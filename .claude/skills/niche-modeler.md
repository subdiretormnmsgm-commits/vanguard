---
name: niche-modeler
description: Processo completo de Cowork Nicho de Mercado -- invocacao gemini-pentalateral, acesso remoto, processamento da resposta, consolidacao e sintese
triggers:
  - "NICHE_MODELER"
  - "Cowork Nicho de Mercado"
  - "gemini-pentalateral"
  - "atualizar nichos"
  - "modelagem de nicho"
  - "NICHE_INDEX"
  - "ir ao Gemini para nicho"
---

# SKILL -- NICHE_MODELER

## QUANDO INVOCAR
Qualquer momento em que o Diretor mencionar NICHE_MODELER, Cowork Nicho de Mercado,
gemini-pentalateral, atualizacao de NICHE_INDEX ou modelagem de nichos.

O Musculo invoca esta skill ANTES de qualquer resposta ou acao sobre a atividade.

## FONTE DE VERDADE
```
PENTALATERAL_UNIVERSAL/OPERACAO/RUNBOOK_NICHE_MODELER.md
```
Ler o RUNBOOK completo antes de iniciar qualquer fase.

## FASES RESUMIDAS (referencia rapida)

| Fase | O que fazer | Artefato de saida |
|------|-------------|-------------------|
| 1 - Cowork Setup | gemini_anchor_generator.ps1 + escrever PASSO3 no disco | PASSO3_GEMINI.md |
| 2 - Skill invocacao | Invocar gemini-pentalateral skill | Browser aberto |
| 3 - Acesso remoto | Playwright: navegar + colar + aguardar resposta | Snapshot completo |
| 4 - Resposta Gemini | PENDING_REVIEW -> MODEL JSONs + NICHE_INDEX | NICHE_INDEX.json atualizado |
| 5 - Consolidacao | NotebookLM Skill + Embaixador CONFIRMA/EXPANDE/ALERTA | Skill instalada |
| 6 - Sintese | P-037: 7 pontos por ideia + DELIBERACAO_LOOP | ESTRATEGIA_CANAIS ou equivalente |
| 7 - Fechamento | MEMORIA_V[N] + relatorio_V[N] + P-033 sync + commit | P-045 satisfeito |

## GATES INVIOAVEIS

- P-090: PASSO3 e escrito no arquivo, nao no chat
- P-124: Gemini Advanced = motor diferente -> output vai para PENDING_REVIEW primeiro
- P-037: 7 pontos por ideia antes de qualquer plano consolidado
- P-045: MEMORIA + relatorio antes de fechar o loop
- P-033: sync apos qualquer mudanca em PENTALATERAL_UNIVERSAL/

## VERIFICACAO DE INICIO

Antes de avancar para Fase 2, checar:
- [ ] Loop anterior tem MEMORIA + RELATORIO em disco?
- [ ] NICHE_INDEX.json existe e tem _meta.versao atual?
- [ ] PASSO3_GEMINI.md foi gravado com Write tool (nao so no chat)?
- [ ] Churn watch de clientes ativos verificado?

## REFERENCIA CRUZADA
- PENTALATERAL_UNIVERSAL/OPERACAO/RUNBOOK_NICHE_MODELER.md -- processo completo
- CLIENTES/[CLIENTE]/ESTRATEGIA_CANAIS_[CLIENTE].md -- saida estrategica
- PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_INDEX.json -- indice de nichos
- .claude/skills/gemini-pentalateral.md -- skill de acesso ao Gemini via browser