# SKILLS_GATILHOS — Mapa Operacional de Invocacao
> Gerado 2026-06-12 — S-4 revisado + S-3 + instalacao completa
> Para CADA skill: quando invocar, como invocar, o que NÃO fazer.

---

## REGRA MESTRE

Se nao tiver certeza qual skill usar: `/find-skills` PRIMEIRO.
Se a tarefa parece complexa: `/ultrathink-trigger` calcula o score — se >= 5, prefixar analise com "ultrathink:".

---

## TABELA DE GATILHOS

| Skill | Gatilho automatico | Como invocar | NAO invocar quando |
|---|---|---|---|
| `ultrathink-trigger` | Score complexidade >= 5; P-037 synthesis; 2+ failed fixes; decisao de arquitetura | Read + aplicar framework manualmente | Tarefas simples e bem entendidas |
| `brainstorming` | Inicio de toda feature nova; Deliberacao P-037 ao receber SECAO D | `Skill("brainstorming")` | APOS o veredito (usa writing-plans) |
| `writing-plans` | SOMENTE apos veredito do Diretor ("D1:A D2:B...") | `Skill("writing-plans")` | ANTES do veredito; NUNCA sem brainstorming primeiro |
| `executing-plans` | Tem plano escrito e aprovado; tasks bite-sized prontas | `Skill("executing-plans")` | Sem plano aprovado |
| `systematic-debugging` | Qualquer bug, test failure, comportamento inesperado | `Skill("systematic-debugging")` | Propor fix SEM investigar root cause |
| `verification-before-completion` | Antes de qualquer "concluido", "funciona", "passou" | `Skill("verification-before-completion")` | — sempre aplicar antes de afirmacao |
| `firecrawl` | URL que WebFetch retornou incompleto; PNCP; portais gov | `Skill("firecrawl")` | Sites estaticos (WebFetch e mais rapido) |
| `webapp-testing` | Antes de commit de entrega de feature cliente | `Skill("webapp-testing")` | Em codigo interno/scripts |
| `frontend-design` | Antes de qualquer nova tela, pagina, componente UI | `Skill("frontend-design")` | Para scripts, CLI, APIs |
| `mcp-builder` | "Criar MCP para X", nova tool para Hermes/Musculo | `Skill("mcp-builder")` | Para integracoes via n8n (usa n8n-orquestracao) |
| `find-skills` | Duvida sobre qual skill usar | `Skill("find-skills")` | Quando a skill e obvia |
| `skill-creator` | Onboarding novo cliente; skill nomeada pelo Gemini | `Skill("skill-creator")` | — rodar sempre ao criar skill nova |
| `cowork-engine-v1` | Abertura de sessao (PASSO 0 bloqueante) | `Skill("cowork-engine-v1")` | Durante sessao ativa |
| `vanguard-design-elite` | Build de UI com design system CYBER-PREMIUM | `Skill("vanguard-design-elite")` | Se cliente tem branding proprio |
| `notebooklm` | Interacao com Auditor via Playwright | `Skill("notebooklm")` | Fora do loop Pentalateral |
| `n8n-orquestracao-v1` | Build/debug de workflows n8n | `Skill("n8n-orquestracao-v1")` | Para MCPs (usa mcp-builder) |
| `doc-drift-audit` | Auditoria semantica de deriva documental | `Skill("doc-drift-audit")` | Auditorias tecnicas de codigo |
| `json-bom-guard` | Edicao de qualquer .json critico (WIP_BOARD, LOOP_STATE) | `Skill("json-bom-guard")` | Para arquivos .txt / .md |

---

## SEQUENCIAS COMPOSTAS

### Deliberacao Fim de Loop (P-037) — SEQUENCIA INVIOLAVEL
```
[Receber SECAO D do Embaixador]
    |
    v
1. ultrathink-trigger  -- Read + calcular score -> SEMPRE >= 5 -> "ultrathink:"
    |
    v
2. Skill("brainstorming")  -- 7 pontos por ideia -> DELIBERACAO_LOOP.md -> aguardar veredito
    |
    v
3. [Diretor veredito: D1:A D2:B...]
    |
    v
4. PASSO7.5 -> update_memoria_embaixador.ps1
    |
    v
5. Skill("writing-plans")  -- plano bite-sized -> PENDENTES.md com [RESOLVE:] tags
```

### Build de Feature Nova
```
1. Skill("brainstorming")  -- design antes de codigo
2. Skill("writing-plans")  -- plano apos aprovacao
3. Skill("executing-plans") -- execucao com checkpoints
4. Skill("webapp-testing")  -- QA antes de commit
5. Skill("verification-before-completion") -- confirmar evidencia
```

### Bug Tecnico
```
1. Skill("systematic-debugging")  -- root cause PRIMEIRO
2. ultrathink-trigger  -- se 2+ failed fixes ou arquitetura
3. Skill("verification-before-completion") -- antes de "corrigido"
```

### Build MCP / Integracao
```
1. Skill("brainstorming")  -- design da API/tool
2. Skill("mcp-builder")    -- implementacao guiada
3. Skill("writing-plans")  -- plano de build
4. Skill("verification-before-completion") -- MCP Inspector test
```

### Onboarding Novo Cliente
```
1. Skill("skill-creator")    -- criar [cliente]-v1.md
2. scripts/skill_parser_gate.ps1  -- validar 4 blocos
3. Skill("brainstorming")    -- primeiro loop com cliente
```

---

## SKILLS NAO USAR NO P-037

**NUNCA invocar ao analisar SECAO D do Embaixador:**
- `mcp-builder` -- para construcao de MCP, nao deliberacao
- `notebooklm` -- para interagir com Auditor, nao deliberar loop
- `cowork-engine-v1` -- para abertura de sessao, nao fim de loop

Erro documentado: 2026-06-10 — Musculo invocou mcp-builder + notebooklm errado — Diretor sentiu-se enganado.

---

## VERIFICAR GATE ANTES DO DECISOES.JSON

```powershell
# Antes de gerar DECISOES.json, sempre rodar:
.\scripts\check_skills_embaixador.ps1 -Cliente VANGUARD -Verificar
# exit 0 = VERDE (pode gerar DECISOES.json)
# exit 1 = VERMELHO (DELIBERACAO_LOOP ausente -- bloqueante)
# exit 2 = AMARELO (DELIBERACAO_LOOP existe mas sem evidencia de skills)
```