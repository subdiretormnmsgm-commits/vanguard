# MEMORIA_10 — THE SOVEREIGN FORTRESS
> **Versão:** V10 · **Data:** 2026-05-09 · **Arquitecto:** Claude Sonnet 4.6

---

## 1. O Salto da V9 para a V10

A V9 criou a economia soberana — o ecossistema tem mercado, certificação e voz. A V10 **blinda tudo**. Esta é a primeira "Sprint de Excelência": em vez de novos produtos, a Vanguard para, olha para trás e constrói a Torre de Controlo que garante resiliência eterna.

**Antes da V10:** sistema cresceu organicamente, sem monitorização unificada ou autocura.  
**Depois da V10:** infraestrutura impenetrável com health checks contínuos, diagnóstico IA autónomo e stress test validado pelo Director.

---

## 2. Os Três Pilares da Fortress

### 2.1 Health Monitor — Torre de Controlo

**Mecanismo:** `GET /api/fortress/health` verifica 5 serviços em paralelo (asyncio.gather):
- **API Bridge** — `http://localhost:9000/health`
- **Supabase** — `{SUPABASE_URL}/rest/v1/`
- **Anthropic AI** — `https://api.anthropic.com/v1/models`
- **Stripe** — `https://api.stripe.com/v1/balance` (se STRIPE_SECRET_KEY)
- **Vapi** — `https://api.vapi.ai/phone-number` (se VAPI_KEY)

**Estados:** `healthy` / `degraded` / `down`  
**Resposta overall:** se qualquer serviço `down` → overall `critical`; se `degraded` → overall `degraded`  
**Auto-webhook:** se overall `critical`, o endpoint dispara automaticamente o webhook Director

**Dashboard:** health cards com indicador de cor (barra superior) + latência em ms.

### 2.2 IA Firefighter — Diagnóstico Autónomo

**O quê:** o Diretor cola logs de erro no dashboard → Claude Haiku analisa e gera plano de resolução.

**System prompt:** Claude actua como engenheiro sénior especialista em FastAPI + Supabase + Docker + n8n.

**Output JSON (obrigatório):**
```json
{
  "causa_raiz": "...",
  "severidade": "critical|high|medium|low",
  "servico_afectado": "api|supabase|stripe|vapi|n8n|nginx",
  "passos_resolucao": ["passo 1", "passo 2"],
  "tempo_estimado_min": 10,
  "acoes_preventivas": ["acção 1"]
}
```

**Fallback:** se JSON parse falha, retorna `{raw: ..., causa_raiz: 'Parse falhou — ver campo raw'}`.

**Limite:** logs truncados a 4000 chars. Modelo: `claude-haiku-4-5-20251001` (rápido + económico).

### 2.3 Director Webhook — Notificação Automática

**Variável:** `DIRECTOR_WEBHOOK_URL` (Slack/Discord/n8n/WhatsApp)  
**Formato payload:**
```json
{
  "type": "vanguard_incident",
  "text": "🚨 [Vanguard Fortress] CRITICAL — api: Serviço em DOWN",
  "incident": {...},
  "ts": "2026-05-09T..."
}
```
**Garantia:** falha do webhook nunca derruba a API (try/except + fire-and-forget).

---

## 3. Director Stress Test Protocol

**Endpoint:** `POST /api/fortress/stress-test?n=1000`  
**Script independente:** `tests/stress_test.py --n 1000 --url http://... --token ...`

**2 Fases:**
1. **Health storm** (N/2 requests): latência p50/p95/p99 sob carga máxima
2. **Guardrail test** (N/2 requests): trigger de scraper → verifica que 429 dispara correctamente quando quota esgotada

**Métricas retornadas:**
| Campo | Descrição |
|-------|-----------|
| `taxa_sucesso` | % de requests com 2xx |
| `quota_violations` | Contagem de 429 (Guardrail activo) |
| `latencia_p50/p95/p99` | Percentis de latência em ms |
| `rps` | Requests por segundo |

**Veredicto automático:**
- `taxa_sucesso >= 99%` + `p95 < 500ms` → **FORTRESS IMPENETRÁVEL**
- `>= 95%` → **SISTEMA RESILIENTE**
- `< 95%` → **ATENÇÃO** (cria incidente automático sugerido)

---

## 4. Schema V10 — Resumo Técnico

**3 novas tabelas:**
- `system_incidents` — severidade + serviço + diagnóstico IA + estado + webhook
- `health_checks_log` — snapshots periódicos de saúde por serviço
- `stress_test_results` — histórico de stress tests com `taxa_sucesso` GENERATED

**1 função:** `fn_health_summary()` — resumo agregado por serviço (últimas 24h)

**RLS:** todas as tabelas têm RLS activo. Authenticated users lêem + criam incidentes.

---

## 5. Dashboard Pixel Perfect — Correcções V10

**Classes HTML→CSS reconciliadas:**
| Classe HTML (V6-V9) | Mapeamento CSS V10 |
|---------------------|-------------------|
| `.sidebar__header` | Novo CSS adicionado |
| `.plan-starter/pro/enterprise/trial` | Variantes adicionadas |
| `.sidebar__quota-bar/fill/header/reset` | Aliases adicionados |
| `.sidebar__footer/user/user-avatar/etc.` | Aliases completos |
| `.topbar__actions/status/refresh` | Aliases adicionados |
| `.main-content` | CSS adicionado |
| `.section.active` | Animação `sectionIn` |
| `.feed-live-badge`, `.feed-pulse` | CSS adicionado |
| `.nav-item__badge--red/cyan` | Novas variantes |

**Melhorias de animação:**
- KPI cards: hover `translateY(-2px)` + glow sutil
- Skeleton: shimmer animado (antes: fundo estático)
- Section transition: `sectionIn` 0.28s cubic-bezier

---

## 6. Endpoints V10 (7 novos)

```
GET  /api/fortress/health              — health de 5 serviços em paralelo
GET  /api/fortress/incidents           — últimas 24h de incidentes
POST /api/fortress/incidents           — criar incidente (dispara webhook)
GET  /api/fortress/metrics             — tenants, leads, incidentes abertos
POST /api/fortress/diagnose            — IA Firefighter (Claude Haiku)
POST /api/fortress/stress-test         — simula N requests (max 1000)
GET  /api/fortress/stress-test/results — histórico dos últimos 10 testes
```

---

## 7. Configuração V10

```env
# Adicionar ao .env:
DIRECTOR_WEBHOOK_URL=https://hooks.slack.com/services/T.../B.../...
# ou Discord: https://discord.com/api/webhooks/...
# ou n8n: https://n8n.seudominio.com/webhook/fortress-alert
```

**Deploy:**
```bash
# 1. Schema
# SQL: infra/schema_v10_fortress.sql no Supabase

# 2. Build + deploy
docker compose build api
docker compose up -d api

# 3. Verificar Fortress
curl http://localhost:9000/api/fortress/health

# 4. Stress test (1000 req)
python tests/stress_test.py --n 1000 --url http://localhost:9000
```

---

## 8. Impacto no Ecossistema

**Antes da V10:** sistema cresce sem autoconhecimento — uma falha silenciosa pode durar horas.  
**Depois da V10:** qualquer falha detectada em < 30s → webhook Director em < 5s → diagnóstico IA em < 10s.

**Princípio da Fortress:** *a melhor defesa não é nunca falhar — é saber exactamente quando falhou e como corrigir.*

---

## 9. Arquitectura de Ficheiros V10

```
vanguard/
├── api/
│   ├── main.py          (v10.0.0 — Fortress router registado)
│   └── fortress.py      (NOVO — Health + IA Firefighter + Stress)
├── infra/
│   ├── schema_v10_fortress.sql  (NOVO — 3 tabelas + RLS + fn)
│   └── nginx.conf               (mantido)
├── tests/
│   └── stress_test.py           (NOVO — Director Protocol autónomo)
├── saas/
│   ├── dashboard.html           (+ Fortress section + Pixel Perfect fixes)
│   ├── assets/css/saas.css      (+ V10 Pixel Perfect aliases + Fortress UI)
│   └── assets/js/saas-dashboard.js (+ Fortress functions)
├── docker-compose.yml           (+ V10 env + health check melhorado)
├── VANGUARD_KNOWLEDGE_GRAPH.md  (actualizado V10)
├── VANGUARD_BUSINESS_RULES.md   (actualizado V10)
├── TODO_FUTURE.md               (criado)
└── memorias/MEMORIA_10_FORTRESS.md (este ficheiro)
```
