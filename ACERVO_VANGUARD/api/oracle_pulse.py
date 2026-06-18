"""
Vanguard V22 — Oráculo Pulse API v0.1
FastAPI Router: /api/v1/oracle/

Primeiro produto do Acto III — Bolsa de Intenção.
Agências e parceiros pagam para saber onde os leads FIRE estão aparecendo no Brasil.

Auth: API Key por cliente (oracle_api_keys table)
Pricing Early Access: R$500/mês — cobertura cresce com cada novo tenant IntentShare.
Transparência: campo tenant_coverage mostra quantos tenants contribuem para o nicho consultado.
"""

import hashlib
import logging
import os
import secrets
from datetime import datetime, timezone
from typing import Optional

import httpx
from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel

log = logging.getLogger('vanguard-oracle-pulse')

router = APIRouter(prefix='/api/v1/oracle', tags=['Oráculo Pulse API'])

SUPABASE_URL = os.getenv('SUPABASE_URL', '')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY', os.getenv('SUPABASE_ANON_KEY', ''))
ORACLE_ADMIN_KEY = os.getenv('ORACLE_ADMIN_KEY', '')  # para criar API keys

_sb_hdrs = lambda: {
    'apikey':        SUPABASE_KEY,
    'Authorization': f'Bearer {SUPABASE_KEY}',
    'Content-Type':  'application/json',
    'Prefer':        'return=representation',
}


async def _sb_get(table: str, params: dict) -> list:
    async with httpx.AsyncClient(timeout=15) as c:
        r = await c.get(f'{SUPABASE_URL}/rest/v1/{table}', params=params, headers=_sb_hdrs())
        r.raise_for_status()
        return r.json()


async def _sb_post(table: str, data: dict) -> dict:
    async with httpx.AsyncClient(timeout=15) as c:
        r = await c.post(f'{SUPABASE_URL}/rest/v1/{table}', json=data, headers=_sb_hdrs())
        r.raise_for_status()
        result = r.json()
        return result[0] if isinstance(result, list) and result else result


async def _sb_patch(table: str, filtro: str, data: dict) -> None:
    async with httpx.AsyncClient(timeout=10) as c:
        r = await c.patch(
            f'{SUPABASE_URL}/rest/v1/{table}?{filtro}', json=data,
            headers={**_sb_hdrs(), 'Prefer': 'return=minimal'},
        )
        r.raise_for_status()


async def _validar_api_key(api_key: str) -> dict:
    """Valida API key e retorna o cliente. Rejeita se expirado ou suspenso."""
    if not api_key:
        raise HTTPException(401, 'API key obrigatória. Header: X-Oracle-Key')

    key_hash = hashlib.sha256(api_key.encode()).hexdigest()
    rows = await _sb_get('oracle_api_keys', {
        'key_hash': f'eq.{key_hash}',
        'status':   'eq.active',
    })

    if not rows:
        raise HTTPException(401, 'API key inválida ou expirada.')

    cliente = rows[0]

    # Verificar expiração
    if cliente.get('expires_at'):
        expira = datetime.fromisoformat(cliente['expires_at'].replace('Z', '+00:00'))
        if expira < datetime.now(timezone.utc):
            raise HTTPException(401, 'API key expirada.')

    # Incrementar uso
    try:
        await _sb_patch('oracle_api_keys', f'key_hash=eq.{key_hash}', {
            'requests_count': cliente.get('requests_count', 0) + 1,
            'last_used_at':   datetime.now(timezone.utc).isoformat(),
        })
    except Exception:
        pass  # não-fatal

    # Registar uso para billing
    try:
        await _sb_post('oracle_usage_log', {
            'api_key_id':  cliente['id'],
            'cliente_nome': cliente.get('cliente_nome'),
        })
    except Exception:
        pass

    return cliente


# ─── Endpoints Públicos (autenticados por API key) ────────────────────────────

@router.get('/pulse')
async def pulse(
    nicho:   Optional[str] = None,
    region:  Optional[str] = None,
    semanas: int = 4,
    x_oracle_key: Optional[str] = Header(None, alias='X-Oracle-Key'),
):
    """
    Bússola de Nicho — onde os leads FIRE estão aparecendo no Brasil.

    Parâmetros:
      nicho:   filtrar por nicho (clinicas, imobiliario, educacao, ...)
      region:  filtrar por região/estado (SP, RJ, MG, ...)
      semanas: janela de tempo em semanas (máx 12)

    Retorna: densidade FIRE/HOT por nicho + tendência semanal + cobertura.
    """
    await _validar_api_key(x_oracle_key)

    semanas = min(semanas, 12)  # cap de 12 semanas

    params = {
        'week_bucket': f'gte.{_semanas_atras(semanas)}',
        'order':       'week_bucket.desc,fire_total.desc',
        'limit':       '100',
    }
    if nicho:
        params['nicho'] = f'eq.{nicho}'
    if region:
        params['geo_region'] = f'eq.{region}'

    dados = await _sb_get('intent_graph_summary', params)

    # Agregar por nicho para visão consolidada
    by_nicho: dict = {}
    for row in dados:
        n = row.get('nicho') or 'outros'
        if n not in by_nicho:
            by_nicho[n] = {
                'nicho':          n,
                'fire_total':     0,
                'hot_total':      0,
                'tenant_coverage': 0,
                'semanas_ativas': 0,
                'tendencia':      'estavel',
                'semanas':        [],
            }
        by_nicho[n]['fire_total']      += row.get('fire_total', 0)
        by_nicho[n]['hot_total']       += row.get('hot_total', 0)
        by_nicho[n]['tenant_coverage']  = max(by_nicho[n]['tenant_coverage'], row.get('tenant_count', 0))
        by_nicho[n]['semanas_ativas']  += 1
        by_nicho[n]['semanas'].append({
            'week':  row.get('week_bucket'),
            'fire':  row.get('fire_total', 0),
            'hot':   row.get('hot_total', 0),
        })

    # Calcular tendência (últimas 2 semanas vs 2 anteriores)
    for n, d in by_nicho.items():
        semanas_data = sorted(d['semanas'], key=lambda x: x['week'] or '', reverse=True)
        if len(semanas_data) >= 4:
            recente   = sum(s['fire'] for s in semanas_data[:2])
            anterior  = sum(s['fire'] for s in semanas_data[2:4])
            if anterior > 0:
                delta = (recente - anterior) / anterior
                if delta > 0.15:   d['tendencia'] = 'subindo'
                elif delta < -0.15: d['tendencia'] = 'caindo'

    nichos_ordenados = sorted(by_nicho.values(), key=lambda x: x['fire_total'], reverse=True)

    total_tenants_contribuindo = sum(
        1 for row in await _sb_get('tenants', {
            'status': 'eq.active',
            'select': 'id',
        }) or []
    )

    return {
        'consulta': {
            'nicho':   nicho,
            'region':  region,
            'semanas': semanas,
        },
        'cobertura': {
            'tenant_coverage_total': max((d.get('tenant_coverage', 0) for d in nichos_ordenados), default=0),
            'nota': (
                'Cobertura em expansão — cada novo tenant IntentShare aumenta a precisão do Oráculo.'
                if max((d.get('tenant_coverage', 0) for d in nichos_ordenados), default=0) < 10
                else 'Cobertura consolidada.'
            ),
        },
        'nichos': nichos_ordenados,
        'timestamp': datetime.now(timezone.utc).isoformat(),
    }


@router.get('/pulse/top-nichos')
async def top_nichos(
    x_oracle_key: Optional[str] = Header(None, alias='X-Oracle-Key'),
):
    """Ranking dos 5 nichos com mais actividade FIRE nas últimas 4 semanas."""
    await _validar_api_key(x_oracle_key)

    dados = await _sb_get('intent_graph_summary', {
        'week_bucket': f'gte.{_semanas_atras(4)}',
        'order':       'fire_total.desc',
        'limit':       '20',
    })

    by_nicho: dict = {}
    for row in dados:
        n = row.get('nicho') or 'outros'
        if n not in by_nicho:
            by_nicho[n] = {'nicho': n, 'fire_total': 0, 'hot_total': 0, 'tenant_count': 0}
        by_nicho[n]['fire_total']  += row.get('fire_total', 0)
        by_nicho[n]['hot_total']   += row.get('hot_total', 0)
        by_nicho[n]['tenant_count'] = max(by_nicho[n]['tenant_count'], row.get('tenant_count', 0))

    top5 = sorted(by_nicho.values(), key=lambda x: x['fire_total'], reverse=True)[:5]
    return {'top_nichos': top5, 'periodo': 'últimas 4 semanas'}


# ─── Endpoints Admin (protegidos por ORACLE_ADMIN_KEY) ───────────────────────

class CriarApiKeyReq(BaseModel):
    cliente_nome:  str
    cliente_email: str
    plano:         str = 'early_access'   # early_access | standard | enterprise
    meses_validade: int = 12


@router.post('/keys', status_code=201)
async def criar_api_key(
    req:           CriarApiKeyReq,
    authorization: Optional[str] = Header(None),
):
    """
    Cria uma API key para um novo cliente do Oráculo.
    Requer ORACLE_ADMIN_KEY no header Authorization.
    Usar quando um novo parceiro (agência) fechar o contrato.
    """
    admin_key = os.getenv('ORACLE_ADMIN_KEY', '')
    if admin_key and authorization != f'Bearer {admin_key}':
        raise HTTPException(403, 'Acesso negado. Requer ORACLE_ADMIN_KEY.')

    raw_key  = f'vg-oracle-{secrets.token_urlsafe(24)}'
    key_hash = hashlib.sha256(raw_key.encode()).hexdigest()

    from datetime import timedelta
    expires = (datetime.now(timezone.utc) + timedelta(days=req.meses_validade * 30)).isoformat()

    registro = await _sb_post('oracle_api_keys', {
        'key_hash':      key_hash,
        'cliente_nome':  req.cliente_nome,
        'cliente_email': req.cliente_email,
        'plano':         req.plano,
        'status':        'active',
        'expires_at':    expires,
        'requests_count': 0,
    })

    log.info(f'API key criada: {req.cliente_nome} — plano {req.plano}')
    return {
        'api_key':        raw_key,
        'cliente_nome':   req.cliente_nome,
        'plano':          req.plano,
        'expira_em':      expires,
        'instrucao':      'Guardar esta chave — não será exibida novamente.',
        'uso':            'Header: X-Oracle-Key: <api_key>',
        'endpoint':       'GET /api/v1/oracle/pulse?nicho=clinicas',
    }


@router.get('/keys/status')
async def status_keys(authorization: Optional[str] = Header(None)):
    """Lista todas as API keys activas (sem expor o hash)."""
    admin_key = os.getenv('ORACLE_ADMIN_KEY', '')
    if admin_key and authorization != f'Bearer {admin_key}':
        raise HTTPException(403, 'Acesso negado.')

    rows = await _sb_get('oracle_api_keys', {
        'status': 'eq.active',
        'select': 'id,cliente_nome,cliente_email,plano,requests_count,last_used_at,expires_at,created_at',
        'order':  'created_at.desc',
    })
    mrr_estimado = sum(500 for _ in rows)  # R$500/mês por cliente Early Access
    return {
        'clientes_activos': len(rows),
        'mrr_estimado_brl': mrr_estimado,
        'clientes':         rows,
    }


# ─── Utilitários ──────────────────────────────────────────────────────────────

def _semanas_atras(n: int) -> str:
    from datetime import date, timedelta
    d = date.today() - timedelta(weeks=n)
    # Arredondar para segunda-feira
    d = d - timedelta(days=d.weekday())
    return d.isoformat()
