# WIP BOARD — Pentalateral IAH
**Atualizado em:** 2026-06-06
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
- **Status:** BUILD — iniciado 2026-06-06
- **Loop:** 28 — EM BUILD
- **Stack:** Hermes Agent (Docker EasyPanel) + n8n (orquestrador) + Claude API Haiku (verificacao semantica)
- **Vereditos Loop 28:**
  - D1=C: Hibrido (Hermes + n8n + Claude API) — APROVADO
  - D2=A: Signal Classifier shadow mode primeiro (7 dias observacao) — APROVADO
  - D3=A: V28 incremental — E-1 + Classifier shadow + Hermes + State Guard (~8h total) — APROVADO
- **Loop fase atual:**
  - Gemini: OK | NotebookLM: OK | Embaixador: OK | Musculo: OK
  - Proximo: BUILD V28 — W-8 Signal Classifier n8n + Hermes Agent Docker + State Guard
- **Entregues V28:**
  - gate_coerencia.ps1 — E-1 Gate de Coerencia Semantica via Haiku
  - skill_parser_gate.ps1 — E-1 integrado ao final
  - MAINTENANCE_COST.md v2.0 — fallbacks W-8 + W-9 + Hermes Agent
  - render_painel.ps1 — VANGUARD adicionado ao ValidateSet
  - DELIBERACAO_LOOP_V28_VANGUARD.md — P-037 gate satisfeito
  - DECISOES_VANGUARD_2026-06-06.json + VEREDITOS — veredito D1=C D2=A D3=A
- **Pendentes V28:**
  - W-8 Signal Classifier — build n8n shadow mode (~3h)
  - Hermes Agent — Docker EasyPanel + Claude API + skill graus A/B/C (~4-6h)
  - State Guard — acoplar ao session_start (~2h)
  - N-4 Sync forcado pos-veredito em executar_vereditos.ps1 (~1h)
  - P-116 inscricao no INTELLIGENCE_LEDGER
  - MEMORIA_EMBAIXADOR_VANGUARD.md — perfil fundador
  - ping_hermes.ps1 + silenced_signals_log Supabase
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
| Data ultima sessao | 2026-06-06 |
| Claude Projects pendente | Nao |

---

*V28 adicionado em 2026-06-06 — PROJ-000 VANGUARD como projeto interno em BUILD*
