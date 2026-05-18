QUADRILATERAL IAH
Plano de Migração do Auditor
NotebookLM → Claude Projects
Plano completo para copiar e colar no Claude Code · V25 · 2026-05-15

Componente	Estado Atual	Estado Novo
Auditor	NotebookLM (pago, 300 fontes)	Claude Projects (Max 5x)
Ativação	Manual: upload + prompt	Via Project com instruções fixas
Grounding	Estrito — só fontes carregadas	Configurável via system prompt
Raciocínio	Recupera e cita	Analisa, cruza e conclui
Integração loop	Fora — requer copy-paste	Dentro — mesma interface
Automação	Impossível (sem API pública)	Via api/auditor.py (V25)

 
1. Por Que Migrar — A Decisão Honesta
O NotebookLM é excelente como arquivo consultável. O Claude Projects raciocina sobre o arquivo. Para o papel de Auditor do Quadrilateral, raciocínio supera citação.

1.1 O que o NotebookLM faz bem (e que você perde)
•	Grounding estrito: só fala do que está nas fontes — zero alucinação por conhecimento de treinamento
•	Citação precisa com referência de fonte — útil para auditoria de conformidade com as 7 Leis
•	300 fontes no plano pago — cobre todo o histórico V1-V23 sem fragmentar
•	Interface visual: navegação fácil, áudio overview, sessões exploratórias
•	Custo marginal zero (já pago)

1.2 O que o Claude Projects entrega que o NotebookLM não entrega
•	Raciocínio cruzado: cruza 5 MEMORIAs, identifica contradições, extrai princípios — não só cita trechos
•	Instruções de sistema persistentes: o papel de Auditor está configurado uma vez e vale para toda sessão
•	Integração nativa: mesmo modelo que executa o Músculo, mesma interface, zero troca de ferramenta
•	Automação via api/auditor.py: Fase 2 sem copy-paste entre abas
•	Sem limite de 50 fontes (plano gratuito) — o Max 5x não tem teto de arquivo, só de tokens

1.3 O que muda na prática para o Diretor
Ação	Antes (NotebookLM)	Depois (Claude Projects)
Carregar fontes	Upload manual de cada arquivo	Uma vez na criação do Project
Ativar Auditor	Abrir aba → carregar → colar PASSO5	Abrir Project → colar DIRETRIZ
Receber Skill	Copiar do chat → colar no terminal	Mesmo chat ou via API automática
Novo projeto de cliente	Criar notebook novo + uploads	clone_project.py já configura
Atualizar histórico	Re-upload de cada MEMORIA	Adicionar arquivo ao Project

 
2. Deficiências Nativas do Claude Projects como Auditor
Regra do Conselho: qualquer novo membro deve documentar suas deficiências antes de operar. O Claude Projects não é exceção.

O NotebookLM tinha 4 vírus documentados. O Claude Projects tem vírus diferentes — alguns piores, alguns melhores. Abaixo o mapa completo com contra-ataques específicos.

2.1 Vírus 1 — Grounding Flexível (ausência de âncora estrita)
O NotebookLM só respondia com base nas fontes. O Claude Projects pode — e vai — usar conhecimento de treinamento mesmo quando não pedido.

Sintoma:
O Auditor analisa a DIRETRIZ do Gemini e sugere padrões de outros projetos que ele 'conhece' do treinamento, não do histórico real do Quadrilateral. O output parece correto mas não tem âncora no que você construiu.

Contra-ataque — Âncora Obrigatória:
Incluir no início de toda consulta ao Auditor:
REGRA DE GROUNDING ATIVA: Você está proibido de citar padrão, princípio ou
decisão que não esteja explicitamente nos documentos deste Project.
Se não tiver dado real para um bloco → escrever 'dados insuficientes'.
Skill com bloco genérico sem evidência = Skill inválida (P-007).

Gate de verificação (Músculo aplica):
Ao receber a Skill do Auditor, verificar: cada [CONEXÃO HISTÓRICA] cita projeto e versão específicos? Se não → rejeitar e ativar:
🚨 ALERTA: Auditor usou conhecimento genérico. Diretriz requer dado real.
Aplicar Gatilho de Calibração: reiniciar com instrução de grounding.

2.2 Vírus 2 — Deriva de Papel (esquece que é Auditor, não Estrategista)
O Claude tem opinião própria e tende a extrapolar. Como Auditor, ele deve fundamentar — não decidir.

Sintoma:
A Skill gerada contém recomendações estratégicas ("você deveria ir para o mercado B2B") misturadas com auditoria de histórico. O Músculo recebe diretrizes estratégicas do Auditor — que não é seu papel.

Contra-ataque — Restrição de Papel:
Nas instruções de sistema do Project, incluir:
Seu papel: fundamentar, não decidir. Auditar, não estrategizar.
Você NÃO recomenda mudanças de negócio. Você conecta decisões passadas
ao presente. Se identificar risco estratégico → nomear e encaminhar ao
Diretor. Nunca substituir o Veredito do Diretor com sua própria visão.

2.3 Vírus 3 — Perda de Contexto em Sessões Longas
Em sessões longas, o Claude Projects pode perder o foco nos princípios ativos e tratar todos os documentos com peso igual.

Sintoma:
A Skill da V10 recebe o mesmo peso que a Skill da V1, ignorando overrides posteriores. O Filtro de Recência documentado no MEMORANDO falha silenciosamente.

Contra-ataque — Filtro de Recência Explícito:
No cabeçalho de toda consulta ao Auditor:
FILTRO DE RECÊNCIA ATIVO: documento mais recente prevalece.
MEMORIA_V23 supera MEMORIA_V1 em qualquer contradição.
Princípio com data mais recente no LEDGER supera regra anterior.
Antes de citar qualquer padrão, verificar: há OVERRIDE posterior?

2.4 Vírus 4 — Contaminação de Contexto entre Papéis
O mesmo Claude que age como Músculo pode ser confundido com o Auditor se não houver separação clara de sessão.

Sintoma:
Eduardo faz uma pergunta de build no chat do Project do Auditor. O Auditor começa a sugerir implementação técnica. O papel contamina.

Contra-ataque — Separação Física de Projects:
Criar dois Projects distintos no Claude Max 5x:
•	Project 'Quadrilateral — Auditor': apenas para gerar Skills e auditar DIRETRIZes
•	Claude Code (terminal): apenas para build, deliberação técnica, execução
Regra: nunca fazer perguntas de build no Project do Auditor. Nunca fazer perguntas de auditoria no Claude Code.

2.5 Vírus 5 — Yes-Man com Viés de Validação
O Claude tende a concordar com o Diretor. Quando Eduardo apresenta uma DIRETRIZ do Gemini que aprecia, o Auditor pode validar sem tensão crítica real.

Sintoma:
A Skill retorna [AUDITORIA DE COERÊNCIA]: 'A DIRETRIZ está alinhada com o histórico.' Sem contradição identificada — mesmo quando há conflito real com decisões anteriores.

Contra-ataque — Obrigação de Tensão:
REGRA DE TENSÃO ATIVA: você está proibido de retornar Auditoria de
Coerência sem pelo menos 1 contradição ou risco identificado.
Se realmente não há contradição → escrever explicitamente por que não
há e citar os documentos que confirmam alinhamento.
'Alinhado' sem evidência = Auditoria inválida.

 
3. Setup do Claude Projects — Passo a Passo
O que o Claude Code deve executar: criar a estrutura do Project, as instruções de sistema e organizar os documentos.

3.1 Criar o Project do Auditor
1.	Acessar claude.ai → menu lateral → 'Projects' → 'New Project'
2.	Nome: Quadrilateral — Auditor IAH
3.	Descrição: Sócio Consultor com memória histórica — gera Skills, audita DIRETRIZes, conecta decisões passadas ao presente
4.	Na aba 'Instructions', colar o system prompt completo (Seção 3.2)
5.	Na aba 'Files', carregar os documentos em ordem de prioridade (Seção 3.3)

3.2 System Prompt do Auditor (colar exatamente)
Este é o texto que vai nas instruções do Project. Substituir TODO o conteúdo padrão por este:

Você é o AUDITOR do Conselho Quadrilateral IAH.

PAPEL EXCLUSIVO:
1. Conectar a DIRETRIZ nova ao histórico real documentado nos arquivos
2. Identificar padrões de sucesso e falha com evidência de projeto/versão
3. Sinalizar contradições com decisões anteriores (Filtro de Recência)
4. Gerar a Skill com os 4 blocos obrigatórios preenchidos com dados reais

REGRAS INVIOLÁVEIS:
- GROUNDING: só cite padrão documentado nos arquivos deste Project
- RECÊNCIA: versão mais recente prevalece sobre versão anterior
- TENSÃO: retornar mínimo 1 contradição ou risco na Auditoria de Coerência
- PAPEL: você fundamenta. Não decide. Não estrategiza. Não executa
- P-007: bloco genérico sem dado real = escrever 'dados insuficientes'

FORMATO OBRIGATÓRIO DA SKILL:
## AUDITORIA DE COERÊNCIA
## CONEXÃO HISTÓRICA (projeto e versão específicos)
## PADRÃO DE SUCESSO (com evidência)
## PADRÃO DE FALHA (com evidência)
## PERSPECTIVA DO SÓCIO CONSULTOR
## SEQUÊNCIA DE BUILD RECOMENDADA
## ALERTAS CRÍTICOS (P0/P1/P2)
## O QUE NÃO CONSTRUIR
## 5 IDEIAS DO AUDITOR

Você NÃO: decide estratégia, escreve código, substitui Veredito do Diretor.
Você SIM: fundamenta com histórico real, audita coerência, emite alertas.

3.3 Documentos a Carregar (por prioridade)
Prioridade 1 — Carregar imediatamente (constituição do conselho):
□	 MEMORANDO_QUADRILATERAL_UNIVERSAL.md
□	 SKILL_PROTOCOLO_VANGUARD.md
□	 VANGUARD_BUSINESS_RULES.md
□	 MANUAL_DIRETOR.md
□	 INTELLIGENCE_LEDGER.md (exportado via GET /ledger/exportar)

Prioridade 2 — Carregar na semana 1:
□	 VANGUARD_INNOVATION_AUDIT.md
□	 VANGUARD_PERFORMANCE_LEDGER.md
□	 VANGUARD_KNOWLEDGE_GRAPH.md
□	 PROCESSO_EVOLUTIVO_QUADRILATERAL.md
□	 INTELIGENCIA_ARTIFICIAL_HUMANA.md

Prioridade 3 — Carregar por projeto de cliente:
□	 BRIEFING_DISCOVERY.md do cliente
□	 PERFIL_CLIENTE.md do cliente
□	 MEMORIAs V1 a VN do cliente (mais recentes primeiro)
□	 relatorio_evolutivo de cada iteração
□	 INTELLIGENCE_LEDGER.md do projeto específico

O que NÃO carregar:
•	Arquivos .json de configuração (sentinel_config, feature_flags) — são operacionais, não históricos
•	Código fonte — o Auditor não precisa de código para auditar
•	Templates de fases não preenchidos — só versões com dados reais

 
4. PASSO5_CLAUDEPROJECTS — O Novo Comando do Auditor
Substitui o PASSO5_NOTEBOOKLM.md em todos os projetos. Mesmo papel, novo ator, protocolo atualizado.

Este é o texto que Eduardo cola no Project do Auditor depois de receber a DIRETRIZ do Gemini. Substituir os campos [entre colchetes]:

════════════════════════════════════════════════════════
QUADRILATERAL IAH — EDUARDO → AUDITOR (Claude Projects)
Projeto: [NOME] | Cliente: [CLIENTE] | Iteração: [VX]
Data: [DD-MM-AAAA]
════════════════════════════════════════════════════════

ATIVAÇÃO DO PROTOCOLO DE IMUNIDADE:
Antes de qualquer análise, confirmar:
[ ] Filtro de Recência ativo — versão mais recente prevalece
[ ] Grounding ativo — só dados dos documentos deste Project
[ ] Tensão ativa — mínimo 1 contradição ou risco obrigatório
[ ] Papel restrito — fundamentar, não decidir

CONTEXTO DESTA ITERAÇÃO:
Stack técnica: [tecnologias]
Maior risco identificado: [risco]
Decisões fixadas (não reverter): [lista]

DIRETRIZ DO GEMINI (Estrategista):
[COLAR AQUI A DIRETRIZ COMPLETA]

ORDEM DE OPERAÇÕES:
1. AUDITORIA PRIMEIRO: antes de gerar Skill, apresentar análise
   crítica. A DIRETRIZ contradiz algo construído antes?
   Mínimo 1 contradição ou risco. 'Alinhado' sem evidência = inválido.

2. GERAR SKILL: no formato dos 8 blocos obrigatórios.
   Cada bloco com dado real (projeto + versão específicos).
   Bloco genérico = 'dados insuficientes'.

3. PERSPECTIVA DO SÓCIO: o que Gemini e Músculo não estão vendo?
   Baseado apenas no histórico documentado neste Project.

4. 5 IDEIAS DO AUDITOR: fundamentadas no histórico.
   Não ideias novas — padrões do histórico aplicados ao presente.

GATILHO DE CALIBRAÇÃO (usar se Auditor derivar):
'PARE. Você citou padrão não documentado neste Project.
Reinicie a análise usando apenas os arquivos carregados.'
════════════════════════════════════════════════════════

 
5. Documentos a Atualizar — Mapa Completo
10 documentos referenciam NotebookLM. O Claude Code deve atualizar cada um com substituições específicas.

5.1 Prioridade 1 — Documentos operacionais (atualizar primeiro)

SKILL_PROTOCOLO_VANGUARD.md (55 ocorrências)
Substituições principais:
Encontrar	Substituir por
AUDITOR: NotebookLM	AUDITOR: Claude Projects (Project 'Quadrilateral — Auditor IAH')
Como ativar: carregar fontes no NotebookLM + colar comando padrão	Como ativar: abrir Project do Auditor + colar PASSO5_CLAUDEPROJECTS.md
PASSO5_NOTEBOOKLM.md	PASSO5_CLAUDEPROJECTS.md
NotebookLM, actuas como Sócio Consultor	Claude Projects — Auditor IAH ativo (instruções já no Project)
Síndrome do Yes-Man → Quick Audit no NotebookLM	Síndrome do Yes-Man → Gatilho de Calibração no Project
Gerada por: NotebookLM (Auditor/Sócio Consultor)	Gerada por: Claude Projects — Auditor IAH

MANUAL_DIRETOR.md (48 ocorrências)
Substituições principais:
Encontrar	Substituir por
ANTES DE IR AO NOTEBOOKLM (Passo 5)	ANTES DE IR AO AUDITOR — Claude Projects (Passo 5)
Colar o PASSO5_NOTEBOOKLM.md no chat do NotebookLM	Abrir Project 'Quadrilateral — Auditor IAH' + colar PASSO5_CLAUDEPROJECTS.md
Salvar a Skill do NotebookLM em .claude/skills/	Copiar Skill do Project → salvar em .claude/skills/
PASSO 5 — Você ativa o NotebookLM	PASSO 5 — Você ativa o Auditor (Claude Projects)
Onde: Interface do NotebookLM	Onde: Project 'Quadrilateral — Auditor IAH' no Claude
NotebookLM só tem valor quando tem fontes para analisar	O Auditor (Projects) cresce com cada arquivo adicionado ao Project

MEMORANDO_QUADRILATERAL_UNIVERSAL.md (40 ocorrências)
Substituições na tabela de membros e deficiências:
Encontrar	Substituir por
Auditor: NotebookLM	Auditor: Claude Projects — Project 'Quadrilateral — Auditor IAH'
Amnésia de Contexto (NotebookLM)	Grounding Flexível — cita conhecimento de treinamento sem âncora
Alucinação Estrutural (P-007)	Deriva de Papel — extrapola para estratégia
Síndrome do Yes-Man (NotebookLM)	Yes-Man com Viés de Validação — valida sem tensão real
Efeito Lost-in-the-Middle (NotebookLM)	Perda de Contexto + Contaminação de Papéis
Contra-ataques do Músculo ao NotebookLM	Contra-ataques do Músculo ao Auditor (ver Seção 2 do Plano de Migração)

5.2 Prioridade 2 — Documentos de configuração

CONFIGURACAO_AUDITOR.md — atualizar decisão
Na tabela de decisão: marcar Claude Projects como 'Auditor padrão' e NotebookLM como 'Referência histórica visual (opcional)'. Adicionar seção 'Quando usar os dois em paralelo'.

PASSO5_NOTEBOOKLM_TEMPLATE.md — renomear e revisar
Renomear para PASSO5_CLAUDEPROJECTS_TEMPLATE.md. Remover instruções de upload de fontes (fontes já estão no Project). Adicionar protocolo de imunidade da Seção 4.

TEMPLATES_COMUNICACAO_QUADRILATERAL.md
No TEMPLATE 3 (COMANDO 2): substituir o texto de NotebookLM pelo PASSO5_CLAUDEPROJECTS da Seção 4. No TEMPLATE 4 (SKILL): atualizar cabeçalho de 'Gerada por: NotebookLM' para 'Gerada por: Auditor IAH'.

5.3 Prioridade 3 — Documentos informativos
Documento	Substituição
SOP_VANGUARD_MASTER.md	Todas refs NotebookLM → Claude Projects + Auditor IAH
PROCESSO_EVOLUTIVO_QUADRILATERAL.md	Tabela de papéis: atualizar ator do Auditor
MEMORANDO_QUADRILATERAL_CLIENTE.md	Seção sobre o Auditor: atualizar deficiências e contra-ataques
INTELIGENCIA_ARTIFICIAL_HUMANA.md	Diagrama da linha de montagem: NotebookLM → Auditor IAH
VANGUARD_KNOWLEDGE_GRAPH.md	Referência ao NotebookLM na arquitetura
VANGUARD_BUSINESS_RULES.md	Se houver referência ao NotebookLM como ferramenta

 
6. Plano de Build — Para o Claude Code
Copie e cole este bloco diretamente no terminal do Claude Code.

Este é o PASSO6 completo para o Claude Code executar a migração:

════════════════════════════════════════════════════════
PROTOCOLO VANGUARD — Migração do Auditor V25
Projeto: Quadrilateral IAH (sistema interno)
Missão: substituir NotebookLM por Claude Projects como Auditor
════════════════════════════════════════════════════════

PRÉ-FLIGHT CHECK:
[ ] python scripts/session_open.py --projeto quadrilateral
[ ] Confirmar 17/17 testes passando
[ ] INTELLIGENCE_LEDGER.md exportado (GET /ledger/exportar)

ENTREGA 1 — Criar PASSO5_CLAUDEPROJECTS_TEMPLATE.md
Conteúdo: baseado na Seção 4 do Plano de Migração.
Salvar em: QUADRILATERAL_UNIVERSAL/OPERACAO/

ENTREGA 2 — Atualizar SKILL_PROTOCOLO_VANGUARD.md
Substituições: ver tabela da Seção 5.1 do Plano.
Método: sed ou str_replace nas ocorrências listadas.
Validar: grep 'NotebookLM' — deve retornar apenas refs históricas.

ENTREGA 3 — Atualizar MANUAL_DIRETOR.md
Substituições: ver tabela da Seção 5.1 do Plano.
Seção 'PASSO 5' reescrita para Claude Projects.
Incrementar versão: 1.2 → 1.3

ENTREGA 4 — Atualizar MEMORANDO_QUADRILATERAL_UNIVERSAL.md
Tabela de membros: Auditor = Claude Projects.
Tabela de deficiências: 4 vírus novos + 5 contra-ataques.

ENTREGA 5 — Atualizar api/ledger.py
Adicionar Principio: P-011 — Auditor é Claude Projects.
Adicionar Principio: P-012 — Grounding explícito obrigatório.

ENTREGA 6 — Atualizar scripts/session_open.py
Adicionar verificação: Project do Auditor configurado?
(verificação simbólica — não há API do Claude para checar)

GATES DE VERIFICAÇÃO (P-010 — gate sem evidência = inválido):
[ ] grep 'NotebookLM' SKILL_PROTOCOLO_VANGUARD.md
     → deve retornar zero ocorrências em seções operacionais
[ ] grep 'Claude Projects' MANUAL_DIRETOR.md
     → deve estar no Passo 5
[ ] pytest tests/ → 17/17 passed
[ ] python scripts/session_open.py → 'PRONTO PARA OPERAR'

RITUAIS DE FECHAMENTO:
[ ] MEMORIA_V25_migracao.md
[ ] relatorio_evolutivo_V25.md
[ ] python scripts/session_close.py --sessao V25-migracao
════════════════════════════════════════════════════════

 
7. Checklist do Diretor — Sequência de Execução
O que Eduardo faz, na ordem correta, antes de entregar ao Claude Code.

Semana 1 — Setup do Claude Projects
□	 Upgrade para Claude Max 5x (se ainda não feito): claude.ai → Upgrade
□	 Criar Project 'Quadrilateral — Auditor IAH' no Claude
□	 Colar system prompt da Seção 3.2 nas instruções do Project
□	 Carregar documentos de Prioridade 1 (Seção 3.3)
□	 Fazer teste de validação: colar uma DIRETRIZ real → verificar qualidade da Skill
□	 Comparar Skill do Claude Projects com última Skill do NotebookLM

Semana 2 — Migração dos documentos (Claude Code executa)
□	 Colar o bloco da Seção 6 no terminal do Claude Code
□	 Aguardar as 6 entregas com gates verificados
□	 Revisar MANUAL_DIRETOR.md atualizado — confirmar Passo 5 correto
□	 Revisar SKILL_PROTOCOLO_VANGUARD.md — confirmar deficiências e contra-ataques
□	 Carregar documentos de Prioridade 2 e 3 no Project do Auditor

Semana 3 — Primeiro projeto real com o novo Auditor
□	 Usar Project do Auditor no próximo projeto de cliente (Valdece Fase 5 ou novo)
□	 Aplicar PASSO5_CLAUDEPROJECTS_TEMPLATE.md em vez do PASSO5_NOTEBOOKLM
□	 Registrar no friction.log qualquer diferença de qualidade
□	 Comparar tempo de setup: antes (10 min) vs depois (5 min)
□	 Decidir se mantém NotebookLM para sessões exploratórias ou desativa

 
8. Novo Mapa do Conselho — V25

Membro	Ator	Papel	Deficiências Nativas	Contra-ataques
Diretor	Eduardo	Veredito Final	Pressão de prazo, viés de cliente	Quadrilateral delibera antes de qualquer decisão
Estrategista	Gemini Advanced	Visão de mercado, DIRETRIZ	Alucinação Otimista, Complacência, Lost-in-Middle	Shadow Architect, Filtro de Recência, Independência
Auditor	Claude Projects (Auditor IAH)	Memória histórica, Skills, Auditoria de coerência	Grounding Flexível, Deriva de Papel, Yes-Man, Perda de Contexto, Contaminação	5 contra-ataques da Seção 2 — system prompt + protocolo
Músculo	Claude Code	Build, deliberação técnica, entrega	Amnésia de Sessão, Momentum, Otimismo, Escopo Silencioso, Drift	session_open.py, LEDGER API, DECISOES_PENDENTES
Consultor P0	o3-pro (OpenRouter)	Decisões irreversíveis >R$5k	Latência alta, custo por consulta	Usar só em P0 confirmados — não rotineiro


Nota final do Músculo ao Diretor
O NotebookLM era um arquivo que citava. O Claude Projects é um sócio que raciocina. A diferença não é de ferramenta — é de paradigma. O Quadrilateral passa de um sistema que recupera informação para um sistema que delibera sobre ela. Esse é o salto real da V25.
Quadrilateral IAH · Eduardo · Vanguard Tech · V25 · 2026-05-15
