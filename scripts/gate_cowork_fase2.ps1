#Requires -Version 5.1
# gate_cowork_fase2.ps1 -- P-159
# Bloqueia Fase 3 (NICHE_MODELER / Antigravity) se Fase 2 (Veredito INBOX) estiver pendente.
# Uso: .\scripts\gate_cowork_fase2.ps1 [-cliente VANGUARD]
# exit 0 = liberado | exit 1 = bloqueado (Fase 2 pendente)

param(
    [string]$cliente = "VANGUARD"
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE     = Split-Path -Parent $PSScriptRoot
$handoff  = "$BASE\CLIENTES\$cliente\COWORK_HANDOFF.md"

Write-Host ""
Write-Host "=================================================="
Write-Host " GATE P-159 -- COWORK FASE 2 -- Cliente: $cliente"
Write-Host "=================================================="

# Verificar existencia do HANDOFF
if (-not (Test-Path $handoff)) {
    Write-Host "[AVISO] COWORK_HANDOFF.md nao encontrado para $cliente."
    Write-Host "        Criando sessao Cowork do zero -- Fase 2 nao aplicavel."
    Write-Host "[OK] Gate liberado (sem sessao anterior)."
    exit 0
}

$content = Get-Content $handoff -Raw -Encoding UTF8

# Detectar Fase 2 como pendente
# Padrao: linha com "Fase pendente" contendo "Fase 2"
$fase2Pendente = $false
foreach ($linha in ($content -split "`n")) {
    if ($linha -match "(?i)Fase\s+pendente.*Fase\s+2" -or
        $linha -match "(?i)Fase\s+2.*pendente" -or
        $linha -match "FASE 2.*VEREDITO INBOX.*gate obrigat") {
        $fase2Pendente = $true
        break
    }
}

if ($fase2Pendente) {
    Write-Host ""
    Write-Host "BLOQUEADO -- P-159"
    Write-Host ""
    Write-Host "  Fase 2 (Veredito INBOX) nao foi executada."
    Write-Host "  Voce esta tentando iniciar a Fase 3 (NICHE_MODELER / Antigravity)"
    Write-Host "  sem ter dado veredito nos arquivos do INBOX_COWORK."
    Write-Host ""
    Write-Host "  ACAO OBRIGATORIA:"
    Write-Host "  1. Abrir CLIENTES\$cliente\COWORK_HANDOFF.md"
    Write-Host "  2. Executar Fase 2: ler arquivos INBOX via MCP Drive + emitir veredito"
    Write-Host "  3. Atualizar COWORK_HANDOFF.md marcando Fase 2 como concluida"
    Write-Host "  4. Rodar este gate novamente para confirmar liberacao"
    Write-Host ""
    Write-Host "  Drive INBOX_COWORK: 1EjaH6TmsxbYpgKWb7ASm7CohFJfwSLKi"
    Write-Host "=================================================="
    exit 1
}

Write-Host "[OK] Fase 2 concluida -- Fase 3 liberada."
Write-Host "=================================================="
exit 0
