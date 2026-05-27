#Requires -Version 5.1
# registrar_churnwatch.ps1 -- Registra ChurnWatch_Vanguard no Task Scheduler
# Nao requer Admin -- RunLevel Limited, usuario atual.
# Uso: .\scripts\registrar_churnwatch.ps1

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$raiz   = Split-Path -Parent $PSScriptRoot
$script = "$raiz\scripts\churn_watch_autonomo.ps1"
$user   = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

Write-Host ""
Write-Host "======================================================="
Write-Host "  REGISTRAR ChurnWatch_Vanguard"
Write-Host "======================================================="
Write-Host "  Usuario: $user"
Write-Host "  Script : $script"
Write-Host "  Horario: 08:00 diario"
Write-Host ""

$taskExiste = Get-ScheduledTask -TaskName "ChurnWatch_Vanguard" -ErrorAction SilentlyContinue
if ($taskExiste) {
    Write-Host "  [OK] Ja registrada -- State: $($taskExiste.State)" -ForegroundColor Green
    $info = Get-ScheduledTaskInfo -TaskName "ChurnWatch_Vanguard" -ErrorAction SilentlyContinue
    if ($info) { Write-Host "  Proxima execucao: $($info.NextRunTime)" -ForegroundColor DarkGray }
    exit 0
}

try {
    $action    = New-ScheduledTaskAction -Execute "powershell.exe" `
                 -Argument "-NonInteractive -WindowStyle Hidden -File `"$script`""
    $trigger   = New-ScheduledTaskTrigger -Daily -At "08:00"
    $settings  = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 5) `
                 -StartWhenAvailable -DontStopOnIdleEnd
    $principal = New-ScheduledTaskPrincipal -UserId $user -RunLevel Limited -LogonType Interactive

    Register-ScheduledTask -TaskName "ChurnWatch_Vanguard" `
        -Action $action -Trigger $trigger -Settings $settings `
        -Principal $principal -Force -ErrorAction Stop | Out-Null

    $info = Get-ScheduledTaskInfo -TaskName "ChurnWatch_Vanguard" -ErrorAction SilentlyContinue
    Write-Host "  [OK] ChurnWatch_Vanguard registrado com sucesso" -ForegroundColor Green
    if ($info) { Write-Host "  Proxima execucao: $($info.NextRunTime)" -ForegroundColor DarkGray }
} catch {
    Write-Host "  [ERRO] Falha ao registrar: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  Alternativa: schtasks /create /tn ChurnWatch_Vanguard /sc daily /st 08:00 /f" -ForegroundColor Yellow
    exit 1
}

Write-Host "======================================================="
Write-Host ""
