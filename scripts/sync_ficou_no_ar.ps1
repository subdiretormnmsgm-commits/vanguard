#Requires -Version 5.1
# sync_ficou_no_ar.ps1 -- converte itens de "8. FICOU NO AR" do CONTEXTO em [ ] no PENDENTES.md
# Chamado automaticamente pelo session_close.ps1
# Garante que nada no "ficou no ar" seja esquecido entre sessoes
#
# CORRECOES (2026-06-07):
#   FIX-1 Dedup por palavras-chave (3+ palavras em comum) em vez de 20 chars fixos.
#         Detecta [ ] E [x] -- evita estado contraditorio.
#   FIX-2 Cabecalho unico por data: se "## Ficou no Ar -- DATA" ja existe,
#         anexa itens ao bloco existente em vez de criar segundo cabecalho.
#   FIX-3 Auto-resolve por commits do dia: 2+ palavras-chave nos commits = item
#         provavelmente concluido -- nao adiciona ao PENDENTES.

param(
    [string]$DataContexto = "",
    [switch]$DryRun
)

$BASE      = Split-Path $PSScriptRoot -Parent
$DATA      = if ($DataContexto) { $DataContexto } else { Get-Date -Format "yyyy-MM-dd" }
$CONTEXTO  = "$BASE\PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$DATA.md"
$PENDENTES = "$BASE\PENDENTES.md"

if (-not (Test-Path $CONTEXTO)) {
    Write-Host "  [ficou-no-ar] CONTEXTO_$DATA.md nao encontrado -- skip" -ForegroundColor DarkGray
    exit 0
}
if (-not (Test-Path $PENDENTES)) {
    Write-Host "  [ficou-no-ar] PENDENTES.md nao encontrado -- skip" -ForegroundColor DarkGray
    exit 0
}

# --- Ler secao "8. FICOU NO AR" do CONTEXTO ---
$linhasCtx = Get-Content $CONTEXTO -Encoding UTF8
$emSecao   = $false
$itens     = @()
foreach ($linha in $linhasCtx) {
    if ($linha -match '^#+\s*(8\.|FICOU NO AR)') { $emSecao = $true; continue }
    if ($emSecao -and $linha -match '^#+\s+\d+\.') { break }
    if ($emSecao -and $linha -match '^\s*[-*]\s+(.+)') {
        $texto = $Matches[1].Trim()
        if ($texto -and $texto -ne '(nenhum)' -and $texto -ne '—' -and $texto -ne '-') {
            $itens += $texto
        }
    }
}
if ($itens.Count -eq 0) {
    Write-Host "  [ficou-no-ar] Nenhum item em 'FICOU NO AR' -- nada a registrar" -ForegroundColor DarkGray
    exit 0
}

# --- Ler PENDENTES.md ---
$pendLines   = @(Get-Content $PENDENTES -Encoding UTF8)
$pendContent = $pendLines -join "`n"

# Stopwords para extrair palavras-chave
$STOP = @('para','com','que','uma','por','mais','mas','nao','sem','ate','apos',
          'antes','este','esta','esse','essa','pelo','pela','todos','todas',
          'musculo','diretor','Eduardo','session','script','arquivo','bloco',
          'pendente','projeto','sistema','processo','sessao','loop')

function Get-Keywords {
    param([string]$texto)
    $palavras = $texto -split '[\s\+\-\(\)\[\]\/\\|`_\.,:;!?]' |
                Where-Object { $_.Length -gt 4 } |
                ForEach-Object { $_.ToLower() } |
                Where-Object { $STOP -notcontains $_ } |
                Select-Object -Unique
    return $palavras
}

function Test-ItemJaExiste {
    # Retorna $true se o item ja esta no PENDENTES (aberto ou fechado)
    # Criterio: 3+ palavras-chave em comum com qualquer linha de pendente
    param([string]$novoItem, [string[]]$linhasPend)
    $kwNovo = Get-Keywords -texto $novoItem
    if ($kwNovo.Count -eq 0) { return $false }
    foreach ($linha in $linhasPend) {
        if ($linha -notmatch '^\s*-\s*\[') { continue }
        $kwLinha = Get-Keywords -texto $linha
        $intersec = @($kwNovo | Where-Object { $kwLinha -contains $_ })
        if ($intersec.Count -ge 3) { return $true }
        # Fallback: primeiros 25 chars do item no texto da linha
        $chave = $novoItem.Substring(0, [Math]::Min(25, $novoItem.Length))
        if ($linha -match [regex]::Escape($chave)) { return $true }
    }
    return $false
}

# --- FIX-3: Auto-resolve por commits do dia ---
$commitsDoDia = @()
try {
    $since = "${DATA} 00:00:00"
    $commitsDoDia = @(git -C $BASE log --since="$since" --pretty=format:"%s %b" --all 2>$null)
} catch { }
$commitsJoined = $commitsDoDia -join " "

function Test-ItemConcluido {
    param([string]$texto)
    $kws = Get-Keywords -texto $texto
    if ($kws.Count -lt 2) { return $false }
    $encontradas = 0
    foreach ($k in $kws) {
        if ($script:commitsJoined -match [regex]::Escape($k)) { $encontradas++ }
    }
    return $encontradas -ge 2
}

# --- Classificar cada item ---
$novos    = @()
$jaFeitos = @()

foreach ($item in $itens) {
    if (Test-ItemJaExiste -novoItem $item -linhasPend $pendLines) {
        # ja existe como [ ] ou [x] -- ignorar
        continue
    }
    if ($commitsJoined -and (Test-ItemConcluido -texto $item)) {
        $jaFeitos += $item
    } else {
        $novos += $item
    }
}

# Relatar auto-resolvidos
if ($jaFeitos.Count -gt 0) {
    Write-Host "  [ficou-no-ar] $($jaFeitos.Count) item(ns) auto-resolvidos por commits do dia -- ignorados:" -ForegroundColor Green
    foreach ($f in $jaFeitos) { Write-Host "    [AUTO] $f" -ForegroundColor DarkGreen }
}

if ($novos.Count -eq 0) {
    if ($jaFeitos.Count -eq 0) {
        Write-Host "  [ficou-no-ar] Todos os itens ja estao no PENDENTES.md" -ForegroundColor DarkGray
    } else {
        Write-Host "  [ficou-no-ar] Nenhum pendente novo a adicionar" -ForegroundColor DarkGray
    }
    exit 0
}

Write-Host ""
Write-Host "  [ficou-no-ar] $($novos.Count) item(ns) novos a registrar no PENDENTES.md:" -ForegroundColor Yellow

# Montar linhas dos novos itens
$linhasNovas = @()
foreach ($item in $novos) {
    $resp = if ($item -match '\[musculo\]|\bMusculo\b|Skill|script|build|codigo') { ' [musculo]' } `
            elseif ($item -match '\[diretor\]|\bDiretor\b|\bEduardo\b|WhatsApp|arrastar|manual') { ' [diretor]' } `
            else { ' [musculo]' }
    $linhasNovas += "- [ ] `"$DATA`" **$item**$resp"
    Write-Host "    + $item$resp" -ForegroundColor Cyan
}

if ($DryRun) {
    Write-Host ""
    Write-Host "  [DRYRUN] Nao gravado. Linhas que seriam adicionadas:" -ForegroundColor DarkCyan
    $linhasNovas | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkCyan }
    exit 0
}

# --- FIX-2: Cabecalho unico -- verificar se ja existe para esta data ---
$cabecalhoMarca = "## Ficou no Ar -- $DATA"
$idxCabecalho  = -1
for ($i = 0; $i -lt $pendLines.Count; $i++) {
    if ($pendLines[$i] -match [regex]::Escape($cabecalhoMarca)) {
        $idxCabecalho = $i
        break
    }
}

if ($idxCabecalho -ge 0) {
    # Cabecalho ja existe -- encontrar o fim do bloco e inserir antes do proximo cabecalho ou EOF
    $idxInsert = $pendLines.Count  # default: fim do arquivo
    for ($i = $idxCabecalho + 1; $i -lt $pendLines.Count; $i++) {
        if ($pendLines[$i] -match '^##\s') {
            $idxInsert = $i
            break
        }
    }
    $resultado = @()
    $resultado += $pendLines[0..($idxInsert - 1)]
    $resultado += $linhasNovas
    $resultado += $pendLines[$idxInsert..($pendLines.Count - 1)]
    Write-Host "  [ficou-no-ar] Anexando ao bloco existente 'Ficou no Ar -- $DATA' (linha $($idxCabecalho + 1))" -ForegroundColor DarkGray
} else {
    # Cabecalho novo -- inserir antes do primeiro [ ] aberto, ou no final
    $cabecalho = @("", $cabecalhoMarca, "")
    $idxInsert = -1
    for ($i = 0; $i -lt $pendLines.Count; $i++) {
        if ($pendLines[$i] -match '^\- \[ \]') { $idxInsert = $i; break }
    }
    if ($idxInsert -ge 0) {
        $resultado  = @()
        $resultado += $pendLines[0..($idxInsert - 1)]
        $resultado += $cabecalho
        $resultado += $linhasNovas
        $resultado += $pendLines[$idxInsert..($pendLines.Count - 1)]
    } else {
        $resultado  = $pendLines + $cabecalho + $linhasNovas
    }
}

[System.IO.File]::WriteAllLines($PENDENTES, $resultado, [System.Text.UTF8Encoding]::new($false))
Write-Host "  [ficou-no-ar] PENDENTES.md atualizado -- $($novos.Count) item(ns) adicionados" -ForegroundColor Green
exit 0
