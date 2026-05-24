#Requires -Version 5.1
# monitor_hypercare.ps1 — Monitora silencio durante Hypercare (dias 1-30 pos-contrato)
# Roda via Task Scheduler as 7h todos os dias uteis.
# Logica: se Hypercare ativo + >= DiasAlerta dias sem contato registrado → alerta Telegram.
#
# Uso:
#   .\scripts\monitor_hypercare.ps1
#   .\scripts\monitor_hypercare.ps1 -DiasAlerta 2

param(
    [int]$DiasAlerta = 3    # limiar em dias sem contato para disparar alerta
)

$raiz        = Split-Path -Parent $PSScriptRoot
$alertScript = "$raiz\scripts\alerta_telegram.ps1"
$wipPath     = "$raiz\CLIENTES\WIP_BOARD.json"

if (-not (Test-Path $wipPath)) { exit 0 }

$wip   = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$hoje  = Get-Date

# Coletar projetos em build E check (Hypercare pode estar ativo em ambas as fases)
$projetos = @()
if ($wip.board.build) { $projetos += @($wip.board.build) }
if ($wip.board.check) { $projetos += @($wip.board.check) }
$projetos = $projetos | Where-Object { $_ }

foreach ($proj in $projetos) {
    $clienteNome = $proj.cliente.ToUpper()

    # --- 1. Detectar data de inicio do Hypercare ---
    $inicioHypercare = $null

    if ($proj.contrato_assinado_em -and $proj.contrato_assinado_em -ne "") {
        try { $inicioHypercare = [datetime]::Parse($proj.contrato_assinado_em) } catch {}
    }
    if (-not $inicioHypercare -and $proj.formalizador -and $proj.formalizador.assinado_em) {
        try { $inicioHypercare = [datetime]::Parse($proj.formalizador.assinado_em) } catch {}
    }

    if (-not $inicioHypercare) { continue }

    $diasDesdeContrato = ($hoje.Date - $inicioHypercare.Date).Days
    if ($diasDesdeContrato -lt 0 -or $diasDesdeContrato -gt 30) { continue }

    $diasHypercareRestantes = 30 - $diasDesdeContrato

    # --- 2. Ler ultimo contato em MEMORIA_EMBAIXADOR ---
    $memoriaPath = "$raiz\CLIENTES\$clienteNome\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
    if (-not (Test-Path $memoriaPath)) { continue }

    $memoriaContent = Get-Content $memoriaPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $memoriaContent) { continue }

    # Formato esperado na tabela ESTADO DO RELACIONAMENTO:
    #   | Último contato | **descricao — YYYY-MM-DD** |
    # Aceita variantes: "ltimo contato", sem acento, com/sem bold
    $match = [regex]::Match($memoriaContent,
        '(?i)[Úú]ltimo\s+contato[^\n|]*[|\s].*?(\d{4}-\d{2}-\d{2})')

    $diasSemContato = $DiasAlerta  # assume silencio se data nao encontrada

    if ($match.Success) {
        try {
            $ultimaData     = [datetime]::Parse($match.Groups[1].Value)
            $diasSemContato = ($hoje.Date - $ultimaData.Date).Days
        } catch {}
    }

    if ($diasSemContato -lt $DiasAlerta) { continue }

    # --- 3. Compor e enviar alerta ---
    $msg = "HYPERCARE $clienteNome — Dia $diasDesdeContrato/30 ($diasHypercareRestantes dias restantes)`n" +
           "$diasSemContato dias sem contato registrado.`n`n" +
           "ACAO SUGERIDA (WhatsApp):`n" +
           '"Oi [NOME], tudo certo? Passando para ver como o sistema está no dia a dia. Tem alguma dúvida ou algo que queira ajustar?"' + "`n`n" +
           "Se ja houve contato nao registrado, atualizar MEMORIA_EMBAIXADOR com a data real."

    if (Test-Path $alertScript) {
        try {
            & $alertScript -mensagem $msg -ErrorAction SilentlyContinue
        } catch {}
    }

    Write-Host "[HYPERCARE] $clienteNome — Dia $diasDesdeContrato — $diasSemContato dias sem contato — alerta enviado" -ForegroundColor Yellow
}

exit 0
