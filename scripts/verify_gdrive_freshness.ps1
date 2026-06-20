# verify_gdrive_freshness.ps1 -- Gate: verifica se os arquivos do perfil EXISTEM localmente
# e se o ultimo rclone sync rodou APOS a modificacao mais recente (Drive em dia).
# P-168: a idade (mtime) de cada arquivo e apenas informativa -- NAO bloqueia. Docs estaticos
# nao mudam todo loop; o que importa e o Drive ter a versao atual (sync apos modificacao).
# Uso: .\verify_gdrive_freshness.ps1 -Perfil [ENCERRAMENTO|VANGUARD|INGRID|VALDECE] [-AutoSync]
# Exit 0 = Drive em dia | Exit 1 = sync necessario antes de acionar Embaixador
# P-169 (-AutoSync): se o unico problema for de SYNC (Drive atras do local ou sem log), roda
# rclone sync sozinho e re-valida -- fecha o ciclo G1/G2/G4 sem o Diretor pedir. NAO auto-sincroniza
# se houver arquivo LOCAL AUSENTE (rclone mirror apagaria o arquivo do Drive).
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("ENCERRAMENTO","VANGUARD","INGRID","VALDECE","CONSELHO")]
    [string]$Perfil,
    [int]$ThresholdHoras = 3,
    [switch]$AutoSync
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
    # G5 (Loop 35): perfil CONSELHO -- arquivos de definicao dos atores lidos via Drive-First.
    # Antes do G5 o gate era cego a estes caminhos (mapa fixo VANGUARD nao os cobria) -> VERDE
    # enganoso entregava prompt velho ao ator. Agora a verificacao data+hora (P-168) os cobre.
    "CONSELHO" = [ordered]@{
        "1. SP_PROJETISTA"               = "CONSELHO\SYSTEM_PROMPT_PROJETISTA.md"
        "2. SP_EMBAIXADOR_DIGITAL"       = "CONSELHO\SYSTEM_PROMPT_EMBAIXADOR_DIGITAL.md"
        "3. SP_DETECTOR_DERIVA"          = "CONSELHO\SYSTEM_PROMPT_DETECTOR_DERIVA.md"
        "4. TASKS_COWORK_PROJETISTA"     = "CONSELHO\TASKS_COWORK_PROJETISTA.md"
        "5. TASKS_COWORK_EMB_DIGITAL"    = "CONSELHO\TASKS_COWORK_EMBAIXADOR_DIGITAL.md"
        "6. TPL_INSTR_PROJETISTA"        = "PENTALATERAL_UNIVERSAL\CLAUDE_PROJECTS\TEMPLATE_INSTRUCAO_PROJETISTA.md"
        "7. TPL_INSTR_EMB_DIGITAL"       = "PENTALATERAL_UNIVERSAL\CLAUDE_PROJECTS\TEMPLATE_INSTRUCAO_EMBAIXADOR_DIGITAL.md"
        "8. MEMORIA_PROJETISTA"          = "PENTALATERAL_UNIVERSAL\CLAUDE_PROJECTS\MEMORIA_PROJETISTA.md"
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
        # P-168: idade do arquivo NAO bloqueia. Docs estaticos (intel/timeline) e MEMORIA
        # (atualizada apos o PASSO7 via P-032) nao mudam todo loop. O que garante que o
        # Embaixador le a versao atual no Drive e o sync ter rodado APOS a ultima modificacao
        # -- validado no PASSO 2. Bloquear por mtime gera falso positivo e desperdicio de token.
        Write-Host ("  [INFO  ] {0,-40} {1}h atras (estavel -- validado pelo sync no PASSO 2)" -f $lbl, $deltaH) -ForegroundColor DarkGray
    }
}

# PASSO 2 -- Verificar que o ultimo rclone sync rodou APOS a modificacao mais recente
Write-Host ""
Write-Host "  [2/2] Verificando ultimo sync rclone..." -ForegroundColor DarkGray
$desktop  = [Environment]::GetFolderPath("Desktop")
# P-168 (data+hora, nao data): NAO filtrar log por data. Filtrar por data fazia sessoes no
# mesmo dia ficarem desatualizadas -- o gate perguntava "tem sync de hoje?" em vez de "o sync
# rodou APOS a ultima modificacao?". Ex: mod 09h -> sync 09h05 (OK) -> mod 14h: a 2a sessao
# via "houve sync hoje" e passava o arquivo das 14h sem re-sync. Pegamos o log mais recente
# por LastWriteTime (data+hora) e comparamos datetime contra a ultima modificacao local.
$logsTodos = Get-ChildItem "$desktop\rclone_sync_*.txt" -ErrorAction SilentlyContinue |
             Sort-Object LastWriteTime -Descending

if (-not $logsTodos) {
    Write-Host "  [SYNC   ] Nenhum log de sync rclone encontrado -- Drive pode estar desatualizado" -ForegroundColor Red
    Write-Host "            Acao: rodar Gate 10 (session_close.ps1) ou rclone sync manualmente" -ForegroundColor Yellow
    $stale.Add("SYNC-NENHUM-LOG")
} else {
    $logMaisRecente   = $logsTodos[0]
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

# PASSO 2.5 -- AutoSync (P-169 G1/G2/G4): se o unico problema for de SYNC, corrigir sozinho
$staleSyncTags = @("SYNC-NENHUM-LOG","SYNC-ANTERIOR-A-MODIFICACAO")
$temSyncStale  = (@($stale | Where-Object { $staleSyncTags -contains $_ }).Count) -gt 0
$naoAutoFix    = @($stale | Where-Object { $staleSyncTags -notcontains $_ })
if ($AutoSync -and $temSyncStale -and ($naoAutoFix.Count -eq 0)) {
    Write-Host ""
    if (-not $rcloneCmd) {
        Write-Host "  [AUTOSYNC] rclone nao encontrado -- nao foi possivel auto-sincronizar" -ForegroundColor Red
    } else {
        Write-Host "  [AUTOSYNC] P-169 -- Drive atras do local. Rodando rclone sync..." -ForegroundColor Yellow
        $stamp   = Get-Date -Format "yyyyMMdd_HHmmss"
        $logNovo = Join-Path $desktop "rclone_sync_$stamp.txt"
        # P-185 (HV-1): nunca empurrar credenciais ao Drive -- filtro espelha o .gitignore
        $secretsExclude = Join-Path $PSScriptRoot "rclone_secrets_exclude.txt"
        & $rcloneCmd sync $RAIZ "gdrive:vanguard" --exclude ".git/**" --exclude ".playwright-mcp/**" --exclude ".serena/**" --exclude "node_modules/**" --exclude "*.pyc" --exclude ".claude/skills/awesome-claude-skills-master/**" --exclude-from $secretsExclude --log-file $logNovo --log-level INFO
        $rc = $LASTEXITCODE
        if ($rc -eq 0) {
            $syncTime2   = (Get-Item $logNovo).LastWriteTime
            $logContent2 = Get-Content $logNovo -ErrorAction SilentlyContinue
            $temErro2    = $logContent2 | Where-Object { $_ -match "^.*ERROR" } | Select-Object -First 1
            if (($syncTime2 -gt $ultimaModLocal) -and (-not $temErro2)) {
                $restantes = @($stale | Where-Object { $staleSyncTags -notcontains $_ })
                $stale = [System.Collections.Generic.List[string]]::new()
                foreach ($r in $restantes) { $stale.Add($r) }
                $lagMin2 = [math]::Round(($syncTime2 - $ultimaModLocal).TotalMinutes, 0)
                Write-Host ("  [AUTOSYNC] OK -- sync {0} ({1}min apos ultima modificacao). Drive em dia." -f $syncTime2.ToString("HH:mm"), $lagMin2) -ForegroundColor Green
            } else {
                Write-Host "  [AUTOSYNC] Sync rodou mas ainda inconsistente -- verificar log: $logNovo" -ForegroundColor Red
            }
        } else {
            Write-Host "  [AUTOSYNC] rclone exit $rc -- sync falhou. Ver log: $logNovo" -ForegroundColor Red
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
    Write-Host "    1. Se arquivo LOCAL AUSENTE: gerar/restaurar o arquivo" -ForegroundColor Yellow
    Write-Host "    2. Se SYNC desatualizado/com erro: rodar rclone sync (Gate 10 ou manual)" -ForegroundColor Yellow
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
