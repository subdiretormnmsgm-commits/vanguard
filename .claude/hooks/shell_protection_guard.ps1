#Requires -Version 5.1
# shell_protection_guard.ps1 -- Bloqueante P-184 (anti-recorrencia P-146 da brecha shell-bypass do P-098)
# Intercepta o tool Bash. Fecha a brecha: gravar/sobrescrever um arquivo PROTEGIDO via shell
# (curl -o, > redirect, tee, dd of=, mv/cp destino, Out-File/Set-Content -Path) passava POR FORA
# do file_protection_guard.ps1, que so ve Write/Edit. Mesma lista canonica (protected_paths.txt).
#
# REGRA: se o ALVO de uma escrita shell casar um caminho protegido -> BLOQUEIA, salvo se autorizado
# pela mesma .musculo_autorizacao.flag (consome) OU pelo token [VEREDITO-DIRETOR] no comando.
# So LE um arquivo protegido (cat/grep/Get-Content) nunca bloqueia -- so escrita.
# FAIL-OPEN: qualquer erro do proprio guard -> exit 0 (nunca trava a sessao por bug interno).

try {
    $stdin = $null
    $raw = [Console]::In.ReadToEnd()
    if ($raw) { $stdin = $raw | ConvertFrom-Json -ErrorAction SilentlyContinue }
    if (-not $stdin) { exit 0 }

    $cmd = ""
    if ($stdin.tool_input -and $stdin.tool_input.command) { $cmd = [string]$stdin.tool_input.command }
    if (-not $cmd) { exit 0 }
    $low = $cmd.ToLower()

    $BASE = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

    # Lista canonica (compartilhada com file_protection_guard.ps1) + fallback inline (fail-safe)
    $protInline = @(
        "PASSO5_NOTEBOOKLM\.md$", "PASSO3_GEMINI\.md$", "PASSO7_EMBAIXADOR\.md$",
        "\.claude[/\\]skills[/\\].+\.md$", "PASSO3_GEMINI_TEMPLATE\.md$", "passo3_template\.txt$",
        "INTELLIGENCE_LEDGER\.md$", "DEPENDENCY_MAP\.json$", "CLAUDE\.md$"
    )
    $listaPath = Join-Path $PSScriptRoot "protected_paths.txt"
    $protegidos = $null
    if (Test-Path $listaPath) {
        try {
            $protegidos = Get-Content $listaPath -ErrorAction Stop |
                ForEach-Object { $_.Trim() } |
                Where-Object { $_ -and ($_ -notmatch '^\s*#') }
        } catch { $protegidos = $null }
    }
    if (-not $protegidos -or @($protegidos).Count -eq 0) { $protegidos = $protInline }

    # ---- Coleta de ALVOS de escrita (apenas o destino de cada construcao) ----
    $targets = New-Object System.Collections.Generic.List[string]
    function Add-Tok($t) {
        if (-not $t) { return }
        $t = $t.Trim().Trim('"').Trim("'")
        if ($t) { $script:targets.Add($t) }
    }
    $TOK = '("[^"]+"|''[^'']+''|[^\s"''|&;<>]+)'

    # 1. Redirecionamento  > arquivo  /  >> arquivo  (inclui 2> &>)
    foreach ($m in [regex]::Matches($cmd, ">>?\s*$TOK")) { Add-Tok $m.Groups[1].Value }
    # 2. curl / wget output
    foreach ($m in [regex]::Matches($cmd, "(?:^|\s)(?:-o|-O|--output|--output-document)[=\s]+$TOK")) { Add-Tok $m.Groups[1].Value }
    # 3. tee [-a] arquivo
    foreach ($m in [regex]::Matches($cmd, "(?:^|\s|\|)\s*tee\b(?:\s+-a)?\s+$TOK")) { Add-Tok $m.Groups[1].Value }
    # 4. dd of=arquivo
    foreach ($m in [regex]::Matches($cmd, "(?:^|\s)of=$TOK")) { Add-Tok $m.Groups[1].Value }
    # 5. PowerShell param-led:  -Destination / -LiteralPath / -Path / -FilePath  arquivo
    foreach ($m in [regex]::Matches($cmd, "(?i)(?:-Destination|-LiteralPath|-Path|-FilePath)\s+$TOK")) { Add-Tok $m.Groups[1].Value }
    # 6. mv / cp / Move-Item / Copy-Item -> destino = ULTIMO token posicional
    if ($low -match '\b(mv|cp|move-item|copy-item)\b') {
        $toks = [regex]::Matches($cmd, $TOK)
        if ($toks.Count -gt 0) { Add-Tok $toks[$toks.Count - 1].Groups[1].Value }
    }

    # ---- Algum alvo casa caminho protegido? ----
    $blocked = $null
    foreach ($t in $targets) {
        $n = $t -replace '\\', '/'
        foreach ($p in $protegidos) {
            if ($n -match $p) { $blocked = $t; break }
        }
        if ($blocked) { break }
    }
    if (-not $blocked) { exit 0 }

    # ---- Autorizacao: flag (consome) ou [VEREDITO-DIRETOR] no comando ----
    $leaf = ($blocked -split '[\\/]')[-1]
    $autorizado = $false
    if ($cmd -match '\[VEREDITO-DIRETOR\]') { $autorizado = $true }
    $flagPath = Join-Path $BASE ".musculo_autorizacao.flag"
    if (-not $autorizado -and (Test-Path $flagPath)) {
        $flagContent = Get-Content $flagPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        if ($flagContent -match '\*' -or ($leaf -and $flagContent -match [regex]::Escape($leaf))) {
            Remove-Item $flagPath -Force -ErrorAction SilentlyContinue
            $autorizado = $true
        }
    }
    if ($autorizado) { exit 0 }

    # ---- BLOQUEIO ----
    $output = [PSCustomObject]@{
        decision      = "block"
        reason        = "ARQUIVO PROTEGIDO via SHELL (P-184/P-098): $leaf nao pode ser sobrescrito por comando shell (curl/redirect/tee/mv/cp) sem veredito. Diga 'AUTORIZO SOBRESCREVER $leaf' (cria a flag) ou inclua [VEREDITO-DIRETOR] no comando."
        systemMessage = "BLOQUEADO P-184: gravacao shell em arquivo de processo protegido ($leaf). Esta e a brecha shell-bypass do P-098 -- exige autorizacao explicita do Diretor igual ao Write/Edit."
    } | ConvertTo-Json -Compress

    Write-Output $output
    exit 1
}
catch {
    exit 0
}
