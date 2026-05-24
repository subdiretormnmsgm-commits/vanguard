# ROTEIRO LOOP 5 — INGRID · PENTALATERAL IAH
> Referência rápida para Eduardo. Loop 5 · Dias 12-13. Salvo em 2026-05-24.
> Estado: Dias 12 concluídos. Aguardando: Gemini (ainda não foi) + NotebookLM + Embaixador.

---

## PROCESSO UNIVERSAL DO LOOP

```
PASSO 2 → Músculo prepara (antes de qualquer sócio)
  Roda  : gemini_anchor_generator.ps1 -cliente INGRID
           → CONTEXTO_GEMINI.md (LEDGER + WIP + MEMORIA consolidados)
  Prepara: PASSO3_GEMINI.md orientado pelo Diretor
  Gate  : P-045 — MEMORIA_V[N-1] + relatorio_V[N-1] existem?
           Se não → BLOQUEIO: fechar loop técnico antes de ir ao Gemini

PASSO 3 → Gemini
  Leva  : COMANDO_ESTRATEGISTA_MASTER_v1.md + PASSO3_GEMINI.md (colados)
           + MEMORIA + relatorio + INTELLIGENCE_LEDGER + WIP_BOARD (anexados)
  Recebe: Diretriz Técnica [VN] — Projeto [X] — Loop [N]
  Salva : NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V[N].txt

PASSO 5 → NotebookLM
  Roda  : preparar_notebooklm_projeto.ps1 -cliente INGRID
  Leva  : NOTEBOOKLM_FONTES/ completo (Wipe & Sync) + COMANDO CURTO
  Recebe: Skill ingrid-v[N].md (4 partes + [N-1 a N-5])
  Salva : .claude/skills/ingrid-v[N].md
  Valida: skill_parser_gate.ps1

PASSO 6 → Embaixador (Claude Projects)
  Roda  : ir_ao_embaixador.ps1 -cliente INGRID
  Leva  : PASSO7_EMBAIXADOR.md SEÇÃO D + [M-1 a M-5] + [G-1 a G-5] + [N-1 a N-5]
  Recebe: [E-1 a E-5] + CONFIRMA/EXPANDE/ALERTA + DECISOES_[PROJETO]_[DATA].json

PASSO 7 → Músculo + Diretor — colar nesta ordem:
  Diretor roda: render_painel.ps1 → marca vereditos → VEREDITOS.json
  Músculo roda: executar_vereditos.ps1 → clipboard/MEMORIA/LEDGER automáticos
  Músculo executa: Skill + DIRETRIZ + [E-1 a E-5] + vereditos → deliberação + plano de build
```

---

## SEQUÊNCIA ESPECÍFICA — LOOP 5 INGRID (estado atual: 2026-05-24)

```
⓪ MÚSCULO PREPARA (antes do Gemini)
  Rodar: gemini_anchor_generator.ps1 -cliente INGRID
  Verificar: MEMORIA_V4_INGRID.md existe? ✅ (P-045 liberado)
  Verificar: relatorio_evolutivo_V4_INGRID.md existe?
  Atualizar: PASSO3_GEMINI.md com orientações do Diretor

① VOCÊ ENVIA AO GEMINI
  1. Cole : COMANDO_ESTRATEGISTA_MASTER_v1.md
  2. Cole : PASSO3_GEMINI.md (Ingrid Loop 5)
  3. Anexe: MEMORIA_V4_INGRID.md
  4. Anexe: relatorio_evolutivo_V4_INGRID.md
  5. Anexe: INTELLIGENCE_LEDGER.md
  6. Anexe: WIP_BOARD.json

② GEMINI ENTREGA
  7. Salvar: DIRETRIZ V6 → NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V6.txt

③ VOCÊ ENVIA AO NOTEBOOKLM
  8. Rodar: preparar_notebooklm_projeto.ps1 -cliente INGRID
     → Wipe & Sync das fontes
     → Colar COMANDO CURTO no chat
     → Validar com skill_parser_gate.ps1

④ NOTEBOOKLM ENTREGA
  9. Salvar: ingrid-v5.md → .claude/skills/ingrid-v5.md

⑤ VOCÊ ENVIA AO EMBAIXADOR (Claude Projects)
  10. Rodar: ir_ao_embaixador.ps1 -cliente INGRID (copia mensagem + abre browser)
      Abrir: PASSO7_EMBAIXADOR.md → SEÇÃO D
      Preencher: [M-1 a M-5] do Músculo + [G-1 a G-5] do Gemini + [N-1 a N-5] do NotebookLM
      Colar bloco SEÇÃO D no chat do Claude Project da Ingrid

⑥ EMBAIXADOR ENTREGA
  11. [E-1 a E-5]: CONFIRMA / EXPANDE / ALERTA cada ideia
      Gera: DECISOES_INGRID_[DATA].json → salvar em CLAUDE_PROJECT/DECISOES/

⑦ VOCÊ RODA O PAINEL (3 minutos)
  12. .\scripts\render_painel.ps1 -projeto INGRID
      Marcar vereditos → Confirmar → Salvar VEREDITOS JSON

⑧ MÚSCULO EXECUTA
  13. .\scripts\executar_vereditos.ps1 -projeto INGRID
      → Clipboard, MEMORIA, LEDGER atualizados automaticamente
  14. Skill ingrid-v5.md + DIRETRIZ V6 + [E-1 a E-5] + vereditos → deliberação + plano de build
```

---

## STATUS ATUAL — O QUE FALTA NO LOOP 5

| Etapa | Status |
|---|---|
| Dia 12 — Contador + Socrática + Vacina + Push CB | ✅ CONCLUÍDO (commit b70ace5) |
| MEMORIA_V4_INGRID.md | ✅ EXISTE — P-045 liberado |
| Gemini (PASSO 3 Loop 5) | 🔲 PENDENTE |
| NotebookLM (PASSO 5 Loop 5) → ingrid-v5.md | 🔲 PENDENTE |
| Embaixador (SEÇÃO D Loop 5) → DECISOES JSON | 🔲 PENDENTE (Painel HTML gerado — aguarda JSON) |
| Dia 13 — Push dominical + Widget Contador | 🔲 PRÓXIMO BUILD |
| Dia 14-15 — Offboarding + SaaS Readiness Audit | 🔲 PRÓXIMO |

---

*Músculo · 2026-05-24 · Loop 5 Ingrid*
*Próxima revisão: ao fechar o Loop 5 (Gate Dia 15)*
