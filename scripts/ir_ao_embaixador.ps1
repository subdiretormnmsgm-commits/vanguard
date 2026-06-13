# ir_ao_embaixador.ps1
# Pentalateral IAH - V25
#
# QUANDO RODAR: sempre que for interagir com o Embaixador (Claude Projects).
# O Musculo roda este script automaticamente ao detectar intencao de ir ao Claude Projects.
#
# O QUE FAZ (em sequencia):
#   0. [SYNC] Copia versoes mais recentes dos documentos para CLAUDE_PROJECT (automatico)
#   1. Detecta o cliente ativo no WIP_BOARD
#   2. Copia MENSAGEM_INTERACAO_INICIAL.md para o clipboard (so colar no chat)
#   3. Abre o browser no Claude Projects
#   4. Abre o Explorer na pasta CLAUDE_PROJECT do cliente
#   5. Exibe instrucoes com arquivos a subir e status de contrato
#
# USO:
#   .\scripts\ir_ao_embaixador.ps1 -cliente INGRID
#   .\scripts\ir_ao_embaixador.ps1 -cliente VALDECE
#   .\scripts\ir_ao_embaixador.ps1            (detecta cliente ativo automaticamente)

param(
    [string]$cliente = "",
    [switch]$AutoSync,        # Modo silencioso: sincroniza docs sem abrir browser/Explorer
    [switch]$ApenasAtivacao,  # Bypass do gate DIRETRIZ -- uso exclusivo para "nova sistematica"
    [switch]$OrdemDiretor     # P-154: comunicacao direta do Diretor entre socios -- gate DIRETRIZ ignorado
)

$ErrorActionPreference = "Stop"
$raiz = $PSScriptRoot | Split-Path -Parent

if (-not $AutoSync) {
    Write-Host ""
    Write-Host "=================================================" -ForegroundColor Magenta
    Write-Host "  PENTALATERAL IAH -- Indo ao Embaixador         " -ForegroundColor Magenta
    Write-Host "=================================================" -ForegroundColor Magenta
    Write-Host ""
}

# PASSO 0 -- Auto-detectar cliente (P-059: nunca auto-selecionar quando >1 projeto ativo)
if (-not $cliente) {
    Write-Host "[0/4] Detectando projetos ativos no WIP_BOARD..." -ForegroundColor Yellow
    $wip = Get-Content "$raiz\CLIENTES\WIP_BOARD.json" -Raw | ConvertFrom-Json
    $projetosAtivos = @($wip.board.build) | Where-Object { $_ }

    if (-not $projetosAtivos -or $projetosAtivos.Count -eq 0) {
        Write-Host "  [ERRO] Nenhum projeto em BUILD no WIP_BOARD." -ForegroundColor Red
        Write-Host "         Informe o cliente: -cliente INGRID" -ForegroundColor Yellow
        exit 1
    }

    if ($projetosAtivos.Count -eq 1) {
        # Apenas 1 projeto — auto-detectar com confirmacao visual
        $projeto = $projetosAtivos[0]
        $cliente = $projeto.cliente.ToUpper()
        $projetoId = $projeto.id
        $projetoNome = $projeto.projeto
        Write-Host "  Cliente detectado: $cliente ($projetoId - $projetoNome)" -ForegroundColor Green
    } else {
        # P-059: >1 projeto ativo — NUNCA auto-selecionar. Listar e aguardar escolha.
        Write-Host ""
        Write-Host "  [P-059] $($projetosAtivos.Count) projetos em BUILD. Escolha o cliente:" -ForegroundColor Yellow
        $i = 1
        foreach ($p in $projetosAtivos) {
            Write-Host "  [$i] $($p.cliente.ToUpper()) — $($p.id) — $($p.projeto)" -ForegroundColor White
            $i++
        }
        Write-Host ""
        $escolha = Read-Host "  Numero do projeto"
        $idx = [int]$escolha - 1
        if ($idx -lt 0 -or $idx -ge $projetosAtivos.Count) {
            Write-Host "  [ERRO] Escolha invalida. Informe -cliente [NOME] diretamente." -ForegroundColor Red
            exit 1
        }
        $projeto = $projetosAtivos[$idx]
        $cliente = $projeto.cliente.ToUpper()
        $projetoId = $projeto.id
        $projetoNome = $projeto.projeto
        Write-Host "  Cliente confirmado: $cliente ($projetoId)" -ForegroundColor Green
    }
} else {
    $cliente = $cliente.ToUpper()
    $wip = Get-Content "$raiz\CLIENTES\WIP_BOARD.json" -Raw | ConvertFrom-Json
    $projeto = @($wip.board.build) | Where-Object { $_.cliente.ToUpper() -eq $cliente } | Select-Object -First 1
    $projetoId = if ($projeto) { $projeto.id } else { "?" }
    $projetoNome = if ($projeto) { $projeto.projeto } else { $cliente }
    Write-Host "[0/4] Cliente: $cliente ($projetoId)" -ForegroundColor Green
}

$claude_project_dir = "$raiz\CLIENTES\$cliente\CLAUDE_PROJECT"
$instrucao          = "$claude_project_dir\00_INSTRUCAO_SISTEMA.md"
$mensagem           = "$claude_project_dir\MENSAGEM_INTERACAO_INICIAL.md"
$contratoStatus     = "$raiz\CLIENTES\$cliente\CONTRATO_STATUS.txt"

# --------------------------------------------------------------------------
# PASSO SYNC -- Atualizar CLAUDE_PROJECT com versoes mais recentes
# Roda sempre que o script e executado. Zero intervencao do Diretor.
# --------------------------------------------------------------------------
Write-Host ""
Write-Host "[SYNC] Atualizando documentos do CLAUDE_PROJECT..." -ForegroundColor Cyan

if (-not (Test-Path $claude_project_dir)) {
    New-Item -ItemType Directory -Path $claude_project_dir -Force | Out-Null
}

$syncCount = 0
$missCount = 0

function Sync-Doc($origem, $destino, $label) {
    if (Test-Path $origem) {
        Copy-Item $origem $destino -Force
        Write-Host "  [OK] $label" -ForegroundColor Green
        $script:syncCount++
    } else {
        Write-Host "  [--] $label" -ForegroundColor DarkGray
        $script:missCount++
    }
}

# Universais (todos os clientes)
Sync-Doc "$raiz\INTELLIGENCE_LEDGER.md" `
         "$claude_project_dir\06_INTELLIGENCE_LEDGER.md" `
         "INTELLIGENCE_LEDGER"

Sync-Doc "$raiz\PENTALATERAL_UNIVERSAL\HISTORICO\VANGUARD_TIMELINE.md" `
         "$claude_project_dir\16_VANGUARD_TIMELINE.md" `
         "VANGUARD_TIMELINE"

Sync-Doc "$raiz\CLIENTES\WIP_BOARD.json" `
         "$claude_project_dir\07_WIP_BOARD.json" `
         "WIP_BOARD"

Sync-Doc "$raiz\CLIENTES\$cliente\BRIEFING_DISCOVERY.txt" `
         "$claude_project_dir\01_BRIEFING_DISCOVERY.txt" `
         "BRIEFING_DISCOVERY"

Sync-Doc "$raiz\CLIENTES\$cliente\CONTRATO_STATUS.txt" `
         "$claude_project_dir\05_CONTRATO_STATUS.txt" `
         "CONTRATO_STATUS"

# Cliente-especificos: ultima versao de cada tipo
$clienteLower = $cliente.ToLower()

# DIRETRIZ_GEMINI: copiada para CLAUDE_PROJECT apenas como referencia local.
# NAO subir no Claude.ai/projects -- contem secoes [PARA O MUSCULO] que confundem o Embaixador.
# O BLOCO 2 da MENSAGEM_INTERACAO_INICIAL ja extrai as [G-1 a G-5] relevantes para ele.
$ultimaDiretriz = Get-ChildItem "$raiz\CLIENTES\$cliente" -Filter "DIRETRIZ_GEMINI_V*.txt" `
                  -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($ultimaDiretriz) {
    Sync-Doc $ultimaDiretriz.FullName `
             "$claude_project_dir\02_DIRETRIZ_GEMINI_LATEST.txt" `
             "DIRETRIZ_GEMINI ($($ultimaDiretriz.Name)) [referencia local -- nao subir no Projects]"
}

$ultimaSkill = Get-ChildItem "$raiz\.claude\skills" -Filter "skill_$($clienteLower)*.md" `
               -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($ultimaSkill) {
    Sync-Doc $ultimaSkill.FullName `
             "$claude_project_dir\03_SKILL_BUILD_PLAN.md" `
             "SKILL ($($ultimaSkill.Name))"
}

$proposta = Get-ChildItem "$raiz\CLIENTES\$cliente" -Filter "PROPOSTA_COMERCIAL*.md" `
            -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($proposta) {
    Sync-Doc $proposta.FullName `
             "$claude_project_dir\04_PROPOSTA_COMERCIAL.md" `
             "PROPOSTA_COMERCIAL ($($proposta.Name))"
}

$ultimoTermo = Get-ChildItem "$raiz\CLIENTES\$cliente" -Filter "Termo_*.pdf" `
               -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($ultimoTermo) {
    Sync-Doc $ultimoTermo.FullName `
             "$claude_project_dir\$($ultimoTermo.Name)" `
             "Termo PDF ($($ultimoTermo.Name))"
}

if ($AutoSync) {
    Write-Host "  [AUTOSYNC] Embaixador $cliente - $syncCount docs sincronizados" -ForegroundColor Cyan
    exit 0
}

Write-Host ""
Write-Host "  Sync: $syncCount docs atualizados | $missCount ausentes (normais)" -ForegroundColor Cyan

# --------------------------------------------------------------------------
# PASSO 1 -- Copiar mensagem de ativacao para o clipboard
# --------------------------------------------------------------------------
Write-Host ""
Write-Host "[1/4] Copiando mensagem de ativacao para o clipboard..." -ForegroundColor Yellow
if (Test-Path $mensagem) {
    Get-Content $mensagem -Raw -Encoding UTF8 | Set-Clipboard
    Write-Host "  [OK] Mensagem copiada -- so colar (Ctrl+V) no chat do Claude Projects" -ForegroundColor Green
} else {
    Write-Host "  [--] MENSAGEM_INTERACAO_INICIAL.md nao encontrada em:" -ForegroundColor Red
    Write-Host "       $mensagem" -ForegroundColor DarkGray
}


# CHECK DIRETRIZ -- Verificar se DIRETRIZ_GEMINI do loop atual existe antes de abrir
$checkDiretrizScript = "$raiz\scripts\check_diretriz_embaixador.ps1"
if (Test-Path $checkDiretrizScript) {
    if ($ApenasAtivacao) {
        & $checkDiretrizScript -cliente $cliente -Silencioso
        Write-Host "  (-ApenasAtivacao: gate DIRETRIZ ignorado -- so ativar nova sistematica)" -ForegroundColor DarkGray
    } elseif ($OrdemDiretor) {
        Write-Host "  (P-154: comunicacao direta do Diretor -- gate DIRETRIZ ignorado por ordem explicita)" -ForegroundColor DarkGray
        Write-Host "  Registrar no LOG do Embaixador o motivo da consulta direta." -ForegroundColor DarkGray
    } else {
        & $checkDiretrizScript -cliente $cliente
        if ($LASTEXITCODE -eq 1) {
            Write-Host ""
            Write-Host "  Browser NAO aberto. Resolva o bloqueio acima e rode novamente." -ForegroundColor Red
            exit 1
        }
    }
}

# CHECK VEREDITOS_RESUMO -- Verificar memoria do Embaixador antes de abrir o Project
$resumoDir = "$raiz\CLIENTES\$cliente\CLAUDE_PROJECT"
$resumosExistentes = Get-ChildItem "$resumoDir\VEREDITOS_RESUMO_*.md" -ErrorAction SilentlyContinue |
                     Sort-Object LastWriteTime -Descending
if ($resumosExistentes -and $resumosExistentes.Count -gt 0) {
    $ultimoResumo = $resumosExistentes[0]
    $dataResumo = $ultimoResumo.BaseName -replace "VEREDITOS_RESUMO_${cliente}_", ""
    Write-Host ""
    Write-Host "  [OK] Resumo de vereditos $dataResumo incluido." -ForegroundColor Green
    Write-Host "       Carregar $($ultimoResumo.Name) como Knowledge Document antes de iniciar." -ForegroundColor DarkGray
} else {
    Write-Host ""
    Write-Host "  [ATENCAO] Nenhum resumo de vereditos encontrado." -ForegroundColor Yellow
    Write-Host "  Verificar AutoSync antes de continuar -- Embaixador abre sem rastreabilidade de decisoes." -ForegroundColor Yellow
    Write-Host "  Eduardo decide se abre o Project mesmo assim ou resolve o sync primeiro." -ForegroundColor White
}
# PASSO 2 -- Abrir browser no Claude Projects
Write-Host ""
Write-Host "[2/4] Abrindo Claude Projects no browser..." -ForegroundColor Yellow
Start-Process "https://claude.ai/projects"
Start-Sleep -Seconds 1

# PASSO 3 -- Abrir Explorer na pasta CLAUDE_PROJECT
Write-Host ""
Write-Host "[3/4] Abrindo Explorer na pasta do Embaixador..." -ForegroundColor Yellow
if (Test-Path $claude_project_dir) {
    Start-Process explorer.exe $claude_project_dir
    Write-Host "  [OK] Explorer aberto em $claude_project_dir" -ForegroundColor Green
} else {
    Write-Host "  [AVISO] Pasta nao encontrada: $claude_project_dir" -ForegroundColor Yellow
}

# PASSO 4 -- Status do contrato
Write-Host ""
Write-Host "[4/4] Verificando status do contrato..." -ForegroundColor Yellow
if (Test-Path $contratoStatus) {
    $status = Get-Content $contratoStatus -Raw
    if ($status -match "\[ASSINADO\]") {
        Write-Host "  [OK] Contrato: ASSINADO" -ForegroundColor Green
    } else {
        Write-Host "  [!!] Contrato: PENDENTE DE ASSINATURA (P-023 ativo)" -ForegroundColor Red
    }
} else {
    Write-Host "  [--] CONTRATO_STATUS.txt nao existe -- criar apos assinatura" -ForegroundColor Yellow
}

# --------------------------------------------------------------------------
# INSTRUCOES FINAIS
# --------------------------------------------------------------------------
# RISCO A -- Atualizar loop_fase_atual.embaixador = "OK" automaticamente (P-077)
if (-not $AutoSync) {
    $wipPath2 = "$raiz\CLIENTES\WIP_BOARD.json"
    try {
        $wipData = Get-Content $wipPath2 -Raw -Encoding UTF8 | ConvertFrom-Json
        $proj2   = @($wipData.board.build) | Where-Object { $_.cliente.ToUpper() -eq $cliente } | Select-Object -First 1
        if ($proj2 -and $proj2.loop_fase_atual) {
            $proj2.loop_fase_atual.embaixador = "OK"
            $proj2.loop_fase_atual.proximo = "Musculo -- sintese P-037 e deliberacao"
            $wipData | ConvertTo-Json -Depth 15 | Set-Content $wipPath2 -Encoding UTF8
            Write-Host "  [LOOP] loop_fase_atual.embaixador = OK -- WIP_BOARD atualizado" -ForegroundColor Green
        }
    } catch {
        Write-Host "  [WARN] Nao foi possivel atualizar loop_fase_atual.embaixador" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host "  INSTRUCOES -- O QUE FAZER NO CLAUDE PROJECTS  " -ForegroundColor Magenta
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  PROJECT: $projetoId - $cliente" -ForegroundColor White
Write-Host ""
Write-Host "  SE FOR A PRIMEIRA VEZ (configuracao inicial):" -ForegroundColor Yellow
Write-Host "  1. Criar novo Project para $cliente em claude.ai/projects" -ForegroundColor White
Write-Host "  2. Colar o conteudo de 00_INSTRUCAO_SISTEMA.md nas Instructions do Project" -ForegroundColor White
Write-Host "     $instrucao" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  3. Subir TODOS os arquivos desta pasta na aba Files do Project:" -ForegroundColor White
Write-Host "     $claude_project_dir" -ForegroundColor DarkGray
Write-Host "     (MENSAGEM_INTERACAO_INICIAL.md e WATCHDOG_TEMPLATE.md: NAO subir -- uso interno)" -ForegroundColor DarkGray
Write-Host ""

# Lista os arquivos do CLAUDE_PROJECT para conferencia visual
$arquivosCP = Get-ChildItem $claude_project_dir -File -ErrorAction SilentlyContinue | Sort-Object Name
$i = 1
foreach ($arq in $arquivosCP) {
    if ($arq.Name -match "^(MENSAGEM|WATCHDOG)") {
        Write-Host "     [$i] $($arq.Name)  [uso interno -- nao subir]" -ForegroundColor DarkGray
    } elseif ($arq.Name -match "^02_DIRETRIZ") {
        Write-Host "     [$i] $($arq.Name)  [referencia local -- nao subir]" -ForegroundColor DarkYellow
    } else {
        Write-Host "     [$i] $($arq.Name)" -ForegroundColor White
    }
    $i++
}

Write-Host ""
Write-Host "  SE JA ESTIVER CONFIGURADO (sessao ativa):" -ForegroundColor Yellow
Write-Host "  O clipboard JA TEM a mensagem de ativacao." -ForegroundColor Green
Write-Host "  Cole (Ctrl+V) diretamente no chat do Project." -ForegroundColor White
Write-Host ""
Write-Host "  O Embaixador vai entregar SEM voce pedir:" -ForegroundColor Yellow
Write-Host "  [A] Diagnostico cruzado -- so ele pode ver (memoria persistente)" -ForegroundColor White
Write-Host "  [B] CONFIRMA/EXPANDE/ALERTA nas 25 ideias do loop" -ForegroundColor White
Write-Host "  [C] Comportamento real de $projetoNome (frases E-2 e E-5)" -ForegroundColor White
Write-Host "  [D] Amplitude Pentalateral -- [E-1 a E-5] (comercial, pipeline, business case)" -ForegroundColor White
Write-Host "  [E] Artefatos prontos -- mensagens WhatsApp para uso imediato" -ForegroundColor White
Write-Host "  [F] DECISOES_${cliente}_[DATA].json -- salvar LOCAL em CLAUDE_PROJECT/DECISOES/ (NAO subir ao Projects -- JSON nao e lido como Knowledge Document)" -ForegroundColor White
Write-Host "  [G] LOG_CLIENTE desta sessao (fonte do Auditor no proximo loop)" -ForegroundColor White
Write-Host ""
Write-Host "  PRE-REQUISITO (se ainda nao fez):" -ForegroundColor Yellow
  Write-Host "  Subir DIRETRIZ_GEMINI_V[N].txt no Claude Project (Knowledge Documents)" -ForegroundColor Magenta
  Write-Host "  Embaixador precisa da DIRETRIZ completa -- nao so [G-1 a G-5] da SECAO D" -ForegroundColor White
  Write-Host ""
  Write-Host "  APOS RECEBER (Eduardo so delibera — Musculo faz o resto):" -ForegroundColor Yellow
Write-Host "  Cole o output completo do Embaixador no Claude Code." -ForegroundColor Cyan
Write-Host "  Musculo extrai DECISOES.json + lista: 'D1: [titulo] — A: [opcao] | B: [opcao]'" -ForegroundColor Cyan
Write-Host "  Eduardo responde: 'D1:A, D2:B' → Musculo executa tudo automaticamente." -ForegroundColor Cyan
Write-Host "  DECISOES.json fica LOCAL em CLAUDE_PROJECT/DECISOES/ — NAO sobe ao Projects." -ForegroundColor DarkGray
Write-Host ""
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host ""




