# HOOK: SessionStart
# Protege contra: Amnesia de Sessao do Musculo (Deficiencia 1)
# Injeta automaticamente os instrumentos de memoria do Quadrilateral IAH

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

function Read-Instrument {
    param([string]$relativePath, [int]$maxLines = 80)
    $fullPath = Join-Path $projectDir $relativePath
    if (-not (Test-Path $fullPath)) { return $null }
    $lines = Get-Content $fullPath -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($null -eq $lines) { return $null }
    if ($lines.Count -gt $maxLines) {
        $lines = $lines[0..($maxLines - 1)]
        $lines += "... [truncado]"
    }
    return $lines -join "`n"
}

$ledger = Read-Instrument "INTELLIGENCE_LEDGER.md" 80
$wip    = Read-Instrument "CLIENTES\WIP_BOARD.json" 60
$socio  = Read-Instrument "CONSELHO\NotebookLM\ANALISE_SOCIO_ATUAL.txt" 25

$sections = @()
if ($ledger) { $sections += "## INTELLIGENCE_LEDGER - PRINCIPIOS ATIVOS`n$ledger" }
if ($wip)    { $sections += "## WIP_BOARD - PROJETOS ATIVOS`n$wip" }
if ($socio)  { $sections += "## ANALISE DO SOCIO - CONTEXTO ATUAL`n$socio" }

if ($sections.Count -eq 0) { exit 0 }

$context = "=== QUADRILATERAL IAH - INSTRUMENTOS DE MEMORIA (auto-injetados) ===`n`n" +
           ($sections -join "`n`n---`n`n")

$output = [ordered]@{
    hookSpecificOutput = [ordered]@{
        hookEventName     = "SessionStart"
        additionalContext = $context
    }
} | ConvertTo-Json -Depth 5 -Compress

Write-Output $output
exit 0
