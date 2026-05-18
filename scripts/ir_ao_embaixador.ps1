# ir_ao_embaixador.ps1
# Quadrilateral IAH - V25
#
# QUANDO RODAR: sempre que for interagir com o Embaixador (Claude Projects).
# O Musculo roda este script automaticamente ao detectar intencao de ir ao Claude Projects.
#
# O QUE FAZ (em sequencia):
#   1. Detecta o cliente ativo no WIP_BOARD
#   2. Abre o browser no Claude Projects
#   3. Abre o Explorer na pasta CLAUDE_PROJECT do cliente
#   4. Exibe instrucoes com arquivos a subir e mensagem de ativacao
#
# USO:
#   .\scripts\ir_ao_embaixador.ps1 -cliente INGRID
#   .\scripts\ir_ao_embaixador.ps1 -cliente VALDECE
#   .\scripts\ir_ao_embaixador.ps1            (detecta cliente ativo automaticamente)

param(
    [string]$cliente = ""
)

$ErrorActionPreference = "Stop"
$raiz = $PSScriptRoot | Split-Path -Parent

Write-Host ""
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host "  QUADRILATERAL IAH -- Indo ao Embaixador        " -ForegroundColor Magenta
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host ""

# Auto-detectar cliente se nao informado
if (-not $cliente) {
    $wip = Get-Content "$raiz\CLIENTES\WIP_BOARD.json" -Raw | ConvertFrom-Json
    $projeto = @($wip.board.build) | Where-Object { $_ } | Select-Object -First 1
    if ($projeto) {
        $cliente = $projeto.cliente.ToUpper()
        $projetoId = $projeto.id
        $projetoNome = $projeto.projeto
        Write-Host "  Cliente detectado: $cliente ($projetoId)" -ForegroundColor Green
    } else {
        Write-Host "  [ERRO] Nenhum projeto em BUILD no WIP_BOARD." -ForegroundColor Red
        Write-Host "         Informe o cliente: -cliente INGRID" -ForegroundColor Yellow
        exit 1
    }
} else {
    $cliente = $cliente.ToUpper()
    $wip = Get-Content "$raiz\CLIENTES\WIP_BOARD.json" -Raw | ConvertFrom-Json
    $projeto = @($wip.board.build) | Where-Object { $_.cliente.ToUpper() -eq $cliente } | Select-Object -First 1
    $projetoId = if ($projeto) { $projeto.id } else { "?" }
    $projetoNome = if ($projeto) { $projeto.projeto } else { $cliente }
}

$claude_project_dir = "$raiz\CLIENTES\$cliente\CLAUDE_PROJECT"
$instrucao = "$claude_project_dir\00_INSTRUCAO_SISTEMA.md"
$mensagem = "$claude_project_dir\MENSAGEM_INTERACAO_INICIAL.md"

# Abrir browser no Claude Projects
Write-Host "[1/3] Abrindo Claude Projects no browser..." -ForegroundColor Yellow
Start-Process "https://claude.ai/projects"
Start-Sleep -Seconds 1

# Abrir Explorer na pasta CLAUDE_PROJECT
Write-Host "[2/3] Abrindo Explorer na pasta do Embaixador..." -ForegroundColor Yellow
if (Test-Path $claude_project_dir) {
    Start-Process explorer.exe $claude_project_dir
} else {
    Write-Host "  [AVISO] Pasta nao encontrada: $claude_project_dir" -ForegroundColor Yellow
}

# Instrucoes
Write-Host "[3/3] Instrucoes prontas." -ForegroundColor Yellow

Write-Host ""
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host "  INSTRUCOES -- O QUE FAZER NO CLAUDE PROJECTS  " -ForegroundColor Magenta
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  PROJECT: $projetoId - $cliente" -ForegroundColor White
Write-Host ""
Write-Host "  SE FOR A PRIMEIRA VEZ (configuracao):" -ForegroundColor Yellow
Write-Host "  1. Criar novo Project para $cliente em claude.ai/projects" -ForegroundColor White
Write-Host "  2. Colar Instructions (aba do Project):" -ForegroundColor White
Write-Host "     $instrucao" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  3. Subir estes arquivos (aba Files do Project):" -ForegroundColor White
Write-Host ""

$arquivos = @(
    @{ Nome = "BRIEFING_DISCOVERY.txt"; Caminho = "$raiz\CLIENTES\$cliente\BRIEFING_DISCOVERY.txt" },
    @{ Nome = "Contrato / Termo de Uso"; Caminho = "$claude_project_dir (ver pasta)" },
    @{ Nome = "WIP_BOARD.json"; Caminho = "$raiz\CLIENTES\WIP_BOARD.json" },
    @{ Nome = "VANGUARD_TIMELINE.md"; Caminho = "$raiz\VANGUARD_TIMELINE.md" },
    @{ Nome = "INTELLIGENCE_LEDGER.md"; Caminho = "$raiz\INTELLIGENCE_LEDGER.md" }
)

$i = 1
foreach ($arq in $arquivos) {
    $existe = if (Test-Path $arq.Caminho) { "[OK]" } else { "[--]" }
    Write-Host "     [$i] $($arq.Nome)" -ForegroundColor White
    Write-Host "         $($arq.Caminho) $existe" -ForegroundColor DarkGray
    $i++
}

Write-Host ""
Write-Host "  SE JA ESTIVER CONFIGURADO (sessao ativa):" -ForegroundColor Yellow
Write-Host "  Colar no chat a mensagem de ativacao:" -ForegroundColor White
Write-Host "  $mensagem" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  O Embaixador deve responder SEM voce pedir:" -ForegroundColor Yellow
Write-Host "  - Estado do relacionamento com $cliente" -ForegroundColor White
Write-Host "  - Maior risco desta semana" -ForegroundColor White
Write-Host "  - Acao proativa recomendada agora" -ForegroundColor White
Write-Host ""
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host ""
