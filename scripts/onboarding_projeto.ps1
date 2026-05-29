#Requires -Version 5.1
# onboarding_projeto.ps1 -- scaffold de projeto novo no WIP_BOARD
# ENTREGAVEL 2+3: gates_programados + churn_watch_threshold obrigatorios
# Uso: .\scripts\onboarding_projeto.ps1 -cliente NOME [-tipo PILOTO|SAAS|HYPERCARE|RETAINER]

param(
    [Parameter(Mandatory=$true)]
    [string]$cliente,

    [ValidateSet("PILOTO","SAAS","HYPERCARE","RETAINER")]
    [string]$tipo = ""
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE     = Split-Path -Parent $PSScriptRoot
$cliente  = $cliente.ToUpper()
$wipPath  = "$BASE\CLIENTES\WIP_BOARD.json"
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

Write-Host ""
Write-Host "=============================================="
Write-Host "  ONBOARDING PROJETO -- $cliente"
Write-Host "  Pentalateral IAH -- P-002+P-003"
Write-Host "=============================================="
Write-Host ""

if (-not (Test-Path $wipPath)) {
    Write-Host "[ERRO] WIP_BOARD.json nao encontrado: $wipPath" -ForegroundColor Red
    exit 1
}

try {
    $board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Host "[ERRO] Falha ao ler WIP_BOARD.json: $_" -ForegroundColor Red
    exit 1
}

# Verificar se projeto existe em BUILD
$projAtual = @($board.board.build) | Where-Object { $_.cliente.ToUpper() -eq $cliente } | Select-Object -First 1
if (-not $projAtual) {
    Write-Host "[ERRO] Projeto '$cliente' nao encontrado em board.build." -ForegroundColor Red
    Write-Host "       Adicione o projeto ao WIP_BOARD.json antes de rodar o onboarding." -ForegroundColor Yellow
    exit 1
}

# --- THRESHOLD (ENTREGAVEL 3) ---
$thresholds = @{ "PILOTO" = 5; "SAAS" = 3; "HYPERCARE" = 2; "RETAINER" = 7 }

if (-not $tipo) {
    Write-Host "Tipo do projeto $cliente?" -ForegroundColor Cyan
    Write-Host "  1. PILOTO    (threshold: 5 dias) -- piloto gratuito"
    Write-Host "  2. SAAS      (threshold: 3 dias) -- SaaS pago"
    Write-Host "  3. HYPERCARE (threshold: 2 dias) -- pos-entrega, maxima atencao"
    Write-Host "  4. RETAINER  (threshold: 7 dias) -- contrato recorrente"
    Write-Host ""
    $escolha = Read-Host "Escolha (1-4)"
    $tipo = switch ($escolha) {
        "1" { "PILOTO" } "2" { "SAAS" } "3" { "HYPERCARE" } "4" { "RETAINER" } default { "PILOTO" }
    }
    Write-Host ""
}

$threshold = $thresholds[$tipo]
Write-Host "[ONBOARDING] Tipo: $tipo -- churn_watch_threshold = $threshold dias" -ForegroundColor Green

if ($projAtual.churn_watch_threshold) {
    Write-Host "[INFO] churn_watch_threshold ja definido: $($projAtual.churn_watch_threshold) -- sobrescrevendo." -ForegroundColor DarkGray
}
$projAtual | Add-Member -NotePropertyName "churn_watch_threshold" -NotePropertyValue $threshold -Force

# --- SCAFFOLD gates_programados (ENTREGAVEL 2) ---
$hoje = [datetime]::Today

if ($projAtual.gates_programados -and @($projAtual.gates_programados).Count -gt 0) {
    Write-Host "[INFO] gates_programados ja preenchido ($(@($projAtual.gates_programados).Count) gates)." -ForegroundColor DarkGray
    Write-Host "[INFO] Mantendo gates existentes -- editar manualmente no WIP_BOARD." -ForegroundColor DarkGray
} else {
    $gatesScaffold = @(
        [PSCustomObject]@{
            nome     = "Gate Dia 2 -- primeiras questoes"
            data     = $hoje.AddDays(2).ToString("yyyy-MM-dd")
            criterio = "preencher"
        },
        [PSCustomObject]@{
            nome     = "Gate Dia 5 -- progresso confirmado"
            data     = $hoje.AddDays(5).ToString("yyyy-MM-dd")
            criterio = "preencher"
        }
    )
    $projAtual | Add-Member -NotePropertyName "gates_programados" -NotePropertyValue $gatesScaffold -Force
    Write-Host "[SCAFFOLD] gates_programados criado (2 gates placeholder)." -ForegroundColor Green
    Write-Host "  -> Editar datas e criterios no WIP_BOARD antes do Loop 1." -ForegroundColor Yellow
}

# --- SALVAR WIP_BOARD ---
try {
    $json = $board | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($wipPath, $json, $utf8NoBom)
    Write-Host ""
    Write-Host "[OK] WIP_BOARD.json atualizado." -ForegroundColor Green
} catch {
    Write-Host "[ERRO] Falha ao salvar WIP_BOARD: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=============================================="
Write-Host "  ONBOARDING CONCLUIDO -- $cliente"
Write-Host "=============================================="
$gCnt = if ($projAtual.gates_programados) { @($projAtual.gates_programados).Count } else { 0 }
Write-Host "  churn_watch_threshold : $threshold dias ($tipo)" -ForegroundColor Green
if ($gCnt -le 2) {
    Write-Host "  gates_programados     : $gCnt placeholder(s) -- preencher datas reais" -ForegroundColor Yellow
} else {
    Write-Host "  gates_programados     : $gCnt gates definidos" -ForegroundColor Green
}
Write-Host ""
Write-Host "  PROXIMOS PASSOS:"
Write-Host "  1. Editar gates_programados no WIP_BOARD com datas reais do projeto"
Write-Host "  2. Rodar: .\scripts\ir_ao_embaixador.ps1 -cliente $cliente"
Write-Host "  3. Rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente $cliente"
Write-Host ""
