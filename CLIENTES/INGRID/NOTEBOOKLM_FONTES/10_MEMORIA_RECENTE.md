# MEMORIA_V3 — PROJ-002 INGRID · Loop 3 · Fechamento
> **Gerada em:** 2026-05-19 | **Por:** Músculo (Claude Code)
> **Cobre:** Loop 3 completo — Gate Dia 8 APROVADO 2026-05-19 + Entrega Embaixador + PERFIS_NICHO

---

## 1. ESTADO TÉCNICO ATUAL

| Componente | Status | Notas |
|---|---|---|
| PWA frontend (app.js + index.html + style.css) | LIVE — gh-pages | URL pública: `https://subdiretormnmsgm-commits.github.io/vanguard/` |
| Supabase Edge Function tutor-socrático | LIVE | Haiku para geral + Sonnet para específico |
| Banco de questões | 460 questões Cargo 202 | Expansão 1.000+ bloqueada por créditos Anthropic |
| Clickwrap Termo de Uso | Implementado | `termos_aceitos` + SHA-256 — Gate P-023 resolvido em código |
| E-2 frase âncora | Implementado | 2 estados: cold start edital / erro recente |
| E-5 encerramento | Implementado | Threshold ≥ 10 questões antes de exibir |
| Tutor Socrático 3 níveis | Implementado | Nível 1 (conceito) / 2 (distrator) / 3 (analogia) |
| TTI (tempo de resposta) | Implementado | `acerto_provavel_chute: true` quando TTI < 10s + acerto |
| Beacon de abandono | Implementado | Padrão 3+ na semana, não evento único |
| Debug Mode | Implementado | 5 toques no logo (nunca query string) |
| Bug negrito Q18 | CORRIGIDO | commit da9887a — md2html() adicionada |

---

## 2. GATES DE LOOP 3

| Gate | Status | Evidência |
|---|---|---|
| Gate Dia 2 (10 questões CLI ≥ 4/5) | APROVADO | Dia 2 da sessão anterior |
| Gate Dia 5 (feed 7 dias, 0 erros) | APROVADO | 2026-05-17 |
| Gate Dia 8 (10q + progresso salvo + fallback) | APROVADO — 2026-05-19 | Ingrid respondeu 10+ questões. Bug negrito Q18 corrigido (commit d00c2c1 → gh-pages). Gate confirmado pelo Diretor. |

---

## 3. DECISÕES FIXADAS (não reverter)

| Decisão | Motivo |
|---|---|
| Stack: PWA Vanilla JS + Supabase + Claude Haiku | Testado e funcional em campo |
| Auth: single-user hardcoded | Piloto — auth real é gate para primeiro pagante (P-045) |
| Feed: 70/30 (Peso 2 / Peso 1) | Calibrado com banco atual |
| SM-2 original preservado | Só coleta latência — não altera fórmula |
| Número visível: Pontos Ponderados | Obrigação contratual Cláusula 2 |
| URL pública (GitHub Pages) | Aceitável para piloto; bloqueante antes de primeiro pagante (P-045) |

---

## 4. ENTREGA DO EMBAIXADOR — LOOP 3

### 4.1 Documentos entregues (commit 273906f)

| Documento | Tipo | Destino |
|---|---|---|
| RELATÓRIO AUTORAL DO EMBAIXADOR.txt | Análise estratégica autoral | CLIENTES/INGRID/ |
| METODOLOGIA_PERFIS_VANGUARD.md | Framework operacional de Perfis | CLAUDE_PROJECT/ + PERFIS_NICHO/ |
| PERFIL_EDTECH_CONCURSO.md | Perfil de Nicho v1 (60% maturidade) | CLAUDE_PROJECT/ + PERFIS_NICHO/ |
| PERFIL_LEGAL_TECH_CRIMINAL.md | Perfil de Nicho v1 (50% maturidade) | CLAUDE_PROJECT/ + PERFIS_NICHO/ |
| PERFIL_CLIENTE_INGRID.md | Perfil comportamental Ingrid v1 | CLAUDE_PROJECT/ |
| CAMADA_FATOS / CAMADA_INFERENCIA / CAMADA_DECISAO | 3-layer MEMORIA | CLAUDE_PROJECT/ (raiz) |
| PASSO7_EMBAIXADOR.md Loop 4 | Guia de ativação atualizado | CLIENTES/INGRID/ |

### 4.2 Descobertas estruturais (RELATÓRIO AUTORAL)

1. **Inconsistência documental do Termo**: PDF datado 30/05/2026, assinatura ocorreu 18/05/2026. PDF corrigido ainda pendente.
2. **MEMORIA_EMBAIXADOR misturava fato e interpretação**: Resolvido com estrutura 3-camadas.
3. **Perfis de Nicho são moat, não produto**: Tese autoral do Embaixador — P-047 registrado.

---

## 5. NOVOS PRINCÍPIOS — LEDGER P-042 A P-050

| P# | Princípio (1 linha) | Rotina operacional |
|---|---|---|
| P-042 | FALAS_CLIENTE — repositório único por projeto | Criar ao iniciar qualquer projeto com cliente real |
| P-043 | Acusação de viés exige evidência verbatim | Antes de qualquer debate metodológico |
| P-044 | Princípio sem rotina operacional é prosa | Ao extrair princípio → declarar a rotina imediatamente |
| P-045 | URL pública só em piloto — auth real antes do primeiro pagante | Gate bloqueante SaaS Readiness Audit |
| P-046 | Primeiro feedback espontâneo de piloto é o ativo mais valioso | Capturar verbatim em < 24h, processar por todos os membros |
| P-047 | Perfil de Nicho é trade secret — nunca em proposta ou pitch externo | PERFIS_NICHO/ com .gitignore |
| P-048 | Perfil avança de maturidade só com evidência de cliente real | Perfil < 30% não dirige build |
| P-049 | Cada Perfil novo declara como difere dos Perfis vizinhos | Seção obrigatória em todo novo Perfil |
| P-050 | Pesquisa de mercado externa é insumo do Estrategista, não substituto de verbatim | Estrategista: 0-30%. Verbatim: 30-80% |

---

## 6. PERFIS_NICHO — CRIAÇÃO

| Ação | Status |
|---|---|
| `PENTALATERAL_UNIVERSAL/PERFIS_NICHO/` criada | FEITO |
| `.gitignore` bloqueando PERFIL_*.md (privacidade de cliente) | FEITO |
| METODOLOGIA_PERFIS_VANGUARD.md na pasta | FEITO |
| EDTECH_CONCURSO.md (60% maturidade — 1 cliente real) | FEITO |
| LEGALTECH_PENAL.md (50% maturidade — 1 cliente real) | FEITO |
| GO/NO-GO nichos novos: Médico + Contabilidade + Psicólogo | APROVADO 2026-05-19 |
| PESQUISA_BRUTA para 3 nichos | Embaixador gerando PASSO3 para Gemini |

---

## 7. DÍVIDAS TÉCNICAS

| # | Dívida | Prioridade | Bloqueante |
|---|---|---|---|
| D-1 | PDF Termo corrigido (data 30/05 → 18/05) + reassinatura da Ingrid | P0 | Cobertura jurídica |
| D-2 | Gate Dia 8 formal: confirmar com Eduardo (10q completas + progresso + fallback) | P0 | Loop 4 |
| D-3 | WhatsApp para Ingrid — bug corrigido + valorizando o feedback dela | P0 | Engajamento |
| D-4 | Banco 460 → 1.000+ questões | P1 | Esgotamento em 23 dias (P-038) |
| D-5 | Auth real (Supabase Auth + RLS) antes do primeiro pagante | P1 | P-045 |
| D-6 | AUDITORIA_VANGUARD.txt — sessão dedicada de auditoria estrutural | P2 | Documetação |

---

## 8. ESTADO DOS MEMBROS DO CONSELHO

| Membro | Estado | Próxima ação |
|---|---|---|
| Músculo | Sessão encerrando | Gerar PASSO3 + email + MEMORIA |
| Estrategista | Aguardando PASSO3 com DIRETRIZ V5 | Eduardo vai ao Gemini com relatorio_V3 + PASSO3 |
| Auditor | Aguardando Wipe & Sync | Executar `preparar_notebooklm_projeto.ps1 -cliente INGRID` antes do Loop 4 |
| Embaixador | Gerando PASSO3 para Medicina + Contabilidade + Psicologia | Aguardar delivery e processar |

---

## 9. CLIMA DO CLIENTE

```
TEMPERATURA: QUENTE
EVIDÊNCIA: Primeira sessão real (18/05), chegou até Q18, reportou bug com precisão técnica, 
           "gostou muito" relatado pelo Diretor.
VALIDADE: até próximo contato ou Gate Dia 11 (o que vier primeiro)
RISCO ATUAL: silêncio > 36h a partir de 2026-05-19 → ativar Embaixador SEÇÃO B
```
