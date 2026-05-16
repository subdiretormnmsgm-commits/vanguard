# check_in.ps1
# Ritual de abertura de sessao: Eduardo declara o que avancou offline.
# Atualiza WIP_BOARD automaticamente. Dispara e-mail de confirmacao.
# Uso: .\scripts\check_in.ps1
# Rodar ANTES de qualquer conversa com o Musculo quando algo foi feito fora do Claude Code.

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$WIP  = "$BASE\CLIENTES\WIP_BOARD.json"
$HOJE = Get-Date -Format "yyyy-MM-dd"

if (-not (Test-Path $WIP)) { Write-Host "ERRO: WIP_BOARD.json nao encontrado."; exit 1 }

$board = Get-Content $WIP -Raw -Encoding UTF8 | ConvertFrom-Json

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  CHECK-IN DE SESSAO — $HOJE" -ForegroundColor Cyan
Write-Host "  O que voce fez desde a ultima sessao?" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$atualizacoes = [System.Collections.ArrayList]@()

foreach ($proj in $board.board.build) {

    Write-Host ""
    Write-Host "  PROJETO: $($proj.id) — $($proj.cliente)" -ForegroundColor Yellow
    Write-Host "  Dias concluidos ate agora: $(if ($proj.dias_completos) { $proj.dias_completos -join ', ' } else { 'nenhum' })"
    Write-Host ""

    # Mostrar gates pendentes
    $gatesPendentes = @{}
    if ($proj.gates_bloqueantes) {
        foreach ($prop in $proj.gates_bloqueantes.PSObject.Properties) {
            $diaKey = $prop.Name
            $jaFeito = $proj.dias_completos -contains "dia$($diaKey -replace 'dia','')*"

            # Verifica se ja esta em dias_completos (busca parcial)
            $concluido = $false
            if ($proj.dias_completos) {
                foreach ($d in $proj.dias_completos) {
                    if ($d -match $diaKey) { $concluido = $true; break }
                }
            }

            if (-not $concluido) {
                $gatesPendentes[$diaKey] = $prop.Value
            }
        }
    }

    if ($gatesPendentes.Count -eq 0) {
        Write-Host "  [OK] Todos os gates registrados. Nenhum pendente." -ForegroundColor Green
        continue
    }

    Write-Host "  Gates ainda nao registrados:" -ForegroundColor White
    $opcoes = @()
    foreach ($g in $gatesPendentes.GetEnumerator() | Sort-Object Key) {
        $opcoes += $g
        Write-Host "    [$($opcoes.Count)] $($g.Key): $($g.Value)" -ForegroundColor Gray
    }

    Write-Host ""
    Write-Host "  Quais voce passou? Digite os numeros separados por virgula (ex: 1,2) ou ENTER para pular:" -ForegroundColor Cyan
    $resposta = Read-Host "  Selecao"

    if ([string]::IsNullOrWhiteSpace($resposta)) {
        Write-Host "  Pulado." -ForegroundColor DarkGray
        continue
    }

    $indices = $resposta -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -match "^\d+$" }

    foreach ($idx in $indices) {
        $i = [int]$idx - 1
        if ($i -ge 0 -and $i -lt $opcoes.Count) {
            $gateKey = $opcoes[$i].Key

            # Adicionar a dias_completos
            $lista = [System.Collections.ArrayList]@()
            if ($proj.dias_completos) { foreach ($d in $proj.dias_completos) { [void]$lista.Add($d) } }
            [void]$lista.Add($gateKey)
            $proj.dias_completos = $lista.ToArray()

            $atualizacoes.Add("$($proj.id) ($($proj.cliente)): $gateKey marcado como concluido") | Out-Null
            Write-Host "  [OK] $gateKey registrado." -ForegroundColor Green
        }
    }
}

if ($atualizacoes.Count -eq 0) {
    Write-Host ""
    Write-Host "  Nenhuma atualizacao registrada. WIP_BOARD inalterado." -ForegroundColor DarkGray
    Write-Host ""
    exit 0
}

# Salvar WIP
$board.atualizado_em = $HOJE
$board | ConvertTo-Json -Depth 15 | Set-Content $WIP -Encoding UTF8

Write-Host ""
Write-Host "======================================================" -ForegroundColor Green
Write-Host "  CHECK-IN CONCLUIDO — WIP ATUALIZADO" -ForegroundColor Green
foreach ($a in $atualizacoes) { Write-Host "  + $a" -ForegroundColor Green }
Write-Host "======================================================" -ForegroundColor Green
Write-Host ""

# Disparar e-mail de confirmacao
. "$BASE\scripts\alert_config.ps1"
$linhas = $atualizacoes -join "`n"

try {
    $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $smtp.EnableSsl    = $true
    $smtp.Credentials  = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)
    $msg               = New-Object Net.Mail.MailMessage
    $msg.From          = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject       = "Check-in $HOJE — WIP atualizado com progresso offline"
    $msg.Body          = "Diretor,`n`nCheck-in registrado em $HOJE.`n`nGates marcados como concluidos:`n$linhas`n`nWIP_BOARD atualizado. Musculo ja sabe o estado real ao iniciar a sessao.`n`nMusculo — Quadrilateral IAH"
    $msg.BodyEncoding  = [System.Text.Encoding]::UTF8
    $smtp.Send($msg)
    Write-Host "  E-mail de confirmacao enviado." -ForegroundColor Cyan
} catch {
    Write-Host "  Aviso: e-mail nao enviado ($($_.Exception.Message))" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Proximo passo: abrir o Claude Code normalmente." -ForegroundColor White
Write-Host "  O session_start ja injetara o estado atualizado." -ForegroundColor White
Write-Host ""
