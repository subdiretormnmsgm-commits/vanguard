# LEGISLACAO IA - BRASIL
**Status:** Legislacao compilada — aguardando clausula do Auditor (NotebookLM)
**Objetivo:** Fundamentar clausula de isencao de responsabilidade para o Discovery Product
**Prioridade:** Baixa — executar apos entrega de PROJ-001 (Valdece) e PROJ-002 (Ingrid)

---

## LEGISLACAO — Texto Oficial Compilado (2026-05-16)
*Fontes: planalto.gov.br · camara.leg.br · senado.leg.br · jusbrasil.com.br*

---

### 1. Marco Civil da Internet — Lei n. 12.965/2014

**Art. 7** — O acesso a internet e essencial ao exercicio da cidadania, e ao usuario sao assegurados os seguintes direitos:
> **XIII** — aplicacao das normas de protecao e defesa do consumidor nas relacoes de consumo realizadas na internet.

**Art. 19** — Com o intuito de assegurar a liberdade de expressao e impedir a censura, o provedor de aplicacoes de internet somente podera ser responsabilizado civilmente por danos decorrentes de conteudo gerado por terceiros se, apos ordem judicial especifica, nao tomar as providencias para, no ambito e nos limites tecnicos do seu servico e dentro do prazo assinalado, tornar indisponivel o conteudo apontado como infringente.

**Aplicacao a Vanguard:** A Vanguard opera como provedora de aplicacao que processa inputs do proprio cliente via LLMs. O Art. 19 afasta responsabilidade por outputs gerados pelos modelos (terceiros). O Art. 7, XIII exige que o cliente declare ciencia das condicoes do servico antes do onboarding.

---

### 2. LGPD — Lei n. 13.709/2018

**Art. 6** — As atividades de tratamento de dados pessoais deverao observar a boa-fe e os seguintes principios:
> **VI — transparencia:** garantia, aos titulares, de informacoes claras, precisas e facilmente acessiveis sobre a realizacao do tratamento e os respectivos agentes de tratamento, observados os segredos comercial e industrial.

**Art. 20** — O titular dos dados tem direito a solicitar a revisao, por pessoa natural, de decisoes tomadas unicamente com base em tratamento automatizado de dados pessoais que afetem seus interesses, inclusive de decisoes destinadas a definir o seu perfil pessoal, profissional, de consumo e de credito ou os aspectos de sua personalidade.
> **§ 1** — O controlador devera fornecer, sempre que solicitadas, informacoes claras e adequadas a respeito dos criterios e dos procedimentos utilizados para a decisao automatizada, observados os segredos comercial e industrial.
> **§ 2** — Em caso de nao oferecimento de informacoes de que trata o § 1 deste artigo baseado na observancia de segredo comercial e industrial, a autoridade nacional podera realizar auditoria para verificacao de aspectos discriminatorios em tratamento automatizado de dados pessoais.

**Aplicacao a Vanguard:** O Discovery Product nao emite decisao automatizada vinculante — e subsidio consultivo. Toda decisao final e tomada pelo cliente (Human-in-the-Loop), descaracterizando o escopo do Art. 20. A clausula deve explicitar isso.

---

### 3. Codigo Civil — Lei n. 10.406/2002

**Art. 393** — O devedor nao responde pelos prejuizos resultantes de caso fortuito ou forca maior, se expressamente nao se houver por eles responsabilizado.
> **Paragrafo unico** — O caso fortuito ou de forca maior verifica-se no fato necessario, cujos efeitos nao era possivel evitar ou impedir.

**Art. 421-A** (introduzido pela Lei n. 13.874/2019 — Lei da Liberdade Economica) — Os contratos civis e empresariais presumem-se paritarios e simetricos ate a presenca de elementos concretos que justifiquem o afastamento dessa presuncao, ressalvados os regimes juridicos previstos em leis especiais, garantido tambem que:
> **I** — as partes negociantes poderao estabelecer parametros objetivos para a interpretacao das clausulas negociais e de seus pressupostos de revisao ou de resolucao;
> **II** — a alocacao de riscos definida pelas partes deve ser respeitada e observada; e
> **III** — a revisao contratual somente ocorrera de maneira excepcional e limitada.

**Art. 594** — Toda a especie de servico ou trabalho licito, material ou imaterial, pode ser contratada mediante retribuicao.

**Aplicacao a Vanguard:** O servico e obrigacao de meio (Art. 594), nao de resultado. Alucinacoes algoritmicas e quedas de infraestrutura da Anthropic ou OpenAI sao caso fortuito tecnico (Art. 393). Em B2B, o Art. 421-A valida a alocacao contratual de risco ao contratante — a clausula de isencao tem forca legal plena.

---

### 4. PL de Inteligencia Artificial — PL n. 2338/2023

**Status:** Em tramitacao — aprovado no Senado, em analise na Camara (2025).

**Classificacao de Risco:**
- **Risco Excessivo (proibido):** sistemas de armas autonomas, inducao comportamental que cause dano.
- **Alto Risco:** sistemas em saude, educacao, credito, selecao de candidatos, infraestrutura critica — responsabilidade objetiva (independente de culpa).
- **Risco Geral:** demais sistemas de produtividade e apoio a decisao — responsabilidade subjetiva (exige prova de dolo ou culpa grave), com possivel inversao do onus da prova em favor da vitima.

**Aplicacao a Vanguard:** O Discovery Product se enquadra como Risco Geral — ferramenta de auxilio a produtividade e otimizacao de negocios. A clausula deve autodeclarar esse enquadramento e exigir que o cliente assine termo de que o output nao substitui o julgamento critico corporativo.

---

### 5. Conselhos Profissionais Regulamentados

**Lei n. 8.906/1994 — Estatuto da OAB:**
> **Art. 1** — Sao atividades privativas de advocacia: I — a postulacao a qualquer orgao do Poder Judiciario e aos juizados especiais; II — as atividades de consultoria, assessoria e direcao juridicas.

**CFM e CFP n. 11/2022:** Proibem emissao de diagnostico clinico ou laudo psicologico por sistemas automatizados sem supervisao de profissional habilitado.

**Aplicacao a Vanguard:** O contrato deve conter disclaimer explicito de que o artefato nao e parecer juridico, diagnostico medico, laudo psicologico, nem auditoria contabil. Deve ser validado por profissional titulado antes de qualquer implementacao em area regulamentada.

---

### 6. Jurisprudencia STJ

**REsp n. 1.250.730/SP e teses consolidadas sobre Pareceres Tecnicos:**

O STJ pacificou que consultores tecnicos e emissores de pareceres estrategicos nao respondem pelo insucesso financeiro do cliente, salvo prova de:
- Erro grosseiro (culpa grave manifesta);
- Dolo (intencao fraudulenta); ou
- Negligencia deliberada na coleta dos dados iniciais.

O insucesso de estrategia de mercado sugerida por parecerista e considerado risco inerente a atividade empresarial do tomador do servico.

**Aplicacao a Vanguard:** O artefato do Discovery Product constitui opiniao tecnica opinativa probabilistica. A decisao de implementar pertence exclusivamente ao cliente — ausencia de nexo de causalidade afasta qualquer responsabilizacao da Vanguard por resultado comercial negativo.

---

## CLAUSULA DEFINITIVA — Redigida pelo Auditor (2026-05-16)

**Clausula de Isencao de Responsabilidade (Discovery Product)**

A contratante reconhece que o "Discovery Product" constitui uma obrigacao de meio e nao de resultado, consubstanciada em um subsidio consultivo probabilistico classificado como sistema de Risco Geral. Em observancia a presuncao de simetria e paridade nas relacoes empresariais (Art. 421-A do Codigo Civil), a contratante assume integralmente o risco pelas decisoes de negocio adotadas a partir do artefato, isentando a Vanguard Tech de qualquer responsabilidade civil por insucesso financeiro ou comercial, alinhando-se a jurisprudencia consolidada do Superior Tribunal de Justica (REsp n. 1.250.730/SP) para servicos opinativos.

Fica expressamente pactuado que a Vanguard atua como provedora de aplicacao, nao respondendo por imprecisoes algoritmicas, alucinacoes de inteligencia artificial ou indisponibilidade de infraestrutura de terceiros, eventos estes tipificados como caso fortuito tecnico (Art. 393 do Codigo Civil e Art. 19 do Marco Civil da Internet). Adicionalmente, a ferramenta nao emite decisoes automatizadas vinculantes, dependendo exclusivamente do juizo critico e da decisao final humana da contratante (Human-in-the-Loop), o que descaracteriza o direito de revisao obrigatoria previsto no Art. 20 da Lei Geral de Protecao de Dados (LGPD).

Por fim, o artefato entregue possui natureza estritamente estrategica e nao substitui, sob nenhuma hipotese, pareceres juridicos (Art. 1 da Lei n. 8.906/94), diagnosticos medicos ou auditorias contabeis. A contratante declara ciencia inequivoca de que quaisquer recomendacoes que incidam sobre areas de atuacao regulamentadas por Conselhos Profissionais devem ser obrigatoriamente validadas por profissionais titulados e habilitados antes de sua implementacao pratica.

---

## RISCOS JURIDICOS NAO COBERTOS (identificados pelo Auditor)

**Risco 1 — Vazamento de Dados Confidenciais (LGPD):**
A clausula afasta responsabilidade sobre decisao automatizada (Art. 20), mas nao isenta a Vanguard caso dados estrategicos do cliente (enviados no Briefing) vazem ou sejam utilizados pelas APIs de terceiros (Anthropic/OpenAI) para treinar modelos publicos. A Vanguard pode responder como operadora/controladora de dados em caso de incidente de seguranca.

**Risco 2 — Violacao de Propriedade Intelectual:**
Se os LLMs gerarem sugestao de nome, slogan ou estrategia que infrinja marca registrada ou direitos autorais de terceiros, o cliente pode responsabilizar a Vanguard solidariamente. O STJ nao cobre esse cenario na tese de insucesso comercial.

---

## RECOMENDACAO DO AUDITOR

Sim — homologacao por advogado especializado em Direito Digital obrigatoria antes do uso comercial. O Art. 421-A exige alocacao de riscos impecavel no conjunto do contrato. Advogado deve garantir que a clausula nao conflite com outras secoes do ToS e inserir defesas processuais especificas de foro.
