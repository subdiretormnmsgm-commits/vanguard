# deploy_ingrid_ghpages.ps1
# P-056: Sync frontend Ingrid (master) → gh-pages (produção)
# Uso: .\scripts\deploy_ingrid_ghpages.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$src  = "CLIENTES/INGRID/frontend"

Write-Host "`n[DEPLOY INGRID] Iniciando sync master → gh-pages..." -ForegroundColor Cyan

# Confirmar versão que será deployada
$versao = git -C $root show "master:$src/app.js" | Select-Object -First 2
Write-Host "`nVersão a deployar:" -ForegroundColor Yellow
$versao | ForEach-Object { Write-Host "  $_" }

# Salvar estado atual
$branch = git -C $root rev-parse --abbrev-ref HEAD
git -C $root stash | Out-Null

# Trocar para gh-pages
git -C $root checkout gh-pages | Out-Null
Write-Host "`n[1/3] Branch gh-pages ativa" -ForegroundColor Green

# Copiar arquivos
@("app.js", "index.html", "style.css", "sw.js", "manifest.json") | ForEach-Object {
    git -C $root show "master:$src/$_" | Set-Content "$root\$_" -Encoding UTF8
    Write-Host "      Copiado: $_" -ForegroundColor Gray
}
Write-Host "[2/3] Arquivos copiados" -ForegroundColor Green

# Commit e push
git -C $root add app.js index.html style.css sw.js manifest.json
$hash = git -C $root rev-parse --short "master"
git -C $root commit -m "deploy(gh-pages): sync ingrid frontend @ master $hash" | Out-Null
git -C $root push origin gh-pages | Out-Null
Write-Host "[3/3] Push concluído → produção atualizada" -ForegroundColor Green

# Voltar para branch original
git -C $root checkout $branch | Out-Null
git -C $root stash pop 2>$null | Out-Null

Write-Host "`n✓ Deploy concluído. Aguarde 1-2 min para GitHub Pages propagar." -ForegroundColor Cyan
Write-Host "  URL: https://subdiretormnmsgm-commits.github.io/vanguard/" -ForegroundColor Gray
Write-Host "  Confirmar: abrir debug panel (3 cliques em 'Sedes-DF 2026') → checar versão`n"
