# perguntas_abertas_gate.ps1
# Varre documentos do ciclo de um nicho, detecta perguntas abertas
# e classifica como BLOQUEIA_BUILD / BLOQUEIA_CAPTACAO / INFORMATIVO.
# Impede que o ciclo avance com perguntas bloqueantes sem resposta.
#
# Uso: .\scripts\perguntas_abertas_gate.ps1 -nicho Medicina
# Uso: .\scripts\perguntas_abertas_gate.ps1 -nicho Contabilidade -pasta "PENTALATERAL_UNIVERSAL\PERFIS_NICHO"

param(
    [Parameter(Mandatory=$true)]
    [string]$nicho,

    [Parameter(Mandatory=$false)]
    [string]$pasta = "PENTALATERAL_UNIVERSAL\PERFIS_NICHO",

    [Parameter(Mandatory=$false)]
    [string]$pastaClaude = "CLIENTES\INGRID\CLAUDE_PROJECT"
)

# Coletar documentos do nicho em ambas as pastas
$arquivos = @()
if (Test-Path $pasta) {
    $arquivos += Get-ChildItem -Path $pasta -Filter "*$nicho*" -File | Where-Object { $_.Extension -eq ".md" }
}
if (Test-Path $pastaClaude) {
    $arquivos += Get-ChildItem -Path $pastaClaude -Filter "*$nicho*" -File | Where-Object { $_.Extension -eq ".md" }
}
if (Test-Path $pastaClaude) {
    $arquivos += Get-ChildItem -Path $pastaClaude -Filter "*EMBAIXADOR*" -File | Where-Object { $_.Extension -eq ".md" }
    $arquivos += Get-ChildItem -Path $pastaClaude -Filter "*AUDITOR*" -File | Where-Object { $_.Extension -eq ".md" }
    $arquivos += Get-ChildItem -Path $pastaClaude -Filter "*REACAO*" -File | Where-Object { $_.Extension -eq ".md" }
}
$arquivos = $arquivos | Select-Object -Unique

Write-Host ""
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host "   PERGUNTAS_ABERTAS_GATE  |  Pentalateral IAH" -ForegroundColor Cyan
Write-Host "   Nicho: $nicho | Documentos encontrados: $($arquivos.Count)" -ForegroundColor White
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host ""

$todasPerguntas = @()

foreach ($arq in $arquivos) {
    $linhas = Get-Content $arq.FullName -Encoding UTF8
    for ($i = 0; $i -lt $linhas.Count; $i++) {
        $linha = $linhas[$i]

        # Detectar perguntas (linhas que terminam com "?", minimo 20 chars)
        if ($linha -match '\?\s*$' -and $linha.Trim().Length -gt 20) {

            # Ignorar perguntas em templates/exemplos (linhas com <pergunta> etc.)
            if ($linha -match '<.*>') { continue }

            # Classificar por contexto e palavras-chave
            $classificacao = "INFORMATIVO"

            $textoBusca = $linha.ToLower()
            if ($textoBusca -match "tam|tamanho.*mercado|build|construir|implementar|arquitetura|schema|banco de dados|edge function|codigo") {
                $classificacao = "BLOQUEIA_BUILD"
            }
            elseif ($textoBusca -match "captaç|prospec|primeiro.*cliente|discovery|lead|pitch|vender|contato.*médico|rede.*pessoal|sub-especialidade") {
                $classificacao = "BLOQUEIA_CAPTACAO"
            }

            $todasPerguntas += [PSCustomObject]@{
                arquivo        = $arq.Name
                linha          = $i + 1
                texto          = $linha.Trim()
                classificacao  = $classificacao
            }
        }
    }
}

if ($todasPerguntas.Count -eq 0) {
    Write-Host "   Nenhuma pergunta aberta detectada nos documentos do ciclo." -ForegroundColor Green
    Write-Host ""
    Write-Host "   RESULTADO: CICLO PODE AVANÇAR" -ForegroundColor Green
    Write-Host ""
    exit 0
}

$bloqueiaBuild = $todasPerguntas | Where-Object { $_.classificacao -eq "BLOQUEIA_BUILD" }
$bloqueiaCapt  = $todasPerguntas | Where-Object { $_.classificacao -eq "BLOQUEIA_CAPTACAO" }
$informativos  = $todasPerguntas | Where-Object { $_.classificacao -eq "INFORMATIVO" }

if ($bloqueiaBuild.Count -gt 0) {
    Write-Host "   [BLOQUEIA_BUILD]  $($bloqueiaBuild.Count) pergunta(s)" -ForegroundColor Red
    foreach ($p in $bloqueiaBuild) {
        Write-Host ("     [{0}:{1}] {2}" -f $p.arquivo, $p.linha, ($p.texto.Substring(0, [Math]::Min(80, $p.texto.Length)))) -ForegroundColor Red
    }
    Write-Host ""
}

if ($bloqueiaCapt.Count -gt 0) {
    Write-Host "   [BLOQUEIA_CAPTACAO]  $($bloqueiaCapt.Count) pergunta(s)" -ForegroundColor Yellow
    foreach ($p in $bloqueiaCapt) {
        Write-Host ("     [{0}:{1}] {2}" -f $p.arquivo, $p.linha, ($p.texto.Substring(0, [Math]::Min(80, $p.texto.Length)))) -ForegroundColor Yellow
    }
    Write-Host ""
}

if ($informativos.Count -gt 0) {
    Write-Host "   [INFORMATIVO]  $($informativos.Count) pergunta(s) — nao bloqueiam" -ForegroundColor Gray
    foreach ($p in $informativos) {
        Write-Host ("     [{0}:{1}] {2}" -f $p.arquivo, $p.linha, ($p.texto.Substring(0, [Math]::Min(80, $p.texto.Length)))) -ForegroundColor Gray
    }
    Write-Host ""
}

Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host ""

if ($bloqueiaBuild.Count -gt 0) {
    Write-Host "   RESULTADO: BUILD BLOQUEADO" -ForegroundColor Red
    Write-Host "   Resolva as $($bloqueiaBuild.Count) perguntas BLOQUEIA_BUILD antes de iniciar qualquer build tecnico." -ForegroundColor Red
    Write-Host ""
    exit 2
}
elseif ($bloqueiaCapt.Count -gt 0) {
    Write-Host "   RESULTADO: CAPTACAO MASSIVA BLOQUEADA" -ForegroundColor Yellow
    Write-Host "   Captacao consultiva 1-a-1 permitida." -ForegroundColor White
    Write-Host "   Resolva as $($bloqueiaCapt.Count) perguntas BLOQUEIA_CAPTACAO antes de campanha ou investimento em captacao." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
else {
    Write-Host "   RESULTADO: CICLO PODE AVANÇAR" -ForegroundColor Green
    Write-Host "   $($informativos.Count) pergunta(s) informativa(s) abertas — registre no LEDGER e siga." -ForegroundColor Gray
    Write-Host ""
    exit 0
}
