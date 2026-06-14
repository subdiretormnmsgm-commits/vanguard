---
name: embaixador-passo7-ingrid-v1
description: "Invocar ao executar PASSO 7 para INGRID. GATE: confirmar cliente ativo = INGRID. Drive-First: sem upload, Embaixador busca no Drive."
---

SKILL: embaixador-passo7-ingrid-v1.md
Camada: Pentalateral IAH -- Embaixador PASSO 7 | Projeto: INGRID (PROJ-002) | Dependencia: claude-projects-remote-v1

[GATE DE INVOCACAO]
BLOQUEANTE: verificar WIP_BOARD.json -> cliente ativo = INGRID antes de qualquer acao.
Se diferente -> parar: "CLIENTE DETECTADO: [X] -- esta skill e para INGRID. Invocar embaixador-passo7-[X]-v1."
P-059: isolamento de contexto e lei -- nunca misturar arquivos de clientes.

[AUDITORIA DE COERENCIA]
INGRID e cliente externo (PROJ-002) -- nicho EdTech. O PASSO 7 usa arquivos especificos: MEMORIA_EMBAIXADOR (comportamento real da cliente), LOOP_STATE (fase do loop), PERFIL_CLIENTE_INGRID e PERFIL_NICHO_EDTECH (contexto de nicho). Coerencia com Drive-First (2026-06-14): verify_gdrive_freshness.ps1 -Perfil INGRID confirma que os 7 arquivos estao no Drive antes de acionar. Nenhum upload via Playwright. URL do projeto Claude.ai da INGRID e diferente do VANGUARD -- confirmar com Diretor antes da primeira operacao. Refs: P-059/P-067/P-032, CLIENTES\INGRID\CLAUDE_PROJECT\LOOP_STATE.json.

[CONEXAO HISTORICA]
PROJ-002 INGRID -- EdTech (plataforma de cursos). Loops 1 a 8 concluidos. MEMORIA_EMBAIXADOR.md registra comportamento real da cliente: padrao de engajamento, temperatura, hipoteses. PERFIL_NICHO_EDTECH_V1.md e o mapa do mercado de educacao digital do Cowork Engine. 06_INTELLIGENCE_LEDGER.md e a copia do LEDGER no Claude Project da INGRID. 07_WIP_BOARD.json e a copia do board com status dos gates.

[PADRAO DE SUCESSO/FALHA]
SUCESSO -- verify_gdrive_freshness.ps1 -Perfil INGRID exit 0 + Playwright envia PASSO 7 no chat correto (URL INGRID). Embaixador le 7 arquivos do Drive.
FALHA BLOQUEANTE -- Gate P-059 ignorado: risco de enviar contexto INGRID para projeto VANGUARD ou VALDECE.
FALHA BLOQUEANTE -- URL do projeto INGRID nao confirmada: risco de enviar para projeto errado. Confirmar com Diretor antes da primeira operacao remota.
FALHA -- MEMORIA_EMBAIXADOR desatualizada: Embaixador reage ao estado anterior da cliente. Verificar LastWriteTime.

[PERSPECTIVA DO SOCIO]
MEMORIA_EMBAIXADOR e PERFIL_CLIENTE_INGRID sao os documentos mais valiosos para INGRID -- registram como a cliente realmente se comporta vs o que ela declara. Sem eles atualizados, o Embaixador da conselhos para um cliente imaginario. RUNNING_INTELLIGENCE_INGRID.md (backlog): acumular sinais de mercado EdTech entre loops -- proposta para proximo ciclo.

---

## FLUXO PASSO 7 INGRID

### PASSO 1 -- Gate de frescor (BLOQUEANTE)
```
.\scripts\verify_gdrive_freshness.ps1 -Perfil INGRID
```
EXIT 0: prosseguir | EXIT 1: atualizar + Gate 10 + re-executar

### PASSO 2 -- Playwright (claude-projects-remote-v1)
1. browser_navigate -> [URL DO PROJETO INGRID -- confirmar com Diretor]
2. browser_snapshot -> localizar campo de chat
3. browser_type -> colar mensagem PASSO 7 (template abaixo)
4. browser_press_key -> Enter
5. browser_snapshot -> confirmar envio

SEM exclusao de arquivos. SEM browser_file_upload.

---

## ARQUIVOS NO DRIVE (7 -- gdrive:vanguard)

1. CLIENTES/INGRID/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md
2. CLIENTES/INGRID/CLAUDE_PROJECT/LOOP_STATE.json
3. CLIENTES/INGRID/CLAUDE_PROJECT/07_WIP_BOARD.json
4. CLIENTES/INGRID/CLAUDE_PROJECT/06_INTELLIGENCE_LEDGER.md
5. CLIENTES/INGRID/CLAUDE_PROJECT/16_VANGUARD_TIMELINE.md
6. CLIENTES/INGRID/CLAUDE_PROJECT/PERFIL_CLIENTE_INGRID.md
7. CLIENTES/INGRID/CLAUDE_PROJECT/PERFIL_NICHO_EDTECH_V1.md

---

## TEMPLATE PASSO 7

```
Embaixador, PASSO 7 INGRID -- Loop [N] V[X] -- [data]

Os documentos estao no Google Drive (subdiretor.mnmsgm@gmail.com, pasta vanguard). Leia via Drive MCP:

1. CLIENTES/INGRID/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md
2. CLIENTES/INGRID/CLAUDE_PROJECT/LOOP_STATE.json
3. CLIENTES/INGRID/CLAUDE_PROJECT/07_WIP_BOARD.json
4. CLIENTES/INGRID/CLAUDE_PROJECT/06_INTELLIGENCE_LEDGER.md
5. CLIENTES/INGRID/CLAUDE_PROJECT/16_VANGUARD_TIMELINE.md
6. CLIENTES/INGRID/CLAUDE_PROJECT/PERFIL_CLIENTE_INGRID.md
7. CLIENTES/INGRID/CLAUDE_PROJECT/PERFIL_NICHO_EDTECH_V1.md

[SECAO D do PASSO7_EMBAIXADOR.md de INGRID -- colar aqui o conteudo completo]
```

Nota: conteudo da SECAO D lido de CLIENTES\INGRID\CLAUDE_PROJECT\PASSO7_EMBAIXADOR.md antes de enviar.