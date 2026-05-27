#Requires -Version 5.1
# session_close.ps1 — Fechamento de sessao Pentalateral IAH
# P-071: sessao encerrada e fato tecnico, nao intencao. Zero Read-Host.
#
# Uso:
#   .\scripts\session_close.ps1
#   .\scripts\session_close.ps1 -Friccao "..." -Principio "..." -Deriva "..."
#
# Todos os parametros sao opcionais. Se omitidos, o campo fica em branco no log.
# O script roda ate o fim sem nenhuma interacao manual.

param(
    [string]$Friccao   = "",
    [string]$Principio = "",
    [string]$Override  = "",
    [string]$Deriva    = "",
    [string]$Divida    = "",
    [string]$Candidato = "",
    [string]$Padrao    = "",
    [string]$Mandato   = ""
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE  = Split-Path -Parent $PSScriptRoot
$LEDGER = "$BASE\INTELLIGENCE_LEDGER.md"
$KG     = "$BASE\knowledge_graph.json"
$DATA   = Get-Date -Format "yyyy-MM-dd"
$HORA   = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"

Write-Host ""
Write-Host "=============================================="
Write-Host "  FECHAMENTO DE SESSAO -- Pentalateral IAH"
Write-Host "  $DATA"
Write-Host "=============================================="
Write-Host ""

# --------------------------------------------------------------------------
# [0a] P-060: Propagacao automatica via DEPENDENCY_MAP
# --------------------------------------------------------------------------
$propagateScript = Join-Path $BASE "scripts\propagate_changes.ps1"
$propOK = $false
if (Test-Path $propagateScript) {
    Write-Host "  [0a] P-060 -- Propagando via DEPENDENCY_MAP..." -ForegroundColor Cyan
    try {
        & powershell.exe -NonInteractive -File $propagateScript 2>$null
        $propOK = ($LASTEXITCODE -eq 0)
        if ($propOK) {
            Write-Host "  [OK] Propagacao concluida -- zero intervencao do Diretor" -ForegroundColor Green
        } else {
            Write-Host "  [!!] Propagacao reportou erros -- verificar DEPENDENCY_MAP.json" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  [!!] propagate_changes.ps1 falhou: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [--] propagate_changes.ps1 nao encontrado" -ForegroundColor DarkGray
}

# --------------------------------------------------------------------------
# [0b] P-060: Validacao de scripts .ps1 editados hoje
# --------------------------------------------------------------------------
$validateScript = Join-Path $BASE "scripts\validate_scripts.ps1"
if (Test-Path $validateScript) {
    Write-Host ""
    Write-Host "  [0b] Validando scripts editados hoje..." -ForegroundColor Cyan
    try {
        $scriptsMod = @(& git -C $BASE diff --name-only HEAD 2>$null | Where-Object { $_ -match '\.ps1$' })
        if ($scriptsMod.Count -gt 0) {
            foreach ($s in $scriptsMod) {
                & powershell.exe -NonInteractive -File $validateScript -Script $s 2>$null
            }
            Write-Host "  [OK] $($scriptsMod.Count) script(s) validado(s)" -ForegroundColor Green
        } else {
            Write-Host "  [OK] Nenhum .ps1 modificado detectado" -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "  [!!] validate_scripts.ps1 falhou" -ForegroundColor Yellow
    }
}

# --------------------------------------------------------------------------
# [0c] P-033: Sync universal PENTALATERAL_UNIVERSAL -> NOTEBOOKLM_FONTES
# --------------------------------------------------------------------------
$syncScript = Join-Path $BASE ".claude\skills\files\sync_vanguard_docs.ps1"
$syncOK = $false
if (Test-Path $syncScript) {
    Write-Host ""
    Write-Host "  [0c] P-033 -- Sync universal -> NOTEBOOKLM_FONTES..." -ForegroundColor Cyan
    try {
        & powershell.exe -NonInteractive -File $syncScript -modo completo 2>$null | Out-Null
        $syncOK = ($LASTEXITCODE -eq 0)
        if ($syncOK) {
            Write-Host "  [OK] Sync concluido -- P-033 satisfeito" -ForegroundColor Green
        } else {
            Write-Host "  [!!] Sync relatou problemas -- verificar sync_vanguard_docs.ps1" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  [!!] sync_vanguard_docs.ps1 falhou" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [--] sync_vanguard_docs.ps1 nao encontrado" -ForegroundColor DarkGray
}

# --------------------------------------------------------------------------
# [0.5] CLAUDE_PROJECT: sync byte-level para todos os projetos ativos
# Byte-level (ReadAllBytes/WriteAllBytes) evita problemas de encoding UTF-8/UTF-16
# --------------------------------------------------------------------------
Write-Host ""
Write-Host "  [0.5] CLAUDE_PROJECT -- sync byte-level..." -ForegroundColor Cyan
$wipPath       = "$BASE\CLIENTES\WIP_BOARD.json"
$ledgerFonte   = $LEDGER
$wipFonte      = $wipPath
$timelineFonte = "$BASE\PENTALATERAL_UNIVERSAL\HISTORICO\VANGUARD_TIMELINE.md"
$projetosEmBuild = @()
$cpSyncOK = $true

if (Test-Path $wipFonte) {
    $board = Get-Content $wipFonte -Raw -Encoding utf8 | ConvertFrom-Json
    $projetosEmBuild = @($board.board.build)
    foreach ($proj in $projetosEmBuild) {
        $cli   = $proj.cliente.ToUpper()
        $cpDir = "$BASE\CLIENTES\$cli\CLAUDE_PROJECT"
        if (Test-Path $cpDir) {
            $copias = @(
                @{ src = $ledgerFonte;   dst = "$cpDir\06_INTELLIGENCE_LEDGER.md" },
                @{ src = $wipFonte;      dst = "$cpDir\07_WIP_BOARD.json" },
                @{ src = $timelineFonte; dst = "$cpDir\16_VANGUARD_TIMELINE.md" }
            )
            foreach ($c in $copias) {
                if (Test-Path $c.src) {
                    try {
                        [System.IO.File]::WriteAllBytes($c.dst, [System.IO.File]::ReadAllBytes($c.src))
                    } catch {
                        Write-Host "  [!!] Falha ao copiar $(Split-Path $c.src -Leaf) -> $cli" -ForegroundColor Yellow
                        $cpSyncOK = $false
                    }
                }
            }
            Write-Host "  [OK] CLAUDE_PROJECT/$cli -- LEDGER + WIP + TIMELINE" -ForegroundColor Green
        } else {
            Write-Host "  [!!] CLAUDE_PROJECT/$cli nao encontrado" -ForegroundColor Yellow
            $cpSyncOK = $false
        }
    }
} else {
    Write-Host "  [!!] WIP_BOARD.json nao encontrado -- sync CLAUDE_PROJECT ignorado" -ForegroundColor Yellow
    $cpSyncOK = $false
}

# --------------------------------------------------------------------------
# [LEDGER] Registrar eventos da sessao (sem Read-Host -- via params)
# --------------------------------------------------------------------------
if (-not (Test-Path $LEDGER)) {
    Write-Host "ERRO: INTELLIGENCE_LEDGER.md nao encontrado." -ForegroundColor Red
    exit 1
}

$entradaLedger = ""
if ($Friccao)   { $entradaLedger += "`n``[FRICCAO]`` $Friccao" }
if ($Principio) { $entradaLedger += "`n``[PRINCIPIO]`` $Principio" }
if ($Override)  { $entradaLedger += "`n``[OVERRIDE]`` $Override" }
if ($Deriva)    { $entradaLedger += "`n``[DERIVA]`` $Deriva" }

if ($entradaLedger) {
    $blocoLedger = "`n`n### [SESSAO $DATA]`n$entradaLedger"
    $conteudoLed = Get-Content $LEDGER -Raw -Encoding utf8
    if ($conteudoLed -match "## GLOSSARIO") {
        $conteudoLed = $conteudoLed -replace "(?m)^## GLOSSARIO", "$blocoLedger`n`n## GLOSSARIO"
    } else {
        $conteudoLed = $conteudoLed + $blocoLedger
    }
    Set-Content $LEDGER -Value $conteudoLed -Encoding utf8
    $numEventos = @($Friccao, $Principio, $Override, $Deriva) | Where-Object { $_ }
    Write-Host ""
    Write-Host "  [LEDGER] $($numEventos.Count) evento(s) registrado(s)" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  [LEDGER] Nenhum evento registrado nesta sessao" -ForegroundColor DarkGray
}

# --------------------------------------------------------------------------
# Loop Continuity Check (nao bloqueante)
# --------------------------------------------------------------------------
$comandoGerado = Get-ChildItem "$BASE\CLIENTES" -Filter "COMANDO_ESTRATEGISTA*.md" -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime.Date -eq (Get-Date).Date } |
    Select-Object -First 1
if (-not $comandoGerado) {
    Write-Host ""
    Write-Host "  [!!] LOOP CONTINUITY: COMANDO_ESTRATEGISTA nao detectado hoje." -ForegroundColor Yellow
    Write-Host "       O loop Musculo->Gemini quebra sem este documento." -ForegroundColor Yellow
} else {
    Write-Host "  [OK] Loop Continuity: $($comandoGerado.Name)" -ForegroundColor Green
}

# --------------------------------------------------------------------------
# knowledge_graph.json
# --------------------------------------------------------------------------
if (Test-Path $KG) {
    $kg = Get-Content $KG -Raw -Encoding utf8 | ConvertFrom-Json
    $nova_sessao = [PSCustomObject]@{
        date                 = $DATA
        label                = "Sessao $DATA"
        friction_events      = if ($Friccao)   { 1 } else { 0 }
        principles_generated = if ($Principio) { @("novo") } else { @() }
        overrides            = if ($Override)  { @([PSCustomObject]@{ description = $Override }) } else { @() }
        drift_detected       = if ($Deriva)    { $true } else { $false }
    }
    $sessoes = [System.Collections.ArrayList]@()
    if ($kg.sessions) { foreach ($s in $kg.sessions) { [void]$sessoes.Add($s) } }
    $sessoes.Insert(0, $nova_sessao)
    if ($sessoes.Count -gt 20) { $sessoes = $sessoes[0..19] }
    $kg.sessions = $sessoes
    $kg.meta.last_updated   = $DATA
    $kg.meta.total_sessions = $sessoes.Count
    $kgJson = $kg | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText($KG, $kgJson, [System.Text.Encoding]::UTF8)
    Write-Host "  [OK] knowledge_graph.json atualizado" -ForegroundColor DarkGray
}

# --------------------------------------------------------------------------
# Dividas Tecnicas para o Auditor
# --------------------------------------------------------------------------
if ($Divida) {
    $divArquivo  = "$BASE\DIVIDAS_TECNICAS_AUDITOR.md"
    $divConteudo = if (Test-Path $divArquivo) { Get-Content $divArquivo -Raw -Encoding utf8 } else { "" }
    $novaDiv     = "`n`n### [DIVIDAS TECNICAS -- $DATA]`n**Sessao:** $DATA`n**Dividas:**`n$Divida`n"
    Set-Content $divArquivo -Value ($divConteudo + $novaDiv) -Encoding utf8
    Write-Host "  [OK] DIVIDAS_TECNICAS_AUDITOR.md atualizado" -ForegroundColor Green
}

# --------------------------------------------------------------------------
# Candidatos a Principio (P-053)
# --------------------------------------------------------------------------
if ($Candidato) {
    $candidatosFile = "$BASE\CANDIDATOS_A_PRINCIPIO.md"
    $conteudoC = if (Test-Path $candidatosFile) {
        Get-Content $candidatosFile -Raw -Encoding utf8
    } else {
        "# CANDIDATOS A PRINCIPIO -- Vanguard Pentalateral IAH`n> Promover ao LEDGER quando padrao aparecer 3x.`n"
    }
    $blocoC = "`n`n### [CANDIDATOS-$DATA]`n> Capturado via session_close.ps1`n$Candidato`n"
    Set-Content $candidatosFile -Value ($conteudoC + $blocoC) -Encoding utf8
    Write-Host "  [OK] CANDIDATOS_A_PRINCIPIO.md atualizado" -ForegroundColor Green
}

# --------------------------------------------------------------------------
# Evolucao do Protocolo Vanguard
# --------------------------------------------------------------------------
if ($Padrao) {
    $protocoloPath = Join-Path $BASE ".claude\skills\vanguard-protocolo.md"
    $universalPath = Join-Path $BASE "PENTALATERAL_UNIVERSAL\OPERACAO\SKILL_PROTOCOLO_VANGUARD.md"
    if (Test-Path $protocoloPath) {
        $conteudoProt = Get-Content $protocoloPath -Raw -Encoding utf8
        $blocoEvol    = "`n`n### [EVOLUCAO-$DATA]`n> Capturado via session_close.ps1`n$Padrao`n"
        if ($conteudoProt -match "## EVOLUCOES DE PROCESSO EM CURSO") {
            $conteudoProt = $conteudoProt + $blocoEvol
        } else {
            $secaoEvol    = "`n`n---`n`n## EVOLUCOES DE PROCESSO EM CURSO`n"
            $secaoEvol   += "> Capturadas pelo Musculo via session_close.ps1.`n"
            $conteudoProt = $conteudoProt + $secaoEvol + $blocoEvol
        }
        Set-Content $protocoloPath -Value $conteudoProt -Encoding utf8
        if (Test-Path (Split-Path $universalPath)) {
            Copy-Item $protocoloPath $universalPath -Force
        }
        # Tambem registrar no LEDGER com tag [PROTOCOLO]
        $entradaProt  = "`n`n### [SESSAO $DATA -- PROTOCOLO]`n``[PROTOCOLO]`` $Padrao`n"
        $conteudoLed2 = Get-Content $LEDGER -Raw -Encoding utf8
        if ($conteudoLed2 -match "## GLOSSARIO") {
            $conteudoLed2 = $conteudoLed2 -replace "(?m)^## GLOSSARIO", "$entradaProt`n`n## GLOSSARIO"
        } else {
            $conteudoLed2 = $conteudoLed2 + $entradaProt
        }
        Set-Content $LEDGER -Value $conteudoLed2 -Encoding utf8
        Write-Host "  [OK] Padrao de protocolo registrado em vanguard-protocolo.md + LEDGER" -ForegroundColor Green
    }
}

# --------------------------------------------------------------------------
# Mandato Direto do Diretor -> PASSO3_GEMINI.md do projeto ativo
# --------------------------------------------------------------------------
if ($Mandato) {
    if (Test-Path $wipPath) {
        $boardM = Get-Content $wipPath -Raw -Encoding utf8 | ConvertFrom-Json
        $projetoAtivo = @($boardM.board.build) | Select-Object -First 1
        if ($projetoAtivo) {
            $clienteDirM = Join-Path $BASE "CLIENTES\$($projetoAtivo.cliente.ToUpper())"
            $passo3Path  = Join-Path $clienteDirM "PASSO3_GEMINI.md"
            if (Test-Path $passo3Path) {
                $blocoMandato  = "`n## [!!] [MANDATO_DIRETO_DO_DIRETOR] -- $DATA`n"
                $blocoMandato += "> Eduardo declarou diretamente. Estrategista: proibido de suavizar ou ignorar.`n`n"
                $blocoMandato += "$Mandato`n`n---`n"
                $conteudoM = Get-Content $passo3Path -Raw -Encoding utf8
                if ($conteudoM -match "\[MANDATO_DIRETO_DO_DIRETOR\]") {
                    $conteudoM = $conteudoM -replace "(?s)## \[!!\] \[MANDATO_DIRETO_DO_DIRETOR\].*?---`r?`n", $blocoMandato
                } else {
                    $conteudoM = $blocoMandato + "`n" + $conteudoM
                }
                Set-Content $passo3Path -Value $conteudoM -Encoding utf8
                Write-Host "  [OK] Mandato injetado em PASSO3_GEMINI.md -- $($projetoAtivo.cliente)" -ForegroundColor Green
            } else {
                Write-Host "  [!!] PASSO3_GEMINI.md nao encontrado para $($projetoAtivo.cliente)" -ForegroundColor Yellow
            }
        }
    }
}

# --------------------------------------------------------------------------
# P-054: AUDITORIA DE CONSISTENCIA TEXTUAL (nao bloqueante)
# --------------------------------------------------------------------------
$auditScript = Join-Path $BASE "scripts\auditar_consistencia.ps1"
if (Test-Path $auditScript) {
    Write-Host ""
    Write-Host "  [P-054] Consistencia textual..." -ForegroundColor Cyan
    & powershell.exe -NonInteractive -File $auditScript
    if ($LASTEXITCODE -eq 2) {
        Write-Host "  [!!] Padroes VERMELHOS detectados -- verificar antes do proximo ciclo." -ForegroundColor Yellow
    }
}

# --------------------------------------------------------------------------
# AUDITORIA DE DOCUMENTOS + P-045 (nao bloqueante)
# --------------------------------------------------------------------------
Write-Host ""
Write-Host "=============================================="
Write-Host "  AUDITORIA DE DOCUMENTOS"
Write-Host "=============================================="

foreach ($proj in $projetosEmBuild) {
    $cliente    = $proj.cliente.ToUpper()
    $clienteDir = Join-Path $BASE "CLIENTES\$cliente"
    Write-Host ""
    Write-Host "  Projeto: $($proj.id) -- $($proj.cliente)" -ForegroundColor Cyan

    # P-045: MEMORIA + relatorio do loop anterior
    $historico = Join-Path $clienteDir "HISTORICO"
    if (Test-Path $historico) {
        $diretrizes = Get-ChildItem $clienteDir -Filter "DIRETRIZ_GEMINI_V*.txt" -ErrorAction SilentlyContinue |
                      Sort-Object Name -Descending
        if (-not $diretrizes) {
            $diretrizes = Get-ChildItem $historico -Filter "DIRETRIZ*.txt" -ErrorAction SilentlyContinue |
                          Sort-Object Name -Descending
        }
        if ($diretrizes) {
            $numLoopDiretriz = 0
            if (($diretrizes | Select-Object -First 1).Name -match "V(\d+)") { $numLoopDiretriz = [int]$Matches[1] }
            $memorias = Get-ChildItem $historico -Filter "MEMORIA_V*.md" -ErrorAction SilentlyContinue |
                        Sort-Object Name -Descending
            $numMemoria = 0
            if ($memorias) {
                if (($memorias | Select-Object -First 1).Name -match "V(\d+)") { $numMemoria = [int]$Matches[1] }
            }
            if ($numMemoria -lt ($numLoopDiretriz - 1)) {
                Write-Host "  [P-045] ALERTA: DIRETRIZ V$numLoopDiretriz existe -- MEMORIA mais recente: V$numMemoria" -ForegroundColor Red
                Write-Host "         Gerar MEMORIA + relatorio_evolutivo antes do proximo loop." -ForegroundColor Yellow
            } else {
                Write-Host "  [P-045] Artefatos OK -- MEMORIA V$numMemoria" -ForegroundColor Green
            }
        }
    }

    # Verificar NOTEBOOKLM_FONTES
    $fontes = Join-Path $clienteDir "NOTEBOOKLM_FONTES"
    if (-not (Test-Path $fontes)) {
        Write-Host "  [!!] NOTEBOOKLM_FONTES/ ausente -- rodar preparar_notebooklm_projeto.ps1" -ForegroundColor Red
    } else {
        $ultimaFonte = Get-ChildItem $fontes -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($ultimaFonte -and $ultimaFonte.LastWriteTime.Date -eq (Get-Date).Date) {
            Write-Host "  [OK] NOTEBOOKLM_FONTES/ sincronizado hoje" -ForegroundColor Green
        } else {
            $dataFonte = if ($ultimaFonte) { $ultimaFonte.LastWriteTime.ToString("yyyy-MM-dd") } else { "nunca" }
            Write-Host "  [!!] NOTEBOOKLM_FONTES/ ultima sync: $dataFonte" -ForegroundColor Yellow
        }
    }

    # Wipe & Sync reminder se loop encerrou hoje
    $loopAtual = $proj.loop_atual
    if ($loopAtual -and $loopAtual -match "Loop #(\d+)") {
        $numLoop = [int]$Matches[1]
        $loopAnterior = $proj.loops_programados | Where-Object {
            $_.loop -eq ($numLoop - 1) -and $_.status -eq "concluido" -and $_.concluido_em -eq $DATA
        }
        if ($loopAnterior) {
            Write-Host ""
            Write-Host "  [!!] LOOP $($numLoop - 1) ENCERRADO HOJE -- Wipe & Sync antes do Loop $numLoop" -ForegroundColor Magenta
            Write-Host "       .\scripts\preparar_notebooklm_projeto.ps1 -cliente $cliente" -ForegroundColor Cyan
        }
    }
}

Write-Host ""
Write-Host "  Auditoria concluida." -ForegroundColor Green

# --------------------------------------------------------------------------
# MANIFEST_DOCS.json — atualizar para cada projeto ativo
# Compara hashes SHA-256 source (NOTEBOOKLM_BASE) vs destino (NOTEBOOKLM_FONTES)
# --------------------------------------------------------------------------
Write-Host ""
Write-Host "=============================================="
Write-Host "  MANIFEST_DOCS -- ATUALIZANDO"
Write-Host "=============================================="

$manifestStatus = @{}
$baseUniversal  = "$BASE\PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE"

foreach ($proj in $projetosEmBuild) {
    $cliente    = $proj.cliente.ToUpper()
    $clienteDir = Join-Path $BASE "CLIENTES\$cliente"
    $fontesDir  = Join-Path $clienteDir "NOTEBOOKLM_FONTES"

    if (-not (Test-Path $fontesDir)) {
        $manifestStatus[$cliente] = "VERMELHO"
        Write-Host "  [XX] $cliente -- NOTEBOOKLM_FONTES/ ausente" -ForegroundColor Red
        continue
    }

    $arquivosManifest = [System.Collections.ArrayList]@()
    $statusGeral      = "VERDE"
    $driftCount       = 0
    $ausenteCount     = 0

    # Comparar arquivos universais
    $arquivosSource = @(Get-ChildItem $baseUniversal -File -ErrorAction SilentlyContinue)
    $arquivosLocal  = @(Get-ChildItem $fontesDir -File -ErrorAction SilentlyContinue)

    foreach ($srcFile in $arquivosSource) {
        $localMatch = $arquivosLocal | Where-Object {
            $_.Name -eq $srcFile.Name -or
            $_.Name -match ("^\d{2}_" + [regex]::Escape($srcFile.Name) + "$")
        } | Select-Object -First 1

        if ($localMatch) {
            $hashSrc   = (Get-FileHash $srcFile.FullName   -Algorithm SHA256).Hash
            $hashLocal = (Get-FileHash $localMatch.FullName -Algorithm SHA256).Hash
            $status    = if ($hashSrc -eq $hashLocal) { "SYNC" } else { "DRIFT" }
            if ($status -eq "DRIFT") { $statusGeral = "AMARELO"; $driftCount++ }
            [void]$arquivosManifest.Add([PSCustomObject]@{
                nome           = $localMatch.Name
                hash_universal = $hashSrc
                hash_local     = $hashLocal
                status         = $status
            })
        } else {
            $hashSrc = (Get-FileHash $srcFile.FullName -Algorithm SHA256).Hash
            $statusGeral = "VERMELHO"; $ausenteCount++
            [void]$arquivosManifest.Add([PSCustomObject]@{
                nome           = $srcFile.Name
                hash_universal = $hashSrc
                hash_local     = ""
                status         = "AUSENTE"
            })
        }
    }

    # Arquivos apenas do projeto (sem universal correspondente)
    $nomesClienteOnly = @("DIRETRIZ_GEMINI_LATEST.txt", "MEMORIA_EMBAIXADOR.md", "PASSO7_EMBAIXADOR.md")
    foreach ($nomeEsp in $nomesClienteOnly) {
        $found = $arquivosLocal | Where-Object { $_.Name -match [regex]::Escape($nomeEsp) } | Select-Object -First 1
        if ($found) {
            $hashLocal = (Get-FileHash $found.FullName -Algorithm SHA256).Hash
            [void]$arquivosManifest.Add([PSCustomObject]@{
                nome           = $found.Name
                hash_universal = "N/A"
                hash_local     = $hashLocal
                status         = "CLIENT-ONLY"
            })
        }
    }

    $manifest = [PSCustomObject]@{
        projeto              = $cliente
        ultima_sincronizacao = $HORA
        arquivos             = $arquivosManifest.ToArray()
        status_geral         = $statusGeral
        total                = $arquivosManifest.Count
        drift_count          = $driftCount
        ausente_count        = $ausenteCount
    }

    $manifestPath = Join-Path $clienteDir "MANIFEST_DOCS.json"
    $manifestJson = $manifest | ConvertTo-Json -Depth 5
    [System.IO.File]::WriteAllText($manifestPath, $manifestJson, [System.Text.Encoding]::UTF8)
    $manifestStatus[$cliente] = $statusGeral

    $cor = if ($statusGeral -eq "VERDE") { "Green" } elseif ($statusGeral -eq "AMARELO") { "Yellow" } else { "Red" }
    Write-Host "  [$statusGeral] $cliente -- $($arquivosManifest.Count) arqs · $driftCount drift · $ausenteCount ausente" -ForegroundColor $cor
}

# --------------------------------------------------------------------------
# AUTO-PREPARACAO DOS 3 SOCIOS
# --------------------------------------------------------------------------
Write-Host ""
Write-Host "=============================================="
Write-Host "  AUTO-PREPARACAO DOS 3 SOCIOS"
Write-Host "=============================================="

# Socio 1 — Gemini
$anchorScript = Join-Path $BASE "scripts\gemini_anchor_generator.ps1"
if (Test-Path $anchorScript) {
    Write-Host ""
    Write-Host "  [1/3] Gemini -- atualizando CONTEXTO_GEMINI.md..." -ForegroundColor Cyan
    try {
        & powershell.exe -NonInteractive -File $anchorScript 2>$null | Out-Null
        Write-Host "  [OK] Gemini pronto" -ForegroundColor Green
    } catch {
        Write-Host "  [!!] Gemini -- falha ao gerar CONTEXTO_GEMINI.md" -ForegroundColor Yellow
    }
}

# Socio 2 — NotebookLM
$prepScript = Join-Path $BASE "scripts\preparar_notebooklm_projeto.ps1"
if (Test-Path $prepScript) {
    Write-Host ""
    Write-Host "  [2/3] NotebookLM -- preparando NOTEBOOKLM_FONTES..." -ForegroundColor Cyan
    foreach ($proj in $projetosEmBuild) {
        $cli = $proj.cliente.ToUpper()
        try {
            & powershell.exe -NonInteractive -File $prepScript -cliente $cli 2>$null | Out-Null
            Write-Host "  [OK] NotebookLM/$cli -- fontes prontas" -ForegroundColor Green
        } catch {
            Write-Host "  [!!] NotebookLM/$cli -- falha" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  [--] preparar_notebooklm_projeto.ps1 nao encontrado" -ForegroundColor DarkGray
}

# Socio 3 — Embaixador
$embScript = Join-Path $BASE "scripts\ir_ao_embaixador.ps1"
if (Test-Path $embScript) {
    Write-Host ""
    Write-Host "  [3/3] Embaixador -- AutoSync..." -ForegroundColor Cyan
    foreach ($proj in $projetosEmBuild) {
        $cli = $proj.cliente.ToUpper()
        try {
            & powershell.exe -NonInteractive -File $embScript -cliente $cli -AutoSync 2>$null | Out-Null
            Write-Host "  [OK] Embaixador/$cli -- docs sincronizados" -ForegroundColor Green
        } catch {
            Write-Host "  [!!] Embaixador/$cli -- falha" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  [--] ir_ao_embaixador.ps1 nao encontrado" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "  Instrucoes para o proximo ciclo:"
Write-Host "  . Gemini    -- CONTEXTO_GEMINI.md atualizado + PASSO3 do projeto" -ForegroundColor White
Write-Host "  . NotebookLM -- Wipe & Sync no Projects + colar PASSO5" -ForegroundColor White
Write-Host "  . Embaixador -- .\scripts\ir_ao_embaixador.ps1 (abre browser + clipboard)" -ForegroundColor White

# --------------------------------------------------------------------------
# PAINEL DE ATIVIDADES para o Embaixador
# --------------------------------------------------------------------------
$painelScript = Join-Path $BASE "scripts\generate_protocolo_encerramento.ps1"
if (Test-Path $painelScript) {
    Write-Host ""
    Write-Host "=============================================="
    Write-Host "  PAINEL DE ATIVIDADES"
    Write-Host "=============================================="
    $painelFile = (& powershell.exe -NonInteractive -File $painelScript 2>$null) | Select-Object -Last 1
    if ($painelFile -and (Test-Path $painelFile)) {
        Write-Host ""
        Write-Host "  [PAINEL] Pronto para upload ao Embaixador:" -ForegroundColor Cyan
        Write-Host "  $painelFile" -ForegroundColor White
        Write-Host "  Instrucao: abrir Claude Projects + fazer upload deste arquivo." -ForegroundColor Yellow
    }
}

# --------------------------------------------------------------------------
# Telegram: resumo da sessao
# --------------------------------------------------------------------------
$alertConfig = Join-Path $BASE "scripts\alert_config.ps1"
if (Test-Path $alertConfig) {
    . $alertConfig
    $resumoTelegram  = "SESSAO ENCERRADA -- $DATA`n"
    $resumoTelegram += "Pentalateral IAH . Musculo`n`n"
    if ($Friccao)   { $resumoTelegram += "Friccao: $Friccao`n" }
    if ($Principio) { $resumoTelegram += "Principio: $Principio`n" }
    if ($Override)  { $resumoTelegram += "Override: $Override`n" }
    if ($Deriva)    { $resumoTelegram += "Deriva: $Deriva`n" }
    if ($Mandato)   { $resumoTelegram += "Mandato: $Mandato`n" }

    # Adicionar status do manifest
    $resumoTelegram += "`nSync:"
    foreach ($kv in $manifestStatus.GetEnumerator()) {
        $resumoTelegram += " $($kv.Key)=$($kv.Value)"
    }
    $resumoTelegram += "`n`nProximo: PASSO3 + Gemini para fechar o loop."

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
}

# --------------------------------------------------------------------------
# SESSION CLOSE REPORT — Entregavel 1 do Diretor
# --------------------------------------------------------------------------
$statusFinal = "VERDE"
foreach ($s in $manifestStatus.Values) {
    if ($s -eq "VERMELHO") { $statusFinal = "VERMELHO"; break }
    if ($s -eq "AMARELO" -and $statusFinal -ne "VERMELHO") { $statusFinal = "AMARELO" }
}

$arquivosModificados = @(& git -C $BASE diff --name-only HEAD 2>$null | Where-Object { $_ })

Write-Host ""
Write-Host "=============================================="
Write-Host "  SESSION CLOSE REPORT -- $DATA"
Write-Host "=============================================="
Write-Host ""
Write-Host ("  Arquivos modificados nesta sessao : " + $arquivosModificados.Count) -ForegroundColor White

foreach ($proj in $projetosEmBuild) {
    $cli = $proj.cliente.ToUpper()
    $st  = if ($manifestStatus.ContainsKey($cli)) { $manifestStatus[$cli] } else { "?" }
    $cor = if ($st -eq "VERDE") { "Green" } elseif ($st -eq "AMARELO") { "Yellow" } else { "Red" }
    Write-Host ("  Manifest " + $cli.PadRight(26) + ": " + $st) -ForegroundColor $cor
}

Write-Host ""
$corFinal = if ($statusFinal -eq "VERDE") { "Green" } elseif ($statusFinal -eq "AMARELO") { "Yellow" } else { "Red" }
Write-Host ("  STATUS GERAL                      : " + $statusFinal) -ForegroundColor $corFinal

if ($statusFinal -eq "VERMELHO") {
    Write-Host ""
    Write-Host "  [AVISO] Arquivos AUSENTES detectados em um ou mais projetos." -ForegroundColor Red
    Write-Host "  Consultar MANIFEST_DOCS.json em CLIENTES/[PROJ]/" -ForegroundColor Red
    Write-Host "  Rodar: .\scripts\session_close.ps1 novamente apos corrigir." -ForegroundColor Yellow
} elseif ($statusFinal -eq "AMARELO") {
    Write-Host ""
    Write-Host "  [AVISO] Drift detectado. Rodar sync_vanguard_docs.ps1 para corrigir." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=============================================="
Write-Host "  Sessao encerrada. Proximo: git commit."
Write-Host "=============================================="

# --------------------------------------------------------------------------
# ENTREGAVEL 4 — Aviso de sincronizacao manual do Claude Projects
# O Embaixador opera em Claude Projects sem API de upload. O Diretor
# precisa re-arrastar manualmente os arquivos que mudaram nesta sessao.
# --------------------------------------------------------------------------
$todosModificados = @(
    (& git -C $BASE diff --name-only HEAD 2>$null)
    (& git -C $BASE diff --name-only --cached 2>$null)
) | Where-Object { $_ } | Select-Object -Unique

$padroesClaude = @(
    "MEMORIA_EMBAIXADOR\.md",
    "INTELLIGENCE_LEDGER\.md",
    "WIP_BOARD\.(json|txt)",
    "PERFIL_CLIENTE_.*\.md",
    "CLIENTES[\\/][A-Z]+[\\/]CLAUDE_PROJECT[\\/]",
    "DIRETRIZ_GEMINI.*\.txt",
    "PASSO7_EMBAIXADOR.*\.md"
)

$arquivosClaude = @($todosModificados | Where-Object {
    $caminho = $_
    $padroesClaude | Where-Object { $caminho -match $_ } | Select-Object -First 1
})

if ($arquivosClaude.Count -gt 0) {
    Write-Host ""
    Write-Host "=============================================="  -ForegroundColor Magenta
    Write-Host "  ACAO MANUAL -- CLAUDE PROJECTS (EMBAIXADOR)" -ForegroundColor Magenta
    Write-Host "=============================================="  -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  Os arquivos abaixo foram modificados nesta sessao." -ForegroundColor White
    Write-Host "  Re-arraste-os ao Claude Projects do cliente correspondente." -ForegroundColor White
    Write-Host ""
    foreach ($arq in $arquivosClaude) {
        Write-Host "  -> $arq" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "  INSTRUCAO: Abrir Claude Projects -> cliente -> Add content" -ForegroundColor Cyan
    Write-Host "  -> selecionar arquivo acima -> Upload"                      -ForegroundColor Cyan
    Write-Host "=============================================="                 -ForegroundColor Magenta
}
