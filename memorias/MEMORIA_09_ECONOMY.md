# MEMORIA_09 — SOVEREIGN ECONOMY
> **Versão:** V9 · **Data:** 2026-05-09 · **Arquitecto:** Claude Sonnet 4.6

---

## 1. O Salto da V8 para a V9

A V8 criou a **Sovereign Data** (Intelligence API + Fractal White-Label) — a Vanguard passou a ser um data broker com API própria. A V9 fecha o ciclo: os **dados agora têm mercado**. Criámos uma economia soberana onde os leads fluem entre tenants, os melhores negócios recebem certificação pública, e o Hermes faz a primeira chamada telefónica automatizada.

**Antes da V9:** leads presos no silo do tenant que os gerou.  
**Depois da V9:** leads em fluxo, certificação como status symbol, voz como canal de fecho.

---

## 2. Três Pilares da Economia Soberana

### 2.1 Lead Arbitrage System
Marketplace interno para compra/venda de leads entre parceiros Vanguard.

**Mecanismo:**
```
Tenant A gera lead → não atende → lista no mercado
Tenants B, C, D vêem preview (nicho, cidade, score, gargalo — SEM PII)
Lance mínimo = max(preco_base, maior_lance + €0.50)
Leilão fecha → trigger PostgreSQL → regista compra automática
Vanguard retém 30% (Stripe application_fee_amount)
Seller recebe 70% → Stripe Transfer
```

**Privacidade:** A tabela `lead_listings` armazena apenas `preview_nicho`, `preview_cidade`, `preview_score`, `preview_gargalo`. Dados pessoais (nome, telefone, email) só são revelados após compra.

**Ficheiros:** `api/arbitrage.py`, `infra/schema_v9_economy.sql` (tabelas: lead_listings, lead_bids, lead_purchases)

### 2.2 Vanguard Maturity Certificate™
Badge de autoridade digital para empresas com score_digital >= 8.0.

**Níveis:**
| Nível | Score | Cor |
|-------|-------|-----|
| Emerging | 8.0+ | `#9CA3AF` |
| Advanced | 8.5+ | `#3B82F6` |
| Ready | 9.0+ | `#10B981` |
| Elite | 9.5+ | `#F59E0B` |

**Badge SVG:** Gerado em Python puro. Inclui gradiente animado, score circular (stroke-dasharray), nível, empresa, data de expiração e link QR para verificação pública. Cacheable (Cache-Control: public, max-age=3600).

**Embed:** `<img src="/certifica/badge/{token}.svg">` — incorporável em qualquer website.

**Ciclo de vida:** emitido → reivindicado pela empresa → expira em 1 ano → renovável.

**Ficheiros:** `api/certifica.py`, `score/index.html` (microsite Score™)

### 2.3 Hermes Multimodal (Voz + WhatsApp)
Evolução do Hermes de texto para chamadas de voz automatizadas.

**Persona Learning (Claude Haiku):**
- Analisa últimos 30 leads + 10 chamadas do tenant
- Infere: tom (formal/neutro/casual/urgente), tamanho de mensagem, usa_emoji, abertura_padrao, cta_padrao
- Guarda em `hermes_personas` (UNIQUE por tenant)

**Selecção de Variante A/B:**
- Claude Haiku recebe lista de variantes + nicho do lead
- Escolhe a melhor template baseado em taxa_resposta histórica
- Renderiza {nome}, {cidade}, {gargalo}, {ai_hook}

**Voz (Vapi API):**
- Provider: Vapi.ai · Modelo IA: claude-haiku-4-5
- TTS: ElevenLabs (voz personalizada por tenant)
- Script de chamada gerado por Claude baseado na persona do tenant
- Webhook `/api/hermes/voice/webhook` processa transcrição + analisa com Claude
- Sem VAPI_KEY: cria registo com status 'simulada' — nunca falha

**Ficheiros:** `api/hermes_voice.py`, tabelas: hermes_personas, hermes_variants, hermes_voice_calls

---

## 3. Microsite Vanguard Score™

**URL:** `/score/`  
**Aesthetic:** Obsidian Exchange — `#0A0802` + `#C5A028` gold + EB Garamond + JetBrains Mono

**Funcionalidades:**
- Ticker tape de scores em tempo real (CSS animation)
- Pesquisa de empresa por nome (Supabase + fallback demo)
- Gauge animado com stroke-dasharray
- Breakdown de componentes do score com barras animadas
- Percentil visual com marcador deslizante
- Leaderboard sectorial por nicho
- Secção de certificação com preview do badge
- Embed code generator para websites

---

## 4. Schema V9 — Resumo Técnico

**7 novas tabelas:**
- `lead_listings` — marketplace público (preview sem PII)
- `lead_bids` — lances com UNIQUE constraint
- `lead_purchases` — compras com split 30/70
- `certifications` — badges com token único (hex 16B)
- `hermes_personas` — persona por tenant (UNIQUE tenant_id)
- `hermes_variants` — A/B com `taxa_resposta` GENERATED ALWAYS AS
- `hermes_voice_calls` — log de chamadas com análise Claude

**2 triggers:**
- `trg_maior_lance` — actualiza liderança de leilão atomicamente
- `trg_fechar_leilao` — fecha leilão e regista compra automaticamente

**1 função:** `fn_nivel_certificacao(score)` → emerging/advanced/ready/elite

---

## 5. Integrações Técnicas Notáveis

**Stripe Arbitragem:** `application_fee_amount = ROUND(preco * 0.30 * 100)` centavos. Não usa Stripe Connect (V7 pattern) — usa taxa de aplicação directa no Checkout Session.

**SVG em Python puro:** `_gerar_badge_svg()` em `certifica.py` — ~60 linhas de f-string SVG. Sem dependências externas. Inclui animação CSS inline (`stroke-dasharray` do círculo de score).

**Webhook Vapi → Claude:** `voice_webhook()` recebe transcrição → Claude Haiku analisa → guarda `analise_claude` + `proximo_passo` na BD. Completamente assíncrono.

**UPSERT de lances:** `faire_lance()` usa `POST /rest/v1/lead_bids` com `Prefer: resolution=merge-duplicates` — actualiza o lance do mesmo bidder sem duplicar.

---

## 6. Novos Endpoints V9 (total: 17)

```
GET  /api/arbitrage/market
POST /api/arbitrage/listings
POST /api/arbitrage/listings/{id}/bid
POST /api/arbitrage/listings/{id}/buy
POST /api/arbitrage/webhook

POST /api/certifica/emitir/{lead_id}
GET  /api/certifica/meus
POST /api/certifica/reivindicar/{token}
GET  /certifica/verificar/{token}   → HTMLResponse
GET  /certifica/badge/{token}.svg   → SVG (cached)

GET  /api/hermes/persona
POST /api/hermes/persona/analisar
GET  /api/hermes/variantes
POST /api/hermes/variantes
GET  /api/hermes/selecionar/{lead_id}
POST /api/hermes/voice/iniciar
POST /api/hermes/voice/webhook
GET  /api/hermes/performance
```

---

## 7. Configuração V9

**Variáveis de ambiente novas:**
```
VAPI_KEY=vapi_xxxx                    # Vapi.ai — chamadas de voz
VAPI_PHONE_NUMBER_ID=ph_xxxx          # Número de telefone configurado no Vapi
CERTIFICA_URL=https://app.vanguard.pt # Base URL para badges e verificação
ANTHROPIC_API_KEY=sk-ant-xxxx         # Claude Haiku (também usa V8)
```

**Deploy:**
1. SQL: `infra/schema_v9_economy.sql` no Supabase
2. Env: adicionar variáveis V9 ao `.env`
3. `docker compose build api && docker compose up -d api`

---

## 8. Impacto no Modelo de Negócio

**Antes da V9:** 4 linhas de receita (SaaS + Marketplace + Intelligence + Fractal)  
**Depois da V9:** 6 linhas de receita + 2 novos canais de aquisição

**Nova receita estimada (conservadora):**
- Arbitragem: 30% de cada lead vendido (€5-150/lead)
- Certificação: €97-297/ano por empresa certificada
- Voz Hermes: diferenciador que aumenta conversão dos tenants (↑ MRR)

**Efeito de rede:** quanto mais tenants, mais rico o mercado de arbitragem. Flywheel iniciado.

---

## 9. Arquitectura de Ficheiros V9

```
vanguard/
├── api/
│   ├── main.py          (v9.0.0 — 4 novos routers registados)
│   ├── arbitrage.py     (NOVO — Lead Auction Marketplace)
│   ├── certifica.py     (NOVO — SVG Badge + Verificação)
│   ├── hermes_voice.py  (NOVO — Vapi + Persona Learning)
│   ├── intelligence.py  (V8 — mantido)
│   └── fractal.py       (V8 — mantido)
├── score/               (NOVO — Score™ Microsite)
│   ├── index.html
│   └── assets/
│       ├── css/score.css
│       └── js/score.js
├── infra/
│   ├── schema_v9_economy.sql  (NOVO)
│   └── nginx.conf             (actualizado — /score/, /certifica/)
├── saas/
│   ├── dashboard.html         (actualizado — Arbitragem + Hermes nav)
│   └── assets/
│       ├── css/saas.css       (actualizado — V9 components)
│       └── js/saas-dashboard.js (actualizado — V9 functions)
├── docker-compose.yml         (actualizado — V9 env vars)
├── VANGUARD_KNOWLEDGE_GRAPH.md (actualizado — V9)
└── .claude/skills/vanguard-v9-arbitrage.md (NOVO)
```
