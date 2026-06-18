"""
Vanguard V16 — Sovereign Engine: Stripe Connect & Open Data Exchange
Endpoints para venda de licenças e auditorias unitárias via Stripe Connect.

Modelo de receita:
  - Licença Standard: €49/mês (produto recorrente)
  - Auditoria Unitária: €9 por scan (one-time)
  - Licença Elite (Open Data Exchange): €299/mês (acesso à API de dados)

Stripe Connect (plataforma → connected accounts):
  - Plataforma Vanguard retém 30% de todas as vendas feitas pelos tenants
  - Tenant (agência/consultor) recebe 70% automaticamente via Stripe Transfer
"""

import os

import stripe
from fastapi import APIRouter, Header, HTTPException, Request
from pydantic import BaseModel

router = APIRouter(prefix="/api/v1/stripe", tags=["stripe-connect"])

STRIPE_SECRET_KEY      = os.getenv("STRIPE_SECRET_KEY", "")
STRIPE_WEBHOOK_SECRET  = os.getenv("STRIPE_WEBHOOK_SECRET", "")
STRIPE_PLATFORM_FEE    = 0.30        # 30% para a plataforma Vanguard
SUPABASE_URL           = os.getenv("SUPABASE_URL", "")
SUPABASE_SERVICE_KEY   = os.getenv("SUPABASE_SERVICE_KEY", "")
FRONTEND_URL           = os.getenv("FRONTEND_URL", "https://vanguardtech.io")

stripe.api_key = STRIPE_SECRET_KEY


# ─── Produtos Open Data Exchange ─────────────────────────────────────────────
PRODUCTS = {
    "license_standard": {
        "name": "Vanguard Standard License",
        "price_eur": 4900,          # cents: €49
        "mode": "subscription",
        "description": "Acesso completo ao Cockpit: Scanner, Outbound, Hive Mind",
    },
    "audit_unit": {
        "name": "Vanguard Audit Unitário",
        "price_eur": 900,           # cents: €9
        "mode": "payment",
        "description": "1 auditoria digital completa com relatório PDF Cyber-Premium",
    },
    "license_elite": {
        "name": "Vanguard Open Data Exchange",
        "price_eur": 29900,         # cents: €299
        "mode": "subscription",
        "description": "Acesso à Intelligence API + Pixel Analytics + Sinais de Intenção",
    },
}


class CheckoutRequest(BaseModel):
    product_key: str        # 'license_standard' | 'audit_unit' | 'license_elite'
    tenant_id: str
    customer_email: str
    connected_account_id: str | None = None  # Stripe Connect account do tenant


class ConnectAccountRequest(BaseModel):
    tenant_id: str
    email: str
    country: str = "PT"
    business_name: str


@router.post("/checkout")
async def create_checkout_session(payload: CheckoutRequest) -> dict:
    """
    Cria sessão de checkout Stripe.
    Se connected_account_id fornecido → usa Stripe Connect com application_fee.
    Caso contrário → checkout directo na plataforma.
    """
    if not STRIPE_SECRET_KEY:
        raise HTTPException(503, "Stripe não configurado.")

    product = PRODUCTS.get(payload.product_key)
    if not product:
        raise HTTPException(400, f"Produto inválido: {payload.product_key}")

    application_fee = int(product["price_eur"] * STRIPE_PLATFORM_FEE) \
                      if payload.connected_account_id else None

    session_params: dict = {
        "payment_method_types": ["card"],
        "mode": product["mode"],
        "customer_email": payload.customer_email,
        "success_url": f"{FRONTEND_URL}/checkout/success?session_id={{CHECKOUT_SESSION_ID}}&tenant={payload.tenant_id}",
        "cancel_url":  f"{FRONTEND_URL}/checkout/cancel",
        "metadata": {
            "tenant_id":   payload.tenant_id,
            "product_key": payload.product_key,
            "vanguard_v":  "16",
        },
    }

    if product["mode"] == "subscription":
        # Criar price dinamicamente (ou usar price_id em cache)
        price = stripe.Price.create(
            unit_amount=product["price_eur"],
            currency="eur",
            recurring={"interval": "month"},
            product_data={"name": product["name"]},
        )
        session_params["line_items"] = [{"price": price.id, "quantity": 1}]
        if application_fee:
            session_params["subscription_data"] = {
                "application_fee_percent": STRIPE_PLATFORM_FEE * 100,
                "metadata": {"tenant_id": payload.tenant_id},
            }
    else:
        session_params["line_items"] = [{
            "price_data": {
                "currency": "eur",
                "unit_amount": product["price_eur"],
                "product_data": {"name": product["name"], "description": product["description"]},
            },
            "quantity": 1,
        }]
        if application_fee:
            session_params["payment_intent_data"] = {
                "application_fee_amount": application_fee,
                "transfer_data": {"destination": payload.connected_account_id},
            }

    kwargs = {}
    if payload.connected_account_id:
        kwargs["stripe_account"] = payload.connected_account_id

    session = stripe.checkout.Session.create(**session_params, **kwargs)

    return {
        "checkout_url": session.url,
        "session_id":   session.id,
        "product":      product["name"],
        "amount_eur":   product["price_eur"] / 100,
        "platform_fee_pct": STRIPE_PLATFORM_FEE * 100 if payload.connected_account_id else 0,
    }


@router.post("/connect/onboard")
async def create_connect_account(payload: ConnectAccountRequest) -> dict:
    """
    Cria Stripe Connect Express Account para tenant e retorna link de onboarding.
    O tenant completa o KYC/banking na UI do Stripe.
    """
    if not STRIPE_SECRET_KEY:
        raise HTTPException(503, "Stripe não configurado.")

    account = stripe.Account.create(
        type="express",
        country=payload.country,
        email=payload.email,
        business_profile={"name": payload.business_name},
        capabilities={
            "card_payments": {"requested": True},
            "transfers":     {"requested": True},
        },
        metadata={"tenant_id": payload.tenant_id, "vanguard_v": "16"},
    )

    link = stripe.AccountLink.create(
        account=account.id,
        refresh_url=f"{FRONTEND_URL}/cockpit/connect/retry",
        return_url=f"{FRONTEND_URL}/cockpit/connect/success?account_id={account.id}&tenant={payload.tenant_id}",
        type="account_onboarding",
    )

    return {
        "stripe_account_id": account.id,
        "onboarding_url":    link.url,
        "expires_at":        link.expires_at,
        "tenant_id":         payload.tenant_id,
    }


@router.get("/connect/dashboard/{account_id}")
async def get_express_dashboard(account_id: str) -> dict:
    """Retorna link para o Stripe Express Dashboard do tenant (ver receitas e transferências)."""
    if not STRIPE_SECRET_KEY:
        raise HTTPException(503, "Stripe não configurado.")
    link = stripe.Account.create_login_link(account_id)
    return {"dashboard_url": link.url, "account_id": account_id}


@router.post("/webhook")
async def stripe_webhook(request: Request) -> dict:
    """
    Webhook Stripe: processa eventos de pagamento e subscrição.
    - checkout.session.completed → activa licença no Supabase
    - customer.subscription.deleted → fn_suspend_tenant()
    - invoice.payment_succeeded → fn_reactivate_tenant()
    """
    payload   = await request.body()
    sig_header = request.headers.get("stripe-signature", "")

    try:
        event = stripe.Webhook.construct_event(payload, sig_header, STRIPE_WEBHOOK_SECRET)
    except stripe.error.SignatureVerificationError:
        raise HTTPException(400, "Assinatura inválida.")

    data      = event["data"]["object"]
    tenant_id = (data.get("metadata") or {}).get("tenant_id")

    if event["type"] == "checkout.session.completed" and tenant_id:
        # Subscrição paga → garantir que tenant está activo
        await _call_supabase_rpc("fn_reactivate_tenant", {"p_tenant_id": tenant_id})

    elif event["type"] == "customer.subscription.deleted" and tenant_id:
        # Subscrição cancelada → APAGÃO TÉCNICO
        await _call_supabase_rpc("fn_suspend_tenant", {
            "p_tenant_id": tenant_id,
            "p_reason": "Subscrição Stripe cancelada",
        })

    elif event["type"] == "invoice.payment_failed" and tenant_id:
        # Falha de pagamento → APAGÃO TÉCNICO
        await _call_supabase_rpc("fn_suspend_tenant", {
            "p_tenant_id": tenant_id,
            "p_reason": "Falha no pagamento da factura Stripe",
        })

    elif event["type"] == "invoice.payment_succeeded" and tenant_id:
        # Pagamento retomado → reactivar
        await _call_supabase_rpc("fn_reactivate_tenant", {"p_tenant_id": tenant_id})

    return {"received": True, "event": event["type"]}


async def _call_supabase_rpc(fn: str, params: dict) -> None:
    """Chama função RPC do Supabase via REST."""
    import httpx
    if not SUPABASE_URL or not SUPABASE_SERVICE_KEY:
        return
    async with httpx.AsyncClient(timeout=5.0) as client:
        await client.post(
            f"{SUPABASE_URL}/rest/v1/rpc/{fn}",
            json=params,
            headers={
                "apikey": SUPABASE_SERVICE_KEY,
                "Authorization": f"Bearer {SUPABASE_SERVICE_KEY}",
                "Content-Type": "application/json",
            },
        )
