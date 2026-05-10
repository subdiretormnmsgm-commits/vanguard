# MEMÓRIA 07 — Marketplace de Nichos: Vanguard V7

> **Data:** 2026-05-09  
> **Versão:** V7  
> **Arquitecto:** Claude Sonnet 4.6  
> **Missão:** Transformar o SaaS num marketplace B2B — criadores publicam packs de nicho, tenants subscrevem, revenue share 70/30 automático via Stripe Connect

---

## 1. Arquitectura V7

```
                    ┌───────────────────────────────────────┐
                    │         VANGUARD V7                    │
                    │                                       │
  Browser ─────────►│ nginx                                 │
                    │  ├── /marketplace/  → Dark Bazaar UI  │
                    │  ├── /saas/        → Dashboard V6     │
                    │  └── /api/         → FastAPI V7       │
                    │                                       │
                    │ FastAPI V7                            │
                    │  ├── /api/marketplace/packs            │
                    │  ├── /api/marketplace/creator/*        │
                    │  ├── /api/marketplace/subscribe/{id}   │
                    │  ├── /api/marketplace/webhook/intention│
                    │  └── /api/marketplace/webhook/stripe-connect │
                    └───────────────┬───────────────────────┘
                                    │
                  ┌─────────────────┼───────────────────────┐
                  │                 │                       │
       ┌──────────▼──────┐ ┌───────▼──────┐  ┌────────────▼──────┐
       │  Supabase Cloud  │ │ Stripe Billing│  │ Stripe Connect     │
       │  ├── creators    │ │  ├── Checkout │  │  ├── Express accs  │
       │  ├── mkt_packs   │ │  ├── Portal   │  │  ├── Transfers 70% │
       │  ├── pack_subs   │ │  └── Webhooks │  │  └── Payouts auto  │
       │  ├── reviews     │ └──────────────┘  └────────────────────┘
       │  └── intentions  │
       └─────────────────┘
```

---

## 2. Feature 01 — Schema Supabase V7

**Ficheiro:** `infra/schema_v7_marketplace.sql`

### Novas tabelas

| Tabela | Propósito |
|--------|-----------|
| `creators` | Parceiros com Stripe Connect Express (stripe_account_id) |
| `marketplace_packs` | Packs: config OSM + prompts IA + templates WA + Stripe price |
| `pack_subscriptions` | Subscriptions de tenants a packs (status, leads_gerados) |
| `pack_reviews` | Avaliações 1-5★ por subscritores activos |
| `intention_webhooks` | Eventos de comportamento (view, preview, checkout_start, scraper_ran) |
| `creator_payouts` | Histórico de transfers Stripe (70% criador / 30% plataforma) |

### Triggers automáticos

| Trigger | Acção |
|---------|-------|
| `fn_incrementar_assinantes` | AFTER INSERT/UPDATE pack_subscriptions → +1 em marketplace_packs + creators |
| `fn_decrementar_assinantes` | AFTER UPDATE (cancelled) → -1 |
| `fn_actualizar_rating_pack` | AFTER INSERT pack_reviews → recalcula rating médio |

---

## 3. Feature 02 — API Marketplace

**Ficheiro:** `api/marketplace.py` (FastAPI APIRouter)

### Endpoints

| Método | Endpoint | Auth | Descrição |
|--------|----------|------|-----------|
| GET | `/api/marketplace/packs` | Público | Lista packs activos com filtros |
| GET | `/api/marketplace/packs/{id}` | Público | Detalhe + reviews + incrementa visualizações |
| POST | `/api/marketplace/creator/onboard` | JWT | Regista criador + Stripe Connect onboarding |
| GET | `/api/marketplace/creator/me` | JWT | Perfil + stats + lista de packs |
| POST | `/api/marketplace/creator/packs` | JWT | Criar pack (status: draft) |
| PUT | `/api/marketplace/creator/packs/{id}` | JWT | Actualizar pack |
| POST | `/api/marketplace/creator/packs/{id}/publish` | JWT | Criar produto Stripe + enviar para revisão |
| POST | `/api/marketplace/subscribe/{pack_id}` | JWT | Checkout Stripe + application_fee 30% |
| GET | `/api/marketplace/minhas-subscricoes` | JWT | Subscriptions activas do tenant |
| POST | `/api/marketplace/webhook/intention` | Opcional | Registar evento de intenção |
| POST | `/api/marketplace/webhook/stripe-connect` | Stripe sig | Eventos Connect (pagamentos, payouts) |
| POST | `/api/marketplace/reviews` | JWT | Avaliar pack (só subscritores activos) |

### Revenue Share (Stripe Connect)

```python
# Na criação do checkout:
session_kwargs['payment_intent_data'] = {
    'application_fee_amount': int(preco * 100 * 0.30),  # 30% plataforma
    'transfer_data': {'destination': creator['stripe_account_id']},  # 70% criador
}
```

---

## 4. Feature 03 — UI "Dark Bazaar"

**Ficheiros:**
- `marketplace/index.html` — Browse público
- `marketplace/creator.html` — Painel do criador
- `marketplace/assets/css/marketplace.css` — Dark Bazaar stylesheet
- `marketplace/assets/js/marketplace.js` — Browse + subscribe + cursor
- `marketplace/assets/js/creator.js` — Onboard + pack CRUD

### Aesthetic "Dark Bazaar"

| Token | Valor |
|-------|-------|
| `--bg` | `#0C0C0E` |
| `--amber` | `#F59E0B` (gold premium) |
| `--paper` | `#F0EBE3` (off-white editorial) |
| `--crimson` | `#EF4444` |
| Font display | Cormorant Garamond (drama editorial serif) |
| Font data | IBM Plex Mono |
| Font body | Outfit |
| Cursor | Custom amber dot + ring com `mix-blend-mode: difference` |

**Pack cards** — formato portrait (magazine covers):
- Emoji cover grande, nicho em mono uppercase, nome em Cormorant 1.6rem
- 3 métricas (leads/mês, taxa conversão, score médio IA)
- Hover: `translateY(-8px)` + amber glow shadow + overlay CTA

**Secções:**
1. Hero (2-col): título editorial "O Bazaar da Prospecção" + pack em destaque
2. Featured: scroll horizontal com drag
3. All Packs: grid filtrado por nicho + sort
4. Criadores: agregado por creator com stats
5. Como Funciona: 4 passos numerados com Cormorant huge numbers
6. CTA banner creator

---

## 5. Feature 04 — Scraper Webhooks de Intenção

**Mudanças em `scraper_vanguard.py`:**

```bash
# Novo uso com pack do Marketplace
python scraper_vanguard.py \
  --nicho advocacia \
  --modo osm \
  --tenant-id <uuid> \
  --pack-id <uuid> \
  --pack-config '{"config_osm":{"query":"office=lawyer"},"config_prompts":{"hook_template":"Olá {nome}..."}}'
```

**Novas funcionalidades:**
- `--pack-id`: UUID do pack do marketplace
- `--pack-config`: JSON com `config_osm` e `config_prompts` do pack
- `_enviar_intention_webhook()`: após scraper completar, envia evento `scraper_ran` para `/api/marketplace/webhook/intention`
- Template de hook do pack tem precedência sobre gerador padrão (mas IA hook tem prioridade máxima)

---

## 6. Tabela de Ficheiros V7

| Ficheiro | Tipo | Descrição |
|----------|------|-----------|
| `infra/schema_v7_marketplace.sql` | SQL | 6 novas tabelas + 3 triggers + RLS |
| `api/marketplace.py` | Python | FastAPI router marketplace (12 endpoints) |
| `api/main.py` | Python | +include_router marketplace_router |
| `marketplace/index.html` | HTML | Browse público Dark Bazaar |
| `marketplace/creator.html` | HTML | Painel do criador |
| `marketplace/assets/css/marketplace.css` | CSS | Dark Bazaar stylesheet completo |
| `marketplace/assets/js/marketplace.js` | JS | Browse + subscribe + cursor |
| `marketplace/assets/js/creator.js` | JS | Onboard + pack CRUD |
| `infra/nginx.conf` | nginx | +/marketplace/ route |
| `docker-compose.yml` | YAML | +STRIPE_CONNECT_WEBHOOK_SECRET |
| `.env.example` | Config | +vars Stripe Connect V7 |
| `scraper_vanguard.py` | Python | +--pack-id, --pack-config, intention webhook |

---

## 7. Variáveis de Ambiente V7

```env
# Stripe Connect (Marketplace)
STRIPE_CONNECT_WEBHOOK_SECRET=whsec_...  # separado do webhook billing V6
MARKETPLACE_URL=https://dominio.com/marketplace

# Scraper com pack
VANGUARD_PACK_ID=<uuid-do-pack>          # env var fallback para --pack-id
VANGUARD_API_URL=http://vanguard_api:9000  # URL interna para webhooks
```

---

*Gerado pelo Arquitecto de IA — Claude Sonnet 4.6 — Missão V7 Completa*
