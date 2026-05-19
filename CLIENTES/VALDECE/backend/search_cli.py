"""
CLI de Busca Semântica — Gate GO/NO-GO (Dia 2)
Valida a qualidade do corpus antes de construir a UI.

Uso:
  python search_cli.py "habeas corpus tráfico de drogas"
  python search_cli.py "prisão preventiva sem fundamentação" --top 5
"""

import argparse
import os
import sys
import time
from pathlib import Path

import requests
from dotenv import load_dotenv
from supabase import create_client

load_dotenv(Path(__file__).parent.parent / ".env")

SUPABASE_URL = os.environ["SUPABASE_URL"]
SUPABASE_ANON_KEY = os.environ["SUPABASE_ANON_KEY"]
GEMINI_API_KEY = os.environ["GEMINI_API_KEY"]

GEMINI_EMBED_URL = (
    "https://generativelanguage.googleapis.com/v1beta/models/"
    "gemini-embedding-001:embedContent"
)

COST_PER_1K_EMBED = 0.000025


def embed_query(query: str) -> list[float]:
    payload = {
        "model": "models/gemini-embedding-001",
        "content": {"parts": [{"text": query}]},
        "taskType": "RETRIEVAL_QUERY",
        "outputDimensionality": 768,
    }
    resp = requests.post(
        GEMINI_EMBED_URL,
        json=payload,
        params={"key": GEMINI_API_KEY},
        timeout=20,
    )
    resp.raise_for_status()
    return resp.json()["embedding"]["values"]


def search(query: str, top_k: int = 3, threshold: float = 0.45) -> list[dict]:
    supabase = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)
    embedding = embed_query(query)

    result = supabase.rpc(
        "search_documents",
        {
            "query_embedding": embedding,
            "match_count": top_k,
            "similarity_threshold": threshold,
        },
    ).execute()

    return result.data or []


def display(results: list[dict], query: str, elapsed: float) -> None:
    sep = "-" * 72
    print(f"\n{sep}")
    print(f"  QUERY : {query}")
    print(f"  TEMPO : {elapsed:.2f}s  |  RESULTADOS: {len(results)}")
    print(sep)

    if not results:
        print("  Nenhum resultado acima do threshold. Ajuste o corpus ou o threshold.")
        return

    for i, r in enumerate(results, 1):
        sim = r.get("similarity", 0)
        tribunal = r.get("tribunal", "?")
        numero = r.get("numero_acordao", "—")
        data = r.get("data_julgamento") or "s/d"
        ementa = r.get("ementa", "")[:200].replace("\n", " ")
        link = r.get("link", "")

        print(f"\n  [{i}] {tribunal} · {numero} · {data}   sim={sim:.3f}")
        print(f"      {ementa}...")
        if link:
            print(f"      {link}")

    print(f"\n{sep}\n")


def main():
    parser = argparse.ArgumentParser(description="Busca semântica jurisprudencial — CLI")
    parser.add_argument("query", help="Consulta em linguagem natural")
    parser.add_argument("--top", type=int, default=3, help="Número de resultados (padrão: 3)")
    parser.add_argument("--threshold", type=float, default=0.45, help="Similaridade mínima (padrão: 0.45 — corpus pequeno)")
    args = parser.parse_args()

    print(f"Buscando: \"{args.query}\"...")
    t0 = time.time()

    try:
        results = search(args.query, args.top, args.threshold)
    except Exception as e:
        print(f"Erro: {e}")
        sys.exit(1)

    elapsed = time.time() - t0
    display(results, args.query, elapsed)

    # Custo da query (estimativa)
    tokens_approx = max(1, len(args.query.split()))
    cost = (tokens_approx / 1000) * COST_PER_1K_EMBED
    print(f"  Custo estimado desta query: USD ${cost:.8f}")


if __name__ == "__main__":
    main()
