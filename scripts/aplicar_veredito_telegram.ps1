#Requires -Version 5.1
# aplicar_veredito_telegram.ps1 -- P-072
# Baixa VEREDITO especifico do GitHub e aplica no DECISOES.json do cliente.
# Chamado manualmente pelo Musculo apos confirmar qual cliente o veredito pertence.
#
# Uso:
#   .\scripts\aplicar_veredito_telegram.ps1 -arquivo VEREDITOS_202606051925.json -cliente INGRID
#   .\scripts\aplicar_veredito_telegram.ps1 -arquivo VEREDITOS_202606051925.json -cliente VALDECE

param(
    [Parameter(Mandatory=$true)] [string]$arquivo,
    [Parameter(Mandatory=$true)] [string]$cliente
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectDir  = Split-Path -Parent $PSScriptRoot
$chaves      = Join-Path $projectDir "CHAVES_SISTEMA_VANGUARD.txt"
$logFile     = Join-Path $PSScriptRoot ".vereditos_processados.log"
$githubRepo  = "subdiretormnmsgm-commits/vanguard"
$cliUp       = $cliente.ToUpper()
$decisoesDir = Join-Path $projectDir "CLIENTES\$cliUp\CLAUDE_PROJECT\DECISOES"

function Read-Chave {
    param([string]$key)
    if (-not (Test-Path $chaves)) { return "" }
    foreach ($l in (Get-Content $chaves -Encoding UTF8 -ErrorAction SilentlyContinue)) {
        if ($l -match "^\s*$([regex]::Escape($key))\s*=\s*(.+)$") { return $matches[1].Trim() }
    }
    return ""
}

$token = Read-Chave "GITHUB_PAT_READONLY"
if (-not $token) {
    Write-Host "[P-072] GITHUB_PAT_READONLY nao encontrado." -ForegroundColor Red; exit 1
}

$headers = @{
    "Authorization" = "token $token"
    "Accept"        = "application/vnd.github.v3+json"
    "User-Agent"    = "Vanguard-P072"
}

# Baixar arquivo
$dlUrl = "https://raw.githubusercontent.com/$githubRepo/master/VEREDITOS/$arquivo"
try {
    $resp = Invoke-WebRequest -Uri $dlUrl -Headers $headers -UseBasicParsing -ErrorAction Stop
    $v    = $resp.Content | ConvertFrom-Json
} catch {
    Write-Host "[P-072] Erro ao baixar $arquivo : $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== APLICAR VEREDITO TELEGRAM ===" -ForegroundColor Cyan
Write-Host "  Arquivo  : $arquivo"
Write-Host "  Cliente  : $cliUp"
Write-Host "  Data/Hora: $($v.dataHora)"
Write-Host "  Itens    : $(($v.itens | ForEach-Object { "$($_.id):$($_.veredito)" }) -join ', ')"
Write-Host ""

if (-not (Test-Path $decisoesDir)) {
    Write-Host "[AVISO] Pasta DECISOES nao existe para $cliUp." -ForegroundColor Yellow
    Write-Host "  Salvar veredito como referencia em: $decisoesDir"
    New-Item -ItemType Directory -Force $decisoesDir | Out-Null
    $resp.Content | Set-Content (Join-Path $decisoesDir $arquivo) -Encoding UTF8
    Write-Host "  [SALVO] $arquivo copiado para referencia."
    Add-Content $logFile $arquivo -Encoding UTF8
    exit 0
}

# Encontrar DECISOES.json mais recente
$decisoesFiles = @(Get-ChildItem $decisoesDir -Filter "DECISOES_*.json" -ErrorAction SilentlyContinue |
                   Sort-Object LastWriteTime -Descending)

if ($decisoesFiles.Count -eq 0) {
    Write-Host "[AVISO] Nenhum DECISOES_*.json em $decisoesDir" -ForegroundColor Yellow
    $resp.Content | Set-Content (Join-Path $decisoesDir $arquivo) -Encoding UTF8
    Write-Host "  [SALVO] $arquivo copiado. Processar manualmente quando DECISOES.json existir."
    Add-Content $logFile $arquivo -Encoding UTF8
    exit 0
}

$df = $decisoesFiles[0]
Write-Host "DECISOES target: $($df.Name)"

try {
    $decisoes = Get-Content $df.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Host "[ERRO] Falha ao ler $($df.Name): $($_.Exception.Message)" -ForegroundColor Red; exit 1
}

# Aplicar
$aplicados   = 0
$naoEncontrados = @()
foreach ($item in $v.itens) {
    # Decisoes podem estar em .decisoes[] ou direto na raiz como array
    $decisao = $null
    if ($decisoes.decisoes) {
        $decisao = $decisoes.decisoes | Where-Object { $_.id -eq $item.id } | Select-Object -First 1
    }
    if (-not $decisao -and $decisoes -is [System.Array]) {
        $decisao = $decisoes | Where-Object { $_.id -eq $item.id } | Select-Object -First 1
    }

    if (-not $decisao) {
        $naoEncontrados += $item.id
        continue
    }

    $decisao | Add-Member -NotePropertyName "veredito"       -NotePropertyValue $item.veredito          -Force
    $decisao | Add-Member -NotePropertyName "veredito_em"    -NotePropertyValue $v.dataHora             -Force
    $decisao | Add-Member -NotePropertyName "veredito_fonte" -NotePropertyValue "Telegram-W7"           -Force
    $aplicados++
    $label = switch ($item.veredito) { "A" { "APROVADO" } "B" { "REJEITADO" } "C" { "ADIADO" } default { $item.veredito } }
    Write-Host "  [OK] $($item.id) -> $label" -ForegroundColor Green
}

if ($naoEncontrados.Count -gt 0) {
    Write-Host "  [AVISO] IDs nao encontrados em $($df.Name): $($naoEncontrados -join ', ')" -ForegroundColor Yellow
}

if ($aplicados -gt 0) {
    $json = $decisoes | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText($df.FullName, $json, [System.Text.Encoding]::UTF8)
    Write-Host ""
    Write-Host "  [SALVO] $($df.Name) -- $aplicados veredito(s) aplicado(s)" -ForegroundColor Green
}

# Copiar VEREDITO localmente
$resp.Content | Set-Content (Join-Path $decisoesDir $arquivo) -Encoding UTF8

# Marcar como processado
Add-Content $logFile $arquivo -Encoding UTF8

Write-Host ""
Write-Host "  [P-072] $arquivo marcado como processado." -ForegroundColor Green
Write-Host "  Proximo: atualizar MEMORIA_EMBAIXADOR (P-032) e commitar."
