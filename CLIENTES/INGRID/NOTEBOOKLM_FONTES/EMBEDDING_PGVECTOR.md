# EMBEDDING / PGVECTOR — Problemas e Soluções
**Vanguard Tech · Knowledge Base**
**Última atualização:** 2026-05-21

---

## PROBLEMA: different vector dimensions X and Y

**Mensagem de erro:**
```
Erro na busca: different vector dimensions 3072 and 768
```
ou no Supabase:
```
ERROR: different vector dimensions 3072 and 768
```

**Contexto:** Ao executar busca semântica via frontend após migração de modelo de embedding.

**Árvore de diagnóstico — executar nesta ordem:**

### 1. Verificar dimensões dos dados armazenados
```sql
SELECT vector_dims(embedding) as dims, count(*)
FROM documents
WHERE embedding IS NOT NULL
GROUP BY dims;
```
- **Duas linhas (ex: 768 e 3072)** → documentos com dims mistas → ir para FIX-A
- **Uma linha (ex: só 3072)** → dados OK → ir para passo 2

### 2. Verificar outputDimensionality no frontend
```js
// Cole no console do browser para interceptar o embedding gerado
const orig = window.fetch;
window.fetch = async (...args) => {
  const r = await orig(...args);
  const url = typeof args[0] === 'string' ? args[0] : args[0]?.url;
  if (url?.includes('embedContent'))
    r.clone().json().then(d => d?.embedding?.values &&
      console.log('QUERY DIMS:', d.embedding.values.length));
  return r;
};
```
- **Retornou 768** → causa: `outputDimensionality: 768` hardcoded no frontend → ir para FIX-B
- **Retornou 3072** → frontend OK → ir para passo 3

### 3. Testar função diretamente no Supabase SQL Editor
```sql
SELECT count(*) FROM public.search_documents(
  array_fill(0.001::float4, ARRAY[3072])::vector,
  3, 0.0
);
```
- **Retornou número** → banco OK → problema é cache PostgREST → ir para FIX-C
- **Mesmo erro** → função ou coluna ainda com tipo errado → ir para FIX-D

---

**FIX-A — Nulificar embeddings com dimensão errada e re-embedar:**
```sql
UPDATE documents SET embedding = NULL WHERE vector_dims(embedding) = 768;
```
Depois:
```bash
python backend/reembed.py
```

---

**FIX-B — Corrigir outputDimensionality no frontend:**
```js
// ERRADO
body: JSON.stringify({ ..., outputDimensionality: 768 })

// CORRETO — deve ser igual à dimensão dos documentos armazenados
body: JSON.stringify({ ..., outputDimensionality: 3072 })
```
Depois fazer novo deploy (Netlify: `netlify deploy --prod --dir frontend`).

---

**FIX-C — Forçar reload do schema cache PostgREST:**
```sql
NOTIFY pgrst, 'reload schema';
```
Aguardar ~30s e testar novamente.

---

**FIX-D — Recriar função search_documents com dimensão correta:**
```sql
DROP FUNCTION IF EXISTS public.search_documents(vector(768), int, float);
DROP FUNCTION IF EXISTS public.search_documents(vector(3072), int, float);
DROP FUNCTION IF EXISTS public.search_documents(vector, int, float);

CREATE OR REPLACE FUNCTION public.search_documents(
  query_embedding      vector(3072),
  match_count          int     DEFAULT 10,
  similarity_threshold float   DEFAULT 0.65
)
RETURNS TABLE (
  id bigint, tribunal text, numero_acordao text, ementa text,
  content text, link text, data_julgamento date, data_dje date,
  repercussao_geral boolean, recurso_repetitivo boolean, turma text,
  similarity float
)
LANGUAGE sql STABLE AS $$
  SELECT id, tribunal, numero_acordao, ementa, content, link,
    data_julgamento, data_dje, repercussao_geral, recurso_repetitivo, turma,
    1 - (embedding <=> query_embedding) AS similarity
  FROM documents
  WHERE embedding IS NOT NULL
    AND 1 - (embedding <=> query_embedding) > similarity_threshold
  ORDER BY embedding <=> query_embedding
  LIMIT match_count;
$$;
```

**Verificação:** `SELECT routine_name FROM information_schema.routines WHERE routine_name = 'search_documents';`

**Projeto de origem:** PROJ-001 Valdece V3 · 2026-05-21

---

## PROBLEMA: expected N dimensions, not M (ao fazer ALTER TABLE)

**Mensagem de erro:**
```
ERROR: 22000: expected 768 dimensions, not 3072
```

**Contexto:** Ao rodar `ALTER TABLE documents ALTER COLUMN embedding TYPE vector(3072)` com dados existentes.

**Causa:** A coluna já tem embeddings armazenados com a dimensão antiga. O ALTER não consegue converter automaticamente.

**Solução:**
```sql
-- Passo 1: apagar todos os embeddings existentes
UPDATE documents SET embedding = NULL;

-- Passo 2: alterar o tipo da coluna (agora vazia)
ALTER TABLE documents
  ALTER COLUMN embedding TYPE vector(3072)
  USING embedding::vector(3072);
```
Depois rodar `reembed.py` para reprocessar todos os documentos.

**Verificação:**
```sql
SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) AS tipo_coluna
FROM pg_attribute a JOIN pg_class c ON c.oid = a.attrelid
WHERE c.relname = 'documents' AND a.attname = 'embedding' AND a.attnum > 0;
```

**Projeto de origem:** PROJ-001 Valdece V3 · 2026-05-21

---

## PROBLEMA: HNSW index — column cannot have more than 2000 dimensions

**Mensagem de erro:**
```
ERROR: 54000: column cannot have more than 2000 dimensions for hnsw index
```

**Contexto:** Ao tentar criar índice HNSW em coluna `vector(3072)`.

**Causa:** pgvector limita índices HNSW a 2000 dims. `gemini-embedding-001` usa 3072.

**Solução:** Dropar o índice HNSW antes de alterar a coluna. Para corpus pequeno (< 500 docs), exact scan é suficiente e mais rápido que índice.
```sql
DROP INDEX IF EXISTS documents_embedding_idx;
-- Alterar coluna normalmente
-- NÃO recriar índice HNSW para 3072 dims
```
Para corpus grande (> 500 docs): usar IVFFlat em vez de HNSW (suporta qualquer dimensão).

**Projeto de origem:** PROJ-001 Valdece V3 · 2026-05-21

---

## REFERÊNCIA — Modelos Gemini e dimensões

| Modelo | outputDimensionality padrão | taskType QUERY | taskType DOCUMENT |
|--------|----------------------------|----------------|-------------------|
| `gemini-embedding-001` | 768 (QUERY) / 3072 (DOCUMENT) | 768 | 3072 |
| `text-embedding-004` | 768 | 768 | 768 |

**ALERTA CRÍTICO:** `gemini-embedding-001` retorna dims DIFERENTES por taskType se `outputDimensionality` não for especificado explicitamente. Sempre declarar `outputDimensionality` igual nos dois lados (frontend e reembed.py).
