ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-05-29 01:09
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
e418b37 chore(ingrid-v6): fechamento Loop V6 -- MEMORIA + relatorio + PASSO3 para V7
e46d42e feat(p089): PASSO3 regenerado automaticamente pelo gemini_anchor_generator
bb9350c feat(embaixador): artefato automatico via API Haiku + fix gargalo dias compostos

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

> **GAPS NUMÉRICOS — RESERVADOS:**
> P-011 e P-012 **não existem**. Foram descartados na origem (pré-V24) antes do LEDGER ser formalizado.
> NÃO reaproveitar esses números — gaps são parte da história do sistema.
> Qualquer referência a P-011 ou P-012 em documentos = erro de numeração.

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
... [truncado -- ver arquivo completo]

================================================================================

## WIP BOARD -- ESTADO DOS PROJETOS
{
    "atualizado_em":  "2026-05-28",
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
                                    "projeto":  "Ferramenta de Estudo â€” Concurso Sedes-DF",
                                    "area":  "EdTech Â· Concursos PÃºblicos",
                                    "camada":  "2 (Produto â€” 15 dias)",
                                    "valor_fechado":  0,
                                    "tipo":  "Projeto Piloto Interno â€” ValidaÃ§Ã£o V25",
                                    "deadline":  "2026-05-30",
                                    "prova_cliente":  "2026-09-06",
                                    "status":  "Loop 6 (Gemini V7) -- iniciando -- SaaS Readiness + pipeline comercial",
                                    "cargo":  "TDAS â€“ TÃ©cnico em Desenvolvimento e AssistÃªncia Social â€“ Especialidade: TÃ©cnico Administrativo (Cargo 202)",
                                    "banca":  "Instituto Quadrix",
                                    "stack":  "PWA + Supabase + Claude API",
                                    "loop_atual":  "Loop 5 CONCLUIDO â€” Gate Dia 15 APROVADO 2026-05-26 Â· Loop 6 PENDENTE â€” aguarda Gemini PASSO3",
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
                                                           "dia6_8_tutor_fallback",
                                                           "dia9_11_heatmap_simulado",
                                                           "dia12_contador_socratica_vacina_push_cb"
                                                       ],
                                    "delivery_dates":  {
                                                           "dia1_2":  "2026-05-15",
                                                           "dia3_5":  "2026-05-17",
                                                           "dia6_8":  "2026-05-19",
                                                           "dia9_11":  "2026-05-20",
                                                           "dia12":  "2026-05-23"
                                                       },
                                    "plano_build":  {
                                                        "dia1_2":  "Schema multi-tenant + Edge Function + Magico de Oz Gate CLI + playbook distratores",
                                                        "dia3_5":  "Feed Diario (70/30 Peso 2) + Spaced Repetition SM-2 + Pilula JSON + Explicacao direta ao errar + Contador header",
                                                        "dia6_8":  "Interface questoes + Tutor Socratico Haiku (Peso 2) + Caching + Fallback Fadiga 70%",
                                                        "dia9_11":  "Heatmap urgencia temporal + Micro-Simulado diario + Modo Sedes-DF domingos",
                                                        "dia12_13":  "Contador Pontos Ponderados + Notificacao push domingo",
                                                        "dia14_15":  "OFFBOARDING_RUNBOOK + SaaS Readiness Audit + P-013 soberania"
                                                    },
                                    "decisoes_fixadas":  {
                                                             "fonte_questoes":  "Claude API â€” sem scraping (P-003)",
                                                             "auth":  "single-user â€” sem login complexo",
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
                                                              "dia2":  "10 questoes avaliadas por Eduardo â€” rubrica media \u003e= 4/5",
                                                              "dia5":  "Feed exibe plano correto 7 dias com proporcao correta",
                                                              "dia8":  "Ingrid responde 10 questoes â€” progresso salvo â€” fallback testado",
                                                              "dia11":  "Heatmap correto + simulado domingo completo",
                                                              "dia15":  "Ingrid com acesso admin proprio Supabase"
                                                          },
                                    "precificacao":  {
                                                         "valor_gerado_candidato":  "R$ 9.750 (tempo + probabilidade aprovacao)",
                                                         "servico_personalizado":  "R$ 2.500 por candidato externo",
                                                         "licenca_acesso_saas":  "R$ 197 por ciclo do concurso",
                                                         "saas_b2c_mrr":  "R$ 97/mes x 4 meses = R$ 388 por usuario",
... [truncado -- ver arquivo completo]

================================================================================

## PROTOCOLO VANGUARD (resumo)
---
name: protocolo-vanguard
description: ativa o Modelo PENTALATERAL IAH para QUALQUER projeto — ecommerce, app, site, SaaS, modelo de negócio, automação, IA, API. O Músculo opera como Arquitecto-Mestre e membro ativo do Conselho colaborativo. Executar sempre que o Diretor disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo PENTALATERAL IAH
**Versão da Skill:** 6.2 — Universal · Colaborativo · Qualquer projeto · Qualquer operador · 7 Leis Soberanas + 8 Frameworks de Gestão ativos · Intelligence Compounding · Protocolo de Imunidade do Conselho (2026-05-14) · **5º Membro: Embaixador + P-031 (2026-05-18) · 12 novas DEF + P-052/053/054/055 (2026-05-23) · DEF-E-8 + Pipeline DECISOES JSON + P-056/057/058 (2026-05-24)**

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
> o Pentalateral — Diretor + Estrategista + Auditor + Músculo — é o conselho.
> O cliente traz o problema. O conselho delibera. O Músculo entrega.

---

## CONFIGURAÇÃO DO OPERADOR

> Preencher uma vez por operador. Ao copiar para outro projeto ou outro operador, atualizar esta seção.
> Os valores abaixo são a configuração ativa deste Pentalateral.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pentalateral — CONFIGURAÇÃO ativa
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
  └── Papel: Inteligência persistente do cliente. Memória entre sessões. 17 mandatos V2.0 (D1/D2/D3).
  └── Único membro com acesso ao relacionamento real acumulado — o Músculo não tem isso.
  └── Como ativar: ir_ao_embaixador.ps1 -cliente [NOME] → clipboard + browser automáticos.
... [truncado -- ver arquivo completo]

================================================================================

## MEMORIA MAIS RECENTE -- MEMORIA_V6_INGRID.md
# MEMÓRIA V6 — PROJETO INGRID
> Diretriz V6 · Loop 5 (Gemini) / Loop 6 (interno) · Engajamento Pós-Entrega
> Gerada em 2026-05-28 — encerramento do ciclo DIRETRIZ V6

---

## ESTADO TÉCNICO ENTREGUE

**Stack ativa:** PWA Vanilla JS + Supabase (projeto próprio Ingrid yjqvjhezwhepwomukudt) + Claude API (Haiku) · Deploy GitHub Pages
**Versão:** v20 · Commits: 14e041f (v19) + a2b42f5 + 86e112b (v20)
**URL produção:** https://subdiretormnmsgm-commits.github.io/vanguard/

### Features entregues neste ciclo (DIRETRIZ V6):

| Feature | Status | Commit | Observação |
|---|---|---|---|
| F-1 Saudação Noturna Dinâmica (E-5) | Entregue | 14e041f | `getHours()` → Bom dia/tarde/noite. Após 18h: "N questões te esperam" |
| F-2 G-5 Distração Vingativa Silenciosa | Entregue | a2b42f5 | Pegadinhas injetadas no feed sem label visível — Ingrid não percebe o padrão |
| F-4 Gatilho Temporal 19h45 + pg_cron | Entregue | a2b42f5 | Edge Function `notificar-progresso` + cron job Supabase. Fallback: Push Mágico de Oz |
| F-5 Modo Véspera (M-3) | Entregue | 14e041f | Toggle no Dashboard Eduardo · `modo_vespera:true` enviado ao `feed-diario` · ativar 2026-08-30 |
| F-6 Relatório Semanal WhatsApp (M-4 + E-3) | Entregue | a2b42f5 | Edge Function `relatorio-semanal` · Haiku API · template semanal + % acerto Quadrix 7 dias |
| F-7 Raio-X SVG + G-4 Brasão Semanal | Entregue | 14e041f | html2canvas export PNG · brasão calculado (semanas desde 2026-05-15) |
| F-8 Termômetro da Aprovação (M-2) | Entregue | 14e041f | Widget fim de sessão: `Nota Projetada vs Linha de Corte` · reusa `get_heatmap_disciplinas` |

### DADOS-WATCH — VERDE (2026-05-28):
- 1 user_id distinto: `00000000-0000-0000-0000-000000000001`
- 102 registros em `progresso_usuario` · nenhuma contaminação
- SM-2, Heatmap e Termômetro lendo dados corretos

### LEGAL-WATCH — VERDE (2026-05-27):
- Reassinatura física do Termo de Uso confirmada
- Token Supabase CLI exposto revogado pelo Diretor

---

## DECISÕES FIXADAS (não reverter sem veredito)

| Decisão | Princípio | Razão |
|---|---|---|
| G-5 Silenciosa sem label | P-031 Embaixador | "Vingativa" visível = ansiedade para Ingrid (H-7 lê com atenção literal) |
| Modo Véspera ativado por Eduardo, não Ingrid | P-031 Embaixador | Transição invisível — Ingrid não percebe mudança de mode |
| F-8 aguarda DADOS-WATCH | DELIBERAÇÃO V6 | Nota projetada inválida se user_id errado — verde confirmado |
| Gatilho às 19h45 | N-1 validado | Horário modal de sessão noturno (~20h) confirmado verbatim |

### VETADOS PERMANENTEMENTE (não reabrir):
- G-3 Bloqueio TTL — churn silencioso garantido
- G-1 Simulador Invalidação Parcial — frustração artificial
- M-1 Streak com Punição — abandono sem reclamação

---

## ALERTAS ATIVOS

| Alerta | Severidade | Ação |
|---|---|---|
| GitHub Pages push bloqueado (secret no histórico — já revogado) | Amarelo | Eduardo: link de desbloqueio no GitHub Security |
| Edge Functions Supabase não deployadas via CLI (auth pendente) | Amarelo | `! supabase login` + `deploy --project-ref yjqvjhezwhepwomukudt` |
| Ingrid não conhece candidatos — indicação = zero curto prazo | Pipeline | Pitch SaaS ao verbalizar uso ativo — janela: após DADOS-WATCH + LEGAL-WATCH |
| Sentinel Report Valdece | 2026-06-02 | Separado de Ingrid — não contaminar contextos |

---

## ESTADO DOS GATES

| Gate | Status |
|---|---|
| Dias 1-15 completos | Todos APROVADOS (último: 2026-05-26) |
| DADOS-WATCH user_id | VERDE 2026-05-28 |
| LEGAL-WATCH | VERDE 2026-05-27 |
| v20 em produção | Deploy ativo GitHub Pages |

---

## PRÓXIMO LOOP (Loop 6 — Gemini V7)

**Triggers:** DADOS-WATCH VERDE confirmado · Ingrid usando diariamente · "Gostei bastante. Amanhã volto para atacar mais" (2026-05-24)
**Temperatura:** 7.5/10 — VERDE SUSTENTADO
**Foco sugerido Loop 6:**
- SaaS Readiness Audit completo — readiness para segundo cliente
- Pitch plano mensal R$97/mês quando Ingrid verbalizar progresso
- Semente pós-aprovação E-4: "quando você passar, vou ter o sistema pronto para quem você indicar"
- Monitorar engajamento com F-6 (Relatório Semanal WhatsApp)

**Pendências antes do Loop 7:**
- [ ] Deploy Edge Functions via `supabase login + deploy`
- [ ] Desbloquear GitHub Pages push
- [ ] Eduardo: script E-4 ("quando você passar...") na próxima mensagem pós-DADOS-WATCH
- [ ] Eduardo identifica qual feature trouxe Ingrid de volta (E-1) — pergunta casual
- [ ] Wipe & Sync NotebookLM antes do Loop 7

---

*Músculo — Pentalateral IAH — 2026-05-28*


================================================================================

## RELATORIO EVOLUTIVO -- relatorio_evolutivo_V6_INGRID.md
# RELATÓRIO EVOLUTIVO V6 — PROJETO INGRID
> Diretriz V6 · Loop 5 (Gemini) / Loop 6 (interno) · Fechamento 2026-05-28
> Análise de negócio + 5 ideias disruptivas para Loop 6 (Gemini V7)

---

## RESUMO EXECUTIVO

O ciclo da DIRETRIZ V6 transformou o app de uma ferramenta de entrega em um **sistema de engajamento autônomo**. Sete features novas (F-1 a F-8) foram implementadas sem intervenção da Ingrid — ela simplesmente continuou usando e o sistema passou a responder de forma mais inteligente. O DADOS-WATCH confirmou integridade total dos dados (102 registros, 1 user_id). O maior risco do ciclo — churn silencioso entre entrega e aprovação — foi endereçado com ferramentas passivas que não exigem disciplina da usuária.

---

## SWOT — ESTADO ATUAL (pós-DIRETRIZ V6)

### Forças
- **Sistema autônomo de engajamento:** push 19h45, relatório semanal WhatsApp, saudação noturna e distração vingativa operam sem que Eduardo ou Ingrid façam nada.
- **Termômetro objetivo:** F-8 responde "se a prova fosse hoje, você aprovaria?" — converte dados frios em urgência real.
- **Modo Véspera pronto:** flag no Dashboard aguarda ativação em 2026-08-30 — zero build adicional na véspera.
- **Export visual:** Raio-X PNG + Brasão SVG = prova social para segundo cliente e motivação interna para Ingrid.
- **Integridade de dados confirmada:** DADOS-WATCH VERDE — SM-2, Heatmap e Termômetro lendo dados corretos.

### Fraquezas
- **Edge Functions não deployadas via CLI:** F-4 (cron 19h45) e F-6 (relatório semanal) dependem de `supabase login` pendente. Enquanto isso, operam via Push Mágico de Oz manual.
- **GitHub Pages push bloqueado:** secret revogado mas unblock pendente no GitHub Security — cada deploy exige workaround.
- **Ausência de analytics de comportamento:** sabemos que Ingrid usa, mas não sabemos quais features ela efetivamente toca. F-7 (export) e F-8 (termômetro) podem ter zero cliques.
- **Pipeline de indicação inexistente:** Ingrid não conhece candidatos relevantes — upsell depende 100% do progresso dela, não de rede.

### Oportunidades
- **Janela de pitch SaaS aberta:** "Gostei bastante. Amanhã volto para atacar mais" (2026-05-24) = temperatura suficiente para proposta R$97/mês quando ela verbalizar progresso.
- **Semente pós-aprovação (E-4):** uma linha no próximo WhatsApp de Eduardo — "quando você passar, vou ter o sistema pronto para quem você indicar" — planta o pipeline sem custo.
- **Motor replicável em 3 dias:** o próximo concurso Quadrix pode ser onboardado com o mesmo stack. O tempo de setup caiu de 15 dias para 3. Ingrid é o caso de sucesso documentável.
- **Relatório semanal como vitrine:** o WhatsApp automático que Ingrid recebe pode virar argumento de venda para próximo cliente ("ela recebe isso toda semana, sem você fazer nada").

### Ameaças
- **Churn por platô de motivação:** features de engajamento passivas funcionam para manter, não para reativar. Se Ingrid parar por 5+ dias, o app não tem gatilho de reativação ativo.
- **Concurso sem data confirmada:** SEDES-DF 2026 ainda inédito — urgência pode erodir se a data atrasar para 2027.
- **Dependência de WhatsApp manual (curto prazo):** F-4 e F-6 operam via Mágico de Oz até deploy CLI — cada domingo Eduardo precisa enviar manualmente se o cron falhar.

---

## PDCA — AVALIAÇÃO DO CICLO DIRETRIZ V6

### PLAN (o que foi planejado)
- 8 features baseadas em P-037 DELIBERAÇÃO V6 (2026-05-27): F-1 a F-8
- Gate bloqueante: DADOS-WATCH antes de qualquer build (user_id correto?)
- Sequência: F-1 → F-3 → F-8 → F-2 → F-7 → F-6 → F-4 → F-5

### DO (o que foi executado)
- F-1 Saudação Noturna: entregue (v19 · commit 14e041f)
- F-2 Distração Vingativa Silenciosa: entregue (v20 · commit a2b42f5)
- F-4 Gatilho Temporal 19h45 + pg_cron: entregue (commit a2b42f5) — deploy CLI pendente
- F-5 Modo Véspera: entregue (14e041f) — ativação agendada 2026-08-30
- F-6 Relatório Semanal WhatsApp Haiku: entregue (a2b42f5) — deploy CLI pendente
- F-7 Raio-X SVG + Brasão: entregue (14e041f)
- F-8 Termômetro da Aprovação: entregue (14e041f) — dependia de DADOS-WATCH
- DADOS-WATCH: executado e VERDE (102 registros, 1 user_id)
- F-3 Linha de Corte Fantasma: já estava em V5 — reutilizada por F-8

### CHECK (o que funcionou e o que não funcionou)
- **Funcionou:** DELIBERAÇÃO P-037 como plano de build — sequência inviolável executada sem desvio
- **Funcionou:** F-2 (distração silenciosa) — Ingrid não percebe o padrão, sem label, sem ansiedade
- **Funcionou:** F-8 Termômetro — reusa infraestrutura existente (get_heatmap_disciplinas + EDITAL_DIST), custo zero
- **Funcionou:** P-088 (template externo) — gerar_artefato_embaixador.ps1 sem falha de parsing PS5.1
- **Funcionou:** P-089 (PASSO3 auto-regenerado) — bug de documento desatualizado resolvido estruturalmente
- **Não funcionou:** Deploy Edge Functions via CLI — `supabase login` pendente, F-4 e F-6 operam manualmente
- **Não funcionou:** PASSO3_GEMINI.md estava em Loop 5 — causou tentativa de ir ao Gemini quando não era necessário
- **Não funcionou:** Conflito WIP_BOARD (`status` desatualizado vs `loop_fase_atual` atualizado) — Diretor viu estado errado

### ACT (o que muda no próximo loop)
- Deploy CLI Supabase antes de qualquer feature que dependa de Edge Function ou cron
- P-089 acoplado: PASSO3 nunca mais desatualizado
- WIP_BOARD: campo `status` atualizado pelo script, não manualmente

---

## 5W2H — PRÓXIMO LOOP (Loop 6 — Gemini V7)

| Dimensão | Resposta |
|---|---|
| **What** | SaaS Readiness Audit + resolver bloqueios técnicos + ativar pipeline comercial |
| **Why** | F-4 e F-6 operam manualmente enquanto deploy CLI pendente. Pitch SaaS aberto — temperatura da Ingrid sustentada. |
| **Who** | Eduardo (WhatsApp E-4 + E-1) · Músculo (deploy CLI + audit) · Embaixador (temperatura + pipeline) |
| **When** | 2026-05-29 a 2026-06-01 (antes do Sentinel Valdece em 02-06) |
| **Where** | Terminal local (`supabase login`) · GitHub Security (unblock Pages) · Chat Ingrid (WhatsApp E-4) |
| **How** | `! supabase login` → `supabase functions deploy` → GitHub unblock → audit RLS + uso real |
| **How much** | 2h técnico · $0 infra · Pitch: R$97/mês → MRR potencial |

---

## 5 IDEIAS DISRUPTIVAS [M-1 a M-5] — Para o Gemini V7 processar

**[M-1] Painel de Uso Real para Eduardo (não para Ingrid)**
Dashboard interno que mostra: Ingrid abriu o app hoje? Qual feature tocou? Quanto tempo ficou? F-7 (export) teve cliques? Eduardo enxerga o comportamento real sem perguntar — e sabe quando acionar o WhatsApp de reativação antes que o churn aconteça.

**[M-2] Gatilho de Reativação após 5 dias sem sessão**
Se Ingrid não abre o app por 5 dias, o sistema envia automaticamente: "Você estava indo muito bem — faltam N dias para a prova. Só 10 questões hoje." Uma mensagem, sem sequência. Reativação passiva — Eduardo não precisa monitorar.

**[M-3] Score de Consistência Semanal (não de acertos)**
Métrica alternativa ao % de acerto: quantos dias da semana Ingrid abriu o app e fez pelo menos 5 questões? Exibido no relatório semanal como "Você foi consistente em X/7 dias." Consistência é mais previsível de aprovação do que acerto isolado.

**[M-4] Modo Apresentação — Portfólio SaaS**
Um link de 1 página (sem login, somente leitura) que Eduardo envia para prospectos: mostra o dashboard anonimizado de Ingrid com números reais. "Veja como funciona para um candidato real." Custo zero — o banco já tem os dados.

**[M-5] Audit Trail de Churn Risk — Alerta Automático no Telegram**
Se Ingrid não abre em 3 dias E o cron de notificação falhou E o relatório semanal não foi enviado — o Telegram do Eduardo recebe: "CHURN RISK — Ingrid · 3 dias sem sessão · Push falhou." Radar de churn ativo sem dashboard extra.

---

## ANÁLISE COMERCIAL

**O que este ciclo significou para o negócio:**
A DIRETRIZ V6 transformou o produto em um sistema que **trabalha mesmo quando ninguém trabalha**. Isso é o argumento de venda definitivo: "O app acompanha a Ingrid 24h. Você não precisa fazer nada — só receber o relatório no domingo." Para o segundo cliente, o onboarding é 3 dias. Para o terceiro, 1 dia. A inteligência acumulada nos LEDGER e nas Skills é o diferencial que nenhum concorrente tem.

**Risco de MRR no curto prazo:** Baixo — Ingrid está usando e engajada. O risco real é o cron não disparar (F-4 + F-6 pendentes de deploy CLI) e Ingrid não receber o relatório no primeiro domingo — primeira impressão de "sistema que falha."

**Janela comercial aberta:** A fala "Amanhã volto para atacar mais" + DADOS-WATCH VERDE + todas as features ativas = momento ideal para o script E-4. Eduardo planta agora, colhe quando ela passar.

---

*Músculo — Pentalateral IAH — 2026-05-28*


================================================================================

## MISSAO DESTA SESSAO -- PASSO3_GEMINI (INGRID)
# PASSO3 — GEMINI — INGRID LOOP 7
> Preparado automaticamente pelo Músculo · 2026-05-28 · Levar ao Estrategista após MEMORIA + relatorio do Loop 6

---

## IDENTIDADE DO ESTRATEGISTA

Você é o Estrategista do Pentalateral IAH — sistema de 5 inteligências: Diretor (Eduardo) + Músculo (Claude Code) + Estrategista (você) + Auditor (NotebookLM) + Embaixador (Claude Projects).

Sua função: emitir uma DIRETRIZ com nome exato de skill + 5 ideias disruptivas [G-1 a G-5].
A DIRETRIZ guia o NotebookLM na geração da skill. O nome da skill define o elo entre os 3 sócios.

---

## CONTEXTO DO PROJETO

**Cliente:** INGRID
**Status atual:** Loop 6 (Gemini V7) -- iniciando -- SaaS Readiness + pipeline comercial
**Dias concluídos:** dia1_schema_edge | dia2_gate_questoes | dia3_5_feed_sm2_pwa | dia6_8_tutor_fallback | dia9_11_heatmap_simulado | dia12_contador_socratica_vacina_push_cb
**Próximo gate:** NotebookLM -- Skill ingrid-v7.md

> ⚠️ Este PASSO3 foi regenerado automaticamente. O Músculo deve revisar e completar a seção MISSÃO abaixo com as decisões específicas do Loop 7.

---

## MISSÃO DO LOOP 7

> [MÚSCULO: completar esta seção com as features aprovadas na DELIBERAÇÃO_LOOP_V7 antes de enviar ao Gemini]

### O que construir:
[MÚSCULO: listar features aprovadas na P-037 para este loop]

### Por que agora:
[MÚSCULO: contexto de urgência — deadline, comportamento do cliente, gate desbloqueado]

### Incógnita crítica não resolvida:
[MÚSCULO: listar perguntas abertas que o Estrategista deve endereçar]

---

## FORMATO DE RESPOSTA ESPERADO

```
Diretriz Estratégica V7 — Projeto INGRID — Loop 7

[NOME DA SKILL]: ingrid-v7

[PARA O NOTEBOOKLM]:
...4 partes obrigatórias...
Skill nomeada: ingrid-v7

[PARA O MÚSCULO]:
...diretrizes técnicas de build...

[G-1 a G-5]: 5 ideias disruptivas do Estrategista

[ALERTA GEMINI]: qualquer risco que o Músculo possa estar subestimando
```

**Elo obrigatório:** o nome `ingrid-v7` deve aparecer idêntico em [PARA O NOTEBOOKLM] e [PARA O MÚSCULO].

---

## DOCUMENTOS ANEXOS (arrastar no chat do Gemini)

1. `CLIENTES/INGRID/HISTORICO/MEMORIA_V6_INGRID.md` — contexto do Loop 6
2. `CLIENTES/INGRID/HISTORICO/relatorio_evolutivo_V6_INGRID.md` — análise do Loop 6
3. `INTELLIGENCE_LEDGER.md` — princípios ativos
4. `CLIENTES/WIP_BOARD.json` — estado dos projetos

> **Como usar:** colar este documento no chat do Gemini (não anexar). Arrastar os 4 documentos acima como anexo.


