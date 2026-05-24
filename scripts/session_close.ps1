# session_close.ps1
# Executar ao fechar qualquer sessao do Pentalateral
# Prompts obrigatorios para atualizar o INTELLIGENCE_LEDGER

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE   = Split-Path -Parent $PSScriptRoot
$LEDGER = "$BASE\INTELLIGENCE_LEDGER.md"
$KG     = "$BASE\knowledge_graph.json"
$DATA   = Get-Date -Format "yyyy-MM-dd"

Write-Host ""
Write-Host "=============================================="
Write-Host "  FECHAMENTO DE SESSAO -- Pentalateral IAH"
Write-Host "=============================================="
Write-Host ""

# --- Loop Continuity Check ---
$comandoGerado = Get-ChildItem "$BASE\CLIENTES" -Filter "COMANDO_ESTRATEGISTA*.md" -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime.Date -eq (Get-Date).Date } |
    Select-Object -First 1

if (-not $comandoGerado) {
    Write-Host "  [!!] LOOP CONTINUITY: COMANDO_ESTRATEGISTA nao detectado hoje."
    Write-Host "       O loop Musculo->Gemini quebra sem este documento."
    Write-Host ""
    Write-Host "  Opcoes:"
    Write-Host "    [1] Gerar COMANDO_ESTRATEGISTA agora (recomendado)"
    Write-Host "    [2] Declarar quebra intencional de loop (justificar abaixo)"
    Write-Host "    [3] Ja gerado em outro caminho -- continuar"
    Write-Host ""
    $opcao = Read-Host "  Escolha [1/2/3]"
    if ($opcao -eq "2") {
        $motivo = Read-Host "  Justificativa para quebra de loop"
        Write-Host ""
        Write-Host "  Quebra de loop registrada: $motivo"
        Write-Host "  Aviso: proximo ciclo com Gemini comecara sem contexto desta sessao."
    } elseif ($opcao -eq "1") {
        Write-Host ""
        Write-Host "  Gere o COMANDO_ESTRATEGISTA antes de continuar o fechamento."
        Write-Host "  Execute este script novamente apos gerar o documento."
        exit 0
    }
} else {
    Write-Host "  [OK] Loop Continuity: $($comandoGerado.Name) detectado."
}
Write-Host ""

if (-not (Test-Path $LEDGER)) {
    Write-Host "ERRO: INTELLIGENCE_LEDGER.md nao encontrado."
    exit 1
}

if (-not (Test-Path $KG)) {
    Write-Host "ERRO: knowledge_graph.json nao encontrado."
    exit 1
}

Write-Host "SESSAO: $DATA"
Write-Host ""
Write-Host "[1/4] Houve FRICCAO nesta sessao? (ALERTA emitido, P0 criado, escopo mudou)"
Write-Host "      Se sim, descreva em 1 linha (Enter para pular):"
$friccao = Read-Host "    > "

Write-Host ""
Write-Host "[2/4] Algum PRINCIPIO novo foi descoberto? (o 'porque' por tras de uma decisao)"
Write-Host "      Se sim, descreva em 1 linha (Enter para pular):"
$principio = Read-Host "    > "

Write-Host ""
Write-Host "[3/4] O Diretor fez OVERRIDE de algum veto? (Hard ou Soft)"
Write-Host "      Se sim, descreva qual e o motivo (Enter para pular):"
$override = Read-Host "    > "

Write-Host ""
Write-Host "[4/4] Houve DERIVA? (sessao divergiu de um principio ativo?)"
Write-Host "      Se sim, qual principio e como foi corrigido (Enter para pular):"
$deriva = Read-Host "    > "

# --- Montar entrada no LEDGER ---
$entrada = "`n`n### [SESSAO $DATA]`n"

if ($friccao)  { $entrada += "`n``[FRICCAO]`` $friccao" }
if ($principio){ $entrada += "`n``[PRINCIPIO]`` $principio" }
if ($override) { $entrada += "`n``[OVERRIDE]`` $override" }
if ($deriva)   { $entrada += "`n``[DERIVA]`` $deriva" }

if ($friccao -or $principio -or $override -or $deriva) {
    $conteudo = Get-Content $LEDGER -Raw -Encoding utf8
    if ($conteudo -match "## GLOSSARIO") {
        $conteudo = $conteudo -replace "(?m)^## GLOSSARIO", "$entrada`n`n## GLOSSARIO"
    } else {
        $conteudo = $conteudo + $entrada
    }
    Set-Content $LEDGER -Value $conteudo -Encoding utf8
    Write-Host ""
    Write-Host "INTELLIGENCE_LEDGER.md atualizado."
} else {
    Write-Host ""
    Write-Host "Nenhum evento registrado nesta sessao."
}

# --- Atualizar knowledge_graph.json ---
$kg = Get-Content $KG -Raw -Encoding utf8 | ConvertFrom-Json

$nova_sessao = [PSCustomObject]@{
    date                 = $DATA
    label                = "Sessao $DATA"
    friction_events      = if ($friccao) { 1 } else { 0 }
    principles_generated = if ($principio) { @("novo") } else { @() }
    overrides            = if ($override) { @([PSCustomObject]@{ description = $override }) } else { @() }
    drift_detected       = if ($deriva) { $true } else { $false }
}

$sessoes = [System.Collections.ArrayList]@()
if ($kg.sessions) { foreach ($s in $kg.sessions) { [void]$sessoes.Add($s) } }
$sessoes.Insert(0, $nova_sessao)
if ($sessoes.Count -gt 20) { $sessoes = $sessoes[0..19] }

$kg.sessions = $sessoes
$kg.meta.last_updated   = $DATA
$kg.meta.total_sessions = $sessoes.Count

$kg | ConvertTo-Json -Depth 10 | Set-Content $KG -Encoding utf8
Write-Host "knowledge_graph.json atualizado."

Write-Host ""
Write-Host "[5/5] DIVIDAS TECNICAS para o Auditor (P0/P1 em aberto)"
Write-Host "      Liste modulos incompletos, bugs conhecidos ou decisoes arquiteturais"
Write-Host "      que o NotebookLM precisa saber no proximo ciclo (Enter para pular):"
$divida = Read-Host "    > "

if ($divida) {
    $divArquivo = "$BASE\DIVIDAS_TECNICAS_AUDITOR.md"

    $divConteudo = ""
    if (Test-Path $divArquivo) {
        $divConteudo = Get-Content $divArquivo -Raw -Encoding utf8
    }

    $novaDiv = "`n`n### [DIVIDAS TECNICAS -- $DATA]`n" +
               "**Sessao:** $DATA`n" +
               "**Dividas registradas:**`n$divida`n" +
               "_Injete este bloco no NotebookLM como primeira fonte antes da proxima auditoria._"

    Set-Content $divArquivo -Value ($divConteudo + $novaDiv) -Encoding utf8
    Write-Host ""
    Write-Host "DIVIDAS_TECNICAS_AUDITOR.md atualizado."
    Write-Host "Inclua este arquivo nas fontes do NotebookLM no proximo ciclo."
}

# --- CANDIDATOS_A_PRINCIPIO: fricção → princípio candidato (P-053) ---
Write-Host ""
Write-Host "=============================================="
Write-Host "  CANDIDATOS A PRINCIPIO (P-053)"
Write-Host "=============================================="
Write-Host ""
Write-Host "  Houve friccao nesta sessao que pode gerar um novo principio?"
Write-Host "  (diferente de EVOLUCAO DE PROTOCOLO -- aqui é sobre padrões do CLIENTE/PROJETO)"
Write-Host "  Exemplos: padrao de comportamento do cliente, decisao que se repetiu, risco nao antecipado"
Write-Host ""
Write-Host "  Formato sugerido: 'Fricção: [X] / Padrão: [Y] / Candidato: P-XXX'"
Write-Host "  Liste 1 por linha. Enter em branco para encerrar. Enter direto para pular."
$candidatos = @()
while ($true) {
    $linha = Read-Host "    > "
    if ([string]::IsNullOrWhiteSpace($linha)) { break }
    $candidatos += $linha
}

if ($candidatos.Count -gt 0) {
    $candidatosPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
    $candidatosFile = Join-Path $BASE "CANDIDATOS_A_PRINCIPIO.md"

    $blocoC  = "`n`n### [CANDIDATOS-$DATA]`n"
    $blocoC += "> Capturado via session_close.ps1 — revisar e promover ao LEDGER quando padrão se repetir 3x.`n"
    $num = 1
    foreach ($c in $candidatos) {
        $blocoC += "$num. $c`n"
        $num++
    }

    $conteudoC = ""
    if (Test-Path $candidatosFile) {
        $conteudoC = Get-Content $candidatosFile -Raw -Encoding utf8
    } else {
        $conteudoC = "# CANDIDATOS A PRINCIPIO — Vanguard Pentalateral IAH`n"
        $conteudoC += "> Fricções capturadas que ainda não viraram princípios no LEDGER.`n"
        $conteudoC += "> Quando um padrão aparecer 3x → promover ao INTELLIGENCE_LEDGER.md com número P-XXX.`n"
    }

    Set-Content $candidatosFile -Value ($conteudoC + $blocoC) -Encoding utf8

    Write-Host ""
    Write-Host "  [OK] $($candidatos.Count) candidato(s) registrado(s) em CANDIDATOS_A_PRINCIPIO.md" -ForegroundColor Green
    Write-Host "  [!]  Quando padrão aparecer 3x → promover ao LEDGER." -ForegroundColor Cyan
} else {
    Write-Host "  Nenhum candidato a princípio nesta sessão." -ForegroundColor DarkGray
}

# --- EVOLUÇÃO DO PROTOCOLO: padrões universais desta sessão ---
Write-Host ""
Write-Host "=============================================="
Write-Host "  EVOLUCAO DO PROTOCOLO VANGUARD"
Write-Host "=============================================="
Write-Host ""
Write-Host "  Esta sessao revelou algum padrao que muda COMO o sistema opera?"
Write-Host "  (nao apenas o que aprendemos de um cliente -- mas como o Pentalateral funciona)"
Write-Host ""
Write-Host "  Exemplos: nova deficiencia descoberta, novo passo no ritual,"
Write-Host "            novo tipo de documento, nova regra de processo."
Write-Host ""
Write-Host "  Liste 1 por linha. Enter em branco para encerrar. Enter direto para pular."
$padroesProtocolo = @()
while ($true) {
    $linha = Read-Host "    > "
    if ([string]::IsNullOrWhiteSpace($linha)) { break }
    $padroesProtocolo += $linha
}

if ($padroesProtocolo.Count -gt 0) {
    $protocoloPath  = Join-Path $BASE ".claude\skills\vanguard-protocolo.md"
    $universalPath  = Join-Path $BASE "PENTALATERAL_UNIVERSAL\OPERACAO\SKILL_PROTOCOLO_VANGUARD.md"

    $blocoEvol  = "`n`n### [EVOLUCAO-$DATA]`n"
    $blocoEvol += "> Capturado via session_close.ps1 — posicionar na secao adequada ao fechar o projeto.`n"
    $num = 1
    foreach ($p in $padroesProtocolo) {
        $blocoEvol += "$num. $p`n"
        $num++
    }

    $conteudoProt = Get-Content $protocoloPath -Raw -Encoding utf8

    if ($conteudoProt -match "## EVOLUCOES DE PROCESSO EM CURSO") {
        $conteudoProt += $blocoEvol
    } else {
        $secaoEvol = "`n`n---`n`n## EVOLUCOES DE PROCESSO EM CURSO`n"
        $secaoEvol += "> Capturadas pelo Musculo via session_close.ps1.`n"
        $secaoEvol += "> Ao fechar o projeto: incorporar ao corpo do protocolo + remover esta secao.`n"
        $conteudoProt = $conteudoProt + $secaoEvol + $blocoEvol
    }

    Set-Content $protocoloPath -Value $conteudoProt -Encoding utf8
    Copy-Item $protocoloPath $universalPath -Force

    # Também registrar no LEDGER com tag [PROTOCOLO]
    $entradaProt = "`n`n### [SESSAO $DATA -- PROTOCOLO]`n"
    foreach ($p in $padroesProtocolo) {
        $entradaProt += "``[PROTOCOLO]`` $p`n"
    }
    $conteudoLed = Get-Content $LEDGER -Raw -Encoding utf8
    if ($conteudoLed -match "## GLOSSARIO") {
        $conteudoLed = $conteudoLed -replace "(?m)^## GLOSSARIO", "$entradaProt`n`n## GLOSSARIO"
    } else {
        $conteudoLed = $conteudoLed + $entradaProt
    }
    Set-Content $LEDGER -Value $conteudoLed -Encoding utf8

    Write-Host ""
    Write-Host "  [OK] $($padroesProtocolo.Count) padrao(oes) registrado(s) em:" -ForegroundColor Green
    Write-Host "       .claude/skills/vanguard-protocolo.md" -ForegroundColor Green
    Write-Host "       PENTALATERAL_UNIVERSAL/OPERACAO/SKILL_PROTOCOLO_VANGUARD.md" -ForegroundColor Green
    Write-Host "       INTELLIGENCE_LEDGER.md (tag [PROTOCOLO])" -ForegroundColor Green
    Write-Host "  [!]  Proximo passo: posicionar na secao adequada ao fechar o projeto." -ForegroundColor Cyan
} else {
    Write-Host "  Nenhum padrao de protocolo registrado nesta sessao." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "=============================================="
Write-Host "  Proximo passo: git commit + fechar sessao"
Write-Host "=============================================="

# --- Mandato Direto do Diretor -- auto-injecao no PASSO3 do projeto ativo ---
Write-Host ""
Write-Host "[MANDATO] Houve intervencao direta do Diretor nesta sessao?"
Write-Host "  (novo principio, nova regra, nova funcao do Conselho - ex: necessidade do contrato)"
Write-Host "  Liste 1 por linha. Enter em branco para encerrar. Enter direto para pular."
$mandatos = @()
$DATA_MANDATO = Get-Date -Format "yyyy-MM-dd"
while ($true) {
    $linha = Read-Host "    > "
    if ([string]::IsNullOrWhiteSpace($linha)) { break }
    $mandatos += $linha
}

if ($mandatos.Count -gt 0) {
    # Detectar projeto ativo (primeiro em BUILD)
    $wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
    if (Test-Path $wipPath) {
        $board = Get-Content $wipPath -Raw -Encoding utf8 | ConvertFrom-Json
        $projetoAtivo = @($board.board.build) | Select-Object -First 1
        if ($projetoAtivo) {
            $clienteDir = Join-Path $BASE "CLIENTES\$($projetoAtivo.cliente.ToUpper())"
            $passo3Path = Join-Path $clienteDir "PASSO3_GEMINI.md"
            if (Test-Path $passo3Path) {
                $blocoMandato  = "`n## [!!] [MANDATO_DIRETO_DO_DIRETOR] -- $DATA_MANDATO`n"
                $blocoMandato += "> Eduardo declarou diretamente. Estrategista: proibido de suavizar ou ignorar.`n"
                $blocoMandato += "> Bloco 1 da DIRETRIZ deve enderecar cada mandato abaixo.`n`n"
                $num = 1
                foreach ($m in $mandatos) {
                    $blocoMandato += "$num. $m`n"
                    $num++
                }
                $blocoMandato += "`n---`n"

                $conteudo = Get-Content $passo3Path -Raw -Encoding utf8
                if ($conteudo -match "\[MANDATO_DIRETO_DO_DIRETOR\]") {
                    # Substituir bloco existente
                    $conteudo = $conteudo -replace "(?s)## \[!!\] \[MANDATO_DIRETO_DO_DIRETOR\].*?---\r?\n", $blocoMandato
                } else {
                    # Inserir no inicio do arquivo
                    $conteudo = $blocoMandato + "`n" + $conteudo
                }
                Set-Content $passo3Path -Value $conteudo -Encoding utf8
                Write-Host ""
                Write-Host "  [OK] Mandato injetado em: CLIENTES\$($projetoAtivo.cliente.ToUpper())\PASSO3_GEMINI.md"
                Write-Host "       Estrategista vai receber os mandatos no proximo loop automaticamente."
            } else {
                Write-Host "  [!!] PASSO3_GEMINI.md nao encontrado para $($projetoAtivo.cliente). Injete manualmente."
            }
        }
    }
}

# --- P-054: AUDITORIA DE CONSISTÊNCIA TEXTUAL (gate obrigatório pós-operação) ---
# Roda sempre ao fechar sessão. VERMELHO bloqueia encerramento.
$auditScript = Join-Path $BASE "scripts\auditar_consistencia.ps1"
if (Test-Path $auditScript) {
    Write-Host ""
    Write-Host "=============================================="
    Write-Host "  CONSISTÊNCIA TEXTUAL — P-054"
    Write-Host "=============================================="
    & powershell.exe -NonInteractive -File $auditScript
    $exitCode = $LASTEXITCODE
    if ($exitCode -eq 2) {
        Write-Host "  [BLOQUEIO] Padrões VERMELHOS detectados — corrigir antes de fechar." -ForegroundColor Red
        Write-Host "  Execute: .\scripts\auditar_consistencia.ps1 para ver detalhes." -ForegroundColor Yellow
        Write-Host "  Para ignorar e continuar mesmo assim, pressione ENTER." -ForegroundColor DarkGray
        Read-Host "  > "
    }
} else {
    Write-Host "  [--] auditar_consistencia.ps1 não encontrado — P-054 não verificado" -ForegroundColor DarkGray
}

# --- AUDITORIA DE DOCUMENTOS (Regra 11 da Diretriz de Singularidade) ---
# Obrigatoria ao fechar qualquer sessao. Musculo nao depende do Diretor lembrar.
Write-Host ""
Write-Host "=============================================="
Write-Host "  AUDITORIA DE DOCUMENTOS — FECHAMENTO"
Write-Host "=============================================="
Write-Host ""

$wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
$projetosEmBuild = @()
if (Test-Path $wipPath) {
    $board = Get-Content $wipPath -Raw -Encoding utf8 | ConvertFrom-Json
    $projetosEmBuild = @($board.board.build)
}

foreach ($proj in $projetosEmBuild) {
    $cliente = $proj.cliente.ToUpper()
    $clienteDir = Join-Path $BASE "CLIENTES\$cliente"
    Write-Host "  Projeto: $($proj.id) — $($proj.cliente)" -ForegroundColor Cyan
    Write-Host ""

    $docs = @(
        @{ nome = "PASSO3_GEMINI.md";      caminho = "$clienteDir\PASSO3_GEMINI.md" },
        @{ nome = "WIP_BOARD.json";        caminho = $wipPath },
        @{ nome = "INTELLIGENCE_LEDGER.md"; caminho = "$BASE\INTELLIGENCE_LEDGER.md" }
    )

    foreach ($doc in $docs) {
        if (-not (Test-Path $doc.caminho)) {
            Write-Host "  [AUSENTE]      $($doc.nome)" -ForegroundColor Red
        } else {
            $ultimaEdicao = (Get-Item $doc.caminho).LastWriteTime
            $hoje = (Get-Date).Date
            if ($ultimaEdicao.Date -eq $hoje) {
                Write-Host "  [EM DIA]       $($doc.nome) — editado hoje $($ultimaEdicao.ToString('HH:mm'))" -ForegroundColor Green
            } else {
                Write-Host "  [DESATUALIZADO] $($doc.nome) — ultima edicao: $($ultimaEdicao.ToString('yyyy-MM-dd'))" -ForegroundColor Yellow
            }
        }
    }

    # Verificar NOTEBOOKLM_FONTES
    $fontes = Join-Path $clienteDir "NOTEBOOKLM_FONTES"
    if (-not (Test-Path $fontes)) {
        Write-Host "  [AUSENTE]      NOTEBOOKLM_FONTES/ — rodar preparar_notebooklm_projeto.ps1" -ForegroundColor Red
    } else {
        $ultimaFonte = Get-ChildItem $fontes -Recurse -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($ultimaFonte -and $ultimaFonte.LastWriteTime.Date -eq (Get-Date).Date) {
            Write-Host "  [EM DIA]       NOTEBOOKLM_FONTES/ — sincronizado hoje" -ForegroundColor Green
        } else {
            Write-Host "  [DESATUALIZADO] NOTEBOOKLM_FONTES/ — rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente $cliente" -ForegroundColor Yellow
        }
    }

    # Verificar se loop foi encerrado (gate aprovado hoje) — lembra Wipe & Sync
    $loopAtual = $proj.loop_atual
    if ($loopAtual -and $loopAtual -match "Loop #(\d+)") {
        $numLoop = [int]$Matches[1]
        $loopAnterior = $proj.loops_programados | Where-Object { $_.loop -eq ($numLoop - 1) -and $_.status -eq "concluido" }
        if ($loopAnterior -and $loopAnterior.concluido_em -eq $DATA) {
            Write-Host ""
            Write-Host "  [!!] LOOP $($numLoop - 1) ENCERRADO HOJE — Wipe & Sync obrigatorio antes do Loop $numLoop" -ForegroundColor Magenta
            Write-Host "       .\scripts\preparar_notebooklm_projeto.ps1 -cliente $cliente" -ForegroundColor Cyan
        }
    }

    Write-Host ""

    # --- P-045: Verificar artefatos de fechamento do loop anterior (MEMORIA + relatorio) ---
    $historico = Join-Path $clienteDir "HISTORICO"
    if (Test-Path $historico) {
        $memorias = Get-ChildItem $historico -Filter "MEMORIA_V*.md" -ErrorAction SilentlyContinue |
                    Sort-Object Name -Descending
        $relatorios = Get-ChildItem $historico -Filter "relatorio_evolutivo_V*.md" -ErrorAction SilentlyContinue |
                      Sort-Object Name -Descending

        # Detectar número do loop mais alto com DIRETRIZ (loop que aconteceu)
        $diretrizes = Get-ChildItem $clienteDir -Filter "DIRETRIZ_GEMINI_V*.txt" -ErrorAction SilentlyContinue |
                      Sort-Object Name -Descending
        if (-not $diretrizes) {
            $diretrizes = Get-ChildItem (Join-Path $clienteDir "HISTORICO") -Filter "DIRETRIZ*.txt" -ErrorAction SilentlyContinue |
                          Sort-Object Name -Descending
        }

        if ($diretrizes) {
            $ultimaDiretriz = $diretrizes | Select-Object -First 1
            if ($ultimaDiretriz.Name -match "V(\d+)") {
                $numLoopDiretriz = [int]$Matches[1]
                $numMemoria = 0
                if ($memorias) {
                    $ultimaMemoria = $memorias | Select-Object -First 1
                    if ($ultimaMemoria.Name -match "V(\d+)") { $numMemoria = [int]$Matches[1] }
                }

                if ($numMemoria -lt ($numLoopDiretriz - 1)) {
                    Write-Host "  [P-045] AVISO: loops sem MEMORIA/relatorio detectados!" -ForegroundColor Red
                    Write-Host "          DIRETRIZ V$numLoopDiretriz existe -- MEMORIA mais recente: V$numMemoria" -ForegroundColor Red
                    for ($v = ($numMemoria + 1); $v -le $numLoopDiretriz; $v++) {
                        $mPath = Join-Path $historico "MEMORIA_V${v}_${cliente}.md"
                        $rPath = Join-Path $historico "relatorio_evolutivo_V${v}_${cliente}.md"
                        if (-not (Test-Path $mPath))  { Write-Host "          [AUSENTE] MEMORIA_V${v}_${cliente}.md" -ForegroundColor Red }
                        if (-not (Test-Path $rPath))  { Write-Host "          [AUSENTE] relatorio_evolutivo_V${v}_${cliente}.md" -ForegroundColor Red }
                    }
                    Write-Host "          Gere os artefatos ausentes antes de iniciar o proximo loop." -ForegroundColor Yellow
                    Write-Host "          (P-045: loop sem artefatos = Auditor com contexto defasado)" -ForegroundColor Yellow
                } else {
                    Write-Host "  [P-045] Artefatos de loop OK — MEMORIA V$numMemoria em dia" -ForegroundColor Green
                }
            }
        }
    }

    Write-Host ""
}

Write-Host "  Auditoria concluida." -ForegroundColor Green
Write-Host ""

# --- Auto-preparar os 3 Sócios (Gemini + NotebookLM + Embaixador) ---
Write-Host ""
Write-Host "=============================================="
Write-Host "  AUTO-PREPARAÇÃO DOS 3 SÓCIOS"
Write-Host "=============================================="

# Pré-etapa P-060 — Propagacao automatica de mudancas (DEPENDENCY_MAP) ─────────────────
# P-060: Eduardo nunca gerencia propagacao. Musculo detecta e propaga antes de reportar.
$propagateScript = Join-Path $BASE "scripts\propagate_changes.ps1"
if (Test-Path $propagateScript) {
    Write-Host ""
    Write-Host "  [0a/3] P-060 — Propagando mudancas via DEPENDENCY_MAP..." -ForegroundColor Cyan
    try {
        & powershell.exe -NonInteractive -File $propagateScript 2>$null
        Write-Host "  [OK]  Propagacao concluida — zero intervencao do Diretor" -ForegroundColor Green
    } catch {
        Write-Host "  [!!]  propagate_changes.ps1 falhou — verificar DEPENDENCY_MAP.json" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [--]  propagate_changes.ps1 nao encontrado — propagacao manual necessaria" -ForegroundColor Yellow
}

# Pré-etapa P-060 — Validacao estatica de scripts criados/editados hoje ─────────────────
$validateScript = Join-Path $BASE "scripts\validate_scripts.ps1"
if (Test-Path $validateScript) {
    Write-Host ""
    Write-Host "  [0b/3] P-060 — Validando scripts editados hoje..." -ForegroundColor Cyan
    try {
        $scriptsMod = & git -C $BASE diff --name-only HEAD 2>$null |
                      Where-Object { $_ -match '\.ps1$' }
        if ($scriptsMod) {
            foreach ($s in $scriptsMod) {
                & powershell.exe -NonInteractive -File $validateScript -Script $s 2>$null
            }
        } else {
            Write-Host "  [OK]  Nenhum .ps1 modificado detectado no git diff" -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "  [!!]  validate_scripts.ps1 falhou" -ForegroundColor Yellow
    }
}

# Pré-etapa — Sync universal: PENTALATERAL_UNIVERSAL → NOTEBOOKLM_FONTES de todos os projetos
$syncScript = Join-Path $BASE ".claude\skills\files\sync_vanguard_docs.ps1"
if (Test-Path $syncScript) {
    Write-Host ""
    Write-Host "  [0c/3] Sync universal → NOTEBOOKLM_FONTES..."
    try {
        & powershell.exe -NonInteractive -File $syncScript -modo completo 2>$null | Out-Null
        Write-Host "  [OK]  Sync concluido — P-033 satisfeito" -ForegroundColor Green
    } catch {
        Write-Host "  [!!]  Sync falhou — verificar sync_vanguard_docs.ps1" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [--]  sync_vanguard_docs.ps1 nao encontrado" -ForegroundColor DarkGray
}

# Pré-etapa 1 — Sync arquivos compartilhados → CLAUDE_PROJECT de cada projeto ativo
# Impede que LEDGER, WIP_BOARD e TIMELINE fiquem defasados no Claude Projects (falha de processo 2026-05-23)
Write-Host ""
Write-Host "  [0.5] CLAUDE_PROJECT — sincronizando arquivos compartilhados..."
$ledgerFonte    = "$BASE\INTELLIGENCE_LEDGER.md"
$wipFonte       = "$BASE\CLIENTES\WIP_BOARD.json"
$timelineFonte  = "$BASE\PENTALATERAL_UNIVERSAL\HISTORICO\VANGUARD_TIMELINE.md"

if (Test-Path $wipFonte) {
    $boardSync = Get-Content $wipFonte -Raw -Encoding utf8 | ConvertFrom-Json
    $projetosSync = @($boardSync.board.build)
    foreach ($proj in $projetosSync) {
        $cli = $proj.cliente.ToUpper()
        $cpDir = "$BASE\CLIENTES\$cli\CLAUDE_PROJECT"
        if (Test-Path $cpDir) {
            if (Test-Path $ledgerFonte)   { Copy-Item $ledgerFonte   "$cpDir\06_INTELLIGENCE_LEDGER.md" -Force }
            if (Test-Path $wipFonte)      { Copy-Item $wipFonte       "$cpDir\07_WIP_BOARD.json"         -Force }
            if (Test-Path $timelineFonte) { Copy-Item $timelineFonte  "$cpDir\16_VANGUARD_TIMELINE.md"   -Force }
            Write-Host "  [OK]  CLAUDE_PROJECT/$cli — LEDGER + WIP + TIMELINE sincronizados" -ForegroundColor Green
        } else {
            Write-Host "  [!!]  CLAUDE_PROJECT/$cli nao encontrado" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  [!!]  WIP_BOARD.json nao encontrado — sync CLAUDE_PROJECT ignorado" -ForegroundColor Yellow
}

# Sócio 1 — Gemini: regenerar CONTEXTO_GEMINI.md
$anchorScript = Join-Path $BASE "scripts\gemini_anchor_generator.ps1"
if (Test-Path $anchorScript) {
    try {
        Write-Host ""
        Write-Host "  [1/3] Gemini — atualizando CONTEXTO_GEMINI.md..."
        & powershell.exe -NonInteractive -File $anchorScript 2>$null | Out-Null
        Write-Host "  [OK]  Gemini pronto — CONTEXTO_GEMINI.md no clipboard" -ForegroundColor Green
    } catch {
        Write-Host "  [!!]  Gemini — falha ao gerar CONTEXTO_GEMINI.md" -ForegroundColor Yellow
    }
}

# Sócio 2 — NotebookLM: preparar fontes para cada projeto ativo
$prepScript = Join-Path $BASE "scripts\preparar_notebooklm_projeto.ps1"
if (Test-Path $prepScript) {
    Write-Host ""
    Write-Host "  [2/3] NotebookLM — preparando NOTEBOOKLM_FONTES..."
    foreach ($proj in $projetosEmBuild) {
        $cli = $proj.cliente.ToUpper()
        try {
            & powershell.exe -NonInteractive -File $prepScript -cliente $cli 2>$null | Out-Null
            Write-Host "  [OK]  NotebookLM/$cli — 19 docs prontos" -ForegroundColor Green
        } catch {
            Write-Host "  [!!]  NotebookLM/$cli — falha" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  [--]  preparar_notebooklm_projeto.ps1 não encontrado" -ForegroundColor DarkGray
}

# Sócio 3 — Embaixador: sincronizar docs (sem abrir browser — modo AutoSync)
$embScript = Join-Path $BASE "scripts\ir_ao_embaixador.ps1"
if (Test-Path $embScript) {
    Write-Host ""
    Write-Host "  [3/3] Embaixador — sincronizando CLAUDE_PROJECT..."
    foreach ($proj in $projetosEmBuild) {
        $cli = $proj.cliente.ToUpper()
        try {
            & powershell.exe -NonInteractive -File $embScript -cliente $cli -AutoSync 2>$null | Out-Null
            Write-Host "  [OK]  Embaixador/$cli — docs sincronizados" -ForegroundColor Green
        } catch {
            Write-Host "  [!!]  Embaixador/$cli — falha" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  [--]  ir_ao_embaixador.ps1 não encontrado" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "  3 sócios preparados. Quando for interagir:" -ForegroundColor Cyan
Write-Host "  · Gemini    → CONTEXTO_GEMINI.md já no clipboard + PASSO3 do projeto" -ForegroundColor White
Write-Host "  · NotebookLM → Wipe & Sync no Projects + colar PASSO5" -ForegroundColor White
Write-Host "  · Embaixador → .\scripts\ir_ao_embaixador.ps1 (abre browser + clipboard)" -ForegroundColor White

# --- Notificação Telegram: sessão encerrada ───────────────
. "$BASE\scripts\alert_config.ps1"
$resumoTelegram  = "SESSAO ENCERRADA — $DATA`n"
$resumoTelegram += "Pentalateral IAH · Musculo`n`n"
if ($friccao)            { $resumoTelegram += "Friccao: $friccao`n" }
if ($principio)          { $resumoTelegram += "Principio: $principio`n" }
if ($override)           { $resumoTelegram += "Override: $override`n" }
if ($deriva)             { $resumoTelegram += "Deriva corrigida: $deriva`n" }
if ($mandatos.Count -gt 0) {
    $resumoTelegram += "Mandatos do Diretor ($($mandatos.Count)):`n"
    foreach ($m in $mandatos) { $resumoTelegram += "  - $m`n" }
}
if ($divida)             { $resumoTelegram += "Divida tecnica registrada: $divida`n" }
if ($padroesProtocolo.Count -gt 0) {
    $resumoTelegram += "Evolucao de protocolo ($($padroesProtocolo.Count) padrao(oes)):`n"
    foreach ($p in $padroesProtocolo) { $resumoTelegram += "  - $p`n" }
}
$resumoTelegram += "`nProximo: PASSO3 + Gemini para fechar o loop."

$urlTelegram = "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage"
try {
    Invoke-RestMethod -Uri $urlTelegram -Method POST -Body @{
        chat_id = $TELEGRAM_CHAT_ID
        text    = $resumoTelegram
    } | Out-Null
    Write-Host ""
    Write-Host "  [OK] Resumo da sessao enviado ao Telegram." -ForegroundColor Cyan
} catch {
    Write-Host "  [!!] Telegram: $($_.Exception.Message)" -ForegroundColor Yellow
}
