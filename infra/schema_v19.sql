-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD V19 — Schema Migrations
-- Resolve dívidas V18 + foundation para Edge Domination
-- Executar: Supabase Dashboard → SQL Editor → Run
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. leads_diagnostico: adicionar metadata JSONB (dívida V18) ──────────
ALTER TABLE leads_diagnostico
  ADD COLUMN IF NOT EXISTS metadata       JSONB,
  ADD COLUMN IF NOT EXISTS email          TEXT,
  ADD COLUMN IF NOT EXISTS revenue_risk   INTEGER,
  ADD COLUMN IF NOT EXISTS quadrant_weak  CHAR(1),
  ADD COLUMN IF NOT EXISTS scores_p       SMALLINT,
  ADD COLUMN IF NOT EXISTS scores_a       SMALLINT,
  ADD COLUMN IF NOT EXISTS scores_c       SMALLINT,
  ADD COLUMN IF NOT EXISTS scores_r       SMALLINT;

-- Índice para queries de quadrante
CREATE INDEX IF NOT EXISTS idx_leads_quadrant_weak
  ON leads_diagnostico (quadrant_weak, created_at DESC);

-- ─── 2. tenant_subscriptions: paywall Neural Sentinel (dívida V18) ────────
CREATE TABLE IF NOT EXISTS tenant_subscriptions (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id           TEXT NOT NULL,
  stripe_customer_id  TEXT,
  stripe_sub_id       TEXT,
  plan                TEXT NOT NULL DEFAULT 'neural_sentinel_97',
  status              TEXT NOT NULL DEFAULT 'active',  -- active | cancelled | past_due
  current_period_end  TIMESTAMPTZ,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tenant_subs_tenant
  ON tenant_subscriptions (tenant_id, status);

-- ─── 3. tenants: registo de instâncias IAH Factory ────────────────────────
CREATE TABLE IF NOT EXISTS tenants (
  id           TEXT PRIMARY KEY,  -- slug-XXXX gerado pelo iah-clone.ps1
  nome         TEXT NOT NULL,
  slug         TEXT NOT NULL UNIQUE,
  nicho        TEXT,
  email        TEXT,
  dominio      TEXT,
  cor_primaria TEXT DEFAULT '#C5A028',
  plano        TEXT DEFAULT 'iah_starter',
  status       TEXT DEFAULT 'active',
  parent_id    TEXT REFERENCES tenants(id),  -- hierarquia franquia → unidade
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tenants_parent
  ON tenants (parent_id) WHERE parent_id IS NOT NULL;

-- ─── 4. maturity_scores: view para Burn Rate Shield §21 ───────────────────
-- Calcula score composto por tenant + session a partir dos eventos do Pixel
CREATE OR REPLACE VIEW maturity_scores AS
SELECT
  tenant_id,
  session_id,
  COUNT(*)                                              AS total_events,
  MAX(created_at)                                       AS last_seen,
  MIN(created_at)                                       AS first_seen,
  EXTRACT(EPOCH FROM (MAX(created_at) - MIN(created_at))) / 60 AS session_minutes,

  -- Score base por intent_level (V17 classification)
  MAX(CASE intent_level
    WHEN 'FIRE' THEN 9.0
    WHEN 'HOT'  THEN 6.0
    WHEN 'WARM' THEN 3.0
    ELSE              1.0
  END)                                                  AS intent_score,

  -- Maturity Score composto (0–10)
  -- 60% intent + 25% session depth + 15% recência (últimas 72h)
  ROUND(
    (
      MAX(CASE intent_level
        WHEN 'FIRE' THEN 9.0
        WHEN 'HOT'  THEN 6.0
        WHEN 'WARM' THEN 3.0
        ELSE              1.0
      END) * 0.60
      +
      LEAST(COUNT(*) / 10.0, 1.0) * 10.0 * 0.25
      +
      CASE WHEN MAX(created_at) > NOW() - INTERVAL '72 hours'
           THEN 10.0 ELSE 3.0 END * 0.15
    )::NUMERIC, 2
  )                                                     AS maturity_score

FROM pixel_events_staging
GROUP BY tenant_id, session_id;

-- ─── 5. RLS: tenant_subscriptions ─────────────────────────────────────────
ALTER TABLE tenant_subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon pode inserir subscrição" ON tenant_subscriptions
  FOR INSERT WITH CHECK (true);

CREATE POLICY "tenant vê a própria subscrição" ON tenant_subscriptions
  FOR SELECT USING (tenant_id = current_setting('app.tenant_id', true));

-- ─── 6. Função: verificar se tenant tem subscrição activa ─────────────────
CREATE OR REPLACE FUNCTION is_sentinel_active(p_tenant_id TEXT)
RETURNS BOOLEAN LANGUAGE sql STABLE AS $$
  SELECT EXISTS (
    SELECT 1 FROM tenant_subscriptions
    WHERE tenant_id = p_tenant_id
      AND status = 'active'
      AND (current_period_end IS NULL OR current_period_end > NOW())
  );
$$;

-- ─── 7. Trigger: updated_at automático ────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$;

DROP TRIGGER IF EXISTS tenant_subs_updated_at ON tenant_subscriptions;
CREATE TRIGGER tenant_subs_updated_at
  BEFORE UPDATE ON tenant_subscriptions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
