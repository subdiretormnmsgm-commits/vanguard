# ir_ao_gemini.ps1
# Quadrilateral IAH - V25
#
# QUANDO RODAR: sempre que for iniciar sessao com o Estrategista (Gemini).
# O Musculo roda este script automaticamente ao detectar intencao de ir ao Gemini.
#
# O QUE FAZ (em sequencia):
#   1. Roda gemini_anchor_generator.ps1 (gera CONTEXTO_GEMINI.md + copia clipboard)
#   2. Abre o browser no Gemini
#   3. Abre o Explorer na raiz do projeto (para arrastar arquivos ao Gemini)
#   4. Exibe instrucoes completas com caminhos dos arquivos a anexar
#
# USO:
#   .\scripts\ir_ao_gemini.ps1

$ErrorActionPreference = "Stop"
$raiz = $PSScriptRoot | Split-Path -Parent

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "  QUADRILATERAL IAH -- Indo ao Estrategista      " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# PASSO 1 -- Gerar contexto e copiar para clipboard
Write-Host "[1/4] Gerando CONTEXTO_GEMINI.md..." -ForegroundColor Yellow
& "$PSScriptRoot\gemini_anchor_generator.ps1"

# PASSO 2 -- Detectar cliente ativo no WIP_BOARD
Write-Host ""
Write-Host "[2/4] Detectando projeto ativo..." -ForegroundColor Yellow
$wip = Get-Content "$raiz\CLIENTES\WIP_BOARD.json" -Raw | ConvertFrom-Json
$projeto = @($wip.board.build) | Where-Object { $_ } | Select-Object -First 1
$cliente = if ($projeto) { $projeto.id + " - " + $projeto.cliente } else { "Nenhum projeto em BUILD" }
$clienteNome = if ($projeto) { $projeto.cliente.ToUpper() } else { "" }
Write-Host "  Projeto ativo: $cliente" -ForegroundColor Green

# PASSO 3 -- Abrir browser no Gemini
Write-Host ""
Write-Host "[3/4] Abrindo Gemini no browser..." -ForegroundColor Yellow
Start-Process "https://gemini.google.com"
Start-Sleep -Seconds 1

# PASSO 4 -- Abrir Explorer na raiz (para selecionar arquivos)
Write-Host "[4/4] Abrindo Explorer na pasta do projeto..." -ForegroundColor Yellow
Start-Process explorer.exe $raiz

# INSTRUCOES FINAIS
Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "  INSTRUCOES -- O QUE FAZER NO GEMINI           " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. O clipboard ja tem o CONTEXTO_GEMINI.md" -ForegroundColor White
Write-Host "     Cole (Ctrl+V) no chat do Gemini PRIMEIRO" -ForegroundColor White
Write-Host ""
Write-Host "  2. Anexe estes arquivos (nesta ordem):" -ForegroundColor Yellow
Write-Host ""
Write-Host "     [1] INTELLIGENCE_LEDGER.md" -ForegroundColor White
Write-Host "         $raiz\INTELLIGENCE_LEDGER.md" -ForegroundColor DarkGray
Write-Host ""
Write-Host "     [2] WIP_BOARD.json" -ForegroundColor White
Write-Host "         $raiz\CLIENTES\WIP_BOARD.json" -ForegroundColor DarkGray
Write-Host ""

if ($clienteNome) {
    $historico = "$raiz\CLIENTES\$clienteNome\HISTORICO"
    $mem = Get-ChildItem $historico -Filter "MEMORIA_V*.md" -ErrorAction SilentlyContinue |
           Sort-Object Name -Descending | Select-Object -First 1
    $rel = Get-ChildItem $historico -Filter "relatorio_evolutivo_V*.md" -ErrorAction SilentlyContinue |
           Sort-Object Name -Descending | Select-Object -First 1

    if ($mem) {
        Write-Host "     [3] $($mem.Name)" -ForegroundColor White
        Write-Host "         $($mem.FullName)" -ForegroundColor DarkGray
        Write-Host ""
    }
    if ($rel) {
        Write-Host "     [4] $($rel.Name)" -ForegroundColor White
        Write-Host "         $($rel.FullName)" -ForegroundColor DarkGray
        Write-Host ""
    }

    $passo3 = "$raiz\CLIENTES\$clienteNome\PASSO3_GEMINI.md"
    if (Test-Path $passo3) {
        Write-Host "     [5] PASSO3_GEMINI.md" -ForegroundColor White
        Write-Host "         $passo3" -ForegroundColor DarkGray
        Write-Host ""
    }

    $vanguardTimeline = "$raiz\VANGUARD_TIMELINE.md"
    if (Test-Path $vanguardTimeline) {
        Write-Host "     [6] VANGUARD_TIMELINE.md" -ForegroundColor White
        Write-Host "         $vanguardTimeline" -ForegroundColor DarkGray
        Write-Host ""
    }

    $cmdEmbaixador = "$raiz\CONSELHO\COMANDO_GEMINI_EMBAIXADOR.md"
    if (Test-Path $cmdEmbaixador) {
        Write-Host "     [7] COMANDO_GEMINI_EMBAIXADOR.md (se for sessao do Embaixador)" -ForegroundColor White
        Write-Host "         $cmdEmbaixador" -ForegroundColor DarkGray
        Write-Host ""
    }
}

Write-Host "  3. Cole o conteudo do PASSO3_GEMINI.md como mensagem principal" -ForegroundColor Yellow
Write-Host "     (ou COMANDO_GEMINI_EMBAIXADOR.md se for sessao do Embaixador)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  4. Apos receber a DIRETRIZ, salvar como:" -ForegroundColor Yellow
Write-Host "     CLIENTES\$clienteNome\DIRETRIZ_GEMINI_V[N].txt" -ForegroundColor White
Write-Host ""
Write-Host "  5. Depois rodar:" -ForegroundColor Yellow
Write-Host "     .\scripts\ir_ao_notebooklm.ps1 -cliente $clienteNome" -ForegroundColor White
Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""
