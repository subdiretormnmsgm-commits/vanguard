# WIP BOARD — Pentalateral IAH
**Atualizado em:** 2026-06-07
**Fonte:** WIP_BOARD.json (versao Markdown para o Auditor — NotebookLM nao le JSON)

---

## LIMITES WIP
| Coluna | Limite |
|--------|--------|
| Build  | 2 |
| Check  | 1 |

---

## BUILD

### PROJ-000 — VANGUARD (Projeto Interno)
- **Projeto:** VanguardV28 -- Pentalateral Autonomo
- **Area:** Infraestrutura Interna — Pentalateral IAH
- **Tipo:** Projeto Interno — Evolucao do Sistema (nao e projeto cliente)
- **Status:** BUILD — Loop 28 ENTREGUE em 2026-06-07
- **Loop:** 28 CONCLUIDO | Proximo: Loop 29 (aguarda Gemini)
- **Stack:** Hermes Agent (Docker EasyPanel) + n8n (orquestrador) + Claude API Haiku (verificacao semantica)
- **Vereditos Loop 28:**
  - D1=C: Hibrido (Hermes + n8n + Claude API) — APROVADO
  - D2=A: Signal Classifier shadow mode primeiro (7 dias observacao) — APROVADO
  - D3=A: V28 incremental — E-1 + Classifier shadow + Hermes + State Guard (~8h total) — APROVADO
- **Loop fase atual:**
  - Gemini: PENDENTE | NotebookLM: OK | Embaixador: OK | Musculo: OK
  - Proximo: Gemini — PASSO3 Loop 29
- **Entregues V28 (completo):**
  - W-8 Signal Classifier — ATIVO shadow mode n8n EasyPanel (2026-06-07)
  - Hermes Agent — ONLINE EasyPanel hermes/hermes-agent OpenRouter+Telegram (2026-06-07)
  - silenced_signals_log — CRIADA Supabase com RLS (2026-06-07)
  - gate_coerencia.ps1 — INTEGRADO skill_parser_gate
  - State Guard — INTEGRADO session_start
  - N-4 executar_vereditos — sync forcado pos-veredito
  - P-116 inscricao no INTELLIGENCE_LEDGER
  - MEMORIA_EMBAIXADOR_VANGUARD.md — perfil fundador
  - NARRATIVA_FUNDADOR.md — Vanguard como primeiro caso do proprio produto
  - ping_hermes.ps1 — health check Hermes
  - RUNBOOK_EASYPANEL.md — fonte canonica EasyPanel
  - RUNBOOK_SUPABASE_DDL.md — fonte canonica Supabase
  - MEMORIA_V27_VANGUARD.md + MEMORIA_V28_VANGUARD.md — P-045 gate
  - CLAUDE.md v13 + vanguard-protocolo.md v6.5 — Hermes integrado
- **Hermes Agent:**
  - Status: ONLINE
  - Plataforma: EasyPanel hermes/hermes-agent
  - Modelo: anthropic/claude-sonnet-4-6 via OpenRouter
  - Telegram: configurado (home: 8895733647)
  - Grau atual: A — age apenas com aprovacao
  - Config: /opt/data/config.yaml (volume persistido)
  - W-8 shadow mode expira: 2026-06-14
- **Pendentes V28:** (zerado)
- **Skill:** .claude/skills/vanguard-v28.md

---

## CHECK (HYPERCARE)

### PROJ-001 — Valdece
- **Projeto:** Ferramenta de Busca Jurisprudencia STF/STJ
- **Area:** LegalTech - Direito Penal
- **Status:** HYPERCARE — ate 18-06-2026
- **Loop:** 7 CONCLUIDO — V3 entregue + Deploy Netlify OK
- **Deploy:** https://toga-digital-valdece.netlify.app
- **Contrato:** Assinado 2026-05-19 | R$5.000
- **Ultimo contato:** 2026-06-04
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
- **Status:** RETAINER
- **Loop:** 8 CONCLUIDO
- **Ultimo contato:** 2026-06-04
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
| Loops desde ultimo checkup | 1 |
| Data ultimo checkup | 2026-05-27 |
| Data ultima sessao | 2026-06-07 |
| Claude Projects pendente | Sim |

---

*V28 ENTREGUE 2026-06-07 — Hermes Agent ONLINE + W-8 shadow mode (expira 2026-06-14)*
