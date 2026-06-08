#Requires -Version 5.1
# pre_loop_action.ps1 -- Valida estado antes de iniciar novo loop para um cliente
# Uso: .\scripts\pre_loop_action.ps1 -cliente INGRID
# O que faz:
#   1. Le LOOP_STATE.json do cliente
#   2. Verifica cada artefato marcado OK existe em disco (P-091)
#   3. Verifica P-045: MEMORIA do loop anterior existe
#   4. Reporta: PRONTO / BLOQUEIOS ENCONTRADOS

param(
    [Parameter(Mandatory=$true)]
    [string]$cliente,
    [switch]$AutoAvancar
)

$BASE = Split-Path -Parent $PSScriptRoot
$LOOP_STATE_PATH = "$BASE\CLIENTES\$cliente\CLAUDE_PROJECT\LOOP_STATE.json"
$SAIU_LIMPO = $true

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  PRE-LOOP ACTION -- $cliente" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# --- Verificar existencia do LOOP_STATE ---
if (-not (Test-Path $LOOP_STATE_PATH)) {
    Write-Host "  [BLOQUEIO] LOOP_STATE.json nao encontrado em:" -ForegroundColor Red
    Write-Host "  $LOOP_STATE_PATH" -ForegroundColor Gray
    Write-Host "  ACAO: copiar LOOP_STATE_SCHEMA.json para o caminho acima e preencher." -ForegroundColor Yellow
    exit 1
}

$state = Get-Content $LOOP_STATE_PATH -Raw -Encoding UTF8 | ConvertFrom-Json
$loop = $state.loop_atual
$status = $state.loop_status

Write-Host "  Cliente:      $cliente" -ForegroundColor White
Write-Host "  Loop atual:   $loop" -ForegroundColor White
Write-Host "  Status:       $status" -ForegroundColor White
Write-Host ""

# --- Gate P-045: loop deve estar CONCLUIDO antes de iniciar novo ---
if ($status -ne "CONCLUIDO" -and $status -ne "LOOP_ENCERRADO") {
    Write-Host "  [BLOQUEIO P-045] Loop $loop nao esta CONCLUIDO." -ForegroundColor Red
    Write-Host "  Status atual: $status" -ForegroundColor Yellow
    Write-Host "  Socios pendentes:" -ForegroundColor Yellow
    foreach ($socio in @("gemini","notebooklm","embaixador","musculo")) {
        $s = $state.socios.$socio
        if ($s.status -ne "OK") {
            Write-Host "    x $socio -- $($s.status)" -ForegroundColor Red
            if ($s.proximo) {
                Write-Host "      Proximo: $($s.proximo)" -ForegroundColor Gray
            }
        }
    }
    $SAIU_LIMPO = $false
}

# --- Verificar artefatos em disco para socios OK ---
Write-Host "  Verificando artefatos em disco..." -ForegroundColor Cyan
$bloqueios = @()
foreach ($socio in @("gemini","notebooklm","embaixador","musculo")) {
    $s = $state.socios.$socio
    if ($s.status -eq "OK" -and $s.artefato) {
        $caminho_relativo = $s.artefato -replace "/","\"
        $caminho_completo = "$BASE\$caminho_relativo"
        if (Test-Path $caminho_completo) {
            Write-Host "    [OK] $socio -- artefato encontrado" -ForegroundColor Green
        } else {
            Write-Host "    [INCONSISTENCIA P-091] $socio -- artefato NAO encontrado em disco" -ForegroundColor Red
            Write-Host "      Declarado: $($s.artefato)" -ForegroundColor Gray
            $bloqueios += "INCONSISTENCIA $socio : $($s.artefato)"
            $SAIU_LIMPO = $false
        }
    } elseif ($s.status -eq "PENDENTE") {
        Write-Host "    [PENDENTE] $socio -- ainda nao concluido" -ForegroundColor Yellow
    }
}

# --- Verificar gates ---
Write-Host ""
Write-Host "  Verificando gates..." -ForegroundColor Cyan

$gates = $state.gates
if (-not $gates.p045_memoria_anterior_existe) {
    Write-Host "    [BLOQUEIO P-045] MEMORIA anterior nao registrada no LOOP_STATE" -ForegroundColor Red
    $SAIU_LIMPO = $false
} else {
    Write-Host "    [OK] P-045 -- MEMORIA anterior existe" -ForegroundColor Green
}
if (-not $gates.p037_deliberacao_concluida) {
    Write-Host "    [BLOQUEIO P-037] Deliberacao do Musculo nao concluida" -ForegroundColor Red
    $SAIU_LIMPO = $false
} else {
    Write-Host "    [OK] P-037 -- Deliberacao concluida" -ForegroundColor Green
}
if (-not $gates.p032_memoria_embaixador_atualizada) {
    Write-Host "    [AVISO P-032] MEMORIA_EMBAIXADOR pode estar desatualizada" -ForegroundColor Yellow
} else {
    Write-Host "    [OK] P-032 -- MEMORIA_EMBAIXADOR atualizada" -ForegroundColor Green
}

# --- Resultado final ---
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
if ($SAIU_LIMPO) {
    $proximo_loop = $loop + 1
    Write-Host "  RESULTADO: PRONTO PARA LOOP $proximo_loop" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Proxima acao do Musculo:" -ForegroundColor Yellow
    Write-Host "  $($state.proxima_acao_musculo)" -ForegroundColor White
    Write-Host ""
    Write-Host "  Proxima acao do Diretor:" -ForegroundColor Yellow
    Write-Host "  $($state.proxima_acao_diretor)" -ForegroundColor White

    if ($AutoAvancar) {
        Write-Host ""
        Write-Host "  [AutoAvancar] Atualizando LOOP_STATE para Loop $proximo_loop..." -ForegroundColor Cyan
        $state.loop_atual = $proximo_loop
        $state.loop_status = "EM_BUILD"
        $state.fase_atual = "GEMINI_PENDENTE"
        $state.socios.gemini.status = "PENDENTE"
        $state.socios.gemini.artefato = $null
        $state.socios.gemini.data_conclusao = $null
        $state.socios.notebooklm.status = "PENDENTE"
        $state.socios.notebooklm.artefato = $null
        $state.socios.notebooklm.data_conclusao = $null
        $state.socios.embaixador.status = "PENDENTE"
        $state.socios.embaixador.artefato = $null
        $state.socios.embaixador.data_conclusao = $null
        $state.socios.musculo.status = "PENDENTE"
        $state.socios.musculo.artefato = $null
        $state.socios.musculo.data_conclusao = $null
        $state.gates.p037_deliberacao_concluida = $false
        $state.gates.p032_memoria_embaixador_atualizada = $false
        $state.gates.p087_resolve_commitado = $false
        $state.ultima_atualizacao = (Get-Date -Format "yyyy-MM-dd")
        $state | ConvertTo-Json -Depth 10 | Set-Content $LOOP_STATE_PATH -Encoding UTF8
        Write-Host "  [OK] LOOP_STATE.json atualizado para Loop $proximo_loop" -ForegroundColor Green
    }
} else {
    Write-Host "  RESULTADO: BLOQUEADO -- resolver antes de iniciar novo loop" -ForegroundColor Red
    Write-Host ""
    if ($bloqueios.Count -gt 0) {
        Write-Host "  Inconsistencias detectadas:" -ForegroundColor Yellow
        $bloqueios | ForEach-Object { Write-Host "    - $_" -ForegroundColor Red }
    }
    Write-Host ""
    Write-Host "  ACAO: corrigir_wip.ps1 -cliente $cliente -socio [NOME] -loop $loop" -ForegroundColor Yellow
    exit 1
}
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
