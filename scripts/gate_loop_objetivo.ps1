#Requires -Version 5.1
# gate_loop_objetivo.ps1 -- P-160
# Bloqueia gemini_anchor_generator e ir_ao_embaixador se objetivo_loop nao foi declarado.
# Uso: .\scripts\gate_loop_objetivo.ps1 -cliente VANGUARD [-registrar "Objetivo em 1 frase"]
# exit 0 = liberado | exit 1 = bloqueado (objetivo ausente)

param(
    [string]$cliente    = "",
    [string]$registrar  = ""
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=================================================="
Write-Host " GATE P-160 -- OBJETIVO DO LOOP"
if ($cliente) { Write-Host " Cliente: $cliente" }
Write-Host "=================================================="

# Determinar cliente se nao fornecido
if (-not $cliente) {
    # Tentar detectar via WIP_BOARD -- projetos em BUILD
    $wipPath = "$BASE\CLIENTES\WIP_BOARD.json"
    if (Test-Path $wipPath) {
        $wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction SilentlyContinue
        $emBuild = @($wip.board.build | Where-Object { $_ -ne $null })
        if ($emBuild.Count -eq 1) {
            $cliente = $emBuild[0].cliente
            Write-Host "[AUTO] Cliente detectado: $cliente"
        } elseif ($emBuild.Count -gt 1) {
            Write-Host "[AVISO] Multiplos projetos em BUILD. Especifique -cliente:"
            $emBuild | ForEach-Object { Write-Host "  - $($_.cliente)" }
            Write-Host "=================================================="
            exit 1
        }
    }
    if (-not $cliente) {
        Write-Host "[ERRO] Nenhum cliente especificado e nao foi possivel detectar automaticamente."
        Write-Host "       Use: .\gate_loop_objetivo.ps1 -cliente NOME"
        exit 1
    }
}

$statePath = "$BASE\CLIENTES\$cliente\CLAUDE_PROJECT\LOOP_STATE.json"

if (-not (Test-Path $statePath)) {
    Write-Host "[ERRO] LOOP_STATE.json nao encontrado para $cliente."
    Write-Host "       Caminho esperado: $statePath"
    exit 1
}

$state = Get-Content $statePath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction SilentlyContinue
if ($null -eq $state) {
    Write-Host "[ERRO] LOOP_STATE.json invalido (parse falhou)."
    exit 1
}

# Modo REGISTRAR: Diretor declara o objetivo
if ($registrar) {
    # Validar formato minimo
    if ($registrar.Length -lt 20) {
        Write-Host "[ERRO] Objetivo muito curto. Use o formato:"
        Write-Host "       'Ao final deste Loop, teremos [resultado] para [projeto/cliente]'"
        exit 1
    }

    # Adicionar campo objetivo_loop ao JSON
    $state | Add-Member -NotePropertyName "objetivo_loop" -NotePropertyValue $registrar -Force
    $state | Add-Member -NotePropertyName "objetivo_declarado_em" -NotePropertyValue (Get-Date -Format "yyyy-MM-dd") -Force

    $json = $state | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($statePath, $json, [System.Text.Encoding]::UTF8)

    Write-Host "[OK] Objetivo registrado em LOOP_STATE.json:"
    Write-Host "     $registrar"
    Write-Host "[P-160] Loop $($state.loop_atual) liberado para $cliente."
    Write-Host "=================================================="
    exit 0
}

# Modo VERIFICAR: checar se objetivo existe
$objetivo = $state.objetivo_loop
$loopAtual = $state.loop_atual

if (-not $objetivo -or $objetivo.ToString().Trim() -eq "") {
    Write-Host ""
    Write-Host "BLOQUEADO -- P-160"
    Write-Host ""
    Write-Host "  Loop $loopAtual de $cliente nao tem objetivo declarado."
    Write-Host "  O Diretor ainda nao definiu o que este Loop deve produzir."
    Write-Host ""
    Write-Host "  ACAO OBRIGATORIA:"
    Write-Host "  1. Musculo: compilar sugestoes do ciclo anterior"
    Write-Host "     M-1..M-5 + G-1..G-5 + N-1..N-5 + E-1..E-5"
    Write-Host "  2. Apresentar ao Diretor: intencoes + oportunidades + deadlines"
    Write-Host "  3. Diretor declara o objetivo em 1 frase:"
    Write-Host "     'Ao final deste Loop, teremos [X] para [projeto/cliente]'"
    Write-Host "  4. Registrar com:"
    Write-Host "     .\scripts\gate_loop_objetivo.ps1 -cliente $cliente -registrar `"objetivo aqui`""
    Write-Host ""
    Write-Host "=================================================="
    exit 1
}

Write-Host "[OK] Objetivo declarado para Loop ${loopAtual}:"
Write-Host "     $objetivo"
if ($state.objetivo_declarado_em) {
    Write-Host "     Declarado em: $($state.objetivo_declarado_em)"
}
Write-Host "[P-160] Loop liberado."
Write-Host "=================================================="
exit 0
