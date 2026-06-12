#Requires -Version 5.1
# session_close.ps1 -- Fechamento de sessao Pentalateral IAH
# P-071: sessao encerrada e fato tecnico, nao intencao.
# 9 gates sequenciais -- Gates 1 e 5 sao BLOQUEANTES (exit 1).
# Uso: .\scripts\session_close.ps1 [-cliente NOME] [-Friccao "..."] etc.

param(
    [string]$Projeto   = "",
    [string]$cliente   = "",
    [string]$Friccao   = "",
    [string]$Principio = "",
    [string]$Override  = "",
    [string]$Deriva    = "",
    [string]$Divida    = "",
    [string]$Candidato = "",
    [string]$Padrao    = "",
    [string]$Mandato   = "",
    [switch]$DryRun
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# P-096: -Projeto sobrepoe auto-deteccao WIP_BOARD; -DryRun simula sem side effects
if ($Projeto) { $cliente = $Projeto.ToUpper() }
if ($DryRun)  { Write-Host "  [DRYRUN] Modo simulacao ativo -- sem escrita, email ou Telegram" -ForegroundColor DarkCyan }

# Verifica se gate N esta coberto por dias_completos compostos (ex: "dia3_5_feed" cobre 3,4,5)
function Test-GateCoberto([object[]]$diasCompletos, [int]$gateNum) {
    foreach ($d in $diasCompletos) {
        $stripped = ($d -replace '^dia', '') -split '_'
        $nums = @()
        foreach ($p in $stripped) {
            if ($p -match '^\d+$') { $nums += [int]$p } else { break }
        }
        if ($nums.Count -eq 0) { continue }
        $minN = ($nums | Measure-Object -Minimum).Minimum
        $maxN = ($nums | Measure-Object -Maximum).Maximum
        if ($gateNum -ge $minN -and $gateNum -le $maxN) { return $true }
    }
    return $false
}

# P-096: localizacao universal -- detectar raiz do repo pela presenca de INTELLIGENCE_LEDGER.md
$_dir = $PSScriptRoot
while ($_dir -and -not (Test-Path "$_dir\INTELLIGENCE_LEDGER.md")) {
    $_parent = Split-Path -Parent $_dir
    if ($_parent -eq $_dir) { break }
    $_dir = $_parent
}
$BASE   = $_dir
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
    G1   = "PENDENTE"
    G1_6 = "PENDENTE"
    G2   = "PENDENTE"
    G3  = "PENDENTE"
    G4  = "PENDENTE"
    G5  = "PENDENTE"
    G6  = "PENDENTE"
    G6A = "PENDENTE"
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
# GATE 0.5 -- doc_freshness_checker.ps1 (ATO 1 Loop 33)
# Verifica CONTEUDO dos arquivos canonicos, nao datas.
# BLOQUEANTE: se VERMELHO, session_close para -- nao gera PAINEL/CONTEXTO.
# ==========================================================================
Write-Host "  [GATE 0.5] Freshness de conteudo canonico..." -ForegroundColor Cyan
$freshnessScript = "$BASE\scripts\doc_freshness_checker.ps1"
if (Test-Path $freshnessScript) {
    if ($DryRun) {
        Write-Host "  [DRYRUN] GATE 0.5 -- doc_freshness_checker simulado" -ForegroundColor DarkCyan
    } else {
        & powershell.exe -NonInteractive -File $freshnessScript -Cliente $cliente -Silent 2>$null
        $freshnessExit = $LASTEXITCODE
        if ($freshnessExit -eq 1) {
            Write-Host "  [GATE 0.5] VERMELHO -- divergencia de conteudo detectada." -ForegroundColor Red
            Write-Host "             Rodar: .\scripts\doc_freshness_checker.ps1 -Cliente $cliente" -ForegroundColor Red
            Write-Host "             Corrigir arquivos VERMELHO antes de encerrar sessao." -ForegroundColor Red
            exit 1
        } else {
            Write-Host "  [GATE 0.5] VERDE -- conteudo coerente com Loop $($cliente)." -ForegroundColor Green
        }
    }
} else {
    Write-Host "  [GATE 0.5] doc_freshness_checker.ps1 nao encontrado -- IGNORADO" -ForegroundColor DarkGray
}
Write-Host ""

# ==========================================================================
# GATE 1 -- auditar_consistencia.ps1 (BLOQUEANTE -- exit 1 se VERMELHO)
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
        if ($DryRun) { Write-Host "  [DRYRUN] GATE 1 -- BLOQUEARIA com exit 1" -ForegroundColor DarkCyan }
        else { exit 1 }
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

# GATE 1 -- REFORCO: fix_bom_json.ps1 (ATO 2 Loop 33 -- FALHA-H 3a ocorrencia)
$fixBomScript = "$BASE\scripts\fix_bom_json.ps1"
if (Test-Path $fixBomScript) {
    if ($DryRun) {
        Write-Host "  [DRYRUN] GATE 1 fix_bom -- simulado" -ForegroundColor DarkCyan
    } else {
        & powershell.exe -NonInteractive -File $fixBomScript 2>$null
        if ($LASTEXITCODE -eq 1) {
            Write-Host "  [GATE 1] AVISO: fix_bom_json encontrou JSON invalido apos remocao de BOM -- verificar manualmente." -ForegroundColor Yellow
        }
    }
}

# ==========================================================================
# GATE 1.5 -- RECONCILIACAO DE PENDENTES (inserido 2026-06-07 -- Briefing Embaixador)
# Filosofia: mesma filosofia do sync_guard para documentos, aplicada ao PENDENTES.md.
# Executa ANTES de qualquer escrita na secao "Ficou no Ar".
# VERMELHO (exit 1) se estado contraditorio nao resolvido.
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 1.5] Reconciliacao de pendentes..." -ForegroundColor Cyan
$pendPath15 = "$BASE\PENDENTES.md"
$gate15Status = "VERDE"

if (Test-Path $pendPath15) {
    $pLines = @(Get-Content $pendPath15 -Encoding UTF8)
    $pMod   = $false
    $logDedup = [System.Collections.ArrayList]@()

    # --- Regra 1: ESTADO UNICO -- item nao pode ser [ ] e [x] simultaneamente ---
    # Indice: texto normalizado -> primeira linha aberta encontrada
    $abertosIdx = @{}
    $fechadosTextos = [System.Collections.ArrayList]@()

    for ($i = 0; $i -lt $pLines.Count; $i++) {
        $l = $pLines[$i]
        if ($l -match '^\s*-\s*\[x\]') {
            # Extrair texto normalizando marcadores MD
            $txt = $l -replace '^\s*-\s*\[x\]\s*', '' -replace '~~', '' -replace '`[^`]*`', '' -replace '\*\*', ''
            $txt = $txt.Substring(0, [Math]::Min(50, $txt.Length)).ToLower().Trim()
            [void]$fechadosTextos.Add($txt)
        }
        if ($l -match '^\s*-\s*\[\s*\]') {
            $txt = $l -replace '^\s*-\s*\[\s*\]\s*', '' -replace '`[^`]*`', '' -replace '\*\*', ''
            $txt = $txt.Substring(0, [Math]::Min(50, $txt.Length)).ToLower().Trim()
            # Verificar se este item aberto tem correspondente fechado (palavras em comum >= 3)
            $kwAberto = @($txt -split '\s+' | Where-Object { $_.Length -gt 4 } | Select-Object -Unique)
            foreach ($fechado in $fechadosTextos) {
                $kwFechado = @($fechado -split '\s+' | Where-Object { $_.Length -gt 4 } | Select-Object -Unique)
                $comuns = @($kwAberto | Where-Object { $kwFechado -contains $_ })
                if ($comuns.Count -ge 3) {
                    [void]$logDedup.Add("[ESTADO-UNICO] Linha $($i+1): item aberto tem correspondente [x] -- removendo [ ] (mantendo [x] mais recente)")
                    $pLines[$i] = $null  # marcar para remocao
                    $pMod = $true
                    $gate15Status = "AMARELO"
                    break
                }
            }
        }
    }

    # Remover linhas marcadas como $null
    if ($pMod) {
        $pLines = @($pLines | Where-Object { $_ -ne $null })
    }

    # --- Regra 2: CABECALHO UNICO -- "Ficou no Ar -- DATA" max 1x por data ---
    $dataHoje15 = Get-Date -Format "yyyy-MM-dd"
    $marcaCab   = "## Ficou no Ar -- $dataHoje15"
    $idxsCab    = @()
    for ($i = 0; $i -lt $pLines.Count; $i++) {
        if ($pLines[$i] -match [regex]::Escape($marcaCab)) { $idxsCab += $i }
    }
    if ($idxsCab.Count -gt 1) {
        # Manter o primeiro cabecalho, remover os subsequentes (mas manter seus itens)
        for ($k = 1; $k -lt $idxsCab.Count; $k++) {
            [void]$logDedup.Add("[CAB-UNICO] Cabecalho duplicado na linha $($idxsCab[$k]+1) -- removendo")
            $pLines[$idxsCab[$k]] = $null
            $pMod = $true
            $gate15Status = "AMARELO"
        }
        $pLines = @($pLines | Where-Object { $_ -ne $null })
    }

    # Salvar se houve modificacoes
    if ($pMod -and -not $DryRun) {
        [System.IO.File]::WriteAllLines($pendPath15, $pLines, [System.Text.UTF8Encoding]::new($false))
        Write-Host "  [GATE 1.5] PENDENTES.md corrigido automaticamente:" -ForegroundColor Yellow
        $logDedup | ForEach-Object { Write-Host "    $_" -ForegroundColor Yellow }
    } elseif ($pMod -and $DryRun) {
        Write-Host "  [DRYRUN] GATE 1.5 -- correcoes simuladas:" -ForegroundColor DarkCyan
        $logDedup | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkCyan }
    } else {
        Write-Host "  [GATE 1.5] VERDE -- sem estados contraditorios detectados" -ForegroundColor Green
    }

    # VERMELHO bloqueante: estado contraditorio nao resolvido (nao deve ocorrer apos correcao acima,
    # mas protege contra falha de escrita)
    if ($gate15Status -eq "VERMELHO") {
        Write-Host "  [GATE 1.5] VERMELHO -- estado contraditorio persistente. Resolver manualmente antes de encerrar." -ForegroundColor Red
        if (-not $DryRun) { exit 1 }
    }
} else {
    Write-Host "  [GATE 1.5] PENDENTES.md nao encontrado -- IGNORADO" -ForegroundColor DarkGray
}

# ==========================================================================
# GATE 1.6 -- reconcile_pendentes.ps1 BLOQUEANTE (P-087 gate)
# Bloqueia se houver commit recente com keyword de pendente aberto sem [RESOLVE:]
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 1.6] Reconciliacao P-087 (commits vs PENDENTES)..." -ForegroundColor Cyan
$reconcileScript = "$BASE\scripts\reconcile_pendentes.ps1"
if (Test-Path $reconcileScript) {
    if ($DryRun) {
        Write-Host "  [DRYRUN] GATE 1.6 -- reconcile_pendentes simulado" -ForegroundColor DarkCyan
        $gateStatus.G1_6 = "DRYRUN"
    } else {
        $reconcileOut = & powershell.exe -NonInteractive -File $reconcileScript 2>$null
        $reconcileExit = $LASTEXITCODE
        if ($reconcileExit -eq 2) {
            Write-Host "  [GATE 1.6] VERMELHO -- commits sem [RESOLVE:] detectados:" -ForegroundColor Red
            $reconcileOut -split "`n" | ForEach-Object { Write-Host "    $_" -ForegroundColor Red }
            Write-Host "  Acao: marcar [x] os pendentes resolvidos OU adicionar [RESOLVE:keyword] ao commit e recomitar." -ForegroundColor Yellow
            $gateStatus.G1_6 = "VERMELHO"
            exit 1
        } elseif ($reconcileExit -eq 0) {
            Write-Host "  [GATE 1.6] VERDE -- nenhuma divergencia P-087 detectada" -ForegroundColor Green
            $gateStatus.G1_6 = "VERDE"
        } else {
            Write-Host "  [GATE 1.6] AMARELO -- reconcile_pendentes retornou codigo inesperado ($reconcileExit)" -ForegroundColor Yellow
            $gateStatus.G1_6 = "AMARELO"
        }
    }
} else {
    Write-Host "  [GATE 1.6] reconcile_pendentes.ps1 nao encontrado -- IGNORADO" -ForegroundColor DarkGray
    $gateStatus.G1_6 = "N/A"
}

# ==========================================================================
# GATE 1.7 -- VANGUARD_TIMELINE atualizada com o loop atual (BLOQUEANTE)
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 1.7] Verificando VANGUARD_TIMELINE..." -ForegroundColor Cyan

$timelinePath = "$BASE\PENTALATERAL_UNIVERSAL\HISTORICO\VANGUARD_TIMELINE.md"
$gateStatus.G1_7 = "N/A"
if (Test-Path $timelinePath) {
    # Ler WIP_BOARD para saber o loop atual
    $wipPath = "$BASE\CLIENTES\WIP_BOARD.json"
    $loopAtual = 0
    if (Test-Path $wipPath) {
        try {
            $wipContent = Get-Content $wipPath -Raw -Encoding UTF8
            $wipContent = $wipContent -replace '^\xEF\xBB\xBF', ''  # remove BOM
            $wip = $wipContent | ConvertFrom-Json -ErrorAction SilentlyContinue
            if ($wip.VANGUARD.loop_atual -match 'Loop (\d+)') { $loopAtual = [int]$Matches[1] }
        } catch {}
    }
    $timelineContent = Get-Content $timelinePath -Raw -Encoding UTF8
    $dataHoje = Get-Date -Format "yyyy-MM-dd"
    # Verificar se a data de hoje OU o loop atual aparecem na timeline
    $temDataHoje  = $timelineContent -match [regex]::Escape($dataHoje)
    $temLoopAtual = ($loopAtual -gt 0) -and ($timelineContent -match "Loop $loopAtual")
    if ($temDataHoje -or $temLoopAtual) {
        Write-Host "  [GATE 1.7] VERDE -- TIMELINE atualizada (loop $loopAtual / $dataHoje)" -ForegroundColor Green
        $gateStatus.G1_7 = "VERDE"
    } else {
        Write-Host "  [GATE 1.7] VERMELHO -- TIMELINE desatualizada!" -ForegroundColor Red
        Write-Host "  Nao encontrei loop $loopAtual nem $dataHoje em VANGUARD_TIMELINE.md" -ForegroundColor Red
        Write-Host "  Acao: adicionar entrada do loop atual na TIMELINE antes de fechar." -ForegroundColor Yellow
        Write-Host "  Arquivo: PENTALATERAL_UNIVERSAL\HISTORICO\VANGUARD_TIMELINE.md" -ForegroundColor Yellow
        $gateStatus.G1_7 = "VERMELHO"
        if (-not $DryRun) { exit 1 }
        else { Write-Host "  [DRYRUN] GATE 1.7 -- BLOQUEARIA com exit 1" -ForegroundColor DarkCyan }
    }
} else {
    Write-Host "  [GATE 1.7] TIMELINE nao encontrada -- IGNORADO" -ForegroundColor DarkGray
}

# ==========================================================================
# GATE 2 -- sync_passo_files.ps1 + sync_vanguard_docs.ps1
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 2] Sync documentos..." -ForegroundColor Cyan

$syncPassoScript  = "$BASE\scripts\sync_passo_files.ps1"
$syncUnivScript   = "$BASE\.claude\skills\files\sync_vanguard_docs.ps1"
$g2ok = $true

if ($DryRun) {
    Write-Host "  [DRYRUN] GATE 2 -- sync_passo_files + sync_vanguard simulados" -ForegroundColor DarkCyan
} else {
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
}

$gateStatus.G2 = if ($g2ok) { "VERDE" } else { "AMARELO" }

# ==========================================================================
# GATE 3 -- propagate_changes.ps1 (P-060)
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 3] Propagacao via DEPENDENCY_MAP (P-060)..." -ForegroundColor Cyan
$propagateScript = "$BASE\scripts\propagate_changes.ps1"
if ($DryRun) {
    Write-Host "  [DRYRUN] GATE 3 -- propagate_changes simulado" -ForegroundColor DarkCyan
    $gateStatus.G3 = "DRYRUN"
} elseif (Test-Path $propagateScript) {
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
# GATE 3.5 -- sync_guard.ps1 -Fechamento (BLOQUEANTE se divergencias canonicas)
# P-033: toda mudanca em PENTALATERAL_UNIVERSAL/ exige copias em sync
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 3.5] sync_guard -- integridade de documentos canonicos..." -ForegroundColor Cyan
$syncGuardScript = "$BASE\scripts\sync_guard.ps1"
if (Test-Path $syncGuardScript) {
    if ($DryRun) {
        Write-Host "  [DRYRUN] GATE 3.5 -- sync_guard -Fechamento simulado" -ForegroundColor DarkCyan
        $gateStatus.G35 = "N/A"
    } else {
        try {
            $sgOut = & powershell.exe -NonInteractive -File $syncGuardScript -Fechamento 2>$null
            $sgExit = $LASTEXITCODE
            if ($sgExit -eq 0) {
                Write-Host "  [GATE 3.5] VERDE -- todas as copias em sync com a fonte canonica" -ForegroundColor Green
                $gateStatus.G35 = "VERDE"
            } else {
                $sgOut | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
                Write-Host "  [GATE 3.5] VERMELHO -- session_close BLOQUEADO (P-033)" -ForegroundColor Red
                Write-Host "  Use: .\scripts\sync_guard.ps1 -Abertura -AutoCorrigir para corrigir" -ForegroundColor Yellow
                $gateStatus.G35 = "VERMELHO"
                exit 1
            }
        } catch {
            Write-Host "  [GATE 3.5] sync_guard.ps1 falhou -- ignorado: $_" -ForegroundColor Yellow
            $gateStatus.G35 = "AMARELO"
        }
    }
} else {
    Write-Host "  [GATE 3.5] sync_guard.ps1 nao encontrado -- IGNORADO" -ForegroundColor DarkGray
    $gateStatus.G35 = "N/A"
}

# ==========================================================================
# GATE 4 -- CLAUDE_PROJECT byte-level sync (ledger_sync)
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
        if ($DryRun) {
            Write-Host "  [DRYRUN] GATE 4 -- copia LEDGER+WIP+TIMELINE para $cli simulada" -ForegroundColor DarkCyan
        } else {
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
        }
    } else {
        Write-Host "  [GATE 4] CLAUDE_PROJECT/$cli nao encontrado" -ForegroundColor Yellow
        $g4ok = $false
    }
}
$gateStatus.G4 = if ($g4ok) { "VERDE" } else { "AMARELO" }

# ==========================================================================
# GATE 5 -- validate_scripts.ps1 (BLOQUEANTE -- exit 1 se VERMELHO)
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
                if ($DryRun) { Write-Host "  [DRYRUN] GATE 5 -- BLOQUEARIA com exit 1" -ForegroundColor DarkCyan }
                else { exit 1 }
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
# GATE 6 -- Artefatos: LEDGER + WIP + MANIFEST + P-045 + knowledge_graph
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
        if (-not $DryRun) { Set-Content $LEDGER -Value $cL -Encoding UTF8 }
        $nEv = @($Friccao, $Principio, $Override, $Deriva) | Where-Object { $_ }
        $ledgerTag = if ($DryRun) { " [DRYRUN]" } else { "" }
        Write-Host "  [GATE 6]$ledgerTag LEDGER: $($nEv.Count) evento(s) registrado(s)" -ForegroundColor Green

        # --- GATE LEDGER_SPLIT: dispara ao atingir 80 principios ---
        $ledgerAtual     = Get-Content $LEDGER -Raw -Encoding UTF8
        $totalPrincipios = ([regex]::Matches($ledgerAtual, '### \[P-\d+\]')).Count
        Write-Host "  [GATE 6] LEDGER: $totalPrincipios principio(s) ativos" -ForegroundColor DarkGray
        if ($totalPrincipios -ge 80) {
            Write-Host "  [GATE 6] LEDGER atingiu $totalPrincipios principios -- executando ledger_split.ps1..." -ForegroundColor Cyan
            $splitScript = "$BASE\scripts\ledger_split.ps1"
            if (Test-Path $splitScript) {
                & powershell -NonInteractive -File $splitScript -Force 2>&1 | ForEach-Object { Write-Host "    $_" }
            }
        }
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
# GATE 6C -- vanguard-doc-sync BLOQUEANTE (P-049)
# notebooklm=PENDENTE -> ignora. notebooklm=OK sem AUDITOR preenchido -> exit 1
# Universal: usa $projetosEmBuild (objetos completos do WIP_BOARD.board.build)
# ==========================================================================
$gate6CFalhou = $false
foreach ($projC in $projetosEmBuild) {
    $cliC    = $projC.cliente.ToUpper()
    $cliLowC = $projC.cliente.ToLower()
    $faseC   = $projC.loop_fase_atual
    if (-not $faseC) { continue }

    # notebooklm=PENDENTE -> ignora silenciosamente
    if ($faseC.notebooklm -ne "OK") { continue }

    $loopC = try { [int]$faseC.loop } catch { 0 }
    if ($loopC -eq 0) { continue }

    $audPathC = "$BASE\CLIENTES\$cliC\HISTORICO\AUDITOR_LOOP_V${loopC}_${cliLowC}.md"

    if (-not (Test-Path $audPathC)) {
        # Ausente: bloqueante so se NotebookLM foi rodado HOJE (arquivo deveria ter sido criado hoje)
        $auditorDeHoje = $false  # se nao existe, nao foi criado hoje
        Write-Host "  [!] [GATE 6C] $cliC -- AUDITOR_LOOP_V$loopC ausente -- colar output NotebookLM (P-049)" -ForegroundColor Yellow
    } elseif ((Get-Content $audPathC -Raw -Encoding UTF8 -ErrorAction SilentlyContinue) -match '\[colar aqui\]') {
        # Placeholder: so bloqueia se o arquivo foi modificado HOJE (NotebookLM desta sessao)
        $auditorDeHoje = (Get-Item $audPathC).LastWriteTime.Date -eq [datetime]::Today
        if ($auditorDeHoje) {
            Write-Host "  [BLOQUEIO P-049] $cliC -- AUDITOR_LOOP_V$loopC criado hoje com placeholders." -ForegroundColor Red
            $gate6CFalhou = $true
        } else {
            Write-Host "  [!] [GATE 6C] $cliC -- AUDITOR_LOOP_V$loopC tem placeholders (sessao anterior) -- colar na proxima sessao NotebookLM" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [OK] [GATE 6C] $cliC -- AUDITOR_LOOP_V$loopC preenchido." -ForegroundColor Green
    }
}
if ($gate6CFalhou) {
    Write-Host "  [GATE 6C] FALHOU -- P-049 violado. Colar output NotebookLM antes de fechar sessao." -ForegroundColor Red
    if ($DryRun) { Write-Host "  [DRYRUN] GATE 6C -- BLOQUEARIA com exit 1" -ForegroundColor DarkCyan }
    else { exit 1 }
}
Write-Host "  [GATE 6C] P-049 doc-sync -- OK" -ForegroundColor Green

# ==========================================================================
# GATE 6A -- P-045 BLOQUEANTE: MEMORIA + relatorio do loop atual escritos?
# Se musculo=OK e artefatos ausentes -> exit 1 (exceto fase AGUARDA_EMBAIXADOR)
# Origem: MEMORIA_V31 escrita APOS compactacao de contexto -- P-045 quase violado
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 6A] Artefatos de fechamento de loop (P-045)..." -ForegroundColor Cyan
$gate6AFalhou = $false
foreach ($proj6A in $projetosEmBuild) {
    $cli6A   = $proj6A.cliente.ToUpper()
    $cliL6A  = $proj6A.cliente.ToLower()
    $histDir = "$BASE\CLIENTES\$cli6A\HISTORICO"
    $lsPath  = "$BASE\CLIENTES\$cli6A\CLAUDE_PROJECT\LOOP_STATE.json"

    if (-not (Test-Path $lsPath)) {
        Write-Host "  [GATE 6A] $cli6A -- LOOP_STATE.json ausente -- IGNORADO" -ForegroundColor DarkGray
        continue
    }

    try { $ls = Get-Content $lsPath -Raw -Encoding UTF8 | ConvertFrom-Json }
    catch {
        Write-Host "  [GATE 6A] $cli6A -- LOOP_STATE.json invalido -- IGNORADO" -ForegroundColor Yellow
        continue
    }

    $loopN   = [int]$ls.loop_atual
    $fase    = $ls.fase_atual
    $musculo = $ls.socios.musculo.status

    if ($musculo -ne "OK") {
        Write-Host "  [GATE 6A] $cli6A Loop $loopN -- musculo PENDENTE (fase: $fase) -- IGNORADO" -ForegroundColor DarkGray
        continue
    }

    $memoriaPath   = "$histDir\MEMORIA_V${loopN}_${cliL6A}.md"
    $relatorioPath = "$histDir\relatorio_evolutivo_V${loopN}_${cliL6A}.md"
    $memoriaOk6A   = Test-Path $memoriaPath
    $relatorioOk6A = Test-Path $relatorioPath

    if ($memoriaOk6A -and $relatorioOk6A) {
        Write-Host "  [GATE 6A] $cli6A Loop $loopN -- MEMORIA + relatorio OK" -ForegroundColor Green
        continue
    }

    if ($fase -eq "AGUARDA_EMBAIXADOR") {
        Write-Host "  [!] [GATE 6A] $cli6A Loop $loopN -- fase AGUARDA_EMBAIXADOR -- artefatos podem ser gerados apos o Embaixador:" -ForegroundColor Yellow
        if (-not $memoriaOk6A)   { Write-Host "       AUSENTE: HISTORICO\MEMORIA_V${loopN}_${cliL6A}.md" -ForegroundColor Yellow }
        if (-not $relatorioOk6A) { Write-Host "       AUSENTE: HISTORICO\relatorio_evolutivo_V${loopN}_${cliL6A}.md" -ForegroundColor Yellow }
        continue
    }

    # musculo=OK + artefatos ausentes + nao e AGUARDA_EMBAIXADOR -> BLOQUEANTE
    Write-Host "  [BLOQUEIO P-045] $cli6A Loop $loopN -- musculo=OK mas artefatos ausentes:" -ForegroundColor Red
    if (-not $memoriaOk6A)   { Write-Host "    AUSENTE: HISTORICO\MEMORIA_V${loopN}_${cliL6A}.md" -ForegroundColor Red }
    if (-not $relatorioOk6A) { Write-Host "    AUSENTE: HISTORICO\relatorio_evolutivo_V${loopN}_${cliL6A}.md" -ForegroundColor Red }
    Write-Host "    Gerar os artefatos antes de encerrar a sessao (P-045)." -ForegroundColor Yellow
    $gate6AFalhou = $true
}
if ($gate6AFalhou) {
    $gateStatus.G6A = "VERMELHO"
    Write-Host "  [GATE 6A] FALHOU -- P-045 violado. Criar MEMORIA + relatorio antes de fechar." -ForegroundColor Red
    if ($DryRun) { Write-Host "  [DRYRUN] GATE 6A -- BLOQUEARIA com exit 1" -ForegroundColor DarkCyan }
    else { exit 1 }
} else {
    $gateStatus.G6A = "VERDE"
    Write-Host "  [GATE 6A] P-045 artefatos de loop -- OK" -ForegroundColor Green
}

# ==========================================================================
# GATE 6B -- P-032 BLOQUEANTE: MEMORIA_EMBAIXADOR atualizada apos vereditos?
# Se VEREDITOS executados hoje + MEMORIA nao atualizada hoje -> exit 1
# ==========================================================================
$gate6BFalhou = $false
foreach ($projB in $projetosEmBuild) {
    $cliB        = $projB.cliente.ToUpper()
    $memoriaB    = "$BASE\CLIENTES\$cliB\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
    $vereditos   = Get-ChildItem "$BASE\CLIENTES\$cliB\CLAUDE_PROJECT\DECISOES\VEREDITOS_*.json" `
                       -ErrorAction SilentlyContinue |
                   Where-Object { $_.LastWriteTime.Date -eq [datetime]::Today }
    if ($vereditos.Count -gt 0 -and (Test-Path $memoriaB)) {
        $memoriaHoje = (Get-Item $memoriaB).LastWriteTime.Date -eq [datetime]::Today
        if (-not $memoriaHoje) {
            Write-Host ""
            Write-Host "  [BLOQUEIO P-032] $cliB" -ForegroundColor Red
            Write-Host "  Vereditos executados hoje mas MEMORIA_EMBAIXADOR nao atualizada." -ForegroundColor Red
            Write-Host "  Atualizar antes de fechar a sessao." -ForegroundColor Red
            try {
                $lc = & git -C $BASE log -1 --format="%h %ar -- %s" `
                    -- "CLIENTES\$cliB\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md" 2>$null
                if ($lc) { Write-Host "  Ultimo commit: $lc" -ForegroundColor Yellow }
            } catch {}
            Write-Host ""
            $gate6BFalhou = $true
        } else {
            Write-Host "  [OK] [GATE 6B] $cliB MEMORIA_EMBAIXADOR atualizada hoje (P-032)" -ForegroundColor Green
        }
    }
}
if ($gate6BFalhou) {
    Write-Host "  [GATE 6B] FALHOU -- P-032 violado. Corrigir e rodar session_close novamente." -ForegroundColor Red
    if ($DryRun) { Write-Host "  [DRYRUN] GATE 6B -- BLOQUEARIA com exit 1" -ForegroundColor DarkCyan }
    else { exit 1 }
}
Write-Host "  [GATE 6B] P-032 -- OK" -ForegroundColor Green

# ==========================================================================
# GATE 6.5 -- P-089 FIX: gerar PASSO3 do proximo loop SOMENTE ao fechar loop completo
# Timing correto: todos os 4 socios OK = loop fechado = gerar esqueleto N+1
# ==========================================================================
$p3tmpl = Join-Path $BASE "PENTALATERAL_UNIVERSAL\TEMPLATES\scripts\passo3_template.txt"
if (Test-Path $p3tmpl) {
    foreach ($pBuild in $projetosEmBuild) {
        $pCli = $pBuild.cliente
        if (-not $pCli) { continue }
        $fase = $pBuild.loop_fase_atual
        if (-not $fase) { continue }
        $loopFechado = ($fase.gemini -eq "OK") -and ($fase.notebooklm -eq "OK") -and
                       ($fase.embaixador -eq "OK") -and ($fase.musculo -eq "OK")
        if ($loopFechado) {
            $loopN       = try { [int]$fase.loop } catch { 0 }
            $proximoLoop = $loopN + 1
            $cliUp       = $pCli.ToUpper()
            $cliLow      = $pCli.ToLower()
            $p3out       = Join-Path $BASE "CLIENTES\$cliUp\PASSO3_GEMINI.md"
            # P-059: gate de isolamento
            if (-not (Test-Path (Split-Path $p3out))) { continue }
            $p3c = Get-Content $p3tmpl -Raw -Encoding UTF8
            $diasF = if ($pBuild.dias_completos) { ($pBuild.dias_completos -join " | ") } else { "nao informado" }
            $stAsc = if ($pBuild.status) { ($pBuild.status -replace '[^\x00-\x7F]','?').Substring(0,[Math]::Min(120,$pBuild.status.Length)) } else { "em andamento" }
            $gtNext = "Gemini -- DIRETRIZ V$proximoLoop"
            $p3c = $p3c -replace '\{CLIENTE\}',        $cliUp
            $p3c = $p3c -replace '\{CLIENTE_LOWER\}',  $cliLow
            $p3c = $p3c -replace '\{LOOP_NUM\}',       [string]$proximoLoop
            $p3c = $p3c -replace '\{LOOP_PREV\}',      [string]$loopN
            $p3c = $p3c -replace '\{DATA\}',            (Get-Date -Format "yyyy-MM-dd")
            $p3c = $p3c -replace '\{DIRETRIZ_NUM\}',   [string]$proximoLoop
            $p3c = $p3c -replace '\{DIAS_COMPLETOS\}', $diasF
            $p3c = $p3c -replace '\{ESTADO_ATUAL\}',   $stAsc
            $p3c = $p3c -replace '\{GATE_PROXIMO\}',   $gtNext
            $utf8nob = New-Object System.Text.UTF8Encoding $false
            if (-not $DryRun) { [System.IO.File]::WriteAllText($p3out, $p3c, $utf8nob) }
            $p3tag = if ($DryRun) { "[DRYRUN] " } else { "" }
            Write-Host "  [GATE 6.5] $($p3tag)PASSO3 $cliUp Loop $proximoLoop $(if($DryRun){'seria gerado'}else{'gerado'}) (loop $loopN fechado)" -ForegroundColor Green
        }
    }
}

# ==========================================================================
# GATE 7 -- LOG_EXECUCAO_DIARIA
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
    if (-not $DryRun) {
        $logBytes = [System.Text.Encoding]::UTF8.GetBytes($logConteudo)
        [System.IO.File]::WriteAllBytes($logPath, $logBytes)
        Write-Host "  [GATE 7] LOG gerado: CLIENTES\$cliente\HISTORICO\LOG_EXECUCAO_DIARIA_$DATA.md" -ForegroundColor Green
    } else {
        Write-Host "  [DRYRUN] GATE 7 -- LOG seria escrito em CLIENTES\$cliente\HISTORICO\LOG_EXECUCAO_DIARIA_$DATA.md" -ForegroundColor DarkCyan
    }
    $gateStatus.G7 = "VERDE"
} else {
    Write-Host "  [GATE 7] Cliente nao identificado -- LOG nao gerado" -ForegroundColor Yellow
    $gateStatus.G7 = "AMARELO"
}

# ENTREGAVEL 13 -- captura de falhas da sessao (Gate 7 -- P-LEDGER)
# Arquivos modificados com padroes de falha -> PENDENTES para extracao de principio
$novasFalhasG7 = @($arquivosMod | Where-Object { $_ -match "RELATO_FALHAS|[Ff][Aa][Ll][Hh][Aa]" })
if ($novasFalhasG7.Count -gt 0 -or $env:FALHA_SESSAO) {
    $dtG7 = Get-Date -Format "dd-MM-yyyy"
    $dsG7 = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
    Write-Host "  [GATE 7] Falha detectada nesta sessao -- registrar principio no LEDGER." -ForegroundColor Yellow
    Write-Host "           Musculo: extrair principio candidato antes de fechar." -ForegroundColor Yellow
    $pendFalhaEntry = "- [LEDGER ($dtG7 $dsG7)] Extrair principio da falha detectada nesta sessao"
    $exFalha = if (Test-Path $pendentesPath) { Get-Content $pendentesPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue } else { "" }
    if ($null -eq $exFalha) { $exFalha = "" }
    if (-not ($exFalha -match ("LEDGER.*Extrair.*falha.*" + [regex]::Escape($dtG7)))) {
        Add-Content $pendentesPath "`n$pendFalhaEntry" -Encoding UTF8
        Write-Host "  [PENDENTES] Registro LEDGER-falha adicionado automaticamente." -ForegroundColor Green
    }
}

# ADD-F2 -- KNOWLEDGE_BASE (P-050) -- gate SEMPRE ativo, nao apenas por idade
# O gate antigo (>7 dias) gerava falso verde quando INDEX foi atualizado mas problemas nao documentados
# Novo gate: SEMPRE exibe runbooks disponiveis + exige confirmacao explicita do Musculo
$kbPath     = "$BASE\PENTALATERAL_UNIVERSAL\KNOWLEDGE_BASE\INDEX.md"
$runbookDir = "$BASE\PENTALATERAL_UNIVERSAL\OPERACAO"
Write-Host ""
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host "  [GATE 7] KNOWLEDGE_BASE -- P-050 (sempre ativo)" -ForegroundColor Cyan
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host "  Regra: todo problema tecnico resolvido nesta sessao" -ForegroundColor White
Write-Host "  deve estar em um RUNBOOK antes de fechar." -ForegroundColor White
Write-Host ""

# Listar runbooks existentes como ancora para o Musculo
$runbooks = @(Get-ChildItem $runbookDir -Filter "RUNBOOK_*.md" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name)
if ($runbooks.Count -gt 0) {
    Write-Host "  Runbooks disponiveis:" -ForegroundColor DarkGray
    $runbooks | ForEach-Object { Write-Host "    - $_" -ForegroundColor DarkGray }
} else {
    Write-Host "  Nenhum runbook encontrado em PENTALATERAL_UNIVERSAL\OPERACAO\" -ForegroundColor Yellow
}
Write-Host ""

# Detectar problemas resolvidos hoje via git log (commits com fix/erro/workaround/solucao)
$gitLogHoje = git log --since="00:00" --oneline 2>$null | Select-String -Pattern "fix|erro|workaround|solucao|corrigi|ajust|bug" -CaseSensitive:$false
if ($gitLogHoje) {
    Write-Host "  Commits de hoje com indicios de problemas resolvidos:" -ForegroundColor Yellow
    $gitLogHoje | Select-Object -First 5 | ForEach-Object { Write-Host "    $_" -ForegroundColor Yellow }
    Write-Host ""
}

Write-Host "  [MUSCULO] Resposta obrigatoria antes de fechar:" -ForegroundColor White
Write-Host "    KB-OK    -- todos os problemas desta sessao estao documentados" -ForegroundColor Green
Write-Host "    KB-FALTA -- [descrever o que nao foi documentado ainda]" -ForegroundColor Red
Write-Host ""
Write-Host "  Se KB-FALTA: abrir o RUNBOOK correspondente agora." -ForegroundColor Yellow
Write-Host "  Nao existe 'documentar depois' -- depois nao existe." -ForegroundColor Yellow
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host ""
$candidatosPath = "$BASE\PENTALATERAL_UNIVERSAL\KNOWLEDGE_BASE\CANDIDATOS_A_PRINCIPIO.md"
if (Test-Path $candidatosPath) {
    $candContent  = Get-Content $candidatosPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    $candPend     = if ($candContent) { ([regex]::Matches($candContent, '\[ \]')).Count } else { 0 }
    if ($candPend -gt 0) {
        Write-Host "  [GATE 7] $candPend candidato(s) a principio aguardando validacao -- promover ao LEDGER" -ForegroundColor Yellow
    }
}

# ==========================================================================
# GATE 7B -- n8n_audit.ps1 (Camada B -- linter de julgamento hardcoded)
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 7B] n8n audit (linter de workflow)..." -ForegroundColor Cyan
$n8nAuditScript = "$BASE\scripts\n8n_audit.ps1"
$n8nWorkflowDir = "$BASE\_n8n\workflows"
if (Test-Path $n8nWorkflowDir) {
    $n8nJsons = @(Get-ChildItem -Path $n8nWorkflowDir -Filter "*.json" -ErrorAction SilentlyContinue)
    if ($n8nJsons.Count -gt 0) {
        if ($DryRun) {
            Write-Host "  [DRYRUN] GATE 7B -- n8n_audit simulado ($($n8nJsons.Count) workflow(s))" -ForegroundColor DarkCyan
        } elseif (Test-Path $n8nAuditScript) {
            & powershell.exe -NonInteractive -File $n8nAuditScript -WorkflowDir $n8nWorkflowDir 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  [GATE 7B] VERMELHO -- n8n_audit detectou violacoes de hardcode." -ForegroundColor Red
                Write-Host "            Remover logica hardcoded ou adicionar '// LEDGER: [razao]'." -ForegroundColor Red
                Write-Host "            Ver: _n8n\N8N_AUDIT_REPORT.md" -ForegroundColor Red
                if ($DryRun) { Write-Host "  [DRYRUN] GATE 7B -- BLOQUEARIA com exit 1" -ForegroundColor DarkCyan }
                else { exit 1 }
            } else {
                Write-Host "  [GATE 7B] n8n_audit CLEAN -- $($n8nJsons.Count) workflow(s) auditado(s)" -ForegroundColor Green
            }
        } else {
            Write-Host "  [GATE 7B] n8n_audit.ps1 nao encontrado -- instalar em scripts/" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [GATE 7B] Nenhum workflow .json em _n8n/workflows/ -- gate ignorado" -ForegroundColor DarkGray
    }
} else {
    Write-Host "  [GATE 7B] _n8n/workflows/ nao existe -- gate ignorado (Camada B nao instalada)" -ForegroundColor DarkGray
}

# ==========================================================================
# GATE 7C -- Freshness dos 7 arquivos criticos (S1 DEF-M-6 -- 2026-06-12)
# Alerta AMARELO nao-bloqueante -- Diretor decide se bypassa
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 7C] Verificando freshness dos 7 arquivos criticos..." -ForegroundColor Cyan

$_g7cArqs = @(
    "PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_$DATA.md",
    "PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$DATA.md",
    "CLIENTES\WIP_BOARD.json",
    "INTELLIGENCE_LEDGER.md",
    "PENDENTES.md",
    "CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md",
    "CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md"
)
$_g7cNomes = @("PAINEL_ATIVIDADES","CONTEXTO_SESSAO_DIRETOR","WIP_BOARD","INTELLIGENCE_LEDGER","PENDENTES","16_VANGUARD_TIMELINE","MEMORIA_EMBAIXADOR")
$_g7cFalhas = @()
$_g7cAgora = Get-Date
$_g7cThreshold = 8  # horas -- arquivo mais antigo que isso e considerado stale

for ($i = 0; $i -lt $_g7cArqs.Count; $i++) {
    $p = Join-Path $BASE $_g7cArqs[$i]
    if (-not (Test-Path $p)) {
        $_g7cFalhas += ("  [AUSENTE] " + $_g7cNomes[$i])
    } else {
        $lw = (Get-Item $p).LastWriteTime
        $deltaH = [math]::Round(($_g7cAgora - $lw).TotalHours, 1)
        if ($deltaH -gt $_g7cThreshold) {
            $_g7cFalhas += ("  [STALE " + $deltaH + "h] " + $_g7cNomes[$i] + " -- ultima mod: " + $lw.ToString("yyyy-MM-dd HH:mm"))
        }
    }
}

if ($_g7cFalhas.Count -gt 0) {
    Write-Host "  [GATE 7C] ALERTA AMARELO -- arquivos nao atualizados hoje:" -ForegroundColor Yellow
    foreach ($f in $_g7cFalhas) { Write-Host $f -ForegroundColor Yellow }
    Write-Host "  [GATE 7C] gerar_msg_embaixador.ps1 bloqueara se estes arquivos estiverem stale." -ForegroundColor Yellow
    Write-Host "  [GATE 7C] Recomendacao: atualizar antes de entregar ao Embaixador." -ForegroundColor Yellow
} else {
    Write-Host "  [GATE 7C] VERDE -- todos os 7 arquivos criticos atualizados hoje." -ForegroundColor Green
}

# ==========================================================================
# GATE 8 -- Notificacao: e-mail + Telegram + Auto-preparacao dos 3 socios
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
if ($DryRun) {
    Write-Host "  [DRYRUN] GATE 8 -- Gemini anchor simulado" -ForegroundColor DarkCyan
} elseif (Test-Path $anchorScript) {
    try {
        & powershell.exe -NonInteractive -File $anchorScript 2>$null | Out-Null
        Write-Host "  [GATE 8] Gemini -- CONTEXTO_GEMINI.md -- OK" -ForegroundColor Green
    } catch {
        Write-Host "  [GATE 8] Gemini -- falha" -ForegroundColor Yellow
    }
}

# --- Socio 2: NotebookLM ---
$prepScript = "$BASE\scripts\preparar_notebooklm_projeto.ps1"
if ($DryRun) {
    Write-Host "  [DRYRUN] GATE 8 -- NotebookLM prep simulado" -ForegroundColor DarkCyan
} elseif (Test-Path $prepScript) {
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
if ($DryRun) {
    Write-Host "  [DRYRUN] GATE 8 -- Embaixador AutoSync simulado" -ForegroundColor DarkCyan
} elseif (Test-Path $embScript) {
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
        ($pendentesAbertos | ForEach-Object { "- $_" }) -join "`n"
    } else { "Nenhum pendente em aberto." }

    $emailBody = @"
Diretor,

Sessao de $DATA encerrada as $HORA_EXIB.

============================
PAINEL DE ATIVIDADES
============================
Arquivo: PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_$DATA.md
Acao: arrastar ao Claude Projects (Embaixador -- Diretor)

============================
RESUMO DA SESSAO
============================
Cliente ativo:   $cliente$(if ($loopAtualLabel) { " -- $loopAtualLabel" })
Status geral:    $statusFinal
Arquivos mod.:   $($arquivosMod.Count) arquivo(s)

MODIFICADOS:
$listaMod

============================
ALERTAS ATIVOS
============================
$alertaBloco

============================
PENDENTES ABERTOS
============================
$pendBloco

============================
LOG completo: CLIENTES\$cliente\HISTORICO\LOG_EXECUCAO_DIARIA_$DATA.md
============================

Musculo . Pentalateral IAH . $DATA $HORA_EXIB
"@

    if ($DryRun) {
        Write-Host "  [DRYRUN] GATE 8 -- e-mail simulado (nao enviado)" -ForegroundColor DarkCyan
        $gateStatus.G8e = "DRYRUN"
    } else {
        $emailBody | Out-File -FilePath $emailBodyPath -Encoding utf8 -Force
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
    if ($DryRun) {
        Write-Host "  [DRYRUN] GATE 8 -- Telegram simulado (nao enviado)" -ForegroundColor DarkCyan
        $gateStatus.G8t = "DRYRUN"
    } else {
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
}

# ADD-F3 -- COMANDO_ESTRATEGISTA_MASTER sincronia com WIP_BOARD (P-052 / Gate 8)
$masterPathF3 = "$BASE\PENTALATERAL_UNIVERSAL\OPERACAO\COMANDO_ESTRATEGISTA_MASTER_v1.md"
if ((Test-Path $masterPathF3) -and (Test-Path $wipPath)) {
    $wMF3 = (Get-Item $wipPath).LastWriteTime
    $mMF3 = (Get-Item $masterPathF3).LastWriteTime
    if ($wMF3 -gt $mMF3) {
        $dhF3 = [int]($wMF3 - $mMF3).TotalHours
        Write-Host "  [GATE 8] COMANDO_ESTRATEGISTA_MASTER desatualizado ${dhF3}h vs WIP_BOARD (P-052)" -ForegroundColor Yellow
        Write-Host "           Atualizar antes do proximo Gemini: PENTALATERAL_UNIVERSAL\OPERACAO\COMANDO_ESTRATEGISTA_MASTER_v1.md" -ForegroundColor Yellow
    } else {
        Write-Host "  [GATE 8] COMANDO_ESTRATEGISTA_MASTER -- OK (em sincronia com WIP_BOARD)" -ForegroundColor Green
    }
}

# ==========================================================================
# GATE 9 -- PAINEL_ATIVIDADES para o Embaixador
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
                    if ($p0.dias_completos) { $conc = Test-GateCoberto -diasCompletos $p0.dias_completos -gateNum $num }
                    if (-not $conc) { $gargaloCnt++ }
                }
            }
        }
    }
    $analise  = "Projeto $cliente encerrou sessao com $totalPend pendente(s) aberto(s) e $gargaloCnt gargalo(s) de gate. "
    $analise += "Status documental: $statusFinal. $deadlineInfo "
    $analise += "Musculo: verificar se gargalos bloqueiam o proximo loop antes de ir ao Gemini."

    # ATO 4 Loop 33: Build Budget Guard -- FALHA-PADRAO se builds acumulam sem inicio (P-148)
    $bbGuardScript = "$BASE\scripts\build_budget_guard.ps1"
    if (Test-Path $bbGuardScript) {
        $null = & powershell.exe -NonInteractive -File $bbGuardScript -Cliente $cliente -Silent 2>$null
        if ($LASTEXITCODE -eq 2) {
            $lsPathBB = "$BASE\CLIENTES\$cliente\CLAUDE_PROJECT\LOOP_STATE.json"
            $buildsCountBB = 0
            if (Test-Path $lsPathBB) {
                try {
                    $lsBB = Get-Content $lsPathBB -Raw -Encoding UTF8 | ConvertFrom-Json
                    $buildsCountBB = @($lsBB.builds_aprovados_nao_iniciados).Count
                } catch {}
            }
            $analise += " [FALHA-PADRAO P-148] $buildsCountBB build(s) aprovados sem inicio nesta sessao. Proxima sessao: iniciar M-2 antes de qualquer deliberacao."
            Write-Host "  [BUILD-GUARD] FALHA-PADRAO registrada no PAINEL -- $buildsCountBB builds acumulados." -ForegroundColor Red
        }
    }

    $entregasTexto = "Sessao $DATA -- $($arquivosMod.Count) arquivo(s) modificado(s). "
    $entregasTexto += "MANIFEST: $(($manifestStatus.Values | Select-Object -Unique) -join ', '). "
    if ($logPath) { $entregasTexto += "LOG: $logPath." }

    # Gerar PAINEL + Artefato Embaixador separado por projeto ativo
    $paineisPorCliente   = [ordered]@{}
    $artefatosPorCliente = [ordered]@{}
    $artefatoScript      = "$BASE\scripts\gerar_artefato_embaixador.ps1"

    $clientesAtivos = @($projetosEmBuild | ForEach-Object { $_.cliente } | Where-Object { $_ })
    if ($clientesAtivos.Count -eq 0) { $clientesAtivos = @($cliente) }

    foreach ($cli in $clientesAtivos) {
        $cliUpper = $cli.ToUpper()
        $p0 = $projetosEmBuild | Where-Object { $_.cliente.ToUpper() -eq $cliUpper } | Select-Object -First 1
        $dlInfo = ""
        $gCnt   = 0
        if ($p0 -and $p0.deadline) {
            $dlDate  = [datetime]::Parse($p0.deadline)
            $diasR   = ($dlDate - (Get-Date).Date).Days
            $dlInfo  = "Deadline $($p0.deadline) -- $diasR dia(s) restante(s)."
        }
        if ($p0 -and $p0.gates_bloqueantes) {
            $inicio = [datetime]::Parse($p0.build_iniciado_em)
            $p0.gates_bloqueantes | Get-Member -MemberType NoteProperty | ForEach-Object {
                $num = [int]($_.Name -replace '\D','')
                $gDate = $inicio.AddDays($num-1)
                if ($gDate.Date -le (Get-Date).Date) {
                    $conc = $false
                    if ($p0.dias_completos) { $conc = Test-GateCoberto -diasCompletos $p0.dias_completos -gateNum $num }
                    if (-not $conc) { $gCnt++ }
                }
            }
        }
        $analise  = "Projeto $cliUpper encerrou sessao com $totalPend pendente(s) e $gCnt gargalo(s). "
        $analise += "Status documental: $statusFinal. $dlInfo "
        $analise += "Musculo: verificar se gargalos bloqueiam o proximo loop antes de ir ao Gemini."

        if ($DryRun) {
            Write-Host "  [DRYRUN] GATE 9 -- PAINEL $cliUpper seria gerado" -ForegroundColor DarkCyan
        } else {
            $painelFile = (& powershell.exe -NonInteractive -File $painelScript `
                -Cliente       $cli `
                -EntregasTexto $entregasTexto `
                -AlertasTexto  $alertaBloco `
                -AnaliseTexto  $analise `
                2>$null) | Select-Object -Last 1

            if ($painelFile -and (Test-Path $painelFile)) {
                $paineisPorCliente[$cliUpper] = $painelFile
                Write-Host "  [GATE 9] PAINEL $cliUpper gerado: $(Split-Path $painelFile -Leaf)" -ForegroundColor Cyan

                # Gerar Artefato Embaixador via API automaticamente
                if (Test-Path $artefatoScript) {
                    Write-Host "  [GATE 9] Chamando Embaixador $cliUpper via API..." -ForegroundColor Cyan
                    $artefatoFile = (& powershell.exe -NonInteractive -File $artefatoScript `
                        -Cliente $cli 2>$null) | Select-Object -Last 1
                    if ($artefatoFile -and (Test-Path $artefatoFile)) {
                        $artefatosPorCliente[$cliUpper] = $artefatoFile
                        Write-Host "  [GATE 9] Artefato $cliUpper OK: $(Split-Path $artefatoFile -Leaf)" -ForegroundColor Green
                    } else {
                        Write-Host "  [GATE 9] Artefato $cliUpper -- API indisponivel ou erro" -ForegroundColor Yellow
                    }
                }
            } else {
                Write-Host "  [GATE 9] PAINEL $cliUpper -- falha na geracao" -ForegroundColor Yellow
            }
        }
    }
    if ($DryRun) { $gateStatus.G9 = "DRYRUN" }
    elseif ($paineisPorCliente.Count -gt 0) { $gateStatus.G9 = "VERDE" } else { $gateStatus.G9 = "AMARELO" }
} else {
    Write-Host "  [GATE 9] generate_protocolo_encerramento.ps1 nao encontrado" -ForegroundColor DarkGray
    $gateStatus.G9 = "N/A"
}

# ADD-F4 -- Regenerar MANIFESTO_DE_FONTES para cada projeto ativo (P-053)
foreach ($projF4 in $projetosEmBuild) {
    $cliF4    = $projF4.cliente.ToUpper()
    $fontesF4 = "$BASE\CLIENTES\$cliF4\NOTEBOOKLM_FONTES"
    if (Test-Path $fontesF4) {
        $manifestoF4 = "$fontesF4\00_MANIFESTO_DE_FONTES.md"
        $arquivosF4  = Get-ChildItem $fontesF4 -File | Sort-Object Name
        $linhasF4    = [System.Collections.ArrayList]@()
        [void]$linhasF4.Add("# MANIFESTO DE FONTES -- $cliF4")
        [void]$linhasF4.Add("# Gerado por session_close.ps1 Gate 9 (P-053)")
        [void]$linhasF4.Add("# Total: $($arquivosF4.Count) arquivos")
        [void]$linhasF4.Add("")
        foreach ($arqF4 in $arquivosF4) {
            $szF4 = [math]::Round($arqF4.Length / 1KB, 1)
            $dtF4 = $arqF4.LastWriteTime.ToString("yyyy-MM-dd")
            [void]$linhasF4.Add("- $($arqF4.Name) ($szF4 KB, $dtF4)")
        }
        $utf8nbF4 = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllLines($manifestoF4, $linhasF4.ToArray(), $utf8nbF4)
        Write-Host "  [GATE 9] MANIFESTO_DE_FONTES -- $cliF4 -- $($arquivosF4.Count) arqs regenerado" -ForegroundColor Green
    }
}

# ==========================================================================
# CHECK-UP SISTEMICO -- contador de loops (ENTREGAVEL 2 -- OSV-007)
# ==========================================================================
try {
    $boardCheckup = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if (-not $boardCheckup.meta) {
        $boardCheckup | Add-Member -NotePropertyName "meta" -NotePropertyValue ([PSCustomObject]@{
            loops_desde_ultimo_checkup = 0
            data_ultimo_checkup        = $DATA
            checkup_recomendado        = $false
        }) -Force
    }
    $meta = $boardCheckup.meta

    # Detectar loop fechado hoje via DELIBERACAO_LOOP_*.md criado hoje
    $deliberacaoHoje = Get-ChildItem "$BASE\CLIENTES\*\HISTORICO\DELIBERACAO_LOOP_*.md" -ErrorAction SilentlyContinue |
        Where-Object {
            $_.LastWriteTime.Date -eq (Get-Date).Date -and
            -not ((Get-Content $_.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue) -match "retroativo|retroactivo")
        }
    if ($deliberacaoHoje -and $deliberacaoHoje.Count -gt 0) {
        $novoValor = [int]$meta.loops_desde_ultimo_checkup + $deliberacaoHoje.Count
        $meta.loops_desde_ultimo_checkup = $novoValor
        Write-Host "  [CHECK-UP] $($deliberacaoHoje.Count) loop(s) fechado(s) -- contador: $novoValor/3" -ForegroundColor DarkGray
    }

    # Gatilho a cada 3 loops
    if ([int]$meta.loops_desde_ultimo_checkup -ge 3) {
        $meta.checkup_recomendado = $true
        Write-Host ""
        Write-Host "  ============================================================" -ForegroundColor Yellow
        Write-Host "  CHECK-UP SISTEMICO RECOMENDADO" -ForegroundColor Yellow
        Write-Host "  ============================================================" -ForegroundColor Yellow
        Write-Host "  $([int]$meta.loops_desde_ultimo_checkup) loops desde o ultimo check-up ($($meta.data_ultimo_checkup))" -ForegroundColor Yellow
        Write-Host "  Na proxima sessao -- ANTES de qualquer build:" -ForegroundColor White
        Write-Host "  PENTALATERAL_UNIVERSAL/OPERACAO/COMANDO_VERIFICACAO_SISTEMICA_FINAL.md" -ForegroundColor Cyan
        Write-Host "  Responder ao Embaixador. Depois rodar: .\scripts\reset_checkup.ps1" -ForegroundColor White
        Write-Host "  ============================================================" -ForegroundColor Yellow
        Write-Host ""
        # Registrar em PENDENTES.md
        $dataProx = (Get-Date).AddDays(1).ToString("yyyy-MM-dd")
        $pendEntry = "- [ ] ``$dataProx`` **CHECK-UP SISTEMICO (3 loops) -- verificar 12 cenarios antes de qualquer build**"
        $pendEntry += "`n  Rodar PENTALATERAL_UNIVERSAL/OPERACAO/COMANDO_VERIFICACAO_SISTEMICA_FINAL.md + responder ao Embaixador + rodar .\scripts\reset_checkup.ps1"
        Add-Content "$BASE\PENDENTES.md" "`n$pendEntry" -Encoding UTF8
    } else {
        Write-Host "  [CHECK-UP] $([int]$meta.loops_desde_ultimo_checkup)/3 loops -- proximo em $(3 - [int]$meta.loops_desde_ultimo_checkup) loop(s)" -ForegroundColor DarkGray
    }

    $boardCheckup.atualizado_em = $DATA
    # P-CHECKIN: gravar data desta sessao para Get-CheckInPrompt usar na proxima
    $dataHoje = (Get-Date -Format "yyyy-MM-dd")
    if ($boardCheckup.meta.PSObject.Properties["data_ultima_sessao"]) {
        $boardCheckup.meta.data_ultima_sessao = $dataHoje
    } else {
        $boardCheckup.meta | Add-Member -NotePropertyName "data_ultima_sessao" -NotePropertyValue $dataHoje -Force
    }
    if (-not $DryRun) {
        [System.IO.File]::WriteAllText($wipPath, ($boardCheckup | ConvertTo-Json -Depth 20), [System.Text.Encoding]::UTF8)
    } else {
        Write-Host "  [DRYRUN] CHECK-UP -- WIP_BOARD.meta.data_ultima_sessao=$dataHoje simulado" -ForegroundColor DarkCyan
    }
} catch {
    Write-Host "  [CHECK-UP] Falha ao atualizar contador: $_" -ForegroundColor DarkGray
}

# ==========================================================================
# DETECTOR DE BUILD SIGNIFICATIVO (ENTREGAVEL 1 -- 2026-05-29)
# Commits desta sessao com arquivos de codigo fora de scripts/ = build real
# ==========================================================================
$dataInicioSessao = (Get-Date -Format "yyyy-MM-dd") + " 00:00"
try {
    $commitsSessao = @(& git -C $BASE log "--since=$dataInicioSessao" `
        --name-only --pretty=format: 2>$null |
        Where-Object { $_ -match '\.(js|ts|html|css|jsx|tsx|py|sql)$' } |
        Where-Object { $_ -notmatch '^scripts/' })
} catch { $commitsSessao = @() }

if ($commitsSessao.Count -gt 0) {
    Write-Host ""
    Write-Host "  ======================================================" -ForegroundColor Cyan
    Write-Host "  BUILD SIGNIFICATIVO DETECTADO NESTA SESSAO" -ForegroundColor Cyan
    Write-Host "  $($commitsSessao.Count) arquivo(s) de codigo modificado(s)." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  ACAO OBRIGATORIA antes de fechar:" -ForegroundColor Yellow
    Write-Host "  -> TESTE_PROCESSO_COMPLETO.md -- Bloco A (5 min)" -ForegroundColor White
    Write-Host "     PENTALATERAL_UNIVERSAL\OPERACAO\TESTE_PROCESSO_COMPLETO.md" -ForegroundColor White
    Write-Host ""
    Write-Host "  Arquivos detectados:" -ForegroundColor DarkGray
    $commitsSessao | Select-Object -First 5 | ForEach-Object { Write-Host "    . $_" -ForegroundColor DarkGray }
    if ($commitsSessao.Count -gt 5) { Write-Host "    ... e mais $($commitsSessao.Count - 5) arquivo(s)" -ForegroundColor DarkGray }
    Write-Host "  ======================================================" -ForegroundColor Cyan
    # Registrar em PENDENTES.md automaticamente (dedup por data)
    $dtBuild = Get-Date -Format "dd-MM-yyyy"
    $dsBuild = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
    $pendBuildPath = "$BASE\PENDENTES.md"
    $exBuild = if (Test-Path $pendBuildPath) { Get-Content $pendBuildPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue } else { "" }
    if (-not ($exBuild -match ("TESTE_PROCESSO.*" + $dtBuild))) {
        Add-Content $pendBuildPath "`n- [BUILD ($dtBuild $dsBuild)] Rodar TESTE_PROCESSO_COMPLETO.md Bloco A -- build significativo detectado" -Encoding UTF8
        Write-Host "  [PENDENTES] Registro BUILD adicionado automaticamente." -ForegroundColor Green
    }
}

# ==========================================================================
# GATE 9.5 -- ALERTAS DE GARGALO + COUNTDOWN DE GATES (P-032/2026-05-29)
# Funciona para QUALQUER projeto -- usa $projetosEmBuild dinamico
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 9.5] Alertas de Gargalo + Countdown..." -ForegroundColor Cyan
$alertasGargalo = @()

# 1. ChurnWatch_Vanguard no Task Scheduler (global)
try {
    $cwTask = Get-ScheduledTask -TaskName "ChurnWatch_Vanguard" -ErrorAction Stop
    if ($cwTask.State -notin @("Ready","Running")) {
        $alertasGargalo += "CHURN-WATCH INATIVO (state: $($cwTask.State)) -- clientes sem monitoramento autonomo"
    }
} catch {
    $alertasGargalo += "CHURN-WATCH INATIVO -- task nao registrada no Task Scheduler"
}

# 2, 3, 5: por projeto ativo
foreach ($projG in $projetosEmBuild) {
    $cliUpG  = $projG.cliente.ToUpper()
    $cliLowG = $projG.cliente.ToLower()

    # 2. PASSO3_GEMINI.md com placeholder
    $passo3G = "$BASE\CLIENTES\$cliUpG\PASSO3_GEMINI.md"
    if (Test-Path $passo3G) {
        $p3G = Get-Content $passo3G -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        if ($p3G -match '\[M.SCULO:') {
            $alertasGargalo += "[$cliUpG] PASSO3 com placeholder -- Gemini recebera instrucao vazia (P-090)"
        }
    }

    # 3. Artefatos do loop atual (P-045)
    $loopNG = 0
    if ($projG.loop_fase_atual -and $projG.loop_fase_atual.loop) {
        try { $loopNG = [int]$projG.loop_fase_atual.loop } catch {}
    }
    if ($loopNG -gt 0) {
        if (-not (Test-Path "$BASE\CLIENTES\$cliUpG\HISTORICO\MEMORIA_V${loopNG}_${cliLowG}.md")) {
            $alertasGargalo += "[$cliUpG] MEMORIA_V${loopNG} ausente -- NotebookLM misturara versoes (P-045)"
        }
        if (-not (Test-Path "$BASE\CLIENTES\$cliUpG\HISTORICO\relatorio_evolutivo_V${loopNG}_${cliLowG}.md")) {
            $alertasGargalo += "[$cliUpG] relatorio_evolutivo_V${loopNG} ausente (P-045)"
        }
    }

    # 5. SOBERANA_EMBAIXADOR.flag ativo
    $sobG = "$BASE\CLIENTES\$cliUpG\CLAUDE_PROJECT\SOBERANA_EMBAIXADOR.flag"
    if (Test-Path $sobG) {
        $sobAgeG = (Get-Date) - (Get-Item $sobG).LastWriteTime
        if ($sobAgeG.TotalDays -lt 7) {
            $alertasGargalo += "[$cliUpG] SOBERANA_EMBAIXADOR ativo -- confirmar se Embaixador reagiu"
        }
    }

    # M2 (ENTREGAVEL 2) -- gates_programados ausente ou vazio
    if (-not $projG.gates_programados -or @($projG.gates_programados).Count -eq 0) {
        $alertasGargalo += "[$cliUpG] gates_programados ausente -- countdown inativo. Preencher no WIP_BOARD ou rodar onboarding_projeto.ps1."
    }

    # M3 (ENTREGAVEL 3) -- churn_watch_threshold ausente
    if (-not $projG.churn_watch_threshold) {
        $alertasGargalo += "[$cliUpG] churn_watch_threshold ausente -- usando fallback silencioso. Definir via .\scripts\onboarding_projeto.ps1 -cliente $cliUpG."
    }

    # M4/M10 (ENTREGAVEIS 4+10) -- AUDITOR_LOOP ausente ou com placeholder
    if ($loopNG -gt 0) {
        $auditorPathG = "$BASE\CLIENTES\$cliUpG\HISTORICO\AUDITOR_LOOP_V${loopNG}_${cliLowG}.md"
        if (-not (Test-Path $auditorPathG)) {
            $alertasGargalo += "[$cliUpG] AUDITOR_LOOP_V${loopNG} ausente -- output do NotebookLM nao salvo (P-049)"
        } else {
            $audConteudoG = Get-Content $auditorPathG -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
            if ($audConteudoG -match '\[colar aqui\]') {
                $alertasGargalo += "[$cliUpG] AUDITOR_LOOP_V${loopNG} com placeholders -- colar output do NotebookLM antes de fechar"
            }
        }
    }

    # M6 (ENTREGAVEL 6) -- MEMORIA_EMBAIXADOR sem atualizacao > 7 dias
    $memoriaEmbPathG = "$BASE\CLIENTES\$cliUpG\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
    if (Test-Path $memoriaEmbPathG) {
        $memoriaEmbAgeG = ([datetime]::Today - (Get-Item $memoriaEmbPathG).LastWriteTime.Date).Days
        if ($memoriaEmbAgeG -gt 7) {
            $alertasGargalo += "[$cliUpG] MEMORIA_EMBAIXADOR sem atualizacao ha ${memoriaEmbAgeG} dias -- verificar P-032"
        }
    }
}

# 4. decisoes_watcher.log (global)
$dwLogG = "$BASE\scripts\decisoes_watcher.log"
if (-not (Test-Path $dwLogG) -or (Get-Item $dwLogG -ErrorAction SilentlyContinue).Length -eq 0) {
    $alertasGargalo += "decisoes_watcher.log vazio ou ausente -- watcher pode estar parado"
}

if ($alertasGargalo.Count -eq 0) {
    Write-Host "  [GATE 9.5] Nenhum alerta de gargalo. Sistema OK." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  === ALERTAS DE GARGALO ===" -ForegroundColor Yellow
    foreach ($ag in $alertasGargalo) { Write-Host "  [!] $ag" -ForegroundColor Yellow }
}

# --- COUNTDOWN DE GATES (proximos 7 dias) ---
$hoje95    = [datetime]::Today
$gatesAlert = @()
foreach ($projG in $projetosEmBuild) {
    $cliUpG   = $projG.cliente.ToUpper()
    $gatesWip = $projG.gates_programados
    if (-not $gatesWip) { continue }
    $gatesProx = @()
    foreach ($gate in $gatesWip) {
        try {
            $delta = ([datetime]$gate.data - $hoje95).Days
            if ($delta -ge 0 -and $delta -le 7) {
                $diaSemG = ([datetime]$gate.data).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
                $gatesProx += "    $($gate.nome.PadRight(42)) +${delta}d ($($gate.data) $diaSemG)"
            }
        } catch { continue }
    }
    if ($gatesProx.Count -gt 0) {
        $gatesAlert += ""
        $gatesAlert += "  GATES EM ALERTA -- $cliUpG"
        $gatesAlert += $gatesProx
    }
}
if ($gatesAlert.Count -gt 0) {
    Write-Host ""
    Write-Host "  === COUNTDOWN DE GATES (proximos 7 dias) ===" -ForegroundColor Cyan
    $gatesAlert | ForEach-Object { Write-Host $_ -ForegroundColor Cyan }
} else {
    Write-Host "  [GATE 9.5] Nenhum gate a <= 7 dias. Silencio." -ForegroundColor DarkGray
}

# ADD-F5 -- P-032 trigger: VEREDITOS do dia detectados + MASTER sincronia pos-COUNTDOWN
foreach ($projF5 in $projetosEmBuild) {
    $cliF5  = $projF5.cliente.ToUpper()
    $decF5  = "$BASE\CLIENTES\$cliF5\CLAUDE_PROJECT\DECISOES"
    if (Test-Path $decF5) {
        $decHoje = Get-ChildItem $decF5 -Filter "DECISOES_*.json" -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTime.Date -eq [datetime]::Today }
        foreach ($dH in $decHoje) {
            $sufF5 = $dH.BaseName -replace "^DECISOES_", ""
            $verF5 = Join-Path $decF5 "VEREDITOS_$sufF5.json"
            if (Test-Path $verF5) {
                Write-Host "  [GATE 9.5] P-032 -- $cliF5 VEREDITO executado hoje -- MEMORIA_EMBAIXADOR deve ser atualizada" -ForegroundColor Yellow
                $dtF5 = Get-Date -Format "dd-MM-yyyy"
                $dsF5 = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
                $exF5 = if (Test-Path $pendentesPath) { Get-Content $pendentesPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue } else { "" }
                if ($null -eq $exF5) { $exF5 = "" }
                if (-not ($exF5 -match ("P-032.*" + [regex]::Escape($cliF5) + ".*" + [regex]::Escape($dtF5)))) {
                    Add-Content $pendentesPath "`n- [P-032 ($dtF5 $dsF5)] $cliF5 -- Atualizar MEMORIA_EMBAIXADOR apos VEREDITO (ADD-F5)" -Encoding UTF8
                }
            }
        }
    }
}
$masterF5 = "$BASE\PENTALATERAL_UNIVERSAL\OPERACAO\COMANDO_ESTRATEGISTA_MASTER_v1.md"
if ((Test-Path $masterF5) -and (Test-Path $wipPath)) {
    $wMF5 = (Get-Item $wipPath).LastWriteTime
    $mMF5 = (Get-Item $masterF5).LastWriteTime
    if ($wMF5 -gt $mMF5) {
        $dhF5 = [int]($wMF5 - $mMF5).TotalHours
        Write-Host "  [GATE 9.5] MASTER desatualizado ${dhF5}h -- atualizar antes do proximo Gemini (P-052)" -ForegroundColor Yellow
    }
}

# ==========================================================================
# POS-GATE -- Claude Projects: arquivos para re-arrastar
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
# RELATORIO FINAL -- 9 gates
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

# --- Aviso Claude Projects -- P-022: PAINEL por projeto ---
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host "  ACAO AO EMBAIXADOR (Claude Projects) -- P-022"       -ForegroundColor Magenta
Write-Host "=======================================================" -ForegroundColor Magenta
if ($paineisPorCliente -and $paineisPorCliente.Count -gt 0) {
    foreach ($cliKey in $paineisPorCliente.Keys) {
        $pFile = $paineisPorCliente[$cliKey]
        $pRel  = "PROTOCOLOS_ENCERRAMENTO\" + (Split-Path $pFile -Leaf)
        Write-Host ""
        Write-Host "  [$cliKey] Embaixador -- Claude Projects"          -ForegroundColor White
        Write-Host "  Arrastar: $pRel"                                  -ForegroundColor Yellow
        Write-Host "  Colar no chat:"                                   -ForegroundColor White
        Write-Host "  -----------------------------------------------"  -ForegroundColor DarkGray
        Write-Host "  Embaixador, fechamento de sessao -- $DATA."       -ForegroundColor Cyan
        Write-Host "  Faco upload do PAINEL_ATIVIDADES desta sessao."   -ForegroundColor Cyan
        Write-Host "  Com base nele, gerar o artefato publicavel com:"  -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  SEMAFORO -- status visual (BLOQUEANTE/ATENCAO/SAUDAVEL)" -ForegroundColor Cyan
        Write-Host "  DIAGNOSTICO DO DIA -- saude dos projetos ativos"  -ForegroundColor Cyan
        Write-Host "  PREVISAO DOS PROXIMOS DIAS -- data a data com"    -ForegroundColor Cyan
        Write-Host "    checklist de acoes do Diretor"                  -ForegroundColor Cyan
        Write-Host "  ANALISE GERENCIAL -- ampliar analise do Musculo:" -ForegroundColor Cyan
        Write-Host "    comportamento real confirma ou contradiz?"       -ForegroundColor Cyan
        Write-Host "    O que voce ve que o Musculo nao ve?"             -ForegroundColor Cyan
        Write-Host "  PROXIMA ACAO DO DIRETOR -- max 3 itens em ordem." -ForegroundColor Cyan
        Write-Host "  Artefato autossuficiente: abro e sei o que fazer."-ForegroundColor Cyan
        Write-Host "  -----------------------------------------------"  -ForegroundColor DarkGray
    }
} else {
    $pFallback = "PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_$DATA.md"
    Write-Host "  Arrastar: $pFallback"                                 -ForegroundColor Yellow
}
Write-Host ""
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host ""

# ==========================================================================
# GATE 9Z -- VERIFICACAO PAINEL POR CLIENTE (bloqueante)
# Garante PAINEL_ATIVIDADES para TODOS os projetos ativos -- sem excecao.
# Nao depende do GATE 9 principal ter funcionado.
# ==========================================================================
Write-Host "  [GATE 9Z] Verificando PAINELs por cliente..." -ForegroundColor Cyan
if ($painelScript -and (Test-Path $painelScript)) {
    foreach ($projZ in $projetosEmBuild) {
        $cliZ           = $projZ.cliente
        $cliZUpper      = $cliZ.ToUpper()
        $painelEsperado = "$BASE\PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_${cliZUpper}_$DATA.md"
        if (-not (Test-Path $painelEsperado)) {
            Write-Host "  [GATE 9Z] PAINEL $cliZUpper ausente -- gerando..." -ForegroundColor Yellow
            $gerado = (& powershell.exe -NonInteractive -File $painelScript -Cliente $cliZ 2>$null) | Select-Object -Last 1
            if ($gerado -and (Test-Path $gerado)) {
                Write-Host "  [GATE 9Z] PAINEL $cliZUpper gerado: $(Split-Path $gerado -Leaf)" -ForegroundColor Green
            } else {
                Write-Host "  [GATE 9Z] FALHA $cliZUpper -- rodar: .\scripts\generate_protocolo_encerramento.ps1 -Cliente $cliZ" -ForegroundColor Red
            }
        } else {
            Write-Host "  [GATE 9Z] PAINEL $cliZUpper ja existe: $(Split-Path $painelEsperado -Leaf)" -ForegroundColor Green
        }
    }
}
Write-Host ""

# ==========================================================================
# GATE 9B -- SINCRONIZACAO CLAUDE PROJECTS (P-032)
# Nivel 1: alerta imediato se VEREDITO executado hoje sem MEMORIA atualizada
# Nivel 2: lista priorizada de uploads necessarios
# ==========================================================================
Write-Host ""
Write-Host "  [GATE 9B] Sincronizacao Claude Projects..." -ForegroundColor Cyan

# Nivel 1 -- alerta P-032 por projeto
foreach ($projScp in $projetosEmBuild) {
    $cliScp      = $projScp.cliente.ToUpper()
    $memoriaScpP = "$BASE\CLIENTES\$cliScp\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
    if (Test-Path $memoriaScpP) {
        $minScp = ([datetime]::Now - (Get-Item $memoriaScpP).LastWriteTime).TotalMinutes
        $decPastaScp = "$BASE\CLIENTES\$cliScp\CLAUDE_PROJECT\DECISOES"
        $veredHoje = @(Get-ChildItem "$decPastaScp\VEREDITOS_*.json" -ErrorAction SilentlyContinue |
                       Where-Object { $_.LastWriteTime.Date -eq [datetime]::Today })
        if ($veredHoje.Count -gt 0 -and $minScp -gt 120) {
            Write-Host "  [GATE 9B] $cliScp -- P-032 VIOLADO: VEREDITO executado hoje mas MEMORIA_EMBAIXADOR nao atualizada." -ForegroundColor Red
            Write-Host "             Atualizar MEMORIA_EMBAIXADOR antes de fazer upload ao Claude Projects." -ForegroundColor Red
        }
    }
}

# Nivel 2 -- script estrutural de uploads
$scpScript = "$BASE\scripts\sincronizar_claude_projects.ps1"
$nomesProjScp = @($projetosEmBuild | ForEach-Object { $_.cliente.ToUpper() })
if ($DryRun) {
    Write-Host "  [DRYRUN] GATE 9B -- sincronizar_claude_projects simulado" -ForegroundColor DarkCyan
    $gateStatus["G9B"] = "DRYRUN"
} elseif ((Test-Path $scpScript) -and $nomesProjScp.Count -gt 0) {
    & powershell.exe -NonInteractive -File $scpScript -projetos $nomesProjScp 2>$null
    if ($LASTEXITCODE -eq 0) { $gateStatus["G9B"] = "VERDE" } else { $gateStatus["G9B"] = "AMARELO" }
} else {
    Write-Host "  [GATE 9B] sincronizar_claude_projects.ps1 nao encontrado -- ignorado" -ForegroundColor DarkGray
}

# ==========================================================================
# APRESENTACAO AO DIRETOR -- ordem canonica obrigatoria (P-086)
# ==========================================================================
Write-Host ""
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "  APRESENTACAO AO DIRETOR -- RITUAL DE FECHAMENTO"       -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

# 1. AUDITORIA DE DOCS (proxy: MANIFEST)
Write-Host "  [1] AUDITORIA DE DOCUMENTOS" -ForegroundColor White
foreach ($kv in $manifestStatus.GetEnumerator()) {
    $cor = if ($kv.Value -eq "VERDE") {"Green"} elseif ($kv.Value -eq "AMARELO") {"Yellow"} else {"Red"}
    Write-Host ("      " + $kv.Key.PadRight(12) + ": " + $kv.Value) -ForegroundColor $cor
}
Write-Host ""

# 2. PENDENTES ABERTOS
Write-Host ("  [2] PENDENTES ABERTOS (" + $pendentesAbertos.Count + " itens)") -ForegroundColor White
if ($pendentesAbertos.Count -gt 0) {
    $pendentesAbertos | ForEach-Object { Write-Host "      - $_" -ForegroundColor Yellow }
} else {
    Write-Host "      Nenhum pendente em aberto." -ForegroundColor Green
}
Write-Host ""

# 3. PAINEL DE ATIVIDADES (por projeto)
Write-Host "  [3] PAINEL DE ATIVIDADES" -ForegroundColor White
if ($paineisPorCliente -and $paineisPorCliente.Count -gt 0) {
    foreach ($cliKey in $paineisPorCliente.Keys) {
        $pLeaf = Split-Path $paineisPorCliente[$cliKey] -Leaf
        Write-Host "      [$cliKey] PROTOCOLOS_ENCERRAMENTO\$pLeaf" -ForegroundColor Cyan
        Write-Host "              -> arrastar ao Claude Projects do Embaixador $cliKey" -ForegroundColor Yellow
    }
} else {
    Write-Host "      Arquivo : PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_$DATA.md" -ForegroundColor Cyan
    Write-Host "      Acao    : arrastar ao Claude Projects (Embaixador -- Diretor)" -ForegroundColor Yellow
}
Write-Host ""

# 4. PROXIMA SESSAO
Write-Host "  [4] PROXIMA SESSAO" -ForegroundColor White
$proximoDesc = ""
if ($pendentesAbertos.Count -gt 0) { $proximoDesc = $pendentesAbertos[0] }
if ($proximoDesc) {
    Write-Host "      Prioridade 1: $proximoDesc" -ForegroundColor Cyan
} else {
    Write-Host "      Ver PAINEL para prioridades da proxima sessao." -ForegroundColor DarkGray
}
Write-Host ""
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

# ATO 6 -- Encerrar watch_readonly + flush notify buffer
$watchPidFile  = Join-Path $projectDir "scripts\.watch_readonly.pid"
$notifyScript  = Join-Path $projectDir "scripts\notify_hermes.ps1"
if (Test-Path $watchPidFile) {
    $wPid = ([System.IO.File]::ReadAllText($watchPidFile)).Trim()
    try { Stop-Process -Id $wPid -Force -ErrorAction SilentlyContinue } catch {}
    Remove-Item $watchPidFile -Force -ErrorAction SilentlyContinue
    Write-Host "  [WATCH_READONLY] Monitor R-01 encerrado (PID $wPid)." -ForegroundColor DarkGray
}
if (Test-Path $notifyScript) {
    & powershell.exe -NonInteractive -File $notifyScript -flush 2>$null
}

Write-Host "======================================================="
Write-Host "  Proximo: git commit -- depois PASSO3 + Gemini."
Write-Host "======================================================="
