-- ============================================================
-- PROJ-002 Ingrid — Migração Dia 10 (Loop 4)
-- get_heatmap_disciplinas — Mapa de Soberania
-- ============================================================

-- RPC get_heatmap_disciplinas — alimenta o Mapa de Soberania na UI
-- Retorna por disciplina: taxa acerto, inatividade, urgência, nível
-- Urgência = 60% acerto inverso + 40% inatividade (janela 30 dias)
-- Mínimo 3 respostas por disciplina para aparecer no heatmap
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_heatmap_disciplinas(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
BEGIN
  RETURN (
    SELECT COALESCE(jsonb_agg(
      jsonb_build_object(
        'disciplina_id',      disciplina_id,
        'total_respondidas',  total_respondidas,
        'total_corretas',     total_corretas,
        'taxa_acerto_pct',    taxa_acerto_pct,
        'ultima_atividade',   ultima_atividade,
        'dias_sem_atividade', dias_sem_atividade,
        'revisoes_pendentes', revisoes_pendentes,
        'urgencia',           urgencia,
        'nivel',              nivel
      )
      ORDER BY urgencia DESC
    ), '[]'::jsonb)
    FROM (
      SELECT
        p.disciplina_id,
        COUNT(*)::INTEGER                                                          AS total_respondidas,
        COUNT(*) FILTER (WHERE p.correta)::INTEGER                                AS total_corretas,
        ROUND(
          COUNT(*) FILTER (WHERE p.correta)::NUMERIC / NULLIF(COUNT(*), 0) * 100,
          1
        )                                                                          AS taxa_acerto_pct,
        MAX(p.respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE               AS ultima_atividade,
        (CURRENT_DATE - MAX(p.respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE)
                                                                                   AS dias_sem_atividade,
        COUNT(*) FILTER (
          WHERE p.proxima_revisao_em IS NOT NULL
            AND p.proxima_revisao_em <= CURRENT_DATE
            AND NOT p.correta
        )::INTEGER                                                                 AS revisoes_pendentes,
        -- urgencia: 60% acerto inverso + 40% inatividade (max 30 dias)
        ROUND(
          LEAST(1.0,
            (1.0 - COUNT(*) FILTER (WHERE p.correta)::NUMERIC
                   / NULLIF(COUNT(*), 0)) * 0.6
            + LEAST(1.0,
                (CURRENT_DATE - MAX(p.respondida_em AT TIME ZONE 'America/Sao_Paulo')::DATE
                )::NUMERIC / 30
              ) * 0.4
          ),
          3
        )                                                                          AS urgencia,
        CASE
          WHEN ROUND(COUNT(*) FILTER (WHERE p.correta)::NUMERIC
                     / NULLIF(COUNT(*), 0) * 100, 1) >= 75 THEN 'forte'
          WHEN ROUND(COUNT(*) FILTER (WHERE p.correta)::NUMERIC
                     / NULLIF(COUNT(*), 0) * 100, 1) >= 50 THEN 'medio'
          ELSE 'fraco'
        END                                                                        AS nivel
      FROM progresso_usuario p
      WHERE p.user_id = p_user_id
      GROUP BY p.disciplina_id
      HAVING COUNT(*) >= 3
    ) sub
  );
END;
$$;

GRANT EXECUTE ON FUNCTION get_heatmap_disciplinas(UUID) TO anon;
GRANT EXECUTE ON FUNCTION get_heatmap_disciplinas(UUID) TO authenticated;


-- ============================================================
-- GATE CLI — verificação pós-migração
-- ============================================================
-- SELECT proname FROM pg_proc WHERE proname = 'get_heatmap_disciplinas';
--
-- Teste com dados reais (substitua o UUID pelo user_id da Ingrid):
-- SELECT get_heatmap_disciplinas('00000000-0000-0000-0000-000000000001');
-- ============================================================
