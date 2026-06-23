#Requires -Version 5.1
# ativacoes_do_dia.ps1 -- ATIVACOES MANUAIS DO DIA (rede de seguranca do W-11)
# FALHA-PROCESSO-2026-06-22: o W-11 (Telegram) nao avisou o Diretor das ativacoes
# manuais de segunda (Projetista triagem + Embaixador Digital radar). O Diretor nao
# OPTOU por nao acionar -- a notificacao nao chegou e ele so esteve ativo no dia 23.
#
# Esta e a 2a ponta do conserto (Diretor 2026-06-23):
#   W-11 (Telegram)  = avisa que ha ativacao hoje (abrir sessao p/ Executor Cowork;
#                      colar comando p/ Projetista/Embaixador Digital).
#   session_start    = quando o Diretor abre a sessao, LISTA as ativacoes do dia.
# Assim um Telegram perdido nunca mais esconde o que era para ser acionado.
#
# Le scripts\comandos_ativacao_atores.json -> agenda_ativacao_manual[diaDaSemana].
# Saida ASCII-safe (sem emoji/acento) por compatibilidade PS 5.1 console.
# FAIL-SAFE: qualquer erro -> exit 0 sem saida (nunca trava o session_start).

try {
    $projectDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
    $gradePath  = Join-Path $projectDir "scripts\comandos_ativacao_atores.json"
    if (-not (Test-Path $gradePath)) { exit 0 }

    $grade = Get-Content $gradePath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction SilentlyContinue
    if (-not $grade) { exit 0 }

    $hoje  = (Get-Date).DayOfWeek.ToString()   # Monday..Sunday
    $agenda = $grade.agenda_ativacao_manual.$hoje
    if (-not $agenda) { exit 0 }

    # rotulos de exibicao + verbo de acao por ator
    $atorNome = @{
        "executor_cowork"   = "EXECUTOR COWORK (Antigravity)"
        "projetista"        = "PROJETISTA (Claude Project)"
        "embaixador_digital"= "EMBAIXADOR DIGITAL (Claude Project)"
    }

    $linhas = @()
    $temAlgo = $false

    foreach ($ator in @("executor_cowork", "projetista", "embaixador_digital")) {
        $cmds = $agenda.$ator
        if (-not $cmds -or $cmds.Count -eq 0) { continue }
        $temAlgo = $true
        $nome = if ($atorNome.ContainsKey($ator)) { $atorNome[$ator] } else { $ator.ToUpper() }

        foreach ($code in $cmds) {
            $rotulo = $null
            try { $rotulo = $grade.comandos_canonicos.$ator.$code.rotulo } catch {}
            if (-not $rotulo) { $rotulo = $code }

            $linhas += "  - $nome :: $rotulo"
            if ($ator -eq "executor_cowork") {
                $linhas += "      ACAO: ABRA UMA SESSAO Claude Code -> o Musculo gera o COMANDO COWORK"
                $linhas += "            (.\scripts\ir_ao_antigravity.ps1 -papel COWORK) p/ colar no Antigravity."
            } else {
                $linhas += "      ACAO: cole o comando '$rotulo' no Claude Project do $($ator.Replace('_',' ').ToUpper())."
            }
        }
    }

    if (-not $temAlgo) { exit 0 }

    $head = @(
        "ATIVACOES MANUAIS DE HOJE ($hoje) -- grade comandos_ativacao_atores.json",
        "O W-11 (Telegram) deveria ter avisado. Esta lista e a rede de seguranca (nao depende do Telegram).",
        ""
    )
    $foot = @(
        "",
        "Fonte: scripts\comandos_ativacao_atores.json -> agenda_ativacao_manual.$hoje",
        "Se a lista acima divergir do que voce recebeu no Telegram -> FALHA-PROCESSO no W-11 (avisar)."
    )

    ($head + $linhas + $foot) -join "`n" | Write-Output
    exit 0
} catch {
    exit 0
}
