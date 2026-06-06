# sync_guard.ps1 -- Guardiao de Integridade de Documentos
# Detecta divergencias entre fontes canonicas e copias declaradas em FONTES_DE_VERDADE.json
# FASE 2 do SYNC_GUARD -- Pentalateral IAH -- 2026-06-06
#
# Uso:
#   -Abertura      Relatorio de divergencias -- nao bloqueia
#   -Fechamento    Bloqueia session_close (exit 1) se houver divergencias bloqueantes
#   -AutoCorrigir  Copia fontes sobre copias automaticamente (usar com cautela)
#   -Silencioso    Output JSON puro -- para n8n (sem display visual)
#
# P-033: sync universal obrigatorio apos qualquer mudanca em PENTALATERAL_UNIVERSAL/
# Integrado: session_start.ps1 (-Abertura) + session_close.ps1 (-Fechamento)

param(
    [switch]$Abertura,
    [switch]$Fechamento,
    [switch]$AutoCorrigir,
    [switch]$Silencioso
)

if (-not ($Abertura -or $Fechamento)) {
    if (-not $Silencioso) {
        Write-Host "[sync_guard] Uso: -Abertura (relatorio) | -Fechamento (bloqueante)" -ForegroundColor Yellow
        Write-Host "             Opcional: -AutoCorrigir | -Silencioso" -ForegroundColor DarkGray
    }
    exit 0
}

$BASE = Split-Path $PSScriptRoot -Parent
$FONTES_PATH = Join-Path $BASE "PENTALATERAL_UNIVERSAL\OPERACAO\FONTES_DE_VERDADE.json"

if (-not (Test-Path $FONTES_PATH)) {
    if (-not $Silencioso) {
        Write-Host "[sync_guard] FONTES_DE_VERDADE.json nao encontrado em OPERACAO/ -- skip" -ForegroundColor DarkGray
    }
    exit 0
}

function Get-FileMD5 {
    param([string]$path)
    if (-not (Test-Path $path)) { return "AUSENTE" }
    return (Get-FileHash $path -Algorithm MD5).Hash.ToLower()
}

$config = Get-Content $FONTES_PATH -Raw -Encoding UTF8 | ConvertFrom-Json
$pares = $config.pares

$divergencias = [System.Collections.Generic.List[hashtable]]::new()
$corrigidos = [System.Collections.Generic.List[string]]::new()
$okCount = 0

foreach ($par in $pares) {
    $fonteAbs = Join-Path $BASE $par.fonte
    $hashFonte = Get-FileMD5 $fonteAbs

    if ($hashFonte -eq "AUSENTE") {
        if (-not $Silencioso) {
            Write-Host "  [ALERTA] Fonte nao encontrada: $($par.fonte)" -ForegroundColor DarkYellow
        }
        continue
    }

    foreach ($copia in $par.copias) {
        $copiaAbs = Join-Path $BASE $copia
        $hashCopia = Get-FileMD5 $copiaAbs

        if ($hashCopia -eq $hashFonte) {
            $okCount++
            continue
        }

        $div = @{
            id         = $par.id
            tipo       = if ($hashCopia -eq "AUSENTE") { "AUSENTE" } else { "DIVERGENTE" }
            fonte      = $par.fonte
            copia      = $copia
            hash_fonte = $hashFonte
            hash_copia = $hashCopia
            bloqueante = [bool]$par.bloqueante_fechamento
        }
        $divergencias.Add($div)

        if ($AutoCorrigir) {
            $dir = Split-Path $copiaAbs -Parent
            if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
            Copy-Item $fonteAbs $copiaAbs -Force
            $corrigidos.Add($copia)
        }
    }
}

$divergenciasBloqueantes = @($divergencias | Where-Object { $_.bloqueante })
$divergenciasInfo        = @($divergencias | Where-Object { -not $_.bloqueante })

# --- OUTPUT SILENCIOSO (JSON para n8n) ---

if ($Silencioso) {
    $result = @{
        timestamp               = (Get-Date -Format "yyyy-MM-dd HH:mm")
        divergencias_total      = $divergencias.Count
        divergencias_bloqueantes = $divergenciasBloqueantes.Count
        divergencias_info       = $divergenciasInfo.Count
        corrigidos              = $corrigidos.Count
        ok                      = $okCount
        divergencias            = @($divergencias)
        corrigidos_lista        = @($corrigidos)
    }
    $result | ConvertTo-Json -Depth 5
    if ($Fechamento -and $divergenciasBloqueantes.Count -gt 0) { exit 1 }
    exit 0
}

# --- OUTPUT VISUAL ---

$modo = if ($Abertura) { "ABERTURA" } else { "FECHAMENTO" }
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  SYNC_GUARD -- $modo -- $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor Cyan
Write-Host "  Pares: $($pares.Count) | OK: $okCount | Divergentes: $($divergencias.Count)" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan

if ($divergencias.Count -eq 0) {
    Write-Host "  [VERDE] Integridade OK -- todas as copias coincidem com a fonte canonica" -ForegroundColor Green
    Write-Host ""
    exit 0
}

Write-Host ""

if ($divergenciasBloqueantes.Count -gt 0) {
    Write-Host "  [VERMELHO] $($divergenciasBloqueantes.Count) divergencia(s) BLOQUEANTE(s):" -ForegroundColor Red
    foreach ($d in $divergenciasBloqueantes) {
        Write-Host "    >> [$($d.tipo)] $($d.copia)" -ForegroundColor Red
        Write-Host "       Fonte:  $($d.hash_fonte)" -ForegroundColor DarkRed
        Write-Host "       Copia:  $($d.hash_copia)" -ForegroundColor DarkRed
        Write-Host "       Fonte canonica: $($d.fonte)" -ForegroundColor DarkGray
    }
    Write-Host ""
}

if ($divergenciasInfo.Count -gt 0) {
    Write-Host "  [AMARELO] $($divergenciasInfo.Count) divergencia(s) informativa(s) (nao bloqueante):" -ForegroundColor Yellow
    foreach ($d in $divergenciasInfo) {
        Write-Host "    >> [$($d.tipo)] $($d.copia)" -ForegroundColor Yellow
        Write-Host "       Fonte canonica: $($d.fonte)" -ForegroundColor DarkGray
    }
    Write-Host ""
}

if ($AutoCorrigir -and $corrigidos.Count -gt 0) {
    Write-Host "  [AUTO-CORRIGIDO] $($corrigidos.Count) copia(s) restauradas a partir da fonte:" -ForegroundColor Cyan
    foreach ($c in $corrigidos) { Write-Host "    [OK] $c" -ForegroundColor Green }
    Write-Host ""
}

if ($Abertura -and $divergenciasBloqueantes.Count -gt 0 -and -not $AutoCorrigir) {
    Write-Host "  [ACAO] Edite a fonte canonical e rode propagate_changes.ps1" -ForegroundColor Yellow
    Write-Host "         Ou use -AutoCorrigir para copiar automaticamente" -ForegroundColor DarkGray
    Write-Host ""
}

if ($Fechamento -and $divergenciasBloqueantes.Count -gt 0) {
    Write-Host "  [BLOQUEIO] session_close BLOQUEADO -- $($divergenciasBloqueantes.Count) divergencia(s) critica(s)" -ForegroundColor Red
    Write-Host "  ACAO: corrija a divergencia ou use -AutoCorrigir antes de fechar" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

exit 0
