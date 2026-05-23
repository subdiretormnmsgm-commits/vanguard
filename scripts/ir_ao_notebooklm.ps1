# ir_ao_notebooklm.ps1
# Pentalateral IAH - V25
#
# QUANDO RODAR: sempre que for iniciar sessao com o Auditor (NotebookLM).
# O Musculo roda este script automaticamente ao detectar intencao de ir ao NotebookLM.
#
# O QUE FAZ (em sequencia):
#   1. Roda preparar_notebooklm_projeto.ps1 (monta NOTEBOOKLM_FONTES/)
#   2. Abre o browser no NotebookLM
#   3. Explorer ja abre automaticamente apontando para a pasta de fontes
#   4. Exibe instrucoes completas com o que colar no chat
#
# USO:
#   .\scripts\ir_ao_notebooklm.ps1 -cliente INGRID
#   .\scripts\ir_ao_notebooklm.ps1 -cliente VALDECE
#   .\scripts\ir_ao_notebooklm.ps1            (detecta cliente ativo automaticamente)

param(
    [string]$cliente = ""
)

$ErrorActionPreference = "Stop"
$raiz = $PSScriptRoot | Split-Path -Parent

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "  Pentalateral IAH -- Indo ao Auditor           " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# Auto-detectar cliente se nao informado
if (-not $cliente) {
    Write-Host "[0/4] Detectando cliente ativo no WIP_BOARD..." -ForegroundColor Yellow
    $wip = Get-Content "$raiz\CLIENTES\WIP_BOARD.json" -Raw | ConvertFrom-Json
    $projeto = @($wip.board.build) | Where-Object { $_ } | Select-Object -First 1
    if ($projeto) {
        $cliente = $projeto.cliente.ToUpper()
        Write-Host "  Cliente detectado: $cliente" -ForegroundColor Green
    } else {
        Write-Host "  [ERRO] Nenhum projeto em BUILD no WIP_BOARD." -ForegroundColor Red
        Write-Host "         Informe o cliente manualmente: -cliente INGRID" -ForegroundColor Yellow
        exit 1
    }
} else {
    $cliente = $cliente.ToUpper()
}

$fontes_dir = "$raiz\CLIENTES\$cliente\NOTEBOOKLM_FONTES"
$passo5 = "$raiz\CLIENTES\$cliente\PASSO5_NOTEBOOKLM.md"
$missaoEmbaixador = "$raiz\CONSELHO\MISSAO_NOTEBOOKLM_EMBAIXADOR.md"

# PASSO 1 -- Preparar fontes (roda atualizar_base + monta NOTEBOOKLM_FONTES)
Write-Host ""
Write-Host "[1/4] Preparando $($fontes_dir.Split('\')[-1]) para $cliente..." -ForegroundColor Yellow
& "$PSScriptRoot\preparar_notebooklm_projeto.ps1" -cliente $cliente

# PASSO 2 -- Contar documentos prontos
$total = (Get-ChildItem $fontes_dir -ErrorAction SilentlyContinue).Count
Write-Host ""
Write-Host "[2/4] $total documentos prontos em NOTEBOOKLM_FONTES\" -ForegroundColor Green

# PASSO 3 -- Abrir browser no NotebookLM
Write-Host ""
Write-Host "[3/4] Abrindo NotebookLM no browser..." -ForegroundColor Yellow
Start-Process "https://notebooklm.google.com"
Start-Sleep -Seconds 1

# PASSO 4 -- Instrucoes
Write-Host ""
Write-Host "[4/4] Explorer ja abriu na pasta de fontes." -ForegroundColor Yellow

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "  INSTRUCOES -- O QUE FAZER NO NOTEBOOKLM       " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. No Explorer: Ctrl+A para selecionar TUDO" -ForegroundColor White
Write-Host "     Arrastar todos os $total arquivos ao NotebookLM como fontes" -ForegroundColor White
Write-Host ""
Write-Host "  2. Fazer WIPE das fontes antigas ANTES de subir as novas" -ForegroundColor Yellow
Write-Host "     (apagar todas as fontes do loop anterior primeiro)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  3. Apos subir as fontes, colar no chat:" -ForegroundColor White

if (Test-Path $passo5) {
    Write-Host ""
    Write-Host "     SESSAO PADRAO (Skill do projeto):" -ForegroundColor Green
    Write-Host "     Abrir e copiar: $passo5" -ForegroundColor DarkGray
}

if (Test-Path $missaoEmbaixador) {
    Write-Host ""
    Write-Host "     SESSAO EMBAIXADOR (se for auditar o Embaixador):" -ForegroundColor Green
    Write-Host "     Abrir e copiar: $missaoEmbaixador" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "  4. Aguardar a Skill completa (4 partes obrigatorias)" -ForegroundColor White
Write-Host "     Validar com: .\scripts\skill_parser_gate.ps1" -ForegroundColor White
Write-Host ""
Write-Host "  5. Salvar a Skill recebida em:" -ForegroundColor White
Write-Host "     .claude\skills\[nome-da-skill].md" -ForegroundColor White
Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""
