# MEMORIA_11 — THE SOVEREIGN LAUNCH
> **Versão:** V11 · **Data:** 2026-05-10 · **Arquitecto:** Claude Sonnet 4.6

---

## 1. O Salto da V10 para a V11

A V10 blindou o sistema. A V11 **lança-o ao mundo**. Esta versão resolve as três questões existenciais de qualquer produto B2B: *Quem somos?* (Identidade), *Onde estamos?* (Domínio), *Somos seguros?* (Protecção).

**Antes da V11:** site no ar via IP com porta 8080, sem logo de marca, sem rate limiting, sem auditoria.  
**Depois da V11:** identidade "Neural V" injectada em todo o sistema, protecção de API activa, auditoria de dados completa e motor preditivo de routing de leads.

---

## 2. Os Quatro Pilares do Sovereign Launch

### 2.1 Neural V — Identidade Soberana

**O símbolo:** V geométrico com gradiente Cyber Cyan (#00F0FF) → Deep Purple (#7B2FFF). Nodes neurais nos 3 vértices e 2 midpoints. Conexão horizontal sugerindo inteligência de rede.

**Onde foi injectado:**
- `index.html` — navbar principal do site
- `saas/dashboard.html` — sidebar do dashboard SaaS
- `api/certifica.py` — badge SVG Certifica™ (em dourado premium #C5A028)

**Ficheiro canónico:** `saas/assets/img/logo-neural-v.svg`

### 2.2 Rate Limiting — Fortaleza de API

**Zonas configuradas no nginx:**
| Zone | Limite | Burst | Destino |
|------|--------|-------|---------|
| `api_scraper` | 5 req/min | 2 | `/api/scraper` — custo computacional alto |
| `api_general` | 30 req/min | 10 | `/api/` — todos os endpoints |
| `api_public` | 120 req/min | — | Endpoints públicos |

**Resposta:** HTTP 429 + header `X-RateLimit-Policy` explicando o limite activo.

### 2.3 Audit Log — Rastreabilidade Total

**Tabela `audit_log`:**
- 14 tipos de acção definidos (login, scraper_trigger, lead_create, arbitrage_bid, certifica_emitir, stripe_webhook, predictive_suggest, api_key_rotate, etc.)
- Campos: timestamp ISO, user_id, tenant_id, action, resource, ip_address, user_agent, payload JSONB, resultado
- RLS: apenas service_role pode inserir (imutável para tenants)
- Nginx: formato `audit_vanguard` com latência upstream

### 2.4 Predictive Lead Routing (Match Score MVP)

**Fórmula:**
```
Match Score = 40% nicho_match + 35% taxa_conversao + 15% score_tenant + 10% quota_livre
```

**Endpoints:**
```
GET /api/arbitrage/suggest/{lead_id}         — top-3 tenants por match score
GET /api/arbitrage/suggest/{lead_id}/explain — histórico de matches do lead
```

**Lógica:**
1. Busca lead por ID (nicho, score, cidade)
2. Lista todos os tenants activos (excluindo o tenant que faz a query)
3. Para cada tenant: calcula 4 dimensões de match
4. Ordena descendente, retorna top-3
5. Persiste cada sugestão em `predictive_matches` para futuro retreino

---

## 3. Schema V11 — 2 novas tabelas + 1 função

- `predictive_matches` — histórico de sugestões com match_score, nicho_match, aceite
- `audit_log` — registo imutável de 14 tipos de operação sensível
- `fn_predictive_summary()` — retorna performance de routing por tenant nos últimos 30 dias

---

## 4. Deploy V11 em Produção (EasyPanel)

### Deploy no VPS (já executado)
```
URL actual: http://2.24.65.194:8080
EasyPanel: vanguard/vanguard (COMPOSE) — deploy verde
```

### Para activar domínio `vanguardtech.io`:
```
1. Hostinger DNS → A record → 2.24.65.194
2. EasyPanel → Domínios → Criar → Host: vanguardtech.io → HTTPS ON → Criar
3. EasyPanel gera certificado Let's Encrypt automático
4. Remover porta 8080 do docker-compose.yml (não é mais necessária)
```

### Schema (Supabase SQL Editor):
```sql
\i infra/schema_v11_launch.sql
```

---

## 5. Endpoints V11 (2 novos)

```
GET /api/arbitrage/suggest/{lead_id}         — Predictive Routing: top-3 match
GET /api/arbitrage/suggest/{lead_id}/explain — Histórico de sugestões do lead
```

---

## 6. Arquitectura de Ficheiros V11

```
vanguard/
├── api/
│   ├── main.py          (v11.0.0 — Predictive router registado)
│   ├── predictive.py    (NOVO — Match Score MVP)
│   └── certifica.py     (Neural V logo injectado no badge SVG)
├── infra/
│   ├── schema_v11_launch.sql  (NOVO — 2 tabelas + RLS + função)
│   └── nginx.conf             (Rate Limiting + Audit Log Format)
├── saas/
│   ├── assets/img/logo-neural-v.svg  (NOVO — Logo canónico)
│   └── dashboard.html               (Neural V no sidebar)
├── index.html           (Neural V no navbar)
├── VANGUARD_BUSINESS_RULES.md  (§16 Identidade + §Changelog V11)
├── TODO_FUTURE.md       (V12 backlog actualizado)
├── CLAUDE.md            (CURRENT_VERSION: 11)
└── memorias/MEMORIA_11_LAUNCH.md  (este ficheiro)
```

---

## 7. Impacto no Ecossistema

**Antes da V11:** produto sem identidade visual, acessível por IP bruto, sem protecção de API, sem rastreabilidade, routing de leads manual.  
**Depois da V11:** marca soberana visível em todo o sistema, API protegida por rate limiting inteligente, auditoria de dados completa, motor preditivo que aprende com o histórico.

**Princípio do Sovereign Launch:** *um produto que ninguém vê não existe. Um produto sem identidade não é memorável. Um produto sem segurança não inspira confiança. A V11 resolve os três.*
