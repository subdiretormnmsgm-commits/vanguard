#Requires -Version 5.1
# ledger_split.ps1 -- Divisao do INTELLIGENCE_LEDGER.md por volume
# GATILHO: so executar apos P-080 ser inscrito no LEDGER.
# PROTECAO: este script verifica P-080 antes de qualquer acao destrutiva.
# Uso: .\scripts\ledger_split.ps1
#      .\scripts\ledger_split.ps1 -simular   (mostra o que seria feito, sem alterar nada)
# NUNCA executar antes da instrucao explicita do Diretor (veredito registrado).

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

param(
    [switch]$simular
)

$BASE          = Split-Path -Parent $PSScriptRoot
$LEDGER        = "$BASE\INTELLIGENCE_LEDGER.md"
$LEDGER_BACKUP = "$BASE\INTELLIGENCE_LEDGER_PRE_SPLIT_$(Get-Date -Format 'yyyyMMdd_HHmmss').md"
$LEDGER_V1     = "$BASE\INTELLIGENCE_LEDGER_P001_P030.md"
$LEDGER_V2     = "$BASE\INTELLIGENCE_LEDGER_P031_ATUAL.md"

Write-Host ""
Write-Host "======================================================="
Write-Host "  LEDGER SPLIT -- Volume Management"
if ($simular) {
    Write-Host "  MODO: SIMULACAO (nenhum arquivo sera alterado)" -ForegroundColor Yellow
}
Write-Host "======================================================="
Write-Host ""

# --- GATE OBRIGATORIO: P-080 inscrito? ---
if (-not (Test-Path $LEDGER)) {
    Write-Host "  [ERRO] INTELLIGENCE_LEDGER.md nao encontrado em: $LEDGER" -ForegroundColor Red
    exit 1
}

$conteudoLedger = Get-Content $LEDGER -Encoding UTF8 -Raw
$p080Inscrito   = $conteudoLedger -match 'P-080'

if (-not $p080Inscrito) {
    Write-Host "  [BLOQUEIO] P-080 NAO inscrito no INTELLIGENCE_LEDGER.md." -ForegroundColor Red
    Write-Host ""
    Write-Host "  Este script so pode ser executado apos P-080 ser formalmente inscrito." -ForegroundColor Yellow
    Write-Host "  P-080 deve descrever: politica de split do LEDGER por volume." -ForegroundColor Yellow
    Write-Host "  Fluxo: Diretor instrui -> Musculo inscreve P-080 -> commit -> ENTAO rodar ledger_split.ps1" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "  [OK] P-080 detectado no LEDGER -- prosseguindo." -ForegroundColor Green
Write-Host ""

# --- Analise do conteudo ---
$linhasLedger = Get-Content $LEDGER -Encoding UTF8
$totalLinhas  = $linhasLedger.Count

# Detectar principios P-NNN
$principios = @()
for ($i = 0; $i -lt $linhasLedger.Count; $i++) {
    if ($linhasLedger[$i] -match '^#+\s*P-(\d+)') {
        $num = [int]$Matches[1]
        $principios += [PSCustomObject]@{ Linha = $i; Numero = $num; Texto = $linhasLedger[$i] }
    }
}

if ($principios.Count -eq 0) {
    Write-Host "  [AVISO] Nenhum principio P-NNN detectado no LEDGER." -ForegroundColor Yellow
    Write-Host "  Verificar formato: cabecalhos com '## P-001' ou '### P-001'" -ForegroundColor DarkGray
    exit 1
}

$pMin = ($principios | Measure-Object -Property Numero -Minimum).Minimum
$pMax = ($principios | Measure-Object -Property Numero -Maximum).Maximum
$pCorte = 30

Write-Host "  LEDGER: $totalLinhas linhas | P-$($pMin.ToString('D3')) ate P-$($pMax.ToString('D3')) | $($principios.Count) principios" -ForegroundColor White
Write-Host "  Corte: V1 (P-001 a P-030) | V2 (P-031 em diante)" -ForegroundColor Cyan
Write-Host ""

# --- Encontrar linha de corte ---
$linhaCorteV2 = -1
foreach ($p in $principios | Sort-Object Numero) {
    if ($p.Numero -gt $pCorte) {
        $linhaCorteV2 = $p.Linha
        break
    }
}

if ($linhaCorteV2 -lt 0) {
    Write-Host "  [INFO] Todos os principios sao P-001 a P-030. Split nao necessario ainda." -ForegroundColor Yellow
    exit 0
}

$linhasV1 = $linhasLedger[0..($linhaCorteV2 - 1)]
$linhasV2 = $linhasLedger[$linhaCorteV2..($linhasLedger.Count - 1)]

Write-Host "  V1: linhas 1 a $linhaCorteV2 ($($linhasV1.Count) linhas)" -ForegroundColor White
Write-Host "  V2: linhas $($linhaCorteV2 + 1) a $totalLinhas ($($linhasV2.Count) linhas)" -ForegroundColor White
Write-Host ""

if ($simular) {
    Write-Host "  [SIMULACAO] Arquivos que seriam gerados:" -ForegroundColor Yellow
    Write-Host "    BACKUP:  $(Split-Path $LEDGER_BACKUP -Leaf)" -ForegroundColor DarkGray
    Write-Host "    V1:      $(Split-Path $LEDGER_V1 -Leaf)" -ForegroundColor Cyan
    Write-Host "    V2:      $(Split-Path $LEDGER_V2 -Leaf)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [SIMULACAO] INTELLIGENCE_LEDGER.md seria atualizado para apontar para V1 e V2." -ForegroundColor Yellow
    Write-Host "  Execute sem -simular para aplicar." -ForegroundColor White
    Write-Host ""
    exit 0
}

# --- Backup ---
Write-Host "  Criando backup..." -ForegroundColor Cyan
$srcBytes = [System.IO.File]::ReadAllBytes($LEDGER)
[System.IO.File]::WriteAllBytes($LEDGER_BACKUP, $srcBytes)
Write-Host "  [OK] Backup: $(Split-Path $LEDGER_BACKUP -Leaf)" -ForegroundColor Green

# --- Gerar V1 ---
$cabecalhoV1 = @(
    "# INTELLIGENCE LEDGER -- VOLUME 1 (P-001 a P-030)",
    "# Gerado automaticamente por ledger_split.ps1 em $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "# Volume 2: INTELLIGENCE_LEDGER_P031_ATUAL.md",
    ""
)
($cabecalhoV1 + $linhasV1) | Out-File -FilePath $LEDGER_V1 -Encoding UTF8
Write-Host "  [OK] V1: $(Split-Path $LEDGER_V1 -Leaf) ($($linhasV1.Count) linhas)" -ForegroundColor Green

# --- Gerar V2 ---
$cabecalhoV2 = @(
    "# INTELLIGENCE LEDGER -- VOLUME 2 (P-031 em diante -- ATUAL)",
    "# Gerado automaticamente por ledger_split.ps1 em $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "# Volume 1 (P-001 a P-030): INTELLIGENCE_LEDGER_P001_P030.md",
    ""
)
($cabecalhoV2 + $linhasV2) | Out-File -FilePath $LEDGER_V2 -Encoding UTF8
Write-Host "  [OK] V2: $(Split-Path $LEDGER_V2 -Leaf) ($($linhasV2.Count) linhas)" -ForegroundColor Green

# --- Atualizar INTELLIGENCE_LEDGER.md com indice ---
$indice = @(
    "# INTELLIGENCE LEDGER -- INDICE DE VOLUMES",
    "# Gerado por ledger_split.ps1 em $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "# P-080 autoriza este split.",
    "",
    "## Volumes",
    "- [Volume 1 -- P-001 a P-030](INTELLIGENCE_LEDGER_P001_P030.md)",
    "- [Volume 2 -- P-031 em diante (ATUAL)](INTELLIGENCE_LEDGER_P031_ATUAL.md)",
    "",
    "## Edicao",
    "Sempre editar nos volumes. Este arquivo eh apenas indice.",
    "propagate_changes.ps1 propaga de cada volume para CLIENTES/*/NOTEBOOKLM_FONTES/.",
    ""
)
$indice | Out-File -FilePath $LEDGER -Encoding UTF8
Write-Host "  [OK] INTELLIGENCE_LEDGER.md atualizado para indice de volumes" -ForegroundColor Green

Write-Host ""
Write-Host "======================================================="
Write-Host "  SPLIT CONCLUIDO" -ForegroundColor Green
Write-Host "  Proximo passo: atualizar DEPENDENCY_MAP.json R-001" -ForegroundColor Yellow
Write-Host "  para propagar V1 e V2 separadamente para CLIENTES/." -ForegroundColor Yellow
Write-Host "======================================================="
Write-Host ""
