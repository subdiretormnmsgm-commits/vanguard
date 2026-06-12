#Requires -Version 5.1
# gerar_msg_embaixador.ps1
# Gera o texto completo da mensagem ao Embaixador (Claude Projects) para fechamento de sessao.
# Uso: .\scripts\gerar_msg_embaixador.ps1
# Output: scripts\embaixador_msg_sessao.txt + exibe no terminal para o Diretor copiar.

$raiz    = Split-Path -Parent $PSScriptRoot
$data    = Get-Date -Format "yyyy-MM-dd"
$dataBR  = Get-Date -Format "dd/MM/yyyy (dddd)"
$hoje    = Get-Date

# --- 7 arquivos obrigatorios (definidos antes de qualquer uso) ---
$arq1 = "PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_$data.md"
$arq2 = "PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_$data.md"
$arq3 = "CLIENTES\WIP_BOARD.json"
$arq4 = "INTELLIGENCE_LEDGER.md"
$arq5 = "PENDENTES.md"
$arq6 = "CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md"
$arq7 = "CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md"

# --- Verificar se os 7 existem e estao atualizados hoje ---
$arquivos = @($arq1, $arq2, $arq3, $arq4, $arq5, $arq6, $arq7)
$nomes    = @("PAINEL_ATIVIDADES", "CONTEXTO_SESSAO_DIRETOR", "WIP_BOARD", "INTELLIGENCE_LEDGER", "PENDENTES", "16_VANGUARD_TIMELINE", "MEMORIA_EMBAIXADOR")
$erros = @()
for ($i = 0; $i -lt $arquivos.Count; $i++) {
    $p = Join-Path $raiz $arquivos[$i]
    if (-not (Test-Path $p)) {
        $erros += ("[AUSENTE] " + $nomes[$i])
    } else {
        $diffDias = ($hoje.Date - (Get-Item $p).LastWriteTime.Date).Days
        if ($diffDias -gt 0) {
            $erros += ("[STALE " + $diffDias + "d] " + $nomes[$i])
        }
    }
}

if ($erros.Count -gt 0) {
    Write-Host ""
    Write-Host "[BLOQUEIO] Nao e possivel gerar mensagem ao Embaixador -- arquivos com problema:" -ForegroundColor Red
    foreach ($e in $erros) { Write-Host ("  " + $e) -ForegroundColor Red }
    Write-Host ""
    Write-Host "Corrija os arquivos acima antes de rodar este script." -ForegroundColor Yellow
    exit 1
}

# --- Ler WIP_BOARD para contexto ---
$wipPath = Join-Path $raiz $arq3
$loop    = "??"
$projetos = @()
try {
    $wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $projetos = @($wip.board.build)
    if ($wip.meta.loop_atual) { $loop = $wip.meta.loop_atual }
} catch {}

# --- Commits das ultimas 24h ---
$commits = @()
try {
    $since = $hoje.AddDays(-1).ToString("yyyy-MM-dd")
    $commits = @(git -C $raiz log --oneline --since="$since" 2>$null)
} catch {}

# --- Extrair DESTAQUES automaticamente do PAINEL_ATIVIDADES ---
$destaques = @()
try {
    $painelPath = Join-Path $raiz $arq1
    $lendo = $false
    foreach ($linha in (Get-Content $painelPath -Encoding UTF8)) {
        if ($linha -match "^## .*(ENTREGAS|ENTREGUES|ATIVIDADES DO COWORK|O QUE FOI ENTREGUE)") { $lendo = $true; continue }
        if ($lendo -and $linha -match "^## ") { $lendo = $false }
        if ($lendo -and $linha -match "^###\s+(.+)") { $destaques += $Matches[1].Trim() }
        if ($lendo -and $linha -match "^-\s+\*\*([^*]+)\*\*") { $destaques += $Matches[1].Trim() }
        elseif ($lendo -and $linha -match "^-\s+(.{10,80})$") { $destaques += $Matches[1].Trim() }
    }
} catch {}

# Fallback: extrair do CONTEXTO_SESSAO_DIRETOR
if ($destaques.Count -eq 0) {
    try {
        $ctxPath = Join-Path $raiz $arq2
        $lendo = $false
        foreach ($linha in (Get-Content $ctxPath -Encoding UTF8)) {
            if ($linha -match "^## O QUE FOI FEITO HOJE") { $lendo = $true; continue }
            if ($lendo -and $linha -match "^## ")         { $lendo = $false }
            if ($lendo -and $linha -match "^-\s+(.{5,})") { $destaques += $Matches[1].Trim() }
        }
    } catch {}
}

# Fallback final: commits
if ($destaques.Count -eq 0 -and $commits.Count -gt 0) {
    $destaques = $commits
}

$destacosTxt = if ($destaques.Count -gt 0) {
    ($destaques | Select-Object -First 10 | ForEach-Object { "- " + $_ }) -join "`n"
} else {
    "(ver PAINEL_ATIVIDADES_$data.md)"
}

# --- Alertas ChurnWatch e Deadlines do WIP_BOARD ---
$alertas = @()
foreach ($proj in $projetos) {
    try {
        $threshold    = [int]($proj.churn_watch_threshold -replace "\D", "")
        $ultimoContato = [datetime]::Parse($proj.ultimo_contato_cliente)
        $dias = ($hoje.Date - $ultimoContato.Date).Days
        if ($dias -ge $threshold) {
            $alertas += ("[CHURNWATCH] " + $proj.cliente + " -- " + $dias + "d sem contato (threshold " + $threshold + "d)")
        }
    } catch {}
    try {
        $deadline = [datetime]::Parse($proj.deadline)
        $diff = ($deadline.Date - $hoje.Date).Days
        if ($diff -le 7) {
            $alertas += ("[DEADLINE] " + $proj.cliente + " -- " + $proj.deadline + " (" + $diff + "d)")
        }
    } catch {}
}

# --- Alertas de PENDENTES URGENTE ---
$alertasDir = @()
try {
    $linhas = Get-Content (Join-Path $raiz $arq5) -Encoding UTF8
    foreach ($l in $linhas) {
        if ($l -match "URGENTE" -and $l -match "\[ \]") {
            $txt = $l -replace "^-\s+\[\s\]\s+", "" -replace "\s+\[URGENTE\].*$", ""
            if ($txt.Trim()) { $alertasDir += $txt.Trim() }
        }
    }
} catch {}

# --- Perspectiva comportamental (so se houver alertas) ---
$perspectiva = ""
if ($alertas.Count -gt 0 -or $alertasDir.Count -gt 0) {
    $linhasPers = @("PERSPECTIVA COMPORTAMENTAL QUE PECO DE VOCE:")
    foreach ($a in $alertas)    { $linhasPers += ("- " + $a) }
    foreach ($a in $alertasDir) { $linhasPers += ("- Diretor ainda sem acao: " + $a) }
    $linhasPers += "O que estes padroes sinalizam sobre a capacidade de atencao do Diretor neste momento?"
    $perspectiva = ($linhasPers -join "`n") + "`n`n"
}

# --- Montar mensagem ---
$msg = @"
Embaixador, fechamento de sessao -- $dataBR -- Loop $loop VANGUARD

Faco upload dos 7 arquivos abaixo (todos atualizados hoje):
1. $arq1
2. $arq2
3. $arq3
4. $arq4
5. $arq5
6. $arq6
7. $arq7

DESTAQUES DESTA SESSAO (para voce ancorar a analise):
$destacosTxt

Com base nos 7 arquivos, gerar o artefato publicavel com:
0. BRIEFING DE ABERTURA PARA O MUSCULO (gerar primeiro)
   Paragrafo que o Diretor colara ao abrir a proxima sessao do Claude Code.
   Conter: (a) o que foi entregue hoje e esta ativo, (b) o que ficou em aberto e por que, (c) proximo passo esperado do Musculo.
   Escrito na segunda pessoa: "Musculo, na ultima sessao..."
1. SEMAFORO -- status visual por projeto (BLOQUEANTE / ATENCAO / SAUDAVEL)
2. DIAGNOSTICO DO DIA -- saude dos projetos ativos + o que avancou hoje
3. PREVISAO DOS PROXIMOS DIAS -- data a data com checklist do Diretor
4. ANALISE GERENCIAL -- o que voce ve que o Musculo nao ve?
5. PROXIMA ACAO DO DIRETOR -- maximo 3 itens em ordem de prioridade

${perspectiva}Ao entregar, incluir instrucao ao Diretor:
"Diretor, ao abrir o Claude Code, cole o BLOCO 0 acima como PRIMEIRA mensagem para o Musculo -- antes de qualquer outra coisa."
"@

# --- Salvar e exibir ---
$saida = Join-Path $raiz "scripts\embaixador_msg_sessao.txt"
[System.IO.File]::WriteAllText($saida, $msg, [System.Text.UTF8Encoding]::new($false))

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  MENSAGEM AO EMBAIXADOR -- copie o texto abaixo" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host $msg
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ("  Arquivo salvo: scripts\embaixador_msg_sessao.txt") -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
