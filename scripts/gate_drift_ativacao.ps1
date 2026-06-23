#Requires -Version 5.1
# gate_drift_ativacao.ps1 -- Drift-guard dos comandos de ativacao A/B (P-146)
# Garante que a fonte de verdade (scripts/comandos_ativacao_atores.json) e a copia
# embutida no Code node do W-11 (scripts/w11_calcular_ativacoes.js) NUNCA divirjam.
# Os comandos vivem DUPLICADOS porque o n8n Code node nao le arquivo do repo --
# este gate transforma "nao podem divergir" de disciplina manual em check mecanico.
#
# Compara:
#   (A) TEXTO + ROTULO de cada comando referenciado na agenda (JSON.texto presente no .js)
#   (B) AGENDA dia-a-dia: JSON.agenda_ativacao_manual (Monday..Sunday) vs JS AGENDA (0..6)
#
# exit 0 = em sincronia | exit 1 = drift detectado | exit 2 = arquivo-fonte ausente
# Uso: .\scripts\gate_drift_ativacao.ps1 [-Quiet]
param([switch]$Quiet)

$ErrorActionPreference = "Stop"
$raiz   = Split-Path $PSScriptRoot -Parent
$jsonPath = Join-Path $PSScriptRoot "comandos_ativacao_atores.json"
$jsPath   = Join-Path $PSScriptRoot "w11_calcular_ativacoes.js"

function Say($msg, $color) { if (-not $Quiet) { Write-Host $msg -ForegroundColor $color } }

if (-not (Test-Path $jsonPath)) { Say "[DRIFT-ATIVACAO] FONTE AUSENTE: $jsonPath" Red; exit 2 }
if (-not (Test-Path $jsPath))   { Say "[DRIFT-ATIVACAO] FONTE AUSENTE: $jsPath" Red; exit 2 }

$json  = Get-Content -LiteralPath $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
$jsRaw = Get-Content -LiteralPath $jsPath   -Raw -Encoding UTF8

# Mapa nome-do-dia (JSON) -> indice getDay() (JS)
$diaNum = @{ Sunday=0; Monday=1; Tuesday=2; Wednesday=3; Thursday=4; Friday=5; Saturday=6 }
# Grupo JSON -> chave curta usada no .js (ed / pj / cw)
$grupos = @{ embaixador_digital = "ed"; projetista = "pj"; executor_cowork = "cw" }

$erros = @()

# ---------- Parse da AGENDA do .js ----------
# Bloco: const AGENDA = { 0: { ed: ['radar'], pj: [] }, ... };
$mBloco = [regex]::Match($jsRaw, 'const\s+AGENDA\s*=\s*\{(.+?)\};', 'Singleline')
if (-not $mBloco.Success) { Say "[DRIFT-ATIVACAO] Nao encontrei 'const AGENDA' no .js -- estrutura mudou." Red; exit 1 }
$blocoAgenda = $mBloco.Groups[1].Value

$jsAgenda = @{}  # num -> @{ ed = @(...); pj = @(...); cw = @(...) }
# Captura o corpo { ... } de cada dia e extrai cada grupo individualmente --
# robusto a ordem e ao numero de grupos (ed/pj/cw e futuros).
foreach ($lm in [regex]::Matches($blocoAgenda, '(\d)\s*:\s*\{([^}]*)\}')) {
    $num   = [int]$lm.Groups[1].Value
    $corpo = $lm.Groups[2].Value
    $dia   = @{ ed = @(); pj = @(); cw = @() }
    foreach ($curto in @('ed','pj','cw')) {
        $mg = [regex]::Match($corpo, "$curto\s*:\s*\[([^\]]*)\]")
        if ($mg.Success) {
            $dia[$curto] = @([regex]::Matches($mg.Groups[1].Value, "'([^']+)'") | ForEach-Object { $_.Groups[1].Value })
        }
    }
    $jsAgenda[$num] = $dia
}

# ---------- CHECK B: agenda dia-a-dia ----------
$comandosUsados = @{ ed = @{}; pj = @{}; cw = @{} }  # coleta uniao p/ CHECK A
foreach ($nome in $diaNum.Keys) {
    $num = $diaNum[$nome]
    $jDia = $json.agenda_ativacao_manual.$nome
    foreach ($g in $grupos.Keys) {
        $curto = $grupos[$g]
        $listaJson = @($jDia.$g)            # ex.: @('radar','validacao')
        $listaJs   = @()
        if ($jsAgenda.ContainsKey($num)) { $listaJs = @($jsAgenda[$num].$curto) }
        foreach ($c in $listaJson) { $comandosUsados[$curto][$c] = $true }

        $soJson = @($listaJson | Where-Object { $listaJs -notcontains $_ })
        $soJs   = @($listaJs   | Where-Object { $listaJson -notcontains $_ })
        if ($soJson.Count -gt 0) { $erros += "AGENDA $nome ($curto): JSON tem [$($soJson -join ',')] que o .js NAO tem" }
        if ($soJs.Count   -gt 0) { $erros += "AGENDA $nome ($curto): .js tem [$($soJs -join ',')] que o JSON NAO tem" }
    }
}

# ---------- CHECK A: texto + rotulo de cada comando usado (igualdade EXATA) ----------
# Extrai do .js o rotulo/texto de cada comando e compara byte-a-byte com o JSON.
# Comparar por igualdade (nao Contains) pega drift em qualquer direcao, inclusive
# texto extra acrescentado num lado mantendo o original como prefixo.
# CONTRATO assumido do .js (garantido pelo gerador w11_calcular_ativacoes.js):
#   (1) campos na ordem 'rotulo' e depois 'texto'; (2) textos SEM aspa simples (').
#   Quebrar qualquer um gera falso "ilegivel no .js" -- alinhe o .js ou ajuste o regex.
foreach ($g in $grupos.Keys) {
    $curto = $grupos[$g]
    foreach ($chave in $comandosUsados[$curto].Keys) {
        $c = $json.comandos_canonicos.$g.$chave
        if (-not $c) { $erros += "TEXTO ($curto/$chave): comando ausente em comandos_canonicos do JSON"; continue }
        $jsonTexto  = ($c.texto  -replace "`r","" -replace "`n", '\n')
        $jsonRotulo = ($c.rotulo -replace "`r","" -replace "`n", '\n')

        # Bloco no .js:  <chave>: { rotulo: '...', texto: '...' }
        $m = [regex]::Match($jsRaw, "$([regex]::Escape($chave))\s*:\s*\{\s*rotulo\s*:\s*'([^']*)'\s*,\s*texto\s*:\s*'([^']*)'\s*\}")
        if (-not $m.Success) { $erros += "TEXTO ($curto/$chave): comando '$chave' nao encontrado/ilegivel no .js"; continue }
        $jsRotulo = $m.Groups[1].Value
        $jsTexto  = $m.Groups[2].Value
        if ($jsRotulo -ne $jsonRotulo) { $erros += "ROTULO ($curto/$chave): JSON='$jsonRotulo' != .js='$jsRotulo'" }
        if ($jsTexto  -ne $jsonTexto)  { $erros += "TEXTO ($curto/$chave): texto divergiu entre JSON e .js" }
    }
}

if ($erros.Count -gt 0) {
    Say "[DRIFT-ATIVACAO] DRIFT DETECTADO -- JSON e W-11(.js) divergiram:" Red
    foreach ($e in $erros) { Say "  - $e" Yellow }
    Say "  Acao: alinhe scripts/comandos_ativacao_atores.json e scripts/w11_calcular_ativacoes.js (e re-PUT o W-11 se mudou o .js)." Yellow
    exit 1
}

Say "[DRIFT-ATIVACAO] OK -- comandos_ativacao_atores.json e w11_calcular_ativacoes.js em sincronia." Green
exit 0
