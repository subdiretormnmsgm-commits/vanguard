#Requires -Version 5.1
# gate_coerencia.ps1 — E-1 V28: Gate de Coerencia Semantica via Claude API (Haiku)
# Verifica se o output de um socio esta completo e correto para o proximo passo.
# Uso:
#   .\scripts\gate_coerencia.ps1 -documento "caminho\DIRETRIZ.txt" -proximo_passo "NotebookLM gerar Skill"
#   .\scripts\gate_coerencia.ps1 -documento "caminho\SKILL.md" -proximo_passo "Musculo executar deliberacao P-037"
# Retorna: exit 0 (APROVADO) | exit 1 (REJEITADO) | exit 2 (erro de API)

param(
    [Parameter(Mandatory=$true)]
    [string]$documento,

    [Parameter(Mandatory=$true)]
    [string]$proximo_passo,

    [switch]$silencioso
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot

if (-not $silencioso) {
    Write-Host ""
    Write-Host "================================================"
    Write-Host "  gate_coerencia -- E-1 V28"
    Write-Host "================================================"
}

# --- Verificar arquivo ---
if (-not (Test-Path $documento)) {
    Write-Host "[GATE_COERENCIA] ERRO: arquivo nao encontrado: $documento" -ForegroundColor Red
    exit 2
}

$conteudo = Get-Content $documento -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
if ([string]::IsNullOrWhiteSpace($conteudo)) {
    Write-Host "[GATE_COERENCIA] ERRO: arquivo vazio." -ForegroundColor Red
    exit 2
}

# Limitar a 6000 chars para controlar custo Haiku
if ($conteudo.Length -gt 6000) {
    $conteudo = $conteudo.Substring(0, 6000) + "`n[...truncado para gate...]"
}

# --- Verificar API Key ---
$apiKey = $env:ANTHROPIC_API_KEY
if ([string]::IsNullOrWhiteSpace($apiKey)) {
    # Tentar ler do arquivo de credenciais (gitignored)
    $credFile = Join-Path $BASE "N8N Easypanel.txt"
    if (Test-Path $credFile) {
        $credContent = Get-Content $credFile -Raw
        if ($credContent -match "ANTHROPIC_API_KEY[=:\s]+([^\r\n]+)") {
            $apiKey = $matches[1].Trim()
        }
    }
}

if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host "[GATE_COERENCIA] ERRO: ANTHROPIC_API_KEY nao encontrada." -ForegroundColor Red
    Write-Host "  Defina via: `$env:ANTHROPIC_API_KEY = 'sk-ant-...'" -ForegroundColor Yellow
    exit 2
}

# --- Montar prompt para Haiku ---
$nomeArquivo = [System.IO.Path]::GetFileName($documento)

$prompt = @"
Voce e um gate de qualidade do Pentalateral IAH. Analise o documento abaixo e responda se ele esta COMPLETO e CORRETO para o proximo passo indicado.

PROXIMO PASSO: $proximo_passo
DOCUMENTO: $nomeArquivo

CONTEUDO:
$conteudo

---

Responda APENAS no formato JSON abaixo, sem texto adicional:
{
  "resultado": "APROVADO" ou "REJEITADO",
  "motivo": "uma frase explicando o motivo",
  "lacunas": ["lista de lacunas se REJEITADO, vazia se APROVADO"]
}

Criterios de APROVADO:
- O documento contem informacao suficiente para o proximo passo executar sem pedir mais contexto
- Nao ha placeholders [A PREENCHER], [INSERIR], [XXX] sem preencher
- O conteudo e coerente com o que o proximo passo precisa receber

Criterios de REJEITADO:
- Informacao critica ausente para o proximo passo
- Placeholders nao preenchidos
- Conteudo incoerente ou incompleto para a funcao declarada
"@

# --- Chamar Claude API Haiku ---
$body = @{
    model = "claude-haiku-4-5-20251001"
    max_tokens = 300
    messages = @(
        @{
            role = "user"
            content = $prompt
        }
    )
} | ConvertTo-Json -Depth 5

try {
    $response = Invoke-RestMethod `
        -Uri "https://api.anthropic.com/v1/messages" `
        -Method POST `
        -Headers @{
            "x-api-key"         = $apiKey
            "anthropic-version" = "2023-06-01"
            "content-type"      = "application/json"
        } `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
        -ErrorAction Stop

    $textoResposta = $response.content[0].text.Trim()

    # Extrair JSON da resposta
    if ($textoResposta -match '\{[\s\S]+\}') {
        $jsonStr = $matches[0]
        $resultado = $jsonStr | ConvertFrom-Json
    } else {
        Write-Host "[GATE_COERENCIA] ERRO: resposta da API nao e JSON valido." -ForegroundColor Red
        Write-Host $textoResposta
        exit 2
    }

} catch {
    Write-Host "[GATE_COERENCIA] ERRO na chamada API: $_" -ForegroundColor Red
    exit 2
}

# --- Exibir resultado ---
if (-not $silencioso) {
    Write-Host ""
    Write-Host "Documento    : $nomeArquivo"
    Write-Host "Proximo passo: $proximo_passo"
    Write-Host ""
}

if ($resultado.resultado -eq "APROVADO") {
    if (-not $silencioso) {
        Write-Host "RESULTADO: APROVADO" -ForegroundColor Green
        Write-Host "  $($resultado.motivo)"
    }
    exit 0
} else {
    Write-Host "RESULTADO: REJEITADO" -ForegroundColor Red
    Write-Host "  $($resultado.motivo)"
    if ($resultado.lacunas -and $resultado.lacunas.Count -gt 0) {
        Write-Host ""
        Write-Host "LACUNAS DETECTADAS:" -ForegroundColor Yellow
        $resultado.lacunas | ForEach-Object { Write-Host "  [X] $_" -ForegroundColor Yellow }
    }
    Write-Host ""
    Write-Host "ACAO: corrigir o documento antes de prosseguir para: $proximo_passo" -ForegroundColor Yellow
    exit 1
}
