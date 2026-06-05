#Requires -Version 5.1
# session_close.ps1 -- wrapper (P-096: canonico em PENTALATERAL_UNIVERSAL\scripts\)
# Uso: .\scripts\session_close.ps1 [-Projeto NOME] [-DryRun] [-Friccao "..."] etc.
# Legado: session_close_LEGADO_2026-06-04.ps1

# PRE-CHECK: CONTEXTO SESSAO DIRETOR deve existir antes de fechar
$baseDir = Split-Path -Parent $PSScriptRoot
$dataHoje = Get-Date -Format "yyyy-MM-dd"
$contextoPath = "$baseDir\PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataHoje.md"
if (-not (Test-Path $contextoPath)) {
    Write-Host ""
    Write-Host "  [AVISO] CONTEXTO_SESSAO_DIRETOR_$dataHoje.md NAO ENCONTRADO" -ForegroundColor Yellow
    Write-Host "  Musculo: escreva o contexto conversacional ANTES de continuar." -ForegroundColor Yellow
    Write-Host "  Destino: PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataHoje.md" -ForegroundColor Yellow
    Write-Host "  Secoes obrigatorias: O que foi feito + Decisoes informais + Direcao do Diretor" -ForegroundColor Yellow
    Write-Host "  + Nuances importantes + Alertas emitidos + Contexto para proxima sessao" -ForegroundColor Yellow
    Write-Host ""
}

$universal = Join-Path (Split-Path -Parent $PSScriptRoot) "PENTALATERAL_UNIVERSAL\scripts\session_close.ps1"
& powershell.exe -NonInteractive -File $universal @args
$exitCode = $LASTEXITCODE

# N-3: fire-and-forget webhook n8n (so executa se n8n_config.ps1 existir e gates passaram)
if ($exitCode -eq 0) {
    $webhookScript = Join-Path $PSScriptRoot "n8n_session_webhook.ps1"
    if (Test-Path $webhookScript) {
        & powershell.exe -NonInteractive -File $webhookScript @args 2>$null
    }
}

# POS-CLOSE: lembrete de upload ao Embaixador (A4 -- acao insubstituivel do Diretor)
if ($exitCode -eq 0) {
    $dataFim = Get-Date -Format "yyyy-MM-dd"
    $contextoFimPath = "$baseDir\PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataFim.md"
    if (Test-Path $contextoFimPath) {
        Write-Host ""
        Write-Host "  [A4 -- ACAO DO DIRETOR]" -ForegroundColor Cyan
        Write-Host "  Arrastar para Claude Projects (Embaixador):" -ForegroundColor Cyan
        Write-Host "  PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataFim.md" -ForegroundColor White
        Write-Host "  O Embaixador processa na proxima ativacao e abre com contexto completo." -ForegroundColor Cyan
        Write-Host ""
    }
}

exit $exitCode
