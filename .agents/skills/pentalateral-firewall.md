---
name: pentalateral-firewall
description: Declara arquivos protegidos de operações automáticas no Pentalateral IAH. Lido por Antigravity, Músculo e scripts de automação antes de qualquer escrita.
version: "1.0"
created: "2026-06-10"
---

# PENTALATERAL FIREWALL — LISTA DE PROTEÇÃO DE ARQUIVOS

> Todo agente (Antigravity, Músculo, scripts) DEVE verificar esta lista antes de escrever,
> sobrescrever ou deletar qualquer arquivo. Violação = incidente irrecuperável.

---

## R-01 — ARQUIVOS PESSOAIS DO DIRETOR (READ-ONLY ABSOLUTO)

Estes arquivos pertencem exclusivamente ao Diretor. Nenhum agente ou script os toca.
Não estão sujeitos a sync, propagação, sobrescrita ou deleção automática.

| Arquivo | Caminho | Razão |
|---|---|---|
| `SUGESTOES_DIRETOR.md` | `CONSELHO/SUGESTOES_DIRETOR.md` | Arquivo pessoal do Diretor — deliberações privadas |

**Regra:** qualquer script ou agente que detectar tentativa de escrita em R-01 → abort imediato + alerta.

---

## R-02 — ARQUIVOS PROTEGIDOS POR P-098 (REQUEREM FLAG EXPLÍCITA)

Arquivos que o `file_protection_guard.ps1` protege. Só editáveis com `.musculo_autorizacao.flag`.

| Arquivo | Protetor |
|---|---|
| `CLAUDE.md` | `file_protection_guard.ps1` |
| `INTELLIGENCE_LEDGER.md` | `file_protection_guard.ps1` |
| `DEPENDENCY_MAP.json` | `file_protection_guard.ps1` |
| `.claude/skills/*.md` | `file_protection_guard.ps1` |
| `PASSO3_GEMINI.md` (qualquer cliente) | `file_protection_guard.ps1` |
| `PASSO5_NOTEBOOKLM.md` (qualquer cliente) | `file_protection_guard.ps1` |
| `PASSO7_EMBAIXADOR.md` (qualquer cliente) | `file_protection_guard.ps1` |

---

## R-03 — ISOLAMENTO P-059 (BLOQUEADO ATÉ 3 FERRAMENTAS)

Antigravity NÃO pode tocar estes caminhos até que as 3 ferramentas de isolamento existam:
(a) Gate que aborta ao tocar caderno de cliente não declarado
(b) Gate que recusa gerar DIRETRIZ sem ter lido PASSO3+CONTEXTO
(c) Saída sempre → PENDING_REVIEW/Músculo, nunca decisão direta

| Caminho bloqueado |
|---|
| `CLIENTES/INGRID/` |
| `CLIENTES/VALDECE/` |
| `CLIENTES/*/CLAUDE_PROJECT/` (exceto VANGUARD) |
| `CLIENTES/*/NOTEBOOKLM_FONTES/` (exceto VANGUARD) |

---

## R-04 — ARQUIVOS GERADOS AUTOMATICAMENTE (NUNCA EDITAR MANUALMENTE)

| Arquivo | Gerado por |
|---|---|
| `CONTEXTO_GEMINI.md` | `gemini_anchor_generator.ps1` |
| `CLIENTES/WIP_BOARD.md` | `propagate_changes.ps1` (espelho do .json) |
| `PROTOCOLOS_ENCERRAMENTO/PAINEL_ATIVIDADES_*.md` | `generate_protocolo_encerramento.ps1` |
| `SYNC_REPORT_*.md` | `sync_vanguard_docs.ps1` |

---

## VERSÃO E EXPANSÃO

v1.0 (2026-06-10): R-01 inicializado com SUGESTOES_DIRETOR.md · R-02/03/04 documentados.
ATO 4 expande: .agents/workflows/pre-commit.md + 3 skills + gate session_start.
