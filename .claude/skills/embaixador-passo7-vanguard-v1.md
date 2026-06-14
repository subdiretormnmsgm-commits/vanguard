---
name: embaixador-passo7-vanguard-v1
description: "Invocar ao executar PASSO 7 para VANGUARD. GATE: confirmar cliente ativo = VANGUARD. Drive-First: sem upload, Embaixador busca no Drive."
---

SKILL: embaixador-passo7-vanguard-v1.md
Camada: Pentalateral IAH -- Embaixador PASSO 7 | Projeto: VANGUARD | Dependencia: claude-projects-remote-v1

[GATE DE INVOCACAO]
BLOQUEANTE: verificar WIP_BOARD.json -> cliente ativo = VANGUARD antes de qualquer acao.
Se diferente -> parar: "CLIENTE DETECTADO: [X] -- esta skill e para VANGUARD. Invocar embaixador-passo7-[X]-v1."
P-059: isolamento de contexto e lei.

[AUDITORIA DE COERENCIA]
PASSO 7 do VANGUARD usa documentos de inteligencia ativa: NICHE_INDEX, INTENCAO_LINKEDIN, LEDGER_INBOX, LOOP_STATE (contexto de loop), MEMORIA_EMBAIXADOR_VANGUARD, PENDENTES, INTELLIGENCE_LEDGER, 16_VANGUARD_TIMELINE. Diferente do encerramento (que usa PAINEL + CONTEXTO gerados pelo session_close). Coerencia com P-067: Embaixador reage ANTES da sintese P-037. Coerencia com Drive-First (2026-06-14): verify_gdrive_freshness.ps1 -Perfil VANGUARD confirma que os 9 arquivos estao no Drive antes de acionar. Nenhum upload via Playwright. Refs: P-059/P-067/P-036, LOOP_STATE.json, MEMORIA_EMBAIXADOR_VANGUARD.md.

[CONEXAO HISTORICA]
Loop 33 V2 (2026-06-14): 9 arquivos validados no Claude Projects via upload Playwright. Arquitetura evoluida para Drive-First: Embaixador busca em gdrive:vanguard. NICHE_INDEX.json (305 linhas) reflete Cowork Engine Loop 33. INTENCAO_LINKEDIN.md registra outreach ECD 2026 (deadline 30/06 -- CRITICO). LOOP_STATE.json resolve amnesia pos-compactacao. 16_VANGUARD_TIMELINE em CLAUDE_PROJECT (nao NOTEBOOKLM_FONTES -- erro historico 2026-06-14).

[PADRAO DE SUCESSO/FALHA]
SUCESSO -- verify_gdrive_freshness.ps1 -Perfil VANGUARD exit 0 + Playwright envia SECAO D no chat. Embaixador le 9 arquivos do Drive e responde com filtro de realidade.
FALHA BLOQUEANTE -- Acionar sem gate de frescor: Embaixador opera com dados desatualizados.
FALHA BLOQUEANTE -- Gate P-059 ignorado: risco de enviar contexto VANGUARD para projeto INGRID/VALDECE.
FALHA -- LOOP_STATE.json desatualizado: Embaixador nao sabe a fase atual do loop. Verificar LastWriteTime antes do gate.

[PERSPECTIVA DO SOCIO]
LOOP_STATE.json e o documento mais critico para continuidade entre sessoes. NICHE_INDEX e o mapa de mercado vivo -- deve estar sincronizado com o ultimo Cowork. INTENCAO_LINKEDIN tem deadline 30/06/2026 -- sempre prioridade no PASSO 7 do VANGUARD enquanto o prazo nao vencer.

---

## FLUXO PASSO 7 VANGUARD

### PASSO 1 -- Gate de frescor (BLOQUEANTE)
```
.\scripts\verify_gdrive_freshness.ps1 -Perfil VANGUARD
```
EXIT 0: prosseguir | EXIT 1: atualizar + Gate 10 + re-executar

### PASSO 2 -- Playwright (claude-projects-remote-v1)
1. browser_navigate -> https://claude.ai/project/019e4c70-7e31-75d4-a568-cbb1077fb439
2. browser_snapshot -> localizar campo de chat
3. browser_type -> colar mensagem PASSO 7 (template abaixo)
4. browser_press_key -> Enter
5. browser_snapshot -> confirmar envio

SEM exclusao de arquivos. SEM browser_file_upload.

---

## ARQUIVOS NO DRIVE (9 -- gdrive:vanguard)

1. CLIENTES/VANGUARD/INTENCAO_LINKEDIN.md
2. PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_INDEX.json
3. LEDGER_INBOX.md
4. CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json
5. PENDENTES.md
6. CLIENTES/WIP_BOARD.json
7. INTELLIGENCE_LEDGER.md
8. CLIENTES/VANGUARD/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR_VANGUARD.md
9. CLIENTES/VANGUARD/CLAUDE_PROJECT/16_VANGUARD_TIMELINE.md  -- nao em NOTEBOOKLM_FONTES

---

## TEMPLATE PASSO 7

```
Embaixador, PASSO 7 VANGUARD -- Loop [N] V[X] -- [data]

Os documentos estao no Google Drive (subdiretor.mnmsgm@gmail.com, pasta vanguard). Leia via Drive MCP:

1. CLIENTES/VANGUARD/INTENCAO_LINKEDIN.md
2. PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_INDEX.json
3. LEDGER_INBOX.md
4. CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json
5. PENDENTES.md
6. CLIENTES/WIP_BOARD.json
7. INTELLIGENCE_LEDGER.md
8. CLIENTES/VANGUARD/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR_VANGUARD.md
9. CLIENTES/VANGUARD/CLAUDE_PROJECT/16_VANGUARD_TIMELINE.md

[SECAO D do PASSO7_EMBAIXADOR.md de VANGUARD -- colar aqui o conteudo completo]
```

Nota: conteudo da SECAO D lido de CLIENTES\VANGUARD\PASSO7_EMBAIXADOR.md antes de enviar.