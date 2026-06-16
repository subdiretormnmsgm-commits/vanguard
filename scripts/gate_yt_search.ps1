# gate_yt_search.ps1 -- P-173
# Bloqueia pesquisa/sintese do Musculo sem invocacao previa da skill yt-search.
# exit 0 = ha invocacao recente (VERDE) | exit 1 = nenhuma (BLOQUEIO).
# Uso: .\scripts\gate_yt_search.ps1 [-Horas N]   (default 24h)
param([int]$Horas = 24)

$log = Join-Path $PSScriptRoot "yt_search.log"
if (-not (Test-Path $log)) {
    Write-Host "[GATE YT] BLOQUEIO -- yt_search.log inexistente. Rode  .\scripts\yt.ps1 ""<query do tema>""  antes de pesquisar/sintetizar. (P-173)" -ForegroundColor Red
    exit 1
}

$limite = (Get-Date).AddHours(-$Horas)
$recente = $false
foreach ($linha in Get-Content $log) {
    $parts = $linha.Split("|")
    if ($parts.Count -ge 1) {
        $dt = [datetime]::MinValue
        if ([datetime]::TryParse($parts[0].Trim(), [ref]$dt)) {
            if ($dt -ge $limite) { $recente = $true; break }
        }
    }
}

if ($recente) {
    Write-Host "[GATE YT] VERDE -- yt-search invocada nas ultimas $Horas h. (P-173)" -ForegroundColor Green
    exit 0
}
else {
    Write-Host "[GATE YT] BLOQUEIO -- nenhuma invocacao de yt-search nas ultimas $Horas h. Rode  .\scripts\yt.ps1 ""<query>""  antes de pesquisar/sintetizar. (P-173)" -ForegroundColor Red
    exit 1
}
