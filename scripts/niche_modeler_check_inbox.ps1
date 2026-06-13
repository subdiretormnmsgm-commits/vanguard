# niche_modeler_check_inbox.ps1
# Verifica se ha sinais novos no Cowork Engine nao enviados ao Antigravity (NICHE_MODELER).
# Elimina idas desnecessarias ao Antigravity quando nao ha dados novos.
#
# Uso:
#   -Status          : exibe status atual (novos sinais disponíveis ou não)
#   -MarcarProcessado: atualiza NICHE_MODELER_SESSIONS.json com as runs do CALIBRACAO processadas
#   -GerarPasso      : gera COWORK_INBOX_NOVOS.md com apenas os novos arquivos para o Antigravity

param(
    [switch]$Status,
    [switch]$MarcarProcessado,
    [switch]$GerarPasso,
    [int]$Loop = 0
)

$projectDir = Split-Path -Parent $PSScriptRoot
$calibracaoPath = Join-Path $projectDir "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\BIBLIOTECA_NICHOS\CALIBRACAO.md"
$sessionsPath   = Join-Path $projectDir "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\NICHE_MODELER_SESSIONS.json"
$novosPath      = Join-Path $projectDir "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\COWORK_INBOX_NOVOS.md"

# --- Ler CALIBRACAO.md: extrair todas as runs (## YYYY-MM-DD | ...) ---
function Get-CalibracaoRuns {
    if (-not (Test-Path $calibracaoPath)) { return @() }
    $content = Get-Content $calibracaoPath -Encoding UTF8 -Raw
    $matches = [regex]::Matches($content, '## (\d{4}-\d{2}-\d{2})\s*\|([^\n]+)')
    $runs = @()
    foreach ($m in $matches) {
        $date   = $m.Groups[1].Value
        $frentes = $m.Groups[2].Value.Trim()
        $runs += [PSCustomObject]@{ date = $date; frentes = $frentes }
    }
    return $runs
}

# --- Ler NICHE_MODELER_SESSIONS.json ---
function Get-Sessions {
    if (-not (Test-Path $sessionsPath)) { return @() }
    $j = Get-Content $sessionsPath -Raw -Encoding UTF8 | ConvertFrom-Json
    return $j.sessions
}

function Get-RunsJaEnviadas {
    $sessions = Get-Sessions
    $jaEnviadas = @()
    foreach ($s in $sessions) {
        if ($s.calibracao_runs_incluidos) {
            $jaEnviadas += $s.calibracao_runs_incluidos
        }
    }
    return $jaEnviadas | Select-Object -Unique
}

# --- Lógica principal ---
$todasRuns  = Get-CalibracaoRuns
$jaEnviadas = Get-RunsJaEnviadas
$novasRuns  = $todasRuns | Where-Object { $_.date -notin $jaEnviadas }

if ($Status) {
    Write-Host ""
    Write-Host "=== NICHE_MODELER INBOX CHECK ==="
    $ultimaSession = (Get-Sessions | Select-Object -Last 1)
    $ultimaData    = if ($ultimaSession) { $ultimaSession.date } else { "nunca" }
    Write-Host "  Ultima sessao Antigravity : Loop $($ultimaSession.loop) em $ultimaData"
    Write-Host "  Runs no CALIBRACAO        : $($todasRuns.Count)"
    Write-Host "  Ja enviadas ao Antigravity: $($jaEnviadas.Count)"
    Write-Host "  Novas runs pendentes      : $($novasRuns.Count)"
    Write-Host ""
    if ($novasRuns.Count -gt 0) {
        Write-Host "  [TRIGGER] NICHE_MODELER: $($novasRuns.Count) run(s) nova(s) -- Antigravity necessario"
        foreach ($r in $novasRuns) {
            Write-Host "    -> $($r.date) | $($r.frentes)"
        }
    } else {
        Write-Host "  [OK] Inbox NICHE_MODELER: 0 novos sinais -- Antigravity desnecessario neste ciclo"
    }
    Write-Host "================================="
    if ($novasRuns.Count -gt 0) { exit 1 }
    exit 0
}

if ($GerarPasso) {
    if ($novasRuns.Count -eq 0) {
        Write-Host "[NICHE_MODELER] Nenhum sinal novo -- COWORK_INBOX_NOVOS.md nao gerado."
        exit 0
    }
    $linhas = @(
        "# COWORK_INBOX_NOVOS — Sinais para proxima sessao Antigravity",
        "> Gerado automaticamente por niche_modeler_check_inbox.ps1",
        "> Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm')",
        "",
        "## Runs novas (nao enviadas ao Antigravity):",
        ""
    )
    foreach ($r in $novasRuns) {
        $linhas += "### $($r.date)"
        $linhas += "Frentes: $($r.frentes)"
        $linhas += ""
    }
    $linhas += "---"
    $linhas += "## Instrucao para PASSO_NICHE_MODELER Bloco A:"
    $linhas += "Incluir apenas os arquivos Drive das runs acima. Ignorar runs antigas."
    $linhas | Set-Content $novosPath -Encoding UTF8
    Write-Host "[NICHE_MODELER] COWORK_INBOX_NOVOS.md gerado com $($novasRuns.Count) run(s) nova(s)."
    exit 0
}

if ($MarcarProcessado) {
    if ($Loop -eq 0) {
        Write-Host "[ERRO] Informe o numero do loop: -MarcarProcessado -Loop N"
        exit 1
    }
    if ($todasRuns.Count -eq 0) {
        Write-Host "[AVISO] CALIBRACAO.md sem entradas -- nada a marcar."
        exit 0
    }
    $j = Get-Content $sessionsPath -Raw -Encoding UTF8 | ConvertFrom-Json

    # Construir nova entrada de sessao
    $novaEntrada = [PSCustomObject]@{
        loop                    = $Loop
        date                    = (Get-Date -Format "yyyy-MM-dd")
        calibracao_runs_incluidos = ($todasRuns | ForEach-Object { $_.date }) | Select-Object -Unique
        frentes_enviadas        = @()
        nichos_novos_aprovados  = @()
        pending_review_processado = $false
    }

    $sessionsLista = [System.Collections.Generic.List[object]]::new()
    foreach ($s in $j.sessions) { $sessionsLista.Add($s) }
    $sessionsLista.Add($novaEntrada)

    $j.sessions = $sessionsLista.ToArray()
    $j | ConvertTo-Json -Depth 10 | Set-Content $sessionsPath -Encoding UTF8
    Write-Host "[NICHE_MODELER] Loop $Loop marcado como processado -- $($novaEntrada.calibracao_runs_incluidos.Count) run(s) registradas."
    exit 0
}

# Sem parametro: mostrar resumo rapido para injecao no session_start
if ($novasRuns.Count -gt 0) {
    Write-Host "[NICHE_MODELER] $($novasRuns.Count) run(s) nova(s) no Cowork -- Antigravity necessario"
    foreach ($r in $novasRuns) { Write-Host "  -> $($r.date)" }
} else {
    Write-Host "[NICHE_MODELER] Inbox limpo -- 0 sinais novos"
}
