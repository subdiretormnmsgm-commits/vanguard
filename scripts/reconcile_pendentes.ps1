#Requires -Version 5.1
# reconcile_pendentes.ps1 - P-087 fallback: detecta discrepancias PENDENTES.md vs commits recentes
# Roda no session_start como guard de seguranca -- alerta se commit recente parece ter concluido
# item aberto sem usar a tag [RESOLVE:]. Nao modifica nada -- so alerta.
# O Musculo confirma e marca manualmente se necessario.

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$raiz = Split-Path -Parent $PSScriptRoot
Push-Location $raiz

try {
    # Encontrar hash do ultimo commit de session-close como ponto de corte
    $allLog = git log --all --pretty='%H %s' 2>$null
    $lastCloseHash = $null
    foreach ($entry in @($allLog)) {
        if ($entry -match 'chore\(session-close\)') {
            $lastCloseHash = ($entry -split ' ')[0]
            break
        }
    }

    # Commits desde o ultimo session-close (fallback: 48h)
    if ($lastCloseHash) {
        $commitMsgs = @(git log "$lastCloseHash..HEAD" --pretty='%s' 2>$null)
    } else {
        $commitMsgs = @(git log '--since=48 hours ago' --pretty='%s' 2>$null)
    }

    # Filtrar commits de sistema (nao geram alertas)
    # GATE 1.6: commits com [RESOLVE:] ja estao corretamente taggeados -- excluir da verificacao
    # Apenas commits SEM [RESOLVE:] precisam ser verificados (podem ter resolvido sem taggar)
    $commitMsgs = $commitMsgs | Where-Object {
        $_ -and
        $_ -notmatch '\[AUTO-RESOLVE\]' -and
        $_ -notmatch '\[RESOLVE:' -and
        $_ -notmatch '^chore\(session-close\)' -and
        $_ -notmatch '^chore\(pendentes\)' -and
        $_ -notmatch '^docs\(' -and
        $_ -notmatch '^fix\(sync\)'
    }

    if ($commitMsgs.Count -eq 0) { exit 0 }

    # Le itens abertos do PENDENTES.md
    $pendPath = Join-Path $raiz 'PENDENTES.md'
    if (-not (Test-Path $pendPath)) { exit 0 }
    $abertos = @(Get-Content $pendPath -Encoding UTF8 |
                 Where-Object { $_ -match '^\s*-\s*\[\s*\]' })

    if ($abertos.Count -eq 0) { exit 0 }

    # Stopwords -- palavras genericas que causam falsos positivos
    $stopwords = @('feat','fix','chore','docs','test','style','refactor','build','loop',
                   'ingrid','valdece','musculo','diretor','script','arquivo','sessao',
                   'commit','update','added','remove','create','merge','branch','usando',
                   'projeto','processo','sistema','parte','antes','depois','primeiro','segundo',
                   'vanguard','pentalateral','claude','supabase','github','netlify',
                   'bloqueante','resolve','gateway','relatorio','atividade','contexto',
                   'template','preencher','checklist','artefato','delibera','executa',
                   'session','notion','telegram','workflow','embaixador','antigravity',
                   'intelligence','ledger','pendente','pendentes','wip_board','diretriz',
                   'memoria','historico','notebooklm','skill','passo5','passo3','passo7',
                   'estrategia','comercial','cliente','clientes','contato','threshold','timeout',
                   'completa','completo','artefatos','artefato','freshness','cabecalho',
                   'auditor','analise','encaixe','musculo','prospect','sugestoes','sugestao',
                   'propagacao','sincronizado','sincronizados','atualizados','atualizado')

    $alertas = [System.Collections.ArrayList]@()
    $pendVistas = [System.Collections.Hashtable]@{}

    foreach ($msg in $commitMsgs) {
        # Extrai palavras significativas (>=7 chars, nao stopwords, nao numeros puros)
        # GATE 1.6: minimo 7 chars (era 5) -- reduz falsos positivos de palavras genericas
        $words = $msg -split '[\s\-/\.\(\)\[\]:,_=+@#]' |
                 Where-Object { $_.Length -ge 7 -and $_ -notmatch '^\d+$' } |
                 Where-Object { $stopwords -notcontains $_.ToLower() }

        if ($words.Count -eq 0) { continue }

        foreach ($pend in $abertos) {
            $pendKey = $pend.Trim()
            if ($pendVistas.ContainsKey($pendKey)) { continue }

            # GATE 1.6: comparar apenas contra o TITULO em negrito -- nao contra descricao completa
            # Evita falsos positivos de palavras no contexto verboso da descricao
            $tituloNegrito = ""
            if ($pendKey -match '\*\*([^*]+)\*\*') { $tituloNegrito = $Matches[1] }
            if ([string]::IsNullOrEmpty($tituloNegrito)) { continue }

            foreach ($word in $words) {
                # GATE 1.6: word boundary -- evita "termina" matchear "determinados"
                if ($tituloNegrito -match ("\b" + [regex]::Escape($word) + "\b")) {
                    # Extrair descricao limpa do pendente
                    $desc = $tituloNegrito.Trim()
                    if ($desc.Length -gt 55) { $desc = $desc.Substring(0, 55) + '...' }

                    $alerta = "commit '$msg' | pendente: $desc"
                    [void]$alertas.Add($alerta)
                    $pendVistas[$pendKey] = $true
                    break
                }
            }
        }
    }

    if ($alertas.Count -gt 0) {
        $linhas = @(
            "PENDENTES-WATCH -- $($alertas.Count) POSSIVEL(IS) ITEM(NS) SEM MARCACAO [x] (P-087 fallback)",
            "Tag [RESOLVE:] foi omitida neste(s) commit(s). Musculo: confirmar e marcar [x] se correto."
        )
        foreach ($a in $alertas) {
            $linhas += "  [?] $a"
        }
        Write-Output ($linhas -join "`n")
        exit 2
    }

} finally {
    Pop-Location
}

exit 0
