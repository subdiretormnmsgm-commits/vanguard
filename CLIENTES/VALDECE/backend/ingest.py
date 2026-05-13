"""
Corpus Pipeline — Dia 2
STF Open Data → Filtro Direito Penal → Gemini embedding-004 → Supabase pgvector

Uso:
  python ingest.py --source stf --limit 100
  python ingest.py --source csv --file acordaos.csv --limit 200
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

# STF Open Data — endpoint público de pesquisa de jurisprudência
STF_SEARCH_URL = "https://jurisprudencia.stf.jus.br/api/search/search"

# Termos-chave para filtrar acórdãos de Direito Penal
PENAL_KEYWORDS = [
    "crime", "pena", "réu", "acusado", "habeas corpus", "tráfico",
    "homicídio", "furto", "roubo", "estelionato", "corrupção",
    "prisão preventiva", "liberdade provisória", "sursis", "reclusão",
    "detenção", "absolvição", "condenação", "indiciamento",
]


# ──────────────────────────────────────────────────────────────
# Fonte 1: STF Open Data API
# ──────────────────────────────────────────────────────────────

def fetch_stf(limit: int) -> list[dict]:
    """Busca acórdãos do STF via API pública, retorna lista normalizada."""
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

            # Filtro de relevância: pelo menos 1 keyword penal
            lower = ementa.lower()
            if not any(kw in lower for kw in PENAL_KEYWORDS):
                continue

            results.append({
                "tribunal": "STF",
                "numero_acordao": src.get("numeroAcordao") or src.get("numeroProcesso", ""),
                "ementa": ementa,
                "content": ementa,  # MVP: content = ementa; futura versão usa texto completo
                "area": "penal",
                "relator": src.get("nomeRelator", ""),
                "data_julgamento": src.get("dataJulgamento", "")[:10] if src.get("dataJulgamento") else None,
                "link": src.get("url", ""),
            })

            if len(results) >= limit:
                break

        page += 1
        time.sleep(0.2)  # rate limiting cortês

    print(f"[STF] {len(results)} acórdãos coletados.")
    return results


# ──────────────────────────────────────────────────────────────
# Fonte 2: CSV local (fallback ou importação manual)
# ──────────────────────────────────────────────────────────────

def fetch_csv(filepath: str, limit: int) -> list[dict]:
    """Lê acórdãos de um CSV local. Colunas esperadas: tribunal, numero_acordao, ementa, relator, data_julgamento, link."""
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
# Embedding via Gemini text-embedding-004
# ──────────────────────────────────────────────────────────────

def embed_text(text: str) -> list[float]:
    """Gera embedding 768-dim via Gemini. Levanta exceção se API falhar."""
    payload = {
        "model": "models/text-embedding-004",
        "content": {"parts": [{"text": text[:8192]}]},  # limite seguro de tokens
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
# Custo estimado (Burn Rate preview)
# ──────────────────────────────────────────────────────────────

COST_PER_1K_EMBED = 0.000025  # USD por 1K tokens


def estimate_cost(docs: list[dict]) -> float:
    """Estimativa conservadora: 200 tokens médios por ementa."""
    total_tokens = len(docs) * 200
    return (total_tokens / 1000) * COST_PER_1K_EMBED


# ──────────────────────────────────────────────────────────────
# Pipeline principal
# ──────────────────────────────────────────────────────────────

def run(docs: list[dict], dry_run: bool = False) -> None:
    supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

    inserted = 0
    skipped = 0
    errors = 0

    for i, doc in enumerate(docs):
        text = doc["content"]
        numero = doc.get("numero_acordao", f"idx-{i}")

        # Verifica se já existe (idempotência)
        existing = (
            supabase.table("documents")
            .select("id")
            .eq("numero_acordao", numero)
            .eq("tribunal", doc["tribunal"])
            .execute()
        )
        if existing.data:
            skipped += 1
            continue

        if dry_run:
            print(f"  [DRY] {doc['tribunal']} · {numero} — {text[:60]}...")
            inserted += 1
            continue

        try:
            embedding = embed_text(text)

            # Log de custo no Supabase (Burn Rate Shield)
            tokens_approx = max(1, len(text.split()))
            cost = (tokens_approx / 1000) * COST_PER_1K_EMBED
            supabase.table("token_usage").insert({
                "date": time.strftime("%Y-%m-%d"),
                "operation": "embed_ingest",
                "tokens_used": tokens_approx,
                "cost_usd": cost,
            }).execute()

            payload = {
                "tribunal": doc["tribunal"],
                "numero_acordao": doc.get("numero_acordao"),
                "ementa": doc["ementa"],
                "content": doc["content"],
                "area": doc.get("area", "penal"),
                "relator": doc.get("relator"),
                "data_julgamento": doc.get("data_julgamento"),
                "link": doc.get("link"),
                "embedding": embedding,
            }
            supabase.table("documents").insert(payload).execute()
            inserted += 1
            print(f"  [{i+1}/{len(docs)}] ✓ {doc['tribunal']} · {numero}")

        except Exception as e:
            errors += 1
            print(f"  [{i+1}/{len(docs)}] ✗ {numero}: {e}")

        time.sleep(0.1)  # rate limiting gentil

    print(f"\n[INGEST] Concluído — inseridos: {inserted} | pulados: {skipped} | erros: {errors}")


# ──────────────────────────────────────────────────────────────
# CLI
# ──────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Corpus ingestion pipeline — Valdece")
    parser.add_argument("--source", choices=["stf", "csv"], default="stf")
    parser.add_argument("--file", help="Caminho do CSV (apenas quando --source=csv)")
    parser.add_argument("--limit", type=int, default=100)
    parser.add_argument("--dry-run", action="store_true", help="Mostra o que seria inserido, sem chamar APIs")
    args = parser.parse_args()

    if args.source == "stf":
        docs = fetch_stf(args.limit)
    else:
        if not args.file:
            print("Erro: --file obrigatório quando --source=csv")
            sys.exit(1)
        docs = fetch_csv(args.file, args.limit)

    if not docs:
        print("[INGEST] Nenhum documento coletado. Verifique conectividade ou o CSV.")
        sys.exit(1)

    est = estimate_cost(docs)
    print(f"\n[CUSTO ESTIMADO] {len(docs)} docs × ~200 tokens = USD ${est:.6f}")
    if not args.dry_run:
        confirm = input("Confirmar ingestão? (s/N): ").strip().lower()
        if confirm != "s":
            print("Abortado pelo usuário.")
            sys.exit(0)

    run(docs, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
