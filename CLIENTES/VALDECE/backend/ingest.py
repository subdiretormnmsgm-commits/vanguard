"""
Corpus Pipeline — Dia 3 (atualizado)
STF + STJ Open Data → Filtro Penal → tema classification → Gemini embedding-004 → Supabase pgvector

Uso:
  python ingest.py --source stf --limit 300
  python ingest.py --source stj --limit 300
  python ingest.py --source all --limit 300   ← recomendado (STF + STJ)
  python ingest.py --source csv --file acordaos.csv --limit 500
"""

import argparse
import json
import os
import sys
import time
from pathlib import Path

import requests
from dotenv import load_dotenv
from supabase import create_client

load_dotenv(Path(__file__).parent.parent / ".env")

SUPABASE_URL = os.environ["SUPABASE_URL"]
SUPABASE_SERVICE_KEY = os.environ["SUPABASE_SERVICE_KEY"]
GEMINI_API_KEY = os.environ["GEMINI_API_KEY"]

GEMINI_EMBED_URL = (
    "https://generativelanguage.googleapis.com/v1beta/models/"
    "text-embedding-004:embedContent"
)
GEMINI_FLASH_URL = (
    "https://generativelanguage.googleapis.com/v1beta/models/"
    "gemini-1.5-flash:generateContent"
)

STF_SEARCH_URL = "https://jurisprudencia.stf.jus.br/api/search/search"
STJ_SEARCH_URL = "https://scon.stj.jus.br/SCON/pesquisar.jsp"

PENAL_KEYWORDS = [
    "crime", "pena", "réu", "acusado", "habeas corpus", "tráfico",
    "homicídio", "furto", "roubo", "estelionato", "corrupção",
    "prisão preventiva", "liberdade provisória", "sursis", "reclusão",
    "detenção", "absolvição", "condenação", "indiciamento", "denúncia",
    "nulidade", "dosimetria", "concurso de crimes", "reincidência",
]

# 8 categorias penais — fundação do Radar de Divergência (V2)
TEMAS_PENAIS = [
    "trafico",        # Tráfico de drogas e entorpecentes
    "vida",           # Homicídio, feminicídio, lesão corporal
    "patrimonio",     # Roubo, furto, estelionato, extorsão
    "habeas_corpus",  # HC, prisão preventiva, excesso de prazo
    "dosimetria",     # Dosimetria de pena, regime, substituição
    "nulidade",       # Nulidades processuais, cerceamento
    "corrupcao",      # Corrupção, lavagem, improbidade
    "outros",         # Demais crimes penais
]

COST_PER_1K_EMBED  = 0.000025   # USD — text-embedding-004
COST_PER_1K_FLASH  = 0.000075   # USD — gemini-1.5-flash input (estimativa conservadora)


# ──────────────────────────────────────────────────────────────
# Fonte 1: STF Open Data API
# ──────────────────────────────────────────────────────────────

def fetch_stf(limit: int) -> list[dict]:
    results = []
    page = 0
    page_size = 10
    print(f"[STF] Buscando até {limit} acórdãos de Direito Penal...")

    while len(results) < limit:
        payload = {
            "query": "direito penal crime pena",
            "tribunal": "STF",
            "from": page * page_size,
            "size": page_size,
        }
        try:
            resp = requests.post(STF_SEARCH_URL, json=payload, timeout=15)
            resp.raise_for_status()
        except Exception as e:
            print(f"[STF] Erro na requisição (página {page}): {e}")
            break

        hits = resp.json().get("hits", {}).get("hits", [])
        if not hits:
            break

        for hit in hits:
            src = hit.get("_source", {})
            ementa = src.get("ementa", "").strip()
            if not ementa:
                continue
            lower = ementa.lower()
            if not any(kw in lower for kw in PENAL_KEYWORDS):
                continue

            results.append({
                "tribunal": "STF",
                "numero_acordao": src.get("numeroAcordao") or src.get("numeroProcesso", ""),
                "ementa": ementa,
                "content": ementa,
                "area": "penal",
                "relator": src.get("nomeRelator", ""),
                "data_julgamento": src.get("dataJulgamento", "")[:10] if src.get("dataJulgamento") else None,
                "link": src.get("url", ""),
            })
            if len(results) >= limit:
                break

        page += 1
        time.sleep(0.2)

    print(f"[STF] {len(results)} acórdãos coletados.")
    return results


# ──────────────────────────────────────────────────────────────
# Fonte 2: STJ Open Data API
# ──────────────────────────────────────────────────────────────

def fetch_stj(limit: int) -> list[dict]:
    """
    Busca acórdãos do STJ via API de dados abertos.
    O STJ disponibiliza jurisprudência em formato JSON via endpoint público.
    Endpoint: https://dadosabertos.stj.jus.br/api/3/action/datastore_search
    """
    results = []
    page = 0
    page_size = 20

    # Endpoint dos dados abertos do STJ
    STJ_OPEN_DATA_URL = "https://dadosabertos.stj.jus.br/api/3/action/datastore_search"

    # Resource IDs conhecidos do STJ Open Data (jurisprudência penal)
    # Fallback: busca por texto no endpoint de pesquisa do SCON
    RESOURCE_ID = "b4d57ee5-e538-4f74-9b8b-0cfd4ac7a979"

    print(f"[STJ] Buscando até {limit} acórdãos de Direito Penal...")

    while len(results) < limit:
        params = {
            "resource_id": RESOURCE_ID,
            "q": "crime penal",
            "limit": page_size,
            "offset": page * page_size,
        }
        try:
            resp = requests.get(STJ_OPEN_DATA_URL, params=params, timeout=15)
            resp.raise_for_status()
            data = resp.json()

            if not data.get("success"):
                print("[STJ] API retornou erro — usando fallback SCON")
                return fetch_stj_scon(limit)

            records = data.get("result", {}).get("records", [])
            if not records:
                break

            for rec in records:
                ementa = (rec.get("ementa") or rec.get("EMENTA") or "").strip()
                if not ementa:
                    continue
                lower = ementa.lower()
                if not any(kw in lower for kw in PENAL_KEYWORDS):
                    continue

                numero = (
                    rec.get("numero_processo")
                    or rec.get("NUMERO_PROCESSO")
                    or rec.get("id", "")
                )
                data_jul = (
                    rec.get("data_julgamento")
                    or rec.get("DATA_JULGAMENTO")
                    or ""
                )
                if data_jul and len(data_jul) >= 10:
                    data_jul = data_jul[:10]
                else:
                    data_jul = None

                results.append({
                    "tribunal": "STJ",
                    "numero_acordao": str(numero),
                    "ementa": ementa,
                    "content": ementa,
                    "area": "penal",
                    "relator": rec.get("relator") or rec.get("RELATOR") or "",
                    "data_julgamento": data_jul,
                    "link": rec.get("link") or rec.get("LINK") or "",
                })
                if len(results) >= limit:
                    break

        except Exception as e:
            print(f"[STJ] Erro (página {page}): {e} — usando fallback SCON")
            return fetch_stj_scon(limit)

        page += 1
        time.sleep(0.3)

    print(f"[STJ] {len(results)} acórdãos coletados.")
    return results


def fetch_stj_scon(limit: int) -> list[dict]:
    """
    Fallback: busca STJ via SCON (interface web com suporte a parâmetros GET).
    Retorna JSON quando o parâmetro formato=json é enviado.
    """
    results = []
    print("[STJ-SCON] Tentando via SCON fallback...")

    termos = ["tráfico", "homicídio", "prisão preventiva", "habeas corpus", "furto"]

    for termo in termos:
        if len(results) >= limit:
            break
        try:
            params = {
                "b": "ACOR",
                "pesq": termo,
                "formato": "json",
                "p": "true",
                "l": min(20, limit - len(results)),
            }
            resp = requests.get(
                "https://scon.stj.jus.br/SCON/jurisprudencia/doc.jsp",
                params=params,
                timeout=15,
                headers={"Accept": "application/json"},
            )
            if resp.status_code != 200:
                continue

            # SCON pode retornar HTML mesmo com formato=json — verificar
            content_type = resp.headers.get("content-type", "")
            if "json" not in content_type:
                print(f"[STJ-SCON] Retornou HTML para '{termo}' — pulando")
                continue

            for item in resp.json().get("documentos", []):
                ementa = item.get("ementa", "").strip()
                if not ementa:
                    continue
                results.append({
                    "tribunal": "STJ",
                    "numero_acordao": item.get("processo", ""),
                    "ementa": ementa,
                    "content": ementa,
                    "area": "penal",
                    "relator": item.get("relator", ""),
                    "data_julgamento": item.get("data", "")[:10] if item.get("data") else None,
                    "link": item.get("url", ""),
                })
                if len(results) >= limit:
                    break

        except Exception as e:
            print(f"[STJ-SCON] Erro em '{termo}': {e}")

        time.sleep(0.5)

    if not results:
        print("[STJ] Ambos os endpoints falharam. Use --source csv com arquivo STJ.")

    print(f"[STJ-SCON] {len(results)} acórdãos coletados.")
    return results


# ──────────────────────────────────────────────────────────────
# Fonte 3: CSV local (fallback ou importação manual)
# ──────────────────────────────────────────────────────────────

def fetch_csv(filepath: str, limit: int) -> list[dict]:
    import csv
    results = []
    with open(filepath, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            if len(results) >= limit:
                break
            ementa = row.get("ementa", "").strip()
            if not ementa:
                continue
            results.append({
                "tribunal": row.get("tribunal", "STF").upper(),
                "numero_acordao": row.get("numero_acordao", ""),
                "ementa": ementa,
                "content": ementa,
                "area": "penal",
                "relator": row.get("relator", ""),
                "data_julgamento": row.get("data_julgamento") or None,
                "link": row.get("link", ""),
            })
    print(f"[CSV] {len(results)} acórdãos carregados.")
    return results


# ──────────────────────────────────────────────────────────────
# Classificação de tema via Gemini Flash (Layer A — Radar V2)
# ──────────────────────────────────────────────────────────────

def classify_tema(ementa: str) -> str:
    """
    Classifica a ementa em uma das 8 categorias penais via Gemini Flash.
    Custo: ~$0.000075 por documento (irrisório).
    Retorna uma das strings em TEMAS_PENAIS.
    """
    prompt = (
        f"Classifique esta ementa jurídica penal em UMA das categorias abaixo.\n"
        f"Responda APENAS com a palavra da categoria, sem explicação.\n\n"
        f"Categorias: trafico, vida, patrimonio, habeas_corpus, dosimetria, nulidade, corrupcao, outros\n\n"
        f"Ementa: {ementa[:500]}\n\n"
        f"Categoria:"
    )
    try:
        payload = {
            "contents": [{"parts": [{"text": prompt}]}],
            "generationConfig": {"maxOutputTokens": 10, "temperature": 0},
        }
        resp = requests.post(
            GEMINI_FLASH_URL,
            json=payload,
            params={"key": GEMINI_API_KEY},
            timeout=15,
        )
        resp.raise_for_status()
        tema = resp.json()["candidates"][0]["content"]["parts"][0]["text"].strip().lower()
        return tema if tema in TEMAS_PENAIS else "outros"
    except Exception:
        return "outros"


# ──────────────────────────────────────────────────────────────
# Embedding via Gemini text-embedding-004
# ──────────────────────────────────────────────────────────────

def embed_text(text: str) -> list[float]:
    payload = {
        "model": "models/text-embedding-004",
        "content": {"parts": [{"text": text[:8192]}]},
        "taskType": "RETRIEVAL_DOCUMENT",
    }
    resp = requests.post(
        GEMINI_EMBED_URL,
        json=payload,
        params={"key": GEMINI_API_KEY},
        timeout=30,
    )
    resp.raise_for_status()
    return resp.json()["embedding"]["values"]


# ──────────────────────────────────────────────────────────────
# Custo estimado
# ──────────────────────────────────────────────────────────────

def estimate_cost(docs: list[dict]) -> float:
    tokens_embed = len(docs) * 200
    tokens_flash = len(docs) * 100
    return (tokens_embed / 1000) * COST_PER_1K_EMBED + (tokens_flash / 1000) * COST_PER_1K_FLASH


# ──────────────────────────────────────────────────────────────
# Pipeline principal
# ──────────────────────────────────────────────────────────────

def run(docs: list[dict], dry_run: bool = False) -> None:
    supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)
    inserted = skipped = errors = 0

    for i, doc in enumerate(docs):
        text = doc["content"]
        numero = doc.get("numero_acordao", f"idx-{i}")
        tribunal = doc["tribunal"]

        existing = (
            supabase.table("documents")
            .select("id")
            .eq("numero_acordao", numero)
            .eq("tribunal", tribunal)
            .execute()
        )
        if existing.data:
            skipped += 1
            continue

        if dry_run:
            print(f"  [DRY] {tribunal} · {numero} — {text[:60]}...")
            inserted += 1
            continue

        try:
            # Layer A: classificar tema antes do embedding
            tema = classify_tema(doc["ementa"])

            embedding = embed_text(text)

            tokens_approx = max(1, len(text.split()))
            cost = (tokens_approx / 1000) * COST_PER_1K_EMBED
            supabase.table("token_usage").insert({
                "date": time.strftime("%Y-%m-%d"),
                "operation": "embed_ingest",
                "tokens_used": tokens_approx,
                "cost_usd": cost,
            }).execute()

            payload = {
                "tribunal": tribunal,
                "numero_acordao": numero or None,
                "ementa": doc["ementa"],
                "content": doc["content"],
                "area": doc.get("area", "penal"),
                "tema": tema,
                "relator": doc.get("relator") or None,
                "data_julgamento": doc.get("data_julgamento") or None,
                "link": doc.get("link") or None,
                "embedding": embedding,
            }
            supabase.table("documents").insert(payload).execute()
            inserted += 1
            print(f"  [{i+1}/{len(docs)}] ✓ {tribunal} · {numero} [{tema}]")

        except Exception as e:
            errors += 1
            print(f"  [{i+1}/{len(docs)}] ✗ {numero}: {e}")

        time.sleep(0.1)

    print(f"\n[INGEST] Concluído — inseridos: {inserted} | pulados: {skipped} | erros: {errors}")


# ──────────────────────────────────────────────────────────────
# CLI
# ──────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Corpus ingestion pipeline — Valdece")
    parser.add_argument("--source", choices=["stf", "stj", "all", "csv"], default="all",
                        help="Fonte: stf | stj | all (STF+STJ) | csv")
    parser.add_argument("--file", help="Caminho do CSV (apenas quando --source=csv)")
    parser.add_argument("--limit", type=int, default=300,
                        help="Limite por fonte (default: 300)")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    docs = []

    if args.source in ("stf", "all"):
        docs += fetch_stf(args.limit)

    if args.source in ("stj", "all"):
        docs += fetch_stj(args.limit)

    if args.source == "csv":
        if not args.file:
            print("Erro: --file obrigatório quando --source=csv")
            sys.exit(1)
        docs = fetch_csv(args.file, args.limit)

    if not docs:
        print("[INGEST] Nenhum documento coletado. Verifique conectividade ou use --source csv.")
        sys.exit(1)

    # Remover duplicatas entre STF e STJ (mesmo número de processo em tribunais diferentes é válido)
    seen = set()
    unique_docs = []
    for doc in docs:
        key = f"{doc['tribunal']}:{doc['numero_acordao']}"
        if key not in seen:
            seen.add(key)
            unique_docs.append(doc)

    print(f"\n[TOTAL] {len(unique_docs)} documentos únicos ({len(docs) - len(unique_docs)} duplicatas removidas)")

    est = estimate_cost(unique_docs)
    print(f"[CUSTO ESTIMADO] USD ${est:.6f} (~R$ {est * 5.8:.4f})")

    if not args.dry_run:
        confirm = input("Confirmar ingestão? (s/N): ").strip().lower()
        if confirm != "s":
            print("Abortado.")
            sys.exit(0)

    run(unique_docs, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
