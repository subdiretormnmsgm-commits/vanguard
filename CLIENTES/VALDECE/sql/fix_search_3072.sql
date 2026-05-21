-- ============================================================
-- FIX: search_documents() — atualiza parâmetro para vector(3072)
-- Rodar no SQL Editor do Supabase (projeto toga-digital-valdece)
-- ============================================================

-- Dropar a versão antiga (assinatura vector(768) é incompatível com CREATE OR REPLACE)
DROP FUNCTION IF EXISTS search_documents(vector(768), int, float);

-- Recriar com 3072 dims (gemini-embedding-001 atualizado pelo Google)
CREATE OR REPLACE FUNCTION search_documents(
  query_embedding      vector(3072),
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

-- VERIFICAÇÃO
SELECT proname, pg_get_function_arguments(oid)
FROM pg_proc WHERE proname = 'search_documents';
