# gemini_anchor_generator.ps1
# Compila PAYLOAD COMPLETO para o Gemini: CONTEXTO + MEMORIA + RELATORIO + PASSO3
# Um arquivo, uma colagem -- zero erro de ordem.
# Uso: .\scripts\gemini_anchor_generator.ps1 [-cliente NOME]
# Output: CLIENTES\[NOME]\CONTEXTO_GEMINI.md (payload completo) + clipboard

param(
    [string]$cliente = ""
)

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

$ledger = Read-Doc "INTELLIGENCE_LEDGER.md" 120
$wip    = Read-Doc "CLIENTES\WIP_BOARD.json" 80
$proto  = Read-Doc ".claude\skills\vanguard-protocolo.md" 60

$sep = "`n`n" + ("=" * 80) + "`n`n"

# --- BLOCO 1: CABECALHO SOBERANO ---
$blocos = @()
$blocos += @"
ESTRATEGISTA -- CONTEXTO SOBERANO -- $DATA
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.
"@

# --- BLOCO 2: COMMITS RECENTES ---
try {
    $gitLog = & git -C $BASE log --oneline -3 2>$null
    if ($gitLog) { $blocos += "## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO`nULTIMOS 3 COMMITS:`n" + ($gitLog -join "`n") }
} catch {}

# --- BLOCO 3: LEDGER + WIP + PROTOCOLO ---
if ($ledger) { $blocos += "## INTELLIGENCE LEDGER -- PRINCIPIOS ATIVOS`n$ledger" }
if ($wip)    { $blocos += "## WIP BOARD -- ESTADO DOS PROJETOS`n$wip" }
if ($proto)  { $blocos += "## PROTOCOLO VANGUARD (resumo)`n$proto" }

# --- DETECTAR PROJETO ATIVO ---
$projetoAtivo = $null
$wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
if (Test-Path $wipPath) {
    try {
        $board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($cliente -ne "") {
            $projetoAtivo = @($board.board.build) | Where-Object { $_.cliente -eq $cliente } | Select-Object -First 1
            if (-not $projetoAtivo) {
                # cliente nao esta em BUILD -- criar entrada minima para gerar o payload
                $projetoAtivo = [PSCustomObject]@{ id = "MANUAL"; cliente = $cliente; loop_atual = "N/A" }
            }
        } else {
            $projetoAtivo = @($board.board.build) | Where-Object { $_ } | Select-Object -First 1
        }
    } catch {}
}

# --- BLOCO 4: MEMORIA + RELATORIO + PASSO3 DO PROJETO ATIVO ---
if ($projetoAtivo) {
    $clienteUpper = $projetoAtivo.cliente.ToUpper()
    $clienteDir   = Join-Path $BASE "CLIENTES\$clienteUpper"
    $histDir      = Join-Path $clienteDir "HISTORICO"

    Write-Host "  Projeto ativo: $($projetoAtivo.id) - $($projetoAtivo.cliente)"
    Write-Host "  Loop atual   : $($projetoAtivo.loop_atual)"
    Write-Host ""

    # P-045 GATE: artefatos do loop anterior obrigatorios antes de ir ao Gemini
    $loopNum = 0
    if ($projetoAtivo.loop_fase_atual -and $projetoAtivo.loop_fase_atual.loop) {
        try { $loopNum = [int]$projetoAtivo.loop_fase_atual.loop } catch {}
    }
    if ($loopNum -gt 1) {
        $loopAnterior = $loopNum - 1
        $memAnterior = Get-ChildItem $histDir -Filter "MEMORIA_V${loopAnterior}*.md" -ErrorAction SilentlyContinue | Select-Object -First 1
        $relAnterior = Get-ChildItem $histDir -Filter "relatorio_evolutivo_V${loopAnterior}*.md" -ErrorAction SilentlyContinue | Select-Object -First 1
        $faltando = @()
        if (-not $memAnterior) { $faltando += "MEMORIA_V${loopAnterior}_$clienteUpper.md" }
        if (-not $relAnterior) { $faltando += "relatorio_evolutivo_V${loopAnterior}_$clienteUpper.md" }
        if ($faltando.Count -gt 0) {
            Write-Host "=== P-045 GATE -- BLOQUEADO ===" -ForegroundColor Red
            Write-Host "Artefatos do Loop $loopAnterior ausentes em: $histDir" -ForegroundColor Red
            $faltando | ForEach-Object { Write-Host "  FALTANDO: $_" -ForegroundColor Yellow }
            Write-Host ""
            Write-Host "ACAO: Musculo gera MEMORIA_V${loopAnterior} + relatorio_V${loopAnterior} antes de ir ao Gemini." -ForegroundColor Yellow
            Write-Host "Loop sem fechamento = proximo loop sem contexto (P-045)." -ForegroundColor Yellow
            exit 1
        }
        Write-Host "  [P-045] Artefatos Loop $loopAnterior -- OK" -ForegroundColor Green
    }

    # MEMORIA mais recente
    $memFile = Get-ChildItem $histDir -Filter "MEMORIA_V*.md" -ErrorAction SilentlyContinue |
               Sort-Object Name -Descending | Select-Object -First 1
    if ($memFile) {
        Write-Host "  [+] $($memFile.Name)"
        $memContent = Get-Content $memFile.FullName -Encoding UTF8 -Raw
        $blocos += "## MEMORIA MAIS RECENTE -- $($memFile.Name)`n$memContent"
        $script:arq1Arrastar = $memFile.FullName
    } else {
        Write-Host "  [--] MEMORIA_V*.md nao encontrada (normal no Loop 1)"
        $script:arq1Arrastar = $null
    }

    # RELATORIO mais recente
    $relFile = Get-ChildItem $histDir -Filter "relatorio_evolutivo_V*.md" -ErrorAction SilentlyContinue |
               Sort-Object Name -Descending | Select-Object -First 1
    if ($relFile) {
        Write-Host "  [+] $($relFile.Name)"
        $relContent = Get-Content $relFile.FullName -Encoding UTF8 -Raw
        $blocos += "## RELATORIO EVOLUTIVO -- $($relFile.Name)`n$relContent"
        $script:arq2Arrastar = $relFile.FullName
    } else {
        Write-Host "  [--] relatorio_evolutivo_V*.md nao encontrado (normal no Loop 1)"
        $script:arq2Arrastar = $null
    }

    # PASSO3 -- MISSAO (sempre por ultimo)
    $passo3Path = Join-Path $clienteDir "PASSO3_GEMINI.md"
    if (Test-Path $passo3Path) {
        $passo3Content = Get-Content $passo3Path -Encoding UTF8 -Raw
        # P-GATE-PASSO3: bloqueia se MISSAO nao foi preenchida (placeholder ativo)
        if ($passo3Content -match '\[M.SCULO:') {
            Write-Host "" -ForegroundColor Red
            Write-Host "=== BLOQUEADO -- PASSO3 NAO PREENCHIDO ===" -ForegroundColor Red
            Write-Host "  PASSO3_GEMINI.md contem placeholders [MUSCULO: ...]" -ForegroundColor Red
            Write-Host "  O Musculo deve preencher a secao MISSAO antes de ir ao Gemini." -ForegroundColor Yellow
            Write-Host "  Arquivo: $passo3Path" -ForegroundColor Yellow
            Write-Host "" -ForegroundColor Red
            exit 1
        }
        Write-Host "  [+] PASSO3_GEMINI.md (MISSAO -- ultimo bloco)"
        $blocos += "## MISSAO DESTA SESSAO -- PASSO3_GEMINI ($clienteUpper)`n$passo3Content"
    } else {
        Write-Host "  [!!] PASSO3_GEMINI.md NAO ENCONTRADO para $clienteUpper" -ForegroundColor Red
    }

} else {
    # Fallback: memoria mais recente de qualquer cliente
    $memoriaRecente = Get-ChildItem "$BASE\CLIENTES" -Filter "MEMORIA*.md" -Recurse -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($memoriaRecente) {
        Write-Host "  [fallback] Memoria detectada: $($memoriaRecente.Name)"
        $memContent = Get-Content $memoriaRecente.FullName -Encoding UTF8 -Raw
        $blocos += "## MEMORIA MAIS RECENTE`n$memContent"
    }
    Write-Host ""
    Write-Host "  [!!] Nenhum projeto em BUILD no WIP_BOARD." -ForegroundColor Yellow
    Write-Host "       Adicione PASSO3_GEMINI manualmente ao final do arquivo gerado." -ForegroundColor Yellow
}

# --- GERAR ARQUIVO UNICO (por projeto) ---
$output = $blocos -join $sep

if ($projetoAtivo) {
    $clienteUpper = $projetoAtivo.cliente.ToUpper()
    $destFile = Join-Path $BASE "CLIENTES\$clienteUpper\CONTEXTO_GEMINI.md"
    $destLabel = "CLIENTES\$clienteUpper\CONTEXTO_GEMINI.md"
} else {
    $destFile = Join-Path $BASE "CONTEXTO_GEMINI.md"
    $destLabel = "CONTEXTO_GEMINI.md (raiz -- fallback sem projeto ativo)"
}
Set-Content $destFile -Value $output -Encoding UTF8

# --- COPIAR PARA CLIPBOARD ---
try {
    $output | Set-Clipboard
    $clipMsg = "copiado"
} catch {
    $clipMsg = "indisponivel -- copie o arquivo manualmente"
}

Write-Host ""
Write-Host "================================================"
Write-Host "  PAYLOAD GEMINI GERADO -- $DATA"
Write-Host "================================================"
Write-Host ""
Write-Host "  Arquivo  : $destLabel ($($output.Length) chars)"
Write-Host "  Clipboard: $clipMsg"
Write-Host ""

# Arquivos para arrastar no Gemini
$arq3Arrastar = Join-Path $BASE "PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE\04_INTELLIGENCE_LEDGER.md"
$arq4Arrastar = Join-Path $BASE "CLIENTES\WIP_BOARD.json"

Write-Host "  =============================================="
Write-Host "  PROTOCOLO GEMINI -- EXECUTAR AGORA" -ForegroundColor Cyan
Write-Host "  =============================================="
Write-Host "  [ ] 1. Ctrl+V no Gemini (payload ja no clipboard)"
Write-Host "  [ ] 2. Arrastar os 4 arquivos:"
if ($script:arq1Arrastar) { Write-Host "         -> $($script:arq1Arrastar)" -ForegroundColor Yellow } else { Write-Host "         -> [sem MEMORIA -- Loop 1]" -ForegroundColor DarkGray }
if ($script:arq2Arrastar) { Write-Host "         -> $($script:arq2Arrastar)" -ForegroundColor Yellow } else { Write-Host "         -> [sem RELATORIO -- Loop 1]" -ForegroundColor DarkGray }
Write-Host "         -> $arq3Arrastar" -ForegroundColor Yellow
Write-Host "         -> $arq4Arrastar" -ForegroundColor Yellow
Write-Host "  [ ] 3. Enviar"
Write-Host "  =============================================="
Write-Host ""

# Abrir Gemini no browser automaticamente
try {
    Start-Process "https://gemini.google.com"
    Write-Host "  Gemini aberto no browser. Cole (Ctrl+V) e arraste os arquivos." -ForegroundColor Green
} catch {
    Write-Host "  Abrir manualmente: https://gemini.google.com" -ForegroundColor Yellow
}

# RISCO A -- Atualizar loop_fase_atual.gemini = "OK" automaticamente (P-077)
if ($projetoAtivo -and $projetoAtivo.id -ne "MANUAL") {
    try {
        $wipPath2 = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
        $wipData  = Get-Content $wipPath2 -Raw -Encoding UTF8 | ConvertFrom-Json
        $proj2    = @($wipData.board.build) | Where-Object { $_.cliente -eq $projetoAtivo.cliente } | Select-Object -First 1
        if ($proj2 -and $proj2.loop_fase_atual) {
            $proj2.loop_fase_atual.gemini = "OK"
            $loopN = if ($proj2.loop_fase_atual.loop) { $proj2.loop_fase_atual.loop } else { "?" }
            $cliLow = $proj2.cliente.ToLower()
            $proj2.loop_fase_atual.proximo = "NotebookLM -- Skill $cliLow-v$loopN.md"
            $wipData | ConvertTo-Json -Depth 15 | Set-Content $wipPath2 -Encoding UTF8
            Write-Host "  [LOOP] loop_fase_atual.gemini = OK -- WIP_BOARD atualizado" -ForegroundColor Green

            # P-089 REMOVIDO DO ANCHOR: PASSO3 agora e gerado em session_close.ps1 Gate 6.5
            # Timing correto: gerado apenas quando todos os 4 socios concluem o loop
            # Fix 2026-05-29: nao sobrescrever PASSO3 ativo antes do Gemini responder
            Write-Host "  [PASSO3] Esqueleto do proximo loop gerado pelo session_close (Gate 6.5)" -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "  [WARN] Nao foi possivel atualizar loop_fase_atual.gemini: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host "================================================"
