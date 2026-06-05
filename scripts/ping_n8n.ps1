#Requires -Version 5.1
# ping_n8n.ps1 -- N-1: verifica se o n8n esta online (P-101)
# Uso standalone: .\scripts\ping_n8n.ps1
# Chamado por session_start.ps1 PASSO 8e via Start-Process para capturar exit code
# Saida: Write-Host com cor + exit 0 (online) ou exit 1 (offline/erro)

param(
    [string]$Url = "https://vanguard-vanguard-n8n.0ul9nk.easypanel.host/healthz"
)

$ok = $false
$detalhe = ""

try {
    $resp = Invoke-WebRequest -Uri $Url -TimeoutSec 8 -UseBasicParsing -ErrorAction Stop
    if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 500) {
        $ok = $true
        $detalhe = "HTTP $($resp.StatusCode)"
    } else {
        $detalhe = "HTTP $($resp.StatusCode) inesperado"
    }
} catch [System.Net.WebException] {
    $detalhe = "WebException: $($_.Exception.Message)"
} catch {
    $detalhe = $_.Exception.Message
}

if ($ok) {
    Write-Host "  [OK] n8n ONLINE ($detalhe)" -ForegroundColor Green
    exit 0
} else {
    Write-Host "  [AVISO] n8n OFFLINE -- $detalhe" -ForegroundColor Yellow
    Write-Host "  Impacto: Check-in 7h/13h/20h + Monitor Supabase + alertas nao funcionam." -ForegroundColor Yellow
    Write-Host "  Acao: EasyPanel -> https://vanguard-vanguard-n8n.0ul9nk.easypanel.host" -ForegroundColor DarkGray
    exit 1
}
