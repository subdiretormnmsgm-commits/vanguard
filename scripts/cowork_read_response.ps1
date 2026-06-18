# SCRIPT: cowork_read_response.ps1
# Uso: powershell -File scripts/cowork_read_response.ps1
#
# Saidas possiveis:
#   exit 0  + "RESPOSTA_DISPONIVEL\n<texto da resposta>"  → resposta lida e campo limpo
#   exit 1  + "AGUARDANDO_RESPOSTA"                       → pergunta enviada, Diretor ainda nao respondeu
#   exit 2  + "SEM_PERGUNTA_PENDENTE"                     → nenhuma pergunta em aberto
#   exit 3  + "BRIDGE_AUSENTE"                            → arquivo nao existe

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$bridgeFile = Join-Path (Join-Path $PSScriptRoot "..") "_cowork_bridge.json"
$bridgeFile = [System.IO.Path]::GetFullPath($bridgeFile)

if (-not (Test-Path $bridgeFile)) {
    Write-Host "BRIDGE_AUSENTE"
    exit 3
}

$bridge = Get-Content $bridgeFile -Raw -Encoding UTF8 | ConvertFrom-Json

if ($null -eq $bridge.pergunta_pendente) {
    Write-Host "SEM_PERGUNTA_PENDENTE"
    exit 2
}

if ($bridge.pergunta_pendente.respondida -eq $false) {
    Write-Host "AGUARDANDO_RESPOSTA"
    Write-Host "Pergunta enviada: $($bridge.pergunta_pendente.pergunta)"
    Write-Host "Timestamp: $($bridge.pergunta_pendente.timestamp)"
    exit 1
}

# Resposta disponivel — entregar e limpar
$resposta = $bridge.pergunta_pendente.resposta
Write-Host "RESPOSTA_DISPONIVEL"
Write-Host $resposta

# Limpar pergunta_pendente do bridge
$bridge | Add-Member -NotePropertyName "pergunta_pendente" -NotePropertyValue $null -Force
$bridge | Add-Member -NotePropertyName "evento" -NotePropertyValue "ResponseRead" -Force

$json = $bridge | ConvertTo-Json -Depth 6
[System.IO.File]::WriteAllText($bridgeFile, $json, [System.Text.Encoding]::UTF8)

exit 0
