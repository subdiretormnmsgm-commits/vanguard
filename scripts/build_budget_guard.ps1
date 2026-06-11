#Requires -Version 5.1
# build_budget_guard.ps1 -- ATO 4 Loop 33
# Lê builds_aprovados_nao_iniciados do LOOP_STATE e alerta quando acumulam sem início.
# P-148: volume de deliberação sem conversão em build = degradação do sistema.
# Uso: .\scripts\build_budget_guard.ps1 [-Cliente VANGUARD] [-iniciar <id>] [-Silent]
# Saída: relatório de builds pendentes. Exit 0 OK | Exit 1 erro | Exit 2 FALHA-PADRÃO detectada.

param(
    [string]$Cliente  = "",
    [string]$iniciar  = "",
    [switch]$Silent
)

$baseDir = Split-Path -Parent $PSScriptRoot

# Detectar cliente ativo se não informado
if ($Cliente -eq "") {
    $wipPath = "$baseDir\CLIENTES\WIP_BOARD.json"
    if (Test-Path $wipPath) {
        try {
            $wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
            $ativo = @($wip.board.build) | Where-Object { $_.status -eq "BUILD" }
            if ($ativo.Count -gt 0) { $Cliente = $ativo[0].cliente }
        } catch {}
    }
    if ($Cliente -eq "") { $Cliente = "VANGUARD" }
}

$loopStatePath = "$baseDir\CLIENTES\$Cliente\CLAUDE_PROJECT\LOOP_STATE.json"

if (-not (Test-Path $loopStatePath)) {
    if (-not $Silent) { Write-Host "[BUILD-GUARD] LOOP_STATE.json nao encontrado: $loopStatePath" -ForegroundColor Yellow }
    exit 0
}

try {
    $loopStateRaw = Get-Content $loopStatePath -Raw -Encoding UTF8
    $loopState    = $loopStateRaw | ConvertFrom-Json
} catch {
    Write-Host "[BUILD-GUARD] Erro ao ler LOOP_STATE.json: $_" -ForegroundColor Red
    exit 1
}

$builds = @($loopState.builds_aprovados_nao_iniciados)

# --- MODO: -iniciar <id> ---
if ($iniciar -ne "") {
    $alvo = $builds | Where-Object { $_.id -eq $iniciar }
    if (-not $alvo) {
        Write-Host "[BUILD-GUARD] ID '$iniciar' nao encontrado em builds_aprovados_nao_iniciados." -ForegroundColor Red
        exit 1
    }

    # Remover do array
    $novosBuilds = @($builds | Where-Object { $_.id -ne $iniciar })
    $loopState.builds_aprovados_nao_iniciados = $novosBuilds

    # Gravar LOOP_STATE atualizado
    $jsonAtualizado = $loopState | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($loopStatePath, $jsonAtualizado, [System.Text.Encoding]::UTF8)

    # Criar entrada em PENDENTES.md
    $pendentesPath = "$baseDir\PENDENTES.md"
    if (Test-Path $pendentesPath) {
        $hoje      = Get-Date -Format "yyyy-MM-dd"
        $resolveTag = "[RESOLVE: build-$($alvo.id.ToLower() -replace '[^a-z0-9]','-')]"
        $novaLinha  = "`n- [ ] ``$hoje`` **[musculo] Iniciar build $($alvo.id): $($alvo.descricao)** $resolveTag`n  > Origem: $($alvo.origem) | Estimativa: $($alvo.estimativa)"
        if ($alvo.bloqueante) {
            $novaLinha += "`n  > BLOQUEANTE: $($alvo.bloqueante)"
        }
        Add-Content -Path $pendentesPath -Value $novaLinha -Encoding UTF8
        Write-Host "[BUILD-GUARD] Build '$iniciar' movido para PENDENTES.md." -ForegroundColor Green
    }

    Write-Host "[BUILD-GUARD] $($novosBuilds.Count) build(s) pendente(s) restante(s)." -ForegroundColor Cyan
    exit 0
}

# --- MODO: relatório ---
if ($builds.Count -eq 0) {
    if (-not $Silent) { Write-Host "[BUILD-GUARD] Nenhum build aprovado pendente de inicio. Sistema em dia." -ForegroundColor Green }
    exit 0
}

$temBloqueante = $builds | Where-Object { $_.bloqueante -and $_.bloqueante -ne "null" }

if (-not $Silent) {
    Write-Host ""
    Write-Host "=== BUILD BUDGET GUARD -- $Cliente · Loop $($loopState.loop_atual) ===" -ForegroundColor Cyan

    if ($temBloqueante) {
        Write-Host ""
        Write-Host "  [ALERTA CRITICO] $($temBloqueante.Count) build(s) com BLOQUEANTE ativo:" -ForegroundColor Red
        foreach ($b in $temBloqueante) {
            Write-Host "    >> [$($b.id)] $($b.descricao)" -ForegroundColor Red
            Write-Host "       BLOQUEANTE: $($b.bloqueante)" -ForegroundColor DarkRed
        }
    }

    Write-Host ""
    Write-Host "  Builds aprovados NAO iniciados ($($builds.Count) total):" -ForegroundColor Yellow
    foreach ($b in ($builds | Sort-Object prioridade)) {
        $bloqFlag = if ($b.bloqueante -and $b.bloqueante -ne "null") { " [BLOQ]" } else { "" }
        Write-Host "  $($b.prioridade). [$($b.id)]$bloqFlag $($b.descricao)" -ForegroundColor Yellow
        Write-Host "     Origem: $($b.origem) | Estimativa: $($b.estimativa)" -ForegroundColor DarkYellow
    }

    Write-Host ""
    Write-Host "  Para iniciar um build: .\scripts\build_budget_guard.ps1 -iniciar <id>" -ForegroundColor Cyan
    Write-Host "  Exemplo: .\scripts\build_budget_guard.ps1 -iniciar M-2" -ForegroundColor DarkCyan

    if ($builds.Count -ge 5) {
        Write-Host ""
        Write-Host "  [P-148] $($builds.Count) builds acumulados sem inicio." -ForegroundColor Red
        Write-Host "  Deliberacao sem build = sistema degradando. Iniciar M-2 primeiro (prioridade 1)." -ForegroundColor Red
    }

    Write-Host ""
}

# Exit 2 indica FALHA-PADRAO (count alto = sinal para session_close incluir no CONTEXTO)
if ($builds.Count -ge 5) { exit 2 }
exit 0
