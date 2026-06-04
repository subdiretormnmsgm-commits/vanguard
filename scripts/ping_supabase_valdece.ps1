# ping_supabase_valdece.ps1
# Mantém projeto Supabase Valdece ativo -- previne pausa por inatividade (free tier)
# Agendado a cada 5 dias via registrar_ping_valdece.ps1

$SUPABASE_URL  = 'https://hqqxzecftkvtrlpkhvnc.supabase.co'
$SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxcXh6ZWNmdGt2dHJscGtodm5jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxMzg5NjYsImV4cCI6MjA5NDcxNDk2Nn0.AFWbk2oi7zKDu7Q922CqS-cc-pG_VJNYMqqH2BeouxA'

$LOG   = "$PSScriptRoot\ping_valdece.log"
$DATA  = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

$TELEGRAM_TOKEN = $env:TELEGRAM_TOKEN
$TELEGRAM_CHAT  = $env:TELEGRAM_CHAT_ID

function Send-TelegramAlerta {
    param($msg)
    if (-not $TELEGRAM_TOKEN) { return }
    try {
        $url  = 'https://api.telegram.org/bot' + $TELEGRAM_TOKEN + '/sendMessage'
        $body = '{"chat_id":"' + $TELEGRAM_CHAT + '","text":"' + $msg + '"}'
        Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType 'application/json' | Out-Null
    } catch {}
}

try {
    $headers = @{
        'apikey'        = $SUPABASE_ANON
        'Authorization' = 'Bearer ' + $SUPABASE_ANON
        'Content-Type'  = 'application/json'
    }

    $response = Invoke-RestMethod `
        -Uri ($SUPABASE_URL + '/rest/v1/documents?select=id&limit=1') `
        -Headers $headers `
        -Method Get `
        -TimeoutSec 15 `
        -ErrorAction Stop

    $count   = ($response | Measure-Object).Count
    $detalhe = 'Projeto ativo -- ' + $count + ' documento(s) retornado(s)'
    Add-Content -Path $LOG -Value ('[' + $DATA + '] VERDE -- ' + $detalhe)
    Write-Host ('[' + $DATA + '] PING OK -- ' + $detalhe)

} catch {
    $detalhe = $_.Exception.Message
    Add-Content -Path $LOG -Value ('[' + $DATA + '] VERMELHO -- FALHA: ' + $detalhe)
    Write-Host ('[' + $DATA + '] PING FALHOU -- ' + $detalhe)

    $msg = 'ALERTA VALDECE -- Supabase nao respondeu. Data: ' + $DATA + '. Erro: ' + $detalhe + '. Acesse supabase.com e verifique se o projeto esta pausado.'
    Send-TelegramAlerta $msg
    exit 1
}
