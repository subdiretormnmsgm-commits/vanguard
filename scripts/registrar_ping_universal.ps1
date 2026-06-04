# registrar_ping_universal.ps1
# Registra o ping universal Supabase no Task Scheduler -- a cada 5 dias

$TASK_NAME = 'Vanguard_Ping_Supabase_Universal'
$SCRIPT    = (Resolve-Path "$PSScriptRoot\ping_supabase_universal.ps1").Path
$PS_EXE    = 'powershell.exe'

Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName 'Vanguard_Ping_Supabase_Valdece' -Confirm:$false -ErrorAction SilentlyContinue

$trigger  = New-ScheduledTaskTrigger -Daily -DaysInterval 5 -At '09:00AM'
$action   = New-ScheduledTaskAction -Execute $PS_EXE -Argument ('-ExecutionPolicy Bypass -NonInteractive -File "' + $SCRIPT + '"')
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 3) -RunOnlyIfNetworkAvailable -StartWhenAvailable

Register-ScheduledTask -TaskName $TASK_NAME -Trigger $trigger -Action $action -Settings $settings -Description 'Ping universal -- mantém todos os projetos Supabase ativos' -RunLevel Limited -Force | Out-Null

Write-Host ('[OK] Task ' + $TASK_NAME + ' registrada -- a cada 5 dias as 09:00')
Write-Host ('[OK] Task Vanguard_Ping_Supabase_Valdece removida -- substituida pela universal')
Write-Host ''
Write-Host '[TESTE] Rodando ping agora...'
& $PS_EXE -ExecutionPolicy Bypass -NonInteractive -File $SCRIPT
