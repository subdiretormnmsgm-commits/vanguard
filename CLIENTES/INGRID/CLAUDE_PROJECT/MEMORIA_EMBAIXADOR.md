# MEMORIA_EMBAIXADOR — PROJ-002 INGRID
> Estrutura em 3 camadas — aprovada pelo Diretor em 2026-05-19
> **CAMADA_FATOS:** dado bruto e verbatim. Zero interpretação. Auditor lê esta camada diretamente.
> **CAMADA_INFERENCIA:** análise do Embaixador. Ler sabendo que é opinião fundamentada.
> **CAMADA_DECISAO:** deliberações formais do Conselho. Verdades acordadas do projeto.
> Versão: Loop 8 · 2026-06-04 — P-032 atualizado pelo Músculo

---

## CAMADA_FATOS

### CLIENTE — dados objetivos

- **Nome:** Ingrid
- **Cargo-alvo:** TDAS Cargo 202 (Técnico Administrativo) — Sedes-DF 2026
- **Banca:** Instituto Quadrix
- **Data da prova:** 2026-09-06 (~111 dias a partir de 2026-05-18)
- **Canal principal de contato:** WhatsApp

### CONTATOS REGISTRADOS

| Data | Canal | Evento objetivo | Fonte |
|---|---|---|---|
| 2026-06-04 | Embaixador | **Loop 8 processado** — Temperatura 8.5/10 QUENTE. Pitch janela fecha ~04/07. 5 decisões D1-D5 pendentes de veredito do Diretor. D4 urgente: 11 dias sem contato humano. | Embaixador Loop 8 |
| 2026-06-01 | WhatsApp | **D3 respondido** — Ingrid confirmou: está realizando o acesso e está gostando. Cenário A confirmado (engajada, ativa, não desengajada). | Ingrid via Diretor |
| 2026-06-01 | WhatsApp | **D3 enviado** — debrief casual: "Aquela configuração ficou perfeita. Como você tá se sentindo com o estudo essa semana? 📚" | Diretor |
| 2026-05-30 | WhatsApp | Veredito: Enviar debrief casual amanhã — coletar temperatura real (PITCH-WATCH — janela R$97/mês: aberta, gatilho não acionado) | VEREDITOS_INGRID_2026-05-30.json |
| 2026-05-16 | WhatsApp | Termo enviado para assinatura | Diretor |
| 2026-05-18 | WhatsApp | Termo assinado por Ingrid | Diretor (confirmado 2026-05-19) |
| 2026-05-18 | App (PWA) | Primeira sessão real — Gate Dia 8 | Ingrid |
| 2026-05-23 | WhatsApp (via Diretor) | Link do app reenviado — reengajamento pós-Loop 5 | Diretor |
| 2026-05-24 | WhatsApp | Ingrid enviou mensagem espontânea — usou simulado, sinalizou retorno amanhã | Ingrid |
| 2026-05-26 | WhatsApp | Ingrid viu documento (Termo 18/05) — confirmado recebido | Diretor |
| 2026-05-26 | WhatsApp | Eduardo plantou lead D4:A — Ingrid respondeu "não conhece ninguém prestando concurso" | Diretor |
| 2026-05-27 | WhatsApp | Reassinatura física do Termo confirmada pelo Diretor — LEGAL-WATCH VERDE | Diretor |

### FALAS VERBATIM DE INGRID

| Data | Canal | Fala exata | Contexto |
|---|---|---|---|
| 2026-05-18 | Via Diretor | *"Gostou muito do aplicativo, só fez essa ressalva: Na questão 18, não houve palavra destacada em negrito, como informava o enunciado."* | Primeira sessão real — Gate Dia 8 |
| 2026-05-24 | WhatsApp direto | *"Boa noite, Eduardo! Fiz um simulado agora e gostei bastante. Amanhã volto ao app para atacar mais um pouco das questões!"* | Pós-reenvio do link (2026-05-23) — contato espontâneo noturno |
| 2026-05-26 | WhatsApp (via Diretor) | *"[não conhece ninguém que esteja fazendo concurso]"* | Resposta ao plantio de lead D4:A — "Você conhece mais alguém prestando concurso esse ano?" |

### EVENTOS OBSERVÁVEIS

| Data | Evento | Detalhe factual |
|---|---|---|
| 2026-05-18 | Termo assinado | Data no corpo do PDF: **30/05/2026** — Eduardo confirmou assinatura em **18/05/2026** — inconsistência documental ativa |
| 2026-05-18 | Primeira sessão real | Chegou até pelo menos a questão 18 |
| 2026-05-18 | Bug identificado | Questão 18 — negrito ausente no enunciado que o referenciava |
| 2026-05-19 | Bug corrigido | Fix deployado em GitHub Pages (commit da9887a) |

### ESTADO DO PRODUTO (fatos técnicos)

| Campo | Estado | Data |
|---|---|---|
| Gate atual | Loop 7 — Todos os 15 dias aprovados · Gate dia15 APROVADO 2026-05-30 | 2026-05-30 |
| Versão em produção | v20 — F-1/F-2/F-5/F-7/F-8 ativos · F-4/F-6 deploy CLI pendente | 2026-05-28 |
| Questões no banco | 460+ — Cargo 202 SEDES-DF | 2026-05-18 |
| App no ar | https://subdiretormnmsgm-commits.github.io/vanguard/ | 2026-05-18 |
| Fix renderização negrito | Deployado | 2026-05-19 |
| G-5 Socrática Pânico | Deployado (bug de ordem de lógica corrigido) | 2026-05-23 |
| G-3 Badge Vacina | Deployado (passivo — aparece quando feed inclui questão vacina) | 2026-05-23 |
| Contador de Erros Cumulativo | Deployado (gauge visual ativo) | 2026-05-23 |
| Deploy pipeline (P-056) | gh-pages branch sincronizada — script `deploy_ingrid_ghpages.ps1` ativo | 2026-05-23 |

### HIPÓTESES RESOLVIDAS — evidência factual

| # | Hipótese | Status | Evidência factual |
|---|---|---|---|
| H-1 | Não assinou por esquecimento — não por hesitação | **CONFIRMADA** | Assinou em ~48h sem questionamento, negociação ou pedido de desconto |
| H-2 | Medo financeiro causou hesitação | **REFUTADA** | Piloto R$0 — sem gatilho financeiro presente |
| H-3 | Compararia o app com TEC Concursos na primeira sessão | **REFUTADA** — encerrada 2026-05-30 | TEC nunca mencionado em nenhuma sessão documentada. Hipótese encerrada definitivamente. |
| H-4 estendida | SM-2 nas sessões 3-5 — dificuldade crescente = abandono? | **REVISADA — BAIXO RISCO** | D3 respondido 2026-06-01: Ingrid confirma acesso ativo e que está gostando. SM-2 crescente não causou abandono. Engajamento sustentado confirmado. |

---

## CAMADA_INFERENCIA

### HIPÓTESES ATIVAS

| # | Hipótese | Status | Base de inferência |
|---|---|---|---|
| H-5 | Pode compartilhar login com familiar ou colega | **IMPROVÁVEL — REVISADA** | D4:A: não conhece ninguém prestando concurso → rede social de concurso = zero por enquanto |
| H-6 | Teto receptivo real pode ser R$150/mês, não R$97 | PENDENTE | Embaixador: "esperança não regateia" |
| H-7 | Lê enunciados com atenção literal — Quadrix mindset nativo | **CONFIRMADA — Loop 6** | Notou discrepância Q18 + espontaneamente retornou para "atacar mais questões" — mindset concurseiro nativo sem que o app precisasse induzir |
| H-8 | "Atacar" = shift de player — pré-comprometimento com aprovação | **NOVA — Loop 6** | Fala espontânea 2026-05-24: "Amanhã volto para atacar mais" — verbo ativo, não ansioso. Embaixador: shift de "sobreviver ao material" para "atacar o placar" |

### TEMPERATURA DO CLIENTE

```
TEMPERATURA_PONDERADA: 8.5/10 — VERDE FORTE (D3 respondido 2026-06-01 — Ingrid confirmou acesso ativo e que está gostando)
Ingrid passou de "tentando sobreviver ao material" para "atacando o placar" (P-079). H-8 CONFIRMADA.
H-4 REVISADA: SM-2 crescente não causou abandono. Engajamento sustentado pós-dificuldade = produto validado.
Cenário A CONFIRMADO: silêncio era confiança no processo, não desengajamento. Cliente ativa, não fugindo.
Janela de pitch R$97/mês: AQUECIDA — Ingrid verbalizou satisfação com o produto. Próximo gatilho: uso 7 dias consecutivos verbalizado ou Eduardo propõe formalmente.
CHURN-WATCH: DESATIVADO. [DATA-GAP-WATCH]: ENCERRADO — uso confirmado verbalmente.
SCOPE-WATCH: DESATIVADO — sem rede de concurso no curto prazo. Pipeline pós-aprovação.
LEGAL-WATCH: VERDE — P-013 VERDE 2026-05-30. P-023 VERDE.
[DADOS-WATCH]: VERDE — 102 respostas · 1 user_id correto.
[DEPLOY-WATCH]: VERDE — Gate 7.1 APROVADO 2026-06-01. 3 Edge Functions em produção: notificar-progresso + gatilho-temporal (19h45 BRT diário) + relatorio-semanal (domingo 10h). pg_cron ativo em yjqvjhezwhepwomukudt.
[GITHUB-WATCH]: VERDE — token sbp_ revogado + alerta GitHub dispensado — 2026-06-01.
[PITCH-WATCH]: AQUECIDO — D3 respondido 2026-06-01. Ingrid ativa e satisfeita. Missão de apropriação recomendada antes do Loop 8.
Padrão: estuda à noite (~20h). F-6 relatório semanal = coração do argumento R$97/mês.
Última atualização: 2026-06-01 (Músculo P-032 — D3 respondido · Cenário A confirmado · Temperatura 8.5)
```

### PADRÕES INFERIDOS — atualizar com cada sessão real

- **Mais analítica do que o registrado anteriormente:** leu o enunciado inteiro da questão 18 e notou discrepância precisa — comunicação de QA, não de cliente comum
- **Não compara com concorrentes:** no Gate Dia 8, TEC não foi mencionado — pode ter descolado cognitivamente ou o app criou identidade própria suficiente
- **Feedback acionável e específico:** não diz "tá estranho" — diz "questão 18, negrito ausente, como informava o enunciado." Precisa de precisão
- **Tom que funciona:** caloroso, direto, sem jargão técnico
- **Tom que não funciona:** formal, técnico, longo

### INTELIGÊNCIA DO EMBAIXADOR — Loop 4 PRÉ-BUILD [E-1 a E-5] (Gate Dia 8 · 2026-05-19)

| # | Insight | Ação prescrita |
|---|---|---|
| E-1 | Ingrid validou o moat do produto sem saber: leitura literal = musculatura Quadrix em treinamento | Documentar como prova social âncora: *"começou a notar detalhes da banca que não notava no TEC"* |
| E-2 | Resolução do bug em 24h = transição de cliente para parceira do produto | Enviar mensagem BLOCO 7 (Camada Decisão) imediatamente após fix deployado |
| E-3 | Não comparou com TEC → argumento comparativo não precisa aparecer no pitch | Revisar 04_PROPOSTA_COMERCIAL.md: retirar tabela comparativa do bloco principal |
| E-4 | KPI do R$194k: timestamp da questão 18 vs. primeiro acesso = primeiro dado real de engajamento EdTech | Músculo: query `progresso_usuario` WHERE `user_id = Ingrid` ORDER BY `created_at` |
| E-5 | Princípio: primeiro feedback espontâneo de piloto vale mais que qualquer pesquisa de mercado | Candidato P-046 ao LEDGER |

### INTELIGÊNCIA DO EMBAIXADOR — Loop 5 SEÇÃO D (2026-05-25)

**PAINEL DE DELIBERAÇÃO — 5 decisões geradas pelo Embaixador (veredito do Diretor pendente):**

| Código | Tema | Opção A | Opção B | Opção C | Recomendação Embaixador |
|---|---|---|---|---|---|
| D1 | LEGAL-WATCH | WhatsApp + novo PDF datado 18/05 | Clickwrap UI — bloqueia Contador | Registro formal via Músculo | **A** — B vetado: Ingrid ignora modal ou abandona. A é invisível para ela. |
| D2 | GATE-WATCH | Deploy completo + offboarding 28-29/05 | Escopo reduzido para caber | Extensão do deadline | **A** — Ingrid em VERDE; momento de fechar forte. Deadline é real. |
| D3 | PRODUTO G-1+G-3 | VETO total ambas → backlog V2 | G-3 suave sem punição | Aguardar TTL de dados | **A** — Ingrid em VERDE FRÁGIL; qualquer feature punitiva ou especulativa é risco de churn silencioso. |
| D4 | PIPELINE | Plantar "conhece alguém?" na próxima mensagem | Esperar orgânico | Já foi mencionado | **A** — temperatura VERDE antes do pitch de cobrança = momento ideal para plantio de lead. |
| D5 | N-3 LINHA DE CORTE | Validar 72 pts com histórico → build | Faixa estimada (65-80) | Não implementar | **A** com ressalva: validar o número real antes de commitar no código. |

**Vetoes e alertas críticos do Embaixador — Loop 5 SEÇÃO D:**
- VETO G-1 (Badge Vacina): feature de compliance disfarçada de gamificação — Ingrid não vai entender o meta
- VETO G-3 (Bloqueio por desatenção): confirmado de Loop 4 — churn garantido para perfil Ingrid
- VETO Horário fixo 09h push: sem base empírica; horário real de Ingrid = noturno (~20h conforme fala verbatim)
- ALERTA iOS Web Push: Apple bloqueia nativamente; fallback WhatsApp é mais confiável que qualquer Service Worker
- CONFIRMA N-2 Clickwrap-Unclog: mata passivo jurídico sem atrito visível — melhor que B de D1
- CONFIRMA N-3 Linha de Corte: aversão à perda converte número frio em caça à vaga — alinha P-041
- CONFIRMA N-5 html2canvas: SVG no cliente sem token de backend — custo zero, pitch SaaS

### INTELIGÊNCIA DO EMBAIXADOR — Loop 6 SEÇÃO D (2026-05-27) · REAÇÃO AO PENTALATERAL

| # | Insight | Ação prescrita |
|---|---|---|
| E-1 | Contato espontâneo é o dado de maior valor — o que fez Ingrid voltar? Provavelmente o Contador de Pontos (novo). Identificar qual feature ativou o retorno antes do próximo contato. | Gate: verificar dados antes de contato. Após DADOS-WATCH resolvido → Eduardo pergunta casualmente "o que você achou do contador de pontos?" |
| E-2 | "Atacar" = shift de player — pré-comprometimento com aprovação. Timing ideal para pitch V2 quando chegar o momento. Não queimar agora — DADOS-WATCH bloqueia. | Aguardar DADOS-WATCH + LEGAL-WATCH VERDE confirmado antes de pitch V2. |
| E-3 | Ingrid precisa de espelho confirmando trajetória — Sentinel Report parcial é a peça ausente. Um número real ("você acertou X% das questões Quadrix nos últimos 7 dias") vale mais que qualquer mensagem motivacional. | Músculo: gerar Sentinel Report parcial com dados reais de Ingrid após resolução do DADOS-WATCH. |
| E-4 | Semente de indicação pós-aprovação — plantar agora, colher depois: "Quando você passar, vou ter o sistema pronto para quem você indicar." Zero pressão agora, aciona circuito de antecipação. | Eduardo planta frase na próxima mensagem após DADOS-WATCH resolvido. |
| E-5 | Saudação noturna personalizada: "Boa noite — 20 questões te esperam" = âncora de hábito. Uma linha de código. Ativa o circuito certo (ritual noturno) sem push nativo (Apple bloqueia). | Músculo: implementar saudação dinâmica por horário de acesso ao app — Loop 6 build. |

**PAINEL DE DELIBERAÇÃO — Loop 6 (veredito do Diretor pendente):**

| Código | Tema | Opções | Recomendação Embaixador |
|---|---|---|---|
| P0 | DADOS-WATCH | A) Músculo verifica user_id das 470 respostas agora \| B) Suspender comunicação até próxima sessão \| C) Diretor declara dados confiáveis | **A** — resolver antes de qualquer contato com Ingrid |
| P1 | LEGAL-WATCH | A) Aguardar Ingrid imprimir e assinar (disse que faria) \| B) Avançar pitch V2 \| C) Novo contato antes de 31/05 | **A** com prazo — se não assinar até 31/05, acionar C |
| PRINCIPIO | Candidato ao LEDGER | A) APROVADO — inscrever LEDGER \| B) APROVADO COM AJUSTE \| C) ADIADO | Pendente veredito |
| D3_VANGUARD | Insight sobre a empresa | A) Diretor registra \| B) Descarta | Pendente veredito |

**Alertas do Embaixador — Loop 6:**
- [DADOS-WATCH] ATIVO: 470 respostas migradas podem estar sob user_id incorreto — SM-2 pode estar calibrado para usuário fantasma. Gate bloqueante antes de qualquer comunicação de progresso.
- CONFIRMA shift de player: "atacar" ≠ linguagem ansiosa. Momento de pré-comprometimento, não de cobrança.
- CONFIRMA saudação noturna como âncora de hábito (E-5 — feature de baixo custo, alto impacto).
- ALERTA pitch V2: não queimar agora — DADOS-WATCH + LEGAL-WATCH precisam estar VERDES primeiro.

### INTELIGÊNCIA DO EMBAIXADOR — Loop 4 DELIBERAÇÃO [E-1 a E-5] (2026-05-20)

| # | Insight | Ação prescrita |
|---|---|---|
| E-1 | Horário de pico de Ingrid desconhecido — Q18 não captura horário. Se estuda às 22h, Simulado Dominical 10h pode ser feature desperdiçada. | Eduardo pergunta no check-in 2026-05-21: "Você estuda mais de manhã, tarde ou noite?" |
| E-2 | Q18 sem pausa = estado de fluxo. Risco não é login quebrando acesso — é qualquer interrupção técnica visível quebrar a imagem do app. Fallback deve ser invisível para Ingrid. | Músculo: garantir que modo passivo (fallback de fadiga) seja indistinguível do modo ativo. |
| E-3 | Ingrid precisa de "você está no seu melhor momento hoje" — confirmação de progresso, não alerta de risco. Heatmap de urgência cobre ameaça; falta cobrir conquista. | Músculo: adicionar feedback positivo pós-sequência de acertos ("Você acertou as últimas 4 — esse é seu ritmo"). |
| E-4 | Campo `horario_inicio_sessao` não existe no schema. Padrão noturno de Ingrid (provável) é argumento de pitch: "feito para quem estuda depois das 20h." | Avaliar antes do Gate Dia 15 se vale incluir timestamp de sessão no schema. |
| E-5 | Mensagem semanal de Eduardo com número de questões via WhatsApp (não push do app) ativa circuito de responsabilidade social além de progresso pessoal. Custo: 30s/semana. | Diretor autoriza protocolo de envio semanal — Músculo já tem `get_total_respostas`. |

### ALERTAS DO EMBAIXADOR — Loop 4 Deliberação (2026-05-20)

- **VETO [G-3] Persona Sargento:** ALERTA CRÍTICO — confronto verbal por TTI baixo vai gerar estresse que Ingrid não nomeia mas abandona silenciosamente. Ingrid não vai reclamar — vai sumir.
- **ALERTA [G-2] Distrator Assombração:** adiar para V2 — perfil de Ingrid é de quem quer superar erro, não ser confrontada repetidamente por ele.
- **CONFIRMA [P-045] veto ao login:** Q18 confirma engajamento real — qualquer atrito de acesso neste momento é risco genuíno.
- **Heatmap linguagem:** enquadrar disciplinas soberanas como "território conquistado", nunca "baixa prioridade".
- **Simulado Dominical:** não construir antes de confirmar horário de estudo de Ingrid (check-in 2026-05-21).

### WATCHDOG

| Flag | Status | Ação se não resolvido |
|---|---|---|
| [CHURN-WATCH] | **DESATIVADO** — Ingrid retornou espontaneamente em 2026-05-24 | Rearmar se silêncio > 3 dias |
| [QA-WATCH] negrito questão 18 | RESOLVIDO | Fix deployado 2026-05-19 |
| [SCOPE-WATCH] H-5 compartilhamento | DESATIVADO — Ingrid não conhece ninguém prestando concurso. H-5 = IMPROVÁVEL. | Rearmar se Ingrid mencionar colega usando o app |
| [LEGAL-WATCH] Termo data | **VERDE** — Reassinatura física confirmada pelo Diretor em 2026-05-27 | Encerrado |
| [DEPLOY-WATCH] gh-pages branch | RESOLVIDO — P-056 documentado | Script deploy_ingrid_ghpages.ps1 ativo |
| [TESTE-WATCH] Features Loop 5 | RESOLVIDO — Ingrid retornou e usou o simulado espontaneamente (2026-05-24) | Encerrado |
| [DADOS-WATCH] user_id | **VERDE** — 102 registros · 1 user_id correto · verificado 2026-05-28 | Encerrado |
| [DEPLOY-WATCH] F-4/F-6 | **VERDE** — 3 Edge Functions ativas em produção + pg_cron ativo (2026-06-01) | Encerrado |
| [GITHUB-WATCH] push bloqueado | **VERDE** — token revogado + alerta dispensado (2026-06-01) | Encerrado |
| [PITCH-WATCH] R$97/mês | **AQUECIDO** — D3 respondido 2026-06-01: Ingrid ativa e satisfeita · Cenário A confirmado · janela aberta para formalização | Ativo |
| [Gate dia15] Supabase Ingrid | **APROVADO** 2026-05-30 — Ingrid admin do próprio Supabase (P-013 VERDE) | Encerrado |

### PIPELINE COMERCIAL

| Produto | Valor | Gatilho verbal de Ingrid | Timing |
|---|---|---|---|
| Piloto atual | R$0 | — | Ativo |
| SaaS V2 | R$97/mês | "tô conseguindo estudar todo dia" ou verbalizar progresso | Entre Gate Dia 8 e 2026-06-15 |
| SaaS V2 upsell | R$150/mês | Ingrid não piscar no R$97 | Avaliar no momento do pitch |

**Abertura do pitch:** *"Ingrid, esse ciclo foi piloto. Quero continuar do seu lado até o dia da prova — R$97/mês, menos que qualquer cursinho, e o sistema já te conhece. Quer continuar?"*

**Inteligência de pipeline — D4:A (2026-05-26):**
- Eduardo plantou: *"Você conhece mais alguém prestando concurso esse ano?"*
- Ingrid respondeu: não conhece ninguém
- **Implicação:** Ingrid estuda em isolamento — sem grupo de estudo, sem rede de concurso. Pipeline de indicação = zero no curto prazo.
- **Contra-intuição:** ausência de rede é também ausência de concorrente social (ninguém para comparar o app com ela). Ela não vai ouvir "TEC é melhor" de colega.
- **Próximo gatilho de pipeline:** avaliar após aprovação — momento de expansão de rede em comunidades de servidores (pós-nomeação = momento de maior vaidade e compartilhamento).

### INTELIGÊNCIA DE MERCADO — D2 (EdTech-Concurso)

> Mandato 12 do Embaixador. Última atualização: 2026-05-23 (Loop 5).

#### SUBSTITUTOS DIRETOS

| Produto | Preço estimado | O que faz | Ponto fraco |
|---|---|---|---|
| TEC Concursos | ~R$50–90/mês | Questões por filtro manual + gabarito | Sem repetição espaçada; sem adaptação por banca; questões genéricas por cargo |
| QConcursos | ~R$50–80/mês | Simulados + estatísticas de acerto | Sem personalização SM-2; sem feed dinâmico por peso |
| Gran Cursos Online | ~R$70–130/mês | Videoaulas + questões | Foco em conteúdo, não em prática adaptativa |
| Estratégia Concursos | ~R$90–150/mês | Videoaulas + resolução comentada | Idem Gran — conteúdo, não prática |

**Diferencial defensável da Vanguard:**
- SM-2 real — cada questão tem intervalo de revisão calculado por acerto/erro pessoal da Ingrid
- Feed ponderado (Peso 2 = disciplinas críticas para o cargo) — nenhum concorrente faz isso por cargo
- G-5 Socrática Pânico — intervenção pedagógica em crise de erros, não punição
- Corpus curado Quadrix SEDES-DF 2026 — nenhum concorrente tem esse recorte

#### DADOS DE MERCADO CAPTURADOS

| Data | Evento | Dado de mercado inferido |
|---|---|---|
| 2026-05-18 (Gate Dia 8) | Ingrid não mencionou TEC Concursos em nenhum momento da sessão | App criou identidade própria — ausência de comparação é sinal de posicionamento conquistado |
| 2026-05-18 | Ingrid reportou bug de negrito com precisão técnica | Perfil exigente — não vai tolerar produto que regride; bar de qualidade alto para manter o posicionamento |

#### POSICIONAMENTO VANGUARD NO MERCADO

```
ARGUMENTO DE PREÇO (quando chegar a hora do pitch):
"R$97/mês é menos que uma plataforma genérica. A diferença: esse sistema
já sabe qual disciplina te custa mais pontos no Quadrix. Nenhum TEC faz isso."

ARGUMENTO DIFERENCIAL:
"O TEC te dá questões. Esse sistema te diz qual questão estudar agora,
com base no que você errou — e te cobra de volta no momento certo."

MOMENTO DO PITCH:
Quando Ingrid verbalizar "tô conseguindo estudar todo dia"
ou "achei que ia perder tempo aqui e não — é diferente"
```

#### OPORTUNIDADE DE PREÇO

| Hipótese | Base | Status |
|---|---|---|
| Teto receptivo real é R$150/mês | Ingrid não regateou no piloto; perfil de quem "espera e não barganha" | PENDENTE — confirmar na hora do pitch |
| R$97/mês é abaixo do teto mas acima da ancora psicológica de concurseiro | Concurseiros pagam R$50–90 nos genéricos; R$97 está acima porém com diferencial claro | HIPÓTESE ATIVA |

#### RISCO DE ESCALA (Mandato 13 — Sentinela)

| Risco | Detalhe | Severidade |
|---|---|---|
| Personalização por cargo = gargalo de curadoria | Cada novo cargo exige coletar e ponderar questões específicas — não escala automaticamente | ALTO |
| SM-2 depende de volume de interações | Com menos de 20 sessões, os intervalos são estimativas — Ingrid está na janela crítica | MÉDIO |
| Ingrid compartilhar login (H-5) | Uma conta shared dilui os dados de SM-2 — algoritmo passa a ser inútil | MÉDIO |

### LEADS DETECTADOS

| Nome | Contexto | Status |
|---|---|---|
| — | D4:A executado 2026-05-26: "Você conhece alguém prestando concurso?" | Ingrid respondeu: não conhece ninguém — pipeline de indicação = zero no curto prazo |

---

## CAMADA_DECISAO

### DECISÕES FORMAIS DO CONSELHO

| Data | Decisão | Autoridade |
|---|---|---|
| 2026-05-18 | P-023 resolvido: Clickwrap na UI + Termo físico assinado | Conselho — Síntese Final P-037 |
| 2026-05-18 | Número visível: Pontos Ponderados — Score de Sobrevivência removido (viola cláusula 2) | Conselho — Síntese Final P-037 |
| 2026-05-18 | Debug mode: 5 toques no logo — nunca query string (Ingrid não é técnica) | Conselho — Síntese Final P-037 |
| 2026-05-18 | Perfis de Nicho: trade secret interno — nunca produto comercializável externamente | Embaixador ALERTA + Músculo — Síntese Final |
| 2026-05-19 | MEMORIA_EMBAIXADOR reestruturada em 3 camadas (FATOS / INFERENCIA / DECISAO) | Diretor — aprovação explícita |
| 2026-05-27 | **D1:A** LEGAL-WATCH — WhatsApp + novo PDF datado 18/05. Ingrid assina sem drama. | Diretor — Veredito Loop 5 |
| 2026-05-27 | **D2:A** GATE-WATCH — Deploy completo + offboarding real nos Dias 14-15 (28-29/05) | Diretor — Veredito Loop 5 |
| 2026-05-27 | **D3:A** VETO G-1 + G-3 total — backlog V2. Ingrid em VERDE FRÁGIL: zero risco desnecessário | Diretor — Veredito Loop 5 |
| 2026-05-27 | **D4:A** Pipeline — plantar "Conhece alguém prestando concurso?" na próxima mensagem a Ingrid | Diretor — Veredito Loop 5 |
| 2026-05-27 | **D5:B** N-3 Linha de Corte — campo configurável no DASHBOARD interno. Eduardo define o número quando tiver dados reais. SEDES-DF 2026 é primeiro concurso Quadrix no órgão — sem corte histórico verificável. | Diretor — Veredito Loop 5 |
| 2026-05-27 | **LEGAL-WATCH VERDE** — Reassinatura física do Termo confirmada. Ingrid reassinou presencialmente. | Diretor — Confirmação 2026-05-27 |
| 2026-05-27 | **Loop 6 · P0/P1/PRINCIPIO/D3_VANGUARD** — PAINEL DE DELIBERAÇÃO gerado pelo Embaixador. VEREDITOS confirmados pelo Diretor. | Embaixador — Loop 6 SEÇÃO D |
| 2026-05-28 | **DADOS-WATCH VERDE** — 102 respostas · 1 user_id correto · SM-2 íntegro | Músculo — verificação técnica |
| 2026-05-30 | **Gate dia15 APROVADO** — Ingrid tem acesso admin ao próprio Supabase (P-013 VERDE) | Diretor — confirmação presencial |
| 2026-05-30 | **Loop 7 iniciado** — Gemini DIRETRIZ V7 + ingrid-v7.md APROVADA · PASSO7 pronto para Embaixador | Músculo P-032 |

### PROTOCOLOS ATIVOS

**Mensagem imediata — enviar AGORA (fix já deployado):**
> *"Ingrid, que bom que gostou — fico feliz mesmo. E olha, valeu demais por ter notado aquilo da questão 18 com o negrito. Era um bug de formatação chato, já corrigi. Esse tipo de olho fino é exatamente o que a banca da Quadrix cobra na prova, viu? Continua estudando assim 👊"*

**Reassinatura do Termo (próxima interação):**
- Gerar novo PDF com data 18/05/2026 no corpo
- Eduardo: *"Corrigi uma data no documento, precisa assinar rapidinho de novo"*
- Simples, sem drama, antes do Gate Dia 15

**Próxima sessão de Ingrid:**
1. Plantar pergunta de lead: *"Você conhece mais alguém prestando concurso esse ano?"*
2. Embaixador recebe debrief em até 24h com `FRASES_VERBATIM` separado de interpretação

### PRINCÍPIOS CANDIDATOS AO LEDGER

| Código | Princípio | Proposto em |
|---|---|---|
| P-042 | FALAS_CLIENTE: repositório único por projeto — captura única, extração múltipla por membro | 2026-05-19 |
| P-043 | Membro que acusa outro de viés metodológico entrega evidência verbatim, não conclusão sintética | 2026-05-19 |
| P-044 | Princípio extraído do LEDGER sem rotina operacional declarada é prosa — não aprendizado | 2026-05-19 |
| P-045 | URL pública (GitHub Pages) aceita só em piloto — auth real obrigatório antes do primeiro cliente pagante | 2026-05-19 |
| P-046 | Primeiro feedback espontâneo de piloto é o ativo mais valioso do projeto — captura verbatim com timestamp | 2026-05-19 |
| P-047 | Engajamento inaugural alto (Q18+) é indicador de receptividade, não hábito formado. Hábito confirma-se na sessão 3-5 quando SM-2 cobra e a novidade foi embora. Temperatura Verde depende da qualidade das sessões 2-5, não da sessão 1. | 2026-05-20 |

### HISTÓRICO DE ATUALIZAÇÕES

| Data | O que mudou | Quem |
|---|---|---|
| 2026-05-18 | Criação inicial | Embaixador |
| 2026-05-18 | Síntese Final P-037: E-1 a E-5 + H-1/H-2 + Pipeline + Temperatura + decisões | Músculo (P-032) |
| 2026-05-18 | Termo assinado — VERDE — P-023 resolvido — URL pública ativa | Músculo (P-032) |
| 2026-05-19 | Gate Dia 8: "gostou muito" + bug questão 18 — primeiro dado verbatim real | Embaixador (LOG_006) |
| 2026-05-19 | H-3/H-4 refutadas, H-7 nova, TEMPERATURA QUENTE, fix deployado | Músculo (P-032) |
| 2026-05-19 | Reestruturação em 3 camadas aprovada pelo Diretor | Músculo (P-032) |
| 2026-05-20 | Loop 4 Deliberação: E-1 a E-5 + alertas CRÍTICOS (Persona Sargento / Distrator) + temperatura VERDE FRÁGIL | Músculo (P-032) |
| 2026-05-20 | H-3 revertida para PENDENTE, H-4 mantida ATIVA — engajamento inaugural ≠ hábito formado | Embaixador |
| 2026-05-23 | Loop 5 Dia 12: G-5 + G-3 + Contador deployados. Deploy pipeline (P-056) corrigido. Link reenviado a Ingrid. Temperatura atualizada para VERDE FRÁGIL REENGAJAMENTO. Watchdog DEPLOY-WATCH + TESTE-WATCH criados. | Músculo (P-032) |
| 2026-05-25 | Loop 5 SEÇÃO D: Embaixador executou reação completa a [M+G+N] (15 inputs). Painel de Deliberação D1-D5 gerado. VETO G-1+G-3 confirmado. N-2+N-3+N-5 confirmados. Veredito de Eduardo pendente. | Músculo (P-032) |
| 2026-05-26 | Gate Dia 15 APROVADO — Loop 5 CONCLUIDO. D4:A executado (lead plantado, Ingrid confirmou não ter rede de concurso). Novo PDF Termo recebido e confirmado por Ingrid. SCOPE-WATCH H-5 desativado. LEGAL-WATCH parcial (recebimento confirmado, assinatura pendente). | Músculo (P-032) |
| 2026-05-27 | Loop 6 SEÇÃO D executada: Embaixador retornou TEMPERATURA 7.5/10, [E-1 a E-5], PAINEL DE DELIBERAÇÃO (P0/P1/PRINCIPIO/D3). LEGAL-WATCH VERDE (reassinatura física confirmada). [DADOS-WATCH] ATIVO (470 respostas — user_id a verificar). H-7 CONFIRMADA. H-8 NOVA. Vereditos do Painel pendentes. | Músculo (P-032) |
| 2026-06-01 | D3 RESPONDIDO — Ingrid confirmou acesso ativo e que está gostando. Cenário A confirmado. H-4 revisada para BAIXO RISCO. Temperatura elevada para 8.5/10. PITCH-WATCH AQUECIDO. Loop 8 liberado para avançar. | Músculo (P-032) |

---

> **Protocolo de uso:** CAMADA_FATOS = Auditor lê sem viés do Embaixador. CAMADA_INFERENCIA = Embaixador interpreta (ler sabendo que é opinião). CAMADA_DECISAO = Conselho deliberou — são verdades formais.
> Tempo de leitura por camada: 30 segundos. Atualização: 2 minutos.
