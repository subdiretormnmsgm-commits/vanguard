#Requires -Version 5.1
# gerar_artefato_operacional.ps1 -- Pentalateral IAH
# Chama Claude Haiku com PAINEL_GERAL + CONTEXTO_SESSAO_DIRETOR + INSTRUCAO_SISTEMA_EMBAIXADOR_OPERACIONAL
# Gera ARTEFATO_EMBAIXADOR_OPERACIONAL_[DATA].md -- ABERTURA DE SESSAO pre-gerada.
# Chamado pelo session_close.ps1 -- gate: ANTHROPIC_API_KEY disponivel (D2 ENV_VARS).
# P-102: coexiste com gerar_artefato_embaixador.ps1 -- nao o substitui.
#
# Uso direto: .\scripts\gerar_artefato_operacional.ps1

$raiz = Split-Path -Parent $PSScriptRoot
$data = Get-Date -Format "yyyy-MM-dd"
$hora = Get-Date -Format "HH:mm"

$apiKey = $env:ANTHROPIC_API_KEY
if (-not $apiKey) {
    Write-Host "  [OPER] ANTHROPIC_API_KEY ausente -- artefato operacional ignorado (gate D2 ENV_VARS)" -ForegroundColor DarkGray
    exit 0
}

$instrucaoPath  = "$raiz\PENTALATERAL_UNIVERSAL\OPERACAO\INSTRUCAO_SISTEMA_EMBAIXADOR_OPERACIONAL.md"
$templatePath   = "$raiz\PENTALATERAL_UNIVERSAL\TEMPLATES\scripts\gerar_artefato_operacional_prompt.txt"
$protDir        = "$raiz\PROTOCOLOS_ENCERRAMENTO"

$contextoFile = Get-ChildItem "$protDir\CONTEXTO_SESSAO_DIRETOR_*.md" -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending | Select-Object -First 1
$painelFile   = Get-ChildItem "$protDir\PAINEL_ATIVIDADES_*.md" -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $contextoFile) {
    Write-Host "  [OPER] CONTEXTO_SESSAO_DIRETOR nao encontrado -- artefato ignorado" -ForegroundColor Yellow
    exit 0
}
if (-not $painelFile) {
    Write-Host "  [OPER] PAINEL_ATIVIDADES nao encontrado -- artefato ignorado" -ForegroundColor Yellow
    exit 0
}
if (-not (Test-Path $templatePath)) {
    Write-Host "  [OPER] Template nao encontrado: $templatePath" -ForegroundColor Red
    exit 1
}

$instrucao = if (Test-Path $instrucaoPath) {
    Get-Content $instrucaoPath -Raw -Encoding UTF8
} else {
    "Voce e o Embaixador Operacional da Vanguard Tech. Guarda contexto de sessao e detecta padroes cronicos."
}

$contexto = Get-Content $contextoFile.FullName -Raw -Encoding UTF8
$painel   = Get-Content $painelFile.FullName   -Raw -Encoding UTF8
$template = Get-Content $templatePath -Raw -Encoding UTF8

$userMsg = $template
$userMsg = $userMsg -replace '\{DATA\}',            $data
$userMsg = $userMsg -replace '\{CONTEXTO_SESSAO\}', $contexto
$userMsg = $userMsg -replace '\{PAINEL\}',           $painel

$bodyObj = [ordered]@{
    model      = "claude-haiku-4-5-20251001"
    max_tokens = 1200
    system     = $instrucao
    messages   = @(@{ role = "user"; content = $userMsg })
}

$bodyJson  = $bodyObj | ConvertTo-Json -Depth 6 -Compress
$bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($bodyJson)

$headers = @{
    "x-api-key"         = $apiKey
    "anthropic-version" = "2023-06-01"
    "Content-Type"      = "application/json"
}

try {
    $resp  = Invoke-RestMethod -Uri "https://api.anthropic.com/v1/messages" `
                               -Method POST -Headers $headers -Body $bodyBytes -ErrorAction Stop
    $texto = $resp.content[0].text
} catch {
    Write-Host "  [OPER] Erro na API Haiku: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

$outputDir  = "$raiz\RELATORIOS_EMBAIXADOR"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

$outputFile = "$outputDir\ARTEFATO_EMBAIXADOR_OPERACIONAL_$data.md"

$linhas = [System.Collections.Generic.List[string]]::new()
$linhas.Add("# ABERTURA DE SESSAO PRE-GERADA -- $data")
$linhas.Add("### Embaixador Operacional -- Haiku 4.5 -- $hora")
$linhas.Add("")
$linhas.Add("---")
$linhas.Add("")
$linhas.Add($texto)
$linhas.Add("")
$linhas.Add("---")
$linhas.Add("")
$linhas.Add("*Fonte: $(Split-Path $contextoFile -Leaf) + $(Split-Path $painelFile -Leaf)*")

($linhas -join "`n") | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "  [OPER] Artefato Operacional OK -- RELATORIOS_EMBAIXADOR\ARTEFATO_EMBAIXADOR_OPERACIONAL_$data.md" -ForegroundColor Green

return $outputFile
