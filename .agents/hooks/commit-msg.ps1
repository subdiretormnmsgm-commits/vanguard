#Requires -Version 5.1
# commit-msg.ps1 -- R-02: verificar [VEREDITO-DIRETOR] em arquivos de alto risco
# Executado pelo commit-msg.bat -- recebe caminho da mensagem como $args[0]
# Origem: dívida R-02 Loop 33 -- implementado Loop 34

param([string]$MsgFile)

if (-not $MsgFile) {
    # Quando chamado via .bat, $args passa o path como primeiro argumento
    $MsgFile = $args[0]
}
if (-not $MsgFile -or -not (Test-Path $MsgFile)) {
    exit 0
}

$commitMsg = Get-Content $MsgFile -Raw -Encoding UTF8
$temVeredito = $commitMsg -match "\[VEREDITO-DIRETOR\]"

$r02_nomes = @(
    "WIP_BOARD.json",
    "INTELLIGENCE_LEDGER.md",
    "DECISOES*.json"
)

$stagedFiles = git diff --cached --name-only 2>$null
if (-not $stagedFiles) { exit 0 }

$r02Violacoes = @()
foreach ($file in $stagedFiles) {
    $fileName = Split-Path $file -Leaf
    $isR02 = $false
    if ($r02_nomes -contains $fileName) { $isR02 = $true }
    if ($fileName -match "^DECISOES.*\.json$") { $isR02 = $true }
    if ($isR02 -and -not $temVeredito) {
        $r02Violacoes += $fileName
    }
}

if ($r02Violacoes.Count -gt 0) {
    Write-Host ""
    Write-Host "[COMMIT-MSG FIREWALL] R-02: arquivos de alto risco sem [VEREDITO-DIRETOR]" -ForegroundColor Red
    foreach ($v in $r02Violacoes) {
        Write-Host "  - $v" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "  Adicionar [VEREDITO-DIRETOR] na mensagem de commit para autorizar." -ForegroundColor Yellow
    Write-Host "  Exemplo: 'feat(wip): atualizar estado [VEREDITO-DIRETOR]'" -ForegroundColor Cyan
    exit 1
}

exit 0
