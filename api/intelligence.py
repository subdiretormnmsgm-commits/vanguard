#!/usr/bin/env python3
"""
Vanguard V8 — Intelligence API
FastAPI Router: /v1/intelligence/

Endpoints públicos autenticados por API key (SHA-256):
  GET /v1/intelligence/nichos               — lista nichos disponíveis
  GET /v1/intelligence/nicho/{nicho}        — stats maturidade digital do nicho
  GET /v1/intelligence/tendencias           — tendências 30d (nicho+cidade)
  GET /v1/intelligence/empresa              — lookup empresa por nome
  GET /v1/intelligence/cidades              — top cidades por nicho
  GET /v1/intelligence/status               — status da key (quota, plano)

Auth: header X-Vanguard-Key: vng_live_xxxx_<token>
Rate limits: free=1000/mês, starter=5000/mês, pro=50000/mês, enterprise=ilimitado
"""

import hashlib
import logging
import time
from datetime import datetime
from typing import Optional

import httpx
from fastapi import APIRouter, Header, HTTPException, Query, Request, Response
from pydantic import BaseModel

log = logging.getLogger('vanguard-intelligence')

# Importar helpers do main (partilhados)
import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

router = APIRouter(tags=['Intelligence API v1'])

# Limites por plano (requests/mês)
LIMITES_PLANO = {
    'free':       1_000,
    'starter':    5_000,
    'pro':        50_000,
    'enterprise': 999_999_999,
}


# ─── Dependência: validar API key ─────────────────────────────────────────────

async def _resolver_api_key(
    x_vanguard_key: Optional[str],
    supabase_url: str,
    service_key: str,
    endpoint: str,
    latencia_ms: int = 0,
) -> dict:
    """Valida X-Vanguard-Key, verifica quota, regista uso. Retorna row da api_keys."""
    if not x_vanguard_key:
        raise HTTPException(
            status_code=401,
            detail='Header X-Vanguard-Key obrigatório. Obtenha a sua key em /intelligence/',
        )

    # A key tem formato: vng_live_<prefix12chars>_<token>
    parts = x_vanguard_key.split('_', 3)
    if len(parts) < 4 or parts[0] != 'vng' or parts[1] not in ('live', 'test'):
        raise HTTPException(status_code=401, detail='Formato de key inválido.')

    key_prefix = f'{parts[0]}_{parts[1]}_{parts[2]}'
    key_hash   = hashlib.sha256(x_vanguard_key.encode()).hexdigest()

    headers = {
        'apikey':        service_key,
        'Authorization': f'Bearer {service_key}',
        'Content-Type':  'application/json',
    }

    async with httpx.AsyncClient(timeout=8) as client:
        # Lookup por prefix (índice rápido) — evita scan full table
        r = await client.get(
            f'{supabase_url}/rest/v1/api_keys',
            params={'key_prefix': f'eq.{key_prefix}', 'ativo': 'eq.true'},
            headers=headers,
        )
        rows = r.json() if r.status_code == 200 else []

        if not rows:
            raise HTTPException(status_code=401, detail='API key inválida ou desactivada.')

        key_row = None
        for row in rows:
            if row['key_hash'] == key_hash:
                key_row = row
                break

        if not key_row:
            raise HTTPException(status_code=401, detail='API key inválida.')

        # Verificar expiração
        if key_row.get('expires_at'):
            if key_row['expires_at'] < datetime.utcnow().isoformat():
                raise HTTPException(status_code=401, detail='API key expirada.')

        # Verificar quota
        plano   = key_row.get('plano', 'free')
        limite  = key_row.get('limite_mes', LIMITES_PLANO.get(plano, 1000))
        usados  = key_row.get('requests_mes', 0)

        if plano != 'enterprise' and usados >= limite:
            raise HTTPException(
                status_code=429,
                detail=f'Quota esgotada: {usados}/{limite} requests este mês. '
                       f'Actualize o plano em /intelligence/',
                headers={'Retry-After': 'next-month', 'X-RateLimit-Limit': str(limite)},
            )

        # Registar uso (assíncrono — não bloqueia a resposta)
        await client.post(
            f'{supabase_url}/rest/v1/api_usage_logs',
            json={
                'key_id':      key_row['id'],
                'endpoint':    endpoint,
                'params':      {},
                'status_code': 200,
                'latencia_ms': latencia_ms,
            },
            headers={**headers, 'Prefer': 'return=minimal'},
        )

    return key_row


# ─── Factory para injectar deps do main ───────────────────────────────────────

def make_intelligence_router(supabase_url: str, service_key: str) -> APIRouter:
    """Cria o router com as dependências injectadas (SUPABASE_URL, SERVICE_KEY)."""

    sb_headers = {
        'apikey':        service_key,
        'Authorization': f'Bearer {service_key}',
        'Content-Type':  'application/json',
    }

    async def _query_view(view: str, params: dict) -> list:
        async with httpx.AsyncClient(timeout=10) as client:
            r = await client.get(
                f'{supabase_url}/rest/v1/{view}',
                params=params,
                headers=sb_headers,
            )
            if r.status_code != 200:
                raise HTTPException(502, 'Erro ao consultar dados de inteligência.')
            return r.json()

    async def _validate_key(key: Optional[str], endpoint: str) -> dict:
        t0 = int(time.time() * 1000)
        return await _resolver_api_key(key, supabase_url, service_key, endpoint,
                                       int(time.time() * 1000) - t0)

    # ─────────────────────────────────────────────────────────────────────────

    @router.get('/v1/intelligence/status')
    async def api_key_status(
        x_vanguard_key: Optional[str] = Header(None, alias='X-Vanguard-Key'),
    ):
        """Retorna estado da API key: plano, quota usada/restante, último uso."""
        key = await _validate_key(x_vanguard_key, '/v1/intelligence/status')
        plano  = key.get('plano', 'free')
        limite = key.get('limite_mes', LIMITES_PLANO.get(plano, 1000))
        usados = key.get('requests_mes', 0)
        return {
            'key_prefix':    key['key_prefix'],
            'plano':         plano,
            'requests_mes':  usados,
            'limite_mes':    limite,
            'restantes':     max(0, limite - usados),
            'pct_usado':     round(usados / max(limite, 1) * 100, 1),
            'ultimo_uso_em': key.get('ultimo_uso_em'),
            'ativo':         key.get('ativo', True),
        }

    @router.get('/v1/intelligence/nichos')
    async def listar_nichos(
        x_vanguard_key: Optional[str] = Header(None, alias='X-Vanguard-Key'),
    ):
        """Lista todos os nichos com dados disponíveis, ordenados por volume."""
        await _validate_key(x_vanguard_key, '/v1/intelligence/nichos')
        rows = await _query_view('mv_intelligence_nicho', {
            'order':  'total_leads.desc',
            'select': 'nicho,total_leads,score_medio,leads_alta_qualidade,pct_com_ia',
        })
        return {
            'nichos':     rows,
            'total':      len(rows),
            'actualizado_em': datetime.utcnow().isoformat(),
        }

    @router.get('/v1/intelligence/nicho/{nicho}')
    async def inteligencia_nicho(
        nicho: str,
        x_vanguard_key: Optional[str] = Header(None, alias='X-Vanguard-Key'),
    ):
        """
        Retorna score de maturidade digital agregado para o nicho.
        Inclui: score médio, mediana, % com IA hook, total de empresas indexadas.
        """
        await _validate_key(x_vanguard_key, f'/v1/intelligence/nicho/{nicho}')

        rows = await _query_view('mv_intelligence_nicho', {
            'nicho': f'eq.{nicho.lower()}',
            'limit': '1',
        })
        if not rows:
            raise HTTPException(404, f'Nicho "{nicho}" sem dados indexados.')

        data = rows[0]
        return {
            'nicho':               data['nicho'],
            'total_empresas':      data['total_leads'],
            'score_medio':         data['score_medio'],
            'score_mediana':       data['score_mediana'],
            'empresas_qualidade':  data['leads_alta_qualidade'],
            'pct_com_ia_hook':     data['pct_com_ia'],
            'ultimo_dado_em':      data['ultimo_lead_em'],
            'referencia_mes':      data['referencia_mes'],
            'insight': _gerar_insight_nicho(data),
        }

    @router.get('/v1/intelligence/tendencias')
    async def tendencias(
        nicho:  Optional[str] = Query(None, description='Filtrar por nicho'),
        top:    int           = Query(10, ge=1, le=50, description='Top N cidades'),
        x_vanguard_key: Optional[str] = Header(None, alias='X-Vanguard-Key'),
    ):
        """
        Tendências de prospecção digital nos últimos 30 dias por cidade/nicho.
        Útil para identificar mercados em expansão.
        """
        await _validate_key(x_vanguard_key, '/v1/intelligence/tendencias')

        params: dict = {
            'order': 'leads_30d.desc',
            'limit': str(top),
        }
        if nicho:
            params['nicho'] = f'eq.{nicho.lower()}'

        rows = await _query_view('mv_intelligence_tendencias', params)
        return {
            'tendencias':     rows,
            'total':          len(rows),
            'periodo':        'ultimos_30_dias',
            'filtro_nicho':   nicho,
            'referencia_dia': datetime.utcnow().date().isoformat(),
        }

    @router.get('/v1/intelligence/empresa')
    async def lookup_empresa(
        nome:  str = Query(..., min_length=3, description='Nome da empresa (parcial)'),
        nicho: Optional[str] = Query(None),
        x_vanguard_key: Optional[str] = Header(None, alias='X-Vanguard-Key'),
    ):
        """
        Lookup do score de maturidade digital de uma empresa específica.
        Retorna score, gargalo principal e data de indexação.
        """
        key_row = await _validate_key(x_vanguard_key, '/v1/intelligence/empresa')

        # Empresas só disponíveis para planos pagos
        if key_row.get('plano', 'free') == 'free':
            raise HTTPException(
                403,
                'Lookup de empresa requer plano Starter ou superior. '
                'Upgrade em /intelligence/',
            )

        nome_normalizado = nome.lower().strip()
        params: dict = {
            'nome_normalizado': f'ilike.*{nome_normalizado}*',
            'limit':            '5',
            'select':           'nome_normalizado,nicho,cidade,score_digital,gargalo_principal,indexado_em',
        }
        if nicho:
            params['nicho'] = f'eq.{nicho.lower()}'

        rows = await _query_view('mv_intelligence_empresas', params)

        if not rows:
            return {
                'encontrado': False,
                'query':      nome,
                'resultados': [],
                'mensagem':   'Empresa não encontrada na base de dados indexados.',
            }

        return {
            'encontrado': True,
            'query':      nome,
            'resultados': rows,
            'total':      len(rows),
        }

    @router.get('/v1/intelligence/cidades')
    async def top_cidades(
        nicho: str = Query(..., description='Nicho a analisar'),
        top:   int = Query(10, ge=1, le=30),
        x_vanguard_key: Optional[str] = Header(None, alias='X-Vanguard-Key'),
    ):
        """
        Top cidades com maior actividade de prospecção digital no nicho.
        Útil para decisões de expansão geográfica.
        """
        await _validate_key(x_vanguard_key, '/v1/intelligence/cidades')

        rows = await _query_view('mv_intelligence_tendencias', {
            'nicho':  f'eq.{nicho.lower()}',
            'order':  'leads_30d.desc',
            'limit':  str(top),
            'select': 'cidade,leads_30d,score_medio',
        })

        return {
            'nicho':   nicho,
            'cidades': rows,
            'total':   len(rows),
            'periodo': 'ultimos_30_dias',
        }

    return router


# ─── Insight generator ────────────────────────────────────────────────────────

def _gerar_insight_nicho(data: dict) -> str:
    """Gera insight textual automático baseado nos dados do nicho."""
    score   = float(data.get('score_medio') or 0)
    pct_ia  = float(data.get('pct_com_ia') or 0)
    total   = int(data.get('total_leads') or 0)
    qualidade = int(data.get('leads_alta_qualidade') or 0)
    pct_qual  = round(qualidade / max(total, 1) * 100, 1)

    partes = []
    if score < 4:
        partes.append(
            f'Nicho com maturidade digital baixa (score médio {score}/10) — '
            f'alta oportunidade de captação com proposta de presença digital.'
        )
    elif score < 7:
        partes.append(
            f'Maturidade digital moderada ({score}/10) — '
            f'segmento competitivo mas com espaço para diferenciação.'
        )
    else:
        partes.append(
            f'Nicho maduro digitalmente ({score}/10) — '
            f'foco em qualidade de serviço e especialização.'
        )

    if pct_ia > 60:
        partes.append(f'{pct_ia}% das empresas indexadas têm hook IA gerado.')
    if pct_qual > 20:
        partes.append(f'{pct_qual}% das empresas classificadas como alta qualidade (score ≥7).')

    return ' '.join(partes) if partes else 'Dados insuficientes para insight automático.'
