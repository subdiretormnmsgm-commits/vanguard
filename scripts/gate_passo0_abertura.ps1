# GATE PASSO 0 -- Sequencia obrigatoria de abertura: BLOCO 0 -> Notion -> Cowork
# P-158: gate mecanico -- Musculo nao avanca para PENDENTES/WIP sem completar 0A+0B
#
# Uso:
#   -MarcarNotion  : cria flag de Notion processado hoje
#   -MarcarCowork  : cria flag de Cowork processado hoje
#   -Status        : exibe status atual (para session_start injetar no contexto)
#   -Verificar     : exit 0 se ambos OK, exit 1 se falta algum (para gates bloqueantes)

param(
    [switch]$MarcarNotion,
    [switch]$MarcarCowork,
    [switch]$Status,
    [switch]$Verificar
)

$dataHoje = Get-Date -Format "yyyy-MM-dd"
$scriptDir = $PSScriptRoot
$flagNotion = Join-Path $scriptDir ".passo0_notion_$dataHoje.flag"
$flagCowork = Join-Path $scriptDir ".passo0_cowork_$dataHoje.flag"

# Limpar flags de dias anteriores (manter somente hoje)
Get-ChildItem $scriptDir -Filter ".passo0_notion_*.flag" -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne ".passo0_notion_$dataHoje.flag" } |
    Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem $scriptDir -Filter ".passo0_cowork_*.flag" -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne ".passo0_cowork_$dataHoje.flag" } |
    Remove-Item -Force -ErrorAction SilentlyContinue

if ($MarcarNotion) {
    Set-Content $flagNotion "NOTION processado em $dataHoje $(Get-Date -Format 'HH:mm')" -Encoding UTF8
    Write-Host "[GATE PASSO 0A] Notion marcado -- $dataHoje"
    exit 0
}

if ($MarcarCowork) {
    Set-Content $flagCowork "COWORK processado em $dataHoje $(Get-Date -Format 'HH:mm')" -Encoding UTF8
    Write-Host "[GATE PASSO 0B] Cowork marcado -- $dataHoje"
    exit 0
}

$notionOK = Test-Path $flagNotion
$coworkOK = Test-Path $flagCowork

$notionTs = if ($notionOK) { (Get-Content $flagNotion -Raw -Encoding UTF8).Trim() } else { "NAO FEITO" }
$coworkTs = if ($coworkOK) { (Get-Content $flagCowork -Raw -Encoding UTF8).Trim() } else { "NAO FEITO" }
$ambosOK  = $notionOK -and $coworkOK

if ($Status) {
    $iconeNotion = if ($notionOK) { "[OK]" } else { "[XX]" }
    $iconeCowork = if ($coworkOK) { "[OK]" } else { "[XX]" }
    $iconeGeral  = if ($ambosOK)  { "[VERDE]" } else { "[VERMELHO]" }
    Write-Host "GATE PASSO 0 -- $dataHoje -- $iconeGeral"
    Write-Host "  $iconeNotion PASSO 0A Notion : $notionTs"
    Write-Host "  $iconeCowork PASSO 0B Cowork : $coworkTs"
    if (-not $ambosOK) {
        Write-Host ""
        Write-Host "  Marcar apos concluir:"
        if (-not $notionOK) { Write-Host "    scripts\gate_passo0_abertura.ps1 -MarcarNotion" }
        if (-not $coworkOK) { Write-Host "    scripts\gate_passo0_abertura.ps1 -MarcarCowork" }
    }
    exit 0
}

if ($Verificar) {
    if ($ambosOK) { exit 0 }
    Write-Host ""
    Write-Host "=== GATE PASSO 0 -- BLOQUEANTE [$dataHoje] ==="
    if (-not $notionOK) { Write-Host "  [XX] PASSO 0A -- Notion NAO processado" }
    if (-not $coworkOK) { Write-Host "  [XX] PASSO 0B -- Cowork NAO processado" }
    Write-Host ""
    Write-Host "  Sequencia: BLOCO 0 -> Notion (0A) -> Cowork (0B) -> PENDENTES"
    Write-Host "  Marcar: scripts\gate_passo0_abertura.ps1 -MarcarNotion / -MarcarCowork"
    Write-Host "================================================"
    exit 1
}
