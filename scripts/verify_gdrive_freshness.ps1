# verify_gdrive_freshness.ps1 -- Gate: verifica se arquivos do perfil estao frescos localmente
# e se o ultimo rclone sync rodou APOS a modificacao mais recente.
# Uso: .\verify_gdrive_freshness.ps1 -Perfil [ENCERRAMENTO|VANGUARD|INGRID|VALDECE]
# Exit 0 = Drive em dia | Exit 1 = sync necessario antes de acionar Embaixador
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("ENCERRAMENTO","VANGUARD","INGRID","VALDECE")]
    [string]$Perfil,
    [int]$ThresholdHoras = 3
)

$RAIZ = Split-Path $PSScriptRoot -Parent
$dataHoje = Get-Date -Format "yyyy-MM-dd"
$agora = Get-Date

$rcloneFallback = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Rclone.Rclone_Microsoft.Winget.Source_8wekyb3d8bbwe\rclone-v1.74.3-windows-amd64\rclone.exe"
$_rcloneObj = Get-Command rclone -ErrorAction SilentlyContinue
$rcloneCmd = if ($_rcloneObj) { $_rcloneObj.Source } else { $null }
if (-not $rcloneCmd -and (Test-Path $rcloneFallback)) { $rcloneCmd = $rcloneFallback }

# Mapa de arquivos por perfil
$mapas = @{
    "ENCERRAMENTO" = [ordered]@{
        "1. PAINEL_ATIVIDADES"           = "PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_$dataHoje.md"
        "2. CONTEXTO_SESSAO_DIRETOR"     = "PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$dataHoje.md"
        "3. WIP_BOARD.json"              = "CLIENTES\WIP_BOARD.json"
        "4. INTELLIGENCE_LEDGER.md"      = "INTELLIGENCE_LEDGER.md"
        "5. PENDENTES.md"                = "PENDENTES.md"
        "6. 16_VANGUARD_TIMELINE"        = "CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
        "7. MEMORIA_EMBAIXADOR_VANGUARD" = "CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md"
    }
    "VANGUARD" = [ordered]@{
        "1. INTENCAO_LINKEDIN"           = "CLIENTES\VANGUARD\INTENCAO_LINKEDIN.md"
        "2. NICHE_INDEX.json"            = "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\NICHE_INDEX.json"
        "3. LEDGER_INBOX.md"             = "LEDGER_INBOX.md"
        "4. LOOP_STATE.json"             = "CLIENTES\VANGUARD\CLAUDE_PROJECT\LOOP_STATE.json"
        "5. PENDENTES.md"                = "PENDENTES.md"
        "6. WIP_BOARD.json"              = "CLIENTES\WIP_BOARD.json"
        "7. INTELLIGENCE_LEDGER.md"      = "INTELLIGENCE_LEDGER.md"
        "8. MEMORIA_EMBAIXADOR_VANGUARD" = "CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md"
        "9. 16_VANGUARD_TIMELINE"        = "CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
    }
    "INGRID" = [ordered]@{
        "1. MEMORIA_EMBAIXADOR"          = "CLIENTES\INGRID\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
        "2. LOOP_STATE.json"             = "CLIENTES\INGRID\CLAUDE_PROJECT\LOOP_STATE.json"
        "3. 07_WIP_BOARD.json"           = "CLIENTES\INGRID\CLAUDE_PROJECT\07_WIP_BOARD.json"
        "4. 06_INTELLIGENCE_LEDGER.md"   = "CLIENTES\INGRID\CLAUDE_PROJECT\06_INTELLIGENCE_LEDGER.md"
        "5. 16_VANGUARD_TIMELINE"        = "CLIENTES\INGRID\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
        "6. PERFIL_CLIENTE_INGRID"       = "CLIENTES\INGRID\CLAUDE_PROJECT\PERFIL_CLIENTE_INGRID.md"
        "7. PERFIL_NICHO_EDTECH"         = "CLIENTES\INGRID\CLAUDE_PROJECT\PERFIL_NICHO_EDTECH_V1.md"
    }
    "VALDECE" = [ordered]@{
        "1. MEMORIA_EMBAIXADOR"          = "CLIENTES\VALDECE\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
        "2. LOOP_STATE.json"             = "CLIENTES\VALDECE\CLAUDE_PROJECT\LOOP_STATE.json"
        "3. 07_WIP_BOARD.json"           = "CLIENTES\VALDECE\CLAUDE_PROJECT\07_WIP_BOARD.json"
        "4. 06_INTELLIGENCE_LEDGER.md"   = "CLIENTES\VALDECE\CLAUDE_PROJECT\06_INTELLIGENCE_LEDGER.md"
        "5. 16_VANGUARD_TIMELINE"        = "CLIENTES\VALDECE\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
        "6. PERFIL_NICHO_LEGALTECH"      = "CLIENTES\VALDECE\CLAUDE_PROJECT\PERFIL_NICHO_LEGALTECH_V1.md"
    }
}

$mapa = $mapas[$Perfil]
$stale = [System.Collections.Generic.List[string]]::new()
$ultimaModLocal = [datetime]::MinValue

Write-Host ""
Write-Host "  =======================================================" -ForegroundColor Cyan
Write-Host "  [DRIVE FRESHNESS] Perfil: $Perfil -- threshold: ${ThresholdHoras}h" -ForegroundColor Cyan
Write-Host "  =======================================================" -ForegroundColor Cyan
Write-Host ""

# PASSO 1 -- Verificar arquivos locais
Write-Host "  [1/2] Verificando arquivos locais..." -ForegroundColor DarkGray
foreach ($entry in $mapa.GetEnumerator()) {
    $lbl       = $entry.Key
    $localPath = Join-Path $RAIZ $entry.Value
    if (-not (Test-Path $localPath)) {
        Write-Host ("  [LOCAL AUSENTE] {0,-40} arquivo nao existe" -f $lbl) -ForegroundColor Red
        $stale.Add($lbl)
        continue
    }
    $mtime  = (Get-Item $localPath).LastWriteTime
    $deltaH = [math]::Round(($agora - $mtime).TotalHours, 1)
    if ($mtime -gt $ultimaModLocal) { $ultimaModLocal = $mtime }
    if ($deltaH -le $ThresholdHoras) {
        Write-Host ("  [OK    ] {0,-40} {1}h atras" -f $lbl, $deltaH) -ForegroundColor Green
    } else {
        Write-Host ("  [STALE ] {0,-40} {1}h atras (max {2}h)" -f $lbl, $deltaH, $ThresholdHoras) -ForegroundColor Yellow
        $stale.Add($lbl)
    }
}

# PASSO 2 -- Verificar que o ultimo rclone sync rodou APOS a modificacao mais recente
Write-Host ""
Write-Host "  [2/2] Verificando ultimo sync rclone..." -ForegroundColor DarkGray
$desktop  = [Environment]::GetFolderPath("Desktop")
$logsHoje = Get-ChildItem "$desktop\rclone_sync_*.txt" -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match "rclone_sync_$($dataHoje -replace '-','')" } |
            Sort-Object LastWriteTime -Descending

if (-not $logsHoje) {
    Write-Host "  [SYNC   ] Nenhum log de sync encontrado hoje -- Drive pode estar desatualizado" -ForegroundColor Red
    Write-Host "            Acao: rodar Gate 10 (session_close.ps1) ou rclone sync manualmente" -ForegroundColor Yellow
    $stale.Add("SYNC-NAO-EXECUTADO-HOJE")
} else {
    $logMaisRecente   = $logsHoje[0]
    $syncTime         = $logMaisRecente.LastWriteTime
    $syncAposModLocal = $syncTime -gt $ultimaModLocal
    $logContent       = Get-Content $logMaisRecente.FullName -ErrorAction SilentlyContinue
    $temErro          = $logContent | Where-Object { $_ -match "^.*ERROR" } | Select-Object -First 1
    $syncOk           = $syncAposModLocal -and (-not $temErro)

    if ($syncOk) {
        $lagMin = [math]::Round(($syncTime - $ultimaModLocal).TotalMinutes, 0)
        Write-Host ("  [OK    ] Sync {0} -- {1}min apos ultima modificacao local" -f $syncTime.ToString("HH:mm"), $lagMin) -ForegroundColor Green
    } else {
        if (-not $syncAposModLocal) {
            Write-Host ("  [STALE ] Sync {0} -- anterior a ultima modificacao local ({1})" -f $syncTime.ToString("HH:mm"), $ultimaModLocal.ToString("HH:mm")) -ForegroundColor Red
            Write-Host "           Acao: rodar Gate 10 (rclone sync) antes de acionar o Embaixador" -ForegroundColor Yellow
            $stale.Add("SYNC-ANTERIOR-A-MODIFICACAO")
        }
        if ($temErro) {
            Write-Host ("  [ERRO  ] Sync com erros -- verificar log: {0}" -f $logMaisRecente.FullName) -ForegroundColor Red
            $stale.Add("SYNC-COM-ERROS")
        }
    }
}

# RESULTADO FINAL
Write-Host ""
Write-Host "  =======================================================" -ForegroundColor Cyan
if ($stale.Count -gt 0) {
    Write-Host "  [DRIVE FRESHNESS] BLOQUEIO -- $($stale.Count) problema(s) detectado(s):" -ForegroundColor Red
    foreach ($s in $stale) { Write-Host "    >> $s" -ForegroundColor Red }
    Write-Host ""
    Write-Host "  Acao antes de acionar o Embaixador:" -ForegroundColor Yellow
    Write-Host "    1. Atualizar arquivos locais desatualizados" -ForegroundColor Yellow
    Write-Host "    2. Rodar: .\scripts\session_close.ps1  (Gate 10 sincroniza)" -ForegroundColor Yellow
    Write-Host "    3. Re-executar este gate" -ForegroundColor Yellow
    Write-Host "  =======================================================" -ForegroundColor Cyan
    Write-Host ""
    exit 1
} else {
    Write-Host "  [DRIVE FRESHNESS] VERDE -- Drive em dia. Embaixador pode buscar em gdrive:vanguard" -ForegroundColor Green
    Write-Host "  =======================================================" -ForegroundColor Cyan
    Write-Host ""
    exit 0
}
