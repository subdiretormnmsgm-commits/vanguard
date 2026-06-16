# burn_rate_shield.ps1 -- E-4 Burn Rate Shield (circuit breaker de custo de API)
# Uso: .\scripts\burn_rate_shield.ps1 -Tarefa <nome> [-Cliente <nome>] [-Registrar] [-ConfigPath <caminho>]
# Exit 0 = LIBERADO | Exit 1 = ERRO (config/estado) | Exit 2 = BLOQUEADO

param(
    [Parameter(Mandatory = $true)]
    [string]$Tarefa,

    [string]$Cliente = "VANGUARD",

    [switch]$Registrar,

    [string]$ConfigPath = ""
)

Set-StrictMode -Off
$ErrorActionPreference = "Stop"

# --- Resolucao de caminhos ---
$raiz = Split-Path $PSScriptRoot -Parent

if ($ConfigPath -eq "") {
    $ConfigPath = Join-Path $raiz "scripts\burn_rate_config.json"
}
elseif (-not [System.IO.Path]::IsPathRooted($ConfigPath)) {
    $ConfigPath = Join-Path $raiz $ConfigPath
}

$StateDir  = Join-Path $raiz "CLIENTES\$Cliente\CLAUDE_PROJECT"
$StateFile = Join-Path $StateDir "burn_rate_state.json"

# --- Carregar config ---
if (-not (Test-Path $ConfigPath)) {
    Write-Host "[BURN] ERRO: config nao encontrada em '$ConfigPath'" -ForegroundColor Red
    exit 1
}

try {
    $cfg = Get-Content $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json
}
catch {
    Write-Host "[BURN] ERRO: config invalida (JSON malformado): $_" -ForegroundColor Red
    exit 1
}

# --- Kill switch ---
if ($cfg.kill_switch -eq $true) {
    Write-Host "[BURN] KILL-SWITCH ATIVO -- todas as tarefas Cowork estao bloqueadas. Ajuste kill_switch=false em burn_rate_config.json para liberar." -ForegroundColor Red
    exit 2
}

# --- Custo da tarefa ---
$custosProp = $cfg.custo_estimado_por_tarefa_usd
$custoTarefa = $null

# Tentativa de leitura da chave exata
$membros = $custosProp | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
if ($membros -contains $Tarefa) {
    $custoTarefa = [double]($custosProp.$Tarefa)
}
else {
    $custoTarefa = [double]($custosProp.default)
}

# --- Verificar janela de madrugada ---
$horaAtual    = (Get-Date).Hour
$horaInicio   = [int]($cfg.janela_madrugada.inicio_hora)
$horaFim      = [int]($cfg.janela_madrugada.fim_hora)
$naJanela     = ($horaAtual -ge $horaInicio) -and ($horaAtual -lt $horaFim)

# --- Carregar / inicializar estado ---
$hoje = (Get-Date -Format "yyyy-MM-dd")

$state = $null
if (Test-Path $StateFile) {
    try {
        $state = Get-Content $StateFile -Raw -Encoding UTF8 | ConvertFrom-Json
    }
    catch {
        $state = $null
    }
}

# Reinicializar se nao existe ou se dia mudou
if ($null -eq $state -or $state.dia -ne $hoje) {
    $state = [PSCustomObject]@{
        dia            = $hoje
        gasto_dia_usd  = 0.0
        gasto_janela_usd = 0.0
        bloqueios      = 0
    }
}

# Garantir que os campos sao doubles (JSON pode serializar como int quando zero)
$gastoDia    = [double]($state.gasto_dia_usd)
$gastoJanela = [double]($state.gasto_janela_usd)
$bloqueios   = [int]($state.bloqueios)

# --- Projecoes ---
$projecaoDia    = $gastoDia + $custoTarefa
$projecaoJanela = $gastoJanela + $custoTarefa

$tetoDia    = [double]($cfg.teto_usd_dia)
$tetoJanela = [double]($cfg.teto_usd_janela_madrugada)

# --- Verificar bloqueio ---
$bloqueado = $false
$motivoBloqueio = ""

if ($projecaoDia -gt $tetoDia) {
    $bloqueado = $true
    $motivoBloqueio = "Projecao dia USD $([math]::Round($projecaoDia,4)) > teto dia USD $tetoDia"
}

if ((-not $bloqueado) -and $naJanela -and ($projecaoJanela -gt $tetoJanela)) {
    $bloqueado = $true
    $motivoBloqueio = "Projecao janela madrugada USD $([math]::Round($projecaoJanela,4)) > teto janela USD $tetoJanela"
}

# --- Agir conforme resultado ---
if ($bloqueado) {
    $bloqueios++
    $state.dia             = $hoje
    $state.gasto_dia_usd   = $gastoDia
    $state.gasto_janela_usd = $gastoJanela
    $state.bloqueios       = $bloqueios

    # Garantir diretorio de estado
    if (-not (Test-Path $StateDir)) {
        New-Item -ItemType Directory -Path $StateDir -Force | Out-Null
    }

    $state | ConvertTo-Json -Depth 5 | Set-Content -Path $StateFile -Encoding UTF8

    Write-Host "[BURN] BLOQUEADO -- Tarefa='$Tarefa' Cliente='$Cliente' | $motivoBloqueio | gasto_dia=USD$([math]::Round($gastoDia,4)) gasto_janela=USD$([math]::Round($gastoJanela,4)) custo_tarefa=USD$custoTarefa bloqueios=$bloqueios" -ForegroundColor Red
    exit 2
}

# --- LIBERADO ---
if ($Registrar) {
    $novoGastoDia = $gastoDia + $custoTarefa
    $novoGastoJanela = if ($naJanela) { $gastoJanela + $custoTarefa } else { $gastoJanela }

    $state.dia             = $hoje
    $state.gasto_dia_usd   = $novoGastoDia
    $state.gasto_janela_usd = $novoGastoJanela
    $state.bloqueios       = $bloqueios

    if (-not (Test-Path $StateDir)) {
        New-Item -ItemType Directory -Path $StateDir -Force | Out-Null
    }

    $state | ConvertTo-Json -Depth 5 | Set-Content -Path $StateFile -Encoding UTF8

    Write-Host "[BURN] LIBERADO (registrado) -- Tarefa='$Tarefa' Cliente='$Cliente' | custo=USD$custoTarefa | gasto_dia=USD$([math]::Round($novoGastoDia,4)) gasto_janela=USD$([math]::Round($novoGastoJanela,4)) | teto_dia=USD$tetoDia teto_janela=USD$tetoJanela" -ForegroundColor Green
}
else {
    Write-Host "[BURN] LIBERADO (dry-run) -- Tarefa='$Tarefa' Cliente='$Cliente' | custo=USD$custoTarefa | gasto_dia_atual=USD$([math]::Round($gastoDia,4)) projecao=USD$([math]::Round($projecaoDia,4)) | teto_dia=USD$tetoDia" -ForegroundColor Green
}

exit 0
