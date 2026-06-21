#Requires -Version 5.1
# gate_regen_vitrine.ps1 -- Wrapper do gate de regeneracao da Vitrine de Nichos do site.
# Cruza hoje x CALENDARIO_NICHE_INTELLIGENCE.md (linhas REGEN_VITRINE_SITE) e, se a data
# liberar, regenera ACERVO_VANGUARD/data/niches_public.json a partir dos *_MODEL.json.
# Idempotente por mes (nao regenera duas vezes no mesmo mes). Fora da data -> no-op.
# Principio do Diretor (2026-06-21): nenhuma acao de calendario sem sincronizacao com o calendario.
#
# A logica de data/idempotencia vive no modulo puro (shouldRegenerate) consumido pelo gerador
# em modo --gate -- este wrapper so resolve caminhos, valida Node e repassa o exit code.
#
# Uso:
#   .\scripts\gate_regen_vitrine.ps1            -> respeita o gate de data (modo --gate)
#   .\scripts\gate_regen_vitrine.ps1 -Force     -> regenera agora (manual, ignora a data)
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$raiz = (git rev-parse --show-toplevel 2>$null)
if (-not $raiz) { $raiz = (Resolve-Path "$PSScriptRoot\..").Path }
$gerador = Join-Path $raiz 'scripts\regen-vitrine-site.mjs'

if (-not (Test-Path $gerador)) {
    Write-Host "[regen-vitrine] gerador ausente: $gerador" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[regen-vitrine] Node.js nao encontrado no PATH. Instale Node 18+." -ForegroundColor Red
    exit 1
}

if ($Force) {
    Write-Host "[regen-vitrine] modo -Force (ignora o gate de data)" -ForegroundColor Yellow
    & node $gerador
} else {
    & node $gerador --gate
}
exit $LASTEXITCODE
