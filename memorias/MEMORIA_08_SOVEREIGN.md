# MEMÓRIA 08 — Sovereign Data: Vanguard V8

> **Data:** 2026-05-09  
> **Versão:** V8  
> **Arquitecto:** Claude Sonnet 4.6  
> **Missão:** Intelligence API pública + Fractal White-Label + Neural Command Center Feed + Ancoragem de Conhecimento

---

## 1. O Que Mudou na V8

| Dimensão | V7 (Marketplace) | V8 (Sovereign Data) |
|----------|------------------|---------------------|
| Linhas de receita | 3 (subs + comissão + packs) | 4 (+Intelligence API) |
| Dados | Internos (uso do produto) | Externalizados via API B2B |
| Clientes | Agências/empresas | +Fundos, franquias, aceleradoras |
| White-Label | Não existia | Fractal — revenda com brand própria |
| Dashboard | KPIs + Scraper + Leads | +Feed Intenção + Fractal + API Keys |
| API Surface | /api/ (privado JWT) | +/v1/ (público, API key auth) |

---

## 2. Feature 01 — Schema Supabase V8

**Ficheiro:** `infra/schema_v8_intelligence.sql`

### Novas tabelas

| Tabela | Campos chave |
|--------|-------------|
| `api_keys` | key_hash (SHA-256), key_prefix (vng_live_xxxx), plano (free/starter/pro/enterprise), requests_mes, limite_mes |
| `api_usage_logs` | key_id FK, endpoint, latencia_ms, status_code |
| `sub_tenants` | parent_tenant_id FK, brand_config JSONB, leads_quota, preco_cobrado |

### Materialized Views

| View | Propósito | Índice único |
|------|-----------|-------------|
| `mv_intelligence_nicho` | Stats por nicho (score médio, mediana, pct_com_ia) | nicho |
| `mv_intelligence_tendencias` | Leads 30d por nicho+cidade | nicho, leads_30d DESC |
| `mv_intelligence_empresas` | Score por nome_normalizado | nome_normalizado |

### Triggers

| Trigger | Acção |
|---------|-------|
| `trg_api_usage` | AFTER INSERT api_usage_logs → requests_mes++ + ultimo_uso_em |
| `trg_sub_quota` | AFTER UPDATE sub_tenants (leads_usados++) → parent.leads_usados++ |

---

## 3. Feature 02 — Intelligence API (api/intelligence.py)

**Factory:** `make_intelligence_router(supabase_url, service_key) → APIRouter`

### Auth flow (SHA-256)
```
Header: X-Vanguard-Key: vng_live_abc123_<token_hex>
1. Extrair key_prefix (vng_live_abc123)
2. Lookup api_keys WHERE key_prefix = prefix AND ativo = true
3. SHA-256(full_key) == key_hash → autenticado
4. Check expires_at + requests_mes < limite_mes
5. INSERT api_usage_logs (async, não bloqueia)
```

### Endpoints
```
GET /v1/intelligence/status          → quota, plano, requests usados
GET /v1/intelligence/nichos          → todos os nichos (free)
GET /v1/intelligence/nicho/{nicho}   → stats maturidade + insight automático (free)
GET /v1/intelligence/tendencias      → top mercados 30d, filtro nicho (free)
GET /v1/intelligence/empresa?nome=X  → lookup empresa (Starter+)
GET /v1/intelligence/cidades?nicho=X → top cidades por volume (free)
```

### Insight automático
```python
# _gerar_insight_nicho(data) — exemplo output:
"Nicho com maturidade digital baixa (score médio 3.8/10) — 
 alta oportunidade de captação com proposta de presença digital. 
 71.4% das empresas indexadas têm hook IA gerado."
```

---

## 4. Feature 03 — Fractal White-Label (api/fractal.py)

**Factory:** `make_fractal_router(supabase_url, service_key, autenticar_fn, get_tenant_fn) → APIRouter`

### Regras de negócio
- Só planos `pro` e `enterprise` podem usar o Fractal
- `leads_quota` do sub-tenant ≤ quota restante do parent
- Soft delete (ativo=false) — dados preservados
- Trigger cascata: sub-tenant usa lead → parent.leads_usados++

### brand_config JSONB (default)
```json
{
  "nome": "Agência",
  "primary": "#00F0FF",
  "secondary": "#1A0B2E",
  "accent": "#7B2FFF",
  "bg": "#0A0A0A",
  "logo_url": ""
}
```

### Endpoints
```
GET    /api/fractal/dashboard             → KPIs: sub_tenants activos, quota cedida, MRR, leads
POST   /api/fractal/sub-tenants           → criar (valida quota do parent)
GET    /api/fractal/sub-tenants           → listar (com KPIs agregados)
GET    /api/fractal/sub-tenants/{id}      → detalhe
PATCH  /api/fractal/sub-tenants/{id}      → actualizar nome/quota/email/ativo
PATCH  /api/fractal/sub-tenants/{id}/brand → actualizar brand_config
DELETE /api/fractal/sub-tenants/{id}      → soft delete (ativo=false)
```

---

## 5. Feature 04 — Intelligence Landing "Sovereign Glass"

**Ficheiros:** `intelligence/index.html`, `intelligence/assets/css/intelligence.css`, `intelligence/assets/js/intelligence.js`

### Aesthetic "Sovereign Glass"

| Token | Valor |
|-------|-------|
| `--navy` | `#040D18` (deep navy quase preto) |
| `--lime` | `#A3FF57` (lima frio — contraste máximo) |
| `--cyan` | `#00F0FF` (herança V6 para links) |
| Font display | Syne 800 (angular, tech) |
| Font mono | Fira Code (dados, endpoints) |
| Font body | DM Sans 300 (editorial clean) |
| BG effects | Grid 48px + Scanlines + Noise Canvas (WebGL-free) |
| Botão CTA | Lime sólido + glow `rgba(163,255,87,0.3)` |

### Secções da landing
1. **Hero:** 2-col (copy + terminal animado com dados reais)
2. **Fingerprint numbers:** 6 métricas brutas (50K+, 12 nichos, <30ms...)
3. **Endpoints:** Grid de 6 cards com método, path, plano
4. **Playground:** Controls (endpoint, nicho, key) + output panel com syntax highlight
5. **Pricing:** Free (€0) / Pro (€97) / Enterprise (€497)
6. **CTA final:** Gigantic watermark text + CTA

### JavaScript
- `initNoise()` — canvas com noise animado (opacity 0.04)
- `initCounters()` — IntersectionObserver → contador animado (50k, 12 nichos, 99.9%)
- `executarPlayground()` — demo com respostas sintéticas realistas + syntax highlight JSON
- `buildCurlExample()` — gera curl command actualizado em tempo real

---

## 6. Feature 05 — Neural Command Center V8 (Dashboard Updates)

### Feed de Intenção (dashboard SaaS)
```javascript
// subscribeIntentionFeed() — Realtime postgres_changes
sb.channel('intention-feed')
  .on('postgres_changes', { event: 'INSERT', table: 'intention_webhooks' }, renderIntentionEvent)
  .subscribe()

// renderIntentionEvent(ev) — animação slideIn + tipo colorido
```

### Novas secções no dashboard
- **⬡ Fractal:** KPIs (sub_tenants activos, quota cedida, MRR) + grid de sub-tenants + modal criar
- **◈ API Keys:** Lista keys com prefix, plano, quota usada + botão Gerar Key

### Criação de API Key (client-side SHA-256)
```javascript
const fullKey = `${prefix}_${token}`
const hashBuf = await crypto.subtle.digest('SHA-256', encoder.encode(fullKey))
// Armazena apenas o hash — key real mostrada uma única vez
```

---

## 7. Tabela de Ficheiros V8

| Ficheiro | Tipo | Descrição |
|----------|------|-----------|
| `infra/schema_v8_intelligence.sql` | SQL | 3 tabelas + 3 MVs + 2 triggers + RLS |
| `api/intelligence.py` | Python | Router Intelligence API (SHA-256 auth) |
| `api/fractal.py` | Python | Router Fractal White-Label |
| `api/main.py` | Python | V8 — include intelligence + fractal routers |
| `intelligence/index.html` | HTML | Landing Sovereign Glass |
| `intelligence/assets/css/intelligence.css` | CSS | Sovereign Glass CSS completo |
| `intelligence/assets/js/intelligence.js` | JS | Playground + noise + counters |
| `saas/dashboard.html` | HTML | +Fractal section + API Keys section + Feed |
| `saas/assets/css/saas.css` | CSS | +Feed de intenção + sub-tenant card + api-key-row |
| `saas/assets/js/saas-dashboard.js` | JS | +subscribeIntentionFeed + Fractal + API Keys |
| `infra/nginx.conf` | nginx | +/intelligence/ + /v1/ proxy |
| `docker-compose.yml` | YAML | +V8 env vars |
| `VANGUARD_KNOWLEDGE_GRAPH.md` | Markdown | Arquitectura completa V1-V8 |
| `TODO_FUTURE.md` | Markdown | 17 itens de backlog V9+ |
| `.claude/skills/vanguard-v8-fractal.md` | Skill | Skill file para sessões futuras |

---

## 8. Variáveis de Ambiente V8 (novas)

```env
# V8: Intelligence + Fractal
INTELLIGENCE_URL=https://dominio.com/intelligence
VANGUARD_API_URL=http://vanguard_api:9000  # já existia no V7
```

---

## 9. Checklist de Deploy V8

1. Executar `infra/schema_v8_intelligence.sql` no Supabase SQL Editor
2. Configurar pg_cron para refresh das MVs:
   ```sql
   SELECT cron.schedule('refresh-intelligence', '0 * * * *', 'SELECT fn_refresh_intelligence_views()');
   ```
3. Adicionar vars ao `.env`
4. `docker compose build api && docker compose up -d`
5. Verificar: `curl /health` → version: 8.0.0
6. Verificar: `curl /v1/intelligence/nichos -H "X-Vanguard-Key: ..."` → dados

---

*Gerado pelo Arquitecto de IA — Claude Sonnet 4.6 — Missão V8 Completa*
