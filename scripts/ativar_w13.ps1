#Requires -Version 5.1
# ativar_w13.ps1 -- ativa o W-13 (Cowork F(x) Notifier) apos veredito do Diretor.
# Uso: .\scripts\ativar_w13.ps1
. "$PSScriptRoot\n8n_config.ps1"
$headers = @{ "X-N8N-API-KEY" = $N8N_API_KEY }
$WID = "g06fYsG6kxduv7ZA"
try {
    $resp = Invoke-RestMethod -Uri "$N8N_BASE_URL/api/v1/workflows/$WID/activate" -Method Post -Headers $headers -ContentType 'application/json' -ErrorAction Stop
    Write-Host "[W-13] ATIVADO -- name: $($resp.name) -- active: $($resp.active) -- cron 07:15 BRT" -ForegroundColor Green
} catch {
    Write-Host "[W-13] FALHA ao ativar: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) { Write-Host $_.ErrorDetails.Message }
    exit 1
}
