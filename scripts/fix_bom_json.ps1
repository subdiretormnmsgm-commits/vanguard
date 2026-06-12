#Requires -Version 5.1
# fix_bom_json.ps1 -- ATO 2 Loop 33 -- elimina BOM UTF-8 de todos os .json
# FALHA-H: 3a ocorrencia de BOM quebrando ChurnWatch, Notion sync, session_start.
# Uso: .\scripts\fix_bom_json.ps1 [-DryRun] [-Path <diretorio>]
# Saida: lista de arquivos corrigidos + erros. Exit 0 (OK) | Exit 1 (erro de validacao)

param(
    [switch]$DryRun,
    [string]$Path = ""
)

$baseDir = Split-Path -Parent $PSScriptRoot
if ($Path -eq "") { $Path = $baseDir }

$BOM = [byte[]]@(0xEF, 0xBB, 0xBF)
$corrigidos   = [System.Collections.Generic.List[string]]::new()
$erros        = [System.Collections.Generic.List[string]]::new()
$semBom       = 0

Write-Host ""
Write-Host "=== FIX BOM JSON -- $Path ===" -ForegroundColor Cyan
if ($DryRun) { Write-Host "  [DRYRUN] Modo simulacao -- sem escrita" -ForegroundColor DarkCyan }

$jsonFiles = Get-ChildItem -Path $Path -Recurse -Filter "*.json" -File |
             Where-Object { $_.FullName -notmatch '\\\.git\\' }

foreach ($file in $jsonFiles) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)

    # Detectar BOM nos 3 primeiros bytes
    $temBom = ($bytes.Length -ge 3) -and
              ($bytes[0] -eq $BOM[0]) -and
              ($bytes[1] -eq $BOM[1]) -and
              ($bytes[2] -eq $BOM[2])

    if (-not $temBom) {
        $semBom++
        continue
    }

    # Remover BOM (pular os 3 primeiros bytes)
    $semBomBytes = $bytes[3..($bytes.Length - 1)]

    # Validar que o resultado ainda e JSON parseable
    $conteudo = [System.Text.Encoding]::UTF8.GetString($semBomBytes)
    try {
        $null = $conteudo | ConvertFrom-Json
    } catch {
        $erros.Add("ERRO PARSE: $($file.FullName) -- $_")
        continue
    }

    if ($DryRun) {
        $corrigidos.Add("[DRYRUN] $($file.FullName)")
    } else {
        [System.IO.File]::WriteAllBytes($file.FullName, $semBomBytes)
        $corrigidos.Add($file.FullName)
    }
}

# OUTPUT
if ($corrigidos.Count -gt 0) {
    Write-Host "  [CORRIGIDO] $($corrigidos.Count) arquivo(s) com BOM removido:" -ForegroundColor Yellow
    foreach ($f in $corrigidos) {
        Write-Host "    $f" -ForegroundColor Yellow
    }

    # Auto-commit se nao for DryRun (PENDENTES requisito d)
    if (-not $DryRun) {
        try {
            $qtd   = $corrigidos.Count
            $nomes = ($corrigidos | ForEach-Object { Split-Path $_ -Leaf } | Select-Object -First 3) -join ", "
            if ($corrigidos.Count -gt 3) { $nomes += " e mais $($corrigidos.Count - 3)" }
            & git -C $baseDir add ($corrigidos | ForEach-Object { $_ }) 2>$null
            $msgCommit = "fix(json): remover BOM UTF-8 de $qtd arquivo(s) [RESOLVE: bom-json]`n`n$nomes`n`nCo-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
            & git -C $baseDir commit -m $msgCommit 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  [FIX-BOM] Commit automatico criado [RESOLVE: bom-json]" -ForegroundColor Green
            }
        } catch {
            Write-Host "  [FIX-BOM] AVISO: commit automatico falhou -- commitar manualmente" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  [OK] Nenhum BOM detectado em $($semBom + $corrigidos.Count) arquivo(s)." -ForegroundColor Green
}

if ($erros.Count -gt 0) {
    Write-Host "  [ERRO] $($erros.Count) arquivo(s) com BOM mas JSON invalido apos remocao:" -ForegroundColor Red
    foreach ($e in $erros) {
        Write-Host "    $e" -ForegroundColor Red
    }
    exit 1
}

Write-Host "  Total: $($jsonFiles.Count) .json analisados | $($corrigidos.Count) corrigidos | $semBom limpos | $($erros.Count) erros" -ForegroundColor Cyan
exit 0
