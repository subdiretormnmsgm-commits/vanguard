# RELATÓRIO EVOLUTIVO V21 — Market Consciousness Engine
**Data:** 2026-05-10
**Ciclo PDCA:** Do (Claude) — consciência de mercado + retenção automatizada

## O Que Foi Construído

### 1. Sentinel Report Card (api/sentinel_report.py)
Motor completo de retenção semanal:
- HTML email Ion Gold/Obsidian com delta FIRE/HOT/WARM, barras de intenção e revenue_risk
- Claude Haiku gera narrativa executiva (~$0.04/relatório)
- CTA "Intervir Agora" → Cockpit com tenant_id (upsell IAH no rodapé)
- Endpoint de preview para o Cockpit mostrar o próximo relatório antes do envio
- pg_cron toda segunda-feira 08:00 BRT

### 2. Hermes Voice Bridge (api/hermes_trigger.py)
Ponte autónoma score → chamada:
- Varre `maturity_scores` a cada hora via pg_cron
- Score >= 9.5 → trigger em `hermes_voice_triggers` (status: pending)
- Fila visível no Cockpit → Diretor autoriza (ou modo AUTO)
- §21 imutável: threshold = 9.5, hardcoded, sem excepções

### 3. Dízimo de Dados — IAH Clone V21
- Flag `-IntentShare` no `iah-clone.ps1`
- `dataTithe: 0.15` no brand-config.js e `tenants.metadata`
- Função SQL `aggregate_intent_tithe()`: 15% dos FIRE/HOT events semanais → `global_intent_graph`
- VIEW `intent_graph_summary`: agrega por nicho + geo_region + semana (base do Oráculo B2B)

## Avaliação das Ideias Gemini V21

| Ideia | Decisão |
|-------|---------|
| Sentinel Report Card | CONSTRUÍDO |
| Hermes Autonomous Loop (bridge) | CONSTRUÍDO (bridge) — loop completo V22 |
| Dízimo de Dados / IAH Cloner | CONSTRUÍDO |
| Oráculo B2B — Intent Graph | FUNDAÇÃO CRIADA (global_intent_graph + VIEW) |
| Sovereign Credit Score | V23+ — aguarda regulação |

## 5 Ideias Disruptivas para V22

---

**[V22-001] HERMES LOOP COMPLETO — Zero Humano no Funil**
O bridge está pronto. Agora fechar o loop:
`trigger authorized` → Hermes busca telefone do session_hash via reverse lookup → Vapi liga com persona do tenant → Haiku classifica resposta em tempo real → se positivo, agenda demo no Google Calendar → CRM actualizado. O Diretor só entra para assinar o contrato.

---

**[V22-002] COCKPIT 2.0 — Command & Control Center**
O cockpit actual (V20) é estático. V22: dashboard em tempo real com:
- Mapa de calor de intenção por nicho (Chart.js)
- Fila Hermes Voice ao vivo com "Autorizar" one-click
- Preview do próximo Sentinel Report antes do envio com botão "Editar Narrativa"
- Revenue forecast: MRR actual + MRR potencial (leads FIRE não convertidos × R$97)

---

**[V22-003] ORÁCULO B2B v0.1 — Primeira API Paga**
Com 3+ tenants usando `-IntentShare`, o `global_intent_graph` já tem dados reais.
Lançar endpoint privado: `GET /api/oracle/nicho/{nicho}/pulse` → retorna densidade FIRE/HOT por semana e geo_region. Primeiro cliente: agência de marketing que quer saber "quais clínicas em SP estão aquecidas esta semana". Ticket: R$500/mês por acesso.

---

**[V22-004] SENTINEL ESCALATION LADDER**
O Report Card actual avisa. A V22 escala:
1. Semana 1: email automático (já construído)
2. Semana 2 sem abertura: WhatsApp via Hermes com "Viu o relatório?"
3. Semana 3 sem resposta: Hermes Voice agenda chamada de "revisão de conta"
4. Semana 4: Cockpit alerta Diretor "RISCO DE CHURN" com proposta de desconto gerada por Haiku

---

**[V22-005] FRANCHISE INTELLIGENCE MATRIX**
Painel exclusivo para franqueadoras com `-IntentShare`:
- Mapa de desempenho por unidade (FIRE density por unidade)
- Ranking de unidades por Maturity Score médio
- Alerta: "Unidade Curitiba teve queda de 40% em FIRE esta semana"
- Upsell: consultoria de 30 dias para recuperar a unidade (R$3.000)
Ticket: R$500/mês por franqueadora (acesso ao painel matriz).

---

## Estado do Ecossistema ao Fechar V21

```
ACTO I — SaaS Operacional (V1-V13):       COMPLETO
ACTO II — Terminal de Dados (V14-V21):    90% (aguarda deploy + Stripe live + 1 cliente)
ACTO III — Bolsa de Intenção (V22+):      FUNDAÇÃO PLANTADA (global_intent_graph)
```

## Plano Imediato

1. **CRÍTICO:** Eduardo abre MEI → gov.br/empresas-e-negocios (30 min)
2. **CRÍTICO:** Stripe BR com CNPJ → criar produto Neural Sentinel R$97/mês BRL
3. **CRÍTICO:** GitHub Secrets FTP → git push → CI/CD activa deploy Hostinger
4. **SENDGRID:** Criar conta gratuita + verificar domínio vanguard.tech + definir `SENDGRID_API_KEY`
5. **SUPABASE:** Executar schema_v21.sql + activar pg_cron + descomentar os 3 jobs cron
6. **PRIMEIRO CLIENTE:** prospectar.ps1 → 20 contactos → 1 Neural Sentinel activo → Report Card enviado na próxima segunda-feira
