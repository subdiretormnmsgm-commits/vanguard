#Requires -Version 5.1
# post_loop_action.ps1 -- Atualiza LOOP_STATE apos concluir uma fase do loop
# Uso: .\scripts\post_loop_action.ps1 -cliente INGRID -socio gemini -artefato "CLIENTES/INGRID/NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V9.txt"
# O que faz:
#   1. Le LOOP_STATE.json do cliente
#   2. Marca o socio como OK com artefato e data
#   3. Determina nova fase_atual
#   4. Sincroniza com WIP_BOARD.json (P-027)
#   5. Salva LOOP_STATE.json atualizado

param(
    [Parameter(Mandatory=$true)]
    [string]$cliente,
    [Parameter(Mandatory=$true)]
    [ValidateSet("gemini","notebooklm","embaixador","musculo")]
    [string]$socio,
    [Parameter(Mandatory=$true)]
    [string]$artefato,
    [string]$data = "",
    [switch]$FecharLoop
)

$BASE = Split-Path -Parent $PSScriptRoot
$LOOP_STATE_PATH = "$BASE\CLIENTES\$cliente\CLAUDE_PROJECT\LOOP_STATE.json"
$WIP_BOARD_PATH  = "$BASE\CLIENTES\WIP_BOARD.json"
$DATA_HOJE = if ($data) { $data } else { Get-Date -Format "yyyy-MM-dd" }

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  POST-LOOP ACTION -- $cliente / $socio" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# --- Verificar LOOP_STATE ---
if (-not (Test-Path $LOOP_STATE_PATH)) {
    Write-Host "  [ERRO] LOOP_STATE.json nao encontrado: $LOOP_STATE_PATH" -ForegroundColor Red
    exit 1
}

$state = Get-Content $LOOP_STATE_PATH -Raw -Encoding UTF8 | ConvertFrom-Json
$loop = $state.loop_atual

Write-Host "  Loop:    $loop" -ForegroundColor White
Write-Host "  Socio:   $socio" -ForegroundColor White
Write-Host "  Artefato: $artefato" -ForegroundColor White
Write-Host ""

# --- Verificar se artefato existe em disco ---
$caminho_relativo = $artefato -replace "/","\"
$caminho_completo = "$BASE\$caminho_relativo"
if (-not (Test-Path $caminho_completo)) {
    Write-Host "  [AVISO] Artefato nao encontrado em disco:" -ForegroundColor Yellow
    Write-Host "  $caminho_completo" -ForegroundColor Gray
    Write-Host "  Registrando mesmo assim -- verificar manualmente." -ForegroundColor Yellow
}

# --- Atualizar socio no LOOP_STATE ---
$state.socios.$socio.status = "OK"
$state.socios.$socio.artefato = $artefato
$state.socios.$socio.data_conclusao = $DATA_HOJE
$state.socios.$socio.proximo = $null
$state.ultima_atualizacao = $DATA_HOJE

# Atualizar gate P-032 se socio for embaixador
if ($socio -eq "embaixador") { $state.gates.p032_memoria_embaixador_atualizada = $true }
if ($socio -eq "musculo")    { $state.gates.p037_deliberacao_concluida = $true }

# --- Determinar nova fase_atual ---
$todos_ok = ($state.socios.gemini.status -eq "OK") -and
            ($state.socios.notebooklm.status -eq "OK") -and
            ($state.socios.embaixador.status -eq "OK") -and
            ($state.socios.musculo.status -eq "OK")

if ($todos_ok -or $FecharLoop) {
    $state.loop_status = "CONCLUIDO"
    $state.fase_atual = "LOOP_ENCERRADO"
    Write-Host "  [OK] Todos os socios concluidos -- Loop $loop ENCERRADO" -ForegroundColor Green
} else {
    # Determinar proximo socio pendente
    $ordem = @("gemini","notebooklm","embaixador","musculo")
    $proximo_pendente = $ordem | Where-Object { $state.socios.$_.status -ne "OK" } | Select-Object -First 1
    if ($proximo_pendente) {
        $state.fase_atual = ($proximo_pendente.ToUpper() + "_PENDENTE")
        $state.loop_status = "EM_BUILD"
        Write-Host "  [OK] $socio marcado como OK" -ForegroundColor Green
        Write-Host "  [FASE] Proximo: $proximo_pendente" -ForegroundColor Cyan
    }
}

# --- Salvar LOOP_STATE ---
$state | ConvertTo-Json -Depth 10 | Set-Content $LOOP_STATE_PATH -Encoding UTF8
Write-Host "  [OK] LOOP_STATE.json atualizado" -ForegroundColor Green

# --- Sincronizar com WIP_BOARD.json ---
if (Test-Path $WIP_BOARD_PATH) {
    $wip = Get-Content $WIP_BOARD_PATH -Raw -Encoding UTF8 | ConvertFrom-Json

    $projeto = $null
    foreach ($col in @("build","check","retainer","entregue")) {
        $found = $wip.board.$col | Where-Object { $_.cliente -like "*$cliente*" -or $_.id -like "*$cliente*" }
        if ($found) { $projeto = $found; break }
    }

    if ($projeto) {
        $projeto.loop_fase_atual.$socio = "OK"
        if ($todos_ok -or $FecharLoop) {
            $loop_num = $state.loop_atual
            $proximo_loop = $loop_num + 1
            $projeto.loop_fase_atual.proximo = "Loop $proximo_loop -- $($state.proxima_acao_diretor)"
        }
        $wip.atualizado_em = $DATA_HOJE
        $wip | ConvertTo-Json -Depth 20 | Set-Content $WIP_BOARD_PATH -Encoding UTF8
        Write-Host "  [OK] WIP_BOARD.json sincronizado -- $cliente.$socio = OK" -ForegroundColor Green
    } else {
        Write-Host "  [AVISO] Cliente $cliente nao encontrado no WIP_BOARD -- sincronizacao ignorada" -ForegroundColor Yellow
    }
}

# --- Output final ---
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  CONCLUIDO" -ForegroundColor Green
Write-Host "  $cliente | Loop $loop | $socio = OK" -ForegroundColor White
Write-Host "  Artefato: $artefato" -ForegroundColor Gray
Write-Host "  Data: $DATA_HOJE" -ForegroundColor Gray
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  LEMBRETE P-027: atualizar loop_fase_atual.proximo no WIP_BOARD" -ForegroundColor Yellow
Write-Host "  com descricao humana da proxima acao antes de fechar sessao." -ForegroundColor Yellow
Write-Host ""
