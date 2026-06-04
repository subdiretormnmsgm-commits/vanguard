# n8n_session_webhook.ps1 -- dispara webhook do session_close para o n8n
# N-3: fire-and-forget -- nao bloqueia o terminal
# Chamado pelo wrapper session_close.ps1 APOS todos os gates passarem
# Criado: 2026-06-04 | Pentalateral IAH
# P-102: coexistencia -- nao substitui nenhum processo existente

param(
    [string]$Cliente   = "",
    [string]$Principio = "",
    [string]$Friccao   = "",
    [string]$Divida    = "",
    [string]$Data      = "",
    [string]$Hora      = "",
    [switch]$DryRun
)

$BASE = Split-Path $PSScriptRoot -Parent
$configPath = Join-Path $PSScriptRoot "n8n_config.ps1"

if (-not (Test-Path $configPath)) {
    Write-Host "  [n8n_webhook] n8n_config.ps1 nao encontrado -- webhook ignorado (sem impacto)" -ForegroundColor DarkGray
    exit 0
}

. $configPath

if ([string]::IsNullOrWhiteSpace($N8N_SESSION_CLOSE_URL)) {
    Write-Host "  [n8n_webhook] N8N_SESSION_CLOSE_URL nao configurado -- ignorado" -ForegroundColor DarkGray
    exit 0
}

$payload = @{
    cliente   = $Cliente
    data      = if ($Data) { $Data } else { (Get-Date -Format "yyyy-MM-dd") }
    hora      = if ($Hora) { $Hora } else { (Get-Date -Format "HH:mm") }
    principios = if ($Principio) { @($Principio) } else { @() }
    friccoes  = if ($Friccao)   { @($Friccao) }   else { @() }
    dividas   = if ($Divida)    { @($Divida) }     else { @() }
}

$json = $payload | ConvertTo-Json -Depth 5

if ($DryRun) {
    Write-Host "  [DRYRUN] n8n_webhook -- URL: $N8N_SESSION_CLOSE_URL" -ForegroundColor DarkCyan
    Write-Host "  [DRYRUN] Payload: $json" -ForegroundColor DarkCyan
    exit 0
}

# Fire-and-forget via Start-Job -- nao bloqueia o terminal (N-3)
$jobUrl  = $N8N_SESSION_CLOSE_URL
$jobBody = $json
Start-Job -ScriptBlock {
    param($url, $body)
    try {
        Invoke-RestMethod -Uri $url -Method POST -Body $body -ContentType "application/json" -TimeoutSec 5 | Out-Null
    } catch {
        # silencio intencional -- fire-and-forget nao reporta falha ao terminal
    }
} -ArgumentList $jobUrl, $jobBody | Out-Null

Write-Host "  [n8n_webhook] Webhook disparado (fire-and-forget) -- N-3 OK" -ForegroundColor DarkGray
exit 0
