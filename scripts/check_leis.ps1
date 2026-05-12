# ============================================================
# CHECK_LEIS.PS1 — Gate das 7 Leis Soberanas + Kanban
# Executar antes de qualquer commit ou handoff de projeto
# Uso: .\scripts\check_leis.ps1 -Projeto "nome" -Versao "V1"
# ============================================================

param(
    [string]$Projeto = "projeto_atual",
    [string]$Versao = "V1"
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$dividas_p0 = 0
$bloqueado = $false

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  GATE DAS 7 LEIS SOBERANAS — $Projeto $Versao" -ForegroundColor Cyan
Write-Host "  $timestamp" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# --- Funções auxiliares ---

function Check-Arquivo {
    param([string]$Path, [string]$Label)
    if (Test-Path $Path) {
        Write-Host "  [OK] $Label" -ForegroundColor Green
        return $true
    } else {
        Write-Host "  [FALTA] $Label — $Path" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# GATE 0 — KANBAN: WIP LIMIT E POLÍTICA EXPLÍCITA
# ============================================================

Write-Host "--- GATE 0: Kanban — WIP Limit e Política Explícita ---" -ForegroundColor Magenta
Write-Host ""

$wip_path = "CLIENTES\WIP_BOARD.json"

if (Test-Path $wip_path) {
    $wip = Get-Content $wip_path -Raw | ConvertFrom-Json
    $em_build = $wip.board.build.Count
    $limite_build = $wip.wip_limits.build

    Write-Host "  Projetos em BUILD: $em_build / $limite_build (limite)" -ForegroundColor $(if ($em_build -lt $limite_build) { "Green" } elseif ($em_build -eq $limite_build) { "Yellow" } else { "Red" })

    if ($em_build -ge $limite_build) {
        Write-Host ""
        Write-Host "  [BLOQUEIO KANBAN] WIP Limit atingido." -ForegroundColor Red
        Write-Host "  Termine e entregue um projeto antes de iniciar novo BUILD." -ForegroundColor Red
        Write-Host "  Regra: Um projeto entregue > três em andamento." -ForegroundColor Yellow
        $bloqueado = $true
    }

    # Sentinel Gate — verificar se cliente anterior foi fechado corretamente
    $entregues = $wip.board.entregue
    if ($entregues.Count -gt 0) {
        $ultimo = $entregues[-1]
        $sentinel_anterior = "CLIENTES\$ultimo\sentinel_config.json"
        $playbook_anterior = "CLIENTES\$ultimo\SOVEREIGN_PLAYBOOK.pdf"

        Write-Host ""
        Write-Host "  Verificando fechamento do cliente anterior: $ultimo" -ForegroundColor Yellow

        if (-not (Test-Path $sentinel_anterior)) {
            Write-Host "  [BLOQUEIO] Sentinel de '$ultimo' não validado." -ForegroundColor Red
            Write-Host "  Validar sentinel_config.json antes de iniciar novo projeto." -ForegroundColor Red
            $bloqueado = $true
        } else {
            Write-Host "  [OK] Sentinel de '$ultimo' validado." -ForegroundColor Green
        }

        if (-not (Test-Path $playbook_anterior)) {
            Write-Host "  [BLOQUEIO] Sovereign Playbook de '$ultimo' não gerado." -ForegroundColor Red
            Write-Host "  Gerar e entregar o Playbook antes de novo BUILD." -ForegroundColor Red
            $bloqueado = $true
        } else {
            Write-Host "  [OK] Playbook de '$ultimo' gerado." -ForegroundColor Green
        }
    } else {
        Write-Host "  [OK] Nenhum cliente anterior — primeiro ciclo." -ForegroundColor Green
    }
} else {
    Write-Host "  [AVISO] WIP_BOARD.json não encontrado em CLIENTES\." -ForegroundColor Yellow
    Write-Host "  Criar o arquivo para ativar o Gate Kanban." -ForegroundColor Yellow
}

Write-Host ""

# ============================================================
# GATE 1 — Verificações automáticas de artefatos
# ============================================================

Write-Host "--- GATE 1: Verificação automática de artefatos ---" -ForegroundColor Yellow

$l3_ok = Check-Arquivo "infra/sentinel_config.json"   "L3 — sentinel_config.json"
$l7_ok = Check-Arquivo "infra/feature_flags.json"     "L7 — feature_flags.json"
$env_ok = Check-Arquivo ".env"                         "L5/L6 — arquivo .env"

$l5_ok = $false
if ($env_ok) {
    $env_content = Get-Content ".env" -Raw -ErrorAction SilentlyContinue
    if ($env_content -match "BURN_RATE") {
        Write-Host "  [OK] L5 — BURN_RATE_* encontrado no .env" -ForegroundColor Green
        $l5_ok = $true
    } else {
        Write-Host "  [FALTA] L5 — BURN_RATE_* não encontrado no .env" -ForegroundColor Red
    }
}

Write-Host ""

# ============================================================
# GATE 2 — Peak-End Gate (Service Design)
# ============================================================

Write-Host "--- GATE 2: Peak-End Gate — Sovereign Playbook ---" -ForegroundColor Magenta
Write-Host ""

$playbook_atual = "CLIENTES\$Projeto\SOVEREIGN_PLAYBOOK.pdf"
$playbook_md    = "CLIENTES\$Projeto\SOVEREIGN_PLAYBOOK.md"

if (Test-Path $playbook_atual) {
    Write-Host "  [OK] Sovereign Playbook (PDF) encontrado — pico da jornada garantido." -ForegroundColor Green
} elseif (Test-Path $playbook_md) {
    Write-Host "  [AVISO] Playbook em .md — converter para PDF antes do handoff." -ForegroundColor Yellow
} else {
    Write-Host "  [BLOQUEIO] Sovereign Playbook não encontrado." -ForegroundColor Red
    Write-Host "  O Playbook é o momento de pico da experiência do cliente." -ForegroundColor Red
    Write-Host "  Gerar antes de qualquer handoff. Localização: $playbook_atual" -ForegroundColor Yellow
    $bloqueado = $true
}

Write-Host ""

# ============================================================
# GATE 3 — Confirmação manual das 7 Leis
# ============================================================

Write-Host "--- GATE 3: Confirmação manual das 7 Leis Soberanas ---" -ForegroundColor Yellow
Write-Host "Responda S (sim) ou N (não) para cada lei." -ForegroundColor Gray
Write-Host ""

$leis = @(
    @{ id="L1"; desc="Sovereign Pixel integrado e testado (CNAME ou snippet verificado)" },
    @{ id="L2"; desc="Banner de cookies funcional + tabela user_consents com teste" },
    @{ id="L3"; desc="sentinel_config.json + Ticket Médio Wizard configurado em staging" },
    @{ id="L4"; desc="Sovereign Playbook gerado e entregue ao cliente (PDF confirmado)" },
    @{ id="L5"; desc="Variáveis Burn Rate no .env + alerta de 75% testado" },
    @{ id="L6"; desc="Kill-Switch ativo + grace period 72h + ToS cobre degradação" },
    @{ id="L7"; desc="feature_flags.json no boilerplate + teasers das Camadas superiores testados" }
)

$resultados = @()

foreach ($lei in $leis) {
    $resposta = Read-Host "  $($lei.id) — $($lei.desc) [S/N]"
    $ok = $resposta.ToUpper() -eq "S"
    $resultados += @{ lei=$lei.id; ok=$ok; desc=$lei.desc }
    if (-not $ok) {
        $bloqueado = $true
        Write-Host "       ↳ PENDENTE — registrar como dívida antes de avançar" -ForegroundColor Yellow
    }
}

# ============================================================
# RESULTADO FINAL
# ============================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  RESULTADO FINAL — $Projeto $Versao" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$aprovadas = ($resultados | Where-Object { $_.ok }).Count
$reprovadas = ($resultados | Where-Object { -not $_.ok }).Count

Write-Host "  Leis aprovadas : $aprovadas / 7" -ForegroundColor $(if ($aprovadas -eq 7) { "Green" } else { "Yellow" })
Write-Host "  Leis pendentes : $reprovadas / 7" -ForegroundColor $(if ($reprovadas -eq 0) { "Green" } else { "Red" })
Write-Host "  Dívidas P0     : $dividas_p0 / 5 (máximo permitido)" -ForegroundColor $(if ($dividas_p0 -le 3) { "Green" } elseif ($dividas_p0 -le 5) { "Yellow" } else { "Red" })
Write-Host ""

if ($bloqueado) {
    Write-Host "  STATUS: HANDOFF BLOQUEADO" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Motivos de bloqueio:" -ForegroundColor Red
    if ($em_build -ge $limite_build) {
        Write-Host "  · WIP Limit atingido — termine projeto em andamento" -ForegroundColor Yellow
    }
    if ($reprovadas -gt 0) {
        Write-Host "  · $reprovadas lei(s) pendente(s) — resolver antes do handoff" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "  Registrar pendências como dívidas no relatorio_evolutivo." -ForegroundColor Yellow
} else {
    Write-Host "  STATUS: HANDOFF APROVADO" -ForegroundColor Green
    Write-Host "  Todas as verificações passaram. Pode avançar." -ForegroundColor Green
}

Write-Host ""
Write-Host "  Alimentar o NotebookLM com o relatorio_evolutivo desta versão." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
