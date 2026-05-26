#Requires -Version 5.1
# generate_protocolo_encerramento.ps1 - Gera PAINEL_ATIVIDADES preenchido para o Embaixador
# Chamado pelo session_close.ps1 ao encerrar qualquer sessao.
# Output: PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_[DATA].md
# Eduardo faz upload do arquivo ao Embaixador - zero preenchimento manual.

param(
    [string]$EntregasTexto = "",
    [string]$AlertasTexto  = "",
    [string]$AcoesTexto    = ""
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
        }
    }
}

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

# --- Blocos opcionais ---
$entregasBloco = if ($EntregasTexto) { $EntregasTexto } else {
    "(entregas serao preenchidas pelo Musculo ao rodar session_close.ps1)"
}
$alertasBloco = if ($AlertasTexto) { $AlertasTexto } else {
    "(nenhum alerta registrado ou pendente de preenchimento)"
}
$acoesBloco = if ($AcoesTexto) { $AcoesTexto } else {
    "(acoes do Diretor serao listadas ao fechar a sessao)"
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
$linhasDoc.Add("2. DIAGNOSTICO DO DIA -- saude dos projetos ativos")
$linhasDoc.Add("3. PREVISAO DOS PROXIMOS DIAS -- data a data com checklist de acoes do Diretor")
$linhasDoc.Add("4. ANALISE GERENCIAL -- replicar e amplificar a analise do Musculo no PAINEL,")
$linhasDoc.Add("   com sua perspectiva: o que o comportamento real do cliente confirma ou contradiz?")
$linhasDoc.Add("   O que voce ve que o Musculo nao ve?")
$linhasDoc.Add("5. PROXIMA ACAO DO DIRETOR -- maximo 3 itens, em ordem de prioridade")
$linhasDoc.Add("")
$linhasDoc.Add("O artefato deve ser autossuficiente: abro e sei exatamente o que fazer.")
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
$linhasDoc.Add("## PROXIMA ACAO DO DIRETOR")
$linhasDoc.Add("")
$linhasDoc.Add($acoesBloco)
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("## ANALISE GERENCIAL DO MUSCULO")
$linhasDoc.Add("")
$linhasDoc.Add("[O Musculo preenche esta secao antes de enviar o PAINEL ao Embaixador.]")
$linhasDoc.Add("[Perspectiva consultora: estado real do projeto, risco principal, oportunidade")
$linhasDoc.Add(" subutilizada, impacto se o gate nao for desbloqueado no prazo.]")
$linhasDoc.Add("[Minimo 3 linhas. Linguagem de consultor senior, nao de tecnico.]")
$linhasDoc.Add("")
$linhasDoc.Add($separador)
$linhasDoc.Add("")
$linhasDoc.Add("## INSTRUCAO PARA O EMBAIXADOR")
$linhasDoc.Add("")
$linhasDoc.Add("Com base neste PAINEL, gerar artefato publicavel com os seguintes blocos:")
$linhasDoc.Add("")
$linhasDoc.Add("1. SEMAFORO — status visual de cada projeto (bloqueante / atencao / saudavel)")
$linhasDoc.Add("2. DIAGNOSTICO DO DIA — saude dos projetos ativos")
$linhasDoc.Add("3. PREVISAO DOS PROXIMOS DIAS — data a data com checklist de acoes do Diretor")
$linhasDoc.Add("4. ANALISE GERENCIAL — replicar e amplificar a analise do Musculo acima")
$linhasDoc.Add("   com perspectiva do Embaixador: o que o comportamento real do cliente")
$linhasDoc.Add("   confirma ou contradiz? O que o Embaixador ve que o Musculo nao ve?")
$linhasDoc.Add("5. PROXIMA ACAO DO DIRETOR — maximo 3 itens, em ordem de prioridade")
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
