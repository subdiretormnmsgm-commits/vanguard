-- =============================================================
-- PROJ-002 Ingrid — Migration Dia 12
-- Loop 5: Contador RPC + Vacina Legislação
-- 2026-05-23 · Executar: Supabase Dashboard → SQL Editor → Run
-- =============================================================

-- ── 1. RPC calcular_pontos_ponderados ────────────────────────
-- Retorna: total acumulado, score %, delta semanal (para [E-1])
CREATE OR REPLACE FUNCTION calcular_pontos_ponderados(p_user_id UUID)
RETURNS TABLE (
  pontos_total           INTEGER,
  score_pct              NUMERIC,
  pontos_esta_semana     INTEGER,
  pontos_semana_passada  INTEGER,
  total_respondidas      INTEGER
) LANGUAGE sql STABLE SECURITY DEFINER AS $$
  WITH base AS (
    SELECT
      p.correta,
      p.respondida_em,
      q.peso_edital
    FROM progresso_usuario p
    JOIN questoes_quadrix q ON q.id = p.questao_id
    WHERE p.user_id = p_user_id
      AND p.correta IS NOT NULL
  )
  SELECT
    COALESCE(SUM(peso_edital) FILTER (WHERE correta), 0)::INTEGER        AS pontos_total,
    CASE
      WHEN COALESCE(SUM(peso_edital), 0) > 0
      THEN ROUND(100.0 * COALESCE(SUM(peso_edital) FILTER (WHERE correta), 0) / SUM(peso_edital), 1)
      ELSE 0
    END                                                                   AS score_pct,
    COALESCE(SUM(peso_edital) FILTER (
      WHERE correta AND respondida_em >= NOW() - INTERVAL '7 days'
    ), 0)::INTEGER                                                        AS pontos_esta_semana,
    COALESCE(SUM(peso_edital) FILTER (
      WHERE correta
        AND respondida_em >= NOW() - INTERVAL '14 days'
        AND respondida_em <  NOW() - INTERVAL '7 days'
    ), 0)::INTEGER                                                        AS pontos_semana_passada,
    COUNT(*)::INTEGER                                                     AS total_respondidas
  FROM base
$$;

GRANT EXECUTE ON FUNCTION calcular_pontos_ponderados(UUID) TO anon, authenticated;

-- ── 2. Coluna vacina_legislacao ───────────────────────────────
ALTER TABLE questoes_quadrix
  ADD COLUMN IF NOT EXISTS vacina_legislacao BOOLEAN NOT NULL DEFAULT FALSE;

-- Marcar disciplinas de legislação recente
UPDATE questoes_quadrix
SET vacina_legislacao = TRUE
WHERE disciplina_id IN ('lc840', 'maria_da_penha', 'politica_mulheres', 'lei_organica_df');

-- ── 3. Verificar ──────────────────────────────────────────────
SELECT
  disciplina_id,
  COUNT(*) FILTER (WHERE vacina_legislacao) AS com_vacina,
  COUNT(*)                                  AS total
FROM questoes_quadrix
WHERE concurso_id = 'sedes_df_2026'
GROUP BY disciplina_id
ORDER BY disciplina_id;
