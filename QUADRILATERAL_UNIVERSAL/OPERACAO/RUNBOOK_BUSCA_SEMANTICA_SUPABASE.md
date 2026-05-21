# RUNBOOK — Busca Semântica Supabase + pgvector
**Vanguard Tech · Válido para todos os nichos de busca semântica**
**Criado:** 2026-05-21 · **Origem:** PROJ-001 Valdece V3

---

## QUANDO USAR ESTE RUNBOOK

Ao encontrar qualquer um dos erros abaixo após deploy, migração de schema ou troca de modelo de embedding:

- `different vector dimensions X and Y`
- `expected N dimensions, not M`
- `ERROR 22000` em ALTER TABLE de coluna vector
- Busca retornando 0 resultados sem erro
- `400 Bad Request` em `/rest/v1/rpc/search_documents`

---

## ÁRVORE DE DIAGNÓSTICO

```
Erro na busca: "different vector dimensions X and Y"
│
├── PASSO 1: Verificar dimensões dos dados armazenados
│   SQL: SELECT vector_dims(embedding) as dims, count(*)
│         FROM documents WHERE embedding IS NOT NULL GROUP BY dims;
│
│   ├── Resultado tem DUAS linhas (ex: 768 e 3072)?
│   │   → CAUSA: Documentos com dimensões mistas
│   │   → AÇÃO: UPDATE documents SET embedding = NULL WHERE vector_dims(embedding) = 768;
│   │            Depois rodar reembed.py
│   │
│   └── Resultado tem UMA linha (ex: só 3072)?
│       → Dados estão OK. Problema é na função ou no schema cache.
│       → IR PARA PASSO 2
│
├── PASSO 2: Verificar assinatura da função search_documents
│   SQL: SELECT proname, pg_get_function_arguments(oid) as assinatura
│         FROM pg_proc WHERE proname = 'search_documents'
│         AND pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public');
│
│   ├── Retornou "vector(768)"?
│   │   → CAUSA: Função com dimensão errada
│   │   → AÇÃO: Ver seção FIX-A abaixo
│   │
│   ├── Retornou "vector" (sem dimensão)?
│   │   → Função genérica — não é o problema
│   │   → IR PARA PASSO 3
│   │
│   └── Retornou vazio?
│       → Função foi dropada mas não recriada
│       → AÇÃO: Ver seção FIX-A abaixo (só o CREATE)
│
├── PASSO 3: Verificar tipo real da coluna embedding
│   SQL: SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) AS tipo_coluna
│         FROM pg_attribute a JOIN pg_class c ON c.oid = a.attrelid
│         WHERE c.relname = 'documents' AND a.attname = 'embedding' AND a.attnum > 0;
│
│   ├── Retornou "vector(768)"?
│   │   → CAUSA: Coluna ainda declarada como 768 dims
│   │   → AÇÃO: Ver seção FIX-B abaixo
│   │
│   └── Retornou "vector(3072)" ou "vector"?
│       → Tipo correto. Problema é no cache do PostgREST.
│       → IR PARA PASSO 4
│
└── PASSO 4: Forçar reload do schema cache PostgREST
    SQL: NOTIFY pgrst, 'reload schema';
    OU: Dashboard Supabase → Settings → API → Reload API

    └── Se ainda persistir após reload:
        → PASSO 5: Testar função direto no SQL Editor (ver FIX-C)
        → Se SQL Editor funcionar mas frontend não → problema no modelo Gemini
        → Se SQL Editor também falhar → abrir ticket Supabase
```

---

## FIX-A — Recriar search_documents com dimensão correta

```sql
-- Dropa TODAS as variantes pelo nome
DROP FUNCTION IF EXISTS public.search_documents(vector(768), int, float);
DROP FUNCTION IF EXISTS public.search_documents(vector(3072), int, float);
DROP FUNCTION IF EXISTS public.search_documents(vector, int, float);

-- Recria com schema explícito e dimensão correta
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
  SELECT
    id, tribunal, numero_acordao, ementa, content, link,
    data_julgamento, data_dje, repercussao_geral, recurso_repetitivo, turma,
    1 - (embedding <=> query_embedding) AS similarity
  FROM documents
  WHERE embedding IS NOT NULL
    AND 1 - (embedding <=> query_embedding) > similarity_threshold
  ORDER BY embedding <=> query_embedding
  LIMIT match_count;
$$;

-- Verificar
SELECT routine_name FROM information_schema.routines
WHERE routine_name = 'search_documents';
```

---

## FIX-B — Migrar coluna embedding para nova dimensão

```sql
-- ATENÇÃO: Apaga todos os embeddings existentes!
-- Rodar reembed.py depois obrigatoriamente.

UPDATE documents SET embedding = NULL;

ALTER TABLE documents
  ALTER COLUMN embedding TYPE vector(3072)
  USING embedding::vector(3072);

-- Verificar tipo
SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) AS tipo_coluna
FROM pg_attribute a JOIN pg_class c ON c.oid = a.attrelid
WHERE c.relname = 'documents' AND a.attname = 'embedding' AND a.attnum > 0;
```

Após FIX-B, rodar obrigatoriamente:
```bash
python backend/reembed.py
```

---

## FIX-C — Testar função diretamente no SQL Editor

```sql
-- Substitua 3072 pela dimensão do modelo em uso
SELECT id, similarity
FROM public.search_documents(
  array_fill(0.001::float4, ARRAY[3072])::vector,
  3,
  0.0
);
```

- **Retornou linhas** → banco OK, problema está no PostgREST ou frontend
- **Mesmo erro** → problema está no banco (coluna ou função com tipo errado)

---

## CHECKLIST P-050 — Executar após qualquer mudança de schema ou modelo

```
[ ] Após ALTER TABLE → testar INSERT de documento dummy
[ ] Após criar/alterar search_documents() → FIX-C no SQL Editor
[ ] Após reembed.py → confirmar dims: SELECT vector_dims(embedding), count(*) FROM documents WHERE embedding IS NOT NULL GROUP BY 1;
[ ] Após deploy frontend → abrir Playwright e rodar busca real
[ ] Após troca de modelo embedding → confirmar dims iguais em: função SQL + frontend + reembed.py
[ ] Após qualquer erro → NOTIFY pgrst, 'reload schema'; antes de outros diagnósticos
```

---

## PONTO CEGO CRÍTICO — outputDimensionality no Frontend

**Descoberto:** PROJ-001 Valdece V3 · 2026-05-21

O parâmetro `outputDimensionality` na chamada Gemini do frontend define a dimensão do **query embedding**.
Se estiver divergindo da dimensão dos **document embeddings** armazenados, a busca falha com "different vector dimensions".

**Sintoma:** banco OK (FIX-C retorna linhas), mas frontend retorna 400.
**Diagnóstico:** interceptar o fetch do frontend com Playwright:

```js
// Cole no console do browser ou via Playwright evaluate
const originalFetch = window.fetch;
window.fetch = async function(...args) {
  const result = await originalFetch(...args);
  const url = typeof args[0] === 'string' ? args[0] : args[0]?.url;
  if (url && url.includes('embedContent')) {
    result.clone().json().then(data => {
      if (data?.embedding?.values)
        console.log('QUERY DIMS:', data.embedding.values.length);
    });
  }
  return result;
};
```

**Fix:** garantir que `outputDimensionality` no frontend = dimensão dos documentos armazenados.

```js
// ERRADO — query embeddings em 768, documentos em 3072
body: JSON.stringify({ ..., outputDimensionality: 768 })

// CORRETO
body: JSON.stringify({ ..., outputDimensionality: 3072 })
```

**Regra:** `outputDimensionality` do frontend SEMPRE deve ser igual ao `outputDimensionality` (ou ausência dele) do `reembed.py`. Os dois precisam viver no mesmo espaço vetorial.

---

## MODELOS DE EMBEDDING GEMINI — REFERÊNCIA

| Modelo | Dims | Status |
|--------|------|--------|
| `text-embedding-004` | 768 | Ativo (limitado) |
| `gemini-embedding-001` | **3072** | Ativo (modelo atual — Google atualizou em 2025) |
| `text-embedding-preview-0409` | 768 | Deprecado |

**ALERTA:** O Google atualizou `gemini-embedding-001` de 768 → 3072 dims em 2025.
Qualquer projeto criado antes desta data com esse modelo precisa de migração de schema.

---

## ARQUIVOS RELACIONADOS

| Arquivo | O que faz |
|---------|-----------|
| `CLIENTES/[CLIENTE]/backend/reembed.py` | Re-embeda documentos com embedding NULL |
| `CLIENTES/[CLIENTE]/sql/fix_search_3072.sql` | Recria search_documents com 3072 dims |
| `CLIENTES/[CLIENTE]/sql/fix_embeddings_768.sql` | Nulifica embeddings de 768 dims |
| `CLIENTES/[CLIENTE]/sql/fix_pgrst_cache.sql` | Força reload do schema PostgREST |

---

*Princípio P-050 do INTELLIGENCE_LEDGER: teste de caminho principal é obrigatório após cada passo técnico irreversível.*
