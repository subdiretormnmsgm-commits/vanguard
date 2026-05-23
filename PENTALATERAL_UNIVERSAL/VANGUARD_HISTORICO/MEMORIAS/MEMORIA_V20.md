# MEMÓRIA V20 — Monetization Singularity
**Data:** 2026-05-10
**Tema:** Do laboratório para o mercado — primeiro cliente pagante como única métrica

---

## Arquivos Criados

| Arquivo | Função |
|---------|--------|
| `api/stripe_sentinel.py` | Motor Stripe Sentinel: `/api/stripe/sentinel-checkout` + webhook sync `tenant_subscriptions` (R$97/mês BRL) |
| `.github/workflows/deploy-hostinger.yml` | CI/CD: push master → deploy FTP automático na Hostinger |
| `cockpit/index.html` | Dashboard de Intervenção: Maturity Scores por tenant + botão "Intervir Agora" |
| `cloudflare/intervention-worker.js` | Worker autónomo: escreve flag KV com TTL para Cockpit |
| `infra/schema_v20.sql` | intervention_log + cockpit_dashboard VIEW + índices Stripe |

## Arquivos Modificados

| Arquivo | Alteração |
|---------|-----------|
| `api/main.py` | Regista Stripe Sentinel router |
| `cloudflare/federation-proxy.js` | Intervention Button via KV bus — lê flag e injeta modal agressivo |
| `VANGUARD_INNOVATION_AUDIT.md` | [ID-007] Monetization Singularity registado |

---

## Arquitetura V20

```
STRIPE SENTINEL ENGINE
├── POST /api/stripe/sentinel-checkout
│   ├── Cria Customer Stripe com tenant_id no metadata
│   ├── Cria Checkout Session modo subscription (R$97/mês BRL)
│   └── Retorna checkout_url para redirect
│
├── POST /api/stripe/sentinel-webhook
│   ├── checkout.session.completed → INSERT tenant_subscriptions (active)
│   ├── customer.subscription.deleted → UPDATE status=cancelled
│   ├── customer.subscription.updated → UPDATE status + period_end
│   └── invoice.payment_failed → UPDATE status=past_due

CI/CD HOSTINGER
├── .github/workflows/deploy-hostinger.yml
│   ├── Trigger: push master ou workflow_dispatch
│   ├── Action: SamKirkland/FTP-Deploy-Action
│   ├── Deploy: /public_html/ (exclui api/, NotebookLM/, .claude/, etc.)
│   └── Secrets: FTP_SERVER, FTP_USERNAME, FTP_PASSWORD

COCKPIT DE INTERVENÇÃO
├── cockpit/index.html
│   ├── Stats Bar: tenants, sentinel, MRR, leads FIRE 24h
│   ├── Tenant Grid: Maturity Score + sentinel status por tenant
│   └── Modal: tipo + mensagem + TTL → POST /api/intervention

INTERVENTION BUTTON (KV BUS)
├── Cockpit → POST /api/intervention → intervention-worker.js
│   └── KV.put(intervention:{tenantId}, payload, { expirationTtl: ttl })
│
└── federation-proxy.js (cada request)
    └── KV.get(intervention:{tenantId}) → se activo → HTMLRewriter injeta modal
```

---

## Dívidas Técnicas

| Item | Prioridade | Descrição |
|------|-----------|-----------|
| Stripe Price ID | 🔴 CRÍTICA | Criar produto Neural Sentinel R$97/mês BRL no Dashboard → copiar Price ID → definir `STRIPE_SENTINEL_PRICE_ID` env |
| GitHub Secrets | 🔴 CRÍTICA | Definir FTP_SERVER + FTP_USERNAME + FTP_PASSWORD para activar CI/CD |
| COCKPIT_SECRET | 🟡 MÉDIA | Secret para Intervention Worker (`wrangler secret put COCKPIT_SECRET`) |
| Wrangler deploy | 🟡 MÉDIA | intervention-worker.js não foi deployed ainda |
| MEI/LTDA | 🔴 CRÍTICA | Sem CNPJ a conta Stripe BR não activa |

---

## Fundação Reutilizada

| Activo | Origem | Uso V20 |
|--------|--------|---------|
| `api/stripe_connect.py` | V16 | Padrão de router FastAPI + webhook reutilizado |
| `cloudflare/federation-proxy.js` | V19 | HTMLRewriter + KV lookup extendido |
| `pixel_events_staging` | V16 | Fonte de dados para Maturity Scores no Cockpit |
| `maturity_scores` VIEW | V19 | Alimenta o Cockpit Dashboard |

---

## Estado Comercial ao Fechar V20

- Tenants activos: 0
- MRR: R$0 (Stripe configurado no código, aguarda Price ID + deploy)
- Infraestrutura de produção: pronta (aguarda secrets GitHub + Stripe)
- Próxima acção bloqueante: Eduardo abre MEI → cria conta Stripe BR → cria produto → define env vars

---

## Lições Aprendidas

1. **KV como bus de eventos**: Cloudflare KV com TTL é o mecanismo ideal para comunicação dashboard → Worker sem polling. Latência < 50ms.
2. **Stripe router separado**: Não tocar em `stripe_connect.py` (V16) — criar router independente evita regressões em funcionalidades existentes.
3. **CI/CD exclude list**: FTP deploy da Hostinger precisa de lista explícita de exclusões (api/, .claude/, etc.) para não subir ficheiros sensíveis.
