#Requires -Version 5.1
# gerar_msg_embaixador.ps1
# Gera o texto completo da mensagem ao Embaixador (Claude Projects) para fechamento de sessao.
# Uso: .\scripts\gerar_msg_embaixador.ps1
# Output: scripts\embaixador_msg_sessao.txt + exibe no terminal para o Diretor copiar.

$raiz = Split-Path -Parent $PSScriptRoot
$data = Get-Date -Format "yyyy-MM-dd"
$dataBR = Get-Date -Format "dd/MM/yyyy (dddd)"

# --- Ler WIP_BOARD para contexto ---
$wipPath = Join-Path $raiz "CLIENTES\WIP_BOARD.json"
$loop = "??"
$projetos = @()
try {
    $wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $projetos = @($wip.board.build)
    if ($wip.meta.loop_atual) { $loop = $wip.meta.loop_atual }
} catch {}

# --- Ultimos commits da sessao ---
$commits = ""
try {
    $commits = (git -C $raiz log --oneline -8 2>$null) -join "`n"
} catch {}

# --- Alertas do WIP_BOARD ---
$alertas = @()
$hoje = Get-Date
foreach ($proj in $projetos) {
    try {
        $threshold = [int]($proj.churn_watch_threshold -replace "\D", "")
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

# --- 7 arquivos obrigatorios (caminhos absolutos para o Diretor localizar) ---
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
        $diff = ($hoje.Date - (Get-Item $p).LastWriteTime.Date).Days
        if ($diff -gt 0) {
            $erros += ("[STALE " + $diff + "d] " + $nomes[$i])
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

# --- Alertas da sessao (lidos de PENDENTES.md) ---
$pendentesPath = Join-Path $raiz "PENDENTES.md"
$alertasDir = @()
try {
    $linhas = Get-Content $pendentesPath -Encoding UTF8
    foreach ($l in $linhas) {
        if ($l -match "URGENTE" -and $l -match "\[ \]") {
            $alertasDir += ($l -replace "^- \[ \] `\`"[^`"`"]*`"`" \*\*", "" -replace "\*\*.*$", "").Trim()
        }
    }
} catch {}

# --- Gerar alertas de perspectiva comportamental ---
$perspectiva = ""
if ($alertas.Count -gt 0 -or $alertasDir.Count -gt 0) {
    $perspectiva = "PERSPECTIVA COMPORTAMENTAL QUE PECO DE VOCE:`n"
    foreach ($a in $alertas)    { $perspectiva += ("- " + $a + "`n") }
    foreach ($a in $alertasDir) { $perspectiva += ("- Diretor ainda sem acao: " + $a + "`n") }
    $perspectiva += "O que estes padroes sinalizam sobre a capacidade de atencao do Diretor neste momento?`n"
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
[PREENCHER PELO MUSCULO ANTES DE RODAR -- ver CONTEXTO_SESSAO_DIRETOR_$data.md para lista de entregas]

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

$perspectiva
Ao entregar, incluir instrucao ao Diretor:
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
