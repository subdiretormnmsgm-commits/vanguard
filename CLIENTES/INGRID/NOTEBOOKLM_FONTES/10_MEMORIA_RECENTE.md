# MEMÓRIA V6 — PROJETO INGRID
> Diretriz V6 · Loop 5 (Gemini) / Loop 6 (interno) · Engajamento Pós-Entrega
> Gerada em 2026-05-28 — encerramento do ciclo DIRETRIZ V6

---

## ESTADO TÉCNICO ENTREGUE

**Stack ativa:** PWA Vanilla JS + Supabase (projeto próprio Ingrid yjqvjhezwhepwomukudt) + Claude API (Haiku) · Deploy GitHub Pages
**Versão:** v20 · Commits: 14e041f (v19) + a2b42f5 + 86e112b (v20)
**URL produção:** https://subdiretormnmsgm-commits.github.io/vanguard/

### Features entregues neste ciclo (DIRETRIZ V6):

| Feature | Status | Commit | Observação |
|---|---|---|---|
| F-1 Saudação Noturna Dinâmica (E-5) | Entregue | 14e041f | `getHours()` → Bom dia/tarde/noite. Após 18h: "N questões te esperam" |
| F-2 G-5 Distração Vingativa Silenciosa | Entregue | a2b42f5 | Pegadinhas injetadas no feed sem label visível — Ingrid não percebe o padrão |
| F-4 Gatilho Temporal 19h45 + pg_cron | Entregue | a2b42f5 | Edge Function `notificar-progresso` + cron job Supabase. Fallback: Push Mágico de Oz |
| F-5 Modo Véspera (M-3) | Entregue | 14e041f | Toggle no Dashboard Eduardo · `modo_vespera:true` enviado ao `feed-diario` · ativar 2026-08-30 |
| F-6 Relatório Semanal WhatsApp (M-4 + E-3) | Entregue | a2b42f5 | Edge Function `relatorio-semanal` · Haiku API · template semanal + % acerto Quadrix 7 dias |
| F-7 Raio-X SVG + G-4 Brasão Semanal | Entregue | 14e041f | html2canvas export PNG · brasão calculado (semanas desde 2026-05-15) |
| F-8 Termômetro da Aprovação (M-2) | Entregue | 14e041f | Widget fim de sessão: `Nota Projetada vs Linha de Corte` · reusa `get_heatmap_disciplinas` |

### DADOS-WATCH — VERDE (2026-05-28):
- 1 user_id distinto: `00000000-0000-0000-0000-000000000001`
- 102 registros em `progresso_usuario` · nenhuma contaminação
- SM-2, Heatmap e Termômetro lendo dados corretos

### LEGAL-WATCH — VERDE (2026-05-27):
- Reassinatura física do Termo de Uso confirmada
- Token Supabase CLI exposto revogado pelo Diretor

---

## DECISÕES FIXADAS (não reverter sem veredito)

| Decisão | Princípio | Razão |
|---|---|---|
| G-5 Silenciosa sem label | P-031 Embaixador | "Vingativa" visível = ansiedade para Ingrid (H-7 lê com atenção literal) |
| Modo Véspera ativado por Eduardo, não Ingrid | P-031 Embaixador | Transição invisível — Ingrid não percebe mudança de mode |
| F-8 aguarda DADOS-WATCH | DELIBERAÇÃO V6 | Nota projetada inválida se user_id errado — verde confirmado |
| Gatilho às 19h45 | N-1 validado | Horário modal de sessão noturno (~20h) confirmado verbatim |

### VETADOS PERMANENTEMENTE (não reabrir):
- G-3 Bloqueio TTL — churn silencioso garantido
- G-1 Simulador Invalidação Parcial — frustração artificial
- M-1 Streak com Punição — abandono sem reclamação

---

## ALERTAS ATIVOS

| Alerta | Severidade | Ação |
|---|---|---|
| GitHub Pages push bloqueado (secret no histórico — já revogado) | Amarelo | Eduardo: link de desbloqueio no GitHub Security |
| Edge Functions Supabase não deployadas via CLI (auth pendente) | Amarelo | `! supabase login` + `deploy --project-ref yjqvjhezwhepwomukudt` |
| Ingrid não conhece candidatos — indicação = zero curto prazo | Pipeline | Pitch SaaS ao verbalizar uso ativo — janela: após DADOS-WATCH + LEGAL-WATCH |
| Sentinel Report Valdece | 2026-06-02 | Separado de Ingrid — não contaminar contextos |

---

## ESTADO DOS GATES

| Gate | Status |
|---|---|
| Dias 1-15 completos | Todos APROVADOS (último: 2026-05-26) |
| DADOS-WATCH user_id | VERDE 2026-05-28 |
| LEGAL-WATCH | VERDE 2026-05-27 |
| v20 em produção | Deploy ativo GitHub Pages |

---

## PRÓXIMO LOOP (Loop 6 — Gemini V7)

**Triggers:** DADOS-WATCH VERDE confirmado · Ingrid usando diariamente · "Gostei bastante. Amanhã volto para atacar mais" (2026-05-24)
**Temperatura:** 7.5/10 — VERDE SUSTENTADO
**Foco sugerido Loop 6:**
- SaaS Readiness Audit completo — readiness para segundo cliente
- Pitch plano mensal R$97/mês quando Ingrid verbalizar progresso
- Semente pós-aprovação E-4: "quando você passar, vou ter o sistema pronto para quem você indicar"
- Monitorar engajamento com F-6 (Relatório Semanal WhatsApp)

**Pendências antes do Loop 7:**
- [ ] Deploy Edge Functions via `supabase login + deploy`
- [ ] Desbloquear GitHub Pages push
- [ ] Eduardo: script E-4 ("quando você passar...") na próxima mensagem pós-DADOS-WATCH
- [ ] Eduardo identifica qual feature trouxe Ingrid de volta (E-1) — pergunta casual
- [ ] Wipe & Sync NotebookLM antes do Loop 7

---

*Músculo — Pentalateral IAH — 2026-05-28*
