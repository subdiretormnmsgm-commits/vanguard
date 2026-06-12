---
name: session-start-firewall-gate
description: Gate de inicialização para injetar no session_start.ps1 garantindo que o Firewall Pentalateral está ativo e a Inbox foi lida.
---

# GATE: Session Start Firewall

Este bloco de código PowerShell foi projetado para ser injetado no script `session_start.ps1`. A sua posição exata no script deve ser **após a leitura da INBOX_COWORK (Passo 0)** e **antes da varredura de PENDENTES (Passo 1)**.

A função deste *gate* é garantir que o Músculo nunca acorde em uma sessão onde o Firewall foi desabilitado, deletado ou esquecido. Ele força o estado de alerta constante sobre quais arquivos são intocáveis (R-01).

## [BLOCO POWERSHELL PARA INJEÇÃO]

```powershell
# =========================================================================
# [PASSO 0.5] GATE DE SEGURANÇA: PENTALATERAL FIREWALL
# =========================================================================
Write-Host "Inicializando Gate de Segurança do Pentalateral..." -ForegroundColor Cyan

$firewallPath = Join-Path $PSScriptRoot "..\.agents\rules\pentalateral-firewall.md"

# (a) Verifica se a constituição do Firewall está presente no repositório
if (-not (Test-Path $firewallPath)) {
    Write-Host "[ERRO CRÍTICO] Firewall ausente — não prosseguir sem .agents/rules/pentalateral-firewall.md" -ForegroundColor Red
    Write-Host "Abortando inicialização. Restaure o arquivo do firewall antes de acordar o Músculo." -ForegroundColor Red
    exit 1
}

# (b) Firewall Existe: Extração visual da proteção
Write-Host "Firewall Ativo [v1.1]. Arquivos protegidos nesta sessão (Lista R-01/Read-Only absoluto):" -ForegroundColor Green

# A lista abaixo espelha o R-01 canônico definido no firewall.
$r01_protected_display = @(
    "INTELLIGENCE_LEDGER.md",
    "PENDENTES.md",
    "WIP_BOARD.json",
    "DEPENDENCY_MAP.json",
    "CLAUDE.md",
    "GEMINI.md",
    "AGENTS.md",
    "PENTALATERAL_UNIVERSAL/** (Toda a árvore)",
    "CLIENTES/[OUTROS]/* (Isolamento P-059)",
    ".claude/skills/vanguard-*.md"
)

foreach ($item in $r01_protected_display) {
    Write-Host "  → $item" -ForegroundColor DarkGray
}

Write-Host "LEMBRETE AO MÚSCULO: Qualquer tentativa de edição nos arquivos acima resultará em aborto no Pre-Commit.`n" -ForegroundColor Yellow

# (c) Verificação do Passo 0 (INBOX_COWORK)
# Presume que o script anterior gravou uma variável ou arquivo temporário de que a Inbox foi limpa/lida
# Aqui usamos uma variável hipotética $inboxProcessada ou checamos o diretório
$inboxDir = Join-Path $PSScriptRoot "..\INBOX_COWORK"

if (Test-Path $inboxDir) {
    $inboxFiles = Get-ChildItem -Path $inboxDir -Filter "*.md"
    if ($inboxFiles.Count -gt 0 -and (-not $global:InboxProcessada)) {
        Write-Host "[ALERTA] Existem $($inboxFiles.Count) arquivos não processados na INBOX_COWORK." -ForegroundColor Yellow
        Write-Host "O Músculo deve ler o Output do Cowork (Passo 0) antes de iniciar qualquer Build ou Pendência.`n" -ForegroundColor Yellow
    }
} else {
    Write-Host "[INFO] Diretório INBOX_COWORK não detectado. Sem pendências de agentes paralelos.`n" -ForegroundColor DarkGray
}

# Fim do Gate - Continua para os Pendentes
```

## Como o Músculo utiliza este arquivo
O Músculo precisará usar suas capacidades de leitura/escrita para ler este markdown, isolar o bloco PowerShell acima, e inseri-lo cirurgicamente dentro do arquivo `scripts/session_start.ps1`. Ao injetar, ele garantirá que toda nova sessão a partir do Loop 34 esteja protegida por este blindado.
