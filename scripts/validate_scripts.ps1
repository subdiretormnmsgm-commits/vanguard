#Requires -Version 5.1
# validate_scripts.ps1 — Analise estatica de scripts PowerShell do Pentalateral
# P-060: Musculo roda isto apos criar ou editar qualquer .ps1 antes de reportar "concluido".
# Detecta bugs comuns antes de Eduardo precisar apontar.
#
# Uso:
#   .\scripts\validate_scripts.ps1 -Script "scripts\ir_ao_embaixador.ps1"
#   .\scripts\validate_scripts.ps1 -Todos   # valida todos os .ps1 em scripts/ e hooks/

param(
    [string]$Script = "",
    [switch]$Todos
)

$raiz = Split-Path -Parent $PSScriptRoot

function Test-Script {
    param([string]$caminho)

    $nomeRel = $caminho.Replace($raiz + "\", "")
    $conteudo = Get-Content $caminho -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $conteudo) { return }

    $erros    = @()
    $avisos   = @()
    $linhas   = $conteudo -split "`n"

    # --- Regra 1: variaveis indefinidas comuns ($root em vez de $raiz) ---
    $varIndefinidas = [regex]::Matches($conteudo, '\$root\b')
    if ($varIndefinidas.Count -gt 0) {
        foreach ($m in $varIndefinidas) {
            $linha = ($conteudo.Substring(0, $m.Index) -split "`n").Count
            $erros += "Linha $linha : `$root nao e variavel padrao — use `$raiz (definida por Split-Path -Parent `$PSScriptRoot)"
        }
    }

    # --- Regra 2: Read-Host em script de automacao (bloqueia execucao nao-interativa) ---
    for ($i = 0; $i -lt $linhas.Count; $i++) {
        if ($linhas[$i] -match 'Read-Host' -and $linhas[$i] -notmatch '#') {
            # Avisar apenas se nao e script de sessao fechamento (eles sao interativos por design)
            if ($caminho -notmatch 'session_close') {
                $avisos += "Linha $($i+1): Read-Host — bloqueia execucao nao-interativa (Task Scheduler, hooks)"
            }
        }
    }

    # --- Regra 3: path hardcoded com nome de usuario ---
    if ($conteudo -match 'C:\\Users\\[A-Za-z]') {
        $matchesPath = [regex]::Matches($conteudo, 'C:\\\\Users\\\\[A-Za-z][^"'' ]+')
        foreach ($m in $matchesPath) {
            $linha = ($conteudo.Substring(0, $m.Index) -split "`n").Count
            $erros += "Linha $linha : path hardcoded detectado ($($m.Value)) — use `$raiz ou `$PSScriptRoot"
        }
    }

    # --- Regra 4: $PSScriptRoot sem definicao de $raiz ---
    if ($conteudo -match '\$PSScriptRoot' -and $conteudo -notmatch '\$raiz\s*=') {
        $avisos += "Script usa `$PSScriptRoot mas nao define `$raiz — verificar se e intencional"
    }

    # --- Regra 5: Exit sem codigo numerico ---
    $exitSemCodigo = [regex]::Matches($conteudo, '\bexit\b(?!\s+[01])')
    foreach ($m in $exitSemCodigo) {
        $linha = ($conteudo.Substring(0, $m.Index) -split "`n").Count
        $avisos += "Linha $linha : exit sem codigo (0 ou 1) — pode mascarar falha"
    }

    # --- Relatorio ---
    $status = if ($erros.Count -gt 0) { "FALHA" } elseif ($avisos.Count -gt 0) { "AVISO" } else { "OK" }
    $cor    = if ($erros.Count -gt 0) { "Red" } elseif ($avisos.Count -gt 0) { "Yellow" } else { "Green" }

    Write-Host "  [$status] $nomeRel" -ForegroundColor $cor
    foreach ($e in $erros)  { Write-Host "    [ERRO] $e" -ForegroundColor Red }
    foreach ($a in $avisos) { Write-Host "    [AVS]  $a" -ForegroundColor Yellow }

    return $erros.Count
}

# --- Executar ---
Write-Host ""
Write-Host "[VALIDATE] Analise estatica de scripts PowerShell" -ForegroundColor Cyan
Write-Host ""

$totalErros = 0

if ($Script) {
    $caminho = if ([System.IO.Path]::IsPathRooted($Script)) { $Script } else { "$raiz\$Script" }
    if (Test-Path $caminho) {
        $totalErros += Test-Script $caminho
    } else {
        Write-Host "  [ERRO] Script nao encontrado: $caminho" -ForegroundColor Red
        exit 1
    }
} elseif ($Todos) {
    $scripts = Get-ChildItem "$raiz\scripts" -Filter "*.ps1" -ErrorAction SilentlyContinue
    $hooks   = Get-ChildItem "$raiz\.claude\hooks" -Filter "*.ps1" -ErrorAction SilentlyContinue
    $todos   = @($scripts) + @($hooks) | Where-Object { $_ }
    foreach ($s in $todos) {
        $totalErros += Test-Script $s.FullName
    }
} else {
    Write-Host "  Uso: -Script [caminho] | -Todos" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
if ($totalErros -gt 0) {
    Write-Host "  [VALIDATE] $totalErros erro(s) encontrado(s) — corrigir antes de reportar ao Diretor." -ForegroundColor Red
    exit 1
} else {
    Write-Host "  [VALIDATE] Nenhum erro critico encontrado." -ForegroundColor Green
    exit 0
}
