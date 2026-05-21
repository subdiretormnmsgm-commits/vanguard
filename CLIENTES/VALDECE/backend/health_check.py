"""
Health Check — Toga Digital Valdece (P-051)
Roda as queries do roteiro do cliente e envia relatório no Telegram.
Uso: python backend/health_check.py
"""

import os, time, requests
from pathlib import Path
from dotenv import load_dotenv

load_dotenv(Path(__file__).parent.parent / ".env")

SUPABASE_URL   = os.environ["SUPABASE_URL"]
SUPABASE_ANON  = os.environ["SUPABASE_ANON_KEY"]
GEMINI_API_KEY = os.environ["GEMINI_API_KEY"]

TELEGRAM_TOKEN   = "8146192723:AAHVZJzzV0R_jp2sAaSE3T2AFFjnzMWuOgE"
TELEGRAM_CHAT_ID = "8895733647"

EMBED_URL = (
    f"https://generativelanguage.googleapis.com/v1beta/models/"
    f"gemini-embedding-001:embedContent?key={GEMINI_API_KEY}"
)

HEADERS_SB = {
    "apikey": SUPABASE_ANON,
    "Authorization": f"Bearer {SUPABASE_ANON}",
    "Content-Type": "application/json",
}

# Roteiro P-051 — termos do próprio cliente (discovery Valdece)
ROTEIRO = [
    "prisão preventiva excesso de prazo",
    "habeas corpus flagrante ilegal",
    "tráfico de drogas pena reduzida privilegiado",
    "execução antecipada pena inconstitucional",
    "medidas cautelares diversas prisão proporcionalidade",
]


def embed(text: str) -> list[float]:
    r = requests.post(
        EMBED_URL,
        json={
            "content": {"parts": [{"text": text}]},
            "taskType": "RETRIEVAL_QUERY",
            "outputDimensionality": 3072,
        },
        timeout=20,
    )
    r.raise_for_status()
    return r.json()["embedding"]["values"]


def search(embedding: list[float], threshold: float = 0.65) -> list[dict]:
    r = requests.post(
        f"{SUPABASE_URL}/rest/v1/rpc/search_documents",
        headers=HEADERS_SB,
        json={"query_embedding": embedding, "match_count": 8, "similarity_threshold": threshold},
        timeout=20,
    )
    r.raise_for_status()
    return r.json()


def send_telegram(msg: str) -> None:
    requests.post(
        f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendMessage",
        json={"chat_id": TELEGRAM_CHAT_ID, "text": msg, "parse_mode": "HTML"},
        timeout=10,
    )


def run_check() -> None:
    print("=" * 55)
    print("HEALTH CHECK — Toga Digital Valdece")
    print("=" * 55)

    resultados = []
    erros = []

    for query in ROTEIRO:
        t0 = time.time()
        try:
            emb = embed(query)
            docs = search(emb)
            elapsed = round(time.time() - t0, 2)
            top = round(docs[0]["similarity"] * 100, 1) if docs else 0
            status = "OK" if docs else "VAZIO"
            resultados.append({
                "query": query,
                "hits": len(docs),
                "top_score": top,
                "elapsed": elapsed,
                "status": status,
            })
            icon = "[OK]" if docs else "[VAZIO]"
            print(f"  {icon} '{query[:40]}' -> {len(docs)} hits | top {top}% | {elapsed}s")
        except Exception as e:
            elapsed = round(time.time() - t0, 2)
            erros.append({"query": query, "erro": str(e)[:80]})
            print(f"  [ERRO] '{query[:40]}' -> {e}")

    # Montar relatório Telegram
    data_hora = time.strftime("%d/%m/%Y %H:%M")
    ok_count  = sum(1 for r in resultados if r["status"] == "OK")
    total     = len(ROTEIRO)
    avg_top   = round(sum(r["top_score"] for r in resultados if r["hits"] > 0) / max(ok_count, 1), 1)
    status_geral = "✅ SISTEMA OK" if not erros and ok_count == total else "⚠️ ATENÇÃO" if ok_count > 0 else "❌ FALHA CRÍTICA"

    linhas = [
        f"<b>🔍 Health Check — Toga Digital Valdece</b>",
        f"<b>{status_geral}</b>  |  {data_hora}",
        "",
        f"<b>Roteiro P-051 ({ok_count}/{total} queries OK)</b>",
    ]

    for r in resultados:
        icon = "✅" if r["hits"] > 0 else "⚠️"
        linhas.append(f'{icon} "{r["query"][:38]}"')
        linhas.append(f'   → {r["hits"]} resultados · top {r["top_score"]}% · {r["elapsed"]}s')

    for e in erros:
        linhas.append(f'❌ "{e["query"][:38]}"')
        linhas.append(f'   → ERRO: {e["erro"]}')

    linhas += [
        "",
        f"📊 Score médio top resultado: <b>{avg_top}%</b>",
        f"🔗 https://toga-digital-valdece.netlify.app",
    ]

    msg = "\n".join(linhas)

    print("\n--- ENVIANDO PARA TELEGRAM ---")
    send_telegram(msg)
    print("Relatorio enviado ao Diretor via Telegram.")


if __name__ == "__main__":
    run_check()
