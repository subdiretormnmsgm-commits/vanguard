# Relatório Evolutivo V9 — Sovereign Economy
> **Data:** 2026-05-09 · **Versão:** V9.0.0 · **Claude:** Sonnet 4.6

---

## Comparativo V8 → V9

| Dimensão | V8 — Sovereign Data | V9 — Sovereign Economy |
|----------|---------------------|------------------------|
| Linhas de receita | 4 (SaaS, Marketplace, Intelligence, Fractal) | 6 (+Arbitragem, +Certificação) |
| Mercado de leads | Fechado por tenant | Mercado interno entre parceiros |
| Hermes | WhatsApp only | WhatsApp + Chamadas de voz (Vapi) |
| Certificação | Não existia | Badge SVG verificável publicamente |
| Score público | API privada | Microsite Score™ público consultável |
| Integrações IA | Claude Haiku (scraper) | Claude Haiku × 4 (scraper, persona, variante, voz) |
| Endpoints API | 12 | 29 |
| Tabelas DB | 12 | 19 |
| Triggers | 2 | 4 |

---

## Features Entregues V9

### 1. Lead Arbitrage System (Mercado Interno)
**O quê:** Marketplace onde tenants listam leads não atendidos para leilão entre parceiros.  
**Como:** `lead_listings` (preview público) → `lead_bids` (lances) → trigger `trg_fechar_leilao` → `lead_purchases` (split 30/70).  
**Valor:** Monetiza leads "mortos" e cria efeito de rede entre tenants.

### 2. Vanguard Maturity Certificate™
**O quê:** Badge SVG dinâmico + página de verificação pública para empresas com score >= 8.0.  
**Como:** Python f-string SVG puro, token único (gen_random_bytes 16), cache 1h, reivindicação pública sem auth.  
**Valor:** Status symbol B2B, nova receita recorrente anual, difusão viral do Score™.

### 3. Hermes Voice (Vapi + ElevenLabs + Claude Haiku)
**O quê:** Chamadas de fecho automatizadas com voz personalizada por tenant.  
**Como:** Claude Haiku gera script → Vapi executa chamada → webhook analisa transcrição → Claude extrai próximo passo.  
**Valor:** Aumenta taxa de fecho sem esforço humano. Diferenciador único no mercado.

### 4. Persona Learning (Claude Haiku)
**O quê:** IA que aprende o estilo comunicativo de cada tenant analisando histórico.  
**Como:** Prompt estruturado com últimos 30 leads + 10 chamadas → JSON {tom, tamanho, emoji, abertura, cta, insight}.  
**Valor:** Mensagens cada vez mais personalizadas = maior taxa de resposta.

### 5. Vanguard Score™ Microsite
**O quê:** Portal público consultável (score.vanguard.pt) com leaderboard sectorial.  
**Como:** Obsidian Exchange aesthetic — EB Garamond + JetBrains Mono + gold/obsidian palette. Gauge SVG animado, ticker tape, search por empresa.  
**Valor:** Aquisição orgânica. Empresas partilham o Score™ nas redes sociais.

---

## Fluxo de Arbitragem — Diagrama

```
Tenant A
  │
  ├─ Gera lead (scraper) ──────────► leads_diagnostico
  ├─ Não atende em 48h
  └─ Lista no mercado ─────────────► lead_listings (preview sem PII)
                                            │
                          ┌────────────────┤
                          ▼                ▼
                     Tenant B          Tenant C
                     (licita €45)      (licita €62)
                          │                │
                          └────────────────┘
                                   │
                          Leilão encerra
                                   │
                    trg_fechar_leilao (trigger)
                                   │
                          lead_purchases
                          ┌────────────────┐
                          │ preco_pago: €62│
                          │ comissao: €18.6│  (30%)
                          │ vendedor: €43.4│  (70%)
                          └────────────────┘
                                   │
                    Stripe Transfer → Tenant A: €43.40
                    Vanguard retém:              €18.60
```

---

## Deploy Guide V9

### 1. Schema
```sql
-- Executar no Supabase SQL Editor:
\i infra/schema_v9_economy.sql
```

### 2. Variáveis de Ambiente
```bash
# Adicionar ao .env:
VAPI_KEY=vapi_xxxxxxxxxxxx
VAPI_PHONE_NUMBER_ID=ph_xxxxxxxxxxxx
CERTIFICA_URL=https://seu-dominio.com
ANTHROPIC_API_KEY=sk-ant-xxxxxxxxxxxx
```

### 3. Deploy
```bash
docker compose build api
docker compose up -d
# Verificar:
curl http://localhost:9000/health
# → {"version": "9.0.0", "service": "Vanguard SaaS API Bridge V9 — Sovereign Economy"}
```

### 4. Verificação dos Routers
```bash
docker compose logs api | grep "router registado"
# ✓ Lead Arbitrage router registado (/api/arbitrage/)
# ✓ Certifica router registado (/api/certifica/ + /certifica/)
# ✓ Hermes Voice router registado (/api/hermes/)
```

---

## Métricas de Velocidade de Execução

| Etapa | Ficheiros | Linhas |
|-------|-----------|--------|
| schema_v9_economy.sql | 1 | 340 |
| api/arbitrage.py | 1 | ~280 |
| api/certifica.py | 1 | ~320 |
| api/hermes_voice.py | 1 | ~350 |
| score/index.html | 1 | ~250 |
| score/assets/css/score.css | 1 | ~480 |
| score/assets/js/score.js | 1 | ~220 |
| Actualizações (main, nginx, docker, dash, css, js) | 6 | ~400 |
| **TOTAL V9** | **13** | **~2.640** |

---

## Visão LMM do Claude — 4 Ideias Disruptivas para a V10

### IDEIA 1: Vanguard AI Agent — O Closer Autónomo

**O que é:** Um agente Claude que, sem intervenção humana, executa o ciclo completo de vendas:
1. Detecta novo lead no Supabase
2. Selecciona a variante Hermes óptima
3. Envia a mensagem WhatsApp
4. Analisa a resposta com NLP
5. Agenda chamada Vapi se interesse detectado
6. Faz a chamada de fecho
7. Se não converte em 72h → lista automaticamente no mercado de arbitragem

**Por que disruptivo:** Elimina completamente o factor humano no topo do funil. O tenant só intervém no fecho final. Taxa de conversão previsível como uma máquina.

**Implementação sugerida:** n8n workflow + webhook Supabase realtime + Claude Opus como orchestrator. Estado do agente persistido em tabela `agent_jobs`.

---

### IDEIA 2: Vanguard Score™ API Pública — O Standard de Mercado

**O que é:** Transformar o Score™ numa API pública com SDK, para que marketplaces, bancos, seguradoras e plataformas de contratação possam consultar a maturidade digital de qualquer empresa portuguesa.

**Endpoints propostos:**
```
GET /v2/score/{nif}              → Score por NIF (€0.05/consulta)
GET /v2/score/batch              → Batch até 1000 empresas (€0.03/cada)
POST /v2/score/webhook           → Webhook quando score muda >10%
GET /v2/score/sector/{sector}    → Score médio e p90 do sector
```

**Por que disruptivo:** A Vanguard deixa de ser SaaS B2B e torna-se infraestrutura de dados do mercado. Modelo Twilio/Stripe: €0.03-0.05 por consulta, 100k queries/mês = €3.000-5.000 MRR passivo.

**Monetização:** Pay-per-use com Stripe Metered Billing. Dashboard de analytics no portal Intelligence.

---

### IDEIA 3: Vanguard Academy — Conhecimento como Produto

**O que é:** Plataforma de cursos integrada no dashboard, onde os tenants mais performantes monetizam o seu conhecimento de prospecção e fecho.

**Estrutura:**
- `courses` tabela: tenant_autor_id, preço, conteúdo (vídeos/guias/templates)
- Compra via Stripe (30% Vanguard, 70% autor)
- Score do autor como credencial: "Criado por tenant com 94 leads convertidos"
- Certificado de conclusão (extensão natural do Vanguard Certifica)

**Por que disruptivo:** Cria uma 3ª categoria de receita sem custos de produção (o conteúdo é dos tenants). O Dashboard passa de ferramenta a ecossistema. Churn cai quando o tenant é simultaneamente comprador e vendedor de conhecimento.

---

### IDEIA 4: Predictive Lead Routing — IA Decide Quem Atende

**O que é:** Um modelo de ML que, ao entrar um novo lead, prediz qual tenant da rede tem maior probabilidade de fechar e faz o routing automático (com consentimento + preço).

**Funcionamento:**
1. Lead entra → Claude Haiku extrai features (nicho, cidade, gargalo, score, horário)
2. Modelo compara com histórico de conversão de todos os tenants no mesmo nicho
3. Sugere ao lead-owner: "O Tenant B tem 78% de probabilidade de fechar este lead"
4. Lead-owner aceita → lead vai directamente para Tenant B com preço pré-acordado (sem leilão)
5. Se lead-owner recusa → segue para leilão normal

**Por que disruptivo:** Elimina a fricção do leilão para leads de alta qualidade. Cria um mercado de intenção em vez de um mercado de leilão. Aumenta a velocidade de monetização e a satisfação de todos os participantes.

**Implementação sugerida:** Features store em Supabase, modelo lightweight (logistic regression ou gradient boosting) retreinado semanalmente com pg_cron, predicções servidas via nova rota `/api/arbitrage/suggest/{lead_id}`.
