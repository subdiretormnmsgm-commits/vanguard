#Requires -Version 5.1
# deploy_functions.ps1 — Deploy Edge Functions Ingrid para Supabase
# Uso: .\deploy_functions.ps1

$raiz = "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard\CLIENTES\INGRID"
Set-Location $raiz

Write-Host ""
Write-Host "=== DEPLOY EDGE FUNCTIONS — INGRID ===" -ForegroundColor Cyan
Write-Host "Diretório: $raiz"
Write-Host ""

# Passo 1 — Login
Write-Host "PASSO 1: Login no Supabase (abre browser)..." -ForegroundColor Yellow
npx supabase login

Write-Host ""
Write-Host "PASSO 2: Deploy gatilho-temporal..." -ForegroundColor Yellow
npx supabase functions deploy gatilho-temporal --project-ref yjqvjhezwhepwomukudt --use-api

Write-Host ""
Write-Host "PASSO 3: Deploy relatorio-semanal..." -ForegroundColor Yellow
npx supabase functions deploy relatorio-semanal --project-ref yjqvjhezwhepwomukudt --use-api

Write-Host ""
Write-Host "=== CONCLUÍDO ===" -ForegroundColor Cyan
