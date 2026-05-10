# MEMÓRIA 06 — SaaS Multi-Tenant: Vanguard Soberano Digital V6

> **Data:** 2026-05-09  
> **Versão:** V6  
> **Arquitecto:** Claude Sonnet 4.6 (Anthropic)  
> **Missão:** Converter o ecossistema num SaaS B2B Multi-Tenant com Stripe Billing, Dashboard PWA e API Bridge REST

---

## 1. Arquitectura Geral V6

```
                 ┌─────────────────────────────────────────────┐
                 │            VANGUARD V6 SaaS                 │
                 │                                             │
  Browser  ─────►│  nginx (80)                                 │
                 │  ├── /           → PWA Marketing (V5)       │
                 │  ├── /saas/      → Dashboard SaaS (V6)      │
                 │  └── /api/       → proxy → FastAPI (9000)   │
                 │                                             │
                 │  FastAPI (9000) — API Bridge                │
                 │  ├── POST /api/scraper/trigger              │
                 │  ├── GET  /api/leads                        │
                 │  ├── POST /api/stripe/checkout              │
                 │  ├── POST /api/stripe/webhook               │
                 │  └── GET  /api/tenant/me                    │
                 │                                             │
                 │  Scraper (docker run on-demand)             │
                 │  └── --tenant-id <uuid>                     │
                 └──────────────────┬──────────────────────────┘
                                    │
                          ┌─────────▼──────────┐
                          │    Supabase Cloud   │
                          │  ├── auth.users     │
                          │  ├── tenants        │
                          │  ├── scraper_jobs   │
                          │  └── leads_diagnostico│
                          └──────────┬──────────┘
                                     │
                          ┌──────────▼──────────┐
                          │    Stripe Billing    │
                          │  ├── Customer Portal │
                          │  ├── Checkout Session│
                          │  └── Webhooks        │
                          └─────────────────────┘
```

---

## 2. Feature 01 — Supabase Multi-Tenant com RLS

**Ficheiro:** `infra/schema_v6_multitenant.sql`

### Tabelas criadas

| Tabela | Propósito |
|--------|-----------|
| `tenants` | Regista cada agência cliente: plano, quota, stripe IDs |
| `scraper_jobs` | Jobs de scraper por tenant — rastreio de status em tempo real |
| `leads_diagnostico.tenant_id` | FK que liga cada lead ao seu tenant |

### Isolamento via RLS

```sql
-- Tenant só vê os seus próprios dados
CREATE POLICY "tenant_ver_proprio"
  ON tenants FOR SELECT TO authenticated
  USING (user_id = auth.uid());

-- Jobs isolados por tenant
CREATE POLICY "jobs_ver_proprio_tenant"
  ON scraper_jobs FOR SELECT TO authenticated
  USING (tenant_id IN (SELECT id FROM tenants WHERE user_id = auth.uid()));
```

### Triggers automáticos

- **`fn_incrementar_quota_tenant`** — AFTER INSERT em `leads_diagnostico` → incrementa `leads_usados`
- **`fn_reset_quota_mensal`** — BEFORE UPDATE em `tenants` → reset automático ao fim do ciclo de 30 dias

### View segura para frontend

```sql
CREATE VIEW v_tenant_dashboard AS
SELECT t.id, t.nome, t.plano, t.leads_usados, t.leads_quota,
       GREATEST(0, t.leads_quota - t.leads_usados) AS leads_restantes,
       ROUND(t.leads_usados::numeric / NULLIF(t.leads_quota,0) * 100, 1) AS pct_usado,
       t.ciclo_reset_em, t.stripe_status, t.ativo, ...
FROM tenants t WHERE t.user_id = auth.uid();
```

---

## 3. Feature 02 — API Bridge FastAPI

**Ficheiros:** `api/main.py`, `api/requirements.txt`, `api/Dockerfile`

### Endpoints

| Método | Endpoint | Função |
|--------|----------|--------|
| POST | `/api/tenant/registar` | Cria tenant após signup Supabase |
| GET | `/api/tenant/me` | Devolve tenant + dashboard stats |
| POST | `/api/scraper/trigger` | Valida quota → cria job → dispara `docker run` |
| GET | `/api/scraper/jobs` | Lista jobs do tenant |
| GET | `/api/scraper/jobs/{id}` | Detalhe de um job |
| GET | `/api/leads` | Leads paginados do tenant |
| POST | `/api/stripe/checkout` | Cria Checkout Session do Stripe |
| POST | `/api/stripe/portal` | Abre Customer Portal do Stripe |
| POST | `/api/stripe/webhook` | Recebe eventos Stripe (billing sync) |
| GET | `/api/planos` | Lista planos e preços |
| GET | `/health` | Health check |

### Auth

JWT validado via `python-jose` com `SUPABASE_JWT_SECRET`. Cada request autenticado extrai `user_id` do token e busca o tenant correspondente.

### Scraper trigger

```python
# Executa o scraper como container Docker isolado
cmd = [
    'docker', 'run', '--rm',
    '--network', DOCKER_NETWORK,
    '-e', f'SUPABASE_URL={SUPABASE_URL}',
    '-e', f'SUPABASE_ANON_KEY={SUPABASE_ANON_KEY}',
    '-e', f'VANGUARD_TENANT_ID={tenant_id}',
    SCRAPER_IMAGE,
    '--nicho', nicho, '--cidade', cidade,
    '--limite', str(limite), '--modo', modo,
    '--tenant-id', tenant_id,
]
```

### Planos Stripe

| Plano | Leads/mês | Stripe Price ID |
|-------|-----------|-----------------|
| Starter | 100 | `STRIPE_PRICE_STARTER` |
| Pro | 500 | `STRIPE_PRICE_PRO` |
| Enterprise | 2000 | `STRIPE_PRICE_ENTERPRISE` |

### Webhook Stripe (eventos tratados)

| Evento | Acção |
|--------|-------|
| `checkout.session.completed` | Activa tenant, define plano e quota |
| `invoice.payment_succeeded` | Reset de quota (ciclo novo) |
| `customer.subscription.deleted` | Cancela plano → `stripe_status = canceled` |
| `customer.subscription.updated` | Actualiza status da subscrição |

---

## 4. Feature 03 — Dashboard PWA SaaS

**Ficheiros:**
- `saas/index.html` — Login page (Supabase Auth)
- `saas/dashboard.html` — Dashboard multi-secção
- `saas/assets/css/saas.css` — "Neural Command Center" (CSS completo)
- `saas/assets/js/saas-auth.js` — Auth + session guard
- `saas/assets/js/saas-dashboard.js` — KPIs, scraper, leads, planos

### Secções do dashboard

1. **Painel** — KPI grid (leads total, jobs activos, restante, score médio IA)
2. **Scraper** — Form de disparo (nicho, cidade, limite slider, modo radio)
3. **Leads** — Tabela paginada com score badge, ia-badge, wa-link, export CSV
4. **Planos** — Plan cards com pricing, upgrade button → Stripe Checkout

### Realtime

```javascript
sb.channel(`jobs-${tenantId}`)
  .on('postgres_changes', { event: '*', table: 'scraper_jobs', filter: `tenant_id=eq.${tenantId}` },
    payload => { /* toast + reload KPIs */ })
  .subscribe();
```

### Aesthetic: Neural Command Center

- **Cores:** `--bg: #080810`, `--cyan: #00F0FF`, `--violet: #7B2FFF`, `--amber: #F59E0B`
- **Fontes:** DM Mono (números/display) + Inter (body)
- **Layout:** CSS Grid `sidebar (240px) + main-content (1fr)`
- **Elementos:** quota bar (cyan→violet gradient), plan badge variants, score badges, ia-badges

---

## 5. Feature 04 — Infra Docker + Nginx

### docker-compose.yml — Novo serviço `api`

```yaml
api:
  build: ./api
  image: vanguard-api:v6
  ports: ['9000:9000']
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock:ro  # para docker run do scraper
  environment:
    - SUPABASE_URL, SUPABASE_SERVICE_KEY, SUPABASE_JWT_SECRET
    - STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET, STRIPE_PRICE_*
    - SCRAPER_IMAGE=vanguard-scraper:v5
    - DOCKER_NETWORK=vanguard_soberano_v5
```

### nginx.conf — Rotas adicionadas

```nginx
location /saas/ {
  try_files $uri $uri/ /saas/index.html;
}

location /api/ {
  proxy_pass http://vanguard_api:9000/api/;
  proxy_read_timeout 120s;
}
```

### scraper_vanguard.py — Argumento `--tenant-id`

```bash
python scraper_vanguard.py --nicho advocacia --modo osm --tenant-id <uuid>
```

- Lê `VANGUARD_TENANT_ID` env var como fallback
- Passa `tenant_id` para `inserir_lead()` → incluído no payload Supabase

---

## 6. Tabela de Ficheiros V6

| Ficheiro | Tipo | Descrição |
|----------|------|-----------|
| `infra/schema_v6_multitenant.sql` | SQL | Migração DB completa: tenants + jobs + RLS |
| `api/main.py` | Python | FastAPI API Bridge (400+ linhas) |
| `api/requirements.txt` | Config | fastapi, stripe, supabase, python-jose |
| `api/Dockerfile` | Docker | Python 3.11-slim, porta 9000 |
| `saas/index.html` | HTML | Login page Supabase Auth |
| `saas/dashboard.html` | HTML | Dashboard multi-secção |
| `saas/assets/css/saas.css` | CSS | Neural Command Center stylesheet |
| `saas/assets/js/saas-auth.js` | JS | Auth + session guard + signup |
| `saas/assets/js/saas-dashboard.js` | JS | Dashboard lógica completa |
| `docker-compose.yml` | YAML | +serviço `api` V6 |
| `infra/nginx.conf` | nginx | +/saas/ +/api/ proxy |
| `scraper_vanguard.py` | Python | +--tenant-id, +VANGUARD_TENANT_ID |

---

## 7. Variáveis de Ambiente Necessárias (V6)

```env
# Supabase
SUPABASE_URL=https://<project>.supabase.co
SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_KEY=eyJ...   # service_role bypassa RLS
SUPABASE_JWT_SECRET=<jwt-secret-do-supabase>

# Stripe
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_PRICE_STARTER=price_...
STRIPE_PRICE_PRO=price_...
STRIPE_PRICE_ENTERPRISE=price_...

# SaaS
SAAS_URL=https://yourdomain.com/saas
```

---

*Gerado pelo Arquitecto de IA — Claude Sonnet 4.6 — Missão V6 Completa*
