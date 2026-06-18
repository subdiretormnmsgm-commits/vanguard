"""
Vanguard V21 — Hermes Voice Bridge
FastAPI Router: /api/hermes-trigger/

Ponte autónoma para o Hermes Voice (Vapi).
Quando maturity_score >= 9.5, o backend cria um trigger autorizado
na fila hermes_voice_triggers. O Diretor vê no Cockpit e confirma a chamada
— ou activa o modo AUTO para zero intervenção humana.

§21 Burn Rate Shield: score < 9.5 = bloqueado. Sem excepções.
"""

import logging
import os
from datetime import datetime, timezone
from typing import Optional

import httpx
from fastapi import APIRouter, BackgroundTasks, Header, HTTPException

log = logging.getLogger('vanguard-hermes-trigger')

router = APIRouter(prefix='/api/hermes-trigger', tags=['Hermes Voice Bridge'])

SUPABASE_URL = os.getenv('SUPABASE_URL', '')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY', os.getenv('SUPABASE_ANON_KEY', ''))
SCORE_THRESHOLD = 9.5  # §21 — imutável

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


async def _verificar_e_enfileirar(tenant_id: str) -> list[dict]:
    """
    Lê maturity_scores para o tenant.
    Sessões com score >= 9.5 → cria trigger autorizado se ainda não existe.
    Retorna lista de triggers criados.
    """
    scores = await _sb_get('maturity_scores', {
        'tenant_id':      f'eq.{tenant_id}',
        'maturity_score': f'gte.{SCORE_THRESHOLD}',
        'order':          'maturity_score.desc',
        'limit':          '10',
    })

    criados = []
    for s in scores:
        session_hash = s.get('session_hash', '')

        # Verificar se já existe trigger para esta sessão
        existentes = await _sb_get('hermes_voice_triggers', {
            'tenant_id':    f'eq.{tenant_id}',
            'session_hash': f'eq.{session_hash}',
            'status':       'in.(pending,authorized)',
        })
        if existentes:
            continue

        trigger = await _sb_post('hermes_voice_triggers', {
            'tenant_id':    tenant_id,
            'session_hash': session_hash,
            'maturity_score': float(s.get('maturity_score', 0)),
            'last_seen':    s.get('last_seen'),
            'status':       'pending',
            'auto_call':    False,
        })
        log.info(
            f'Trigger criado: tenant {tenant_id[:8]} '
            f'session {session_hash[:12]} score={s.get("maturity_score")}'
        )
        criados.append(trigger)

    return criados


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.post('/check/{tenant_id}')
async def verificar_tenant(tenant_id: str):
    """
    Verifica leads FIRE máximo (score >= 9.5) para um tenant
    e cria triggers autorizados na fila hermes_voice_triggers.
    """
    tenants = await _sb_get('tenants', {'id': f'eq.{tenant_id}', 'status': 'eq.active'})
    if not tenants:
        raise HTTPException(404, 'Tenant não encontrado.')

    triggers = await _verificar_e_enfileirar(tenant_id)
    return {
        'tenant_id':       tenant_id,
        'score_threshold': SCORE_THRESHOLD,
        'triggers_criados': len(triggers),
        'triggers':        triggers,
    }


@router.post('/check-all')
async def verificar_todos(
    background_tasks: BackgroundTasks,
    authorization: Optional[str] = Header(None),
):
    """
    Varre TODOS os tenants activos e enfileira triggers para score >= 9.5.
    Chamado pelo pg_cron a cada hora ou via cockpit.
    """
    cron_secret = os.getenv('CRON_SECRET', '')
    if cron_secret and authorization != f'Bearer {cron_secret}':
        raise HTTPException(401, 'Não autorizado.')

    tenants = await _sb_get('tenants', {'status': 'eq.active', 'select': 'id'})

    import asyncio
    results = await asyncio.gather(
        *[_verificar_e_enfileirar(t['id']) for t in tenants],
        return_exceptions=True,
    )

    total_triggers = sum(len(r) for r in results if isinstance(r, list))
    log.info(f'Hermes Bridge check-all: {len(tenants)} tenants, {total_triggers} triggers novos')
    return {
        'tenants_verificados': len(tenants),
        'triggers_criados':    total_triggers,
        'timestamp':           datetime.now(timezone.utc).isoformat(),
    }


@router.get('/queue/{tenant_id}')
async def fila_triggers(tenant_id: str):
    """Retorna fila de triggers pendentes para o tenant — visível no Cockpit."""
    triggers = await _sb_get('hermes_voice_triggers', {
        'tenant_id': f'eq.{tenant_id}',
        'status':    'in.(pending,authorized)',
        'order':     'maturity_score.desc',
    })
    return {
        'tenant_id': tenant_id,
        'pendentes': len([t for t in triggers if t.get('status') == 'pending']),
        'autorizados': len([t for t in triggers if t.get('status') == 'authorized']),
        'triggers':  triggers,
    }


@router.post('/authorize/{trigger_id}')
async def autorizar_chamada(trigger_id: str):
    """
    Diretor autoriza manualmente uma chamada Hermes Voice.
    Muda status pending → authorized.
    O loop Hermes retira da fila e executa.
    """
    await _sb_patch('hermes_voice_triggers', f'id=eq.{trigger_id}', {
        'status':        'authorized',
        'authorized_at': datetime.now(timezone.utc).isoformat(),
    })
    log.info(f'Trigger autorizado: {trigger_id}')
    return {'trigger_id': trigger_id, 'status': 'authorized'}


@router.post('/auto-mode/{tenant_id}')
async def activar_auto_mode(tenant_id: str, activar: bool = True):
    """
    Activa modo AUTO para o tenant: triggers autorizados automaticamente
    sem intervenção do Diretor. Usar com cautela — custo Vapi por chamada.
    """
    await _sb_patch('tenants', f'id=eq.{tenant_id}', {
        'hermes_auto_mode': activar,
    })
    modo = 'ACTIVADO' if activar else 'DESACTIVADO'
    log.info(f'Hermes Auto Mode {modo}: tenant {tenant_id[:8]}')
    return {'tenant_id': tenant_id, 'hermes_auto_mode': activar}
