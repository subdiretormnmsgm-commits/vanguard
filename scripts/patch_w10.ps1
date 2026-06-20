#Requires -Version 5.1
# patch_w10.ps1 -- estende W-10 (8yvX4MBzdaK5l6IQ) com resumo POSITIVO de execucoes (S-3).
# In-place via PUT. Topologia intacta (9 nos): muda 1 URL (remove filtro status=error) + jsCode.
# W-10 ja e ativo -- PUT mantem ativo. Mudanca aditiva e backward-compatible.
# Uso: .\scripts\patch_w10.ps1

. "$PSScriptRoot\n8n_config.ps1"
if ([string]::IsNullOrWhiteSpace($N8N_API_KEY)) { Write-Error "N8N_API_KEY ausente"; exit 1 }

Add-Type -AssemblyName System.Web.Extensions
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$ser.MaxJsonLength = [int]::MaxValue
$headers = @{ "X-N8N-API-KEY" = $N8N_API_KEY }
$WID = "8yvX4MBzdaK5l6IQ"

function Clean($o) {
    if ($null -eq $o) { return $null }
    if ($o -is [string] -or $o -is [ValueType]) { return $o }
    if ($o -is [System.Collections.IEnumerable]) {
        $al = New-Object System.Collections.ArrayList
        foreach ($i in $o) { [void]$al.Add((Clean $i)) }
        return ,($al.ToArray())
    }
    if ($o -is [System.Management.Automation.PSCustomObject]) {
        $h = [ordered]@{}
        foreach ($p in $o.PSObject.Properties) { $h[$p.Name] = Clean $p.Value }
        return $h
    }
    return $o
}

$src = Invoke-RestMethod -Uri "$N8N_BASE_URL/api/v1/workflows/$WID" -Headers $headers -ErrorAction Stop
$code = $src.nodes | Where-Object { $_.type -match 'code' } | Select-Object -First 1
$oldJs = $code.parameters.jsCode
$newJs = Get-Content "$PSScriptRoot\..\_n8n\w10_new.js" -Raw

$cleanNodes = Clean $src.nodes
$urlOk = $false
foreach ($n in $cleanNodes) {
    if ($n['name'] -eq 'HTTP Get Executions') {
        $u = $n['parameters']['url']
        # remove o filtro status=error (em qualquer ordem de params) e forca limit alto p/ varrer TODAS
        # as execucoes 24h (incl. sucessos) -- robusto a ordem/limite e idempotente em re-run.
        $u2 = $u -replace 'status=error&?', ''
        if ($u2 -match 'limit=\d+') { $u2 = $u2 -replace 'limit=\d+', 'limit=250' }
        else { $u2 = $u2 + $(if ($u2 -match '\?') { '&' } else { '?' }) + 'limit=250' }
        $n['parameters']['url'] = $u2
        if ($u2 -notmatch 'status=error' -and $u2 -match 'limit=250') { $urlOk = $true }
    }
}
# fail-loud: sem o estado-alvo (sem status=error, limit=250) o resumo POSITIVO reportaria 0 OK -- abortar.
if (-not $urlOk) { Write-Host "[W-10] ERRO: no 'HTTP Get Executions' nao atingiu estado-alvo (sem status=error, limit=250) -- abortando." -ForegroundColor Red; exit 1 }

$body = [ordered]@{
    name        = $src.name
    nodes       = $cleanNodes
    connections = Clean $src.connections
    settings    = Clean $src.settings
    staticData  = Clean $src.staticData
}

$json = $ser.Serialize($body)
$jsonPatched = $json.Replace($ser.Serialize($oldJs), $ser.Serialize($newJs))
if ($jsonPatched -eq $json) { Write-Host "[W-10] ERRO: jsCode nao casou -- abortando." -ForegroundColor Red; exit 1 }
$json = $jsonPatched

$bytes = [Text.Encoding]::UTF8.GetBytes($json)
try {
    $resp = Invoke-RestMethod -Uri "$N8N_BASE_URL/api/v1/workflows/$WID" -Method Put -Headers $headers -ContentType 'application/json' -Body $bytes -ErrorAction Stop
    Write-Host "[W-10] ATUALIZADO -- name: $($resp.name) -- active: $($resp.active) -- nodes: $($resp.nodes.Count)" -ForegroundColor Green
    Write-Host "[W-10] URL exec patched: $patchedUrl | resumo POSITIVO de execucoes 24h ATIVO (S-3)."
} catch {
    Write-Host "[W-10] FALHA no PUT: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) { Write-Host $_.ErrorDetails.Message }
    exit 1
}
