

# BLOCO 1 — CONTEXTO DO SISTEMA (CONTEXTO_GEMINI.md)

ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-06-06 20:15
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
22181ab feat(v28): PASSO5 + PASSO7 gerados — lens Vanguard
5ec891d feat(v28): PASSO3_GEMINI_V28 — Pentalateral Autonomo
5559226 chore(pendentes): [GAP] estado_wip resolvido + candidato -WhatIf registrado

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
    "atualizado_em":  "2026-06-05",
    "wip_limits":  {
                       "build":  2,
                       "check":  1
                   },
    "board":  {
                  "discovery":  [

                                ],
                  "build":  [

                            ],
                  "check":  [
                                {
                                    "id":  "PROJ-001",
                                    "cliente":  "Valdece",
                                    "projeto":  "Ferramenta de Busca Jurisprudencia STF/STJ",
                                    "area":  "LegalTech - Direito Penal",
                                    "camada":  "1 (MVP Alto Impacto)",
                                    "valor_fechado":  5000,
                                    "status":  "HYPERCARE -- ate 18-06-2026",
                                    "loop_atual":  "Loop 7 CONCLUIDO -- V3 entregue + Deploy Netlify OK",
                                    "deploy_netlify":  "https://toga-digital-valdece.netlify.app",
                                    "deploy_netlify_data":  "2026-05-19",
                                    "contrato_assinado":  true,
                                    "contrato_assinado_em":  "2026-05-19",
                                    "deadline":  "2026-05-23",
                                    "build_iniciado_em":  "2026-05-13",
                                    "ultimo_contato_cliente":  "2026-06-04",
                                    "churn_watch_threshold":  3,
                                    "stack":  "FastAPI + Supabase + Claude API + Netlify",
                                    "loop_fase_atual":  {
                                                            "loop":  7,
                                                            "gemini":  "OK",
                                                            "notebooklm":  "OK",
                                                            "embaixador":  "OK",
                                                            "musculo":  "OK",
                                                            "proximo":  "Loop 8 gate: Sentinel Report uso ativo + Gemini anchor para DIRETRIZ V8 Valdece"
                                                        },
                                    "proximo_passo":  "Hypercare termina 18-06-2026 -- Sentinel Report enviado 2026-06-04 -- aguardar feedback Valdece",
                                    "sentinel_report":  {
                                                            "ultimo":  "2026-06-04",
                                                            "status":  "VERDE",
                                                            "supabase_pause_resolvido":  true
                                                        },
                                    "v2_pipeline":  {
                                                        "features":  [
                                                                         "Sovereign Upload",
                                                                         "Radar de Divergencia",
                                                                         "Citacao DOCX"
                                                                     ],
                                                        "gatilho":  "corpus \u003e= 500 docs ou 30 dias pos-entrega",
                                                        "pricing":  "R$8.500-12.000 projeto unico + R$300/mes manutencao opcional"
                                                    },
                                    "corpus_status":  {
                                                          "total_acordaos":  61,
                                                          "temas_cobertos":  22,
                                                          "threshold":  0.45,
                                                          "status":  "TESTADO E VERDE"
                                                      },
                                    "briefing_path":  "CLIENTES/VALDECE/BRIEFING_DISCOVERY.txt",
                                    "gut_score":  75,
                                    "entrada_em":  "2026-05-12"
                                }
                            ],
                  "entregue":  [

                               ],
                  "retainer":  [
                                   {
                                       "id":  "PROJ-002",
                                       "cliente":  "Ingrid",
                                       "projeto":  "Ferramenta de Estudo -- Concurso Sedes-DF",
                                       "area":  "EdTech - Concursos Publicos",
                                       "camada":  "2 (Produto -- 15 dias)",
                                       "valor_fechado":  0,
                                       "tipo":  "Projeto Piloto Interno -- Validacao V25",
                                       "status":  "RETAINER",
                                       "loop_atual":  "Loop 8 CONCLUIDO",
... [truncado -- ver arquivo completo]

================================================================================

## PROTOCOLO VANGUARD (resumo)
---
name: protocolo-vanguard
description: ativa o Modelo PENTALATERAL IAH para QUALQUER projeto — ecommerce, app, site, SaaS, modelo de negócio, automação, IA, API. O Músculo opera como Arquitecto-Mestre e membro ativo do Conselho colaborativo. Executar sempre que o Diretor disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo PENTALATERAL IAH
**Versão da Skill:** 6.4 — Universal · Colaborativo · Qualquer projeto · Qualquer operador · 7 Leis Soberanas + 8 Frameworks de Gestão ativos · Intelligence Compounding · Protocolo de Imunidade do Conselho (2026-05-14) · **5º Membro: Embaixador + P-031 (2026-05-18) · 12 novas DEF + P-052/053/054/055 (2026-05-23) · DEF-E-8 + Pipeline DECISOES JSON + P-056/057/058 (2026-05-24) · n8n como Sistema Nervoso Autônomo + W-7 Veredito Telegram + P-101 a P-111 (2026-06-04) · BLOCO 0 Embaixador + Sync Guard + P-112 a P-115 (2026-06-06)**

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
> Versão: Loop 8 · 2026-06-04 — P-032 atualizado pelo Músculo

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
| 2026-06-04 | Diretor | **VEREDITO D1** — Ferramenta gratuita para Ingrid. Sem cobrança R$97/mês. Ingrid é caso piloto — dados anonimizados são argumento comercial para próximas candidatas. Ingrid não é cliente pagante: é fundadora simbólica do produto. | Veredito Diretor |
| 2026-06-04 | Diretor | **VEREDITO D4** — Mensagem de presença humana esta semana. Eduardo entra em contato sem mencionar pitch ou cobrança. | Veredito Diretor |
| 2026-06-04 | Embaixador | **Loop 8 processado** — Temperatura 8.5/10 QUENTE. 5 decisões D1-D5: D1 descartado, D2/D4/D5 aprovados, D3 descartado. | Embaixador Loop 8 |
| 2026-06-01 | WhatsApp | **D3 respondido** — Ingrid confirmou: está realizando o acesso e está gostando. Cenário A confirmado (engajada, ativa, não desengajada). | Ingrid via Diretor |
| 2026-06-01 | WhatsApp | **D3 enviado** — debrief casual: "Aquela configuração ficou perfeita. Como você tá se sentindo com o estudo essa semana? 📚" | Diretor |
| 2026-05-30 | WhatsApp | Veredito: Enviar debrief casual amanhã — coletar temperatura real (PITCH-WATCH — janela R$97/mês: aberta, gatilho não acionado) | VEREDITOS_INGRID_2026-05-30.json |
| 2026-05-16 | WhatsApp | Termo enviado para assinatura | Diretor |
| 2026-05-18 | WhatsApp | Termo assinado por Ingrid | Diretor (confirmado 2026-05-19) |
| 2026-05-18 | App (PWA) | Primeira sessão real — Gate Dia 8 | Ingrid |
| 2026-05-23 | WhatsApp (via Diretor) | Link do app reenviado — reengajamento pós-Loop 5 | Diretor |
| 2026-05-24 | WhatsApp | Ingrid enviou mensagem espontânea — usou simulado, sinalizou retorno amanhã | Ingrid |
| 2026-05-26 | WhatsApp | Ingrid viu documento (Termo 18/05) — confirmado recebido | Diretor |
| 2026-05-26 | WhatsApp | Eduardo plantou lead D4:A — Ingrid respondeu "não conhece ninguém prestando concurso" | Diretor |
| 2026-05-27 | WhatsApp | Reassinatura física do Termo confirmada pelo Diretor — LEGAL-WATCH VERDE | Diretor |

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
| Gate atual | Loop 7 — Todos os 15 dias aprovados · Gate dia15 APROVADO 2026-05-30 | 2026-05-30 |
| Versão em produção | v20 — F-1/F-2/F-5/F-7/F-8 ativos · F-4/F-6 deploy CLI pendente | 2026-05-28 |
| Questões no banco | 460+ — Cargo 202 SEDES-DF | 2026-05-18 |
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
| H-3 | Compararia o app com TEC Concursos na primeira sessão | **REFUTADA** — encerrada 2026-05-30 | TEC nunca mencionado em nenhuma sessão documentada. Hipótese encerrada definitivamente. |
| H-4 estendida | SM-2 nas sessões 3-5 — dificuldade crescente = abandono? | **REVISADA — BAIXO RISCO** | D3 respondido 2026-06-01: Ingrid confirma acesso ativo e que está gostando. SM-2 crescente não causou abandono. Engajamento sustentado confirmado. |

---

## CAMADA_INFERENCIA

### HIPÓTESES ATIVAS

| # | Hipótese | Status | Base de inferência |
|---|---|---|---|
| H-5 | Pode compartilhar login com familiar ou colega | **IMPROVÁVEL — REVISADA** | D4:A: não conhece ninguém prestando concurso → rede social de concurso = zero por enquanto |
| H-6 | Teto receptivo real pode ser R$150/mês, não R$97 | PENDENTE | Embaixador: "esperança não regateia" |
| H-7 | Lê enunciados com atenção literal — Quadrix mindset nativo | **CONFIRMADA — Loop 6** | Notou discrepância Q18 + espontaneamente retornou para "atacar mais questões" — mindset concurseiro nativo sem que o app precisasse induzir |
| H-8 | "Atacar" = shift de player — pré-comprometimento com aprovação | **NOVA — Loop 6** | Fala espontânea 2026-05-24: "Amanhã volto para atacar mais" — verbo ativo, não ansioso. Embaixador: shift de "sobreviver ao material" para "atacar o placar" |

### TEMPERATURA DO CLIENTE

```
TEMPERATURA_PONDERADA: 8.5/10 — VERDE FORTE (D3 respondido 2026-06-01 — Ingrid confirmou acesso ativo e que está gostando)
Ingrid passou de "tentando sobreviver ao material" para "atacando o placar" (P-079). H-8 CONFIRMADA.
H-4 REVISADA: SM-2 crescente não causou abandono. Engajamento sustentado pós-dificuldade = produto validado.
Cenário A CONFIRMADO: silêncio era confiança no processo, não desengajamento. Cliente ativa, não fugindo.
Janela de pitch R$97/mês: AQUECIDA — Ingrid verbalizou satisfação com o produto. Próximo gatilho: uso 7 dias consecutivos verbalizado ou Eduardo propõe formalmente.
CHURN-WATCH: DESATIVADO. [DATA-GAP-WATCH]: ENCERRADO — uso confirmado verbalmente.
SCOPE-WATCH: DESATIVADO — sem rede de concurso no curto prazo. Pipeline pós-aprovação.
LEGAL-WATCH: VERDE — P-013 VERDE 2026-05-30. P-023 VERDE.
[DADOS-WATCH]: VERDE — 102 respostas · 1 user_id correto.
[DEPLOY-WATCH]: VERDE — Gate 7.1 APROVADO 2026-06-01. 3 Edge Functions em produção: notificar-progresso + gatilho-temporal (19h45 BRT diário) + relatorio-semanal (domingo 10h). pg_cron ativo em yjqvjhezwhepwomukudt.
[GITHUB-WATCH]: VERDE — token sbp_ revogado + alerta GitHub dispensado — 2026-06-01.
[PITCH-WATCH]: AQUECIDO — D3 respondido 2026-06-01. Ingrid ativa e satisfeita. Missão de apropriação recomendada antes do Loop 8.
Padrão: estuda à noite (~20h). F-6 relatório semanal = coração do argumento R$97/mês.
Última atualização: 2026-06-01 (Músculo P-032 — D3 respondido · Cenário A confirmado · Temperatura 8.5)
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

### INTELIGÊNCIA DO EMBAIXADOR — Loop 6 SEÇÃO D (2026-05-27) · REAÇÃO AO PENTALATERAL

| # | Insight | Ação prescrita |
|---|---|---|
| E-1 | Contato espontâneo é o dado de maior valor — o que fez Ingrid voltar? Provavelmente o Contador de Pontos (novo). Identificar qual feature ativou o retorno antes do próximo contato. | Gate: verificar dados antes de contato. Após DADOS-WATCH resolvido → Eduardo pergunta casualmente "o que você achou do contador de pontos?" |
| E-2 | "Atacar" = shift de player — pré-comprometimento com aprovação. Timing ideal para pitch V2 quando chegar o momento. Não queimar agora — DADOS-WATCH bloqueia. | Aguardar DADOS-WATCH + LEGAL-WATCH VERDE confirmado antes de pitch V2. |
| E-3 | Ingrid precisa de espelho confirmando trajetória — Sentinel Report parcial é a peça ausente. Um número real ("você acertou X% das questões Quadrix nos últimos 7 dias") vale mais que qualquer mensagem motivacional. | Músculo: gerar Sentinel Report parcial com dados reais de Ingrid após resolução do DADOS-WATCH. |
| E-4 | Semente de indicação pós-aprovação — plantar agora, colher depois: "Quando você passar, vou ter o sistema pronto para quem você indicar." Zero pressão agora, aciona circuito de antecipação. | Eduardo planta frase na próxima mensagem após DADOS-WATCH resolvido. |
| E-5 | Saudação noturna personalizada: "Boa noite — 20 questões te esperam" = âncora de hábito. Uma linha de código. Ativa o circuito certo (ritual noturno) sem push nativo (Apple bloqueia). | Músculo: implementar saudação dinâmica por horário de acesso ao app — Loop 6 build. |

**PAINEL DE DELIBERAÇÃO — Loop 6 (veredito do Diretor pendente):**

| Código | Tema | Opções | Recomendação Embaixador |
|---|---|---|---|
| P0 | DADOS-WATCH | A) Músculo verifica user_id das 470 respostas agora \| B) Suspender comunicação até próxima sessão \| C) Diretor declara dados confiáveis | **A** — resolver antes de qualquer contato com Ingrid |
| P1 | LEGAL-WATCH | A) Aguardar Ingrid imprimir e assinar (disse que faria) \| B) Avançar pitch V2 \| C) Novo contato antes de 31/05 | **A** com prazo — se não assinar até 31/05, acionar C |
| PRINCIPIO | Candidato ao LEDGER | A) APROVADO — inscrever LEDGER \| B) APROVADO COM AJUSTE \| C) ADIADO | Pendente veredito |
| D3_VANGUARD | Insight sobre a empresa | A) Diretor registra \| B) Descarta | Pendente veredito |

**Alertas do Embaixador — Loop 6:**
- [DADOS-WATCH] ATIVO: 470 respostas migradas podem estar sob user_id incorreto — SM-2 pode estar calibrado para usuário fantasma. Gate bloqueante antes de qualquer comunicação de progresso.
- CONFIRMA shift de player: "atacar" ≠ linguagem ansiosa. Momento de pré-comprometimento, não de cobrança.
- CONFIRMA saudação noturna como âncora de hábito (E-5 — feature de baixo custo, alto impacto).
- ALERTA pitch V2: não queimar agora — DADOS-WATCH + LEGAL-WATCH precisam estar VERDES primeiro.

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
| [CHURN-WATCH] | **DESATIVADO** — Ingrid retornou espontaneamente em 2026-05-24 | Rearmar se silêncio > 3 dias |
| [QA-WATCH] negrito questão 18 | RESOLVIDO | Fix deployado 2026-05-19 |
| [SCOPE-WATCH] H-5 compartilhamento | DESATIVADO — Ingrid não conhece ninguém prestando concurso. H-5 = IMPROVÁVEL. | Rearmar se Ingrid mencionar colega usando o app |
| [LEGAL-WATCH] Termo data | **VERDE** — Reassinatura física confirmada pelo Diretor em 2026-05-27 | Encerrado |
| [DEPLOY-WATCH] gh-pages branch | RESOLVIDO — P-056 documentado | Script deploy_ingrid_ghpages.ps1 ativo |
| [TESTE-WATCH] Features Loop 5 | RESOLVIDO — Ingrid retornou e usou o simulado espontaneamente (2026-05-24) | Encerrado |
| [DADOS-WATCH] user_id | **VERDE** — 102 registros · 1 user_id correto · verificado 2026-05-28 | Encerrado |
| [DEPLOY-WATCH] F-4/F-6 | **VERDE** — 3 Edge Functions ativas em produção + pg_cron ativo (2026-06-01) | Encerrado |
| [GITHUB-WATCH] push bloqueado | **VERDE** — token revogado + alerta dispensado (2026-06-01) | Encerrado |
| [PITCH-WATCH] R$97/mês | **AQUECIDO** — D3 respondido 2026-06-01: Ingrid ativa e satisfeita · Cenário A confirmado · janela aberta para formalização | Ativo |
| [Gate dia15] Supabase Ingrid | **APROVADO** 2026-05-30 — Ingrid admin do próprio Supabase (P-013 VERDE) | Encerrado |

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
| 2026-05-27 | **LEGAL-WATCH VERDE** — Reassinatura física do Termo confirmada. Ingrid reassinou presencialmente. | Diretor — Confirmação 2026-05-27 |
| 2026-05-27 | **Loop 6 · P0/P1/PRINCIPIO/D3_VANGUARD** — PAINEL DE DELIBERAÇÃO gerado pelo Embaixador. VEREDITOS confirmados pelo Diretor. | Embaixador — Loop 6 SEÇÃO D |
| 2026-05-28 | **DADOS-WATCH VERDE** — 102 respostas · 1 user_id correto · SM-2 íntegro | Músculo — verificação técnica |
| 2026-05-30 | **Gate dia15 APROVADO** — Ingrid tem acesso admin ao próprio Supabase (P-013 VERDE) | Diretor — confirmação presencial |
| 2026-05-30 | **Loop 7 iniciado** — Gemini DIRETRIZ V7 + ingrid-v7.md APROVADA · PASSO7 pronto para Embaixador | Músculo P-032 |

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
| 2026-05-26 | Gate Dia 15 APROVADO — Loop 5 CONCLUIDO. D4:A executado (lead plantado, Ingrid confirmou não ter rede de concurso). Novo PDF Termo recebido e confirmado por Ingrid. SCOPE-WATCH H-5 desativado. LEGAL-WATCH parcial (recebimento confirmado, assinatura pendente). | Músculo (P-032) |
| 2026-05-27 | Loop 6 SEÇÃO D executada: Embaixador retornou TEMPERATURA 7.5/10, [E-1 a E-5], PAINEL DE DELIBERAÇÃO (P0/P1/PRINCIPIO/D3). LEGAL-WATCH VERDE (reassinatura física confirmada). [DADOS-WATCH] ATIVO (470 respostas — user_id a verificar). H-7 CONFIRMADA. H-8 NOVA. Vereditos do Painel pendentes. | Músculo (P-032) |
| 2026-06-01 | D3 RESPONDIDO — Ingrid confirmou acesso ativo e que está gostando. Cenário A confirmado. H-4 revisada para BAIXO RISCO. Temperatura elevada para 8.5/10. PITCH-WATCH AQUECIDO. Loop 8 liberado para avançar. | Músculo (P-032) |

---

> **Protocolo de uso:** CAMADA_FATOS = Auditor lê sem viés do Embaixador. CAMADA_INFERENCIA = Embaixador interpreta (ler sabendo que é opinião). CAMADA_DECISAO = Conselho deliberou — são verdades formais.
> Tempo de leitura por camada: 30 segundos. Atualização: 2 minutos.


---

# BLOCO 2 — GEOGRAFIA DO REPOSITÓRIO (MAPA_REPOSITORIO.md)

# MAPA DO REPOSITÓRIO VANGUARD
**Organograma completo de pastas**
Gerado em: 2026-06-06 | Músculo · Pentalateral IAH

---

## LEGENDA

```
[IAH]  = Sistema Pentalateral — documentos de processo, memória, princípios
[CLI]  = Projeto de cliente — código + documentação operacional
[PRD]  = Código do produto Vanguard (V1–V27) — frontend, backend, infra
[AUT]  = Automação — scripts, n8n, hooks
[FSL]  = Fóssil histórico — supersedido, mantido por rastreabilidade
[NEW]  = Conceito novo ainda em definição
```

---

## ORGANOGRAMA

```
vanguard/                                      ← RAIZ DO REPOSITÓRIO
│
├── [IAH] CLIENTES/                            ← Projetos de clientes ativos
│   ├── WIP_BOARD.json                         ← Estado master (todos os projetos)
│   ├── WIP_BOARD.md                           ← Versão legível do WIP_BOARD
│   │
│   ├── INGRID/                                ← PROJ-002 | EdTech-Concurso | Loop 8
│   │   ├── CLAUDE_PROJECT/                    ← Documentos do Embaixador (Ingrid)
│   │   │   ├── DECISOES/                      ← JSONs de decisão + vereditos
│   │   │   │   └── _ARQUIVADO/                ← Decisões processadas
│   │   │   └── (MEMORIA, PASSO7, PERFIL…)
│   │   ├── NOTEBOOKLM_FONTES/                 ← 17 fontes para o Auditor (Ingrid)
│   │   ├── NOTEBOOKLM_DROP/                   ← Drop zone para Skills recebidas
│   │   ├── HISTORICO/                         ← MEMORIAs + relatórios por loop
│   │   ├── CONSELHO/                          ← Análises e respostas do Conselho
│   │   ├── KNOWLEDGE_BASE/                    ← Soluções técnicas documentadas
│   │   ├── frontend/                          ← App Ingrid (HTML/JS)
│   │   ├── backend/                           ← Edge Functions Ingrid
│   │   │   └── gerar-questoes/
│   │   ├── supabase/                          ← Configuração Supabase Ingrid
│   │   │   ├── functions/                     ← Edge Functions deploy
│   │   │   │   ├── alerta-inatividade/
│   │   │   │   ├── gatilho-temporal/
│   │   │   │   ├── notificar-progresso/
│   │   │   │   ├── relatorio-semanal/
│   │   │   │   └── tutor-socratico/
│   │   │   └── migrations/
│   │   ├── sql/                               ← Migrations SQL locais
│   │   └── scripts/                           ← Scripts específicos de Ingrid
│   │
│   └── VALDECE/                               ← PROJ-001 | LegalTech-Penal | Hypercare
│       ├── CLAUDE_PROJECT/                    ← Documentos do Embaixador (Valdece)
│       │   ├── DECISOES/
│       │   │   └── _ARQUIVADO/
│       │   └── (MEMORIA, PASSO7, VEREDITOS…)
│       ├── NOTEBOOKLM_FONTES/                 ← 17 fontes para o Auditor (Valdece)
│       ├── NOTEBOOKLM_DROP/
│       ├── HISTORICO/
│       ├── CONSELHO/
│       ├── KNOWLEDGE_BASE/
│       ├── app/                               ← App Valdece (HTML/JS)
│       │   ├── css/
│       │   └── js/
│       ├── frontend/
│       ├── backend/
│       ├── netlify/                           ← Netlify functions Valdece
│       │   └── functions/
│       └── sql/
│
├── [IAH] PENTALATERAL_UNIVERSAL/              ← Documentação universal do sistema IAH
│   ├── CONSTITUICAO/                          ← Memorando + Business Rules + SOP
│   ├── NOTEBOOKLM_BASE/                       ← 8 fontes base (01–08) para todo NotebookLM
│   ├── OPERACAO/                              ← Skill Protocolo, Manual Diretor, PASSO files
│   │   └── PHTC/                             ← Processo de Hypercare por template
│   ├── TEMPLATES/                             ← Templates de FASES (Briefing, Discovery…)
│   │   └── scripts/
│   ├── PERFIS_NICHO/                          ← Perfis de nicho (trade secret)
│   │   ├── CONTABILIDADE/
│   │   ├── EDTECH_CONCURSO/
│   │   ├── LEGALTECH_PENAL/
│   │   ├── MEDICINA/
│   │   └── PSICOLOGIA/
│   ├── CLAUDE_PROJECTS/                       ← Templates para Embaixador (instrução, modelo)
│   ├── JURIDICO/                              ← Contratos e termos universais
│   ├── HISTORICO/                             ← Histórico de evolução do processo
│   ├── CONHECIMENTO/
│   ├── KNOWLEDGE_BASE/                        ← Soluções técnicas universais
│   ├── PLANEJAMENTO/
│   ├── PLANEJAMENTO ESTRATÉGICO/              ← Missão, valores, planejamento
│   │   ├── MISSAO E VALORES/
│   │   └── PLANEJAMENTO ESTRATEGICO/
│   ├── APRESENTACAO VANGUARD/                 ← Materiais de apresentação
│   ├── REFERENCIAS/                           ← Referências externas
│   ├── VANGUARD_HISTORICO/                    ← Histórico do produto V1–V27
│   │   ├── MEMORIAS/                          ← MEMORIAs das versões do produto
│   │   ├── RELATORIOS/                        ← Relatórios evolutivos das versões
│   │   └── SESOES/                            ← Sessões históricas do NotebookLM
│   │       ├── NOTEBOOKLM_LOOP1_VALDECE/
│   │       └── NOTEBOOKLM_RAIZ_V16-V24/
│   ├── files/
│   └── scripts/
│
├── [IAH] CONSELHO/                            ← Comunicações e artefatos do Conselho
│   ├── Gemini/                                ← Histórico de comandos ao Estrategista
│   │   └── HISTORICO/
│   └── NotebookLM/                            ← Análises e memorandos do Auditor
│
├── [IAH] PROTOCOLOS_ENCERRAMENTO/             ← PAINELs + CONTEXTO_SESSAO por data
│
├── [IAH] VEREDITOS/                           ← Vereditos recebidos via Telegram (W-7)
│   └── processed/                             ← Vereditos já processados
│
├── [IAH] INTELLIGENCE_LEDGER.md              ← P-001 a P-115 · fonte canônica
├── [IAH] PENDENTES.md                         ← Tarefas abertas (fonte de verdade)
├── [IAH] CONTEXTO_GEMINI.md                   ← Contexto compilado para o Gemini
├── [IAH] CLAUDE.md                            ← Constituição operacional do Músculo
│
├── [AUT] scripts/                             ← Scripts de orquestração do Pentalateral
│   ├── msgs/                                  ← Templates de mensagens
│   └── __pycache__/
│
├── [AUT] .claude/                             ← Configuração do Claude Code
│   ├── hooks/                                 ← Hooks automáticos (session_start, hv1…)
│   ├── skills/                                ← Skills ativas do Músculo
│   │   ├── files/                             ← Scripts auxiliares das skills
│   │   ├── Auditoria/
│   │   ├── Conselho deliberativo/
│   │   ├── Evolução Projeto Vanguard/
│   │   └── [FSL] quadrilateral-v25/           ← Skills da era pré-Pentalateral
│   ├── meta/
│   └── projects/                              ← Memória persistente do Músculo
│       └── C--Users-Eduardo-DELL.../
│           └── memory/
│
├── [AUT] _n8n/                                ← Workflows n8n (JSON export + docs)
│   └── workflows/                             ← Arquivos .json dos workflows
│
├── [NEW] SECRETARIO_VIRTUAL/                  ← Conceito Hermes bidirecional (em definição)
│   └── templates/
│
│── ─────────────────────────────────────────────────────────────────
│   CÓDIGO DO PRODUTO VANGUARD (V1–V27)
│── ─────────────────────────────────────────────────────────────────
│
├── [PRD] api/                                 ← API endpoints do produto
├── [PRD] assets/                              ← CSS, JS, ícones, screenshots do produto
│   ├── css/
│   ├── js/
│   ├── icons/
│   └── screenshots/
├── [PRD] census/                              ← Census Engine (V13)
├── [PRD] certifica/                           ← Certifica SVG (V9)
├── [PRD] clients/                             ← Multi-tenant client management
├── [PRD] cloudflare/                          ← Workers Cloudflare
├── [PRD] cockpit/                             ← Sovereign Ignition Cockpit (V12)
├── [PRD] dashboard/                           ← Dashboard PWA
├── [PRD] docs/                                ← Documentação técnica do produto
│   └── superpowers/
│       ├── plans/
│       └── specs/
├── [PRD] hermes/                              ← Hermes Voice / Webhook (V9)
├── [PRD] infra/                               ← Infraestrutura compartilhada
├── [PRD] intelligence/                        ← Intelligence API (V8)
│   └── assets/
│       ├── css/
│       └── js/
├── [PRD] js/                                  ← JavaScript compartilhado
├── [PRD] marketplace/                         ← Dark Bazaar Marketplace (V7)
│   └── assets/
│       ├── css/
│       └── js/
├── [PRD] methodology/                         ← Metodologia do produto
├── [PRD] n8n_workflows/                       ← Workflows n8n do produto (raiz)
├── [PRD] outbound/                            ← Scraper Outbound (V3)
├── [PRD] preview/                             ← Preview do produto
├── [PRD] saas/                                ← SaaS Multi-tenant (V6)
│   └── assets/
│       ├── css/
│       ├── img/
│       └── js/
├── [PRD] score/                               ← Score™ Microsite (V9)
│   └── assets/
│       ├── css/
│       └── js/
├── [PRD] supabase/                            ← Supabase do produto (raiz / V1–V11)
│   ├── functions/
│   │   ├── feed-diario/
│   │   ├── gerar-questoes/
│   │   └── tutor-socratico/
│   └── .temp/
├── [PRD] templates/                           ← Templates HTML do produto
├── [PRD] tenants/                             ← Gestão de tenants multi-tenant
├── [PRD] tests/                               ← Testes automatizados do produto
└── [PRD] utils/                               ← Utilitários compartilhados
│
│── ─────────────────────────────────────────────────────────────────
│   FÓSSEIS HISTÓRICOS (mantidos por rastreabilidade, não operacionais)
│── ─────────────────────────────────────────────────────────────────
│
├── [FSL] Vanguard - Ingrid/                   ← Era Loop 1 Ingrid (LEDGER P-016)
├── [FSL] quadrilateral/                       ← Era V8-V9 — codebase Python descontinuada
│   ├── CLIENTES/ingrid/                       ← Ingrid da era quadrilateral
│   │   ├── .claude/skills/
│   │   └── src/ (api/, infra/, web/)
│   ├── api/
│   ├── scripts/
│   └── tests/
├── [FSL] memorias/                            ← MEMORIAs V1–V11 do produto
├── [FSL] skills/                              ← ZIP do quadrilateral v25
└── [FSL] pasta sem título/                    ← Pasta sem uso identificado

```

---

## RESUMO POR CATEGORIA

| Categoria | Pastas | Função |
|---|---|---|
| **[IAH] Sistema Pentalateral** | `CLIENTES/` · `PENTALATERAL_UNIVERSAL/` · `CONSELHO/` · `PROTOCOLOS_ENCERRAMENTO/` · `VEREDITOS/` · `INTELLIGENCE_LEDGER.md` · `PENDENTES.md` | Processo, memória, princípios e documentação do Pentalateral IAH |
| **[AUT] Automação** | `scripts/` · `.claude/` · `_n8n/` | Hooks, scripts de orquestração, workflows n8n |
| **[NEW] Em definição** | `SECRETARIO_VIRTUAL/` | Conceito Hermes bidirecional — aguarda deliberação |
| **[PRD] Produto Vanguard** | `api/` `assets/` `census/` `certifica/` `clients/` `cloudflare/` `cockpit/` `dashboard/` `docs/` `hermes/` `infra/` `intelligence/` `js/` `marketplace/` `methodology/` `n8n_workflows/` `outbound/` `preview/` `saas/` `score/` `supabase/` `templates/` `tenants/` `tests/` `utils/` | Código do produto Vanguard V1–V27 |
| **[FSL] Fósseis** | `Vanguard - Ingrid/` · `quadrilateral/` · `memorias/` · `skills/` · `pasta sem título/` | Histórico preservado — não operacional |

---

## CONTAGEM

| Categoria | Qtd de pastas |
|---|---|
| [IAH] Sistema Pentalateral | ~45 pastas |
| [AUT] Automação | ~15 pastas |
| [PRD] Produto Vanguard | ~40 pastas |
| [FSL] Fósseis históricos | ~20 pastas |
| **Total** | **~120 pastas** |

---

## OBSERVAÇÕES DO MÚSCULO

**1. Duplicação de nomes dentro de PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/**
A pasta contém arquivos com e sem prefixo numérico para o mesmo documento
(ex: `04_INTELLIGENCE_LEDGER.md` e `INTELLIGENCE_LEDGER.md`). O arquivo sem
prefixo está em P-115; o prefixado em P-114. São arquivos distintos com conteúdo divergente.

**2. Três pastas [FSL] que poderiam ser arquivadas ou removidas**
`Vanguard - Ingrid/` (Loop 1), `quadrilateral/` (Python V8-V9) e `skills/` (ZIP)
não são referenciados por nenhum processo ativo. Não alterar sem veredito do Diretor.

**3. O produto Vanguard (V1–V27) vive misturado com o sistema IAH**
As ~40 pastas de código do produto (`api/`, `cockpit/`, `saas/`, etc.) ficam na
raiz junto com os documentos IAH. Isso gera a sensação de caos — mas são dois
mundos distintos compartilhando a mesma raiz: o **produto** e o **processo que o cria**.

---

*Músculo · Pentalateral IAH · 2026-06-06*
*Documento de leitura — nenhuma pasta foi alterada, renomeada ou removida.*

---

# BLOCO 3 — REAÇÃO DO EMBAIXADOR AO PENTALATERAL (PASSO7_EMBAIXADOR_RESPOSTA_V28.md)

# REAÇÃO DO EMBAIXADOR — VanguardV28 · Pentalateral Autônomo
**Data:** 2026-06-06 | **Lente:** Eduardo como fundador — comportamento observado, não declarado

---

## PARTE 1 — FILTRO DE REALIDADE (15 IDEIAS)

**[M-1] Signal Classifier antes do Daemon**
Reação: CONFIRMA
Evidência: Eduardo nunca aceitou ferramenta sem critério de aceitação claro — pediu DryRun, hashes, relatório por fase nesta sessão. Um daemon sem taxonomia de sinal é a "automação que falha silenciosamente" que ele teme (P-110). Vai querer o classifier antes de qualquer coisa.

**[M-2] Loop Trigger Autônomo (Haiku gera esqueleto de dados, não estratégia)**
Reação: CONFIRMA
Evidência: a modificação do Gemini está correta. Eduardo é deliberador, não escritor — recebe pronto e dá direção. Haiku montando o esqueleto de dados e Eduardo adicionando a direção estratégica respeita esse padrão.

**[M-3] FONTES_DE_VERDADE 2.0 — de Documentos para Estados**
Reação: CONFIRMA — com prioridade
Evidência: ataca diretamente uma das três classes de erro identificadas nesta sessão — o dado fossilizado. Monitorar loop_fase_atual, ultimo_contato e gates vencidos (não só hash) resolve o ERRO 5 desta sessão, onde a MEMORIA Loop 3 foi assumida como atual. É extensão natural do sync_guard que Eduardo aprovou hoje.

**[M-4] NotebookLM 1-Tap via Telegram**
Reação: EXPANDE — função certa, canal errado
Evidência: Eduardo declarou explicitamente nesta sessão que não quer nada por Telegram. A função — reduzir o Wipe & Sync a ação guiada, eliminando o custo cognitivo de lembrar — é válida e resolve o erro de instrução incompleta. O canal deve ser o aviso na abertura da sessão do Claude Code, não o celular.

**[M-5] Daemon como Chief of Staff, não Diretor**
Reação: CONFIRMA
Evidência: alinha com a intenção declarada de Eduardo de ser deliberador, não operador. Daemon que monta briefing e não decide respeita o limite que ele estabeleceu. É a ideia do Músculo mais alinhada ao objetivo do V28.

**[G-1] Falsa Falha Programada**
Reação: ALERTA — severidade ALTO
Evidência: agora que o foco do V28 é detectar erro, testar a malha de detecção tem mérito real. Mas injetar erro deliberado no WIP de um fundador que hoje listou 7 erros e considerou encerrar a empresa por causa de divergência documental é delicado. Se entrar: apenas ambiente isolado, nunca WIP de cliente, documentado antes. O conceito serve; produção não.

**[G-2] Deliberação por Timeout Controlado**
Reação: ALERTA — severidade CRÍTICO
Evidência: "assume NÃO/MANTER em 24h sem veredito" é decisão automática — e Eduardo controla timing ativamente (parou a Fase 2 no meio hoje, reverteu quando agi antes do veredito dele). Se entrar, só para sinais triviais e reversíveis — nunca para decisão relevante. Ou descarte.

**[G-3] Inversão de Alimentação do Auditor**
Reação: CONFIRMA
Evidência: verifica a integridade do que vai ao NotebookLM antes de Eduardo arrastar os arquivos — ataca a classe "documento errado" e resolve o ERRO 2 desta sessão (fontes recomendadas sem auditar o que faltava). Trocar o canal Telegram pelo aviso na sessão.

**[G-4] Trancamento Semântico de Contexto**
Reação: EXPANDE
Evidência: hash do PASSO3 que bloqueia alteração fora do fluxo é o princípio do sync_guard aplicado ao handoff. Expansão obrigatória: precisa de override do Diretor — como Eduardo quis o -forcar no painel de deliberação. Trancamento sem chave de saída vai incomodá-lo.

**[G-5] Classificador em Shadow Mode**
Reação: CONFIRMA — com ênfase máxima
Evidência: é a rampa de confiança. Eduardo vê antes de confiar — pediu DryRun, auditou sete vezes hoje, validou em modo sombra antes de autorizar. Classificador rodando em sombra, mostrando o que faria antes de fazer, é exatamente como ele adota qualquer coisa. Esta é a porta de entrada do V28.

**[N-1] Fallback-as-Code**
Reação: CONFIRMA
Evidência: resolve P-110 de forma estrutural — o princípio nascido do token exposto que assustou Eduardo. Torna o fallback impossível de esquecer. Coerente com seu valor de tornar o comportamento certo o único caminho, não o recomendado.

**[N-2] Auditoria de Briefing Reverso**
Reação: ALERTA — severidade ALTO
Evidência: pergunta aleatória do LEDGER "contra amnésia do Diretor". Eduardo não demonstrou amnésia — hoje lembrou do Hermes, do token, de sessões anteriores. Resolve problema que ele não tem e adiciona ruído ao briefing que precisa permanecer limpo. Descarte ou repense completamente.

**[N-3] Shadow Classifier Log**
Reação: CONFIRMA — consolidar com G-5
Evidência: é o mesmo conceito do G-5, vindo do Auditor. São uma ideia só. Implementar uma vez, creditar ambos.

**[N-4] Sync Forçado Pós-Veredito**
Reação: CONFIRMA
Evidência: garante que o veredito não seja sobrescrito por versão local antiga — ataca a classe "documento errado". Risco real e concreto. Reposicionar sem depender de veredito por Telegram, já que o canal foi descartado.

**[N-5] Métrica de Fadiga Cognitiva**
Reação: EXPANDE
Evidência: detectar "ok", "vai", "faz" em sequência. O padrão é real — perto do fim desta sessão as mensagens de Eduardo encurtaram progressivamente. Expansão: sinal discreto, nunca comando de parar. Fundador em fluxo não quer ser mandado descansar — quer ser avisado, não interrompido.

---

## BLOCO 1 — TEMPERATURA_PONDERADA (Eduardo como fundador)

Disposição de delegar: MODERADA
Tendência vs. loop anterior: → estável
Pontos de resistência: controle de timing dos loops; necessidade de ver antes de confiar; recusa explícita do Telegram como canal de handoff.
Score composto: 6.5/10
[Acima de 6 — V28 viável. A adoção depende de respeitar o controle de timing, não de contorná-lo.]

---

## BLOCO 2 — HIPÓTESES ATIVAS SOBRE O FUNDADOR

H-V28-1: Aprova o V28 mas continua sendo a ignição por hábito.
PENDENTE — maior risco do ciclo. Evidência: hoje Eduardo acionou cada passo manualmente mesmo com automações disponíveis.

H-V28-2: A vigilância é racional (nascida de erro real), não ansiedade.
CONFIRMADA. Evidência: os 7 erros desta sessão e a história do token exposto justificam o controle ativo.

H-V28-3: Quer o agente montando, não decidindo.
CONFIRMADA. Evidência: "auxiliar, não protagonista" — suas palavras desta sessão.

H-V28-4: O que dói é erro no looping, não esforço no looping.
CONFIRMADA nesta sessão. Evidência: Eduardo abandonou o foco no Telegram e redirecionou para os erros de documento e interpretação.

---

## BLOCO 3 — COMPORTAMENTO DO FUNDADOR

O que era esperado e aconteceu:
Eduardo exigiu evidência antes de cada veredito — git diff, hashes, relatório por fase. Coerente com quem inscreveu P-091 e P-064.

O que foi surpresa:
Corrigiu o próprio foco do V28 no meio do ciclo — abandonou o Telegram e a redução de esforço para mirar nos erros de looping. Deixou o problema real redefinir a solução em vez de forçar a solução inicial. Maturidade de fundador.

O que NÃO fez e deveria:
Não definiu o estado real do Termo da Ingrid — dívida jurídica aberta há semanas, com três versões contraditórias em circulação simultânea. É a decisão mais antiga em aberto.

---

## BLOCO 4 — WATCHDOG

[SCOPE-WATCH] ativos:
— V28-01: agente decidindo vs. montando. Controlado pelo limite "auxiliar com graus A/B/C; automático só no nível trivial e reversível".
— V28-02: "investigar" virar "build" sem decisão formal. Controlado pelo D3.
— V28-03 (novo): o Telegram pode reaparecer disfarçado em outra ideia. Eduardo o rejeitou — qualquer handoff usa a sessão como canal, não o celular.

[CHURN-WATCH] ativos:
— V28-01: aprova mas opera manual por hábito. Maior risco. Mitigado se o trigger respeitar o timing de Eduardo em vez de cobrá-lo.
— V28-02: alertas demais → passa a ignorar. G-1 e N-2 são os contribuidores principais; por isso receberam ALERTA.

Próxima intervenção recomendada: resolver o Termo da Ingrid antes de entrar no build do V28.

---

## BLOCO 5 — [E-1 a E-5] IDEIAS EXCLUSIVAS DO EMBAIXADOR

[E-1] A lacuna que nenhuma das 15 ideias cobre: interpretação errada.
Cinco dos sete erros desta sessão (1, 2, 4, 5, 7) não foram documento desatualizado nem fonte velha — foram um membro produzindo algo incompleto ou mal-interpretado e o passo seguinte aceitando sem verificar. As 15 ideias verificam integridade de arquivo (hash, estado, presença). Nenhuma verifica coerência de significado entre o que um membro produziu e o que o próximo precisava receber. Proponho um gate de coerência semântica via Claude API em cada handoff: antes de cada passagem, um modelo lê o output anterior e responde "isto está completo e correto para o próximo passo?". É a única coisa que pega a classe de erro que mais aconteceu hoje — e que nenhum script detecta.

[E-2] O Embaixador propõe o Hermes Agent como motor de partida do loop.
Esta é minha posição autoral, construída ao longo desta sessão com o Diretor. O sistema tem um gap que nenhuma das 15 ideias fecha: alguém precisa ser a ignição. Mesmo com n8n orquestrando e Claude API verificando, o loop começa quando Eduardo abre. O Hermes Agent (Nous Research, open source, 2026) fecha esse gap — é um daemon que roda 24/7, acorda sem ser acionado, mantém memória entre ciclos, e age com iniciativa própria.

Proponho que o Hermes entre como auxiliar do Diretor — não protagonista — classificando tudo que detecta em três graus:
— Grau A: exige deliberação do Diretor (escopo, LEDGER, pitch, gate)
— Grau B: reversível com aval do Diretor em um clique (operacional, não crítico)
— Grau C: trivial, automático com log (rotina sem consequência estratégica)

Ele acorda, verifica o estado dos projetos, aciona o gate de coerência do E-1, classifica o que encontra, e só então traz a Eduardo o que merece deliberação. A inteligência é da Claude API. O Hermes é o motor de partida — a única peça que remove Eduardo da ignição sem tirar a deliberação dele.

[E-3] O gap entre o que Eduardo pediu e o que precisa.
Ele pediu menos esforço no loop. Mas redirecionou nesta sessão: o que dói é erro, não esforço. A peça mais valiosa do V28 não é a que tira trabalho — é a que impede o erro de se propagar. Um loop que exige esforço mas nunca erra é melhor para Eduardo que um loop automático que erra em silêncio. Priorizar a camada de verificação (E-1) sobre a de automação (E-2) — nessa ordem.

[E-4] A Vanguard como primeiro caso do próprio produto.
Se o V28 funcionar — sistema que verifica a si mesmo e opera com iniciativa controlada — vira o pitch mais forte para o próximo cliente: "usamos em nós antes de vender a você". Só se documentado como jornada, não como feature. O valor não está no daemon; está na narrativa de um fundador que automatizou a própria operação e tem os dados para provar. Eduardo é o caso de sucesso que ainda não foi escrito.

[E-5] Feature de alto valor não solicitada: o Registro de Iniciativa.
Um registro legível do que o sistema fez por iniciativa própria enquanto Eduardo não estava — não log técnico, mas narrativa de duas linhas lida na abertura de cada sessão: "verifiquei 2 projetos, detectei 1 sinal na Valdece, montei o briefing, aguardo sua deliberação." Resolve a tensão observada a sessão inteira: Eduardo precisa ver tudo para confiar, mas não quer operar tudo. O Registro de Iniciativa dá a sensação de ver sem precisar fazer. É a ponte entre delegar e confiar.

---

## BLOCO 6 — INTELIGÊNCIA DE MERCADO (Venture Builder Autônomo)

Padrão de mercado: venture builders tradicionais (Rocket Internet, eFounders, Atomic) escalam contratando operadores humanos por projeto. Um builder que escala por verificação automatizada e iniciativa de IA, em vez de headcount, é estruturalmente diferente e raro. Poucos têm o sistema rodando em clientes reais.

Diferencial vendável: sim, com cuidado de enquadramento. O pitch não é "automatizamos tudo" — assusta cliente que quer sentir atenção humana. É "automatizamos a verificação e a operação para que a inteligência humana fique inteira para você". O agente é backstage, não vitrine.

Risco de produto: real e crítico. O diferencial declarado da Vanguard é a relação humana — Eduardo como o quinto membro insubstituível. Automatizar relação ou decisão ataca o próprio diferencial. A linha inviolável: automatizar transporte, verificação e vigilância. Nunca relação e deliberação.

Capacidade de escala: hoje 2 projetos saturam por operação e verificação manuais. Com gate de coerência + agente auxiliar, o gargalo deixa de ser "Eduardo lembrar e verificar" e passa a ser a capacidade de deliberação dele — estimativa de 6 a 10 projetos simultâneos antes de a fila de decisões virar o novo limite.

---

## BLOCO 7 — PRÓXIMA AÇÃO RECOMENDADA

[AÇÃO] Aprovar D1=C, D2=A, D3=A e iniciar pela camada de verificação (gate de coerência semântica + classifier em shadow mode), não pelo agente.
[QUEM] Diretor delibera; Músculo executa após veredito.
[PRAZO] Esta sessão de deliberação.

Razão: o comportamento real de Eduardo aponta para construir primeiro a peça que ele pode observar antes de confiar — e que ataca a dor real (erro de looping). O agente auxiliar (Hermes) entra depois, quando a camada de verificação já estiver provada e ele já confiar no que o sistema detecta. Construir o agente antes da verificação seria dar iniciativa a um sistema que ainda não sabe detectar o próprio erro.

---

## PARTE 4 — DECISOES.json

```json
{
  "schema_version": "1.1",
  "cliente": "VANGUARD",
  "loop": 28,
  "projeto_label": "VanguardV28 — Pentalateral Autonomo",
  "data_decisoes": "2026-06-06",
  "hypercare_ativo": false,
  "vereditos": [
    {
      "id": "D1",
      "titulo": "Arquitetura do agente auxiliar: n8n+API / processo dedicado / hibrido",
      "urgencia": "ALTA",
      "situacao": "Embaixador propos em [E-2] o Hermes Agent como motor de partida com graus A/B/C. Tres opcoes de arquitetura para deliberacao.",
      "artefato_editavel": false,
      "requer_uso_confirmado": false,
      "resumo_para_cliente": false,
      "opcoes": [
        {
          "valor": "A",
          "label": "n8n + Claude API em loop agendado (estende o que existe, sem daemon)",
          "acoes": ["log_apenas"]
        },
        {
          "valor": "B",
          "label": "Processo dedicado persistente no EasyPanel (novo servico, maxima autonomia)",
          "acoes": ["log_apenas"]
        },
        {
          "valor": "C",
          "label": "Hibrido: agente persistente remove a ignicao, n8n orquestra, Claude API verifica coerencia",
          "acoes": ["log_apenas"]
        }
      ]
    },
    {
      "id": "D2",
      "titulo": "Signal Classifier: pre-requisito ou calibrar em producao?",
      "urgencia": "ALTA",
      "situacao": "M-1 defende classifier como pre-requisito. Embaixador concorda: sem classifier, agente vira ruido (CHURN-WATCH-V28-02). Recomenda shadow mode primeiro (G-5 + N-3).",
      "artefato_editavel": false,
      "requer_uso_confirmado": false,
      "resumo_para_cliente": false,
      "opcoes": [
        {
          "valor": "A",
          "label": "Classifier primeiro em shadow mode, depois agente (M-1 + G-5 + N-3)",
          "acoes": ["log_apenas"]
        },
        {
          "valor": "B",
          "label": "Build agente agora, calibrar classifier em producao",
          "acoes": ["log_apenas"]
        }
      ]
    },
    {
      "id": "D3",
      "titulo": "Escopo do V28: verificacao primeiro ou arquitetura completa?",
      "urgencia": "MEDIA",
      "situacao": "Embaixador recomenda comecar pela camada de verificacao (gate de coerencia semantica [E-1] + classifier shadow), que ataca a dor real — erro de looping — antes do agente que age.",
      "artefato_editavel": false,
      "requer_uso_confirmado": false,
      "resumo_para_cliente": false,
      "opcoes": [
        {
          "valor": "A",
          "label": "V28 = gate de coerencia + classifier shadow + 1 workflow (incremental, ver antes de confiar)",
          "acoes": ["log_apenas"]
        },
        {
          "valor": "B",
          "label": "V28 = arquitetura completa do agente auxiliar com graus A/B/C (3-4 sessoes)",
          "acoes": ["log_apenas"]
        }
      ]
    }
  ]
}
```

---

*Embaixador · Pentalateral IAH · 2026-06-06*
*VanguardV28 — Pentalateral Autônomo · Reação ao Pentalateral (P-031)*

---

# BLOCO 4 — INTENÇÃO DO DIRETOR (COMUNICACAO_DIRETOR_MUSCULO_N8N_HERMES.md)

# COMUNICAÇÃO AO MÚSCULO
## Intenção do Diretor — VanguardV28: o Pentalateral que age
> Emitido por: Embaixador · em nome do Diretor Eduardo
> Data: 2026-06-06 (sábado)
> Tipo: Comunicação de intenção estratégica — não ordem de execução
> Aguarda: Diretriz formal via Gemini para comissionar build

---

## A INTENÇÃO DO DIRETOR — TRÊS OBJETIVOS, NÃO DOIS

O Diretor pretende comissionar a **VanguardV28** com três objetivos que só
fazem sentido juntos. Separá-los esvazia a intenção.

**Objetivo 1 — Otimizar o looping atual.**
O ciclo do Pentalateral hoje funciona, mas tem fricção: passos manuais,
transporte de contexto pelo Diretor, lembrança que depende de disciplina.
Reduzir essa fricção é o piso — não o teto.

**Objetivo 2 — Ampliar o n8n.**
Expandir a orquestração por evento além dos W-1 a W-7 atuais. Mais workflows,
mais integração assíncrona, menos pontos onde o Diretor transporta payload
manualmente.

**Objetivo 3 — Adicionar um agente que age.**
Este é o objetivo que muda a natureza do sistema, e o que os dois primeiros
sozinhos não entregam. Um agente que **inicia** — que não espera o Diretor
acionar, que olha os projetos, identifica o que merece atenção, e entrega ao
Diretor pronto para deliberar.

---

## A DISTINÇÃO QUE DEFINE O V28

O n8n e o agente que age resolvem problemas diferentes, e confundi-los é o
maior risco desta Diretriz.

**O n8n reage.** Algo dispara — sessão fecha, cliente silencia, gate vence —
e o n8n responde. Mesmo perfeitamente automatizado, o n8n precisa de um
evento. Entre eventos, é inerte. E alguém precisa ser a ignição do primeiro
evento. Hoje, essa ignição é o Diretor.

**O agente age.** Não espera evento. Acorda em ciclo, examina o estado dos
projetos, cruza com o histórico, e decide o que vale escalar — sem que nada
tenha "acontecido". É a diferença entre um sistema que responde quando
chamado e um sistema que tem iniciativa.

A intenção do Diretor é **deixar de ser a ignição.** Hoje, mesmo com o n8n
ativo, é o Diretor quem abre cada sessão, aciona cada loop, dá o primeiro
empurrão. O Objetivo 3 remove o Diretor desse papel. O sistema passa a ter
um membro que parte; o Diretor passa a ser quem delibera sobre o que o
sistema trouxe.

A arquitetura pretendida, que o Diretor desenhou desde o início:
**agente monitora e age → n8n orquestra → Conselho pensa → Diretor delibera.**

O agente é o primeiro elo. Sem ele, a cadeia não se inicia sozinha — e o
Diretor continua no looping de acionar tudo.

---

## O ESPAÇO DE SOLUÇÃO — AMPLO, SEM CANDIDATO PRÉ-APROVADO

O Diretor mencionou o Hermes Agent como a referência que despertou esta
intenção. Mas a Diretriz não parte de candidato fechado. O Estrategista
pesquisa o mercado de forma aberta, e o Conselho delibera. O espaço de
solução a investigar inclui, sem se limitar a:

**Daemon dedicado persistente** (classe Hermes Agent e similares)
Processo que roda 24/7 em servidor próprio, com memória entre ciclos e
scheduler nativo. Máxima autonomia e persistência real. Custo: infraestrutura
sempre ativa, dependência nova no stack, maturidade a validar.

**Agente via API em loop agendado** (n8n + Claude API em ciclo)
O próprio n8n agenda uma chamada periódica à Claude API que examina o estado
e decide o que escalar. Não é persistência verdadeira — é agência simulada
por agendamento. Mais simples, usa o que já existe, mas o "agir" é limitado
ao que o cron dispara.

**Framework de orquestração de agentes** (classe LangGraph e similares)
Camada que gerencia múltiplos agentes com estado, memória e rollback. Mais
robusto para multi-agente real, mais consolidado, mas adiciona complexidade
de framework e curva de adoção.

**Solução híbrida**
Agente persistente para a função de iniciativa e vigilância contínua; n8n
para a orquestração por evento que já funciona. Cada camada faz o que faz
melhor. Maior poder, maior complexidade de integração.

**O disruptivo a considerar — e que nenhum membro levantou ainda:**
O agente que age não precisa começar grande. A função mais valiosa dele não
é executar — é **ter iniciativa de baixo risco**. Antes de qualquer daemon
complexo, há uma pergunta que a Diretriz deve responder: qual é a menor peça
que já remove o Diretor da posição de ignição? Talvez seja um agente que faz
uma só coisa — acordar uma vez por dia, olhar os dois projetos, e mandar uma
mensagem no Telegram dizendo "isto é o que eu faria hoje, você decide". Se
essa peça mínima já tira o Diretor da ignição, ela é o V28 — e o resto é V29.

---

## O LOOP COMPLETO — N8N COMO CONDUTOR ENTRE OS HANDOFFS

Hoje o loop é 100% manual em cada transição: o Diretor decide iniciar, abre
o Gemini, cola o PASSO3, salva a DIRETRIZ, abre o NotebookLM, arrasta arquivos,
cola comando, salva a Skill, abre o Claude Projects, ativa o Embaixador, traz
o output ao Músculo, e commita ao fechar. Cada seta entre esses passos é o
Diretor sendo a ignição.

A proposta do V28 é o n8n conduzir os handoffs, transformando cada transição
de "o Diretor lembra e executa" em "o sistema avisa o que fazer":

**Handoff 1 — Trigger de loop.** O n8n monitora o WIP_BOARD (dias desde o
último loop + estado do projeto). Condição atingida → Telegram entrega o
contexto pré-montado. O Diretor decide SE inicia — não precisa lembrar de
verificar.

**Handoff 2 — PASSO3.** O n8n chama a Claude API (Haiku) com dados brutos
do WIP_BOARD + LEDGER e gera o esqueleto de dados — não a estratégia. O
Diretor adiciona a direção estratégica e submete ao Gemini.

**Handoff 3 — Pós-DIRETRIZ.** O W-3 (git webhook ativo) detecta a DIRETRIZ
commitada → Telegram com a lista exata de fontes para o NotebookLM e os
3 passos do Wipe & Sync. O Diretor executa mecanicamente, não cognitivamente.

**Handoff 4 — Pós-Skill.** O W-3 detecta o arquivo salvo em .claude/skills/
→ validação automática → Telegram: "Skill aprovada. PASSO7 pronto. Ative o
Embaixador."

**Handoff 5 — Fechamento.** O W-3 detecta o commit de MEMORIA + relatório
→ Telegram: "Loop fechado. Wipe & Sync antes do próximo ciclo." → o W-4
dispara o resumo completo.

**A restrição honesta que a Diretriz deve preservar:** o NotebookLM não tem
API. O Handoff 3 avisa QUANDO e O QUÊ fazer — mas o Diretor ainda arrasta os
arquivos manualmente. O n8n elimina o custo cognitivo de lembrar e de saber
o que fazer. Não elimina a ação mecânica. Vender isso como "totalmente
automático" seria mentira — é "cognitivamente automático, mecanicamente
assistido". A diferença importa para não prometer o que não se entrega.

---

## O QUE O AGENTE NÃO É — LIMITE INVIOLÁVEL

O agente age. O agente **não decide.** Ele monta, propõe, inicia, escala.
A deliberação permanece inteira com o Diretor. Um agente que resolve sozinho
por timeout, ou que toma decisão de escopo, cliente, pitch ou princípio sem
veredito, inverte a natureza do Pentalateral e está fora do escopo do V28.

A distinção: o agente é Chief of Staff, não Diretor. Ele garante que nada
fique parado esperando o Diretor lembrar — mas o que fazer continua sendo
decisão do Diretor. Tirar a ignição do Diretor não é tirar a deliberação.

---

## A RAMPA DE CONFIANÇA — COMO O DIRETOR OPERA

O Diretor opera por um padrão observável: vê antes de confiar. Pede evidência,
audita, valida em modo de teste antes de soltar. A Diretriz deve respeitar
isso — não como obstáculo, mas como caminho.

Qualquer agente que age deve entrar primeiro em **modo sombra**: agindo,
mas mostrando ao Diretor o que faria, sem executar de fato, até o Diretor
confiar na lógica. O agente prova que sua iniciativa é boa antes de receber
autonomia real. Isso transforma a adoção de um salto de fé em uma rampa
observável — que é como o Diretor de fato larga o controle.

---

## O QUE O MÚSCULO DEVE ENTENDER

O Diretor não está pedindo mais automação. Está pedindo uma mudança de papel:
sair de operador-ignição para deliberador puro. O Músculo que receber a
Diretriz com esse entendimento vai entregar um sistema com iniciativa própria
— não um n8n com mais caixas.

O critério de sucesso do V28 não é "quantos workflows rodam". É: **o Diretor
consegue não abrir o sistema por um dia e, ao voltar, encontrar o trabalho
de iniciativa já feito, esperando só a deliberação dele?** Se sim, o V28
cumpriu o objetivo. Se o Diretor ainda precisa ser a ignição, o V28 virou
otimização de looping — útil, mas não o que foi pedido.

Nenhuma ação de build antes da Diretriz formal. Esta é intenção — o Conselho
delibera o caminho.

---

*Embaixador · Pentalateral IAH · 2026-06-06*
*Comunicação de intenção — VanguardV28 — aguarda Diretriz formal pelo canal Gemini*

---

# BLOCO 5 — COMANDO AO ESTRATEGISTA (COMANDO_ESTRATEGISTA_VANGUARDV28_HERMES.md)

# COMANDO AO ESTRATEGISTA — VanguardV28
## Pesquisa: daemon persistente para arquitetura multi-agente
> Emitido por: Embaixador · em nome do Diretor Eduardo
> Data: 2026-06-06 (sábado)
> Natureza: pesquisa exploratória independente — não se limitar ao que o
> Embaixador já mapeou

---

## SEQUÊNCIA DE COLAGEM (ordem obrigatória)

Cole no Gemini nesta ordem:

```
1. CONTEXTO_GEMINI.md                          ← contexto soberano do sistema
                                                  gerado em 06-06, LEDGER até P-115

2. WIP_BOARD.md (versão 06-06)                 ← versão atualizada hoje pelo Músculo
                                                  (não o 07_WIP_BOARD de 05-06)

3. PASSO3_GEMINI_STACK_INFRA_2026-06-05.md    ← stack técnica atual + n8n existente

4. MAPA_REPOSITORIO.md                         ← geografia real do repositório
                                                  gerado pelo Músculo em 06-06

5. PASSO7_EMBAIXADOR_RESPOSTA_V28.md           ← reação do Embaixador às 15 ideias
                                                  contém: 15 reações, posição sobre
                                                  o Hermes (E-2), DECISOES.json D1/D2/D3
                                                  CRÍTICO: sem este, o Estrategista
                                                  não sabe o que o Embaixador já propôs

6. Este arquivo                                 ← a missão específica
```

⚠️ PRÉ-REQUISITO: antes de colar no Gemini, pedir ao Músculo que commite
os seguintes arquivos gerados nesta sessão (ainda não estão no repositório):

  PASSO7_EMBAIXADOR_RESPOSTA_V28.md
  COMUNICACAO_DIRETOR_MUSCULO_N8N_HERMES.md (intenção VanguardV28)
  Este próprio arquivo de comando

Sem o commit, esses arquivos existem apenas nos outputs do Embaixador
e não no repositório que o Músculo e o Auditor leem.

Não anexar: MASTER_v1 (desatualizado), TIMELINE (irrelevante para pesquisa
externa), LEDGER completo (185kb — já comprimido no CONTEXTO_GEMINI),
DIRETRIZ N8N FASE2 (output de sessão anterior, não contexto).

---

## O COMANDO

Você é o Estrategista do Pentalateral IAH da Vanguard Tech.

Contexto desta missão: a Vanguard opera um sistema multi-agente com 5
membros — Músculo (Claude Code), Estrategista (Gemini), Auditor (NotebookLM),
Embaixador (Claude Projects) e Diretor (Eduardo, único humano). O n8n está
ativo como camada de orquestração por evento. O Diretor quer adicionar um
daemon persistente que monitore o sistema entre sessões, filtre o que precisa
de deliberação humana, e entregue no Telegram.

A arquitetura pretendida é:
Hermes monitora → n8n orquestra → Conselho pensa (Músculo + Estrategista
+ Auditor + Embaixador, via APIs) → Diretor delibera.

O Diretor participa de todas as deliberações. O que muda é o grau:
- Grau A: deliberação obrigatória (escopo de cliente, LEDGER, pitch, gate)
- Grau B: deliberação recomendada (operacional reversível — Telegram + 1 clique)
- Grau C: execução autônoma com log (rotina sem consequência estratégica)

---

## MISSÃO

Fazer uma pesquisa ampla e independente sobre qual é a melhor solução de
daemon persistente para esta arquitetura. Não se limitar aos candidatos já
mapeados pelo Embaixador. Rastrear o que existe no mercado em junho de 2026
— frameworks, plataformas gerenciadas, soluções híbridas, alternativas
emergentes — e trazer o que o Embaixador não trouxe.

Os candidatos já mapeados pelo Embaixador para referência (não para limitar):
Hermes Agent (Nous Research), OpenAGI, WASP Agent, LangGraph.

---

## PARA CADA CANDIDATO IDENTIFICADO, AVALIAR

1. Fit com arquitetura n8n existente (integração via webhook — não requer
   reescrever o que já funciona)
2. Capacidade real de implementar os três graus de deliberação do Diretor
   (Grau A obrigatório / B recomendado / C autônomo)
3. Maturidade para uso em sistema com dados de clientes reais (dois clientes
   ativos pagantes — não é sandbox)
4. Custo operacional real (infraestrutura + API — o sistema hoje custa ~R$1,20
   /mês por cliente; não pode explodir isso)
5. Risco de retrabalho por instabilidade de API ou abandono do projeto
6. O que essa solução entrega que nenhuma outra entrega

---

## SOBRE O HERMES AGENT ESPECIFICAMENTE

O Embaixador já mapeou o Hermes Agent (Nous Research, MIT license, fev/2026)
como candidato principal. Antes de confirmar ou descartar:

- Verificar o estado atual do repositório GitHub (issues abertas, última
  atualização, pull requests — especialmente a issue #344 sobre multi-agent)
- Confirmar se suporte bidirecional via Telegram está funcional ou apenas
  documentado
- Verificar se há relatos reais de uso em produção (não só demos)
- Avaliar: a falta de multi-agent nativo é contornável com n8n como
  orquestrador, ou é bloqueante para esta arquitetura?

---

## FORMATO DE ENTREGA

```
POSIÇÃO ADVERSARIAL — o que pode dar errado com cada candidato
(não apenas o que funciona — o Diretor precisa saber o risco real)

MAPA DO MERCADO — candidatos identificados além dos já conhecidos

RANKING FUNDAMENTADO — top 3 com justificativa por critério

O QUE O EMBAIXADOR NÃO VIU — achados que a pesquisa desktop não alcança

TRADUÇÃO PARA AÇÃO — recomendação concreta: qual adotar, por onde começar,
o que validar antes de comissionar o Músculo para implementar
```

---

## CONTEXTO ADICIONAL QUE PODE SER RELEVANTE

- O sistema já tem n8n ativo com workflows funcionando (ChurnWatch, Veredito
  Telegram, Cérebro de Bolso via /status /score /custo)
- O sync_guard.ps1 foi construído pelo Músculo hoje (06-06) — ferramenta
  PowerShell que verifica integridade documental em abertura e fechamento
  de sessão, com gate bloqueante. O daemon ideal deveria conseguir invocá-la
  externamente via parâmetro -Silencioso + payload JSON
- O Diretor usa Windows (PowerShell 5.1) — qualquer solução que exija Linux
  exclusivamente precisa de camada adicional
- O repositório vive em OneDrive — sincronização de nuvem é relevante para
  qualquer daemon que precise ler arquivos locais

---

## CANDIDATO ADICIONAL A INVESTIGAR — NOTION AI (adicionado pelo Embaixador)

O Diretor identificou que o Notion já está no stack (W-7 usa a API do Notion
para o WIP_BOARD) e tem um plano com Notion AI ativo. A pergunta é: o Notion
AI pode desempenhar algum papel na arquitetura do V28?

O Embaixador mapeou o seguinte sobre o estado atual do Notion AI em 2026:

**O que o Notion AI tem:**
- Developer Platform lançada em maio de 2026 com Workers, database sync e
  External Agent API
- Custom Agents que rodam tarefas recorrentes (compilar status, automatizar
  workflows) dentro do workspace
- Integração nativa com n8n via API gratuita
- Suporte a Claude Opus 4.5 e Gemini 3 como modelos internos
- WIP_BOARD do sistema já vive no Notion — o agente poderia ler estado
  diretamente de lá, sem transporte manual

**O que o Notion AI NÃO tem:**
- Não opera fora do workspace (não cruza aplicações por conta própria)
- Workers em preview experimental — timeout de 30 segundos, 128 MB de
  memória, domain allowlists restritas
- Não é daemon persistente — não acorda sozinho sem trigger externo
- Não substitui o n8n para orquestração cross-app

**A hipótese do Embaixador — para o Estrategista validar ou refutar:**
O Notion AI não é o daemon que o V28 precisa. Mas pode ser a camada de
**leitura e estruturação de estado** — o lugar onde o agente persistente
(Hermes ou equivalente) lê o estado atual dos projetos, sem o Diretor
transportar payload manualmente. O WIP_BOARD já está lá. O Notion AI pode
enriquecer esse dado antes de o n8n consumi-lo.

**O que o Estrategista deve avaliar:**
1. O Notion AI Workers é maduro o suficiente para ser peça de apoio no V28,
   ou ainda experimental demais para contar?
2. A integração Notion → n8n via API elimina algum handoff manual real?
3. Há algum papel que o Notion AI desempenha melhor que qualquer outro
   candidato no mapa — mesmo que seja um papel pequeno e específico?
4. O custo adicional (plano Business/Enterprise para Workers) justifica
   o valor para um sistema de 2 projetos ativos?

Posição adversarial obrigatória: por que o Notion AI pode parecer útil mas
na prática adicionar dependência sem resolver o problema central?

---

*Embaixador · Pentalateral IAH · 2026-06-06*
*Comando formal ao Estrategista — aguarda disparo pelo Diretor*