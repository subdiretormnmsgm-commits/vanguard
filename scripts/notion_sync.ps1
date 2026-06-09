# notion_sync.ps1 -- Outbound: estado local -> Notion (idempotente). Rodado no session_close.
# Diretor NAO administra Notion -- so escreve em Falhas/Sugestoes. Este script e 100% codigo.
# Alvos (2026-06-08):
#   PENDENTES.md          -> "Vanguard Pendentes"  (SO pendentes em aberto, por secao)
#   CLIENTES/WIP_BOARD.md -> "Vanguard WIP Board"   (espelho do board)
#   INTELLIGENCE_LEDGER.md-> "Ledger Vanguard"      (cabecalho de frescor + tail recente; 2123 linhas e inviavel espelhar)
# Regras: substitui conteudo (nao empilha); NUNCA apaga subpaginas; texto limpo (sem markdown/acentos quebrados).
# Erro SEMPRE visivel (mata o "2>$null" cego). Fallback P-110: arquivos locais sao a fonte canonica.
param([switch]$Quiet)

$ErrorActionPreference = "Stop"
$RAIZ   = Split-Path $PSScriptRoot -Parent
$CHAVES = Join-Path $RAIZ "CHAVES_SISTEMA_VANGUARD.txt"

function Log($m, $c = "White") { if (-not $Quiet) { Write-Host $m -ForegroundColor $c } }
if (-not (Test-Path $CHAVES)) { Log "[notion_sync] CHAVES ausente -- ignorado" "DarkGray"; exit 0 }

$chaves = Get-Content -Raw $CHAVES
$tok       = ([regex]'NOTION_API_TOKEN\s*=\s*(\S+)').Match($chaves).Groups[1].Value
$pgPend    = ([regex]'NOTION_PENDENTES_PAGE_ID\s*=\s*(\S+)').Match($chaves).Groups[1].Value
$pgWip     = ([regex]'NOTION_WIP_PAGE_ID\s*=\s*(\S+)').Match($chaves).Groups[1].Value
$pgLedger  = ([regex]'NOTION_LEDGER_PAGE_ID\s*=\s*(\S+)').Match($chaves).Groups[1].Value
if (-not $tok) { Log "[notion_sync] token nao encontrado em CHAVES" "Red"; exit 1 }

$h = @{ "Authorization" = "Bearer $tok"; "Notion-Version" = "2022-06-28" }

function Show-NotionError($err) {
    if ($err.Exception.Response) {
        $st = $err.Exception.Response.GetResponseStream()
        if ($st) { Log ((New-Object IO.StreamReader($st)).ReadToEnd()) "DarkRed" }
    }
}
function Invoke-NotionRetry($uri, $method, $body) {
    for ($a = 1; $a -le 3; $a++) {
        try {
            if ($body) {
                $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
                return Invoke-RestMethod -Uri $uri -Headers $h -Method $method -Body $bytes -ContentType "application/json; charset=utf-8"
            } else {
                return Invoke-RestMethod -Uri $uri -Headers $h -Method $method
            }
        } catch {
            if ($a -eq 3) { throw }
            Start-Sleep -Milliseconds (400 * $a)
        }
    }
}
function Clean($s) {
    $s = [string]$s
    $s = $s -replace '\[([^\]]+)\]\([^)]+\)', '$1'
    $s = $s -replace '\*\*', '' -replace '`', '' -replace '~~', ''
    $s = $s -replace '\s+$', ''
    return $s
}
function Esc($s) {
    if ($null -eq $s) { return '' }
    $s = [string]$s
    $s = $s.Replace('\', '\\').Replace('"', '\"')
    $s = $s -replace '[\x00-\x1F]', ' '
    if ($s.Length -gt 1900) { $s = $s.Substring(0, 1900) }
    return $s
}
function RT($t) { '[{"text":{"content":"' + (Esc $t) + '"}}]' }
function B-Head($t) { '{"object":"block","type":"heading_3","heading_3":{"rich_text":' + (RT $t) + '}}' }
function B-Para($t) { '{"object":"block","type":"paragraph","paragraph":{"rich_text":' + (RT $t) + '}}' }
function B-Todo($t, $chk) { '{"object":"block","type":"to_do","to_do":{"checked":' + ($chk.ToString().ToLower()) + ',"rich_text":' + (RT $t) + '}}' }
function B-Bullet($t) { '{"object":"block","type":"bulleted_list_item","bulleted_list_item":{"rich_text":' + (RT $t) + '}}' }

# Markdown generico -> blocos (preserva estado dos checkboxes; pula linhas vazias e tabelas-divisorias)
function Md-Blocks($lines) {
    $out = New-Object System.Collections.ArrayList
    foreach ($l in $lines) {
        $t = $l.TrimEnd()
        if ($t.Trim() -eq '') { continue }
        if ($t -match '^---+$') { [void]$out.Add('{"object":"block","type":"divider","divider":{}}'); continue }
        if ($t -match '^\|[\s:-]+\|?\s*$') { continue }   # linha separadora de tabela markdown
        if ($t -match '^#{1,6}\s+(.*)') { [void]$out.Add((B-Head (Clean $matches[1]))); continue }
        if ($t -match '^\s*[-*]\s*\[( |x|X)\]\s*(.*)') { $td = Clean $matches[2]; if (-not [string]::IsNullOrWhiteSpace($td)) { [void]$out.Add((B-Todo $td ($matches[1] -match '[xX]'))) }; continue }
        if ($t -match '^\s*[-*]\s+(.*)') { [void]$out.Add((B-Bullet (Clean $matches[1]))); continue }
        [void]$out.Add((B-Para (Clean $t)))
    }
    return $out
}

# Sincroniza uma pagina: apaga blocos de conteudo (nunca subpaginas) e reescreve em lotes de 100
function Sync-Page($pageId, $blocos, $nome) {
    if (-not $pageId) { Log "[notion_sync] $nome : page id ausente -- pulado" "DarkGray"; return $true }
    try {
        do {
            $kids = Invoke-NotionRetry "https://api.notion.com/v1/blocks/$pageId/children?page_size=100" "Get" $null
            foreach ($k in $kids.results) {
                if ($k.type -eq 'child_page' -or $k.type -eq 'child_database') { continue }
                Invoke-NotionRetry "https://api.notion.com/v1/blocks/$($k.id)" "Delete" $null | Out-Null
                Start-Sleep -Milliseconds 130
            }
        } while ($kids.has_more)
    } catch {
        Log "[notion_sync] $nome : FALHOU ao limpar -- $($_.Exception.Message)" "Red"; Show-NotionError $_; return $false
    }
    $n = 0
    for ($i = 0; $i -lt $blocos.Count; $i += 100) {
        $lote = $blocos[$i..([Math]::Min($i + 99, $blocos.Count - 1))]
        $body = '{"children":[' + ($lote -join ",") + ']}'
        try { Invoke-NotionRetry "https://api.notion.com/v1/blocks/$pageId/children" "Patch" $body | Out-Null; $n += $lote.Count }
        catch { Log "[notion_sync] $nome : FALHOU no lote $i -- $($_.Exception.Message)" "Red"; Show-NotionError $_; return $false }
    }
    Log "[notion_sync] $nome : OK -- $n blocos" "Green"; return $true
}

$ts = Get-Date -Format "yyyy-MM-dd HH:mm"
$okAll = $true

# ---- 0. PULL: reconciliar marcacoes [diretor] do Notion ANTES de reescrever (nao perder o que o Diretor marcou) ----
$pullScript = Join-Path $PSScriptRoot "notion_pendentes_pull.ps1"
if (Test-Path $pullScript) {
    $out = & powershell.exe -NonInteractive -File $pullScript 2>&1 | Out-String
    if ($out.Trim()) { Log $out.Trim() "Cyan" }
}

# ---- 1. PENDENTES (somente abertos, por secao) ----
$pend = Join-Path $RAIZ "PENDENTES.md"
if (Test-Path $pend) {
    $secoes = New-Object System.Collections.ArrayList; $cur = $null
    foreach ($l in (Get-Content $pend -Encoding UTF8)) {
        $t = $l.TrimEnd()
        if ($t -match '^#{1,6}\s+(.*)') { $cur = @{ head = (Clean $matches[1]); items = (New-Object System.Collections.ArrayList) }; [void]$secoes.Add($cur); continue }
        if ($t -match '^\s*[-*]\s*\[ \]\s*(.*)') {
            if (-not $cur) { $cur = @{ head = $null; items = (New-Object System.Collections.ArrayList) }; [void]$secoes.Add($cur) }
            $itc = Clean $matches[1]; if (-not [string]::IsNullOrWhiteSpace($itc)) { [void]$cur.items.Add($itc) }
        }
    }
    $bl = New-Object System.Collections.ArrayList
    [void]$bl.Add((B-Para "Atualizado pelo Musculo em $ts (fim de sessao) -- somente pendentes em aberto"))
    $abertos = 0
    foreach ($s in $secoes) {
        if ($s.items.Count -eq 0) { continue }
        if ($s.head) { [void]$bl.Add((B-Head $s.head)) }
        foreach ($it in $s.items) { [void]$bl.Add((B-Todo $it $false)); $abertos++ }
    }
    if ($abertos -eq 0) { [void]$bl.Add((B-Para "Nenhum pendente em aberto.")) }
    if (-not (Sync-Page $pgPend $bl "Pendentes")) { $okAll = $false }
}

# ---- 2. WIP BOARD (espelho do markdown -- UMA fonte: CLIENTES\WIP_BOARD.md; este script nunca cria .md) ----
$wipMd = Join-Path $RAIZ "CLIENTES\WIP_BOARD.md"
$wipJson = Join-Path $RAIZ "CLIENTES\WIP_BOARD.json"
if ((Test-Path $wipMd) -and (Test-Path $wipJson) -and ((Get-Item $wipJson).LastWriteTime -gt (Get-Item $wipMd).LastWriteTime)) {
    Log "[notion_sync] WIP Board : ATENCAO -- WIP_BOARD.json e mais novo que .md. Regenere o .md antes de confiar no espelho Notion." "Yellow"
}
if (Test-Path $wipMd) {
    $bl = New-Object System.Collections.ArrayList
    [void]$bl.Add((B-Para "Atualizado pelo Musculo em $ts (fim de sessao)"))
    foreach ($b in (Md-Blocks (Get-Content $wipMd -Encoding UTF8))) { [void]$bl.Add($b) }
    if (-not (Sync-Page $pgWip $bl "WIP Board")) { $okAll = $false }
}

# ---- 3. LEDGER (cabecalho de frescor + tail recente -- espelho total e inviavel: 2123 linhas) ----
$ledger = Join-Path $RAIZ "INTELLIGENCE_LEDGER.md"
if (Test-Path $ledger) {
    $todas = Get-Content $ledger -Encoding UTF8
    $tail = if ($todas.Count -gt 80) { $todas[($todas.Count - 80)..($todas.Count - 1)] } else { $todas }
    $bl = New-Object System.Collections.ArrayList
    [void]$bl.Add((B-Para "Atualizado pelo Musculo em $ts -- $($todas.Count) linhas no total. Fonte canonica completa: git/INTELLIGENCE_LEDGER.md. Abaixo, os principios mais recentes."))
    [void]$bl.Add('{"object":"block","type":"divider","divider":{}}')
    foreach ($b in (Md-Blocks $tail)) { [void]$bl.Add($b) }
    if (-not (Sync-Page $pgLedger $bl "Ledger")) { $okAll = $false }
}

if ($okAll) { Log "[notion_sync] CONCLUIDO ($ts)" "Green"; exit 0 }
else        { Log "[notion_sync] INCOMPLETO -- arquivos locais sao a fonte canonica (fallback P-110)." "Yellow"; exit 1 }
