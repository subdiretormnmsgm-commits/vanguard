#Requires -Version 5.1
# n8n_antigravity_repair.ps1 -- Diagnosticar falha n8n via Antigravity
# Chamado quando W-10 detecta falha e envia alerta no Telegram
# Gera prompt para @n8n-validation-expert ou @systematic-debugging e copia para clipboard
#
# Uso:
#   .\scripts\n8n_antigravity_repair.ps1                       -- detecta automaticamente falhas
#   .\scripts\n8n_antigravity_repair.ps1 -workflow "W-3 GitHub Push" -- workflow especifico
#   .\scripts\n8n_antigravity_repair.ps1 -executionId "abc123"  -- execucao especifica
#   .\scripts\n8n_antigravity_repair.ps1 -ListarFalhas          -- lista falhas das ultimas 24h

param(
    [string]$workflow    = "",
    [string]$executionId = "",
    [switch]$ListarFalhas,
    [switch]$Clipboard
)

$raiz    = Split-Path -Parent $PSScriptRoot
$baseUrl = "https://vanguard-vanguard-n8n.0ul9nk.easypanel.host"

# Ler API key das variaveis de ambiente ou arquivo de chaves
$apiKey = $env:N8N_API_KEY
if (-not $apiKey) {
    $chavesFile = Join-Path $raiz "N8N Easypanel.txt"
    if (Test-Path $chavesFile) {
        $linhas = Get-Content $chavesFile -Encoding UTF8
        foreach ($l in $linhas) {
            if ($l -match 'N8N_API_KEY[=:]?\s*(.+)') {
                $apiKey = $Matches[1].Trim()
                break
            }
        }
    }
}

if (-not $apiKey) {
    Write-Host ""
    Write-Host "[ERRO] N8N_API_KEY nao encontrada." -ForegroundColor Red
    Write-Host "       Configure em EasyPanel: variaveis de ambiente -> N8N_API_KEY" -ForegroundColor Yellow
    Write-Host "       Ou adicione ao arquivo 'N8N Easypanel.txt': N8N_API_KEY=sua_chave" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Como criar a API Key no n8n:" -ForegroundColor Cyan
    Write-Host "  1. Abrir $baseUrl" -ForegroundColor White
    Write-Host "  2. Settings -> API -> Create API Key" -ForegroundColor White
    Write-Host "  3. Copiar e adicionar nas variaveis de ambiente do EasyPanel" -ForegroundColor White
    exit 1
}

$headers = @{ "X-N8N-API-KEY" = $apiKey }

function Invoke-N8NApi {
    param([string]$endpoint)
    try {
        $resp = Invoke-RestMethod -Method GET -Uri "$baseUrl/api/v1/$endpoint" -Headers $headers -TimeoutSec 15 -ErrorAction Stop
        return $resp
    } catch {
        Write-Host "[ERRO] n8n API: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

$dataHoje = Get-Date -Format "yyyy-MM-dd HH:mm"
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  W-10 n8n REPAIR -- Antigravity Debug Tool" -ForegroundColor Cyan
Write-Host "  $dataHoje" -ForegroundColor DarkGray
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Modo: listar falhas das ultimas 24h
$modeLista = $ListarFalhas -or (-not $workflow -and -not $executionId)

if ($modeLista -or $ListarFalhas) {
    Write-Host "Buscando execucoes com erro (ultimas 24h)..." -ForegroundColor DarkGray

    $execsResp = Invoke-N8NApi "executions?status=error&limit=50&includeData=false"
    if (-not $execsResp) { Write-Host "Falha ao conectar ao n8n."; exit 1 }

    $agora  = Get-Date
    $ontem  = $agora.AddHours(-24)
    $erros  = @($execsResp.data) | Where-Object {
        $dt = [datetime]::Parse($_.startedAt)
        $dt -ge $ontem
    }

    if ($erros.Count -eq 0) {
        Write-Host "[OK] Nenhuma execucao com erro nas ultimas 24h." -ForegroundColor Green
        Write-Host "     Se W-10 reportou falha, verifique workflows INATIVOS manualmente." -ForegroundColor DarkGray
        Write-Host ""
        exit 0
    }

    Write-Host "Encontradas $($erros.Count) execucao(oes) com erro:" -ForegroundColor Red
    Write-Host ""

    # Buscar nomes dos workflows
    $wfResp = Invoke-N8NApi "workflows?limit=250"
    $wfMap  = @{}
    if ($wfResp) {
        foreach ($w in $wfResp.data) { $wfMap[$w.id] = $w.name }
    }

    $errosPorWf = @{}
    foreach ($e in $erros) {
        $nome = if ($wfMap[$e.workflowId]) { $wfMap[$e.workflowId] } else { "ID:$($e.workflowId)" }
        if (-not $errosPorWf[$nome]) { $errosPorWf[$nome] = @() }
        $errosPorWf[$nome] += $e
    }

    foreach ($kv in $errosPorWf.GetEnumerator()) {
        Write-Host "  WORKFLOW: $($kv.Key)" -ForegroundColor Red
        Write-Host "  Falhas  : $($kv.Value.Count)" -ForegroundColor White
        $ultimo = $kv.Value[0]
        Write-Host "  Ultimo  : $($ultimo.startedAt) | ID: $($ultimo.id)" -ForegroundColor DarkGray
        Write-Host ""
    }

    # Se apenas listando, parar aqui
    if ($ListarFalhas -and -not $workflow -and -not $executionId) {
        Write-Host "Para diagnosticar um workflow especifico:" -ForegroundColor Yellow
        Write-Host "  .\scripts\n8n_antigravity_repair.ps1 -workflow 'Nome do Workflow'" -ForegroundColor White
        Write-Host ""
        exit 0
    }
}

# --- Modo diagnotico especifico ---

# Buscar detalhes da execucao com erro mais recente do workflow
$contextoErro   = @()
$workflowNome   = $workflow
$execucaoDetalhes = $null

if ($executionId) {
    Write-Host "Buscando execucao ID: $executionId ..." -ForegroundColor DarkGray
    $execucaoDetalhes = Invoke-N8NApi "executions/$executionId"
    if ($execucaoDetalhes) {
        $wn = $wfMap[$execucaoDetalhes.workflowId]
        $workflowNome = if ($wn) { $wn } else { "ID:$($execucaoDetalhes.workflowId)" }
    }
} elseif ($workflow) {
    Write-Host "Buscando ultima execucao com erro de: $workflow ..." -ForegroundColor DarkGray

    $wfResp = Invoke-N8NApi "workflows?limit=250"
    $wfId   = $null
    if ($wfResp) {
        $found = @($wfResp.data) | Where-Object { $_.name -like "*$workflow*" } | Select-Object -First 1
        if ($found) {
            $wfId         = $found.id
            $workflowNome = $found.name
            Write-Host "  Workflow encontrado: $workflowNome (ID: $wfId)" -ForegroundColor White
        } else {
            Write-Host "[AVISO] Workflow '$workflow' nao encontrado. Usando busca por erro recente." -ForegroundColor Yellow
        }
    }

    $endpointExecs = if ($wfId) { "executions?workflowId=$wfId&status=error&limit=5" } else { "executions?status=error&limit=5" }
    $execsResp     = Invoke-N8NApi $endpointExecs
    if ($execsResp -and $execsResp.data.Count -gt 0) {
        $execId           = $execsResp.data[0].id
        $execucaoDetalhes = Invoke-N8NApi "executions/$execId"
    }
}

# Extrair mensagem de erro e no que falhou
$mensagemErro  = "sem detalhes"
$nodoQuefalhou = "desconhecido"

if ($execucaoDetalhes) {
    try {
        $resultData    = $null
        if ($execucaoDetalhes.data) { $resultData = $execucaoDetalhes.data.resultData }
        $nodoQuefalhou = if ($resultData -and $resultData.lastNodeExecuted) { $resultData.lastNodeExecuted } else { "desconhecido" }
        $errorMsg      = ""
        if ($resultData -and $resultData.error -and $resultData.error.message) { $errorMsg = $resultData.error.message }
        $nodeErrorMsg  = ""
        if ($resultData -and $resultData.runData) {
            foreach ($nodo in $resultData.runData.PSObject.Properties) {
                $runs = $nodo.Value
                foreach ($run in $runs) {
                    if ($run.error) {
                        $em = if ($run.error.message) { $run.error.message } else { "" }
                        $nodeErrorMsg  = $em
                        $nodoQuefalhou = $nodo.Name
                    }
                }
            }
        }
        $mensagemErro = if ($nodeErrorMsg) { $nodeErrorMsg } elseif ($errorMsg) { $errorMsg } else { "erro sem mensagem" }
    } catch {
        $mensagemErro = "nao foi possivel extrair o erro: $_"
    }
}

# Determinar skill ideal
$skillIdeal  = "n8n-validation-expert"
$skillFallbk = "systematic-debugging"
if ($mensagemErro -match "401|403|Unauthorized|Forbidden") {
    $skillIdeal = "n8n-node-configuration"
} elseif ($mensagemErro -match "timeout|ETIMEDOUT|ECONNREFUSED") {
    $skillIdeal = "n8n-workflow-patterns"
} elseif ($mensagemErro -match "expression|Cannot|undefined|null") {
    $skillIdeal = "n8n-expression-syntax"
}

# Gerar prompt para Antigravity
$contextoLinhas = @(
    "@$skillIdeal Diagnosticar falha no workflow n8n: $workflowNome",
    "",
    "CONTEXTO DA FALHA:",
    "  Workflow    : $workflowNome",
    "  No que falhou: $nodoQuefalhou",
    "  Mensagem de erro: $mensagemErro",
    "  Data da falha: $dataHoje",
    "  Detectado por: W-10 Health Check automatico",
    "",
    "ARQUIVOS DE REFERENCIA (ler no workspace):",
    "  PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PENDING_REVIEW.md",
    "  scripts/w10_n8n_healthcheck.json",
    "",
    "PASSOS SUGERIDOS:",
    "  1. @$skillIdeal -- diagnosticar o no '$nodoQuefalhou'",
    "  2. Verificar credenciais e ENV VARs no EasyPanel",
    "  3. @$skillFallbk -- se a causa raiz nao for clara",
    "  4. Propor correcao no workflow",
    "  5. Testar antes de reativar (P-110 fallback obrigatorio)"
)
$prompt = $contextoLinhas -join "`n"

# Output
Write-Host "DIAGNOSTICO GERADO:" -ForegroundColor Yellow
Write-Host "  Workflow  : $workflowNome" -ForegroundColor White
Write-Host "  No falhou : $nodoQuefalhou" -ForegroundColor Red
Write-Host "  Erro      : $($mensagemErro.Substring(0, [Math]::Min(120, $mensagemErro.Length)))" -ForegroundColor Red
Write-Host "  Skill     : @$skillIdeal" -ForegroundColor Cyan
Write-Host ""
Write-Host "PROMPT PARA ANTIGRAVITY (VS Code Gemini chat):" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host $prompt -ForegroundColor White
Write-Host "----------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

# Salvar prompt
$promptFile = Join-Path $raiz "scripts\.antigravity_prompt.txt"
[System.IO.File]::WriteAllText($promptFile, $prompt, [System.Text.Encoding]::UTF8)
Write-Host "Prompt salvo em: scripts/.antigravity_prompt.txt" -ForegroundColor DarkGray

# Clipboard automatico
try {
    Set-Clipboard -Value $prompt
    Write-Host "[CLIPBOARD] Copiado -- cole no VS Code com Ctrl+V" -ForegroundColor Green
} catch {
    Write-Host "[CLIPBOARD] Falhou -- copiar do texto acima" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "PROXIMOS PASSOS:" -ForegroundColor Cyan
Write-Host "  1. Abrir VS Code com o workspace Vanguard" -ForegroundColor White
Write-Host "  2. Ir ao Gemini chat" -ForegroundColor White
Write-Host "  3. Colar o prompt (Ctrl+V)" -ForegroundColor White
Write-Host "  4. Seguir diagnostico do @$skillIdeal" -ForegroundColor White
Write-Host "  5. Apos correcao: testar workflow no EasyPanel n8n" -ForegroundColor White
Write-Host ""
