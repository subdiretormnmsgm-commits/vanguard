---
name: embaixador-passo7-ingrid-v1
description: "Invocar ao executar PASSO 7 para a cliente INGRID. GATE: confirmar cliente ativo = INGRID antes de qualquer acao."
---

SKILL: embaixador-passo7-ingrid-v1.md
Camada: Pentalateral IAH — Embaixador PASSO 7 | Projeto: INGRID (PROJ-002) | Dependencia: claude-projects-remote-v1

[GATE DE INVOCACAO]
BLOQUEANTE: verificar WIP_BOARD.json -> projeto com status BUILD = INGRID antes de prosseguir.
Se cliente ativo for diferente -> parar + alertar: "CLIENTE DETECTADO: [X] — esta skill e para INGRID. Invocar embaixador-passo7-[X]-v1."
P-059: isolamento de contexto e lei — nunca misturar arquivos de clientes.

[AUDITORIA DE COERENCIA]
INGRID e cliente externo (PROJ-002) — nicho EdTech, Loop 8 ativo. O PASSO 7 da INGRID usa arquivos especificos do projeto: MEMORIA_EMBAIXADOR (comportamento real da cliente), LOOP_STATE (fase atual do loop), PERFIL_CLIENTE_INGRID e PERFIL_NICHO_EDTECH (contexto de nicho), INTELLIGENCE_LEDGER e 16_VANGUARD_TIMELINE (base universal). Coerencia com P-059: URL do projeto Claude.ai da INGRID e diferente do VANGUARD — confirmar com o Diretor antes da primeira operacao remota. Coerencia com P-067: Embaixador reage ANTES do Musculo executar sintese P-037. Refs: INTELLIGENCE_LEDGER.md P-059/P-067, CLIENTES\INGRID\CLAUDE_PROJECT\LOOP_STATE.json, MEMORIA_EMBAIXADOR.md.

[CONEXAO HISTORICA]
PROJ-002 INGRID — EdTech (plataforma de cursos). Loops 1 a 8 concluidos. Hypercare ativa. MEMORIA_EMBAIXADOR.md (INGRID) registra comportamento real da cliente: padrao de engajamento, temperatura atual, hipoteses confirmadas e refutadas. PERFIL_NICHO_EDTECH_V1.md e o mapa do mercado de educacao digital gerado pelo Cowork Engine. 07_WIP_BOARD.json e a copia local do board com status dos gates do projeto. 16_VANGUARD_TIMELINE.md presente em INGRID/CLAUDE_PROJECT (copia para o Embaixador ter contexto da holding). Refs: INTELLIGENCE_LEDGER.md P-032, LOOP_STATE.json INGRID Loop 8, CLIENTES\INGRID\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md.

[PADRAO DE SUCESSO/FALHA]
SUCESSO — Gate P-059 antes do upload: confirmar WIP_BOARD cliente ativo = INGRID evita contaminacao de contexto.
SUCESSO — Colar SECAO D do PASSO7_EMBAIXADOR.md de INGRID no chat: Embaixador reage com filtro de realidade comportamental da cliente.
FALHA (BLOQUEANTE) — Upload sem verificar URL do projeto INGRID: risco de enviar para o projeto errado. URL deve ser confirmada com o Diretor antes da primeira operacao.
FALHA — Passo7 sem MEMORIA_EMBAIXADOR atualizada: Embaixador reage ao estado anterior da cliente. Verificar LastWriteTime antes do upload.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, o Embaixador e o filtro critico para INGRID: e o unico membro que sabe como a cliente realmente se comporta vs o que ela declara. O PERFIL_CLIENTE_INGRID.md e o documento mais valioso para calibrar as respostas. IDEIA DISRUPTIVA: criar RUNNING_INTELLIGENCE_INGRID.md espelhando o modelo do VANGUARD — acumulando sinais de mercado EdTech entre loops. PROPONHO incluir como item [musculo] no proximo ciclo de INGRID.

---

## ARQUIVOS DO PASSO 7 — INGRID

| # | Arquivo | Path local |
|---|---------|-----------|
| 1 | MEMORIA_EMBAIXADOR.md | CLIENTES\INGRID\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md |
| 2 | LOOP_STATE.json | CLIENTES\INGRID\CLAUDE_PROJECT\LOOP_STATE.json |
| 3 | 07_WIP_BOARD.json | CLIENTES\INGRID\CLAUDE_PROJECT\07_WIP_BOARD.json |
| 4 | 06_INTELLIGENCE_LEDGER.md | CLIENTES\INGRID\CLAUDE_PROJECT\06_INTELLIGENCE_LEDGER.md |
| 5 | 16_VANGUARD_TIMELINE.md | CLIENTES\INGRID\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md |
| 6 | PERFIL_CLIENTE_INGRID.md | CLIENTES\INGRID\CLAUDE_PROJECT\PERFIL_CLIENTE_INGRID.md |
| 7 | PERFIL_NICHO_EDTECH_V1.md | CLIENTES\INGRID\CLAUDE_PROJECT\PERFIL_NICHO_EDTECH_V1.md |

## PROJETO
URL: [CONFIRMAR COM DIRETOR — Claude Projects INGRID]
Conta: subdiretor.mnmsgm@gmail.com

## MENSAGEM PASSO 7
Conteudo: colar o texto de CLIENTES\INGRID\CLAUDE_PROJECT\PASSO7_EMBAIXADOR.md diretamente no chat.