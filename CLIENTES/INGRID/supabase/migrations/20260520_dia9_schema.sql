-- ============================================================
-- PROJ-002 Ingrid — Migração Dia 9 (Loop 4)
-- Clickwrap V2 · tipo_pegadinha · sessoes_usuario
-- get_progresso_semanal · metricas_diarias · cron snapshot
-- ============================================================

-- 1. TIPO_PEGADINHA — campo M-1 (schema agora, curação no Loop 5)
-- ─────────────────────────────────────────────────────────────
ALTER TABLE questoes_quadrix
  ADD COLUMN IF NOT EXISTS tipo_pegadinha TEXT
  CHECK (tipo_pegadinha IN (
    'prescinde', 'salvo', 'nunca', 'sempre', 'dupla_negativa', 'outro'
  ));

COMMENT ON COLUMN questoes_quadrix.tipo_pegadinha
  IS 'Armadilha léxica da Quadrix. NULL até curação no Loop 5.';


-- 2. SESSOES_USUARIO — rastreia horário de início por sessão (E-4)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sessoes_usuario (
  id                   UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id              UUID        NOT NULL,
  iniciada_em          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  encerrada_em         TIMESTAMPTZ,
  questoes_respondidas INTEGER     NOT NULL DEFAULT 0
);

ALTER TABLE sessoes_usuario ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon gerencia proprias sessoes"
  ON sessoes_usuario FOR ALL TO anon
  USING (true) WITH CHECK (true);

CREATE INDEX IF NOT EXISTS idx_sessoes_user_iniciada
  ON sessoes_usuario (user_id, iniciada_em DESC);


-- 3. RPC get_progresso_semanal — alimenta mensagem WhatsApp de Eduardo (M-2)
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_progresso_semanal(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
DECLARE
  v_total       INTEGER;
  v_corretas    INTEGER;
  v_forte       TEXT;
  v_fraca       TEXT;
BEGIN
  SELECT
    COUNT(*)::INTEGER,
    COUNT(*) FILTER (WHERE correta)::INTEGER
  INTO v_total, v_corretas
  FROM progresso_usuario
  WHERE user_id = p_user_id
    AND respondida_em >= NOW() - INTERVAL '7 days';

  SELECT disciplina_id INTO v_forte
  FROM progresso_usuario
  WHERE user_id = p_user_id
    AND respondida_em >= NOW() - INTERVAL '7 days'
  GROUP BY disciplina_id
  HAVING COUNT(*) >= 5
  ORDER BY COUNT(*) FILTER (WHERE correta)::NUMERIC / COUNT(*) DESC
  LIMIT 1;

  SELECT disciplina_id INTO v_fraca
  FROM progresso_usuario
  WHERE user_id = p_user_id
    AND respondida_em >= NOW() - INTERVAL '7 days'
  GROUP BY disciplina_id
  HAVING COUNT(*) >= 5
  ORDER BY COUNT(*) FILTER (WHERE correta)::NUMERIC / COUNT(*) ASC
  LIMIT 1;

  RETURN jsonb_build_object(
    'total_questoes_semana',   COALESCE(v_total, 0),
    'total_corretas_semana',   COALESCE(v_corretas, 0),
    'taxa_acerto_pct',         CASE WHEN v_total > 0
                                 THEN ROUND((v_corretas::NUMERIC / v_total) * 100, 1)
                                 ELSE 0 END,
    'disciplina_mais_forte',   COALESCE(v_forte, 'insuficiente'),
    'disciplina_mais_fraca',   COALESCE(v_fraca, 'insuficiente'),
    'periodo_inicio',          (NOW() - INTERVAL '7 days')::DATE,
    'periodo_fim',             NOW()::DATE
  );
END;
$$;

GRANT EXECUTE ON FUNCTION get_progresso_semanal(UUID) TO anon;
GRANT EXECUTE ON FUNCTION get_progresso_semanal(UUID) TO authenticated;


-- 4. METRICAS_DIARIAS — snapshot imutável por dia (M-4)
-- Raio-X do Dia 15 lê estes snapshots — não processa raw data
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS metricas_diarias (
  id                      UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id                 UUID        NOT NULL,
  data_ref                DATE        NOT NULL DEFAULT CURRENT_DATE,
  total_questoes          INTEGER     NOT NULL DEFAULT 0,
  total_corretas          INTEGER     NOT NULL DEFAULT 0,
  taxa_acerto_pct         NUMERIC(5,2),
  disciplinas_ativas      INTEGER     DEFAULT 0,
  disciplina_mais_forte   TEXT,
  disciplina_mais_fraca   TEXT,
  horario_primeiro_acesso TIME,
  gerado_em               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, data_ref)
);

ALTER TABLE metricas_diarias ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon le proprias metricas"
  ON metricas_diarias FOR SELECT TO anon
  USING (true);

CREATE POLICY "service_role gerencia metricas"
  ON metricas_diarias FOR ALL TO service_role
  USING (true);


-- 5. FUNCTION gerar_snapshot_diario — chamada pelo cron às 02h (M-4)
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION gerar_snapshot_diario(
  p_user_id UUID,
  p_data    DATE DEFAULT CURRENT_DATE - 1
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_total     INTEGER;
  v_corretas  INTEGER;
  v_taxa      NUMERIC;
  v_disc_qt   INTEGER;
  v_forte     TEXT;
  v_fraca     TEXT;
  v_hora      TIME;
BEGIN
  SELECT
    COUNT(*)::INTEGER,
    COUNT(*) FILTER (WHERE correta)::INTEGER,
    COUNT(DISTINCT disciplina_id)::INTEGER,
    MIN(respondida_em AT TIME ZONE 'America/Sao_Paulo')::TIME
  INTO v_total, v_corretas, v_disc_qt, v_hora
  FROM progresso_usuario
  WHERE user_id = p_user_id
    AND (respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE = p_data;

  IF v_total = 0 THEN RETURN; END IF;

  v_taxa := ROUND((v_corretas::NUMERIC / v_total) * 100, 2);

  SELECT disciplina_id INTO v_forte
  FROM progresso_usuario
  WHERE user_id = p_user_id
    AND (respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE = p_data
  GROUP BY disciplina_id HAVING COUNT(*) >= 3
  ORDER BY COUNT(*) FILTER (WHERE correta)::NUMERIC / COUNT(*) DESC
  LIMIT 1;

  SELECT disciplina_id INTO v_fraca
  FROM progresso_usuario
  WHERE user_id = p_user_id
    AND (respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE = p_data
  GROUP BY disciplina_id HAVING COUNT(*) >= 3
  ORDER BY COUNT(*) FILTER (WHERE correta)::NUMERIC / COUNT(*) ASC
  LIMIT 1;

  INSERT INTO metricas_diarias (
    user_id, data_ref, total_questoes, total_corretas, taxa_acerto_pct,
    disciplinas_ativas, disciplina_mais_forte, disciplina_mais_fraca,
    horario_primeiro_acesso
  ) VALUES (
    p_user_id, p_data, v_total, v_corretas, v_taxa,
    v_disc_qt, v_forte, v_fraca, v_hora
  )
  ON CONFLICT (user_id, data_ref) DO UPDATE SET
    total_questoes          = EXCLUDED.total_questoes,
    total_corretas          = EXCLUDED.total_corretas,
    taxa_acerto_pct         = EXCLUDED.taxa_acerto_pct,
    disciplinas_ativas      = EXCLUDED.disciplinas_ativas,
    disciplina_mais_forte   = EXCLUDED.disciplina_mais_forte,
    disciplina_mais_fraca   = EXCLUDED.disciplina_mais_fraca,
    horario_primeiro_acesso = EXCLUDED.horario_primeiro_acesso,
    gerado_em               = NOW();
END;
$$;

GRANT EXECUTE ON FUNCTION gerar_snapshot_diario(UUID, DATE) TO service_role;


-- 6. CRON JOB — 02h diariamente (requer pg_cron ativo no Supabase)
-- Extensions > pg_cron deve estar habilitado antes de rodar esta linha
-- ─────────────────────────────────────────────────────────────
SELECT cron.schedule(
  'snapshot_diario_ingrid',
  '0 2 * * *',
  $$SELECT gerar_snapshot_diario('00000000-0000-0000-0000-000000000001'::UUID)$$
);


-- ============================================================
-- GATE CLI — verificação pós-migração
-- Copie e rode no Supabase SQL Editor para confirmar:
-- ============================================================
-- SELECT column_name FROM information_schema.columns
--   WHERE table_name = 'questoes_quadrix' AND column_name = 'tipo_pegadinha';
--
-- SELECT table_name FROM information_schema.tables
--   WHERE table_schema = 'public'
--   AND table_name IN ('sessoes_usuario', 'metricas_diarias');
--
-- SELECT proname FROM pg_proc
--   WHERE proname IN ('get_progresso_semanal', 'gerar_snapshot_diario');
--
-- SELECT jobname FROM cron.job WHERE jobname = 'snapshot_diario_ingrid';
-- ============================================================
