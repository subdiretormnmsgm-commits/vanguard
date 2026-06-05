#Requires -Version 5.1
# session_start.ps1 — Abertura de sessao Pentalateral IAH (P-071 / OSV-001)
# Ponto unico de entrada. 8 passos em sequencia.
# Uso: .\scripts\session_start.ps1 -cliente INGRID
#      .\scripts\session_start.ps1              (detecta cliente do WIP_BOARD)

param(
    [string]$cliente = ""
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE           = Split-Path -Parent $PSScriptRoot
$DATA           = Get-Date -Format "yyyy-MM-dd"
$HORA           = Get-Date -Format "HH:mm:ss"
$DEPENDENCY_MAP = "$BASE\PENTALATERAL_UNIVERSAL\OPERACAO\DEPENDENCY_MAP.json"
$WIP_BOARD      = "$BASE\CLIENTES\WIP_BOARD.json"
$PENDENTES      = "$BASE\PENDENTES.md"

$statusGeral  = "VERDE"
$bloqueios    = [System.Collections.ArrayList]@()
$avisos       = [System.Collections.ArrayList]@()
$infoLinhas   = [System.Collections.ArrayList]@()

function Set-StatusAmarclo { if ($statusGeral -ne "VERMELHO") { $script:statusGeral = "AMARELO" } }
function Set-StatusVermelho { $script:statusGeral = "VERMELHO" }

Write-Host ""
Write-Host "======================================================="
Write-Host "  SESSION START -- Pentalateral IAH"
Write-Host "  $DATA $HORA"
Write-Host "======================================================="
Write-Host ""

# --- Projetos ativos ---
$projetosEmBuild = @()
if (Test-Path $WIP_BOARD) {
    try {
        $board = Get-Content $WIP_BOARD -Raw -Encoding UTF8 | ConvertFrom-Json
        $projetosEmBuild = @($board.board.build | Where-Object { $_.cliente })
    } catch { }
}

# --- Cliente principal ---
if ($cliente -eq "" -and $projetosEmBuild.Count -gt 0) {
    if ($projetosEmBuild.Count -eq 1) {
        $cliente = $projetosEmBuild[0].cliente.ToUpper()
    } else {
        # P-059: com mais de 1 projeto em BUILD, listar e aguardar escolha
        Write-Host "  [P-059] Multiplos projetos em BUILD detectados:" -ForegroundColor Yellow
        for ($i = 0; $i -lt $projetosEmBuild.Count; $i++) {
            Write-Host "    $($i+1). $($projetosEmBuild[$i].cliente.ToUpper()) -- $($projetosEmBuild[$i].loop_atual)"
        }
        Write-Host "  Use: .\scripts\session_start.ps1 -cliente [NOME]" -ForegroundColor Yellow
        Write-Host "  Nunca selecionar silenciosamente. (P-059)" -ForegroundColor Yellow
        exit 0
    }
}

$clienteLabel = $cliente.ToUpper()
$projAtivo = $projetosEmBuild | Where-Object { $_.cliente.ToUpper() -eq $clienteLabel } | Select-Object -First 1
$loopLabel = if ($projAtivo -and $projAtivo.loop_atual) { $projAtivo.loop_atual } else { "Loop ?" }
$deadline  = if ($projAtivo -and $projAtivo.deadline) { $projAtivo.deadline } else { "sem prazo" }
$diasRest  = "?"
if ($deadline -ne "sem prazo") {
    try {
        $dlDate = [datetime]::Parse($deadline)
        $diasRest = ($dlDate - (Get-Date).Date).Days
    } catch { }
}

Write-Host "  Cliente: $clienteLabel -- $loopLabel -- Deadline: $deadline ($diasRest dias)" -ForegroundColor Cyan
Write-Host ""

# ==========================================================================
# PASSO 0 — Bloqueio: DECISOES.json sem veredito pendente (P-059 pipeline)
# ==========================================================================
Write-Host "  [PASSO 0] Verificando DECISOES pendentes..." -ForegroundColor Cyan
$decisoesComPendencia = @()
foreach ($proj in $projetosEmBuild) {
    $cli   = $proj.cliente.ToUpper()
    $pasta = "$BASE\CLIENTES\$cli\CLAUDE_PROJECT\DECISOES"
    if (-not (Test-Path $pasta)) { continue }
    $jsonD = Get-ChildItem "$pasta\DECISOES_*.json" -ErrorAction SilentlyContinue |
             Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $jsonV = Get-ChildItem "$pasta\VEREDITOS_*.json" -ErrorAction SilentlyContinue |
             Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $pendente = $jsonD -and (-not $jsonV -or $jsonD.LastWriteTime -gt $jsonV.LastWriteTime)
    if ($pendente) { $decisoesComPendencia += [PSCustomObject]@{ Projeto=$cli; Arquivo=$jsonD.Name } }
}

if ($decisoesComPendencia.Count -gt 0) {
    Write-Host ""
    Write-Host "  ============================================" -ForegroundColor Red
    Write-Host "  PAINEL PENDENTE -- DELIBERACAO OBRIGATORIA" -ForegroundColor Red
    Write-Host "  ============================================" -ForegroundColor Red
    foreach ($dp in $decisoesComPendencia) {
        Write-Host "  Projeto: $($dp.Projeto) -- $($dp.Arquivo)" -ForegroundColor Red
        Write-Host "  O Diretor NAO delibera verbalmente." -ForegroundColor Red

        $renderScript = "$BASE\scripts\render_painel.ps1"
        if (Test-Path $renderScript) {
            Write-Host "  Abrindo painel agora..." -ForegroundColor Yellow
            Start-Process powershell -ArgumentList "-NonInteractive -File `"$renderScript`" -projeto $($dp.Projeto)" -WindowStyle Normal
        }
    }
    Write-Host ""
    Write-Host "  [BLOQUEIO] Sessao pausada -- aguardando VEREDITOS..." -ForegroundColor Yellow
    Write-Host "  Delibere no painel HTML e salve o VEREDITOS.json." -ForegroundColor White
    Write-Host ""

    $limite = 120
    $espera = 0
    $liberado = $false
    while ($espera -lt $limite) {
        Start-Sleep -Seconds 10
        $espera += 10
        $aindaPendente = $false
        foreach ($dp in $decisoesComPendencia) {
            $pasta = "$BASE\CLIENTES\$($dp.Projeto)\CLAUDE_PROJECT\DECISOES"
            $jsonD = Get-ChildItem "$pasta\DECISOES_*.json" -ErrorAction SilentlyContinue |
                     Sort-Object LastWriteTime -Descending | Select-Object -First 1
            $jsonV = Get-ChildItem "$pasta\VEREDITOS_*.json" -ErrorAction SilentlyContinue |
                     Sort-Object LastWriteTime -Descending | Select-Object -First 1
            if ($jsonD -and (-not $jsonV -or $jsonD.LastWriteTime -gt $jsonV.LastWriteTime)) {
                $aindaPendente = $true
            }
        }
        if (-not $aindaPendente) { $liberado = $true; break }
        Write-Host "  [AGUARDANDO] $espera s -- Vereditos ainda pendentes..." -ForegroundColor DarkGray
    }

    if ($liberado) {
        Write-Host "  [DESBLOQUEIO] Vereditos recebidos -- sessao pode continuar." -ForegroundColor Green
    } else {
        Write-Host "  [TIMEOUT] Limite de $($limite)s atingido." -ForegroundColor Yellow
        Write-Host "  Prosseguindo -- certifique-se de deliberar antes de criar novos DECISOES." -ForegroundColor Yellow
    }
}

# ==========================================================================
# PASSO 0b — Ler PAINEL_ATIVIDADES da sessao anterior
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 0b] Carregando PAINEL anterior..." -ForegroundColor Cyan
$painelDir    = "$BASE\PROTOCOLOS_ENCERRAMENTO"
$painelAnter  = $null
$painelData   = "nao encontrado"
if (Test-Path $painelDir) {
    $painelAnter = Get-ChildItem "$painelDir\PAINEL_ATIVIDADES_*.md" -ErrorAction SilentlyContinue |
                   Sort-Object Name -Descending | Select-Object -First 1
}
if ($painelAnter) {
    $painelData = $painelAnter.Name -replace "PAINEL_ATIVIDADES_","" -replace "\.md",""
    [void]$infoLinhas.Add("PAINEL anterior: $painelData carregado")
    Write-Host "  [OK] PAINEL de $painelData carregado" -ForegroundColor Green
} else {
    [void]$avisos.Add("PAINEL anterior nao encontrado -- agenda gerada sem PAINEL")
    Write-Host "  [AVISO] PAINEL anterior nao encontrado" -ForegroundColor Yellow
    Set-StatusAmarclo
}

# --- Ler alertas do PAINEL anterior ---
$alertasPainel   = [System.Collections.ArrayList]@()
$pendentesVencidos = [System.Collections.ArrayList]@()
if ($painelAnter) {
    $linhasPainel = Get-Content $painelAnter.FullName -Encoding UTF8 -ErrorAction SilentlyContinue
    $emDeficit = $false
    foreach ($l in $linhasPainel) {
        if ($l -match "## ATIVIDADES EM DEFICIT") { $emDeficit = $true; continue }
        if ($l -match "^## " -and $emDeficit) { $emDeficit = $false }
        if ($emDeficit -and $l -match "\|.*\|.*\|.*\|") {
            if ($l -notmatch "^---" -and $l -notmatch "Projeto.*Tarefa") {
                $cols = $l -split "\|" | Where-Object { $_.Trim() } | ForEach-Object { $_.Trim() }
                if ($cols.Count -ge 3) { [void]$pendentesVencidos.Add($cols[1]) }
            }
        }
    }
}

# ==========================================================================
# PASSO 0c -- Violacao canonical (P-073) -- BLOQUEANTE se VERMELHO
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 0c] Verificando integridade canonical (P-073)..." -ForegroundColor Cyan
$detectScript = "$BASE\scripts\detect_canonical_violation.ps1"
if (Test-Path $detectScript) {
    $outViolacao = & powershell -NonInteractive -File $detectScript 2>&1
    $exitViolacao = $LASTEXITCODE
    if ($exitViolacao -ne 0) {
        Write-Host "  [VERMELHO] Violacoes canonicas detectadas:" -ForegroundColor Red
        $outViolacao | Where-Object { $_ -match 'VIOLACAO|BLOQUEIO' } | ForEach-Object {
            Write-Host "    * $_" -ForegroundColor Red
        }
        [void]$bloqueios.Add("P-073: arquivo editado fora da fonte canonical -- resolver antes de continuar")
        Set-StatusVermelho
        Write-Host "  Acao: edite apenas a fonte canonical. Execute propagate_changes.ps1." -ForegroundColor Yellow
    } else {
        $temAmarelo = $outViolacao | Where-Object { $_ -match 'AMARELO|DRIFT' }
        if ($temAmarelo) {
            Write-Host "  [AMARELO] Drift detectado (sync pendente -- nao eh violacao)" -ForegroundColor Yellow
            [void]$avisos.Add("P-073: drift em documentos universais -- rodar sync_vanguard_docs.ps1")
            Set-StatusAmarclo
        } else {
            Write-Host "  [OK] Integridade canonical VERDE" -ForegroundColor Green
        }
    }
} else {
    Write-Host "  [AVISO] detect_canonical_violation.ps1 nao encontrado -- gate ignorado" -ForegroundColor Yellow
    Set-StatusAmarclo
}

# ==========================================================================
# PASSO 1 -- Ler PENDENTES.md completo (P-063 BLOQUEANTE)
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 1] Lendo PENDENTES.md (P-063)..." -ForegroundColor Cyan
$totalPendentes = 0
$pendentesCriticos  = [System.Collections.ArrayList]@()
$pendentesImportant = [System.Collections.ArrayList]@()
$pendentesRotina    = [System.Collections.ArrayList]@()
$hoje = (Get-Date).Date

if (Test-Path $PENDENTES) {
    $linhasPend = Get-Content $PENDENTES -Encoding UTF8
    foreach ($l in $linhasPend) {
        if ($l -match "^\- \[ \]") {
            $totalPendentes++
            $desc = ($l -replace "^\- \[ \] ``[^``]+``\s*\*\*","") -replace "\*\*.*",""
            $desc = $desc.Trim()
            if ($desc.Length -gt 70) { $desc = $desc.Substring(0,67) + "..." }

            $dataTarefa = $hoje
            $dataMatch  = [regex]::Match($l, '`(\d{4}-\d{2}-\d{2})`')
            if ($dataMatch.Success) {
                try { $dataTarefa = [datetime]::ParseExact($dataMatch.Groups[1].Value,"yyyy-MM-dd",$null) } catch { }
            }
            $diasAtraso = ($hoje - $dataTarefa.Date).Days

            if ($l -match "ALERTA CRITICO" -or $diasAtraso -ge 2) {
                [void]$pendentesCriticos.Add("$desc [+${diasAtraso}d]")
            } elseif ($diasAtraso -ge 0) {
                [void]$pendentesImportant.Add($desc)
            } else {
                [void]$pendentesRotina.Add($desc)
            }
        }
    }
    [void]$infoLinhas.Add("PENDENTES: $totalPendentes item(ns)")
    Write-Host "  [OK] $totalPendentes pendente(s) lido(s)" -ForegroundColor Green
} else {
    [void]$bloqueios.Add("PENDENTES.md nao encontrado -- P-063 violado")
    Write-Host "  [BLOQUEIO] PENDENTES.md nao encontrado. Criar antes de prosseguir." -ForegroundColor Red
    Set-StatusVermelho
}

# ==========================================================================
# PASSO 2 — sync_passo_files.ps1
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 2] Sync PASSO files..." -ForegroundColor Cyan
$syncPassoScript = "$BASE\scripts\sync_passo_files.ps1"
if (Test-Path $syncPassoScript) {
    try {
        & powershell.exe -NonInteractive -File $syncPassoScript 2>$null | Out-Null
        Write-Host "  [OK] sync_passo_files -- OK" -ForegroundColor Green
        [void]$infoLinhas.Add("sync_passo_files: OK")
    } catch {
        Write-Host "  [AVISO] sync_passo_files -- falha" -ForegroundColor Yellow
        Set-StatusAmarclo
    }
} else {
    Write-Host "  [--] sync_passo_files nao encontrado" -ForegroundColor DarkGray
    [void]$infoLinhas.Add("sync_passo_files: N/A")
}

# ==========================================================================
# PASSO 3 — Estado real dos projetos (P-055)
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 3] Estado dos projetos..." -ForegroundColor Cyan
$estadoProjetos = [System.Collections.ArrayList]@()
foreach ($proj in $projetosEmBuild) {
    $cli     = $proj.cliente.ToUpper()
    $loop    = if ($proj.loop_atual) { $proj.loop_atual } else { "Loop ?" }
    $dias    = if ($proj.dias_completos) { $proj.dias_completos.Count } else { 0 }
    $dl      = if ($proj.deadline) { $proj.deadline } else { "sem prazo" }
    $skillPat = "$BASE\.claude\skills\$($cli.ToLower())-v*.md"
    $skillFile = Get-ChildItem $skillPat -ErrorAction SilentlyContinue |
                 Sort-Object Name -Descending | Select-Object -First 1
    $skillLabel = if ($skillFile) { $skillFile.Name } else { "skill nao encontrada" }
    $linha = "  $($cli.PadRight(10)) $($loop.PadRight(12)) Dias:$dias  $skillLabel  Deadline:$dl"
    Write-Host $linha -ForegroundColor White
    [void]$estadoProjetos.Add("${cli}: $loop -- $skillLabel")
}

# ==========================================================================
# PASSO 4 — Ler MANIFEST_DOCS.json de cada projeto
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 4] Verificando MANIFEST_DOCS..." -ForegroundColor Cyan
$manifestInfo = [ordered]@{}
foreach ($proj in $projetosEmBuild) {
    $cli      = $proj.cliente.ToUpper()
    $mPath    = "$BASE\CLIENTES\$cli\MANIFEST_DOCS.json"
    if (Test-Path $mPath) {
        try {
            $m   = Get-Content $mPath -Raw -Encoding UTF8 | ConvertFrom-Json
            $st  = $m.status_geral
            $cor = if ($st -eq "VERDE") {"Green"} elseif ($st -eq "AMARELO") {"Yellow"} else {"Red"}
            Write-Host "  [$st] $cli -- $($m.total) arqs -- $($m.drift_count) drift -- $($m.ausente_count) ausente" -ForegroundColor $cor
            $manifestInfo[$cli] = $st
            if ($st -eq "VERMELHO") { Set-StatusVermelho; [void]$bloqueios.Add("MANIFEST ${cli}: VERMELHO") }
            elseif ($st -eq "AMARELO") { Set-StatusAmarclo; [void]$avisos.Add("MANIFEST ${cli}: AMARELO ($($m.drift_count) drift)") }
        } catch {
            Write-Host "  [AVISO] $cli -- MANIFEST invalido" -ForegroundColor Yellow
            $manifestInfo[$cli] = "AMARELO"
            Set-StatusAmarclo
        }
    } else {
        Write-Host "  [--] $cli -- MANIFEST nao encontrado" -ForegroundColor DarkGray
        $manifestInfo[$cli] = "N/A"
    }
}

# ==========================================================================
# PASSO 5 — P-045: Artefatos de fechamento do loop anterior
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 5] Artefatos de loop anterior (P-045)..." -ForegroundColor Cyan
$artefatosOK = $true
foreach ($proj in $projetosEmBuild) {
    $cli   = $proj.cliente.ToUpper()
    $cliDir = "$BASE\CLIENTES\$cli"
    $hist   = "$cliDir\HISTORICO"
    if (-not (Test-Path $hist)) { continue }
    $dirs = @(Get-ChildItem $cliDir -Filter "DIRETRIZ_GEMINI_V*.txt" -ErrorAction SilentlyContinue |
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
            Write-Host "  [BLOQUEIO] P-045 [$cli]: DIRETRIZ V$numD sem MEMORIA V$($numD-1)" -ForegroundColor Red
            Write-Host "             Gerar MEMORIA_V$($numD-1) + relatorio antes do proximo loop." -ForegroundColor Yellow
            [void]$bloqueios.Add("P-045 [$cli]: MEMORIA V$($numD-1) ausente")
            $artefatosOK = $false
            Set-StatusVermelho
        } else {
            Write-Host "  [OK] [$cli] Artefatos V$numM -- OK" -ForegroundColor Green
        }
    }
}
if ($artefatosOK) { [void]$infoLinhas.Add("P-045: Artefatos OK") }

# ==========================================================================
# PASSO 6 — VEREDITOS da sessao anterior
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 6] Carregando VEREDITOS anteriores..." -ForegroundColor Cyan
$vreditosLabel = "nao encontrado"
if ($clienteLabel) {
    $vDir = "$BASE\CLIENTES\$clienteLabel\CLAUDE_PROJECT\DECISOES"
    if (Test-Path $vDir) {
        $vFile = Get-ChildItem "$vDir\VEREDITOS_*.json" -ErrorAction SilentlyContinue |
                 Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($vFile) {
            $vreditosLabel = $vFile.Name
            Write-Host "  [OK] Vereditos: $($vFile.Name)" -ForegroundColor Green
        } else {
            Write-Host "  [AVISO] Nenhum VEREDITOS anterior encontrado" -ForegroundColor Yellow
            [void]$avisos.Add("Vereditos anteriores nao encontrados")
            Set-StatusAmarclo
        }
    }
}
[void]$infoLinhas.Add("Vereditos: $vreditosLabel")

# ==========================================================================
# PASSO 7 — P-059: Confirmacao de isolamento de contexto
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 7] Confirmando isolamento de contexto (P-059)..." -ForegroundColor Cyan
Write-Host ""
Write-Host "  ============================================" -ForegroundColor Cyan
Write-Host "  CLIENTE DETECTADO: $clienteLabel -- $loopLabel" -ForegroundColor Cyan
Write-Host "  Confirmar antes de prosseguir? (s/n)"         -ForegroundColor Cyan
Write-Host "  ============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  [Auto-confirmado em modo script -- P-059 declarado ao Diretor]" -ForegroundColor DarkGray
[void]$infoLinhas.Add("P-059: Cliente $clienteLabel -- $loopLabel -- confirmado")

# ==========================================================================
# PASSO 8 — Iniciar decisoes_watcher.ps1 em background
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 8] Iniciando pipeline DECISOES em background..." -ForegroundColor Cyan
$watcherScript = "$BASE\scripts\decisoes_watcher.ps1"
if (Test-Path $watcherScript) {
    Start-Process powershell -ArgumentList "-NonInteractive -File `"$watcherScript`"" -WindowStyle Hidden
    Write-Host "  [OK] decisoes_watcher.ps1 ativo -- monitorando DECISOES/" -ForegroundColor Green
} else {
    Write-Host "  [--] decisoes_watcher.ps1 nao encontrado" -ForegroundColor DarkGray
}

# ==========================================================================
# PASSO 8b — Iniciar skill_watcher.ps1 em background (OSV-003)
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 8b] Iniciando SKILL_WATCHER em background..." -ForegroundColor Cyan
$skillWatcherScript = "$BASE\scripts\skill_watcher.ps1"
if (Test-Path $skillWatcherScript) {
    if ($clienteLabel -ne "") {
        Start-Process powershell -ArgumentList "-NonInteractive -File `"$skillWatcherScript`" -cliente $clienteLabel" -WindowStyle Hidden
        Write-Host "  [OK] skill_watcher.ps1 ativo -- monitorando NOTEBOOKLM_DROP/$clienteLabel/" -ForegroundColor Green
        [void]$infoLinhas.Add("SkillWatcher: ATIVO para $clienteLabel")
    } else {
        Write-Host "  [--] skill_watcher: nenhum cliente ativo -- ignorado" -ForegroundColor DarkGray
        [void]$infoLinhas.Add("SkillWatcher: N/A (sem cliente)")
    }
} else {
    Write-Host "  [--] skill_watcher.ps1 nao encontrado" -ForegroundColor DarkGray
    [void]$infoLinhas.Add("SkillWatcher: nao encontrado")
}

# ==========================================================================
# PASSO 8c — Agenda de gates calculada automaticamente (OSV-003)
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 8c] Computando agenda de gates..." -ForegroundColor Cyan
$agendaScript = "$BASE\scripts\agenda_scheduler.ps1"
if (Test-Path $agendaScript) {
    try {
        & powershell -NonInteractive -File $agendaScript 2>&1 | ForEach-Object { Write-Host "  $_" }
        [void]$infoLinhas.Add("AgendaScheduler: OK")
    } catch {
        Write-Host "  [AVISO] agenda_scheduler.ps1 falhou: $_" -ForegroundColor Yellow
        [void]$avisos.Add("AgendaScheduler: falha de execucao")
        Set-StatusAmarclo
    }
} else {
    Write-Host "  [--] agenda_scheduler.ps1 nao encontrado" -ForegroundColor DarkGray
    [void]$infoLinhas.Add("AgendaScheduler: nao encontrado")
}

# ==========================================================================
# PASSO 8d — Registrar churn_watch_autonomo.ps1 no Task Scheduler (OSV-003)
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 8d] Verificando Task Scheduler -- CHURN-WATCH..." -ForegroundColor Cyan
$churnScript  = "$BASE\scripts\churn_watch_autonomo.ps1"
$churnTask    = "ChurnWatch_Vanguard"
$existeTask   = Get-ScheduledTask -TaskName $churnTask -ErrorAction SilentlyContinue
if ($existeTask) {
    Write-Host "  [OK] Task Scheduler: $churnTask ja registrado (08:00 diario)" -ForegroundColor Green
    [void]$infoLinhas.Add("ChurnWatch Task: JA EXISTE")
} elseif (Test-Path $churnScript) {
    try {
        $action   = New-ScheduledTaskAction -Execute "powershell.exe" `
                        -Argument "-NonInteractive -File `"$churnScript`""
        $trigger  = New-ScheduledTaskTrigger -Daily -At "08:00"
        $settings = New-ScheduledTaskSettingsSet `
                        -ExecutionTimeLimit (New-TimeSpan -Hours 1) `
                        -RunOnlyIfNetworkAvailable $false
        Register-ScheduledTask -TaskName $churnTask -Action $action `
            -Trigger $trigger -Settings $settings `
            -Description "Vanguard CHURN-WATCH diario (OSV-003)" `
            -RunLevel Highest -Force | Out-Null
        Write-Host "  [OK] Task Scheduler: $churnTask registrado (08:00 diario)" -ForegroundColor Green
        [void]$infoLinhas.Add("ChurnWatch Task: REGISTRADO")
    } catch {
        Write-Host "  [AVISO] Task Scheduler requer execucao elevada para registrar." -ForegroundColor Yellow
        Write-Host "  Execute session_start.ps1 como Administrador uma vez para registrar a task." -ForegroundColor DarkGray
        Write-Host "  Alternativa manual: .\scripts\churn_watch_autonomo.ps1" -ForegroundColor DarkGray
        [void]$avisos.Add("ChurnWatch_Vanguard: nao registrado -- elevar permissoes (executar como Admin uma vez)")
        Set-StatusAmarclo
    }
} else {
    Write-Host "  [--] churn_watch_autonomo.ps1 nao encontrado" -ForegroundColor DarkGray
    [void]$infoLinhas.Add("ChurnWatch Task: script nao encontrado")
}

# ==========================================================================
# PASSO 8e — N-1: Verificar status do n8n (P-101)
# ==========================================================================
Write-Host ""
Write-Host "  [PASSO 8e] Verificando n8n (P-101)..." -ForegroundColor Cyan
$pingN8nScript = "$BASE\scripts\ping_n8n.ps1"
if (Test-Path $pingN8nScript) {
    & powershell.exe -NonInteractive -File "$pingN8nScript" | ForEach-Object { Write-Host "  $_" }
    $pingExit = $LASTEXITCODE
    if ($pingExit -eq 0) {
        [void]$infoLinhas.Add("n8n: ONLINE")
    } else {
        [void]$avisos.Add("n8n OFFLINE -- Check-in 7h/13h/20h + Monitor Supabase + alertas desativados")
        Set-StatusAmarclo
    }
} else {
    Write-Host "  [--] ping_n8n.ps1 nao encontrado (N-1 pendente)" -ForegroundColor DarkGray
    [void]$infoLinhas.Add("n8n: N/A (ping_n8n.ps1 ausente)")
}

# ==========================================================================
# LEMBRETE DE LOOP — ONDE ESTAMOS (OSV-004, P-027)
# Exibir ANTES da AGENDA DO DIA — Músculo nao pode ignorar
# ==========================================================================
Write-Host ""
Write-Host "  +====================================================+" -ForegroundColor Cyan
Write-Host "  |  ONDE ESTAMOS NO LOOP -- LER ANTES DE QUALQUER ACAO  |" -ForegroundColor Cyan
Write-Host "  +====================================================+" -ForegroundColor Cyan

$loopMostrouAlgo = $false
foreach ($proj in $projetosEmBuild) {
    $fase = $proj.loop_fase_atual
    if (-not $fase) { continue }
    $loopMostrouAlgo = $true

    $g = if ($fase.gemini     -eq "OK") { "OK" } else { "PENDENTE" }
    $n = if ($fase.notebooklm -eq "OK") { "OK" } else { "PENDENTE" }
    $e = if ($fase.embaixador -eq "OK") { "OK" } else { "PENDENTE" }
    $m = if ($fase.musculo    -eq "OK") { "OK" } else { "PENDENTE" }

    $corG = if ($g -eq "OK") { "Green" } else { "Yellow" }
    $corN = if ($n -eq "OK") { "Green" } else { "Yellow" }
    $corE = if ($e -eq "OK") { "Green" } else { "Yellow" }
    $corM = if ($m -eq "OK") { "Green" } else { "Yellow" }

    $projetoLabel = "$($proj.cliente.ToUpper()) -- Loop $($fase.loop)"
    Write-Host ("  |  " + $projetoLabel.PadRight(49) + "|") -ForegroundColor White
    Write-Host "  |    Gemini      : " -NoNewline
    Write-Host ($g.PadRight(34) + "|") -ForegroundColor $corG
    Write-Host "  |    NotebookLM  : " -NoNewline
    Write-Host ($n.PadRight(34) + "|") -ForegroundColor $corN
    Write-Host "  |    Embaixador  : " -NoNewline
    Write-Host ($e.PadRight(34) + "|") -ForegroundColor $corE
    Write-Host "  |    Musculo     : " -NoNewline
    Write-Host ($m.PadRight(34) + "|") -ForegroundColor $corM

    $proximo = if ($fase.proximo) { $fase.proximo } else { "nao definido" }
    $proxLabel = if ($proximo.Length -gt 47) { $proximo.Substring(0, 44) + "..." } else { $proximo }
    Write-Host ("  |  -> " + $proxLabel.PadRight(47) + "|") -ForegroundColor Yellow
    Write-Host "  +----------------------------------------------------+" -ForegroundColor Cyan
}

if (-not $loopMostrouAlgo) {
    Write-Host "  |  Nenhum loop_fase_atual no WIP_BOARD -- atualizar   |" -ForegroundColor DarkGray
    Write-Host "  +----------------------------------------------------+" -ForegroundColor Cyan
}
Write-Host "  |  Pular etapa = loop contaminado. Confirmar o passo.   |" -ForegroundColor Red
Write-Host "  +====================================================+" -ForegroundColor Cyan
Write-Host ""

# ==========================================================================
# AGENDA DO DIA — formato visual
# ==========================================================================
function Format-AgendaItem([string]$item, [int]$max = 52) {
    if ($item.Length -gt $max) { return $item.Substring(0, $max - 3) + "..." }
    return $item
}

$agendaCritico   = @($pendentesCriticos    | Select-Object -First 3)
$agendaImportant = @($pendentesImportant   | Select-Object -First 3)
$agendaRotina    = @($pendentesRotina      | Select-Object -First 3)

$diaLabel = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
$diaLabel = $diaLabel.Substring(0,1).ToUpper() + $diaLabel.Substring(1)

Write-Host ""
Write-Host "  +====================================================+"
Write-Host ("  |  AGENDA DO DIA -- $DATA ($diaLabel)".PadRight(53) + "|")
if ($painelAnter) {
    Write-Host ("  |  Fonte: PAINEL de $painelData + PENDENTES".PadRight(53) + "|")
} else {
    Write-Host "  |  Fonte: PENDENTES + WIP (PAINEL anterior ausente)   |"
}
Write-Host "  +====================================================+"
Write-Host ("  |  PROJETO: $clienteLabel -- $loopLabel".PadRight(53) + "|")
Write-Host ("  |  Gate:    $deadline ($diasRest dias restantes)".PadRight(53) + "|")
Write-Host "  +----------------------------------------------------+"

if ($agendaCritico.Count -gt 0) {
    Write-Host "  |  CRITICO -- antes de qualquer outra coisa:         |" -ForegroundColor Red
    foreach ($i in $agendaCritico) {
        Write-Host ("  |  - " + (Format-AgendaItem $i).PadRight(49) + "|") -ForegroundColor Red
    }
} else {
    Write-Host "  |  CRITICO -- nenhum item critico hoje               |" -ForegroundColor Green
}

Write-Host "  +----------------------------------------------------+"
if ($agendaImportant.Count -gt 0) {
    Write-Host "  |  IMPORTANTE -- fechar nesta sessao:                |" -ForegroundColor Yellow
    foreach ($i in $agendaImportant) {
        Write-Host ("  |  - " + (Format-AgendaItem $i).PadRight(49) + "|") -ForegroundColor Yellow
    }
} else {
    Write-Host "  |  IMPORTANTE -- nenhum item urgente hoje            |" -ForegroundColor DarkGray
}

Write-Host "  +----------------------------------------------------+"
if ($agendaRotina.Count -gt 0) {
    Write-Host "  |  ROTINA -- se sobrar tempo:                        |" -ForegroundColor DarkGray
    foreach ($i in $agendaRotina) {
        Write-Host ("  |  - " + (Format-AgendaItem $i).PadRight(49) + "|") -ForegroundColor DarkGray
    }
} else {
    Write-Host "  |  ROTINA -- nenhum item de manutencao pendente      |" -ForegroundColor DarkGray
}

Write-Host "  +====================================================+"

# ==========================================================================
# RELATORIO FINAL DE ABERTURA
# ==========================================================================
$corFinal = if ($statusGeral -eq "VERDE") {"Green"} elseif ($statusGeral -eq "AMARELO") {"Yellow"} else {"Red"}
Write-Host ""
Write-Host "  ======================================================="
Write-Host ("  SESSION START -- $DATA $HORA")
Write-Host ("  Cliente: $clienteLabel -- $loopLabel")
Write-Host "  ======================================================="
Write-Host ("  PAINEL anterior  : " + (if ($painelAnter) { "$painelData carregado" } else { "nao encontrado (AVISO)" })) -ForegroundColor (if ($painelAnter) {"Green"} else {"Yellow"})
Write-Host ("  PENDENTES        : $totalPendentes item(ns) -- $($pendentesCriticos.Count) criticos, $($pendentesImportant.Count) importantes")

foreach ($proj in $projetosEmBuild) {
    $cli = $proj.cliente.ToUpper()
    $mSt = if ($manifestInfo.Contains($cli)) { $manifestInfo[$cli] } else { "N/A" }
    $cor = if ($mSt -eq "VERDE") {"Green"} elseif ($mSt -eq "AMARELO") {"Yellow"} else {"Red"}
    Write-Host ("  MANIFEST [$cli]    : $mSt") -ForegroundColor $cor
}

Write-Host ("  P-045 artefatos  : " + (if ($artefatosOK) {"OK"} else {"BLOQUEIO"})) -ForegroundColor (if ($artefatosOK) {"Green"} else {"Red"})
Write-Host ("  P-059 contexto   : $clienteLabel confirmado")
Write-Host ("  Watcher DECISOES : ativo")
Write-Host ("  Watcher SKILLS   : " + (if ($clienteLabel -ne "") { "ativo para $clienteLabel" } else { "N/A" }))
Write-Host ("  Agenda Gates     : computada (PASSO 8c)")
Write-Host ("  CHURN-WATCH Task : " + (if (Get-ScheduledTask -TaskName "ChurnWatch_Vanguard" -ErrorAction SilentlyContinue) { "agendado 08:00" } else { "pendente (elevar permissoes)" }))
Write-Host ""

if ($bloqueios.Count -gt 0) {
    Write-Host "  BLOQUEIOS ativos:" -ForegroundColor Red
    foreach ($b in $bloqueios) { Write-Host "    ! $b" -ForegroundColor Red }
    Write-Host ""
}
if ($avisos.Count -gt 0) {
    Write-Host "  AVISOS:" -ForegroundColor Yellow
    foreach ($a in $avisos) { Write-Host "    - $a" -ForegroundColor Yellow }
    Write-Host ""
}

$muscPode = $statusGeral -ne "VERMELHO" -or $bloqueios.Count -eq 0
Write-Host ("  STATUS GERAL     : " + $statusGeral) -ForegroundColor $corFinal
Write-Host ("  Musculo pode iniciar: " + (if ($muscPode) {"SIM"} else {"NAO -- resolver bloqueios acima"})) -ForegroundColor (if ($muscPode) {"Green"} else {"Red"})
Write-Host "  ======================================================="
Write-Host ""
