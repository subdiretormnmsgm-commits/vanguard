#Requires -Version 5.1
# decision_impact.ps1 -- Cascata de impacto de uma mudanca de arquivo (P-074)
# Dado um arquivo alterado, lista todos os destinos que precisam de propagacao.
# Chamado automaticamente apos propagate_changes.ps1 (hook post-commit).
# Uso: .\scripts\decision_impact.ps1 -arquivo "INTELLIGENCE_LEDGER.md"
#      .\scripts\decision_impact.ps1 -arquivo "INTELLIGENCE_LEDGER.md" -detalhar
#      .\scripts\decision_impact.ps1 -listar   (mostra todos os triggers do DEPENDENCY_MAP)

param(
    [string]$arquivo = "",
    [switch]$detalhar,
    [switch]$listar
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE           = Split-Path -Parent $PSScriptRoot
$DEPENDENCY_MAP = "$BASE\PENTALATERAL_UNIVERSAL\OPERACAO\DEPENDENCY_MAP.json"
$CLIENTES_DIR   = "$BASE\CLIENTES"

function Get-Hash256 {
    param([string]$path)
    if (-not (Test-Path $path)) { return $null }
    return (Get-FileHash -Path $path -Algorithm SHA256).Hash
}

if (-not (Test-Path $DEPENDENCY_MAP)) {
    Write-Host "  [ERRO] DEPENDENCY_MAP.json nao encontrado." -ForegroundColor Red
    exit 1
}

$map = Get-Content $DEPENDENCY_MAP -Raw -Encoding UTF8 | ConvertFrom-Json

if ($listar) {
    Write-Host ""
    Write-Host "  TRIGGERS REGISTRADOS NO DEPENDENCY_MAP:" -ForegroundColor Cyan
    foreach ($rule in $map.rules) {
        Write-Host "    $($rule.id): $($rule.trigger) -- $($rule.description)" -ForegroundColor White
    }
    Write-Host ""
    exit 0
}

if ($arquivo -eq "") {
    Write-Host "  [ERRO] Parametro -arquivo obrigatorio. Use -listar para ver triggers." -ForegroundColor Red
    exit 1
}

$arquivoNorm = $arquivo -replace '\\','/' -replace '^\./',''

Write-Host ""
Write-Host "======================================================="
Write-Host "  DECISION IMPACT -- P-074"
Write-Host "  Arquivo: $arquivoNorm"
Write-Host "======================================================="
Write-Host ""

$projetos = @()
try {
    $projetos = @(Get-ChildItem $CLIENTES_DIR -Directory | Select-Object -ExpandProperty Name)
} catch { }

$regrasAtivadas = @()
foreach ($rule in $map.rules) {
    $trigger = $rule.trigger -replace '\\','/'
    if ($arquivoNorm -like "*$trigger*" -or $trigger -like "*$arquivoNorm*" -or
        $arquivoNorm -eq $trigger -or (Split-Path $arquivoNorm -Leaf) -eq (Split-Path $trigger -Leaf)) {
        $regrasAtivadas += $rule
    }
}

if ($regrasAtivadas.Count -eq 0) {
    Write-Host "  [INFO] Nenhuma regra de propagacao encontrada para: $arquivoNorm" -ForegroundColor Yellow
    Write-Host "  Use -listar para ver todos os triggers registrados." -ForegroundColor DarkGray
    Write-Host ""
    exit 0
}

$totalSync     = 0
$totalDesatual = 0
$totalAusente  = 0

foreach ($rule in $regrasAtivadas) {
    Write-Host "  Regra: $($rule.id) -- $($rule.description)" -ForegroundColor Cyan
    Write-Host ""

    $srcAbs  = "$BASE\$($arquivoNorm -replace '/','\' )"
    $hashSrc = Get-Hash256 $srcAbs

    foreach ($dest in $rule.destinations) {
        $pattern = $dest.pattern -replace '/', '\'
        $action  = $dest.action

        if ($action -eq "copy_fixed") {
            $dstAbs  = "$BASE\$pattern"
            $hashDst = Get-Hash256 $dstAbs
            if (-not (Test-Path $dstAbs)) {
                Write-Host "    [AUSENTE]  $pattern" -ForegroundColor Red
                $totalAusente++
            } elseif ($hashDst -eq $hashSrc) {
                Write-Host "    [SYNC]     $pattern" -ForegroundColor Green
                $totalSync++
            } else {
                Write-Host "    [DESATUAL] $pattern -- propagacao necessaria" -ForegroundColor Yellow
                $totalDesatual++
            }
        } elseif ($action -in @("copy_to_all_clients","copy_to_all_clients_verbatim","copy_to_all_clients_claude_project")) {
            $partesPattern = $pattern -split '\\\*\\'
            if ($partesPattern.Count -ge 2) {
                $prefixo = $partesPattern[0]
                $sufixo  = $partesPattern[1]
                foreach ($proj in $projetos) {
                    $dstAbs  = "$BASE\$prefixo\$proj\$sufixo"
                    $hashDst = Get-Hash256 $dstAbs
                    $label   = "$prefixo\$proj\$sufixo"
                    if (-not (Test-Path $dstAbs)) {
                        if ($detalhar) { Write-Host "    [AUSENTE]  $label" -ForegroundColor DarkGray }
                        $totalAusente++
                    } elseif ($hashDst -eq $hashSrc) {
                        if ($detalhar) { Write-Host "    [SYNC]     $label" -ForegroundColor Green }
                        $totalSync++
                    } else {
                        Write-Host "    [DESATUAL] $label" -ForegroundColor Yellow
                        $totalDesatual++
                    }
                }
            }
        } else {
            if ($detalhar) { Write-Host "    [INFO] action '$action' -- verificacao manual necessaria" -ForegroundColor DarkGray }
        }
    }
    Write-Host ""
}

Write-Host "======================================================="
Write-Host "  RESUMO DE IMPACTO:" -ForegroundColor White
Write-Host "  SYNC:      $totalSync" -ForegroundColor Green
Write-Host "  DESATUAL:  $totalDesatual (propagacao pendente)" -ForegroundColor $(if ($totalDesatual -gt 0) { "Yellow" } else { "Green" })
Write-Host "  AUSENTE:   $totalAusente" -ForegroundColor $(if ($totalAusente -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($totalDesatual -gt 0) {
    Write-Host "  ACAO: execute .\scripts\propagate_changes.ps1 para sincronizar." -ForegroundColor Yellow
    Write-Host "  Depois confirme com: .\scripts\decision_impact.ps1 -arquivo '$arquivo'" -ForegroundColor DarkGray
}

Write-Host "======================================================="
Write-Host ""

if ($totalDesatual -gt 0 -or $totalAusente -gt 0) { exit 1 }
exit 0
