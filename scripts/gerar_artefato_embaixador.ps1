#Requires -Version 5.1
# gerar_artefato_embaixador.ps1 -- Pentalateral IAH
# Chama Claude Haiku com PAINEL + MEMORIA_EMBAIXADOR + INSTRUCAO_SISTEMA
# e gera ARTEFATO_EMBAIXADOR_[CLIENTE]_[DATA].md automaticamente.
# Chamado pelo session_close.ps1 -- zero acao manual do Diretor.
# P-088: codigo-fonte ASCII-only -- conteudo rico fica no template .txt
#
# Uso direto: .\scripts\gerar_artefato_embaixador.ps1 -Cliente INGRID

param(
    [Parameter(Mandatory=$true)]
    [string]$Cliente
)

$raiz     = Split-Path -Parent $PSScriptRoot
$data     = Get-Date -Format "yyyy-MM-dd"
$hora     = Get-Date -Format "HH:mm"
$cliUpper = $Cliente.ToUpper()

# --------------------------------------------------------------------------
# 1. API KEY
# --------------------------------------------------------------------------
$apiKey = $env:ANTHROPIC_API_KEY
if (-not $apiKey) {
    Write-Host "  [EMBAIXADOR] ERRO: ANTHROPIC_API_KEY ausente no ambiente Windows." -ForegroundColor Red
    exit 1
}

# --------------------------------------------------------------------------
# 2. LOCALIZAR ARQUIVOS
# --------------------------------------------------------------------------
$cliDir        = "$raiz\CLIENTES\$cliUpper"
$instrucaoPath = "$cliDir\CLAUDE_PROJECT\00_INSTRUCAO_SISTEMA.md"
$memoriaPath   = "$cliDir\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
$templatePath  = "$raiz\PENTALATERAL_UNIVERSAL\TEMPLATES\scripts\gerar_artefato_embaixador_prompt.txt"
$painelDir     = "$raiz\PROTOCOLOS_ENCERRAMENTO"

$painelFile = Get-ChildItem "$painelDir\PAINEL_ATIVIDADES_${cliUpper}_*.md" -ErrorAction SilentlyContinue |
              Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $painelFile) {
    Write-Host "  [EMBAIXADOR] $cliUpper -- PAINEL nao encontrado. Gere o PAINEL antes." -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $templatePath)) {
    Write-Host "  [EMBAIXADOR] Template nao encontrado: $templatePath" -ForegroundColor Red
    exit 1
}

# --------------------------------------------------------------------------
# 3. LER CONTEUDOS (UTF8 -- o codigo nao vê os acentos, só lê bytes)
# --------------------------------------------------------------------------
$instrucao = if (Test-Path $instrucaoPath) {
    Get-Content $instrucaoPath -Raw -Encoding UTF8
} else {
    "Voce e o Embaixador da Vanguard Tech. Conselheiro de relacionamento e inteligencia de cliente."
}

$memoria = if (Test-Path $memoriaPath) {
    Get-Content $memoriaPath -Raw -Encoding UTF8
} else {
    "Sem memoria anterior registrada para este cliente."
}

$painel   = Get-Content $painelFile.FullName -Raw -Encoding UTF8
$template = Get-Content $templatePath -Raw -Encoding UTF8

# --------------------------------------------------------------------------
# 4. SUBSTITUIR PLACEHOLDERS -- P-088: codigo ASCII, conteudo rico no .txt
# --------------------------------------------------------------------------
$userMsg = $template
$userMsg = $userMsg -replace '\{CLIENTE\}', $cliUpper
$userMsg = $userMsg -replace '\{DATA\}',    $data
$userMsg = $userMsg -replace '\{MEMORIA\}', $memoria
$userMsg = $userMsg -replace '\{PAINEL\}',  $painel

# --------------------------------------------------------------------------
# 5. CHAMAR API ANTHROPIC -- Haiku 4.5
# --------------------------------------------------------------------------
$bodyObj = [ordered]@{
    model      = "claude-haiku-4-5-20251001"
    max_tokens = 1800
    system     = $instrucao
    messages   = @(
        @{ role = "user"; content = $userMsg }
    )
}

$bodyJson  = $bodyObj | ConvertTo-Json -Depth 6 -Compress
$bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($bodyJson)

$headers = @{
    "x-api-key"         = $apiKey
    "anthropic-version" = "2023-06-01"
    "Content-Type"      = "application/json"
}

try {
    $resp = Invoke-RestMethod `
        -Uri     "https://api.anthropic.com/v1/messages" `
        -Method  POST `
        -Headers $headers `
        -Body    $bodyBytes `
        -ErrorAction Stop
    $texto = $resp.content[0].text
} catch {
    Write-Host "  [EMBAIXADOR] $cliUpper -- Erro na API: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# --------------------------------------------------------------------------
# 6. SALVAR ARTEFATO
# --------------------------------------------------------------------------
$outputDir = "$raiz\RELATORIOS_EMBAIXADOR"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

$outputFile = "$outputDir\ARTEFATO_EMBAIXADOR_${cliUpper}_$data.md"

$sep = "---"
$linhas = [System.Collections.Generic.List[string]]::new()
$linhas.Add("# ARTEFATO EMBAIXADOR -- $cliUpper -- $data")
$linhas.Add("### Pentalateral IAH -- Haiku 4.5 -- $hora")
$linhas.Add("")
$linhas.Add($sep)
$linhas.Add("")
$linhas.Add($texto)
$linhas.Add("")
$linhas.Add($sep)
$linhas.Add("")
$linhas.Add("*Fonte: $(Split-Path $painelFile -Leaf) + MEMORIA_EMBAIXADOR.md*")

($linhas -join "`n") | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "  [EMBAIXADOR] $cliUpper OK -- RELATORIOS_EMBAIXADOR\ARTEFATO_EMBAIXADOR_${cliUpper}_$data.md" -ForegroundColor Green

return $outputFile
