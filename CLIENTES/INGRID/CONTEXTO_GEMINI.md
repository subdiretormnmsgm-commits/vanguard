ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-06-04 13:17
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
26a119b fix(security): redatar JWT e ANON_KEY em runbook + memorias
4238f87 fix(security): redatar todos os tokens sbp_ em historico -- F-G validado
0fc729c fix(security): redatar token sbp_ em MEMORIA_V5 -- F-G bloqueou push corretamente

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
    "atualizado_em":  "2026-06-01",
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
                                    "status":  "Loop 8 -- iniciando -- Telemetria + RLS + Monetizacao",
                                    "cargo":  "TDAS â€“ TÃ©cnico em Desenvolvimento e AssistÃªncia Social â€“ Especialidade: TÃ©cnico Administrativo (Cargo 202)",
                                    "banca":  "Instituto Quadrix",
                                    "stack":  "PWA + Supabase + Claude API",
                                    "loop_atual":  "Loop 7 CONCLUIDO â€” MEMORIA_V7 + relatorio_V7 + DELIBERACAO_V7 gerados Â· Loop 8 PENDENTE â€” aguarda Gemini PASSO3",
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

## MEMORIA MAIS RECENTE -- MEMORIA_V7_INGRID.md
# MEMÓRIA V7 — PROJETO INGRID
> Diretriz V7 · Loop 7 · SaaS Readiness + Pipeline Comercial
> Gerada em 2026-05-30 — encerramento do ciclo Loop 7

---

## ESTADO TÉCNICO AO ENCERRAR LOOP 7

**Stack ativa:** PWA Vanilla JS + Supabase próprio da Ingrid (yjqvjhezwhepwomukudt) + Claude API · GitHub Pages
**Versão:** v20 · URL: https://subdiretormnmsgm-commits.github.io/vanguard/

### Features ativas em produção (v20):

| Feature | Status |
|---|---|
| F-1 Saudação Noturna Dinâmica | Ativo — "Boa noite, N questões te esperam" |
| F-2 Distração Vingativa Silenciosa | Ativo — sem label visível |
| F-4 Gatilho Temporal 19h45 + pg_cron | Código entregue — **deploy CLI PENDENTE** |
| F-5 Modo Véspera | Ativo — ativar em 2026-08-30 |
| F-6 Relatório Semanal WhatsApp | Código entregue — **deploy CLI PENDENTE** |
| F-7 Raio-X SVG + Brasão Semanal | Ativo — html2canvas export PNG |
| F-8 Termômetro da Aprovação | Ativo — Nota Projetada vs Linha de Corte |
| SM-2 + Heatmap | Ativos — 102 respostas · 1 user_id correto |

### Loop 7 — o que foi planejado mas NÃO construído (bloqueado por D1/D4):

| Feature | Por que não construída |
|---|---|
| F-A Telemetria passiva (evento_uso) | Aguarda deploy CLI (D1 → pós-D4) |
| F-B Painel de uso Eduardo (M-1) | Aguarda F-A (evento_uso) |
| F-C Interceptor RLS silencioso (N-2) | Aguarda deploy CLI |
| F-D View SQL snapshot_ingrid_loop6_golden (N-4) | Pode fazer offline — próxima sessão |
| F-E Alerta Compound Telegram (M-5) | Aguarda F-4/F-6 autônomos |
| F-F Pulse Check Analógico (N-5) | Aguarda F-B (Painel Eduardo) |
| F-G Git Hook pre-push (G-5 + N-3) | Próxima sessão |
| F-H LEGAL-WATCH visual (N-1) | Aguarda F-B (Painel Eduardo) |

### O que foi entregue neste ciclo (ferramentas do processo):

| Ferramenta | Arquivo |
|---|---|
| Gate 0 WIP_BOARD vs disco | `scripts/auditar_consistencia.ps1` |
| Correção rápida WIP_BOARD | `scripts/corrigir_wip.ps1` |
| Gate 9B sync Claude Projects | `scripts/sincronizar_claude_projects.ps1` |
| Dry-run isolamento de tenant | `scripts/test_tenant_isolation.ps1` |
| Síntese do Conselho (estrutura) | `scripts/gerar_sintese_conselho.ps1` |
| Template síntese | `PENTALATERAL_UNIVERSAL/TEMPLATES/scripts/sintese_conselho_template.txt` |
| P-091 inscrito | `INTELLIGENCE_LEDGER.md` linha 1620 |
| Render painel bug fix | `scripts/render_painel.ps1` — injeção automática de campos ausentes |
| WIP_BOARD.md distribuído | `CLIENTES/WIP_BOARD.md` + NOTEBOOKLM_FONTES de cada projeto |

---

## DECISÕES FIXADAS LOOP 7 (não reverter sem novo veredito)

| Veredito | Decisão |
|---|---|
| D1 | Deploy F-4 + F-6 aguarda resolução D4 (GitHub Security) |
| D2 | RLS dry-run → Loop 8 (não urgente neste ciclo) |
| D3 | Debrief casual 31/05 — mensagem no clipboard |
| D4 | GitHub Security — pendência próxima sessão |
| D5 | M-4 Link Demo BLOQUEADO até segunda usuária |
| D6 | Semente E-4 aguarda sessão com maior engajamento verbal de Ingrid |

---

## BLOQUEIOS ATIVOS

| Bloqueio | Causa | Desbloqueio |
|---|---|---|
| Deploy F-4/F-6 (Gate 7.1) | GitHub Security pendente → `supabase login` interativo | Eduardo: link GitHub Security → Músculo deploya |
| GitHub Pages push | Token sbp_ no histórico | Eduardo: link GitHub Security |
| Gate 7.2 RLS dry-run | Movido para Loop 8 | `$env:SUPABASE_SERVICE_ROLE_KEY` + `test_tenant_isolation.ps1` |
| Loop 8 build | Bloqueado por Gate 7.1 | Resolver D4 → D1 em ordem |

---

## ESTADO DOS GATES E WATCHES

| Gate/Watch | Status |
|---|---|
| Todos os dias 1–15 | ✅ APROVADOS — último: dia15 2026-05-30 |
| DADOS-WATCH user_id | ✅ VERDE — 102 respostas · 1 user_id |
| LEGAL-WATCH | ✅ VERDE — reassinatura 2026-05-27 |
| P-013 soberania | ✅ VERDE — Ingrid admin Supabase própria |
| DEPLOY-WATCH F-4/F-6 | ⚠️ ATIVO |
| GITHUB-WATCH | ⚠️ ATIVO |
| DATA-GAP-WATCH | ⚠️ ATIVO — uso 24/05 a 30/05 não confirmado |

---

## TEMPERATURA E PIPELINE

| Campo | Estado |
|---|---|
| Temperatura | 7.5/10 VERDE SUSTENTADO — validar no debrief 31/05 |
| Shift confirmado | H-8: "atacar" = player mindset (P-079) |
| Pitch R$97/mês | Janela aberta — gatilho: 7 dias consecutivos + progresso verbalizado |
| Pipeline de referral | Zero no curto prazo — semear pós-aprovação (D6 aguardando) |
| CHURN-WATCH | DESATIVADO |

---

## PRÓXIMO LOOP (Loop 8)

**Ordem de execução obrigatória:**
1. Eduardo: GitHub Security → desbloqueia push Pages
2. Músculo: `supabase login` + deploy F-4 + F-6 (Gate 7.1)
3. Músculo: `test_tenant_isolation.ps1` (Gate 7.2)
4. Build F-A a F-H em sequência (telemetria → painel → alertas → hooks)
5. Eduardo: debrief casual Ingrid 31/05 (mensagem no clipboard)

**Skill do Loop 8:** `ingrid-v8.md` — gerada após Gemini PASSO3

---

*Músculo — Pentalateral IAH — 2026-05-30*


================================================================================

## RELATORIO EVOLUTIVO -- relatorio_evolutivo_V7_INGRID.md
# RELATÓRIO EVOLUTIVO V7 — PROJETO INGRID
> Loop 7 · SaaS Readiness + Pipeline Comercial · Fechamento 2026-05-30
> SWOT + PDCA + 5W2H + [M-1 a M-5] para Loop 8

---

## RESUMO EXECUTIVO

O Loop 7 foi um ciclo de deliberação, não de build. A barreira técnica (GitHub Security + deploy CLI) bloqueou a construção das features aprovadas, mas o ciclo produziu três ativos estratégicos de alto valor: (1) o Painel de Deliberação com 6 decisões formalizadas pelos 4 sócios, (2) ferramentas de processo que tornam o sistema mais robusto (Gate 0, Gate 9B, render_painel corrigido, P-091), e (3) inteligência do Embaixador que revelou um gap crítico de dados (24/05–30/05 sem registro de uso) antes que se tornasse churn silencioso.

---

## SWOT — ESTADO AO FECHAR LOOP 7

### Forças
- **Sistema autônomo em produção:** F-1, F-2, F-5, F-7, F-8 operam sem intervenção — "o app trabalha mesmo quando ninguém trabalha"
- **Soberania confirmada:** Ingrid admin do próprio Supabase (P-013 VERDE 2026-05-30)
- **Temperatura sustentada:** 7.5/10 sem intervenção ativa do Eduardo — H-8 confirmada (shift de player)
- **Processo mais robusto:** P-091 + Gate 0 + Gate 9B + render_painel bug fix — o sistema detecta suas próprias inconsistências
- **Inteligência do Embaixador consolidada:** 15 inputs deliberados individualmente — novo padrão estabelecido

### Fraquezas
- **Deploy CLI bloqueado:** F-4 (cron 19h45) e F-6 (relatório semanal) ainda manuais — risco real no primeiro domingo
- **GitHub Pages comprometido:** cada deploy exige workaround — velocidade de resposta a bugs reduzida
- **Telemetria ausente:** sem `evento_uso`, Eduardo voa às cegas sobre o que Ingrid efetivamente usa
- **Gap de dados 24/05–30/05:** 6 dias sem registro de uso confirmado — temperatura pode estar desatualizada

### Oportunidades
- **F-6 como argumento de pitch:** relatório semanal autônomo é o melhor argumento para R$97/mês — cada semana de operação autônoma é evidência do produto
- **Debrief 31/05 como gate informal de pitch:** resposta de Ingrid ao check-in define se pitch pode avançar
- **View SQL golden:** 102 registros = business case concreto — "X% em Direito Administrativo, SM-2 calibrado para você"
- **Motor replicável em 3 dias:** onboarding de segunda usuária depende só de RLS validado (Gate 7.2 → Loop 8)

### Ameaças
- **Apagão dominical:** se F-4/F-6 não deployados antes do próximo domingo, primeiro relatório semanal falha — pior momento para a percepção de sistema instável
- **Churn silencioso pós-entrega técnica:** Gate Dia 15 foi tarefa administrativa — Ingrid pode ter sentido abandono sem que Eduardo perceba
- **DATA-GAP:** 6 dias sem registro obrigam debrief antes de qualquer decisão comercial

---

## PDCA — AVALIAÇÃO DO LOOP 7

### PLAN (o que foi planejado)
- Resolver bloqueios técnicos: deploy CLI + GitHub Security
- SaaS Readiness Audit: RLS, telemetria, painel de uso
- Pipeline comercial: debrief casual + semente E-4
- 8 features (F-A a F-H) aprovadas na DELIBERAÇÃO P-037

### DO (o que foi executado)
- DELIBERAÇÃO P-037 completa com 25 inputs + filtro do Embaixador
- Vereditos formalizados via Painel HTML
- Gate 0 (P-091) + Gate 9B + render_painel corrigido
- test_tenant_isolation.ps1 criado (Gate 7.2 pronto para Loop 8)
- D3 mensagem no clipboard (debrief 31/05)
- D1/D2/D4/D6 registrados como pendências — Diretor saiu antes de executar

### CHECK (o que funcionou e o que não funcionou)
- **Funcionou:** Painel de deliberação — 6 decisões formalizadas em 1 fluxo
- **Funcionou:** Embaixador deliberou todos os 15 inputs individualmente — novo padrão validado
- **Funcionou:** render_painel bug fix — campos ausentes injetados automaticamente (problema detectado e resolvido na mesma sessão)
- **Funcionou:** P-091 detectou inconsistência WIP_BOARD vs disco antes de comprometer o processo
- **Não funcionou:** deploy CLI — supabase login interativo bloqueou execução autônoma
- **Não funcionou:** GitHub Security — requer presença física do Diretor no browser

### ACT (o que muda no próximo loop)
- Loop 8 começa com D4 (GitHub Security) → D1 (deploy) → build F-A a F-H
- `gerar_sintese_conselho.ps1` disponível para acelerar P-037
- Gate 0 e Gate 9B protegem o processo de inconsistências silenciosas

---

## 5W2H — LOOP 8

| Dimensão | Resposta |
|---|---|
| **What** | Deploy F-4+F-6 · GitHub Security · Telemetria · Painel Eduardo · Git Hook · View SQL golden |
| **Why** | F-4/F-6 manuais = risco de falha no domingo · Telemetria = decisão informada no pitch · Painel = Eduardo vê sem perguntar |
| **Who** | Eduardo (GitHub Security + debrief) · Músculo (deploy + build F-A a F-H) |
| **When** | Próxima sessão disponível — urgência: antes do próximo domingo |
| **Where** | Terminal (`supabase login`) · GitHub Security · app.js · Edge Functions |
| **How** | D4 → D1 → F-A → F-B → F-C → F-D → F-E → F-F → F-G → F-H → v21 |
| **How much** | ~4h build · $0 infra adicional · supabase login: 5 min Eduardo |

---

## 5 IDEIAS DISRUPTIVAS [M-1 a M-5] — Para o Gemini V8 processar

**[M-1] Dashboard de Ritmo de Aprovação — não de acerto**
Painel Eduardo mostra: "No ritmo atual, Ingrid chegará à prova com X questões estudadas e Y% de consistência semanal." Não é nota — é trajetória. Eduardo vê se Ingrid vai chegar ou não sem perguntar. Feature de 2h que transforma dados brutos em argumento de pitch concreto.

**[M-2] Certificado de Consistência Semanal (não de aprovação)**
Todo domingo: Ingrid recebe card visual PNG com "7/7 dias esta semana — você não parou." Diferente do Brasão já implementado (baseado em semanas desde início), este é semanal e binário — ou fez ou não fez. Mais urgente, mais visceral. Custo: extensão do F-6 existente.

**[M-3] Modo Silêncio — 3 dias sem sessão aciona série de mensagens progressivas**
Dia 3: "Boa noite, sentimos sua falta." Dia 5: "Faltam N dias — 10 questões agora?" Dia 7: "Eduardo enviou um recado." (aciona Pulse Check manual). Progressivo, não agressivo. Complementa M-5 do Loop 7 (alerta compound do Telegram) com ação do lado do app.

**[M-4] Benchmark de Candidatas Similares (anônimo)**
Quando a segunda usuária entrar: "Candidatas no seu ritmo acertam em média X% em Direito Administrativo na reta final." Ingrid compara com par invisível, não com nota genérica. Requer segunda usuária (Gate 7.2 desbloqueado). Custo: query simples quando multi-tenant ativo.

**[M-5] Página de Apresentação do Produto — SaaS Readiness Comercial**
Uma página pública (sem login) com: o que é o produto, como funciona, o que uma candidata recebe. Não exibe dados da Ingrid — é landing page para a próxima candidata. Eduardo envia o link em vez de explicar. Custo: 2h HTML estático, zero backend.

---

## ANÁLISE COMERCIAL

**O que este ciclo significou para o negócio:**
O Loop 7 não entregou features para Ingrid, mas entregou algo mais valioso: clareza sobre o que bloqueia o pitch e o que o desbloqueia. O debrief de 31/05 é o gate informal — se Ingrid confirmar uso nos últimos 6 dias e verbalizar progresso, a janela de R$97/mês está aberta. Se não confirmar, o sistema detecta silêncio antes do churn.

**O bloqueio técnico como revelação estratégica:**
D1 não pôde ser executado porque exige `supabase login` interativo. Isso revelou uma dependência oculta: todo deploy de Edge Function requer presença do Diretor no terminal. Para escala de 500 usuárias, este modelo não funciona. Loop 8 deve incluir automação de deploy via CI/CD ou service account — antes que a dependência trave o crescimento.

**Próxima janela comercial:**
- Pitch R$97/mês: debrief 31/05 → se temperatura confirmada → pitch na semana de 02/06
- Semente E-4: aguarda sessão com engajamento verbal mais alto (decisão soberana do Diretor)

---

*Músculo — Pentalateral IAH — 2026-05-30*


================================================================================

## MISSAO DESTA SESSAO -- PASSO3_GEMINI (INGRID)
# PASSO3 — INGRID LOOP 8
> Colar no Gemini. Arrastar APENAS os 3 documentos listados no final. NAO anexar o LEDGER.

---

Voce e um consultor estrategico analisando um projeto de software educacional.

Preciso que voce analise o contexto abaixo e emita uma DIRETRIZ no formato especificado.

---

## PROJETO

**Cliente:** Ingrid — candidata ao concurso SEDES-DF (prova 06/09/2026, 94 dias)
**Produto:** PWA de estudos com SM-2, heatmap, tutor socratico, questoes geradas por IA
**Stack:** Vanilla JS + Supabase + Claude API + GitHub Pages
**Contexto completo:** ver documentos anexos

---

## O QUE FOI ENTREGUE (Loop 7)

- 3 Edge Functions deployadas em producao (gatilho temporal, relatorio semanal, RLS)
- pg_cron ativo (cron 45 22 * * * + 0 13 * * 0)
- GitHub Security resolvido — push Pages desbloqueado
- Ingrid confirmou engajamento ativo: "esta realizando o acesso e esta gostando" (2026-06-01)
- Temperatura: QUENTE

---

## O QUE PRECISA SER FEITO (Loop 8)

**Bloco A — Seguranca e isolamento:**
- Gate 7.2: RLS dry-run via test_tenant_isolation.ps1 — confirmar isolamento de tenant antes de telemetria
- F-G: Git Hook pre-push — barreira contra vazamento de credenciais

**Bloco B — Telemetria (desbloqueado com Edge Functions ativas):**
- F-A: registrar evento_uso em Supabase — batch nao-bloqueante, nao por evento individual
- F-D: View SQL snapshot_ingrid_loop6_golden — baseline historico para comparacao entre loops

**Bloco C — Visibilidade e alertas (depende de F-A):**
- F-B: Painel Eduardo — tabela HTML limpa mostrando dias de uso, questoes, horario
- F-E: Alerta Telegram — 3 dias sem uso dispara notificacao para Eduardo

**Bloco D — Monetizacao:**
- SaaS Readiness Audit — documentar custo por usuario adicional e tempo de onboarding
- Pitch R$97/mes: janela aberta — Ingrid disse que gosta, ainda nao verbalizou progresso especifico

---

## MINHAS 5 IDEIAS — REAJA A CADA UMA (aprovada / modificada / descartada + razao)

M-1: F-A como primeiro dataset comercial — "estudou X horas, acertou Y% das questoes dificeis" vira argumento de venda para o proximo candidato
M-2: F-E como diferencial invisivel — Eduardo e o produto, nao o software; nenhum concorrente alerta o coach quando o candidato para de usar
M-3: RLS dry-run agora como prova de multi-tenant para o pitch ao candidato 2
M-4: SaaS Readiness Audit como ferramenta de venda ativa, nao apenas artefato de fechamento
M-5: F-F (Pulse Check — pergunta semanal de 30s) como dado qualitativo que o Supabase nao captura

---

## INCOGNITAS QUE PRECISO QUE VOCE ENDERECE

1. Custo real de F-A + F-E em producao com 1 usuario diario — o Musculo nao tem esse numero
2. Timing do pitch R$97/mes — gatilho por dias, por uso ou por metrica de aprovacao?
3. Nivel minimo do Painel Eduardo — terminal + View SQL e suficiente ou precisa de UI?
4. M-1 (telemetria como dataset comercial): ha algum risco legal de usar dados da Ingrid como argumento de venda para terceiros sem consentimento explicito?

---

## FORMATO DA RESPOSTA

Responda exatamente assim — sem adicionar secoes extras:

```
Diretriz Estrategica V8 -- Projeto INGRID -- Loop 8

[NOME DA SKILL]: ingrid-v8

[PARA O MUSCULO]:
[diretrizes tecnicas: o que executar, em que ordem, o que NAO construir, gates por dia de build]

REACAO AS MINHAS IDEIAS:
M-1: [aprovada / modificada / descartada — razao em 1 linha]
M-2: [aprovada / modificada / descartada — razao em 1 linha]
M-3: [aprovada / modificada / descartada — razao em 1 linha]
M-4: [aprovada / modificada / descartada — razao em 1 linha]
M-5: [aprovada / modificada / descartada — razao em 1 linha]

5 IDEIAS DISRUPTIVAS (suas — o que eu nao vi):
[G-1]: [ideia disruptiva 1]
[G-2]: [ideia disruptiva 2]
[G-3]: [CONTRA-INTUITIVO] [ideia que vai contra o obvio]
[G-4]: [ideia disruptiva 4]
[G-5]: [CONTRA-INTUITIVO] [segunda ideia contra-intuitiva]

[ALERTA]:
[riscos que estamos subestimando]
```

Minimo 2 ideias marcadas [CONTRA-INTUITIVO] — ideias que vao contra o que parece obvio fazer agora.

---

## DOCUMENTOS PARA ARRASTAR (apenas estes 3 — nao o LEDGER)

1. CLIENTES/INGRID/HISTORICO/MEMORIA_V7_INGRID.md
2. CLIENTES/INGRID/HISTORICO/relatorio_evolutivo_V7_INGRID.md
3. CLIENTES/WIP_BOARD.json

