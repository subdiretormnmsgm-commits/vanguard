# ============================================================
# ALERT_WIP_MONITOR.PS1 -- Monitor do WIP_BOARD (Council Messenger)
# Roda via Task Scheduler a cada 5 minutos
# Triggers: novo cliente, slot BUILD liberado, Circuit Breaker, Sentinel FIRE
# Formato de alerta urgente: Pager do Diretor (TOC / A Meta)
# ============================================================

$BASE               = Split-Path -Parent $PSScriptRoot
$WIP_PATH           = "$BASE\CLIENTES\WIP_BOARD.json"
$STATE_PATH         = "$BASE\CLIENTES\.wip_last_state.json"
$TIMESTAMPS_PATH    = "$BASE\CLIENTES\.build_timestamps.json"
$FIRE_NOTIFIED_PATH = "$BASE\CLIENTES\.sentinel_fire_notified.json"
$CONFIG_PATH        = "$BASE\scripts\alert_config.ps1"
$LOG_PATH           = "$BASE\scripts\alert_monitor.log"

function Write-Log {
    param([string]$msg)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $msg" | Out-File -FilePath $LOG_PATH -Append -Encoding utf8
}

# --- Credenciais (env var tem prioridade -- Seguranca Soberana) ---
if (-not (Test-Path $CONFIG_PATH)) {
    Write-Log "ERRO: alert_config.ps1 nao encontrado."
    exit 1
}
. $CONFIG_PATH

$SENHA_ATIVA = if ($env:PENTALATERAL_GMAIL_SENHA) { $env:PENTALATERAL_GMAIL_SENHA } else { $ALERT_SENHA }

if ($SENHA_ATIVA -eq "COLAR_SENHA_DE_APP_AQUI") {
    Write-Log "AVISO: Senha de app nao configurada."
    exit 1
}

# --- Funcao de envio de email ---
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
    Write-Log "AVISO: WIP_BOARD.json nao encontrado."
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

# --- Carregar registro de notificacoes ---
$fire_notified = @{}
if (Test-Path $FIRE_NOTIFIED_PATH) {
    $fn_raw = Get-Content $FIRE_NOTIFIED_PATH -Raw | ConvertFrom-Json
    $fn_raw.PSObject.Properties | ForEach-Object { $fire_notified[$_.Name] = $_.Value }
}

# ============================================================
# TRIGGER 1 -- Novo cliente em DISCOVERY ou BUILD
# ============================================================

$ativos = @()
$ativos += $wip.board.discovery
$ativos += $wip.board.build

$novos = $ativos | Where-Object { $_ -notin $ultimo_estado.clientes }

foreach ($cliente in $novos) {
    $etapa = if ($cliente -in $wip.board.build) { "BUILD" } else { "DISCOVERY" }

    $acoes_discovery = @"
  1. Conduzir o Briefing Rapido (WhatsApp ou presencial)
  2. Calcular a Hemorragia: clientes x ticket x 4
  3. Identificar o FIRE Event
  4. Dar veredito: avancar para BUILD ou recusar
"@
    $acoes_build = @"
  1. Acionar PROTOCOLO VANGUARD no Claude Code
  2. Confirmar appetite (quantos dias?)
  3. Iniciar o Modulo 0 (Sovereign Pixel + Sentinel)
"@

    $disc_board  = if ($wip.board.discovery.Count -eq 0) { "-- vazio" } else { $wip.board.discovery -join ", " }
    $build_board = if ($wip.board.build.Count -eq 0) { "-- vazio" } else { $wip.board.build -join ", " }
    $check_board = if ($wip.board.check.Count -eq 0) { "-- vazio" } else { $wip.board.check -join ", " }
    $entr_board  = if ($wip.board.entregue.Count -eq 0) { "-- vazio" } else { $wip.board.entregue -join ", " }

    $assunto = "[PENTALATERAL IAH] Musculo -> Novo objeto em ${etapa}: $cliente"
    $corpo = @"
PENTALATERAL IAH -- DESPACHO DO MUSCULO
=========================================

Diretor Eduardo,

Novo objeto entrou no sistema. Acao sua necessaria.

Cliente : $cliente
Etapa   : $etapa
Entrou  : $(Get-Date -Format "dd/MM/yyyy HH:mm")

O QUE PRECISA DE VOCE:
$(if ($etapa -eq "DISCOVERY") { $acoes_discovery } else { $acoes_build })

Board atual:
  Discovery : $disc_board
  Build     : $build_board
  Check     : $check_board
  Entregue  : $entr_board

Aguardamos seu veredito para avancar.

=========================================
Musculo (Claude Code) . PENTALATERAL IAH
"@

    if (Send-Email -Assunto $assunto -Corpo $corpo) {
        Write-Log "EMAIL ENVIADO -- Novo cliente '$cliente' em $etapa"
    }
}

# ============================================================
# SINCRONIZAR TIMESTAMPS DE BUILD
# ============================================================

foreach ($cliente in $wip.board.build) {
    if (-not $timestamps.ContainsKey($cliente)) {
        $timestamps[$cliente] = (Get-Date -Format "yyyy-MM-dd")
        Write-Log "TIMESTAMP registrado -- '$cliente' entrou em BUILD"
    }
}

$keys_to_remove = @($timestamps.Keys | Where-Object { $_ -notin $wip.board.build })
foreach ($key in $keys_to_remove) {
    $timestamps.Remove($key)
    Write-Log "TIMESTAMP removido -- '$key' saiu de BUILD"
}

$timestamps | ConvertTo-Json | Out-File -FilePath $TIMESTAMPS_PATH -Encoding utf8

# ============================================================
# TRIGGER 2 -- Slot BUILD liberado
# ============================================================

$build_anterior = if ($ultimo_estado.board_build) { @($ultimo_estado.board_build) } else { @() }
$build_atual    = @($wip.board.build)
$saiu_de_build  = $build_anterior | Where-Object { $_ -notin $build_atual }

foreach ($cliente in $saiu_de_build) {
    $disc_txt  = if ($wip.board.discovery.Count -eq 0) { "-- vazio" } else { $wip.board.discovery -join ", " }
    $build_txt = if ($build_atual.Count -eq 0) { "-- vazio" } else { $build_atual -join ", " }
    $assunto = "[PENTALATERAL IAH] Musculo -> Slot BUILD liberado -- pipeline pode avancar"
    $corpo = @"
PENTALATERAL IAH -- DESPACHO DO MUSCULO
=========================================

Diretor Eduardo,

$cliente saiu de BUILD. Capacidade disponivel: $($build_atual.Count)/$($wip.wip_limits.build) slots.

BOARD ATUAL:
  Discovery : $disc_txt
  Build     : $build_txt

Se ha alguem em DISCOVERY aprovado, de o sinal para entrar em BUILD.

=========================================
Musculo (Claude Code) . PENTALATERAL IAH
"@

    if (Send-Email -Assunto $assunto -Corpo $corpo) {
        Write-Log "EMAIL ENVIADO -- Slot BUILD liberado por '$cliente'"
    }
}

# ============================================================
# TRIGGER 3 -- Circuit Breaker (Dia 4+ em BUILD sem sentinel)
# Formato: Pager do Diretor (TOC -- A Meta)
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
            $assunto = "[ALERTA] Circuit Breaker Dia $dias_em_build -- $cliente"
            $corpo = @"
[ALERTA] CIRCUIT BREAKER -- $cliente

Gatilho Acionado: Circuit Breaker Dia $dias_em_build (BUILD sem MVP entregue)

==================================================
[SINTESE] (situacao objetiva)
$cliente esta em BUILD ha $dias_em_build dias.
Sentinel nao configurado. Gargalo: sem validacao de entrega.

[DELIBERACAO DO CONSELHO]
- Estrategista (Gemini): Consultar Gemini com contexto do cliente antes de decidir.
- Musculo (Claude Code): Cortar escopo ao MVP minimo viavel. Entregar algo hoje.
- Auditor (NotebookLM): Padrao historico indica risco de museu tecnologico apos Dia 6.

[RECOMENDACAO DE ACAO]
Redefinir MVP em sessao com Musculo hoje. Validar com cliente em 24h.
Nao adicionar features. Entregar o minimo que gera valor mensuravel.

[VEREDITO REQUERIDO -- responder com o numero]:
[ 1 ] APROVAR recomendacao -- redefinir MVP com Musculo.
[ 2 ] VETAR -- acionar Protocolo de Emergencia (congelar projeto).
[ 3 ] Aguardar Diretor -- WIP entra em pausa.
==================================================
GUT: Gravidade 5 . Urgencia 5 . Tendencia 5 = PRIORIDADE MAXIMA
Conselho . PENTALATERAL IAH
"@

            if (Send-Email -Assunto $assunto -Corpo $corpo) {
                Write-Log "EMAIL ENVIADO -- Circuit Breaker '$cliente' Dia $dias_em_build"
                $fire_notified[$chave_cb] = (Get-Date -Format "yyyy-MM-dd")
            }
        }
    }
}

# ============================================================
# TRIGGER 4 -- Sentinel FIRE Event
# Formato: Pager do Diretor (TOC -- A Meta)
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

    $assunto = "[ALERTA] FIRE Event -- $cliente ($etapa)"
    $corpo = @"
[ALERTA] SENTINEL FIRE EVENT -- $cliente

Gatilho Acionado: Sentinel FIRE (fire_event = true em sentinel_config.json)

==================================================
[SINTESE] (situacao objetiva)
Sentinel de $cliente ($etapa) sinalizou incidente critico.
Flag fire_event ativa. Requer decisao imediata do Diretor.

[DELIBERACAO DO CONSELHO]
- Estrategista (Gemini): Consultar Gemini com contexto do incidente antes de agir.
- Musculo (Claude Code): Inspecionar sentinel_config.json. Avaliar impacto tecnico.
- Auditor (NotebookLM): Aplicar 5 Porques antes de qualquer correcao (raiz, nao sintoma).

[RECOMENDACAO DE ACAO]
Abrir sessao com Musculo agora. Identificar raiz via 5 Porques.
Aplicar correcao minima e proporcional. Remover flag apos validacao.

[VEREDITO REQUERIDO -- responder com o numero]:
[ 1 ] APROVAR -- iniciar sessao de diagnostico com Musculo.
[ 2 ] VETAR -- acionar Protocolo de Emergencia (isolar cliente).
[ 3 ] Aguardar Diretor -- WIP entra em pausa.
==================================================
GUT: Gravidade 5 . Urgencia 5 . Tendencia 5 = PRIORIDADE MAXIMA
Conselho . PENTALATERAL IAH
"@

    if (Send-Email -Assunto $assunto -Corpo $corpo) {
        Write-Log "EMAIL ENVIADO -- Sentinel FIRE '$cliente'"
        $fire_notified["${cliente}_fire"] = (Get-Date -Format "yyyy-MM-dd HH:mm")
    }
}

# --- Salvar estado de notificacoes ---
$fire_notified | ConvertTo-Json | Out-File -FilePath $FIRE_NOTIFIED_PATH -Encoding utf8

# --- Salvar novo estado do board ---
$novo_estado = @{
    clientes    = $ativos
    board_build = [array]$wip.board.build
    atualizado  = (Get-Date -Format "yyyy-MM-dd HH:mm")
}
$novo_estado | ConvertTo-Json | Out-File -FilePath $STATE_PATH -Encoding utf8
