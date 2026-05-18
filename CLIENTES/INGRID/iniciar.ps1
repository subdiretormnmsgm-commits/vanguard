# iniciar.ps1 - PROJ-002 Ingrid
# Ponto de entrada unico da sessao. Roda ISSO e o projeto comeca certo.
# Uso: .\CLIENTES\INGRID\iniciar.ps1

$PROJECT_REF = "ehyaecxqijgyuuiorzcj"
$SUPABASE_URL = "https://$PROJECT_REF.supabase.co"

Write-Host ""
Write-Host "  ======================================" -ForegroundColor Cyan
Write-Host "  PROJ-002 INGRID - Iniciar Sessao"      -ForegroundColor Cyan
Write-Host "  ======================================" -ForegroundColor Cyan
Write-Host ""

# ---------------------------------------------------------
# PASSO 1 - Garantir diretorio correto
# ---------------------------------------------------------
$raiz = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ((Get-Location).Path -ne $raiz) {
    Set-Location $raiz
    Write-Host "  [DIR] Diretorio ajustado para raiz do projeto." -ForegroundColor Yellow
}
Write-Host "  [DIR] OK - $((Get-Location).Path)" -ForegroundColor Green

# ---------------------------------------------------------
# PASSO 2 - Configurar variaveis de ambiente
# ---------------------------------------------------------
$env:SUPABASE_URL = $SUPABASE_URL
Write-Host "  [ENV] SUPABASE_URL configurada." -ForegroundColor Green

if (-not $env:SUPABASE_SERVICE_ROLE_KEY) {
    Write-Host ""
    Write-Host "  [ENV] SUPABASE_SERVICE_ROLE_KEY nao encontrada." -ForegroundColor Yellow
    Write-Host "  Supabase Dashboard -> Settings -> API -> service_role -> Reveal" -ForegroundColor White
    $chave = Read-Host "  Cole a service_role key"
    if (-not $chave) {
        Write-Host "  Chave nao fornecida. Encerrando." -ForegroundColor Red
        exit 1
    }
    $env:SUPABASE_SERVICE_ROLE_KEY = $chave
}
Write-Host "  [ENV] SUPABASE_SERVICE_ROLE_KEY configurada." -ForegroundColor Green

# ---------------------------------------------------------
# PASSO 3 - Verificar estado do banco (rapido)
# ---------------------------------------------------------
Write-Host ""
Write-Host "  Verificando banco..." -ForegroundColor White
try {
    $r = Invoke-RestMethod `
        -Uri "$SUPABASE_URL/rest/v1/questoes_quadrix?select=disciplina_id,count&concurso_id=eq.sedes_df_2026&groupby=disciplina_id" `
        -Headers @{
            "apikey"        = $env:SUPABASE_SERVICE_ROLE_KEY
            "Authorization" = "Bearer $env:SUPABASE_SERVICE_ROLE_KEY"
            "Content-Type"  = "application/json"
            "Prefer"        = "count=exact"
        } `
        -TimeoutSec 15 -ErrorAction Stop
    Write-Host "  [DB] Banco acessivel." -ForegroundColor Green
} catch {
    Write-Host "  [DB] Nao foi possivel verificar o banco (continua mesmo assim)." -ForegroundColor Yellow
}

# ---------------------------------------------------------
# PASSO 4 - Menu de acoes
# ---------------------------------------------------------
Write-Host ""
Write-Host "  O que voce quer fazer?" -ForegroundColor Cyan
Write-Host "  [1] Rodar seed (popular banco de questoes)"      -ForegroundColor White
Write-Host "  [2] Rodar Gate Dia 5 (validar feed 70/30)"       -ForegroundColor White
Write-Host "  [3] Deployar Edge Function (gerar-questoes)"     -ForegroundColor White
Write-Host "  [4] Deployar Edge Function (feed-diario)"        -ForegroundColor White
Write-Host "  [5] Deployar AMBAS as Edge Functions"            -ForegroundColor White
Write-Host "  [6] So configurar ambiente (sem acao)"           -ForegroundColor White
Write-Host ""

$opcao = Read-Host "  Escolha (1-6)"

switch ($opcao) {
    "1" {
        Write-Host ""
        $qtd = Read-Host "  Questoes por disciplina? (Enter = 25)"
        if (-not $qtd) { $qtd = "25" }
        & ".\CLIENTES\INGRID\seed_questoes.ps1" -QuantidadePorDisciplina ([int]$qtd)
    }
    "2" {
        Write-Host ""
        Write-Host "  Rodando Gate Dia 5..." -ForegroundColor Cyan
        node "CLIENTES\INGRID\gate_cli_dia5.js"
    }
    "3" {
        Write-Host ""
        Write-Host "  Deployando gerar-questoes..." -ForegroundColor Cyan
        npx supabase functions deploy gerar-questoes --project-ref $PROJECT_REF
    }
    "4" {
        Write-Host ""
        Write-Host "  Deployando feed-diario..." -ForegroundColor Cyan
        npx supabase functions deploy feed-diario --project-ref $PROJECT_REF
    }
    "5" {
        Write-Host ""
        Write-Host "  Deployando gerar-questoes..." -ForegroundColor Cyan
        npx supabase functions deploy gerar-questoes --project-ref $PROJECT_REF
        Write-Host "  Deployando feed-diario..." -ForegroundColor Cyan
        npx supabase functions deploy feed-diario --project-ref $PROJECT_REF
    }
    "6" {
        Write-Host ""
        Write-Host "  Ambiente configurado. Variaveis ativas nesta sessao do PowerShell." -ForegroundColor Green
    }
    default {
        Write-Host "  Opcao invalida." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "  Loop atual   : Loop 3 - Build Dias 6-8" -ForegroundColor DarkGray
Write-Host "  Gate proximo : Dia 8 — Ingrid responde 10 questoes" -ForegroundColor DarkGray
Write-Host "  Deadline     : 2026-05-30" -ForegroundColor DarkGray
Write-Host ""
