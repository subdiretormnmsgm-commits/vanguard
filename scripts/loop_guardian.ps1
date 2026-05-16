# loop_guardian.ps1
# Detecta quando o loop evolutivo Musculo→Gemini→NotebookLM→Musculo está parado.
# Roda no session_start (silencioso) e manualmente (com e-mail de alerta).
# Se projeto BUILD ficou > AlertaDias sem MEMORIA → alerta por e-mail.

param(
    [int]$AlertaDias = 5,   # dias sem nova MEMORIA antes de alertar
    [switch]$Silencioso     # sem e-mail; apenas retorna status para session_start
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$WIP  = "$BASE\CLIENTES\WIP_BOARD.json"
$HOJE = Get-Date

if (-not (Test-Path $WIP)) { exit 0 }

$board    = Get-Content $WIP -Raw -Encoding UTF8 | ConvertFrom-Json
$projetos = @($board.board.build)
if ($projetos.Count -eq 0) { exit 0 }

$alertas  = [System.Collections.ArrayList]@()
$linhas   = [System.Collections.ArrayList]@()

foreach ($proj in $projetos) {
    $projId  = $proj.id
    $cliente = $proj.cliente

    # Localizar pasta do cliente (case-insensitive)
    $clienteDir = Get-ChildItem "$BASE\CLIENTES" -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ieq $cliente } |
        Select-Object -First 1 -ExpandProperty FullName

    # ── Última MEMORIA gerada ──────────────────────────────────────────────
    $ultimaMemoriaArq  = $null
    $diasSemMemoria    = 999
    if ($clienteDir -and (Test-Path "$clienteDir\HISTORICO")) {
        $memorias = Get-ChildItem "$clienteDir\HISTORICO" -Filter "MEMORIA_V*.md" `
                        -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
        if ($memorias) {
            $ultimaMemoriaArq = $memorias[0]
            $diasSemMemoria   = [int]($HOJE - $ultimaMemoriaArq.LastWriteTime).TotalDays
        }
    }

    # ── Último COMANDO_ESTRATEGISTA gerado ────────────────────────────────
    $ultimoCmdArq    = $null
    $diasSemComando  = 999
    if ($clienteDir) {
        $cmds = Get-ChildItem "$clienteDir\CONSELHO" -Filter "COMANDO_ESTRATEGISTA*.md" `
                    -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
        if ($cmds) {
            $ultimoCmdArq   = $cmds[0]
            $diasSemComando = [int]($HOJE - $ultimoCmdArq.LastWriteTime).TotalDays
        }
    }

    # ── PASSO3 desatualizado? ─────────────────────────────────────────────
    $passo3Stale = $false
    if ($clienteDir -and $ultimaMemoriaArq) {
        $passo3 = Join-Path $clienteDir "PASSO3_GEMINI.md"
        if (Test-Path $passo3) {
            $passo3Age = [int]($HOJE - (Get-Item $passo3).LastWriteTime).TotalDays
            if ($passo3Age -gt $diasSemMemoria + 1) { $passo3Stale = $true }
        }
    }

    # ── Dias em BUILD ─────────────────────────────────────────────────────
    $diasEmBuild = 0
    if ($proj.build_iniciado_em) {
        $diasEmBuild = [int]($HOJE - [datetime]::Parse($proj.build_iniciado_em)).TotalDays
    }

    # ── Deadline status ───────────────────────────────────────────────────
    $diasParaDeadline = 999
    if ($proj.deadline) {
        $diasParaDeadline = [int]([datetime]::Parse($proj.deadline) - $HOJE).TotalDays
    }

    # ── Classificação do risco de loop ────────────────────────────────────
    $loopStale = $diasSemMemoria -ge $AlertaDias
    $critico   = $diasSemMemoria -ge ($AlertaDias * 2)

    $icone = if ($critico)   { "[!!]" }
             elseif ($loopStale) { "[>>]" }
             else                { "[OK]" }

    [void]$linhas.Add("")
    [void]$linhas.Add("$icone [$projId] $cliente — $diasEmBuild dias em BUILD | Deadline: +$diasParaDeadline dias")
    [void]$linhas.Add("     Ultima MEMORIA   : $(if ($ultimaMemoriaArq) { "$($ultimaMemoriaArq.Name) — $diasSemMemoria dias atras" } else { 'NENHUMA' })")
    [void]$linhas.Add("     Ultimo COMANDO   : $(if ($ultimoCmdArq)     { "$($ultimoCmdArq.Name) — $diasSemComando dias atras" } else { 'NENHUM — loop nunca completou' })")
    if ($passo3Stale) { [void]$linhas.Add("     [AVISO] PASSO3_GEMINI.md desatualizado — atualizar antes do proximo loop") }

    if ($loopStale) {
        [void]$alertas.Add(
            "[$projId] $($proj.cliente): $diasSemMemoria dias sem MEMORIA nova`n" +
            "  Prazo restante: $diasParaDeadline dias | Build: $diasEmBuild dias em andamento`n" +
            "  Acao: gerar MEMORIA + relatorio_evolutivo + COMANDO_ESTRATEGISTA"
        )
    }
}

# ── Output para session_start (sempre) ───────────────────────────────────────
$linhas | ForEach-Object { Write-Host $_ }

if ($alertas.Count -eq 0 -or $Silencioso) { exit 0 }

# ── E-mail de alerta ──────────────────────────────────────────────────────────
$alertConfig = "$BASE\scripts\alert_config.ps1"
if (-not (Test-Path $alertConfig)) { exit 0 }

. $alertConfig

$body = @"
Diretor,

O loop evolutivo está parado em $($alertas.Count) projeto(s):

$($alertas -join "`n`n")

Loop parado = inteligência morre no projeto e não alimenta a IAH.

Ação imediata:
1. Abrir o projeto no Claude Code
2. Gerar MEMORIA + relatorio_evolutivo para o projeto acima
3. Preparar PASSO3_GEMINI.md e ir ao Gemini para fechar o loop

Sem loop → próximo projeto começa do zero.

Músculo — Loop Guardian
"@

try {
    $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $smtp.EnableSsl   = $true
    $smtp.Credentials = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)
    $msg              = New-Object Net.Mail.MailMessage
    $msg.From         = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject      = "ALERTA LOOP: $($alertas.Count) projeto(s) sem loop ha $AlertaDias+ dias — $(Get-Date -Format 'yyyy-MM-dd')"
    $msg.Body         = $body
    $msg.BodyEncoding = [System.Text.Encoding]::UTF8
    $smtp.Send($msg)
    Write-Host ""
    Write-Host "[E-MAIL] Alerta de loop enviado." -ForegroundColor Yellow
} catch {
    Write-Host "[AVISO] E-mail de loop nao enviado: $($_.Exception.Message)" -ForegroundColor Yellow
}

exit 0
