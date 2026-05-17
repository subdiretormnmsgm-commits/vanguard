# MEMORIA — PROJ-002 Ingrid | Dias 1-2
**Data:** 2026-05-16 | **Loop:** #1 | **Músculo:** Claude Code

---

## ESTADO TÉCNICO

### O que foi construído
- **Schema Supabase** deployado via Management API (Node.js) — 4 tabelas com RLS ativo:
  - `questoes_quadrix` — banco de questões geradas pelo Claude
  - `progresso_usuario` — histórico de respostas + SM-2 (easiness_factor, interval, repetitions)
  - `controle_cache` — controle de lotes gerados por disciplina
  - `controle_burn_rate` — hard-limit $5,00/dia com bloqueio automático
- **Views com security_invoker=true:** `questoes_nao_respondidas`, `questoes_para_revisao`
- **RPC `incrementar_custo_burn_rate`** — função SECURITY DEFINER que atualiza burn rate e bloqueia quando limite atingido
- **Edge Function `gerar-questoes`** deployada no Supabase (Deno) — roteamento Haiku/Sonnet por peso do edital
- **`gate_cli.js`** — Mágico de Oz Gate CLI funcional com fallback direto para Claude API
- **`.env.example`** — protocolo seguro de credenciais (nunca commitado)
- **`email_fechamento.ps1`** — infraestrutura de e-mail do Conselho documentada como P-017

### Decisões de arquitetura fixadas
- Fonte de questões: Claude API exclusivamente (P-003 — sem scraping)
- Auth: single-user MVP — sem login complexo
- Cache: gerar lote de 50 quando < 30 questões disponíveis
- Proporção do feed: 70% Peso 2 / 30% Peso 1
- Modelos: Sonnet (disciplinas Peso 2) / Haiku (disciplinas Peso 1 + tutor socrático)
- Burn Rate Shield: $5,00/dia hard-limit

### Commits da iteração
- `904132a` — schema Supabase + Edge Function
- `ee26c67` — P-017 + email fechamento + gate CLI robusto

---

## GATE DOS DIAS 1-2 — RESULTADO

**Gate:** 10 questões avaliadas pelo Diretor — rubrica média >= 4,0/5
**Resultado:** APROVADO — média 5,0/5

Disciplina testada: SUAS (Peso 2 — Sonnet)
Critérios avaliados:
1. Estilo Quadrix (literalidade da lei)
2. Distratores plausíveis
3. Gabarito correto
4. Explicação clara
5. Dificuldade adequada (2-4/5)

Custo do lote gate: ~$0,07

---

## FRICÇÕES E PRINCÍPIOS EXTRAÍDOS

### Fricções
- Supabase MCP OAuth falhou ("redirect_uri: Required") → solução: CLI `npx supabase`
- `supabase db query` conecta ao banco local, não ao remoto → solução: Management API via Node.js
- `gate_cli.js` com `process.exit(1)` bloqueava fallback → solução: `throw new Error()`
- JSON truncado (max_tokens: 4096) → solução: aumentado para 8192
- Duas API Keys expostas no chat → ambas rotacionadas — protocolo .env estabelecido
- Em dash (—) causava ParseError no PS 5.1 → substituído por hífen

### Princípios registrados no LEDGER
- **P-017** — Infraestrutura de e-mail do Conselho documentada e operacional

---

## DÍVIDAS TÉCNICAS

| Prioridade | Item | Impacto |
|---|---|---|
| P0 | `.env` da Ingrid precisa da Anthropic API Key real (`ingrid-sedes-df`) | Gate CLI e Edge Function dependem disso |
| P1 | `10_MEMORIA_RECENTE` e `11_RELATORIO_EVOLUTIVO` ausentes no NOTEBOOKLM_FONTES | Auditor entra no Loop 2 sem memória dos Dias 1-2 |
| P2 | SKILL_PROTOCOLO_VANGUARD não refletia princípios [2026-05-16] | Sincronizado nesta sessão |

---

## PRÓXIMA ITERAÇÃO — DIAS 3-5

**Gate de entrada:** `.env` preenchido com Anthropic API Key real
**O que será construído:**
- Calendário de estudo até 06/09/2026 (114 dias)
- Algoritmo de roteamento 70% Peso 2 / 30% Peso 1
- Integração SM-2 (revisão espaçada por taxa de acerto)
- Interface de questões com explicação ao errar

**Gate do Dia 5:** feed exibe plano correto de 7 dias com proporção 70/30 — Diretor valida antes de avançar para Dias 6-8

---

## CUSTO REAL DA ITERAÇÃO
- Gate CLI (10 questões, Sonnet): ~$0,07
- Deploy e testes: $0,00 (sem chamadas de produção)
- **Total Dias 1-2: ~$0,07**
