# Relatório Evolutivo V18 — Recurrence Singularity Engine
> **Data:** 2026-05-10
> **Versão:** V18
> **Status:** Concluída

---

## O QUE FOI CONSTRUÍDO

A V18 transformou o Vanguard de uma plataforma de diagnóstico num **motor de receita recorrente**. Quatro sistemas novos:

**Sovereign Playbook** — Gerador de plano estratégico 90 dias (12 semanas). Cada tarefa está nativamente ancorada a um Power-Up do ecossistema Vanguard — o cliente não executa o plano sem a plataforma activa. Versão gratuita: semanas 1–2 (isca de conversão). Versão completa: desbloqueada com subscrição R$97/mês Neural Sentinel. PDF Ion Gold gerado client-side com jsPDF.

**Neural Sentinel** — Guarda do castelo: analisa o delta semanal de sessões FIRE/HOT/WARM do Sovereign Pixel (V17). Se FIRE cair >15% ou receita estimada em risco ultrapassar R$1.500, dispara alerta vermelho automático. Histórico de 4 semanas bloqueado para não-subscritores — paywall R$97/mês via Stripe subscriptions. Demo com dados seed funciona mesmo sem Pixel instalado — widget sempre visível.

**Diagnóstico Quadrilateral™** — Quiz de 7 perguntas que mapeia o negócio em 4 quadrantes: Presença (P), Aquisição (A), Conversão (C), Retenção (R). Scoring matrix por resposta → quadrante mais fraco identificado → produto Vanguard recomendado automaticamente. Preview com C+R bloqueados cria o gatilho de conversão para entregar o contacto. Supabase guarda scores completos por lead.

**Neural Particle Hero** — Canvas de partículas douradas no hero com conexões neurais em tempo real. 80 partículas (42 mobile), pulsos periódicos, pausa automática via IntersectionObserver. Identidade visual futurista — Design Direction 1.

---

## O QUE MUDOU NA ARQUITECTURA

- `quiz.js` totalmente reescrito: 3 passos → 9 steps com scoring matrix completo
- `index.html` copy reescrita: zero referências a IA/Claude/n8n/Scraper — linguagem de "especialistas"
- `supabase.js` aceita `metadata` JSONB por lead — dados quadrilateral completos
- `v16-elite.css` +200 linhas de estilos quiz card, quad-bars, preview-risk, recommendation panel
- `VANGUARD_INNOVATION_AUDIT.md` [ID-005] processado — Recurrence Singularity Engine documentado

---

## AVALIAÇÃO TÉCNICA DAS IDEIAS DO GEMINI

| Ideia Gemini (V17→V18) | Avaliação | Decisão |
|---|---|---|
| Neural Sentinel R$97/mês | Correcta — MRR defensável via histórico | ✅ Implementado V18 |
| Sovereign Playbook | Correcta — lock-in perfeito | ✅ Implementado V18 |
| Hermes Autonomous Loop | Correcta — depende de dados reais 30+ dias Pixel | V19 (dados ainda acumulando) |
| Sentinel Report Card Email | Boa — stack simples (pg_cron + Resend) | V19 rápido |
| Vanguard Exchange | Prematura — precisa 20+ tenants activos | V20+ |

---

## 5 IDEIAS DISRUPTIVAS PARA V19

### IDEIA 1 — SENTINEL REPORT CARD: Email Semanal Automatizado
Toda segunda-feira às 8h, o Neural Sentinel envia email com o delta da semana anterior: "Esta semana perdeu R$3.200 a mais vs semana passada — veja o que mudou." Stack: Supabase `pg_cron` + SendGrid/Resend API + template HTML Ion Gold. Lock-in temporal: o cliente não sai sem perder o histórico comparativo acumulado semana a semana. Custo: ~R$0,001/email. Implementação: 1–2 dias.

**Impacto:** transforma subscrição passiva (cliente esquece que paga) em subscrição activa (cliente espera o email toda semana).

### IDEIA 2 — STRIPE SENTINEL CHECKOUT REAL
O endpoint `/api/stripe/sentinel-checkout` actualmente não existe — subscrição Neural Sentinel falha em produção. V19 cria o endpoint serverless (Cloudflare Worker ou Supabase Edge Function) com Stripe Billing: `price_id sentinel_97_monthly`, webhook para marcar subscritor em `tenant_subscriptions`, redirect pós-pagamento com `?sentinel_paid=1`. Sem este passo, o MRR é R$0 independentemente do tráfego.

**Impacto:** desbloqueia a única fonte de receita recorrente actualmente bloqueada por infraestrutura.

### IDEIA 3 — HERMES AUTONOMOUS LOOP COMPLETO
Loop fechado sem intervenção humana: sessão FIRE → Claude Haiku gera mensagem personalizada com comportamento real → WhatsApp via 360dialog → Haiku classifica resposta (INTERESTED / NOT_NOW / NEGOTIATING) → actualiza `lead_stage` → cadência diferenciada automática. Custo total: R$0,12/lead (Pixel + Haiku + WhatsApp). Taxa de resposta esperada: +45% vs outbound frio. Depende de dados reais do Pixel (30+ dias activo).

**Fundação:** `prospectar.ps1` já tem a estrutura de cadência — Haiku substitui o copy manual.

### IDEIA 4 — SUPABASE MIGRATION: metadata JSONB + tenant_subscriptions
Dois DDL simples que desbloqueiam funcionalidades críticas: (1) `ALTER TABLE leads_diagnostico ADD COLUMN metadata JSONB` — guarda scores quadrilateral completos, receita em risco e histórico de respostas por lead; (2) `CREATE TABLE tenant_subscriptions (tenant_id, plan, stripe_customer_id, expires_at)` — base do controlo de acesso Neural Sentinel. Sem estas tabelas, os dados quadrilateral são perdidos e o paywall não tem persistência server-side.

**Impacto:** transforma localStorage (frágil) em subscrição server-side auditável.

### IDEIA 5 — INTENT GRAPH: API de Intenção Cross-Tenant
Ao agregar dados FIRE de todos os tenants (quando existirem 30+), o sistema tem a matéria-prima de um grafo de intenção nacional B2B. API privada: "quais PMEs no sector de saúde em SP tiveram sessões FIRE nas últimas 72h?" — vendida a bancos, fundos de M&A e seguradoras. Ticket mínimo: R$15.000/mês por cliente institucional. É o início do Acto III (Bolsa de Intenção B2B) documentado no VANGUARD_INNOVATION_AUDIT.md [ID-003].

**Dependência:** 30+ tenants activos com Pixel instalado há 60+ dias.

---

## PLANO IMEDIATO (próximas 4 semanas)

| Semana | Acção | Meta |
|---|---|---|
| 1 | Ritual pós-V18: Gemini + NotebookLM + Skill V19 | DIRETRIZ V19 pronta |
| 1–2 | 20 prospecções Hermes Manual via prospectar.ps1 | 3+ respostas |
| 2 | V19: Stripe endpoint real + Supabase migration | 1.º pagamento Neural Sentinel possível |
| 2–3 | 1.ª reunião de vendas com Diagnóstico Quadrilateral™ | 1 cliente R$97/mês |
| 3–4 | Sentinel Report Card email semanal | Retenção activa |

---

## ESTADO DO ECOSSISTEMA (2026-05-10)

- **Versões construídas:** 18
- **Clientes pagantes:** 0
- **MRR actual:** R$0
- **Meta V18:** R$97 (1.º Neural Sentinel) + R$270 (1.º Standard)
- **Ferramentas prontas para vender:** Diagnóstico Quadrilateral™ · Neural Audit Trail · Sovereign Playbook · Neural Sentinel (demo) · prospectar.ps1
- **Bloqueador principal:** Stripe endpoint `/api/stripe/sentinel-checkout` não existe → V19 prioridade #1
- **Próximo milestone:** 1 conversa de venda iniciada
