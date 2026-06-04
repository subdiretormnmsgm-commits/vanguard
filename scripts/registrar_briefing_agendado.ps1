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
$scriptNoite  = "$BASE\scripts\lembrete_noite.ps1"

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
    -Force | Out-Null

# ── Tarefa 2: Check-in da tarde 13:00 ─────────────────────
$actionTarde  = New-ScheduledTaskAction -Execute "powershell.exe" `
                -Argument "-NonInteractive -WindowStyle Hidden -File `"$scriptTarde`""
$triggerTarde = New-ScheduledTaskTrigger -Daily -At "13:00"

Register-ScheduledTask -TaskName "Pentalateral_Lembrete_Tarde" `
    -Action $actionTarde `
    -Trigger $triggerTarde `
    -Settings $settings `
    -Force | Out-Null

# ── Tarefa 3: Check-in da noite 20:00 ─────────────────────
$actionNoite  = New-ScheduledTaskAction -Execute "powershell.exe" `
                -Argument ('-NonInteractive -WindowStyle Hidden -File "' + $scriptNoite + '"')
$triggerNoite = New-ScheduledTaskTrigger -Daily -At "20:00"

Register-ScheduledTask -TaskName "Pentalateral_Lembrete_Noite" `
    -Action $actionNoite `
    -Trigger $triggerNoite `
    -Settings $settings `
    -Force | Out-Null

Write-Host ""
Write-Host "[OK] 3 check-ins diarios registrados (Telegram + E-mail):" -ForegroundColor Green
Write-Host "   07:00 -- Pentalateral_Briefing_Manha  (briefing_diario.ps1)" -ForegroundColor White
Write-Host "   13:00 -- Pentalateral_Lembrete_Tarde  (lembrete_tarde.ps1)"  -ForegroundColor White
Write-Host "   20:00 -- Pentalateral_Lembrete_Noite  (lembrete_noite.ps1)"  -ForegroundColor White
Write-Host ""
Write-Host "NOTA: o computador precisa estar ligado na hora agendada." -ForegroundColor Yellow
Write-Host "O e-mail e o canal principal -- chega no celular mesmo sem o Telegram aberto." -ForegroundColor Gray
Write-Host ""
Write-Host "Para testar agora:" -ForegroundColor Yellow
Write-Host "  Start-ScheduledTask -TaskName 'Pentalateral_Briefing_Manha'" -ForegroundColor White
Write-Host "  Start-ScheduledTask -TaskName 'Pentalateral_Lembrete_Tarde'"  -ForegroundColor White
Write-Host "  Start-ScheduledTask -TaskName 'Pentalateral_Lembrete_Noite'"  -ForegroundColor White
Write-Host ""
