# TODO_FUTURE — Backlog V9+
> Catalogação rigorosa do que a velocidade da V8 obrigou a adiar.
> Ordenado por impacto estimado.

---

## CRÍTICO (V9 prioritário)

### [TODO-01] Refresh Automático das Materialized Views
**O que é:** A função `fn_refresh_intelligence_views()` existe mas não tem scheduler.
**Como fazer:** Supabase Edge Function com pg_cron → `CALL fn_refresh_intelligence_views()` a cada hora.
**Impacto:** Sem isto, os dados da Intelligence API ficam estáticos após o deploy.
**Esforço:** ~2h

---

### [TODO-02] Intelligence API — Auth via Stripe (billing por request)
**O que é:** Actualmente os planos são geridos manualmente. Falta Stripe billing integrado para:
- Upgrade de plano da API key via Checkout
- Reset automático de `requests_mes` no início de cada ciclo de billing
- Webhook Stripe → `api_keys.requests_mes = 0`
**Esforço:** ~4h

---

### [TODO-03] Sub-Tenant — Login Isolado
**O que é:** Sub-tenants criados no Fractal existem na BD mas não têm fluxo de login próprio.
Precisam de contas Supabase Auth separadas + onboarding por email.
**Como fazer:** POST /api/fractal/sub-tenants → criar user Supabase Auth (Admin API) → enviar email de boas-vindas.
**Esforço:** ~3h

---

### [TODO-04] Brand Injection para Sub-Tenants
**O que é:** `brand_config` está na BD mas o dashboard SaaS não lê o brand do sub-tenant ao carregar.
Sub-tenants deviam ver o dashboard com as cores e logo do seu parent.
**Como fazer:** `saas-auth.js` → detectar `sub_tenant_id` no JWT → carregar brand_config → injectar CSS vars.
**Esforço:** ~2h

---

## ALTA PRIORIDADE

### [TODO-05] Lead Score Colectivo (V8 Ideia 1 adiada)
**O que é:** Modelo de scoring treinado com sinais de conversão reais (WA response = positivo, 3 follow-ups ignorados = negativo).
Claude Haiku analisa batch de leads nocturnamente → actualiza heurísticas do scraper.
**Tabelas necessárias:** `conversion_signals` (lead_id, signal_type, tenant_id, created_at)
**Esforço:** ~8h (scraper + Edge Function + schema)

---

### [TODO-06] Pack Collab — Co-autoria Multi-Criador (V8 Ideia 2 adiada)
**O que é:** Packs com múltiplos criadores + revenue split configurável via Stripe Connect (múltiplos `transfer_data`).
**Tabelas necessárias:** `pack_collaborators` (pack_id, creator_id, pct_share)
**Esforço:** ~6h

---

### [TODO-07] Intelligence API — Dados Raw / Bulk Export
**O que é:** Endpoint Enterprise para download CSV/JSON de dados agregados.
Útil para fundos e aceleradoras que querem análise offline.
**Esforço:** ~3h

---

### [TODO-08] Feed de Intenção — Histórico e Filtros
**O que é:** O feed actual mostra apenas eventos em tempo real (Realtime).
Falta: load dos últimos N eventos ao entrar na página + filtrar por nicho/tipo.
**Query necessária:** `SELECT * FROM intention_webhooks ORDER BY created_at DESC LIMIT 50`
**Esforço:** ~1.5h

---

## MÉDIO PRAZO

### [TODO-09] Hermes Autónomo — A/B Testing de Hooks (V8 Ideia 3 adiada)
**O que é:** n8n workflow que testa 3 variantes de ai_hook em grupos de 10 leads e adopta a melhor em 72h.
**Tabelas necessárias:** `wa_conversations` (lead_id, variant, replied_at, outcome)
**Esforço:** ~12h

---

### [TODO-10] Scraper — Modo Paralelo
**O que é:** Actualmente o scraper é sequencial. Com asyncio semaphore poderia processar 5 leads em paralelo.
**Impacto:** 5× throughput sem custo adicional.
**Esforço:** ~3h

---

### [TODO-11] Dashboard — Dark Mode Toggle
**O que é:** O SaaS Dashboard está fixo em dark mode. Alguns clientes enterprise pedem light mode.
**Esforço:** ~2h (CSS custom properties já preparadas para override)

---

### [TODO-12] API Docs — OpenAPI Customizado
**O que é:** FastAPI gera `/api/docs` automático mas sem branding Vanguard.
Customizar com logo, cores e exemplos reais de request/response.
**Esforço:** ~1.5h

---

### [TODO-13] Webhook de Erro — Alertas Slack/Discord
**O que é:** Quando um scraper_job falha, não há notificação proactiva ao tenant.
**Como fazer:** BackgroundTask → POST to tenant's webhook_url (se configurado) com job error details.
**Esforço:** ~1h

---

## LONGO PRAZO / V10+

### [TODO-14] Marketplace — Packs Premium com Trial
**O que é:** Criadores oferecem 7 dias de trial antes de cobrar.
Stripe permite `trial_period_days` na subscription — integrar no checkout flow.
**Esforço:** ~3h

---

### [TODO-15] Intelligence API — GraphQL
**O que é:** Clientes enterprise querem queries personalizadas em vez de endpoints fixos.
Supabase tem suporte GraphQL nativo — expor directamente.
**Esforço:** ~4h (configuração Supabase + documentação)

---

### [TODO-16] Scraper — Integração LinkedIn
**O que é:** LinkedIn Sales Navigator como fonte adicional de leads B2B.
Requer proxy rotation + rate limiting agressivo.
**Esforço:** Alto (20h+) + custo de proxies

---

### [TODO-17] Fractal — Portal do Sub-Tenant
**O que é:** Sub-tenants deveriam ter o seu próprio painel simplificado (sem acesso às configs do parent).
Ver apenas os seus leads, jobs e quota usada.
**Esforço:** ~8h (nova rota /sub/ no nginx + HTML simplificado)

---

*Catalogado por Claude Sonnet 4.6 — Missão V8 Completa — 2026-05-09*
