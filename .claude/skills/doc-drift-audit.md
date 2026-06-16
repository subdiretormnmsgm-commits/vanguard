---
name: doc-drift-audit
description: Auditoria de deriva documental — detecta documentos canônicos desatualizados em relação ao estado atual do loop. Skill operacional do DETECTOR DE DERIVA (ator coadjuvante do Conselho). Usar ao iniciar sessão ou ao suspeitar de deriva.
version: "1.1"
created: "2026-06-11"
updated: "2026-06-15"
---

# DOC DRIFT AUDIT — PENTALATERAL IAH

> Skill operacional do **DETECTOR DE DERIVA** — ator coadjuvante formalizado no Loop 34 (2026-06-15).
> Ativada quando há suspeita de deriva entre documentos e realidade do sistema.
> Complementa doc_freshness_checker.ps1 (Gate 0.5) com análise semântica.

---

## IDENTIDADE — DETECTOR DE DERIVA (coadjuvante · Loop 34)

O Detector de Deriva não é um arquivista. É o sistema imunológico documental do Pentalateral.
Três princípios fundadores (amplificações M'X do Loop 34):

- **[M'X-1] DERIVA PREDITIVA, NÃO FORENSE** — não espera o documento virar 🎯 DERIVA; sinaliza o
  🔄 REPETIDO prestes a virar deriva. Antecipa, não faz autópsia. O alerta nasce ANTES do dano.
- **[M'X-2] DRIFT INDEX** — cada varredura emite um índice de deriva (0–100) por cluster de
  documentos. O Diretor vê a saúde documental do sistema em UM número, não num relatório longo.
- **[M'X-3] PRIMEIRO ALVO SÃO OS 3 ATORES NOVOS** — audita primeiro os próprios atores recém-criados
  (Projetista, Embaixador Digital): a coerência entre o que o template (CLAUDE_PROJECT_INSTRUCAO)
  PROMETE e o que o ator PRODUZ. Atores novos são a maior fonte de deriva potencial.

> ⚠️ FRONTEIRA EM ABERTO (DIRETRIZ V34): se o Detector é ator à parte ou função do Auditor — e o
> risco de virar burocracia que trava o sistema — é decisão da síntese P-037. Esta skill é operacional
> e neutra a essa decisão: roda igual em qualquer das duas formas.

> **1 DETECTOR / 2 MODOS (Loop 35):** existe UM só Detector de Deriva. Ele opera em dois MODOS conforme
> o ambiente: **(A) obsidian-cli** quando o vault Obsidian está aberto (segue wikilinks/backlinks) e
> **(B) Claude Code/grep** como fallback quando fechado. Mesma régua (`./INTELLIGENCE_LEDGER.md` na RAIZ,
> P-171), mesmo destino único (`INTELLIGENCE_HUB/PENDING_REVIEW.md`, append, P-124). O persona completo
> está em `CONSELHO/SYSTEM_PROMPT_DETECTOR_DERIVA.md` (v1.3); esta skill é a camada operacional.

---

## QUANDO USAR

- Ao iniciar sessão com BLOCO 0 do Embaixador mencionando deriva
- Quando session_start reportar AMARELO em doc_freshness_checker
- Quando o Diretor mencionar que um documento "parece desatualizado"
- A cada 3 loops (CHECK-UP SISTÊMICO)
- **Sempre que um ator novo produzir seu primeiro output** (M'X-3 — verificar template vs. produção)

---

## PROTOCOLO DE AUDITORIA

### 1. INVENTÁRIO DOS DOCUMENTOS RASTREADOS

> Ordem de varredura segue M'X-3: atores novos PRIMEIRO.

| Prioridade | Arquivo | Critério de Deriva |
|---|---|---|
| ATOR-NOVO | PENTALATERAL_UNIVERSAL/CLAUDE_PROJECTS/TEMPLATE_INSTRUCAO_PROJETISTA.md | Template promete o que a produção do Projetista não entrega |
| ATOR-NOVO | PENTALATERAL_UNIVERSAL/CLAUDE_PROJECTS/TEMPLATE_INSTRUCAO_EMBAIXADOR_DIGITAL.md | Template promete o que a produção do Embaixador Digital não entrega; linguagem externa viola R-3 |
| ATOR-NOVO | PENTALATERAL_UNIVERSAL/OPERACAO/DEPENDENCY_MAP.json | CLAUDE_PROJECT_INSTRUCAO ausente ou ordem_conselho divergente do CLAUDE.md |
| CRÍTICO | CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json | loop_atual != loop em WIP_BOARD |
| CRÍTICO | PENDENTES.md | Seção "LOOP [N]" ausente para loop atual |
| CRÍTICO | CLIENTES/WIP_BOARD.json | loop_fase_atual.loop != LOOP_STATE.loop_atual |
| CRÍTICO | CLAUDE.md | Nº de membros no SISTEMA divergente do Conselho real (6→8 membros + Detector coadjuvante, pós-Loop 35) |
| ATOR-NOVO | CONSELHO/SYSTEM_PROMPT_{PROJETISTA,EMBAIXADOR_DIGITAL,DETECTOR_DERIVA}.md | Prompt de definição do ator desatualizado vs. Drive (G5 estrutural — `verify_gdrive_freshness.ps1 -Perfil CONSELHO`) |
| ALTO | INTELLIGENCE_LEDGER.md | Último P-XXX tem mais de 2 loops sem adição |
| ALTO | CLIENTES/*/NOTEBOOKLM_FONTES/04_INTELLIGENCE_LEDGER.md | Diverge do LEDGER raiz |
| ALTO | CLIENTES/*/NOTEBOOKLM_FONTES/02_MEMORANDO_PENTALATERAL_UNIVERSAL.md | Diverge do UNIVERSAL |
| MÉDIO | CLIENTES/*/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR_*.md | Sem data do ano atual no cabeçalho |
| MÉDIO | CLIENTES/*/NOTEBOOKLM_FONTES/17_VANGUARD_TIMELINE.md | Não menciona Loop N ou N-1 |

### 2. METODOLOGIA

Para cada arquivo rastreado:
a) Ler as primeiras 20 linhas (cabeçalho, data, loop)
b) Verificar se menciona o loop atual ou anterior
c) Comparar campo crítico com fonte canônica
d) Classificar: VERDE / AMARELO / VERMELHO

Critérios:
- VERDE: menciona loop atual, campos coerentes com WIP_BOARD e LOOP_STATE
- AMARELO: menciona loop anterior (N-1), drift leve mas recuperável — 🔄 REPETIDO (M'X-1: alvo da deriva preditiva)
- VERMELHO: menciona N-2 ou anterior, ou campo crítico diverge da fonte — 🎯 DERIVA consumada

### 3. DRIFT INDEX (M'X-2)

Após a varredura, emitir um índice 0–100 por cluster (atores novos · clientes · universal · operação):

```
DRIFT INDEX = round( 100 * (1 - (pesoVermelho*Nverm + pesoAmarelo*Namar) / (totalDocs * pesoVermelho)) )
  pesoVermelho = 1.0 · pesoAmarelo = 0.4
  >= 90 VERDE · 70-89 AMARELO · < 70 VERMELHO (Alerta de Risco ao Diretor)
```

### 4. OUTPUT

```
DOC DRIFT AUDIT — [DATA] — Loop [N] — [CLIENTE]
DRIFT INDEX: atores-novos [NN] · clientes [NN] · universal [NN] · operação [NN]
[VERMELHO] [arquivo] — motivo
[AMARELO]  [arquivo] — motivo (🔄 prestes a derivar)
[VERDE]    [arquivo] — coerente

AÇÕES IMEDIATAS (VERMELHO): corrigir antes de qualquer deliberação.
AÇÕES PLANEJADAS (AMARELO): corrigir na mesma sessão (deriva preditiva — antecipar).
```

### 5. FALHA-PROCESSO SE DERIVA > 2 LOOPS

```
[FALHA-PROCESSO-{DATA}-DERIVA] [arquivo] — [N] loops sem atualização.
Registrar em LEDGER_INBOX.md imediatamente.
```

---

## CLASSIFICAÇÃO DE DERIVA — TIPO A / B / C

Adotado do Antigravity Executor (Build A, Loop 33 ATO 3) — complementa o semáforo VERDE/AMARELO/VERMELHO com tipologia de causa.

| Tipo | Nome | Critério |
|---|---|---|
| **A** | Deriva Temporal | Timestamp antigo, manifesto defasado, doc `[IDENTIDADE]` >30 dias sem revalidação |
| **B** | Referência Fantasma | P-XXX citado mas ausente do LEDGER, Loop sem registro na TIMELINE, filepath inexistente em disco |
| **C** | Drift de Propagação | `UNIVERSAL_PURO` atualizado mas cópia em `CLIENTES/*` desatualizada; schema JSON ou skill em versão obsoleta |
| **D** | Drift de Promessa (ator novo) | Template CLAUDE_PROJECT_INSTRUCAO promete capacidade/bloco que a produção real do ator não cumpre (M'X-3) |

### OUTPUT EM TABELA (quando emitir relatório completo)

| Arquivo / Caminho | Data Local | Tipo (A/B/C/D) | Ação Proposta |
|:---|:---|:---|:---|
| `CLIENTES/INGRID/PASSO3...` | 2026-05-10 | TIPO A | Atualizar cabeçalho para Loop atual |
| `PENTALATERAL_UNIVERSAL/...` | 2026-06-01 | TIPO B | Remover citação ao P-XXX (inexistente) |
| `CLIENTES/VALDECE/skill.md` | 2026-05-20 | TIPO C | Re-sync a partir de UNIVERSAL_PURO |
| `CLAUDE_PROJECTS/TEMPLATE_INSTRUCAO_PROJETISTA.md` | 2026-06-15 | TIPO D | Revalidar bloco vs. produção do Projetista |

**LIMITE DE ALERTA:** >30 arquivos com deriva → emitir Alerta de Risco P-147 ao Diretor sem formatar tabela completa.

**GUARDRAIL:** Output vai SEMPRE para `PENDING_REVIEW.md` — nunca gravação direta em LEDGER ou WIP_BOARD.

---

## INTEGRAÇÃO

- doc_freshness_checker.ps1 (Gate 0.5): verifica CONTEÚDO — automático
- Esta skill: verifica SEMÂNTICA — manual quando suspeita de deriva
- sync_guard.ps1: verifica HASH — integridade física dos arquivos
- Cláusula de auto-obsolescência do Projetista (M'P-3): o Detector monitora as condições de
  revalidação registradas pelo Projetista e dispara reprojeção quando uma condição vira. Ponte formal
  Projetista → Detector.

---

v1.0 (2026-06-11): ATO 3 Loop 33 — análise semântica de deriva documental.
v1.1 (2026-06-15): Loop 34 — identidade Detector de Deriva + M'X-1 (deriva preditiva) + M'X-2 (Drift Index) + M'X-3 (atores novos como 1º alvo) + TIPO D (drift de promessa) + ponte Projetista→Detector.
