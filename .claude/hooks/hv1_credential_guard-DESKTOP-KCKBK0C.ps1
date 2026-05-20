# HOOK: PreToolUse (Write | Edit)
# Protege contra: HV-1 -- Credencial hardcoded no codigo
# Bloqueia escrita de arquivo se detectar padrao de API key real no conteudo

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$inputJson = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputJson)) { exit 0 }

$data = $inputJson | ConvertFrom-Json -ErrorAction SilentlyContinue
if ($null -eq $data) { exit 0 }

# Extrair conteudo a verificar (Write usa 'content'; Edit usa 'new_string')
$content = ""
if ($data.tool_input.content)    { $content = $data.tool_input.content }
if ($data.tool_input.new_string) { $content += $data.tool_input.new_string }

if ([string]::IsNullOrWhiteSpace($content)) { exit 0 }

# Padroes de credenciais reais com valor literal entre aspas
$patterns = @(
    '"sk-ant-[A-Za-z0-9\-_]{20,}"',
    '"sk-[A-Za-z0-9]{20,}"',
    '"eyJ[A-Za-z0-9_-]{50,}\.[A-Za-z0-9_-]{10,}"',
    '"sbp_[A-Za-z0-9]{20,}"',
    'password\s*=\s*"[^"]{8,}"',
    'service_role.*"eyJ[A-Za-z0-9_-]{20,}"'
)

foreach ($pattern in $patterns) {
    if ($content -match $pattern) {
        $reason = "[HV-1 BLOQUEADO] Credencial hardcoded detectada. Mova para variavel de ambiente (.env) antes de prosseguir."

        $output = [ordered]@{
            hookSpecificOutput = [ordered]@{
                hookEventName            = "PreToolUse"
                permissionDecision       = "deny"
                permissionDecisionReason = $reason
            }
        } | ConvertTo-Json -Depth 3 -Compress

        Write-Output $output
        Write-Error $reason
        exit 2
    }
}

exit 0
