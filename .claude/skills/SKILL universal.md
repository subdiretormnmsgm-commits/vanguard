---
name: [kebab-case, ≤4 palavras, sem palavras reservadas]
description: >
  [Verbo de ação] + [objeto] + [contexto].
  Use quando o usuário [gatilho 1], "[gatilho 2 entre aspas]",
  "[gatilho 3]", ou [gatilho 4 — forma indireta].
  Acione também quando [gatilho 5 — contexto implícito].
  Não acione para [falso positivo 1] ou [falso positivo 2].
---

# [Nome da Skill em Title Case]

## Papel (P)

[Persona em 2–3 linhas: especialidade, postura, nível de autonomia, tom.]

---

## Ação e Contexto (A+C) — Instruções Principais

> Leia `references/domain-research.md` antes de iniciar qualquer execução desta skill.

### Fase 1 — [Nome da Fase]

1. [Passo com critério de conclusão claro]
2. [Passo com critério de conclusão claro]
   > Leia `references/[arquivo].md` para [motivo específico].
3. [Passo com critério de conclusão claro]

### Fase 2 — [Nome da Fase]

1. [Passo]
2. [Passo]

### Fase 3 — [Nome da Fase]

1. [Passo]
2. [Passo]

---

## Formato (F)

### Template de Saída

[Descrever ou exemplificar o formato exato da resposta — blocos de código, seções, tabelas, etc.]

> Para saídas complexas, leia `templates/output-template.md`.

### Restrições (Guardrails)

1. **Nunca** [ação proibida — específica e verificável].
2. **Nunca** [ação proibida — específica e verificável].
3. **Não** [ação proibida com condição].
4. **Sempre que** [condição], [ação obrigatória].
5. **Sempre que** [condição], [ação obrigatória].
6. [Guardrail estrutural: SKILL.md gerado ≤500 linhas]
7. [Guardrail estrutural: nenhuma solução delega ao usuário]

---

## Solução de Problemas

| Sintoma | Causa Técnica | Solução Processual |
|---------|--------------|-------------------|
| [erro observável 1] | [causa raiz 1] | [ação exata — sem "tente" ou "verifique"] |
| [erro observável 2] | [causa raiz 2] | [ação exata] |
| [erro observável 3] | [causa raiz 3] | [ação exata] |
| [erro observável 4] | [causa raiz 4] | [ação exata] |

---

## Notas de Uso

- [Nota de instalação ou dependência, se aplicável]
- [Nota de integração com outras skills, se aplicável]