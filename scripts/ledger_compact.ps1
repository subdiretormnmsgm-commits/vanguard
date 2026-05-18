# ledger_compact.ps1
# Arquiva principios do INTELLIGENCE_LEDGER com mais de 90 dias
# Mantém LEDGER enxuto — combate Context Drift (Risco 1 identificado pelo Estrategista)
# Principios marcados com [PERMANENTE] nunca sao arquivados
# Uso: .\scripts\ledger_compact.ps1 [-simular] [-dias 90]

param(
    [switch]$simular,
    [int]$dias = 90
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE    = Split-Path -Parent $PSScriptRoot
$LEDGER  = "$BASE\INTELLIGENCE_LEDGER.md"
$ARQUIVO = "$BASE\INTELLIGENCE_LEDGER_ARQUIVO.md"
$LIMITE  = (Get-Date).AddDays(-$dias)
$HOJE    = Get-Date -Format "yyyy-MM-dd"

Write-Host ""
Write-Host "=============================================="
Write-Host "  LEDGER COMPACT -- $HOJE"
Write-Host "  Arquivando principios com mais de $dias dias"
if ($simular) { Write-Host "  MODO SIMULACAO -- nenhum arquivo sera alterado" }
Write-Host "=============================================="
Write-Host ""

if (-not (Test-Path $LEDGER)) {
    Write-Host "ERRO: INTELLIGENCE_LEDGER.md nao encontrado."
    exit 1
}

$conteudo = Get-Content $LEDGER -Raw -Encoding UTF8

# Separar blocos de principio pelo padrao ### [P-XXX]
$blocos   = [System.Collections.ArrayList]::new()
$partes   = $conteudo -split '(?=### \[P-\d+\])'

$cabecalho    = $partes[0]
$manter       = [System.Collections.ArrayList]::new()
$arquivar     = [System.Collections.ArrayList]::new()
$permanentes  = 0

foreach ($bloco in $partes[1..($partes.Count - 1)]) {
    if ([string]::IsNullOrWhiteSpace($bloco)) { continue }

    # Verificar flag [PERMANENTE]
    if ($bloco -match '\[PERMANENTE\]') {
        [void]$manter.Add($bloco)
        $permanentes++
        continue
    }

    # Extrair data de descoberta
    if ($bloco -match '\*\*Descoberto:\*\*\s*(\d{4}-\d{2}-\d{2})') {
        $dataBloco = [datetime]::Parse($Matches[1])
        if ($dataBloco -lt $LIMITE) {
            [void]$arquivar.Add($bloco)
        } else {
            [void]$manter.Add($bloco)
        }
    } else {
        # Sem data — manter por seguranca
        [void]$manter.Add($bloco)
    }
}

Write-Host "  Principios encontrados : $($partes.Count - 1)"
Write-Host "  Permanentes (nunca arquivar): $permanentes"
Write-Host "  Para manter (< $dias dias) : $($manter.Count)"
Write-Host "  Para arquivar (>= $dias dias): $($arquivar.Count)"
Write-Host ""

if ($arquivar.Count -eq 0) {
    Write-Host "  Nenhum principio elegivel para arquivamento. LEDGER ja esta enxuto."
    Write-Host "=============================================="
    exit 0
}

# Listar o que seria arquivado
Write-Host "  Principios que serao arquivados:"
foreach ($b in $arquivar) {
    if ($b -match '### (\[P-\d+\][^\n]*)') {
        Write-Host "    - $($Matches[1].Trim())"
    }
}
Write-Host ""

if ($simular) {
    Write-Host "  [SIMULACAO] Nenhum arquivo alterado."
    Write-Host "  Execute sem -simular para aplicar."
    Write-Host "=============================================="
    exit 0
}

# Confirmacao
$confirma = Read-Host "  Confirmar arquivamento? [S/N]"
if ($confirma -notmatch '^[Ss]') {
    Write-Host "  Cancelado pelo usuario."
    Write-Host "=============================================="
    exit 0
}

# --- Atualizar LEDGER (manter apenas os validos) ---
$novoLedger = $cabecalho + ($manter -join "")
Set-Content $LEDGER -Value $novoLedger -Encoding UTF8

# --- Adicionar ao arquivo historico ---
$cabecalhoArquivo = ""
if (Test-Path $ARQUIVO) {
    $cabecalhoArquivo = Get-Content $ARQUIVO -Raw -Encoding UTF8
} else {
    $cabecalhoArquivo = "# INTELLIGENCE LEDGER - ARQUIVO HISTORICO`n" +
                        "Principios arquivados automaticamente por ledger_compact.ps1`n" +
                        "Consulte este arquivo quando precisar de contexto historico profundo.`n`n"
}

$novaEntrada = "`n`n---`n`n## COMPACTACAO $HOJE (arquivados $($arquivar.Count) principios)`n`n" +
               ($arquivar -join "")

Set-Content $ARQUIVO -Value ($cabecalhoArquivo + $novaEntrada) -Encoding UTF8

Write-Host ""
Write-Host "  Concluido:"
Write-Host "  INTELLIGENCE_LEDGER.md     — $($manter.Count) principios mantidos"
Write-Host "  INTELLIGENCE_LEDGER_ARQUIVO.md — $($arquivar.Count) principios arquivados"
Write-Host ""
Write-Host "  LEDGER enxuto. Context Drift mitigado."
Write-Host "=============================================="
