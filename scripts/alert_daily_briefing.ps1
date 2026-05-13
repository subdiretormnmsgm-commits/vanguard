# ============================================================
# ALERT_DAILY_BRIEFING.PS1 — Despacho Matinal do Conselho
# Roda via Task Scheduler todo dia as 07:00
# Inclui Score GUT semanal calculado automaticamente
# ============================================================

$BASE               = Split-Path -Parent $PSScriptRoot
$WIP_PATH           = "$BASE\CLIENTES\WIP_BOARD.json"
$CONFIG_PATH        = "$BASE\scripts\alert_config.ps1"
$LOG_PATH           = "$BASE\scripts\alert_monitor.log"
$TIMESTAMPS_PATH    = "$BASE\CLIENTES\.build_timestamps.json"
$FIRE_NOTIFIED_PATH = "$BASE\CLIENTES\.sentinel_fire_notified.json"

function Write-Log {
    param([string]$msg)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $msg" | Out-File -FilePath $LOG_PATH -Append -Encoding utf8
}

# --- Credenciais (env var tem prioridade --- Seguranca Soberana) ---
if (-not (Test-Path $CONFIG_PATH)) { Write-Log "ERRO: alert_config.ps1 nao encontrado."; exit 1 }
. $CONFIG_PATH

$SENHA_ATIVA = if ($env:QUADRILATERAL_GMAIL_SENHA) { $env:QUADRILATERAL_GMAIL_SENHA } else { $ALERT_SENHA }
if ($SENHA_ATIVA -eq "COLAR_SENHA_DE_APP_AQUI") { Write-Log "AVISO: Senha nao configurada."; exit 1 }
if (-not (Test-Path $WIP_PATH)) { Write-Log "AVISO: WIP_BOARD.json nao encontrado."; exit 0 }

$wip  = Get-Content $WIP_PATH -Raw | ConvertFrom-Json
$hoje = Get-Date -Format "dd/MM/yyyy"

# --- Carregar Intelligence Knowledge Graph ---
$KG_PATH = "$BASE\knowledge_graph.json"
$kg_data = $null
$principios_ativos = 0
if (Test-Path $KG_PATH) {
    $kg_data = Get-Content $KG_PATH -Raw | ConvertFrom-Json
    $principios_ativos = $kg_data.principles.Count
}

# --- Carregar timestamps de BUILD ---
$timestamps = @{}
if (Test-Path $TIMESTAMPS_PATH) {
    $ts_raw = Get-Content $TIMESTAMPS_PATH -Raw | ConvertFrom-Json
    $ts_raw.PSObject.Properties | ForEach-Object { $timestamps[$_.Name] = $_.Value }
}

# ============================================================
# CALCULAR SCORE GUT SEMANAL
# Gravidade  : impacto no negocio se nada for feito
# Urgencia   : pressao de tempo / prazo
# Tendencia  : tendencia de piorar se nao agir agora
# Escala: 1 (baixo) a 5 (critico)
# ============================================================

$gut_gravidade = 1
$gut_urgencia  = 1
$gut_tendencia = 1
$gut_razoes    = @()

# Gravidade sobe com projetos em BUILD sem sentinel
$projetos_sem_sentinel = 0
foreach ($cliente in $wip.board.build) {
    if (-not (Test-Path "$BASE\CLIENTES\$cliente\sentinel_config.json")) {
        $projetos_sem_sentinel++
    }
}
if ($projetos_sem_sentinel -ge 2) {
    $gut_gravidade = [Math]::Min(5, $gut_gravidade + 3)
    $gut_razoes += "  . $projetos_sem_sentinel projetos em BUILD sem Sentinel configurado"
} elseif ($projetos_sem_sentinel -eq 1) {
    $gut_gravidade = [Math]::Min(5, $gut_gravidade + 2)
    $gut_razoes += "  . 1 projeto em BUILD sem Sentinel configurado"
}

# Gravidade sobe com FIRE events ativos
$fire_ativos = 0
$todos_clientes_fire = @($wip.board.discovery) + @($wip.board.build) + @($wip.board.check)
foreach ($cliente in $todos_clientes_fire) {
    $sp = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    if (Test-Path $sp) {
        $s = Get-Content $sp -Raw | ConvertFrom-Json
        if ($s.fire_event -eq $true) { $fire_ativos++ }
    }
}
if ($fire_ativos -gt 0) {
    $gut_gravidade = 5
    $gut_razoes += "  . $fire_ativos FIRE Event(s) ativo(s) no sistema"
}

# Urgencia sobe com WIP cheio
$slots_livres = $wip.wip_limits.build - $wip.board.build.Count
if ($slots_livres -eq 0) {
    $gut_urgencia = [Math]::Min(5, $gut_urgencia + 2)
    $gut_razoes += "  . WIP BUILD cheio - nenhum slot disponivel"
}

# Urgencia sobe com projeto no prazo limite
$max_dias = 0
foreach ($cliente in $wip.board.build) {
    if ($timestamps.ContainsKey($cliente)) {
        $dias = ([datetime]::Today - [datetime]::ParseExact($timestamps[$cliente], "yyyy-MM-dd", $null)).Days
        if ($dias -gt $max_dias) { $max_dias = $dias }
    }
}
if ($max_dias -ge 6) {
    $gut_urgencia = 5
    $gut_razoes += "  . Projeto em BUILD ha $max_dias dias - CRITICO"
} elseif ($max_dias -ge 4) {
    $gut_urgencia = [Math]::Min(5, $gut_urgencia + 2)
    $gut_razoes += "  . Projeto em BUILD ha $max_dias dias - Circuit Breaker ativo"
}

# Tendencia sobe se LEDGER desatualizado
if ($kg_data -and $kg_data.meta.last_updated) {
    try {
        $ultima_sessao  = [datetime]::ParseExact($kg_data.meta.last_updated, "yyyy-MM-dd", $null)
        $dias_sem_ledger = ([datetime]::Today - $ultima_sessao).Days
        if ($dias_sem_ledger -ge 3) {
            $gut_tendencia = [Math]::Min(5, $gut_tendencia + 1)
            $gut_razoes += "  . INTELLIGENCE_LEDGER nao atualizado ha $dias_sem_ledger dia(s)"
        }
    } catch { }
}

# Tendencia sobe com discovery parado ou check pendente
if ($wip.board.discovery.Count -gt 0 -and $wip.board.build.Count -eq 0) {
    $gut_tendencia = [Math]::Min(5, $gut_tendencia + 2)
    $gut_razoes += "  . Clientes em DISCOVERY sem avancar para BUILD"
}
if ($wip.board.check.Count -gt 0) {
    $gut_tendencia = [Math]::Min(5, $gut_tendencia + 1)
    $gut_razoes += "  . Projeto em CHECK aguardando validacao"
}
if ($fire_ativos -gt 0) { $gut_tendencia = 5 }

$gut_score = $gut_gravidade * $gut_urgencia * $gut_tendencia
$gut_nivel = if ($gut_score -ge 100) { "CRITICO" } `
             elseif ($gut_score -ge 50) { "ALTO" } `
             elseif ($gut_score -ge 20) { "MEDIO" } `
             else { "BAIXO" }

$gut_razoes_texto = if ($gut_razoes.Count -eq 0) { "  Sem fatores de risco ativos." } `
                    else { ($gut_razoes | Select-Object -Unique) -join "`n" }

# ============================================================
# MONTAR LISTA DE BUILD COM DIAS
# ============================================================

$build_linhas = if ($wip.board.build.Count -eq 0) {
    "  -- vazio"
} else {
    $linhas = @()
    foreach ($cliente in $wip.board.build) {
        if ($timestamps.ContainsKey($cliente)) {
            $dias   = ([datetime]::Today - [datetime]::ParseExact($timestamps[$cliente], "yyyy-MM-dd", $null)).Days
            $alerta = if ($dias -ge 4) { " [Circuit Breaker]" } else { "" }
            $linhas += "  . $cliente -- Dia $dias$alerta"
        } else {
            $linhas += "  . $cliente"
        }
    }
    $linhas -join "`n"
}

# ============================================================
# CALCULAR ACOES PENDENTES
# ============================================================

$acoes = @()

foreach ($cliente in $wip.board.build) {
    $sp = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    if (-not (Test-Path $sp)) {
        $acoes += "  . Sentinel de $cliente nao configurado - obrigatorio antes do handoff"
    }
    $pdf = "$BASE\CLIENTES\$cliente\SOVEREIGN_PLAYBOOK.pdf"
    $md  = "$BASE\CLIENTES\$cliente\SOVEREIGN_PLAYBOOK.md"
    if (-not (Test-Path $pdf) -and -not (Test-Path $md)) {
        $acoes += "  . Playbook de $cliente pendente - gerar antes de ENTREGUE"
    }
    if ($timestamps.ContainsKey($cliente)) {
        $dias = ([datetime]::Today - [datetime]::ParseExact($timestamps[$cliente], "yyyy-MM-dd", $null)).Days
        if ($dias -ge 4) {
            $acoes += "  . $cliente em BUILD ha $dias dias - revisar scope com Musculo"
        }
    }
}

foreach ($cliente in $todos_clientes_fire) {
    $sp = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    if (Test-Path $sp) {
        $s = Get-Content $sp -Raw | ConvertFrom-Json
        if ($s.fire_event -eq $true) {
            $acoes += "  . FIRE Event ativo em $cliente - resolver com urgencia"
        }
    }
}

$acoes_texto = if ($acoes.Count -eq 0) {
    "  Nenhuma acao pendente. Board em ordem."
} else {
    ($acoes | Select-Object -Unique) -join "`n"
}

$capacidade_label = if ($slots_livres -gt 0) { "LIVRE ($slots_livres slot(s))" } else { "CHEIO" }

# ============================================================
# MONTAR E ENVIAR EMAIL
# ============================================================

$disc_txt     = if ($wip.board.discovery.Count -eq 0) { "<em>vazio</em>" } else { $wip.board.discovery -join ", " }
$check_txt    = if ($wip.board.check.Count -eq 0)     { "<em>vazio</em>" } else { $wip.board.check -join ", " }
$entregue_txt = if ($wip.board.entregue.Count -eq 0)  { "<em>vazio</em>" } else { $wip.board.entregue -join ", " }
$retainer_txt = if ($wip.board.retainer.Count -eq 0)  { "<em>vazio</em>" } else { $wip.board.retainer -join ", " }

$gut_cor = if ($gut_score -ge 100) { "#FF4444" } `
           elseif ($gut_score -ge 50) { "#FF8800" } `
           elseif ($gut_score -ge 20) { "#FFCC00" } `
           else { "#00CC66" }

# --- VEREDITO BINARIO --- (exibido quando GUT >= 20)
$veredito_html = ""
if ($gut_score -ge 20) {

    # Determinar opcoes com base no estado do board
    if ($gut_score -ge 100) {
        $vd_titulo = "EMERGENCIA — Acao imediata requerida"
        $opcA_titulo = "ESTANCAR (Agilidade)"
        $opcA_foco   = "Pausar todos os projetos e resolver o bloqueio critico agora"
        $opcA_roi    = "Evita perda de cliente / dado critico"
        $opcA_prazo  = "Hoje"
        $opcB_titulo = "ESCALAR (Robustez)"
        $opcB_foco   = "Acionar protocolo de emergencia completo com documentacao"
        $opcB_roi    = "Protege arquitetura, evita reincidencia"
        $opcB_prazo  = "24h"
    } elseif ($wip.board.discovery.Count -gt 0 -and $slots_livres -gt 0) {
        $proximo_cliente = $wip.board.discovery[0]
        $vd_titulo = "Proximo passo: $proximo_cliente"
        $opcA_titulo = "AVANCAR (MVP)"
        $opcA_foco   = "Iniciar BUILD de $proximo_cliente com escopo minimo — entrega em 48h"
        $opcA_roi    = "Primeiro resultado visivel rapido"
        $opcA_prazo  = "2 dias"
        $opcB_titulo = "APROFUNDAR (IP)"
        $opcB_foco   = "Completar Discovery de $proximo_cliente antes de BUILD — mais dados"
        $opcB_roi    = "Menor risco de retrabalho, arquitetura mais solida"
        $opcB_prazo  = "4 dias"
    } elseif ($wip.board.build.Count -gt 0) {
        $cliente_build = $wip.board.build[0]
        $vd_titulo = "Projeto em BUILD: $cliente_build"
        $opcA_titulo = "ENTREGAR (MVP)"
        $opcA_foco   = "Fechar $cliente_build com o escopo atual e fazer handoff"
        $opcA_roi    = "Libera slot BUILD, gera receita"
        $opcA_prazo  = "1-2 dias"
        $opcB_titulo = "EXPANDIR (Qualidade)"
        $opcB_foco   = "Adicionar modulo extra em $cliente_build antes do handoff"
        $opcB_roi    = "Maior satisfacao do cliente, ticket de upsell"
        $opcB_prazo  = "3-4 dias"
    } else {
        $vd_titulo = "Expansao comercial"
        $opcA_titulo = "PROSPECTAR (Agilidade)"
        $opcA_foco   = "Rodar prospectar.ps1 — 10 contatos hoje"
        $opcA_roi    = "Pipeline de leads imediato"
        $opcA_prazo  = "Hoje"
        $opcB_titulo = "PREPARAR (IP)"
        $opcB_foco   = "Refinar proposta comercial e materiais antes de prospectar"
        $opcB_roi    = "Maior taxa de conversao"
        $opcB_prazo  = "2 dias"
    }

    # mailto links (funcional agora — webhook FastAPI substituira em V-next)
    $mailto_a = "mailto:$ALERT_FROM?subject=VEREDITO%3A%20A%20--%20$([System.Uri]::EscapeDataString($vd_titulo))&body=VEREDITO%3A%20A"
    $mailto_b = "mailto:$ALERT_FROM?subject=VEREDITO%3A%20B%20--%20$([System.Uri]::EscapeDataString($vd_titulo))&body=VEREDITO%3A%20B"

    $veredito_html = @"
<div style="margin-top:28px;border:2px solid #00F0FF;border-radius:8px;overflow:hidden;">
  <div style="background:#00F0FF;padding:10px 16px;">
    <span style="color:#0A0A0A;font-weight:bold;font-size:13px;">⚖️ VEREDITO BINARIO — $vd_titulo</span>
  </div>
  <div style="display:flex;background:#111;">
    <div style="flex:1;padding:16px;border-right:1px solid #333;">
      <div style="color:#FF6B6B;font-weight:bold;margin-bottom:8px;">🔴 OPCAO A — $opcA_titulo</div>
      <div style="color:#ccc;font-size:12px;margin-bottom:6px;"><strong>Foco:</strong> $opcA_foco</div>
      <div style="color:#ccc;font-size:12px;margin-bottom:6px;"><strong>ROI:</strong> $opcA_roi</div>
      <div style="color:#ccc;font-size:12px;margin-bottom:12px;"><strong>Prazo:</strong> $opcA_prazo</div>
      <a href="$mailto_a" style="display:inline-block;background:#FF6B6B;color:#fff;padding:8px 16px;border-radius:4px;text-decoration:none;font-weight:bold;font-size:12px;">APROVAR A</a>
    </div>
    <div style="flex:1;padding:16px;">
      <div style="color:#5B9BF5;font-weight:bold;margin-bottom:8px;">🔵 OPCAO B — $opcB_titulo</div>
      <div style="color:#ccc;font-size:12px;margin-bottom:6px;"><strong>Foco:</strong> $opcB_foco</div>
      <div style="color:#ccc;font-size:12px;margin-bottom:6px;"><strong>ROI:</strong> $opcB_roi</div>
      <div style="color:#ccc;font-size:12px;margin-bottom:12px;"><strong>Prazo:</strong> $opcB_prazo</div>
      <a href="$mailto_b" style="display:inline-block;background:#5B9BF5;color:#fff;padding:8px 16px;border-radius:4px;text-decoration:none;font-weight:bold;font-size:12px;">APROVAR B</a>
    </div>
  </div>
  <div style="background:#0d0d0d;padding:8px 16px;text-align:center;font-size:11px;color:#666;">
    Responda com A ou B — webhook FastAPI em implantacao (V-next)
  </div>
</div>
"@
}

# --- HTML COMPLETO ---
$build_html = if ($wip.board.build.Count -eq 0) {
    "<em style='color:#666'>vazio</em>"
} else {
    $linhas_html = @()
    foreach ($cliente in $wip.board.build) {
        if ($timestamps.ContainsKey($cliente)) {
            $dias   = ([datetime]::Today - [datetime]::ParseExact($timestamps[$cliente], "yyyy-MM-dd", $null)).Days
            $alerta = if ($dias -ge 4) { " <span style='color:#FF4444'>[Circuit Breaker]</span>" } else { "" }
            $linhas_html += "<span style='color:#00F0FF'>$cliente</span> — Dia $dias$alerta"
        } else {
            $linhas_html += "<span style='color:#00F0FF'>$cliente</span>"
        }
    }
    $linhas_html -join "<br>"
}

$acoes_html = if ($acoes.Count -eq 0) {
    "<span style='color:#00CC66'>Nenhuma acao pendente. Board em ordem.</span>"
} else {
    ($acoes | Select-Object -Unique | ForEach-Object { "• $_" }) -join "<br>"
}

$gut_razoes_html = if ($gut_razoes.Count -eq 0) {
    "<span style='color:#00CC66'>Sem fatores de risco ativos.</span>"
} else {
    ($gut_razoes | Select-Object -Unique | ForEach-Object { "• $_" }) -join "<br>"
}

$assunto = "[QUADRILATERAL IAH] Despacho Matinal -- $hoje -- GUT $gut_score ($gut_nivel)"
$corpo_html = @"
<!DOCTYPE html>
<html>
<body style="margin:0;padding:20px;background:#0A0A0A;font-family:'Courier New',monospace;color:#e0e0e0;">
<div style="max-width:600px;margin:0 auto;">

  <div style="border-bottom:2px solid #00F0FF;padding-bottom:12px;margin-bottom:20px;">
    <div style="color:#00F0FF;font-size:11px;letter-spacing:2px;">QUADRILATERAL IAH</div>
    <div style="font-size:18px;font-weight:bold;color:#fff;">Despacho Matinal</div>
    <div style="color:#666;font-size:12px;">$hoje</div>
  </div>

  <table style="width:100%;border-collapse:collapse;margin-bottom:20px;">
    <tr style="background:#111;">
      <td style="padding:10px;border:1px solid #222;color:#888;font-size:11px;width:30%">DISCOVERY</td>
      <td style="padding:10px;border:1px solid #222;font-size:12px;">$disc_txt</td>
    </tr>
    <tr>
      <td style="padding:10px;border:1px solid #222;color:#888;font-size:11px;">BUILD</td>
      <td style="padding:10px;border:1px solid #222;font-size:12px;">$build_html</td>
    </tr>
    <tr style="background:#111;">
      <td style="padding:10px;border:1px solid #222;color:#888;font-size:11px;">CHECK</td>
      <td style="padding:10px;border:1px solid #222;font-size:12px;">$check_txt</td>
    </tr>
    <tr>
      <td style="padding:10px;border:1px solid #222;color:#888;font-size:11px;">ENTREGUE</td>
      <td style="padding:10px;border:1px solid #222;font-size:12px;">$entregue_txt</td>
    </tr>
    <tr style="background:#111;">
      <td style="padding:10px;border:1px solid #222;color:#888;font-size:11px;">RETAINER</td>
      <td style="padding:10px;border:1px solid #222;font-size:12px;">$retainer_txt</td>
    </tr>
    <tr>
      <td style="padding:10px;border:1px solid #222;color:#888;font-size:11px;">INTELIGENCIA</td>
      <td style="padding:10px;border:1px solid #222;font-size:12px;">
        <span style="color:#00F0FF;">$principios_ativos principio(s) ativo(s)</span> no LEDGER
        $(if ($kg_data) { "· Sessoes: $($kg_data.meta.total_sessions)" })
      </td>
    </tr>
    <tr style="background:#111;">
      <td style="padding:10px;border:1px solid #222;color:#888;font-size:11px;">CAPACIDADE</td>
      <td style="padding:10px;border:1px solid #222;font-size:12px;">$($wip.board.build.Count)/$($wip.wip_limits.build) — $capacidade_label</td>
    </tr>
  </table>

  <div style="background:#111;border:1px solid #222;border-radius:6px;padding:16px;margin-bottom:20px;">
    <div style="color:#888;font-size:11px;letter-spacing:1px;margin-bottom:10px;">SCORE GUT SEMANAL</div>
    <div style="font-size:28px;font-weight:bold;color:$gut_cor;margin-bottom:4px;">$gut_score</div>
    <div style="color:$gut_cor;font-size:12px;margin-bottom:10px;">$gut_nivel — G$gut_gravidade × U$gut_urgencia × T$gut_tendencia</div>
    <div style="color:#888;font-size:11px;">$gut_razoes_html</div>
  </div>

  <div style="background:#111;border:1px solid #222;border-radius:6px;padding:16px;margin-bottom:20px;">
    <div style="color:#888;font-size:11px;letter-spacing:1px;margin-bottom:10px;">ACOES PENDENTES</div>
    <div style="font-size:12px;line-height:1.6;">$acoes_html</div>
  </div>

  $veredito_html

  <div style="margin-top:24px;padding-top:12px;border-top:1px solid #222;text-align:center;color:#444;font-size:10px;">
    Conselho Quadrilateral IAH · O Conselho esta de plantao.
  </div>

</div>
</body>
</html>
"@

try {
    $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object Net.NetworkCredential($ALERT_FROM, $SENHA_ATIVA)
    $msg = New-Object Net.Mail.MailMessage
    $msg.From       = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject    = $assunto
    $msg.Body       = $corpo_html
    $msg.IsBodyHtml = $true
    $smtp.Send($msg)
    Write-Log "BRIEFING MATINAL ENVIADO -- $hoje (GUT $gut_score -- $gut_nivel)"
} catch {
    Write-Log "ERRO briefing: $_"
}
