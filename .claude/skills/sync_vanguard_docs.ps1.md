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

--------------------------------------------------------------------------------
2. sync_vanguard_docs.sh (Corrigido com Varredura Recursiva Universal para Mac/Linux)
#!/usr/bin/env bash
### sync_vanguard_docs.sh
### Vanguard Doc Sync — Script do Músculo (Linux / Mac)
### Versão: 2.1 | Atualizado pelo Auditor e Diretor (Varredura Universal Profunda)

set -euo pipefail

CLIENTE=""; MODO="completo"; VERBOSE=false
PROMOVER=""; DESTINO_P=""; DELETAR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cliente)  CLIENTE="$2";    shift 2 ;;
    --modo)     MODO="$2";       shift 2 ;;
    --verbose)  VERBOSE=true;    shift   ;;
    --promover) PROMOVER="$2";   shift 2 ;;
    --destino)  DESTINO_P="$2";  shift 2 ;;
    --deletar)  DELETAR="$2";    shift 2 ;;
    *) echo "Argumento desconhecido: $1"; exit 1 ;;
  esac
done

RAIZ="$(pwd)"
# CORREÇÃO DO DIRETOR: A base agora é toda a pasta QUADRILATERAL_UNIVERSAL
UNIVERSAL_BASE="$RAIZ/QUADRILATERAL_UNIVERSAL"
CLIENTES_DIR="$RAIZ/CLIENTES"
DATA_HOJE=$(date +"%Y%m%d")
RELATORIO="$RAIZ/SYNC_REPORT_$DATA_HOJE.md"

# Arquivos críticos dinâmicos
CRITICOS=("WIP_BOARD.json" "INTELLIGENCE_LEDGER.md" "VANGUARD_TIMELINE.md" "CONSELHO/NotebookLM/ANALISE_SOCIO_ATUAL.txt")

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'
log() { echo -e "$1"; }
rel() { echo "$1" >> "$RELATORIO"; }

sha256_file() {
  if command -v sha256sum &>/dev/null; then sha256sum "$1" | awk '{print $1}'
  else shasum -a 256 "$1" | awk '{print $1}'
  fi
}

### Ações Especiais (Órfãos)
if [[ -n "$PROMOVER" ]]; then
  [[ -z "$DESTINO_P" ]] && { log "${RED}ERRO: --destino obrigatório${NC}"; exit 1; }
  mkdir -p "$DESTINO_P"
  cp "$PROMOVER" "$DESTINO_P/"
  log "${GREEN}✅ PROMOVIDO: $PROMOVER -> $DESTINO_P${NC}"
  exit 0
fi

if [[ -n "$DELETAR" ]]; then
  [[ -f "$DELETAR" ]] && rm "$DELETAR" && log "${YELLOW}🗑️ DELETADO: $DELETAR${NC}" || log "${YELLOW}Não encontrado: $DELETAR${NC}"
  exit 0
fi

### Validação
[[ ! -d "$UNIVERSAL_BASE" ]] && { log "${RED}BLOQUEIO: $UNIVERSAL_BASE não encontrada.${NC}"; exit 1; }
[[ ! -d "$CLIENTES_DIR"   ]] && { log "${RED}BLOQUEIO: $CLIENTES_DIR não encontrada.${NC}"; exit 1; }

echo "# VANGUARD DOC SYNC — RELATORIO $DATA_HOJE" > "$RELATORIO"
rel "> P-033 — Sync universal -> projetos é obrigatório e imediato (Expansão V25)"

declare -a PROJETOS=()
if [[ -n "$CLIENTE" ]]; then
  PROJ_PATH="$CLIENTES_DIR/$CLIENTE"
  [[ ! -d "$PROJ_PATH" ]] && { log "${RED}Projeto '$CLIENTE' não encontrado.${NC}"; exit 1; }
  PROJETOS=("$PROJ_PATH")
else
  while IFS= read -r -d '' p; do PROJETOS+=("$p"); done < <(find "$CLIENTES_DIR" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null || true)
fi

log "\n${CYAN}VANGUARD DOC SYNC — $DATA_HOJE | Projetos: ${#PROJETOS[@]}${NC}"

# Coletar fontes
declare -a FONTES_NOME=()
declare -a FONTES_PATH=()

# CORREÇÃO DO DIRETOR: Busca profunda em todas as subpastas dentro de QUADRILATERAL_UNIVERSAL
while IFS= read -r -d '' f; do
  FONTES_NOME+=("$(basename "$f")"); FONTES_PATH+=("$f")
done < <(find "$UNIVERSAL_BASE" -type f \( -name "*.md" -o -name "*.txt" \) -print0 2>/dev/null || true)

for CRITICO in "${CRITICOS[@]}"; do
  if [[ -f "$RAIZ/$CRITICO" ]]; then
    FONTES_NOME+=("$(basename "$CRITICO")"); FONTES_PATH+=("$RAIZ/$CRITICO")
  fi
done

TOTAL_FONTES="${#FONTES_NOME[@]}"
log "${YELLOW}RODADA 1 — INVENTARIO (${TOTAL_FONTES} fontes mapeadas)${NC}"

CNT_SYNC=0; CNT_DESATUAL=0; CNT_AUSENTE=0; CNT_ORFAO=0; SINC_R2=0; FALHAS_R3=0
declare -a ORFAOS=()

for PROJ_PATH in "${PROJETOS[@]}"; do
  PROJ_NOME=$(basename "$PROJ_PATH")
  FONTES_DIR="$PROJ_PATH/NOTEBOOKLM_FONTES"
  mkdir -p "$FONTES_DIR"

  # Verifica AUSENTE, SYNC, DESATUAL
  for i in "${!FONTES_NOME[@]}"; do
    NOME="${FONTES_NOME[$i]}"; CAMINHO="${FONTES_PATH[$i]}"
    COPIA="$FONTES_DIR/$NOME"
    
    if [[ ! -f "$COPIA" ]]; then
      ((CNT_AUSENTE++)) || true
      if [[ "$MODO" == "completo" ]]; then cp "$CAMINHO" "$COPIA"; ((SINC_R2++)) || true; fi
    else
      if [[ "$(sha256_file "$CAMINHO")" == "$(sha256_file "$COPIA")" ]]; then
        ((CNT_SYNC++)) || true
      else
        ((CNT_DESATUAL++)) || true
        if [[ "$MODO" == "completo" ]]; then cp "$CAMINHO" "$COPIA"; ((SINC_R2++)) || true; fi
      fi
    fi
  done
  
  # Verifica Órfãos
  while IFS= read -r -d '' f; do
    NOME_PROJ_ARQ=$(basename "$f")
    FOUND=0
    for NOME_FONTE in "${FONTES_NOME[@]}"; do
      if [[ "$NOME_FONTE" == "$NOME_PROJ_ARQ" ]]; then FOUND=1; break; fi
    done
    if [[ $FOUND -eq 0 ]]; then
      ((CNT_ORFAO++)) || true
      ORFAOS+=("$PROJ_NOME|$NOME_PROJ_ARQ")
    fi
  done < <(find "$FONTES_DIR" -maxdepth 1 -type f -print0 2>/dev/null || true)
done

# Rodada 3 (Integridade final embutida)
if [[ "$MODO" == "completo" ]]; then
  for PROJ_PATH in "${PROJETOS[@]}"; do
    FONTES_DIR="$PROJ_PATH/NOTEBOOKLM_FONTES"
    for i in "${!FONTES_NOME[@]}"; do
      NOME="${FONTES_NOME[$i]}"; CAMINHO="${FONTES_PATH[$i]}"; COPIA="$FONTES_DIR/$NOME"
      if [[ -f "$COPIA" && "$(sha256_file "$CAMINHO")" != "$(sha256_file "$COPIA")" ]]; then
        ((FALHAS_R3++)) || true
        log "${RED}❌ Falha Hash Pós-cópia: $COPIA${NC}"
      fi
    done
  done
fi

INTEGRIDADE="VERDE"
[[ $CNT_ORFAO -gt 0 ]] && INTEGRIDADE="AMARELO"
[[ $FALHAS_R3 -gt 0 ]] && INTEGRIDADE="VERMELHO"

rel "Sincronizados: $SINC_R2 | Falhas Hash: $FALHAS_R3 | Órfãos: $CNT_ORFAO"
if [[ ${#ORFAOS[@]} -gt 0 ]]; then
  rel "## DECISÕES PENDENTES: ÓRFÃOS"
  for O in "${ORFAOS[@]}"; do rel "- $O"; done
fi

COR_INT=$GREEN; [[ "$INTEGRIDADE" == "AMARELO" ]] && COR_INT=$YELLOW; [[ "$INTEGRIDADE" == "VERMELHO" ]] && COR_INT=$RED
log "\n${CYAN}SYNC CONCLUÍDO | INTEGRIDADE: ${COR_INT}${INTEGRIDADE}${NC}"
log "Sincronizados: $SINC_R2 | Órfãos: $CNT_ORFAO"