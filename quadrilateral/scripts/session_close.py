#!/usr/bin/env python3
"""
SESSION CLOSE — Ritual obrigatório de fechamento do Quadrilateral IAH

Substitui o session_close.ps1 por versão Python que roda em qualquer OS.

O que faz em 30 segundos:
1. Pergunta sobre fricções, princípios e overrides da sessão
2. Registra tudo via API do LEDGER (ou diretamente no arquivo se API offline)
3. Gera INTELLIGENCE_LEDGER.md atualizado
4. Exibe resumo do estado do Conselho

Por que isso importa (P-005):
"Inteligência acumula por sessão, não por versão.
 Sessão sem ritual = memória perdida para sempre."

Uso:
  python scripts/session_close.py
  python scripts/session_close.py --sessao "V25-cliente-onboarding" --projeto "vanguard"
  python scripts/session_close.py --silencioso  # usa defaults, sem perguntas interativas
"""

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

# Tenta importar via API local; fallback para operação standalone
try:
    import httpx
    API_URL = "http://localhost:8765"
    _api_disponivel = None  # lazy check
except ImportError:
    httpx = None
    _api_disponivel = False


def api_disponivel() -> bool:
    global _api_disponivel
    if _api_disponivel is None and httpx:
        try:
            r = httpx.get(f"{API_URL}/status", timeout=2)
            _api_disponivel = r.status_code == 200
        except Exception:
            _api_disponivel = False
    return bool(_api_disponivel)


def registrar_via_api(endpoint: str, dados: dict) -> bool:
    if not api_disponivel() or not httpx:
        return False
    try:
        r = httpx.post(f"{API_URL}/{endpoint}", json=dados, timeout=10)
        return r.status_code == 200
    except Exception:
        return False


def registrar_standalone(dados: dict, tipo: str) -> None:
    """Fallback: escreve diretamente no ledger_state.json."""
    path = Path("ledger_state.json")
    state = {}
    if path.exists():
        try:
            state = json.loads(path.read_text())
        except Exception:
            pass

    if tipo == "friccao":
        fricoes = state.get("fricoes", [])
        dados["id"] = f"F-{len(fricoes) + 1:03d}"
        fricoes.append(dados)
        state["fricoes"] = fricoes
    elif tipo == "principio":
        principios = state.get("principios", [])
        dados["id"] = f"P-{len(principios) + 1:03d}"
        dados["ativo"] = True
        dados["overrides"] = []
        principios.append(dados)
        state["principios"] = principios

    path.write_text(json.dumps(state, indent=2, ensure_ascii=False), encoding='utf-8')


def perguntar(prompt: str, default: str = "") -> str:
    try:
        resp = input(f"{prompt} [{default}]: ").strip()
        return resp if resp else default
    except (EOFError, KeyboardInterrupt):
        return default


def coletar_sessao_interativo(sessao: str, projeto: str) -> dict:
    print("\n" + "═" * 55)
    print("  QUADRILATERAL IAH — RITUAL DE FECHAMENTO")
    print("═" * 55)
    print(f"  Sessão : {sessao}")
    print(f"  Projeto: {projeto}")
    print("═" * 55)
    print("\nResponda em 1-2 linhas. Enter para pular.\n")

    dados = {
        "sessao": sessao,
        "projeto": projeto,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "fricoes": [],
        "principios": [],
        "overrides": [],
    }

    # Fricções
    print("── FRICÇÕES (instruções que causaram problema ou desvio) ──")
    while True:
        f = perguntar("Fricção ocorreu? (descreva ou Enter para pular)", "")
        if not f:
            break
        tipo = perguntar("Tipo", "ALUCINACAO_TECNICA")
        fonte = perguntar("Fonte (quem emitiu)", "Estrategista")
        acao = perguntar("Ação tomada", "")
        principio = perguntar("Princípio gerado (P-XXX ou deixe em branco)", "")
        dados["fricoes"].append({
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "sessao": sessao,
            "tipo": tipo,
            "fonte": fonte,
            "instrucao_original": f,
            "problema_detectado": f,
            "acao_tomada": acao,
            "principio_gerado": principio or None,
            "severidade": "MEDIUM",
        })
        mais = perguntar("Mais uma fricção? (s/n)", "n")
        if mais.lower() != "s":
            break

    # Princípios
    print("\n── PRINCÍPIOS (regras que emergiram de decisões desta sessão) ──")
    while True:
        p = perguntar("Princípio novo? (descreva ou Enter para pular)", "")
        if not p:
            break
        dados["principios"].append({
            "descricao": p,
            "origem": f"{projeto}-{sessao}",
            "data": datetime.now(timezone.utc).date().isoformat(),
        })
        mais = perguntar("Mais um princípio? (s/n)", "n")
        if mais.lower() != "s":
            break

    # Overrides
    print("\n── OVERRIDES (vetos superados pelo Diretor) ──")
    while True:
        o = perguntar("Override ocorreu? (descreva ou Enter para pular)", "")
        if not o:
            break
        dados["overrides"].append({
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "sessao": sessao,
            "tipo": "OVERRIDE_DIRETOR",
            "fonte": "Diretor",
            "instrucao_original": o,
            "problema_detectado": "Override pelo Diretor",
            "acao_tomada": "Executado com risco documentado",
            "principio_gerado": None,
            "severidade": "MEDIUM",
        })
        mais = perguntar("Mais um override? (s/n)", "n")
        if mais.lower() != "s":
            break

    return dados


def executar_fechamento(sessao: str, projeto: str, silencioso: bool = False) -> None:
    if silencioso:
        dados = {
            "sessao": sessao,
            "projeto": projeto,
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "fricoes": [],
            "principios": [],
            "overrides": [],
        }
    else:
        dados = coletar_sessao_interativo(sessao, projeto)

    registrados = {"fricoes": 0, "principios": 0}

    # Registrar fricções
    for f in dados["fricoes"]:
        ok = registrar_via_api("ledger/friccao", f)
        if not ok:
            registrar_standalone(f, "friccao")
        registrados["fricoes"] += 1

    # Registrar overrides como fricções tipo OVERRIDE_DIRETOR
    for o in dados["overrides"]:
        ok = registrar_via_api("ledger/friccao", o)
        if not ok:
            registrar_standalone(o, "friccao")
        registrados["fricoes"] += 1

    # Registrar princípios
    for p in dados["principios"]:
        ok = registrar_via_api("ledger/principio", p)
        if not ok:
            registrar_standalone(p, "principio")
        registrados["principios"] += 1

    # Incrementar sessão via API ou standalone
    ok_sessao = registrar_via_api("sessao/iniciar", {"nome": sessao, "projeto": projeto})
    if not ok_sessao:
        ledger_path = Path("ledger_state.json")
        if ledger_path.exists():
            try:
                raw = json.loads(ledger_path.read_text())
                raw["sessoes_count"] = raw.get("sessoes_count", 0) + 1
                raw["ultima_sessao"] = sessao
                ledger_path.write_text(json.dumps(raw, indent=2, ensure_ascii=False), encoding='utf-8')
            except Exception:
                pass

    # Exportar LEDGER atualizado
    ledger_md = None
    if api_disponivel() and httpx:
        try:
            r = httpx.get(f"{API_URL}/ledger/exportar", timeout=10)
            if r.status_code == 200:
                ledger_md = r.text
        except Exception:
            pass

    if ledger_md:
        Path("INTELLIGENCE_LEDGER.md").write_text(ledger_md, encoding='utf-8')
        print("\n✅ INTELLIGENCE_LEDGER.md atualizado automaticamente")
    else:
        print("\n⚠️  API offline — LEDGER não exportado. Rode a API e execute novamente.")

    # Resumo
    print("\n" + "═" * 55)
    print("  SESSÃO FECHADA")
    print("═" * 55)
    print(f"  Fricções registradas : {registrados['fricoes']}")
    print(f"  Princípios novos     : {registrados['principios']}")
    print(f"  API ativa            : {'✅' if api_disponivel() else '❌ (operação standalone)'}")
    print("═" * 55)
    print("\nPróximos passos:")
    print("  1. Commitar ledger_state.json e INTELLIGENCE_LEDGER.md")
    print("  2. Levar o relatorio_evolutivo ao Gemini (PASSO3)")
    print("  3. O loop recomeça mais inteligente do que abriu.")
    print()


def main():
    parser = argparse.ArgumentParser(description="Ritual de fechamento do Quadrilateral IAH")
    parser.add_argument("--sessao", default="", help="Nome da sessão (ex: V25-cliente-onboarding)")
    parser.add_argument("--projeto", default="vanguard", help="Nome do projeto")
    parser.add_argument("--silencioso", action="store_true", help="Sem perguntas interativas")
    args = parser.parse_args()

    sessao = args.sessao or f"sessao-{datetime.now(timezone.utc).strftime('%Y%m%d-%H%M')}"
    executar_fechamento(sessao=sessao, projeto=args.projeto, silencioso=args.silencioso)


if __name__ == "__main__":
    main()
