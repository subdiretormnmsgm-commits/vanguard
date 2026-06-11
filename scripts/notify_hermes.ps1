# ============================================================
# NOTIFY_HERMES.PS1 -- Canal de notificacao Hermes/Telegram
# Pentalateral IAH -- ATO 6 - Loop 33 - 2026-06-11
#
# Uso:
#   .\scripts\notify_hermes.ps1 -status CRITICO -mensagem "R-01 violado" -projeto VANGUARD
#   .\scripts\notify_hermes.ps1 -status AVISO -mensagem "build iniciado"
#   .\scripts\notify_hermes.ps1 -flush          # envia buffer acumulado
#
# Frequencia por status:
#   CRITICO : imediato, sem dedup
#   ALERTA  : dedup 30min (nao repete em 30min)
#   AVISO   : acumula buffer -- enviado via -flush no session_close
#   INFO    : acumula buffer -- enviado via -flush no session_close
# ============================================================

param(
    [string]$status   = "",
    [string]$mensagem = "",
    [string]$projeto  = "VANGUARD",
    [switch]$flush
)

$BASE        = Split-Path -Parent $PSScriptRoot
$configPath  = Join-Path $BASE "scripts\alert_config.ps1"
$dedup30     = Join-Path $BASE "scripts\.notify_dedup_30.flag"
$bufferPath  = Join-Path $BASE "scripts\.notify_buffer.txt"
$enc         = [System.Text.UTF8Encoding]::new($false)

if (-not (Test-Path $configPath)) {
    Write-Host "[notify_hermes] ERRO: alert_config.ps1 nao encontrado"
    exit 1
}
. $configPath

function Send-Telegram {
    param([string]$text)
    $url  = "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage"
    $body = @{ chat_id = $TELEGRAM_CHAT_ID; text = $text } | ConvertTo-Json -Compress
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
        $r = Invoke-RestMethod -Uri $url -Method POST -Body $bytes -ContentType "application/json; charset=utf-8"
        return $r.ok
    } catch {
        Write-Host "[notify_hermes] ERRO Telegram: $($_.Exception.Message)"
        return $false
    }
}

function Get-StatusLabel {
    param([string]$s)
    switch ($s.ToUpper()) {
        "CRITICO" { return "[!! CRITICO !!]" }
        "ALERTA"  { return "[ALERTA]" }
        "AVISO"   { return "[AVISO]" }
        "INFO"    { return "[INFO]" }
        default   { return "[INFO]" }
    }
}

# -- MODO FLUSH: enviar tudo que esta no buffer ---------------
if ($flush) {
    if (-not (Test-Path $bufferPath)) {
        Write-Host "[notify_hermes] Buffer vazio -- nada a enviar."
        exit 0
    }
    $bufContent = [System.IO.File]::ReadAllText($bufferPath, [System.Text.Encoding]::UTF8).Trim()
    if ($bufContent -eq "") {
        Write-Host "[notify_hermes] Buffer vazio -- nada a enviar."
        Remove-Item $bufferPath -Force -ErrorAction SilentlyContinue
        exit 0
    }
    $texto = "=== Pentalateral IAH -- Resumo Sessao ===`n$bufContent`n=== FIM ==="
    $ok = Send-Telegram -text $texto
    if ($ok) {
        Remove-Item $bufferPath -Force -ErrorAction SilentlyContinue
        Write-Host "[notify_hermes] Buffer enviado e limpo."
    }
    exit 0
}

# -- MODO NOTIFICACAO -----------------------------------------
if ($mensagem -eq "" -or $status -eq "") {
    Write-Host "[notify_hermes] Uso: -status [CRITICO|ALERTA|AVISO|INFO] -mensagem <texto> [-projeto <nome>]"
    Write-Host "                     -flush (envia buffer acumulado)"
    exit 1
}

$label         = Get-StatusLabel -s $status
$agora         = Get-Date
$header        = "$label [$projeto] $($agora.ToString('HH:mm'))"
$textoCompleto = "$header`n$mensagem"

switch ($status.ToUpper()) {

    "CRITICO" {
        $ok = Send-Telegram -text $textoCompleto
        if ($ok) { Write-Host "[notify_hermes] CRITICO enviado ao Telegram." }
    }

    "ALERTA" {
        $enviar = $true
        if (Test-Path $dedup30) {
            try {
                $ultimaStr = [System.IO.File]::ReadAllText($dedup30, [System.Text.Encoding]::UTF8).Trim()
                $ultima    = [datetime]$ultimaStr
                $diffMin   = ($agora - $ultima).TotalMinutes
                if ($diffMin -lt 30) {
                    Write-Host "[notify_hermes] ALERTA dedup -- ultimo ha $([Math]::Round($diffMin))min (< 30min). Suprimido."
                    $enviar = $false
                }
            } catch {}
        }
        if ($enviar) {
            $ok = Send-Telegram -text $textoCompleto
            if ($ok) {
                [System.IO.File]::WriteAllText($dedup30, $agora.ToString("o"), $enc)
                Write-Host "[notify_hermes] ALERTA enviado ao Telegram."
            }
        }
    }

    { $_ -in "AVISO","INFO" } {
        $linhaEol = "$textoCompleto`n"
        if (Test-Path $bufferPath) {
            $existente = [System.IO.File]::ReadAllText($bufferPath, [System.Text.Encoding]::UTF8)
            [System.IO.File]::WriteAllText($bufferPath, $existente + $linhaEol, $enc)
        } else {
            [System.IO.File]::WriteAllText($bufferPath, $linhaEol, $enc)
        }
        Write-Host "[notify_hermes] $status adicionado ao buffer (sera enviado no session_close via -flush)."
    }

    default {
        Write-Host "[notify_hermes] Status invalido: '$status'. Use CRITICO|ALERTA|AVISO|INFO."
        exit 1
    }
}
