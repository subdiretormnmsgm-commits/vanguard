#Requires -Version 5.1
# send_telegram_helper.ps1 -- Helper compartilhado: funcao Send-Telegram
# Dot-source este arquivo para usar Send-Telegram em qualquer script.
# Uso: . "$BASE\scripts\send_telegram_helper.ps1"
#      Send-Telegram "mensagem aqui"
# Credenciais: scripts\alert_config.ps1 (nunca recriar token sem instrucao do Diretor -- P-017)

# Carregar credenciais
$_helperBase = Split-Path -Parent $PSScriptRoot
if (-not $TELEGRAM_TOKEN) {
    $alertCfg = "$_helperBase\scripts\alert_config.ps1"
    if (Test-Path $alertCfg) { . $alertCfg }
}

function Send-Telegram {
    param([string]$Texto, [int]$MaxChars = 4096)
    if ([string]::IsNullOrWhiteSpace($Texto)) { return 0 }
    if (-not $TELEGRAM_TOKEN -or -not $TELEGRAM_CHAT_ID) {
        Write-Host "  [TELEGRAM] Credenciais nao encontradas -- verificar alert_config.ps1" -ForegroundColor Yellow
        return 0
    }
    $url   = "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage"
    $partes = 0
    $inicio = 0
    while ($inicio -lt $Texto.Length) {
        $bloco = $Texto.Substring($inicio, [Math]::Min($MaxChars, $Texto.Length - $inicio))
        try {
            $body = @{ chat_id = $TELEGRAM_CHAT_ID; text = $bloco }
            Invoke-RestMethod -Uri $url -Method Post -Body $body -TimeoutSec 10 | Out-Null
            $partes++
        } catch {
            Write-Host "  [TELEGRAM] Falha ao enviar parte $($partes + 1): $($_.Exception.Message)" -ForegroundColor Red
        }
        $inicio += $MaxChars
    }
    return $partes
}
