# gerar_sintese_conselho.ps1 -- Gera DELIBERACAO_LOOP com estrutura P-037
# Bloqueia se qualquer socio estiver pendente ou AUDITOR_LOOP ausente
# Uso: .\scripts\gerar_sintese_conselho.ps1 -cliente INGRID

param(
    [Parameter(Mandatory)][string]$cliente
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE        = Split-Path -Parent $PSScriptRoot
$clienteU    = $cliente.ToUpper()
$clienteLow  = $cliente.ToLower()
$DATA        = Get-Date -Format "dd-MM-yyyy"
$DS          = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))

Write-Host ""
Write-Host "  [P-037] Gerando Sintese do Conselho -- $clienteU..." -ForegroundColor Cyan

# Ler WIP_BOARD (estrutura array em board.build)
$wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
if (-not (Test-Path $wipPath)) {
    Write-Host "  [ERRO] WIP_BOARD.json nao encontrado." -ForegroundColor Red
    exit 1
}

$board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$proj  = $null
foreach ($p in $board.board.build) {
    if ($p.cliente -ieq $cliente) { $proj = $p; break }
}

if (-not $proj) {
    Write-Host "  [ERRO] Projeto '$clienteU' nao encontrado em board.build." -ForegroundColor Red
    Write-Host "  Projetos: $(($board.board.build | ForEach-Object { $_.cliente }) -join ', ')"
    exit 1
}

$fase      = $proj.loop_fase_atual
$loopAtual = $fase.loop

# GATE 1 -- todos os socios devem ter entregado
$faltando = [System.Collections.ArrayList]@()
if ($fase.gemini     -ne "OK") { [void]$faltando.Add("Gemini") }
if ($fase.notebooklm -ne "OK") { [void]$faltando.Add("NotebookLM") }
if ($fase.embaixador -ne "OK") { [void]$faltando.Add("Embaixador") }

if ($faltando.Count -gt 0) {
    Write-Host ""
    Write-Host "  [BLOQUEIO] Sintese bloqueada -- socios pendentes:" -ForegroundColor Red
    foreach ($s in $faltando) { Write-Host "    - $s" -ForegroundColor Red }
    Write-Host "  Todos os socios devem entregar antes da sintese (P-037)." -ForegroundColor Red
    exit 1
}

# GATE 2 -- AUDITOR_LOOP_V[N] deve existir (P-049)
$auditorPath = Join-Path $BASE "CLIENTES\$clienteU\HISTORICO\AUDITOR_LOOP_V${loopAtual}_${clienteLow}.md"
if (-not (Test-Path $auditorPath)) {
    Write-Host ""
    Write-Host "  [BLOQUEIO] AUDITOR_LOOP_V${loopAtual}_${clienteLow}.md ausente." -ForegroundColor Red
    Write-Host "  Salvar output do NotebookLM antes de gerar sintese (P-049)." -ForegroundColor Red
    Write-Host "  Esperado em: CLIENTES\$clienteU\HISTORICO\" -ForegroundColor Yellow
    exit 1
}

# GATE 3 -- MEMORIA_EMBAIXADOR deve existir (P-032)
$memoriaPath = Join-Path $BASE "CLIENTES\$clienteU\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
if (-not (Test-Path $memoriaPath)) {
    Write-Host ""
    Write-Host "  [BLOQUEIO] MEMORIA_EMBAIXADOR.md ausente." -ForegroundColor Red
    Write-Host "  Embaixador deve ter atualizado antes da sintese (P-032)." -ForegroundColor Red
    exit 1
}

Write-Host "  [GATE 1] Socios: Gemini OK | NotebookLM OK | Embaixador OK" -ForegroundColor Green
Write-Host "  [GATE 2] AUDITOR_LOOP_V${loopAtual} encontrado." -ForegroundColor Green
Write-Host "  [GATE 3] MEMORIA_EMBAIXADOR encontrada." -ForegroundColor Green

# Ler template externo (P-088 -- sem Unicode no codigo PS)
$templatePath = Join-Path $BASE "PENTALATERAL_UNIVERSAL\TEMPLATES\scripts\sintese_conselho_template.txt"
if (-not (Test-Path $templatePath)) {
    Write-Host "  [ERRO] Template nao encontrado: $templatePath" -ForegroundColor Red
    exit 1
}

$template = Get-Content $templatePath -Raw -Encoding UTF8

# Substituir placeholders
$saida = $template
$saida = $saida -replace '\{CLIENTE\}',    $clienteU
$saida = $saida -replace '\{LOOP\}',       "$loopAtual"
$saida = $saida -replace '\{DATA\}',       $DATA
$saida = $saida -replace '\{DIA_SEMANA\}', $DS
$saida = $saida -replace '\{LOOP_NEXT\}',  "$($loopAtual + 1)"

# Verificar se DELIBERACAO ja existe (nao sobrescrever sem aviso)
$destino = Join-Path $BASE "CLIENTES\$clienteU\HISTORICO\DELIBERACAO_LOOP_V${loopAtual}_${clienteLow}.md"
if (Test-Path $destino) {
    Write-Host ""
    Write-Host "  [AVISO] DELIBERACAO_LOOP_V${loopAtual} ja existe." -ForegroundColor Yellow
    Write-Host "  Para sobrescrever, renomeie o existente primeiro." -ForegroundColor Yellow
    Write-Host "  Arquivo existente preservado -- nenhuma acao tomada." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [P-037] DELIBERACAO ja presente -- Musculo pode preencher diretamente." -ForegroundColor Green
    Write-Host "  Local: $destino"
    exit 0
}

# Salvar (UTF8 sem BOM via StreamWriter)
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($destino, $saida, $utf8NoBom)

Write-Host ""
Write-Host "  [P-037] DELIBERACAO_LOOP_V${loopAtual}_${clienteLow}.md gerada." -ForegroundColor Green
Write-Host "  Local: $destino"
Write-Host ""
Write-Host "  PROXIMO PASSO -- Musculo preenche as 4 partes:" -ForegroundColor Cyan
Write-Host "    PARTE 1: 25 inputs com filtro do Embaixador"
Write-Host "    PARTE 2: analise de 7 pontos por input qualificado"
Write-Host "    PARTE 3: plano consolidado (ENTRA AGORA / V2 / DESCARTADO)"
Write-Host "    PARTE 4: recomendacao do Musculo com pergunta ao Diretor"
Write-Host ""
Write-Host "  Diretor nao recebe 25 inputs -- recebe 1 plano. (P-037)" -ForegroundColor Cyan
