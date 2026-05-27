#Requires -Version 5.1
# generate_protocolo_encerramento.ps1 - Gera PAINEL_ATIVIDADES preenchido para o Embaixador
# Chamado pelo session_close.ps1 ao encerrar qualquer sessao.
# Output: PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_[DATA].md
# Eduardo faz upload do arquivo ao Embaixador - zero preenchimento manual.

param(
    [string]$EntregasTexto = "",
    [string]$AlertasTexto  = "",
    [string]$AcoesTexto    = "",
    [string]$AnaliseTexto  = ""
)

$raiz = Split-Path -Parent $PSScriptRoot
$data = Get-Date -Format "yyyy-MM-dd"
$hora = Get-Date -Format "HH:mm"
$diaSemana = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
$diaSemana = $diaSemana.Substring(0,1).ToUpper() + $diaSemana.Substring(1)

# --- Diretorio de saida ---
$outputDir = "$raiz\PROTOCOLOS_ENCERRAMENTO"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }
$outputFile = "$outputDir\PAINEL_ATIVIDADES_$data.md"

# --- Ler WIP_BOARD ---
$wipPath = "$raiz\CLIENTES\WIP_BOARD.json"
$wip = $null
if (Test-Path $wipPath) {
    try { $wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json } catch {}
}

# --- Projetos ativos (estrutura: wip.board.build / check / retainer) ---
$linhasProjetos = @()
$colunas = @("build", "check", "retainer")
if ($wip -and $wip.board) {
    foreach ($col in $colunas) {
        $lista = $wip.board.$col
        if (-not $lista) { continue }
        foreach ($proj in $lista) {
            $deadline = if ($proj.deadline) { $proj.deadline } else { "sem prazo" }
            $loop     = if ($proj.loop_atual) { $proj.loop_atual } else { "Loop ?" }
            $colLabel = $col.ToUpper().PadRight(9)
            $nome     = if ($proj.cliente) { $proj.cliente } else { "?" }
            $linhasProjetos += "$($nome.PadRight(10)) [$colLabel]  $loop  Deadline: $deadline"
        }
    }
}
$projetosBloco = if ($linhasProjetos.Count -gt 0) { $linhasProjetos -join "`n" } else { "Nenhum projeto ativo detectado" }

# --- Git (ultimo commit) ---
$gitHash  = "sem-commit"
$gitMsg   = "sem-commit"
$gitFiles = 0
try {
    $gitHash  = (& git -C $raiz log -1 --format="%h" 2>$null).Trim()
    $gitMsg   = (& git -C $raiz log -1 --format="%s" 2>$null).Trim()
    $gitFiles = [int](& git -C $raiz diff --name-only HEAD~1 HEAD 2>$null | Measure-Object).Count
} catch {}

# --- Pendentes por projeto ---
$pendentesPath = "$raiz\PENDENTES.md"
$totalPendentes = 0
$secoes = [ordered]@{}
$secaoAtual = "GERAL"
$hoje = (Get-Date).Date

# Estrutura para deficit (atividades vencidas com dias de atraso)
$deficitItens = [System.Collections.Generic.List[object]]::new()

if (Test-Path $pendentesPath) {
    $linhas = Get-Content $pendentesPath -Encoding UTF8
    $secoesIgnorar = @("COMO USAR", "INSTRUCOES", "LEGENDA")
    $ignorandoSecao = $false
    foreach ($l in $linhas) {
        if ($l -match "^## (.+)") {
            $candidato = $matches[1].Trim()
            if ($secoesIgnorar -contains $candidato) {
                $ignorandoSecao = $true
            } else {
                $ignorandoSecao = $false
                $secaoAtual = $candidato
                if (-not $secoes.Contains($secaoAtual)) { $secoes[$secaoAtual] = [System.Collections.Generic.List[string]]::new() }
            }
        }
        if (-not $ignorandoSecao -and $l -match "^\- \[ \]") {
            $totalPendentes++
            if (-not $secoes.Contains($secaoAtual)) { $secoes[$secaoAtual] = [System.Collections.Generic.List[string]]::new() }
            $descricao = $l -replace "^\- \[ \] ``[^``]+`` \*\*", ""
            $descricao = ($descricao -replace "\*\*.*", "").Trim()
            if ($descricao.Length -gt 80) { $descricao = $descricao.Substring(0, 77) + "..." }
            $secoes[$secaoAtual].Add($descricao)

            # Calcular deficit: data da tarefa vs hoje
            $dataMatch = [regex]::Match($l, '`(\d{4}-\d{2}-\d{2})`')
            if ($dataMatch.Success) {
                $dataTarefa = [datetime]::ParseExact($dataMatch.Groups[1].Value, "yyyy-MM-dd", $null)
                $diasAtraso = ($hoje - $dataTarefa.Date).Days
                if ($diasAtraso -ge 0) {
                    # tarefa vencida ou vence hoje
                    $deficitItens.Add([PSCustomObject]@{
                        Projeto    = $secaoAtual
                        Descricao  = $descricao
                        Prazo      = $dataTarefa.ToString("yyyy-MM-dd")
                        DiasAtraso = $diasAtraso
                    })
                }
            }
        }
    }
}

# Ordenar deficit: mais atrasados primeiro
$deficitOrdenado = @($deficitItens | Sort-Object DiasAtraso -Descending)

# --- Gargalos: gates vencidos no WIP_BOARD ---
$gargaloItens = [System.Collections.Generic.List[object]]::new()
if ($wip -and $wip.board -and $wip.board.build) {
    foreach ($proj in $wip.board.build) {
        if (-not $proj.gates_bloqueantes -or -not $proj.build_iniciado_em) { continue }
        $inicio = [datetime]::Parse($proj.build_iniciado_em)
        $gates  = $proj.gates_bloqueantes | Get-Member -MemberType NoteProperty |
                  Select-Object -ExpandProperty Name |
                  Sort-Object { [int]($_ -replace '\D', '') }
        foreach ($g in $gates) {
            $num      = [int]($g -replace '\D', '')
            $gateDate = $inicio.AddDays($num - 1)
            if ($gateDate.Date -gt $hoje) { continue }
            $concluido = $false
            if ($proj.dias_completos) {
                foreach ($d in $proj.dias_completos) {
                    if ($d -match "^dia$num") { $concluido = $true; break }
                }
            }
            if (-not $concluido) {
                $diasGargalo = ($hoje - $gateDate.Date).Days
                $gargaloItens.Add([PSCustomObject]@{
                    Projeto      = if ($proj.cliente) { $proj.cliente } else { "?" }
                    Gate         = $g
                    Prazo        = $gateDate.ToString("yyyy-MM-dd")
                    DiasVencido  = $diasGargalo
                    Descricao    = $proj.gates_bloqueantes.$g
                })
            }
        }
    }
}
$gargaloOrdenado = @($gargaloItens | Sort-Object DiasVencido -Descending)

# --- Construir lista de pendentes (emoji via Unicode escape - PS1 ASCII-safe) ---
# PS5.1 nao suporta [char] acima de 0xFFFF — usar surrogate pair para emoji SMP
function Get-Emoji([int]$codepoint) {
    $hi = [char](0xD800 + (($codepoint - 0x10000) -shr 10))
    $lo = [char](0xDC00 + (($codepoint - 0x10000) -band 0x3FF))
    return "$hi$lo"
}
$eVermelho = Get-Emoji 0x1F534  # 🔴
$eAmarelo  = Get-Emoji 0x1F7E1  # 🟡
$eBranco   = [string][char]0x26AA   # ⚪ (BMP — funciona direto)
$prioEmoji = @($eVermelho, $eVermelho, $eAmarelo, $eAmarelo, $eBranco)

$pendentesLinhas = [System.Collections.Generic.List[string]]::new()
foreach ($secao in $secoes.Keys) {
    $itens = $secoes[$secao]
    if ($itens.Count -eq 0) { continue }
    $pendentesLinhas.Add("")
    $pendentesLinhas.Add("### $secao")
    $pendentesLinhas.Add("")
    for ($i = 0; $i -lt $itens.Count; $i++) {
        $emoji = if ($i -lt $prioEmoji.Count) { $prioEmoji[$i] } else { $eBranco }
        $pendentesLinhas.Add("$emoji $($itens[$i])")
    }
}
$pendentesBloco = $pendentesLinhas -join "`n"

# --- Blocos opcionais: auto-preencher se nao passados como parametro ---
# ENTREGAS: usar git log do dia se nao fornecido
$entregasAuto = ""
try {
    $commits = & git -C $raiz log --since="$($data)T00:00:00" --format="%h %s" 2>$null
    if ($commits) {
        $entregasAuto = ($commits | ForEach-Object { "- $_" }) -join "`n"
    }
} catch { }
$entregasBloco = if ($EntregasTexto) { $EntregasTexto } elseif ($entregasAuto) {
    "Commits do dia:`n$entregasAuto"
} else {
    "Sessao de $data. Nenhum commit registrado hoje."
}

# ALERTAS: auto-detectar manifest VERMELHO/AMARELO se nao fornecido
$alertasAuto = [System.Collections.ArrayList]@()
if (-not $AlertasTexto) {
    $wipAuto = $null
    if (Test-Path "$raiz\CLIENTES\WIP_BOARD.json") {
        try { $wipAuto = Get-Content "$raiz\CLIENTES\WIP_BOARD.json" -Raw -Encoding UTF8 | ConvertFrom-Json } catch { }
    }
    if ($wipAuto -and $wipAuto.board.build) {
        foreach ($p in $wipAuto.board.build) {
            $cli  = $p.cliente.ToUpper()
            $mPth = "$raiz\CLIENTES\$cli\MANIFEST_DOCS.json"
            if (Test-Path $mPth) {
                try {
                    $m = Get-Content $mPth -Raw -Encoding UTF8 | ConvertFrom-Json
                    if ($m.status_geral -ne "VERDE") {
                        [void]$alertasAuto.Add("[$cli] MANIFEST: $($m.status_geral) -- $($m.drift_count) drift, $($m.ausente_count) ausente")
                    }
                } catch { }
            }
        }
    }
}
$alertasBloco = if ($AlertasTexto) { $AlertasTexto } elseif ($alertasAuto.Count -gt 0) {
    $alertasAuto -join "`n"
} else {
    "Nenhum alerta ativo detectado nesta sessao."
}

$acoesBloco = if ($AcoesTexto) { $AcoesTexto } else {
    "Ver PENDENTES.md -- itens vencidos acima exigem deliberacao do Diretor."
}

# ANALISE GERENCIAL: auto-gerar se nao fornecido
$analiseBloco = if ($AnaliseTexto) { $AnaliseTexto } else {
    $nPend = $totalPendentes
    "Sessao de $data encerrada com $nPend pendente(s). " +
    "Verificar itens VERMELHOS na secao ATIVIDADES EM DEFICIT antes de iniciar proxima sessao. " +
    "Musculo: priorizar gates que bloqueiam Gemini ou entrega ao cliente."
}

# --- Montar documento ---
$separador = "---"
$tri = '```'

$linhasDoc = [System.Collections.Generic.List[string]]::new()
$linhasDoc.Add("# PAINEL DE ATIVIDADES - DIRETOR EDUARDO")
$linhasDoc.Add("### Pentalateral IAH - $diaSemana, $data $hora")
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")

# --- SECAO A: ATIVIDADES EM DEFICIT (gestao do Diretor) ---
$linhasDoc.Add("## ATIVIDADES EM DEFICIT -- GESTAO DO DIRETOR")
$linhasDoc.Add("")
$linhasDoc.Add("> O Diretor delibera a ordem de acao. O Musculo nunca decide a prioridade.")
$linhasDoc.Add("> Abaixo: todas as atividades vencidas ou que vencem hoje, ordenadas por dias de atraso.")
$linhasDoc.Add("")

if ($deficitOrdenado.Count -eq 0) {
    $linhasDoc.Add("Nenhuma atividade em deficit nesta sessao.")
} else {
    $linhasDoc.Add("| # | Projeto | Tarefa | Prazo | Dias em atraso |")
    $linhasDoc.Add("|---|---------|--------|-------|---------------|")
    $idx = 1
    foreach ($it in $deficitOrdenado) {
        $diasLabel = if ($it.DiasAtraso -eq 0) { "HOJE" } else { "$($it.DiasAtraso)d" }
        $tarefa = if ($it.Descricao.Length -gt 60) { $it.Descricao.Substring(0, 57) + "..." } else { $it.Descricao }
        $linhasDoc.Add("| $idx | $($it.Projeto) | $tarefa | $($it.Prazo) | $diasLabel |")
        $idx++
    }
}
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")

# --- SECAO B: ALERTA GARGALO (gates vencidos) ---
$linhasDoc.Add("## ALERTA GARGALO -- GATES VENCIDOS")
$linhasDoc.Add("")
if ($gargaloOrdenado.Count -eq 0) {
    $linhasDoc.Add("Nenhum gate vencido detectado.")
} else {
    $linhasDoc.Add("| Projeto | Gate | Descricao | Prazo | Dias vencido |")
    $linhasDoc.Add("|---------|------|-----------|-------|-------------|")
    foreach ($g in $gargaloOrdenado) {
        $diasLabel = if ($g.DiasVencido -eq 0) { "HOJE" } else { "$($g.DiasVencido)d" }
        $desc = if ($g.Descricao.Length -gt 50) { $g.Descricao.Substring(0, 47) + "..." } else { $g.Descricao }
        $linhasDoc.Add("| $($g.Projeto) | $($g.Gate) | $desc | $($g.Prazo) | $diasLabel |")
    }
}
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")

$linhasDoc.Add("## MENSAGEM PARA COLAR NO CHAT DO EMBAIXADOR")
$linhasDoc.Add("")
$linhasDoc.Add("> Copiar o bloco abaixo e colar no Claude Projects junto com o upload deste arquivo.")
$linhasDoc.Add("")
$linhasDoc.Add($tri)
$linhasDoc.Add("Embaixador, fechamento de sessao -- $data.")
$linhasDoc.Add("")
$linhasDoc.Add("Faco upload do PAINEL_ATIVIDADES desta sessao.")
$linhasDoc.Add("Com base nele, gerar o artefato publicavel com:")
$linhasDoc.Add("")
$linhasDoc.Add("1. SEMAFORO -- status visual de cada projeto (bloqueante / atencao / saudavel)")
$linhasDoc.Add("2. ATIVIDADES EM DEFICIT -- validar a lista acima e comentar o que voce ve de comportamental")
$linhasDoc.Add("3. ALERTA GARGALO -- validar os gates vencidos com contexto do cliente real")
$linhasDoc.Add("4. DIAGNOSTICO DO DIA -- saude dos projetos ativos")
$linhasDoc.Add("5. PREVISAO DOS PROXIMOS DIAS -- data a data com checklist de acoes do Diretor")
$linhasDoc.Add("6. ANALISE GERENCIAL -- amplificar a analise do Musculo com perspectiva do Embaixador:")
$linhasDoc.Add("   o que o comportamento real do cliente confirma ou contradiz?")
$linhasDoc.Add("   O que voce ve que o Musculo nao ve?")
$linhasDoc.Add("7. PARA DELIBERACAO DO DIRETOR -- opcoes para o Diretor deliberar a ordem,")
$linhasDoc.Add("   nunca lista de comandos. O Embaixador nao decide a prioridade — o Diretor sim.")
$linhasDoc.Add("")
$linhasDoc.Add("O artefato deve ser autossuficiente: o Diretor abre e decide, nao executa.")
$linhasDoc.Add($tri)
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("## PROJETOS ATIVOS")
$linhasDoc.Add("")
$linhasDoc.Add($tri)
$linhasDoc.Add($projetosBloco)
$linhasDoc.Add($tri)
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("## COMMIT DA SESSAO")
$linhasDoc.Add("")
$linhasDoc.Add("Commit : $gitHash - $gitFiles arquivo(s) alterado(s)")
$linhasDoc.Add("Mensagem: $gitMsg")
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("## ENTREGAS DO DIA")
$linhasDoc.Add("")
$linhasDoc.Add($entregasBloco)
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("## ALERTAS DO MUSCULO")
$linhasDoc.Add("")
$linhasDoc.Add($alertasBloco)
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("## PENDENTES POR PROJETO")
$linhasDoc.Add($pendentesBloco)
$linhasDoc.Add("")
$linhasDoc.Add("Total pendentes abertos: $totalPendentes")
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("## PARA DELIBERACAO DO DIRETOR")
$linhasDoc.Add("")
$linhasDoc.Add("> O Musculo apresenta. O Diretor decide a ordem. Nunca o contrario.")
$linhasDoc.Add("")
$linhasDoc.Add($acoesBloco)
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("## ANALISE GERENCIAL DO MUSCULO")
$linhasDoc.Add("")
$linhasDoc.Add($analiseBloco)
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("## INSTRUCAO PARA O EMBAIXADOR")
$linhasDoc.Add("")
$linhasDoc.Add("Com base neste PAINEL, gerar artefato publicavel com os seguintes blocos:")
$linhasDoc.Add("")
$linhasDoc.Add("1. SEMAFORO -- status visual de cada projeto (bloqueante / atencao / saudavel)")
$linhasDoc.Add("2. ATIVIDADES EM DEFICIT -- validar com contexto do cliente real")
$linhasDoc.Add("3. ALERTA GARGALO -- gates vencidos com perspectiva comportamental do cliente")
$linhasDoc.Add("4. DIAGNOSTICO DO DIA -- saude dos projetos ativos")
$linhasDoc.Add("5. PREVISAO DOS PROXIMOS DIAS -- data a data com checklist de acoes do Diretor")
$linhasDoc.Add("6. ANALISE GERENCIAL -- amplificar a analise do Musculo com perspectiva do Embaixador")
$linhasDoc.Add("7. PARA DELIBERACAO DO DIRETOR -- opcoes para deliberar, nunca lista de comandos")
$linhasDoc.Add("")
$linhasDoc.Add("O artefato deve ser autossuficiente: o Diretor abre e sabe exatamente o que fazer.")
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("Musculo - Pentalateral IAH - $data")

$linhasDoc -join "`n" | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host ""
Write-Host "  [PAINEL] Gerado: PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_$data.md" -ForegroundColor Cyan
Write-Host "  [PAINEL] Fazer upload ao projeto: Embaixador — Diretor (claude.ai/projects)" -ForegroundColor Yellow
Write-Host ""

return $outputFile
