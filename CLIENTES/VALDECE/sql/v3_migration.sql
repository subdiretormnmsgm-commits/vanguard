-- ============================================================
-- V3 MIGRATION — Toga Digital Valdece — 2026-05-20
-- Adiciona campos de metadata vinculante ao corpus existente
-- Rodar no SQL Editor do Supabase (conta Vanguard primeiro, depois Valdece)
-- ============================================================

-- PASSO 1: Adicionar colunas
ALTER TABLE documents
  ADD COLUMN IF NOT EXISTS data_dje            date,
  ADD COLUMN IF NOT EXISTS repercussao_geral   boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS recurso_repetitivo  boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS turma               text;

-- PASSO 2: Atualizar search_documents() para retornar novos campos
CREATE OR REPLACE FUNCTION search_documents(
  query_embedding      vector(768),
  match_count          int     DEFAULT 10,
  similarity_threshold float   DEFAULT 0.65
)
RETURNS TABLE (
  id                  bigint,
  tribunal            text,
  numero_acordao      text,
  ementa              text,
  content             text,
  link                text,
  data_julgamento     date,
  data_dje            date,
  repercussao_geral   boolean,
  recurso_repetitivo  boolean,
  turma               text,
  similarity          float
)
LANGUAGE sql STABLE
AS $$
  SELECT
    id, tribunal, numero_acordao, ementa, content, link,
    data_julgamento, data_dje, repercussao_geral, recurso_repetitivo, turma,
    1 - (embedding <=> query_embedding) AS similarity
  FROM documents
  WHERE
    embedding IS NOT NULL
    AND 1 - (embedding <=> query_embedding) > similarity_threshold
  ORDER BY embedding <=> query_embedding
  LIMIT match_count;
$$;

-- PASSO 3: Índices para filtros V3 (badges e busca futura)
CREATE INDEX IF NOT EXISTS documents_repercussao_idx ON documents (repercussao_geral) WHERE repercussao_geral = true;
CREATE INDEX IF NOT EXISTS documents_repetitivo_idx  ON documents (recurso_repetitivo) WHERE recurso_repetitivo = true;

-- VERIFICAÇÃO — rodar após o script
-- SELECT column_name, data_type FROM information_schema.columns
--   WHERE table_name = 'documents' ORDER BY ordinal_position;
-- SELECT count(*) as total,
--        sum(case when repercussao_geral then 1 else 0 end) as com_repercussao,
--        sum(case when recurso_repetitivo then 1 else 0 end) as repetitivos
-- FROM documents;
