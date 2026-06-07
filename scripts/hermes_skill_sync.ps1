#Requires -Version 5.1
# hermes_skill_sync.ps1 -- gera comandos para carregar skills no container Hermes
# Executar: .\scripts\hermes_skill_sync.ps1
# Output: comando pronto para colar no terminal EasyPanel do hermes-agent

param(
    [string]$Skill = "pentalateral-graus-abc",
    [switch]$All
)

$BASE   = Split-Path $PSScriptRoot -Parent
$SKILLS = Join-Path $BASE "hermes-agent\skills"

function Get-SkillsToSync {
    if ($All) {
        return Get-ChildItem $SKILLS -Filter "*.md" -ErrorAction SilentlyContinue
    } else {
        $path = Join-Path $SKILLS "$Skill.md"
        if (Test-Path $path) { return Get-Item $path }
        Write-Host "  ERRO: $path nao encontrado" -ForegroundColor Red
        exit 1
    }
}

$files = Get-SkillsToSync
if (-not $files) { Write-Host "  Nenhuma skill encontrada em $SKILLS" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host "  HERMES SKILL SYNC -- Instrucoes para EasyPanel Terminal" -ForegroundColor Cyan
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. Abrir EasyPanel: https://0ul9nk.easypanel.host" -ForegroundColor Yellow
Write-Host "  2. Projeto: hermes | Servico: hermes-agent | Aba: Terminal" -ForegroundColor Yellow
Write-Host "  3. Colar os comandos abaixo (um bloco por skill):" -ForegroundColor Yellow
Write-Host ""

foreach ($file in $files) {
    $name    = $file.BaseName
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # Escapar aspas simples para uso em heredoc bash
    $escaped = $content -replace "'", "'\"'\"'"

    Write-Host "--- SKILL: $name ---" -ForegroundColor Green
    Write-Host ""
    Write-Host "mkdir -p /opt/data/skills && cat > /opt/data/skills/$name.md << 'SKILLEOF'" -ForegroundColor White

    # Mostrar primeiras linhas para confirmacao visual
    $preview = ($content -split "`n" | Select-Object -First 5) -join "`n"
    Write-Host $preview -ForegroundColor DarkGray
    Write-Host "..." -ForegroundColor DarkGray
    Write-Host "SKILLEOF" -ForegroundColor White
    Write-Host ""

    # Salvar o conteudo completo em arquivo temporario para o Diretor copiar
    $tmpPath = Join-Path $env:TEMP "hermes_skill_$name.sh"
    $cmd  = "mkdir -p /opt/data/skills && cat > /opt/data/skills/$name.md << 'SKILLEOF'`n"
    $cmd += $content
    $cmd += "`nSKILLEOF`n"
    $cmd += "echo 'Skill carregada: $name' && ls -la /opt/data/skills/"
    [System.IO.File]::WriteAllText($tmpPath, $cmd, [System.Text.Encoding]::UTF8)

    Write-Host "  Comando completo salvo em: $tmpPath" -ForegroundColor Cyan
    Write-Host "  Abrir e copiar TUDO para o terminal do EasyPanel." -ForegroundColor Cyan
    Write-Host ""
}

Write-Host "  Apos colar no terminal EasyPanel:"     -ForegroundColor Yellow
Write-Host "  Verificar com: ls -la /opt/data/skills/" -ForegroundColor Yellow
Write-Host ""
Write-Host "  4. Reiniciar gateway para carregar a skill:" -ForegroundColor Yellow
Write-Host "     hermes gateway restart"                   -ForegroundColor White
Write-Host ""
Write-Host "=============================================================" -ForegroundColor Cyan

# Copiar comando de verificacao para clipboard
$verif = "ls -la /opt/data/skills/ && hermes status"
try {
    $verif | Set-Clipboard
    Write-Host "  [CLIPBOARD] Comando de verificacao copiado: $verif" -ForegroundColor Green
} catch {}
