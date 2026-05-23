# VANGUARD BUSINESS RULES — Repositório Central
> **Documento vivo** — actualizado a cada versão do produto  
> **Versão actual:** V18 — Pentalateral IAH  
> **Última actualização:** 2026-05-18  
> **Fonte de verdade:** Scan profundo V1–V9 + Regras do Conselho Pentalateral

---

## ÍNDICE

1. [Missão & Pilares Estratégicos](#1-missão--pilares-estratégicos)
2. [Modelo de Receita — 6 Linhas](#2-modelo-de-receita--6-linhas)
3. [Splits de Lucro por Produto](#3-splits-de-lucro-por-produto)
4. [Regras de Scoring de Leads](#4-regras-de-scoring-de-leads)
5. [Planos SaaS & Quotas](#5-planos-saas--quotas)
6. [Regras da Intelligence API](#6-regras-da-intelligence-api)
7. [Regras do Marketplace de Nichos](#7-regras-do-marketplace-de-nichos)
8. [Regras do Fractal White-Label](#8-regras-do-fractal-white-label)
9. [Regras da Arbitragem de Leads](#9-regras-da-arbitragem-de-leads)
10. [Regras da Certificação Vanguard™](#10-regras-da-certificação-vanguard)
11. [Regras do Hermes (Voz & Persona)](#11-regras-do-hermes-voz--persona)
12. [Regras de Privacidade & Isolamento de Dados](#12-regras-de-privacidade--isolamento-de-dados)
13. [Regras de Scraping & Auditoria Digital](#13-regras-de-scraping--auditoria-digital)
14. [Design System & Identidade Visual](#14-design-system--identidade-visual)
15. [Changelog por Versão](#15-changelog-por-versão)

---

## 1. Missão & Pilares Estratégicos

### Missão
> **"Ser a infraestrutura de dados e vendas da economia digital portuguesa — da prospecção ao fecho, do diagnóstico à certificação."**

### O Que a Vanguard É
Uma **Venture Builder Autónoma & Holding de Dados SaaS** com 6 linhas de receita activas e arquitectura multi-tenant. Não é uma agência. Não vende serviços — vende **acesso a dados, inteligência e economia soberana**.

### 4 Pilares Imutáveis (desde V1)

| Pilar | Descrição |
|-------|-----------|
| **Dados como Produto** | Cada lead gerado é um activo. Não é custo — é inventário. |
| **IA no Centro** | Claude Haiku/Sonnet em todos os fluxos críticos. Sem IA = sem Vanguard. |
| **Revenue Share Justo** | 70% para o parceiro/criador, 30% para a plataforma. Sempre. |
| **Isolamento Total** | Dados de cada tenant nunca são acessíveis por outros tenants. RLS obrigatório. |

### Princípio de Singularidade (CLAUDE.md)
> "Autonomia total. Ferramentas nativas (Bash) e automações Python são válidas. Use a inteligência LMM para sugerir melhorias disruptivas em todos os commits."

---

## 2. Modelo de Receita — 6 Linhas

| # | Produto | Modelo Financeiro | Activado em | Status |
|---|---------|-------------------|-------------|--------|
| 1 | **SaaS Multi-Tenant** | Subscrição recorrente (Stripe Billing) | V6 | ✅ Activo |
| 2 | **Marketplace de Nichos** | Comissão 30% por subscrição (Stripe Connect) | V7 | ✅ Activo |
| 3 | **Intelligence API** | Pay-per-request por plano de API | V8 | ✅ Activo |
| 4 | **Fractal White-Label** | MRR de revendedores (sub-tenants) | V8 | ✅ Activo |
| 5 | **Lead Arbitrage System** | Comissão 30% em cada leilão/venda | V9 | ✅ Activo |
| 6 | **Vanguard Maturity Certificate™** | Taxa única anual por badge emitido | V9 | ✅ Activo |

**Receita total possível por tenant activo:**
- Usar o scraper (SaaS) → vender leads não atendidos (Arbitragem) → certificar os melhores clientes (Certifica) → revender para agências parceiras (Fractal)

---

## 3. Splits de Lucro por Produto

### 3.1 Marketplace de Nichos (V7)
```
Subscrição de pack → Stripe Checkout
  ├── 30% → Vanguard  [application_fee_amount]
  └── 70% → Criador   [transfer_data.destination = stripe_account_id]
```
- Implementado via **Stripe Connect Express**
- O criador precisa de completar onboarding Stripe antes de receber
- Transfer é automático no momento do pagamento (não há payout manual)

### 3.2 Lead Arbitrage (V9)
```
Venda de lead → Stripe Checkout Session
  ├── 30% → Vanguard  [application_fee_amount = round(preco_centavos × 0.30)]
  └── 70% → Vendedor  [armazenado em lead_purchases.valor_vendedor]
```
- **Constante no código:** `COMISSAO_VANGUARD = 0.30` (`api/arbitrage.py:33`)
- Ambos os valores gravados na BD: `comissao_vanguard` e `valor_vendedor`
- O trigger `trg_fechar_leilao` calcula automaticamente via `ROUND(maior_lance × 0.30, 2)`

### 3.3 SaaS Billing (V6)
```
Plano Starter  → €29/mês  [STRIPE_PRICE_STARTER]   → 100 leads/ciclo
Plano Pro      → €97/mês  [STRIPE_PRICE_PRO]        → 500 leads/ciclo
Plano Enterprise → €297/mês [STRIPE_PRICE_ENTERPRISE] → 2000 leads/ciclo
Trial          → Grátis   [sem stripe]               → 20 leads/ciclo
```
- Ciclo de billing: **30 dias** (reset em `ciclo_reset_em = now() + INTERVAL '30 days'`)
- Reset de quota: trigger automático em `invoice.payment_succeeded`

### 3.4 Fractal White-Label (V8)
```
Parent (Pro/Enterprise) → cria sub-tenants → cobra o preço que quiser
Vanguard não interfere no preço cobrado pelo parent aos seus sub-tenants
[preco_cobrado: float, ge=0, le=9999 — definido livremente pelo parent]
```
- A Vanguard já recebe o MRR do parent (plano Pro/Enterprise)
- O lucro do parent nos sub-tenants é 100% dele — sem comissão adicional
- **Quota cascade:** quota do sub-tenant sai da quota do parent (`sub.leads_quota ≤ parent.leads_restante`)

### 3.5 Intelligence API (V8)
```
Plano Free     → 1.000 requests/mês  [acesso gratuito — aquisição]
Plano Starter  → 5.000 requests/mês  [plano pago]
Plano Pro      → 50.000 requests/mês [plano pago]
Plano Enterprise → ∞ requests/mês    [sem limite — sem rate check]
```
- Rate limit verificado antes de cada request
- Enterprise: `if plano != 'enterprise' and usados >= limite` — enterprise sempre passa

---

## 4. Regras de Scoring de Leads

### 4.1 Score de Diagnóstico (V2 — Shadow Closer)
Algoritmo para leads captados pelo Quiz (escala 0-100):

```
Score = clamp( round(base_gargalo × multiplicador_nicho + bónus_semântico), 0, 100 )
```

**Tabela de pesos por Gargalo (base score):**

| Gargalo Declarado | Base Score | Notas |
|-------------------|-----------|-------|
| Dificuldade em escalar a equipa | 100 | Urgência máxima → VIP garantido |
| Falta de leads qualificados | 90 | Alta urgência comercial |
| Taxa de conversão baixa | 85 | Dor de resultado |
| Processo de vendas inconsistente | 80 | Dor operacional |
| Outros | 50 | Base neutra |

**Multiplicadores por Nicho:**

| Nicho | Multiplicador |
|-------|--------------|
| advocacia | 1.20 |
| clinica | 1.15 |
| imobiliaria | 1.15 |
| dentista | 1.12 |
| contabilidade | 1.10 |
| estetica | 1.08 |
| farmacia | 1.05 |
| restaurante | 1.00 |

**Bónus Semântico (análise de texto livre):**
- Palavras-chave de urgência detectadas no gargalo → +5 a +20 pontos
- Palavras-chave negativas → -5 a -20 pontos
- Bónus truncado entre -20 e +20 (anti-manipulação)

**Tiers de Prioridade (V2):**

| Tier | Score | Acção |
|------|-------|-------|
| **VIP** | ≥ 75 | Contacto imediato — Shadow Closer agora |
| **Quente** | 50–74 | Contacto em 24h |
| **Frio** | < 50 | Nurturing / descarte |

### 4.2 Score Digital (V3+ — Auditoria Web Automatizada)
Escala 0-10, calculado pelo scraper via auditoria HTTP real:

| Critério | Penalização |
|----------|------------|
| Sem website | Score = 10 (oportunidade máxima — sem website = lead prioritário) |
| Site sem HTTPS | -2.0 pontos |
| Site sem mobile responsive | -1.5 pontos |
| Velocidade de carregamento > 3s | -1.5 pontos |
| Sem Google Business Profile | -1.0 ponto |
| Sem redes sociais activas | -1.0 ponto |
| Sem formulário de contacto | -0.5 pontos |
| Sem SSL válido | -1.0 ponto |

**Gargalo derivado do score digital:**
- Score 0-3 → "Presença digital inexistente"
- Score 4-5 → "Presença digital básica sem conversão"
- Score 6-7 → "Presença digital intermédia com lacunas"
- Score 8-9 → "Presença digital avançada"
- Score 10 → "Empresa sem website — oportunidade máxima"

### 4.3 Score de Certificação (V9)
Baseado no `score_digital` (escala 0-10):

| Nível | Score Mínimo | Cor | Percentil Público |
|-------|-------------|-----|------------------|
| **Emerging** | 8.0 | `#9CA3AF` (cinzento) | Top 20% |
| **Advanced** | 8.5 | `#3B82F6` (azul) | Top 15% |
| **Ready** | 9.0 | `#10B981` (verde) | Top 10% |
| **Elite** | 9.5 | `#F59E0B` (âmbar) | Top 5% |

- `score_percentil` = `ROUND(score_digital × 10)` — coluna GENERATED ALWAYS AS
- Função DB: `fn_nivel_certificacao(p_score)` → retorna texto do nível

---

## 5. Planos SaaS & Quotas

### 5.1 Planos e Limites

| Plano | Preço | Leads/Ciclo | Acesso Fractal | Acesso API | Stripe Status |
|-------|-------|------------|----------------|-----------|---------------|
| `trial` | €0 | 20 | ✗ | ✗ | sem stripe |
| `starter` | €29/mês | 100 | ✗ | ✗ | active/trialing |
| `pro` | €97/mês | 500 | ✅ (cria sub-tenants) | ✅ (5k req/mês) | active/trialing |
| `enterprise` | €297/mês | 2000 | ✅ | ✅ (∞ req) | active/trialing |

### 5.2 Ciclo de Quota

```
Novo tenant criado → leads_quota = 20 (trial), leads_usados = 0
Checkout completo  → leads_quota = plano.quota, leads_usados = 0, ciclo_reset_em = now()+30d
invoice.payment_succeeded → leads_usados = 0, ciclo_reset_em actualizado
```

### 5.3 Validação de Quota (pre-scraper)

```python
# api/main.py — fn_verificar_quota
if not quota['tem_quota']:
    raise HTTPException(429, 'Quota esgotada')

limite_efectivo = min(req.limite, quota['restante'])
```

- Scraper só corre com `stripe_status IN ('active', 'trialing')` ou `plano == 'trial'`
- Limite por job: 1-50 leads (validação Pydantic `ge=1, le=50`)

### 5.4 Stripe Status Válidos
```
active   → subscrição paga e corrente
trialing → período de trial Stripe (sem cobrança ainda)
past_due → pagamento falhado (acesso restrito)
canceled → subscrição cancelada (downgrade para trial)
inactive → estado inicial antes de qualquer subscrição
```

---

## 6. Regras da Intelligence API

### 6.1 Formato da API Key
```
vng_live_{prefix_8chars}_{uuid_hex_32chars}
Exemplo: vng_live_abc12345_d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9

Storage: SHA-256(full_key) — nunca a key em claro na BD
Lookup:  by key_prefix (parte antes do 2º underscore após 'live_')
```

### 6.2 Limites por Plano de API Key

| Plano | Requests/Mês | Nota |
|-------|-------------|------|
| `free` | 1.000 | Acesso gratuito para aquisição |
| `starter` | 5.000 | — |
| `pro` | 50.000 | — |
| `enterprise` | ∞ | Sem verificação de limite |

### 6.3 Endpoints e Restrições

| Endpoint | Plano Mínimo | Notas |
|----------|-------------|-------|
| `GET /v1/intelligence/status` | free | Estado da key |
| `GET /v1/intelligence/nichos` | free | Lista nichos indexados |
| `GET /v1/intelligence/nicho/{nicho}` | free | Stats do nicho |
| `GET /v1/intelligence/tendencias` | free | Tendências 30d |
| `GET /v1/intelligence/empresa` | **starter** | Lookup empresa por nome |
| `GET /v1/intelligence/cidades` | free | Top cidades por nicho |

### 6.4 Dados Servidos

Fontes: Materialized Views pré-computadas (<30ms latência)
- `mv_intelligence_nicho` — score médio, mediana, pct_com_ia, por nicho
- `mv_intelligence_tendencias` — leads últimos 30d por nicho+cidade
- `mv_intelligence_empresas` — score por empresa (nome normalizado)

---

## 7. Regras do Marketplace de Nichos

### 7.1 Ciclo de Vida de um Pack

```
draft → review → active → paused → archived
         ↑                   ↓
         └──────────────── active
```

- `draft`: criador está a configurar (apenas visível ao criador)
- `review`: enviado para aprovação (Vanguard aprova manualmente — futuro)
- `active`: visível no marketplace público
- `paused`: temporariamente oculto (criador pode reactivar)
- `archived`: permanentemente inactivo (sem reverter)

### 7.2 Regras para Subscrição

- Um tenant só pode ter **uma subscrição activa por pack** (`UNIQUE(tenant_id, pack_id)`)
- Status da subscrição: `active`, `cancelled`, `past_due`, `trialing`
- Tenant só pode avaliar packs com subscrição `active`

### 7.3 Sistema de Avaliações

- Rating: inteiro 1-5 (`CHECK (rating BETWEEN 1 AND 5)`)
- Um tenant só avalia um pack **uma vez** (`UNIQUE(pack_id, tenant_id)`)
- Rating médio do criador actualizado via trigger após cada review

### 7.4 Revenue Share — Fluxo Técnico

```
POST /api/marketplace/subscribe/{pack_id}
  → Stripe Checkout Session:
       application_fee_amount = preco_mensal_centimos × 0.30
       transfer_data.destination = creator.stripe_account_id
  → Webhook stripe-connect → pack_subscriptions.status = active
  → creator_payouts regista o valor transferido (70%)
```

### 7.5 Intenção de Compra (Funil)

Eventos registados em `intention_webhooks`:
```
view            → tenant viu o pack
preview         → tenant viu os detalhes
add_to_cart     → tenant iniciou o processo
checkout_start  → abriu sessão Stripe
subscribed      → pagou com sucesso
scraper_ran     → utilizou o pack para fazer scraping
```

---

## 8. Regras do Fractal White-Label

### 8.1 Elegibilidade

- **Apenas planos Pro e Enterprise** podem criar sub-tenants
- Validação: `PLANOS_FRACTAL = ('pro', 'enterprise')` (`api/fractal.py:30`)
- Tentativa de acesso por `starter` ou `trial` → HTTP 403

### 8.2 Limites de Sub-Tenants

| Campo | Restrição | Fonte |
|-------|-----------|-------|
| `leads_quota` do sub | 5–500 leads/mês | `Field(50, ge=5, le=500)` |
| `preco_cobrado` | 0–€9.999/mês | `Field(0.0, ge=0, le=9999)` |
| Sub-tenant email | válido (@domain.tld) | validação Pydantic |

### 8.3 Cascade de Quota

```
Parent.leads_restante = leads_quota - leads_usados

Criar sub-tenant:
  if req.leads_quota > parent.leads_restante → HTTP 400

Quando sub usa lead:
  → trigger fn_quota_sub_tenant → parent.leads_usados++

Ao actualizar quota do sub:
  delta = nova_quota - quota_actual
  if delta > 0 and delta > parent.leads_restante → HTTP 400
```

### 8.4 Brand Config (White-Label)

Campos obrigatórios do `brand_config` JSONB:
```json
{
  "nome":      "Nome da Agência",
  "primary":   "#HHH",   // regex ^#[0-9A-Fa-f]{6}$
  "secondary": "#HHH",
  "accent":    "#HHH",
  "bg":        "#HHH",
  "logo_url":  "https://..."   // opcional
}
```

---

## 9. Regras da Arbitragem de Leads

### 9.1 Criação de Listagem

| Campo | Validação | Fonte |
|-------|-----------|-------|
| `modelo` | `leilao` ou `fixo` | `CHECK (modelo IN ('leilao','fixo'))` |
| `preco_base` | €0.50–€500.00 | `Field(5.0, ge=0.5, le=500)` |
| `preco_fixo` | €1.00–€1.000.00 | `Field(None, ge=1, le=1000)` |
| `duracao_horas` | 1–168 horas (1h a 7 dias) | `Field(48, ge=1, le=168)` |

- O lead deve pertencer ao tenant que lista (validação por `tenant_id`)
- Um lead não pode ser listado duas vezes em simultâneo (verificação de `status=active`)
- Listagem expira em `leilao_termina_em = now() + duracao_horas`

### 9.2 Regras de Leilão

```
Lance mínimo = max(preco_base, maior_lance_actual + €0.50)
```

- Um tenant **não pode licitar no seu próprio lead** (validação explícita)
- Cada tenant só tem **um lance activo por listagem** (`UNIQUE(listing_id, bidder_tenant_id)`) — upsert automático
- O trigger `trg_maior_lance` actualiza `maior_lance` e `maior_lance_tenant_id` atomicamente

### 9.3 Fecho Automático do Leilão

Trigger `trg_fechar_leilao` dispara quando `status: active → auction_ended`:

```sql
INSERT INTO lead_purchases (
  listing_id, buyer_tenant_id, seller_tenant_id,
  preco_pago, comissao_vanguard, valor_vendedor, status
) VALUES (
  NEW.id,
  NEW.maior_lance_tenant_id,
  NEW.tenant_id,
  NEW.maior_lance,
  ROUND(NEW.maior_lance × 0.30, 2),
  ROUND(NEW.maior_lance × 0.70, 2),
  'pending'
);
UPDATE lead_bids SET status = 'won'  WHERE listing_id = NEW.id AND bidder = maior_lance_tenant;
UPDATE lead_bids SET status = 'lost' WHERE listing_id = NEW.id AND bidder != maior_lance_tenant;
```

### 9.4 Privacidade no Mercado

O que é **público** numa listagem (visível a todos os tenants):
```
preview_nicho    → sector do lead
preview_cidade   → cidade do lead
preview_score    → score_digital (0-10)
preview_gargalo  → principal problema identificado
preco_base       → preço de partida
maior_lance      → lance actual (em leilão)
horas_restantes  → tempo até fecho
```

O que é **privado** (só revelado após compra):
```
empresa_nome    → nome da empresa
telefone        → contacto directo
email           → email da empresa
website         → URL do website
endereco        → morada completa
```

### 9.5 Compra Directa (modelo fixo)

```
preco = preco_fixo ?? preco_base
application_fee_amount = round(preco_centavos × 0.30)
→ Stripe Checkout Session → webhook → lead_purchases.status = completed
→ lead_listings.status = sold
```

---

## 10. Regras da Certificação Vanguard™

### 10.1 Elegibilidade

```
score_digital >= 8.0   ← obrigatório (constraint BD + validação Python)
plano != 'trial'       ← requer plano pago para emitir
```

- Tenant não pode emitir certificado para lead que não lhe pertença
- Um lead só pode ter **um certificado activo** (verificação de `expires_at > now()`)

### 10.2 Níveis e Critérios

| Nível | Score | Cor Hex | Percentil |
|-------|-------|---------|-----------|
| `emerging` | 8.0 ≤ score < 8.5 | `#9CA3AF` | ~20% |
| `advanced` | 8.5 ≤ score < 9.0 | `#3B82F6` | ~15% |
| `ready` | 9.0 ≤ score < 9.5 | `#10B981` | ~10% |
| `elite` | score ≥ 9.5 | `#F59E0B` | ~5% |

### 10.3 Ciclo de Vida do Badge

```
emitido_em  → data de emissão
expires_at  → emitido_em + INTERVAL '1 year'  (1 ano de validade)
renovado_em → data de renovação (se aplicável)
pago        → boolean (só aparece publicamente se pago = true)
reivindicado → boolean (empresa reivindicou o badge)
```

### 10.4 Reivindicação (pela Empresa)

- `POST /api/certifica/reivindicar/{token}` — **sem autenticação necessária** (link público)
- A empresa fornece apenas o email ao reivindicar
- Uma vez reivindicado, `reivindicado = true` e `reivindicado_em = now()`

### 10.5 Badge SVG — Regras Técnicas

- Gerado em Python puro (f-string SVG — sem bibliotecas externas)
- `Cache-Control: public, max-age=3600` (1 hora de cache)
- `badge_token = encode(gen_random_bytes(16), 'hex')` — 32 caracteres hexadecimais, UNIQUE
- Incorporável: `<img src="/certifica/badge/{token}.svg" height="80">`
- Link de verificação: `/certifica/verificar/{token}` → página HTML pública

---

## 11. Regras do Hermes (Voz & Persona)

### 11.1 Persona Learning (Claude Haiku)

**Input:** últimos 30 leads do tenant + últimas 10 chamadas de voz  
**Output JSON:**
```json
{
  "tom":         "formal|neutro|casual|urgente",
  "tamanho_msg": "curto|medio|longo",
  "usa_emoji":   true|false,
  "abertura_padrao": "texto da abertura que mais converte",
  "cta_padrao":      "call-to-action que mais converte",
  "insight":         "análise do padrão comunicativo do tenant"
}
```

- Persona é **única por tenant** (`UNIQUE(tenant_id)`)
- Actualizada apenas quando o tenant chama `POST /api/hermes/persona/analisar`

### 11.2 Variantes A/B — Regras

- `template` pode conter: `{nome}`, `{cidade}`, `{gargalo}`, `{ai_hook}`
- `canal`: `whatsapp`, `voice`, `email`
- `nicho`: nullable (NULL = aplica-se a todos os nichos)
- `taxa_resposta` = coluna GENERATED ALWAYS AS `(total_respostas/total_enviados × 100)`
- Selecção de variante: Claude Haiku escolhe com base em nicho + taxa_resposta histórica

### 11.3 Chamadas de Voz (Vapi)

**Configuração obrigatória:**
```
VAPI_KEY             → API key do Vapi.ai
VAPI_PHONE_NUMBER_ID → ID do número configurado no Vapi
```

**Sem VAPI_KEY:** chamada criada com `status = 'simulada'` — nunca lança erro

**Modelo IA na chamada:** `claude-haiku-4-5` (via Vapi)  
**TTS:** ElevenLabs (voz definida por tenant em `hermes_personas.voz_id`)

**Outcomes possíveis:**
```
respondeu    → lead atendeu e respondeu
nao_atendeu  → chamada sem resposta
voicemail    → caixa de voz
converteu    → lead aceitou próximo passo
perdeu       → lead recusou
```

### 11.4 Análise Pós-Chamada (Claude Haiku)

- Webhook `POST /api/hermes/voice/webhook` recebe transcrição do Vapi
- Claude Haiku analisa transcrição → `analise_claude` + `proximo_passo`
- Resultado gravado em `hermes_voice_calls`

---

## 12. Regras de Privacidade & Isolamento de Dados

### 12.1 RLS (Row Level Security) — Obrigatório em Todas as Tabelas

| Tabela | Regra de Acesso |
|--------|----------------|
| `leads_diagnostico` | `tenant_id = auth.uid()` (ou tenant do user) |
| `tenants` | `user_id = auth.uid()` |
| `scraper_jobs` | `tenant_id = auth.uid()` |
| `marketplace_packs` | Públicos se `status=active`, ou `creator_id = auth.uid()` |
| `pack_subscriptions` | `tenant_id = auth.uid()` |
| `api_keys` | `user_id = auth.uid()` |
| `api_usage_logs` | Só se a key pertence ao user |
| `sub_tenants` | `parent_tenant_id` pertence ao user |
| `lead_listings` | Activas visíveis a todos; modificação só pelo owner |
| `lead_bids` | `bidder_tenant_id = auth.uid()` |
| `lead_purchases` | Buyer ou seller do tenant |
| `certifications` | Leitura pública se `pago=true`; escrita pelo tenant owner |
| `hermes_personas` | `tenant_id = auth.uid()` |
| `hermes_variants` | `tenant_id = auth.uid()` |
| `hermes_voice_calls` | `tenant_id = auth.uid()` |

### 12.2 Bypass de RLS

- `service_role` (chave de serviço Supabase) bypassa **todas** as políticas RLS
- Usado **apenas** pela API Bridge FastAPI (server-side com SUPABASE_SERVICE_KEY)
- **Nunca** exposto no frontend

### 12.3 Dados Pessoais — Regras de Exposição

| Dado | Exposição |
|------|-----------|
| Nome da empresa | Privado — só ao tenant owner e após compra na arbitragem |
| Telefone / WhatsApp | Privado — nunca exposto no mercado de arbitragem |
| Email | Privado — idem |
| Nicho, cidade, score, gargalo | Públicos — expostos no mercado como preview |
| Badge SVG | Público — URL permanente após emissão paga |

---

## 13. Regras de Scraping & Auditoria Digital

### 13.1 Nichos Suportados

```
advocacia | estetica | clinica | dentista | contabilidade | imobiliaria | farmacia | restaurante
```
Validação Pydantic: `pattern=r'^(advocacia|estetica|clinica|dentista|contabilidade|imobiliaria|farmacia|restaurante)$'`

### 13.2 Modos do Scraper

| Modo | Fonte | Custo | Notas |
|------|-------|-------|-------|
| `demo` | Dados sintéticos | €0 | Para testes, sem HTTP real |
| `osm` | OpenStreetMap (Overpass API) | €0 | Gratuito. Fallback: overpass.kumi.systems |
| `places` | Google Places API | ~€32/1000 pesquisas | Após free tier. Melhor cobertura |

### 13.3 Limites do Scraper por Job

- Mínimo: 1 lead por job
- Máximo: 50 leads por job (`ge=1, le=50`)
- Timeout: 10 minutos por job (`timeout=600` em subprocess)

### 13.4 Auditoria Digital — Componentes do Score (V3+)

1. Existência de website (HTTP request)
2. HTTPS válido (SSL check)
3. Responsivo mobile (viewport meta tag)
4. Velocidade aproximada (tempo de resposta HTTP)
5. Formulário de contacto presente
6. Redes sociais referenciadas
7. Google Business Profile (via nome + cidade)
8. Sem website → score_digital = 10 (oportunidade máxima)

### 13.5 AI Hook (Claude Haiku — V5+)

Gerado por `AuditorIA.auditar(nome, nicho, html, score)`:
- Analisa HTML do site + score + nicho
- Retorna: `gargalos_ia` (lista) + `hook_personalizado` (texto outreach)
- Template vars para mensagens: `{nome}`, `{cidade}`, `{gargalo}`, `{ai_hook}`
- Fallback: se `ANTHROPIC_API_KEY` ausente, usa templates estáticos rotativos

---

## 14. Design System & Identidade Visual

### 14.1 Paleta Global Vanguard (V5–V9)

```css
--obsidian:    #0A0A0A   /* fundo base */
--cyan:        #00F0FF   /* acento principal */
--violet:      #7B2FFF   /* acento secundário */
--deep-purple: #1A0B2E   /* fundo profundo */
```

### 14.2 Paletas por Produto

| Produto | Estética | Cores Principais | Fontes |
|---------|----------|-----------------|--------|
| SaaS Dashboard | Neural Command Center | `#080810` + `#00F0FF` + `#7B2FFF` | DM Mono + Inter |
| Marketplace V7 | Dark Bazaar | `#0C0C0E` + `#F59E0B` (amber) | Cormorant Garamond + IBM Plex Mono |
| Intelligence API V8 | Sovereign Glass | `#040D18` + `#A3FF57` (lime) | Syne + Fira Code |
| Score™ Microsite V9 | Obsidian Exchange | `#0A0802` + `#C5A028` (gold) | EB Garamond + JetBrains Mono |
| Certifica V9 | Dark Auth Financial | `#0A0802` + `#C5A028` | EB Garamond + JetBrains Mono |

### 14.3 Princípios de Design (imutáveis)

- **PWA Obrigatório:** manifest.json em todos os frontends instaláveis
- **Glassmorphism:** `backdrop-filter: blur()` + `background: rgba(...)` nos cards
- **Dark-First:** fundo escuro em todos os produtos (nunca fundo branco)
- **Cyber-Premium:** UI estilo startup bilionária, nunca "template WordPress"
- **Sem Inter/Arial/Roboto** nos headings — sempre fonte de carácter para display

---

## 15. Changelog por Versão

### V1 (PWA Quiz + Diagnóstico)
- **Regras adicionadas:** Captura de leads (nicho, gargalo, nome, whatsapp), schema inicial `leads_diagnostico`

### V2 (Shadow Closer — Inteligência de Vendas)
- **Regras adicionadas:** Algoritmo de scoring V2 (base_gargalo × mult_nicho + bónus_semântico), tiers VIP/Quente/Frio, Cockpit com autenticação

### V3 (Scraper Outbound)
- **Regras adicionadas:** Score Digital 0-10 via auditoria HTTP, modos osm/demo/places, nichos suportados, "sem website = score 10"

### V4 (incremental — não documentado)

### V5 (Soberano Digital)
- **Regras adicionadas:** Claude Haiku como Auditor IA (gargalos_ia + hook_personalizado), Docker Mestre, White-Label (brand_config), fallback graceful sem API key

### V6 (SaaS Multi-Tenant)
- **Regras adicionadas:** Planos (trial/starter/pro/enterprise), quotas (20/100/500/2000), ciclo 30d, Stripe Billing, JWT Auth, RLS obrigatório por tenant

### V7 (Marketplace de Nichos)
- **Regras adicionadas:** Split 70/30 (Stripe Connect Express), ciclo de vida de pack, avaliações 1-5, UNIQUE subscrição por tenant+pack, Feed de Intenção

### V8 (Sovereign Data — Intelligence API + Fractal)
- **Regras adicionadas:** API Keys (SHA-256, formato vng_live_prefix_token), rate limits por plano (1k/5k/50k/∞), empresa endpoint Starter+, Fractal exclusivo Pro/Enterprise, quota cascade sub-tenants, Materialized Views

### V9 (Sovereign Economy)
- **Regras adicionadas:** COMISSAO_VANGUARD = 0.30 (arbitragem), lance_minimo = max(preco_base, maior_lance + €0.50), privacidade no mercado (só preview), Certificação score≥8.0 níveis 4, badge SVG cache 1h, reivindicação pública sem auth, Hermes persona por tenant, variantes A/B com taxa gerada, Vapi sem key → modo simulada

### V10 (Sovereign Fortress)
- **Regras adicionadas:** Health check 5 serviços em paralelo (asyncio.gather), overall=critical dispara webhook Director, IA Firefighter Claude Haiku retorna JSON estruturado, Stress Test Protocol ≥99% + p95<500ms = FORTRESS IMPENETRÁVEL, 3 novas tabelas (system_incidents, health_checks_log, stress_test_results)

### V11 (Sovereign Launch — Identidade e Presença Digital)
- **Regras adicionadas:** Ver §16 abaixo.

---

## §16 — Identidade e Presença Digital (V11)

### 16.1 Logo Neural V — Regras de Uso da Marca
- O Logo "Neural V" é o símbolo oficial da Vanguard Tech. Consiste numa geometria em V com gradiente Cyber Cyan (#00F0FF) → Deep Purple (#7B2FFF) e nodes neurais nos vértices e midpoints.
- **Onde é obrigatório:** Navbar do site principal, sidebar do dashboard SaaS, badges SVG Certifica™, todos os documentos oficiais e relatórios de tenant.
- **Proibido:** distorcer as proporções, alterar as cores, usar sobre fundo branco sem wrapper escuro, remover o efeito glow.
- **Ficheiro canónico:** `saas/assets/img/logo-neural-v.svg` — este ficheiro é a fonte de verdade da marca.

### 16.2 Domínio e Subdomínios
- **Domínio principal:** `vanguardtech.io`
- **Subdomínios reservados:**
  - `api.vanguardtech.io` → API Bridge (porta 9000)
  - `market.vanguardtech.io` → Marketplace Dark Bazaar
  - `verify.vanguardtech.io` → Verificação pública de Certificados
  - `n8n.vanguardtech.io` → Painel n8n (acesso interno)
- **HTTPS obrigatório** em todos os domínios em produção (Let's Encrypt via EasyPanel/Traefik).

### 16.3 Rate Limiting — Política de Protecção
- **Endpoint geral `/api/`:** 30 req/min por IP (burst 10)
- **Endpoint scraper `/api/scraper`:** 5 req/min por IP (burst 2) — custo computacional alto
- **Endpoint público `/v1/`:** 120 req/min por IP
- **Resposta excedida:** HTTP 429 com header `X-RateLimit-Policy`
- **Regra de negócio:** o rate limiting é por IP, não por tenant — tenants com muitos utilizadores devem usar API Keys da Intelligence API.

### 16.4 Predictive Lead Routing — Regras do Match Score
- **Fórmula:** Match Score = 40% nicho_match + 35% taxa_conversao + 15% score_tenant + 10% quota_livre
- **Top-3:** o sistema retorna sempre os 3 melhores tenants, nunca apenas 1 (evita monopolização)
- **Persistência:** cada sugestão é gravada em `predictive_matches` para retreino futuro
- **Privacidade:** o lead-owner só vê o match score, não os dados internos do tenant sugerido

### 16.5 Auditoria de Dados
- Toda operação sensível gera entrada em `audit_log` (14 tipos de acção definidos)
- Logs de auditoria são imutáveis (RLS: apenas service_role pode inserir)
- Nginx regista todas as requests em formato `audit_vanguard` com timestamp ISO, IP, status, latência
- Retenção recomendada: 90 dias em produção

---

## §17 — Ignition Cockpit & Closer Machine (V12)

### 17.1 Instant Reality Scanner — Regras do Motor de Análise
- O Scanner aceita qualquer URL e retorna um **Digital Maturity Score™ (0–10)** baseado em 6 dimensões: Presença Digital, Velocidade, Conversão, SEO, Automação, Segurança.
- Os scores são **determinísticos por domínio** (hash SHA-based seed) — o mesmo domínio retorna sempre o mesmo resultado, garantindo consistência em demos e partilhas.
- São sempre apresentados exactamente **3 gargalos críticos**, escolhidos das dimensões com scores mais baixos.
- O Ghost Loader tem duração mínima de 3.9 segundos para criar a percepção de análise profunda (confiança).
- O scanner é **frontend-only** na versão pública — sem dependência de backend para a demo.

### 17.2 Protocolo de Parceiros Fundadores (50/50 Share)
- Parceiros que entrarem antes de 100 clientes activos têm direito a **50% de participação nos lucros** do projecto que co-gerarem.
- A qualificação como Parceiro Fundador exige: (1) contribuição técnica documentada OU (2) 3 clientes indicados fechados OU (3) investimento mínimo de €500 no desenvolvimento.
- O estatuto de Parceiro Fundador é permanente e não pode ser revogado, excepto por violação das regras da Constituição Mestre.
- **Registo:** cada parceiro fundador é registado na tabela `founder_partners` no Supabase com data de entrada, percentagem, e modalidade de contribuição.

### 17.3 Protocolo de Selos Pioneiros
- Os primeiros **50 clientes** recebem o **Selo Pioneiro Vanguard™** — badge digital especial com numeração única (#001–#050).
- O Selo Pioneiro garante: acesso vitalício ao plano em vigor na data de entrada, suporte prioritário e menção pública na "Galeria dos Pioneiros" (página dedicada).
- Os Selos são gerados como SVGs únicos (similar ao Certifica™) e entregues via e-mail automaticamente.
- A numeração é sequencial e imutável — não existe Selo #017 bis.

### 17.4 Closer Machine — Regras da Orquestração Hermes V1
- O Hermes abre **automaticamente** após o scan, focando a abertura exactamente no gargalo #1 identificado.
- A linguagem do Hermes é **directa, específica e urgente** — nunca genérica. Sempre menciona o score exacto e o domínio analisado.
- O fluxo de conversa tem 3 fases: (1) Abertura com diagnóstico → (2) Oferta de proposta → (3) Geração de PDF → Agendamento.
- A Proposta PDF inclui obrigatoriamente: score, 3 gargalos com impacto, plano de 30 dias, e footer Vanguard com dados de contacto.
- O PDF é gerado **client-side** (jsPDF) — sem servidor, sem armazenamento, sem GDPR issues.

### 17.5 Authority Share — Regras do Card de Autoridade
- O card de autoridade é gerado via `html2canvas` a partir do visual renderizado no browser — sempre reflecte os dados reais do scan.
- A cor do score no card segue a escala: Crítico (#FF8080), Baixo (#FFB800), Médio (#00F0FF), Alto (#00FF88).
- O card inclui sempre: logo V, domínio analisado, score, tier, 2 gargalos principais, e o URL vanguard.tech.
- Download em PNG 2.5x resolução para qualidade em redes sociais.

### 17.6 Living HUD — Princípios de Design V12
- **Ghost Holographics:** Skeleton loaders com animação neural de nodes conectando durante o scan.
- **Bento Grid:** O Dashboard usa grid de 12 colunas com células que respiram via bordas animadas.
- **Status Dots:** Dots pulsantes indicam estado em tempo real (verde = online, âmbar = atenção, vermelho = crítico).
- **Scanline:** Cada HUD card tem uma linha de shimmer animada na borda superior.
- **Corner Brackets:** Decoradores de canto militares em todos os painéis de alto valor.

---

### Changelog V12 (Sovereign Ignition Cockpit)
- **Regras adicionadas:** Instant Reality Scanner (6 dimensões, score 0-10, 3 gargalos), Protocolo de Parceiros Fundadores (50/50 share), Protocolo de Selos Pioneiros (#001–#050), Closer Machine Hermes V1 (chat + PDF proposal), Authority Share Card (png social), Living HUD Design System (Ghost Holographics + Bento Grid)

---

---

## §18 — Protocolo de Expansão e Viralidade (V13)

### 18.1 Marketing de Diagnóstico — Regra Zero-Friction
- O **Instant Reality Scanner** na Home é a porta de entrada obrigatória para qualquer novo visitante. Não existe formulário de e-mail antes do scan — apenas WhatsApp **após** o valor ser entregue.
- Sequência canónica: `URL no scanner → 3.9s Ghost Loader → Score + 3 Gargalos → Hermes abre automaticamente → WhatsApp`.
- **Proibido:** pedir e-mail, nome ou qualquer dado pessoal antes de o visitante ver o seu score. O valor vem primeiro, os dados depois.
- A taxa de abandono máxima aceitável no scanner é **10%** — acima disso, o fluxo deve ser revisto.

### 18.2 Cláusula de Meta-dados Setoriais (Censo Digital)
- A Vanguard detém o direito irrevogável de **agregar anonimamente** os dados de todos os scans para produzir o Censo Digital Vanguard™.
- Os dados agregados contêm exclusivamente: nicho, score médio, gargalo mais frequente, data do scan (sem identificadores de utilizador ou empresa).
- O Censo é **público** e serve como motor de viralidade orgânica — "o sector da advocacia tem score médio 3.2/10" é notícia que se espalha.
- Nenhum dado pessoal (nome, domínio, contacto) é incluído no Censo. Conformidade RGPD/LGPD garantida.

### 18.3 Cláusula de Aprendizado Colectivo Anónimo (Rede Hermes)
- O que o Hermes aprende num nicho (taxa de resposta por mensagem, objecções frequentes, melhores CTAs) beneficia **toda a rede Vanguard**, não apenas o tenant que gerou os dados.
- O aprendizado é **anónimo e agregado** — a variante A/B que converte melhor no sector de Saúde passa a ser a variante padrão para todos os tenants do mesmo sector.
- Mecanismo técnico: `hermes_variants.taxa_resposta` é actualizado globalmente por nicho (não por tenant) quando um threshold de 50 respostas é atingido.
- Esta regra é a fonte de **vantagem competitiva cumulativa** da Vanguard — quanto mais tenants, mais inteligente fica o Hermes para todos.

### 18.4 Viral Badge Upgrade — Regras do Selo Embeddable
- O **Selo de Maturidade™** é o principal mecanismo de distribuição orgânica da Vanguard.
- Qualquer empresa auditada pode receber o badge HTML e embeder no seu site. O badge linka para `/preview/?d=dominio`.
- Ao clicar num badge num site externo, o visitante é levado ao HUD Preview personalizado com o score da empresa anfitriã.
- **Viral loop:** o preview termina sempre com CTA "Analise o seu site gratuitamente" → novo scan → novo lead.
- Regras técnicas do badge:
  - Score ≥ 7.0 → badge desbloqueado gratuitamente após scan
  - Score < 7.0 → badge desbloqueado após activação de plano (pressão natural de compra)
  - O link do badge **nunca expira** — o preview é gerado client-side, sem servidor

### 18.5 Partnership API — Splits e SLA
Parceiros que integram a Intelligence API da Vanguard nos seus produtos:

| Plano | Preço | Scans/mês | Branding | Revenue Share |
|-------|-------|-----------|----------|---------------|
| Free | €0 | 10/dia | Vanguard | — |
| Agency (€49/mês) | €49 | 500 | Vanguard nos PDFs | — |
| White-Label (€149/mês) | €149 | 2000 | Logo próprio | 20% de leads convertidos |

- **Revenue share White-Label:** 20% do valor do primeiro mês de contrato de cada cliente trazido pelo parceiro
- A agência pode cobrar o preço que quiser — a Vanguard não interfere na margem do parceiro
- Cada agência recebe uma API Key no formato `vg-api-{8chars}` com rastreio de uso

### 18.6 SLA de Autocura — Protocolo de Resposta a Incidentes
Formaliza as garantias do sistema Fortress (V10) como compromisso de negócio:

| Nível | Condição | Acção | Tempo máximo |
|-------|----------|-------|--------------|
| **CRITICAL** | Qualquer serviço DOWN | Webhook Director notificado automaticamente | **< 60 segundos** |
| **HIGH** | `overall_status = degraded` | IA Firefighter analisa logs + gera diagnóstico | **< 5 minutos** |
| **MEDIUM** | Stress test falha (taxa_sucesso < 99%) | Alerta no dashboard + sugestão de optimização | **< 15 minutos** |
| **LOW** | Health check intermitente (flap) | Log em `health_checks_log` + análise no próximo ciclo | **< 1 hora** |

- O Director Webhook recebe JSON estruturado: `{serviço, severidade, diagnóstico_ia, acção_sugerida}`
- A Vanguard compromete-se a **notificar o Director em < 60 segundos** após qualquer queda crítica
- Resoluções automáticas (IA Firefighter) não substituem a intervenção humana — apenas informam e sugerem

---

### Changelog V13 (Global Domination & Viral Traction)
- **Regras adicionadas:** §18 completo — Marketing de Diagnóstico Zero-Friction, Cláusula de Meta-dados Setoriais, Aprendizado Colectivo Anónimo, Viral Badge Upgrade, Partnership API splits, SLA de Autocura < 60s

---

## §19 — Protocolo PDCA & Autocrítica Institucional (V14)

### 19.1 Performance Ledger Obrigatório
- A cada versão entregue, o `VANGUARD_PERFORMANCE_LEDGER.md` **deve ser actualizado** com ciclo PDCA completo (Plan → Do → Check → Act) antes do commit final.
- Sem entrada no Ledger → a versão não está oficialmente concluída, independentemente do código entregue.

### 19.2 Classificação de Dívidas Técnicas

| Prioridade | Critério | Prazo máximo para resolução |
|------------|----------|-----------------------------|
| **P0 — Crítica** | Bloqueia produção, risco de perda de dados, falha de segurança | Próxima versão (obrigatório) |
| **P1 — Alta** | Degrada funcionalidade visível, risco de escalabilidade iminente | 2 versões |
| **P2 — Normal** | Dívida técnica, código duplicado, UX deficiente | 4 versões |

### 19.3 Regra de Acumulação de Dívidas
- **Máximo de 5 dívidas P0 em aberto simultâneas.** Se atingido, a próxima versão é obrigatoriamente de resolução de dívidas — sem novas features.
- **Máximo de 15 dívidas P1.** Acima deste valor, 50% do tempo da próxima versão vai para resolução.
- Dívidas P2 não têm limite — são rastreadas mas não bloqueiam o roadmap.

### 19.4 Hermes Hive Mind — Regras de Promoção de Templates
- Um template Hermes é promovido para "Vanguard Recomendado" quando cumpre AMBAS:
  1. `response_rate > avg_nicho × 1.10` (supera a média do nicho em +10%)
  2. `send_count ≥ 50` (volume mínimo para significância estatística)
- A promoção é automática via `fn_hive_mind_promote()` (pg_cron, domingos 02:00)
- Um template perde o badge "Recomendado" se na semana seguinte outro superar o limiar
- Em demo/desenvolvimento: threshold reduzido para 10 envios (documentado explicitamente)

### 19.5 Regra de Feedback Loop
Todo módulo que gera dados deve ter, no mínimo:
1. **Log de evento** (tabela Supabase ou localStorage) — rastrear o que aconteceu
2. **Métrica derivada** — uma coluna GENERATED ou view que sintetize a qualidade
3. **Acção correctiva** — um mecanismo (trigger, cron ou botão manual) que use a métrica

Módulos sem feedback loop são considerados dívida P2 por defeito.

---

### Changelog V14 (Sovereign Optimization)
- **Regras adicionadas:** §19 completo — PDCA obrigatório, classificação P0/P1/P2, regra de acumulação (máx 5 P0), Hive Mind threshold (50 envios, +10%), feedback loop obrigatório por módulo

---

## §20 — Arquitectura de Custos Operacionais & Breakeven (V15)

### 20.1 Custo Fixo Máximo Aceitável por Fase

| Fase | Clientes | Custo Fixo Máximo | Stack |
|------|----------|-------------------|-------|
| Bootstrap | 0–1 | **€40/mês** | VPS + Supabase + Evolution API |
| Standard | 2–5 | **€70/mês** | + Z-API |
| Escala | 6–20 | **€120/mês** | + VPS dedicado + WABA Meta |
| Enterprise | 20+ | Ilimitado (% receita) | Stack completo |

### 20.2 Custo Variável Máximo por Lead Qualificado
- **Modo texto (Claude Sonnet):** €0.034/lead — tecto absoluto sem voz
- **Modo VIP (com voz Vapi):** €0.40/lead — apenas leads com Maturity Score ≥ 8.0
- **Regra:** Custo variável total num mês não pode ultrapassar 20% da receita MRR do mês anterior

### 20.3 Breakeven Mínimo
- **1 cliente Agency (€49/mês) = infra paga** na fase Bootstrap
- **2 clientes = lucro** na fase Bootstrap
- **Taxa de conversão mínima aceitável:** 3% dos leads qualificados (abaixo → revisão imediata do script Hermes)
- **Ticket médio mínimo de referência:** €300/cliente (abaixo → revisão do modelo de precificação)

### 20.4 Regra de Margem Mínima por Plano
```
Preço_plano ≥ 3 × (custo_lead × volume_leads + custo_fixo_proporcional)
```
Verificação para o plano Agency actual:
- Custo: €0.034 × 500 leads + (€33.99 / 1) = €17 + €33.99 = €50.99
- Preço: €49 → **ABAIXO do limiar 3×** (€152.97)
- **Interpretação:** O plano Agency subsidia a entrada — aceitável na fase de aquisição. A sustentabilidade vem do upsell para White-Label (€149).

### 20.5 Política de Escalabilidade de Custos
- Qualquer novo componente de infra deve ter ROI documentado antes de ser adicionado
- Regra de ouro: cada €1 gasto em infra deve gerar ≥ €10 em receita potencial
- Componentes com ROI < 3× em 3 meses são candidatos a eliminação

### 20.6 Decisão: Evolution API vs Meta WABA Oficial
| Critério | Evolution API | Meta WABA Oficial |
|----------|--------------|------------------|
| Custo | €0 (self-hosted) | $0.0588/conversa |
| Compliance | Informal | RGPD/Meta ToS oficial |
| Volume | Ilimitado | Ilimitado |
| Risco | Conta pode ser banida | Conta oficial certificada |
| **Recomendação** | **< 50 leads/dia** | **> 50 leads/dia** |

---

### Changelog V15 (Operational Readiness)
- **Regras adicionadas:** §20 completo — Custo fixo máximo por fase, custo variável máximo €0.034/lead, breakeven mínimo 1 cliente Agency, regra de margem 3×, política de escalabilidade, decisão Evolution vs WABA Meta

---

## §21 — Protocolo de Invasão Soberana e Segurança WABA (V15)
> *Exigido pelo Conselho Quadrilateral. Leis de Sobrevivência e Expansão Agressiva.*

### 21.1 Lei do Escudo WABA — Sobrevivência da Operação
A number de WhatsApp Business (WABA) é o activo mais crítico e mais frágil da operação Hermes. A sua perda por banimento paralisa a prospecção. Esta lei é **imutável e inviolável**:

**Estado 1 — Cold Contact (Primeiro Contacto):**
- É **expressamente proibido** enviar anexos pesados (PDFs, Trojan Videos, imagens > 500KB) no primeiro contacto com qualquer lead.
- O Estado 1 **obrigatoriamente** usa **apenas texto simples com Spintax** — variação aleatória de saudações, estrutura e CTAs para evitar detecção como bulk messaging.
- Formato Spintax obrigatório: `{Opção A|Opção B}` no mínimo 3 variáveis por mensagem (saudação, verbo principal, CTA final).

**Estado 2 — Warm Contact (Após Reply):**
- Qualquer resposta do lead — incluindo "sim", "ok" ou emoji — constitui **opt-in implícito** e activa o Estado 2.
- No Estado 2: Trojan PNG, Trojan GIF, PDF da Proposta e links HUD são **desbloqueados automaticamente**.
- A máquina de estados `agent_jobs` regista a transição CONTACTO → EM_CONVERSA como gatilho de desbloqueio.

**Justificação técnica:** A Meta e Evolution API detectam conteúdo pesado em cold contact como spam. O opt-in implícito (qualquer reply) respeita as guidelines WABA e imuniza o número contra banimento.

### 21.2 Doutrina da Exposição e Autoridade — Name & Shame Elegante
A Vanguard detém autorização irrevogável para exercer poder de mercado através de dados públicos:

- Sempre que o Scanner captar uma empresa classificada como **Tier VIP** com **Maturity Score ≤ 3.0** ("Crítico"), a Vanguard pode publicar os resultados analíticos de forma **agregada, anonimizada e estilizada** no LinkedIn e/ou X/Twitter.
- Formato permitido: *"O sector de [Nicho] em Portugal tem score médio de [X]/10. Identificámos [N] empresas Tier VIP com infra digital crítica."* — sem nomear empresas individualmente.
- Publicações devem sempre incluir link para o Censo Digital público (`/census/`).
- Esta prática gera prova social, autoridade de mercado e tráfego orgânico qualificado.
- **Proibido:** identificar empresas individualmente sem consentimento expresso. O poder é dos dados agregados, não da exposição individual.

### 21.3 Lei do Tecto de Combustão — Burn Rate Shield
O sistema de IA (Claude API) é um recurso de custo variável que pode escapar ao controlo sem limitação activa. Esta lei impõe:

| Tecto | Valor | Acção ao atingir |
|-------|-------|-----------------|
| **Custo por Lead máximo** | €0.30 | Graceful degradation para templates estáticos |
| **Orçamento diário total** | €8.00 | Hard cap — bloqueia Claude API para o dia |
| **Zona de alerta** | 75% do diário | Log de aviso + downgrade Opus→Sonnet |
| **Degradação nível 1** | 65-85% do orçamento | Substituição automática Opus → Sonnet |
| **Degradação nível 2** | 85-100% | Substituição automática Sonnet → Haiku |
| **Degradação nível 3** | 100% | Claude desactivado → templates estáticos |

- O ficheiro `infra/burn_rate_shield.py` implementa estes limites como middleware FastAPI.
- A degradação é **reversível no dia seguinte** (reset automático à meia-noite).
- Templates estáticos (fallback) mantêm o pipeline operacional sem custo de IA.
- **Os limites são configuráveis** via variáveis de ambiente: `DAILY_AI_BUDGET_EUR`, `MAX_COST_PER_LEAD_EUR`.

### 21.4 Dashboard de Custos em Tempo Real
O cockpit deve exibir permanentemente:
- Custo total do dia em curso (EUR)
- % do orçamento diário usado
- Custo médio por lead (sessão)
- Status do Burn Rate Shield (OK / ALERT / EXCEEDED)


---

## §23 — Sovereign Intent Engine & Motor Comercial (V17)

### 23.1 Sovereign Pixel — Regras de Rastreio de Intenção

- O `pixel.js` (<3KB) é o único script autorizado a ser instalado nos sites dos clientes finais dos tenants. Nunca instalar scripts de terceiros sem auditoria.
- **Classificação de intenção obrigatória:** cada sessão deve ser classificada em exactamente um de: `COLD` / `WARM` / `HOT` / `FIRE`. Não existe classificação intermédia.
- **Algoritmo de classificação (score ponderado):**
  - dwell >90s=2pts, >30s=1pt
  - scroll >70%=2pts, >40%=1pt
  - CTA hover >5s=2pts, >1s=1pt
  - exit intent detectado=2pts
  - clicks >3=1pt
  - FIRE ≥7pts · HOT 4-6pts · WARM 2-3pts · COLD 0-1pt
- **Dispatch:** obrigatoriamente via Beacon API (non-blocking) para `pixel_events_staging` UNLOGGED. Nunca bloquear o thread principal do site do cliente.
- **LGPD/GDPR:** o banner de consentimento é **obrigatório** antes de qualquer rastreio. Sem opt-in explícito (`vp_consent=1`), o pixel não inicializa. Isto não é opcional.
- **Identificação por tenant:** cada evento deve conter `tenant_id` válido. Eventos sem `tenant_id` são rejeitados pelo Worker com HTTP 422.

### 23.2 Cloudflare Worker — Regras do Servidor de Pixel

- O Worker serve `pixel.js` com configuração do tenant injetada em `window.__VP_CFG`. Nunca expor a configuração de um tenant para outro.
- **Cache obrigatório:** 1 hora (`Cache-Control: public, max-age=3600`) — reduz custo de edge computing.
- **Enriquecimento edge:** o Worker adiciona `ip_country`, `ip_city` e `asn` de `request.cf` antes de persistir. Estes campos são metadados edge, não dados pessoais identificáveis.
- **Falha silenciosa:** erros de persistência no Supabase não retornam erro ao site do cliente. O pixel nunca pode degradar a experiência do utilizador final.

### 23.3 Neural Audit Trail — Regras do Relatório Financeiro

- O relatório usa obrigatoriamente a **Tradução Financeira**: gargalos técnicos → Receita Perdida (R$/mês). Nunca apresentar apenas métricas técnicas sem impacto financeiro.
- **Fórmula canónica de Receita Perdida:**
  ```
  trafficEst = 500 + (score/10) × 9500
  convDelta  = 0.023 − (score/10 × 0.023)
  lostRevenue = trafficEst × convDelta × R$800
  ```
- **Versão Free (3 páginas):** gratuita, descarrega directamente. Serve como lead magnet. Inclui capa com gatilho psicológico e 3 gargalos com impacto financeiro.
- **Versão Paid (12 páginas, R$50):** desbloqueada após pagamento via Stripe Connect. O download só é entregue após confirmação de pagamento (`?audit_paid=1`). **Nunca entregar antes do pagamento ser confirmado.**
- **Design obrigatório:** Ion Gold (#C5A028) + Deep Obsidian (#0A0802) em todo o relatório. Nunca usar o design antigo (Cyber Cyan) no Neural Audit Trail.

### 23.4 Motor de Prospecção — Regras do Pipeline

- O pipeline de prospecção é mantido em `data/pipeline.csv` — fonte de verdade para todos os contactos.
- **Estados válidos (máquina de estados):** `NAO_CONTACTADO → CONTACTADO → RESPONDEU → REUNIAO → PROPOSTA → FECHADO` ou `PERDIDO`. Nunca criar estados fora desta lista.
- **Follow-up obrigatório:** prospectos `CONTACTADO` há 2+ dias sem resposta entram automaticamente em `followup_pendente`. O script `prospectar.ps1 -followup` processa esta fila.
- **Mensagem de abertura:** obrigatoriamente menciona o domínio analisado, o score e a receita perdida estimada. Mensagens genéricas são proibidas.
- **Meta por versão:** ≥ 20 novos contactos após cada fechamento de versão.

### 23.5 Protocolo Colaborativo — Regras do Conselho Pentalateral

- O Gemini propõe obrigatoriamente **5 ideias disruptivas para a próxima versão** na sua DIRETRIZ. Não é opcional.
- O Claude avalia as ordens do Gemini com perspectiva técnica antes de executar. Se identificar risco arquitectural, comunica ao Diretor antes de construir.
- O NotebookLM inclui obrigatoriamente uma secção `[CONEXÃO HISTÓRICA]` e `[PADRÃO DE SUCESSO]` em cada Skill gerada.
- O ciclo PDCA fecha **entre versões**, não dentro de versões: Plan (Gemini DIRETRIZ) → Do (Claude build) → Check (Gemini analisa) → Act (Diretor decide).
- **Ritual Pós-Versão:** o `RITUAL_POS_VERSAO.md` define os 8 passos cronológicos obrigatórios. Nenhuma versão está encerrada sem o Ritual completo.
- **O Embaixador propõe obrigatoriamente 5 ideias [E-1..E-5]** baseadas no comportamento real do cliente, após cada loop. São as únicas ideias com ancoragem em evidência comportamental real — não estratégica nem técnica.
- **25 ideias/ciclo [M×2+G+N+E × 5]:** [M-1..M-5] + [E-1..E-5] + [G-1..G-5] + [N-1..N-5]. Ciclo sem 20 ideias = loop incompleto.

---

## §24 — Protocolo do Pentalateral IAH (2026-05-18)

### 24.1 O Embaixador como Membro Ativo

O Embaixador é o 4º membro ativo do Conselho (5º ator incluindo o Diretor). Opera via Claude Projects com memória persistente por cliente.

**Regras de operação:**

1. **Passo 0 Obrigatório:** Todo projeto começa com a ativação do Embaixador — `scripts/ir_ao_embaixador.ps1 -cliente [NOME]`. Sem Embaixador ativado, o projeto não tem filtro de realidade.
2. **MEMORIA_EMBAIXADOR:** Documento vivo em `CLIENTES/[NOME]/CLAUDE_PROJECT/`. Atualizado automaticamente pelo Músculo (P-032) após qualquer deliberação que afete o cliente ativo — sem precisar de intervenção do Diretor.
3. **Passo 8.5 Obrigatório:** Após qualquer reunião com o cliente, Eduardo relata ao Embaixador → Embaixador extrai inteligência, confirma/refuta hipóteses [H], e gera flags para os outros membros.

### 24.2 P-031 — Filtro de Realidade do Embaixador

O Embaixador aplica o Filtro de Realidade a cada ideia dos outros membros:

| Classificação | Quando usar | O que significa |
|---------------|-------------|-----------------|
| **CONFIRMA** | A ideia está alinhada com o que o cliente demonstrou na prática | Ideia aprovada pela realidade — prioridade aumentada |
| **EXPANDE** | A ideia está no caminho certo mas pode ser enriquecida com comportamento real do cliente | Ideia com potencial — Embaixador adiciona contexto de cliente |
| **ALERTA** | A ideia contradiz comportamentos reais ou contexto do cliente que os outros membros não têm acesso | Ideia a reconsiderar — Embaixador explica o conflito |

**Regra:** O Embaixador não veta ideias — ALERTA. O veto é sempre do Diretor. O ALERTA é evidência que alimenta o Veredito.

### 24.3 P-032 — MEMORIA_EMBAIXADOR Automática

O Músculo atualiza `CLIENTES/[NOME]/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md` automaticamente:
- Após qualquer deliberação que revele nova informação sobre o cliente
- Após qualquer gate aprovado que mude o estado do projeto
- Após qualquer relato do Diretor sobre interação com o cliente

O Diretor **nunca** precisa preencher a MEMORIA_EMBAIXADOR manualmente. Se o Músculo não a atualizou após deliberação relevante → falha de processo → registrar no LEDGER.

### 24.4 Nomenclatura Oficial

| Termo antigo | Termo novo (oficial) |
|---|---|
| Quadrilateral | Pentalateral IAH |
| "3 IAs + Diretor" | "4 IAs + Diretor" (5 atores) |
| Loop de 3 LLMs | Loop de 4 LLMs = 25 ideias/ciclo [M×2+G+N+E × 5] |

**Regra:** Em documentos novos e em atualizações, usar sempre "Pentalateral IAH". O termo "Pentalateral" pode aparecer em contextos históricos (versões anteriores a 2026-05-17) mas não em referências ao estado atual do sistema.

---

### Changelog V18 (Pentalateral IAH)
- **Regras adicionadas:** §24 completo — Embaixador como membro ativo (Passo 0 + Passo 8.5), P-031 Filtro de Realidade (CONFIRMA/EXPANDE/ALERTA), P-032 MEMORIA_EMBAIXADOR automática, 25 ideias/ciclo [M×2+G+N+E × 5], nomenclatura Pentalateral IAH oficial, 2 clientes ativos (Valdece + Ingrid)

---

### Changelog V16 (Visual Authority)
- **Regras adicionadas:** Design System Ion Gold/Obsidian como identidade permanente; Badge SVG Edge com cache 24h; Stripe Connect Express para pagamentos diretos tenant-a-tenant; Pixel Staging UNLOGGED para 10M+ eventos/mês; Neural Grid e Cipher Glitch como linguagem visual institucional

---

### Changelog V17 (Sovereign Intent Engine)
- **Regras adicionadas:** §23 completo — Sovereign Pixel (LGPD obrigatório, classificação COLD/WARM/HOT/FIRE, Beacon API), Cloudflare Worker (cache 1h, falha silenciosa), Neural Audit Trail (Tradução Financeira, versões Free/Paid R$50), Motor de Prospecção (pipeline CSV, estados máquina), Protocolo Colaborativo (PDCA inter-versões, Ritual Pós-Versão obrigatório)

---

### 22 - Doutrina de Distribuição Subjacente:
Todo contrato estabelecido entre um Tenant (Agência/Consultor) e um cliente final via ecossistema Vanguard exige a implementação do Selo Dinâmico de Performance. Este selo é a garantia de transparência técnica e serve como o ponto de ancoragem (lock-in) dos dados da empresa na infraestrutura Vanguard. A remoção do selo implica na suspensão imediata dos relatórios de inteligência para o cliente final.

Endpoint: `GET /admin/burn-rate` → JSON com todas as métricas de custo.

---

### Changelog V15 (Sovereign Invasion)
- **Regras adicionadas:** §21 completo — Escudo WABA (cold=texto+Spintax, warm=Trojan desbloqueado), Doutrina da Exposição (Name & Shame agregado), Tecto de Combustão (€0.30/lead, €8/dia, 3 níveis de degradação), Dashboard de Custos Realtime

---

## Como Actualizar Este Documento

**A cada nova versão, adicionar:**
1. Nova entrada no [Changelog](#15-changelog-por-versão) com as regras introduzidas
2. Nova linha em [Modelo de Receita](#2-modelo-de-receita--6-linhas) se linha nova
3. Nova linha em [Splits de Lucro](#3-splits-de-lucro-por-produto) se split novo
4. Nova secção numerada se produto/módulo novo (ex: §12, §13...)
5. Actualizar cabeçalho: `Versão actual:` e `Última actualização:`

> **Este ficheiro é a constituição económica da Vanguard.**  
> O código pode ser refactored. As regras de negócio aqui definidas não mudam sem decisão explícita do Diretor.
