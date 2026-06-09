# n8n_disable_notion_writers.ps1 -- SINGLE WRITER do Notion (P-128 / desafio #1, 2026-06-09)
# Desliga (disabled:true) APENAS os nodes que ESCREVEM no Notion (httpRequest -> .../blocks/{id}/children)
# nos workflows vivos do n8n cloud. Motivo: esses nodes fazem APPEND e empilham nas mesmas paginas
# (WIP / Pendentes / Ledger) que scripts/notion_sync.ps1 faz wipe+rewrite -> conflito de escritores.
# notion_sync.ps1 passa a ser o UNICO escritor. Telegram / W-8 Sinal / Limpar Pendentes seguem intactos
# (downstream NAO usa a resposta do Notion -- verificado em 2026-06-09).
# SEGURANCA: faz backup completo de cada workflow ANTES do PUT. Rollback = re-PUT do backup.
# Uso:  .\scripts\n8n_disable_notion_writers.ps1            (aplica)
#       .\scripts\n8n_disable_notion_writers.ps1 -DryRun    (so mostra o que faria)
#       .\scripts\n8n_disable_notion_writers.ps1 -Rollback  (restaura do ultimo backup)
param([switch]$DryRun, [switch]$Rollback)

$ErrorActionPreference = 'Stop'
$RAIZ   = Split-Path $PSScriptRoot -Parent
$CHAVES = Join-Path $RAIZ 'CHAVES_SISTEMA_VANGUARD.txt'
$BKDIR  = Join-Path $RAIZ '_n8n\backup_pre_singlewriter'
if (-not (Test-Path $CHAVES)) { Write-Output 'CHAVES nao encontrado.'; exit 1 }

$chaves = Get-Content -Raw $CHAVES
$key  = ([regex]'N8N_API_KEY\s*=\s*(\S+)').Match($chaves).Groups[1].Value
$host0 = ([regex]'N8N_HOST\s*=\s*(\S+)').Match($chaves).Groups[1].Value
if (-not $host0) { $host0 = 'https://vanguard-vanguard-n8n.0ul9nk.easypanel.host' }
$host0 = $host0.TrimEnd('/')
if (-not $key) { Write-Output 'N8N_API_KEY ausente.'; exit 1 }
$h = @{ 'X-N8N-API-KEY' = $key }

function Is-NotionWriter($n) {
    $u = [string]$n.parameters.url
    return ($n.type -match 'httpRequest') -and ($u -match 'notion') -and ($u -match '/children')
}
function Sanitize-Settings($s) {
    # A Public API rejeita campos extras (additionalProperties:false). Manter so a whitelist valida.
    $ok = 'saveExecutionProgress','saveManualExecutions','saveDataErrorExecution','saveDataSuccessExecution','executionTimeout','errorWorkflow','timezone','executionOrder'
    $out = @{}
    if ($s) { foreach ($p in $s.PSObject.Properties) { if ($ok -contains $p.Name) { $out[$p.Name] = $p.Value } } }
    if (-not $out.ContainsKey('executionOrder')) { $out['executionOrder'] = 'v1' }
    return $out
}
function Put-Workflow($id, $wf) {
    # Public API aceita apenas: name, nodes, connections, settings (settings sanitizado)
    $body = @{ name = $wf.name; nodes = $wf.nodes; connections = $wf.connections; settings = (Sanitize-Settings $wf.settings) }
    $json = $body | ConvertTo-Json -Depth 60 -Compress
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    Invoke-RestMethod -Uri "$host0/api/v1/workflows/$id" -Headers $h -Method Put -Body $bytes -ContentType 'application/json; charset=utf-8' -TimeoutSec 30
}

# ----------------- ROLLBACK -----------------
if ($Rollback) {
    if (-not (Test-Path $BKDIR)) { Write-Output 'Sem backup para rollback.'; exit 1 }
    Get-ChildItem $BKDIR -Filter '*.json' | ForEach-Object {
        $wf = Get-Content -Raw $_.FullName | ConvertFrom-Json
        $id = $_.BaseName
        try { Put-Workflow $id $wf | Out-Null; Write-Output "ROLLBACK OK: $($wf.name) ($id)" }
        catch { Write-Output "ROLLBACK FALHOU: $id -- $($_.Exception.Message)" }
        Start-Sleep -Milliseconds 300
    }
    exit 0
}

# ----------------- APLICAR -----------------
if (-not (Test-Path $BKDIR)) { New-Item -ItemType Directory -Path $BKDIR -Force | Out-Null }
$lista = Invoke-RestMethod -Uri "$host0/api/v1/workflows?limit=200" -Headers $h -Method Get -TimeoutSec 30
$totalNodes = 0; $totalWf = 0

foreach ($w in $lista.data) {
    $alvos = @($w.nodes | Where-Object { (Is-NotionWriter $_) -and (-not $_.disabled) })
    if ($alvos.Count -eq 0) { continue }
    $totalWf++
    Write-Output ("WORKFLOW: {0} ({1}) active={2}" -f $w.name, $w.id, $w.active)

    if ($DryRun) {
        $alvos | ForEach-Object { Write-Output ("    [DRY] desligaria node '{0}'" -f $_.name); $totalNodes++ }
        continue
    }

    # backup completo ANTES de tocar (rollback)
    $full = Invoke-RestMethod -Uri "$host0/api/v1/workflows/$($w.id)" -Headers $h -Method Get -TimeoutSec 30
    ($full | ConvertTo-Json -Depth 60) | Out-File -FilePath (Join-Path $BKDIR "$($w.id).json") -Encoding utf8

    foreach ($n in $full.nodes) {
        if ((Is-NotionWriter $n) -and (-not $n.disabled)) {
            $n | Add-Member -NotePropertyName disabled -NotePropertyValue $true -Force
            Write-Output ("    desligado: '{0}'" -f $n.name); $totalNodes++
        }
    }
    try {
        Put-Workflow $w.id $full | Out-Null
        # re-verificar
        $chk = Invoke-RestMethod -Uri "$host0/api/v1/workflows/$($w.id)" -Headers $h -Method Get -TimeoutSec 30
        $aindaAtivos = @($chk.nodes | Where-Object { (Is-NotionWriter $_) -and (-not $_.disabled) }).Count
        Write-Output ("    PUT OK -- active={0} -- nodes-escrita-notion ainda ativos: {1}" -f $chk.active, $aindaAtivos)
    } catch {
        Write-Output ("    PUT FALHOU: {0} -- restaure com -Rollback" -f $_.Exception.Message)
    }
    Start-Sleep -Milliseconds 300
}

Write-Output ""
if ($DryRun) { Write-Output ("[DRY-RUN] {0} node(s) de escrita Notion em {1} workflow(s) seriam desligados." -f $totalNodes, $totalWf) }
else { Write-Output ("CONCLUIDO: {0} node(s) desligados em {1} workflow(s). Backups em _n8n\backup_pre_singlewriter\" -f $totalNodes, $totalWf) }
