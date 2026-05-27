#Requires -Version 5.1
# ledger_split.ps1 -- Gera LEDGER_INDEX.md quando LEDGER atinge 80 principios
# GATILHO: P-080 inscrito (session_close.ps1 chama automaticamente ao atingir 80).
# Uso: .\scripts\ledger_split.ps1              (bloqueia se < 80)
#      .\scripts\ledger_split.ps1 -Force       (executa independente de contagem)
# NUNCA executar sem -Force antes de P-080 ser inscrito.

param(
    [switch]$Force
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE       = Split-Path -Parent $PSScriptRoot
$LEDGER     = "$BASE\INTELLIGENCE_LEDGER.md"
$INDEX_DEST = "$BASE\PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE\LEDGER_INDEX.md"

if (-not (Test-Path $LEDGER)) {
    Write-Host "[LEDGER_SPLIT] ERRO: INTELLIGENCE_LEDGER.md nao encontrado." -ForegroundColor Red
    exit 1
}

$content = Get-Content $LEDGER -Raw -Encoding UTF8

# Contar principios ativos (excluindo gaps e reservados)
$matches_ = [regex]::Matches($content, '### \[P-\d+\]')
$total    = $matches_.Count

if ($total -lt 80 -and -not $Force) {
    Write-Host "[LEDGER_SPLIT] $total principios -- aguardando P-080 para executar." -ForegroundColor Yellow
    Write-Host "[LEDGER_SPLIT] Rodar com -Force para executar manualmente." -ForegroundColor DarkGray
    exit 0
}

Write-Host "[LEDGER_SPLIT] $total principios -- gerando LEDGER_INDEX.md..." -ForegroundColor Cyan

# Mapeamento de categorias por numero de principio
# Principios podem aparecer em mais de uma categoria (cross-cutting)
$categorias = @{
    "PROCESSO"  = [System.Collections.Generic.HashSet[int]]@(
        5, 10, 29, 30, 33, 38, 45, 48, 54, 58, 60, 63, 71, 72, 73, 74, 76
    )
    "PRODUTO"   = [System.Collections.Generic.HashSet[int]]@(
        1, 3, 13, 25, 38, 46, 50, 51, 56, 61, 64, 70
    )
    "CLIENTE"   = [System.Collections.Generic.HashSet[int]]@(
        6, 8, 16, 23, 26, 28, 31, 32, 35, 36, 37, 47, 57, 67, 68, 75
    )
    "UNIVERSAL" = [System.Collections.Generic.HashSet[int]]@(
        2, 4, 7, 9, 18, 21, 29, 52, 53, 55, 59, 65, 69, 74
    )
}

# Extrair principios: numero, titulo, data de descoberta
# Formato: ### [P-NNN] Titulo\n**Descoberto:** DATA
$principios = [regex]::Matches($content,
    '(?m)### \[P-(\d+)\] (.+)\r?\n\*\*Descoberto:\*\* ([^\|]+)')

$indexLines = [System.Collections.ArrayList]@()
[void]$indexLines.Add("# LEDGER INDEX -- Pentalateral IAH")
[void]$indexLines.Add("**$total principios ativos** | Atualizado: $(Get-Date -Format 'yyyy-MM-dd')")
[void]$indexLines.Add("")
[void]$indexLines.Add("| # | Principio | Categoria | Descoberto |")
[void]$indexLines.Add("|---|-----------|-----------|------------|")

# Ordenar por numero
$principiosOrdenados = $principios | Sort-Object { [int]$_.Groups[1].Value }

foreach ($m in $principiosOrdenados) {
    $num   = [int]$m.Groups[1].Value
    $numPad = $m.Groups[1].Value.PadLeft(3, '0')
    $nome  = $m.Groups[2].Value.Trim()
    $data  = ($m.Groups[3].Value -split '\|')[0].Trim()

    # Determinar categoria primaria
    $cat = "UNIVERSAL"
    foreach ($c in @("PROCESSO","PRODUTO","CLIENTE","UNIVERSAL")) {
        if ($categorias[$c].Contains($num)) { $cat = $c; break }
    }

    $nomeShort = if ($nome.Length -gt 60) { $nome.Substring(0, 57) + "..." } else { $nome }
    [void]$indexLines.Add("| P-$numPad | $nomeShort | $cat | $data |")
}

$indexContent = $indexLines -join "`n"
[System.IO.File]::WriteAllText($INDEX_DEST, $indexContent, [System.Text.Encoding]::UTF8)

Write-Host "[LEDGER_SPLIT] LEDGER_INDEX.md gerado -- $total linhas." -ForegroundColor Green
Write-Host "[LEDGER_SPLIT] Destino: $INDEX_DEST" -ForegroundColor DarkGray

# Propagar para destinos do DEPENDENCY_MAP
$propagateScript = "$BASE\scripts\propagate_changes.ps1"
if (Test-Path $propagateScript) {
    & powershell -NonInteractive -File $propagateScript 2>&1 | Out-Null
    Write-Host "[LEDGER_SPLIT] Propagacao executada." -ForegroundColor Green
}

Write-Host "[LEDGER_SPLIT] Proximo passo: criar LEDGER_[CATEGORIA].md por demanda." -ForegroundColor DarkGray
