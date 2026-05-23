# PENDENTES — Vanguard IAH
> Atualizado pelo Músculo em tempo real durante qualquer sessão.
> O briefing matinal lê este arquivo — tudo aqui aparece às 7h.
> Regra P-047: qualquer tarefa identificada como pendente → registrar aqui IMEDIATAMENTE.
> Feito? Marcar [x]. Músculo remove os [x] ao fechar sessão.

---

## PROJ-001 · Valdece (Deadline: 23/05 Sab)

- [x] `2026-05-21` **Dia 6 — V3 SEQUÊNCIA COMPLETA:** ✅ ENTREGUE
  1. ~~Criar `sql/v3_migration.sql`~~ ✅
  2. ~~Atualizar `ingest.py` com `--mode reingest`~~ ✅
  3. ~~Dry-run validado — 61/61, 0 erros, 0 custo~~ ✅
  4. ~~Migração Supabase Vanguard (uslkhnselzmbbnupmfsp) — 61 docs~~ ✅
  5. ~~search_documents() V3 aplicada~~ ✅
  6. ~~Frontend: badges PLENO/COLEGIADA + ABNT data_dje~~ ✅
  7. ~~Deploy Netlify — toga-digital-valdece.netlify.app~~ ✅ VALIDADO

- [ ] `2026-05-21` **V3 ENRICHMENT — campos turma/repercussao_geral vazios:**
  APIs STF/STJ inacessíveis por DNS nesta sessão. Rodar quando rede disponível:
  `python ingest.py --mode reingest` — popula turma + repercussao_geral + recurso_repetitivo + data_dje nos 61 acórdãos.
  Badges PLENO/COLEGIADA só aparecem após este passo.

- [x] `2026-05-23` ~~**MEMORIA_EMBAIXADOR Valdece** — campo "Estado Contratual" corrigido para "ASSINADO — 2026-05-19"~~ ✅

- [x] `2026-05-21` **Billing Gemini** — resolvido: chave Valdece substituída pela chave Vanguard (Eduardo)

---

## PROJ-002 · Ingrid (Deadline: 30/05 Sab)

- [ ] `2026-05-23` **⚠️ P-045 BLOQUEANTE — ingrid-v3.md NUNCA GERADA:**
  Loop 4 não pode começar sem artefatos de fechamento do Loop 3.
  Sequência: MEMORIA_V3_INGRID existe ✅ → gerar ingrid-v3.md no NotebookLM → só então Loop 4.
  Rodar: `preparar_notebooklm_projeto.ps1 -cliente INGRID` → NotebookLM → skill nomeada ingrid-v3.

- [ ] `2026-05-20` **Dias 12-13:**
  1. Contador de Pontos Ponderados (header ou dashboard)
  2. Notificações Push — domingo = Micro-Simulado Sedes-DF

- [ ] `2026-05-20` **Loop 4** — após ingrid-v3.md gerada + Dias 12-13: ir ao Gemini com PASSO3 → DIRETRIZ V4 → NotebookLM → ingrid-v4.md → Músculo executa skill

---

## PROCESSO / INFRA

- [x] `2026-05-23` ~~**P-047 no INTELLIGENCE_LEDGER**~~ — princípio já registrado como P-048 no LEDGER. Numeração inconsistente detectada mas não corrigida para evitar cascata de renumeração. ✅

---

## SESSÃO 2026-05-23 — EXPANSÃO DE PAPÉIS PENTALATERAL

- [x] `2026-05-23` **Expansão de papéis — ENTRA AGORA:** todos os itens aprovados executados ✅
  - COMANDO_ESTRATEGISTA_MASTER_v1.md criado
  - P-052 e P-053 no LEDGER
  - PASSO3/5/6/7 templates atualizados (v2.3 / v2.2 / v4.1 / v1.1)
  - SKILL_PROTOCOLO_VANGUARD v6.1 (12 novas deficiências)
  - MANUAL_DIRETOR v1.3 (PARTE 0.6 — tabela definitiva de documentos)
  - MANIFESTO_DE_FONTES_TEMPLATE + REGISTRO_DE_PREMISSAS_TEMPLATE criados
  - MANIFESTO_DE_FONTES.md e REGISTRO_DE_PREMISSAS.md para Valdece e Ingrid
  - session_close.ps1 com CANDIDATOS_A_PRINCIPIO
  - ATUALIZACAO_PENTALATERAL_2026-05-23.md para os sócios
  - MEMORIA_EMBAIXADOR Valdece corrigida

- [x] `2026-05-23` ~~**Sync universal obrigatório**~~ — `sync_vanguard_docs.ps1` executado: INTEGRIDADE VERDE, 0 falhas de hash ✅

- [x] `2026-05-23` ~~**Rename QUADRILATERAL → PENTALATERAL**~~ — veredito formal do Diretor dado, executado: 234 arquivos via `git mv`, todos os scripts/hooks/skills/docs atualizados ✅

- [x] `2026-05-23` ~~**Varredura total + VANGUARD_TIMELINE**~~ — CONSTITUICAO atualizada (MEMORANDO v2.3), NOTEBOOKLM_BASE sincronizado, TIMELINE com marcos 2026-05-23, tabela de membros v6.1 ✅

---

## PRÓXIMA SESSÃO — OBRIGATÓRIOS PÓS-EXPANSÃO PENTALATERAL

- [ ] `2026-05-23` **Distribuir ATUALIZACAO_PENTALATERAL_2026-05-23.md aos sócios:**
  Colar no chat de cada parceiro ao iniciar próxima sessão:
  1. Gemini (Estrategista) — colar no início do PASSO3
  2. NotebookLM (Auditor) — colar junto ao PASSO5
  3. Embaixador (Claude Projects) — colar via ir_ao_embaixador.ps1
  Arquivo: `PENTALATERAL_UNIVERSAL/OPERACAO/ATUALIZACAO_PENTALATERAL_2026-05-23.md`

- [ ] `2026-05-23` **NotebookLM Wipe & Sync — AMBOS os projetos:**
  Rename massivo alterou nomes de fontes. Executar antes da próxima sessão NotebookLM:
  - `.\scripts\preparar_notebooklm_projeto.ps1 -cliente VALDECE` → Wipe & Sync no NotebookLM
  - `.\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID` → Wipe & Sync no NotebookLM

- [ ] `2026-05-23` **MEMORIA_EMBAIXADOR Ingrid — atualizar:**
  Não atualizada nesta sessão (apenas Valdece foi corrigida).
  Atualizar: hipóteses confirmadas/refutadas desta sessão + temperatura atual + próxima ação do Embaixador.
  Arquivo: `CLIENTES/INGRID/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md`

- [ ] `2026-05-23` **REGISTRO_DE_PREMISSAS — registrar premissas desta sessão:**
  Premissas silenciosas desta sessão que precisam ser declaradas:
  - Rename QUADRILATERAL → PENTALATERAL não altera funcionalidade, apenas nomenclatura
  - 12 deficiências formalizadas são reais — não hipotéticas
  Atualizar: `CLIENTES/VALDECE/REGISTRO_DE_PREMISSAS.md` e `CLIENTES/INGRID/REGISTRO_DE_PREMISSAS.md`

- [ ] `2026-05-23` **CANDIDATOS_A_PRINCIPIO — capturar via session_close.ps1:**
  Esta sessão gerou pelo menos 1 candidato a princípio não formalizado:
  "Rename massivo de pasta exige Wipe & Sync imediato em todos os projetos ativos do NotebookLM."
  Rodar: `.\scripts\session_close.ps1` → bloco CANDIDATOS_A_PRINCIPIO

- [ ] `2026-05-23` **COMANDO_ESTRATEGISTA_MASTER — atualizar BLOCO 1 (estado atual):**
  O estado pós-expansão não está refletido no BLOCO 1 do MASTER.
  Atualizar: versão SKILL_PROTOCOLO (v6.1), 25 ideias/ciclo, 12 novas deficiências, P-052/P-053.
  Arquivo: `PENTALATERAL_UNIVERSAL/OPERACAO/COMANDO_ESTRATEGISTA_MASTER_v1.md`

---

## COMO USAR

**Adicionar pendente (Músculo):**
```
- [ ] `YYYY-MM-DD` **[PROJ/PROCESSO]** descrição exata da tarefa
```

**Marcar feito:**
```
- [x] `YYYY-MM-DD` ~~descrição~~
```

**Remover concluídos:** Músculo limpa os `[x]` ao rodar `session_close.ps1`.
