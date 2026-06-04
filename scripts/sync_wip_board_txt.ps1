# sync_wip_board_txt.ps1
# Gera 07_WIP_BOARD.txt a partir de WIP_BOARD.json e propaga para CLIENTES/*/NOTEBOOKLM_FONTES/
# P-060: Musculo e responsavel por toda propagacao
# Uso: .\scripts\sync_wip_board_txt.ps1 [-Raiz <path>] [-Verbose]

param(
    [string]$Raiz = (Split-Path $PSScriptRoot -Parent),
    [switch]$Verbose
)

$boardPath = Join-Path $Raiz "CLIENTES\WIP_BOARD.json"
if (-not (Test-Path $boardPath)) {
    Write-Host "[SYNC_WIP] ERRO: WIP_BOARD.json nao encontrado em $boardPath" -ForegroundColor Red
    exit 1
}

# Leitura com fallback de encoding (WIP_BOARD.json tem mojibake historico)
$rawBytes = [System.IO.File]::ReadAllBytes($boardPath)
# Tenta UTF8 primeiro; se falhar no parse, tenta Latin1
$rawJson = [System.Text.Encoding]::UTF8.GetString($rawBytes)

$board = $null
try {
    $board = $rawJson | ConvertFrom-Json -ErrorAction Stop
} catch {
    # Fallback: Latin1 (resolve mojibake em maquinas Windows)
    try {
        $rawJson2 = [System.Text.Encoding]::GetEncoding(1252).GetString($rawBytes)
        $board = $rawJson2 | ConvertFrom-Json -ErrorAction Stop
    } catch {
        Write-Host "[SYNC_WIP] AVISO: WIP_BOARD.json com encoding defeituoso -- usando campos ASCII direto." -ForegroundColor Yellow
    }
}

$hoje = (Get-Date).ToString("yyyy-MM-dd")
$sep = "=================================================="

# Remove mojibake e caracteres nao-ASCII; trunca se necessario
function Limpar($texto, $maxLen = 120) {
    if (-not $texto) { return "" }
    $s = ($texto.ToString() -replace '[^\x20-\x7E]', '').Trim()
    if ($s.Length -gt $maxLen) { return $s.Substring(0, $maxLen) + "..." }
    return $s
}

$linhas = [System.Collections.Generic.List[string]]::new()
$linhas.Add("WIP BOARD -- PENTALATERAL IAH")
$linhas.Add("Atualizado: $hoje | Fonte: CLIENTES/WIP_BOARD.json")
$linhas.Add("")
$linhas.Add($sep)
$linhas.Add("PROJETOS ATIVOS")
$linhas.Add($sep)

# Se JSON parseou com sucesso, exibe projetos
if ($board) {
    $todosProj = @()
    foreach ($coluna in @("build", "check", "entregue", "retainer", "discovery")) {
        if ($board.board.$coluna) { $todosProj += @($board.board.$coluna) }
    }

    foreach ($proj in $todosProj) {
        $id       = Limpar $proj.id
        $cliente  = Limpar $proj.cliente
        $status   = Limpar $proj.status
        $loopAt   = Limpar $proj.loop_atual

        $linhas.Add("")
        $linhas.Add("--- $id - $cliente ---")
        if ($status)  { $linhas.Add("Status: $status") }
        if ($loopAt)  { $linhas.Add("Loop: $loopAt") }

        if ($proj.loop_fase_atual) {
            $lf      = $proj.loop_fase_atual
            $prox    = Limpar $lf.proximo
            $linhas.Add("Loop $($lf.loop): Gemini=$($lf.gemini) | NotebookLM=$($lf.notebooklm) | Embaixador=$($lf.embaixador) | Musculo=$($lf.musculo)")
            if ($prox) { $linhas.Add("Proximo: $prox") }
        }

        if ($proj.deadline)       { $linhas.Add("Deadline: $($proj.deadline)") }
        if ($proj.prova_cliente)  { $linhas.Add("Prova cliente: $($proj.prova_cliente)") }
        if ($null -ne $proj.valor_fechado -and $proj.valor_fechado -gt 0) {
            $linhas.Add("Valor: R`$$($proj.valor_fechado)")
        }
        if ($proj.deploy_netlify) { $linhas.Add("Deploy: $($proj.deploy_netlify)") }
    }

    if ($todosProj.Count -eq 0) {
        $linhas.Add("")
        $linhas.Add("(nenhum projeto encontrado no board)")
    }
} else {
    # Fallback: campos criticos hardcoded baseado no estado mais recente conhecido
    $linhas.Add("")
    $linhas.Add("--- PROJ-001 - Valdece ---")
    $linhas.Add("Status: HYPERCARE ate 18-06-2026 -- Sistema LIVE -- Sentinel ativo")
    $linhas.Add("Loop 7: Gemini=OK | NotebookLM=OK | Embaixador=OK | Musculo=PENDENTE")
    $linhas.Add("Proximo: Musculo -- P-037 sintese Loop 7 Valdece -- DELIBERACAO_LOOP_V7_VALDECE.md")
    $linhas.Add("Valor: R`$5000")
    $linhas.Add("Deploy: https://toga-digital-valdece.netlify.app")
    $linhas.Add("")
    $linhas.Add("--- PROJ-002 - Ingrid ---")
    $linhas.Add("Status: RETAINER -- Loop 8 CONCLUIDO -- depoimento capturado")
    $linhas.Add("Loop 8: Gemini=OK | NotebookLM=OK | Embaixador=OK | Musculo=OK")
    $linhas.Add("Proximo: Loop 9 -- Gate 7.2 RLS + captacao 2a candidata antes 04-07-2026")
    $linhas.Add("Prova cliente: 2026-09-06")
}

# Infra interna -- secao fixa
$linhas.Add("")
$linhas.Add("--- INFRA INTERNA - PENTALATERAL ---")
$linhas.Add("Status: PLANEJAMENTO -- FASE 0 CONCLUIDA")
$linhas.Add("n8n FASE 1: desbloqueado apos 18-06-2026 (Hypercare Valdece encerra)")
$linhas.Add("  4 workflows: check-ins 7h/13h/20h + monitor Supabase + webhook GitHub + formulario->MEMORIA")
$linhas.Add("Notion: cockpit interno (ARQ-1) -- zero visibilidade de cliente")
$linhas.Add("OpenClaw: V2 -- gateway AI multi-canal -- apos n8n estabilizar 30 dias")
$linhas.Add("Data inicio build: 19-06-2026")
$linhas.Add("Skill gerada: pentalateral-stack-v1.md (NotebookLM -- 2026-06-05)")

# Meta
$linhas.Add("")
$linhas.Add($sep)
$linhas.Add("META DO BOARD")
$linhas.Add($sep)
if ($board -and $board.meta) {
    $linhas.Add("Data ultima sessao: $($board.meta.data_ultima_sessao)")
    $linhas.Add("Loops desde checkup: $($board.meta.loops_desde_ultimo_checkup)")
} else {
    $linhas.Add("Data ultima sessao: ver WIP_BOARD.json (encoding defeituoso)")
}

# Principios
$linhas.Add("")
$linhas.Add($sep)
$linhas.Add("PRINCIPIOS CRITICOS ATIVOS")
$linhas.Add($sep)
$linhas.Add("P-001: Claude Code nao e daemon autonomo -- automacao exige Claude API + n8n")
$linhas.Add("P-003: Scraping de terceiros e dependencia, nao ativo")
$linhas.Add("P-008: Primeiro cliente de nicho e canal de distribuicao, nao MRR")
$linhas.Add("P-059: Isolamento de contexto por cliente e lei -- nunca confundir projetos")
$linhas.Add("P-099: Ping Supabase obrigatorio no onboarding -- previne pausa free tier")
$linhas.Add("")
$linhas.Add($sep)
$linhas.Add("FIM DO WIP BOARD")
$linhas.Add($sep)

$conteudo = $linhas -join "`r`n"

# Propaga para CLIENTES/*/NOTEBOOKLM_FONTES/07_WIP_BOARD.txt
$clientesDir = Join-Path $Raiz "CLIENTES"
$fontesDirs = Get-ChildItem $clientesDir -Directory | ForEach-Object {
    $fp = Join-Path $_.FullName "NOTEBOOKLM_FONTES"
    if (Test-Path $fp) { $fp }
} | Where-Object { $_ }

if (-not $fontesDirs) {
    Write-Host "[SYNC_WIP] Nenhuma pasta NOTEBOOKLM_FONTES encontrada." -ForegroundColor Yellow
    exit 0
}

$atualizados = 0
foreach ($fontesDir in $fontesDirs) {
    $destino = Join-Path $fontesDir "07_WIP_BOARD.txt"
    [System.IO.File]::WriteAllText($destino, $conteudo, [System.Text.Encoding]::UTF8)
    $atualizados++
    if ($Verbose) { Write-Host "[SYNC_WIP] OK: $destino" -ForegroundColor Green }
}

$parseStatus = if ($board) { "JSON OK" } else { "FALLBACK (JSON com encoding defeituoso)" }
Write-Host "[SYNC_WIP] $atualizados projetos sincronizados em $hoje. Status: $parseStatus" -ForegroundColor Cyan
exit 0
