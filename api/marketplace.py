"""
Vanguard V7 — Marketplace de Nichos
FastAPI Router: Stripe Connect + Packs + Subscriptions + Intention Webhooks

Revenue Share: 70% criador / 30% plataforma (automático via Stripe Connect)
"""

import json
import logging
import os
from datetime import datetime
from typing import Optional

import httpx
import stripe
from fastapi import APIRouter, Header, HTTPException, Request
from pydantic import BaseModel, Field

log = logging.getLogger('vanguard-marketplace')

SUPABASE_URL         = os.getenv('SUPABASE_URL', '')
SUPABASE_SERVICE_KEY = os.getenv('SUPABASE_SERVICE_KEY', '')
STRIPE_SECRET_KEY    = os.getenv('STRIPE_SECRET_KEY', '')
STRIPE_CONNECT_WHSEC = os.getenv('STRIPE_CONNECT_WEBHOOK_SECRET', '')
MARKETPLACE_URL      = os.getenv('MARKETPLACE_URL', 'http://localhost/marketplace')
PLATFORM_FEE_PCT     = 0.30  # 30% para a plataforma

stripe.api_key = STRIPE_SECRET_KEY

router = APIRouter(prefix='/marketplace', tags=['marketplace'])


# ── Supabase helpers (reutiliza padrão da main.py) ────────────────────────────

def _sb_headers() -> dict:
    return {
        'apikey':        SUPABASE_SERVICE_KEY,
        'Authorization': f'Bearer {SUPABASE_SERVICE_KEY}',
        'Content-Type':  'application/json',
        'Prefer':        'return=representation',
    }


async def sb_get(client: httpx.AsyncClient, table: str, params: dict = None) -> list:
    r = await client.get(f'{SUPABASE_URL}/rest/v1/{table}', params=params or {}, headers=_sb_headers())
    r.raise_for_status()
    return r.json()


async def sb_post(client: httpx.AsyncClient, table: str, data: dict) -> dict:
    r = await client.post(f'{SUPABASE_URL}/rest/v1/{table}', json=data, headers=_sb_headers())
    r.raise_for_status()
    result = r.json()
    return result[0] if isinstance(result, list) and result else result


async def sb_patch(client: httpx.AsyncClient, table: str, filtro: str, data: dict) -> None:
    r = await client.patch(
        f'{SUPABASE_URL}/rest/v1/{table}?{filtro}', json=data,
        headers={**_sb_headers(), 'Prefer': 'return=minimal'},
    )
    r.raise_for_status()


# ── Modelos ───────────────────────────────────────────────────────────────────

class CriarCreatorReq(BaseModel):
    nome:          str = Field(..., min_length=2, max_length=120)
    bio:           Optional[str] = Field(None, max_length=500)
    especialidade: Optional[str] = None


class CriarPackReq(BaseModel):
    nome:              str   = Field(..., min_length=3, max_length=120)
    descricao:         Optional[str] = Field(None, max_length=800)
    nicho:             str   = Field(...)
    cidade_alvo:       Optional[str] = None
    preco_mensal:      float = Field(97.0, ge=9.9, le=9999)
    leads_tipicos:     int   = Field(50, ge=5, le=2000)
    config_osm:        Optional[dict] = None
    config_prompts:    Optional[dict] = None
    config_wa_templates: Optional[dict] = None
    tags:              list[str] = Field(default_factory=list)
    cover_emoji:       str  = Field('📦', max_length=4)


class IntencaoReq(BaseModel):
    pack_id:   str
    evento:    str = Field(..., pattern=r'^(view|preview|add_to_cart|checkout_start|subscribed|scraper_ran)$')
    metadata:  dict = Field(default_factory=dict)


class ReviewReq(BaseModel):
    pack_id:    str
    rating:     int = Field(..., ge=1, le=5)
    comentario: Optional[str] = Field(None, max_length=600)


# ── Auth helper (importado de contexto, redefinido aqui para independência) ───

from jose import JWTError, jwt as _jwt

SUPABASE_JWT_SECRET = os.getenv('SUPABASE_JWT_SECRET', '')


def _verify_jwt(authorization: Optional[str]) -> str:
    if not authorization or not authorization.startswith('Bearer '):
        raise HTTPException(401, 'Authorization header obrigatório.')
    token = authorization.split(' ', 1)[1]
    try:
        payload = _jwt.decode(token, SUPABASE_JWT_SECRET, algorithms=['HS256'],
                              options={'verify_aud': False})
    except JWTError as e:
        raise HTTPException(401, f'Token inválido: {e}')
    uid = payload.get('sub')
    if not uid:
        raise HTTPException(401, 'Token sem user ID.')
    return uid


# ═══════════════════════════════════════════════════════════════════
# ENDPOINTS PÚBLICOS (sem auth)
# ═══════════════════════════════════════════════════════════════════

@router.get('/packs')
async def listar_packs(
    nicho:  Optional[str] = None,
    ordem:  str = 'assinantes',   # assinantes | rating | preco | recente
    limite: int = 20,
    offset: int = 0,
):
    """Lista packs activos do marketplace (público)."""
    params = {
        'status': 'eq.active',
        'limit':  str(min(limite, 50)),
        'offset': str(offset),
        'select': 'id,nome,descricao,nicho,cidade_alvo,preco_mensal,leads_tipicos,taxa_conversao,score_medio,assinantes,rating,reviews,tags,cover_emoji,publicado_em,creator_id',
    }
    if nicho:
        params['nicho'] = f'eq.{nicho}'

    ordem_map = {
        'assinantes': 'assinantes.desc',
        'rating':     'rating.desc',
        'preco':      'preco_mensal.asc',
        'recente':    'publicado_em.desc',
    }
    params['order'] = ordem_map.get(ordem, 'assinantes.desc')

    async with httpx.AsyncClient(timeout=10) as client:
        packs = await sb_get(client, 'marketplace_packs', params)

        # Enriquecer com dados do criador
        creator_ids = list({p['creator_id'] for p in packs if p.get('creator_id')})
        creators_map = {}
        if creator_ids:
            creators = await sb_get(client, 'creators', {
                'id': f'in.({",".join(creator_ids)})',
                'select': 'id,nome,avatar_url,rating_medio',
            })
            creators_map = {c['id']: c for c in creators}

        for p in packs:
            p['creator'] = creators_map.get(p.get('creator_id'), {})

    return {'packs': packs, 'total': len(packs)}


@router.get('/packs/{pack_id}')
async def detalhe_pack(pack_id: str):
    """Detalhe de um pack específico."""
    async with httpx.AsyncClient(timeout=10) as client:
        rows = await sb_get(client, 'marketplace_packs', {'id': f'eq.{pack_id}', 'limit': '1'})
        if not rows or rows[0].get('status') not in ('active', 'draft'):
            raise HTTPException(404, 'Pack não encontrado.')
        pack = rows[0]

        # Buscar criador
        creator_rows = await sb_get(client, 'creators', {'id': f'eq.{pack["creator_id"]}', 'limit': '1'})
        pack['creator'] = creator_rows[0] if creator_rows else {}

        # Últimas reviews (5)
        reviews = await sb_get(client, 'pack_reviews', {
            'pack_id': f'eq.{pack_id}',
            'order':   'created_at.desc',
            'limit':   '5',
            'select':  'rating,comentario,created_at',
        })
        pack['ultimas_reviews'] = reviews

        # Incrementar visualizações
        await sb_patch(client, 'marketplace_packs', f'id=eq.{pack_id}', {
            'visualizacoes': pack.get('visualizacoes', 0) + 1,
            'updated_at':    datetime.utcnow().isoformat(),
        })

    return {'pack': pack}


# ═══════════════════════════════════════════════════════════════════
# CRIADOR — onboarding + gestão de packs
# ═══════════════════════════════════════════════════════════════════

@router.post('/creator/onboard')
async def creator_onboard(
    req: CriarCreatorReq,
    authorization: Optional[str] = Header(None),
):
    """Regista criador + inicia Stripe Connect Express onboarding."""
    user_id = _verify_jwt(authorization)

    async with httpx.AsyncClient(timeout=15) as client:
        # Verificar se já existe
        existing = await sb_get(client, 'creators', {'user_id': f'eq.{user_id}', 'limit': '1'})

        if not existing:
            # Criar Stripe Connect account
            try:
                account = stripe.Account.create(
                    type='express',
                    country='BR',
                    email=None,
                    capabilities={'transfers': {'requested': True}},
                    business_type='individual',
                    metadata={'vanguard_user_id': user_id},
                )
                stripe_account_id = account['id']
            except stripe.error.StripeError as e:
                log.warning(f'Stripe Connect account creation failed: {e}')
                stripe_account_id = None

            creator = await sb_post(client, 'creators', {
                'user_id':          user_id,
                'nome':             req.nome,
                'bio':              req.bio,
                'especialidade':    req.especialidade,
                'stripe_account_id': stripe_account_id,
                'stripe_onboarded': False,
            })
        else:
            creator          = existing[0]
            stripe_account_id = creator.get('stripe_account_id')

        # Gerar link de onboarding Stripe
        onboarding_url = None
        if stripe_account_id:
            try:
                link = stripe.AccountLink.create(
                    account=stripe_account_id,
                    refresh_url=f'{MARKETPLACE_URL}/creator.html?refresh=1',
                    return_url=f'{MARKETPLACE_URL}/creator.html?onboarded=1',
                    type='account_onboarding',
                )
                onboarding_url = link['url']
            except stripe.error.StripeError as e:
                log.error(f'AccountLink creation failed: {e}')

    return {
        'creator':        creator,
        'onboarding_url': onboarding_url,
    }


@router.get('/creator/me')
async def creator_me(authorization: Optional[str] = Header(None)):
    """Perfil do criador autenticado + stats dos seus packs."""
    user_id = _verify_jwt(authorization)

    async with httpx.AsyncClient(timeout=10) as client:
        rows = await sb_get(client, 'creators', {'user_id': f'eq.{user_id}', 'limit': '1'})
        if not rows:
            raise HTTPException(404, 'Perfil de criador não encontrado. Use /creator/onboard primeiro.')
        creator = rows[0]

        # Verificar status Stripe Connect
        if creator.get('stripe_account_id') and not creator.get('stripe_onboarded'):
            try:
                account = stripe.Account.retrieve(creator['stripe_account_id'])
                if account.get('details_submitted'):
                    await sb_patch(client, 'creators', f'id=eq.{creator["id"]}',
                                   {'stripe_onboarded': True, 'updated_at': datetime.utcnow().isoformat()})
                    creator['stripe_onboarded'] = True
            except Exception:
                pass

        # Packs do criador
        packs = await sb_get(client, 'marketplace_packs', {
            'creator_id': f'eq.{creator["id"]}',
            'order':      'created_at.desc',
            'select':     'id,nome,nicho,preco_mensal,status,assinantes,rating,publicado_em',
        })
        creator['packs'] = packs

    return {'creator': creator}


@router.post('/creator/packs')
async def criar_pack(
    req:           CriarPackReq,
    authorization: Optional[str] = Header(None),
):
    """Cria um novo pack de nicho (status: draft)."""
    user_id = _verify_jwt(authorization)

    async with httpx.AsyncClient(timeout=10) as client:
        creators = await sb_get(client, 'creators', {'user_id': f'eq.{user_id}', 'limit': '1'})
        if not creators:
            raise HTTPException(403, 'Perfil de criador necessário. Use /creator/onboard.')
        creator = creators[0]

        pack = await sb_post(client, 'marketplace_packs', {
            'creator_id':          creator['id'],
            'nome':                req.nome,
            'descricao':           req.descricao,
            'nicho':               req.nicho,
            'cidade_alvo':         req.cidade_alvo,
            'preco_mensal':        req.preco_mensal,
            'leads_tipicos':       req.leads_tipicos,
            'config_osm':          req.config_osm or {},
            'config_prompts':      req.config_prompts or {},
            'config_wa_templates': req.config_wa_templates or {},
            'tags':                req.tags,
            'cover_emoji':         req.cover_emoji,
            'status':              'draft',
        })

    return {'pack': pack, 'message': 'Pack criado em modo rascunho. Use /creator/packs/{id}/publish para publicar.'}


@router.put('/creator/packs/{pack_id}')
async def actualizar_pack(
    pack_id:       str,
    req:           CriarPackReq,
    authorization: Optional[str] = Header(None),
):
    """Actualiza um pack existente (só o criador)."""
    user_id = _verify_jwt(authorization)

    async with httpx.AsyncClient(timeout=10) as client:
        creators = await sb_get(client, 'creators', {'user_id': f'eq.{user_id}', 'limit': '1'})
        if not creators:
            raise HTTPException(403, 'Perfil de criador necessário.')
        creator = creators[0]

        packs = await sb_get(client, 'marketplace_packs', {
            'id': f'eq.{pack_id}', 'creator_id': f'eq.{creator["id"]}', 'limit': '1',
        })
        if not packs:
            raise HTTPException(404, 'Pack não encontrado ou sem permissão.')

        await sb_patch(client, 'marketplace_packs', f'id=eq.{pack_id}', {
            'nome':                req.nome,
            'descricao':           req.descricao,
            'nicho':               req.nicho,
            'cidade_alvo':         req.cidade_alvo,
            'preco_mensal':        req.preco_mensal,
            'leads_tipicos':       req.leads_tipicos,
            'config_osm':          req.config_osm or {},
            'config_prompts':      req.config_prompts or {},
            'config_wa_templates': req.config_wa_templates or {},
            'tags':                req.tags,
            'cover_emoji':         req.cover_emoji,
            'updated_at':          datetime.utcnow().isoformat(),
        })

    return {'message': 'Pack actualizado com sucesso.'}


@router.post('/creator/packs/{pack_id}/publish')
async def publicar_pack(
    pack_id:       str,
    authorization: Optional[str] = Header(None),
):
    """Publica o pack: cria produto + preço no Stripe e muda status para review."""
    user_id = _verify_jwt(authorization)

    async with httpx.AsyncClient(timeout=15) as client:
        creators = await sb_get(client, 'creators', {'user_id': f'eq.{user_id}', 'limit': '1'})
        if not creators:
            raise HTTPException(403, 'Perfil de criador necessário.')
        creator = creators[0]

        packs = await sb_get(client, 'marketplace_packs', {
            'id': f'eq.{pack_id}', 'creator_id': f'eq.{creator["id"]}', 'limit': '1',
        })
        if not packs:
            raise HTTPException(404, 'Pack não encontrado ou sem permissão.')
        pack = packs[0]

        if pack['status'] not in ('draft',):
            raise HTTPException(400, 'Só packs em rascunho podem ser publicados.')

        # Criar produto no Stripe
        stripe_product_id = pack.get('stripe_product_id')
        stripe_price_id   = pack.get('stripe_price_id')

        if not stripe_product_id:
            try:
                product = stripe.Product.create(
                    name=f'[Pack] {pack["nome"]}',
                    description=pack.get('descricao', '')[:500],
                    metadata={'pack_id': pack_id, 'creator_id': creator['id']},
                )
                price = stripe.Price.create(
                    product=product['id'],
                    unit_amount=int(pack['preco_mensal'] * 100),  # centavos
                    currency='brl',
                    recurring={'interval': 'month'},
                    metadata={'pack_id': pack_id},
                )
                stripe_product_id = product['id']
                stripe_price_id   = price['id']
            except stripe.error.StripeError as e:
                log.error(f'Stripe product creation failed: {e}')
                raise HTTPException(500, f'Erro Stripe: {e}')

        await sb_patch(client, 'marketplace_packs', f'id=eq.{pack_id}', {
            'stripe_product_id': stripe_product_id,
            'stripe_price_id':   stripe_price_id,
            'status':            'review',
            'updated_at':        datetime.utcnow().isoformat(),
        })

    return {
        'message': 'Pack enviado para revisão. Será publicado em até 24h.',
        'stripe_price_id': stripe_price_id,
    }


# ═══════════════════════════════════════════════════════════════════
# TENANT — subscrever packs
# ═══════════════════════════════════════════════════════════════════

@router.post('/subscribe/{pack_id}')
async def subscrever_pack(
    pack_id:       str,
    authorization: Optional[str] = Header(None),
):
    """Tenant inicia checkout Stripe para subscrever um pack."""
    user_id = _verify_jwt(authorization)

    async with httpx.AsyncClient(timeout=15) as client:
        # Buscar tenant
        tenants = await sb_get(client, 'tenants', {'user_id': f'eq.{user_id}', 'limit': '1'})
        if not tenants:
            raise HTTPException(404, 'Tenant não encontrado.')
        tenant = tenants[0]

        # Buscar pack
        packs = await sb_get(client, 'marketplace_packs', {'id': f'eq.{pack_id}', 'status': 'eq.active', 'limit': '1'})
        if not packs:
            raise HTTPException(404, 'Pack não encontrado ou inactivo.')
        pack = packs[0]

        if not pack.get('stripe_price_id'):
            raise HTTPException(400, 'Pack sem preço configurado no Stripe.')

        # Verificar se já subscrito
        existing = await sb_get(client, 'pack_subscriptions', {
            'tenant_id': f'eq.{tenant["id"]}',
            'pack_id':   f'eq.{pack_id}',
            'status':    'eq.active',
            'limit':     '1',
        })
        if existing:
            raise HTTPException(400, 'Já tem uma subscrição activa para este pack.')

        # Buscar criador para application_fee
        creator_rows = await sb_get(client, 'creators', {'id': f'eq.{pack["creator_id"]}', 'limit': '1'})
        creator = creator_rows[0] if creator_rows else {}

        # Criar Checkout Session Stripe com application_fee_percent (30% plataforma)
        session_kwargs = {
            'payment_method_types': ['card'],
            'line_items': [{'price': pack['stripe_price_id'], 'quantity': 1}],
            'mode': 'subscription',
            'success_url': f'{MARKETPLACE_URL}/index.html?sub=success&pack={pack_id}',
            'cancel_url':  f'{MARKETPLACE_URL}/index.html?sub=cancel&pack={pack_id}',
            'metadata': {
                'pack_id':   pack_id,
                'tenant_id': tenant['id'],
                'tipo':      'pack_subscription',
            },
        }

        # Revenue share via Stripe Connect (se criador tem conta Connect)
        if creator.get('stripe_account_id') and creator.get('stripe_onboarded'):
            session_kwargs['payment_intent_data'] = {
                'application_fee_amount': int(pack['preco_mensal'] * 100 * PLATFORM_FEE_PCT),
                'transfer_data': {'destination': creator['stripe_account_id']},
            }

        try:
            session = stripe.checkout.Session.create(**session_kwargs)
        except stripe.error.StripeError as e:
            raise HTTPException(500, f'Erro Stripe: {e}')

        # Registar intenção
        await sb_post(client, 'intention_webhooks', {
            'tenant_id': tenant['id'],
            'pack_id':   pack_id,
            'evento':    'checkout_start',
            'metadata':  {'pack_nome': pack['nome']},
        })

    return {'checkout_url': session['url'], 'session_id': session['id']}


@router.get('/minhas-subscricoes')
async def minhas_subscricoes(authorization: Optional[str] = Header(None)):
    """Lista as subscriptions activas do tenant."""
    user_id = _verify_jwt(authorization)

    async with httpx.AsyncClient(timeout=10) as client:
        tenants = await sb_get(client, 'tenants', {'user_id': f'eq.{user_id}', 'limit': '1'})
        if not tenants:
            raise HTTPException(404, 'Tenant não encontrado.')
        tenant = tenants[0]

        subs = await sb_get(client, 'pack_subscriptions', {
            'tenant_id': f'eq.{tenant["id"]}',
            'status':    'eq.active',
            'select':    'id,pack_id,status,leads_gerados,created_at',
        })

        # Enriquecer com dados do pack
        pack_ids = [s['pack_id'] for s in subs]
        packs_map = {}
        if pack_ids:
            packs = await sb_get(client, 'marketplace_packs', {
                'id':     f'in.({",".join(pack_ids)})',
                'select': 'id,nome,nicho,preco_mensal,cover_emoji',
            })
            packs_map = {p['id']: p for p in packs}
        for s in subs:
            s['pack'] = packs_map.get(s['pack_id'], {})

    return {'subscricoes': subs}


# ═══════════════════════════════════════════════════════════════════
# WEBHOOKS DE INTENÇÃO
# ═══════════════════════════════════════════════════════════════════

@router.post('/webhook/intention')
async def registar_intencao(
    req:           IntencaoReq,
    authorization: Optional[str] = Header(None),
):
    """Regista evento de intenção (view, preview, checkout_start…)."""
    tenant_id = None
    if authorization and authorization.startswith('Bearer '):
        try:
            user_id = _verify_jwt(authorization)
            async with httpx.AsyncClient(timeout=5) as client:
                tenants = await sb_get(client, 'tenants', {'user_id': f'eq.{user_id}', 'limit': '1'})
                if tenants:
                    tenant_id = tenants[0]['id']
        except Exception:
            pass

    async with httpx.AsyncClient(timeout=5) as client:
        await sb_post(client, 'intention_webhooks', {
            'tenant_id': tenant_id,
            'pack_id':   req.pack_id,
            'evento':    req.evento,
            'metadata':  req.metadata,
        })

    return {'ok': True}


# ═══════════════════════════════════════════════════════════════════
# WEBHOOK STRIPE CONNECT
# ═══════════════════════════════════════════════════════════════════

@router.post('/webhook/stripe-connect')
async def webhook_stripe_connect(request: Request):
    """Processa eventos Stripe Connect (pagamentos, payouts)."""
    payload   = await request.body()
    sig       = request.headers.get('stripe-signature', '')

    try:
        event = stripe.Webhook.construct_event(payload, sig, STRIPE_CONNECT_WHSEC)
    except stripe.error.SignatureVerificationError:
        raise HTTPException(400, 'Assinatura Stripe inválida.')

    evt_type = event['type']
    data     = event['data']['object']
    log.info(f'Stripe Connect event: {evt_type}')

    async with httpx.AsyncClient(timeout=15) as client:

        if evt_type == 'checkout.session.completed':
            meta      = data.get('metadata', {})
            pack_id   = meta.get('pack_id')
            tenant_id = meta.get('tenant_id')
            tipo      = meta.get('tipo')

            if tipo == 'pack_subscription' and pack_id and tenant_id:
                # Criar subscription no Supabase
                existing = await sb_get(client, 'pack_subscriptions', {
                    'tenant_id': f'eq.{tenant_id}', 'pack_id': f'eq.{pack_id}', 'limit': '1',
                })
                if not existing:
                    await sb_post(client, 'pack_subscriptions', {
                        'tenant_id':              tenant_id,
                        'pack_id':                pack_id,
                        'stripe_subscription_id': data.get('subscription'),
                        'status':                 'active',
                    })
                else:
                    await sb_patch(client, 'pack_subscriptions',
                                   f'tenant_id=eq.{tenant_id}&pack_id=eq.{pack_id}',
                                   {'status': 'active', 'stripe_subscription_id': data.get('subscription')})

                # Registar intenção subscribed
                await sb_post(client, 'intention_webhooks', {
                    'tenant_id': tenant_id, 'pack_id': pack_id, 'evento': 'subscribed',
                    'metadata': {'session_id': data.get('id')},
                })
                log.info(f'Pack {pack_id} subscrito por tenant {tenant_id}')

        elif evt_type == 'customer.subscription.deleted':
            sub_id = data.get('id')
            if sub_id:
                rows = await sb_get(client, 'pack_subscriptions', {
                    'stripe_subscription_id': f'eq.{sub_id}', 'limit': '1',
                })
                if rows:
                    await sb_patch(client, 'pack_subscriptions',
                                   f'stripe_subscription_id=eq.{sub_id}',
                                   {'status': 'cancelled', 'cancelled_at': datetime.utcnow().isoformat()})

        elif evt_type == 'transfer.created':
            # Registar payout para o criador
            stripe_account = event.get('account')
            if stripe_account:
                creators = await sb_get(client, 'creators', {
                    'stripe_account_id': f'eq.{stripe_account}', 'limit': '1',
                })
                if creators:
                    creator = creators[0]
                    valor_centavos = data.get('amount', 0)
                    valor_criador  = valor_centavos / 100
                    valor_bruto    = valor_criador / (1 - PLATFORM_FEE_PCT)
                    comissao       = valor_bruto * PLATFORM_FEE_PCT

                    await sb_post(client, 'creator_payouts', {
                        'creator_id':          creator['id'],
                        'stripe_transfer_id':  data.get('id'),
                        'valor_bruto':         round(valor_bruto, 2),
                        'comissao_plataforma': round(comissao, 2),
                        'valor_criador':       round(valor_criador, 2),
                        'status':              'transferred',
                    })
                    await sb_patch(client, 'creators', f'id=eq.{creator["id"]}', {
                        'receita_total': creator.get('receita_total', 0) + valor_criador,
                        'updated_at':    datetime.utcnow().isoformat(),
                    })

    return {'received': True}


@router.post('/reviews')
async def avaliar_pack(req: ReviewReq, authorization: Optional[str] = Header(None)):
    """Tenant avalia um pack subscrito."""
    user_id = _verify_jwt(authorization)

    async with httpx.AsyncClient(timeout=10) as client:
        tenants = await sb_get(client, 'tenants', {'user_id': f'eq.{user_id}', 'limit': '1'})
        if not tenants:
            raise HTTPException(404, 'Tenant não encontrado.')
        tenant = tenants[0]

        # Verificar que tem subscription activa
        subs = await sb_get(client, 'pack_subscriptions', {
            'tenant_id': f'eq.{tenant["id"]}', 'pack_id': f'eq.{req.pack_id}',
            'status': 'eq.active', 'limit': '1',
        })
        if not subs:
            raise HTTPException(403, 'Só subscritores activos podem avaliar este pack.')

        review = await sb_post(client, 'pack_reviews', {
            'pack_id':    req.pack_id,
            'tenant_id':  tenant['id'],
            'rating':     req.rating,
            'comentario': req.comentario,
        })

    return {'review': review}
