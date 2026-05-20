# MEMORIA V22 — Autonomous Dominion Engine
**Data:** 2026-05-10
**Versão:** V22
**Ciclo PDCA:** Do (Claude) — domínio autónomo: agenda, retenção e monetização de dados

## Arquivos Criados

| Ficheiro | Descrição |
|----------|-----------|
| `api/hermes_loop.py` | Hermes Loop completo: Google Calendar OAuth + Vapi IAH Bridge + Haiku sentiment |
| `api/sentinel_escalation.py` | Escalation Ladder: tracking pixel + cadência 4 semanas + IAH Rescue Plan |
| `api/oracle_pulse.py` | Oráculo Pulse API v0.1: Bússola de Nicho com API key auth |
| `infra/schema_v22.sql` | Migrations: escalation_log, oracle_api_keys, oracle_usage_log, oracle_mrr VIEW |

## Arquivos Modificados

| Ficheiro | Modificação |
|----------|-------------|
| `api/main.py` | 3 novos routers registados (hermes_loop, sentinel_escalation, oracle_pulse) |
| `VANGUARD_INNOVATION_AUDIT.md` | [ID-009] adicionado |

## Arquitectura Técnica Detalhada

### 1. Hermes Loop — api/hermes_loop.py

**Google Calendar OAuth (setup único):**
```
GET /api/hermes-loop/oauth/start → URL Google OAuth
Eduardo visita → autoriza → callback em /oauth/callback → exibe refresh_token
Eduardo copia para GOOGLE_CALENDAR_REFRESH_TOKEN no .env
```
Após isso: ciclo totalmente autónomo, sem nova intervenção.

**IAH Bridge (modo implementado em V22):**
- Trigger: `hermes_voice_triggers` com status `authorized` e score >= 9.5
- Chamada Vapi para DIRECTOR_PHONE (número do Eduardo)
- Script: "Lead FIRE em {site_domain}. Score {X}. Pressione 1 para agir / 2 para amanhã."
- §21 imutável: score < 9.5 → HTTPException 403

**Booking automático (via webhook Vapi):**
```
POST /api/hermes-loop/vapi-webhook
→ Haiku analisa transcrição (interesse: alto/medio/baixo)
→ Se interesse=alto: _find_next_slot() → freebusy API
→ _criar_evento_calendar() com meet link + notificações
→ Update hermes_voice_triggers status = meeting_booked
```

**Variáveis de ambiente necessárias:**
- `GOOGLE_CLIENT_ID` + `GOOGLE_CLIENT_SECRET` (Google Cloud Console)
- `GOOGLE_CALENDAR_REFRESH_TOKEN` (obtido via /oauth/start uma vez)
- `GOOGLE_REDIRECT_URI` (https://vanguard.tech/api/hermes-loop/oauth/callback)
- `DIRECTOR_CALENDAR_ID` (default: 'primary')
- `DIRECTOR_PHONE` (número do Eduardo para IAH Bridge)

### 2. Sentinel Escalation Ladder — api/sentinel_escalation.py

**Tracking pixel de abertura:**
- Pixel 1×1 GIF base64 injectado no email HTML do Report Card
- URL: `<img src="https://vanguard.tech/api/sentinel/track/{open_token}.gif">`
- Quando aberto: UPDATE sentinel_report_log SET email_aberto=true, aberto_em=NOW()
- Token: SHA-256(tenant_id + report_id + key_prefix)

**Escada de escalação (avaliada toda segunda 09:00 BRT via pg_cron):**
| Semana sem abertura | Acção | Custo |
|---------------------|-------|-------|
| 0 | Em dia — nenhuma | R$0 |
| 1 | WhatsApp enfileirado em `escalation_whatsapp_queue` | R$0 |
| 2 | Hermes Voice — Vapi liga para Eduardo com briefing de churn | ~R$0.25 |
| 3+ | IAH Rescue Plan — modal injectado via KV bus por 48h | R$0 |

**IAH Rescue Plan (semana 4):**
- Não é desconto — é uma oferta de valor: "5 prospecções gratuitas no seu nicho"
- Injectado via intervention-worker Cloudflare (TTL 172800s = 48h)
- Custo zero — maximiza percepção de valor sem sacrificar MRR

### 3. Oráculo Pulse API v0.1 — api/oracle_pulse.py

**Endpoints:**
- `GET /api/v1/oracle/pulse?nicho=clinicas&region=SP&semanas=4` — Bússola de Nicho
- `GET /api/v1/oracle/pulse/top-nichos` — ranking dos 5 nichos mais quentes
- `POST /api/v1/oracle/keys` — criar API key para agência (admin)
- `GET /api/v1/oracle/keys/status` — MRR estimado do Oráculo

**Auth:** Header `X-Oracle-Key: vg-oracle-{token}`

**Resposta inclui `tenant_coverage`** — quantos tenants contribuem para aquele nicho.
Honestidade estratégica: agência vê a cobertura crescer → incentivo a trazer mais clientes.

**Pricing:** R$500/mês Early Access por agência cliente. VIEW `oracle_mrr` mostra MRR do Oráculo.

## Fundação Reutilizada (Conexão Histórica)

| Componente | Origem | Uso em V22 |
|------------|--------|------------|
| `hermes_voice_triggers` | V21 | Base do Hermes Loop — triggers autorizados |
| `global_intent_graph` + VIEW `intent_graph_summary` | V21 | Fonte de dados do Pulse API |
| KV bus + intervention-worker | V20 | IAH Rescue Plan modal |
| `pixel_events_staging` | V16 | Dados brutos para tracking de intent |
| `sentinel_report_log` | V21 | Base da escalation ladder |
| §21 Burn Rate Shield | V15 | Threshold 9.5 — imutável |
| Ion Gold + Deep Obsidian | V16 | Paleta visual consistente |

## Dívidas Técnicas V22

1. **Google Cloud Project:** Criar em console.cloud.google.com → activar Calendar API → criar credenciais OAuth (Web App) → URI redirect → copiar GOOGLE_CLIENT_ID + GOOGLE_CLIENT_SECRET
2. **OAuth setup:** Eduardo executa `/oauth/start` uma vez → copia refresh_token → `.env` → reiniciar servidor
3. **Tracking pixel no email:** Adicionar `<img src=".../track/{open_token}.gif">` no template HTML de `sentinel_report.py` — gerar token via `generate_open_token()` do schema_v22.sql
4. **ORACLE_ADMIN_KEY:** Definir no `.env` para proteger criação de API keys do Oráculo
5. **schema_v22.sql:** Executar no Supabase + descomentar job pg_cron da escalação

## Estado Comercial ao Fechar V22

- **MRR Sentinel:** R$0 (aguarda MEI + Stripe + 1 cliente)
- **Oráculo MRR:** R$0 (aguarda 1ª agência parceira — prospectar activamente)
- **Reuniões agendadas pelo Hermes:** 0 (aguarda 1 lead FIRE com score >= 9.5)
- **Sequência crítica inalterada:** MEI → Stripe → git push → 1 cliente → tudo o resto activa em cascata

## Lições Aprendidas

1. O IAH Bridge (Eduardo recebe a chamada, não o lead) é a decisão correcta para esta fase — minimiza risco regulatório de cold calling por IA e mantém o toque humano no momento crítico.
2. O tracking pixel de abertura de email é obrigatório — sem ele a Escalation Ladder é cega. Adicionar ao template HTML do Report Card é a próxima dívida a pagar.
3. A transparência do `tenant_coverage` no Oráculo é vantagem competitiva, não fraqueza — agências que entram cedo ficam com preço grandfathered.
