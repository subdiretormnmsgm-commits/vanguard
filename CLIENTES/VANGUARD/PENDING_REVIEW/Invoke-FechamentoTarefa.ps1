<#
.SYNOPSIS
Registra o fechamento de uma tarefa, atualizando simultaneamente a Memória, a Timeline e o WIP Board.

.DESCRIPTION
O Invoke-FechamentoTarefa (ou Register-Veredito) centraliza a gravação de estado do Pentalateral.
Em vez do Músculo (Claude Code) editar múltiplos arquivos Markdown e JSONs manualmente - o que gera esquecimentos e erros de formatação (DEF-M-6) - ele executa este script passando os parâmetros.
O script garante o princípio P-032 e P-091: Evidência em disco atômica e imediata.

.PARAMETER Cliente
O nome do cliente (ex: VANGUARD, INGRID, VALDECE). Usado para resolver o path do P-059.

.PARAMETER Tarefa
ID ou nome da tarefa (ex: "G-1 Motor Headless").

.PARAMETER Decisao
O veredito ou resumo da ação tomada.

.PARAMETER Impacto
O que muda a partir dessa decisão (ex: "Atualiza o script X").

.EXAMPLE
.\Invoke-FechamentoTarefa.ps1 -Cliente "VANGUARD" -Tarefa "Bug P-032" -Decisao "Script atômico implementado" -Impacto "Músculo não edita mais a memória manualmente"
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$Cliente,

    [Parameter(Mandatory=$true)]
    [string]$Tarefa,

    [Parameter(Mandatory=$true)]
    [string]$Decisao,

    [Parameter(Mandatory=$false)]
    [string]$Impacto = "N/A"
)

$ErrorActionPreference = "Stop"

# 1. Resolve Caminhos Base (P-059)
$basePath = Join-Path $PSScriptRoot "..\CLIENTES\$Cliente"
if (-not (Test-Path $basePath)) {
    Write-Error "Diretório do cliente $Cliente não encontrado no escopo."
    exit 1
}

$memoriaPath = Join-Path $basePath "CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_$Cliente.md"
$timelinePath = Join-Path $basePath "..\PENTALATERAL_UNIVERSAL\HISTORICO\16_$($Cliente)_TIMELINE.md"
$wipPath = Join-Path $basePath "CLAUDE_PROJECT\LOOP_STATE.json" # Assumindo G-4 (Isolamento de Estado)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "Iniciando Write-Through (Atualização Atômica)..." -ForegroundColor Cyan

# 2. Atualizar MEMORIA_EMBAIXADOR
if (Test-Path $memoriaPath) {
    $blocoMemoria = "`n### [$timestamp] TAREFA CONCLUÍDA: $Tarefa`n- **Decisão:** $Decisao`n- **Impacto:** $Impacto`n"
    Add-Content -Path $memoriaPath -Value $blocoMemoria -Encoding UTF8
    Write-Host " [OK] MEMORIA_EMBAIXADOR atualizada." -ForegroundColor Green
} else {
    Write-Host " [AVISO] $memoriaPath não encontrado." -ForegroundColor Yellow
}

# 3. Atualizar TIMELINE
if (Test-Path $timelinePath) {
    $blocoTimeline = "`n- **$((Get-Date).ToString('yyyy-MM-dd'))**: Conclusão da tarefa '$Tarefa'. Decisão: $Decisao"
    Add-Content -Path $timelinePath -Value $blocoTimeline -Encoding UTF8
    Write-Host " [OK] TIMELINE atualizada." -ForegroundColor Green
} else {
    Write-Host " [AVISO] TIMELINE não encontrada." -ForegroundColor Yellow
}

# 4. Atualizar WIP_BOARD (LOOP_STATE)
if (Test-Path $wipPath) {
    try {
        $json = Get-Content $wipPath -Raw | ConvertFrom-Json
        
        # Adiciona no array de vereditos/histórico se existir, ou cria
        $novoVeredito = @{
            Data = $timestamp
            Tarefa = $Tarefa
            Decisao = $Decisao
        }

        if (-not $json.PSObject.Properties.Match('Historico_Vereditos').Count) {
            $json | Add-Member -MemberType NoteProperty -Name 'Historico_Vereditos' -Value @()
        }

        $json.Historico_Vereditos += $novoVeredito

        $json | ConvertTo-Json -Depth 5 | Set-Content -Path $wipPath -Encoding UTF8
        Write-Host " [OK] LOOP_STATE.json atualizado." -ForegroundColor Green
    } catch {
        Write-Host " [ERRO] Falha ao atualizar LOOP_STATE.json: $_" -ForegroundColor Red
    }
}

Write-Host "Fechamento da tarefa '$Tarefa' registrado com sucesso!" -ForegroundColor Cyan
exit 0
