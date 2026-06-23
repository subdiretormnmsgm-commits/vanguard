#Requires -Version 5.1
# ir_ao_antigravity.ps1 -- Gera comando @skill para Antigravity + clipboard + abre VS Code
# P-163: Musculo gera o prompt, Diretor cola no VS Code (Gemini chat)
#
# Uso:
#   -papel ESTRATEGISTA   -- @concise-planning com contexto da sessao (padrao toda abertura)
#   -papel EXECUTOR       -- @n8n-workflow-patterns com contexto do workflow ativo
#   -papel COWORK         -- @20-andruia-niche-intelligence com nicho ativo
#   -skill <nome>         -- skill especifica (sobrescreve a padrao do papel)
#   -acao <descricao>     -- contexto da acao atual (opcional, gera contexto automatico se omitido)
#   -Clipboard            -- copia o prompt para o clipboard automaticamente
#   -AbrirVSCode          -- abre o VS Code com o workspace do Vanguard
#   -VerificarSkill       -- verifica se a skill esta instalada sem gerar prompt

param(
    [ValidateSet("ESTRATEGISTA","EXECUTOR","COWORK")]
    [string]$papel = "ESTRATEGISTA",
    [string]$skill = "",
    [string]$acao = "",
    [switch]$Clipboard,
    [switch]$AbrirVSCode,
    [switch]$VerificarSkill
)

$raiz     = Split-Path -Parent $PSScriptRoot
$dataHoje = Get-Date -Format "yyyy-MM-dd"
$diaSemana = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))

# Mapa papel -> skill padrao + skills complementares
$skillMap = @{
    ESTRATEGISTA = @{
        principal    = "concise-planning"
        complementar = @("brainstorming", "multi-agent-brainstorming", "architecture", "analyze-project")
        descricao    = "Planejamento estrategico e suporte a DIRETRIZ"
    }
    EXECUTOR = @{
        principal    = "n8n-workflow-patterns"
        complementar = @("n8n-node-configuration", "n8n-expression-syntax", "n8n-validation-expert", "systematic-debugging", "bash-scripting")
        descricao    = "Execucao de decisoes do Estrategista-Gemini"
    }
    COWORK = @{
        principal    = "20-andruia-niche-intelligence"
        complementar = @("apify-market-research", "apify-trend-analysis", "competitive-landscape", "market-sizing-analysis", "deep-research")
        descricao    = "Sessao NICHE_MODELER e inteligencia de mercado"
    }
}

$cfg       = $skillMap[$papel]
$skillAtual = if ($skill) { $skill } else { $cfg.principal }

# Verificar instalacao da skill
$skillInstPath = "$env:USERPROFILE\.agents\skills\$skillAtual"
$instalada     = Test-Path $skillInstPath

# Modo verificacao rapida
if ($VerificarSkill) {
    if ($instalada) {
        Write-Host "[OK] @$skillAtual instalada em: $skillInstPath" -ForegroundColor Green
    } else {
        Write-Host "[XX] @$skillAtual NAO instalada." -ForegroundColor Red
        Write-Host "     Instalar: npx antigravity-awesome-skills --antigravity" -ForegroundColor Yellow
    }
    foreach ($comp in $cfg.complementar) {
        $compPath = "$env:USERPROFILE\.agents\skills\$comp"
        $compIcon = if (Test-Path $compPath) { "[OK]" } else { "[--]" }
        $cor = if (Test-Path $compPath) { "Green" } else { "DarkGray" }
        Write-Host "  $compIcon @$comp" -ForegroundColor $cor
    }
    exit 0
}

# Ler contexto ativo do WIP_BOARD
$clienteAtivo = "VANGUARD"
$loopAtivo    = "?"
$projetoDesc  = ""
$wipPath = Join-Path $raiz "CLIENTES\WIP_BOARD.json"
if (Test-Path $wipPath) {
    try {
        $wip      = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $projBuild = @($wip.board.build) | Select-Object -First 1
        if ($projBuild) {
            $clienteAtivo = $projBuild.cliente
            $loopAtivo    = $projBuild.loop_fase_atual.loop
            $fasePend     = ""
            $lfa = $projBuild.loop_fase_atual
            if ($lfa.gemini     -ne "OK") { $fasePend = "aguardando Gemini" }
            elseif ($lfa.notebooklm -ne "OK") { $fasePend = "aguardando NotebookLM" }
            elseif ($lfa.embaixador -ne "OK") { $fasePend = "aguardando Embaixador" }
            elseif ($lfa.musculo    -ne "OK") { $fasePend = "aguardando Musculo" }
            else { $fasePend = "loop completo" }
            $projetoDesc = "[$clienteAtivo Loop $loopAtivo -- $fasePend]"
        }
    } catch {}
}

# Ler pendentes abertas (top 3 mais antigas)
$pendentes = @()
$pendPath = Join-Path $raiz "PENDENTES.md"
if (Test-Path $pendPath) {
    $linhas = Get-Content $pendPath -Encoding UTF8 -ErrorAction SilentlyContinue
    foreach ($l in $linhas) {
        if ($l -match '^\s*- \[ \]') {
            $titulo = $l -replace '^\s*- \[ \]\s*`[^`]+`\s*', '' -replace '\*\*([^*]+)\*\*', '$1'
            $titulo = $titulo.Trim() -replace '^\[musculo\]\s*', '' -replace '^\[diretor\]\s*', ''
            if ($titulo.Length -gt 60) { $titulo = $titulo.Substring(0, 57) + "..." }
            $pendentes += $titulo
            if ($pendentes.Count -ge 3) { break }
        }
    }
}

# Ler entradas do ANTIGRAVITY_SESSION_LOG (memoria de contexto entre sessoes)
# Origem: Sugestao do Diretor no Notion 2026-06-16 -- "Antigravity saber contexto da ultima sessao dele"
# Furo 4 (2026-06-16): capturar a ultima entrada GLOBAL (qualquer papel) + a ultima entrada DO PAPEL ATUAL.
$ultimaSessao = ""
$ultimaPapel  = ""
$logPath = Join-Path $raiz "CONSELHO\ANTIGRAVITY_SESSION_LOG.md"
if (Test-Path $logPath) {
    $logLinhas = Get-Content $logPath -Encoding UTF8 -ErrorAction SilentlyContinue
    $blocos = @()        # ordem do arquivo: topo = mais recente (append-only no topo)
    $atual  = $null
    foreach ($l in $logLinhas) {
        if ($l -match '^##\s+\d{4}-\d{2}-\d{2}') {
            if ($atual) { $blocos += ,$atual }
            $papelBloco = "OUTRO"
            foreach ($p in @("ESTRATEGISTA","EXECUTOR","COWORK","SISTEMA")) {
                if ($l -match $p) { $papelBloco = $p; break }
            }
            $atual = @{ papel = $papelBloco; linhas = @($l) }
        } elseif ($atual) {
            $atual.linhas += $l
        }
    }
    if ($atual) { $blocos += ,$atual }

    if ($blocos.Count -gt 0) {
        $t0 = ($blocos[0].linhas | Where-Object { $_.Trim() -ne "" }) -join " "
        if ($t0.Length -gt 400) { $t0 = $t0.Substring(0, 397) + "..." }
        $ultimaSessao = $t0
        # so injeta a ultima do papel se a global mais recente NAO for ja desse papel (evita duplicar)
        if ($blocos[0].papel -ne $papel) {
            $bloPapel = $blocos | Where-Object { $_.papel -eq $papel } | Select-Object -First 1
            if ($bloPapel) {
                $tp = ($bloPapel.linhas | Where-Object { $_.Trim() -ne "" }) -join " "
                if ($tp.Length -gt 400) { $tp = $tp.Substring(0, 397) + "..." }
                $ultimaPapel = $tp
            }
        }
    }
}

# Ler MEMORIA PERMANENTE do Antigravity (licoes que NUNCA expiram -- ele "nao sabe nada, age por gatilho")
# Origem: Diretor 2026-06-22 -- "Temos que criar uma memoria para ele, esta sempre sem contexto".
# Distinta do SESSION_LOG (cronologico, so a ultima entrada): esta e injetada INTEIRA, todo comando, qualquer papel.
$memoriaPermanente = ""
$memoriaPath = Join-Path $raiz "CONSELHO\ANTIGRAVITY_MEMORIA.md"
if (Test-Path $memoriaPath) {
    $memoriaPermanente = ((Get-Content $memoriaPath -Encoding UTF8 -ErrorAction SilentlyContinue) -join "`n").Trim()
    # Espelho NATIVO -- Antigravity le .agents/rules/ sozinho toda sessao (Workspace Rules persistem contexto,
    # igual o CLAUDE.md do Claude Code). Opcao A do Diretor (2026-06-22): canonico em CONSELHO/ANTIGRAVITY_MEMORIA.md,
    # espelhado aqui a cada run -> UMA fonte, duas saidas (injecao inline + arquivo nativo), zero deriva (P-110).
    # Limite Antigravity: 12.000 chars por arquivo de regras -- a memoria cabe folgado.
    if ($memoriaPermanente) {
        $rulesDir = Join-Path $raiz ".agents\rules"
        if (-not (Test-Path $rulesDir)) { New-Item -ItemType Directory -Path $rulesDir -Force | Out-Null }
        # BOM-less (UTF8Encoding $false): PS 5.1 Set-Content -Encoding UTF8 grava BOM e divergiria do canonico
        # CONSELHO/ANTIGRAVITY_MEMORIA.md (sem BOM) -- contradiz o "zero deriva / P-110". FALHA-H / json-bom-guard.
        [System.IO.File]::WriteAllText((Join-Path $rulesDir "00-vanguard-memoria.md"), $memoriaPermanente, (New-Object System.Text.UTF8Encoding($false)))
    }
}

# Contexto da acao
$contextoAcao = if ($acao) { $acao } else {
    switch ($papel) {
        "ESTRATEGISTA" {
            "Abertura $dataHoje ($diaSemana) $projetoDesc. Objetivo desta sessao: [descreva aqui]"
        }
        "EXECUTOR" {
            "Executar decisoes Gemini para $clienteAtivo. Arquivo de entrada: PASSO3_GEMINI.md + CONTEXTO_GEMINI.md"
        }
        "COWORK" {
            "Sessao NICHE_MODELER $dataHoje. Le INBOX_COWORK + BIBLIOTECA + NICHE_INDEX. 5 tarefas: fit_score, enriquecimento, alertas, nichos novos, mapa prioridade"
        }
    }
}

# GATE PERMANENTE -- PILARES COMPORTAMENTAIS (Loop 36+) -- carrega em TODA sessao Antigravity
# Injetado na geracao (P-033): o .antigravity_prompt.txt e regenerado a cada run, entao o gate
# vive aqui, no script, nunca no artefato. Harmonizacao Diretor 2026-06-17.
$gatePilares = @'
## GATE PERMANENTE -- PILARES COMPORTAMENTAIS (Loop 36+)
Fonte: CONSELHO/PILARES COMPORTAMENTAIS.md (Vanguard vault)
REGRA: os 4 pilares valem em TODA sessao do Antigravity, antes de qualquer tarefa.
Harmonizacao Diretor (2026-06-17): "Amplitude maxima na busca, economia na entrega."
  -> Amplitude maxima: Deep Research sem teto de vetores, subagentes e fontes.
  -> Economia: entrega concisa, sem listagem sem sintese, sem verbose.

I.  PENSAR ANTES DE AGIR -- declare premissa; pergunte se incerto; confronte quando justificado.
II. SIMPLICIDADE NA ENTREGA -- minimo que resolve; sem feature alem do pedido.
III.MUDANCAS CIRURGICAS -- toque so no escopo; fora do escopo -> sinaliza ao Diretor.
IV. META VERIFICAVEL -- criterio contra fonte/disco. Iteracao termina em P-124.

PADRAO DE QUALIDADE (toda ideia [G-1..G-N]):
- CRIATIVA: nao e a primeira solucao obvia -- ha camada que o Embaixador nao faria imediatamente.
- DISRUPTIVA: muda como o mercado enxerga o problema. Nunca disruptiva em complexidade de build.
- INTELIGENTE: conecta pelo menos dois dados nao conectados. Sintese, nao listagem.
Teste: "O Diretor diria que isso e obvio?" -> se sim, refazer.

GATE DE FATO: toda afirmacao de mercado exige fonte + data. Sem fonte -> [NAO CONFIRMADO].
---
'@

# Montar o prompt -- gate dos pilares SEMPRE primeiro (antes do @skill)
$linhasPrompt = @($gatePilares, "@$skillAtual $contextoAcao")
# MEMORIA PERMANENTE -- injetada INTEIRA em todo comando, qualquer papel (Antigravity e stateless).
# Vem ANTES da ETAPA 0 porque licao permanente > contexto da ultima sessao.
if ($memoriaPermanente) {
    $linhasPrompt += ""
    $linhasPrompt += "## MEMORIA PERMANENTE DO ANTIGRAVITY (vale SEMPRE, qualquer papel -- leia ANTES de agir):"
    $linhasPrompt += $memoriaPermanente
}
# ETAPA 0 -- contexto da ultima sessao do Antigravity (memoria entre sessoes)
$linhasPrompt += ""
if ($ultimaSessao) {
    $linhasPrompt += "ETAPA 0 (ultima sessao -- mais recente, qualquer papel): $ultimaSessao"
    if ($ultimaPapel) {
        $linhasPrompt += "ETAPA 0 (sua ultima sessao como $papel): $ultimaPapel"
    }
    $linhasPrompt += "Leia CONSELHO/ANTIGRAVITY_SESSION_LOG.md no workspace se precisar do historico completo."
} else {
    $linhasPrompt += "ETAPA 0: leia CONSELHO/ANTIGRAVITY_SESSION_LOG.md no workspace (sua memoria de sessoes anteriores)."
}
if ($pendentes.Count -gt 0) {
    $linhasPrompt += ""
    $linhasPrompt += "Pendentes abertas: " + ($pendentes -join " | ")
}
if ($papel -eq "ESTRATEGISTA") {
    $linhasPrompt += ""
    $linhasPrompt += "Instrucao: apos @concise-planning, invocar @brainstorming para qualquer decisao arquitetural ou DIRETRIZ."
}
if ($papel -eq "COWORK") {
    # COMO AGIR conforme os PILARES no trabalho de inteligencia de mercado (Diretor 2026-06-18).
    # O gate generico ($gatePilares) diz O QUE respeitar; este diz COMO, no contexto Cowork.
    $gateCowork = @'
## COMO AGIR -- PILARES NO COWORK (Executor COWORK CONDUCTOR)
I.   PENSAR ANTES DE AGIR -> declare a hipotese de mercado e o nicho-alvo ANTES de pesquisar.
     Fonte ou nicho incerto -> marque [NAO CONFIRMADO] e sinalize ao Diretor; nunca assuma.
II.  SIMPLICIDADE -> entregue SINTESE acionavel (fit_score + decisao + por que), nao o dump do que achou.
     O Diretor le PENDING_REVIEW, nao um despejo bruto. Amplitude na busca, economia na entrega.
III. CIRURGICAS -> fique no(s) nicho(s) em escopo. Nicho novo descoberto -> registre como SUGESTAO
     em PENDING_REVIEW; nunca expanda o escopo sozinho, nunca crie decisao por conta propria.
IV.  META VERIFICAVEL -> todo numero de mercado com FONTE + DATA. Sem fonte -> [NAO CONFIRMADO].
     Output SEMPRE para PENDING_REVIEW.md (P-124 -- anti-camara-de-eco). Nunca direto para DECISOES/WIP.
'@
    # RUBRICA FIT_SCORE -- antidoto anti-inflacao (Diretor 2026-06-22).
    # Causa raiz: motor Gemini 3.1 Pro High tem vies otimista/yes-man nativo; a instrucao "fit_score
    # recalculado" nao trazia trava. Resultado: 11/16 nichos com media 5.0 cravada, D1-D5 uniformes,
    # 5.5 fora de escala. Conserto: discriminar pela EVIDENCIA, NAO por cota fixa (sem anti-volume).
    $rubricaFitScore = @'
## RUBRICA FIT_SCORE -- ANTIDOTO ANTI-INFLACAO (Score Vanguard D1-D5, escala 1-5)
Motivo: o motor tende a dar nota alta a tudo (vies otimista / yes-man). A nota so
serve se DISCRIMINA. Discriminacao vem da EVIDENCIA, nunca de uma cota fixa.

1. ANCORA POR NOTA (cada dimensao D1-D5):
   5 = evidencia dura citavel (numero + fonte + data) que prova a dimensao no grau maximo.
   3 = sinal real porem parcial / sem numero fechado.
   1 = sem evidencia ou irrelevante ao nicho.   (2 e 4 = graus intermediarios.)
2. EVIDENCIA OBRIGA NOTA: qualquer D >= 4 EXIGE numero + FONTE + DATA na propria nota.
   Sem evidencia citavel -> teto 3 naquela dimensao. Sem excecao.
   >> ANTES DE APLICAR TETO 3, BUSQUE O NUMERO NO CARTAO DO NICHO
   (BIBLIOTECA_NICHOS/[SLUG]_CARTAO.md) e no INTELLIGENCE_HUB. Teto 3 vale para evidencia
   AUSENTE -- nao para evidencia que voce nao foi procurar. Ex.: Saude Digital tem "6.000+
   hospitais" no cartao; subpontuar por preguica de busca e ERRO (detectado no cruzamento
   2026-06-22). So aplique teto 3 apos confirmar que o numero NAO existe em disco.
3. ANTI-UNIFORMIDADE -- MAS NAO ANTI-VOLUME: e proibido repetir a mesma linha D1-D5 entre
   nichos diferentes sem justificativa (variacao tem de refletir diferenca real de evidencia).
   NAO existe cota maxima de MOVER AGORA: se muitos nichos tem deadline real + dor documentada,
   MUITOS MOVER AGORA e o resultado CORRETO -- volume alto e natural (ha ~33 nichos ativos).
   Discrimina pela PROVA, jamais por limite numerico artificial. Nem inflar tudo, nem podar bom nicho.
4. TRAVA DE ESCALA: 1 a 5 estrito. Rejeitar valor fora (ex.: 5.5) -> recalcular.
5. CLASSIFICACAO = CALCULO DA MEDIA: >= 4.0 MOVER AGORA | 2.5-3.9 MONITORAR | < 2.5 ARQUIVAR.
   A classificacao TEM de bater com a media. Se nao bate, ha erro -> corrigir.
6. TESTE FINAL: se a tabela deu nota maxima a quase todos SEM evidencia por celula, falhou em
   discriminar -> refazer. Se cada nota alta tem prova, qualquer distribuicao (alta ou baixa) vale.
'@
    $linhasPrompt += ""
    $linhasPrompt += $gateCowork
    $linhasPrompt += ""
    $linhasPrompt += $rubricaFitScore
}
# ETAPA FINAL -- anexar entrada ao log (memoria para a proxima sessao)
$linhasPrompt += ""
$linhasPrompt += "ETAPA FINAL (obrigatoria): ao terminar, anexe no TOPO da lista em CONSELHO/ANTIGRAVITY_SESSION_LOG.md uma entrada: ## $dataHoje ($diaSemana) -- $papel | Objetivo | O que fiz | Arquivos tocados | Decisao/output (destino PENDING_REVIEW.md) | Proximo passo."
$prompt = $linhasPrompt -join "`n"

# --- Output ---
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  ANTIGRAVITY -- PAPEL: $papel" -ForegroundColor Cyan
Write-Host "  $($cfg.descricao)" -ForegroundColor DarkGray
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

$corSkill = if ($instalada) { "Green" } else { "Red" }
$statusSkill = if ($instalada) { "[INSTALADA]" } else { "[NAO INSTALADA]" }
Write-Host "Skill principal : @$skillAtual $statusSkill" -ForegroundColor $corSkill
if (-not $instalada) {
    Write-Host "  Instalar: npx antigravity-awesome-skills --antigravity" -ForegroundColor Yellow
}
Write-Host "Projeto ativo   : $clienteAtivo | Loop $loopAtivo" -ForegroundColor White
if ($ultimaSessao) {
    Write-Host "Ultima sessao   : $ultimaSessao" -ForegroundColor DarkCyan
    if ($ultimaPapel) {
        Write-Host "Ultima ($papel) : $ultimaPapel" -ForegroundColor DarkCyan
    }
} else {
    Write-Host "Ultima sessao   : (log vazio -- primeira sessao registrada)" -ForegroundColor DarkGray
}
Write-Host ""
Write-Host "Skills complementares (invocar conforme necessidade):" -ForegroundColor DarkGray
foreach ($comp in $cfg.complementar) {
    $compOk = Test-Path "$env:USERPROFILE\.agents\skills\$comp"
    $icon = if ($compOk) { "[OK]" } else { "[--]" }
    $cor  = if ($compOk) { "Gray" } else { "DarkGray" }
    Write-Host "  $icon @$comp" -ForegroundColor $cor
}
Write-Host ""
Write-Host "COLAR NO VS CODE (Gemini chat) -- Ctrl+V apos abrir:" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host $prompt -ForegroundColor White
Write-Host "----------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

# Gravar prompt em arquivo
$promptFile = Join-Path $raiz "scripts\.antigravity_prompt.txt"
[System.IO.File]::WriteAllText($promptFile, $prompt, [System.Text.Encoding]::UTF8)
Write-Host "Prompt salvo em : scripts/.antigravity_prompt.txt" -ForegroundColor DarkGray

# Clipboard
if ($Clipboard) {
    try {
        Set-Clipboard -Value $prompt
        Write-Host "[CLIPBOARD] Copiado -- cole no VS Code com Ctrl+V" -ForegroundColor Green
    } catch {
        Write-Host "[CLIPBOARD] Falhou -- copiar do texto acima" -ForegroundColor Yellow
    }
}

# Abrir VS Code
if ($AbrirVSCode) {
    try {
        Start-Process "code" -ArgumentList "`"$raiz`"" -ErrorAction Stop
        Write-Host "[VS CODE] Workspace aberto -- ir ao Gemini chat e colar" -ForegroundColor Green
    } catch {
        Write-Host "[VS CODE] Nao encontrado -- abrir manualmente: code `"$raiz`"" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Proximas skills a invocar durante a sessao (ver GATILHOS em .agents/skills/skills.md):" -ForegroundColor DarkGray
switch ($papel) {
    "ESTRATEGISTA" { Write-Host "  @brainstorming -> @multi-agent-brainstorming (alto impacto) -> @architecture -> @analyze-project" -ForegroundColor DarkGray }
    "EXECUTOR"     { Write-Host "  @n8n-node-configuration -> @n8n-expression-syntax -> @n8n-validation-expert -> @systematic-debugging" -ForegroundColor DarkGray }
    "COWORK"       { Write-Host "  @apify-market-research -> @apify-trend-analysis -> @competitive-landscape -> @market-sizing-analysis" -ForegroundColor DarkGray }
}
Write-Host ""
