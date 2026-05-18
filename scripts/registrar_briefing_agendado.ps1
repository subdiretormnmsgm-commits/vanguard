# ============================================================
# REGISTRAR_BRIEFING_AGENDADO.PS1 — Setup único
# Agenda briefing_diario.ps1 para rodar todo dia às 7h
# Executar UMA VEZ como Administrador
# ============================================================

$BASE       = Split-Path -Parent $PSScriptRoot
$scriptPath = "$BASE\scripts\briefing_diario.ps1"
$taskName   = "Quadrilateral_Briefing_Diario"

$action  = New-ScheduledTaskAction -Execute "powershell.exe" `
           -Argument "-NonInteractive -WindowStyle Hidden -File `"$scriptPath`""

$trigger = New-ScheduledTaskTrigger -Daily -At "07:00"

$settings = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 2) `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable

Register-ScheduledTask -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -RunLevel Highest `
    -Force

Write-Host ""
Write-Host "✅ Briefing diário agendado para 07:00 todos os dias." -ForegroundColor Green
Write-Host "   Nome da tarefa: $taskName" -ForegroundColor Gray
Write-Host "   Para rodar agora: Start-ScheduledTask -TaskName '$taskName'" -ForegroundColor Gray
Write-Host ""
