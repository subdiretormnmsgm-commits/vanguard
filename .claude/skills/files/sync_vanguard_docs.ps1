### sync_vanguard_docs.ps1
### Vanguard Doc Sync — Script do Músculo
### Versão: 2.1 | Atualizado pelo Auditor e Diretor (Varredura Universal Profunda)
### Baseado em: P-033 — Sync universal → projetos é obrigatório e imediato

param(
    [string]$cliente = "",
    [ValidateSet("completo", "verificar")]
    [string]$modo = "completo",
    [switch]$verbose,
    [string]$promover = "",
    [string]$destino = "",
    [string]$deletar = ""
)

### ─────────────────────────────────────────────
### CONFIGURAÇÃO — Estrutura Pentalateral IAH
### ─────────────────────────────────────────────
$RAIZ = (Get-Item -Path ".").FullName
# CORRECAO DO DIRETOR: A base agora é toda a pasta QUADRILATERAL_UNIVERSAL
$UNIVERSAL_BASE = Join-Path $RAIZ "QUADRILATERAL_UNIVERSAL"
$CLIENTES_DIR   = Join-Path $RAIZ "CLIENTES"
$DATA_HOJE      = Get-Date -Format "yyyyMMdd"
$RELATORIO_PATH = Join-Path $RAIZ "SYNC_REPORT_$DATA_HOJE.md"

### Arquivos Criticos Dinamicos na Raiz
$ARQUIVOS_CRITICOS_RAIZ = @(
    "WIP_BOARD.json",
    "INTELLIGENCE_LEDGER.md",
    "VANGUARD_TIMELINE.md",
    "CONSELHO\NotebookLM\ANALISE_SOCIO_ATUAL.txt"
)

### ─────────────────────────────────────────────
### FUNCOES AUXILIARES
### ─────────────────────────────────────────────
function Get-FileHash256 {
    param([string]$path)
    if (Test-Path $path) { return (Get-FileHash -Path $path -Algorithm SHA256).Hash }
    return $null
}

function Write-Log {
    param([string]$msg, [string]$cor = "White")
    Write-Host $msg -ForegroundColor $cor
}

function Write-Relatorio {
    param([string]$linha)
    Add-Content -Path $RELATORIO_PATH -Value $linha -Encoding UTF8
}

### ─────────────────────────────────────────────
### ACOES ESPECIAIS (ORFAOS)
### ─────────────────────────────────────────────
if ($promover -ne "") {
    if ($destino -eq "") { Write-Log "ERRO: -destino e obrigatorio ao usar -promover." "Red"; exit 1 }
    $destino_completo = Join-Path $RAIZ $destino
    if (-not (Test-Path $destino_completo)) { New-Item -ItemType Directory -Path $destino_completo -Force | Out-Null }
    Copy-Item -Path $promover -Destination $destino_completo -Force
    Write-Log "PROMOVIDO: $promover -> $destino_completo" "Green"
    exit 0
}

if ($deletar -ne "") {
    $alvo = Join-Path $RAIZ $deletar
    if (Test-Path $alvo) {
        Remove-Item -Path $alvo -Force
        Write-Log "DELETADO: $alvo" "Yellow"
    } else {
        Write-Log "Arquivo nao encontrado: $alvo" "Yellow"
    }
    exit 0
}

### ─────────────────────────────────────────────
### VALIDACAO INICIAL E PROJETOS
### ─────────────────────────────────────────────
if (-not (Test-Path $UNIVERSAL_BASE)) { Write-Log "BLOQUEIO: Pasta QUADRILATERAL_UNIVERSAL nao encontrada." "Red"; exit 1 }
if (-not (Test-Path $CLIENTES_DIR)) { Write-Log "BLOQUEIO: Pasta CLIENTES nao encontrada." "Red"; exit 1 }

if (Test-Path $RELATORIO_PATH) { Remove-Item $RELATORIO_PATH }
Write-Relatorio "# VANGUARD DOC SYNC -- RELATORIO $DATA_HOJE"
Write-Relatorio "> Principio: P-033 -- Sync universal -> projetos e obrigatorio e imediato"
Write-Relatorio ""

$projetos = @()
if ($cliente -ne "") {
    $proj_path = Join-Path $CLIENTES_DIR $cliente
    if (Test-Path $proj_path) { $projetos = @($proj_path) } else { Write-Log "Projeto '$cliente' nao encontrado." "Red"; exit 1 }
} else {
    $projetos = Get-ChildItem -Path $CLIENTES_DIR -Directory | ForEach-Object { $_.FullName }
}

Write-Log "==================================================" "Cyan"
Write-Log "  VANGUARD DOC SYNC -- $DATA_HOJE (Modo: $modo)" "Cyan"
Write-Log "==================================================" "Cyan"

### ─────────────────────────────────────────────
### RODADA 1 — INVENTARIO (Varredura Recursiva Universal)
### ─────────────────────────────────────────────
Write-Log "RODADA 1 -- INVENTARIO" "Yellow"

# CORRECAO DO DIRETOR: Busca recursiva (-Recurse) em todas as subpastas da base Universal
$arquivos_universais = Get-ChildItem -Path $UNIVERSAL_BASE -Recurse -File | Where-Object { $_.Extension -match "\.(md|txt)$" }
$lista_fontes_origem = @()

foreach ($arq in $arquivos_universais) {
    $lista_fontes_origem += [PSCustomObject]@{ Nome = $arq.Name; Caminho = $arq.FullName }
}

foreach ($arq_critico in $ARQUIVOS_CRITICOS_RAIZ) {
    $caminho_critico = Join-Path $RAIZ $arq_critico
    if (Test-Path $caminho_critico) {
        $lista_fontes_origem += [PSCustomObject]@{ Nome = (Split-Path $arq_critico -Leaf); Caminho = $caminho_critico }
    }
}

$total_universal = $lista_fontes_origem.Count
Write-Log "  Arquivos fontes a espelhar: $total_universal" "White"

$inventario = @{}
$contadores = @{ SYNC=0; DESATUAL=0; AUSENTE=0; ORFAO=0 }

foreach ($proj_path in $projetos) {
    $proj_nome = Split-Path $proj_path -Leaf
    $fontes_dir = Join-Path $proj_path "NOTEBOOKLM_FONTES"
    if (-not (Test-Path $fontes_dir)) { New-Item -ItemType Directory -Path $fontes_dir -Force | Out-Null }

    foreach ($fonte in $lista_fontes_origem) {
        $arq_destino = Join-Path $fontes_dir $fonte.Nome
        $chave = "$proj_nome|$($fonte.Nome)"

        if (-not (Test-Path $arq_destino)) {
            $inventario[$chave] = "AUSENTE"; $contadores.AUSENTE++
        } else {
            if ((Get-FileHash256 $fonte.Caminho) -eq (Get-FileHash256 $arq_destino)) {
                $inventario[$chave] = "SYNC"; $contadores.SYNC++
            } else {
                $inventario[$chave] = "DESATUAL"; $contadores.DESATUAL++
            }
        }
    }

    # Check Orfaos
    $arquivos_projeto = Get-ChildItem -Path $fontes_dir -File
    foreach ($arq_proj in $arquivos_projeto) {
        $existe_na_origem = $lista_fontes_origem | Where-Object { $_.Nome -eq $arq_proj.Name }
        if (-not $existe_na_origem) {
            $chave = "$proj_nome|$($arq_proj.Name)"
            $inventario[$chave] = "ORFAO"; $contadores.ORFAO++
        }
    }
}

Write-Log ""
Write-Log "  RESUMO RODADA 1:" "White"
Write-Log "  SYNC:          $($contadores.SYNC)" "Green"
Write-Log "  DESATUALIZADO: $($contadores.DESATUAL)" "Yellow"
Write-Log "  AUSENTE:       $($contadores.AUSENTE)" "Red"
Write-Log "  ORFAO:         $($contadores.ORFAO)" "Magenta"

if ($modo -eq "verificar") {
    Write-Log ""
    Write-Log "  Modo 'verificar' - Rodadas 2 e 3 nao executadas." "Gray"
    Write-Relatorio "## VERIFICACAO"
    Write-Relatorio "- SYNC: $($contadores.SYNC)"
    Write-Relatorio "- DESATUALIZADO: $($contadores.DESATUAL)"
    Write-Relatorio "- AUSENTE: $($contadores.AUSENTE)"
    Write-Relatorio "- ORFAO: $($contadores.ORFAO)"
    Write-Log "  Relatorio salvo em: $RELATORIO_PATH" "Cyan"
    exit 0
}

### ─────────────────────────────────────────────
### RODADA 2 E 3 — SINCRONIZACAO E INTEGRIDADE
### ─────────────────────────────────────────────
Write-Log ""
Write-Log "RODADA 2 -- SINCRONIZACAO" "Yellow"

$sincronizados = 0
$falhas = 0

foreach ($proj_path in $projetos) {
    $proj_nome = Split-Path $proj_path -Leaf
    $fontes_dir = Join-Path $proj_path "NOTEBOOKLM_FONTES"

    foreach ($fonte in $lista_fontes_origem) {
        $chave = "$proj_nome|$($fonte.Nome)"
        $arq_destino = Join-Path $fontes_dir $fonte.Nome

        if ($inventario[$chave] -in @("AUSENTE", "DESATUAL")) {
            Copy-Item -Path $fonte.Caminho -Destination $arq_destino -Force
            $sincronizados++
            if ($verbose) { Write-Log "  SYNC: $proj_nome\$($fonte.Nome)" "Green" }

            # Rodada 3 Embutida:
            if ((Get-FileHash256 $fonte.Caminho) -ne (Get-FileHash256 $arq_destino)) {
                $falhas++
                Write-Log "  FALHA hash pos-copia: $arq_destino" "Red"
            }
        }
    }
}

Write-Log "  Sincronizados nesta rodada: $sincronizados" "Green"

Write-Log ""
Write-Log "RODADA 3 -- VERIFICACAO DE INTEGRIDADE" "Yellow"
Write-Log "  Verificados: $($contadores.SYNC + $sincronizados) | Re-sincronizados: 0" "White"

$integridade = if ($contadores.ORFAO -gt 0) { "AMARELO" } elseif ($falhas -gt 0) { "VERMELHO" } else { "VERDE" }

Write-Log ""
Write-Log "==================================================" "Cyan"
Write-Log "  SYNC CONCLUIDO -- $DATA_HOJE" "Cyan"
Write-Log "==================================================" "Cyan"
Write-Log "  INTEGRIDADE: $integridade" $(if($integridade -eq 'VERDE'){"Green"}elseif($integridade -eq 'AMARELO'){"Yellow"}else{"Red"})
Write-Log ""
Write-Log "  Sync:      $sincronizados arquivos" "White"
Write-Log "  Orfaos:    $($contadores.ORFAO) arquivo(s) - veredito do Diretor necessario" $(if($contadores.ORFAO -gt 0){"Yellow"}else{"Green"})
Write-Log ""
Write-Log "  Relatorio: $RELATORIO_PATH" "Cyan"
Write-Log "==================================================" "Cyan"

Write-Relatorio "## STATUS FINAL"
Write-Relatorio "- Sincronizados: $sincronizados"
Write-Relatorio "- Falhas de Integridade: $falhas"
Write-Relatorio "- Orfaos (Pendentes de Veredito): $($contadores.ORFAO)"

if ($contadores.ORFAO -gt 0) {
    Write-Relatorio "## DECISOES PENDENTES (ORFAOS)"
    foreach ($key in $inventario.Keys | Where-Object { $inventario[$_] -eq "ORFAO" }) {
        Write-Relatorio "- $key"
    }
}
