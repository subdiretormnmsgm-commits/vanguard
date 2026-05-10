# Vanguard V9 — Sovereign Economy Skill

## Contexto do Projecto
Vanguard é uma Venture Builder Autónoma & Holding de Dados SaaS. V9 adiciona a "Sovereign Economy": mercado interno de arbitragem de leads, certificação de maturidade digital (badge SVG), e Hermes multimodal com chamadas de voz automatizadas.

## Arquitectura V9

### Stack
- **Frontend:** Vanilla JS + SPA sem framework · CSS custom com design Cyber-Premium e Obsidian Exchange
- **Backend:** FastAPI Python · 4 routers via factory pattern
- **Dados:** Supabase PostgreSQL + Row Level Security
- **Pagamentos:** Stripe (Checkout Sessions + application_fee_amount 30%)
- **Voz:** Vapi API (Claude Haiku como AI assistant) + ElevenLabs TTS
- **IA:** Claude Haiku (análise de persona, seleção de variante, análise de chamada)

### Novos Ficheiros V9

| Ficheiro | Propósito |
|----------|-----------|
| `infra/schema_v9_economy.sql` | 7 tabelas + 2 triggers + 1 função |
| `api/arbitrage.py` | Lead auction marketplace router |
| `api/certifica.py` | SVG badge + página verificação router |
| `api/hermes_voice.py` | Persona learning + Vapi voice router |
| `score/index.html` | Vanguard Score™ microsite público |
| `score/assets/css/score.css` | Obsidian Exchange aesthetic |
| `score/assets/js/score.js` | Search, leaderboard, gauge animation |

### Schema V9 — Tabelas Críticas

```sql
lead_listings    -- Mercado de leads: preview sem PII, modelo leilao/fixo
lead_bids        -- Lances: UNIQUE(listing_id, bidder_tenant_id), upsert pattern
lead_purchases   -- Compras: buyer/seller, comissao 30%, valor 70%
certifications   -- Badge: badge_token UNIQUE hex(16), score_digital >= 8.0, 1 ano
hermes_personas  -- Persona por tenant: tom, tamanho, CTA, voz_id
hermes_variants  -- A/B: taxa_resposta GENERATED AS (respostas/enviados*100)
hermes_voice_calls -- Log chamadas: transcricao, outcome, analise_claude
```

### Triggers Críticos

```sql
trg_maior_lance   -- AFTER INSERT lead_bids → UPDATE lead_listings.maior_lance (se maior)
trg_fechar_leilao -- AFTER UPDATE lead_listings (auction_ended) → INSERT lead_purchases + UPDATE bids
```

### Lógica de Negócio

**Arbitragem:**
- Tenant lista lead com preview (nicho, cidade, score, gargalo) — sem PII
- Outros tenants vêem o mercado público (policy: `status = 'active'`)
- Lance mínimo = max(preco_base, maior_lance + €0.50)
- Vanguard retém 30% via `application_fee_amount` no Stripe
- `trg_fechar_leilao` trigger regista compra automaticamente ao mudar status

**Certificação:**
- score_digital >= 8.0 (equivale ao percentil 80 — exibido como `score_percentil = ROUND(score * 10)`)
- Níveis: emerging (8.0+), advanced (8.5+), ready (9.0+), elite (9.5+)
- badge_token = `encode(gen_random_bytes(16), 'hex')` — UNIQUE
- SVG gerado em Python puro (sem libs externas), cached 1h
- Reivindicação pública: POST /api/certifica/reivindicar/{token} sem auth

**Hermes Voice:**
- Persona learning: Claude Haiku analisa últimos 30 leads + 10 calls → JSON {tom, tamanho, abertura, cta, insight}
- Template vars: {nome}, {cidade}, {gargalo}, {ai_hook}
- Seleção de variante: Claude Haiku escolhe melhor template para o nicho do lead
- Chamada Vapi: modelo claude-haiku-4-5, voice elevenlabs, script gerado por IA
- Sem VAPI_KEY: status 'simulada', nunca lança erro

### Routers V9 (registados em main.py)

```python
make_arbitrage_router(supabase_url, service_key, stripe_key, saas_url, autenticar_fn, get_tenant_fn)
make_certifica_router(supabase_url, service_key, autenticar_fn, get_tenant_fn)
make_hermes_voice_router(supabase_url, service_key, anthropic_key, vapi_key, autenticar_fn, get_tenant_fn)
```

### Env Vars V9

```bash
VAPI_KEY=              # Vapi.ai API key — Hermes Voice
VAPI_PHONE_NUMBER_ID=  # ID do número de telefone no Vapi
CERTIFICA_URL=         # Base URL para links de verificação (ex: https://app.vanguard.pt)
ANTHROPIC_API_KEY=     # Claude Haiku para análise de persona + chamadas
```

### Aesthetic Design System V9

**Score™ Microsite (Obsidian Exchange):**
- `#0A0802` warm obsidian · `#C5A028` old gold · `#FF4E4E` loss red · `#22C55E` gain green
- Fonts: EB Garamond 700 (display authority) + JetBrains Mono (data precision)
- Visual language: stock exchange terminal + ancient ledger + ticker tape

**Dashboard V9 additions:**
- Nav badges gold `.nav-item__badge--gold`
- Market cards `.market-card--auction` (gold border-left) / `.market-card--fixo` (cyan)
- Voice log `.voice-outcome--{converteu|respondeu|nao_atendeu|voicemail}`

### nginx V9

```nginx
# Score™ microsite
location /score/ { try_files $uri $uri/ /score/index.html; }

# Badges SVG (cached 1h via proxy)
location ~* ^/certifica/badge/.*\.svg$ { proxy_pass http://vanguard_api:9000; }

# Verification pages (no-cache)
location /certifica/ { proxy_pass http://vanguard_api:9000/certifica/; }
```

## Deploy Checklist V9

1. Executar `infra/schema_v9_economy.sql` no Supabase SQL Editor
2. Configurar `.env`: VAPI_KEY, VAPI_PHONE_NUMBER_ID, CERTIFICA_URL, ANTHROPIC_API_KEY
3. `docker compose build && docker compose up -d`
4. Testar: `GET /health` → version: 9.0.0
5. Verificar log: "Lead Arbitrage router registado", "Certifica router registado", "Hermes Voice router registado"
6. Testar score microsite: `/score/`
7. Criar primeira certificação via dashboard → `/certifica/verificar/{token}`
