-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD V20 — Schema Migrations
-- Monetization Singularity: Stripe Sentinel + Cockpit de Intervenção
-- Executar: Supabase Dashboard → SQL Editor → Run
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. tenant_subscriptions: índice por stripe_sub_id (webhook lookup) ────
CREATE INDEX IF NOT EXISTS idx_tenant_subs_stripe_sub
  ON tenant_subscriptions (stripe_sub_id)
  WHERE stripe_sub_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_tenant_subs_customer
  ON tenant_subscriptions (stripe_customer_id)
  WHERE stripe_customer_id IS NOT NULL;

-- ─── 2. intervention_log: auditoria de intervenções do Cockpit ─────────────
CREATE TABLE IF NOT EXISTS intervention_log (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   TEXT        NOT NULL,
  type        TEXT        NOT NULL,  -- offer_aggressive | offer_discount | consultant_call
  message     TEXT,
  ttl_seconds INTEGER     NOT NULL DEFAULT 86400,
  activated_by TEXT       DEFAULT 'cockpit',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_intervention_log_tenant
  ON intervention_log (tenant_id, created_at DESC);

-- ─── 3. View: cockpit_dashboard — dados agregados para o Painel ────────────
CREATE OR REPLACE VIEW cockpit_dashboard AS
SELECT
  t.id                                              AS tenant_id,
  t.nome,
  t.slug,
  t.dominio,
  t.status,
  t.created_at,

  -- Subscription
  ts.stripe_sub_id                                  AS sub_id,
  ts.status                                         AS sentinel_status,
  ts.current_period_end,

  -- Maturity Score (melhor score da última sessão)
  COALESCE(ms.best_score, 0)                        AS maturity_score,
  ms.last_seen,

  -- MRR contribution
  CASE WHEN ts.status = 'active' THEN 97 ELSE 0 END AS mrr_contribution

FROM tenants t
LEFT JOIN tenant_subscriptions ts
  ON ts.tenant_id = t.id AND ts.status = 'active'
LEFT JOIN LATERAL (
  SELECT
    MAX(maturity_score) AS best_score,
    MAX(last_seen)      AS last_seen
  FROM maturity_scores
  WHERE tenant_id = t.id::uuid
) ms ON true
WHERE t.status = 'active'
ORDER BY ms.best_score DESC NULLS LAST;

-- ─── 4. Função: activar/desactivar intervenção (log + retorna ok) ──────────
CREATE OR REPLACE FUNCTION log_intervention(
  p_tenant_id   TEXT,
  p_type        TEXT,
  p_message     TEXT DEFAULT NULL,
  p_ttl         INTEGER DEFAULT 86400
)
RETURNS UUID LANGUAGE plpgsql AS $$
DECLARE
  v_id UUID;
BEGIN
  INSERT INTO intervention_log (tenant_id, type, message, ttl_seconds)
  VALUES (p_tenant_id, p_type, p_message, p_ttl)
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;

-- ─── 5. Supabase Realtime: activar para cockpit_dashboard ──────────────────
-- Executar após criar as tabelas:
-- ALTER PUBLICATION supabase_realtime ADD TABLE tenants;
-- ALTER PUBLICATION supabase_realtime ADD TABLE tenant_subscriptions;
-- ALTER PUBLICATION supabase_realtime ADD TABLE pixel_events_staging;
-- (descomentar e executar separadamente se necessário)
