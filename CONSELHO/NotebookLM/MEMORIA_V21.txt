# MEMORIA V21 — Market Consciousness Engine
**Data:** 2026-05-10
**Versão:** V21
**Ciclo PDCA:** Do (Claude) — motor de consciência de mercado

## Arquivos Criados

| Ficheiro | Descrição |
|----------|-----------|
| `api/sentinel_report.py` | Motor de Report Card semanal — SendGrid + Claude Haiku |
| `api/hermes_trigger.py` | Hermes Voice Bridge — fila de triggers score >= 9.5 |
| `infra/schema_v21.sql` | Migrations: sentinel_report_log, global_intent_graph, hermes_voice_triggers |

## Arquivos Modificados

| Ficheiro | Modificação |
|----------|-------------|
| `scripts/iah-clone.ps1` | Parâmetro `-IntentShare` + `dataTithe: 0.15` no brand-config |
| `api/main.py` | Registo de sentinel_report e hermes_trigger routers (V21) |
| `VANGUARD_INNOVATION_AUDIT.md` | [ID-008] adicionado |

## Arquitectura Técnica

### 1. Sentinel Report Card (api/sentinel_report.py)
**Endpoints:**
- `POST /api/sentinel/report/generate/{tenant_id}` — gera e envia relatório manual
- `POST /api/sentinel/report/send-weekly` — envia para TODOS os tenants activos (pg_cron)
- `GET /api/sentinel/report/preview/{tenant_id}` — pré-visualização no Cockpit

**Fluxo:**
1. Agrega eventos FIRE/HOT/WARM dos últimos 7 dias vs 7 dias anteriores (via Supabase)
2. Calcula delta e revenue_risk (FIRE × R$300 estimado por lead)
3. Claude Haiku gera narrativa executiva em 2-3 frases (~$0.04)
4. HTML email Ion Gold/Obsidian com barras de intenção animadas
5. CTA "Intervir Agora" → cockpit com tenant_id para upsell IAH
6. Envia via SendGrid e regista em `sentinel_report_log`

**Dependências de ambiente:**
- `SENDGRID_API_KEY` — chave SendGrid
- `SENDGRID_FROM_EMAIL` — email remetente (relatorios@vanguard.tech)
- `CRON_SECRET` — protege endpoint send-weekly
- `ANTHROPIC_API_KEY` — Haiku para narrativa (fallback estático se ausente)

### 2. Hermes Voice Bridge (api/hermes_trigger.py)
**Endpoints:**
- `POST /api/hermes-trigger/check/{tenant_id}` — verifica leads >= 9.5 do tenant
- `POST /api/hermes-trigger/check-all` — varre todos os tenants (pg_cron/hora)
- `GET /api/hermes-trigger/queue/{tenant_id}` — fila visível no Cockpit
- `POST /api/hermes-trigger/authorize/{trigger_id}` — Diretor autoriza chamada
- `POST /api/hermes-trigger/auto-mode/{tenant_id}` — modo AUTO zero intervenção

**§21 Burn Rate Shield:** Score threshold = 9.5 (imutável — definido em constante)

**Fluxo:**
1. pg_cron chama `/check-all` a cada hora
2. Lê `maturity_scores` VIEW para sessions com score >= 9.5
3. Se trigger ainda não existe para o session_hash → cria em `hermes_voice_triggers` (status: pending)
4. Cockpit exibe fila — Diretor clica "Autorizar" → status: authorized
5. Com `hermes_auto_mode: true` → autorizado imediatamente sem intervenção

### 3. Dízimo de Dados (iah-clone.ps1 + schema_v21.sql)
**Novo parâmetro:**
```powershell
.\scripts\iah-clone.ps1 -Nicho "clinicas" -TenantNome "Rede ABC" -Email "admin@abc.com" -IntentShare
```

**O que muda:**
- `brand-config.js` recebe `intentShare: true, dataTithe: 0.15`
- `tenants.metadata` JSONB recebe `{intent_share: true, dataTithe: 0.15}`
- Função `aggregate_intent_tithe()` (pg_cron segunda 07:00) agrega 15% dos FIRE events da semana anterior para `global_intent_graph`

**Estrutura global_intent_graph:**
```
nicho | geo_region | intent_label | session_count (15%) | week_bucket
```
Com 10 tenants IntentShare: ~150 pontos/semana. Com 50 tenants: mercado nacional mapeado.

## Fundação Reutilizada (Conexão Histórica)

| Componente | Origem | Uso em V21 |
|------------|--------|------------|
| `maturity_scores` VIEW | V19 | Hermes Bridge lê score composto |
| `pixel_events_staging` | V16 | Fonte dos eventos para agregação |
| `tenant_subscriptions` | V19/V20 | Filtro de tenants activos para report |
| `hermes_voice.py` | V9 | Executa chamadas autorizadas pelo Hermes Bridge |
| Burn Rate Shield §21 | V15 | Threshold 9.5 mantido imutável |
| Ion Gold + Deep Obsidian | V16 | Paleta do email HTML do Report Card |

## Dívidas Técnicas

1. **pg_cron a activar:** Extensão pg_cron no Supabase (Extensions → pg_cron → Enable). Três jobs comentados no schema_v21.sql prontos para descomentar.
2. **SENDGRID_API_KEY:** Criar conta SendGrid gratuita (100 emails/dia) + verificar domínio remetente.
3. **CRON_SECRET:** Definir variável de ambiente no servidor para proteger endpoints cron.
4. **Hermes Auto Mode:** Desactivado por defeito — testar manualmente antes de activar por tenant.
5. **geo_region no global_intent_graph:** Actualmente vazio — populate com dados de country_code/site_domain (V22).

## Estado Comercial

- **MRR real:** R$0 (aguarda MEI + Stripe live + primeiro cliente)
- **Report Card:** Pronto para enviar assim que houver 1 tenant com subscrição activa
- **Oráculo B2B:** 0 dados no global_intent_graph — começa a respirar quando primeiro clone usa -IntentShare
- **Hermes Bridge:** Pronto — fila de triggers activa, aguarda leads com score >= 9.5

## Lições Aprendidas

1. O Report Card HTML com barras de progresso por intent label é um diferenciador visual real — o cliente vê a inteligência, não apenas um número.
2. O Dízimo de Dados precisa de ser opt-in (flag `-IntentShare`) e não opt-out — respeita LGPD e cria incentivo para franqueados aderirem.
3. O Hermes Bridge separa corretamente autorização de execução — o Diretor controla o gatilho, o Hermes executa. Zero risco de chamadas não autorizadas.
