# audit_doc_usage.ps1
# Detecta documentos estrategicos do repositorio que nao sao referenciados
# em nenhum fluxo ativo do Pentalateral (PASSO3, PASSO5, PASSO7, PENDENTES, CLAUDE.md)
# P-XXX: documento no repositorio sem evidencia de uso = ativo morto
# Rodar: .\scripts\audit_doc_usage.ps1

param(
    [string]$Raiz = (Split-Path $PSScriptRoot -Parent),
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

# --- Arquivos de fluxo onde documentos sao referenciados ---
$FluxoFiles = @(
    "CLAUDE.md",
    "PENDENTES.md",
    "CLIENTES\INGRID\PASSO3_GEMINI.md",
    "CLIENTES\VALDECE\PASSO3_GEMINI.md",
    "PENTALATERAL_UNIVERSAL\OPERACAO\PASSO3_GEMINI_TEMPLATE.md",
    "PENTALATERAL_UNIVERSAL\OPERACAO\PASSO5_NOTEBOOKLM_TEMPLATE.md",
    "PENTALATERAL_UNIVERSAL\OPERACAO\PASSO7_EMBAIXADOR_TEMPLATE.md",
    "CONTEXTO_GEMINI.md"
)

# Construir corpus de texto de todos os fluxos ativos
$CorpusFluxo = ""
foreach ($f in $FluxoFiles) {
    $path = Join-Path $Raiz $f
    if (Test-Path $path) {
        $CorpusFluxo += (Get-Content $path -Raw -Encoding UTF8 -ErrorAction SilentlyContinue)
        $CorpusFluxo += "`n"
    }
}

# Incluir PASSO7 e PASSO5 de todos os projetos
Get-ChildItem $Raiz -Recurse -Filter "PASSO5*" -ErrorAction SilentlyContinue | ForEach-Object {
    $CorpusFluxo += (Get-Content $_.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue)
}
Get-ChildItem $Raiz -Recurse -Filter "PASSO7*" -ErrorAction SilentlyContinue | ForEach-Object {
    $CorpusFluxo += (Get-Content $_.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue)
}

# --- Documentos estrategicos para auditar ---
# Foco: .md nao-codigo, fora de HISTORICO/ e NOTEBOOKLM_FONTES/ (esses sao arquivos de output)
$Excluir = @("HISTORICO", "NOTEBOOKLM_FONTES", "KNOWLEDGE_BASE", "node_modules", ".git", "PROTOCOLOS_ENCERRAMENTO", "DECISOES")

$Docs = Get-ChildItem $Raiz -Recurse -Filter "*.md" -ErrorAction SilentlyContinue | Where-Object {
    $caminho = $_.FullName
    $excluido = $false
    foreach ($ex in $Excluir) {
        if ($caminho -like "*\$ex\*") { $excluido = $true; break }
    }
    -not $excluido -and $_.Name -notlike "*.n8n.json"
}

$resultados = @{
    ATIVO  = @()
    MORTO  = @()
    PARCIAL = @()
}

foreach ($doc in $Docs) {
    $nome = $doc.Name
    $nomeBase = [System.IO.Path]::GetFileNameWithoutExtension($nome)
    $relativo = $doc.FullName.Replace($Raiz + "\", "")

    # Verificar se o nome do arquivo aparece no corpus de fluxo
    $refNome    = $CorpusFluxo -match [regex]::Escape($nome)
    $refBase    = $CorpusFluxo -match [regex]::Escape($nomeBase)
    $refRelativo = $CorpusFluxo -match [regex]::Escape($relativo.Replace("\", "/"))

    if ($refNome -or $refBase -or $refRelativo) {
        $resultados["ATIVO"] += $relativo
    } else {
        # Verificar se o conteudo do doc menciona a si mesmo em outros docs
        # (heuristica adicional: nome aparece em WIP_BOARD)
        $wipPath = Join-Path $Raiz "CLIENTES\WIP_BOARD.json"
        $wip = ""
        if (Test-Path $wipPath) { $wip = Get-Content $wipPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue }
        if ($wip -match [regex]::Escape($nomeBase)) {
            $resultados["PARCIAL"] += $relativo
        } else {
            $resultados["MORTO"] += $relativo
        }
    }
}

# --- Output ---
Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  AUDIT_DOC_USAGE — Pentalateral IAH — $(Get-Date -Format 'yyyy-MM-dd')" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ ATIVOS ($($resultados.ATIVO.Count) documentos referenciados em fluxos):" -ForegroundColor Green
if ($Verbose) { $resultados["ATIVO"] | ForEach-Object { Write-Host "   $_" -ForegroundColor Green } }
else { Write-Host "   (use -Verbose para listar)" -ForegroundColor DarkGreen }

Write-Host ""
Write-Host "⚠️  PARCIAL ($($resultados.PARCIAL.Count) mencionados no WIP mas nao em fluxo):" -ForegroundColor Yellow
$resultados["PARCIAL"] | ForEach-Object { Write-Host "   $_" -ForegroundColor Yellow }

Write-Host ""
Write-Host "🔴 MORTOS ($($resultados.MORTO.Count) sem referencia em nenhum fluxo ativo):" -ForegroundColor Red
$resultados["MORTO"] | ForEach-Object { Write-Host "   $_" -ForegroundColor Red }

Write-Host ""
Write-Host "------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "Acao recomendada para MORTOS:" -ForegroundColor DarkGray
Write-Host "  (A) Integrar ao PASSO3/PASSO5/PASSO7 de um projeto" -ForegroundColor DarkGray
Write-Host "  (D) Arquivar em HISTORICO/ do projeto correspondente" -ForegroundColor DarkGray
Write-Host "  (X) Deletar — documento sem proposito no sistema" -ForegroundColor DarkGray
Write-Host ""

# Exportar resultado para o Embaixador
$relatorio = @"
AUDIT_DOC_USAGE — $(Get-Date -Format 'yyyy-MM-dd')
ATIVOS: $($resultados.ATIVO.Count)
PARCIAL: $($resultados.PARCIAL.Count)
MORTOS: $($resultados.MORTO.Count)

MORTOS DETECTADOS:
$($resultados.MORTO -join "`n")

PARCIAL DETECTADOS:
$($resultados.PARCIAL -join "`n")
"@

$relatorioPath = Join-Path $Raiz "scripts\audit_doc_usage_last.txt"
$relatorio | Out-File $relatorioPath -Encoding UTF8
Write-Host "Relatorio salvo: scripts\audit_doc_usage_last.txt" -ForegroundColor DarkGray
