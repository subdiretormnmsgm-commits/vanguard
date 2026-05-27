#Requires -Version 5.1
# skill_watcher.ps1 -- Monitoramento automatico da pasta NOTEBOOKLM_DROP (OSV-003)
# Detecta Skill salva pelo Diretor -> valida com skill_parser_gate.ps1 -> instala em .claude/skills/
# Iniciado pelo session_start.ps1 como processo background.
# Uso: .\scripts\skill_watcher.ps1 -cliente INGRID
# Unico passo manual do Diretor: salvar o .md na pasta NOTEBOOKLM_DROP.

param(
    [Parameter(Mandatory=$true)]
    [string]$cliente
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE       = Split-Path -Parent $PSScriptRoot
$LOG        = "$BASE\scripts\skill_watcher.log"
$clienteUp  = $cliente.ToUpper()
$pastaDrop  = "$BASE\CLIENTES\$clienteUp\NOTEBOOKLM_DROP"
$skillsDir  = "$BASE\.claude\skills"
$parserGate = "$BASE\scripts\skill_parser_gate.ps1"

. "$BASE\scripts\send_telegram_helper.ps1"

function Write-Log {
    param([string]$msg)
    $ts   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts] [SKILL_WATCHER] [$clienteUp] $msg"
    Add-Content -Path $LOG -Value $line -Encoding UTF8
    Write-Host $line
}

if (-not (Test-Path $pastaDrop)) {
    New-Item -ItemType Directory -Path $pastaDrop -Force | Out-Null
    Write-Log "Pasta DROP criada: $pastaDrop"
}

if (-not (Test-Path $skillsDir)) {
    Write-Log "ERRO: .claude\skills nao encontrado -- verificar estrutura do repositorio"
    exit 1
}

Write-Log "Iniciando -- monitorando $pastaDrop para arquivos .md"

$msgData = [PSCustomObject]@{
    Cliente    = $clienteUp
    Base       = $BASE
    SkillsDir  = $skillsDir
    ParserGate = $parserGate
    Log        = $LOG
}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path              = $pastaDrop
$watcher.Filter            = "*.md"
$watcher.NotifyFilter      = [System.IO.NotifyFilters]::FileName -bor [System.IO.NotifyFilters]::LastWrite
$watcher.EnableRaisingEvents = $true

$acaoSkill = {
    $arquivo  = $Event.SourceEventArgs.FullPath
    $nome     = $Event.SourceEventArgs.Name
    $cli      = $Event.MessageData.Cliente
    $basePath = $Event.MessageData.Base
    $skills   = $Event.MessageData.SkillsDir
    $parser   = $Event.MessageData.ParserGate
    $logPath  = $Event.MessageData.Log
    $ts       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Add-Content -Path $logPath -Value "[$ts] [SKILL_WATCHER] [$cli] Skill detectada: $nome" -Encoding UTF8

    # Aguardar arquivo terminar de ser escrito
    Start-Sleep -Seconds 3

    if (-not (Test-Path $arquivo)) {
        Add-Content -Path $logPath -Value "[$ts] [SKILL_WATCHER] [$cli] Arquivo desapareceu antes da validacao -- ignorado" -Encoding UTF8
        return
    }

    # Validar com skill_parser_gate.ps1
    if (-not (Test-Path $parser)) {
        Add-Content -Path $logPath -Value "[$ts] [SKILL_WATCHER] [$cli] skill_parser_gate.ps1 nao encontrado" -Encoding UTF8
        return
    }

    $null = & powershell -NonInteractive -File $parser -skill $arquivo 2>&1
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        # Detectar versao pelo nome do arquivo (ex: ingrid-v6.md -> v6)
        $versao = "N"
        if ($nome -match "-v(\d+)") { $versao = $Matches[1] }
        elseif ($nome -match "v(\d+)") { $versao = $Matches[1] }

        $nomeDestino = "$($cli.ToLower())-v$versao.md"
        $destino     = "$skills\$nomeDestino"

        $bytes = [System.IO.File]::ReadAllBytes($arquivo)
        [System.IO.File]::WriteAllBytes($destino, $bytes)

        $msg = "Skill aprovada e instalada: $destino"
        Add-Content -Path $logPath -Value "[$ts] [SKILL_WATCHER] [$cli] $msg" -Encoding UTF8

        . "$basePath\scripts\send_telegram_helper.ps1"
        Send-Telegram "[SKILL_WATCHER] $cli -- Skill $nomeDestino instalada automaticamente. Gate P-067: acionar Embaixador antes de deliberar." | Out-Null

        # Limpar pasta DROP apos instalacao
        Remove-Item $arquivo -Force -ErrorAction SilentlyContinue
        Add-Content -Path $logPath -Value "[$ts] [SKILL_WATCHER] [$cli] Arquivo removido do DROP apos instalacao" -Encoding UTF8

        # P-077: Atualizar WIP_BOARD loop_fase_atual.notebooklm = "OK"
        try {
            $wipBoardPath = Join-Path $basePath "CLIENTES\WIP_BOARD.json"
            if (Test-Path $wipBoardPath) {
                $boardData = Get-Content $wipBoardPath -Raw -Encoding UTF8 | ConvertFrom-Json
                foreach ($projEntry in @($boardData.board.build)) {
                    if ($projEntry.cliente -eq $cli) {
                        if ($projEntry.loop_fase_atual) {
                            $projEntry.loop_fase_atual.notebooklm = "OK"
                            $projEntry.loop_fase_atual.proximo = "Embaixador -- PASSO7 com [N-1 a N-5] + [G-1 a G-5]"
                        }
                        break
                    }
                }
                $boardData.atualizado_em = (Get-Date -Format "yyyy-MM-dd")
                $jsonOut = $boardData | ConvertTo-Json -Depth 20
                [System.IO.File]::WriteAllText($wipBoardPath, $jsonOut, [System.Text.Encoding]::UTF8)
                Add-Content -Path $logPath -Value "[$ts] [SKILL_WATCHER] [$cli] WIP_BOARD: loop_fase_atual.notebooklm = OK" -Encoding UTF8
            }
        } catch {
            Add-Content -Path $logPath -Value "[$ts] [SKILL_WATCHER] [$cli] AVISO: falha ao atualizar WIP_BOARD: $_" -Encoding UTF8
        }

    } else {
        $msg = "Skill REJEITADA pelo gate (exit $exitCode) -- verificar criterios"
        Add-Content -Path $logPath -Value "[$ts] [SKILL_WATCHER] [$cli] $msg" -Encoding UTF8

        . "$basePath\scripts\send_telegram_helper.ps1"
        Send-Telegram "[SKILL_WATCHER] REJEICAO -- $cli -- $nome rejeitada pelo skill_parser_gate. Retornar ao NotebookLM e aplicar Gatilho de Calibracao." | Out-Null
    }
}

Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action $acaoSkill -MessageData $msgData | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $acaoSkill -MessageData $msgData | Out-Null

Write-Log "Watcher ativo. Salve a Skill em: $pastaDrop"

try {
    while ($true) { Start-Sleep -Seconds 5 }
} finally {
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    Write-Log "Watcher encerrado."
}
