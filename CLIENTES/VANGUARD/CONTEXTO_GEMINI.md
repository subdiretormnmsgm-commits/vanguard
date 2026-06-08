ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-06-08 19:27
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
a3a7d99 docs(auditoria): Loop 29 cirurgica completa -- P-127 + SKILL v6.9 + MANUAL v1.8 + WIP L29 + sync [RESOLVE: auditoria-loop29]
972c7d8 feat(fechamento): gate e-mail + P-127 + auditoria mandato 2026-06-09
63afe6c feat(skills): gemini-pentalateral v2.1 -- browser automation Embaixador->Estrategista

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
    "atualizado_em":  "2026-06-09",
    "wip_limits":  {
                       "build":  2,
                       "check":  1
                   },
    "board":  {
                  "discovery":  [

                                ],
                  "build":  [
                                {
                                    "id":  "PROJ-000",
                                    "cliente":  "VANGUARD",
                                    "projeto":  "VanguardV29 -- Pentalateral Autonomo",
                                    "area":  "Infraestrutura Interna -- Pentalateral IAH",
                                    "camada":  "0 (Infraestrutura Vanguard -- nao e projeto cliente)",
                                    "valor_fechado":  0,
                                    "tipo":  "Projeto Interno -- Evolucao do Sistema",
                                    "status":  "BUILD",
                                    "loop_atual":  "Loop 29 -- EM BUILD",
                                    "build_iniciado_em":  "2026-06-06",
                                    "deadline":  null,
                                    "churn_watch_threshold":  null,
                                    "stack":  "Hermes Agent (Docker EasyPanel) + n8n (orquestrador) + Claude API (Haiku -- verificacao)",
                                    "loop_fase_atual":  {
                                                            "loop":  29,
                                                            "gemini":  "PENDENTE",
                                                            "notebooklm":  "PENDENTE",
                                                            "embaixador":  "PENDENTE",
                                                            "musculo":  "EM BUILD",
                                                            "proximo":  "Gemini -- PASSO3_GEMINI.md pronto -- ir ao Gemini com skill gemini-pentalateral v2.1"
                                                        },
                                    "vereditos_loop28":  {
                                                             "D1":  "C -- Hibrido: Hermes + n8n + Claude API",
                                                             "D2":  "A -- Signal Classifier shadow mode primeiro (7 dias observacao)",
                                                             "D3":  "A -- V28 = E-1 + Classifier shadow + Hermes Agent + State Guard (~8h total)"
                                                         },
                                    "entregues_v28":  [
                                                          "gate_coerencia.ps1 -- E-1 Gate de Coerencia Semantica via Haiku",
                                                          "skill_parser_gate.ps1 -- E-1 integrado ao final",
                                                          "MAINTENANCE_COST.md v2.0 -- fallbacks W-8 + W-9 + Hermes Agent",
                                                          "render_painel.ps1 -- VANGUARD adicionado ao ValidateSet",
                                                          "DELIBERACAO_LOOP_V28_VANGUARD.md -- P-037 gate satisfeito",
                                                          "DECISOES_VANGUARD_2026-06-06.json -- D1=C D2=A D3=A",
                                                          "VEREDITOS_VANGUARD_2026-06-06.json -- veredito verbal registrado"
                                                      ],
                                    "pendentes_v28":  [

                                                      ],
                                    "entregues_v28_completo":  [
                                                                   "W-8 Signal Classifier -- ATIVO shadow mode n8n EasyPanel (2026-06-07)",
                                                                   "Hermes Agent -- ONLINE EasyPanel hermes/hermes-agent OpenRouter+Telegram (2026-06-07)",
                                                                   "silenced_signals_log -- CRIADA Supabase com RLS (2026-06-07)",
                                                                   "gate_coerencia.ps1 -- INTEGRADO skill_parser_gate",
                                                                   "State Guard -- INTEGRADO session_start",
                                                                   "N-4 executar_vereditos -- sync forcado pos-veredito",
                                                                   "P-116 inscricao no INTELLIGENCE_LEDGER",
                                                                   "MEMORIA_EMBAIXADOR_VANGUARD.md -- perfil fundador",
                                                                   "NARRATIVA_FUNDADOR.md -- Vanguard como primeiro caso do proprio produto",
                                                                   "ping_hermes.ps1 -- health check Hermes",
                                                                   "RUNBOOK_EASYPANEL.md -- fonte canonica EasyPanel",
                                                                   "RUNBOOK_SUPABASE_DDL.md -- fonte canonica Supabase"
                                                               ],
                                    "hermes_agent":  {
                                                         "status":  "ONLINE",
                                                         "plataforma":  "EasyPanel hermes/hermes-agent",
                                                         "modelo":  "anthropic/claude-sonnet-4-6 via OpenRouter",
                                                         "telegram":  "configurado (home: 8895733647)",
                                                         "grau_atual":  "A -- age apenas com aprovacao",
                                                         "config_path":  "/opt/data/config.yaml",
                                                         "shadow_mode_w8_expira":  "2026-06-14"
                                                     },
                                    "principios_v28":  [
                                                           "P-115 -- Musculo assessora ativamente conclusao de pendentes (2026-06-06)",
                                                           "P-116 -- o que doi e erro, nao esforco -- verificacao antes de automacao (2026-06-06)"
                                                       ],
                                    "principios_v29":  [
                                                           "P-121 -- automacao nao iniciada pelo cliente e ameaca de churn (2026-06-08)",
                                                           "P-122 -- deliberacao precede P-032 (2026-06-08)",
... [truncado -- ver arquivo completo]

================================================================================

## PROTOCOLO VANGUARD (resumo)
---
name: protocolo-vanguard
description: ativa o Modelo PENTALATERAL IAH para QUALQUER projeto — ecommerce, app, site, SaaS, modelo de negócio, automação, IA, API. O Músculo opera como Arquitecto-Mestre e membro ativo do Conselho colaborativo. Executar sempre que o Diretor disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo PENTALATERAL IAH
**Versão da Skill:** 6.6 — Universal · Colaborativo · Qualquer projeto · Qualquer operador · 7 Leis Soberanas + 8 Frameworks de Gestão ativos · Intelligence Compounding · Protocolo de Imunidade do Conselho (2026-05-14) · **5º Membro: Embaixador + P-031 (2026-05-18) · 12 novas DEF + P-052/053/054/055 (2026-05-23) · DEF-E-8 + Pipeline DECISOES JSON + P-056/057/058 (2026-05-24) · n8n como Sistema Nervoso Autônomo + W-7 Veredito Telegram + P-101 a P-111 (2026-06-04) · BLOCO 0 Embaixador + Sync Guard + P-112 a P-115 (2026-06-06) · Hermes Agent ONLINE + W-8 Signal Classifier + P-116 a P-117 (2026-06-07)**

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

## MEMORIA MAIS RECENTE -- MEMORIA_V28_VANGUARD.md
# MEMORIA V28 — VANGUARD PENTALATERAL IAH
**Loop 28 · The Sovereign Autonomous Layer · 2026-06-07**

---

## TEMA DO LOOP

Transformar o Pentalateral de sistema assistido em sistema autônomo.
Eduardo delibera. Hermes executa. O loop não para entre sessões.

---

## O QUE FOI CONSTRUÍDO

| Entregável | Descrição | Status |
|-----------|-----------|--------|
| W-8 Signal Classifier | n8n workflow — classifica sinais em AUTO-RESOLVE/INFORMAR/DELIBERAR-A/B/C. Shadow mode 7 dias. | ✅ ATIVO |
| Hermes Agent | Motor autônomo — EasyPanel, responde no Telegram, usa OpenRouter/Claude. PID 251. | ✅ ONLINE |
| silenced_signals_log | Tabela Supabase com RLS — log de sombra do W-8 | ✅ CRIADA |
| gate_coerencia.ps1 | Validação semântica via Haiku API antes de propagar decisões | ✅ INTEGRADO |
| State Guard | state_guard.ps1 — detecta anomalias no WIP_BOARD na abertura de sessão | ✅ INTEGRADO |
| ping_hermes.ps1 | Health check do Hermes Agent — exit 0/1/2 + flag -Telegram | ✅ CRIADO |
| sync_guard -WhatIf | Modo passivo real — exibe o que faria sem escrever em disco | ✅ IMPLEMENTADO |
| N-4 executar_vereditos | Sync forçado pós-veredito (P-033 automático após deliberação) | ✅ INTEGRADO |
| MEMORIA_EMBAIXADOR_VANGUARD.md | Perfil comportamental do Fundador — temperatura 9.2/10 | ✅ CRIADO |
| NARRATIVA_FUNDADOR.md | Argumento central: Vanguard como primeiro caso do próprio produto | ✅ CRIADO |
| RUNBOOK_EASYPANEL.md | Fonte canônica: deploy Compose BETA, n8n API, erros conhecidos | ✅ CRIADO |
| RUNBOOK_SUPABASE_DDL.md | Fonte canônica: DDL, RLS, anon vs service role, tabelas | ✅ CRIADO |
| P-115 no LEDGER | Músculo assessora ativamente pendentes + DEPENDENCY_MAP em toda sessão | ✅ INSCRITO |
| P-116 no LEDGER | O que dói é erro, não esforço — verificação antes de automação | ✅ INSCRITO |

---

## PRINCÍPIOS EXTRAÍDOS

- **P-115:** Músculo propõe execução de [musculo] pendentes em toda sessão. DEPENDENCY_MAP só concluído com 3 passos.
- **P-116:** Confiança no sistema se verifica, não se declara. Escada: shadow → Grau A → Grau B → Grau C.
- **Lição técnica EasyPanel:** Compose BETA não injeta vars do painel "Ambiente" no container. Usar `hermes config set` para persistir no volume `/opt/data/`.

---

## VEREDITOS DO LOOP

- **D1:** C — Híbrido Hermes + n8n + Claude API (não puramente um, não puramente outro)
- **D2:** A — Signal Classifier shadow mode primeiro (7 dias observação antes de agir)
- **D3:** A — V28 = E-1 + Classifier shadow + Hermes Agent + State Guard (~8h total)

---

## ESTADO TÉCNICO AO FECHAR

- Hermes: `OpenRouter ✓ · Telegram ✓ (home: 8895733647) · Gateway PID 251`
- W-8: ativo em shadow mode — 7 dias de observação iniciados em 2026-06-07
- Supabase: `silenced_signals_log` com RLS — anon pode SELECT e INSERT
- Persistência Hermes: token + allowed_chats + api_key em `/opt/data/config.yaml`

---

## O QUE FICA ABERTO → V29

- Hermes subir para Grau B (age + confirma, não apenas responde)
- W-8 sair do shadow mode após 7 dias de validação (2026-06-14)
- Integração W-8 → Hermes: sinal DELIBERAR-A dispara análise no Hermes
- Skill `pentalateral-graus-abc.md` upload no dashboard do Hermes
- Fix persistência OpenRouter via `.env` no volume (workaround atual: config.yaml)
- RLS do `silenced_signals_log` — restringir INSERT ao service_role (segurança)

---

## 5 IDEIAS DISRUPTIVAS PARA O GEMINI (Loop 29)

**M-1 — Hermes como árbitro de prioridade**
Quando W-8 classifica múltiplos sinais simultâneos, Hermes prioriza por impacto comercial (cliente ativo > interno > administrativo) e apresenta ao Diretor em ordem de urgência — não cronológica.

**M-2 — Grau B com janela de veto**
Grau B não precisa esperar confirmação ativa. Hermes age e dá 15 minutos para veto. Se Eduardo não rejeitar, a ação é confirmada automaticamente. Reduz carga sem perder controle.

**M-3 — Kanban do Hermes como WIP_BOARD espelho**
O `kanban.db` do Hermes pode ser populado automaticamente pelo Músculo ao session_close — transformando o Hermes num segundo ponto de verdade do estado dos projetos, acessível 24h via Telegram.

**M-4 — Hermes como co-piloto de reunião**
Antes de qualquer reunião com cliente, Eduardo envia: `/briefing Ingrid reunião`. Hermes responde com: temperatura do cliente, últimas interações, gate atual, o que não pode esquecer de dizer.

**M-5 — Hermes aprende com o Diretor**
Cada vez que Eduardo aprova ou rejeita uma sugestão do Hermes, o feedback vai para as `memories/`. Em 30 dias, o Hermes tem um perfil real do estilo de decisão do Diretor — sem Eduardo precisar explicar nada duas vezes.


================================================================================

## RELATORIO EVOLUTIVO -- relatorio_evolutivo_V28_vanguard.md
# RELATÓRIO EVOLUTIVO V28 — VANGUARD PENTALATERAL IAH
**Loop 28 · The Sovereign Autonomous Layer · 2026-06-07**
**Músculo · Síntese de Negócio + Processo**

---

## SWOT — ESTADO AO FECHAR V28

### FORÇAS

- **Hermes Agent ONLINE:** primeiro motor autônomo do sistema rodando 24h — EasyPanel, OpenRouter, Telegram. Gateway PID 251, config persistida em `/opt/data/config.yaml`. Pentalateral tem agora um 6º componente ativo entre sessões.
- **W-8 Signal Classifier ativo:** taxonomia de sinal implementada (AUTO-RESOLVE / INFORMAR / DELIBERAR-A/B/C). Shadow mode de 7 dias — o sistema aprende antes de agir. Prova de maturidade operacional.
- **Camada de verificação antes da automação (P-116):** o V28 redefiniu a filosofia de build. Verificação semântica via Haiku (gate_coerencia.ps1) entra antes de qualquer propagação de decisão. A dor real identificada pelo Embaixador (E-3) — é o erro que dói, não o esforço — se tornou princípio fundador.
- **State Guard integrado:** anomalias no WIP_BOARD detectadas na abertura de sessão, não quando o Diretor percebe. Fecha o loop de visibilidade sem custo cognitivo adicional.
- **Runbooks canônicos:** RUNBOOK_EASYPANEL.md + RUNBOOK_SUPABASE_DDL.md criados. Conhecimento técnico adquirido com dor documentado antes de ser esquecido — P-050 ativo.

### FRAQUEZAS

- **Hermes em Grau A:** toda ação requer aprovação do Diretor. Aumenta a autonomia percebida do sistema, mas o custo cognitivo de Eduardo não caiu — apenas mudou de canal (Claude Code → Telegram). Grau B é o próximo salto real.
- **W-8 shadow mode não gera alerta ativo:** os logs vão para `silenced_signals_log` mas o Diretor não vê o que o sistema *teria feito*. Falta o relatório de shadow — o Diretor não pode avaliar sem ver.
- **NOTEBOOKLM_FONTES/VANGUARD incompleta:** a pasta foi criada na sessão mas sem os arquivos base universais (00_INSTRUCAO_AUDITOR, 02_MEMORANDO, 05_PROCESSO, 06_TEMPLATES). MANIFEST VERMELHO ao fechar sessão.
- **pentalateral-graus-abc.md não carregada no Hermes:** o Hermes opera sem sua skill de referência. Gap de configuração que pode gerar comportamento inconsistente em interações futuras.

### OPORTUNIDADES

- **Pitch validado:** "Vanguard como primeiro caso do próprio produto" — NARRATIVA_FUNDADOR.md gerado. O diferencial de mercado é demonstrável: fundador que automatizou verificação e tem dados para provar.
- **Teto de projetos simultâneos:** com V28, a estimativa do Embaixador sobe de 3-5 para 6-10 projetos antes de saturar a atenção do Diretor. Capacidade de receita dobrada sem aumentar equipe.
- **Loop de confiança construível:** escada Grau A → B → C documentada. Em 30 dias com dados reais do shadow mode, a decisão de subir para Grau B é técnica, não de fé.

### AMEAÇAS

- **W-8 expira em 2026-06-14:** se o shadow mode não for avaliado antes dessa data, ou o sistema entra em produção sem validação (risco de falso positivo em cliente ativo) ou continua em shadow indefinidamente (automação travada).
- **ChurnWatch Valdece + Ingrid no limiar:** 3 dias sem contato (threshold 3). Se Hermes/W-8 não detectar e o Diretor não agir hoje, o próximo alerta já é VERMELHO — com cliente em Hypercare.
- **RLS do silenced_signals_log permissiva:** anon pode INSERT. Em produção com Grau B/C, um agente mal-configurado pode gravar lixo na tabela de sinal — corrompendo o aprendizado do W-8.

---

## PDCA — ANÁLISE DO CICLO V28

### PLAN (o que foi planejado)

- Arquitetura: Opção C Híbrida — Hermes (ignição) + n8n (orquestrador) + Claude API (verificação semântica)
- Signal Classifier em shadow mode 7 dias antes de qualquer ação real
- Gate de coerência semântica como prioridade 1 (E-1 Embaixador)
- Escopo fechado: ~8h core, 2-3 sessões

### DO (o que foi executado)

- ✅ Hermes Agent deploy EasyPanel — respondeu ao Telegram na sessão
- ✅ W-8 Signal Classifier importado no n8n, shadow mode ativo
- ✅ silenced_signals_log criada no Supabase com RLS
- ✅ gate_coerencia.ps1 + integração ao skill_parser_gate.ps1
- ✅ State Guard integrado ao session_start
- ✅ ping_hermes.ps1, sync_guard -WhatIf, N-4 executar_vereditos
- ✅ MEMORIA_EMBAIXADOR_VANGUARD.md + NARRATIVA_FUNDADOR.md
- ✅ RUNBOOK_EASYPANEL.md + RUNBOOK_SUPABASE_DDL.md
- ✅ P-115 + P-116 inscritos no LEDGER

### CHECK (o que ficou fora do plano)

- ❌ Templates Pentalateral + MANUAL_DIRETOR adiados (escopo grande, priorizou fechar V28 primeiro)
- ❌ Mensagens de atualização aos sócios sobre V28 não enviadas
- ❌ pentalateral-graus-abc.md não carregada no dashboard Hermes
- ❌ NOTEBOOKLM_FONTES/VANGUARD incompleta — MANIFEST VERMELHO
- ❌ relatorio_evolutivo não criado no session_close (gap corrigido nesta sessão)
- ⚠️ EasyPanel Compose BETA não injeta vars do painel "Ambiente" no container — workaround via `hermes config set` documentado no RUNBOOK

### ACT (o que muda no V29)

- Relatório de shadow mode: o W-8 precisa gerar summary semanal para o Diretor avaliar antes de 2026-06-14
- Hermes Grau B: após validação do shadow mode, subir delegação para "age + confirma em 15min"
- RLS silenced_signals_log: restringir INSERT ao service_role
- Integração W-8 → Hermes: sinal DELIBERAR-A dispara análise automática no Hermes

---

## 5W2H — PRÓXIMO LOOP (V29)

| Elemento | Resposta |
|---------|---------|
| **WHAT** | Hermes Grau B + relatório automático do W-8 shadow mode |
| **WHY** | Grau A não reduz custo cognitivo do Diretor. Grau B fecha o gap real. |
| **WHO** | Músculo build · Hermes executa · Diretor delibera escalações |
| **WHEN** | Depende da avaliação do shadow mode: data alvo **2026-06-14** (expiração W-8) |
| **WHERE** | EasyPanel hermes/hermes-agent + n8n + Supabase silenced_signals_log |
| **HOW** | (1) Relatório shadow mode automático via W-8 → Telegram · (2) Subir Grau B · (3) RLS restritiva |
| **HOW MUCH** | ~4h build (relatório shadow + Grau B) + 1h config (RLS + skill Hermes) |

---

## AVALIAÇÃO DO CONSULTOR

V28 entregou o que prometeu com uma ressignificação importante: o Embaixador identificou que o problema central não era automação — era verificação. Automatizar sem verificar é multiplicar erros. O P-116 nasce disso e vale mais que qualquer linha de código entregue neste loop.

O Hermes online é um marco — o Pentalateral tem agora seu primeiro componente 24h. Mas o risco real está na transição: um Hermes em Grau A sem skill carregada e com shadow mode não avaliado pelo Diretor é um componente caro e subaproveitado. A janela de 2026-06-14 é real — o Diretor precisa ver os dados do shadow antes que o prazo expire ou tomar decisão de prorrogar conscientemente.

Ponto positivo operacional: o V28 foi o primeiro loop onde o PROJETO INTERNO (VANGUARD) foi rastreado no WIP_BOARD com os mesmos campos de cliente — isso é evolução de maturidade do sistema.

---

*Relatório Evolutivo V28 · Músculo · Pentalateral IAH · 2026-06-07*
*Próxima etapa: Loop V29 — Gemini PASSO3 com M-1 a M-5 desta MEMORIA*


================================================================================

## MISSAO DESTA SESSAO -- PASSO3_GEMINI (VANGUARD)
# PASSO 3 — ESTRATEGISTA · VANGUARD UNIVERSAL
# Sessão: 2026-06-07/08 · Loop 29 · Nova Conformação Vanguard
# COMO USAR: colar este arquivo no chat do Gemini (texto)
#             anexar como arquivo: MEMORIA_RECENTE.md + INTELLIGENCE_LEDGER.md + WIP_BOARD.json

---

## [IDENTIDADE DO ESTRATEGISTA]

Você é o Estrategista do Pentalateral IAH — membro do conselho de inteligência coletiva da Vanguard Tech.

Sua função neste PASSO3: receber o contexto do Loop 29 e gerar a DIRETRIZ V29 com sua visão estratégica independente. Você enxerga padrões de mercado que o Músculo (executor) não vê de dentro.

**Sua deficiência a combater:** Síntese Multi-Doc — você tende a repetir o que foi dito em vez de contradizer. Se algo neste briefing for otimista demais, diga. Se houver risco que o Músculo não mencionou, nomeie.

---

## [CONTEXTO DO SISTEMA — O QUE VOCÊ VAI RECEBER]

**Arquivos anexados:**
- `MEMORIA_RECENTE.md` — contexto técnico e comercial dos últimos loops
- `INTELLIGENCE_LEDGER.md` — P-001 a P-126 (princípios que não se repetem)
- `WIP_BOARD.json` — estado atual dos 3 projetos: Ingrid, Valdece, Vanguard

**O que mudou no Loop 29 (sessão 2026-06-07/08):**

1. **INTELLIGENCE HUB ativado** — dois tracks:
   - Track COMPETITORS: relatório mensal de 5 empresas concorrentes por nicho
   - Track TRENDS: relatório semanal via /notebooklm — YouTube + artigos por nicho
   - Primeiro REPORT_COMPETITORS_2026-06.md gerado: EasyJur, CRIA.AI, iClinic, Effecti, vhsys
   - Track TRENDS validado em produção ao vivo pelo Diretor via /notebooklm skill

2. **Antigravity CLI v1.0.6 instalado** — motor do Intel Loop autônomo
   - GEMINI.md criado (identidade isolada — Intel Loop Motor, não Estrategista)
   - .agents/skills/intel-loop.md (checklists COMPETITORS + TRENDS)
   - PENDING_REVIEW.md (canal Antigravity → Músculo → Conselho)
   - P-124: Antigravity NÃO entra no loop de cliente — câmara de eco proibida

3. **/notebooklm skill v2 validada em produção pelo Diretor**
   - Skill atualizada com workflow operacional completo
   - YouTube como fonte nativa confirmada (Diretor testou: 5 fontes + podcast gerado)
   - P-125: fire-and-forget — Studio não bloqueia terminal
   - P-123: dois namespaces — [cliente]-base (permanente) + [cliente]-loop-N (efêmero)

4. **LOOP_STATE system v1.0**
   - LOOP_STATE_SCHEMA.json + instâncias por cliente (INGRID, VALDECE, VANGUARD)
   - pre_loop_action.ps1 + post_loop_action.ps1
   - Resolve amnésia pós-compactação — estado de cada loop em arquivo estruturado

5. **W-9 n8n criado** — Track TRENDS automatizado
   - Cron semanal (segunda 8h BRT) → Gemini grounding → GitHub → Telegram

6. **Princípios P-121 a P-126 inscritos no LEDGER**
   - P-121: automação não iniciada pelo cliente é ameaça de churn
   - P-122: deliberação precede P-032
   - P-123: dois namespaces de notebook
   - P-124: câmara de eco proibida entre sócios
   - P-125: fire-and-forget com webhook
   - P-126: descoberta técnica pode vir do Diretor, não de DIRETRIZ

---

## [MISSÃO DESTE LOOP — M-1 a M-5 DO MÚSCULO]

**[M-1] INTELLIGENCE HUB como arma de pré-venda**
Antes de qualquer reunião de prospecção, o Músculo gera um REPORT_COMPETITORS personalizado do nicho do potencial cliente. A Vanguard chega na reunião sabendo mais do mercado do cliente do que o próprio cliente. Custo: 0. Impacto: fecha a credibilidade antes do pitch.

**[M-2] /notebooklm como onboarding emocional do cliente**
Para cada cliente novo, gerar um podcast de 10 minutos sobre o nicho deles via /notebooklm. O Diretor entrega o áudio no dia de entrega: "Criei isso para você entender o mercado que vamos dominar juntos." Custo marginal zero. Diferenciação máxima — nenhum concorrente faz isso.

**[M-3] LOOP_STATE no W-7 — dashboard de loops via Telegram**
W-7 (Cérebro de Bolso) já responde /status. Expandir para `/loop [INGRID]` → retorna fase atual + próxima ação + dias sem contato. Diretor vê estado de todos os loops sem abrir nenhum arquivo. Build estimado: 30min.

**[M-4] Antigravity como simulador de PASSO3 pré-Gemini**
Antes de ir ao Gemini interativo, o Músculo roda o Antigravity com os mesmos inputs. O output não substitui a DIRETRIZ (P-124), mas prepara perguntas mais cirúrgicas para o PASSO3. Melhora a qualidade do que o Diretor leva ao Gemini.

**[M-5] Studio outputs como entregáveis recorrentes para clientes**
Cada loop que fecha com Ingrid ou Valdece gera um Audio Overview do relatório evolutivo via /notebooklm. Formato: 8-12min sobre "o que avançou este ciclo". O cliente sente o progresso sem precisar ler documentos técnicos. Diferenciação competitiva real.

---

## [MISSÃO PARA O ESTRATEGISTA]

**O que você responde:**

1. **DIRETRIZ V29** — sua visão estratégica sobre a nova conformação da Vanguard
   - Qual das M-1 a M-5 tem maior impacto comercial AGORA?
   - O que o INTELLIGENCE HUB muda na proposta de valor para novos clientes?
   - Há riscos sistêmicos na nova arquitetura (Antigravity + W-9 + /notebooklm) que o Músculo não está vendo?

2. **[G-1 a G-5]** — suas 5 ideias disruptivas

3. **[PARA O NOTEBOOKLM]** — bloco obrigatório ao final
   Skill nomeada: `vanguard-v29.md`

---

## [FORMATO OBRIGATÓRIO DA DIRETRIZ]

```
DIRETRIZ ESTRATÉGICA V29 — VANGUARD TECH — Loop 29

[1. VALIDAÇÃO DO MÚSCULO]
[2. DIVERGÊNCIA ESTRATÉGICA]
[3. DECISÃO CLARA] — ENTRA AGORA / V30 / DESCARTADO
[4. ENHANCEMENT]
[5. CUSTO REAL]
[6. IMPACTO COMERCIAL]
[7. PRÓXIMA AÇÃO]

[G-1 a G-5]

[PARA O NOTEBOOKLM]
Skill: vanguard-v29.md
[IDENTIDADE DO AUDITOR UNIVERSAL]
[O QUE AUDITAR NESTE LOOP]
[PADRÕES HISTÓRICOS CRÍTICOS]
[N-1 a N-5]
```

