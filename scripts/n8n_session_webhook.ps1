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

# Extrair pendentes abertos do PENDENTES.md (itens [ ] nao concluidos)
$pendentesAbertos = @()
$pendentesPath = Join-Path $BASE "PENDENTES.md"
if (Test-Path $pendentesPath) {
    $linhasPend = Get-Content $pendentesPath -Encoding UTF8
    foreach ($linha in $linhasPend) {
        if ($linha -match '^\- \[ \]') {
            # Extrair titulo em negrito
            $titulo = $linha -replace '^\- \[ \] `[^`]+` \*\*(.+?)\*\*.*', '$1'
            if ($titulo -eq $linha) { $titulo = ($linha -replace '^\- \[ \] ', '').Trim() }
            $projeto = if ($linha -match '\[musculo\]') { '[musculo]' } elseif ($linha -match '\[diretor\]') { '[diretor]' } else { '' }
            $pendentesAbertos += ($titulo.Trim() + if ($projeto) { ' ' + $projeto } else { '' })
        }
    }
}

# Extrair titulos de principios novos hoje do INTELLIGENCE_LEDGER.md
$principiosTitulos = @()
if ($Principio) { $principiosTitulos = @($Principio) }
else {
    $ledgerPath = Join-Path $BASE "INTELLIGENCE_LEDGER.md"
    if (Test-Path $ledgerPath) {
        $hoje = Get-Date -Format "yyyy-MM-dd"
        $linhasLedger = Get-Content $ledgerPath -Encoding UTF8
        foreach ($linha in $linhasLedger) {
            if ($linha -match "^## (P-\d+)[^(]*\($hoje\)") {
                $principiosTitulos += $Matches[1] + ' — ' + ($linha -replace '^## P-\d+ -- ', '' -replace "^## P-\d+ — ", '' -replace " \($hoje\)", '')
            }
        }
    }
}

$payload = @{
    cliente          = $Cliente
    data             = $dataWh
    hora             = if ($Hora) { $Hora } else { (Get-Date -Format "HH:mm") }
    principios       = $principiosTitulos
    friccoes         = if ($Friccao)   { @($Friccao) }   else { @() }
    dividas          = if ($Divida)    { @($Divida) }     else { @() }
    pendentes_abertos = $pendentesAbertos
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

# Carregar secret do CHAVES_SISTEMA_VANGUARD.txt (P-073 -- credencial fora do codigo)
$chavesPath = Join-Path $BASE "CHAVES_SISTEMA_VANGUARD.txt"
$webhookSecret = ""
if (Test-Path $chavesPath) {
    $linhaSecret = Get-Content $chavesPath -Encoding UTF8 | Where-Object { $_ -match "^N8N_WEBHOOK_SECRET\s*=" }
    if ($linhaSecret) {
        $webhookSecret = ($linhaSecret -split "=", 2)[1].Trim()
    }
}

# Fire-and-forget via Start-Job -- nao bloqueia o terminal (N-3)
$jobUrl    = $N8N_SESSION_CLOSE_URL
$jobBody   = $json
$jobSecret = $webhookSecret
Start-Job -ScriptBlock {
    param($url, $body, $secret)
    try {
        $hdrs = @{ "Content-Type" = "application/json" }
        if ($secret) { $hdrs["X-Webhook-Secret"] = $secret }
        Invoke-RestMethod -Uri $url -Method POST -Body $body -Headers $hdrs -TimeoutSec 5 | Out-Null
    } catch {
        # silencio intencional -- fire-and-forget nao reporta falha ao terminal
    }
} -ArgumentList $jobUrl, $jobBody, $jobSecret | Out-Null

Write-Host "  [n8n_webhook] Webhook disparado (fire-and-forget) -- N-3 OK" -ForegroundColor DarkGray
exit 0
