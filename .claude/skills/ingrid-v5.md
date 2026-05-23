# SKILL: ingrid-v5.md
**Auditor:** NotebookLM · **Loop:** 5 · **Dias:** 12-13 · **Stack:** PWA Vanilla JS + Supabase RPC + WhatsApp API

---

## ANTI-AMNESIA — AUDITORIA DE COERENCIA (ABERTURA)

36 documentos indexados. Mais recentes: 13_PASSO5_NOTEBOOKLM.md, 12_DIRETRIZ_GEMINI.txt (Loop 5), 14_MEMORIA_EMBAIXADOR.md e 04_INTELLIGENCE_LEDGER.md. Loop atual: 5.

**3 PRINCIPAIS RISCOS DE CONSISTENCIA DOCUMENTAL:**

1. Ilusao de Viabilidade Tecnica (Web Push no iOS Safari): A DIRETRIZ_V5 prioriza um Spike de Notificacoes Push via Service Worker. A 14_MEMORIA_EMBAIXADOR.md atesta que a usuario Ingrid e nao-tecnica e repele friccoes (mindset "Caminho Feliz"). O iOS Safari exige a acao manual de "Adicionar a Tela de Inicio" para habilitar Web Push em PWAs. Depender disso sem suporte humano garantira uma falha silenciosa de engajamento no domingo.

2. Anacronismo Contratual Juridico (Status Amarelo): O arquivo oficial em PDF do Termo de Uso esta datado postumamente para 30/05/2026, embora a assinatura real tenha ocorrido em 18/05/2026. A Vanguard Tech segue exposta a um passivo juridico documental nao saneado.

3. Desamparo Aprendido via Contador Punitivo: A formula do Instituto Quadrix estabelece que uma resposta errada anula uma resposta certa. Se a interface exibir nota liquida negativa em vermelho flagrante, a usuario (temperatura VERDE FRAGIL) pode colapsar psicologicamente e abandonar a plataforma.

**MAIOR ALERTA DO LEDGER:**
[P-038] Esgotamento do Banco de Questoes: 460 itens. O Micro-Simulado Dominical DEVE obrigatoriamente reciclar questoes atreladas ao SM-2.

**VERIFICADOR P-045:** MEMORIA_V4: EXISTE | relatorio_V4: EXISTE | Loop 5: DESBLOQUEADO.

---

## PARTE 1 — AUDITORIA DE COERENCIA

Atuando sob os mandatos de Auditor Canonico e Advogado do Processo, cruzo a DIRETRIZ_V5 do Estrategista com as memorias de campo do Embaixador:

- **Consistencia entre documentos:** A DIRETRIZ dita a exploracao de Service Workers de Push. O Embaixador relata perfil avesso a complexidade. Avançar com Push nativo sem garantia do atalho criado no iPhone contradiz a Lei da Simplicidade Extrema do MVP.

- **Conflitos Doc A vs Doc B — O que prevalece:** O Estrategista alocou horas de build para o Spike de Push, mas inteligentemente desenhou o "WhatsApp Shield" como fallback. Prevalece o Fallback Analogico de WhatsApp. Razao canonica documentada no principio [P-030]: O Diretor enviando o link com um clique e 100% a prova de falhas do iOS.

- **LEDGER [SHIELD CONTRATUAL P-026]:** O Termo de Uso da Ingrid tem uma falha material de datas. A ideia [G-4] do Estrategista (Widget Clickwrap Unclog) e a acao tecnica correta para registrar um novo hash legal da assinatura, forcando o saneamento contratual antes de exibir o Score Quadrix.

---

## PARTE 2 — PERSPECTIVA DO SOCIO CONSULTOR

O que o Musculo e o Estrategista estao subestimando nos Dias 12-13:

1. **O que funciona:** A adocao do calculo estatistico estrito da Quadrix (Acertos Peso 2 x 2 + Acertos Peso 1 - Erros). Isso nao e uma feature — e a resolucao literal da Dor P4 ("metodo de avaliar meu rendimento") capturada no Discovery.

2. **Onde diverge:** O Estrategista propoe em [G-3] alterar o peso para "Leis Recentes". O Auditor veta. Isso introduz manipulacao silenciosa na amostra do SM-2 a 3 dias do prazo. Risco de bugs estruturais invisiveis.

3. **Risco central do ciclo:** O vies da punicao grafica. Mostrar a cliente que a nota afundou devido ao fator de correcao gerara panico. O progresso deve ser emoldurado como "Metros Conquistados", nao "Divida Criada".

4. **Decisao pendente (Exclusiva do Diretor):** O Estrategista fixou disparo de notificacao dominical as 09:00. O Diretor Eduardo deve validar pessoalmente se o domingo de manha e a janela de isolamento cognitivo da Ingrid.

5. **Ciclo N vs N-1:** Evoluimos de captura de dados passivos (Loop 4) para sintese ativa de valor (Loop 5). Mas repetimos o vicio de "Momentum de Execucao" apostando em integracoes nativas de SO (Web Push) em vez de focar 100% no motor de calculo.

---

## PARTE 3 — SKILL INGRID-V5 (acionavel)

### CONTEXTO DO PROJETO
PROJ-002 (Ingrid). Status: LIVE. Temperatura: VERDE FRAGIL. Foco absoluto: Implementar o Contador de Pontos Ponderados (Formula Quadrix: Acertos Especificos x 2 + Basicos x 1 - Erros Totais) e garantir o Micro-Simulado Dominical sem atritos no iOS Safari. Deadline: 30/05/2026.

### PADROES E ALERTAS DE VETO (INTELLIGENCE LEDGER)
- [P-045] Veto de Barreira: Zero interfaces de login/senha complexas para a usuario piloto. Acesso via user_id embutido.
- [P-038] Reciclagem Obrigatoria: O Micro-Simulado Dominical NAO PODE drenar questoes ineditas do banco. Motor DEVE puxar exclusivamente questoes ja indexadas pelo SM-2, priorizando as de maior indice de falha (Easiness Factor < 2.0).
- [P-044] Escudo Psicologico de UI: A pontuacao punitiva (erros anulam acertos) NAO deve ser renderizada em cor de alerta (vermelho vivo) se o score for negativo. Exiba como "Territorio a Conquistar".
- [P-023] Trava Contratual (SHIELD): Utilizar o "Widget Unclog" (G-4). O Contador de Pontos fica visualmente desfocado (blur) ate que a usuario clique no banner de confirmacao da nova data do Termo de Uso (18/05), persistindo via RPC no Supabase.

### SEQUENCIA DE BUILD (DIAS 12-13)
- Dia 12 (Backend RPC & Fallback WhatsApp): Construir a Stored Procedure (RPC) no Supabase que emite o Score Quadrix em tempo real. Codificar a string parametrizada (wa.me/...) no Dashboard do Diretor para o "WhatsApp Shield".
- Dia 13 (UI Diario Oficial & Spike de Push): Renderizar o widget do Contador Ponderado no PWA, emulando a diagramacao em colunas do Diario Oficial do DF [G-2]. Rodar Spike tecnico de Web Push no Service Worker; SE a permissao for negada pelo Safari iOS no primeiro teste, abortar e utilizar 100% o Fallback de WhatsApp.

### O QUE NAO CONSTRUIR
- NAO ultrapasse 2 horas debugando permissoes de Web Push em Safari mobile. O "Magico de Oz" via WhatsApp atende a necessidade funcional com risco zero.
- NAO altere a matriz matematica do algoritmo SM-2 [Veto a ideia G-3].
- NAO construa botoes paralelos de reset de progresso do simulado (preservar telemetria historica).

### GATES VERIFICAVEIS
- Dia 12: RPC score_quadrix retorna valor correto via CLI Supabase + link WhatsApp funcional no Dashboard do Diretor.
- Dia 13: Widget do Contador visivel no Header do PWA + Spike Push documentado com resultado (funciona / nao funciona no iOS Safari).

---

## PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR

[N-1] Gatilho de Envio Baseado em Telemetria Temporal Passiva:
A notificacao dominical via WhatsApp nao deve usar gatilho arbitrario as 09:00. Musculo deve expor query lendo o horario_inicio_sessao modal da Ingrid nas ultimas 2 semanas e preparar a string para disparo exatamente 15 minutos antes do pico natural de energia.

[N-2] Reconciliacao Contratual Criptografica:
Expandindo [G-4]: O destravamento do Score Ponderado no front-end deve atrelar a nova string termo_v2_18_05 gerando log de IP e timestamp rigido no Supabase. Sana o anacronismo juridico de forma inquestionavel.

[N-3] Linha de Corte Fantasma (P-041 Subutilizado):
O Score Quadrix solto nao gera a "Cena de Sucesso". A interface deve tracar uma linha pontilhada horizontal exibindo a "Nota de Corte Estimada Historica" (ex: 68 pontos). O instinto de cacadora fara a Ingrid lutar para cruzar essa linha, mobilizando aversao a perda.

[N-4] Rotulo de "Ilusao Estatistica" do Simulado:
Como P-038 obriga reciclagem de questoes, o Score exibira taxa de acertos ligeiramente inflada pela memoria fotografica. Musculo deve injetar tag visual (ex: "Simulado Misto") informando que a nota contem questoes recicladas, impedindo excesso de confianca perigosa.

[N-5] Exportacao Automatica do Card SVG (Comparacao N vs N-1):
Apos renderizar o Score Quadrix no PWA, o sistema converte essa area em elemento visual (SVG/PNG) compartilhavel. Diretor extrai o card (anonimizado) como pilar de Prova Social no pitch de R$ 97/mes para grupo de 500 candidatas B2C.

---

## ALERTAS FINAIS DO AUDITOR

1. Filtro de Realidade do PWA iOS: Se o Diretor nao instruir fisicamente a Ingrid a clicar em "Adicionar a Tela de Inicio", o codigo do Musculo nascera morto. O Fallback de WhatsApp nao e plano B — e o provavel plano A.

2. Escudo Psicologico Quadrix: A interface nao deve subtrair visualmente barras de progresso. Manter barras de acerto e mostrar penalidades como "Carga de Resgate". Agressividade excessiva na UX destroi a temperatura VERDE FRAGIL.

3. Custo de Chamada Socratica: Se o simulado gerar 20 erros que precisam de revisao, acionar Claude Haiku 20 vezes sobrecarregara o Burn Rate Shield. Musculo deve estruturar requisicao batendo primeiro no cache bidimensional (explicacao_tutor) antes de despachar payload a Anthropic.

## PADRAO DE SUCESSO E FALHA — HISTORICO DOS LOOPS

**PADRAO DE SUCESSO validado (Loops 1-4):**
- Loop 2: Feed 70/30 funcional — 7 dias, 0 erros — SM-2 estavel
- Loop 3: Gate Dia 8 APROVADO 2026-05-19 — PWA completo, Clickwrap + Tutor 3 niveis + TTI
- Loop 4: Gate Dia 11 APROVADO 2026-05-20 — Heatmap (Mapa de Soberania) + Micro-Simulado Dominical

**PADRAO DE FALHA registrado:**
- Loop 2: Distratores de qualidade abaixo do padrao Quadrix — corrigido com banco real de questoes
- Loop 4: WIP_BOARD congelado no Loop 2 enquanto build ja estava no Loop 4 — ponto cego metodologico
- Risco ativo Loop 5: Push iOS Safari pode gerar falha silenciosa — Fallback WhatsApp e plano primario
