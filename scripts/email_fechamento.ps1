# ============================================================
# EMAIL_FECHAMENTO.PS1 — Envia e-mail de fechamento de sessão
# Acionado pelo Músculo ao fechar qualquer sessão do Quadrilateral
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
    $assunto = "Quadrilateral IAH - Fechamento de Sessao $(Get-Date -Format 'yyyy-MM-dd')"
}

try {
    $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)

    $msg = New-Object Net.Mail.MailMessage
    $msg.From    = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject = $assunto
    $msg.Body    = $corpo
    $msg.BodyEncoding = [System.Text.Encoding]::UTF8

    $smtp.Send($msg)
    Write-Host "✅ E-mail de fechamento enviado para $ALERT_TO" -ForegroundColor Green

    # Limpa o arquivo temporário após envio
    Remove-Item $bodyFile -Force
} catch {
    Write-Host "❌ ERRO ao enviar e-mail: $($_.Exception.Message)" -ForegroundColor Red
}
