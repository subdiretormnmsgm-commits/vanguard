-- =============================================================
-- PROJ-002 INGRID — MIGRAÇÃO COMPLETA PARA SUPABASE PRÓPRIO
-- P-013 Soberania — Dia 15 (29-05-2026 sexta-feira)
-- Versão: v1 | Executar UMA VEZ no Supabase SQL Editor da Ingrid
-- =============================================================
-- INSTRUÇÕES:
-- 1. Abrir supabase.com → seu projeto → SQL Editor
-- 2. Colar TODO o conteúdo deste arquivo
-- 3. Clicar RUN
-- 4. Verificar output: deve mostrar linhas sem erros
-- Tempo estimado: ~30 segundos
-- =============================================================

-- ─────────────────────────────────────────────────────────────
-- BLOCO 1 — TABELA BASE: questoes_quadrix
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS questoes_quadrix (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  concurso_id         TEXT NOT NULL,
  disciplina_id       TEXT NOT NULL,
  peso_edital         INTEGER NOT NULL CHECK (peso_edital IN (1, 2)),
  score_prioridade    INTEGER,
  enunciado           TEXT NOT NULL,
  alternativas        JSONB NOT NULL,
  gabarito            TEXT NOT NULL,
  explicacao          TEXT NOT NULL,
  distrator_principal TEXT,
  nivel_dificuldade   INTEGER CHECK (nivel_dificuldade BETWEEN 1 AND 5),
  estilo_quadrix      TEXT[],
  tipo_pegadinha      TEXT CHECK (tipo_pegadinha IN (
                        'prescinde', 'salvo', 'nunca', 'sempre',
                        'dupla_negativa', 'outro')),
  vacina_legislacao   BOOLEAN NOT NULL DEFAULT FALSE,
  criada_em           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  criada_por          TEXT DEFAULT 'claude_api'
);

CREATE INDEX IF NOT EXISTS idx_questoes_concurso_disciplina
  ON questoes_quadrix (concurso_id, disciplina_id);

CREATE INDEX IF NOT EXISTS idx_questoes_score
  ON questoes_quadrix (concurso_id, score_prioridade DESC);

-- ─────────────────────────────────────────────────────────────
-- BLOCO 2 — TABELA: progresso_usuario
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS progresso_usuario (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL,
  questao_id            UUID NOT NULL REFERENCES questoes_quadrix(id) ON DELETE CASCADE,
  respondida_em         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resposta_usuario      TEXT NOT NULL,
  correta               BOOLEAN NOT NULL,
  tempo_resposta_seg    INTEGER,
  distrator_errado      TEXT,
  proxima_revisao_em    DATE,
  intervalo_sm2_dias    INTEGER DEFAULT 1,
  disciplina_id         TEXT,
  tempo_resposta_ms     INTEGER,
  distrator_escolhido   TEXT,
  nivel_tutor_disparado INTEGER,
  acerto_provavel_chute BOOLEAN DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS idx_progresso_revisao
  ON progresso_usuario (user_id, proxima_revisao_em);

CREATE INDEX IF NOT EXISTS idx_progresso_questao
  ON progresso_usuario (user_id, questao_id);

CREATE INDEX IF NOT EXISTS idx_progresso_usuario_ultimo_erro
  ON progresso_usuario (user_id, correta, respondida_em DESC)
  WHERE correta = false;

CREATE INDEX IF NOT EXISTS idx_progresso_usuario_distrator
  ON progresso_usuario (user_id, disciplina_id, distrator_escolhido)
  WHERE distrator_escolhido IS NOT NULL;

-- ─────────────────────────────────────────────────────────────
-- BLOCO 3 — TABELAS AUXILIARES
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS controle_cache (
  concurso_id           TEXT NOT NULL,
  disciplina_id         TEXT NOT NULL,
  total_disponiveis     INTEGER NOT NULL DEFAULT 0,
  ultima_geracao_em     TIMESTAMPTZ,
  geracao_em_progresso  BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (concurso_id, disciplina_id)
);

CREATE TABLE IF NOT EXISTS controle_burn_rate (
  data_ref            DATE NOT NULL DEFAULT CURRENT_DATE PRIMARY KEY,
  custo_acumulado_usd NUMERIC(8, 4) NOT NULL DEFAULT 0,
  limite_diario_usd   NUMERIC(8, 4) NOT NULL DEFAULT 5.00,
  bloqueado           BOOLEAN NOT NULL DEFAULT FALSE,
  ultima_chamada_em   TIMESTAMPTZ
);

INSERT INTO controle_burn_rate (data_ref)
VALUES (CURRENT_DATE)
ON CONFLICT (data_ref) DO NOTHING;

CREATE TABLE IF NOT EXISTS termos_aceitos (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id      UUID NOT NULL,
  accepted_at  TIMESTAMPTZ NOT NULL,
  versao_termo TEXT NOT NULL,
  hash_sha256  TEXT NOT NULL,
  UNIQUE (user_id, versao_termo)
);

CREATE TABLE IF NOT EXISTS explicacao_tutor (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  questao_id  TEXT NOT NULL,
  nivel       INTEGER NOT NULL CHECK (nivel BETWEEN 1 AND 3),
  distrator   TEXT NOT NULL DEFAULT '',
  explicacao  TEXT NOT NULL,
  cached_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (questao_id, nivel, distrator)
);

CREATE TABLE IF NOT EXISTS abandonment_log (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id      UUID NOT NULL,
  questao_id   TEXT NOT NULL,
  viewed_at    TIMESTAMPTZ NOT NULL,
  abandoned_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS sessoes_usuario (
  id                   UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id              UUID NOT NULL,
  iniciada_em          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  encerrada_em         TIMESTAMPTZ,
  questoes_respondidas INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_sessoes_user_iniciada
  ON sessoes_usuario (user_id, iniciada_em DESC);

CREATE TABLE IF NOT EXISTS metricas_diarias (
  id                    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id               UUID NOT NULL,
  data_ref              DATE NOT NULL DEFAULT CURRENT_DATE,
  total_questoes        INTEGER NOT NULL DEFAULT 0,
  total_corretas        INTEGER NOT NULL DEFAULT 0,
  taxa_acerto_pct       NUMERIC(5,2),
  disciplinas_ativas    INTEGER DEFAULT 0,
  disciplina_mais_forte TEXT,
  disciplina_mais_fraca TEXT,
  horario_primeiro_acesso TIME,
  gerado_em             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, data_ref)
);

-- ─────────────────────────────────────────────────────────────
-- BLOCO 4 — RLS (Row Level Security)
-- ─────────────────────────────────────────────────────────────
ALTER TABLE questoes_quadrix     ENABLE ROW LEVEL SECURITY;
ALTER TABLE progresso_usuario    ENABLE ROW LEVEL SECURITY;
ALTER TABLE controle_cache       ENABLE ROW LEVEL SECURITY;
ALTER TABLE controle_burn_rate   ENABLE ROW LEVEL SECURITY;
ALTER TABLE termos_aceitos       ENABLE ROW LEVEL SECURITY;
ALTER TABLE explicacao_tutor     ENABLE ROW LEVEL SECURITY;
ALTER TABLE abandonment_log      ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessoes_usuario      ENABLE ROW LEVEL SECURITY;
ALTER TABLE metricas_diarias     ENABLE ROW LEVEL SECURITY;

-- Políticas
CREATE POLICY "questoes_leitura_publica" ON questoes_quadrix
  FOR SELECT USING (true);

CREATE POLICY "progresso_service_role" ON progresso_usuario
  FOR ALL USING (true);

CREATE POLICY "cache_service_role" ON controle_cache
  FOR ALL USING (true);

CREATE POLICY "burn_rate_service_role" ON controle_burn_rate
  FOR ALL USING (true);

CREATE POLICY "anon le proprios termos" ON termos_aceitos
  FOR SELECT TO anon USING (true);

CREATE POLICY "anon registra aceite" ON termos_aceitos
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "service_role gerencia termos" ON termos_aceitos
  FOR ALL TO service_role USING (true);

CREATE POLICY "anon le cache tutor" ON explicacao_tutor
  FOR SELECT TO anon USING (true);

CREATE POLICY "service_role gerencia cache" ON explicacao_tutor
  FOR ALL TO service_role USING (true);

CREATE POLICY "anon insere abandono" ON abandonment_log
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "service_role gerencia log" ON abandonment_log
  FOR ALL TO service_role USING (true);

CREATE POLICY "anon gerencia proprias sessoes" ON sessoes_usuario
  FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE POLICY "anon le proprias metricas" ON metricas_diarias
  FOR SELECT TO anon USING (true);

CREATE POLICY "service_role gerencia metricas" ON metricas_diarias
  FOR ALL TO service_role USING (true);

-- ─────────────────────────────────────────────────────────────
-- BLOCO 5 — VIEWS
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW questoes_nao_respondidas
  WITH (security_invoker = true)
AS
SELECT q.*
FROM questoes_quadrix q
WHERE q.concurso_id = 'sedes_df_2026'
  AND q.id NOT IN (
    SELECT questao_id FROM progresso_usuario
    WHERE user_id = '00000000-0000-0000-0000-000000000001'
  )
ORDER BY q.score_prioridade DESC;

CREATE OR REPLACE VIEW questoes_para_revisao
  WITH (security_invoker = true)
AS
SELECT
  pu.questao_id, q.disciplina_id, q.peso_edital, q.score_prioridade,
  pu.proxima_revisao_em, pu.intervalo_sm2_dias
FROM progresso_usuario pu
JOIN questoes_quadrix q ON q.id = pu.questao_id
WHERE pu.user_id = '00000000-0000-0000-0000-000000000001'
  AND pu.proxima_revisao_em <= CURRENT_DATE
ORDER BY pu.proxima_revisao_em ASC, q.score_prioridade DESC;

CREATE OR REPLACE VIEW vw_curva_distrator AS
SELECT user_id, disciplina_id, distrator_escolhido, nivel_tutor_disparado,
  COUNT(*) AS total_ocorrencias,
  MIN(respondida_em) AS primeira_vez, MAX(respondida_em) AS ultima_vez
FROM progresso_usuario
WHERE distrator_escolhido IS NOT NULL
GROUP BY user_id, disciplina_id, distrator_escolhido, nivel_tutor_disparado
ORDER BY total_ocorrencias DESC;

-- ─────────────────────────────────────────────────────────────
-- BLOCO 6 — FUNCTIONS RPCs
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION calcular_proximo_intervalo_sm2(
  p_questao_id UUID, p_user_id UUID
) RETURNS INTEGER AS $$
DECLARE v_total INTEGER; v_corretas INTEGER; v_taxa NUMERIC;
BEGIN
  SELECT COUNT(*), COUNT(*) FILTER (WHERE correta = TRUE)
  INTO v_total, v_corretas
  FROM progresso_usuario
  WHERE questao_id = p_questao_id AND user_id = p_user_id;
  IF v_total = 0 THEN RETURN 1; END IF;
  v_taxa := v_corretas::NUMERIC / v_total;
  IF v_taxa < 0.30 THEN RETURN 2;
  ELSIF v_taxa < 0.50 THEN RETURN 4;
  ELSE RETURN 7; END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION registrar_resposta(
  p_user_id UUID, p_questao_id UUID,
  p_resposta_usuario TEXT, p_tempo_seg INTEGER DEFAULT NULL
) RETURNS JSONB AS $$
DECLARE
  v_questao questoes_quadrix%ROWTYPE;
  v_correta BOOLEAN; v_intervalo INTEGER;
  v_proxima_revisao DATE; v_distrator TEXT;
BEGIN
  SELECT * INTO v_questao FROM questoes_quadrix WHERE id = p_questao_id;
  v_correta := (UPPER(p_resposta_usuario) = UPPER(v_questao.gabarito));
  v_distrator := CASE WHEN NOT v_correta THEN p_resposta_usuario ELSE NULL END;
  v_intervalo := calcular_proximo_intervalo_sm2(p_questao_id, p_user_id);
  v_proxima_revisao := CURRENT_DATE + v_intervalo;
  INSERT INTO progresso_usuario (
    user_id, questao_id, resposta_usuario, correta,
    tempo_resposta_seg, distrator_errado, proxima_revisao_em, intervalo_sm2_dias
  ) VALUES (
    p_user_id, p_questao_id, p_resposta_usuario, v_correta,
    p_tempo_seg, v_distrator, v_proxima_revisao, v_intervalo
  );
  RETURN jsonb_build_object(
    'correta', v_correta, 'gabarito', v_questao.gabarito,
    'explicacao', v_questao.explicacao,
    'distrator_principal', v_questao.distrator_principal,
    'proxima_revisao', v_proxima_revisao, 'intervalo_dias', v_intervalo
  );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION incrementar_custo_burn_rate(
  p_data_ref DATE, p_custo NUMERIC, p_limite NUMERIC DEFAULT 5.00
) RETURNS VOID AS $$
BEGIN
  INSERT INTO controle_burn_rate (data_ref, custo_acumulado_usd, limite_diario_usd)
  VALUES (p_data_ref, p_custo, p_limite)
  ON CONFLICT (data_ref) DO UPDATE SET
    custo_acumulado_usd = controle_burn_rate.custo_acumulado_usd + p_custo,
    ultima_chamada_em = NOW(),
    bloqueado = CASE
      WHEN controle_burn_rate.custo_acumulado_usd + p_custo >= p_limite THEN TRUE
      ELSE FALSE END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

REVOKE ALL ON FUNCTION incrementar_custo_burn_rate FROM PUBLIC;
GRANT EXECUTE ON FUNCTION incrementar_custo_burn_rate TO service_role;

CREATE OR REPLACE FUNCTION get_total_respostas_ingrid(p_user_id UUID)
RETURNS INTEGER LANGUAGE sql SECURITY DEFINER STABLE AS $$
  SELECT COALESCE(COUNT(*)::INTEGER, 0) FROM progresso_usuario WHERE user_id = p_user_id;
$$;
GRANT EXECUTE ON FUNCTION get_total_respostas_ingrid(UUID) TO anon, authenticated;

CREATE OR REPLACE FUNCTION get_progresso_semanal(p_user_id UUID)
RETURNS JSONB LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
DECLARE v_total INTEGER; v_corretas INTEGER; v_forte TEXT; v_fraca TEXT;
BEGIN
  SELECT COUNT(*)::INTEGER, COUNT(*) FILTER (WHERE correta)::INTEGER
  INTO v_total, v_corretas
  FROM progresso_usuario
  WHERE user_id = p_user_id AND respondida_em >= NOW() - INTERVAL '7 days';
  SELECT disciplina_id INTO v_forte
  FROM progresso_usuario WHERE user_id = p_user_id
    AND respondida_em >= NOW() - INTERVAL '7 days'
  GROUP BY disciplina_id HAVING COUNT(*) >= 5
  ORDER BY COUNT(*) FILTER (WHERE correta)::NUMERIC / COUNT(*) DESC LIMIT 1;
  SELECT disciplina_id INTO v_fraca
  FROM progresso_usuario WHERE user_id = p_user_id
    AND respondida_em >= NOW() - INTERVAL '7 days'
  GROUP BY disciplina_id HAVING COUNT(*) >= 5
  ORDER BY COUNT(*) FILTER (WHERE correta)::NUMERIC / COUNT(*) ASC LIMIT 1;
  RETURN jsonb_build_object(
    'total_questoes_semana', COALESCE(v_total, 0),
    'total_corretas_semana', COALESCE(v_corretas, 0),
    'taxa_acerto_pct', CASE WHEN v_total > 0 THEN ROUND((v_corretas::NUMERIC/v_total)*100,1) ELSE 0 END,
    'disciplina_mais_forte', COALESCE(v_forte,'insuficiente'),
    'disciplina_mais_fraca', COALESCE(v_fraca,'insuficiente'),
    'periodo_inicio', (NOW()-INTERVAL '7 days')::DATE,
    'periodo_fim', NOW()::DATE
  );
END;
$$;
GRANT EXECUTE ON FUNCTION get_progresso_semanal(UUID) TO anon, authenticated;

CREATE OR REPLACE FUNCTION gerar_snapshot_diario(
  p_user_id UUID, p_data DATE DEFAULT CURRENT_DATE - 1
) RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_total INTEGER; v_corretas INTEGER; v_taxa NUMERIC;
  v_disc_qt INTEGER; v_forte TEXT; v_fraca TEXT; v_hora TIME;
BEGIN
  SELECT COUNT(*)::INTEGER, COUNT(*) FILTER (WHERE correta)::INTEGER,
    COUNT(DISTINCT disciplina_id)::INTEGER,
    MIN(respondida_em AT TIME ZONE 'America/Sao_Paulo')::TIME
  INTO v_total, v_corretas, v_disc_qt, v_hora
  FROM progresso_usuario WHERE user_id = p_user_id
    AND (respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE = p_data;
  IF v_total = 0 THEN RETURN; END IF;
  v_taxa := ROUND((v_corretas::NUMERIC / v_total) * 100, 2);
  SELECT disciplina_id INTO v_forte
  FROM progresso_usuario WHERE user_id = p_user_id
    AND (respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE = p_data
  GROUP BY disciplina_id HAVING COUNT(*) >= 3
  ORDER BY COUNT(*) FILTER (WHERE correta)::NUMERIC / COUNT(*) DESC LIMIT 1;
  SELECT disciplina_id INTO v_fraca
  FROM progresso_usuario WHERE user_id = p_user_id
    AND (respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE = p_data
  GROUP BY disciplina_id HAVING COUNT(*) >= 3
  ORDER BY COUNT(*) FILTER (WHERE correta)::NUMERIC / COUNT(*) ASC LIMIT 1;
  INSERT INTO metricas_diarias (
    user_id, data_ref, total_questoes, total_corretas, taxa_acerto_pct,
    disciplinas_ativas, disciplina_mais_forte, disciplina_mais_fraca, horario_primeiro_acesso
  ) VALUES (p_user_id, p_data, v_total, v_corretas, v_taxa, v_disc_qt, v_forte, v_fraca, v_hora)
  ON CONFLICT (user_id, data_ref) DO UPDATE SET
    total_questoes = EXCLUDED.total_questoes, total_corretas = EXCLUDED.total_corretas,
    taxa_acerto_pct = EXCLUDED.taxa_acerto_pct, disciplinas_ativas = EXCLUDED.disciplinas_ativas,
    disciplina_mais_forte = EXCLUDED.disciplina_mais_forte,
    disciplina_mais_fraca = EXCLUDED.disciplina_mais_fraca,
    horario_primeiro_acesso = EXCLUDED.horario_primeiro_acesso, gerado_em = NOW();
END;
$$;
GRANT EXECUTE ON FUNCTION gerar_snapshot_diario(UUID, DATE) TO service_role;

CREATE OR REPLACE FUNCTION get_heatmap_disciplinas(p_user_id UUID)
RETURNS JSONB LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
BEGIN
  RETURN (
    SELECT COALESCE(jsonb_agg(
      jsonb_build_object(
        'disciplina_id', disciplina_id, 'total_respondidas', total_respondidas,
        'total_corretas', total_corretas, 'taxa_acerto_pct', taxa_acerto_pct,
        'ultima_atividade', ultima_atividade, 'dias_sem_atividade', dias_sem_atividade,
        'revisoes_pendentes', revisoes_pendentes, 'urgencia', urgencia, 'nivel', nivel
      ) ORDER BY urgencia DESC
    ), '[]'::jsonb)
    FROM (
      SELECT p.disciplina_id,
        COUNT(*)::INTEGER AS total_respondidas,
        COUNT(*) FILTER (WHERE p.correta)::INTEGER AS total_corretas,
        ROUND(COUNT(*) FILTER (WHERE p.correta)::NUMERIC / NULLIF(COUNT(*), 0) * 100, 1) AS taxa_acerto_pct,
        MAX(p.respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE AS ultima_atividade,
        (CURRENT_DATE - MAX(p.respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE) AS dias_sem_atividade,
        COUNT(*) FILTER (WHERE p.proxima_revisao_em IS NOT NULL
          AND p.proxima_revisao_em <= CURRENT_DATE AND NOT p.correta)::INTEGER AS revisoes_pendentes,
        ROUND(LEAST(1.0,
          (1.0 - COUNT(*) FILTER (WHERE p.correta)::NUMERIC / NULLIF(COUNT(*),0)) * 0.6
          + LEAST(1.0,
              (CURRENT_DATE - MAX(p.respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE)::NUMERIC / 30
            ) * 0.4
        ), 3) AS urgencia,
        CASE
          WHEN ROUND(COUNT(*) FILTER (WHERE p.correta)::NUMERIC / NULLIF(COUNT(*),0)*100,1) >= 75 THEN 'forte'
          WHEN ROUND(COUNT(*) FILTER (WHERE p.correta)::NUMERIC / NULLIF(COUNT(*),0)*100,1) >= 50 THEN 'medio'
          ELSE 'fraco' END AS nivel
      FROM progresso_usuario p WHERE p.user_id = p_user_id
      GROUP BY p.disciplina_id HAVING COUNT(*) >= 3
    ) sub
  );
END;
$$;
GRANT EXECUTE ON FUNCTION get_heatmap_disciplinas(UUID) TO anon, authenticated;

CREATE OR REPLACE FUNCTION get_questoes_simulado(
  p_user_id UUID, p_quantidade INTEGER DEFAULT 10
) RETURNS JSONB LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
BEGIN
  RETURN (
    SELECT COALESCE(jsonb_agg(jsonb_build_object(
      'id', q.id, 'enunciado', q.enunciado, 'gabarito', q.gabarito,
      'disciplina_id', q.disciplina_id, 'peso_edital', q.peso_edital,
      'alternativas', q.alternativas, 'explicacao', q.explicacao
    )), '[]'::jsonb)
    FROM (
      SELECT id, enunciado, gabarito, disciplina_id, peso_edital, alternativas, explicacao
      FROM questoes_quadrix ORDER BY random() LIMIT p_quantidade
    ) q
  );
END;
$$;
GRANT EXECUTE ON FUNCTION get_questoes_simulado(UUID, INTEGER) TO anon, authenticated;

CREATE OR REPLACE FUNCTION calcular_pontos_ponderados(p_user_id UUID)
RETURNS TABLE (
  pontos_total INTEGER, score_pct NUMERIC,
  pontos_esta_semana INTEGER, pontos_semana_passada INTEGER,
  total_respondidas INTEGER
) LANGUAGE sql STABLE SECURITY DEFINER AS $$
  WITH base AS (
    SELECT p.correta, p.respondida_em, q.peso_edital
    FROM progresso_usuario p JOIN questoes_quadrix q ON q.id = p.questao_id
    WHERE p.user_id = p_user_id AND p.correta IS NOT NULL
  )
  SELECT
    COALESCE(SUM(peso_edital) FILTER (WHERE correta), 0)::INTEGER,
    CASE WHEN COALESCE(SUM(peso_edital),0) > 0
      THEN ROUND(100.0 * COALESCE(SUM(peso_edital) FILTER (WHERE correta),0) / SUM(peso_edital), 1)
      ELSE 0 END,
    COALESCE(SUM(peso_edital) FILTER (WHERE correta AND respondida_em >= NOW()-INTERVAL '7 days'), 0)::INTEGER,
    COALESCE(SUM(peso_edital) FILTER (
      WHERE correta AND respondida_em >= NOW()-INTERVAL '14 days'
        AND respondida_em < NOW()-INTERVAL '7 days'), 0)::INTEGER,
    COUNT(*)::INTEGER
  FROM base
$$;
GRANT EXECUTE ON FUNCTION calcular_pontos_ponderados(UUID) TO anon, authenticated;

-- ─────────────────────────────────────────────────────────────
-- BLOCO 7 — DADOS INICIAIS: controle_cache
-- ─────────────────────────────────────────────────────────────
INSERT INTO controle_cache (concurso_id, disciplina_id, total_disponiveis)
VALUES
  ('sedes_df_2026', 'portugues',              0),
  ('sedes_df_2026', 'realidade_df_ride',       0),
  ('sedes_df_2026', 'lei_organica_df',         0),
  ('sedes_df_2026', 'lc840',                   0),
  ('sedes_df_2026', 'maria_da_penha',          0),
  ('sedes_df_2026', 'politica_mulheres',       0),
  ('sedes_df_2026', 'primeiros_socorros',      0),
  ('sedes_df_2026', 'suas_fundamentos',        0),
  ('sedes_df_2026', 'programas_beneficios_df', 0),
  ('sedes_df_2026', 'direito_administrativo',  0),
  ('sedes_df_2026', 'arquivologia',            0),
  ('sedes_df_2026', 'direito_constitucional',  0),
  ('sedes_df_2026', 'recursos_materiais',      0)
ON CONFLICT DO NOTHING;

-- ─────────────────────────────────────────────────────────────
-- BLOCO 8 — CRON JOB (snapshot diário 02h)
-- ATENÇÃO: requer Extension pg_cron ativa no Supabase
-- Ativar em: Dashboard → Database → Extensions → pg_cron → Enable
-- ─────────────────────────────────────────────────────────────
-- SELECT cron.schedule(
--   'snapshot_diario_ingrid', '0 2 * * *',
--   $$SELECT gerar_snapshot_diario('00000000-0000-0000-0000-000000000001'::UUID)$$
-- );
-- (descomente a linha acima após ativar pg_cron)

-- ─────────────────────────────────────────────────────────────
-- VERIFICAÇÃO FINAL — Executar para confirmar sucesso:
-- ─────────────────────────────────────────────────────────────
SELECT
  (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public') AS tabelas_criadas,
  (SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema='public') AS funcoes_criadas,
  (SELECT COUNT(*) FROM controle_cache) AS linhas_cache;
-- Esperado: tabelas_criadas >= 9, funcoes_criadas >= 8, linhas_cache = 13
