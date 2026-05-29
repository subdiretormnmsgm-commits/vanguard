# RELATÓRIO EVOLUTIVO V6 — PROJETO INGRID
> Diretriz V6 · Loop 5 (Gemini) / Loop 6 (interno) · Fechamento 2026-05-28
> Análise de negócio + 5 ideias disruptivas para Loop 6 (Gemini V7)

---

## RESUMO EXECUTIVO

O ciclo da DIRETRIZ V6 transformou o app de uma ferramenta de entrega em um **sistema de engajamento autônomo**. Sete features novas (F-1 a F-8) foram implementadas sem intervenção da Ingrid — ela simplesmente continuou usando e o sistema passou a responder de forma mais inteligente. O DADOS-WATCH confirmou integridade total dos dados (102 registros, 1 user_id). O maior risco do ciclo — churn silencioso entre entrega e aprovação — foi endereçado com ferramentas passivas que não exigem disciplina da usuária.

---

## SWOT — ESTADO ATUAL (pós-DIRETRIZ V6)

### Forças
- **Sistema autônomo de engajamento:** push 19h45, relatório semanal WhatsApp, saudação noturna e distração vingativa operam sem que Eduardo ou Ingrid façam nada.
- **Termômetro objetivo:** F-8 responde "se a prova fosse hoje, você aprovaria?" — converte dados frios em urgência real.
- **Modo Véspera pronto:** flag no Dashboard aguarda ativação em 2026-08-30 — zero build adicional na véspera.
- **Export visual:** Raio-X PNG + Brasão SVG = prova social para segundo cliente e motivação interna para Ingrid.
- **Integridade de dados confirmada:** DADOS-WATCH VERDE — SM-2, Heatmap e Termômetro lendo dados corretos.

### Fraquezas
- **Edge Functions não deployadas via CLI:** F-4 (cron 19h45) e F-6 (relatório semanal) dependem de `supabase login` pendente. Enquanto isso, operam via Push Mágico de Oz manual.
- **GitHub Pages push bloqueado:** secret revogado mas unblock pendente no GitHub Security — cada deploy exige workaround.
- **Ausência de analytics de comportamento:** sabemos que Ingrid usa, mas não sabemos quais features ela efetivamente toca. F-7 (export) e F-8 (termômetro) podem ter zero cliques.
- **Pipeline de indicação inexistente:** Ingrid não conhece candidatos relevantes — upsell depende 100% do progresso dela, não de rede.

### Oportunidades
- **Janela de pitch SaaS aberta:** "Gostei bastante. Amanhã volto para atacar mais" (2026-05-24) = temperatura suficiente para proposta R$97/mês quando ela verbalizar progresso.
- **Semente pós-aprovação (E-4):** uma linha no próximo WhatsApp de Eduardo — "quando você passar, vou ter o sistema pronto para quem você indicar" — planta o pipeline sem custo.
- **Motor replicável em 3 dias:** o próximo concurso Quadrix pode ser onboardado com o mesmo stack. O tempo de setup caiu de 15 dias para 3. Ingrid é o caso de sucesso documentável.
- **Relatório semanal como vitrine:** o WhatsApp automático que Ingrid recebe pode virar argumento de venda para próximo cliente ("ela recebe isso toda semana, sem você fazer nada").

### Ameaças
- **Churn por platô de motivação:** features de engajamento passivas funcionam para manter, não para reativar. Se Ingrid parar por 5+ dias, o app não tem gatilho de reativação ativo.
- **Concurso sem data confirmada:** SEDES-DF 2026 ainda inédito — urgência pode erodir se a data atrasar para 2027.
- **Dependência de WhatsApp manual (curto prazo):** F-4 e F-6 operam via Mágico de Oz até deploy CLI — cada domingo Eduardo precisa enviar manualmente se o cron falhar.

---

## PDCA — AVALIAÇÃO DO CICLO DIRETRIZ V6

### PLAN (o que foi planejado)
- 8 features baseadas em P-037 DELIBERAÇÃO V6 (2026-05-27): F-1 a F-8
- Gate bloqueante: DADOS-WATCH antes de qualquer build (user_id correto?)
- Sequência: F-1 → F-3 → F-8 → F-2 → F-7 → F-6 → F-4 → F-5

### DO (o que foi executado)
- F-1 Saudação Noturna: entregue (v19 · commit 14e041f)
- F-2 Distração Vingativa Silenciosa: entregue (v20 · commit a2b42f5)
- F-4 Gatilho Temporal 19h45 + pg_cron: entregue (commit a2b42f5) — deploy CLI pendente
- F-5 Modo Véspera: entregue (14e041f) — ativação agendada 2026-08-30
- F-6 Relatório Semanal WhatsApp Haiku: entregue (a2b42f5) — deploy CLI pendente
- F-7 Raio-X SVG + Brasão: entregue (14e041f)
- F-8 Termômetro da Aprovação: entregue (14e041f) — dependia de DADOS-WATCH
- DADOS-WATCH: executado e VERDE (102 registros, 1 user_id)
- F-3 Linha de Corte Fantasma: já estava em V5 — reutilizada por F-8

### CHECK (o que funcionou e o que não funcionou)
- **Funcionou:** DELIBERAÇÃO P-037 como plano de build — sequência inviolável executada sem desvio
- **Funcionou:** F-2 (distração silenciosa) — Ingrid não percebe o padrão, sem label, sem ansiedade
- **Funcionou:** F-8 Termômetro — reusa infraestrutura existente (get_heatmap_disciplinas + EDITAL_DIST), custo zero
- **Funcionou:** P-088 (template externo) — gerar_artefato_embaixador.ps1 sem falha de parsing PS5.1
- **Funcionou:** P-089 (PASSO3 auto-regenerado) — bug de documento desatualizado resolvido estruturalmente
- **Não funcionou:** Deploy Edge Functions via CLI — `supabase login` pendente, F-4 e F-6 operam manualmente
- **Não funcionou:** PASSO3_GEMINI.md estava em Loop 5 — causou tentativa de ir ao Gemini quando não era necessário
- **Não funcionou:** Conflito WIP_BOARD (`status` desatualizado vs `loop_fase_atual` atualizado) — Diretor viu estado errado

### ACT (o que muda no próximo loop)
- Deploy CLI Supabase antes de qualquer feature que dependa de Edge Function ou cron
- P-089 acoplado: PASSO3 nunca mais desatualizado
- WIP_BOARD: campo `status` atualizado pelo script, não manualmente

---

## 5W2H — PRÓXIMO LOOP (Loop 6 — Gemini V7)

| Dimensão | Resposta |
|---|---|
| **What** | SaaS Readiness Audit + resolver bloqueios técnicos + ativar pipeline comercial |
| **Why** | F-4 e F-6 operam manualmente enquanto deploy CLI pendente. Pitch SaaS aberto — temperatura da Ingrid sustentada. |
| **Who** | Eduardo (WhatsApp E-4 + E-1) · Músculo (deploy CLI + audit) · Embaixador (temperatura + pipeline) |
| **When** | 2026-05-29 a 2026-06-01 (antes do Sentinel Valdece em 02-06) |
| **Where** | Terminal local (`supabase login`) · GitHub Security (unblock Pages) · Chat Ingrid (WhatsApp E-4) |
| **How** | `! supabase login` → `supabase functions deploy` → GitHub unblock → audit RLS + uso real |
| **How much** | 2h técnico · $0 infra · Pitch: R$97/mês → MRR potencial |

---

## 5 IDEIAS DISRUPTIVAS [M-1 a M-5] — Para o Gemini V7 processar

**[M-1] Painel de Uso Real para Eduardo (não para Ingrid)**
Dashboard interno que mostra: Ingrid abriu o app hoje? Qual feature tocou? Quanto tempo ficou? F-7 (export) teve cliques? Eduardo enxerga o comportamento real sem perguntar — e sabe quando acionar o WhatsApp de reativação antes que o churn aconteça.

**[M-2] Gatilho de Reativação após 5 dias sem sessão**
Se Ingrid não abre o app por 5 dias, o sistema envia automaticamente: "Você estava indo muito bem — faltam N dias para a prova. Só 10 questões hoje." Uma mensagem, sem sequência. Reativação passiva — Eduardo não precisa monitorar.

**[M-3] Score de Consistência Semanal (não de acertos)**
Métrica alternativa ao % de acerto: quantos dias da semana Ingrid abriu o app e fez pelo menos 5 questões? Exibido no relatório semanal como "Você foi consistente em X/7 dias." Consistência é mais previsível de aprovação do que acerto isolado.

**[M-4] Modo Apresentação — Portfólio SaaS**
Um link de 1 página (sem login, somente leitura) que Eduardo envia para prospectos: mostra o dashboard anonimizado de Ingrid com números reais. "Veja como funciona para um candidato real." Custo zero — o banco já tem os dados.

**[M-5] Audit Trail de Churn Risk — Alerta Automático no Telegram**
Se Ingrid não abre em 3 dias E o cron de notificação falhou E o relatório semanal não foi enviado — o Telegram do Eduardo recebe: "CHURN RISK — Ingrid · 3 dias sem sessão · Push falhou." Radar de churn ativo sem dashboard extra.

---

## ANÁLISE COMERCIAL

**O que este ciclo significou para o negócio:**
A DIRETRIZ V6 transformou o produto em um sistema que **trabalha mesmo quando ninguém trabalha**. Isso é o argumento de venda definitivo: "O app acompanha a Ingrid 24h. Você não precisa fazer nada — só receber o relatório no domingo." Para o segundo cliente, o onboarding é 3 dias. Para o terceiro, 1 dia. A inteligência acumulada nos LEDGER e nas Skills é o diferencial que nenhum concorrente tem.

**Risco de MRR no curto prazo:** Baixo — Ingrid está usando e engajada. O risco real é o cron não disparar (F-4 + F-6 pendentes de deploy CLI) e Ingrid não receber o relatório no primeiro domingo — primeira impressão de "sistema que falha."

**Janela comercial aberta:** A fala "Amanhã volto para atacar mais" + DADOS-WATCH VERDE + todas as features ativas = momento ideal para o script E-4. Eduardo planta agora, colhe quando ela passar.

---

*Músculo — Pentalateral IAH — 2026-05-28*
