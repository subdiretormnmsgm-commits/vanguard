# PROTOCOLO DE ATUALIZAÇÃO DO SISTEMA — MÚSCULO
> Versão: 1.0 · 2026-06-05 · Pentalateral IAH V27
> Uso: consultar sempre que qualquer arquivo-fonte for alterado na sessão
> Complementa: `.claude/skills/pentalateral-atualizacao-v1.md` (mapa de cascata)
> P-060: o Músculo é responsável por toda propagação — zero intervenção do Diretor

---

## REGRA DE OURO

**Antes de fechar qualquer sessão, perguntar:**
> "O que mudei hoje? Quais arquivos dependem disso? Já propaghei?"

Se a resposta à terceira pergunta for NÃO → não fechar.

---

## SEÇÃO A — CHECKLIST RÁPIDO POR TIPO DE MUDANÇA

### A1 — Novo princípio no LEDGER

```powershell
# 1. Sync para todos os clientes
.\.claude\skills\files\sync_vanguard_docs.ps1

# 2. Verificar se CONTEXTO_GEMINI precisa atualizar
# (sim se o princípio afeta o projeto ativo)
.\scripts\gemini_anchor_generator.ps1

# 3. Atualizar VANGUARD_TIMELINE.md se for princípio landmark (P-0XX com impacto sistêmico)
# (editar manualmente PENTALATERAL_UNIVERSAL/HISTORICO/VANGUARD_TIMELINE.md)
# (copiar para CLIENTES/*/NOTEBOOKLM_FONTES/16_VANGUARD_TIMELINE.md)

# 4. Atualizar CLAUDE.md se o princípio muda comportamento do Músculo
# (editar CLAUDE.md — bloco "O QUE VOCÊ NUNCA ESQUECE")
```

**Verificação final:** hash do LEDGER em NOTEBOOKLM_FONTES/04 bate com raiz?

---

### A2 — Workflow n8n criado ou modificado

```powershell
# 1. Salvar JSON atualizado em n8n_workflows/
# (Write tool — nome: workflow_N_[nome].json)

# 2. Atualizar tabela N8N no CLAUDE.md
# (seção "N8N — CAMADA DE AUTOMAÇÃO DO PENTALATERAL")

# 3. Atualizar vanguard-protocolo.md (seção Automação)
# Criar .musculo_autorizacao.flag primeiro
echo "autorizado" > .musculo_autorizacao.flag
# Então editar .claude/skills/vanguard-protocolo.md

# 4. Atualizar DEPENDENCY_MAP.json
# (campo infra_dependencias.n8n.workflows_ativos)
echo "autorizado" > .musculo_autorizacao.flag
# Editar PENTALATERAL_UNIVERSAL/OPERACAO/DEPENDENCY_MAP.json

# 5. Sync universal
.\.claude\skills\files\sync_vanguard_docs.ps1

# 6. Atualizar VANGUARD_TIMELINE.md se for workflow de infraestrutura (W-5, W-6+)

# 7. Verificar EasyPanel — workflow ativo?
# curl ou verificação manual no painel n8n
```

**Verificação final:** JSON local ID bate com ID do EasyPanel? `active=true` verificado?

---

### A3 — Loop de cliente fechado

```powershell
# SEQUÊNCIA INVIOLÁVEL (P-045):
# 1. Criar DELIBERACAO_LOOP_V[N]_[NOME].md (P-037 gate)
# 2. Criar MEMORIA_V[N]_[NOME].md
# 3. Criar relatorio_evolutivo_V[N]_[NOME].md

# 4. Atualizar WIP_BOARD
python -c "
import json
with open('CLIENTES/WIP_BOARD.json','r',encoding='utf-8') as f: d=json.load(f)
# Editar loop_fase_atual do projeto
with open('CLIENTES/WIP_BOARD.json','w',encoding='utf-8') as f: json.dump(d,f,ensure_ascii=False,indent=2)
"
.\scripts\atualizar_wip_board_txt.ps1

# 5. Atualizar MEMORIA_EMBAIXADOR (P-032)
# (editar CLIENTES/[NOME]/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md)

# 6. Marcar PENDENTES com [x]
# (commits com [RESOLVE:] ativam auto_resolve_pendentes.ps1)

# 7. Copiar para NOTEBOOKLM_FONTES
cp "CLIENTES\[NOME]\HISTORICO\MEMORIA_V[N]_[NOME].md" "CLIENTES\[NOME]\NOTEBOOKLM_FONTES\10_MEMORIA_RECENTE.md"
cp "CLIENTES\[NOME]\HISTORICO\relatorio_evolutivo_V[N]_[NOME].md" "CLIENTES\[NOME]\NOTEBOOKLM_FONTES\11_RELATORIO_EVOLUTIVO.md"

# 8. Sync universal se princípios novos foram inscritos no LEDGER
.\.claude\skills\files\sync_vanguard_docs.ps1

# 9. Atualizar VANGUARD_TIMELINE.md se for gate comercial ou marco
```

**Verificação final:** `.\scripts\auditar_consistencia.ps1` — exit 0 sem divergência?

---

### A4 — Mudança em PENTALATERAL_UNIVERSAL/

```powershell
# Automático via p033_sync_guardian.ps1 (hook)
# Mas verificar manualmente:
.\.claude\skills\files\sync_vanguard_docs.ps1

# Se mudou SKILL_PROTOCOLO_VANGUARD.md:
cp "PENTALATERAL_UNIVERSAL\OPERACAO\SKILL_PROTOCOLO_VANGUARD.md" ".claude\skills\vanguard-protocolo.md"
# (requer .musculo_autorizacao.flag)

# Se mudou MEMORANDO:
cp "PENTALATERAL_UNIVERSAL\OPERACAO\MEMORANDO_PENTALATERAL_UNIVERSAL.md" ".claude\skills\vanguard-memorando.md"
# (requer .musculo_autorizacao.flag)
```

---

### A5 — Nova skill de cliente instalada

```powershell
# 1. Validar antes de instalar
.\scripts\skill_parser_gate.ps1 -skill "caminho\para\skill.md"

# 2. Se APROVADO — instalar
# (Write tool em .claude/skills/[cliente]-v[N].md — requer .musculo_autorizacao.flag)

# 3. Atualizar WIP_BOARD
# loop_fase_atual.notebooklm = "OK"
.\scripts\atualizar_wip_board_txt.ps1

# 4. Marcar PENDENTES
```

---

### A6 — WIP_BOARD modificado

```powershell
# Sempre junto:
.\scripts\atualizar_wip_board_txt.ps1

# Cópias obrigatórias para clientes ativos:
cp "CLIENTES\WIP_BOARD.md" "CLIENTES\INGRID\NOTEBOOKLM_FONTES\07_WIP_BOARD.md"
cp "CLIENTES\WIP_BOARD.txt" "CLIENTES\INGRID\NOTEBOOKLM_FONTES\07_WIP_BOARD.txt"
cp "CLIENTES\WIP_BOARD.md" "CLIENTES\VALDECE\NOTEBOOKLM_FONTES\07_WIP_BOARD.md"
cp "CLIENTES\WIP_BOARD.txt" "CLIENTES\VALDECE\NOTEBOOKLM_FONTES\07_WIP_BOARD.txt"
```

---

## SEÇÃO B — ANTES DE QUALQUER GIT COMMIT

**Executar mentalmente (ou com o script abaixo) antes de `git commit`:**

```
[ ] LEDGER propagado para NOTEBOOKLM_FONTES/04 de todos os clientes
[ ] WIP_BOARD.json → WIP_BOARD.md + WIP_BOARD.txt → NOTEBOOKLM_FONTES/07
[ ] PENDENTES.md com [x] corretos — commits têm [RESOLVE:]?
[ ] MEMORIA_EMBAIXADOR do cliente ativo atualizada (P-032)
[ ] Slots 10/11/12/14 atualizados em NOTEBOOKLM_FONTES do cliente ativo
[ ] n8n JSONs locais refletem o que está ativo no EasyPanel
[ ] VANGUARD_TIMELINE.md atualizado se houve marco
[ ] CLAUDE.md atualizado se processo mudou
[ ] vanguard-protocolo.md atualizado se processo mudou
[ ] NENHUMA credencial no código — N8N Easypanel.txt em .gitignore
[ ] .musculo_autorizacao.flag consumido ou deletado
```

---

## SEÇÃO C — FLUXO DO LOOP COM N8N (REFERÊNCIA RÁPIDA)

```
PASSO 3 → gemini_anchor_generator.ps1 → PASSO3_GEMINI.md (Write, não chat)
           Recebe DIRETRIZ → salvar como 12_DIRETRIZ_GEMINI_V[N].txt
           W-3 notifica automaticamente ao fazer git push

PASSO 5 → preparar_notebooklm_projeto.ps1 -cliente [NOME]
           Wipe & Sync no NotebookLM → colar PASSO5
           Recebe SKILL → skill_parser_gate.ps1 → instalar em .claude/skills/
           WIP_BOARD: notebooklm = "OK" → atualizar_wip_board_txt.ps1

PASSO 7 → ir_ao_embaixador.ps1 -cliente [NOME]
           MEMORIA_EMBAIXADOR.md atualizada (P-032)

PASSO 9 → DELIBERACAO (P-037) + MEMORIA + relatorio
           WIP_BOARD: musculo = "OK" → Trigger A3 cascata completa
           session_close.ps1 (ordem do Diretor) → W-4 webhook
           WIPE & SYNC NotebookLM para próximo loop

VEREDITOS → W-7: /aprovar /rejeitar /veredito via Telegram
             Notion registra → Músculo lê → executar_vereditos.ps1
```

---

## SEÇÃO D — COMO USAR O AUDITOR SISTÊMICO (PASSO5 NOVO)

Quando for fazer sessão de auditoria da Vanguard como empresa (não de cliente):

1. Abrir NotebookLM em sessão separada (sem fontes de cliente)
2. Carregar nesta ordem:
   - `01_SKILL_PROTOCOLO_VANGUARD.md`
   - `04_INTELLIGENCE_LEDGER.md`
   - `05_PROCESSO_EVOLUTIVO_PENTALATERAL.md`
   - `07_WIP_BOARD.md`
   - `15_MAPA_SISTEMA_OPERACIONAL.md`
   - `16_VANGUARD_TIMELINE.md` (ou `17_`)
3. Colar: `PASSO5_AUDITOR_SISTEMA_VANGUARD.md` como texto
4. Receber: `pentalateral-atualizacao-v2.md`
5. Instalar com `.musculo_autorizacao.flag` + Write em `.claude/skills/`

---

## SEÇÃO E — REGRAS DE SEGURANÇA (PERMANENTES)

```
HV-1: NUNCA credencial no código → hv1_credential_guard.ps1 bloqueia
P-061: API keys nunca no frontend
P-098: .musculo_autorizacao.flag obrigatório para editar .claude/skills/*.md
P-109: Notion = OUTPUT ONLY — git é a fonte de verdade
P-110: Todo workflow n8n tem fallback ≤3 passos documentado
P-033: sync_vanguard_docs.ps1 após qualquer mudança em PENTALATERAL_UNIVERSAL/
P-059: Isolamento de contexto — nunca misturar clientes em NOTEBOOKLM_FONTES
P-087: [RESOLVE:] obrigatório em commit que fecha PENDENTES
```

---

*Versão: 1.0 · 2026-06-05 · Pentalateral IAH*
*Próxima atualização: quando W-5/W-6 entrarem em produção*
