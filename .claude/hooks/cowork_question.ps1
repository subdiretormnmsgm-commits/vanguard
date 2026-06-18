# SCRIPT: cowork_question.ps1
# Uso: powershell -File .claude/hooks/cowork_question.ps1 -pergunta "Sua pergunta aqui"
# Grava uma pergunta no _cowork_bridge.json para o Cowork apresentar ao Diretor

param(
    [Parameter(Mandatory=$true)]
    [string]$pergunta
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$bridgeFile  = Join-Path $projectDir "_cowork_bridge.json"
$timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$id          = "q-" + (Get-Date -Format "yyyyMMdd-HHmmss")

# Ler bridge existente (ou criar estrutura mínima)
if (Test-Path $bridgeFile) {
    $raw    = Get-Content $bridgeFile -Raw -Encoding UTF8
    $bridge = $raw | ConvertFrom-Json
} else {
    $bridge = [PSCustomObject]@{
        timestamp       = $timestamp
        evento          = "Question"
        loop_atual      = $null
        gates_pendentes = @()
        pendentes       = @()
        ultimos_commits = @()
        lido_pelo_cowork = $true
        pergunta_pendente = $null
    }
}

# Adicionar/substituir pergunta_pendente
$pq = [PSCustomObject]@{
    id         = $id
    timestamp  = $timestamp
    pergunta   = $pergunta
    respondida = $false
    resposta   = $null
}

# Adicionar ou sobrescrever campo pergunta_pendente
$bridge | Add-Member -NotePropertyName "pergunta_pendente" -NotePropertyValue $pq -Force
$bridge | Add-Member -NotePropertyName "evento"           -NotePropertyValue "Question" -Force
$bridge | Add-Member -NotePropertyName "lido_pelo_cowork" -NotePropertyValue $false -Force

$json = $bridge | ConvertTo-Json -Depth 6
[System.IO.File]::WriteAllText($bridgeFile, $json, [System.Text.Encoding]::UTF8)

Write-Host "COWORK_QUESTION_ENVIADA: $pergunta"
exit 0
