# MEMORIA V2 — PROJ-002 Ingrid
**Loop:** #2 — Build Dias 3–5 (Feed Diário + Gate)  
**Data:** 2026-05-17  
**Próximo loop:** Loop #3 — Dias 6–8 (Interface + Tutor Socrático + Fallback Fadiga)

> Este arquivo é lido pelo Músculo no início do Loop 3.  
> Contém o estado técnico real — o que foi construído, o que falhou, o que está pendente.

---

## ESTADO DO BUILD

| Item | Status |
|---|---|
| Loop atual | #2 concluído — Gate Dia 5 APROVADO 2026-05-17 |
| Dias completos | 5 de 15 |
| Deadline app | 2026-05-30 (10 dias restantes) |
| Prova cliente | 2026-09-06 (~112 dias) |
| Questões no banco | 460 — 13 disciplinas Cargo 202 |

---

## RECALIBRAÇÃO CRÍTICA — EXECUTADA 2026-05-16 (P-024)

O cargo identificado no Loop 1 estava errado.

| Campo | Loop 1 (errado) | Loop 2 (correto) |
|---|---|---|
| Cargo | TDAS — área social | Cargo 202 — Técnico Administrativo |
| Disciplinas centrais | SUAS, LOAS, PNAS, CRAS/CREAS | Dir. Administrativo, Dir. Constitucional, Arquivologia, Recursos Materiais |
| edital_sedes.json | v2.0 (área social) | v3.0 (reconstruído do zero) |
| Edge Function index.ts | prompt com SUAS/LOAS | rebuildt — disciplinas Cargo 202 |

**P-024:** Validar o número do cargo e a especialidade no edital antes de gerar qualquer questão. Cargo errado = banco inútil.

---

## DISCIPLINAS DO CARGO 202 — edital_sedes.json v3.0

| Disciplina | Questões estimadas | Score | Peso |
|---|---|---|---|
| suas_fundamentos | 12q | 190 | 2 |
| programas_beneficios_df | 8q | 180 | 2 |
| direito_administrativo | 8q | 184 | 2 |
| direito_constitucional | 3q | 156 | 2 |
| arquivologia_rotinas_atendimento | 6q | 170 | 2 |
| recursos_materiais_patrimonio | 3q | 144 | 2 |
| portugues | 5q | ~75 | 1 |
| realidade_df_ride | 3q | ~65 | 1 |
| lei_organica_df | 2q | ~60 | 1 |
| lc840 | 2q | ~60 | 1 |
| maria_da_penha | 1q | ~50 | 1 |
| politica_mulheres | 1q | ~50 | 1 |
| primeiros_socorros | 1q | ~50 | 1 |

---

## O QUE FOI CONSTRUÍDO NO LOOP 2

### Dias 3–5

| Componente | Status | Arquivo |
|---|---|---|
| Edge Function `feed-diario` | Deployada e funcional | `supabase/functions/feed-diario/index.ts` |
| Edge Function `gerar-questoes` | Refatorada — 1 chamada Claude/invocação | `supabase/functions/gerar-questoes/index.ts` |
| Seed de questões | 460 questões no Supabase | `CLIENTES/INGRID/seed_questoes.ps1` |
| Gate Dia 5 (CLI) | APROVADO — 7 dias × 20q, 70.0% Peso 2, 0 erros | `CLIENTES/INGRID/gate_cli_dia5.js` |
| Ponto de entrada único | `iniciar.ps1` — menu, env, banco | `CLIENTES/INGRID/iniciar.ps1` |
| Troubleshooting | 7 panes documentadas | `PENTALATERAL_UNIVERSAL/REFERENCIAS/TROUBLESHOOTING_SUPABASE_CLAUDE_API.md` |
| session_close.ps1 | Auditoria automática de documentos adicionada | `scripts/session_close.ps1` |

---

## ARQUITETURA REAL — APÓS LOOP 2

### Edge Function gerar-questoes (regra permanente)

```
REGRA DE OURO: 1 chamada Claude por invocação da Edge Function.
O loop é externo (no seed script), não dentro da Function.

Por quê: Supabase Edge Function timeout = ~150s wall clock.
Sonnet para 5 questões técnicas complexas = ~87s por chamada.
2 chamadas sequenciais = 174s → timeout garantido.

Parâmetros corretos:
  - Peso 2 (Sonnet): max 5 questões por invocação, max_tokens = 8192, TimeoutSec = 200
  - Peso 1 (Haiku): max 8 questões por invocação, max_tokens = 4096, TimeoutSec = 120
```

### Seed script — controle externo do loop

```powershell
# Peso 2: batch de 5, timeout 200s por chamada
# Peso 1: batch de 8, timeout 120s por chamada
# Seed chama a Edge Function N vezes até atingir quota
# Edge Function faz 1 Claude call e retorna
```

### Strip de markdown (regra permanente)

```typescript
// Claude pode retornar JSON envolvido em ```json ... ```
// Sempre fazer strip antes de JSON.parse
let jsonText = conteudo.trim();
if (jsonText.startsWith("```")) {
  jsonText = jsonText.replace(/^```(?:json)?\s*\n?/, "").replace(/\n?```\s*$/, "").trim();
}
```

### Gate Dia 5 — Node.js v24

```javascript
// Node.js v24 tem fetch nativo — NÃO importar node-fetch
// Remover: import fetch from 'node-fetch'
```

---

## 7 PANES DOCUMENTADAS (P-025)

| # | Sintoma | Causa | Solução |
|---|---|---|---|
| 1 | HTTP 500 instantâneo | API key Anthropic arquivada | Gerar nova key + atualizar Secret Supabase (sem redeploy) |
| 2 | HTTP 500 após ~28s | Claude retorna JSON em markdown | Strip antes de JSON.parse — permanente na Edge Function |
| 3 | HTTP 500 — max_tokens | 4096 insuficiente para 5+ questões Sonnet | max_tokens = 8192 para Sonnet; regra: N × 700 × 1.3 |
| 4 | Timeout da Edge Function | Loop de múltiplas chamadas Claude dentro da Function | 1 Claude call por invocação; loop externo no script |
| 5 | Timeout PowerShell | Sonnet demora ~87s para 5q, TimeoutSec default 120s insuficiente para batch maior | TimeoutSec = 200 para Peso 2 |
| 6 | HTTP 400 no deploy | Deploy rodado fora do diretório raiz do projeto | `cd vanguard/` antes de qualquer `npx supabase functions deploy` |
| 7 | ERR_MODULE_NOT_FOUND: node-fetch | Node.js v24 tem fetch nativo, package desnecessário | Remover import, usar fetch global |

---

## RESULTADO DO GATE DIA 5

```
Resultado: 7 dias simulados
  Dia 1: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 2: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 3: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 4: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 5: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 6: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 7: 14 Peso2 + 6 Peso1 = 20 questões ✅

Proporção Peso 2: 70.0% (exata)
Erros de API: 0
Status: 🟢 APROVADO
```

---

## FALHA DE PROCESSO REGISTRADA — 2026-05-17

O Músculo não auditou documentos ao fechar o Loop 2. Eduardo teve que lembrar.

**Medida permanente:** `session_close.ps1` agora inclui AUDITORIA DE DOCUMENTOS automática.  
**Regra ativa:** CLAUDE.md Regra 11 — AO FECHAR CADA SESSÃO.  
**Registrado em:** INTELLIGENCE_LEDGER.md como FALHA-PROCESSO-2026-05-17.

---

## DÍVIDAS TÉCNICAS PARA O LOOP 3

| Prioridade | Item | Impacto |
|---|---|---|
| P0 | Interface PWA mobile para Ingrid responder questões | Gate Dia 8 bloqueante — Ingrid precisa interagir |
| P0 | Tutor Socrático Haiku — feedback ao errar | Engajamento e aprendizado real |
| P1 | Cache de explicações (`explicacao_tutor` no banco) | Zero custo de API em repetições |
| P1 | Fallback de fadiga — conteúdo passivo quando burn 70% | Estudo sem custo extra |
| P2 | Progresso visual por disciplina no header | UX — Ingrid vê onde atacar |
| P2 | Modo Revisão Express 5 min | Consistência diária |

---

## DECISÕES FIXADAS — NÃO REVERTER (acumulado Loop 1 + Loop 2)

| Decisão | Razão |
|---|---|
| Fonte de questões = Claude API | P-003 — sem scraping |
| Auth = single-user | MVP — Ingrid é a única usuária |
| Proporção feed = 70% Peso 2 / 30% Peso 1 | Fixado no Gate Dia 5 |
| SM-2 intervalo variável | <30% → 2 dias / 30-50% → 4 dias / >50% → 7 dias |
| Haiku para gerais + dicas socrátcas | Custo baixo |
| Sonnet para específicos Peso 2 | Qualidade máxima |
| BURN_RATE_DAILY_LIMIT_USD = 5.00 | P-006 |
| Fallback trigger = 70% da cota | Margem de segurança |
| Stack = PWA + Supabase + Claude API | Sem framework pesado |
| 1 Claude call por Edge Function invocação | Arquitetura de timeout — nunca reverter |
| max_tokens = 8192 para Sonnet | Custo vs segurança validado |
| Batch Sonnet = 5 questões | TimeoutSec 200s comporta ~87s por call |
| Batch Haiku = 8 questões | TimeoutSec 120s comporta confortavelmente |

---

## ARQUIVOS CRIADOS/MODIFICADOS NO LOOP 2

```
CLIENTES/INGRID/
  iniciar.ps1                           ← ponto de entrada único da sessão
  seed_questoes.ps1                     ← refatorado com batch externo
  gate_cli_dia5.js                      ← import node-fetch removido
  HISTORICO/MEMORIA_V2_INGRID.md        ← este arquivo
  HISTORICO/relatorio_evolutivo_V2_INGRID.md

supabase/functions/
  gerar-questoes/index.ts               ← 1 Claude call + strip markdown
  feed-diario/index.ts                  ← deployada pela 1ª vez

scripts/
  session_close.ps1                     ← seção AUDITORIA DE DOCUMENTOS adicionada

infra/
  schema_v19.sql                        ← schema atualizado

PENTALATERAL_UNIVERSAL/REFERENCIAS/
  TROUBLESHOOTING_SUPABASE_CLAUDE_API.md ← 7 panes documentadas

INTELLIGENCE_LEDGER.md                  ← P-025 + FALHA-PROCESSO-2026-05-17
CLIENTES/WIP_BOARD.json                 ← Loop 2 concluído, Loop 3 declarado
CLIENTES/INGRID/PASSO3_GEMINI.md        ← atualizado para Loop 3
```

---

## PRINCÍPIOS ATIVOS PARA O LOOP 3

- **P-003:** Sem scraping — questões são IP da Vanguard via Claude API
- **P-006:** Burn Rate Shield — $5,00/dia hard-limit
- **P-007:** Mágico de Oz Gate — CLI valida antes de UI avançar
- **P-010:** Gate por dia — output verificado antes de avançar
- **P-024:** Validar cargo e especialidade no edital antes de gerar qualquer questão
- **P-025:** Arquitetura Supabase+Claude — 1 call por invocação, batch externo, strip markdown sempre

---

*MEMORIA gerada pelo Músculo ao fechar Loop 2 · PROJ-002 Ingrid · 2026-05-17*
