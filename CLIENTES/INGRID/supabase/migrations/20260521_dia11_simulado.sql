-- ── DIA 11: Micro-Simulado ──────────────────────────────────────────────────
-- get_questoes_simulado: retorna N questões aleatórias para modo simulado
-- Sem SM-2, sem filtro de revisão — simula ritmo real da prova Quadrix

CREATE OR REPLACE FUNCTION get_questoes_simulado(
  p_user_id  UUID,
  p_quantidade INTEGER DEFAULT 10
)
RETURNS JSONB LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
BEGIN
  RETURN (
    SELECT COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'id',            q.id,
          'enunciado',     q.enunciado,
          'gabarito',      q.gabarito,
          'disciplina_id', q.disciplina_id,
          'peso_edital',   q.peso_edital,
          'alternativas',  q.alternativas,
          'explicacao',    q.explicacao
        )
      ),
      '[]'::jsonb
    )
    FROM (
      SELECT id, enunciado, gabarito, disciplina_id, peso_edital, alternativas, explicacao
      FROM questoes_quadrix
      ORDER BY random()
      LIMIT p_quantidade
    ) q
  );
END; $$;

GRANT EXECUTE ON FUNCTION get_questoes_simulado(UUID, INTEGER) TO anon;
GRANT EXECUTE ON FUNCTION get_questoes_simulado(UUID, INTEGER) TO authenticated;
