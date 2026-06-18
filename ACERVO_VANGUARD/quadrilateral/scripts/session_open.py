#!/usr/bin/env python3
"""
SESSION OPEN — Pre-Flight Check do Quadrilateral IAH

Executa ANTES de qualquer sessão de build.
O que faz em 30 segundos:
  1. Verifica saúde da API do LEDGER
  2. Lista princípios ativos (o Músculo não opera sem eles)
  3. Exibe vetos abertos (Hard Veto = deploy bloqueado)
  4. Mostra estado da última sessão
  5. Confirma que o sistema está pronto para operar

Responde ao que o Gemini pediu no documento de auto-auditoria:
"Pre-Flight Check obrigatório antes de qualquer sessão."
A diferença: não é checklist manual — é verificação automatizada.

Uso:
  python scripts/session_open.py
  python scripts/session_open.py --projeto vanguard
  python scripts/session_open.py --silencioso  # só retorna código de saída
"""

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

try:
    import httpx
    API_URL = "http://localhost:8765"
    _api_ok = None
except ImportError:
    httpx = None
    _api_ok = False


def _checar_api() -> bool:
    global _api_ok
    if _api_ok is None and httpx:
        try:
            r = httpx.get(f"{API_URL}/status", timeout=2)
            _api_ok = r.status_code == 200
        except Exception:
            _api_ok = False
    return bool(_api_ok)


def _carregar_estado_local() -> dict:
    """Fallback: lê ledger_state.json diretamente."""
    path = Path("ledger_state.json")
    if path.exists():
        try:
            return json.loads(path.read_text())
        except Exception:
            pass
    return {}


def _get_principios() -> list[dict]:
    if _checar_api() and httpx:
        try:
            r = httpx.get(f"{API_URL}/ledger/principios", timeout=5)
            if r.status_code == 200:
                return r.json().get("principios", [])
        except Exception:
            pass
    # Fallback local
    state = _carregar_estado_local()
    return [p for p in state.get("principios", []) if p.get("ativo", True)]


def _get_status() -> dict:
    if _checar_api() and httpx:
        try:
            r = httpx.get(f"{API_URL}/status", timeout=5)
            if r.status_code == 200:
                return r.json()
        except Exception:
            pass
    # Fallback local
    state = _carregar_estado_local()
    vetos_abertos = [
        v for v in state.get("vetos_ativos", [])
        if not v.get("override_diretor")
    ]
    hard_vetos = [v for v in vetos_abertos if v.get("tipo", "").startswith("HV-")]
    return {
        "status": "bloqueado" if hard_vetos else "operacional",
        "versao": state.get("versao", "V25"),
        "sessoes_acumuladas": state.get("sessoes_count", 0),
        "ultima_sessao": state.get("ultima_sessao", "nenhuma"),
        "principios_ativos": len([p for p in state.get("principios", []) if p.get("ativo", True)]),
        "vetos_abertos": len(vetos_abertos),
        "vetos_detalhes": [f"{v.get('tipo')} · {v.get('projeto')}" for v in vetos_abertos],
    }


def _checar_decisoes_pendentes(projeto: str) -> list[str]:
    """Verifica se há DECISOES_PENDENTES.md com itens Classe B ou C abertos."""
    path = Path(f"CLIENTES/{projeto}/DECISOES_PENDENTES.md")
    if not path.exists():
        path = Path("DECISOES_PENDENTES.md")
    if not path.exists():
        return []

    pendentes = []
    for linha in path.read_text().splitlines():
        if "[B]" in linha or "[C]" in linha:
            if "✅" not in linha and "RESOLVIDO" not in linha.upper():
                pendentes.append(linha.strip())
    return pendentes


def executar_preflight(projeto: str = "vanguard", silencioso: bool = False) -> int:
    """
    Retorna 0 se sistema operacional, 1 se há Hard Veto bloqueando.
    """
    status = _get_status()
    principios = _get_principios()
    pendentes = _checar_decisoes_pendentes(projeto)
    api_ativa = _checar_api()

    if silencioso:
        return 1 if status.get("vetos_abertos", 0) > 0 else 0

    # ── Header ──────────────────────────────────────────────────────────────
    print()
    print("═" * 60)
    print("  QUADRILATERAL IAH — PRE-FLIGHT CHECK")
    print("═" * 60)
    print(f"  Projeto  : {projeto}")
    print(f"  Data     : {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}")
    print(f"  API      : {'✅ Online' if api_ativa else '⚠️  Offline (modo standalone)'}")
    print(f"  Versão   : {status.get('versao', 'N/A')}")
    print(f"  Sessões  : {status.get('sessoes_acumuladas', 0)} acumuladas")
    print(f"  Última   : {status.get('ultima_sessao', 'nenhuma')}")
    print("═" * 60)

    # ── Status geral ─────────────────────────────────────────────────────────
    sistema_status = status.get("status", "desconhecido")
    vetos_count = status.get("vetos_abertos", 0)

    if sistema_status == "operacional":
        print(f"\n  ✅ SISTEMA OPERACIONAL — sem vetos ativos")
    else:
        print(f"\n  ⛔ SISTEMA BLOQUEADO — {vetos_count} veto(s) ativo(s)")
        for detalhe in status.get("vetos_detalhes", []):
            print(f"     → {detalhe}")
        print()
        print("  Para resolver: python scripts/veto.py resolver --tipo HV-X --projeto PROJ \\")
        print("    --override 'OVERRIDE DOCUMENTADO: [motivo]. Eduardo. [data]'")

    # ── Princípios ativos ────────────────────────────────────────────────────
    print(f"\n  PRINCÍPIOS ATIVOS ({len(principios)}):")
    print("  " + "─" * 56)
    for p in principios[:10]:  # exibe máximo 10
        pid = p.get("id", "?")
        desc = p.get("descricao", "")
        # Trunca se muito longo
        if len(desc) > 65:
            desc = desc[:62] + "..."
        print(f"  {pid}: {desc}")
    if len(principios) > 10:
        print(f"  ... e mais {len(principios) - 10} princípios (ver GET /ledger/principios)")

    # ── Decisões pendentes ───────────────────────────────────────────────────
    if pendentes:
        print(f"\n  ⚠️  DECISÕES PENDENTES ({len(pendentes)} itens Classe B/C):")
        for p in pendentes[:5]:
            print(f"     → {p[:70]}")
        print("  Resolver antes de avançar para build.")

    # ── Checklist rápido ─────────────────────────────────────────────────────
    print()
    print("  CHECKLIST PRE-FLIGHT:")
    print("  " + "─" * 56)

    checks = [
        (sistema_status == "operacional", "Sem Hard Vetos ativos"),
        (len(principios) >= 10, f"Princípios carregados ({len(principios)})"),
        (not pendentes, "Sem decisões Classe B/C pendentes"),
        (api_ativa, "API do LEDGER online"),
        (status.get("ultima_sessao") != "nenhuma", "Sessão anterior registrada"),
    ]

    todos_ok = True
    for ok, descricao in checks:
        icone = "✅" if ok else "⚠️ "
        print(f"  {icone} {descricao}")
        if not ok and descricao.startswith("Sem Hard"):
            todos_ok = False

    # ── Conclusão ────────────────────────────────────────────────────────────
    print()
    if todos_ok and sistema_status == "operacional":
        print("  🚀 PRONTO PARA OPERAR")
        print("     Ative com: PROTOCOLO VANGUARD — [projeto]. Leia tudo e delibere.")
    else:
        print("  ⛔ RESOLVER ITENS ACIMA ANTES DE INICIAR O BUILD")

    print("═" * 60)
    print()

    return 0 if sistema_status == "operacional" else 1


def main():
    parser = argparse.ArgumentParser(description="Pre-Flight Check do Quadrilateral IAH")
    parser.add_argument("--projeto", default="vanguard", help="Nome do projeto")
    parser.add_argument("--silencioso", action="store_true", help="Só retorna código de saída")
    args = parser.parse_args()
    sys.exit(executar_preflight(projeto=args.projeto, silencioso=args.silencioso))


if __name__ == "__main__":
    main()
