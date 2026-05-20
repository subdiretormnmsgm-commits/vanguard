#!/usr/bin/env python3
"""
VETO CLI — Ativar e resolver Hard/Soft Vetos do Quadrilateral

Uso:
  # Ativar Hard Veto (bloqueia deploy)
  python scripts/veto.py ativar --tipo HV-4 --projeto vanguard --motivo "Dívida P0 ativa em api/scanner.py"
  
  # Ativar Soft Veto (warning, não bloqueia)
  python scripts/veto.py ativar --tipo SV-4 --projeto vanguard --motivo "DIRETRIZ tem 7 prioridades"
  
  # Resolver veto com override do Diretor
  python scripts/veto.py resolver --tipo HV-4 --projeto vanguard \
    --override "OVERRIDE DOCUMENTADO: aceito risco de dívida P0 pois cliente tem demo amanhã. Eduardo. 2026-05-15"
  
  # Listar vetos ativos
  python scripts/veto.py listar
"""

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path


def _carregar_state() -> dict:
    path = Path("ledger_state.json")
    if path.exists():
        return json.loads(path.read_text())
    return {"vetos_ativos": [], "principios": [], "fricoes": [], "sessoes_count": 0}


def _salvar_state(state: dict) -> None:
    Path("ledger_state.json").write_text(json.dumps(state, indent=2, ensure_ascii=False))


def cmd_ativar(args) -> None:
    state = _carregar_state()
    veto = {
        "tipo": args.tipo,
        "projeto": args.projeto,
        "motivo": args.motivo,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "override_diretor": None,
    }
    state.setdefault("vetos_ativos", []).append(veto)
    _salvar_state(state)

    eh_hard = args.tipo.startswith("HV-")
    icone = "⛔" if eh_hard else "⚠️"
    print(f"\n{icone} VETO ATIVADO")
    print(f"  Tipo    : {args.tipo}")
    print(f"  Projeto : {args.projeto}")
    print(f"  Motivo  : {args.motivo}")
    if eh_hard:
        print(f"\n  DEPLOY BLOQUEADO até override do Diretor.")
        print(f"  Para resolver:")
        print(f"    python scripts/veto.py resolver --tipo {args.tipo} --projeto {args.projeto} --override 'motivo'")


def cmd_resolver(args) -> None:
    state = _carregar_state()
    vetos = state.get("vetos_ativos", [])
    resolvido = False

    for v in vetos:
        if v["tipo"] == args.tipo and v["projeto"] == args.projeto and not v.get("override_diretor"):
            v["override_diretor"] = args.override
            resolvido = True
            break

    if not resolvido:
        print(f"❌ Veto {args.tipo} não encontrado para projeto {args.projeto}")
        sys.exit(1)

    # Contar overrides do mesmo tipo — 3 = novo princípio
    overrides_mesmo_tipo = sum(
        1 for v in vetos
        if v["tipo"] == args.tipo and v.get("override_diretor")
    )

    _salvar_state(state)
    print(f"\n✅ VETO RESOLVIDO")
    print(f"  Tipo    : {args.tipo}")
    print(f"  Override: {args.override}")

    if overrides_mesmo_tipo >= 3:
        print(f"\n⚡ ATENÇÃO: 3 overrides de {args.tipo} detectados.")
        print(f"   Isso indica padrão de comportamento recorrente.")
        print(f"   Considere adicionar um novo princípio ao LEDGER:")
        print(f"   python scripts/session_close.py")


def cmd_listar(args) -> None:
    state = _carregar_state()
    vetos = state.get("vetos_ativos", [])

    abertos = [v for v in vetos if not v.get("override_diretor")]
    resolvidos = [v for v in vetos if v.get("override_diretor")]

    print(f"\n VETOS DO QUADRILATERAL IAH")
    print("═" * 50)

    if abertos:
        print(f"\n⛔ VETOS ATIVOS ({len(abertos)}):")
        for v in abertos:
            eh_hard = v["tipo"].startswith("HV-")
            icone = "⛔" if eh_hard else "⚠️"
            print(f"  {icone} {v['tipo']} [{v['projeto']}]: {v['motivo']}")
    else:
        print("\n✅ Nenhum veto ativo — deploy liberado")

    if resolvidos and getattr(args, "todos", False):
        print(f"\n📋 VETOS RESOLVIDOS ({len(resolvidos)}):")
        for v in resolvidos:
            print(f"  ✅ {v['tipo']} [{v['projeto']}]: {v['override_diretor'][:60]}...")

    print()


def main():
    parser = argparse.ArgumentParser(description="Veto CLI — Quadrilateral IAH")
    sub = parser.add_subparsers(dest="cmd")

    # ativar
    p_ativar = sub.add_parser("ativar", help="Ativar um Hard ou Soft Veto")
    p_ativar.add_argument("--tipo", required=True, help="Ex: HV-4, SV-2")
    p_ativar.add_argument("--projeto", required=True)
    p_ativar.add_argument("--motivo", required=True)

    # resolver
    p_resolver = sub.add_parser("resolver", help="Resolver veto com override do Diretor")
    p_resolver.add_argument("--tipo", required=True)
    p_resolver.add_argument("--projeto", required=True)
    p_resolver.add_argument("--override", required=True, help="Texto do override assinado pelo Diretor")

    # listar
    p_listar = sub.add_parser("listar", help="Listar vetos ativos")
    p_listar.add_argument("--todos", action="store_true", help="Incluir vetos resolvidos")

    args = parser.parse_args()

    if args.cmd == "ativar":
        cmd_ativar(args)
    elif args.cmd == "resolver":
        cmd_resolver(args)
    elif args.cmd == "listar":
        cmd_listar(args)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
