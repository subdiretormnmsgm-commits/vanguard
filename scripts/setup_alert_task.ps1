# ============================================================
# SETUP_ALERT_TASK.PS1 — Registra o monitor no Task Scheduler
# Executar UMA VEZ como Administrador
# Uso: .\scripts\setup_alert_task.ps1
# ============================================================

$TASK_NAME   = "Pentalateral_WIP_Monitor"
$SCRIPT_PATH = "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard\scripts\alert_wip_monitor.ps1"

Write-Host ""
Write-Host "Registrando tarefa: $TASK_NAME" -ForegroundColor Cyan

# Remover tarefa anterior se existir
Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:$false -ErrorAction SilentlyContinue

# Ação: executar o script PowerShell
$acao = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NonInteractive -WindowStyle Hidden -File `"$SCRIPT_PATH`""

# Gatilho: repetir a cada 5 minutos, indefinidamente
$gatilho = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 5) -Once -At (Get-Date)

# Configurações: rodar mesmo sem estar logado, não parar se em bateria
$settings = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 2) `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1)

# Principal: rodar com o usuário atual
$principal = New-ScheduledTaskPrincipal `
    -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) `
    -LogonType Interactive `
    -RunLevel Highest

# Registrar
Register-ScheduledTask `
    -TaskName $TASK_NAME `
    -Action $acao `
    -Trigger $gatilho `
    -Settings $settings `
    -Principal $principal `
    -Description "Pentalateral IAH — Monitor do WIP_BOARD. Alerta por email quando novo cliente aparece." `
    -Force

Write-Host ""
Write-Host "Tarefa registrada com sucesso." -ForegroundColor Green
Write-Host "Monitorando a cada 5 minutos." -ForegroundColor Green

# ============================================================
# TASK 2 — Despacho Matinal (todo dia as 07:00)
# ============================================================

$TASK_BRIEFING   = "Pentalateral_Despacho_Matinal"
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
    -Description "Pentalateral IAH — Despacho Matinal do Conselho. Score GUT + estado do board todo dia as 07:00." `
    -Force

Write-Host "Tarefa '$TASK_BRIEFING' registrada com sucesso." -ForegroundColor Green
Write-Host "Despacho Matinal: todo dia as 07:00" -ForegroundColor Green

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  TASKS REGISTRADAS:" -ForegroundColor Cyan
Write-Host "  1. $TASK_NAME — a cada 5 minutos (eventos urgentes)" -ForegroundColor Green
Write-Host "  2. $TASK_BRIEFING — diariamente as 07:00 (Score GUT + board)" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para verificar: Abrir Task Scheduler e buscar as duas tasks." -ForegroundColor Yellow
Write-Host "Log em: scripts\alert_monitor.log" -ForegroundColor Yellow
Write-Host ""
