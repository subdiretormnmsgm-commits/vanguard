# DELIBERAÇÃO LOOP V8 — PROJ-002 INGRID
> Síntese P-037 — Músculo consolida 25 inputs em 1 plano
> Data: 2026-06-04 | Loop: 8 | Fase: Telemetria + RLS + Monetização
> Sequência: Gemini (DIRETRIZ V8) ✅ → NotebookLM (ingrid-v8.md) ✅ → Embaixador (SEÇÃO D) ✅ → Músculo P-037 ✅
> Status: DELIBERAÇÃO CONCLUÍDA — VEREDITOS D1-D5 executados — BUILD COMPLETO

---

## 1. ESTADO ANTERIOR — CONTEXTO QUE PRECEDEU ESTE LOOP

| Campo | Estado ao entrar no Loop 8 |
|---|---|
| App | v20 live · GitHub Pages ativo |
| Deploy CLI | Gate 7.1 APROVADO 2026-06-01 — F-4 (cron 19h45) + F-6 (relatório semanal) autônomos |
| GitHub Security | D4 resolvido 2026-06-01 — token sbp_ revogado |
| LEGAL-WATCH | VERDE — Termo 18/05/2026 · reassinatura física 2026-05-27 |
| DADOS-WATCH | VERDE — 102 respostas · 1 user_id correto |
| Temperatura | 8.5/10 VERDE FORTE — D3 respondido 2026-06-01 (Ingrid confirmou uso ativo e que está gostando) |
| Telemetria | AUSENTE — evento_uso não existia, Eduardo voava às cegas |
| RLS | Gate 7.2 pendente — isolamento multi-tenant não validado |
| Pitch | AQUECIDO — janela aberta. Diretor não havia monetizado |

---

## 2. DECISÃO ESTRATÉGICA CENTRAL DO LOOP 8

> **D1 DESCARTADO — Mudança de fundamento comercial**
> Ingrid não é cliente pagante. É fundadora simbólica do produto.
> Ferramenta é gratuita para ela. Dados anonimizados de seu uso são o argumento comercial para as próximas candidatas.
> Esta decisão muda o eixo do projeto: de "converter Ingrid em R$97/mês" para "usar os dados de Ingrid para vender a outras candidatas".

---

## 3. OS 25 INPUTS — SÍNTESE COM FILTRO DO EMBAIXADOR

### MÚSCULO [M-1 a M-5] · relatorio_V7

| # | Ideia | Decisão P-037 |
|---|---|---|
| M-1 | Telemetria passiva evento_uso — batch assíncrono | **ENTRA** — F-A construído · IndexedDB + flush na reconexão |
| M-2 | Painel de uso Eduardo — última sessão + threshold visual | **ENTRA** — F-B construído · painel_eduardo.html puro |
| M-3 | RLS dry-run — isolamento multi-tenant Gate 7.2 | **ENTRA como pré-requisito** — test_tenant_isolation.ps1 pendente (ação do Diretor) |
| M-4 | Link de demonstração anônimo para prospects | **BLOQUEADO** — com 1 usuária, anonimato é fictício. Liberar com segunda usuária |
| M-5 | Alerta Compound Telegram — 3 dias sem uso | **ENTRA** — F-E construído · alerta-inatividade Edge Function atualizada |

### ESTRATEGISTA [G-1 a G-5] · DIRETRIZ V8 — Gemini

| # | Ideia | Decisão P-037 |
|---|---|---|
| G-1 | Safe-Horizon SM-2 Adaptativo | **FLAG TÉCNICA INTERNA** — zero UX. Nunca expor a Ingrid |
| G-2 | SaaS Readiness Audit anônimo — custo operacional M-4 | **SEGREDO INTERNO** — exposição de engrenagens destrói ancoragem de preço |
| G-3 | Redução punitiva de cota SM-2 | **VETO PERMANENTE** — perfil ansioso = churn imediato. G-3 nunca entra neste projeto |
| G-4 | Framing relativo ao edital no F-6 | **ENTRA** — D2 A implementado no relatorio-semanal/index.ts |
| G-5 | Adiar pitch passivamente | **REJEITADO** — Embaixador vetou. Temperatura 8.5/10 + shift vocabular = janela ativa |

### AUDITOR [N-1 a N-5] · ingrid-v8.md

| # | Ideia | Decisão P-037 |
|---|---|---|
| N-1 | Clickwrap Legal Opt-In Dataset M-1 | **FICA PARA LOOP 9** — necessário antes de qualquer pitch B2C com dados |
| N-2 | Pitch puxado pela View SQL golden — ROI real +15% acertos | **ENTRA COMO GATE** — snapshot_ingrid_loop6_golden criada · view golden corrigida |
| N-3 | Heartbeat autônomo + fallback de batches | **ENTRA** — N-3 integrado ao app.js · IndexedDB com flush na reconexão |
| N-4 | TTL expurgo RLS — PostgreSQL limpa dados sintéticos 24h | **ENTRA** — migration 20260604_loop8_n4_ttl_expurgo.sql deployada |
| N-5 | Pulse Check dominical — 3 emojis no cold start | **FICA PARA LOOP 9** — prioridade inferior às fundações de telemetria |

### EMBAIXADOR [E-1 a E-5] · Loop 8 SEÇÃO D · 2026-06-04

| # | Insight | Status P-037 |
|---|---|---|
| E-1 | Janela de pitch fecha ~04-07 de julho — modo bunker após essa data | **URGÊNCIA** — D4 mensagem de presença humana esta semana. Pitch antes de julho |
| E-2 | 11 dias sem contato humano de Eduardo — componente humano invisível | **GATE** — D4 A executado pelo Diretor esta semana |
| E-3 | H-6 (teto R$/mês) — não testar com Ingrid. Confirmar com 2º/3º cliente | **DECISÃO FIXADA** — nunca testar preço com Ingrid |
| E-4 | Fluxo operacional de aceite do pitch não existe ainda | **FICA PARA LOOP 9** — contrato V2, forma de pagamento, onboarding da 2ª candidata |
| E-5 | G-3 vetado — Ingrid com desamparo aprendido, punição = abandono silencioso | **VETO PERMANENTE** confirmado |

---

## 4. O QUE FOI CONSTRUÍDO NO LOOP 8

### Features entregues

| Feature | Arquivo | Status |
|---|---|---|
| F-A Telemetria passiva | `frontend/app.js` + `migrations/20260604_loop8_fa_evento_uso.sql` | ✅ DEPLOYADO |
| F-B Painel Eduardo | `painel_eduardo.html` | ✅ ENTREGUE |
| F-E Alerta Telegram | `supabase/functions/alerta-inatividade/index.ts` | ✅ DEPLOYADO |
| F-G Git Hook pre-push | `.git/hooks/pre-push` | ✅ ATIVO — bloqueou token em 13:12 |
| N-3 Heartbeat + fallback | `frontend/app.js` (integrado) | ✅ DEPLOYADO |
| N-4 TTL expurgo | `migrations/20260604_loop8_n4_ttl_expurgo.sql` | ✅ APLICADO |
| D2 Framing edital | `supabase/functions/relatorio-semanal/index.ts` | ✅ DEPLOYADO |
| View golden corrigida | `migrations/20260604_loop8_fa_evento_uso.sql` (fix colunas) | ✅ CORRIGIDA |

### Ferramentas de processo entregues

| Ferramenta | O que protege |
|---|---|
| `scripts/validar_diretriz.ps1` | Rejeita DIRETRIZ V8 mal formatada do Gemini |
| `.claude/hooks/file_protection_guard.ps1` | P-098 — bloqueia edição de arquivo de processo sem veredito |

---

## 5. VEREDITOS FORMALIZADOS — D1 a D5

| Veredito | Decisão | Impacto |
|---|---|---|
| D1 DESCARTADO | Ingrid = fundadora simbólica. Sem cobrança R$/mês. | Muda eixo: monetizar com 2ª candidata usando dados de Ingrid como prova |
| D2 A | Framing relativo ao edital no F-6 | Relatório semanal mostra progresso no contexto do que importa: a prova |
| D3 DESCARTADO | Sem transação comercial com Ingrid | Opt-in dataset vai com 2ª candidata |
| D4 A | Mensagem de presença humana esta semana | Eduardo reentra no radar ANTES do pitch — componente humano visível |
| D5 A | Sequência M-3 → N-4 → N-3 → M-1 | Fundação antes de construção — isolamento antes de telemetria |

---

## 6. BLOQUEADOS / ADIADOS

| Item | Razão | Retorno |
|---|---|---|
| M-4 Link demo anônimo | 1 usuária = anonimato fictício | Loop 9 com 2ª usuária |
| Gate 7.2 RLS dry-run | Ação do Diretor (`$env:SUPABASE_SERVICE_ROLE_KEY` + `test_tenant_isolation.ps1`) | Antes de onboarding da 2ª candidata |
| N-1 Clickwrap Opt-In Dataset | Necessário antes de pitch B2C com dados de Ingrid | Loop 9 |
| N-5 Pulse Check dominical | Prioridade inferior às fundações | Loop 9 |
| Fluxo aceite do pitch | Contrato V2 + forma de pagamento + onboarding 2ª candidata | Loop 9 |

---

## 7. AÇÕES DO DIRETOR (sem código)

| Ação | Timing | Texto pronto |
|---|---|---|
| D4: Mensagem de presença humana | **ESTA SEMANA** | *"Ingrid, o sistema me avisou que você tem estudado. Queria saber: como você está se sentindo em relação à prova agora? O ritmo está fazendo sentido?"* |
| Gate 7.2 RLS dry-run | Antes do onboarding da 2ª candidata | `$env:SUPABASE_SERVICE_ROLE_KEY = 'sua-key'` → `.\scripts\test_tenant_isolation.ps1` |
| Deploy GitHub Pages | Próxima sessão | `.\scripts\deploy_ingrid_ghpages.ps1` |

---

## 8. REGISTRO P-037

- **DELIBERAÇÃO criada:** 2026-06-04
- **Músculo responsável:** Claude Sonnet 4.6
- **Arquivo:** `CLIENTES/INGRID/HISTORICO/DELIBERACAO_LOOP_V8_INGRID.md`
- **VEREDITOS:** `CLIENTES/INGRID/CLAUDE_PROJECT/DECISOES/VEREDITOS_Loop8_2026-06-04.json`
- **Gate P-037:** CUMPRIDO — síntese documentada antes do fechamento do loop
