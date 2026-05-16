# MEMORIA_V1 — PROJETO VALDECE
**Iteração:** V1 (Dias 1–2 de 5)
**Data:** 2026-05-13
**Gerado por:** Músculo (Claude Code)

---

## CONTEXTO DO PROJETO

**Cliente:** Valdece — Advogado criminalista (Direito Penal)
**Produto:** Ferramenta de busca semântica de jurisprudências STF/STJ
**Stack:** Vanilla JS + Supabase pgvector + Gemini embedding-004
**Prazo total:** 5 dias (deadline: 2026-05-17)
**Valor fechado:** R$5.000 + contrapartida 20% MRR do SaaS
**GUT Score:** 75 (G:5 · U:5 · T:3)
**ROI calculado para o cliente:** 860% no ano 1

---

## O QUE FOI CONSTRUÍDO (Dias 1–2)

### Dia 1 — Infraestrutura & 7 Leis Soberanas (commit ef3f1cd)

**`sql/schema.sql`**
- Extensão pgvector habilitada
- Tabela `documents`: corpus com `embedding vector(768)`, HNSW index (m=16, ef_construction=64)
- Tabela `search_logs`: Sovereign Pixel — rastreia queries, cliques, relevância
- Tabela `token_usage` + view `daily_cost`: Burn Rate Shield
- Tabela `config`: Kill-Switch + Feature Flags (sintese_enabled=false, sentinel_enabled=false)
- Função `search_documents()`: busca por similaridade coseno com threshold 0.65
- RLS completo: auth_read_documents, auth_own_search_logs, anon_read_config, service_token_usage

**`backend/burn_rate_shield.js`**
- Hard-limit $10/dia na API Gemini
- Warning em 80% do limite
- `logUsage()`: registra cada operação em token_usage
- `burnRateMiddleware()`: 429 se limite excedido

**`backend/kill_switch.js`**
- `isSearchEnabled()`: lê config.search_enabled — fail-open (não bloqueia por erro de rede)
- `isFeatureEnabled()`: flag genérica para qualquer feature
- `killSwitchMiddleware()`: 503 com mensagem de manutenção

**`.env.example`**: template completo com SUPABASE_URL, SUPABASE_SERVICE_KEY, GEMINI_API_KEY, DAILY_TOKEN_LIMIT_USD=10

### Dia 2 — Corpus Pipeline & GO/NO-GO Gate (commit 996b40d)

**`backend/ingest.py`**
- Fonte 1: STF Open Data API (`/api/search/search`) com filtro por palavras-chave penais
- Fonte 2: CSV local (fallback para importação manual)
- Embedding via Gemini text-embedding-004 (768 dims, taskType=RETRIEVAL_DOCUMENT)
- Idempotência: verifica duplicatas por numero_acordao + tribunal antes de inserir
- Token Rate Shield integrado: log de custo em token_usage a cada embedding
- Estimativa de custo + confirmação do usuário antes de executar
- Rate limiting: sleep(0.1) entre documentos, sleep(0.2) entre páginas STF

**`backend/search_cli.py`** — Mágico de Oz Gate
- Valida busca semântica via CLI antes de construir UI
- Embedding taskType=RETRIEVAL_QUERY (diferente do ingest — otimizado para queries)
- Exibe: tribunal, numero_acordao, data, ementa (200 chars), similarity score, link
- Mede tempo de resposta + estima custo da query
- Uso: `python search_cli.py "habeas corpus tráfico" --top 5 --threshold 0.65`

---

## PADRÕES EXTRAÍDOS NESTA ITERAÇÃO

| Padrão | Origem | Status |
|---|---|---|
| Token Rate Shield antes de qualquer chamada de API de IA | Burn Rate Shield — Dia 1 | Confirmado — promovido ao SKILL_PROTOCOLO_VANGUARD |
| Mágico de Oz Gate: CLI antes de UI | search_cli.py — Dia 2 | Candidato (P-007) — confirmar após teste real |
| STF Open Data público > scraping real-time | Escolha de corpus — Dia 2 | Confirmado — reforça P-003 |
| Idempotência no ingest: verifica antes de inserir | ingest.py — Dia 2 | Confirmado — aplicar em todo pipeline de dados |

---

## DECISÕES DE ARQUITETURA TOMADAS

1. **Vanilla JS + Supabase** (não Next.js): peso_simplicidade=1.0 para deadline de 5 dias
2. **embedding-004 (768 dims)**: melhor custo-benefício para corpus jurídico em PT-BR
3. **HNSW index** (não ivfflat): sem treinamento necessário, funciona bem até 1M docs
4. **Similaridade mínima 0.65**: calibrar após testes com corpus real do STF
5. **fail-open no Kill-Switch**: busca não cai por erro de rede na config table

---

## ESTADO ATUAL

- Dias completos: 1/5 e 2/5
- Commits: ef3f1cd (Dia 1) e 996b40d (Dia 2)
- Pendente: corpus real ainda não inserido (aguarda credenciais do Valdece)
- GO/NO-GO gate: não executado ainda (depende do corpus)

---

## DÍVIDAS TÉCNICAS

| ID | Descrição | Prioridade |
|---|---|---|
| DT-001 | search_cli.py não loga query no search_logs (Sovereign Pixel) | P2 — fazer no Dia 3 |
| DT-002 | ingest.py não atualiza embedding se documento já existe com embedding null | P2 — edge case |
| DT-003 | STF Open Data URL pode mudar sem aviso — fallback CSV obrigatório | P1 — documentar no handoff |
