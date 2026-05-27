#Requires -Version 5.1
# decisoes_watcher.ps1 -- Pipeline DECISOES automatico (P-071 / OSV-001)
# Monitora CLIENTES/*/CLAUDE_PROJECT/DECISOES/ para DECISOES_*.json e VEREDITOS_*.json
# Iniciado pelo session_start.ps1 como processo background.
# NUNCA recriar sem instrucao do Diretor -- credenciais em alert_config.ps1 (P-017).

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE           = Split-Path -Parent $PSScriptRoot
$LOG            = "$BASE\scripts\decisoes_watcher.log"
$DEPENDENCY_MAP = "$BASE\PENTALATERAL_UNIVERSAL\OPERACAO\DEPENDENCY_MAP.json"
$WIP_BOARD      = "$BASE\CLIENTES\WIP_BOARD.json"

function Write-Log {
    param([string]$msg)
    $ts   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts] $msg"
    Add-Content -Path $LOG -Value $line -Encoding UTF8
    Write-Host $line
}

# --- Projetos ativos: Get-ProjetosAtivos (dinamico) com fallback WIP_BOARD direto ---
$projetos = @()
$getProjetosScript = "$BASE\utils\Get-ProjetosAtivos.ps1"
if (Test-Path $getProjetosScript) {
    . $getProjetosScript
    $projetos = @(Get-ProjetosAtivos -WipPath $WIP_BOARD)
}
# Fallback direto ao WIP_BOARD se utils nao disponivel
if ($projetos.Count -eq 0 -and (Test-Path $WIP_BOARD)) {
    try {
        $board = Get-Content $WIP_BOARD -Raw -Encoding UTF8 | ConvertFrom-Json
        $projetos = @($board.board.build | Where-Object { $_.cliente } |
                      ForEach-Object { $_.cliente.ToUpper() })
    } catch { }
}
if ($projetos.Count -eq 0) {
    Write-Log "[WATCHER] Nenhum projeto ativo encontrado -- encerrando."
    exit 1
}

Write-Log "[WATCHER] Iniciando pipeline DECISOES -- projetos: $($projetos -join ', ')"

# --- Registrar watchers para cada projeto ---
$watchers = [System.Collections.ArrayList]@()

foreach ($proj in $projetos) {
    $pasta = "$BASE\CLIENTES\$proj\CLAUDE_PROJECT\DECISOES"
    if (-not (Test-Path $pasta)) {
        New-Item -ItemType Directory -Path $pasta -Force | Out-Null
        Write-Log "[WATCHER] Pasta DECISOES criada: $pasta"
    }

    $msgData = [PSCustomObject]@{
        Projeto = $proj
        Base    = $BASE
        Log     = $LOG
    }

    # --- Watcher A: DECISOES_*.json -- abrir render_painel.ps1 ---
    $wD = New-Object System.IO.FileSystemWatcher
    $wD.Path              = $pasta
    $wD.Filter            = "DECISOES_*.json"
    $wD.NotifyFilter      = [System.IO.NotifyFilters]::FileName -bor [System.IO.NotifyFilters]::LastWrite
    $wD.EnableRaisingEvents = $true

    $acaoDecisoes = {
        $arquivo  = $Event.SourceEventArgs.FullPath
        $projNome = $Event.MessageData.Projeto
        $basePath = $Event.MessageData.Base
        $logPath  = $Event.MessageData.Log
        $ts       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        Add-Content -Path $logPath -Value "[$ts] [DECISOES] Detectado: $arquivo" -Encoding UTF8

        $render = "$basePath\scripts\render_painel.ps1"
        if (Test-Path $render) {
            Start-Process powershell -ArgumentList "-NonInteractive -File `"$render`" -projeto $projNome" -WindowStyle Normal
            Add-Content -Path $logPath -Value "[$ts] [DECISOES] Painel aberto para $projNome" -Encoding UTF8
        } else {
            Add-Content -Path $logPath -Value "[$ts] [DECISOES] render_painel.ps1 nao encontrado" -Encoding UTF8
        }
    }

    Register-ObjectEvent -InputObject $wD -EventName "Created" -Action $acaoDecisoes -MessageData $msgData | Out-Null
    Register-ObjectEvent -InputObject $wD -EventName "Changed" -Action $acaoDecisoes -MessageData $msgData | Out-Null
    [void]$watchers.Add($wD)

    # --- Watcher B: VEREDITOS_*.json -- executar_vereditos.ps1 automaticamente ---
    $wV = New-Object System.IO.FileSystemWatcher
    $wV.Path              = $pasta
    $wV.Filter            = "VEREDITOS_*.json"
    $wV.NotifyFilter      = [System.IO.NotifyFilters]::FileName -bor [System.IO.NotifyFilters]::LastWrite
    $wV.EnableRaisingEvents = $true

    $acaoVereditos = {
        $arquivo  = $Event.SourceEventArgs.FullPath
        $projNome = $Event.MessageData.Projeto
        $basePath = $Event.MessageData.Base
        $logPath  = $Event.MessageData.Log
        $ts       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        Add-Content -Path $logPath -Value "[$ts] [VEREDITOS] Detectado: $arquivo" -Encoding UTF8
        Add-Content -Path $logPath -Value "[$ts] [VEREDITOS] Executando pipeline para $projNome..." -Encoding UTF8

        $executar = "$basePath\scripts\executar_vereditos.ps1"
        if (Test-Path $executar) {
            Start-Process powershell -ArgumentList "-NonInteractive -File `"$executar`" -projeto $projNome" -WindowStyle Hidden -Wait
            Add-Content -Path $logPath -Value "[$ts] [VEREDITOS] Pipeline concluido para $projNome" -Encoding UTF8
        } else {
            Add-Content -Path $logPath -Value "[$ts] [VEREDITOS] executar_vereditos.ps1 nao encontrado" -Encoding UTF8
        }
    }

    Register-ObjectEvent -InputObject $wV -EventName "Created" -Action $acaoVereditos -MessageData $msgData | Out-Null
    Register-ObjectEvent -InputObject $wV -EventName "Changed" -Action $acaoVereditos -MessageData $msgData | Out-Null
    [void]$watchers.Add($wV)

    Write-Log "[WATCHER] [$proj] Monitorando DECISOES_*.json e VEREDITOS_*.json"
}

Write-Log "[WATCHER] Pipeline ativo para $($projetos.Count) projeto(s). Aguardando eventos..."

# --- Manter watcher vivo ---
try {
    while ($true) {
        Start-Sleep -Seconds 5
    }
} finally {
    foreach ($w in $watchers) {
        $w.EnableRaisingEvents = $false
        $w.Dispose()
    }
    Write-Log "[WATCHER] Encerrado."
}
