-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD V8 — Intelligence API + Fractal White-Label
-- Execute no Supabase → SQL Editor (após schema_v7_marketplace.sql)
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. API KEYS (Auth para /v1/intelligence/) ────────────────────────────────
CREATE TABLE IF NOT EXISTS api_keys (
  id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid        REFERENCES auth.users(id) ON DELETE CASCADE,
  tenant_id     uuid        REFERENCES tenants(id) ON DELETE CASCADE,
  nome          text        NOT NULL,
  key_hash      text        NOT NULL UNIQUE,  -- SHA-256 da key real
  key_prefix    text        NOT NULL,         -- vng_live_xxxx (primeiros 12 chars)
  plano         text        NOT NULL DEFAULT 'free'
                            CHECK (plano IN ('free','starter','pro','enterprise')),
  requests_mes  int         NOT NULL DEFAULT 0,
  limite_mes    int         NOT NULL DEFAULT 1000, -- free: 1000, pro: 50000
  ativo         boolean     NOT NULL DEFAULT true,
  ultimo_uso_em timestamptz,
  expires_at    timestamptz,
  created_at    timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_api_keys_prefix ON api_keys (key_prefix);
CREATE INDEX IF NOT EXISTS idx_api_keys_tenant ON api_keys (tenant_id);

-- ─── 2. API USAGE LOGS ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS api_usage_logs (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  key_id      uuid        REFERENCES api_keys(id) ON DELETE CASCADE,
  endpoint    text        NOT NULL,
  params      jsonb       DEFAULT '{}',
  status_code int         NOT NULL DEFAULT 200,
  latencia_ms int,
  created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_usage_key_date ON api_usage_logs (key_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_usage_endpoint  ON api_usage_logs (endpoint, created_at DESC);

-- ─── 3. SUB-TENANTS (Fractal White-Label) ────────────────────────────────────
CREATE TABLE IF NOT EXISTS sub_tenants (
  id                uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_tenant_id  uuid          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  nome              text          NOT NULL,
  email             text          NOT NULL,
  -- Quota derivada do parent (parent cede parte da sua quota)
  leads_quota       int           NOT NULL DEFAULT 50,
  leads_usados      int           NOT NULL DEFAULT 0,
  -- White-Label brand config
  brand_config      jsonb         NOT NULL DEFAULT '{
    "nome": "Agência",
    "primary": "#00F0FF",
    "secondary": "#1A0B2E",
    "accent": "#7B2FFF",
    "bg": "#0A0A0A",
    "logo_url": ""
  }',
  -- Stripe (sub-tenant paga ao parent, não à plataforma directamente)
  preco_cobrado     numeric(10,2) DEFAULT 0,  -- o que o parent cobra ao sub
  stripe_customer_id text,
  ativo             boolean       NOT NULL DEFAULT true,
  created_at        timestamptz   NOT NULL DEFAULT now(),
  updated_at        timestamptz   NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_sub_tenants_parent ON sub_tenants (parent_tenant_id);

-- ─── 4. MATERIALIZED VIEWS para Intelligence API ─────────────────────────────

-- 4a. Stats por nicho (actualizada a cada hora)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_intelligence_nicho AS
SELECT
  ld.nicho                                    AS nicho,
  COUNT(*)                                    AS total_leads,
  ROUND(AVG(ld.score_digital)::numeric, 2)   AS score_medio,
  ROUND(
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ld.score_digital)::numeric, 2
  )                                           AS score_mediana,
  COUNT(*) FILTER (WHERE ld.score_digital >= 7) AS leads_alta_qualidade,
  COUNT(*) FILTER (WHERE ld.ai_hook != '')   AS leads_com_ia_hook,
  ROUND(
    COUNT(*) FILTER (WHERE ld.ai_hook != '')::numeric /
    NULLIF(COUNT(*), 0) * 100, 1
  )                                           AS pct_com_ia,
  MAX(ld.created_at)                          AS ultimo_lead_em,
  DATE_TRUNC('month', NOW())                  AS referencia_mes
FROM leads_diagnostico ld
WHERE ld.nicho IS NOT NULL AND ld.score_digital IS NOT NULL
GROUP BY ld.nicho;

CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_nicho ON mv_intelligence_nicho (nicho);

-- 4b. Tendências por cidade/nicho (últimos 30 dias)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_intelligence_tendencias AS
SELECT
  ld.nicho,
  ld.cidade,
  COUNT(*)                                  AS leads_30d,
  ROUND(AVG(ld.score_digital)::numeric, 2) AS score_medio,
  MAX(ld.created_at)                        AS ultimo_em,
  DATE_TRUNC('day', NOW())                  AS referencia_dia
FROM leads_diagnostico ld
WHERE
  ld.created_at >= NOW() - INTERVAL '30 days'
  AND ld.nicho   IS NOT NULL
  AND ld.cidade  IS NOT NULL
GROUP BY ld.nicho, ld.cidade
ORDER BY leads_30d DESC;

CREATE INDEX IF NOT EXISTS idx_mv_tend_nicho ON mv_intelligence_tendencias (nicho, leads_30d DESC);

-- 4c. Score de maturidade digital por empresa (para lookup)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_intelligence_empresas AS
SELECT
  LOWER(TRIM(ld.nome))  AS nome_normalizado,
  ld.nicho,
  ld.cidade,
  MAX(ld.score_digital) AS score_digital,
  MAX(ld.gargalo)       AS gargalo_principal,
  MAX(ld.created_at)    AS indexado_em
FROM leads_diagnostico ld
WHERE ld.score_digital IS NOT NULL
GROUP BY LOWER(TRIM(ld.nome)), ld.nicho, ld.cidade;

CREATE INDEX IF NOT EXISTS idx_mv_empresas_nome ON mv_intelligence_empresas (nome_normalizado);

-- ─── 5. FUNÇÃO: Refresh das Materialized Views ────────────────────────────────
CREATE OR REPLACE FUNCTION fn_refresh_intelligence_views()
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_intelligence_nicho;
  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_intelligence_tendencias;
  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_intelligence_empresas;
END;
$$;

-- ─── 6. TRIGGER: Incrementar requests_mes ao usar API key ────────────────────
CREATE OR REPLACE FUNCTION fn_incrementar_api_usage()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE api_keys
  SET
    requests_mes  = requests_mes + 1,
    ultimo_uso_em = NOW()
  WHERE id = NEW.key_id;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_api_usage ON api_usage_logs;
CREATE TRIGGER trg_api_usage
  AFTER INSERT ON api_usage_logs
  FOR EACH ROW EXECUTE FUNCTION fn_incrementar_api_usage();

-- ─── 7. TRIGGER: Sub-tenant — quota derivada do parent ───────────────────────
CREATE OR REPLACE FUNCTION fn_quota_sub_tenant()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Quando sub-tenant usa lead, decrementa quota do parent também
  IF NEW.leads_usados > OLD.leads_usados THEN
    UPDATE tenants
    SET leads_usados = leads_usados + 1,
        updated_at   = NOW()
    WHERE id = NEW.parent_tenant_id;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_sub_quota ON sub_tenants;
CREATE TRIGGER trg_sub_quota
  AFTER UPDATE ON sub_tenants
  FOR EACH ROW
  WHEN (NEW.leads_usados > OLD.leads_usados)
  EXECUTE FUNCTION fn_quota_sub_tenant();

-- ─── 8. ROW LEVEL SECURITY ────────────────────────────────────────────────────

ALTER TABLE api_keys       ENABLE ROW LEVEL SECURITY;
ALTER TABLE sub_tenants    ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_usage_logs ENABLE ROW LEVEL SECURITY;

-- API Keys: dono vê as suas
CREATE POLICY "api_keys_ver_proprio"
  ON api_keys FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "api_keys_inserir_proprio"
  ON api_keys FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Sub-tenants: parent vê os seus
CREATE POLICY "sub_tenants_ver_proprio"
  ON sub_tenants FOR SELECT TO authenticated
  USING (
    parent_tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid())
  );

CREATE POLICY "sub_tenants_criar"
  ON sub_tenants FOR INSERT TO authenticated
  WITH CHECK (
    parent_tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid())
  );

CREATE POLICY "sub_tenants_update"
  ON sub_tenants FOR UPDATE TO authenticated
  USING (parent_tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()))
  WITH CHECK (parent_tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()));

-- Usage logs: dono da key vê os seus
CREATE POLICY "usage_logs_ver_proprio"
  ON api_usage_logs FOR SELECT TO authenticated
  USING (key_id IN (SELECT id FROM api_keys WHERE user_id = auth.uid()));

-- ─── 9. GRANTS ────────────────────────────────────────────────────────────────
GRANT SELECT, INSERT, UPDATE ON api_keys        TO service_role;
GRANT SELECT, INSERT         ON api_usage_logs  TO service_role;
GRANT SELECT, INSERT, UPDATE ON sub_tenants     TO service_role;
GRANT SELECT ON mv_intelligence_nicho           TO service_role, anon, authenticated;
GRANT SELECT ON mv_intelligence_tendencias      TO service_role, anon, authenticated;
GRANT SELECT ON mv_intelligence_empresas        TO service_role;

-- ─── 10. COMENTÁRIOS ──────────────────────────────────────────────────────────
COMMENT ON TABLE api_keys    IS 'API keys para Vanguard Intelligence API v1. Planos: free(1k/mês), pro(50k/mês). Hash SHA-256.';
COMMENT ON TABLE sub_tenants IS 'Fractal White-Label: tenants Pro podem criar sub-tenants com brand_config própria. Quota partilhada do parent.';
COMMENT ON MATERIALIZED VIEW mv_intelligence_nicho IS 'Stats de maturidade digital por nicho. Refresh horário via fn_refresh_intelligence_views().';
