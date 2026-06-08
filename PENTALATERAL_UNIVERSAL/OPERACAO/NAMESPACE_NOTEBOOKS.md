# NAMESPACE DE NOTEBOOKS — MODELO HÍBRIDO PENTALATERAL (P-123)
> Origem: P-123 inscrito em 2026-06-07 — aprovado pelo Diretor
> Aplica-se a: todo projeto com NotebookLM ativo

---

## REGRA FUNDAMENTAL

Todo cliente tem DOIS notebooks no NotebookLM. Nunca um, nunca três.

---

## NAMESPACE BASE — Permanente

**Nome obrigatório:** `[YYYY-MM] [NOME_CLIENTE]-base`
**Exemplo:** `2026-06 VALDECE-base`

**O que contém:**
- LEDGER (04_INTELLIGENCE_LEDGER.md)
- Documentos universais do Pentalateral (01-08 do NOTEBOOKLM_FONTES/)
- SKILL_PROTOCOLO_VANGUARD
- MEMORIA_EMBAIXADOR do cliente
- Histórico de deliberações (DELIBERACAO_LOOP_*)

**Regras:**
- NUNCA recebe documentos de loop efêmero (PASSO5, docs do ciclo atual)
- NUNCA recebe dados do cliente (acórdãos, planilhas, dados sensíveis) — P-059
- Sincronizado via `preparar_notebooklm_projeto.ps1` — nunca editado manualmente
- Sobrevive entre loops — é a memória institucional do projeto

---

## NAMESPACE LOOP — Efêmero

**Nome obrigatório:** `[YYYY-MM] [NOME_CLIENTE]-loop-N`
**Exemplo:** `2026-06 VALDECE-loop-8`

**O que contém:**
- PASSO5_NOTEBOOKLM.md do ciclo atual
- Documentos específicos do loop (fontes 09-17 do NOTEBOOKLM_FONTES/)
- Skill anterior (referência de evolução)
- Output do Gemini (DIRETRIZ_GEMINI_V[N])

**Regras:**
- DESTRUÍDO após skill extraída e aprovada pelo `skill_parser_gate.ps1`
- Studio outputs (Audio Overview, Infografico) pertencem a este namespace — descartados com ele
- A skill gerada (`.claude/skills/[cliente]-v[N].md`) é o ÚNICO artefato que sobrevive
- Wipe & Sync obrigatório ao iniciar cada novo loop

---

## FLUXO POR LOOP

```
INÍCIO DO LOOP N:
  1. Criar [cliente]-loop-N (ou Wipe & Sync se já existe)
  2. preparar_notebooklm_projeto.ps1 popula NOTEBOOKLM_FONTES/
  3. Add Sources em [cliente]-loop-N (fontes 09-17)

DURANTE O LOOP:
  4. Chat no [cliente]-loop-N → gera Skill [cliente]-vN
  5. skill_parser_gate.ps1 valida → APROVADO
  6. Salvar .claude/skills/[cliente]-vN.md

ENCERRAMENTO DO LOOP N:
  7. Arquivar ou destruir [cliente]-loop-N
  8. Atualizar [cliente]-base com novos artefatos permanentes
  9. Wipe & Sync de [cliente]-base com fontes atualizadas
```

---

## ISOLAMENTO DE CONTEXTO (P-059 + P-123)

| O que NUNCA acontece | Por quê |
|---|---|
| LEDGER no namespace loop | Contamina dados sensíveis com inteligência interna |
| Dados de cliente no namespace base | Viola isolamento entre projetos — risco de cruzamento |
| Studio outputs persistidos além do loop | São efêmeros por design — valor está na skill gerada |
| Um único notebook para tudo | Impossível garantir isolamento sem namespace separado |

---

## VERIFICAÇÃO AUTOMÁTICA

`auditar_consistencia.ps1` (Gate 0) verifica ao iniciar sessão:
- Existe [cliente]-base no WIP_BOARD? → se não → alerta
- Existe [cliente]-loop-N ativo? → se não e loop em curso → alerta
- Skill do loop anterior existe em disco? → se não → P-045 bloqueio
