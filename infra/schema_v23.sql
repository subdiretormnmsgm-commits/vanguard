-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD V23 — THE REVENUE STRIKE
-- Schema: Partner Portal Alpha + Upsell Engine + ticket_medio
-- Aplicar: Settings → SQL Editor no Supabase
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. Campo ticket_medio em tenants ───────────────────────────────────────
-- Declara o ticket médio do cliente para cálculo de ROI real no Upsell Engine
-- Actualizar via: UPDATE tenants SET metadata = jsonb_set(metadata, '{ticket_medio}', '500') WHERE id = '...';

-- Índice para queries de onboarding
CREATE INDEX IF NOT EXISTS idx_tenants_ticket_medio
    ON tenants ((metadata->>'ticket_medio'));

-- ─── 2. partner_agencies — Registo de agências parceiras ────────────────────
CREATE TABLE IF NOT EXISTS partner_agencies (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome_agencia  TEXT NOT NULL,
    email_contato TEXT NOT NULL,
    responsavel   TEXT NOT NULL,
    telefone      TEXT,
    site          TEXT,
    key_hash      TEXT UNIQUE NOT NULL,     -- SHA-256 da API key (nunca guardar raw)
    partner_code  TEXT UNIQUE NOT NULL,     -- VGP-XXXX (código de referral público)
    status        TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','suspended','inactive')),
    criado_em     TIMESTAMPTZ NOT NULL DEFAULT now(),
    notas         TEXT
);

CREATE INDEX IF NOT EXISTS idx_partner_agencies_code   ON partner_agencies (partner_code);
CREATE INDEX IF NOT EXISTS idx_partner_agencies_status ON partner_agencies (status);

-- ─── 3. partner_referrals — Clientes indicados pela agência ────────────────
CREATE TABLE IF NOT EXISTS partner_referrals (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    partner_id  UUID NOT NULL REFERENCES partner_agencies(id),
    tenant_id   UUID NOT NULL REFERENCES tenants(id),
    status      TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','active','cancelled')),
    criado_em   TIMESTAMPTZ NOT NULL DEFAULT now(),
    activado_em TIMESTAMPTZ,
    UNIQUE (partner_id, tenant_id)
);

CREATE INDEX IF NOT EXISTS idx_partner_referrals_partner ON partner_referrals (partner_id);
CREATE INDEX IF NOT EXISTS idx_partner_referrals_tenant  ON partner_referrals (tenant_id);
CREATE INDEX IF NOT EXISTS idx_partner_referrals_status  ON partner_referrals (status);

-- ─── 4. partner_commissions — Comissões ganhas ─────────────────────────────
CREATE TABLE IF NOT EXISTS partner_commissions (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    partner_id   UUID NOT NULL REFERENCES partner_agencies(id),
    referral_id  UUID REFERENCES partner_referrals(id),
    tenant_id    UUID REFERENCES tenants(id),
    tipo         TEXT NOT NULL CHECK (tipo IN ('sentinel','iah')),
    valor        NUMERIC(10,2) NOT NULL,
    pago         BOOLEAN NOT NULL DEFAULT FALSE,
    registado_em TIMESTAMPTZ NOT NULL DEFAULT now(),
    pago_em      TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_partner_commissions_partner ON partner_commissions (partner_id);
CREATE INDEX IF NOT EXISTS idx_partner_commissions_pago    ON partner_commissions (pago);

-- ─── 5. VIEW: partner_mrr — MRR por agência (dashboard do Diretor) ──────────
CREATE OR REPLACE VIEW partner_mrr AS
SELECT
    pa.id            AS partner_id,
    pa.nome_agencia,
    pa.partner_code,
    COUNT(DISTINCT pr.tenant_id) FILTER (WHERE pr.status = 'active') AS clientes_activos,
    COALESCE(SUM(pc.valor) FILTER (WHERE NOT pc.pago), 0)  AS comissoes_pendentes,
    COALESCE(SUM(pc.valor) FILTER (WHERE pc.pago), 0)      AS comissoes_pagas,
    COALESCE(SUM(pc.valor), 0)                              AS total_ganho
FROM partner_agencies pa
LEFT JOIN partner_referrals   pr ON pr.partner_id = pa.id
LEFT JOIN partner_commissions pc ON pc.partner_id = pa.id
WHERE pa.status = 'active'
GROUP BY pa.id, pa.nome_agencia, pa.partner_code;

-- ─── 6. sentinel_report_log — garantir colunas V22 (se schema_v22 ainda não aplicado) ─
-- Adiciona colunas que podem não existir ainda
ALTER TABLE sentinel_report_log
    ADD COLUMN IF NOT EXISTS open_token   TEXT,
    ADD COLUMN IF NOT EXISTS email_aberto BOOLEAN DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS aberto_em    TIMESTAMPTZ;

-- Índice para lookup rápido pelo pixel de tracking
CREATE INDEX IF NOT EXISTS idx_sentinel_report_log_token
    ON sentinel_report_log (open_token)
    WHERE open_token IS NOT NULL;

-- ─── 7. Função: activar_referral — activa referral quando Stripe confirma ──
CREATE OR REPLACE FUNCTION activar_referral(p_tenant_id UUID)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    UPDATE partner_referrals
    SET status      = 'active',
        activado_em = now()
    WHERE tenant_id = p_tenant_id
      AND status    = 'pending';
END;
$$;

-- ─── 8. tenants: índice de consentimento LGPD ───────────────────────────────
CREATE INDEX IF NOT EXISTS idx_tenants_partner_consent
    ON tenants ((metadata->>'partner_consent'))
    WHERE metadata->>'partner_consent' = 'true';

-- ─── Verificação final ───────────────────────────────────────────────────────
DO $$
BEGIN
    RAISE NOTICE 'Schema V23 aplicado: partner_agencies, partner_referrals, partner_commissions, partner_mrr VIEW';
    RAISE NOTICE 'Sentinel Report Log: colunas open_token, email_aberto, aberto_em garantidas';
    RAISE NOTICE 'Próximo passo: actualizar ticket_medio por tenant via UPDATE tenants SET metadata = jsonb_set(metadata, ''{ticket_medio}'', ''300'') WHERE id = ''...''';
END $$;
