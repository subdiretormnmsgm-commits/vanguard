#Requires -Version 5.1
# render_painel.ps1 - Le DECISOES JSON do Embaixador e gera Painel HTML interativo
# Uso: .\scripts\render_painel.ps1 -projeto INGRID
#      .\scripts\render_painel.ps1 -projeto VALDECE -data 2026-05-24

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("INGRID","VALDECE","VANGUARD")]
    [string]$projeto,

    [string]$data = "",

    [switch]$forcar
)

$raiz = Split-Path -Parent $PSScriptRoot
Set-Location $raiz

$decisoesDir = "CLIENTES\$projeto\CLAUDE_PROJECT\DECISOES"
$templatePath = "scripts\painel_template.html"

# --- 1. Localizar arquivo DECISOES (ignora _ARQUIVADO/) ---
if ($data -eq "") {
    $decisoesItem = Get-ChildItem "$decisoesDir\DECISOES_${projeto}_*.json" -ErrorAction SilentlyContinue |
        Where-Object { $_.DirectoryName -notmatch "_ARQUIVADO" } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $decisoesItem) {
        Write-Host "[render_painel] Nenhum DECISOES pendente encontrado para $projeto. Nada a deliberar." -ForegroundColor Green
        exit 0
    }

    $dataExtraida = $decisoesItem.BaseName -replace "^DECISOES_${projeto}_", ""
    $vereditos    = Get-ChildItem "$decisoesDir\VEREDITOS_${projeto}_${dataExtraida}.json" -ErrorAction SilentlyContinue

    if ($vereditos) {
        Write-Host ("DECISOES de " + $dataExtraida + " ja tem VEREDITOS correspondente.") -ForegroundColor Yellow
        Write-Host "    Se quiser reabrir: rode com -forcar" -ForegroundColor DarkGray
        if (-not $forcar) { exit 0 }
    }

    $decisoesFile = $decisoesItem.FullName
    Write-Host ("Usando arquivo: " + $decisoesItem.Name)
} else {
    $decisoesFile = "$decisoesDir\DECISOES_${projeto}_${data}.json"
    if (-not (Test-Path $decisoesFile)) {
        Write-Error ("Arquivo nao encontrado: " + $decisoesFile)
        exit 1
    }
}

# --- 2. Ler e validar JSON ---
try {
    $decisoesRaw = Get-Content $decisoesFile -Raw -Encoding UTF8
    $decisoesObj = $decisoesRaw | ConvertFrom-Json
} catch {
    Write-Error ("JSON invalido em " + $decisoesFile + ": " + $_)
    exit 1
}

# --- Injetar campos obrigatorios ausentes (tolerancia a JSON do Embaixador sem esses campos) ---
if (-not $decisoesObj.projeto_label) {
    $decisoesObj | Add-Member -NotePropertyName "projeto_label" `
        -NotePropertyValue $projeto -Force
}
if (-not $decisoesObj.cliente_label) {
    $decisoesObj | Add-Member -NotePropertyName "cliente_label" `
        -NotePropertyValue $projeto -Force
}
if (-not $decisoesObj.secoes) {
    # Derivar secoes unicas a partir das decisoes existentes
    $secoesMap = [ordered]@{
        "prerequisito"  = "Pre-requisitos (executar primeiro)"
        "acao_imediata" = "Acao Imediata"
        "inteligencia"  = "Inteligencia e Ajustes"
        "pendencias"    = "Pendencias"
    }
    $secoesUnicas = @($decisoesObj.decisoes | ForEach-Object { $_.secao } | Select-Object -Unique)
    $secoesArr = @($secoesUnicas | ForEach-Object {
        $sid = $_
        $slabel = if ($secoesMap[$sid]) { $secoesMap[$sid] } else { $sid }
        [PSCustomObject]@{ id = $sid; label = $slabel }
    })
    $decisoesObj | Add-Member -NotePropertyName "secoes" -NotePropertyValue $secoesArr -Force
}
# Regravar JSON com campos injetados para o embed no HTML
$decisoesRaw = $decisoesObj | ConvertTo-Json -Depth 15
# --- Fim injecao de campos ---

$dataStr      = $decisoesObj.data
$projetoLabel = $decisoesObj.projeto_label
$loop         = $decisoesObj.loop
$nDecisoes    = $decisoesObj.decisoes.Count

Write-Host ""
Write-Host ("Projeto : " + $projetoLabel)
Write-Host ("Data    : " + $dataStr)
Write-Host ("Loop    : " + $loop)
Write-Host ("Decisoes: " + $nDecisoes)
Write-Host ""

# --- P-037 GATE: sintese do Musculo deve existir antes de abrir Painel de vereditos ---
$historicoDirP037 = Join-Path $raiz "CLIENTES\$projeto\HISTORICO"
$sinteseFlagPath  = Join-Path $raiz "CLIENTES\$projeto\CLAUDE_PROJECT\SOBERANA_P037.flag"
$sinteseArquivo   = Get-ChildItem "$historicoDirP037\DELIBERACAO_LOOP_*.md" -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-4) } |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $sinteseArquivo) {
    # DECISAO SOBERANA: flag suprime o gate (Musculo ja sintetizou offline na sessao)
    $soberanaRecente = $false
    if (Test-Path $sinteseFlagPath) {
        $soberanaRecente = ((Get-Date) - (Get-Item $sinteseFlagPath).LastWriteTime).TotalHours -lt 4
    }
    if (-not $soberanaRecente) {
        Write-Host "=== P-037 GATE -- BLOQUEADO ===" -ForegroundColor Red
        Write-Host "DECISOES.json deve ser renderizado APOS a sintese P-037 do Musculo." -ForegroundColor Red
        Write-Host "Nenhum arquivo DELIBERACAO_LOOP_*.md encontrado (ultimas 4h) em:" -ForegroundColor Yellow
        Write-Host "  $historicoDirP037" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "ACAO: pedir ao Musculo para executar sintese P-037 e gerar" -ForegroundColor Yellow
        Write-Host "      DELIBERACAO_LOOP_V[N]_$projeto.md antes de abrir o Painel." -ForegroundColor Yellow
        Write-Host "Para declarar sintese feita na sessao atual (DECISAO SOBERANA):" -ForegroundColor DarkGray
        Write-Host "  New-Item '$sinteseFlagPath' -ItemType File -Force" -ForegroundColor DarkGray
        Write-Host ""
        exit 2
    }
    Write-Host "  [P-037] DECISAO SOBERANA ativa -- sintese declarada na sessao atual." -ForegroundColor DarkYellow
} else {
    Write-Host ("  [P-037] Sintese OK: " + $sinteseArquivo.Name) -ForegroundColor Green
}
Write-Host ""

# --- P-174 GATE: artefato do Embaixador deve existir antes de abrir Painel de vereditos ---
# Ciclo inviolavel Gemini->NotebookLM->Embaixador->Musculo (P-067). No P-037 o Embaixador ja
# entregou: EMBAIXADOR_LOOP_V[N] tem de estar em disco e NAO ser mais antigo que a sintese.
# Ideia de socio que so vive no chat (E-5/E-6) e perdida na compactacao -- P-174.
$embPath174 = Join-Path $historicoDirP037 ("EMBAIXADOR_LOOP_V" + $loop + "_" + $projeto + ".md")
$emb174Falha = $null
if (-not (Test-Path $embPath174)) {
    $emb174Falha = "AUSENTE: " + (Split-Path $embPath174 -Leaf)
} elseif ($sinteseArquivo -and (Get-Item $embPath174).LastWriteTime -lt $sinteseArquivo.LastWriteTime) {
    $emb174Falha = "STALE: " + (Split-Path $embPath174 -Leaf) + " e mais antigo que " + $sinteseArquivo.Name
}
if ($emb174Falha) {
    if ($forcar) {
        Write-Host ("  [P-174] Embaixador " + $emb174Falha + " -- BYPASS por -forcar.") -ForegroundColor DarkYellow
    } else {
        Write-Host "=== P-174 GATE -- BLOQUEADO ===" -ForegroundColor Red
        Write-Host "DECISOES.json nao pode ser aberto sem o artefato do Embaixador do loop." -ForegroundColor Red
        Write-Host ("  " + $emb174Falha) -ForegroundColor Yellow
        Write-Host ("ACAO: gravar " + $historicoDirP037 + "\EMBAIXADOR_LOOP_V" + $loop + "_" + $projeto + ".md") -ForegroundColor Yellow
        Write-Host "      com E-1..E-X + SECAO D persistidas (P-067/P-174). Bypass: -forcar." -ForegroundColor DarkGray
        exit 2
    }
} else {
    Write-Host ("  [P-174] Artefato do Embaixador OK: EMBAIXADOR_LOOP_V" + $loop + "_" + $projeto + ".md") -ForegroundColor Green
}
Write-Host ""

# --- P-173 GATE: pesquisa viva (yt-search) deve preceder a sintese P-037 ---
$ytGate = Join-Path $PSScriptRoot "gate_yt_search.ps1"
if (Test-Path $ytGate) {
    & $ytGate -Horas 24 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        if ($forcar) {
            Write-Host "  [P-173] Sem yt-search recente -- BYPASS por -forcar." -ForegroundColor DarkYellow
        } else {
            Write-Host "=== P-173 GATE -- BLOQUEADO ===" -ForegroundColor Red
            Write-Host "Sintese P-037 exige pesquisa viva: nenhuma invocacao de yt-search nas ultimas 24h." -ForegroundColor Red
            Write-Host "ACAO: rodar  .\scripts\yt.ps1 ""<query do tema do loop>""  antes de gerar o Painel." -ForegroundColor Yellow
            Write-Host "Bypass (excecao do Diretor): repetir com -forcar." -ForegroundColor DarkGray
            exit 2
        }
    } else {
        Write-Host "  [P-173] Pesquisa viva OK (yt-search <24h)." -ForegroundColor Green
    }
    Write-Host ""
}

# --- 3. Ler template HTML ---
if (-not (Test-Path $templatePath)) {
    Write-Error ("Template nao encontrado: " + $templatePath)
    Write-Host "Certifique-se de que scripts\painel_template.html existe no repositorio."
    exit 1
}

$templateHtml = Get-Content $templatePath -Raw -Encoding UTF8

# --- 4. Substituir placeholder com os dados JSON ---
$decisoesJsonEscaped = $decisoesRaw  # JSON puro - JS vai parsear diretamente

$html = $templateHtml `
    -replace '__DECISOES_DATA__', $decisoesJsonEscaped `
    -replace '__PROJETO_LABEL__', $projetoLabel `
    -replace '__DATA__',          $dataStr

# --- 5. Escrever arquivo HTML (UTF-8 sem BOM, compativel PS 5.1) ---
$painelPath = Join-Path $raiz "$decisoesDir\PAINEL_${projeto}_${dataStr}.html"
[System.IO.File]::WriteAllText($painelPath, $html, [System.Text.Encoding]::UTF8)
Write-Host ("Painel gerado: " + $painelPath)

# --- 6. Abrir no browser ---
Start-Process $painelPath
Write-Host ""
Write-Host "Painel aberto no browser."
Write-Host ""
Write-Host "PROXIMOS PASSOS:"
Write-Host "  1. Marque todos os vereditos no painel"
Write-Host "  2. Clique em [Confirmar vereditos]"
Write-Host ("  3. Salve o arquivo VEREDITOS_" + $projeto + "_" + $dataStr + ".json em:")
Write-Host ("     CLIENTES\" + $projeto + "\CLAUDE_PROJECT\DECISOES\")
Write-Host ("  4. Rode: .\scripts\executar_vereditos.ps1 -projeto " + $projeto)
