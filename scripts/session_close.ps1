# session_close.ps1
# Executar ao fechar qualquer sessao do Quadrilateral
# Prompts obrigatorios para atualizar o INTELLIGENCE_LEDGER

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE   = Split-Path -Parent $PSScriptRoot
$LEDGER = "$BASE\INTELLIGENCE_LEDGER.md"
$KG     = "$BASE\knowledge_graph.json"
$DATA   = Get-Date -Format "yyyy-MM-dd"

Write-Host ""
Write-Host "=============================================="
Write-Host "  FECHAMENTO DE SESSAO -- Quadrilateral IAH"
Write-Host "=============================================="
Write-Host ""

# --- Loop Continuity Check ---
$comandoGerado = Get-ChildItem "$BASE\CLIENTES" -Filter "COMANDO_ESTRATEGISTA*.md" -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime.Date -eq (Get-Date).Date } |
    Select-Object -First 1

if (-not $comandoGerado) {
    Write-Host "  [!!] LOOP CONTINUITY: COMANDO_ESTRATEGISTA nao detectado hoje."
    Write-Host "       O loop Musculo->Gemini quebra sem este documento."
    Write-Host ""
    Write-Host "  Opcoes:"
    Write-Host "    [1] Gerar COMANDO_ESTRATEGISTA agora (recomendado)"
    Write-Host "    [2] Declarar quebra intencional de loop (justificar abaixo)"
    Write-Host "    [3] Ja gerado em outro caminho -- continuar"
    Write-Host ""
    $opcao = Read-Host "  Escolha [1/2/3]"
    if ($opcao -eq "2") {
        $motivo = Read-Host "  Justificativa para quebra de loop"
        Write-Host ""
        Write-Host "  Quebra de loop registrada: $motivo"
        Write-Host "  Aviso: proximo ciclo com Gemini comecara sem contexto desta sessao."
    } elseif ($opcao -eq "1") {
        Write-Host ""
        Write-Host "  Gere o COMANDO_ESTRATEGISTA antes de continuar o fechamento."
        Write-Host "  Execute este script novamente apos gerar o documento."
        exit 0
    }
} else {
    Write-Host "  [OK] Loop Continuity: $($comandoGerado.Name) detectado."
}
Write-Host ""

if (-not (Test-Path $LEDGER)) {
    Write-Host "ERRO: INTELLIGENCE_LEDGER.md nao encontrado."
    exit 1
}

if (-not (Test-Path $KG)) {
    Write-Host "ERRO: knowledge_graph.json nao encontrado."
    exit 1
}

Write-Host "SESSAO: $DATA"
Write-Host ""
Write-Host "[1/4] Houve FRICCAO nesta sessao? (ALERTA emitido, P0 criado, escopo mudou)"
Write-Host "      Se sim, descreva em 1 linha (Enter para pular):"
$friccao = Read-Host "    > "

Write-Host ""
Write-Host "[2/4] Algum PRINCIPIO novo foi descoberto? (o 'porque' por tras de uma decisao)"
Write-Host "      Se sim, descreva em 1 linha (Enter para pular):"
$principio = Read-Host "    > "

Write-Host ""
Write-Host "[3/4] O Diretor fez OVERRIDE de algum veto? (Hard ou Soft)"
Write-Host "      Se sim, descreva qual e o motivo (Enter para pular):"
$override = Read-Host "    > "

Write-Host ""
Write-Host "[4/4] Houve DERIVA? (sessao divergiu de um principio ativo?)"
Write-Host "      Se sim, qual principio e como foi corrigido (Enter para pular):"
$deriva = Read-Host "    > "

# --- Montar entrada no LEDGER ---
$entrada = "`n`n### [SESSAO $DATA]`n"

if ($friccao)  { $entrada += "`n``[FRICCAO]`` $friccao" }
if ($principio){ $entrada += "`n``[PRINCIPIO]`` $principio" }
if ($override) { $entrada += "`n``[OVERRIDE]`` $override" }
if ($deriva)   { $entrada += "`n``[DERIVA]`` $deriva" }

if ($friccao -or $principio -or $override -or $deriva) {
    $conteudo = Get-Content $LEDGER -Raw -Encoding utf8
    if ($conteudo -match "## GLOSSARIO") {
        $conteudo = $conteudo -replace "(?m)^## GLOSSARIO", "$entrada`n`n## GLOSSARIO"
    } else {
        $conteudo = $conteudo + $entrada
    }
    Set-Content $LEDGER -Value $conteudo -Encoding utf8
    Write-Host ""
    Write-Host "INTELLIGENCE_LEDGER.md atualizado."
} else {
    Write-Host ""
    Write-Host "Nenhum evento registrado nesta sessao."
}

# --- Atualizar knowledge_graph.json ---
$kg = Get-Content $KG -Raw -Encoding utf8 | ConvertFrom-Json

$nova_sessao = [PSCustomObject]@{
    date                 = $DATA
    label                = "Sessao $DATA"
    friction_events      = if ($friccao) { 1 } else { 0 }
    principles_generated = if ($principio) { @("novo") } else { @() }
    overrides            = if ($override) { @([PSCustomObject]@{ description = $override }) } else { @() }
    drift_detected       = if ($deriva) { $true } else { $false }
}

$sessoes = [System.Collections.ArrayList]@()
if ($kg.sessions) { foreach ($s in $kg.sessions) { [void]$sessoes.Add($s) } }
$sessoes.Insert(0, $nova_sessao)
if ($sessoes.Count -gt 20) { $sessoes = $sessoes[0..19] }

$kg.sessions = $sessoes
$kg.meta.last_updated   = $DATA
$kg.meta.total_sessions = $sessoes.Count

$kg | ConvertTo-Json -Depth 10 | Set-Content $KG -Encoding utf8
Write-Host "knowledge_graph.json atualizado."

Write-Host ""
Write-Host "[5/5] DIVIDAS TECNICAS para o Auditor (P0/P1 em aberto)"
Write-Host "      Liste modulos incompletos, bugs conhecidos ou decisoes arquiteturais"
Write-Host "      que o NotebookLM precisa saber no proximo ciclo (Enter para pular):"
$divida = Read-Host "    > "

if ($divida) {
    $divArquivo = "$BASE\DIVIDAS_TECNICAS_AUDITOR.md"

    $divConteudo = ""
    if (Test-Path $divArquivo) {
        $divConteudo = Get-Content $divArquivo -Raw -Encoding utf8
    }

    $novaDiv = "`n`n### [DIVIDAS TECNICAS -- $DATA]`n" +
               "**Sessao:** $DATA`n" +
               "**Dividas registradas:**`n$divida`n" +
               "_Injete este bloco no NotebookLM como primeira fonte antes da proxima auditoria._"

    Set-Content $divArquivo -Value ($divConteudo + $novaDiv) -Encoding utf8
    Write-Host ""
    Write-Host "DIVIDAS_TECNICAS_AUDITOR.md atualizado."
    Write-Host "Inclua este arquivo nas fontes do NotebookLM no proximo ciclo."
}

Write-Host ""
Write-Host "=============================================="
Write-Host "  Proximo passo: git commit + fechar sessao"
Write-Host "=============================================="

# --- Mandato Direto do Diretor -- auto-injecao no PASSO3 do projeto ativo ---
Write-Host ""
Write-Host "[MANDATO] Houve intervencao direta do Diretor nesta sessao?"
Write-Host "  (novo principio, nova regra, nova funcao do Conselho - ex: necessidade do contrato)"
Write-Host "  Liste 1 por linha. Enter em branco para encerrar. Enter direto para pular."
$mandatos = @()
$DATA_MANDATO = Get-Date -Format "yyyy-MM-dd"
while ($true) {
    $linha = Read-Host "    > "
    if ([string]::IsNullOrWhiteSpace($linha)) { break }
    $mandatos += $linha
}

if ($mandatos.Count -gt 0) {
    # Detectar projeto ativo (primeiro em BUILD)
    $wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
    if (Test-Path $wipPath) {
        $board = Get-Content $wipPath -Raw -Encoding utf8 | ConvertFrom-Json
        $projetoAtivo = @($board.board.build) | Select-Object -First 1
        if ($projetoAtivo) {
            $clienteDir = Join-Path $BASE "CLIENTES\$($projetoAtivo.cliente.ToUpper())"
            $passo3Path = Join-Path $clienteDir "PASSO3_GEMINI.md"
            if (Test-Path $passo3Path) {
                $blocoMandato  = "`n## [!!] [MANDATO_DIRETO_DO_DIRETOR] -- $DATA_MANDATO`n"
                $blocoMandato += "> Eduardo declarou diretamente. Estrategista: proibido de suavizar ou ignorar.`n"
                $blocoMandato += "> Bloco 1 da DIRETRIZ deve enderecar cada mandato abaixo.`n`n"
                $num = 1
                foreach ($m in $mandatos) {
                    $blocoMandato += "$num. $m`n"
                    $num++
                }
                $blocoMandato += "`n---`n"

                $conteudo = Get-Content $passo3Path -Raw -Encoding utf8
                if ($conteudo -match "\[MANDATO_DIRETO_DO_DIRETOR\]") {
                    # Substituir bloco existente
                    $conteudo = $conteudo -replace "(?s)## \[!!\] \[MANDATO_DIRETO_DO_DIRETOR\].*?---\r?\n", $blocoMandato
                } else {
                    # Inserir no inicio do arquivo
                    $conteudo = $blocoMandato + "`n" + $conteudo
                }
                Set-Content $passo3Path -Value $conteudo -Encoding utf8
                Write-Host ""
                Write-Host "  [OK] Mandato injetado em: CLIENTES\$($projetoAtivo.cliente.ToUpper())\PASSO3_GEMINI.md"
                Write-Host "       Estrategista vai receber os mandatos no proximo loop automaticamente."
            } else {
                Write-Host "  [!!] PASSO3_GEMINI.md nao encontrado para $($projetoAtivo.cliente). Injete manualmente."
            }
        }
    }
}

# --- Auto-regenerar CONTEXTO_GEMINI.md para o proximo loop ---
$anchorScript = Join-Path $BASE "scripts\gemini_anchor_generator.ps1"
if (Test-Path $anchorScript) {
    try {
        Write-Host ""
        Write-Host "Atualizando CONTEXTO_GEMINI.md para o proximo loop..."
        & powershell.exe -NonInteractive -File $anchorScript 2>$null | Out-Null
        Write-Host "  [OK] CONTEXTO_GEMINI.md atualizado com commits + WIP + LEDGER."
    } catch {
        Write-Host "  [!!] Falha ao atualizar CONTEXTO_GEMINI.md -- execute manualmente."
    }
}
