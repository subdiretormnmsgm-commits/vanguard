# VANGUARD KNOWLEDGE GRAPH — Mapa Mestre da Arquitectura
> **Versão:** V9 — Sovereign Economy  
> **Última actualização:** 2026-05-09  
> **Propósito:** Verdade absoluta sobre a arquitectura para NotebookLM e sessões futuras.  
> **Arquitecto de IA:** Claude Sonnet 4.6

---

## 1. Visão Geral — O Que é a Vanguard

A Vanguard é uma **Venture Builder Autónoma & Holding de Dados SaaS** com 6 linhas de receita:

| Linha | Produto | Modelo | Status |
|-------|---------|--------|--------|
| 1 | SaaS Multi-Tenant | Subscrição mensal (Stripe) | ✅ V6 |
| 2 | Marketplace de Nichos | Comissão 30% (Stripe Connect) | ✅ V7 |
| 3 | Intelligence API | Pay-per-request + planos | ✅ V8 |
| 4 | Fractal White-Label | MRR revendedores | ✅ V8 |
| 5 | Lead Arbitrage System | Leilão interno 30% comissão | ✅ V9 |
| 6 | Vanguard Maturity Certificate™ | Badge SVG anual €97-297 | ✅ V9 |

---

## 2. Evolução Histórica

```
V1 → PWA Quiz + Diagnóstico (Supabase + Vanilla JS)
V2 → Shadow Closer Lite + Cockpit (leads manuais, quiz IA)
V3 → Scraper Outbound (OSM + Claude Haiku + Supabase inject)
V4 → [não documentado — incrementos intermediários]
V5 → Soberano Digital: Docker Mestre + White-Label brand-config.js + UI Awwwards
V6 → SaaS Multi-Tenant: FastAPI + Stripe Billing + JWT Auth + RLS
V7 → Marketplace Nichos: Stripe Connect 70/30 + Dark Bazaar UI
V8 → Intelligence API: SHA-256 keys + Fractal WL + Sovereign Glass UI
V9 → Sovereign Economy: Lead Arbitrage + Certifica SVG + Hermes Voice + Score™
V7 → Marketplace: Stripe Connect + Dark Bazaar UI + webhooks intenção
V8 → Sovereign Data: Intelligence API + Fractal White-Label + Feed Intenção
```

---

## 3. Arquitectura de Sistema (V8)

```
Internet
    │
    ▼
┌─────────────────────────────────────────────────────┐
│  nginx (Frontend Container)                          │
│  ├── /            → PWA Landing/Quiz (V1-V5 herdado) │
│  ├── /saas/       → SaaS Dashboard PWA (V6)          │
│  ├── /marketplace/→ Dark Bazaar Marketplace (V7)     │
│  ├── /intelligence/→ Sovereign Glass Landing (V8)    │
│  ├── /api/        → proxy → FastAPI :9000            │
│  └── /v1/         → proxy → FastAPI :9000            │
└─────────────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────┐
│  FastAPI API Bridge :9000                            │
│  ├── main.py          (V6 endpoints + lifespan)      │
│  ├── marketplace.py   (V7 router /api/marketplace/)  │
│  ├── intelligence.py  (V8 router /v1/intelligence/)  │
│  └── fractal.py       (V8 router /api/fractal/)      │
└─────────────────────────────────────────────────────┘
                    │
      ┌─────────────┴──────────────┐
      ▼                            ▼
┌───────────────┐        ┌──────────────────┐
│  Supabase     │        │  Stripe          │
│  ├── Auth     │        │  ├── Billing     │
│  ├── DB (PG)  │        │  ├── Connect     │
│  ├── Realtime │        │  └── Webhooks    │
│  └── Storage  │        └──────────────────┘
└───────────────┘
      │
      ▼
┌───────────────┐
│  Scraper IA   │   Claude Haiku (Auditor)
│  (on-demand   │   OpenStreetMap + Places API
│   Docker run) │   → leads_diagnostico
└───────────────┘
      │
      ▼
┌───────────────┐
│  n8n Hermes   │   WhatsApp → Claude Sonnet → resposta
│  :5678        │   Supabase Realtime trigger
└───────────────┘
```

---

## 4. Schema Supabase — Tabelas por Versão

### V1-V3 (Core)
| Tabela | Propósito |
|--------|-----------|
| `leads_diagnostico` | Base central: nome, nicho, cidade, score_digital, ai_hook, gargalo, tenant_id |

### V5 (Soberano)
| Tabela | Propósito |
|--------|-----------|
| `tenants` | Multi-tenant: plano, leads_quota, stripe_customer_id, brand_config |

### V6 (SaaS)
| Tabela | Propósito |
|--------|-----------|
| `tenants` | +stripe_subscription_id, stripe_status, ciclo_reset_em |
| `scraper_jobs` | Jobs: status queued/running/completed/failed, leads_gerados |

### V7 (Marketplace)
| Tabela | Propósito |
|--------|-----------|
| `creators` | Parceiros com stripe_account_id (Connect Express) |
| `marketplace_packs` | config_osm JSONB, config_prompts JSONB, stripe_price_id |
| `pack_subscriptions` | UNIQUE (tenant_id, pack_id), status |
| `pack_reviews` | Rating 1-5 por subscritores activos |
| `intention_webhooks` | Eventos: view, preview, checkout_start, subscribed, scraper_ran |
| `creator_payouts` | Histórico transfers Stripe 70% criador |

### V8 (Intelligence + Fractal)
| Tabela | Propósito |
|--------|-----------|
| `api_keys` | SHA-256 hash, key_prefix vng_live_xxxx, plano, rate limiting |
| `api_usage_logs` | key_id, endpoint, latencia_ms, status_code |
| `sub_tenants` | parent_tenant_id FK, brand_config JSONB, leads_quota partilhada |

### V8 Materialized Views
| View | Dados | Refresh |
|------|-------|---------|
| `mv_intelligence_nicho` | Stats por nicho (score médio, mediana, pct_com_ia) | Horário via fn_refresh |
| `mv_intelligence_tendencias` | Leads 30d por nicho+cidade | Horário |
| `mv_intelligence_empresas` | Score por empresa (nome normalizado) | Horário |

---

## 5. API Endpoints — Mapa Completo

### FastAPI main.py (V6)
```
POST /api/tenant/registar      — cria tenant (Supabase auth)
GET  /api/tenant/me            — tenant + quota + planos
POST /api/scraper/trigger      — dispara scraper (valida quota)
GET  /api/scraper/jobs         — lista jobs
GET  /api/scraper/jobs/{id}    — detalhe job
GET  /api/leads                — leads do tenant
POST /api/stripe/checkout      — Stripe Checkout Session
POST /api/stripe/portal        — Stripe Customer Portal
POST /api/stripe/webhook       — Stripe Webhook
GET  /api/planos               — lista planos (público)
GET  /health                   — healthcheck
```

### marketplace.py (V7)
```
GET  /api/marketplace/packs                    — packs activos (público)
GET  /api/marketplace/packs/{id}               — detalhe pack
POST /api/marketplace/creator/onboard          — Stripe Connect onboarding
GET  /api/marketplace/creator/me               — perfil criador
POST /api/marketplace/creator/packs            — criar pack (draft)
PUT  /api/marketplace/creator/packs/{id}       — actualizar pack
POST /api/marketplace/creator/packs/{id}/publish — publicar (Stripe product)
POST /api/marketplace/subscribe/{pack_id}      — Stripe Checkout + 30% fee
GET  /api/marketplace/minhas-subscricoes       — subscriptions activas
POST /api/marketplace/webhook/intention        — regista evento
POST /api/marketplace/webhook/stripe-connect   — Stripe Connect events
POST /api/marketplace/reviews                  — avaliar pack
```

### intelligence.py (V8)
```
GET /v1/intelligence/status          — estado da API key
GET /v1/intelligence/nichos          — lista nichos indexados
GET /v1/intelligence/nicho/{nicho}   — stats maturidade digital
GET /v1/intelligence/tendencias      — tendências 30d
GET /v1/intelligence/empresa         — lookup empresa (Starter+)
GET /v1/intelligence/cidades         — top cidades por nicho

Auth: header X-Vanguard-Key: vng_live_<prefix>_<token>
Rate limits: free=1000/mês, starter=5000/mês, pro=50000/mês, enterprise=∞
```

### fractal.py (V8)
```
GET    /api/fractal/dashboard               — KPIs do sistema Fractal
POST   /api/fractal/sub-tenants             — criar sub-tenant
GET    /api/fractal/sub-tenants             — listar sub-tenants
GET    /api/fractal/sub-tenants/{id}        — detalhe
PATCH  /api/fractal/sub-tenants/{id}        — actualizar quota/nome
PATCH  /api/fractal/sub-tenants/{id}/brand  — actualizar brand_config
DELETE /api/fractal/sub-tenants/{id}        — desactivar (soft)

Auth: JWT Bearer (Supabase), requer plano pro ou enterprise
```

---

## 6. Ficheiros-Chave por Versão

### V6
| Ficheiro | Propósito |
|----------|-----------|
| `api/main.py` | FastAPI V6 (Stripe + JWT + Scraper trigger) |
| `saas/index.html` | Login/Register SaaS |
| `saas/dashboard.html` | Dashboard multi-secção |
| `saas/assets/js/saas-auth.js` | Supabase auth flow |
| `saas/assets/js/saas-dashboard.js` | KPIs + scraper + leads + planos |
| `infra/schema_v6_saas.sql` | Schema V6 |

### V7
| Ficheiro | Propósito |
|----------|-----------|
| `api/marketplace.py` | Router marketplace (12 endpoints) |
| `marketplace/index.html` | Dark Bazaar browse público |
| `marketplace/creator.html` | Painel do criador |
| `marketplace/assets/css/marketplace.css` | Dark Bazaar CSS |
| `marketplace/assets/js/marketplace.js` | Browse + subscribe + cursor amber |
| `marketplace/assets/js/creator.js` | Onboard + pack CRUD |
| `infra/schema_v7_marketplace.sql` | 6 tabelas + triggers + RLS |
| `memorias/MEMORIA_07_MARKETPLACE.md` | Documentação técnica V7 |

### V8
| Ficheiro | Propósito |
|----------|-----------|
| `api/intelligence.py` | Router Intelligence API (auth SHA-256) |
| `api/fractal.py` | Router Fractal White-Label |
| `intelligence/index.html` | Sovereign Glass landing |
| `intelligence/assets/css/intelligence.css` | Sovereign Glass CSS (navy+lime) |
| `intelligence/assets/js/intelligence.js` | Playground + noise canvas |
| `infra/schema_v8_intelligence.sql` | api_keys + sub_tenants + MVs |
| `memorias/MEMORIA_08_SOVEREIGN.md` | Documentação técnica V8 |
| `VANGUARD_KNOWLEDGE_GRAPH.md` | Este ficheiro — verdade absoluta |
| `TODO_FUTURE.md` | Backlog de V9+ |

---

## 7. Aesthetic Visual por Versão

| Versão | Nome | Fontes | Cores principais |
|--------|------|--------|-----------------|
| V5     | Cyber-Premium | Inter | `#0A0A0A` + `#00F0FF` + `#7B2FFF` |
| V6     | Neural Command Center | DM Mono + Inter | `#080810` + `#00F0FF` + `#7B2FFF` |
| V7     | Dark Bazaar | Cormorant Garamond + IBM Plex Mono | `#0C0C0E` + `#F59E0B` (amber) |
| V8     | Sovereign Glass | Syne + Fira Code + DM Sans | `#040D18` + `#A3FF57` (lime) |

---

## 8. Fluxos Críticos

### Fluxo Scraper (V6+)
```
1. Tenant faz login (Supabase Auth → JWT)
2. Dashboard → POST /api/scraper/trigger {nicho, cidade, limite, modo}
3. API valida quota → cria scraper_job (status: queued)
4. BackgroundTask → docker run vanguard-scraper:v5 --nicho ... --tenant-id ...
5. Scraper: OSM/Places → Claude Haiku (score_digital, gargalo, ai_hook)
6. Scraper → INSERT leads_diagnostico (com tenant_id)
7. job.status → completed
8. Supabase Realtime → dashboard atualiza via postgres_changes
```

### Fluxo Revenue Share Marketplace (V7)
```
1. Tenant clica "Subscrever Pack"
2. POST /api/marketplace/subscribe/{pack_id}
3. Stripe Checkout com:
   - application_fee_amount: preço × 30% (vai para Vanguard)
   - transfer_data.destination: creator.stripe_account_id (70%)
4. Webhook stripe-connect → pack_subscriptions.status = active
5. Tenant vê pack no dashboard → pode usar config do pack no scraper
```

### Fluxo Intelligence API (V8)
```
1. Tenant cria API key no dashboard → SHA-256 hash stored
2. Cliente externo: GET /v1/intelligence/nicho/{nicho}
   Header: X-Vanguard-Key: vng_live_xxxx_<token>
3. FastAPI: lookup key_prefix → compare SHA-256 → check rate limit
4. Query mv_intelligence_nicho (Materialized View pré-computada)
5. Log to api_usage_logs → trigger atualiza requests_mes
6. Response < 30ms
```

### Fluxo Fractal White-Label (V8)
```
1. Tenant Pro cria sub-tenant via dashboard (fractal section)
2. POST /api/fractal/sub-tenants {nome, email, leads_quota, brand_config}
3. Sub-tenant criado com quota cedida do parent
4. Sub-tenant acede ao SaaS com brand_config (cores, logo) do parent
5. Quando sub usa lead → trigger fn_quota_sub_tenant → parent.leads_usados++
```

---

## 9. Variáveis de Ambiente Críticas

```env
# Supabase
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_KEY=eyJ...   # bypass RLS
SUPABASE_JWT_SECRET=jwt...    # validar tokens no FastAPI

# Stripe
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...           # billing V6
STRIPE_CONNECT_WEBHOOK_SECRET=whsec_...  # marketplace V7
STRIPE_PRICE_STARTER=price_...
STRIPE_PRICE_PRO=price_...
STRIPE_PRICE_ENTERPRISE=price_...

# AI
ANTHROPIC_API_KEY=sk-ant-...   # Claude Haiku (scraper) + Claude Sonnet (Hermes)

# URLs
SAAS_URL=https://seudominio.com/saas
MARKETPLACE_URL=https://seudominio.com/marketplace
INTELLIGENCE_URL=https://seudominio.com/intelligence
VANGUARD_API_URL=http://vanguard_api:9000

# Hermes
WA_VERIFY_TOKEN=...
WA_TOKEN=...
WA_PHONE_NUMBER_ID=...
N8N_ENCRYPTION_KEY=...
N8N_USER=admin
N8N_PASSWORD=...
POSTGRES_PASSWORD=...
```

---

## 10. RLS — Isolamento de Dados

Todas as tabelas têm RLS activo. Regras críticas:

| Tabela | Quem vê |
|--------|---------|
| `leads_diagnostico` | Só `tenant_id = auth.uid()` |
| `tenants` | Só `user_id = auth.uid()` |
| `scraper_jobs` | Só `tenant_id = auth.uid()` |
| `marketplace_packs` | Públicos (status=active) ou `creator_id = auth.uid()` |
| `pack_subscriptions` | Só `tenant_id = auth.uid()` |
| `api_keys` | Só `user_id = auth.uid()` |
| `api_usage_logs` | Só se key pertence ao user |
| `sub_tenants` | Só se `parent_tenant_id` pertence ao user |

O `service_role` bypassa RLS para operações da API (insert com tenant_id).

---

*Mapa gerado por Claude Sonnet 4.6 — Arquitecto de IA Supremo — V8 Sovereign Data*
