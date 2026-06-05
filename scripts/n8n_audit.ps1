#Requires -Version 5.1
# n8n_audit.ps1 -- audita workflows n8n em busca de logica de julgamento hardcoded
# Gate 7B do session_close. Falha (exit 1) se encontrar violacoes.
# Excecao: linha com comentario "// LEDGER: [razao]" passa e documenta no AUDIT_REPORT.
# Uso: .\scripts\n8n_audit.ps1 [-WorkflowDir "caminho"] [-DryRun]
param(
    [string]$WorkflowDir = "",
    [switch]$DryRun
)

$scriptDir = Split-Path -Parent $PSScriptRoot
if (-not $WorkflowDir) { $WorkflowDir = Join-Path $scriptDir "_n8n\workflows" }

if (-not (Test-Path $WorkflowDir)) {
    Write-Host "[n8n_audit] Pasta $WorkflowDir nao encontrada -- gate ignorado (nenhum workflow versionado)." -ForegroundColor DarkGray
    exit 0
}

$jsonFiles = @(Get-ChildItem -Path $WorkflowDir -Filter "*.json" -ErrorAction SilentlyContinue)
if ($jsonFiles.Count -eq 0) {
    Write-Host "[n8n_audit] Nenhum workflow .json em $WorkflowDir -- gate ignorado." -ForegroundColor DarkGray
    exit 0
}

Write-Host "[n8n_audit] Auditando $($jsonFiles.Count) workflow(s)..." -ForegroundColor Cyan

$violations = [System.Collections.ArrayList]@()
$approved   = [System.Collections.ArrayList]@()

$keywords   = @("churn","score","price","preco","pitch","prompt")
# Detecta comparacao com LITERAL numerico (ex: > 7, === 97, <= 388) -- variavel nao dispara
$numPattern = '[><=!]+\s*\d+\.?\d*'
# Detecta string literal longa (provavel prompt ou mensagem hardcoded -- > 50 chars)
$strPattern = '"[^"$][^"]{50,}"'

foreach ($file in $jsonFiles) {
    try {
        $raw = [System.IO.File]::ReadAllText($file.FullName)
        $wf  = $raw | ConvertFrom-Json
    } catch {
        Write-Host "  [AVISO] Falha ao parsear $($file.Name): $($_.Exception.Message)" -ForegroundColor Yellow
        continue
    }

    if (-not $wf.nodes) { continue }

    foreach ($node in $wf.nodes) {
        $codeBlocks = @()
        if ($node.parameters.jsCode)       { $codeBlocks += $node.parameters.jsCode }
        if ($node.parameters.functionCode) { $codeBlocks += $node.parameters.functionCode }
        if ($node.parameters.code)         { $codeBlocks += $node.parameters.code }
        if ($codeBlocks.Count -eq 0)       { continue }

        $code = $codeBlocks -join "`n"
        $lines = $code -split "`n"
        $lineNum = 0

        foreach ($line in $lines) {
            $lineNum++
            $isApproved     = $line -match '//\s*LEDGER:'
            $hasNumHardcode = $line -match $numPattern
            $hasStrHardcode = $line -match $strPattern
            $hasKeyword     = ($keywords | Where-Object { $line -match $_ }).Count -gt 0

            if ($isApproved) {
                $null = $approved.Add("[OK-LEDGER] $($file.Name) · $($node.name) · L$lineNum`n  > $($line.Trim())")
            } elseif ($hasNumHardcode -or $hasStrHardcode -or $hasKeyword) {
                $null = $violations.Add("[VIOLATION] $($file.Name) · $($node.name) · L$lineNum`n  > $($line.Trim())")
            }
        }
    }
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$reportLines = [System.Collections.ArrayList]@()
$null = $reportLines.Add("# N8N_AUDIT_REPORT -- $timestamp")
$null = $reportLines.Add("")

if ($violations.Count -eq 0) {
    $null = $reportLines.Add("STATUS: CLEAN -- nenhuma violacao encontrada.")
    $null = $reportLines.Add("Workflows auditados: $($jsonFiles.Count)")
} else {
    $null = $reportLines.Add("STATUS: VIOLATIONS ($($violations.Count) encontrada(s))")
    $null = $reportLines.Add("Workflows auditados: $($jsonFiles.Count)")
    $null = $reportLines.Add("")
    $null = $reportLines.Add("## Violacoes -- corrigir antes de fechar sessao")
    foreach ($v in $violations) { $null = $reportLines.Add("- $v") }
}

if ($approved.Count -gt 0) {
    $null = $reportLines.Add("")
    $null = $reportLines.Add("## Aprovadas via LEDGER (requer revisao do Auditor)")
    foreach ($a in $approved) { $null = $reportLines.Add("- $a") }
}

$reportPath = Join-Path $scriptDir "_n8n\N8N_AUDIT_REPORT.md"
$reportContent = $reportLines -join "`n"

if (-not $DryRun) {
    [System.IO.File]::WriteAllText($reportPath, $reportContent, [System.Text.Encoding]::UTF8)
}

Write-Host $reportContent

if ($violations.Count -gt 0) {
    Write-Host ""
    Write-Host "[n8n_audit] GATE 7B FALHOU -- $($violations.Count) violacao(oes) detectada(s)." -ForegroundColor Red
    Write-Host "            Remover logica hardcoded ou adicionar comentario '// LEDGER: [razao]'." -ForegroundColor Red
    if ($DryRun) { Write-Host "  [DRYRUN] Bloquearia session_close com exit 1" -ForegroundColor DarkCyan }
    else { exit 1 }
}

Write-Host "[n8n_audit] GATE 7B CLEAN -- $($jsonFiles.Count) workflow(s) auditado(s)." -ForegroundColor Green
exit 0
