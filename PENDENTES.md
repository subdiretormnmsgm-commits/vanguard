# PENDENTES — Vanguard IAH
> Atualizado pelo Músculo em tempo real durante qualquer sessão.
> O briefing matinal lê este arquivo — tudo aqui aparece às 7h.
> Regra P-047: qualquer tarefa identificada como pendente → registrar aqui IMEDIATAMENTE.
> Feito? Marcar [x]. Músculo remove os [x] ao fechar sessão.

---

## 🔴 ALERTAS CRÍTICOS — AÇÃO IMEDIATA DO DIRETOR

- [x] `2026-05-26` ~~**TOKEN SUPABASE EXPOSTO — RESOLVIDO:**~~
  ✅ Token revogado no dashboard Supabase — confirmado pelo Diretor em 2026-05-27. Arquivos redatados.

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

- [x] `2026-05-26` ~~**Ingrid — Assinatura física do Termo de Uso — RESOLVIDO:**~~
  ✅ Reassinatura física confirmada pelo Diretor em 2026-05-27. LEGAL-WATCH VERDE.

- [x] `2026-05-27` ~~**Ingrid — Termo de Uso — RESOLVIDO:**~~
  ✅ PDF 18/05/2026 enviado + reassinatura física obtida — confirmado pelo Diretor em 2026-05-27. LEGAL-WATCH VERDE.

- [ ] `2026-05-26` **Deploy GitHub Pages — Ingrid v18 (Dia 15 concluído):**
  v18 funcional em produção com Edge Functions + Supabase yjqvjhezwhepwomukudt.
  **GATE:** Eduardo testa localmente antes → aprovação → `.\scripts\deploy_ingrid_ghpages.ps1`
  Músculo não executa deploy sem gate de teste explícito.

- [x] `2026-05-30` ~~**Loop 6 Ingrid — Gemini PASSO3:**~~
  ✅ DIRETRIZ V6 recebida · ingrid-v6.md instalada — confirmado pelo Diretor 2026-05-27.

- [ ] `2026-05-30` **Loop 6 Ingrid — Embaixador PASSO7 Seção D (PRÓXIMO PASSO):**
  Gemini + NotebookLM concluídos. Próximo: levar ao Embaixador para filtro de realidade.
  **AÇÃO DO MÚSCULO:** Gerar PASSO7_EMBAIXADOR Seção D com [G-1 a G-5] da DIRETRIZ V6 + contexto Loop 6.
  **AÇÃO DO DIRETOR:** Colar no Claude Project da Ingrid e aguardar [E-1 a E-5].

- [ ] `2026-05-30` **Loop 6 Ingrid — Músculo /ingrid-v6 + síntese P-037:**
  Após Embaixador retornar [E-1 a E-5] → Músculo executa /ingrid-v6 + deliberação + DECISOES.json.
  **GATE P-067:** Embaixador precede o Músculo. Sem [E-1 a E-5] → bloqueio.

---

## PROCESSO / INFRA

- [x] `2026-05-27` ~~**[BLOQUEANTE] ChurnWatch_Vanguard NAO registrado no Task Scheduler:**~~
  ✅ Registrado pelo Músculo em 2026-05-27 (sem Admin necessário). Próxima execução: 28-05-2026 08:00.

- [x] `2026-05-27` ~~**C4 — Watchers EncodedCommand — VERDE:**~~
  ✅ decisoes_watcher.log: OK (20:30). skill_watcher: OK (teste manual 20:46). EncodedCommand funciona com path acentuado.

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
