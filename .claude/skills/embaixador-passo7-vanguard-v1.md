---
name: embaixador-passo7-vanguard-v1
description: "Invocar ao executar PASSO 7 para o cliente VANGUARD. GATE: confirmar cliente ativo = VANGUARD antes de qualquer acao."
---

SKILL: embaixador-passo7-vanguard-v1.md
Camada: Pentalateral IAH — Embaixador PASSO 7 | Projeto: VANGUARD (holding interna) | Dependencia: claude-projects-remote-v1

[GATE DE INVOCACAO]
BLOQUEANTE: verificar WIP_BOARD.json -> projeto com status BUILD = VANGUARD antes de prosseguir.
Se cliente ativo for diferente -> parar + alertar: "CLIENTE DETECTADO: [X] — esta skill e para VANGUARD. Invocar embaixador-passo7-[X]-v1."
P-059: isolamento de contexto e lei — nunca misturar arquivos de clientes.

[AUDITORIA DE COERENCIA]
O PASSO 7 do VANGUARD usa um conjunto de arquivos diferente do encerramento. O encerramento envia PAINEL + CONTEXTO gerados pelo session_close; o PASSO 7 envia os documentos de inteligencia ativa do projeto: NICHE_INDEX, INTENCAO_LINKEDIN, LEDGER_INBOX, LOOP_STATE. Coerencia com P-067: Embaixador reage ANTES do Musculo executar sintese P-037. Coerencia com P-036: Musculo prepara mensagem estruturada antes de acionar o Embaixador. Coerencia com P-059: confirmar cliente = VANGUARD antes de qualquer upload. O projeto Claude.ai do VANGUARD e o "Embaixador - Diretor" (ID: 019e4c70-7e31-75d4-a568-cbb1077fb439, conta subdiretor.mnmsgm@gmail.com). Refs: INTELLIGENCE_LEDGER.md P-067/P-036/P-059, LOOP_STATE.json Loop 33, MEMORIA_EMBAIXADOR_VANGUARD.md.

[CONEXAO HISTORICA]
VANGUARD e o projeto interno da holding — nao e cliente externo. Loop 33 V2 (2026-06-14): 9 arquivos validados no Claude Projects. NICHE_INDEX.json (305 linhas) reflete o Cowork Engine Loop 33. INTENCAO_LINKEDIN.md registra a estrategia de outreach ECD 2026 (deadline 30/06 — CRITICO). LEDGER_INBOX.md e o canal de entrada de principios novos antes de serem promovidos ao INTELLIGENCE_LEDGER. LOOP_STATE.json (180 linhas) e o estado duravel do loop — resolve amnesia pos-compactacao (P-130). 16_VANGUARD_TIMELINE.md em CLAUDE_PROJECT (nao NOTEBOOKLM_FONTES — erro historico 2026-06-14).

[PADRAO DE SUCESSO/FALHA]
SUCESSO VALIDADO — Upload 9 arquivos VANGUARD: browser_file_upload com lista completa em uma chamada. Validado 2026-06-14.
SUCESSO VALIDADO — PASSO7 SECAO D como texto no chat: copiar conteudo de CLIENTES\VANGUARD\PASSO7_EMBAIXADOR.md e colar no chat — nao como arquivo anexo.
FALHA (BLOQUEANTE) — Upload sem gate de cliente: risco de enviar arquivos VANGUARD para projeto INGRID ou VALDECE. P-059 violado.
FALHA — 16_VANGUARD_TIMELINE.md com path errado (NOTEBOOKLM_FONTES): ENOENT silencioso. Path correto: CLIENTES\VANGUARD\CLAUDE_PROJECT\.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, o VANGUARD e o unico projeto onde o Embaixador atua como analista critico do proprio sistema — nao como gestor de relacionamento comercial. O LOOP_STATE.json e o documento mais importante para continuidade entre sessoes: sem ele, o Embaixador opera sem saber em qual fase do loop o sistema esta. IDEIA DISRUPTIVA: automatizar o upload dos 9 arquivos via script ir_ao_embaixador.ps1 -cliente VANGUARD -AutoUpload — eliminando risco de path errado. PROPONHO adicionar ao PENDENTES como item [musculo] para o proximo ciclo de infraestrutura.

---

## ARQUIVOS DO PASSO 7 — VANGUARD (9 fixos)

| # | Arquivo | Path local |
|---|---------|-----------|
| 1 | INTENCAO_LINKEDIN.md | CLIENTES\VANGUARD\INTENCAO_LINKEDIN.md |
| 2 | NICHE_INDEX.json | PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\NICHE_INDEX.json |
| 3 | LEDGER_INBOX.md | LEDGER_INBOX.md (raiz) |
| 4 | LOOP_STATE.json | CLIENTES\VANGUARD\CLAUDE_PROJECT\LOOP_STATE.json |
| 5 | PENDENTES.md | PENDENTES.md (raiz) |
| 6 | 07_WIP_BOARD.json | CLIENTES\VANGUARD\CLAUDE_PROJECT\07_WIP_BOARD.json |
| 7 | INTELLIGENCE_LEDGER.md | INTELLIGENCE_LEDGER.md (raiz) |
| 8 | MEMORIA_EMBAIXADOR_VANGUARD.md | CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md |
| 9 | 16_VANGUARD_TIMELINE.md | CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md |

## PROJETO
URL: https://claude.ai/project/019e4c70-7e31-75d4-a568-cbb1077fb439
Conta: subdiretor.mnmsgm@gmail.com

## MENSAGEM PASSO 7
Conteudo: colar o texto de CLIENTES\VANGUARD\PASSO7_EMBAIXADOR.md diretamente no chat (nao como arquivo).