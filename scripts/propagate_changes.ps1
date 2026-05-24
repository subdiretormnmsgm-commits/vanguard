#Requires -Version 5.1
# propagate_changes.ps1 — Propaga mudancas de arquivos-fonte para todos os destinos
# Baseado em DEPENDENCY_MAP.json. P-060: Eduardo nunca gerencia propagacao.
#
# Uso:
#   .\scripts\propagate_changes.ps1              # propaga baseado em git diff
#   .\scripts\propagate_changes.ps1 -Forcar      # propaga TUDO
#   .\scripts\propagate_changes.ps1 -Arquivo "INTELLIGENCE_LEDGER.md"

param(
    [switch]$Forcar,
    [string]$Arquivo = ""
)

$raiz    = Split-Path -Parent $PSScriptRoot
$mapPath = "$raiz\PENTALATERAL_UNIVERSAL\OPERACAO\DEPENDENCY_MAP.json"

if (-not (Test-Path $mapPath)) {
    Write-Host "  [ERRO] DEPENDENCY_MAP.json nao encontrado." -ForegroundColor Red
    exit 1
}

$map = Get-Content $mapPath -Raw -Encoding UTF8 | ConvertFrom-Json

# --- Detectar arquivos alterados ---
$arquivosAlterados = @()

$modoForcar = ($Forcar -eq $true) -or ($Forcar.IsPresent -eq $true)

if ($Arquivo -ne "") {
    $arquivosAlterados = @($Arquivo)
} elseif ($modoForcar) {
    $triggers = @()
    foreach ($r in $map.rules) { $triggers += $r.trigger }
    $arquivosAlterados = $triggers
} else {
    $gitDiff       = @(& git -C $raiz diff --name-only HEAD 2>$null)
    $gitDiffStaged = @(& git -C $raiz diff --name-only --cached 2>$null)
    $gitUntracked  = @(& git -C $raiz ls-files --others --exclude-standard 2>$null)
    $todos = $gitDiff + $gitDiffStaged + $gitUntracked
    $arquivosAlterados = @($todos | Where-Object { $_ -ne $null -and $_ -ne "" } | Sort-Object -Unique)
}
$modoForcar = $modoForcar -or ($arquivosAlterados.Count -eq 0 -and $Arquivo -eq "")

if ($arquivosAlterados.Count -eq 0) {
    Write-Host "  [OK] Nenhum arquivo alterado — propagacao nao necessaria." -ForegroundColor DarkGray
    exit 0
}

# --- Coletar clientes ---
$clientes = @(Get-ChildItem "$raiz\CLIENTES" -Directory -ErrorAction SilentlyContinue |
              Where-Object { $_.Name -notmatch '^\.' } |
              Select-Object -ExpandProperty Name)

# --- Executar regras ---
$propagados = 0
$log        = @()

Write-Host ""
Write-Host "[PROPAGATE] $($arquivosAlterados.Count) arquivo(s) verificado(s)..." -ForegroundColor Cyan

foreach ($regra in $map.rules) {
    $trigger = $regra.trigger

    # Verificar match com algum arquivo alterado
    $match = $null
    foreach ($a in $arquivosAlterados) {
        if ($a -like "*$trigger*" -or $trigger -like "*$(Split-Path $a -Leaf)*") {
            $match = $a
            break
        }
    }
    if (-not $match -and -not $Forcar) { continue }

    # Origem real
    $origemPath = "$raiz\$trigger"
    if (-not (Test-Path $origemPath)) {
        if ($match -ne $null) { $origemPath = "$raiz\$match" }
        if (-not (Test-Path $origemPath)) { continue }
    }

    Write-Host ""
    Write-Host "  [$($regra.id)] $($regra.description)" -ForegroundColor Yellow

    foreach ($dest in $regra.destinations) {
        $acao = $dest.action

        if ($acao -eq "copy_to_all_clients") {
            foreach ($c in $clientes) {
                $destPath = "$raiz\$($dest.pattern -replace '\*', $c)"
                $destDir  = Split-Path $destPath
                if (-not (Test-Path $destDir)) { continue }
                Copy-Item $origemPath $destPath -Force
                $lbl = "$c\$(Split-Path $destPath -Leaf)"
                Write-Host "    [OK] $lbl" -ForegroundColor Green
                $log += $lbl
                $propagados++
            }
        } elseif ($acao -eq "copy_to_all_clients_claude_project") {
            foreach ($c in $clientes) {
                $destPath = "$raiz\$($dest.pattern -replace '\*', $c)"
                $destDir  = Split-Path $destPath
                if (-not (Test-Path $destDir)) { continue }
                Copy-Item $origemPath $destPath -Force
                $lbl = "$c\CLAUDE_PROJECT\$(Split-Path $destPath -Leaf)"
                Write-Host "    [OK] $lbl" -ForegroundColor Green
                $log += $lbl
                $propagados++
            }
        } elseif ($acao -eq "copy_fixed") {
            $destPath = "$raiz\$($dest.pattern)"
            $destDir  = Split-Path $destPath
            if (Test-Path $destDir) {
                Copy-Item $origemPath $destPath -Force
                Write-Host "    [OK] $($dest.pattern)" -ForegroundColor Green
                $log += $dest.pattern
                $propagados++
            }
        } elseif ($acao -eq "copy_to_all_clients_named") {
            $nomeArquivo = Split-Path $origemPath -Leaf
            foreach ($c in $clientes) {
                $padraoFinal = $dest.pattern -replace '\*', $c -replace '\{filename\}', $nomeArquivo
                $destPath    = "$raiz\$padraoFinal"
                $destDir     = Split-Path $destPath
                if (-not (Test-Path $destDir)) { continue }
                Copy-Item $origemPath $destPath -Force
                $lbl = "$c\$(Split-Path $destPath -Leaf)"
                Write-Host "    [OK] $lbl" -ForegroundColor Green
                $log += $lbl
                $propagados++
            }
        }
    }
}

Write-Host ""
if ($propagados -gt 0) {
    Write-Host "  [PROPAGATE] $propagados destino(s) atualizados — zero intervencao do Diretor." -ForegroundColor Cyan
} else {
    Write-Host "  [PROPAGATE] Nenhuma propagacao necessaria." -ForegroundColor DarkGray
}

exit 0
