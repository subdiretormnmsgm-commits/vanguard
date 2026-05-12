# ============================================================
# ALERT_DAILY_BRIEFING.PS1 — Despacho Matinal do Conselho
# Roda via Task Scheduler todo dia as 07:00
# Inclui Score GUT semanal calculado automaticamente
# ============================================================

$BASE             = Split-Path -Parent $PSScriptRoot
$WIP_PATH         = "$BASE\CLIENTES\WIP_BOARD.json"
$CONFIG_PATH      = "$BASE\scripts\alert_config.ps1"
$LOG_PATH         = "$BASE\scripts\alert_monitor.log"
$TIMESTAMPS_PATH  = "$BASE\CLIENTES\.build_timestamps.json"
$FIRE_NOTIFIED_PATH = "$BASE\CLIENTES\.sentinel_fire_notified.json"

function Write-Log {
    param([string]$msg)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $msg" | Out-File -FilePath $LOG_PATH -Append -Encoding utf8
}

# --- Credenciais (env var tem prioridade — Seguranca Soberana) ---
if (-not (Test-Path $CONFIG_PATH)) { Write-Log "ERRO: alert_config.ps1 nao encontrado."; exit 1 }
. $CONFIG_PATH

$SENHA_ATIVA = if ($env:QUADRILATERAL_GMAIL_SENHA) { $env:QUADRILATERAL_GMAIL_SENHA } else { $ALERT_SENHA }
if ($SENHA_ATIVA -eq "COLAR_SENHA_DE_APP_AQUI") { Write-Log "AVISO: Senha nao configurada."; exit 1 }
if (-not (Test-Path $WIP_PATH)) { Write-Log "AVISO: WIP_BOARD.json nao encontrado."; exit 0 }

$wip  = Get-Content $WIP_PATH -Raw | ConvertFrom-Json
$hoje = Get-Date -Format "dd/MM/yyyy"

# --- Carregar timestamps de BUILD ---
$timestamps = @{}
if (Test-Path $TIMESTAMPS_PATH) {
    $ts_raw = Get-Content $TIMESTAMPS_PATH -Raw | ConvertFrom-Json
    $ts_raw.PSObject.Properties | ForEach-Object { $timestamps[$_.Name] = $_.Value }
}

# --- Carregar FIRE notificados ---
$fire_notified = @{}
if (Test-Path $FIRE_NOTIFIED_PATH) {
    $fn_raw = Get-Content $FIRE_NOTIFIED_PATH -Raw | ConvertFrom-Json
    $fn_raw.PSObject.Properties | ForEach-Object { $fire_notified[$_.Name] = $_.Value }
}

# ============================================================
# CALCULAR SCORE GUT SEMANAL
# Gravidade  : impacto no negocio se nada for feito
# Urgencia   : pressao de tempo / prazo
# Tendencia  : tendencia de piorar se nao agir agora
# Escala: 1 (baixo) a 5 (critico)
# ============================================================

$gut_gravidade  = 1
$gut_urgencia   = 1
$gut_tendencia  = 1
$gut_razoes     = @()

# Gravidade sobe com projetos em BUILD sem sentinel
$projetos_sem_sentinel = 0
foreach ($cliente in $wip.board.build) {
    if (-not (Test-Path "$BASE\CLIENTES\$cliente\sentinel_config.json")) {
        $projetos_sem_sentinel++
    }
}
if ($projetos_sem_sentinel -ge 2) { $gut_gravidade = [Math]::Min(5, $gut_gravidade + 3); $gut_razoes += "  · $projetos_sem_sentinel projetos em BUILD sem Sentinel configurado" }
elseif ($projetos_sem_sentinel -eq 1) { $gut_gravidade = [Math]::Min(5, $gut_gravidade + 2); $gut_razoes += "  · 1 projeto em BUILD sem Sentinel configurado" }

# Gravidade sobe com FIRE events ativos
$fire_ativos = 0
foreach ($cliente in ($wip.board.discovery + $wip.board.build + $wip.board.check)) {
    $sp = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    if (Test-Path $sp) {
        $s = Get-Content $sp -Raw | ConvertFrom-Json
        if ($s.fire_event -eq $true) { $fire_ativos++ }
    }
}
if ($fire_ativos -gt 0) { $gut_gravidade = 5; $gut_razoes += "  · $fire_ativos FIRE Event(s) ativo(s) no sistema" }

# Urgencia sobe com WIP cheio e projetos no prazo limite
$slots_livres = $wip.wip_limits.build - $wip.board.build.Count
if ($slots_livres -eq 0) { $gut_urgencia = [Math]::Min(5, $gut_urgencia + 2); $gut_razoes += "  · WIP BUILD cheio — nenhum slot disponivel" }

$max_dias = 0
foreach ($cliente in $wip.board.build) {
    if ($timestamps.ContainsKey($cliente)) {
        $dias = ([datetime]::Today - [datetime]::ParseExact($timestamps[$cliente], "yyyy-MM-dd", $null)).Days
        if ($dias -gt $max_dias) { $max_dias = $dias }
    }
}
if ($max_dias -ge 6) { $gut_urgencia = 5; $gut_razoes += "  · Projeto em BUILD ha $max_dias dias — critico" }
elseif ($max_dias -ge 4) { $gut_urgencia = [Math]::Min(5, $gut_urgencia + 2); $gut_razoes += "  · Projeto em BUILD ha $max_dias dias — Circuit Breaker ativo" }

# Tendencia sobe se ha discovery sem avanco ou retainer sem renovacao pendente
if ($wip.board.discovery.Count -gt 0 -and $wip.board.build.Count -eq 0) {
    $gut_tendencia = [Math]::Min(5, $gut_tendencia + 2)
    $gut_razoes += "  · Clientes em DISCOVERY sem avancar para BUILD"
}
if ($wip.board.check.Count -gt 0) {
    $gut_tendencia = [Math]::Min(5, $gut_tendencia + 1)
    $gut_razoes += "  · Projeto em CHECK aguardando validacao"
}
if ($fire_ativos -gt 0) { $gut_tendencia = 5 }

$gut_score  = $gut_gravidade * $gut_urgencia * $gut_tendencia
$gut_nivel  = if ($gut_score -ge 100) { "CRITICO" } `
              elseif ($gut_score -ge 50) { "ALTO" } `
              elseif ($gut_score -ge 20) { "MEDIO" } `
              else { "BAIXO" }

$gut_razoes_texto = if ($gut_razoes.Count -eq 0) { "  Sem fatores de risco ativos." } `
                    else { ($gut_razoes | Select-Object -Unique) -join "`n" }

# ============================================================
# MONTAR LISTA DE BUILD COM DIAS
# ============================================================

function Get-BuildLine {
    param([string]$cliente)
    if ($timestamps.ContainsKey($cliente)) {
        $dias = ([datetime]::Today - [datetime]::ParseExact($timestamps[$cliente], "yyyy-MM-dd", $null)).Days
        $alerta = if ($dias -ge 4) { " ⚠ Circuit Breaker" } else { "" }
        return "  . $cliente — Dia $dias$alerta"
    }
    return "  . $cliente"
}

$build_linhas = if ($wip.board.build.Count -eq 0) { "  — vazio" } `
               else { ($wip.board.build | ForEach-Object { Get-BuildLine $_ }) -join "`n" }

# ============================================================
# CALCULAR ACOES PENDENTES
# ============================================================

$acoes = @()

foreach ($cliente in $wip.board.build) {
    if (-not (Test-Path "$BASE\CLIENTES\$cliente\sentinel_config.json")) {
        $acoes += "  . Sentinel de $cliente nao configurado — obrigatorio antes do handoff"
    }
    $pdf = "$BASE\CLIENTES\$cliente\SOVEREIGN_PLAYBOOK.pdf"
    $md  = "$BASE\CLIENTES\$cliente\SOVEREIGN_PLAYBOOK.md"
    if (-not (Test-Path $pdf) -and -not (Test-Path $md)) {
        $acoes += "  . Playbook de $cliente pendente — gerar antes de ENTREGUE"
    }
    if ($timestamps.ContainsKey($cliente)) {
        $dias = ([datetime]::Today - [datetime]::ParseExact($timestamps[$cliente], "yyyy-MM-dd", $null)).Days
        if ($dias -ge 4) { $acoes += "  . $cliente em BUILD ha $dias dias — revisar scope com Musculo" }
    }
}

foreach ($cliente in ($wip.board.build + $wip.board.check + $wip.board.discovery)) {
    $sp = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    if (Test-Path $sp) {
        $s = Get-Content $sp -Raw | ConvertFrom-Json
        if ($s.fire_event -eq $true) { $acoes += "  . FIRE Event ativo em $cliente — resolver com urgencia" }
    }
}

$acoes_texto = if ($acoes.Count -eq 0) { "  Nenhuma acao pendente. Board em ordem." } `
               else { ($acoes | Select-Object -Unique) -join "`n" }

$capacidade_label = if ($slots_livres -gt 0) { "LIVRE ($slots_livres slot(s))" } else { "CHEIO" }

# ============================================================
# MONTAR E ENVIAR EMAIL
# ============================================================

$assunto = "[QUADRILATERAL IAH] Despacho Matinal — $hoje"
$corpo = @"
QUADRILATERAL IAH — DESPACHO MATINAL
=========================================

Diretor Eduardo, bom dia.

========================================
ESTADO DO BOARD — $hoje
========================================

  Discovery : $(if ($wip.board.discovery.Count -eq 0) { "— vazio" } else { $wip.board.discovery -join ", " })
  Build     :
$build_linhas
  Check     : $(if ($wip.board.check.Count -eq 0) { "— vazio" } else { $wip.board.check -join ", " })
  Entregue  : $(if ($wip.board.entregue.Count -eq 0) { "— vazio" } else { $wip.board.entregue -join ", " })
  Retainer  : $(if ($wip.board.retainer.Count -eq 0) { "— vazio" } else { $wip.board.retainer -join ", " })

CAPACIDADE:
  Slots BUILD: $($wip.board.build.Count)/$($wip.wip_limits.build) — $capacidade_label

========================================
SCORE GUT SEMANAL
========================================

  Gravidade  : $gut_gravidade / 5
  Urgencia   : $gut_urgencia / 5
  Tendencia  : $gut_tendencia / 5
  GUT Total  : $gut_score — $gut_nivel

FATORES DE RISCO:
$gut_razoes_texto

========================================
ACOES PENDENTES
========================================
$acoes_texto

O Conselho esta de plantao.

=========================================
Conselho . Quadrilateral IAH
"@

try {
    $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object Net.NetworkCredential($ALERT_FROM, $SENHA_ATIVA)
    $msg = New-Object Net.Mail.MailMessage
    $msg.From    = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject = $assunto
    $msg.Body    = $corpo
    $smtp.Send($msg)
    Write-Log "BRIEFING MATINAL ENVIADO — $hoje (GUT $gut_score — $gut_nivel)"
} catch {
    Write-Log "ERRO briefing: $_"
}
