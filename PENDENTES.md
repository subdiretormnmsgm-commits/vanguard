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

- [x] `2026-05-26` ~~**NotebookLM Wipe & Sync — Valdece:**~~
  ✅ Confirmado pelo Diretor em 2026-05-27. (PENDENTES não foi atualizado na sessão anterior — falha do Músculo.)

---

## PROJ-002 · Ingrid (Loop 7 em andamento)

- [ ] `2026-05-30` **Ingrid — D1: Deploy CLI F-4 + F-6 (Gate 7.1):**
  Eduardo roda `! supabase login` no terminal (abre browser para auth).
  Depois: Músculo faz link + deploy `notificar-progresso` e `relatorio-semanal` no projeto Ingrid (yjqvjhezwhepwomukudt).

- [ ] `2026-05-30` **Ingrid — D2: Gate 7.2 RLS dry-run (test_tenant_isolation.ps1):**
  Definir `$env:SUPABASE_SERVICE_ROLE_KEY = 'sua-key'` no terminal.
  Depois: `.\scripts\test_tenant_isolation.ps1` — deve retornar VERDE.

- [ ] `2026-05-30` **Ingrid — D4: GitHub Security — Pages push bloqueado:**
  Eduardo segue link no e-mail do GitHub Security → revogar token sbp_ do histórico.
  Sem isto, deploy automático está comprometido.

- [ ] `2026-05-31` **Ingrid — D3: Debrief casual Ingrid (gate informal pitch):**
  Mensagem no clipboard (D3): "Ingrid! Aquela configuração que fizemos hoje ficou perfeita. Como você tá se sentindo com o estudo essa semana? 📚"
  Eduardo ajusta e envia no WhatsApp. Resultado informa se pitch R$97/mês pode avançar.

- [ ] `2026-05-31` **Ingrid — D6: Plantar semente E-4 pós-aprovação (no debrief D3):**
  Frase: "Quando você passar, você vai ser a prova que esse negócio funciona — aí a gente pensa em expandir. 😄"
  Integrar naturalmente — não como anúncio.

- [ ] `2026-06-XX` **Ingrid — D5: M-4 Link Demo BLOQUEADO até segunda usuária:**
  Com 1 usuária, anonimato é fictício. Liberar apenas quando segunda usuária ativa.
  Quando liberar: só gráficos e Heatmap — NUNCA conteúdo das questões.

- [x] `2026-05-26` ~~**NotebookLM Wipe & Sync — Ingrid:**~~
  ✅ Fontes antigas deletadas → 18 arquivos de CLIENTES/INGRID/NOTEBOOKLM_FONTES/ carregados — 2026-05-26

- [x] `2026-05-26` ~~**Ingrid — Assinatura física do Termo de Uso — RESOLVIDO:**~~
  ✅ Reassinatura física confirmada pelo Diretor em 2026-05-27. LEGAL-WATCH VERDE.

- [x] `2026-05-27` ~~**Ingrid — Termo de Uso — RESOLVIDO:**~~
  ✅ PDF 18/05/2026 enviado + reassinatura física obtida — confirmado pelo Diretor em 2026-05-27. LEGAL-WATCH VERDE.

- [x] `2026-05-26` ~~**Deploy GitHub Pages — Ingrid v19 — GATE TESTE:**~~
  ✅ Eduardo confirmou v19 funcionando no celular em 2026-05-27. Dashboard, SM-2, saudação, debug — VERDE.
  Gate desbloqueado: Músculo pode iniciar F-2 + F-4 + F-6 (backend Loop 6).

- [x] `2026-05-30` ~~**Loop 6 Ingrid — Gemini PASSO3:**~~
  ✅ DIRETRIZ V6 recebida · ingrid-v6.md instalada — confirmado pelo Diretor 2026-05-27.

- [x] `2026-05-30` ~~**Loop 6 Ingrid — Embaixador PASSO7 Seção D:**~~
  ✅ SEÇÃO D executada — Embaixador retornou TEMPERATURA 7.5/10 + [E-1 a E-5] + PAINEL — 2026-05-27

- [x] `2026-05-30` ~~**Loop 6 Ingrid — Músculo /ingrid-v6 + síntese P-037:**~~
  ✅ ingrid-v6.md lida · DELIBERACAO_LOOP_V6_INGRID.md gerado · MEMORIA_EMBAIXADOR atualizada (P-032) — 2026-05-27

- [x] `2026-05-30` ~~**Loop 6 Ingrid — Backend F-2 + F-4 + F-6 (após gate v19):**~~
  ✅ Commits 86e112b + a2b42f5 confirmam — backend completo em 2026-05-28 00:24. PENDENTES não foi atualizado na sessão anterior — falha do Músculo corrigida agora.

- [x] `2026-05-30` **Ingrid — Dia 13 (29-05-2026 sexta-feira) — Contador Pontos Ponderados + Notificação push domingo:**
  Contador Pontos Ponderados: exibir no header/dashboard a pontuação ponderada acumulada da Ingrid.
  Notificação push domingo: acionar notificação automática aos domingos para lembrar do Micro-Simulado.
  Referência: plano_build dia12_13 do WIP_BOARD + skill ingrid-v6.md.

- [x] `2026-05-27` ~~**Loop 6 Ingrid — PAINEL DE DELIBERAÇÃO:**~~
  ✅ P0-A (DADOS-WATCH VERDE: 102 respostas migradas) · P1-A (aguardar até 31/05) · PRINCIPIO-A (P-079 inscrito) · D3_VANGUARD-A (registrado) — 2026-05-27

---

## PROCESSO / INFRA

- [x] `2026-05-27` ~~**[BLOQUEANTE] ChurnWatch_Vanguard NAO registrado no Task Scheduler:**~~
  ✅ Registrado pelo Músculo em 2026-05-27 (sem Admin necessário). Próxima execução: 28-05-2026 08:00.

- [x] `2026-05-27` ~~**C4 — Watchers EncodedCommand — VERDE:**~~
  ✅ decisoes_watcher.log: OK (20:30). skill_watcher: OK (teste manual 20:46). EncodedCommand funciona com path acentuado.

- [x] `2026-05-27` ~~**Confirmar detect_canonical_violation.ps1 funcionando:**~~
  ✅ PASSO 0c validado em 2026-05-27: violação injetada em NOTEBOOKLM_FONTES/INGRID → VERMELHO exit 1 detectado. Restaurado → VERDE exit 0. NOTEBOOKLM_BASE sync corrigido.

- [x] `2026-05-26` ~~**PROTOCOLO_ONBOARDING_INVISÍVEL.md — decidir destino:**~~
  ✅ Veredito do Diretor em 2026-05-27: ENTRA AGORA. Movido para PENTALATERAL_UNIVERSAL/OPERACAO/. P-085 inscrito no LEDGER.

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

- [CLAUDE_PROJECTS (30-05-2026 sábado)] INGRID -- upload: MEMORIA_EMBAIXADOR.md

- [P-032 (30-05-2026 sábado)] INGRID -- Atualizar MEMORIA_EMBAIXADOR apos deliberacao
