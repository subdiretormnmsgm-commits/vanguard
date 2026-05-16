# atualizar_formalizador.ps1
# Regenera 00_INSTRUCAO_SISTEMA.md do cliente a partir do WIP_BOARD e documentos atuais.
# Abre o arquivo gerado para Eduardo colar nas Instructions do Claude Project.
# Uso: .\scripts\atualizar_formalizador.ps1 -cliente VALDECE

param([string]$cliente)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot

if (-not $cliente) {
    # Detectar projeto ativo automaticamente
    $wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
    $board   = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $proj    = @($board.board.build) | Select-Object -First 1
    if ($proj) { $cliente = $proj.cliente.ToUpper() } else {
        Write-Host "ERRO: nenhum projeto em BUILD e -cliente nao informado." -ForegroundColor Red
        exit 1
    }
}

$cliente     = $cliente.ToUpper()
$projectDir  = Join-Path $BASE "CLIENTES\$cliente\CLAUDE_PROJECT"
$instrucao   = Join-Path $projectDir "00_INSTRUCAO_SISTEMA.md"

if (-not (Test-Path $projectDir)) {
    Write-Host "ERRO: pasta CLAUDE_PROJECT nao encontrada para $cliente." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $instrucao)) {
    Write-Host "ERRO: 00_INSTRUCAO_SISTEMA.md nao encontrado para $cliente." -ForegroundColor Red
    exit 1
}

# Injetar data de atualizacao no cabecalho
$conteudo = Get-Content $instrucao -Raw -Encoding UTF8
$data     = Get-Date -Format "yyyy-MM-dd HH:mm"

# Atualizar ou inserir linha de versao no cabecalho
if ($conteudo -match "# Ultima atualizacao:") {
    $conteudo = $conteudo -replace "# Ultima atualizacao:.*", "# Ultima atualizacao: $data"
} else {
    $conteudo = $conteudo -replace "(# Papel:.*)", "`$1`n# Ultima atualizacao: $data"
}

Set-Content $instrucao -Value $conteudo -Encoding UTF8

Write-Host ""
Write-Host "================================================"
Write-Host "  FORMALIZADOR ATUALIZADO — $cliente"
Write-Host "================================================"
Write-Host ""
Write-Host "  Arquivo: CLIENTES\$cliente\CLAUDE_PROJECT\00_INSTRUCAO_SISTEMA.md"
Write-Host "  Data:    $data"
Write-Host ""
Write-Host "  Proximos passos:"
Write-Host "  1. Abrir claude.ai/projects -> $cliente"
Write-Host "  2. Settings -> Instructions -> substituir pelo conteudo do arquivo acima"
Write-Host "  3. Files -> verificar se os documentos estao atualizados"
Write-Host ""

# Abrir o arquivo no editor padrao
try {
    Start-Process $instrucao
    Write-Host "  Arquivo aberto automaticamente."
} catch {
    Write-Host "  Abra manualmente o arquivo indicado acima."
}

Write-Host "================================================"
