# ============================================================
# VERIFICAR_ESTADO_PROJETOS.PS1 — P-055
# Estado real dos projetos: fase, proxima atividade, skill ativa.
# Executado automaticamente pelo session_start.ps1 a cada sessao.
# Nunca confiar em resumo de sessao para estado de projeto.
# ============================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$skillsDir = Join-Path $BASE ".claude\skills"

# Ler WIP_BOARD.json
$wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
if (-not (Test-Path $wipPath)) {
    Write-Host "  [AVISO P-055] WIP_BOARD.json nao encontrado." -ForegroundColor Yellow
    exit 0
}

$wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$projetos = @($wip.board.build) + @($wip.board.check) | Where-Object { $_ -ne $null }

if ($projetos.Count -eq 0) {
    Write-Host "  [P-055] Nenhum projeto em BUILD ou CHECK." -ForegroundColor DarkGray
    exit 0
}

Write-Host ""
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host "  ESTADO REAL DOS PROJETOS ATIVOS (P-055) -- $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor Cyan
Write-Host "  Fonte: arquivos em disco. Nao confiar em resumos de sessao."    -ForegroundColor DarkCyan
Write-Host "  ================================================================" -ForegroundColor Cyan

foreach ($proj in $projetos) {
    $nome      = $proj.cliente
    $id        = $proj.id
    $deadline  = $proj.deadline
    $hoje      = Get-Date
    $diasFalta = if ($deadline) { ([datetime]$deadline - $hoje).Days } else { $null }
    $dlLabel   = if ($null -ne $diasFalta) {
        if ($diasFalta -lt 0)    { "[VENCIDO $([Math]::Abs($diasFalta))d]" }
        elseif ($diasFalta -eq 0){ "[HOJE]" }
        else                     { "[$diasFalta dias]" }
    } else { "" }

    $diasOk    = if ($proj.dias_completos) { @($proj.dias_completos) } else { @() }
    $plano     = if ($proj.plano_build)    { $proj.plano_build }        else { $null }
    $gates     = if ($proj.gates_bloqueantes) { $proj.gates_bloqueantes } else { $null }

    Write-Host ""
    Write-Host "  [$id] $nome  --  Deadline: $deadline $dlLabel" -ForegroundColor White

    # -- Fase atual e proxima atividade --
    $faseAtual  = "(nao mapeada)"
    $proximaAtv = "(nao mapeada)"
    if ($plano) {
        $chaves = $plano | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
        $ultimaConcluida = $null
        $proxChave       = $null
        foreach ($ch in $chaves) {
            $isDone = $diasOk | Where-Object { $_ -match ($ch -replace '_','.') }
            if ($isDone) { $ultimaConcluida = $ch }
            elseif (-not $proxChave) { $proxChave = $ch }
        }
        if ($ultimaConcluida) { $faseAtual  = "$ultimaConcluida : $($plano.$ultimaConcluida)" }
        if ($proxChave)       { $proximaAtv = "$proxChave : $($plano.$proxChave)" }
    }
    Write-Host "    Fase concluida       : $faseAtual"   -ForegroundColor DarkGreen
    Write-Host "    PROXIMA ATIVIDADE    : $proximaAtv"  -ForegroundColor Yellow

    # -- Dias concluidos --
    Write-Host "    Dias concluidos      : $(if ($diasOk.Count -gt 0) { $diasOk -join ', ' } else { '(nenhum)' })" -ForegroundColor DarkCyan

    # -- Skills em disco para este cliente --
    $clienteLower = $nome.ToLower()
    $skillsCliente = Get-ChildItem $skillsDir -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -imatch $clienteLower } |
        Sort-Object Name
    if ($skillsCliente.Count -gt 0) {
        Write-Host "    Skills em disco      :" -ForegroundColor DarkCyan
        foreach ($sk in $skillsCliente) {
            $headerLines = Get-Content $sk.FullName -TotalCount 5 -Encoding UTF8 -ErrorAction SilentlyContinue
            if (-not $headerLines) { $headerLines = @("") }
            $match = $headerLines | Select-String "Loop|Camada|Status" | Select-Object -First 1
            $loopInfo = if ($match) { $match.ToString().Trim() } else { "" }
            Write-Host "      $($sk.Name)" -ForegroundColor DarkGray -NoNewline
            if ($loopInfo) { Write-Host "  >> $loopInfo" -ForegroundColor DarkGray }
            else            { Write-Host "" }
        }
        # Determinar proxima skill esperada pelo padrao de numeracao
        $ultimoV = ($skillsCliente.Name | Select-String "v(\d+)" | ForEach-Object {
            [int]$_.Matches[0].Groups[1].Value
        } | Sort-Object -Descending | Select-Object -First 1)
        if ($ultimoV) {
            $proxV = $ultimoV + 1
            Write-Host "    PROXIMA SKILL        : $($clienteLower)-v$proxV  (a gerar no NotebookLM)" -ForegroundColor Magenta
        }
    } else {
        Write-Host "    Skills em disco      : (nenhuma encontrada)" -ForegroundColor DarkYellow
    }

    # -- Gate mais antigo pendente --
    if ($gates) {
        $gateNomes = $gates | Get-Member -MemberType NoteProperty |
            Select-Object -ExpandProperty Name |
            Sort-Object { [int]($_ -replace '\D','') }
        foreach ($g in $gateNomes) {
            $num = [int]($g -replace '\D','')
            $concluido = $diasOk | Where-Object { $_ -match "dia$num" }
            if (-not $concluido) {
                Write-Host "    Gate pendente        : [$g] $($gates.$g)" -ForegroundColor Red
                break
            }
        }
    }
}

Write-Host ""
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host "  P-055: Este painel e a unica fonte de verdade de estado de projeto." -ForegroundColor DarkYellow
Write-Host "  Nao reproduzir afirmacoes de estado sem confirmar aqui primeiro." -ForegroundColor DarkYellow
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host ""
