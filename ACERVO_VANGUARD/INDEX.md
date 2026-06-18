# ACERVO VANGUARD — Base Técnica V1-V24 (preservada e indexada)

> Consolidado na Operação Vault Soberano F2 (2026-06-17). **NÃO é legado morto** — é a base técnica
> reutilizável dos projetos Vanguard. Todo o código continua versionado no git; aqui ele fica
> organizado e navegável em vez de espalhado na raiz.
> **Regra:** este acervo é REFERÊNCIA. Nada aqui roda em produção. Infra viva (Hermes/n8n/Supabase/
> Netlify) permanece FORA do acervo, na raiz/INFRA. As MEMORIAS completas de cada versão estão em
> `PENTALATERAL_UNIVERSAL/VANGUARD_HISTORICO/` e nas memórias do Músculo (`project_vanguard_v*`).

---

## ⚠️ DÍVIDA DE SEGURANÇA — CORRIGIR ANTES DE QUALQUER REUSO EM PRODUÇÃO

> Revisão automática de segurança (2026-06-17) flagou 6 vulnerabilidades no código-produto deste
> acervo. **Inertes hoje** (nada roda), mas o acervo semeia componentes para projetos-cliente —
> qualquer reuso DEVE remediar o item correspondente ANTES do deploy. Não copiar "as-is".

| Arquivo | Severidade | Falha | Correção exigida no reuso |
|---|---|---|---|
| `api/arbitrage.py` | **CRÍTICO** | Stripe webhook usa `stripe.api_key` em vez de webhook secret → bypass de assinatura | Usar `STRIPE_*_WEBHOOK_SECRET` dedicado em `construct_event` |
| `api/main.py` | ALTO | CORS `allow_origins=['*']` com `allow_credentials=True` | Allowlist explícita de domínios; sem wildcard com credenciais |
| `api/main.py` | MÉDIO | Tenant data não validada em argv de `docker run` (flag injection via `cidade`) | Pydantic `pattern` em `cidade` + `--` antes de positionais |
| `api/partner_portal.py` | ALTO | `/commission/record` sem auth interna real (só partner key) | Exigir segredo interno/CRON ou validar referral+assinatura paga |
| `api/partner_portal.py` | ALTO | `/referral/register` sem auth → IDOR de tenant | Exigir JWT do tenant ou chamada server-side com segredo |
| `api/oracle_pulse.py` | MÉDIO | Query params interpolados em PostgREST sem validação | Regex/allowlist em `nicho`/`region` ou RPC tipado |

> Origem: alerta `security-guidance` em 2026-06-17, pós-F2. Tag de rastreio: `[ACERVO-SEC-DEBT]`.

---

## Mapa de componentes → origem → reuso

| Pasta/arquivo | O que é | Versão de origem | Reusável para |
|---|---|---|---|
| `api/arbitrage.py` | Lead Arbitrage engine | V9 | Pipeline de leads, scoring de oportunidade |
| `api/certifica.py` | Geração de selo/certificado SVG | V9/V16 | Badge de confiança, prova social |
| `api/badge.py` | Badge SVG Edge (Stripe Connect) | V16 | Selo dinâmico por tenant |
| `api/fortress.py` | Rate limiting + hardening | V11 | Proteção de API, audit log |
| `api/fractal.py` | (engine fractal) | — | Verificar antes de reusar |
| `api/Dockerfile` | Container da API (histórico) | V5+ | Template de empacotamento |
| `saas/` | SaaS multi-tenant (dashboard + index) | V6 | UI multi-tenant, Stripe + RLS |
| `marketplace/` | Marketplace creator (Stripe Connect 70/30) | V7 | Split de pagamento, portal de criador |
| `census/` | Census Engine (UI) | V13 | Coleta/diagnóstico de mercado |
| `cockpit/` | Ignition Cockpit / HUD | V2/V12 | Painel de controle premium |
| `dashboard/` | Dashboard (css+js+html) | V12+ | Living HUD, métricas em tempo real |
| `intelligence/` | Sovereign Data Intelligence API (UI) | V8 | Camada de inteligência, KNOWLEDGE_GRAPH |
| `score/` | Score/diagnóstico (UI) | V9+ | Quiz de diagnóstico, captação |
| `preview/` | Preview de landing | — | Template de preview |
| `quadrilateral/` | Engine Quadrilateral (api+scripts+tests próprios) | V14+ | Motor de auditoria/decisão (predecessor do Pentalateral) |
| `js/closer-machine.js` | Closer Machine | V12 | Automação de fechamento comercial |
| `js/hive-mind.js` | Hive Mind | V14 | Coordenação multi-agente |
| `js/neural-audit-trail.js` | Audit Log neural | V11 | Trilha de auditoria visual |
| `js/burn-rate-shield.js` | Burn-rate shield | — | Monitor de custo/consumo |
| `js/crypto-glitch.js` | Efeito visual cyber-premium | — | Design system (glitch/glass) |
| `js/main.js` | Bootstrap PWA | V1 | Base de PWA |
| `assets/` | css/icons/js/screenshots compartilhados | V1+ | Design system Cyber-Premium |
| `tests/stress_test.py` | Stress test (IA Firefighter) | V10 | Teste de carga, resiliência |
| `PWA/` | Shell PWA histórico (index/sw/manifest/server) | V1-V16 | Base instalável (UI estática inerte) |

> **Ficaram na RAIZ (sistema VIVO, NÃO entram no acervo):** `knowledge_graph.json` (lido pelo
> `session_close.ps1` GATE 6 + `alert_daily_briefing.ps1`) e `utils/Get-ProjetosAtivos.ps1`
> (helper chamado por `churn_watch_autonomo.ps1` e `decisoes_watcher.ps1`). Detectado na review R-05 da F2.

---

## Linha do tempo (resumo — detalhe nas MEMORIAS)

V1 PWA+leads · V2 Shadow Closer+Cockpit · V3 Scraper Outbound · V5 Auditor IA Haiku+Docker+White-Label ·
V6 SaaS Multi-Tenant (Stripe+FastAPI+RLS) · V7 Marketplace (Connect 70/30) · V8 Sovereign Data (Intelligence API+SHA-256) ·
V9 Lead Arbitrage+Certifica SVG · V10 Health Monitor+Firefighter+Stress · V11 Rate Limiting+Audit Log ·
V12 Ignition Cockpit+Living HUD+Closer Machine · V13 Census Engine+Hermes Outbound · V14 PDCA Ledger+Hive Mind+Trojan ·
V15 Real Scanner+War Room · V16 Badge SVG Edge+Stripe Connect (ARR R$4,1M) · V23 Partner Portal+Upsell Engine.

> Modelo atual: **IAH (camada de inteligência), não SaaS.** Este acervo é a herança técnica que semeia
> componentes para projetos-cliente (Ingrid, Valdece, etc.) sem reinventar a roda.
