# MAPA DO SISTEMA OPERACIONAL — V2
> Versão: 2.0 · 2026-06-05 · Pentalateral IAH
> Gerado: skill pentalateral-atualizacao-v1 (Músculo) + auditoria pentalateral-atualizacao-v2 (Auditor Sistêmico)
> V1: mapa base + n8n. V2: incorpora Cascata Delta V27 (9 itens) + 3 riscos sistêmicos mapeados.
> Skill de invocação: `.claude/skills/pentalateral-atualizacao-v2.md`
> Auditoria completa: `PENTALATERAL_UNIVERSAL/OPERACAO/MAPA_SISTEMA_OPERACIONAL_V1.md` (4 blocos)

---

## DELTA V27 — O QUE MUDOU DE V1 PARA V2

Itens adicionados com base na auditoria do Auditor Sistêmico (2026-06-05):

| Item | Onde adicionado | Referência |
|---|---|---|
| MANIFESTO_DE_FONTES.md explícito | CAMADA 0 | P-053 |
| VANGUARD_INNOVATION_AUDIT.md | CAMADA 0 | AUTO-LOG |
| REGISTRO_DE_PREMISSAS.md | CAMADA 2 | SKILL_PROTOCOLO_VANGUARD 2026-05-23 |
| CANDIDATOS_A_PRINCIPIO.md | CAMADA 2 | Captura de fricções por projeto |
| MAINTENANCE_COST.md por workflow | CAMADA 4 | P-110 |
| P-109 Notion OUTPUT ONLY mapeado | CAMADA 4 | P-109 |
| P-102 coexistência 30 dias | CAMADA 4 | P-102 |
| Risco P-072: W-7 Telegram desync | RISCOS ATIVOS | P-072 / P-055 |
| Checklist expandido: itens 11+12 | CHECKLIST | REGISTRO_DE_PREMISSAS + CANDIDATOS |

---

## DELTA V29/L32 — HERMES GRAU B + ANTIGRAVITY EXECUTOR + RUNNING_INTELLIGENCE (2026-06-10)

| Item | Onde adicionado | Referência |
|---|---|---|
| Hermes Grau B ATIVO (D1:A executado 2026-06-10) | CAMADA 4 (Hermes Agent) | CLAUDE.md + MANUAL_HERMES_COMMANDS.md |
| Antigravity = EXECUTOR do Estrategista (não o Estrategista) | CAMADA 4 (Antigravity CLI) | GEMINI.md + SKILL_PROTOCOLO_VANGUARD v7.0 |
| RUNNING_INTELLIGENCE.md (Embaixador — decaimento 90d) | CAMADA 2 (por projeto) | P-143 |
| builds_aprovados_nao_iniciados no LOOP_STATE v1.1 | CAMADA 1 (estado) | LOOP_STATE_SCHEMA v1.1 |
| p133_gate_zero_captacao no LOOP_STATE | CAMADA 1 (gates) | P-133 |
| loop_anterior e missao como campos do LOOP_STATE v1.1 | CAMADA 1 (estado) | LOOP_STATE_SCHEMA v1.1 |

---

## ⚙️ MAPA COMPLETO DO SISTEMA — TODOS OS ARQUIVOS

### CAMADA 0 — FONTES CANÔNICAS (TIPO 1 UNIVERSAL_PURO)
> Editadas APENAS em PENTALATERAL_UNIVERSAL/ — nunca nas cópias de projeto.

| Arquivo | Caminho | Papel |
|---|---|---|
| `SKILL_PROTOCOLO_VANGUARD.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Processo operacional v6.3. Sync → `.claude/skills/vanguard-protocolo.md` |
| `MEMORANDO_PENTALATERAL_UNIVERSAL.md` | `PENTALATERAL_UNIVERSAL/CONSTITUICAO/` | Constituição do Pentalateral. Sync → `.claude/skills/vanguard-memorando.md` |
| `MANUAL_DIRETOR.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Guia do Diretor |
| `INTELLIGENCE_LEDGER.md` | raiz | Princípios P-001 a P-111+. **Protegido por file_protection_guard.ps1** |
| `DEPENDENCY_MAP.json` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Mapa de dependências v2.1+. **Protegido** |
| `VANGUARD_TIMELINE.md` | `PENTALATERAL_UNIVERSAL/HISTORICO/` | Linha do tempo V1-V27. Sync → slot 16/17 |
| `PROCESSO_EVOLUTIVO_PENTALATERAL.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Evolução do Conselho (inclui V26/V27). Sync → slot 05 |
| `MANIFESTO_DE_FONTES.md` | `PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/` | **[P-053] Declara o que o Auditor pode ver** — slot 00 + posição 15+ |
| `VANGUARD_INNOVATION_AUDIT.md` | `PENTALATERAL_UNIVERSAL/HISTORICO/` | **[AUTO-LOG] Registro de inovações por versão** — sync via p033 |

### CAMADA 1 — DOCUMENTOS DE ESTADO (ATUALIZADOS POR SESSÃO)

| Arquivo | Caminho | Papel | Quem atualiza |
|---|---|---|---|
| `WIP_BOARD.json` | `CLIENTES/` | Estado real de todos os projetos | Músculo — imediatamente ao mudar estado |
| `WIP_BOARD.md` | `CLIENTES/` | Cópia legível para Auditor | Músculo — junto com .json (P-033) |
| `PENDENTES.md` | raiz | Tarefas pendentes com prazo | Músculo — em tempo real |
| `CONTEXTO_GEMINI.md` | raiz | Contexto compilado para o Estrategista | `gemini_anchor_generator.ps1` |
| `ANALISE_SOCIO_ATUAL.txt` | `CONSELHO/NotebookLM/` | Análise mais recente do Sócio | Diretor (após sessão NotebookLM) |

### CAMADA 2 — DOCUMENTOS DE CLIENTE (POR PROJETO)

| Arquivo | Caminho | Papel | Quando criar |
|---|---|---|---|
| `PASSO3_GEMINI.md` | `CLIENTES/[NOME]/` | Input para o Estrategista | Músculo antes de ir ao Gemini |
| `PASSO5_NOTEBOOKLM.md` | `CLIENTES/[NOME]/` | Input para o Auditor | Músculo antes de ir ao NotebookLM |
| `PASSO7_EMBAIXADOR.md` | `CLIENTES/[NOME]/` | Input para o Embaixador | Músculo antes de ir ao Embaixador |
| `BRIEFING_DISCOVERY.txt` | `CLIENTES/[NOME]/` | Discovery do cliente | Criado no Loop 1 — nunca sobrescrever |
| `MEMORIA_V[N]_[NOME].md` | `CLIENTES/[NOME]/HISTORICO/` | Contexto técnico do loop fechado | Músculo ao fechar loop |
| `relatorio_evolutivo_V[N]_[NOME].md` | `CLIENTES/[NOME]/HISTORICO/` | Análise de negócio do loop fechado | Músculo ao fechar loop |
| `DELIBERACAO_LOOP_V[N]_[NOME].md` | `CLIENTES/[NOME]/HISTORICO/` | Síntese P-037 | Músculo ao fechar loop |
| `DECISOES_[DATA].json` | `CLIENTES/[NOME]/CLAUDE_PROJECT/DECISOES/` | Vereditos do Diretor | Pipeline render_painel → executar_vereditos |
| `MEMORIA_EMBAIXADOR.md` | `CLIENTES/[NOME]/CLAUDE_PROJECT/` | Inteligência persistente do Embaixador | Músculo — P-032 — após toda deliberação |
| `REGISTRO_DE_PREMISSAS.md` | `CLIENTES/[NOME]/` | **[V2] Premissas do projeto** — monitorado pelo Músculo | Criado no Loop 1 com o BRIEFING |
| `CANDIDATOS_A_PRINCIPIO.md` | `CLIENTES/[NOME]/` | **[V2] Fricções candidatas a LEDGER** — auditado ao fechar loop | Músculo ao identificar padrão novo |

### CAMADA 3 — NOTEBOOKLM_FONTES (MAPA DE SLOTS)
> Slots 00-08 universais. Slots 09-19 por projeto.

| Slot | Arquivo | Tipo | Atualizar quando |
|---|---|---|---|
| 00 | `INSTRUCAO_AUDITOR.md` + `MANIFESTO_DE_FONTES.md` | Universal | Loop novo ou mudança de processo |
| 01 | `SKILL_PROTOCOLO_VANGUARD.md` | Universal TIPO 1 | Sync automático via `sync_vanguard_docs.ps1` |
| 02 | `MEMORANDO_PENTALATERAL_UNIVERSAL.md` | Universal TIPO 1 | Sync automático |
| 03 | `MANUAL_DIRETOR.md` | Universal TIPO 1 | Sync automático |
| 04 | `INTELLIGENCE_LEDGER.md` | Universal TIPO 1 | Sync automático após novo princípio |
| 05 | `PROCESSO_EVOLUTIVO_PENTALATERAL.md` | Universal | Mudança de processo (agora inclui V26/V27) |
| 06 | `TEMPLATES_COMUNICACAO_PENTALATERAL.md` | Universal | Novo template aprovado |
| 07 | `WIP_BOARD.md` + `WIP_BOARD.txt` | Estado | Toda sessão — `atualizar_wip_board_txt.ps1` |
| 08 | `ANALISE_SOCIO_ATUAL.txt` | Estado | Após sessão NotebookLM — Diretor carrega |
| 09 | `BRIEFING_DISCOVERY.txt` | Projeto | Criado no Loop 1 |
| 10 | `MEMORIA_V[N]_[NOME].md` | Projeto | Ao fechar loop — cópia mais recente |
| 11 | `relatorio_evolutivo_V[N]_[NOME].md` | Projeto | Ao fechar loop — cópia mais recente |
| 12 | `DIRETRIZ_GEMINI_V[N].txt` | Projeto | Ao receber DIRETRIZ do Gemini |
| 13 | `PASSO5_NOTEBOOKLM.md` | Projeto | Músculo prepara antes de cada sessão |
| 14 | `MEMORIA_EMBAIXADOR.md` | Projeto | P-032 — após toda deliberação |
| 15 | `MAPA_SISTEMA_OPERACIONAL.md` | Universal | Esta skill V2 — slot reservado |
| 16-17 | `VANGUARD_TIMELINE.md` | Universal TIPO 1 | Sync automático após marco |
| 18 | `ATUALIZACAO_PENTALATERAL_[DATA].md` | Universal | Ao fechar loop significativo |
| 19 | `PROTOCOLO_ATUALIZACAO_SISTEMA.md` | Universal | Ao fechar loop significativo |

### CAMADA 4 — N8N WORKFLOWS (SISTEMA NERVOSO) [V26 — 2026-06-04]
> Host: `https://vanguard-vanguard-n8n.0ul9nk.easypanel.host` · EasyPanel 24/7
> **P-109:** Notion = OUTPUT ONLY — git é canônico. **P-102:** Scripts .ps1 redundantes 30 dias.
> **P-110:** MAINTENANCE_COST.md documenta fallback ≤ 3 passos para cada workflow.

| Workflow | ID | Trigger | Output | Fallback P-110 |
|---|---|---|---|---|
| W-1 Check-in | `rinBbgMlUTEccnTI` | Cron 7h/13h/20h | Telegram + Notion WIP | `check_in.ps1` |
| W-2 Monitor Supabase | `rV4gw82vFSrtPF4a` | Cron horário | Telegram (se offline) | Testar URL manualmente |
| W-3 GitHub Push | `VBPua2oP0YQhxdpn` | Webhook GitHub | Telegram + Notion WIP | `git log` + Telegram manual |
| W-4 Session Close | `rMl9OJaA1hazqo1i` | Webhook POST | Telegram + Notion + Pendentes | `n8n_session_webhook.ps1 -DryRun` |
| W-7 Veredito | `KisAa6ynD4btgrkL` | Telegram /aprovar /veredito | Notion Pendentes + Telegram | Editar DECISOES.json direto |
| W-5 ChurnWatch | gate: 2026-06-12 | Cron diário | Telegram alerta churn | `churn_watch_autonomo.ps1` |
| W-6 Embaixador API | gate: 30 dias FASE 1 | Webhook POST | Embaixador Claude API | Passo 7 manual |

**⚠️ RISCO P-072 ATIVO:** W-7 Telegram deve atualizar DECISOES.json local imediatamente após /aprovar.
Estado assíncrono = Auditor delibera sobre premissas erradas. Verificar sincronização antes de produção plena.

### CAMADA 5 — SCRIPTS | CAMADA 6 — HOOKS
> Detalhamento completo: `PENTALATERAL_UNIVERSAL/OPERACAO/MAPA_SISTEMA_OPERACIONAL_V1.md` (seções 5 e 6)

---

## ⚙️ RISCOS SISTÊMICOS ATIVOS (Auditor Sistêmico — 2026-06-05)

| Risco | Princípio violado | Ação | Status |
|---|---|---|---|
| W-7 Telegram desync de DECISOES.json | P-072 / P-055 | Verificar sync W-7 → git antes de produção plena | ABERTO |
| MAINTENANCE_COST.md inexistente | P-110 | Criar `PENTALATERAL_UNIVERSAL/OPERACAO/MAINTENANCE_COST.md` | ABERTO |
| REGISTRO_DE_PREMISSAS não no DEPENDENCY_MAP | P-060 / P-074 | Atualizar DEPENDENCY_MAP.json → v2.2 | ABERTO |

---

## ⚙️ CHECKLIST PÓS-BUILD — ANTES DE QUALQUER GIT COMMIT

```
[ ] 1. LEDGER: novo princípio? → sync_vanguard_docs.ps1
[ ] 2. WIP_BOARD: loop_fase_atual atualizado? → atualizar_wip_board_txt.ps1
[ ] 3. PENDENTES: [x] em concluídas? [RESOLVE:] no commit?
[ ] 4. MEMORIA_EMBAIXADOR: atualizada para cliente ativo? (P-032)
[ ] 5. NOTEBOOKLM_FONTES: slots 10/11/12/14 atualizados?
[ ] 6. n8n: JSONs locais refletem EasyPanel? MAINTENANCE_COST.md atualizado? (P-110)
[ ] 7. VANGUARD_TIMELINE: marco novo registrado?
[ ] 8. CLAUDE.md: nova regra/seção se processo mudou?
[ ] 9. vanguard-protocolo.md: processo atualizado?
[ ] 10. Credenciais: nenhuma no código? N8N Easypanel.txt gitignored?
[ ] 11. REGISTRO_DE_PREMISSAS.md: premissas novas capturadas? [V2]
[ ] 12. CANDIDATOS_A_PRINCIPIO.md: fricções candidatas ao LEDGER? [V2]
```

---

*Versão: 2.0 · 2026-06-05 · Pentalateral IAH*
*Gerado: Músculo (V1 base) + Auditor Sistêmico NotebookLM (Delta V27)*
*Próxima atualização: W-5/W-6 em produção, DEPENDENCY_MAP v2.2, ou novo membro do Conselho*
