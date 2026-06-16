#Requires -Version 5.1
# close_loop.ps1 -- P-179: transicao MECANICA e COMPLETA de loop (combate DEF-M-6).
# Origem: FALHA-PROCESSO-2026-06-15 -- Loop 34 fechou e LOOP_STATE nao avancou.
#   Causa: pre_loop_action -AutoAvancar nao era chamado por gatilho nenhum (manual = DEF-M-6)
#          e, mesmo se fosse, nao arquivava loop_anterior nem zerava o eixo
#          (resultados_esperados/objetivo_loop/missao ficavam do loop velho = deriva).
#
# MODOS:
#   (acao)    .\close_loop.ps1 -cliente VANGUARD [-Force] [-Status FECHADO] [-DryRun]
#             Fecha o loop atual, arquiva em loop_anterior, bumpa +1, ZERA o eixo
#             (resultados_esperados/objetivo_loop/missao) -> reativa o gate P-160.
#   -Detect   .\close_loop.ps1 -Detect
#             Saida limpa (uma linha por deriva) -- usado pelo session_start.
#             Detecta: (1) loop fechado nao-transicionado; (2) objetivo_loop citando
#             um Loop != loop_atual (eixo de outro loop). exit 0 sempre.
#
# Validacao de fechabilidade (sem -Force): 4 socios OK + p037 + MEMORIA do loop em disco.
# Loop fracassado sem MEMORIA: usar -Force -Status FRACASSO.

param(
    [string]$cliente = "",
    [switch]$Force,
    [string]$Status  = "FECHADO",
    [switch]$DryRun,
    [switch]$Detect
)

$BASE = Split-Path -Parent $PSScriptRoot

function Save-State($state, $path) {
    # UTF-8 SEM BOM -- JSON consumido por outros scripts/n8n (evita ato2 BOM-guard)
    $json = $state | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($path, $json, (New-Object System.Text.UTF8Encoding($false)))
}

# ----------------------------------------------------------------------------
# MODO -Detect: varre todos os LOOP_STATE.json e lista derivas de transicao.
# Saida limpa (stdout) para o session_start consumir. Nunca grava nada.
# ----------------------------------------------------------------------------
if ($Detect) {
    $estados = Get-ChildItem "$BASE\CLIENTES\*\CLAUDE_PROJECT\LOOP_STATE.json" -ErrorAction SilentlyContinue
    foreach ($f in $estados) {
        try {
            $st = Get-Content $f.FullName -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
        } catch { continue }
        $cli  = if ($st.cliente) { $st.cliente } else { Split-Path (Split-Path $f.FullName -Parent) -Parent | Split-Path -Leaf }
        $loop = $st.loop_atual
        $stat = "$($st.loop_status)".ToUpper()

        # Deriva 1: loop fechado mas nao transicionado
        if ($stat -eq "CONCLUIDO" -or $stat -eq "LOOP_ENCERRADO") {
            Write-Output "[$cli] Loop $loop esta $stat mas nao transicionou -> rodar: .\scripts\close_loop.ps1 -cliente $cli"
        }

        # Deriva 2: objetivo_loop cita um Loop diferente do loop_atual (eixo de outro loop)
        $obj = "$($st.objetivo_loop)"
        if ($obj -match 'Loop\s+(\d+)') {
            $loopNoObjetivo = [int]$matches[1]
            if ($loopNoObjetivo -ne [int]$loop) {
                Write-Output "[$cli] DERIVA DE EIXO: loop_atual=$loop mas objetivo_loop cita Loop $loopNoObjetivo -> close_loop nao foi rodado no fecho anterior"
            }
        }
    }
    exit 0
}

# ----------------------------------------------------------------------------
# MODO ACAO: fechar + transicionar
# ----------------------------------------------------------------------------
if (-not $cliente) {
    Write-Host "[ERRO] -cliente obrigatorio no modo acao. Ex: .\close_loop.ps1 -cliente VANGUARD" -ForegroundColor Red
    exit 1
}

$statePath = "$BASE\CLIENTES\$cliente\CLAUDE_PROJECT\LOOP_STATE.json"
if (-not (Test-Path $statePath)) {
    Write-Host "[ERRO] LOOP_STATE.json nao encontrado: $statePath" -ForegroundColor Red
    exit 1
}

$state = Get-Content $statePath -Raw -Encoding UTF8 | ConvertFrom-Json
$loop  = [int]$state.loop_atual
$novo  = $loop + 1

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  CLOSE LOOP -- $cliente -- Loop $loop -> $novo" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# --- Validacao de fechabilidade (pulada com -Force) ---
$bloqueios = @()
$socios = @("gemini","notebooklm","embaixador","musculo")
foreach ($s in $socios) {
    if ($state.socios.$s.status -ne "OK") { $bloqueios += "socio '$s' nao esta OK (status: $($state.socios.$s.status))" }
}
if (-not $state.gates.p037_deliberacao_concluida) { $bloqueios += "gate p037_deliberacao_concluida = false" }

# MEMORIA do loop em disco (P-045)
$memDir = "$BASE\CLIENTES\$cliente\HISTORICO"
$memExiste = $false
if (Test-Path $memDir) {
    $mem = Get-ChildItem $memDir -Filter "MEMORIA_V$loop*.md" -ErrorAction SilentlyContinue
    if ($mem) { $memExiste = $true }
}
if (-not $memExiste) { $bloqueios += "MEMORIA_V$loop*.md ausente em HISTORICO (P-045)" }

# E-1 Trava-PF-1 (veredito E_1_gate_duro=SIM 2026-06-16): loop nao fecha sem
# POST publicado (post_url) OU 1 conversa real (conversa_real) em e1_evidencia.
$ev = $state.e1_evidencia
if ($null -ne $ev -and $ev.exigido -eq $true) {
    $postUrl  = if ($ev.post_url)      { $ev.post_url.ToString().Trim() }      else { "" }
    $conversa = if ($ev.conversa_real) { $ev.conversa_real.ToString().Trim() } else { "" }
    if ($postUrl -eq "" -and $conversa -eq "") {
        $bloqueios += "E-1 (Trava-PF-1): sem POST publicado nem conversa real em e1_evidencia"
    }
}

if ($bloqueios.Count -gt 0 -and -not $Force) {
    Write-Host ""
    Write-Host "  [BLOQUEADO] Loop $loop nao esta fechavel:" -ForegroundColor Red
    $bloqueios | ForEach-Object { Write-Host "    - $_" -ForegroundColor Yellow }
    Write-Host ""
    Write-Host "  Para fechar um loop incompleto/fracassado: -Force -Status FRACASSO" -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Cyan
    exit 1
}
if ($bloqueios.Count -gt 0 -and $Force) {
    Write-Host ""
    Write-Host "  [FORCE] Fechando com pendencias (Status=$Status):" -ForegroundColor Yellow
    $bloqueios | ForEach-Object { Write-Host "    - $_" -ForegroundColor DarkYellow }
}

# --- Montar arquivamento do loop atual ---
$artefatos = @()
foreach ($s in $socios) {
    if ($state.socios.$s.artefato) { $artefatos += "$s : $($state.socios.$s.artefato)" }
}
$hoje = Get-Date -Format "yyyy-MM-dd"
$loopAnterior = [pscustomobject]@{
    numero                = $loop
    status                = $Status
    data_fechamento       = $hoje
    missao                = "$($state.missao)"
    objetivo_loop         = "$($state.objetivo_loop)"
    artefatos_fechamento  = $artefatos
}

if ($DryRun) {
    Write-Host ""
    Write-Host "  [DRY-RUN] Transicao que seria aplicada:" -ForegroundColor Cyan
    Write-Host "    loop_atual:           $loop -> $novo" -ForegroundColor White
    Write-Host "    loop_status:          $($state.loop_status) -> ABERTO" -ForegroundColor White
    Write-Host "    fase_atual:           -> AGUARDANDO_OBJETIVO_P160" -ForegroundColor White
    Write-Host "    loop_anterior:        <- Loop $loop ($Status)" -ForegroundColor White
    Write-Host "    EIXO ZERADO:          resultados_esperados / objetivo_loop / missao" -ForegroundColor White
    Write-Host "    socios:               todos -> PENDENTE" -ForegroundColor White
    Write-Host "    gate P-160:           REATIVADO (objetivo_loop vazio bloqueia)" -ForegroundColor White
    Write-Host "==================================================" -ForegroundColor Cyan
    exit 0
}

# --- Aplicar transicao ---
$state | Add-Member -NotePropertyName "loop_anterior" -NotePropertyValue $loopAnterior -Force
$state.loop_atual  = $novo
$state.loop_status = "ABERTO"
$state.fase_atual  = "AGUARDANDO_OBJETIVO_P160"

# ZERAR O EIXO (P-172: ninguem herda o eixo do loop anterior por inercia)
$state | Add-Member -NotePropertyName "objetivo_loop" -NotePropertyValue "" -Force
$state | Add-Member -NotePropertyName "objetivo_declarado_em" -NotePropertyValue "" -Force
$state.missao = "AGUARDANDO OBJETIVO -- Loop $novo (P-160)"
$state.resultados_esperados = @("(AGUARDANDO) declarar resultados ao abrir o Loop $novo -- P-160/P-172")

# Reset socios
foreach ($s in $socios) {
    $state.socios.$s.status         = "PENDENTE"
    $state.socios.$s.artefato       = $null
    $state.socios.$s.data_conclusao = $null
    $state.socios.$s.proximo        = $null
}

# Reset gates do novo loop
$state.gates.p037_deliberacao_concluida        = $false
$state.gates.p032_memoria_embaixador_atualizada = $false
$state.gates.p087_resolve_commitado            = $false
$state.gates.p045_memoria_anterior_existe      = $memExiste

$state.fase_atual = "AGUARDANDO_OBJETIVO_P160"
$state.proxima_acao_musculo = "Loop $novo ABERTO. Compilar M+G+N+E do ciclo anterior -> propor objetivo + resultados (P-160/P-172) -> Diretor declara -> gate_loop_objetivo.ps1 -cliente $cliente -registrar."
$state.proxima_acao_diretor = "Declarar o objetivo do Loop $novo em 1 frase apos o Musculo apresentar as sugestoes compiladas."
$state.ultima_atualizacao = $hoje

Save-State $state $statePath

Write-Host ""
Write-Host "  [OK] Loop $loop arquivado (status: $Status) em loop_anterior" -ForegroundColor Green
Write-Host "  [OK] loop_atual -> $novo | eixo ZERADO | socios resetados" -ForegroundColor Green
Write-Host "  [OK] gate P-160 REATIVADO -- objetivo do Loop $novo precisa ser declarado" -ForegroundColor Green
Write-Host ""
Write-Host "  PROXIMO: Musculo compila M+G+N+E -> Diretor declara objetivo ->" -ForegroundColor Yellow
Write-Host "           gate_loop_objetivo.ps1 -cliente $cliente -registrar `"...`"" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
exit 0
