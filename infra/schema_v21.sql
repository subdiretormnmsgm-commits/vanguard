-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD V21 — Schema Migrations
-- Market Consciousness: Sentinel Report Card + Dízimo de Dados + Hermes Bridge
-- Executar: Supabase Dashboard → SQL Editor → Run
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. sentinel_report_log: auditoria de relatórios enviados ─────────────
CREATE TABLE IF NOT EXISTS sentinel_report_log (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       TEXT        NOT NULL,
  semana_inicio   DATE        NOT NULL,
  fire_count      INTEGER     NOT NULL DEFAULT 0,
  hot_count       INTEGER     NOT NULL DEFAULT 0,
  warm_count      INTEGER     NOT NULL DEFAULT 0,
  revenue_risk    INTEGER     NOT NULL DEFAULT 0,
  email_enviado   BOOLEAN     NOT NULL DEFAULT FALSE,
  email_destino   TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_report_log_tenant
  ON sentinel_report_log (tenant_id, semana_inicio DESC);

CREATE UNIQUE INDEX IF NOT EXISTS idx_report_log_unique_week
  ON sentinel_report_log (tenant_id, semana_inicio);

-- ─── 2. global_intent_graph: Dízimo de Dados cross-tenant ─────────────────
-- Recebe 15% dos eventos FIRE de instâncias IAH com intent_share: true
-- Fundação silenciosa do Oráculo B2B (Acto III)
CREATE TABLE IF NOT EXISTS global_intent_graph (
  id              BIGSERIAL   PRIMARY KEY,
  source_tenant   TEXT        NOT NULL,      -- tenant_id de origem (anonimizado após 30d)
  nicho           TEXT,
  geo_region      TEXT,                      -- estado/cidade (do site_domain)
  intent_label    TEXT        NOT NULL DEFAULT 'FIRE',
  session_count   INTEGER     NOT NULL DEFAULT 1,
  week_bucket     DATE        NOT NULL,      -- semana de agregação (segunda-feira)
  aggregated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_global_intent_nicho_week
  ON global_intent_graph (nicho, week_bucket DESC);

CREATE INDEX IF NOT EXISTS idx_global_intent_region
  ON global_intent_graph (geo_region, week_bucket DESC);

-- ─── 3. Função: agregar dízimo de dados semanal ───────────────────────────
-- Chamada pelo pg_cron toda segunda-feira às 07:00 BRT
-- Agrega 15% dos eventos FIRE da semana anterior por tenant com intent_share
CREATE OR REPLACE FUNCTION aggregate_intent_tithe()
RETURNS INTEGER LANGUAGE plpgsql AS $$
DECLARE
  v_count INTEGER := 0;
  v_week  DATE := DATE_TRUNC('week', NOW() - INTERVAL '7 days')::DATE;
BEGIN
  INSERT INTO global_intent_graph (source_tenant, nicho, intent_label, session_count, week_bucket)
  SELECT
    pes.tenant_id::TEXT                           AS source_tenant,
    t.nicho,
    pes.intent_label,
    CEIL(COUNT(*) * 0.15)::INTEGER                AS session_count,  -- 15% arredondado
    v_week
  FROM pixel_events_staging pes
  JOIN tenants t ON t.id::text = pes.tenant_id::text
  WHERE
    pes.intent_label IN ('FIRE', 'HOT')
    AND pes.fired_at >= v_week
    AND pes.fired_at < v_week + INTERVAL '7 days'
    AND t.status = 'active'
    -- Apenas tenants com intent_share activado (metadata JSONB)
    AND (t.metadata->>'intent_share')::boolean IS TRUE
  GROUP BY pes.tenant_id, t.nicho, pes.intent_label
  ON CONFLICT DO NOTHING;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END;
$$;

-- ─── 4. tenants: adicionar colunas V21 ────────────────────────────────────
ALTER TABLE tenants
  ADD COLUMN IF NOT EXISTS metadata         JSONB,     -- intent_share, dataTithe
  ADD COLUMN IF NOT EXISTS hermes_auto_mode BOOLEAN NOT NULL DEFAULT FALSE;

-- ─── 5. hermes_voice_triggers: fila de chamadas autorizadas ───────────────
CREATE TABLE IF NOT EXISTS hermes_voice_triggers (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       TEXT        NOT NULL,
  session_hash    TEXT        NOT NULL,
  maturity_score  NUMERIC(4,2) NOT NULL,
  last_seen       TIMESTAMPTZ,
  status          TEXT        NOT NULL DEFAULT 'pending',
  -- pending | authorized | dispatched | completed | cancelled
  auto_call       BOOLEAN     NOT NULL DEFAULT FALSE,
  authorized_at   TIMESTAMPTZ,
  dispatched_at   TIMESTAMPTZ,
  call_record_id  UUID,        -- FK para hermes_voice_calls
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_hermes_triggers_tenant_status
  ON hermes_voice_triggers (tenant_id, status, maturity_score DESC);

CREATE UNIQUE INDEX IF NOT EXISTS idx_hermes_triggers_session
  ON hermes_voice_triggers (tenant_id, session_hash)
  WHERE status IN ('pending', 'authorized');

-- ─── 6. pg_cron: agendar envio semanal e dízimo ──────────────────────────
-- IMPORTANTE: pg_cron precisa de estar activado no Supabase (Extensions → pg_cron)
-- Descomentare executar separadamente após activar a extensão:

-- Segunda-feira 08:00 BRT (11:00 UTC) — envio de relatórios semanais
-- SELECT cron.schedule(
--   'sentinel-weekly-report',
--   '0 11 * * 1',
--   $$SELECT net.http_post(
--     'https://vanguard.tech/api/sentinel/report/send-weekly',
--     '{}',
--     headers:='{"Authorization":"Bearer " || current_setting("app.cron_secret")}'::jsonb
--   )$$
-- );

-- Segunda-feira 07:00 BRT (10:00 UTC) — dízimo de dados
-- SELECT cron.schedule(
--   'intent-tithe-weekly',
--   '0 10 * * 1',
--   'SELECT aggregate_intent_tithe()'
-- );

-- A cada hora — Hermes Bridge check
-- SELECT cron.schedule(
--   'hermes-trigger-check',
--   '0 * * * *',
--   $$SELECT net.http_post(
--     'https://vanguard.tech/api/hermes-trigger/check-all',
--     '{}',
--     headers:='{"Authorization":"Bearer " || current_setting("app.cron_secret")}'::jsonb
--   )$$
-- );

-- ─── 7. View: intent_graph_summary — resumo para o Oráculo B2B ────────────
CREATE OR REPLACE VIEW intent_graph_summary AS
SELECT
  nicho,
  geo_region,
  week_bucket,
  SUM(CASE intent_label WHEN 'FIRE' THEN session_count ELSE 0 END) AS fire_total,
  SUM(CASE intent_label WHEN 'HOT'  THEN session_count ELSE 0 END) AS hot_total,
  COUNT(DISTINCT source_tenant)                                      AS tenant_count
FROM global_intent_graph
WHERE week_bucket >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY nicho, geo_region, week_bucket
ORDER BY week_bucket DESC, fire_total DESC;
