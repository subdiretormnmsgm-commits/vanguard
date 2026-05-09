#!/usr/bin/env python3
"""
Scraper Vanguard — Engenheiro de Dados Outbound V5 (Soberano Digital)
Minera leads B2B, audita presença digital com IA e injeta no Supabase Cockpit.

Modos de operação:
  --modo demo    : gera leads sintéticos realistas (teste sem API keys)
  --modo osm     : OpenStreetMap Overpass API (gratuito, sem ToS violados)
  --modo places  : Google Places API (requer GOOGLE_PLACES_API_KEY em .env)

Uso:
  python scraper_vanguard.py --nicho advocacia --cidade "São Paulo" --modo demo
  python scraper_vanguard.py --nicho estetica  --cidade "Rio de Janeiro" --modo osm
"""

import argparse
import json
import os
import random
import sys
import time
import urllib.parse
import urllib.request
from datetime import datetime
from pathlib import Path

import requests
from bs4 import BeautifulSoup
from dotenv import load_dotenv

load_dotenv()

if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

# ─── Disponibilidade opcional: anthropic ──────────────────────────────────────
try:
    import anthropic as _anthropic_lib
    _ANTHROPIC_AVAILABLE = True
except ImportError:
    _anthropic_lib = None
    _ANTHROPIC_AVAILABLE = False

# ─── Configuração ─────────────────────────────────────────────────────────────
SUPABASE_URL      = os.getenv('SUPABASE_URL', 'https://ehyaecxqijgyuuiorzcj.supabase.co')
SUPABASE_ANON_KEY = os.getenv('SUPABASE_ANON_KEY', '')
GOOGLE_API_KEY    = os.getenv('GOOGLE_PLACES_API_KEY', '')
ANTHROPIC_API_KEY = os.getenv('ANTHROPIC_API_KEY', '')
QUIZ_URL          = os.getenv('VANGUARD_QUIZ_URL', 'https://vanguardtech.com/#quiz')

OUTPUT_DIR = Path('outbound')

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                  '(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
    'Accept-Language': 'pt-BR,pt;q=0.9',
}

# ─── Mapeamentos ──────────────────────────────────────────────────────────────
NICHO_MAP = {
    'advocacia':    {'supabase': 'Consultoria',  'osm': 'office=lawyer',       'places': 'lawyer'},
    'estetica':     {'supabase': 'Saúde',        'osm': 'shop=beauty',         'places': 'beauty_salon'},
    'clinica':      {'supabase': 'Saúde',        'osm': 'amenity=clinic',      'places': 'doctor'},
    'dentista':     {'supabase': 'Saúde',        'osm': 'amenity=dentist',     'places': 'dentist'},
    'contabilidade':{'supabase': 'Finanças',     'osm': 'office=accountant',   'places': 'accounting'},
    'imobiliaria':  {'supabase': 'Imobiliário',  'osm': 'office=estate_agent', 'places': 'real_estate_agency'},
    'farmacia':     {'supabase': 'Saúde',        'osm': 'amenity=pharmacy',    'places': 'pharmacy'},
    'restaurante':  {'supabase': 'E-commerce',   'osm': 'amenity=restaurant',  'places': 'restaurant'},
}

GARGALO_BY_SCORE = {
    range(8, 11): 'Dependência de ferramentas de terceiros',
    range(5, 8):  'Falta de visibilidade sobre métricas do negócio',
    range(2, 5):  'Captação e retenção de clientes',
    range(0, 2):  'Processos manuais que consomem tempo',
}


# ─── Feature 01: Auditor IA (Claude Haiku) ────────────────────────────────────

class AuditorIA:
    """
    Usa Claude Haiku para analisar o HTML do site prospectado e gerar:
    - gargalos_ia: lista de gargalos específicos identificados no site
    - hook_personalizado: mensagem WhatsApp personalizada para o lead
    """

    _PROMPT = """\
Analisa o site desta empresa como especialista em marketing digital B2B.
Responde APENAS com JSON válido, sem markdown, sem texto extra.

Empresa : {nome}
Nicho   : {nicho}
Score   : {score}/10 (10 = presença digital crítica, 0 = excelente)
HTML do site (primeiros 5000 chars):
---
{html}
---

JSON esperado:
{{
  "gargalos_ia": [
    "gargalo específico e concreto identificado no site",
    "segundo gargalo específico identificado"
  ],
  "hook_personalizado": "Mensagem WhatsApp de 2-3 frases, personalizada para esta empresa específica, mencionando um problema real encontrado no site. Tom consultivo, não vendedor."
}}"""

    def __init__(self) -> None:
        self.enabled = bool(ANTHROPIC_API_KEY) and _ANTHROPIC_AVAILABLE
        self._client = None

        if not _ANTHROPIC_AVAILABLE:
            print('  ○ anthropic não instalado (pip install anthropic) — hooks por template.')
            return
        if not ANTHROPIC_API_KEY:
            print('  ○ ANTHROPIC_API_KEY não definida — hooks por template.')
            return

        self._client = _anthropic_lib.Anthropic(api_key=ANTHROPIC_API_KEY)
        print('  ✓ Claude Haiku · Auditor IA V5 activado')

    def auditar(self, nome: str, nicho: str, html: str, score: int) -> dict:
        """Retorna dict com 'gargalos_ia' e 'hook_personalizado', ou {} se indisponível."""
        if not self.enabled or not html:
            return {}

        prompt = self._PROMPT.format(
            nome=nome,
            nicho=nicho,
            score=score,
            html=html[:5000],
        )

        try:
            msg = self._client.messages.create(
                model='claude-haiku-4-5-20251001',
                max_tokens=512,
                messages=[{'role': 'user', 'content': prompt}],
            )
            texto = msg.content[0].text.strip()

            # Limpar markdown se o modelo o incluir
            if '```' in texto:
                partes = texto.split('```')
                for parte in partes:
                    parte = parte.lstrip('json').strip()
                    if parte.startswith('{'):
                        texto = parte
                        break

            resultado = json.loads(texto)
            return resultado

        except (json.JSONDecodeError, ValueError):
            return {}
        except Exception as ex:
            print(f'  ⚠️  AuditorIA erro: {type(ex).__name__}: {ex}')
            return {}


# ─── Auditoria de Presença Digital ───────────────────────────────────────────

class DigitalAudit:
    """Avalia a presença digital de um negócio. Score 0–10 (10 = gargalo máximo)."""

    def auditar(self, site: str | None) -> tuple[int, str, str]:
        """Retorna (score, descricao, html_raw)."""
        if not site or site.strip() == '':
            return 10, 'Sem site detectado', ''

        url = site if site.startswith('http') else f'https://{site}'
        try:
            resp = requests.get(url, headers=HEADERS, timeout=6, allow_redirects=True)
            score = self._analisar(resp, url)
            return score, self._descricao(score), resp.text
        except requests.exceptions.SSLError:
            return 7, 'Site sem HTTPS (certificado inválido)', ''
        except requests.exceptions.ConnectionError:
            return 8, 'Site fora do ar ou domínio inexistente', ''
        except requests.exceptions.Timeout:
            return 6, 'Site com tempo de resposta crítico (>6s)', ''
        except Exception:
            return 5, 'Site com erros de acesso', ''

    def _analisar(self, resp: requests.Response, url: str) -> int:
        score = 0
        soup  = BeautifulSoup(resp.text, 'lxml')

        if not url.startswith('https'):
            score += 3
        if not soup.find('meta', attrs={'name': 'description'}):
            score += 2
        if not soup.find('meta', attrs={'name': 'viewport'}):
            score += 2
        if not any(kw in resp.text for kw in ['gtag', 'fbq', 'GTM-', '_ga']):
            score += 2
        if not soup.find('meta', property='og:title'):
            score += 1

        return min(score, 10)

    def _descricao(self, score: int) -> str:
        for r, desc in GARGALO_BY_SCORE.items():
            if score in r:
                return desc
        return 'Presença digital básica'


# ─── Geração de Copy WhatsApp (fallback sem IA) ───────────────────────────────

class CopyGenerator:
    TEMPLATES = [
        "Olá, {nome}! 👋\n\nFizemos uma auditoria rápida à vossa presença digital e identificámos um gargalo importante: *{gargalo}*.\n\nEm 60 segundos podem descobrir exactamente como transformar este gargalo num activo digital:\n👉 {quiz_url}\n\n— Vanguard Tech 🚀",
        "Bom dia, {nome}! ☀️\n\nAnalisámos a vossa presença online e o vosso score digital é {score}/10 de potencial de melhoria.\n\nTemos uma solução específica para negócios de {nicho}. Façam o diagnóstico gratuito:\n👉 {quiz_url}\n\n— Vanguard Tech",
        "Olá, equipa {nome}! 🔥\n\nIdentificámos que o vosso maior gargalo actual é: *{gargalo}*.\n\nA Vanguard Tech especializa-se exactamente nisto. Descubram o plano de ataque:\n👉 {quiz_url}\n\n— Vanguard Tech 🚀",
    ]

    def gerar(self, lead: dict) -> str:
        template = random.choice(self.TEMPLATES)
        return template.format(
            nome=lead['nome'],
            nicho=lead['nicho'],
            gargalo=lead['gargalo'],
            score=lead['score_digital'],
            quiz_url=QUIZ_URL,
        )


# ─── Supabase Writer ──────────────────────────────────────────────────────────

class SupabaseWriter:
    def __init__(self):
        self.url = SUPABASE_URL
        self.key = SUPABASE_ANON_KEY

    def inserir_lead(self, lead: dict) -> bool:
        if not self.key:
            print('  ⚠️  SUPABASE_ANON_KEY não configurada — a gravar apenas localmente.')
            return False

        endpoint = f'{self.url}/rest/v1/leads_diagnostico'
        payload  = json.dumps({
            'nome':     lead['nome'],
            'whatsapp': lead.get('telefone') or 'N/D',
            'nicho':    lead['nicho'],
            'gargalo':  lead['gargalo'],
            'origem':   'scraper',
            'ai_hook':  lead.get('ai_hook', ''),
        }).encode('utf-8')

        req = urllib.request.Request(
            endpoint,
            data=payload,
            method='POST',
            headers={
                'apikey':        self.key,
                'Authorization': f'Bearer {self.key}',
                'Content-Type':  'application/json',
                'Prefer':        'return=minimal',
            }
        )
        try:
            with urllib.request.urlopen(req, timeout=10) as resp:
                return resp.status in (200, 201)
        except urllib.error.HTTPError as e:
            body = e.read().decode()
            if '23505' in body:
                return True  # Duplicado — OK
            print(f'  ✗ Erro Supabase: {e.code} — {body[:120]}')
            return False
        except Exception as ex:
            print(f'  ✗ Erro de ligação: {ex}')
            return False


# ─── Fontes de Dados ──────────────────────────────────────────────────────────

class DemoSource:
    """Gera leads sintéticos realistas para testes sem API keys."""

    DEMO_DATA = {
        'advocacia': [
            ('Escritório Mendes & Associados', '+5511998877001', 'mendesadvocacia.com.br', 'Av. Paulista, 1000, São Paulo'),
            ('Dr. Carlos Lima — Advocacia',    '+5511997654321', '',                        'Rua Augusta, 200, São Paulo'),
            ('Ferreira, Costa & Luz Advogados','+5511996543210', 'http://fcladvogados.com', 'Al. Santos, 45, São Paulo'),
            ('Advocacia Rodrigues',             '+5511995432109', '',                        'Rua da Consolação, 88'),
            ('LegalPro — Advogados Associados', '+5511994321098', 'legalpro.adv.br',         'Rua Pamplona, 145, SP'),
        ],
        'estetica': [
            ('Studio Bella Forma',              '+5521997001122', 'bellaestetica.com',       'Rua das Laranjeiras, 40, RJ'),
            ('Clínica Estética Renascer',        '+5521996112233', '',                        'Av. Atlântica, 500, RJ'),
            ('SPA Luxo & Bem-Estar',             '+5521995223344', 'spaluxo.com.br',          'Rua do Catete, 88, RJ'),
            ('Instituto Corpo & Saúde',          '+5521994334455', '',                        'Largo do Machado, 12, RJ'),
            ('Beauty Point Estética',            '+5521993445566', 'beautypoint.net',         'Rua Voluntários da Pátria, 22'),
        ],
        'clinica': [
            ('Clínica Dr. Alves — Medicina Integral', '+5531998001020', 'clinicaalves.med.br', 'Av. do Contorno, 100, BH'),
            ('Centro Médico Saúde Plena',              '+5531997002030', '',                     'Rua da Bahia, 250, BH'),
            ('Policlínica Minas Gerais',               '+5531996003040', 'polimg.com.br',         'Rua Espírito Santo, 800'),
            ('Saúde+Plus Clínica',                     '+5531995004050', '',                     'Av. Afonso Pena, 300, BH'),
            ('Instituto de Medicina Avançada',          '+5531994005060', 'imamedico.com.br',     'Al. das Acácias, 55, BH'),
        ],
    }

    def buscar(self, nicho: str, cidade: str, limite: int) -> list[dict]:
        dados = self.DEMO_DATA.get(nicho, self.DEMO_DATA['advocacia'])
        return [
            {'nome': d[0], 'telefone': d[1], 'site': d[2], 'endereco': d[3], 'fonte': 'demo'}
            for d in dados[:limite]
        ]


class OSMSource:
    """OpenStreetMap Overpass API — gratuito e sem violação de ToS."""

    OVERPASS_URLS = [
        'https://overpass-api.de/api/interpreter',
        'https://overpass.kumi.systems/api/interpreter',
    ]

    CITY_COORDS: dict[str, tuple[float, float, int]] = {
        'são paulo':      (-23.5505, -46.6333, 15000),
        'rio de janeiro': (-22.9068, -43.1729, 15000),
        'curitiba':       (-25.4284, -49.2733, 12000),
        'belo horizonte': (-19.9191, -43.9386, 12000),
        'porto alegre':   (-30.0346, -51.2177, 12000),
        'brasília':       (-15.7801, -47.9292, 15000),
        'salvador':       (-12.9714, -38.5014, 12000),
        'fortaleza':      (-3.7172,  -38.5433, 12000),
        'recife':         (-8.0476,  -34.8770, 12000),
        'manaus':         (-3.1190,  -60.0217, 12000),
    }

    def buscar(self, nicho: str, cidade: str, limite: int) -> list[dict]:
        mapa    = NICHO_MAP.get(nicho, {})
        osm_tag = mapa.get('osm', 'amenity=clinic')
        key, val = osm_tag.split('=')

        coords = self.CITY_COORDS.get(cidade.lower(), (-23.5505, -46.6333, 15000))
        lat, lon, raio = coords

        query = (
            f'[out:json][timeout:25];'
            f'(node["{key}"="{val}"](around:{raio},{lat},{lon});'
            f'way["{key}"="{val}"](around:{raio},{lat},{lon}););'
            f'out body {limite};'
        )

        print(f'  → Consultando OpenStreetMap para {nicho} em {cidade}...')
        for url in self.OVERPASS_URLS:
            try:
                resp = requests.post(
                    url, data={'data': query}, headers=HEADERS, timeout=30
                )
                resp.raise_for_status()
                elementos = resp.json().get('elements', [])
                print(f'     OK via {url.split("/")[2]}')
                return [self._parse(e) for e in elementos if e.get('tags')]
            except Exception as ex:
                print(f'     ✗ {url.split("/")[2]}: {ex}')
        print('  ⚠️  Todos os servidores OSM indisponíveis. Use --modo demo.')
        return []

    def _parse(self, el: dict) -> dict:
        tags = el.get('tags', {})
        return {
            'nome':     tags.get('name', tags.get('brand', 'Empresa sem nome')),
            'telefone': tags.get('phone', tags.get('contact:phone', '')),
            'site':     tags.get('website', tags.get('contact:website', '')),
            'endereco': f"{tags.get('addr:street', '')} {tags.get('addr:housenumber', '')}".strip(),
            'fonte':    'osm',
        }


class PlacesSource:
    """Google Places API — dados ricos, requer API key."""

    BASE = 'https://maps.googleapis.com/maps/api/place'

    def buscar(self, nicho: str, cidade: str, limite: int) -> list[dict]:
        if not GOOGLE_API_KEY:
            print('  ✗ GOOGLE_PLACES_API_KEY não configurada em .env')
            return []

        mapa    = NICHO_MAP.get(nicho, {})
        query   = f'{nicho} em {cidade}'
        results = []
        token   = None

        while len(results) < limite:
            params = {'query': query, 'key': GOOGLE_API_KEY, 'language': 'pt-BR'}
            if token:
                params = {'pagetoken': token, 'key': GOOGLE_API_KEY}

            r    = requests.get(f'{self.BASE}/textsearch/json', params=params, timeout=10)
            data = r.json()

            for place in data.get('results', []):
                if len(results) >= limite:
                    break
                results.append(self._detail(place['place_id']))
                time.sleep(0.3)

            token = data.get('next_page_token')
            if not token:
                break
            time.sleep(2)

        return results

    def _detail(self, place_id: str) -> dict:
        fields = 'name,formatted_phone_number,website,formatted_address'
        r = requests.get(
            f'{self.BASE}/details/json',
            params={'place_id': place_id, 'fields': fields, 'key': GOOGLE_API_KEY, 'language': 'pt-BR'},
            timeout=10,
        )
        d = r.json().get('result', {})
        return {
            'nome':     d.get('name', ''),
            'telefone': d.get('formatted_phone_number', ''),
            'site':     d.get('website', ''),
            'endereco': d.get('formatted_address', ''),
            'fonte':    'google_places',
        }


# ─── Pipeline Principal ───────────────────────────────────────────────────────

def processar(
    leads_raw:  list[dict],
    nicho:      str,
    auditor:    DigitalAudit,
    copy_gen:   CopyGenerator,
    writer:     SupabaseWriter,
    auditor_ia: AuditorIA | None = None,
) -> list[dict]:
    mapa     = NICHO_MAP.get(nicho, {'supabase': 'Consultoria'})
    nicho_sb = mapa['supabase']
    results  = []

    for i, raw in enumerate(leads_raw, 1):
        nome = raw.get('nome', 'Empresa').strip() or 'Empresa sem nome'
        print(f'  [{i}/{len(leads_raw)}] {nome}')

        # Auditoria técnica — retorna HTML para o Auditor IA
        score_digital, descricao_gargalo, html_site = auditor.auditar(raw.get('site', ''))
        gargalo = _score_to_gargalo(score_digital)

        lead = {
            'nome':          nome,
            'telefone':      raw.get('telefone', 'N/D'),
            'site':          raw.get('site', ''),
            'endereco':      raw.get('endereco', ''),
            'nicho':         nicho_sb,
            'score_digital': score_digital,
            'gargalo':       gargalo,
            'auditoria':     descricao_gargalo,
            'fonte':         raw.get('fonte', 'manual'),
            'ai_hook':       '',
            'ai_gargalos':   [],
        }

        # Feature 01: Auditor IA — hook personalizado por Claude Haiku
        if auditor_ia and auditor_ia.enabled:
            ia_result = auditor_ia.auditar(nome, nicho_sb, html_site, score_digital)
            if ia_result:
                lead['ai_hook']     = ia_result.get('hook_personalizado', '')
                lead['ai_gargalos'] = ia_result.get('gargalos_ia', [])
                if lead['ai_hook']:
                    print(f'      🧠 Hook IA: {lead["ai_hook"][:70]}...')

        # Copy WhatsApp (usa ai_hook se disponível, senão template)
        lead['wa_copy'] = lead['ai_hook'] if lead['ai_hook'] else copy_gen.gerar(lead)

        # Injectar no Supabase
        ok = writer.inserir_lead(lead)
        lead['supabase_ok'] = ok
        status = '✓ Supabase' if ok else '○ Local'
        ia_tag = ' 🧠IA' if lead['ai_hook'] else ''
        print(f'      {status} · Score {score_digital}/10 · {gargalo[:35]}{ia_tag}')

        results.append(lead)

        if i < len(leads_raw):
            time.sleep(random.uniform(0.8, 1.8))

    return results


def _score_to_gargalo(score: int) -> str:
    for r, desc in GARGALO_BY_SCORE.items():
        if score in r:
            return desc
    return 'Processos manuais que consomem tempo'


def exportar(leads: list[dict], nicho: str, cidade: str) -> Path:
    OUTPUT_DIR.mkdir(exist_ok=True)
    ts       = datetime.now().strftime('%Y%m%d_%H%M')
    ficheiro = OUTPUT_DIR / f'{nicho}_{cidade.replace(" ", "_")}_{ts}.md'

    linhas = [
        f'# Outbound Vanguard V5 — {nicho.title()} / {cidade}',
        f'> Gerado em {datetime.now().strftime("%Y-%m-%d %H:%M")} · {len(leads)} leads · Claude Haiku Auditor',
        '', '---', '',
    ]

    for i, l in enumerate(leads, 1):
        status_sb = '✓ Supabase' if l.get('supabase_ok') else '○ Local'
        ia_badge  = ' · 🧠 Hook IA' if l.get('ai_hook') else ''
        score_bar = '█' * l['score_digital'] + '░' * (10 - l['score_digital'])
        linhas += [
            f'## {i}. {l["nome"]}',
            f'- **Telefone:** {l["telefone"]}',
            f'- **Site:** {l["site"] or "—"}',
            f'- **Endereço:** {l["endereco"] or "—"}',
            f'- **Score Digital:** `{score_bar}` {l["score_digital"]}/10',
            f'- **Gargalo:** {l["gargalo"]}',
            f'- **Auditoria:** {l["auditoria"]}',
            f'- **Status:** {status_sb}{ia_badge}',
            '',
        ]

        if l.get('ai_gargalos'):
            linhas.append('### Gargalos IA (Claude Haiku)')
            for g in l['ai_gargalos']:
                linhas.append(f'- {g}')
            linhas.append('')

        linhas += [
            '### Copy WhatsApp',
            '```',
            l['wa_copy'],
            '```',
            '',
        ]

    ficheiro.write_text('\n'.join(linhas), encoding='utf-8')
    return ficheiro


def resumo(leads: list[dict]) -> None:
    total     = len(leads)
    criticos  = [l for l in leads if l['score_digital'] >= 8]
    medios    = [l for l in leads if 4 <= l['score_digital'] < 8]
    bons      = [l for l in leads if l['score_digital'] < 4]
    injetados = [l for l in leads if l.get('supabase_ok')]
    com_ia    = [l for l in leads if l.get('ai_hook')]

    sep = '─' * 55
    print(f'\n{sep}')
    print(f'RESUMO FINAL V5 · {datetime.now().strftime("%Y-%m-%d %H:%M")}')
    print(sep)
    print(f'  Total processados      : {total}')
    print(f'  🔴 Críticos (≥8/10)    : {len(criticos)}  ← atacar primeiro')
    print(f'  🟡 Médios   (4-7/10)   : {len(medios)}')
    print(f'  🟢 Bons     (<4/10)    : {len(bons)}')
    print(f'  ✓  Injectados Supabase : {len(injetados)}')
    print(f'  🧠 Hooks por IA Haiku  : {len(com_ia)}')
    print(sep)

    if criticos:
        print('\n🔴 LEADS CRÍTICOS (ATACAR AGORA):')
        for l in sorted(criticos, key=lambda x: x['score_digital'], reverse=True):
            ia = ' 🧠' if l.get('ai_hook') else ''
            print(f'  • {l["nome"]} — Score {l["score_digital"]}/10 — {l["telefone"]}{ia}')


# ─── CLI ──────────────────────────────────────────────────────────────────────

def main() -> None:
    parser = argparse.ArgumentParser(
        description='Scraper Vanguard V5 — Soberano Digital (Auditor IA + Claude Haiku)'
    )
    parser.add_argument('--nicho',  default='advocacia', choices=list(NICHO_MAP.keys()))
    parser.add_argument('--cidade', default='São Paulo')
    parser.add_argument('--limite', type=int, default=5)
    parser.add_argument('--modo',   default='demo', choices=['demo', 'osm', 'places'])
    parser.add_argument('--sem-ia', action='store_true', help='Desactivar Auditor IA (mais rápido)')
    args = parser.parse_args()

    print('╔══════════════════════════════════════════════════════╗')
    print('║  Scraper Vanguard V5 — Soberano Digital              ║')
    print('╚══════════════════════════════════════════════════════╝')
    print(f'  Nicho  : {args.nicho}')
    print(f'  Cidade : {args.cidade}')
    print(f'  Limite : {args.limite}')
    print(f'  Modo   : {args.modo}')
    print()

    fontes    = {'demo': DemoSource, 'osm': OSMSource, 'places': PlacesSource}
    fonte     = fontes[args.modo]()

    print('1/4 · A extrair leads...')
    leads_raw = fonte.buscar(args.nicho, args.cidade, args.limite)

    if not leads_raw:
        print('Nenhum lead encontrado. Tente --modo demo para testar.')
        sys.exit(1)
    print(f'     {len(leads_raw)} leads encontrados.\n')

    print('2/4 · A inicializar motores de auditoria...')
    auditor    = DigitalAudit()
    copy_gen   = CopyGenerator()
    writer     = SupabaseWriter()
    auditor_ia = None if args.sem_ia else AuditorIA()
    print()

    print('3/4 · A auditar presença digital + IA...')
    leads = processar(leads_raw, args.nicho, auditor, copy_gen, writer, auditor_ia)

    print(f'\n4/4 · A exportar relatório Markdown...')
    ficheiro = exportar(leads, args.nicho, args.cidade)
    print(f'     Relatório: {ficheiro}')

    resumo(leads)


if __name__ == '__main__':
    main()
