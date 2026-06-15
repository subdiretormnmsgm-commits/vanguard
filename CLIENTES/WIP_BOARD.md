# WIP BOARD — Pentalateral IAH
**Atualizado em:** 2026-06-14
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
- **Projeto:** VanguardV29 — Pentalateral Autonomo
- **Area:** Infraestrutura Interna — Pentalateral IAH
- **Tipo:** Projeto Interno — Evolucao do Sistema (nao e projeto cliente)
- **Status:** BUILD — Loop 33 CONCLUIDO · W-10 redesign 9 nos + P-164 · Loop 34 aguarda objetivo P-160
- **Loop atual:** 33 CONCLUIDO | Gemini OK | NotebookLM OK | Embaixador OK | Musculo OK
- **Stack:** Hermes Agent (Docker EasyPanel) + n8n (orquestrador) + Claude API (Haiku — verificacao)
- **Loop fase atual:**
  - Gemini: OK | NotebookLM: OK | Embaixador: OK | Musculo: OK
  - Proximo: Loop 34 — aguarda objetivo declarado pelo Diretor (P-160 gate bloqueante)
- **Hermes Agent:**
  - Status: ONLINE
  - Plataforma: EasyPanel hermes/hermes-agent
  - Modelo: anthropic/claude-sonnet-4-6 via OpenRouter
  - Telegram: configurado (home: 8895733647)
  - Grau atual: B — age automaticamente + veto 15min Telegram (PERMANENTE — decidido 2026-06-13)
  - Grau ativado em: 2026-06-10
  - W-8 shadow mode: ENCERRADO — 7 dias sem incidentes — Grau B permanente · Grau C adiar para Loop 35+ apos 30 dias log limpo
  - Config: /opt/data/config.yaml (volume persistido)
- **Entregues V29:**
  - INTELLIGENCE HUB — Track COMPETITORS (mensal) + Track TRENDS (semanal W-9) — ATIVO
  - Antigravity CLI — Intel Loop Motor isolado (P-124) — GEMINI.md + intel-loop.md + PENDING_REVIEW.md
  - /notebooklm skill v2 — YouTube nativo + podcast PT-BR — validada em producao
  - LOOP_STATE system v1.0 — estado duravel por cliente/loop — resolve amnesia pos-compactacao
  - W-9 n8n — Track TRENDS semanal (segunda 8h BRT) — ATIVO — GOOGLE_AI_API_KEY configurada via Playwright 2026-06-14
  - session_close.ps1 — gate e-mail bloqueante adicionado
  - skill gemini-pentalateral v2.1 — browser automation Embaixador->Estrategista
  - P-121 a P-127 inscritos no INTELLIGENCE_LEDGER
- **Entregues V32:**
  - Antigravity renomeado EXECUTOR do Estrategista (Gemini) em 62 arquivos — commit 4defaf6
  - Hermes Grau B registrado formalmente (D1:A executado 2026-06-10)
  - LOOP_STATE schema v1.1 — missao + loop_anterior + builds_aprovados_nao_iniciados + p133
  - pentalateral-firewall.md criado (.agents/skills/) — R-01..R-04
  - SUGESTOES_DIRETOR.md protegida R-01 + deletada de CONSELHO/
  - PASSO3_GEMINI.md identidade corrigida + CONTEXTO_GEMINI regenerado (110.677 chars)
  - P-033 sync slot 20 LOOP_STATE_SCHEMA propagado INGRID+VALDECE+VANGUARD
  - LEDGER_INBOX.md criado com P-148 + FALHAS A-K + addendum P-130
- **Principios V28:** P-115, P-116
- **Principios V29:** P-121 a P-127 (2026-06-08/09)
- **Entregues V33:**
  - W-10 Health Check n8n — redesenhado 1 no para 9 nos (HTTP Request + Analyze Health logica pura) — execucao 499 verde (2026-06-14)
  - P-164 inscrito — Code node sandbox EasyPanel: $helpers e fetch() indisponiveis — regra arquitetural definitiva
  - n8n-remote-v1.md atualizado — 8 entradas SUCESSO/FALHA
  - RUNBOOK_EASYPANEL.md atualizado — secao restricao sandbox + 4 erros conhecidos
  - w10_n8n_healthcheck.json atualizado — reflete arquitetura 9 nos live (commit d8a3a8b)
- **Principios V32:** P-148 — LEDGER_INBOX como buffer de integridade (2026-06-10)
- **Principios V33:** P-164 — Code node sandbox EasyPanel sem $helpers/fetch() (2026-06-14)
- **Ultimo veredito:** 2026-06-14 — Loop 33 V2 CONCLUIDO: W-10 redesign 9 nos + P-164 + RUNBOOK + Skill atualizados
- **Skill:** .claude/skills/vanguard-v30.md

---

## CHECK (HYPERCARE)

### PROJ-001 — Valdece
- **Projeto:** Ferramenta de Busca Jurisprudencia STF/STJ
- **Area:** LegalTech - Direito Penal
- **Status:** HYPERCARE — ate 18-06-2026
- **Loop:** 7 CONCLUIDO — V3 entregue + Deploy Netlify OK
- **Deploy:** https://toga-digital-valdece.netlify.app (2026-05-19)
- **Contrato:** Assinado 2026-05-19 | R$5.000
- **Ultimo contato:** 2026-06-14
- **Churn threshold:** 3 dias
- **Sentinel:** VERDE — 2026-06-04 (Supabase pause resolvido)
- **Corpus:** 61 acordaos | 22 temas | threshold 0.45 | TESTADO E VERDE
- **Loop fase atual:**
  - Gemini: OK | NotebookLM: OK | Embaixador: OK | Musculo: OK
  - Proximo: Loop 8 gate — Sentinel Report uso ativo + Gemini anchor DIRETRIZ V8 Valdece
- **V2 Pipeline:** Sovereign Upload + Radar de Divergencia + Citacao DOCX | R$8.500-12.000 + R$300/mes manutencao
- **Proximo passo:** Hypercare termina 18-06-2026 — Sentinel Report enviado 2026-06-04 — aguardar feedback Valdece

---

## RETAINER

### PROJ-002 — Ingrid
- **Projeto:** Ferramenta de Estudo — Concurso Sedes-DF
- **Area:** EdTech - Concursos Publicos
- **Status:** RETAINER
- **Loop:** 8 CONCLUIDO
- **Ultimo contato:** 2026-06-13
- **Churn threshold:** 3 dias
- **Depoimento:** Ingrid gostou muito da ferramenta — capturado 2026-06-04
- **Prova:** 2026-09-06 (Instituto Quadrix — cargo TDAS 202)
- **URL publica:** https://subdiretormnmsgm-commits.github.io/vanguard/
- **Banco questoes:** 460 validadas — expansao para 1000+ aguarda creditos Anthropic
- **Termo de uso:** ASSINADO 2026-05-18
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
| Data ultima sessao | 2026-06-14 |
| Claude Projects pendente | Sim |

---

*Loop 33 CONCLUIDO 2026-06-14 — W-10 redesign 9 nos + P-164 Code sandbox + Drive-First Embaixador — Loop 34 aguarda objetivo P-160 — COWORK sync INTELLIGENCE_HUB pendente (proxima sessao dedicada 4-6h)*
