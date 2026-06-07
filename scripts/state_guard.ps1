#Requires -Version 5.1
# state_guard.ps1 -- Guarda de Estado do WIP_BOARD (V28)
# Monitora anomalias em loop_fase_atual, ultimo_contato_cliente e gates vencidos
# Extensao do sync_guard para estados semanticos (nao apenas hashes de arquivo)
# Uso:
#   .\scripts\state_guard.ps1              -- verifica e reporta
#   .\scripts\state_guard.ps1 -Silencioso  -- JSON para n8n
#   .\scripts\state_guard.ps1 -Telegram    -- alerta via Telegram se anomalia detectada
# Integrado: session_start.ps1 (apos sync_guard)

param(
    [switch]$Silencioso,
    [switch]$Telegram
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$BASE = Split-Path -Parent $PSScriptRoot

$alertas   = [System.Collections.Generic.List[hashtable]]::new()
$ok        = [System.Collections.Generic.List[string]]::new()
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

# --- Ler WIP_BOARD.json ---
$wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
if (-not (Test-Path $wipPath)) {
    if (-not $Silencioso) { Write-Host "[state_guard] WIP_BOARD.json nao encontrado." -ForegroundColor Yellow }
    exit 0
}

try {
    $wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    if (-not $Silencioso) { Write-Host "[state_guard] ERRO ao ler WIP_BOARD.json: $_" -ForegroundColor Red }
    exit 1
}

$hoje = [datetime]::Today
$projetos = @()
foreach ($coluna in @("build", "check", "retainer")) {
    $lista = $wip.board.$coluna
    if ($lista) { $projetos += $lista }
}

foreach ($proj in $projetos) {
    $id      = $proj.id
    $cliente = $proj.cliente
    $skip    = ($proj.churn_watch_threshold -eq $null)

    # --- VERIFICACAO 1: loop_fase_atual inconsistente ---
    $lfa = $proj.loop_fase_atual
    if ($lfa) {
        $sociosOK = @("gemini","notebooklm","embaixador","musculo") | Where-Object { $lfa.$_ -eq "OK" }
        $sociosPend = @("gemini","notebooklm","embaixador","musculo") | Where-Object { $lfa.$_ -ne "OK" -and $lfa.$_ -ne $null }

        # Inconsistencia: proximo diz "OK" mas socio nao marcado OK
        $proximo = if ($lfa.proximo) { $lfa.proximo } else { "" }
        if ($sociosOK.Count -eq 4 -and $proximo -match "gemini|notebooklm|embaixador|musculo") {
            $alertas.Add(@{
                tipo      = "INCONSISTENCIA_LOOP"
                nivel     = "AMARELO"
                cliente   = $cliente
                detalhe   = "[$id] loop_fase_atual: todos socio=OK mas proximo ainda referencia socio pendente. Verificar WIP_BOARD."
            })
        } else {
            $ok.Add("[$id] $cliente loop_fase_atual: $($sociosOK.Count)/4 socios OK")
        }
    }

    # --- VERIFICACAO 2: WIP_BOARD declara socio=OK sem artefato em disco (P-091) ---
    if ($lfa -and $lfa.musculo -eq "OK" -and $lfa.loop -ne $null) {
        $loopN   = $lfa.loop
        $delib   = Join-Path $BASE "CLIENTES\$cliente\HISTORICO\DELIBERACAO_LOOP_V${loopN}_${cliente}.md"
        if (-not (Test-Path $delib)) {
            $alertas.Add(@{
                tipo    = "INCONSISTENCIA_DISK"
                nivel   = "VERMELHO"
                cliente = $cliente
                detalhe = "[$id] musculo=OK no Loop $loopN mas DELIBERACAO_LOOP_V${loopN}_${cliente}.md ausente. P-091."
            })
        }
    }

    if ($lfa -and $lfa.gemini -eq "OK" -and $lfa.loop -ne $null) {
        $loopN  = $lfa.loop
        $diretriz = Get-ChildItem (Join-Path $BASE "CLIENTES\$cliente\NOTEBOOKLM_FONTES") -Filter "12_DIRETRIZ_GEMINI_V${loopN}*" -ErrorAction SilentlyContinue
        if (-not $diretriz) {
            $alertas.Add(@{
                tipo    = "INCONSISTENCIA_DISK"
                nivel   = "AMARELO"
                cliente = $cliente
                detalhe = "[$id] gemini=OK no Loop $loopN mas 12_DIRETRIZ_GEMINI_V${loopN}* ausente em NOTEBOOKLM_FONTES. P-091."
            })
        }
    }

    # --- VERIFICACAO 3: ultimo_contato_cliente vencido ---
    if (-not $skip -and $proj.ultimo_contato_cliente -and $proj.churn_watch_threshold) {
        try {
            $ultimoContato = [datetime]::ParseExact($proj.ultimo_contato_cliente, "yyyy-MM-dd", $null)
            $diasSemContato = ($hoje - $ultimoContato).Days
            $threshold = [int]$proj.churn_watch_threshold

            if ($diasSemContato -gt ($threshold * 2)) {
                $alertas.Add(@{
                    tipo    = "CHURN_CRITICO"
                    nivel   = "VERMELHO"
                    cliente = $cliente
                    detalhe = "[$id] $diasSemContato dias sem contato (threshold: ${threshold}d). RISCO CRITICO de churn."
                })
            } elseif ($diasSemContato -gt $threshold) {
                $alertas.Add(@{
                    tipo    = "CHURN_ATENCAO"
                    nivel   = "AMARELO"
                    cliente = $cliente
                    detalhe = "[$id] $diasSemContato dias sem contato (threshold: ${threshold}d). Verificar engajamento."
                })
            } else {
                $ok.Add("[$id] $cliente contato: ${diasSemContato}d OK (threshold ${threshold}d)")
            }
        } catch { }
    }
}

# --- Output Silencioso (JSON) ---
if ($Silencioso) {
    @{
        timestamp  = $timestamp
        alertas    = $alertas.Count
        ok         = $ok.Count
        vermelho   = @($alertas | Where-Object { $_.nivel -eq "VERMELHO" }).Count
        amarelo    = @($alertas | Where-Object { $_.nivel -eq "AMARELO" }).Count
        detalhes   = @($alertas)
    } | ConvertTo-Json -Depth 5
    exit $(if ($alertas.Count -gt 0) { 1 } else { 0 })
}

# --- Output Visual ---
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  STATE_GUARD -- $timestamp" -ForegroundColor Cyan
Write-Host "  Projetos: $($projetos.Count) | OK: $($ok.Count) | Alertas: $($alertas.Count)" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan

$vermelhos = @($alertas | Where-Object { $_.nivel -eq "VERMELHO" })
$amarelos  = @($alertas | Where-Object { $_.nivel -eq "AMARELO" })

if ($alertas.Count -eq 0) {
    Write-Host "  [VERDE] Estado do WIP_BOARD sem anomalias detectadas." -ForegroundColor Green
} else {
    if ($vermelhos.Count -gt 0) {
        Write-Host ""
        Write-Host "  [VERMELHO] $($vermelhos.Count) anomalia(s) critica(s):" -ForegroundColor Red
        foreach ($a in $vermelhos) {
            Write-Host "    >> $($a.detalhe)" -ForegroundColor Red
        }
    }
    if ($amarelos.Count -gt 0) {
        Write-Host ""
        Write-Host "  [AMARELO] $($amarelos.Count) anomalia(s) informativa(s):" -ForegroundColor Yellow
        foreach ($a in $amarelos) {
            Write-Host "    >> $($a.detalhe)" -ForegroundColor Yellow
        }
    }
}

if ($ok.Count -gt 0) {
    Write-Host ""
    Write-Host "  [OK] $($ok.Count) verificacao(s) sem anomalia:" -ForegroundColor DarkGray
    foreach ($o in $ok) { Write-Host "    . $o" -ForegroundColor DarkGray }
}
Write-Host ""

# --- Telegram ---
if ($Telegram -and $alertas.Count -gt 0) {
    $credFile = Join-Path $BASE "N8N Easypanel.txt"
    $tgToken  = $env:TELEGRAM_BOT_TOKEN
    $tgChatId = $env:TELEGRAM_CHAT_ID_DIRETOR
    if ([string]::IsNullOrWhiteSpace($tgToken) -and (Test-Path $credFile)) {
        $cred = Get-Content $credFile -Raw
        if ($cred -match "TELEGRAM_BOT_TOKEN[=:\s]+([^\r\n]+)") { $tgToken = $matches[1].Trim() }
        if ($cred -match "TELEGRAM_CHAT_ID_DIRETOR[=:\s]+([^\r\n]+)") { $tgChatId = $matches[1].Trim() }
    }
    if ($tgToken -and $tgChatId) {
        $linhas = @("STATE_GUARD $timestamp", "[VERMELHO] $($vermelhos.Count) | [AMARELO] $($amarelos.Count)")
        $alertas | Select-Object -First 5 | ForEach-Object { $linhas += "- $($_.detalhe)" }
        $msg = $linhas -join "`n"
        $body = @{ chat_id = $tgChatId; text = $msg } | ConvertTo-Json
        try {
            Invoke-RestMethod -Uri "https://api.telegram.org/bot$tgToken/sendMessage" -Method POST -Body $body -ContentType "application/json; charset=utf-8" -ErrorAction Stop | Out-Null
        } catch { }
    }
}

exit $(if ($vermelhos.Count -gt 0) { 1 } else { 0 })
