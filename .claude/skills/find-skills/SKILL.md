---
name: find-skills
description: Meta-skill -- descobrir qual skill usar para a tarefa atual. Usar quando Musculo nao tem certeza qual skill aplicar ou Diretor pergunta "existe skill para X?".
---

# Find Skills

## Quando usar

- Inicio de projeto novo (descoberta da stack)
- Antes de tarefa sem skill obvia
- Diretor pergunta "voce tem skill para X?"
- Garantir que nenhuma skill relevante esta sendo esquecida

## Processo

1. Ler contexto da tarefa
2. ls .claude/skills/ + ls .agents/skills/
3. Verificar descricao de cada skill candidata
4. Retornar top 3 com justificativa

## Mapa por Situacao

| Situacao | Skills |
|---|---|
| Bug tecnico | systematic-debugging + ultrathink-trigger |
| Nova feature | brainstorming -> writing-plans -> executing-plans |
| Entrega cliente | webapp-testing + verification-before-completion |
| MCP / integracao API | mcp-builder |
| Scrape JS dinamico | firecrawl |
| Design de tela | frontend-design + vanguard-design-elite |
| Analise de mercado | intel-loop (.agents/skills/) |
| Deliberacao socios (P-037) | ultrathink-trigger + brainstorming -> writing-plans |
| Encoding / BOM | json-bom-guard |
| Deriva de documentos | doc-drift-audit |
| Skill nova para cliente | skill-creator |

## Skills Priority por Fase do Loop Pentalateral

| Fase | Skills |
|---|---|
| Abertura (BLOCO 0) | cowork-engine-v1, notebooklm |
| Build tecnico | brainstorming -> mcp-builder / executing-plans |
| Deliberacao final (P-037) | ultrathink-trigger + brainstorming -> writing-plans |
| QA pre-entrega | webapp-testing + verification-before-completion |
| Fechamento | vanguard-v33 |

## Regra

Se nao tiver certeza qual skill usar: invocar find-skills PRIMEIRO. Evita usar skill errada (historico: mcp-builder + notebooklm invocadas errado em 2026-06-10).