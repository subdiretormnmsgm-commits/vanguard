#Requires -Version 5.1
# agenda_scheduler.ps1 -- Alerta automatico de gates por data computada (OSV-003)
# Calcula datas dos blocos de build a partir de deadline + plano_build + dias_completos
# Mesmo algoritmo de Get-CalendarioProjeto em briefing_diario.ps1 -- zero mudancas no WIP_BOARD.
# Integrado ao session_start.ps1 (PASSO 8c) -- roda inline a cada sessao.
# Uso: .\scripts\agenda_scheduler.ps1
#      .\scripts\agenda_scheduler.ps1 -diasAlerta 3
#      .\scripts\agenda_scheduler.ps1 -simular

param(
    [int]$diasAlerta = 2,
    [switch]$simular
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE    = Split-Path -Parent $PSScriptRoot
$WIP     = "$BASE\CLIENTES\WIP_BOARD.json"

. "$BASE\scripts\send_telegram_helper.ps1"

$hoje    = (Get-Date).Date
$dataStr = $hoje.ToString("yyyy-MM-dd")

Write-Host ""
Write-Host "======================================================="
Write-Host "  AGENDA SCHEDULER -- $dataStr"
if ($simular) { Write-Host "  MODO: SIMULACAO (Telegram nao sera enviado)" -ForegroundColor Yellow }
Write-Host "======================================================="
Write-Host ""

if (-not (Test-Path $WIP)) {
    Write-Host "  [ERRO] WIP_BOARD.json nao encontrado." -ForegroundColor Red
    exit 1
}

$board    = Get-Content $WIP -Raw -Encoding UTF8 | ConvertFrom-Json
$projetos = @($board.board.build | Where-Object { $_ })

if ($projetos.Count -eq 0) {
    Write-Host "  [INFO] Nenhum projeto em BUILD -- nada a agendar." -ForegroundColor DarkGray
    Write-Host ""
    exit 0
}

# Calcula a data estimada de um bloco do plano_build
# Replica exatamente o algoritmo de Get-CalendarioProjeto (briefing_diario.ps1)
function Get-DataEstimadaBloco {
    param(
        [object]$proj,
        [string]$chave
    )

    $deadline      = $proj.deadline
    $inicio        = $proj.build_iniciado_em
    $diasCompletos = @($proj.dias_completos)
    $planoBuild    = $proj.plano_build
    $deliveryDates = $proj.delivery_dates

    if (-not $planoBuild -or -not $inicio -or -not $deadline) { return $null }

    # Maximo dia de build concluido
    $maxDiaConcluido = 0
    foreach ($dc in $diasCompletos) {
        $ns = [regex]::Matches($dc, '\d+') | ForEach-Object { [int]$_.Value }
        foreach ($n in $ns) { if ($n -gt $maxDiaConcluido) { $maxDiaConcluido = $n } }
    }

    # Contar blocos totais, concluidos, e max dia do plano
    $maxDiaTotalPlano = 0
    $blocosTotais     = 0
    $blocosConcluidos = 0
    foreach ($prop in $planoBuild.PSObject.Properties) {
        $ns = [regex]::Matches($prop.Name, '\d+') | ForEach-Object { [int]$_.Value }
        if ($ns.Count -eq 0) { continue }
        $maxB = ($ns | Measure-Object -Maximum).Maximum
        if ($maxB -gt $maxDiaTotalPlano) { $maxDiaTotalPlano = $maxB }
        $blocosTotais++
        if ($maxDiaConcluido -ge $maxB) { $blocosConcluidos++ }
    }

    $blocosRestantes = $blocosTotais - $blocosConcluidos
    $daysLeft        = ([datetime]$deadline - $hoje).Days
    $diasPorBloco    = if ($blocosRestantes -gt 0) { [Math]::Ceiling($daysLeft / $blocosRestantes) } else { 1 }

    # Verificar numeros do bloco especifico
    $nums = [regex]::Matches($chave, '\d+') | ForEach-Object { [int]$_.Value }
    if ($nums.Count -eq 0) { return $null }
    $maxDia = ($nums | Measure-Object -Maximum).Maximum

    # Bloco ja concluido -- usar delivery_dates se disponivel
    if ($maxDiaConcluido -ge $maxDia) {
        if ($deliveryDates -and $deliveryDates.PSObject.Properties[$chave]) {
            return ([datetime]$deliveryDates.PSObject.Properties[$chave].Value).Date
        }
        $fracao     = if ($maxDiaTotalPlano -gt 0) { $maxDia / $maxDiaTotalPlano } else { 0.5 }
        $diasUsados = ($hoje - [datetime]$inicio).Days
        return (([datetime]$inicio).AddDays([Math]::Round($fracao * $diasUsados))).Date
    }

    # Percorrer blocos em ordem para calcular indice de bloco futuro
    $blocoFuturoIdx = 0
    $primeiroAtivo  = $true

    foreach ($prop in $planoBuild.PSObject.Properties) {
        $pNums = [regex]::Matches($prop.Name, '\d+') | ForEach-Object { [int]$_.Value }
        if ($pNums.Count -eq 0) { continue }
        $pMinDia = ($pNums | Measure-Object -Minimum).Minimum
        $pMaxDia = ($pNums | Measure-Object -Maximum).Maximum

        if ($maxDiaConcluido -ge $pMaxDia) { continue }  # ja concluido -- pular

        if ($prop.Name -eq $chave) {
            if ($maxDiaConcluido -ge ($pMinDia - 1) -and $primeiroAtivo) {
                return $hoje  # bloco ativo agora
            }
            return $hoje.AddDays($blocoFuturoIdx * $diasPorBloco)
        }

        if ($maxDiaConcluido -ge ($pMinDia - 1) -and $primeiroAtivo) {
            $primeiroAtivo = $false
        } else {
            $blocoFuturoIdx++
        }
    }

    return $null
}

$gatesHoje    = [System.Collections.ArrayList]@()
$gatesProximos = [System.Collections.ArrayList]@()

foreach ($proj in $projetos) {
    $clienteUpper = $proj.cliente.ToUpper()
    $planoBuild   = $proj.plano_build
    $gates        = $proj.gates_bloqueantes

    if (-not $planoBuild) { continue }

    Write-Host "  [$clienteUpper] Gates computados:" -ForegroundColor Cyan

    foreach ($prop in $planoBuild.PSObject.Properties) {
        $chave     = $prop.Name
        $descBloco = $prop.Value

        $dataEstimada = Get-DataEstimadaBloco -proj $proj -chave $chave
        if (-not $dataEstimada) { continue }

        $delta = ($dataEstimada.Date - $hoje).Days

        # Buscar descricao do gate associado ao bloco (pelo numero maximo do dia)
        $gateDesc = ""
        if ($gates) {
            $numBloco = [regex]::Matches($chave, '\d+') | ForEach-Object { [int]$_.Value } | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
            foreach ($gp in $gates.PSObject.Properties) {
                if ($gp.Name -match "dia$numBloco" -or $gp.Name -match "dia_$numBloco") {
                    $gateDesc = $gp.Value
                    break
                }
            }
        }

        if ($delta -lt 0) {
            $simbolo = "OK"
            $cor     = "DarkGray"
        } elseif ($delta -eq 0) {
            $simbolo = "HOJE"
            $cor     = "Red"
        } elseif ($delta -le $diasAlerta) {
            $simbolo = "Em ${delta}d"
            $cor     = "Yellow"
        } else {
            $simbolo = "Em ${delta}d"
            $cor     = "DarkGray"
        }

        $linha = "    [$simbolo]  $($dataEstimada.ToString('dd/MM'))  $chave  -- $descBloco"
        if ($linha.Length -gt 90) { $linha = $linha.Substring(0, 87) + "..." }
        Write-Host $linha -ForegroundColor $cor

        if ($delta -ge 0 -and $delta -le $diasAlerta) {
            $item = [PSCustomObject]@{
                Cliente   = $clienteUpper
                Bloco     = $chave
                Descricao = $descBloco
                Gate      = $gateDesc
                Data      = $dataEstimada
                Delta     = $delta
            }
            if ($delta -eq 0) {
                [void]$gatesHoje.Add($item)
            } else {
                [void]$gatesProximos.Add($item)
            }
        }
    }
    Write-Host ""
}

# Enviar alerta Telegram se houver gates urgentes
$gatesUrgentes = @($gatesHoje) + @($gatesProximos)

if ($gatesUrgentes.Count -gt 0) {
    $partes = [System.Collections.ArrayList]@()
    [void]$partes.Add("[AGENDA] GATES PROXIMOS -- $dataStr")
    [void]$partes.Add("")

    foreach ($g in $gatesUrgentes) {
        $icone = if ($g.Delta -eq 0) { "HOJE" } else { "Em $($g.Delta)d ($($g.Data.ToString('dd/MM/yyyy')))" }
        [void]$partes.Add("[$icone] $($g.Cliente) -- Bloco: $($g.Bloco)")
        [void]$partes.Add("Build: $($g.Descricao)")
        if ($g.Gate) { [void]$partes.Add("Gate: $($g.Gate)") }
        [void]$partes.Add("")
    }

    $msgAlerta = $partes -join "`n"

    if ($simular) {
        Write-Host "  [SIMULACAO] Alerta Telegram seria:" -ForegroundColor Yellow
        Write-Host $msgAlerta -ForegroundColor DarkGray
    } else {
        Send-Telegram $msgAlerta | Out-Null
        Write-Host "  [TELEGRAM] Alerta de gates enviado ($($gatesUrgentes.Count) gate(s))." -ForegroundColor Yellow
    }
} else {
    Write-Host "  [OK] Nenhum gate nos proximos $diasAlerta dia(s)." -ForegroundColor Green
}

Write-Host ""
Write-Host "======================================================="
$resumo = "Gates hoje: $($gatesHoje.Count) | Proximos ($($diasAlerta)d): $($gatesProximos.Count)"
Write-Host "  AGENDA SCHEDULER CONCLUIDO -- $resumo"
Write-Host "======================================================="
Write-Host ""
