---
name: firecrawl
description: Use when scraping JavaScript-heavy or dynamic websites. WebFetch only gets HTML -- Firecrawl renders JS first. Use for PNCP, gov portals, SaaS competitors.
---

# Firecrawl -- Web Scraping JS Dinamico

## Quando usar

- Sites JavaScript-heavy (SPAs, React, Angular, Vue)
- Portais gov: PNCP (pncp.gov.br), Compras.gov.br
- Sites de concorrentes SaaS com conteudo dinamico
- Qualquer URL onde WebFetch retornou HTML incompleto ou vazio

## Regra P-124 -- Output vai para PENDING_REVIEW (OBRIGATORIO)

**NUNCA** colocar output diretamente em DECISOES.json, WIP_BOARD.json ou doc canonico.
**SEMPRE** enviar para: INTELLIGENCE_HUB/PENDING_REVIEW.md
Musculo cura ANTES de qualquer acao.

## Uso no Pentalateral

| Caso de uso | Destino |
|---|---|
| Auditoria PNCP (G-2 Licitacoes) | INTELLIGENCE_HUB/COMPETITORS/ |
| TRENDS semanal (W-9) | INTELLIGENCE_HUB/TRENDS/ |
| Lead generation | CLIENTES/[PROJ]/LEADS/ |

## Processo

1. WebFetch retornou conteudo completo? SIM -> usar WebFetch (mais rapido)
2. NAO -> invocar Firecrawl com URL alvo
3. Output -> INTELLIGENCE_HUB/PENDING_REVIEW.md
4. Musculo cura: relevante? fonte fidedigna? (P-132: fonte+data obrigatorio)
5. Curado -> mover para destino final

## Fallback (sem Firecrawl MCP disponivel)

Playwright como fallback:
```
mcp__plugin_playwright__browser_navigate(url)
mcp__plugin_playwright__browser_wait_for(timeout: 3000)
mcp__plugin_playwright__browser_snapshot()
```

## Gatilho automatico

Ativar quando detectar:
- "PNCP", "portal gov", "site concorrente" na task
- WebFetch retornou < 500 chars para site que deveria ter conteudo
- Diretor menciona "scrape", "coletar dados", "monitorar site"