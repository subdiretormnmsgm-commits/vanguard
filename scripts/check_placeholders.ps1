#Requires -Version 5.1
# check_placeholders.ps1 -- S3a DEF-M-6 patch (2026-06-12)
# Detecta placeholders em arquivos antes do commit. Leve -- sem pre-commit hook.
# Uso: .\scripts\check_placeholders.ps1 [-Arquivo "caminho.ps1"] [-Pasta "scripts\"] [-Extensoes @("ps1","md")]
# Sem parametros: varre scripts\ + PROTOCOLOS_ENCERRAMENTO\ por padrao.
# Exit 0 = limpo. Exit 1 = placeholders encontrados.

param(
    [string]$Arquivo   = "",
    [string]$Pasta     = "",
    [string[]]$Extensoes = @("ps1", "md", "txt", "json"),
    [switch]$Silencioso  # suprime output OK, so mostra falhas
)

$raiz = Split-Path -Parent $PSScriptRoot

# Padroes de placeholder que indicam entrega incompleta
# Estreitos para evitar falsos positivos em scripts que checam esses padroes
$padroes = @(
    '\[PREENCHER\b',
    '\[INSERIR\b',
    '\[COMPLETAR\b',
    '\[TODO\]\s',
    '\[FIXME\]\s',
    'Loop \?\?'
)
$regexCombinado = ($padroes -join "|")

# Montar lista de arquivos a verificar
$arquivos = @()
if ($Arquivo) {
    $p = if ([System.IO.Path]::IsPathRooted($Arquivo)) { $Arquivo } else { Join-Path $raiz $Arquivo }
    if (Test-Path $p) { $arquivos = @($p) }
    else { Write-Host "[ERRO] Arquivo nao encontrado: $p" -ForegroundColor Red; exit 1 }
} elseif ($Pasta) {
    $p = if ([System.IO.Path]::IsPathRooted($Pasta)) { $Pasta } else { Join-Path $raiz $Pasta }
    $arquivos = @(Get-ChildItem $p -Recurse -File | Where-Object { $Extensoes -contains $_.Extension.TrimStart('.') } | Select-Object -ExpandProperty FullName)
} else {
    # Padrao: scripts\ + PROTOCOLOS_ENCERRAMENTO\ (hoje)
    $data = Get-Date -Format "yyyy-MM-dd"
    $dirs = @(
        (Join-Path $raiz "scripts"),
        (Join-Path $raiz "PROTOCOLOS_ENCERRAMENTO")
    )
    foreach ($d in $dirs) {
        if (Test-Path $d) {
            $arquivos += @(Get-ChildItem $d -File | Where-Object { $Extensoes -contains $_.Extension.TrimStart('.') } | Select-Object -ExpandProperty FullName)
        }
    }
}

if ($arquivos.Count -eq 0) {
    Write-Host "[check_placeholders] Nenhum arquivo para verificar." -ForegroundColor DarkGray
    exit 0
}

$totalFalhas = 0
$arquivosComFalha = @()

foreach ($arq in $arquivos) {
    $nomeRel = $arq.Replace($raiz, "").TrimStart('\')
    # Autoexclusao: nao verificar scripts de deteccao/metaprogramacao + outputs gerados
    if ($nomeRel -match "check_placeholders|skill_parser_gate|gate_coerencia|n8n_audit|notion_|embaixador_msg_sessao") { continue }
    $linhas = @()
    try { $linhas = Get-Content $arq -Encoding UTF8 } catch { continue }

    $falhasArq = @()
    for ($i = 0; $i -lt $linhas.Count; $i++) {
        if ($linhas[$i] -match $regexCombinado) {
            $falhasArq += ("    Linha " + ($i + 1) + ": " + $linhas[$i].Trim())
        }
    }

    if ($falhasArq.Count -gt 0) {
        Write-Host ""
        Write-Host "  [PLACEHOLDER] $nomeRel" -ForegroundColor Red
        foreach ($f in $falhasArq) { Write-Host $f -ForegroundColor Yellow }
        $totalFalhas += $falhasArq.Count
        $arquivosComFalha += $nomeRel
    } elseif (-not $Silencioso) {
        Write-Host "  [OK] $nomeRel" -ForegroundColor DarkGreen
    }
}

Write-Host ""
if ($totalFalhas -gt 0) {
    Write-Host "[check_placeholders] FALHOU -- $totalFalhas placeholder(s) em $($arquivosComFalha.Count) arquivo(s)." -ForegroundColor Red
    Write-Host "  Corrigir antes de commitar." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "[check_placeholders] LIMPO -- nenhum placeholder encontrado em $($arquivos.Count) arquivo(s)." -ForegroundColor Green
    exit 0
}
