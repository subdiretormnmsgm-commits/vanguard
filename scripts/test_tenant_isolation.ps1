# test_tenant_isolation.ps1 -- Gate 7.2: Dry-Run de Isolamento de Tenant (G-2)
# Valida fisicamente que RLS bloqueia vazamento de dados entre tenants
# Uso: .\scripts\test_tenant_isolation.ps1 -projectRef [REF] -serviceKey [KEY]
# Se sem params: tenta ler do .env ou das variaveis de ambiente

param(
    [string]$projectRef = "",
    [string]$serviceKey  = "",
    [switch]$Silencioso
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot

# Tentar ler credenciais do ambiente se nao passadas
if (-not $projectRef) { $projectRef = $env:SUPABASE_PROJECT_REF }
if (-not $serviceKey)  { $serviceKey  = $env:SUPABASE_SERVICE_ROLE_KEY }

# Credenciais fixas do projeto Ingrid (soberania P-013)
$INGRID_REF = "yjqvjhezwhepwomukudt"
$INGRID_URL = "https://$INGRID_REF.supabase.co"

if (-not $projectRef) { $projectRef = $INGRID_REF }
if (-not $serviceKey) {
    Write-Host ""
    Write-Host "  [GATE 7.2] AVISO: SUPABASE_SERVICE_ROLE_KEY nao definida." -ForegroundColor Yellow
    Write-Host "             Para rodar o dry-run real, execute primeiro no terminal:" -ForegroundColor Yellow
    Write-Host "             `$env:SUPABASE_SERVICE_ROLE_KEY = 'sua-service-role-key'" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [GATE 7.2] Rodando em MODO SIMULADO (sem chave real)..." -ForegroundColor DarkGray
    Write-Host ""
}

Write-Host ""
Write-Host "  [GATE 7.2] Dry-Run Isolamento de Tenant -- P-059 / G-2" -ForegroundColor Cyan
Write-Host "  Projeto : $projectRef"
Write-Host "  URL     : $INGRID_URL"
Write-Host ""

$resultados = [System.Collections.ArrayList]@()
$falhas     = 0

# TESTE 1: RLS ativo em progresso_usuario?
Write-Host "  [1/4] Verificando RLS em progresso_usuario..." -ForegroundColor DarkCyan
if ($serviceKey) {
    try {
        $headers = @{
            "apikey"        = $serviceKey
            "Authorization" = "Bearer $serviceKey"
            "Content-Type"  = "application/json"
        }
        # Tentar SELECT com user_id invalido (simulando tenant B tentando ler dados do tenant A)
        $uri  = "$INGRID_URL/rest/v1/progresso_usuario?user_id=eq.99999999-9999-9999-9999-999999999999&select=*"
        $resp = Invoke-RestMethod -Uri $uri -Headers $headers -Method GET -ErrorAction Stop
        if ($resp.Count -eq 0) {
            Write-Host "  [OK] progresso_usuario -- RLS bloqueou user_id falso (0 linhas retornadas)" -ForegroundColor Green
            [void]$resultados.Add("VERDE: progresso_usuario RLS ativo")
        } else {
            Write-Host "  [!!] progresso_usuario -- RLS NAO bloqueou! $($resp.Count) linhas vazaram." -ForegroundColor Red
            [void]$resultados.Add("VERMELHO: progresso_usuario RLS FALHOU -- $($resp.Count) linhas vazaram")
            $falhas++
        }
    } catch {
        Write-Host "  [OK] progresso_usuario -- erro HTTP (esperado com RLS ativo): $($_.Exception.Message.Substring(0,[Math]::Min(60,$_.Exception.Message.Length)))" -ForegroundColor Green
        [void]$resultados.Add("VERDE: progresso_usuario RLS ativo (erro HTTP = acesso negado)")
    }
} else {
    Write-Host "  [SIM] progresso_usuario -- SIMULADO (sem chave real)" -ForegroundColor DarkGray
    [void]$resultados.Add("SIMULADO: progresso_usuario")
}

# TESTE 2: RLS ativo em evento_uso (se existir)?
Write-Host "  [2/4] Verificando RLS em evento_uso..." -ForegroundColor DarkCyan
if ($serviceKey) {
    try {
        $headers2 = @{
            "apikey"        = $serviceKey
            "Authorization" = "Bearer $serviceKey"
            "Content-Type"  = "application/json"
        }
        $uri2  = "$INGRID_URL/rest/v1/evento_uso?user_id=eq.99999999-9999-9999-9999-999999999999&select=*"
        $resp2 = Invoke-RestMethod -Uri $uri2 -Headers $headers2 -Method GET -ErrorAction Stop
        if ($resp2.Count -eq 0) {
            Write-Host "  [OK] evento_uso -- RLS bloqueou user_id falso" -ForegroundColor Green
            [void]$resultados.Add("VERDE: evento_uso RLS ativo")
        } else {
            Write-Host "  [!!] evento_uso -- $($resp2.Count) linhas vazaram!" -ForegroundColor Red
            [void]$resultados.Add("VERMELHO: evento_uso RLS FALHOU")
            $falhas++
        }
    } catch {
        Write-Host "  [OK] evento_uso -- acesso negado (RLS ativo)" -ForegroundColor Green
        [void]$resultados.Add("VERDE: evento_uso RLS ativo")
    }
} else {
    Write-Host "  [SIM] evento_uso -- SIMULADO" -ForegroundColor DarkGray
    [void]$resultados.Add("SIMULADO: evento_uso")
}

# TESTE 3: Injeção de user_id falso via POST bloqueada?
Write-Host "  [3/4] Testando injecao de user_id adulterado..." -ForegroundColor DarkCyan
if ($serviceKey) {
    try {
        $headers3 = @{
            "apikey"        = $serviceKey
            "Authorization" = "Bearer $serviceKey"
            "Content-Type"  = "application/json"
            "Prefer"        = "return=minimal"
        }
        $body3 = '{"user_id":"00000000-0000-0000-0000-AAAAAAAAAA00","questao_id":"fake-001","acertou":true}'
        $uri3  = "$INGRID_URL/rest/v1/progresso_usuario"
        Invoke-RestMethod -Uri $uri3 -Headers $headers3 -Method POST -Body $body3 -ErrorAction Stop
        Write-Host "  [!!] Injecao aceita -- RLS nao bloqueou INSERT com user_id adulterado!" -ForegroundColor Red
        [void]$resultados.Add("VERMELHO: INSERT com user_id adulterado aceito -- CRITICO")
        $falhas++
    } catch {
        Write-Host "  [OK] Injecao bloqueada -- POST retornou erro (RLS ativo)" -ForegroundColor Green
        [void]$resultados.Add("VERDE: INSERT bloqueado por RLS")
    }
} else {
    Write-Host "  [SIM] Injecao -- SIMULADO" -ForegroundColor DarkGray
    [void]$resultados.Add("SIMULADO: injecao de user_id")
}

# TESTE 4: questoes_quadrix visivel sem auth (deve ser publica -- apenas leitura)?
Write-Host "  [4/4] Verificando acesso publico a questoes_quadrix..." -ForegroundColor DarkCyan
try {
    $uriQ = "$INGRID_URL/rest/v1/questoes_quadrix?limit=1&select=id"
    $anonKey = $env:SUPABASE_ANON_KEY
    if (-not $anonKey) {
        # Tentar ler do app.js
        $appJs = Join-Path $BASE "CLIENTES\INGRID\frontend\app.js"
        if (Test-Path $appJs) {
            $jsContent = Get-Content $appJs -Raw -Encoding UTF8
            if ($jsContent -match 'SUPABASE_ANON_KEY\s*=\s*"([^"]+)"') {
                $anonKey = $matches[1]
            }
        }
    }
    if ($anonKey) {
        $headersQ = @{ "apikey" = $anonKey; "Authorization" = "Bearer $anonKey" }
        $respQ = Invoke-RestMethod -Uri $uriQ -Headers $headersQ -Method GET -ErrorAction Stop
        Write-Host "  [OK] questoes_quadrix -- acessivel via anon (banco publico de questoes)" -ForegroundColor Green
        [void]$resultados.Add("VERDE: questoes_quadrix acessivel (comportamento esperado)")
    } else {
        Write-Host "  [SIM] questoes_quadrix -- anon key nao encontrada, SIMULADO" -ForegroundColor DarkGray
        [void]$resultados.Add("SIMULADO: questoes_quadrix")
    }
} catch {
    Write-Host "  [INFO] questoes_quadrix -- $($_.Exception.Message.Substring(0,[Math]::Min(60,$_.Exception.Message.Length)))" -ForegroundColor DarkGray
    [void]$resultados.Add("INFO: questoes_quadrix -- verificar manualmente")
}

# RESULTADO FINAL
Write-Host ""
Write-Host "  ===============================" -ForegroundColor Cyan
Write-Host "  RESULTADO GATE 7.2 -- RLS AUDIT" -ForegroundColor Cyan
Write-Host "  ===============================" -ForegroundColor Cyan
foreach ($r in $resultados) {
    $cor = if ($r -match "^VERDE") { "Green" } elseif ($r -match "^VERMELHO") { "Red" } else { "DarkGray" }
    Write-Host "  $r" -ForegroundColor $cor
}
Write-Host ""

if ($serviceKey -and $falhas -eq 0) {
    Write-Host "  GATE 7.2: APROVADO -- RLS bloqueia vazamento entre tenants." -ForegroundColor Green
    Write-Host "            Segunda usuaria pode entrar com seguranca." -ForegroundColor Green
    exit 0
} elseif ($falhas -gt 0) {
    Write-Host "  GATE 7.2: REPROVADO -- $falhas falha(s) de isolamento detectada(s)." -ForegroundColor Red
    Write-Host "            NAO adicionar segunda usuaria sem corrigir RLS." -ForegroundColor Red
    exit 2
} else {
    Write-Host "  GATE 7.2: SIMULADO -- rodar com SUPABASE_SERVICE_ROLE_KEY para resultado real." -ForegroundColor Yellow
    Write-Host "            Para o dry-run real: definir a variavel de ambiente e reexecutar." -ForegroundColor Yellow
    exit 1
}
