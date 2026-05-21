# KNOWLEDGE BASE — PROJ-001 Valdece (Toga Digital)
**Problemas e soluções específicos deste projeto**
**Atualizado:** 2026-05-21

---

## RUNBOOKS UNIVERSAIS APLICÁVEIS A ESTE PROJETO

| Assunto | Link |
|---------|------|
| Busca semântica + pgvector + Supabase | [RUNBOOK_BUSCA_SEMANTICA_SUPABASE.md](../../QUADRILATERAL_UNIVERSAL/OPERACAO/RUNBOOK_BUSCA_SEMANTICA_SUPABASE.md) |
| Testes remotos de frontend (Playwright) | [TESTES_REMOTOS.md](../../QUADRILATERAL_UNIVERSAL/KNOWLEDGE_BASE/TESTES_REMOTOS.md) |

---

## PROBLEMAS ESPECÍFICOS DESTE PROJETO

| Problema | Solução | Data |
|----------|---------|------|
| `outputDimensionality: 768` hardcoded no frontend causava mismatch com documentos em 3072 dims | Alterar para `3072` em `frontend/index.html` linha 706 | 2026-05-21 |
| Supabase do cliente inacessível (sem credenciais) | Criar projeto no Supabase Vanguard + migrar via `backend/migrate_data.py` | 2026-05-20 |
| Chave Gemini exposta no Netlify → Google bloqueou | Criar nova chave em projeto separado `vanguard-ai` sem restrições de IP | 2026-05-20 |
| `HNSW index` rejeita `vector(3072)` (max 2000 dims) | Dropar índice — 61 docs não precisam de índice (exact scan suficiente) | 2026-05-20 |

---

## ROTEIRO DE TESTES DO CLIENTE (P-051)
> Derivado do discovery com Valdece. Usar estes termos — nas palavras dele — em todo teste remoto.

| # | Query de teste | O que valida |
|---|---------------|-------------|
| 1 | `prisão preventiva excesso de prazo` | Caso mais comum da defesa criminal (termo citado por Valdece) |
| 2 | `habeas corpus flagrante ilegal` | HC é o instrumento central do dia a dia dele |
| 3 | `tráfico de drogas pena reduzida privilegiado` | Tese de causa de diminuição — alta frequência |
| 4 | `execução antecipada pena inconstitucional` | Tema de repercussão geral — filtro V3 |
| 5 | `medidas cautelares diversas prisão proporcionalidade` | Alternativas à preventiva — pede muito |

**Resultado esperado:** ≥ 5 resultados · score topo ≥ 85% · sem erro no console

---

## STACK DESTE PROJETO

| Componente | Detalhe |
|-----------|---------|
| Frontend | Netlify — `toga-digital-valdece.netlify.app` |
| Banco | Supabase `uslkhnselzmbbnupmfsp` (projeto Vanguard) |
| Embedding | `gemini-embedding-001` · `outputDimensionality: 3072` |
| Chave Gemini | Projeto `vanguard-ai` — sem restrição de domínio/IP |
| Backend | Python — `backend/reembed.py`, `backend/ingest.py` |
