# PENDENTES — Vanguard IAH
> Atualizado pelo Músculo em tempo real durante qualquer sessão.
> O briefing matinal lê este arquivo — tudo aqui aparece às 7h.
> Regra P-047: qualquer tarefa identificada como pendente → registrar aqui IMEDIATAMENTE.
> Feito? Marcar [x]. Músculo remove os [x] ao fechar sessão.

---

## PROJ-001 · Valdece (Deadline: Hypercare até 18/06)

- [ ] `2026-05-21` **V3 ENRICHMENT — campos turma/repercussao_geral vazios:**
  APIs STF/STJ inacessíveis por DNS nesta sessão. Rodar quando rede disponível:
  `python ingest.py --mode reingest` — popula turma + repercussao_geral + recurso_repetitivo + data_dje nos 61 acórdãos.
  Badges PLENO/COLEGIADA só aparecem após este passo.

- [ ] `2026-05-24` **Embaixador Valdece — ativar com nova sistemática:**
  1. Cole no Claude Project Valdece: mensagem de ativação do novo papel (DECISOES.json)
  2. Cole: MENSAGEM_INTERACAO_INICIAL.md V2.0 (via clipboard do ir_ao_embaixador.ps1 -cliente VALDECE)
  3. Suba arquivos atualizados: INTELLIGENCE_LEDGER + WIP_BOARD + MEMORIA_EMBAIXADOR (feito pelo script)

- [ ] `2026-05-24` **Sentinel Report — gerar em 2026-06-02:**
  Relatório de Hypercare para Valdece. Template em CLIENTES/VALDECE/CLAUDE_PROJECT/PASSO7_EMBAIXADOR.md.

---

## PROJ-002 · Ingrid (Deadline: 30/05 Sab — 6 dias)

- [ ] `2026-05-24` **Embaixador Ingrid — ativar com nova sistemática:**
  1. Cole no Claude Project Ingrid: mensagem de ativação do novo papel (DECISOES.json)
  2. Cole: MENSAGEM_INTERACAO_INICIAL.md V2.0 (via clipboard do ir_ao_embaixador.ps1 -cliente INGRID)
  3. Suba arquivos atualizados: INTELLIGENCE_LEDGER + WIP_BOARD + MEMORIA_EMBAIXADOR (feito pelo script)

- [ ] `2026-05-24` **Loop 5 — Gemini (PASSO 3):**
  Passo ⓪ Músculo: ✅ gemini_anchor_generator.ps1 + P-045 verificado (MEMORIA_V4 existe)
  1. Cole: COMANDO_ESTRATEGISTA_MASTER_v1.md
  2. Cole: PASSO3_GEMINI.md (Ingrid Loop 5)
  3. Anexe: MEMORIA_V4_INGRID.md + relatorio_evolutivo_V4_INGRID.md + INTELLIGENCE_LEDGER.md + WIP_BOARD.json
  Salvar: DIRETRIZ V6 → NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V6.txt

- [ ] `2026-05-24` **Loop 5 — NotebookLM (PASSO 5) → ingrid-v5.md:**
  Rodar: preparar_notebooklm_projeto.ps1 -cliente INGRID → Wipe & Sync → COMANDO CURTO
  Salvar: ingrid-v5.md → .claude/skills/ingrid-v5.md
  Validar: skill_parser_gate.ps1

- [ ] `2026-05-24` **Loop 5 — Embaixador (SEÇÃO D) → DECISOES inline:**
  Preencher PASSO7_EMBAIXADOR.md SEÇÃO D com [M-1 a M-5] + [G-1 a G-5] + [N-1 a N-5]
  Colar output completo do Embaixador no Claude Code — Músculo extrai JSON + apresenta decisões
  Eduardo responde "D1:A, D2:B" — Músculo executa automaticamente
  ⚠️ Ingrid (B2C sensível): fluxo simplificado — [E-1 a E-5] como texto, sem JSON burocrático

- [x] `2026-05-24` ~~**Dia 13 — Push dominical + Widget Contador:**~~
  ✅ Widget Contador: pontosBase (Supabase) + pontosAcumulados (sessão) no header
  ✅ Push dominical: banner slideDown + Notification API (iOS excluído via isIosSafari())
  ✅ Versão v14 — deploy GitHub Pages — smoke test 5/5 PASSOU
  ⏳ Gate: Ingrid testa e aprova antes de avançar para Dia 14

- [ ] `2026-05-24` **Dia 14-15 — Offboarding + SaaS Readiness Audit:**
  LEGAL-WATCH: PDF do Termo datado 30/05 — assinatura real 18/05. Resolver antes do offboarding.

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
