"""
Vanguard V20 — Monetization Singularity: Stripe Sentinel Engine
Endpoint: POST /api/stripe/sentinel-checkout  → Checkout Neural Sentinel R$97/mês
Webhook:  POST /api/stripe/sentinel-webhook   → sincroniza tenant_subscriptions
"""

import os
import httpx
import stripe
from fastapi import APIRouter, Header, HTTPException, Request, Response
from pydantic import BaseModel

router = APIRouter(prefix="/api/stripe", tags=["sentinel"])

STRIPE_SECRET_KEY       = os.getenv("STRIPE_SECRET_KEY", "")
STRIPE_SENTINEL_WEBHOOK = os.getenv("STRIPE_SENTINEL_WEBHOOK_SECRET", "")
SUPABASE_URL            = os.getenv("SUPABASE_URL", "")
SUPABASE_SERVICE_KEY    = os.getenv("SUPABASE_SERVICE_KEY", "")
FRONTEND_URL            = os.getenv("FRONTEND_URL", "https://vanguard.tech")

# Price ID criado no Stripe Dashboard (R$97/mês BRL)
# Criar em: Stripe Dashboard → Products → Neural Sentinel → R$97 recurring BRL
SENTINEL_PRICE_ID = os.getenv("STRIPE_SENTINEL_PRICE_ID", "")

stripe.api_key = STRIPE_SECRET_KEY


def _sb_headers() -> dict:
    return {
        "apikey":        SUPABASE_SERVICE_KEY,
        "Authorization": f"Bearer {SUPABASE_SERVICE_KEY}",
        "Content-Type":  "application/json",
        "Prefer":        "return=minimal",
    }


class SentinelCheckoutRequest(BaseModel):
    tenant_id:      str
    customer_email: str
    customer_name:  str = ""


@router.post("/sentinel-checkout")
async def sentinel_checkout(payload: SentinelCheckoutRequest) -> dict:
    """
    Cria sessão de Checkout Stripe para Neural Sentinel R$97/mês.
    Após pagamento, webhook sincroniza tenant_subscriptions.
    """
    if not STRIPE_SECRET_KEY:
        raise HTTPException(503, "Stripe não configurado. Defina STRIPE_SECRET_KEY.")

    if not SENTINEL_PRICE_ID:
        raise HTTPException(503, "STRIPE_SENTINEL_PRICE_ID não configurado no ambiente.")

    try:
        customer = stripe.Customer.create(
            email=payload.customer_email,
            name=payload.customer_name or payload.tenant_id,
            metadata={"tenant_id": payload.tenant_id, "vanguard_v": "20"},
        )

        session = stripe.checkout.Session.create(
            customer=customer.id,
            mode="subscription",
            line_items=[{"price": SENTINEL_PRICE_ID, "quantity": 1}],
            success_url=(
                f"{FRONTEND_URL}/checkout/success"
                f"?session_id={{CHECKOUT_SESSION_ID}}&tenant={payload.tenant_id}"
            ),
            cancel_url=f"{FRONTEND_URL}/?checkout=cancelled",
            subscription_data={
                "metadata": {
                    "tenant_id": payload.tenant_id,
                    "plan":      "neural_sentinel_97",
                },
            },
            metadata={
                "tenant_id": payload.tenant_id,
                "plan":      "neural_sentinel_97",
            },
        )

        return {
            "checkout_url":  session.url,
            "session_id":    session.id,
            "customer_id":   customer.id,
            "tenant_id":     payload.tenant_id,
            "plan":          "neural_sentinel_97",
            "amount_brl":    97.00,
        }

    except stripe.StripeError as e:
        raise HTTPException(502, f"Stripe erro: {getattr(e, 'user_message', str(e))}")


@router.post("/sentinel-webhook")
async def sentinel_webhook(request: Request) -> Response:
    """
    Webhook Stripe para eventos do Neural Sentinel.
    Sincroniza tenant_subscriptions após pagamento / cancelamento.
    """
    payload    = await request.body()
    sig_header = request.headers.get("stripe-signature", "")

    try:
        event = stripe.Webhook.construct_event(payload, sig_header, STRIPE_SENTINEL_WEBHOOK)
    except stripe.SignatureVerificationError:
        raise HTTPException(400, "Assinatura Stripe inválida.")

    obj       = event["data"]["object"]
    tenant_id = (obj.get("metadata") or {}).get("tenant_id")

    if not tenant_id:
        return Response(status_code=200)

    async with httpx.AsyncClient(timeout=10) as client:

        if event["type"] == "checkout.session.completed":
            sub_id      = obj.get("subscription")
            customer_id = obj.get("customer")

            # Upsert em tenant_subscriptions
            await client.post(
                f"{SUPABASE_URL}/rest/v1/tenant_subscriptions",
                json={
                    "tenant_id":          tenant_id,
                    "stripe_customer_id": customer_id,
                    "stripe_sub_id":      sub_id,
                    "plan":               "neural_sentinel_97",
                    "status":             "active",
                },
                headers={**_sb_headers(), "Prefer": "resolution=merge-duplicates,return=minimal"},
            )

        elif event["type"] == "customer.subscription.deleted":
            sub_id = obj.get("id")
            await client.patch(
                f"{SUPABASE_URL}/rest/v1/tenant_subscriptions"
                f"?stripe_sub_id=eq.{sub_id}",
                json={"status": "cancelled"},
                headers=_sb_headers(),
            )

        elif event["type"] == "customer.subscription.updated":
            sub_id  = obj.get("id")
            status  = obj.get("status", "active")
            period  = obj.get("current_period_end")
            patch   = {"status": status}
            if period:
                from datetime import datetime, timezone
                patch["current_period_end"] = datetime.fromtimestamp(
                    period, tz=timezone.utc
                ).isoformat()
            await client.patch(
                f"{SUPABASE_URL}/rest/v1/tenant_subscriptions"
                f"?stripe_sub_id=eq.{sub_id}",
                json=patch,
                headers=_sb_headers(),
            )

        elif event["type"] == "invoice.payment_failed":
            sub_id = obj.get("subscription")
            if sub_id:
                await client.patch(
                    f"{SUPABASE_URL}/rest/v1/tenant_subscriptions"
                    f"?stripe_sub_id=eq.{sub_id}",
                    json={"status": "past_due"},
                    headers=_sb_headers(),
                )

    return Response(status_code=200)
