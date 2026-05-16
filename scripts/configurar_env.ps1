# configurar_env.ps1
# Configura o arquivo .env de um projeto de forma segura — sem digitar keys no chat.
# Uso: .\scripts\configurar_env.ps1 -projeto INGRID
# O script guia cada variavel, mascara a entrada e escreve o .env com permissao restrita.

param(
    [Parameter(Mandatory)][ValidateSet("INGRID","VALDECE")][string]$projeto
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot

$caminhos = @{
    "INGRID"  = "$BASE\CLIENTES\INGRID\backend\.env"
    "VALDECE" = "$BASE\CLIENTES\VALDECE\backend\.env"
}

$variaveis = @{
    "INGRID" = @(
        @{ Nome = "SUPABASE_URL";       Descricao = "URL do projeto Supabase (ex: https://xxxx.supabase.co)"; Exemplo = "https://xxxx.supabase.co" }
        @{ Nome = "SUPABASE_ANON_KEY";  Descricao = "Chave anon/public do Supabase (Dashboard > Settings > API)"; Exemplo = "eyJ..." }
        @{ Nome = "ANTHROPIC_API_KEY";  Descricao = "Chave da Anthropic (console.anthropic.com > API Keys)"; Exemplo = "sk-ant-api03-..." }
    )
    "VALDECE" = @(
        @{ Nome = "SUPABASE_URL";       Descricao = "URL do projeto Supabase Valdece"; Exemplo = "https://xxxx.supabase.co" }
        @{ Nome = "SUPABASE_ANON_KEY";  Descricao = "Chave anon Supabase Valdece"; Exemplo = "eyJ..." }
        @{ Nome = "ANTHROPIC_API_KEY";  Descricao = "Chave da Anthropic"; Exemplo = "sk-ant-api03-..." }
    )
}

$envPath = $caminhos[$projeto]
$vars    = $variaveis[$projeto]

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  CONFIGURADOR SEGURO DE .ENV — $projeto" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  As chaves serao inseridas com entrada mascarada." -ForegroundColor Yellow
Write-Host "  NUNCA cole chaves no chat do Claude Code." -ForegroundColor Red
Write-Host ""

$valores = @{}

foreach ($v in $vars) {
    Write-Host "  [$($v.Nome)]" -ForegroundColor Cyan
    Write-Host "  $($v.Descricao)" -ForegroundColor Gray
    Write-Host "  Formato: $($v.Exemplo)" -ForegroundColor DarkGray

    $entrada = Read-Host -AsSecureString "  Valor (mascarado)"
    $plain   = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                   [Runtime.InteropServices.Marshal]::SecureStringToBSTR($entrada))

    if ([string]::IsNullOrWhiteSpace($plain)) {
        Write-Host "  [AVISO] Campo vazio — deixando em branco no .env." -ForegroundColor Yellow
    }

    $valores[$v.Nome] = $plain
    Write-Host ""
}

# Montar conteudo do .env
$conteudo = $vars | ForEach-Object { "$($_.Nome)=$($valores[$_.Nome])" }
$conteudo -join "`n" | Set-Content $envPath -Encoding UTF8

# Restringir permissao de leitura ao usuario atual (Windows ACL)
try {
    $acl  = Get-Acl $envPath
    $acl.SetAccessRuleProtection($true, $false)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $env:USERNAME, "FullControl", "Allow")
    $acl.SetAccessRule($rule)
    Set-Acl $envPath $acl
} catch {
    Write-Host "  [AVISO] Nao foi possivel restringir permissoes: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host "======================================================" -ForegroundColor Green
Write-Host "  .ENV SALVO COM SEGURANCA" -ForegroundColor Green
Write-Host "  Caminho: $envPath" -ForegroundColor Green
Write-Host "  Variaveis: $($vars.Count) configuradas" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Proximos passos:" -ForegroundColor Cyan
Write-Host "  1. Verificar se .env esta no .gitignore" -ForegroundColor White
Write-Host "  2. Nunca copiar o conteudo deste arquivo no chat" -ForegroundColor White
Write-Host "  3. Para rotacionar uma chave: rodar este script novamente" -ForegroundColor White
Write-Host ""
