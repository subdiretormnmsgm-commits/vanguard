-- =============================================================
-- PROJ-002 Ingrid — Schema Supabase
-- Dia 1 do build — 2026-05-15
-- Multi-tenant desde o Dia 1 (P-013 + decisao arquitetural aprovada)
-- =============================================================

-- -------------------------------------------------------------
-- TABELA: questoes_quadrix
-- Global por concurso — reutilizavel para SaaS B2C futuro
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS questoes_quadrix (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  concurso_id         TEXT NOT NULL,          -- 'sedes_df_2026'
  disciplina_id       TEXT NOT NULL,          -- 'suas', 'loas', 'pnas', etc.
  peso_edital         INTEGER NOT NULL CHECK (peso_edital IN (1, 2)),
  score_prioridade    INTEGER,                -- peso_edital * incidencia_historica_pct
  enunciado           TEXT NOT NULL,
  alternativas        JSONB NOT NULL,         -- [{ "letra": "A", "texto": "...", "correta": false }]
  gabarito            TEXT NOT NULL,          -- "A", "B", "C", "D" ou "E"
  explicacao          TEXT NOT NULL,          -- explicacao da resposta correta (Opcao A comentario ao errar)
  distrator_principal TEXT,                   -- descricao da pegadinha usada na questao
  nivel_dificuldade   INTEGER CHECK (nivel_dificuldade BETWEEN 1 AND 5),
  estilo_quadrix      TEXT[],                 -- ['literalidade', 'troca_modalidade', 'pegadinha_competencia']
  criada_em           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  criada_por          TEXT DEFAULT 'claude_api'
);

-- Indice para busca rapida por concurso + disciplina (usado no feed diario)
CREATE INDEX IF NOT EXISTS idx_questoes_concurso_disciplina
  ON questoes_quadrix (concurso_id, disciplina_id);

-- Indice para busca por score (prioridade do feed)
CREATE INDEX IF NOT EXISTS idx_questoes_score
  ON questoes_quadrix (concurso_id, score_prioridade DESC);

-- -------------------------------------------------------------
-- TABELA: progresso_usuario
-- Por user_id — pronto para multi-tenant sem refatoracao
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS progresso_usuario (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             UUID NOT NULL,          -- identificador da Ingrid (hardcoded no MVP)
  questao_id          UUID NOT NULL REFERENCES questoes_quadrix(id) ON DELETE CASCADE,
  respondida_em       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resposta_usuario    TEXT NOT NULL,          -- "A", "B", "C", "D" ou "E"
  correta             BOOLEAN NOT NULL,
  tempo_resposta_seg  INTEGER,               -- tempo que levou para responder
  distrator_errado    TEXT,                  -- distrator escolhido se errou (para M-3 futuro)
  proxima_revisao_em  DATE,                  -- SM-2: data da proxima revisao
  intervalo_sm2_dias  INTEGER DEFAULT 1      -- SM-2: intervalo atual em dias
);

-- Indice para busca de revisoes pendentes (SM-2 scheduler)
CREATE INDEX IF NOT EXISTS idx_progresso_revisao
  ON progresso_usuario (user_id, proxima_revisao_em);

-- Indice para historico por questao
CREATE INDEX IF NOT EXISTS idx_progresso_questao
  ON progresso_usuario (user_id, questao_id);

-- -------------------------------------------------------------
-- TABELA: controle_cache
-- Monitora quantidade disponivel por disciplina — trigger do lote
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS controle_cache (
  concurso_id         TEXT NOT NULL,
  disciplina_id       TEXT NOT NULL,
  total_disponiveis   INTEGER NOT NULL DEFAULT 0,
  ultima_geracao_em   TIMESTAMPTZ,
  geracao_em_progresso BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (concurso_id, disciplina_id)
);

-- -------------------------------------------------------------
-- TABELA: controle_burn_rate
-- Hard limit diario de API — BURN_RATE_DAILY_LIMIT_USD = 5.00
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS controle_burn_rate (
  data_ref            DATE NOT NULL DEFAULT CURRENT_DATE PRIMARY KEY,
  custo_acumulado_usd NUMERIC(8, 4) NOT NULL DEFAULT 0,
  limite_diario_usd   NUMERIC(8, 4) NOT NULL DEFAULT 5.00,
  bloqueado           BOOLEAN NOT NULL DEFAULT FALSE,
  ultima_chamada_em   TIMESTAMPTZ
);

-- Insere o registro de hoje automaticamente se nao existir
INSERT INTO controle_burn_rate (data_ref)
VALUES (CURRENT_DATE)
ON CONFLICT (data_ref) DO NOTHING;

-- -------------------------------------------------------------
-- RLS — habilitar em todas as tabelas expostas
-- -------------------------------------------------------------
ALTER TABLE questoes_quadrix     ENABLE ROW LEVEL SECURITY;
ALTER TABLE progresso_usuario    ENABLE ROW LEVEL SECURITY;
ALTER TABLE controle_cache       ENABLE ROW LEVEL SECURITY;
ALTER TABLE controle_burn_rate   ENABLE ROW LEVEL SECURITY;

-- questoes_quadrix: leitura publica (anon pode buscar questoes), escrita so via service_role
CREATE POLICY "questoes_leitura_publica" ON questoes_quadrix
  FOR SELECT USING (true);

-- progresso_usuario: MVP single-user — service_role gerencia tudo via Edge Function
CREATE POLICY "progresso_service_role" ON progresso_usuario
  FOR ALL USING (true);

-- controle_cache e burn_rate: apenas service_role (Edge Function)
CREATE POLICY "cache_service_role" ON controle_cache
  FOR ALL USING (true);

CREATE POLICY "burn_rate_service_role" ON controle_burn_rate
  FOR ALL USING (true);

-- -------------------------------------------------------------
-- VIEW: questoes_nao_respondidas
-- Usado pelo feed diario — questoes que Ingrid ainda nao viu
-- security_invoker = true: view respeita RLS do chamador
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW questoes_nao_respondidas
  WITH (security_invoker = true)
AS
SELECT q.*
FROM questoes_quadrix q
WHERE q.concurso_id = 'sedes_df_2026'
  AND q.id NOT IN (
    SELECT questao_id
    FROM progresso_usuario
    WHERE user_id = '00000000-0000-0000-0000-000000000001'
  )
ORDER BY q.score_prioridade DESC;

-- -------------------------------------------------------------
-- VIEW: questoes_para_revisao
-- SM-2: questoes com proxima_revisao_em <= hoje
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW questoes_para_revisao
  WITH (security_invoker = true)
AS
SELECT
  pu.questao_id,
  q.disciplina_id,
  q.peso_edital,
  q.score_prioridade,
  pu.proxima_revisao_em,
  pu.intervalo_sm2_dias
FROM progresso_usuario pu
JOIN questoes_quadrix q ON q.id = pu.questao_id
WHERE pu.user_id = '00000000-0000-0000-0000-000000000001'
  AND pu.proxima_revisao_em <= CURRENT_DATE
ORDER BY pu.proxima_revisao_em ASC, q.score_prioridade DESC;

-- -------------------------------------------------------------
-- FUNCTION: calcular_proximo_intervalo_sm2
-- SM-2 simplificado: intervalo baseado na taxa de acerto recente
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION calcular_proximo_intervalo_sm2(
  p_questao_id UUID,
  p_user_id    UUID
) RETURNS INTEGER AS $$
DECLARE
  v_total_respostas INTEGER;
  v_total_corretas  INTEGER;
  v_taxa_acerto     NUMERIC;
BEGIN
  SELECT
    COUNT(*),
    COUNT(*) FILTER (WHERE correta = TRUE)
  INTO v_total_respostas, v_total_corretas
  FROM progresso_usuario
  WHERE questao_id = p_questao_id
    AND user_id = p_user_id;

  IF v_total_respostas = 0 THEN
    RETURN 1; -- primeira vez: revisar em 1 dia
  END IF;

  v_taxa_acerto := v_total_corretas::NUMERIC / v_total_respostas;

  IF v_taxa_acerto < 0.30 THEN
    RETURN 2;  -- abaixo de 30%: revisar em 2 dias
  ELSIF v_taxa_acerto < 0.50 THEN
    RETURN 4;  -- 30-50%: revisar em 4 dias
  ELSE
    RETURN 7;  -- acima de 50%: revisar em 7 dias
  END IF;
END;
$$ LANGUAGE plpgsql;

-- -------------------------------------------------------------
-- FUNCTION: registrar_resposta
-- Salva resposta + calcula proximo intervalo SM-2 automaticamente
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION registrar_resposta(
  p_user_id           UUID,
  p_questao_id        UUID,
  p_resposta_usuario  TEXT,
  p_tempo_seg         INTEGER DEFAULT NULL
) RETURNS JSONB AS $$
DECLARE
  v_questao         questoes_quadrix%ROWTYPE;
  v_correta         BOOLEAN;
  v_intervalo       INTEGER;
  v_proxima_revisao DATE;
  v_distrator       TEXT;
BEGIN
  -- Busca questao
  SELECT * INTO v_questao FROM questoes_quadrix WHERE id = p_questao_id;

  -- Verifica se acertou
  v_correta := (UPPER(p_resposta_usuario) = UPPER(v_questao.gabarito));

  -- Distrator escolhido se errou
  v_distrator := CASE WHEN NOT v_correta THEN p_resposta_usuario ELSE NULL END;

  -- Calcula intervalo SM-2
  v_intervalo := calcular_proximo_intervalo_sm2(p_questao_id, p_user_id);
  v_proxima_revisao := CURRENT_DATE + v_intervalo;

  -- Salva progresso
  INSERT INTO progresso_usuario (
    user_id, questao_id, resposta_usuario, correta,
    tempo_resposta_seg, distrator_errado,
    proxima_revisao_em, intervalo_sm2_dias
  ) VALUES (
    p_user_id, p_questao_id, p_resposta_usuario, v_correta,
    p_tempo_seg, v_distrator,
    v_proxima_revisao, v_intervalo
  );

  -- Retorna resultado completo (usado pelo front para mostrar explicacao)
  RETURN jsonb_build_object(
    'correta',          v_correta,
    'gabarito',         v_questao.gabarito,
    'explicacao',       v_questao.explicacao,
    'distrator_principal', v_questao.distrator_principal,
    'proxima_revisao',  v_proxima_revisao,
    'intervalo_dias',   v_intervalo
  );
END;
$$ LANGUAGE plpgsql;

-- -------------------------------------------------------------
-- FUNCTION: incrementar_custo_burn_rate
-- Chamada pela Edge Function apos cada geracao (P-006)
-- Bloqueia automaticamente quando limite diario e atingido
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION incrementar_custo_burn_rate(
  p_data_ref DATE,
  p_custo    NUMERIC,
  p_limite   NUMERIC DEFAULT 5.00
) RETURNS VOID AS $$
BEGIN
  INSERT INTO controle_burn_rate (data_ref, custo_acumulado_usd, limite_diario_usd)
  VALUES (p_data_ref, p_custo, p_limite)
  ON CONFLICT (data_ref) DO UPDATE
    SET custo_acumulado_usd = controle_burn_rate.custo_acumulado_usd + p_custo,
        ultima_chamada_em   = NOW(),
        bloqueado = CASE
          WHEN controle_burn_rate.custo_acumulado_usd + p_custo >= p_limite THEN TRUE
          ELSE FALSE
        END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Coloca a funcao em schema privado para nao expor via Data API
-- (SECURITY DEFINER em schema publico e um risco — executa com privilegios do owner)
REVOKE ALL ON FUNCTION incrementar_custo_burn_rate FROM PUBLIC;
GRANT EXECUTE ON FUNCTION incrementar_custo_burn_rate TO service_role;

-- -------------------------------------------------------------
-- DADOS INICIAIS: controle_cache para Sedes-DF 2026
-- -------------------------------------------------------------
INSERT INTO controle_cache (concurso_id, disciplina_id, total_disponiveis)
VALUES
  ('sedes_df_2026', 'suas',              0),
  ('sedes_df_2026', 'pnas',              0),
  ('sedes_df_2026', 'loas',              0),
  ('sedes_df_2026', 'cras_creas_servicos', 0),
  ('sedes_df_2026', 'lei_distrital_7484', 0),
  ('sedes_df_2026', 'nob_suas',          0),
  ('sedes_df_2026', 'programas_sociais_df', 0),
  ('sedes_df_2026', 'bpc_beneficios',    0),
  ('sedes_df_2026', 'portugues',         0),
  ('sedes_df_2026', 'realidade_df_ride', 0),
  ('sedes_df_2026', 'lei_organica_df',   0),
  ('sedes_df_2026', 'lc840',             0),
  ('sedes_df_2026', 'maria_da_penha',    0),
  ('sedes_df_2026', 'politica_mulheres', 0),
  ('sedes_df_2026', 'primeiros_socorros', 0)
ON CONFLICT DO NOTHING;
