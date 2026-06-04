# registrar_ping_valdece.ps1
# Registra ping Supabase Valdece no Task Scheduler -- a cada 5 dias

$TASK_NAME = 'Vanguard_Ping_Supabase_Valdece'
$SCRIPT    = (Resolve-Path "$PSScriptRoot\ping_supabase_valdece.ps1").Path
$PS_EXE    = 'powershell.exe'

Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:$false -ErrorAction SilentlyContinue

$trigger  = New-ScheduledTaskTrigger -Daily -DaysInterval 5 -At '09:00AM'
$action   = New-ScheduledTaskAction -Execute $PS_EXE -Argument ('-ExecutionPolicy Bypass -NonInteractive -File "' + $SCRIPT + '"')
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 2) -RunOnlyIfNetworkAvailable -StartWhenAvailable

Register-ScheduledTask -TaskName $TASK_NAME -Trigger $trigger -Action $action -Settings $settings -Description 'Mantém projeto Supabase Valdece ativo' -RunLevel Limited -Force | Out-Null

Write-Host '[OK] Task registrada -- executa a cada 5 dias as 09:00'
Write-Host ('     Script: ' + $SCRIPT)
Write-Host ''
Write-Host '[TESTE] Rodando ping agora...'
& $PS_EXE -ExecutionPolicy Bypass -NonInteractive -File $SCRIPT
