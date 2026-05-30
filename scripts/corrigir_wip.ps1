# corrigir_wip.ps1 -- Reverte socio para PENDENTE no WIP_BOARD (P-091)
# Uso: .\scripts\corrigir_wip.ps1 -cliente INGRID -socio gemini -loop 7
# Socios validos: gemini | notebooklm | embaixador | musculo

param(
    [string]$cliente,
    [string]$socio,
    [int]$loop
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$sociosValidos = @("gemini", "notebooklm", "embaixador", "musculo")

if (-not $cliente -or -not $socio) {
    Write-Host "Uso: corrigir_wip.ps1 -cliente [NOME] -socio [SOCIO] -loop [N]"
    Write-Host "Socios validos: $($sociosValidos -join ' | ')"
    exit 1
}

if ($socio -notin $sociosValidos) {
    Write-Host "[ERRO] Socio invalido: '$socio'."
    Write-Host "Validos: $($sociosValidos -join ' | ')"
    exit 1
}

$BASE    = Split-Path -Parent $PSScriptRoot
$wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"

if (-not (Test-Path $wipPath)) {
    Write-Host "[ERRO] WIP_BOARD.json nao encontrado em: $wipPath"
    exit 1
}

$board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json

# Localiza projeto na array board.build
$proj = $null
foreach ($p in $board.board.build) {
    if ($p.cliente -ieq $cliente) { $proj = $p; break }
}

if (-not $proj) {
    Write-Host "[ERRO] Projeto '$cliente' nao encontrado em board.build."
    Write-Host "Projetos disponiveis: $(($board.board.build | ForEach-Object { $_.cliente }) -join ', ')"
    exit 1
}

$fase = $proj.loop_fase_atual
if (-not $fase) {
    Write-Host "[ERRO] loop_fase_atual nao encontrado para '$cliente'."
    exit 1
}

$valorAnterior  = $fase.$socio
$fase.$socio    = "PENDENTE"
if ($loop -and $loop -gt 0) { $fase.loop = $loop }

# Grava -- PS5.1 UTF8 inclui BOM; ConvertTo-Json com Depth 15 cobre toda estrutura
$board | ConvertTo-Json -Depth 15 | Set-Content $wipPath -Encoding UTF8

Write-Host ""
Write-Host "[CORRECAO] WIP_BOARD atualizado:" -ForegroundColor Green
Write-Host "  Projeto: $($proj.cliente.ToUpper())"
Write-Host "  Socio  : $socio"
Write-Host "  Antes  : $valorAnterior"
Write-Host "  Agora  : PENDENTE"
if ($loop -and $loop -gt 0) { Write-Host "  Loop   : $loop" }
Write-Host ""
Write-Host "Verificar artefatos correspondentes antes de marcar OK novamente."
Write-Host "  gemini=OK     -> CLIENTES\$($cliente.ToUpper())\NOTEBOOKLM_FONTES\12_DIRETRIZ_GEMINI_V${loop}.txt"
Write-Host "  notebooklm=OK -> .claude\skills\$($cliente.ToLower())-v${loop}.md"
Write-Host "  musculo=OK    -> CLIENTES\$($cliente.ToUpper())\HISTORICO\DELIBERACAO_LOOP_V${loop}_$($cliente.ToLower()).md"
