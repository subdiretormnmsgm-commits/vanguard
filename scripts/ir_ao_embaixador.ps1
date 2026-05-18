# ir_ao_embaixador.ps1
# Quadrilateral IAH - V25
#
# QUANDO RODAR: sempre que for interagir com o Embaixador (Claude Projects).
# O Musculo roda este script automaticamente ao detectar intencao de ir ao Claude Projects.
#
# O QUE FAZ (em sequencia):
#   1. Detecta o cliente ativo no WIP_BOARD
#   2. Copia MENSAGEM_INTERACAO_INICIAL.md para o clipboard (so colar no chat)
#   3. Abre o browser no Claude Projects
#   4. Abre o Explorer na pasta CLAUDE_PROJECT do cliente
#   5. Exibe instrucoes com arquivos a subir e status de contrato
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

# PASSO 0 -- Auto-detectar cliente
if (-not $cliente) {
    Write-Host "[0/4] Detectando cliente ativo no WIP_BOARD..." -ForegroundColor Yellow
    $wip = Get-Content "$raiz\CLIENTES\WIP_BOARD.json" -Raw | ConvertFrom-Json
    $projeto = @($wip.board.build) | Where-Object { $_ } | Select-Object -First 1
    if ($projeto) {
        $cliente = $projeto.cliente.ToUpper()
        $projetoId = $projeto.id
        $projetoNome = $projeto.projeto
        Write-Host "  Cliente detectado: $cliente ($projetoId - $projetoNome)" -ForegroundColor Green
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
    Write-Host "[0/4] Cliente: $cliente ($projetoId)" -ForegroundColor Green
}

$claude_project_dir = "$raiz\CLIENTES\$cliente\CLAUDE_PROJECT"
$instrucao  = "$claude_project_dir\00_INSTRUCAO_SISTEMA.md"
$mensagem   = "$claude_project_dir\MENSAGEM_INTERACAO_INICIAL.md"
$contratoStatus = "$raiz\CLIENTES\$cliente\CONTRATO_STATUS.txt"

# PASSO 1 -- Copiar mensagem de ativacao para o clipboard
Write-Host ""
Write-Host "[1/4] Copiando mensagem de ativacao para o clipboard..." -ForegroundColor Yellow
if (Test-Path $mensagem) {
    Get-Content $mensagem -Raw -Encoding UTF8 | Set-Clipboard
    Write-Host "  [OK] Mensagem copiada -- so colar (Ctrl+V) no chat do Claude Projects" -ForegroundColor Green
} else {
    Write-Host "  [--] MENSAGEM_INTERACAO_INICIAL.md nao encontrada em:" -ForegroundColor Red
    Write-Host "       $mensagem" -ForegroundColor DarkGray
}

# PASSO 2 -- Abrir browser no Claude Projects
Write-Host ""
Write-Host "[2/4] Abrindo Claude Projects no browser..." -ForegroundColor Yellow
Start-Process "https://claude.ai/projects"
Start-Sleep -Seconds 1

# PASSO 3 -- Abrir Explorer na pasta CLAUDE_PROJECT
Write-Host ""
Write-Host "[3/4] Abrindo Explorer na pasta do Embaixador..." -ForegroundColor Yellow
if (Test-Path $claude_project_dir) {
    Start-Process explorer.exe $claude_project_dir
    Write-Host "  [OK] Explorer aberto em $claude_project_dir" -ForegroundColor Green
} else {
    Write-Host "  [AVISO] Pasta nao encontrada: $claude_project_dir" -ForegroundColor Yellow
}

# PASSO 4 -- Status do contrato
Write-Host ""
Write-Host "[4/4] Verificando status do contrato..." -ForegroundColor Yellow
if (Test-Path $contratoStatus) {
    $status = Get-Content $contratoStatus -Raw
    if ($status -match "\[ASSINADO\]") {
        Write-Host "  [OK] Contrato: ASSINADO" -ForegroundColor Green
    } else {
        Write-Host "  [!!] Contrato: PENDENTE DE ASSINATURA (P-023 ativo)" -ForegroundColor Red
    }
} else {
    Write-Host "  [--] CONTRATO_STATUS.txt nao existe -- criar apos assinatura" -ForegroundColor Yellow
}

# INSTRUCOES FINAIS
Write-Host ""
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host "  INSTRUCOES -- O QUE FAZER NO CLAUDE PROJECTS  " -ForegroundColor Magenta
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  PROJECT: $projetoId - $cliente" -ForegroundColor White
Write-Host ""
Write-Host "  SE FOR A PRIMEIRA VEZ (configuracao inicial):" -ForegroundColor Yellow
Write-Host "  1. Criar novo Project para $cliente em claude.ai/projects" -ForegroundColor White
Write-Host "  2. Colar o conteudo abaixo nas Instructions do Project:" -ForegroundColor White
Write-Host "     $instrucao" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  3. Subir estes arquivos na aba Files do Project:" -ForegroundColor White
Write-Host ""

# Lista de arquivos a subir — com deteccao automatica do contrato/termo
$contratoArquivo = Get-ChildItem "$raiz\CLIENTES\$cliente" -Filter "Contrato_*.docx" -ErrorAction SilentlyContinue |
                   Sort-Object Name -Descending | Select-Object -First 1
$termoArquivo    = Get-ChildItem "$raiz\CLIENTES\$cliente" -Filter "Termo_*.pdf" -ErrorAction SilentlyContinue |
                   Sort-Object Name -Descending | Select-Object -First 1

$arquivos = [System.Collections.ArrayList]@(
    @{ Nome = "BRIEFING_DISCOVERY.txt";  Caminho = "$raiz\CLIENTES\$cliente\BRIEFING_DISCOVERY.txt" },
    @{ Nome = "WIP_BOARD.json";          Caminho = "$raiz\CLIENTES\WIP_BOARD.json" },
    @{ Nome = "VANGUARD_TIMELINE.md";    Caminho = "$raiz\VANGUARD_TIMELINE.md" },
    @{ Nome = "INTELLIGENCE_LEDGER.md";  Caminho = "$raiz\INTELLIGENCE_LEDGER.md" }
)

if ($contratoArquivo) {
    $arquivos.Insert(1, @{ Nome = $contratoArquivo.Name; Caminho = $contratoArquivo.FullName })
}
if ($termoArquivo) {
    $arquivos.Insert(1, @{ Nome = $termoArquivo.Name; Caminho = $termoArquivo.FullName })
}

$i = 1
foreach ($arq in $arquivos) {
    $existe = if (Test-Path $arq.Caminho) { "[OK]" } else { "[--]" }
    $cor    = if ($existe -eq "[OK]") { "White" } else { "Red" }
    Write-Host "     [$i] $($arq.Nome) $existe" -ForegroundColor $cor
    Write-Host "         $($arq.Caminho)" -ForegroundColor DarkGray
    $i++
}

Write-Host ""
Write-Host "  SE JA ESTIVER CONFIGURADO (sessao ativa):" -ForegroundColor Yellow
Write-Host "  O clipboard JA TEM a mensagem de ativacao." -ForegroundColor Green
Write-Host "  Cole (Ctrl+V) diretamente no chat do Project." -ForegroundColor White
Write-Host ""
Write-Host "  O Embaixador vai entregar SEM voce pedir:" -ForegroundColor Yellow
Write-Host "  [A] Diagnostico cruzado -- so ele pode ver (memoria persistente)" -ForegroundColor White
Write-Host "  [B] Artefatos prontos -- mensagens, scripts, respostas" -ForegroundColor White
Write-Host "  [C] Mapa de risco com cenarios sutis" -ForegroundColor White
Write-Host "  [D] Simulacao de cenario -- teste de resiliencia" -ForegroundColor White
Write-Host "  [E] Sentinel Report / Contribuicao ao Conselho" -ForegroundColor White
Write-Host "  [F/G] LOG_CLIENTE desta sessao (fonte 17 do Auditor)" -ForegroundColor White
Write-Host ""
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host ""
