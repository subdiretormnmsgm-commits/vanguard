# ============================================================
# SETUP_ALERT_TASK.PS1 — Registra o monitor no Task Scheduler
# Executar UMA VEZ como Administrador
# Uso: .\scripts\setup_alert_task.ps1
# ============================================================

$TASK_NAME   = "Quadrilateral_WIP_Monitor"
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
    -Description "Quadrilateral IAH — Monitor do WIP_BOARD. Alerta por email quando novo cliente aparece." `
    -Force

Write-Host ""
Write-Host "Tarefa registrada com sucesso." -ForegroundColor Green
Write-Host "Monitorando a cada 5 minutos." -ForegroundColor Green
Write-Host ""
Write-Host "Para verificar: Abrir Task Scheduler e buscar '$TASK_NAME'" -ForegroundColor Yellow
Write-Host "Log em: scripts\alert_monitor.log" -ForegroundColor Yellow
Write-Host ""
