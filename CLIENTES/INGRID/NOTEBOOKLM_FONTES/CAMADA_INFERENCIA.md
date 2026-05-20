# CAMADA_INFERENCIA — PROJ-002 INGRID
> **Regra absoluta:** tudo aqui é interpretação do Embaixador sobre os fatos da CAMADA_FATOS.
> Hipóteses, padrões inferidos, ideias estratégicas, leituras de comportamento.
> Quem lê esta camada lê **opinião informada**, não verdade factual.
>
> **Quem mantém:** Embaixador (Claude Projects) — única voz autoral aqui.
> **Quem lê:** todos os membros do Conselho, sabendo que estão lendo inferência.
> **Como ler:** sempre cruzar com CAMADA_FATOS. Se a inferência não tiver fato correspondente, é especulação solta.
>
> **Versão:** v1 (refatoração inicial — 2026-05-18) | **Última atualização:** 2026-05-18

---

## LEITURA DE COMPORTAMENTO — PERFIL INFERIDO DA INGRID

### Dor real (interpretada)
Não é falta de material — é excesso de material irrelevante. QConcursos e TEC entregam milhões de questões sem priorizar o cargo específico, sem explicar por que errou, sem adaptar ao histórico da banca. O incômodo de Ingrid é volume sem direção.

### O que ela quer sentir (inferido a partir de contexto, não dito explicitamente)
Abrir o celular, responder 20 questões certas em 30 minutos, ir dormir confiante de que está no caminho certo. Sensação de progresso fechado por sessão, não progresso aberto sem fim.

### O que ela mais teme (inferido)
Estudar a matéria errada e descobrir tarde demais. Medo de retrabalho, não de dificuldade.

### O que a motiva (inferido)
Progresso concreto e mensurável. *"Estudei 140 questões esta semana"* é a forma de motivação dela — quantidade rastreável, não qualidade abstrata.

---

## PADRÕES OBSERVADOS — INTERPRETAÇÃO DO EMBAIXADOR

> Atualizar com cada interação real. Cada padrão tem fato correspondente em CAMADA_FATOS.

- **Dedicada e sistemática.** Inferência baseada em: assinou o Termo dentro de 48h da cobrança, persistiu até pelo menos a questão 18 na primeira sessão, reportou bug com precisão técnica.
- **Atenção literal ao enunciado.** Inferência forte baseada no feedback verbatim da questão 18 — leu o enunciado, comparou com a tela, notou desencontro. Comportamento que Quadrix recompensa.
- **Linguagem acessível, calorosa.** Responde melhor a resultado concreto do que a explicação técnica.
- **Usuária não-técnica.** Nunca mencionar infraestrutura, custo de API, ou detalhes de backend nas mensagens.
- **Padrão de retenção:** frases E-2 (abertura) e E-5 (encerramento) são o mecanismo crítico — não são decoração.
- **Reforço de uso:** 1 clique para estudar (P-031) — UI complexa é causa de abandono neste perfil.

### Padrão novo descoberto em 2026-05-18 (debrief Gate Dia 8)
Ingrid não comparou o app com TEC Concursos no primeiro contato. H-3 refutada. Inferência: ou o app já se diferenciou tanto que a comparação não veio à mente, ou Ingrid está em modo "experimentando algo novo" e desligou o comparador. Ambas as leituras são positivas; a primeira é mais valiosa.

---

## HIPÓTESES ATIVAS — ESTADO INTERPRETADO

> Cada hipótese é leitura do Embaixador sobre comportamento. Status (CONFIRMADA / REFUTADA / PENDENTE) é decisão do Embaixador baseada em fato da CAMADA_FATOS.

| # | Hipótese | Status | Evidência da CAMADA_FATOS |
|---|---|---|---|
| H-1 | Não assinou em 16/05 por esquecimento funcional, não por hesitação | **CONFIRMADA** (2026-05-18) | Assinou em 18/05 após cobrança direta — janela de 2 dias compatível com modo foco de estudo, não com hesitação ativa |
| H-2 | Medo financeiro causou hesitação na assinatura | **REFUTADA** (2026-05-18) | Piloto sem custo — não houve gatilho financeiro objetivo no período |
| H-3 | Vai comparar o app com TEC Concursos na primeira sessão | **REFUTADA** (2026-05-18) | Feedback verbatim da primeira sessão não mencionou TEC nem fez comparação |
| H-4 | Primeiras questões parecendo difíceis = reação normal, não abandono | **REFUTADA — pela via positiva** (2026-05-18) | Persistiu até pelo menos a questão 18 e elogiou espontaneamente o app |
| H-5 | Pode compartilhar login com familiar ou colega próxima | PENDENTE | Sem oportunidade de observar ainda — monitorar Gate Dia 15 |
| H-6 | Teto receptivo de preço é R$97/mês — teto real pode ser R$150 | PENDENTE | Preço não foi mencionado nas interações até 2026-05-18 |
| **H-7 (nova)** | Ingrid lê banca como banca lê — atenção literal ao enunciado | PROVÁVEL — confirmar nas próximas sessões | Notou bug fino na questão 18 onde enunciado pedia "palavra em negrito" e o negrito não apareceu na tela |

---

## INTELIGÊNCIA DO EMBAIXADOR — IDEIAS [E-1 a E-5] DO LOOP 3

> Gerado em 2026-05-18 · Confirmado na Síntese Final · Peso de evidência de campo.

| # | Ideia | Ação operacional | Status |
|---|---|---|---|
| E-1 | Vanguard como investidor de relacionamento — gerar "Resumo da Entrega" de 1 página para Ingrid no Gate Dia 15 em linguagem dela, não pacote corporativo | Eduardo prepara doc de 1 página com evolução, métricas, próximos passos | PROTOCOLO Eduardo — Gate Dia 15 |
| E-2 | Plantar pergunta no Gate Dia 8: *"Você conhece mais alguém prestando concurso esse ano?"* | Eduardo faz a pergunta após Ingrid responder 10 questões reais — casual, não formal | PENDENTE — não plantada na primeira sessão; replantar próxima |
| E-3 | R$97/mês é teto receptivo; teto real pode ser R$150 — abrir pitch alto e descer | Registrar reação verbal/comportamental de Ingrid ao ouvir preço pela primeira vez | MONITORAR no pitch |
| E-4 | Curva de erro por distrator nas 3 primeiras sessões = slide de pitch para 500 candidatos Quadrix | Campo `distrator_escolhido` + `nivel_tutor_disparado` obrigatórios no banco desde sessão 1 | CONSTRUÍDO no build Dia 7 |
| E-5 | Clickwrap em D1 de produto vira regra Vanguard para todo SaaS — não exceção | Documentar no LEDGER como princípio universal após Gate Dia 8 aprovado | CANDIDATO AO LEDGER — promover agora que Gate Dia 8 foi aprovado |

---

## ATIVO DE DADOS — INTERPRETAÇÃO DE BUSINESS CASE

A partir do Gate Dia 8, cada resposta da Ingrid gera dado bruto registrado em CAMADA_FATOS. A interpretação estratégica desse dado é a seguinte:

- 3 sessões com dados de distrator + tutor + TTI = curva de erro/distrator documentada.
- Curva documentada = argumento de pitch para 500 candidatos Quadrix.
- Sem documentação = argumento de escala colapsa antes de existir.

**KPI fundamental inferido pelo Embaixador (não pedido por nenhum outro membro):**
`tempo_entre_assinatura_e_primeira_sessao` + `tempo_da_primeira_sessao_até_questao_10` = o número que valida ou destrói o modelo SaaS de R$194k. Para Ingrid, este número precisa ser solicitado ao Músculo retroativamente.

---

## PIPELINE COMERCIAL — LEITURA DO EMBAIXADOR

| Produto | Valor | Gatilho para pitch | Timing |
|---|---|---|---|
| Piloto atual | R$0 | — | Ativo |
| Sovereign Study SaaS V2 | R$97/mês (teto receptivo inferido) | 7 dias consecutivos de uso + verbalização de progresso | Entre Gate Dia 8 e 2026-06-15 |
| Sovereign Study SaaS V2 — upsell | Até R$150/mês | Reação positiva a R$97 sem hesitação | Avaliar no momento do pitch |
| Plataforma SaaS V3 | R$97/mês × N usuárias | Menção espontânea a grupo de estudos ou colega | Após V2 confirmada |

### Argumento de abertura inferido pelo Embaixador
*"Ingrid, esse ciclo foi piloto. Quero continuar do seu lado até o dia da prova — R$97/mês, menos que qualquer cursinho, e o sistema já te conhece. Quer continuar?"*

### Argumento anti-objeção
*"Tudo que o app aprendeu sobre você fica aqui. Sair agora é perder o histórico."*

### Sinal inferido como gatilho ideal de pitch
Ingrid verbalizar progresso espontâneo: *"tô conseguindo estudar todo dia"* ou *"acertei mais hoje do que essa semana toda no TEC."*

---

## LEADS DETECTADOS — INTERPRETAÇÃO

| Nome/Descrição | Contexto | Status |
|---|---|---|
| Nenhum registrado ainda | — | Monitorar ativamente — pergunta E-2 ainda não plantada |

**Gatilho passivo:** qualquer menção espontânea a amiga, colega ou grupo de estudos → registrar evento na CAMADA_FATOS e perfil inferido aqui.
**Gatilho ativo:** Eduardo planta a pergunta no próximo contato natural — não no contato pós-bug, sob risco de diluir o sinal emocional positivo.

---

## TEMPERATURA_CLIENTE — INTERPRETAÇÃO DO EMBAIXADOR

```
TEMPERATURA_CLIENTE — PROJ-002 INGRID
Status atual: QUENTE
Baseado em: Feedback verbatim positivo na primeira sessão real (2026-05-18) + 
            persistência até questão 18 + reporte espontâneo de bug
Validade: até próxima interação ou Gate Dia 15, o que vier primeiro
Override de urgência técnica ativo: SIM
  → Bug da questão 18 e formatação de negrito têm prioridade máxima nas 24h
Última atualização: 2026-05-18 (Embaixador — pós-debrief Gate Dia 8)
```

### Por que QUENTE (não VERDE simples)
VERDE é status contratual. QUENTE é estado emocional engajado confirmado por dado real. A diferença importa para o Músculo: features que sustentam o estado QUENTE têm prioridade sobre features de eficiência técnica que Ingrid nem percebe.

---

## PRINCÍPIOS CANDIDATOS AO LEDGER (propostos pelo Embaixador)

**P-026 proposto:** O case de EdTech só tem valor comercial se as métricas de uso forem documentadas desde o Gate Dia 8 — acertos por disciplina, sessões por semana, evolução de score. Sem documentação, argumento de escala não existe.

**E-5 promovido a P-XXX candidato:** Clickwrap na primeira tela de qualquer SaaS Vanguard. Não exceção, regra universal — confirmada pela velocidade que o método dá ao onboarding.

**P-039 proposto (novo desta refatoração):** Transcrição verbatim É a purificação. Síntese interpretada é onde mora o viés. Memórias de relacionamento com cliente devem ser estruturadas em camadas separadas: FATOS (verbatim) / INFERÊNCIA (interpretação) / DECISÃO (deliberação). Captura única, extração múltipla.

**P-040 proposto (novo desta refatoração):** Data de assinatura em documento contratual nunca é pré-preenchida. Geração de documento deixa o campo em branco; preenchimento acontece no ato de assinar. Datas projetadas (vigência, prazo, deadline) podem ser pré-preenchidas — data de assinatura, nunca.

**P-041 proposto (novo desta refatoração):** Todo princípio extraído do LEDGER deve declarar, no momento da extração, qual rotina operacional executa o princípio. Princípio sem rotina é prosa.

**P-042 proposto (novo desta refatoração):** Todo membro do Conselho que cobra outro membro por viés metodológico deve entregar evidência verbatim que sustenta a cobrança. Cobrança sintética é eco, não auditoria.

---

## ALERTAS ATIVOS — LEITURA DO EMBAIXADOR

- **[QA-WATCH] questão 18:** bug de formatação de negrito reportado em 2026-05-18. Hipóteses técnicas em três frentes (parser markdown frontend / geração API / curadoria banco). Janela ideal de correção: 24h. Acima de 48h, fricção de confiança maior que o próprio bug.
- **[DOC-WATCH] Termo de Uso:** PDF original com data 30/05 no corpo enquanto assinatura real foi 18/05. Não vai problematizar com Ingrid (piloto, R$0, confiança alta), mas precisa ser corrigido como prática antes de qualquer cliente pagante.
- **[CHURN-WATCH]:** desarmado por enquanto. Reavalia após 3 sessões consecutivas ou se silenciar 48h+ sem retornar ao app.
- **[SCOPE-WATCH] H-5:** ainda pendente — sem oportunidade de observar compartilhamento.

---

> **Princípio que governa esta camada:**
> Inferência rotulada é proteção do Conselho contra contaminação narrativa.
> Quem lê esta camada lê opinião do Embaixador, não realidade.
> Quem audita esta camada audita a interpretação, não o fato.
