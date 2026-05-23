# MEMÓRIA V4 — PROJETO INGRID
> Loop 4 · Dias 9-11 · Gate Dia 11 APROVADO 2026-05-20
> Gerada retroativamente em 2026-05-23 (Loop 4 executado sem MEMORIA formal — P-045 sanado)

---

## ESTADO TÉCNICO ENTREGUE

**Stack ativa:** PWA Vanilla JS + Supabase + Claude API (Haiku + Sonnet) · Deploy GitHub Pages

### O que foi construído (Dias 9-11):
| Componente | Status | Observação |
|---|---|---|
| RLS + auto-login invisível | ✓ Entregue | Backend multi-usuário. Ingrid sem tela de login. |
| Clickwrap V2 ("termo_v2_18_05") | ✓ Entregue | Erro de data corrigido (era 30/05, passou a 18/05). P-023 sanado. |
| `horario_inicio_sessao` + `ttl_resposta_ms` | ✓ Entregue | Campos de telemetria adicionados. |
| RPC `progresso_semanal` (M-2) | ✓ Entregue | Dados para mensagem semanal WhatsApp. |
| Snapshot diário `metricas_diarias` (M-4) | ✓ Entregue | Cron job ativo. |
| Fallback graceful Claude API | ✓ Entregue | Claude lento → questão cached, zero erro visível. |
| RPCs Heatmap (taxa acerto por disciplina) | ✓ Entregue | Gate CLI aprovado Dia 10. |
| UI Mapa de Soberania + Radar de Foco | ✓ Entregue | Linguagem conquista. Frase: "Esse é seu terreno." |
| Streak feedback (E-3) | ✓ Entregue | Streak ≥ 3: "Você acertou as últimas [N]..." |
| Micro-Simulado Dominical (Penalidade Quadrix) | ✓ Entregue | Condicional check-in 21/05 — Ingrid estuda domingo. |
| Distrator oculto no SM-2 | ✓ Entregue | Reforço de padrão de erro sem confronto visual. |
| TTI silencioso (`ttl_resposta_ms`) | ✓ Entregue | Registrado sem feedback punitivo. |
| Burn Rate por sessão (M-3) | ✓ Entregue | > 20 chamadas API → rate limiting silencioso. |

### Banco de dados:
- **460 questões** · 13 disciplinas · Cargo 202 (Técnico Administrativo — Instituto Quadrix)
- Schema: multi-usuário com RLS · Clickwrap V2 gravado
- Telemetria: `horario_inicio_sessao`, `ttl_resposta_ms`, `metricas_diarias`

---

## DECISÕES FIXADAS (não reverter sem veredito)

| Decisão | Princípio | Razão |
|---|---|---|
| Zero tela de login para Ingrid | P-045 | Interromperia sessão ativa — abandono silencioso |
| Micro-Simulado só recicla questões SM-2 | P-038 | Banco fixo em 460 — inéditas esgotam o pool |
| Persona Sargento = DESCARTADO | E-1 (Embaixador) | Confronto verbal → abandono sem aviso |
| Distrator visível repetitivo = DESCARTADO | E-1 (Embaixador) | Frustração sem nomeação → churn silencioso |
| Heatmap linguagem conquista (Mapa de Soberania) | G-4 (Gemini) | Ingrid movida por confirmação, não ameaça |

---

## ALERTAS ATIVOS PARA O LOOP 5

- **[P-045]** RLS no backend — Ingrid NUNCA vê tela de login
- **[P-038]** Contador de Pontos só usa dados reais do banco — não gerar dados fictícios
- **[P-003]** Sem scraping — questões só via Claude API
- **[P-007]** Validar toda RPC/Edge via CLI antes da UI
- **[P-023]** Clickwrap V2 ativo — não reverter nem criar V3 sem veredito
- **[Burn Rate]** `BURN_RATE_DAILY_LIMIT_USD=5.00` antes de qualquer call API
- **[Telemetria]** `horario_inicio_sessao` disponível — usar no Contador para segmentação temporal

---

## TEMPERATURA DA CLIENTE

- **Status:** VERDE FRÁGIL → **VERDE CONSOLIDANDO** (hábito > 2 semanas pós Loop 4)
- Ingrid usa diariamente. Reporta bugs de formatação e lê enunciados de forma literal (mindset Quadrix).
- Engajamento no Micro-Simulado dominical: a confirmar no próximo check-in.
- Não reclama quando frustrada — abandona silenciosamente. Embaixador monitora.

---

## PRÓXIMOS PASSOS (Loop 5 — Dias 12-13)

1. **Contador de Pontos Ponderados** — exibir pontuação simulada (peso 1 correto/errado + peso 2 correto/errado) em header ou dashboard. Base: `progresso_usuario` + `plano_build` + pesos do edital.
2. **Notificações Push dominicais** — lembrar Ingrid do Micro-Simulado. Viabilidade iOS Safari (PWA) precisa teste antes do build.

**Incógnita crítica:** Push funciona em iOS Safari? (limitação estrutural do PWA — confirmar antes de prometer à Ingrid.)
