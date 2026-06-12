#Requires -Version 5.1
# Register-Veredito.ps1  --  Write-Through atomico (S2 DEF-M-6 -- P-032 automatico)
# Atualiza atomicamente: MEMORIA_EMBAIXADOR + 16_VANGUARD_TIMELINE + WIP_BOARD
# Uso: .\scripts\Register-Veredito.ps1 -Cliente VANGUARD -Decisao "Vertical Licitacoes aprovada" -Impacto "G-2 desbloqueado"
# Parametros opcionais: -Loop (default: le do WIP_BOARD), -Tipo (default: VEREDITO)

param(
    [Parameter(Mandatory)][string]$Cliente,
    [Parameter(Mandatory)][string]$Decisao,
    [Parameter(Mandatory)][string]$Impacto,
    [string]$Loop    = "",
    [string]$Tipo    = "VEREDITO",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$raiz = Split-Path -Parent $PSScriptRoot
$data = Get-Date -Format "yyyy-MM-dd"
$hora = Get-Date -Format "HH:mm"

# --- 1. Verificar cliente no WIP_BOARD ---
$wipPath  = Join-Path $raiz "CLIENTES\WIP_BOARD.json"
$clienteUpper = $Cliente.ToUpper()

if (-not (Test-Path $wipPath)) {
    Write-Host "[ERRO] WIP_BOARD.json nao encontrado em: $wipPath" -ForegroundColor Red
    exit 1
}

$wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$clientesConhecidos = @($wip.board.build | ForEach-Object { $_.cliente.ToUpper() })
if ($clientesConhecidos -notcontains $clienteUpper) {
    Write-Host "[ERRO] Cliente '$Cliente' nao encontrado no WIP_BOARD." -ForegroundColor Red
    Write-Host "       Clientes ativos: $($clientesConhecidos -join ', ')" -ForegroundColor Yellow
    exit 1
}

# Resolver loop atual se nao passado
if (-not $Loop) {
    $proj = $wip.board.build | Where-Object { $_.cliente.ToUpper() -eq $clienteUpper }
    $rawLoop = ""
    if ($proj -and $proj.loop_atual) { $rawLoop = $proj.loop_atual }
    elseif ($wip.meta.loop_atual)   { $rawLoop = $wip.meta.loop_atual }
    if ($rawLoop -match "(\d+)") { $Loop = $Matches[1] }
    elseif ($rawLoop)            { $Loop = $rawLoop }
    else                         { $Loop = "??" }
}

Write-Host ""
Write-Host "Register-Veredito -- $clienteUpper / Loop $Loop" -ForegroundColor Cyan
Write-Host "  Decisao: $Decisao" -ForegroundColor White
Write-Host "  Impacto: $Impacto" -ForegroundColor White
if ($DryRun) { Write-Host "  [DRYRUN] Nenhum arquivo sera alterado." -ForegroundColor DarkCyan }
Write-Host ""

$erros = @()

# ==========================================================================
# PASSO 1 -- Atualizar MEMORIA_EMBAIXADOR (secao LOG DE CONTATOS)
# ==========================================================================
$memoriaPath = Join-Path $raiz "CLIENTES\$clienteUpper\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_$clienteUpper.md"
if (-not (Test-Path $memoriaPath)) {
    # Fallback: tentar VANGUARD sem sufixo
    $memoriaPath = Join-Path $raiz "CLIENTES\$clienteUpper\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
}

if (Test-Path $memoriaPath) {
    $linhasMemoria = [System.Collections.Generic.List[string]](Get-Content $memoriaPath -Encoding UTF8)
    $novaLinha = "| $data $hora | $Tipo -- Loop $Loop | $Decisao -- Impacto: $Impacto |"

    # Localizar secao LOG DE CONTATOS e inserir antes da linha de fechamento da tabela
    $idxLog = -1
    for ($i = 0; $i -lt $linhasMemoria.Count; $i++) {
        if ($linhasMemoria[$i] -match "LOG DE CONTATOS|LOG_CONTATOS|LOG CONTATOS") { $idxLog = $i; break }
    }

    if ($idxLog -ge 0) {
        # Inserir apos o ultimo separador de tabela encontrado apos idxLog
        $idxInsert = $idxLog + 1
        for ($j = $idxLog + 1; $j -lt $linhasMemoria.Count; $j++) {
            if ($linhasMemoria[$j] -match "^\|") { $idxInsert = $j + 1 }
            elseif ($linhasMemoria[$j] -match "^##") { break }
        }
        $linhasMemoria.Insert($idxInsert, $novaLinha)
    } else {
        # Sem secao LOG: adicionar ao final
        $linhasMemoria.Add("")
        $linhasMemoria.Add("## LOG DE CONTATOS")
        $linhasMemoria.Add("| Data | Tipo | Resumo |")
        $linhasMemoria.Add("|---|---|---|")
        $linhasMemoria.Add($novaLinha)
    }

    if (-not $DryRun) {
        [System.IO.File]::WriteAllLines($memoriaPath, $linhasMemoria, [System.Text.UTF8Encoding]::new($false))
        Write-Host "  [OK] MEMORIA_EMBAIXADOR atualizada: $memoriaPath" -ForegroundColor Green
    } else {
        Write-Host "  [DRYRUN] MEMORIA_EMBAIXADOR -- inseriria: $novaLinha" -ForegroundColor DarkCyan
    }
} else {
    $erros += "[AUSENTE] MEMORIA_EMBAIXADOR para $clienteUpper -- path tentado: $memoriaPath"
    Write-Host "  [AVISO] $($erros[-1])" -ForegroundColor Yellow
}

# ==========================================================================
# PASSO 2 -- Atualizar 16_VANGUARD_TIMELINE (secao de vereditos ou log)
# ==========================================================================
$timelinePath = Join-Path $raiz "CLIENTES\$clienteUpper\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
if (-not (Test-Path $timelinePath)) {
    $timelinePath = Join-Path $raiz "CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
}

if (Test-Path $timelinePath) {
    $entrada = "`n- **$data $hora** [${Tipo} Loop $Loop] $Decisao -- Impacto: $Impacto"
    if (-not $DryRun) {
        Add-Content -Path $timelinePath -Value $entrada -Encoding UTF8
        Write-Host "  [OK] 16_VANGUARD_TIMELINE atualizada." -ForegroundColor Green
    } else {
        Write-Host "  [DRYRUN] TIMELINE -- adicionaria: $entrada" -ForegroundColor DarkCyan
    }
} else {
    $erros += "[AUSENTE] 16_VANGUARD_TIMELINE -- path: $timelinePath"
    Write-Host "  [AVISO] $($erros[-1])" -ForegroundColor Yellow
}

# ==========================================================================
# PASSO 3 -- Atualizar WIP_BOARD (campo ultimo_contato_cliente + log)
# ==========================================================================
if (-not $DryRun) {
    try {
        $wipRaw   = Get-Content $wipPath -Raw -Encoding UTF8
        $wipObj   = $wipRaw | ConvertFrom-Json
        $updated  = $false
        foreach ($p in $wipObj.board.build) {
            if ($p.cliente.ToUpper() -eq $clienteUpper) {
                $p | Add-Member -MemberType NoteProperty -Name "ultimo_veredito"       -Value ("$data " + $Tipo + ": $Decisao") -Force
                $p | Add-Member -MemberType NoteProperty -Name "ultimo_veredito_data"  -Value $data                  -Force
                $updated = $true
            }
        }
        if ($updated) {
            $wipJson = $wipObj | ConvertTo-Json -Depth 10
            [System.IO.File]::WriteAllText($wipPath, $wipJson, [System.Text.UTF8Encoding]::new($false))
            Write-Host "  [OK] WIP_BOARD.json atualizado (ultimo_veredito)." -ForegroundColor Green
        }
    } catch {
        $erros += ("[ERRO WIP_BOARD] " + $_.ToString())
        Write-Host ("  [AVISO] Falha ao atualizar WIP_BOARD: " + $_.ToString()) -ForegroundColor Yellow
    }
} else {
    Write-Host "  [DRYRUN] WIP_BOARD -- adicionaria ultimo_veredito para $clienteUpper" -ForegroundColor DarkCyan
}

# ==========================================================================
# RESUMO
# ==========================================================================
Write-Host ""
if ($erros.Count -eq 0) {
    Write-Host "  [Register-Veredito] CONCLUIDO -- 3 arquivos atualizados atomicamente." -ForegroundColor Green
} else {
    Write-Host "  [Register-Veredito] PARCIAL -- $($erros.Count) arquivo(s) com problema:" -ForegroundColor Yellow
    foreach ($e in $erros) { Write-Host ("    " + $e) -ForegroundColor Yellow }
}
Write-Host "  P-032 cumprido para $clienteUpper / Loop $Loop / $data" -ForegroundColor Cyan
Write-Host ""
