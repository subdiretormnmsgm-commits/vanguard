# gemini_anchor_generator.ps1  (V29 -- adaptado para o ANTIGRAVITY = Estrategista)
# Compila o CONTEXTO do Estrategista: LEDGER + WIP + MEMORIA + RELATORIO + PASSO3
# O Antigravity LE CLIENTES\[NOME]\CONTEXTO_GEMINI.md do disco via @ -- nao se cola nem se arrasta.
# Este script NAO abre mais o Gemini web (obsoleto). Mantem: compilacao + gate P-045 + WIP loop_fase.
# Uso: .\scripts\gemini_anchor_generator.ps1 [-cliente NOME]
# Output: CLIENTES\[NOME]\CONTEXTO_GEMINI.md + comando @ pronto no clipboard

param(
    [string]$cliente = "",

    # P-166: o comando ao Antigravity declara o PAPEL e cita o ARSENAL EXATO de skills (P-163).
    # ESTRATEGISTA e o papel padrao deste script (produz o CONTEXTO + PASSO3 da DIRETRIZ).
    [ValidateSet("ESTRATEGISTA","EXECUTOR","COWORK")]
    [string]$papel = "ESTRATEGISTA"
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

# LEDGER digest -- corrige o ponto cego do Estrategista (V29):
# arquivo @ inteiro (207KB) era truncado em ~800 linhas e a cauda P-116+ nunca chegava.
# Agora: cabecalho/leis + INDICE COMPLETO de principios (1 linha cada) + cauda recente integral.
$ledger = $null
$ledgerFull = Join-Path $BASE "INTELLIGENCE_LEDGER.md"
if (Test-Path $ledgerFull) {
    $allLines = @(Get-Content $ledgerFull -Encoding UTF8)
    $headEnd  = [Math]::Min(59, $allLines.Count - 1)
    $head     = ($allLines[0..$headEnd]) -join "`n"
    $indexLines = @($allLines | Where-Object { $_ -match '^#{2,3}\s*\[?P-\d+\]?' })
    $tailMatch  = $allLines | Select-String -Pattern '^#{2,3}\s*\[?P-116\]?' | Select-Object -First 1
    $tail = ""
    if ($tailMatch) { $tail = ($allLines[($tailMatch.LineNumber - 1)..($allLines.Count - 1)]) -join "`n" }
    $ledger = "### CABECALHO + LEIS SOBERANAS`n$head`n`n### INDICE COMPLETO DE PRINCIPIOS (titulos -- use para citar P-XXX corretamente)`n" + ($indexLines -join "`n") + "`n`n### PRINCIPIOS RECENTES -- TEXTO INTEGRAL (P-116 ao ultimo)`n$tail"
}
$wip    = Read-Doc "CLIENTES\WIP_BOARD.json" 80
$proto  = Read-Doc ".claude\skills\vanguard-protocolo.md" 60

$sep = "`n`n" + ("=" * 80) + "`n`n"

# --- BLOCO 0: GATE PERMANENTE -- PILARES COMPORTAMENTAIS (Loop 36+) ---
# Injetado na geracao: CONTEXTO_GEMINI.md e regerado a cada run, entao o gate vive no script.
$blocos = @()
$blocos += @"
## GATE PERMANENTE -- PILARES COMPORTAMENTAIS (vale em TODA sessao)
Fonte canonica: CONSELHO/PILARES COMPORTAMENTAIS.md · Harmonizacao Diretor 2026-06-17: "Amplitude maxima na busca, economia na entrega."
I.   PENSAR ANTES DE AGIR -- declare a premissa; pergunte se incerto; confronte quando houver razao tecnica.
II.  SIMPLICIDADE NA ENTREGA -- o minimo que resolve; sem feature alem do pedido; sem inchaco.
III. MUDANCAS CIRURGICAS -- toque so no escopo; fora do escopo -> sinalize ao Diretor, nao corrija em silencio.
IV.  META VERIFICAVEL -- criterio aferivel contra fonte/disco; iteracao termina no checkpoint do Diretor (P-124).
GATE DE FATO: dado critico (deadline, valor, versao, nome do cliente) vem de fonte/disco -- nunca de memoria. Sem confirmacao -> [NAO CONFIRMADO].
PADRAO DE QUALIDADE: toda ideia [G-1 a G-5] precisa ser CRIATIVA (nao obvia), DISRUPTIVA (muda como o mercado ve o problema, nunca em complexidade de build) e INTELIGENTE (conecta dados nao conectados -- sintese, nao listagem).
"@

# --- BLOCO 1: CABECALHO SOBERANO ---
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

# ENTREGAVEL 8 (P-052) -- MASTER em sincronia com WIP_BOARD
$masterPath8 = "$BASE\PENTALATERAL_UNIVERSAL\OPERACAO\COMANDO_ESTRATEGISTA_MASTER_v1.md"
if ((Test-Path $masterPath8) -and (Test-Path $wipPath)) {
    $wipMod8    = (Get-Item $wipPath).LastWriteTime
    $masterMod8 = (Get-Item $masterPath8).LastWriteTime
    if ($wipMod8 -gt $masterMod8) {
        $deltaH8 = [int]($wipMod8 - $masterMod8).TotalHours
        Write-Host ""
        Write-Host "  [!] COMANDO_ESTRATEGISTA_MASTER desatualizado." -ForegroundColor Yellow
        Write-Host "      WIP_BOARD modificado ha ${deltaH8}h -- MASTER pode precisar de update (P-052)." -ForegroundColor Yellow
        Write-Host "      Atualizar MASTER antes de ir ao Gemini se houve mudancas de projeto." -ForegroundColor Yellow
        Write-Host "      Arquivo: PENTALATERAL_UNIVERSAL\OPERACAO\COMANDO_ESTRATEGISTA_MASTER_v1.md" -ForegroundColor DarkGray
    }
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

Write-Host ""
Write-Host "================================================"
Write-Host "  CONTEXTO DO ESTRATEGISTA GERADO -- $DATA"
Write-Host "================================================"
Write-Host ""
Write-Host "  Arquivo: $destLabel ($($output.Length) chars)"
Write-Host "  -> Lido pelo Antigravity via @ (nao se cola nem se arrasta)"
Write-Host ""

# --- COMANDO @ PARA O ANTIGRAVITY (substitui o "arrastar 4 arquivos" do Gemini web) ---
if ($projetoAtivo) {
    $passo3Rel   = "CLIENTES/$clienteUpper/PASSO3_GEMINI.md"
    $contextoRel = "CLIENTES/$clienteUpper/CONTEXTO_GEMINI.md"
} else {
    $passo3Rel   = "CLIENTES/VANGUARD/PASSO3_GEMINI.md"
    $contextoRel = "CONTEXTO_GEMINI.md"
}

# --- P-166: PAPEL + ARSENAL EXATO (P-163) injetados no comando ao Antigravity ---
# Falha P-166: comando sem papel/arsenal = invalido. O comando gerado SEMPRE contem
# (1) "Sessao Antigravity: [PAPEL]", (2) arsenal exato na ordem, (3) nota de fronteira.
$arsenalMap = @{
    "ESTRATEGISTA" = @{
        skills    = "@concise-planning -> @brainstorming -> @architecture -> @analyze-project -> deliberacao 7 pontos"
        fronteira = "ESTRATEGISTA SUPORTA a producao da DIRETRIZ -- NUNCA a gera autonomamente (papel exclusivo do Gemini Advanced). Todo output -> PENDING_REVIEW.md; o Musculo revisa antes de qualquer acao (P-124). Papeis nao se misturam na mesma sessao."
    }
    "EXECUTOR" = @{
        skills    = "@systematic-debugging, @bash-scripting, @git-pushing, @error-detective"
        fronteira = "EXECUTOR age pelo que o Estrategista-Gemini definiu (le PASSO3_GEMINI.md + CONTEXTO_GEMINI.md do disco) -- nunca por intuicao. Output -> PENDING_REVIEW.md; Musculo revisa antes de aplicar (P-124). Papeis nao se misturam na mesma sessao."
    }
    "COWORK" = @{
        skills    = "@bash-scripting, @error-detective"
        fronteira = "COWORK CONDUCTOR conduz NICHE_MODELER (le INBOX_COWORK + BIBLIOTECA + NICHE_INDEX). COWORK != LOOP. Output -> PENDING_REVIEW.md; Musculo revisa (P-124). Papeis nao se misturam na mesma sessao."
    }
}
$pp = $arsenalMap[$papel]
$papelHeader = "Sessao Antigravity: $papel" + "`n`n" +
    "ARSENAL OBRIGATORIO (invocar nesta ordem): " + $pp.skills + "`n" +
    "@concise-planning e obrigatoria na abertura de QUALQUER papel." + "`n`n" +
    "FRONTEIRA DO PAPEL: " + $pp.fronteira

# Corpo da instrucao por papel (file refs @ lidos do disco -- nada de colar/arrastar)
switch ($papel) {
    "EXECUTOR" {
        $antigravityBody = "@$passo3Rel @$contextoRel @INTELLIGENCE_LEDGER.md`n`nVoce e o EXECUTOR do Pentalateral. Leia os arquivos acima e execute exatamente o que o Estrategista-Gemini definiu no PASSO3 -- nao gere DIRETRIZ. Grave o resultado em PENDING_REVIEW.md."
    }
    "COWORK" {
        $antigravityBody = "Voce e o COWORK CONDUCTOR. Leia INBOX_COWORK + BIBLIOTECA + NICHE_INDEX e conduza a sessao NICHE_MODELER (5 tarefas: fit_score, enriquecimento, alertas regulatorios, nichos novos, mapa de prioridade). Grave o resultado em PENDING_REVIEW.md. COWORK != LOOP."
    }
    default {
        $antigravityBody = "@$passo3Rel @$contextoRel @INTELLIGENCE_LEDGER.md`n`nVoce e o Estrategista do Pentalateral (GEMINI.md v2.0). Leia os 3 arquivos acima e gere a DIRETRIZ ESTRATEGICA no formato obrigatorio do PASSO3 (7 blocos), com [G-1 a G-5] e o bloco [PARA O NOTEBOOKLM]."
    }
}
$antigravityCmd = $papelHeader + "`n`n" + ("-" * 60) + "`n`n" + $antigravityBody

try { $antigravityCmd | Set-Clipboard; $clipMsg = "comando @ copiado" } catch { $clipMsg = "indisponivel -- copie do terminal" }

Write-Host "  =============================================="
Write-Host "  PROTOCOLO $papel (ANTIGRAVITY) -- EXECUTAR AGORA" -ForegroundColor Cyan
Write-Host "  =============================================="
Write-Host "  O Antigravity LE os arquivos do disco via @ -- nada de colar payload nem arrastar."
Write-Host "  P-166: o comando abaixo declara PAPEL + ARSENAL EXATO (P-163) + fronteira." -ForegroundColor DarkGray
Write-Host ""
Write-Host "  [ ] 1. Cole no Antigravity ($clipMsg):"
Write-Host "         $antigravityCmd" -ForegroundColor Yellow
Write-Host "  [ ] 2. Enviar -- a DIRETRIZ volta ao Musculo antes do veredito (P-124)"
Write-Host "  =============================================="
Write-Host ""

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
