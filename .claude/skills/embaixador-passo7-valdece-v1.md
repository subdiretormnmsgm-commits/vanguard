---
name: embaixador-passo7-valdece-v1
description: "Invocar ao executar PASSO 7 para VALDECE. GATE: confirmar cliente ativo = VALDECE. Drive-First: sem upload, Embaixador busca no Drive."
---

SKILL: embaixador-passo7-valdece-v1.md
Camada: Pentalateral IAH -- Embaixador PASSO 7 | Projeto: VALDECE (PROJ-001) | Dependencia: claude-projects-remote-v1

[GATE DE INVOCACAO]
BLOQUEANTE: verificar WIP_BOARD.json -> cliente ativo = VALDECE antes de qualquer acao.
Se diferente -> parar: "CLIENTE DETECTADO: [X] -- esta skill e para VALDECE. Invocar embaixador-passo7-[X]-v1."
P-059: isolamento de contexto e lei -- nunca misturar arquivos de clientes.
GATE ADICIONAL -- Hypercare: se (hoje >= hypercare_ate - 7 dias), ler 02_OFFBOARDING_RUNBOOK.md e incluir na mensagem como contexto de transicao.

[AUDITORIA DE COERENCIA]
VALDECE e cliente externo (PROJ-001) -- nicho LegalTech, Hypercare ativa ate 18-06-2026. O PASSO 7 usa: MEMORIA_EMBAIXADOR (historico e temperatura do cliente), LOOP_STATE, PERFIL_NICHO_LEGALTECH_V1. Coerencia com Drive-First (2026-06-14): verify_gdrive_freshness.ps1 -Perfil VALDECE confirma 6 arquivos no Drive antes de acionar. Nenhum upload via Playwright. URL do projeto VALDECE diferente do VANGUARD e INGRID -- confirmar com Diretor. Refs: P-059/P-032, CLIENTES\VALDECE\CLAUDE_PROJECT\LOOP_STATE.json, WIP_BOARD.json hypercare_ate.

[CONEXAO HISTORICA]
PROJ-001 VALDECE -- LegalTech (automacao juridica). Entrega V3 concluida. Hypercare ate 18-06-2026. MEMORIA_EMBAIXADOR.md registra temperatura atual e historico de comportamento. PERFIL_NICHO_LEGALTECH_V1.md contem mapa do mercado juridico do Cowork Engine. 02_OFFBOARDING_RUNBOOK.md disponivel para caso o cliente nao renove.

[PADRAO DE SUCESSO/FALHA]
SUCESSO -- verify_gdrive_freshness.ps1 -Perfil VALDECE exit 0 + Playwright envia PASSO 7 no chat correto (URL VALDECE). Embaixador le 6 arquivos do Drive.
FALHA BLOQUEANTE -- Gate P-059 ignorado: risco de enviar contexto VALDECE para projeto errado.
FALHA BLOQUEANTE -- URL do projeto VALDECE nao confirmada: confirmar com Diretor antes da primeira operacao.
FALHA -- Passo7 sem 02_OFFBOARDING_RUNBOOK.md quando Hypercare expira: Embaixador opera sem saber que cliente esta em transicao. Gate adicional acima previne isso.

[PERSPECTIVA DO SOCIO]
VALDECE em fase critica: Hypercare expira 18-06-2026. O PASSO 7 deve priorizar diagnostico de temperatura e probabilidade de renovacao vs offboarding. Quando Hypercare < 7 dias: incluir 02_OFFBOARDING_RUNBOOK.md na mensagem -- Embaixador precisa do plano de saida para calibrar a recomendacao.

---

## FLUXO PASSO 7 VALDECE

### PASSO 0 -- Gate Hypercare (condicional)
```powershell
$wip = Get-Content "CLIENTES\WIP_BOARD.json" -Raw | ConvertFrom-Json
$valdece = $wip.projetos | Where-Object { $_.cliente -eq "VALDECE" }
$hypercare = [datetime]::Parse($valdece.hypercare_ate)
$diasRestantes = ($hypercare - (Get-Date)).Days
if ($diasRestantes -le 7) { Write-Host "HYPERCARE < 7 DIAS -- incluir 02_OFFBOARDING_RUNBOOK.md na mensagem" -ForegroundColor Yellow }
```

### PASSO 1 -- Gate de frescor (BLOQUEANTE)
```
.\scripts\verify_gdrive_freshness.ps1 -Perfil VALDECE
```
EXIT 0: prosseguir | EXIT 1: atualizar + Gate 10 + re-executar

### PASSO 2 -- Playwright (claude-projects-remote-v1)
1. browser_navigate -> [URL DO PROJETO VALDECE -- confirmar com Diretor]
2. browser_snapshot -> localizar campo de chat
3. browser_type -> colar mensagem PASSO 7 (template abaixo)
4. browser_press_key -> Enter
5. browser_snapshot -> confirmar envio

SEM exclusao de arquivos. SEM browser_file_upload.

---

## ARQUIVOS NO DRIVE (6 -- gdrive:vanguard)

1. CLIENTES/VALDECE/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md
2. CLIENTES/VALDECE/CLAUDE_PROJECT/LOOP_STATE.json
3. CLIENTES/VALDECE/CLAUDE_PROJECT/07_WIP_BOARD.json
4. CLIENTES/VALDECE/CLAUDE_PROJECT/06_INTELLIGENCE_LEDGER.md
5. CLIENTES/VALDECE/CLAUDE_PROJECT/16_VANGUARD_TIMELINE.md
6. CLIENTES/VALDECE/CLAUDE_PROJECT/PERFIL_NICHO_LEGALTECH_V1.md
[+ 02_OFFBOARDING_RUNBOOK.md se Hypercare < 7 dias]

---

## TEMPLATE PASSO 7

```
Embaixador, PASSO 7 VALDECE -- Loop [N] V[X] -- [data]

Os documentos estao no Google Drive (subdiretor.mnmsgm@gmail.com, pasta vanguard). Leia via Drive MCP:

1. CLIENTES/VALDECE/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md
2. CLIENTES/VALDECE/CLAUDE_PROJECT/LOOP_STATE.json
3. CLIENTES/VALDECE/CLAUDE_PROJECT/07_WIP_BOARD.json
4. CLIENTES/VALDECE/CLAUDE_PROJECT/06_INTELLIGENCE_LEDGER.md
5. CLIENTES/VALDECE/CLAUDE_PROJECT/16_VANGUARD_TIMELINE.md
6. CLIENTES/VALDECE/CLAUDE_PROJECT/PERFIL_NICHO_LEGALTECH_V1.md
[7. CLIENTES/VALDECE/CLAUDE_PROJECT/02_OFFBOARDING_RUNBOOK.md -- incluir se Hypercare < 7 dias]

[SECAO D do PASSO7_EMBAIXADOR.md de VALDECE -- colar aqui o conteudo completo]
```

Nota: conteudo da SECAO D lido de CLIENTES\VALDECE\CLAUDE_PROJECT\PASSO7_EMBAIXADOR.md antes de enviar.