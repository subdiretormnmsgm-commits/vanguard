# ============================================================
# WIP_GUARD_SOBERANO.PS1 — Pre-veredito validation
# Musculo roda ANTES de chamar o Diretor para o Veredito.
# Se nao passar em todos os checks, nao chama.
#
# Uso: .\scripts\wip_guard_soberano.ps1 -cliente INGRID
#
# Exit code 0 = ALL CHECKS PASSED
# Exit code 1 = BLOQUEADO (erros criticos)
# ============================================================

param(
    [string]$cliente = "INGRID"
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot

$erros  = @()
$avisos = @()

Write-Host ""
Write-Host "  =================================================" -ForegroundColor Cyan
Write-Host "  WIP GUARD SOBERANO -- PRE-VEREDITO VALIDATION"    -ForegroundColor Cyan
Write-Host "  Cliente : $($cliente.ToUpper())"                  -ForegroundColor Cyan
Write-Host "  Data    : $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor Cyan
Write-Host "  =================================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------------------------------
# CHECK 1 -- Credito Anthropic
# Tenta chave local (.env.local do cliente). Se nao encontrar,
# avisa mas nao bloqueia (chave pode estar so no Supabase Secrets).
# ------------------------------------------------------------------
Write-Host "  [1/4] Credito Anthropic..." -ForegroundColor White

$apiKey = $env:ANTHROPIC_API_KEY
if (-not $apiKey) {
    $envPath = Join-Path $BASE "CLIENTES\$($cliente.ToUpper())\.env.local"
    if (Test-Path $envPath) {
        $linhas = Get-Content $envPath | Where-Object { $_ -match "^ANTHROPIC_API_KEY=" }
        if ($linhas) { $apiKey = ($linhas -split "=", 2)[1].Trim() }
    }
}

if ($apiKey) {
    try {
        $body = '{"model":"claude-haiku-4-5-20251001","max_tokens":1,"messages":[{"role":"user","content":"ping"}]}'
        $r = Invoke-RestMethod -Uri "https://api.anthropic.com/v1/messages" `
            -Method POST `
            -Headers @{
                "x-api-key"         = $apiKey
                "anthropic-version" = "2023-06-01"
                "content-type"      = "application/json"
            } `
            -Body $body -ErrorAction Stop
        Write-Host "  [OK] Credito Anthropic: disponivel" -ForegroundColor Green
    } catch {
        $errBody = ""
        if ($_.ErrorDetails.Message) { $errBody = $_.ErrorDetails.Message }
        if ($errBody -match "credit" -or $errBody -match "billing" -or $errBody -match "Plans") {
            $erros += "CRITICO: Creditos Anthropic esgotados -- https://console.anthropic.com/settings/plans"
            Write-Host "  [CRITICO] Creditos Anthropic esgotados" -ForegroundColor Red
        } else {
            $avisos += "AVISO: Anthropic API retornou erro inesperado -- $($_.Exception.Message)"
            Write-Host "  [AVISO] Anthropic: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
} else {
    $avisos += "AVISO: ANTHROPIC_API_KEY nao encontrada localmente (chave pode estar so no Supabase Secrets -- ok para producao)"
    Write-Host "  [AVISO] Chave nao encontrada localmente (verificar Supabase Secrets)" -ForegroundColor Yellow
}

# ------------------------------------------------------------------
# CHECK 2 -- App URL live (HTTP ping)
# Nota: PowerShell nao simula CORS de browser.
# Este check valida que o app esta no ar -- nao os headers CORS.
# Para CORS: testar manualmente no browser antes do Veredito.
# ------------------------------------------------------------------
Write-Host "  [2/4] App URL (HTTP ping)..." -ForegroundColor White

$appUrl = "https://subdiretormnmsgm-commits.github.io/vanguard/"
try {
    $r = Invoke-WebRequest -Uri $appUrl -Method GET -TimeoutSec 20 -ErrorAction Stop -UseBasicParsing
    if ($r.StatusCode -eq 200) {
        Write-Host "  [OK] App URL live: HTTP $($r.StatusCode)" -ForegroundColor Green
    } else {
        $avisos += "AVISO: App URL retornou HTTP $($r.StatusCode) -- verificar GitHub Pages"
        Write-Host "  [AVISO] App URL: HTTP $($r.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    $erros += "CRITICO: App URL inacessivel -- $appUrl"
    Write-Host "  [CRITICO] App URL inacessivel" -ForegroundColor Red
}

# ------------------------------------------------------------------
# CHECK 3 -- Setup obrigatorio (chama verificar_projeto.ps1)
# Valida os 6 artefatos de P-041.
# ------------------------------------------------------------------
Write-Host "  [3/4] Setup do projeto ($($cliente.ToUpper()))..." -ForegroundColor White

$setupOutput = & "$BASE\scripts\verificar_projeto.ps1" -cliente $cliente 2>&1 | Out-String
if ($setupOutput -match "SETUP COMPLETO") {
    Write-Host "  [OK] Setup: 6 artefatos presentes (P-041)" -ForegroundColor Green
} else {
    $erros += "CRITICO: Setup incompleto -- rodar: .\scripts\verificar_projeto.ps1 -cliente $cliente"
    Write-Host "  [CRITICO] Setup incompleto -- ver detalhes em verificar_projeto.ps1" -ForegroundColor Red
}

# ------------------------------------------------------------------
# CHECK 4 -- Banco de questoes (Supabase)
# Verifica contagem real no banco antes de declarar gate pronto.
# ------------------------------------------------------------------
Write-Host "  [4/4] Banco de questoes (Supabase)..." -ForegroundColor White

$supaUrl = "https://ehyaecxqijgyuuiorzcj.supabase.co"
$key     = $env:SUPABASE_SERVICE_ROLE_KEY

if ($key) {
    try {
        $headers = @{
            "apikey"        = $key
            "Authorization" = "Bearer $key"
            "Content-Type"  = "application/json"
            "Prefer"        = "count=exact"
        }
        $resp  = Invoke-WebRequest `
            -Uri "$supaUrl/rest/v1/questoes_quadrix?select=id&concurso_id=eq.sedes_df_2026" `
            -Headers $headers -TimeoutSec 15 -ErrorAction Stop -UseBasicParsing
        $count = 0
        if ($resp.Headers["Content-Range"]) {
            $count = [int]($resp.Headers["Content-Range"] -replace ".*/", "")
        }
        if ($count -ge 100) {
            Write-Host "  [OK] Banco: $count questoes disponiveis" -ForegroundColor Green
        } elseif ($count -gt 0) {
            $avisos += "AVISO: Banco com $count questoes (minimo recomendado: 100) -- rodar seed antes do gate"
            Write-Host "  [AVISO] Banco: $count questoes (minimo recomendado: 100)" -ForegroundColor Yellow
        } else {
            $erros += "CRITICO: Banco vazio -- rodar seed_questoes.ps1 antes de qualquer gate"
            Write-Host "  [CRITICO] Banco vazio -- gate nao pode ser executado" -ForegroundColor Red
        }
    } catch {
        $avisos += "AVISO: Banco inacessivel -- $($_.Exception.Message)"
        Write-Host "  [AVISO] Banco inacessivel (continua sem bloquear)" -ForegroundColor Yellow
    }
} else {
    $avisos += "AVISO: SUPABASE_SERVICE_ROLE_KEY nao configurada -- rodar iniciar.ps1 primeiro"
    Write-Host "  [AVISO] Chave Supabase nao encontrada -- rodar iniciar.ps1 -opcao 6 primeiro" -ForegroundColor Yellow
}

# ------------------------------------------------------------------
# RESULTADO FINAL
# ------------------------------------------------------------------
Write-Host ""
Write-Host "  =================================================" -ForegroundColor Cyan

if ($erros.Count -eq 0) {
    Write-Host "  ALL CHECKS PASSED" -ForegroundColor Green
    Write-Host "  Sistema pronto. Diretor pode ser acionado para o Veredito." -ForegroundColor Green
    Write-Host ""
    Write-Host "  LEMBRETE (nao automatizavel via PowerShell):" -ForegroundColor DarkGray
    Write-Host "  [ ] Testar no browser real antes do Veredito (CORS -- P-039)" -ForegroundColor DarkGray
} else {
    Write-Host "  BLOQUEADO -- $($erros.Count) erro(s) critico(s)" -ForegroundColor Red
    Write-Host ""
    foreach ($e in $erros) {
        Write-Host "  >> $e" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "  Musculo nao aciona o Diretor ate resolver os erros acima." -ForegroundColor Red
}

if ($avisos.Count -gt 0) {
    Write-Host ""
    Write-Host "  Avisos (nao bloqueantes):" -ForegroundColor Yellow
    foreach ($a in $avisos) {
        Write-Host "  [!] $a" -ForegroundColor Yellow
    }
}

Write-Host "  =================================================" -ForegroundColor Cyan
Write-Host ""

if ($erros.Count -gt 0) { exit 1 } else { exit 0 }
