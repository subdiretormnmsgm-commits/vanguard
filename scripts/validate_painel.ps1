#Requires -Version 5.1
# validate_painel.ps1 -- Verifica consistencia do PAINEL antes de enviar ao Embaixador
# Uso: .\validate_painel.ps1 [-PainelPath caminho] [-Cliente INGRID|VALDECE]
# Integrado ao generate_protocolo_encerramento.ps1 automaticamente apos geracao.
# Exit 0 = VERDE. Exit 1 = inconsistencia detectada -- nao enviar ao Embaixador.

param(
    [string]$PainelPath = "",
    [string]$Cliente    = ""
)

$raiz = Split-Path -Parent $PSScriptRoot
$data = Get-Date -Format "yyyy-MM-dd"

# Resolver caminho se nao passado
if (-not $PainelPath) {
    if ($Cliente) {
        $PainelPath = "$raiz\PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_$($Cliente.ToUpper())_$data.md"
    } else {
        # Pegar o mais recente
        $PainelPath = Get-ChildItem "$raiz\PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_*.md" |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
    }
}

if (-not $PainelPath -or -not (Test-Path $PainelPath)) {
    Write-Host "  [VALIDATE] PAINEL nao encontrado: $PainelPath" -ForegroundColor Red
    exit 1
}

$linhas = Get-Content $PainelPath -Encoding UTF8
$erros  = [System.Collections.Generic.List[string]]::new()

# --- Extrair total declarado no rodape ---
$totalDeclarado = -1
foreach ($l in $linhas) {
    if ($l -match "^Total pendentes abertos:\s*(\d+)") {
        $totalDeclarado = [int]$matches[1]
        break
    }
}

if ($totalDeclarado -lt 0) {
    $erros.Add("Rodape 'Total pendentes abertos' nao encontrado no PAINEL.")
}

# --- Contar itens urgentes (semaforo emoji no corpo) ---
$urgentesContados = 0
$emSecaoPendentes = $false
$emSecaoFuturos   = $false
foreach ($l in $linhas) {
    if ($l -match "^## PENDENTES POR PROJETO")       { $emSecaoPendentes = $true; $emSecaoFuturos = $false; continue }
    if ($l -match "^## PENDENTES FUTUROS")            { $emSecaoFuturos   = $true; $emSecaoPendentes = $false; continue }
    if ($l -match "^## " -and $l -notmatch "PENDENTES") {
        $emSecaoPendentes = $false; $emSecaoFuturos = $false
    }
    # emoji no inicio -- inclui pares substitutos (SMP: 🔴🟡 sao \p{Cs} high-surrogate em PS5.1) + simbolos BMP (⚪)
    if ($emSecaoPendentes -and $l -match "^([\uD800-\uDBFF]|\p{So}|\p{Sm})") { $urgentesContados++ }
}

# --- Contar itens futuros (linhas "- [" na secao futuros) ---
$futurosContados = 0
$emSecaoFuturos2 = $false
foreach ($l in $linhas) {
    if ($l -match "^## PENDENTES FUTUROS")    { $emSecaoFuturos2 = $true; continue }
    if ($l -match "^## " -and $l -notmatch "PENDENTES FUTUROS") { $emSecaoFuturos2 = $false }
    if ($emSecaoFuturos2 -and $l -match "^\- \[") { $futurosContados++ }
}

$totalContado = $urgentesContados + $futurosContados

# --- Verificar consistencia ---
if ($totalDeclarado -ge 0 -and $totalContado -ne $totalDeclarado) {
    $erros.Add("Discrepancia: rodape declara $totalDeclarado pendentes, corpo tem $totalContado ($urgentesContados urgentes + $futurosContados agendados).")
}

# --- Verificar secao obrigatoria: PENDENTES POR PROJETO ---
$temSecaoPendentes = $linhas | Where-Object { $_ -match "^## PENDENTES POR PROJETO" }
if (-not $temSecaoPendentes) {
    $erros.Add("Secao '## PENDENTES POR PROJETO' ausente no PAINEL.")
}

# --- Verificar secao ANALISE GERENCIAL ---
$temAnalise = $linhas | Where-Object { $_ -match "^## ANALISE GERENCIAL" }
if (-not $temAnalise) {
    $erros.Add("Secao '## ANALISE GERENCIAL DO MUSCULO' ausente no PAINEL.")
}

# --- Resultado ---
$nomeArq = Split-Path -Leaf $PainelPath
if ($erros.Count -eq 0) {
    Write-Host "  [VALIDATE] VERDE -- $nomeArq consistente ($totalDeclarado pendentes: $urgentesContados urgentes + $futurosContados agendados)" -ForegroundColor Green
    exit 0
} else {
    Write-Host "  [VALIDATE] VERMELHO -- $nomeArq com inconsistencias:" -ForegroundColor Red
    foreach ($e in $erros) { Write-Host "    >> $e" -ForegroundColor Yellow }
    Write-Host "  [VALIDATE] NAO enviar ao Embaixador -- corrigir e regenerar." -ForegroundColor Red
    exit 1
}
