-- ============================================================
-- SCHEMA UPDATE — Dia 3
-- Adicionar: tema TEXT + corpus_gap FLOAT
-- Executar sobre o schema do Dia 1 (schema.sql já aplicado)
-- ============================================================

-- Lei 7: tema = fundação do Radar de Divergência (V2)
alter table documents
  add column if not exists tema text default 'outros';

-- 8 categorias penais calibradas para Direito Penal brasileiro
-- 'trafico' | 'vida' | 'patrimonio' | 'habeas_corpus' |
-- 'dosimetria' | 'nulidade' | 'corrupcao' | 'outros'

-- corpus_gap: registra quando similarity < 0.50 (corpus fraco naquele tema)
alter table search_logs
  add column if not exists corpus_gap float default null;

-- Índice para análise de gap por tema (Radar de Divergência V2)
create index if not exists documents_tema_idx on documents (tema);
