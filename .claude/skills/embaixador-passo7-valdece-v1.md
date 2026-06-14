---
name: embaixador-passo7-valdece-v1
description: "Invocar ao executar PASSO 7 para o cliente VALDECE. GATE: confirmar cliente ativo = VALDECE antes de qualquer acao."
---

SKILL: embaixador-passo7-valdece-v1.md
Camada: Pentalateral IAH — Embaixador PASSO 7 | Projeto: VALDECE (PROJ-001) | Dependencia: claude-projects-remote-v1

[GATE DE INVOCACAO]
BLOQUEANTE: verificar WIP_BOARD.json -> projeto com status = VALDECE antes de prosseguir.
Se cliente ativo for diferente -> parar + alertar: "CLIENTE DETECTADO: [X] — esta skill e para VALDECE. Invocar embaixador-passo7-[X]-v1."
P-059: isolamento de contexto e lei — nunca misturar arquivos de clientes.

[AUDITORIA DE COERENCIA]
VALDECE e cliente externo (PROJ-001) — nicho LegalTech, Hypercare ativa ate 18-06-2026. O PASSO 7 da VALDECE usa arquivos especificos: MEMORIA_EMBAIXADOR (historico de comportamento do cliente), LOOP_STATE (fase do loop), PERFIL_NICHO_LEGALTECH_V1 (contexto de mercado juridico), INTELLIGENCE_LEDGER e 16_VANGUARD_TIMELINE (base universal). Coerencia com P-059: URL do projeto Claude.ai da VALDECE e diferente do VANGUARD e INGRID — confirmar com o Diretor antes da primeira operacao remota. Coerencia com P-032: MEMORIA_EMBAIXADOR deve estar atualizada antes do upload. Refs: INTELLIGENCE_LEDGER.md P-059/P-032, CLIENTES\VALDECE\CLAUDE_PROJECT\LOOP_STATE.json, MEMORIA_EMBAIXADOR.md VALDECE.

[CONEXAO HISTORICA]
PROJ-001 VALDECE — LegalTech (automacao juridica). Entrega V3 concluida. Hypercare ativa ate 18-06-2026 — proximo gate e a renovacao ou offboarding. MEMORIA_EMBAIXADOR.md (VALDECE) registra comportamento real do cliente e temperatura atual. PERFIL_NICHO_LEGALTECH_V1.md contem mapa do mercado juridico gerado pelo Cowork Engine. 02_OFFBOARDING_RUNBOOK.md indica que processo de transicao esta planejado. Refs: INTELLIGENCE_LEDGER.md P-001 (PROJ-001 Valdece), CLIENTES\VALDECE\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md, WIP_BOARD.json campo hypercare_ate 2026-06-18.

[PADRAO DE SUCESSO/FALHA]
SUCESSO — Gate P-059 antes do upload: confirmar WIP_BOARD cliente ativo = VALDECE.
SUCESSO — MEMORIA_EMBAIXADOR VALDECE atualizada (LastWriteTime do dia) antes de enviar ao Embaixador.
FALHA (BLOQUEANTE) — Upload sem URL confirmada do projeto VALDECE: risco de enviar para projeto errado.
FALHA — Passo7 sem 02_OFFBOARDING_RUNBOOK.md quando Hypercare expira: Embaixador opera sem saber que o cliente esta em transicao de saida.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, a VALDECE esta em fase critica: Hypercare expira 18-06-2026 e a renovacao nao esta garantida. O Embaixador no PASSO 7 deve priorizar o diagnostico de temperatura do cliente e a probabilidade de renovacao vs offboarding. IDEIA DISRUPTIVA: incluir 02_OFFBOARDING_RUNBOOK.md no upload do PASSO7 quando a data de Hypercare estiver a menos de 7 dias — Embaixador tem o plano de saida para caso o cliente nao renove. PROPONHO adicionar esta logica condicional ao gate de invocacao da skill.

---

## ARQUIVOS DO PASSO 7 — VALDECE

| # | Arquivo | Path local |
|---|---------|-----------|
| 1 | MEMORIA_EMBAIXADOR.md | CLIENTES\VALDECE\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md |
| 2 | LOOP_STATE.json | CLIENTES\VALDECE\CLAUDE_PROJECT\LOOP_STATE.json |
| 3 | 07_WIP_BOARD.json | CLIENTES\VALDECE\CLAUDE_PROJECT\07_WIP_BOARD.json |
| 4 | 06_INTELLIGENCE_LEDGER.md | CLIENTES\VALDECE\CLAUDE_PROJECT\06_INTELLIGENCE_LEDGER.md |
| 5 | 16_VANGUARD_TIMELINE.md | CLIENTES\VALDECE\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md |
| 6 | PERFIL_NICHO_LEGALTECH_V1.md | CLIENTES\VALDECE\CLAUDE_PROJECT\PERFIL_NICHO_LEGALTECH_V1.md |

## PROJETO
URL: [CONFIRMAR COM DIRETOR — Claude Projects VALDECE]
Conta: subdiretor.mnmsgm@gmail.com

## MENSAGEM PASSO 7
Conteudo: colar o texto de CLIENTES\VALDECE\CLAUDE_PROJECT\PASSO7_EMBAIXADOR.md diretamente no chat.