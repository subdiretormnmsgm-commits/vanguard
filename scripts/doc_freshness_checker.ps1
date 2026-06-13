#Requires -Version 5.1
# doc_freshness_checker.ps1 -- Gate 0.5 do session_close
# ATO 1 do Loop 33 -- verifica CONTEUDO dos arquivos canonicos, nao datas
# Uso: .\scripts\doc_freshness_checker.ps1 [-Cliente VANGUARD] [-Silent]
# Saida: exit 0 (VERDE/AMARELO) | exit 1 (VERMELHO -- bloqueante)

param(
    [string]$Cliente = "VANGUARD",
    [switch]$Silent
)

$baseDir = Split-Path -Parent $PSScriptRoot
$loopStatePath = "$baseDir\CLIENTES\$Cliente\CLAUDE_PROJECT\LOOP_STATE.json"

if (-not (Test-Path $loopStatePath)) {
    Write-Host "[GATE 0.5] LOOP_STATE.json nao encontrado: $loopStatePath" -ForegroundColor Red
    exit 1
}

$loopState = Get-Content $loopStatePath -Raw -Encoding UTF8 | ConvertFrom-Json
$loopAtual = $loopState.loop_atual

$resultados = [System.Collections.Generic.List[PSCustomObject]]::new()
$temVermelho = $false

function Add-Resultado {
    param([string]$Arquivo, [string]$Status, [string]$Detalhe)
    $resultados.Add([PSCustomObject]@{
        Arquivo = $Arquivo
        Status  = $Status
        Detalhe = $Detalhe
    })
    if ($Status -eq "VERMELHO") { $script:temVermelho = $true }
}

# [1] WIP_BOARD.json -- loop_fase_atual.loop coincide com LOOP_STATE.loop_atual?
$wipPath = "$baseDir\CLIENTES\WIP_BOARD.json"
if (Test-Path $wipPath) {
    $wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $proj = $wip.board.build | Where-Object { $_.cliente -eq $Cliente }
    if ($proj) {
        $wipLoop = $proj.loop_fase_atual.loop
        if ($wipLoop -eq $loopAtual) {
            Add-Resultado "WIP_BOARD.json" "VERDE" "loop_fase_atual.loop=$wipLoop == LOOP_STATE=$loopAtual"
        } else {
            Add-Resultado "WIP_BOARD.json" "VERMELHO" "loop_fase_atual.loop=$wipLoop != LOOP_STATE.loop_atual=$loopAtual -- DIVERGENCIA"
        }
    } else {
        Add-Resultado "WIP_BOARD.json" "AMARELO" "Projeto $Cliente nao encontrado em board.build"
    }
} else {
    Add-Resultado "WIP_BOARD.json" "VERMELHO" "Arquivo nao encontrado: $wipPath"
}

# [2] LOOP_STATE.json -- loop_status valido e fase_atual coerente?
$statusValidos = @("ABERTO", "FECHADO", "PRE_LOOP", "ATOS_PRE_ABERTURA", "AGUARDA_EMBAIXADOR", "CONCLUIDO", "VEREDITO_CONFIRMADO", "D1A_APROVADO", "SINTESE_FEITA")
if ($loopState.loop_status -in $statusValidos) {
    Add-Resultado "LOOP_STATE.json" "VERDE" "loop_status='$($loopState.loop_status)' valido · fase_atual='$($loopState.fase_atual)'"
} else {
    Add-Resultado "LOOP_STATE.json" "AMARELO" "loop_status='$($loopState.loop_status)' desconhecido -- verificar schema"
}

# [3] PENDENTES.md -- contem secao "LOOP [N]" do loop corrente?
$pendentesPath = "$baseDir\PENDENTES.md"
if (Test-Path $pendentesPath) {
    $pendentes = Get-Content $pendentesPath -Raw -Encoding UTF8
    $loopTag = "LOOP $loopAtual"
    if ($pendentes -match [regex]::Escape($loopTag)) {
        Add-Resultado "PENDENTES.md" "VERDE" "Secao '$loopTag' encontrada"
    } else {
        Add-Resultado "PENDENTES.md" "VERMELHO" "Secao '$loopTag' ausente -- PENDENTES nao reflete loop atual"
    }
} else {
    Add-Resultado "PENDENTES.md" "VERMELHO" "PENDENTES.md nao encontrado"
}

# [4] MEMORIA_EMBAIXADOR -- data 2026 nas primeiras linhas?
$memoriaPath = "$baseDir\CLIENTES\$Cliente\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_$Cliente.md"
if (Test-Path $memoriaPath) {
    $memoriaLinhas = Get-Content $memoriaPath -TotalCount 10 -Encoding UTF8
    $anoAtual = (Get-Date).Year.ToString()
    if ($memoriaLinhas -match $anoAtual) {
        Add-Resultado "MEMORIA_EMBAIXADOR" "VERDE" "Data $anoAtual encontrada nas primeiras 10 linhas"
    } else {
        Add-Resultado "MEMORIA_EMBAIXADOR" "AMARELO" "Data $anoAtual ausente no cabecalho -- verificar atualizacao"
    }
} else {
    Add-Resultado "MEMORIA_EMBAIXADOR" "AMARELO" "Arquivo nao encontrado: $(Split-Path $memoriaPath -Leaf)"
}

# [5] LEDGER_INBOX.md -- itens pendentes sem movimento?
$ledgerInboxPath = "$baseDir\LEDGER_INBOX.md"
if (-not (Test-Path $ledgerInboxPath)) {
    $ledgerInboxPath = "$baseDir\CLIENTES\$Cliente\LEDGER_INBOX.md"
}
if (Test-Path $ledgerInboxPath) {
    $ledgerContent = Get-Content $ledgerInboxPath -Raw -Encoding UTF8
    $itensAbertos = ([regex]::Matches($ledgerContent, '^\s*-\s*\[ \]', [System.Text.RegularExpressions.RegexOptions]::Multiline)).Count
    if ($itensAbertos -eq 0) {
        Add-Resultado "LEDGER_INBOX.md" "VERDE" "INBOX zerado -- sem itens pendentes"
    } elseif ($itensAbertos -le 5) {
        Add-Resultado "LEDGER_INBOX.md" "AMARELO" "$itensAbertos item(s) no INBOX -- aguardam autorizacao ou movimento"
    } else {
        Add-Resultado "LEDGER_INBOX.md" "VERMELHO" "$itensAbertos itens no INBOX ha mais de 3 loops -- passivo acumulado"
    }
} else {
    Add-Resultado "LEDGER_INBOX.md" "VERDE" "LEDGER_INBOX inexistente -- sem passivo"
}

# [6] TIMELINE -- ultima entrada menciona loop atual ou anterior?
$timelinePaths = @(
    "$baseDir\CLIENTES\$Cliente\NOTEBOOKLM_FONTES\17_VANGUARD_TIMELINE.md",
    "$baseDir\CLIENTES\$Cliente\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
)
foreach ($tPath in $timelinePaths) {
    if (Test-Path $tPath) {
        $timelineContent = Get-Content $tPath -Raw -Encoding UTF8
        $loopAtualStr  = "Loop $loopAtual"
        $loopAntStr    = "Loop $($loopAtual - 1)"
        if ($timelineContent -match [regex]::Escape($loopAtualStr)) {
            Add-Resultado (Split-Path $tPath -Leaf) "VERDE" "'$loopAtualStr' encontrado"
        } elseif ($timelineContent -match [regex]::Escape($loopAntStr)) {
            Add-Resultado (Split-Path $tPath -Leaf) "AMARELO" "Apenas '$loopAntStr' encontrado -- Timeline pode precisar de update no encerramento"
        } else {
            Add-Resultado (Split-Path $tPath -Leaf) "VERMELHO" "Nem '$loopAtualStr' nem '$loopAntStr' na Timeline -- arquivo muito defasado"
        }
    }
}

# OUTPUT
if (-not $Silent) {
    Write-Host ""
    Write-Host "=== DOC FRESHNESS CHECKER -- Loop $loopAtual ($Cliente) ===" -ForegroundColor Cyan
    foreach ($r in $resultados) {
        $cor = switch ($r.Status) {
            "VERDE"    { "Green"  }
            "AMARELO"  { "Yellow" }
            "VERMELHO" { "Red"    }
            default    { "White"  }
        }
        Write-Host "  [$($r.Status.PadRight(8))] $($r.Arquivo): $($r.Detalhe)" -ForegroundColor $cor
    }
    Write-Host ""
}

if ($temVermelho) {
    $vermelhos = $resultados | Where-Object { $_.Status -eq "VERMELHO" }
    Write-Host "[GATE 0.5 BLOQUEADO] $($vermelhos.Count) arquivo(s) com VERMELHO. Corrigir antes de gerar PAINEL/CONTEXTO." -ForegroundColor Red
    foreach ($v in $vermelhos) {
        Write-Host "  >> $($v.Arquivo): $($v.Detalhe)" -ForegroundColor Red
    }
    exit 1
}

$amarelos = $resultados | Where-Object { $_.Status -eq "AMARELO" }
if ($amarelos -and -not $Silent) {
    Write-Host "[GATE 0.5 AMARELO] $($amarelos.Count) item(s) com inconsistencia leve -- verificar antes de fechar sessao." -ForegroundColor Yellow
}

Write-Host "[GATE 0.5 VERDE] Todos os arquivos coerentes com Loop $loopAtual." -ForegroundColor Green
exit 0
