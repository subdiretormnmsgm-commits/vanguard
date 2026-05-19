# ANÁLISE DO EMBAIXADOR — PROJ-001 VALDECE
**Para:** Músculo (Claude Code)  
**De:** Embaixador (Claude Projects — PROJ-001)  
**Data:** 2026-05-19  
**Versão:** V2 — análise pós-gate fundacional  
**Fontes:** LEDGER P-001→P-035 · WIP_BOARD · DIRETRIZ V3 · MEMORIA V24 · RELATORIO V24 · TEMPLATE RELATORIO V2 · CALIBRACAO_QUADRILATERAL · COMANDO_AUDITOR_V1  
**Classificação:** Inteligência acumulada de case fundacional — alimentar loop evolutivo imediatamente

---

## PARTE 1 — O QUE ESTE PROJETO PROVOU

O PROJ-001 Valdece não é o primeiro cliente. É o **primeiro teste real do Pentalateral IAH sob condições de produção**: prazo de 5 dias, cliente não-técnico, nicho especializado, entrega presencial, credenciais reais, demo com resultado binário — contrato ou não.

O organismo saiu mais inteligente. Mas não por acaso — por fricção documentada.

### O que funcionou

**O gate substituiu a fé.** Em V1–V24, a Vanguard construiu sistemas sem cliente. No Valdece, o gate P-038 tornou a demo previsível: 12 queries testadas, 12 verdes, latência mapeada, corpus validado antes de sentar com o cliente. Isso eliminou o maior risco de uma demo: o sistema falhar na primeira impressão.

**A soberania virou argumento comercial.** O OFFBOARDING_RUNBOOK.md (P-013) foi entregue não como documento técnico, mas como prova de confiança. O cliente que vê "como me demitir em 30 minutos" não cancela — porque não se sente preso.

**O corpus_gap virou fechador de negócios.** A DIRETRIZ V3 do Gemini identificou antes do build: o log de buscas com similaridade < 0.50 não é métrica técnica — é a prova matemática dos temas não cobertos. Em 30 dias, esses temas justificam a V2. O Músculo construiu uma feature; o Gemini transformou em argumento comercial.

**P-008 se confirmou na prática.** O primeiro cliente de nicho não é fonte de MRR — é canal de distribuição. Valdece na OAB-DF tem acesso a 50 colegas criminalistas. A demo bem-sucedida com ele vale mais que qualquer campanha de aquisição.

### O que revelou risco

O gate de teste (P-038) não estava no processo original. Emergiu durante o build porque o Músculo percebeu que "funciona na Vanguard" ≠ "funciona na conta do Valdece". Isso deve virar princípio formal — não prática ad hoc.

O distanciamento entre build e expectativa do cliente — detalhado na Parte 2 — foi o risco mais silencioso do projeto.

---

## PARTE 2 — O DISTANCIAMENTO DETECTADO E SUA CAUSA RAIZ

O Diretor identificou durante o projeto que em determinados momentos o que estava sendo construído se distanciou do que o cliente havia pedido.

Este é o risco mais silencioso de qualquer build rápido. O Músculo entra em momentum de execução e o momentum, sem verificação, gera drift — P-010 existe exatamente para isso, mas não cobre a dimensão de expectativa do cliente.

### A causa raiz não foi técnica

O discovery capturou o problema declarado pelo cliente. Não capturou o resultado imaginado.

Valdece disse: *"Busca de jurisprudência no STF e STJ exige muito tempo, às vezes horas."*

O que ele imaginou: estar em audiência, júri começa em 20 minutos, digitar uma frase e encontrar o precedente certo antes do juiz. Resultado = vantagem em julgamento.

O que o build priorizou por alguns ciclos: corpus, threshold, embedding, arquitetura — correto tecnicamente, invisível para o cliente.

A divergência foi corrigida. Mas o mecanismo que a gerou — ausência de uma pergunta específica no discovery — precisa ser endereçado estruturalmente.

A DIRETRIZ V3 do Gemini tocou nisto indiretamente ao identificar que o corpus_gap é "o maior vendedor disfarçado de código" — o Gemini viu o valor comercial do que o Músculo tratou como métrica técnica. Isso é exatamente o padrão: o build otimiza para o sistema, o cliente otimiza para a cena.

---

## PARTE 3 — DOIS PRINCÍPIOS NOVOS PARA O LEDGER

### [P-041] Discovery deve capturar a cena de sucesso, não apenas o problema declarado

**Descoberto:** 2026-05-19 | **Sessão:** PROJ-001 Valdece — análise pós-gate  
**Evidência:** Valdece declarou "busca de jurisprudência consome horas". O build otimizou para corpus e threshold — correto tecnicamente. Mas o cliente imagina uma cena específica: "júri em 20 minutos, encontro o precedente antes do juiz." Sem capturar essa cena no discovery, o build pode ser tecnicamente impecável e emocionalmente irrelevante para o cliente.  
**Princípio:** No Passo 2 (Discovery), incluir obrigatoriamente: *"Me descreve uma situação real — uma cena específica — onde este sistema te salvaria. O que acontece, onde você está, qual é o resultado que muda."* A resposta é o critério de aceitação real do projeto.  
**Corolário de build:** O Músculo usa a cena descrita como teste de aceitação final.  
**Corolário de demo:** A abertura da demo reproduz a cena do cliente, não demonstra features.  
**Aplica-se a:** todo projeto cliente, todo nicho, toda camada.

---

### [P-042] Gate de validação semântica é ativo de nicho, não burocracia de entrega

**Descoberto:** 2026-05-19 | **Sessão:** PROJ-001 Valdece — gate P-038  
**Evidência:** O gate P-038 emergiu como proteção de demo mas gerou protocolo replicável. O segundo advogado criminalista custa 30 minutos de gate — não horas de fricção.  
**Princípio:** O gate de validação semântica deve ser documentado como artefato formal. Estrutura mínima: área coberta + query testada + melhor similaridade + latência + status verde/amarelo/vermelho.  
**Corolário de escala:** Em 5 clientes LegalTech-Criminal, a Vanguard tem benchmark que nenhum concorrente possui.  
**Corolário comercial:** "Testamos 12 queries antes de sentar com você" é diferencial de processo.  
**Aplica-se a:** todo sistema de busca semântica por nicho profissional.

---

## PARTE 4 — DISCOVERY V2 — 8 PERGUNTAS COM COBERTURA SUBSTANCIAL

### BLOCO A — O PROBLEMA

**P1 — A dor com custo mensurável**
> *"Qual dor do seu trabalho este sistema vai resolver? Quanto tempo ou dinheiro ela custa hoje?"*

**P2 — A cena de sucesso** ← *nova, obrigatória*
> *"Me descreve uma situação real — uma cena específica — onde este sistema te salvaria. O que acontece, onde você está, o que você está fazendo, qual é o resultado que muda."*

Exemplo Valdece: *"Júri começa em 20 minutos. Preciso do precedente STJ sobre tráfico privilegiado antes do juiz citar o dele. Hoje levo 40 minutos no Google e às vezes não acho."*

**P3 — Quem usa e como**
> *"Quem vai usar no dia a dia? Descreve essa pessoa — nível técnico, rotina, onde acessa."*

**P4 — O que existe hoje e por que não resolve**
> *"Como você resolve isso hoje? Quais ferramentas usa? O que funciona e o que falha nelas?"*

**P5 — O que não pode quebrar**
> *"Se este sistema falhar no momento mais crítico, o que acontece?"*

**P6 — Escopo e limites** ← *expandida*
> *"O que este sistema definitivamente precisa fazer? E o que definitivamente não precisa — pelo menos por agora?"*

**P7 — Investimento e urgência**
> *"Quanto você investiria para resolver isso? E em quanto tempo você precisa?"*

**P8 — Expansão futura** ← *nova, obrigatória*
> *"Se isso funcionar bem nos primeiros 30 dias, qual seria o próximo passo natural? Tem outras pessoas com a mesma dor que você conhece?"*

---

## PARTE 5 — SKILL PROJETO VALDECE V1 — VERSÃO EMBAIXADOR

```
════════════════════════════════════════════════════════════
SKILL — JURISPRUDÊNCIA SEMÂNTICA VALDECE — V1
Complemento do Embaixador ao Auditor
════════════════════════════════════════════════════════════

CONTEXTO
Cliente: Valdece | Advogado criminalista autônomo | OAB-DF
Camada: 1 (MVP soberano) | Stack: Supabase + Gemini + Vanilla JS
Problema: Busca manual STF/STJ consome horas em audiências
Objetivo V1: Motor semântico na conta do cliente, gate aprovado, demo encantadora

[CONEXÃO HISTÓRICA — Para o Músculo]
burn_rate_shield.js · kill_switch.js · gate_stj.py · seed_demo.py · search_cli.py
Todos em CLIENTES/VALDECE/backend/ — reutilizar diretamente nos próximos projetos de nicho

[PADRÃO DE SUCESSO]
Gate antes de demo → elimina risco de falha na primeira impressão
Corpus testado com queries do nicho real → resultado confiável
Sovereign Playbook no handoff → elimina objeção de dependência
Soberania total → P-008: cliente vira canal de distribuição

[PADRÃO DE FALHA]
STJ sem teste em produção → Circuit Breaker obrigatório
Cron Job sem try/catch → custo incontrolável na conta do cliente
Features V2 prometidas antes do contrato → scope creep
Explicar features antes de mostrar o resultado → impacto reduzido

[PERSPECTIVA DO EMBAIXADOR]
· A demo não termina quando o sistema funciona.
  Termina quando Valdece digita a própria query sem ajuda e encontra o resultado.
  O momento de virada é H-2: ele digitando, não Eduardo demonstrando.

· Corpus_gap não documentado = argumento de V2 perdido.
  Valdece não sabe que o corpus_gap existe.
  "Os 12 temas que o sistema não cobriu ainda" é o argumento mais forte para V2.

· Roteiro da demo:
  Abertura: "Você me disse que precisava do precedente antes do juiz. Vamos fazer isso."
  Busca 1 e 2: Eduardo conduz — silêncio total
  Busca 3: mostrar citação ABNT + modo preciso/amplo
  Busca 4: Valdece digita sozinho — Eduardo não toca no teclado
  Sovereign Playbook: "Se eu sumir, você opera em 3 passos."
  Contrato: "O sistema é seu. Isso aqui só formaliza."

QUERIES TESTADAS E APROVADAS PARA A DEMO
  Tema 1 → "homicídio qualificado tribunal do júri excesso de linguagem pronúncia" → sim=0.818
  Tema 2 → "roubo com arma de fogo dosimetria pena aumento proporcional" → sim=0.792
  Tema 3 → "corrupção peculato lavagem de dinheiro servidor público administração" → sim=0.780
  Coringa → "habeas corpus constrangimento ilegal prisão preventiva" → sim=0.804

ALERTAS CRÍTICOS
· Demo sem busca autônoma do Valdece (H-2) = janela perdida [ALTO]
· Corpus_gap não documentado na demo = argumento V2 perdido [ALTO]

[PARA O SKILL_PROTOCOLO_VANGUARD]
· Gate semântico como artefato formal de entrega (P-042)
· Discovery P2 cena de sucesso como critério de aceitação (P-041)
· Corpus_gap como fechador comercial de V2
· Sovereign Playbook como argumento de proposta antes do contrato
· Demo estruturada em torno da cena do cliente — não das features
════════════════════════════════════════════════════════════
```

---

## PARTE 6 — RELATORIO_EVOLUTIVO V2 — SEÇÕES DO EMBAIXADOR

### CHECK — Validações do Embaixador

| Validação | Status |
|---|---|
| Cena de sucesso testada na demo | A confirmar 2026-05-20 |
| Valdece digitou a 4ª busca sozinho | A confirmar 2026-05-20 |
| Sovereign Playbook apresentado antes do contrato | A confirmar 2026-05-20 |
| Corpus_gap documentado para argumento V2 | ✅ Registrado no gate P-038 |
| Deploy Netlify enviado ao Valdece | ✅ 2026-05-19 |

### ACT — 5 Ideias do Embaixador [E-1 a E-5]

**[E-1] Gate como entregável formal do contrato**
Incluir "Gate de Validação Semântica documentado" como item de escopo em todo contrato de sistema de busca IA. O cliente recebe: sistema + gate + resultado do gate.

**[E-2] Cena de sucesso como abertura obrigatória de qualquer demo**
O PROCESSO_EVOLUTIVO inclui no Passo 8 (execução) sub-passo obrigatório: "Abrir a demo reproduzindo verbalmente a cena descrita pelo cliente na P2 do discovery."

**[E-3] Corpus_gap como SLA informal do Sentinel Report**
Sentinel Report inclui obrigatoriamente: "Temas descobertos / Temas pendentes" como argumento comercial de V2 — não apenas métrica técnica.

**[E-4] Sovereign Playbook como argumento de proposta, não de handoff**
Apresentar o Playbook durante a negociação, antes do contrato: "Você pode me demitir em 30 minutos — está escrito aqui." Elimina objeção de dependência antes que ela seja feita.

**[E-5] Discovery P8 como mapa de nicho**
Lead mencionado por cliente → entra no WIP_BOARD como "lead qualificado — origem: indicação [cliente]" com campo `cena_provavel` preenchido baseado no perfil do indicador.

---

## PARTE 7 — AÇÕES PARA O MÚSCULO

**Ação 1:** Registrar P-041 e P-042 no LEDGER ✅ (executado nesta sessão)  
**Ação 2:** Atualizar PROCESSO_EVOLUTIVO — Passo 2 com as 8 perguntas (P2 e P8 marcadas obrigatórias)  
**Ação 3:** Atualizar perfil LegalTech-Criminal no WIP_BOARD para 75% ✅ (executado nesta sessão)

---

## PARTE 8 — ESTADO DO RELACIONAMENTO E CALENDÁRIO

| Marco | Data | Status |
|---|---|---|
| Gate P-038 | 2026-05-19 | ✅ 12/12 verde |
| Deploy Netlify | 2026-05-19 | ✅ toga-digital-valdece.netlify.app |
| Demo presencial | 2026-05-20 | Pendente |
| Contrato | 2026-05-20 | Pendente — aguarda demo |
| Sentinel Report #1 | 2026-06-02 | Programar pós-contrato |
| Pitch V2 | 2026-06-19 | Gatilho: 30 dias ou corpus ≥ 500 |
| Lead OAB | A definir | Monitorar na demo |

---

## DECISÃO DO EMBAIXADOR

```
🟢 PROJ-001 VALDECE — CASE FUNDACIONAL DOCUMENTADO
Gate: 12/12 verde
Deploy: https://toga-digital-valdece.netlify.app (ativo 2026-05-19)
Inteligência: P-041 + P-042 extraídos · Discovery V2 com 8 perguntas
[E-1 a E-5]: prontas para COMANDO_ESTRATEGISTA
```

---
*Versão 2 — gerada em 2026-05-19 | Músculo (arquivo) + Embaixador (conteúdo)*
