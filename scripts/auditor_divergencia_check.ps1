# auditor_divergencia_check.ps1
# Anti-Lost-in-the-Middle: verifica se o output do Auditor endereça
# as divergências [DIV-N] solicitadas no PASSO5.
# Se o Auditor auditou coisas diferentes do que foi pedido → detecta e alerta.
#
# Uso: .\scripts\auditor_divergencia_check.ps1 `
#        -passo5 "CLIENTES\INGRID\PASSO5_NOTEBOOKLM_MEDICINA_V2.md" `
#        -auditoria "QUADRILATERAL_UNIVERSAL\PERFIS_NICHO\AUDITORIA_MEDICINA_V2.md"

param(
    [Parameter(Mandatory=$true)]
    [string]$passo5,

    [Parameter(Mandatory=$true)]
    [string]$auditoria
)

if (-not (Test-Path $passo5)) {
    Write-Host "`nERRO: PASSO5 nao encontrado: $passo5" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $auditoria)) {
    Write-Host "`nERRO: Auditoria nao encontrada: $auditoria" -ForegroundColor Red
    exit 1
}

$textoPasso5    = Get-Content $passo5    -Raw -Encoding UTF8
$textoAuditoria = Get-Content $auditoria -Raw -Encoding UTF8

# Extrair [DIV-N] do PASSO5 — divergências solicitadas
$matchesPasso5 = [regex]::Matches($textoPasso5, '\[DIV-(\w+)\]')
$divsSolicitadas = $matchesPasso5 | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

# Extrair [DIV-N] do output do Auditor — divergências que ele endereçou
$matchesAuditoria = [regex]::Matches($textoAuditoria, '\[DIV-(\w+)\]')
$divsEndereçadas = $matchesAuditoria | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

Write-Host ""
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host "   AUDITOR_DIVERGENCIA_CHECK  |  Anti-Lost-in-the-Middle" -ForegroundColor Cyan
Write-Host "   PASSO5   : $passo5" -ForegroundColor Gray
Write-Host "   Auditoria: $auditoria" -ForegroundColor Gray
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host ""

if ($divsSolicitadas.Count -eq 0) {
    Write-Host "   AVISO: Nenhum marcador [DIV-N] encontrado no PASSO5." -ForegroundColor Yellow
    Write-Host "   Verifique se o PASSO5 usa o formato [DIV-1], [DIV-2], etc." -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

Write-Host "   Divergencias solicitadas no PASSO5 : $($divsSolicitadas -join ', ')" -ForegroundColor White
Write-Host "   Divergencias endereçadas na Auditoria: $($divsEndereçadas -join ', ')" -ForegroundColor White
Write-Host ""

$naoEndereçadas = @()
$endereçadas = @()

foreach ($div in $divsSolicitadas) {
    if ($divsEndereçadas -contains $div) {
        $endereçadas += $div
        Write-Host ("   [DIV-{0}]  OK  — endereçada" -f $div) -ForegroundColor Green
    } else {
        $naoEndereçadas += $div
        Write-Host ("   [DIV-{0}]  AUSENTE  — Lost-in-the-Middle detectado" -f $div) -ForegroundColor Red
    }
}

# Detectar divergencias que o Auditor criou mas nao foram solicitadas
$divsExtras = $divsEndereçadas | Where-Object { $divsSolicitadas -notcontains $_ }
if ($divsExtras.Count -gt 0) {
    Write-Host ""
    Write-Host "   Divergencias extras auditadas (nao solicitadas):" -ForegroundColor Yellow
    foreach ($e in $divsExtras) {
        Write-Host ("   [DIV-{0}]  extra — Auditor criou, nao foi pedido" -f $e) -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host ""

if ($naoEndereçadas.Count -eq 0) {
    Write-Host "   RESULTADO:  APROVADA — todas as divergencias endereçadas" -ForegroundColor Green
    if ($divsExtras.Count -gt 0) {
        Write-Host "   AVISO: Auditor entregou extras alem do solicitado." -ForegroundColor Yellow
        Write-Host "   Extras podem ser valiosos, mas nao substituem as solicitadas." -ForegroundColor Yellow
    }
    Write-Host ""
    exit 0
}
else {
    Write-Host "   RESULTADO:  PARCIAL — $($naoEndereçadas.Count) divergencia(s) nao endereçada(s)" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Divergencias que o Auditor NAO respondeu:" -ForegroundColor Red
    foreach ($d in $naoEndereçadas) {
        Write-Host ("     [DIV-{0}]" -f $d) -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "   ACAO:" -ForegroundColor Yellow
    Write-Host "   1. Registrar no LEDGER: [FALHA-PROCESSO-$(Get-Date -Format 'yyyy-MM-dd')] Auditor nao endereçou DIV-$($naoEndereçadas -join '/')" -ForegroundColor Yellow
    Write-Host "   2. Criar PASSO5_V2 focando APENAS nas DIVs nao endereçadas:" -ForegroundColor Yellow
    foreach ($d in $naoEndereçadas) {
        Write-Host ("     [DIV-{0}] — reescrever PASSO5 com instrucao explicita para auditar esta DIV" -f $d) -ForegroundColor Yellow
    }
    Write-Host ""
    exit 2
}
