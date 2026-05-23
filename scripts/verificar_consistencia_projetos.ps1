# verificar_consistencia_projetos.ps1
# Verifica consistencia da skill-alvo entre PASSO3, PASSO5 e PASSO7 de cada projeto
# Uso: .\scripts\verificar_consistencia_projetos.ps1

$raiz = Split-Path $PSScriptRoot -Parent
$clientesDir = Join-Path $raiz "CLIENTES"

$projetos = Get-ChildItem $clientesDir -Directory | Select-Object -ExpandProperty Name

function Get-SkillFromFile {
    param([string]$caminho, [string[]]$padroes)
    foreach ($p in $padroes) {
        $m = Select-String -Path $caminho -Pattern $p | Select-Object -First 1
        if ($m) {
            return $m.Matches[0].Groups[1].Value.Trim().TrimEnd('.md') -replace '\.md$', ''
        }
    }
    return $null
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  VERIFICACAO DE CONSISTENCIA -- SKILL-ALVO POR PROJETO" -ForegroundColor Cyan
Write-Host ("  " + (Get-Date -Format "yyyy-MM-dd HH:mm")) -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

$tudo_ok = $true

foreach ($projeto in $projetos) {
    $dir = Join-Path $clientesDir $projeto
    Write-Host "[$projeto]" -ForegroundColor Yellow

    # --- PASSO3 ---
    $passo3 = Join-Path $dir "PASSO3_GEMINI.md"
    $s3 = "AUSENTE"
    if (Test-Path $passo3) {
        $padroes3 = @(
            '\[NOME DA SKILL\]:\s*(\S+)',
            'Skill nomeada:\s*(\S+)',
            'Nome da skill.*?:\s*([\w-]+(?:\.md)?)'
        )
        $found = Get-SkillFromFile -caminho $passo3 -padroes $padroes3
        if (-not $found) {
            # fallback: buscar padrao tipo "ingrid-v5" ou "valdece-v7" na linha com "skill"
            $linha = Select-String -Path $passo3 -Pattern '(?i)skill[^\w]*([\w]+-v\d+)' | Select-Object -First 1
            if ($linha) { $found = $linha.Matches[0].Groups[1].Value }
        }
        if (-not $found) {
            # ultimo fallback: qualquer padrao cliente-vN.md no arquivo
            $linha2 = Select-String -Path $passo3 -Pattern '([\w]+-v\d+)\.md' | Select-Object -First 1
            if ($linha2) { $found = $linha2.Matches[0].Groups[1].Value }
        }
        if ($found) { $s3 = $found -replace '\.md$', '' } else { $s3 = "NAO DETECTADO" }
    }

    # --- PASSO5 ---
    $passo5_files = Get-ChildItem $dir -Filter 'PASSO5_NOTEBOOKLM*.md' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
    $s5 = "AUSENTE"
    $nome_passo5 = ""
    if ($passo5_files) {
        $nome_passo5 = $passo5_files[0].Name
        $passo5 = $passo5_files[0].FullName
        $linha = Select-String -Path $passo5 -Pattern '(?i)gerar a Skill ([\w-]+-v\d+)' | Select-Object -First 1
        if ($linha) {
            $s5 = $linha.Matches[0].Groups[1].Value -replace '\.md$', ''
        } else {
            $linha = Select-String -Path $passo5 -Pattern '(?i)([\w]+-v\d+)\.md' | Select-Object -First 1
            if ($linha) { $s5 = $linha.Matches[0].Groups[1].Value }
            else { $s5 = "NAO DETECTADO" }
        }
    }

    # --- PASSO7 ---
    $passo7 = Join-Path $dir "PASSO7_EMBAIXADOR.md"
    $s7 = "AUSENTE"
    $loop7 = ""
    if (Test-Path $passo7) {
        $linha_loop = Select-String -Path $passo7 -Pattern 'Loop[: ]+(\d+)' | Select-Object -First 1
        if ($linha_loop) { $loop7 = $linha_loop.Matches[0].Groups[1].Value }

        $linha = Select-String -Path $passo7 -Pattern '(?i)([\w]+-v\d+)\.md' | Select-Object -First 1
        if ($linha) { $s7 = $linha.Matches[0].Groups[1].Value } else { $s7 = "NAO DETECTADO" }
    }

    # --- Exibir ---
    $cor3 = if ($s3 -notmatch 'AUSENTE|NAO') { "Green" } else { "Red" }
    $cor5 = if ($s5 -notmatch 'AUSENTE|NAO') { "Green" } else { "Red" }
    $cor7 = if ($s7 -notmatch 'AUSENTE|NAO') { "Cyan" } else { "DarkGray" }

    Write-Host "  PASSO3 (Gemini)     : " -NoNewline; Write-Host $s3 -ForegroundColor $cor3
    $label5 = if ($nome_passo5) { "PASSO5 ($nome_passo5)" } else { "PASSO5 (NotebookLM) " }
    Write-Host "  $label5 : " -NoNewline; Write-Host $s5 -ForegroundColor $cor5
    $label7 = if ($loop7) { "PASSO7 [Loop $loop7]      " } else { "PASSO7 (Embaixador)  " }
    Write-Host "  $label7 : " -NoNewline; Write-Host $s7 -ForegroundColor $cor7

    $ok = ($s3 -eq $s5) -and ($s3 -notmatch 'AUSENTE|NAO')
    if ($ok) {
        Write-Host "  STATUS: OK -- PASSO3 e PASSO5 alinhados em [$s3]" -ForegroundColor Green
    } else {
        $tudo_ok = $false
        Write-Host "  STATUS: DIVERGENCIA -- corrigir antes de ir ao NotebookLM" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "================================================================"
if ($tudo_ok) {
    Write-Host "  TODOS OS PROJETOS: OK" -ForegroundColor Green
} else {
    Write-Host "  ATENCAO: Ha divergencias. Corrigir antes de continuar o loop." -ForegroundColor Red
}
Write-Host "================================================================"
Write-Host ""
