-- ============================================================
-- VANGUARD TECH — Schema V14: Sovereign Optimization
-- Hive Mind (Hermes Templates) + Agency Partners
-- Data: 2026-05-10
-- ============================================================

-- ── 1. HERMES TEMPLATES — Colmeia de Inteligência ────────────
-- Armazena templates de mensagem com métricas de performance.
-- O Hive Mind promove automaticamente o melhor template por nicho.

CREATE TABLE IF NOT EXISTS hermes_templates (
  id               UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  nicho            TEXT        NOT NULL,
  gargalo          TEXT,                         -- NULL = aplica-se a todos os gargalos do nicho
  template_text    TEXT        NOT NULL,
  canal            TEXT        NOT NULL DEFAULT 'whatsapp' CHECK (canal IN ('whatsapp', 'email', 'voice')),
  send_count       INTEGER     NOT NULL DEFAULT 0,
  response_count   INTEGER     NOT NULL DEFAULT 0,
  response_rate    NUMERIC     GENERATED ALWAYS AS (
                     CASE WHEN send_count > 0
                          THEN ROUND(response_count::NUMERIC / send_count * 100, 2)
                          ELSE 0
                     END
                   ) STORED,
  is_vanguard_recommended BOOLEAN NOT NULL DEFAULT FALSE,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- RLS: Templates são globais (leitura pública) mas escrita é service_role
ALTER TABLE hermes_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "templates_read_all"  ON hermes_templates FOR SELECT USING (TRUE);
CREATE POLICY "templates_write_svc" ON hermes_templates FOR ALL USING (auth.role() = 'service_role');

-- Trigger para updated_at
CREATE OR REPLACE FUNCTION fn_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_templates_updated
  BEFORE UPDATE ON hermes_templates
  FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

-- ── 2. HERMES OUTBOUND LOG — Registo de Envios ────────────────
-- Rastreia cada envio Hermes para calcular a taxa de resposta real.

CREATE TABLE IF NOT EXISTS hermes_outbound_log (
  id            UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  template_id   UUID        REFERENCES hermes_templates(id) ON DELETE SET NULL,
  lead_id       UUID,                            -- FK para leads_diagnostico (nullable — nem todos têm UUID)
  nicho         TEXT        NOT NULL,
  canal         TEXT        NOT NULL DEFAULT 'whatsapp',
  sent_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  responded_at  TIMESTAMPTZ,
  outcome       TEXT        CHECK (outcome IN ('pending', 'responded', 'converted', 'no_response', 'bounced')),
  notes         TEXT
);

ALTER TABLE hermes_outbound_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "log_write_svc" ON hermes_outbound_log FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "log_read_all"  ON hermes_outbound_log FOR SELECT USING (TRUE);

-- ── 3. AGENCY PARTNERS — Parceiros (migração do localStorage) ─

CREATE TABLE IF NOT EXISTS agency_partners (
  id          UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  name        TEXT        NOT NULL,
  email       TEXT        NOT NULL UNIQUE,
  plan        TEXT        NOT NULL DEFAULT 'Free' CHECK (plan IN ('Free', 'Agency', 'White-Label')),
  api_key     TEXT        NOT NULL UNIQUE,         -- vg-api-{8chars}
  api_key_hash TEXT,                               -- SHA-256 do api_key (para lookup seguro)
  scans_used  INTEGER     NOT NULL DEFAULT 0,
  revenue_generated NUMERIC NOT NULL DEFAULT 0,
  status      TEXT        NOT NULL DEFAULT 'trial' CHECK (status IN ('active', 'trial', 'paused', 'cancelled')),
  joined_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE agency_partners ENABLE ROW LEVEL SECURITY;
CREATE POLICY "partners_read_all"  ON agency_partners FOR SELECT USING (TRUE);
CREATE POLICY "partners_write_svc" ON agency_partners FOR ALL USING (auth.role() = 'service_role');

CREATE TRIGGER trg_partners_updated
  BEFORE UPDATE ON agency_partners
  FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

-- ── 4. HIVE MIND — Função de Promoção Automática ─────────────
-- Executada via pg_cron semanalmente: a cada domingo às 02:00

CREATE OR REPLACE FUNCTION fn_hive_mind_promote(p_nicho TEXT DEFAULT NULL)
RETURNS TABLE(nicho TEXT, promoted_id UUID, response_rate NUMERIC, action TEXT) AS $$
DECLARE
  r RECORD;
  avg_rate NUMERIC;
  best_id  UUID;
  best_rate NUMERIC;
BEGIN
  -- Itera sobre cada nicho distinto (ou o nicho específico passado)
  FOR r IN
    SELECT DISTINCT t.nicho
    FROM hermes_templates t
    WHERE (p_nicho IS NULL OR t.nicho = p_nicho)
      AND t.send_count >= 50
  LOOP
    -- Calcula taxa média do nicho
    SELECT AVG(t.response_rate), MAX(t.response_rate)
    INTO avg_rate, best_rate
    FROM hermes_templates t
    WHERE t.nicho = r.nicho AND t.send_count >= 50;

    -- Reset todas as recomendações do nicho
    UPDATE hermes_templates
    SET is_vanguard_recommended = FALSE
    WHERE hermes_templates.nicho = r.nicho;

    -- Promove o melhor se superar a média em 10%
    SELECT id INTO best_id
    FROM hermes_templates
    WHERE hermes_templates.nicho = r.nicho
      AND send_count >= 50
      AND response_rate >= (avg_rate * 1.10)
    ORDER BY response_rate DESC
    LIMIT 1;

    IF best_id IS NOT NULL THEN
      UPDATE hermes_templates
      SET is_vanguard_recommended = TRUE
      WHERE id = best_id;

      RETURN QUERY SELECT r.nicho, best_id, best_rate, 'PROMOTED'::TEXT;
    ELSE
      RETURN QUERY SELECT r.nicho, NULL::UUID, avg_rate, 'NO_WINNER'::TEXT;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Comentário: executar manualmente com:
-- SELECT * FROM fn_hive_mind_promote();           -- todos os nichos
-- SELECT * FROM fn_hive_mind_promote('Saúde');    -- nicho específico

-- ── 5. pg_cron — Agendamento Semanal ────────────────────────
-- Requer extensão pg_cron activa no Supabase (Settings > Database > Extensions)
-- SELECT cron.schedule('hive-mind-weekly', '0 2 * * 0', 'SELECT fn_hive_mind_promote()');

-- ── 6. PERFORMANCE VIEW — Dashboard Hive Mind ────────────────

CREATE OR REPLACE VIEW v_hive_mind_performance AS
SELECT
  t.nicho,
  t.gargalo,
  t.canal,
  t.template_text,
  t.send_count,
  t.response_count,
  t.response_rate,
  t.is_vanguard_recommended,
  RANK() OVER (PARTITION BY t.nicho ORDER BY t.response_rate DESC) AS rank_in_nicho,
  t.updated_at
FROM hermes_templates t
ORDER BY t.nicho, t.response_rate DESC;

-- ── 7. SEED — Templates Iniciais ────────────────────────────
-- Templates iniciais baseados nos scripts do outbound-engine.js V13

INSERT INTO hermes_templates (nicho, gargalo, canal, template_text) VALUES
('Saúde', 'Captação e retenção de clientes', 'whatsapp',
 'Olá {nome}! Analisei o perfil digital do seu negócio em *Saúde* e identifiquei que a captação de clientes é o gargalo #1 do sector. Temos um sistema que gera pacientes qualificados automaticamente para clínicas. Posso mostrar-lhe os resultados de clínicas similares? 5 minutos, sem compromisso. — Hermes · Vanguard Tech 🚀'),
('Advocacia', 'Captação e retenção de clientes', 'whatsapp',
 'Olá {nome}! Analisei escritórios em *Advocacia* e a captação de clientes é o gargalo crítico do sector. Temos um sistema específico para advocacia — gera leads qualificados sem depender de indicações. Posso mostrar os resultados de outros escritórios? — Hermes · Vanguard Tech 🚀'),
('Imobiliário', 'Processos manuais que consomem tempo', 'whatsapp',
 'Olá {nome}! O seu negócio em *Imobiliário* ainda opera com processos manuais que consomem tempo crítico. Calculamos que este gargalo custa 15-20 horas semanais que podiam estar em fechamentos. Automatizamos os 3 processos mais repetitivos do sector em menos de uma semana. — Hermes · Vanguard Tech 🚀'),
('Consultoria', 'Falta de visibilidade sobre métricas do negócio', 'whatsapp',
 'Olá {nome}! O seu negócio em *Consultoria* está a tomar decisões sem dados. No sector de consultoria, empresas sem dashboard de métricas perdem em média 23% de margem por trimestre. Instalamos o painel de controlo completo em 72h. Quer ver uma demo? — Hermes · Vanguard Tech 🚀'),
('Tecnologia', 'Dificuldade em escalar a equipa', 'whatsapp',
 'Olá {nome}! Analisei o perfil da sua *Startup/Tech* e a dificuldade em escalar a equipa está a travar o crescimento. Empresas que resolvem este gargalo crescem 3× mais rápido nos 6 meses seguintes. A Vanguard Tech já ajudou tech startups a automatizar o processo de contratação. — Hermes · Vanguard Tech 🚀')
ON CONFLICT DO NOTHING;

-- ── FIM DO SCHEMA V14 ────────────────────────────────────────
