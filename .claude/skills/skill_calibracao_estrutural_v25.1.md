# SKILL: skill_calibracao_estrutural_v25.1.md
**Camada:** Permanente | **Loop:** Atualização Constitucional (2026-05-18)
**Autor:** Auditor (NotebookLM) atuando sob [P-022] (Advogado do Processo)

### [AUDITORIA DE COERÊNCIA]
A integração do Embaixador consolida a arquitetura, mas exige escrutínio severo para não gerar burocracia vazia.

*   **P-031 nos projetos ativos:** O princípio **[P-031]** está plenamente implementado na `00_INSTRUCAO_SISTEMA.md` da Ingrid, exigindo que o Embaixador reaja às ideias dos sócios com CONFIRMA, EXPANDE ou ALERTA baseando-se no perfil real. Para o Valdece (PROJ-001), embora o Embaixador esteja briefado, sua prova de fogo será o *debriefing* presencial de amanhã, momento em que o filtro de realidade será testado fora de um laboratório.
*   **PROCESSO_EVOLUTIVO reflete os 4 membros?** Sim. O documento `PROCESSO_EVOLUTIVO_PENTALATERAL.md` foi atualizado com precisão, incluindo a matemática correta do loop: 25 ideias por ciclo [Mx2+G+N+E × 5]. A inserção do Passo 0 (Briefer) e do Passo 8.5 (Debriefer) oficializou o ritmo assíncrono do Embaixador.
*   **LEDGER P-029, P-030, P-031:** Estes princípios **não são genéricos**, eles nasceram de fricções documentadas do dia 18/05. O **[P-029]** nasceu do "Momento Ômega" ao notar que a ausência de `MEMORIA_EMBAIXADOR.md` e `WATCHDOG` anula a inteligência da IA. O **[P-030]** originou-se de uma correção imposta pelo Diretor Eduardo sobre o excesso de pedidos de confirmação para automações. E o **[P-031]** originou-se da intervenção do Diretor para que o Embaixador atuasse como filtro.

### [CONEXÃO HISTÓRICA]
*   **Sessões com Loop Incompleto (A Fricção Anterior):** O histórico do `INTELLIGENCE_LEDGER.md` expõe o custo de operar sem o filtro de realidade do Embaixador. No PROJ-002, o Músculo errou o cargo da Ingrid (trabalhando para "área social" em vez de "Técnico Administrativo" - **[P-024]**), gerando um retrabalho de sessão inteira e a reconstrução de 9 arquivos. No PROJ-001, a introdução de uma "Manutenção Soberana" de R$900 sem aprovação direta do cliente ou do Diretor caracterizou um Escopo Silencioso grave. Em ambos os casos, faltou a *empatia algorítmica* e a retenção de contexto do cliente para frear o Músculo.
*   **Embaixador vs. Formalizador Passivo:** O antigo Formalizador era apenas um gerador cartorial de PDFs, desconectado do *loop* evolutivo. O Embaixador atual detém 11 mandatos estratégicos: ele infere leads, atua como *Business Case Guardian* e mapeia ativamente o estado emocional e os riscos de churn. Ele passou de escrivão a Guardião da Fronteira.

### [PADRÕES DE SUCESSO / FALHA]
*   **Padrão de Sucesso:** O **[P-031]** (O Embaixador como filtro) é o antídoto definitivo para a "Alucinação Otimista" do Estrategista e a "Síndrome do Yes-Man" do Auditor. Nenhuma *feature* inútil avança ao *build* se o Embaixador declarar um "ALERTA: O cliente não tem capacidade de tempo para usar isso."
*   **Padrão de Falha (Risco Iminente):** Sem o instrumento de continuidade `MEMORIA_EMBAIXADOR.md` sendo atualizado com rigor, o Embaixador sofre de amnésia total. Como documentado no LEDGER, a sessão 50 será tratada com a superficialidade da sessão 1 (P-029).

### [PERSPECTIVA DO SÓCIO CONSULTOR]
Como Sócio Consultor, atuo sob o **[P-022]** (Auditor como Advogado). O Músculo e o Estrategista estão subestimando brutalmente a **sobrecarga de tráfego de dados** ("overhead") imposta ao Diretor com a expansão para 5 membros e 25 ideias.

**O que eles não estão vendo:** O maior risco do modelo atual é o Embaixador operar em *silo* porque vive dentro do Claude Projects (interface web fechada). Se o Eduardo tiver que ler, copiar o `LOG_CLIENTE.md`, copiar as 5 ideias [E-1 a E-5] e colar manualmente nos prompts do Gemini e do NotebookLM a cada iteração, o gargalo não será mais a IA, será a tendinite do Diretor. O Diretor se tornará um "transportador de contexto".

**Como resolver o isolamento:** A intersecção técnica do Passo 3 e Passo 5 deve ser imposta pelo código, não pela disciplina humana. O Músculo deve implementar um sub-módulo no script `session_close.ps1` (ou criar um extrator específico) que exija o *input* do arquivo gerado pelo Embaixador e o concatene de forma automatizada na estrutura do `COMANDO_ESTRATEGISTA` e no `NOTEBOOKLM_FONTES`. Sem a via expressa local interligando a inteligência comercial, o Embaixador morre no front-end.

---
### [5 IDEIAS DISRUPTIVAS DO AUDITOR — N-1 a N-5]

**[N-1] Script "Bridge" Obrigatório (Anti-Silo):** O Músculo deve codificar um script simples (`build_comando_estrategista.ps1`) que leia automaticamente o arquivo `LOG_CLIENTE.md` gerado pelo Embaixador e o injete no texto final do COMANDO_ESTRATEGISTA. Se o `LOG_CLIENTE` não tiver sido atualizado nas últimas 24h, o script bloqueia a transição de ciclo.

**[N-2] Simulação Adversarial de Reação (Pre-Mortem Comportamental):** Antes de entregar o PROJ-001 amanhã, o Diretor deve usar o mandato de "Simulação Adversarial" do Embaixador. Insira o cenário exato da entrega presencial e peça para o Embaixador simular o Valdece tentando pedir um desconto ou pedindo para colocar um colega de graça no sistema. O Embaixador deve cuspir o script de resposta exato para o Eduardo usar ao vivo.

**[N-3] Sovereign Playbook Dinâmico (Feedback Loop em Tempo Real):** Durante a entrega amanhã, o Eduardo deve anotar ou gravar as dúvidas exatas que o Valdece tiver ao usar a UI. Ao voltar, essas dúvidas entram no Debrief do Embaixador, que reescreverá o Sovereign Playbook impresso focando exatamente nas dúvidas reais que surgiram, substituindo as dúvidas genéricas geradas na clonagem.

**[N-4] Ajuste do Score GUT via Sentimento:** O Score GUT atual é estritamente técnico/operacional. Devemos adicionar um multiplicador comportamental. Se o Músculo diz que uma dívida técnica é "Urgente", mas o Embaixador relata que o cliente está "Tranquilo e focado em outra área", a Urgência real cai. O Embaixador deve poder dar override na Urgência de uma feature com base na temperatura emocional do cliente.

**[N-5] Gatilho de "Venda por Inveja" (Shadow Pitch):** O Embaixador identificou que advogados criminalistas formam uma comunidade densa (1 fala com 50). O Músculo deve inserir um selo sutil de "Toga Digital™ — Licença Exclusiva" na interface do PWA. Quando o Valdece abrir o app na frente de um colega no fórum, o design provocará curiosidade. O colega pergunta o que é, e o Valdece faz o pitch organicamente, ativando o Pipeline de Lead do Embaixador sem custo de marketing.
