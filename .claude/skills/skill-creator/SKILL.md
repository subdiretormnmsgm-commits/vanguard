---
name: skill-creator
description: Use when creating a new skill file for a client, process, or reusable behavior. Generates SKILL.md with 4 mandatory blocks, validated by skill_parser_gate.ps1.
---

# Skill Creator

## Quando usar

- Onboarding de novo cliente (skill inicial)
- Padrao novo reutilizavel entre sessoes
- NotebookLM entregou skill que precisa ser formatada
- Gemini nomeou skill no PASSO3 e ela precisa ser criada

## Estrutura Obrigatoria -- 4 Blocos (skill_parser_gate.ps1)

```markdown
---
name: [nome-kebab-case]
description: "[1 frase -- quando e por que invocar]"
---

# [NOME] . v[N] . [PROJETO]

## [PARTE 1] IDENTIDADE
Quem e, papel no Pentalateral IAH, escopo.

## [PARTE 2] PROTOCOLOS OPERACIONAIS
Regras de comportamento, alertas DEF-*, gates bloqueantes.

## [PARTE 3] CAPACIDADES TECNICAS
O que sabe fazer, integracoes, scripts associados, limitacoes.

## [PARTE 4] HISTORICO E CONTEXTO
Loops anteriores, hipoteses, temperatura do cliente, proxima acao.
```

## Processo

1. Coletar: nome, descricao, projeto/cliente
2. Preencher os 4 blocos (sem placeholder)
3. Salvar em .claude/skills/[nome].md
4. Validar: scripts/skill_parser_gate.ps1 -skill ".claude/skills/[nome].md"
5. APROVADO -> commitar: feat(skill): criar [nome]
6. REJEITADO -> corrigir e re-validar

## Nomenclatura

- Cliente: [cliente]-v[N].md (ex: ingrid-v8.md)
- Universal: vanguard-v[N].md (ex: vanguard-v33.md)
- Processo: [processo]-v[N].md (ex: n8n-orquestracao-v1.md)
- Generica: [nome-kebab].md (ex: mcp-builder.md)

## Gate Final

Skill nao commitada sem validacao. Skill REJEITADA = skill inexistente para o sistema.