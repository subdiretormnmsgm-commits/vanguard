#Requires -Version 5.1
# ping_hermes.ps1 -- Verifica uptime do Hermes Agent no EasyPanel
# Uso:
#   .\scripts\ping_hermes.ps1                  -- check simples, output visual
#   .\scripts\ping_hermes.ps1 -Silencioso      -- JSON para n8n/automacao
#   .\scripts\ping_hermes.ps1 -Telegram        -- envia resultado ao Telegram
# Retorna: exit 0 (UP) | exit 1 (DOWN) | exit 2 (config ausente)

param(
    [switch]$Silencioso,
    [switch]$Telegram
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$BASE = Split-Path -Parent $PSScriptRoot

# --- Config ---
$credFile = Join-Path $BASE "N8N Easypanel.txt"
$hermesUrl = $env:HERMES_AGENT_URL
$telegramBotToken = $env:TELEGRAM_BOT_TOKEN
$telegramChatId   = $env:TELEGRAM_CHAT_ID_DIRETOR

if ([string]::IsNullOrWhiteSpace($hermesUrl) -and (Test-Path $credFile)) {
    $credContent = Get-Content $credFile -Raw
    if ($credContent -match "HERMES_AGENT_URL[=:\s]+([^\r\n]+)") {
        $hermesUrl = $matches[1].Trim()
    }
    if ($credContent -match "TELEGRAM_BOT_TOKEN[=:\s]+([^\r\n]+)") {
        $telegramBotToken = $matches[1].Trim()
    }
    if ($credContent -match "TELEGRAM_CHAT_ID_DIRETOR[=:\s]+([^\r\n]+)") {
        $telegramChatId = $matches[1].Trim()
    }
}

if ([string]::IsNullOrWhiteSpace($hermesUrl)) {
    if (-not $Silencioso) {
        Write-Host "[ping_hermes] HERMES_AGENT_URL nao configurada." -ForegroundColor Yellow
        Write-Host "  Definir via: `$env:HERMES_AGENT_URL = 'https://hermes.seudominio.easypanel.host'" -ForegroundColor DarkGray
        Write-Host "  Ou adicionar ao N8N Easypanel.txt (gitignored)" -ForegroundColor DarkGray
    }
    if ($Silencioso) {
        @{ status = "CONFIG_AUSENTE"; url = ""; timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm") } | ConvertTo-Json
    }
    exit 2
}

# --- Endpoint de saude ---
$healthUrl = $hermesUrl.TrimEnd("/") + "/health"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$status    = "DOWN"
$latencia  = -1
$detalhe   = ""

try {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $resp = Invoke-WebRequest -Uri $healthUrl -Method GET -TimeoutSec 5 -ErrorAction Stop -UseBasicParsing
    $sw.Stop()
    $latencia = $sw.ElapsedMilliseconds

    if ($resp.StatusCode -in @(200, 204)) {
        $status  = "UP"
        $detalhe = "HTTP $($resp.StatusCode) em ${latencia}ms"
    } else {
        $status  = "DEGRADADO"
        $detalhe = "HTTP $($resp.StatusCode) em ${latencia}ms"
    }
} catch {
    $detalhe = $_.Exception.Message -replace "`r?`n", " "
    if ($detalhe.Length -gt 120) { $detalhe = $detalhe.Substring(0,120) + "..." }
}

# --- Output ---
if ($Silencioso) {
    @{
        status    = $status
        url       = $healthUrl
        latencia_ms = $latencia
        detalhe   = $detalhe
        timestamp = $timestamp
    } | ConvertTo-Json
} else {
    $cor = if ($status -eq "UP") { "Green" } elseif ($status -eq "DEGRADADO") { "Yellow" } else { "Red" }
    Write-Host ""
    Write-Host "================================================"
    Write-Host "  HERMES AGENT -- PING -- $timestamp"
    Write-Host "================================================"
    Write-Host "  Status : $status" -ForegroundColor $cor
    Write-Host "  URL    : $healthUrl"
    if ($latencia -ge 0) { Write-Host "  Latencia: ${latencia}ms" }
    if ($detalhe) { Write-Host "  Detalhe: $detalhe" -ForegroundColor DarkGray }
    Write-Host ""

    if ($status -eq "DOWN") {
        Write-Host "  FALLBACK (P-110):" -ForegroundColor Yellow
        Write-Host "    1. EasyPanel -> servico hermes-agent -> Restart" -ForegroundColor DarkGray
        Write-Host "    2. n8n W-1/W-5 assumem notificacoes automaticamente" -ForegroundColor DarkGray
        Write-Host "    3. session_start opera em modo manual (comportamento pre-V28)" -ForegroundColor DarkGray
    }
}

# --- Telegram ---
if ($Telegram -and (-not [string]::IsNullOrWhiteSpace($telegramBotToken)) -and (-not [string]::IsNullOrWhiteSpace($telegramChatId))) {
    $icone   = if ($status -eq "UP") { "[OK]" } elseif ($status -eq "DEGRADADO") { "[!]" } else { "[X]" }
    $msg     = "HERMES AGENT $icone $status`n$healthUrl`n$detalhe`n$timestamp"
    $tgUrl   = "https://api.telegram.org/bot$telegramBotToken/sendMessage"
    $body    = @{ chat_id = $telegramChatId; text = $msg } | ConvertTo-Json
    try {
        Invoke-RestMethod -Uri $tgUrl -Method POST -Body $body -ContentType "application/json; charset=utf-8" -ErrorAction Stop | Out-Null
    } catch {
        Write-Host "  [ping_hermes] Telegram: falha ao enviar -- $_" -ForegroundColor DarkGray
    }
}

exit $(if ($status -eq "UP") { 0 } elseif ($status -eq "DEGRADADO") { 0 } else { 1 })
