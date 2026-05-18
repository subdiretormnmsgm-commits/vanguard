# ============================================================
# BRIEFING_DIARIO.PS1 — Briefing matinal do Diretor
# Lê estado real dos projetos ativos e envia briefing completo via Telegram + e-mail
# Agendado para rodar 7h automaticamente (registrar_briefing_agendado.ps1)
# Telegram: entrega garantida mesmo se e-mail falhar (canal primário)
# Uso manual: .\scripts\briefing_diario.ps1
# ============================================================

$BASE = Split-Path -Parent $PSScriptRoot
. "$BASE\scripts\alert_config.ps1"

$hoje      = Get-Date
$dataStr   = $hoje.ToString("yyyy-MM-dd")
$diaSemana = (Get-Culture).DateTimeFormat.GetDayName($hoje.DayOfWeek)
$amanha    = $hoje.AddDays(1).ToString("yyyy-MM-dd")

# ── Lê WIP_BOARD ──────────────────────────────────────────
$wipPath = "$BASE\CLIENTES\WIP_BOARD.json"
$wip     = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$projetos = $wip.board.build

# ── Monta corpo do e-mail ──────────────────────────────────
$linhas = @()
$linhas += "BRIEFING DO DIRETOR — $dataStr ($diaSemana)"
$linhas += "=" * 60
$linhas += ""

$alertasCriticos = @()
$acoesDia        = @()

foreach ($proj in $projetos) {
    $cliente  = $proj.cliente
    $projId   = $proj.id
    $deadline = $proj.deadline
    $status   = $proj.status
    $proximo  = $proj.proximo_passo

    # Lê MEMORIA_EMBAIXADOR se existir
    $memoriaPath = "$BASE\CLIENTES\$($cliente.ToUpper())\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
    $memoriaExiste = Test-Path $memoriaPath
    $ultimoContato = $null
    $diasSemContato = $null
    $temperatura = $null
    $termoStatus = $null

    if ($memoriaExiste) {
        $memoria = Get-Content $memoriaPath -Raw -Encoding UTF8

        # Extrai último contato
        if ($memoria -match "Último contato[^\n]*(\d{4}-\d{2}-\d{2})") {
            $ultimoContato  = [datetime]$matches[1]
            $diasSemContato = ($hoje - $ultimoContato).Days
        }

        # Extrai temperatura
        if ($memoria -match "Status atual:\s*(VERDE|AMARELO|VERMELHO)") {
            $temperatura = $matches[1]
        }

        # Extrai status do Termo
        if ($memoria -match "Termo[^\n]*(PENDENTE|assinado|ASSINADO)") {
            $termoStatus = $matches[1]
        }
    }

    # Calcula dias até deadline
    $diasDeadline = $null
    if ($deadline) {
        try {
            $diasDeadline = ([datetime]$deadline - $hoje).Days
        } catch {}
    }

    # ── Bloco do projeto ──
    $linhas += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    $linhas += "$projId — $cliente"

    if ($temperatura) {
        $icone = switch ($temperatura) {
            "VERDE"    { "🟢" }
            "AMARELO"  { "🟡" }
            "VERMELHO" { "🔴" }
            default    { "⚪" }
        }
        $linhas += "Temperatura: $icone $temperatura"
    }

    if ($diasSemContato -ne $null) {
        $linhas += "Último contato: $($ultimoContato.ToString('yyyy-MM-dd')) — $diasSemContato dias atrás"
    }

    if ($termoStatus -and $termoStatus -ne "assinado" -and $termoStatus -ne "ASSINADO") {
        $linhas += "⚠️  Termo: PENDENTE"
        $alertasCriticos += "[$cliente] Termo não assinado — P-023 bloqueia entrega"
    }

    if ($diasDeadline -ne $null) {
        $urgencia = if ($diasDeadline -le 2) { "🔴" } elseif ($diasDeadline -le 5) { "🟡" } else { "🟢" }
        $linhas += "Deadline: $deadline ($urgencia $diasDeadline dias)"
    }

    $linhas += ""
    $linhas += "STATUS: $status"
    $linhas += ""

    # ── Ações do dia ──
    $linhas += "AÇÕES DE HOJE:"

    # Presencial amanhã (Valdece)
    if ($proj.deadline_anterior -or ($deadline -eq $amanha)) {
        if ($cliente -eq "Valdece" -and $status -match "presencial") {
            $linhas += "  → PRESENCIAL AMANHÃ — Leia MEMORIA_EMBAIXADOR antes de sair"
            $linhas += "  → Leve WATCHDOG_TEMPLATE preenchido"
            $linhas += "  → Ao voltar: preencher protocolo de debrief (7 campos) e relatar ao Embaixador"
            $acoesDia += "Valdece: PRESENCIAL — leia MEMORIA_EMBAIXADOR e prepare o debrief"
        }
    }

    # Dias sem contato → reativar
    if ($diasSemContato -ge 2 -and $temperatura -ne "VERMELHO") {
        $linhas += "  → $diasSemContato dias sem contato — verificar se respondeu / enviar reativação"
        $acoesDia += "$cliente`: $diasSemContato dias sem contato — ação necessária"
    }
    if ($diasSemContato -ge 4) {
        $alertasCriticos += "[$cliente] $diasSemContato dias sem contato — risco VERMELHO se não agir hoje"
    }

    # Domingo = relatório semanal Ingrid
    if ($cliente -eq "Ingrid" -and $hoje.DayOfWeek -eq [System.DayOfWeek]::Sunday) {
        $linhas += "  → GATE FORMAL: Relatório Semanal — copiar métricas do Supabase e enviar WhatsApp"
        $linhas += "  → Script de mensagem: .\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo RELATORIO_SEMANAL"
        $alertasCriticos += "[Ingrid] DOMINGO — relatório semanal obrigatório (E-3 gate formal)"
    }

    # Próximo passo
    if ($proximo) {
        $linhas += ""
        $linhas += "PRÓXIMO PASSO:"
        $linhas += "  $proximo"
    }

    $linhas += ""
}

# ── Resumo de alertas críticos ─────────────────────────────
if ($alertasCriticos.Count -gt 0) {
    $linhas += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    $linhas += "🔴 ALERTAS CRÍTICOS — RESOLVER HOJE"
    foreach ($a in $alertasCriticos) {
        $linhas += "  • $a"
    }
    $linhas += ""
}

# ── Comandos rápidos ───────────────────────────────────────
$linhas += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
$linhas += "COMANDOS RÁPIDOS"
$linhas += "  Embaixador Valdece : .\scripts\ir_ao_embaixador.ps1 -cliente VALDECE"
$linhas += "  Embaixador Ingrid  : .\scripts\ir_ao_embaixador.ps1 -cliente INGRID"
$linhas += "  WhatsApp Ingrid B1 : .\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo B1"
$linhas += "  WhatsApp Ingrid Rel: .\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo RELATORIO_SEMANAL"
$linhas += ""
$linhas += "— Pentalateral IAH · Músculo"

$corpo = $linhas -join "`n"

# ── Função: envia texto ao Telegram com split automático ──
function Send-Telegram {
    param([string]$Texto)
    $url      = "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage"
    $maxLen   = 4000
    $offset   = 0
    $partes   = 0
    while ($offset -lt $Texto.Length) {
        $parte = $Texto.Substring($offset, [Math]::Min($maxLen, $Texto.Length - $offset))
        try {
            Invoke-RestMethod -Uri $url -Method POST -Body @{
                chat_id = $TELEGRAM_CHAT_ID
                text    = $parte
            } | Out-Null
        } catch {
            Write-Host "⚠️  Telegram (parte $($partes+1)): $($_.Exception.Message)" -ForegroundColor Yellow
        }
        $offset += $maxLen
        $partes++
        if ($partes -gt 1) { Start-Sleep -Milliseconds 300 }
    }
    return $partes
}

# ── Envia briefing completo via Telegram ──────────────────
$cabecalhoTelegram = if ($alertasCriticos.Count -gt 0) {
    "🔴 BRIEFING $dataStr — $($alertasCriticos.Count) ALERTA(S) CRITICO(S)`n`n"
} else {
    "✅ BRIEFING $dataStr — Pentalateral IAH — nenhum alerta`n`n"
}

$partesTelegram = Send-Telegram ($cabecalhoTelegram + $corpo)
Write-Host "📱 Briefing enviado ao Telegram ($partesTelegram parte(s))" -ForegroundColor Cyan

# ── Envia e-mail ───────────────────────────────────────────
$assuntoEmail = if ($alertasCriticos.Count -gt 0) {
    "🔴 BRIEFING $dataStr — $($alertasCriticos.Count) ALERTA(S) — Pentalateral IAH"
} else {
    "BRIEFING $dataStr — Pentalateral IAH"
}

try {
    $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $smtp.EnableSsl     = $true
    $smtp.Credentials  = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)

    $msg                 = New-Object Net.Mail.MailMessage
    $msg.From            = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject         = $assuntoEmail
    $msg.Body            = $corpo
    $msg.BodyEncoding    = [System.Text.Encoding]::UTF8

    $smtp.Send($msg)
    Write-Host "✉️  Briefing enviado para $ALERT_TO" -ForegroundColor Green
} catch {
    Write-Host "❌ ERRO ao enviar e-mail: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   (Briefing já foi entregue pelo Telegram)" -ForegroundColor Yellow
}
