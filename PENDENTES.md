# PENDENTES — Vanguard IAH
> Atualizado pelo Músculo em tempo real durante qualquer sessão.
> O briefing matinal lê este arquivo — tudo aqui aparece às 7h.
> Regra P-047: qualquer tarefa identificada como pendente → registrar aqui IMEDIATAMENTE.
> Feito? Marcar [x]. Músculo remove os [x] ao fechar sessão.

---

## PROJ-001 · Valdece (Deadline: Hypercare até 18/06)

- [x] `2026-05-21` ~~**V3 ENRICHMENT — campos turma/repercussao_geral vazios:**~~
  ✅ reingest aplicado 2026-05-25 — 61/61 atualizados · 0 erros
  ✅ fix classify_v3_fields: RE/ARE STF → repercussao_geral=True (EC 45/2004)
  ✅ gate_v3 --check pos APROVADO: vinculantes=3 · pleno=5 · turma=56
  ✅ view_diretor_roi validada no Supabase: total_acordaos=61 · vinculantes=3

- [x] `2026-05-24` ~~**Embaixador Valdece — ativar com nova sistemática:**~~
  ✅ Embaixador ativado — LOG_002 processado — blocos A–H completos
  ✅ DECISOES_VALDECE_2026-05-24.json → VEREDITOS_VALDECE_2026-05-24.json → executar_vereditos.ps1 (automático)
  ✅ D1 clipboard · D3 scope-watch · D5 P-065 LEDGER · D6 pipeline OAB
  ✅ MEMORIA_EMBAIXADOR atualizada (Loop 7 · Score 6.5 · Hypercare ativo)
  ✅ WIP_BOARD: notebooklm=OK · embaixador=OK

- [x] `2026-05-25` ~~**Deploy Netlify — ativar V3 em produção:**~~
  ✅ deploy em 11s — toga-digital-valdece.netlify.app — 2026-05-25
  ✅ Proxy embed: 200 OK · vetor 3072 dimensões · GEMINI_API_KEY server-side
  ✅ GEMINI_API_KEY já estava configurada (Builds + Functions + Runtime)

- [ ] `2026-05-24` **Sentinel Report — gerar em 2026-06-02:**
  Relatório de Hypercare para Valdece. Template em CLIENTES/VALDECE/CLAUDE_PROJECT/PASSO7_EMBAIXADOR.md.

---

## PROJ-002 · Ingrid (Deadline: 30/05 Sab — 6 dias)

- [x] `2026-05-25 Dom` ~~**Embaixador Ingrid — ativar com nova sistemática:**~~
  ✅ SEÇÃO D executada em 2026-05-27 — 15 inputs reais [M+G+N] processados
  ✅ Painel D1-D5 gerado pelo Embaixador
  ✅ Vereditos do Diretor: D1:A D2:A D3:A D4:A D5:A
  ✅ MEMORIA_EMBAIXADOR atualizada (P-032) · P-067 + P-068 registrados no LEDGER

- [x] `2026-05-25 Dom` ~~**Loop 5 — Gemini (PASSO 3):**~~
  ✅ DIRETRIZ V6 gerada — salva em CLIENTES/INGRID/NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V6.txt (2026-05-25)

- [x] `2026-05-26 Seg` ~~**Loop 5 — NotebookLM (PASSO 5) → ingrid-v5.md:**~~
  ✅ DIRETRIZ V6 recuperada do git e salva em CLIENTES/INGRID/DIRETRIZ_GEMINI_V6.txt
  ✅ PASSO5_NOTEBOOKLM.md atualizado para Loop 5 com bloqueio Embaixador (P-067)
  ✅ Template universal PASSO5_NOTEBOOKLM_TEMPLATE.md atualizado com P-067
  ✅ skill_parser_gate.ps1 atualizado: gate automático Embaixador pós-APROVADO
  ✅ ingrid-v5.md gerada pelo Auditor + headers corrigidos → APROVADO no gate

- [x] `2026-05-27 Ter` ~~**Loop 5 — Embaixador (SEÇÃO D) → DECISOES inline:**~~
  ✅ Vereditos executados: D1:A D2:A D3:A D4:A D5:A
  ✅ P-037 síntese completa (25 ideias analisadas)
  ✅ P-067 + P-068 registrados no LEDGER

- [x] `2026-05-23 Sex` ~~**Dia 13 — Push dominical + Widget Contador:**~~
  ✅ Widget Contador: pontosBase (Supabase) + pontosAcumulados (sessão) no header
  ✅ Push dominical: banner slideDown + Notification API (iOS excluído via isIosSafari())
  ✅ Versão v14 — deploy GitHub Pages — smoke test 5/5 PASSOU
  ⏳ Gate: Ingrid testa e aprova antes de avançar para Dia 14

- [ ] `2026-05-27 Ter` **[AÇÃO IMEDIATA] D1:A — WhatsApp + novo PDF para Ingrid:**
  Eduardo envia: "Corrigi uma data no documento, precisa assinar rapidinho de novo 😊"
  Músculo gera PDF template com data 18/05/2026 → Eduardo imprime/assina digitalmente
  ⚠️ Fazer ANTES do Dia 14 para destravar o offboarding

- [ ] `2026-05-27 Ter` **[AÇÃO IMEDIATA] D4:A — Plantar lead na próxima mensagem:**
  Na próxima mensagem a Ingrid (qualquer assunto): "Você conhece mais alguém prestando concurso esse ano?"
  Simples, casual, sem pitch

- [ ] `2026-05-27 Ter` **[VALIDAR] D5:A — Confirmar corte histórico Quadrix SEDES:**
  Músculo: query nos dados históricos Quadrix para confirmar se 72 pts é o corte real
  Se confirmado → Linha de Corte Fantasma entra no build Dia 14

- [ ] `2026-05-28 Qui` **Dia 14 — Build Loop 5 + Offboarding + SaaS Readiness Audit:**
  Ordem de build (5-6h total):
  1. N-4 Rótulo SM-2 (15min) — tag [Simulado de Fixação] no domingo
  2. N-3 Linha de Corte configurável (45min) — campo no DASHBOARD interno + linha na UI de Ingrid
     D5:B: Eduardo define o número (ex: 72) no dashboard; Ingrid vê a linha na tela
  3. N-1 Push adaptativo Mágico de Oz (1h) — query horario_inicio_sessao + mensagem WhatsApp pré-formatada
  4. N-5 html2canvas export (3-4h) — card SVG no cliente, sem backend; unifica M-2+G-4+N-5
  5. M-5 protocolo manual (sem build) — instrução para Eduardo enviar relatório semanal
  ⚠️ D1:A (WhatsApp + PDF 18/05) deve estar resolvido ANTES deste dia

- [ ] `2026-05-29 Sex` **Dia 15 — P-013 Soberania + gate admin Supabase:**
  Gate bloqueante: Ingrid com acesso admin ao próprio Supabase
  Deadline: 2026-05-30 Sab (1 dia de margem)

---

## ALERTAS CRÍTICOS DOS AUDITORES — 2026-05-24

- [x] `2026-05-24` ~~**🔴 RLS + Chave API exposta no frontend (Auditor Valdece):**~~
  ✅ GEMINI_KEY removida do frontend (era o real problema — não a anon key Supabase)
  ✅ Proxy criado: `CLIENTES/VALDECE/netlify/functions/embed.js`
  ✅ `netlify.toml` criado com config de functions + headers
  ✅ Frontend atualizado: `embedQuery()` agora chama `/.netlify/functions/embed`
  ✅ P-061 registrado no LEDGER
  ⏳ AÇÃO DO DIRETOR: Netlify Dashboard → Site Settings → Environment Variables → adicionar `GEMINI_API_KEY`
  ⏳ AÇÃO DO DIRETOR: git commit + `netlify deploy` para ativar o proxy em produção

- [x] `2026-05-24` ~~**🔴 CANDIDATO_A_PRINCIPIO — Fuga do MRR pela Burocracia:**~~
  ✅ Registrado como P-062 no INTELLIGENCE_LEDGER.md

---

## PROCESSO / INFRA

- [x] `2026-05-24` ~~**Distribuir ATUALIZACAO_PENTALATERAL_2026-05-24.md aos sócios:**~~
  ✅ Gemini: ATUALIZACAO já prepended no CONTEXTO_GEMINI.md (clipboard pronto — Ctrl+V)
  ✅ NotebookLM: incluir junto ao PASSO5 (Eduardo cola junto ao PASSO5 quando for ao NotebookLM)
  ✅ Embaixador: ir_ao_embaixador.ps1 já sincroniza os docs do CLAUDE_PROJECT

- [x] `2026-05-24` ~~**Task Scheduler — monitor_hypercare.ps1 (7h diário):**~~
  ✅ Tarefa `Vanguard_Monitor_Hypercare_7h` registrada no Windows Task Scheduler
  ✅ Gatilho: segunda a sexta às 07:00 — Estado: Ready

- [x] `2026-05-23` ~~**NotebookLM Wipe & Sync — Músculo preparou fontes (scripts rodados):**~~
  ✅ `preparar_notebooklm_projeto.ps1 -cliente VALDECE` — 18 docs prontos
  ✅ `preparar_notebooklm_projeto.ps1 -cliente INGRID` — 18 docs prontos
  ⏳ AÇÃO DO DIRETOR: ir ao NotebookLM → Wipe & Sync das fontes (arrastar os arquivos)

- [x] `2026-05-23` ~~**REGISTRO_DE_PREMISSAS — registrado (sessão 2026-05-24):**~~
  ✅ CLIENTES/VALDECE/REGISTRO_DE_PREMISSAS.md — premissas 6, 7, 8 adicionadas
  ✅ CLIENTES/INGRID/REGISTRO_DE_PREMISSAS.md — premissas 7, 8 adicionadas

- [x] `2026-05-24` ~~**scripts/deploy_ingrid_ghpages.ps1 — JÁ EXISTE (P-056 resolvido):**~~
  ✅ Script completo em `scripts/deploy_ingrid_ghpages.ps1` — criado na sessão anterior

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
