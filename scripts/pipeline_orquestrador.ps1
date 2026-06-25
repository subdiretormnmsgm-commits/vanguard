#Requires -Version 5.1
# pipeline_orquestrador.ps1 -- Orquestrador de Pipeline por Estagio + Calendario.
# Le PIPELINE_STATE.json (estagio de cada produto) + comandos_ativacao_atores.json (grade)
# e, para a DATA de hoje (ou -Data), monta a ACAO DO DIA por produto com o comando JA PREENCHIDO
# (placeholder sem fonte em disco vira [AGUARDA: ...] -- Mandato 8, nunca inventa).
# GATE DE PAPEL (item 42): rastreia ESTAGIO mecanico, NAO decide/classifica nicho.
# P-124: read-only sobre o canonico. Detecta deriva e ALERTA; nunca escreve.
# FAIL-SAFE: qualquer erro -> exit 0 sem saida (nunca trava o session_start).
#
# Uso:
#   .\scripts\pipeline_orquestrador.ps1                 # saida humana para hoje
#   .\scripts\pipeline_orquestrador.ps1 -Data 2026-06-26
#   .\scripts\pipeline_orquestrador.ps1 -Json           # saida JSON

param(
    [string]$Data = "",
    [switch]$Json
)

try {
    if ($Data -ne "") {
        try { $hoje = [datetime]::ParseExact($Data, "yyyy-MM-dd", $null) }
        catch { if ($Json) { Write-Output "{}" }; exit 0 }
    } else {
        $hoje = Get-Date
    }
    $diaSemana = $hoje.DayOfWeek.ToString()   # Monday..Sunday
    $dataFmt   = $hoje.ToString("dd-MM-yyyy")

    $raiz      = Split-Path $PSScriptRoot -Parent
    $statePath = Join-Path $raiz "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PIPELINE_STATE.json"
    $gradePath = Join-Path $PSScriptRoot "comandos_ativacao_atores.json"

    if (-not (Test-Path $statePath) -or -not (Test-Path $gradePath)) { if ($Json) { Write-Output "{}" }; exit 0 }

    $state = Get-Content -LiteralPath $statePath -Raw -Encoding UTF8 | ConvertFrom-Json
    $grade = Get-Content -LiteralPath $gradePath -Raw -Encoding UTF8 | ConvertFrom-Json
    $agendaHoje = $grade.agenda_ativacao_manual.$diaSemana

    function Expand-Comando {
        param($template, $p)
        $t = $template
        # placeholders com fonte em disco
        $t = $t -replace '\[nicho\]',      $p.rotulo
        $t = $t -replace '\[nome/codigo\]', $p.rotulo
        $t = $t -replace '\[X\]',          $p.rotulo
        $t = $t -replace '\[referencia\]', $p.evidencia
        $t = $t -replace '\[data\]',       $p.ultima_saida_data
        # placeholders SEM fonte -> AGUARDA (Mandato 8: nunca inventar)
        $t = $t -replace '\[sinal\]',               '[AGUARDA: DELTA no _MODEL.json]'
        $t = $t -replace '\[N\]',                   '[AGUARDA: ciclos]'
        $t = $t -replace '\[quando\]',              '[AGUARDA: janela]'
        $t = $t -replace '\[LEVE/PADRAO/PESADA\]',  '[AGUARDA: tipo de deliberacao]'
        $t = $t -replace '\[deck ao cliente / audio / infografico EAP / cards p/ Digital\]', '[AGUARDA: Diretor escolhe o formato]'
        $t = $t -replace '\[resultado de campanha\]', '[AGUARDA: resultado de campo do Embaixador Digital]'
        $t = $t -replace '\[tema\]',                '[AGUARDA: tema da lacuna]'
        return $t
    }

    $resultados = @()
    foreach ($p in $state.produtos) {
        $ator   = $p.proxima_acao_ator
        $cmdKey = $p.proxima_acao_comando

        $janelaFixa = $false
        if ($agendaHoje -and $agendaHoje.$ator -and (@($agendaHoje.$ator) -contains $cmdKey)) { $janelaFixa = $true }
        # sob_gatilho so cobre embaixador_digital e projetista. Um futuro produto cujo proximo
        # ator seja executor_cowork (sem janela fixa) cai em "AGUARDA JANELA" -- ponto cego conhecido.
        $sobGatilho = [bool]($grade.sob_gatilho.$ator.$cmdKey)

        # produto retido -> mostra o que falta, nao o comando
        if ($p.retido_motivo) {
            $resultados += [ordered]@{
                produto = $p.rotulo; estagio = $p.estagio; status = "RETIDO"
                falta = $p.retido_motivo; comando = $null
            }
            continue
        }

        $tpl = $grade.comandos_canonicos.$ator.$cmdKey.texto
        $cmd = if ($tpl) { Expand-Comando $tpl $p } else { $null }

        $status = if     ($janelaFixa) { "JANELA HOJE (grade fixa)" }
                  elseif ($sobGatilho) { "SOB GATILHO (seu portao -- decide o Diretor)" }
                  else                 { "AGUARDA JANELA" }

        $resultados += [ordered]@{
            produto = $p.rotulo; estagio = $p.estagio; status = $status
            ator = $ator; comando = $cmd
        }
    }

    # -- deteccao de deriva (read-only): produto em disco fora do estado --
    $deriva = @()
    $dirCamp = Join-Path $raiz "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PROJETISTA\CAMPANHA"
    $dirPlan = Join-Path $raiz "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PROJETISTA\PLANOS"
    $rastreados = @($state.produtos | ForEach-Object { Split-Path $_.evidencia -Leaf })
    foreach ($dir in @($dirCamp, $dirPlan)) {
        if (Test-Path $dir) {
            Get-ChildItem -LiteralPath $dir -Filter *.md -File -ErrorAction SilentlyContinue | ForEach-Object {
                # so conta arquivo de PRODUTO (padrao do nome) -- ignora README/indices auxiliares
                if (($_.Name -match 'CAMPANHA|PLANO_EXECUCAO') -and ($rastreados -notcontains $_.Name)) { $deriva += $_.Name }
            }
        }
    }

    if ($Json) {
        $obj = [ordered]@{ data = $hoje.ToString("yyyy-MM-dd"); dia_semana = $diaSemana; produtos = @($resultados); deriva = @($deriva) }
        Write-Output ($obj | ConvertTo-Json -Depth 8 -Compress)
        exit 0
    }

    Write-Host ""
    Write-Host "  PIPELINE -- ACAO DO DIA POR PRODUTO  -- $dataFmt ($diaSemana)"
    Write-Host "  ============================================================================"
    Write-Host "  Estagio em disco (PIPELINE_STATE.json). Portoes 1 e 2 continuam do Diretor."
    Write-Host ""
    foreach ($r in $resultados) {
        Write-Host ("  >> {0}  [{1}]  -- {2}" -f $r.produto, $r.estagio, $r.status)
        if ($r.status -eq "RETIDO") {
            Write-Host ("     RETIDO. Falta: {0}" -f $r.falta)
        } elseif ($r.comando) {
            foreach ($ln in ($r.comando -split "`n")) { Write-Host "       $ln" }
        }
        Write-Host ""
    }
    if ($deriva.Count -gt 0) {
        Write-Host "  [DERIVA] Produto(s) em disco FORA do PIPELINE_STATE -- confirmar avanco de estagio com o Diretor (P-124):"
        foreach ($d in $deriva) { Write-Host "     -> $d" }
        Write-Host ""
    }
    exit 0
} catch {
    if ($Json) { Write-Output "{}" }
    exit 0
}
