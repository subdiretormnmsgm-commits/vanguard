#Requires -Version 5.1
# install_hooks.ps1 -- Instala git hooks do Pentalateral IAH em .git/hooks/
# Rodar apos clone novo ou reset de .git/hooks/
# Origem: Loop 34 -- hooks versionados em .agents/hooks/

$raiz = Split-Path $PSScriptRoot -Parent -Resolve
$hooksGit = "$raiz\.git\hooks"
$hooksSrc  = $PSScriptRoot

if (-not (Test-Path $hooksGit)) {
    Write-Host "[ERRO] .git/hooks nao encontrado. Executar dentro do repositorio." -ForegroundColor Red
    exit 1
}

$arquivos = @(
    "pre-commit.ps1",
    "pre-commit.bat",
    "commit-msg.ps1",
    "commit-msg.bat"
)

foreach ($arq in $arquivos) {
    $src = "$hooksSrc\$arq"
    $dst = "$hooksGit\$arq"
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        Write-Host "[OK] Instalado: $arq" -ForegroundColor Green
    }
}

# Verificar hook bash pre-commit (entry point)
$preCommitBash = "$hooksGit\pre-commit"
if (Test-Path $preCommitBash) {
    $conteudo = Get-Content $preCommitBash -Raw -Encoding UTF8
    if ($conteudo -notmatch "pre-commit\.ps1") {
        Write-Host "[AVISO] pre-commit (bash) nao chama pre-commit.ps1 -- adicionar manualmente:" -ForegroundColor Yellow
        Write-Host '  powershell.exe -NonInteractive -ExecutionPolicy Bypass -File "$(git rev-parse --show-toplevel)/.git/hooks/pre-commit.ps1"' -ForegroundColor Cyan
    } else {
        Write-Host "[OK] pre-commit (bash) ja chama pre-commit.ps1" -ForegroundColor Green
    }
} else {
    Write-Host "[AVISO] pre-commit (bash) nao encontrado -- criar antes de instalar" -ForegroundColor Yellow
}

$commitMsgBash = "$hooksGit\commit-msg"
if (-not (Test-Path $commitMsgBash)) {
    Write-Host "[AVISO] commit-msg (bash) nao encontrado -- criar:" -ForegroundColor Yellow
    Write-Host '  #!/bin/sh' -ForegroundColor Cyan
    Write-Host '  powershell.exe -NonInteractive -ExecutionPolicy Bypass -File "$(git rev-parse --show-toplevel)/.git/hooks/commit-msg.ps1" "$1"' -ForegroundColor Cyan
} else {
    Write-Host "[OK] commit-msg (bash) presente" -ForegroundColor Green
}

Write-Host ""
Write-Host "Hooks instalados. Testar: git commit --allow-empty -m 'test: firewall check'" -ForegroundColor Cyan
