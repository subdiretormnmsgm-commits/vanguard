#Requires -Version 5.1
# patch_w11.ps1 -- atualiza o jsCode do W-11 (vew2fonxWwiGB9uQ) in-place via PUT.
# Aplica Opcao A (Diretor 2026-06-20): ED nao e diario -- radar SO Segunda + validacao Sexta.
# Fonte do jsCode: _n8n/w11_current.js (espelho do canonico scripts/w11_calcular_ativacoes.js).
# Topologia intacta -- muda apenas o jsCode do no Code. W-11 ja ativo -- PUT mantem ativo.
# Aplica as 4 solucoes de serializacao PS 5.1 da skill n8n-remote-v1 (mesmo padrao do patch_w10).
# Uso: .\scripts\patch_w11.ps1

. "$PSScriptRoot\n8n_config.ps1"
if ([string]::IsNullOrWhiteSpace($N8N_API_KEY)) { Write-Error "N8N_API_KEY ausente"; exit 1 }

Add-Type -AssemblyName System.Web.Extensions
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$ser.MaxJsonLength = [int]::MaxValue
$headers = @{ "X-N8N-API-KEY" = $N8N_API_KEY }
$WID = "vew2fonxWwiGB9uQ"

# Converte PSCustomObject -> hashtable/array puro serializavel (armadilha #3 da skill).
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

# 1. GET W-11
$src = Invoke-RestMethod -Uri "$N8N_BASE_URL/api/v1/workflows/$WID" -Headers $headers -ErrorAction Stop
$code = $src.nodes | Where-Object { $_.type -match 'code' } | Select-Object -First 1
$oldJs = $code.parameters.jsCode

# 2. novo jsCode de arquivo (.ps1 fica ASCII-puro -- emoji/em-dash vivem so no .js, P-183)
$newJs = Get-Content "$PSScriptRoot\..\_n8n\w11_current.js" -Raw
if ([string]::IsNullOrWhiteSpace($newJs)) { Write-Error "_n8n\w11_current.js ausente ou vazio"; exit 1 }

# 3. body apenas com campos permitidos pela API
$body = [ordered]@{
    name        = $src.name
    nodes       = Clean $src.nodes
    connections = Clean $src.connections
    settings    = Clean $src.settings
    staticData  = Clean $src.staticData
}

# 4. serializar (solucao #1) e trocar jsCode por TEXTO (solucao #2)
$json = $ser.Serialize($body)
$jsonPatched = $json.Replace($ser.Serialize($oldJs), $ser.Serialize($newJs))
if ($jsonPatched -eq $json) { Write-Host "[W-11] ERRO: jsCode nao casou -- abortando." -ForegroundColor Red; exit 1 }
$json = $jsonPatched

# 5. PUT in-place (Content-Type json, solucao #4)
$bytes = [Text.Encoding]::UTF8.GetBytes($json)
try {
    $resp = Invoke-RestMethod -Uri "$N8N_BASE_URL/api/v1/workflows/$WID" -Method Put -Headers $headers -ContentType 'application/json' -Body $bytes -ErrorAction Stop
    Write-Host "[W-11] ATUALIZADO -- name: $($resp.name) -- active: $($resp.active) -- nodes: $($resp.nodes.Count)" -ForegroundColor Green
    Write-Host "[W-11] Opcao A aplicada: ED radar SO Segunda + validacao Sexta."
} catch {
    Write-Host "[W-11] FALHA no PUT: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) { Write-Host $_.ErrorDetails.Message }
    exit 1
}
