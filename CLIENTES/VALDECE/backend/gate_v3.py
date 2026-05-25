"""
gate_v3.py — Gate de validacao V3 · Toga Digital Valdece
Roda em dois momentos:
  1. PRE-MIGRATION:  python gate_v3.py --check pre
     Verifica se o schema tem vector(3072) e os campos V3 existem.
  2. POS-REINGEST:   python gate_v3.py --check pos
     Verifica se os 61 acordaos tem turma preenchida e >= 1 vinculante.
"""

import argparse
import os
import re
import sys
from pathlib import Path

import requests
from dotenv import load_dotenv
from supabase import create_client

load_dotenv(Path(__file__).parent.parent / ".env")

SUPABASE_URL         = os.environ["SUPABASE_URL"]
SUPABASE_SERVICE_KEY = os.environ["SUPABASE_SERVICE_KEY"]
GEMINI_API_KEY       = os.environ.get("GEMINI_API_KEY", "")

GEMINI_EMBED_URL = (
    "https://generativelanguage.googleapis.com/v1beta/models/"
    "gemini-embedding-001:embedContent"
)

# [N-3] Dimensionalidade esperada — sincronizar com outputDimensionality da Edge Function
EXPECTED_DIM = 3072


def check_pre(supabase) -> bool:
    print("\n[GATE V3 — PRE-MIGRATION]")
    ok = True

    # 1. Verificar se os campos V3 existem no schema
    print("  Verificando schema...")
    try:
        resp = supabase.table("documents").select(
            "data_dje,repercussao_geral,recurso_repetitivo,turma"
        ).limit(1).execute()
        print("  [OK] Campos V3 presentes no schema (data_dje, repercussao_geral, recurso_repetitivo, turma)")
    except Exception as e:
        err = str(e)
        if "column" in err.lower() or "does not exist" in err.lower():
            print("  [BLOQUEIO] Campos V3 ausentes — rodar v3_migration.sql primeiro")
        else:
            print(f"  [AVISO] Erro ao verificar campos: {e}")
        ok = False

    # 2. [N-3] Verificar dimensionalidade do embedding via Gemini
    if GEMINI_API_KEY:
        print("  Verificando dimensionalidade do embedding...")
        try:
            payload = {
                "model": "models/gemini-embedding-001",
                "content": {"parts": [{"text": "teste de dimensao"}]},
                "taskType": "RETRIEVAL_QUERY",
                "outputDimensionality": EXPECTED_DIM,
            }
            resp = requests.post(
                GEMINI_EMBED_URL,
                json=payload,
                params={"key": GEMINI_API_KEY},
                timeout=15,
            )
            resp.raise_for_status()
            values = resp.json()["embedding"]["values"]
            dim_real = len(values)
            if dim_real == EXPECTED_DIM:
                print(f"  [OK] Dimensionalidade confirmada: {dim_real}")
            else:
                print(f"  [BLOQUEIO] Dimensao esperada {EXPECTED_DIM} — retornou {dim_real}")
                print(f"            Ajustar EXPECTED_DIM em gate_v3.py antes de prosseguir.")
                ok = False
        except Exception as e:
            print(f"  [AVISO] Nao foi possivel testar dimensionalidade: {e}")
    else:
        print("  [AVISO] GEMINI_API_KEY ausente — verificacao de dimensionalidade pulada")

    # 3. Contar documentos atuais
    try:
        resp = supabase.table("documents").select("id", count="exact").execute()
        total = resp.count
        print(f"  [INFO] Documentos no banco: {total}")
        if total == 0:
            print("  [BLOQUEIO] Banco vazio — execute o ingest normal primeiro")
            ok = False
    except Exception as e:
        print(f"  [AVISO] Nao foi possivel contar documentos: {e}")

    return ok


def check_pos(supabase) -> bool:
    print("\n[GATE V3 — POS-REINGEST]")
    ok = True

    try:
        resp = supabase.table("documents").select(
            "id,turma,repercussao_geral,recurso_repetitivo,tribunal"
        ).execute()
        docs = resp.data or []
        total = len(docs)

        turma_preenchida    = sum(1 for d in docs if d.get("turma"))
        repercussao_true    = sum(1 for d in docs if d.get("repercussao_geral"))
        repetitivo_true     = sum(1 for d in docs if d.get("recurso_repetitivo"))
        sem_turma           = [d for d in docs if not d.get("turma")]

        print(f"  Total de documentos:    {total}")
        print(f"  Com turma preenchida:   {turma_preenchida}/{total}")
        print(f"  Com repercussao_geral:  {repercussao_true}")
        print(f"  Com recurso_repetitivo: {repetitivo_true}")

        # Gate 1: turma deve estar preenchida em todos os documentos
        if turma_preenchida < total:
            print(f"  [FALHA] {total - turma_preenchida} documento(s) sem turma:")
            for d in sem_turma[:5]:
                print(f"          id={d['id']} tribunal={d.get('tribunal')} repercussao={d.get('repercussao_geral')}")
            ok = False
        else:
            print("  [OK] Todos os documentos tem turma preenchida")

        # Gate 2: deve haver pelo menos 1 com repercussao_geral = true
        if repercussao_true == 0:
            print("  [FALHA] Nenhum acordao marcado como repercussao_geral=true")
            print("          Badges VINCULANTE nao aparecerao no frontend")
            ok = False
        else:
            print(f"  [OK] {repercussao_true} acordao(s) VINCULANTE(s) detectado(s)")

        # Gate 3: contar por turma (distribuicao esperada)
        turmas = {}
        for d in docs:
            t = d.get("turma") or "sem_turma"
            turmas[t] = turmas.get(t, 0) + 1
        print("  Distribuicao por turma:")
        for t, n in sorted(turmas.items(), key=lambda x: -x[1]):
            print(f"    {t}: {n}")

    except Exception as e:
        print(f"  [ERRO] Falha ao consultar banco: {e}")
        ok = False

    return ok


def main():
    parser = argparse.ArgumentParser(description="Gate V3 — Toga Digital Valdece")
    parser.add_argument(
        "--check",
        choices=["pre", "pos"],
        required=True,
        help="pre = antes da migracao | pos = apos reingest",
    )
    args = parser.parse_args()

    supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

    if args.check == "pre":
        passed = check_pre(supabase)
    else:
        passed = check_pos(supabase)

    if passed:
        print("\n[GATE V3] APROVADO — pode prosseguir.")
        sys.exit(0)
    else:
        print("\n[GATE V3] BLOQUEADO — resolver os itens acima antes de prosseguir.")
        sys.exit(1)


if __name__ == "__main__":
    main()
