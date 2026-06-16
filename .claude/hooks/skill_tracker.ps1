#Requires -Version 5.1
# skill_tracker.ps1 -- P-180 (FALHA-PROCESSO-2026-06-16)
# PostToolUse nos tools "Skill" e "Read": registra qual skill foi invocada NESTA sessao.
# E a memoria que a TRAVA DURA (skill_gate_guard.ps1) consulta para decidir
# se uma acao de etapa pode rodar.
#
# DOIS modos de invocacao de skill:
#   - tool Skill            -> registra tool_input.skill (ex: brainstorming, notebooklm-remote-v1)
#   - tool Read de um .md    -> SO conta para skills "read-based" declaradas em
#                              skill_gatilhos_map.json -> meta.skills_read_based (ex: ultrathink-trigger,
#                              que NAO e Skill() -- e Read('.claude/skills/ultrathink-trigger.md')).
#   SEGURANCA: Read de QUALQUER outra skill .md NAO conta -- senao ler o .md de
#   notebooklm-remote-v1 / embaixador-* burlaria a trava. Allowlist e a unica porta.
#
# Estado por sessao: .claude/state/p180_skills_<session_id>.txt (uma skill por linha, lowercase).
# FAIL-SAFE: qualquer erro -> exit 0. Este hook nunca bloqueia nada (e PostToolUse).

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $stdin = $raw | ConvertFrom-Json -ErrorAction SilentlyContinue
    if (-not $stdin) { exit 0 }

    $BASE = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

    $toolName = "$($stdin.tool_name)"
    $skill = ""

    if ($toolName -eq "Skill") {
        # Nome da skill invocada (param do tool Skill)
        $skill = "$($stdin.tool_input.skill)".Trim().ToLower()
    }
    elseif ($toolName -eq "Read") {
        # Read de skill read-based (allowlist no mapa) -- ex: ultrathink-trigger
        $fp = "$($stdin.tool_input.file_path)" -replace '\\', '/'
        if ($fp -match '/([^/]+)\.md$') {
            $cand = $matches[1].Trim().ToLower()
            $readBased = @()
            $mapPath = Join-Path $BASE "scripts\skill_gatilhos_map.json"
            if (Test-Path $mapPath) {
                try {
                    $m = Get-Content $mapPath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction SilentlyContinue
                    if ($m -and $m.meta -and $m.meta.skills_read_based) {
                        $readBased = @($m.meta.skills_read_based | ForEach-Object { "$_".Trim().ToLower() })
                    }
                } catch {}
            }
            if ($readBased -contains $cand) { $skill = $cand }
        }
    }
    else {
        exit 0
    }

    if ($skill -eq "") { exit 0 }

    # Identificar sessao
    $sid = "$($stdin.session_id)".Trim()
    if ($sid -eq "") { $sid = "default" }
    $sid = $sid -replace '[^a-zA-Z0-9_\-]', '_'

    $stateDir = Join-Path $BASE ".claude\state"
    if (-not (Test-Path $stateDir)) {
        New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
    }
    $stateFile = Join-Path $stateDir "p180_skills_$sid.txt"

    # Nao duplicar
    $jaTem = $false
    if (Test-Path $stateFile) {
        $existentes = @(Get-Content $stateFile -Encoding UTF8 -ErrorAction SilentlyContinue)
        if ($existentes -contains $skill) { $jaTem = $true }
    }
    if (-not $jaTem) {
        Add-Content -Path $stateFile -Value $skill -Encoding UTF8
    }
} catch {}

exit 0
