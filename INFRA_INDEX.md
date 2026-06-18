# INFRA_INDEX — Mapa da Infraestrutura Viva da Vanguard

> Gerado na Operação Vault Soberano F3 (2026-06-17). **DOC-ONLY: nenhuma pasta abaixo foi movida.**
> Estas pastas alimentam serviços VIVOS (EasyPanel / Cloudflare / Netlify / Supabase). Têm paths
> relativos frágeis (build context de Docker, wrangler, deploy) e algumas estão hardcoded em
> `.claude/settings.local.json`. **NÃO relocar sem gate de deploy dedicado.** Este índice existe só
> para responder "o que é cada pasta de infra?" sem precisar abrir cada uma.

---

## Mapa pasta → o que é → onde deploia

| Pasta / arquivo | O que é | Deploia em | Observação |
|---|---|---|---|
| `hermes-agent/` | Motor autônomo Hermes (`docker-compose.yml`, skills) | **EasyPanel** projeto `hermes` / serviço `hermes-agent` | Imagem `nousresearch/hermes-agent:latest`. Telegram `@Eduardo431Vanguardbot`. `/opt/data/config.yaml` persiste. |
| `hermes/` | Webhook/bootstrap do Hermes (`Dockerfile`, `webhook.py`) | EasyPanel (mesmo projeto) | `.env.example` = template; segredo real fora do git. |
| `_n8n/` | Config + auditoria + backups de workflows n8n | **EasyPanel n8n** (`vanguard-vanguard-n8n.0ul9nk.easypanel.host`) | Referenciado em `settings.local.json`. `N8N_CONFIG.json`, backups. |
| `n8n_workflows/` | Exports versionados dos workflows W-1..W-12 | EasyPanel n8n (importados) | Fonte de verdade dos workflows; clonar via n8n-remote-v1. |
| `cloudflare/` | Cloudflare Workers (`federation-proxy.js`, `pixel-worker.js`, `intervention-worker.js`) | **Cloudflare** (deploy via `wrangler`) | Pixel/edge de captura. Paths relativos no wrangler — não mover. |
| `supabase/` | CLI state + link do projeto Supabase (`.temp/`) | **Supabase** (projeto linkado) | Estado do CLI; recriável via `supabase link`. |
| `infra/` | Dockerfile da API + schemas SQL + nginx + entrypoint | EasyPanel (build da API) | `schema.sql`, `schema_hermes.sql`, `burn_rate_shield.py`. |
| `.netlify/` | Estado de deploy Netlify (`netlify.toml`, `state.json`) | **Netlify** (`toga-digital-valdece.netlify.app`) | Demo Valdece. `state.json` = link do site. |
| `docker-compose.yml` (raiz) | Compose mestre histórico (API multi-serviço V5+) | EasyPanel / local | Referenciado nas MEMORIAS V5-V11. Verificar antes de reusar. |

---

## Regras
- **Não mover** nenhum item desta tabela sem gate próprio + teste de deploy (decisão técnica da F3).
- Segredos (`hermes-agent/.env`, `N8N_CONFIG.json`, chaves) **nunca** vão ao Drive — protegidos por P-185 (`rclone_secrets_guard.ps1`).
- Runbooks de operação: `PENTALATERAL_UNIVERSAL/OPERACAO/RUNBOOK_EASYPANEL.md` (+ RUNBOOK_W11/W12).
- Credenciais canônicas (gitignored): `N8N Easypanel.txt` · `CHAVES_SISTEMA_VANGUARD.txt`.
