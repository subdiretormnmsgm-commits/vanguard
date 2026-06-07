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

$painelMaisRecente = Get-ChildItem "$baseDir\PROTOCOLOS_ENCERRAMENTO" -Filter "PAINEL_ATIVIDADES_*$dataFim*.md" -ErrorAction SilentlyContinue |
                     Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $painelMaisRecente) {
    $painelMaisRecente = Get-ChildItem "$baseDir\PROTOCOLOS_ENCERRAMENTO" -Filter "PAINEL_ATIVIDADES_*.md" -ErrorAction SilentlyContinue |
                         Sort-Object LastWriteTime -Descending | Select-Object -First 1
}
$painelNome = if ($painelMaisRecente) { $painelMaisRecente.Name } else { "PAINEL_ATIVIDADES_$dataFim.md (VERIFICAR)" }

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host "  EMBAIXADOR -- Vanguard" -ForegroundColor Magenta
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  ARQUIVOS PARA ARRASTAR AO EMBAIXADOR (7):" -ForegroundColor Yellow
Write-Host ""
Write-Host "  PROTOCOLOS_ENCERRAMENTO\$painelNome" -ForegroundColor Cyan
Write-Host "  PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataFim.md" -ForegroundColor Cyan
Write-Host "  CLIENTES\WIP_BOARD.json" -ForegroundColor Cyan
Write-Host "  INTELLIGENCE_LEDGER.md" -ForegroundColor Cyan
Write-Host "  PENDENTES.md" -ForegroundColor Cyan
Write-Host "  CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md" -ForegroundColor Cyan
Write-Host "  CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "  ---" -ForegroundColor DarkGray
Write-Host "  MENSAGEM PARA COLAR NO EMBAIXADOR:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Embaixador, fechamento de sessao -- $dataFim." -ForegroundColor White
Write-Host "  Faco upload do PAINEL_ATIVIDADES, CONTEXTO_SESSAO_DIRETOR, WIP_BOARD, INTELLIGENCE_LEDGER, PENDENTES," -ForegroundColor White
Write-Host "  VANGUARD_TIMELINE e MEMORIA_EMBAIXADOR desta sessao." -ForegroundColor White
Write-Host "  Com base nos sete arquivos, gerar o artefato publicavel com:" -ForegroundColor White
Write-Host ""
Write-Host "  0. BRIEFING DE ABERTURA PARA O MUSCULO (gerar primeiro)" -ForegroundColor White
Write-Host "     Paragrafo que o Diretor colara ao abrir a proxima sessao do Claude Code." -ForegroundColor White
Write-Host "     Conter: (a) o que foi entregue hoje e esta ativo, (b) o que ficou em aberto e por que," -ForegroundColor White
Write-Host "     (c) proximo passo esperado do Musculo." -ForegroundColor White
Write-Host '     Escrito na segunda pessoa: "Musculo, na ultima sessao..."' -ForegroundColor White
Write-Host ""
Write-Host "  1. SEMAFORO -- status visual por projeto (vermelho bloqueante / amarelo atencao / verde saudavel)" -ForegroundColor White
Write-Host "  2. DIAGNOSTICO DO DIA -- saude dos projetos ativos + o que avancou hoje" -ForegroundColor White
Write-Host "  3. PREVISAO DOS PROXIMOS DIAS -- data a data com checklist do Diretor" -ForegroundColor White
Write-Host "  4. ANALISE GERENCIAL -- o que voce ve que o Musculo nao ve?" -ForegroundColor White
Write-Host "  5. PROXIMA ACAO DO DIRETOR -- maximo 3 itens em ordem de prioridade" -ForegroundColor White
Write-Host ""
Write-Host "  Ao entregar, incluir instrucao ao Diretor:" -ForegroundColor White
Write-Host '  "Diretor, ao abrir o Claude Code, cole o BLOCO 0 acima como PRIMEIRA mensagem para o Musculo -- antes de qualquer outra coisa."' -ForegroundColor White
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
