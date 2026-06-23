#Requires -Version 5.1
# nicho_role_guard.ps1 -- GATE DE PAPEL (FALHA-PROCESSO-2026-06-23)
# UserPromptSubmit: quando o Diretor toca no tema NICHO/PROJECAO, injeta um
# lembrete imperativo IMEDIATAMENTE antes da resposta do Musculo -- impedindo
# que o Musculo delibere merito/classificacao/prioridade de nicho (papel do Projetista).
#
# Origem: 2026-06-23 o Musculo deliberou merito de nicho (Gate E-4, ancora AI Act,
# "projecao seria dispersao", candidatos MOVER_AGORA) -- invasao de papel.
# Diretor: "voce esta entrando numa area que nao e sua... e o Projetista, junto a mim, que decide."
#
# Nao bloqueia o prompt. So injeta contexto (hookSpecificOutput.additionalContext).
# FAIL-SAFE: qualquer erro -> exit 0 sem injetar nada.

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $stdin = $raw | ConvertFrom-Json -ErrorAction SilentlyContinue
    if (-not $stdin) { exit 0 }

    $prompt = "$($stdin.prompt)"
    if ($prompt.Trim() -eq "") { exit 0 }
    $txt = $prompt.ToLower()

    # palavras-gatilho do tema nicho/projecao
    $gatilhos = @("nicho", "projetista", "mover_agora", "mover agora", "projecao", "projeção",
                  "projetar", "fit_score", "fit score", "delta", "priorizar", "classificar nicho")

    $hit = $false
    foreach ($g in $gatilhos) { if ($txt -like "*$($g.ToLower())*") { $hit = $true; break } }
    if (-not $hit) { exit 0 }

    $linhas = @()
    $linhas += ">>> GATE DE PAPEL -- NICHO (CLAUDE.md item 42 -- FALHA-PROCESSO-2026-06-23)"
    $linhas += "O Musculo NAO decide, classifica nem prioriza nicho. Quem decide e o PROJETISTA junto ao Diretor"
    $linhas += "(SYSTEM_PROMPT_PROJETISTA v5.1, BLOCO 5: 'Voce projeta e materializa; ele decide')."
    $linhas += "SEU PAPEL ESTREITO: Musculo + Antigravity PRODUZEM material (Cowork Engine) + camada fria M-STATS"
    $linhas += "(market-stats-analysis) -> PENDING_REVIEW. O Projetista consome e decide. Projetista opera FORA de Loop."
    $linhas += "AO RESPONDER sobre nicho/ativacao de ator: de SO o fato mecanico da grade (comandos_ativacao_atores.json)"
    $linhas += "-- NUNCA o juizo de qual nicho vale, se 'tem insumo', Gate E-4, ancora, ou 'projecao seria dispersao'."
    $linhas += "Decisao de ATIVAR = Diretor. Projecao/classificacao = Projetista. Divisao: Musculo+Antigravity FAZEM ·"
    $linhas += "Diretor analisa e sobe · Projetista (com Diretor) DECIDE. Memoria: feedback_musculo_nao_decide_nicho_projetista."

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
