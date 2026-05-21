"""
Migração de dados: Supabase antigo → Supabase novo Vanguard
Copia os 61 acórdãos (com embeddings) sem precisar das APIs STF/STJ.
"""

import json
import os
import sys
import requests
from pathlib import Path
from dotenv import load_dotenv

load_dotenv(Path(__file__).parent.parent / ".env")

# Supabase novo (destino) — credenciais do .env
NEW_URL = os.environ["SUPABASE_URL"]
NEW_KEY = os.environ["SUPABASE_SERVICE_KEY"]

# Supabase antigo (origem) — credenciais hardcoded para esta migração
OLD_URL = "https://hqqxzecftkvtrlpkhvnc.supabase.co"
OLD_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxcXh6ZWNmdGt2dHJscGtodm5jIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3OTEzODk2NiwiZXhwIjoyMDk0NzE0OTY2fQ.z-AhKLYy9bKupZEAqfZnn_yYuI75l7dWPiozRSddfsY"

HEADERS_OLD = {"apikey": OLD_KEY, "Authorization": f"Bearer {OLD_KEY}"}
HEADERS_NEW = {
    "apikey": NEW_KEY,
    "Authorization": f"Bearer {NEW_KEY}",
    "Content-Type": "application/json",
    "Prefer": "return=minimal",
}


def fetch_all_old() -> list[dict]:
    """Busca todos os documentos do Supabase antigo em lotes de 50."""
    docs = []
    offset = 0
    batch = 50
    fields = "id,tribunal,numero_acordao,ementa,content,area,tema,relator,data_julgamento,link,embedding,created_at"

    print("[ORIGEM] Buscando documentos do Supabase antigo...")
    while True:
        resp = requests.get(
            f"{OLD_URL}/rest/v1/documents",
            headers=HEADERS_OLD,
            params={"select": fields, "limit": batch, "offset": offset},
            timeout=30,
        )
        resp.raise_for_status()
        batch_data = resp.json()
        if not batch_data:
            break
        docs.extend(batch_data)
        print(f"  Buscados: {len(docs)} documentos")
        if len(batch_data) < batch:
            break
        offset += batch

    print(f"[ORIGEM] Total: {len(docs)} documentos")
    return docs


def insert_new(docs: list[dict]) -> None:
    """Insere os documentos no novo Supabase em lotes de 10."""
    batch_size = 10
    ok = 0
    erros = 0

    # Preparar docs: remover id (auto-gerado), garantir campos V3 com default
    for doc in docs:
        doc.pop("id", None)
        doc.pop("created_at", None)
        doc.setdefault("data_dje", None)
        doc.setdefault("repercussao_geral", False)
        doc.setdefault("recurso_repetitivo", False)
        doc.setdefault("turma", None)

    print(f"\n[DESTINO] Inserindo {len(docs)} documentos no novo Supabase...")
    for i in range(0, len(docs), batch_size):
        lote = docs[i : i + batch_size]
        resp = requests.post(
            f"{NEW_URL}/rest/v1/documents",
            headers=HEADERS_NEW,
            json=lote,
            timeout=30,
        )
        if resp.status_code in (200, 201):
            ok += len(lote)
            print(f"  ✓ Inseridos {ok}/{len(docs)}")
        else:
            erros += len(lote)
            print(f"  ✗ Erro no lote {i//batch_size + 1}: {resp.status_code} — {resp.text[:200]}")

    print(f"\n[RESULTADO] OK: {ok} | Erros: {erros}")
    if erros == 0:
        print("✅ Migração concluída com sucesso!")
    else:
        print("⚠️  Migração parcial — verifique os erros acima.")


def verify_new() -> None:
    """Verifica quantidade de documentos no novo Supabase."""
    resp = requests.get(
        f"{NEW_URL}/rest/v1/documents",
        headers={**HEADERS_NEW, "Prefer": "count=exact"},
        params={"select": "id", "limit": 1},
        timeout=15,
    )
    count = resp.headers.get("content-range", "?/?").split("/")[-1]
    print(f"\n[VERIFICAÇÃO] Documentos no novo Supabase: {count}")


if __name__ == "__main__":
    print("=" * 60)
    print("MIGRACAO TOGA DIGITAL -- Supabase antigo -> Vanguard")
    print("=" * 60)

    docs = fetch_all_old()
    if not docs:
        print("❌ Nenhum documento encontrado na origem.")
        sys.exit(1)

    insert_new(docs)
    verify_new()
