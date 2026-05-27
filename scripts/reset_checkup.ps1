#Requires -Version 5.1
# reset_checkup.ps1 — Reseta o contador de check-up sistemico no WIP_BOARD
# Executar ao CONCLUIR uma verificacao dos 12 cenarios e responder ao Embaixador
# Uso: .\scripts\reset_checkup.ps1

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE    = Split-Path -Parent $PSScriptRoot
$wipPath = "$BASE\CLIENTES\WIP_BOARD.json"

Write-Host ""
Write-Host "======================================================="
Write-Host "  RESET CHECK-UP SISTEMICO"
Write-Host "======================================================="
Write-Host ""

if (-not (Test-Path $wipPath)) {
    Write-Host "  ERRO: WIP_BOARD.json nao encontrado em: $wipPath" -ForegroundColor Red
    exit 1
}

try {
    $board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json

    if (-not $board.meta) {
        $board | Add-Member -NotePropertyName "meta" -NotePropertyValue ([PSCustomObject]@{
            loops_desde_ultimo_checkup = 0
            data_ultimo_checkup        = (Get-Date -Format "yyyy-MM-dd")
            checkup_recomendado        = $false
        }) -Force
        Write-Host "  meta inicializado (nao existia)" -ForegroundColor Yellow
    } else {
        $anterior = $board.meta.loops_desde_ultimo_checkup
        $board.meta.loops_desde_ultimo_checkup = 0
        $board.meta.data_ultimo_checkup        = (Get-Date -Format "yyyy-MM-dd")
        $board.meta.checkup_recomendado        = $false
        Write-Host "  Contador resetado: $anterior -> 0" -ForegroundColor Green
        Write-Host "  Ultimo check-up   : $(Get-Date -Format 'yyyy-MM-dd')" -ForegroundColor Green
        Write-Host "  Proximo check-up  : em 3 loops" -ForegroundColor Green
    }

    $board.atualizado_em = (Get-Date -Format "yyyy-MM-dd")
    [System.IO.File]::WriteAllText($wipPath, ($board | ConvertTo-Json -Depth 20), [System.Text.Encoding]::UTF8)

    Write-Host ""
    Write-Host "  [OK] WIP_BOARD.json atualizado." -ForegroundColor Green
    Write-Host ""
    Write-Host "======================================================="
    Write-Host "  CHECK-UP RESETADO -- proximo em 3 loops."
    Write-Host "======================================================="
    Write-Host ""
    exit 0
} catch {
    Write-Host "  ERRO ao atualizar WIP_BOARD: $_" -ForegroundColor Red
    exit 1
}
