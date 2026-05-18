# Teste de confirmacao do sistema de alertas
$BASE = Split-Path -Parent $PSScriptRoot
. "$BASE\scripts\alert_config.ps1"

$assunto = "Quadrilateral IAH - Sistema de Alertas ATIVO"

$corpo = "QUADRILATERAL IAH - CONFIRMACAO DO SISTEMA`r`n"
$corpo += "==========================================`r`n`r`n"
$corpo += "Diretor Eduardo,`r`n`r`n"
$corpo += "O sistema de alertas esta ativo e funcionando.`r`n`r`n"
$corpo += "A partir de agora, voce recebera notificacoes automaticas`r`n"
$corpo += "sempre que um novo cliente entrar no WIP_BOARD.`r`n`r`n"
$corpo += "STATUS DO SISTEMA`r`n"
$corpo += "  Monitor   : Ativo (Task Scheduler - a cada 5 minutos)`r`n"
$corpo += "  Protocolo : V4.5 - 8 frameworks de elite ativos`r`n"
$corpo += "  Gates     : 10 verificacoes automaticas antes de handoff`r`n`r`n"
$corpo += "O Quadrilateral esta de plantao. Aguardamos o primeiro cliente.`r`n`r`n"
$corpo += "==========================================`r`n"
$corpo += "Quadrilateral IAH - Musculo (Claude Code) - 2026-05-12`r`n"

try {
    $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)

    $msg = New-Object Net.Mail.MailMessage
    $msg.From    = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject = $assunto
    $msg.Body    = $corpo

    $smtp.Send($msg)
    Write-Host "Email enviado com sucesso." -ForegroundColor Green
} catch {
    Write-Host "ERRO: $($_.Exception.Message)" -ForegroundColor Red
}
