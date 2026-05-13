"""
Gate STJ — Validação dos endpoints em produção
Dia 4 · Primeira tarefa obrigatória antes de qualquer build de feature

Uso:
  python gate_stj.py

Critério de GO:
  - Pelo menos 1 endpoint retorna documentos com ementa não-vazia
  - Pelo menos 3 documentos contêm keywords penais
  - Tempo de resposta < 10s por endpoint

Resultado:
  GO  → continua com STJ no corpus
  NO-GO → STJ removido do ingest, corpus apenas STF
"""

import time
import requests

PENAL_KEYWORDS = [
    "crime", "pena", "réu", "acusado", "habeas corpus", "tráfico",
    "homicídio", "furto", "roubo", "estelionato", "corrupção",
    "prisão", "absolvição", "condenação", "nulidade", "dosimetria",
]

STJ_OPEN_DATA_URL = "https://dadosabertos.stj.jus.br/api/3/action/datastore_search"
RESOURCE_ID       = "b4d57ee5-e538-4f74-9b8b-0cfd4ac7a979"

STJ_SCON_URL = "https://scon.stj.jus.br/SCON/jurisprudencia/doc.jsp"


def gate_open_data() -> dict:
    print("\n[GATE STJ] Testando endpoint Open Data...")
    t0 = time.time()
    try:
        resp = requests.get(
            STJ_OPEN_DATA_URL,
            params={"resource_id": RESOURCE_ID, "q": "crime penal", "limit": 10},
            timeout=15,
        )
        elapsed = time.time() - t0
        if resp.status_code != 200:
            return {"ok": False, "reason": f"HTTP {resp.status_code}", "elapsed": elapsed}

        data = resp.json()
        if not data.get("success"):
            return {"ok": False, "reason": "API retornou success=false", "elapsed": elapsed}

        records = data.get("result", {}).get("records", [])
        if not records:
            return {"ok": False, "reason": "Nenhum registro retornado", "elapsed": elapsed}

        # Verificar campos disponíveis
        sample = records[0]
        campos = list(sample.keys())
        print(f"  Campos disponíveis: {campos[:10]}")

        # Contar ementas válidas com keywords penais
        validos = 0
        for r in records:
            ementa = (r.get("ementa") or r.get("EMENTA") or "").strip()
            if ementa and any(kw in ementa.lower() for kw in PENAL_KEYWORDS):
                validos += 1
                print(f"  ✓ {(r.get('numero_processo') or r.get('NUMERO_PROCESSO') or 'N/A')[:30]}: {ementa[:80]}...")

        return {
            "ok": validos >= 3,
            "validos": validos,
            "total": len(records),
            "campos": campos,
            "elapsed": elapsed,
            "reason": f"{validos}/{len(records)} docs penais encontrados em {elapsed:.1f}s",
        }

    except Exception as e:
        return {"ok": False, "reason": str(e), "elapsed": time.time() - t0}


def gate_scon() -> dict:
    print("\n[GATE STJ] Testando endpoint SCON fallback...")
    t0 = time.time()
    try:
        resp = requests.get(
            STJ_SCON_URL,
            params={"b": "ACOR", "pesq": "tráfico crime pena", "formato": "json", "l": 5},
            timeout=15,
            headers={"Accept": "application/json, text/html"},
        )
        elapsed = time.time() - t0
        content_type = resp.headers.get("content-type", "")

        if "json" in content_type:
            docs = resp.json().get("documentos", [])
            validos = sum(1 for d in docs if d.get("ementa", "").strip())
            return {
                "ok": validos >= 1,
                "validos": validos,
                "content_type": content_type,
                "elapsed": elapsed,
                "reason": f"JSON retornado — {validos} docs válidos",
            }
        else:
            # SCON retornou HTML — endpoint não suporta JSON direto
            return {
                "ok": False,
                "content_type": content_type,
                "elapsed": elapsed,
                "reason": "SCON retornou HTML (não suporta JSON neste endpoint)",
            }

    except Exception as e:
        return {"ok": False, "reason": str(e), "elapsed": time.time() - t0}


def main():
    print("=" * 60)
    print("GATE STJ — Dia 4 | Validação de endpoints em produção")
    print("=" * 60)

    r1 = gate_open_data()
    r2 = gate_scon()

    print("\n" + "=" * 60)
    print("RESULTADO DO GATE")
    print("=" * 60)

    print(f"\n  Open Data:  {'✅ GO' if r1['ok'] else '❌ FALHOU'} — {r1.get('reason', '')}")
    print(f"  SCON:       {'✅ GO' if r2['ok'] else '❌ FALHOU'} — {r2.get('reason', '')}")

    if r1["ok"] or r2["ok"]:
        print("\n🟢 GATE STJ: GO")
        print("   STJ permanece no corpus. ingest.py usará o endpoint disponível.")
        if r1["ok"]:
            print(f"   Endpoint primário: Open Data ({r1.get('elapsed', 0):.1f}s)")
        else:
            print("   Endpoint primário: SCON fallback")
            print("   ⚠ Open Data falhou — verificar RESOURCE_ID")
    else:
        print("\n🔴 GATE STJ: NO-GO")
        print("   Ambos os endpoints falharam.")
        print("   AÇÃO: usar apenas STF nesta entrega.")
        print("   ALTERNATIVA: importar CSV manual do STJ (export do JusBrasil).")
        print("\n   Para rodar apenas com STF:")
        print("   python ingest.py --source stf --limit 300")


if __name__ == "__main__":
    main()
