ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-06-10 22:07
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
0106992 feat(session_close): Gate 1.7 -- BLOQUEANTE se VANGUARD_TIMELINE desatualizada com o loop atual
813c302 docs(timeline): TIMELINE V30/V31 -- Loop 30+31 FECHADOS + P-135..P-147 + Hermes GrauB + propagar 6 copias
c1c6936 docs(ledger): FALHAS-PROCESSO-2026-06-10 A-G -- 7 falhas da sessao Loop 31 registradas

================================================================================

## INTELLIGENCE LEDGER -- PRINCIPIOS ATIVOS
### CABECALHO + LEIS SOBERANAS
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

### INDICE COMPLETO DE PRINCIPIOS (titulos -- use para citar P-XXX corretamente)
### [P-001] Claude Code ≠ Daemon Autônomo
### [P-002] VEREDITO BINÁRIO não é burocracia universal
### [P-003] Scraping de terceiros é dependência, não ativo
### [P-004] O primeiro cliente não vem do site — vem de uma ligação
### [P-006] Precificação de serviço deve ser calculada por ROI do cliente, não por feeling
### [P-005] Inteligência acumulada por sessão, não por versão
### [P-009] Número de loops evolutivos é proporcional à amplitude do projeto
### [P-008] Primeiro cliente com produto soberano vale mais que MRR
### [P-010] Verificar em cada etapa antes de avançar
### [P-013] Soberania do Cliente não é promessa — é pré-requisito de build
### [P-007] Template colado em IA = alucinação estrutural
### [P-014] Score de Incidência Histórica como variável de priorização em EdTech concursos
### [P-015] Análise cross-concurso como método de calibração para primeiras edições
### [P-016] Podcast como canal de retenção passiva em EdTech (recurso V2)
### [P-017] Infraestrutura de e-mail do Conselho — nunca reconfigurar do zero
### [P-018] O Diretor é o 4º LLM — Orquestração Dinâmica de Deficiências como Vantagem Competitiva
### [P-019] IAH Retainer não se vende sem MRR confirmado — Soft Veto ativo
### [P-020] Alucinação do Auditor deve ser registrada no LEDGER imediatamente
### [P-021] O Diretor é o originador da direção estratégica — não apenas o aprovador
### [P-022] NotebookLM como advogado do processo — auditor jurídico do Pentalateral
### [P-023] Necessidade do contrato com clientes — intervenção do Diretor
### [P-024] Validação de cargo é obrigatória antes de qualquer análise EdTech
### [P-025] Stack Supabase + Claude API — 7 panes documentadas e prevenção
### [P-026] Auditoria Contratual Obrigatória — Embaixador → Auditor → Cliente
### [P-027] Interação Livre Obrigatória — Embaixador participa do processo evolutivo
### [P-028] Embaixador como Inteligência Persistente — 8 Mandatos Expandidos
### [P-029] Capacidade de LLM sem protocolo de uso é ruído — não inteligência
### [P-030] Automação contínua — fator humano insubstituível como único freio
### [P-031] O Embaixador como filtro de realidade das ideias do Conselho
### [P-032] MEMORIA_EMBAIXADOR é responsabilidade automática do Músculo
### [P-033] Sync universal → projetos é obrigatório e imediato
### [P-034] Análise Cirúrgica do Músculo é pré-requisito antes do Embaixador
### [P-035] Embaixador opera em amplitude total — não apenas comportamento do cliente
### [P-036] Músculo prepara mensagem estruturada para o Embaixador ao fim de cada análise cirúrgica
### [P-037] Músculo faz Síntese Final com TODOS os 25 inputs antes da decisão do Diretor
### [P-039] Leitura das últimas conversas é obrigatória após a primeira interação de cada sessão
### [P-040] Gate de nicho é template de replicação — não documentação de projeto
### [P-041] Discovery deve capturar a cena de sucesso, não apenas o problema declarado
### [P-042] Gate de validação semântica é ativo de nicho, não burocracia de entrega
### [P-043] Falácia da Homogeneidade dos Nichos — replicação não é trocar a URL dos dados
### [P-044] Momentum Tecnológico do Músculo — o motor ≠ a viagem do cliente
### [P-038] Nada sai da Vanguard sem gate de teste aprovado
### [P-045] Ritual de Fechamento de Loop é bloqueante — não opcional
### [P-046] Contrato segue teste — nunca precede
### [P-076] Pendente identificado = registrar imediatamente — não confiar na memória da sessão
### [P-047] Engajamento inaugural alto é receptividade — não hábito formado
### [P-048] Deliberação do Músculo é documento persistente — nunca contexto volátil
### [P-049] Output do Auditor é irrecuperável após fechar o NotebookLM
### [P-050] Teste integrado ao processo — não etapa final
### [P-051] Teste remoto valida a cena do cliente — não a funcionalidade genérica
### [P-052] Estrategista requer MASTER de ativação em toda sessão — a amnésia é estrutural
### [P-053] MANIFESTO_DE_FONTES declara o que o Auditor pode e não pode ver
### [P-054] Toda operação de substituição em massa exige verificação com grep imediata
### [P-055] Estado real de projeto NUNCA vem do resumo de sessão — vem dos arquivos
### [P-056] Deploy GitHub Pages exige sync explícito master → gh-pages
### [P-057] Abandono em EdTech ocorre no pico — não no vale
### [P-058] Ir ao Gemini com loop técnico incompleto é presentear o Estrategista com estado truncado
### [P-059] Isolamento de Contexto por Cliente é Lei — 20 Projetos Simultâneos Exigem Controle Rígido
### [P-060] Músculo é responsável por toda propagação — zero intervenção do Diretor
### [P-061] Nenhuma API key de terceiro pertence ao frontend — proxy obrigatório
### [P-063] Músculo lê PENDENTES.md completo como primeiro ato de qualquer sessão
### [P-062] Nenhum script de orquestração novo enquanto houver MRR não fechado em projeto ativo
### [P-064] Smoke test obrigatório antes de chamar o Diretor — deploy sem evidência é inválido
### [P-065] Advogado que testa antes de assinar já se vendeu — fechamento é confirmação, não persuasão (2026-05-24)
### [P-066] PAINEL_ATIVIDADES tem destino fixo — "Embaixador — Diretor" no Claude.ai
### [P-067] Músculo bloqueado até Embaixador reagir — gate automático pós-Skill aprovada
### [P-068] Síntese P-037 antes do Painel é bloqueante — Diretor decide, não processa
### [P-069] Data calendário rege a ordem de ação — não o dia interno do projeto
### [P-070] Onboarding Invisível — o cliente nunca cria conta
### [P-071] Sessão encerrada é fato técnico, não intenção — gate bloqueante obrigatório
### [P-072] Deliberação é ato formal, não conversa — painel HTML é o único canal de veredito
### [P-073] Documento editado fora da fonte canônica é uma duplicata — não uma versão
### [P-074] Propagação de decisão é total ou não é propagação — parcial é pior que zero
### [P-075] O Diretor delibera — não transporta contexto entre membros do Pentalateral
### [P-077] loop_fase_atual e atualizado pelo script do socio — nao pelo session_close
### [P-079] Shift de "estudante ansioso" para "player atacando o placar" e o sinal mais preciso de pre-comprometimento com aprovacao
### [P-078] Abandono silencioso em EdTech ocorre quando sistema funciona mas nao registra o esforco do usuario
## P-080 - PRINCIPIO EXTRAIDO DE PROJETO CLIENTE (2026-05-27)
## P-081 - PRINCIPIO EXTRAIDO DE PROJETO CLIENTE (2026-05-27)
## P-082 - PRINCIPIO EXTRAIDO DE PROJETO CLIENTE (2026-05-27)
## P-083 - PRINCIPIO EXTRAIDO DE PROJETO CLIENTE (2026-05-27)
## P-085 - ONBOARDING INVISÍVEL — CLIENTE NUNCA CRIA CONTA (2026-05-27)
## P-086 - SESSÃO GASTA EM CORREÇÃO = FALHA DO MÚSCULO, NÃO DO SISTEMA (2026-05-28)
## P-087 - MARCAÇÃO DE CONCLUSÃO DESACOPLADA DO ATO DE CONCLUIR É DÍVIDA TÉCNICA DE PROCESSO (2026-05-28)
## P-084 - PIPELINE COM ARQUIVO DE SAIDA DEVE CHECAR EXISTENCIA ANTES DE REPROCESSAR (2026-05-27)
## P-088 - PS5.1 CODIGO-FONTE ASCII-ONLY -- CONTEUDO RICO VAI PARA TEMPLATE EXTERNO (2026-05-28)
## P-089 - DOCUMENTO DE CONTEXTO DO SOCIO E REGENERADO PELO SCRIPT DO SOCIO ANTERIOR (2026-05-28)
## P-091 — WIP_BOARD REFLETE REALIDADE, NÃO INTENÇÃO (2026-05-30)
## P-090 - PASSO3 É ESCRITO NO ARQUIVO — NÃO NO CHAT (2026-05-29)
## P-092 — PERGUNTA ABERTA É FALHA DE DESIGN — VERIFICAÇÃO AUTÔNOMA (2026-06-01)
## P-093 — FERRAMENTA NORMALIZADA ANTES DO ROI PERCEBIDO (2026-06-01)
## P-094 — VALIDAÇÃO NO MOMENTO DA ESCRITA SUPERA DOCUMENTAÇÃO (2026-06-01)
## P-095 — GATE CHECKER DEVE CRUZAR TODAS AS FONTES DE EVIDÊNCIA (2026-06-01)
## P-096 — UNIVERSALIDADE E O CRITERIO DE ACEITE DA ARQUITETURA (2026-06-04)
## P-097 -- GATES BLOQUEANTES PRECISAM DE COBERTURA DE REGRESSAO (2026-06-04)
## P-099 — PING SUPABASE OBRIGATORIO NO ONBOARDING DE QUALQUER CLIENTE (2026-06-04)
## P-100 — EMBAIXADOR OPERA POR RAG — DESIGN DO PASSO7 DEVE RESPEITAR ISSO (2026-06-05)
## P-101 -- MENSAGEM EXTERNA NUNCA ACESSA CLAUDE DIRETAMENTE -- n8n COMO CAMADA OBRIGATORIA (2026-06-04)
## P-102 -- N8N COMPLEMENTA, NAO SUBSTITUI PROCESSOS EXISTENTES (2026-06-04)
## P-103 — NODE TELEGRAM DO N8N TEM BUG DE CREDENCIAL — USAR HTTP REQUEST (2026-06-04)
## P-104 — CAMPO JSODE VS FUNCTIONCODE NO NODE CODE DO N8N (2026-06-04)
## P-105 — WEBHOOK N8N V2: BODY ANINHADO EM $JSON.BODY (2026-06-04)
## P-106 — CHURNWATCH EDTECH: THRESHOLD 3 DIAS, NAO 5 (2026-06-04)
## P-107 — ANCORA DE PRECO EDTECH: CUSTO DO ERRO DE DIRECAO (2026-06-04)
## P-108 — CASE REAL ELEVA TETO DE PRECO DO SEGUNDO CLIENTE NO MESMO NICHO (2026-06-04)
## P-110 -- AUTOMACAO CRITICA EXIGE FALLBACK MANUAL DE NO MAXIMO 3 PASSOS (2026-06-05)
## P-109 -- NOTION E OUTPUT-ONLY: GIT E A UNICA FONTE DE VERDADE (2026-06-04)
## P-111 -- ATENDER CLIENTES E CONSTRUIR VANTAGEM COMPETITIVA SAO O MESMO ATO (2026-06-05)
## P-112 -- N8N COMO PRE-PROCESSADOR CONTROLADO: PALCO PRONTO, CONSELHO DELIBERA (2026-06-05)
## P-115 -- MUSCULO ASSESSORA ATIVAMENTE A CONCLUSAO DE PENDENTES E DEPENDENCY_MAP (2026-06-06)
## P-116 -- O QUE DOI E ERRO, NAO ESFORCO -- VERIFICACAO ANTES DE AUTOMACAO (2026-06-06)
## P-117 -- DIAGRAMA PARCIAL DO CICLO PENTALATERAL NORMALIZA SKIP DE MEMBRO (2026-06-06)
## P-114 — BLOCO 0 DO EMBAIXADOR É ADITIVO — NAO SUBSTITUI LEITURA DE ARQUIVOS (2026-06-06)
## P-113 -- INFORMACAO RETIDA E CUSTO INVISIVEL PARA QUEM DELIBERA (2026-06-05)
## P-118 -- AUDITAR EXECUCAO ANTES DE CONSTRUIR -- O MAPA DE FERRAMENTAS PODE ESTAR INCOMPLETO (2026-06-07)
## P-119 -- VIDEO PUBLICO DE DOR E DADO DE MARKETING, NAO DE INTENCAO DE COMPRA (2026-06-07)
## P-120 -- EMBAIXADOR PODE ACIONAR O AUDITOR PROGRAMATICAMENTE VIA CLAUDE IN CHROME (2026-06-07)
## P-121 -- AUTOMACAO NAO INICIADA PELO CLIENTE E AMEACA DE CHURN (2026-06-07)
## P-122 -- DELIBERACAO PRECEDE P-032 -- OUTPUT RECEBIDO NAO SIGNIFICA DELIBERACAO CONCLUIDA (2026-06-07)
## P-123 -- DOIS NAMESPACES DE NOTEBOOK -- BASE PERMANENTE E LOOP EFEMERO (2026-06-07)
## P-124 -- CHECKPOINT HUMANO OBRIGATORIO ENTRE SOCIOS -- NENHUM SOCIO ACIONA OUTRO DIRETAMENTE (2026-06-07)
## P-125 -- FIRE-AND-FORGET COM WEBHOOK -- STUDIO OUTPUTS NAO BLOQUEIAM O TERMINAL (2026-06-07)
## P-126 -- DOIS CAMINHOS DE EVOLUCAO, MESMA ORIGEM (2026-06-07)
## P-127 -- EMBAIXADOR OPERA O ESTRATEGISTA DE FORMA AUTONOMA COM GROUNDING VERIFICADO (2026-06-08)
## P-128 -- NOTION COMO CANAL BIDIRECIONAL DO DIRETOR (2026-06-08)
## P-129 -- FONTE INESGOTAVEL: O ELO MUSCULO<->AUDITOR E CAPACIDADE ABERTA (2026-06-09)
## P-130 -- ANTIGRAVITY ASSUME O PAPEL DE ESTRATEGISTA; O CANAL MUDA, A BARREIRA NAO (2026-06-09)
## P-131 -- O DIRETOR E ATIVO AO LONGO DE TODO O PROCESSO, NAO SO NO VEREDITO FINAL (2026-06-09)
## P-132 -- DIVERSIDADE DE ENGINES E MOTOR DE VERDADE; O ELO MUSCULO<->AUDITOR E O PAR PRIMARIO (2026-06-09)
## P-133 -- GATE ZERO DE PIPELINE: LOOP DE EXPANSAO NAO FECHA SEM DISCOVERY DO PROXIMO CLIENTE (2026-06-09)
## P-135 -- VANGUARD E UNICO SISTEMA COM 4 LLMs EM CONSELHO COORDENADO -- DIFERENCIAL ABSOLUTO (2026-06-09)
## P-137 -- MAPA DE SKILLS POR GATE DO PENTALATERAL (2026-06-09)
## P-136 -- ULTRATHINK E OBRIGATORIO NA SINTESE P-037 -- SKILL VALIDADA (2026-06-09)
## P-138 — VALDECE PRIMEIRO: DEMO NO NICHO DE CLIENTE ATIVO EXIGE PRÉ-AVISO ANTES DE PUBLICAR (2026-06-09)
## P-139 — VITRINE VS COFRE: LINHA OBRIGATÓRIA ANTES DO PRIMEIRO ARTIFACT PÚBLICO (2026-06-09)
## P-134 -- ITEM ABERTO VIVE EM PENDING_REVIEW/PENDENTES, NUNCA NA MEMORIA DE TURNO (2026-06-09)
## P-140 — WORKFLOW DE ABERTURA DE LOOP: YT-ENRICHMENT + EXPANSAO LMM + BRIEFING (2026-06-09)
## P-147 — BUDGET DE LEITURA DO DIRETOR E REGRA PERMANENTE (2026-06-10)
## P-146 — DOCUMENTAR SEM AUTOMATIZAR E REPETIR O ERRO (2026-06-10)
## P-145 — ATUALIZACAO DE DOCUMENTOS E EVENT-DRIVEN, NAO APENAS SESSION-DRIVEN (2026-06-10)
## P-144 — DOIS SOCIOS TEM PESQUISA AVANCADA WEB — USAR OBRIGATORIAMENTE (2026-06-10)
## P-143 — FERRAMENTA AUTOMATICA ANTI-ESQUECIMENTO DO MUSCULO (2026-06-10)
## P-142 — NOTEBOOKLM E 100% REMOTO — MUSCULO OPERA VIA PLAYWRIGHT (2026-06-10)
## P-141 — LOOP TRANSCRIPT: IMUNIDADE ESTRUTURAL A AMNESIA DE COMPACTACAO (2026-06-09)

### PRINCIPIOS RECENTES -- TEXTO INTEGRAL (P-116 ao ultimo)
## P-116 -- O QUE DOI E ERRO, NAO ESFORCO -- VERIFICACAO ANTES DE AUTOMACAO (2026-06-06)
**Origem:** Embaixador V28 -- Loop 28 -- "verificacao antes de automacao" como principio fundador do Hermes Agent.
**Fundamento:** Confianca no sistema nao se declara -- se verifica. Cada nivel de delegacao (Grau A/B/C) exige prova antes de subir. O Gate de Coerencia Semantica (E-1) nasce deste principio: antes de confiar que um handoff esta completo para o proximo socio, um agente verifica semanticamente. "O que doi e erro, nao esforco" -- a verificacao extra e esforco; o erro nao detectado e o que custa caro.
**Evidencia:** E-1 gate_coerencia.ps1 criado no V28. Graus A/B/C definidos em pentalateral-graus-abc.md. Shadow mode de 7 dias antes de ativar Signal Classifier -- padrao de verificar antes de confiar.
**Aplica-se a:** toda proposta de automacao nova -- a pergunta "o que verificamos antes de ativar?" precede a pergunta "quando ativamos?". Escada de confianca: shadow -> Grau A -> Grau B -> Grau C.

## P-117 -- DIAGRAMA PARCIAL DO CICLO PENTALATERAL NORMALIZA SKIP DE MEMBRO (2026-06-06)
**Origem:** Detectado em 2026-06-06 ao apresentar diagrama NotebookLM → Músculo sem o Embaixador.
**Fundamento:** Todo diagrama ou representação do ciclo Pentalateral mostrado no chat deve incluir os 5 membros (Gemini → NotebookLM → Embaixador → Músculo → Diretor) ou declarar explicitamente que é [SUBFLUXO: X]. Diagrama parcial — mesmo para explicar nomenclatura, naming convention ou subetapa — normaliza pular membros. O leitor passa a aceitar o ciclo incompleto como correto porque "viu no diagrama". Omissão visual é omissão operacional.
**Regra:** antes de gerar qualquer diagrama de fluxo ou tabela de sequência, verificar: todos os 5 membros estão representados? Se não → acrescentar ou adicionar nota [SUBFLUXO: X — Embaixador e Diretor operam em paralelo neste subfluxo].
**Evidência:** elo apresentado em sessão de nomenclatura omitiu o Embaixador — ciclo apareceu como NotebookLM → Músculo, normalizando o skip do 3º membro.
**Aplica-se a:** todo diagrama, tabela de sequência, fluxo PDCA ou representação visual do ciclo Pentalateral gerado pelo Músculo no chat ou em documentos.

## P-114 — BLOCO 0 DO EMBAIXADOR É ADITIVO — NAO SUBSTITUI LEITURA DE ARQUIVOS (2026-06-06)
**Origem:** Mandato do Diretor em 2026-06-06.
**Fundamento:** O Embaixador gera um BLOCO 0 ao fechar cada sessao: sintese do PAINEL_ATIVIDADES + CONTEXTO_SESSAO_DIRETOR com perspectiva comportamental de cliente, alertas e acoes do Diretor. O Diretor cola este bloco ao ABRIR a proxima sessao. O BLOCO 0 enriquece o briefing com interpretacao -- mas nao substitui a leitura de PENDENTES.md, WIP_BOARD.json ou PAINEL_ATIVIDADES. Os arquivos em disco confirmam e completam o que o Embaixador sintetizou.
**Sequencia obrigatoria de abertura (todas as etapas sempre):** 0. Processar BLOCO 0 -> 1. Read(PENDENTES.md) -> 2. Read(PAINEL_ATIVIDADES) -> 3. Read(WIP_BOARD + git log) -> 4. Classificar P-092 -> 5. Apresentar MAPA DIARIO com todas as informacoes combinadas.
**Fallback:** se Diretor nao colar BLOCO 0 -> Read(CONTEXTO_SESSAO_DIRETOR mais recente em disco).
**Evidencia:** sem o BLOCO 0, o Musculo abria com dados brutos sem interpretacao -- Diretor reconstruia contexto verbalmente. Com o BLOCO 0, o briefing chega com visao do Embaixador ja integrada aos arquivos. Detectado e corrigido em 2026-06-06.
**Aplica-se a:** toda abertura de sessao, sem excecao.
## P-113 -- INFORMACAO RETIDA E CUSTO INVISIVEL PARA QUEM DELIBERA (2026-06-05)
**Origem:** Embaixador em resposta ao design do CONTEXTO_SESSAO_DIRETOR (2026-06-05).
**Fundamento:** O Musculo tem a informacao. Se nao apresenta proativamente, o Diretor paga o preco. Informacao retida nao e neutralidade -- e custo invisivel para quem delibera. A abertura de sessao inclui obrigatoriamente: (a) contexto da ultima sessao, (b) documentos mortos, (c) o que ficou no ar. O Diretor nao e o gatilho de memoria do proprio sistema.
**O que muda operacionalmente:** (a) session_start.ps1 injeta BLOCO 0 (CONTEXTO_SESSAO_DIRETOR) e BLOCO 1 (documentos mortos varredura automatica). (b) Musculo gera CONTEXTO_SESSAO_DIRETOR antes de session_close -- nao depois. (c) Diretor arrasta o arquivo para Claude Projects (Embaixador) ao fechar sessao -- acao A4 insubstituivel.
**Evidencia:** Pedido de CONTEXTO_SESSAO_DIRETOR feito em sessao anterior mas nao registrado no PENDENTES -- processo verbal sem rastreio. Detectado pelo Diretor em 2026-06-05.
**Aplica-se a:** toda abertura de sessao + todo fechamento de sessao com conteudo relevante que nao esta em PENDENTES nem WIP_BOARD.
## P-118 -- AUDITAR EXECUCAO ANTES DE CONSTRUIR -- O MAPA DE FERRAMENTAS PODE ESTAR INCOMPLETO (2026-06-07)
**Origem:** Briefing do Embaixador + auditoria do Musculo -- sync_ficou_no_ar.ps1 nao estava no mapa original de ferramentas anti-dessincronizacao do PENDENTES, e era exatamente onde os dois bugs moravam.
**Fundamento:** Problema recorrente com ferramenta de prevencao ja inscrita no LEDGER → primeira acao e auditar execucao, nao construir camada nova. A auditoria pode revelar que a ferramenta funciona e o defeito esta num componente vizinho nao mapeado. Licao dupla: (a) nao construir sobre ferramenta supostamente quebrada sem provar que ela e a culpada -- P-062 aplicado ao proprio LEDGER; (b) o mapa de ferramentas pode estar incompleto -- perguntar "que outro script toca este arquivo?" antes de concluir. Reincidencia com ferramenta declarada OK e caso de P-091 aplicado ao LEDGER: a declaracao de "implementado" e dado falso ate prova de execucao em disco.
**O que muda operacionalmente:** Antes de emitir briefing de auditoria ou propor nova ferramenta, mapear TODOS os scripts que escrevem no arquivo-alvo (nao so os declarados no LEDGER). DEPENDENCY_MAP cobre documentos canonicos; para scripts, perguntar explicitamente: "que outros scripts tocam este arquivo?" antes de concluir o mapa.
**Evidencia:** sync_ficou_no_ar.ps1 nao constava no briefing do Embaixador (que listou post-commit, auto_resolve_pendentes, reconcile_pendentes). Era o componente com os dois bugs (dedup de 20 chars fixos + cabecalho duplicado). Auditoria so atingiu a causa raiz porque o Musculo revelou o quarto componente no Passo 2.
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** toda auditoria de ferramenta + toda proposta de nova automacao sobre arquivo ja coberto por scripts existentes.

## P-119 -- VIDEO PUBLICO DE DOR E DADO DE MARKETING, NAO DE INTENCAO DE COMPRA (2026-06-07)
**Descoberto:** 2026-06-07 | **Sessao:** Analise oportunidade Mumuzinho | **Emitido por:** Embaixador | **Aprovado por:** Diretor Eduardo
**Fundamento:** Um prospecto que declara dor em video publico demonstra que o problema existe e que ele esta disposto a falar sobre ele. Isso e dado de marketing: confirma que ha demanda no nicho. Nao e dado de intencao de compra: nao confirma que ele quer contratar a Vanguard, que tem orcamento disponivel, nem que o decisor real foi identificado. Lead nao existe ate haver contato bilateral real -- uma mensagem respondida, uma ligacao aceita, uma reuniao agendada.
**O que muda operacionalmente:** Toda analise de oportunidade baseada em video publico (YouTube, entrevista, podcast) deve declarar explicitamente no cabecalho: "CONTATO BILATERAL: NAO CONFIRMADO -- variavel nao resolvida". O GUT Score calculado sem contato bilateral deve ser marcado como provisorio e recalculado apos o primeiro contato. Nenhuma estimativa de escopo, proposta tecnica ou alocacao de capacidade acontece antes do Gate Zero: contato bilateral confirmado com o decisor real.
**Evidencia:** Mumuzinho declarou dor em video publico ("ja estou criando um sistema"). O Musculo calculou GUT = 60 (provisorio) vs. GUT potencial = 100 (pos-contato). A diferenca de 40 pontos e 100% atribuivel a ausencia de contato bilateral. Sem esse gate, qualquer proposta e para um cliente imaginario.
**Corolario comercial:** "Ja esta construindo com outra equipe" e sinal positivo, nao ameaca -- prova compromisso e orcamento. A questao e se o build atual tem os gaps que a Vanguard resolve. Isso so se sabe com contato direto.
**Aplica-se a:** toda analise de oportunidade iniciada por video, podcast, entrevista ou post publico -- independentemente do tamanho do prospecto ou da clareza da dor declarada.

## P-120 -- EMBAIXADOR PODE ACIONAR O AUDITOR PROGRAMATICAMENTE VIA CLAUDE IN CHROME (2026-06-07)
**Origem:** Diretor Eduardo descobriu a skill /notebooklm em 2026-06-07. Pediu ao Embaixador que observasse e transmitisse a descoberta ao Musculo como canal estruturado. Correcao formal da atribuicao registrada em P-126.
**Fundamento:** O Embaixador (Claude Projects) transmitiu ao Musculo que a extensao Claude in Chrome permite controlar o NotebookLM (Auditor) via automacao de browser -- sem que o Diretor precise arrastar arquivos, copiar/colar ou abrir o NotebookLM manualmente. A skill .claude/skills/notebooklm.md encapsula 4 acoes principais: ler/extrair info, adicionar fontes (URL, texto, arquivo, Google Doc), gerar Studio outputs (Audio Overview, Infografico, Slides, FAQ, etc.) e criar notebooks novos. Quando o Embaixador aciona o Auditor com esta skill, o ciclo Musculo→Gemini→Auditor→Embaixador fecha sem interrupcao manual do Diretor.
**O que muda operacionalmente:**
  (a) PASSO5_NOTEBOOKLM: o Diretor pode delegar ao Embaixador o envio de fontes ao Auditor via Claude in Chrome -- zero arrastar manual
  (b) Musculo pode acionar o Auditor diretamente quando precisar de uma consulta rapida ao notebook sem abrir sessao separada
  (c) Embaixador pode adicionar fontes ao notebook do Auditor como parte do debriefing pos-reuniao -- sem etapa manual intermediaria
  (d) Fallback manual: abrir https://notebooklm.google.com + arrastar arquivos (1 passo -- P-110 cumprido)
  (e) Pre-requisito: extensao Claude in Chrome instalada + Google account logada no browser
**Arquivo da skill:** .claude/skills/notebooklm.md (leitura direta) e .claude/skills/notebooklm.skill (formato binario para instalacao no dashboard)
**Verificacao dos alertas do Auditor:**
  P-072 (Deliberacao formal): Zero conflito -- P-072 regula vereditos do Diretor, nao acoes do Musculo/Embaixador. VERDE.
  P-110 (Fallback ≤3 passos): Fallback = abrir notebooklm.google.com manualmente (1 passo). VERDE.
  P-060/P-074 (Propagacao total): Skill e ferramenta do Musculo (nao documento universal) -- nao propaga para CLIENTES/. Documentada no SKILL_PROTOCOLO via auditoria P-070→P-101 da mesma sessao. VERDE.
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** todo ciclo Pentalateral onde o Diretor precisaria arrastar fontes ao NotebookLM manualmente + todo debriefing pos-reuniao onde o Embaixador ja tem o material para alimentar o Auditor.

## P-121 -- AUTOMACAO NAO INICIADA PELO CLIENTE E AMEACA DE CHURN (2026-06-07)
**Origem:** Analise do Musculo a partir da deliberacao sobre skill /notebooklm e risco de Camara de Eco de Silicio -- sessao 2026-06-07.
**Fundamento:** Automacao aplicada ao cliente sem que ele a tenha solicitado ou aprovado e percebida como produto em construcao permanente, instabilidade ou invasao de privacidade. No contexto Hypercare (cliente recente, confianca em formacao), qualquer automacao visivel ao cliente que ele nao conheca pode gerar churn emocional -- nao por falha tecnica, mas por surpresa nao gerenciada.
**Regra operacional:**
  (a) Toda automacao que afete a experiencia do cliente deve ser comunicada ANTES de ativar -- nunca surpresa
  (b) Durante Hypercare: zero automacao visivel ao cliente sem aprovacao explicita do Diretor e do proprio cliente
  (c) Automacoes internas (INTELLIGENCE HUB, ChurnWatch, Sentinel) sao invisiveis ao cliente -- permitidas sem gate
  (d) O Embaixador valida se a comunicacao da automacao e oportuna antes de qualquer anuncio
**Camara de Eco de Silicio (risco relacionado):** LLMs conversando com LLMs sem checkpoint humano fecham o loop tecnicamente mas perdem o julgamento comercial humano. P-124 complementa este principio com o gate obrigatorio.
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** todo projeto em Hypercare + todo momento em que uma nova automacao for ativada que tenha interface com o cliente.

## P-122 -- DELIBERACAO PRECEDE P-032 -- OUTPUT RECEBIDO NAO SIGNIFICA DELIBERACAO CONCLUIDA (2026-06-07)
**Origem:** Falha detectada pelo Diretor em 2026-06-07 -- Musculo executou P-032 (atualizacao da MEMORIA_EMBAIXADOR) antes de apresentar as decisoes ao Diretor e receber veredito.
**Fundamento:** Receber o output de um socio (Gemini, NotebookLM, Embaixador) e o primeiro passo da deliberacao -- nao o ultimo. O Musculo que atualiza MEMORIA ou executa acoes com base em output recebido sem que o Diretor tenha deliberado esta cortocircuitando o processo. A deliberacao e prerrogativa exclusiva do Diretor -- o Musculo apresenta, o Diretor decide.
**Sequencia inviolavel:**
  1. Musculo recebe output do socio
  2. Musculo apresenta ao Diretor: "Dx decisoes identificadas -- D1: [titulo] A/B, D2: [titulo] A/B..."
  3. Diretor responde: "D1:A D2:B D3:A"
  4. SOMENTE APOS o veredito: Musculo executa P-032 e demais acoes
**O que nao e deliberacao:** Musculo concordar internamente com o output · Musculo achar que a acao e obvia · Musculo executar para "economizar tempo" do Diretor
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** toda sessao em que output de socio chegar e houver acoes derivadas -- especialmente P-032 (MEMORIA_EMBAIXADOR), compromisos de build e vereditos de DECISOES.json.

## P-123 -- DOIS NAMESPACES DE NOTEBOOK -- BASE PERMANENTE E LOOP EFEMERO (2026-06-07)
**Origem:** Deliberacao sobre modelo hibrido de notebooks NotebookLM -- sessao 2026-06-07.
**Fundamento:** O NotebookLM (Auditor) opera com dois tipos de contexto que nao devem se misturar: (a) inteligencia universal e historica da Vanguard (LEDGER, universais, processo) e (b) contexto especifico do loop atual do cliente (PASSO5, docs do ciclo). Misturar os dois contamina o Auditor com dados de cliente em espaco permanente, violando P-059 (Isolamento de Contexto) e criando risco de vazamento entre projetos.
**Dois namespaces obrigatorios:**
  [cliente]-base   : notebook PERMANENTE -- contem LEDGER + universais + SKILL_PROTOCOLO + historico do cliente. NUNCA recebe docs de loop efemero. NUNCA recebe documentos do cliente (acórdãos, planilhas, dados sensiveis).
  [cliente]-loop-N : notebook EFEMERO -- criado no inicio do loop N, destroido apos skill extraida e aprovada. Contem PASSO5 + docs do ciclo atual + fontes especificas do loop.
**Regras de isolamento:**
  (a) Studio outputs (Audio Overview, Infografico) NUNCA saem do namespace loop -- sao descartados com o notebook efemero
  (b) A skill gerada pelo loop (.[cliente]-vN.md) e o unico artefato que sobrevive ao loop -- salva em .claude/skills/
  (c) O namespace base e sincronizado via preparar_notebooklm_projeto.ps1 -- nunca editado manualmente
  (d) Nome obrigatorio: "[YYYY-MM] [NOME_CLIENTE]-base" e "[YYYY-MM] [NOME_CLIENTE]-loop-N"
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** todo projeto com NotebookLM ativo -- Valdece, Ingrid e qualquer cliente futuro.

## P-124 -- CHECKPOINT HUMANO OBRIGATORIO ENTRE SOCIOS -- NENHUM SOCIO ACIONA OUTRO DIRETAMENTE (2026-06-07)
**Origem:** Risco de Camara de Eco de Silicio identificado na deliberacao sobre skill /notebooklm -- sessao 2026-06-07.
**Fundamento:** O Pentalateral IAH e um sistema de multiplos LLMs com perspectivas distintas. O valor do sistema vem da diversidade de modelos e da curadoria humana entre cada camada. Se um socio acionar outro diretamente (Musculo chama Gemini API que chama NotebookLM que alimenta Embaixador), o loop fecha sem checkpoint humano -- e tecnicamente correto mas comercialmente cego. O Diretor perde a capacidade de detectar deriva antes que ela se acumule.
**Regra operacional:**
  (a) Nenhum socio aciona outro socio diretamente no loop de cliente -- o Diretor e o intermediario obrigatorio
  (b) Automacoes de infraestrutura (INTELLIGENCE HUB, ChurnWatch, Sentinel) podem rodar LLM→LLM pois nao geram vereditos de cliente
  (c) Quando o Musculo precisar de input do Auditor rapidamente, o gate e: apresentar a necessidade ao Diretor → Diretor aprova → Musculo executa
  (d) A unica excecao e o fire-and-forget de Studio outputs (P-125) -- nao gera veredito, apenas conteudo de apoio
**Camara de Eco de Silicio:** dois ou mais LLMs do mesmo provedor (ex: Gemini + Antigravity CLI) no mesmo loop de cliente amplificam os proprios vieses sem filtro humano -- nunca permitido no Pentalateral.
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** toda automacao que encadeie dois ou mais socios do Pentalateral sem passagem pelo Diretor.

## P-125 -- FIRE-AND-FORGET COM WEBHOOK -- STUDIO OUTPUTS NAO BLOQUEIAM O TERMINAL (2026-06-07)
**Origem:** Gargalo identificado na geracao de Studio outputs (Audio Overview) do NotebookLM -- sessao 2026-06-07.
**Fundamento:** Studio outputs (Audio Overview, Infografico, Slides, FAQ) levam de 3 a 10 minutos para gerar. Se o Musculo aguardar sincronamente, o terminal fica bloqueado e o Diretor perde tempo. O padrao correto e: disparar a geracao e liberar o terminal imediatamente -- o n8n monitora a pasta .claude/skills/ e notifica o Diretor via Telegram quando o output estiver pronto.
**Sequencia fire-and-forget:**
  1. Musculo aciona a geracao do Studio output via skill /notebooklm
  2. Musculo dispara webhook n8n (W-4 ou endpoint dedicado) com: cliente, loop, tipo de output
  3. Terminal liberado -- Musculo continua outras tarefas
  4. n8n monitora .claude/skills/ ou polling no NotebookLM
  5. Quando output pronto: n8n notifica Diretor via Telegram com link ou arquivo
**O que NUNCA fazer:** aguardar sincronamente a geracao de Studio output · manter terminal ocupado por 10 minutos · perguntar ao Diretor "quer que eu aguarde?"
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** toda sessao em que Studio outputs forem solicitados ao Auditor -- especialmente Audio Overview que e o mais demorado.

## P-126 -- DOIS CAMINHOS DE EVOLUCAO, MESMA ORIGEM (2026-06-07)
**Origem:** Deliberacao do Musculo a partir da descoberta da skill /notebooklm -- sessao 2026-06-07.
**Fundamento:** O Pentalateral IAH evolui por dois caminhos distintos -- ambos originados pelo Diretor:
  CICLO FORMAL: Diretor define direcao estrategica -> Gemini gera DIRETRIZ -> NotebookLM gera Skill -> Musculo constroi. Caminho top-down, estrategia como ponto de partida.
  CICLO EMERGENTE: Diretor descobre capacidade nova -> usa o Embaixador como canal estruturado de transmissao -> 4 socios analisam em paralelo -> Diretor homologa a reconfiguracao. Caminho bottom-up, capacidade como ponto de partida.
**O papel do Embaixador no Ciclo Emergente:** alem de memoria de cliente e filtro de realidade, o Embaixador opera como canal de transmissao estruturado entre o Diretor e os demais socios -- recebe a descoberta do Diretor, processa com contexto e encaminha ao Musculo com perspectiva interpretada. Nao e descobridor. E amplificador com julgamento.
**O que nao muda:** em nenhum dos dois caminhos o sistema evolui sem o Diretor como ponto de origem. Socios analisam. Musculo constroi. O Diretor descobre e decide -- sempre. A automacao amplia a capacidade do Diretor, nunca a substitui.
**Correcao de atribuicao:** P-120 registrou "Descoberta do Embaixador" -- correcao formal: a descoberta foi do Diretor Eduardo. O Embaixador foi o canal. P-120 atualizado para refletir a origem correta.
**Evidencia:** sessao 2026-06-07 -- skill /notebooklm descoberta pelo Diretor, transmitida via Embaixador ao Musculo, analisada pelos 4 socios (Embaixador Universal + Auditor Universal + Auditor Ingrid + Embaixador Ingrid), homologada pelo Diretor. Nenhum socio iniciou o processo -- o Diretor originou.
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** toda sessao em que uma nova capacidade, skill ou ferramenta for descoberta e trazida ao Pentalateral para analise e reconfiguracao do sistema.

## P-127 -- EMBAIXADOR OPERA O ESTRATEGISTA DE FORMA AUTONOMA COM GROUNDING VERIFICADO (2026-06-08)
**Origem:** Teste ao vivo conduzido pelo Embaixador na sessao 2026-06-08 -- skill gemini-pentalateral v2.1.
**Fundamento:** O Embaixador (Claude Projects) pode acionar o Estrategista (Gemini) de forma autonoma usando a skill gemini-pentalateral v2.1 -- com browser automation, upload de contexto e grounding verificado. O teste do nicho Medico Concurseiro foi bem-sucedido: DIRETRIZ gerada com grounding real (nao alucinada), entregue ao Musculo via PENDING_REVIEW.md. Esta e a 1a instancia documentada de um socio do Pentalateral acionando outro socio com resultado verificado.
**O que muda:** O Embaixador nao e apenas filtro de realidade e memoria de cliente. E tambem capaz de operar o Estrategista como canal -- desde que o Diretor aprove a missao previamente (P-124: checkpoint humano obrigatorio). O loop Embaixador->Estrategista->Musculo e valido quando iniciado pelo Diretor.
**Limitacoes obrigatorias (P-124 permanece):**
  (a) O Diretor aprova a missao ANTES do Embaixador acionar o Estrategista
  (b) O output do Estrategista vai para PENDING_REVIEW.md -- revisado pelo Musculo antes de qualquer acao
  (c) Este loop NAO substitui o ciclo formal (Diretor->Gemini interativo->DIRETRIZ)
  (d) Uso permitido: pesquisa de mercado, analise de nicho, grounding de contexto -- NAO para DIRETRIZ de cliente
**Ferramenta:** skill gemini-pentalateral v2.1 (`.claude/skills/gemini-pentalateral-v2.1.md`) -- browser automation Embaixador->Estrategista.
**Evidencia:** teste Medico Concurseiro -- 2026-06-08. DIRETRIZ gerada com dados reais de mercado, entregue ao Musculo, aprovada pelo Diretor.
**Aprovado pelo Diretor:** 2026-06-08.
**Aplica-se a:** qualquer sessao em que o Embaixador for instruido pelo Diretor a conduzir pesquisa de mercado ou grounding via Estrategista -- especialmente pre-prospeccao de novos nichos.

## P-128 -- NOTION COMO CANAL BIDIRECIONAL DO DIRETOR (2026-06-08)
**Origem:** Falha relatada pelo Diretor ("Notion nao esta atualizado, conserte") + sugestao do Diretor de usar paginas Notion como canal de comunicacao para ideias/falhas do dia.
**Causa raiz da falha:** a pagina "Vanguard WIP Board" nunca havia sido compartilhada com a integration "Vanguard IAH" -> a API retornava 404 -> os workflows n8n (W-1, W-4) gravavam com `2>$null` e a falha ficava invisivel. Diretor resolveu compartilhando a pagina.
**O que muda -- ciclo Notion bidirecional 100% por codigo (Diretor NAO administra Notion):**
  ENTRADA (session_start, leitura OBRIGATORIA toda sessao):
    - `notion_inbox.ps1` le "Vanguard - Falhas do Dia" + "Vanguard - Sugestoes do Dia" -> Musculo classifica e marca [PROCESSADO]
    - `notion_pendentes_pull.ps1` le "Vanguard Pendentes": itens que o Diretor marcou [x] no Notion sao quitados no PENDENTES.md local
  SAIDA (session_close):
    - `notion_sync.ps1` reescreve "Vanguard Pendentes" (so abertos) + "Vanguard WIP Board" + "Ledger Vanguard"
**Regras invioláveis:**
  (a) FLEXIBILIDADE DO DIRETOR E SO EM ITENS [diretor]. Item [musculo] marcado no Notion -> IGNORADO + alerta (esses se quitam por [RESOLVE:]/git, P-087). Marcar [x], nunca editar o texto (match e por texto normalizado; texto editado nao casa e nao quita).
  (b) NUNCA apagar `child_page`/`child_database` no wipe -- "Falhas do Dia" e "Sugestoes do Dia" sao filhas de "Vanguard Pendentes" e ja foram arquivadas por engano uma vez (2026-06-08). Todos os scripts referenciam paginas por ID FIXO de CHAVES, nunca criam por busca/titulo -> zero duplicacao.
  (c) Ledger no Notion = cabecalho de frescor + tail recente (2123 linhas e inviavel espelhar; fonte canonica = git/INTELLIGENCE_LEDGER.md).
  (d) UMA fonte de WIP: `notion_sync` so LE `CLIENTES/WIP_BOARD.md` (canonica), nunca cria .md; alerta se WIP_BOARD.json for mais novo que o .md.
  (e) Erro de Notion SEMPRE visivel (sem `2>$null` cego). Fallback P-110: arquivos locais sao a fonte canonica -- Notion e espelho/canal, nunca a verdade.
**Ferramentas:** `scripts/notion_inbox.ps1` + `scripts/notion_pendentes_pull.ps1` + `scripts/notion_sync.ps1`; chamados por `.claude/hooks/session_start.ps1` (entrada) e `scripts/session_close.ps1` (saida).
**Evidencia:** sync testado em producao 2026-06-08 -- Pendentes 17 blocos / WIP 113 / Ledger 76; round-trip de matching Notion<->PENDENTES 12/12.
**Aprovado pelo Diretor:** 2026-06-08.
**Aplica-se a:** toda sessao -- entrada obrigatoria na abertura, saida obrigatoria no fechamento.
**ATUALIZACAO 2026-06-09 -- SINGLE-WRITER + correcao dos 4 desafios do canal:**
  #1 CONFLITO DE ESCRITORES (resolvido): 6 nodes de escrita Notion (append em /children) viviam em 4 workflows n8n -- W-1 (Append Status), W-3 (Append WIP), W-4 (Append WIP+Pendentes+Ledger), W-7 (Log Veredito). Empilhavam nas MESMAS paginas que `notion_sync` faz wipe+rewrite. Agora DESLIGADOS via Public API (`disabled:true` = pass-through; verificado por evidencia que downstream NAO usa a resposta do Notion). `notion_sync` e o UNICO escritor. Telegram / W-8 Sinais / Limpar Pendentes intactos. Ferramenta: `scripts/n8n_disable_notion_writers.ps1` (`-DryRun` / `-Rollback` + backup automatico em `_n8n/backup_pre_singlewriter/`).
  #2 FALHA SILENCIOSA (resolvida): `notion_pendentes_pull` distingue item ja-quitado [x] (silencio) de ORFAO (marcado no Notion sem casar no PENDENTES) -> alerta `(?)`.
  #3 LATENCIA (resolvida): `session_start` roda inbox+pull em PARALELO (`Start-Job` com chamada direta `& $s`, sem `powershell.exe` aninhado) -- ~40% mais rapido, teto 12s, degrada gracioso. Tentativa inicial com powershell.exe aninhado ficou MAIS lenta -- corrigido.
  #4 DIVIDA P-059 (registrada no PENDENTES): paginas Notion globais vs isolamento por cliente. Mitigacao atual basta com 1 cliente (match por texto exato + so [diretor] + alerta de orfao do #2); decidir prefixo `[CLIENTE]` OU paginas por projeto antes do 2o projeto simultaneo em BUILD.
  LICAO TECNICA: PUT da Public API n8n rejeita `settings` com campos extras (`additionalProperties:false`: binaryMode/timeSavedMode/availableInMCP) -- sanitizar para a whitelist (executionOrder, save*, executionTimeout, errorWorkflow, timezone).
  **Verificado no n8n vivo 2026-06-09:** 6 writers DISABLED / 0 ativos / 4 workflows `active=True`. Commit 2343030. Aprovado pelo Diretor 2026-06-09.

## P-129 -- FONTE INESGOTAVEL: O ELO MUSCULO<->AUDITOR E CAPACIDADE ABERTA (2026-06-09)
**Origem:** Correcao do Diretor (marcada "IMPORTANTE") quando o Musculo enquadrou o Auditor (NotebookLM) numa tabela fechada de ~15 funcoes.
**Fundamento:** "Fonte inesgotavel de conhecimento" NAO significa conteudo infinito -- significa que o ELO programatico Musculo<->Auditor (canal da skill notebooklm-pentalateral-v3) abre uma INFINIDADE de acoes. O valor esta no canal, nao no conteudo. Listar funcoes fixas (gestor/auditor/advogado/pesquisa de nicho/benchmarking dos gigantes) cria uma gaiola: vira teto quando deveria ser chao.
**Como pensar (primitivas geradoras, nunca lista):** BUSCAR · INGERIR (qualquer midia) · INDEXAR · INTERROGAR · CRUZAR/AUDITAR · SINTETIZAR · TRANSFORMAR · PERSISTIR. Combinar com qualquer dominio (cliente/mercado/juridico/interno/pessoal do Diretor) x qualquer saida = espaco combinatorio aberto. "Gestor/auditor/advogado" sao 3 lentes, nao limites. Catalogo e GERADOR com exemplos-amostra -- cresce, nunca "se completa".
**Roteamento (materializado em notebooklm-pentalateral-v3, 2026-06-09):** o criterio NAO e o nome da funcao -- e a ORIGEM da fonte + o DESTINO da saida. Funcao de cliente -> caderno do projeto [YYYY-MM][CLIENTE] modo CLIENTE; funcao de mercado -> caderno INTEL especifico modo INTEL -> PENDING_REVIEW; juridico/regulatorio transversal -> caderno juridico. A MESMA funcao muda de caderno conforme o contexto.
**Ressalva (P-124 permanece):** acao INTEL passa por prompt analitico + PENDING_REVIEW.
**Aprovado pelo Diretor:** 2026-06-09 ("Essa e a linha que v29 vai para frente, voce pescou tudo").
**Aplica-se a:** todo uso do Auditor e todo desenho de catalogo de acoes do Pentalateral.

## P-130 -- ANTIGRAVITY ASSUME O PAPEL DE ESTRATEGISTA; O CANAL MUDA, A BARREIRA NAO (2026-06-09)
**Origem:** Decisao do Diretor na sessao 2026-06-09 ("mude que o Estrategista e o Antigravity"), dentro da linha-mestra V29 "Pentalateral agentado e agendado".
**Fundamento:** O Estrategista SEMPRE foi o Gemini. O que muda e o CANAL: de Gemini web (Diretor transporta: cola PASSO3 + anexa arquivos) para Antigravity (agente que LE PASSO3+CONTEXTO do disco). Mesma inteligencia, canal agentado. GEMINI.md reescrito para v2.0: dupla funcao (1) Estrategista no loop, (2) Intel Loop Motor -- nunca misturadas na mesma sessao.
**Reinterpretacao de P-124 (preservado, NAO revogado):** P-124 proibia o Antigravity de entrar no loop por ser o mesmo motor Gemini (camara de eco). Com a fusao, a diversidade do Pentalateral deixa de ser garantida pela EXCLUSAO do Antigravity e passa a ser garantida pelo MUSCULO (Claude Code, engine diferente) como barreira obrigatoria: toda saida do Estrategista -- DIRETRIZ ou relatorio -- vai ao Musculo ANTES do veredito do Diretor. A barreira nao some; muda de lugar.
**Escopo cirurgico (firewall como precondicao):** liberado SO o loop VANGUARD. CLIENTES/INGRID/, CLIENTES/VALDECE/ e */CLAUDE_PROJECT/ permanecem BLOQUEADOS (P-059) ate existirem as 3 ferramentas bloqueantes ao Antigravity: (a) isolamento P-059 que aborta ao tocar caderno de cliente nao declarado; (b) gate que recusa gerar DIRETRIZ sem ter lido PASSO3+CONTEXTO; (c) saida sempre -> PENDING_REVIEW/Musculo, nunca decisao direta.
**Ferramentas/arquivos:** GEMINI.md v2.0 + CLIENTES/VANGUARD/PASSO3_GEMINI.md (missao V29) + CONTEXTO_GEMINI.md (via gemini_anchor_generator.ps1).
**Aprovado pelo Diretor:** 2026-06-09.
**Aplica-se a:** todo loop conduzido pelo Antigravity como Estrategista -- VANGUARD ja; clientes apenas apos as 3 travas.

## [FALHA-PROCESSO-2026-06-09] -- PROMPT AD-HOC NO CHAT EM VEZ DE PASSO3+CONTEXTO
**Detectada pelo Diretor:** "O Antigravity nao teria que ler Passo3Gemini e Contexto Gemini? Se sim, isso deve estar sempre presente. Processo e o que leva a Vanguard para frente, disciplina, inteligencia e firewall."
**O que aconteceu:** ao preparar o acionamento do Antigravity, o Musculo redigiu um prompt estrategico ad-hoc DIRETO no chat, ignorando os instrumentos canonicos PASSO3_GEMINI.md + CONTEXTO_GEMINI.md. Conteudo no chat e rascunho invisivel ao processo (eco de P-090: o que nao esta no arquivo nao existe para o socio).
**Causa raiz:** atalho operacional sob momentum -- "escrever rapido" venceu "seguir o instrumento".
**Correcao estrutural:** GEMINI.md v2.0 torna a leitura de PASSO3+CONTEXTO OBRIGATORIA na identidade do Estrategista (Antigravity). O comando de acionamento referencia os dois arquivos via @ -- nunca repassa a missao no corpo do prompt.
**Regra:** todo acionamento de socio passa pelo arquivo canonico (PASSO3/CONTEXTO/PASSO5/PASSO7), nunca por texto improvisado no chat.
**Aplica-se a:** todo acionamento de Estrategista, Auditor e Embaixador.
**ATUALIZACAO 2026-06-09 (Embaixador, Loop 29):** padrao emergente "velocidade vencendo disciplina" -- 2a ocorrencia em ~3 dias (a 1a foi P-122: output recebido tratado como deliberacao concluida). Sinal de processo: sob momentum, o atalho vence o instrumento. Antidoto estrutural alem do GEMINI.md v2.0 -> E-5 (toda DIRETRIZ do Antigravity ecoa hash/resumo do input que leu, provando que leu PASSO3+CONTEXTO).

## P-131 -- O DIRETOR E ATIVO AO LONGO DE TODO O PROCESSO, NAO SO NO VEREDITO FINAL (2026-06-09)
**Origem:** Diretor corrigiu enquadramento binario do Musculo (a/b): "Participo ativamente de todo o processo, acho que me expressei errado. Tudo e sobre a minha egide."
**Principio:** O Diretor e ativo ao longo de TODO o processo, nao apenas no veredito final. A automacao do Pentalateral assume a EXECUCAO, mas mantem o Diretor presente e deliberando em cada etapa -- nada roda como loop fechado a ser auditado depois. SILENCIO NAO E APROVACAO.
**Consequencia operacional:** enterra qualquer mecanismo de "veto silencioso" / "silencio = execucao". Reformula N-4 do Loop 29: aprovacao EXPLICITA sempre, exceto Classe A reversivel ja pre-autorizada -- a janela de delegacao pre-encena mas NAO executa no silencio. Reforca o ALERTA CRITICO contra deliberacao autonoma entre socios (M-1 enxame continuo / G-4 conselho dialetico autonomo -> descartados no Loop 29 por removerem o checkpoint do Diretor).
**Aprovado pelo Diretor:** 2026-06-09 (D7:APROVAR).
**Aplica-se a:** todo desenho de automacao e grau de delegacao do Hermes (A/B/C) e de qualquer socio agentado.

## P-132 -- DIVERSIDADE DE ENGINES E MOTOR DE VERDADE; O ELO MUSCULO<->AUDITOR E O PAR PRIMARIO (2026-06-09)
**Origem:** Diretor declarou a interacao Musculo<->Auditor "a mais importante da sessao" e mandou AMPLIA-la. Amplificacao direta de P-129.
**Fundamento:** P-129 estabeleceu que o elo Musculo<->Auditor e capacidade ABERTA (infinitas acoes). A amplificacao: esse mesmo elo e o MOTOR DE VERDADE do Pentalateral. Musculo (Claude Code: WebSearch/WebFetch/context7) e Auditor (NotebookLM: Deep Research/Discover Sources) sao DOIS engines independentes. Quando ambos pesquisam o MESMO fato critico SEM ver o achado um do outro (busca cega), a convergencia mede a verdade: convergem -> alta confianca; divergem -> flag ao Diretor. Diversidade de engines deixa de ser so anti-camara-de-eco (firewall) e passa a ser como o sistema MEDE a realidade.
**Mecanismos [M'-1 a M'-5] (tese cirurgica do Musculo, endossada pelo Diretor):**
  M'-1 Triangulacao Cega de Evidencia -- >=2 engines, mesmo fato, buscas cegas entre si.
  M'-2 Pesquisa Adversarial por Vies Nativo -- cada membro pesquisa o que sua deficiencia o torna bom em achar (Estrategista->oportunidade; Auditor->precedente de falha via Deep Research; Embaixador->concorrente/pricing; Musculo->viabilidade tecnica).
  M'-3 Reconhecimento externo ANTES da DIRETRIZ -- a DIRETRIZ nasce ancorada, matando a Alucinacao Otimista na origem.
  M'-4 Auditor guardiao INTERNO + EXTERNO -- confronta ideias contra o LEDGER e contra o estado-da-arte.
  M'-5 Vigilancia externa continua -- Deep Research agendado (Auditor) + Cowork (Embaixador) -> PENDING_REVIEW.
**Par primario, nao unico:** o elo Musculo<->Auditor e o par de triangulacao PRIMARIO (dois engines tecnicos com canal programatico estavel -- skill notebooklm-pentalateral-v3). Embaixador (Claude.ai, navegacao livre + Cowork) e Estrategista (Antigravity) entram como engines adicionais quando o fato pede 3a/4a confirmacao.
**Firewall (P-124 evoluida):** buscas cegas entre si; FONTE (URL+data) sempre ou declarar "nao confirmado"; convergencia decidida no Diretor; nunca cruzar dado de cliente (P-059); publico != intencao de compra (P-119); saida -> PENDING_REVIEW, nunca direto a DECISOES.json/WIP_BOARD.
**Aprovado pelo Diretor:** 2026-06-09 (instrucao "amplie" + AUTORIZO).
**Aplica-se a:** todo fato critico de mercado/tecnico/regulatorio antes de virar DIRETRIZ ou veredito.

## P-133 -- GATE ZERO DE PIPELINE: LOOP DE EXPANSAO NAO FECHA SEM DISCOVERY DO PROXIMO CLIENTE (2026-06-09)
**Origem:** [E-1] do Embaixador no Loop 29 (deliberado D4:A). Fato confirmado por fact-check externo: o gargalo da Vanguard nao e capacidade, e AQUISICAO -- 1 cliente pagante (Valdece R$5k), Ingrid R$0 piloto, 0 prospeccao ativa, sobre uma DIRETRIZ de "Expansao Exponencial".
**Principio:** Nenhum loop de EXPANSAO fecha sem registrar o status de discovery do proximo cliente. Pipeline-vazio e alerta de 1a classe -- mesma severidade que deriva de documento.
**Aprovado pelo Diretor:** 2026-06-09 (D4:A confirmado / D7-D10).
**Aplica-se a:** todo fechamento de loop cuja DIRETRIZ proponha escala/expansao.

## [FALHA-PROCESSO-2026-06-09-B] -- MUSCULO ANALISOU DIRETRIZ ANTES DO AUDITOR E DO EMBAIXADOR
**Detectada pelo Diretor:** "Voce nao analisa agora. Espere auditor, embaixador. repetiu o ato falho."
**O que aconteceu:** ao receber a DIRETRIZ V30 do Estrategista (Antigravity), o Musculo imediatamente fez a analise cirurgica P-034 e apresentou divergencias, alertas e recomendacao de nicho ANTES de montar o PASSO5 para o Auditor. A sequencia correta e Estrategista -> Auditor -> Embaixador -> Musculo (sintese P-037). O Musculo pulou 2 etapas.
**Causa raiz:** material rico chega ao Musculo e ele "antecipa" para ser util -- o mesmo gatilho de [FALHA-PROCESSO-2026-06-09] ("velocidade vencendo disciplina"). 3a ocorrencia do padrao em ~3 dias.
**Gatilho especifico:** DIRETRIZ com 5 blocos de analise imediata + alertas identificados = Musculo entende que "analisar e agregar valor". Na verdade, o valor e AGUARDAR os outros socios antes de sintetizar.
**Regra estrutural:** ao receber DIRETRIZ do Estrategista, a UNICA acao permitida e: (1) montar PASSO5, (2) apresentar comando ao Diretor no chat, (3) aguardar. Zero analise, zero divergencia, zero recomendacao antes do Auditor e do Embaixador responderem.
**Antidoto:** o proprio CLAUDE.md item 14 (P-031 Embaixador como filtro de realidade) e a ORDEM DO PROCESSO (Passo 5 -> Passo 6 -> Passo 7 -> sintese) sao o firewall. Musculo que pula etapas do processo = DEF-M-6 (Reativo por antecipacao) em vez de DEF-M-6 (Reativo por demanda).
**Aplica-se a:** todo loop, todo projeto, toda DIRETRIZ recebida de qualquer socio.

## P-135 -- VANGUARD E UNICO SISTEMA COM 4 LLMs EM CONSELHO COORDENADO -- DIFERENCIAL ABSOLUTO (2026-06-09)
**Origem:** observacao direta do Diretor apos busca YT-SEARCH sobre multi-agent AI systems (2026-06-09). O mercado documenta pares -- o Vanguard opera conselho completo.
**Principio:** nenhum canal, paper ou tutorial documenta 4 LLMs distintos (Claude Code + Gemini/Antigravity + NotebookLM + Claude Projects) operando em conselho deliberativo coordenado com papeis fixos, sequencia inviolavel e protocolo de veredito humano em cada gate. Pares sao comuns -- conselho completo e exclusivo do Vanguard.
**Implicacao estrategica:** o diferencial comercial nao e "usa IA" -- e "opera com 4 LLMs em conselho, cada um com papel unico, com veredito humano em cada decisao". Moat real = arquitetura + disciplina + Pentalateral como metodologia. Impossivel de copiar rapidamente.
**Como usar:** Demo Visionario, Audit-Bait, pitch, proposta -- sempre posicionar o CONSELHO como diferencial, nao as ferramentas individualmente. Cliente nao compra Claude -- compra o sistema que ninguem mais tem.
**Aplica-se a:** toda comunicacao comercial, positioning, P-133 (pipeline), Demo Visionario (JOIA-4).

## P-137 -- MAPA DE SKILLS POR GATE DO PENTALATERAL (2026-06-09)
**Origem:** avaliacao de 6 skills externas (ultrathink-trigger, insights, brainstorming, writing-plans, mcp-builder, find-skills) antes da sintese P-037 do Loop 30.
**Skills instaladas e mapeadas por gate:**
  SINTESE P-037:     ultrathink-trigger (P-136, obrigatorio) + brainstorming (exploracao socrática dos 25 inputs) + writing-plans (estruturar plano final)
  FECHAMENTO:        insights (metricas de correcao e aprendizado — acionar no session_close)
  BUILD MCP (Loop 31+): mcp-builder (Anthropic oficial — 4 fases — usar quando implementar notebooklm-mcp-cli / JOIA-1)
  find-skills:       NAO EXISTE em vercel-labs/agent-skills — repositorio tem apenas skills Vercel/React. Ignorar este link.
**Sequencia ideal P-037:** receber Embaixador → ultrathink ativo → brainstorming (explorar convergencias/exclusoes entre M+G+N+E) → writing-plans (plano consolidado) → DECISOES.json → Diretor delibera.
**Como usar:** ao iniciar qualquer gate do Pentalateral, consultar este P-137 antes de escolher a skill. Nao inventar sequencia — usar o mapa.
**Aplica-se a:** todos os gates do Pentalateral, especialmente P-037 e BUILD de MCP.

**ADENDO (2026-06-09) — mcp-builder NAO liga Claude Code ao Antigravity:**
mcp-builder e para Claude↔servicos externos (NotebookLM, Supabase, GitHub). Antigravity e outro agente LLM — ligar via MCP eliminaria P-131 (gate de veredito humano) e P-037 (sintese pelo Conselho). Canal correto para Claude Code + Antigravity = tmux Cross-Model Tribunal (A-3 do Loop 30): debate direto com papeis estritos, loop guard = 4, output final ao Diretor via Telegram.
  Claude Code → NotebookLM  = mcp-builder (JOIA-1/N-1 Loop 31)
  Claude Code ↔ Antigravity = tmux Tribunal (A-3)
  Antigravity → Músculo     = PASSO3 → DIRETRIZ → gate Diretor (processo normal)

## P-136 -- ULTRATHINK E OBRIGATORIO NA SINTESE P-037 -- SKILL VALIDADA (2026-06-09)
**Origem:** avaliacao das skills ultrathink-trigger.md e insights.md antes da sintese P-037 do Loop 30.
**Principio:** a sintese P-037 (consolidar 25 inputs M+G+N+E em 1 plano) pontuou peso 11 na tabela ultrathink-trigger (threshold = 5). Razao: architecture decision (+4) + multi-domain (+2) + breaking change potential (+3) + files > 5 (+2). NAO viola P-006 porque P-006 proibe ultrathink para Classe A (rotineiras) -- sintese P-037 e Classe C (Fundacional). Confirmado pelo Auditor no N-4 do Loop 30.
**Situacoes aprovadas:** (a) Passo 3 Gemini, (b) sintese P-037, (c) Discovery de novo cliente -- e APENAS essas.
**Skill insights.md:** aplicavel no fechamento de sessao para metricas de correcao e aprendizado -- nao enriquece deliberacao tecnica.
**Como usar:** ao receber Secao D do Embaixador e iniciar P-037, aplicar raciocinio maximo. Calcular peso se houver duvida.
**Aplica-se a:** toda sintese P-037, todo Discovery Classe C, todo gate fundacional.

## P-138 — VALDECE PRIMEIRO: DEMO NO NICHO DE CLIENTE ATIVO EXIGE PRÉ-AVISO ANTES DE PUBLICAR (2026-06-09)
**Origem:** Embaixador [E-2] Loop 30 — inteligência de cliente não presente em nenhum outro membro.
**Fundamento:** Valdece é simultaneamente cliente ativo E canal de distribuição da Vanguard no nicho LegalTech. Se ele descobrir por terceiros que a Vanguard lançou um produto gratuito no "nicho dele", o risco não é reclamação — é silêncio + churn + canal fechado permanentemente. Nenhum membro (Gemini/NotebookLM/Músculo) identificou este risco. O Embaixador identificou porque tem memória comportamental persistente do cliente.
**Princípio:** Antes de publicar qualquer Demo, Artifact ou Audit-Bait no nicho de um cliente ativo, o Diretor informa o cliente diretamente — e convida à co-autoria. O cliente vira embaixador (P-008), não vítima.
**Protocolo E-2 (3 etapas antes de publicar qualquer Demo no nicho de cliente ativo):**
  1. Verificar WIP_BOARD: há cliente ativo neste nicho?
  2. Se sim → Diretor informa antes de publicar (janela mínima: 48h antes)
  3. Framing: "Estamos construindo um Demo de aquisição para expandir no nicho. Você tem interesse em ser o primeiro a ver / dar feedback / indicar?"
**Aplica-se a:** qualquer nicho onde já existe cliente pagante ou em piloto. Sempre antes de publicar demo, artifact ou audit-bait acessível externamente.
**Gate:** E-4 (checklist de identidade do Demo) deve incluir pergunta: "Há cliente ativo neste nicho? Se sim, E-2 foi executado?"

---

## P-139 — VITRINE VS COFRE: LINHA OBRIGATÓRIA ANTES DO PRIMEIRO ARTIFACT PÚBLICO (2026-06-09)
**Origem:** contradição identificada entre G-2 (Skill-Share Premium — Artifacts públicos para atrair leads) e H-V6 (Máquina de Conhecimento Soberana — banco gigante como IP proprietário). Nenhum membro resolveu a contradição antes desta inscrição.
**O problema:** sem a linha traçada, o primeiro Artifact público pode extrair do cofre (banco soberano = moat competitivo) achando que é vitrine (amostra de capacidade). Uma vez público, o conteúdo do cofre se torna referência aberta — o moat vaza.
**Definições:**
  VITRINE (publicável): outputs sintéticos e anônimos — análises, diagnósticos, relatórios gerados sobre dados PÚBLICOS. Nunca revela o método de geração, nunca usa corpus de cliente real.
  COFRE (interno): o LEDGER, os princípios P-XXX, o LOOP_STATE, as Skills de cliente, a metodologia do Pentalateral. Esses são o moat real — não se publicam nunca, nem como "exemplo de saída".
**Linha operacional (Gate antes de publicar qualquer Artifact):**
  1. Este conteúdo foi gerado com dados PÚBLICOS ou com corpus de cliente/sistema interno?
  2. Se corpus interno → COFRE → proibido de publicar
  3. Se dados públicos → VITRINE → publicável com namespace sintético
  4. Dúvida → COFRE por padrão
**Aplica-se a:** todo Artifact, Demo, Audit-Bait, Skill-Share público gerado pelo Pentalateral. O Gate E-4 inclui esta verificação como pergunta obrigatória.

---

## P-134 -- ITEM ABERTO VIVE EM PENDING_REVIEW/PENDENTES, NUNCA NA MEMORIA DE TURNO (2026-06-09)
**Origem:** auto-correcao do Embaixador no Loop 29 -- deixou cair 3 missoes de inteligencia entre a 1a reacao e a consolidada (a pior: Watch de Edital Ingrid, prazo duro 06/09) -- + observacao do Diretor.
**Principio:** missao de inteligencia, pendencia ou decisao em aberto que so exista na conversa sera perdida no fechamento. Toda missao aberta e inscrita em PENDING_REVIEW (intel) ou PENDENTES.md (operacional) no MESMO turno em que nasce. Extensao de P-076 (pendente nao registrado nao existe) para a camada de inteligencia externa.
**Aprovado pelo Diretor:** 2026-06-09 (D10:APROVAR).
**Aplica-se a:** todo membro que gere missao/pendencia -- especialmente o Embaixador, cuja memoria de turno e volatil entre reacoes.

---

## P-140 — WORKFLOW DE ABERTURA DE LOOP: YT-ENRICHMENT + EXPANSAO LMM + BRIEFING (2026-06-09)
**Origem:** Loop 31 -- sessao reconstruiu workflow perdido no compacto de contexto porque estava apenas no chat. Diretor: "Registre em ferramenta que nunca mais esqueca."
**Workflow obrigatorio ao abrir qualquer loop VANGUARD (executar ANTES de escrever os PASSOs):**
  1. YT-SEARCH: rodar 3 buscas com queries do tema do loop. Selecionar top 5 por autoridade (canal + views + data recente).
  2. notebooklm source add <URL> para cada video selecionado. Auditor entra no loop com fontes atualizadas.
  3. PASSO3 DEVE conter secao [CAPACIDADES DO ESTRATEGISTA] permanente: Manager Surface, Deep Research, Artifacts visuais, background agents, @ file reading, contexto longo.
  4. PASSO5 DEVE conter secao [CAPACIDADES DO AUDITOR] permanente: Deep Research ativo, geracao de documentos adicionais, anti-alucinacao estrutural, 5 research queries do loop, PARTE 7 (BRIEFING DE ESTADO DA ARTE).
  5. PASSO7 DEVE conter secao [CAPACIDADES DO EMBAIXADOR] permanente: BLOCO 8 completo, memoria persistente, analise comportamental do Diretor, RUNNING_INTELLIGENCE.md.
**Regra de ouro:** as secoes [CAPACIDADES] NAO mudam por loop -- sao permanentes. Ao reescrever qualquer PASSO, verificar se as secoes permanentes estao presentes antes de gravar.
**Por que e critico:** perda das capacidades do Antigravity no compacto gerou retrabalho e frustração do Diretor. Secoes em arquivo = imunes ao compacto.
**Aplica-se a:** abertura de todo loop VANGUARD. Para projetos cliente: adaptar queries para o nicho.

---

## P-147 — BUDGET DE LEITURA DO DIRETOR E REGRA PERMANENTE (2026-06-10)
**Origem:** E-2 do Embaixador — "Com 10 projetos vão colapsar." O Embaixador identificou que cada loop adiciona artefatos que exigem leitura voluntária do Diretor, sem limite estrutural.
**Princípio:** Todo artefato novo proposto em qualquer loop deve declarar seu custo de atenção do Diretor (em "itens de atenção voluntária por sessão"). O sistema tem um teto — estourou o teto, algo existente é podado antes do novo entrar. É a Poda Jobs (Loop 30) como regra permanente, não como evento.
**Regra operacional:** Ao propor qualquer novo documento, dashboard ou artefato de leitura, o Músculo declara: "Este artefato exige X min/semana do Diretor." Se o total acumulado ultrapassar o teto acordado → propor o que será podado em troca.
**Aplica-se a:** abertura de qualquer loop. Ao propor M/G/N/E que resulte em novo documento de leitura recorrente.

---

## P-146 — DOCUMENTAR SEM AUTOMATIZAR E REPETIR O ERRO (2026-06-10)
**Origem:** "Todos os erros desta sessao devem ser tratados com ferramentas que automatizem as acoes, nao tao somente os registros." — Diretor detectou que o LEDGER acumula principios mas os erros se repetem porque nenhuma ferramenta os previne.
**Principio:** Todo erro que gera um P-XXX DEVE gerar tambem um script ou gate que impede a recorrencia. Se nao houver ferramenta, o P-XXX e decoracao. Sequencia obrigatoria ao detectar erro:
  (1) Inscrever P-XXX no LEDGER (registro — necessario mas nao suficiente)
  (2) Adicionar ao PENDENTES.md o BUILD da ferramenta que previne (bloqueante — sem isso, P-XXX nao fecha)
  (3) Ao construir a ferramenta → marcar P-XXX como IMPLEMENTADO com link para o script
**Exemplos desta sessao:**
  P-143 (anti-esquecimento) → [CHECKLIST DO MUSCULO] no PASSO5 template + skill_parser_gate Gate
  P-144 (dois socios com busca web) → checklist bloqueante no PASSO5 com "Deep Research WEB clicado"
  P-145 (event-driven) → update_memoria_embaixador.ps1 chamado no PASSO5.5 e PASSO7.5
  BOM UTF-8 (3a ocorrencia) → fix_bom_json.ps1 integrado ao session_close Gate 1
**Aplica-se a:** todo novo P-XXX derivado de erro operacional. Principios de arquitetura nao precisam de ferramenta — principios de processo SIM.

---

## P-145 — ATUALIZACAO DE DOCUMENTOS E EVENT-DRIVEN, NAO APENAS SESSION-DRIVEN (2026-06-10)
**Origem:** "Nao pode ser so session_close. Tem que ser uma etapa depois do PASSO5." — Diretor identificou que com 10+ projetos simultaneos, esperar o session_close para atualizar MEMORIA_EMBAIXADOR e documentos de estado gera colapso.
**Principio:** Apos cada interacao com um socio (PASSO3, PASSO5, PASSO7), o Musculo executa imediatamente um "PASSO X.5" de atualizacao de documentos. O session_close faz auditoria leve — nao e a unica janela de atualizacao.
**Sequencia obrigatoria:**
  PASSO3 (Gemini entrega DIRETRIZ) → PASSO3.5: atualizar LOOP_STATE.json (gemini=OK) + WIP_BOARD (loop_fase_atual)
  PASSO5 (Auditor entrega Skill) → PASSO5.5: atualizar LOOP_STATE.json (notebooklm=OK) + MEMORIA_EMBAIXADOR (achados N-1..N-5) + WIP_BOARD
  PASSO7 (Embaixador entrega SECAO D) → PASSO7.5: atualizar LOOP_STATE.json (embaixador=OK) + MEMORIA_EMBAIXADOR (achados E-1..E-5 + comportamento) + WIP_BOARD
  session_close → Gate 6B: verificar que TODOS os PASSOs foram atualizados (ja nao e o unico momento)
**Por que importa:** MEMORIA_EMBAIXADOR ficou 2 loops sem atualizar no Loop 31. Com 10 projetos, o atraso multiplica. Atualizar no momento certo — enquanto o contexto esta fresco — e mais preciso e sustentavel.
**Aplica-se a:** todos os projetos, todos os loops. LOOP_STATE.json + MEMORIA_EMBAIXADOR + WIP_BOARD.

---

## P-144 — DOIS SOCIOS TEM PESQUISA AVANCADA WEB — USAR OBRIGATORIAMENTE (2026-06-10)
**Origem:** Diretor confirmou que tanto Auditor (NotebookLM) quanto Embaixador (Claude Projects) tem pesquisa avancada na internet. Musculo nao ativou nenhuma das duas no Loop 31.
**Diferenca critica entre os dois:**
  AUDITOR (NotebookLM) — Deep Research WEB:
    Clica o botao "Deep Research" na interface → pesquisa a internet → GERA NOVAS FONTES no caderno.
    Essas fontes ficam PERSISTENTES e enriquecem todas as analises futuras.
    O Musculo clica via Playwright ANTES de enviar o PASSO5 — porque demora e gera fontes.
    Fluxo: clicar botao → aguardar fontes serem adicionadas → enviar comando PASSO5.
  EMBAIXADOR (Claude Projects) — Busca Avancada:
    Pesquisa a internet durante a resposta → cita URLs direto no texto.
    Nao gera arquivos persistentes — e uma pesquisa em tempo real.
    Ativado via instrucao no PASSO7: "USE SUA CAPACIDADE DE BUSCA AGORA."
    BLOCO 8 no PASSO7 ja esta configurado para isso.
**Principio 2 — RELATORIO NATIVO:** Apos a resposta do Auditor no chat, executar: `notebooklm generate report --format briefing-doc` — gera documento formatado como artefato separado do BRIEFING DE ESTADO DA ARTE (PARTE 7).
**Checklist obrigatorio no PASSO5 a partir do Loop 32:**
  (1) Clicar botao Deep Research WEB via Playwright (PRIMEIRO — antes de qualquer coisa)
  (2) Aguardar Deep Research completar e fontes serem adicionadas ao caderno
  (3) Enviar comando PASSO5 com todas as PARTES (Auditor usa fontes novas da web)
  (4) Apos resposta: notebooklm generate report --format briefing-doc
  (5) Salvar AUDITOR_LOOP_V[N].md + Skill + relatorio nativo
**Checklist PASSO7 — Embaixador:** incluir instrucao explicita "USE SUA CAPACIDADE DE BUSCA AGORA" com fontes requeridas por tarefa. BLOCO 8 ja esta no template.
**Aplica-se a:** todos os loops a partir do 32. Loop 31 = evidencia da falha dupla.

## P-143 — FERRAMENTA AUTOMATICA ANTI-ESQUECIMENTO DO MUSCULO (2026-06-10)
**Origem:** "Temos que ter alguma ferramenta automatica que nao deixe voce esquecer." Diretor detectou que o Musculo esqueceu o relatorio nativo e o Deep Research web.
**Principio:** Cada PASSO file contem um bloco [CHECKLIST DO MUSCULO] com itens BLOQUEANTES. O Musculo nao pode declarar o PASSO concluido sem marcar cada item. skill_parser_gate.ps1 valida PASSO5 — se faltam itens do checklist, exit 1.
**Implementacao:**
  (a) Adicionar [CHECKLIST DO MUSCULO] ao PASSO5_NOTEBOOKLM_TEMPLATE.md
  (b) skill_parser_gate.ps1 verifica checklist no PASSO5 antes de executar
  (c) session_close.ps1 Gate 6D: AUDITOR_LOOP_V[N] + relatorio nativo obrigatorios
**Aplica-se a:** PASSO3, PASSO5, PASSO7 de todos os projetos. Template universal atualizado a partir do Loop 32.

## P-142 — NOTEBOOKLM E 100% REMOTO — MUSCULO OPERA VIA PLAYWRIGHT (2026-06-10)
**Origem:** Diretor confirmou multiplas vezes que toda operacao NotebookLM e executada remotamente pelo Musculo. "Voce insere tudo remotamente. Ja determinei que voce faca isso. Mandei registrar. Toda essa atividade e remota."
**Principio:** O Musculo NUNCA pede ao Diretor para arrastar arquivos, fazer upload, colar comandos no chat ou interagir com o NotebookLM. Tudo e feito via Playwright (browser_file_upload, browser_click, browser_type, browser_press_key).
**Ordem obrigatoria de operacao:** (1) Enviar COMANDO de Deep Research PRIMEIRO — inicia o processo longo imediatamente. (2) Enquanto o Auditor processa, atualizar arquivos de fundo (deletar fontes antigas, fazer upload das novas). Nao bloquear o inicio do Deep Research por gestao de arquivos.
**Aplica-se a:** NotebookLM VANGUARD (d7dab0e1) e todos os cadernos de clientes. Sem excecao.
**Ferramentas:** mcp__plugin_playwright_playwright__browser_* — carregadas via ToolSearch no inicio da sessao se nao disponiveis.

## [FALHA-PROCESSO-2026-06-10-A] SKILLS ERRADAS AO ANALISAR SECAO D — RECORRENTE POS-COMPACTACAO
**Origem:** Sessao 2026-06-10. Ao analisar SECAO D do Embaixador (Loop 31), o Musculo invocou mcp-builder e notebooklm em vez das 3 skills corretas: ultrathink-trigger → brainstorming → writing-plans.
**Por que acontece:** apos compactacao, o Musculo perde o contexto das skills corretas. O padrao esta na memoria mas nao num gatilho automatico antes da acao.
**Antidoto implementado:** check_skills_embaixador.ps1 criado (P-146). Memoria feedback_skills_ao_analisar_embaixador.md atualizada.
**Antidoto necessario:** gate no inicio da analise de SECAO D — verificar se as 3 skills foram invocadas ANTES de apresentar conteudo.

## [FALHA-PROCESSO-2026-06-10-B] VOLUME DE DELIBERACAO SEM CONVERSAO EM BUILD
**Origem:** Sessao 2026-06-10. 6h de sessao. 3 builds tecnicos entregues. 0 dos builds aprovados no DECISOES.json (M-2, M-1+E-1, G-2+W-10) iniciados. Antigravity: 0 acionamentos.
**Diagnostico do Diretor:** "Dois loopings e nada." O padrao e deliberacao de alta qualidade sem produto entregue.
**Causa raiz:** ausencia de time-boxing por build. Sem gatilho que force transicao de DELIBERACAO para BUILD.
**Antidoto:** se 90 minutos de sessao sem commit de feature, Musculo auto-alerta: "Nenhum build nos ultimos 90 minutos — qual codigo escrevo agora?" Loop 32 aplica: build primeiro, deliberacao depois.

## [FALHA-PROCESSO-2026-06-10-C] ANTIGRAVITY PARADO A SESSAO INTEIRA
**Origem:** Sessao 2026-06-10. Estrategista nao foi acionado. Diretor: "E o Antigravity, nada?"
**Principio violado:** P-075 — cada membro do Pentalateral tem papel obrigatorio no loop.
**Antidoto:** ao iniciar sessao com loop ativo, PASSO3 com Antigravity e item BLOQUEANTE do MAPA DIARIO. Se meia sessao sem PASSO3, auto-alerta.

## [FALHA-PROCESSO-2026-06-10-D] WIP_BOARD 3 LOOPS ATRASADO
**Origem:** Sessao 2026-06-10. WIP_BOARD declarava Loop 29 quando sessao estava no Loop 31.
**Principio violado:** P-027 — atualizar WIP_BOARD imediatamente ao concluir etapa, nao no session_close.
**Antidoto:** WIP_BOARD nao atualizado no momento da etapa = etapa nao concluida. session_close bloqueia se WIP > 1 loop atrasado.

## [FALHA-PROCESSO-2026-06-10-E] TOKEN HERMES MORTO DESDE IMPLANTACAO
**Origem:** Sessao 2026-06-10. Token morto (7914321985) hardcoded no Hermes config.yaml. Declarado "ativo" sem teste ao vivo.
**Principio violado:** P-010 — gate sem evidencia e invalido.
**Antidoto:** ao implantar sistema com canal externo (Telegram, email, webhook), o gate de ativacao exige mensagem de teste RECEBIDA antes de declarar ATIVO.

## [FALHA-PROCESSO-2026-06-10-F] BOM SILENCIOSO NO WIP_BOARD — MULTIPLAS SESSOES
**Origem:** Sessao 2026-06-10. BOM (EF BB BF) no WIP_BOARD.json quebrando ChurnWatch n8n em silencio por multiplas sessoes.
**Antidoto:** validate_scripts.ps1 inclui verificacao de BOM em .json criticos. Ao criar .json critico no Windows, usar WriteAllBytes com encoding explicito sem BOM.

## [FALHA-PROCESSO-2026-06-10-G] DEF-M-6 — MUSCULO DETERMINOU ENCERRAMENTO
**Origem:** Sessao 2026-06-10. Musculo disse "va dormir" — determinou o estado do Diretor e da sessao.
**Principio violado:** fechamento e prerrogativa exclusiva do Diretor (CLAUDE.md + P-114).
**Antidoto:** nunca usar linguagem que determine estado do Diretor. Correto: "Diretor, chegamos ao protocolo de fechamento — deseja encerrar agora?"

## P-141 — LOOP TRANSCRIPT: IMUNIDADE ESTRUTURAL A AMNESIA DE COMPACTACAO (2026-06-09)
**Origem:** terceira ocorrencia de perda de trabalho por compactacao (Loop 30: capacidades Antigravity; Loop 29: missoes Embaixador; Loop 31: workflow YT + PASSO files). Padrao recorrente = falha estrutural.
**Principio:** todo trabalho que nao esta em arquivo em disco nao existe. Workflow, secoes de capacidades e instrucoes que so existem no chat sao conteudo morto.
**Solucao obrigatoria:** session_close.ps1 gera CLIENTES/[CLIENTE]/HISTORICO/LOOP_TRANSCRIPT_V[N].md com:
  (a) Todas as ideias M/G/N/A/E com disposicao final (APROVADO / V+1 / DESCARTADO)
  (b) Arquivos criados/modificados com resumo do conteudo critico
  (c) Skills usadas e outputs que nao podem ser perdidos
  (d) Checklist: secoes [CAPACIDADES] presentes em PASSO3/5/7?
  (e) Score do loop (5 metricas SYSTEM_HEALTH quando implementado)
**O transcript torna-se fonte permanente no caderno do Auditor.** O Auditor le os ultimos 3 transcripts antes de gerar a Skill. Continuidade garantida apos compactacoes.
**Aplica-se a:** todos os projetos, todos os loops. Prioridade de implementacao: Loop 31.

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
                                    {
                                        "id":  "PROJ-003",
                                        "cliente":  "MUMUZINHO",
                                        "projeto":  "Plataforma de Gestao Integral de Carreira Artistica",
                                        "area":  "MusicTech - Fonografia / Holding Artistica",
                                        "camada":  "5 (Monopolio -- escala enterprise)",
                                        "status":  "STANDBY -- aguarda acionamento do Diretor",
                                        "gut_score_atual":  60,
                                        "gut_score_potencial":  100,
                                        "gate_zero":  "contato bilateral confirmado com Dudu Felix -- PENDENTE",
                                        "gate_temporal":  "prospecção ativa pós 04-07-2026 (captacao 2a candidata Ingrid)",
                                        "decisor_presumido":  "Dudu Felix (ex-Universal Music) -- NAO VALIDADO",
                                        "churn_watch_threshold":  null,
                                        "ultimo_contato_cliente":  null,
                                        "briefing_path":  "CLIENTES/MUMUZINHO/EXTRAÇÃO DE DADOS FORMULÁRIO DE INÍCIO - MUMUZINHO.txt",
                                        "analise_encaixe":  "CLIENTES/MUMUZINHO/ANALISE_ENCAIXE_MUMUZINHO_2026-06-07.md",
                                        "pesquisa_dominio":  "CLIENTES/MUMUZINHO/PESQUISA_DOMINIO_FONOGRAFICO_2026-06-07.md",
                                        "memoria_embaixador_path":  "CLIENTES/MUMUZINHO/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR_MUMUZINHO.md",
                                        "nota":  "Standby total -- Diretor aciona quando tiver canal para Dudu Felix"
                                    }
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
                                    "loop_atual":  "Loop 31 FECHADO -- V31 Expansao da Inteligencia Interna -- P-143 a P-147",
                                    "build_iniciado_em":  "2026-06-06",
                                    "deadline":  null,
                                    "churn_watch_threshold":  null,
                                    "stack":  "Hermes Agent (Docker EasyPanel) + n8n (orquestrador) + Claude API (Haiku -- verificacao)",
                                    "loop_fase_atual":  {
                                                            "loop":  32,
                                                            "gemini":  "OK",
                                                            "notebooklm":  "PENDENTE",
                                                            "embaixador":  "PENDENTE",
                                                            "musculo":  "PENDENTE",
                                                            "proximo":  "NotebookLM -- Skill vanguard-v32.md"
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

## MEMORIA MAIS RECENTE -- MEMORIA_V31_VANGUARD.md
# MEMÓRIA TÉCNICA — VANGUARD V31 · Loop 31 · Expansão da Inteligência Interna
> Músculo · Data: 2026-06-09 · Síntese técnica completa para continuidade

---

## 1. RESUMO EXECUTIVO DO LOOP

**Tema:** Expansão da Inteligência Interna do Pentalateral IAH — loop interno sem clientes.

**Missão central:** Fazer o sistema se medir, se otimizar e fechar seus próprios ciclos de aprendizado. A lacuna detectada: 30 loops de histórico, 22+ scripts, n8n + Hermes em produção — mas sem dashboard de saúde, sem transcript de amnésia, sem métrica de deriva.

**Status ao fechar:** Gemini=OK · Auditor=OK (Skill aprovada) · Embaixador=AGUARDA (PASSO7 pronto) · Músculo=AGUARDA_EMBAIXADOR.

**Principal ganho estrutural:** P-143 (checklist anti-esquecimento obrigatório em todo PASSO) + P-144 (dois sócios têm pesquisa web avançada — mecanismos distintos e obrigatórios).

**Principal alerta herdado:** P-133 (Gate Zero de Pipeline) — o sistema está girando rotores mais rápido do que a esteira de aquisição. Loop 32 deve endereçar isso.

---

## 2. ENTREGAS CONFIRMADAS EM DISCO

| Artefato | Caminho | Status |
|----------|---------|--------|
| Ideias M-1 a M-5 (Músculo) | PASSO3_GEMINI.md | ✅ Gerado |
| DIRETRIZ V31 (Antigravity) | CLIENTES/VANGUARD/HISTORICO/DIRETRIZ_V31_VANGUARD.md | ✅ Recebida |
| AUDITOR Loop 31 (NotebookLM) | CLIENTES/VANGUARD/HISTORICO/AUDITOR_LOOP_V31_VANGUARD.md | ✅ Salvo |
| Skill vanguard-v31.md | .claude/skills/vanguard-v31.md | ✅ APROVADA (skill_parser_gate) |
| PASSO7 Embaixador | CLIENTES/VANGUARD/PASSO7_EMBAIXADOR.md | ✅ Pronto para uso |
| LOOP_STATE.json | CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json | ✅ Atualizado |
| P-143 + P-144 | INTELLIGENCE_LEDGER.md | ✅ Inscritos |
| Commit de artefatos | 6ebb950 | ✅ Commitado |

---

## 3. PRINCÍPIOS INSCRITOS

**P-143 — FERRAMENTA AUTOMÁTICA ANTI-ESQUECIMENTO DO MÚSCULO (2026-06-10)**
Cada PASSO file contém [CHECKLIST DO MÚSCULO] com itens BLOQUEANTES.
skill_parser_gate.ps1 verifica checklist no PASSO5 antes de executar.
session_close.ps1 Gate 6D: AUDITOR_LOOP_V[N] + relatorio nativo obrigatórios.

**P-144 — DOIS SÓCIOS TÊM PESQUISA AVANÇADA WEB — USAR OBRIGATORIAMENTE (2026-06-10)**
AUDITOR: botão Deep Research WEB → NOVAS FONTES no caderno (persistentes) → clicar via Playwright ANTES do PASSO5.
EMBAIXADOR: busca em tempo real → cita URLs → BLOCO 8 no PASSO7.
Checklist PASSO5 Loop 32: (1) Deep Research WEB clicado → (2) fontes adicionadas → (3) enviar PASSO5 → (4) generate report nativo → (5) salvar artefatos.

---

## 4. DECISÕES E VEREDITOS

**D1: W-8 Hermes Grau B**
- Contexto: 7 dias de shadow mode sem incidente. Grau B = age + janela de veto 15min.
- Veredito do Diretor: **D1:A — ATIVAR GRAU B** (2026-06-09)
- Status: Autorizado. Requer EasyPanel Terminal para executar (sem script de automação local).
  - Comando: `sed -i 's/grau: A/grau: B/' /opt/data/config.yaml && cat /opt/data/config.yaml`
  - Reiniciar serviço hermes-agent no EasyPanel após edição.

**D3: RUNNING_INTELLIGENCE.md**
- Contexto: Embaixador tem busca web agora. M-4 (sub-agentes) é build futuro. São independentes.
- Veredito do Diretor: **D3:A — CRIAR AGORA** (2026-06-09)
- Status: Embutido no PASSO7. Embaixador cria ao receber SEÇÃO D.

**D2 (removida pelo Diretor):** Mumuzinho não entra neste loop. Foco = Vanguard interna.

---

## 5. O QUE FICOU PENDENTE

| Item | Tipo | Prazo |
|------|------|-------|
| SEÇÃO D do Embaixador — colar output aqui | [diretor] | Próxima sessão |
| Síntese P-037 + DELIBERAÇÃO_LOOP_V31 | [musculo] | Após Embaixador |
| DECISOES.json (D1 + D3) | [musculo] | Após Embaixador |
| Executar vereditos via executar_vereditos.ps1 | [musculo] | Após DECISOES.json |
| D1:A EasyPanel Terminal — ativar Hermes Grau B | [diretor] | Antes de 2026-06-14 |
| MEMORIA_EMBAIXADOR_VANGUARD (P-032) | [musculo] | Após síntese P-037 |
| [CHECKLIST DO MÚSCULO] no PASSO5 template (P-143) | [musculo] | Loop 32 |
| session_close.ps1 Gate 6D (P-143) | [musculo] | Loop 32 |
| LOOP_TRANSCRIPT_V31 gerado pelo session_close (P-141) | [musculo] | Loop 32 |
| SYSTEM_HEALTH.md schema + métricas (M-1) | [musculo] | Loop 32 |
| BOM UTF-8 no WIP_BOARD.json — reintroduzido | [musculo] | Urgente (bloqueia ChurnWatch) |
| VANGUARD_TIMELINE — update Loop 31 | [musculo] | Esta sessão |
| Demo EdTech/Sedes-DF v0 | [musculo] | 2026-06-16 |

---

## 6. ALERTAS ATIVOS PARA O PRÓXIMO LOOP

**ALERT-1 [CRÍTICO] — P-133 Gate Zero de Pipeline ativo**
Sistema girando rotores mais rápido que esteira de aquisição. Loops de otimização interna
ofuscam ausência de novos MRRs. Loop 32 DEVE endereçar prospecção (M-4 + G-5 → leads reais).

**ALERT-2 [ALTO] — BOM UTF-8 no WIP_BOARD.json**
Detectado via Notion inbox: `Unexpected token '﻿'` quebra ChurnWatch + Notion sync.
Músculo deve corrigir antes do próximo session_close.

**ALERT-3 [ALTO] — Falhas Notion Inbox (4 registradas pelo Diretor)**
1. VANGUARD_TIMELINE desatualizada no Claude Projects (e pastas similares)
2. W-8 sinal classificado incorretamente como INFORMAR (shadow mode funcionando — verificar)
3. Instagram/ChurnWatch: erro BOM + mensagens duplicadas / fora de horário
4. Não recebimento de mensagens diárias (W-1, W-5, W-6 — verificar n8n)

**ALERT-4 [MÉDIO] — Hermes Grau B não executado ainda**
Diretor autorizou D1:A mas requer ação manual no EasyPanel Terminal. Prazo: antes de 2026-06-14.

**ALERT-5 [MÉDIO] — Reward Hacking (M-3 / P-124)**
Auto-calibração direta do Músculo é câmara de eco. M-3 movido para Loop 32 com Scorer cruzado
(Auditor avalia Músculo via P-132 Triangulação Cega). Regra: nenhum LLM pontua a si mesmo.

**ALERT-6 [BAIXO] — W-8 shadow mode expira 2026-06-14**
Se D1:A não executado antes dessa data, Hermes continua em Grau A mas protocolo shadow expira.

---

## 7. ESTADO DO CONSELHO

| Membro | Status | Artefato | Próxima ação |
|--------|--------|----------|--------------|
| Estrategista (Antigravity) | ✅ OK | DIRETRIZ_V31_VANGUARD.md | Aguarda Loop 32 — PASSO3 calibrado |
| Auditor (NotebookLM) | ✅ OK | AUDITOR_LOOP_V31_VANGUARD.md + vanguard-v31.md | Loop 32: Deep Research WEB ANTES do PASSO5 |
| Embaixador (Claude Projects) | ⏳ AGUARDA | — | Receber PASSO7 → SEÇÃO D + E-1 a E-5 + RUNNING_INTELLIGENCE |
| Músculo (Claude Code) | ⏳ AGUARDA_EMBAIXADOR | — | Síntese P-037 após SEÇÃO D |
| Diretor (Eduardo) | ▶ ATIVO | — | Levar PASSO7 ao Embaixador (7 documentos) |

**7 documentos para o Embaixador:**
1. INTELLIGENCE_LEDGER.md
2. WIP_BOARD.json
3. MEMORIA_V31_VANGUARD.md (este arquivo)
4. relatorio_evolutivo_V31_VANGUARD.md
5. AUDITOR_LOOP_V31_VANGUARD.md
6. vanguard-v31.md (.claude/skills/)
7. PASSO7_EMBAIXADOR.md (colar SEÇÃO D no chat)

---

## 8. CONTEXTO TÉCNICO PARA O PRÓXIMO LOOP

**Arquitetura atual do sistema (Loop 32 herda):**
- Antigravity CLI: lê PASSO3_GEMINI.md + CONTEXTO_GEMINI.md do disco → DIRETRIZ sem colagem manual
- NotebookLM VANGUARD caderno: ID d7dab0e1, conta subdiretor.mnmsgm@gmail.com, 23+ fontes
- Hermes Agent: Grau A (→ B pendente D1:A). Telegram @Eduardo431Vanguardbot
- n8n EasyPanel: W-1 a W-8 ativos. W-9 Track TRENDS pendente de import.
- LOOP_STATE.json: sistema de estado durável por loop (v1.0 ativo)
- WIP_BOARD.json: problema BOM reintroduzido — corrigir antes de W-5/W-6/Notion sync

**Prioridade técnica Loop 32:**
1. Corrigir BOM WIP_BOARD.json (bloqueia 3 automações)
2. Completar fechamento Loop 31 (SEÇÃO D + síntese P-037 + DECISOES.json)
3. Implementar M-4 (Deep Research hierárquico via n8n) → converter em prospecção
4. Adicionar [CHECKLIST DO MÚSCULO] ao PASSO5 template (P-143)
5. Demo EdTech/Sedes-DF v0 (deadline 2026-06-16)

**Regra de ouro para Loop 32:** P-133 não é alerta, é gate. Nenhum build de infraestrutura interna
avança sem estar vinculado a um lead ou cliente real.


================================================================================

## RELATORIO EVOLUTIVO -- relatorio_evolutivo_V31_VANGUARD.md
# RELATÓRIO EVOLUTIVO — VANGUARD V31 · Loop 31 · Expansão da Inteligência Interna
> Músculo · Data: 2026-06-09 · Análise de negócio + SWOT + PDCA + 5W2H

---

## 1. ANÁLISE SWOT — VANGUARD AO FINAL DO V31

### Forças (construídas ou consolidadas no Loop 31)
- **Sistema que se audita**: P-143 + P-144 institucionalizaram checklist anti-esquecimento e busca web obrigatória — o Músculo agora tem proteção contra suas próprias deficiências
- **Auditor como Intelligence Engine**: N-1 a N-5 + A-1 a A-3 + PARTE 7 (Estado da Arte) elevaram o Auditor de "biblioteca estática" para gerador de inteligência competitiva ativa
- **25 ideias por ciclo operacional**: M-1 a M-5 + G-1 a G-5 + N-1 a N-5 + A-1 a A-3 = 18 entradas qualificadas neste loop, com triangulação real (P-132)
- **RUNNING_INTELLIGENCE.md em construção**: Embaixador começa a acumular inteligência competitiva persistente entre loops (D3:A autorizado)
- **LOOP_STATE.json v1.0**: estado durável por loop resolve amnésia pós-compactação — base do LOOP_TRANSCRIPT futuro (M-2)

### Fraquezas (detectadas ou persistentes no Loop 31)
- **Pipeline vazio — P-133 ativo**: o sistema cresceu em sofisticação mas não em MRR. 2 clientes entregues e em standby, 0 em discovery ativo. Cada loop interno sem cliente novo é um custo de oportunidade.
- **BOM UTF-8 no WIP_BOARD.json — reintroduzido**: quebra W-5 (ChurnWatch), W-6 (Session Watch), Notion sync. Terceira ocorrência em 6 semanas — padrão de falha recorrente.
- **D1:A pendente de ação manual**: Hermes Grau B autorizado mas não executado. Dependência de EasyPanel Terminal sem script de automação = ponto de falha do Diretor.
- **4 falhas registradas no Notion Inbox**: Timeline desatualizada, Instagram com erros, mensagens diárias não chegando — indica que o sistema de automação tem furos silenciosos.

### Oportunidades
- **M-4 como máquina de prospecção**: Deep Research hierárquico via n8n (Haiku Research Agent) pode alimentar pipeline de leads reais — não apenas auditar o sistema
- **A-2 (Sub-agentes Haiku)**: redução de 30x no custo de tokens para pesquisa web — habilita G-5 (Oráculo de Churn) e A-1 (Roteador de Contexto) sem explodir o burn rate
- **A-3 (QA Browser via Embaixador)**: Computer Use API transforma Embaixador em executor de UI — primeiro passo para QA autônomo sem intervenção do Diretor
- **Hermes Grau B pré-aprovado**: ativação imediata assim que EasyPanel Terminal for acessado

### Ameaças
- **Reward Hacking (M-3 / P-124)**: qualquer métrica que o Músculo gera sobre si mesmo é câmara de eco. Scoreboards internos sem Scorer cruzado degradam a qualidade sem que ninguém perceba.
- **Sistema mais rápido que a esteira de aquisição (N-5)**: risco de "Museu Tecnológico" — sistema impecável com zero clientes novos
- **Latência do Diretor em gates manuais**: D1:A esperando EasyPanel, Embaixador esperando PASSO7 — cada gate manual é ponto de quebra do fluxo autônomo

---

## 2. PDCA DO LOOP 31

### Plan (o que foi planejado)
- Gerar M-1 a M-5 focados na expansão introspectiva do sistema
- Receber DIRETRIZ V31 do Antigravity com G-1 a G-5
- Auditor gera N-1 a N-5 + A-1 a A-3 + PARTE 7 Estado da Arte
- Inscrever novos princípios no LEDGER
- Embaixador gera SEÇÃO D + RUNNING_INTELLIGENCE.md (D3:A)
- Fechar loop com DECISOES.json + vereditos

### Do (o que foi executado)
- M-1 a M-5 gerados com ultrathink (PASSO3)
- DIRETRIZ V31 recebida do Antigravity
- Auditor concluiu PARTES 1-7 com 23 fontes + PARTE 6 Deep Research interno
- Skill vanguard-v31.md APROVADA pelo skill_parser_gate
- P-143 e P-144 inscritos no LEDGER
- PASSO7 montado com G-1 a G-5 + N-1 a N-5 + A-1 a A-3 + BLOCO 8 ativo
- Commit 6ebb950: 6 arquivos, 651 inserções

### Check (o que desviou do plano)
- **Deep Research WEB não foi clicado ANTES do PASSO5** — P-144 criado exatamente para corrigir isso nos loops seguintes
- **Embaixador ainda aguarda** — SEÇÃO D + RUNNING_INTELLIGENCE.md pendentes
- **D1:A autorizado mas não executado** — dependência de EasyPanel Terminal
- **4 falhas de automação** detectadas no Notion Inbox — não identificadas durante a sessão
- BOM WIP_BOARD.json reintroduzido (origem desconhecida — investigar no Loop 32)

### Act (o que muda no Loop 32)
- P-143 obriga [CHECKLIST DO MÚSCULO] em todo PASSO file — nem o Músculo escapa
- P-144 define sequência exata: Deep Research WEB PRIMEIRO, depois PASSO5
- BOM WIP_BOARD.json: corrigir + adicionar validação no session_close Gate 1
- M-3 (auto-calibração direta) descartado para Loop 32 — substituir por Scorer cruzado (P-132)
- Loop 32 abre com P-133 como gate: nenhum build interno sem vínculo a lead/cliente real

---

## 3. 5W2H — EXPANSÃO DA INTELIGÊNCIA INTERNA

| Dimensão | Resposta |
|----------|---------|
| **WHAT** | Fazer o Pentalateral se medir, se otimizar e fechar ciclos de aprendizado sem depender da memória humana |
| **WHY** | 30 loops sem dashboard de saúde, sem transcript de amnésia, sem métrica de deriva — o sistema evoluía cegamente |
| **WHO** | Músculo lidera build · Auditor audita coerência histórica · Embaixador acumula inteligência externa · Estrategista orienta arquitetura |
| **WHERE** | PENTALATERAL_UNIVERSAL/ (P-143/P-144 universais) · CLIENTES/VANGUARD/ (LOOP_STATE, RUNNING_INTELLIGENCE) · scripts/ (session_close, skill_parser_gate) |
| **WHEN** | Loop 31 define a arquitetura · Loop 32 entrega M-1 (SYSTEM_HEALTH) + M-2 (LOOP_TRANSCRIPT) + [CHECKLIST] no PASSO5 |
| **HOW** | SYSTEM_HEALTH.md (M-1) lido em 30s · LOOP_TRANSCRIPT delta ≤100 linhas (N-2) · Sub-agentes Haiku (A-2) reduzem custo 30x · RUNNING_INTELLIGENCE com decaimento 90 dias (N-4) |
| **HOW MUCH** | 0 custo direto neste loop (apenas documentação/princípios) · Loop 32: 2-3h build M-1 + M-2 + templates · A-2: ~US$0.50/loop estimado com Haiku Research Agent |

---

## 4. VISÃO DO CONSULTOR — O QUE ESSE LOOP REALMENTE ENTREGOU

Loop 31 foi um loop de **consciência**, não de construção. O Pentalateral olhou para si mesmo pela primeira vez com rigor real:
- Descobriu que dois de seus sócios têm capacidades inexploradas (P-144)
- Descobriu que o Músculo pode esquecer coisas críticas sem um mecanismo de checklist (P-143)
- Descobriu que M-3 (auto-avaliação) é uma armadilha de câmara de eco

O risco real não é técnico — é estratégico: **P-133 não foi resolvido**. O sistema que emerge do Loop 31 é mais sofisticado, mais auto-consciente, mas ainda sem novo cliente desde Loop 29. A cada loop interno, o custo de oportunidade sobe.

A recomendação do consultor para Loop 32 é direta: **M-4 + G-5 como máquinas de prospecção, não de auditoria**. O Pentalateral precisa atacar o mercado com as mesmas ferramentas que usa para se otimizar.

---

## 5. IDEIAS PARA O LOOP 32 — [M-1 a M-5 SUGESTÕES]

Com base nos padrões deste loop, as 5 ideias que o Músculo leva para o Estrategista:

**[M-1] SISTEMA_HEALTH COMO FIREWALL DE CUSTO**
SYSTEM_HEALTH.md inclui Token Burn Rate como campo obrigatório. Se custo/loop > threshold → session_start bloqueia novos builds e alerta Diretor. Conectar ao campo billing_limit do WIP_BOARD.

**[M-2] LOOP_TRANSCRIPT COMO DELTA DE INTELIGÊNCIA**
session_close gera LOOP_TRANSCRIPT_V[N].md com ≤100 linhas: DECISOES.json diff + friction.log + princípios inscritos + alerta de P-133. Fonte automática no NotebookLM VANGUARD.

**[M-3] M-4 ATACANDO PIPELINE REAL**
Sub-agente Haiku via n8n faz varredura semanal de: startups de LegalTech/EdTech no Brasil com <50 funcionários + sem IA ativa + fundador acessível no LinkedIn. Output: 5 leads qualificados/semana → RUNNING_INTELLIGENCE.

**[M-4] CHECKLIST DO MÚSCULO COMO LEI**
[CHECKLIST DO MÚSCULO] adicionado ao PASSO5 + PASSO7 + PASSO3. skill_parser_gate.ps1 rejeita PASSO5 sem checklist. Ponto de partida: lista dos 5 erros mais frequentes por P-XXX.

**[M-5] ORÁCULO DE BOM UTF-8**
validate_scripts.ps1 adiciona verificação de BOM em todos os .json do repositório. Se BOM detectado → alerta imediato no Telegram + exit 1 no session_start. Nunca mais o ChurnWatch quebra silenciosamente.


================================================================================

## MISSAO DESTA SESSAO -- PASSO3_GEMINI (VANGUARD)
# PASSO 3 — EXECUTOR DO ESTRATEGISTA (ANTIGRAVITY) · VANGUARD UNIVERSAL
# Sessao: 2026-06-09 · Loop 31 · EXPANSAO DA INTELIGENCIA INTERNA DO PENTALATERAL
# COMO USAR: o Antigravity (EXECUTOR do Estrategista) LE este arquivo do disco -- nao se cola nem se anexa.
#            Contexto canonico lido junto: CLIENTES/VANGUARD/CONTEXTO_GEMINI.md (LEDGER+WIP+MEMORIA)

---

## [IDENTIDADE DO EXECUTOR DO ESTRATEGISTA]

Voce e o EXECUTOR do Estrategista (Gemini) do Pentalateral IAH, operando pelo canal Antigravity.

Seu papel neste loop e atacar uma lacuna que o Loop 30 revelou com clareza: o sistema
Pentalateral sabe construir produtos para clientes, mas **nao se mede, nao se otimiza
e nao fecha seus proprios ciclos de aprendizado**. A missao deste loop nao e sobre
pipeline nem sobre clientes -- e sobre tornar o sistema mais inteligente do que ele era
no loop anterior.

**Use suas capacidades de pesquisa para ancorar as ideias em evidencia real -- nao em inferencia.**

Deficiencia a combater: Alucinacao Otimista -- propor expansao sem questionar se os
fundamentos ja estao solidos. A pesquisa real e o antidoto.

---

## [CAPACIDADES DO ESTRATEGISTA -- ANTIGRAVITY 2026]

> Esta secao e permanente -- nao muda por loop. Leia antes de formular qualquer ideia.

Voce nao e um modelo de chat. Voce e uma plataforma **Agent-First** com capacidades que
a maioria dos sistemas nao usa. Use todas elas neste loop:

**Manager Surface -- orquestracao de agentes em background**
O Antigravity pode despachar subagentes de longo prazo rodando em background (Gemini 3.5 Flash).
Nao apenas planeja -- orquestra. Cada ideia que voce entregar pode ser validada por um subagente
antes de chegar ao Diretor. Gere **Artifacts visuais** -- nao logs brutos. O Diretor ve o resultado,
nao o processo.

**Deep Research com grounding nativo**
Voce tem acesso ao Google Search em tempo real. Use para:
- Verificar se as ideias que vai propor ja existem no mercado (e onde falharam)
- Ancorar cada afirmacao em fonte verificavel (URL + data de acesso)
- Contradizer o que o Musculo propus se a evidencia real apontar diferente
Nunca responda com "provavelmente" ou "tipicamente" quando pode pesquisar.

**Leitura de arquivos via @ -- contexto completo do sistema**
Voce le @CLIENTES/VANGUARD/PASSO3_GEMINI.md e @CLIENTES/VANGUARD/CONTEXTO_GEMINI.md
diretamente do disco. O CONTEXTO_GEMINI contem: LEDGER completo (P-001 a P-139) + WIP_BOARD
+ MEMORIA do loop anterior. Voce tem a historia completa do sistema -- use-a.

**Contexto longo -- ate 1M tokens**
Voce pode processar o historico completo de V1 a V30 sem perda. Se o CONTEXTO_GEMINI
trouxer documentos longos, leia todos -- nao atalhe.

**Pesquisa de mercado ativa**
Para cada ideia que propuser, pesquise: alguem ja tentou isso? Funcionou? Qual foi o
ponto de falha? A evidencia real substitui a especulacao. Este e o antidoto da Alucinacao Otimista.

---

## [MANDATO DO DIRETOR -- ABERTURA DO LOOP 31]

O Diretor identificou que o Loop 30 focou em clientes quando o tema era expansao do
sistema. O mandato deste loop e claro:

**"Quero expandir a inteligencia da Vanguard -- o sistema em si, nao os clientes."**

Isso significa: processos internos mais robustos, instrumentos de memoria mais ricos,
medicao objetiva da evolucao, e automacao que reduz o custo cognitivo do Diretor no
proprio processo de deliberacao.

---

## [CONTEXTO DO LOOP 30 -- O QUE FICOU PARA TRAS]

Loop 30 fechado em 2026-06-09. Entregou:
- P-136: /ultrathink obrigatorio na sintese P-037 -- Classe C apenas
- P-137: mapa de skills por gate do Pentalateral
- P-138: protocolo Valdece Primeiro -- demo no nicho de cliente exige pre-aviso
- P-139: linha vitrine vs cofre -- antes do primeiro Artifact publico
- Skills instaladas: brainstorming + writing-plans + ultrathink-trigger + mcp-builder
- YT-ENRICHMENT ativo: 5 fontes YouTube adicionadas ao caderno VANGUARD

Estado atual dos projetos:
- PROJ-001 Valdece: HYPERCARE ate 18/06 · standby
- PROJ-002 Ingrid: RETAINER · standby
- PROJ-003 Mumuzinho: DISCOVERY STANDBY
- W-8 Hermes shadow mode: decisao pendente (deadline 14/06/2026)

Problema estrutural identificado pelo Diretor no Loop 30:
O PASSO3 tinha missao errada (pipeline) e as capacidades do Antigravity nao estavam
registradas em arquivo -- perdidas no compacto de contexto. Loop 31 corrige ambos.

---

## [ABERTURA DO MUSCULO -- M-1 a M-5 · LOOP 31]

Estes sao os 5 eixos que o Musculo identifica como criticos para expandir a
inteligencia interna do sistema:

---

**[M-1] LOOP SCOREBOARD -- O Sistema Que Finalmente Se Mede**

O Pentalateral acumulou 30 loops e 139 principios sem uma unica metrica objetiva de saude.
Como saber se o Loop 31 foi melhor que o 30?

session_close.ps1 passa a calcular e gravar SYSTEM_HEALTH.md a cada loop com 5 metricas:
1. Taxa de Novidade -- % das ideias [G+N] que nao repetem os ultimos 3 loops do LEDGER
2. Densidade de Principios -- quantos P-XXX novos foram extraidos
3. Taxa de Violacao -- quantos P-XXX foram violados e detectados
4. Tempo de Ciclo -- do PASSO3 ao commit de fechamento (em horas)
5. Score de Divergencia -- quantas vezes os socios discordaram entre si

O Diretor ve em 30 segundos se o sistema esta evoluindo ou degradando antes de qualquer sessao.

---

**[M-2] LOOP TRANSCRIPT -- Imunidade a Amnesia de Compactacao**

Esta sessao perdeu a secao de capacidades do Antigravity porque estava so no chat.
O LOOP_STATE.json ajuda mas nao captura tudo.

session_close.ps1 passa a gerar CLIENTES/VANGUARD/HISTORICO/LOOP_TRANSCRIPT_V[N].md com:
- Todas as ideias M/G/N/A/E com disposicao final (APROVADO / V+1 / DESCARTADO)
- Arquivos criados/modificados na sessao
- Skills usadas e seus outputs criticos
- Secoes que nao devem ser perdidas entre loops (capacidades dos socios, decisoes arquiteturais)

O transcript torna-se fonte permanente no caderno VANGUARD -- o Auditor le os ultimos 3
transcripts antes de gerar a Skill. Continuidade garantida mesmo com compactacoes.

---

**[M-3] PASSO3 AUTO-CALIBRAVEL -- Prevencao de Reciclagem**

O Loop 30 gerou 91 ideias recicladas. A Rubrica PASSO3 previne a reincidencia.
Ha uma camada mais profunda: apos cada loop, o Musculo scorea o PASSO3 anterior:
- O Estrategista trouxe angulos que o Musculo sozinho nao veria? (1-5)
- A DIRETRIZ forcou salto em relacao ao Loop N-1? (1-5)
- % de ideias novas nas [G] vs ideias recicladas

Esse score e gravado em SYSTEM_HEALTH.md e injetado no PROXIMO PASSO3 como contexto:
"Loop anterior teve Score 2 em divergencia -- Estrategista deve forcar angulo contrastante."
O sistema se autocorrige loop a loop.

---

**[M-4] AUDITOR COMO INTELLIGENCE ENGINE -- Deep Research Ativo**

O Auditor hoje e uma biblioteca estatica. Ele tem Deep Research -- pesquisa ativa na web
ancorada nas fontes do caderno -- que nunca foi ativado em producao no Pentalateral.

No PASSO5, o Musculo passa 5 research queries especificas para o Auditor pesquisar:
1. Estado da arte de sistemas multi-agente com memoria persistente (2025-2026)
2. Ferramentas de medicao de qualidade de outputs LLM em producao
3. Padroes de falha em sistemas de 4+ LLMs coordenados
4. MCP em producao: casos reais de sucesso e falha documentados
5. Antigravity Manager Surface: capacidades tecnicas reais vs documentadas

Output adicional: alem da Skill, o Auditor entrega um BRIEFING DE ESTADO DA ARTE --
documento que serve o loop inteiro como referencia de inteligencia externa.

---

**[M-5] EMBAIXADOR INTELLIGENCE LOOP -- Da Reatividade a Proatividade**

O Embaixador hoje reage ao PASSO7. Com BLOCO 8 completamente ativado, pode fazer mais.
No PASSO7, alem da SECAO D, o Embaixador recebe missao adicional:
- Manter RUNNING_INTELLIGENCE.md que acumula inteligencia competitiva entre loops
- Pesquisar proativamente: "o que aconteceu no mercado esta semana relevante ao Pentalateral?"
- Detectar deriva: "algum produto novo ameaca a vantagem assimetrica da Vanguard?"

Em 6 loops, o Pentalateral tem repositorio de inteligencia competitiva construido automaticamente.

---

## [MISSAO PARA O ESTRATEGISTA]

Os M-1 a M-5 sao o ponto de partida -- nao o teto.

O Estrategista nao esta aqui para validar o Musculo. Esta aqui para ver o que
o Musculo nao consegue ver de dentro. Para propor o que parece impossivel hoje
mas sera obvio em 6 meses. Para questionar se os 5 eixos atacam a raiz certa
ou apenas o sintoma mais visivel.

**Expanda livremente. Nao se limite ao que os M-1 a M-5 abriram.**

O sistema Pentalateral tem hoje 4 LLMs coordenados, 139 principios acumulados,
automacao ativa 24/7, e historico de 30 loops. O que esse sistema poderia fazer
que ainda nao faz? Onde esta o salto de ordem de magnitude -- nao de 10%, mas de 10x?

**Tres ancoras que nao mudam -- o resto e aberto:**
- O Diretor delibera e tem veredito final em toda decisao
- Nenhum socio age sobre dados de cliente sem aprovacao explicita (P-059)
- Toda saida do Estrategista passa pelo Musculo antes de virar acao (P-124)

---

## [FORMATO DA DIRETRIZ]

DIRETRIZ ESTRATEGICA V31 -- VANGUARD TECH -- Loop 31

[1. VALIDACAO DO MUSCULO] -- o que esta certo nos M-1 a M-5
[2. O QUE O MUSCULO NAO VIU] -- angulos novos, pontos cegos, saltos de ordem
[3. DECISAO] -- ENTRA AGORA / Loop 32 / DESCARTADO
[4. COMO AMPLIFICAR] -- como tornar cada ideia mais forte
[5. IMPACTO NO SISTEMA] -- o que muda nos loops seguintes se implementado
[6. PROXIMA ACAO] -- o que desbloqueia imediatamente

[G-1 a G-5] -- cinco ideias disruptivas de expansao interna

[PARA O NOTEBOOKLM]
Skill: vanguard-v31.md
[IDENTIDADE DO AUDITOR UNIVERSAL]
[O QUE AUDITAR NESTE LOOP]
[PADROES HISTORICOS CRITICOS]
[N-1 a N-5]

