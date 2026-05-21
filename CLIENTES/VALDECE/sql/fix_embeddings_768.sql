-- ============================================================
-- FIX: Nulificar embeddings de 768 dims para forçar reembed
-- Rodar no SQL Editor do Supabase (projeto toga-digital-valdece)
-- ============================================================

-- PASSO 1: Diagnóstico
SELECT vector_dims(embedding) as dims, count(*)
FROM documents
WHERE embedding IS NOT NULL
GROUP BY dims;

-- PASSO 2: Nulificar os que têm 768 dims (migrate_data.py copiou embeddings antigos)
-- Rodar após confirmar que há docs com dims = 768
UPDATE documents SET embedding = NULL WHERE vector_dims(embedding) = 768;

-- PASSO 3: Confirmar que só restam 3072
SELECT vector_dims(embedding) as dims, count(*)
FROM documents
WHERE embedding IS NOT NULL
GROUP BY dims;
