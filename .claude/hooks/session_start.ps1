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

# --- Check-In integrado: lista gates pendentes para o Musculo perguntar ao Diretor ---
function Get-CheckInPrompt {
    $wipPath = Join-Path $projectDir "CLIENTES\WIP_BOARD.json"
    if (-not (Test-Path $wipPath)) { return $null }
    $board    = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $projetos = @($board.board.build)
    if ($projetos.Count -eq 0) { return $null }
    $hoje       = Get-Date
    $pendentes  = @()
    foreach ($proj in $projetos) {
        if (-not $proj.gates_bloqueantes) { continue }
        $inicio = if ($proj.build_iniciado_em) { [datetime]::Parse($proj.build_iniciado_em) } else { $hoje }
        $gates  = $proj.gates_bloqueantes | Get-Member -MemberType NoteProperty |
                  Select-Object -ExpandProperty Name |
                  Sort-Object { [int]($_ -replace '\D', '') }
        foreach ($g in $gates) {
            $num  = [int]($g -replace '\D', '')
            $gateDate = $inicio.AddDays($num - 1)
            if ($gateDate.Date -gt $hoje.Date) { continue }  # nao venceu ainda
            $concluido = $false
            if ($proj.dias_completos) {
                foreach ($d in $proj.dias_completos) {
                    if ($d -match "^dia$num") { $concluido = $true; break }
                }
            }
            if (-not $concluido) {
                $pendentes += "  [$($proj.id)/$($proj.cliente)] Gate $g ($($gateDate.ToString('dd/MM'))): $($proj.gates_bloqueantes.$g)"
            }
        }
    }
    if ($pendentes.Count -eq 0) { return $null }
    $linhas = @(
        "CHECK-IN OBRIGATORIO — $(Get-Date -Format 'yyyy-MM-dd')",
        "Os gates abaixo constam como PENDENTES no WIP_BOARD.",
        "Antes de declarar o estado de qualquer projeto, o Musculo DEVE perguntar:",
        "  'Algum destes gates foi concluido offline desde a ultima sessao?'",
        "Atualizar WIP_BOARD somente apos confirmacao explicita do Diretor.",
        ""
    )
    $linhas += $pendentes
    return $linhas -join "`n"
}

$checkIn = Get-CheckInPrompt

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

$sections = @()
if ($pendentesAlert)     { $sections += "## PENDENTES (P-048) - LER PRIMEIRO`n$pendentesAlert" }
if ($estadoRealOutput)   { $sections += "## ESTADO REAL DOS PROJETOS (P-055) - VERIFICADO EM DISCO`n$estadoRealOutput" }
if ($ledger)             { $sections += "## INTELLIGENCE_LEDGER - PRINCIPIOS ATIVOS`n$ledger" }
if ($wip)                { $sections += "## WIP_BOARD - PROJETOS ATIVOS`n$wip" }
if ($socio)              { $sections += "## ANALISE DO SOCIO - CONTEXTO ATUAL`n$socio" }
if ($gateAlert)          { $sections += "## GATE ALERT - STATUS DOS PROJETOS`n$gateAlert" }
if ($checkIn)            { $sections += "## CHECK-IN OBRIGATORIO - PERGUNTAR AO DIRETOR`n$checkIn" }
if ($formalizadorOutput) { $sections += "## FORMALIZADOR - CONFLITO COMERCIAL DETECTADO`n$formalizadorOutput" }
if ($loopGuardianOutput) { $sections += "## LOOP GUARDIAN - SAUDE DO LOOP EVOLUTIVO`n$loopGuardianOutput" }

if ($mapaDiarioOutput) { $sections = @("## MAPA DIARIO — P-069 (PENDENCIAS POR DATA / TODOS OS PROJETOS)`n$mapaDiarioOutput") + $sections }
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
