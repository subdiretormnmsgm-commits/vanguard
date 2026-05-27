ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-05-26 23:25
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
6a5c3e9 fix(sync): propagar Template 9 para NOTEBOOKLM_FONTES de Ingrid e Valdece
ca74055 feat(p070): Onboarding Invisivel + LEDGER atualizado + Claude Project docs em dia
fa10db6 docs(pendentes): limpar [x] concluidos + novos pendentes da sessao 2026-05-26

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
    "atualizado_em":  "2026-05-26",
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
                                    "status":  "Loop 5 CONCLUIDO â€” Gate Dia 15 APROVADO 2026-05-26 â€” OFFBOARDING_RUNBOOK entregue Â· Loop 6 PENDENTE",
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

## MEMORIA MAIS RECENTE
# MEMORIA_EMBAIXADOR — PROJ-002 INGRID
> Estrutura em 3 camadas — aprovada pelo Diretor em 2026-05-19
> **CAMADA_FATOS:** dado bruto e verbatim. Zero interpretação. Auditor lê esta camada diretamente.
> **CAMADA_INFERENCIA:** análise do Embaixador. Ler sabendo que é opinião fundamentada.
> **CAMADA_DECISAO:** deliberações formais do Conselho. Verdades acordadas do projeto.
> Versão: Loop 5 · Dia 13 · 2026-05-25 — SEÇÃO D executada

---

## CAMADA_FATOS

### CLIENTE — dados objetivos

- **Nome:** Ingrid
- **Cargo-alvo:** TDAS Cargo 202 (Técnico Administrativo) — Sedes-DF 2026
- **Banca:** Instituto Quadrix
- **Data da prova:** 2026-09-06 (~111 dias a partir de 2026-05-18)
- **Canal principal de contato:** WhatsApp

### CONTATOS REGISTRADOS

| Data | Canal | Evento objetivo | Fonte |
|---|---|---|---|
| 2026-05-16 | WhatsApp | Termo enviado para assinatura | Diretor |
| 2026-05-18 | WhatsApp | Termo assinado por Ingrid | Diretor (confirmado 2026-05-19) |
| 2026-05-18 | App (PWA) | Primeira sessão real — Gate Dia 8 | Ingrid |
| 2026-05-23 | WhatsApp (via Diretor) | Link do app reenviado — reengajamento pós-Loop 5 | Diretor |
| 2026-05-24 | WhatsApp | Ingrid enviou mensagem espontânea — usou simulado, sinalizou retorno amanhã | Ingrid |
| 2026-05-26 | WhatsApp | Ingrid viu documento (Termo 18/05) — confirmado recebido | Diretor |
| 2026-05-26 | WhatsApp | Eduardo plantou lead D4:A — Ingrid respondeu "não conhece ninguém prestando concurso" | Diretor |

### FALAS VERBATIM DE INGRID

| Data | Canal | Fala exata | Contexto |
|---|---|---|---|
| 2026-05-18 | Via Diretor | *"Gostou muito do aplicativo, só fez essa ressalva: Na questão 18, não houve palavra destacada em negrito, como informava o enunciado."* | Primeira sessão real — Gate Dia 8 |
| 2026-05-24 | WhatsApp direto | *"Boa noite, Eduardo! Fiz um simulado agora e gostei bastante. Amanhã volto ao app para atacar mais um pouco das questões!"* | Pós-reenvio do link (2026-05-23) — contato espontâneo noturno |
| 2026-05-26 | WhatsApp (via Diretor) | *"[não conhece ninguém que esteja fazendo concurso]"* | Resposta ao plantio de lead D4:A — "Você conhece mais alguém prestando concurso esse ano?" |

### EVENTOS OBSERVÁVEIS

| Data | Evento | Detalhe factual |
|---|---|---|
| 2026-05-18 | Termo assinado | Data no corpo do PDF: **30/05/2026** — Eduardo confirmou assinatura em **18/05/2026** — inconsistência documental ativa |
| 2026-05-18 | Primeira sessão real | Chegou até pelo menos a questão 18 |
| 2026-05-18 | Bug identificado | Questão 18 — negrito ausente no enunciado que o referenciava |
| 2026-05-19 | Bug corrigido | Fix deployado em GitHub Pages (commit da9887a) |

### ESTADO DO PRODUTO (fatos técnicos)

| Campo | Estado | Data |
|---|---|---|
| Gate atual | Loop 5 — Dias 9-12 concluídos | 2026-05-23 |
| Questões no banco | 460 — Cargo 202 SEDES-DF | 2026-05-18 |
| App no ar | https://subdiretormnmsgm-commits.github.io/vanguard/ | 2026-05-18 |
| Fix renderização negrito | Deployado | 2026-05-19 |
| G-5 Socrática Pânico | Deployado (bug de ordem de lógica corrigido) | 2026-05-23 |
| G-3 Badge Vacina | Deployado (passivo — aparece quando feed inclui questão vacina) | 2026-05-23 |
| Contador de Erros Cumulativo | Deployado (gauge visual ativo) | 2026-05-23 |
| Deploy pipeline (P-056) | gh-pages branch sincronizada — script `deploy_ingrid_ghpages.ps1` ativo | 2026-05-23 |

### HIPÓTESES RESOLVIDAS — evidência factual

| # | Hipótese | Status | Evidência factual |
|---|---|---|---|
| H-1 | Não assinou por esquecimento — não por hesitação | **CONFIRMADA** | Assinou em ~48h sem questionamento, negociação ou pedido de desconto |
| H-2 | Medo financeiro causou hesitação | **REFUTADA** | Piloto R$0 — sem gatilho financeiro presente |
| H-3 | Compararia o app com TEC Concursos na primeira sessão | **PENDENTE** | Q18 sem menção ao TEC — modo imersivo, não avaliativo. Só confirma quando verbalizar. |
| H-4 | Dificuldade = risco de abandono na primeira sessão | **ATIVA** | Q18 é receptividade, não hábito. Teste real ocorre na sessão 3-5 quando SM-2 começa a cobrar. |

---

## CAMADA_INFERENCIA

### HIPÓTESES ATIVAS

| # | Hipótese | Status | Base de inferência |
|---|---|---|---|
| H-5 | Pode compartilhar login com familiar ou colega | **IMPROVÁVEL — REVISADA** | D4:A: não conhece ninguém prestando concurso → rede social de concurso = zero por enquanto |
| H-6 | Teto receptivo real pode ser R$150/mês, não R$97 | PENDENTE | Embaixador: "esperança não regateia" |
| H-7 | Lê enunciados com atenção literal — Quadrix mindset nativo | **NOVA — confirmar nas próximas 2 sessões** | Notou discrepância entre o que o enunciado "informava" e o que a UI entregou |

### TEMPERATURA DO CLIENTE

```
TEMPERATURA: VERDE — ENGAJAMENTO ATIVO CONFIRMADO
Razão: Ingrid enviou mensagem espontânea em 2026-05-24 (noite). Usou o simulado, declarou que
"gostei bastante" e sinalizou retorno no dia seguinte. Contato iniciado por ela — sem estímulo
direto do Diretor no dia. Score estimado: 7/10 (de 5 para 7 — subindo).
CHURN-WATCH: DESATIVADO — risco de abandono não confirmado.
Padrão observado: estuda à noite (mensagem às ~20h). Confirmação parcial de horário noturno.
Simulado (Micro-Simulado Dia 11) testado e aprovado. Contador e Push: amanhã.
Próxima reavaliação: após Eduardo informar feedback de Ingrid sobre Contador (Dia 13)
Última atualização: 2026-05-24 (Músculo P-032 — contato espontâneo Ingrid)
```

### PADRÕES INFERIDOS — atualizar com cada sessão real

- **Mais analítica do que o registrado anteriormente:** leu o enunciado inteiro da questão 18 e notou discrepância precisa — comunicação de QA, não de cliente comum
- **Não compara com concorrentes:** no Gate Dia 8, TEC não foi mencionado — pode ter descolado cognitivamente ou o app criou identidade própria suficiente
- **Feedback acionável e específico:** não diz "tá estranho" — diz "questão 18, negrito ausente, como informava o enunciado." Precisa de precisão
- **Tom que funciona:** caloroso, direto, sem jargão técnico
- **Tom que não funciona:** formal, técnico, longo

### INTELIGÊNCIA DO EMBAIXADOR — Loop 4 PRÉ-BUILD [E-1 a E-5] (Gate Dia 8 · 2026-05-19)

| # | Insight | Ação prescrita |
|---|---|---|
| E-1 | Ingrid validou o moat do produto sem saber: leitura literal = musculatura Quadrix em treinamento | Documentar como prova social âncora: *"começou a notar detalhes da banca que não notava no TEC"* |
| E-2 | Resolução do bug em 24h = transição de cliente para parceira do produto | Enviar mensagem BLOCO 7 (Camada Decisão) imediatamente após fix deployado |
| E-3 | Não comparou com TEC → argumento comparativo não precisa aparecer no pitch | Revisar 04_PROPOSTA_COMERCIAL.md: retirar tabela comparativa do bloco principal |
| E-4 | KPI do R$194k: timestamp da questão 18 vs. primeiro acesso = primeiro dado real de engajamento EdTech | Músculo: query `progresso_usuario` WHERE `user_id = Ingrid` ORDER BY `created_at` |
| E-5 | Princípio: primeiro feedback espontâneo de piloto vale mais que qualquer pesquisa de mercado | Candidato P-046 ao LEDGER |

### INTELIGÊNCIA DO EMBAIXADOR — Loop 5 SEÇÃO D (2026-05-25)

**PAINEL DE DELIBERAÇÃO — 5 decisões geradas pelo Embaixador (veredito do Diretor pendente):**

| Código | Tema | Opção A | Opção B | Opção C | Recomendação Embaixador |
|---|---|---|---|---|---|
| D1 | LEGAL-WATCH | WhatsApp + novo PDF datado 18/05 | Clickwrap UI — bloqueia Contador | Registro formal via Músculo | **A** — B vetado: Ingrid ignora modal ou abandona. A é invisível para ela. |
| D2 | GATE-WATCH | Deploy completo + offboarding 28-29/05 | Escopo reduzido para caber | Extensão do deadline | **A** — Ingrid em VERDE; momento de fechar forte. Deadline é real. |
| D3 | PRODUTO G-1+G-3 | VETO total ambas → backlog V2 | G-3 suave sem punição | Aguardar TTL de dados | **A** — Ingrid em VERDE FRÁGIL; qualquer feature punitiva ou especulativa é risco de churn silencioso. |
| D4 | PIPELINE | Plantar "conhece alguém?" na próxima mensagem | Esperar orgânico | Já foi mencionado | **A** — temperatura VERDE antes do pitch de cobrança = momento ideal para plantio de lead. |
| D5 | N-3 LINHA DE CORTE | Validar 72 pts com histórico → build | Faixa estimada (65-80) | Não implementar | **A** com ressalva: validar o número real antes de commitar no código. |

**Vetoes e alertas críticos do Embaixador — Loop 5 SEÇÃO D:**
- VETO G-1 (Badge Vacina): feature de compliance disfarçada de gamificação — Ingrid não vai entender o meta
- VETO G-3 (Bloqueio por desatenção): confirmado de Loop 4 — churn garantido para perfil Ingrid
- VETO Horário fixo 09h push: sem base empírica; horário real de Ingrid = noturno (~20h conforme fala verbatim)
- ALERTA iOS Web Push: Apple bloqueia nativamente; fallback WhatsApp é mais confiável que qualquer Service Worker
- CONFIRMA N-2 Clickwrap-Unclog: mata passivo jurídico sem atrito visível — melhor que B de D1
- CONFIRMA N-3 Linha de Corte: aversão à perda converte número frio em caça à vaga — alinha P-041
- CONFIRMA N-5 html2canvas: SVG no cliente sem token de backend — custo zero, pitch SaaS

### INTELIGÊNCIA DO EMBAIXADOR — Loop 4 DELIBERAÇÃO [E-1 a E-5] (2026-05-20)

| # | Insight | Ação prescrita |
|---|---|---|
| E-1 | Horário de pico de Ingrid desconhecido — Q18 não captura horário. Se estuda às 22h, Simulado Dominical 10h pode ser feature desperdiçada. | Eduardo pergunta no check-in 2026-05-21: "Você estuda mais de manhã, tarde ou noite?" |
| E-2 | Q18 sem pausa = estado de fluxo. Risco não é login quebrando acesso — é qualquer interrupção técnica visível quebrar a imagem do app. Fallback deve ser invisível para Ingrid. | Músculo: garantir que modo passivo (fallback de fadiga) seja indistinguível do modo ativo. |
| E-3 | Ingrid precisa de "você está no seu melhor momento hoje" — confirmação de progresso, não alerta de risco. Heatmap de urgência cobre ameaça; falta cobrir conquista. | Músculo: adicionar feedback positivo pós-sequência de acertos ("Você acertou as últimas 4 — esse é seu ritmo"). |
| E-4 | Campo `horario_inicio_sessao` não existe no schema. Padrão noturno de Ingrid (provável) é argumento de pitch: "feito para quem estuda depois das 20h." | Avaliar antes do Gate Dia 15 se vale incluir timestamp de sessão no schema. |
| E-5 | Mensagem semanal de Eduardo com número de questões via WhatsApp (não push do app) ativa circuito de responsabilidade social além de progresso pessoal. Custo: 30s/semana. | Diretor autoriza protocolo de envio semanal — Músculo já tem `get_total_respostas`. |

### ALERTAS DO EMBAIXADOR — Loop 4 Deliberação (2026-05-20)

- **VETO [G-3] Persona Sargento:** ALERTA CRÍTICO — confronto verbal por TTI baixo vai gerar estresse que Ingrid não nomeia mas abandona silenciosamente. Ingrid não vai reclamar — vai sumir.
- **ALERTA [G-2] Distrator Assombração:** adiar para V2 — perfil de Ingrid é de quem quer superar erro, não ser confrontada repetidamente por ele.
- **CONFIRMA [P-045] veto ao login:** Q18 confirma engajamento real — qualquer atrito de acesso neste momento é risco genuíno.
- **Heatmap linguagem:** enquadrar disciplinas soberanas como "território conquistado", nunca "baixa prioridade".
- **Simulado Dominical:** não construir antes de confirmar horário de estudo de Ingrid (check-in 2026-05-21).

### WATCHDOG

| Flag | Status | Ação se não resolvido |
|---|---|---|
| [CHURN-WATCH] | **DESATIVADO** — Ingrid retornou espontaneamente em 2026-05-24 | Rearmar se silêncio > 3 dias a partir de agora |
| [QA-WATCH] negrito questão 18 | RESOLVIDO | Fix deployado 2026-05-19 |
| [SCOPE-WATCH] H-5 compartilhamento | DESATIVADO — D4:A: Ingrid não conhece ninguém prestando concurso. Pipeline indicação = zero. H-5 revisada para IMPROVÁVEL. | Rearmar apenas se Ingrid mencionar colega ou amigo usando o app |
| [LEGAL-WATCH] Termo data | PARCIAL — Ingrid confirmou recebimento do novo PDF (18/05) em 2026-05-26. Reassinatura formal pendente. | Confirmar assinatura na próxima interação |
| [DEPLOY-WATCH] gh-pages branch | RESOLVIDO — P-056 documentado | Script deploy_ingrid_ghpages.ps1 ativo — rodar ao fim de cada sessão de build |
| [TESTE-WATCH] Features Loop 5 | **PARCIAL** — Simulado testado e aprovado (2026-05-24). Contador + Push: amanhã (2026-05-25) | Aguardar feedback de Ingrid sobre Contador após visita ao app |

### PIPELINE COMERCIAL

| Produto | Valor | Gatilho verbal de Ingrid | Timing |
|---|---|---|---|
| Piloto atual | R$0 | — | Ativo |
| SaaS V2 | R$97/mês | "tô conseguindo estudar todo dia" ou verbalizar progresso | Entre Gate Dia 8 e 2026-06-15 |
| SaaS V2 upsell | R$150/mês | Ingrid não piscar no R$97 | Avaliar no momento do pitch |

**Abertura do pitch:** *"Ingrid, esse ciclo foi piloto. Quero continuar do seu lado até o dia da prova — R$97/mês, menos que qualquer cursinho, e o sistema já te conhece. Quer continuar?"*

**Inteligência de pipeline — D4:A (2026-05-26):**
- Eduardo plantou: *"Você conhece mais alguém prestando concurso esse ano?"*
- Ingrid respondeu: não conhece ninguém
- **Implicação:** Ingrid estuda em isolamento — sem grupo de estudo, sem rede de concurso. Pipeline de indicação = zero no curto prazo.
- **Contra-intuição:** ausência de rede é também ausência de concorrente social (ninguém para comparar o app com ela). Ela não vai ouvir "TEC é melhor" de colega.
- **Próximo gatilho de pipeline:** avaliar após aprovação — momento de expansão de rede em comunidades de servidores (pós-nomeação = momento de maior vaidade e compartilhamento).

### INTELIGÊNCIA DE MERCADO — D2 (EdTech-Concurso)

> Mandato 12 do Embaixador. Última atualização: 2026-05-23 (Loop 5).

#### SUBSTITUTOS DIRETOS

| Produto | Preço estimado | O que faz | Ponto fraco |
|---|---|---|---|
| TEC Concursos | ~R$50–90/mês | Questões por filtro manual + gabarito | Sem repetição espaçada; sem adaptação por banca; questões genéricas por cargo |
| QConcursos | ~R$50–80/mês | Simulados + estatísticas de acerto | Sem personalização SM-2; sem feed dinâmico por peso |
| Gran Cursos Online | ~R$70–130/mês | Videoaulas + questões | Foco em conteúdo, não em prática adaptativa |
| Estratégia Concursos | ~R$90–150/mês | Videoaulas + resolução comentada | Idem Gran — conteúdo, não prática |

**Diferencial defensável da Vanguard:**
- SM-2 real — cada questão tem intervalo de revisão calculado por acerto/erro pessoal da Ingrid
- Feed ponderado (Peso 2 = disciplinas críticas para o cargo) — nenhum concorrente faz isso por cargo
- G-5 Socrática Pânico — intervenção pedagógica em crise de erros, não punição
- Corpus curado Quadrix SEDES-DF 2026 — nenhum concorrente tem esse recorte

#### DADOS DE MERCADO CAPTURADOS

| Data | Evento | Dado de mercado inferido |
|---|---|---|
| 2026-05-18 (Gate Dia 8) | Ingrid não mencionou TEC Concursos em nenhum momento da sessão | App criou identidade própria — ausência de comparação é sinal de posicionamento conquistado |
| 2026-05-18 | Ingrid reportou bug de negrito com precisão técnica | Perfil exigente — não vai tolerar produto que regride; bar de qualidade alto para manter o posicionamento |

#### POSICIONAMENTO VANGUARD NO MERCADO

```
ARGUMENTO DE PREÇO (quando chegar a hora do pitch):
"R$97/mês é menos que uma plataforma genérica. A diferença: esse sistema
já sabe qual disciplina te custa mais pontos no Quadrix. Nenhum TEC faz isso."

ARGUMENTO DIFERENCIAL:
"O TEC te dá questões. Esse sistema te diz qual questão estudar agora,
com base no que você errou — e te cobra de volta no momento certo."

MOMENTO DO PITCH:
Quando Ingrid verbalizar "tô conseguindo estudar todo dia"
ou "achei que ia perder tempo aqui e não — é diferente"
```

#### OPORTUNIDADE DE PREÇO

| Hipótese | Base | Status |
|---|---|---|
| Teto receptivo real é R$150/mês | Ingrid não regateou no piloto; perfil de quem "espera e não barganha" | PENDENTE — confirmar na hora do pitch |
| R$97/mês é abaixo do teto mas acima da ancora psicológica de concurseiro | Concurseiros pagam R$50–90 nos genéricos; R$97 está acima porém com diferencial claro | HIPÓTESE ATIVA |

#### RISCO DE ESCALA (Mandato 13 — Sentinela)

| Risco | Detalhe | Severidade |
|---|---|---|
| Personalização por cargo = gargalo de curadoria | Cada novo cargo exige coletar e ponderar questões específicas — não escala automaticamente | ALTO |
| SM-2 depende de volume de interações | Com menos de 20 sessões, os intervalos são estimativas — Ingrid está na janela crítica | MÉDIO |
| Ingrid compartilhar login (H-5) | Uma conta shared dilui os dados de SM-2 — algoritmo passa a ser inútil | MÉDIO |

### LEADS DETECTADOS

| Nome | Contexto | Status |
|---|---|---|
| — | D4:A executado 2026-05-26: "Você conhece alguém prestando concurso?" | Ingrid respondeu: não conhece ninguém — pipeline de indicação = zero no curto prazo |

---

## CAMADA_DECISAO

### DECISÕES FORMAIS DO CONSELHO

| Data | Decisão | Autoridade |
|---|---|---|
| 2026-05-18 | P-023 resolvido: Clickwrap na UI + Termo físico assinado | Conselho — Síntese Final P-037 |
| 2026-05-18 | Número visível: Pontos Ponderados — Score de Sobrevivência removido (viola cláusula 2) | Conselho — Síntese Final P-037 |
| 2026-05-18 | Debug mode: 5 toques no logo — nunca query string (Ingrid não é técnica) | Conselho — Síntese Final P-037 |
| 2026-05-18 | Perfis de Nicho: trade secret interno — nunca produto comercializável externamente | Embaixador ALERTA + Músculo — Síntese Final |
| 2026-05-19 | MEMORIA_EMBAIXADOR reestruturada em 3 camadas (FATOS / INFERENCIA / DECISAO) | Diretor — aprovação explícita |
| 2026-05-27 | **D1:A** LEGAL-WATCH — WhatsApp + novo PDF datado 18/05. Ingrid assina sem drama. | Diretor — Veredito Loop 5 |
| 2026-05-27 | **D2:A** GATE-WATCH — Deploy completo + offboarding real nos Dias 14-15 (28-29/05) | Diretor — Veredito Loop 5 |
| 2026-05-27 | **D3:A** VETO G-1 + G-3 total — backlog V2. Ingrid em VERDE FRÁGIL: zero risco desnecessário | Diretor — Veredito Loop 5 |
| 2026-05-27 | **D4:A** Pipeline — plantar "Conhece alguém prestando concurso?" na próxima mensagem a Ingrid | Diretor — Veredito Loop 5 |
| 2026-05-27 | **D5:B** N-3 Linha de Corte — campo configurável no DASHBOARD interno. Eduardo define o número quando tiver dados reais. SEDES-DF 2026 é primeiro concurso Quadrix no órgão — sem corte histórico verificável. | Diretor — Veredito Loop 5 |

### PROTOCOLOS ATIVOS

**Mensagem imediata — enviar AGORA (fix já deployado):**
> *"Ingrid, que bom que gostou — fico feliz mesmo. E olha, valeu demais por ter notado aquilo da questão 18 com o negrito. Era um bug de formatação chato, já corrigi. Esse tipo de olho fino é exatamente o que a banca da Quadrix cobra na prova, viu? Continua estudando assim 👊"*

**Reassinatura do Termo (próxima interação):**
- Gerar novo PDF com data 18/05/2026 no corpo
- Eduardo: *"Corrigi uma data no documento, precisa assinar rapidinho de novo"*
- Simples, sem drama, antes do Gate Dia 15

**Próxima sessão de Ingrid:**
1. Plantar pergunta de lead: *"Você conhece mais alguém prestando concurso esse ano?"*
2. Embaixador recebe debrief em até 24h com `FRASES_VERBATIM` separado de interpretação

### PRINCÍPIOS CANDIDATOS AO LEDGER

| Código | Princípio | Proposto em |
|---|---|---|
| P-042 | FALAS_CLIENTE: repositório único por projeto — captura única, extração múltipla por membro | 2026-05-19 |
| P-043 | Membro que acusa outro de viés metodológico entrega evidência verbatim, não conclusão sintética | 2026-05-19 |
| P-044 | Princípio extraído do LEDGER sem rotina operacional declarada é prosa — não aprendizado | 2026-05-19 |
| P-045 | URL pública (GitHub Pages) aceita só em piloto — auth real obrigatório antes do primeiro cliente pagante | 2026-05-19 |
| P-046 | Primeiro feedback espontâneo de piloto é o ativo mais valioso do projeto — captura verbatim com timestamp | 2026-05-19 |
| P-047 | Engajamento inaugural alto (Q18+) é indicador de receptividade, não hábito formado. Hábito confirma-se na sessão 3-5 quando SM-2 cobra e a novidade foi embora. Temperatura Verde depende da qualidade das sessões 2-5, não da sessão 1. | 2026-05-20 |

### HISTÓRICO DE ATUALIZAÇÕES

| Data | O que mudou | Quem |
|---|---|---|
| 2026-05-18 | Criação inicial | Embaixador |
| 2026-05-18 | Síntese Final P-037: E-1 a E-5 + H-1/H-2 + Pipeline + Temperatura + decisões | Músculo (P-032) |
| 2026-05-18 | Termo assinado — VERDE — P-023 resolvido — URL pública ativa | Músculo (P-032) |
| 2026-05-19 | Gate Dia 8: "gostou muito" + bug questão 18 — primeiro dado verbatim real | Embaixador (LOG_006) |
| 2026-05-19 | H-3/H-4 refutadas, H-7 nova, TEMPERATURA QUENTE, fix deployado | Músculo (P-032) |
| 2026-05-19 | Reestruturação em 3 camadas aprovada pelo Diretor | Músculo (P-032) |
| 2026-05-20 | Loop 4 Deliberação: E-1 a E-5 + alertas CRÍTICOS (Persona Sargento / Distrator) + temperatura VERDE FRÁGIL | Músculo (P-032) |
| 2026-05-20 | H-3 revertida para PENDENTE, H-4 mantida ATIVA — engajamento inaugural ≠ hábito formado | Embaixador |
| 2026-05-23 | Loop 5 Dia 12: G-5 + G-3 + Contador deployados. Deploy pipeline (P-056) corrigido. Link reenviado a Ingrid. Temperatura atualizada para VERDE FRÁGIL REENGAJAMENTO. Watchdog DEPLOY-WATCH + TESTE-WATCH criados. | Músculo (P-032) |
| 2026-05-25 | Loop 5 SEÇÃO D: Embaixador executou reação completa a [M+G+N] (15 inputs). Painel de Deliberação D1-D5 gerado. VETO G-1+G-3 confirmado. N-2+N-3+N-5 confirmados. Veredito de Eduardo pendente. | Músculo (P-032) |
| 2026-05-26 | Gate Dia 15 APROVADO — Loop 5 CONCLUIDO. D4:A executado (lead plantado, Ingrid confirmou não ter rede de concurso). Novo PDF Termo recebido e confirmado por Ingrid. Datas 2026-05-29 → 2026-05-26 corrigidas. SCOPE-WATCH H-5 desativado. LEGAL-WATCH parcial (recebimento confirmado, assinatura pendente). | Músculo (P-032) |

---

> **Protocolo de uso:** CAMADA_FATOS = Auditor lê sem viés do Embaixador. CAMADA_INFERENCIA = Embaixador interpreta (ler sabendo que é opinião). CAMADA_DECISAO = Conselho deliberou — são verdades formais.
> Tempo de leitura por camada: 30 segundos. Atualização: 2 minutos.

