"""
IAH Factory — Calculadora de Precificação + Pesquisa de Mercado
Quadrilateral Vanguard Tech | Uso interno do Diretor

Modo de uso:
  python scripts/calculadora_precificacao.py
  python scripts/calculadora_precificacao.py --json     (exporta JSON na raiz)
  python scripts/calculadora_precificacao.py --rapido   (sem wizard, via args)
"""

import argparse
import io
import json
import math
import os
import sys
from datetime import datetime

# Força UTF-8 no terminal Windows
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

# ─────────────────────────────────────────────
# DADOS DE MERCADO BRASILEIRO (actualização: 2025)
# Fontes: Glassdoor BR, Workana, 99freelas, surveys de agências digitais SP/RJ
# ─────────────────────────────────────────────
MERCADO = {
    "landing_page": {
        "nome": "Landing Page / Funil",
        "freela_min": 800,   "freela_max": 5000,
        "agencia_min": 3000, "agencia_max": 15000,
        "horas_ref": 20,
        "camada_ref": 1,
    },
    "site_institucional": {
        "nome": "Site Institucional",
        "freela_min": 2000,  "freela_max": 8000,
        "agencia_min": 5000, "agencia_max": 25000,
        "horas_ref": 35,
        "camada_ref": 1,
    },
    "ecommerce": {
        "nome": "E-commerce",
        "freela_min": 3000,  "freela_max": 15000,
        "agencia_min": 8000, "agencia_max": 45000,
        "horas_ref": 60,
        "camada_ref": 2,
    },
    "agendamento": {
        "nome": "Sistema de Agendamento",
        "freela_min": 4000,  "freela_max": 18000,
        "agencia_min": 10000, "agencia_max": 50000,
        "horas_ref": 50,
        "camada_ref": 2,
    },
    "automacao": {
        "nome": "Automação / Integração (n8n, Zapier, API)",
        "freela_min": 1500,  "freela_max": 10000,
        "agencia_min": 5000, "agencia_max": 30000,
        "horas_ref": 30,
        "camada_ref": 2,
    },
    "crm_interno": {
        "nome": "Sistema Interno / CRM / ERP",
        "freela_min": 8000,  "freela_max": 40000,
        "agencia_min": 20000, "agencia_max": 100000,
        "horas_ref": 100,
        "camada_ref": 3,
    },
    "saas_mvp": {
        "nome": "SaaS MVP / Plataforma Web",
        "freela_min": 12000, "freela_max": 60000,
        "agencia_min": 30000, "agencia_max": 150000,
        "horas_ref": 120,
        "camada_ref": 3,
    },
    "app_mobile": {
        "nome": "App Mobile (iOS + Android)",
        "freela_min": 15000, "freela_max": 60000,
        "agencia_min": 35000, "agencia_max": 180000,
        "horas_ref": 150,
        "camada_ref": 3,
    },
    "marketplace": {
        "nome": "Marketplace / Plataforma Multi-Tenant",
        "freela_min": 25000, "freela_max": 100000,
        "agencia_min": 60000, "agencia_max": 300000,
        "horas_ref": 200,
        "camada_ref": 4,
    },
    "outro": {
        "nome": "Projecto Personalizado",
        "freela_min": 3000,  "freela_max": 30000,
        "agencia_min": 10000, "agencia_max": 80000,
        "horas_ref": 60,
        "camada_ref": 2,
    },
}

RETAINER_MERCADO = {
    1: {"freela_min": 200,  "freela_max": 800,  "agencia_min": 500,  "agencia_max": 2000},
    2: {"freela_min": 500,  "freela_max": 2000, "agencia_min": 1500, "agencia_max": 4000},
    3: {"freela_min": 1500, "freela_max": 5000, "agencia_min": 3000, "agencia_max": 8000},
    4: {"freela_min": 3000, "freela_max": 10000,"agencia_min": 5000, "agencia_max": 15000},
}

# Factor de camada: % da receita mensal do cliente que o produto vale
FATOR_CAMADA = {1: 0.20, 2: 0.35, 3: 0.50, 4: 0.75}
MINIMO_CAMADA = {1: 1200, 2: 4000, 3: 12000, 4: 35000}
RETAINER_MINIMO = {1: 250, 2: 600, 3: 1500, 4: 3500}

FATOR_URGENCIA = {
    "exploratório": 0.85,
    "normal":       1.00,
    "urgente":      1.25,
    "critico":      1.50,
}

CUSTO_HORA_INTERNO = 60.0   # R$/h (custo-oportunidade do Diretor)

# ─────────────────────────────────────────────
# HELPERS DE TERMINAL
# ─────────────────────────────────────────────
CYAN  = "\033[96m"
GOLD  = "\033[93m"
GREEN = "\033[92m"
RED   = "\033[91m"
BOLD  = "\033[1m"
DIM   = "\033[2m"
RESET = "\033[0m"

SEP = "-" * 55

def c(text, cor): return f"{cor}{text}{RESET}"
def titulo(t):    print(f"\n{BOLD}{CYAN}{SEP}{RESET}\n{BOLD}{CYAN}  {t}{RESET}\n{BOLD}{CYAN}{SEP}{RESET}")
def secao(t):     print(f"\n{BOLD}{GOLD}>> {t}{RESET}")
def linha():      print(f"{DIM}{SEP}{RESET}")
def ok(t):        print(f"  {GREEN}[OK]{RESET}  {t}")
def alerta(t):    print(f"  {GOLD}[!]{RESET}   {t}")
def erro(t):      print(f"  {RED}[X]{RESET}   {t}")

def moeda(v): return f"R${v:,.0f}".replace(",", "X").replace(".", ",").replace("X", ".")

def pergunta(prompt, opcoes=None, default=None):
    if opcoes:
        for i, op in enumerate(opcoes, 1):
            print(f"  {DIM}[{i}]{RESET} {op}")
    sufixo = f" [{default}]" if default else ""
    resp = input(f"  {GOLD}→{RESET} {prompt}{sufixo}: ").strip()
    if not resp and default:
        return default
    if opcoes:
        try:
            idx = int(resp) - 1
            if 0 <= idx < len(opcoes):
                return opcoes[idx]
        except ValueError:
            pass
        return resp
    return resp

def num(prompt, default=None):
    sufixo = f" [{default}]" if default else ""
    while True:
        resp = input(f"  {GOLD}→{RESET} {prompt}{sufixo}: ").strip()
        if not resp and default is not None:
            return float(default)
        try:
            v = float(resp.replace(".", "").replace(",", ".").replace("R$", "").replace(" ", ""))
            if v >= 0:
                return v
        except ValueError:
            pass
        print(f"  {RED}Digite um número válido.{RESET}")

# ─────────────────────────────────────────────
# MOTOR DE CÁLCULO
# ─────────────────────────────────────────────
def calcular(tipo, camada, ticket_medio, volume_mensal, urgencia, horas_estimadas, nome_cliente=""):
    info = MERCADO.get(tipo, MERCADO["outro"])
    receita_mensal = ticket_medio * volume_mensal

    # Preço base: % da receita mensal, respeitando o mínimo da camada
    valor_base = max(receita_mensal * FATOR_CAMADA[camada], MINIMO_CAMADA[camada])

    # Ajuste de urgência
    fator_urg = FATOR_URGENCIA.get(urgencia, 1.0)
    opcao_a = math.ceil(valor_base * fator_urg / 100) * 100  # arredonda p/ cima nos R$100

    # Opção B: 50% entrada + retainer
    entrada_b = math.ceil(opcao_a * 0.50 / 100) * 100
    retainer_mensal = max(
        receita_mensal * 0.05,
        RETAINER_MINIMO[camada]
    )
    retainer_mensal = math.ceil(retainer_mensal / 50) * 50

    # ROI e payback
    roi_12m = (receita_mensal * 12) / opcao_a if opcao_a > 0 else 0
    payback_meses = opcao_a / receita_mensal if receita_mensal > 0 else 99

    # Custo interno e margem
    custo_build = horas_estimadas * CUSTO_HORA_INTERNO
    margem_bruta = opcao_a - custo_build
    margem_pct = (margem_bruta / opcao_a * 100) if opcao_a > 0 else 0

    # Mercado para comparação
    freela_medio = (info["freela_min"] + info["freela_max"]) / 2
    agencia_medio = (info["agencia_min"] + info["agencia_max"]) / 2
    delta_freela = ((opcao_a / freela_medio) - 1) * 100 if freela_medio > 0 else 0
    delta_agencia = ((opcao_a / agencia_medio) - 1) * 100 if agencia_medio > 0 else 0

    ret_mercado = RETAINER_MERCADO[camada]
    ret_freela_medio = (ret_mercado["freela_min"] + ret_mercado["freela_max"]) / 2
    ret_agencia_medio = (ret_mercado["agencia_min"] + ret_mercado["agencia_max"]) / 2

    return {
        "cliente": nome_cliente,
        "tipo": info["nome"],
        "camada": camada,
        "urgencia": urgencia,
        "receita_mensal_cliente": receita_mensal,
        "opcao_a": opcao_a,
        "opcao_b_entrada": entrada_b,
        "retainer_mensal": retainer_mensal,
        "opcao_b_total_12m": entrada_b + retainer_mensal * 12,
        "roi_12m": roi_12m,
        "payback_meses": round(payback_meses, 1),
        "custo_build_interno": custo_build,
        "margem_bruta": margem_bruta,
        "margem_pct": margem_pct,
        "mercado": {
            "tipo": info["nome"],
            "freela_min": info["freela_min"],
            "freela_max": info["freela_max"],
            "freela_medio": freela_medio,
            "agencia_min": info["agencia_min"],
            "agencia_max": info["agencia_max"],
            "agencia_medio": agencia_medio,
            "nossa_vs_freela_pct": delta_freela,
            "nossa_vs_agencia_pct": delta_agencia,
            "retainer_freela_medio": ret_freela_medio,
            "retainer_agencia_medio": ret_agencia_medio,
        },
        "horas_estimadas": horas_estimadas,
        "gerado_em": datetime.now().isoformat(),
    }

# ─────────────────────────────────────────────
# DISPLAY DE RESULTADOS
# ─────────────────────────────────────────────
def exibir(r):
    titulo("IAH FACTORY — CALCULADORA DE PRECIFICAÇÃO")

    if r["cliente"]:
        print(f"  {BOLD}Cliente:{RESET} {r['cliente']}")
    print(f"  {BOLD}Projecto:{RESET} {r['tipo']} (Camada {r['camada']})")
    print(f"  {BOLD}Urgência:{RESET} {r['urgencia'].capitalize()}")
    print(f"  {BOLD}Receita mensal do cliente:{RESET} {moeda(r['receita_mensal_cliente'])}/mês")

    # ── PROPOSTA ──────────────────────────────
    secao("PROPOSTA COMERCIAL")
    linha()
    print(f"  {BOLD}OPÇÃO A — Pagamento Único{RESET}")
    print(f"    Valor total:   {c(moeda(r['opcao_a']), BOLD + GREEN)}")
    linha()
    print(f"  {BOLD}OPÇÃO B — Entrada + Retainer{RESET}")
    print(f"    Entrada (50%): {c(moeda(r['opcao_b_entrada']), GOLD)}")
    print(f"    Retainer:      {c(moeda(r['retainer_mensal']) + '/mês', GOLD)}")
    print(f"    Total 12 meses:{c(moeda(r['opcao_b_total_12m']), DIM)}")

    # ── ROI DO CLIENTE ─────────────────────────
    secao("ROI DO CLIENTE (argumento de venda)")
    roi = r["roi_12m"]
    pb  = r["payback_meses"]
    cor_roi = GREEN if roi >= 3 else (GOLD if roi >= 1.5 else RED)
    print(f"    ROI em 12 meses:  {c(f'{roi:.1f}×', BOLD + cor_roi)}")
    print(f"    Payback:          {c(f'{pb} meses', cor_roi)}")
    if roi >= 3:
        ok("ROI excelente — use como alavanca principal da proposta")
    elif roi >= 1.5:
        alerta("ROI razoável — enfatize diferenciais e urgência")
    else:
        alerta("ROI fraco — reveja camada ou volume. Cliente pode hesitar.")

    # ── MARGEM INTERNA ─────────────────────────
    secao("SAÚDE DO PROJECTO (interno)")
    mb   = r["margem_bruta"]
    mpct = r["margem_pct"]
    cor_m = GREEN if mpct >= 60 else (GOLD if mpct >= 35 else RED)
    print(f"    Custo interno:    {moeda(r['custo_build_interno'])} ({r['horas_estimadas']}h × R${CUSTO_HORA_INTERNO:.0f}/h)")
    print(f"    Margem bruta:     {c(moeda(mb), cor_m)}  ({c(f'{mpct:.0f}%', BOLD + cor_m)})")
    if mpct < 35:
        erro("Margem abaixo do limite. Aumente o preço ou reduza horas.")
    elif mpct < 60:
        alerta("Margem aceitável. Considere reduzir horas ou aumentar ticket.")
    else:
        ok("Margem saudável. Projecto aprovado pela IAH Factory.")

    # ── PESQUISA DE MERCADO ────────────────────
    m = r["mercado"]
    secao("PESQUISA DE MERCADO BRASILEIRO")
    linha()
    print(f"  Tipo de projecto: {BOLD}{m['tipo']}{RESET}")
    print()
    print(f"  {'':30s}  {'MIN':>10}  {'MÉDIO':>10}  {'MAX':>10}")
    print(f"  {'Freelancer BR':30s}  {moeda(m['freela_min']):>10}  {moeda(m['freela_medio']):>10}  {moeda(m['freela_max']):>10}")
    print(f"  {'Agência Digital BR':30s}  {moeda(m['agencia_min']):>10}  {moeda(m['agencia_medio']):>10}  {moeda(m['agencia_max']):>10}")
    print(f"  {'IAH Factory (nossa proposta)':30s}  {'':>10}  {c(moeda(r['opcao_a']), BOLD + CYAN):>10}  {'':>10}")
    linha()

    opcao_a   = r["opcao_a"]
    freela_min = m["freela_min"]
    freela_med = m["freela_medio"]
    agencia_min = m["agencia_min"]
    agencia_med = m["agencia_medio"]

    # Posição relativa ao mercado
    if opcao_a < freela_min:
        pos_freela = c(f"abaixo do piso freelancer ({moeda(freela_min)}) — recomendado ajustar para {moeda(freela_min)}", RED)
        ajuste_sugerido = freela_min
    elif opcao_a < freela_med:
        pos_freela = c(f"dentro da faixa freelancer ({moeda(freela_min)}–{moeda(m['freela_max'])}) — competitivo", GREEN)
        ajuste_sugerido = None
    elif opcao_a < agencia_min:
        pos_freela = c(f"+{((opcao_a/freela_med)-1)*100:.0f}% vs freelancer médio — posição premium-freelancer", GREEN)
        ajuste_sugerido = None
    else:
        pos_freela = c(f"acima do piso de agência — território enterprise, justifique entregas", GOLD)
        ajuste_sugerido = None

    if opcao_a < agencia_min:
        pos_agencia = c(f"-{((1-(opcao_a/agencia_med))*100):.0f}% vs agência média — argumento de preço forte", GREEN)
    elif opcao_a < agencia_med:
        pos_agencia = c(f"dentro da faixa de agência — sólido, sem necessidade de justificativa extra", GREEN)
    else:
        pos_agencia = c(f"+{((opcao_a/agencia_med)-1)*100:.0f}% vs agência média — alto valor, prepare dossier de ROI", GOLD)

    print(f"  Posicao vs freelancer:  {pos_freela}")
    print(f"  Posicao vs agencia:     {pos_agencia}")

    if ajuste_sugerido:
        margem_ajustada = (ajuste_sugerido - r["custo_build_interno"]) / ajuste_sugerido * 100
        print()
        alerta("Preco calculado por ROI esta abaixo do piso de mercado.")
        print(f"       Sugestao: eleve a Opcao A para {c(moeda(ajuste_sugerido), BOLD + GOLD)} (minimo freelancer).")
        print(f"       Isso mantem margem de {c(f'{margem_ajustada:.0f}%', GOLD)} e evita desvalorizacao.")

    # Retainer mercado
    print()
    print(f"  Retainer de mercado: freelancer {moeda(m['retainer_freela_medio'])}/mês | agência {moeda(m['retainer_agencia_medio'])}/mês")
    print(f"  Nosso retainer:      {c(moeda(r['retainer_mensal']) + '/mês', CYAN)}")

    # ── SCRIPT DE VENDA ───────────────────────
    secao("SCRIPT DE VENDA (30 segundos)")
    linha()
    print(f"""
  \"A sua empresa fatura {moeda(r['receita_mensal_cliente'])}/mês.
  Com este sistema, o custo é {moeda(r['opcao_a'])} — valor único.
  Em {r['payback_meses']} meses o projecto se paga sozinho,
  e no primeiro ano o seu ROI é de {r['roi_12m']:.1f}×.

  Uma agência cobraria entre {moeda(m['agencia_min'])} e {moeda(m['agencia_max'])}.
  Um freelancer cobraria entre {moeda(m['freela_min'])} e {moeda(m['freela_max'])} — sem garantia de entrega.
  Nós entregamos com contrato, playbook de operação e suporte incluído.\"
""")

    titulo("FIM DA ANÁLISE")
    print(f"  Gerado em: {r['gerado_em'][:16].replace('T', ' às ')}\n")

# ─────────────────────────────────────────────
# WIZARD INTERACTIVO
# ─────────────────────────────────────────────
def wizard():
    titulo("IAH FACTORY — CALCULADORA DE PRECIFICAÇÃO")
    print(f"  {DIM}Responda às perguntas abaixo para gerar a proposta e a pesquisa de mercado.{RESET}\n")

    nome_cliente = input(f"  {GOLD}→{RESET} Nome do cliente (opcional): ").strip()

    secao("TIPO DE PROJECTO")
    tipos_lista = list(MERCADO.keys())
    for i, k in enumerate(tipos_lista, 1):
        horas = MERCADO[k]['horas_ref']
        print(f"  {DIM}[{i:2d}]{RESET}  {MERCADO[k]['nome']:40s}  {DIM}~{horas}h{RESET}")
    tipo_idx = num("Escolha o número do tipo de projecto", default=1)
    tipo = tipos_lista[int(tipo_idx) - 1] if 1 <= tipo_idx <= len(tipos_lista) else "outro"

    secao("CAMADA DE COMPLEXIDADE")
    camadas = [
        "Camada 1 — Estático / Vitrine (HTML, landing, site simples)",
        "Camada 2 — Dinâmico / Transaccional (DB, CRM, agendamento, ecommerce)",
        "Camada 3 — Plataforma / SaaS (multi-tenant, integrações complexas, app)",
        "Camada 4 — Enterprise / Ecossistema (marketplace, infra própria, IA nativa)",
    ]
    camada = int(num("Camada [1-4]", default=MERCADO[tipo]["camada_ref"]))
    camada = max(1, min(4, camada))

    secao("DADOS DO NEGÓCIO DO CLIENTE")
    ticket_medio  = num("Ticket médio por venda/serviço (R$)", default=300)
    volume_mensal = num("Clientes ou transacções por mês (actual ou esperado)", default=20)

    secao("URGÊNCIA")
    urgencias = list(FATOR_URGENCIA.keys())
    for i, u in enumerate(urgencias, 1):
        f = FATOR_URGENCIA[u]
        sufixo = f"(×{f:.2f})" if f != 1 else "(base)"
        print(f"  {DIM}[{i}]{RESET}  {u.capitalize():20s}  {DIM}{sufixo}{RESET}")
    urg_idx = int(num("Urgência [1-4]", default=2))
    urgencia = urgencias[urg_idx - 1] if 1 <= urg_idx <= 4 else "normal"

    secao("ESTIMATIVA INTERNA")
    horas_ref = MERCADO[tipo]["horas_ref"]
    horas = int(num(f"Horas estimadas de build", default=horas_ref))

    return calcular(tipo, camada, ticket_medio, volume_mensal, urgencia, horas, nome_cliente)

# ─────────────────────────────────────────────
# ENTRY POINT
# ─────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(description="IAH Factory — Calculadora de Precificação")
    parser.add_argument("--json", action="store_true", help="Exportar resultado como JSON")
    parser.add_argument("--rapido", action="store_true", help="Modo não-interactivo (usa defaults)")
    args = parser.parse_args()

    try:
        resultado = wizard()
    except (KeyboardInterrupt, EOFError):
        print(f"\n\n  {DIM}Calculadora encerrada pelo utilizador.{RESET}\n")
        sys.exit(0)

    exibir(resultado)

    if args.json or input(f"\n  {GOLD}→{RESET} Exportar JSON para proposta? [s/N]: ").strip().lower() == "s":
        ts = datetime.now().strftime("%Y%m%d_%H%M")
        cliente_slug = resultado["cliente"].lower().replace(" ", "_")[:20] if resultado["cliente"] else "proposta"
        fname = f"proposta_{cliente_slug}_{ts}.json"
        with open(fname, "w", encoding="utf-8") as f:
            json.dump(resultado, f, ensure_ascii=False, indent=2)
        print(f"\n  {GREEN}✔{RESET}  JSON exportado: {BOLD}{fname}{RESET}")
        print(f"  {DIM}Cole os valores na PROPOSTA_COMERCIAL_TEMPLATE.md{RESET}\n")

if __name__ == "__main__":
    main()
