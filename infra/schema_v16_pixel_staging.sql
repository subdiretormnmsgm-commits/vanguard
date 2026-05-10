-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD TECH — Pixel Staging Schema V16
-- "Visual Authority & Lock-in Foundation"
-- Dois sistemas: Pixel Staging (absorsão massiva) + RLS Apagão Técnico
-- Executar no SQL Editor do Supabase
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. PIXEL EVENTS STAGING (UNLOGGED — Alta Performance) ───────────────────
-- UNLOGGED: sem WAL write → 3-5x mais rápido que tabela normal.
-- Perfeito para volume massivo de eventos de pixel.
-- Em crash, a tabela fica vazia — mas os dados são consolidados em pixel_stats_daily.
CREATE UNLOGGED TABLE IF NOT EXISTS pixel_events_staging (
  id            bigserial       PRIMARY KEY,
  -- Identidade do pixel instalado
  pixel_id      uuid            NOT NULL,        -- UUID único do pixel instalado no site cliente
  tenant_id     uuid            NOT NULL,        -- Tenant (agência) que instalou o pixel
  site_domain   text            NOT NULL,        -- Domínio onde o pixel está instalado

  -- Dados do visitante (anonimizados — conformidade RGPD)
  session_hash  text            NOT NULL,        -- SHA-256(ip + user_agent + date) — irreversível
  country_code  char(2),                         -- 2-letter ISO (PT, BR, US...)
  device_type   text            CHECK (device_type IN ('mobile','desktop','tablet','bot')),
  referrer_host text,                            -- domínio de referência (sem path/query)

  -- Dados de intenção (o coração do Lock-in)
  event_type    text            NOT NULL,        -- 'pageview' | 'scroll_50' | 'scroll_90' | 'time_30s'
                                                 -- | 'cta_hover' | 'cta_click' | 'form_start'
                                                 -- | 'form_submit' | 'exit_intent' | 'rage_click'
  page_path     text,                            -- path relativo da página (/sobre, /precos, ...)
  time_on_page  smallint,                        -- segundos na página (máx 32767)
  scroll_depth  smallint,                        -- % de scroll (0-100)

  -- Sinal de intenção derivado (calculado no edge antes de inserir)
  intent_score  numeric(4,2)    CHECK (intent_score BETWEEN 0 AND 10),
  intent_label  text            CHECK (intent_label IN (
                  'COLD','WARM','HOT','FIRE',    -- frio → compra iminente
                  'CHURN_RISK','RETURNING'        -- sinais de fuga e retorno
                )),

  -- Timestamp (precisão de ms para ordenação em alto volume)
  fired_at      timestamptz     NOT NULL DEFAULT now()
);

-- Índices críticos para queries de agregação diária (pg_cron)
CREATE INDEX IF NOT EXISTS idx_pixel_staging_tenant   ON pixel_events_staging (tenant_id, fired_at DESC);
CREATE INDEX IF NOT EXISTS idx_pixel_staging_domain   ON pixel_events_staging (site_domain, fired_at DESC);
CREATE INDEX IF NOT EXISTS idx_pixel_staging_intent   ON pixel_events_staging (intent_label, fired_at DESC);
CREATE INDEX IF NOT EXISTS idx_pixel_staging_pixel    ON pixel_events_staging (pixel_id);
CREATE INDEX IF NOT EXISTS idx_pixel_staging_fired    ON pixel_events_staging (fired_at DESC);

-- ─── 2. PIXEL STATS DAILY (UNLOGGED — Agregação Diária) ──────────────────────
-- Consolida pixel_events_staging em granularidade diária.
-- pg_cron agrega cada hora e descarta eventos > 48h do staging.
CREATE UNLOGGED TABLE IF NOT EXISTS pixel_stats_daily (
  id            bigserial       PRIMARY KEY,
  tenant_id     uuid            NOT NULL,
  site_domain   text            NOT NULL,
  stat_date     date            NOT NULL DEFAULT CURRENT_DATE,

  -- Volume
  total_events  int             NOT NULL DEFAULT 0,
  unique_sessions int           NOT NULL DEFAULT 0,
  pageviews     int             NOT NULL DEFAULT 0,

  -- Intenção agregada
  hot_sessions  int             NOT NULL DEFAULT 0,    -- intent_label IN ('HOT','FIRE')
  fire_sessions int             NOT NULL DEFAULT 0,    -- intent_label = 'FIRE' (compra iminente)
  churn_signals int             NOT NULL DEFAULT 0,    -- intent_label = 'CHURN_RISK'

  -- Score médio de intenção do dia
  avg_intent_score numeric(4,2),

  -- Dispositivos
  mobile_pct    numeric(5,2),
  desktop_pct   numeric(5,2),

  -- Top referrer do dia
  top_referrer  text,

  computed_at   timestamptz     NOT NULL DEFAULT now(),

  UNIQUE (tenant_id, site_domain, stat_date)
);

CREATE INDEX IF NOT EXISTS idx_pixel_stats_tenant  ON pixel_stats_daily (tenant_id, stat_date DESC);
CREATE INDEX IF NOT EXISTS idx_pixel_stats_domain  ON pixel_stats_daily (site_domain, stat_date DESC);
CREATE INDEX IF NOT EXISTS idx_pixel_stats_fire    ON pixel_stats_daily (fire_sessions DESC, stat_date DESC);

-- ─── 3. PIXEL REGISTRY (tabela normal — metadata dos pixels instalados) ───────
-- Esta SIM vai ao WAL — é configuração, não volume.
CREATE TABLE IF NOT EXISTS pixel_registry (
  id            uuid            PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     uuid            NOT NULL,        -- dono do pixel
  site_domain   text            NOT NULL,        -- domínio autorizado
  pixel_token   text            NOT NULL UNIQUE DEFAULT encode(gen_random_bytes(24), 'hex'),
  label         text,                            -- nome amigável ("Site Principal", "Blog")
  is_active     boolean         NOT NULL DEFAULT true,
  installed_at  timestamptz     NOT NULL DEFAULT now(),
  last_ping_at  timestamptz,                     -- último evento recebido
  total_events  bigint          NOT NULL DEFAULT 0,

  UNIQUE (tenant_id, site_domain)
);

ALTER TABLE pixel_registry ENABLE ROW LEVEL SECURITY;

-- Tenant lê e gere apenas os seus pixels
CREATE POLICY "pixel_registry_tenant_access"
  ON pixel_registry FOR ALL TO authenticated
  USING (
    tenant_id IN (
      SELECT id FROM tenants
      WHERE owner_id = auth.uid()
      AND suspended = false          -- ← APAGÃO: tenant suspenso não vê os seus pixels
    )
  )
  WITH CHECK (
    tenant_id IN (
      SELECT id FROM tenants
      WHERE owner_id = auth.uid()
      AND suspended = false
    )
  );

-- ─── 4. RLS STATE ENFORCEMENT — "APAGÃO TÉCNICO" ─────────────────────────────
-- Princípio: tenant com suspended=true perde acesso instantâneo a TODOS os dados.
-- A inadimplência é tecnicamente punida sem intervenção manual.

-- Função utilitária reutilizável: verifica se o tenant do utilizador está activo
CREATE OR REPLACE FUNCTION fn_tenant_is_active() RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM tenants
    WHERE owner_id = auth.uid()
    AND suspended = false
  );
$$;

-- RLS Apagão em leads_diagnostico
ALTER TABLE leads_diagnostico ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "leads_tenant_active_only" ON leads_diagnostico;
CREATE POLICY "leads_tenant_active_only"
  ON leads_diagnostico FOR ALL TO authenticated
  USING (fn_tenant_is_active())
  WITH CHECK (fn_tenant_is_active());

-- RLS Apagão em agent_jobs
ALTER TABLE agent_jobs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "director_full_access" ON agent_jobs;
CREATE POLICY "agent_jobs_active_tenant"
  ON agent_jobs FOR ALL TO authenticated
  USING (fn_tenant_is_active())
  WITH CHECK (fn_tenant_is_active());

-- RLS Apagão em hermes_variants (Hive Mind)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'hermes_variants') THEN
    ALTER TABLE hermes_variants ENABLE ROW LEVEL SECURITY;
    DROP POLICY IF EXISTS "hermes_active_tenant" ON hermes_variants;
    CREATE POLICY "hermes_active_tenant"
      ON hermes_variants FOR ALL TO authenticated
      USING (fn_tenant_is_active())
      WITH CHECK (fn_tenant_is_active());
  END IF;
END $$;

-- ─── 5. TENANTS — COLUNA suspended (se ainda não existir) ────────────────────
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS suspended boolean NOT NULL DEFAULT false;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS suspended_at timestamptz;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS suspension_reason text;

-- Índice para o fn_tenant_is_active() não fazer seq scan em tenants grandes
CREATE INDEX IF NOT EXISTS idx_tenants_owner_active ON tenants (owner_id, suspended);

-- ─── 6. FUNÇÃO: SUSPENDER TENANT (chamada pelo webhook Stripe de falha de pagto) ──
CREATE OR REPLACE FUNCTION fn_suspend_tenant(p_tenant_id uuid, p_reason text DEFAULT 'Pagamento em falta')
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE tenants
  SET
    suspended          = true,
    suspended_at       = now(),
    suspension_reason  = p_reason
  WHERE id = p_tenant_id;

  -- Log no audit_log
  INSERT INTO audit_log (tenant_id, action, actor, metadata)
  VALUES (
    p_tenant_id,
    'TENANT_SUSPENDED',
    'system',
    jsonb_build_object('reason', p_reason, 'suspended_at', now())
  );
END;
$$;

-- Função inversa: reactivar após pagamento confirmado
CREATE OR REPLACE FUNCTION fn_reactivate_tenant(p_tenant_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE tenants
  SET
    suspended         = false,
    suspended_at      = NULL,
    suspension_reason = NULL
  WHERE id = p_tenant_id;

  INSERT INTO audit_log (tenant_id, action, actor, metadata)
  VALUES (
    p_tenant_id,
    'TENANT_REACTIVATED',
    'stripe_webhook',
    jsonb_build_object('reactivated_at', now())
  );
END;
$$;

-- ─── 7. pg_cron: CONSOLIDAÇÃO HORÁRIA DO STAGING ─────────────────────────────
-- Requer extensão pg_cron activada no Supabase Pro
SELECT cron.schedule(
  'pixel-staging-consolidate',
  '5 * * * *',  -- 5 minutos após cada hora
  $$
    -- Agrega eventos da última hora para pixel_stats_daily
    INSERT INTO pixel_stats_daily (
      tenant_id, site_domain, stat_date,
      total_events, unique_sessions, pageviews,
      hot_sessions, fire_sessions, churn_signals,
      avg_intent_score, mobile_pct, desktop_pct, top_referrer
    )
    SELECT
      tenant_id,
      site_domain,
      CURRENT_DATE,
      COUNT(*)                                                          AS total_events,
      COUNT(DISTINCT session_hash)                                      AS unique_sessions,
      COUNT(*) FILTER (WHERE event_type = 'pageview')                  AS pageviews,
      COUNT(DISTINCT session_hash) FILTER (WHERE intent_label IN ('HOT','FIRE')) AS hot_sessions,
      COUNT(DISTINCT session_hash) FILTER (WHERE intent_label = 'FIRE') AS fire_sessions,
      COUNT(DISTINCT session_hash) FILTER (WHERE intent_label = 'CHURN_RISK') AS churn_signals,
      ROUND(AVG(intent_score), 2)                                       AS avg_intent_score,
      ROUND(100.0 * COUNT(*) FILTER (WHERE device_type = 'mobile') / NULLIF(COUNT(*),0), 2) AS mobile_pct,
      ROUND(100.0 * COUNT(*) FILTER (WHERE device_type = 'desktop') / NULLIF(COUNT(*),0), 2) AS desktop_pct,
      (SELECT referrer_host FROM pixel_events_staging p2
       WHERE p2.tenant_id = p.tenant_id AND p2.site_domain = p.site_domain
         AND p2.referrer_host IS NOT NULL
         AND p2.fired_at > now() - INTERVAL '1 hour'
       GROUP BY referrer_host ORDER BY count(*) DESC LIMIT 1)           AS top_referrer
    FROM pixel_events_staging p
    WHERE fired_at > now() - INTERVAL '1 hour'
    GROUP BY tenant_id, site_domain
    ON CONFLICT (tenant_id, site_domain, stat_date)
    DO UPDATE SET
      total_events      = pixel_stats_daily.total_events + EXCLUDED.total_events,
      unique_sessions   = pixel_stats_daily.unique_sessions + EXCLUDED.unique_sessions,
      pageviews         = pixel_stats_daily.pageviews + EXCLUDED.pageviews,
      hot_sessions      = pixel_stats_daily.hot_sessions + EXCLUDED.hot_sessions,
      fire_sessions     = pixel_stats_daily.fire_sessions + EXCLUDED.fire_sessions,
      churn_signals     = pixel_stats_daily.churn_signals + EXCLUDED.churn_signals,
      avg_intent_score  = ROUND((pixel_stats_daily.avg_intent_score + EXCLUDED.avg_intent_score) / 2, 2),
      computed_at       = now();

    -- Limpar eventos com mais de 48h do staging (já consolidados)
    DELETE FROM pixel_events_staging WHERE fired_at < now() - INTERVAL '48 hours';
  $$
);

-- ─── 8. VIEW OPERACIONAL: PIXEL DASHBOARD ────────────────────────────────────
CREATE OR REPLACE VIEW v_pixel_dashboard AS
SELECT
  pr.tenant_id,
  pr.site_domain,
  pr.label,
  pr.is_active,
  pr.last_ping_at,
  pr.total_events,
  -- Hoje
  COALESCE(today.total_events, 0)     AS today_events,
  COALESCE(today.unique_sessions, 0)  AS today_sessions,
  COALESCE(today.fire_sessions, 0)    AS today_fire,
  COALESCE(today.avg_intent_score, 0) AS today_avg_intent,
  -- Ontem (para comparação)
  COALESCE(yest.total_events, 0)      AS yesterday_events,
  COALESCE(yest.fire_sessions, 0)     AS yesterday_fire,
  -- Delta % de sessões fire
  CASE
    WHEN COALESCE(yest.fire_sessions, 0) = 0 THEN NULL
    ELSE ROUND(100.0 * (COALESCE(today.fire_sessions,0) - yest.fire_sessions) / yest.fire_sessions, 1)
  END AS fire_delta_pct
FROM pixel_registry pr
LEFT JOIN pixel_stats_daily today
  ON today.tenant_id = pr.tenant_id AND today.site_domain = pr.site_domain AND today.stat_date = CURRENT_DATE
LEFT JOIN pixel_stats_daily yest
  ON yest.tenant_id  = pr.tenant_id AND yest.site_domain  = pr.site_domain AND yest.stat_date = CURRENT_DATE - 1
WHERE pr.is_active = true
ORDER BY today.fire_sessions DESC NULLS LAST;

-- ─── FIM DO SCHEMA V16 ────────────────────────────────────────────────────────
-- Checklist de execução:
-- [ ] Activar pg_cron no Supabase (Settings → Extensions)
-- [ ] Verificar que coluna tenants.suspended foi criada sem erros
-- [ ] Confirmar que fn_tenant_is_active() retorna false para tenants suspensos
-- [ ] Testar RLS: criar tenant suspenso e verificar acesso negado a leads_diagnostico
-- [ ] Activar cron pixel-staging-consolidate após validação do schema
-- [ ] Criar bucket 'pixels' no Supabase Storage para pixel.js servido via CDN
