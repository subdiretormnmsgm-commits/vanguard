#Requires -Version 5.1
# gate_code_review.ps1 -- P-178: code-review EXECUTADO, nao so doutrinado.
# Origem: FALHA-PROCESSO-2026-06-15-C (LEDGER_INBOX). Diretor: "muitos erros de codigo ao longo dos loops".
#
# GATILHO MECANICO (nao depende da memoria do Musculo -- combate DEF-M-6):
#   -Verify  -> usado pelo firewall pre-commit.ps1 (R-05). BLOQUEIA (exit 1) commit de codigo sem review.
#   -Report  -> usado pelo session_start. Lista codigo pendente de review no INICIO do processo (exit 0).
#   -MarkReviewed -> usado pelo Musculo APOS rodar a skill requesting-code-review. Grava o flag de review.
#
# O .ps1 NAO revisa (a skill requesting-code-review e do Musculo) -- ele DETECTA, LISTA e BLOQUEIA.
# Fluxo: pre-commit detecta -> Musculo roda skill -> grava flag (-MarkReviewed) -> commit libera.

param(
    [switch]$Report,
    [switch]$Verify,
    [switch]$MarkReviewed,
    [switch]$List
)

# raiz por $PSScriptRoot (P-183 / #17): sob o git-sh o console e CP850 e a saida UTF-8
# de 'git rev-parse --show-toplevel' corrompe o acento de 'Area de Trabalho' -- quebrava
# Test-Path do flag e bloqueava o commit mesmo com a review feita. $PSScriptRoot chega
# correto via -File. Mesmo padrao ja usado por .git/hooks/pre-commit.ps1.
if ($PSScriptRoot) {
    $raiz = Split-Path $PSScriptRoot -Parent   # <raiz>/scripts -> <raiz>
} else {
    $raiz = git rev-parse --show-toplevel 2>$null
}
if (-not $raiz) { Write-Host "[CODE-REVIEW] Nao e repositorio git -- pulado." -ForegroundColor DarkGray; exit 0 }

$flag = Join-Path $raiz ".code_review_done.flag"

# Extensoes consideradas CODIGO (nao .md de conteudo, nao dado de cliente).
$codeExt = @('.ps1','.psm1','.psd1','.js','.mjs','.cjs','.ts','.html','.htm','.py','.css')

function Test-CodeFile([string]$path) {
    # Regex em vez de [IO.Path]::GetExtension -- git devolve paths com aspas/escapes
    # (ex.: "Doc Vanguard Evolucao Diretor/...") que tem chars invalidos e lancam excecao.
    if ([string]::IsNullOrWhiteSpace($path)) { return $false }
    $ext = ''
    if ($path -match '\.([A-Za-z0-9]+)"?\s*$') { $ext = '.' + $matches[1].ToLower() }
    if (-not $ext) { return $false }
    if ($codeExt -contains $ext) { return $true }
    # .json so quando for infra/config -- nunca dado de cliente (P-059)
    if ($ext -eq '.json') {
        if ($path -match '^"?(scripts/|\.claude/)' -or $path -match 'hooks/') { return $true }
        if ($path -match '(DEPENDENCY_MAP|skills-lock|manifest|package)\.json$') { return $true }
    }
    return $false
}

function Get-StagedSha([string]$path) {
    $sha = git rev-parse ":$path" 2>$null
    if ($LASTEXITCODE -eq 0) { return $sha.Trim() }
    return $null
}

function Get-WorktreeSha([string]$path) {
    # Hash do conteudo ATUAL na arvore de trabalho (cobre unstaged + untracked).
    # Usado por -List/-Report: um arquivo revisado num commit anterior e MODIFICADO de novo
    # depois tem sha de working-tree != sha gravado na flag -> volta a ser pendente (P-178).
    $sha = git hash-object -- "$path" 2>$null
    if ($LASTEXITCODE -eq 0 -and $sha) { return $sha.Trim() }
    return $null
}

# ----------------------------------------------------------------------------
# MODO -MarkReviewed: grava path + blob sha (staged) dos arquivos de codigo
# ----------------------------------------------------------------------------
if ($MarkReviewed) {
    $staged = @(git diff --cached --name-only 2>$null)
    $lines = @()
    foreach ($f in $staged) {
        $nf = $f -replace '\\','/'
        if (Test-CodeFile $nf) {
            $sha = Get-StagedSha $f
            if ($sha) { $lines += "$sha  $nf" }
        }
    }
    if ($lines.Count -eq 0) {
        Write-Host "[CODE-REVIEW] Nenhum arquivo de codigo staged para marcar como revisado." -ForegroundColor Yellow
        exit 0
    }
    Set-Content -Path $flag -Value $lines -Encoding ascii
    Write-Host "[CODE-REVIEW] $($lines.Count) arquivo(s) marcado(s) como revisado(s) (flag gravada):" -ForegroundColor Green
    $lines | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
    exit 0
}

# ----------------------------------------------------------------------------
# Ler flag de review existente -> mapa path => sha revisado
# ----------------------------------------------------------------------------
$reviewed = @{}
if (Test-Path $flag) {
    foreach ($line in @(Get-Content $flag -ErrorAction SilentlyContinue)) {
        $parts = $line -split '\s+', 2
        if ($parts.Count -eq 2) { $reviewed[$parts[1].Trim()] = $parts[0].Trim() }
    }
}

# ----------------------------------------------------------------------------
# Coletar arquivos de codigo modificados
#   -Verify  : apenas STAGED (o que entra no commit)
#   -Report  : staged + unstaged (codigo nao-commitado da sessao)
# ----------------------------------------------------------------------------
if ($Verify) {
    $changed = @(git diff --cached --name-only 2>$null)
} else {
    $changed = @()
    $changed += @(git diff --cached --name-only 2>$null)
    $changed += @(git diff --name-only 2>$null)
    $changed += @(git ls-files --others --exclude-standard 2>$null)
    $changed = @($changed | Select-Object -Unique)
}

$codeFiles = @()
foreach ($f in $changed) {
    $nf = $f -replace '\\','/'
    if (Test-CodeFile $nf) { $codeFiles += $nf }
}

if ($codeFiles.Count -eq 0) {
    if ($Verify) { Write-Host "[CODE-REVIEW R-05] Sem codigo staged. OK." -ForegroundColor Green }
    exit 0
}

# Determinar quais arquivos de codigo ainda nao foram revisados
$pendentes = @()
foreach ($f in $codeFiles) {
    if ($Verify) {
        $sha = Get-StagedSha $f
        if (-not ($reviewed.ContainsKey($f) -and $reviewed[$f] -eq $sha)) { $pendentes += $f }
    } else {
        # Compara o hash da arvore de trabalho (nao so a presenca da chave): codigo revisado
        # antes mas modificado de novo na sessao volta a contar como pendente (P-178).
        $wsha = Get-WorktreeSha $f
        if (-not ($reviewed.ContainsKey($f) -and $wsha -and $reviewed[$f] -eq $wsha)) { $pendentes += $f }
    }
}

if ($pendentes.Count -eq 0) {
    if ($Verify) { Write-Host "[CODE-REVIEW R-05] Codigo staged ja revisado. OK." -ForegroundColor Green }
    exit 0
}

# ----------------------------------------------------------------------------
# MODO -List: saida limpa em stdout (uma path por linha) -- para session_start
# ----------------------------------------------------------------------------
if ($List) {
    $pendentes | ForEach-Object { Write-Output $_ }
    exit 0
}

# ----------------------------------------------------------------------------
# MODO -Report (session_start): informa, nao bloqueia
# ----------------------------------------------------------------------------
if ($Report) {
    Write-Host ""
    Write-Host "[CODE-REVIEW] $($pendentes.Count) arquivo(s) de codigo SEM review (P-178):" -ForegroundColor Yellow
    $pendentes | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
    Write-Host "  Acao: invocar a skill requesting-code-review antes de commitar." -ForegroundColor DarkGray
    exit 0
}

# ----------------------------------------------------------------------------
# MODO -Verify (pre-commit R-05): BLOQUEIA
# Bypass de emergencia: env PENTALATERAL_AUTORIZO (mesmo padrao do firewall R-01)
# ----------------------------------------------------------------------------
if ($Verify) {
    if ($env:PENTALATERAL_AUTORIZO) {
        Write-Host "[CODE-REVIEW R-05] Bypass de emergencia (PENTALATERAL_AUTORIZO). Commit liberado." -ForegroundColor Yellow
        exit 0
    }
    Write-Host ""
    Write-Host "[CODE-REVIEW R-05] BLOQUEADO -- $($pendentes.Count) arquivo(s) de codigo staged sem review:" -ForegroundColor Red
    $pendentes | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    Write-Host "  P-178: code-review obrigatorio antes do commit. Passos:" -ForegroundColor Yellow
    Write-Host "    1. Musculo invoca a skill requesting-code-review nesses arquivos" -ForegroundColor Yellow
    Write-Host "    2. scripts\gate_code_review.ps1 -MarkReviewed" -ForegroundColor Yellow
    Write-Host "    3. repetir o commit" -ForegroundColor Yellow
    exit 1
}

# Sem modo: comportamento default = Report
Write-Host ""
Write-Host "[CODE-REVIEW] $($pendentes.Count) arquivo(s) de codigo sem review. Use -Report ou -Verify." -ForegroundColor Yellow
$pendentes | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
exit 0
