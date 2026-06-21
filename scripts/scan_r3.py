#!/usr/bin/env python3
# scan_r3.py - Gate R-3: varre conteudo externo por linguagem interna proibida.
# Fonte unica de termos: scripts/r3_termos.json (consolida vanguard-brand-r3 + verificacao-r3-blindagem).
#
# Uso:
#   python scripts/scan_r3.py <arquivo>
#   python scripts/scan_r3.py --text "texto a verificar"
#   echo "texto" | python scripts/scan_r3.py
#   python scripts/scan_r3.py --selftest
#
# Exit codes:
#   0 = R-3 OK   (nenhum termo de bloqueio/cliente; pode haver alertas a revisar)
#   1 = R-3 FAIL (termo de bloqueio ou nome de cliente -> output NAO sai)
#   2 = erro de uso / configuracao
#
# Match: palavra inteira, insensivel a acento (pega "automacao" e "automacao").
#        'IA'/'AI' sao case-sensitive (so caixa-alta isolada) p/ nao casar com "media", "associacao".
import sys, os, json, re, unicodedata

HERE = os.path.dirname(os.path.abspath(__file__))
TERMS_FILE = os.path.join(HERE, "r3_termos.json")


def strip_accents(s):
    return "".join(c for c in unicodedata.normalize("NFD", s)
                   if unicodedata.category(c) != "Mn")


def compile_term(term, case_sensitive):
    pat = r"\b" + re.escape(strip_accents(term)) + r"\b"
    return re.compile(pat, 0 if case_sensitive else re.IGNORECASE)


def find_hits(text_lines, terms, case_sensitive_set):
    hits = []
    for term in terms:
        rx = compile_term(term, term in case_sensitive_set)
        for i, line in enumerate(text_lines, 1):
            if rx.search(line):
                hits.append((term, i))
    return hits


def scan(text, cfg):
    lines = [strip_accents(l) for l in text.splitlines()] or [""]
    cs = set(cfg.get("alerta", {}).get("case_sensitive", []))
    block = find_hits(lines, cfg["bloqueio"]["termos"], cs)
    clients = find_hits(lines, cfg["clientes"]["termos"], cs)
    alerts = find_hits(lines, cfg["alerta"]["termos"], cs)
    return block, clients, alerts


def load_cfg():
    with open(TERMS_FILE, encoding="utf-8") as f:
        return json.load(f)


def selftest():
    cfg = load_cfg()
    dirty = "Usando IA avancada, o Claude analisou o cliente Valdece Contabilidade."
    clean = "Nossa equipe de especialistas auditou um escritorio contabil de medio porte."
    b, c, a = scan(dirty, cfg)
    assert b, "FALHA: deveria bloquear (Claude)"
    assert c, "FALHA: deveria pegar cliente (Valdece)"
    assert a, "FALHA: deveria alertar (IA caixa-alta)"
    b2, c2, _ = scan(clean, cfg)
    assert not b2 and not c2, "FALHA: texto limpo nao deveria bloquear"
    # 'media' nao pode disparar 'IA'
    b3, c3, a3 = scan("A media de mercado e alta.", cfg)
    assert not a3, "FALHA: 'media' nao deveria casar com 'IA'"
    print("selftest OK: dirty bloqueado, clean liberado, 'media' nao falso-positiva")
    return 0


def main():
    args = sys.argv[1:]
    if "--selftest" in args:
        return selftest()
    try:
        cfg = load_cfg()
    except Exception as e:
        print(f"[scan_r3] erro ao ler {TERMS_FILE}: {e}")
        return 2

    if "--text" in args:
        idx = args.index("--text")
        if idx + 1 >= len(args):
            print("uso: --text precisa de um argumento")
            return 2
        text = args[idx + 1]
    elif args and os.path.isfile(args[0]):
        with open(args[0], encoding="utf-8") as f:
            text = f.read()
    elif not sys.stdin.isatty():
        text = sys.stdin.read()
    else:
        print('uso: scan_r3.py <arquivo> | --text "..." | (stdin) | --selftest')
        return 2

    block, clients, alerts = scan(text, cfg)
    for term, ln in block:
        print(f"[BLOQUEIO] linha {ln}: '{term}'")
    for term, ln in clients:
        print(f"[CLIENTE]  linha {ln}: '{term}' (isolamento P-059)")
    for term, ln in alerts:
        print(f"[ALERTA]   linha {ln}: '{term}' (ambiguo - Diretor decide)")

    if block or clients:
        print("R-3 FAIL -- output nao sai.")
        return 1
    print("R-3 OK" + (" (com alertas a revisar)" if alerts else ""))
    return 0


if __name__ == "__main__":
    sys.exit(main())
