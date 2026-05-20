# Hook: PostToolUse (Write | Edit)
# P-033 — Auto-sync quando QUADRILATERAL_UNIVERSAL/ ou docs criticos sao modificados
# Garante que CLIENTES/*/NOTEBOOKLM_FONTES/ fica sempre em dia — zero intervencao manual

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$inputJson = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputJson)) { exit 0 }

$data = $inputJson | ConvertFrom-Json -ErrorAction SilentlyContinue
if ($null -eq $data) { exit 0 }

$filePath = $data.tool_input.file_path
if ([string]::IsNullOrWhiteSpace($filePath)) { exit 0 }

$filePath = $filePath.Replace("/", "\")

# Gatilhos: qualquer arquivo em QUADRILATERAL_UNIVERSAL/ ou docs criticos da raiz
$deveSync = (
    $filePath -match "QUADRILATERAL_UNIVERSAL" -or
    $filePath -match "INTELLIGENCE_LEDGER" -or
    $filePath -match "WIP_BOARD\.json" -or
    $filePath -match "ANALISE_SOCIO_ATUAL"
)

if (-not $deveSync) { exit 0 }

$nomeArq = Split-Path $filePath -Leaf

# Localiza sync script relativo a este hook
$ROOT       = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$syncScript = Join-Path $ROOT ".claude\skills\files\sync_vanguard_docs.ps1"

if (-not (Test-Path $syncScript)) {
    Write-Host "[P-033] AVISO: sync_vanguard_docs.ps1 nao encontrado em: $syncScript" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "[P-033] $nomeArq modificado — sync iniciado automaticamente..." -ForegroundColor Cyan

try {
    $result = & powershell -NoProfile -NonInteractive -File $syncScript 2>&1

    # Extrai apenas o resumo relevante
    $linhaSync    = $result | Select-String "Sincronizados nesta rodada" | Select-Object -Last 1
    $linhaInteg   = $result | Select-String "INTEGRIDADE:" | Select-Object -Last 1
    $linhaOrfaos  = $result | Select-String "Orfaos:" | Select-Object -Last 1

    if ($linhaSync)   { Write-Host "  $($linhaSync.Line.Trim())"   -ForegroundColor White }
    if ($linhaOrfaos) { Write-Host "  $($linhaOrfaos.Line.Trim())" -ForegroundColor White }

    if ($linhaInteg) {
        $cor = if ($linhaInteg.Line -match "VERDE") { "Green" } elseif ($linhaInteg.Line -match "AMARELO") { "Yellow" } else { "Red" }
        Write-Host "  $($linhaInteg.Line.Trim())" -ForegroundColor $cor
    }

    Write-Host "[P-033] NOTEBOOKLM_FONTES/ sincronizado." -ForegroundColor Green
} catch {
    Write-Host "[P-033] ERRO no sync: $($_.Exception.Message)" -ForegroundColor Red
}

exit 0
