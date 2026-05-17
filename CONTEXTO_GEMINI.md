ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-05-16 19:18
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## INTELLIGENCE LEDGER -- PRINCIPIOS ATIVOS
# INTELLIGENCE LEDGER — Quadrilateral IAH
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
**Aplica-se a:** toda sessão do Quadrilateral.

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
**Aplica-se a:** todo projeto gerido pelo Quadrilateral. Definir o número de loops no Passo 7 (aprovação do plano).

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
**Aplica-se a:** todo projeto do Quadrilateral, toda etapa de build, toda entrega a cliente.

---
... [truncado -- ver arquivo completo]

================================================================================

## WIP BOARD -- ESTADO DOS PROJETOS
{
    "atualizado_em":  "2026-05-16",
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
                                    "cargo":  "TDAS — Técnico em Desenvolvimento e Assistência Social",
                                    "banca":  "Instituto Quadrix",
                                    "stack":  "PWA + Supabase + Claude API",
                                    "loop_atual":  "Loop #1 — Build",
                                    "diretriz_gemini_v1":  true,
                                    "skill_notebooklm_v1":  true,
                                    "deliberacao_musculo":  true,
                                    "veredito_diretor":  true,
                                    "veredito_data":  "2026-05-15",
                                    "edital_sedes_json":  true,
                                    "build_iniciado_em":  "2026-05-15",
                                    "dias_completos":  [
                                                           "dia1_schema_edge",
                                                           "dia2_gate_questoes"
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
                                    "pendente_diretor":  [
                                                             "5 questoes reais Quadrix para playbook distratores (bloqueante Dia 2)"
                                                         ],
                                    "proximo_passo":  "Musculo executa Dia 1: schema SQL + Edge Function + Gate CLI"
                                },
                                {
                                    "id":  "PROJ-001",
                                    "cliente":  "Valdece",
                                    "projeto":  "Ferramenta de Busca Jurisprudência STF/STJ",
... [truncado -- ver arquivo completo]

================================================================================

## MEMORIA MAIS RECENTE
# MEMORIA V1 — PROJ-002 Ingrid
**Loop:** #1 — Kickoff e Deliberação  
**Data:** 2026-05-15  
**Próximo loop:** ao final do Dia 5 de build (gate Feed Adaptativo)

> Este arquivo é lido pelo Músculo no início do Loop 2.
> Contém o estado técnico real — decisões tomadas, dívidas, riscos, gates pendentes.

---

## ESTADO DO BUILD

| Item | Status |
|---|---|
| Loop atual | #1 concluído — aguardando Veredito do Diretor para Dia 1 |
| Dias completos | 0 — build ainda não iniciado |
| Deadline app | 2026-05-30 (15 dias de build) |
| Prova cliente | 2026-09-06 (114 dias) |
| Stack aprovada | PWA + Supabase + Claude API |

---

## DECISÕES FIXADAS — NÃO REVERTER

| Decisão | Razão |
|---|---|
| Fonte de questões = Claude API (estilo Quadrix) | P-003 — sem scraping TEC/QConcursos |
| Auth = single-user (sem login complexo) | MVP — Ingrid é a única usuária |
| Cache = lote 50 quando < 30 disponíveis | P-006 Lei 5 — evitar geração on-the-fly repetida |
| Proporção feed = 70% Peso 2 / 30% Peso 1 | Específicos valem 80/100 pontos — foco obrigatório |
| Haiku = gerais + dicas socráticas | Custo baixo para conteúdo simples |
| Sonnet = específicos (SUAS, LOAS, PNAS) | Qualidade máxima para conteúdo crítico |
| BURN_RATE_DAILY_LIMIT_USD = 5.00 | P-006 — limite antes de qualquer chamada API |
| Fallback = trigger em 70% da cota diária | Margem de segurança antes do hard-limit |
| SM-2 = intervalo variável | <30% acerto → 2 dias / 30-50% → 4 dias / >50% → 7 dias |
| Push MVP / email Loop 2 | Sem serviço de email complexo no MVP |

---

## ARQUITETURA APROVADA (Dias 1-2)

### Schema Supabase

```sql
-- Tabela de questões (global, multi-tenant desde o Dia 1)
questoes_quadrix (
  id uuid PRIMARY KEY,
  concurso_id text NOT NULL,       -- 'sedes_df_2026'
  disciplina_id text NOT NULL,     -- 'suas', 'loas', 'pnas', etc.
  peso_edital integer NOT NULL,    -- 1 ou 2
  score_prioridade integer,        -- peso × incidencia_historica_pct
  enunciado text NOT NULL,
  alternativas jsonb,              -- [{ letra, texto, correta }]
  gabarito text,
  explicacao text,
  nivel_dificuldade integer,       -- 1 (fácil) a 5 (difícil)
  estilo_quadrix text[],           -- ['literalidade', 'pegadinha_troca', ...]
  criada_em timestamptz DEFAULT now()
)

-- Progresso por usuário (per user_id — pronto para multi-tenant)
progresso_usuario (
  id uuid PRIMARY KEY,
  user_id uuid NOT NULL,           -- FK futura para auth.users
  questao_id uuid REFERENCES questoes_quadrix(id),
  respondida_em timestamptz DEFAULT now(),
  resposta_usuario text,
  correta boolean,
  tempo_resposta_seg integer,
  proxima_revisao_em date          -- SM-2
)
```

### Algoritmo de Feed Diário

```
score_prioridade = peso_edital × incidencia_historica_pct

Ranking (top-3 por score):
  1. SUAS       — score 196 — 10 questões estimadas na prova
  2. PNAS/LOAS  — score 190 — 7/6 questões estimadas
  3. CRAS/CREAS — score 184 — 4 questões estimadas

Feed diário de 20 questões:
  → 14 questões Peso 2 (70%) — priorizadas por score_prioridade DESC
  → 6 questões Peso 1 (30%) — priorizadas por score_prioridade DESC
  → SM-2 insere questões de revisão antes das novas
```

### Edge Function (Dias 1-2)

```
POST /gerar-questoes
  body: { disciplina, peso, quantidade, estilo_quadrix }
  → chama Claude API (Haiku ou Sonnet por peso)
  → valida JSON da resposta
  → insere em questoes_quadrix
  → retorna questões para o front
  
Trigger de cache:
  QUANDO questoes disponíveis (concurso_id, disciplina_id) < 30
  → gerar lote de 50 em background
  → BURN_RATE_DAILY_LIMIT_USD = $5.00 verificado antes
```

### Mágico de Oz Gate (Dia 2 — bloqueante)

```bash
# Eduardo avalia 10 questões geradas via CLI
node test_geracao.js --disciplina suas --quantidade 10
# Rubrica: estilo Quadrix (literalidade, alternativas plausíveis, pegadinhas)
# Gate passa se média >= 4/5 na rubrica
```

---

## GATES BLOQUEANTES POR DIA

| Dia | Gate | Critério | Output verificado |
|---|---|---|---|
| Dia 2 | Qualidade da questão | Eduardo avalia 10 questões — rubrica média >= 4/5 | JSON com 10 questões geradas no terminal |
| Dia 5 | Feed correto | Feed exibe plano 7 dias com proporção 70/30 correta | Tela do app mostrando disciplinas e contagens |
| Dia 8 | Experiência real | Ingrid responde 10 questões, progresso salvo, fallback testado | Registros no Supabase + log de custo |
| Dia 11 | Heatmap funcional | Heatmap verde/amarelo/vermelho correto + simulado domingo | Screenshot da tela + resultado do simulado |
| Dia 15 | Soberania (P-013) | Ingrid com acesso admin ao próprio Supabase | Login da Ingrid no Supabase confirmado ao vivo |

---

## VEREDITO DO DIRETOR — PENDENTE (BLOQUEANTE DIA 1)

O build não pode iniciar sem aprovação nos 8 pontos abaixo:

1. Schema multi-tenant desde o Dia 1 (questoes_quadrix + progresso_usuario)?
2. Haiku para gerais + dicas / Sonnet para específicos?
3. BURN_RATE_DAILY_LIMIT_USD = $5,00?
4. Cache: gerar lote 50 quando < 30 disponíveis?
5. Proporção feed: 70% Peso 2 / 30% Peso 1?
6. Fallback trigger em 70% (não 90%) da cota?
7. SM-2 intervalo variável (não 3 dias fixos)?
8. Push no MVP / email com tracking no Loop 2?

**Quando o Diretor responder SIM a todos → Músculo inicia Dia 1.**

---

## IDEIAS DO DIRETOR (REGISTRADAS — alimentar Gemini no Loop 2)

| ID | Ideia | Status |
|---|---|---|
| D-1 | Score de Incidência Histórica (peso × incidencia) | Implementado no edital_sedes.json |
| D-2 | Blocos de Incidência como critério de feed | Implementado no algoritmo_feed |
| D-3 | Análise Provas vs Editais (base proprietária) | Pesquisa feita, V2 pipeline |
| D-4 | Estrutura JSON rica por concurso (modelo reutilizável) | Implementado — edital_sedes.json v2.0 |
| D-5 | Podcast passivo (roteiro → TTS → áudio do dia) | Registrado, entra no Loop 2/V2 |

---

## DÍVIDAS TÉCNICAS

| Prioridade | Item | Impacto |
|---|---|---|
| P0 | 5 questões reais Quadrix para playbook de distratores | Sem isso o prompt de geração tem distratores fracos |
| P0 | Veredito do Diretor nos 8 pontos | Build bloqueado |
| P1 | Conteúdo topicos detalhados do PDF do Edital | edital_sedes.json tem estrutura mas pode complementar |
| P2 | Pesquisa provas reais anteriores para calibrar incidência_pct | Dados atuais são cross-concurso (Quadrix similares) |

---

## ARQUIVOS CRIADOS NO LOOP 1

```
CLIENTES/INGRID/
  BRIEFING_DISCOVERY.txt          ← respostas do discovery com Ingrid
  PASSO3_GEMINI.md                ← instrução ao Gemini (atualizada)
  PASSO5_NOTEBOOKLM.md            ← instrução ao Auditor
  PASSO6_MUSCULO.md               ← guia do Músculo (atualizado)
  DIRETRIZ_GEMINI_V1.txt          ← DIRETRIZ completa 7 blocos
  edital_sedes.json               ← v2.0 completo com score incidência
  HISTORICO/MEMORIA_V1_INGRID.md  ← este arquivo
  HISTORICO/relatorio_evolutivo_V1_INGRID.md
  sql/                            ← schema SQL (a criar no Dia 1)
  backend/                        ← Edge Functions (a criar no Dia 1)
  frontend/                       ← PWA (a criar no Dia 3)

.claude/skills/
  skill_proj002_ingrid_loop1.md   ← Skill do Auditor

INTELLIGENCE_LEDGER.md            ← P-014, P-015, P-016 adicionados
CLIENTES/WIP_BOARD.json           ← PROJ-002 em BUILD
```

---

## PRINCÍPIOS ATIVOS PARA O LOOP 2

- **P-003:** Sem scraping — questões são IP da Vanguard gerado via Claude API
- **P-006:** Burn Rate Shield — $5,00/dia hard-limit antes de qualquer chamada
- **P-007:** Mágico de Oz Gate — CLI valida geração antes de UI avançar
- **P-010:** Gate por dia — nenhuma etapa avança sem output verificado
- **P-013:** Supabase na conta da Ingrid desde o Dia 1
- **P-014:** Score de incidência histórica guia o feed — não o edital linear
- **P-016:** Podcast como V2 — não entra no MVP

---

*MEMORIA gerada pelo Músculo ao fechar Loop 1 · PROJ-002 Ingrid · 2026-05-15*


================================================================================

## PROTOCOLO VANGUARD (resumo)
---
name: protocolo-vanguard
description: ativa o Modelo Quadrilateral IAH para QUALQUER projeto — ecommerce, app, site, SaaS, modelo de negócio, automação, IA, API. O Músculo opera como Arquitecto-Mestre e membro ativo do Conselho colaborativo. Executar sempre que o Diretor disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo Quadrilateral IAH
**Versão da Skill:** 5.1 — Universal · Colaborativo · Qualquer projeto · Qualquer operador · 7 Leis Soberanas + 8 Frameworks de Gestão ativos · Intelligence Compounding · Protocolo de Imunidade do Conselho (2026-05-14)

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
> O Quadrilateral — Diretor + Estrategista + Auditor + Músculo — é o conselho.
> O cliente traz o problema. O conselho delibera. O Músculo entrega.

---

## CONFIGURAÇÃO DO OPERADOR

> Preencher uma vez por operador. Ao copiar para outro projeto ou outro operador, atualizar esta seção.
> Os valores abaixo são a configuração ativa deste Quadrilateral.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUADRILATERAL — CONFIGURAÇÃO ativa
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

TRIGGER:          PROTOCOLO VANGUARD
MEMORANDO:        MEMORANDO_QUADRILATERAL_UNIVERSAL.md
MOEDA:            BRL
PRODUTO_ENTRADA:  Sprint Discovery — [preço definido por Eduardo por projeto]
... [truncado -- ver arquivo completo]
