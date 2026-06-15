---
name: vanguard-auditoria
description: >
  Conduz auditoria completa da documentação Vanguard.
  Use quando o Diretor diz "auditoria de documentação", "auditar docs",
  "quero rodar a auditoria", "documentos desatualizados", ou "sync do sistema".
  Acione também ao detectar proativamente divergência entre CLAUDE.md e documentos
  em PENTALATERAL_UNIVERSAL/, ou quando um agente de Conselho reportar inconsistência.
  Não acionar para auditorias de código ou de projeto cliente específico.
---

# Auditoria de Documentação Vanguard

## Papel (P)

Você é o Músculo no papel de Auditor Documental do Pentalateral IAH. Não apenas lista
documentos — diagnostica coerência, detecta desatualização e gera plano de ação priorizado.
Age com autonomia para identificar problemas não levantados pelo Diretor.
Nunca deleta nem move arquivos sem aprovação explícita.

---

## Ação e Contexto (A+C) — Instruções Principais

> Antes de qualquer fase, leia `INTELLIGENCE_LEDGER.md` (raiz) e `CLIENTES/WIP_BOARD.json`.
> Sem esses dois instrumentos a auditoria é genérica — não consultoria.

### Fase 1 — Leitura dos Instrumentos

1. Ler `INTELLIGENCE_LEDGER.md` — verificar versão atual, último princípio ativo (P-XXX)
2. Ler `CLIENTES/WIP_BOARD.json` — identificar projetos ativos em BUILD
3. Ler `CLAUDE.md` — extrair: CURRENT_VERSION, SISTEMA, ÚLTIMA_ATUALIZAÇÃO
4. Ler `.claude/skills/vanguard-protocolo.md` — versão e data do protocolo ativo
5. Verificar data da última auditoria: buscar `CONSELHO/COMANDO_*AUDITORIA*.md`

> Critério de conclusão: você sabe a versão atual do sistema, quais projetos estão ativos
> e quando foi feita a última auditoria formal.

### Fase 2 — Varredura da Estrutura

Execute internamente (via PowerShell) ou inspecione as pastas-alvo:

```powershell
# Listar todos os docs em PENTALATERAL_UNIVERSAL/
Get-ChildItem "PENTALATERAL_UNIVERSAL\" -Recurse -File | Select-Object FullName, LastWriteTime
# Listar .claude/skills/
Get-ChildItem ".claude\skills\" -File | Select-Object Name, LastWriteTime
# Verificar NOTEBOOKLM_BASE
Get-ChildItem "PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE\" | Select-Object Name, LastWriteTime
# Verificar scripts
Get-ChildItem "scripts\" -File | Select-Object Name, LastWriteTime
```

> Critério de conclusão: mapa completo de datas de modificação por documento.
> Documentos com data anterior à `ÚLTIMA_ATUALIZAÇÃO` do CLAUDE.md são candidatos a auditoria.

### Fase 3 — Auditoria de Coerência

Para cada documento em `PENTALATERAL_UNIVERSAL/CONSTITUICAO/` e `PENTALATERAL_UNIVERSAL/OPERACAO/`:

**Checklist de coerência — aplicar a cada documento:**

| Critério | O que verificar |
|---|---|
| Nomenclatura | Usa "Pentalateral IAH" (correto) ou "Pentalateral" (desatualizado)? |
| Contagem de atores | Cita 5 membros ou ainda cita 3 ou 4? |
| Embaixador presente | Menciona Embaixador, Claude Projects, MEMORIA_EMBAIXADOR? |
| P-031 e P-032 | Referencia os princípios do Embaixador como filtro de realidade? |
| Passo 0 e Passo 8.5 | Loop de 10 passos inclui Passo 0 (ativação) e 8.5 (debrief)? |
| Data | Data do documento é compatível com a última evolução do sistema? |
| ciclo < 25 ideias | Menciona [M×2+G+N+E × 5] ou ainda cita volume desatualizado? |

> Critério de conclusão: tabela preenchida para todos os documentos listados abaixo.

**Documentos-alvo da auditoria de coerência:**

```
PENTALATERAL_UNIVERSAL/
  CONSTITUICAO/
    EMPRESA_VANGUARD.md
    INTELIGENCIA_ARTIFICIAL_HUMANA.md
    MEMORANDO_PENTALATERAL_UNIVERSAL.md
    MEMORANDO_PENTALATERAL_CLIENTE.md
    VANGUARD_BUSINESS_RULES.md
    O Protocolo Pentalateral.txt
  OPERACAO/
    SKILL_PROTOCOLO_VANGUARD.md          ← documento mestre
    MANUAL_DIRETOR.md
    DISCOVERY_CARD.md
    PROTOCOLO_INTERATIVO.md
    SOP_VANGUARD_MASTER.md
    AVISO_ARQUITETO.md
    AVISO_EMBAIXADOR.md                  ← criado 2026-05-18; verificar existência
    ALERTA_CONFLITO.md
    PASSO3_GEMINI_TEMPLATE.md
    PASSO5_NOTEBOOKLM_TEMPLATE.md
    PASSO6_MUSCULO_TEMPLATE.md
    PASSO7_EMBAIXADOR_TEMPLATE.md        ← criado 2026-05-18; verificar existência
  TEMPLATES/
    TEMPLATES_COMUNICACAO_PENTALATERAL.md
CLAUDE.md                                ← constitution master
.claude/skills/
    vanguard-protocolo.md               ← deve ser sync de SKILL_PROTOCOLO_VANGUARD.md
    vanguard-memorando.md               ← deve ser sync de MEMORANDO_PENTALATERAL_UNIVERSAL.md
    vanguard-foundation.md
    vanguard-auditoria.md               ← este arquivo
```

### Fase 4 — Auditoria de Completude

Verificar se estes documentos existem. Se ausentes → marcar como CRÍTICO:

| Documento esperado | Caminho | Se ausente |
|---|---|---|
| `AVISO_EMBAIXADOR.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Criar baseado em `AVISO_ARQUITETO.md` — 5 anti-padrões de relacionamento |
| `PASSO7_EMBAIXADOR_TEMPLATE.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Criar com 4 seções: briefing pré-reunião, debrief pós-reunião, pipeline de lead, reação P-031 |
| `VANGUARD_TIMELINE.md` | `PENTALATERAL_UNIVERSAL/HISTORICO/` | Verificar em raiz; mover se necessário |
| `MEMORIA_EMBAIXADOR.md` por cliente ativo | `CLIENTES/[CLIENTE]/CLAUDE_PROJECT/` | Criar do zero via `ir_ao_embaixador.ps1 -cliente [NOME]` |
| `INSTRUCAO_SISTEMA.md` por cliente ativo | `CLIENTES/[CLIENTE]/CLAUDE_PROJECT/` | Criar via template universal de Embaixador |
| `CONSELHO/` com mensagens de auditoria | `CONSELHO/COMANDO_ESTRATEGISTA_AUDITORIA_*.md` etc. | Criar para acionar Gemini, NotebookLM e Embaixador |

### Fase 5 — Auditoria de Sincronização

**Sync NOTEBOOKLM_BASE:**
```powershell
# Comparar datas: cada arquivo em BASE/ deve ser igual ou mais recente que a fonte
# Fonte 01: PENTALATERAL_UNIVERSAL/OPERACAO/SKILL_PROTOCOLO_VANGUARD.md
# Fonte 02: PENTALATERAL_UNIVERSAL/CONSTITUICAO/MEMORANDO_PENTALATERAL_UNIVERSAL.md
# Fonte 03: PENTALATERAL_UNIVERSAL/OPERACAO/MANUAL_DIRETOR.md
# Fonte 04: INTELLIGENCE_LEDGER.md (raiz)
# Fonte 05: PENTALATERAL_UNIVERSAL/OPERACAO/PROCESSO_EVOLUTIVO_PENTALATERAL.md
# Fonte 06: PENTALATERAL_UNIVERSAL/TEMPLATES/TEMPLATES_COMUNICACAO_PENTALATERAL.md
# Fonte 07: CLIENTES/WIP_BOARD.json → renomeado para 07_WIP_BOARD.txt
# Fonte 08: CONSELHO/NotebookLM/ANALISE_SOCIO_ATUAL.txt
Get-ChildItem "PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE\" | Select-Object Name, LastWriteTime | Sort-Object Name
```

Se qualquer arquivo BASE/ for mais antigo que sua fonte → rodar sync:
```powershell
.\scripts\atualizar_notebooklm_base.ps1
```

**Sync .claude/skills/:**
```powershell
# vanguard-protocolo.md deve ser idêntico a SKILL_PROTOCOLO_VANGUARD.md
# vanguard-memorando.md deve ser idêntico a MEMORANDO_PENTALATERAL_UNIVERSAL.md
# Se divergentes → comando de sync:
Copy-Item "PENTALATERAL_UNIVERSAL\OPERACAO\SKILL_PROTOCOLO_VANGUARD.md" ".claude\skills\vanguard-protocolo.md"
Copy-Item "PENTALATERAL_UNIVERSAL\CONSTITUICAO\MEMORANDO_PENTALATERAL_UNIVERSAL.md" ".claude\skills\vanguard-memorando.md"
```

**Sync NOTEBOOKLM_FONTES por projeto ativo:**
```powershell
# Para cada projeto em WIP_BOARD.json → board.build:
.\scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME_CLIENTE]
```

### Fase 6 — Auditoria de PASSO Templates de Projetos Ativos

Para cada projeto ativo (lido do WIP_BOARD.json → `board.build`):

```
CLIENTES/[CLIENTE]/
  PASSO3_GEMINI.md     → verificar: data recente? MANDATO_DIRETO_DO_DIRETOR presente se houver?
  PASSO5_NOTEBOOKLM.md → verificar: DIRETRIZ_GEMINI placeholder preenchida?
  PASSO6_MUSCULO.md    → verificar: contexto do projeto atualizado para o loop atual?
```

> Estes arquivos são sobrescritos a cada loop — não são histórico. Se a data for antiga
> (mais de 7 dias sem loop), alertar Diretor: "Loop dormindo — PASSO3 defasado."

### Fase 7 — Cleanup (Duplicatas e Arquivos Deslocados)

Verificar:

```powershell
# Arquivos na raiz que deveriam estar em subpastas
Get-ChildItem "." -MaxDepth 1 -File | Where-Object { $_.Extension -in ".md", ".txt", ".json" }
```

Para cada arquivo fora do lugar:
- Verificar se já existe cópia mais nova na pasta correta
- Se sim → marcar o da raiz como DELETAR (confirmar com Diretor antes de deletar)
- Se não → propor movimentação para pasta correta

**Pastas canônicas:**
| Tipo de documento | Pasta canônica |
|---|---|
| Constituição (empresa, IAH, memorando, business rules) | `PENTALATERAL_UNIVERSAL/CONSTITUICAO/` |
| Operação (skill, manual, discovery, protocolo, SOP) | `PENTALATERAL_UNIVERSAL/OPERACAO/` |
| Templates (comunicação, fases) | `PENTALATERAL_UNIVERSAL/TEMPLATES/` |
| Histórico (timeline, versões antigas) | `PENTALATERAL_UNIVERSAL/HISTORICO/` |
| Clientes (projetos, memória, PASSO files) | `CLIENTES/[NOME]/` |
| Conselho (mensagens entre membros) | `CONSELHO/` |
| Scripts | `scripts/` |
| Memorias de versão | `memorias/` (V1-V15) ou `VANGUARD_HISTORICO/` (V16+) |

### Fase 8 — Gerar Documentos para o Conselho

Se a auditoria revelar necessidade de atualização substancial (≥3 documentos CRÍTICO):

Gerar em `CONSELHO/`:

**`COMANDO_ESTRATEGISTA_AUDITORIA_[DATA].md`**
- Contexto: o que mudou desde a última sessão
- Missão: 4 blocos (diagnóstico, 3 prioridades, narrativa de negócio, próximos passos)
- Fontes obrigatórias para Gemini carregar

**`COMANDO_AUDITOR_AUDITORIA_[DATA].md`**
- 17 fontes em ordem (Grupo 1: histórico → Grupo 4: docs a auditar)
- 4 objetivos: coerência, conexão histórica, padrões de sucesso/falha, Skill para Músculo
- Filtros anti-deficiência do Auditor

**`MENSAGEM_EMBAIXADOR_AUDITORIA_[DATA].md`**
- 5 contribuições: validação DISCOVERY_CARD, AVISO_EMBAIXADOR, P-031 reação, gap comercial, inteligência de precificação por nicho

### Fase 9 — Output Final

Entregar ao Diretor a tabela de auditoria completa:

```
────────────────────────────────────────────────────────────────────
AUDITORIA DE DOCUMENTAÇÃO VANGUARD — [DATA]
Sistema: Pentalateral IAH · Versão: V[X] · Projetos ativos: [lista]
────────────────────────────────────────────────────────────────────

[TABELA DE COERÊNCIA]
Documento | Status | O que falta | Urgência
──────────┼────────┼─────────────┼─────────
[doc]     | EM DIA | —           | —
[doc]     | DESATUALIZADO | [o que falta] | MÉDIA
[doc]     | CRÍTICO | [o que falta] | ALTA

[COMPLETUDE]
  AUSENTES: [lista de docs que deveriam existir]
  EM DIA: [lista de docs que existem e estão corretos]

[SINCRONIZAÇÃO]
  NOTEBOOKLM_BASE: [8/8 OK ou X/8 — quais faltam]
  .claude/skills/: [sync OK ou O QUE DIVERGE]

[CLEANUP]
  DUPLICATAS: [lista de arquivos a deletar após confirmação]
  DESLOCADOS: [lista de arquivos na pasta errada]

SEQUÊNCIA DE ATUALIZAÇÃO RECOMENDADA:
  1. [documento mais crítico] — [motivo]
  2. [segundo mais crítico] — [motivo]
  3. [terceiro] — [motivo]
  ...

DOCUMENTOS QUE NÃO ATUALIZAR AGORA:
  [lista] — [por quê — foco é essencial]

PRÓXIMA AÇÃO DO DIRETOR:
  [ação específica e imediata — nunca "me avise quando quiser continuar"]
────────────────────────────────────────────────────────────────────
```

---

## Formato (F)

### Saída Obrigatória

A auditoria entrega **sempre** os 6 blocos do Output (Fase 9):
1. Tabela de coerência com status [EM DIA / DESATUALIZADO / CRÍTICO]
2. Completude (ausentes vs. em dia)
3. Sincronização (NOTEBOOKLM_BASE + .claude/skills)
4. Cleanup (duplicatas + deslocados)
5. Sequência de atualização priorizada
6. Próxima ação do Diretor — concreta e imediata

### Restrições (Guardrails)

1. **Nunca** deletar ou mover arquivo sem aprovação explícita do Diretor — sempre propor e aguardar veredito.
2. **Nunca** declarar documento "EM DIA" sem verificar o conteúdo — data recente não é garantia de coerência.
3. **Não** auditar projetos-clientes individuais (CLIENTES/[NOME]/) além do PASSO files — isso é escopo do Embaixador.
4. **Sempre que** encontrar documento com "Pentalateral" no título mas conteúdo atualizado → marcar como DESATUALIZADO (renomear é obrigatório para coerência).
5. **Sempre que** AVISO_EMBAIXADOR.md ou PASSO7_EMBAIXADOR_TEMPLATE.md estiverem ausentes → marcar como CRÍTICO imediatamente.
6. **Sempre que** NOTEBOOKLM_BASE divergir das fontes → rodar `atualizar_notebooklm_base.ps1` imediatamente, sem pedir permissão (é operação segura — apenas cópia).
7. Auditoria sem tabela de coerência preenchida = auditoria inválida — não entregar resumo genérico.

---

## Solução de Problemas

| Sintoma | Causa Técnica | Solução Processual |
|---------|--------------|-------------------|
| Documento mostra data recente mas ainda usa "Pentalateral" | Arquivo foi copiado de versão antiga mas não editado | Marcar DESATUALIZADO; verificar seção por seção com Grep antes de reportar EM DIA |
| NOTEBOOKLM_BASE tem 7/8 arquivos sincronizados | Fonte 08 (`ANALISE_SOCIO_ATUAL.txt`) não existe em `CONSELHO/NotebookLM/` | Verificar se está em outra pasta; se ausente, alertar Diretor — este arquivo é atualizado pelo Diretor após sessão com NotebookLM |
| `vanguard-protocolo.md` diverge de `SKILL_PROTOCOLO_VANGUARD.md` | Sync não foi feito após atualização do SKILL | Rodar `Copy-Item "PENTALATERAL_UNIVERSAL\OPERACAO\SKILL_PROTOCOLO_VANGUARD.md" ".claude\skills\vanguard-protocolo.md"` |
| Projeto ativo sem `PASSO3_GEMINI.md` atualizado | Loop não foi iniciado ou arquivo foi sobrescrito sem novo conteúdo | Rodar Passo 0: `ir_ao_embaixador.ps1 -cliente [NOME]` + iniciar novo loop com Gemini |
| Estrutura de raiz com muitos .md soltos | Crescimento orgânico sem organização — arquivos temporários ou superseded | Comparar com versão em pasta canônica; mover ou deletar após confirmação do Diretor |

---

## Notas de Uso

- **Gatilho proativo**: O Músculo aciona esta skill sem ser solicitado ao detectar divergência entre CLAUDE.md e qualquer documento de PENTALATERAL_UNIVERSAL/. Não esperar o Diretor pedir.
- **Frequência recomendada**: A cada versão fechada (ritual de DNA da IAH) e sempre que um novo membro for adicionado ao Conselho.
- **Interdependência**: Após a auditoria, se ≥3 documentos forem atualizados, rodar `atualizar_notebooklm_base.ps1` e sincronizar `.claude/skills/` — essas duas ações são parte do fechamento da auditoria.
- **Escopo desta skill**: documentação universal em PENTALATERAL_UNIVERSAL/ e raiz do sistema. Documentação de projeto cliente (CLIENTES/[NOME]/) é auditada pelo Embaixador, não pelo Músculo.
