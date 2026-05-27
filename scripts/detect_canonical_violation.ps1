#Requires -Version 5.1
# detect_canonical_violation.ps1 -- Gate 0c do session_start (P-073)
# Detecta arquivos UNIVERSAL_PURO editados fora da fonte canonica.
# Saida: VERDE (zero violacoes) | AMARELO (drift sem edicao direta) | VERMELHO (violacao confirmada)
# Uso: .\scripts\detect_canonical_violation.ps1
#      .\scripts\detect_canonical_violation.ps1 -detalhar
#      .\scripts\detect_canonical_violation.ps1 -saida relatorio.md

param(
    [string]$saida = "",
    [switch]$detalhar
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE           = Split-Path -Parent $PSScriptRoot
$DEPENDENCY_MAP = "$BASE\PENTALATERAL_UNIVERSAL\OPERACAO\DEPENDENCY_MAP.json"
$CLIENTES_DIR   = "$BASE\CLIENTES"

$status      = "VERDE"
$violacoes   = [System.Collections.ArrayList]@()
$alertas     = [System.Collections.ArrayList]@()
$verificados = 0

function Set-Amarelo { if ($script:status -ne "VERMELHO") { $script:status = "AMARELO" } }
function Set-Vermelho { $script:status = "VERMELHO" }

function Get-Hash256 {
    param([string]$path)
    if (-not (Test-Path $path)) { return $null }
    return (Get-FileHash -Path $path -Algorithm SHA256).Hash
}

Write-Host ""
Write-Host "======================================================="
Write-Host "  DETECT CANONICAL VIOLATION -- P-073"
Write-Host "======================================================="
Write-Host ""

if (-not (Test-Path $DEPENDENCY_MAP)) {
    Write-Host "  [ERRO] DEPENDENCY_MAP.json nao encontrado." -ForegroundColor Red
    exit 1
}

$map = Get-Content $DEPENDENCY_MAP -Raw -Encoding UTF8 | ConvertFrom-Json

if (-not $map.documentos -or -not $map.documentos.UNIVERSAL_PURO) {
    Write-Host "  [ERRO] DEPENDENCY_MAP v2.0 nao encontrado (campo 'documentos.UNIVERSAL_PURO' ausente)." -ForegroundColor Red
    exit 1
}

$projetos = @()
try {
    $projetos = @(Get-ChildItem $CLIENTES_DIR -Directory | Select-Object -ExpandProperty Name)
} catch { }

$arquivosUP = $map.documentos.UNIVERSAL_PURO.arquivos

Write-Host "  Verificando $($arquivosUP.Count) arquivos UNIVERSAL_PURO em $($projetos.Count) projetos..." -ForegroundColor Cyan
Write-Host ""

foreach ($doc in $arquivosUP) {
    if ($doc.padrao) { continue }

    $canonicalRel = $doc.canonical -replace '/', '\'
    $canonicalAbs = "$BASE\$canonicalRel"
    $nomeSlot     = $doc.nome

    if (-not (Test-Path $canonicalAbs)) {
        [void]$alertas.Add("FONTE-AUSENTE: $($doc.canonical) -- arquivo canonical inexistente")
        Set-Amarelo
        continue
    }

    $hashCanon = Get-Hash256 $canonicalAbs
    $tsCanon   = (Get-Item $canonicalAbs).LastWriteTime
    $verificados++

    # Verificar NOTEBOOKLM_BASE se canonical NAO eh la
    $base2 = "$BASE\PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE\$nomeSlot"
    if ((Test-Path $base2) -and $base2 -ne $canonicalAbs) {
        $hashBase2 = Get-Hash256 $base2
        $tsBase2   = (Get-Item $base2).LastWriteTime
        if ($hashBase2 -ne $hashCanon) {
            if ($tsBase2 -gt $tsCanon) {
                $msg = "VIOLACAO: NOTEBOOKLM_BASE\$nomeSlot mais NOVO que $($doc.canonical) e hash diferente -- editado fora da fonte."
                [void]$violacoes.Add($msg)
                Set-Vermelho
                Write-Host "  [VERMELHO] $msg" -ForegroundColor Red
            } else {
                $msg = "DRIFT: NOTEBOOKLM_BASE\$nomeSlot desatualizado em relacao a $($doc.canonical) (sync pendente)"
                [void]$alertas.Add($msg)
                Set-Amarelo
                if ($detalhar) { Write-Host "  [AMARELO] $msg" -ForegroundColor Yellow }
            }
        } else {
            if ($detalhar) { Write-Host "  [OK] NOTEBOOKLM_BASE\$nomeSlot em sync com canonical" -ForegroundColor Green }
        }
    }

    # Verificar cada projeto
    foreach ($proj in $projetos) {
        $fontesDir = "$CLIENTES_DIR\$proj\NOTEBOOKLM_FONTES"
        if (-not (Test-Path $fontesDir)) { continue }

        $arqProjeto = Get-ChildItem $fontesDir -ErrorAction SilentlyContinue |
                      Where-Object { $_.Name -eq $nomeSlot -or ($_.Name -replace '^[0-9]{2}_','') -eq $nomeSlot } |
                      Select-Object -First 1

        if (-not $arqProjeto) {
            if ($detalhar) { Write-Host "  [INFO] $proj\$nomeSlot -- ausente (normal se projeto nao inicializado)" -ForegroundColor DarkGray }
            continue
        }

        $hashProj = Get-Hash256 $arqProjeto.FullName
        $tsProj   = $arqProjeto.LastWriteTime

        if ($hashProj -ne $hashCanon) {
            if ($tsProj -gt $tsCanon) {
                $msg = "VIOLACAO: $proj\NOTEBOOKLM_FONTES\$($arqProjeto.Name) mais NOVO que fonte canonical e hash diferente -- editado diretamente."
                [void]$violacoes.Add($msg)
                Set-Vermelho
                Write-Host "  [VERMELHO] $msg" -ForegroundColor Red
            } else {
                $msg = "DRIFT: $proj\$($arqProjeto.Name) -- hash difere do canonical $($doc.canonical) (sync pendente)"
                [void]$alertas.Add($msg)
                Set-Amarelo
                if ($detalhar) { Write-Host "  [AMARELO] $msg" -ForegroundColor Yellow }
            }
        } else {
            if ($detalhar) { Write-Host "  [OK] $proj\$($arqProjeto.Name) em sync" -ForegroundColor Green }
        }
    }
}

Write-Host ""
Write-Host "======================================================="
$corStatus = switch ($status) { "VERDE" { "Green" } "AMARELO" { "Yellow" } default { "Red" } }
Write-Host "  STATUS: $status -- $verificados arquivos verificados" -ForegroundColor $corStatus

if ($violacoes.Count -gt 0) {
    Write-Host ""
    Write-Host "  VIOLACOES ($($violacoes.Count)):" -ForegroundColor Red
    foreach ($v in $violacoes) { Write-Host "    * $v" -ForegroundColor Red }
    Write-Host ""
    Write-Host "  ACAO: edite apenas a fonte canonical. Execute propagate_changes.ps1 para propagar." -ForegroundColor Yellow
}

if ($alertas.Count -gt 0 -and $detalhar) {
    Write-Host ""
    Write-Host "  ALERTAS ($($alertas.Count)):" -ForegroundColor Yellow
    foreach ($a in $alertas) { Write-Host "    - $a" -ForegroundColor Yellow }
}

Write-Host "======================================================="
Write-Host ""

if ($null -ne $saida -and $saida.Length -gt 0) {
    $linhas = @()
    $linhas += "# DETECT CANONICAL VIOLATION -- $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    $linhas += "- STATUS: $status"
    $linhas += "- Verificados: $verificados"
    $linhas += "- Violacoes: $($violacoes.Count)"
    $linhas += "- Alertas: $($alertas.Count)"
    if ($violacoes.Count -gt 0) {
        $linhas += "## VIOLACOES"
        foreach ($v in $violacoes) { $linhas += "- $v" }
    }
    if ($alertas.Count -gt 0) {
        $linhas += "## ALERTAS (drift -- sync pendente)"
        foreach ($a in $alertas) { $linhas += "- $a" }
    }
    $linhas | Out-File -FilePath $saida -Encoding UTF8
    Write-Host "  Relatorio salvo: $saida" -ForegroundColor Cyan
}

if ($status -eq "VERMELHO") { exit 1 }
exit 0
