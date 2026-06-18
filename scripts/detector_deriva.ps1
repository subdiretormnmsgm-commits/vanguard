#Requires -Version 5.1
# detector_deriva.ps1 -- ATO UNICO de ativacao do DETECTOR DE DERIVA
# Operacao Vault Soberano / Fase F7 (b-min: maestro fino sobre motores JA existentes).
#
# O QUE FAZ: roda em sequencia os gates DETERMINISTICOS que ja vivem em scripts/ e
# entrega UM resumo (semaforo) ao Diretor. ZERO motor de deteccao novo -- so orquestra.
#
# LIMITE EPISTEMICO (persona v1.4, sec 2.5 -- arXiv 2604.03447):
#   este ato cobre a camada Policy-as-Code DETERMINISTICA (mecanica, confiavel).
#   A auditoria SEMANTICA de prosa-vs-principio (LEDGER) e do subagente read-only da
#   skill .claude/skills/doc-drift-audit.md -- nunca deste script.
#
# READ-ONLY sobre o canonico: nao move, nao apaga, nao edita conteudo do vault.
#   (em modo completo, vault_audit.ps1 regenera seus proprios relatorios de auditoria --
#    VAULT_MANIFEST.json / VAULT_AUDIT_REPORT.md -- nunca toca documento canonico.)
# LOCAL-FIRST (C1/P-181): roda so sobre o filesystem local. NUNCA sobre mount rclone.
#
# Modos:
#   (padrao)  varredura COMPLETA  -- roda os 5 motores (inclui vault_audit, hash full)
#   -Leve     varredura LEVE      -- p/ session_start (c-1); pula o vault_audit pesado
#   -Quiet    so a linha-resumo final (uso em hook)
#
# Exit: 0 VERDE | 1 AMARELO | 2 VERMELHO (pior status entre os motores).
#   NUNCA deve derrubar o hook chamador -- o session_start o invoca em try/catch (P-110).
#
# Persona/skill/destino:
#   CONSELHO\SYSTEM_PROMPT_DETECTOR_DERIVA.md (v1.4) -- prompt do ator
#   .claude\skills\doc-drift-audit.md (v1.1)         -- camada operacional semantica
#   PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PENDING_REVIEW.md -- destino UNICO de achado (append, P-124)

param([switch]$Leve, [switch]$Quiet)

$ErrorActionPreference = "Stop"
$raiz   = Split-Path $PSScriptRoot -Parent
$dataAg = Get-Date -Format "yyyy-MM-dd HH:mm"

function Say($msg, $color) { if (-not $Quiet) { Write-Host $msg -ForegroundColor $color } }

# Severidade numerica: 0 VERDE | 1 AMARELO | 2 VERMELHO
$rotulo = @{ 0 = "VERDE"; 1 = "AMARELO"; 2 = "VERMELHO" }
$cor    = @{ 0 = "Green"; 1 = "Yellow";  2 = "Red" }

# Definicao dos motores. 'map' traduz o exit code de CADA motor para severidade comum,
# porque os contratos diferem (doc_freshness usa 1=vermelho; auditar usa 1=amarelo/2=vermelho).
$motores = @(
    @{ nome = "Frescor de conteudo (Gate 0.5)"; script = "doc_freshness_checker.ps1"; args = @("-Silent");
       map = @{ 0 = 0; 1 = 2 }; leve = $true },
    @{ nome = "Consistencia textual (P-054/P-091)"; script = "auditar_consistencia.ps1"; args = @("-Silencioso");
       map = @{ 0 = 0; 1 = 1; 2 = 2 }; leve = $true },
    @{ nome = "Violacao canonica TIPO 1 (P-073)"; script = "detect_canonical_violation.ps1"; args = @();
       map = @{ 0 = 0; 1 = 2 }; leve = $true },
    @{ nome = "Drift comandos ativacao (W-11, Policy-as-Code)"; script = "gate_drift_ativacao.ps1"; args = @("-Quiet");
       map = @{ 0 = 0; 1 = 1; 2 = 1 }; leve = $true },
    @{ nome = "Inventario + frescor do vault (Fase 1, hash full)"; script = "vault_audit.ps1"; args = @();
       map = $null; leve = $false }   # informativo: regenera relatorio, sem severidade-gate
)

$modoTxt = if ($Leve) { "LEVE (session_start)" } else { "COMPLETA" }
Say "" Cyan
Say "============================================================" Cyan
Say "  DETECTOR DE DERIVA -- ato unico (camada deterministica)" Cyan
Say "  Modo: $modoTxt  |  $dataAg" Cyan
Say "============================================================" Cyan

$pior      = 0
$linhas    = @()
$infoVault = $null

foreach ($m in $motores) {
    if ($Leve -and -not $m.leve) { continue }   # modo leve pula o vault_audit pesado
    $sp = Join-Path $PSScriptRoot $m.script
    if (-not (Test-Path $sp)) {
        $linhas += "  ?  $($m.nome) -- MOTOR AUSENTE: $($m.script)"
        if ($pior -lt 1) { $pior = 1 }
        continue
    }
    # Invoca como processo filho (isola exit code, igual ao padrao do session_start)
    $argList = @("-NonInteractive", "-NoProfile", "-File", $sp) + $m.args
    & powershell.exe @argList *> $null
    $ec = $LASTEXITCODE

    if ($null -eq $m.map) {
        # Motor informativo (vault_audit): nao entra no semaforo; so registra que rodou
        $infoVault = "  i  $($m.nome) -- relatorio regenerado (VAULT_AUDIT_REPORT.md)"
        continue
    }
    $sev = if ($m.map.ContainsKey($ec)) { $m.map[$ec] } else { 1 }   # exit desconhecido => AMARELO
    if ($sev -gt $pior) { $pior = $sev }
    $icone = switch ($sev) { 0 { "OK " } 1 { "!! " } 2 { "XX " } }
    $linhas += "  $icone $($m.nome) -- $($rotulo[$sev]) (exit $ec)"
}

Say "" Gray
foreach ($l in $linhas) {
    $sevLinha = if ($l -match "VERMELHO") { 2 } elseif ($l -match "AMARELO|AUSENTE") { 1 } else { 0 }
    Say $l $cor[$sevLinha]
}
if ($infoVault) { Say $infoVault "Gray" }

Say "" Gray
Say "------------------------------------------------------------" Cyan
Say "  DRIFT STATUS (deterministico): $($rotulo[$pior])" $cor[$pior]
if ($pior -ge 1) {
    Say "  -> camada SEMANTICA: acione o subagente read-only via skill doc-drift-audit" "Yellow"
    Say "     (varre prosa-vs-LEDGER; achados -> PENDING_REVIEW.md, append, P-124)" "Yellow"
}
Say "------------------------------------------------------------" Cyan
Say "" Gray

exit $pior
