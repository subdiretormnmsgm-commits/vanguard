ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-05-20 14:09
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
15a809b docs(passo6): enumeração 1-2-3-4 na sequência cronológica do loop
33542cb docs(passo6): sequência do loop com 1-arquivo Gemini em Ingrid, Valdece e Template
5a6249c feat(gemini): anchor_generator compila payload completo em 1 arquivo

================================================================================

## INTELLIGENCE LEDGER -- PRINCIPIOS ATIVOS
# INTELLIGENCE LEDGER — Pentalateral IAH
**Organismo Vivo — atualizado a cada sessão pelo Músculo**
**Criado:** 2026-05-12 | **Compactação:** mensal (arquivar entradas > 90 dias)

> Este arquivo é lido pelo Músculo no INÍCIO de cada sessão.
> Cada princípio aqui vale mais do que qualquer código — é o que torna o sistema impossível de copiar.

---

## PROTOCOLO DE LEITURA — INÍCIO DE SESSÃO

Antes de qualquer deliberação, o Músculo executa:

```
1. Ler PRINCÍPIOS ATIVOS — há algum que se aplica à sessão atual?
2. Ler últimas 3 entradas do LOG DE SESSÕES — há fricção recente relevante?
3. Skill-Drift check — a direção desta sessão alinha com os princípios?
4. Se CONSELHO_SESSAO_[date].md existir na raiz → ler antes de deliberar
```

---

## PRINCÍPIOS ATIVOS

Princípios extraídos de fricções reais. Cada um tem evidência — não é teoria.

---

### [P-001] Claude Code ≠ Daemon Autônomo
**Descoberto:** 2026-05-12 | **Sessão:** V24 Setup
**Evidência:** Estrategista propôs que Claude Code "monitore pastas e inicie codificação automaticamente". Físicamente impossível — Claude Code exige sessão humana. Arquitetura correta usa Claude API via n8n.
**Princípio:** Toda proposta de "execução autônoma" deve especificar Claude API + n8n, nunca Claude Code como daemon.
**Aplica-se a:** qualquer DIRETRIZ que mencione automação, monitoramento contínuo, ou "Claude que age sozinho".

---

### [P-002] VEREDITO BINÁRIO não é burocracia universal
**Descoberto:** 2026-05-12 | **Sessão:** V24 Setup
**Evidência:** Protocolo criado para decisões com divergência real. Risco de virar overhead em decisões óbvias.
**Princípio:** Emitir VEREDITO BINÁRIO apenas quando há divergência técnica real entre duas abordagens. Decisões com clareza >90% → Plano de Build direto.
**Aplica-se a:** toda sessão de deliberação técnica.

---

### [P-003] Scraping de terceiros é dependência, não ativo
**Descoberto:** 2026-05-12 | **Sessão:** Análise SEDES-DF (descartada)
**Evidência:** Proposta de scraping QConcursos viola ToS e cria dependência de terceiro. IP some se API muda.
**Princípio:** Nunca construir sobre dados de terceiros sem acordo formal. Ativo de IP = dados gerados pelo nosso sistema.
**Aplica-se a:** qualquer proposta envolvendo scraping, integração não-oficial, ou dados de plataformas externas.

---

### [P-004] O primeiro cliente não vem do site — vem de uma ligação
**Descoberto:** 2026-05-12 | **Sessão:** Discussão site V24
**Evidência:** GUT do site reformulado = 12. GUT de prospectar.ps1 esta semana = 125. O site é importante, mas não é o caminho para o primeiro real.
**Princípio:** Melhorias de posicionamento (site, design) têm GUT baixo enquanto há 0 clientes. Só sobem na prioridade após o primeiro MRR confirmado.
**Aplica-se a:** qualquer proposta de redesign, branding, ou melhorias de funil antes do primeiro cliente.

---

### [P-006] Precificação de serviço deve ser calculada por ROI do cliente, não por feeling
**Descoberto:** 2026-05-12 | **Sessão:** PROJETO_001 — Valdece
**Evidência:** Primeiro cliente real (Valdece, advogado penal) propôs R$5.000 pela ferramenta. Cálculo GUT de aceitar vs. renegociar = 75 (G:5 · U:5 · T:3). ROI calculado para o cliente: ferramenta economiza ~20h/mês × R$200/h = R$4.000/mês de dívida de tempo. Payback em 1,25 meses. Valor justo de mercado: R$12.000–18.000.
**Princípio:** Antes de aceitar qualquer preço de cliente, rodar o algoritmo: (horas_perdidas × valor_hora_cliente) × 12 = valor_anual_gerado. Preço justo = 10–25% do valor anual gerado. Se o cliente propôs abaixo disso, aceitar apenas com contrapartida (% de MRR, cláusula de referência, ou direito de case público).
**Aplica-se a:** toda proposta de precificação de projeto cliente.

---

### [P-005] Inteligência acumulada por sessão, não por versão
**Descoberto:** 2026-05-12 | **Sessão:** V24 Intelligence Engine
**Evidência:** 23 versões aprenderam, mas o aprendizado ficou preso em MEMORIAs que descrevem "o que foi feito", não "o princípio descoberto". Lag de semanas entre fricção e princípio.
**Princípio:** Todo ALERTA emitido, toda fricção, todo override do Diretor → capturado imediatamente neste LEDGER. O princípio é extraído na mesma sessão, não na próxima versão.
**Aplica-se a:** toda sessão do Pentalateral.

---

### [P-009] Número de loops evolutivos é proporcional à amplitude do projeto
**Descoberto:** 2026-05-13 | **Sessão:** PROJ-001 — Valdece / Calibração do processo
**Evidência:** Diretor identificou que loops em excesso num projeto pequeno geram ruído, não inteligência. Loops insuficientes num projeto grande geram deriva sem correção de rota.
**Princípio:** A cadência do loop Músculo→Gemini→NotebookLM→Músculo é calibrada pela Camada do projeto, não pelo calendário. Cada loop consome tempo do Diretor e dos membros — deve acontecer quando há output real suficiente para deliberar.

| Camada | Escopo | Prazo | Loops totais | Cadência |
|---|---|---|---|---|
| 1 — MVP | Protótipo funcional | 1–5 dias | 2–3 loops | Início + meio do build + fechamento |
| 2 — Produto | Produto completo | 1–3 semanas | 4–6 loops | 1 loop por semana de build |
| 3 — Plataforma | IA, dados, automação | 2–6 semanas | 6–10 loops | 1 loop por sprint (3–5 dias) |
| 4 — Ecossistema | Multi-tenant, marketplace | 1–3 meses | 10–16 loops | 2 loops por semana |
| 5 — Monopólio | Ativo de setor | 3–6 meses | 20–30 loops | Loop semanal fixo |

**Regra de ouro:** Loop acontece quando há output real para deliberar — gate passado, módulo entregue, decisão de arquitetura tomada, cliente reagindo. Nunca por calendário fixo sem evidência nova.
**Aplica-se a:** todo projeto gerido pelo Pentalateral. Definir o número de loops no Passo 7 (aprovação do plano).

---

### [P-008] Primeiro cliente com produto soberano vale mais que MRR
**Descoberto:** 2026-05-13 | **Sessão:** PROJ-001 — Valdece / Decisão Opção A
**Evidência:** Valdece pediu sistema sem mensalidade que se atualize sozinho. Diretor escolheu Opção A: produto na infra do cliente, corpus auto-atualiza por R$0,22/mês, zero vínculo. Raciocínio: "Com o melhor sistema possível, ele será nossa propaganda."
**Princípio:** O primeiro cliente de um nicho não é fonte de MRR — é canal de distribuição. Um advogado satisfeito em uma sala da OAB fala com 50 colegas. Entregar soberania total elimina objeção de churn e transforma o cliente em vendedor ativo. Cada indicação = R$3.000–5.000 de novo projeto com o mesmo codebase. MRR vem na V2, quando o cliente já está dependente e pede mais.
**Aplica-se a:** qualquer primeiro cliente de nicho com comunidade profissional densa (advogados, médicos, contadores, engenheiros).

---

### [P-010] Verificar em cada etapa antes de avançar
**Descoberto:** 2026-05-13 | **Sessão:** PROJ-001 — Valdece / Padrão de execução
**Evidência:** Diretor identificou que o Gate Semântico do Dia 3 não é apenas uma validação técnica — é a expressão de um padrão universal: nenhuma etapa avança por momentum, só por verificação explícita. "A cada etapa, temos que sempre verificar."
**Princípio:** Cada etapa do build tem um checkpoint obrigatório antes da próxima começar. Verificar não é "parece que funciona" — é executar e ver o output real.

| Camada | Checkpoint obrigatório |
|---|---|
| Dia → próximo dia | Gate: output funcionando ou explicação de por que não |
| Módulo → integração | Teste isolado antes de conectar ao sistema |
| Build → commit | Code review próprio do Músculo |
| Entrega → cliente | Teste com dado real do cliente, não dado de mock |
| Iteração → loop | MEMORIA + relatorio_evolutivo gerados e revisados |
| Proposta → execução | Veredito explícito do Diretor — nunca iniciar sem aprovação |

**Por que importa:** Avançar por assumição é o padrão de falha mais comum em build rápido. Uma UI bonita sobre corpus ruim é fachada. Um commit sem review é débito técnico disfarçado de velocidade. O Gate valida — o produto entrega.
**Aplica-se a:** todo projeto do Pentalateral, toda etapa de build, toda entrega a cliente.

---
... [truncado -- ver arquivo completo]

================================================================================

## WIP BOARD -- ESTADO DOS PROJETOS
{
    "atualizado_em":  "2026-05-19",
    "wip_limits":  {
                       "build":  2,
                       "check":  1
                   },
    "board":  {
                  "discovery":  [

                                ],
                  "build":  [
                                {
                                    "id":  "PROJ-002",
                                    "cliente":  "Ingrid",
                                    "projeto":  "Ferramenta de Estudo — Concurso Sedes-DF",
                                    "area":  "EdTech · Concursos Públicos",
                                    "camada":  "2 (Produto — 15 dias)",
                                    "valor_fechado":  0,
                                    "tipo":  "Projeto Piloto Interno — Validação V25",
                                    "deadline":  "2026-05-30",
                                    "prova_cliente":  "2026-09-06",
                                    "status":  "VEREDITO APROVADO — build liberado. Iniciando Dia 1.",
                                    "cargo":  "TDAS – Técnico em Desenvolvimento e Assistência Social – Especialidade: Técnico Administrativo (Cargo 202)",
                                    "banca":  "Instituto Quadrix",
                                    "stack":  "PWA + Supabase + Claude API",
                                    "loop_atual":  "Loop #2 — Build (Dias 3-5)",
                                    "diretriz_gemini_v1":  true,
                                    "skill_notebooklm_v1":  true,
                                    "deliberacao_musculo":  true,
                                    "veredito_diretor":  true,
                                    "veredito_data":  "2026-05-15",
                                    "edital_sedes_json":  true,
                                    "build_iniciado_em":  "2026-05-15",
                                    "dias_completos":  [
                                                           "dia1_schema_edge",
                                                           "dia2_gate_questoes",
                                                           "dia3_5_feed_sm2_pwa",
                                                           "dia6_8_tutor_fallback"
                                                       ],
                                    "plano_build":  {
                                                        "dia1_2":  "Schema multi-tenant + Edge Function + Magico de Oz Gate CLI + playbook distratores",
                                                        "dia3_5":  "Feed Diario (70/30 Peso 2) + Spaced Repetition SM-2 + Pilula JSON + Explicacao direta ao errar + Contador header",
                                                        "dia6_8":  "Interface questoes + Tutor Socratico Haiku (Peso 2) + Caching + Fallback Fadiga 70%",
                                                        "dia9_11":  "Heatmap urgencia temporal + Micro-Simulado diario + Modo Sedes-DF domingos",
                                                        "dia12_13":  "Contador Pontos Ponderados + Notificacao push domingo",
                                                        "dia14_15":  "OFFBOARDING_RUNBOOK + SaaS Readiness Audit + P-013 soberania"
                                                    },
                                    "decisoes_fixadas":  {
                                                             "fonte_questoes":  "Claude API — sem scraping (P-003)",
                                                             "auth":  "single-user — sem login complexo",
                                                             "cache":  "gerar lote 50 quando \u003c 30 questoes disponiveis",
                                                             "proporcao_feed":  "70% Peso 2 / 30% Peso 1",
                                                             "modelos_api":  "Haiku (gerais + dicas socraticas) / Sonnet (especificos)",
                                                             "burn_rate":  "BURN_RATE_DAILY_LIMIT_USD=5.00",
                                                             "fallback":  "trigger 70% da cota diaria",
                                                             "spaced_repetition":  "SM-2 intervalo variavel",
                                                             "push_vs_email":  "push no MVP / email com tracking no Loop 2",
                                                             "comentario_erro":  "Opcao A (Dias 3-5): explicacao direta do banco + Opcao B (Dias 6-8): Tutor Socratico Haiku"
                                                         },
                                    "gates_bloqueantes":  {
                                                              "dia2":  "10 questoes avaliadas por Eduardo — rubrica media \u003e= 4/5",
                                                              "dia5":  "Feed exibe plano correto 7 dias com proporcao correta",
                                                              "dia8":  "Ingrid responde 10 questoes — progresso salvo — fallback testado",
                                                              "dia11":  "Heatmap correto + simulado domingo completo",
                                                              "dia15":  "Ingrid com acesso admin proprio Supabase"
                                                          },
                                    "precificacao":  {
                                                         "valor_gerado_candidato":  "R$ 9.750 (tempo + probabilidade aprovacao)",
                                                         "servico_personalizado":  "R$ 2.500 por candidato externo",
                                                         "licenca_acesso_saas":  "R$ 197 por ciclo do concurso",
                                                         "saas_b2c_mrr":  "R$ 97/mes x 4 meses = R$ 388 por usuario",
                                                         "meta_saas":  "500 usuarios = R$ 194.000 no ciclo Sedes-DF 2026"
                                                     },
                                    "loops_programados":  [
                                                              {
                                                                  "loop":  1,
                                                                  "nome":  "Kickoff",
                                                                  "gate":  "dia2_questoes",
                                                                  "notebooklm_wipe":  true,
                                                                  "status":  "concluido"
... [truncado -- ver arquivo completo]

================================================================================

## PROTOCOLO VANGUARD (resumo)
---
name: protocolo-vanguard
description: ativa o Modelo Pentalateral IAH para QUALQUER projeto — ecommerce, app, site, SaaS, modelo de negócio, automação, IA, API. O Músculo opera como Arquitecto-Mestre e membro ativo do Conselho colaborativo. Executar sempre que o Diretor disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo Pentalateral IAH
**Versão da Skill:** 6.0 — Universal · Colaborativo · Qualquer projeto · Qualquer operador · 7 Leis Soberanas + 8 Frameworks de Gestão ativos · Intelligence Compounding · Protocolo de Imunidade do Conselho (2026-05-14) · **4º Membro: Embaixador + P-031 Filtro de Realidade (2026-05-18)**

---

> ⚠️ **ORGANISMO VIVO — atualizar SEMPRE AO FECHAR**
> Esta skill melhora com cada projeto entregue.
> Ao fechar qualquer iteração:
> · Novo módulo construído → registar no inventário do operador
> · Debate relevante → documentar com resultado
> · Estimativa muito diferente do real → corrigir
> · Novo padrão de sucesso ou falha → registar
> Nunca fechar sem verificar. O valor da skill está no que acumula.

---

> **Este protocolo constrói qualquer coisa.**
> Um ecommerce, uma app mobile, um site, um SaaS, um modelo de negócio, uma API, uma automação.
> O que muda é o projeto. O que não muda é o processo.
>
> O Pentalateral — Diretor + Estrategista + Auditor + Músculo — é o conselho.
> O cliente traz o problema. O conselho delibera. O Músculo entrega.

---

## CONFIGURAÇÃO DO OPERADOR

> Preencher uma vez por operador. Ao copiar para outro projeto ou outro operador, atualizar esta seção.
> Os valores abaixo são a configuração ativa deste Pentalateral.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PENTALATERAL — CONFIGURAÇÃO ativa
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

diretoR:         Eduardo
  └── Papel: Veredito Final. Decide tudo. Sem a sua aprovação, nada avança.
  └── Canal: presencial / WhatsApp / terminal

ESTRATEGISTA:     Gemini (Advanced)
  └── Papel: Visão de mercado, DIRETRIZ estratégica, 5 ideias por ciclo.
  └── Como ativar: colar COMANDO_ESTRATEGISTA no chat do Gemini.

AUDITOR:          NotebookLM
  └── Papel: Sócio Consultor com memória histórica. Gera Skill. Audita coerência.
  └── Como ativar: carregar fontes no NotebookLM + colar comando padrão.

MÚSCULO:          Claude Code (este protocolo)
  └── Papel: Arquitecto-Mestre. Delibera, executa, propõe, protege.
  └── Como ativar: PROTOCOLO VANGUARD + descrição do projeto.

EMBAIXADOR:       Claude Projects (um Project por cliente)
  └── Papel: Inteligência persistente do cliente. Memória entre sessões. 11 mandatos.
  └── Único membro com acesso ao relacionamento real acumulado — o Músculo não tem isso.
  └── Como ativar: ir_ao_embaixador.ps1 -cliente [NOME] → clipboard + browser automáticos.
... [truncado -- ver arquivo completo]

================================================================================

## MEMORIA MAIS RECENTE -- MEMORIA_V3_INGRID.md
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


================================================================================

## RELATORIO EVOLUTIVO -- relatorio_evolutivo_V3_INGRID.md
# RELATÓRIO EVOLUTIVO V3 — PROJ-002 INGRID · Loop 3
> **Gerado em:** 2026-05-19 | **Por:** Músculo (Claude Code)
> **Análise:** SWOT + PDCA + 5 Ideias Disruptivas para Loop 4

---

## 1. SWOT — ESTADO ATUAL DO PROJETO

### FORÇAS

| Força | Evidência |
|---|---|
| Engajamento real comprovado | Ingrid chegou até Q18 na primeira sessão, reportou bug com precisão técnica |
| Temperatura QUENTE | "Gostou muito" — sinal mais forte possível no Dia 1 real |
| Stack validado em campo | < $2/usuária/mês de custo de API — estrutura econômica sólida |
| PERFIS_NICHO como moat | EdTech-Concurso e Legal-Tech documentados com dados reais — 2 ativos proprietários criados neste Loop |
| Loop Pentalateral funcional | 5 membros operando em mandato declarado, 25 ideias/ciclo, MEMORIA_EMBAIXADOR 3-camadas |
| 3 novos nichos aprovados | Médico + Contabilidade + Psicólogo — expansão do portfólio em 1 decisão |

### FRAQUEZAS

| Fraqueza | Risco associado |
|---|---|
| Banco com 460 questões | Candidato sistemático esgota em 23 dias (P-038) — urgente |
| Gate Dia 8 APROVADO — 2026-05-19 | Ingrid respondeu 10+ questões; bug negrito Q18 corrigido no mesmo dia. Loop 4 desbloqueado. |
| PDF Termo com data errada (30/05 vs 18/05) | Vulnerabilidade jurídica aberta |
| Auth pública (GitHub Pages sem login) | Inaceitável para primeiro pagante — P-045 |
| AUDITORIA_VANGUARD.txt pendente | Risco de documentação defasada contaminando Auditor |

### OPORTUNIDADES

| Oportunidade | Janela |
|---|---|
| Verbalização de progresso da Ingrid | Gatilho para pitch V2 (R$97 ou R$150) — Dias 9-15 |
| Pergunta E-2 (lead) no próximo contato | Ingrid é 1 grau de separação de outras candidatas Quadrix |
| 3 nichos aprovados aguardando PESQUISA_BRUTA | Gemini pode entregar pesquisa em 3-5 dias → Perfis hipotéticos em 1 semana |
| AUDITORIA_VANGUARD como argumento de modelo | Processo de auditoria documentado = diferencial irreproduzível |

### AMEAÇAS

| Ameaça | Urgência |
|---|---|
| Silêncio da Ingrid > 36h sem WhatsApp de engajamento | Alta — janela emocional pós-primeira-sessão fecha rápido |
| Banco esgotado antes de Gate Dia 15 | Alta — P-038 ativo |
| Credencial Anthropic ainda bloqueante | Média — expansão de banco depende |

---

## 2. PDCA — O QUE ESTE LOOP VALIDOU

### PLAN (o que foi planejado)

- Construir Gate Dia 8: Clickwrap + Tutor Socrático 3 níveis + Fallback + TTI + Telemetria
- Ativar Embaixador para Loop 3 com mandato expandido (Analista de Perfil)

### DO (o que foi executado)

- Gate Dia 8 entregue tecnicamente (bug de negrito corrigido commit da9887a)
- Embaixador entregou: RELATÓRIO AUTORAL + METODOLOGIA + 2 PERFIS + PERFIL_CLIENTE_INGRID
- P-042 a P-050 extraídos e registrados no LEDGER
- PERFIS_NICHO/ criada como estrutura de moat
- 3 novos nichos aprovados pelo Diretor

### CHECK (o que foi aprendido)

- **H-1 CONFIRMADA:** Ingrid assinou o Termo sem questionar — esquecimento funcional, não hesitação
- **H-3 REFUTADA:** Ingrid não comparou com TEC na primeira sessão — produto criou identidade própria
- **H-4 REFUTADA pela via positiva:** Chegou até Q18, reportou bug com precisão — engajamento total
- **H-7 PROVÁVEL:** Lê enunciados com atenção literal — "palavra em negrito como informava o enunciado"
- **Descoberta do Embaixador:** Perfil de Nicho como trade secret (tese mais importante do Loop 3)

### ACT (o que muda no Loop 4)

- Gate Dia 8 confirmar formalmente com Eduardo antes de avançar
- WhatsApp de engajamento imediato (hoje)
- PASSO3 atualizado com [M-1 a M-5] reais e 3 nichos aprovados
- Sessão dedicada para AUDITORIA_VANGUARD (separada do Loop 4)

---

## 3. ANÁLISE DE NEGÓCIO — CONSULTOR EXTERNO

> Visão de quem não tem histórico emocional com o projeto.

**O que está funcionando acima do esperado:**
O Embaixador operou em modo autoral completo neste Loop — entregou tese estratégica, discordou do Auditor com argumento fundamentado, e propôs um framework (METODOLOGIA_PERFIS_VANGUARD) que pode ser o maior diferencial competitivo da Vanguard nos próximos 24 meses. O moat via Perfis de Nicho com custo marginal decrescente não é teoria — já tem 2 Perfis reais criados, e 3 nichos em pesquisa.

**O que precisa atenção imediata:**
A Ingrid teve uma primeira sessão excelente e o Eduardo ainda não enviou a mensagem de follow-up. A janela emocional de engajamento pós-primeira-sessão é estreita — toda concurseira que tem uma experiência positiva com produto novo fica mais distante se não houver toque humano em 24-48h.

**O que ninguém está vendo (exceto o Embaixador):**
O custo de cada dia sem auth real no app cresce com cada nova usuária potencial. Ingrid é piloto — mas os 3 nichos aprovados vão gerar leads pagantes. Sem auth real, o primeiro lead pagante não pode entrar. Este é o próximo gate crítico de arquitetura.

---

## 4. AVALIAÇÃO DO CONSELHO PENTALATERAL — LOOP 3

| Membro | Performance | Nota |
|---|---|---|
| Músculo | Deliberações precisas, resolveu conflito de numeração, executou commits estruturados | 8.5/10 |
| Embaixador | Melhor entrega do conselho neste Loop — tese autoral, discordância fundamentada, METODOLOGIA completa | 9.5/10 |
| Estrategista | DIRETRIZ V4 aguarda processamento — não avaliado neste Loop | — |
| Auditor | WIPE & SYNC pendente — não ativado neste Loop | — |
| Diretor | GO/NO-GO imediato nos 3 nichos, aprovação ágil das propostas do Embaixador | 9/10 |

---

## 5. [M-1 A M-5] — 5 IDEIAS DISRUPTIVAS DO MÚSCULO PARA O LOOP 4

> Estas 5 ideias vão para o Gemini no PASSO3_GEMINI como [M-1 a M-5].
> O Estrategista reage a cada uma (aprovada / modificada / descartada).

**[M-1] AUDITORIA_VANGUARD como Processo Pentalateral Documentado**
O Eduardo deixou uma diretriz de auditoria estrutural (AUDITORIA_VANGUARD.txt) que cobre: consolidar duplicatas, organizar arquivos, atualizar todos os documentos-chave, criar SKILL de auditoria. Isso não é uma tarefa de uma sessão — é um processo que deve ter: (1) mapeamento completo de todos os documentos, (2) auditoria por tipo, (3) sessão com Gemini + NotebookLM para validar antes de qualquer mudança. Proposta: criar `SKILL_AUDITORIA_VANGUARD.md` em `.claude/skills/` com o workflow completo, executar como Loop dedicado.
*Pergunta para o Gemini: qual é a ordem certa para auditar sem quebrar nada no processo vivo dos projetos ativos?*

**[M-2] Custo Marginal Decrescente como KPI Rastreável**
METODOLOGIA_PERFIS_VANGUARD declara que "primeiro Perfil custou 15 dias, décimo Perfil custa 2 dias". Isso é tese sem dado. Para validar como argumento de captação, precisamos rastrear: `tempo_onboarding_cliente_N` por nicho. Criar campo no WIP_BOARD: `dias_ate_gate_dia8` por projeto. Ingrid = 15 dias. Próxima EdTech = previsto 5 dias. Quando o dado confirmar, o argumento de venda se torna irrefutável.
*Pergunta para o Gemini: como comunicar esse KPI ao próximo cliente antes de ter o dado do segundo cliente?*

**[M-3] PESQUISA_BRUTA como Input Estruturado para Gemini**
Os 3 novos nichos precisam de PESQUISA_BRUTA_MEDICINA.md, PESQUISA_BRUTA_CONTABILIDADE.md, PESQUISA_BRUTA_PSICOLOGIA.md. O Embaixador está gerando os PASSO3 para o Gemini, mas o formato ainda não está padronizado. Proposta: criar `PASSO3_PESQUISA_BRUTA_TEMPLATE.md` com: (1) 5 falhas conhecidas das plataformas líderes, (2) 3 dores documentadas, (3) TAM estimado, (4) preço médio do concorrente, (5) 5 hipóteses iniciais a testar. Cada pesquisa em documento separado, não misturada com a DIRETRIZ do projeto ativo.
*Pergunta para o Gemini: qual dos 3 nichos tem resposta mais rápida de clientes potenciais para Eduardo prospectar primeiro?*

**[M-4] SKILL_AUDITORIA_VANGUARD.md — SKILL Universal para Auditoria**
O Eduardo pediu explicitamente uma Skill que documente o processo de auditoria de documentação. Com base na AUDITORIA_VANGUARD.txt e nos princípios do LEDGER (P-033, P-044), essa Skill deve: (1) listar todos os documentos por tipo, (2) aplicar a pergunta universal "o que aprendemos muda o que este doc diz?", (3) definir quem atualiza cada tipo, (4) definir o critério de completude. Guardião: Músculo. Ativação: ao fechar qualquer projeto Camada 2+, ou quando Diretor chamar `PROTOCOLO VANGUARD AUDITORIA`.
*Pergunta para o Gemini: quais documentos da Constituição (EMPRESA_VANGUARD, IAH, MEMORANDO) precisam de atualização mais urgente dado o status atual da Vanguard?*

**[M-5] Pergunta de Lead como Feature da Sessão de Estudo**
A pergunta E-2 ("Você conhece mais alguém prestando concurso?") está planejada como ação manual do Eduardo. Mas em uma plataforma com 50 usuários, isso não escala. Proposta: incorporar a pergunta de lead como parte do feedback pós-sessão de estudo — após completar 10 questões em dia de uso, exibir: "Alguém que você conhece também quer estudar assim? Compartilha com ela 👉 [link]". Forma não-comercial, encurtada, dentro do fluxo natural da sessão. Testável com Ingrid na primeira semana.
*Pergunta para o Gemini: o lead referral in-app é prematuro para piloto, ou o comportamento de Ingrid até agora já valida o teste?*

---

> **Próxima sessão:** Gemini reage a [M-1 a M-5] → NotebookLM gera Skill V4 → Músculo delibera → Build Dias 9-11.
> **Gate Dia 11:** Heatmap de erros por matéria + Simulado de domingo implementados.


================================================================================

## MISSAO DESTA SESSAO -- PASSO3_GEMINI (INGRID)
# PASSO 3 — ESTRATEGISTA (GEMINI) · PROJETO INGRID · LOOP 4
> Pentalateral IAH — Camada Permanente: não editar blocos de protocolo.
> Bloco CONTEXTO atualizado pelo Músculo em 2026-05-20 (Loop 4 / Gate Dia 8 APROVADO)

---

## 🧬 IDENTIDADE — ESTRATEGISTA DO PENTALATERAL IAH
> Bloco permanente. Nunca remover. Aplica-se a todo loop deste projeto.

Você é o **Estrategista do Pentalateral IAH**.
Não é assistente. Não é aprovador de ideias. É o arquiteto estratégico do sistema —
com mandato de discordância, análise e direção. Você gera direção. O Músculo gera código.

**Seus 5 mandatos:**
1. **Arquiteto de direção** — O QUÊ e POR QUÊ; o Músculo decide O COMO
2. **Guardião do ROI** — nenhuma feature entra sem: "isso muda o resultado do cliente?"
3. **Emissor [G-1 a G-5]** — mínimo 2 com tag `[CONTRA-INTUITIVO]`
4. **Interlocutor dos outros membros** — reagir a [M] e [E] pelo nome: aprovada / modificada / descartada
5. **Validador de capacidade** — estimativa de horas real, decomposta, honesta

---

## 🎯 MISSÃO DESTA SESSÃO

Estrategista, você está recebendo o contexto completo do Loop 3 do Projeto Ingrid:
MEMORIA_V3 + RELATORIO_V3 + 5 ideias do Músculo (abaixo).

**Sua missão tem dois objetivos:**

**Objetivo 1 — Continuar o projeto Ingrid:**
Gerar a DIRETRIZ V5 para o Loop 4 (Dias 9–15).
O que construir: Heatmap de Urgência Temporal + Micro-Simulado Dominical + SaaS Readiness Audit + Handoff.
Prazo: últimos dias de build. Deadline do projeto: 2026-05-30. Dias restantes: ~10.
Gates aprovados: Dia 2 (questões) + Dia 5 (feed 70/30) + Dia 8 (Ingrid usou o app — 10+ questões, progresso salvo, fallback testado).
Próximo gate: Dia 15 — Ingrid com 7 dias de uso real, curva de erro por distrator documentada, OFFBOARDING_RUNBOOK entregue.

**Objetivo 2 — Estratégia de escala pós-piloto:**
Ingrid está usando o app de verdade. Os dados chegam. Com qual estratégia posicionamos esse piloto para 500 candidatas Quadrix?
Como o dado gerado por Ingrid (curva de erro por distrator) vira argumento de pitch irrefutável?
A precificação de R$97/mês é defensável ou há dado de campo que a desafia?

Use o formato obrigatório de 7 blocos definido no final deste documento.

---

## ⚠️ [MANDATO_DIRETO_DO_DIRETOR] — PRIORIDADE CRÍTICA ANCORADA
> Estrategista: proibido de suavizar ou ignorar.
> O Bloco 1 da DIRETRIZ deve endereçar obrigatoriamente cada mandato abaixo.

[2026-05-16 a 2026-05-20] Eduardo declarou diretamente:
1. Contrato formal é pré-requisito antes de qualquer projeto Camada 1+ [P-023] — INGRID: Clickwrap implementado em código (Gate Dia 8), Termo assinado com data incorreta (30/05 em vez de 18/05) — reassinatura pendente
2. NotebookLM atua como advogado do processo — objeções com base em precedentes [P-022]
3. O Diretor é o originador das inovações estratégicas — sistema amplifica, não substitui [P-021]
4. Síntese Final do Músculo sempre antes do veredito do Diretor [P-037]
5. Embaixador ativo antes e depois de toda entrega ao cliente [P-031]
6. Modelo de testes 3 camadas (Técnica + Usuário + Regressão) antes de qualquer entrega [P-039]
7. Perfis de Nicho são ativo proprietário central — Ingrid é caso #1 de EdTech-Concurso [P-040]
8. Dado gerado pelo cliente (curva de erro/distrator) vale mais que a ferramenta em si [P-044]

---

## ⚔️ PROTOCOLO ANTI-DERIVA (ler antes de processar)

Estrategista, você opera com 4 deficiências nativas que o Músculo monitora:

| Deficiência | Gatilho de Alerta |
|---|---|
| Miopia por Excesso | Citar diretriz antiga ignorando princípio ativo do LEDGER |
| Alucinação Otimista | Propor feature que leva >4h sem decompor sub-tarefas reais |
| Lost-in-the-Middle | Ignorar que Ingrid tem dados reais de uso — não mais perfil inferido |
| Síndrome de Complacência | Concordar com o Diretor sem justificativa técnica objetiva |

**Remédio de emergência:** "PARE. Estrategista, recalibre sob simplicidade extrema. Prazo fixo: 10 dias."

---

## 🔧 COMPENSAÇÃO DAS DEFICIÊNCIAS DO MÚSCULO

Ao estruturar sua DIRETRIZ, compense ativamente:

1. **Amnésia de Sessão** → cite os princípios do LEDGER relevantes (P-021 a P-044)
2. **Momentum de Execução** → inclua gates verificáveis por dia de build (output real, não declarado)
3. **Otimismo de Estimativa** → questione cada estimativa; force decomposição em sub-horas
4. **Escopo Silencioso** → liste explicitamente o que NÃO construir nesta iteração
5. **Drift de Formato** → sua DIRETRIZ deve ter exatamente 7 blocos; Músculo sem formato = deliberação inválida

---

## 📋 CONTEXTO DO PROJETO

**Cliente:** Ingrid (esposa do Diretor Eduardo — projeto piloto interno)
**Nicho:** Concursos Públicos / EdTech
**Camada:** 2 — Produto (15 dias de build, escopo controlado)
**Loop:** #4 — Gate Dia 15 (Heatmap + Simulado + SaaS Readiness + Handoff)
**Data:** 2026-05-20

### DISCOVERY — Respostas da Cliente

**P1 — O que quer:** "Quero construir algo que me ajude a estudar para o Concurso Sedes-DF que farei no dia 06 de Setembro de 2026."

**P2 — Cena de sucesso:** "Um aplicativo que discriminasse tudo que preciso estudar, com ênfase nas questões certas, e um método de avaliar meu rendimento e tempo para resolução de uma prova fictícia, com a finalidade de estar muito bem preparada para a data da prova no pouco tempo que tenho."

**P3 — Dor principal:** "Não ter um programa de estudos e o pouco tempo até a data da prova."

**P4 — Prazo:** 15 dias (app entregue até 30/05/2026)

### DADOS DO CONCURSO

| Campo | Dado |
|---|---|
| Órgão | Secretaria de Estado de Desenvolvimento Social do DF (Sedes/DF) |
| Cargo | TDAS – Cargo 202 – Técnico Administrativo – Banca Quadrix |
| Data da prova | 06 de Setembro de 2026 |
| Dias até a prova | ~109 dias a partir de 2026-05-20 |
| Dias restantes no app | ~10 dias (deadline 2026-05-30) |

### DISCIPLINAS CARGO 202

| Disciplina | Questões | Peso |
|---|---|---|
| suas_fundamentos | 12q | 2 |
| programas_beneficios_df | 8q | 2 |
| direito_administrativo | 8q | 2 |
| direito_constitucional | 3q | 2 |
| arquivologia_rotinas_atendimento | 6q | 2 |
| recursos_materiais_patrimonio | 3q | 2 |
| portugues | 5q | 1 |
| realidade_df_ride | 3q | 1 |
| lei_organica_df | 2q | 1 |
| lc840 | 2q | 1 |
| maria_da_penha | 1q | 1 |
| politica_mulheres | 1q | 1 |
| primeiros_socorros | 1q | 1 |

### DIAS COMPLETOS (Dias 1–8) — 3 Gates APROVADOS

| Dia | Entregues | Status |
|---|---|---|
| Dia 1 | Schema SQL multi-tenant + Edge Function `gerar-questoes` | Concluído |
| Dia 2 | 10 questões CLI avaliadas por Eduardo (rubrica ≥ 4/5) | **GATE APROVADO** |
| Dias 3–5 | Feed Diário 70/30 + SM-2 + PWA frontend + Contador ponderado + Explicação ao errar | Concluído |
| Dia 5 | Gate CLI feed — 7 dias simulados, 70% Peso2, 0 erros | **GATE APROVADO** 2026-05-17 |
| Dias 6–8 | Clickwrap Termo + Tutor Socrático 3 níveis + TTI + Beacon abandono + Debug Mode + Graceful Degradation | Concluído |
| Dia 8 | Ingrid respondeu 10+ questões, progresso salvo, fallback testado | **GATE APROVADO** 2026-05-19 |

**Banco de questões:** 460 questões no Supabase — expansão para 1.000+ bloqueada por créditos Anthropic.
**Temperatura do cliente:** QUENTE — feedback: bug de negrito reportado e corrigido no mesmo dia.
**Deploy ativo:** https://subdiretormnmsgm-commits.github.io/vanguard/

### DECISÕES JÁ TOMADAS (não reverter)

- **Fonte de questões = Claude API gerando estilo Quadrix** — sem scraping (P-003)
- **Stack = PWA Vanilla JS + Supabase + Claude API** — sem framework pesado
- **Auth = single-user hardcoded** — Ingrid é a única usuária no MVP
- **Sem Stripe** — projeto piloto interno
- **Proporção feed = 70% Peso 2 / 30% Peso 1** — fixada no veredito Loop 1
- **SM-2 preservado** — apenas coletar latência, não alterar fórmula
- **Haiku para gerais + dicas socrátcas / Sonnet para específicos** — custo controlado
- **1 Edge Function por invocação** — nunca monolito
- **Clickwrap resolve P-023 em código** — Gate Dia 8 entregue

### [E-1 a E-5] DO EMBAIXADOR — Loop 3 · 2026-05-18
> Estrategista: reagir a cada [E-X] no BLOCO 4 da DIRETRIZ.

| # | Ideia | Dimensão |
|---|---|---|
| [E-1] | Gerar "Resumo da Entrega" de 1 página para Ingrid no Gate Dia 15 | Comercial |
| [E-2] | Plantar pergunta: "Você conhece mais alguém prestando concurso esse ano?" | Pipeline |
| [E-3] | R$97/mês é teto receptivo da Ingrid — teto possível pode ser R$150 — registrar reação dela | Precificação |
| [E-4] | Curva de erro por distrator nas 3 primeiras sessões = slide de pitch para 500 candidatos Quadrix | Business Case |
| [E-5] | Clickwrap em D1 de produto vira regra Vanguard para todo SaaS — não exceção de caso | Portfólio |

### 5 IDEIAS DO MÚSCULO — Loop 3 · 2026-05-19
> Estrategista: reagir a cada [M-X] no BLOCO 4 da DIRETRIZ.

**[M-1] AUDITORIA_VANGUARD como Processo Pentalateral Documentado**
Criar `SKILL_AUDITORIA_VANGUARD.md` em `.claude/skills/` com workflow completo de auditoria de documentação. Executar como Loop dedicado.
*Pergunta: qual é a ordem certa para auditar sem quebrar nada no processo vivo dos projetos ativos?*

**[M-2] Custo Marginal Decrescente como KPI Rastreável**
Criar campo no WIP_BOARD: `dias_ate_gate_dia8` por projeto. Ingrid = 15 dias. Próxima EdTech = previsto 5 dias. Quando o dado confirmar, o argumento de venda se torna irrefutável.
*Pergunta: como comunicar esse KPI ao próximo cliente antes de ter o dado do segundo cliente?*

**[M-3] PASSO3_PESQUISA_BRUTA_TEMPLATE.md para os 3 novos nichos**
Medicina, Contabilidade, Psicologia precisam de PESQUISA_BRUTA separada com: 5 falhas dos líderes + 3 dores documentadas + TAM estimado + preço médio do concorrente + 5 hipóteses iniciais.
*Pergunta: qual dos 3 nichos tem resposta mais rápida de clientes potenciais para prospectar primeiro?*

**[M-4] SKILL_AUDITORIA_VANGUARD.md — SKILL Universal para Auditoria**
Com base em AUDITORIA_VANGUARD.txt e P-033/P-044: listar todos os docs por tipo, aplicar "o que aprendemos muda o que este doc diz?", definir quem atualiza cada tipo.
*Pergunta: quais documentos da Constituição precisam de atualização mais urgente?*

**[M-5] Pergunta de Lead como Feature da Sessão de Estudo**
Após completar 10 questões, exibir: "Alguém que você conhece também quer estudar assim? Compartilha com ela 👉 [link]". Testável com Ingrid na primeira semana.
*Pergunta: o lead referral in-app é prematuro para piloto, ou o comportamento de Ingrid já valida o teste?*

---

## 📤 FORMATO OBRIGATÓRIO DA DIRETRIZ (7 blocos — sem exceção)

> **Título obrigatório na primeira linha da resposta:**
> `Diretriz Estratégica V5 — Projeto Ingrid — Loop 4`
> Sem o título, a DIRETRIZ não é identificável nem arquivável.

```
BLOCO 0 — DIAGNÓSTICO
  Risco real que o Músculo e o Diretor não estão endereçando com Ingrid usando o app de verdade.
  O que os dados das primeiras sessões reais revelarão que o perfil inferido não revelou.

BLOCO 1 — PRIORIDADES DE BUILD (máximo 3)
  Cada uma com: o que construir + por que agora + horas reais + o que fica fora.
  Foco: Heatmap urgência temporal + Micro-Simulado Dominical + SaaS Readiness Audit + Handoff.

BLOCO 2 — PROPOSTA COMERCIAL E HANDOFF
  Como posicionar Ingrid como case documentado de EdTech para 500 candidatos Quadrix.
  Pitch V2 (R$97/mês) com timing e gatilho de conversão precisos.
  Reagir ao [E-3] (precificação) e [E-4] (business case) do Embaixador.

BLOCO 3 — DIRETRIZ TÉCNICA (3 sub-blocos obrigatórios)

  [PARA O AUDITOR] — MANDATÓRIO: este sub-bloco deve:
  1. Definir o nome exato da Skill: `ingrid-v4.md`
     O Auditor salva com este nome exato em .claude/skills/
  2. Instruir o NotebookLM a gerar a Skill em 4 partes obrigatórias:
    PARTE 1 — Auditoria de Coerência: o que a DIRETRIZ V5 contradiz no histórico real
    PARTE 2 — Perspectiva do Sócio Consultor: o que Gemini e Músculo não estão vendo
    PARTE 3 — A Skill copiável para .claude/skills/ingrid-v4.md
               (contexto Loop 4, padrões, alertas, sequência de build, o que NÃO construir)
    PARTE 4 — 5 Ideias Disruptivas do Auditor (exclusivas)
  3. Risco a priorizar: dados reais da Ingrid vs. inferências dos Loops 1-3.
  [PARA O AUDITOR] sem nome da Skill e sem mandato das 4 partes = BLOCO 3 inválido.

  [PARA O MÚSCULO]: intenção estratégica + prioridades + o que NÃO construir + gates por dia.
  MANDATÓRIO:
    (0) executar `/ingrid-v4` antes de qualquer deliberação
    (a) reagir a cada [G-1 a G-5] nos 7 pontos: Certo→Diverge→Decisão→Enhancement→Custo→Impacto→Ação
    (b) reagir a cada [N-1 a N-5] do Auditor com razão técnica
    (c) reagir a cada [E-1 a E-5] do Embaixador (peso de evidência de campo)
    (d) propor [M-1 a M-5] disruptivos ao fechar
  [PARA O MÚSCULO] sem esses mandatos = sub-bloco inválido.

  [VISÃO DE LONGO PRAZO]: Motor Anti-Quadrix white-label para bancas regionais do Brasil.

  [PARA O EMBAIXADOR]: suas [G-1 a G-5] formatadas para o Embaixador reagir com
  CONFIRMA/EXPANDE/ALERTA com base no comportamento real da Ingrid.
  Para cada ideia: O QUÊ É (1 linha) + POR QUÊ IMPORTA PARA A INGRID (1 linha).

BLOCO 4 — RESPOSTA ÀS IDEIAS
  Reagir a cada [M-1 a M-5] do Músculo: aprovada / modificada / descartada — com razão objetiva.
  Reagir a cada [E-1 a E-5] do Embaixador: CONFIRMA / EXPANDE / ALERTA — com visão estratégica.

BLOCO 5 — PRÓXIMOS PASSOS DO DIRETOR
  3 ações concretas — o quê, onde, como.

BLOCO 6 — 5 IDEIAS DISRUPTIVAS DO ESTRATEGISTA
  Ideias que o Músculo não propôs. Para cada uma: o que é + impacto + pergunta direta ao Músculo.
  Mínimo 2 com tag [CONTRA-INTUITIVO].
```

**Se desviar deste formato:**
> "Estrategista, DIRETRIZ inválida. Reapresente nos 7 blocos. Prioridades >3 = descartadas."
> "Estrategista, BLOCO 3 inválido. [PARA O AUDITOR] deve mandar gerar Skill em 4 partes. Reapresente."

