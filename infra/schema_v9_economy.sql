-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD V9 — Sovereign Economy
-- Execute no Supabase → SQL Editor (após schema_v8_intelligence.sql)
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. LEAD ARBITRAGE — Listagens e Leilões ─────────────────────────────────

CREATE TABLE IF NOT EXISTS lead_listings (
  id               uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id        uuid          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  lead_id          uuid          NOT NULL REFERENCES leads_diagnostico(id) ON DELETE CASCADE,
  -- Dados públicos do lead (sem PII — apenas dados de inteligência)
  preview_nicho    text          NOT NULL,
  preview_cidade   text          NOT NULL,
  preview_score    numeric(4,1),
  preview_gargalo  text,
  -- Preço e modelo (leilão ou preço fixo)
  modelo           text          NOT NULL DEFAULT 'leilao'
                                 CHECK (modelo IN ('leilao', 'fixo')),
  preco_base       numeric(10,2) NOT NULL DEFAULT 0,
  preco_fixo       numeric(10,2),          -- só para modelo='fixo'
  -- Estado
  status           text          NOT NULL DEFAULT 'active'
                                 CHECK (status IN ('active','auction_ended','sold','withdrawn')),
  -- Leilão
  leilao_termina_em timestamptz,
  maior_lance      numeric(10,2) DEFAULT 0,
  maior_lance_tenant_id uuid REFERENCES tenants(id),
  -- Stripe (preço fixo)
  stripe_price_id  text,
  -- Timestamps
  expires_at       timestamptz   DEFAULT (now() + INTERVAL '7 days'),
  created_at       timestamptz   NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_listings_nicho   ON lead_listings (preview_nicho, status);
CREATE INDEX IF NOT EXISTS idx_listings_tenant  ON lead_listings (tenant_id);
CREATE INDEX IF NOT EXISTS idx_listings_leilao  ON lead_listings (leilao_termina_em) WHERE status = 'active';

-- Lances no leilão
CREATE TABLE IF NOT EXISTS lead_bids (
  id               uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  listing_id       uuid          NOT NULL REFERENCES lead_listings(id) ON DELETE CASCADE,
  bidder_tenant_id uuid          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  valor            numeric(10,2) NOT NULL,
  stripe_payment_intent text,               -- pre-authorizado
  status           text          NOT NULL DEFAULT 'active'
                                 CHECK (status IN ('active','won','lost','cancelled')),
  created_at       timestamptz   NOT NULL DEFAULT now(),
  UNIQUE (listing_id, bidder_tenant_id)     -- um lance por tenant por listagem
);

CREATE INDEX IF NOT EXISTS idx_bids_listing ON lead_bids (listing_id, valor DESC);

-- Compras concluídas
CREATE TABLE IF NOT EXISTS lead_purchases (
  id               uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  listing_id       uuid          REFERENCES lead_listings(id),
  buyer_tenant_id  uuid          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  seller_tenant_id uuid          NOT NULL REFERENCES tenants(id),
  preco_pago       numeric(10,2) NOT NULL,
  comissao_vanguard numeric(10,2),          -- 30%
  valor_vendedor   numeric(10,2),           -- 70%
  stripe_payment_intent text,
  stripe_transfer  text,
  status           text          NOT NULL DEFAULT 'pending'
                                 CHECK (status IN ('pending','completed','refunded')),
  created_at       timestamptz   NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_purchases_buyer  ON lead_purchases (buyer_tenant_id);
CREATE INDEX IF NOT EXISTS idx_purchases_seller ON lead_purchases (seller_tenant_id);

-- ─── 2. VANGUARD MATURITY CERTIFICATE ─────────────────────────────────────────

CREATE TABLE IF NOT EXISTS certifications (
  id               uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id        uuid          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  lead_id          uuid          REFERENCES leads_diagnostico(id),
  empresa_nome     text          NOT NULL,
  empresa_cidade   text,
  empresa_nicho    text,
  -- Score (0-10 → pct 0-100)
  score_digital    numeric(4,1)  NOT NULL CHECK (score_digital >= 8),
  score_percentil  int           GENERATED ALWAYS AS (ROUND(score_digital * 10)::int) STORED,
  -- Badge
  badge_token      text          NOT NULL UNIQUE DEFAULT encode(gen_random_bytes(16), 'hex'),
  badge_svg_url    text,
  nivel            text          NOT NULL DEFAULT 'ready'
                                 CHECK (nivel IN ('emerging','advanced','ready','elite')),
  -- Lifecycle
  emitido_em       timestamptz   NOT NULL DEFAULT now(),
  expires_at       timestamptz   NOT NULL DEFAULT (now() + INTERVAL '1 year'),
  renovado_em      timestamptz,
  -- Reivindicação pela empresa
  reivindicado     boolean       NOT NULL DEFAULT false,
  reivindicado_em  timestamptz,
  empresa_email    text,         -- email fornecido pela empresa ao reivindicar
  -- Pagamento
  stripe_payment_intent text,
  pago             boolean       NOT NULL DEFAULT false,
  created_at       timestamptz   NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_cert_token       ON certifications (badge_token);
CREATE INDEX IF NOT EXISTS idx_cert_tenant      ON certifications (tenant_id);
CREATE INDEX IF NOT EXISTS idx_cert_expires     ON certifications (expires_at) WHERE pago = true;

-- ─── 3. HERMES — Persona & Voz ────────────────────────────────────────────────

-- Persona aprendida por tenant (Claude analisa histórico WA)
CREATE TABLE IF NOT EXISTS hermes_personas (
  id               uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id        uuid          NOT NULL UNIQUE REFERENCES tenants(id) ON DELETE CASCADE,
  -- Estilo comunicativo (inferido por Claude)
  tom              text          DEFAULT 'neutro'
                                 CHECK (tom IN ('formal','neutro','casual','urgente')),
  tamanho_msg      text          DEFAULT 'medio'
                                 CHECK (tamanho_msg IN ('curto','medio','longo')),
  usa_emoji        boolean       DEFAULT false,
  abertura_padrao  text,         -- frase de abertura que mais converte
  cta_padrao       text,         -- call-to-action que mais converte
  -- Voice settings
  voz_habilitada   boolean       DEFAULT false,
  voz_id           text,         -- ElevenLabs/Vapi voice ID
  voz_provider     text          DEFAULT 'elevenlabs'
                                 CHECK (voz_provider IN ('elevenlabs','vapi','openai')),
  voz_config       jsonb         DEFAULT '{}',
  -- Performance
  taxa_resposta    numeric(5,2)  DEFAULT 0,   -- % de leads que responderam
  taxa_conversao   numeric(5,2)  DEFAULT 0,   -- % de leads que converteram
  total_analisados int           DEFAULT 0,
  analisado_em     timestamptz,
  created_at       timestamptz   NOT NULL DEFAULT now(),
  updated_at       timestamptz   NOT NULL DEFAULT now()
);

-- Variantes A/B de mensagens Hermes
CREATE TABLE IF NOT EXISTS hermes_variants (
  id               uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id        uuid          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  nicho            text,                      -- NULL = aplica a todos os nichos
  nome             text          NOT NULL,
  template         text          NOT NULL,    -- {nome}, {cidade}, {gargalo}, {ai_hook}
  canal            text          NOT NULL DEFAULT 'whatsapp'
                                 CHECK (canal IN ('whatsapp','voice','email')),
  -- A/B stats
  total_enviados   int           NOT NULL DEFAULT 0,
  total_respostas  int           NOT NULL DEFAULT 0,
  taxa_resposta    numeric(5,2)  GENERATED ALWAYS AS (
                                   CASE WHEN total_enviados > 0
                                   THEN ROUND(total_respostas::numeric / total_enviados * 100, 2)
                                   ELSE 0 END
                                 ) STORED,
  is_winner        boolean       NOT NULL DEFAULT false,
  ativo            boolean       NOT NULL DEFAULT true,
  created_at       timestamptz   NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_variants_tenant ON hermes_variants (tenant_id, nicho);

-- Histórico de chamadas de voz (Vapi/ElevenLabs)
CREATE TABLE IF NOT EXISTS hermes_voice_calls (
  id               uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id        uuid          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  lead_id          uuid          REFERENCES leads_diagnostico(id),
  -- Provider
  provider         text          NOT NULL DEFAULT 'vapi'
                                 CHECK (provider IN ('vapi','elevenlabs','openai')),
  call_id          text,         -- ID externo do provider
  numero_destino   text,
  -- Estado
  status           text          NOT NULL DEFAULT 'iniciada'
                                 CHECK (status IN ('iniciada','em_curso','concluida','sem_resposta','erro')),
  duracao_seg      int,
  transcricao      text,
  outcome          text          CHECK (outcome IN ('respondeu','nao_atendeu','voicemail','converteu','perdeu')),
  -- Claude analysis
  analise_claude   text,
  proximo_passo    text,
  -- Custo
  custo_usd        numeric(8,4),
  created_at       timestamptz   NOT NULL DEFAULT now(),
  terminado_em     timestamptz
);

CREATE INDEX IF NOT EXISTS idx_voice_tenant ON hermes_voice_calls (tenant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_voice_lead   ON hermes_voice_calls (lead_id);

-- ─── 4. TRIGGER: Fechar Leilão ────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_fechar_leilao()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Quando o leilão termina (chamado por job externo ou UPDATE):
  IF NEW.status = 'auction_ended' AND OLD.status = 'active' THEN
    IF NEW.maior_lance_tenant_id IS NOT NULL THEN
      -- Registar compra
      INSERT INTO lead_purchases (
        listing_id, buyer_tenant_id, seller_tenant_id, preco_pago,
        comissao_vanguard, valor_vendedor, status
      ) VALUES (
        NEW.id,
        NEW.maior_lance_tenant_id,
        NEW.tenant_id,
        NEW.maior_lance,
        ROUND(NEW.maior_lance * 0.30, 2),
        ROUND(NEW.maior_lance * 0.70, 2),
        'pending'
      );
      -- Marcar lance vencedor
      UPDATE lead_bids
      SET status = 'won'
      WHERE listing_id = NEW.id
        AND bidder_tenant_id = NEW.maior_lance_tenant_id;
      -- Marcar perdedores
      UPDATE lead_bids
      SET status = 'lost'
      WHERE listing_id = NEW.id
        AND bidder_tenant_id != NEW.maior_lance_tenant_id;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_fechar_leilao ON lead_listings;
CREATE TRIGGER trg_fechar_leilao
  AFTER UPDATE ON lead_listings
  FOR EACH ROW
  WHEN (NEW.status = 'auction_ended' AND OLD.status = 'active')
  EXECUTE FUNCTION fn_fechar_leilao();

-- ─── 5. TRIGGER: Atualizar maior lance ───────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_atualizar_maior_lance()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE lead_listings
  SET
    maior_lance            = NEW.valor,
    maior_lance_tenant_id  = NEW.bidder_tenant_id
  WHERE id = NEW.listing_id
    AND (maior_lance IS NULL OR NEW.valor > maior_lance);
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_maior_lance ON lead_bids;
CREATE TRIGGER trg_maior_lance
  AFTER INSERT ON lead_bids
  FOR EACH ROW EXECUTE FUNCTION fn_atualizar_maior_lance();

-- ─── 6. FUNÇÃO: Nível de Certificação ────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_nivel_certificacao(p_score numeric)
RETURNS text LANGUAGE plpgsql IMMUTABLE AS $$
BEGIN
  CASE
    WHEN p_score >= 9.5 THEN RETURN 'elite';
    WHEN p_score >= 9.0 THEN RETURN 'ready';
    WHEN p_score >= 8.5 THEN RETURN 'advanced';
    ELSE                     RETURN 'emerging';
  END CASE;
END;
$$;

-- ─── 7. ROW LEVEL SECURITY ────────────────────────────────────────────────────
ALTER TABLE lead_listings       ENABLE ROW LEVEL SECURITY;
ALTER TABLE lead_bids           ENABLE ROW LEVEL SECURITY;
ALTER TABLE lead_purchases      ENABLE ROW LEVEL SECURITY;
ALTER TABLE certifications      ENABLE ROW LEVEL SECURITY;
ALTER TABLE hermes_personas     ENABLE ROW LEVEL SECURITY;
ALTER TABLE hermes_variants     ENABLE ROW LEVEL SECURITY;
ALTER TABLE hermes_voice_calls  ENABLE ROW LEVEL SECURITY;

-- Lead listings: qualquer tenant autenticado vê as listagens activas (mercado público)
CREATE POLICY "listings_ver_activas"
  ON lead_listings FOR SELECT TO authenticated
  USING (status = 'active');

CREATE POLICY "listings_gerir_proprio"
  ON lead_listings FOR ALL TO authenticated
  USING (tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()))
  WITH CHECK (tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()));

-- Bids: tenant vê os seus lances
CREATE POLICY "bids_proprio"
  ON lead_bids FOR ALL TO authenticated
  USING (bidder_tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()))
  WITH CHECK (bidder_tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()));

-- Certifications: público para leitura (verificação), owner para escrita
CREATE POLICY "cert_ver_publico"
  ON certifications FOR SELECT TO authenticated, anon
  USING (pago = true);

CREATE POLICY "cert_gerir_proprio"
  ON certifications FOR INSERT TO authenticated
  WITH CHECK (tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()));

-- Hermes: cada tenant vê os seus dados
CREATE POLICY "persona_proprio"
  ON hermes_personas FOR ALL TO authenticated
  USING (tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()))
  WITH CHECK (tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()));

CREATE POLICY "variants_proprio"
  ON hermes_variants FOR ALL TO authenticated
  USING (tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()))
  WITH CHECK (tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()));

CREATE POLICY "voice_calls_proprio"
  ON hermes_voice_calls FOR ALL TO authenticated
  USING (tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()))
  WITH CHECK (tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()));

-- Purchases: buyer e seller vêem as suas compras
CREATE POLICY "purchases_ver"
  ON lead_purchases FOR SELECT TO authenticated
  USING (
    buyer_tenant_id  IN (SELECT id FROM tenants WHERE user_id = auth.uid())
    OR
    seller_tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid())
  );

-- ─── 8. GRANTS ────────────────────────────────────────────────────────────────
GRANT SELECT, INSERT, UPDATE ON lead_listings      TO service_role;
GRANT SELECT, INSERT, UPDATE ON lead_bids          TO service_role;
GRANT SELECT, INSERT, UPDATE ON lead_purchases     TO service_role;
GRANT SELECT, INSERT, UPDATE ON certifications     TO service_role, authenticated;
GRANT SELECT ON certifications                     TO anon;
GRANT SELECT, INSERT, UPDATE ON hermes_personas    TO service_role;
GRANT SELECT, INSERT, UPDATE ON hermes_variants    TO service_role;
GRANT SELECT, INSERT, UPDATE ON hermes_voice_calls TO service_role;

-- ─── 9. COMENTÁRIOS ──────────────────────────────────────────────────────────
COMMENT ON TABLE lead_listings      IS 'Mercado de Arbitragem: leads listados por tenants para leilão/venda interna. Vanguard retém 30%.';
COMMENT ON TABLE certifications     IS 'Vanguard Maturity Certificate: badge SVG dinâmico para empresas com score_digital >= 8. Expira anualmente.';
COMMENT ON TABLE hermes_personas    IS 'Persona aprendida do Hermes por tenant — tom, tamanho, CTA, voice settings.';
COMMENT ON TABLE hermes_variants    IS 'Variantes A/B de mensagens Hermes. Taxa de resposta calculada automaticamente.';
COMMENT ON TABLE hermes_voice_calls IS 'Histórico de chamadas de voz via Vapi/ElevenLabs. Inclui transcrição e análise Claude.';
