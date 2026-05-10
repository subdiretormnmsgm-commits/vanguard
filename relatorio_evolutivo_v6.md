# Relatório Evolutivo — Vanguard Soberano Digital V6
> SaaS Multi-Tenant: da Ferramenta ao Produto

**Data:** 2026-05-09  
**Versão:** V6 → `CURRENT_VERSION: 6`  
**Arquitecto de IA:** Claude Sonnet 4.6

---

## 1. Comparação Evolutiva

| Dimensão | V5 (Soberano) | V6 (SaaS Multi-Tenant) |
|----------|---------------|------------------------|
| Modelo de negócio | Ferramenta interna | Produto SaaS com assinaturas |
| Utilizadores | 1 (agência própria) | N tenants isolados |
| Isolamento de dados | Nenhum | RLS por `tenant_id` |
| Billing | Manual | Stripe automático |
| Auth | Não existia | Supabase Auth + JWT |
| Dashboard | Marketing PWA | Dashboard operacional por tenant |
| API | Supabase directo | FastAPI Bridge (segurança + lógica) |
| Scraper | Stand-alone | Trigger via API → `docker run` com `tenant-id` |
| Realtime | Não existia | Supabase Realtime (postgres_changes) |
| Infra | 4 serviços | 5 serviços (+api container) |

---

## 2. Features Implementadas

### Feature 01 — Supabase Multi-Tenant
- Tabela `tenants` com plano, quota, stripe IDs, ciclo de reset
- Tabela `scraper_jobs` para tracking de jobs por tenant
- `tenant_id` FK em `leads_diagnostico`
- Triggers automáticos: incremento de quota + reset mensal
- RLS completo: tenants só acedem aos seus dados
- View `v_tenant_dashboard` para frontend seguro

### Feature 02 — API Bridge FastAPI
- JWT auth via `python-jose` + Supabase JWT Secret
- 11 endpoints REST documentados
- Stripe Checkout Session + Customer Portal
- Webhook Stripe para sincronização de billing
- Scraper trigger via `docker run` background task
- Validação de quota antes de cada job

### Feature 03 — Dashboard PWA SaaS
- Login page com Supabase Auth (email + password)
- Dashboard multi-secção: Painel / Scraper / Leads / Planos
- KPI cards com animação roll-up
- Quota bar (cyan→violet, warn em 70%, full em 90%)
- Realtime job status via Supabase channel
- Tabela de leads com score badge + IA badge + WA link
- Export CSV nativo
- Upgrade flow integrado com Stripe Checkout

### Feature 04 — Infra Docker + Nginx
- Serviço `api` no docker-compose (porta 9000, docker.sock montado)
- nginx proxy `/api/` → `vanguard_api:9000`
- Rota `/saas/` para SPA dashboard
- Scraper com `--tenant-id` CLI + `VANGUARD_TENANT_ID` env fallback

---

## 3. Guia de Deploy V6

```bash
# 1. Executar migração no Supabase SQL Editor
# Copiar e executar: infra/schema_v6_multitenant.sql

# 2. Configurar variáveis de ambiente
cp .env.example .env
# Preencher: SUPABASE_SERVICE_KEY, SUPABASE_JWT_SECRET
# Preencher: STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET, STRIPE_PRICE_*

# 3. Configurar webhook Stripe
# URL: https://yourdomain.com/api/stripe/webhook
# Eventos: checkout.session.completed, invoice.payment_succeeded,
#          customer.subscription.deleted, customer.subscription.updated

# 4. Build e deploy
docker compose build
docker compose up -d

# 5. Verificar saúde
curl http://localhost:9000/health
# → {"status":"ok","version":"6.0.0"}

# 6. Aceder ao dashboard
# https://yourdomain.com/saas/
```

---

## 4. Fluxo do Utilizador SaaS

```
1. Acede a /saas/ → Login page
   ↓
2. Cria conta (email + password + nome agência)
   ↓
3. Supabase Auth → registo automático de tenant (plano: starter, 100 leads)
   ↓
4. Dashboard → Painel KPIs
   ↓
5. Scraper → selecciona nicho + cidade + modo → dispara
   ↓
6. API valida quota → cria scraper_job → docker run em background
   ↓
7. Realtime → toast de conclusão → KPIs actualizados
   ↓
8. Leads → tabela com scores IA + links WhatsApp
   ↓
9. Quota esgotada → upgrade → Stripe Checkout → plano activo
```

---

## 5. Visão LMM do Claude — Propostas Disruptivas para V7

> *"Aqui o arquitecto sai do código e entra no impossível."*
> 
> A V6 transformou a Vanguard num SaaS funcional. Mas há dois vectores onde a maioria dos concorrentes nunca pensou. Eis onde a V7 pode criar um fosso intransponível.

---

### IDEIA 1: Pipeline de IA Autónoma por Tenant — "Agente Comercial Perpétuo"

**Conceito:** Cada tenant recebe um **agente IA próprio** que opera 24/7 sem intervenção humana. O agente:

1. **Detecta oportunidades automaticamente** — analisa padrões de conversão dos leads passados e identifica nichos/cidades com melhor ROI para cada tenant
2. **Auto-dispara scrapers** — sem nenhum clique humano, agenda jobs nocturnos nos melhores horários (menor carga OSM)
3. **Personaliza hooks por histórico** — aprende com os leads que geraram resposta no WhatsApp e ajusta o estilo do `ai_hook` do Claude Haiku
4. **Reporta por WhatsApp ao próprio tenant** — envia resumo diário: "Hoje capturei 23 leads de advocacia em Brasília. Os 3 melhores têm score 8+ e já enviamos hooks personalizados."

**Stack necessária:**
- n8n workflow com trigger cron
- Supabase function para detectar oportunidades
- Claude Haiku para análise de padrões + geração de relatório
- WhatsApp Business API (já temos via Hermes)

**Por que é disruptivo:** O concorrente SaaS vende "ferramentas". A Vanguard V7 vende um **colaborador de IA** que nunca dorme. O churn cai para próximo de zero — o utilizador não cancela aquilo que está a trabalhar por ele enquanto dorme.

**Impacto estimado:** Retenção +60%, ARPU +40% (nova tier: "Autopilot" a 3× o preço Pro).

---

### IDEIA 2: Marketplace de Nichos + Revenue Share — "AppStore de Prospecção"

**Conceito:** A Vanguard V7 não é apenas uma ferramenta — é uma **plataforma de distribuição de fluxos de prospecção verticais**. Funciona assim:

1. **Parceiros criam "Pacotes de Nicho"** — um especialista em saúde dental cria um pack: queries OSM optimizadas, prompts Claude Haiku específicos, templates de mensagem WhatsApp com alta taxa de resposta, scripts de qualificação de lead. Publica no Marketplace.

2. **Tenants compram/subscrevem pacotes** — a partir de R$ 97/mês por pack adicional. Um pack de "Clínicas Odontológicas — São Paulo" pode ter 200 compradores.

3. **Revenue share automático** — 70% para o criador do pack, 30% para a Vanguard. Stripe Connect processa tudo automaticamente.

4. **Dados de performance públicos** — cada pack tem rating, taxa de conversão média, leads/mês típicos. Transparência radical que cria confiança.

**Por que é impossível de copiar:**
- A concorrência pode copiar o scraper. Não pode copiar o **efeito de rede** de 500 criadores a optimizar packs para 10.000 tenants.
- Cada pack publicado torna o produto melhor para todos — flywheel de crescimento orgânico.
- O marketplace cria uma nova linha de receita que **não depende do número de features da Vanguard** — depende da comunidade.

**Impacto estimado:**
- Linha de receita adicional: 30% das transacções do marketplace
- CAC próximo de zero para novos tenants (criadores promovem os seus packs)
- Vanguard torna-se a "Shopify dos closers digitais"

---

*Estas duas ideias não são iterações — são saltos de paradigma. A V6 prova que sabemos construir SaaS. A V7 decide se somos mais uma ferramenta ou uma plataforma.*

---

*Relatório gerado por Claude Sonnet 4.6 — Arquitecto de IA Supremo — Missão V6*
