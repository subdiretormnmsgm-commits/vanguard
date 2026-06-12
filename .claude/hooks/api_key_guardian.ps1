# HOOK: UserPromptSubmit — API Key Guardian
# Detecta padroes de API keys no prompt do Diretor antes de processar.
# Protege contra exposicao acidental de credenciais no chat do Claude Code.

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Ler o prompt do stdin (JSON enviado pelo Claude Code)
$stdinRaw = [Console]::In.ReadToEnd()
$promptText = ""

try {
    $parsed = $stdinRaw | ConvertFrom-Json
    # O campo pode ser "prompt" ou estar em estrutura aninhada
    if ($parsed.prompt)            { $promptText = $parsed.prompt }
    elseif ($parsed.message)       { $promptText = $parsed.message }
    elseif ($parsed.userMessage)   { $promptText = $parsed.userMessage }
    else                           { $promptText = $stdinRaw }
} catch {
    $promptText = $stdinRaw
}

# Padroes de API keys conhecidos
$padroes = @(
    @{ Regex = "sk-ant-api[0-9]+-[A-Za-z0-9_-]{20,}";  Nome = "Anthropic API Key" }
    @{ Regex = "sbp_[A-Za-z0-9]{30,}";                  Nome = "Supabase Personal Access Token" }
    @{ Regex = "eyJhbGciOiJIUzI1NiIsInR5cCI[A-Za-z0-9_.-]{40,}"; Nome = "Supabase JWT / Anon Key" }
    @{ Regex = "sk-[A-Za-z0-9]{40,}";                   Nome = "OpenAI API Key" }
    @{ Regex = "AIza[A-Za-z0-9_-]{35}";                 Nome = "Google API Key" }
    @{ Regex = "ghp_[A-Za-z0-9]{36}";                   Nome = "GitHub Personal Access Token" }
)

$encontrados = @()
foreach ($p in $padroes) {
    if ($promptText -match $p.Regex) {
        $encontrados += $p.Nome
    }
}

if ($encontrados.Count -eq 0) {
    exit 0
}

# Key detectada — disparar e-mail de alerta e bloquear
$nomes = $encontrados -join ", "

$BASE = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$alertConfig = "$BASE\scripts\alert_config.ps1"

if (Test-Path $alertConfig) {
    try {
        . $alertConfig
        $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
        $smtp.EnableSsl    = $true
        $smtp.Credentials  = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)
        $msg               = New-Object Net.Mail.MailMessage
        $msg.From          = $ALERT_FROM
        $msg.To.Add($ALERT_TO)
        $msg.Subject       = "ALERTA HV-1: API Key detectada no chat do Claude Code"
        $msg.Body          = "Diretor,`n`nO sistema bloqueou uma mensagem no Claude Code que continha:`n$nomes`n`nA mensagem NAO foi processada.`n`nAcao correta: use .\scripts\configurar_env.ps1 -projeto [NOME] para configurar credenciais com entrada mascarada, sem expor no chat.`n`nMusculo - API Key Guardian"
        $msg.BodyEncoding  = [System.Text.Encoding]::UTF8
        $smtp.Send($msg)
    } catch { }
}

$resposta = [ordered]@{
    hookSpecificOutput = [ordered]@{
        hookEventName = "UserPromptSubmit"
        blockReason   = "ALERTA HV-1 — $nomes detectada. Mensagem bloqueada. E-mail de alerta disparado. Use: .\scripts\configurar_env.ps1 -projeto [NOME]"
    }
} | ConvertTo-Json -Depth 3 -Compress

Write-Output $resposta
exit 2
