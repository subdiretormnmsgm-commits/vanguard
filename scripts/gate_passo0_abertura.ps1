# GATE PASSO 0 -- Sequencia obrigatoria de abertura: BLOCO 0 -> Notion -> Cowork -> Calendario
# P-158: gate mecanico -- Musculo nao avanca para PENDENTES/WIP sem completar 0A+0B+0C
#
# Uso:
#   -MarcarNotion      : cria flag de Notion processado hoje
#   -MarcarCowork      : cria flag de Cowork INBOX processado hoje
#   -MarcarCalendario  : cria flag de Calendario Cowork analisado hoje
#   -ConsultarCalendario : exibe atividade Cowork do dia (sem marcar)
#   -Status            : exibe status atual dos 3 gates (para session_start injetar no contexto)
#   -Verificar         : exit 0 se todos OK, exit 1 se falta algum (para gates bloqueantes)

param(
    [switch]$MarcarNotion,
    [switch]$MarcarCowork,
    [switch]$MarcarCalendario,
    [switch]$ConsultarCalendario,
    [switch]$Status,
    [switch]$Verificar
)

$dataHoje      = Get-Date -Format "yyyy-MM-dd"
$dataFormatada = Get-Date -Format "dd/MM"
$scriptDir     = $PSScriptRoot
$raiz          = Split-Path $scriptDir -Parent

$flagNotion     = Join-Path $scriptDir ".passo0_notion_$dataHoje.flag"
$flagCowork     = Join-Path $scriptDir ".passo0_cowork_$dataHoje.flag"
$flagCalendario = Join-Path $scriptDir ".passo0_calendario_$dataHoje.flag"
$calPath        = Join-Path $raiz "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\CALENDARIO_NICHE_INTELLIGENCE.md"

# Limpar flags de dias anteriores
foreach ($pattern in @(".passo0_notion_*.flag", ".passo0_cowork_*.flag", ".passo0_calendario_*.flag")) {
    $keepName = $pattern -replace "\*", $dataHoje
    Get-ChildItem $scriptDir -Filter $pattern -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ne (Split-Path $keepName -Leaf) } |
        Remove-Item -Force -ErrorAction SilentlyContinue
}

# ── Funcao: ler calendario e retornar entrada do dia ────────────────────────────
function Get-EntradaCalendario {
    if (-not (Test-Path $calPath)) {
        return $null
    }
    $linhas = Get-Content $calPath -Encoding UTF8 -ErrorAction SilentlyContinue
    # Busca linha com | **DD/MM** | no calendario especifico
    $linha = $linhas | Where-Object { $_ -match "\|\s*\*\*$dataFormatada\*\*\s*\|" } | Select-Object -First 1
    if (-not $linha) { return $null }

    # Parse das colunas: | Data | Dia | Frentes | Prioridade | Acao |
    $cols = $linha -split '\|' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    if ($cols.Count -ge 4) {
        return @{
            Data       = $cols[0] -replace '\*', ''
            Dia        = $cols[1]
            Frentes    = $cols[2]
            Prioridade = $cols[3]
            Acao       = if ($cols.Count -ge 5) { $cols[4] } else { "" }
        }
    }
    return $null
}

# ── Marcar gates ────────────────────────────────────────────────────────────────
if ($MarcarNotion) {
    Set-Content $flagNotion "NOTION processado em $dataHoje $(Get-Date -Format 'HH:mm')" -Encoding UTF8
    Write-Host "[GATE PASSO 0A] Notion marcado -- $dataHoje"
    exit 0
}

if ($MarcarCowork) {
    Set-Content $flagCowork "COWORK INBOX processado em $dataHoje $(Get-Date -Format 'HH:mm')" -Encoding UTF8
    Write-Host "[GATE PASSO 0B] Cowork INBOX marcado -- $dataHoje"
    exit 0
}

if ($MarcarCalendario) {
    Set-Content $flagCalendario "CALENDARIO COWORK analisado em $dataHoje $(Get-Date -Format 'HH:mm')" -Encoding UTF8
    Write-Host "[GATE PASSO 0C] Calendario Cowork marcado -- $dataHoje"
    exit 0
}

# ── Consultar calendario (sem marcar) ──────────────────────────────────────────
if ($ConsultarCalendario) {
    Write-Host ""
    Write-Host "  [PASSO 0C] CALENDARIO COWORK -- $dataFormatada" -ForegroundColor Cyan
    Write-Host "  ─────────────────────────────────────────────" -ForegroundColor Cyan
    $entrada = Get-EntradaCalendario
    if ($entrada) {
        $priorCor = "Gray"
        if ($entrada.Prioridade -match "CRITICO") { $priorCor = "Red" }
        elseif ($entrada.Prioridade -match "ALTA|DEADLINE") { $priorCor = "Yellow" }
        Write-Host ("  Frentes do dia : {0}" -f $entrada.Frentes) -ForegroundColor White
        Write-Host ("  Prioridade     : {0}" -f $entrada.Prioridade) -ForegroundColor $priorCor
        if ($entrada.Acao -ne "") {
            Write-Host ("  Acao prevista  : {0}" -f $entrada.Acao) -ForegroundColor Gray
        }
        Write-Host ""
        Write-Host "  --> Esta atividade Cowork sera executada nesta sessao? SIM / NAO" -ForegroundColor Yellow
    } else {
        Write-Host "  Sem atividade Cowork especifica agendada para $dataFormatada." -ForegroundColor Gray
        Write-Host "  Verificar ritmo semanal: Segunda=F1+F2+F4a+F12 | Terca=F1+F3 | Quarta=F1+F6 | Quinta=F1+F4b | Sexta=F1+F15" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  --> Alguma frente do ritmo semanal sera executada nesta sessao? SIM / NAO" -ForegroundColor Yellow
    }
    Write-Host "  Apos decisao do Diretor: scripts\gate_passo0_abertura.ps1 -MarcarCalendario" -ForegroundColor DarkGray
    Write-Host "  ─────────────────────────────────────────────" -ForegroundColor Cyan
    Write-Host ""
    exit 0
}

# ── Status ─────────────────────────────────────────────────────────────────────
$notionOK     = Test-Path $flagNotion
$coworkOK     = Test-Path $flagCowork
$calendarioOK = Test-Path $flagCalendario
$todosOK      = $notionOK -and $coworkOK -and $calendarioOK

$notionTs     = if ($notionOK)     { (Get-Content $flagNotion     -Raw -Encoding UTF8).Trim() } else { "NAO FEITO" }
$coworkTs     = if ($coworkOK)     { (Get-Content $flagCowork     -Raw -Encoding UTF8).Trim() } else { "NAO FEITO" }
$calendarioTs = if ($calendarioOK) { (Get-Content $flagCalendario -Raw -Encoding UTF8).Trim() } else { "NAO FEITO" }

if ($Status) {
    $iconeNotion     = if ($notionOK)     { "[OK]" } else { "[XX]" }
    $iconeCowork     = if ($coworkOK)     { "[OK]" } else { "[XX]" }
    $iconeCalendario = if ($calendarioOK) { "[OK]" } else { "[XX]" }
    $iconeGeral      = if ($todosOK)      { "[VERDE]" } else { "[VERMELHO]" }

    Write-Host "GATE PASSO 0 -- $dataHoje -- $iconeGeral"
    Write-Host "  $iconeNotion PASSO 0A Notion     : $notionTs"
    Write-Host "  $iconeCowork PASSO 0B Cowork INBOX: $coworkTs"
    Write-Host "  $iconeCalendario PASSO 0C Calendario : $calendarioTs"

    if (-not $todosOK) {
        Write-Host ""
        Write-Host "  Marcar apos concluir:"
        if (-not $notionOK)     { Write-Host "    scripts\gate_passo0_abertura.ps1 -MarcarNotion" }
        if (-not $coworkOK)     { Write-Host "    scripts\gate_passo0_abertura.ps1 -MarcarCowork" }
        if (-not $calendarioOK) {
            Write-Host "    scripts\gate_passo0_abertura.ps1 -ConsultarCalendario  (apresentar ao Diretor)"
            Write-Host "    scripts\gate_passo0_abertura.ps1 -MarcarCalendario     (apos decisao SIM/NAO)"
        }
    }
    exit 0
}

# ── Verificar (gate bloqueante) ─────────────────────────────────────────────────
if ($Verificar) {
    if ($todosOK) { exit 0 }
    Write-Host ""
    Write-Host "=== GATE PASSO 0 -- BLOQUEANTE [$dataHoje] ==="
    if (-not $notionOK)     { Write-Host "  [XX] PASSO 0A -- Notion NAO processado" }
    if (-not $coworkOK)     { Write-Host "  [XX] PASSO 0B -- Cowork INBOX NAO processado" }
    if (-not $calendarioOK) { Write-Host "  [XX] PASSO 0C -- Calendario Cowork NAO analisado" }
    Write-Host ""
    Write-Host "  Sequencia: BLOCO 0 -> Notion (0A) -> Cowork INBOX (0B) -> Calendario (0C) -> PENDENTES"
    Write-Host "  Marcar: scripts\gate_passo0_abertura.ps1 -MarcarNotion / -MarcarCowork / -MarcarCalendario"
    Write-Host "================================================"
    exit 1
}
