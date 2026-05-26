# deploy_ingrid_ghpages.ps1
# P-056: Sync frontend Ingrid (master) -> gh-pages (producao)
# Uso: .\scripts\deploy_ingrid_ghpages.ps1

$ErrorActionPreference = "Stop"

# PS5.1: forcar leitura do output de git como UTF-8 (sem isso emojis ficam corrompidos)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8

$root = Split-Path $PSScriptRoot -Parent
$src  = "CLIENTES/INGRID/frontend"

Write-Host "`n[DEPLOY INGRID] Iniciando sync master -> gh-pages..." -ForegroundColor Cyan

# Confirmar versao que sera deployada
$versao = git -C $root show "master:$src/app.js" | Select-Object -First 2
Write-Host "`nVersao a deployar:" -ForegroundColor Yellow
$versao | ForEach-Object { Write-Host "  $_" }

# Salvar estado atual
$branch = git -C $root rev-parse --abbrev-ref HEAD
git -C $root stash | Out-Null

# Trocar para gh-pages
git -C $root checkout gh-pages | Out-Null
Write-Host "`n[1/3] Branch gh-pages ativa" -ForegroundColor Green

# Copiar arquivos preservando UTF-8 sem BOM
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
@("app.js", "index.html", "style.css", "sw.js", "manifest.json") | ForEach-Object {
    $lines   = git -C $root show "master:$src/$_"
    $content = $lines -join "`n"
    [System.IO.File]::WriteAllText("$root\$_", $content, $utf8NoBom)
    Write-Host "      Copiado: $_" -ForegroundColor Gray
}
Write-Host "[2/3] Arquivos copiados" -ForegroundColor Green

# Commit e push
git -C $root add app.js index.html style.css sw.js manifest.json
$hash = git -C $root rev-parse --short "master"
git -C $root commit -m "deploy(gh-pages): sync ingrid frontend @ master $hash" | Out-Null
git -C $root push origin gh-pages | Out-Null
Write-Host "[3/3] Push concluido -> producao atualizada" -ForegroundColor Green

# Voltar para branch original
git -C $root checkout $branch | Out-Null
git -C $root stash pop 2>$null | Out-Null

Write-Host "`n[OK] Deploy concluido. Aguarde 1-2 min para GitHub Pages propagar." -ForegroundColor Cyan
Write-Host "  URL: https://subdiretormnmsgm-commits.github.io/vanguard/" -ForegroundColor Gray
Write-Host "  Confirmar: debug panel (3 toques no logo) -> checar versao v17"
