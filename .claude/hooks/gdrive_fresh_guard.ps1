#Requires -Version 5.1
# gdrive_fresh_guard.ps1 -- P-168/P-169 (Diretor 2026-06-16) -- TRAVA DURA de frescor
# PreToolUse: NEGA browser_file_upload (anexar arquivo) e browser_navigate a superficies
# que leem do gdrive:vanguard (Embaixador/NotebookLM) ENQUANTO o Drive nao estiver
# comprovadamente fresco por DATA+HORA (P-168).
#
# Liberar exige TODAS as condicoes:
#   (a) existe marcador VERDE da sessao (gravado por gdrive_fresh_tracker.ps1)
#   (b) NENHUM arquivo monitorado foi modificado DEPOIS do VERDE (data+hora) -- P-168
#   (c) marcador dentro do teto de idade (max_age_horas)
#
# Combate DEF-M-6: o frescor do Drive deixa de depender da memoria do Musculo.
# Fonte de verdade: scripts/gdrive_fresh_gatilhos.json
# Memoria da sessao: .claude/state/gdrive_fresh_<session_id>.txt (mtime = momento do VERDE)
#
# FAIL-OPEN ABSOLUTO: o UNICO caminho que bloqueia e certeza positiva (op casa um gatilho
# E o Drive nao esta comprovadamente fresco). Qualquer outra coisa -> exit 0 (libera).

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
    $cfgPath = Join-Path $BASE "scripts\gdrive_fresh_gatilhos.json"
    if (-not (Test-Path $cfgPath)) { exit 0 }

    $cfg = Get-Content $cfgPath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction SilentlyContinue
    if (-not $cfg -or -not $cfg.operacoes) { exit 0 }

    function Get-CampoValor($obj, $campo) {
        if ($null -eq $obj -or $null -eq $campo -or "$campo" -eq "") { return "" }
        $prop = $obj.PSObject.Properties | Where-Object { $_.Name -eq $campo }
        if ($prop) { return "$($prop.Value)" }
        return ""
    }

    # --- detectar operacao que exige frescor ---
    $opDetectada = $null
    foreach ($op in @($cfg.operacoes)) {
        if (-not $op.tool) { continue }
        if ($toolName -notlike "*$($op.tool)*") { continue }
        # campo null -> casa so pelo nome do tool (ex: browser_file_upload)
        if ($null -eq $op.campo -or "$($op.campo)" -eq "") {
            $opDetectada = $op; break
        }
        $valor = Get-CampoValor $toolInput $op.campo
        if ($valor -eq "") { continue }
        if ($valor -match $op.padrao) { $opDetectada = $op; break }
    }
    if (-not $opDetectada) { exit 0 }

    # --- localizar marcador da sessao ---
    $sid = "$($stdin.session_id)".Trim()
    if ($sid -eq "") { $sid = "default" }
    $sid = $sid -replace '[^a-zA-Z0-9_\-]', '_'
    $stateFile = Join-Path $BASE ".claude\state\gdrive_fresh_$sid.txt"

    $maxAge = 12
    if ($cfg.meta -and $cfg.meta.max_age_horas) {
        try { $maxAge = [double]$cfg.meta.max_age_horas } catch { $maxAge = 12 }
    }

    $agora    = Get-Date
    $motivo   = $null

    if (-not (Test-Path $stateFile)) {
        $motivo = "Nenhum VERDE nesta sessao -- Drive nunca foi verificado."
    } else {
        $markerTS = (Get-Item $stateFile).LastWriteTime

        # (c) teto de idade
        if (($agora - $markerTS).TotalHours -gt $maxAge) {
            $motivo = "Ultimo VERDE ha mais de ${maxAge}h ($($markerTS.ToString('dd/MM HH:mm'))) -- re-verificar."
        } else {
            # (b) DATA+HORA: algum arquivo monitorado modificado APOS o VERDE?
            $newest = [datetime]::MinValue
            $newestFile = ""
            foreach ($d in @($cfg.meta.monitorados_dirs)) {
                $dp = Join-Path $BASE $d
                if (-not (Test-Path $dp)) { continue }
                Get-ChildItem -Path $dp -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
                    if ($_.LastWriteTime -gt $newest) { $newest = $_.LastWriteTime; $newestFile = $_.Name }
                }
            }
            foreach ($f in @($cfg.meta.monitorados_files)) {
                $fp = Join-Path $BASE $f
                if (-not (Test-Path $fp)) { continue }
                $mt = (Get-Item $fp).LastWriteTime
                if ($mt -gt $newest) { $newest = $mt; $newestFile = (Split-Path $fp -Leaf) }
            }
            if ($newest -gt $markerTS) {
                $motivo = "Arquivo monitorado '$newestFile' modificado $($newest.ToString('dd/MM HH:mm')) -- APOS o VERDE ($($markerTS.ToString('dd/MM HH:mm'))). Drive desatualizado (P-168 data+hora)."
            }
        }
    }

    if (-not $motivo) { exit 0 }  # Drive fresco -> libera

    # --- BLOQUEAR: certeza positiva ---
    $opNome = "$($opDetectada.nome)"
    $msg = "TRAVA DRIVE-FRESH [$opNome]: $motivo " +
           "Antes de anexar/navegar, rode: .\scripts\verify_gdrive_freshness.ps1 -Perfil <ENCERRAMENTO|VANGUARD|INGRID|VALDECE|CONSELHO> -AutoSync (ate sair VERDE). " +
           "Motivo: Embaixador/Auditor leem do gdrive:vanguard -- Drive velho = socio le doc desatualizado (P-168/P-169). Escolha o -Perfil do cliente/operacao ativa."

    $output = [PSCustomObject]@{
        decision      = "block"
        reason        = $msg
        systemMessage = "BLOQUEADO DRIVE-FRESH [$opNome]: $motivo Rode verify_gdrive_freshness -AutoSync e repita."
    } | ConvertTo-Json -Compress

    Write-Output $output
    exit 1
} catch {
    # Qualquer falha -> libera (fail-open). Trava nunca por bug.
    exit 0
}
