#Requires -Version 5.1
# check_diretriz_embaixador.ps1 — Verifica DIRETRIZ_GEMINI do loop atual antes de abrir o Embaixador
# Chamado automaticamente por ir_ao_embaixador.ps1
# Saída: exit 0 = OK | exit 1 = BLOQUEADO (sem -Silencioso)
#
# Uso direto:
#   .\scripts\check_diretriz_embaixador.ps1 -cliente INGRID
#   .\scripts\check_diretriz_embaixador.ps1 -cliente VALDECE -Silencioso

param(
    [Parameter(Mandatory=$true)]
    [string]$cliente,
    [switch]$Silencioso   # Alerta mas nao bloqueia
)

$raiz         = Split-Path -Parent $PSScriptRoot
$clienteUpper = $cliente.ToUpper()

# --- 1. Ler WIP_BOARD para obter loop atual POR CLIENTE ---
$wipPath = "$raiz\CLIENTES\WIP_BOARD.json"
if (-not (Test-Path $wipPath)) {
    Write-Host "  [AVISO] WIP_BOARD.json nao encontrado -- verificacao de DIRETRIZ ignorada." -ForegroundColor Yellow
    exit 0
}

$wip     = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$projeto = @($wip.board.build) | Where-Object { $_.cliente.ToUpper() -eq $clienteUpper } | Select-Object -First 1

if (-not $projeto) {
    # Projeto pode estar em check ou entregue — nao bloquear
    exit 0
}

# --- 2. Extrair numero do loop a partir do campo loop_atual ---
# Exemplos: "Loop 5 — Dias 12-13 — ..."  |  "Loop 6 CONCLUIDO — Loop 7 aguardando..."
$loopAtual = $projeto.loop_atual
$loopNum   = $null

# Preferir o ULTIMO numero de loop mencionado (ex.: "Loop 6 CONCLUIDO — Loop 7")
$matches_all = [regex]::Matches($loopAtual, "Loop (\d+)")
if ($matches_all.Count -gt 0) {
    $loopNum = [int]($matches_all | Select-Object -Last 1).Groups[1].Value
}

if (-not $loopNum) {
    Write-Host "  [AVISO] Numero de loop nao identificado para $clienteUpper (loop_atual: '$loopAtual')." -ForegroundColor Yellow
    exit 0
}

# --- 3. Verificar existencia da DIRETRIZ para este loop ---
$fontes          = "$raiz\CLIENTES\$clienteUpper\NOTEBOOKLM_FONTES"
$nomeEsperado    = "DIRETRIZ_GEMINI_V${loopNum}.txt"
$nomeNumerado    = "12_DIRETRIZ_GEMINI_V${loopNum}.txt"

# Locais onde a DIRETRIZ pode estar (por ordem de prioridade)
$candidatos = @(
    "$fontes\$nomeNumerado",                                   # slot 12 numerado
    "$fontes\$nomeEsperado",                                   # sem numero
    "$raiz\CLIENTES\$clienteUpper\$nomeEsperado"               # raiz do cliente
)

$encontrado     = $false
$encontradoPath = ""
foreach ($c in $candidatos) {
    if (Test-Path $c) {
        $encontrado     = $true
        $encontradoPath = $c
        break
    }
}

# --- 4. Resultado ---
if ($encontrado) {
    $nomeArquivo = Split-Path $encontradoPath -Leaf
    Write-Host "  [OK] DIRETRIZ Loop $loopNum encontrada: $nomeArquivo" -ForegroundColor Green
    exit 0
}

# DIRETRIZ ausente
Write-Host ""
Write-Host "  +----------------------------------------------------------+" -ForegroundColor Red
Write-Host "  |  BLOQUEIO -- DIRETRIZ_GEMINI_V${loopNum}.txt nao encontrada  |" -ForegroundColor Red
Write-Host "  +----------------------------------------------------------+" -ForegroundColor Red
Write-Host "  Cliente : $clienteUpper" -ForegroundColor Yellow
Write-Host "  Loop    : $loopNum ($loopAtual)" -ForegroundColor Yellow
Write-Host "  Esperado: $fontes\$nomeNumerado" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Sem a DIRETRIZ, o Embaixador reage ao Pentalateral sem o plano" -ForegroundColor Yellow
Write-Host "  real do Musculo (SEÇÃO D sem contexto = analise de hipoteses abstratas)." -ForegroundColor Yellow
Write-Host ""
Write-Host "  COMO RESOLVER:" -ForegroundColor Cyan
Write-Host "  1. Gerar DIRETRIZ no Gemini (Passo 3) e salvar como:" -ForegroundColor White
Write-Host "     $fontes\$nomeNumerado" -ForegroundColor DarkGray
Write-Host "  2. Subir o arquivo em Claude Projects > Settings > Knowledge" -ForegroundColor White
Write-Host ""

# Enviar alerta Telegram
$alertScript = "$raiz\scripts\alerta_telegram.ps1"
if (Test-Path $alertScript) {
    $msg = "EMBAIXADOR $clienteUpper - BLOQUEIO: DIRETRIZ Loop $loopNum ausente. Gerar no Gemini antes de ativar SECAO D."
    try { & $alertScript -mensagem $msg -ErrorAction SilentlyContinue } catch {}
}

if ($Silencioso) {
    Write-Host "  (-Silencioso ativo -- bloqueio ignorado, continuando)" -ForegroundColor DarkGray
    exit 0
}

exit 1
