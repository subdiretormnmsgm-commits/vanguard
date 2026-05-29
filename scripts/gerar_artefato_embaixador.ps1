#Requires -Version 5.1
# gerar_artefato_embaixador.ps1 -- Pentalateral IAH
# Chama Claude Haiku com PAINEL + MEMORIA_EMBAIXADOR + INSTRUCAO_SISTEMA
# e gera ARTEFATO_EMBAIXADOR_[CLIENTE]_[DATA].md automaticamente.
# Chamado pelo session_close.ps1 -- zero acao manual do Diretor.
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
$painelDir     = "$raiz\PROTOCOLOS_ENCERRAMENTO"

$painelFile = Get-ChildItem "$painelDir\PAINEL_ATIVIDADES_${cliUpper}_*.md" -ErrorAction SilentlyContinue |
              Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $painelFile) {
    Write-Host "  [EMBAIXADOR] $cliUpper -- PAINEL nao encontrado. Gere o PAINEL antes." -ForegroundColor Yellow
    exit 1
}

# --------------------------------------------------------------------------
# 3. LER CONTEUDOS
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

$painel = Get-Content $painelFile.FullName -Raw -Encoding UTF8

# --------------------------------------------------------------------------
# 4. MONTAR PROMPT (lista de strings -- sem here-string para evitar PS5.1 bugs)
# --------------------------------------------------------------------------
$sep = "---"
$linhasPrompt = [System.Collections.Generic.List[string]]::new()
$linhasPrompt.Add("## MEMORIA ACUMULADA DO EMBAIXADOR -- $cliUpper")
$linhasPrompt.Add("")
$linhasPrompt.Add($memoria)
$linhasPrompt.Add("")
$linhasPrompt.Add($sep)
$linhasPrompt.Add("")
$linhasPrompt.Add("## PAINEL DE ATIVIDADES -- FECHAMENTO $data")
$linhasPrompt.Add("")
$linhasPrompt.Add($painel)
$linhasPrompt.Add("")
$linhasPrompt.Add($sep)
$linhasPrompt.Add("")
$linhasPrompt.Add("## SUA TAREFA -- ARTEFATO DE FECHAMENTO")
$linhasPrompt.Add("")
$linhasPrompt.Add("Com base no PAINEL e na sua MEMORIA acumulada, gere o artefato com EXATAMENTE estes 7 blocos:")
$linhasPrompt.Add("")
$linhasPrompt.Add("**1. SEMAFORO**")
$linhasPrompt.Add("Status do projeto: VERDE / AMARELO / VERMELHO. Justificativa objetiva em 1 linha.")
$linhasPrompt.Add("")
$linhasPrompt.Add("**2. ATIVIDADES EM DEFICIT**")
$linhasPrompt.Add("O que o comportamento real do cliente confirma ou contradiz sobre os itens em atraso.")
$linhasPrompt.Add("")
$linhasPrompt.Add("**3. ALERTA GARGALO**")
$linhasPrompt.Add("Gates vencidos com perspectiva comportamental -- o que o cliente sinaliza que o Musculo nao viu.")
$linhasPrompt.Add("")
$linhasPrompt.Add("**4. DIAGNOSTICO DO DIA**")
$linhasPrompt.Add("Saude do projeto em 2-3 linhas. Tendencia positiva ou negativa?")
$linhasPrompt.Add("")
$linhasPrompt.Add("**5. PREVISAO DOS PROXIMOS DIAS**")
$linhasPrompt.Add("Data a data com checklist de acoes concretas do Diretor. Sem generalidades.")
$linhasPrompt.Add("")
$linhasPrompt.Add("**6. ANALISE GERENCIAL**")
$linhasPrompt.Add("O que o Musculo nao ve. Perspectiva do cliente, do mercado, da Vanguard como empresa.")
$linhasPrompt.Add("")
$linhasPrompt.Add("**7. PARA DELIBERACAO DO DIRETOR**")
$linhasPrompt.Add("Opcoes para o Diretor deliberar. Nunca lista de comandos. O Embaixador apresenta -- o Diretor decide.")
$linhasPrompt.Add("")
$linhasPrompt.Add($sep)
$linhasPrompt.Add("")
$linhasPrompt.Add("Tom: direto, sem bajulacao. Nao repita o PAINEL -- acrescente perspectiva que so voce tem.")
$linhasPrompt.Add("Maximo 800 palavras no total.")

$userMsg = $linhasPrompt -join "`n"

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

$bodyJson = $bodyObj | ConvertTo-Json -Depth 6 -Compress
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
    $errMsg = $_.Exception.Message
    Write-Host "  [EMBAIXADOR] $cliUpper -- Erro na API Anthropic: $errMsg" -ForegroundColor Red
    exit 1
}

# --------------------------------------------------------------------------
# 6. SALVAR ARTEFATO
# --------------------------------------------------------------------------
$outputDir = "$raiz\RELATORIOS_EMBAIXADOR"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

$outputFile = "$outputDir\ARTEFATO_EMBAIXADOR_${cliUpper}_$data.md"

$linhasArtefato = [System.Collections.Generic.List[string]]::new()
$linhasArtefato.Add("# ARTEFATO EMBAIXADOR -- $cliUpper -- $data")
$linhasArtefato.Add("### Pentalateral IAH - Haiku 4.5 - $hora")
$linhasArtefato.Add("")
$linhasArtefato.Add($sep)
$linhasArtefato.Add("")
$linhasArtefato.Add($texto)
$linhasArtefato.Add("")
$linhasArtefato.Add($sep)
$linhasArtefato.Add("")
$linhasArtefato.Add("*Fonte: $(Split-Path $painelFile -Leaf) + MEMORIA_EMBAIXADOR.md*")

($linhasArtefato -join "`n") | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "  [EMBAIXADOR] $cliUpper OK -- RELATORIOS_EMBAIXADOR\ARTEFATO_EMBAIXADOR_${cliUpper}_$data.md" -ForegroundColor Green

return $outputFile
