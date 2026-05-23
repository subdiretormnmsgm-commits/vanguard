# VANGUARD TECH — LINHA DO TEMPO EVOLUTIVA
> Organismo vivo. Atualizado pelo Músculo a cada marco real.
> Criado: 2026-05-17 | Última atualização: 2026-05-23
> Fonte obrigatória do Auditor (NotebookLM) em todo ciclo. Documento 16 em NOTEBOOKLM_FONTES.

---

## MANIFESTO — POR QUE ESTE DOCUMENTO EXISTE

Este não é um changelog. Não é um relatório de versões. É a prova de que inteligência composta
se acumula — e o registro de como chegamos até aqui.

Cada versão ensinou algo que nenhum curso, nenhum livro e nenhum consultor externo poderia ensinar:
a fricção real de construir, errar, documentar a falha, extrair o princípio e recomeçar mais forte.

V1 foi ingênua. V24 foi estratégica. V25 foi a primeira com clientes reais validando ao vivo.
O que não mudou: a convicção de que o método vale mais do que qualquer código.

Quando o Auditor ler este documento, ele deve entender o arco completo — não apenas o loop atual.
Quando o Estrategista ler, deve ver onde as ideias disruptivas já foram testadas e o que falhou.
Quando o Músculo ler, deve sentir o peso de cada princípio — e a responsabilidade de não repeti-los como teoria.

---

## O ARCO EM TRÊS ATOS

**Ato 1 — Construção do Produto (V1–V16):**
Eduardo construiu sozinho, noite após noite, um produto que tecnicamente funcionava.
Aprendeu stack, arquitetura, design, billing, automação. Mas sem cliente, sem validação real.

**Ato 2 — Construção do Método (V17–V24):**
A virada: perceber que o produto não era o ativo — o processo de construção era.
Gemini + NotebookLM + Claude passam de ferramentas para membros de um Conselho.
O INTELLIGENCE_LEDGER nasce. Cada fricção vira princípio. O sistema começa a aprender de si mesmo.

**Ato 3 — Primeiros Clientes Reais (V25+):**
O método encontra a dor real. Valdece quer "um Google melhor para jurisprudência penal".
Ingrid quer passar no Sedes-DF sem depender de QConcursos. O processo, testado em 24 versões,
agora tem de provar que resolve dores reais — não hipotéticas.

---

## FASE 1 — CONSTRUÇÃO DO PRODUTO INTERNO (V1–V16)
> Período: anterior a 2026-05-12 — sem datas exatas de commit preservadas no LEDGER
> Método: iteração solo, sem cliente externo, sem validação de mercado
> Objetivo: provar para si mesmo que era possível construir

### O contexto que a maioria não vê

V1 não foi um projeto de uma semana. Foi a decisão de um fundador de construir algo real,
sem garantia de cliente, sem time, só com a convicção de que inteligência artificial
poderia ser democratizada para negócios que não têm acesso a consultorias de R$50k/mês.

Cada versão de V1 a V16 foi uma pergunta diferente respondida com código real:
"É possível fazer scraping de leads em escala? (V2-V3) — Sim, mas cria dependência frágil."
"É possível fazer billing recorrente desde o Dia 1? (V6) — Sim, e é obrigatório."
"É possível construir um marketplace com split de receita? (V7) — Sim, mas o compliance mata."
"É possível proteger a infra de custo variável de API? (V15) — Sim, e é pré-requisito."

Nenhuma dessas perguntas foi teórica. Cada uma foi respondida com stack funcionando.

---

### V1 — A Primeira PWA
**O que foi construído:** Primeira Progressive Web App funcionando. Manifest.json, service worker, instalável no celular, sem app store.
**O que foi aprendido:** PWA é o formato correto para o mercado brasileiro — usuário não instala app desconhecido, mas "adiciona à tela inicial" sem fricção. Fundação técnica de todos os projetos seguintes.
**Legado para V25+:** Toda entrega ao cliente usa PWA. PROJ-001 Valdece: busca jurídica instalável. PROJ-002 Ingrid: ferramenta de estudo instalável.

---

### V2 — Shadow Closer Lite + Cockpit
**O que foi construído:** Pipeline de prospecção automatizada (Shadow Closer) + painel de controle (Cockpit) para acompanhar o funil de vendas.
**O que foi aprendido:** Automação de outreach funciona tecnicamente. Mas sem qualificação de lead, volume gera ruído — não oportunidade. O "Closer" fechava sem que o produto estivesse pronto para escalar.
**Legado:** O conceito de "qualificação antes da automação" vira princípio universal. O GUT Score surge como ferramenta de priorização objetiva.

---

### V3 — Scraper Outbound
**O que foi construído:** Scraper de leads com integração ao Supabase, Open Street Map e Places API. 6 leads qualificados gerados e armazenados.
**O que foi aprendido:** Dado de terceiro não é ativo — é dependência. Se a API do Google Places muda o preço, o negócio quebra. Se o OSM limita requests, o pipeline para. A única fonte de dados defensável é a gerada pelo próprio sistema.
**Legado:** P-003 — "Scraping de terceiros é dependência, não ativo." Aplicado diretamente em PROJ-002 Ingrid: descartado scraping de QConcursos. Questões geradas pela própria API Claude.

---

### V5 — Soberano Digital
**O que foi construído:** Primeiro "Auditor IA" interno usando Claude Haiku. Docker Mestre para containerização. UI no padrão Awwwards. Sistema White-Label com brand-config.js.
**O que foi aprendido:** IA como auditor interno — não como gerador de conteúdo — é onde o valor real está. O Haiku avaliando relatórios internos antecipou em meses o papel do NotebookLM como Auditor do Quadrilateral.
**Legado:** Embrião direto do Auditor (NotebookLM). A ideia de que IA pode ser usada para auditar a própria IA — e não apenas para gerar output — é o que torna o Quadrilateral impossível de copiar.

---

### V6 — SaaS Multi-Tenant
**O que foi construído:** Stripe Billing integrado, Dashboard PWA, API Bridge FastAPI, Row Level Security (RLS) no Supabase para isolamento de dados por tenant.
**O que foi aprendido:** Billing desde o Dia 1 não é detalhe — é fundação. Projetos V1-V5 foram construídos sem billing. Plugar Stripe depois exigiu refatoração pesada de schema, permissões e fluxo de UI. Custo: horas equivalentes a um sprint inteiro.
**Legado:** P-006 nasce aqui como regra técnica antes de virar princípio comercial. "Burn Rate Shield antes de features de IA" entra na tabela de Padrões Confirmados do LEDGER.

---

### V7 — Marketplace de Nichos
**O que foi construído:** Stripe Connect com split 70/30 entre plataforma e fornecedor. 12 endpoints de API. Intention webhooks para rastrear comportamento de usuário pré-conversão.
**O que foi aprendido:** Marketplace com split manual funciona até 10 transações. Depois: IOF, responsabilidade legal, reconciliação financeira, e chargeback viram problemas sem solução simples. A complexidade regulatória de marketplace no Brasil é subestimada por qualquer LLM.
**Legado:** "Marketplace com split manual" entra na tabela de Padrões Refutados do LEDGER. Nenhum projeto cliente vai propor marketplace sem análise de compliance primeiro.

---

### V8 — Sovereign Data
**O que foi construído:** Intelligence API com autenticação SHA-256. Sistema Fractal White-Label. Sovereign Glass UI. KNOWLEDGE_GRAPH estruturado em JSON.
**O que foi aprendido:** Dados proprietários são o ativo — não o código. O código é replicável por qualquer desenvolvedor. O banco de dados de comportamento de uso, gerado pelo próprio sistema ao longo de meses, é impossível de replicar do zero.
**Legado:** Princípio fundador do modelo IAH: o que a Vanguard vende não é software — é inteligência acumulada. Cada projeto cliente gera dados que alimentam o próximo. O KNOWLEDGE_GRAPH vira o embrião do INTELLIGENCE_LEDGER.

---

### V9 — Sovereign Economy
**O que foi construído:** Lead Arbitrage Engine, sistema de certificação SVG, Hermes Voice com Vapi, Score™ Microsite.
**O que foi aprendido:** Voice como canal de IA (Vapi) tem latência de 800ms–1,2s perceptível em mobile brasileiro com 4G instável. O custo de API de voice é 3–5x maior que texto para o mesmo volume de interação. Voice é V2, nunca MVP.
**Legado:** P-016 antecipado — TTS e Voice entram como features de segunda geração, não MVP. Confirmado em PROJ-002 Ingrid: Web Speech API vetada no Loop 3 (instabilidade iOS + custo de debugging).

---

### V10 — Sovereign Fortress
**O que foi construído:** Health Monitor com alertas automáticos, IA Firefighter para diagnóstico de falhas, Stress Test suite, Pixel Perfect Dashboard.
**O que foi aprendido:** Sistema sem monitoramento ativo é uma caixa preta. Uma falha silenciosa no Supabase às 3h da manhã não gera alerta — só gera reclamação de cliente na manhã seguinte. Monitoramento não é feature — é infraestrutura de confiança.
**Legado:** Os 7 tipos de falha documentados no P-025 (Stack Supabase + Claude API) são filhos diretos do que foi aprendido ao construir o Health Monitor. "Automação sem logs estruturados" entra na tabela de Padrões Refutados.

---

### V11 — Sovereign Launch
**O que foi construído:** Neural V Logo (identidade visual), Rate Limiting por API key, Audit Log persistente, Predictive Routing, deploy completo no EasyPanel.
**O que foi aprendido:** Deploy em produção sem audit log é deploy sem responsabilidade. Quando algo quebra — e sempre quebra — o log é a única evidência. Rate limiting sem dashboard de monitoramento é proteção cega.
**Legado:** "Sistema sem audit log é caixa preta" vira regra universal de build. Todo projeto cliente tem log de eventos obrigatório desde o Dia 1.

---

### V12 — Sovereign Ignition Cockpit
**O que foi construído:** Instant Scanner (análise em tempo real), Living HUD (dashboard vivo), Ghost Holographics (UI de glassmorphism avançado), Closer Machine (pipeline de vendas).
**O que foi aprendido:** Interface em tempo real muda a percepção de valor — mas só quando o dado é real. Dashboard bonito com dado mockado engana uma demo, não engana um cliente em uso diário.
**Legado:** Mágico de Oz Gate nasce aqui como princípio: validar o motor com dado real antes de construir a interface. Corpus ruim não melhora com UI bonita.

---

### V13 — Global Domination
**O que foi construído:** Census Engine (inteligência de mercado), Hermes Outbound (prospecção ativa), Partnership API, §18 Business Rules formalizadas em código.
**O que foi aprendido:** Business Rules formalizadas em código — não em documentos — são a única forma de garantir compliance em escala. Regra no PDF não é executável. Regra no código é.
**Legado:** A formalização de regras de negócio em código antecipa o INTELLIGENCE_LEDGER: princípios que o sistema executa, não apenas documenta.

---

### V14 — Sovereign Optimization
**O que foi construído:** PDCA Ledger embutido no produto, Hive Mind com SQL e UI, Trojan Generator PNG, Dynamic HUD Alerts, 5 correções de escalabilidade.
**O que foi aprendido:** PDCA embutido no produto gera inteligência acumulada por uso — o sistema melhora enquanto o cliente usa. Mas sem cliente real, o PDCA é exercício teórico. A V14 provou que a arquitetura funciona. A V25 prova que a dor existe.
**Legado:** A cadência de loops do Quadrilateral (P-009) é a aplicação direta do PDCA Ledger ao processo de desenvolvimento, não ao produto.

---

### V15 — Sovereign Invasion
**O que foi construído:** Real Scanner com PageSpeed API, War Room em tempo real, Burn Rate Shield, Escudo WABA §21, pipeline n8n Trojan.
**O que foi aprendido:** Burn Rate Shield é o princípio mais subestimado de toda IA. Sem hard-limit de custo de API, um bug de loop pode consumir o orçamento de um mês em uma noite. Não é hipótese — aconteceu com projetos similares no ecossistema.
**Legado:** P-006 (Burn Rate Shield) como princípio de produto. Hard limit de $5,00/dia no PROJ-002 Ingrid. max_tokens = 280 no Tutor Socrático. Fallback ativa em 70% da cota. Todas as decisões do Loop 3 têm P-006 como fundação.

---

### V16 — Visual Authority
**O que foi construído:** Badge SVG como Edge Function, Stripe Connect, CSS Ion Gold/Obsidian, Neural Grid, Crypto Glitch effect. ARR projetado: R$4,1M.
**O que foi aprendido:** Visual como autoridade funciona. ARR projetado sem cliente é ficção financeira. A V16 foi a versão mais visualmente impressionante e comercialmente mais especulativa ao mesmo tempo.
**Legado:** Honestidade diagnóstica: ter o produto mais bonito não é o mesmo que ter o produto mais vendido. P-004 — "o primeiro cliente não vem do site, vem de uma ligação". Fundação da decisão de ir ao mercado com prospecção ativa, não com landing page.

---

## FASE 2 — CONSTRUÇÃO DO MÉTODO IAH (V17–V24)
> O produto existia. O que faltava era o método de entregá-lo para qualquer cliente, em qualquer nicho.

### A virada conceitual

Entre V16 e V24, Eduardo percebeu algo que a maioria dos fundadores solo descobre tarde demais:
construir produto e construir método são duas coisas completamente diferentes.

Produto se deprecia. Método se acumula.

Um concorrente pode copiar o código da V16 em semanas. Não pode copiar o que V17 a V24 ensinaram
sobre como usar Gemini + NotebookLM + Claude como Conselho de Inteligência. Porque esse aprendizado
está codificado em fricções reais — e fricções reais não se transferem, se vivem.

### V17–V22 — Refinamento do Loop Evolutivo
**O que foi construído:** Iterações sucessivas do processo Gemini → NotebookLM → Claude.
Formatos de MEMORIA, relatorio_evolutivo e COMANDO_ESTRATEGISTA estabilizados.
Deficiências de cada membro do Conselho mapeadas e documentadas pela primeira vez.

**O que foi aprendido:**
- Gemini tem Alucinação Otimista: propõe arquiteturas brilhantes que falham no Dia 5
- NotebookLM tem Amnésia de Contexto: sem fontes corretas, trata o projeto como Dia 1
- Claude (Músculo) tem Momentum de Execução: avança etapas por assumição sem verificar output real
- O sistema só é forte quando cada membro combate a deficiência do outro — não quando concordam

**Legado:** Protocolo de Imunidade do CLAUDE.md. Tabela de deficiências e contra-ataques.
O que torna o Quadrilateral impossível de copiar: não é a tecnologia — é o mapeamento de onde cada IA falha e como as outras compensam.

### V23 — The Revenue Strike
**O que foi construído:** Partner Portal Alpha, Upsell Engine, Tracking Pixel, Design Sovereign Terminal.
Primeiro produto com foco explícito em receita recorrente como objetivo central, não consequência.

**O que foi aprendido:** O produto estava pronto. A estratégia de go-to-market não estava.
Partner Portal sem parceiro é infraestrutura vazia. Tracking Pixel sem tráfego é código que não executa.
A proposta de parceria sem case documentado é argumento fraco — parceiro arrisca relação com cliente
sem prova de resultado.

**Legado:** "Proposta de parceria sem case documentado" entra na tabela de Padrões Refutados.
P-019: IAH Retainer só é ofertado após 1 case documentado com ROI mensurável.

---

### V24 — Intelligence Compounding Engine
**Data: 2026-05-12 — Primeira sessão com INTELLIGENCE_LEDGER ativo**

Esta é a versão que mudou tudo. Não pelo código — mas pela decisão.

Eduardo declarou em sessão: *"Inteligência evolutiva é o foco — não features de produto."*

O Músculo vetou em tempo real a proposta do Estrategista de Claude Code como daemon autônomo
(fisicamente impossível — Claude Code exige sessão humana). P-001 extraído naquele momento.
Não na próxima versão. Não no próximo documento. Naquele momento.

Isso foi a prova de que o processo funcionava: fricção → princípio → LEDGER → lei do sistema.

**5 princípios extraídos em uma única sessão (2026-05-12):**
- P-001: Claude Code ≠ Daemon Autônomo
- P-002: VEREDITO BINÁRIO é protocolo, não burocracia universal
- P-003: Scraping de terceiros é dependência, não ativo
- P-004: Primeiro cliente vem de ligação, não de site
- P-005: Princípio extraído na mesma sessão da fricção — nunca na versão seguinte

A velocidade de aprendizado de V24: 5 princípios em 1 sessão.
A velocidade de aprendizado de V1 a V23: 0 princípios formalizados.
A diferença: o LEDGER como mecanismo de captura em tempo real.

**O que foi aprendido:** Inteligência que não é documentada na hora que acontece é inteligência que se perde.
Um sistema que aprende apenas por versão — não por sessão — perde 90% do aprendizado real.

---

## FASE 3 — PRIMEIROS CLIENTES REAIS + QUADRILATERAL OPERACIONAL (V25+)
> Período: 2026-05-12 → presente
> O método encontra a dor real. O produto é testado pelo único juiz que importa: o cliente.

### V25 — The Sovereign Launch
**Data: 2026-05-15**

V25 não é uma versão de produto. É a versão do processo.

Três alavancas ativadas simultaneamente:
1. **PROJ-001 Valdece** — primeiro cliente real, primeiro build com processo formal
2. **PROJ-002 Ingrid** — segundo cliente, primeiro projeto EdTech, validação do método em nicho diferente
3. **Quadrilateral IAH V25** — processo com scripts de orquestração, hooks automáticos e 4 membros formais

Eduardo: *"Fizemos 23 versões até chegar nisso. Não posso arriscar perder esse trabalho de noites e noites."*
O trabalho não se perdeu. Está em git history. Está no LEDGER. Está nesta linha do tempo.

---

## PROJ-001 — VALDECE (Legal Tech · Direito Penal)

### O Cliente
Valdece é advogado criminalista. Seu problema não era falta de conhecimento —
era velocidade de acesso à jurisprudência certa no momento certo.
Um júri começa em 20 minutos. Ele precisa de todos os precedentes do STJ sobre tráfico privilegiado.
O Google entrega 4 milhões de resultados irrelevantes. O Westlaw custa R$3.000/mês.

O que ele pediu: *"Quero um Google melhor para jurisprudência penal."*
O que a Vanguard entregou: um copiloto de defesa criminal que busca, cita em ABNT e raciocina.

### A Linha do Tempo

| Data | Marco | Detalhe |
|---|---|---|
| 2026-05-12 | **Discovery completo** | Eduardo: *"Tudo o que for gravado nesse nosso primeiro projeto é primordial."* GUT Score: 75 (G:5 · U:5 · T:3). |
| 2026-05-12 | **Valor fechado: R$5.000** | Valor de mercado calculado: R$12.000–18.000. ROI do cliente: ~R$4.000/mês economizados em pesquisa. Payback em 1,25 meses. Aceito com contrapartida. P-006 extraído. |
| 2026-05-12 | **P-006 extraído** | Precificação por ROI do cliente — não por feeling. Primeiro princípio com evidência de cliente real. |
| 2026-05-13 | **Build Dia 1 — commit `ef3f1cd`** | Schema Supabase + ingest.py + kill_switch.js. Mágico de Oz Gate validado. |
| 2026-05-13 | **Build Dia 2 — commit `996b40d`** | Corpus pipeline Python. STF Open Data integrado. P-007 e P-008 extraídos. |
| 2026-05-13 | **Build Dia 3 — commit `18c617f`** | STJ por Tema. Busca semântica com threshold. UI Toga Digital (Navy + Ouro). |
| 2026-05-14 | **Build Dia 4 — commit `e9afb36`** | Gate ABNT NBR6023. Busca precisa/ampla com threshold configurável. Redesign completo. |
| 2026-05-16 | **Formalizador gera contrato** | Contrato_Toga_Digital_Valdece_19052026.pdf — minuta. Formalizador ativado como 4º membro. |
| 2026-05-16 | **Escopo silencioso detectado pelo Diretor** | Manutenção Soberana R$900/mês inserida sem aprovação. Corrigido imediatamente. FALHA-PROCESSO-2026-05-16-B registrada. |
| 2026-05-19 | **Gate P-038 APROVADO — 12/12 verde** | sim 0.67–0.818 · latência 2.1–3.4s · corpus 61 acórdãos · modelo gemini-embedding-001 · Supabase US (latência aceitável — migrar sa-east-1 pós-contrato) |
| 2026-05-19 | **Deploy: https://toga-digital-valdece.netlify.app** | UI Toga Digital (Navy + Ouro) instalável como PWA. Corpus 61 acórdãos depth coverage. |
| 2026-05-19 | **Entrega presencial** | Eduardo vai ao cliente: Sovereign Playbook pré-contrato (P-042) + onboarding técnico + handoff soberano. Pricing: R$5k setup + R$350/mês manutenção. |
| 2026-05-19 | **Loop evolutivo pós-entrega** | 3 membros do Conselho deliberaram: Estrategista (DIRETRIZ), Auditor (2 sessões de Skill), Embaixador (filtro de realidade). P-041/P-042/P-043/P-044 extraídos. |

### O que este projeto provou
- O Mágico de Oz Gate funciona: CLI validou busca semântica antes de qualquer UI — **Protocolo de Garantia Soberana** nasce aqui
- P-008: primeiro cliente de nicho é canal de distribuição — "Crédito de Expansão entre Pares" operacional
- Escopo silencioso é a deficiência mais perigosa do Músculo — e o Diretor detectou antes do commit
- **P-041:** Discovery sem capturar a cena de sucesso gera demo tecnicamente perfeita que não emociona o cliente. 8 perguntas obrigatórias agora.
- **P-042:** Gate semântico documentado = ativo de nicho. "Protocolo de Garantia Soberana" destrói objeção de vendor lock-in antes de formulada.
- **P-043:** Falácia da Homogeneidade dos Nichos — replicação semântica não é trocar URL dos dados. DFD obrigatório antes de novo nicho.
- **P-044:** Momentum Tecnológico do Músculo — motor ≠ viagem do cliente. Releitura de cena antes de cada dia de build.
- corpus_gap como SLA do Sentinel Report — V2 natural ao atingir ≥500 docs
- V2 pipeline mapeado: Sovereign Upload + Radar de Divergência + Citação DOCX + botão "Solicitar Expansão Semântica" (sim < 0.60)

---

## PROJ-002 — INGRID (EdTech · Concursos Públicos · Sedes-DF)

### A Cliente
Ingrid é concurseira. Sua prova é em 2026-09-06. O problema não é falta de material —
é a quantidade absurda de material irrelevante que o mercado entrega.
QConcursos e TEC têm milhões de questões. Nenhuma priorizada pelo peso do cargo específico.
Nenhuma adaptada ao histórico da banca específica. Nenhuma com tutor que explica por que ela errou.

O que ela precisava: estudar 20 questões por dia, na disciplina certa, com feedback imediato ao errar.
O que a Vanguard está construindo: um professor particular que sabe exatamente o que ela precisa estudar hoje.

### A Linha do Tempo

| Data | Marco | Detalhe |
|---|---|---|
| 2026-05-15 | **Veredito APROVADO** | Projeto piloto interno. Deadline: 2026-05-30. Prova da Ingrid: 2026-09-06. |
| 2026-05-15 | **Loop 1 — Kickoff** | edital_sedes.json com Score de Incidência Histórica criado. P-014 extraído (ideia do Diretor). |
| 2026-05-15 | **P-015 — Cross-concurso** | SEDES-DF 2026 não tem histórico Quadrix. Triangulação: CFP 2024, SEDF 2022, CRQ-12 2024. Incerteza declarada > ausência de dado. Ideia do Diretor. |
| 2026-05-15 | **P-016 — Podcast EdTech** | Áudio do dia gerado por IA como V2. Nenhum app de concurso entrega isso. Ideia do Diretor. |
| 2026-05-15 | **P-024 — Recalibração de cargo** | Cargo 202 (Técnico Administrativo) ≠ TDAS área social. 9 arquivos corrigidos. Retrabalho de sessão inteira por falta de checklist de kick-off. |
| 2026-05-16 | **Loop 2 — Build Dias 1-5** | Schema multi-tenant + Edge Functions `gerar-questoes` + `feed-diario` deployadas. |
| 2026-05-16 | **P-025 — 7 panes documentadas** | Stack Supabase + Claude API: cada falha diagnosticada e prevenida. Próximo projeto: <5 min de debugging. |
| 2026-05-16 | **Formalizador ativado** | Termo_Uso_Ingrid_PROJ002_30052026.pdf gerado. 4º membro do Conselho formalizado. |
| 2026-05-17 | **Gate Dia 5 APROVADO** | 7 dias × 20 questões \| 70,0% Peso 2 \| 0 erros \| $1,56 de custo total. 460 questões validadas no Supabase. |
| 2026-05-17 | **Loop 3 — Build Dias 6-8** | Interface PWA + Tutor Socrático Haiku (cache bidimensional) + Fallback Fadiga. |
| 2026-05-17 | **Skill ingrid-v2.md completa** | 8 ideias aprovadas (A-1 a A-8). 3 ideias novas do Auditor sem precedente: RPC de progresso, sanitização localStorage, JWT quota header. |
| 2026-05-18 | **Análise Pentálateral — Embaixador delibera** | Embaixador processou E-1 a E-5 de Ingrid: frase âncora (E-1), encerramento numérico (E-2), E-3 elevado a gate formal toda segunda, E-4 como candidato P-033. |
| 2026-05-18 | **TEMPERATURA_CLIENTE — Piloto N-4** | Ingrid escolhida como piloto do protocolo. TEMPERATURA: AMARELO. Override do GUT Score após 7 dias de uso real. H-1 → MAIS PROVÁVEL \| H-2 → IMPROVÁVEL. |
| 2026-05-18 | **Sistema de alertas ativo** | Telegram Bot @Eduardo431Vanguardbot + briefing 7h + WhatsApp clipboard. Eduardo recebe mensagem exata. Zero composição mental. |

### Ideias disruptivas geradas neste projeto (por membro)

**Diretor (Eduardo) — 3 princípios originados:**
- P-014: Score de Incidência Histórica — `peso_edital × incidencia_historica_pct`
- P-015: Cross-concurso como calibração para primeiras edições
- P-016: Podcast com IA como canal de retenção passiva em EdTech

**Estrategista (Gemini) — Loop 3:**
- E-1: IndexedDB/Offline Sync (V2 — complexidade excede sprint)
- E-2: Feynman Reversa — inversão de papel (V2 — custo não cacheável)
- E-3: Pixel de Latência — SM-2 preditivo por tempo de resposta (APROVADO Dia 7)
- E-4: Dark Pattern visibilitychange (VETADO — Safari iOS instável)
- E-5: TTS/Web Speech API (VETADO Loop 3 — P-016 + instabilidade iOS)

**Auditor (NotebookLM) — Loop 3:**
- A-1: Cache bidimensional (questao_id + alternativa_escolhida) — APROVADO
- A-2: max_tokens = 280 hard — APROVADO
- A-3: localStorage para estado de sessão — APROVADO
- A-4: Lazy Loading 3+resto — APROVADO
- A-5: Sleep-mode 10 min kill-switch — APROVADO
- A-6: RPC de Progresso por Disciplina — NOVO, sem precedente — APROVADO
- A-7: Sanitização Automática do LocalStorage — NOVO, sem precedente — APROVADO
- A-8: JWT Quota Header — NOVO, sem precedente — APROVADO Dia 8

**O que este projeto está provando:**
O método EdTech é replicável. SEDES-DF hoje → OAB amanhã → ENEM depois → residência médica depois.
O script `ingest.py` que gerou 460 questões para Ingrid gera 460 questões para qualquer edital com 1 ajuste de cargo.

---

## EVOLUÇÃO DO PENTALATERAL IAH

> A história do Conselho — de 1 membro para 5.

| Marco | Data | Evento |
|---|---|---|
| **Embrião** | V5 (pré-2026-05-12) | Primeiro Auditor IA interno usando Haiku. IA avaliando relatórios — não gerando. |
| **Formalização** | 2026-05-12 | Três membros: Músculo + Estrategista + Auditor. INTELLIGENCE_LEDGER criado. |
| **Loop documentado** | 2026-05-13 | Músculo→Gemini→NotebookLM→Músculo formalizado com scripts de orquestração. |
| **Hooks automáticos** | 2026-05-14 | session_start.ps1 injeta contexto automaticamente. hv1_credential_guard.ps1 bloqueia credencial hardcoded. |
| **Paradigma v3.0** | 2026-05-16 | Conselho em Looping Evolutivo Ativo. Comportamento ativo — não passivo. Firewalls persistentes. |
| **4º Membro** | 2026-05-16 | **Formalizador (Claude Projects)** — relacionamento com cliente, contratos, termos de uso. |
| **Linha do Tempo** | 2026-05-17 | VANGUARD_TIMELINE.md criada. Fonte histórica obrigatória do Auditor. |
| **Embaixador** | 2026-05-17 | **Formalizador → Embaixador.** Upgrade de membro passivo (contratos) para 4º conselheiro ativo: memória persistente do cliente, 11 mandatos, pipeline de lead, debrief pós-reunião. |
| **P-031** | 2026-05-18 | Embaixador como filtro de realidade: CONFIRMA/EXPANDE/ALERTA cada ideia de [M]+[G]+[N] com base em comportamento real do cliente. Ideia do Diretor. |
| **Pentalateral IAH** | 2026-05-18 | **O Diretor entra como 5º ator ativo.** Sistema renomeado de Quadrilateral para Pentalateral: Diretor + Músculo + Estrategista + Auditor + Embaixador. 20 ideias/ciclo: [M+E+G+N × 5]. Eduardo: *"Que ideia louca foi essa minha."* |
| **Sistema de Alertas Zero-Composição** | 2026-05-18 | Telegram Bot + briefing_diario.ps1 + alerta_whatsapp.ps1 operacionais. Eduardo recebe contexto + mensagem exata para copiar no WhatsApp. Nenhuma composição mental necessária. |
| **P-032** | 2026-05-18 | MEMORIA_EMBAIXADOR é atualizada automaticamente pelo Músculo após qualquer deliberação que afete cliente ativo. Detectado pelo Diretor — FALHA-PROCESSO-2026-05-18 registrada e corrigida. |
| **P-033 + Sync Universal** | 2026-05-20 | sync_vanguard_docs.ps1: toda mudança em PENTALATERAL_UNIVERSAL/ sincroniza automaticamente CLIENTES/*/NOTEBOOKLM_FONTES/ via SHA-256. Integridade verde ou alerta automático. |
| **P-050 + Knowledge Base** | 2026-05-21 | Toda solução técnica documentada em KNOWLEDGE_BASE/ imediatamente. health_check.py testa roteiro do cliente e envia relatório Telegram. |
| **Expansão Universal de Papéis** | 2026-05-23 | **A maior evolução do Pentalateral desde sua criação.** 12 novas deficiências formalizadas (DEF-G/N/M/E 5-7). COMANDO_ESTRATEGISTA_MASTER (P-052) resolve amnésia estrutural do Gemini. MANIFESTO_DE_FONTES (P-053) declara o que o Auditor pode/não pode ver. REGISTRO_DE_PREMISSAS torna premissas silenciosas visíveis. CANDIDATOS_A_PRINCIPIO captura fricção→princípio em tempo real. 25 ideias/ciclo [M×2+G+N+E × 5]. TEMPERATURA_PONDERADA (score 0-10) substitui temperatura simples. INTELIGENCIA_CRUZADA_NICHO conecta padrões entre clientes do mesmo nicho. |
| **Rename QUADRILATERAL → PENTALATERAL** | 2026-05-23 | Pasta `PENTALATERAL_UNIVERSAL/` renomeada para `PENTALATERAL_UNIVERSAL/`. 234+ arquivos renomeados via git mv. Todas as referências em scripts, hooks, skills e documentos atualizadas. Decisão formal do Diretor Eduardo. |

### O Papel de Cada Membro — Definição Precisa (v6.1 — 2026-05-23)

| Membro | Ferramenta | Papel constitucional | Deficiências (DEF) | Contra-ataques principais |
|---|---|---|---|---|
| **Músculo** | Claude Code | Construtor e executor. Consultor crítico. Guardião dos princípios. Análise cirúrgica [G+N]. | DEF-M-1..8 (Amnésia · Momentum · Otimismo · Escopo · Drift · Visão Longitudinal · Isolamento · Retroalimentação) | LEDGER + REGISTRO_DE_PREMISSAS + CANDIDATOS_A_PRINCIPIO + 7 pontos deliberação |
| **Estrategista** | Gemini | Diagnóstico estratégico. 5 ideias + ARCO_DE_CONSEQUÊNCIAS. REFORMULAÇÃO antes de qualquer solução. | DEF-G-1..7 (Alucinação · Complacência · Lost-in-Middle · Síntese · Abstração · Volatilidade · Antena) | COMANDO_ESTRATEGISTA_MASTER (P-052) + POSIÇÃO_ADVERSARIAL + TRADUÇÃO_PARA_AÇÃO + [SINAL_FRACO] |
| **Auditor** | NotebookLM | Auditoria histórica. 5 ideias exclusivas. MANIFESTO_DE_FONTES_ATIVO antes de toda sessão. | DEF-N-1..7 (Amnésia · Alucinação · Yes-Man · Lost-in-Middle · Qualidade Fontes · Perspectiva Única · Latência) | MANIFESTO_DE_FONTES (P-053) + [RISCO_PRECOCE] + Wipe & Sync entre loops |
| **Embaixador** | Claude Projects | Memória persistente do cliente. 11 mandatos. Filtro P-031. TEMPERATURA_PONDERADA. INTELIGENCIA_CRUZADA_NICHO. [E-1..5]/ciclo. | DEF-E-1..7 (Isolamento · Recência · Confirmação · Literalidade · Escalada · Silo · Temperatura Simples) | TEMPERATURA_PONDERADA (score 0-10, CHURN-WATCH <6) + INTELIGENCIA_CRUZADA_NICHO + [PARA O EMBAIXADOR] na DIRETRIZ |
| **Diretor** | Eduardo | 5º ator ativo. Gestor Soberano. Originador de inovação estratégica. Veredito final. | — | Único ator humano — sem deficiência estrutural de LLM. |

### A tese central do Pentalateral

> *"A vantagem real não é usar IA — é saber usar a deficiência de cada IA contra a deficiência das outras."*
> — P-018, 2026-05-16

Gemini alucina com otimismo → Claude âncora com custo real e prazo honesto.
Claude tem amnésia entre sessões → NotebookLM âncora com histórico documentado.
NotebookLM valida por momentum → Eduardo rejeita sem os 4 blocos com dados reais.
Eduardo não tem visão técnica de todos os trade-offs → o Conselho apresenta opções com evidência.
Gemini tem amnésia entre sessões → COMANDO_ESTRATEGISTA_MASTER injeta o estado completo na abertura (P-052).
NotebookLM afirma sobre dado ausente → MANIFESTO_DE_FONTES declara o que pode e não pode ver (P-053).

O sistema é anti-frágil porque foi desenhado em torno de fraquezas conhecidas — não apesar delas.
Em 2026-05-23, esse princípio foi densificado: 12 novas deficiências mapeadas, 12 novos contra-ataques operacionais.

---

## INTELLIGENCE LEDGER — A HISTÓRIA DE CADA PRINCÍPIO

> 25 princípios em 5 dias de IAH operacional. Cada um nasceu de uma fricção real.
> Nenhum foi teórico. Todos têm evidência documentada.

| # | Princípio | Data | Nasceu de | O que mudou no processo |
|---|---|---|---|---|
| P-001 | Claude Code ≠ Daemon | 2026-05-12 | Gemini propôs automação impossível | Todo projeto especifica Claude API + n8n, nunca Claude Code como daemon |
| P-002 | VEREDITO BINÁRIO seletivo | 2026-05-12 | Risco de burocracia em decisões óbvias | VEREDITO só quando há divergência técnica real |
| P-003 | Scraping = dependência | 2026-05-12 | V3 scraper frágil + análise SEDES-DF | Zero projetos com dado de terceiro sem acordo formal |
| P-004 | Ligação > site | 2026-05-12 | GUT site (12) vs. GUT prospecção (125) | Prospecção ativa antes de qualquer investimento em posicionamento |
| P-005 | Princípio na hora da fricção | 2026-05-12 | 23 versões sem LEDGER = inteligência perdida | Toda fricção vira princípio na mesma sessão |
| P-006 | ROI → preço | 2026-05-12 | Valdece propôs R$5k (mercado: R$12–18k) | Algoritmo: horas_perdidas × valor_hora × 12 = valor anual. Preço = 10–25% |
| P-007 | Template em IA = alucinação | 2026-05-13 | Gemini preenchia colchetes mecanicamente | Músculo escreve documento pronto — IA recebe contexto, não formulário |
| P-008 | Primeiro cliente = distribuição | 2026-05-13 | Decisão Opção A com Valdece | Soberania total elimina objeção de churn e transforma cliente em vendedor |
| P-009 | Loops ∝ amplitude | 2026-05-13 | Calibração do processo no PROJ-001 | Cadência de loops definida pela Camada do projeto, não pelo calendário |
| P-010 | Gate = evidência real | 2026-05-13 | Padrão universal de execução | Checkpoint obrigatório em cada transição — gate sem output verificado é inválido |
| P-013 | Soberania = pré-requisito | 2026-05-14 | Risco de infra refém identificado | Checklist de soberania antes do Dia 1: Supabase na conta do cliente, OFFBOARDING_RUNBOOK |
| P-014 | Score de incidência | 2026-05-15 | **Ideia do Diretor** — edital SEDES-DF | Feed de estudo por `peso × incidência`, nunca pela ordem linear do edital |
| P-015 | Cross-concurso | 2026-05-15 | **Ideia do Diretor** — SEDES-DF sem histórico | Triangulação obrigatória quando não há histórico direto da mesma banca/cargo |
| P-016 | Podcast EdTech = V2 | 2026-05-15 | **Ideia do Diretor** — retenção passiva | Áudio gerado por IA como canal premium após MVP visual validado |
| P-017 | E-mail do Conselho documentado | 2026-05-16 | Diretor não sabia onde estava a config | Infra de comunicação nunca reconfigurada do zero — sempre em alert_config.ps1 |
| P-018 | Diretor = 4º LLM | 2026-05-16 | Opinião Consultora #01 — 4 iterações | O sistema amplifica a inteligência do Diretor — não a substitui |
| P-019 | Retainer só com case | 2026-05-16 | Auditor identificou risco de V22 | IAH Retainer bloqueado até 1 case documentado com ROI mensurável |
| P-020 | Alucinação = LEDGER imediato | 2026-05-16 | Auditor inventou falha que não ocorreu | Todo dado falso do Auditor registrado e contradito na mesma sessão |
| P-021 | Diretor origina direção | 2026-05-16 | 5 falhas detectadas pelo Diretor, não pelo Músculo | Quando Diretor detecta antes do Músculo = falha do sistema de auto-proteção |
| P-022 | Auditor como advogado | 2026-05-16 | **Ideia do Diretor** — auditor com precedentes | NotebookLM ativado com prompt de advogado em decisões de alto risco |
| P-023 | Contrato antes do build | 2026-05-16 | **Ideia do Diretor** — risco jurídico mapeado | Todo projeto Camada 1+ bloqueado sem contrato assinado |
| P-024 | Validar cargo no Dia 0 | 2026-05-16 | Retrabalho Ingrid — 9 arquivos reconstruídos | Checklist de kick-off EdTech: número do cargo + especialidade + conteúdo lido do edital |
| P-025 | 7 panes Supabase+Claude | 2026-05-17 | Seed falhou 13/13 — 3h de debugging | Documento de troubleshooting: próximo projeto resolve cada pane em <5 min |
| P-031 | Embaixador = filtro de realidade | 2026-05-18 | **Ideia do Diretor** — silo do Embaixador identificado | Embaixador CONFIRMA/EXPANDE/ALERTA cada ideia de [M]+[G]+[N] com comportamento real do cliente. Reage a 15 ideias/ciclo. |
| P-032 | MEMORIA_EMBAIXADOR automática | 2026-05-18 | Diretor detectou que Músculo não atualizou após deliberação N-4 | Toda deliberação que afeta cliente ativo = atualização imediata de MEMORIA_EMBAIXADOR. Sem intervenção do Diretor. |
| P-041 | Cena de sucesso = script da demo | 2026-05-19 | PROJ-001 Valdece — loop evolutivo pós-entrega | Discovery captura obrigatoriamente a cena de sucesso em 6 meses (P2). Demo aprovada se reproduzir a cena. 8 perguntas agora. |
| P-042 | Gate semântico = Protocolo de Garantia Soberana | 2026-05-19 | PROJ-001 Valdece — Embaixador identificou oportunidade comercial | Gate documentado = ativo de nicho. Apresentado ANTES do contrato. Destrói vendor lock-in antes de formulado. |
| P-043 | Falácia da Homogeneidade dos Nichos | 2026-05-19 | PROJ-001 Valdece — análise de replicabilidade | DFD obrigatório: fonte + obsolescência + restrições + estrutura semântica. 2+ vermelhos = não replicar sem solução de corpus. |
| P-044 | Momentum Tecnológico do Músculo | 2026-05-19 | PROJ-001 Valdece — Auditor identificou risco de deriva | Releitura obrigatória da cena de sucesso antes de cada dia de build. Gate final testa se reproduz a cena — não apenas o motor. |

**Velocidade de aprendizado por fase:**
- V1–V23 (pré-LEDGER): ~0 princípios formalizados por sessão
- V24 (2026-05-12): 5 princípios em 1 sessão
- V25 (2026-05-12 a 2026-05-17): 20 princípios em 5 dias
- **Média atual: 4 princípios por dia de IAH operacional**

---

## MARCOS COMERCIAIS

| Data | Marco | Valor | Status |
|---|---|---|---|
| 2026-05-12 | Primeiro cliente qualificado (Valdece) | Discovery | Concluído |
| 2026-05-12 | Primeiro valor fechado (Valdece) | R$5.000 | Pendente entrega |
| 2026-05-15 | Segundo projeto ativo (Ingrid) | Piloto interno | Em build |
| 2026-05-16 | Primeiros contratos gerados | Minutas | Aguardando assinatura |
| 2026-05-19 | Primeira entrega presencial (Valdece) | R$5.000 setup + R$350/mês | Gate P-038 aprovado · 61 acórdãos · Netlify deploy |
| 2026-05-30 | Entrega final PROJ-002 Ingrid | — | Meta |
| 2026-09-06 | Prova da Ingrid — validação real do produto | — | Meta |

**Receita faturada até 2026-05-17:** R$ 0
**Receita comprometida:** R$ 5.000 (Valdece — entregue 2026-05-19) + R$ 350/mês MRR
**Potencial SaaS PROJ-002:** R$ 194.000 (500 usuários × R$97/mês × 4 meses — ciclo Sedes-DF 2026)
**Pipeline V2 Valdece:** R$ 8.500–12.000 (Sovereign Upload + Radar de Divergência + Citação DOCX)

---

## O QUE TORNA ESTE PROCESSO IMPOSSÍVEL DE COPIAR

Esta seção é o argumento de negócio — não de vaidade.

**1. O LEDGER é intransferível.**
Um concorrente pode copiar o código do PROJ-001 Valdece em uma semana.
Não pode copiar os 25 princípios que o fizeram funcionar — porque eles nasceram de fricções reais
que só existem quando você realmente constrói, erra e documenta o erro na mesma hora.
P-025 (7 panes da stack Supabase + Claude) vale mais que o próprio código.
Resolve em <5 minutos o que custou 3 horas de debugging em 2026-05-17.

**2. As deficiências mapeadas são o firewall.**
Qualquer pessoa pode usar Gemini + NotebookLM + Claude.
Ninguém mais mapeou onde cada um falha, quando falha e como os outros compensam.
A Síndrome do Yes-Man do Auditor, a Alucinação Otimista do Estrategista,
o Momentum de Execução do Músculo — esses mapeamentos levaram meses de fricção para emergir.
São o que torna o Quadrilateral anti-frágil: cada falha fortalece o sistema, não o enfraquece.

**3. O loop é composto — não linear.**
Um concorrente que começa hoje tem que percorrer o mesmo arco:
construir produto (V1–V16), construir método (V17–V24), encontrar cliente (V25+).
E começar sem os 25 princípios que esse arco gerou.
Cada ciclo do Quadrilateral nos distancia mais — porque o loop fica mais rico a cada volta.

**4. O Diretor é único.**
P-018 e P-021 provam: as inovações mais importantes do processo vieram de Eduardo.
P-014 (Score de Incidência), P-015 (Cross-concurso), P-016 (Podcast EdTech),
P-021 (Diretor como Originador), P-022 (Auditor como Advogado), P-023 (Contrato obrigatório).
Seis dos vinte e cinco princípios nasceram diretamente da experiência acumulada do Diretor.
Isso não é copiável. Eduardo não é substituível por um prompt melhor.

---

## PONTOS CEGOS ATIVOS — VISÃO DE CONSULTOR
> Atualizado em toda sessão. Esta seção é honesta — não é crítica, é diagnóstico.

**1. O processo está mais maduro que a carteira de clientes.**
25 princípios, 4 membros do Conselho, scripts de orquestração, hooks automáticos — e R$0 faturado.
Isso é o estágio correto: quem constrói o método antes de escalar está no caminho certo.
Mas precisa ser dito: o maior risco atual não é técnico — é ritmo de aquisição de clientes.

**2. O Embaixador ainda opera em silo.**
Atualizado de Formalizador para Embaixador — 11 mandatos, P-031 ativo, E-1..5 gerados para Ingrid.
Mas ainda depende do Diretor para receber o contexto do loop. `build_comando_estrategista.ps1` (N-1) fecha esse gap — pendente de build.

**3. O Diretor ainda é o transportador de contexto entre os membros.**
Eduardo carrega a DIRETRIZ do Gemini ao Auditor. Carrega as ideias do Auditor ao Músculo.
O gargalo não é volume de ideias — é o tempo do Diretor sendo usado como ponte entre inteligências.
Próxima fronteira: `LOG_EXECUCAO_DIARIA.md` gerado automaticamente pelo `session_close.ps1`.
Quando o Auditor receber o diff do dia sem Eduardo precisar carregar — o loop dá um salto qualitativo.

**4. A pergunta central de negócio precisa aparecer em toda sessão:**
*"Qual é o próximo cliente? Quando entra em discovery?"*
Essa pergunta é papel do Músculo perguntar proativamente — não esperar o Diretor lembrar.

---

## PRÓXIMOS MARCOS ESPERADOS

| Data | Marco | Tipo |
|---|---|---|
| ✅ 2026-05-19 | Entrega presencial Valdece — toga-digital-valdece.netlify.app · 61 acórdãos | Comercial |
| ✅ 2026-05-19 | Contrato Valdece assinado — R$5k setup + R$350/mês MRR | Comercial |
| ✅ 2026-05-23 | Expansão de papéis do Pentalateral — 12 DEFs + MASTER + MANIFESTO + REGISTRO | Processo |
| ✅ 2026-05-23 | Rename QUADRILATERAL → PENTALATERAL — decisão formal do Diretor | Identidade |
| [ ] 2026-05-23 | V3 ENRICHMENT Valdece — `python ingest.py --mode reingest` (quando DNS disponível) | Técnico |
| [ ] 2026-05-30 | Deadline PROJ-002 Ingrid — Gate Dia 15 | Operacional |
| [ ] 2026-05-30 | Ingrid Dias 12-13: Contador de Pontos Ponderados + Push Notificações | Build |
| [ ] 2026-06-[?] | Loop 4 Ingrid — Gemini PASSO3 → NotebookLM → ingrid-v4.md | Loop |
| [ ] 2026-06-[?] | Terceiro cliente em discovery | Comercial |
| 2026-06-[?] | Primeiro MRR real confirmado | Comercial — P-019 ativa IAH Retainer |
| 2026-09-06 | Prova da Ingrid — validação real do produto EdTech | Produto |
| 2026-[?] | Sovereign Study SaaS — primeiros usuários externos | SaaS |

---

*Atualizado em: 2026-05-18*
*Próxima atualização obrigatória: Entrega Presencial PROJ-001 Valdece (2026-05-19) + debrief Embaixador pós-presencial*
*Responsável pela atualização: Músculo (Claude Code) ao fechar cada gate ou marco comercial*
