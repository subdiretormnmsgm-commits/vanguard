# HOOK: cowork_notify
# Funcao: escreve _cowork_bridge.json na raiz do projeto quando a sessao encerra
# O Cowork le esse arquivo via tarefa agendada e notifica o Diretor

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$bridgeFile = Join-Path $projectDir "_cowork_bridge.json"

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$loop      = "?"
$gatesPend = @()
$pendentes = @()
$commits   = @()

try {
    $cl = & git -C $projectDir log --oneline -5 2>$null
    if ($cl) { $commits = @($cl) }
} catch {}

$wipPath = Join-Path $projectDir "CLIENTES\WIP_BOARD.json"
if (Test-Path $wipPath) {
    try {
        $wip  = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $proj = @($wip.board.build) | Select-Object -First 1
        if ($proj -and $proj.loop_fase_atual) {
            $loop = $proj.loop_fase_atual.loop
            foreach ($socio in @("gemini","notebooklm","embaixador","musculo")) {
                $st = $proj.loop_fase_atual.$socio
                if ($st -ne "OK") { $gatesPend += "$socio=$st" }
            }
        }
    } catch {}
}

$pendPath = Join-Path $projectDir "PENDENTES.md"
if (Test-Path $pendPath) {
    try {
        $linhas = Get-Content $pendPath -Encoding UTF8 -ErrorAction SilentlyContinue
        foreach ($l in $linhas) {
            if ($l -match '^\s*- \[ \]') {
                $titulo = $l -replace '^\s*- \[ \]\s*`[^`]+`\s*', '' -replace '\*\*([^*]+)\*\*', '$1'
                $pendentes += $titulo.Trim()
                if ($pendentes.Count -ge 5) { break }
            }
        }
    } catch {}
}

$payload = [ordered]@{
    timestamp        = $timestamp
    evento           = "SessionStop"
    loop_atual       = $loop
    gates_pendentes  = $gatesPend
    pendentes        = $pendentes
    ultimos_commits  = $commits
    lido_pelo_cowork = $false
}

try {
    $json = $payload | ConvertTo-Json -Depth 5
    [System.IO.File]::WriteAllText($bridgeFile, $json, [System.Text.Encoding]::UTF8)
} catch {}

$output = [ordered]@{
    hookSpecificOutput = [ordered]@{
        hookEventName = "Stop"
        systemMessage = "[COWORK] Notificacao gravada em _cowork_bridge.json"
    }
} | ConvertTo-Json -Depth 3 -Compress

Write-Output $output
exit 0
