---
name: brainstorming
description: "MUST use before any creative work. Explores intent, requirements and design before implementation. HARD-GATE: no code until design approved."
---

# Brainstorming Ideas Into Designs

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, or take any implementation action
until you have presented a design and the user has approved it.
</HARD-GATE>

## Checklist (em ordem)

1. Explore project context -- arquivos, docs, commits recentes
2. Perguntas clarificadoras -- uma por vez
3. Propor 2-3 abordagens com trade-offs e recomendacao
4. Apresentar design -- secao por secao, aprovacao apos cada uma
5. Escrever spec doc e commitar
6. Invocar writing-plans skill

## Pentalateral Adaptation -- Deliberacao P-037

Quando invocado para deliberacao de loop (analisando M/G/N/E dos socios):
- "Explore context" = ler as 25 ideias completas (M/G/N/E)
- "2-3 approaches" = para CADA ideia: 7 pontos (certo->diverge->decisao->enhancement->custo->impacto->acao)
- "Design doc" = CLIENTES/[CLIENTE]/HISTORICO/DELIBERACAO_LOOP_V[N]_[CLIENTE].md
- "User approval" = Diretor da veredito: "D1:A D2:B D3:A..."
- HARD-GATE = NENHUM DECISOES.json antes do veredito do Diretor

**Estado terminal: invocar writing-plans. Nunca outra skill.**

## Principios

- Uma pergunta por vez
- YAGNI -- remover features desnecessarias
- Sempre 2-3 abordagens antes de decidir

## Apos o Design

- Generico: docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md
- Pentalateral: CLIENTES/[CLIENTE]/HISTORICO/DELIBERACAO_LOOP_V[N]_[CLIENTE].md
- Proximo passo SEMPRE: writing-plans. Nunca outra skill.