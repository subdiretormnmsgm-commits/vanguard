# ============================================================
# WATCH_READONLY.PS1 -- Monitor de integridade arquivos R-01
# Pentalateral IAH -- ATO 6 - Loop 33 - 2026-06-11
#
# Comportamento:
#   - Calcula SHA-256 dos 7 arquivos canonicos R-01 ao iniciar
#   - Loop a cada $intervalSeconds: compara hash atual vs. snapshot
#   - Modificado ou deletado -> notify_hermes -status ALERTA/CRITICO
#
# Iniciado por .claude/hooks/session_start.ps1
# Encerrado por scripts/session_close.ps1 via PID file
# PID: scripts/.watch_readonly.pid
# Log: scripts/.watch_readonly.log
# ============================================================

param(
    [int]$intervalSeconds = 30
)

$BASE         = Split-Path -Parent $PSScriptRoot
$pidPath      = Join-Path $BASE "scripts\.watch_readonly.pid"
$logPath      = Join-Path $BASE "scripts\.watch_readonly.log"
$notifyScript = Join-Path $BASE "scripts\notify_hermes.ps1"
$enc          = [System.Text.UTF8Encoding]::new($false)

# Salvar PID proprio
[System.IO.File]::WriteAllText($pidPath, "$PID", $enc)

function Write-WatchLog {
    param([string]$msg)
    $ts    = (Get-Date).ToString("HH:mm:ss")
    $linha = "[$ts] $msg"
    try {
        $linhas = if (Test-Path $logPath) {
            ([System.IO.File]::ReadAllText($logPath, [System.Text.Encoding]::UTF8)).Split("`n") | Where-Object { $_ -ne "" }
        } else { @() }
        if ($linhas.Count -gt 190) { $linhas = $linhas[-190..-1] }
        $novo = ($linhas + $linha) -join "`n"
        [System.IO.File]::WriteAllText($logPath, $novo + "`n", $enc)
    } catch {}
}

function Get-FileHash256 {
    param([string]$path)
    try {
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $sha   = [System.Security.Cryptography.SHA256]::Create()
        $hash  = $sha.ComputeHash($bytes)
        return [BitConverter]::ToString($hash).Replace("-","")
    } catch { return "ERROR" }
}

function Notify {
    param([string]$statusLevel, [string]$msg)
    if (Test-Path $notifyScript) {
        & powershell.exe -NonInteractive -File $notifyScript `
            -status $statusLevel -mensagem $msg -projeto VANGUARD 2>$null
    }
}

# Arquivos R-01 canonicos a monitorar (subconjunto critico)
$R01_FILES = @(
    "INTELLIGENCE_LEDGER.md",
    "PENDENTES.md",
    "WIP_BOARD.json",
    "DEPENDENCY_MAP.json",
    "CLAUDE.md",
    "GEMINI.md",
    "AGENTS.md"
) | ForEach-Object { Join-Path $BASE $_ }

# Snapshot inicial
$snapshot = @{}
foreach ($f in $R01_FILES) {
    if (Test-Path $f) {
        $snapshot[$f] = Get-FileHash256 -path $f
    }
}

Write-WatchLog "INICIADO -- $($snapshot.Count) arquivos R-01 sob vigilancia. PID=$PID interval=${intervalSeconds}s"

# Loop principal
while ($true) {
    Start-Sleep -Seconds $intervalSeconds

    foreach ($f in $R01_FILES) {
        $nome = [System.IO.Path]::GetFileName($f)

        if (-not (Test-Path $f)) {
            if ($snapshot.ContainsKey($f)) {
                $msg = "ARQUIVO R-01 DELETADO: $nome"
                Write-WatchLog "!! CRITICO: $msg"
                Notify -statusLevel "CRITICO" -msg $msg
                $snapshot.Remove($f)
            }
            continue
        }

        $hashAtual = Get-FileHash256 -path $f
        $hashOld   = if ($snapshot.ContainsKey($f)) { $snapshot[$f] } else { "" }

        if ($hashOld -ne "" -and $hashAtual -ne $hashOld) {
            $msg = "ARQUIVO R-01 MODIFICADO: $nome"
            Write-WatchLog "ALERTA: $msg (hash mudou)"
            Notify -statusLevel "ALERTA" -msg $msg
            $snapshot[$f] = $hashAtual
        }
    }
}
