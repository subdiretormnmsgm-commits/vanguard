#Requires -Version 5.1
# session_close.ps1 — Fechamento de sessao Pentalateral IAH
# P-071: sessao encerrada e fato tecnico, nao intencao.
# 9 gates sequenciais — Gates 1 e 5 sao BLOQUEANTES (exit 1).
# Uso: .\scripts\session_close.ps1 [-cliente NOME] [-Friccao "..."] etc.

param(
    [string]$cliente   = "",
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

$BASE   = Split-Path -Parent $PSScriptRoot
$LEDGER = "$BASE\INTELLIGENCE_LEDGER.md"
$KG     = "$BASE\knowledge_graph.json"
$DATA   = Get-Date -Format "yyyy-MM-dd"
$HORA   = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"
$HORA_EXIB = Get-Date -Format "HH:mm:ss"

# Resolver projetos ativos
$wipPath = "$BASE\CLIENTES\WIP_BOARD.json"
$projetosEmBuild = @()
if (Test-Path $wipPath) {
    try {
        $board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $projetosEmBuild = @($board.board.build)
    } catch { }
}

# Cliente principal da sessao
if ($cliente -eq "" -and $projetosEmBuild.Count -gt 0) {
    $cliente = $projetosEmBuild[0].cliente.ToUpper()
}
$loopAtualLabel = ""
if ($projetosEmBuild.Count -gt 0) {
    $proj0 = $projetosEmBuild | Where-Object { $_.cliente.ToUpper() -eq $cliente } | Select-Object -First 1
    if ($proj0 -and $proj0.loop_atual) { $loopAtualLabel = $proj0.loop_atual }
}

# Status por gate
$gateStatus = [ordered]@{
    G1  = "PENDENTE"
    G2  = "PENDENTE"
    G3  = "PENDENTE"
    G4  = "PENDENTE"
    G5  = "PENDENTE"
    G6  = "PENDENTE"
    G7  = "PENDENTE"
    G8e = "PENDENTE"
    G8t = "PENDENTE"
    G9  = "PENDENTE"
}
$manifestStatus = @{}
$logPath = ""
$acoesSessao = [System.Collections.ArrayList]@()

Write-Host ""
Write-Host "======================================================="
Write-Host "  SESSION CLOSE -- Pentalateral IAH"
Write-Host "  $DATA $HORA_EXIB"
if ($cliente) { Write-Host "  Cliente: $cliente$(if ($loopAtualLabel) { ' -- ' + $loopAtualLabel })" }
Write-Host "======================================================="
Write-Host ""

# ==========================================================================
# GATE 1 — auditar_consistencia.ps1 (BLOQUEANTE — exit 1 se VERMELHO)
# ==========================================================================
Write-Host "  [GATE 1] Auditoria de consistencia..." -ForegroundColor Cyan
$auditScript = "$BASE\scripts\auditar_consistencia.ps1"
if (Test-Path $auditScript) {
    & powershell.exe -NonInteractive -File $auditScript 2>$null
    $auditExit = $LASTEXITCODE
    if ($auditExit -eq 2) {
        Write-Host "  [GATE 1] VERMELHO -- Padroes criticos detectados." -ForegroundColor Red
        Write-Host "           Resolver divergencias antes de encerrar a sessao." -ForegroundColor Red
        Write-Host "           Sessao nao pode ser declarada encerrada. (P-071)" -ForegroundColor Red
        $gateStatus.G1 = "VERMELHO"
        exit 1
    } elseif ($auditExit -eq 1) {
        Write-Host "  [GATE 1] AMARELO -- Avisos detectados. Prosseguindo." -ForegroundColor Yellow
        $gateStatus.G1 = "AMARELO"
    } else {
        Write-Host "  [GATE 1] VERDE" -ForegroundColor Green
        $gateStatus.G1 = "VERDE"
    }
} else {
    Write-Host "  [GATE 1] auditar_consistencia.ps1 nao encontrado -- IGNORADO" -ForegroundColor DarkGray
    $gateStatus.G1 = "N/A"
}

# ==========================================================================
# GATE 2 — sync_passo_files.ps1 + sync_vanguard_docs.ps1
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 2] Sync documentos..." -ForegroundColor Cyan

$syncPassoScript  = "$BASE\scripts\sync_passo_files.ps1"
$syncUnivScript   = "$BASE\.claude\skills\files\sync_vanguard_docs.ps1"
$g2ok = $true

if (Test-Path $syncPassoScript) {
    try {
        & powershell.exe -NonInteractive -File $syncPassoScript 2>$null | Out-Null
        if ($LASTEXITCODE -ne 0) { $g2ok = $false; Write-Host "  [GATE 2] sync_passo_files -- aviso" -ForegroundColor Yellow }
        else { Write-Host "  [GATE 2] sync_passo_files -- OK" -ForegroundColor Green }
    } catch { $g2ok = $false }
} else {
    Write-Host "  [GATE 2] sync_passo_files nao encontrado" -ForegroundColor DarkGray
}

if (Test-Path $syncUnivScript) {
    try {
        & powershell.exe -NonInteractive -File $syncUnivScript -modo completo 2>$null | Out-Null
        if ($LASTEXITCODE -ne 0) { $g2ok = $false; Write-Host "  [GATE 2] sync_vanguard -- aviso" -ForegroundColor Yellow }
        else { Write-Host "  [GATE 2] sync_vanguard (P-033) -- OK" -ForegroundColor Green }
    } catch { $g2ok = $false }
} else {
    Write-Host "  [GATE 2] sync_vanguard_docs nao encontrado" -ForegroundColor DarkGray
}

$gateStatus.G2 = if ($g2ok) { "VERDE" } else { "AMARELO" }

# ==========================================================================
# GATE 3 — propagate_changes.ps1 (P-060)
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 3] Propagacao via DEPENDENCY_MAP (P-060)..." -ForegroundColor Cyan
$propagateScript = "$BASE\scripts\propagate_changes.ps1"
if (Test-Path $propagateScript) {
    try {
        & powershell.exe -NonInteractive -File $propagateScript 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [GATE 3] Propagacao -- VERDE" -ForegroundColor Green
            $gateStatus.G3 = "VERDE"
        } else {
            Write-Host "  [GATE 3] Propagacao -- avisos (verificar DEPENDENCY_MAP)" -ForegroundColor Yellow
            $gateStatus.G3 = "AMARELO"
        }
    } catch {
        Write-Host "  [GATE 3] propagate_changes.ps1 falhou: $_" -ForegroundColor Yellow
        $gateStatus.G3 = "AMARELO"
    }
} else {
    Write-Host "  [GATE 3] propagate_changes.ps1 nao encontrado" -ForegroundColor DarkGray
    $gateStatus.G3 = "N/A"
}

# ==========================================================================
# GATE 4 — CLAUDE_PROJECT byte-level sync (ledger_sync)
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 4] CLAUDE_PROJECT sync..." -ForegroundColor Cyan
$ledgerFonte   = $LEDGER
$wipFonte      = $wipPath
$timelineFonte = "$BASE\PENTALATERAL_UNIVERSAL\HISTORICO\VANGUARD_TIMELINE.md"
$g4ok = $true

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
                    Write-Host "  [GATE 4] Falha: $(Split-Path $c.src -Leaf) -> $cli" -ForegroundColor Yellow
                    $g4ok = $false
                }
            }
        }
        Write-Host "  [GATE 4] $cli -- LEDGER + WIP + TIMELINE -- OK" -ForegroundColor Green
    } else {
        Write-Host "  [GATE 4] CLAUDE_PROJECT/$cli nao encontrado" -ForegroundColor Yellow
        $g4ok = $false
    }
}
$gateStatus.G4 = if ($g4ok) { "VERDE" } else { "AMARELO" }

# ==========================================================================
# GATE 5 — validate_scripts.ps1 (BLOQUEANTE — exit 1 se VERMELHO)
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 5] Validacao de scripts editados..." -ForegroundColor Cyan
$validateScript = "$BASE\scripts\validate_scripts.ps1"
if (Test-Path $validateScript) {
    try {
        $scriptsMod = @(& git -C $BASE diff --name-only HEAD 2>$null | Where-Object { $_ -match '\.ps1$' })
        if ($scriptsMod.Count -gt 0) {
            $g5errors = $false
            foreach ($s in $scriptsMod) {
                & powershell.exe -NonInteractive -File $validateScript -Script $s 2>$null
                if ($LASTEXITCODE -ne 0) { $g5errors = $true }
            }
            if ($g5errors) {
                Write-Host "  [GATE 5] VERMELHO -- Scripts com erros de sintaxe. (P-060)" -ForegroundColor Red
                Write-Host "           Corrigir antes de encerrar a sessao. (P-071)" -ForegroundColor Red
                $gateStatus.G5 = "VERMELHO"
                exit 1
            }
            Write-Host "  [GATE 5] $($scriptsMod.Count) script(s) validado(s) -- VERDE" -ForegroundColor Green
            $gateStatus.G5 = "VERDE"
        } else {
            Write-Host "  [GATE 5] Nenhum .ps1 modificado detectado" -ForegroundColor DarkGray
            $gateStatus.G5 = "VERDE"
        }
    } catch {
        Write-Host "  [GATE 5] validate_scripts.ps1 falhou -- aviso" -ForegroundColor Yellow
        $gateStatus.G5 = "AMARELO"
    }
} else {
    Write-Host "  [GATE 5] validate_scripts.ps1 nao encontrado -- IGNORADO" -ForegroundColor DarkGray
    $gateStatus.G5 = "N/A"
}

# ==========================================================================
# GATE 6 — Artefatos: LEDGER + WIP + MANIFEST + P-045 + knowledge_graph
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 6] Artefatos de sessao e loop..." -ForegroundColor Cyan

# --- LEDGER ---
if (-not (Test-Path $LEDGER)) {
    Write-Host "  [GATE 6] ERRO: INTELLIGENCE_LEDGER.md nao encontrado." -ForegroundColor Red
} else {
    $entradaLedger = ""
    if ($Friccao)   { $entradaLedger += "`n``[FRICCAO]`` $Friccao" }
    if ($Principio) { $entradaLedger += "`n``[PRINCIPIO]`` $Principio" }
    if ($Override)  { $entradaLedger += "`n``[OVERRIDE]`` $Override" }
    if ($Deriva)    { $entradaLedger += "`n``[DERIVA]`` $Deriva" }
    if ($entradaLedger) {
        $blocoL = "`n`n### [SESSAO $DATA]`n$entradaLedger"
        $cL = Get-Content $LEDGER -Raw -Encoding UTF8
        if ($cL -match "## GLOSSARIO") {
            $cL = $cL -replace "(?m)^## GLOSSARIO", "$blocoL`n`n## GLOSSARIO"
        } else { $cL = $cL + $blocoL }
        Set-Content $LEDGER -Value $cL -Encoding UTF8
        $nEv = @($Friccao, $Principio, $Override, $Deriva) | Where-Object { $_ }
        Write-Host "  [GATE 6] LEDGER: $($nEv.Count) evento(s) registrado(s)" -ForegroundColor Green
    }
}

# --- Dividas Tecnicas ---
if ($Divida) {
    $divArq = "$BASE\DIVIDAS_TECNICAS_AUDITOR.md"
    $divC   = if (Test-Path $divArq) { Get-Content $divArq -Raw -Encoding UTF8 } else { "" }
    Set-Content $divArq -Value ($divC + "`n`n### [DIVIDAS-$DATA]`n$Divida`n") -Encoding UTF8
    Write-Host "  [GATE 6] DIVIDAS_TECNICAS -- OK" -ForegroundColor Green
}

# --- Candidatos a Principio ---
if ($Candidato) {
    $candArq = "$BASE\CANDIDATOS_A_PRINCIPIO.md"
    $candC   = if (Test-Path $candArq) { Get-Content $candArq -Raw -Encoding UTF8 } else { "# CANDIDATOS A PRINCIPIO`n> Promover ao LEDGER quando padrao aparecer 3x.`n" }
    Set-Content $candArq -Value ($candC + "`n`n### [CANDIDATOS-$DATA]`n$Candidato`n") -Encoding UTF8
    Write-Host "  [GATE 6] CANDIDATOS_A_PRINCIPIO -- OK" -ForegroundColor Green
}

# --- Evolucao do Protocolo ---
if ($Padrao) {
    $protPath  = "$BASE\.claude\skills\vanguard-protocolo.md"
    $univPath  = "$BASE\PENTALATERAL_UNIVERSAL\OPERACAO\SKILL_PROTOCOLO_VANGUARD.md"
    if (Test-Path $protPath) {
        $protC = Get-Content $protPath -Raw -Encoding UTF8
        $blocoE = "`n`n### [EVOLUCAO-$DATA]`n$Padrao`n"
        if ($protC -notmatch "## EVOLUCOES DE PROCESSO EM CURSO") {
            $protC += "`n`n---`n`n## EVOLUCOES DE PROCESSO EM CURSO`n"
        }
        $protC += $blocoE
        Set-Content $protPath -Value $protC -Encoding UTF8
        if (Test-Path (Split-Path $univPath)) { Copy-Item $protPath $univPath -Force }
        Write-Host "  [GATE 6] PROTOCOLO VANGUARD -- OK" -ForegroundColor Green
    }
}

# --- Mandato Direto ---
if ($Mandato) {
    if (Test-Path $wipPath) {
        $bM   = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $p0   = @($bM.board.build) | Select-Object -First 1
        if ($p0) {
            $passo3 = "$BASE\CLIENTES\$($p0.cliente.ToUpper())\PASSO3_GEMINI.md"
            if (Test-Path $passo3) {
                $blocoM = "`n## [!!] [MANDATO_DIRETO_DO_DIRETOR] -- $DATA`n> Eduardo declarou diretamente.`n`n$Mandato`n`n---`n"
                $cM = Get-Content $passo3 -Raw -Encoding UTF8
                if ($cM -match "\[MANDATO_DIRETO_DO_DIRETOR\]") {
                    $cM = $cM -replace "(?s)## \[!!\] \[MANDATO_DIRETO_DO_DIRETOR\].*?---`r?`n", $blocoM
                } else { $cM = $blocoM + "`n" + $cM }
                Set-Content $passo3 -Value $cM -Encoding UTF8
                Write-Host "  [GATE 6] Mandato -> PASSO3_GEMINI ($($p0.cliente)) -- OK" -ForegroundColor Green
            }
        }
    }
}

# --- P-045: Artefatos de loop anterior ---
foreach ($proj in $projetosEmBuild) {
    $cli      = $proj.cliente.ToUpper()
    $cliDir   = "$BASE\CLIENTES\$cli"
    $hist     = "$cliDir\HISTORICO"
    if (Test-Path $hist) {
        $dirs   = @(Get-ChildItem $cliDir -Filter "DIRETRIZ_GEMINI_V*.txt" -ErrorAction SilentlyContinue |
                    Sort-Object Name -Descending)
        if (-not $dirs) {
            $dirs = @(Get-ChildItem $hist -Filter "DIRETRIZ*.txt" -ErrorAction SilentlyContinue |
                      Sort-Object Name -Descending)
        }
        if ($dirs) {
            $numD = 0
            if (($dirs | Select-Object -First 1).Name -match "V(\d+)") { $numD = [int]$Matches[1] }
            $mems = @(Get-ChildItem $hist -Filter "MEMORIA_V*.md" -ErrorAction SilentlyContinue |
                      Sort-Object Name -Descending)
            $numM = 0
            if ($mems -and ($mems | Select-Object -First 1).Name -match "V(\d+)") { $numM = [int]$Matches[1] }
            if ($numM -lt ($numD - 1)) {
                Write-Host "  [GATE 6] P-045 ALERTA [$cli]: DIRETRIZ V$numD -- MEMORIA mais recente V$numM" -ForegroundColor Red
                Write-Host "           Gerar MEMORIA + relatorio antes do proximo loop." -ForegroundColor Yellow
            } else {
                Write-Host "  [GATE 6] P-045 [$cli]: Artefatos OK (V$numM)" -ForegroundColor Green
            }
        }
    }
}

# --- Loop Continuity ---
$cmdGerado = Get-ChildItem "$BASE\CLIENTES" -Filter "COMANDO_ESTRATEGISTA*.md" -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime.Date -eq (Get-Date).Date } | Select-Object -First 1
if (-not $cmdGerado) {
    Write-Host "  [GATE 6] Loop Continuity: COMANDO_ESTRATEGISTA nao detectado hoje." -ForegroundColor Yellow
} else {
    Write-Host "  [GATE 6] Loop Continuity: $($cmdGerado.Name) -- OK" -ForegroundColor Green
}

# --- MANIFEST_DOCS ---
$baseUniversal = "$BASE\PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE"
foreach ($proj in $projetosEmBuild) {
    $cli      = $proj.cliente.ToUpper()
    $cliDir   = "$BASE\CLIENTES\$cli"
    $fontesDir = "$cliDir\NOTEBOOKLM_FONTES"
    if (-not (Test-Path $fontesDir)) {
        $manifestStatus[$cli] = "VERMELHO"
        Write-Host "  [GATE 6] MANIFEST [$cli]: NOTEBOOKLM_FONTES/ ausente" -ForegroundColor Red
        continue
    }
    $arqsMani  = [System.Collections.ArrayList]@()
    $stGeral   = "VERDE"
    $driftCnt  = 0
    $ausCnt    = 0
    $srcFiles  = @(Get-ChildItem $baseUniversal -File -ErrorAction SilentlyContinue)
    $locFiles  = @(Get-ChildItem $fontesDir -File -ErrorAction SilentlyContinue)
    foreach ($sf in $srcFiles) {
        $lm = $locFiles | Where-Object {
            $_.Name -eq $sf.Name -or $_.Name -match ("^\d{2}_" + [regex]::Escape($sf.Name) + "$")
        } | Select-Object -First 1
        if ($lm) {
            $hSrc = (Get-FileHash $sf.FullName  -Algorithm SHA256).Hash
            $hLoc = (Get-FileHash $lm.FullName  -Algorithm SHA256).Hash
            $st   = if ($hSrc -eq $hLoc) { "SYNC" } else { "DRIFT"; $stGeral = "AMARELO"; $driftCnt++ }
            [void]$arqsMani.Add([PSCustomObject]@{ nome=$lm.Name; hash_universal=$hSrc; hash_local=$hLoc; status=$st })
        } else {
            $hSrc = (Get-FileHash $sf.FullName -Algorithm SHA256).Hash
            $stGeral = "VERMELHO"; $ausCnt++
            [void]$arqsMani.Add([PSCustomObject]@{ nome=$sf.Name; hash_universal=$hSrc; hash_local=""; status="AUSENTE" })
        }
    }
    $manifest  = [PSCustomObject]@{
        projeto=$cli; ultima_sincronizacao=$HORA
        arquivos=$arqsMani.ToArray(); status_geral=$stGeral
        total=$arqsMani.Count; drift_count=$driftCnt; ausente_count=$ausCnt
    }
    $mPath = "$cliDir\MANIFEST_DOCS.json"
    $mBytes = [System.Text.Encoding]::UTF8.GetBytes(($manifest | ConvertTo-Json -Depth 5))
    [System.IO.File]::WriteAllBytes($mPath, $mBytes)
    $manifestStatus[$cli] = $stGeral
    $cor = if ($stGeral -eq "VERDE") {"Green"} elseif ($stGeral -eq "AMARELO") {"Yellow"} else {"Red"}
    Write-Host "  [GATE 6] MANIFEST [$cli]: $stGeral -- $($arqsMani.Count) arqs, $driftCnt drift, $ausCnt ausente" -ForegroundColor $cor
}

# --- knowledge_graph ---
if (Test-Path $KG) {
    try {
        $kg = Get-Content $KG -Raw -Encoding UTF8 | ConvertFrom-Json
        $ns = [PSCustomObject]@{
            date=$DATA; label="Sessao $DATA"
            friction_events=if($Friccao){1}else{0}
            principles_generated=if($Principio){@("novo")}else{@()}
            overrides=if($Override){@([PSCustomObject]@{description=$Override})}else{@()}
            drift_detected=if($Deriva){$true}else{$false}
        }
        $sess = [System.Collections.ArrayList]@()
        if ($kg.sessions) { foreach ($s in $kg.sessions) { [void]$sess.Add($s) } }
        $sess.Insert(0, $ns)
        if ($sess.Count -gt 20) { $sess = $sess[0..19] }
        $kg.sessions = $sess
        $kg.meta.last_updated = $DATA
        $kg.meta.total_sessions = $sess.Count
        $kgBytes = [System.Text.Encoding]::UTF8.GetBytes(($kg | ConvertTo-Json -Depth 10))
        [System.IO.File]::WriteAllBytes($KG, $kgBytes)
    } catch { }
}

$g6ok = -not ($manifestStatus.Values -contains "VERMELHO")
$gateStatus.G6 = if ($g6ok) { "VERDE" } else { "AMARELO" }

# ==========================================================================
# GATE 7 — LOG_EXECUCAO_DIARIA
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 7] Gerando LOG_EXECUCAO_DIARIA..." -ForegroundColor Cyan

$arquivosMod = @(& git -C $BASE diff --name-only HEAD 2>$null | Where-Object { $_ })
$arquivosMod += @(& git -C $BASE diff --name-only --cached 2>$null | Where-Object { $_ })
$arquivosMod = @($arquivosMod | Select-Object -Unique)

$pendentesAbertos    = [System.Collections.ArrayList]@()
$pendentesConcluidos = [System.Collections.ArrayList]@()
$pendentesPath = "$BASE\PENDENTES.md"
if (Test-Path $pendentesPath) {
    $linhasPend = Get-Content $pendentesPath -Encoding UTF8
    foreach ($l in $linhasPend) {
        if ($l -match "^\- \[ \]") {
            $desc = ($l -replace "^\- \[ \] ``[^``]+``\s*\*\*", "") -replace "\*\*.*", ""
            [void]$pendentesAbertos.Add($desc.Trim())
        } elseif ($l -match "^\- \[x\]") {
            $desc = ($l -replace "^\- \[x\]", "").Trim()
            [void]$pendentesConcluidos.Add($desc)
        }
    }
}

# Sync por projeto
$syncLinhas = "| Projeto | Status MANIFEST |`n|---------|----------------|"
foreach ($kv in $manifestStatus.GetEnumerator()) {
    $syncLinhas += "`n| $($kv.Key) | $($kv.Value) |"
}

$logConteudo = @"
# LOG DE EXECUCAO DIARIA -- $cliente . $DATA
> Gerado automaticamente por session_close.ps1
> Sessao encerrada: $HORA_EXIB

---

## 1. ARQUIVOS MODIFICADOS
$( if ($arquivosMod.Count -gt 0) { $arquivosMod | ForEach-Object { "- $_" } | Out-String } else { "Nenhum arquivo modificado detectado." } )

## 2. SINCRONIZACAO NOTEBOOKLM
$syncLinhas

## 3. PENDENTES ABERTOS ($(($pendentesAbertos).Count) itens)
$( if ($pendentesAbertos.Count -gt 0) { $pendentesAbertos | ForEach-Object { "- $_" } | Out-String } else { "Nenhum pendente aberto." } )

## 4. PENDENTES CONCLUIDOS NESTA SESSAO
$( if ($pendentesConcluidos.Count -gt 0) { $pendentesConcluidos | ForEach-Object { "+ $_" } | Out-String } else { "Nenhum pendente concluido." } )

## 5. STATUS GERAL
$( $statusGeral7 = "VERDE"
   foreach ($s in $manifestStatus.Values) {
       if ($s -eq "VERMELHO") { $statusGeral7 = "VERMELHO"; break }
       if ($s -eq "AMARELO" -and $statusGeral7 -ne "VERMELHO") { $statusGeral7 = "AMARELO" }
   }
   $statusGeral7 )
"@

if ($cliente -and $projetosEmBuild.Count -gt 0) {
    $histDir = "$BASE\CLIENTES\$cliente\HISTORICO"
    if (-not (Test-Path $histDir)) { New-Item -ItemType Directory -Path $histDir -Force | Out-Null }
    $logPath = "$histDir\LOG_EXECUCAO_DIARIA_$DATA.md"
    $logBytes = [System.Text.Encoding]::UTF8.GetBytes($logConteudo)
    [System.IO.File]::WriteAllBytes($logPath, $logBytes)
    Write-Host "  [GATE 7] LOG gerado: CLIENTES\$cliente\HISTORICO\LOG_EXECUCAO_DIARIA_$DATA.md" -ForegroundColor Green
    $gateStatus.G7 = "VERDE"
} else {
    Write-Host "  [GATE 7] Cliente nao identificado -- LOG nao gerado" -ForegroundColor Yellow
    $gateStatus.G7 = "AMARELO"
}

# ==========================================================================
# GATE 8 — Notificacao: e-mail + Telegram + Auto-preparacao dos 3 socios
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 8] Notificacao e auto-preparacao..." -ForegroundColor Cyan

# --- Determinar status geral ---
$statusFinal = "VERDE"
foreach ($s in $manifestStatus.Values) {
    if ($s -eq "VERMELHO") { $statusFinal = "VERMELHO"; break }
    if ($s -eq "AMARELO" -and $statusFinal -ne "VERMELHO") { $statusFinal = "AMARELO" }
}
if ($gateStatus.G1 -eq "AMARELO" -or $gateStatus.G2 -eq "AMARELO") {
    if ($statusFinal -eq "VERDE") { $statusFinal = "AMARELO" }
}

# --- Socio 1: Gemini ---
$anchorScript = "$BASE\scripts\gemini_anchor_generator.ps1"
if (Test-Path $anchorScript) {
    try {
        & powershell.exe -NonInteractive -File $anchorScript 2>$null | Out-Null
        Write-Host "  [GATE 8] Gemini -- CONTEXTO_GEMINI.md -- OK" -ForegroundColor Green
    } catch {
        Write-Host "  [GATE 8] Gemini -- falha" -ForegroundColor Yellow
    }
}

# --- Socio 2: NotebookLM ---
$prepScript = "$BASE\scripts\preparar_notebooklm_projeto.ps1"
if (Test-Path $prepScript) {
    foreach ($proj in $projetosEmBuild) {
        $cli = $proj.cliente.ToUpper()
        try {
            & powershell.exe -NonInteractive -File $prepScript -cliente $cli 2>$null | Out-Null
            Write-Host "  [GATE 8] NotebookLM/$cli -- fontes -- OK" -ForegroundColor Green
        } catch {
            Write-Host "  [GATE 8] NotebookLM/$cli -- falha" -ForegroundColor Yellow
        }
    }
}

# --- Socio 3: Embaixador ---
$embScript = "$BASE\scripts\ir_ao_embaixador.ps1"
if (Test-Path $embScript) {
    foreach ($proj in $projetosEmBuild) {
        $cli = $proj.cliente.ToUpper()
        try {
            & powershell.exe -NonInteractive -File $embScript -cliente $cli -AutoSync 2>$null | Out-Null
            Write-Host "  [GATE 8] Embaixador/$cli -- AutoSync -- OK" -ForegroundColor Green
        } catch {
            Write-Host "  [GATE 8] Embaixador/$cli -- falha" -ForegroundColor Yellow
        }
    }
}

# --- E-mail (email_fechamento.ps1) ---
$emailScript = "$BASE\scripts\email_fechamento.ps1"
$emailBodyPath = "$BASE\scripts\.email_body.txt"
$emailEnviado = $false
if (Test-Path $emailScript) {
    # Montar corpo do e-mail estruturado (ARTEFATO B)
    $listaMod = if ($arquivosMod.Count -gt 0) {
        ($arquivosMod | Select-Object -First 5 | ForEach-Object { "- $_" }) -join "`n"
    } else { "Nenhum arquivo modificado detectado." }
    $listaAlerta = @()
    foreach ($kv in $manifestStatus.GetEnumerator()) {
        if ($kv.Value -ne "VERDE") { $listaAlerta += "- [$($kv.Key)] MANIFEST: $($kv.Value)" }
    }
    $alertaBloco = if ($listaAlerta.Count -gt 0) { $listaAlerta -join "`n" } else { "Nenhum alerta ativo." }
    $pendBloco   = if ($pendentesAbertos.Count -gt 0) {
        ($pendentesAbertos | Select-Object -First 5 | ForEach-Object { "- $_" }) -join "`n"
    } else { "Nenhum pendente em aberto." }

    $emailBody = @"
Diretor,

Sessao de $DATA encerrada as $HORA_EXIB.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RESUMO DA SESSAO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Cliente ativo:   $cliente$(if ($loopAtualLabel) { " -- $loopAtualLabel" })
Status geral:    $statusFinal
Arquivos mod.:   $($arquivosMod.Count) arquivo(s)

MODIFICADOS:
$listaMod

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ALERTAS ATIVOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$alertaBloco

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PENDENTES ABERTOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$pendBloco

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
LOG completo: CLIENTES\$cliente\HISTORICO\LOG_EXECUCAO_DIARIA_$DATA.md
PAINEL: Claude Project "Embaixador -- Diretor"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Musculo . Pentalateral IAH . $DATA $HORA_EXIB
"@

    $emailBytes = [System.Text.Encoding]::UTF8.GetBytes($emailBody)
    [System.IO.File]::WriteAllBytes($emailBodyPath, $emailBytes)

    try {
        & powershell.exe -NonInteractive -File $emailScript 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [GATE 8] E-mail -- enviado -- OK" -ForegroundColor Green
            $emailEnviado = $true
            $gateStatus.G8e = "VERDE"
        } else {
            Write-Host "  [GATE 8] E-mail -- falha de envio" -ForegroundColor Yellow
            $gateStatus.G8e = "AMARELO"
            Add-Content "$BASE\CLIENTES\$cliente\HISTORICO\ERROS_EMAIL.log" -Value "[$DATA $HORA_EXIB] Falha no envio" -Encoding UTF8
        }
    } catch {
        Write-Host "  [GATE 8] E-mail -- excecao: $_" -ForegroundColor Yellow
        $gateStatus.G8e = "AMARELO"
    }
} else {
    Write-Host "  [GATE 8] email_fechamento.ps1 nao encontrado" -ForegroundColor DarkGray
    $gateStatus.G8e = "N/A"
}

# --- Telegram ---
$alertConfig = "$BASE\scripts\alert_config.ps1"
if (Test-Path $alertConfig) {
    . $alertConfig
    $statusEmoji = if ($statusFinal -eq "VERDE") {"VERDE"} elseif ($statusFinal -eq "AMARELO") {"AMARELO"} else {"VERMELHO"}
    $resumoTg  = "SESSAO ENCERRADA -- $DATA $HORA_EXIB`n"
    $resumoTg += "Cliente: $cliente$(if ($loopAtualLabel) { ' -- ' + $loopAtualLabel })`n"
    $resumoTg += "Status: $statusEmoji`n`n"
    $resumoTg += "Arquivos: $($arquivosMod.Count) modificados`n"
    if ($Friccao)   { $resumoTg += "Friccao: $Friccao`n" }
    if ($Principio) { $resumoTg += "Principio: $Principio`n" }
    $resumoTg += "`nSync:"
    foreach ($kv in $manifestStatus.GetEnumerator()) { $resumoTg += " $($kv.Key)=$($kv.Value)" }
    $resumoTg += "`nPendentes abertos: $($pendentesAbertos.Count)"
    $urlTg = "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage"
    try {
        Invoke-RestMethod -Uri $urlTg -Method POST -Body @{chat_id=$TELEGRAM_CHAT_ID; text=$resumoTg} | Out-Null
        Write-Host "  [GATE 8] Telegram -- OK" -ForegroundColor Green
        $gateStatus.G8t = "VERDE"
    } catch {
        Write-Host "  [GATE 8] Telegram -- $($_.Exception.Message)" -ForegroundColor Yellow
        $gateStatus.G8t = "AMARELO"
        Add-Content "$BASE\CLIENTES\$cliente\HISTORICO\ERROS_TELEGRAM.log" -Value "[$DATA $HORA_EXIB] $($_.Exception.Message)" -Encoding UTF8
    }
}

# ==========================================================================
# GATE 9 — PAINEL_ATIVIDADES para o Embaixador
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 9] Gerando PAINEL_ATIVIDADES..." -ForegroundColor Cyan
$painelScript = "$BASE\scripts\generate_protocolo_encerramento.ps1"
if (Test-Path $painelScript) {
    # Montar ANALISE GERENCIAL automatica
    $totalPend     = $pendentesAbertos.Count
    $gargaloCnt    = 0
    $deadlineInfo  = ""
    if ($projetosEmBuild.Count -gt 0) {
        $p0 = $projetosEmBuild | Where-Object { $_.cliente.ToUpper() -eq $cliente } | Select-Object -First 1
        if ($p0 -and $p0.deadline) {
            $dlDate = [datetime]::Parse($p0.deadline)
            $diasRest = ($dlDate - (Get-Date).Date).Days
            $deadlineInfo = "Deadline $($p0.deadline) -- $diasRest dia(s) restante(s)."
        }
        if ($p0 -and $p0.gates_bloqueantes) {
            $inicio = [datetime]::Parse($p0.build_iniciado_em)
            $p0.gates_bloqueantes | Get-Member -MemberType NoteProperty | ForEach-Object {
                $num = [int]($_.Name -replace '\D','')
                $gDate = $inicio.AddDays($num-1)
                if ($gDate.Date -le (Get-Date).Date) {
                    $conc = $false
                    if ($p0.dias_completos) { foreach ($d in $p0.dias_completos) { if ($d -match "^dia$num") { $conc = $true } } }
                    if (-not $conc) { $gargaloCnt++ }
                }
            }
        }
    }
    $analise  = "Projeto $cliente encerrou sessao com $totalPend pendente(s) aberto(s) e $gargaloCnt gargalo(s) de gate. "
    $analise += "Status documental: $statusFinal. $deadlineInfo "
    $analise += "Musculo: verificar se gargalos bloqueiam o proximo loop antes de ir ao Gemini."

    $entregasTexto = "Sessao $DATA -- $($arquivosMod.Count) arquivo(s) modificado(s). "
    $entregasTexto += "MANIFEST: $(($manifestStatus.Values | Select-Object -Unique) -join ', '). "
    if ($logPath) { $entregasTexto += "LOG: $logPath." }

    $painelFile = (& powershell.exe -NonInteractive -File $painelScript `
        -EntregasTexto $entregasTexto `
        -AlertasTexto  $alertaBloco `
        -AnaliseTexto  $analise `
        2>$null) | Select-Object -Last 1

    if ($painelFile -and (Test-Path $painelFile)) {
        Write-Host "  [GATE 9] PAINEL gerado: $painelFile" -ForegroundColor Cyan
        Write-Host "  [GATE 9] Upload ao Claude Projects: Embaixador -- Diretor" -ForegroundColor Yellow
        $gateStatus.G9 = "VERDE"
    } else {
        Write-Host "  [GATE 9] PAINEL nao gerado -- verificar generate_protocolo_encerramento.ps1" -ForegroundColor Yellow
        $gateStatus.G9 = "AMARELO"
    }
} else {
    Write-Host "  [GATE 9] generate_protocolo_encerramento.ps1 nao encontrado" -ForegroundColor DarkGray
    $gateStatus.G9 = "N/A"
}

# ==========================================================================
# POS-GATE — Claude Projects: arquivos para re-arrastar
# ==========================================================================
$todosArqs = @(
    (& git -C $BASE diff --name-only HEAD 2>$null)
    (& git -C $BASE diff --name-only --cached 2>$null)
) | Where-Object { $_ } | Select-Object -Unique

$padroesClaude = @(
    "MEMORIA_EMBAIXADOR\.md", "INTELLIGENCE_LEDGER\.md", "WIP_BOARD\.(json|txt)",
    "PERFIL_CLIENTE_.*\.md", "CLIENTES[\\/][A-Z]+[\\/]CLAUDE_PROJECT[\\/]",
    "DIRETRIZ_GEMINI.*\.txt", "PASSO7_EMBAIXADOR.*\.md", "PAINEL_ATIVIDADES.*\.md"
)
$arqsClaude = @($todosArqs | Where-Object {
    $cam = $_
    $padroesClaude | Where-Object { $cam -match $_ } | Select-Object -First 1
})

# ==========================================================================
# RELATORIO FINAL — 9 gates
# ==========================================================================
Write-Host ""
Write-Host "======================================================="
Write-Host "  SESSION CLOSE REPORT -- $DATA $HORA_EXIB"
Write-Host "  Cliente: $cliente$(if ($loopAtualLabel) { ' -- ' + $loopAtualLabel })"
Write-Host "======================================================="
Write-Host ""

$gateLabels = [ordered]@{
    G1  = "GATE 1  auditoria"
    G2  = "GATE 2  sync_docs"
    G3  = "GATE 3  propagate"
    G4  = "GATE 4  ledger_sync"
    G5  = "GATE 5  validate"
    G6  = "GATE 6  artefatos"
    G7  = "GATE 7  LOG"
    G8e = "GATE 8e e-mail"
    G8t = "GATE 8t Telegram"
    G9  = "GATE 9  PAINEL"
}
foreach ($k in $gateStatus.Keys) {
    $st  = $gateStatus[$k]
    $lbl = $gateLabels[$k]
    $cor = if ($st -eq "VERDE") {"Green"} elseif ($st -eq "AMARELO") {"Yellow"} elseif ($st -eq "VERMELHO") {"Red"} else {"DarkGray"}
    Write-Host ("  " + $lbl.PadRight(22) + ": " + $st) -ForegroundColor $cor
}

$corFinal = if ($statusFinal -eq "VERDE") {"Green"} elseif ($statusFinal -eq "AMARELO") {"Yellow"} else {"Red"}
Write-Host ""
Write-Host ("  STATUS GERAL                  : " + $statusFinal) -ForegroundColor $corFinal
Write-Host ""

$integridadeOK = ($gateStatus.G1 -ne "VERMELHO") -and ($gateStatus.G5 -ne "VERMELHO")
if ($integridadeOK) {
    Write-Host "  Sessao encerrada com integridade: SIM" -ForegroundColor Green
} else {
    Write-Host "  Sessao encerrada com integridade: NAO (gates bloqueantes falharam)" -ForegroundColor Red
}
Write-Host ""

# --- Aviso Claude Projects ---
if ($arqsClaude.Count -gt 0) {
    Write-Host "=======================================================" -ForegroundColor Magenta
    Write-Host "  ACAO MANUAL -- CLAUDE PROJECTS (EMBAIXADOR)"         -ForegroundColor Magenta
    Write-Host "=======================================================" -ForegroundColor Magenta
    Write-Host "  Re-arrastar ao Claude Projects do cliente:"            -ForegroundColor White
    foreach ($a in $arqsClaude) {
        Write-Host "  -> $a" -ForegroundColor Yellow
    }
    Write-Host "=======================================================" -ForegroundColor Magenta
    Write-Host ""
} else {
    Write-Host "  Nenhuma acao necessaria no Claude Projects." -ForegroundColor DarkGray
    Write-Host ""
}

Write-Host "======================================================="
Write-Host "  Proximo: git commit -- depois PASSO3 + Gemini."
Write-Host "======================================================="
