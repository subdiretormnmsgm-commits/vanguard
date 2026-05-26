# PASSO 7 — EMBAIXADOR (CLAUDE PROJECTS) · PROJETO INGRID · LOOP 5
> Instância do PASSO7_EMBAIXADOR_TEMPLATE.md · Atualizado em 2026-05-23
> Eduardo não edita este arquivo — é o guia de ativação do Embaixador para este projeto.
> Músculo atualiza a SEÇÃO D com ideias dos sócios ao fechar cada loop.

---

## INSTRUÇÕES PARA O DIRETOR — COMO ACIONAR O EMBAIXADOR

```
1. RODAR no terminal (Músculo executa automaticamente):
   .\scripts\ir_ao_embaixador.ps1 -cliente INGRID
   → Script copia MENSAGEM_INTERACAO_INICIAL para clipboard
   → Abre browser em claude.ai/projects
   → Abre Explorer na pasta CLIENTES\INGRID\CLAUDE_PROJECT\

2. NO CLAUDE PROJECTS:
   Colar o bloco da SEÇÃO correspondente ao tipo de ativação no chat
   (Embaixador tem memória persistente — não precisa de anexos)

3. AGUARDAR resposta do Embaixador (7 blocos obrigatórios).
   Ao fechar SEÇÃO D: aguardar também o Painel de Deliberação (Artifact interativo).
   Músculo atualiza MEMORIA_EMBAIXADOR.md automaticamente via P-032.
   Músculo NÃO executa nenhuma ação da Síntese Final antes de receber JSON de vereditos do Painel.
```

> O Embaixador é o único membro com memória persistente da Ingrid entre sessões.

---

## PROTOCOLO ANTI-DEFICIÊNCIAS DO EMBAIXADOR

**Deficiência 1 — Viés de Afinidade**
Ingrid é gentil e não reclama quando frustrada — abandona silenciosamente.
Contra-ataque: exigir flags negativos concretos. Relatório só positivo = SV imediato.

**Deficiência 2 — Excesso de Otimismo de Engajamento**
Pode interpretar uso diário como consolidação quando ainda é hábito frágil (<3 semanas).
Contra-ataque: sem uso do app por 3+ dias → [CHURN-WATCH] obrigatório. VERDE FRÁGIL ≠ VERDE.

**Deficiência 3 — Omissão de Flags Desconfortáveis**
Pode suavizar risco de push iOS (limitação técnica real que afeta a expectativa da Ingrid).
Contra-ataque: Músculo pergunta diretamente: "Qual o sinal mais preocupante sobre Ingrid agora?"

**Deficiência 4 — Limitação a Evidências**
"Não tenho evidência direta, mas vejo este risco/oportunidade" é contribuição obrigatória.
Nunca limitar a citar o que Ingrid fez — contribuir com o que nenhum outro membro viu.

**DEF-E-6 — Silo de Cliente**
Vê Ingrid isoladamente. Ao emitir [E-1 a E-5], aplicar INTELIGENCIA_CRUZADA_NICHO se houver outro cliente EdTech:
```
INTELIGENCIA_CRUZADA_NICHO (quando aplicável):
  Padrão em [CLIENTE-A]: [comportamento]
  Padrão em [CLIENTE-B]: [comportamento]
  O que isso sugere para o nicho EdTech-Concurso: [hipótese]
```

**DEF-E-7 — Temperatura Simples**
Usar sempre TEMPERATURA_PONDERADA:
```
TEMPERATURA_PONDERADA:
  Temperatura atual: [FRIA / MORNA / QUENTE / ENTUSIASMADA]
  Tendência (últimos 7 dias): [subindo / estável / caindo]
  Contexto de pagamento: [pago / pendente / risco]
  Score 0-10: [N]  ← Score < 6 = CHURN-WATCH automático
```

**DEF-E-8 — Painel Ausente**
Embaixador que fecha SEÇÃO D sem gerar o Painel de Deliberação entregou análise — não ciclo fechado.
O Painel é parte obrigatória da entrega, não opcional. Sem Painel = Músculo não sabe o que executar.
Se JSON não chegar em 48h → Músculo emite ALERTA ao Diretor e solicita veredito manual simplificado.

---

## CABEÇALHO DA ATIVAÇÃO

```
ATIVAÇÃO DO EMBAIXADOR — INGRID
Data: [YYYY-MM-DD]
Loop: 5 | Fase: [PRÉ-REUNIÃO / DEBRIEF / PIPELINE / REAÇÃO AO PENTALATERAL]
Modo: [FLASH / COMPLETO]
```

---

## CONTEXTO ATUALIZADO DO PROJETO — Loop 5

**Cliente:** Ingrid
**Projeto:** Ferramenta de Estudo Sedes-DF — Cargo 202 (Técnico Administrativo)
**Banca:** Instituto Quadrix | **Data prova:** 2026-09-06 | **Deadline entrega:** 2026-05-30
**Camada:** 2 — Produto | **Loop atual:** 5 (Dias 12–13)
**Temperatura atual:** VERDE FRÁGIL → VERDE CONSOLIDANDO (hábito ~2 semanas)
**App:** https://subdiretormnmsgm-commits.github.io/vanguard/ — LIVE

**Gates aprovados:**
- Dia 2: qualidade das questões
- Dia 5: feed 70/30 funcional (7 dias, 0 erros)
- Dia 8: PWA completo — Clickwrap + Tutor 3 níveis + Fallback + TTI (APROVADO 2026-05-19)
- Dia 11: Heatmap (Mapa de Soberania) + Micro-Simulado Dominical (APROVADO 2026-05-20)

**Banco:** 460 questões · 13 disciplinas · Cargo 202

**Missão Loop 5 (Dias 12-13):**
- Contador de Pontos Ponderados — "quanto valho nessa prova?"
- Notificações Push dominicais — lembrete do Micro-Simulado
- Incógnita crítica: Push via PWA funciona em iOS Safari?

**Perfil comportamental confirmado:**
- Usa o app diariamente — hábito em formação, não consolidado
- Lê enunciados de forma literal (mindset Quadrix — não generaliza)
- Não reclama quando frustrada — abandona silenciosamente
- Motivação: confirmação de progresso concreto ("seu terreno")
- Micro-Simulado dominical: engajamento a confirmar no próximo check-in
- Horário de pico: dado disponível em `horario_inicio_sessao` — ainda não confirmado verbalmente

**Watchdog ativo:**
- [CHURN-WATCH] se sem uso >3 dias a partir de 2026-05-23
- [SCOPE-WATCH] compartilhamento de login — endereçar no SaaS Readiness Audit (Dias 14-15)
- [PIPELINE] Ingrid conhece outras candidatas prestando Sedes-DF?

---

## MISSÃO DESTA ATIVAÇÃO — MARCAR APENAS UMA

- [ ] SEÇÃO A — BRIEFING PRÉ-REUNIÃO (gate ou entrega se aproximando)
- [ ] SEÇÃO B — DEBRIEF PÓS-REUNIÃO (após qualquer contato real com Ingrid)
- [ ] SEÇÃO C — PIPELINE DE LEAD (Ingrid mencionou alguém)
- [ ] SEÇÃO D — REAÇÃO AO PENTALATERAL (após receber DIRETRIZ V6 + Skill ingrid-v5.md)

---

## SEÇÃO A — BRIEFING PRÉ-REUNIÃO

> Usar antes de qualquer contato significativo com Ingrid (check-in, gate, entrega).

```
Embaixador, briefing pré-contato com INGRID.

ESTADO ATUAL (2026-05-23):
- Loop 5 em andamento — Dias 12-13: Contador de Pontos + Push dominical
- Temperatura: VERDE FRÁGIL → consolidando. Hábito ~2 semanas.
- Gate Dia 11 APROVADO — Mapa de Soberania entregue, Micro-Simulado ativo
- Deadline do projeto: 2026-05-30 (7 dias restantes)
- Incógnita: Push funciona em iOS Safari? (confirmar antes de prometer à Ingrid)

PEDIDO AO EMBAIXADOR:
1. Qual o risco de engajamento mais urgente para os próximos 7 dias?
2. O que Eduardo NÃO deve prometer sobre notificações Push (limitação iOS)?
3. Como apresentar o Contador de Pontos sem criar ansiedade em vez de motivação?
4. Análise inovadora: há algo que nenhum outro membro está vendo sobre este momento?
```

---

## SEÇÃO B — DEBRIEF PÓS-REUNIÃO (Passo 8.5)

> Usar após qualquer interação com Ingrid — Gate, WhatsApp, check-in.

```
Embaixador, debrief pós-contato com INGRID.

O QUE ACONTECEU (Eduardo relata):
[DESCREVER: o que foi discutido, como ela reagiu ao app,
 comentários sobre o Micro-Simulado dominical, horário de uso, etc.]

PEDIDO AO EMBAIXADOR:
1. Ingrid usa o app aos domingos? (crítico para a feature Push)
2. Qual é o horário de uso real (manhã / tarde / noite)?
3. Há sinais de [CHURN-WATCH]? (comparação negativa, frustração, silêncio prolongado)
4. Há sinais de [SCOPE-WATCH]? (compartilhamento de login, expectativa além do contrato)
5. Ingrid mencionou alguém? → acionar SEÇÃO C se sim
6. TEMPERATURA_PONDERADA atualizada (formato obrigatório acima)
7. Análise inovadora: o que não foi dito neste relato que o perfil da Ingrid sugere?

ATUALIZAR MEMORIA_EMBAIXADOR com:
- Data + resumo de 3 linhas
- Confirmações sobre uso dominical e horário de pico
- Alertas ativos
- Temperatura atualizada
- Próxima ação recomendada
```

---

## SEÇÃO C — PIPELINE DE LEAD

> Usar quando Ingrid mencionar outra candidata prestando Sedes-DF ou concurso similar.

```
Embaixador, pipeline de lead detectado a partir de INGRID.

O QUE INGRID DISSE:
[DESCREVER: o que foi mencionado, contexto, como surgiu]

PEDIDO AO EMBAIXADOR:
1. Perfil mais provável deste lead (cargo, banca, fase do ciclo)?
2. Qual pergunta casual Eduardo planta na Ingrid para qualificar sem parecer comercial?
3. INTELIGENCIA_CRUZADA_NICHO: o padrão de Ingrid sugere algo sobre este nicho?
4. Business case: a plataforma suporta uma segunda candidata sem mudança de código?
   (RLS já ativo — resposta técnica é sim, confirmar com Embaixador)
```

---

## SEÇÃO D — REAÇÃO AO PENTALATERAL (P-031)

> Usar após receber DIRETRIZ V6 do Gemini + Skill ingrid-v5.md do NotebookLM.
> [G-1 a G-5] e [N-1 a N-5]: preencher com as ideias reais recebidas antes de enviar.

```
Embaixador, reação ao ciclo atual do Pentalateral — INGRID.
Loop 5 · Sessão 2026-05-23 · Dias 12-13: Contador de Pontos + Push

[M-1 a M-5] — IDEIAS DO MÚSCULO (Loop 4 · relatorio_V4):

M-1: Modo Sedes-DF Chrome — limitar interface a 1 questão por vez + timer fixo.
     Simula tela de prova real. Pergunta: Ingrid treinaria nesse modo ou evitaria a pressão?

M-2: Contador de Pontos como argumento de venda — SVG compartilhável no WhatsApp.
     "Simulado: você tiraria X pontos de Y." Pergunta: Ingrid compartilha conquistas ou é discreta?

M-3: Push adaptativo por horário de pico — horario_inicio_sessao disponível.
     Se Ingrid estuda 20h-22h, Push vai às 19h50. Pergunta: Ingrid usa o app no horário fixo?

M-4: Raio-X de Armadilhas Quadrix — agrupar erros por tipo de pegadinha (prescinde/salvo/nunca).
     Treino cirúrgico por padrão de erro. Pergunta: Ingrid percebe os padrões de erro ou só vê "errei"?

M-5: Relatório semanal automatizado — RPC progresso_semanal · WhatsApp toda segunda.
     Pergunta: Ingrid responderia bem a uma mensagem automática ou prefere silêncio?

---

[G-1 a G-5] — IDEIAS DO ESTRATEGISTA (GEMINI · DIRETRIZ V6):

G-1: Simulador de Invalidação Parcial — Gatilho Quadrix
     A cada 2 erros, 1 acerto anterior é deletado do contador visual do dia. Força leitura milimétrica dos enunciados. Elimina ilusão de avanço rápido.
     Pergunta: Ingrid suportaria a frustração inicial ou abandonaria a sessão?

G-2: Badge Vacina de Anacronismo Legislativo
     Ícone de vacina/seringa nos enunciados de LC 840 e LODF com alterações recentes. Alerta visual para pegadinhas baseadas em leis revogadas.
     Pergunta: Ingrid percebe quando a questão cobra texto antigo ou confia na própria memória?

G-3: Bloqueio Temporário por Leitura Dinâmica Negligente
     Se TTL de resposta < 12 segundos em 3 itens consecutivos (Direito Admin / Constitucional), app congela 45 segundos exibindo o artigo violado. Força desaceleração compulsória.
     Pergunta: Ingrid estuda com cansaço físico no final do dia — isso seria frustrante ou útil?

G-4: Emissão do Brasão de Estabilidade Semanal
     String de certificado gerada toda noite de domingo na aba Raio-X: "Sua teia jurídica atingiu X% nesta semana. Zona de Classificação Atingida." Ativo compartilhável e combustível psicológico.
     Pergunta: Ingrid compartilha conquistas ou guarda para si?

G-5: Algoritmo de Distração Vingativa
     Ao errar por armadilha literal (prescinde/salvo/exclusivamente), o sistema injeta essa palavra-chave nas próximas 3 questões de matérias distintas. Neutraliza o gatilho semântico da banca.
     Pergunta: Ingrid identifica quando erra por pegadinha ou acha que não entendeu o conteúdo?

---

[N-1 a N-5] — IDEIAS DO AUDITOR (NOTEBOOKLM · ingrid-v5.md — output real 2026-05-26):

N-1: Gatilho Temporal Autônomo
     Query sobre horario_inicio_sessao das últimas 2 semanas → link WhatsApp ou notificação disparado 15 min antes do pico modal natural de Ingrid. Não às 09h fixo.
     Pergunta: Ingrid tem horário fixo de estudo dominical?

N-2: Reconciliação Contratual Criptográfica
     Clickwrap-Unclog: Contador Ponderado bloqueado até Ingrid confirmar termo com data correta (18/05). Clique grava hash SHA-256 no Supabase. Mata passivo jurídico sem atrito.
     Pergunta: Ingrid reagiria bem a um banner de "confirmar licença" antes de ver sua nota?

N-3: Linha de Corte Fantasma (P-041 aplicado)
     Linha pontilhada estática de "Nota de Corte Histórica Estimada" (72 pts) na interface. Ingrid vê sua barra vs a linha. Aversão à Perda converte número em caça à vaga.
     Pergunta: Ingrid é movida por metas visuais ou a comparação gera ansiedade?

N-4: Rótulo "Ilusão Estatística" do SM-2
     Tag visual [Simulado de Fixação] informa que nota tem viés de repetição (P-038). Previne complacência — nota sobe por memória fotográfica, não por domínio real.
     Pergunta: Ingrid percebe a diferença entre questões novas e recicladas?

N-5: Raio-X SVG Export via html2canvas
     Painel convertido em card motivacional pelo cliente JS puro (html2canvas) — sem token de back-end. Ingrid vê conquista, Vanguard colhe anonimizado para pitch SaaS 500 usuárias.
     Pergunta: Ingrid compartilha conquistas ou mantém para si?

---

PEDIDO AO EMBAIXADOR — QUATRO PARTES OBRIGATÓRIAS:

PARTE 1 — FILTRO DE REALIDADE
Para cada ideia [M], [G], [N], responder:
  CONFIRMA — Ingrid demonstrou comportamento/interesse compatível
  EXPANDE  — Ingrid tem contexto que potencializa além do proposto
  ALERTA   — comportamento real contradiz ou torna a ideia arriscada

Formato por ideia:
  [M/G/N]-[N]: [NOME DA IDEIA]
  Reação: [CONFIRMA / EXPANDE / ALERTA]
  Evidência: [o que Ingrid disse/fez — ou "sem evidência direta ainda, mas..."]
  Severidade (só ALERTA): [ALTO / CRÍTICO]

PARTE 2 — ANÁLISE INOVADORA E PENSAMENTOS CONTRIBUTIVOS
"Não tenho evidência direta, mas vejo este risco/oportunidade" é contribuição obrigatória.
Operar em amplitude total (P-035):
- Push iOS: qual é o impacto real se não funcionar no Safari? Ingrid usa iOS?
- Contador de Pontos: pode criar ansiedade em vez de motivação? Como calibrar a linguagem?
- Deadline 2026-05-30: o que Ingrid precisará ter consolidado para não sentir abandono no offboarding?
- Pipeline: há sinal de que Ingrid mencionou ou vai mencionar outras candidatas?

PARTE 3 — INTELIGÊNCIA DE MERCADO (dimensão expandida)
O que o comportamento da Ingrid diz sobre o nicho EdTech-Concurso — não apenas sobre ela:
- Padrão de engajamento: candidatas deste perfil estudam sozinhas ou em grupo? A ferramenta serve ao isolamento ou ao social?
- Padrão de pagamento: o que Ingrid pagou sem questionar vs. o que hesitaria a pagar em escala B2C?
- Padrão de churn: o silêncio da Ingrid quando insatisfeita é padrão de nicho ou individual?
- Validação de produto: o que a Ingrid usa todo dia é o core do produto ou uma feature secundária?
- Argumento de venda: qual experiência da Ingrid Eduardo usaria como prova social para a próxima candidata?

PARTE 4 — DECISOES.json (DEF-E-8: obrigatório ao fechar SEÇÃO D)

FLUXO OBRIGATÓRIO — ciclo Embaixador → Músculo → Diretor → Músculo:

  Embaixador fecha ativação
    ↓ gera DECISOES_INGRID_[YYYY-MM-DD].json com schema fixo
  Eduardo salva em CLIENTES/INGRID/CLAUDE_PROJECT/DECISOES/
    ↓ Músculo detecta e roda automaticamente:
  .\scripts\render_painel.ps1 -projeto INGRID
    ↓ Painel HTML abre no browser
  Diretor marca vereditos → clica "Confirmar" → baixa VEREDITOS_INGRID_[DATA].json
    ↓ Eduardo move arquivo para DECISOES/ — Músculo roda:
  .\scripts\executar_vereditos.ps1 -projeto INGRID
    ↓ Executa: clipboard, log_contato, inscrever_ledger, criar_nota, P-032
  Painel fecha — ciclo completo

O Embaixador NÃO gera HTML. Gera apenas JSON estruturado com este schema:
  - id: "D1", "D2", ... (sequencial)
  - secao: "acao_imediata" | "pendencias" | "inteligencia" (ou label livre)
  - urgencia: "prerequisito" | "alta" | "normal"
  - icon: emoji representativo
  - titulo + subtitulo + situacao (contexto em 1-2 frases)
  - tem_artefato: true/false
  - artefato_editavel: true/false (se true → Eduardo edita no painel)
  - artefato_label + artefato_texto (mensagem pré-redigida, se aplicável)
  - opcoes: lista de { valor, label, subtitulo, acoes[] }
    Ações mapeadas: "log_apenas" | "copiar_clipboard" | "log_contato" |
                    "inscrever_ledger" | "criar_nota_regerar_pdf"

DECISÕES OBRIGATÓRIAS NESTE LOOP (Ingrid Loop 5):
  ► D1: LEGAL-WATCH — PDF data 30/05 vs. assinatura 18/05
  ► D2: CHURN-WATCH — reengajamento pós-silêncio + pós-fix Q18
  ► D3: PUSH-WATCH — iOS Safari · buildar ou fallback WhatsApp?
  ► D4: PITCH-WATCH — Ingrid verbalizou progresso? Abrir V2?
  ► D5: Princípio candidato ao LEDGER — aprovar ou descartar
  ► D6: Princípio D3 Vanguard — encaminhar ao Conselheiro?

Regra: Músculo NÃO executa sem VEREDITOS.json confirmado pelo Diretor.
Músculo NÃO aceita HTML como output da SEÇÃO D — apenas JSON estruturado.
Exemplo de arquivo real: CLIENTES/INGRID/CLAUDE_PROJECT/DECISOES/DECISOES_INGRID_2026-05-24.json
```

---

## FORMATO OBRIGATÓRIO — 7 BLOCOS DA RESPOSTA DO EMBAIXADOR

```
BLOCO 1 — TEMPERATURA_PONDERADA DE INGRID
  Temperatura atual: [FRIA / MORNA / QUENTE / ENTUSIASMADA]
  Tendência (últimos 7 dias): [subindo / estável / caindo]
  Contexto de pagamento: [pago / pendente / risco]
  Score 0-10: [N]  ← Score < 6 = CHURN-WATCH automático
  Razão: [1-2 linhas com evidência concreta]

BLOCO 2 — HIPÓTESES ATIVAS
  Para cada hipótese pendente: CONFIRMADA / REFUTADA / PENDENTE + evidência de 1 linha
  Prioridade: uso dominical (crítico para Push) + horário de pico (crítico para Push adaptativo)

BLOCO 3 — COMPORTAMENTO DO CLIENTE (3 pontos obrigatórios)
  O que Ingrid fez que era esperado:
  O que Ingrid fez que foi surpresa:
  O que Ingrid NÃO fez que deveria ter feito:

BLOCO 4 — WATCHDOG
  [SCOPE-WATCH] abertos:
  [CHURN-WATCH] ativos:
  Próximo debrief recomendado:

BLOCO 5 — [E-1 a E-5] IDEIAS EXCLUSIVAS DO EMBAIXADOR
  Perspectiva exclusiva — não síntese das ideias dos outros membros.
  Para cada ideia:
    [E-N] [NOME]
    Descrição: [o que é]
    Por que vale agora: [razão fundamentada]

BLOCO 6 — INTELIGÊNCIA DE MERCADO (EdTech-Concurso)
  O que o comportamento real da Ingrid revela sobre o nicho — não sobre ela individualmente:
  Padrão confirmado no nicho: [comportamento que provavelmente se repete em outras candidatas]
  Padrão específico da Ingrid: [o que é dela, não do nicho]
  Argumento de venda derivado: [o que Eduardo usa como prova social para a próxima candidata]
  Risco de nicho: [o que pode matar o produto na escala de 500 usuárias]

BLOCO 7 — PRÓXIMA AÇÃO RECOMENDADA
  [AÇÃO ESPECÍFICA] — [QUEM EXECUTA] — [PRAZO]
  Razão: [por que esta ação agora e não outra]

DECISOES.json — gerado automaticamente ao fechar SEÇÃO D
  Arquivo: DECISOES_INGRID_[YYYY-MM-DD].json
  Instruir Diretor: "Salve em CLIENTES/INGRID/CLAUDE_PROJECT/DECISOES/ e rode render_painel.ps1"
  Decisões desta ativação: [listar títulos — mínimo os obrigatórios do loop]
  Músculo executa ZERO ações antes de receber VEREDITOS.json confirmado pelo Diretor
```

---

## VALIDAÇÃO ANTES DE FECHAR A SESSÃO

| Item | Critério |
|---|---|
| TEMPERATURA_PONDERADA com score 0-10? | Obrigatório — temperatura simples é DEF-E-7 |
| BLOCO 3 tem 3 pontos concretos? | Obrigatório — sem dados concretos = calibrar |
| [E-1 a E-5] incluem análise inovadora? | Sim — Embaixador não é só espelho do cliente |
| Todas as ideias do Pentalateral receberam reação? | Com evidência real ou análise própria |
| INTELIGENCIA_CRUZADA_NICHO aplicada? | Se houver 2+ clientes EdTech |
| MEMORIA_EMBAIXADOR marcada para atualização? | Músculo executa P-032 após sessão |
| DECISOES.json gerado e salvo em DECISOES/? | Obrigatório ao fechar SEÇÃO D — ausência = DEF-E-8 |

---

## PRÓXIMAS ATIVAÇÕES PROGRAMADAS

| Momento | Seção | Urgência |
|---|---|---|
| Antes de ir ao Gemini Loop 5 | SEÇÃO D (reação) — [M-1 a M-5] já preenchidos | ALTA |
| Após receber DIRETRIZ V6 + Skill ingrid-v5 | SEÇÃO D (completar [G]+[N]) | ALTA |
| Próximo check-in com Ingrid | SEÇÃO B (debrief) | NORMAL |
| Se Ingrid não usar app 3+ dias | SEÇÃO B (debrief) | [CHURN-WATCH] |
| Se Ingrid mencionar alguém | SEÇÃO C (pipeline) | IMEDIATA |
| Gate Dias 12-13 | SEÇÃO A (briefing) + SEÇÃO B (debrief) | ALTA |

---

*PASSO7 · Projeto Ingrid · Loop 5 · Atualizado em 2026-05-23*
*[M-1 a M-5] do Loop 4 pré-preenchidos · [G] e [N] a preencher após DIRETRIZ V5 + ingrid-v5.md*
*Template universal: PENTALATERAL_UNIVERSAL/OPERACAO/PASSO7_EMBAIXADOR_TEMPLATE.md*

---

## SEÇÃO E — FECHAMENTO + PAINEL PUBLICÁVEL (colar no Embaixador após session_close)

```
Embaixador, fechamento de sessão — INGRID · 29-05-2026.

ENTREGAS DO DIA:
- P-069 operacionalizado: formato "Dia X (DD-MM-YYYY dia-da-semana)" em TODOS os documentos
- P-013 Opção B autorizada: Ingrid cria próprio Supabase — OFFBOARDING_RUNBOOK + SQL de migração criados
- v17 deploy confirmado: GitHub Pages funcional, nota simulada 7.6/100, último acesso correto
- D4:A fechado: Ingrid não conhece ninguém prestando concurso (pipeline de referral = zero)
- H-5 (compartilhamento de login) revisada para IMPROVÁVEL

ALERTAS ATIVOS:
🔴 P-013 bloqueante: deadline 30-05-2026 sábado — aguarda Ingrid enviar URL + anon key do Supabase
🟡 MEMORIA_V5_INGRID ausente: loop 5 não fechou — gate dia15 ainda aberto
🟡 LEGAL-WATCH: Termo de Uso data 30/05 vs assinatura 18/05 — endereçar no Dia 14

PRÓXIMO GATE:
Gate Dia 15 (30-05-2026 sábado) — P-013 Soberania
Sequência de desbloqueio:
  1. Ingrid envia URL + anon key do Supabase dela
  2. Eduardo roda migrate_ingrid_supabase_v1.sql no SQL Editor dela
  3. Eduardo exporta questões CSV do Vanguard → importa no projeto da Ingrid
  4. Eduardo deploya Edge Functions via Supabase CLI
  5. Músculo atualiza app.js linhas 16-17 → v18 → Eduardo testa → gate APROVADO
  Ao fechar: MEMORIA_V5_INGRID + relatorio_evolutivo_V5_INGRID + Wipe & Sync NotebookLM

PREVISÃO DOS PRÓXIMOS DIAS:
30-05-2026 sábado   — DEADLINE: Ingrid envia credenciais Supabase → executar sequência P-013
                      Se sim: build v18 + deploy + gate dia15 APROVADO + fechar Loop 5
                      Se não: Eduardo cria projeto e convida Ingrid como admin depois
02-06-2026 terça    — Gerar Sentinel Report Valdece (template PASSO7_EMBAIXADOR Valdece)
03-06-2026 em diante — Loop 6 Ingrid: PASSO3_GEMINI + nova DIRETRIZ V7

PEDIDO AO EMBAIXADOR:
Gerar o PAINEL DE ATIVIDADES como artefato publicável com:
1. Semáforo visual de pendências (🔴 bloqueante / 🟡 atenção / 🟢 saudável)
2. Seção DIAGNÓSTICO DO DIA — saúde de PROJ-002 Ingrid e PROJ-001 Valdece
3. Seção PREVISÃO — data a data com checklist de ações do Diretor (30/05, 02/06, 03/06+)
4. Seção PRÓXIMA AÇÃO DO DIRETOR — P-013 hoje + Sentinel Report 02/06

O artefato deve ser autossuficiente: o Diretor abre o PAINEL e sabe exatamente
o que fazer, sem precisar ler esta conversa.
```

---

## NOTAS PÓS-SESSÃO — 29-05-2026

**[D4:A — RESULTADO CONFIRMADO]**
Eduardo plantou a pergunta: "Você conhece mais alguém prestando concurso esse ano?"
Resposta da Ingrid: não conhece ninguém prestando concurso.
Pipeline de referral = zero no curto prazo. Candidata estuda em isolamento.
Hipótese H-5 (compartilhamento de login) revisada para IMPROVÁVEL — Ingrid usa sozinha.
Próximo gatilho de pipeline: pós-aprovação (rede de servidores empossados).

**[P-013 — GATE EM ANDAMENTO]**
Diretor autorizou Opção B: Ingrid cria próprio projeto Supabase (soberania do cliente).
Eduardo já contatou Ingrid. Aguarda ela enviar URL + anon key do projeto criado.
Deadline: 30-05-2026 sábado.
Sequência quando Ingrid enviar credenciais:
  1. Eduardo roda `migrate_ingrid_supabase_v1.sql` no SQL Editor dela
  2. Eduardo exporta questões (CSV) do Supabase Vanguard → importa no projeto dela
  3. Eduardo deploya Edge Functions via Supabase CLI
  4. Músculo atualiza app.js com novas credenciais → v18 → Eduardo testa → gate APROVADO

**[WATCHDOG ATUALIZADO — 29-05-2026]**
- [PIPELINE] D4:A FECHADO — Ingrid não tem referral. Remover da lista de pendências ativas.
- [SCOPE-WATCH] compartilhamento de login: IMPROVÁVEL (revisado após intel D4:A)
- [LEGAL-WATCH] Termo de Uso data 30/05 vs assinatura 18/05: endereçar em Dia 14 (28-05-2026 quinta-feira)
- [CHURN-WATCH] ativo se sem uso >3 dias a partir de 2026-05-23

**[TEMPERATURA ESTIMADA — 29-05-2026]**
Ingrid respondeu ao contato sobre Supabase: comportamento cooperativo, sem resistência.
Score estimado: 7/10. Tendência: estável. Contexto de pagamento: pago.
