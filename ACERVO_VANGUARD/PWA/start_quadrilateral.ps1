# PENTALATERAL IAH — Iniciar API do sistema
# Uso: .\start_pentalateral.ps1

Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  PENTALATERAL IAH — Iniciando sistema..." -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Verificar ANTHROPIC_API_KEY
if (-not $env:ANTHROPIC_API_KEY) {
    Write-Host "⚠️  ANTHROPIC_API_KEY não configurada." -ForegroundColor Yellow
    Write-Host "   O Auditor automático não funcionará." -ForegroundColor Yellow
    Write-Host "   Configure: `$env:ANTHROPIC_API_KEY = 'sk-ant-...'" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "🚀 Iniciando API na porta 8765..." -ForegroundColor Green
Write-Host "   Acesse: http://localhost:8765/status" -ForegroundColor Gray
Write-Host "   Docs:   http://localhost:8765/docs" -ForegroundColor Gray
Write-Host ""
Write-Host "   Para parar: Ctrl+C" -ForegroundColor Gray
Write-Host ""

Set-Location "$PSScriptRoot\pentalateral"
uvicorn api.main:app --reload --port 8765
