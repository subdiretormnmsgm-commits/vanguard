#Requires -Version 5.1
# gdrive_fresh_tracker.ps1 -- P-168/P-169 (Diretor 2026-06-16) -- rastreador de frescor
# PostToolUse no tool Bash: quando o comando rodou verify_gdrive_freshness.ps1 E a saida
# contem a assinatura VERDE ("VERDE -- Drive em dia"), grava um marcador de sessao com
# TIMESTAMP (data+hora) + perfil. E a memoria que a TRAVA DURA (gdrive_fresh_guard.ps1)
# consulta para liberar operacoes de anexacao/leitura do gdrive:vanguard.
#
# Espelha skill_tracker.ps1 (P-180). Estado por sessao:
#   .claude/state/gdrive_fresh_<session_id>.txt  (TS=<o> na 1a linha, PERFIL=<x> na 2a)
#
# FAIL-SAFE ABSOLUTO: qualquer erro -> exit 0. PostToolUse nunca bloqueia nada.

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $stdin = $raw | ConvertFrom-Json -ErrorAction SilentlyContinue
    if (-not $stdin) { exit 0 }

    $toolName = "$($stdin.tool_name)"
    if ($toolName -notlike "*Bash*") { exit 0 }

    $cmd = "$($stdin.tool_input.command)"
    if ($cmd -notmatch "verify_gdrive_freshness") { exit 0 }

    # Saida do comando (tool_response): pode ser string, objeto {stdout,...} ou aninhado.
    # Concatenar candidatos e procurar a assinatura VERDE -- robusto a formato.
    $respStr = ""
    $tr = $stdin.tool_response
    if ($null -ne $tr) {
        try { $respStr += "$tr" } catch {}
        try { if ($tr.stdout)   { $respStr += "`n$($tr.stdout)" } }   catch {}
        try { if ($tr.output)   { $respStr += "`n$($tr.output)" } }   catch {}
        try { if ($tr.stderr)   { $respStr += "`n$($tr.stderr)" } }   catch {}
        if ($respStr.Trim() -eq "") {
            try { $respStr = ($tr | ConvertTo-Json -Depth 6 -Compress) } catch {}
        }
    }
    if ($respStr -eq "") { exit 0 }

    # So grava em VERDE real (sucesso exit 0 do verify). BLOQUEIO -> nao grava.
    if ($respStr -notmatch "VERDE\s*--\s*Drive em dia") { exit 0 }

    # Perfil (informativo) -- extrair do comando: -Perfil X
    $perfil = "DESCONHECIDO"
    if ($cmd -match "-Perfil\s+([A-Za-z]+)") { $perfil = $matches[1].ToUpper() }

    $BASE = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

    $sid = "$($stdin.session_id)".Trim()
    if ($sid -eq "") { $sid = "default" }
    $sid = $sid -replace '[^a-zA-Z0-9_\-]', '_'

    $stateDir = Join-Path $BASE ".claude\state"
    if (-not (Test-Path $stateDir)) {
        New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
    }
    $stateFile = Join-Path $stateDir "gdrive_fresh_$sid.txt"

    # mtime do arquivo = momento do VERDE (data+hora) -- o que o guard usa para comparar.
    # Conteudo: TS legivel + perfil (auditoria).
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Set-Content -Path $stateFile -Value @("TS=$ts", "PERFIL=$perfil") -Encoding UTF8
} catch {}

exit 0
