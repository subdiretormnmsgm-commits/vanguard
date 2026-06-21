#Requires -Version 5.1
# rclone_secrets_guard.ps1 -- Bloqueante P-185 (anti-recorrencia P-146)
# Intercepta o tool Bash. Bloqueia "rclone sync" / "rclone copy" para destino REMOTO
# que NAO carregue o filtro de segredos (scripts/rclone_secrets_exclude.txt).
# Filosofia (igual P-180/P-181): mecanico, nunca por memoria. Falha P-185: 7 chaves foram
# empurradas ao gdrive: por syncs de arvore inteira SEM --exclude-from.
#
# REGRA:
#   - "rclone sync"  para remoto sem o filtro  -> BLOQUEIA
#   - "rclone copy"  para remoto sem o filtro  -> BLOQUEIA
#   - "rclone copyto" (subida cirurgica arquivo-a-arquivo, padrao G2) -> LIBERA sempre
#   - destino so local (sem remoto name:)      -> LIBERA
#   - comando ja contem rclone_secrets_exclude -> LIBERA
#
# REFINO achado #2 (P-185-guard-refino): a deteccao de remoto/sync/filtro agora ocorre
# DENTRO do SEGMENTO que invoca rclone -- nunca em texto livre de outro comando no mesmo
# pipeline/lista.
# ENDURECIMENTO +1 (P-185-guard-refino, 2026-06-21): um segmento e PULADO apenas quando seu
# primeiro verbo esta na DENY-LIST de verbos benignos (git, echo, printf, cat, true, :) --
# comandos que so MENCIONAM a string em texto livre, nunca executam rclone. Todo o resto e
# analisado. Escolha deliberada de deny-list (verbos benignos) em vez de allow-list (verbo
# unico 'rclone'): a allow-list deixava WRAPPERS escaparem -- 'sudo/env/command/time/nice
# rclone sync gdrive:' tem primeiro verbo != rclone e vazaria segredo (falso-negativo critico
# pego em code-review 2026-06-21). Com deny-list, o wrapper (verbo nao-benigno) volta a ser
# analisado e BLOQUEADO; o git commit -m "...rclone..." (verbo git, benigno) segue pulado.
# "git status && rclone sync gdrive:x" quebra no '&&' e o segmento rclone e analisado -> BLOQUEADO.
# LIMITE CONHECIDO (best-effort, FAIL-SAFE): o split por shell e por regex, nao respeita aspas
# nem $(...)/heredoc -- um heredoc cuja linha comece por 'rclone sync gdrive:' pode dar
# falso-POSITIVO (bloqueia a mais, nunca a menos: nao vaza segredo).
# FAIL-OPEN: qualquer erro do proprio guard -> exit 0 (nunca trava a sessao por bug interno).

function Get-FirstVerb([string]$s) {
    # Primeiro verbo do segmento, ignorando prefixos de env var (FOO=bar) e espacos.
    $t = ($s -replace '^\s+', '')
    $parts = $t -split '\s+' | Where-Object { $_ -ne '' -and $_ -notmatch '^\w+=' }
    if ($parts.Count -ge 1) { return $parts[0].ToLower() } else { return '' }
}

try {
    $stdin = $null
    $raw = [Console]::In.ReadToEnd()
    if ($raw) { $stdin = $raw | ConvertFrom-Json -ErrorAction SilentlyContinue }
    if (-not $stdin) { exit 0 }

    $cmd = ""
    if ($stdin.tool_input -and $stdin.tool_input.command) { $cmd = [string]$stdin.tool_input.command }
    if (-not $cmd) { exit 0 }

    $low = $cmd.ToLower()

    # 1. E rclone em algum ponto? Se nem aparece, libera cedo.
    if ($low -notmatch '\brclone\b') { exit 0 }

    # 2. Quebra o comando em segmentos por separadores de shell (; | || && e nova linha).
    #    Analisa SO os segmentos que de fato invocam rclone -- isola o gatilho do texto
    #    livre de outros comandos (causa raiz do falso-positivo no git commit).
    $segments = $cmd -split '[;\r\n|&]+'
    $rcloneSegs = $segments | Where-Object { $_ -match '\brclone\b' }
    if (-not $rcloneSegs) { exit 0 }

    $benignVerbs = @('git', 'echo', 'printf', 'cat', 'true', ':')
    foreach ($seg in $rcloneSegs) {
        # 2a. Pula o segmento SO se seu primeiro verbo for benigno (git/echo/printf/cat/true/:)
        #     -- esses apenas mencionam a string, nunca executam rclone. Wrappers como
        #     'sudo/env/command/time rclone sync' tem verbo nao-benigno -> continuam analisados.
        if ($benignVerbs -contains (Get-FirstVerb $seg)) { continue }

        $segLow = $seg.ToLower()

        # 2b. E operacao de ARVORE (sync/copy)? copyto fica de fora: '\bcopy\b' nao casa
        #     "copyto" porque 'copy' e 'to' sao colados (sem fronteira de palavra).
        $isTreeOp = ($segLow -match '\bsync\b') -or ($segLow -match '\bcopy\b')
        if (-not $isTreeOp) { continue }

        # 2c. Ha destino REMOTO (name:path) DENTRO deste segmento? Exclui letra de drive
        #     (C:\ = 1 char) por {2,}. (?!//) evita URL (https://). Lookbehind evita casar
        #     dentro de caminho.
        $hasRemote = $seg -match '(?<![A-Za-z0-9_/])[A-Za-z0-9_-]{2,}:(?!//)'
        if (-not $hasRemote) { continue }

        # 2d. O filtro de segredos esta presente neste segmento?
        $hasFilter = $segLow -match 'rclone_secrets_exclude'
        if ($hasFilter) { continue }

        # BLOQUEIO -- este segmento sincroniza arvore para remoto sem filtro de segredos
        $output = [PSCustomObject]@{
            decision      = "block"
            reason        = "BLOQUEADO P-185: 'rclone sync/copy' para destino remoto SEM o filtro de segredos. Adicione '--exclude-from scripts/rclone_secrets_exclude.txt' (espelha o .gitignore) antes de sincronizar a arvore. Para subida pontual de 1 arquivo use 'rclone copyto' (G2 cirurgico), que passa livre."
            systemMessage = "BLOQUEADO P-185: sync de arvore inteira ao Drive sem --exclude-from das credenciais. Sem o filtro, segredos (CHAVES_SISTEMA, n8n_config, alert_config, hermes-agent/.env) vazam para o gdrive: de terceiros. Inclua --exclude-from scripts/rclone_secrets_exclude.txt."
        } | ConvertTo-Json -Compress

        Write-Output $output
        exit 1
    }

    # Nenhum segmento rclone problematico -> libera.
    exit 0
}
catch {
    # FAIL-OPEN: bug do guard nunca pode travar uma operacao legitima.
    exit 0
}
