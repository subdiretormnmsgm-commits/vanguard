#Requires -Version 5.1
# update_memoria_embaixador.ps1
# P-032 + P-145 -- Atualiza MEMORIA_EMBAIXADOR automaticamente apos socio concluir
# Modos: -Passo 5 (NotebookLM/Auditor) | -Passo 7 (Embaixador/Secao D)
# Chamado por: PASSO5.5 (apos AUDITOR_LOOP salvo) | PASSO7.5 (apos Secao D colada)
# session_close Gate 6B: exit 1 se nenhum modo rodou na sessao com vereditos

param(
    [Parameter(Mandatory=$true)]
    [string]$Cliente,

    [Parameter(Mandatory=$true)]
    [ValidateSet("5","7")]
    [string]$Passo,

    [string]$Resumo = "",

    [string]$Temperatura = "",

    [switch]$Status
)

$raiz = Split-Path $PSScriptRoot -Parent
$clienteUpper = $Cliente.ToUpper()
$data = Get-Date -Format "yyyy-MM-dd"
$hora = Get-Date -Format "HH:mm"

$memoriaPath = "$raiz\CLIENTES\$clienteUpper\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
$loopStatePath = "$raiz\CLIENTES\$clienteUpper\CLAUDE_PROJECT\LOOP_STATE.json"
$flagPath = "$raiz\scripts\.memoria_atualizada_hoje_$clienteUpper.flag"

# --- VALIDACOES ---
if (-not (Test-Path $memoriaPath)) {
    Write-Host "[ERRO] MEMORIA_EMBAIXADOR nao encontrada: $memoriaPath" -ForegroundColor Red
    exit 2
}
if (-not (Test-Path $loopStatePath)) {
    Write-Host "[ERRO] LOOP_STATE nao encontrado: $loopStatePath" -ForegroundColor Red
    exit 2
}

$loopState = Get-Content $loopStatePath -Raw -Encoding UTF8 | ConvertFrom-Json
$loopAtual = $loopState.loop_atual

# --- MODO STATUS ---
if ($Status) {
    $flagExiste = Test-Path $flagPath
    if ($flagExiste) {
        $flagData = (Get-Item $flagPath).LastWriteTime.ToString("yyyy-MM-dd")
        if ($flagData -eq $data) {
            Write-Host "[OK] MEMORIA_EMBAIXADOR $clienteUpper atualizada hoje ($data) -- P-032 VERDE" -ForegroundColor Green
            exit 0
        }
    }
    Write-Host "[ALERTA] MEMORIA_EMBAIXADOR $clienteUpper NAO atualizada hoje -- P-032 pendente" -ForegroundColor Yellow
    exit 1
}

# --- EXTRAIR CONTEUDO DO SOCIO ---
$socioNome = ""
$entradaLog = ""
$novaTemperatura = ""

if ($Passo -eq "5") {
    $socioNome = "NotebookLM (Auditor)"

    # Localizar AUDITOR_LOOP mais recente
    $auditorDir = "$raiz\CLIENTES\$clienteUpper\HISTORICO"
    $auditorFiles = Get-ChildItem $auditorDir -Filter "AUDITOR_LOOP_V*$($clienteUpper.ToLower())*.md" -ErrorAction SilentlyContinue |
                    Sort-Object LastWriteTime -Descending
    if (-not $auditorFiles) {
        $auditorFiles = Get-ChildItem $auditorDir -Filter "AUDITOR_LOOP*.md" -ErrorAction SilentlyContinue |
                        Sort-Object LastWriteTime -Descending
    }

    if ($Resumo -ne "") {
        $entradaLog = $Resumo
    } elseif ($auditorFiles) {
        $auditorMaisRecente = $auditorFiles[0].FullName
        $auditorConteudo = Get-Content $auditorMaisRecente -Raw -Encoding UTF8

        # Extrair secao PERSPECTIVA DE SOCIO CONSULTOR
        $blocoConsultor = ""
        if ($auditorConteudo -match "(?s)## PARTE 2.+?PERSPECTIVA.+?\n(.+?)(?=\n## PARTE [34]|\z)") {
            $blocoConsultor = $matches[1] -replace "\n", " " -replace "\s+", " "
            if ($blocoConsultor.Length -gt 200) { $blocoConsultor = $blocoConsultor.Substring(0, 197) + "..." }
        }

        # Extrair alertas relevantes
        $alertas = ""
        if ($auditorConteudo -match "(?s)Risco central:(.+?)(?=\n\n|\z)") {
            $alertas = $matches[1].Trim() -replace "\n", " "
            if ($alertas.Length -gt 150) { $alertas = $alertas.Substring(0, 147) + "..." }
        }

        $entradaLog = "Auditor Loop $loopAtual concluido."
        if ($blocoConsultor) { $entradaLog += " Perspectiva: $blocoConsultor" }
        if ($alertas) { $entradaLog += " | Risco: $alertas" }
    } else {
        $entradaLog = "Auditor Loop $loopAtual concluido. (sem AUDITOR_LOOP em disco -- inserir resumo manualmente)"
    }

} elseif ($Passo -eq "7") {
    $socioNome = "Embaixador (Secao D)"

    if ($Resumo -ne "") {
        $entradaLog = $Resumo
    } else {
        # Tentar ler SECAO_D colada em arquivo padrao
        $secaoDPath = "$raiz\CLIENTES\$clienteUpper\CLAUDE_PROJECT\SECAO_D_ATUAL.md"
        if (Test-Path $secaoDPath) {
            $secaoDConteudo = Get-Content $secaoDPath -Raw -Encoding UTF8

            # Extrair temperatura se presente
            if ($secaoDConteudo -match "(?i)temperatura.{0,20}(\d+[\.,]\d+)/10") {
                $novaTemperatura = $matches[1]
            } elseif ($secaoDConteudo -match "(?i)(VERDE FORTE|VERDE|AMARELO|VERMELHO|QUENTE|FRIO|ENGAJADA)") {
                $novaTemperatura = $matches[1]
            }

            # Resumo das decisoes D1-Dn
            $decisoes = [System.Collections.Generic.List[string]]::new()
            $linhas = $secaoDConteudo -split "`n"
            foreach ($linha in $linhas) {
                if ($linha -match "^\|\s*(D\d+|E-\d+)\s*\|") {
                    $cols = $linha -split "\|" | Where-Object { $_ -ne "" }
                    if ($cols.Count -ge 2) {
                        $codigo = $cols[0].Trim()
                        $tema = $cols[1].Trim()
                        $decisoes.Add("$codigo/$tema")
                    }
                }
            }
            $resumoDecisoes = if ($decisoes.Count -gt 0) { " Decisoes: " + ($decisoes -join "; ") } else { "" }
            $entradaLog = "Embaixador Loop $loopAtual Secao D processada.$resumoDecisoes"
            if ($novaTemperatura) { $entradaLog += " | Temperatura: $novaTemperatura/10" }
        } else {
            $entradaLog = "Embaixador Loop $loopAtual Secao D colada. (sem SECAO_D_ATUAL.md -- usar -Resumo para detalhar)"
        }
    }

    # Extrair temperatura se passada via param
    if ($Temperatura -ne "") {
        $novaTemperatura = $Temperatura
    }
}

# --- GERAR LINHA DO LOG DE CONTATOS ---
$linhaLog = "| $data | $socioNome | **Loop $loopAtual concluido** -- $entradaLog | Musculo (P-032) |"

# --- INSERIR NO LOG DE CONTATOS ---
$memoriaConteudo = Get-Content $memoriaPath -Raw -Encoding UTF8

# Localizar a tabela CONTATOS REGISTRADOS e inserir logo apos o cabecalho
$marcadorTabela = "| Data | Canal | Evento objetivo | Fonte |"
$marcadorSeparador = "|---|---|---|---|"

if ($memoriaConteudo -match [regex]::Escape($marcadorSeparador)) {
    # Inserir como primeira linha de dados (logo apos o separador de cabecalho)
    $memoriaConteudo = $memoriaConteudo -replace (
        [regex]::Escape($marcadorSeparador + "`n"),
        "$marcadorSeparador`n$linhaLog`n"
    )
    Write-Host "[OK] Linha inserida no LOG DE CONTATOS" -ForegroundColor Green
} else {
    Write-Host "[AVISO] Separador de tabela nao encontrado -- adicionando ao final da secao CONTATOS" -ForegroundColor Yellow
    $memoriaConteudo += "`n`n$linhaLog"
}

# --- ATUALIZAR TEMPERATURA (se informada) ---
if ($novaTemperatura -ne "") {
    # Atualizar o campo "Ultima atualizacao" no bloco de temperatura
    $memoriaConteudo = $memoriaConteudo -replace (
        "(Ultima atualizacao:)(.+?)(\n```)",
        "`$1 $data (Musculo P-032 -- $socioNome Loop $loopAtual)`$3"
    )
    Write-Host "[OK] Timestamp de temperatura atualizado -- $novaTemperatura" -ForegroundColor Cyan
}

# --- SALVAR MEMORIA ---
[System.IO.File]::WriteAllText($memoriaPath, $memoriaConteudo, [System.Text.UTF8Encoding]::new($false))
Write-Host "[OK] MEMORIA_EMBAIXADOR $clienteUpper salva: $memoriaPath" -ForegroundColor Green

# --- ATUALIZAR LOOP_STATE.json gate p032 ---
$loopStateConteudo = Get-Content $loopStatePath -Raw -Encoding UTF8
$loopStateConteudo = $loopStateConteudo -replace '"p032_memoria_embaixador_atualizada":\s*(true|false)', '"p032_memoria_embaixador_atualizada": true'
[System.IO.File]::WriteAllText($loopStatePath, $loopStateConteudo, [System.Text.UTF8Encoding]::new($false))
Write-Host "[OK] LOOP_STATE.json -- p032_memoria_embaixador_atualizada = true" -ForegroundColor Green

# --- CRIAR FLAG DO DIA ---
[System.IO.File]::WriteAllText($flagPath, "$data $hora -- Passo $Passo -- $socioNome", [System.Text.UTF8Encoding]::new($false))

# --- RELATORIO FINAL ---
Write-Host ""
Write-Host "=== UPDATE_MEMORIA_EMBAIXADOR -- $clienteUpper ===" -ForegroundColor Cyan
Write-Host "Loop      : $loopAtual" -ForegroundColor White
Write-Host "Socio     : $socioNome" -ForegroundColor White
Write-Host "Entrada   : $($entradaLog.Substring(0, [Math]::Min(100, $entradaLog.Length)))..." -ForegroundColor White
Write-Host "P-032     : VERDE -- flag criada" -ForegroundColor Green
Write-Host ""
Write-Host "PROXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "  1. Verificar LOG DE CONTATOS em MEMORIA_EMBAIXADOR.md" -ForegroundColor White
Write-Host "  2. Se passo 7: verificar temperatura atualizada em CAMADA_INFERENCIA" -ForegroundColor White
Write-Host "  3. session_close Gate 6B vai passar (flag do dia criada)" -ForegroundColor White
exit 0
