# mapa_diario_pendencias.ps1 — P-069
# Visibilidade cruzada de pendencias por data calendario em todos os projetos ativos.
# Uso: .\scripts\mapa_diario_pendencias.ps1
# Output: mapa agrupado por data + sugestao de acao ao Diretor

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

param(
    [switch]$Silencioso  # retorna texto sem cabecalho de execucao
)

$root       = Split-Path $PSScriptRoot -Parent
$pendPath   = Join-Path $root "PENDENTES.md"
$hoje       = (Get-Date).Date
$diaSemana  = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))

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
$linhasOut += "==== MAPA DIARIO DE PENDENCIAS — P-069 ===="
$linhasOut += "Data: $(Get-Date -Format 'yyyy-MM-dd') ($diaSemana)"
$linhasOut += $sep

# Vencidas
if ($vencidas.Count -gt 0) {
    $linhasOut += ""
    $linhasOut += "VENCIDAS ($($vencidas.Count)) — resolver PRIMEIRO:"
    foreach ($p in $vencidas) {
        $quem = if ($p.PrecisaDiretor) { "[GATE -> Diretor]" } else { "[Musculo executa]" }
        $d    = if ($p.Atraso -eq 1) { "1 dia atraso" } else { "$($p.Atraso) dias atraso" }
        $linhasOut += "  [!!] $($p.Projeto) | $($p.Titulo)"
        $linhasOut += "       $quem | $d | Data: $($p.Data.ToString('dd/MM'))"
    }
}

# Hoje
if ($hoje_items.Count -gt 0) {
    $linhasOut += ""
    $linhasOut += "HOJE — $(Get-Date -Format 'dd/MM') ($diaSemana) ($($hoje_items.Count) item(ns)):"
    foreach ($p in $hoje_items) {
        $quem = if ($p.PrecisaDiretor) { "[GATE -> Diretor]" } else { "[Musculo executa]" }
        $linhasOut += "  [>>] $($p.Projeto) | $($p.Titulo)"
        $linhasOut += "       $quem"
    }
} else {
    $linhasOut += ""
    $linhasOut += "HOJE — $(Get-Date -Format 'dd/MM'): Nenhuma pendencia com data de hoje."
}

# Proximos 7 dias
$proximas7 = @($futuras | Where-Object { $_.Atraso -ge -7 })
if ($proximas7.Count -gt 0) {
    $linhasOut += ""
    $linhasOut += "PROXIMOS 7 DIAS ($($proximas7.Count) item(ns)):"
    foreach ($p in $proximas7 | Sort-Object Data) {
        $diaSem = $p.Data.ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
        $quem   = if ($p.PrecisaDiretor) { "[GATE -> Diretor]" } else { "[Musculo executa]" }
        $linhasOut += "  [  ] $($p.Data.ToString('dd/MM')) $diaSem | $($p.Projeto) | $($p.Titulo)"
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
        $linhasOut += "    -> $($m.Projeto): $($m.Titulo)"
    }
}

if ($diretorHoje.Count -gt 0) {
    $linhasOut += "  Aguarda deliberacao do Diretor ($($diretorHoje.Count)):"
    foreach ($d in $diretorHoje) {
        $linhasOut += "    -> $($d.Projeto): $($d.Titulo)"
    }
    $linhasOut += ""
    $linhasOut += "  PERGUNTA AO DIRETOR: Ha $($diretorHoje.Count) gate(s) bloqueado(s) aguardando sua deliberacao."
    $linhasOut += "  Deseja desbloquear algum agora ou priorizamos o que o Musculo pode executar?"
}

$linhasOut += ""

Write-Output ($linhasOut -join "`n")
exit 0
