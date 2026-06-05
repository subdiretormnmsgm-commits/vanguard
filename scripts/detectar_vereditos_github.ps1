#Requires -Version 5.1
# detectar_vereditos_github.ps1 -- P-072
# Verifica VEREDITOS nao processados no GitHub (subdiretormnmsgm-commits/vanguard/VEREDITOS/)
# Chamado pelo session_start -- retorna bloco de texto para injetar no contexto do Musculo.
# Silencioso se nenhum veredito pendente.
#
# Saida de alerta (para session_start injetar):
#   VEREDITOS TELEGRAM PENDENTES -- N arquivo(s) nao processado(s)
#   [VEREDITOS_YYYYMMDDHHNN.json] D1:A D2:B -- data
#   Musculo: confirmar cliente -> .\scripts\aplicar_veredito_telegram.ps1 -arquivo X -cliente Y

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectDir = Split-Path -Parent $PSScriptRoot
$chaves     = Join-Path $projectDir "CHAVES_SISTEMA_VANGUARD.txt"
$logFile    = Join-Path $PSScriptRoot ".vereditos_processados.log"
$githubRepo = "subdiretormnmsgm-commits/vanguard"
$vereditosPath = "VEREDITOS"

function Read-Chave {
    param([string]$key)
    if (-not (Test-Path $chaves)) { return "" }
    foreach ($l in (Get-Content $chaves -Encoding UTF8 -ErrorAction SilentlyContinue)) {
        if ($l -match "^\s*$([regex]::Escape($key))\s*=\s*(.+)$") { return $matches[1].Trim() }
    }
    return ""
}

$token = Read-Chave "GITHUB_PAT_READONLY"
if (-not $token) { exit 0 }  # silencioso se sem token

# Ler processados
$processados = @{}
if (Test-Path $logFile) {
    Get-Content $logFile -Encoding UTF8 -ErrorAction SilentlyContinue |
        Where-Object { $_.Trim() } |
        ForEach-Object { $processados[$_.Trim()] = $true }
}

# Listar VEREDITOS/ no GitHub
$headers = @{
    "Authorization" = "token $token"
    "Accept"        = "application/vnd.github.v3+json"
    "User-Agent"    = "Vanguard-P072"
}
try {
    $resp   = Invoke-WebRequest -Uri "https://api.github.com/repos/$githubRepo/contents/$vereditosPath" `
                                -Headers $headers -UseBasicParsing -ErrorAction Stop
    $items  = $resp.Content | ConvertFrom-Json
} catch {
    exit 0  # falha silenciosa: GitHub indisponivel nao bloqueia sessao
}

$novos = @($items | Where-Object { $_.name -match "^VEREDITOS_\d{12}\.json$" -and -not $processados.ContainsKey($_.name) } |
           Sort-Object { $_.name })

if ($novos.Count -eq 0) { exit 0 }  # tudo processado -- silencio

$linhas = @("VEREDITOS TELEGRAM PENDENTES -- $($novos.Count) arquivo(s) nao processado(s)")
$linhas += ""

foreach ($arq in $novos) {
    # Baixar conteudo para mostrar resumo
    try {
        $dlResp = Invoke-WebRequest -Uri $arq.download_url -Headers $headers -UseBasicParsing -ErrorAction Stop
        $v = $dlResp.Content | ConvertFrom-Json
        $itensStr = if ($v.itens) {
            ($v.itens | ForEach-Object { "$($_.id):$($_.veredito)" }) -join " "
        } elseif ($v.tipo -eq "veredito") {
            "veredito-simples"
        } else { "?" }
        $dataHora = if ($v.dataHora) { $v.dataHora } else { "?" }
        $linhas  += "  [$($arq.name)]  $itensStr  --  $dataHora"
    } catch {
        $linhas += "  [$($arq.name)]  (erro ao ler conteudo)"
    }
}

$linhas += ""
$linhas += "Musculo: identificar cliente e processar:"
$linhas += "  .\scripts\aplicar_veredito_telegram.ps1 -arquivo VEREDITOS_XXXXXX.json -cliente INGRID"
$linhas += "  (ou -cliente VALDECE, etc.)"

Write-Output ($linhas -join "`n")
