# SKILL: ingrid-v4.md
**Camada:** 2 (Produto - Dias 9 a 11) | **Loop:** #4 | **Stack:** PWA Vanilla JS + Supabase + RPC

## [AUDITORIA DE COERENCIA]
PROJ-002 (Ingrid). Status: LIVE (gh-pages). Gate Dia 8 APROVADO 2026-05-19.
Alertas ativos — VETO obrigatório:

- **[P-045]** RLS preparado no backend, mas frontend DEVE manter acesso contínuo/invisível. VETO a qualquer tela de login com e-mail/senha da Ingrid neste loop.
- **[P-038]** Banco com 460 questões. Micro-Simulado NÃO DEVE consumir questões inéditas — reciclar questões com menor *easiness_factor* e maiores erros da semana.
- **[P-023]** Erro de data no Termo de Uso (30/05 vs 18/05) — novo Clickwrap obrigatório gravando a string "termo_v2_18_05" no banco de dados.
- **[P-024]** Cargo 202 (Técnico Administrativo), não TDAS — recalibração obrigatória em toda referência ao cargo.
- **[P-003]** Sem scraping TEC Concursos — decisão fechada.

## [CONEXAO HISTORICA]
Loops 1-3 provaram: Edge Functions gerar-questoes + feed-diario deployadas e validadas. Arquitetura: 1 Claude call por Edge Function invocação — nunca reverter. Feed 70/30 funciona. Tutor Socrático 3 níveis funciona. TTI aceitável. Clickwrap V1 com erro de data — corrigir neste loop.

Temperatura da cliente: VERDE FRÁGIL (Q18 na sessão inaugural do Loop 4). Ingrid engajou nativamente, lê os enunciados de forma literal (mindset Quadrix) e reporta bugs de formatação (ausência de negritos). Hábito com menos de 72h — não é verde consolidado. Próxima avaliação: sessão 3-5 quando SM-2 começa a cobrar.

Banco de questões: 460 questões · 13 disciplinas · Cargo 202 · Supabase.

## [PADRAO DE SUCESSO/FALHA]
**Padrão de sucesso validado:** Feed diário + Tutor Socrático + Clickwrap funcionam. Cliente usa diariamente sem atrito. Gate Dia 8 passou com TTI aceitável e 0 erros.

**Padrão de falha documentado:**
- Tela de login interrompe sessão da Ingrid (P-045 — veto total)
- Questões inéditas no Micro-Simulado esgotam banco de 460 questões (P-038 — reciclar apenas)
- Heatmap UI pode tomar 6h+ — decompor em sub-tarefas antes de estimar (Otimismo de Estimativa)
- Distrator repetitivo sem contexto gera frustração, não aprendizado (Embaixador [E-feedback])
- Persona agressiva por TTI baixo cria estresse que usuária não nomeia mas abandona silenciosamente

**Sequência de build Dias 9-11:**
1. **Dia 9** — RPCs/Stored Procedures no Supabase para Heatmap (agrupando progresso_usuario por disciplina Peso 2) + RLS configurado mantendo auto-login + Clickwrap V2 ("termo_v2_18_05"). Gate: RPCs retornam dados corretos via CLI.
2. **Dia 10** — UI Heatmap/Curva de Erro: mostrar onde Quadrix está "vencendo" (ex: "Você caiu em X pegadinhas de 'exceto' em Dir. Administrativo"). Linguagem: conquista, não ameaça. Gate: Heatmap correto por disciplina verificado via CLI.
3. **Dia 11** — Micro-Simulado Dominical: timer + penalidade Quadrix (1 errada anula 1 certa) + bloquear feed normal para evitar concorrência + apenas questões de repetição espaçada (vencidas/erradas). Gate: simulado completo funcional.

**O que NÃO construir:**
- NÃO tela de Login que interrompa sessão da Ingrid (P-045)
- NÃO exportações PDF pesados no PWA
- NÃO Leaderboards, Rankings ou gamificação social
- NÃO Persona Sargento ou confronto verbal por TTI baixo (ALERTA CRÍTICO do Embaixador)
- NÃO Distrator Assombração antes de confirmar tolerância de Ingrid a repetição de erro

## [PERSPECTIVA DO SOCIO]
Ingrid é movida por confirmação de progresso, não por ameaça. Heatmap deve enquadrar disciplinas conquistadas como "território soberano", não "zona de conforto a evitar". Frase certa: "SUAS — Fundamentos: você já tem esse." Frase errada: "baixa prioridade".

Simulado Dominical: verificar horário de estudo com Eduardo antes de construir — feature desperdiçada se ela não estuda aos domingos. Dado crítico não capturado pelo sistema: horário de pico da Ingrid.

Ação pendente antes do build do Dia 11: Eduardo confirma no check-in de 2026-05-21 se Ingrid estuda no domingo.

**Princípios obrigatórios neste loop:** P-003, P-007 (validar motor via CLI antes da UI), P-010 (gate verificável em cada dia), P-013 (Ingrid tem acesso admin ao próprio Supabase desde o Dia 1), P-023, P-024, P-031 (Embaixador filtra toda ideia — peso maior que G e N), P-037 (Músculo consolida 25 inputs em 1 plano), P-038, P-045.

Lei 5 — Burn Rate Shield: `BURN_RATE_DAILY_LIMIT_USD=5.00` antes de qualquer chamada Claude API.
