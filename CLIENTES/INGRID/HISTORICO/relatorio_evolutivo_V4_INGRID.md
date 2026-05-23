# RELATÓRIO EVOLUTIVO V4 — PROJETO INGRID
> Loop 4 · Dias 9-11 · Gate Dia 11 APROVADO 2026-05-20
> Gerado retroativamente em 2026-05-23

---

## SWOT DO LOOP 4

### Forças
- **Heatmap (Mapa de Soberania)** entregue e funcional — linguagem de conquista, não ameaça. Diferencial de pitch real.
- **Micro-Simulado Dominical** com penalidade Quadrix — treino de pressão alinhado ao formato da banca.
- **RLS + auto-login invisível** — Ingrid sem fricção. Backend pronto para scale 1→500 usuárias.
- **Telemetria comportamental** (`horario_inicio_sessao`, `ttl_resposta_ms`, `metricas_diarias`) ativa — dados para segmentação futura.
- **Burn Rate Shield** operacional — risco de estouro de API mitigado.

### Fraquezas
- **MEMORIA_V4 não foi gerada no fechamento real do Loop 4** — sanada retroativamente (P-045 não seguido na transição 11→12).
- **Loop 3 / ingrid-v3.md** nunca gerados formalmente pelo NotebookLM — ingrid-v4 assumiu continuidade sem skill de transição.
- **Horário de pico da Ingrid ainda não confirmado** — dado crítico para eficácia do Push dominical.
- **Push iOS Safari** — limitação técnica de PWA não testada antes do planejamento do Loop 5.

### Oportunidades
- **Contador de Pontos Ponderados** (Loop 5) fecha o ciclo de progresso visível — responde objetivamente "quanto valho nessa prova?"
- **Raio-X Pessoal** (G-5, Loop 6) com 15+ dias de dados tem potencial de ser o maior gerador de indicação.
- **460 questões com telemetria** = corpus de comportamento real. Argumento de pitch: "feito para quem estuda depois das 20h."
- **Schema multi-usuário pronto** — monetização SaaS em 1 configuração de admin.

### Ameaças
- **Deadline 2026-05-30** — 7 dias para Dias 12-15 + offboarding. Margem zero para bugs de estimativa.
- **Hábito em VERDE FRÁGIL** — menos de 3 semanas de uso. Uma interrupção pode desfazer o ganho comportamental.
- **Push como feature visível** — se não funcionar em iOS (limitação PWA), quebra expectativa gerada.

---

## PDCA DO LOOP 4

### Plan
- Construir Heatmap + Micro-Simulado + RLS como entregáveis principais.
- Gate de qualidade: Heatmap correto via CLI + simulado domingo funcional.

### Do
- **Acertos:** Todos os 13 componentes listados na MEMORIA_V4 entregues. Convergência Gemini (G-4) + Auditor (N-5) + Embaixador (E-3) no Mapa de Soberania — decisão com 3 votos independentes.
- **Falha de processo:** MEMORIA e relatorio não gerados no fechamento — detectado no Loop 5 via P-045.

### Check
- Gate Dia 11 APROVADO 2026-05-20.
- Temperatura da cliente: VERDE FRÁGIL → consolidando.
- Micro-Simulado dominical: funcionando conforme check-in 21/05.

### Act
- P-045 registrado como active alert: fechar todo loop com MEMORIA + relatorio antes de iniciar o próximo.
- Loop 5 desbloqueado após geração retroativa dos artefatos.

---

## 5 IDEIAS DISRUPTIVAS DO MÚSCULO [M-1 a M-5]

| # | Ideia | Loop |
|---|---|---|
| M-1 | **Modo Sedes-DF Chrome** — limitar interface a 1 questão por vez + timer fixo (simula tela de prova real) | Loop 5 ou 6 |
| M-2 | **Contador de Pontos como argumento de venda** — gerar imagem SVG com "Simulado: você tiraria X pontos de Y" compartilhável no WhatsApp | Loop 5 |
| M-3 | **Push adaptativo por horário de pico** — se `horario_inicio_sessao` mostra que Ingrid estuda 20h-22h, Push vai às 19h50 | Loop 5 |
| M-4 | **Raio-X de Armadilhas Quadrix** — agrupar questões erradas por tipo de pegadinha (prescinde / salvo / nunca) para treino cirúrgico | Loop 6 |
| M-5 | **Relatório semanal automatizado** — RPC `progresso_semanal` já existe · Eduardo envia via WhatsApp · Argumento de SaaS: "resumo automático toda segunda" | Loop 5 |

---

## INDICADORES DE NEGÓCIO

| Métrica | Valor |
|---|---|
| Valor gerado/candidato | R$ 9.750 (tempo + probabilidade aprovação estimada) |
| Serviço personalizado (externo) | R$ 2.500/candidato |
| Licença SaaS por ciclo | R$ 197 |
| SaaS B2C MRR | R$ 97/mês × 4 meses = R$ 388/usuária |
| Meta SaaS ciclo Sedes-DF | 500 usuárias = R$ 194.000 |
| Prazo para monetização | Após offboarding da Ingrid (pós-30/05) + SaaS Readiness Audit (Dias 14-15) |
