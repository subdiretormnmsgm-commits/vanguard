#!/usr/bin/env python3
"""
Shadow Closer Lite — Vanguard Tech V2
Lead Scoring Engine: calcula Score de Urgência e gera diagnósticos personalizados.

Uso:
    SUPABASE_URL=https://... SUPABASE_ANON_KEY=eyJ... python shadow_closer_v2.py
"""

import os
import sys
import json
import urllib.request
from datetime import datetime
from pathlib import Path

# ─── Configuração ─────────────────────────────────────────────────────────────
SUPABASE_URL      = os.environ.get('SUPABASE_URL', 'https://ehyaecxqijgyuuiorzcj.supabase.co')
SUPABASE_ANON_KEY = os.environ.get('SUPABASE_ANON_KEY', '')
OUTPUT_DIR        = Path('diagnosticos')
VIP_THRESHOLD     = 75

# ─── Tabelas de Score ─────────────────────────────────────────────────────────
# Peso base por gargalo (0-100): calibrado pela urgência de solução e ticket médio
GARGALO_SCORES: dict[str, int] = {
    'Dificuldade em escalar a equipa':                   100,
    'Falta de visibilidade sobre métricas do negócio':    85,
    'Captação e retenção de clientes':                    80,
    'Processos manuais que consomem tempo':               70,
    'Dependência de ferramentas de terceiros':             65,
}

# Multiplicador por nicho: mercados com maior ticket médio amplificam o score
NICHO_MULTIPLIERS: dict[str, float] = {
    'Finanças':    1.00,
    'Consultoria': 0.95,
    'Tecnologia':  0.90,
    'Saúde':       0.85,
    'Imobiliário': 0.80,
    'E-commerce':  0.75,
    'Educação':    0.70,
    'Outro':       0.65,
}

# Bónus semântico: palavras-chave no texto do gargalo ajustam o score ±20
URGENCY_KEYWORDS: dict[str, int] = {
    'escal':    +10,
    'crise':    +15,
    'urgente':  +15,
    'bloqueio': +10,
    'travar':   +10,
    'perder':    +8,
    'queda':     +8,
}

# ─── Textos de Solução por Gargalo ────────────────────────────────────────────
SOLUCOES: dict[str, tuple[str, list[str]]] = {
    'Dificuldade em escalar a equipa': (
        'Sistema de Onboarding Automatizado + Base de Conhecimento Proprietária',
        [
            'Construir SOP digital com base de conhecimento proprietária',
            'Automatizar onboarding via chatbot + vídeos indexados',
            'Dashboard de performance por colaborador em tempo real',
        ]
    ),
    'Falta de visibilidade sobre métricas do negócio': (
        'Motor de BI Proprietário com Dashboard Executivo em Tempo Real',
        [
            'Integrar fontes de dados (CRM, financeiro, operações) numa API unificada',
            'Construir KPIs executivos com alertas automáticos por WhatsApp',
            'Painel de decisão visual — dados actualizados a cada 5 minutos',
        ]
    ),
    'Captação e retenção de clientes': (
        'Funil de Captação Automático + CRM com IA de Segmentação',
        [
            'Implementar Lead Scoring automático (como este script)',
            'Criar sequências de nurturing segmentadas por gargalo',
            'Painel de churn prediction por cliente com alertas precoces',
        ]
    ),
    'Processos manuais que consomem tempo': (
        'Motor de Automação de Processos com Orquestração Python',
        [
            'Mapear os 3 processos com maior consumo de horas semanais',
            'Automatizar via scripts Python + webhooks (N8N/Zapier)',
            'Painel de horas economizadas e ROI da automação por semana',
        ]
    ),
    'Dependência de ferramentas de terceiros': (
        'Stack Proprietária Modular — Zero Dependência de Terceiros',
        [
            'Auditar todas as ferramentas actuais e os seus custos mensais',
            'Construir alternativas próprias para as ferramentas críticas',
            'Eliminar 60%+ das licenças externas em 90 dias',
        ]
    ),
}

# ─── Algoritmo de Scoring ─────────────────────────────────────────────────────

def _semantic_bonus(gargalo: str) -> int:
    lower = gargalo.lower()
    total = sum(w for kw, w in URGENCY_KEYWORDS.items() if kw in lower)
    return max(-20, min(20, total))


def calcular_score(nicho: str, gargalo: str) -> dict:
    base   = GARGALO_SCORES.get(gargalo, 50)
    mult   = NICHO_MULTIPLIERS.get(nicho, 0.65)
    bonus  = _semantic_bonus(gargalo)
    score  = max(0, min(100, round(base * mult + bonus)))
    tier   = 'VIP' if score >= VIP_THRESHOLD else ('QUENTE' if score >= 55 else 'FRIO')
    return {'score': score, 'vip': tier == 'VIP', 'tier': tier,
            'base': base, 'multiplicador': mult, 'bonus_semantico': bonus}

# ─── Fetch Leads (REST directo, sem dependência externa) ──────────────────────

def fetch_leads() -> list:
    if not SUPABASE_ANON_KEY:
        print('ERRO: defina SUPABASE_ANON_KEY como variável de ambiente.')
        sys.exit(1)
    url = f'{SUPABASE_URL}/rest/v1/leads_diagnostico?select=*&order=created_at.desc'
    req = urllib.request.Request(url, headers={
        'apikey':        SUPABASE_ANON_KEY,
        'Authorization': f'Bearer {SUPABASE_ANON_KEY}',
    })
    with urllib.request.urlopen(req, timeout=15) as resp:
        return json.loads(resp.read().decode())

# ─── Geração de Diagnóstico em Markdown ───────────────────────────────────────

def _barra(score: int) -> str:
    filled = int(score / 10)
    return '█' * filled + '░' * (10 - filled)


def gerar_diagnostico(lead: dict, s: dict) -> str:
    nome    = lead['nome']
    nicho   = lead['nicho']
    gargalo = lead['gargalo']
    wa      = lead['whatsapp']
    data    = lead['created_at'][:10]
    score   = s['score']
    flag    = {'VIP': '🔴 PRIORIDADE VIP', 'QUENTE': '🟡 LEAD QUENTE', 'FRIO': '🔵 LEAD FRIO'}[s['tier']]
    solucao, acoes = SOLUCOES.get(gargalo, ('Consultoria Estratégica Personalizada', ['Agendar sessão de diagnóstico aprofundado']))
    acoes_md = '\n'.join(f'{i+1}. {a}' for i, a in enumerate(acoes))

    return f"""# Diagnóstico Vanguard Tech — {nome}
> Shadow Closer Lite · gerado em {datetime.now().strftime('%Y-%m-%d %H:%M')}

---

## Perfil
| Campo        | Valor |
|--------------|-------|
| **Nome**     | {nome} |
| **Nicho**    | {nicho} |
| **Gargalo**  | {gargalo} |
| **WhatsApp** | {wa} |
| **Data**     | {data} |

---

## Score de Urgência
```
{_barra(score)}  {score}/100
```
**Classificação:** {flag}

| Componente            | Valor |
|-----------------------|-------|
| Base (gargalo)        | {s['base']} |
| Multiplicador (nicho) | ×{s['multiplicador']} |
| Bónus semântico       | +{s['bonus_semantico']} |
| **Score Final**       | **{score}** |

---

## Solução Recomendada
**{solucao}**

### Plano de Ataque — 90 Dias
{acoes_md}

---

## Mensagem Shadow Closer (WhatsApp)
```
Olá {nome}! 👋

Analisei o seu diagnóstico Vanguard e o seu score de urgência é {score}/100.

O seu maior gargalo em {nicho}: *{gargalo}*

A nossa solução: *{solucao}*

Posso mostrar como implementar isto no seu negócio em 15 minutos.
Quando tem disponibilidade esta semana?

— Vanguard Tech 🚀
```

---
*Shadow Closer Lite · Vanguard Tech V2 · Algoritmo proprietário de scoring*
"""

# ─── Main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    if sys.platform == 'win32':
        sys.stdout.reconfigure(encoding='utf-8')

    print('Shadow Closer Lite — Vanguard Tech V2')
    print('=' * 45)

    leads = fetch_leads()
    print(f'Leads carregados: {len(leads)}')

    if not leads:
        print('Nenhum lead encontrado. Execute o quiz e tente novamente.')
        return

    OUTPUT_DIR.mkdir(exist_ok=True)
    resultados = []

    for lead in leads:
        s  = calcular_score(lead['nicho'], lead['gargalo'])
        md = gerar_diagnostico(lead, s)
        slug    = ''.join(c if c.isalnum() else '_' for c in lead['nome'].lower())[:30]
        ficheiro = OUTPUT_DIR / f"{slug}_{lead['id'][:8]}.md"
        ficheiro.write_text(md, encoding='utf-8')
        resultados.append({**s, 'nome': lead['nome'], 'nicho': lead['nicho'],
                           'gargalo': lead['gargalo'], 'ficheiro': str(ficheiro)})

    vips    = [r for r in resultados if r['vip']]
    quentes = [r for r in resultados if r['tier'] == 'QUENTE']
    frios   = [r for r in resultados if r['tier'] == 'FRIO']

    sep = '─' * 45
    print(f'\n{sep}')
    print(f'RELATÓRIO · {datetime.now().strftime("%Y-%m-%d %H:%M")}')
    print(sep)
    print(f'  Total processados  : {len(resultados)}')
    print(f'  🔴 VIP (≥75)       : {len(vips)}')
    print(f'  🟡 Quentes (55-74) : {len(quentes)}')
    print(f'  🔵 Frios (<55)     : {len(frios)}')
    print(sep)

    if vips:
        print('\n🔴 LEADS VIP — CONTACTAR AGORA:')
        for v in sorted(vips, key=lambda x: x['score'], reverse=True):
            print(f'  • {v["nome"]} ({v["nicho"]}) — Score: {v["score"]}')

    print(f'\nDiagnósticos em: {OUTPUT_DIR}/')


if __name__ == '__main__':
    main()
