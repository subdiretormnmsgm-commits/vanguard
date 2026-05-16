# HOOK: SessionStart
# Protege contra: Amnesia de Sessao do Musculo (Deficiencia 1)
# Injeta automaticamente os instrumentos de memoria do Quadrilateral IAH

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

# --- Gargalo Ping silencioso (dispara e-mail se Diretor estiver bloqueando) ---
$pingScript = Join-Path $projectDir "scripts\gargalo_ping.ps1"
if (Test-Path $pingScript) {
    try { & $pingScript 2>$null | Out-Null } catch {}
}

# --- Gemini Anchor silencioso (CONTEXTO_GEMINI.md sempre atualizado) ---
$anchorScript = Join-Path $projectDir "scripts\gemini_anchor_generator.ps1"
if (Test-Path $anchorScript) {
    try { & powershell.exe -NonInteractive -File $anchorScript 2>$null | Out-Null } catch {}
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

$sections = @()
if ($ledger)             { $sections += "## INTELLIGENCE_LEDGER - PRINCIPIOS ATIVOS`n$ledger" }
if ($wip)                { $sections += "## WIP_BOARD - PROJETOS ATIVOS`n$wip" }
if ($socio)              { $sections += "## ANALISE DO SOCIO - CONTEXTO ATUAL`n$socio" }
if ($gateAlert)          { $sections += "## GATE ALERT - STATUS DOS PROJETOS`n$gateAlert" }
if ($loopGuardianOutput) { $sections += "## LOOP GUARDIAN - SAUDE DO LOOP EVOLUTIVO`n$loopGuardianOutput" }

if ($sections.Count -eq 0) { exit 0 }

$context = "=== QUADRILATERAL IAH - INSTRUMENTOS DE MEMORIA (auto-injetados) ===`n`n" +
           ($sections -join "`n`n---`n`n")

$output = [ordered]@{
    hookSpecificOutput = [ordered]@{
        hookEventName     = "SessionStart"
        additionalContext = $context
    }
} | ConvertTo-Json -Depth 5 -Compress

Write-Output $output
exit 0
