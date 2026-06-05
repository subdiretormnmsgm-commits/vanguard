# SKILL: pentalateral-atualizacao-v1.md
**Camada:** Sistema Interno — Infraestrutura Pentalateral | **Loop:** Universal | **Stack:** Claude Code + n8n + PowerShell + NotebookLM + Gemini

## [AUDITORIA DE COERÊNCIA]

O Pentalateral IAH opera com 5 atores e 1 sistema nervoso autônomo (n8n). Cada sessão de build produz mudanças que cascateiam por múltiplas camadas de documentos — e a falha mais comum não é não atualizar um arquivo, é não saber QUAIS arquivos precisam ser atualizados. Esta skill é o mapa completo de cascata de atualização do sistema.

**Princípio fundador:** P-060 — o Músculo é responsável por toda propagação. Zero intervenção do Diretor em gestão de documentos.

**Gatilho de uso:** invocar `/pentalateral-atualizacao-v1` sempre que:
- Um novo princípio for inscrito no LEDGER
- Um workflow n8n for criado, modificado ou desativado
- Um loop de cliente for fechado (MEMORIA + relatorio + DELIBERACAO)
- Um template universal for criado ou modificado
- Uma nova sessão de Auditor (NotebookLM) for preparada
- O WIP_BOARD for alterado

---

## [CONEXÃO HISTÓRICA]

**Falha de 2026-05-18 (FALHA-PROCESSO-2026-05-18):** Músculo atualizou deliberação mas não atualizou MEMORIA_EMBAIXADOR — Diretor detectou. Origem do P-032.

**Falha de 2026-05-24 (DEF-M-6):** Músculo leu apenas títulos de PENDENTES sem ler o corpo — atualizou arquivos errados. Origem do P-063.

**Falha de 2026-05-30 (WIP_BOARD INCONSISTENTE):** WIP_BOARD declarou `gemini=OK` sem DIRETRIZ existir em disco. Diretor detectou via Embaixador. Origem do P-091.

**Falha crônica (pré-2026-05-26):** NOTEBOOKLM_FONTES dos clientes desatualizados em relação ao PENTALATERAL_UNIVERSAL — Auditor deliberava sobre sistema desatualizado. Origem do P-033.

Esses padrões têm um ponto em comum: o Músculo atualizou o arquivo principal mas não propagou para os dependentes. Esta skill elimina esse gap com cascata explícita.

---

## [PADRÃO DE SUCESSO/FALHA]

**Sucesso:** Após qualquer build significativo, rodar esta skill e verificar cada célula da MATRIZ DE CASCATA abaixo. Fechar a sessão com `propagate_changes.ps1` já executado. O Diretor nunca diz "esse arquivo está desatualizado" — o Músculo detectou antes.

**Falha:** Músculo fecha a sessão com git commit mas sem propagar para NOTEBOOKLM_FONTES, CLAUDE.md, WIP_BOARD.md e scripts dependentes. Na próxima sessão, o Auditor delibera sobre estado antigo. O Estrategista propõe soluções baseadas em premissas obsoletas. O loop começa envenenado.

---

## [PERSPECTIVA DO SÓCIO — AUDITOR]

O risco sistêmico mais silencioso do Pentalateral não é perder um cliente — é o Auditor (NotebookLM) deliberar com fontes obsoletas. Cada vez que o NOTEBOOKLM_FONTES fica para trás do estado real do sistema, as skills geradas pelo Auditor partem de premissas erradas, e o Músculo executa o plano errado. A MATRIZ DE CASCATA abaixo é a vacina contra esse risco. O Músculo deve tratá-la como lei — não como sugestão.

---

## ⚙️ MAPA COMPLETO DO SISTEMA — TODOS OS ARQUIVOS

### CAMADA 0 — FONTES CANÔNICAS (TIPO 1 UNIVERSAL_PURO)
> Editadas APENAS em PENTALATERAL_UNIVERSAL/ — nunca nas cópias de projeto.

| Arquivo | Caminho | Papel |
|---|---|---|
| `SKILL_PROTOCOLO_VANGUARD.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Processo operacional completo do Pentalateral. Sync → `.claude/skills/vanguard-protocolo.md` |
| `MEMORANDO_PENTALATERAL_UNIVERSAL.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Constituição do Pentalateral. Sync → `.claude/skills/vanguard-memorando.md` |
| `MANUAL_DIRETOR.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Guia do Diretor |
| `INTELLIGENCE_LEDGER.md` | raiz | Princípios P-001 a P-111+. **Protegido por file_protection_guard.ps1** |
| `DEPENDENCY_MAP.json` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Mapa de dependências v2.1. **Protegido por file_protection_guard.ps1** |
| `VANGUARD_TIMELINE.md` | `PENTALATERAL_UNIVERSAL/HISTORICO/` | Linha do tempo evolutiva. Sync → slot 16/17 NOTEBOOKLM_FONTES |
| `TEMPLATES_COMUNICACAO_PENTALATERAL.md` | `PENTALATERAL_UNIVERSAL/TEMPLATES/` | Templates de PASSO3/PASSO5/PASSO7/MEMORIA/RELATORIO |
| `ROTEIRO_LOOP_PENTALATERAL.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Sequência completa do loop |

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

### CAMADA 3 — NOTEBOOKLM_FONTES (MAPA DE SLOTS)
> Fontes carregadas no Auditor. Slots 00-08 universais. Slots 09-18 por projeto.
> **Notion é o PAINEL de visualização** — não a fonte de verdade. Git é canônico.

| Slot | Arquivo | Tipo | Atualizar quando |
|---|---|---|---|
| 00 | `INSTRUCAO_AUDITOR.md` + `MANIFESTO_DE_FONTES.md` | Universal | Loop novo ou mudança de processo |
| 01 | `SKILL_PROTOCOLO_VANGUARD.md` | Universal TIPO 1 | Sync automático via `sync_vanguard_docs.ps1` |
| 02 | `MEMORANDO_PENTALATERAL_UNIVERSAL.md` | Universal TIPO 1 | Sync automático |
| 03 | `MANUAL_DIRETOR.md` | Universal TIPO 1 | Sync automático |
| 04 | `INTELLIGENCE_LEDGER.md` | Universal TIPO 1 | Sync automático após novo princípio |
| 05 | `PROCESSO_EVOLUTIVO_PENTALATERAL.md` | Universal | Mudança de processo |
| 06 | `TEMPLATES_COMUNICACAO_PENTALATERAL.md` | Universal | Novo template aprovado |
| 07 | `WIP_BOARD.md` + `WIP_BOARD.txt` | Estado | Toda sessão — `atualizar_wip_board_txt.ps1` |
| 08 | `ANALISE_SOCIO_ATUAL.txt` | Estado | Após sessão NotebookLM — Diretor carrega |
| 09 | `BRIEFING_DISCOVERY.txt` | Projeto | Criado no Loop 1 |
| 10 | `MEMORIA_V[N]_[NOME].md` | Projeto | Ao fechar loop — cópia mais recente |
| 11 | `relatorio_evolutivo_V[N]_[NOME].md` | Projeto | Ao fechar loop — cópia mais recente |
| 12 | `DIRETRIZ_GEMINI_V[N].txt` | Projeto | Ao receber DIRETRIZ do Gemini |
| 13 | `PASSO5_NOTEBOOKLM.md` | Projeto | Músculo prepara antes de cada sessão |
| 14 | `MEMORIA_EMBAIXADOR.md` | Projeto | P-032 — após toda deliberação |
| 15 | `MAPA_SISTEMA_OPERACIONAL.md` | Universal | Esta skill — slot reservado |
| 16-17 | `VANGUARD_TIMELINE.md` | Universal TIPO 1 | Sync automático após marco |
| 18 | `ATUALIZACAO_PENTALATERAL_[DATA].md` | Universal | Ao fechar loop significativo |

### CAMADA 4 — N8N WORKFLOWS (SISTEMA NERVOSO)
> Host: `https://vanguard-vanguard-n8n.0ul9nk.easypanel.host` · EasyPanel 24/7
> Arquivos locais: `n8n_workflows/` · Credenciais: `N8N Easypanel.txt` (gitignored)
> **Notion** serve como PAINEL de visualização dos outputs — W-1/W-3/W-4/W-7 escrevem nele.

| Workflow | ID | Trigger | Output | Fallback P-110 |
|---|---|---|---|---|
| W-1 Check-in | `rinBbgMlUTEccnTI` | Cron 7h/13h/20h | Telegram + Notion WIP | `check_in.ps1` |
| W-2 Monitor Supabase | `rV4gw82vFSrtPF4a` | Cron horário | Telegram (se offline) | Testar URL Supabase manualmente |
| W-3 GitHub Push | `VBPua2oP0YQhxdpn` | Webhook GitHub | Telegram + Notion WIP | `git log` + Telegram manual |
| W-4 Session Close | `rMl9OJaA1hazqo1i` | Webhook POST | Telegram + Notion WIP + Pendentes | `n8n_session_webhook.ps1 -DryRun` |
| W-7 Veredito | `KisAa6ynD4btgrkL` | Telegram `/aprovar /rejeitar /veredito` | Notion Pendentes + Telegram | Editar DECISOES.json direto |
| W-5 ChurnWatch | gate: 2026-06-12 | Cron diário | Telegram alerta churn | `churn_watch_autonomo.ps1` |
| W-6 Embaixador API | gate: 30 dias FASE 1 | Webhook POST | Embaixador Claude API | Passo 7 manual |

**Quando novo workflow for criado → atualizar:**
CLAUDE.md (seção N8N) · vanguard-protocolo.md · DEPENDENCY_MAP.json · WIP_BOARD.json · VANGUARD_TIMELINE.md

### CAMADA 5 — SCRIPTS DE ORQUESTRAÇÃO

| Script | Quando executar | O que faz |
|---|---|---|
| `session_close.ps1` | Encerrar sessão (ordem do Diretor) | FRICÇÕES + PRINCÍPIOS + DÍVIDAS + email + sync |
| `gemini_anchor_generator.ps1` | Antes do Gemini | Compila LEDGER + WIP → `CONTEXTO_GEMINI.md` |
| `preparar_notebooklm_projeto.ps1` | Antes do NotebookLM | Monta NOTEBOOKLM_FONTES completo |
| `ir_ao_embaixador.ps1` | Antes/após reunião | Copia mensagem + abre browser |
| `sync_vanguard_docs.ps1` | Após mudança em PENTALATERAL_UNIVERSAL/ | P-033 — sync SHA-256 para NOTEBOOKLM_FONTES |
| `propagate_changes.ps1` | Após mudança em arquivo-fonte | Cascata via DEPENDENCY_MAP.json |
| `atualizar_wip_board_txt.ps1` | Após editar WIP_BOARD.json | Gera WIP_BOARD.md + .txt |
| `ping_n8n.ps1` | PASSO 8e session_start | Uptime n8n — alerta se offline |
| `auto_resolve_pendentes.ps1` | Post-commit (automático) | Detecta [RESOLVE:] → marca [x] |
| `skill_parser_gate.ps1` | Ao receber skill do Auditor | Valida 4 blocos + dados reais |
| `auditar_consistencia.ps1` | Gate 0 de sessão | WIP_BOARD vs artefatos em disco |

### CAMADA 6 — HOOKS (AUTOMÁTICOS — NÃO MODIFICAR SEM VEREDITO)

| Hook | Evento | Protege contra |
|---|---|---|
| `session_start.ps1` | Abertura de sessão | Amnésia do Músculo |
| `hv1_credential_guard.ps1` | Write/Edit | Credencial hardcoded no código |
| `file_protection_guard.ps1` | Write/Edit | Edição de arquivos protegidos sem flag |
| `p033_sync_guardian.ps1` | Write em PENTALATERAL_UNIVERSAL/ | Falta de sync automático |
| `fechamento_checklist.ps1` | git commit | Checklist de fechamento |
| `stop_checklist.ps1` | Sessão encerra | Checklist mesmo sem commit |

---

## ⚙️ MATRIZ DE CASCATA — O QUE MUDA QUANDO ALGO MUDA

### Trigger 1 — Novo princípio no LEDGER
```
INTELLIGENCE_LEDGER.md (raiz)
  ├─ sync_vanguard_docs.ps1 → CLIENTES/*/NOTEBOOKLM_FONTES/04_INTELLIGENCE_LEDGER.md
  ├─ CONTEXTO_GEMINI.md (se relevante ao projeto ativo)
  ├─ VANGUARD_TIMELINE.md → se for princípio landmark
  ├─ DEPENDENCY_MAP.json → se gerar nova dependência estrutural
  └─ CLAUDE.md → se alterar comportamento do Músculo
```
Verificar: hashes LEDGER em fontes batem com raiz?

### Trigger 2 — Workflow n8n criado ou modificado
```
n8n_workflows/workflow_N_[nome].json
  ├─ CLAUDE.md → seção N8N (tabela workflows)
  ├─ .claude/skills/vanguard-protocolo.md → seção Automação
  ├─ DEPENDENCY_MAP.json → infra_dependencias.n8n
  ├─ WIP_BOARD.json → (se afetar cliente específico)
  └─ VANGUARD_TIMELINE.md → se for workflow de infraestrutura
```
Verificar: JSON local bate com EasyPanel? 5 workflows ativos?

### Trigger 3 — Loop de cliente fechado
```
HISTORICO/MEMORIA_V[N]_[NOME].md + relatorio + DELIBERACAO
  ├─ WIP_BOARD.json → loop_fase_atual.musculo = "OK" + proximo
  ├─ WIP_BOARD.md → atualizar_wip_board_txt.ps1
  ├─ MEMORIA_EMBAIXADOR.md → P-032 obrigatório
  ├─ PENDENTES.md → [x] tarefas + [RESOLVE:] no commit
  ├─ NOTEBOOKLM_FONTES/10 + 11 → cópias de MEMORIA e relatorio
  ├─ VANGUARD_TIMELINE.md → se for gate comercial ou marco
  └─ INTELLIGENCE_LEDGER.md → princípios extraídos no loop
```
Verificar: auditar_consistencia.ps1 — WIP_BOARD OK com DELIBERACAO em disco?

### Trigger 4 — Mudança em PENTALATERAL_UNIVERSAL/
```
PENTALATERAL_UNIVERSAL/[qualquer arquivo]
  ├─ sync_vanguard_docs.ps1 → CLIENTES/*/NOTEBOOKLM_FONTES/
  ├─ .claude/skills/vanguard-protocolo.md → se for SKILL_PROTOCOLO
  └─ .claude/skills/vanguard-memorando.md → se for MEMORANDO
```
Verificar: p033_sync_guardian.ps1 disparou? Integridade = VERDE?

### Trigger 5 — Template novo aprovado
```
TEMPLATES_COMUNICACAO_PENTALATERAL.md
  ├─ sync_vanguard_docs.ps1 → NOTEBOOKLM_FONTES/06_TEMPLATES
  └─ PASSO3/PASSO5/PASSO7 do projeto ativo → atualizar se afetados
```

### Trigger 6 — Nova skill de cliente instalada
```
.claude/skills/[cliente]-v[N].md
  ├─ Validar: skill_parser_gate.ps1 → APROVADO ou REJEITADO
  ├─ WIP_BOARD.json → loop_fase_atual.notebooklm = "OK"
  └─ PENDENTES.md → [x] na tarefa de instalação
```

### Trigger 7 — Novo cliente no WIP_BOARD
```
WIP_BOARD.json → novo projeto em board.discovery
  ├─ WIP_BOARD.md → atualizar_wip_board_txt.ps1
  ├─ CLIENTES/[NOME]/NOTEBOOKLM_FONTES/ → preparar_notebooklm_projeto.ps1
  ├─ CLIENTES/[NOME]/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md → criar
  ├─ Verificar C1+C4+C7+C8 antes do onboarding
  └─ Ativar: ir_ao_embaixador.ps1 -cliente [NOME] → Passo 0
```

---

## ⚙️ O LOOP COMPLETO COM N8N INTEGRADO (V27+)

```
PASSO 0 → Embaixador ativado (ir_ao_embaixador.ps1)
PASSO 1 → Qualificação GO/NO-GO + BRIEFING_DISCOVERY
PASSO 2 → Discovery 7 perguntas → MEMORIA_EMBAIXADOR inicial
PASSO 3 → gemini_anchor_generator.ps1 → PASSO3_GEMINI.md gravado (P-090)
           Diretor: cole texto + anexe MEMORIA + relatorio + LEDGER + WIP
           Gemini → DIRETRIZ
           Músculo: NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V[N].txt
           W-3: notifica Telegram + Notion (automático ao fazer push)
PASSO 4 → Diretor valida DIRETRIZ
PASSO 5 → preparar_notebooklm_projeto.ps1 -cliente [NOME]
           Músculo: PASSO5_NOTEBOOKLM.md
           Diretor: Wipe & Sync + cola PASSO5 no NotebookLM
           Auditor → SKILL nomeada
           Músculo: skill_parser_gate.ps1 → .claude/skills/[cliente]-v[N].md
           WIP_BOARD: notebooklm = "OK"
PASSO 6 → Músculo executa /[cliente]-v[N]
           Deliberação 7 pontos → plano de build
PASSO 7 → ir_ao_embaixador.ps1 -cliente [NOME]
           Embaixador: CONFIRMA/EXPANDE/ALERTA [M+G+N]-1a5
           Seção D: temperatura + ações + [E-1 a E-5]
PASSO 8 → Build com commits [RESOLVE:] em todo fechamento de PENDENTES
           W-3: Telegram + Notion a cada push (automático)
           W-4: Telegram + Notion ao fechar sessão (automático)
PASSO 8.5 → Debrief Embaixador pós-reunião (ir_ao_embaixador.ps1)
PASSO 9 → Fechamento:
           DELIBERACAO_LOOP_V[N]_[NOME].md (P-037 gate)
           MEMORIA_V[N]_[NOME].md
           relatorio_evolutivo_V[N]_[NOME].md
           MEMORIA_EMBAIXADOR atualizada (P-032)
           WIP_BOARD: musculo = "OK" → Trigger 3 cascata
           session_close.ps1 (ordem do Diretor) → W-4 dispara
           Wipe & Sync NotebookLM para próximo loop
PASSO 10 → Diretor valida → loop recomeça

VEREDITOS via Telegram (W-7):
  /aprovar D1 | /rejeitar D2 | /veredito D1:A D2:B D3:C
  → Notion registra + Telegram confirma
  → Músculo lê e executa executar_vereditos.ps1
```

---

## ⚙️ CHECKLIST PÓS-BUILD — ANTES DE QUALQUER GIT COMMIT

```
[ ] 1. LEDGER: novo princípio? → sync_vanguard_docs.ps1
[ ] 2. WIP_BOARD: loop_fase_atual atualizado? → atualizar_wip_board_txt.ps1
[ ] 3. PENDENTES: [x] em concluídas? [RESOLVE:] no commit?
[ ] 4. MEMORIA_EMBAIXADOR: atualizada para cliente ativo? (P-032)
[ ] 5. NOTEBOOKLM_FONTES: slots 10/11/12/14 atualizados?
[ ] 6. n8n: JSONs locais refletem EasyPanel? 5 workflows ativos?
[ ] 7. VANGUARD_TIMELINE: marco novo registrado?
[ ] 8. CLAUDE.md: nova regra/seção se processo mudou?
[ ] 9. vanguard-protocolo.md: processo atualizado?
[ ] 10. Credenciais: nenhuma no código? N8N Easypanel.txt gitignored?
```

---

*Versão: 1.0 · 2026-06-05 · Pentalateral IAH*
*Próxima atualização: W-5/W-6 em produção, ou novo membro do Conselho adicionado*
