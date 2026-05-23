# gargalo_ping.ps1
# Detecta projetos bloqueados aguardando input do Diretor por mais de 24h
# e dispara e-mail de alerta com o score GUT do atraso.
# Rodado pelo wip_guard.ps1 e pelo session_start.ps1 automaticamente.
# Uso manual: .\scripts\gargalo_ping.ps1

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE    = Split-Path -Parent $PSScriptRoot
$WIP     = "$BASE\CLIENTES\WIP_BOARD.json"
$AGORA   = Get-Date
$LIMITE  = 24  # horas sem movimento para disparar alerta

if (-not (Test-Path $WIP)) {
    Write-Host "ERRO: WIP_BOARD.json nao encontrado." -ForegroundColor Red
    exit 1
}

$board   = Get-Content $WIP -Raw -Encoding UTF8 | ConvertFrom-Json
$alertas = [System.Collections.ArrayList]@()

foreach ($proj in $board.board.build) {

    # Verificar se ha pendencias explicitas do Diretor
    $pendentes = @()
    if ($proj.pendente_diretor) {
        foreach ($p in $proj.pendente_diretor) { $pendentes += $p }
    }

    # Verificar se status indica bloqueio aguardando Diretor
    $statusBloqueado = $false
    if ($proj.status -match "aguardando|bloqueado|pendente|Diretor") {
        $statusBloqueado = $true
    }

    if ($pendentes.Count -eq 0 -and -not $statusBloqueado) { continue }

    # Calcular horas desde ultima atualizacao do board
    $ultimaAtt = [datetime]::ParseExact($board.atualizado_em, "yyyy-MM-dd", $null)
    $horas     = ($AGORA - $ultimaAtt).TotalHours

    if ($horas -lt $LIMITE) { continue }

    # Calcular GUT do atraso
    # G — Gravidade: dias ate deadline
    $deadline  = [datetime]::ParseExact($proj.deadline, "yyyy-MM-dd", $null)
    $diasRestantes = ($deadline - $AGORA).TotalDays
    $G = if ($diasRestantes -le 1) { 5 } elseif ($diasRestantes -le 3) { 4 } elseif ($diasRestantes -le 7) { 3 } else { 2 }

    # U — Urgencia: horas de bloqueio
    $U = if ($horas -ge 48) { 5 } elseif ($horas -ge 36) { 4 } elseif ($horas -ge 24) { 3 } else { 2 }

    # T — Tendencia: pior (sem MRR = sem margem para erro)
    $T = if ($board.board.retainer.Count -eq 0) { 5 } else { 3 }

    $GUT = $G * $U * $T

    $alertas.Add([PSCustomObject]@{
        Id          = $proj.id
        Cliente     = $proj.cliente
        Projeto     = $proj.projeto
        Deadline    = $proj.deadline
        DiasRestantes = [math]::Round($diasRestantes, 1)
        HorasBloqueado = [math]::Round($horas, 1)
        Pendentes   = ($pendentes -join " | ")
        Status      = $proj.status
        GUT         = $GUT
        G           = $G
        U           = $U
        T           = $T
    }) | Out-Null
}

if ($alertas.Count -eq 0) {
    Write-Host ""
    Write-Host "  [OK] Nenhum gargalo do Diretor detectado." -ForegroundColor Green
    Write-Host ""
    exit 0
}

# Exibir no terminal
Write-Host ""
Write-Host "======================================================" -ForegroundColor Red
Write-Host "  GARGALO DO DIRETOR DETECTADO" -ForegroundColor Red
Write-Host "======================================================" -ForegroundColor Red

foreach ($a in $alertas | Sort-Object GUT -Descending) {
    Write-Host ""
    Write-Host "  Projeto  : $($a.Id) — $($a.Cliente)" -ForegroundColor Yellow
    Write-Host "  Deadline : $($a.Deadline) ($($a.DiasRestantes) dias restantes)"
    Write-Host "  Bloqueado: $($a.HorasBloqueado)h sem movimento do Diretor"
    Write-Host "  Score GUT: $($a.GUT) (G:$($a.G) U:$($a.U) T:$($a.T))" -ForegroundColor Red
    if ($a.Pendentes) {
        Write-Host "  Pendente : $($a.Pendentes)" -ForegroundColor Cyan
    }
    Write-Host "  Status   : $($a.Status)"
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Red
Write-Host ""

# Disparar e-mail de alerta
. "$BASE\scripts\alert_config.ps1"

$linhasAlerta = foreach ($a in $alertas | Sort-Object GUT -Descending) {
    "PROJETO: $($a.Id) — $($a.Cliente)"
    "Deadline: $($a.Deadline) ($($a.DiasRestantes) dias restantes)"
    "Bloqueado ha: $($a.HorasBloqueado)h"
    "Score GUT: $($a.GUT) — Gravidade $($a.G) / Urgencia $($a.U) / Tendencia $($a.T)"
    if ($a.Pendentes) { "Pendente do Diretor: $($a.Pendentes)" }
    "Status atual: $($a.Status)"
    "---"
}

$corpo = @"
**Assunto:** ALERTA GARGALO — Diretor bloqueando projeto ha mais de $($LIMITE)h

Diretor,

O sistema detectou que voce e o ponto de bloqueio em projeto(s) ativo(s) ha mais de $($LIMITE) horas.

$($linhasAlerta -join "`n")

Acao necessaria agora:
Para cada projeto acima, execute a acao pendente listada.
O build nao avanca enquanto o input do Diretor nao chegar.

Score GUT do atraso mede: Gravidade (prazo) x Urgencia (horas parado) x Tendencia (sem MRR = sem margem).

Musculo — Pentalateral IAH
"@

try {
    $smtp        = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $smtp.EnableSsl     = $true
    $smtp.Credentials   = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)

    $msg                = New-Object Net.Mail.MailMessage
    $msg.From           = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject        = "ALERTA GARGALO — Diretor bloqueando projeto ha mais de $($LIMITE)h — GUT $($alertas[0].GUT)"
    $msg.Body           = $corpo
    $msg.BodyEncoding   = [System.Text.Encoding]::UTF8

    $smtp.Send($msg)
    Write-Host "  E-mail de alerta disparado para $ALERT_TO" -ForegroundColor Green
} catch {
    Write-Host "  ERRO ao enviar e-mail: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
