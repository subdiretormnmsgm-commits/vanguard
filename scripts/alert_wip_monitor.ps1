# ============================================================
# ALERT_WIP_MONITOR.PS1 — Monitor do WIP_BOARD
# Roda via Task Scheduler a cada 5 minutos
# Envia email quando primeiro cliente aparece no sistema
# ============================================================

$BASE = "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard"
$WIP_PATH    = "$BASE\CLIENTES\WIP_BOARD.json"
$STATE_PATH  = "$BASE\CLIENTES\.wip_last_state.json"
$CONFIG_PATH = "$BASE\scripts\alert_config.ps1"
$LOG_PATH    = "$BASE\scripts\alert_monitor.log"

function Write-Log {
    param([string]$msg)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $msg" | Out-File -FilePath $LOG_PATH -Append -Encoding utf8
}

# Carregar credenciais
if (-not (Test-Path $CONFIG_PATH)) {
    Write-Log "ERRO: alert_config.ps1 não encontrado. Configure as credenciais."
    exit 1
}
. $CONFIG_PATH

if ($ALERT_SENHA -eq "COLAR_SENHA_DE_APP_AQUI") {
    Write-Log "AVISO: Senha de app não configurada. Preencher alert_config.ps1."
    exit 1
}

# Ler WIP_BOARD atual
if (-not (Test-Path $WIP_PATH)) {
    Write-Log "AVISO: WIP_BOARD.json não encontrado."
    exit 0
}

$wip = Get-Content $WIP_PATH -Raw | ConvertFrom-Json

# Coletar todos os clientes em discovery ou build
$ativos = @()
$ativos += $wip.board.discovery
$ativos += $wip.board.build

# Ler último estado conhecido
$ultimo_estado = @{ clientes = @() }
if (Test-Path $STATE_PATH) {
    $ultimo_estado = Get-Content $STATE_PATH -Raw | ConvertFrom-Json
}

# Detectar novos clientes
$novos = $ativos | Where-Object { $_ -notin $ultimo_estado.clientes }

if ($novos.Count -eq 0) {
    exit 0
}

# Novo cliente detectado — enviar email
foreach ($cliente in $novos) {

    $etapa = if ($cliente -in $wip.board.build) { "BUILD" } else { "DISCOVERY" }

    $assunto = "Quadrilateral IAH — Novo cliente: $cliente"

    $corpo = @"
QUADRILATERAL IAH — ALERTA DO SISTEMA
======================================

Diretor Eduardo,

Um novo objeto entrou no sistema.

Cliente : $cliente
Etapa   : $etapa
Data    : $(Get-Date -Format "dd/MM/yyyy HH:mm")

PRÓXIMAS AÇÕES:
$(if ($etapa -eq "DISCOVERY") {
"  1. Preencher BRIEFING_RAPIDO_WHATSAPP.md com as respostas
  2. Calcular a Hemorragia (clientes × ticket × 4)
  3. Identificar o FIRE Event
  4. Dar veredito: avançar para BUILD ou recusar"
} else {
"  1. Acionar PROTOCOLO VANGUARD no Claude Code
  2. Confirmar appetite (quantos dias?)
  3. Iniciar o Módulo 0 (Sovereign Pixel + Sentinel)"
})

Board atual:
  Discovery : $($wip.board.discovery -join ", ")
  Build     : $($wip.board.build -join ", ")
  Check     : $($wip.board.check -join ", ")
  Entregue  : $($wip.board.entregue -join ", ")

======================================
Quadrilateral IAH · Sistema de Alertas · Músculo (Claude Code)
"@

    try {
        $smtp   = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
        $smtp.EnableSsl = $true
        $smtp.Credentials = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)

        $msg          = New-Object Net.Mail.MailMessage
        $msg.From     = $ALERT_FROM
        $msg.To.Add($ALERT_TO)
        $msg.Subject  = $assunto
        $msg.Body     = $corpo

        $smtp.Send($msg)
        Write-Log "EMAIL ENVIADO — Novo cliente '$cliente' em $etapa"

    } catch {
        Write-Log "ERRO ao enviar email: $_"
    }
}

# Salvar novo estado
$novo_estado = @{ clientes = $ativos; atualizado = (Get-Date -Format "yyyy-MM-dd HH:mm") }
$novo_estado | ConvertTo-Json | Out-File -FilePath $STATE_PATH -Encoding utf8
