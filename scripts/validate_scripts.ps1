#Requires -Version 5.1
# validate_scripts.ps1 - Analise estatica de scripts PowerShell do Pentalateral
# P-060: Musculo roda isto apos criar ou editar qualquer .ps1 antes de reportar "concluido".
#
# Uso:
#   .\scripts\validate_scripts.ps1 -Script "scripts\ir_ao_embaixador.ps1"
#   .\scripts\validate_scripts.ps1 -Todos

param(
    [string]$Script = "",
    [switch]$Todos
)

$raiz = Split-Path -Parent $PSScriptRoot

function Test-Script {
    param([string]$caminho)

    $nomeRel = $caminho.Replace($raiz + "\", "")
    $conteudo = Get-Content $caminho -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $conteudo) { return 0 }

    $erros  = @()
    $avisos = @()
    $linhas = $conteudo -split "`n"

    # --- Regra 0: Parse AST real (usa ParseInput+UTF8 para evitar falso positivo de em dash) ---
    $parseErros = $null
    $parseTokens = $null
    $conteudoUtf8 = [System.IO.File]::ReadAllText($caminho, [System.Text.Encoding]::UTF8)
    [System.Management.Automation.Language.Parser]::ParseInput($conteudoUtf8, [ref]$parseTokens, [ref]$parseErros) | Out-Null
    foreach ($pe in $parseErros) {
        $erros += ("Linha " + $pe.Extent.StartLineNumber + " [PARSE]: " + $pe.Message)
    }

    # Detectar aspas curvas nos bytes brutos (U+2018 U+2019 U+201C U+201D)
    $bytesRaw = [System.IO.File]::ReadAllBytes($caminho)
    $textoRaw = [System.Text.Encoding]::UTF8.GetString($bytesRaw)
    $curvosPattern = "[" + [char]0x2018 + [char]0x2019 + [char]0x201C + [char]0x201D + "]"
    $curvos = [regex]::Matches($textoRaw, $curvosPattern)
    foreach ($m in $curvos) {
        $linhaNum = ($textoRaw.Substring(0, $m.Index) -split "`n").Count
        $cp = [int][char]$m.Value[0]
        $erros += ("Linha " + $linhaNum + " [ENCODING]: aspa curva U+" + $cp.ToString('X4') + " - PS 5.1 quebra o script")
    }

    # Detectar utf8NoBOM em chamadas reais de Out-File/Set-Content (PS 6+ exclusivo)
    # Exclui linhas que sao comentarios ou que contem o padrao como texto de erro/exemplo
    for ($i = 0; $i -lt $linhas.Count; $i++) {
        $linha = $linhas[$i].TrimStart()
        if ($linha.StartsWith('#')) { continue }
        if ($linha -match '(Out-File|Set-Content)' -and $linha -match '-Encoding\s+utf8NoBOM') {
            $erros += ("Linha " + ($i+1) + " [ENCODING]: -Encoding utf8NoBOM e PS 6+ exclusivo - usar [System.Text.UTF8Encoding]::new(`$false)")
        }
    }

    # --- Regra 1: $root em vez de $raiz ---
    # Padrao construido em partes para evitar auto-deteccao neste script
    $varProibida = '$' + 'root'
    for ($i = 0; $i -lt $linhas.Count; $i++) {
        $linha = $linhas[$i].TrimStart()
        if ($linha.StartsWith('#')) { continue }
        if ($linha -match '^\$(erros|avisos)\s+\+=' -or $linha -match '^Write-Host') { continue }
        if ($linha.Contains($varProibida)) {
            $erros += ("Linha " + ($i+1) + ": `$root nao e variavel padrao - use `$raiz")
        }
    }

    # --- Regra 2: Read-Host fora de session_close ---
    for ($i = 0; $i -lt $linhas.Count; $i++) {
        if ($linhas[$i] -match 'Read-Host' -and $linhas[$i] -notmatch '#') {
            if ($caminho -notmatch 'session_close') {
                $avisos += ("Linha " + ($i+1) + ": Read-Host - bloqueia execucao nao-interativa")
            }
        }
    }

    # --- Regra 3: path hardcoded com nome de usuario ---
    if ($conteudo -match 'C:\\Users\\[A-Za-z]') {
        $pathMatches = [regex]::Matches($conteudo, 'C:\\\\Users\\\\[A-Za-z][^"'' ]+')
        foreach ($m in $pathMatches) {
            $linhaNum = ($conteudo.Substring(0, $m.Index) -split "`n").Count
            $erros += ("Linha " + $linhaNum + ": path hardcoded (" + $m.Value + ") - use `$raiz")
        }
    }

    # --- Regra 4: $PSScriptRoot sem $raiz ---
    if ($conteudo -match '\$PSScriptRoot' -and $conteudo -notmatch '\$raiz\s*=') {
        $avisos += "Script usa `$PSScriptRoot mas nao define `$raiz - verificar"
    }

    # --- Relatorio ---
    $status = if ($erros.Count -gt 0) { "FALHA" } elseif ($avisos.Count -gt 0) { "AVISO" } else { "OK" }
    $cor    = if ($erros.Count -gt 0) { "Red" } elseif ($avisos.Count -gt 0) { "Yellow" } else { "Green" }

    Write-Host ("  [" + $status + "] " + $nomeRel) -ForegroundColor $cor
    foreach ($e in $erros)  { Write-Host ("    [ERRO] " + $e) -ForegroundColor Red }
    foreach ($a in $avisos) { Write-Host ("    [AVS]  " + $a) -ForegroundColor Yellow }

    return $erros.Count
}

# --- Executar ---
Write-Host ""
Write-Host "[VALIDATE] Analise estatica de scripts PowerShell" -ForegroundColor Cyan
Write-Host ""

$totalErros = 0

if ($Script) {
    $caminho = if ([System.IO.Path]::IsPathRooted($Script)) { $Script } else { Join-Path $raiz $Script }
    if (Test-Path $caminho) {
        $totalErros += Test-Script $caminho
    } else {
        Write-Host ("  [ERRO] Script nao encontrado: " + $caminho) -ForegroundColor Red
        exit 1
    }
} elseif ($Todos) {
    $scriptsList = Get-ChildItem "$raiz\scripts" -Filter "*.ps1" -ErrorAction SilentlyContinue
    $hooksList   = Get-ChildItem "$raiz\.claude\hooks" -Filter "*.ps1" -ErrorAction SilentlyContinue
    $todos = @($scriptsList) + @($hooksList) | Where-Object { $_ }
    foreach ($s in $todos) {
        $totalErros += Test-Script $s.FullName
    }
} else {
    Write-Host "  Uso: -Script [caminho] | -Todos" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
if ($totalErros -gt 0) {
    Write-Host ("  [VALIDATE] " + $totalErros + " erro(s) encontrado(s) - corrigir antes de reportar ao Diretor.") -ForegroundColor Red
    exit 1
} else {
    Write-Host "  [VALIDATE] Nenhum erro critico encontrado." -ForegroundColor Green
    exit 0
}
