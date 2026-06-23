# cowork_calendar.ps1 -- GATE DE DATA do Cowork (P-146 / Diretor 2026-06-15)
#
# NATUREZA: gestao de inteligencia de mercado da Vanguard (Claude Cowork). NAO e loop.
#
# Funcao: cruzar a DATA DE HOJE com as regras de cadencia do
#   PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\CALENDARIO_NICHE_INTELLIGENCE.md
# e dizer ao Musculo, na abertura (gate 0C), EXATAMENTE:
#   - quais tarefas Cowork M1-M7 (nicho fonografico) rodam hoje
#   - quais frentes F do ritmo semanal/quinzenal/mensal rodam hoje
#   - quais BRIEFING_MUSCULO_M[n] esperar no INBOX_COWORK
#
# REGRA (Diretor 2026-06-15): o Musculo NUNCA executa nem colhe atividade Cowork
# fora da data estipulada. A data e a unica unidade de autorizacao.
#
# Uso:
#   .\scripts\cowork_calendar.ps1                 # saida humana para hoje
#   .\scripts\cowork_calendar.ps1 -Data 2026-06-15
#   .\scripts\cowork_calendar.ps1 -Json           # saida JSON (session_start consome)

param(
    [string]$Data = "",
    [switch]$Json
)

if ($Data -ne "") {
    try { $hoje = [datetime]::ParseExact($Data, "yyyy-MM-dd", $null) }
    catch { Write-Host "Data invalida. Use yyyy-MM-dd."; exit 1 }
} else {
    $hoje = Get-Date
}

$diaSemana = $hoje.DayOfWeek          # Monday, Tuesday, ...
$diaMes    = $hoje.Day                # 1..31
$ptBR      = [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR")
$diaSemPt  = $ptBR.TextInfo.ToTitleCase($hoje.ToString("dddd", $ptBR))
$dataFmt   = $hoje.ToString("dd-MM-yyyy")

# -- Cadencia das tarefas Cowork fonograficas M1-M7 ------------------------------
# Fonte: CALENDARIO_NICHE_INTELLIGENCE.md -> secao "NICHO FONOGRAFICO (M1-M7)"
$mTasks = @(
    @{ Id = "M1"; Tema = "Radar de Artista";              Regra = "Semanal-Segunda";  Hora = "03:00" },
    @{ Id = "M2"; Tema = "Regulatorio (entretenimento)";  Regra = "Semanal-Terca";    Hora = "03:15" },
    @{ Id = "M3"; Tema = "Prospeccao de Holdings";        Regra = "Semanal-Quarta";   Hora = "03:30" },
    @{ Id = "M4"; Tema = "ECAD + Streaming";              Regra = "Quinzenal-1-15";   Hora = "03:45" },
    @{ Id = "M5"; Tema = "Mercado Fonografico";           Regra = "Mensal-1";         Hora = "04:00" },
    @{ Id = "M6"; Tema = "Licenciamento de Eventos";      Regra = "Quinzenal-8-22";   Hora = "04:15" },
    @{ Id = "M7"; Tema = "Concorrencia Musical";          Regra = "Mensal-15";        Hora = "04:30" }
)

function Test-CadenciaHoje {
    param([string]$regra)
    switch ($regra) {
        "Semanal-Segunda" { return ($diaSemana -eq "Monday") }
        "Semanal-Terca"   { return ($diaSemana -eq "Tuesday") }
        "Semanal-Quarta"  { return ($diaSemana -eq "Wednesday") }
        "Quinzenal-1-15"  { return ($diaMes -eq 1 -or $diaMes -eq 15) }
        "Mensal-1"        { return ($diaMes -eq 1) }
        "Quinzenal-8-22"  { return ($diaMes -eq 8 -or $diaMes -eq 22) }
        "Mensal-15"       { return ($diaMes -eq 15) }
        default           { return $false }
    }
}

$mHoje = @()
foreach ($t in $mTasks) {
    if (Test-CadenciaHoje $t.Regra) { $mHoje += $t }
}

# -- E-4 Burn Rate Shield gate (Loop 35) -----------------------------------------
# DRY-RUN (sem -Registrar): NAO consome orcamento. So anota, para cada tarefa M
# prevista hoje, se o custo projetado violaria o teto diario/madrugada.
# rc 0 = LIBERADO, rc 2 = BLOQUEADO, qualquer outro (incl. 1 ou shield ausente)
# = INDISPONIVEL (aviso leve, NUNCA bloqueia o proprio gate de data).
$shieldPath = Join-Path $PSScriptRoot "burn_rate_shield.ps1"
$shieldExiste = Test-Path $shieldPath
foreach ($t in $mHoje) {
    if (-not $shieldExiste) {
        $t.Orcamento = "INDISPONIVEL"
        continue
    }
    # 6>$null suprime tambem o stream Information (Write-Host do shield), senao o [BURN]
    # vaza para o stdout quando o script roda via -File (subprocesso) e polui o -Json.
    & $shieldPath -Tarefa $t.Id -Cliente "VANGUARD" 6>$null 2>&1 | Out-Null
    $rc = $LASTEXITCODE
    if     ($rc -eq 0) { $t.Orcamento = "LIBERADO" }
    elseif ($rc -eq 2) { $t.Orcamento = "BLOQUEADO" }
    else               { $t.Orcamento = "INDISPONIVEL" }
}

# -- Ritmo semanal das frentes F (inteligencia de mercado generica) --------------
# Alinhado a AGENDA VANGUARD oficial (2026-06-17): F2/F4a/F4b/F6 DESCONTINUADAS.
# F3 migrou Terca->Sexta (consolidacao); F15 migrou Sexta->Segunda; ROD adicionado a Segunda.
$fSemanal = switch ($diaSemana) {
    "Monday"    { "F1 + F12 + F15 + ROD (Radar de Dor + Tutor do Fundador + Guardiao de Dependencias + Rodizio Caca F16-F22)" }
    "Tuesday"   { "F1 (Radar de Dor -- diario)" }
    "Wednesday" { "F1 (Radar de Dor -- diario)" }
    "Thursday"  { "F1 (Radar de Dor -- diario)" }
    "Friday"    { "F1 + F3 (Radar de Dor + Cacador de Encaixe -- consolidacao semanal)" }
    default     { "F1 (Radar de Dor -- diario)" }
}

$fQuinzenal = @()
if ($diaMes -eq 1 -or $diaMes -eq 15) { $fQuinzenal += "F5 + F9 (Espelho Estrategico + Radar de Fomento)" }
$fMensal = @()
if ($diaMes -eq 1) { $fMensal += "F7 + F8 + F11 + NICHE_MODELER (enriquecimento mensal -- sessao Gemini)" }
if ($diaMes -eq 1) { $fMensal += "M-STATS (Analise Estatistica de Nicho -- skill market-stats-analysis: market sizing TAM/SAM/SOM dupla-via + tendencia c/ IC sobre o produto Vanguard; saida -> PENDING_REVIEW)" }

# -- Ativacoes MANUAIS do Diretor: Projetista (P-T) + Embaixador Digital (ED) -----
# Diretor 2026-06-17: estes atores (Claude Projects) so entregam quando o Diretor
# roda o COMANDO DE ATIVACAO. Fonte: scripts\comandos_ativacao_atores.json (preenchido
# dos 2 system prompts: Embaixador Digital v2.1 + Projetista v5.1). Categoria A = frente
# Cowork AUTOMATICA (Diretor NAO ativa); Categoria B = comando manual. So a B vira
# notificacao aqui + Telegram (W-11). Horarios da AGENDA sao teoricos; vale quando o Diretor ativa.
# A notificacao mostra o TEXTO do comando para o Diretor colar no ator com excelencia.
$ativCmdPath = Join-Path $PSScriptRoot "comandos_ativacao_atores.json"
$ativDigital    = @()   # array de @{ comando = rotulo; texto = comando completo }
$ativProjetista = @()
$ativExecutor   = @()   # executor_cowork (Antigravity COWORK) -- Categoria B, notifica (Diretor 2026-06-22)
$ativErro = $null
try {
    $jCmd  = Get-Content -LiteralPath $ativCmdPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $agDia = $jCmd.agenda_ativacao_manual.$diaSemana
    foreach ($k in @($agDia.embaixador_digital)) {
        $c = $jCmd.comandos_canonicos.embaixador_digital.$k
        if ($c) { $ativDigital += @{ comando = $c.rotulo; texto = $c.texto } }
    }
    foreach ($k in @($agDia.projetista)) {
        $c = $jCmd.comandos_canonicos.projetista.$k
        if ($c) { $ativProjetista += @{ comando = $c.rotulo; texto = $c.texto } }
    }
    foreach ($k in @($agDia.executor_cowork)) {
        $c = $jCmd.comandos_canonicos.executor_cowork.$k
        if ($c) { $ativExecutor += @{ comando = $c.rotulo; texto = $c.texto } }
    }
} catch {
    $ativErro = $_.Exception.Message
}

# -- M-STATS: check de ESTADO (independe da data) -- "e sempre bom conferir" (Diretor 2026-06-17)
# O M-STATS Passo 2 (robustecer) e downstream e NAO segue o mapa de colheita do calendario.
# Alem do disparo mensal (dia 1, ja no fMensal), varremos o PENDING_REVIEW por parecer BASE
# (Passo 1) marcado com a keyword AGUARDANDO_ROBUSTECER -- para nenhum BASE ficar sem Passo 2.
# Quem robustece: Antigravity papel EXECUTOR (skill market-stats-analysis). Disparo: Projetista
# encomenda (Acao 3 v5.1 -- mensal dia 1 + sob demanda) -> Musculo prepara COMANDO EXECUTOR.
$pendingPath = Join-Path $PSScriptRoot "..\PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PENDING_REVIEW.md"
$mstatsPendentes = @()
if (Test-Path $pendingPath) {
    $linhasPending = Get-Content -LiteralPath $pendingPath -Encoding UTF8 -ErrorAction SilentlyContinue
    foreach ($ln in $linhasPending) {
        if ($ln -match "\[M-STATS-BASE\s+AGUARDANDO_ROBUSTECER\]") { $mstatsPendentes += $ln.Trim() }
    }
}

# -- Briefings esperados no INBOX_COWORK -----------------------------------------
$briefingsEsperados = @()
foreach ($t in $mHoje) { $briefingsEsperados += "BRIEFING_MUSCULO_$($t.Id)" }

# -- Saida JSON (consumida pelo session_start) -----------------------------------
if ($Json) {
    $obj = [ordered]@{
        data                = $hoje.ToString("yyyy-MM-dd")
        dia_semana          = "$diaSemana"
        dia_mes             = $diaMes
        cowork_m_hoje       = @($mHoje | ForEach-Object { @{ id = $_.Id; tema = $_.Tema; hora = $_.Hora; orcamento = $_.Orcamento } })
        frentes_semanal     = $fSemanal
        frentes_quinzenal   = $fQuinzenal
        frentes_mensal      = $fMensal
        briefings_esperados = $briefingsEsperados
        mstats_aguardando_robustecer = @($mstatsPendentes)
        ativacoes_projetista = @($ativProjetista)
        ativacoes_digital    = @($ativDigital)
        ativacoes_executor   = @($ativExecutor)
        ativacoes_fonte_erro = $ativErro
    }
    Write-Output ($obj | ConvertTo-Json -Depth 6 -Compress)
    exit 0
}

# -- Saida humana ----------------------------------------------------------------
Write-Host ""
Write-Host "  GATE DE DATA -- COWORK (inteligencia de mercado Vanguard)  -- $dataFmt $diaSemPt"
Write-Host "  ============================================================================"
Write-Host "  Regra (Diretor 2026-06-15): agir SOMENTE no que a data de hoje preve."
Write-Host ""

if ($mHoje.Count -gt 0) {
    Write-Host "  TAREFAS COWORK FONOGRAFICAS (M1-M7) PREVISTAS HOJE:"
    foreach ($t in $mHoje) {
        switch ($t.Orcamento) {
            "LIBERADO"  { $e4 = " [E-4: LIBERADO]" }
            "BLOQUEADO" { $e4 = " [E-4: BLOQUEADO -- NAO COLHER hoje]" }
            default     { $e4 = " [E-4: INDISPONIVEL -- shield off]" }
        }
        Write-Host (("    {0} {1,-32} (roda {2} BRT) -> colher BRIEFING_MUSCULO_{0}" -f $t.Id, $t.Tema, $t.Hora) + $e4)
    }
} else {
    Write-Host "  Nenhuma tarefa Cowork fonografica (M1-M7) prevista para hoje."
}
Write-Host ""

Write-Host "  FRENTES F PREVISTAS HOJE:"
Write-Host "    Semanal  : $fSemanal"
if ($fQuinzenal.Count -gt 0) { foreach ($f in $fQuinzenal) { Write-Host "    Quinzenal: $f" } }
if ($fMensal.Count    -gt 0) { foreach ($f in $fMensal)    { Write-Host "    Mensal   : $f" } }
Write-Host ""

Write-Host "  M-STATS -- CONFERIR (estado, independe da data):"
if ($mstatsPendentes.Count -gt 0) {
    Write-Host "    $($mstatsPendentes.Count) parecer(es) M-STATS BASE aguardando ROBUSTECER (Passo 2 -- EXECUTOR):"
    foreach ($m in $mstatsPendentes) { Write-Host "      -> $m" }
    Write-Host "    Robustecer = Antigravity papel EXECUTOR. Disparo: Projetista (Acao 3 v5.1) ou dia 1."
    Write-Host "    Musculo prepara: scripts\ir_ao_antigravity.ps1 -papel EXECUTOR"
} else {
    Write-Host "    Nenhum parecer M-STATS BASE aguardando robustecer."
}
Write-Host ""

Write-Host "  ATIVACOES MANUAIS DO DIRETOR HOJE (Claude Projects -- COLAR o comando no ator):"
if ($ativErro) {
    Write-Host "    [FALLBACK] Falha ao ler comandos_ativacao_atores.json: $ativErro"
    Write-Host "    EMBAIXADOR DIGITAL: colar 'EMBAIXADOR DIGITAL, mostrar radar.' (diario)"
    Write-Host "    PROJETISTA: ver scripts\comandos_ativacao_atores.json"
} else {
    Write-Host "  -- EMBAIXADOR DIGITAL --"
    if ($ativDigital.Count -gt 0) {
        foreach ($a in $ativDigital) {
            Write-Host "    >> $($a.comando):"
            foreach ($ln in ($a.texto -split "`n")) { Write-Host "       $ln" }
        }
    } else { Write-Host "    (nenhuma ativacao manual hoje)" }
    Write-Host "  -- PROJETISTA --"
    if ($ativProjetista.Count -gt 0) {
        foreach ($a in $ativProjetista) {
            Write-Host "    >> $($a.comando):"
            foreach ($ln in ($a.texto -split "`n")) { Write-Host "       $ln" }
        }
    } else { Write-Host "    (nenhuma ativacao manual hoje -- frentes Cowork rodam sozinhas)" }
    Write-Host "  -- ANTIGRAVITY COWORK / EXECUTOR --"
    if ($ativExecutor.Count -gt 0) {
        foreach ($a in $ativExecutor) {
            Write-Host "    >> $($a.comando):"
            foreach ($ln in ($a.texto -split "`n")) { Write-Host "       $ln" }
        }
    } else { Write-Host "    (nenhuma conducao Cowork hoje -- fim de semana)" }
    Write-Host ""
    Write-Host "    SOB GATILHO (rodar quando aplicavel): ED 'trabalhar [nicho]' (ao escolher nicho no radar) /"
    Write-Host "    ED 'setup inicial' (1a vez) / PROJETISTA 'materializacao' (plano aprovado) /"
    Write-Host "    PROJETISTA 'sessao de agendamento' (lacuna / novo nicho)."
}
Write-Host "    (espelhadas no Telegram via W-11 -- horarios da AGENDA sao teoricos; vale quando o Diretor ativa)"
Write-Host ""

if ($briefingsEsperados.Count -gt 0) {
    Write-Host "  BRIEFINGS A COLHER NO INBOX_COWORK (folder 1EjaH6TmsxbYpgKWb7ASm7CohFJfwSLKi):"
    foreach ($b in $briefingsEsperados) {
        $bId = $b -replace "^BRIEFING_MUSCULO_", ""
        $bTask = $mHoje | Where-Object { $_.Id -eq $bId } | Select-Object -First 1
        $flag = ""
        if ($bTask -and $bTask.Orcamento -eq "BLOQUEADO") { $flag = " -- BLOQUEADO POR E-4, NAO COLHER" }
        Write-Host "    -> $b   (firewall: PENDING_REVIEW [NICHO-FONOGRAFICO] -- P-124/P-132 -- P-059 N/A)$flag"
    }
    Write-Host ""
    Write-Host "  Briefing previsto e AUSENTE = alerta de falha do Cowork (reportar ao Diretor)."
    Write-Host "  Briefing presente mas NAO previsto hoje = registrar, NAO colher; checar a data na grade."
} else {
    Write-Host "  Nenhum briefing fonografico a colher hoje."
}
Write-Host ""
Write-Host "  Apos analisar com o Diretor: scripts\gate_passo0_abertura.ps1 -MarcarCalendario"
Write-Host ""
exit 0
