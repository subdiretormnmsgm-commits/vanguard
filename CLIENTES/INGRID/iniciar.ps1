# iniciar.ps1 - PROJ-002 Ingrid
# Ponto de entrada unico da sessao. Roda ISSO e o projeto comeca certo.
# Uso interativo : .\CLIENTES\INGRID\iniciar.ps1
# Uso automatico : .\CLIENTES\INGRID\iniciar.ps1 -opcao G
#                  .\CLIENTES\INGRID\iniciar.ps1 -opcao N
#                  .\CLIENTES\INGRID\iniciar.ps1 -opcao E
#                  .\CLIENTES\INGRID\iniciar.ps1 -opcao V

param(
    [string]$opcao = ""
)

$PROJECT_REF  = "ehyaecxqijgyuuiorzcj"
$SUPABASE_URL = "https://$PROJECT_REF.supabase.co"

Write-Host ""
Write-Host "  ======================================" -ForegroundColor Cyan
Write-Host "  PROJ-002 INGRID - Iniciar Sessao"      -ForegroundColor Cyan
Write-Host "  Loop 3 - Dias 6-8 (Build concluido)"   -ForegroundColor Cyan
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
# Carrega automaticamente de .env.local se existir (P-039 fix)
# ---------------------------------------------------------
$env:SUPABASE_URL = $SUPABASE_URL
Write-Host "  [ENV] SUPABASE_URL configurada." -ForegroundColor Green

$envLocalPath = Join-Path $PSScriptRoot ".env.local"
if (Test-Path $envLocalPath) {
    $linhas = Get-Content $envLocalPath | Where-Object { $_ -match "^[^#]" -and $_ -match "=" }
    foreach ($linha in $linhas) {
        $partes = $linha -split "=", 2
        $nome   = $partes[0].Trim()
        $valor  = $partes[1].Trim()
        if ($nome -and $valor -and $valor -ne "COLE_AQUI_A_SERVICE_ROLE_KEY") {
            Set-Item -Path "Env:\$nome" -Value $valor
        }
    }
    Write-Host "  [ENV] .env.local carregado automaticamente." -ForegroundColor Green
}

if (-not $env:SUPABASE_SERVICE_ROLE_KEY) {
    Write-Host ""
    Write-Host "  [ENV] SUPABASE_SERVICE_ROLE_KEY nao encontrada." -ForegroundColor Yellow
    Write-Host "  Opcao 1 (permanente): edite CLIENTES\INGRID\.env.local" -ForegroundColor Cyan
    Write-Host "  Opcao 2 (temporaria): cole a chave agora" -ForegroundColor White
    Write-Host "  Supabase Dashboard -> Settings -> API -> service_role -> Reveal" -ForegroundColor DarkGray
    $chave = Read-Host "  Cole a service_role key"
    if (-not $chave) {
        Write-Host "  Chave nao fornecida. Encerrando." -ForegroundColor Red
        exit 1
    }
    $env:SUPABASE_SERVICE_ROLE_KEY = $chave
    $salvar = Read-Host "  Salvar no .env.local para proximas sessoes? (s/N)"
    if ($salvar -eq "s" -or $salvar -eq "S") {
        "SUPABASE_SERVICE_ROLE_KEY=$chave" | Out-File -FilePath $envLocalPath -Encoding UTF8
        Write-Host "  [ENV] Salvo em .env.local. Proxima sessao carrega automaticamente." -ForegroundColor Green
    }
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
Write-Host ""
Write-Host "  --- Conselho ---" -ForegroundColor Cyan
Write-Host "  [G] Ir ao Gemini       (gera contexto + clipboard + lista anexos)" -ForegroundColor Cyan
Write-Host "  [N] Ir ao NotebookLM   (prepara fontes + abre Explorer + browser)"  -ForegroundColor Cyan
Write-Host "  [E] Ir ao Embaixador   (copia mensagem inicial + abre Projects)"    -ForegroundColor Cyan
Write-Host "  [V] Verificar projeto  (P-041: 6 artefatos obrigatorios)"           -ForegroundColor Cyan
Write-Host "  [W] WIP Guard Soberano (ALL CHECKS PASSED antes do Veredito)"      -ForegroundColor Green
Write-Host ""
Write-Host "  --- Banco & Seed ---" -ForegroundColor DarkGray
Write-Host "  [1] Rodar seed (popular banco de questoes)" -ForegroundColor White
Write-Host "  [2] Rodar Gate Dia 5 (validar feed 70/30)"  -ForegroundColor White
Write-Host "  [M] Instrucoes para migracao SQL Dias 6-8"  -ForegroundColor Yellow
Write-Host ""
Write-Host "  --- Edge Functions ---" -ForegroundColor DarkGray
Write-Host "  [3] Deploy: gerar-questoes"                          -ForegroundColor White
Write-Host "  [4] Deploy: feed-diario"                             -ForegroundColor White
Write-Host "  [5] Deploy: tutor-socratico"                         -ForegroundColor White
Write-Host "  [9] Deploy: TODAS as 3 Edge Functions"               -ForegroundColor White
Write-Host ""
Write-Host "  --- Frontend ---" -ForegroundColor DarkGray
Write-Host "  [F] Configurar app.js (substituir placeholders)"     -ForegroundColor White
Write-Host "  [A] Configurar ANTHROPIC_API_KEY no Supabase Secrets" -ForegroundColor White
Write-Host ""
Write-Host "  [6] So configurar ambiente (sem acao)" -ForegroundColor White
Write-Host ""

if ($opcao -eq "") {
    $opcao = Read-Host "  Escolha"
} else {
    Write-Host "  Opcao automatica: $($opcao.ToUpper())" -ForegroundColor DarkGray
}

switch ($opcao.ToUpper()) {
    "G" {
        Write-Host ""
        Write-Host "  Preparando sessao com o Gemini (Estrategista)..." -ForegroundColor Cyan
        & ".\scripts\gemini_anchor_generator.ps1"
        Write-Host ""
        Write-Host "  Abrindo Gemini no browser..." -ForegroundColor Cyan
        Start-Process "https://gemini.google.com/app"
        Write-Host "  [OK] Contexto no clipboard (Ctrl+V) + browser aberto." -ForegroundColor Green
        Write-Host "  Anexe os arquivos listados acima antes de colar o contexto." -ForegroundColor Yellow
    }
    "N" {
        Write-Host ""
        Write-Host "  Preparando fontes para o NotebookLM (Auditor)..." -ForegroundColor Cyan
        & ".\scripts\preparar_notebooklm_projeto.ps1" -cliente INGRID
        Write-Host ""
        Write-Host "  Abrindo NotebookLM no browser..." -ForegroundColor Cyan
        Start-Process "https://notebooklm.google.com"
        Write-Host "  [OK] Explorer aberto com fontes. Arrastar tudo ao NotebookLM." -ForegroundColor Green
        Write-Host "  Depois colar o COMANDO CURTO do PASSO5_NOTEBOOKLM.md no chat." -ForegroundColor Yellow
    }
    "E" {
        Write-Host ""
        Write-Host "  Ativando o Embaixador (Claude Projects)..." -ForegroundColor Cyan
        & ".\scripts\ir_ao_embaixador.ps1" -cliente INGRID
        Write-Host "  [OK] Mensagem no clipboard. Usar PASSO7_EMBAIXADOR.md para escolher a secao." -ForegroundColor Green
    }
    "V" {
        Write-Host ""
        & ".\scripts\verificar_projeto.ps1" -cliente INGRID
    }
    "W" {
        Write-Host ""
        Write-Host "  Rodando WIP Guard Soberano..." -ForegroundColor Green
        & ".\scripts\wip_guard_soberano.ps1" -cliente INGRID
    }
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
        Write-Host "  Deployando tutor-socratico..." -ForegroundColor Cyan
        npx supabase functions deploy tutor-socratico --project-ref $PROJECT_REF
        Write-Host "  [OK] tutor-socratico deployado." -ForegroundColor Green
    }
    "9" {
        Write-Host ""
        foreach ($fn in @("gerar-questoes", "feed-diario", "tutor-socratico")) {
            Write-Host "  Deployando $fn..." -ForegroundColor Cyan
            npx supabase functions deploy $fn --project-ref $PROJECT_REF
        }
        Write-Host "  [OK] Todas as Edge Functions deployadas." -ForegroundColor Green
    }
    "6" {
        Write-Host ""
        Write-Host "  Ambiente configurado. Variaveis ativas nesta sessao do PowerShell." -ForegroundColor Green
    }
    "M" {
        Write-Host ""
        Write-Host "  MIGRACAO SQL - Dias 6-8" -ForegroundColor Yellow
        Write-Host "  ──────────────────────────────────────────────" -ForegroundColor DarkGray
        Write-Host "  1. Abra o Supabase SQL Editor:" -ForegroundColor White
        Write-Host "     https://supabase.com/dashboard/project/$PROJECT_REF/sql/new" -ForegroundColor Cyan
        Write-Host "  2. Cole o conteudo do arquivo:" -ForegroundColor White
        Write-Host "     CLIENTES\INGRID\supabase\migrations\20260518_dia678_tables.sql" -ForegroundColor Cyan
        Write-Host "  3. Clique em Run" -ForegroundColor White
        Write-Host "  4. Confirme: 3 tabelas novas + 5 colunas em progresso_usuario" -ForegroundColor White
        Write-Host ""
        $abrir = Read-Host "  Abrir o arquivo de migracao agora? (s/n)"
        if ($abrir -eq "s") {
            Invoke-Item "CLIENTES\INGRID\supabase\migrations\20260518_dia678_tables.sql"
        }
    }
    "F" {
        Write-Host ""
        Write-Host "  CONFIGURAR FRONTEND - substituir placeholders em app.js" -ForegroundColor Cyan
        Write-Host "  (Supabase Dashboard -> Settings -> API)" -ForegroundColor DarkGray
        Write-Host ""
        $anonKey  = Read-Host "  ANON KEY (anon/public)"
        $userId   = Read-Host "  USER_ID da Ingrid (UUID)"
        $adminTok = Read-Host "  Token admin (Enter = pular)"

        if (-not $anonKey -or -not $userId) {
            Write-Host "  Campos obrigatorios nao preenchidos. Cancelado." -ForegroundColor Red
        } else {
            $appPath = "CLIENTES\INGRID\frontend\app.js"
            $appJs   = Get-Content $appPath -Raw -Encoding UTF8
            $appJs   = $appJs -replace "__SUPABASE_URL__",      $SUPABASE_URL
            $appJs   = $appJs -replace "__SUPABASE_ANON_KEY__", $anonKey
            $appJs   = $appJs -replace "__USER_ID_INGRID__",    $userId
            if ($adminTok) {
                $appJs = $appJs -replace "__ADMIN_TOKEN__", $adminTok
            }
            Set-Content $appPath $appJs -Encoding UTF8
            Write-Host "  [OK] app.js configurado com credenciais reais." -ForegroundColor Green
            Write-Host "  ATENCAO: nao commitar app.js com credenciais." -ForegroundColor Yellow
        }
    }
    "A" {
        Write-Host ""
        Write-Host "  ANTHROPIC_API_KEY - Supabase Secrets" -ForegroundColor Cyan
        $apiKey = Read-Host "  Cole a Anthropic API Key (sk-ant-...)"
        if ($apiKey) {
            npx supabase secrets set ANTHROPIC_API_KEY=$apiKey --project-ref $PROJECT_REF
            Write-Host "  [OK] Secret ANTHROPIC_API_KEY configurada." -ForegroundColor Green
        } else {
            Write-Host "  Chave nao fornecida. Cancelado." -ForegroundColor Yellow
        }
    }
    default {
        Write-Host "  Opcao invalida." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "  Loop atual   : Loop 3 - Build Dias 6-8 CONCLUIDO"   -ForegroundColor DarkGray
Write-Host "  Gate proximo : Dia 8 - Ingrid responde 10 questoes"  -ForegroundColor DarkGray
Write-Host "  Deadline     : 2026-05-30"                           -ForegroundColor DarkGray
Write-Host ""
