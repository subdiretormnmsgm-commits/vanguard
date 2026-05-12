# ============================================================
# CHECK_LEIS.PS1 — Verificador das 7 Leis Soberanas
# Executar antes de qualquer commit ou handoff de projeto
# Uso: .\scripts\check_leis.ps1 -Projeto "nome_do_projeto"
# ============================================================

param(
    [string]$Projeto = "projeto_atual",
    [string]$Versao = "V1"
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$dividas_p0 = 0

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  GATE DAS 7 LEIS SOBERANAS — $Projeto $Versao" -ForegroundColor Cyan
Write-Host "  $timestamp" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# --- Verificações automáticas de artefatos ---

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

Write-Host "--- Verificação automática de artefatos ---" -ForegroundColor Yellow

$l3_ok = Check-Arquivo "infra/sentinel_config.json"       "L3 — sentinel_config.json"
$l7_ok = Check-Arquivo "infra/feature_flags.json"         "L7 — feature_flags.json"
$env_ok = Check-Arquivo ".env"                             "L5/L6 — arquivo .env"

# Verificar variáveis de burn rate no .env
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
Write-Host "--- Confirmação manual das 7 Leis ---" -ForegroundColor Yellow
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
$bloqueado = $false

foreach ($lei in $leis) {
    $resposta = Read-Host "  $($lei.id) — $($lei.desc) [S/N]"
    $ok = $resposta.ToUpper() -eq "S"
    $resultados += @{ lei=$lei.id; ok=$ok; desc=$lei.desc }
    if (-not $ok) {
        $bloqueado = $true
        Write-Host "       ↳ PENDENTE — registrar como dívida antes de avançar" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  RESULTADO — $Projeto $Versao" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$aprovadas = ($resultados | Where-Object { $_.ok }).Count
$reprovadas = ($resultados | Where-Object { -not $_.ok }).Count

Write-Host ""
Write-Host "  Leis aprovadas:  $aprovadas / 7" -ForegroundColor $(if ($aprovadas -eq 7) { "Green" } else { "Yellow" })
Write-Host "  Leis pendentes:  $reprovadas / 7" -ForegroundColor $(if ($reprovadas -eq 0) { "Green" } else { "Red" })
Write-Host "  Dívidas P0:      $dividas_p0 / 5 (máximo permitido)" -ForegroundColor $(if ($dividas_p0 -le 3) { "Green" } elseif ($dividas_p0 -le 5) { "Yellow" } else { "Red" })
Write-Host ""

if ($bloqueado) {
    Write-Host "  STATUS: HANDOFF BLOQUEADO" -ForegroundColor Red
    Write-Host "  Resolver leis pendentes antes de declarar versão concluída." -ForegroundColor Red
    Write-Host "  Registrar pendências como dívidas no relatorio_evolutivo." -ForegroundColor Yellow
} else {
    Write-Host "  STATUS: HANDOFF APROVADO" -ForegroundColor Green
    Write-Host "  Todas as 7 Leis Soberanas verificadas. Pode avançar." -ForegroundColor Green
}

Write-Host ""
Write-Host "  Alimentar o NotebookLM com o relatorio_evolutivo desta versão." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
