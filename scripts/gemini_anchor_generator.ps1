# gemini_anchor_generator.ps1
# Compila contexto atualizado para o Estrategista (Gemini)
# Previne Deficiencia 1 do Gemini: Amnesia de Contexto e Deriva
# Uso: .\scripts\gemini_anchor_generator.ps1
# Output: CONTEXTO_GEMINI.md + clipboard

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$DATA = Get-Date -Format "yyyy-MM-dd HH:mm"

function Read-Doc {
    param([string]$relativePath, [int]$max = 100)
    $full = Join-Path $BASE $relativePath
    if (-not (Test-Path $full)) { return $null }
    $lines = Get-Content $full -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($null -eq $lines) { return $null }
    if ($lines.Count -gt $max) {
        $lines = $lines[0..($max - 1)]
        $lines += "... [truncado -- ver arquivo completo]"
    }
    return ($lines -join "`n")
}

Write-Host ""
Write-Host "================================================"
Write-Host "  gemini_anchor_generator -- $DATA"
Write-Host "================================================"
Write-Host ""

$ledger  = Read-Doc "INTELLIGENCE_LEDGER.md" 120
$wip     = Read-Doc "CLIENTES\WIP_BOARD.json" 80
$proto   = Read-Doc ".claude\skills\vanguard-protocolo.md" 60

# Memoria mais recente de qualquer cliente
$memoriaRecente = Get-ChildItem "$BASE\CLIENTES" -Filter "MEMORIA*.md" -Recurse -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1

$memoria = if ($memoriaRecente) {
    Write-Host "  Memoria detectada: $($memoriaRecente.Name)"
    Get-Content $memoriaRecente.FullName -Encoding UTF8 -Raw
} else { $null }

# Ultimos 3 commits (payload dinamico — Estrategista nao recebe contexto stale)
$commits = $null
try {
    $gitLog = & git -C $BASE log --oneline -3 2>$null
    if ($gitLog) { $commits = "ULTIMOS 3 COMMITS:`n" + ($gitLog -join "`n") }
} catch {}

$sep = "`n`n" + ("=" * 80) + "`n`n"

$blocos = @()
$blocos += @"
ESTRATEGISTA -- CONTEXTO SOBERANO -- $DATA
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.
"@

if ($commits) { $blocos += "## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO`n$commits" }
if ($ledger)  { $blocos += "## INTELLIGENCE LEDGER -- PRINCIPIOS ATIVOS`n$ledger" }
if ($wip)     { $blocos += "## WIP BOARD -- ESTADO DOS PROJETOS`n$wip" }
if ($memoria) { $blocos += "## MEMORIA MAIS RECENTE`n$memoria" }
if ($proto)   { $blocos += "## PROTOCOLO VANGUARD (resumo)`n$proto" }

$output = $blocos -join $sep

# Salvar arquivo
$destFile = Join-Path $BASE "CONTEXTO_GEMINI.md"
Set-Content $destFile -Value $output -Encoding UTF8

# Copiar para clipboard
try {
    $output | Set-Clipboard
    $clipMsg = "copiado"
} catch {
    $clipMsg = "indisponivel -- use o arquivo"
}

Write-Host ""
Write-Host "Concluido:"
Write-Host "  Arquivo  : CONTEXTO_GEMINI.md ($($output.Length) chars)"
Write-Host "  Clipboard: $clipMsg"
Write-Host ""
Write-Host "Cole no inicio da sessao do Gemini antes de qualquer DIRETRIZ."
Write-Host "================================================"

# --- LISTA DE ANEXOS OBRIGATORIOS PARA O GEMINI ---
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  ANEXOS OBRIGATORIOS -- ABRIR NO GEMINI"        -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Anexe estes arquivos ao Gemini (nesta ordem):" -ForegroundColor Yellow
Write-Host ""

$anexos   = [System.Collections.ArrayList]@()
$num      = 1

# 1 — INTELLIGENCE_LEDGER
$ledgerPath = Join-Path $BASE "INTELLIGENCE_LEDGER.md"
if (Test-Path $ledgerPath) {
    Write-Host "  [$num] INTELLIGENCE_LEDGER.md" -ForegroundColor Green
    Write-Host "       $ledgerPath"
    [void]$anexos.Add($ledgerPath)
    $num++
} else {
    Write-Host "  [!!] INTELLIGENCE_LEDGER.md NAO ENCONTRADO" -ForegroundColor Red
}

# 2 — WIP_BOARD
$wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
if (Test-Path $wipPath) {
    Write-Host "  [$num] WIP_BOARD.json" -ForegroundColor Green
    Write-Host "       $wipPath"
    [void]$anexos.Add($wipPath)
    $num++
} else {
    Write-Host "  [!!] WIP_BOARD.json NAO ENCONTRADO" -ForegroundColor Red
}

# Detectar projeto ativo em BUILD
$projetoAtivo = $null
if (Test-Path $wipPath) {
    try {
        $board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $projetoAtivo = @($board.board.build) | Where-Object { $_ } | Select-Object -First 1
    } catch {}
}

if ($projetoAtivo) {
    $clienteUpper = $projetoAtivo.cliente.ToUpper()
    $clienteDir   = Join-Path $BASE "CLIENTES\$clienteUpper"
    $histDir      = Join-Path $clienteDir "HISTORICO"

    # 3 — MEMORIA mais recente do projeto ativo
    $mem = Get-ChildItem $histDir -Filter "MEMORIA_V*.md" -ErrorAction SilentlyContinue |
           Sort-Object Name -Descending | Select-Object -First 1
    if ($mem) {
        Write-Host "  [$num] $($mem.Name)" -ForegroundColor Green
        Write-Host "       $($mem.FullName)"
        [void]$anexos.Add($mem.FullName)
        $num++
    } else {
        Write-Host "  [--] MEMORIA_V*.md nao encontrada em HISTORICO (normal no Loop 1)" -ForegroundColor DarkGray
    }

    # 4 — RELATORIO mais recente do projeto ativo
    $rel = Get-ChildItem $histDir -Filter "relatorio_evolutivo_V*.md" -ErrorAction SilentlyContinue |
           Sort-Object Name -Descending | Select-Object -First 1
    if ($rel) {
        Write-Host "  [$num] $($rel.Name)" -ForegroundColor Green
        Write-Host "       $($rel.FullName)"
        [void]$anexos.Add($rel.FullName)
        $num++
    } else {
        Write-Host "  [--] relatorio_evolutivo_V*.md nao encontrado (normal no Loop 1)" -ForegroundColor DarkGray
    }

    # 5 — PASSO3_GEMINI.md do projeto ativo
    $passo3 = Join-Path $clienteDir "PASSO3_GEMINI.md"
    if (Test-Path $passo3) {
        Write-Host "  [$num] PASSO3_GEMINI.md ($clienteUpper)" -ForegroundColor Green
        Write-Host "       $passo3"
        [void]$anexos.Add($passo3)
        $num++
    } else {
        Write-Host "  [!!] PASSO3_GEMINI.md NAO ENCONTRADO para $clienteUpper" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "  Projeto ativo: $($projetoAtivo.id) - $($projetoAtivo.cliente)" -ForegroundColor Cyan
    Write-Host "  Loop atual   : $($projetoAtivo.loop_atual)" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "  [!!] Nenhum projeto em BUILD detectado no WIP_BOARD." -ForegroundColor Yellow
    Write-Host "       Anexe manualmente: LEDGER + WIP + PASSO3_GEMINI do projeto." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Apos receber a DIRETRIZ do Gemini:"                              -ForegroundColor Yellow
Write-Host '  Salvar como: CLIENTES\[CLIENTE]\DIRETRIZ_GEMINI_V[N].txt'       -ForegroundColor White
Write-Host '  Depois rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente [CLIENTE]' -ForegroundColor White
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
