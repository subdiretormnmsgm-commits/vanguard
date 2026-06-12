---
name: doc-drift-audit
description: Detecta deriva entre arquivos canônicos UNIVERSAL_PURO e suas cópias nos CLIENTES/
---

# SKILL: Auditoria de Deriva Documental (Doc Drift)

## [FUNÇÃO]
Esta skill varre sistematicamente o repositório Pentalateral para detectar inconsistências, defasagens e referências quebradas entre os arquivos canônicos (base) em `PENTALATERAL_UNIVERSAL/` e as suas respectivas instâncias em `CLIENTES/*/`. A função é exclusivamente de **leitura e auditoria**.

## [LISTA DE RASTREADOS]
A auditoria deve monitorar a propagação e a integridade de:
- Todos os arquivos sob `PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/`
- `DEPENDENCY_MAP.json`
- `INTELLIGENCE_LEDGER.md`
- `AGENTS.md`
- Scripts de orquestração universais em `PENTALATERAL_UNIVERSAL/scripts/`
- Arquivos de regras em `.agents/rules/`
- Diretórios de clientes: `CLIENTES/VANGUARD/`, `CLIENTES/INGRID/`, `CLIENTES/VALDECE/`, `CLIENTES/MUMUZINHO/` (com acesso estritamente read-only para checagem de paridade).

## [TIPOS DE DERIVA]

Ao executar a varredura, o agente deve identificar obrigatoriamente três tipos de desvios:

**TIPO A — Deriva temporal**
- Arquivo "LATEST" contendo conteúdo ou *timestamp* de uma versão antiga.
- Manifesto (ex: PASSO3_GEMINI) apontando para um loop defasado em relação ao diretório corrente.
- Documento marcado como [IDENTIDADE] com data de última modificação superior a 30 dias (exigindo revalidação).

**TIPO B — Referência fantasma**
- Citação de um Princípio (ex: P-059, P-124) em qualquer documento sem que este princípio esteja devidamente listado e definido no `INTELLIGENCE_LEDGER.md`.
- Referência a um Loop (ex: V-32) que não possui registro na `TIMELINE`.
- Arquivos referenciados diretamente por *filepath* (ex: @caminho/do/arquivo) que não existem mais em disco.

**TIPO C — Drift de propagação**
- Arquivo classificado como `UNIVERSAL_PURO` foi atualizado no HUB, mas a sua cópia no diretório de algum cliente (`CLIENTES/*/`) permanece com a versão antiga.
- Schemas JSON atualizados, mas instâncias locais ainda usando a estrutura obsoleta.
- Skills atualizadas, mas a pasta `.claude/skills/` contendo arquivos defasados.

## [SAÍDA ESPERADA]
O resultado final da skill deve ser **sempre** uma tabela formatada em Markdown, salva no PENDING_REVIEW, contendo a lista completa de anomalias encontradas:

| Arquivo / Caminho | Data Local | Tipo de Deriva (A/B/C) | Ação Proposta (Correção) |
| :--- | :--- | :--- | :--- |
| `CLIENTES/INGRID/PASSO3...` | 2026-05-10 | TIPO A | Atualizar cabeçalho para Loop 33 |
| `PENTALATERAL_UNIVERSAL/...` | 2026-06-01 | TIPO B | Remover citação ao P-999 (inexistente) |
| `CLIENTES/VALDECE/skill.md` | 2026-05-20 | TIPO C | Re-sync a partir de UNIVERSAL_PURO |

## [GUARDRAILS]
1. **LEITURA ESTRITA:** Esta skill **NUNCA** modifica, deleta ou propõe diffs de aplicação automática nos arquivos. O escopo é apenas de **REPORT**.
2. **ISOLAMENTO R-01:** Nenhuma proposta gerada por esta skill pode encorajar ou instruir qualquer agente a sobrescrever os arquivos listados no `pentalateral-firewall.md` (R-01) sem ordem explícita do Diretor.
3. **PONTO DE SAÍDA ÚNICO:** O relatório da auditoria deve ser enviado única e exclusivamente para `PENDING_REVIEW.md`. Nenhuma gravação direta no `INTELLIGENCE_LEDGER` ou `WIP_BOARD` é permitida.
4. **LIMITE DE ALERTA:** Se a varredura detectar mais de 30 arquivos com deriva, a skill deve abortar a formatação da tabela completa e emitir um **Alerta de Risco P-147** ao Diretor, informando o volume massivo de inconsistências.
