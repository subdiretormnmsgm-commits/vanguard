ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-05-23 20:08
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
c43f2fa feat(embaixador): dimensão de mercado expandida — BLOCO 6 + PARTE 3 em todos os PASSO7 + Conselheiro da Vanguard
b6e4ab3 docs(passo7): DEF-E-5/6/7 + 6 BLOCOS em Valdece e Template — Loop 7 + TEMPERATURA_PONDERADA score
d97404c feat(scripts): verificar_consistencia_projetos.ps1 — valida skill-alvo em PASSO3/PASSO5/PASSO7 de todos os projetos

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
                                                           "dia6_8_tutor_fallback",
                                                           "dia9_11_heatmap_simulado"
                                                       ],
                                    "delivery_dates":  {
                                                           "dia1_2":   "2026-05-15",
                                                           "dia3_5":   "2026-05-17",
                                                           "dia6_8":   "2026-05-19",
                                                           "dia9_11":  "2026-05-20"
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
... [truncado -- ver arquivo completo]

================================================================================

## PROTOCOLO VANGUARD (resumo)
---
name: protocolo-vanguard
description: ativa o Modelo PENTALATERAL IAH para QUALQUER projeto — ecommerce, app, site, SaaS, modelo de negócio, automação, IA, API. O Músculo opera como Arquitecto-Mestre e membro ativo do Conselho colaborativo. Executar sempre que o Diretor disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo PENTALATERAL IAH
**Versão da Skill:** 6.1 — Universal · Colaborativo · Qualquer projeto · Qualquer operador · 7 Leis Soberanas + 8 Frameworks de Gestão ativos · Intelligence Compounding · Protocolo de Imunidade do Conselho (2026-05-14) · **5º Membro: Embaixador + P-031 (2026-05-18) · 12 novas DEF + P-052/053/054/055 (2026-05-23)**

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
  └── Papel: Inteligência persistente do cliente. Memória entre sessões. 11 mandatos.
  └── Único membro com acesso ao relacionamento real acumulado — o Músculo não tem isso.
  └── Como ativar: ir_ao_embaixador.ps1 -cliente [NOME] → clipboard + browser automáticos.
... [truncado -- ver arquivo completo]

================================================================================

## MEMORIA MAIS RECENTE -- MEMORIA_V4_INGRID.md
# MEMÓRIA V4 — PROJETO INGRID
> Loop 4 · Dias 9-11 · Gate Dia 11 APROVADO 2026-05-20
> Gerada retroativamente em 2026-05-23 (Loop 4 executado sem MEMORIA formal — P-045 sanado)

---

## ESTADO TÉCNICO ENTREGUE

**Stack ativa:** PWA Vanilla JS + Supabase + Claude API (Haiku + Sonnet) · Deploy GitHub Pages

### O que foi construído (Dias 9-11):
| Componente | Status | Observação |
|---|---|---|
| RLS + auto-login invisível | ✓ Entregue | Backend multi-usuário. Ingrid sem tela de login. |
| Clickwrap V2 ("termo_v2_18_05") | ✓ Entregue | Erro de data corrigido (era 30/05, passou a 18/05). P-023 sanado. |
| `horario_inicio_sessao` + `ttl_resposta_ms` | ✓ Entregue | Campos de telemetria adicionados. |
| RPC `progresso_semanal` (M-2) | ✓ Entregue | Dados para mensagem semanal WhatsApp. |
| Snapshot diário `metricas_diarias` (M-4) | ✓ Entregue | Cron job ativo. |
| Fallback graceful Claude API | ✓ Entregue | Claude lento → questão cached, zero erro visível. |
| RPCs Heatmap (taxa acerto por disciplina) | ✓ Entregue | Gate CLI aprovado Dia 10. |
| UI Mapa de Soberania + Radar de Foco | ✓ Entregue | Linguagem conquista. Frase: "Esse é seu terreno." |
| Streak feedback (E-3) | ✓ Entregue | Streak ≥ 3: "Você acertou as últimas [N]..." |
| Micro-Simulado Dominical (Penalidade Quadrix) | ✓ Entregue | Condicional check-in 21/05 — Ingrid estuda domingo. |
| Distrator oculto no SM-2 | ✓ Entregue | Reforço de padrão de erro sem confronto visual. |
| TTI silencioso (`ttl_resposta_ms`) | ✓ Entregue | Registrado sem feedback punitivo. |
| Burn Rate por sessão (M-3) | ✓ Entregue | > 20 chamadas API → rate limiting silencioso. |

### Banco de dados:
- **460 questões** · 13 disciplinas · Cargo 202 (Técnico Administrativo — Instituto Quadrix)
- Schema: multi-usuário com RLS · Clickwrap V2 gravado
- Telemetria: `horario_inicio_sessao`, `ttl_resposta_ms`, `metricas_diarias`

---

## DECISÕES FIXADAS (não reverter sem veredito)

| Decisão | Princípio | Razão |
|---|---|---|
| Zero tela de login para Ingrid | P-045 | Interromperia sessão ativa — abandono silencioso |
| Micro-Simulado só recicla questões SM-2 | P-038 | Banco fixo em 460 — inéditas esgotam o pool |
| Persona Sargento = DESCARTADO | E-1 (Embaixador) | Confronto verbal → abandono sem aviso |
| Distrator visível repetitivo = DESCARTADO | E-1 (Embaixador) | Frustração sem nomeação → churn silencioso |
| Heatmap linguagem conquista (Mapa de Soberania) | G-4 (Gemini) | Ingrid movida por confirmação, não ameaça |

---

## ALERTAS ATIVOS PARA O LOOP 5

- **[P-045]** RLS no backend — Ingrid NUNCA vê tela de login
- **[P-038]** Contador de Pontos só usa dados reais do banco — não gerar dados fictícios
- **[P-003]** Sem scraping — questões só via Claude API
- **[P-007]** Validar toda RPC/Edge via CLI antes da UI
- **[P-023]** Clickwrap V2 ativo — não reverter nem criar V3 sem veredito
- **[Burn Rate]** `BURN_RATE_DAILY_LIMIT_USD=5.00` antes de qualquer call API
- **[Telemetria]** `horario_inicio_sessao` disponível — usar no Contador para segmentação temporal

---

## TEMPERATURA DA CLIENTE

- **Status:** VERDE FRÁGIL → **VERDE CONSOLIDANDO** (hábito > 2 semanas pós Loop 4)
- Ingrid usa diariamente. Reporta bugs de formatação e lê enunciados de forma literal (mindset Quadrix).
- Engajamento no Micro-Simulado dominical: a confirmar no próximo check-in.
- Não reclama quando frustrada — abandona silenciosamente. Embaixador monitora.

---

## PRÓXIMOS PASSOS (Loop 5 — Dias 12-13)

1. **Contador de Pontos Ponderados** — exibir pontuação simulada (peso 1 correto/errado + peso 2 correto/errado) em header ou dashboard. Base: `progresso_usuario` + `plano_build` + pesos do edital.
2. **Notificações Push dominicais** — lembrar Ingrid do Micro-Simulado. Viabilidade iOS Safari (PWA) precisa teste antes do build.

**Incógnita crítica:** Push funciona em iOS Safari? (limitação estrutural do PWA — confirmar antes de prometer à Ingrid.)


================================================================================

## RELATORIO EVOLUTIVO -- relatorio_evolutivo_V4_INGRID.md
# RELATÓRIO EVOLUTIVO V4 — PROJETO INGRID
> Loop 4 · Dias 9-11 · Gate Dia 11 APROVADO 2026-05-20
> Gerado retroativamente em 2026-05-23

---

## SWOT DO LOOP 4

### Forças
- **Heatmap (Mapa de Soberania)** entregue e funcional — linguagem de conquista, não ameaça. Diferencial de pitch real.
- **Micro-Simulado Dominical** com penalidade Quadrix — treino de pressão alinhado ao formato da banca.
- **RLS + auto-login invisível** — Ingrid sem fricção. Backend pronto para scale 1→500 usuárias.
- **Telemetria comportamental** (`horario_inicio_sessao`, `ttl_resposta_ms`, `metricas_diarias`) ativa — dados para segmentação futura.
- **Burn Rate Shield** operacional — risco de estouro de API mitigado.

### Fraquezas
- **MEMORIA_V4 não foi gerada no fechamento real do Loop 4** — sanada retroativamente (P-045 não seguido na transição 11→12).
- **Loop 3 / ingrid-v3.md** nunca gerados formalmente pelo NotebookLM — ingrid-v4 assumiu continuidade sem skill de transição.
- **Horário de pico da Ingrid ainda não confirmado** — dado crítico para eficácia do Push dominical.
- **Push iOS Safari** — limitação técnica de PWA não testada antes do planejamento do Loop 5.

### Oportunidades
- **Contador de Pontos Ponderados** (Loop 5) fecha o ciclo de progresso visível — responde objetivamente "quanto valho nessa prova?"
- **Raio-X Pessoal** (G-5, Loop 6) com 15+ dias de dados tem potencial de ser o maior gerador de indicação.
- **460 questões com telemetria** = corpus de comportamento real. Argumento de pitch: "feito para quem estuda depois das 20h."
- **Schema multi-usuário pronto** — monetização SaaS em 1 configuração de admin.

### Ameaças
- **Deadline 2026-05-30** — 7 dias para Dias 12-15 + offboarding. Margem zero para bugs de estimativa.
- **Hábito em VERDE FRÁGIL** — menos de 3 semanas de uso. Uma interrupção pode desfazer o ganho comportamental.
- **Push como feature visível** — se não funcionar em iOS (limitação PWA), quebra expectativa gerada.

---

## PDCA DO LOOP 4

### Plan
- Construir Heatmap + Micro-Simulado + RLS como entregáveis principais.
- Gate de qualidade: Heatmap correto via CLI + simulado domingo funcional.

### Do
- **Acertos:** Todos os 13 componentes listados na MEMORIA_V4 entregues. Convergência Gemini (G-4) + Auditor (N-5) + Embaixador (E-3) no Mapa de Soberania — decisão com 3 votos independentes.
- **Falha de processo:** MEMORIA e relatorio não gerados no fechamento — detectado no Loop 5 via P-045.

### Check
- Gate Dia 11 APROVADO 2026-05-20.
- Temperatura da cliente: VERDE FRÁGIL → consolidando.
- Micro-Simulado dominical: funcionando conforme check-in 21/05.

### Act
- P-045 registrado como active alert: fechar todo loop com MEMORIA + relatorio antes de iniciar o próximo.
- Loop 5 desbloqueado após geração retroativa dos artefatos.

---

## 5 IDEIAS DISRUPTIVAS DO MÚSCULO [M-1 a M-5]

| # | Ideia | Loop |
|---|---|---|
| M-1 | **Modo Sedes-DF Chrome** — limitar interface a 1 questão por vez + timer fixo (simula tela de prova real) | Loop 5 ou 6 |
| M-2 | **Contador de Pontos como argumento de venda** — gerar imagem SVG com "Simulado: você tiraria X pontos de Y" compartilhável no WhatsApp | Loop 5 |
| M-3 | **Push adaptativo por horário de pico** — se `horario_inicio_sessao` mostra que Ingrid estuda 20h-22h, Push vai às 19h50 | Loop 5 |
| M-4 | **Raio-X de Armadilhas Quadrix** — agrupar questões erradas por tipo de pegadinha (prescinde / salvo / nunca) para treino cirúrgico | Loop 6 |
| M-5 | **Relatório semanal automatizado** — RPC `progresso_semanal` já existe · Eduardo envia via WhatsApp · Argumento de SaaS: "resumo automático toda segunda" | Loop 5 |

---

## INDICADORES DE NEGÓCIO

| Métrica | Valor |
|---|---|
| Valor gerado/candidato | R$ 9.750 (tempo + probabilidade aprovação estimada) |
| Serviço personalizado (externo) | R$ 2.500/candidato |
| Licença SaaS por ciclo | R$ 197 |
| SaaS B2C MRR | R$ 97/mês × 4 meses = R$ 388/usuária |
| Meta SaaS ciclo Sedes-DF | 500 usuárias = R$ 194.000 |
| Prazo para monetização | Após offboarding da Ingrid (pós-30/05) + SaaS Readiness Audit (Dias 14-15) |


================================================================================

## MISSAO DESTA SESSAO -- PASSO3_GEMINI (INGRID)
# PASSO3 — GEMINI — INGRID LOOP 5 — DIAS 12-13
> Preparado pelo Músculo · 2026-05-23 · Levar ao Estrategista após MEMORIA + relatorio do Loop 4

---

## IDENTIDADE DO ESTRATEGISTA

Você é o Estrategista do Pentalateral IAH — sistema de 5 inteligências: Diretor (Eduardo) + Músculo (Claude Code) + Estrategista (você) + Auditor (NotebookLM) + Embaixador (Claude Projects).

Sua função: emitir uma DIRETRIZ com nome exato de skill + 5 ideias disruptivas [G-1 a G-5].
A DIRETRIZ guia o NotebookLM na geração da skill. O nome da skill define o elo entre os 3 sócios.

---

## CONTEXTO DO PROJETO

**Cliente:** Ingrid
**Projeto:** Ferramenta de Estudo — Concurso Sedes-DF (TDAS Cargo 202 · Instituto Quadrix)
**Stack:** PWA Vanilla JS + Supabase + Claude API (Haiku + Sonnet)
**URL:** GitHub Pages (live)
**Prova final:** 2026-09-06

### Estado atual verificado (2026-05-23):
- Dias 1-11 **CONCLUÍDOS** (confirmado em disco)
- Loop 4 = **Gate Dia 8 APROVADO 2026-05-19** · Skill ativa: `ingrid-v4.md`
- Banco: **460 questões** · 13 disciplinas · Cargo 202
- Temperatura da cliente: **VERDE FRÁGIL** (usa diariamente, mas hábito < 2 semanas)
- Sistema funcional: Feed 70/30 + Tutor Socrático 3 níveis + Heatmap + Micro-Simulado dominical

### O que foi construído nos Dias 9-11 (Loop 4):
1. RPCs Supabase para Heatmap por disciplina (agrupando progresso_usuario Peso 2)
2. UI Heatmap — linguagem de conquista ("território soberano"), não ameaça
3. Micro-Simulado Dominical — timer + penalidade Quadrix (1 errada anula 1 certa) + recicla questões SM-2
4. Clickwrap V2 corrigido (termo_v2_18_05)

### Restrições técnicas ativas (VETO total — não reverter):
- **P-045:** Zero tela de login para a Ingrid — acesso contínuo/invisível
- **P-038:** Micro-Simulado só recicla questões já vistas (SM-2), nunca consome inéditas
- **P-003:** Sem scraping de terceiros — questões via Claude API apenas
- **Burn Rate:** `BURN_RATE_DAILY_LIMIT_USD=5.00` antes de qualquer call à API
- **P-007:** Validar RPC/Edge Function via CLI antes de qualquer UI

---

## MISSÃO DO LOOP 5 — DIAS 12-13

### O que construir:
1. **Contador de Pontos Ponderados** — exibir pontuação simulada baseada no desempenho real (peso 1 e peso 2 corretos vs. errados), de forma visível no header ou dashboard
2. **Notificações Push** — lembrete no domingo para o Micro-Simulado Sedes-DF

### Por que agora:
- Ingrid entra na fase de "o que valho nessa prova?" — o contador responde objetivamente
- Micro-Simulado dominical precisa de gatilho externo para virar hábito consolidado
- Deadline 30/05 — Dias 12-13 são os dois últimos dias de feature antes do offboarding

### Incógnita crítica não resolvida:
- Ingrid estuda aos domingos? (Push é inútil no horário errado — confirmar com Eduardo)
- Push via Service Worker funciona em iOS Safari? (limitação técnica conhecida do PWA)

---

## FORMATO DE RESPOSTA ESPERADO

```
Diretriz Estratégica V5 — Projeto Ingrid — Loop 5

[NOME DA SKILL]: ingrid-v5

[PARA O NOTEBOOKLM]:
...4 partes obrigatórias...
Skill nomeada: ingrid-v5

[PARA O MÚSCULO]:
...diretrizes técnicas de build...

[G-1 a G-5]: 5 ideias disruptivas do Estrategista

[ALERTA GEMINI]: qualquer risco que o Músculo possa estar subestimando
```

**Elo obrigatório:** o nome `ingrid-v5` deve aparecer idêntico em [PARA O NOTEBOOKLM] e [PARA O MÚSCULO].

---

## DOCUMENTOS ANEXOS (arrastar no chat do Gemini)

1. `CLIENTES/INGRID/HISTORICO/MEMORIA_V4_INGRID.md` — contexto do Loop 4
2. `CLIENTES/INGRID/HISTORICO/relatorio_evolutivo_V4_INGRID.md` — análise do Loop 4
3. `INTELLIGENCE_LEDGER.md` — princípios ativos (P-001 a P-055)
4. `CLIENTES/WIP_BOARD.json` — estado dos projetos

> **Como usar:** colar este documento no chat do Gemini (não anexar). Arrastar os 4 documentos acima como anexo.

