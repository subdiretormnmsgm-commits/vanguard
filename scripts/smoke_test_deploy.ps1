#Requires -Version 5.1
# smoke_test_deploy.ps1 — P-064: Validacao obrigatoria pos-deploy
# Musculo NUNCA diz "pronto" sem este script passar.
# Diretor so testa o golden path depois de PASSOU.
#
# Uso:
#   .\scripts\smoke_test_deploy.ps1 -cliente VALDECE
#   .\scripts\smoke_test_deploy.ps1 -cliente INGRID -TimeoutSeconds 180

param(
    [Parameter(Mandatory=$true)]
    [string]$cliente,
    [int]$TimeoutSeconds = 120,
    [switch]$Silencioso
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$raiz         = Split-Path -Parent $PSScriptRoot
$clienteUpper = $cliente.ToUpper()

# --- Carregar configuracao de testes ---
$configPath = "$raiz\CLIENTES\$clienteUpper\smoke_tests.json"
if (-not (Test-Path $configPath)) {
    Write-Host ""
    Write-Host "[AVISO] smoke_tests.json nao encontrado para $clienteUpper" -ForegroundColor Yellow
    Write-Host "        Criar em: $configPath" -ForegroundColor DarkGray
    Write-Host "        Modelo  : scripts\smoke_tests_template.json" -ForegroundColor DarkGray
    Write-Host ""
    exit 0
}

$config = Get-Content $configPath -Raw -Encoding UTF8 | ConvertFrom-Json
$site   = $config.site.TrimEnd('/')
$testes = @($config.tests)

if (-not $Silencioso) {
    Write-Host ""
    Write-Host "=================================================" -ForegroundColor Cyan
    Write-Host "  SMOKE TEST P-064 -- $clienteUpper" -ForegroundColor Cyan
    Write-Host "  Site   : $site" -ForegroundColor DarkGray
    Write-Host "  Testes : $($testes.Count)" -ForegroundColor DarkGray
    Write-Host "  Timeout: ${TimeoutSeconds}s por teste" -ForegroundColor DarkGray
    Write-Host "=================================================" -ForegroundColor Cyan
    Write-Host ""
}

# --- Executar cada teste ---
$resultados = @()

foreach ($teste in $testes) {
    $url          = "$site$($teste.endpoint)"
    $nome         = $teste.name
    $method       = if ($teste.method)         { $teste.method }         else { "GET" }
    $expectStatus = if ($teste.expect_status)  { $teste.expect_status }  else { 200 }
    $passou       = $false
    $detalhe      = ""
    $inicio       = Get-Date

    if (-not $Silencioso) {
        Write-Host "  $nome" -NoNewline -ForegroundColor White
    }

    while ($true) {
        $elapsed = ((Get-Date) - $inicio).TotalSeconds
        if ($elapsed -gt $TimeoutSeconds) {
            $detalhe = "Timeout de ${TimeoutSeconds}s -- deploy pode estar demorando"
            break
        }

        try {
            $params = @{
                Uri             = $url
                Method          = $method
                UseBasicParsing = $true
                TimeoutSec      = 20
                ErrorAction     = "Stop"
            }
            if ($method -eq "POST") {
                $params.ContentType = "application/json"
                $params.Body        = ($teste.body | ConvertTo-Json -Compress -Depth 5)
            }

            $resp = Invoke-WebRequest @params

            # Verificar status esperado
            if ($resp.StatusCode -ne $expectStatus) {
                $detalhe = "Status $($resp.StatusCode) (esperado $expectStatus)"
                Start-Sleep -Seconds 10
                if (-not $Silencioso) { Write-Host "." -NoNewline -ForegroundColor DarkGray }
                continue
            }

            # Verificar campo no JSON de resposta
            if ($teste.expect_field) {
                $json  = $resp.Content | ConvertFrom-Json
                $valor = $json.($teste.expect_field)
                if ($null -eq $valor) {
                    $detalhe = "Campo '$($teste.expect_field)' ausente na resposta"
                    break
                }
                $count   = if ($valor.Count) { $valor.Count } else { 1 }
                $detalhe = "[$($teste.expect_field): $count elementos]"
            }

            # Verificar conteudo no HTML/texto
            if ($teste.expect_contains -and $resp.Content -notmatch [regex]::Escape($teste.expect_contains)) {
                $detalhe = "Resposta nao contem '$($teste.expect_contains)'"
                break
            }

            $passou = $true
            break

        } catch {
            $msg = $_.Exception.Message
            # Deploy ainda nao pronto: 502, 503, timeout de conexao
            if ($msg -match "502|503|Unable to connect|timed out") {
                Start-Sleep -Seconds 15
                if (-not $Silencioso) { Write-Host "." -NoNewline -ForegroundColor DarkGray }
            } else {
                $detalhe = "Erro HTTP: $msg"
                break
            }
        }
    }

    if (-not $Silencioso) {
        if ($passou) {
            Write-Host " [PASSOU]" -ForegroundColor Green
            if ($detalhe) { Write-Host "    $detalhe" -ForegroundColor DarkGray }
        } else {
            Write-Host " [FALHOU]" -ForegroundColor Red
            if ($detalhe) { Write-Host "    $detalhe" -ForegroundColor Red }
        }
    }

    $resultados += [PSCustomObject]@{
        Nome    = $nome
        Passou  = $passou
        Detalhe = $detalhe
    }
}

# --- Resultado final ---
$passaram = @($resultados | Where-Object { $_.Passou  }).Count
$falharam = @($resultados | Where-Object { -not $_.Passou }).Count

if (-not $Silencioso) {
    Write-Host ""
    Write-Host "=================================================" -ForegroundColor Cyan
    if ($falharam -eq 0) {
        Write-Host "  RESULTADO: PASSOU ($passaram/$($resultados.Count))" -ForegroundColor Green
        Write-Host "  Deploy validado. Diretor pode testar o golden path." -ForegroundColor Green
    } else {
        Write-Host "  RESULTADO: FALHOU ($falharam falha(s), $passaram/$($resultados.Count) ok)" -ForegroundColor Red
        Write-Host "  Musculo resolve antes de chamar o Diretor." -ForegroundColor Red
    }
    Write-Host "=================================================" -ForegroundColor Cyan
    Write-Host ""
}

# Alerta Telegram se falhou
if ($falharam -gt 0) {
    $alertScript = "$raiz\scripts\alerta_telegram.ps1"
    if (Test-Path $alertScript) {
        $nomes = ($resultados | Where-Object { -not $_.Passou } | ForEach-Object { $_.Nome }) -join ", "
        $msg = "SMOKE TEST $clienteUpper FALHOU: $nomes -- Musculo resolve antes de chamar o Diretor."
        try { & $alertScript -mensagem $msg -ErrorAction SilentlyContinue } catch {}
    }
}

exit $(if ($falharam -eq 0) { 0 } else { 1 })
