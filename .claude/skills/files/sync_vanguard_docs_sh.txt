#!/usr/bin/env bash
# sync_vanguard_docs.sh
# Vanguard Doc Sync — Script do Músculo (Linux / Mac)
# Versão: 1.0 | 2026-05-19
# Baseado em: P-033 — Sync universal → projetos é obrigatório e imediato
#
# USO:
#   bash scripts/sync_vanguard_docs.sh
#   bash scripts/sync_vanguard_docs.sh --cliente VALDECE
#   bash scripts/sync_vanguard_docs.sh --modo verificar
#   bash scripts/sync_vanguard_docs.sh --verbose

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
UNIVERSAL_BASE="$RAIZ/QUADRILATERAL_UNIVERSAL/NOTEBOOKLM_BASE"
CLIENTES_DIR="$RAIZ/CLIENTES"
DATA_HOJE=$(date +"%Y%m%d")
RELATORIO="$RAIZ/SYNC_REPORT_$DATA_HOJE.md"

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'
log() { echo -e "$1"; }
rel() { echo "$1" >> "$RELATORIO"; }

sha256_file() {
    if command -v sha256sum &>/dev/null; then
        sha256sum "$1" | awk '{print $1}'
    else
        shasum -a 256 "$1" | awk '{print $1}'
    fi
}

# Acoes especiais
if [[ -n "$PROMOVER" ]]; then
    [[ -z "$DESTINO_P" ]] && { log "${RED}ERRO: --destino obrigatorio com --promover${NC}"; exit 1; }
    mkdir -p "$DESTINO_P"
    cp "$PROMOVER" "$DESTINO_P/"
    log "${GREEN}PROMOVIDO: $PROMOVER -> $DESTINO_P${NC}"
    exit 0
fi

if [[ -n "$DELETAR" ]]; then
    [[ -f "$DELETAR" ]] && rm "$DELETAR" && log "${YELLOW}DELETADO: $DELETAR${NC}" || log "${YELLOW}Nao encontrado: $DELETAR${NC}"
    exit 0
fi

# Validacao
[[ ! -d "$UNIVERSAL_BASE" ]] && { log "${RED}BLOQUEIO: $UNIVERSAL_BASE nao encontrada.${NC}"; exit 1; }
[[ ! -d "$CLIENTES_DIR"   ]] && { log "${RED}BLOQUEIO: $CLIENTES_DIR nao encontrada.${NC}";   exit 1; }

> "$RELATORIO"
rel "# VANGUARD DOC SYNC — RELATORIO $DATA_HOJE"
rel "> P-033 — Sync universal -> projetos e obrigatorio e imediato"
rel ""; rel "---"; rel ""

declare -a PROJETOS=()
if [[ -n "$CLIENTE" ]]; then
    PROJ_PATH="$CLIENTES_DIR/$CLIENTE"
    [[ ! -d "$PROJ_PATH" ]] && { log "${RED}Projeto '$CLIENTE' nao encontrado.${NC}"; exit 1; }
    PROJETOS=("$PROJ_PATH")
else
    while IFS= read -r -d '' p; do PROJETOS+=("$p"); done < <(find "$CLIENTES_DIR" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null || true)
fi

log ""; log "${CYAN}VANGUARD DOC SYNC — $DATA_HOJE | Modo: $MODO | Projetos: ${#PROJETOS[@]}${NC}"; log ""

mapfile -t ARQUIVOS_UNIVERSAIS < <(find "$UNIVERSAL_BASE" -maxdepth 1 -name "*.md" -type f 2>/dev/null || true)
TOTAL_UNIVERSAL="${#ARQUIVOS_UNIVERSAIS[@]}"

log "${YELLOW}RODADA 1 — INVENTARIO${NC}"
rel "## RODADA 1 — INVENTARIO"; rel "Arquivos universais: $TOTAL_UNIVERSAL"; rel ""

declare -A INVENTARIO=()
declare -a ORFAOS=() BLOQUEIOS=()
CNT_SYNC=0; CNT_DESATUAL=0; CNT_AUSENTE=0; CNT_ORFAO=0; CNT_SYNC_R2=0; CNT_FALHA_R3=0

for PROJ_PATH in "${PROJETOS[@]}"; do
    PROJ_NOME=$(basename "$PROJ_PATH")
    FONTES_DIR="$PROJ_PATH/NOTEBOOKLM_FONTES"
    rel "### $PROJ_NOME"; rel ""

    if [[ ! -d "$FONTES_DIR" ]]; then
        rel "AUSENTE: NOTEBOOKLM_FONTES nao existe — sera criada na Rodada 2"; rel ""
        for ARQ in "${ARQUIVOS_UNIVERSAIS[@]}"; do
            NOME=$(basename "$ARQ")
            INVENTARIO["$PROJ_NOME|$NOME"]="AUSENTE"
            ((CNT_AUSENTE++)) || true
            rel "- AUSENTE: $NOME"
        done
        continue
    fi

    for ARQ in "${ARQUIVOS_UNIVERSAIS[@]}"; do
        NOME=$(basename "$ARQ")
        COPIA="$FONTES_DIR/$NOME"
        HASH_U=$(sha256_file "$ARQ")
        if [[ ! -f "$COPIA" ]]; then
            INVENTARIO["$PROJ_NOME|$NOME"]="AUSENTE"
            ((CNT_AUSENTE++)) || true
            rel "- AUSENTE: $NOME"
        else
            HASH_C=$(sha256_file "$COPIA")
            if [[ "$HASH_U" == "$HASH_C" ]]; then
                INVENTARIO["$PROJ_NOME|$NOME"]="SYNC"
                ((CNT_SYNC++)) || true
                $VERBOSE && log "  SYNC: $PROJ_NOME/$NOME"
            else
                INVENTARIO["$PROJ_NOME|$NOME"]="DESATUALIZADO"
                ((CNT_DESATUAL++)) || true
                rel "- DESATUALIZADO: $NOME"
            fi
        fi
    done

    while IFS= read -r -d '' ARQ_PROJ; do
        NOME_PROJ=$(basename "$ARQ_PROJ")
        EXISTE=false
        for ARQ_U in "${ARQUIVOS_UNIVERSAIS[@]}"; do [[ "$(basename "$ARQ_U")" == "$NOME_PROJ" ]] && EXISTE=true && break; done
        if ! $EXISTE; then
            ((CNT_ORFAO++)) || true
            ORFAOS+=("$PROJ_NOME|$NOME_PROJ")
            log "  ${RED}ORFAO: $NOME_PROJ${NC}"
            rel "- ORFAO: $NOME_PROJ (sem correspondente na universal)"
        fi
    done < <(find "$FONTES_DIR" -maxdepth 1 -name "*.md" -type f -print0 2>/dev/null || true)
    rel ""
done

log "  SYNC:$CNT_SYNC  DESATUAL:$CNT_DESATUAL  AUSENTE:$CNT_AUSENTE  ORFAO:$CNT_ORFAO"
rel ""; rel "SYNC:$CNT_SYNC | DESATUAL:$CNT_DESATUAL | AUSENTE:$CNT_AUSENTE | ORFAO:$CNT_ORFAO"
rel ""; rel "---"; rel ""

if [[ "$MODO" == "verificar" ]]; then
    log "\n${CYAN}Modo verificar — Rodadas 2 e 3 nao executadas. Relatorio: $RELATORIO${NC}"
    exit 0
fi

# RODADA 2 — SINCRONIZACAO
log ""; log "${YELLOW}RODADA 2 — SINCRONIZACAO${NC}"
rel "## RODADA 2 — SINCRONIZACAO"; rel ""

for PROJ_PATH in "${PROJETOS[@]}"; do
    PROJ_NOME=$(basename "$PROJ_PATH")
    FONTES_DIR="$PROJ_PATH/NOTEBOOKLM_FONTES"
    mkdir -p "$FONTES_DIR"

    for ARQ in "${ARQUIVOS_UNIVERSAIS[@]}"; do
        NOME=$(basename "$ARQ")
        STATUS="${INVENTARIO["$PROJ_NOME|$NOME"]:-}"
        if [[ "$STATUS" == "DESATUALIZADO" || "$STATUS" == "AUSENTE" ]]; then
            if cp "$ARQ" "$FONTES_DIR/$NOME" 2>/dev/null; then
                ((CNT_SYNC_R2++)) || true
                log "  ${GREEN}SYNC: $PROJ_NOME/$NOME${NC}"
                rel "- SYNC: $PROJ_NOME/$NOME"
            else
                BLOQUEIOS+=("$PROJ_NOME/$NOME")
                rel "- FALHA: $PROJ_NOME/$NOME"
            fi
        fi
    done
done

rel ""; rel "Sincronizados:$CNT_SYNC_R2 | Bloqueios:${#BLOQUEIOS[@]}"; rel ""; rel "---"; rel ""

# RODADA 3 — VERIFICACAO
log ""; log "${YELLOW}RODADA 3 — VERIFICACAO${NC}"
rel "## RODADA 3 — VERIFICACAO"; rel ""
VERIFICADOS=0

for PROJ_PATH in "${PROJETOS[@]}"; do
    PROJ_NOME=$(basename "$PROJ_PATH")
    FONTES_DIR="$PROJ_PATH/NOTEBOOKLM_FONTES"
    for ARQ in "${ARQUIVOS_UNIVERSAIS[@]}"; do
        NOME=$(basename "$ARQ")
        COPIA="$FONTES_DIR/$NOME"
        if [[ -f "$COPIA" ]]; then
            HASH_U=$(sha256_file "$ARQ"); HASH_C=$(sha256_file "$COPIA")
            if [[ "$HASH_U" == "$HASH_C" ]]; then
                ((VERIFICADOS++)) || true
            else
                ((CNT_FALHA_R3++)) || true
                cp "$ARQ" "$COPIA"
                log "  ${RED}RE-SYNC: $PROJ_NOME/$NOME${NC}"
                rel "- RE-SINCRONIZADO: $PROJ_NOME/$NOME"
            fi
        fi
    done
done

rel ""; rel "Verificados:$VERIFICADOS | Re-sincronizados:$CNT_FALHA_R3"; rel ""; rel "---"; rel ""

# STATUS FINAL
INTEGRIDADE="VERDE"
[[ $CNT_ORFAO -gt 0 ]] && INTEGRIDADE="AMARELO"
[[ ${#BLOQUEIOS[@]} -gt 0 || $CNT_FALHA_R3 -gt 0 ]] && INTEGRIDADE="VERMELHO"

rel "## STATUS FINAL"; rel ""
rel "| Metrica | Valor |"; rel "|---|---|"
rel "| Arquivos universais | $TOTAL_UNIVERSAL |"
rel "| Projetos processados | ${#PROJETOS[@]} |"
rel "| Sincronizados Rodada 2 | $CNT_SYNC_R2 |"
rel "| Re-sincronizados Rodada 3 | $CNT_FALHA_R3 |"
rel "| Orfaos pendentes | $CNT_ORFAO |"
rel "| Bloqueios | ${#BLOQUEIOS[@]} |"
rel "| INTEGRIDADE | $INTEGRIDADE |"; rel ""

if [[ ${#ORFAOS[@]} -gt 0 ]]; then
    rel "## DECISOES PENDENTES PARA O DIRETOR"; rel ""
    for ORFAO in "${ORFAOS[@]}"; do
        PROJ_O="${ORFAO%%|*}"; ARQ_O="${ORFAO##*|}"
        rel "ORFAO: CLIENTES/$PROJ_O/NOTEBOOKLM_FONTES/$ARQ_O"
        rel "  Acao: deletar | promover para universal"; rel ""
    done
fi

rel "---"; rel "*Gerado por sync_vanguard_docs.sh | P-033*"

COR_INT="$GREEN"; [[ "$INTEGRIDADE" == "AMARELO" ]] && COR_INT="$YELLOW"; [[ "$INTEGRIDADE" == "VERMELHO" ]] && COR_INT="$RED"
log ""
log "${CYAN}SYNC CONCLUIDO — $DATA_HOJE${NC}"
log "INTEGRIDADE: ${COR_INT}$INTEGRIDADE${NC}"
log "${GREEN}Sincronizados: $CNT_SYNC_R2${NC}"
[[ $CNT_ORFAO -gt 0 ]] && log "${RED}Orfaos: $CNT_ORFAO — veredito do Diretor necessario${NC}"
log "Relatorio: $RELATORIO"
