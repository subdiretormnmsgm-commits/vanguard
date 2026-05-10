# Relatório Evolutivo — Vanguard V7
> Do SaaS ao Marketplace: A Plataforma com Efeito de Rede

**Data:** 2026-05-09  
**Versão:** V7 → `CURRENT_VERSION: 7`  
**Arquitecto de IA:** Claude Sonnet 4.6

---

## 1. Comparação Evolutiva

| Dimensão | V6 (SaaS Multi-Tenant) | V7 (Marketplace) |
|----------|------------------------|------------------|
| Modelo de negócio | Produto SaaS (creator = Vanguard) | Plataforma + Marketplace (creators externos) |
| Fontes de receita | 1 (subscrições) | 3 (subscrições + comissão 30% + packs premium) |
| Criadores de conteúdo | Apenas Vanguard | N criadores externos com Stripe Connect |
| Revenue share | N/A | 70% criador / 30% plataforma (automático) |
| Config do scraper | Fixa (por tenant) | Dinâmica (config do pack) |
| Webhooks de intenção | Não existiam | 6 eventos rastreados (view, preview, subscribed...) |
| Efeito de rede | Nenhum | Cada criador traz os seus clientes |
| Infra API | 1 ficheiro (main.py) | main.py + marketplace.py (router separado) |
| UI pública | Apenas dashboard interno | Marketplace público + creator dashboard |

---

## 2. Features Implementadas

### Feature 01 — Schema Supabase V7
- 6 novas tabelas: `creators`, `marketplace_packs`, `pack_subscriptions`, `pack_reviews`, `intention_webhooks`, `creator_payouts`
- 3 triggers: assinantes (inc/dec), rating médio
- RLS completo: criadores só editam os seus packs, tenants só vêem as suas subscriptions
- View `v_marketplace_feed` para feed público optimizado

### Feature 02 — API Marketplace (12 endpoints)
- Stripe Connect Express onboarding (criadores)
- Pack CRUD: criar rascunho → publicar (cria produto Stripe) → revisão → activo
- Subscribe: Checkout Session com `application_fee` 30% + transfer 70% ao criador
- Webhook Stripe Connect: sincroniza subscriptions, payouts, cancellamentos
- Webhooks de intenção: 6 eventos para análise de funil

### Feature 03 — UI "Dark Bazaar" (Awwwards-level)
- **Aesthetic:** Editorial Luxury × Dark Web — completamente diferente do Neural Command Center V6
- **Cursor customizado:** amber dot + ring com `mix-blend-mode: difference`
- **Pack cards:** formato magazine cover (portrait, emoji cover, stats trio, hover overlay CTA)
- **Hero section:** 2-col com título Cormorant dramático + pack em destaque
- **Horizontal scroll:** drag-scroll com cursor grab + amber scrollbar
- **marketplace/index.html:** Browse, featured, filtros, criadores, how-it-works, CTA creator
- **marketplace/creator.html:** Onboarding Stripe + CRUD packs + dashboard KPIs

### Feature 04 — Scraper Webhooks de Intenção
- `--pack-id` e `--pack-config` (JSON com config OSM + prompts IA do pack)
- Hook template do pack tem precedência sobre gerador padrão
- `_enviar_intention_webhook()`: notifica API após cada run com `scraper_ran`

---

## 3. Guia de Deploy V7

```bash
# 1. Executar no Supabase SQL Editor (após schema_v6)
# infra/schema_v7_marketplace.sql

# 2. Configurar Stripe Connect no dashboard Stripe
# Dashboard → Connect → Settings → Activar Express accounts

# 3. Criar webhook Stripe Connect separado
# URL: https://dominio.com/api/marketplace/webhook/stripe-connect
# Eventos: checkout.session.completed, customer.subscription.deleted, transfer.created

# 4. Adicionar novas vars ao .env
STRIPE_CONNECT_WEBHOOK_SECRET=whsec_...
MARKETPLACE_URL=https://dominio.com/marketplace
VANGUARD_API_URL=http://vanguard_api:9000  # para o scraper

# 5. Build e deploy
docker compose build api
docker compose up -d

# 6. Verificar
curl http://localhost:9000/api/marketplace/packs
# → {"packs":[],"total":0}

# 7. Aceder ao marketplace
# https://dominio.com/marketplace/
```

---

## 4. Fluxo Completo do Marketplace

```
CRIADOR:
1. /marketplace/creator.html → onboard
   ↓ Stripe Connect Express → conta bancária conectada
2. Criar pack (draft): nicho + config OSM + prompts IA + preço
3. Publicar → cria produto Stripe + preço recorrente → revisão → activo
4. Recebe 70% automaticamente em cada nova subscrição

TENANT:
1. /marketplace/ → browse por nicho/rating
2. Clicar pack → modal detalhe + webhook 'view'
3. "Subscrever Pack" → webhook 'checkout_start' → Stripe Checkout
4. Pagamento → Stripe transfere 70% para criador, 30% fica na plataforma
5. Dashboard SaaS → novo pack disponível → dispara scraper com config do pack
6. Scraper usa prompts do pack → leads com hooks personalizados
7. n8n Hermes → follow-up WA com template do pack
```

---

## 5. Visão LMM do Claude — 4 Ideias Disruptivas para V8

> *"A V7 criou o marketplace. A V8 deve torná-lo inevitável."*
> 
> Analisando a arquitectura completa — scraper + IA + realtime + billing + marketplace — identifico 4 vectores onde a maioria dos concorrentes nem sabe que existe uma batalha.

---

### IDEIA 1: "Lead Score Colectivo" — Inteligência Distribuída Entre Todos os Tenants

**Conceito:** Cada lead capturado em toda a rede (não apenas o tenant individual) contribui anonimamente para um **modelo de scoring colectivo**. Funciona assim:

- Quando um lead gera resposta no WhatsApp (detectado pelo Hermes n8n), regista-se um sinal positivo
- Quando um lead é ignorado após 3 follow-ups, regista-se sinal negativo
- Claude Haiku analisa os padrões de ~10.000 leads para identificar: quais características de site (score, tamanho, presença Google, número de funcionários estimado) correlacionam com conversão real
- O modelo actualiza o `score_digital` do scraper — não mais baseado em heurísticas fixas, mas em dados reais de conversão da rede

**Por que é impossível de copiar:** Cada novo tenant que entra **melhora o modelo para todos**. Depois de 6 meses e 50.000 leads, o scoring da Vanguard será literalmente impossível de reproduzir por um concorrente que está a começar do zero.

**Stack:** Supabase Edge Functions + Claude Haiku (análise batch noturna) + coluna `conversion_signal` na tabela leads

**Impacto:** Upsell "Score Pro" que mostra o ranking de probabilidade de conversão. Diferencial de produto mensurável.

---

### IDEIA 2: "Pack Collab" — Co-Autoria com Revenue Split Automático

**Conceito:** Criadores podem criar packs em colaboração com até 3 parceiros, cada um com percentagem configurável do revenue share.

Exemplo: Um especialista em advocacia SP (30%), um copywriter de WhatsApp (20%), e a Vanguard (50%). Stripe Connect distribui automaticamente em cada pagamento.

Mas o nível seguinte é ainda mais disruptivo: **packs de comunidade** onde qualquer subscritor pode submeter um novo template de hook WA, e se for aprovado pelo criador, ganha 5% do revenue daquele mês. O pack melhora continuamente, o criador faz curation, a comunidade é co-criadora.

**Por que isto muda tudo:** Transforma utilizadores passivos em stakeholders activos. O churn cai drasticamente quando o cliente tem "pele no jogo" — literalmente ganha dinheiro por ficar.

**Stack:** Stripe Connect com múltiplos `transfer_data.destination`, nova tabela `pack_collaborators` com percentagens, UI de submissão de templates

**Impacto:** Novo tier de produto — "Pack Pro" com colaboração. Comunidade auto-sustentável.

---

### IDEIA 3: "Hermes Autónomo" — WhatsApp Agent que Aprende e Negoceia

**Conceito:** O Hermes n8n actual é reactivo — responde quando contactado. A V8 torna-o proactivo e adaptativo:

1. **Aprendizagem de persona:** Claude analisa as conversas WA dos últimos 30 dias do tenant e identifica o estilo de comunicação que funcionou melhor (formal/informal, directo/narrativo, curto/longo)

2. **A/B testing automático:** Para cada nicho, o Hermes testa 3 variantes de hook diferentes em grupos de 10 leads, e em 72h adopta automaticamente a que tem maior taxa de resposta

3. **Negociação progressiva:** Quando lead responde com objecção ("está caro", "não tenho tempo"), o Hermes tem um playbook de 5 respostas pré-aprovadas pelo tenant, escolhidas por Claude com base no contexto da objecção. Escala para humano apenas quando as 5 falharem

4. **Relatório semanal de performance:** "Esta semana: 127 leads contactados, 23 respostas, 8 reuniões agendadas. A variante B teve +40% de resposta vs. A para advocacia SP."

**Stack:** Claude Sonnet (raciocínio de negociação) + n8n com workflow branching + nova tabela `wa_conversations` + Supabase Realtime

**Impacto:** De ferramenta de prospecção a **SDR virtual**. Justifica tier "Enterprise Plus" a 5× o preço.

---

### IDEIA 4: "Vanguard Intelligence" — API Pública de Inteligência de Mercado

**Conceito radicalmente diferente:** A Vanguard tem dados que mais ninguém tem — scrores digitais de dezenas de milhares de empresas, taxas de conversão por nicho e cidade, tendências de quais nichos estão a crescer digitalmente.

Monetizar esses dados como **API B2B de inteligência de mercado**:

- `GET /v1/intelligence/nicho/{nicho}?cidade={cidade}` → "Score médio das 500 empresas de advocacia em SP é 4.2/10. 67% não têm Google Reviews. Os que têm mais leads respondem têm website com blog activo."
- `GET /v1/intelligence/tendencias` → "Nicho de estética cresceu 34% em prospecção digital este mês em São Paulo."
- `GET /v1/intelligence/empresa?cnpj={cnpj}` → Score digital daquela empresa específica

**Clientes desta API:** Fundos de investimento que querem mapear oportunidades de mercado. Franquias que querem saber onde abrir unidades. Aceleradoras que querem identificar empresas com baixa presença digital (oportunidades de investimento).

**Por que é disruptivo:** Cria uma **linha de receita completamente nova que não compete com o produto principal**. A API não vende leads — vende inteligência. Preço: R$ 500/mês para startups, R$ 5.000/mês para enterprise.

**O mais louco:** Os dados são um subproduto do que já fazemos. Não há custo marginal de produção — só custo de exposição via API.

**Stack:** FastAPI endpoint público `/v1/intelligence/`, agregações em Supabase Materialized Views actualizadas nocturnamente, auth por API key (Stripe billing por requests acima de 1000/mês)

**Impacto:** TAM expande de "donos de agências" para "qualquer empresa que precisa de inteligência de mercado B2B". Potencialmente, esta linha de receita supera a principal em 18 meses.

---

*"Quatro ideias. Uma muda o produto. Uma muda a comunidade. Uma muda o serviço. Uma muda o mercado endereçável. A V8 que implementar as quatro não é mais uma startup — é uma empresa de dados com um produto SaaS como veículo."*

---

*Relatório gerado por Claude Sonnet 4.6 — Arquitecto de IA Supremo — Missão V7 Completa*
