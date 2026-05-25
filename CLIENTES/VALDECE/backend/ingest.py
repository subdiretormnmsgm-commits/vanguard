"""
Corpus Pipeline — V3 (Dia 6)
STF + STJ Open Data → Filtro Penal → tema classification → Gemini embedding-004 → Supabase pgvector

Modos:
  python ingest.py --source all --limit 300          ← ingesta novos acórdãos
  python ingest.py --mode reingest --dry-run          ← valida classificação V3 dos 61 existentes
  python ingest.py --mode reingest                    ← aplica campos V3 no Supabase (sem re-embedding)
  python ingest.py --source csv --file acordaos.csv --limit 500
"""

import argparse
import json
import os
import re
import sys
import time
from pathlib import Path

import urllib3
import requests
from dotenv import load_dotenv
from supabase import create_client

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

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
            resp = requests.post(STF_SEARCH_URL, json=payload, timeout=15, verify=False)
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

    # Endpoint alternativo do STJ Open Data
    STJ_OPEN_DATA_URL = "https://dadosabertos.stj.jus.br/api/3/action/datastore_search"
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
            resp = requests.get(STJ_OPEN_DATA_URL, params=params, timeout=15, verify=False)
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
                verify=False,
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
# Classificação V3: turma, repercussão geral, recurso repetitivo
# Estratégia: API fonte (dado oficial) → regex → Gemini Flash
# ──────────────────────────────────────────────────────────────

def _norm_numero(s: str) -> str:
    """Normaliza número do processo: remove espaços, pontos, traços e barras."""
    return re.sub(r'[\s.\-/]', '', s).upper()


def _lookup_stf(numero: str) -> dict:
    """Busca metadados completos do caso na API do STF por número do processo."""
    try:
        payload = {"query": numero, "tribunal": "STF", "from": 0, "size": 5}
        resp = requests.post(STF_SEARCH_URL, json=payload, timeout=15, verify=False)
        resp.raise_for_status()
        hits = resp.json().get("hits", {}).get("hits", [])
        num_norm = _norm_numero(numero)
        for hit in hits:
            src = hit.get("_source", {})
            api_num = str(src.get("numeroAcordao") or src.get("numeroProcesso") or "")
            if _norm_numero(api_num) == num_norm or num_norm in _norm_numero(api_num):
                return src
        return hits[0].get("_source", {}) if hits else {}
    except Exception:
        return {}


def _extract_stf_v3(src: dict, ementa: str) -> dict:
    """Extrai turma e repercussão geral dos campos estruturados da API STF."""
    # Turma — campo orgaoJulgador
    org = (src.get("orgaoJulgador") or src.get("turma") or src.get("colegiado") or "").strip()
    turma = None
    org_l = org.lower()
    if "primeira" in org_l:   turma = "Primeira Turma"
    elif "segunda" in org_l:  turma = "Segunda Turma"
    elif "pleno" in org_l:    turma = "Pleno"

    # Repercussão geral — campo dedicado na API STF
    rg = src.get("repercussaoGeral") or src.get("repercussao_geral")
    repercussao = False
    if rg is not None:
        if isinstance(rg, bool):
            repercussao = rg
        elif isinstance(rg, dict):
            repercussao = bool(rg.get("possui") or rg.get("reconhecida"))
        elif isinstance(rg, str):
            repercussao = rg.lower() not in ("", "nao", "não", "false", "0", "sem repercussao")
    # Fallback: regex na ementa
    if not repercussao:
        repercussao = bool(re.search(r'repercuss[aã]o\s+geral', ementa.lower()))

    return {"turma": turma, "repercussao_geral": repercussao, "recurso_repetitivo": False}


def _lookup_stj(numero: str) -> dict:
    """Busca metadados completos do caso na API aberta do STJ por número do processo."""
    STJ_OPEN_DATA_URL = "https://dadosabertos.stj.jus.br/api/3/action/datastore_search"
    RESOURCE_ID = "b4d57ee5-e538-4f74-9b8b-0cfd4ac7a979"
    try:
        # Remove prefixo textual (REsp, HC, RHC…) para a busca numérica
        numero_digits = re.sub(r'^[A-Za-záéíóúãõ\s]+', '', numero).strip()
        params = {"resource_id": RESOURCE_ID, "q": numero_digits, "limit": 5}
        resp = requests.get(STJ_OPEN_DATA_URL, params=params, timeout=15, verify=False)
        resp.raise_for_status()
        if not resp.json().get("success"):
            return {}
        records = resp.json().get("result", {}).get("records", [])
        num_norm = _norm_numero(numero)
        for rec in records:
            api_num = str(rec.get("numero_processo") or rec.get("NUMERO_PROCESSO") or "")
            if _norm_numero(api_num) == num_norm or num_norm in _norm_numero(api_num):
                return rec
        return records[0] if records else {}
    except Exception:
        return {}


def _extract_stj_v3(rec: dict, ementa: str) -> dict:
    """Extrai turma e recurso repetitivo dos campos estruturados da API STJ."""
    TURMAS_STJ = [
        "Terceira Turma", "Quarta Turma", "Quinta Turma", "Sexta Turma",
        "Corte Especial", "Órgão Especial",
        "Primeira Seção", "Segunda Seção", "Terceira Seção",
    ]
    org = (rec.get("orgao_julgador") or rec.get("ORGAO_JULGADOR") or
           rec.get("orgaoJulgador") or "").strip()
    turma = None
    if org:
        for nome in TURMAS_STJ:
            if nome.lower() in org.lower():
                turma = nome
                break

    # Recurso repetitivo — campo dedicado ou campo tipo_recurso
    rep_raw = str(
        rec.get("recurso_repetitivo") or rec.get("RECURSO_REPETITIVO") or
        rec.get("tipo_julgamento") or rec.get("TIPO_JULGAMENTO") or ""
    )
    repetitivo = "repetitivo" in rep_raw.lower()
    # Fallback: regex na ementa
    if not repetitivo:
        repetitivo = bool(re.search(r'recurso\s+(especial\s+)?repetitivo', ementa.lower()))

    return {"turma": turma, "repercussao_geral": False, "recurso_repetitivo": repetitivo}


def _turma_via_flash(ementa: str, tribunal: str) -> str | None:
    """Fallback final: identifica a turma via Gemini Flash quando a API não retornou."""
    if tribunal == "STF":
        opcoes = "Primeira Turma, Segunda Turma, Pleno"
    else:
        opcoes = ("Terceira Turma, Quarta Turma, Quinta Turma, Sexta Turma, "
                  "Corte Especial, Órgão Especial, Primeira Seção, Segunda Seção, Terceira Seção")
    prompt = (
        f"Identifique a turma ou câmara que julgou este acórdão do {tribunal}.\n"
        f"Responda APENAS com o nome exato dentre as opções, ou 'desconhecido'.\n\n"
        f"Opções: {opcoes}\n\nEmenta: {ementa[:400]}\n\nTurma:"
    )
    try:
        payload = {
            "contents": [{"parts": [{"text": prompt}]}],
            "generationConfig": {"maxOutputTokens": 20, "temperature": 0},
        }
        resp = requests.post(
            GEMINI_FLASH_URL, json=payload,
            params={"key": GEMINI_API_KEY}, timeout=15,
        )
        resp.raise_for_status()
        result = resp.json()["candidates"][0]["content"]["parts"][0]["text"].strip()
        return None if result.lower() == "desconhecido" else result
    except Exception:
        return None


def classify_composicao(numero: str, tribunal: str) -> str:
    """
    Infere a composição colegiada pelo prefixo do número do processo.

    STF — competência originária do Pleno: AP, ADC, ADI, ADPF, RE, MS, MI, IF, ACO, EXT
    STJ — Seção: EREsp, EAREsp | demais: Turma
    Retorna 'Pleno', 'Seção' ou 'Turma'.
    """
    n = (numero or "").strip().upper()

    if tribunal == "STF":
        PLENO = ("AP ", "AP/", "ADC ", "ADI ", "ADPF ", "RE ", "RE/",
                 "MS ", "MI ", "IF ", "ACO ", "EXT ", "PPE ", "PSV ", "RG ")
        for p in PLENO:
            if n.startswith(p) or n == p.strip():
                return "Pleno"
        return "Turma"

    # STJ
    if n.startswith("ERESP ") or n.startswith("EARESP "):
        return "Seção"
    return "Turma"


def classify_v3_fields(ementa: str, tribunal: str, numero: str = "") -> dict:
    """
    Classifica campos V3.
    turma: prefixo do número (confiável) → fallback Gemini Flash.
    repercussao_geral: RE/ARE no STF → True por exigência constitucional (EC 45/2004);
                       fallback: regex na ementa.
    recurso_repetitivo: regex na ementa (dado secundário).
    """
    turma = classify_composicao(numero, tribunal)

    lower = ementa.lower()
    n_upper = numero.upper().strip()
    trib_upper = tribunal.upper()

    # RE e ARE no STF exigem repercussão geral como requisito de admissibilidade
    stf_re_prefixes = ("RE ", "RE.", "ARE ", "ARE.", "RE-", "ARE-")
    repercussao = (
        trib_upper == "STF" and any(n_upper.startswith(p) for p in stf_re_prefixes)
    )
    if not repercussao:
        repercussao = bool(re.search(r'repercuss[aã]o\s+geral', lower))

    repetitivo = bool(re.search(r'recurso\s+(especial\s+)?repetitivo', lower))

    return {
        "turma":              turma,
        "repercussao_geral":  repercussao,
        "recurso_repetitivo": repetitivo,
        "data_dje":           None,
    }


# ──────────────────────────────────────────────────────────────
# Modo reingest: atualiza campos V3 nos documentos existentes
# ──────────────────────────────────────────────────────────────

def reingest_existing(dry_run: bool = False, auto_yes: bool = False) -> None:
    """
    Atualiza os acórdãos existentes com campos V3 sem re-embedding.
    Regex para repercussao_geral + recurso_repetitivo.
    Gemini Flash para turma.
    data_dje permanece NULL (preenchimento manual).
    """
    supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

    print("[REINGEST] Buscando documentos existentes no Supabase...")
    resp = (
        supabase.table("documents")
        .select("id,ementa,numero_acordao,tribunal")
        .execute()
    )
    docs = resp.data or []
    total = len(docs)
    print(f"[REINGEST] {total} documentos encontrados.")

    if total == 0:
        print("[REINGEST] Corpus vazio — execute o ingest normal primeiro.")
        return

    cost_est = (total * 100 / 1000) * COST_PER_1K_FLASH
    print(f"[CUSTO ESTIMADO] USD ${cost_est:.6f} (~R$ {cost_est * 5.8:.4f})")

    if not dry_run and not auto_yes:
        confirm = input("Confirmar reingestão? (s/N): ").strip().lower()
        if confirm != "s":
            print("Abortado.")
            return

    updated = skipped = errors = 0

    for i, doc in enumerate(docs):
        doc_id   = doc["id"]
        ementa   = doc.get("ementa", "")
        numero   = doc.get("numero_acordao", "?")
        tribunal = doc.get("tribunal", "?")

        if not ementa:
            skipped += 1
            continue

        v3 = classify_v3_fields(ementa, tribunal, numero)

        if dry_run:
            flags = []
            if v3["repercussao_geral"]:  flags.append("REPERCUSSÃO GERAL")
            if v3["recurso_repetitivo"]: flags.append("REPETITIVO")
            if v3["turma"]:              flags.append(f"Turma: {v3['turma']}")
            print(f"  [DRY {i+1}/{total}] {tribunal} | {numero} -> {' | '.join(flags) or '-'}")
            updated += 1
            continue

        try:
            supabase.table("documents").update(v3).eq("id", doc_id).execute()
            updated += 1
            flags = []
            if v3["repercussao_geral"]:  flags.append("VINCULANTE")
            if v3["recurso_repetitivo"]: flags.append("REPETITIVO")
            if v3["turma"]:              flags.append(v3["turma"])
            print(f"  [{i+1}/{total}] ✓ {tribunal} · {numero} [{', '.join(flags) or '—'}]")
        except Exception as e:
            errors += 1
            print(f"  [{i+1}/{total}] ✗ {numero}: {e}")

        time.sleep(0.05)

    print(f"\n[REINGEST] Concluído — atualizados: {updated} | pulados: {skipped} | erros: {errors}")


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
            # Layer A: classificar tema + campos V3 antes do embedding
            tema = classify_tema(doc["ementa"])
            v3   = classify_v3_fields(doc["ementa"], tribunal, numero)

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
                "repercussao_geral":  v3["repercussao_geral"],
                "recurso_repetitivo": v3["recurso_repetitivo"],
                "turma":    v3["turma"],
                "data_dje": None,
            }
            supabase.table("documents").insert(payload).execute()
            inserted += 1
            flags = []
            if v3["repercussao_geral"]:  flags.append("VINCULANTE")
            if v3["recurso_repetitivo"]: flags.append("REPETITIVO")
            print(f"  [{i+1}/{len(docs)}] ✓ {tribunal} · {numero} [{tema}]{' — ' + ', '.join(flags) if flags else ''}")

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
    parser.add_argument("--mode", choices=["ingest", "reingest"], default="ingest",
                        help="ingest = novos docs com embedding | reingest = atualizar campos V3 sem re-embedding")
    parser.add_argument("--source", choices=["stf", "stj", "all", "csv"], default="all",
                        help="Fonte: stf | stj | all (STF+STJ) | csv  [apenas modo ingest]")
    parser.add_argument("--file", help="Caminho do CSV (apenas quando --source=csv)")
    parser.add_argument("--limit", type=int, default=300,
                        help="Limite por fonte (default: 300)")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--yes", "-y", action="store_true", help="Auto-confirmar sem prompt interativo")
    args = parser.parse_args()

    # ── Modo reingest: atualiza campos V3 nos 61 acórdãos existentes ──
    if args.mode == "reingest":
        reingest_existing(dry_run=args.dry_run, auto_yes=args.yes)
        return

    # ── Modo ingest normal ──
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
