---
name: mcp-builder
description: Guide for creating high-quality MCP servers. Use when building MCPs to integrate external APIs, in Python (FastMCP) or TypeScript (MCP SDK).
---

# MCP Server Development Guide

## Gatilho automatico Pentalateral

Invocar quando:
- Diretor diz "criar MCP para X" ou "integrar API Y via ferramenta"
- Nova integracao que requer tool customizada
- Hermes Agent precisa de nova capacidade externa

## 4 Phases

### Phase 1: Research and Planning
- Tool naming: [service]_[verb]_[noun] (ex: supabase_insert_row)
- Stack recomendado: TypeScript + Streamable HTTP (remote) / stdio (local)
- MCP spec: https://modelcontextprotocol.io/sitemap.xml

### Phase 2: Implementation

Project structure (TypeScript):
```
src/
  index.ts    -- entry + server
  tools/      -- one file per tool group
  utils/      -- auth, formatters, errors
```

Cada tool: Zod/Pydantic schema + async/await + actionable errors
Annotations: readOnlyHint, destructiveHint, idempotentHint

### Phase 3: Review and Test
```bash
npm run build
npx @modelcontextprotocol/inspector
```

### Phase 4: Evaluations
10 perguntas: independentes, read-only, complexas, verificaveis, estaveis.

## Reference Files
.agents/skills/mcp-builder/reference/: mcp_best_practices.md / node_mcp_server.md / python_mcp_server.md / evaluation.md