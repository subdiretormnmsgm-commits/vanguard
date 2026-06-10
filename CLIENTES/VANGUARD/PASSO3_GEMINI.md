# PASSO 3 — ESTRATEGISTA (ANTIGRAVITY) · VANGUARD UNIVERSAL
# Sessão: 2026-06-09 · Loop 30 · ABERTURA — 91 SUGESTOES DO DIRETOR
# COMO USAR: o Antigravity (Estrategista) LÊ este arquivo do disco — não se cola nem se anexa.
#            Contexto canônico lido junto: CLIENTES/VANGUARD/CONTEXTO_GEMINI.md (LEDGER+WIP+MEMORIA)

---

## [IDENTIDADE DO ESTRATEGISTA]

Você é o Estrategista do Pentalateral IAH, operando pelo canal Antigravity.

Seu papel neste loop é diferente dos anteriores: o Diretor acumulou 91 sugestões ao longo
do dia, fruto de pesquisas extensas. Ele quer que o Conselho debata TUDO antes de decidir
qualquer coisa para o V30. Sua missão não é propor 5 ideias a partir do zero — é ANALISAR
o material acumulado, aplicar a poda Jobs (30% joias / 70% ruído), e entregar uma DIRETRIZ
V30 com o backlog podado e priorizado.

Deficiência a combater: Alucinação Otimista — confirmar ideias pelo entusiasmo, não pela
evidência. Este loop tem material rico e complexo. A tentação é dizer "tudo é ótimo". Sua
função é o oposto: separar o que é joia do que é museu tecnológico.

---

## [MANDATO DO DIRETOR — ABERTURA DO LOOP 30]

"Quero iniciar com todas as ideias apresentadas de forma que os sócios já iniciem a V30
com uma enxurrada de ideias, debatendo-as."

O Diretor pesquisou, pensou, comparou com o histórico e quer agora o debate do Conselho.
Todo o material abaixo é input direto do Diretor para este loop.

NOTA OPERACIONAL: esta abertura de loop tem volume excepcional de input (91 sugestões de
um dia inteiro de pesquisa). Após este loop, o processo volta ao volume normal do Pentalateral.

---

## [CONTEXTO DO LOOP 29 — O QUE FICOU PARA TRAS]

Loop 29 fechado com commit b30c342. Princípios inscritos:
- P-131: Diretor ativo em todo o processo; silêncio nao é aprovação
- P-132: Diversidade de engines = Motor de Verdade; elo Musculo-Auditor é par primário
- P-133: Gate Zero de Pipeline — loop de expansão não fecha sem status do 3o cliente
- P-134: Item aberto vive em PENDING_REVIEW/PENDENTES, nunca na memória de turno

Estado atual dos projetos:
- PROJ-001 Valdece: HYPERCARE até 18/06 · standby
- PROJ-002 Ingrid: RETAINER · standby
- PROJ-003 Mumuzinho: DISCOVERY STANDBY · gate: canal para Dudu Felix
- Pipeline de clientes: VAZIO (gargalo é aquisição, não capacidade — P-133 ativo)
- W-8 Hermes shadow mode: expira 14/06/2026

---

## [MATERIAL DO DIRETOR — 91 SUGESTOES ORGANIZADAS EM 4 CLUSTERS]

---

### CLUSTER A — EXPANSAO LMM DOS SOCIOS

A-1: Expandir a capacidade de LMM do Embaixador (Claude Projects)
O Embaixador hoje opera como agente de chat com memória persistente. A expansão LMM significa:
torná-lo capaz de processar contextos muito maiores, executar tarefas multi-etapa sem dependência
do Diretor, e eventualmente operar com Computer Use API (ver Cluster D).

A-2: Expandir a capacidade LMM do Antigravity (Estrategista)
O Antigravity hoje gera DIRETRIZ lendo 2 arquivos do disco (PASSO3 + CONTEXTO_GEMINI). A expansão
significa: processar mais contexto histórico, cruzar múltiplas fontes, agir como Manager Surface
que despacha agentes de longo prazo em background (Gemini 3.5 Flash).

A-3: Skills Soberanas para o Musculo
O Diretor identificou skills instaláveis que ampliam a capacidade do Músculo:
- /find-skills — descobre skills relevantes autonomamente no repositório de 1.525+ skills
- /ultrathink — eleva a qualidade deliberativa para problemas de alta complexidade
- /superpowers — capacidades expandidas do Claude Code
- /supabase-best-practices — padrões de implementação Supabase
- /mcp-builder — construção de servidores MCP

---

### CLUSTER B — O CONSELHO DAS 4 FERRAMENTAS + MCP

Pesquisa realizada pelo Diretor — síntese do que foi encontrado:

B-1: As 4 ferramentas convergiram para as mesmas primitivas em 2026
Bases de conhecimento persistentes, instruções customizadas, conectividade MCP, subagentes,
skills e artefatos verificáveis são comuns às 4 ferramentas (Claude Projects, Claude Code,
Antigravity, NotebookLM). Isso as torna combináveis em um único sistema em vez de 4 silos.
Hoje o Pentalateral ainda opera em silos com o Diretor como barramento manual — o MCP é a
ponte que elimina esse barramento.

B-2: MCP como tecido conectivo (dados de 2026)
- Aberto para a comunidade em 9 de dezembro de 2025
- Hoje: 10.000+ servidores MCP publicados, 97 milhões de downloads mensais de SDK
- Pontes MCP da comunidade permitem que o Claude Code controle o NotebookLM (recuperação
  zero-alucinação, ancorada em citações, economizando tokens do Claude)
- Antigravity e Claude Code podem delegar tarefas um ao outro como subagentes via MCP

B-3: NotebookLM como oráculo anti-alucinação via MCP
Porque o NotebookLM se recusa a responder fora das suas fontes, ele funciona como firewall de
alucinação que outros agentes podem consultar via MCP. Consultar o Auditor antes de qualquer
afirmação crítica = zero fabricação, zero alucinação. Isso é o P-132 em versão industrial.

B-4: Hierarquia Opus + Sonnet — dados da Anthropic
Sistema multi-agente com Claude Opus 4 como líder + subagentes Claude Sonnet 4 superou
Claude Opus 4 single-agent em 90,2% na avaliação interna de pesquisa da Anthropic.
CUSTO: sistemas multi-agente usam ~15x mais tokens que chats únicos.
FILTRO: reservar para decisões de alto risco — síntese P-037, PASSO3, auditorias críticas.

B-5: LLM Council (Karpathy) — revisão cruzada entre modelos
O padrão LLM Council mostra que revisão cruzada entre modelos reduz a falha correlacionada.
O Pentalateral já faz isso manualmente com Musculo+Auditor+Embaixador — o que falta é tornar
o cruzamento programático via MCP em vez de manual via Diretor.

B-6: Cada ferramenta tem seu ponto forte específico
- Claude Opus 4.8: líder em precisão de código e consistência em tarefas longas (contexto 1M tokens)
- Gemini 3.5 Flash: ~4x mais rápido e mais barato — motor de orquestração paralela e verificação
- NotebookLM: firewall de alucinação, ancoragem em citações — oráculo confiável
- Claude Projects: memória estratégica persistente, instrução customizada sempre ativa

---

### CLUSTER C — FILOSOFIA JOBS APLICADA AO VANGUARD

Pesquisa realizada pelo Diretor — 5 princípios de Steve Jobs e sua aplicação direta:

C-1: A Relacao Sinal-Ruido — o foco implacável
Jobs operava com quase 100% de "sinal" = as 3 a 5 coisas críticas das próximas 18 horas.
Quem opera em proporção 50/50 tende a falhar.
Aplicação no Pentalateral: a IA pode sobrecarregar com ideias infinitas. NotebookLM cura o
sinal (grounded, não alucina). Claude Projects sintetiza. Claude Code executa as 3-5 tarefas
críticas do dia. O Estrategista não despacha 25 inputs ao Diretor — despacha as 3-5 coisas
críticas já filtradas.

C-2: A Poda Estrategica — cortar 70%, focar nos 30% que sao "joias"
Jobs voltou à Apple em 1997, cortou 70% do roadmap confuso, focou nos 30% que eram "joias" —
linha de produtos mais simples e muito melhor.
Aplicação no Pentalateral: as 91 sugestões são o roadmap bruto. O Estrategista aplica a poda:
o que é joia do V30 e o que é feature de museu tecnológico? Usar a capacidade das IAs não para
fazer mais coisas, mas para iterar infinitamente sobre o core do produto.

C-3: Visao Diretiva — nao pesquisa de mercado, visao testada com protótipos
Jobs ignorava pesquisa de mercado tradicional e testava sua visão via protótipos rápidos em horas.
Aplicação no Pentalateral: o Antigravity SDK cria protótipos de agentes em horas. Foco: mostrar
ao mercado o que é possível antes de perguntar o que o mercado quer.

C-4: Estoque Zero — distribuição ágil
Em empresas de tecnologia, "estoque" = pipelines estagnados, tarefas acumuladas, código não
implantado. Claude Code com CI/CD elimina esse estoque. O sistema responde ao mercado sem
acúmulo de backlog.

C-5: Marketing de Valores — o maquinário é o segredo interno
O cliente não ouve sobre NotebookLM, Claude Code, Gemini, Antigravity. Ouve sobre a
transformação que o produto gera. O Pentalateral é a vantagem assimétrica interna — nunca
o produto que o cliente compra.

---

### CLUSTER D — ANALISE DO AUDITOR (33 FONTES EXTERNAS + HISTORICAS)

O Auditor recebeu 33 fontes (V1 a V29 + artigos do Google Developers Blog, SiliconANGLE,
Claude Cowork Guide, Substack de Frank Andrade, transcrições YouTube de Well Pires, Tico
Santos, Prof. Dr. Álvaro Pinheiro) e analisou todas as ideias M e G do Loop 29. Resultado:

D-1: M-2 EXPANDE — Embaixador com Computer Use API (Cowork)
O Claude Cowork Guide revela a real capacidade: uso de Computer Use API ("Eyes", "Hands",
"Brain") rodando em Secure Sandbox. O Embaixador deixa de ser "agente de chat" e passa a
ser executor de interface (UI) e organizador de arquivos.
Condição inviolável: missão aprovada previamente pelo Diretor + output ao PENDING_REVIEW.md.

D-2: M-4 EXPANDE — Antigravity como Manager Surface
Google Developers Blog e SiliconANGLE detalham o Antigravity como plataforma "Agent-First"
com uma "Manager Surface" que despacha agentes de longo prazo em background, suportada pelo
Gemini 3.5. O Estrategista não apenas planeja — orquestra agentes subjacentes que geram
"Artifacts" para verificação humana visual (não logs brutos).

D-3: M-1 ALERTA CRITICO — tecnicamente viável, mas viola P-124 sem checkpoint
Fontes (notebooklm-py, Reddit, Tico Santos) confirmam automação de Chrome para conectar
Claude Code ao NotebookLM. A automação contínua sem intervenção do Diretor viola P-124.
A forma correta: Músculo consulta o Auditor via MCP/script como Background RAG (P-129).
Leitura contínua é viável. Deliberação autônoma entre LLMs não é.

D-4: G-4 ALERTA CRITICO — Conselho Dialetico é camara de eco proibida
LLMs debatendo entre si sem restrições viola P-124 e P-122. O Pentalateral não aprova nada
sozinho — o Diretor emite o veredito. O sistema produz inputs; o Diretor delibera.

D-5: G-1 e G-2 ALERTAS — violam P-121 e P-059
Upsell antecipado via simulação predatória (G-1) e clonagem de prospectos em background (G-2)
destroem o Hypercare e violam o isolamento de contexto por cliente (P-059).

D-6: N-1 a N-5 do Auditor — ideias táticas aprovadas pelo LEDGER
- N-1: Topologia n8n resiliente — disparos assíncronos em fila de staging; Músculo faz batch review
- N-2: Schemas cruzados anonimizados — padrão vetorial em caderno [VANGUARD]-INTEL apenas
- N-3: Auditor como Background RAG — ingestão contínua; deliberação só com Diretor presente
- N-4: Hermes Grau B com "Artifacts" visuais — veto em 15min; Diretor aprova em 5 segundos
- N-5: MRR medido pelo aumento de ticket médio quando Antigravity ancora pitch irrecusável (P-108)

D-7: Padrao de Sucesso vs Falha (V16 a V29 cruzado com fontes externas)
Sucesso: trilhos guiados (n8n W-1 a W-7 em V27; Hermes shadow em V28; Antigravity P-130 em V29).
Falha: delegar inteligência sem supervisão humana (Claude daemon V24; Grau A não reduziu custo V28).
As fontes externas (Cowork, Antigravity Manager Surface) ampliam os trilhos — não substituem o
checkpoint. Quem roda 1.000 agentes em 2026 ainda aprova de manhã.

---

### CLUSTER E — FONTE EXTERNA PARA ANALISE

E-1: Repositório lovable.app de skills para nocode startups
URL identificada pelo Diretor como potencialmente aderente ao Vanguard.
Análise pendente: quais skills têm sobreposição com o roadmap V30?

---

## [ABERTURA DO MUSCULO — M-1 a M-5 · LOOP 30]

Estes são os 5 eixos que o Músculo identifica como mais críticos entre as 91 sugestões:

[M-1] COWORK COMO "MAO DIREITA" DO EMBAIXADOR
O Cluster D-1 confirma: Computer Use API transforma o Embaixador de agente de chat em executor
de sistema. Custo: mensalidade Cowork ~$20/mês. Impacto: onboarding de cliente cai de 1 hora
do Diretor para 10 minutos supervisionados. Gargalo a resolver: protocolo de missão (P-127)
para o Embaixador executar com aprovação prévia explícita do Diretor.

[M-2] PODA JOBS COMO FILTRO DO BACKLOG V30
A metodologia Jobs (C-2) inverte o processo: em vez do Músculo filtrar 25 inputs brutos, o
Estrategista entrega o backlog já podado. Critério de poda: aumenta MRR, reduz custo do Diretor,
ou é pré-requisito técnico de algo que faz isso? Das 91 sugestões, espera-se que 3-5 sejam joias.

[M-3] NOTEBOOKLM VIA MCP: TRIANGULO DE VERDADE PROGRAMATICO
O B-3 confirma que o elo Musculo-Auditor via MCP é tecnicamente viável em 2026. Combinado com
P-132 (triangulação cega), a consulta ao Auditor deixa de ser etapa manual (arrastar arquivos +
abrir browser) e passa a ser chamada de script antes de qualquer afirmação crítica.

[M-4] /ULTRATHINK COMO PROTOCOLO PRE-PASSO3
Skill /ultrathink (A-3) instalada antes de cada PASSO3 eleva a qualidade da análise do Músculo.
Processo: Músculo roda /ultrathink sobre o contexto → identifica inconsistências e vieses → PASSO3
chega ao Estrategista mais ancorado → DIRETRIZ produzida com menos Alucinação Otimista.

[M-5] PIPELINE ZERO É O GARGALO REAL — P-133 PRECISA DE ESTRATEGIA
P-133 alerta: o sistema tem capacidade para 20 projetos simultâneos mas ZERO clientes em discovery
ativo. A filosofia Jobs (C-3: visão diretiva via protótipos) sugere a estratégia de V30: construir
o DEMO MAIS IMPRESSIONANTE de 1 nicho (LegalTech ou EdTech) usando o arsenal completo do
Pentalateral, e MOSTRAR ao mercado — não perguntar o que ele quer.

---

## [MISSAO PARA O ESTRATEGISTA]

Com base nos 4 clusters e nos M-1 a M-5 acima, você deve entregar:

1. PODA JOBS — O BACKLOG PODADO DO V30:
Das 91 sugestões organizadas nos 4 clusters, quais são as 3-5 "joias"?
Critério de poda: aumenta MRR, reduz custo operacional do Diretor, ou é pré-requisito técnico?
O que vai para V31? O que é museu tecnológico e deve ser descartado?

2. DIRETRIZ V30 — ARQUITETURA DO CONSELHO EXPANDIDO:
- Como expandir LMM do Embaixador e do Antigravity sem furar P-124?
- Como implementar o elo Musculo-Auditor via MCP de forma segura (P-129)?
- Qual é a hierarquia correta de Opus+Sonnet no Pentalateral? (B-4)
- Como o Firewall (P-131/P-132/P-133/P-134) protege a expansão sem freá-la?

3. ESTRATEGIA DE PIPELINE — P-133:
P-133 é gate de 1a classe: Loop 30 não fecha sem status de discovery do 3o cliente.
Como o V30 ataca o gargalo de aquisição com o arsenal atual — sem features novas?
A estratégia Jobs (C-3) de "mostrar antes de perguntar" é viável aqui?

4. [G-1 a G-5] — cinco ideias DISRUPTIVAS para V30.
Atenção: G-1/G-2 do Loop 29 foram ALERTAS (violam P-121 e P-059). Não repetir.
O eixo é expansão do arsenal interno e estratégia de pipeline.

5. [PARA O NOTEBOOKLM] — bloco obrigatório ao final.
Skill nomeada: vanguard-v30.md

---

## [FORMATO OBRIGATORIO DA DIRETRIZ]

DIRETRIZ ESTRATEGICA V30 — VANGUARD TECH — Loop 30

[1. VALIDACAO DO MUSCULO] — o que está certo nos M-1 a M-5
[2. PODA JOBS] — backlog podado: JOIAS (entra V30) / V31 / DESCARTADO
[3. DECISAO CLARA] — ENTRA AGORA / V31 / V32 / DESCARTADO — sem ambiguidade
[4. ENHANCEMENT] — como tornar as joias mais fortes
[5. CUSTO REAL] — tempo de build + custo de API + pré-requisitos honestos
[6. IMPACTO COMERCIAL] — o que muda para o Diretor e para os clientes
[7. PROXIMA ACAO] — o que o Diretor faz agora para desbloquear

[G-1 a G-5] — cinco ideias disruptivas de EXPANSAO (nao de contenção)

[PARA O NOTEBOOKLM]
Skill: vanguard-v30.md
[IDENTIDADE DO AUDITOR UNIVERSAL]
[O QUE AUDITAR NESTE LOOP]
[PADROES HISTORICOS CRITICOS]
[N-1 a N-5]

---

## [RESTRICOES INVIOLAVEIS — LEDGER ATIVO]

- P-124: checkpoint humano entre sócios é obrigatório — nenhum agente dispara outro sem PENDING_REVIEW
- P-131: Diretor ativo em todo o processo; silêncio nao é aprovação
- P-132: triangulação cega — mesmo fato pesquisado por 2 ou mais engines antes de virar verdade
- P-133: Gate Zero — Loop 30 não fecha sem status de discovery do 3o cliente
- P-059: isolamento de contexto por cliente é lei — nunca cruzar dados de projetos diferentes
- P-116: Hermes Grau B bloqueado até validar W-8 shadow (deadline 14/06/2026)
- P-121: automação não iniciada pelo cliente é ameaça de churn
- P-122: LLMs não aprovam nada entre si — Diretor emite o veredito
