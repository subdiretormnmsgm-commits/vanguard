#Requires -Version 5.1
# file_protection_guard.ps1 -- Bloqueante P-098
# Le o caminho do arquivo via stdin JSON (padrao de hook do Claude Code)
# Bloqueia Write/Edit em arquivos de processo critico sem flag de autorizacao.
# Para autorizar: diga "AUTORIZO SOBRESCREVER [arquivo]" no chat.
# O Musculo cria .musculo_autorizacao.flag -- o hook consome e permite.

$stdin = $null
try {
    $raw = [Console]::In.ReadToEnd()
    if ($raw) { $stdin = $raw | ConvertFrom-Json -ErrorAction SilentlyContinue }
} catch {}

$FilePath = ""
if ($stdin) {
    $FilePath = if ($stdin.tool_input.file_path)  { $stdin.tool_input.file_path }
                elseif ($stdin.tool_input.new_path) { $stdin.tool_input.new_path }
                else { "" }
}

if (-not $FilePath) { exit 0 }

$BASE = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

# Padroes protegidos -- arquivos que o Musculo NAO pode sobrescrever sem veredito.
# Fonte canonica = protected_paths.txt (compartilhada com shell_protection_guard.ps1, P-184).
# Fallback inline (fail-safe): se a lista sumir, o firewall NAO enfraquece.
$protegidosInline = @(
    "PASSO5_NOTEBOOKLM\.md$",
    "PASSO3_GEMINI\.md$",
    "PASSO7_EMBAIXADOR\.md$",
    "\.claude[/\\]skills[/\\].+\.md$",
    "PASSO3_GEMINI_TEMPLATE\.md$",
    "passo3_template\.txt$",
    "INTELLIGENCE_LEDGER\.md$",
    "DEPENDENCY_MAP\.json$",
    "CLAUDE\.md$"
)
$listaPath = Join-Path $PSScriptRoot "protected_paths.txt"
$protegidos = $null
if (Test-Path $listaPath) {
    try {
        $protegidos = Get-Content $listaPath -ErrorAction Stop |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ -and ($_ -notmatch '^\s*#') }
    } catch { $protegidos = $null }
}
if (-not $protegidos -or @($protegidos).Count -eq 0) { $protegidos = $protegidosInline }

$pathNorm = $FilePath -replace "\\", "/"
$protegido = $false
$padrao    = ""
foreach ($p in $protegidos) {
    if ($pathNorm -match $p) { $protegido = $true; $padrao = $p; break }
}

if (-not $protegido) { exit 0 }

# Verificar flag de autorizacao
$flagPath = "$BASE\.musculo_autorizacao.flag"
if (Test-Path $flagPath) {
    $flagContent = Get-Content $flagPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    $arquivoNome = Split-Path $FilePath -Leaf
    if ($flagContent -match [regex]::Escape($arquivoNome) -or $flagContent -match "\*") {
        Remove-Item $flagPath -Force -ErrorAction SilentlyContinue
        exit 0
    }
}

# Bloquear
$arquivoNome = Split-Path $FilePath -Leaf
$output = [PSCustomObject]@{
    decision    = "block"
    reason      = "ARQUIVO PROTEGIDO (P-098): $arquivoNome nao pode ser sobrescrito sem veredito explicito do Diretor. Diga 'AUTORIZO SOBRESCREVER $arquivoNome' para desbloquear."
    systemMessage = "BLOQUEADO P-098: $arquivoNome e arquivo de processo protegido. O Musculo precisa de autorizacao explicita do Diretor antes de modificar."
} | ConvertTo-Json -Compress

Write-Output $output
exit 1
