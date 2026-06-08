# ============================================================
# EMAIL_FECHAMENTO.PS1 — Envia e-mail de fechamento de sessão
# Acionado pelo Músculo ao fechar qualquer sessão do Pentalateral
# Uso: .\scripts\email_fechamento.ps1
# Lê o corpo do e-mail de scripts\.email_body.txt (gerado pelo Músculo)
# ============================================================

$BASE = Split-Path -Parent $PSScriptRoot
. "$BASE\scripts\alert_config.ps1"

$bodyFile = "$BASE\scripts\.email_body.txt"

if (-not (Test-Path $bodyFile)) {
    Write-Host "ERRO: arquivo de corpo do e-mail não encontrado em scripts\.email_body.txt" -ForegroundColor Red
    exit 1
}

$corpo  = Get-Content $bodyFile -Raw -Encoding UTF8
$linhas = $corpo -split "`n"
$assunto = ($linhas | Where-Object { $_ -match "^\*\*Assunto:" } | Select-Object -First 1) -replace "\*\*Assunto:\*\* ", ""

if (-not $assunto) {
    $assunto = "Pentalateral IAH - Fechamento de Sessao $(Get-Date -Format 'yyyy-MM-dd')"
}

try {
    $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)

    $msg = New-Object Net.Mail.MailMessage
    $msg.From              = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject           = $assunto
    $msg.SubjectEncoding   = [System.Text.Encoding]::UTF8
    $msg.IsBodyHtml        = $false

    # AlternateView garante Content-Type: text/plain; charset=utf-8
    # com Content-Transfer-Encoding: quoted-printable (compativel com todos os clientes)
    $view = [System.Net.Mail.AlternateView]::CreateAlternateViewFromString(
        $corpo,
        [System.Text.Encoding]::UTF8,
        "text/plain"
    )
    $view.TransferEncoding = [System.Net.Mime.TransferEncoding]::QuotedPrintable
    $msg.AlternateViews.Add($view)

    $smtp.Send($msg)
    Write-Host "✅ E-mail de fechamento enviado para $ALERT_TO" -ForegroundColor Green

    # Flag de confirmacao -- session_close verifica este arquivo para saber se email foi enviado
    $flagPath = Join-Path $PSScriptRoot ".email_sent_$(Get-Date -Format 'yyyy-MM-dd').flag"
    Set-Content -Path $flagPath -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss") -Encoding UTF8

    # Limpa o arquivo temporário após envio
    Remove-Item $bodyFile -Force
} catch {
    Write-Host "❌ ERRO ao enviar e-mail: $($_.Exception.Message)" -ForegroundColor Red
}
