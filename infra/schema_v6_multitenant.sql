-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD V6 — SaaS Multi-Tenant: Migração Completa
-- Execute no Supabase → SQL Editor (na ordem exacta abaixo)
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. TABELA DE TENANTS ─────────────────────────────────────────────────────
-- Cada agência/cliente é um tenant isolado
CREATE TABLE IF NOT EXISTS tenants (
  id                    uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  nome                  text        NOT NULL,
  email                 text        NOT NULL,
  plano                 text        NOT NULL DEFAULT 'starter'
                                    CHECK (plano IN ('starter','pro','enterprise','trial')),
  leads_quota           int         NOT NULL DEFAULT 100,
  leads_usados          int         NOT NULL DEFAULT 0,
  ciclo_reset_em        timestamptz NOT NULL DEFAULT (now() + interval '30 days'),
  stripe_customer_id    text,
  stripe_subscription_id text,
  stripe_status         text        DEFAULT 'inactive'
                                    CHECK (stripe_status IN ('active','inactive','past_due','canceled','trialing')),
  ativo                 boolean     NOT NULL DEFAULT true,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_tenants_user_id   ON tenants (user_id);
CREATE INDEX         IF NOT EXISTS idx_tenants_email     ON tenants (email);
CREATE INDEX         IF NOT EXISTS idx_tenants_stripe_cid ON tenants (stripe_customer_id)
  WHERE stripe_customer_id IS NOT NULL;

-- ─── 2. TABELA DE JOBS DO SCRAPER ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS scraper_jobs (
  id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       uuid        NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  nicho           text        NOT NULL,
  cidade          text        NOT NULL,
  limite          int         NOT NULL DEFAULT 10,
  modo            text        NOT NULL DEFAULT 'osm'
                              CHECK (modo IN ('demo','osm','places')),
  status          text        NOT NULL DEFAULT 'queued'
                              CHECK (status IN ('queued','running','completed','failed','cancelled')),
  leads_gerados   int         NOT NULL DEFAULT 0,
  erro_msg        text,
  iniciado_em     timestamptz,
  concluido_em    timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_scraper_jobs_tenant    ON scraper_jobs (tenant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_scraper_jobs_status    ON scraper_jobs (status) WHERE status IN ('queued','running');

-- ─── 3. ADICIONAR tenant_id À TABELA DE LEADS ─────────────────────────────────
ALTER TABLE leads_diagnostico
  ADD COLUMN IF NOT EXISTS tenant_id uuid REFERENCES tenants(id) ON DELETE SET NULL;

-- Índice para queries por tenant
CREATE INDEX IF NOT EXISTS idx_leads_tenant_id
  ON leads_diagnostico (tenant_id, created_at DESC)
  WHERE tenant_id IS NOT NULL;

-- ─── 4. TRIGGER: auto-incrementar leads_usados quando lead é inserido ──────────
CREATE OR REPLACE FUNCTION fn_incrementar_quota_tenant()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF NEW.tenant_id IS NOT NULL THEN
    UPDATE tenants
    SET leads_usados = leads_usados + 1,
        updated_at   = now()
    WHERE id = NEW.tenant_id;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_incrementar_quota ON leads_diagnostico;
CREATE TRIGGER trg_incrementar_quota
  AFTER INSERT ON leads_diagnostico
  FOR EACH ROW
  EXECUTE FUNCTION fn_incrementar_quota_tenant();

-- ─── 5. TRIGGER: reset mensal automático de quota ─────────────────────────────
CREATE OR REPLACE FUNCTION fn_reset_quota_mensal()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF NEW.ciclo_reset_em <= now() THEN
    NEW.leads_usados  := 0;
    NEW.ciclo_reset_em := now() + interval '30 days';
    NEW.updated_at     := now();
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_reset_quota ON tenants;
CREATE TRIGGER trg_reset_quota
  BEFORE UPDATE ON tenants
  FOR EACH ROW
  WHEN (OLD.ciclo_reset_em IS DISTINCT FROM NEW.ciclo_reset_em OR NEW.leads_usados > 0)
  EXECUTE FUNCTION fn_reset_quota_mensal();

-- ─── 6. FUNÇÃO: verificar quota disponível (para a API) ───────────────────────
CREATE OR REPLACE FUNCTION fn_verificar_quota(p_tenant_id uuid)
RETURNS TABLE(
  tem_quota     boolean,
  leads_usados  int,
  leads_quota   int,
  restante      int,
  plano         text
) LANGUAGE sql SECURITY DEFINER AS $$
  SELECT
    t.leads_usados < t.leads_quota AS tem_quota,
    t.leads_usados,
    t.leads_quota,
    GREATEST(0, t.leads_quota - t.leads_usados) AS restante,
    t.plano
  FROM tenants t
  WHERE t.id = p_tenant_id AND t.ativo = true;
$$;

-- ─── 7. ROW LEVEL SECURITY ────────────────────────────────────────────────────

-- Tabela tenants
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_ver_proprio"
  ON tenants FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "tenant_update_proprio"
  ON tenants FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Tabela scraper_jobs (tenant isolado)
ALTER TABLE scraper_jobs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "jobs_ver_proprio_tenant"
  ON scraper_jobs FOR SELECT
  TO authenticated
  USING (
    tenant_id IN (
      SELECT id FROM tenants WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "jobs_inserir_proprio_tenant"
  ON scraper_jobs FOR INSERT
  TO authenticated
  WITH CHECK (
    tenant_id IN (
      SELECT id FROM tenants WHERE user_id = auth.uid()
    )
  );

-- Tabela leads_diagnostico — REMOVER policy antiga, criar isolamento por tenant
DROP POLICY IF EXISTS "anon_insert_only" ON leads_diagnostico;

CREATE POLICY "leads_anon_insert"
  ON leads_diagnostico FOR INSERT
  TO anon
  WITH CHECK (tenant_id IS NULL);  -- leads do quiz público não têm tenant

CREATE POLICY "leads_ver_proprio_tenant"
  ON leads_diagnostico FOR SELECT
  TO authenticated
  USING (
    tenant_id IN (
      SELECT id FROM tenants WHERE user_id = auth.uid()
    )
    OR tenant_id IS NULL  -- leads públicos do quiz ficam visíveis ao admin
  );

CREATE POLICY "leads_inserir_proprio_tenant"
  ON leads_diagnostico FOR INSERT
  TO authenticated
  WITH CHECK (
    tenant_id IS NULL
    OR tenant_id IN (
      SELECT id FROM tenants WHERE user_id = auth.uid()
    )
  );

-- ─── 8. GRANTS PARA SERVICE ROLE (API Bridge) ─────────────────────────────────
-- A API usa service_role key que bypassa RLS por default.
-- As operações do scraper (INSERT de leads com tenant_id) vêm da API Bridge.
GRANT SELECT, INSERT, UPDATE ON tenants       TO service_role;
GRANT SELECT, INSERT, UPDATE ON scraper_jobs  TO service_role;
GRANT SELECT, INSERT         ON leads_diagnostico TO service_role;

-- ─── 9. VIEW: dashboard_tenant (leitura segura para o frontend) ───────────────
CREATE OR REPLACE VIEW v_tenant_dashboard AS
SELECT
  t.id                AS tenant_id,
  t.nome,
  t.plano,
  t.leads_usados,
  t.leads_quota,
  GREATEST(0, t.leads_quota - t.leads_usados) AS leads_restantes,
  ROUND(t.leads_usados::numeric / NULLIF(t.leads_quota,0) * 100, 1) AS pct_usado,
  t.ciclo_reset_em,
  t.stripe_status,
  t.ativo,
  (
    SELECT COUNT(*) FROM scraper_jobs sj WHERE sj.tenant_id = t.id
  ) AS total_jobs,
  (
    SELECT COUNT(*) FROM scraper_jobs sj
    WHERE sj.tenant_id = t.id AND sj.status IN ('queued','running')
  ) AS jobs_ativos
FROM tenants t
WHERE t.user_id = auth.uid();

-- ─── 10. DADOS SEED: planos disponíveis (referência) ─────────────────────────
COMMENT ON TABLE tenants IS 'Planos disponíveis: starter=100 leads, pro=500 leads, enterprise=2000 leads. Reset mensal automático.';
COMMENT ON COLUMN tenants.stripe_status IS 'active|inactive|past_due|canceled|trialing — sincronizado via webhook Stripe';
COMMENT ON COLUMN scraper_jobs.status IS 'queued→running→completed|failed. Actualizado pela API Bridge via service_role.';
