param()
$BASE          = Split-Path $PSScriptRoot -Parent
$baseUniversal = Join-Path $BASE 'PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE'
$fontesDir     = Join-Path $BASE 'CLIENTES\VANGUARD\NOTEBOOKLM_FONTES'
$mPath         = Join-Path $BASE 'CLIENTES\VANGUARD\MANIFEST_DOCS.json'
$HORA          = Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'

$srcFiles = @(Get-ChildItem $baseUniversal -File -ErrorAction SilentlyContinue)
$locFiles = @(Get-ChildItem $fontesDir     -File -ErrorAction SilentlyContinue)

$arqsMani = [System.Collections.ArrayList]@()
$stGeral  = 'VERDE'
$driftCnt = 0
$ausCnt   = 0

foreach ($sf in $srcFiles) {
    $lm = $locFiles | Where-Object {
        $_.Name -eq $sf.Name -or $_.Name -match ("^\d{2}_" + [regex]::Escape($sf.Name) + "$")
    } | Select-Object -First 1

    if ($lm) {
        $hSrc = (Get-FileHash $sf.FullName -Algorithm SHA256).Hash
        $hLoc = (Get-FileHash $lm.FullName -Algorithm SHA256).Hash
        if ($hSrc -eq $hLoc) {
            $st = 'SYNC'
            Write-Host "  [SYNC]  $($lm.Name)" -ForegroundColor Green
        } else {
            $st = 'DRIFT'
            $stGeral = 'AMARELO'
            $driftCnt++
            Write-Host "  [DRIFT] $($lm.Name)" -ForegroundColor Yellow
            Write-Host "          src=$hSrc" -ForegroundColor DarkYellow
            Write-Host "          loc=$hLoc" -ForegroundColor DarkYellow
        }
        [void]$arqsMani.Add([PSCustomObject]@{
            nome           = $lm.Name
            hash_universal = $hSrc
            hash_local     = $hLoc
            status         = $st
        })
    } else {
        $hSrc   = (Get-FileHash $sf.FullName -Algorithm SHA256).Hash
        $stGeral = 'VERMELHO'
        $ausCnt++
        Write-Host "  [AUSENTE] $($sf.Name)" -ForegroundColor Red
        [void]$arqsMani.Add([PSCustomObject]@{
            nome           = $sf.Name
            hash_universal = $hSrc
            hash_local     = ''
            status         = 'AUSENTE'
        })
    }
}

$manifest = [PSCustomObject]@{
    projeto              = 'VANGUARD'
    ultima_sincronizacao = $HORA
    arquivos             = $arqsMani.ToArray()
    status_geral         = $stGeral
    total                = $arqsMani.Count
    drift_count          = $driftCnt
    ausente_count        = $ausCnt
}

$json  = $manifest | ConvertTo-Json -Depth 5
$bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
[System.IO.File]::WriteAllBytes($mPath, $bytes)

Write-Host ''
if ($stGeral -eq 'VERDE') {
    Write-Host "=== MANIFEST REGENERADO: $stGeral | Total: $($arqsMani.Count) | Drift: $driftCnt | Ausente: $ausCnt ===" -ForegroundColor Green
} elseif ($stGeral -eq 'AMARELO') {
    Write-Host "=== MANIFEST REGENERADO: $stGeral | Total: $($arqsMani.Count) | Drift: $driftCnt | Ausente: $ausCnt ===" -ForegroundColor Yellow
} else {
    Write-Host "=== MANIFEST REGENERADO: $stGeral | Total: $($arqsMani.Count) | Drift: $driftCnt | Ausente: $ausCnt ===" -ForegroundColor Red
}
