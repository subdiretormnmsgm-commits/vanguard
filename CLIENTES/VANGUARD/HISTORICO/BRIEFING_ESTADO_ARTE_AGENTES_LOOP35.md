# BRIEFING_ESTADO_ARTE_AGENTES_LOOP35.md

> PARTE 6 do Auditor — Loop 35 VANGUARD. Gerado em 2026-06-15, ancorado em 18 transcricoes YouTube.
> Dossie de estado da arte de sistemas multi-agentes corporativos 2026.

---

## [1. CASE-BASED REASONING + RAG EM CONSULTORIA B2B (PROJETISTA)]

- **Padrao Arquitetural: RAG Agentic + Knowledge Graphs.** Como o video de Cole Medin demonstra, RAGs
  modernos nao injetam cegamente contexto (Naive RAG). O Agente raciocina antes. Combinar bancos como
  pgvector para pesquisa bruta com Neo4j para pesquisa relacional permite que o Projetista descubra
  conexoes de dores estruturais B2B (ex: "Microsoft e OpenAI formam parceria").
- **Aplicacao em Times Pequenos:** Multiplos agentes sem Immutable State Snapshots criam conflito
  (Sandipan Bhaumik). O Projetista processa o CBR extraindo a arquitetura em "versions" irreversiveis.
  O LLM atua apenas como "Planner" (raciocinio), e o codigo local atua deterministico ("Executor"),
  como explicado pelo canal BracesAndSemicolons.

## [2. AEO + EVENT-DRIVEN INTENT NO LINKEDIN B2B (EMBAIXADOR DIGITAL)]

- **O Dominio do AEO:** As respostas da IA priorizam sintese da "sabedoria das multidoes". O conteudo
  corporativo precisa de Info Gain (Ethan Smith), gerando valor onde ninguem fala. Modelos sao atraidos
  por listicles estruturados, mencoes em YouTube e comentarios autenticos em subreddits densos.
- **Sinal de Compra Baseado em Risco:** A distribuicao de "Money Keywords" e "Jobs-to-be-done" orienta
  o trafego do LLM com uma taxa de conversao 6x maior que o search classico do Google (Ethan Smith /
  Sam Dunning).
- **Gate Humano P-121:** A identificacao de intencao (via consumo no LinkedIn/site) funciona como radar.
  Todavia, a orquestracao deve entregar a "pesquisa/sinal" ao Diretor (Gate), em conformidade com as
  restricoes eticas (Agentic AI Red Teaming).

## [3. POLICY-AS-CODE + SEMANTIC DRIFT (DETECTOR)]

- **Guardiao Mecanico no Pre-Commit:** Como exposto em "Pre-Commit Hooks Explained", githooks formam a
  primeira linha de defesa deterministica. Se um arquivo tentar entrar no historico contendo jargao
  "IA/Claude" (Quebra R-3) ou falhar na estrutura yaml, a ferramenta (como Bandit, TruffleHog e o Hook
  nativo git 2.54) bloqueia (Exit 1).
- **Rastreio do Agent Drift e Custos:** O Detector de Deriva transcende a gramatica e usa telemetria.
  "Building AI Agents with Observability" detalha que "Unbounded Agents" devem ser controlados via
  Circuit Breakers e Alertas Reais de Telemetria (Logfire, OpenTelemetry). O baseline semantico detecta
  a "Alucinacao em Cascata", e caso haja multiplas falhas de um Agente ou de uma API, a execucao cai
  graciosamente para evitar desastres regulatorios e financeiros.
