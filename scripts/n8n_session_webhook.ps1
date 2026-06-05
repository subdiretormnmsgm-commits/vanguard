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

$gitSha     = (git -C $BASE rev-parse --short HEAD 2>$null) -replace "`n",""
$gitBranch  = (git -C $BASE rev-parse --abbrev-ref HEAD 2>$null) -replace "`n",""
$gitMsg     = (git -C $BASE log -1 --format="%s" 2>$null) -replace "`n",""
$gitCount   = (git -C $BASE rev-list --count HEAD 2>$null) -replace "`n",""

$dataWh = if ($Data) { $Data } else { (Get-Date -Format "yyyy-MM-dd") }
$contextoExiste = Test-Path "$BASE\PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataWh.md"
$artefatoExiste = Test-Path "$BASE\RELATORIOS_EMBAIXADOR\ARTEFATO_EMBAIXADOR_OPERACIONAL_$dataWh.md"

$payload = @{
    cliente    = $Cliente
    data       = $dataWh
    hora       = if ($Hora) { $Hora } else { (Get-Date -Format "HH:mm") }
    principios = if ($Principio) { @($Principio) } else { @() }
    friccoes   = if ($Friccao)   { @($Friccao) }   else { @() }
    dividas    = if ($Divida)    { @($Divida) }     else { @() }
    git        = @{
        sha           = $gitSha
        branch        = $gitBranch
        mensagem      = $gitMsg
        total_commits = $gitCount
    }
    embaixador_operacional = @{
        contexto_sessao_gerado  = $contextoExiste
        artefato_abertura_gerado = $artefatoExiste
        arquivos_arrastar       = @(
            "PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataWh.md",
            "PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_$dataWh.md"
        )
        projeto_claude          = "Vanguard - Embaixador Operacional"
    }
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
