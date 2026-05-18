# marcar_dia_completo.ps1
# Atualiza dias_completos no WIP_BOARD.json automaticamente apos cada dia de build
# O Musculo chama este script — o Diretor nao precisa editar JSON manualmente
# Uso: .\scripts\marcar_dia_completo.ps1 -projeto "PROJ-002" -dia "dia1_schema_edge"

param(
    [Parameter(Mandatory)][string]$projeto,
    [Parameter(Mandatory)][string]$dia
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$WIP  = "$BASE\CLIENTES\WIP_BOARD.json"
$HOJE = Get-Date -Format "yyyy-MM-dd"

if (-not (Test-Path $WIP)) {
    Write-Host "ERRO: WIP_BOARD.json nao encontrado."
    exit 1
}

$json  = Get-Content $WIP -Raw -Encoding UTF8
$board = $json | ConvertFrom-Json

# Localizar projeto em build
$proj = $board.board.build | Where-Object { $_.id -eq $projeto }

if (-not $proj) {
    Write-Host "ERRO: Projeto '$projeto' nao encontrado em board.build."
    Write-Host "Projetos disponiveis:"
    $board.board.build | ForEach-Object { Write-Host "  - $($_.id) ($($_.cliente))" }
    exit 1
}

# Verificar se ja marcado
if ($proj.dias_completos -contains $dia) {
    Write-Host "  [OK] '$dia' ja esta em dias_completos de $projeto. Nenhuma alteracao."
    exit 0
}

# Adicionar dia
$lista = [System.Collections.ArrayList]@()
if ($proj.dias_completos) {
    foreach ($d in $proj.dias_completos) { [void]$lista.Add($d) }
}
[void]$lista.Add($dia)
$proj.dias_completos = $lista.ToArray()

# Atualizar data
$board.atualizado_em = $HOJE

# Salvar
$board | ConvertTo-Json -Depth 15 | Set-Content $WIP -Encoding UTF8

Write-Host ""
Write-Host "=============================================="
Write-Host "  DIA MARCADO COMO CONCLUIDO"
Write-Host "  Projeto : $projeto ($($proj.cliente))"
Write-Host "  Dia     : $dia"
Write-Host "  Total   : $($proj.dias_completos.Count) dia(s) concluido(s)"
Write-Host "  Data    : $HOJE"
Write-Host "=============================================="
Write-Host ""
Write-Host "  Gate alert atualizado automaticamente."
Write-Host "  Rode .\scripts\gate_alert.ps1 para confirmar."
