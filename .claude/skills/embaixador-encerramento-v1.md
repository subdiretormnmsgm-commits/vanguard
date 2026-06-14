---
name: embaixador-encerramento-v1
description: "Invocar ao encerrar qualquer sessao -- verifica Drive fresco e envia mensagem canonico ao Embaixador via Playwright. Unico por sessao. Requer claude-projects-remote-v1."
---

SKILL: embaixador-encerramento-v1.md
Camada: Pentalateral IAH -- Gate de Encerramento (Universal) | Loop: toda sessao | Dependencia: claude-projects-remote-v1

[AUDITORIA DE COERENCIA]
O encerramento e unico -- acontece uma vez ao fim de qualquer sessao. Destino: projeto "Embaixador - Diretor" (ID: 019e4c70-7e31-75d4-a568-cbb1077fb439, conta subdiretor.mnmsgm@gmail.com). Coerencia com P-114: Embaixador precisa dos documentos atualizados para gerar o BLOCO 0. Coerencia com P-032: MEMORIA_EMBAIXADOR do cliente ativo deve estar atualizada ANTES (gate 6B do session_close.ps1). Coerencia com P-110: arquivos locais sao canônico -- Gate 10 (rclone) sincroniza para gdrive:vanguard. O Embaixador busca arquivos NO DRIVE via MCP -- nao recebe upload. NUNCA BLOCO 0 em HTML. NUNCA browser_file_upload -- Drive e a fonte.

[CONEXAO HISTORICA]
Encerramento original (2026-06-14, Loop 33 V2): Playwright com upload de 7 arquivos. Arquitetura evoluida em 2026-06-14 para Drive-First: Gate 10 sincroniza gdrive:vanguard + verify_gdrive_freshness.ps1 confirma frescor + Playwright envia apenas mensagem (sem upload, sem exclusao). Licao: HTML artefato travou mais de 5 min -- texto simples sempre. Refs: session_close.ps1 Gate 10, scripts/verify_gdrive_freshness.ps1, P-114/P-032.

[PADRAO DE SUCESSO/FALHA]
SUCESSO -- verify_gdrive_freshness.ps1 -Perfil ENCERRAMENTO retorna exit 0 + Playwright envia mensagem. Embaixador busca no Drive e responde em ~60s com BLOCO 0 texto simples.
FALHA BLOQUEANTE -- Acionar Embaixador sem verify_gdrive_freshness.ps1: Embaixador le arquivos desatualizados sem avisar.
FALHA BLOQUEANTE -- Gate 10 (rclone) nao rodou apos ultima modificacao: sync desatualizado. session_close.ps1 executa Gate 10 automaticamente.
FALHA -- BLOCO 0 em HTML: Embaixador fica "Trabalhando" mais de 5 min. Re-solicitar em texto simples imediatamente.

[PERSPECTIVA DO SOCIO]
Drive-First elimina risco de upload incorreto e torna o encerramento mais rapido. O Embaixador ja tem acesso ao Google Drive via MCP (subdiretor.mnmsgm@gmail.com) -- busca o que precisa quando instruido. verify_gdrive_freshness.ps1 garante que o Embaixador nao opera com informacao stale. PROXIMA EVOLUCAO (backlog): integrar gate de frescor ao session_close.ps1 como sub-etapa do Gate 7C -- Playwright dispara automaticamente sem intervencao do Diretor.

---

## FLUXO DE ENCERRAMENTO

### PASSO 1 -- Gate de frescor (BLOQUEANTE)
```
.\scripts\verify_gdrive_freshness.ps1 -Perfil ENCERRAMENTO
```
EXIT 0: prosseguir | EXIT 1: atualizar localmente + session_close.ps1 (Gate 10 sincroniza) + re-executar

### PASSO 2 -- Playwright (claude-projects-remote-v1)
1. browser_navigate -> https://claude.ai/project/019e4c70-7e31-75d4-a568-cbb1077fb439
2. browser_snapshot -> localizar campo de chat
3. browser_type -> colar mensagem canonico (template abaixo)
4. browser_press_key -> Enter
5. browser_snapshot -> confirmar envio + aguardar BLOCO 0 em texto simples

SEM exclusao de arquivos. SEM browser_file_upload.

---

## ARQUIVOS NO DRIVE (7 -- gdrive:vanguard)

1. PROTOCOLOS_ENCERRAMENTO/PAINEL_ATIVIDADES_[hoje].md
2. PROTOCOLOS_ENCERRAMENTO/CONTEXTO_SESSAO_DIRETOR_[hoje].md
3. CLIENTES/WIP_BOARD.json
4. INTELLIGENCE_LEDGER.md
5. PENDENTES.md
6. CLIENTES/VANGUARD/CLAUDE_PROJECT/16_VANGUARD_TIMELINE.md  -- nao em NOTEBOOKLM_FONTES
7. CLIENTES/VANGUARD/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR_VANGUARD.md

---

## TEMPLATE CANONICO

```
Embaixador, fechamento de sessao -- [DD-MM-YYYY] ([dia]) Loop [N] V[X] -- [tema]

Os documentos estao no Google Drive (subdiretor.mnmsgm@gmail.com, pasta vanguard). Leia via Drive MCP:

1. PROTOCOLOS_ENCERRAMENTO/PAINEL_ATIVIDADES_[YYYY-MM-DD].md
2. PROTOCOLOS_ENCERRAMENTO/CONTEXTO_SESSAO_DIRETOR_[YYYY-MM-DD].md
3. CLIENTES/WIP_BOARD.json
4. INTELLIGENCE_LEDGER.md
5. PENDENTES.md
6. CLIENTES/VANGUARD/CLAUDE_PROJECT/16_VANGUARD_TIMELINE.md
7. CLIENTES/VANGUARD/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR_VANGUARD.md

ENTREGAS DESTA SESSAO:
* [entrega 1 -- o que foi feito + impacto]
* [entrega 2]

FICOU NO AR:
* [MUSCULO] [pendente] -- [contexto]
* [DIRETOR] [pendente] -- [deadline]

PROXIMA SESSAO: [objetivo em 1 frase]

Leia os 7 arquivos e gere o BLOCO 0 em texto simples (sem HTML, sem artefato):
-- BLOCO 0: 3-5 linhas com o que ficou + o que o Musculo ataca primeiro + alertas criticos
-- Semaforo: VANGUARD / INGRID / VALDECE (1 linha cada)
-- Contexto da ultima sessao (3 linhas max)
-- Padrao detectado (so se aparecer em 2+ sessoes)
-- Inconsistencias abertas
-- Maximo 3 acoes do Diretor para esta semana
```