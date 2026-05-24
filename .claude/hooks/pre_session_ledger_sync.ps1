#Requires -Version 5.1
# pre_session_ledger_sync.ps1 — Sincroniza INTELLIGENCE_LEDGER.md para todos os
# CLIENTES/*/NOTEBOOKLM_FONTES/ e CLAUDE_PROJECT/ se a fonte for mais recente.
# Chamado automaticamente pelo session_start.ps1. Zero intervencao do Diretor.

$raiz = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

# Mapa: origem → nomes de destino (por tipo de pasta)
$mapa = @(
    [PSCustomObject]@{
        Origem        = "$raiz\INTELLIGENCE_LEDGER.md"
        NomeFontes    = "04_INTELLIGENCE_LEDGER.md"
        NomeClaudeCP  = "06_INTELLIGENCE_LEDGER.md"
    }
)

$clientes    = Get-ChildItem "$raiz\CLIENTES" -Directory -ErrorAction SilentlyContinue |
               Where-Object { $_.Name -notin @("WIP_BOARD.json") }
$sincronizados = 0
$emDia         = 0

foreach ($item in $mapa) {
    if (-not (Test-Path $item.Origem)) { continue }
    $origemInfo = Get-Item $item.Origem

    foreach ($c in $clientes) {
        $nome = $c.Name

        # NOTEBOOKLM_FONTES
        if ($item.NomeFontes) {
            $destFontes = "$raiz\CLIENTES\$nome\NOTEBOOKLM_FONTES\$($item.NomeFontes)"
            if (Test-Path $destFontes) {
                $destInfo = Get-Item $destFontes
                if ($origemInfo.LastWriteTime -gt $destInfo.LastWriteTime) {
                    Copy-Item $item.Origem $destFontes -Force
                    $sincronizados++
                } else {
                    $emDia++
                }
            }
        }

        # CLAUDE_PROJECT (para o Embaixador)
        if ($item.NomeClaudeCP) {
            $destCP = "$raiz\CLIENTES\$nome\CLAUDE_PROJECT\$($item.NomeClaudeCP)"
            if (Test-Path $destCP) {
                $destInfo = Get-Item $destCP
                if ($origemInfo.LastWriteTime -gt $destInfo.LastWriteTime) {
                    Copy-Item $item.Origem $destCP -Force
                    $sincronizados++
                } else {
                    $emDia++
                }
            }
        }
    }
}

if ($sincronizados -gt 0) {
    Write-Output "  [LEDGER-SYNC] $sincronizados copia(s) atualizadas ($emDia em dia)"
}

exit 0
