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
# CORREÇÃO DO DIRETOR: A base agora é toda a pasta QUADRILATERAL_UNIVERSAL
$UNIVERSAL_BASE = Join-Path $RAIZ "QUADRILATERAL_UNIVERSAL"
$CLIENTES_DIR   = Join-Path $RAIZ "CLIENTES"
$DATA_HOJE      = Get-Date -Format "yyyyMMdd"
$RELATORIO_PATH = Join-Path $RAIZ "SYNC_REPORT_$DATA_HOJE.md"

### Arquivos Críticos Dinâmicos na Raiz
$ARQUIVOS_CRITICOS_RAIZ = @(
    "WIP_BOARD.json",
    "INTELLIGENCE_LEDGER.md",
    "VANGUARD_TIMELINE.md",
    "CONSELHO\NotebookLM\ANALISE_SOCIO_ATUAL.txt"
)

### ─────────────────────────────────────────────
### FUNÇÕES AUXILIARES
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
### AÇÕES ESPECIAIS (ÓRFÃOS)
### ─────────────────────────────────────────────
if ($promover -ne "") {
    if ($destino -eq "") { Write-Log "ERRO: -destino é obrigatório ao usar -promover." "Red"; exit 1 }
    $destino_completo = Join-Path $RAIZ $destino
    if (-not (Test-Path $destino_completo)) { New-Item -ItemType Directory -Path $destino_completo -Force | Out-Null }
    Copy-Item -Path $promover -Destination $destino_completo -Force
    Write-Log "✅ PROMOVIDO: $promover → $destino_completo" "Green"
    exit 0
}

if ($deletar -ne "") {
    $alvo = Join-Path $RAIZ $deletar
    if (Test-Path $alvo) {
        Remove-Item -Path $alvo -Force
        Write-Log "🗑️  DELETADO: $alvo" "Yellow"
    } else {
        Write-Log "⚠️  Arquivo não encontrado: $alvo" "Yellow"
    }
    exit 0
}

### ─────────────────────────────────────────────
### VALIDAÇÃO INICIAL E PROJETOS
### ─────────────────────────────────────────────
if (-not (Test-Path $UNIVERSAL_BASE)) { Write-Log "❌ BLOQUEIO: Pasta QUADRILATERAL_UNIVERSAL não encontrada." "Red"; exit 1 }
if (-not (Test-Path $CLIENTES_DIR)) { Write-Log "❌ BLOQUEIO: Pasta CLIENTES não encontrada." "Red"; exit 1 }

if (Test-Path $RELATORIO_PATH) { Remove-Item $RELATORIO_PATH }
Write-Relatorio "# VANGUARD DOC SYNC — RELATÓRIO $DATA_HOJE"
Write-Relatorio "> Princípio: P-033 — Sync universal → projetos é obrigatório e imediato"
Write-Relatorio ""

$projetos = @()
if ($cliente -ne "") {
    $proj_path = Join-Path $CLIENTES_DIR $cliente
    if (Test-Path $proj_path) { $projetos = @($proj_path) } else { Write-Log "❌ Projeto '$cliente' não encontrado." "Red"; exit 1 }
} else {
    $projetos = Get-ChildItem -Path $CLIENTES_DIR -Directory | ForEach-Object { $_.FullName }
}

Write-Log "══════════════════════════════════════════════════" "Cyan"
Write-Log "  VANGUARD DOC SYNC — $DATA_HOJE (Modo: $modo)" "Cyan"
Write-Log "══════════════════════════════════════════════════" "Cyan"

### ─────────────────────────────────────────────
### RODADA 1 — INVENTÁRIO (Varredura Recursiva Universal)
### ─────────────────────────────────────────────
Write-Log "▶ RODADA 1 — INVENTÁRIO" "Yellow"

# CORREÇÃO DO DIRETOR: Busca recursiva (-Recurse) em todas as subpastas da base Universal
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
    
    # Check Orfãos
    $arquivos_projeto = Get-ChildItem -Path $fontes_dir -File
    foreach ($arq_proj in $arquivos_projeto) {
        $existe_na_origem = $lista_fontes_origem | Where-Object { $_.Nome -eq $arq_proj.Name }
        if (-not $existe_na_origem) {
            $chave = "$proj_nome|$($arq_proj.Name)"
            $inventario[$chave] = "ORFAO"; $contadores.ORFAO++
        }
    }
}

if ($modo -eq "verificar") { Write-Log "Modo verificar — encerrando."; exit 0 }

### ─────────────────────────────────────────────
### RODADA 2 E 3 — SINCRONIZAÇÃO E INTEGRIDADE
### ─────────────────────────────────────────────
Write-Log "▶ RODADAS 2 & 3 — SYNC E VALIDAÇÃO" "Yellow"

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
            
            # Rodada 3 Embutida:
            if ((Get-FileHash256 $fonte.Caminho) -ne (Get-FileHash256 $arq_destino)) {
                $falhas++
                Write-Log "❌ Falha no hash pós-cópia: $arq_destino" "Red"
            }
        }
    }
}

$integridade = if ($contadores.ORFAO -gt 0) { "AMARELO" } elseif ($falhas -gt 0) { "VERMELHO" } else { "VERDE" }
Write-Log "  INTEGRIDADE: $integridade | Sync: $sincronizados | Órfãos: $($contadores.ORFAO)" $(if($integridade -eq 'VERDE'){"Green"}else{"Yellow"})

Write-Relatorio "## STATUS FINAL"
Write-Relatorio "- Sincronizados: $sincronizados"
Write-Relatorio "- Falhas de Integridade: $falhas"
Write-Relatorio "- Órfãos (Pendentes de Veredito): $($contadores.ORFAO)"

if ($contadores.ORFAO -gt 0) {
    Write-Relatorio "## DECISÕES PENDENTES (ÓRFÃOS)"
    foreach ($key in $inventario.Keys | Where-Object { $inventario[$_] -eq "ORFAO" }) {
        Write-Relatorio "- 🔴 $key"
    }
}

