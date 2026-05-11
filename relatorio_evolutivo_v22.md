# RELATÓRIO EVOLUTIVO V22 — Autonomous Dominion Engine
**Data:** 2026-05-10
**Ciclo PDCA:** Do (Claude) — domínio autónomo: agenda + retenção + monetização de dados

## O Que Foi Construído

### 1. Hermes Loop Completo (api/hermes_loop.py)
- Google Calendar OAuth 2.0: setup único via `/oauth/start` → refresh_token permanente
- IAH Bridge: Vapi liga para Eduardo quando lead FIRE score >= 9.5 está no checkout
- Haiku sentiment analysis na transcrição da chamada
- Booking automático: freebusy query → próximo slot livre → evento Calendar com Meet link
- §21 imutável: score < 9.5 → HTTPException 403

### 2. Sentinel Escalation Ladder (api/sentinel_escalation.py)
- Tracking pixel 1×1 GIF (base64 nativo, sem deps externas) por email enviado
- Escada automática: Semana 1 (email) → 2 (WhatsApp queue) → 3 (Hermes Voice Eduardo) → 4 (IAH Rescue Plan modal)
- IAH Rescue Plan: modal de 48h injectado via KV bus — oferta de valor, não desconto
- Endpoint `/escalation/run` chamado por pg_cron toda segunda 09:00 BRT

### 3. Oráculo Pulse API v0.1 (api/oracle_pulse.py)
- `GET /api/v1/oracle/pulse` com filtro nicho + region + janela temporal
- `GET /api/v1/oracle/pulse/top-nichos` — ranking semanal
- Auth por API key SHA-256 com billing tracking em `oracle_usage_log`
- `tenant_coverage` transparente — Early Access com pricing grandfathered
- VIEW `oracle_mrr` para visibilidade de receita do Acto III

## Avaliação das Ideias Gemini + Eduardo (V22)

| Ideia | Origem | Decisão |
|-------|--------|---------|
| Hermes Loop + Google Calendar | Gemini | CONSTRUÍDO |
| IAH Bridge (Eduardo recebe a chamada) | Eduardo | CONSTRUÍDO — modo implementado |
| Sentinel Escalation Ladder | Gemini + Eduardo | CONSTRUÍDO |
| IAH Rescue Plan (modal vs desconto) | Eduardo | CONSTRUÍDO — via KV bus 48h |
| Oráculo Pulse API v0.1 | Gemini + Eduardo | CONSTRUÍDO |
| Franchise Intelligence Matrix | Gemini | V23 |

## ANÁLISE DE NEGÓCIO — V22

### Pontos Fortes

**1. O funil já não precisa do Eduardo no meio**
Com o Hermes Loop activo, o ciclo é: lead FIRE → chamada automática → reunião agendada → Eduardo só aparece para fechar. Isto é o principal activo operacional — tempo do Diretor preservado.

**2. Retenção em camadas sem custo de IA**
A Escalation Ladder das semanas 2, 3 e 4 não usa Claude Haiku — usa WhatsApp (grátis), Vapi para Eduardo (< R$0,25), e o KV bus (grátis). Custo de retenção por cliente em risco: < R$1,00. Valor salvo: R$97/mês.

**3. O Oráculo gera um segundo fluxo de receita**
Pela primeira vez, temos um produto que monetiza os dados que o sistema recolhe automaticamente — sem custo marginal por cliente. Cada agência que paga R$500/mês não aumenta os nossos custos de infra.

**4. Transparência como vantagem competitiva**
O campo `tenant_coverage` mostra quantos tenants contribuem para cada nicho. Outros SaaS escondem a cobertura. Nós mostramos — e usamos isso para vender Early Access: "você ajuda a construir o mapa enquanto paga menos".

**5. Arquitectura defensável**
Três camadas de lock-in simultâneas: dados no sistema (o cliente perde histórico se sair), inteligência no relatório (o cliente perde a bússola), e o Oráculo alimentado por todos (rede que fica mais valiosa com cada cliente).

### Pontos Fracos e Riscos

**1. Zero receita com 22 versões construídas — este é o principal risco**
O produto é sofisticado demais para o momento. O risco não é técnico — é de foco. Cada versão construída sem um cliente pagante aumenta o custo de oportunidade. A V22 precisa de ser a última antes do primeiro cliente ou teremos um museu de tecnologia sem mercado.

**Acção correctiva:** MEI + Stripe + git push esta semana, antes de qualquer V23.

**2. Google Calendar OAuth requer Google Cloud Project**
Eduardo precisa de criar o projecto no Google Cloud Console, activar a API e fazer o fluxo OAuth. São 30-45 minutos de setup técnico que podem ser bloqueadores. Se não for feito, o Hermes Loop funciona em modo simulado mas não agenda reuniões reais.

**Acção correctiva:** Documentar o setup em 5 passos exactos. Eduardo pode fazer enquanto aguarda o Stripe ser verificado.

**3. Oráculo sem dados = promessa vazia**
Com 0 clientes hoje, o `global_intent_graph` está vazio. Vender a Pulse API agora seria vender dados que não existem. A cobertura tem de ser honesta.

**Acção correctiva:** Não prospectar o Oráculo até ter >= 3 tenants com `-IntentShare`. Focar 100% no Neural Sentinel primeiro.

**4. Dependência de Vapi para funcionalidades críticas**
O Hermes Loop, o IAH Bridge e os alertas de churn dependem do Vapi. Se o Vapi falhar ou mudar pricing, perdemos 3 funcionalidades de uma vez.

**Acção correctiva:** Garantir que cada endpoint tem fallback gracioso (modo simulado documentado). Não é urgente — é gestão de risco a médio prazo.

**5. Tracking pixel requer actualização do template de email**
O sentinel_report.py não inclui ainda o pixel de abertura. Sem ele, a Escalation Ladder é cega — não sabe se o email foi lido. Esta é a dívida técnica mais impactante da V22.

**Acção correctiva:** Adicionar `<img src=".../track/{token}.gif">` ao template HTML em `sentinel_report.py` antes do primeiro envio real. 30 minutos de trabalho.

### Avaliação do Consultor

**Classificação geral da V22: B+**

O código é sólido e a arquitectura é correcta. O problema não está no que foi construído — está no que falta fazer fora do código. O negócio precisa de um CNPJ, de uma conta Stripe activa e de uma chamada de vendas antes de precisar de mais uma versão.

**Recomendação forte:** Não iniciar a V23 enquanto não houver um cliente Neural Sentinel activo e um relatório Sentinel enviado. O próximo commit deve ser o deploy para Hostinger, não novo código.

## 5 Ideias Disruptivas para V23

---

**[V23-001] FRANCHISE INTELLIGENCE MATRIX**
Painel exclusivo para franqueadoras com `-IntentShare`: ranking de unidades por Maturity Score médio, alertas automáticos de queda de FIRE por unidade, upsell de consultoria de recuperação (R$3.000). Ticket: R$500/mês por franqueadora matriz. Este produto vende-se em uma reunião de 20 minutos com o dono da franqueadora.

---

**[V23-002] ORÁCULO B2B v1.0 — Intent Radar por Código Postal**
Evoluir o Pulse API: adicionar geo_region com granularidade de CEP (extraído de site_domain via GeoIP). "Quais bairros de SP têm mais leads FIRE em clínicas esta semana?" Ticket para agências imobiliárias e de marketing: R$2.000/mês.

---

**[V23-003] SENTINEL UPSELL ENGINE — Haiku como Vendedor**
No Report Card da semana 3+ (quando o cliente vê ROI positivo), o Haiku gera automaticamente uma proposta de upgrade para Projecto IAH (R$3.000-R$6.000) no rodapé do email, personalizada com os dados do tenant. Zero intervenção do Diretor — a IA propõe, o cliente clica, Eduardo fecha.

---

**[V23-004] SOVEREIGN PLAYBOOK DIGITAL**
Cada cliente IAH recebe um plano de 90 dias gerado por Claude Sonnet, onde cada tarefa só pode ser executada usando a plataforma Vanguard (lock-in disfarçado de consultoria). Inclui checkpoints semanais + Sentinel Reports com progresso do Playbook. Ticket: R$500/mês adicional ao projecto IAH.

---

**[V23-005] VANGUARD PARTNER NETWORK**
Programa de parceiros: agências de marketing pagam R$200/mês e indicam clientes. Para cada cliente indicado que activa Neural Sentinel, a agência recebe 20% do primeiro mês (R$19,40). Para cada Projecto IAH: comissão de R$600. A agência se torna canal de vendas activo sem custo fixo para a Vanguard.

---

## Estado do Ecossistema ao Fechar V22

```
ACTO I — SaaS Operacional (V1-V13):            COMPLETO
ACTO II — Terminal de Dados (V14-V22):         95% (aguarda deploy + Stripe + 1 cliente)
ACTO III — Bolsa de Intenção (V22 Oráculo):    v0.1 LANÇADA — aguarda dados
```

## Plano Imediato (Por Ordem de Prioridade Real)

1. **ESTA SEMANA — Não é código:** MEI + Stripe + GitHub Secrets + git push
2. **ESTA SEMANA:** SENDGRID_API_KEY + schema_v22.sql + pg_cron activado
3. **ESTA SEMANA:** 20 contactos via prospectar.ps1 → 1 Neural Sentinel activo
4. **PRÓXIMA SEMANA:** Primeiro Sentinel Report enviado + tracking pixel a funcionar
5. **DEPOIS DO 1.º CLIENTE:** Google Calendar OAuth setup + Hermes Loop activo
6. **COM 3 CLIENTES:** Prospectar primeira agência para o Oráculo Pulse API
