# PENDENTES — Vanguard IAH
> Atualizado pelo Músculo em tempo real durante qualquer sessão.
> O briefing matinal lê este arquivo — tudo aqui aparece às 7h.
> Regra P-047: qualquer tarefa identificada como pendente → registrar aqui IMEDIATAMENTE.
> Feito? Marcar [x]. Músculo remove os [x] ao fechar sessão.

---

## 🔴 ALERTAS CRÍTICOS — AÇÃO IMEDIATA DO DIRETOR

- [ ] `2026-05-26` **🔴 TOKEN SUPABASE EXPOSTO — deletar HOJE:**
  O token `REVOKED_TOKEN` foi exposto em sessão anterior.
  **AÇÃO:** Acessar supabase.com/dashboard/account/tokens → encontrar token → deletar.
  Enquanto não deletado, qualquer pessoa com acesso ao histórico pode usar o token.

---

## PROJ-001 · Valdece (Hypercare até 18/06/2026)

- [ ] `2026-06-02` **Sentinel Report (02-06-2026 terça-feira) — Hypercare Valdece:**
  Relatório de Hypercare para Valdece. Template em CLIENTES/VALDECE/CLAUDE_PROJECT/PASSO7_EMBAIXADOR.md.
  Músculo gera PASSO7-C (debrief) antes do Sentinel.

- [ ] `2026-05-26` **NotebookLM Wipe & Sync — Valdece:**
  Arquivos 02, 07, 08, 16, 17, 18 atualizados com P-059 compliance.
  **AÇÃO DO DIRETOR:** NotebookLM Valdece → deletar todas as fontes → arrastar CLIENTES/VALDECE/NOTEBOOKLM_FONTES/ (18 arquivos).

---

## PROJ-002 · Ingrid (Loop 6 em andamento)

- [x] `2026-05-26` ~~**NotebookLM Wipe & Sync — Ingrid:**~~
  ✅ Fontes antigas deletadas → 18 arquivos de CLIENTES/INGRID/NOTEBOOKLM_FONTES/ carregados — 2026-05-26

- [ ] `2026-05-26` **Ingrid — Assinatura física do Termo de Uso:**
  Termo enviado via WhatsApp 2026-05-26 (LEGAL-WATCH PARCIAL). Assinatura física ainda pendente.
  **AÇÃO DO DIRETOR:** Confirmar recebimento físico + data de assinatura com Ingrid.

- [ ] `2026-05-26` **Deploy GitHub Pages — Ingrid v18 (Dia 15 concluído):**
  v18 funcional em produção com Edge Functions + Supabase yjqvjhezwhepwomukudt.
  **GATE:** Eduardo testa localmente antes → aprovação → `.\scripts\deploy_ingrid_ghpages.ps1`
  Músculo não executa deploy sem gate de teste explícito.

- [ ] `2026-05-30` **Loop 6 Ingrid — Ir ao Gemini (Passo 3):**
  **Deadline do projeto: 30/05/2026 (sábado).**
  Arquivos a anexar: MEMORIA_V5_INGRID.md + relatorio_evolutivo_V5_INGRID.md + INTELLIGENCE_LEDGER.md + WIP_BOARD.json
  Texto a colar: CLIENTES/INGRID/CLAUDE_PROJECT/PASSO3_GEMINI.md (atualizado)
  Músculo gera PASSO3 atualizado antes de Eduardo ir ao Gemini.

---

## PROCESSO / INFRA

- [ ] `2026-05-27` **Confirmar Task Scheduler CHURN-WATCH registrado:**
  Rodar `session_start.ps1` como Administrador uma vez para registrar a Task `ChurnWatch_Vanguard` (08:00 diário).
  Ou testar manualmente: `.\scripts\churn_watch_autonomo.ps1 -simular`

- [ ] `2026-05-27` **Confirmar detect_canonical_violation.ps1 funcionando:**
  Testar PASSO 0c: simular edição em cópia de projeto e confirmar BLOQUEIO.

- [ ] `2026-05-26` **PROTOCOLO_ONBOARDING_INVISÍVEL.md — decidir destino:**
  Arquivo untracked na raiz. Commitar em PENTALATERAL_UNIVERSAL/OPERACAO/ ou descartar?
  **AÇÃO DO DIRETOR:** veredito de onde colocar ou se descarta.

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
