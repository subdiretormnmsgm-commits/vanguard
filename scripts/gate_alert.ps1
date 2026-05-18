# gate_alert.ps1
# Exibe status de gates de todos os projetos em BUILD
# Combate: gargalo de visibilidade do Diretor — gates vencidos sem alerta
# Integrado ao session_start.ps1 automaticamente
# Uso manual: .\scripts\gate_alert.ps1

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$WIP  = "$BASE\CLIENTES\WIP_BOARD.json"
$HOJE = Get-Date

if (-not (Test-Path $WIP)) {
    Write-Host "WIP_BOARD.json nao encontrado em: $WIP"
    exit 1
}

$board    = Get-Content $WIP -Raw -Encoding UTF8 | ConvertFrom-Json
$projetos = @($board.board.build)

Write-Host ""
Write-Host "=============================================="
Write-Host "  GATE ALERT -- $(Get-Date -Format 'yyyy-MM-dd')"
Write-Host "=============================================="

if ($projetos.Count -eq 0) {
    Write-Host ""
    Write-Host "  Nenhum projeto em BUILD."
    Write-Host "=============================================="
    exit 0
}

$temAlerta = $false

foreach ($proj in $projetos) {
    $deadlineDate  = [datetime]::Parse($proj.deadline)
    $diasRestantes = ($deadlineDate.Date - $HOJE.Date).Days
    $dlStatus = if ($diasRestantes -lt 0) { "VENCIDO ($([Math]::Abs($diasRestantes))d atrasado)" }
                elseif ($diasRestantes -eq 0) { "HOJE" }
                else { "+$diasRestantes dias" }

    Write-Host ""
    Write-Host "  [$($proj.id)] $($proj.cliente) - $($proj.projeto)"
    Write-Host "  Deadline: $($proj.deadline)  [$dlStatus]"

    if (-not $proj.gates_bloqueantes -or -not $proj.build_iniciado_em) {
        Write-Host "  Gates: nao configurados no WIP_BOARD"
        continue
    }

    $inicio = [datetime]::Parse($proj.build_iniciado_em)
    $gates  = $proj.gates_bloqueantes | Get-Member -MemberType NoteProperty |
              Select-Object -ExpandProperty Name |
              Sort-Object { [int]($_ -replace '\D', '') }

    Write-Host "  Gates:"
    $numAnterior = 0
    foreach ($g in $gates) {
        $num      = [int]($g -replace '\D', '')
        $gateDate = $inicio.AddDays($num - 1)
        $diff     = ($gateDate.Date - $HOJE.Date).Days
        $descricao = $proj.gates_bloqueantes.$g

        $concluido = $false
        if ($proj.dias_completos) {
            foreach ($d in $proj.dias_completos) {
                if ($d -match "^dia$num") { $concluido = $true; break }
            }
        }

        # Verificar se o dia imediatamente anterior ao gate foi concluido
        # Gate dia2 requer dia1 concluido; gate dia5 requer dia4 concluido; etc.
        $diaAnterior = $num - 1
        $anteriorConcluido = $true
        if ($diaAnterior -gt 0) {
            $anteriorConcluido = $false
            if ($proj.dias_completos) {
                foreach ($d in $proj.dias_completos) {
                    if ($d -match "^dia$diaAnterior") { $anteriorConcluido = $true; break }
                }
            }
        }

        $icone = if ($concluido)                        { "[OK]" }
                 elseif (-not $anteriorConcluido)       { "[--]" }
                 elseif ($diff -lt 0)                   { "[!!]" }
                 elseif ($diff -eq 0)                   { "[>>]" }
                 else                                   { "[  ]" }

        # So alerta se gate vencido E anterior concluido (gate realmente ativo)
        if (-not $concluido -and $anteriorConcluido -and $diff -le 0) { $temAlerta = $true }

        $bloqueadoLabel = if (-not $anteriorConcluido -and -not $concluido) { " [aguarda dia anterior]" } else { "" }
        Write-Host "    $icone  $g ($($gateDate.ToString('dd/MM'))): $descricao$bloqueadoLabel"

        $numAnterior = $num
    }
}

Write-Host ""
if ($temAlerta) {
    Write-Host "  [!!] ATENCAO: Ha gates VENCIDOS ou vencendo HOJE."
    Write-Host "       Resolva antes de avancar para novas tarefas."
}
Write-Host "=============================================="
