# MEMÓRIA V5 — PROJETO INGRID
> Loop 5 · Dias 12-15 · Gate Dia 15 APROVADO 2026-05-26
> Gerada em 2026-05-26 — encerramento do Loop 5

---

## ESTADO TÉCNICO ENTREGUE

**Stack ativa:** PWA Vanilla JS + Supabase (projeto próprio da Ingrid) + Claude API (Haiku) · Deploy GitHub Pages
**Versão:** v18 · Commit: 8e9ac55
**URL produção:** https://subdiretormnmsgm-commits.github.io/vanguard/
**Supabase Ingrid:** https://yjqvjhezwhepwomukudt.supabase.co

### O que foi construído (Dias 12-15):

| Componente | Status | Observação |
|---|---|---|
| Badge SM-2 [Simulado de Fixação] | ✓ Entregue | Questões com `revisao=true` recebem badge amarelo |
| N-3 Linha de Corte configurável | ✓ Entregue | Dashboard admin (3 toques no logo) · default 67 pts · barra meta na tela de fim |
| N-1 Push Mágico de Oz | ✓ Entregue | Dashboard mostra última sessão + botão "Copiar mensagem" para Ingrid |
| N-5 html2canvas export PNG | ✓ Entregue | Botão "📱 Salvar progresso" gera card PNG da sessão |
| Nota Simulada de Prova | ✓ Entregue | Estatística ponderada: `get_heatmap_disciplinas × EDITAL_DIST` (13 disciplinas) |
| Bug fix disciplina_id + iniciada_em | ✓ Entregue | Campos nulos corrigidos no registro de sessão |
| Migration `sessoes_usuario` | ✓ Entregue | Aplicada no Supabase Vanguard antes da migração |
| **P-013 Soberania — Supabase própria** | ✓ **Entregue** | Ingrid tem projeto Supabase próprio com controle total dos dados |
| Migração 460 questões | ✓ Entregue | Export CSV Vanguard → Import Ingrid (+ coluna `pilula_do_dia` adicionada) |
| Migração 470 respostas | ✓ Entregue | Histórico de progresso migrado |
| Edge Functions deployadas | ✓ Entregue | `feed-diario` · `tutor-socratico` · `notificar-progresso` |
| Secrets configurados via CLI | ✓ Entregue | `ANTHROPIC_API_KEY` · `TELEGRAM_BOT_TOKEN` · `TELEGRAM_CHAT_ID` |
| v18 deploy GitHub Pages | ✓ Entregue | Cache `sedes-df-v18` · assets `?v=18` · service worker renovado |

### Banco de dados (projeto da Ingrid — yjqvjhezwhepwomukudt):
- **460 questões** · 13 disciplinas · Cargo 202 (Técnico Administrativo — Quadrix)
- **12 tabelas** criadas · **9 funções** (RPCs) · **13 linhas** controle_cache
- RLS ativo em todas as tabelas
- Edge Functions ativas: feed-diario · tutor-socratico · notificar-progresso
- USER_ID hardcoded: `00000000-0000-0000-0000-000000000001`

---

## DECISÕES FIXADAS (não reverter sem veredito)

| Decisão | Princípio | Razão |
|---|---|---|
| P-013 Opção B: Ingrid cria próprio Supabase | P-013 | Soberania do cliente sobre seus dados — aprovado pelo Diretor |
| USER_ID hardcoded `000...0001` | P-045 | Zero login visível — Ingrid nunca vê tela de autenticação |
| Edge Functions no projeto da Ingrid | Soberania | Funções no projeto dela = sem dependência da infra Vanguard |
| `pilula_do_dia` como coluna TEXT nullable | P-056 | Campo novo identificado no export — adicionado sem quebrar schema |
| Linha de Corte default 67 pts | Runbook | SEDES-DF 2026 sem corte verificável (concurso inédito Quadrix) |

---

## ALERTAS ATIVOS

| Alert | Severidade | Status |
|---|---|---|
| 470 respostas migradas podem estar sob user_id diferente do hardcoded | 🟡 Médio | A investigar no Loop 6 |
| Token Supabase CLI `[REDACTED]` exposto no chat | 🔴 Crítico — REVOGADO 2026-05-27 | Confirmado revogado pelo Diretor |
| Histórico SM-2 pode não carregar (user_id discrepância) | 🟡 Médio | Monitorar na primeira sessão real da Ingrid |

---

## ESTADO DOS GATES

| Gate | Dia | Status |
|---|---|---|
| gate_qualidade (questões reais Quadrix) | Dia 2 | ✅ APROVADO |
| gate_feed_sm2 (feed 70/30 + SM-2) | Dia 5 | ✅ APROVADO |
| gate_pwa (PWA completo + tutor + fallback) | Dia 8 | ✅ APROVADO |
| gate_heatmap (Heatmap + Micro-Simulado) | Dia 11 | ✅ APROVADO |
| gate_dia13 (Pontos Ponderados + Push domingo) | Dia 13 | ✅ APROVADO |
| **gate_dia15 (Soberania P-013 + v18)** | **Dia 15** | ✅ **APROVADO 2026-05-26** |

---

## PRÓXIMO LOOP (Loop 6)

**Triggers:** Primeira semana de uso real da Ingrid · Feedback de campo
**Foco sugerido:** SaaS Readiness Audit · Onboarding de segundo cliente · Upsell plano mensal

**Pendências antes do Loop 6:**
- [ ] Wipe & Sync NotebookLM (Eduardo arrasta fontes)
- [ ] Investigar discrepância user_id nas 470 respostas migradas
- [ ] Deletar token Supabase exposto

---

*Músculo — Pentalateral IAH — 2026-05-26*
