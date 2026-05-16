# gemini_anchor_generator.ps1
# Compila contexto atualizado para o Estrategista (Gemini)
# Previne Deficiencia 1 do Gemini: Amnesia de Contexto e Deriva
# Uso: .\scripts\gemini_anchor_generator.ps1
# Output: CONTEXTO_GEMINI.md + clipboard

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$DATA = Get-Date -Format "yyyy-MM-dd HH:mm"

function Read-Doc {
    param([string]$relativePath, [int]$max = 100)
    $full = Join-Path $BASE $relativePath
    if (-not (Test-Path $full)) { return $null }
    $lines = Get-Content $full -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($null -eq $lines) { return $null }
    if ($lines.Count -gt $max) {
        $lines = $lines[0..($max - 1)]
        $lines += "... [truncado -- ver arquivo completo]"
    }
    return ($lines -join "`n")
}

Write-Host ""
Write-Host "================================================"
Write-Host "  gemini_anchor_generator -- $DATA"
Write-Host "================================================"
Write-Host ""

$ledger  = Read-Doc "INTELLIGENCE_LEDGER.md" 120
$wip     = Read-Doc "CLIENTES\WIP_BOARD.json" 80
$proto   = Read-Doc ".claude\skills\vanguard-protocolo.md" 60

# Memoria mais recente de qualquer cliente
$memoriaRecente = Get-ChildItem "$BASE\CLIENTES" -Filter "MEMORIA*.md" -Recurse -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1

$memoria = if ($memoriaRecente) {
    Write-Host "  Memoria detectada: $($memoriaRecente.Name)"
    Get-Content $memoriaRecente.FullName -Encoding UTF8 -Raw
} else { $null }

# Ultimos 3 commits (payload dinamico — Estrategista nao recebe contexto stale)
$commits = $null
try {
    $gitLog = & git -C $BASE log --oneline -3 2>$null
    if ($gitLog) { $commits = "ULTIMOS 3 COMMITS:`n" + ($gitLog -join "`n") }
} catch {}

$sep = "`n`n" + ("=" * 80) + "`n`n"

$blocos = @()
$blocos += @"
ESTRATEGISTA -- CONTEXTO SOBERANO -- $DATA
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.
"@

if ($commits) { $blocos += "## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO`n$commits" }
if ($ledger)  { $blocos += "## INTELLIGENCE LEDGER -- PRINCIPIOS ATIVOS`n$ledger" }
if ($wip)     { $blocos += "## WIP BOARD -- ESTADO DOS PROJETOS`n$wip" }
if ($memoria) { $blocos += "## MEMORIA MAIS RECENTE`n$memoria" }
if ($proto)   { $blocos += "## PROTOCOLO VANGUARD (resumo)`n$proto" }

$output = $blocos -join $sep

# Salvar arquivo
$destFile = Join-Path $BASE "CONTEXTO_GEMINI.md"
Set-Content $destFile -Value $output -Encoding UTF8

# Copiar para clipboard
try {
    $output | Set-Clipboard
    $clipMsg = "copiado"
} catch {
    $clipMsg = "indisponivel -- use o arquivo"
}

Write-Host ""
Write-Host "Concluido:"
Write-Host "  Arquivo  : CONTEXTO_GEMINI.md ($($output.Length) chars)"
Write-Host "  Clipboard: $clipMsg"
Write-Host ""
Write-Host "Cole no inicio da sessao do Gemini antes de qualquer DIRETRIZ."
Write-Host "================================================"
