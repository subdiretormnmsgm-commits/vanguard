# TODO_FUTURE — Backlog Estratégico Vanguard
> **Actualizado:** V10 — 2026-05-09  
> **Metodologia:** ideias ordenadas por impacto × viabilidade

---

## 🔴 CRÍTICO (implementar em V11)

- [ ] **pg_cron para materialized view refresh** — views Intelligence desactualizadas após 1h sem trigger manual
- [ ] **Sub-tenant isolated login** — sub-tenants (Fractal) acedem com URL dedicada + brand própria sem ver dashboard pai
- [ ] **CORS restrito em produção** — `allow_origins=['*']` deve ser restrito ao domínio em produção
- [ ] **Vanguard AI Agent — Closer Autónomo** (Ideia disruptiva V10 #1)
  - Detecta novo lead → selecciona variante Hermes → envia WA → analisa resposta → agenda Vapi → lista no mercado após 72h sem conversão
  - Stack: n8n workflow + Supabase Realtime + Claude Opus orchestrator + tabela `agent_jobs`

---

## 🟡 ALTA PRIORIDADE (V11-V12)

- [ ] **Score™ API Pública** (Ideia disruptiva V10 #2)
  - `GET /v2/score/{nif}` — €0.05/consulta · `GET /v2/score/batch` — €0.03/cada
  - Metered billing Stripe · SDK JS/Python · 100k queries/mês = €3k-5k MRR passivo

- [ ] **Fortress: Health check periódico automático** — n8n a chamar `/api/fortress/health` a cada 5min e guardar em `health_checks_log`

- [ ] **Incident auto-resolve** — quando serviço volta ao ar após DOWN, criar incidente de resolução automática

- [ ] **Vanguard Academy** (Ideia disruptiva V10 #3)
  - Tabela `courses`: tenant_autor_id, preço, conteúdo (vídeos/guias/templates)
  - Split 70/30, score do autor como credencial, certificado de conclusão Vanguard™

---

## 🟢 MÉDIA PRIORIDADE (V12-V13)

- [ ] **Predictive Lead Routing** (Ideia disruptiva V10 #4)
  - Claude Haiku extrai features → modelo logistic regression → sugere tenant com maior probabilidade de fecho
  - Nova rota `/api/arbitrage/suggest/{lead_id}` · retreino semanal pg_cron

- [ ] **Rate limiting no nginx** — `limit_req_zone` por IP para endpoints públicos

- [ ] **API Keys rotação** — `POST /v1/intelligence/keys/{id}/rotate` sem downtime

- [ ] **Webhook idempotência** — tabela `processed_events` para evitar double-processing de Stripe

---

## ⚪ BAIXA PRIORIDADE (V13+)

- [ ] **Score™ webhook** — `POST /v2/score/webhook` — notifica quando score de empresa muda >10%
- [ ] **Multi-idioma** — dashboard PT/EN/ES (i18n com JSON files)
- [ ] **Mobile sidebar** — sidebar colapsável em mobile (atualmente `display:none`)
- [ ] **Leaderboard sectorial público** — microsite Score™ com top 10 empresas por nicho

---

## ✅ IMPLEMENTADO (referência histórica)

- [x] V1: PWA Quiz + Supabase
- [x] V2: Shadow Closer + Cockpit
- [x] V3: Scraper OSM + Claude Haiku
- [x] V5: Docker + White-Label
- [x] V6: SaaS Multi-Tenant + Stripe Billing + JWT
- [x] V7: Marketplace + Stripe Connect 70/30
- [x] V8: Intelligence API SHA-256 + Fractal WL + Sovereign Glass
- [x] V9: Lead Arbitrage + Certifica™ + Hermes Voice + Score™ Microsite
- [x] V10: Fortress Health Monitor + IA Firefighter + Stress Test + Pixel Perfect Dashboard
- [x] V10: `VANGUARD_BUSINESS_RULES.md` — Constituição económica V1–V10
