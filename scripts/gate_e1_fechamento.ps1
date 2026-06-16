#Requires -Version 5.1
# gate_e1_fechamento.ps1 -- E-1 Trava-PF-1 (veredito E_1_gate_duro=SIM 2026-06-16)
# Loop nao fecha sem POST publicado (post_url) OU 1 conversa real registrada (conversa_real).
# Le CLIENTES\<cliente>\CLAUDE_PROJECT\LOOP_STATE.json -> bloco e1_evidencia.
# Uso: .\scripts\gate_e1_fechamento.ps1 -cliente VANGUARD
# exit 0 = LIBERADO (evidencia presente, ou e1_evidencia.exigido=false, ou loop ja FECHADO)
# exit 1 = ERRO (LOOP_STATE ausente / invalido / cliente nao resolvido)
# exit 2 = BLOQUEADO (E-1 exigido e evidencia vazia)

param(
    [string]$cliente = "VANGUARD"
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=================================================="
Write-Host " GATE E-1 -- TRAVA-PF-1 (POST OU CONVERSA REAL)"
Write-Host " Cliente: $cliente"
Write-Host "=================================================="

$statePath = "$BASE\CLIENTES\$cliente\CLAUDE_PROJECT\LOOP_STATE.json"

if (-not (Test-Path $statePath)) {
    Write-Host "[ERRO] LOOP_STATE.json nao encontrado para $cliente."
    Write-Host "       Caminho esperado: $statePath"
    exit 1
}

$state = Get-Content $statePath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction SilentlyContinue
if ($null -eq $state) {
    Write-Host "[ERRO] LOOP_STATE.json invalido (parse falhou)."
    exit 1
}

$loopAtual = $state.loop_atual

# Loop ja fechado -> gate nao se aplica
if ($state.loop_status -and ($state.loop_status.ToString().ToUpper() -eq "FECHADO")) {
    Write-Host "[OK] Loop $loopAtual ja esta FECHADO -- gate E-1 nao se aplica."
    Write-Host "=================================================="
    exit 0
}

$ev = $state.e1_evidencia

# Sem bloco e1_evidencia -> gate desarmado (nao exigido neste loop)
if ($null -eq $ev) {
    Write-Host "[OK] Loop $loopAtual sem bloco e1_evidencia -- gate E-1 desarmado."
    Write-Host "=================================================="
    exit 0
}

# Exigido = false -> liberado
if ($ev.exigido -ne $true) {
    Write-Host "[OK] e1_evidencia.exigido = false -- gate E-1 nao bloqueia este loop."
    Write-Host "=================================================="
    exit 0
}

$postUrl  = ""
$conversa = ""
if ($ev.post_url)      { $postUrl  = $ev.post_url.ToString().Trim() }
if ($ev.conversa_real) { $conversa = $ev.conversa_real.ToString().Trim() }

if ($postUrl -ne "" -or $conversa -ne "") {
    Write-Host "[OK] Evidencia E-1 presente para Loop ${loopAtual}:"
    if ($postUrl -ne "")  { Write-Host "     post_url      = $postUrl" }
    if ($conversa -ne "") { Write-Host "     conversa_real = $conversa" }
    Write-Host "[E-1] Loop liberado para fechamento."
    Write-Host "=================================================="
    exit 0
}

Write-Host ""
Write-Host "BLOQUEADO -- E-1 (Trava-PF-1)"
Write-Host ""
Write-Host "  Loop $loopAtual de $cliente nao tem prova de fato externo (PF-1)."
Write-Host "  Veredito do Diretor (2026-06-16): o Loop nao fecha sem"
Write-Host "  POST publicado OU 1 conversa real registrada."
Write-Host ""
Write-Host "  ACAO PARA DESTRAVAR (uma das duas):"
Write-Host "  (a) Publicar o POST ECD e registrar a URL em LOOP_STATE.json ->"
Write-Host "      e1_evidencia.post_url"
Write-Host "  (b) Registrar uma conversa real do nicho em LOOP_STATE.json ->"
Write-Host "      e1_evidencia.conversa_real"
Write-Host ""
Write-Host "=================================================="
exit 2
