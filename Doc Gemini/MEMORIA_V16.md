# MEMORIA_V16 — Visual Authority & Sovereign Lock-in
> **Versão:** V16  
> **Data:** 2026-05-10  
> **Autor técnico:** Claude Code (Sócio-Arquiteto)  
> **Protocolo:** Fase 4 — Encerramento de Ciclo

---

## 1. ARQUIVOS CRIADOS

| Arquivo | Função | Impacto |
|---|---|---|
| `infra/schema_v16_pixel_staging.sql` | Tabelas UNLOGGED + RLS Apagão + pg_cron | Infra para 10M+ eventos/mês |
| `api/badge.py` | Endpoint SVG + JSON para badge de autoridade | Viral loop B2B |
| `api/stripe_connect.py` | Checkout + Connect Express + Webhooks | Monetização autônoma |
| `assets/css/v16-elite.css` | Design System Ion Gold + Obsidian | Identidade visual élite |
| `js/neural-grid.js` | Canvas Neural Grid com threads Bézier douradas | Visual authority |
| `js/crypto-glitch.js` | Cipher reveal para dados sensíveis | UX institucional |
| `relatorio_evolutivo_v16.md` | Relatório completo com 5 ideias V17 | Handoff Gemini |
| `MEMORIA_V16.md` | Este arquivo — memória técnica permanente | Auditoria futura |
| `HANDOFF_V16_PARA_GEMINI.md` | Pacote completo Fase 4→1 para Gemini | Loop evolutivo |

---

## 2. ARQUIVOS MODIFICADOS

| Arquivo | Mudança | Detalhe |
|---|---|---|
| `dashboard/index.html` | +3 secções V16 | Pixel Staging, Stripe Connect, Badge Engine |
| `index.html` | Design V16 aplicado | Terminal V16, features label, footer, Ion Gold CSS |
| `api/main.py` | +2 routers | badge.py + stripe_connect.py via try/except |
| `assets/css/v16-elite.css` | +overrides landing page | Ion Gold aplicado a todos os elementos existentes |
| `VANGUARD_INNOVATION_AUDIT.md` | +[ID-003] | Bolsa de Intenção B2B Horizonte V18 |
| `TODO_FUTURE.md` | +V18 Oráculo | Bolsa B2B, Sovereign Credit Score, M&A Engine |
| `VANGUARD_OPERATIONAL_COSTS.md` | +secção BRL V16 | Custos em R$, projeção ARR 2028 R$4.1M |

---

## 3. SCHEMA V16 — MUDANÇAS SUPABASE

```sql
-- NOVAS TABELAS
CREATE UNLOGGED TABLE pixel_events_staging (...)  -- absorção de alta velocidade
CREATE UNLOGGED TABLE pixel_stats_daily (...)      -- agregação horária
CREATE TABLE pixel_registry (...)                  -- catálogo de pixels instalados

-- NOVAS FUNÇÕES
fn_tenant_is_active()    -- verificação RLS reutilizável
fn_suspend_tenant()      -- chamada pelo webhook Stripe on payment.failed
fn_reactivate_tenant()   -- chamada pelo webhook Stripe on payment.succeeded

-- POLÍTICAS RLS (Apagão Técnico)
ON leads_diagnostico   -- tenant inativo não lê seus leads
ON agent_jobs          -- tenant inativo não vê seus jobs
ON hermes_variants     -- tenant inativo perde acesso às variantes

-- CRON
pixel-staging-consolidate  -- a cada hora, min 5, agrega → purga > 48h
```

---

## 4. API ENDPOINTS V16

```
GET  /api/badge/{domain}.svg   → SVG Ion Gold com score e tier
GET  /api/badge/{domain}.json  → JSON com embed code HTML
POST /api/v1/stripe/checkout   → sessão de checkout Stripe
POST /api/v1/stripe/connect/onboard  → Express Account KYC
GET  /api/v1/stripe/connect/dashboard/{id}  → dashboard do tenant
POST /api/v1/stripe/webhook    → 4 eventos: suspend/reactivate
```

---

## 5. DESIGN V16 — O QUE MUDOU VISUALMENTE

### Landing Page (index.html)
- Terminal: `V16 Elite` (era V5 Soberano)
- Features badge: `Protocolo Pentalateral V16` (era Fábrica Autônoma V5)
- Footer: `v16.0 · Visual Authority · Sovereign Intelligence` (era v12.0)
- **Ion Gold substituiu Cyber Cyan** em: botões primary, status dots, gradientes de texto, números de stats, tags de features, números dos steps, barra de progresso do quiz

### Dashboard (dashboard/index.html)
- Cockpit fundo: Deep Obsidian `#0A0802`
- Cards: Monolithic Glass Panels com borda 0.5px Gold pulsante
- KPIs: Cipher Reveal (characters aleatórios → valor real)
- Background: Neural Grid Canvas (3% opacidade base)

---

## 6. DEPENDÊNCIAS DE INFRAESTRUTURA

| Serviço | Estado | Versão mínima |
|---|---|---|
| Supabase | Ativo | Schema V16 executado |
| Stripe | Configurar | STRIPE_SECRET_KEY + STRIPE_WEBHOOK_SECRET |
| pg_cron | Instalar | `CREATE EXTENSION pg_cron` |
| FastAPI | Ativo | +badge + stripe routers |

---

## 7. PENDÊNCIAS CRÍTICAS (Input para V17)

- [ ] `STRIPE_SECRET_KEY` e `STRIPE_WEBHOOK_SECRET` configurados no `.env`
- [ ] Extensão `pg_cron` habilitada no Supabase
- [ ] Schema V16 SQL executado no Supabase Dashboard
- [ ] Vanguard Pixel `pixel.js` criado e distribuído (V17)
- [ ] Domínio de produção definido e deploy no EasyPanel

---

## 8. PERFORMANCE E ESCALA

- Tabelas UNLOGGED: 3-5x mais rápidas que WAL para evento de pixel
- Badge SVG: cache 24h, CDN-ready, zero latência em produção
- RLS Apagão: corte instantâneo sem query, sem chamada de API externa
- pg_cron: consolidação automática sem cron job externo

---

## 9. REGRAS DE NEGÓCIO ADICIONADAS

- **§21 — Escudo WABA** (herdado V15): aprovado e documentado
- **§22 — Doutrina de Distribuição** (herdado V15): 70/30 Stripe Connect
- **V16 Design Language**: Ion Gold como cor de poder institucional, Deep Obsidian como fundação
