#!/usr/bin/env python3
"""
Vanguard V9 — Lead Arbitrage System
FastAPI Router: /api/arbitrage/

Mercado interno de leads: tenants listam leads não trabalhados para leilão/venda.
Revenue share: 70% vendedor / 30% Vanguard (via Stripe Connect).

Endpoints (JWT obrigatório):
  GET    /api/arbitrage/market           — browse listings activos (público autenticado)
  POST   /api/arbitrage/listings         — listar lead para venda/leilão
  DELETE /api/arbitrage/listings/{id}    — retirar listagem
  GET    /api/arbitrage/listings/minhas  — as minhas listagens
  POST   /api/arbitrage/bid/{listing_id} — fazer lance num leilão
  POST   /api/arbitrage/buy/{listing_id} — compra directa (modelo fixo)
  GET    /api/arbitrage/compras          — leads comprados
  POST   /api/arbitrage/webhook/stripe   — Stripe webhook (confirmar pagamento)
"""

import logging
from datetime import datetime, timedelta
from typing import Optional

import httpx
import stripe
from fastapi import APIRouter, Header, HTTPException, Request, Response
from pydantic import BaseModel, Field

log = logging.getLogger('vanguard-arbitrage')

router = APIRouter(prefix='/api/arbitrage', tags=['Lead Arbitrage'])

COMISSAO_VANGUARD = 0.30  # 30% plataforma


# ─── Modelos ──────────────────────────────────────────────────────────────────

class CriarListingReq(BaseModel):
    lead_id:       str         = Field(..., description='UUID do lead a listar')
    modelo:        str         = Field('leilao', pattern=r'^(leilao|fixo)$')
    preco_base:    float       = Field(5.0, ge=0.5, le=500)
    preco_fixo:    Optional[float] = Field(None, ge=1, le=1000)
    duracao_horas: int         = Field(24, ge=1, le=168, description='Duração do leilão em horas')

    class Config:
        json_schema_extra = {
            'example': {
                'lead_id': 'uuid-do-lead',
                'modelo': 'leilao',
                'preco_base': 10.0,
                'duracao_horas': 48,
            }
        }


class LanceReq(BaseModel):
    valor: float = Field(..., ge=0.5, le=1000, description='Valor do lance em EUR')


# ─── Factory ──────────────────────────────────────────────────────────────────

def make_arbitrage_router(
    supabase_url:    str,
    service_key:     str,
    stripe_key:      str,
    saas_url:        str,
    autenticar_fn,
    get_tenant_fn,
) -> APIRouter:

    stripe.api_key = stripe_key

    sb_hdrs = {
        'apikey':        service_key,
        'Authorization': f'Bearer {service_key}',
        'Content-Type':  'application/json',
        'Prefer':        'return=representation',
    }

    async def _sb_get(table: str, params: dict) -> list:
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.get(f'{supabase_url}/rest/v1/{table}', params=params, headers=sb_hdrs)
            r.raise_for_status()
            return r.json()

    async def _sb_post(table: str, data: dict) -> dict:
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.post(f'{supabase_url}/rest/v1/{table}', json=data, headers=sb_hdrs)
            r.raise_for_status()
            result = r.json()
            return result[0] if isinstance(result, list) and result else result

    async def _sb_patch(table: str, filtro: str, data: dict) -> None:
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.patch(
                f'{supabase_url}/rest/v1/{table}?{filtro}', json=data,
                headers={**sb_hdrs, 'Prefer': 'return=minimal'}
            )
            r.raise_for_status()

    async def _get_tenant_auth(authorization: Optional[str]) -> dict:
        _, user_id = await autenticar_fn(authorization)
        async with httpx.AsyncClient(timeout=10) as c:
            return await get_tenant_fn(c, user_id)

    # ─── Endpoints ────────────────────────────────────────────────────────────

    @router.get('/market')
    async def browse_market(
        nicho:         Optional[str] = None,
        modelo:        Optional[str] = None,
        limit:         int           = 20,
        authorization: Optional[str] = Header(None),
    ):
        """Browse do mercado de leads disponíveis. Mostra apenas preview (sem PII)."""
        await autenticar_fn(authorization)

        params: dict = {
            'status': 'eq.active',
            'order':  'created_at.desc',
            'limit':  str(limit),
            'select': 'id,preview_nicho,preview_cidade,preview_score,preview_gargalo,'
                      'modelo,preco_base,preco_fixo,maior_lance,leilao_termina_em,created_at',
        }
        if nicho:  params['preview_nicho'] = f'eq.{nicho}'
        if modelo: params['modelo']        = f'eq.{modelo}'

        rows = await _sb_get('lead_listings', params)

        # Enriquecer com tempo restante para leilões
        now = datetime.utcnow().isoformat()
        for r in rows:
            if r.get('leilao_termina_em') and r['leilao_termina_em'] > now:
                delta = datetime.fromisoformat(r['leilao_termina_em'].replace('Z','')) - datetime.utcnow()
                r['horas_restantes'] = max(0, int(delta.total_seconds() / 3600))
            else:
                r['horas_restantes'] = 0

        return {
            'listings': rows,
            'total':    len(rows),
            'filtro':   {'nicho': nicho, 'modelo': modelo},
        }

    @router.post('/listings', status_code=201)
    async def criar_listing(
        req:           CriarListingReq,
        authorization: Optional[str] = Header(None),
    ):
        """Lista um lead para venda/leilão. Valida que o lead pertence ao tenant."""
        tenant = await _get_tenant_auth(authorization)

        # Verificar que o lead pertence ao tenant
        leads = await _sb_get('leads_diagnostico', {
            'id':        f'eq.{req.lead_id}',
            'tenant_id': f'eq.{tenant["id"]}',
            'select':    'id,nome,nicho,cidade,score_digital,gargalo',
        })
        if not leads:
            raise HTTPException(404, 'Lead não encontrado ou não pertence ao seu tenant.')

        lead = leads[0]

        # Verificar que o lead não está já listado
        ja_listado = await _sb_get('lead_listings', {
            'lead_id': f'eq.{req.lead_id}',
            'status':  'eq.active',
        })
        if ja_listado:
            raise HTTPException(409, 'Este lead já está listado no mercado.')

        terminada_em = (datetime.utcnow() + timedelta(hours=req.duracao_horas)).isoformat()

        listing = await _sb_post('lead_listings', {
            'tenant_id':       tenant['id'],
            'lead_id':         req.lead_id,
            'preview_nicho':   lead.get('nicho', ''),
            'preview_cidade':  lead.get('cidade', ''),
            'preview_score':   lead.get('score_digital'),
            'preview_gargalo': lead.get('gargalo'),
            'modelo':          req.modelo,
            'preco_base':      req.preco_base,
            'preco_fixo':      req.preco_fixo,
            'maior_lance':     0,
            'leilao_termina_em': terminada_em if req.modelo == 'leilao' else None,
            'expires_at':      terminada_em,
        })

        log.info(f'Lead {req.lead_id[:8]} listado por tenant {tenant["id"][:8]} — {req.modelo}')
        return listing

    @router.get('/listings/minhas')
    async def minhas_listings(authorization: Optional[str] = Header(None)):
        """Lista os leads que o tenant tem no mercado."""
        tenant = await _get_tenant_auth(authorization)
        rows = await _sb_get('lead_listings', {
            'tenant_id': f'eq.{tenant["id"]}',
            'order':     'created_at.desc',
        })
        total_lances = sum(r.get('maior_lance', 0) or 0 for r in rows if r['status'] == 'active')
        return {'listings': rows, 'total': len(rows), 'valor_em_leilao': round(total_lances, 2)}

    @router.delete('/listings/{listing_id}')
    async def retirar_listing(
        listing_id:    str,
        authorization: Optional[str] = Header(None),
    ):
        """Retira o lead do mercado (só se não tiver lances activos)."""
        tenant = await _get_tenant_auth(authorization)

        listings = await _sb_get('lead_listings', {
            'id':        f'eq.{listing_id}',
            'tenant_id': f'eq.{tenant["id"]}',
        })
        if not listings:
            raise HTTPException(404, 'Listagem não encontrada.')

        listing = listings[0]
        if listing.get('maior_lance', 0) > 0:
            raise HTTPException(
                400, 'Não é possível retirar uma listagem com lances activos.'
            )

        await _sb_patch('lead_listings', f'id=eq.{listing_id}', {'status': 'withdrawn'})
        return {'status': 'withdrawn', 'id': listing_id}

    @router.post('/bid/{listing_id}', status_code=201)
    async def fazer_lance(
        listing_id:    str,
        req:           LanceReq,
        authorization: Optional[str] = Header(None),
    ):
        """Faz um lance num leilão de lead."""
        tenant = await _get_tenant_auth(authorization)

        # Carregar listagem
        listings = await _sb_get('lead_listings', {
            'id':     f'eq.{listing_id}',
            'status': 'eq.active',
            'modelo': 'eq.leilao',
        })
        if not listings:
            raise HTTPException(404, 'Leilão não encontrado ou já encerrado.')

        listing = listings[0]

        if listing['tenant_id'] == tenant['id']:
            raise HTTPException(400, 'Não pode fazer lance no seu próprio lead.')

        if listing.get('leilao_termina_em'):
            if listing['leilao_termina_em'] < datetime.utcnow().isoformat():
                raise HTTPException(400, 'Este leilão já terminou.')

        lance_minimo = max(listing['preco_base'], (listing.get('maior_lance') or 0) + 0.50)
        if req.valor < lance_minimo:
            raise HTTPException(
                400, f'Lance mínimo: €{lance_minimo:.2f}. '
                     f'(Maior lance actual: €{listing.get("maior_lance", 0):.2f})'
            )

        # Upsert do lance (um por tenant por listagem)
        existing = await _sb_get('lead_bids', {
            'listing_id':       f'eq.{listing_id}',
            'bidder_tenant_id': f'eq.{tenant["id"]}',
        })

        if existing:
            await _sb_patch('lead_bids', f'id=eq.{existing[0]["id"]}', {
                'valor':  req.valor,
                'status': 'active',
            })
            bid = {**existing[0], 'valor': req.valor}
        else:
            bid = await _sb_post('lead_bids', {
                'listing_id':       listing_id,
                'bidder_tenant_id': tenant['id'],
                'valor':            req.valor,
                'status':           'active',
            })

        log.info(f'Lance €{req.valor} em listing {listing_id[:8]} por tenant {tenant["id"][:8]}')
        return {
            'bid':          bid,
            'posicao':      'lider' if req.valor >= (listing.get('maior_lance', 0) or 0) else 'superado',
            'termina_em':   listing.get('leilao_termina_em'),
        }

    @router.post('/buy/{listing_id}')
    async def compra_direta(
        listing_id:    str,
        authorization: Optional[str] = Header(None),
    ):
        """Compra directa (modelo='fixo'). Cria Stripe Checkout Session."""
        tenant = await _get_tenant_auth(authorization)

        listings = await _sb_get('lead_listings', {
            'id':     f'eq.{listing_id}',
            'status': 'eq.active',
            'modelo': 'eq.fixo',
        })
        if not listings:
            raise HTTPException(404, 'Listing não encontrado ou não disponível para compra directa.')

        listing = listings[0]
        if listing['tenant_id'] == tenant['id']:
            raise HTTPException(400, 'Não pode comprar o seu próprio lead.')

        preco = listing.get('preco_fixo') or listing['preco_base']
        preco_centavos = int(preco * 100)

        try:
            session = stripe.checkout.Session.create(
                mode='payment',
                line_items=[{
                    'price_data': {
                        'currency':     'eur',
                        'unit_amount':  preco_centavos,
                        'product_data': {
                            'name': f'Lead — {listing["preview_nicho"]} em {listing["preview_cidade"]}',
                            'description': f'Score digital: {listing.get("preview_score", "N/A")}/10',
                        },
                    },
                    'quantity': 1,
                }],
                payment_intent_data={
                    'application_fee_amount': int(preco_centavos * COMISSAO_VANGUARD),
                    'metadata': {
                        'listing_id':  listing_id,
                        'buyer_id':    tenant['id'],
                        'seller_id':   listing['tenant_id'],
                        'tipo':        'lead_arbitrage',
                    },
                },
                success_url=f'{saas_url}/dashboard.html?arbitrage=success',
                cancel_url=f'{saas_url}/dashboard.html?arbitrage=cancelled',
                metadata={
                    'listing_id': listing_id,
                    'buyer_id':   tenant['id'],
                    'seller_id':  listing['tenant_id'],
                    'tipo':       'lead_arbitrage',
                },
            )
            return {'checkout_url': session.url, 'session_id': session.id}
        except stripe.StripeError as e:
            raise HTTPException(502, f'Erro Stripe: {e.user_message or str(e)}')

    @router.get('/compras')
    async def minhas_compras(authorization: Optional[str] = Header(None)):
        """Lista os leads comprados pelo tenant no mercado de arbitragem."""
        tenant = await _get_tenant_auth(authorization)
        rows = await _sb_get('lead_purchases', {
            'buyer_tenant_id': f'eq.{tenant["id"]}',
            'status':          'eq.completed',
            'order':           'created_at.desc',
        })
        total_gasto = sum(float(r.get('preco_pago', 0)) for r in rows)
        return {
            'compras':     rows,
            'total':       len(rows),
            'total_gasto': round(total_gasto, 2),
        }

    @router.post('/webhook/stripe')
    async def arbitrage_webhook(request: Request):
        """Webhook Stripe para confirmar pagamentos do mercado de arbitragem."""
        payload = await request.body()
        sig     = request.headers.get('stripe-signature', '')

        try:
            event = stripe.Webhook.construct_event(
                payload, sig,
                stripe.api_key  # Usar webhook secret separado em produção
            )
        except stripe.SignatureVerificationError:
            raise HTTPException(400, 'Signature inválida')

        if event['type'] == 'checkout.session.completed':
            session  = event['data']['object']
            meta     = session.get('metadata', {})
            tipo     = meta.get('tipo', '')

            if tipo == 'lead_arbitrage':
                listing_id = meta.get('listing_id')
                buyer_id   = meta.get('buyer_id')
                seller_id  = meta.get('seller_id')
                preco      = session.get('amount_total', 0) / 100

                if listing_id and buyer_id:
                    # Marcar listagem como vendida
                    await _sb_patch('lead_listings', f'id=eq.{listing_id}', {
                        'status': 'sold',
                    })
                    # Registar compra como completed
                    purchases = await _sb_get('lead_purchases', {
                        'listing_id':       f'eq.{listing_id}',
                        'buyer_tenant_id':  f'eq.{buyer_id}',
                        'status':           'eq.pending',
                    })
                    if purchases:
                        await _sb_patch('lead_purchases', f'id=eq.{purchases[0]["id"]}', {
                            'status':                'completed',
                            'stripe_payment_intent': session.get('payment_intent'),
                            'preco_pago':            preco,
                            'comissao_vanguard':     round(preco * COMISSAO_VANGUARD, 2),
                            'valor_vendedor':        round(preco * (1 - COMISSAO_VANGUARD), 2),
                        })
                    else:
                        await _sb_post('lead_purchases', {
                            'listing_id':            listing_id,
                            'buyer_tenant_id':       buyer_id,
                            'seller_tenant_id':      seller_id,
                            'preco_pago':            preco,
                            'comissao_vanguard':     round(preco * COMISSAO_VANGUARD, 2),
                            'valor_vendedor':        round(preco * (1 - COMISSAO_VANGUARD), 2),
                            'stripe_payment_intent': session.get('payment_intent'),
                            'status':                'completed',
                        })

                    log.info(f'Compra arbitrage confirmada: listing {listing_id[:8]} → buyer {buyer_id[:8]}')

        return Response(status_code=200)

    return router
