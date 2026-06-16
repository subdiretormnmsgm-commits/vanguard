# yt.ps1 -- wrapper da skill yt-search (P-173)
# Roda a busca real no YouTube e REGISTRA a invocacao em scripts/yt_search.log.
# O gate_yt_search.ps1 le este log para confirmar que houve pesquisa viva.
# Uso: .\scripts\yt.ps1 "<query do tema>" [--count N] [--months N]
param(
    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
    [string[]]$Rest
)
$ErrorActionPreference = "Stop"

$script = Join-Path $env:USERPROFILE ".claude\skills\yt-search\scripts\search.py"
if (-not (Test-Path $script)) {
    Write-Host "ERRO: search.py nao encontrado em $script -- instalar conforme YT-SEARCH CLAUDE SKILL.md" -ForegroundColor Red
    exit 1
}

$log = Join-Path $PSScriptRoot "yt_search.log"
$query = ($Rest -join " ")
$stamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

python $script @Rest
$code = $LASTEXITCODE

Add-Content -Path $log -Value "$stamp | exit=$code | $query" -Encoding utf8
exit $code
