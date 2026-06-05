#Requires -Version 5.1
# n8n_export.ps1 -- exporta todos os workflows do n8n EasyPanel para /_n8n/workflows/
# Uso: .\scripts\n8n_export.ps1 [-DryRun]
param([switch]$DryRun)

$scriptDir = Split-Path -Parent $PSScriptRoot
$configScript = Join-Path $PSScriptRoot "n8n_config.ps1"
$outputDir = Join-Path $scriptDir "_n8n\workflows"

if (-not (Test-Path $configScript)) {
    Write-Error "[n8n_export] n8n_config.ps1 nao encontrado em scripts/. Abortar."
    exit 1
}
. $configScript

if ([string]::IsNullOrWhiteSpace($N8N_API_KEY)) {
    Write-Error "[n8n_export] N8N_API_KEY nao configurada em n8n_config.ps1. Abortar."
    exit 1
}

if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

Write-Host "[n8n_export] Conectando em $N8N_BASE_URL ..." -ForegroundColor Cyan

try {
    $headers = @{ "X-N8N-API-KEY" = $N8N_API_KEY }
    $response = Invoke-RestMethod -Uri "$N8N_BASE_URL/api/v1/workflows" -Headers $headers -ErrorAction Stop
    $workflows = $response.data
} catch {
    Write-Error "[n8n_export] Falha ao listar workflows: $($_.Exception.Message)"
    exit 1
}

Write-Host "[n8n_export] $($workflows.Count) workflow(s) encontrado(s)." -ForegroundColor Cyan

$exportados = 0
foreach ($wf in $workflows) {
    $nomeLimpo = ($wf.name -replace '[^a-zA-Z0-9_\-]', '_').ToLower()
    $destino = Join-Path $outputDir "$nomeLimpo.json"

    if ($DryRun) {
        Write-Host "  [DRYRUN] Exportaria: $($wf.name) -> $nomeLimpo.json"
        continue
    }

    try {
        $wfDetalhe = Invoke-RestMethod -Uri "$N8N_BASE_URL/api/v1/workflows/$($wf.id)" -Headers $headers -ErrorAction Stop
        $json = $wfDetalhe | ConvertTo-Json -Depth 20
        [System.IO.File]::WriteAllText($destino, $json, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] $($wf.name) -> $nomeLimpo.json" -ForegroundColor Green
        $exportados++
    } catch {
        Write-Host "  [AVISO] Falha ao exportar $($wf.name): $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

if (-not $DryRun) {
    Write-Host "[n8n_export] $exportados workflow(s) exportado(s) para _n8n/workflows/" -ForegroundColor Green
    Write-Host "             Proximo passo: git add _n8n/workflows/ && git commit" -ForegroundColor Cyan
}
exit 0
