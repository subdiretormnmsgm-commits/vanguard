[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host ""
Write-Host "GATE 7.2 -- RLS Dry-Run Ingrid" -ForegroundColor Cyan
Write-Host "Cole a service role key (Settings > API > service_role) e pressione Enter:" -ForegroundColor Yellow
Write-Host ""
$key = Read-Host "Key"
if (-not $key) { Write-Host "Key vazia -- abortando." -ForegroundColor Red; exit 1 }
$env:SUPABASE_SERVICE_ROLE_KEY = $key
Write-Host ""
Write-Host "Rodando teste..." -ForegroundColor DarkGray
Write-Host ""
powershell -ExecutionPolicy Bypass -NonInteractive -File "$PSScriptRoot\test_tenant_isolation.ps1"
Write-Host ""
Write-Host "Pressione qualquer tecla para fechar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
