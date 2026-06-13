---
name: writing-plans
description: Use when you have a spec for a multi-step task. SOMENTE APOS veredito do Diretor. Bite-sized tasks, exact files, real code, no placeholders.
---

# Writing Plans

**Announce at start:** "I am using the writing-plans skill to create the implementation plan."

**Save to:** docs/superpowers/plans/YYYY-MM-DD-<feature>.md
- Pentalateral: populate PENDENTES.md com [musculo] tasks + [RESOLVE:] tags

## Pentalateral Adaptation -- Pos-Veredito

Apos Diretor dar veredito ("D1:A D2:B..."):
1. Para cada decisao APROVADA -- criar task bite-sized
2. Cada task: arquivo exato + o que mudar + [RESOLVE: keyword]
3. Sequencia de commits com mensagens prontas
4. Nenhum placeholder ("TBD", "TODO")

**Nao invocar antes do veredito -- brainstorming HARD-GATE libera primeiro.**

## Bite-Sized Task Granularity

Cada step = uma acao (2-5 minutos):
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement minimal code" - step
- "Commit with [RESOLVE: keyword]" - step

## Plan Header (obrigatorio)

```markdown
# [Feature Name] Implementation Plan
**Goal:** [Uma frase]
**Architecture:** [2-3 frases]
**Tech Stack:** [Tecnologias-chave]
---
```

## No Placeholders

Nunca: "TBD", "TODO", "implement later", "similar to Task N", steps sem codigo exato.

## Self-Review

1. Coverage: task para cada requisito?
2. Placeholder scan: fix inline
3. Type consistency: nomes de metodos batem entre tasks?

## Execution Handoff

Opcao 1: Subagent-Driven (recomendado)
Opcao 2: Inline -- executing-plans skill nesta sessao