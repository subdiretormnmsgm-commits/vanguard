"""
Vanguard V22 — Sentinel Escalation Ladder
FastAPI Router: /api/sentinel/escalation/

Cadência de retenção automática baseada em semanas sem abertura de email:
  Semana 1: Sentinel Report Card enviado (sentinel_report.py)
  Semana 2: WhatsApp de seguimento via prospectar pipeline
  Semana 3: Hermes Voice — chamada de "revisão de conta"
  Semana 4: IAH Rescue Plan — modal injectado no site do cliente via KV bus (NÃO desconto)

Tracking de abertura: pixel 1×1 em cada email → GET /api/sentinel/track/{token}.gif
"""

import base64
import hashlib
import logging
import os
from datetime import datetime, timedelta, timezone
from typing import Optional

import httpx
from fastapi import APIRouter, Header, HTTPException, Response
from pydantic import BaseModel

log = logging.getLogger('vanguard-sentinel-escalation')

router = APIRouter(prefix='/api/sentinel', tags=['Sentinel Escalation'])

SUPABASE_URL      = os.getenv('SUPABASE_URL', '')
SUPABASE_KEY      = os.getenv('SUPABASE_SERVICE_KEY', os.getenv('SUPABASE_ANON_KEY', ''))
COCKPIT_SECRET    = os.getenv('COCKPIT_SECRET', '')
INTERVENTION_WORKER_URL = os.getenv('INTERVENTION_WORKER_URL', 'https://intervention.vanguard.tech')
VAPI_KEY          = os.getenv('VAPI_KEY', '')
VAPI_PHONE_ID     = os.getenv('VAPI_PHONE_NUMBER_ID', '')
DIRECTOR_PHONE    = os.getenv('DIRECTOR_PHONE', '')
BASE_URL          = os.getenv('SAAS_URL', 'https://vanguard.tech')

# GIF 1×1 pixel transparente
_TRACKING_PIXEL = base64.b64decode(
    'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'
)

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


def _gerar_open_token(tenant_id: str, report_id: str) -> str:
    """Token único para tracking de abertura de email."""
    raw = f'{tenant_id}:{report_id}:{SUPABASE_KEY[:8]}'
    return hashlib.sha256(raw.encode()).hexdigest()[:32]


async def _injectar_rescue_plan_modal(tenant_id: str) -> bool:
    """
    Semana 4 — IAH Rescue Plan.
    Injeta modal de resgate no site do cliente via intervention-worker (KV bus).
    NÃO é um desconto — é uma oferta de valor: prospecção intensiva gratuita por 48h.
    """
    if not COCKPIT_SECRET:
        log.warning('COCKPIT_SECRET não configurado — modal de resgate não injectado.')
        return False

    message = (
        '🚨 PLANO DE RESGATE IAH — OFERTA 48H\n\n'
        'A Vanguard detectou que você pode estar a perder leads FIRE esta semana.\n\n'
        'Active agora o Plano de Resgate: a nossa IA faz prospecção intensiva no seu nicho '
        'GRATUITAMENTE pelas próximas 48 horas. Sem custo extra para subscritores Sentinel.\n\n'
        'Esta oferta expira em 48h.'
    )

    try:
        async with httpx.AsyncClient(timeout=15) as c:
            r = await c.post(
                f'{INTERVENTION_WORKER_URL}/api/intervention',
                headers={
                    'Authorization': f'Bearer {COCKPIT_SECRET}',
                    'Content-Type':  'application/json',
                },
                json={
                    'tenant_id':   tenant_id,
                    'type':        'iah_rescue_plan',
                    'message':     message,
                    'ttl_seconds': 172800,   # 48 horas
                },
            )
            return r.status_code in (200, 201)
    except Exception as e:
        log.warning(f'Rescue plan injection error: {e}')
        return False


async def _enviar_whatsapp_followup(tenant: dict) -> bool:
    """
    Semana 2 — WhatsApp de seguimento.
    Regista na escalation_log para que prospectar.ps1 possa enviar.
    """
    await _sb_post('escalation_whatsapp_queue', {
        'tenant_id':    tenant['id'],
        'tenant_nome':  tenant.get('nome', ''),
        'email':        tenant.get('email', ''),
        'dominio':      tenant.get('dominio', ''),
        'message':      (
            f"Olá! Vi que o relatório Vanguard desta semana ainda não foi aberto. "
            f"Há leads FIRE no seu site esperando atenção. "
            f"Posso enviar um resumo rápido por aqui?"
        ),
        'status':       'pending',
    })
    log.info(f'WhatsApp follow-up enfileirado: tenant {tenant["id"][:8]}')
    return True


async def _iniciar_hermes_voice_retencao(tenant: dict) -> bool:
    """
    Semana 3 — Hermes Voice de retenção.
    Liga para o Eduardo com briefing sobre risco de churn do tenant.
    """
    if not VAPI_KEY or not DIRECTOR_PHONE:
        log.warning('VAPI_KEY ou DIRECTOR_PHONE não configurados.')
        return False

    try:
        async with httpx.AsyncClient(timeout=20) as c:
            r = await c.post(
                'https://api.vapi.ai/call',
                headers={'Authorization': f'Bearer {VAPI_KEY}', 'Content-Type': 'application/json'},
                json={
                    'phoneNumberId': VAPI_PHONE_ID,
                    'customer':      {'number': DIRECTOR_PHONE},
                    'assistant': {
                        'firstMessage': (
                            f'Eduardo, alerta de retenção. '
                            f'O cliente {tenant.get("nome", "Tenant")} não abre o Sentinel há 3 semanas. '
                            f'Risco de churn elevado. '
                            f'Pressione 1 para activar o Plano de Resgate agora. '
                            f'Pressione 2 para ignorar por mais uma semana.'
                        ),
                        'model': {
                            'provider':    'anthropic',
                            'model':       'claude-haiku-4-5-20251001',
                            'systemPrompt': (
                                'És o Hermes, sistema de alerta Vanguard. '
                                'Informa o Diretor Eduardo sobre risco de churn de um cliente. '
                                'Tom: breve, urgente, factual. Máximo 3 frases.'
                            ),
                        },
                        'voice': {'provider': 'elevenlabs', 'voiceId': 'rachel'},
                    },
                    'metadata': {'tenant_id': tenant['id'], 'mode': 'churn_alert'},
                }
            )
            return r.status_code == 201
    except Exception as e:
        log.warning(f'Vapi churn alert error: {e}')
        return False


async def _avaliar_escalacao_tenant(tenant: dict) -> dict:
    """
    Determina o nível de escalação do tenant baseado em relatórios sem abertura.
    Retorna a acção tomada.
    """
    tenant_id = tenant['id']

    # Buscar últimos 4 relatórios
    relatorios = await _sb_get('sentinel_report_log', {
        'tenant_id': f'eq.{tenant_id}',
        'order':     'semana_inicio.desc',
        'limit':     '4',
    })

    if not relatorios:
        return {'tenant_id': tenant_id, 'acao': 'sem_relatorios', 'nivel': 0}

    # Contar semanas consecutivas sem abertura
    semanas_sem_abertura = sum(
        1 for r in relatorios if not r.get('email_aberto', False)
    )

    nivel  = semanas_sem_abertura
    acao   = 'nenhuma'
    sucesso = False

    if nivel == 0:
        acao = 'em_dia'
    elif nivel == 1:
        # Semana 2: WhatsApp
        acao    = 'whatsapp_followup'
        sucesso = await _enviar_whatsapp_followup(tenant)
    elif nivel == 2:
        # Semana 3: Hermes Voice alerta Eduardo
        acao    = 'hermes_voice_churn_alert'
        sucesso = await _iniciar_hermes_voice_retencao(tenant)
    elif nivel >= 3:
        # Semana 4+: IAH Rescue Plan modal
        acao    = 'iah_rescue_plan_modal'
        sucesso = await _injectar_rescue_plan_modal(tenant_id)

    # Registar escalação
    if acao not in ('em_dia', 'sem_relatorios', 'nenhuma'):
        try:
            await _sb_post('escalation_log', {
                'tenant_id':            tenant_id,
                'nivel':                nivel,
                'acao':                 acao,
                'semanas_sem_abertura': semanas_sem_abertura,
                'sucesso':              sucesso,
            })
        except Exception as e:
            log.warning(f'Escalation log error (não-fatal): {e}')

    log.info(f'Escalação: tenant {tenant_id[:8]} — nível {nivel} — {acao} — ok={sucesso}')
    return {
        'tenant_id':            tenant_id,
        'tenant_nome':          tenant.get('nome'),
        'nivel':                nivel,
        'semanas_sem_abertura': semanas_sem_abertura,
        'acao':                 acao,
        'sucesso':              sucesso,
    }


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.get('/track/{open_token}.gif')
async def tracking_pixel(open_token: str):
    """
    Pixel de tracking de abertura de email (1×1 GIF transparente).
    Incluir no HTML do Report Card como:
      <img src="https://vanguard.tech/api/sentinel/track/{token}.gif" width="1" height="1">
    """
    # Marcar relatório como aberto
    try:
        await _sb_patch(
            'sentinel_report_log',
            f'open_token=eq.{open_token}',
            {'email_aberto': True, 'aberto_em': datetime.now(timezone.utc).isoformat()},
        )
    except Exception:
        pass  # não-fatal — o pixel deve sempre retornar o GIF

    return Response(
        content=_TRACKING_PIXEL,
        media_type='image/gif',
        headers={
            'Cache-Control': 'no-cache, no-store, must-revalidate',
            'Pragma':        'no-cache',
            'Expires':       '0',
        },
    )


@router.post('/escalation/run')
async def executar_escalacao_semanal(
    authorization: Optional[str] = Header(None),
):
    """
    Avalia TODOS os tenants com subscrição activa e executa a próxima escalação.
    Chamado pelo pg_cron segunda-feira 09:00 BRT (após o envio dos relatórios).
    """
    cron_secret = os.getenv('CRON_SECRET', '')
    if cron_secret and authorization != f'Bearer {cron_secret}':
        raise HTTPException(401, 'Não autorizado.')

    # Tenants com subscrição activa
    subs = await _sb_get('tenant_subscriptions', {'status': 'eq.active', 'select': 'tenant_id'})
    tenant_ids = list({s['tenant_id'] for s in subs})

    if not tenant_ids:
        return {'avaliados': 0}

    tenants = await _sb_get('tenants', {
        'id':    f'in.({",".join(tenant_ids)})',
        'status': 'eq.active',
    })

    import asyncio
    resultados = await asyncio.gather(
        *[_avaliar_escalacao_tenant(t) for t in tenants],
        return_exceptions=True,
    )

    acoes = {}
    for r in resultados:
        if isinstance(r, dict):
            acao = r.get('acao', 'erro')
            acoes[acao] = acoes.get(acao, 0) + 1

    log.info(f'Escalação semanal: {len(tenants)} tenants — acções: {acoes}')
    return {
        'tenants_avaliados': len(tenants),
        'acoes':             acoes,
        'resultados':        [r for r in resultados if isinstance(r, dict)],
    }


@router.get('/escalation/status/{tenant_id}')
async def status_escalacao(tenant_id: str):
    """Retorna o nível de escalação actual do tenant — visível no Cockpit."""
    relatorios = await _sb_get('sentinel_report_log', {
        'tenant_id': f'eq.{tenant_id}',
        'order':     'semana_inicio.desc',
        'limit':     '4',
        'select':    'semana_inicio,email_enviado,email_aberto,aberto_em,fire_count',
    })

    semanas_sem_abertura = sum(1 for r in relatorios if not r.get('email_aberto', False))
    nivel_map = {0: 'em_dia', 1: 'whatsapp_pendente', 2: 'hermes_alerta', 3: 'iah_rescue'}
    nivel_label = nivel_map.get(min(semanas_sem_abertura, 3), 'iah_rescue')

    historico_escalacao = await _sb_get('escalation_log', {
        'tenant_id': f'eq.{tenant_id}',
        'order':     'created_at.desc',
        'limit':     '5',
    })

    return {
        'tenant_id':            tenant_id,
        'semanas_sem_abertura': semanas_sem_abertura,
        'nivel':                semanas_sem_abertura,
        'nivel_label':          nivel_label,
        'relatorios':           relatorios,
        'historico_escalacao':  historico_escalacao,
    }


@router.post('/escalation/rescue/{tenant_id}')
async def activar_rescue_manual(tenant_id: str):
    """Activa manualmente o IAH Rescue Plan para um tenant — via Cockpit."""
    tenants = await _sb_get('tenants', {'id': f'eq.{tenant_id}'})
    if not tenants:
        raise HTTPException(404, 'Tenant não encontrado.')

    sucesso = await _injectar_rescue_plan_modal(tenant_id)
    return {'tenant_id': tenant_id, 'rescue_plan_injectado': sucesso}
