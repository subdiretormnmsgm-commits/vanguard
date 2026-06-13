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

# GATE NOTION -- sincronizacao bloqueante (P-128)
# Pendentes abertos + WIP Board + Ledger chegam ao Notion antes de encerrar sessao.
# Roda se exitCode <= 1 (nao roda se sessao ja esta em falha critica exit 2).
if ($exitCode -le 1) {
    $notionSync = Join-Path $PSScriptRoot "notion_sync.ps1"
    Write-Host ""
    Write-Host "  ========================================================" -ForegroundColor Cyan
    Write-Host "  [GATE NOTION] Sincronizando Notion (P-128 -- BLOQUEANTE)" -ForegroundColor Cyan
    Write-Host "  ========================================================" -ForegroundColor Cyan
    if (Test-Path $notionSync) {
        & powershell.exe -NonInteractive -File $notionSync
        if ($LASTEXITCODE -ne 0) {
            Write-Host ""
            Write-Host "  ========================================================" -ForegroundColor Red
            Write-Host "  [GATE NOTION] BLOQUEIO -- notion_sync.ps1 falhou"         -ForegroundColor Red
            Write-Host "  ========================================================" -ForegroundColor Red
            Write-Host "  Sessao nao pode ser declarada encerrada sem Notion atualizado." -ForegroundColor Red
            Write-Host "  Secoes afetadas: Pendentes abertos + WIP Board + Ledger tail"  -ForegroundColor Yellow
            Write-Host "  Para depurar: .\scripts\notion_sync.ps1"                  -ForegroundColor Yellow
            Write-Host "  ========================================================" -ForegroundColor Red
            Write-Host ""
            $exitCode = 2
        } else {
            Write-Host "  [GATE NOTION] VERDE -- Pendentes + WIP + Ledger sincronizados." -ForegroundColor Green
            Write-Host "  ========================================================" -ForegroundColor Cyan
        }
    } else {
        Write-Host "  [GATE NOTION] BLOQUEIO -- notion_sync.ps1 nao encontrado."   -ForegroundColor Red
        Write-Host "  Notion e canal obrigatorio (P-128). Instalar: scripts\notion_sync.ps1" -ForegroundColor Red
        Write-Host "  ========================================================" -ForegroundColor Red
        $exitCode = 2
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

# GATE P-032 / GATE 6B (P-145): MEMORIA_EMBAIXADOR deve ter sido atualizada em todo cliente ativo
# Ordem de verificacao: (1) flag de update_memoria_embaixador.ps1 do dia (evento)
#                       (2) fallback: LastWriteTime da MEMORIA_EMBAIXADOR.md
$wipBoardPath = "$baseDir\CLIENTES\WIP_BOARD.json"
$statusAtivos = @("BUILD","RETAINER","HYPERCARE")
$clientesAtivos = @()
if (Test-Path $wipBoardPath) {
    try {
        $wipObj = Get-Content $wipBoardPath -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($proj in $wipObj.projetos) {
            if ($proj.status -in $statusAtivos) { $clientesAtivos += $proj.cliente.ToUpper() }
        }
    } catch {}
}
# Garantir que VANGUARD sempre esta na lista (projeto interno)
if ("VANGUARD" -notin $clientesAtivos) { $clientesAtivos += "VANGUARD" }

$p032Falhos = @()
foreach ($cli in $clientesAtivos) {
    $flagHoje = "$baseDir\scripts\.memoria_atualizada_hoje_$cli.flag"
    $memoriaPath = "$baseDir\CLIENTES\$cli\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR*.md"
    $memoriaOk = $false

    # Verificacao primaria: flag do dia (update_memoria_embaixador.ps1 rodou)
    if (Test-Path $flagHoje) {
        $flagData = (Get-Item $flagHoje).LastWriteTime.Date
        if ($flagData -eq (Get-Date).Date) { $memoriaOk = $true }
    }

    # Fallback: LastWriteTime do arquivo MEMORIA_EMBAIXADOR
    if (-not $memoriaOk) {
        $memoriaFiles = Get-Item $memoriaPath -ErrorAction SilentlyContinue
        if ($memoriaFiles) {
            $arq = $memoriaFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1
            if ($arq.LastWriteTime.Date -eq (Get-Date).Date) { $memoriaOk = $true }
        }
    }

    if (-not $memoriaOk) { $p032Falhos += $cli }
}

if ($p032Falhos.Count -gt 0) {
    Write-Host ""
    Write-Host "  ========================================================" -ForegroundColor Red
    Write-Host "  [GATE P-032 / GATE 6B] BLOQUEIO -- MEMORIA desatualizada" -ForegroundColor Red
    Write-Host "  ========================================================" -ForegroundColor Red
    Write-Host "  Clientes sem MEMORIA_EMBAIXADOR atualizada hoje:" -ForegroundColor Red
    foreach ($cli in $p032Falhos) {
        Write-Host "    - $cli" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "  Correcao rapida (por cliente):" -ForegroundColor Yellow
    Write-Host "    .\scripts\update_memoria_embaixador.ps1 -Cliente [X] -Passo 7 -Resumo 'resumo do dia'" -ForegroundColor Cyan
    Write-Host "  ========================================================" -ForegroundColor Red
    Write-Host ""
    $exitCode = 2
}

# GATE EMAIL -- e-mail de fechamento deve ter sido enviado antes de encerrar
$emailBodyPath = Join-Path $baseDir "scripts\.email_body.txt"
$emailSentFlag = Join-Path $baseDir "scripts\.email_sent_$dataHoje.flag"

if (Test-Path $emailBodyPath) {
    # Body existe mas nao foi enviado -- disparar automaticamente
    Write-Host ""
    Write-Host "  [EMAIL] .email_body.txt encontrado -- disparando email_fechamento.ps1 automaticamente..." -ForegroundColor Cyan
    $emailScript = Join-Path $baseDir "scripts\email_fechamento.ps1"
    & powershell.exe -NonInteractive -File $emailScript
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  [GATE EMAIL] Falha no envio -- verificar SMTP." -ForegroundColor Red
        Write-Host "  Rodar manualmente: .\scripts\email_fechamento.ps1" -ForegroundColor Yellow
        $exitCode = 2
    }
} elseif (-not (Test-Path $emailSentFlag)) {
    # Nem body nem flag de envio -- email nunca foi preparado
    Write-Host ""
    Write-Host "  ========================================================" -ForegroundColor Red
    Write-Host "  [GATE EMAIL] BLOQUEIO -- E-mail nao preparado nem enviado" -ForegroundColor Red
    Write-Host "  ========================================================" -ForegroundColor Red
    Write-Host "  scripts\.email_body.txt nao encontrado." -ForegroundColor Red
    Write-Host "  Musculo: escrever scripts\.email_body.txt e rodar email_fechamento.ps1" -ForegroundColor Red
    Write-Host "  Conteudo obrigatorio:" -ForegroundColor Yellow
    Write-Host "    (a) entregas do dia com status" -ForegroundColor Yellow
    Write-Host "    (b) alertas emitidos" -ForegroundColor Yellow
    Write-Host "    (c) proximo gate e prazo" -ForegroundColor Yellow
    Write-Host "    (d) o que o Diretor faz antes da proxima sessao" -ForegroundColor Yellow
    Write-Host "    (e) previsao dos proximos dias" -ForegroundColor Yellow
    Write-Host "  ========================================================" -ForegroundColor Red
    $exitCode = 2
}
# Se $emailSentFlag existir -- email ja foi enviado hoje -- gate OK, silencio total

# GATE EMBAIXADOR FORMAT -- mensagem ao Embaixador segue formato canonico (BLOQUEANTE)
# Formato exigido pelo Diretor em 2026-06-13.
# Musculo escreve DESTAQUES + PENDENCIAS em scripts\embaixador_msg_sessao.txt.
# Gate valida, auto-completa header + lista 7 arquivos + secoes 0-5 e exibe mensagem pronta.
$dataFim   = Get-Date -Format "yyyy-MM-dd"
$dataFimBR = Get-Date -Format "dd/MM/yyyy"
$diaSem    = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))

$painelMaisRecente = Get-ChildItem "$baseDir\PROTOCOLOS_ENCERRAMENTO" -Filter "PAINEL_ATIVIDADES_*$dataFim*.md" -ErrorAction SilentlyContinue |
                     Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $painelMaisRecente) {
    $painelMaisRecente = Get-ChildItem "$baseDir\PROTOCOLOS_ENCERRAMENTO" -Filter "PAINEL_ATIVIDADES_*.md" -ErrorAction SilentlyContinue |
                         Sort-Object LastWriteTime -Descending | Select-Object -First 1
}
$painelNome = if ($painelMaisRecente) { $painelMaisRecente.Name } else { "PAINEL_ATIVIDADES_$dataFim.md (AUSENTE)" }

$arq1 = "PROTOCOLOS_ENCERRAMENTO\$painelNome"
$arq2 = "PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataFim.md"
$arq3 = "CLIENTES\WIP_BOARD.json"
$arq4 = "INTELLIGENCE_LEDGER.md"
$arq5 = "PENDENTES.md"
$arq6 = "CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
$arq7 = "CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md"

# GATE 7C -- FRESCOR DOS 7 ARQUIVOS DO EMBAIXADOR (BLOQUEANTE)
# Verifica LastWriteTime de cada arquivo. Nenhum pode ter data anterior a hoje.
# "So prossegue com dados atualizados" -- Diretor 2026-06-13.
Write-Host ""
Write-Host "  =======================================================" -ForegroundColor Cyan
Write-Host "  [GATE 7C] Frescor dos 7 Arquivos para o Embaixador"    -ForegroundColor Cyan
Write-Host "  Referencia: $dataFim ($(Get-Date -Format 'HH:mm'))"    -ForegroundColor Cyan
Write-Host "  =======================================================" -ForegroundColor Cyan
Write-Host ""

$dataHojeDate7c = (Get-Date).Date
$stale7c = [System.Collections.Generic.List[string]]::new()

$mapa7c = [ordered]@{
    "1. PAINEL_ATIVIDADES"           = if ($painelMaisRecente) { $painelMaisRecente.FullName } else { "$baseDir\PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_$dataFim.md" }
    "2. CONTEXTO_SESSAO_DIRETOR"     = "$baseDir\PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataFim.md"
    "3. WIP_BOARD.json"              = "$baseDir\CLIENTES\WIP_BOARD.json"
    "4. INTELLIGENCE_LEDGER.md"      = "$baseDir\INTELLIGENCE_LEDGER.md"
    "5. PENDENTES.md"                = "$baseDir\PENDENTES.md"
    "6. 16_VANGUARD_TIMELINE.md"     = "$baseDir\CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
    "7. MEMORIA_EMBAIXADOR_VANGUARD" = "$baseDir\CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md"
}

foreach ($entry in $mapa7c.GetEnumerator()) {
    $lbl  = $entry.Key
    $path = $entry.Value
    if (Test-Path $path) {
        $lwt  = (Get-Item $path).LastWriteTime
        $ts   = $lwt.ToString("yyyy-MM-dd HH:mm")
        if ($lwt.Date -ge $dataHojeDate7c) {
            Write-Host ("  [OK    ] {0,-44} {1}" -f $lbl, $ts) -ForegroundColor Green
        } else {
            Write-Host ("  [STALE ] {0,-44} {1}" -f $lbl, $ts) -ForegroundColor Red
            $stale7c.Add($lbl)
        }
    } else {
        Write-Host ("  [AUSENTE] {0,-44} ARQUIVO NAO ENCONTRADO" -f $lbl) -ForegroundColor Red
        $stale7c.Add($lbl)
    }
}

Write-Host ""
if ($stale7c.Count -gt 0) {
    Write-Host "  =======================================================" -ForegroundColor Red
    Write-Host "  [GATE 7C] BLOQUEIO -- $($stale7c.Count) arquivo(s) desatualizado(s)" -ForegroundColor Red
    Write-Host "  =======================================================" -ForegroundColor Red
    foreach ($sl in $stale7c) {
        Write-Host "    >> $sl" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "  Musculo: atualizar os arquivos acima antes de rodar session_close novamente." -ForegroundColor Yellow
    Write-Host "  =======================================================" -ForegroundColor Red
    Write-Host ""
    $exitCode = 2
} else {
    Write-Host "  [GATE 7C] VERDE -- todos os 7 arquivos atualizados hoje." -ForegroundColor Green
    Write-Host "  =======================================================" -ForegroundColor Cyan
}
Write-Host ""

# Detectar loop + cliente para o header
$loopLabel = ""
try {
    $wipRaw = Get-Content "$baseDir\CLIENTES\WIP_BOARD.json" -Raw -Encoding UTF8
    $wipObj = $wipRaw | ConvertFrom-Json -ErrorAction SilentlyContinue
    $projAtivo = @($wipObj.board.build) | Select-Object -First 1
    if ($projAtivo -and $projAtivo.loop_atual) {
        $loopLabel = " -- " + $projAtivo.loop_atual + " " + $projAtivo.cliente.ToUpper()
    }
} catch {}

$msgAdaptadaPath = Join-Path $baseDir "scripts\embaixador_msg_sessao.txt"

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host "  GATE EMBAIXADOR -- Formato Canonico (BLOQUEANTE)"    -ForegroundColor Magenta
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host ""

if (-not (Test-Path $msgAdaptadaPath)) {
    Write-Host "  [GATE EMBAIXADOR] BLOQUEIO -- embaixador_msg_sessao.txt nao encontrado." -ForegroundColor Red
    Write-Host ""
    Write-Host "  Musculo: criar scripts\embaixador_msg_sessao.txt com no minimo:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    DESTAQUES DESTA SESSAO:" -ForegroundColor Yellow
    Write-Host "    - [entrega 1 com status]" -ForegroundColor Yellow
    Write-Host "    - [entrega 2 com status]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    PENDENCIAS DO DIRETOR:" -ForegroundColor Yellow
    Write-Host "    - [acao 1 (prazo)]" -ForegroundColor Yellow
    Write-Host "    - [acao 2 (prazo)]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Gate auto-completa: header + lista numerada 7 arquivos + secoes 0-5 + instrucao final." -ForegroundColor DarkGray
    Write-Host ""
    $exitCode = 2
} else {
    $msgContent = Get-Content $msgAdaptadaPath -Raw -Encoding UTF8

    $temDestaques  = $msgContent -match "DESTAQUES DESTA SESS"
    $temPendencias = $msgContent -match "PEND.NCIAS DO DIRETOR|PENDENCIAS DO DIRETOR"
    $formatOk      = $true

    if (-not $temDestaques) {
        Write-Host "  [GATE EMBAIXADOR] BLOQUEIO -- secao 'DESTAQUES DESTA SESSAO' ausente." -ForegroundColor Red
        $formatOk = $false
    }
    if (-not $temPendencias) {
        Write-Host "  [GATE EMBAIXADOR] BLOQUEIO -- secao 'PENDENCIAS DO DIRETOR' ausente." -ForegroundColor Red
        $formatOk = $false
    }

    if (-not $formatOk) {
        Write-Host ""
        Write-Host "  Formato minimo obrigatorio do embaixador_msg_sessao.txt:" -ForegroundColor Yellow
        Write-Host "    DESTAQUES DESTA SESSAO:" -ForegroundColor Yellow
        Write-Host "    - [lista de entregas com status]" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "    PENDENCIAS DO DIRETOR:" -ForegroundColor Yellow
        Write-Host "    - [acoes pendentes do Diretor com prazo]" -ForegroundColor Yellow
        Write-Host ""
        $exitCode = 2
    } else {
        # Extrair corpo contextual (pular header se existir)
        $linhasArq = @(Get-Content $msgAdaptadaPath -Encoding UTF8)
        $corpoIdx  = 0
        if ($linhasArq.Count -gt 0 -and ($linhasArq[0] -match "Embaixador.*fechamento|fechamento.*sess")) { $corpoIdx = 1 }
        while ($corpoIdx -lt $linhasArq.Count -and [string]::IsNullOrWhiteSpace($linhasArq[$corpoIdx])) { $corpoIdx++ }
        $corpo = if ($corpoIdx -lt $linhasArq.Count) {
            ($linhasArq[$corpoIdx..($linhasArq.Count-1)] -join "`n").Trim()
        } else { $msgContent.Trim() }

        # Construir mensagem completa no formato canonico do Diretor
        $msgCompleta  = "Embaixador, fechamento de sessao -- $dataFimBR ($diaSem)$loopLabel`n`n"
        $msgCompleta += "Faco upload dos 7 arquivos abaixo (todos atualizados hoje):`n"
        $msgCompleta += "1. $arq1`n"
        $msgCompleta += "2. $arq2`n"
        $msgCompleta += "3. $arq3`n"
        $msgCompleta += "4. $arq4`n"
        $msgCompleta += "5. $arq5`n"
        $msgCompleta += "6. $arq6`n"
        $msgCompleta += "7. $arq7`n`n"
        $msgCompleta += "$corpo`n`n"
        $msgCompleta += "Com base nos 7 arquivos, gerar:`n`n"
        $msgCompleta += "0. BRIEFING DE ABERTURA PARA O MUSCULO`n"
        $msgCompleta += "1. SEMAFORO por projeto`n"
        $msgCompleta += "2. DIAGNOSTICO DO DIA`n"
        $msgCompleta += "3. PREVISAO DOS PROXIMOS DIAS`n"
        $msgCompleta += "4. ANALISE GERENCIAL`n"
        $msgCompleta += "5. PROXIMA ACAO DO DIRETOR (maximo 3 itens)`n`n"
        $msgCompleta += '"Diretor, ao abrir o Claude Code, cole o BLOCO 0 como PRIMEIRA mensagem."'

        # Exibir lista de arquivos
        Write-Host "  ARQUIVOS PARA ARRASTAR AO EMBAIXADOR (7):" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  1. $arq1" -ForegroundColor Cyan
        Write-Host "  2. $arq2" -ForegroundColor Cyan
        Write-Host "  3. $arq3" -ForegroundColor Cyan
        Write-Host "  4. $arq4" -ForegroundColor Cyan
        Write-Host "  5. $arq5" -ForegroundColor Cyan
        Write-Host "  6. $arq6" -ForegroundColor Cyan
        Write-Host "  7. $arq7" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  ---" -ForegroundColor DarkGray
        Write-Host "  MENSAGEM COMPLETA -- COLAR NO EMBAIXADOR:" -ForegroundColor Yellow
        Write-Host ""

        # Exibir mensagem linha a linha
        $msgCompleta -split "`n" | ForEach-Object { Write-Host "  $_" -ForegroundColor White }

        # Limpar arquivo apos exibir
        Remove-Item $msgAdaptadaPath -Force -ErrorAction SilentlyContinue
        Write-Host ""
        Write-Host "  [GATE EMBAIXADOR] VERDE -- mensagem exibida no formato canonico." -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Magenta

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

# LOOP TRANSCRIPT (M-2 P-141) -- gerar para cada cliente ativo com loop CONCLUIDO
$transcriptScript = Join-Path $PSScriptRoot "generate_loop_transcript.ps1"
if ((Test-Path $transcriptScript) -and $exitCode -eq 0) {
    if (Test-Path $wipBoardPath) {
        try {
            $wipForTranscript = Get-Content $wipBoardPath -Raw -Encoding UTF8 | ConvertFrom-Json
            foreach ($projT in $wipForTranscript.projetos) {
                if ($projT.status -notin @("BUILD","RETAINER","HYPERCARE")) { continue }
                $cliT = $projT.cliente.ToUpper()
                $lsPathT = "$baseDir\CLIENTES\$cliT\CLAUDE_PROJECT\LOOP_STATE.json"
                if (-not (Test-Path $lsPathT)) { continue }
                $lsT = Get-Content $lsPathT -Raw -Encoding UTF8 | ConvertFrom-Json
                # Gerar transcript apenas se loop CONCLUIDO ou ENCERRADO (nao EXECUCAO em andamento)
                $statusValidos = @("CONCLUIDO","VEREDITO_CONFIRMADO","LOOP_ENCERRADO")
                if ($lsT.loop_status -notin $statusValidos) { continue }
                $transcriptJaExiste = Test-Path "$baseDir\CLIENTES\$cliT\HISTORICO\LOOP_TRANSCRIPT_V$($lsT.loop_atual)_$($cliT.ToLower()).md"
                if ($transcriptJaExiste) { continue }
                Write-Host "  [M-2] Gerando LOOP_TRANSCRIPT_V$($lsT.loop_atual) para $cliT..." -ForegroundColor Cyan
                & powershell.exe -NonInteractive -File $transcriptScript -Cliente $cliT -Loop $lsT.loop_atual 2>$null
            }
        } catch {}
    }
}

exit $exitCode
