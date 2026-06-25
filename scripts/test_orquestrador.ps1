#Requires -Version 5.1
# test_orquestrador.ps1 -- prova de datas do pipeline_orquestrador.ps1 (sem esperar o dia chegar).
$ErrorActionPreference = "Stop"
$orq = Join-Path $PSScriptRoot "pipeline_orquestrador.ps1"
$falhas = 0

function Assert-Contains($json, $needle, $label) {
    if ($json -like "*$needle*") { Write-Host "  PASS  $label" -ForegroundColor Green }
    else { Write-Host "  FAIL  $label (esperava conter: $needle)" -ForegroundColor Red; $script:falhas++ }
}

function Assert-NotContains($json, $needle, $label) {
    if ($json -notlike "*$needle*") { Write-Host "  PASS  $label" -ForegroundColor Green }
    else { Write-Host "  FAIL  $label (NAO devia conter: $needle)" -ForegroundColor Red; $script:falhas++ }
}

# Caso A -- Sexta 26-06: N18 sob gatilho com comando preenchido; compliance retido
$jA = (& powershell.exe -NonInteractive -File $orq -Data "2026-06-26" -Json)
Assert-Contains $jA "S1_PROJETADO"            "26-06: N18 em S1_PROJETADO"
Assert-Contains $jA "PLANO_EXECUCAO_N18"      "26-06: comando do N18 cita o plano-base (ultima saida)"
Assert-Contains $jA "S2b_RETIDO"              "26-06: compliance RETIDO"
Assert-Contains $jA "LC 227"                  "26-06: motivo da retencao presente"

# Caso B -- nunca inventa dado ausente
Assert-Contains $jA "AGUARDA"                 "26-06: placeholder sem fonte vira [AGUARDA], nao inventado"

# Caso B2 -- produto RETIDO nao vaza comando de disparo (invariante load-bearing)
Assert-NotContains $jA "EMBAIXADOR DIGITAL, trabalhar" "26-06: compliance RETIDO NAO emite comando de campanha"

# Caso C -- JSON sempre valido em qualquer data (Domingo)
$jC = (& powershell.exe -NonInteractive -File $orq -Data "2026-06-28" -Json)
try { $jC | ConvertFrom-Json | Out-Null; Write-Host "  PASS  28-06: JSON valido no domingo" -ForegroundColor Green }
catch { Write-Host "  FAIL  28-06: JSON invalido" -ForegroundColor Red; $falhas++ }

# Caso D -- data invalida nao quebra (fail-safe)
$jD = (& powershell.exe -NonInteractive -File $orq -Data "xx" -Json)
try { $jD | ConvertFrom-Json | Out-Null; Write-Host "  PASS  data invalida -> JSON vazio, sem crash" -ForegroundColor Green }
catch { Write-Host "  FAIL  data invalida quebrou" -ForegroundColor Red; $falhas++ }

Write-Host ""
if ($falhas -eq 0) { Write-Host "[VERDE] Todos os casos passaram." -ForegroundColor Green; exit 0 }
else { Write-Host "[VERMELHO] $falhas caso(s) falharam." -ForegroundColor Red; exit 1 }
