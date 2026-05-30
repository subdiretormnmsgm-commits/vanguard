# MEMÓRIA V7 — PROJETO INGRID
> Diretriz V7 · Loop 7 · SaaS Readiness + Pipeline Comercial
> Gerada em 2026-05-30 — encerramento do ciclo Loop 7

---

## ESTADO TÉCNICO AO ENCERRAR LOOP 7

**Stack ativa:** PWA Vanilla JS + Supabase próprio da Ingrid (yjqvjhezwhepwomukudt) + Claude API · GitHub Pages
**Versão:** v20 · URL: https://subdiretormnmsgm-commits.github.io/vanguard/

### Features ativas em produção (v20):

| Feature | Status |
|---|---|
| F-1 Saudação Noturna Dinâmica | Ativo — "Boa noite, N questões te esperam" |
| F-2 Distração Vingativa Silenciosa | Ativo — sem label visível |
| F-4 Gatilho Temporal 19h45 + pg_cron | Código entregue — **deploy CLI PENDENTE** |
| F-5 Modo Véspera | Ativo — ativar em 2026-08-30 |
| F-6 Relatório Semanal WhatsApp | Código entregue — **deploy CLI PENDENTE** |
| F-7 Raio-X SVG + Brasão Semanal | Ativo — html2canvas export PNG |
| F-8 Termômetro da Aprovação | Ativo — Nota Projetada vs Linha de Corte |
| SM-2 + Heatmap | Ativos — 102 respostas · 1 user_id correto |

### Loop 7 — o que foi planejado mas NÃO construído (bloqueado por D1/D4):

| Feature | Por que não construída |
|---|---|
| F-A Telemetria passiva (evento_uso) | Aguarda deploy CLI (D1 → pós-D4) |
| F-B Painel de uso Eduardo (M-1) | Aguarda F-A (evento_uso) |
| F-C Interceptor RLS silencioso (N-2) | Aguarda deploy CLI |
| F-D View SQL snapshot_ingrid_loop6_golden (N-4) | Pode fazer offline — próxima sessão |
| F-E Alerta Compound Telegram (M-5) | Aguarda F-4/F-6 autônomos |
| F-F Pulse Check Analógico (N-5) | Aguarda F-B (Painel Eduardo) |
| F-G Git Hook pre-push (G-5 + N-3) | Próxima sessão |
| F-H LEGAL-WATCH visual (N-1) | Aguarda F-B (Painel Eduardo) |

### O que foi entregue neste ciclo (ferramentas do processo):

| Ferramenta | Arquivo |
|---|---|
| Gate 0 WIP_BOARD vs disco | `scripts/auditar_consistencia.ps1` |
| Correção rápida WIP_BOARD | `scripts/corrigir_wip.ps1` |
| Gate 9B sync Claude Projects | `scripts/sincronizar_claude_projects.ps1` |
| Dry-run isolamento de tenant | `scripts/test_tenant_isolation.ps1` |
| Síntese do Conselho (estrutura) | `scripts/gerar_sintese_conselho.ps1` |
| Template síntese | `PENTALATERAL_UNIVERSAL/TEMPLATES/scripts/sintese_conselho_template.txt` |
| P-091 inscrito | `INTELLIGENCE_LEDGER.md` linha 1620 |
| Render painel bug fix | `scripts/render_painel.ps1` — injeção automática de campos ausentes |
| WIP_BOARD.md distribuído | `CLIENTES/WIP_BOARD.md` + NOTEBOOKLM_FONTES de cada projeto |

---

## DECISÕES FIXADAS LOOP 7 (não reverter sem novo veredito)

| Veredito | Decisão |
|---|---|
| D1 | Deploy F-4 + F-6 aguarda resolução D4 (GitHub Security) |
| D2 | RLS dry-run → Loop 8 (não urgente neste ciclo) |
| D3 | Debrief casual 31/05 — mensagem no clipboard |
| D4 | GitHub Security — pendência próxima sessão |
| D5 | M-4 Link Demo BLOQUEADO até segunda usuária |
| D6 | Semente E-4 aguarda sessão com maior engajamento verbal de Ingrid |

---

## BLOQUEIOS ATIVOS

| Bloqueio | Causa | Desbloqueio |
|---|---|---|
| Deploy F-4/F-6 (Gate 7.1) | GitHub Security pendente → `supabase login` interativo | Eduardo: link GitHub Security → Músculo deploya |
| GitHub Pages push | Token sbp_ no histórico | Eduardo: link GitHub Security |
| Gate 7.2 RLS dry-run | Movido para Loop 8 | `$env:SUPABASE_SERVICE_ROLE_KEY` + `test_tenant_isolation.ps1` |
| Loop 8 build | Bloqueado por Gate 7.1 | Resolver D4 → D1 em ordem |

---

## ESTADO DOS GATES E WATCHES

| Gate/Watch | Status |
|---|---|
| Todos os dias 1–15 | ✅ APROVADOS — último: dia15 2026-05-30 |
| DADOS-WATCH user_id | ✅ VERDE — 102 respostas · 1 user_id |
| LEGAL-WATCH | ✅ VERDE — reassinatura 2026-05-27 |
| P-013 soberania | ✅ VERDE — Ingrid admin Supabase própria |
| DEPLOY-WATCH F-4/F-6 | ⚠️ ATIVO |
| GITHUB-WATCH | ⚠️ ATIVO |
| DATA-GAP-WATCH | ⚠️ ATIVO — uso 24/05 a 30/05 não confirmado |

---

## TEMPERATURA E PIPELINE

| Campo | Estado |
|---|---|
| Temperatura | 7.5/10 VERDE SUSTENTADO — validar no debrief 31/05 |
| Shift confirmado | H-8: "atacar" = player mindset (P-079) |
| Pitch R$97/mês | Janela aberta — gatilho: 7 dias consecutivos + progresso verbalizado |
| Pipeline de referral | Zero no curto prazo — semear pós-aprovação (D6 aguardando) |
| CHURN-WATCH | DESATIVADO |

---

## PRÓXIMO LOOP (Loop 8)

**Ordem de execução obrigatória:**
1. Eduardo: GitHub Security → desbloqueia push Pages
2. Músculo: `supabase login` + deploy F-4 + F-6 (Gate 7.1)
3. Músculo: `test_tenant_isolation.ps1` (Gate 7.2)
4. Build F-A a F-H em sequência (telemetria → painel → alertas → hooks)
5. Eduardo: debrief casual Ingrid 31/05 (mensagem no clipboard)

**Skill do Loop 8:** `ingrid-v8.md` — gerada após Gemini PASSO3

---

*Músculo — Pentalateral IAH — 2026-05-30*
