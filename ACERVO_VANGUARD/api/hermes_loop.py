"""
Vanguard V22 — Hermes Loop Completo
FastAPI Router: /api/hermes-loop/

Ciclo fechado de autonomia:
  Trigger (score >= 9.5) → Vapi Call → Haiku Sentiment → Google Calendar Booking
  → Status update → Confirmação WhatsApp

§21 Burn Rate Shield: score < 9.5 = bloqueado. Imutável.

Google Calendar OAuth:
  1. Visitar GET /api/hermes-loop/oauth/start → URL de autorização
  2. Google redireciona para /api/hermes-loop/oauth/callback
  3. Refresh token guardado em GOOGLE_CALENDAR_REFRESH_TOKEN (env)
  Após setup inicial, o loop funciona sem intervenção do Diretor.
"""

import json
import logging
import os
from datetime import datetime, timedelta, timezone
from typing import Optional
from urllib.parse import urlencode

import anthropic
import httpx
from fastapi import APIRouter, HTTPException, Request, Response
from pydantic import BaseModel

log = logging.getLogger('vanguard-hermes-loop')

router = APIRouter(prefix='/api/hermes-loop', tags=['Hermes Loop'])

SUPABASE_URL      = os.getenv('SUPABASE_URL', '')
SUPABASE_KEY      = os.getenv('SUPABASE_SERVICE_KEY', os.getenv('SUPABASE_ANON_KEY', ''))
ANTHROPIC_KEY     = os.getenv('ANTHROPIC_API_KEY', '')
VAPI_KEY          = os.getenv('VAPI_KEY', '')
VAPI_PHONE_ID     = os.getenv('VAPI_PHONE_NUMBER_ID', '')
GOOGLE_CLIENT_ID  = os.getenv('GOOGLE_CLIENT_ID', '')
GOOGLE_CLIENT_SECRET = os.getenv('GOOGLE_CLIENT_SECRET', '')
GOOGLE_REFRESH_TOKEN = os.getenv('GOOGLE_CALENDAR_REFRESH_TOKEN', '')
GOOGLE_REDIRECT_URI  = os.getenv('GOOGLE_REDIRECT_URI', 'https://vanguard.tech/api/hermes-loop/oauth/callback')
DIRECTOR_CALENDAR_ID = os.getenv('DIRECTOR_CALENDAR_ID', 'primary')
DIRECTOR_PHONE       = os.getenv('DIRECTOR_PHONE', '')    # para IAH Bridge
SCORE_THRESHOLD      = 9.5   # §21 — imutável

GOOGLE_TOKEN_URL  = 'https://oauth2.googleapis.com/token'
GOOGLE_AUTH_URL   = 'https://accounts.google.com/o/oauth2/v2/auth'
GOOGLE_CALENDAR_BASE = 'https://www.googleapis.com/calendar/v3'
GOOGLE_SCOPES     = 'https://www.googleapis.com/auth/calendar.events'

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


async def _sb_patch(table: str, filtro: str, data: dict) -> None:
    async with httpx.AsyncClient(timeout=10) as c:
        r = await c.patch(
            f'{SUPABASE_URL}/rest/v1/{table}?{filtro}', json=data,
            headers={**_sb_hdrs(), 'Prefer': 'return=minimal'},
        )
        r.raise_for_status()


# ─── Google Calendar OAuth ────────────────────────────────────────────────────

async def _get_google_access_token() -> str:
    """Troca o refresh_token por um access_token fresco. Requer GOOGLE_CALENDAR_REFRESH_TOKEN."""
    if not GOOGLE_REFRESH_TOKEN:
        raise HTTPException(
            503,
            'Google Calendar não autorizado. Visite GET /api/hermes-loop/oauth/start'
        )

    async with httpx.AsyncClient(timeout=15) as c:
        r = await c.post(GOOGLE_TOKEN_URL, data={
            'client_id':     GOOGLE_CLIENT_ID,
            'client_secret': GOOGLE_CLIENT_SECRET,
            'refresh_token': GOOGLE_REFRESH_TOKEN,
            'grant_type':    'refresh_token',
        })
        r.raise_for_status()
        return r.json()['access_token']


@router.get('/oauth/start')
async def oauth_start():
    """
    Passo 1 do setup Google Calendar.
    Eduardo visita o URL retornado → autoriza → é redirecionado para /oauth/callback.
    Executar UMA VEZ. Após obter o refresh_token, guardar em GOOGLE_CALENDAR_REFRESH_TOKEN.
    """
    if not GOOGLE_CLIENT_ID:
        return {
            'erro': 'GOOGLE_CLIENT_ID não configurado.',
            'instrucoes': [
                '1. Criar projecto em console.cloud.google.com',
                '2. Activar Google Calendar API',
                '3. Criar credenciais OAuth 2.0 (Web Application)',
                '4. Adicionar redirect URI: ' + GOOGLE_REDIRECT_URI,
                '5. Copiar Client ID e Client Secret para .env',
            ]
        }

    params = {
        'client_id':     GOOGLE_CLIENT_ID,
        'redirect_uri':  GOOGLE_REDIRECT_URI,
        'response_type': 'code',
        'scope':         GOOGLE_SCOPES,
        'access_type':   'offline',
        'prompt':        'consent',
    }
    auth_url = f'{GOOGLE_AUTH_URL}?{urlencode(params)}'
    return {
        'instrucao': 'Abrir o URL abaixo no browser e autorizar o acesso ao Calendar do Eduardo.',
        'url': auth_url,
    }


@router.get('/oauth/callback')
async def oauth_callback(code: str, request: Request):
    """
    Passo 2 — Google redireciona aqui com o code.
    Troca por tokens e exibe o refresh_token para guardar em .env.
    """
    async with httpx.AsyncClient(timeout=15) as c:
        r = await c.post(GOOGLE_TOKEN_URL, data={
            'code':          code,
            'client_id':     GOOGLE_CLIENT_ID,
            'client_secret': GOOGLE_CLIENT_SECRET,
            'redirect_uri':  GOOGLE_REDIRECT_URI,
            'grant_type':    'authorization_code',
        })
        r.raise_for_status()
        tokens = r.json()

    refresh_token = tokens.get('refresh_token', '')
    return {
        'sucesso':       True,
        'refresh_token': refresh_token,
        'instrucao':     'Copiar o refresh_token para GOOGLE_CALENDAR_REFRESH_TOKEN no .env e reiniciar o servidor.',
        'nota': 'O refresh_token não expira (a menos que as permissões sejam revogadas).',
    }


# ─── Calendar Booking ─────────────────────────────────────────────────────────

async def _find_next_slot(access_token: str, duracao_min: int = 30) -> Optional[dict]:
    """
    Encontra o próximo slot livre no Calendar do Eduardo.
    Procura nos próximos 3 dias úteis entre 09:00 e 17:00 BRT (UTC-3).
    """
    now_utc  = datetime.now(timezone.utc)
    brt_offset = timedelta(hours=-3)
    now_brt  = now_utc + brt_offset

    hdrs = {'Authorization': f'Bearer {access_token}', 'Content-Type': 'application/json'}

    # Verificar disponibilidade nos próximos 3 dias úteis
    for dias_a_frente in range(1, 6):
        data_tentativa = (now_brt + timedelta(days=dias_a_frente)).date()
        # Ignorar fim de semana
        if data_tentativa.weekday() >= 5:
            continue

        for hora in [9, 10, 11, 14, 15, 16]:
            slot_brt  = datetime(
                data_tentativa.year, data_tentativa.month, data_tentativa.day,
                hora, 0, 0
            ).replace(tzinfo=timezone(brt_offset))
            slot_utc  = slot_brt.astimezone(timezone.utc)
            slot_end  = slot_utc + timedelta(minutes=duracao_min)

            # Verificar freebusy
            async with httpx.AsyncClient(timeout=15) as c:
                r = await c.post(
                    f'{GOOGLE_CALENDAR_BASE}/freeBusy',
                    headers=hdrs,
                    json={
                        'timeMin': slot_utc.isoformat(),
                        'timeMax': slot_end.isoformat(),
                        'items':   [{'id': DIRECTOR_CALENDAR_ID}],
                    }
                )
                if r.status_code != 200:
                    continue
                busy = r.json().get('calendars', {}).get(DIRECTOR_CALENDAR_ID, {}).get('busy', [])
                if not busy:
                    return {
                        'start':     slot_utc.isoformat(),
                        'end':       slot_end.isoformat(),
                        'start_brt': slot_brt.strftime('%d/%m/%Y às %H:%M'),
                    }

    return None


async def _criar_evento_calendar(
    access_token: str,
    titulo: str,
    descricao: str,
    slot: dict,
    email_lead: Optional[str] = None,
) -> str:
    """Cria evento no Google Calendar e retorna o link."""
    hdrs = {'Authorization': f'Bearer {access_token}', 'Content-Type': 'application/json'}

    attendees = [{'email': DIRECTOR_CALENDAR_ID}]
    if email_lead:
        attendees.append({'email': email_lead})

    evento = {
        'summary':     titulo,
        'description': descricao,
        'start':       {'dateTime': slot['start'], 'timeZone': 'America/Sao_Paulo'},
        'end':         {'dateTime': slot['end'],   'timeZone': 'America/Sao_Paulo'},
        'attendees':   attendees,
        'reminders': {
            'useDefault': False,
            'overrides':  [
                {'method': 'email',  'minutes': 60},
                {'method': 'popup',  'minutes': 10},
            ],
        },
        'conferenceData': {
            'createRequest': {'requestId': f'hermes-{int(datetime.now().timestamp())}'},
        },
    }

    async with httpx.AsyncClient(timeout=15) as c:
        r = await c.post(
            f'{GOOGLE_CALENDAR_BASE}/calendars/{DIRECTOR_CALENDAR_ID}/events'
            '?conferenceDataVersion=1&sendUpdates=all',
            headers=hdrs,
            json=evento,
        )
        r.raise_for_status()
        data = r.json()
        return data.get('htmlLink', data.get('id', ''))


# ─── Sentiment Analysis ───────────────────────────────────────────────────────

async def _analisar_sentimento_haiku(transcricao: str, lead_info: dict) -> dict:
    """
    Claude Haiku analisa a transcrição da chamada Vapi.
    Retorna: interesse (alto/medio/baixo), proximo_passo, booking_recomendado.
    """
    if not ANTHROPIC_KEY or not transcricao:
        return {'interesse': 'desconhecido', 'booking_recomendado': False, 'proximo_passo': 'Follow-up manual.'}

    claude = anthropic.Anthropic(api_key=ANTHROPIC_KEY)
    prompt = f"""Analisa esta transcrição de chamada de vendas Vanguard Tech.

Lead: {lead_info.get('nome', 'Empresa')} — Nicho: {lead_info.get('nicho', '')}
Transcrição:
{transcricao[:1200]}

Responde APENAS em JSON:
{{
  "interesse": "alto | medio | baixo",
  "booking_recomendado": true | false,
  "email_lead": "email se mencionado ou null",
  "proximo_passo": "frase curta sobre o que fazer agora",
  "resumo_chamada": "1 frase sobre como correu"
}}"""

    try:
        msg = claude.messages.create(
            model='claude-haiku-4-5-20251001',
            max_tokens=256,
            messages=[{'role': 'user', 'content': prompt}],
        )
        import re
        json_match = re.search(r'\{.*\}', msg.content[0].text, re.DOTALL)
        if json_match:
            return json.loads(json_match.group())
    except Exception as e:
        log.warning(f'Haiku sentiment error: {e}')

    return {'interesse': 'desconhecido', 'booking_recomendado': False, 'proximo_passo': 'Follow-up manual.'}


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.post('/execute/{trigger_id}')
async def executar_loop(trigger_id: str):
    """
    Executa o Hermes Loop completo para um trigger autorizado.
    Score < 9.5 → rejeitado (§21).
    Fluxo: validar trigger → Vapi call → aguarda webhook → (webhook faz o resto)
    """
    triggers = await _sb_get('hermes_voice_triggers', {
        'id':     f'eq.{trigger_id}',
        'status': 'eq.authorized',
    })
    if not triggers:
        raise HTTPException(404, 'Trigger não encontrado ou não autorizado.')

    trigger = triggers[0]

    # §21 — Burn Rate Shield
    if float(trigger.get('maturity_score', 0)) < SCORE_THRESHOLD:
        raise HTTPException(
            403,
            f'§21 Burn Rate Shield: score {trigger["maturity_score"]} < {SCORE_THRESHOLD}. Bloqueado.'
        )

    # Buscar lead associado ao session_hash
    tenant_id    = trigger['tenant_id']
    session_hash = trigger.get('session_hash', '')

    leads = await _sb_get('pixel_events_staging', {
        'tenant_id':    f'eq.{tenant_id}',
        'session_hash': f'eq.{session_hash}',
        'select':       'site_domain,device_type',
        'limit':        '1',
    })
    site_domain = leads[0].get('site_domain', 'site do lead') if leads else 'site do lead'

    # Buscar dados do tenant para o script Vapi
    tenants = await _sb_get('tenants', {'id': f'eq.{tenant_id}'})
    tenant  = tenants[0] if tenants else {}
    tenant_nome = tenant.get('nome', 'empresa')

    # Script da chamada
    call_script = (
        f"Olá! Falo da Vanguard Intelligence. Identificámos que {site_domain} "
        f"tem leads com intenção máxima de compra esta semana. "
        f"Posso explicar como a {tenant_nome} pode converter estes leads em receita nos próximos 7 dias? "
        f"São apenas 15 minutos."
    )

    # Marcar como dispatched
    await _sb_patch('hermes_voice_triggers', f'id=eq.{trigger_id}', {
        'status':       'dispatched',
        'dispatched_at': datetime.now(timezone.utc).isoformat(),
    })

    # Iniciar chamada Vapi (se configurado)
    call_id = None
    if VAPI_KEY and DIRECTOR_PHONE:
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
                                f'Eduardo, lead FIRE detectado agora em {site_domain}. '
                                f'Score {trigger["maturity_score"]}. '
                                f'Pressione 1 para activar prospecção imediata. '
                                f'Pressione 2 para agendar para amanhã.'
                            ),
                            'model': {
                                'provider':    'anthropic',
                                'model':       'claude-haiku-4-5-20251001',
                                'systemPrompt': (
                                    f'És o Hermes, assistente de vendas Vanguard. '
                                    f'Informa o Diretor Eduardo sobre um lead FIRE em {site_domain}. '
                                    f'Se pressionar 1: confirma que vais fazer prospecção imediata. '
                                    f'Se pressionar 2: agenda para amanhã no Calendar. '
                                    f'Tom: breve, executivo, urgente.'
                                ),
                            },
                            'voice': {'provider': 'elevenlabs', 'voiceId': 'rachel'},
                        },
                        'metadata': {
                            'trigger_id': trigger_id,
                            'tenant_id':  tenant_id,
                            'mode':       'iah_bridge',
                        },
                    }
                )
                if r.status_code == 201:
                    call_id = r.json().get('id')
        except Exception as e:
            log.warning(f'Vapi IAH Bridge error (não-fatal): {e}')

    log.info(f'Hermes Loop executado: trigger {trigger_id[:8]} — call_id={call_id}')
    return {
        'trigger_id':  trigger_id,
        'status':      'dispatched',
        'call_id':     call_id,
        'site_domain': site_domain,
        'score':       trigger['maturity_score'],
        'nota': 'Configure VAPI_KEY + DIRECTOR_PHONE para chamadas reais.' if not VAPI_KEY else None,
    }


@router.post('/vapi-webhook')
async def vapi_webhook_loop(request: Request):
    """
    Recebe eventos Vapi após a chamada.
    Se interesse alto → agenda no Google Calendar automaticamente.
    """
    payload = await request.json()
    event   = payload.get('message', {})
    tipo    = event.get('type', '')
    meta    = payload.get('call', {}).get('metadata', {})
    trigger_id = meta.get('trigger_id')

    if tipo != 'end-of-call-report' or not trigger_id:
        return Response(status_code=200)

    transcricao = event.get('transcript', '')
    duracao_seg = int(event.get('durationSeconds', 0))

    # Buscar trigger e lead info
    triggers = await _sb_get('hermes_voice_triggers', {'id': f'eq.{trigger_id}'})
    trigger  = triggers[0] if triggers else {}
    lead_info = {'nome': meta.get('site_domain', ''), 'nicho': ''}

    # Analisar sentimento com Haiku
    sentimento = await _analisar_sentimento_haiku(transcricao, lead_info)

    evento_link = None
    slot_info   = None

    # Se interesse alto → agendar no Calendar
    if sentimento.get('booking_recomendado') and sentimento.get('interesse') == 'alto':
        try:
            access_token = await _get_google_access_token()
            slot = await _find_next_slot(access_token, duracao_min=30)
            if slot:
                tenant_id   = trigger.get('tenant_id', '')
                site_domain = lead_info.get('nome', 'Lead')
                evento_link = await _criar_evento_calendar(
                    access_token,
                    titulo    = f'Demo Vanguard — {site_domain}',
                    descricao = (
                        f'Lead FIRE identificado pela Vanguard Intelligence.\n'
                        f'Score: {trigger.get("maturity_score")}\n'
                        f'Resumo da chamada: {sentimento.get("resumo_chamada", "")}\n'
                        f'Próximo passo: {sentimento.get("proximo_passo", "")}'
                    ),
                    slot      = slot,
                    email_lead = sentimento.get('email_lead'),
                )
                slot_info = slot.get('start_brt')
                log.info(f'Meeting booked: trigger {trigger_id[:8]} — {slot_info}')
        except Exception as e:
            log.warning(f'Calendar booking error (não-fatal): {e}')

    # Actualizar trigger
    await _sb_patch('hermes_voice_triggers', f'id=eq.{trigger_id}', {
        'status':        'meeting_booked' if evento_link else 'completed',
        'maturity_score': trigger.get('maturity_score'),
    })

    log.info(
        f'Hermes webhook: trigger {trigger_id[:8]} '
        f'interesse={sentimento.get("interesse")} '
        f'booking={bool(evento_link)}'
    )
    return Response(status_code=200)


@router.get('/calendar/slots')
async def listar_slots():
    """Retorna os próximos 5 slots livres no Calendar do Eduardo."""
    try:
        access_token = await _get_google_access_token()
    except HTTPException as e:
        return {'erro': str(e.detail), 'configurado': False}

    slots = []
    now_utc    = datetime.now(timezone.utc)
    brt_offset = timedelta(hours=-3)
    now_brt    = now_utc + brt_offset
    hdrs       = {'Authorization': f'Bearer {access_token}'}

    for dias in range(1, 6):
        data = (now_brt + timedelta(days=dias)).date()
        if data.weekday() >= 5:
            continue

        for hora in [9, 10, 11, 14, 15, 16]:
            if len(slots) >= 5:
                break
            slot_brt = datetime(data.year, data.month, data.day, hora, 0, tzinfo=timezone(brt_offset))
            slot_utc = slot_brt.astimezone(timezone.utc)
            slot_end = slot_utc + timedelta(minutes=30)

            async with httpx.AsyncClient(timeout=10) as c:
                r = await c.post(
                    f'{GOOGLE_CALENDAR_BASE}/freeBusy',
                    headers={**hdrs, 'Content-Type': 'application/json'},
                    json={
                        'timeMin': slot_utc.isoformat(),
                        'timeMax': slot_end.isoformat(),
                        'items':   [{'id': DIRECTOR_CALENDAR_ID}],
                    }
                )
                if r.status_code == 200:
                    busy = r.json().get('calendars', {}).get(DIRECTOR_CALENDAR_ID, {}).get('busy', [])
                    if not busy:
                        slots.append({'slot': slot_brt.strftime('%d/%m/%Y %H:%M BRT'), 'utc': slot_utc.isoformat()})

    return {'slots_livres': slots, 'total': len(slots)}
