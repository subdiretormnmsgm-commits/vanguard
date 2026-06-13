# niche_alert_router.ps1
# Le PENDING_REVIEW.md, extrai alertas [ALERTA NICHE] e roteia via Telegram (n8n W-8)
# Uso: .\scripts\niche_alert_router.ps1
# Executado automaticamente pelo Musculo apos processar output do NICHE_MODELER

param(
    [switch]$dryRun  # Se -dryRun: mostra alertas sem enviar Telegram
)

$pendingFile = "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PENDING_REVIEW.md"
$pendentesFile = "PENDENTES.md"
$logFile = "scripts\logs\niche_alert_router_log.txt"
$n8nWebhookFile = "scripts\N8N_WEBHOOK_URL.txt"

if (-not (Test-Path $pendingFile)) {
    Write-Host "[ERRO] PENDING_REVIEW.md nao encontrado." -ForegroundColor Red
    exit 1
}

# Criar pasta de logs se nao existir
$logDir = Split-Path $logFile
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
}

$content = Get-Content $pendingFile -Raw -Encoding UTF8
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

Write-Host ""
Write-Host "=== NICHE ALERT ROUTER - $timestamp ===" -ForegroundColor Cyan

# Extrair blocos [ALERTA NICHE]
$alertPattern = '\[ALERTA NICHE\].*?(?=\[ALERTA NICHE\]|$)'
$alertMatches = [regex]::Matches($content, $alertPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

if ($alertMatches.Count -eq 0) {
    Write-Host "[OK] Nenhum [ALERTA NICHE] encontrado em PENDING_REVIEW.md" -ForegroundColor Green
    "[OK] $timestamp - Sem alertas" | Out-File $logFile -Append -Encoding UTF8
    exit 0
}

Write-Host "$($alertMatches.Count) alerta(s) detectado(s):" -ForegroundColor Yellow
Write-Host ""

$alertsForTelegram = @()

foreach ($match in $alertMatches) {
    $alertText = $match.Value.Trim()

    # Extrair campos do alerta
    $nichoLine = ($alertText -split "`n")[0]
    $urgenciaLine = ($alertText | Select-String -Pattern "Urgencia: (.+)").Matches.Groups[1].Value
    $gatilhoLine = ($alertText | Select-String -Pattern "Gatilho: (.+)").Matches.Groups[1].Value
    $prazoLine = ($alertText | Select-String -Pattern "Prazo: (.+)").Matches.Groups[1].Value
    $acaoLine = ($alertText | Select-String -Pattern "Acao imediata: (.+)").Matches.Groups[1].Value

    Write-Host "  $nichoLine" -ForegroundColor Red
    Write-Host "  Urgencia: $urgenciaLine" -ForegroundColor Yellow
    Write-Host "  Prazo: $prazoLine" -ForegroundColor White
    Write-Host "  Acao: $acaoLine" -ForegroundColor Cyan
    Write-Host ""

    # Formatar mensagem Telegram
    $telegramMsg = "[NICHE ALERT] $nichoLine`nUrgencia: $urgenciaLine`nPrazo: $prazoLine`nAcao: $acaoLine"
    $alertsForTelegram += $telegramMsg

    # Adicionar em PENDENTES.md como [diretor] com prazo
    if (-not $dryRun -and (Test-Path $pendentesFile)) {
        $pendentesContent = Get-Content $pendentesFile -Raw -Encoding UTF8
        $novaLinha = "- [ ] [diretor] [ALERTA NICHO] $nichoLine — Prazo: $prazoLine"

        if (-not ($pendentesContent -match [regex]::Escape($nichoLine.Substring(0, [Math]::Min(30, $nichoLine.Length))))) {
            # Adicionar ao PENDENTES se nao existe ainda
            $pendentesContent = $pendentesContent -replace "(## PENDENTES DO DIRETOR)", "`$1`n$novaLinha"
            $pendentesContent | Out-File $pendentesFile -Encoding UTF8 -NoNewline
            Write-Host "  [PENDENTES] Adicionado: $novaLinha" -ForegroundColor DarkGray
        }
    }
}

# Enviar para Telegram via n8n W-8
if (-not $dryRun) {
    if (Test-Path $n8nWebhookFile) {
        $webhookUrl = (Get-Content $n8nWebhookFile -Raw).Trim()

        foreach ($msg in $alertsForTelegram) {
            try {
                $body = @{ message = $msg; source = "niche_alert_router"; type = "INFORMAR" } | ConvertTo-Json
                Invoke-RestMethod -Uri $webhookUrl -Method POST -Body $body -ContentType "application/json" | Out-Null
                Write-Host "  [TELEGRAM] Enviado via n8n W-8" -ForegroundColor Green
            } catch {
                Write-Host "  [AVISO] Falha ao enviar Telegram: $($_.Exception.Message)" -ForegroundColor Yellow
                Write-Host "  [AVISO] Alertas registrados em PENDENTES.md como fallback" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "  [AVISO] N8N_WEBHOOK_URL.txt nao encontrado." -ForegroundColor Yellow
        Write-Host "  [AVISO] Crie scripts\N8N_WEBHOOK_URL.txt com a URL do webhook W-8." -ForegroundColor Yellow
        Write-Host "  [AVISO] Alertas registrados apenas em PENDENTES.md." -ForegroundColor Yellow
    }
} else {
    Write-Host "[DRY RUN] Alertas detectados — nao enviados (use sem -dryRun para enviar)" -ForegroundColor DarkGray
}

# Log
"$timestamp - $($alertMatches.Count) alerta(s) processados - dryRun=$dryRun" | Out-File $logFile -Append -Encoding UTF8

Write-Host ""
Write-Host "Alertas processados: $($alertMatches.Count)" -ForegroundColor Cyan
Write-Host "Proximo passo: revisar PENDENTES.md e aprovar acoes." -ForegroundColor DarkGray
