---
name: embaixador-passo7-vanguard-v1
description: "Invocar ao executar o PASSO 7 para o cliente VANGUARD — define arquivos especificos, projeto Claude.ai e formato de mensagem para interacoes do Embaixador com o projeto interno Vanguard. Requer claude-projects-remote-v1 para a camada tecnica."
---

SKILL: embaixador-passo7-vanguard-v1.md
Camada: Pentalateral IAH — Embaixador | Projeto: VANGUARD | Dependencia: claude-projects-remote-v1

[AUDITORIA DE COERENCIA]
O PASSO 7 do VANGUARD e uma interacao especifica do ciclo Pentalateral — ocorre em momentos distintos do encerramento de sessao: pre-reuniao, debrief, pipeline, reacao ao Pentalateral. O projeto Claude.ai do VANGUARD e o "Embaixador - Diretor" (ID: 019e4c70-7e31-75d4-a568-cbb1077fb439, conta subdiretor.mnmsgm@gmail.com) — o mesmo projeto usado no encerramento, pois o VANGUARD e o projeto interno da holding. Coerencia com P-059: isolamento de contexto — ao operar PASSO7 VANGUARD, confirmar que o cliente ativo no WIP_BOARD e VANGUARD antes de enviar qualquer mensagem. Coerencia com P-067: Embaixador reage ANTES do Musculo executar sintese P-037. Coerencia com P-036: Musculo prepara mensagem estruturada para o Embaixador antes de ativa-lo. Esta skill define O QUE enviar no PASSO7 VANGUARD; a camada tecnica esta em claude-projects-remote-v1.

[CONEXAO HISTORICA]
VANGUARD e o projeto interno da holding Pentalateral IAH — nao e um cliente externo, e a propria empresa. Loop 33 V2 (2026-06-14): operacoes de infraestrutura (EasyPanel, P-059 Notion, W-9 Track TRENDS desbloqueado via GOOGLE_AI_API_KEY). MEMORIA_EMBAIXADOR_VANGUARD.md contem historico de decisoes de produto e arquitetura desde Loop 29. 16_VANGUARD_TIMELINE.md (803 linhas) e o documento mais denso — registra toda a evolucao do sistema V1 a V29+. Path critico: CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md (nao em NOTEBOOKLM_FONTES — erro historico 2026-06-14). Refs: INTELLIGENCE_LEDGER.md P-130/P-124, WIP_BOARD.json Loop 33, MEMORIA_EMBAIXADOR_VANGUARD.md, CLIENTES\VANGUARD\PASSO7_EMBAIXADOR.md.

[PADRAO DE SUCESSO/FALHA]
SUCESSO VALIDADO — Upload VANGUARD: 2 arquivos especificos (MEMORIA_EMBAIXADOR_VANGUARD + 16_VANGUARD_TIMELINE) somados aos 5 universais no encerramento. Validado 2026-06-14.
SUCESSO VALIDADO — Mensagem PASSO7-A (pre-reuniao): Embaixador retorna perspectiva comportamental sobre o projeto + alertas de deriva + 5 ideias [E-1 a E-5].
FALHA (BLOQUEANTE) — Path 16_VANGUARD_TIMELINE.md errado: ENOENT ao tentar usar NOTEBOOKLM_FONTES. Path correto: CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md.
FALHA — Ativar PASSO7 sem preparar mensagem estruturada (P-036): Embaixador opera sem contexto do loop atual e retorna resposta generica sem valor para P-037.
GATE APRENDIDO — Verificar MEMORIA_EMBAIXADOR_VANGUARD.md atualizada (LastWriteTime do dia) antes de enviar ao Embaixador. Versao antiga = Embaixador reage ao estado anterior do projeto.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, o VANGUARD e diferente dos clientes externos: nao ha reuniao de vendas nem temperatura de cliente a monitorar — ha decisoes de produto, arquitetura e estrategia interna. O Embaixador no PASSO7 VANGUARD atua como analista critico do proprio sistema, nao como gestor de relacionamento comercial. Recomendacoes: (1) SEMPRE incluir o bloco ATUALIZACOES DO PROCESSO na mensagem PASSO7 ao Embaixador (P-018 — informar socios ao fechar sessao); (2) 16_VANGUARD_TIMELINE.md e o documento mais valioso para o Embaixador — nunca omitir; (3) ao identificar deriva de processo, incluir no PASSO7 como item de ALERTA para o Embaixador reagir. IDEIA DISRUPTIVA: criar PASSO7_VANGUARD_TEMPLATE.md especifico para o projeto interno — diferente do template de cliente externo (PASSO7_EMBAIXADOR_TEMPLATE.md), deve incluir secao de DECISOES DE ARQUITETURA e LEDGER DELTA (principios novos desde o ultimo loop). PROPONHO criar este template no proximo ciclo de infraestrutura.

---

## ARQUIVOS ESPECIFICOS DO VANGUARD

| Arquivo | Path local | Observacao |
|---------|-----------|------------|
| MEMORIA_EMBAIXADOR_VANGUARD.md | CLIENTES\VANGUARD\CLAUDE_PROJECT\ | Memoria persistente do projeto |
| 16_VANGUARD_TIMELINE.md | CLIENTES\VANGUARD\CLAUDE_PROJECT\ | ATENCAO: nao esta em NOTEBOOKLM_FONTES |

## PROJETO CLAUDE.AI
URL: https://claude.ai/project/019e4c70-7e31-75d4-a568-cbb1077fb439
Conta: subdiretor.mnmsgm@gmail.com
(Mesmo projeto do encerramento — VANGUARD e o projeto interno da holding)

## TEMPLATE PASSO7 VANGUARD
Arquivo base: CLIENTES\VANGUARD\PASSO7_EMBAIXADOR.md
Preparar com: contexto do loop atual + decisoes tomadas + [M-1 a M-5] + [G-1 a G-5] + [N-1 a N-5] + ATUALIZACOES DO PROCESSO (P-018) + perguntas especificas para o Embaixador.