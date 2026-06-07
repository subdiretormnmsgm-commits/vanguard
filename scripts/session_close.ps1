#Requires -Version 5.1
# session_close.ps1 -- wrapper (P-096: canonico em PENTALATERAL_UNIVERSAL\scripts\)
# Uso: .\scripts\session_close.ps1 [-Projeto NOME] [-DryRun] [-Friccao "..."] etc.
# Legado: session_close_LEGADO_2026-06-04.ps1

# PRE-CHECK: CONTEXTO SESSAO DIRETOR deve existir antes de fechar
$baseDir = Split-Path -Parent $PSScriptRoot
$dataHoje = Get-Date -Format "yyyy-MM-dd"
$contextoPath = "$baseDir\PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataHoje.md"
if (-not (Test-Path $contextoPath)) {
    Write-Host ""
    Write-Host "  [AVISO] CONTEXTO_SESSAO_DIRETOR_$dataHoje.md NAO ENCONTRADO" -ForegroundColor Yellow
    Write-Host "  Musculo: escreva o contexto conversacional ANTES de continuar." -ForegroundColor Yellow
    Write-Host "  Destino: PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataHoje.md" -ForegroundColor Yellow
    Write-Host "  9 secoes obrigatorias:" -ForegroundColor Yellow
    Write-Host "  1. O QUE FOI CONSTRUIDO   -- arquivos criados, scripts, commits (com verbo)" -ForegroundColor Yellow
    Write-Host "  2. DECISOES TOMADAS       -- decisao + razao + impacto (inclui verbais)" -ForegroundColor Yellow
    Write-Host "  3. DIRECAO DO DIRETOR     -- mandatos, ajustes estrategicos, redirecionamentos" -ForegroundColor Yellow
    Write-Host "  4. ESTADO DOS PROJETOS    -- semaforo rapido antes/depois por projeto" -ForegroundColor Yellow
    Write-Host "  5. FRICCOES DO PROCESSO   -- o que travou, workarounds, candidatos ao LEDGER" -ForegroundColor Yellow
    Write-Host "  6. O QUE O SISTEMA NAO SABIA -- informacoes reveladas pelo Diretor nesta sessao" -ForegroundColor Yellow
    Write-Host "  7. DOCUMENTOS MORTOS / INCONSISTENCIAS" -ForegroundColor Yellow
    Write-Host "  8. FICOU NO AR            -- o que nao foi concluido" -ForegroundColor Yellow
    Write-Host "  9. PROXIMA SESSAO         -- uma frase cirurgica" -ForegroundColor Yellow
    Write-Host ""
}

$universal = Join-Path (Split-Path -Parent $PSScriptRoot) "PENTALATERAL_UNIVERSAL\scripts\session_close.ps1"
& powershell.exe -NonInteractive -File $universal @args
$exitCode = $LASTEXITCODE

# SYNC FICOU NO AR -- converte itens de "8. FICOU NO AR" do CONTEXTO em [ ] no PENDENTES.md
# Roda antes do webhook para que o n8n receba o PENDENTES ja atualizado
if ($exitCode -eq 0) {
    $syncFicouScript = Join-Path $PSScriptRoot "sync_ficou_no_ar.ps1"
    if (Test-Path $syncFicouScript) {
        & powershell.exe -NonInteractive -File $syncFicouScript -DataContexto $dataHoje 2>$null
    }
}

# N-3: fire-and-forget webhook n8n (so executa se n8n_config.ps1 existir e gates passaram)
if ($exitCode -eq 0) {
    $webhookScript = Join-Path $PSScriptRoot "n8n_session_webhook.ps1"
    if (Test-Path $webhookScript) {
        & powershell.exe -NonInteractive -File $webhookScript @args 2>$null
    }
}

# GIT PUSH -- propagar commits locais para o GitHub e disparar W-3
if ($exitCode -eq 0) {
    Write-Host ""
    Write-Host "  [GIT] Verificando commits locais nao publicados..." -ForegroundColor Cyan
    $unpushed = git log origin/master..master --oneline 2>$null
    if ($unpushed) {
        Write-Host "  [GIT] $(@($unpushed).Count) commit(s) pendentes -- fazendo push..." -ForegroundColor Yellow
        git push origin master 2>&1 | ForEach-Object { Write-Host "  $_" }
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [GIT] Push concluido -- W-3 sera disparado pelo GitHub." -ForegroundColor Green
        } else {
            Write-Host "  [GIT] AVISO: push falhou -- verificar conexao ou conflitos remotos." -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [GIT] Nenhum commit pendente -- remoto ja esta atualizado." -ForegroundColor Green
    }
}

# ARTEFATO OPERACIONAL -- Haiku via API (gate: ANTHROPIC_API_KEY disponivel -- D2 ENV_VARS)
if ($exitCode -eq 0) {
    $artefatoOpScript = Join-Path $PSScriptRoot "gerar_artefato_operacional.ps1"
    if (Test-Path $artefatoOpScript) {
        Write-Host ""
        Write-Host "  [OPER] Gerando ABERTURA DE SESSAO pre-gerada (Haiku)..." -ForegroundColor Cyan
        & powershell.exe -NonInteractive -File $artefatoOpScript 2>$null
    }
}

# POS-CLOSE: bloco Embaixador Operacional (A4 -- acao insubstituivel do Diretor)
$dataFim = Get-Date -Format "yyyy-MM-dd"
$contextoFimPath = "$baseDir\PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataFim.md"

# Localizar PAINEL_ATIVIDADES mais recente
$painelMaisRecente = Get-ChildItem "$baseDir\PROTOCOLOS_ENCERRAMENTO" -Filter "PAINEL_ATIVIDADES_*$dataFim*.md" -ErrorAction SilentlyContinue |
                     Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $painelMaisRecente) {
    $painelMaisRecente = Get-ChildItem "$baseDir\PROTOCOLOS_ENCERRAMENTO" -Filter "PAINEL_ATIVIDADES_*.md" -ErrorAction SilentlyContinue |
                         Sort-Object LastWriteTime -Descending | Select-Object -First 1
}
$painelNome = if ($painelMaisRecente) { $painelMaisRecente.Name } else { "PAINEL_ATIVIDADES_$dataFim.md (verificar)" }

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host "  EMBAIXADOR OPERACIONAL -- Vanguard (A4)"              -ForegroundColor Magenta
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Projeto: 'Vanguard - Embaixador Operacional'" -ForegroundColor White
Write-Host ""
Write-Host "  ANEXAR os 7 arquivos ao Embaixador (arrastar):" -ForegroundColor Yellow
Write-Host ""

# Doc 1 -- PAINEL
Write-Host "  1. PROTOCOLOS_ENCERRAMENTO\$painelNome" -ForegroundColor Cyan

# Doc 2 -- CONTEXTO
if (Test-Path $contextoFimPath) {
    Write-Host "  2. PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataFim.md" -ForegroundColor Cyan
} else {
    Write-Host "  2. CONTEXTO_SESSAO_DIRETOR_$dataFim.md [NAO GERADO -- Musculo deve criar antes de fechar]" -ForegroundColor Red
}

# Doc 3 -- WIP_BOARD
Write-Host "  3. CLIENTES\WIP_BOARD.json" -ForegroundColor Cyan

# Doc 4 -- LEDGER
Write-Host "  4. INTELLIGENCE_LEDGER.md" -ForegroundColor Cyan

# Doc 5 -- PENDENTES
Write-Host "  5. PENDENTES.md" -ForegroundColor Cyan

# Doc 6 -- TIMELINE
$timelinePath = "$baseDir\CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
if (Test-Path $timelinePath) {
    Write-Host "  6. CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md" -ForegroundColor Cyan
} else {
    Write-Host "  6. 16_VANGUARD_TIMELINE.md [NAO ENCONTRADO]" -ForegroundColor Yellow
}

# Doc 7 -- MEMORIA EMBAIXADOR
$memoriaEmbPath = "$baseDir\CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md"
if (Test-Path $memoriaEmbPath) {
    Write-Host "  7. CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md" -ForegroundColor Cyan
} else {
    Write-Host "  7. MEMORIA_EMBAIXADOR_VANGUARD.md [NAO ENCONTRADO]" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  COLAR no chat do Embaixador (copiar o bloco abaixo):" -ForegroundColor Yellow
Write-Host ""
Write-Host "  ============================================================" -ForegroundColor DarkGray
Write-Host "  Embaixador, fechamento de sessao -- $dataFim." -ForegroundColor White
Write-Host "  Faco upload do PAINEL_ATIVIDADES, CONTEXTO_SESSAO_DIRETOR," -ForegroundColor White
Write-Host "  WIP_BOARD, INTELLIGENCE_LEDGER, PENDENTES, VANGUARD_TIMELINE" -ForegroundColor White
Write-Host "  e MEMORIA_EMBAIXADOR desta sessao." -ForegroundColor White
Write-Host "  Com base nos sete arquivos, gerar o artefato publicavel com:" -ForegroundColor White
Write-Host ""
Write-Host "  0. BRIEFING DE ABERTURA PARA O MUSCULO (item mais importante -- gerar primeiro)" -ForegroundColor White
Write-Host "     Redigir um paragrafo que o Diretor colara no inicio da proxima sessao do Claude Code." -ForegroundColor White
Write-Host "     Deve conter: (a) o que foi entregue hoje e esta ativo," -ForegroundColor White
Write-Host "     (b) o que ficou em aberto e por que," -ForegroundColor White
Write-Host "     (c) qual e o proximo passo esperado do Musculo ao abrir a sessao." -ForegroundColor White
Write-Host "     Escrito na segunda pessoa, direto ao Musculo: 'Musculo, na ultima sessao...'" -ForegroundColor White
Write-Host ""
Write-Host "  1. SEMAFORO -- status visual de cada projeto" -ForegroundColor White
Write-Host "     (vermelho bloqueante / amarelo atencao / verde saudavel)" -ForegroundColor White
Write-Host "  2. DIAGNOSTICO DO DIA -- saude dos projetos ativos + o que avancou" -ForegroundColor White
Write-Host "  3. PREVISAO DOS PROXIMOS DIAS -- data a data com checklist do Diretor" -ForegroundColor White
Write-Host "  4. ANALISE GERENCIAL -- o que o comportamento real do cliente confirma" -ForegroundColor White
Write-Host "     ou contradiz? O que voce ve que o Musculo nao ve?" -ForegroundColor White
Write-Host "  5. PROXIMA ACAO DO DIRETOR -- maximo 3 itens em ordem de prioridade" -ForegroundColor White
Write-Host ""
Write-Host "  Ao entregar o artefato, incluir esta instrucao ao Diretor:" -ForegroundColor White
Write-Host "  'Diretor, ao abrir o Claude Code, cole o BLOCO 0 acima como" -ForegroundColor White
Write-Host "  PRIMEIRA mensagem para o Musculo -- antes de qualquer outra coisa." -ForegroundColor White
Write-Host "  Sem isso, ele comeca sem contexto da sessao de hoje.'" -ForegroundColor White
Write-Host "  ============================================================" -ForegroundColor DarkGray
Write-Host ""

# n8n W-4 -- gate: TELEGRAM_BOT_TOKEN configurado (D2 ENV_VARS)
$alertConfigPath = Join-Path $PSScriptRoot "alert_config.ps1"
$telegramAtivo   = $false
if (Test-Path $alertConfigPath) {
    try {
        . $alertConfigPath
        $telegramAtivo = -not [string]::IsNullOrWhiteSpace($TELEGRAM_BOT_TOKEN)
    } catch {}
}
if ($telegramAtivo) {
    Write-Host "  [n8n W-4] Telegram ativo -- notificacao de encerramento disparada via W-4" -ForegroundColor Green
} else {
    Write-Host "  [n8n W-4] Telegram INATIVO -- configurar D2 ENV_VARS (TELEGRAM_BOT_TOKEN) para ativar" -ForegroundColor DarkGray
    Write-Host "            Apos D2: W-4 envia aviso automatico ao Diretor com lista de arquivos para upload" -ForegroundColor DarkGray
}
Write-Host ""
Write-Host "=======================================================" -ForegroundColor Magenta

exit $exitCode
