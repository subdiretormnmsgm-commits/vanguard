#!/usr/bin/env python3
"""
Vanguard V8 — API Bridge (Sovereign Data)
FastAPI: Scraper trigger · Stripe Billing · Auth JWT
       + V7 Marketplace · V8 Intelligence API · V8 Fractal White-Label

Endpoints V8 adicionais:
  GET  /v1/intelligence/nichos          — nichos indexados
  GET  /v1/intelligence/nicho/{nicho}   — stats maturidade digital
  GET  /v1/intelligence/tendencias      — tendências 30d
  GET  /v1/intelligence/empresa         — lookup empresa
  GET  /v1/intelligence/cidades         — top cidades
  GET  /v1/intelligence/status          — estado da API key
  POST /api/fractal/sub-tenants         — criar sub-tenant
  GET  /api/fractal/sub-tenants         — listar sub-tenants
  PATCH /api/fractal/sub-tenants/{id}/brand — actualizar brand

Deploy: uvicorn main:app --host 0.0.0.0 --port 9000
"""

import asyncio
import logging
import os
import subprocess
import uuid
from contextlib import asynccontextmanager
from datetime import datetime
from typing import Optional

import httpx
import stripe
from dotenv import load_dotenv
from fastapi import BackgroundTasks, FastAPI, Header, HTTPException, Request, Response
from fastapi.middleware.cors import CORSMiddleware
from jose import JWTError, jwt
from pydantic import BaseModel, Field

load_dotenv()

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(name)s — %(message)s')
log = logging.getLogger('vanguard-api')

# ─── Configuração ─────────────────────────────────────────────────────────────
SUPABASE_URL         = os.getenv('SUPABASE_URL', '')
SUPABASE_SERVICE_KEY = os.getenv('SUPABASE_SERVICE_KEY', '')
SUPABASE_JWT_SECRET  = os.getenv('SUPABASE_JWT_SECRET', '')
ANTHROPIC_API_KEY    = os.getenv('ANTHROPIC_API_KEY', '')
STRIPE_SECRET_KEY    = os.getenv('STRIPE_SECRET_KEY', '')
STRIPE_WEBHOOK_SECRET= os.getenv('STRIPE_WEBHOOK_SECRET', '')
SAAS_URL             = os.getenv('SAAS_URL', 'http://localhost')
SCRAPER_IMAGE        = os.getenv('SCRAPER_IMAGE', 'vanguard-scraper:v5')
DOCKER_NETWORK       = os.getenv('DOCKER_NETWORK', 'vanguard_soberano_v5')

stripe.api_key = STRIPE_SECRET_KEY

# Mapeamento de planos → preços Stripe + quotas
PLANOS = {
    'starter': {
        'price_id': os.getenv('STRIPE_PRICE_STARTER', ''),
        'quota':    100,
        'label':    'Starter',
        'valor':    '€29/mês',
    },
    'pro': {
        'price_id': os.getenv('STRIPE_PRICE_PRO', ''),
        'quota':    500,
        'label':    'Pro',
        'valor':    '€97/mês',
    },
    'enterprise': {
        'price_id': os.getenv('STRIPE_PRICE_ENTERPRISE', ''),
        'quota':    2000,
        'label':    'Enterprise',
        'valor':    '€297/mês',
    },
}

# ─── Supabase HTTP helper ──────────────────────────────────────────────────────

def _sb_headers() -> dict:
    return {
        'apikey':        SUPABASE_SERVICE_KEY,
        'Authorization': f'Bearer {SUPABASE_SERVICE_KEY}',
        'Content-Type':  'application/json',
        'Prefer':        'return=representation',
    }


async def sb_get(client: httpx.AsyncClient, table: str, params: dict = None) -> list:
    r = await client.get(
        f'{SUPABASE_URL}/rest/v1/{table}',
        params=params or {},
        headers=_sb_headers(),
    )
    r.raise_for_status()
    return r.json()


async def sb_post(client: httpx.AsyncClient, table: str, data: dict) -> dict:
    r = await client.post(
        f'{SUPABASE_URL}/rest/v1/{table}',
        json=data,
        headers=_sb_headers(),
    )
    r.raise_for_status()
    result = r.json()
    return result[0] if isinstance(result, list) and result else result


async def sb_patch(client: httpx.AsyncClient, table: str, filtro: str, data: dict) -> None:
    r = await client.patch(
        f'{SUPABASE_URL}/rest/v1/{table}?{filtro}',
        json=data,
        headers={**_sb_headers(), 'Prefer': 'return=minimal'},
    )
    r.raise_for_status()


async def sb_rpc(client: httpx.AsyncClient, fn: str, params: dict) -> list:
    r = await client.post(
        f'{SUPABASE_URL}/rest/v1/rpc/{fn}',
        json=params,
        headers=_sb_headers(),
    )
    r.raise_for_status()
    return r.json()


# ─── Auth JWT ─────────────────────────────────────────────────────────────────

def verificar_jwt(token: str) -> dict:
    """Valida JWT do Supabase Auth e retorna o payload."""
    try:
        payload = jwt.decode(
            token,
            SUPABASE_JWT_SECRET,
            algorithms=['HS256'],
            options={'verify_aud': False},
        )
        return payload
    except JWTError as e:
        raise HTTPException(status_code=401, detail=f'Token inválido: {e}')


async def get_tenant(client: httpx.AsyncClient, user_id: str) -> dict:
    """Busca o tenant do utilizador autenticado."""
    rows = await sb_get(client, 'tenants', {'user_id': f'eq.{user_id}', 'limit': '1'})
    if not rows:
        raise HTTPException(status_code=404, detail='Tenant não encontrado. Crie a sua conta primeiro.')
    return rows[0]


async def autenticar(authorization: Optional[str]) -> tuple[dict, str]:
    """Extrai Bearer token, valida JWT, retorna (payload, user_id)."""
    if not authorization or not authorization.startswith('Bearer '):
        raise HTTPException(status_code=401, detail='Authorization header obrigatório.')
    token   = authorization.split(' ', 1)[1]
    payload = verificar_jwt(token)
    user_id = payload.get('sub')
    if not user_id:
        raise HTTPException(status_code=401, detail='Token sem user ID.')
    return payload, user_id


# ─── Modelos Pydantic ─────────────────────────────────────────────────────────

class ScraperTriggerReq(BaseModel):
    nicho:  str = Field(..., pattern=r'^(advocacia|estetica|clinica|dentista|contabilidade|imobiliaria|farmacia|restaurante)$')
    cidade: str = Field(..., min_length=2, max_length=80)
    limite: int = Field(10, ge=1, le=50)
    modo:   str = Field('osm', pattern=r'^(demo|osm|places)$')


class RegistoTenantReq(BaseModel):
    nome: str = Field(..., min_length=2, max_length=120)


class CheckoutReq(BaseModel):
    plano: str = Field(..., pattern=r'^(starter|pro|enterprise)$')


# ─── Background task: executar scraper ────────────────────────────────────────

async def executar_scraper_bg(
    job_id:    str,
    tenant_id: str,
    nicho:     str,
    cidade:    str,
    limite:    int,
    modo:      str,
) -> None:
    """Roda o scraper Python em subprocess e actualiza o job no Supabase."""
    log.info(f'Job {job_id[:8]} iniciado — {nicho}/{cidade}/{modo}/{limite}')

    async with httpx.AsyncClient(timeout=10) as client:
        await sb_patch(client, 'scraper_jobs', f'id=eq.{job_id}', {
            'status':      'running',
            'iniciado_em': datetime.utcnow().isoformat(),
        })

    # Montar env vars para o scraper (service key bypassa RLS)
    env = {
        **os.environ,
        'SUPABASE_URL':        SUPABASE_URL,
        'SUPABASE_ANON_KEY':   SUPABASE_SERVICE_KEY,  # service key para inserir com tenant_id
        'ANTHROPIC_API_KEY':   ANTHROPIC_API_KEY,
        'VANGUARD_TENANT_ID':  tenant_id,
    }

    cmd = [
        'docker', 'run', '--rm',
        '--network', DOCKER_NETWORK,
        '-e', f'SUPABASE_URL={SUPABASE_URL}',
        '-e', f'SUPABASE_ANON_KEY={SUPABASE_SERVICE_KEY}',
        '-e', f'ANTHROPIC_API_KEY={ANTHROPIC_API_KEY}',
        '-e', f'VANGUARD_TENANT_ID={tenant_id}',
        SCRAPER_IMAGE,
        '--nicho', nicho,
        '--cidade', cidade,
        '--limite', str(limite),
        '--modo', modo,
        '--tenant-id', tenant_id,
    ]

    leads_gerados = 0
    erro_msg      = None

    try:
        result = await asyncio.get_event_loop().run_in_executor(
            None,
            lambda: subprocess.run(cmd, capture_output=True, text=True, timeout=600)
        )
        log.info(f'Job {job_id[:8]} stdout: {result.stdout[-500:]}')

        if result.returncode == 0:
            # Contar leads gerados contando "✓ Supabase" no stdout
            leads_gerados = result.stdout.count('✓ Supabase')
        else:
            erro_msg = result.stderr[-400:] if result.stderr else 'Erro desconhecido'
            log.error(f'Job {job_id[:8]} falhou: {erro_msg}')

    except subprocess.TimeoutExpired:
        erro_msg = 'Timeout após 10 minutos'
        log.error(f'Job {job_id[:8]} timeout')
    except Exception as e:
        erro_msg = str(e)
        log.error(f'Job {job_id[:8]} erro: {e}')

    status = 'completed' if erro_msg is None else 'failed'

    async with httpx.AsyncClient(timeout=10) as client:
        await sb_patch(client, 'scraper_jobs', f'id=eq.{job_id}', {
            'status':        status,
            'leads_gerados': leads_gerados,
            'erro_msg':      erro_msg,
            'concluido_em':  datetime.utcnow().isoformat(),
        })
        log.info(f'Job {job_id[:8]} {status} — {leads_gerados} leads')


# ─── App ──────────────────────────────────────────────────────────────────────

@asynccontextmanager
async def lifespan(app: FastAPI):
    log.info('Vanguard API Bridge V8 iniciada — Intelligence API + Fractal White-Label.')
    if not SUPABASE_URL:       log.warning('SUPABASE_URL não configurada!')
    if not STRIPE_SECRET_KEY:  log.warning('STRIPE_SECRET_KEY não configurada!')
    if not SUPABASE_JWT_SECRET:log.warning('SUPABASE_JWT_SECRET não configurada!')
    yield
    log.info('API Bridge encerrada.')


app = FastAPI(
    title='Vanguard SaaS API Bridge V8 — Sovereign Data',
    version='8.0.0',
    docs_url='/api/docs',
    redoc_url=None,
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],  # Restringir ao domínio em produção
    allow_credentials=True,
    allow_methods=['*'],
    allow_headers=['*'],
)

# ─── V7: Marketplace router ───────────────────────────────────────────────────
try:
    from marketplace import router as marketplace_router
    app.include_router(marketplace_router, prefix='/api')
    log.info('Marketplace router registado.')
except ImportError as e:
    log.warning(f'marketplace.py não encontrado: {e}')

# ─── V8: Intelligence API router ──────────────────────────────────────────────
try:
    from intelligence import make_intelligence_router
    intelligence_router = make_intelligence_router(SUPABASE_URL, SUPABASE_SERVICE_KEY)
    app.include_router(intelligence_router)
    log.info('Intelligence API router registado (/v1/intelligence/).')
except ImportError as e:
    log.warning(f'intelligence.py não encontrado: {e}')

# ─── V8: Fractal White-Label router ───────────────────────────────────────────
try:
    from fractal import make_fractal_router
    fractal_router = make_fractal_router(
        SUPABASE_URL, SUPABASE_SERVICE_KEY, autenticar, get_tenant
    )
    app.include_router(fractal_router)
    log.info('Fractal White-Label router registado (/api/fractal/).')
except ImportError as e:
    log.warning(f'fractal.py não encontrado: {e}')


# ─── Endpoints: Tenant ────────────────────────────────────────────────────────

@app.post('/api/tenant/registar')
async def registar_tenant(
    req:           RegistoTenantReq,
    authorization: Optional[str] = Header(None),
):
    """Cria registo de tenant para o user autenticado (1ª vez)."""
    _, user_id = await autenticar(authorization)

    async with httpx.AsyncClient(timeout=15) as client:
        # Verificar se já existe
        existente = await sb_get(client, 'tenants', {'user_id': f'eq.{user_id}'})
        if existente:
            return existente[0]

        tenant = await sb_post(client, 'tenants', {
            'user_id':    user_id,
            'nome':       req.nome,
            'email':      '',
            'plano':      'trial',
            'leads_quota': 20,
        })
        log.info(f'Tenant criado: {tenant["id"][:8]} — {req.nome}')
        return tenant


@app.get('/api/tenant/me')
async def get_me(authorization: Optional[str] = Header(None)):
    """Retorna dados do tenant + quota status."""
    _, user_id = await autenticar(authorization)

    async with httpx.AsyncClient(timeout=10) as client:
        tenant = await get_tenant(client, user_id)

        # Verificar quota via função Supabase
        quota = await sb_rpc(client, 'fn_verificar_quota', {'p_tenant_id': tenant['id']})

        return {
            'tenant':   tenant,
            'quota':    quota[0] if quota else None,
            'planos':   {k: {
                'label': v['label'],
                'quota': v['quota'],
                'valor': v['valor'],
                'ativo': k == tenant['plano'],
            } for k, v in PLANOS.items()},
        }


# ─── Endpoints: Scraper ───────────────────────────────────────────────────────

@app.post('/api/scraper/trigger')
async def trigger_scraper(
    req:           ScraperTriggerReq,
    bg:            BackgroundTasks,
    authorization: Optional[str] = Header(None),
):
    """Dispara o scraper para o tenant após validar quota."""
    _, user_id = await autenticar(authorization)

    async with httpx.AsyncClient(timeout=10) as client:
        tenant = await get_tenant(client, user_id)

        # Verificar se o plano está activo
        if tenant['stripe_status'] not in ('active', 'trialing') and tenant['plano'] != 'trial':
            raise HTTPException(402, 'Assinatura inactiva. Actualize o seu plano.')

        # Verificar quota
        quota = await sb_rpc(client, 'fn_verificar_quota', {'p_tenant_id': tenant['id']})
        if not quota or not quota[0]['tem_quota']:
            usados = quota[0]['leads_usados'] if quota else tenant['leads_usados']
            quota_total = quota[0]['leads_quota'] if quota else tenant['leads_quota']
            raise HTTPException(
                429,
                f'Quota esgotada: {usados}/{quota_total} leads usados neste ciclo. '
                f'Actualize o plano ou aguarde o próximo reset.'
            )

        # Garantir que o limite pedido não excede o restante
        restante = quota[0]['restante']
        limite_efectivo = min(req.limite, restante)

        # Criar registo do job
        job = await sb_post(client, 'scraper_jobs', {
            'tenant_id': tenant['id'],
            'nicho':     req.nicho,
            'cidade':    req.cidade,
            'limite':    limite_efectivo,
            'modo':      req.modo,
            'status':    'queued',
        })

    job_id = job['id']
    log.info(f'Job {job_id[:8]} enfileirado — tenant {tenant["id"][:8]}')

    # Disparar scraper em background (não bloqueia a resposta)
    bg.add_task(
        executar_scraper_bg,
        job_id, tenant['id'],
        req.nicho, req.cidade, limite_efectivo, req.modo,
    )

    return {
        'job_id':          job_id,
        'status':          'queued',
        'limite_efectivo': limite_efectivo,
        'restante_apos':   restante - limite_efectivo,
        'mensagem':        f'Scraper em fila: {req.nicho} em {req.cidade} ({limite_efectivo} leads, modo {req.modo})',
    }


@app.get('/api/scraper/jobs')
async def listar_jobs(
    limite: int = 20,
    authorization: Optional[str] = Header(None),
):
    """Lista os jobs do scraper do tenant autenticado."""
    _, user_id = await autenticar(authorization)

    async with httpx.AsyncClient(timeout=10) as client:
        tenant = await get_tenant(client, user_id)
        jobs   = await sb_get(client, 'scraper_jobs', {
            'tenant_id': f'eq.{tenant["id"]}',
            'order':     'created_at.desc',
            'limit':     str(limite),
        })
        return {'jobs': jobs, 'total': len(jobs)}


@app.get('/api/scraper/jobs/{job_id}')
async def get_job(job_id: str, authorization: Optional[str] = Header(None)):
    """Detalhes de um job específico (pertencente ao tenant)."""
    _, user_id = await autenticar(authorization)

    async with httpx.AsyncClient(timeout=10) as client:
        tenant = await get_tenant(client, user_id)
        jobs   = await sb_get(client, 'scraper_jobs', {
            'id':        f'eq.{job_id}',
            'tenant_id': f'eq.{tenant["id"]}',
        })
        if not jobs:
            raise HTTPException(404, 'Job não encontrado')
        return jobs[0]


# ─── Endpoints: Leads ─────────────────────────────────────────────────────────

@app.get('/api/leads')
async def listar_leads(
    limite: int = 50,
    nicho:  Optional[str] = None,
    authorization: Optional[str] = Header(None),
):
    """Lista leads do tenant autenticado (isolamento por tenant_id)."""
    _, user_id = await autenticar(authorization)

    async with httpx.AsyncClient(timeout=15) as client:
        tenant = await get_tenant(client, user_id)
        params = {
            'tenant_id': f'eq.{tenant["id"]}',
            'order':     'created_at.desc',
            'limit':     str(limite),
        }
        if nicho:
            params['nicho'] = f'eq.{nicho}'

        leads = await sb_get(client, 'leads_diagnostico', params)
        return {'leads': leads, 'total': len(leads), 'tenant_id': tenant['id']}


# ─── Endpoints: Stripe Billing ────────────────────────────────────────────────

@app.post('/api/stripe/checkout')
async def criar_checkout(
    req:           CheckoutReq,
    authorization: Optional[str] = Header(None),
):
    """Cria sessão de Checkout Stripe para upgrade de plano."""
    _, user_id = await autenticar(authorization)

    plano_info = PLANOS.get(req.plano)
    if not plano_info or not plano_info['price_id']:
        raise HTTPException(400, f'Plano "{req.plano}" não configurado ou price_id ausente.')

    async with httpx.AsyncClient(timeout=10) as client:
        tenant = await get_tenant(client, user_id)

    try:
        # Obter ou criar customer Stripe
        customer_id = tenant.get('stripe_customer_id')
        if not customer_id:
            customer = stripe.Customer.create(
                email=tenant['email'] or '',
                name=tenant['nome'],
                metadata={'tenant_id': tenant['id'], 'user_id': user_id},
            )
            customer_id = customer.id
            # Persistir customer_id
            async with httpx.AsyncClient(timeout=10) as client:
                await sb_patch(client, 'tenants', f'id=eq.{tenant["id"]}',
                               {'stripe_customer_id': customer_id})

        session = stripe.checkout.Session.create(
            customer=customer_id,
            mode='subscription',
            line_items=[{'price': plano_info['price_id'], 'quantity': 1}],
            success_url=f'{SAAS_URL}/saas/success.html?session_id={{CHECKOUT_SESSION_ID}}',
            cancel_url=f'{SAAS_URL}/saas/dashboard.html?upgrade=cancelled',
            subscription_data={
                'metadata': {'tenant_id': tenant['id'], 'plano': req.plano},
            },
            metadata={'tenant_id': tenant['id'], 'plano': req.plano},
        )
        log.info(f'Checkout criado: {session.id[:16]} — tenant {tenant["id"][:8]} — plano {req.plano}')
        return {'checkout_url': session.url, 'session_id': session.id}

    except stripe.StripeError as e:
        log.error(f'Stripe erro: {e}')
        raise HTTPException(502, f'Erro Stripe: {e.user_message or str(e)}')


@app.post('/api/stripe/portal')
async def criar_portal(authorization: Optional[str] = Header(None)):
    """Cria sessão do Customer Portal Stripe para gerir assinatura."""
    _, user_id = await autenticar(authorization)

    async with httpx.AsyncClient(timeout=10) as client:
        tenant = await get_tenant(client, user_id)

    customer_id = tenant.get('stripe_customer_id')
    if not customer_id:
        raise HTTPException(400, 'Sem assinatura Stripe activa.')

    try:
        session = stripe.billing_portal.Session.create(
            customer=customer_id,
            return_url=f'{SAAS_URL}/saas/dashboard.html',
        )
        return {'portal_url': session.url}
    except stripe.StripeError as e:
        raise HTTPException(502, f'Erro Stripe: {e.user_message or str(e)}')


@app.post('/api/stripe/webhook')
async def stripe_webhook(request: Request):
    """Recebe e processa eventos Stripe (signature verified)."""
    payload = await request.body()
    sig     = request.headers.get('stripe-signature', '')

    try:
        event = stripe.Webhook.construct_event(payload, sig, STRIPE_WEBHOOK_SECRET)
    except stripe.SignatureVerificationError:
        log.warning('Stripe webhook: signature inválida')
        raise HTTPException(400, 'Signature inválida')

    log.info(f'Stripe event: {event["type"]}')

    async with httpx.AsyncClient(timeout=15) as client:

        if event['type'] == 'checkout.session.completed':
            session   = event['data']['object']
            tenant_id = session.get('metadata', {}).get('tenant_id')
            plano     = session.get('metadata', {}).get('plano', 'starter')
            sub_id    = session.get('subscription')

            if tenant_id and plano in PLANOS:
                await sb_patch(client, 'tenants', f'id=eq.{tenant_id}', {
                    'plano':                   plano,
                    'leads_quota':             PLANOS[plano]['quota'],
                    'stripe_subscription_id':  sub_id,
                    'stripe_status':           'active',
                    'leads_usados':            0,
                    'ciclo_reset_em':          (datetime.utcnow().isoformat() + 'Z'),
                })
                log.info(f'Tenant {tenant_id[:8]} activado: plano={plano}')

        elif event['type'] in ('invoice.payment_succeeded',):
            sub       = event['data']['object']
            sub_id    = sub.get('subscription')
            cust_id   = sub.get('customer')
            if sub_id and cust_id:
                # Reset mensal de quota
                rows = await sb_get(client, 'tenants', {'stripe_customer_id': f'eq.{cust_id}'})
                if rows:
                    tenant_id = rows[0]['id']
                    plano     = rows[0]['plano']
                    await sb_patch(client, 'tenants', f'id=eq.{tenant_id}', {
                        'leads_usados':  0,
                        'stripe_status': 'active',
                        'ciclo_reset_em': (datetime.utcnow().isoformat() + 'Z'),
                    })
                    log.info(f'Quota resetada: tenant {tenant_id[:8]}')

        elif event['type'] in ('customer.subscription.deleted', 'customer.subscription.paused'):
            sub     = event['data']['object']
            cust_id = sub.get('customer')
            if cust_id:
                rows = await sb_get(client, 'tenants', {'stripe_customer_id': f'eq.{cust_id}'})
                if rows:
                    await sb_patch(client, 'tenants', f'id=eq.{rows[0]["id"]}', {
                        'stripe_status': 'canceled',
                        'plano':         'trial',
                        'leads_quota':   0,
                    })
                    log.info(f'Assinatura cancelada: {cust_id}')

        elif event['type'] == 'customer.subscription.updated':
            sub     = event['data']['object']
            cust_id = sub.get('customer')
            status  = sub.get('status', 'inactive')
            if cust_id:
                rows = await sb_get(client, 'tenants', {'stripe_customer_id': f'eq.{cust_id}'})
                if rows:
                    await sb_patch(client, 'tenants', f'id=eq.{rows[0]["id"]}', {
                        'stripe_status': status,
                    })

    return Response(status_code=200)


# ─── Health ───────────────────────────────────────────────────────────────────

@app.get('/health')
async def health():
    return {
        'status':  'ok',
        'service': 'Vanguard API Bridge V8 — Sovereign Data',
        'version': '8.0.0',
        'ts':       datetime.utcnow().isoformat(),
        'stripe':   bool(STRIPE_SECRET_KEY),
        'supabase': bool(SUPABASE_URL),
    }


@app.get('/api/planos')
async def listar_planos():
    """Lista planos disponíveis (público)."""
    return {k: {'label': v['label'], 'quota': v['quota'], 'valor': v['valor']}
            for k, v in PLANOS.items()}
