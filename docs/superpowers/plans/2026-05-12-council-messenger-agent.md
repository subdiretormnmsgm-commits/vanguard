# Council Messenger Agent — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Expandir o monitor existente e criar um briefing diário para que o Conselho fale proativamente com o Diretor via email sobre tudo que requer sua atenção.

**Architecture:** Dois scripts PowerShell — `alert_wip_monitor.ps1` (expandido, roda a cada 5 min via Task Scheduler existente) e `alert_daily_briefing.ps1` (novo, roda às 07:00). Três arquivos de estado em `CLIENTES/` rastreiam o que já foi notificado para evitar spam. Reutiliza credenciais Gmail de `scripts/alert_config.ps1`.

**Tech Stack:** PowerShell 5.1, Net.Mail.SmtpClient (Gmail SMTP TLS 587), JSON para estado persistido, Windows Task Scheduler.

---

## Mapa de Arquivos

| Arquivo | Ação | Responsabilidade |
|---|---|---|
| `scripts/alert_wip_monitor.ps1` | Modificar | Adicionar detecção de slot liberado, Circuit Breaker e Sentinel FIRE |
| `scripts/alert_daily_briefing.ps1` | Criar | Despacho matinal consolidado do Conselho |
| `scripts/setup_alert_task.ps1` | Modificar | Registrar segunda Task (briefing diário às 07:00) |
| `CLIENTES/.build_timestamps.json` | Auto-criado pelo script | Data de entrada em BUILD por cliente |
| `CLIENTES/.sentinel_fire_notified.json` | Auto-criado pelo script | FIRE Events já notificados |

---

## Task 1: Adicionar gerenciamento de `.build_timestamps.json` ao monitor

**Arquivos:**
- Modificar: `scripts/alert_wip_monitor.ps1`

Este bloco deve ser inserido logo após a leitura do `$wip` e antes da lógica de detecção de novos clientes.

- [ ] **Passo 1: Definir path e carregar timestamps**

Localizar a linha `$wip = Get-Content $WIP_PATH -Raw | ConvertFrom-Json` (linha ~37) e inserir logo após:

```powershell
# --- Gerenciar timestamps de BUILD ---
$TIMESTAMPS_PATH = "$BASE\CLIENTES\.build_timestamps.json"
$FIRE_NOTIFIED_PATH = "$BASE\CLIENTES\.sentinel_fire_notified.json"

$timestamps = @{}
if (Test-Path $TIMESTAMPS_PATH) {
    $ts_raw = Get-Content $TIMESTAMPS_PATH -Raw | ConvertFrom-Json
    $ts_raw.PSObject.Properties | ForEach-Object { $timestamps[$_.Name] = $_.Value }
}

$fire_notified = @{}
if (Test-Path $FIRE_NOTIFIED_PATH) {
    $fn_raw = Get-Content $FIRE_NOTIFIED_PATH -Raw | ConvertFrom-Json
    $fn_raw.PSObject.Properties | ForEach-Object { $fire_notified[$_.Name] = $_.Value }
}
```

- [ ] **Passo 2: Sincronizar timestamps com clientes em BUILD**

Inserir logo após o bloco acima:

```powershell
# Adicionar clientes novos em BUILD aos timestamps
foreach ($cliente in $wip.board.build) {
    if (-not $timestamps.ContainsKey($cliente)) {
        $timestamps[$cliente] = (Get-Date -Format "yyyy-MM-dd")
        Write-Log "TIMESTAMP registrado — '$cliente' entrou em BUILD em $($timestamps[$cliente])"
    }
}

# Remover clientes que saíram de BUILD dos timestamps
$keys_to_remove = $timestamps.Keys | Where-Object { $_ -notin $wip.board.build }
foreach ($key in $keys_to_remove) {
    $timestamps.Remove($key)
    Write-Log "TIMESTAMP removido — '$key' saiu de BUILD"
}

# Salvar timestamps atualizados
$timestamps | ConvertTo-Json | Out-File -FilePath $TIMESTAMPS_PATH -Encoding utf8
```

- [ ] **Passo 3: Verificar manualmente**

Adicionar um cliente temporário no `CLIENTES\WIP_BOARD.json` em `build`:
```json
"build": ["TesteCB"]
```
Executar: `.\scripts\alert_wip_monitor.ps1`
Verificar: `CLIENTES\.build_timestamps.json` deve conter `{"TesteCB": "2026-05-12"}`.
Remover `TesteCB` do board após verificação.

- [ ] **Passo 4: Commit**

```powershell
git add scripts/alert_wip_monitor.ps1
git commit -m "feat(monitor): gerenciamento de timestamps de BUILD"
```

---

## Task 2: Adicionar detecção de slot BUILD liberado

**Arquivos:**
- Modificar: `scripts/alert_wip_monitor.ps1`

- [ ] **Passo 1: Adicionar detecção após o bloco de novos clientes**

Localizar o bloco que salva o novo estado (`$novo_estado = ...`) — está no final do arquivo (linha ~118). Inserir **antes** desse bloco:

```powershell
# --- Detectar slot BUILD liberado ---
$build_anterior = if ($ultimo_estado.board_build) { $ultimo_estado.board_build } else { @() }
$build_atual    = $wip.board.build

$saiu_de_build = $build_anterior | Where-Object { $_ -notin $build_atual }

foreach ($cliente in $saiu_de_build) {
    $slots_livres = $wip.wip_limits.build - $build_atual.Count
    $assunto = "[QUADRILATERAL IAH] Músculo → Slot BUILD liberado — pipeline pode avançar"
    $corpo = @"
QUADRILATERAL IAH — DESPACHO DO MÚSCULO
=========================================

Diretor Eduardo,

$cliente saiu de BUILD. Capacidade disponível: $($build_atual.Count)/$($wip.wip_limits.build) slots.

BOARD ATUAL:
  Discovery : $(if ($wip.board.discovery.Count -eq 0) { "— vazio" } else { $wip.board.discovery -join ", " })
  Build     : $(if ($build_atual.Count -eq 0) { "— vazio" } else { $build_atual -join ", " })

Se há alguém em DISCOVERY aprovado, dê o sinal para entrar em BUILD.

=========================================
Músculo (Claude Code) · Quadrilateral IAH
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
        Write-Log "EMAIL ENVIADO — Slot BUILD liberado por '$cliente'"
    } catch {
        Write-Log "ERRO slot-liberado: $_"
    }
}
```

- [ ] **Passo 2: Salvar `board_build` no estado persistido**

Localizar a linha:
```powershell
$novo_estado = @{ clientes = $ativos; atualizado = (Get-Date -Format "yyyy-MM-dd HH:mm") }
```
Substituir por:
```powershell
$novo_estado = @{
    clientes    = $ativos
    board_build = [array]$wip.board.build
    atualizado  = (Get-Date -Format "yyyy-MM-dd HH:mm")
}
```

- [ ] **Passo 3: Verificar manualmente**

Adicionar `"TestSlot"` ao `build` no WIP_BOARD, executar o monitor (registra estado).
Remover `"TestSlot"` do build, executar novamente.
Verificar: email recebido com assunto `Slot BUILD liberado`.

- [ ] **Passo 4: Commit**

```powershell
git add scripts/alert_wip_monitor.ps1
git commit -m "feat(monitor): detecção de slot BUILD liberado"
```

---

## Task 3: Adicionar Circuit Breaker (Dia 4+ sem MVP)

**Arquivos:**
- Modificar: `scripts/alert_wip_monitor.ps1`

- [ ] **Passo 1: Inserir detecção de Circuit Breaker após o bloco de slot liberado**

```powershell
# --- Circuit Breaker — Dia 4+ em BUILD sem sentinel válido ---
$hoje = Get-Date

foreach ($cliente in $wip.board.build) {
    if (-not $timestamps.ContainsKey($cliente)) { continue }

    $data_entrada  = [datetime]::ParseExact($timestamps[$cliente], "yyyy-MM-dd", $null)
    $dias_em_build = ($hoje - $data_entrada).Days
    $sentinel_path = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    $sentinel_ok   = Test-Path $sentinel_path

    if ($dias_em_build -ge 4 -and -not $sentinel_ok) {
        # Verificar se já alertou hoje
        $chave_cb   = "${cliente}_circuit_breaker"
        $ultimo_alerta = if ($fire_notified.ContainsKey($chave_cb)) { $fire_notified[$chave_cb] } else { "" }
        $ja_alertou_hoje = $ultimo_alerta -eq (Get-Date -Format "yyyy-MM-dd")

        if (-not $ja_alertou_hoje) {
            $assunto = "[QUADRILATERAL IAH] AUDITOR → Circuit Breaker: $cliente — Dia $dias_em_build sem MVP"
            $corpo = @"
QUADRILATERAL IAH — DESPACHO DO AUDITOR
=========================================

Diretor,

$cliente está em BUILD há $dias_em_build dias sem MVP entregue.

Score GUT: Gravidade 5 · Urgência 5 · Tendência 5 = PRIORIDADE MÁXIMA

DIAGNÓSTICO: Risco de entrega comprometida. Intervenção necessária.

AÇÃO NECESSÁRIA HOJE:
  → Revisar o appetite com o Músculo
  → Cortar escopo ou redefinir MVP
  → Confirmar nova data de entrega

Sem sua decisão nas próximas 24h, o projeto entra em modo de congelamento.

=========================================
Auditor · Quadrilateral IAH
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
                Write-Log "EMAIL ENVIADO — Circuit Breaker '$cliente' Dia $dias_em_build"
            } catch {
                Write-Log "ERRO circuit-breaker: $_"
            }

            $fire_notified[$chave_cb] = (Get-Date -Format "yyyy-MM-dd")
        }
    }
}

# Salvar fire_notified atualizado
$fire_notified | ConvertTo-Json | Out-File -FilePath $FIRE_NOTIFIED_PATH -Encoding utf8
```

- [ ] **Passo 2: Verificar manualmente**

Editar `.build_timestamps.json` e colocar data de 5 dias atrás para um cliente de teste:
```json
{"TestCB": "2026-05-07"}
```
Garantir que `CLIENTES/TestCB/sentinel_config.json` **não** existe.
Executar: `.\scripts\alert_wip_monitor.ps1`
Verificar: email do Auditor recebido com assunto `Circuit Breaker`.
Remover o cliente de teste dos arquivos após verificação.

- [ ] **Passo 3: Commit**

```powershell
git add scripts/alert_wip_monitor.ps1
git commit -m "feat(monitor): Circuit Breaker — Dia 4+ sem MVP dispara Auditor"
```

---

## Task 4: Adicionar detecção de Sentinel FIRE Event

**Arquivos:**
- Modificar: `scripts/alert_wip_monitor.ps1`

- [ ] **Passo 1: Inserir detecção de FIRE após o Circuit Breaker**

```powershell
# --- Sentinel FIRE Event ---
$todos_clientes = @()
$todos_clientes += $wip.board.discovery
$todos_clientes += $wip.board.build
$todos_clientes += $wip.board.check

foreach ($cliente in $todos_clientes) {
    $sentinel_path = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    if (-not (Test-Path $sentinel_path)) { continue }

    $sentinel = Get-Content $sentinel_path -Raw | ConvertFrom-Json
    if ($sentinel.fire_event -ne $true) { continue }

    # Verificar se já notificou este FIRE
    if ($fire_notified.ContainsKey("${cliente}_fire")) { continue }

    $etapa   = if ($cliente -in $wip.board.build) { "BUILD" } elseif ($cliente -in $wip.board.check) { "CHECK" } else { "DISCOVERY" }
    $assunto = "[QUADRILATERAL IAH] AUDITOR → FIRE Event detectado: $cliente"
    $corpo = @"
QUADRILATERAL IAH — DESPACHO DO AUDITOR
=========================================

Diretor,

O Sentinel de $cliente sinalizou um FIRE Event.

Cliente : $cliente
Etapa   : $etapa
Flag    : fire_event = true em sentinel_config.json

AÇÃO NECESSÁRIA:
  → Acessar CLIENTES\$cliente\sentinel_config.json
  → Avaliar o incidente com o Músculo
  → Definir resposta e remover a flag após resolução

=========================================
Auditor · Quadrilateral IAH
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
        Write-Log "EMAIL ENVIADO — Sentinel FIRE '$cliente'"
    } catch {
        Write-Log "ERRO sentinel-fire: $_"
    }

    $fire_notified["${cliente}_fire"] = (Get-Date -Format "yyyy-MM-dd HH:mm")
}

# Salvar fire_notified (já inclui circuit breaker + fire events)
$fire_notified | ConvertTo-Json | Out-File -FilePath $FIRE_NOTIFIED_PATH -Encoding utf8
```

- [ ] **Passo 2: Verificar manualmente**

Criar `CLIENTES\TestFire\sentinel_config.json`:
```json
{"fire_event": true}
```
Adicionar `"TestFire"` ao `build` no WIP_BOARD.
Executar: `.\scripts\alert_wip_monitor.ps1`
Verificar: email do Auditor com assunto `FIRE Event detectado`.
Executar novamente: nenhum email (anti-spam funcionando).
Limpar arquivos de teste após verificação.

- [ ] **Passo 3: Commit**

```powershell
git add scripts/alert_wip_monitor.ps1
git commit -m "feat(monitor): Sentinel FIRE Event — Auditor notifica Diretor"
```

---

## Task 5: Criar `alert_daily_briefing.ps1`

**Arquivos:**
- Criar: `scripts/alert_daily_briefing.ps1`

- [ ] **Passo 1: Criar o script completo**

```powershell
# ============================================================
# ALERT_DAILY_BRIEFING.PS1 — Despacho Matinal do Conselho
# Roda via Task Scheduler todo dia às 07:00
# ============================================================

$BASE        = Split-Path -Parent $PSScriptRoot
$WIP_PATH    = "$BASE\CLIENTES\WIP_BOARD.json"
$CONFIG_PATH = "$BASE\scripts\alert_config.ps1"
$LOG_PATH    = "$BASE\scripts\alert_monitor.log"
$TIMESTAMPS_PATH = "$BASE\CLIENTES\.build_timestamps.json"

function Write-Log {
    param([string]$msg)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $msg" | Out-File -FilePath $LOG_PATH -Append -Encoding utf8
}

if (-not (Test-Path $CONFIG_PATH)) { Write-Log "ERRO: alert_config.ps1 não encontrado."; exit 1 }
. $CONFIG_PATH
if ($ALERT_SENHA -eq "COLAR_SENHA_DE_APP_AQUI") { Write-Log "AVISO: Senha não configurada."; exit 1 }
if (-not (Test-Path $WIP_PATH)) { Write-Log "AVISO: WIP_BOARD.json não encontrado."; exit 0 }

$wip  = Get-Content $WIP_PATH -Raw | ConvertFrom-Json
$hoje = Get-Date -Format "dd/MM/yyyy"

# Carregar timestamps
$timestamps = @{}
if (Test-Path $TIMESTAMPS_PATH) {
    $ts_raw = Get-Content $TIMESTAMPS_PATH -Raw | ConvertFrom-Json
    $ts_raw.PSObject.Properties | ForEach-Object { $timestamps[$_.Name] = $_.Value }
}

# Formatar lista de BUILD com dias
function Format-BuildList {
    param($clientes)
    if ($clientes.Count -eq 0) { return "— vazio" }
    $result = @()
    foreach ($c in $clientes) {
        if ($timestamps.ContainsKey($c)) {
            $dias = ([datetime]::Today - [datetime]::ParseExact($timestamps[$c], "yyyy-MM-dd", $null)).Days
            $result += "  · $c — Dia $dias"
        } else {
            $result += "  · $c"
        }
    }
    return $result -join "`n"
}

function Format-List {
    param($clientes)
    if ($clientes.Count -eq 0) { return "— vazio" }
    return ($clientes | ForEach-Object { "  · $_" }) -join "`n"
}

# Calcular ações pendentes
$acoes = @()

foreach ($cliente in $wip.board.build) {
    # Circuit Breaker
    if ($timestamps.ContainsKey($cliente)) {
        $dias = ([datetime]::Today - [datetime]::ParseExact($timestamps[$cliente], "yyyy-MM-dd", $null)).Days
        if ($dias -ge 4) {
            $sentinel_path = "$BASE\CLIENTES\$cliente\sentinel_config.json"
            if (-not (Test-Path $sentinel_path)) {
                $acoes += "  · $cliente em BUILD há $dias dias sem MVP — intervenção necessária"
            }
        }
    }
    # Sentinel não configurado
    $sentinel_path = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    if (-not (Test-Path $sentinel_path)) {
        $acoes += "  · Sentinel de $cliente não configurado — configurar antes do handoff"
    }
    # Playbook pendente
    $playbook_path = "$BASE\CLIENTES\$cliente\SOVEREIGN_PLAYBOOK.pdf"
    $playbook_md   = "$BASE\CLIENTES\$cliente\SOVEREIGN_PLAYBOOK.md"
    if (-not (Test-Path $playbook_path) -and -not (Test-Path $playbook_md)) {
        $acoes += "  · Playbook de $cliente pendente — gerar antes de ENTREGUE"
    }
}

foreach ($cliente in ($wip.board.build + $wip.board.check + $wip.board.discovery)) {
    $sentinel_path = "$BASE\CLIENTES\$cliente\sentinel_config.json"
    if (Test-Path $sentinel_path) {
        $s = Get-Content $sentinel_path -Raw | ConvertFrom-Json
        if ($s.fire_event -eq $true) {
            $acoes += "  · FIRE Event ativo em $cliente — resolver urgente"
        }
    }
}

$acoes_texto = if ($acoes.Count -eq 0) {
    "  Nenhuma ação pendente. Board em ordem."
} else {
    ($acoes | Select-Object -Unique) -join "`n"
}

$slots_livres  = $wip.wip_limits.build - $wip.board.build.Count
$capacidade_label = if ($slots_livres -gt 0) { "LIVRE ($slots_livres slot(s))" } else { "CHEIO" }

$assunto = "[QUADRILATERAL IAH] Despacho Matinal — $hoje"
$corpo = @"
QUADRILATERAL IAH — DESPACHO MATINAL
=========================================

Diretor Eduardo, bom dia.

════════════════════════════════
ESTADO DO BOARD — $hoje
════════════════════════════════

  Discovery : $(if ($wip.board.discovery.Count -eq 0) { "— vazio" } else { $wip.board.discovery -join ", " })
  Build     :
$(Format-BuildList $wip.board.build)
  Check     : $(if ($wip.board.check.Count -eq 0) { "— vazio" } else { $wip.board.check -join ", " })
  Entregue  : $(if ($wip.board.entregue.Count -eq 0) { "— vazio" } else { $wip.board.entregue -join ", " })
  Retainer  : $(if ($wip.board.retainer.Count -eq 0) { "— vazio" } else { $wip.board.retainer -join ", " })

CAPACIDADE:
  Slots BUILD: $($wip.board.build.Count)/$($wip.wip_limits.build) — $capacidade_label

════════════════════════════════
AÇÕES PENDENTES
════════════════════════════════
$acoes_texto

O Conselho está de plantão.

=========================================
Conselho · Quadrilateral IAH
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
    Write-Log "BRIEFING MATINAL ENVIADO — $hoje"
} catch {
    Write-Log "ERRO briefing: $_"
}
```

- [ ] **Passo 2: Verificar manualmente**

```powershell
.\scripts\alert_daily_briefing.ps1
```
Verificar: email recebido com assunto `Despacho Matinal` e estado correto do board.

- [ ] **Passo 3: Commit**

```powershell
git add scripts/alert_daily_briefing.ps1
git commit -m "feat(briefing): Despacho Matinal do Conselho — 07h diário"
```

---

## Task 6: Registrar Task Scheduler para o briefing diário

**Arquivos:**
- Modificar: `scripts/setup_alert_task.ps1`

- [ ] **Passo 1: Adicionar registro da segunda task no final do script**

Localizar o final do arquivo (após o último `Write-Host`) e adicionar:

```powershell
# --- Task 2: Despacho Matinal às 07:00 ---
$TASK_BRIEFING  = "Quadrilateral_Despacho_Matinal"
$SCRIPT_BRIEFING = "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard\scripts\alert_daily_briefing.ps1"

Write-Host ""
Write-Host "Registrando tarefa: $TASK_BRIEFING" -ForegroundColor Cyan

Unregister-ScheduledTask -TaskName $TASK_BRIEFING -Confirm:$false -ErrorAction SilentlyContinue

$acao2 = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NonInteractive -WindowStyle Hidden -File `"$SCRIPT_BRIEFING`""

$gatilho2 = New-ScheduledTaskTrigger -Daily -At "07:00"

$settings2 = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 2) `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1)

$principal2 = New-ScheduledTaskPrincipal `
    -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) `
    -LogonType Interactive `
    -RunLevel Highest

Register-ScheduledTask `
    -TaskName $TASK_BRIEFING `
    -Action $acao2 `
    -Trigger $gatilho2 `
    -Settings $settings2 `
    -Principal $principal2 `
    -Description "Quadrilateral IAH — Despacho Matinal do Conselho. Envia estado do board todo dia às 07:00." `
    -Force

Write-Host "Tarefa '$TASK_BRIEFING' registrada com sucesso." -ForegroundColor Green
Write-Host "Despacho Matinal: todo dia às 07:00" -ForegroundColor Green
```

- [ ] **Passo 2: Executar como Administrador**

```powershell
# Abrir PowerShell como Administrador e executar:
.\scripts\setup_alert_task.ps1
```
Verificar: Task Scheduler mostra duas tasks — `Quadrilateral_WIP_Monitor` e `Quadrilateral_Despacho_Matinal`.

- [ ] **Passo 3: Commit**

```powershell
git add scripts/setup_alert_task.ps1
git commit -m "feat(scheduler): Task do Despacho Matinal registrada às 07:00"
```

---

## Task 7: Teste de integração completo

- [ ] **Passo 1: Limpar estado anterior**

```powershell
Remove-Item "CLIENTES\.wip_last_state.json" -ErrorAction SilentlyContinue
Remove-Item "CLIENTES\.build_timestamps.json" -ErrorAction SilentlyContinue
Remove-Item "CLIENTES\.sentinel_fire_notified.json" -ErrorAction SilentlyContinue
```

- [ ] **Passo 2: Testar novo cliente (DISCOVERY)**

Adicionar `"ClienteTeste"` ao `discovery` no WIP_BOARD.
```powershell
.\scripts\alert_wip_monitor.ps1
```
Verificar: email recebido — assunto `Músculo → Novo objeto em DISCOVERY: ClienteTeste`.

- [ ] **Passo 3: Testar Circuit Breaker**

Mover `"ClienteTeste"` de `discovery` para `build` no WIP_BOARD.
Editar `.build_timestamps.json` para data 5 dias atrás:
```json
{"ClienteTeste": "2026-05-07"}
```
```powershell
.\scripts\alert_wip_monitor.ps1
```
Verificar: email do Auditor — assunto `Circuit Breaker: ClienteTeste — Dia 5 sem MVP`.

- [ ] **Passo 4: Testar Sentinel FIRE**

Criar `CLIENTES\ClienteTeste\sentinel_config.json`:
```json
{"fire_event": true}
```
```powershell
.\scripts\alert_wip_monitor.ps1
```
Verificar: email do Auditor — assunto `FIRE Event detectado: ClienteTeste`.

- [ ] **Passo 5: Testar slot liberado**

Remover `"ClienteTeste"` do `build` (mover para `check`).
```powershell
.\scripts\alert_wip_monitor.ps1
```
Verificar: email do Músculo — assunto `Slot BUILD liberado`.

- [ ] **Passo 6: Testar briefing matinal**

```powershell
.\scripts\alert_daily_briefing.ps1
```
Verificar: email do Conselho — assunto `Despacho Matinal` com estado correto.

- [ ] **Passo 7: Limpar tudo**

```powershell
# Restaurar WIP_BOARD ao estado original (sem ClienteTeste)
# Remover CLIENTES\ClienteTeste\ se criado
# Limpar arquivos de estado
Remove-Item "CLIENTES\.wip_last_state.json" -ErrorAction SilentlyContinue
Remove-Item "CLIENTES\.build_timestamps.json" -ErrorAction SilentlyContinue
Remove-Item "CLIENTES\.sentinel_fire_notified.json" -ErrorAction SilentlyContinue
```

- [ ] **Passo 8: Commit final**

```powershell
git add .
git commit -m "test(council-messenger): integração completa validada — todos os triggers funcionando"
```
