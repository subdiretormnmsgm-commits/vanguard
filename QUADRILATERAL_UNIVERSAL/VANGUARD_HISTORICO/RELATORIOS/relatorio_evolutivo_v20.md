# RELATÓRIO EVOLUTIVO V20 — Monetization Singularity
**Data:** 2026-05-10
**Ciclo PDCA:** Do (Claude) — motor de receita + produção real

---

## O Que Foi Construído

### 1. Stripe Sentinel Engine — `api/stripe_sentinel.py`
Endpoint completo para subscrição Neural Sentinel R$97/mês em BRL:
- `POST /api/stripe/sentinel-checkout`: cria Customer + Checkout Session Stripe, retorna URL de redirect
- `POST /api/stripe/sentinel-webhook`: processa 4 eventos (checkout.completed, subscription.deleted, subscription.updated, invoice.payment_failed) e sincroniza `tenant_subscriptions`
- Router independente do `stripe_connect.py` (V16) — zero risco de regressão

### 2. CI/CD Hostinger — `.github/workflows/deploy-hostinger.yml`
Pipeline automático: push na branch master → deploy FTP na Hostinger via `SamKirkland/FTP-Deploy-Action`. Exclui automaticamente ficheiros sensíveis (api/, .claude/, NotebookLM/, scripts PowerShell, .env). Activar: definir 3 secrets no GitHub (FTP_SERVER, FTP_USERNAME, FTP_PASSWORD).

### 3. Cockpit de Intervenção — `cockpit/index.html`
Dashboard completo sem dependências externas:
- Stats bar: contagem tenants, sentinel activos, MRR calculado, leads FIRE 24h
- Tenant grid: Maturity Score por tenant com barra animada + status Sentinel
- Modal de intervenção: tipo (oferta agressiva / desconto / consultoria) + mensagem + TTL
- Auto-refresh a cada 60 segundos
- Modo demo automático se Supabase não configurado

### 4. Intervention Button via KV Bus — arquitectura validada
Cockpit → `POST /api/intervention` (intervention-worker.js) → `KV.put(intervention:{tenantId}, payload, TTL)` → federation-proxy.js lê KV em cada request → HTMLRewriter injeta modal de oferta agressivo no site do cliente. O Diretor controla o tráfego dos clientes em tempo real com um clique.

---

## Avaliação das Ideias Gemini (DIRETRIZ V20)

| Ideia | Decisão |
|-------|---------|
| Stripe Sentinel Engine (MRR Blocker) | ✅ CONSTRUÍDO |
| Cockpit de Intervenção (Intervention Button) | ✅ CONSTRUÍDO |
| CI/CD Hostinger Deploy | ✅ CONSTRUÍDO |
| Sentinel Report Card email | 📋 V21 |
| Hermes Autonomous Loop | 📋 V21 |

---

## 5 Ideias Disruptivas para V21

### [V21-001] ORÁCULO B2B — Intent Graph como Produto Institucional
Agregar dados FIRE cross-tenant → API privada vendida a bancos, fundos M&A e seguradoras. *"Quais PMEs em SP tiveram sessões FIRE nas últimas 72h?"* Ticket R$15.000/mês por cliente institucional. Início do Acto III (Bolsa de Intenção B2B).

### [V21-002] HERMES AUTONOMOUS LOOP COMPLETO
Loop fechado zero intervenção humana: real-scanner → lead qualificado → Haiku gera mensagem → WhatsApp envia → Haiku classifica resposta → se score > 8.5 → Vapi liga → agenda demo → CRM actualizado.

### [V21-003] SENTINEL REPORT CARD — Vendedor de Retainers
Email semanal automático: delta FIRE/HOT/WARM + receita em risco + proposta IAH no rodapé (dado gera dor, botão gera faturamento). SendGrid + cron. Stickiness: o cliente espera o relatório toda segunda-feira.

### [V21-004] IAH PROJECT CLONER com Dízimo de Dados
Cada instância clonada com `dataTithe: 0.15` — 15% dos dados de intenção alimentam o Intent Graph global automaticamente. O franqueado cresce, o Oráculo fica mais inteligente. Preparação para venda institucional V22.

### [V21-005] SOVEREIGN CREDIT SCORE — PME como Activo Financeiro
Densidade de eventos FIRE + estabilidade de intenção → score de solvência de PMEs vendido a bancos como alternativa ao balanço tradicional. Primeiro produto do Acto III. Parceria piloto fintech/banco comercial.

---

## Estado do Ecossistema ao Fechar V20

```
ACTO I — SaaS Operacional (V1–V13):     ████████████ COMPLETO
ACTO II — Terminal de Dados (V14–V20):  ██████████░░ 85% (aguarda deploy + Stripe live)
ACTO III — Bolsa de Intenção (V21+):    ░░░░░░░░░░░░ HORIZONTE (V21-001 é a porta)
```

**Próximo milestone crítico:** Eduardo abre MEI → Stripe activo → git push → primeiro cliente paga.

---

## Plano Imediato (esta semana)

1. ✅ Schema V20 executado no Supabase
2. ⬜ Eduardo abre MEI (gov.br — 30 min)
3. ⬜ Criar conta Stripe BR com CNPJ
4. ⬜ Criar produto "Neural Sentinel" R$97/mês BRL → copiar Price ID
5. ⬜ Definir env var `STRIPE_SENTINEL_PRICE_ID` no servidor
6. ⬜ Configurar GitHub Secrets: FTP_SERVER, FTP_USERNAME, FTP_PASSWORD
7. ⬜ `git push` → CI/CD deploy automático na Hostinger
8. ⬜ Testar checkout Sentinel de ponta a ponta
9. ⬜ 20 diagnósticos via prospectar.ps1 → primeiro contacto WhatsApp
