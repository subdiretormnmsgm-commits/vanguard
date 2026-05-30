# DELIBERAÇÃO LOOP V7 — PROJ-002 INGRID
> Síntese P-037 — Músculo consolida 25 inputs em 1 plano
> Data: 2026-05-30 | Loop: 7 | Fase: SaaS Readiness + Pipeline Comercial
> Sequência: Gemini (DIRETRIZ V7) ✅ → NotebookLM (ingrid-v7.md) ✅ → Embaixador (SEÇÃO D) ✅ → Músculo P-037 ✅
> Status: DELIBERAÇÃO CONCLUÍDA — DECISOES.json gerado — aguarda vereditos do Diretor

---

## 1. ESTADO ATUAL — CONTEXTO QUE PRECEDE ESTE LOOP

| Campo | Estado |
|---|---|
| App | v20 live — GitHub Pages ativo |
| Supabase | Projeto da Ingrid (yjqvjhezwhepwomukudt) — soberania P-013 VERDE |
| Gate Dia 15 | APROVADO 2026-05-30 |
| LEGAL-WATCH | VERDE — Termo 18/05/2026 · reassinatura física 2026-05-27 |
| DADOS-WATCH | VERDE — 102 respostas · 1 user_id correto |
| Temperatura | 7.5/10 · tendência SUBINDO · score sustentado sem intervenção ativa |
| Deploy CLI | PENDENTE — F-4 (cron 19h45) e F-6 (relatório semanal) não autônomos |
| GitHub Pages | BLOQUEADO — token no histórico |
| Pipeline | Ingrid não conhece candidatos → referral pós-aprovação (semear agora) |
| Shift comportamental | "Gostei bastante. Amanhã volto para atacar mais" (2026-05-24) — H-8 CONFIRMADA |
| Gap crítico | 24/05 a 30/05 sem registro de uso documentado — debrief 31/05 obrigatório |

---

## 2. OS 25 INPUTS — SÍNTESE COM FILTRO DO EMBAIXADOR

### MÚSCULO [M-1 a M-5] · relatorio_V6_INGRID

| # | Ideia | Reação Embaixador Loop 7 | Decisão P-037 |
|---|---|---|---|
| M-1 | Painel de Uso Real para Eduardo (não Ingrid) | CONFIRMA + EXPANDE — campo "última sessão há X dias" com fundo amarelo/vermelho por threshold | **ENTRA** — adicionar visual de threshold de risco (3d=amarelo, 5d=vermelho) |
| M-2 | Gatilho de Reativação após 5 dias sem sessão | CONFIRMA com ressalva — verificar horário pico histórico antes de disparar | **ENTRA** — integrar verificação de horário modal (~20h) antes de enviar |
| M-3 | Score de Consistência Semanal (não de acerto) | CONFIRMA — atleta pergunta treino, não acerto. Adicionar "consistência necessária" como meta | **ENTRA** — integrar ao F-6 com benchmark "padrão de aprovados é X/7" |
| M-4 | Link de Demonstração Anônimo para Prospects | EXPANDE + ALERTA ALTO — com 1 usuária, anonimato é fictício. Ingrid reconheceria os dados | **BLOQUEADO** — liberar apenas com segunda usuária ativa |
| M-5 | Audit Trail de Churn Risk — Alerta Compound Telegram | CONFIRMA — adicionar tempo em horas, não apenas dias ("4d 7h" é mais urgente que "5 dias") | **ENTRA** — incluir timestamp em horas na mensagem do Telegram |

### ESTRATEGISTA [G-1 a G-5] · DIRETRIZ V7 — Gemini

| # | Ideia | Reação Embaixador Loop 7 | Decisão P-037 |
|---|---|---|---|
| G-1 | Safe-Horizon SM-2 Adaptativo (prova atrasar 2027) | ALERTA ALTO — introduzir modo manutenção de 2027 é sinal confuso de falha prevista. Ingrid não lida bem com ambiguidade de prazo | **FLAG TÉCNICA INTERNA APENAS** — zero UX. Desabilitada por padrão. Nunca expor a Ingrid |
| G-2 | Dry-Run Isolamento de Tenant (test_tenant_isolation.ps1) | CONFIRMA — implicação comercial: segunda usuária não pode entrar sem este teste | **ENTRA como Gate 7.2** — pré-requisito absoluto para segundo cliente |
| G-3 | Mapeador Replicabilidade Quadrix (próximo nicho 80%) | ALERTA ALTO — desvio de foco. Ingrid não tem rede. Ferramenta de pipeline, não produto | **ANÁLISE OFFLINE** — Eduardo + Embaixador identificam próximo cargo. Não entra no produto |
| G-4 | Telemetria Passiva por Evento de Componente (F-7, F-8) | CONFIRMA + EXPANDE — rastrear tempo por tela, não apenas clique. F-7 olha mas não toca; F-8 verifica sempre | **ENTRA** — rastrear permanência por tela + cliques em `evento_uso` |
| G-5 | Git Hook pre-push Antiamnésia (P-045) | CONFIRMA — ferramenta de processo. N-3 complementa | **ENTRA** — `.git/hooks/pre-push` verificando MEMORIA + relatorio + secrets |

### AUDITOR [N-1 a N-5] · ingrid-v7.md

| # | Ideia | Reação Embaixador Loop 7 | Decisão P-037 |
|---|---|---|---|
| N-1 | Telemetria de Vínculo Contratual (LEGAL-WATCH no painel) | CONFIRMA — VERDE por memória vs VERDE por evidência. Serve de gatilho para próximas clientes | **ENTRA** — ícone LEGAL-WATCH permanente no Painel Eduardo |
| N-2 | Interceptor RLS Silencioso (fetch wrapper 403) | CONFIRMA — Ingrid não reportou erros, mas perfil dela é silêncio. Se houve 403, ela pode ter parado sem contar | **ENTRA** — fetch wrapper JWT reload passivo antes de qualquer migração multi-tenant |
| N-3 | Auditoria de Secrets no Git Hook (token sbp_) | CONFIRMA — diretamente responsável pelo GITHUB-WATCH ativo agora. Complementa G-5 | **ENTRA** — integrar ao pre-push do G-5 |
| N-4 | View SQL snapshot_ingrid_loop6_golden (102 registros imutáveis) | CONFIRMA + posição — 102 registros são o business case. Mas precisam virar relatório de performance, não só dados brutos | **ENTRA** — criar View + processar em relatório de performance para o pitch |
| N-5 | Pulse Check Analógico Pós-Automático | CONFIRMA — Ingrid percebe diferença. Calor humano pós-automação é diferenciação emocional do modelo Vanguard | **ENTRA** — Painel Eduardo emite notificação "Sistema enviou. Mande 👍 2h depois" |

### EMBAIXADOR [E-1 a E-5] · Loop 7 SEÇÃO D · 2026-05-30

| # | Ideia | Status P-037 |
|---|---|---|
| E-1 | Silêncio 24/05 a 30/05 não é churn — mas é dado ausente crítico | **GATE** — debrief casual 31/05 antes de qualquer decisão de pitch |
| E-2 | Gate Dia 15 foi técnico, não emocional — temperatura pode ter resfriado levemente | **MONITORAR** — não assumir 7.5 persiste. Confirmar no debrief de D3 |
| E-3 | Ausência de pedidos não confirma saúde — telemetria é o único termômetro confiável | **GATE** — M-1 (painel de uso) resolve isso estruturalmente |
| E-4 | Janela de pitch aberta, mas gatilho comportamental não acionado ainda | **TIMING** — debrief 31/05 é gate informal. Pitch só após "7 dias consecutivos + progresso verbalizado" |
| E-5 | F-6 (relatório semanal) é o coração do argumento de pitch R$97/mês | **URGÊNCIA #1** — deploy CLI de F-4 + F-6 é a ação mais crítica desta semana |

---

## 3. PLANO CONSOLIDADO — O QUE ENTRA AGORA

### BLOQUEANTES PRÉ-BUILD (nenhuma feature começa sem estes)

```
① D4: Eduardo segue link GitHub Security → desbloqueia push GitHub Pages
② D1: Músculo executa supabase login + deploy F-4/F-6 + smoke test (Gate 7.1)
③ D2: Músculo roda test_tenant_isolation.ps1 + verifica RLS (Gate 7.2)
```

### FEATURES QUE ENTRAM NO LOOP 7

| # | Feature | Complexidade | Dependência |
|---|---|---|---|
| F-A | **Telemetria passiva G-4** — `evento_uso` com tempo por tela (F-7, F-8) | Baixa — listener assíncrono | Supabase da Ingrid ativo |
| F-B | **Painel de uso Eduardo (M-1)** — última sessão + threshold visual | Baixa — HTML puro + DataTables + Views RPC | F-A (evento_uso) |
| F-C | **N-2 Interceptor RLS** — fetch wrapper 403 → JWT reload passivo | Baixa — wrapper em app.js | Deploy CLI Gate 7.1 |
| F-D | **N-4 View SQL golden** — 102 registros imutáveis + relatório de performance | Baixa — SQL View + query | Supabase da Ingrid |
| F-E | **M-5 Alerta Compound Telegram** — 3 sinais + timestamp em horas | Média — cron verification + Telegram API | F-4/F-6 deployados |
| F-F | **N-5 Pulse Check** — Painel Eduardo: "Sistema enviou. Mande 👍 2h depois" | Baixa — notificação no Painel | F-B (Painel Eduardo) |
| F-G | **G-5 + N-3 Git Hook** — pre-push: MEMORIA + relatorio + secrets sbp_ | Baixa — `.git/hooks/pre-push` | — |
| F-H | **N-1 LEGAL-WATCH visual** — ícone no Painel Eduardo | Baixa — query + ícone | F-B (Painel Eduardo) |

### BLOQUEADOS / ADIADOS

| Feature | Razão | Retorno |
|---|---|---|
| M-4 Link demo anônimo | Com 1 usuária, anonimato é fictício (Embaixador ALERTA ALTO) | Liberar com segunda usuária |
| G-1 Safe-Horizon | Zero UX — flag interna apenas | Desabilitada por padrão |
| G-3 Mapeador Quadrix | Análise offline do Embaixador, não feature do produto | Eduardo + Embaixador |

### AÇÕES DO DIRETOR (sem código)

| Ação | Timing | Artefato |
|---|---|---|
| D4: Seguir link GitHub Security | Hoje | — |
| D3: Debrief casual Ingrid | 31/05 | Mensagem sugerida: *"Ingrid! Aquela configuração que fizemos hoje ficou perfeita. Como você tá se sentindo com o estudo essa semana? 📚"* |
| D6: Plantar semente E-4 pós-aprovação | No debrief D3 | *"Quando você passar, você vai ser a prova que esse negócio funciona — aí a gente pensa em expandir. 😄"* |
| Pitch R$97/mês | SOMENTE após debrief 31/05 confirmar temperatura + 7 dias consecutivos | Script de pitch pronto no próximo loop |

---

## 4. GATES E SEQUÊNCIA DE EXECUÇÃO

```
SEQUÊNCIA INVIOLÁVEL — Loop 7 Build

① D4 (Eduardo) — GitHub Security desbloqueado
② Gate 7.1 (Músculo) — supabase login + deploy F-4/F-6 + smoke test
③ Gate 7.2 (Músculo) — test_tenant_isolation.ps1 + RLS VERDE
④ F-A Telemetria G-4 — evento_uso + tempo por tela
⑤ F-B Painel Eduardo — HTML puro + threshold visual
⑥ F-C Interceptor RLS (N-2)
⑦ F-D View SQL golden (N-4) + relatório de performance
⑧ F-E Alerta Compound Telegram (M-5) — timeout horas
⑨ F-F Pulse Check (N-5)
⑩ F-G Git Hook (G-5 + N-3)
⑪ F-H LEGAL-WATCH visual (N-1)
⑫ Smoke test integrado → Eduardo testa → aprova → v21
⑬ D3: Debrief casual 31/05 → coletar temperatura real
⑭ D6: Plantar semente E-4 no debrief
```

---

## 5. CUSTO REAL DO LOOP 7

| Item | Estimativa |
|---|---|
| Tempo de build (F-A a F-H) | ~4-6 horas Músculo |
| Deploy CLI Supabase | ~30 min (Eduardo + Músculo) |
| GitHub Security (Eduardo) | ~15 min |
| Claude API (incremental) | ~$0 (telemetria não usa API) |

---

## 6. IMPACTO COMERCIAL

- **F-6 deployado autonomamente**: primeiro relatório semanal chega sem Eduardo fazer nada → argumento de pitch real, não promessa
- **Painel de uso (M-1)**: Eduardo sabe quando acionar — sem suposições. Pitch no momento certo, não no momento conveniente
- **N-5 Pulse Check**: Ingrid associa cuidado humano ao sistema → diferenciação emocional de R$97/mês vs R$90 do TEC
- **View golden (N-4)**: "102 questões do Cargo 202, SM-2 calibrado para você, X% em Direito Administrativo" — business case concreto para pitch

---

## 7. PRÓXIMA AÇÃO DO DIRETOR

1. **Hoje:** D4 (GitHub Security link) → desbloqueia toda a cadeia de deploy
2. **Hoje:** Deliberar o PAINEL — render_painel.ps1 abre o browser para os vereditos D1-D6
3. **31/05:** Debrief casual com Ingrid (mensagem D3) — gate informal para pitch
4. **Quando VEREDITOS.json chegar:** Músculo executa sequência de build F-A a F-H

---

## 8. REGISTRO P-037

- **DELIBERAÇÃO criada:** 2026-05-30
- **Músculo responsável:** Claude Sonnet 4.6
- **Arquivo gerado:** CLIENTES/INGRID/HISTORICO/DELIBERACAO_LOOP_V7_INGRID.md
- **DECISOES.json:** gerado pelo Embaixador — salvo em CLAUDE_PROJECT/DECISOES/
- **Gate P-037:** CUMPRIDO — síntese documentada
