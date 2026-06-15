# mapa_diario_pendencias.ps1 -- P-069
# Visibilidade cruzada de pendencias por data calendario em todos os projetos ativos.
# Uso: .\scripts\mapa_diario_pendencias.ps1
# Output: mapa agrupado por data + sugestao de acao ao Diretor

param(
    [switch]$Silencioso  # retorna texto sem cabecalho de execucao
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$raiz       = Split-Path $PSScriptRoot -Parent
$pendPath   = Join-Path $raiz "PENDENTES.md"
$hoje       = (Get-Date).Date
$diaSemana  = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))

# --- GATE PASSO 0 (P-158 / P-165): bloqueia o MAPA se 0A+0B+0C nao concluidos ---
# Excecao: modo -Silencioso (session_start, roda ANTES da abertura) nunca bloqueia.
if (-not $Silencioso) {
    $gateScript = Join-Path $PSScriptRoot "gate_passo0_abertura.ps1"
    if (Test-Path $gateScript) {
        $gateOut = & powershell.exe -NonInteractive -File $gateScript -Verificar 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Output ($gateOut -join "`n")
            Write-Output ""
            Write-Output "==== MAPA DIARIO BLOQUEADO (P-165) ===="
            Write-Output "Sequencia de abertura incompleta. Conclua 0A (Notion) + 0B (Cowork INBOX) + 0C (Calendario)"
            Write-Output "antes de apresentar o MAPA DIARIO. INBOX vazio != etapa concluida."
            exit 1
        }
    }
}

if (-not (Test-Path $pendPath)) {
    Write-Output "[MAPA DIARIO] PENDENTES.md nao encontrado."
    exit 0
}

$linhas = Get-Content $pendPath -Encoding UTF8 -ErrorAction SilentlyContinue
if (-not $linhas) { exit 0 }

# --- Parseamento ---
$projetoAtual = "GERAL"
$pendencias   = @()

foreach ($linha in $linhas) {
    # Detectar cabecalho de projeto
    if ($linha -match '^## (PROJ-\d+[^\-]*|ALERTAS|PROCESSO)') {
        $projetoAtual = $Matches[1].Trim()
    }

    # Detectar item pendente
    if ($linha -match '^\s*- \[ \]') {
        # Extrair data
        $dataMatch = [regex]::Match($linha, '`(\d{4}-\d{2}-\d{2})')
        $dataPend  = if ($dataMatch.Success) { [datetime]::Parse($dataMatch.Groups[1].Value) } else { $hoje }

        # Extrair titulo (sem data e sem markdown de negrito)
        $titulo = $linha -replace '^\s*- \[ \]\s*', ''
        $titulo = $titulo -replace '`[^`]*`\s*', ''
        $titulo = $titulo -replace '\*\*([^*]+)\*\*', '$1'
        $titulo = $titulo.Trim()

        # Classificar quem pode desbloquear
        $precisaDiretor = $false
        if ($titulo -match 'ACAO DO DIRETOR|gate admin|presencial|[Dd]iretor|[Gg]ate bloqueante') {
            $precisaDiretor = $true
        }

        $pendencias += [PSCustomObject]@{
            Data          = $dataPend
            Projeto       = $projetoAtual
            Titulo        = $titulo
            PrecisaDiretor = $precisaDiretor
            Atraso        = ($hoje - $dataPend.Date).Days
        }
    }
}

if ($pendencias.Count -eq 0) {
    Write-Output "[MAPA DIARIO] Nenhuma pendencia aberta encontrada."
    exit 0
}

# --- Agrupamento ---
$vencidas   = @($pendencias | Where-Object { $_.Atraso -gt 0 } | Sort-Object Data)
$hoje_items = @($pendencias | Where-Object { $_.Atraso -eq 0 })
$futuras    = @($pendencias | Where-Object { $_.Atraso -lt 0 } | Sort-Object Data)

# --- Montagem do mapa ---
$sep   = "-" * 60
$linhasOut = @()

$linhasOut += ""
$linhasOut += "==== MAPA DIARIO DE PENDENCIAS -- P-069 ===="
$linhasOut += "Data: $(Get-Date -Format 'yyyy-MM-dd') ($diaSemana)"
$linhasOut += $sep

# Vencidas
if ($vencidas.Count -gt 0) {
    $linhasOut += ""
    $linhasOut += "VENCIDAS ($($vencidas.Count)) -- resolver PRIMEIRO:"
    foreach ($p in $vencidas) {
        $quem    = if ($p.PrecisaDiretor) { "[GATE -> Diretor]" } else { "[Musculo executa]" }
        $d       = if ($p.Atraso -eq 1) { "1 dia atraso" } else { "$($p.Atraso) dias atraso" }
        $diaSemV = $p.Data.ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
        $linhasOut += "  [!!] $($p.Projeto) | $($p.Titulo)"
        $linhasOut += "       $quem | $d | $($p.Data.ToString('dd-MM-yyyy')) $diaSemV"
    }
}

# Hoje
if ($hoje_items.Count -gt 0) {
    $linhasOut += ""
    $linhasOut += "HOJE -- $(Get-Date -Format 'dd/MM') ($diaSemana) ($($hoje_items.Count) item(ns)):"
    foreach ($p in $hoje_items) {
        $quem    = if ($p.PrecisaDiretor) { "[GATE -> Diretor]" } else { "[Musculo executa]" }
        $diaSemH = $p.Data.ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
        $linhasOut += "  [>>] $($p.Projeto) | $($p.Titulo)"
        $linhasOut += "       $quem | $($p.Data.ToString('dd-MM-yyyy')) $diaSemH"
    }
} else {
    $linhasOut += ""
    $linhasOut += "HOJE -- $(Get-Date -Format 'dd/MM'): Nenhuma pendencia com data de hoje."
}

# Proximos 7 dias
$proximas7 = @($futuras | Where-Object { $_.Atraso -ge -7 })
if ($proximas7.Count -gt 0) {
    $linhasOut += ""
    $linhasOut += "PROXIMOS 7 DIAS ($($proximas7.Count) item(ns)):"
    foreach ($p in $proximas7 | Sort-Object Data) {
        $diaSem = $p.Data.ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
        $quem   = if ($p.PrecisaDiretor) { "[GATE -> Diretor]" } else { "[Musculo executa]" }
        $linhasOut += "  [  ] $($p.Data.ToString('dd-MM-yyyy')) $diaSem | $($p.Projeto) | $($p.Titulo)"
        $linhasOut += "       $quem"
    }
}

$linhasOut += ""
$linhasOut += $sep

# --- Sugestao de acao ---
$totalHoje    = $vencidas.Count + $hoje_items.Count
$musculoHoje  = @($vencidas + $hoje_items | Where-Object { -not $_.PrecisaDiretor })
$diretorHoje  = @($vencidas + $hoje_items | Where-Object { $_.PrecisaDiretor })

$linhasOut += ""
$linhasOut += "RESUMO: $totalHoje pendencia(s) imediata(s) em $( ($vencidas + $hoje_items | Select-Object -ExpandProperty Projeto -Unique).Count ) projeto(s)"

if ($musculoHoje.Count -gt 0) {
    $linhasOut += "  Musculo executa agora ($($musculoHoje.Count)):"
    foreach ($m in $musculoHoje) {
        $diaSemM = $m.Data.ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
        $linhasOut += "    -> $($m.Projeto): $($m.Titulo) [$($m.Data.ToString('dd-MM-yyyy')) $diaSemM]"
    }
}

if ($diretorHoje.Count -gt 0) {
    $linhasOut += "  Aguarda deliberacao do Diretor ($($diretorHoje.Count)):"
    foreach ($d in $diretorHoje) {
        $diaSemD = $d.Data.ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
        $linhasOut += "    -> $($d.Projeto): $($d.Titulo) [$($d.Data.ToString('dd-MM-yyyy')) $diaSemD]"
    }
    $linhasOut += ""
    $linhasOut += "  PERGUNTA AO DIRETOR: Ha $($diretorHoje.Count) gate(s) bloqueado(s) aguardando sua deliberacao."
    $linhasOut += "  Deseja desbloquear algum agora ou priorizamos o que o Musculo pode executar?"
}

$linhasOut += ""

# --- LEMBRETE ANTIGRAVITY (P-163 / P-165): vive no artefato que o Musculo sempre apresenta ---
if (-not $Silencioso) {
    $linhasOut += $sep
    $linhasOut += "LEMBRETE ANTIGRAVITY (P-163): ao acionar o Antigravity nesta sessao, abrir SEMPRE"
    $linhasOut += "com @concise-planning (qualquer papel) ANTES da skill do papel. Alertar o Diretor."
    $linhasOut += "Estrategista: @concise-planning -> @brainstorming | Comando: scripts\ir_ao_antigravity.ps1"
    $linhasOut += ""
}

Write-Output ($linhasOut -join "`n")
exit 0
