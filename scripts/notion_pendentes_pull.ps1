# notion_pendentes_pull.ps1 -- Inbound: le "Vanguard Pendentes" no Notion e quita no PENDENTES.md local.
# Canal de comunicacao do Diretor (2026-06-08): ele marca [x] no Notion durante o dia; o Musculo le na abertura.
# REGRA DE OURO: FLEXIBILIDADE SO EM ITENS [diretor]. Item [musculo] marcado no Notion -> IGNORADO + alerta
#   (esses se quitam por [RESOLVE:]/git -- P-087). Match por texto normalizado; ambiguo/sem match -> NAO quita.
# Rodado em 2 pontos: session_start (abertura) e dentro de notion_sync.ps1 (antes do push de fechamento).
# Idempotente: so olha linhas "[ ]" do PENDENTES.md; ja-quitadas nao re-disparam.

$ErrorActionPreference = "Stop"
$RAIZ   = Split-Path $PSScriptRoot -Parent
$CHAVES = Join-Path $RAIZ "CHAVES_SISTEMA_VANGUARD.txt"
$PEND   = Join-Path $RAIZ "PENDENTES.md"
if (-not (Test-Path $CHAVES) -or -not (Test-Path $PEND)) { exit 0 }

$chaves = Get-Content -Raw $CHAVES
$tok    = ([regex]'NOTION_API_TOKEN\s*=\s*(\S+)').Match($chaves).Groups[1].Value
$pgPend = ([regex]'NOTION_PENDENTES_PAGE_ID\s*=\s*(\S+)').Match($chaves).Groups[1].Value
if (-not $tok -or -not $pgPend) { exit 0 }
$h = @{ "Authorization" = "Bearer $tok"; "Notion-Version" = "2022-06-28" }

# Mesma limpeza que o notion_sync aplica ao escrever (para o texto casar)
function Clean($s) {
    $s = [string]$s
    $s = $s -replace '\[([^\]]+)\]\([^)]+\)', '$1'
    $s = $s -replace '\*\*', '' -replace '`', '' -replace '~~', ''
    $s = $s -replace '\s+$', ''
    return $s
}
function Norm($s) { (([string]$s) -replace '\s+', ' ').Trim().ToLower() }

# 1. Coletar itens MARCADOS ([x]) na pagina Notion
$checked = New-Object System.Collections.ArrayList
try {
    $cursor = $null
    do {
        $uri = "https://api.notion.com/v1/blocks/$pgPend/children?page_size=100"
        if ($cursor) { $uri += "&start_cursor=$cursor" }
        $r = Invoke-RestMethod -Uri $uri -Headers $h -Method Get -TimeoutSec 10
        foreach ($b in $r.results) {
            if ($b.type -eq 'to_do' -and $b.to_do.checked) {
                $txt = ($b.to_do.rich_text | ForEach-Object { $_.plain_text }) -join ''
                if ($txt.Trim()) { [void]$checked.Add((Norm $txt)) }
            }
        }
        $cursor = $r.next_cursor
    } while ($r.has_more)
} catch {
    Write-Output "[pull] ERRO ao ler Notion: $($_.Exception.Message) -- PENDENTES.md local intacto (fonte canonica)."
    exit 0
}
if ($checked.Count -eq 0) { exit 0 }   # silencio total se nada marcado

# 2. Mapear linhas abertas do PENDENTES.md + pre-computar as JA quitadas ([x]) para distinguir
#    "ja concluido" (silencio) de "marcado no Notion mas inexistente no PENDENTES" (alerta -- #2).
$raw   = Get-Content -Raw -Encoding UTF8 $PEND
$linhas = Get-Content -Encoding UTF8 $PEND
$quitados = New-Object System.Collections.ArrayList
$ignorados = New-Object System.Collections.ArrayList
$orfaos = New-Object System.Collections.ArrayList

$jaQuitadasNorm = New-Object System.Collections.ArrayList
foreach ($l in $linhas) {
    if ($l -match '^\s*[-*]\s*\[[xX]\]\s*(.*)') { [void]$jaQuitadasNorm.Add((Norm (Clean $matches[1]))) }
}

foreach ($chk in $checked) {
    $hits = @()
    foreach ($l in $linhas) {
        if ($l -match '^\s*[-*]\s*\[ \]\s*(.*)') {
            $conteudo = $matches[1]
            if ((Norm (Clean $conteudo)) -eq $chk) { $hits += $l }
        }
    }
    if ($hits.Count -eq 0) {
        # Nao bate com nenhuma linha aberta. Ja esta quitada [x]? -> silencio. Senao -> orfao (alerta #2).
        if ($jaQuitadasNorm -notcontains $chk) {
            [void]$orfaos.Add($chk)
        }
        continue
    }
    if ($hits.Count -gt 1) { [void]$ignorados.Add("AMBIGUO (texto repetido) -> $chk"); continue }
    $linha = $hits[0]
    if ($linha -notmatch '\[diretor\]') {                    # REGRA DE OURO: so [diretor]
        [void]$ignorados.Add("NAO-[diretor] marcado no Notion -> $($linha.Trim())")
        continue
    }
    # quitar: trocar "[ ]" por "[x]" exatamente nesta linha
    $nova = ([regex]::Replace($linha, '\[ \]', '[x]', 1))
    $raw  = $raw.Replace($linha, $nova)
    [void]$quitados.Add($linha.Trim())
}

# 3. Gravar PENDENTES.md (UTF-8 sem BOM, preservando o resto byte-a-byte)
if ($quitados.Count -gt 0) {
    [System.IO.File]::WriteAllText($PEND, $raw, (New-Object System.Text.UTF8Encoding($false)))
}

# 4. Reportar (session_start injeta isto no contexto)
if ($quitados.Count -gt 0 -or $ignorados.Count -gt 0 -or $orfaos.Count -gt 0) {
    Write-Output "=== NOTION -> PENDENTES (Diretor marcou no Notion) ==="
    if ($quitados.Count -gt 0) {
        Write-Output "QUITADOS via Notion ($($quitados.Count)) -- ja marcados [x] no PENDENTES.md:"
        $quitados | ForEach-Object { Write-Output "  [x] $_" }
    }
    if ($ignorados.Count -gt 0) {
        Write-Output "IGNORADOS ($($ignorados.Count)) -- flexibilidade e SO em [diretor]:"
        $ignorados | ForEach-Object { Write-Output "  (!) $_" }
    }
    if ($orfaos.Count -gt 0) {
        Write-Output "ORFAOS ($($orfaos.Count)) -- marcados [x] no Notion mas NAO encontrados no PENDENTES.md:"
        Write-Output "  (texto editado dos dois lados, item de outra pagina, ou ja arquivado -- Musculo deve conferir)"
        $orfaos | ForEach-Object { Write-Output "  (?) $_" }
    }
}
