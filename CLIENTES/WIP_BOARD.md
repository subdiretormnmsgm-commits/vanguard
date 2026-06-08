# WIP BOARD — Pentalateral IAH
**Atualizado em:** 2026-06-09
**Fonte:** WIP_BOARD.json (versao Markdown para o Auditor — NotebookLM nao le JSON)

---

## LIMITES WIP
| Coluna | Limite |
|--------|--------|
| Build  | 2 |
| Check  | 1 |

---

## DISCOVERY (STANDBY)

### PROJ-003 — Mumuzinho
- **Projeto:** Plataforma de Gestao Integral de Carreira Artistica
- **Area:** MusicTech — Fonografia / Holding Artistica
- **Status:** STANDBY — aguarda acionamento do Diretor
- **GUT atual:** 60 provisório | **GUT potencial:** 100 (pós-contato bilateral)
- **Gate Zero:** contato confirmado com Dudu Félix (decisor presumido) — PENDENTE
- **Gate temporal:** prospecção ativa pós 04-07-2026
- **ChurnWatch:** desativado (sem contato bilateral)
- **Nota:** Standby total — inteligência preservada (Análise de Encaixe + Pesquisa Fonográfica) — Diretor aciona quando tiver canal para Dudu Félix

---

## BUILD

### PROJ-000 — VANGUARD (Projeto Interno)
- **Projeto:** VanguardV29 -- Pentalateral Autonomo
- **Area:** Infraestrutura Interna — Pentalateral IAH
- **Tipo:** Projeto Interno — Evolucao do Sistema (nao e projeto cliente)
- **Status:** BUILD — Loop 29 EM BUILD (auditoria cirurgica concluida 2026-06-09)
- **Loop:** 29 EM BUILD | Gemini PENDENTE | auditoria cirurgica desbloqueou
- **Stack:** Hermes Agent (Docker EasyPanel) + n8n (orquestrador) + Claude API Haiku + Antigravity CLI (Intel Loop Motor)
- **Loop fase atual:**
  - Gemini: PENDENTE | NotebookLM: PENDENTE | Embaixador: PENDENTE | Musculo: EM BUILD
  - Proximo: Gemini — PASSO3_GEMINI.md pronto — skill gemini-pentalateral v2.1
- **Entregues V29:**
  - INTELLIGENCE HUB — Track COMPETITORS (mensal) + Track TRENDS (semanal W-9) — ATIVO
  - Antigravity CLI — Intel Loop Motor isolado (P-124) — GEMINI.md + intel-loop.md + PENDING_REVIEW.md
  - /notebooklm skill v2 — YouTube nativo + podcast PT-BR — validada em producao pelo Diretor
  - LOOP_STATE system v1.0 — estado duravel por cliente/loop — resolve amnesia pos-compactacao
  - W-9 n8n — Track TRENDS semanal (segunda 8h BRT) — arquivo criado (importacao EasyPanel: [DIRETOR])
  - session_close.ps1 — gate e-mail bloqueante adicionado
  - skill gemini-pentalateral v2.1 — browser automation Embaixador->Estrategista
  - P-121 a P-127 inscritos no INTELLIGENCE_LEDGER
- **Principios V29:** P-121 a P-127 (2026-06-08/09)
- **Hermes Agent:**
  - Status: ONLINE
  - Plataforma: EasyPanel hermes/hermes-agent
  - Modelo: anthropic/claude-sonnet-4-6 via OpenRouter
  - Telegram: configurado (home: 8895733647)
  - Grau atual: A — age apenas com aprovacao
  - Config: /opt/data/config.yaml (volume persistido)
  - W-8 shadow mode expira: 2026-06-14
- **Skill:** .claude/skills/vanguard-v29.md (pendente — aguarda DIRETRIZ V29)

---

## CHECK (HYPERCARE)

### PROJ-001 — Valdece
- **Projeto:** Ferramenta de Busca Jurisprudencia STF/STJ
- **Area:** LegalTech - Direito Penal
- **Status:** HYPERCARE — ate 18-06-2026
- **Loop:** 7 CONCLUIDO — V3 entregue + Deploy Netlify OK
- **Deploy:** https://toga-digital-valdece.netlify.app
- **Contrato:** Assinado 2026-05-19 | R$5.000
- **Ultimo contato:** 2026-06-09 (confirmou: ferramenta OK — standby)
- **Churn threshold:** 3 dias
- **Sentinel:** VERDE — 2026-06-04 (Supabase pause resolvido)
- **Corpus:** 61 acordaos | 22 temas | threshold 0.45 | TESTADO E VERDE
- **Loop fase atual:**
  - Gemini: OK | NotebookLM: OK | Embaixador: OK | Musculo: OK
  - Proximo: Loop 8 gate — Sentinel Report uso ativo + Gemini anchor DIRETRIZ V8 Valdece
- **V2 Pipeline:** Sovereign Upload + Radar de Divergencia + Citacao DOCX | R$8.500-12.000
- **Proximo passo:** Hypercare termina 18-06-2026 — aguardar feedback Valdece apos Sentinel

---

## RETAINER

### PROJ-002 — Ingrid
- **Projeto:** Ferramenta de Estudo — Concurso Sedes-DF
- **Area:** EdTech - Concursos Publicos
- **Status:** RETAINER — STANDBY
- **Loop:** 8 CONCLUIDO
- **Ultimo contato:** 2026-06-09 (confirmou: ferramenta OK — standby)
- **Churn threshold:** 3 dias (P-106 — EdTech perfil nao-verbal)
- **Depoimento:** Ingrid gostou muito da ferramenta — capturado 2026-06-04
- **Prova:** 2026-09-06 (Instituto Quadrix)
- **URL publica:** https://subdiretormnmsgm-commits.github.io/vanguard/
- **Banco questoes:** 460 validadas
- **Loop fase atual:**
  - Gemini: OK | NotebookLM: OK | Embaixador: OK | Musculo: OK
  - Proximo: Loop 9 — Gate 7.2 RLS + captacao 2a candidata antes 04-07-2026
- **Pendentes abertos:**
  - D5: Link Demo bloqueado ate 2a usuario
  - D6: Semente E-4 aguardar engajamento verbal
  - Gate 7.2 RLS refactor: julho 2026

---

## PERFIS DE NICHO

| Nicho | Maturidade | Cliente Referencia | Status |
|-------|------------|-------------------|--------|
| EdTech-Concurso | 70% | PROJ-002 Ingrid | consolidado — Loop 8 concluido |
| LegalTech-Criminal | 75% | PROJ-001 Valdece | HYPERCARE — V3 entregue — Sentinel Verde |

---

## POLITICA

1. Nada entra em BUILD sem Briefing aprovado pelo Diretor
2. Nada sai de BUILD sem check_leis.ps1 aprovado
3. Nada vai para ENTREGUE sem Sovereign Playbook gerado
4. Sentinel do cliente atual validado antes de novo projeto entrar em BUILD
5. Retainer so apos 30 dias de dados reais do Sentinel

---

## META

| Campo | Valor |
|-------|-------|
| Loops desde ultimo checkup | 2 |
| Data ultimo checkup | 2026-05-27 |
| Data ultima sessao | 2026-06-09 |
| Claude Projects pendente | Sim |

---

*V29 EM BUILD 2026-06-09 — INTELLIGENCE HUB + Antigravity + /notebooklm v2 + LOOP_STATE + P-127 — Gemini PENDENTE*
