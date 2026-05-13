# session_close.ps1
# Executar ao fechar qualquer sessao do Quadrilateral
# Prompts obrigatorios para atualizar o INTELLIGENCE_LEDGER

$BASE   = Split-Path -Parent $PSScriptRoot
$LEDGER = "$BASE\INTELLIGENCE_LEDGER.md"
$KG     = "$BASE\knowledge_graph.json"
$DATA   = Get-Date -Format "yyyy-MM-dd"

Write-Host ""
Write-Host "=============================================="
Write-Host "  FECHAMENTO DE SESSAO -- Quadrilateral IAH"
Write-Host "=============================================="
Write-Host ""

if (-not (Test-Path $LEDGER)) {
    Write-Host "ERRO: INTELLIGENCE_LEDGER.md nao encontrado."
    exit 1
}

if (-not (Test-Path $KG)) {
    Write-Host "ERRO: knowledge_graph.json nao encontrado."
    exit 1
}

Write-Host "SESSAO: $DATA"
Write-Host ""
Write-Host "[1/4] Houve FRICCAO nesta sessao? (ALERTA emitido, P0 criado, escopo mudou)"
Write-Host "      Se sim, descreva em 1 linha (Enter para pular):"
$friccao = Read-Host "    > "

Write-Host ""
Write-Host "[2/4] Algum PRINCIPIO novo foi descoberto? (o 'porque' por tras de uma decisao)"
Write-Host "      Se sim, descreva em 1 linha (Enter para pular):"
$principio = Read-Host "    > "

Write-Host ""
Write-Host "[3/4] O Diretor fez OVERRIDE de algum veto? (Hard ou Soft)"
Write-Host "      Se sim, descreva qual e o motivo (Enter para pular):"
$override = Read-Host "    > "

Write-Host ""
Write-Host "[4/4] Houve DERIVA? (sessao divergiu de um principio ativo?)"
Write-Host "      Se sim, qual principio e como foi corrigido (Enter para pular):"
$deriva = Read-Host "    > "

# --- Montar entrada no LEDGER ---
$entrada = "`n`n### [SESSAO $DATA]`n"

if ($friccao)  { $entrada += "`n``[FRICCAO]`` $friccao" }
if ($principio){ $entrada += "`n``[PRINCIPIO]`` $principio" }
if ($override) { $entrada += "`n``[OVERRIDE]`` $override" }
if ($deriva)   { $entrada += "`n``[DERIVA]`` $deriva" }

if ($friccao -or $principio -or $override -or $deriva) {
    $conteudo = Get-Content $LEDGER -Raw -Encoding utf8
    if ($conteudo -match "## GLOSSARIO") {
        $conteudo = $conteudo -replace "(## GLOSSARIO)", "$entrada`n`n## GLOSSARIO"
    } else {
        $conteudo = $conteudo + $entrada
    }
    Set-Content $LEDGER -Value $conteudo -Encoding utf8
    Write-Host ""
    Write-Host "INTELLIGENCE_LEDGER.md atualizado."
} else {
    Write-Host ""
    Write-Host "Nenhum evento registrado nesta sessao."
}

# --- Atualizar knowledge_graph.json ---
$kg = Get-Content $KG -Raw -Encoding utf8 | ConvertFrom-Json

$nova_sessao = [PSCustomObject]@{
    date                 = $DATA
    label                = "Sessao $DATA"
    friction_events      = if ($friccao) { 1 } else { 0 }
    principles_generated = if ($principio) { @("novo") } else { @() }
    overrides            = if ($override) { @([PSCustomObject]@{ description = $override }) } else { @() }
    drift_detected       = if ($deriva) { $true } else { $false }
}

$sessoes = [System.Collections.ArrayList]@()
if ($kg.sessions) { foreach ($s in $kg.sessions) { [void]$sessoes.Add($s) } }
$sessoes.Insert(0, $nova_sessao)
if ($sessoes.Count -gt 20) { $sessoes = $sessoes[0..19] }

$kg.sessions = $sessoes
$kg.meta.last_updated   = $DATA
$kg.meta.total_sessions = $sessoes.Count

$kg | ConvertTo-Json -Depth 10 | Set-Content $KG -Encoding utf8
Write-Host "knowledge_graph.json atualizado."

Write-Host ""
Write-Host "=============================================="
Write-Host "  Proximo passo: git commit + fechar sessao"
Write-Host "=============================================="
