-- ══════════════════════════════════════════════════════════════════════════
-- VANGUARD V10 — The Sovereign Fortress
-- Executar no Supabase SQL Editor
-- Schema: Health Monitoring · Incident Management · Stress Tests
-- ══════════════════════════════════════════════════════════════════════════

-- ── 1. system_incidents — Torre de Controlo ───────────────────────────────
CREATE TABLE IF NOT EXISTS system_incidents (
    id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    severidade    TEXT        NOT NULL CHECK (severidade IN ('critical', 'high', 'medium', 'low')),
    servico       TEXT        NOT NULL CHECK (servico IN ('api', 'supabase', 'stripe', 'anthropic', 'vapi', 'n8n', 'nginx', 'outro')),
    titulo        TEXT        NOT NULL,
    descricao     TEXT,
    stack_trace   TEXT,
    resolucao     TEXT,
    status        TEXT        NOT NULL DEFAULT 'open'
                  CHECK (status IN ('open', 'investigating', 'resolved', 'closed')),
    diagnostico_ia TEXT,
    detectado_em  TIMESTAMPTZ DEFAULT NOW(),
    resolvido_em  TIMESTAMPTZ,
    notificado_em TIMESTAMPTZ,
    created_at    TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE system_incidents IS
    'V10: Registo de incidentes com diagnóstico autónomo do IA Firefighter (Claude Haiku)';

-- ── 2. health_checks_log — Log de verificações periódicas ─────────────────
CREATE TABLE IF NOT EXISTS health_checks_log (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    servico     TEXT        NOT NULL,
    status      TEXT        NOT NULL CHECK (status IN ('healthy', 'degraded', 'down')),
    latencia_ms INTEGER,
    http_code   INTEGER,
    detalhes    JSONB,
    checked_at  TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE health_checks_log IS
    'V10: Log de health checks periódicos por serviço — base para alertas automáticos';

-- ── 3. stress_test_results — Director Protocol ────────────────────────────
CREATE TABLE IF NOT EXISTS stress_test_results (
    id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    total_requests INTEGER     NOT NULL,
    success_count  INTEGER     NOT NULL,
    error_count    INTEGER     NOT NULL DEFAULT 0,
    p50_ms         FLOAT,
    p95_ms         FLOAT,
    p99_ms         FLOAT,
    taxa_sucesso   FLOAT       GENERATED ALWAYS AS (
                       ROUND((success_count::FLOAT / NULLIF(total_requests, 0) * 100)::NUMERIC, 1)
                   ) STORED,
    ran_at         TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE stress_test_results IS
    'V10: Resultados do Director Stress Test (1000 leads simultâneos)';

-- ── RLS ───────────────────────────────────────────────────────────────────
ALTER TABLE system_incidents    ENABLE ROW LEVEL SECURITY;
ALTER TABLE health_checks_log   ENABLE ROW LEVEL SECURITY;
ALTER TABLE stress_test_results ENABLE ROW LEVEL SECURITY;

-- Authenticated users podem ler; service_role pode escrever via API
CREATE POLICY "incidents_select" ON system_incidents
    FOR SELECT TO authenticated USING (true);

CREATE POLICY "incidents_insert" ON system_incidents
    FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "incidents_update" ON system_incidents
    FOR UPDATE TO authenticated USING (true);

CREATE POLICY "health_select" ON health_checks_log
    FOR SELECT TO authenticated USING (true);

CREATE POLICY "stress_select" ON stress_test_results
    FOR SELECT TO authenticated USING (true);

-- ── Índices ───────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_incidents_detectado
    ON system_incidents (detectado_em DESC);

CREATE INDEX IF NOT EXISTS idx_incidents_status_sev
    ON system_incidents (status, severidade);

CREATE INDEX IF NOT EXISTS idx_health_checked
    ON health_checks_log (checked_at DESC);

CREATE INDEX IF NOT EXISTS idx_health_servico
    ON health_checks_log (servico, checked_at DESC);

CREATE INDEX IF NOT EXISTS idx_stress_ran
    ON stress_test_results (ran_at DESC);

-- ── Função auxiliar: resumo de saúde ─────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_health_summary()
RETURNS TABLE (
    servico      TEXT,
    ultimo_status TEXT,
    avg_latencia  FLOAT,
    checks_24h    BIGINT
) LANGUAGE sql STABLE AS $$
    SELECT
        servico,
        (ARRAY_AGG(status ORDER BY checked_at DESC))[1] AS ultimo_status,
        ROUND(AVG(latencia_ms)::NUMERIC, 1)             AS avg_latencia,
        COUNT(*)                                         AS checks_24h
    FROM health_checks_log
    WHERE checked_at >= NOW() - INTERVAL '24 hours'
    GROUP BY servico
    ORDER BY servico;
$$;

COMMENT ON FUNCTION fn_health_summary IS
    'V10: Resumo de saúde por serviço nas últimas 24h';
