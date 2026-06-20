#Requires -Version 5.1
# build_w13.ps1 -- clona W-11 (vew2fonxWwiGB9uQ) -> W-13 Cowork F(x) Notifier (S-2).
# Aplica as 4 solucoes de serializacao PS 5.1 da skill n8n-remote-v1 (clone do W-12).
# Cria DESATIVADO. Ativacao so por veredito do Diretor apos teste.
# Uso: .\scripts\build_w13.ps1

. "$PSScriptRoot\n8n_config.ps1"
if ([string]::IsNullOrWhiteSpace($N8N_API_KEY)) { Write-Error "N8N_API_KEY ausente"; exit 1 }

Add-Type -AssemblyName System.Web.Extensions
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$ser.MaxJsonLength = [int]::MaxValue
$headers = @{ "X-N8N-API-KEY" = $N8N_API_KEY }

# Converte PSCustomObject (com PSMethods) -> hashtable/array puro serializavel (armadilha #3 da skill).
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

# 1. GET W-11 (template)
$src = Invoke-RestMethod -Uri "$N8N_BASE_URL/api/v1/workflows/vew2fonxWwiGB9uQ" -Headers $headers -ErrorAction Stop
$code = $src.nodes | Where-Object { $_.type -match 'code' } | Select-Object -First 1
$oldJs = $code.parameters.jsCode

# 2. novo jsCode (fonte unica em _n8n/w13_logic.js -- mantem temAtivacao/textoAtivacao/chatId).
#    Carregado de arquivo .js para o .ps1 ficar ASCII-puro (P-183): emoji/bullet/em-dash vivem so no .js.
$newJs = Get-Content "$PSScriptRoot\..\_n8n\w13_logic.js" -Raw
if ([string]::IsNullOrWhiteSpace($newJs)) { Write-Error "_n8n\w13_logic.js ausente ou vazio"; exit 1 }

# 3. body apenas com campos permitidos (name patchado direto -- string simples e seguro)
$body = [ordered]@{
    name        = "W-13 -- Cowork F(x) Notifier"
    nodes       = Clean $src.nodes
    connections = Clean $src.connections
    settings    = Clean $src.settings
    staticData  = Clean $src.staticData
}

# 4. serializar com JavaScriptSerializer (solucao #1) e trocar jsCode por TEXTO (solucao #2)
$json = $ser.Serialize($body)
$json = $json.Replace($ser.Serialize($oldJs), $ser.Serialize($newJs))
# trocar cron 07:05 -> 07:15 BRT (nao competir com W-11/W-12) via texto
$json = $json.Replace('"5 10 * * *"', '"15 10 * * *"')

# 5. POST cria novo workflow (sempre desativado). Content-Type json (solucao #4)
$bytes = [Text.Encoding]::UTF8.GetBytes($json)
try {
    $resp = Invoke-RestMethod -Uri "$N8N_BASE_URL/api/v1/workflows" -Method Post -Headers $headers -ContentType 'application/json' -Body $bytes -ErrorAction Stop
    Write-Host "[W-13] CRIADO -- id: $($resp.id) -- name: $($resp.name) -- active: $($resp.active)" -ForegroundColor Green
    Write-Host "[W-13] cron: $((($resp.nodes | Where-Object { $_.type -match 'scheduleTrigger' }).parameters.rule.interval[0].expression))"
    Write-Host "[W-13] Ativar (apos veredito): POST /api/v1/workflows/$($resp.id)/activate"
} catch {
    Write-Host "[W-13] FALHA no POST: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) { Write-Host $_.ErrorDetails.Message }
    exit 1
}
