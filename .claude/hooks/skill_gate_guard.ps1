#Requires -Version 5.1
# skill_gate_guard.ps1 -- P-180 (FALHA-PROCESSO-2026-06-16) -- TRAVA DURA
# PreToolUse: NEGA a acao que define uma etapa do processo ENQUANTO a skill
# obrigatoria daquela etapa nao tiver sido invocada NESTA sessao.
#
# Combate DEF-M-6 (Musculo Reativo): a skill deixa de depender da memoria do
# Musculo. O sistema bloqueia a acao ate a skill ser invocada. Nao e lembrete -- e trava.
#
# Fonte de verdade: scripts/skill_gatilhos_map.json -> etapas[].gatilho_acao + skill_obrigatoria
# Memoria da sessao: .claude/state/p180_skills_<session_id>.txt (escrito por skill_tracker.ps1)
#
# FAIL-OPEN ABSOLUTO: o UNICO caminho que bloqueia e certeza positiva
# (acao casa um gatilho de etapa E a skill obrigatoria nao esta no estado da sessao).
# Qualquer outra coisa -- stdin invalido, mapa ausente, excecao, duvida -- exit 0 (libera).
# Um bug neste hook NUNCA pode travar o trabalho do Musculo.

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $stdin = $raw | ConvertFrom-Json -ErrorAction SilentlyContinue
    if (-not $stdin) { exit 0 }

    $toolName = "$($stdin.tool_name)"
    if ($toolName -eq "") { exit 0 }
    $toolInput = $stdin.tool_input
    if ($null -eq $toolInput) { exit 0 }

    $BASE    = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $mapPath = Join-Path $BASE "scripts\skill_gatilhos_map.json"
    if (-not (Test-Path $mapPath)) { exit 0 }

    $map = Get-Content $mapPath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction SilentlyContinue
    if (-not $map -or -not $map.etapas) { exit 0 }

    # --- valor de um campo do tool_input por nome (robusto) ---
    function Get-CampoValor($obj, $campo) {
        if ($null -eq $obj) { return "" }
        $prop = $obj.PSObject.Properties | Where-Object { $_.Name -eq $campo }
        if ($prop) { return "$($prop.Value)" }
        return ""
    }

    # --- detectar etapa pela assinatura da acao ---
    $etapaDetectada = $null
    foreach ($e in @($map.etapas)) {
        foreach ($ga in @($e.gatilho_acao)) {
            if (-not $ga) { continue }
            # tool: substring (cobre nome longo do playwright: ...__browser_navigate)
            if ($toolName -notlike "*$($ga.tool)*") { continue }
            $valor = Get-CampoValor $toolInput $ga.campo
            if ($valor -eq "") { continue }
            if ($valor -match $ga.padrao) {
                $etapaDetectada = $e
                break
            }
        }
        if ($etapaDetectada) { break }
    }

    if (-not $etapaDetectada) { exit 0 }

    # --- skills obrigatorias desta etapa (1 ou varias) ---
    # Coexistem: skill_obrigatoria (string unica) + skills_obrigatorias (lista).
    $skillsReq = @()
    if ("$($etapaDetectada.skill_obrigatoria)".Trim() -ne "") {
        $skillsReq += "$($etapaDetectada.skill_obrigatoria)".Trim().ToLower()
    }
    if ($etapaDetectada.skills_obrigatorias) {
        foreach ($s in @($etapaDetectada.skills_obrigatorias)) {
            $sn = "$s".Trim().ToLower()
            if ($sn -ne "") { $skillsReq += $sn }
        }
    }
    if ($skillsReq.Count -eq 0) { exit 0 }

    $sid = "$($stdin.session_id)".Trim()
    if ($sid -eq "") { $sid = "default" }
    $sid = $sid -replace '[^a-zA-Z0-9_\-]', '_'
    $stateFile = Join-Path $BASE ".claude\state\p180_skills_$sid.txt"

    $invocadas = @()
    if (Test-Path $stateFile) {
        $invocadas = @(Get-Content $stateFile -Encoding UTF8 -ErrorAction SilentlyContinue | ForEach-Object { "$_".Trim().ToLower() } | Where-Object { $_ -ne "" })
    }

    # quais skills obrigatorias NAO foram invocadas nesta sessao
    $faltando = @()
    foreach ($req in $skillsReq) {
        $achou = $false
        foreach ($inv in $invocadas) {
            # match por substring nos dois sentidos (ex: "embaixador-passo7" casa "embaixador-passo7-vanguard-v1")
            if ($inv -like "*$req*" -or $req -like "*$inv*") { $achou = $true; break }
        }
        if (-not $achou) { $faltando += $req }
    }

    if ($faltando.Count -eq 0) { exit 0 }

    # --- BLOQUEAR: certeza positiva ---
    $etapaNome = $etapaDetectada.etapa
    $acao      = "$($etapaDetectada.acao)"
    $falha     = "$($etapaDetectada.falha_se_pular)"
    $listaFalt = ($faltando -join "', '")
    $msg = "TRAVA P-180 [$etapaNome]: invoque a(s) skill(s) '$listaFalt' (tool Skill) ANTES desta acao. " +
           "Motivo: skill por gatilho mecanico, nunca por memoria (DEF-M-6). " +
           "Se pular: $falha Acao da etapa: $acao"

    $output = [PSCustomObject]@{
        decision      = "block"
        reason        = $msg
        systemMessage = "BLOQUEADO P-180 [$etapaNome]: skill(s) '$listaFalt' nao invocada(s) nesta sessao. Invoque-a(s) e repita a acao."
    } | ConvertTo-Json -Compress

    Write-Output $output
    exit 1
} catch {
    # Qualquer falha -> libera (fail-open). Trava nunca por bug.
    exit 0
}
