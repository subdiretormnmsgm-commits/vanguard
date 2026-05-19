# PASSO 7 — EMBAIXADOR (CLAUDE PROJECTS) · PROJETO VALDECE · LOOP 4
> Instância do PASSO7_EMBAIXADOR_TEMPLATE.md · Criado em 2026-05-19
> Eduardo não edita este arquivo — é o guia de ativação do Embaixador para este projeto.
> Músculo atualiza as ideias dos sócios (SEÇÃO D) ao fechar cada loop.

---

## 📌 INSTRUÇÕES PARA O DIRETOR — COMO ACIONAR O EMBAIXADOR

```
1. RODAR no terminal:
   .\scripts\ir_ao_embaixador.ps1 -cliente VALDECE
   → Script copia MENSAGEM_INTERACAO_INICIAL para clipboard
   → Abre browser em claude.ai/projects
   → Abre Explorer na pasta CLIENTES\VALDECE\CLAUDE_PROJECT\

2. NO CLAUDE PROJECTS:
   Fazer upload de MEMORIA_EMBAIXADOR.md (sempre — é a memória viva do cliente)
   Marcar a SEÇÃO correspondente ao tipo de ativação
   Colar o bloco da SEÇÃO no chat

3. AGUARDAR resposta do Embaixador.
   Músculo atualiza MEMORIA_EMBAIXADOR.md automaticamente via P-032.
```

> O Embaixador é o único membro com memória persistente do Valdece entre sessões.
> Sem ele, cada gate começa do zero. Com ele, cada sessão começa onde a anterior terminou.

---

## 🛡️ PROTOCOLO ANTI-DEFICIÊNCIAS DO EMBAIXADOR

**Deficiência 1 — Viés de Afinidade**
Valdece é profissional e pragmático. O Embaixador pode suavizar alertas sobre resistência a contratos.
Contra-ataque: ao emitir ALERTA, exigir evidência concreta da MEMORIA_EMBAIXADOR — não intuição.

**Deficiência 2 — Excesso de Otimismo de Engajamento**
Pode interpretar entusiasmo verbal como disposição de assinar. São coisas diferentes.
Contra-ataque: sem contrato assinado = sem encantamento real, independente do tom da conversa.
Prazo ativo: demo pendente → qualquer dia sem contato é janela de encantamento se perdendo.

**Deficiência 3 — Omissão de Flags Desconfortáveis**
Pode focar no entusiasmo do Valdece com o produto e omitir sinais de hesitação no contrato.
Contra-ataque: Músculo pergunta diretamente: "Qual é o sinal mais preocupante sobre o Valdece agora?"

**Deficiência 4 — Limitação a Evidências**
O Embaixador pode responder apenas com o que Valdece disse/fez, ignorando análise inovadora.
Contra-ataque: Eduardo quer TANTO evidências quanto pensamentos inovadores.
"Não tenho evidência direta, mas vejo este risco/oportunidade" é contribuição obrigatória.

---

## 📋 CABEÇALHO DA ATIVAÇÃO

```
ATIVAÇÃO DO EMBAIXADOR — VALDECE
Data: [YYYY-MM-DD]
Loop atual: 4 | Fase: [PRÉ-DEMO / DEBRIEF-PÓS-DEMO / PIPELINE / REAÇÃO AO PENTALATERAL]
Última ativação: [DATA]

--- ELO DO CICLO ATUAL (obrigatório no cabeçalho) ---
DIRETRIZ em processo: DIRETRIZ_GEMINI_V4.txt
Skill gerada pelo Auditor: valdece-v4.md
Skill executada pelo Músculo: /valdece-v4 (antes de qualquer build)
Gate atual: Demo ao vivo → Valdece diz "é isso" em <10s no sistema DELE → contrato assinado
```

---

## 📋 CONTEXTO ATUALIZADO DO PROJETO — Loop 4

**Cliente:** Valdece — Advogado criminalista
**Projeto:** Toga Digital — busca semântica de jurisprudências STF/STJ
**Camada:** 1 — MVP (5 dias de build concluídos)
**Loop atual:** 4 (pós-presencial 2026-05-19 · demo ao vivo pendente)
**Temperatura atual:** QUENTE (sistema funciona + credenciais obtidas + presencial realizado)
**App:** https://toga-digital-valdece.netlify.app — LIVE
**Corpus:** 61 acórdãos · 22 temas · threshold 0.67 · top 3 · similaridade 0.67-0.818 · VERDE
**Gate aprovado:** GATE P-038 (12/12 verde · latência 2.1-3.4s)
**Gate pendente:** Demo real — Valdece diz "é isso" em <10s → contrato R$5.000 fechado

**Cena de sucesso (P-041 — âncora do Embaixador):**
"Estou num julgamento, o promotor cita um precedente que eu não conheço. Abro o Toga Digital,
digito o nome do crime, e em 10 segundos tenho o acórdão com mais peso — citação pronta em ABNT."

**Estado atual (2026-05-19):**
- Credenciais do Valdece: obtidas no presencial — Eduardo as tem
- Sovereign Playbook apresentado — objeção vendor lock-in destruída
- Demo real: PRÓXIMA — Valdece ainda não testou o sistema. Janela de encantamento intacta.
- Contrato: PENDENTE — aguarda demo + encantamento

**Watchdog ativo:**
- [CHURN-WATCH] janela de encantamento: cada dia sem demo = encantamento esfriando
- [SCOPE-WATCH] P-023: contrato formal é pré-requisito — nenhuma feature nova antes de assinar
- [PIPELINE] Valdece pode mencionar colegas — momento de plantio de lead no pós-demo

---

## MISSÃO DESTA ATIVAÇÃO — MARCAR APENAS UMA

- [ ] SEÇÃO A — BRIEFING PRÉ-DEMO (antes da demo ao vivo com Valdece)
- [ ] SEÇÃO B — DEBRIEF PÓS-DEMO (após qualquer contato real com Valdece)
- [ ] SEÇÃO C — PIPELINE DE LEAD (Valdece mencionou colega)
- [ ] SEÇÃO D — REAÇÃO AO PENTALATERAL (Músculo + Gemini + NotebookLM geraram ideias)

---

## SEÇÃO A — BRIEFING PRÉ-DEMO

> Usar antes da demo ao vivo com Valdece.
> Prazo: pelo menos 2 horas antes da reunião.

```
Embaixador, briefing pré-demo para VALDECE.

O QUE SABEMOS SOBRE ESTE CLIENTE (MEMORIA_EMBAIXADOR):
- Advogado criminalista pragmático — quer solução que funcione no julgamento real
- Validou o Sovereign Playbook — objeção de vendor lock-in superada
- Credenciais obtidas no presencial — comprometimento alto
- Primeira busca ao vivo no sistema DELE é o momento mais crítico do projeto
- Tom que funciona: demonstrar resultado real, não explicar tecnologia

O QUE ESTA DEMO PRECISA ENTREGAR:
- Valdece abre o app no sistema DELE, faz uma busca em tema que ELE escolhe
- Em <10s encontra resultado com sim score real
- Eduardo silencia e deixa Valdece reagir — não explica, deixa o encantamento acontecer
- Ao final: "O sistema é seu. Isso aqui só formaliza." → contrato

O QUE QUEREMOS DESCOBRIR:
- Quais temas Valdece vai pedir (crimes contra a vida, patrimônio ou administração pública?)
- Reação ao ABNT automático — isso importa para ele?
- Se Busca Precisa vs. Ampla vai ser notada espontaneamente
- Se menciona colega (pipeline de lead)

ALERTAS DO WATCHDOG PARA ESTA DEMO:
- [SCOPE-WATCH] se Valdece pedir feature nova durante a demo → "ótima ideia, entra na V2"
- [CHURN-WATCH] se busca demorar >10s → plano de contingência pronto

PEDIDO AO EMBAIXADOR:
1. Quais pontos desta demo Eduardo deve abordar com cuidado?
2. Qual é a pergunta ou reação do Valdece que vai revelar se o encantamento aconteceu?
3. O que Eduardo NÃO deve mencionar durante a demo?
4. Se tudo correr bem, qual o próximo passo natural a propor (linha de fechamento)?
```

---

## SEÇÃO B — DEBRIEF PÓS-DEMO (Passo 8.5)

> Usar após qualquer interação com Valdece — demo, ligação, troca relevante.
> Prazo máximo: 24 horas após o contato.

```
Embaixador, debrief pós-demo com VALDECE.

O QUE ACONTECEU (Eduardo relata informalmente):
[DESCREVER: como foi a demo, quais temas Valdece buscou, como reagiu ao resultado,
 pedidos que fez, perguntas que fez, como terminou a reunião, o contrato foi assinado?]

PEDIDO AO EMBAIXADOR:
Com base neste relato e no histórico do Valdece na MEMORIA_EMBAIXADOR:

1. Quais hipóteses sobre este cliente foram CONFIRMADAS?
2. Quais hipóteses foram REFUTADAS (Valdece agiu diferente do esperado)?
3. Há sinais de [SCOPE-WATCH] a registrar? (pedidos de feature, expansão de escopo)
4. Há sinais de [CHURN-WATCH] a monitorar?
5. Valdece mencionou alguém? (acionar SEÇÃO C se sim)
6. Temperatura atual: FRIA / MORNA / QUENTE / ENTUSIASMADA?
7. Qual o próximo passo que maximiza avanço do projeto e do relacionamento?

ATUALIZAR MEMORIA_EMBAIXADOR com:
- Data da demo e resumo de 3 linhas
- Hipóteses confirmadas/refutadas
- Alertas ativos (SCOPE-WATCH, CHURN-WATCH)
- Status do contrato
- Próxima ação recomendada
```

---

## SEÇÃO C — PIPELINE DE LEAD

> Usar quando Valdece mencionar colega, parceiro ou concorrente que possa ser lead.

```
Embaixador, pipeline de lead detectado a partir de VALDECE.

O QUE VALDECE DISSE:
[DESCREVER: o que exatamente foi mencionado, contexto, como surgiu na conversa]

O QUE SABEMOS SOBRE O LEAD:
[DESCREVER: nome se conhecido, nicho, escritório, contexto inferido]

PEDIDO AO EMBAIXADOR:
1. Perfil mais provável deste lead (área do direito, tamanho do escritório, dor principal)?
2. Qual a dor mais provável inferida pelo nicho/contexto do Valdece?
3. Qual pergunta casual Eduardo planta no Valdece para saber mais?
4. Em qual momento natural da próxima conversa com Valdece essa pergunta cabe?
5. Se qualificado, qual seria o "Choque de Valor Imediato" mais impactante para este perfil?
```

---

## SEÇÃO D — REAÇÃO AO PENTALATERAL (P-031)

> Usar quando Músculo + Gemini + NotebookLM geraram ideias e precisam do filtro de realidade.
> Músculo preenche as ideias dos sócios antes de enviar ao Embaixador.

```
Embaixador, reação ao ciclo atual do Pentalateral — VALDECE.
Loop 4 · pós-presencial 2026-05-19 · demo pendente · contrato pendente

CONTEXTO DO CICLO (elo obrigatório — não omitir):
- DIRETRIZ em execução: DIRETRIZ_GEMINI_V4.txt
- Skill que o Músculo vai executar: /valdece-v4
- O que a Skill define como prioridade: converter a demo em contrato — não build novo
- O que a Skill proíbe de construir: qualquer feature nova antes do contrato assinado

[M-1 a M-5] — IDEIAS DO MÚSCULO:
[Eduardo: colar as 5 ideias do relatorio_evolutivo mais recente aqui]

[G-1 a G-5] — IDEIAS DO ESTRATEGISTA (GEMINI):
[Eduardo: colar as 5 ideias da DIRETRIZ V4 do Gemini aqui]

[N-1 a N-5] — IDEIAS DO AUDITOR (NOTEBOOKLM · valdece-v4.md):
[Eduardo: colar as 5 ideias da Skill valdece-v4 aqui]

PEDIDO AO EMBAIXADOR:
Para cada ideia acima, responder com:
  CONFIRMA — se Valdece demonstrou comportamento, interesse ou disposição compatível
  EXPANDE  — se Valdece tem contexto que potencializa esta ideia além do proposto
  ALERTA   — se o comportamento real do Valdece contradiz ou torna esta ideia arriscada

Formato de resposta para cada ideia:
  [M/G/N]-[N]: [NOME DA IDEIA]
  Reação: [CONFIRMA / EXPANDE / ALERTA]
  Evidência da MEMORIA_EMBAIXADOR: [citar o que Valdece disse/fez]
  Severidade (apenas para ALERTA): [ALTO / CRÍTICO]

ANÁLISE INOVADORA OBRIGATÓRIA (P-035 — amplitude total):
- Estratégia comercial: qual o timing certo para apresentar a Manutenção Soberana R$900/mês?
- Pipeline: há outros advogados no círculo do Valdece que o sistema já serviria?
- Business case: quais dados da demo validam escala para outros escritórios criminais?
- Risco não endereçado: o que o Músculo e o Gemini não estão vendo sobre o perfil do Valdece?
```

---

## 📤 FORMATO OBRIGATÓRIO — O QUE O EMBAIXADOR ENTREGA

```
[E-1 a E-5] — IDEIAS EXCLUSIVAS DO EMBAIXADOR
Perspectiva exclusiva do relacionamento real com o Valdece.
Para cada ideia: o que é + por que Valdece valorizaria + evidência da MEMORIA_EMBAIXADOR.

[E-1] [NOME DA IDEIA]
Descrição: [o que é]
Por que Valdece valorizaria: [razão fundamentada no histórico]
Evidência: [o que Valdece disse/fez que apoia esta ideia]

[E-2] ... [E-3] ... [E-4] ... [E-5] ...

TEMPERATURA ATUALIZADA DO CLIENTE
[FRIA / MORNA / QUENTE / ENTUSIASMADA]
Razão: [1-2 linhas com evidência concreta]

WATCHDOG — ALERTAS ATIVOS
[SCOPE-WATCH] abertos: [LISTAR OU "nenhum"]
[CHURN-WATCH] ativos: [LISTAR OU "nenhum"]
Próximo debrief recomendado: [DATA OU "após a demo"]

PRÓXIMA AÇÃO RECOMENDADA PELO EMBAIXADOR
[AÇÃO ESPECÍFICA] — [QUEM EXECUTA] — [PRAZO]
Razão: [por que esta ação agora e não outra]
```

---

## ✅ VALIDAÇÃO ANTES DE FECHAR A SESSÃO

| Item | Critério |
|---|---|
| [E-1 a E-5] foram geradas? | Sim — exclusivas, não síntese dos outros membros |
| Todas as ideias do Pentalateral receberam reação? | Sim — CONFIRMA/EXPANDE/ALERTA com evidência |
| Análise inovadora presente? | Sim — amplitude total P-035, não só comportamento |
| SCOPE-WATCH atualizado? | Sim — contrato pendente é watch permanente |
| Temperatura atualizada com razão declarada? | Sim |
| MEMORIA_EMBAIXADOR marcada para atualização P-032? | Sim — Músculo executa após sessão |

---

## 📅 PRÓXIMAS ATIVAÇÕES PROGRAMADAS

| Momento | Seção | Urgência |
|---|---|---|
| Antes da demo ao vivo | SEÇÃO A (briefing pré-demo) | ALTA |
| Após a demo | SEÇÃO B (debrief) | ALTA — prazo 24h |
| Se Valdece mencionar colega | SEÇÃO C (pipeline) | IMEDIATA |
| Após Gemini + NotebookLM Loop 4 | SEÇÃO D (reação) | NORMAL |
| Se 3+ dias sem contato pós-demo | SEÇÃO B (debrief) | [CHURN-WATCH] |

---

*PASSO7 · Projeto Valdece · Loop 4 · Criado em 2026-05-19*
*Template universal: QUADRILATERAL_UNIVERSAL/OPERACAO/PASSO7_EMBAIXADOR_TEMPLATE.md*
