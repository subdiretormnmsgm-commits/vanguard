-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD V7 — Marketplace de Nichos: Migração Completa
-- Execute no Supabase → SQL Editor (após schema_v6_multitenant.sql)
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. TABELA DE CRIADORES (Parceiros do Marketplace) ────────────────────────
CREATE TABLE IF NOT EXISTS creators (
  id                    uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               uuid          NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  nome                  text          NOT NULL,
  bio                   text,
  avatar_url            text,
  especialidade         text,         -- nicho principal do criador
  stripe_account_id     text,         -- Stripe Connect Express account ID
  stripe_onboarded      boolean       NOT NULL DEFAULT false,
  packs_publicados      int           NOT NULL DEFAULT 0,
  assinantes_total      int           NOT NULL DEFAULT 0,
  receita_total         numeric(12,2) NOT NULL DEFAULT 0,
  rating_medio          numeric(3,2)  DEFAULT 5.0,
  ativo                 boolean       NOT NULL DEFAULT true,
  created_at            timestamptz   NOT NULL DEFAULT now(),
  updated_at            timestamptz   NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_creators_user_id   ON creators (user_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_creators_stripe_acc ON creators (stripe_account_id)
  WHERE stripe_account_id IS NOT NULL;

-- ─── 2. TABELA DE PACKS DE NICHO ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS marketplace_packs (
  id                    uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id            uuid          NOT NULL REFERENCES creators(id) ON DELETE CASCADE,
  nome                  text          NOT NULL,
  descricao             text,
  nicho                 text          NOT NULL,
  cidade_alvo           text,         -- NULL = nacional
  preco_mensal          numeric(10,2) NOT NULL DEFAULT 97,

  -- Performance histórica (actualizada por trigger)
  leads_tipicos         int           NOT NULL DEFAULT 50,
  taxa_conversao        numeric(5,2)  DEFAULT 0,
  score_medio           numeric(4,2)  DEFAULT 0,

  -- Config do scraper (JSON)
  config_osm            jsonb,        -- {query, raio_km, filtros_extra}
  config_prompts        jsonb,        -- {system_prompt, hook_template, persona}
  config_wa_templates   jsonb,        -- {saudacao, followup_24h, followup_72h}

  -- Stripe
  stripe_price_id       text,
  stripe_product_id     text,

  -- Status do pack
  status                text          NOT NULL DEFAULT 'draft'
                                      CHECK (status IN ('draft','review','active','paused','archived')),

  -- Métricas públicas
  assinantes            int           NOT NULL DEFAULT 0,
  visualizacoes         int           NOT NULL DEFAULT 0,
  rating                numeric(3,2)  DEFAULT 5.0,
  reviews               int           NOT NULL DEFAULT 0,

  -- Tags e cover
  tags                  text[]        DEFAULT '{}',
  cover_emoji           text          DEFAULT '📦',

  publicado_em          timestamptz,
  created_at            timestamptz   NOT NULL DEFAULT now(),
  updated_at            timestamptz   NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_packs_creator      ON marketplace_packs (creator_id);
CREATE INDEX IF NOT EXISTS idx_packs_nicho_status ON marketplace_packs (nicho, status);
CREATE INDEX IF NOT EXISTS idx_packs_rating       ON marketplace_packs (rating DESC) WHERE status = 'active';
CREATE INDEX IF NOT EXISTS idx_packs_assinantes   ON marketplace_packs (assinantes DESC) WHERE status = 'active';

-- ─── 3. SUBSCRIPTIONS DE TENANTS A PACKS ────────────────────────────────────
CREATE TABLE IF NOT EXISTS pack_subscriptions (
  id                      uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id               uuid        NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  pack_id                 uuid        NOT NULL REFERENCES marketplace_packs(id) ON DELETE CASCADE,
  stripe_subscription_id  text,
  status                  text        NOT NULL DEFAULT 'active'
                                      CHECK (status IN ('active','cancelled','past_due','trialing')),
  leads_gerados           int         NOT NULL DEFAULT 0,
  ultimo_job_em           timestamptz,
  created_at              timestamptz NOT NULL DEFAULT now(),
  cancelled_at            timestamptz,
  UNIQUE (tenant_id, pack_id)
);

CREATE INDEX IF NOT EXISTS idx_subs_tenant ON pack_subscriptions (tenant_id, status);
CREATE INDEX IF NOT EXISTS idx_subs_pack   ON pack_subscriptions (pack_id, status);

-- ─── 4. REVIEWS DE PACKS ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS pack_reviews (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  pack_id     uuid        NOT NULL REFERENCES marketplace_packs(id) ON DELETE CASCADE,
  tenant_id   uuid        NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  rating      int         NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comentario  text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (pack_id, tenant_id)
);

-- ─── 5. WEBHOOKS DE INTENÇÃO ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS intention_webhooks (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   uuid        REFERENCES tenants(id) ON DELETE SET NULL,
  pack_id     uuid        REFERENCES marketplace_packs(id) ON DELETE SET NULL,
  evento      text        NOT NULL
              CHECK (evento IN ('view','preview','add_to_cart','checkout_start','subscribed','scraper_ran')),
  metadata    jsonb       DEFAULT '{}',
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_intention_pack   ON intention_webhooks (pack_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_intention_tenant ON intention_webhooks (tenant_id, created_at DESC);

-- ─── 6. TRANSFERÊNCIAS / PAYOUTS ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS creator_payouts (
  id                    uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id            uuid          NOT NULL REFERENCES creators(id) ON DELETE CASCADE,
  pack_id               uuid          REFERENCES marketplace_packs(id) ON DELETE SET NULL,
  stripe_transfer_id    text,
  valor_bruto           numeric(10,2) NOT NULL,
  comissao_plataforma   numeric(10,2) NOT NULL, -- 30%
  valor_criador         numeric(10,2) NOT NULL, -- 70%
  status                text          NOT NULL DEFAULT 'pending'
                                      CHECK (status IN ('pending','transferred','failed')),
  periodo_inicio        date,
  periodo_fim           date,
  created_at            timestamptz   NOT NULL DEFAULT now()
);

-- ─── 7. TRIGGERS ─────────────────────────────────────────────────────────────

-- Incrementa assinantes do pack e do criador quando nova subscription activa
CREATE OR REPLACE FUNCTION fn_incrementar_assinantes()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF NEW.status = 'active' AND (OLD IS NULL OR OLD.status != 'active') THEN
    UPDATE marketplace_packs
    SET assinantes = assinantes + 1, updated_at = now()
    WHERE id = NEW.pack_id;

    UPDATE creators c
    SET assinantes_total = assinantes_total + 1, updated_at = now()
    FROM marketplace_packs p
    WHERE p.id = NEW.pack_id AND c.id = p.creator_id;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_incrementar_assinantes ON pack_subscriptions;
CREATE TRIGGER trg_incrementar_assinantes
  AFTER INSERT OR UPDATE ON pack_subscriptions
  FOR EACH ROW EXECUTE FUNCTION fn_incrementar_assinantes();

-- Decrementa assinantes quando subscription cancelada
CREATE OR REPLACE FUNCTION fn_decrementar_assinantes()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF NEW.status = 'cancelled' AND OLD.status = 'active' THEN
    UPDATE marketplace_packs
    SET assinantes = GREATEST(0, assinantes - 1), updated_at = now()
    WHERE id = NEW.pack_id;

    UPDATE creators c
    SET assinantes_total = GREATEST(0, assinantes_total - 1), updated_at = now()
    FROM marketplace_packs p
    WHERE p.id = NEW.pack_id AND c.id = p.creator_id;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_decrementar_assinantes ON pack_subscriptions;
CREATE TRIGGER trg_decrementar_assinantes
  AFTER UPDATE ON pack_subscriptions
  FOR EACH ROW EXECUTE FUNCTION fn_decrementar_assinantes();

-- Actualiza rating médio do pack após nova review
CREATE OR REPLACE FUNCTION fn_actualizar_rating_pack()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE marketplace_packs
  SET
    rating  = (SELECT ROUND(AVG(rating)::numeric, 2) FROM pack_reviews WHERE pack_id = NEW.pack_id),
    reviews = (SELECT COUNT(*) FROM pack_reviews WHERE pack_id = NEW.pack_id),
    updated_at = now()
  WHERE id = NEW.pack_id;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_actualizar_rating ON pack_reviews;
CREATE TRIGGER trg_actualizar_rating
  AFTER INSERT OR UPDATE ON pack_reviews
  FOR EACH ROW EXECUTE FUNCTION fn_actualizar_rating_pack();

-- ─── 8. ROW LEVEL SECURITY ────────────────────────────────────────────────────

ALTER TABLE creators              ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketplace_packs     ENABLE ROW LEVEL SECURITY;
ALTER TABLE pack_subscriptions    ENABLE ROW LEVEL SECURITY;
ALTER TABLE pack_reviews          ENABLE ROW LEVEL SECURITY;
ALTER TABLE intention_webhooks    ENABLE ROW LEVEL SECURITY;
ALTER TABLE creator_payouts       ENABLE ROW LEVEL SECURITY;

-- Creators
CREATE POLICY "creator_ver_proprio"
  ON creators FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "creator_update_proprio"
  ON creators FOR UPDATE TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Packs: leitura pública (activos), escrita só pelo criador
CREATE POLICY "packs_leitura_publica"
  ON marketplace_packs FOR SELECT
  TO anon, authenticated
  USING (status = 'active' OR creator_id IN (SELECT id FROM creators WHERE user_id = auth.uid()));

CREATE POLICY "packs_criador_inserir"
  ON marketplace_packs FOR INSERT TO authenticated
  WITH CHECK (creator_id IN (SELECT id FROM creators WHERE user_id = auth.uid()));

CREATE POLICY "packs_criador_update"
  ON marketplace_packs FOR UPDATE TO authenticated
  USING (creator_id IN (SELECT id FROM creators WHERE user_id = auth.uid()))
  WITH CHECK (creator_id IN (SELECT id FROM creators WHERE user_id = auth.uid()));

-- Subscriptions: tenant vê as suas, criador vê as dos seus packs
CREATE POLICY "subs_ver_proprio_tenant"
  ON pack_subscriptions FOR SELECT TO authenticated
  USING (
    tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid())
    OR pack_id IN (
      SELECT p.id FROM marketplace_packs p
      JOIN creators c ON c.id = p.creator_id
      WHERE c.user_id = auth.uid()
    )
  );

-- Reviews: leitura pública, escrita por tenant subscritor
CREATE POLICY "reviews_leitura_publica"
  ON pack_reviews FOR SELECT TO anon, authenticated USING (true);

CREATE POLICY "reviews_inserir_subscritor"
  ON pack_reviews FOR INSERT TO authenticated
  WITH CHECK (
    tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid())
    AND pack_id IN (
      SELECT pack_id FROM pack_subscriptions
      WHERE tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid())
        AND status = 'active'
    )
  );

-- Payouts: só o criador
CREATE POLICY "payouts_ver_proprio"
  ON creator_payouts FOR SELECT TO authenticated
  USING (creator_id IN (SELECT id FROM creators WHERE user_id = auth.uid()));

-- ─── 9. GRANTS PARA SERVICE ROLE ──────────────────────────────────────────────
GRANT SELECT, INSERT, UPDATE ON creators           TO service_role;
GRANT SELECT, INSERT, UPDATE ON marketplace_packs  TO service_role;
GRANT SELECT, INSERT, UPDATE ON pack_subscriptions TO service_role;
GRANT SELECT, INSERT         ON pack_reviews       TO service_role;
GRANT SELECT, INSERT         ON intention_webhooks TO service_role;
GRANT SELECT, INSERT, UPDATE ON creator_payouts    TO service_role;

-- ─── 10. VIEW: marketplace_feed (packs activos com info do criador) ───────────
CREATE OR REPLACE VIEW v_marketplace_feed AS
SELECT
  p.id,
  p.nome,
  p.descricao,
  p.nicho,
  p.cidade_alvo,
  p.preco_mensal,
  p.leads_tipicos,
  p.taxa_conversao,
  p.score_medio,
  p.assinantes,
  p.visualizacoes,
  p.rating,
  p.reviews,
  p.tags,
  p.cover_emoji,
  p.publicado_em,
  c.id            AS creator_id,
  c.nome          AS creator_nome,
  c.avatar_url    AS creator_avatar,
  c.rating_medio  AS creator_rating
FROM marketplace_packs p
JOIN creators c ON c.id = p.creator_id
WHERE p.status = 'active'
ORDER BY p.assinantes DESC, p.rating DESC;

-- ─── 11. COMENTÁRIOS DE DOCUMENTAÇÃO ─────────────────────────────────────────
COMMENT ON TABLE creators IS 'Parceiros que publicam packs de nicho no Marketplace V7. Integrados com Stripe Connect Express (70% da receita).';
COMMENT ON TABLE marketplace_packs IS 'Packs de nicho: config OSM + prompts Claude Haiku + templates WA. Revenue share: 70% criador / 30% plataforma.';
COMMENT ON TABLE pack_subscriptions IS 'Subscriptions de tenants a packs. Stripe subscription recorrente. Scra per auto-dispara com config do pack.';
COMMENT ON TABLE intention_webhooks IS 'Eventos de comportamento pré-compra: view, preview, checkout_start. Usados para optimizar funil do Marketplace.';
