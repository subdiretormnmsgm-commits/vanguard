# ============================================================
# LEMBRETE_TARDE.PS1 — Check-in da tarde do Diretor (13h)
# Envia via Telegram: gates pendentes + ações da tarde + alertas
# Agendado por registrar_briefing_agendado.ps1 para 13h diário
# ============================================================

$ErrorActionPreference = "Stop"

$BASE = Split-Path -Parent $PSScriptRoot
. "$BASE\scripts\alert_config.ps1"

trap {
    $ts     = (Get-Date).ToString("dd/MM HH:mm")
    $errMsg = "FALHA -- Pentalateral Tarde ${ts}: $($_.Exception.Message)"
    try {
        Invoke-RestMethod -Uri ("https://api.telegram.org/bot" + $TELEGRAM_TOKEN + "/sendMessage") -Method POST -Body @{
            chat_id = $TELEGRAM_CHAT_ID
            text    = $errMsg
        } | Out-Null
    } catch {}
    break
}

$hoje    = Get-Date
$dataStr = $hoje.ToString("yyyy-MM-dd")
$hora    = $hoje.ToString("HH:mm")

$wipPath  = "$BASE\CLIENTES\WIP_BOARD.json"
$wip      = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$projetos = $wip.board.build

$linhas          = @()
$gatesPendentes  = @()
$alertasCriticos = @()

$linhas += "CHECK-IN DA TARDE — $hora"
$linhas += "Pentalateral IAH · $dataStr"
$linhas += ""

foreach ($proj in $projetos) {
    $cliente  = $proj.cliente
    $projId   = $proj.id
    $status   = $proj.status
    $proximo  = $proj.proximo_passo
    $deadline = $proj.deadline

    # Lê MEMORIA_EMBAIXADOR
    $memoriaPath = "$BASE\CLIENTES\$($cliente.ToUpper())\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
    $temperatura  = $null
    $diasSemContato = $null
    $ultimoContato  = $null

    if (Test-Path $memoriaPath) {
        $memoria = Get-Content $memoriaPath -Raw -Encoding UTF8
        if ($memoria -match "Status atual:\s*(VERDE|AMARELO|VERMELHO)") {
            $temperatura = $matches[1]
        }
        if ($memoria -match "Último contato[^\n]*(\d{4}-\d{2}-\d{2})") {
            $ultimoContato  = [datetime]$matches[1]
            $diasSemContato = ($hoje - $ultimoContato).Days
        }
        if ($memoria -match "Termo[^\n]*(PENDENTE)") {
            $alertasCriticos += "[$cliente] Termo ainda PENDENTE — P-023 ativo"
        }
    }

    $icone = switch ($temperatura) {
        "VERDE"    { "🟢" }
        "AMARELO"  { "🟡" }
        "VERMELHO" { "🔴" }
        default    { "⚪" }
    }

    $linhas += "$icone $projId — $cliente"

    if ($diasSemContato -ne $null -and $diasSemContato -ge 2) {
        $linhas += "  ⏱ $diasSemContato dias sem contato"
        if ($diasSemContato -ge 3) {
            $alertasCriticos += "[$cliente] $diasSemContato dias sem contato — reagir hoje"
        }
    }

    if ($deadline) {
        try {
            $dias = ([datetime]$deadline - $hoje).Days
            $urgencia = if ($dias -le 1) { "🔴" } elseif ($dias -le 3) { "🟡" } else { "🟢" }
            $linhas += "  $urgencia Deadline: $deadline ($dias dias)"
            if ($dias -le 1) {
                $alertasCriticos += "[$cliente] DEADLINE AMANHÃ — verificar entrega"
            }
        } catch {}
    }

    if ($proximo) {
        $linhas += "  → $proximo"
        $gatesPendentes += "[$cliente] $proximo"
    }

    $linhas += ""
}

# ── Alertas críticos
if ($alertasCriticos.Count -gt 0) {
    $linhas += "🔴 ALERTAS:"
    foreach ($a in $alertasCriticos) { $linhas += "  • $a" }
    $linhas += ""
}

# ── Gates pendentes para a tarde
if ($gatesPendentes.Count -gt 0) {
    $linhas += "GATES PENDENTES:"
    foreach ($g in $gatesPendentes) { $linhas += "  • $g" }
    $linhas += ""
}

$linhas += "— Músculo · Pentalateral IAH"

$corpo = $linhas -join "`n"

# ── Envia ao Telegram
$url = "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage"
try {
    Invoke-RestMethod -Uri $url -Method POST -Body @{
        chat_id = $TELEGRAM_CHAT_ID
        text    = $corpo
    } | Out-Null
    Write-Host "Check-in da tarde enviado ao Telegram" -ForegroundColor Cyan
} catch {
    Write-Host "ERRO Telegram tarde: $($_.Exception.Message)" -ForegroundColor Red
}

# ── Envia por e-mail (canal remoto -- recebido no celular sem app aberto)
$assuntoTarde = 'Pentalateral IAH -- Check-in Tarde ' + (Get-Date -Format 'dd/MM HH:mm')
try {
    $smtp = New-Object Net.Mail.SmtpClient('smtp.gmail.com', 587)
    $smtp.EnableSsl    = $true
    $smtp.Credentials = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)
    $msg              = New-Object Net.Mail.MailMessage
    $msg.From         = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject      = $assuntoTarde
    $view = [System.Net.Mail.AlternateView]::CreateAlternateViewFromString($corpo, [System.Text.Encoding]::UTF8, 'text/plain')
    $view.TransferEncoding = [System.Net.Mime.TransferEncoding]::QuotedPrintable
    $msg.AlternateViews.Add($view)
    $smtp.Send($msg)
    Write-Host "E-mail tarde enviado para $ALERT_TO" -ForegroundColor Green
} catch {
    Write-Host "ERRO e-mail tarde: $($_.Exception.Message)" -ForegroundColor Red
}
