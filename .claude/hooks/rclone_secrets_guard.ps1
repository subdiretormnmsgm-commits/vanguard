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

    # 1. E rclone?
    if ($low -notmatch '\brclone\b') { exit 0 }

    # 2. E operacao de ARVORE (sync/copy)? copyto fica de fora: '\bcopy\b' nao casa "copyto"
    #    porque 'copy' e 'to' sao colados (sem fronteira de palavra).
    $isTreeOp = ($low -match '\bsync\b') -or ($low -match '\bcopy\b')
    if (-not $isTreeOp) { exit 0 }

    # 3. Ha destino REMOTO (name:path)? Exclui letra de drive (C:\ = 1 char) por {2,}.
    #    (?!//) evita falso positivo de URL (https://). Lookbehind evita casar dentro de caminho.
    $hasRemote = $cmd -match '(?<![A-Za-z0-9_/])[A-Za-z0-9_-]{2,}:(?!//)'
    if (-not $hasRemote) { exit 0 }

    # 4. O filtro de segredos esta presente no comando?
    $hasFilter = $low -match 'rclone_secrets_exclude'
    if ($hasFilter) { exit 0 }

    # BLOQUEIO -- sync/copy de arvore para remoto sem filtro de segredos
    $output = [PSCustomObject]@{
        decision      = "block"
        reason        = "BLOQUEADO P-185: 'rclone sync/copy' para destino remoto SEM o filtro de segredos. Adicione '--exclude-from scripts/rclone_secrets_exclude.txt' (espelha o .gitignore) antes de sincronizar a arvore. Para subida pontual de 1 arquivo use 'rclone copyto' (G2 cirurgico), que passa livre."
        systemMessage = "BLOQUEADO P-185: sync de arvore inteira ao Drive sem --exclude-from das credenciais. Sem o filtro, segredos (CHAVES_SISTEMA, n8n_config, alert_config, hermes-agent/.env) vazam para o gdrive: de terceiros. Inclua --exclude-from scripts/rclone_secrets_exclude.txt."
    } | ConvertTo-Json -Compress

    Write-Output $output
    exit 1
}
catch {
    # FAIL-OPEN: bug do guard nunca pode travar uma operacao legitima.
    exit 0
}
