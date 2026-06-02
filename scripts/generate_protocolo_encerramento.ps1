#Requires -Version 5.1
# generate_protocolo_encerramento.ps1 - Gera PAINEL_ATIVIDADES preenchido para o Embaixador
# Chamado pelo session_close.ps1 ao encerrar qualquer sessao.
# Output: PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_[DATA].md
# Eduardo faz upload do arquivo ao Embaixador - zero preenchimento manual.

param(
    [string]$EntregasTexto = "",
    [string]$AlertasTexto  = "",
    [string]$AcoesTexto    = "",
    [string]$AnaliseTexto  = "",
    [string]$Cliente       = ""   # se passado: gera PAINEL filtrado por projeto
)

$raiz = Split-Path -Parent $PSScriptRoot
$data = Get-Date -Format "yyyy-MM-dd"
$hora = Get-Date -Format "HH:mm"
$diaSemana = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
$diaSemana = $diaSemana.Substring(0,1).ToUpper() + $diaSemana.Substring(1)

# --- Diretorio de saida ---
$outputDir = "$raiz\PROTOCOLOS_ENCERRAMENTO"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }
$clienteLabel = if ($Cliente) { $Cliente.ToUpper() } else { "" }
$outputFile   = if ($clienteLabel) {
    "$outputDir\PAINEL_ATIVIDADES_${clienteLabel}_$data.md"
} else {
    "$outputDir\PAINEL_ATIVIDADES_$data.md"
}

# --- Ler WIP_BOARD ---
$wipPath = "$raiz\CLIENTES\WIP_BOARD.json"
$wip = $null
if (Test-Path $wipPath) {
    try { $wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json } catch {}
}

# --- Projetos ativos (estrutura: wip.board.build / check / retainer) ---
# Se -Cliente passado, inclui apenas aquele projeto no bloco
$linhasProjetos = @()
$colunas = @("build", "check", "retainer")
if ($wip -and $wip.board) {
    foreach ($col in $colunas) {
        $lista = $wip.board.$col
        if (-not $lista) { continue }
        foreach ($proj in $lista) {
            $nome = if ($proj.cliente) { $proj.cliente } else { "?" }
            if ($clienteLabel -and $nome.ToUpper() -ne $clienteLabel) { continue }
            $deadline = if ($proj.deadline) { $proj.deadline } else { "sem prazo" }
            # Preferir loop_fase_atual (objeto estruturado) sobre loop_atual (string legada)
            $lfa = $proj.loop_fase_atual
            $loop = if ($lfa) {
                "Loop $($lfa.loop) -- Gemini:$($lfa.gemini) NBook:$($lfa.notebooklm) Embaixador:$($lfa.embaixador) Musculo:$($lfa.musculo) -- Proximo: $($lfa.proximo)"
            } elseif ($proj.loop_atual) { $proj.loop_atual } else { "Loop ?" }
            $colLabel = $col.ToUpper().PadRight(9)
            $linhasProjetos += "$($nome.PadRight(10)) [$colLabel]  $loop  Deadline: $deadline"
        }
    }
}
$projetosBloco = if ($linhasProjetos.Count -gt 0) { $linhasProjetos -join "`n" } else { "Nenhum projeto ativo detectado" }

# --- Git (commit filtrado por projeto - item 1c) ---
$gitHash  = "sem-commit"
$gitMsg   = "sem-commit"
$gitFiles = 0
try {
    if ($clienteLabel) {
        # Filtrar por arquivos do projeto especifico
        $gitHashProj = (& git -C $raiz log -1 --format="%h" -- "CLIENTES/$clienteLabel/" 2>$null).Trim()
        if ($gitHashProj) {
            $gitHash  = $gitHashProj
            $gitMsg   = (& git -C $raiz log -1 --format="%s" -- "CLIENTES/$clienteLabel/" 2>$null).Trim()
            $gitFiles = [int](& git -C $raiz diff --name-only "$gitHash~1" "$gitHash" -- "CLIENTES/$clienteLabel/" 2>$null | Measure-Object).Count
        } else {
            $gitHash  = (& git -C $raiz log -1 --format="%h" 2>$null).Trim()
            $gitMsg   = "(sem commit neste projeto hoje) " + (& git -C $raiz log -1 --format="%s" 2>$null).Trim()
            $gitFiles = 0
        }
    } else {
        $gitHash  = (& git -C $raiz log -1 --format="%h" 2>$null).Trim()
        $gitMsg   = (& git -C $raiz log -1 --format="%s" 2>$null).Trim()
        $gitFiles = [int](& git -C $raiz diff --name-only HEAD~1 HEAD 2>$null | Measure-Object).Count
    }
} catch {}

# --- Pendentes por projeto ---
$pendentesPath = "$raiz\PENDENTES.md"
$totalUrgentes  = 0   # vencidos + hoje + sem data
$totalAgendados = 0   # data futura
$secoes        = [ordered]@{}   # urgentes — aparecem no corpo principal com semaforo
$secoesFuturas = [ordered]@{}   # agendados — aparecem em secao propria sem semaforo
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
                if (-not $secoes.Contains($secaoAtual))        { $secoes[$secaoAtual]        = [System.Collections.Generic.List[string]]::new() }
                if (-not $secoesFuturas.Contains($secaoAtual)) { $secoesFuturas[$secaoAtual] = [System.Collections.Generic.List[object]]::new() }
            }
        }
        if (-not $ignorandoSecao -and $l -match "^\- \[ \]") {
            # Verificar se esta secao pertence ao cliente filtrado (ou e universal)
            $secaoVisivel = $true
            if ($clienteLabel) {
                $ehCliente   = $secaoAtual.ToUpper() -match $clienteLabel
                $ehUniversal = $secaoAtual -match "PROCESSO|INFRA|GERAL|CRITICO"
                $secaoVisivel = $ehCliente -or $ehUniversal
            }

            # Extrair descricao, tag de origem e dependencia inline (itens 3b e 2)
            $descricao = $l -replace "^\- \[ \] ``[^``]+`` \*\*", ""
            $descricao = ($descricao -replace "\*\*.*", "").Trim()

            # Tag de origem: [diretor] [cliente] [musculo] apos o negrito
            $tagOrigem = ""
            $tagMatch = [regex]::Match($l, '\[(diretor|cliente|musculo)\]')
            if ($tagMatch.Success) { $tagOrigem = "[$($tagMatch.Groups[1].Value)]" }

            # Dependencia inline: texto apos "← depende:"
            $dependencia = ""
            $depMatch = [regex]::Match($l, '<-\s*depende:\s*(.+?)(\[|$)')
            if (-not $depMatch.Success) { $depMatch = [regex]::Match($l, 'depende:\s*(.+?)(\[|$)') }
            if ($depMatch.Success) { $dependencia = "← depende: " + $depMatch.Groups[1].Value.Trim() }

            if ($descricao.Length -gt 70) { $descricao = $descricao.Substring(0, 67) + "..." }

            # Determinar se e futuro (data parseable posterior a hoje, ou placeholder XX) ou urgente
            $dataMatch  = [regex]::Match($l, '`(\d{4}-\d{2}-\d{2})`')
            $dataXX     = [regex]::Match($l, '`(\d{4}-\d{2}-XX)`')  # placeholder sem data definida
            $isFuturo   = $false
            $dataLabel  = "sem data"
            if ($dataXX.Success) {
                # placeholder XX = agendado sem data definida — trata como futuro
                $isFuturo  = $true
                $dataLabel = "sem data definida"
            } elseif ($dataMatch.Success) {
                $dataTarefa = [datetime]::ParseExact($dataMatch.Groups[1].Value, "yyyy-MM-dd", $null)
                $dataLabel  = $dataTarefa.ToString("yyyy-MM-dd")
                if ($dataTarefa.Date -gt $hoje) {
                    $isFuturo = $true
                } else {
                    # urgente ou vencido — calcular deficit
                    $diasAtraso = ($hoje - $dataTarefa.Date).Days
                    if ($secaoVisivel) {
                        $deficitItens.Add([PSCustomObject]@{
                            Projeto    = $secaoAtual
                            Descricao  = $descricao
                            Prazo      = $dataLabel
                            DiasAtraso = $diasAtraso
                        })
                    }
                }
            }

            if ($isFuturo) {
                if ($secaoVisivel) { $totalAgendados++ }
                if (-not $secoesFuturas.Contains($secaoAtual)) { $secoesFuturas[$secaoAtual] = [System.Collections.Generic.List[object]]::new() }
                $secoesFuturas[$secaoAtual].Add([PSCustomObject]@{
                    Descricao   = $descricao
                    Data        = $dataLabel
                    Tag         = $tagOrigem
                    Dependencia = $dependencia
                })
            } else {
                if ($secaoVisivel) { $totalUrgentes++ }
                if (-not $secoes.Contains($secaoAtual)) { $secoes[$secaoAtual] = [System.Collections.Generic.List[object]]::new() }
                $secoes[$secaoAtual].Add([PSCustomObject]@{ Descricao = $descricao; Tag = $tagOrigem })
            }
        }
    }
}
$totalPendentes = $totalUrgentes + $totalAgendados

# Ordenar deficit: mais atrasados primeiro
$deficitOrdenado = @($deficitItens | Sort-Object DiasAtraso -Descending)

# Verifica se um numero de gate esta coberto por dias_completos compostos
# Ex: "dia3_5_feed" cobre gates 3,4,5 — "dia9_11_heatmap" cobre 9,10,11
function Test-GateCoberto([object[]]$diasCompletos, [int]$gateNum) {
    foreach ($d in $diasCompletos) {
        $stripped = ($d -replace '^dia', '') -split '_'
        $nums = @()
        foreach ($p in $stripped) {
            if ($p -match '^\d+$') { $nums += [int]$p } else { break }
        }
        if ($nums.Count -eq 0) { continue }
        $minN = ($nums | Measure-Object -Minimum).Minimum
        $maxN = ($nums | Measure-Object -Maximum).Maximum
        if ($gateNum -ge $minN -and $gateNum -le $maxN) { return $true }
    }
    return $false
}

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
                $concluido = Test-GateCoberto -diasCompletos $proj.dias_completos -gateNum $num
            }
            # Checar tambem loops_programados (gate pode estar concluido sem estar em dias_completos)
            if (-not $concluido -and $proj.loops_programados) {
                foreach ($lp in $proj.loops_programados) {
                    if ($lp.gate -match "dia$num" -and $lp.status -eq "concluido") {
                        $concluido = $true
                        break
                    }
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
$gargaloOrdenado = @($gargaloItens |
    Where-Object { -not $clienteLabel -or $_.Projeto.ToUpper() -eq $clienteLabel } |
    Sort-Object DiasVencido -Descending)

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
    if ($clienteLabel) {
        $ehCliente   = $secao.ToUpper() -match $clienteLabel
        $ehUniversal = $secao -match "PROCESSO|INFRA|GERAL|CRITICO"
        if (-not $ehCliente -and -not $ehUniversal) { continue }
    }
    $pendentesLinhas.Add("")
    $pendentesLinhas.Add("### $secao")
    $pendentesLinhas.Add("")
    for ($i = 0; $i -lt $itens.Count; $i++) {
        $emoji = if ($i -lt $prioEmoji.Count) { $prioEmoji[$i] } else { $eBranco }
        $item  = $itens[$i]
        $sufixo = if ($item.Tag) { " $($item.Tag)" } else { "" }
        $pendentesLinhas.Add("$emoji $($item.Descricao)$sufixo")
    }
}
$pendentesBloco = $pendentesLinhas -join "`n"

# --- Construir bloco de pendentes futuros com tag e dependencia (itens 2 e 3b) ---
$futurosLinhas = [System.Collections.Generic.List[string]]::new()
foreach ($secao in $secoesFuturas.Keys) {
    $itens = $secoesFuturas[$secao]
    if ($itens.Count -eq 0) { continue }
    if ($clienteLabel) {
        $ehCliente   = $secao.ToUpper() -match $clienteLabel
        $ehUniversal = $secao -match "PROCESSO|INFRA|GERAL|CRITICO"
        if (-not $ehCliente -and -not $ehUniversal) { continue }
    }
    foreach ($item in $itens) {
        $sufixo = ""
        if ($item.Dependencia) { $sufixo += " $($item.Dependencia)" }
        if ($item.Tag)         { $sufixo += " $($item.Tag)" }
        $futurosLinhas.Add("- [$($item.Data)] $($item.Descricao)$sufixo")
    }
}
$futurosBloco = $futurosLinhas -join "`n"

# --- Ultimo contato com o cliente (item 3a) - ler MEMORIA_EMBAIXADOR ---
$ultimoContato = ""
if ($clienteLabel) {
    $memPath = "$raiz\CLIENTES\$clienteLabel\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
    if (Test-Path $memPath) {
        try {
            $memLinhas = Get-Content $memPath -Encoding UTF8
            $emTabela  = $false
            $ultimaLinha = $null
            foreach ($ml in $memLinhas) {
                if ($ml -match "\|\s*Data\s*\|\s*Canal") { $emTabela = $true; continue }
                if ($emTabela -and $ml -match "^\|---")  { continue }
                if ($emTabela -and $ml -match "^\|\s*(\d{4}-\d{2}-\d{2})\s*\|" -and -not $ultimaLinha) {
                    $ultimaLinha = $ml  # tabela em ordem decrescente -- primeira linha = mais recente
                }
                if ($emTabela -and $ml -match "^##") { break }
            }
            if ($ultimaLinha) {
                $cols = $ultimaLinha -split '\|' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
                if ($cols.Count -ge 3) {
                    $ultimoContato = "$($cols[0]) ($($cols[1]) — $($cols[2]))"
                }
            }
        } catch { }
    }
    if (-not $ultimoContato) { $ultimoContato = "sem registro" }
}

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
    $nGarg = $gargaloOrdenado.Count
    $projLabel = if ($clienteLabel) { "Projeto $clienteLabel" } else { "Sessao de $data" }
    $wipProj = if ($clienteLabel -and $wip -and $wip.board.build) {
        $wip.board.build | Where-Object { $_.cliente.ToUpper() -eq $clienteLabel } | Select-Object -First 1
    } else { $null }
    $statusDoc = "VERDE"
    if ($wipProj -and $wipProj.cliente) {
        $mPth = "$raiz\CLIENTES\$clienteLabel\MANIFEST_DOCS.json"
        if (Test-Path $mPth) {
            try {
                $m = Get-Content $mPth -Raw -Encoding UTF8 | ConvertFrom-Json
                $statusDoc = $m.status_geral
            } catch { }
        }
    }
    # Status de deadline inferido (item 1b)
    $deadlineInfo = ""
    if ($wipProj -and $wipProj.deadline) {
        $dl = [datetime]::Parse($wipProj.deadline)
        $diasRestantes = ($dl.Date - $hoje).Days
        $dlStatus = if ($diasRestantes -lt 0) { "ABSORVIDO -- prazo vencido, projeto continua" }
                    elseif ($diasRestantes -eq 0) { "VENCE HOJE" }
                    else { "ATIVO -- $diasRestantes dia(s) restante(s)" }
        $deadlineInfo = "Deadline $($wipProj.deadline) [$dlStatus]."
    }
    $detalheAgendados = if ($totalAgendados -gt 0) { " -- $totalUrgentes urgente(s) + $totalAgendados agendado(s)" } else { "" }
    "$projLabel encerrou sessao com $nPend pendente(s)$detalheAgendados e $nGarg gargalo(s). Status documental: $statusDoc. $deadlineInfo Musculo: verificar se gargalos bloqueiam o proximo loop antes de ir ao Gemini."
}

# --- Montar documento ---
$separador = "---"
$tri = '```'

$linhasDoc = [System.Collections.Generic.List[string]]::new()
$tituloCliente = if ($clienteLabel) { " - $clienteLabel" } else { "" }
$linhasDoc.Add("# PAINEL DE ATIVIDADES$tituloCliente - DIRETOR EDUARDO")
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
$msgCliente = if ($clienteLabel) { "Embaixador de $clienteLabel, fechamento de sessao -- $data." } else { "Embaixador, fechamento de sessao -- $data." }
$linhasDoc.Add($msgCliente)
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
$linhasDoc.Add("> Escopo: anomalias de sistema (manifesto hash, canonical violation). Pendentes e gargalos estao nas secoes ATIVIDADES EM DEFICIT e ALERTA GARGALO acima.")
$linhasDoc.Add("")
$linhasDoc.Add($alertasBloco)
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
# Bloco de contexto do projeto (ultimo contato + deadline status - itens 1b e 3a)
if ($clienteLabel) {
    $linhasDoc.Add("## CONTEXTO DO PROJETO")
    $linhasDoc.Add("")
    if ($ultimoContato) {
        $linhasDoc.Add("**Ultimo contato com o cliente:** $ultimoContato")
    }
    if ($deadlineInfo) {
        $linhasDoc.Add("**Deadline:** $deadlineInfo")
    }
    $linhasDoc.Add("")
    $linhasDoc.Add($separador)
    $linhasDoc.Add("")
}

$linhasDoc.Add("## PENDENTES POR PROJETO")
$corpoUrgentes = if ($pendentesBloco.Trim()) { $pendentesBloco } else { "`nNenhum pendente urgente neste ciclo." }
$linhasDoc.Add($corpoUrgentes)
$linhasDoc.Add("")
if ($futurosLinhas.Count -gt 0) {
    $linhasDoc.Add("## PENDENTES FUTUROS (nao urgentes)")
    $linhasDoc.Add("")
    $linhasDoc.Add($futurosBloco)
    $linhasDoc.Add("")
}
$rodapeTotal = "Total pendentes abertos: $totalPendentes"
if ($totalAgendados -gt 0) {
    $rodapeTotal += " ($totalUrgentes urgente(s) + $totalAgendados agendado(s))"
}
$linhasDoc.Add($rodapeTotal)
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

$nomeArq = if ($clienteLabel) { "PAINEL_ATIVIDADES_${clienteLabel}_$data.md" } else { "PAINEL_ATIVIDADES_$data.md" }
$destLabel = if ($clienteLabel) { "Claude Projects: Embaixador $clienteLabel" } else { "Claude Projects: Embaixador - Diretor" }
Write-Host ""
Write-Host "  [PAINEL] Gerado: PROTOCOLOS_ENCERRAMENTO\$nomeArq" -ForegroundColor Cyan

# Validacao automatica de consistencia antes de informar que esta pronto
$validateScript = "$PSScriptRoot\validate_painel.ps1"
if (Test-Path $validateScript) {
    & $validateScript -PainelPath $outputFile
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  [PAINEL] BLOQUEADO -- corrigir inconsistencia antes de enviar ao Embaixador." -ForegroundColor Red
        Write-Host ""
        return $null
    }
}

Write-Host "  [PAINEL] Fazer upload ao projeto: $destLabel (claude.ai/projects)" -ForegroundColor Yellow
Write-Host ""

return $outputFile
