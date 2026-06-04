#Requires -Version 5.1
# briefing_diario.ps1 -- wrapper (P-096: canonico em PENTALATERAL_UNIVERSAL\scripts\)
# Uso: .\scripts\briefing_diario.ps1
# Legado: briefing_diario_LEGADO_2026-06-04.ps1

$universal = Join-Path (Split-Path -Parent $PSScriptRoot) "PENTALATERAL_UNIVERSAL\scripts\briefing_diario.ps1"
& powershell.exe -NonInteractive -File $universal @args
exit $LASTEXITCODE
