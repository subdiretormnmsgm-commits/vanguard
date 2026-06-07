#Requires -Version 5.1
# sync_ficou_no_ar.ps1 -- converte itens de "8. FICOU NO AR" do CONTEXTO em [ ] no PENDENTES.md
# Chamado automaticamente pelo session_close.ps1
# Garante que nada no "ficou no ar" seja esquecido entre sessoes

param(
    [string]$DataContexto = "",
    [switch]$DryRun
)

$BASE     = Split-Path $PSScriptRoot -Parent
$DATA     = if ($DataContexto) { $DataContexto } else { Get-Date -Format "yyyy-MM-dd" }
$CONTEXTO = "$BASE\PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$DATA.md"
$PENDENTES = "$BASE\PENDENTES.md"

if (-not (Test-Path $CONTEXTO)) {
    Write-Host "  [ficou-no-ar] CONTEXTO_$DATA.md nao encontrado -- skip" -ForegroundColor DarkGray
    exit 0
}

if (-not (Test-Path $PENDENTES)) {
    Write-Host "  [ficou-no-ar] PENDENTES.md nao encontrado -- skip" -ForegroundColor DarkGray
    exit 0
}

# Ler secao "8. FICOU NO AR" do CONTEXTO
$linhas = Get-Content $CONTEXTO -Encoding UTF8
$emSecao = $false
$itens = @()

foreach ($linha in $linhas) {
    if ($linha -match '^#+\s*(8\.|FICOU NO AR)') {
        $emSecao = $true
        continue
    }
    if ($emSecao -and $linha -match '^#+\s+\d+\.') {
        break  # proxima secao
    }
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

# Ler PENDENTES.md para verificar duplicatas
$pendContent = Get-Content $PENDENTES -Encoding UTF8 -Raw

$novos = @()
foreach ($item in $itens) {
    # Verificar se ja existe (match parcial nos primeiros 40 chars)
    $chave = $item.Substring(0, [Math]::Min(40, $item.Length))
    if ($pendContent -notmatch [regex]::Escape($chave.Substring(0, [Math]::Min(20, $chave.Length)))) {
        $novos += $item
    }
}

if ($novos.Count -eq 0) {
    Write-Host "  [ficou-no-ar] Todos os itens ja estao no PENDENTES.md" -ForegroundColor DarkGray
    exit 0
}

Write-Host ""
Write-Host "  [ficou-no-ar] $($novos.Count) item(ns) de 'FICOU NO AR' nao registrados -- adicionando ao PENDENTES.md:" -ForegroundColor Yellow

# Montar bloco de novos pendentes
$bloco = "`n## Ficou no Ar -- $DATA (gerado automaticamente)`n"
foreach ($item in $novos) {
    # Detectar responsavel pela keyword
    $resp = if ($item -match '\[musculo\]|\bMusculo\b|Skill|script|build|codigo') { ' [musculo]' } `
            elseif ($item -match '\[diretor\]|\bDiretor\b|\bEduardo\b|WhatsApp|arrastar|manual') { ' [diretor]' } `
            else { ' [musculo]' }

    $linha = "- [ ] `"$DATA`" **$item**$resp"
    $bloco += "$linha`n"
    Write-Host "    + $item$resp" -ForegroundColor Cyan
}

if ($DryRun) {
    Write-Host ""
    Write-Host "  [DRYRUN] Nao gravado. Bloco que seria adicionado:" -ForegroundColor DarkCyan
    Write-Host $bloco -ForegroundColor DarkCyan
    exit 0
}

# Inserir antes da primeira linha de tarefas abertas (ou no topo apos o cabecalho)
$pendLines = Get-Content $PENDENTES -Encoding UTF8
$insertIdx = -1
for ($i = 0; $i -lt $pendLines.Count; $i++) {
    if ($pendLines[$i] -match '^\- \[ \]') {
        $insertIdx = $i
        break
    }
}

if ($insertIdx -ge 0) {
    $before = $pendLines[0..($insertIdx-1)] -join "`n"
    $after  = $pendLines[$insertIdx..($pendLines.Count-1)] -join "`n"
    $novo   = $before + "`n" + $bloco + "`n" + $after
} else {
    $novo = ($pendLines -join "`n") + "`n" + $bloco
}

[System.IO.File]::WriteAllText($PENDENTES, $novo, [System.Text.UTF8Encoding]::new($false))

Write-Host "  [ficou-no-ar] PENDENTES.md atualizado -- $($novos.Count) item(ns) adicionados" -ForegroundColor Green
exit 0
