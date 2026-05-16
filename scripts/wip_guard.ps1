# wip_guard.ps1
# Audita limites WIP e bloqueia abertura de projeto novo quando condicoes nao sao atendidas
# Combate: deriva de foco + violacao de P-004 (escala antes do primeiro MRR)
# Uso: .\scripts\wip_guard.ps1 [-novoCliente "Nome do Cliente"]

param(
    [string]$novoCliente = ""
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$WIP  = "$BASE\CLIENTES\WIP_BOARD.json"
$HOJE = Get-Date

if (-not (Test-Path $WIP)) {
    Write-Host "WIP_BOARD.json nao encontrado."
    exit 1
}

$board   = Get-Content $WIP -Raw -Encoding UTF8 | ConvertFrom-Json
$emBuild = @($board.board.build)
$limite  = $board.wip_limits.build

Write-Host ""
Write-Host "=============================================="
Write-Host "  WIP GUARD -- $(Get-Date -Format 'yyyy-MM-dd')"
Write-Host "=============================================="
Write-Host ""
Write-Host "  Limite WIP (build) : $limite"
Write-Host "  Projetos em BUILD  : $($emBuild.Count)"
if ($novoCliente) {
    Write-Host "  Candidato a entrada: $novoCliente"
}
Write-Host ""

# --- Verificar MRR confirmado ---
$temMRR = $false
foreach ($p in @($board.board.entregue)) {
    if ($p.valor_fechado -gt 0) { $temMRR = $true }
}
foreach ($p in $emBuild) {
    if ($p.valor_fechado -gt 0 -and ($p.status -match "pago|producao")) { $temMRR = $true }
}

# --- Verificar gates vencidos sem conclusao ---
$gatesVencidos = @()
foreach ($proj in $emBuild) {
    if (-not $proj.gates_bloqueantes -or -not $proj.build_iniciado_em) { continue }
    $inicio = [datetime]::Parse($proj.build_iniciado_em)
    $gates  = $proj.gates_bloqueantes | Get-Member -MemberType NoteProperty |
              Select-Object -ExpandProperty Name
    foreach ($g in $gates) {
        $num      = [int]($g -replace '\D', '')
        $gateDate = $inicio.AddDays($num - 1)
        $diff     = ($gateDate.Date - $HOJE.Date).Days
        $concluido = $false
        if ($proj.dias_completos) {
            foreach ($d in $proj.dias_completos) {
                if ($d -match "^dia$num") { $concluido = $true; break }
            }
        }
        if (-not $concluido -and $diff -lt 0) {
            $gatesVencidos += "[$($proj.id)] $g - venceu $($gateDate.ToString('dd/MM'))"
        }
    }
}

# --- Montar lista de bloqueios ---
$bloqueios = @()

if ($emBuild.Count -ge $limite) {
    $bloqueios += "WIP LIMIT atingido: $($emBuild.Count)/$limite projetos em BUILD"
}

if (-not $temMRR) {
    $bloqueios += "MRR = 0: nenhum pagamento confirmado. P-004 ativo - nao abrir novo projeto antes do primeiro real"
}

if ($gatesVencidos.Count -gt 0) {
    $bloqueios += "Gates vencidos sem conclusao:`n      " + ($gatesVencidos -join "`n      ")
}

# --- Exibir resultado ---
if ($bloqueios.Count -eq 0) {
    Write-Host "  STATUS: LIBERADO"
    Write-Host ""
    if ($novoCliente) {
        Write-Host "  Novo projeto [$novoCliente] pode entrar em BUILD."
        Write-Host "  Lembre de atualizar WIP_BOARD.json ao iniciar."
    } else {
        Write-Host "  WIP dentro dos limites. Sistema saudavel."
    }
} else {
    Write-Host "  STATUS: BLOQUEADO"
    Write-Host ""
    Write-Host "  Razoes:"
    foreach ($b in $bloqueios) {
        Write-Host "    [!!] $b"
    }
    Write-Host ""
    Write-Host "  Para desbloquear:"
    if ($emBuild.Count -ge $limite) {
        Write-Host "    > Mover pelo menos 1 projeto de BUILD para ENTREGUE"
    }
    if (-not $temMRR) {
        Write-Host "    > Confirmar pagamento de PROJ-001 (Valdece) e atualizar WIP_BOARD.json"
    }
    if ($gatesVencidos.Count -gt 0) {
        Write-Host "    > Concluir gates vencidos e registrar em dias_completos do WIP_BOARD.json"
    }
}

Write-Host ""
Write-Host "=============================================="

# Rodar gargalo_ping ao final para detectar bloqueios do Diretor
$pingScript = "$BASE\scripts\gargalo_ping.ps1"
if (Test-Path $pingScript) {
    Write-Host ""
    & $pingScript
}
