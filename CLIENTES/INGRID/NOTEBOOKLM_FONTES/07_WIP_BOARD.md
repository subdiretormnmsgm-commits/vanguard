# WIP BOARD — Pentalateral IAH
**Atualizado em:** 2026-05-30
**Fonte:** WIP_BOARD.json (versão Markdown para o Auditor — NotebookLM não lê JSON)

---

## PROJETOS EM BUILD

---

### PROJ-002 · INGRID
**Projeto:** Ferramenta de Estudo — Concurso SEDES-DF 2026
**Área:** EdTech · Concursos Públicos
**Cargo:** TDAS — Técnico Administrativo (Cargo 202) · Banca: Instituto Quadrix
**Stack:** PWA + Supabase + Claude API
**Deadline:** 2026-05-30 | **Data da prova:** 2026-09-06
**Valor fechado:** R$ 0 (Projeto Piloto Interno — Validação V25)

**Status:** Loop 6 (Gemini V7) — SaaS Readiness + pipeline comercial
**URL pública:** https://subdiretormnmsgm-commits.github.io/vanguard/ — ATIVA — v20

#### Loop Fase Atual (Loop 7)
| Sócio | Status |
|---|---|
| Gemini | OK — DIRETRIZ V7 recebida · 12_DIRETRIZ_GEMINI_V7.txt salvo em NOTEBOOKLM_FONTES |
| NotebookLM | PENDENTE |
| Embaixador | PENDENTE |
| Músculo | PENDENTE |
| Próximo | NotebookLM — PASSO5 pronto — Wipe & Sync — Skill ingrid-v7.md |

#### Dias Concluídos
- dia1_schema_edge ✅
- dia2_gate_questoes ✅
- dia3_5_feed_sm2_pwa ✅
- dia6_8_tutor_fallback ✅
- dia9_11_heatmap_simulado ✅
- dia12_contador_socratica_vacina_push_cb ✅

#### Gates Bloqueantes
| Gate | Requisito | Status |
|---|---|---|
| dia2 | 10 questões avaliadas — rubrica média >= 4/5 | ✅ APROVADO |
| dia5 | Feed exibe plano correto 7 dias | ✅ APROVADO |
| dia8 | Ingrid responde 10 questões — progresso salvo | ✅ APROVADO |
| dia11 | Heatmap correto + simulado domingo completo | ✅ APROVADO |
| dia15 | Ingrid com acesso admin próprio Supabase | ✅ APROVADO — 2026-05-30 |

#### Bloqueios Técnicos Ativos
- Edge Functions não deployadas via CLI — F-4 (cron 19h45) e F-6 (relatório semanal) operam manualmente
- GitHub Pages push bloqueado — Eduardo: seguir link GitHub Security para desbloquear

#### Precificação
| Modelo | Valor |
|---|---|
| Serviço personalizado | R$ 2.500 por candidato externo |
| SaaS licença | R$ 197 por ciclo do concurso |
| SaaS MRR | R$ 97/mês × 4 meses = R$ 388/usuário |
| Meta | 500 usuários = R$ 194.000 no ciclo SEDES-DF 2026 |

#### Temperatura do Cliente
- **7.5/10 — VERDE SUSTENTADO** · "Gostei bastante. Amanhã volto para atacar mais" (2026-05-24)
- CHURN-WATCH desativado · DADOS-WATCH VERDE (102 respostas, 1 user_id)
- LEGAL-WATCH VERDE — Reassinatura física 2026-05-27

#### Loops Programados
| Loop | Nome | Gate | Status |
|---|---|---|---|
| 1 | Kickoff | dia2_questoes | ✅ CONCLUÍDO |
| 2 | Gate Dia 5 | dia5_feed_proporcao | ✅ CONCLUÍDO — 2026-05-17 |
| 3 | Gate Dia 11 | dia11_heatmap_simulado | ✅ CONCLUÍDO — 2026-05-20 |
| 4 | Handoff Dia 15 | dia15_admin_supabase | ✅ CONCLUÍDO — 2026-05-26 |

---

### PROJ-001 · VALDECE
**Projeto:** Ferramenta de Busca Jurisprudência STF/STJ
**Área:** Legal Tech · Direito Penal
**Stack:** Python + Supabase + Gemini Embeddings + Netlify
**Deadline:** 2026-05-23 — ENTREGUE | **Valor fechado:** R$ 5.000
**Hypercare:** até 2026-06-18

**Status:** Sistema LIVE · Contrato ASSINADO 2026-05-19 · V3 entregue · Deploy Netlify ATIVO
**URL:** https://toga-digital-valdece.netlify.app

#### Loop Fase Atual (Loop 7)
| Sócio | Status |
|---|---|
| Gemini | OK — DIRETRIZ V7 gerada (DIRETRIZ_GEMINI_V7.txt) |
| NotebookLM | OK — valdece-v7.md existe |
| Embaixador | OK |
| Músculo | PENDENTE |
| Próximo | Sentinel Report 2026-06-02 — Músculo gera PASSO7-C antes |

#### Corpus
- 61 acórdãos · 22 temas · Threshold 0.45 · Top 3 · Latência 2.1–3.4s
- Temas: HC, preventiva, tráfico, dosimetria, nulidade, homicídio, estupro, violência doméstica, execução penal, prescrição, legítima defesa, org-criminosa, porte-arma, corrupção, concurso-crimes, sursis, estelionato, extorsão, ECA, lesão-corporal, tentativa, tráfico-internacional

#### V2 Pipeline (gatilho: corpus >= 500 docs ou 30 dias pós-entrega)
- Sovereign Upload · Radar de Divergência · Citação DOCX
- Pricing: R$ 8.500–12.000 projeto único + R$ 300/mês manutenção opcional

#### Pendentes
- Sentinel Report: 2026-06-02 (terça-feira) — Músculo gera PASSO7-C antes

---

## PERFIS DE NICHO

| Nicho | Maturidade | Cliente | Status |
|---|---|---|---|
| EdTech-Concurso | 60% | PROJ-002 Ingrid | Consolidado parcial |
| LegalTech-Penal | 75% | PROJ-001 Valdece | Contrato assinado — V3 entregue |

### Em Discovery
- Médico-Prova-Especialidade — GO aprovado 2026-05-19
- Contabilidade-PME — GO aprovado 2026-05-19
- Psicólogo-Clínico-Autônomo — GO aprovado 2026-05-19

---

## POLÍTICA EXPLÍCITA

1. Nada entra em BUILD sem Briefing aprovado pelo Diretor
2. Nada sai de BUILD sem check_leis.ps1 aprovado
3. Nada vai para ENTREGUE sem Sovereign Playbook gerado
4. Sentinel do cliente atual validado antes de novo projeto entrar em BUILD
5. Retainer só após 30 dias de dados reais do Sentinel

---

*Músculo — Pentalateral IAH — 2026-05-30*
*Regra: atualizar este .md sempre que WIP_BOARD.json for editado — Auditor não lê JSON*
