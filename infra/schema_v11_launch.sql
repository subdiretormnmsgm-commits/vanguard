-- ════════════════════════════════════════════════════════════════════════════
-- Vanguard V11 — The Sovereign Launch
-- Schema: Predictive Routing + Audit Log
-- Executar no Supabase SQL Editor
-- ════════════════════════════════════════════════════════════════════════════

-- ── 1. Predictive Matches — histórico de sugestões de routing ────────────────
CREATE TABLE IF NOT EXISTS predictive_matches (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lead_id         UUID NOT NULL,
    tenant_id       UUID NOT NULL,
    match_score     NUMERIC(5,2) NOT NULL CHECK (match_score >= 0 AND match_score <= 100),
    nicho_match     BOOLEAN DEFAULT FALSE,
    taxa_conversao  NUMERIC(5,2) DEFAULT 0,
    quota_livre_pct NUMERIC(5,2) DEFAULT 0,
    aceite          BOOLEAN,
    criado_em       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pm_lead_id    ON predictive_matches (lead_id);
CREATE INDEX IF NOT EXISTS idx_pm_tenant_id  ON predictive_matches (tenant_id);
CREATE INDEX IF NOT EXISTS idx_pm_score      ON predictive_matches (match_score DESC);

-- ── 2. Audit Log — registo de todas as operações sensíveis ──────────────────
CREATE TABLE IF NOT EXISTS audit_log (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ts          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    user_id     UUID,
    tenant_id   UUID,
    action      TEXT NOT NULL CHECK (action IN (
                    'login','logout','scraper_trigger','lead_create','lead_update',
                    'arbitrage_list','arbitrage_bid','certifica_emitir',
                    'stripe_webhook','predictive_suggest','incident_create',
                    'api_key_create','api_key_rotate')),
    resource    TEXT,
    ip_address  INET,
    user_agent  TEXT,
    payload     JSONB,
    resultado   TEXT DEFAULT 'ok'
);

CREATE INDEX IF NOT EXISTS idx_al_ts        ON audit_log (ts DESC);
CREATE INDEX IF NOT EXISTS idx_al_tenant_id ON audit_log (tenant_id);
CREATE INDEX IF NOT EXISTS idx_al_action    ON audit_log (action);

-- ── 3. RLS ───────────────────────────────────────────────────────────────────
ALTER TABLE predictive_matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log          ENABLE ROW LEVEL SECURITY;

-- Tenants autenticados vêem os seus próprios matches
CREATE POLICY "tenant_vê_matches" ON predictive_matches
    FOR SELECT TO authenticated
    USING (tenant_id = auth.uid());

-- Service role pode inserir/ler audit_log
CREATE POLICY "service_audit_insert" ON audit_log
    FOR INSERT TO service_role WITH CHECK (true);

CREATE POLICY "service_audit_select" ON audit_log
    FOR SELECT TO service_role USING (true);

-- ── 4. Função: fn_predictive_summary ─────────────────────────────────────────
-- Retorna resumo de performance de routing dos últimos 30 dias
CREATE OR REPLACE FUNCTION fn_predictive_summary()
RETURNS TABLE (
    tenant_id      UUID,
    total_sugestoes BIGINT,
    aceites         BIGINT,
    taxa_aceitacao  NUMERIC,
    score_medio     NUMERIC
) LANGUAGE sql STABLE AS $$
    SELECT
        tenant_id,
        COUNT(*)                                              AS total_sugestoes,
        COUNT(*) FILTER (WHERE aceite = true)                AS aceites,
        ROUND(
            COUNT(*) FILTER (WHERE aceite = true)::NUMERIC /
            NULLIF(COUNT(*), 0) * 100, 1
        )                                                     AS taxa_aceitacao,
        ROUND(AVG(match_score), 2)                           AS score_medio
    FROM predictive_matches
    WHERE criado_em >= NOW() - INTERVAL '30 days'
    GROUP BY tenant_id
    ORDER BY score_medio DESC;
$$;
