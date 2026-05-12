# ============================================================
# ALERT_WIP_MONITOR.PS1 — Monitor do WIP_BOARD (Council Messenger)
# Roda via Task Scheduler a cada 5 minutos
# Triggers: novo cliente, slot BUILD liberado, Circuit Breaker, Sentinel FIRE
# ============================================================

$BASE             = Split-Path -Parent $PSScriptRoot
$WIP_PATH         = "$BASE\CLIENTES\WIP_BOARD.json"
$STATE_PATH       = "$BASE\CLIENTES\.wip_last_state.json"
$TIMESTAMPS_PATH  = "$BASE\CLIENTES\.build_timestamps.json"
$FIRE_NOTIFIED_PATH = "$BASE\CLIENTES\.sentinel_fire_notified.json"
$CONFIG_PATH      = "$BASE\scripts\alert_config.ps1"
$LOG_PATH         = "$BASE\scripts\alert_monitor.log"

function Write-Log {
    param([string]$msg)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $msg" | Out-File -FilePath $LOG_PATH -Append -Encoding utf8
}

# --- Carregar credenciais (env var tem prioridade — Segurança Soberana) ---
if (-not (Test-Path $CONFIG_PATH)) {
    Write-Log "ERRO: alert_config.ps1 não encontrado."
    exit 1
}
. $CONFIG_PATH

$SENHA_ATIVA = if ($env:QUADRILATERAL_GMAIL_SENHA) { $env:QUADRILATERAL_GMAIL_SENHA } else { $ALERT_SENHA }

if ($SENHA_ATIVA -eq "COLAR_SENHA_DE_APP_AQUI") {
    Write-Log "AVISO: Senha de app não configurada."
    exit 1
}

# --- Função de envio de email ---
function Send-Email {
    param([string]$Assunto, [string]$Corpo)
    try {
        $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
        $smtp.EnableSsl = $true
        $smtp.Credentials = New-Object Net.NetworkCredential($ALERT_FROM, $SENHA_ATIVA)
        $msg = New-Object Net.Mail.MailMessage
        $msg.From    = $ALERT_FROM
        $msg.To.Add($ALERT_TO)
        $msg.Subject = $Assunto
        $msg.Body    = $Corpo
        $smtp.Send($msg)
        return $true
    } catch {
        Write-Log "ERRO ao enviar email: $_"
        return $false
    }
}

# --- Ler WIP_BOARD ---
if (-not (Test-Path $WIP_PATH)) {
    Write-Log "AVISO: WIP_BOARD.json não encontrado."
    exit 0
}
$wip = Get-Content $WIP_PATH -Raw | ConvertFrom-Json

# --- Carregar estado anterior ---
$ultimo_estado = @{ clientes = @(); board_build = @() }
if (Test-Path $STATE_PATH) {
    $ultimo_estado = Get-Content $STATE_PATH -Raw | ConvertFrom-Json
}

# --- Carregar timestamps de BUILD ---
$timestamps = @{}
if (Test-Path $TIMESTAMPS_PATH) {
    $ts_raw = Get-Content $TIMESTAMPS_PATH -Raw | ConvertFrom-Json
    $ts_raw.PSObject.Properties | ForEach-Object { $timestamps[$_.Name] = $_.Value }
}

# --- Carregar registro de notificações (Circuit Breaker + FIRE) ---
$fire_notified = @{}
if (Test-Path $FIRE_NOTIFIED_PATH) {
    $fn_raw = Get-Content $FIRE_NOTIFIED_PATH -Raw | ConvertFrom-Json
    $fn_raw.PSObject.Properties | ForEach-Object { $fire_notified[$_.Name] = $_.Value }
}

# ============================================================
# TRIGGER 1 — Novo cliente em DISCOVERY ou BUILD
# ============================================================

$ativos = @()
$ativos += $wip.board.discovery
$ativos += $wip.board.build

$novos = $ativos | Where-Object { $_ -notin $ultimo_estado.clientes }

foreach ($cliente in $novos) {
    $etapa = if ($cliente -in $wip.board.build) { "BUILD" } else { "DISCOVERY" }

    $acoes_discovery = @"
  1. Conduzir o Briefing Rápido (WhatsApp ou presencial)
  2. Calcular a Hemorragia: clientes x ticket x 4
  3. Identificar o FIRE Event
  4. Dar veredito: avançar para BUILD ou recusar
"@
    $acoes_build = @"
  1. Acionar PROTOCOLO VANGUARD no Claude Code
  2. Confirmar appetite (quantos dias?)
  3. Iniciar o Modulo 0 (Sovereign Pixel + Sentinel)
"@

    $assunto = "[QUADRILATERAL IAH] Musculo -> Novo objeto em ${etapa}: $cliente"
    $corpo = @"
QUADRILATERAL IAH — DESPACHO DO MUSCULO
=========================================

Diretor Eduardo,

Novo objeto entrou no sistema. Acao sua necessaria.

Cliente : $cliente
Etapa   : $etapa
Entrou  : $(Get-Date -Format "dd/MM/yyyy HH:mm")

O QUE PRECISA DE VOCE:
$(if ($etapa -eq "DISCOVERY") { $acoes_discovery } else { $acoes_build })

Board atual:
  Discovery : $($wip.board.discovery -join ", ")
  Build     : $($wip.board.build -join ", ")
  Check     : $($wip.board.check -join ", ")
  Entregue  : $($wip.board.entregue -join ", ")

Aguardamos seu veredito para avancar.

=========================================
Musculo (Claude Code) . Quadrilateral IAH
"@

    if (Send-Email -Assunto $assunto -Corpo $corpo) {
        Write-Log "EMAIL ENVIADO — Novo cliente '$cliente' em $etapa"
    }
}

# ============================================================
# SINCRONIZAR TIMESTAMPS DE BUILD
# ============================================================

foreach ($cliente in $wip.board.build) {
    if (-not $timestamps.ContainsKey($cliente)) {
        $timestamps[$cliente] = (Get-Date -Format "yyyy-MM-dd")
        Write-Log "TIMESTAMP registrado — '$cliente' entrou em BUILD"
    }
}

$keys_to_remove = @($timestamps.Keys | Where-Object { $_ -notin $wip.board.build })
foreach ($key in $keys_to_remove) {
    $timestamps.Remove($key)
    Write-Log "TIMESTAMP removido — '$key' saiu de BUILD"
}

$timestamps | ConvertTo-Json | Out-File -FilePath $TIMESTAMPS_PATH -Encoding utf8

# ============================================================
# TRIGGER 2 — Slot BUILD liberado
# ============================================================

$build_anterior = if ($ultimo_estado.board_build) { @($ultimo_estado.board_build) } else { @() }
$build_atual    = @($wip.board.build)
$saiu_de_build  = $build_anterior | Where-Object { $_ -notin $build_atual }

foreach ($cliente in $saiu_de_build) {
    $assunto = "[QUADRILATERAL IAH] Musculo -> Slot BUILD liberado — pipeline pode avancar"
    $corpo = @"
QUADRILATERAL IAH — DESPACHO DO MUSCULO
=========================================

Diretor Eduardo,

$cliente saiu de BUILD. Capacidade disponivel: $($build_atual.Count)/$($wip.wip_limits.build) slots.

BOARD ATUAL:
  Discovery : $(if ($wip.board.discovery.Count -eq 0) { "— vazio" } else { $wip.board.discovery -join ", " })
  Build     : $(if ($build_atual.Count -eq 0) { "— vazio" } else { $build_atual -join ", " })

Se ha alguem em DISCOVERY aprovado, de o sinal para entrar em BUILD.

=========================================
Musculo (Claude Code) . Quadrilateral IAH
"@

    if (Send-Email -Assunto $assunto -Corpo $corpo) {
        Write-Log "EMAIL ENVIADO — Slot BUILD liberado por '$cliente'"
    }
}

# ============================================================
# TRIGGER 3 — Circuit Breaker (Dia 4+ em BUILD sem sentinel)
# ============================================================

$hoje = Get-Date

foreach ($cliente in $wip.board.build) {
    if (-not $timestamps.ContainsKey($cliente)) { continue }

    $data_entrada  = [datetime]::ParseExact($timestamps[$cliente], "yyyy-MM-dd", $null)
    $dias_em_build = ($hoje - $data_entrada).Days
    $sentinel_path = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    $sentinel_ok   = Test-Path $sentinel_path

    if ($dias_em_build -ge 4 -and -not $sentinel_ok) {
        $chave_cb        = "${cliente}_circuit_breaker"
        $ultimo_alerta   = if ($fire_notified.ContainsKey($chave_cb)) { $fire_notified[$chave_cb] } else { "" }
        $ja_alertou_hoje = $ultimo_alerta -eq (Get-Date -Format "yyyy-MM-dd")

        if (-not $ja_alertou_hoje) {
            $assunto = "[QUADRILATERAL IAH] AUDITOR -> Circuit Breaker: $cliente — Dia $dias_em_build sem MVP"
            $corpo = @"
QUADRILATERAL IAH — DESPACHO DO AUDITOR
=========================================

Diretor,

$cliente esta em BUILD ha $dias_em_build dias sem MVP entregue.

Score GUT: Gravidade 5 . Urgencia 5 . Tendencia 5 = PRIORIDADE MAXIMA

DIAGNOSTICO: Risco de entrega comprometida. Intervencao necessaria.

ACAO NECESSARIA HOJE:
  -> Revisar o appetite com o Musculo
  -> Cortar escopo ou redefinir MVP
  -> Confirmar nova data de entrega

Sem sua decisao nas proximas 24h, o projeto entra em modo de congelamento.

=========================================
Auditor . Quadrilateral IAH
"@

            if (Send-Email -Assunto $assunto -Corpo $corpo) {
                Write-Log "EMAIL ENVIADO — Circuit Breaker '$cliente' Dia $dias_em_build"
                $fire_notified[$chave_cb] = (Get-Date -Format "yyyy-MM-dd")
            }
        }
    }
}

# ============================================================
# TRIGGER 4 — Sentinel FIRE Event
# ============================================================

$todos_clientes = @()
$todos_clientes += $wip.board.discovery
$todos_clientes += $wip.board.build
$todos_clientes += $wip.board.check

foreach ($cliente in $todos_clientes) {
    $sentinel_path = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    if (-not (Test-Path $sentinel_path)) { continue }

    $sentinel = Get-Content $sentinel_path -Raw | ConvertFrom-Json
    if ($sentinel.fire_event -ne $true) { continue }
    if ($fire_notified.ContainsKey("${cliente}_fire")) { continue }

    $etapa = if ($cliente -in $wip.board.build) { "BUILD" } `
             elseif ($cliente -in $wip.board.check) { "CHECK" } `
             else { "DISCOVERY" }

    $assunto = "[QUADRILATERAL IAH] AUDITOR -> FIRE Event detectado: $cliente"
    $corpo = @"
QUADRILATERAL IAH — DESPACHO DO AUDITOR
=========================================

Diretor,

O Sentinel de $cliente sinalizou um FIRE Event.

Cliente : $cliente
Etapa   : $etapa
Flag    : fire_event = true em sentinel_config.json

ACAO NECESSARIA:
  -> Acessar CLIENTES\$cliente\sentinel_config.json
  -> Avaliar o incidente com o Musculo
  -> Definir resposta e remover a flag apos resolucao

=========================================
Auditor . Quadrilateral IAH
"@

    if (Send-Email -Assunto $assunto -Corpo $corpo) {
        Write-Log "EMAIL ENVIADO — Sentinel FIRE '$cliente'"
        $fire_notified["${cliente}_fire"] = (Get-Date -Format "yyyy-MM-dd HH:mm")
    }
}

# --- Salvar estado de notificações ---
$fire_notified | ConvertTo-Json | Out-File -FilePath $FIRE_NOTIFIED_PATH -Encoding utf8

# --- Salvar novo estado do board ---
$novo_estado = @{
    clientes    = $ativos
    board_build = [array]$wip.board.build
    atualizado  = (Get-Date -Format "yyyy-MM-dd HH:mm")
}
$novo_estado | ConvertTo-Json | Out-File -FilePath $STATE_PATH -Encoding utf8
