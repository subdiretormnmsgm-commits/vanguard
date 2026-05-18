# PASSO 7 — TEMPLATE UNIVERSAL: PARA O EMBAIXADOR (CLAUDE PROJECTS)
# Versão: Universal · QUADRILATERAL_UNIVERSAL/OPERACAO/
# Uso: O Músculo preenche os [PLACEHOLDERS] com dados reais antes de enviar ao Embaixador.

---

## INSTRUÇÕES PARA O DIRETOR — ANTES DE ABRIR O CLAUDE PROJECTS

**O que fazer (em 3 passos simples):**

```
1. RODAR no terminal:
   .\scripts\ir_ao_embaixador.ps1 -cliente [NOME]
   → Script copia MENSAGEM_INTERACAO_INICIAL para clipboard
   → Abre browser em claude.ai/projects
   → Abre Explorer na pasta CLIENTES\[NOME]\CLAUDE_PROJECT\

2. NO CLAUDE PROJECTS:
   Se primeiro acesso: colar 00_INSTRUCAO_SISTEMA.md em Settings > Instructions
   Em qualquer acesso: colar o conteúdo da seção relevante deste template no chat

3. AGUARDAR resposta do Embaixador.
   O Embaixador entrega: [E-1 a E-5] + alertas + temperatura do cliente
   Salvar output em: CLIENTES\[NOME]\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md
   (o Músculo atualiza automaticamente via P-032 após a sessão)
```

> Por que usar o Embaixador: ele é o único membro com memória persistente do cliente.
> Sem ele, cada sessão começa do zero com o cliente. Com ele, cada sessão começa
> onde a última terminou — acumulando inteligência que nenhum outro membro tem.

---

## PROTOCOLO ANTI-DEFICIÊNCIAS DO EMBAIXADOR
> Leia antes de cada ativação. O Embaixador tem deficiências documentadas — compensá-las ativamente.

**Deficiência 1 — Viés de Afinidade**
O Embaixador pode suavizar alertas sobre clientes com quem desenvolveu relacionamento positivo.
Contra-ataque: ao emitir ALERTA, exigir que o Embaixador cite evidência concreta da MEMORIA_EMBAIXADOR, não apenas intuição.

**Deficiência 2 — Excesso de Otimismo de Engajamento**
O Embaixador pode interpretar silêncio como "processando" quando na verdade é churn emocional.
Contra-ataque: qualquer cliente sem resposta há 5+ dias = ALERTA AP-1 obrigatório, mesmo que a última mensagem fosse positiva.

**Deficiência 3 — Generalização de Perfil**
O Embaixador pode aplicar padrões de um cliente anterior a um cliente diferente do mesmo nicho.
Contra-ataque: cada cliente tem entrada separada em MEMORIA_EMBAIXADOR. Nunca comparar perfis sem evidência explícita.

**Deficiência 4 — Omissão de Flags Desconfortáveis**
O Embaixador pode omitr sinais de que o cliente está insatisfeito para manter o momentum positivo.
Contra-ataque: Músculo pergunta diretamente: "Qual é o sinal mais preocupante que você detectou sobre [NOME] neste ciclo?"

**Deficiência 5 — Scope Creep Validado por Entusiasmo**
O Embaixador pode confirmar ideias do loop simplesmente porque o cliente mostrou entusiasmo com conceito similar, sem evidência de que o cliente pagaria por isso.
Contra-ataque: CONFIRMA só vale quando o cliente demonstrou disposição de pagar ou usar ativamente, não apenas interesse verbal.

---

## CABEÇALHO DA ATIVAÇÃO

```
ATIVAÇÃO DO EMBAIXADOR — [NOME_DO_CLIENTE]
Data: [YYYY-MM-DD]
Loop atual: [N] | Dia do build: [X] | Fase: [PRÉ-REUNIÃO / DEBRIEF / PIPELINE / REAÇÃO]
Última ativação: [DATA]
```

---

## CONTEXTO DO PROJETO
> O Músculo preenche esta seção com dados reais antes de enviar ao Embaixador.

**Cliente:** [NOME_DO_CLIENTE]
**Projeto:** [NOME_DO_PROJETO]
**Camada:** [1-5]
**Status atual:** [DESCREVER: o que foi entregue, o que falta, gate mais recente]
**Temperatura estimada do cliente (Músculo):** [FRIA / MORNA / QUENTE / ENTUSIASMADA]
**Itens [SCOPE-WATCH] abertos:** [LISTAR OU "nenhum"]
**Itens [CHURN-WATCH] abertos:** [LISTAR OU "nenhum"]

---

## MISSÃO DESTA ATIVAÇÃO
> Marcar somente uma. Colar a seção correspondente no chat do Embaixador.

- [ ] BRIEFING PRÉ-REUNIÃO — Eduardo vai se reunir com o cliente
- [ ] DEBRIEF PÓS-REUNIÃO — Eduardo acabou de se reunir com o cliente
- [ ] PIPELINE DE LEAD — cliente mencionou alguém que pode ser um lead
- [ ] REAÇÃO AO PENTALATERAL — Embaixador reage às ideias do ciclo atual

---

## SEÇÃO A — BRIEFING PRÉ-REUNIÃO

> Usar quando: Eduardo vai ter reunião com o cliente.
> Prazo: pelo menos 2 horas antes da reunião.

```
Embaixador, briefing pré-reunião para [NOME_DO_CLIENTE].

O QUE SABEMOS SOBRE ESTE CLIENTE (desta MEMORIA_EMBAIXADOR):
[LISTAR OS 3-5 PONTOS MAIS RELEVANTES DO HISTÓRICO]

O QUE ESTA REUNIÃO PRECISA ENTREGAR:
[DESCREVER: objetivo principal, decisão esperada, o que queremos que o cliente sinta ao sair]

O QUE QUEREMOS DESCOBRIR:
[LISTAR PERGUNTAS OU HIPÓTESES QUE PRECISAM SER VALIDADAS]

ALERTAS DO WATCHDOG PARA ESTA REUNIÃO:
[LISTAR ITENS [SCOPE-WATCH] / [CHURN-WATCH] abertos que podem emergir]

PEDIDO AO EMBAIXADOR:
1. Quais pontos desta reunião o Diretor deve abordar com cuidado?
2. Qual é a pergunta-chave que vai revelar o estado real do cliente?
3. O que o Diretor NÃO deve mencionar nesta reunião (e por quê)?
4. Se tudo correr bem, qual o próximo passo natural a propor?
```

---

## SEÇÃO B — DEBRIEF PÓS-REUNIÃO (Passo 8.5)

> Usar quando: Eduardo acabou de ter reunião, ligação ou troca relevante com o cliente.
> Prazo máximo: 24 horas após a reunião.

```
Embaixador, debrief pós-reunião com [NOME_DO_CLIENTE].

O QUE ACONTECEU (Eduardo relata informalmente):
[DESCREVER: como foi a reunião, o que o cliente disse, como reagiu ao produto,
 pedidos que fez, perguntas que fez, como terminou a reunião]

PEDIDO AO EMBAIXADOR:
Com base neste relato e no histórico de [NOME_DO_CLIENTE] na MEMORIA_EMBAIXADOR:

1. Quais hipóteses sobre este cliente foram CONFIRMADAS?
2. Quais hipóteses foram REFUTADAS (o cliente agiu diferente do esperado)?
3. Há sinais de SCOPE-WATCH que devo registrar?
4. Há sinais de CHURN-WATCH que devo monitorar?
5. O cliente mencionou alguém? (acionar pipeline de lead se sim)
6. Qual é a temperatura atual do cliente em escala FRIA/MORNA/QUENTE/ENTUSIASMADA?
7. Qual é o próximo passo que maximiza o avanço do projeto e do relacionamento?

ATUALIZAR MEMORIA_EMBAIXADOR com:
- Data da reunião e resumo de 3 linhas
- Hipóteses confirmadas/refutadas
- Alertas ativos (SCOPE-WATCH, CHURN-WATCH)
- Próxima ação recomendada
```

---

## SEÇÃO C — PIPELINE DE LEAD

> Usar quando: cliente mencionou alguém — colega, parceiro, amigo, concorrente — que pode ser lead.
> O Embaixador infere perfil e sugere pergunta casual a plantar.

```
Embaixador, pipeline de lead detectado a partir de [NOME_DO_CLIENTE].

O QUE O CLIENTE DISSE:
[DESCREVER: o que exatamente foi mencionado, contexto, como surgiu na conversa]

O QUE SABEMOS SOBRE O LEAD:
[DESCREVER: nome se conhecido, nicho, empresa, contexto inferido]

PEDIDO AO EMBAIXADOR:
1. Com base no que [NOME_DO_CLIENTE] disse, qual é o perfil mais provável deste lead?
2. Qual é a dor mais provável que este lead tem (inferida pelo nicho/contexto)?
3. Qual pergunta casual Eduardo pode plantar em [NOME_DO_CLIENTE] para saber mais?
4. Em qual momento natural da próxima conversa com [NOME_DO_CLIENTE] essa pergunta cabe?
5. Se qualificado, qual seria o "Choque de Valor Imediato" mais impactante para este perfil?
```

---

## SEÇÃO D — REAÇÃO AO PENTALATERAL (P-031)

> Usar quando: Músculo, Estrategista e Auditor geraram suas ideias e o Embaixador precisa filtrar pela realidade do cliente.
> Colar as ideias dos outros membros aqui para o Embaixador reagir.

```
Embaixador, reação ao ciclo atual do Pentalateral para [NOME_DO_CLIENTE].

[M-1 a M-5] — IDEIAS DO MÚSCULO:
[COLAR AS 5 IDEIAS DO MÚSCULO COM NOME E DESCRIÇÃO DE 2 LINHAS CADA]

[G-1 a G-5] — IDEIAS DO ESTRATEGISTA (GEMINI):
[COLAR AS 5 IDEIAS DO GEMINI COM NOME E DESCRIÇÃO DE 2 LINHAS CADA]

[N-1 a N-5] — IDEIAS DO AUDITOR (NOTEBOOKLM):
[COLAR AS 5 IDEIAS DO NOTEBOOKLM COM NOME E DESCRIÇÃO DE 2 LINHAS CADA]

PEDIDO AO EMBAIXADOR:
Para cada ideia acima, responder com:
  CONFIRMA — se o cliente demonstrou comportamento, interesse ou disposição compatível
  EXPANDE  — se o cliente tem contexto que potencializa esta ideia além do que foi proposto
  ALERTA   — se o comportamento real do cliente contradiz ou torna esta ideia arriscada

Formato de resposta para cada ideia:
  [M/G/N]-[N]: [NOME DA IDEIA]
  Reação: [CONFIRMA / EXPANDE / ALERTA]
  Evidência da MEMORIA_EMBAIXADOR: [citar o que o cliente disse/fez que fundamenta a reação]
  Severidade (apenas para ALERTA): [ALTO / CRÍTICO]
```

---

## O QUE O EMBAIXADOR ENTREGA

> Seção que o Embaixador preenche ao responder. O Músculo usa para atualizar MEMORIA_EMBAIXADOR.

**[E-1 a E-5] — IDEIAS EXCLUSIVAS DO EMBAIXADOR**
> Não síntese das ideias dos outros membros. Perspectiva única do relacionamento real com o cliente.
> Para cada ideia: o que é, por que o cliente específico valorizaria isso, e qual evidência da MEMORIA_EMBAIXADOR fundamenta a ideia.

```
[E-1] [NOME DA IDEIA]
Descrição: [o que é]
Por que [NOME_DO_CLIENTE] valorizaria: [razão fundamentada no histórico]
Evidência: [o que o cliente disse/fez que apoia esta ideia]

[E-2] ...
[E-3] ...
[E-4] ...
[E-5] ...
```

**TEMPERATURA ATUALIZADA DO CLIENTE**
```
[FRIA / MORNA / QUENTE / ENTUSIASMADA]
Razão: [1-2 linhas explicando a classificação]
```

**WATCHDOG — ALERTAS ATIVOS**
```
[SCOPE-WATCH] abertos: [LISTAR OU "nenhum"]
[CHURN-WATCH] ativos: [LISTAR OU "nenhum"]
Próximo debrief recomendado: [DATA OU "após próxima reunião"]
```

**PRÓXIMA AÇÃO RECOMENDADA PELO EMBAIXADOR**
```
[AÇÃO ESPECÍFICA] — [QUEM EXECUTA] — [PRAZO]
Razão: [por que esta ação agora e não outra]
```

---

## VALIDAÇÃO ANTES DE FECHAR A SESSÃO DO EMBAIXADOR

| Item | Critério |
|---|---|
| [E-1 a E-5] foram geradas? | Sim — exclusivas, não síntese |
| Todas as ideias do Pentalateral receberam reação? | Sim — CONFIRMA/EXPANDE/ALERTA com evidência |
| SCOPE-WATCH atualizado? | Sim — novos itens adicionados se detectados |
| Temperatura do cliente atualizada? | Sim — com razão declarada |
| MEMORIA_EMBAIXADOR marcada para atualização (P-032)? | Sim — Músculo atualiza após sessão |

---

*Template Universal · Pentalateral IAH · OPERACAO/ · Atualizar ao descobrir novo padrão de relacionamento com cliente*
*Versão: 1.0 · 2026-05-18*
