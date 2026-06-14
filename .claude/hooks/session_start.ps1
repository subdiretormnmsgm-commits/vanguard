# HOOK: SessionStart
# Protege contra: Amnesia de Sessao do Musculo (Deficiencia 1)
# Injeta automaticamente os instrumentos de memoria do Pentalateral IAH

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

function Read-Instrument {
    param([string]$relativePath, [int]$maxLines = 80)
    $fullPath = Join-Path $projectDir $relativePath
    if (-not (Test-Path $fullPath)) { return $null }
    $lines = Get-Content $fullPath -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($null -eq $lines) { return $null }
    if ($lines.Count -gt $maxLines) {
        $lines = $lines[0..($maxLines - 1)]
        $lines += "... [truncado]"
    }
    return $lines -join "`n"
}

$ledger = Read-Instrument "INTELLIGENCE_LEDGER.md" 80
$wip    = Read-Instrument "CLIENTES\WIP_BOARD.json" 60
$socio  = Read-Instrument "CONSELHO\NotebookLM\ANALISE_SOCIO_ATUAL.txt" 25

# --- Gate Alert inline ---
function Get-GateSummary {
    $wipPath = Join-Path $projectDir "CLIENTES\WIP_BOARD.json"
    if (-not (Test-Path $wipPath)) { return $null }
    $board    = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $projetos = @($board.board.build)
    if ($projetos.Count -eq 0) { return $null }
    $hoje  = Get-Date
    $linhas = @("GATE ALERT -- $(Get-Date -Format 'yyyy-MM-dd')")
    $temAlerta = $false
    foreach ($proj in $projetos) {
        $deadlineDate  = [datetime]::Parse($proj.deadline)
        $diasRestantes = ($deadlineDate.Date - $hoje.Date).Days
        $dlStatus = if ($diasRestantes -lt 0) { "VENCIDO ($([Math]::Abs($diasRestantes))d)" }
                    elseif ($diasRestantes -eq 0) { "HOJE" }
                    else { "+$diasRestantes dias" }
        $linhas += ""
        $linhas += "[$($proj.id)] $($proj.cliente) — Deadline: $($proj.deadline) [$dlStatus]"
        if ($proj.gates_bloqueantes -and $proj.build_iniciado_em) {
            $inicio = [datetime]::Parse($proj.build_iniciado_em)
            $gates  = $proj.gates_bloqueantes | Get-Member -MemberType NoteProperty |
                      Select-Object -ExpandProperty Name |
                      Sort-Object { [int]($_ -replace '\D', '') }
            foreach ($g in $gates) {
                $num      = [int]($g -replace '\D', '')
                $gateDate = $inicio.AddDays($num - 1)
                $diff     = ($gateDate.Date - $hoje.Date).Days
                $descricao = $proj.gates_bloqueantes.$g
                $concluido = $false
                if ($proj.dias_completos) {
                    foreach ($d in $proj.dias_completos) {
                        if ($d -match "^dia$num") { $concluido = $true; break }
                    }
                }
                $icone = if ($concluido)      { "[OK]" }
                         elseif ($diff -lt 0) { "[!!]" }
                         elseif ($diff -eq 0) { "[>>]" }
                         else                 { "[  ]" }
                if (-not $concluido -and $diff -le 0) { $temAlerta = $true }
                $linhas += "  $icone $g ($($gateDate.ToString('dd/MM'))): $descricao"
            }
        }
    }
    if ($temAlerta) { $linhas += ""; $linhas += "[!!] Ha gates VENCIDOS ou vencendo HOJE — resolva antes de avancar." }
    return $linhas -join "`n"
}

$gateAlert = Get-GateSummary

# --- P-092 + Embaixador 2026-05-30: Get-CheckInPrompt cirurgico ---
# Cobre APENAS o que os blocos 1-6 do session_start NAO cobrem:
#   A1: coerencia loop_fase_atual.proximo vs socio pendente (auto-corrige)
#   A2: DELIBERACAO_LOOP existe quando musculo=OK (P-091)
#   B:  gates externos vencidos -- lista SIM/NAO (so em ALTO/MAXIMO)
# NORMAL sem problema = string vazia = silencio total
function Get-CheckInPrompt {
    $wipPath2 = Join-Path $projectDir "CLIENTES\WIP_BOARD.json"
    if (-not (Test-Path $wipPath2)) { return "" }
    $hoje  = [datetime]::Today
    try { $wip2 = Get-Content $wipPath2 -Raw -Encoding UTF8 | ConvertFrom-Json }
    catch { return "" }
    $projetos = @($wip2.board.build)
    if ($projetos.Count -eq 0) { return "" }

    # Dias desde ultima sessao (gravado pelo session_close Gate 9.5)
    $diasDesde = 999
    if ($wip2.meta -and $wip2.meta.data_ultima_sessao) {
        try { $diasDesde = ($hoje - [datetime]$wip2.meta.data_ultima_sessao).Days } catch {}
    }

    $todasSaidas  = [System.Collections.ArrayList]@()
    $wipModificado = $false

    foreach ($proj in $projetos) {
        $cUp  = $proj.cliente.ToUpper()
        $cLow = $proj.cliente.ToLower()
        $fase = $proj.loop_fase_atual
        if (-not $fase) { continue }
        $loopN = $fase.loop

        # Nivel
        $loopRecem = ($fase.gemini     -eq "PENDENTE") -and
                     ($fase.notebooklm -eq "PENDENTE") -and
                     ($fase.embaixador -eq "PENDENTE") -and
                     ($fase.musculo    -eq "PENDENTE")
        $nivel = if ($loopRecem) { "MAXIMO" } elseif ($diasDesde -ge 2) { "ALTO" } else { "NORMAL" }

        $verificados    = [System.Collections.ArrayList]@()
        $acoesExternas  = [System.Collections.ArrayList]@()

        # A1 -- coerencia proximo
        $allOK = ($fase.gemini -eq "OK") -and ($fase.notebooklm -eq "OK") -and
                 ($fase.embaixador -eq "OK") -and ($fase.musculo -eq "OK")
        if ($allOK) {
            $proxEsp = "Gemini -- PASSO3 Loop $($loopN + 1)"
            if ($fase.proximo -ne $proxEsp) {
                $fase.proximo  = $proxEsp
                $wipModificado = $true
                [void]$verificados.Add("[AUTO-FIX] $cUp loop_fase_atual.proximo -> $proxEsp")
            }
        } else {
            $socPend = if ($fase.gemini     -ne "OK") { "Gemini" }
                       elseif ($fase.notebooklm -ne "OK") { "NotebookLM" }
                       elseif ($fase.embaixador -ne "OK") { "Embaixador" }
                       else { "Musculo" }
            if ($fase.proximo -and $fase.proximo -notmatch $socPend) {
                [void]$verificados.Add("[INCONSISTENCIA] $cUp proximo='$($fase.proximo)' mas pendente=$socPend")
            }
        }

        # A2 -- DELIBERACAO_LOOP vs musculo=OK (P-091)
        if ($fase.musculo -eq "OK") {
            $deliberPath = Join-Path $projectDir "CLIENTES\$cUp\HISTORICO\DELIBERACAO_LOOP_V${loopN}_${cLow}.md"
            if (-not (Test-Path $deliberPath)) {
                [void]$verificados.Add("[INCONSISTENCIA] $cUp musculo=OK sem DELIBERACAO_LOOP_V$loopN (P-091)")
            }
        }

        # B -- gates externos vencidos (so ALTO ou MAXIMO)
        if ($nivel -ne "NORMAL" -and $proj.gates_programados) {
            foreach ($gate in $proj.gates_programados) {
                try {
                    $dg    = [datetime]$gate.data
                    $delta = ($hoje - $dg).Days
                    if ($dg -le $hoje -and $gate.status -ne "APROVADO") {
                        [void]$acoesExternas.Add("[ ] '$($gate.nome)' ($($dg.ToString('dd-MM-yyyy')), ha ${delta}d): APROVADO offline?")
                    }
                } catch { continue }
            }
        }

        # Silencio se nada a reportar
        if ($nivel -eq "NORMAL" -and $verificados.Count -eq 0 -and $acoesExternas.Count -eq 0) { continue }

        $hdr = switch ($nivel) {
            "NORMAL" { "CHECK-IN [$cUp - NORMAL]" }
            "ALTO"   { "CHECK-IN [$cUp - ALTO -- $diasDesde dia(s) desde ultima sessao]" }
            "MAXIMO" { "CHECK-IN [$cUp - MAXIMO -- loop recem aberto]" }
        }
        $s = "`n=== $hdr ===`n"
        if ($verificados.Count -gt 0) {
            $s += "`n-- VERIFICADO AUTOMATICAMENTE --`n"
            foreach ($v in $verificados) { $s += "  $v`n" }
        }
        if ($acoesExternas.Count -gt 0) {
            $s += "`n-- SO O DIRETOR SABE (substituir [ ] por [S] ou [N]) --`n"
            foreach ($a in $acoesExternas) { $s += "  $a`n" }
            $s += "`n  Colar de volta para o Musculo processar`n"
        }
        $s += "$("=" * 50)`n"
        [void]$todasSaidas.Add($s)
    }

    if ($wipModificado) {
        try { [System.IO.File]::WriteAllText($wipPath2, ($wip2 | ConvertTo-Json -Depth 20), [System.Text.Encoding]::UTF8) } catch {}
    }

    return $todasSaidas -join ""
}

$checkIn = Get-CheckInPrompt
if (-not $checkIn) { $checkIn = $null }  # string vazia vira null -- silencio total

# --- PENDENTES: alerta completo com instruções detalhadas (P-063) ---
# Injeta título + sub-bullets de cada tarefa aberta para o Músculo ter as instruções exatas
function Get-PendentesAlert {
    $pendPath = Join-Path $projectDir "PENDENTES.md"
    if (-not (Test-Path $pendPath)) { return $null }
    $linhas = Get-Content $pendPath -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $linhas) { return $null }

    $hoje    = Get-Date
    $abertos = @()
    $i = 0
    while ($i -lt $linhas.Count) {
        $l = $linhas[$i]
        if ($l -match '^\s*- \[ \]') {
            $dataMatch = [regex]::Match($l, '`(\d{4}-\d{2}-\d{2})`')
            $dataPend  = if ($dataMatch.Success) { [datetime]$dataMatch.Groups[1].Value } else { $hoje }
            $atraso    = ($hoje.Date - $dataPend.Date).Days
            $titulo    = $l -replace '^\s*- \[ \]\s*`[^`]+`\s*', '' -replace '\*\*([^*]+)\*\*', '$1'

            # Captura sub-bullets logo abaixo (linhas indentadas que não são outra tarefa)
            $subs = @()
            $j = $i + 1
            while ($j -lt $linhas.Count) {
                $next = $linhas[$j]
                if ($next -match '^\s*- \[') { break }   # próxima tarefa
                if ($next -match '^#{1,3} ')  { break }   # novo heading
                if ($next.Trim() -eq '')       { $j++; continue }  # linha vazia: pular mas continuar
                $subs += "    " + $next.Trim()
                $j++
                if ($subs.Count -ge 6) { break }  # máx 6 sub-linhas por tarefa
            }

            $abertos += [PSCustomObject]@{
                Atraso = $atraso
                Titulo = $titulo.Trim()
                Subs   = $subs
            }
        }
        $i++
    }
    if ($abertos.Count -eq 0) { return $null }

    $abertos  = $abertos | Sort-Object Atraso -Descending
    $vencidos = @($abertos | Where-Object { $_.Atraso -gt 0 })
    $emPrazo  = @($abertos | Where-Object { $_.Atraso -eq 0 })

    $out = @("PENDENTES (P-048) — $($abertos.Count) abertos — LEIA AS INSTRUCOES, NAO SO OS TITULOS")
    if ($vencidos.Count -gt 0) {
        $out += "⚠️  EM ATRASO — resolver AGORA:"
        foreach ($p in $vencidos) {
            $d = if ($p.Atraso -eq 1) { "1 dia" } else { "$($p.Atraso) dias" }
            $out += "  🔴 [$d atrasado] $($p.Titulo)"
            foreach ($s in $p.Subs) { $out += $s }
        }
    }
    if ($emPrazo.Count -gt 0) {
        $out += "No prazo — adicionados hoje:"
        foreach ($p in $emPrazo) {
            $out += "  • $($p.Titulo)"
            foreach ($s in $p.Subs) { $out += $s }
        }
    }
    return $out -join "`n"
}

$pendentesAlert = Get-PendentesAlert

# --- CONTEXTO SESSAO DIRETOR: contexto conversacional da ultima sessao ---
function Get-ContextoSessao {
    $protDir = Join-Path $projectDir "PROTOCOLOS_ENCERRAMENTO"
    if (-not (Test-Path $protDir)) { return $null }
    $arquivos = Get-ChildItem $protDir -Filter "CONTEXTO_SESSAO_DIRETOR_*.md" -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending
    if (-not $arquivos -or $arquivos.Count -eq 0) { return $null }
    $mais_recente = $arquivos[0]
    $data_ctx = $mais_recente.BaseName -replace "CONTEXTO_SESSAO_DIRETOR_", ""
    $conteudo = Get-Content $mais_recente.FullName -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $conteudo) { return $null }
    $secoes_chave = @()
    $capturando = $false
    $linhas_capturadas = 0
    foreach ($linha in $conteudo) {
        if ($linha -match '^## [23456]') { $capturando = $true }
        if ($linha -match '^## [78]' -or $linhas_capturadas -ge 60) { break }
        if ($capturando) { $secoes_chave += $linha; $linhas_capturadas++ }
    }
    $resumo = @("CONTEXTO DA ULTIMA SESSAO -- $data_ctx", "")
    $resumo += $secoes_chave
    return $resumo -join "`n"
}

$contextoSessao = Get-ContextoSessao

# --- BLOCO 1: Varredura de Documentos Mortos (P-113) ---
# Detecta arquivos > 7 dias sem referencia em DEPENDENCY_MAP, PENDENTES ou WIP_BOARD
function Get-DocumentosMortos {
    $hoje = [datetime]::Today
    $limite = 7
    # Listas de referencia
    $depMapPath  = Join-Path $projectDir "PENTALATERAL_UNIVERSAL\OPERACAO\DEPENDENCY_MAP.json"
    $pendPath    = Join-Path $projectDir "PENDENTES.md"
    $wipPathDM   = Join-Path $projectDir "CLIENTES\WIP_BOARD.json"
    $refTexto = ""
    if (Test-Path $depMapPath) { $refTexto += (Get-Content $depMapPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue) }
    if (Test-Path $pendPath)   { $refTexto += (Get-Content $pendPath   -Raw -Encoding UTF8 -ErrorAction SilentlyContinue) }
    if (Test-Path $wipPathDM)  { $refTexto += (Get-Content $wipPathDM  -Raw -Encoding UTF8 -ErrorAction SilentlyContinue) }

    # Diretorios a escanear
    $diretorios = @(
        (Join-Path $projectDir "CONSELHO"),
        (Join-Path $projectDir "CLIENTES"),
        (Join-Path $projectDir "PENTALATERAL_UNIVERSAL\OPERACAO"),
        (Join-Path $projectDir "scripts")
    )
    $mortos = [System.Collections.ArrayList]@()
    foreach ($dir in $diretorios) {
        if (-not (Test-Path $dir)) { continue }
        $arquivos = Get-ChildItem $dir -Recurse -File -Include "*.md","*.txt","*.ps1" -ErrorAction SilentlyContinue
        foreach ($arq in $arquivos) {
            # Ignorar pastas HISTORICO e NOTEBOOKLM_FONTES (esperado ter arquivos antigos)
            if ($arq.FullName -match '\\HISTORICO\\' -or $arq.FullName -match '\\NOTEBOOKLM_FONTES\\') { continue }
            if ($arq.FullName -match '\\NOTEBOOKLM_DROP\\') { continue }
            $diasIdle = ($hoje - $arq.LastWriteTime.Date).Days
            if ($diasIdle -lt $limite) { continue }
            $nome = $arq.Name
            if ($refTexto -match [regex]::Escape($nome)) { continue }
            [void]$mortos.Add([PSCustomObject]@{ Nome = $nome; Dias = $diasIdle; Path = $arq.FullName })
        }
    }
    if ($mortos.Count -eq 0) { return $null }
    $top = @($mortos | Sort-Object Dias -Descending | Select-Object -First 5)
    $linhas = @("DOCUMENTOS MORTOS -- $($mortos.Count) arquivo(s) sem referencia ativa ha > $limite dias", "")
    foreach ($m in $top) {
        $relPath = $m.Path.Replace($projectDir + "\", "")
        $linhas += "  [MORTO] $($m.Nome) -- $($m.Dias) dias -- $relPath"
    }
    if ($mortos.Count -gt 5) { $linhas += "  ... e mais $($mortos.Count - 5) arquivo(s)" }
    $linhas += ""
    $linhas += "  Acao: verificar se ainda tem uso. Se nao: deletar ou arquivar."
    return $linhas -join "`n"
}

$documentosMortos = Get-DocumentosMortos

# ENTREGAVEL 12 -- Pendentes vencidos formato P-069 (DD-MM-YYYY dia-da-semana)
# Complementa Get-PendentesAlert (que detecta formato backtick ISO) com o formato P-069
$pendentesVencidosP069 = ""
try {
    $pendPathV = Join-Path $projectDir "PENDENTES.md"
    if (Test-Path $pendPathV) {
        $linhasV  = Get-Content $pendPathV -Encoding UTF8 -ErrorAction SilentlyContinue
        $hojeV    = [datetime]::Today
        $vencP069 = [System.Collections.ArrayList]@()
        foreach ($linhaV in $linhasV) {
            # Formato P-069: - [KEYWORD (DD-MM-YYYY dia-da-semana)] descricao
            if ($linhaV -match '^\s*-\s*\[.+?\((\d{2}-\d{2}-\d{4})\s') {
                try {
                    $dataPV  = [datetime]::ParseExact($matches[1], "dd-MM-yyyy", $null)
                    $diasV   = ($hojeV - $dataPV).Days
                    if ($diasV -gt 0) {
                        [void]$vencP069.Add([PSCustomObject]@{
                            Linha       = $linhaV.Trim()
                            DiasVencido = $diasV
                        })
                    }
                } catch { continue }
            }
        }
        if ($vencP069.Count -gt 0) {
            $lnsV069 = @("PENDENTES VENCIDOS (P-069) -- $($vencP069.Count) item(ns) -- resolver antes de avancar", "")
            $topV069 = @($vencP069 | Sort-Object DiasVencido -Descending | Select-Object -First 5)
            foreach ($pv069 in $topV069) {
                $truncado = $pv069.Linha.Substring(0, [Math]::Min(80, $pv069.Linha.Length))
                $lnsV069 += "  [$($pv069.DiasVencido)d atrasado] $truncado"
            }
            if ($vencP069.Count -gt 5) {
                $lnsV069 += "  ... e mais $($vencP069.Count - 5) item(ns)"
            }
            $pendentesVencidosP069 = $lnsV069 -join "`n"
        }
    }
} catch {}

# --- PENDENTES-WATCH: fallback P-087 -- commits recentes vs itens abertos sem [x] ---
$pendentesWatchOutput = ""
$reconcileScript = Join-Path $projectDir "scripts\reconcile_pendentes.ps1"
if (Test-Path $reconcileScript) {
    try {
        $pwLines = & powershell.exe -NonInteractive -File $reconcileScript 2>$null
        if ($pwLines) {
            $pendentesWatchOutput = ($pwLines | Where-Object { $_ -ne $null }) -join "`n"
        }
    } catch {}
}

# --- P-069: Mapa Diario de Pendencias (visibilidade cruzada por data em todos os projetos) ---
$mapaDiarioOutput = ""
$mapaDiarioScript = Join-Path $projectDir "scripts\mapa_diario_pendencias.ps1"
if (Test-Path $mapaDiarioScript) {
    try {
        $mdLines = & powershell.exe -NonInteractive -File $mapaDiarioScript -Silencioso 2>$null
        if ($mdLines) {
            $mapaDiarioOutput = ($mdLines | Where-Object { $_ -ne $null }) -join "`n"
        }
    } catch {}
}

# --- Gargalo Ping silencioso (dispara e-mail se Diretor estiver bloqueando) ---
$pingScript = Join-Path $projectDir "scripts\gargalo_ping.ps1"
if (Test-Path $pingScript) {
    try { & $pingScript 2>$null | Out-Null } catch {}
}

# --- Ledger Sync silencioso (INTELLIGENCE_LEDGER sempre fresco em NOTEBOOKLM_FONTES) ---
$ledgerSyncScript = Join-Path $projectDir ".claude\hooks\pre_session_ledger_sync.ps1"
if (Test-Path $ledgerSyncScript) {
    try { $lsOut = & powershell.exe -NonInteractive -File $ledgerSyncScript 2>$null
          if ($lsOut) { Write-Host $lsOut } } catch {}
}

# --- SYNC_GUARD: integridade de documentos canonicos (P-033 / FASE 2 SYNC_GUARD) ---
$syncGuardOutput = ""
$syncGuardScript = Join-Path $projectDir "scripts\sync_guard.ps1"
if (Test-Path $syncGuardScript) {
    try {
        $sgLines = & powershell.exe -NonInteractive -File $syncGuardScript -Abertura 2>$null
        $sgText  = $sgLines -join "`n"
        if ($sgText -match "\[VERMELHO\]" -or $sgText -match "\[AMARELO\]") {
            $syncGuardOutput = $sgText
        }
    } catch {}
}

# --- STATE_GUARD: anomalias semanticas no WIP_BOARD (V28) ---
$stateGuardOutput = ""
$stateGuardScript = Join-Path $projectDir "scripts\state_guard.ps1"
if (Test-Path $stateGuardScript) {
    try {
        $sgRaw = & powershell.exe -NonInteractive -File $stateGuardScript -Silencioso 2>$null
        $sgJson = $sgRaw -join "" | ConvertFrom-Json
        if ($sgJson -and $sgJson.alertas -gt 0) {
            $linhasSG = @("STATE_GUARD V28 -- $(Get-Date -Format 'yyyy-MM-dd') -- $($sgJson.alertas) anomalia(s)")
            foreach ($det in $sgJson.detalhes) {
                $linhasSG += "  [$($det.nivel)] $($det.detalhe)"
            }
            $stateGuardOutput = $linhasSG -join "`n"
        }
    } catch {}
}

# --- MANIFEST_DOCS: estado de sincronizacao por projeto (P-071) ---
function Get-ManifestStatus {
    $wipPath = Join-Path $projectDir "CLIENTES\WIP_BOARD.json"
    if (-not (Test-Path $wipPath)) { return $null }
    $board    = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $projetos = @($board.board.build)
    if ($projetos.Count -eq 0) { return $null }
    $linhas    = @("MANIFEST SYNC -- $(Get-Date -Format 'yyyy-MM-dd')")
    $temAlerta = $false
    foreach ($proj in $projetos) {
        $cli          = $proj.cliente.ToUpper()
        $manifestPath = Join-Path $projectDir "CLIENTES\$cli\MANIFEST_DOCS.json"
        if (-not (Test-Path $manifestPath)) {
            $linhas   += "  $cli -- SEM MANIFEST (rodar session_close.ps1 para criar)"
            $temAlerta = $true
            continue
        }
        $manifest = Get-Content $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $status   = $manifest.status_geral
        $ultima   = if ($manifest.ultima_sincronizacao) { $manifest.ultima_sincronizacao.Substring(0, 10) } else { "?" }
        $total    = $manifest.total
        $drift    = $manifest.drift_count
        $ausente  = $manifest.ausente_count
        $icone    = if ($status -eq "VERDE") { "[OK]" } elseif ($status -eq "AMARELO") { "[!!]" } else { "[XX]" }
        $linhas  += "  $icone $cli -- $status . $total arqs . $drift drift . $ausente ausente . sync: $ultima"
        if ($status -ne "VERDE") { $temAlerta = $true }
    }
    if ($temAlerta) {
        $linhas += ""
        $linhas += "[!!] Um ou mais projetos fora de sync -- session_close.ps1 corrige automaticamente."
    }
    return $linhas -join "`n"
}

$manifestStatus = Get-ManifestStatus

# --- Gemini Anchor silencioso (CONTEXTO_GEMINI.md sempre atualizado) ---
$anchorScript = Join-Path $projectDir "scripts\gemini_anchor_generator.ps1"
if (Test-Path $anchorScript) {
    try { & powershell.exe -NonInteractive -File $anchorScript 2>$null | Out-Null } catch {}
}

# --- Validador Formalizador silencioso (detecta termo comercial nao aprovado) ---
$formalizadorOutput = ""
$validarScript = Join-Path $projectDir "scripts\validar_formalizador.ps1"
if (Test-Path $validarScript) {
    try {
        $fLines = & powershell.exe -NonInteractive -File $validarScript -Silencioso 2>$null
        if ($fLines) {
            $formalizadorOutput = ($fLines | Where-Object { $_ -ne $null }) -join "`n"
        }
    } catch {}
}

# --- Loop Guardian silencioso (detecta loop evolutivo parado) ---
$loopGuardianOutput = ""
$loopScript = Join-Path $projectDir "scripts\loop_guardian.ps1"
if (Test-Path $loopScript) {
    try {
        $loopLines = & powershell.exe -NonInteractive -File $loopScript -Silencioso 2>$null
        if ($loopLines) {
            $loopGuardianOutput = ($loopLines | Where-Object { $_ -ne $null }) -join "`n"
        }
    } catch {}
}

# --- P-055: Estado real dos projetos (verifica skills em disco, nao apenas WIP_BOARD) ---
$estadoRealOutput = ""
$estadoRealScript = Join-Path $projectDir "scripts\verificar_estado_projetos.ps1"
if (Test-Path $estadoRealScript) {
    try {
        $erLines = & powershell.exe -NonInteractive -File $estadoRealScript 2>$null
        if ($erLines) {
            $estadoRealOutput = ($erLines | Where-Object { $_ -ne $null }) -join "`n"
        }
    } catch {}
}

# --- Verificar DECISOES.json sem VEREDITOS (P-071: painel abre antes da agenda) ---
function Get-DecisoesPendentes {
    $clDir = Join-Path $projectDir "CLIENTES"
    if (-not (Test-Path $clDir)) { return $null }
    $alertas = @()
    $pastas = Get-ChildItem "$clDir\*\CLAUDE_PROJECT\DECISOES" -Directory -ErrorAction SilentlyContinue
    foreach ($pasta in $pastas) {
        $decisoes = Get-ChildItem $pasta.FullName -Filter "DECISOES_*.json" -ErrorAction SilentlyContinue
        foreach ($d in $decisoes) {
            $sufixo = $d.BaseName -replace "^DECISOES_",""
            $veredito = Join-Path $pasta.FullName "VEREDITOS_$sufixo.json"
            if (-not (Test-Path $veredito)) {
                $partes = $pasta.FullName -split [regex]::Escape("\CLIENTES\")
                $cli = if ($partes.Count -gt 1) { ($partes[1] -split "\\")[0] } else { "?" }
                $alertas += "  [!!] $cli -- $($d.Name) sem VEREDITOS -- Diretor delibera antes de qualquer acao"
            }
        }
    }
    if ($alertas.Count -eq 0) { return $null }
    $linhas = @(
        "DECISOES PENDENTES DE VEREDITO -- $(Get-Date -Format 'yyyy-MM-dd')",
        "Rodar: .\scripts\render_painel.ps1 -projeto [CLIENTE] para deliberar.",
        "Agenda esta bloqueada ate o veredito do Diretor.",
        ""
    )
    $linhas += $alertas
    return $linhas -join "`n"
}

# --- Verificar ChurnWatch_Vanguard no Task Scheduler (Ponto 5) ---
function Get-ChurnWatchStatus {
    $task = Get-ScheduledTask -TaskName "ChurnWatch_Vanguard" -ErrorAction SilentlyContinue
    if ($task) { return $null }
    $linhas = @(
        "CHURN-WATCH INATIVO -- ChurnWatch_Vanguard nao registrado no Task Scheduler",
        "IMPACTO: silencio de cliente passa sem alerta automatico.",
        "",
        "ACAO (terminal normal, sem Admin):",
        "  Rodar: .\scripts\registrar_churnwatch.ps1",
        "  Ou: Register-ScheduledTask via PowerShell com RunLevel Limited",
        "  Confirmacao: Get-ScheduledTask -TaskName ChurnWatch_Vanguard"
    )
    return $linhas -join "`n"
}

# --- Verificar MEMORIA_EMBAIXADOR por projeto em BUILD (RISCO C) ---
function Get-EmbaixadorStatus {
    $wipPath = Join-Path $projectDir "CLIENTES\WIP_BOARD.json"
    if (-not (Test-Path $wipPath)) { return $null }
    $board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $projs = @($board.board.build)
    if ($projs.Count -eq 0) { return $null }
    $alertas = @()
    foreach ($proj in $projs) {
        $cli = $proj.cliente.ToUpper()
        $embPath = Join-Path $projectDir "CLIENTES\$cli\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
        if (-not (Test-Path $embPath)) {
            # DECISAO SOBERANA: se flag existir e for recente (< 7 dias), suprimir alerta
            $soberanaPath = Join-Path $projectDir "CLIENTES\$cli\CLAUDE_PROJECT\SOBERANA_EMBAIXADOR.flag"
            if (Test-Path $soberanaPath) {
                $flagAge = (Get-Date) - (Get-Item $soberanaPath).LastWriteTime
                if ($flagAge.TotalDays -lt 7) {
                # FIX C8: registrar bypass em PENDENTES.md com formato P-069
                $dtSob   = Get-Date -Format "dd-MM-yyyy"
                $dsSob   = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
                $pendSob = Join-Path $projectDir "PENDENTES.md"
                $entrSob = "- [SOBERANA ($dtSob $dsSob)] $cli -- SOBERANA_EMBAIXADOR ativa -- verificar se Embaixador reagiu"
                if (Test-Path $pendSob) {
                    $exSob = Get-Content $pendSob -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
                    if (-not ($exSob -match ("SOBERANA.*" + $dtSob + ".*" + $cli))) {
                        Add-Content $pendSob "`n$entrSob" -Encoding UTF8
                    }
                }
                continue
            }
            }
            $alertas += "  [!!] $cli -- MEMORIA_EMBAIXADOR.md ausente -- Embaixador NAO ativo para este projeto"
            $alertas += "       Rodar: .\scripts\ir_ao_embaixador.ps1 -cliente $cli"
            $alertas += "       Para suprimir (projeto novo, Embaixador ainda nao ativado por design):"
            $alertas += "       Musculo cria: CLIENTES\$cli\CLAUDE_PROJECT\SOBERANA_EMBAIXADOR.flag"
        }
    }
    if ($alertas.Count -eq 0) { return $null }
    $linhas = @("EMBAIXADOR INATIVO -- PROJETO(S) SEM MEMORIA_EMBAIXADOR (RISCO C)", "")
    $linhas += $alertas
    return $linhas -join "`n"
}

# --- Lembrete de Loop: fase atual por projeto em BUILD (ITEM 1 / C1) ---
function Get-LembreteDeLoop {
    $wipPath = Join-Path $projectDir "CLIENTES\WIP_BOARD.json"
    if (-not (Test-Path $wipPath)) { return $null }
    try {
        $board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $projs = @($board.board.build)
        if ($projs.Count -eq 0) { return $null }
        $linhas = @("FASES DO LOOP ATIVO -- $(Get-Date -Format 'yyyy-MM-dd')", "")
        $temDado = $false
        foreach ($proj in $projs) {
            $lfa = $proj.loop_fase_atual
            if (-not $lfa) { continue }
            $temDado = $true
            $linhas += "[$($proj.id)] $($proj.cliente) -- Loop $($lfa.loop)"
            foreach ($socio in @("gemini","notebooklm","embaixador","musculo")) {
                $st = $lfa.$socio
                $icon = if ($st -eq "OK") { "[OK]" } else { "[--]" }
                $linhas += "  $icon $($socio.PadRight(11)): $st"
            }
            $linhas += "  PROXIMO      : $($lfa.proximo)"
            # claude_projects_pendente -- flag de upload pendente
            $cpPend = $false
            try { $cpPend = [bool]$board.meta.claude_projects_pendente } catch {}
            $cpStatus = if ($cpPend) {
                "DESATUALIZADO -- fazer upload antes de ir ao Embaixador"
            } else { "OK" }
            $linhas += "  Claude Proj  : $cpStatus"
            # Doc-Sync (Auditor): AUDITOR_LOOP preenchido sem placeholders?
            $cliLow3  = $proj.cliente.ToLower()
            $loopN3   = try { [int]$lfa.loop } catch { 0 }
            $audPath3 = Join-Path $projectDir "CLIENTES\$($proj.cliente.ToUpper())\HISTORICO\AUDITOR_LOOP_V${loopN3}_${cliLow3}.md"
            $docSync3 = if (-not (Test-Path $audPath3)) { "PENDENTE" }
                        elseif ((Get-Content $audPath3 -Raw -Encoding UTF8 -ErrorAction SilentlyContinue) -match '\[colar aqui\]') { "INCOMPLETO" }
                        else { "OK" }
            $cor3 = if ($docSync3 -eq "OK") { "[OK]" } elseif ($docSync3 -eq "INCOMPLETO") { "[!!]" } else { "[--]" }
            $linhas += "  $cor3 Doc-Sync     : $docSync3  (AUDITOR_LOOP_V$loopN3)"
            $linhas += ""
        }
        if (-not $temDado) { return $null }
        return $linhas -join "`n"
    } catch { return $null }
}

# --- Discovery: detectar projeto novo em board.discovery (ENTREGAVEL 3 — OSV-007) ---
function Get-DiscoveryAlert {
    $wipPath = Join-Path $projectDir "CLIENTES\WIP_BOARD.json"
    if (-not (Test-Path $wipPath)) { return $null }
    try {
        $board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $projetosNovos = @($board.board.discovery) | Where-Object { $_ }
        if ($projetosNovos.Count -eq 0) { return $null }
        $linhas = @("PROJETO NOVO EM DISCOVERY -- verificar sistema antes de onboarding", "")
        foreach ($novo in $projetosNovos) {
            $nome = if ($novo.cliente) { $novo.cliente } elseif ($novo.id) { $novo.id } else { "?" }
            $linhas += "  -> $nome (DISCOVERY)"
        }
        $linhas += ""
        $linhas += "  Confirmar VERDE antes de onboarding:"
        $linhas += "  C1 (LEMBRETE LOOP) . C4 (watcher logs) . C7 (churn threshold) . C8 (ROTEIRO UNIVERSAL)"
        return $linhas -join "`n"
    } catch { return $null }
}

$decisoesPendentes = Get-DecisoesPendentes
$churnWatchStatus  = Get-ChurnWatchStatus
$embaixadorStatus  = Get-EmbaixadorStatus
$loopLembrete      = Get-LembreteDeLoop
$discoveryAlert    = Get-DiscoveryAlert

# --- Lançar decisoes_watcher.ps1 como background silencioso (P-071) ---
# ITEM 4A: EncodedCommand evita corrupcao de path com acentos (Area de Trabalho)
$watcherScript = Join-Path $projectDir "scripts\decisoes_watcher.ps1"
if (Test-Path $watcherScript) {
    try {
        $wCmd = "& '$watcherScript'"
        $wEnc = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($wCmd))
        Start-Process powershell -ArgumentList "-NonInteractive -WindowStyle Hidden -EncodedCommand $wEnc" -WindowStyle Hidden -ErrorAction SilentlyContinue
    } catch {}
}

# --- Lançar skill_watcher.ps1 por projeto em BUILD (P-075: Diretor nao move Skill manualmente) ---
$wipForSkill = Join-Path $projectDir "CLIENTES\WIP_BOARD.json"
$swScript    = Join-Path $projectDir "scripts\skill_watcher.ps1"
if ((Test-Path $wipForSkill) -and (Test-Path $swScript)) {
    try {
        $boardSw = Get-Content $wipForSkill -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($projSw in @($boardSw.board.build)) {
            $cliSw = $projSw.cliente
            $swCmd = "& '$swScript' -cliente $cliSw"
            $swEnc = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($swCmd))
            Start-Process powershell -ArgumentList "-NonInteractive -WindowStyle Hidden -EncodedCommand $swEnc" -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
    } catch {}
}

# --- P-072: Detectar VEREDITOS nao processados no GitHub ---
$vereditosTelegramOutput = ""
$detectVereditosScript = Join-Path $projectDir "scripts\detectar_vereditos_github.ps1"
if (Test-Path $detectVereditosScript) {
    try {
        $vLines = & powershell.exe -NonInteractive -File $detectVereditosScript 2>$null
        if ($vLines) {
            $vereditosTelegramOutput = ($vLines | Where-Object { $_ -ne $null }) -join "`n"
        }
    } catch {}
}

# --- ATO 3 Loop 33: AGENTS.md gate (firewall Antigravity) ---
$agentsMdAlert = ""
$agentsPath = Join-Path $projectDir "AGENTS.md"
if (-not (Test-Path $agentsPath)) {
    $agentsMdAlert = "AGENTS.md AUSENTE na raiz do repositorio.`nO firewall do Antigravity nao existe. Criar AGENTS.md antes de qualquer acionamento do Antigravity.`nAcao: executar ATO 3 do Loop 33 via Musculo."
}

# --- ATO 4 Loop 33: Build Budget Guard (P-148) -- builds aprovados sem inicio ---
$buildBudgetOutput = ""
$budgetScript = Join-Path $projectDir "scripts\build_budget_guard.ps1"
if (Test-Path $budgetScript) {
    try {
        $bbLines = & powershell.exe -NonInteractive -File $budgetScript 2>$null
        if ($bbLines) {
            $buildBudgetOutput = ($bbLines | Where-Object { $_ -ne $null }) -join "`n"
        }
    } catch {}
}

# ADD-A1 -- Commits recentes (ultimos 10) para contexto de sessao
$ultimosCommits = ""
try {
    $cl = & git -C $projectDir log --oneline -10 2>$null
    if ($cl) { $ultimosCommits = ($cl -join "`n") }
} catch {}

# --- PASSO 0: COLHEITA DO EMBAIXADOR (INBOX_COWORK via MCP Drive) --- BLOQUEANTE ---
# Mesmo nivel de bloqueio que BLOCO 0. Musculo NAO responde ao Diretor antes de executar.
# Notion ja e executado automaticamente pelo hook (paralelo acima) -- confirmar processamento.
$colheitaCowork = @(
    "⛔ PASSO 0B -- COWORK -- BLOQUEANTE -- EXECUTAR APOS BLOCO 0 E NOTION (P-158)",
    "",
    "Notion (PASSO 0A) ja esta na secao acima. Esta secao e exclusivamente COWORK + ARTIFACT ENGINE.",
    "",
    "━━━ [1] COWORK -- MCP Google Drive (conta: subdiretor.mnmsgm@gmail.com) ━━━━━━━━━━━━",
    "  Folder ID INBOX_COWORK: 1EjaH6TmsxbYpgKWb7ASm7CohFJfwSLKi",
    "  Frentes ativas: F1 (diario) - F5 (quinzenal) - F8 - F9 - F12 - F15 (agendadas)",
    "",
    "  FLUXO:",
    "  1. mcp__claude_ai_Google_Drive__search_files (parentId = '1EjaH6TmsxbYpgKWb7ASm7CohFJfwSLKi')",
    "  2. Filtrar: apenas arquivos sem prefixo [LIDO] no titulo",
    "  3. Para cada arquivo novo:",
    "     a. mcp__claude_ai_Google_Drive__read_file_content",
    "     b. Extrair: frente, data, 3 bullets do sinal mais urgente",
    "     c. Renomear com prefixo [LIDO] via copy_file + deletar original",
    "  4. Apresentar COLHEITA no formato:",
    "     COLHEITA DO EMBAIXADOR -- [N] arquivo(s) novo(s)",
    "     [F1] [nome da frente] - [data]: bullet1 / bullet2 / bullet3",
    "",
    "  SE INBOX VAZIO: exibir [AMARELO] e continuar para ARTIFACT ENGINE.",
    "  Apos processar: & '.\scripts\gate_passo0_abertura.ps1' -MarcarCowork",
    "",
    "━━━ [2] ARTIFACT ENGINE -- invocar Skill cowork-engine-v1 (bloqueante) ━━━━━━━━━━━━━━",
    "  Executar APOS a COLHEITA ([1]). Nao pular. Nao simplificar.",
    "",
    "  ACAO OBRIGATORIA:",
    "    Invocar: Skill tool -> skill: 'cowork-engine-v1'",
    "    A skill executa as 5 fases completas (Diagnostico -> Planejamento -> Execucao ->",
    "    Validacao -> Otimizacao) e apresenta os artefatos ao Diretor para veredito.",
    "",
    "  A skill e a fonte unica de verdade deste processo.",
    "  Nao replicar as instrucoes aqui -- seguir a skill.",
    "",
    "  ⛔ Musculo que avanca para PENDENTES/WIP sem ter executado [1]+[2] = P-158 VIOLADO + DEF-M-6.",
    "  ⛔ Musculo que lista sinais sem invocar a skill = [2] incompleto."
) -join "`n"

# --- GATE 7C MIRROR: Frescor dos 7 Arquivos do Embaixador (informativo na abertura) ---
# Mesmo check do Gate 7C do session_close -- exibe no INICIO para que o Musculo
# saiba quais arquivos precisam ser atualizados ANTES de fechar a sessao.
# Nao bloqueia a abertura -- session_close BLOQUEIA se arquivos estiverem stale.
function Get-FrescorEmbaixador {
    $dataRef = [datetime]::Today
    $dataStr = Get-Date -Format "yyyy-MM-dd"
    $protDir = Join-Path $projectDir "PROTOCOLOS_ENCERRAMENTO"

    $painelFile = Get-ChildItem $protDir -Filter "PAINEL_ATIVIDADES_*$dataStr*.md" -ErrorAction SilentlyContinue |
                  Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $painelFile) {
        $painelFile = Get-ChildItem $protDir -Filter "PAINEL_ATIVIDADES_*.md" -ErrorAction SilentlyContinue |
                      Sort-Object LastWriteTime -Descending | Select-Object -First 1
    }
    $painelPath = if ($painelFile) { $painelFile.FullName } else { "$protDir\PAINEL_ATIVIDADES_$dataStr.md" }

    $mapa = [ordered]@{
        "1. PAINEL_ATIVIDADES"           = $painelPath
        "2. CONTEXTO_SESSAO_DIRETOR"     = "$projectDir\PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataStr.md"
        "3. WIP_BOARD.json"              = "$projectDir\CLIENTES\WIP_BOARD.json"
        "4. INTELLIGENCE_LEDGER.md"      = "$projectDir\INTELLIGENCE_LEDGER.md"
        "5. PENDENTES.md"                = "$projectDir\PENDENTES.md"
        "6. 16_VANGUARD_TIMELINE.md"     = "$projectDir\CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
        "7. MEMORIA_EMBAIXADOR_VANGUARD" = "$projectDir\CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md"
    }

    $stale  = [System.Collections.Generic.List[string]]::new()
    $linhas = [System.Collections.Generic.List[string]]::new()
    $linhas.Add("Referencia: $dataStr -- session_close BLOQUEIA se qualquer arquivo estiver STALE.")
    $linhas.Add("")

    foreach ($entry in $mapa.GetEnumerator()) {
        $lbl  = $entry.Key
        $path = $entry.Value
        if (Test-Path $path) {
            $lwt = (Get-Item $path).LastWriteTime
            $ts  = $lwt.ToString("yyyy-MM-dd HH:mm")
            if ($lwt.Date -ge $dataRef) {
                $linhas.Add(("  [OK    ] {0,-44} {1}" -f $lbl, $ts))
            } else {
                $linhas.Add(("  [STALE ] {0,-44} {1}  <<< ATUALIZAR NESTA SESSAO" -f $lbl, $ts))
                $stale.Add($lbl)
            }
        } else {
            $linhas.Add(("  [AUSENTE] {0,-44} ARQUIVO NAO ENCONTRADO" -f $lbl))
            $stale.Add($lbl)
        }
    }

    $linhas.Add("")
    if ($stale.Count -gt 0) {
        $linhas.Add("ATENCAO: $($stale.Count) arquivo(s) desatualizado(s).")
        $linhas.Add("Musculo: atualizar estes arquivos ANTES de fechar a sessao (session_close vai bloquear):")
        foreach ($s in $stale) { $linhas.Add("  >> $s") }
    } else {
        $linhas.Add("[VERDE] Todos os 7 arquivos atualizados hoje.")
    }
    return $linhas -join "`n"
}
$frescorEmbaixador = Get-FrescorEmbaixador

$sections = @()
if ($pendentesAlert)     { $sections += "## PENDENTES (P-048) - LER PRIMEIRO`n$pendentesAlert" }
if ($pendentesWatchOutput) { $sections += "## PENDENTES-WATCH (P-087) -- CONFIRMAR MARCACAO`n$pendentesWatchOutput" }
if ($estadoRealOutput)   { $sections += "## ESTADO REAL DOS PROJETOS (P-055) - VERIFICADO EM DISCO`n$estadoRealOutput" }
if ($ledger)             { $sections += "## INTELLIGENCE_LEDGER - PRINCIPIOS ATIVOS`n$ledger" }
if ($wip)                { $sections += "## WIP_BOARD - PROJETOS ATIVOS`n$wip" }
if ($socio)              { $sections += "## ANALISE DO SOCIO - CONTEXTO ATUAL`n$socio" }
if ($gateAlert)          { $sections += "## GATE ALERT - STATUS DOS PROJETOS`n$gateAlert" }
if ($embaixadorStatus)   { $sections += "## EMBAIXADOR INATIVO (RISCO C) -- ACAO NECESSARIA`n$embaixadorStatus" }
if ($checkIn)            { $sections += "## VERIFICACAO AUTONOMA (P-092) -- CONFIRMAR APENAS ACOES EXTERNAS`n$checkIn" }
if ($churnWatchStatus)   { $sections += "## CHURN-WATCH INATIVO -- ACAO DO DIRETOR NECESSARIA`n$churnWatchStatus" }
if ($formalizadorOutput) { $sections += "## FORMALIZADOR - CONFLITO COMERCIAL DETECTADO`n$formalizadorOutput" }
if ($loopGuardianOutput) { $sections += "## LOOP GUARDIAN - SAUDE DO LOOP EVOLUTIVO`n$loopGuardianOutput" }
if ($discoveryAlert)     { $sections += "## PROJETO NOVO EM DISCOVERY -- VERIFICAR ANTES DE ONBOARDING`n$discoveryAlert" }
if ($vereditosTelegramOutput) { $sections += "## VEREDITOS TELEGRAM PENDENTES (P-072) -- PROCESSAR ANTES DE QUALQUER ACAO`n$vereditosTelegramOutput" }
if ($ultimosCommits)     { $sections += "## COMMITS RECENTES (ultimos 10)`n$ultimosCommits" }
if ($buildBudgetOutput)  { $sections += "## BUILD BUDGET GUARD (P-148) -- BUILDS APROVADOS SEM INICIO`n$buildBudgetOutput" }
if ($agentsMdAlert)      { $sections += "## [CRÍTICO] AGENTS.md AUSENTE -- FIREWALL DO ANTIGRAVITY INATIVO`n$agentsMdAlert" }

# ANTIGRAVITY -- lembrete de abertura obrigatoria (P-163 / 2026-06-14)
$antigravityBlock = @(
    "PAPEL DESTA SESSAO: definir antes de abrir VS Code (padrao = ESTRATEGISTA)",
    "",
    "  Gerar prompt + clipboard:",
    "  .\scripts\ir_ao_antigravity.ps1 -papel ESTRATEGISTA -Clipboard -AbrirVSCode",
    "",
    "  Se sessao EXECUTOR  -> .\scripts\ir_ao_antigravity.ps1 -papel EXECUTOR -Clipboard",
    "  Se sessao COWORK    -> .\scripts\ir_ao_antigravity.ps1 -papel COWORK   -Clipboard",
    "",
    "REGRA P-163: @concise-planning OBRIGATORIA na abertura. Sem ela, Antigravity age sem plano.",
    "Verificar skills: .\scripts\ir_ao_antigravity.ps1 -papel ESTRATEGISTA -VerificarSkill",
    "GATILHOS completos: .agents/skills/skills.md"
) -join "`n"
$sections += "## ANTIGRAVITY -- ABRIR COM @concise-planning (P-163)`n$antigravityBlock"

if ($manifestStatus)       { $sections = @("## MANIFEST SYNC (P-071) -- ESTADO DOS DOCUMENTOS`n$manifestStatus") + $sections }
if ($frescorEmbaixador)    { $sections = @("## ⚠️ FRESCOR DOS 7 ARQUIVOS DO EMBAIXADOR (Gate 7C)`n$frescorEmbaixador") + $sections }
if ($mapaDiarioOutput)     { $sections = @("## MAPA DIARIO -- P-069 (PENDENCIAS POR DATA / TODOS OS PROJETOS)`n$mapaDiarioOutput") + $sections }
if ($pendentesVencidosP069) { $sections = @("## PENDENTES VENCIDOS (P-069) -- ATENCAO IMEDIATA`n$pendentesVencidosP069") + $sections }
if ($decisoesPendentes) { $sections = @("## DECISOES PENDENTES -- AGENDA BLOQUEADA ATE VEREDITO`n$decisoesPendentes") + $sections }
if ($loopLembrete)      { $sections = @("## LEMBRETE DE LOOP -- FASES ATIVAS (P-077)`n$loopLembrete") + $sections }
if ($documentosMortos)  { $sections = @("## DOCUMENTOS MORTOS (P-113) -- VARREDURA AUTOMATICA`n$documentosMortos") + $sections }
if ($syncGuardOutput)   { $sections = @("## SYNC_GUARD (P-033) -- DIVERGENCIAS DE DOCUMENTOS CANONICOS`n$syncGuardOutput") + $sections }
if ($stateGuardOutput)  { $sections = @("## STATE_GUARD V28 -- ANOMALIAS NO WIP_BOARD`n$stateGuardOutput") + $sections }

# CONTEXTO SESSAO DIRETOR -- segunda secao (logo apos BLOCO 0, nunca truncada)
if ($contextoSessao)    { $sections = @("## CONTEXTO DA ULTIMA SESSAO (MEMORIA CONVERSACIONAL)`n$contextoSessao") + $sections }

# NOTION (2026-06-08) -- leitura OBRIGATORIA toda sessao, rodada em PARALELO (#3, 2026-06-09).
#   inbox: Diretor escreve em "Falhas do Dia" + "Sugestoes do Dia"; Musculo le e marca [PROCESSADO].
#   pull : Diretor marca [x] no Notion (so itens [diretor]); Musculo quita o PENDENTES.md.
# Paralelo + teto de 12s: latencia = max(inbox,pull) em vez da soma. Degrada gracioso:
# qualquer falha/timeout -> secao omitida, PENDENTES.md local intacto (fonte canonica, P-110).
$notionInbox = $null
$notionPull  = $null
try {
    $scriptsDir  = Join-Path $projectDir "scripts"
    $inboxScript = Join-Path $scriptsDir "notion_inbox.ps1"
    $pullScript  = Join-Path $scriptsDir "notion_pendentes_pull.ps1"
    $sb   = { param($s) (& $s 2>$null | Out-String) }   # chamada direta no runspace do job (sem powershell.exe aninhado -- ~40% mais rapido)
    $jobs = @()
    if (Test-Path $inboxScript) { $jobs += @{ nome = 'inbox'; job = (Start-Job -ScriptBlock $sb -ArgumentList $inboxScript) } }
    if (Test-Path $pullScript)  { $jobs += @{ nome = 'pull';  job = (Start-Job -ScriptBlock $sb -ArgumentList $pullScript) } }
    if ($jobs.Count -gt 0) {
        $todos = $jobs | ForEach-Object { $_.job }
        $null  = Wait-Job -Job $todos -Timeout 12
        foreach ($j in $jobs) {
            if ($j.job.State -eq 'Completed') {
                $out = (Receive-Job -Job $j.job 2>$null | Out-String).Trim()
                if ($j.nome -eq 'inbox') { $notionInbox = $out } else { $notionPull = $out }
            }
        }
        $todos | Remove-Job -Force -ErrorAction SilentlyContinue
    }
} catch { $notionInbox = $null; $notionPull = $null }
# PASSO 0.5 -- FIREWALL PENTALATERAL: lembrete nao-bloqueante de arquivos R-01 protegidos
$firewallPath = Join-Path $projectDir ".agents\skills\pentalateral-firewall.md"
$p05Lines = @("PASSO 0.5 -- FIREWALL PENTALATERAL (lembrete nao-bloqueante)", "")
if (Test-Path $firewallPath) {
    $p05Lines += "Firewall ATIVO. Arquivos R-01 protegidos nesta sessao:"
    $p05Lines += "  -> INTELLIGENCE_LEDGER.md / PENDENTES.md / WIP_BOARD.json / DEPENDENCY_MAP.json"
    $p05Lines += "  -> CLAUDE.md / GEMINI.md / AGENTS.md / PENTALATERAL_UNIVERSAL/** / .claude/skills/vanguard-*.md"
    $p05Lines += ""
    $p05Lines += "[AVISO AMARELO] Edicao em R-01 sem veredito do Diretor = violacao imediata."
} else {
    $p05Lines += "[ATENCAO] .agents/skills/pentalateral-firewall.md ausente -- verificar repositorio."
}
$passo05 = $p05Lines -join "`n"
$sections = @("## [PASSO 0.5] FIREWALL PENTALATERAL`n$passo05") + $sections

# GATE PASSO 0 -- audit trail de flags do dia (P-158 / 2026-06-13)
$gatePasso0Status = ""
$gateScript = Join-Path $projectDir "scripts\gate_passo0_abertura.ps1"
if (Test-Path $gateScript) {
    try {
        $gateLines = (& powershell.exe -NonInteractive -File $gateScript -Status 2>$null)
        if ($gateLines) { $gatePasso0Status = ($gateLines | Where-Object { $_ -ne $null }) -join "`n" }
    } catch {}
}

# PASSO 0C -- CALENDARIO COWORK (prepend antes do 0B: aparece apos 0B na saida)
$calendarioOutput = ""
if (Test-Path $gateScript) {
    try {
        $calLines = (& powershell.exe -NonInteractive -File $gateScript -ConsultarCalendario 2>$null)
        if ($calLines) { $calendarioOutput = ($calLines | Where-Object { $_ -ne $null }) -join "`n" }
    } catch {}
}
if ($calendarioOutput) {
    $sections = @("## 📅 PASSO 0C -- CALENDARIO COWORK (analisar e decidir SIM/NAO com Diretor)`n$calendarioOutput") + $sections
}

# PASSO 0B -- COWORK (prepend 1o: aparece 3o na saida, apos BLOCO0 e NOTION)
$coworkFooter = if ($gatePasso0Status) { "`n`n---`n[GATE P-158] STATUS HOJE:`n$gatePasso0Status" } else { "" }
$sections = @("## ⚡ PASSO 0B -- COWORK DO EMBAIXADOR (MCP Google Drive) -- APOS BLOCO 0 E NOTION`n$colheitaCowork$coworkFooter") + $sections

# NOTION (prepend 2o: aparece 2o na saida, logo apos BLOCO 0)
if ($notionInbox) {
    $notionFooter = "`n`nApos processar Falhas+Sugestoes: & '.\scripts\gate_passo0_abertura.ps1' -MarcarNotion"
    $sections = @("## ⚠️  PASSO 0A -- NOTION INBOX DO DIRETOR (Falhas + Sugestoes) -- APOS BLOCO 0`n$notionInbox$notionFooter") + $sections
}
if ($notionPull)  { $sections = @("## NOTION -> PENDENTES (Diretor quitou itens [diretor] no Notion)`n$notionPull") + $sections }

# BLOCO 0 -- prepend POR ULTIMO = aparece PRIMEIRO na saida (P-114 + P-158 / 2026-06-13)
$bloco0Alert = @(
    "SEQUENCIA OBRIGATORIA DE ABERTURA (P-114 + P-158):",
    "",
    "  [PASSO 0 ] BLOCO 0  -- VOCE ESTA AQUI. Processar o BLOCO 0 colado pelo Diretor.",
    "  [PASSO 0A] NOTION   -- apos BLOCO 0: ler Falhas+Sugestoes via MCP Notion. Marcar -MarcarNotion.",
    "  [PASSO 0B] COWORK   -- apos NOTION: ler Drive INBOX_COWORK via MCP Google Drive. Marcar -MarcarCowork.",
    "  [PASSO 0C] CALENDARIO -- apos COWORK: consultar CALENDARIO_NICHE_INTELLIGENCE -- ver abaixo. Marcar -MarcarCalendario.",
    "  [PASSO 1+] CONTINUAR -- somente apos 0+0A+0B+0C: apresentar PENDENTES, WIP, MAPA DIARIO.",
    "",
    "  Se Diretor NAO colou BLOCO 0 -> dizer EXATAMENTE:",
    "    'Diretor, cole aqui o BLOCO 0 do Embaixador da sessao anterior antes de continuarmos.'",
    "  Aguardar BLOCO 0 ou confirmacao de indisponibilidade.",
    "",
    "  FALLBACK (somente apos confirmacao do Diretor de que nao esta disponivel):",
    "  Ler: PROTOCOLOS_ENCERRAMENTO/CONTEXTO_SESSAO_DIRETOR_[data mais recente].md",
    "",
    "  ⛔ Musculo que pula para PENDENTES/WIP sem executar 0A+0B+0C = P-158 VIOLADO (DEF-M-6).",
    "  Marcar gates apos cada etapa: scripts\gate_passo0_abertura.ps1 -MarcarNotion / -MarcarCowork / -MarcarCalendario"
) -join "`n"
$sections = @("## ⚠️  BLOCO 0 DO EMBAIXADOR (P-114) -- PRIMEIRA ACAO OBRIGATORIA`n$bloco0Alert") + $sections

# ATO 6 -- Iniciar watch_readonly.ps1 em background (P-033 guardian)
$watchScript = Join-Path $projectDir "scripts\watch_readonly.ps1"
$watchPidFile = Join-Path $projectDir "scripts\.watch_readonly.pid"
if ((Test-Path $watchScript) -and (-not (Test-Path $watchPidFile))) {
    try {
        Start-Process powershell.exe `
            -ArgumentList "-NonInteractive -WindowStyle Hidden -File `"$watchScript`"" `
            -WindowStyle Hidden -ErrorAction SilentlyContinue
    } catch {}
}

if ($sections.Count -eq 0) { exit 0 }

$context = "=== PENTALATERAL IAH - INSTRUMENTOS DE MEMORIA (auto-injetados) ===`n`n" +
           ($sections -join "`n`n---`n`n")

$output = [ordered]@{
    hookSpecificOutput = [ordered]@{
        hookEventName     = "SessionStart"
        additionalContext = $context
    }
} | ConvertTo-Json -Depth 5 -Compress

Write-Output $output
exit 0
