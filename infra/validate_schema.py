#!/usr/bin/env python3
"""Validacao estatica do schema.sql — sem conexao ao Supabase."""

import re
import sys
from pathlib import Path

REQUIRED_COLUMNS = {
    "id":         r"uuid",
    "nome":       r"text",
    "whatsapp":   r"text",
    "nicho":      r"text",
    "gargalo":    r"text",
    "created_at": r"timestamptz",
    "origem":     r"text",
}
REQUIRED_RLS    = "ENABLE ROW LEVEL SECURITY"
REQUIRED_POLICY = "anon_insert_only"

def validate():
    if sys.platform == 'win32':
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')

    path = Path(__file__).parent / "schema.sql"
    if not path.exists():
        print("❌ schema.sql não encontrado"); sys.exit(1)

    content = path.read_text(encoding="utf-8")
    errors = []

    for col, type_pat in REQUIRED_COLUMNS.items():
        if not re.search(rf"\b{col}\b\s+{type_pat}", content, re.IGNORECASE):
            errors.append(f"  Coluna ausente ou tipo errado: {col} ({type_pat})")

    if REQUIRED_RLS not in content:
        errors.append(f"  RLS não activado: {REQUIRED_RLS}")

    if REQUIRED_POLICY not in content:
        errors.append(f"  Política RLS ausente: {REQUIRED_POLICY}")

    if errors:
        print("❌ Erros no schema:")
        print("\n".join(errors))
        sys.exit(1)

    print("✅ Schema válido — colunas, RLS e política verificados.")

if __name__ == "__main__":
    validate()
