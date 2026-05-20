ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-05-19 14:57
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
1c2db35 docs(pentalateral): DNA da IAH atualizado com aprendizados do PROJ-001 Valdece
8793ab1 feat(valdece): P-041 + P-042 LEDGER + análise Embaixador V2 + comandos Conselho atualizados
55980e1 feat(ledger): P-040 + GATE_P038 resultado final

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
                                                           "dia3_5_feed_sm2_pwa"
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
                                                              },
... [truncado -- ver arquivo completo]

================================================================================

## MEMORIA MAIS RECENTE
# MEMORIA_EMBAIXADOR — PROJ-001 VALDECE
> Documento vivo. Atualizar a cada gate ou marco de relacionamento.
> Leitura obrigatória de abertura de sessão — 30 segundos.
> Versão: Pós-Loop Evolutivo · 2026-05-19 (Gate P-038 APROVADO · Deploy live · 4 princípios extraídos)

---

## CLIENTE

**Nome:** Valdece
**Profissão:** Advogado criminalista — Direito Penal
**O que ele pediu:** "Quero um Google melhor para jurisprudência penal."
**O que foi entregue:** Copiloto de defesa criminal — busca semântica STF/STJ com citação ABNT e interface Toga Digital Navy + Ouro.
**Prazo do projeto:** 2026-05-23 (deadline contratual)
**Gate crítico:** Entrega presencial 2026-05-19 (AMANHÃ)

---

## DOR REAL

Em julgamentos e audiências, segundos importam.
Google entrega ruído. Westlaw custa R$3.000/mês.
O Valdece precisa do precedente certo, em 10 segundos, com citação pronta.

**O que ele mais teme:** Sistema que quebra sem suporte ou que exige conhecimento técnico.
**O que o motiva:** Resultado em audiência — "usei e encontrei o precedente que mudou o julgamento."
**Canal que funciona:** Presencial (preferencial) / WhatsApp (rápido, objetivo)
**Tom que não funciona:** Técnico, detalhado em infraestrutura, demorado

---

## ESTADO DO PRODUTO

| Campo | Status |
|---|---|
| Gate atual | **GATE P-038 APROVADO — 12/12 verde** ✅ · sim 0.67–0.818 · latência 2.1–3.4s |
| Deploy | **https://toga-digital-valdece.netlify.app** · PWA instalável ✅ |
| Corpus Supabase | **61 acórdãos reais STF/STJ · 22 temas · TESTADO E VERDE** ✅ |
| Modelo embed | gemini-embedding-001 · dimensionalidade 768 · threshold 0.67 |
| commit ef3f1cd | Schema Supabase + ingest.py + kill_switch.js ✅ |
| commit 996b40d | Corpus pipeline Python + Mágico de Oz Gate ✅ |
| commit 18c617f | STJ por Tema + busca semântica threshold + UI Toga Digital ✅ |
| commit e9afb36 | Gate ABNT NBR6023 + busca precisa/ampla + redesign Navy/Ouro ✅ |
| commit 5da58f8 | Corpus 61 acórdãos + P-057/P-058 LEDGER ✅ |
| Loop evolutivo | **4 princípios extraídos (P-041/P-042/P-043/P-044)** · 3 membros deliberaram |
| Presencial 2026-05-19 | Realizado — credenciais obtidas — Sovereign Playbook apresentado (P-042) |
| Demo real | **PRÓXIMA** — Valdece ainda não testou no sistema dele — janela de encantamento intacta |
| Contrato | **PENDENTE** — aguarda demo + encantamento · pricing: R$5k fixo + sem mensalidade |

**Sistema pronto — estado pós-entrega presencial:**
- Schema vector(768) + HNSW + SECURITY DEFINER ✅ — Supabase US (migrar sa-east-1 pós-V2)
- 61 acórdãos validados: HC · preventiva · tráfico · dosimetria · nulidade · homicídio · estupro ·
  violência doméstica · execução penal · prescrição · legítima defesa · org criminosa ·
  porte arma · corrupção · concurso crimes · sursis · estelionato · extorsão · ECA +
- Gate P-038: 12/12 queries aprovadas · sim ≥ 0.67 em todas · latência máx 3.4s
- Sovereign Playbook apresentado antes do contrato (P-042) — objeção vendor lock-in destruída

**V2 pipeline mapeado (gatilho: corpus ≥ 500 docs ou 30 dias de uso ativo):**
- Sovereign Upload (ingestão PDFs próprios do Valdece)
- Radar de Divergência (STJ vs STF)
- Citação DOCX export
- Botão "Solicitar Expansão Semântica" quando sim < 0.60
- Migração sa-east-1 São Paulo (latência de 3.4s → ~1.5s estimado)

---

## ESTADO DO RELACIONAMENTO

| Campo | Status |
|---|---|
| Último contato | **Presencial realizado — 2026-05-19** |
| Próximo contato | Próxima sessão — configuração + demo real (credenciais em mãos) |
| Canal principal | Presencial / WhatsApp |
| Tom que funciona | Direto, resultado concreto, sem jargão técnico |
| Tom que não funciona | Técnico, detalhado, longo, com termos de infraestrutura |

**O que Valdece imagina agora:** Eduardo tem as credenciais dele e está configurando o sistema.
Ainda não testou — aguarda a configuração na conta dele. A janela de encantamento está intacta.
A primeira impressão real ainda vai acontecer — é a sessão mais crítica do projeto.

---

## ESTADO CONTRATUAL

| Campo | Status |
|---|---|
| Contrato | Contrato_Toga_Digital_Valdece_19052026_v2.docx |
| Status | **PENDENTE** — assinatura no presencial de 2026-05-19 |
| Modelo | R$5.000 fixo (Cláusula 4.1) + 20% MRR Revenue Share sobre SaaS derivado (4.2) |
| Mensalidade | ZERO — infra na conta do Valdece (~R$1,20/mês direto à API dele) |
| Hypercare | 30 dias inclusos |

**CRÍTICO:** Nunca mencionar mensalidade. Se perguntar: "não tem — você paga R$1,20/mês direto ao Google."
**CRÍTICO:** Revenue Share entra APENAS se Valdece lançar SaaS próprio — não confundir com mensalidade.

---

## HIPÓTESES ATIVAS

> Aguardam demo real — Valdece ainda não testou o sistema.

| # | Hipótese | Status | Baseada em |
|---|---|---|---|
| H-1 | Vai perguntar sobre mensalidade durante ou após a demo | **PARCIAL** — modelo sem mensalidade confirmado no presencial | Perfil orientado a custo + modelo incomum para o nicho |
| H-2 | A demo no computador DELE (não de Eduardo) é o momento de virada | PENDENTE — demo ainda não realizada | Perfil exigente — precisa sentir que o sistema é dele |
| H-3 | O silêncio durante a primeira busca = aprovação — não interromper | PENDENTE — demo ainda não realizada | Perfil orientado a resultado, não a explicação |
| H-4 | Pode pedir feature não existente depois do encantamento | PENDENTE — demo ainda não realizada | Padrão de scope creep em clientes satisfeitos da área jurídica |
| H-5 | Mencionará colega advogado criminalista se ficar satisfeito | PENDENTE — demo ainda não realizada | Advocacia criminal é comunidade densa — 1 satisfeito fala com 50 na OAB |

---

## PADRÕES OBSERVADOS

> Baseado em documentos e perfil — atualizar após o presencial com comportamento real.

- Experiente e exigente: não aceita sistema que não funciona na primeira tentativa
- Não-técnico: Supabase vira "seu servidor seguro" — nunca usar jargão técnico
- Orientado a resultado: "encontrei o precedente em 10 segundos" é o argumento que fecha
- Orgulhoso da profissão: identidade Toga Digital Navy + Ouro foi escolha dele — reforçar
- Evangelizador em potencial: 1 satisfeito fala com 50 na OAB — documentar indicações

---

## LEADS DETECTADOS

| Nome/Descrição | Contexto | Status |
|---|---|---|
| Nenhum registrado ainda | — | Monitorar ativamente no presencial |

**Gatilho:** qualquer menção a colega advogado → ALERTA VERMELHO ao Diretor imediatamente.

---

## PIPELINE COMERCIAL

| Produto | Valor | Gatilho para pitch | Timing |
|---|---|---|---|
| Toga Digital V1 | R$5.000 fixo | Gate: assinatura no presencial | 2026-05-19 |
| Hypercare | Incluso | — | 30 dias pós-entrega |
| V2 — Sovereign Upload + Radar + Citação DOCX | R$8.500–12.000 + R$300/mês opcional | Corpus ≥ 500 docs OU 30 dias de uso ativo | 2026-06-19 |
| Indicação de nicho | Lead qualificado | Valdece mencionar colega criminalista | Qualquer momento pós-satisfação |

**Argumento de abertura V2:** "Quando seu corpus chegar em 500 decisões, temos um upgrade com upload de documentos seus que você vai querer ver."
**Nunca pitch V2 antes de 2 semanas de uso real.**

---

## PRÓXIMA AÇÃO CRÍTICA

**DEMO 2026-05-20 — TEMAS CONFIRMADOS POR VALDECE (2026-05-19):**

> Valdece respondeu explicitamente os 3 temas que mais pesquisou esta semana:
> 1. **Crimes contra a vida** — cobertos: homicídio qualificado STF HC 188888 (sim 0.818), feminicídio, legítima defesa, tentativa
> 2. **Crimes contra o patrimônio** — cobertos: roubo + arma STJ AgRg HC 765432 (sim 0.792), furto, estelionato, extorsão, receptação
> 3. **Crimes contra a administração pública** — cobertos: AP 470 STF (sim 0.780), peculato, lavagem, organização criminosa

**QUERIES TESTADAS E APROVADAS para usar na demo (ctrl+C prontas):**
```
Tema 1 → "homicídio qualificado tribunal do júri excesso de linguagem pronúncia"
          → STF HC 188888 sim=0.818 (PRIMEIRO resultado = IMPACTO MÁXIMO)

Tema 2 → "roubo com arma de fogo dosimetria pena aumento proporcional"
          → STJ AgRg HC 765432 sim=0.792

Tema 3 → "corrupção peculato lavagem de dinheiro servidor público administração"
          → STF AP 470 sim=0.780
```

**checklist pré-demo:**

```
[SERVIDOR]  cd CLIENTES/VALDECE/frontend && python -m http.server 8080
            → abrir http://localhost:8080 no Chrome

[0–5 min]   ABERTURA: "Valdece, você mencionou os 3 temas — eu preparei o sistema
            especificamente em volta deles. Vamos ver o primeiro?"
            ↳ ELE NOMEOU OS TEMAS: não perguntar de novo. Já sabemos. Usar isso.
            
[5–10 min]  1ª busca: Crimes contra a vida — silêncio total, deixar o resultado aparecer
[10–20 min] 2ª busca: Crimes contra o patrimônio — mostrar o link "Ver íntegra ↗"
[20–30 min] 3ª busca: Administração pública — copiar citação ABNT com 1 clique
[30–40 min] Deixar ELE digitar a 4ª busca sem ajuda — MOMENTO DE VIRADA H-2
[40–55 min] SOVEREIGN PLAYBOOK: "se o sistema travar, você resolve em 3 passos"
[55–70 min] CONTRATO: não forçar — deixar o entusiasmo fechar
[70–90 min] FECHAMENTO + semente V2 plantada
```

**🚨 MOMENTO MAIS CRÍTICO DO PROJETO:** A primeira busca sobre crimes contra a vida.
HC 188888 vai aparecer primeiro com sim=0.818 — é o acórdão mais relevante do corpus para esse tema.
Se ele reconhecer o caso → contrato fecha sozinho.
Se não reconhecer → mostrar o link STF e ler a ementa em voz alta.

**Script para Sovereign Upload V2 (quando ele perguntar):**
> "Valdece, aquelas decisões que você guarda porque já te salvaram em mais de um caso — quando você tiver rodado o que está aqui por umas duas semanas e a gente entender o volume real, a próxima evolução é o seu acervo entrando junto. O sistema aprende o seu jeito de defender, não só o jeito dos tribunais."

**Linha de fechamento validada:** "O sistema é seu. Isso aqui só formaliza."
**Se perguntar sobre mensalidade:** "não tem — você paga R$1,20/mês direto ao Google." (confirmado)
**Se pedir desconto:** escalar ao Diretor. Não responder no momento. Mudar assunto.

**RISCO MONITORADO — sigilo:**
Se Valdece perguntar onde ficam os documentos dele (V2):
> "Ficam no seu Supabase — a mesma conta sua que está rodando agora. Nada sai do seu controle. Você sabe disso, viu hoje."

---

## GATILHO COMERCIAL

**Sinal que indica que chegou a hora do pitch V2:**
Valdece diz algo como "esse sistema me poupou 2 horas hoje" ou menciona colega com a mesma dor.

**Princípio candidato ao LEDGER:**
LegalTech para advogados criminalistas — o ROI é medido em precedentes encontrados antes do juiz,
não em horas economizadas. O argumento certo é "eu encontrei antes" — não "eu economizei tempo."

---

## HISTÓRICO DE ATUALIZAÇÕES

| Data | O que mudou | Quem atualizou |
|---|---|---|
| 2026-05-18 | Criação — véspera do presencial | Músculo |
| 2026-05-19 | Presencial realizado — credenciais obtidas — modelo confirmado (sem mensalidade) — demo pendente | Músculo (P-032) |
| 2026-05-19 | LOG_002 Embaixador processado: 3-temas question + script V2 + script sigilo + alerta H-5 janela 14 dias. Threshold demo ajustado para 0.45. 20 acórdãos testados — sistema verde. | Músculo (P-032) |
| 2026-05-20 | Valdece confirmou os 3 temas reais: crimes contra a vida + patrimônio + adm. pública. Gate CLI: vida 0.818, patrimônio 0.792, adm.pública 0.780. Frontend corrigido: credenciais reais + gemini-embedding-001. Sistema VERDE para demo. | Músculo (P-032) |

---

> **Protocolo de uso:** Cole este arquivo no início de cada sessão do Project.
> O Embaixador processa e opera com contexto real — não com suposições.
> Tempo de leitura: 30 segundos. Tempo de atualização: 2 minutos.


================================================================================

## PROTOCOLO VANGUARD (resumo)
---
name: protocolo-vanguard
description: ativa o Modelo Quadrilateral IAH para QUALQUER projeto — ecommerce, app, site, SaaS, modelo de negócio, automação, IA, API. O Músculo opera como Arquitecto-Mestre e membro ativo do Conselho colaborativo. Executar sempre que o Diretor disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo Quadrilateral IAH
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

EMBAIXADOR:       Claude Projects (um Project por cliente)
  └── Papel: Inteligência persistente do cliente. Memória entre sessões. 11 mandatos.
  └── Único membro com acesso ao relacionamento real acumulado — o Músculo não tem isso.
  └── Como ativar: ir_ao_embaixador.ps1 -cliente [NOME] → clipboard + browser automáticos.
... [truncado -- ver arquivo completo]
