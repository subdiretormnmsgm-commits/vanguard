#Requires -Version 5.1
# skill_gate_prompt.ps1 -- P-180 (FALHA-PROCESSO-2026-06-16) -- IMPERATIVO NO GATILHO VERBAL
# UserPromptSubmit: quando o Diretor usa uma palavra-gatilho de etapa, injeta um
# imperativo direcionado IMEDIATAMENTE antes da resposta do Musculo aquela mensagem.
# Pega o gatilho cedo (antes da acao). Complementa a TRAVA DURA (skill_gate_guard).
#
# Nao bloqueia o prompt. So injeta contexto (hookSpecificOutput.additionalContext).
# FAIL-SAFE: qualquer erro -> exit 0 sem injetar nada.
#
# Fonte de verdade: scripts/skill_gatilhos_map.json -> etapas[].gatilhos + skill_obrigatoria

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $stdin = $raw | ConvertFrom-Json -ErrorAction SilentlyContinue
    if (-not $stdin) { exit 0 }

    $prompt = "$($stdin.prompt)"
    if ($prompt.Trim() -eq "") { exit 0 }
    $txt = $prompt.ToLower()

    $BASE    = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $mapPath = Join-Path $BASE "scripts\skill_gatilhos_map.json"
    if (-not (Test-Path $mapPath)) { exit 0 }

    $map = Get-Content $mapPath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction SilentlyContinue
    if (-not $map -or -not $map.etapas) { exit 0 }

    $casaram = @()
    foreach ($e in @($map.etapas)) {
        foreach ($g in @($e.gatilhos)) {
            if ($txt -like "*$($g.ToLower())*") { $casaram += $e; break }
        }
    }
    if ($casaram.Count -eq 0) { exit 0 }

    $linhas = @()
    $linhas += ">>> GATILHO DE ETAPA DETECTADO (P-180) -- skill por gatilho mecanico, nunca por memoria (DEF-M-6)."
    foreach ($e in $casaram) {
        $dep = if ($e.dependencia) { " (dep: $($e.dependencia))" } else { "" }
        # skills da etapa: skill_obrigatoria (unica) + skills_obrigatorias (lista)
        $skills = @()
        if ("$($e.skill_obrigatoria)".Trim() -ne "") { $skills += "$($e.skill_obrigatoria)".Trim() }
        if ($e.skills_obrigatorias) {
            foreach ($s in @($e.skills_obrigatorias)) { if ("$s".Trim() -ne "") { $skills += "$s".Trim() } }
        }
        $listaSkills = ($skills -join "', '")
        $plural = if ($skills.Count -gt 1) { "as skills" } else { "a skill" }
        $linhas += ""
        $linhas += "[$($e.etapa)] SKILL(S) OBRIGATORIA(S): '$listaSkills'$dep"
        $linhas += "  INVOQUE $plural AGORA (tool Skill) ANTES de qualquer acao ou resposta desta etapa."
        if ($e.nota_extra) { $linhas += "  NOTA: $($e.nota_extra)" }
        $linhas += "  Acao: $($e.acao)"
        $linhas += "  Se pular: $($e.falha_se_pular)"
    }
    $linhas += ""
    $linhas += "A TRAVA DURA (PreToolUse) vai NEGAR a acao da etapa se a skill nao estiver invocada."
    $contexto = $linhas -join "`n"

    $output = [PSCustomObject]@{
        hookSpecificOutput = [PSCustomObject]@{
            hookEventName     = "UserPromptSubmit"
            additionalContext = $contexto
        }
    } | ConvertTo-Json -Depth 5 -Compress

    Write-Output $output
    exit 0
} catch {
    exit 0
}
