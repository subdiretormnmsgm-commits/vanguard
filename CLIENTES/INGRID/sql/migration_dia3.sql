-- =============================================================
-- PROJ-002 Ingrid — Migration Dia 3
-- P-024: corrige discipline IDs para Cargo 202 (Tecnico Administrativo)
-- Adiciona coluna pilula_do_dia para exibicao no feed
-- Executar: Supabase Dashboard → SQL Editor → Run
-- =============================================================

-- 1. Adicionar coluna pilula_do_dia (dica rapida exibida antes da questao)
ALTER TABLE questoes_quadrix
  ADD COLUMN IF NOT EXISTS pilula_do_dia TEXT;

-- 2. Remover registros de controle_cache com disciplinas antigas (cargo social)
DELETE FROM controle_cache
WHERE concurso_id = 'sedes_df_2026'
  AND disciplina_id IN (
    'suas', 'pnas', 'loas', 'cras_creas_servicos',
    'lei_distrital_7484', 'nob_suas', 'programas_sociais_df', 'bpc_beneficios'
  );

-- 3. Inserir disciplinas corretas do Cargo 202
INSERT INTO controle_cache (concurso_id, disciplina_id, total_disponiveis)
VALUES
  -- Peso 2 — Conhecimentos Especificos
  ('sedes_df_2026', 'suas_fundamentos',                0),
  ('sedes_df_2026', 'programas_beneficios_df',         0),
  ('sedes_df_2026', 'direito_administrativo',          0),
  ('sedes_df_2026', 'direito_constitucional',          0),
  ('sedes_df_2026', 'arquivologia_rotinas_atendimento',0),
  ('sedes_df_2026', 'recursos_materiais_patrimonio',   0),
  -- Peso 1 — Conhecimentos Gerais (manter os corretos)
  ('sedes_df_2026', 'portugues',                       0),
  ('sedes_df_2026', 'realidade_df_ride',               0),
  ('sedes_df_2026', 'lei_organica_df',                 0),
  ('sedes_df_2026', 'lc840',                           0),
  ('sedes_df_2026', 'maria_da_penha',                  0),
  ('sedes_df_2026', 'politica_mulheres',               0),
  ('sedes_df_2026', 'primeiros_socorros',               0)
ON CONFLICT (concurso_id, disciplina_id) DO NOTHING;

-- 4. Remover questoes geradas com disciplinas antigas (se houver)
--    CUIDADO: so rodar se o Gate Dia 2 usou disciplinas antigas
--    Comentar se as questoes do gate ja estao corretas
-- DELETE FROM questoes_quadrix
-- WHERE concurso_id = 'sedes_df_2026'
--   AND disciplina_id IN ('suas','pnas','loas','cras_creas_servicos',
--                         'lei_distrital_7484','nob_suas','programas_sociais_df','bpc_beneficios');

-- 5. Indice para pilula_do_dia (facilita selecao no feed)
CREATE INDEX IF NOT EXISTS idx_questoes_disciplina_peso
  ON questoes_quadrix (concurso_id, disciplina_id, peso_edital, score_prioridade DESC);

-- 6. Verificar estado apos migration
SELECT disciplina_id, COUNT(*) as total
FROM questoes_quadrix
WHERE concurso_id = 'sedes_df_2026'
GROUP BY disciplina_id
ORDER BY disciplina_id;
