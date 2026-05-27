#Requires -Version 5.1
# churn_watch_autonomo.ps1 -- CHURN-WATCH autonomo por projeto (OSV-003)
# Le MEMORIA_EMBAIXADOR.md de cada projeto, extrai data do ultimo contato
# e dispara alerta Telegram se delta >= threshold.
# Registrado via Task Scheduler em session_start.ps1 (roda 08:00 diariamente).
# Uso: .\scripts\churn_watch_autonomo.ps1
#      .\scripts\churn_watch_autonomo.ps1 -simular   (nao envia Telegram)

param(
    [switch]$simular
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE           = Split-Path -Parent $PSScriptRoot
$DEPENDENCY_MAP = "$BASE\PENTALATERAL_UNIVERSAL\OPERACAO\DEPENDENCY_MAP.json"
$CLIENTES_DIR   = "$BASE\CLIENTES"

. "$BASE\scripts\send_telegram_helper.ps1"

$hoje       = (Get-Date).Date
$dataStr    = $hoje.ToString("yyyy-MM-dd")
$THRESHOLD_PADRAO = 5

Write-Host ""
Write-Host "======================================================="
Write-Host "  CHURN-WATCH AUTONOMO -- $dataStr"
if ($simular) { Write-Host "  MODO: SIMULACAO (Telegram nao sera disparado)" -ForegroundColor Yellow }
Write-Host "======================================================="
Write-Host ""

# Carregar projetos ativos do WIP_BOARD (dinamico -- Get-ProjetosAtivos)
$projetos = @()
$getProjetosScript = "$BASE\utils\Get-ProjetosAtivos.ps1"
if (Test-Path $getProjetosScript) {
    . $getProjetosScript
    $projetos = @(Get-ProjetosAtivos -WipPath "$BASE\CLIENTES\WIP_BOARD.json")
}
# Fallback: DEPENDENCY_MAP (DEPRECATED -- manter ate todos os projetos migrarem)
if ($projetos.Count -eq 0 -and (Test-Path $DEPENDENCY_MAP)) {
    try {
        $map = Get-Content $DEPENDENCY_MAP -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($map.projetos_ativos -and $map.projetos_ativos.Count -gt 0) {
            $projetos = @($map.projetos_ativos | ForEach-Object { $_.ToUpper() })
        }
    } catch { }
}
if ($projetos.Count -eq 0) {
    Write-Host "  [AVISO] Nenhum projeto ativo no WIP_BOARD -- verificar board.build" -ForegroundColor Yellow
    exit 0
}

Write-Host "  Projetos: $($projetos -join ', ')" -ForegroundColor Cyan
Write-Host ""

foreach ($proj in $projetos) {
    $memoriaPath = "$CLIENTES_DIR\$proj\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"

    if (-not (Test-Path $memoriaPath)) {
        Write-Host "  [$proj] MEMORIA_EMBAIXADOR.md nao encontrada -- ignorado" -ForegroundColor DarkGray
        continue
    }

    $memoria = Get-Content $memoriaPath -Raw -Encoding UTF8

    # Extrair ultima data da tabela CONTATOS REGISTRADOS
    # Formato real: | 2026-05-26 | WhatsApp | Evento | Fonte |
    $ultimoContato = $null
    $matchesData   = [regex]::Matches($memoria, '\|\s*(\d{4}-\d{2}-\d{2})\s*\|')
    if ($matchesData.Count -gt 0) {
        $datas = $matchesData | ForEach-Object { [datetime]$_.Groups[1].Value } | Sort-Object -Descending
        $ultimoContato = $datas | Select-Object -First 1
    }

    if (-not $ultimoContato) {
        Write-Host "  [$proj] Nenhuma data de contato encontrada na MEMORIA_EMBAIXADOR -- ignorado" -ForegroundColor Yellow
        continue
    }

    $diasSemContato = ($hoje - $ultimoContato.Date).Days

    # Threshold: buscar campo churn_watch_threshold no WIP_BOARD, fallback 5 dias
    $threshold = $THRESHOLD_PADRAO
    $wipPath   = "$CLIENTES_DIR\WIP_BOARD.json"
    if (Test-Path $wipPath) {
        try {
            $wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
            $projWip = $wip.board.build | Where-Object { $_.cliente -and $_.cliente.ToUpper() -eq $proj } | Select-Object -First 1
            if ($projWip -and $projWip.churn_watch_threshold) {
                $threshold = [int]$projWip.churn_watch_threshold
            }
        } catch { }
    }

    $statusLabel = "OK ($diasSemContato dias, threshold: $threshold)"
    $corStatus   = "Green"

    if ($diasSemContato -ge $threshold) {
        $nivel   = if ($diasSemContato -ge ($threshold * 2)) { "CRITICO" } else { "ALERTA" }
        $icone   = if ($nivel -eq "CRITICO") { "VERMELHO" } else { "AMARELO" }
        $corStatus = if ($nivel -eq "CRITICO") { "Red" } else { "Yellow" }

        # Extrair mensagem de reengajamento da MEMORIA_EMBAIXADOR (se existir)
        $msgReeng = "Oi, tudo bem? Conseguiu usar o app recentemente?"
        $matchMsg = [regex]::Match($memoria, 'mensagem_reengajamento[^:]*:[^\n]*"([^"]+)"')
        if ($matchMsg.Success) { $msgReeng = $matchMsg.Groups[1].Value }

        # Extrair ultima fala verbatim (ultima linha da tabela FALAS VERBATIM)
        $ultimaFala = ""
        $matchesFala = [regex]::Matches($memoria, '\|\s*\d{4}-\d{2}-\d{2}\s*\|[^|]+\|\s*\*"([^"]+)"\*')
        if ($matchesFala.Count -gt 0) {
            $ultimaFala = "`nUltima fala: ""$($matchesFala[$matchesFala.Count - 1].Groups[1].Value)"""
        }

        $msgAlerta = @"
[$icone] CHURN-WATCH -- $proj
$diasSemContato dias sem contato (threshold: $threshold dias)
Ultimo contato: $($ultimoContato.ToString('dd/MM/yyyy'))$ultimaFala

Mensagem sugerida:
"$msgReeng"

Acao: acionar Embaixador ou enviar mensagem agora.
"@
        Write-Host "  [$proj] $nivel -- $diasSemContato dias sem contato (threshold: $threshold)" -ForegroundColor $corStatus

        if ($simular) {
            Write-Host "  [SIMULACAO] Telegram nao enviado. Mensagem seria:" -ForegroundColor Yellow
            Write-Host $msgAlerta -ForegroundColor DarkGray
        } else {
            Send-Telegram $msgAlerta | Out-Null
            Write-Host "  [$proj] Alerta Telegram enviado." -ForegroundColor $corStatus
        }

        $statusLabel = "$nivel -- $diasSemContato dias (alerta enviado)"
    } else {
        Write-Host "  [$proj] $statusLabel" -ForegroundColor $corStatus
    }
}

Write-Host ""
Write-Host "======================================================="
Write-Host "  CHURN-WATCH CONCLUIDO -- $dataStr"
Write-Host "======================================================="
Write-Host ""
