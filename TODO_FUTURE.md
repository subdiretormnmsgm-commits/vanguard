# TODO_FUTURE — Backlog Estratégico Vanguard
> **Actualizado:** V13 — 2026-05-10  
> **Metodologia:** ideias ordenadas por impacto × viabilidade

---

## ✅ IMPLEMENTADO — Histórico Completo

### V1–V10
- [x] V1: PWA Quiz + Supabase
- [x] V2: Shadow Closer + Cockpit + Algoritmo Scoring
- [x] V3: Scraper OSM + Claude Haiku + Score Digital 0-10
- [x] V5: Docker Mestre + White-Label brand-config.js + UI Awwwards
- [x] V6: SaaS Multi-Tenant + Stripe Billing + JWT Auth + RLS
- [x] V7: Marketplace + Stripe Connect 70/30 + Dark Bazaar UI
- [x] V8: Intelligence API SHA-256 + Fractal WL + Sovereign Glass + Materialized Views
- [x] V9: Lead Arbitrage + Certifica™ SVG + Hermes Voice Vapi + Score™ Microsite
- [x] V10: Fortress Health Monitor + IA Firefighter + Stress Test + Dashboard Pixel Perfect

### V11 — The Sovereign Launch
- [x] Neural V Logo SVG — injectado em site, dashboard e certificados via `data-nv-logo`
- [x] Rate Limiting nginx — 30r/m geral, 5r/m scraper, 120r/m público
- [x] Audit Log — tabela `audit_log` com 14 tipos de acção + RLS imutável
- [x] Predictive Lead Routing MVP — Match Score 4 dimensões + top-3
- [x] Schema V11 — `predictive_matches` + `audit_log` + `fn_predictive_summary()`
- [x] Business Rules §16 — Identidade e Presença Digital
- [x] Deploy EasyPanel — frontend porta 8080, nginx Traefik proxy

### V12 — Sovereign Ignition Cockpit
- [x] Instant Reality Scanner — URL → Ghost Loader 3.9s → Score 0-10 + Radar 6 eixos + 3 Gargalos
- [x] Motor determinístico por domínio (djb2 hash-seed) — mesmo domínio = mesmo score sempre
- [x] `assets/css/hud.css` — Living HUD 580+ linhas: Ghost Holographics, Bento Grid, shimmer, corner brackets
- [x] Ghost Neural Loader — canvas 20 nodes + edges + glow halos + light sweep (3.9s mínimo)
- [x] Authority Share Card — html2canvas 2.5x PNG para redes sociais
- [x] Closer Machine V1 — Hermes chat contextual + jsPDF Cyber-Premium client-side
- [x] Dashboard Bento Grid — 4 KPIs com status dots pulsantes e bordas animadas
- [x] Business Rules §17 — Scanner, Parceiros Fundadores 50/50, Selos Pioneiros, Closer Machine

### V13 — Global Domination & Viral Traction
- [x] `preview/index.html` — HUD Preview personalizado por `?d=domain` — Isca de Autoridade standalone
- [x] `census/index.html` — Census Engine público: agregação Supabase + ranking sectorial + badge generator
- [x] `js/outbound-engine.js` — Fila Hermes Outbound: mensagens por nicho/gargalo + WhatsApp 1-click
- [x] `js/partnerships.js` — Partnership API UI: agências + API keys + revenue share 20%
- [x] Dashboard V13 — 3 novas secções: Outbound Queue, Censo Global (link), Parcerias
- [x] Business Rules §18 — Protocolo Expansão & Viralidade completo
- [x] Knowledge Graph V13 — Arquitectura actualizada com Census Engine e Partnership API

---

## 🔴 CRÍTICO (V14 — Próximas Operações)

- [ ] **Trojan Outbound Engine** — Envio de vídeo/GIF do HUD personalizado via WhatsApp
  - Gravar screenshot do `/preview/?d=dominio` como GIF animado (puppeteer server-side)
  - Enviar via WhatsApp Business API (não wa.me) com thumbnail do score
  - Taxa de abertura estimada: +35% vs mensagem de texto pura
  - Stack: Node.js + puppeteer + WABA API + n8n trigger

- [ ] **Census Engine Dashboard** — Integrar o Censo directamente no Cockpit (sem página separada)
  - Embed do Census iframe no dashboard autenticado
  - Filtro por data e nicho específico do tenant
  - Export CSV dos dados sectoriais para relatórios de parceiros

- [ ] **Viral Badge Upgrade** — Clique em badge externo inicia scan automático do visitante
  - preview/index.html detecta `document.referrer` → sugere scan do site do visitante
  - Auto-trigger do scanner após 5s de visualização do preview
  - CTA contextual: "O seu site tem potencial maior que este — analise agora"

- [ ] **Hermes Aprendizado Colectivo** — implementação técnica da Cláusula §18.3
  - Trigger Supabase: quando `hermes_variants.taxa_resposta` atinge 50+ respostas por nicho
  - Actualizar `taxa_resposta` global do nicho para todos os tenants
  - Endpoint `/api/hermes/best-variant/{nicho}` → retorna variante com maior conversão no sector

---

## 🟡 ALTA PRIORIDADE (V14)

- [ ] **pg_cron para Materialized View refresh** — views Intelligence desactualizadas após 1h sem trigger manual
- [ ] **Sub-tenant isolated login** — sub-tenants (Fractal) acedem com URL dedicada + brand própria
- [ ] **CORS restrito em produção** — `allow_origins=['*']` deve ser restrito ao domínio em produção
- [ ] **Score™ API Pública** — `GET /v2/score/{nif}` metered billing €0.05/consulta · SDK JS/Python
- [ ] **Incident auto-resolve** — quando serviço volta ao ar após DOWN, criar resolução automática
- [ ] **Vanguard Academy** — tabela `courses`, split 70/30, certificado de conclusão Vanguard™

---

## 🟢 MÉDIA PRIORIDADE (V14–V15)

- [ ] **Predictive Routing — Retreino Automático** — pg_cron semanal recalcula pesos com dados reais
- [ ] **API Keys rotação** — `POST /v1/intelligence/keys/{id}/rotate` sem downtime
- [ ] **Webhook idempotência** — tabela `processed_events` para evitar double-processing Stripe
- [ ] **Audit Log Dashboard** — secção no cockpit com últimos 50 eventos de auditoria do tenant
- [ ] **Fortress Health check periódico** — n8n → `/api/fortress/health` cada 5min → `health_checks_log`

---

## ⚪ BAIXA PRIORIDADE (V15+)

- [ ] **Score™ webhook** — `POST /v2/score/webhook` — notifica quando score de empresa muda >10%
- [ ] **Multi-idioma** — dashboard PT/EN/ES (i18n com JSON files)
- [ ] **Mobile sidebar** — sidebar colapsável em mobile (atualmente `display:none`)
- [ ] **Live Leaderboard Sectorial** — página pública top 10 empresas por nicho em tempo real
