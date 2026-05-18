# ============================================================
# REGISTRAR_BRIEFING_AGENDADO.PS1 — Setup único
# Agenda 3 notificações diárias via Telegram + e-mail:
#   07:00 — Briefing completo (briefing_diario.ps1)
#   13:00 — Check-in da tarde com gates e alertas (lembrete_tarde.ps1)
# Executar UMA VEZ como Administrador
# ============================================================

$BASE         = Split-Path -Parent $PSScriptRoot
$scriptManha  = "$BASE\scripts\briefing_diario.ps1"
$scriptTarde  = "$BASE\scripts\lembrete_tarde.ps1"

$settings = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 3) `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable

# ── Tarefa 1: Briefing matinal 07:00 ──────────────────────
$actionManha  = New-ScheduledTaskAction -Execute "powershell.exe" `
                -Argument "-NonInteractive -WindowStyle Hidden -File `"$scriptManha`""
$triggerManha = New-ScheduledTaskTrigger -Daily -At "07:00"

Register-ScheduledTask -TaskName "Pentalateral_Briefing_Manha" `
    -Action $actionManha `
    -Trigger $triggerManha `
    -Settings $settings `
    -RunLevel Highest `
    -Force | Out-Null

# ── Tarefa 2: Check-in da tarde 13:00 ─────────────────────
$actionTarde  = New-ScheduledTaskAction -Execute "powershell.exe" `
                -Argument "-NonInteractive -WindowStyle Hidden -File `"$scriptTarde`""
$triggerTarde = New-ScheduledTaskTrigger -Daily -At "13:00"

Register-ScheduledTask -TaskName "Pentalateral_Lembrete_Tarde" `
    -Action $actionTarde `
    -Trigger $triggerTarde `
    -Settings $settings `
    -RunLevel Highest `
    -Force | Out-Null

Write-Host ""
Write-Host "✅ Notificações diárias registradas no Task Scheduler:" -ForegroundColor Green
Write-Host "   07:00 — Pentalateral_Briefing_Manha  (briefing_diario.ps1)"   -ForegroundColor White
Write-Host "   13:00 — Pentalateral_Lembrete_Tarde  (lembrete_tarde.ps1)"    -ForegroundColor White
Write-Host ""
Write-Host "Ambas enviam via Telegram + e-mail. Telegram garante entrega" -ForegroundColor Gray
Write-Host "mesmo se o computador estiver desligado na hora agendada." -ForegroundColor Gray
Write-Host ""
Write-Host "Para testar agora:" -ForegroundColor Yellow
Write-Host "  Start-ScheduledTask -TaskName 'Pentalateral_Briefing_Manha'" -ForegroundColor White
Write-Host "  Start-ScheduledTask -TaskName 'Pentalateral_Lembrete_Tarde'" -ForegroundColor White
Write-Host ""
