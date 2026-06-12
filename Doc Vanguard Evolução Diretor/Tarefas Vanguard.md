# O que a Vanguard faz enquanto o Eduardo não está trabalhando

Este documento explica, de forma simples, as tarefas automáticas que foram programadas para rodar sozinhas no computador do Eduardo. Cada tarefa tem um horário fixo, pesquisa informações na internet, analisa os dados e salva um arquivo no Google Drive com o resultado.

O Eduardo não precisa fazer nada para que essas tarefas rodem. Quando ele abrir o computador, o material já estará lá, esperando por ele.

---

## Como o sistema funciona

O sistema é chamado de **Embaixador Agentado**. É um conjunto de tarefas automáticas que trabalha enquanto o Eduardo vive sua vida — atende clientes, dorme, cuida da família. Quando ele abre uma sessão de trabalho, em vez de começar do zero, ele encontra inteligência acumulada esperando por ele.

Toda tarefa segue o mesmo fluxo:

1. O sistema roda no horário programado
2. Pesquisa na internet e analisa as informações encontradas
3. Salva um arquivo organizado no Google Drive (pasta INBOX_COWORK)
4. Na próxima sessão de trabalho, o Eduardo abre o arquivo e lê
5. Ele decide o que fazer com a informação — **nenhuma ação acontece sem a aprovação dele**

---

## A empresa por trás das tarefas: a Vanguard Tech

A Vanguard é uma empresa de inteligência aplicada. O que ela vende não é tecnologia nem automação de processos. Ela vende a eliminação do custo do erro — o prejuízo que acontece quando uma decisão parece certa, mas estava errada em um detalhe que ninguém viu.

Os mercados que ela atende:

- **Licitações públicas** — empresas que participam de pregões e perdem por erros documentais evitáveis
- **Saúde** — médicos e clínicas que têm receita bloqueada por erros em prontuários
- **Fusões e aquisições** — empresas que compram outras e descobrem passivos escondidos depois de assinar
- **Comércio exterior** — importadores multados por erros de classificação fiscal
- **Alimentos premium** — fabricantes que sofrem recalls e interdições por falha de rastreabilidade

A Vanguard nunca menciona tecnologia para os clientes. Sempre fala de resultado. Sempre fala de especialistas. Essa é uma regra que o sistema inteiro respeita.

---

## As 8 tarefas automáticas

---

### Tarefa 1 — Radar de Dor do Mercado

**Quando roda:** Todo dia às 7h da manhã

**O que faz:**

Todo dia, o sistema acorda antes do Eduardo e vai pesquisar na internet o que está acontecendo nos 5 mercados que a Vanguard atende. Ele varre redes sociais, sites de órgãos públicos, grupos profissionais e publicações especializadas procurando por problemas reais que as empresas estão enfrentando.

Ele não olha para um mercado só — olha para os 5 ao mesmo tempo, todo dia:

- **Licitações:** empresas reclamando de editais perdidos por detalhe, inabilitações no PNCP, decisões do TCU sobre habilitação documental
- **Saúde:** médicos e clínicas reclamando de glosas negadas, problemas em prontuários, mudanças de critério das operadoras
- **Fusões e aquisições:** advogados e diretores financeiros falando de passivos descobertos tarde, due diligence que falhou
- **Comércio exterior:** importadores com cargas retidas, multas por classificação fiscal errada, novas circulares da Receita Federal
- **Rastreabilidade sanitária:** fabricantes de alimentos com interdições, novos requisitos da ANVISA, riscos de recall

Para cada sinal encontrado, o sistema classifica a urgência: ALTA (dor imediata, a empresa precisa de solução agora), MÉDIA ou BAIXA.

Para o mercado com o sinal mais forte do dia, o sistema escreve três versões de narrativa de venda prontas para o Eduardo usar: uma para LinkedIn (150 palavras), uma para WhatsApp (50 palavras) e uma para proposta comercial (300 palavras). O Eduardo não precisa escrever — só revisar e enviar.

**O que entrega:**

Um arquivo markdown salvo no Google Drive com:
- Tabela de sinais detectados por nicho (sinal, fonte, urgência)
- Narrativa de venda pronta em 3 formatos para o nicho mais quente do dia
- Lista de editais novos no portal de licitações públicas (PNCP) com valor acima de R$ 500 mil

---

### Tarefa 2 — Tutor do Fundador

**Quando roda:** Toda segunda-feira às 8h

**O que faz:**

Toda segunda de manhã, o sistema identifica qual é a decisão mais importante que o Eduardo provavelmente vai precisar tomar nos próximos 7 a 14 dias. Então prepara um briefing de no máximo 2 páginas — como se um conselho de administração tivesse contratado um analista para preparar o Eduardo para aquela decisão específica.

O briefing sempre responde quatro perguntas:

1. O que o Eduardo precisa saber sobre esse assunto que ele provavelmente não sabe ainda?
2. Quais são os 3 erros mais comuns que outros empreendedores cometeram em situações parecidas?
3. O que os dados e a evidência disponível dizem que funciona nesse caso?
4. O que ele vai precisar saber daqui a 60 dias que ainda não sabe? (para já ir se preparando)

Além do briefing, sempre que houver um relatório longo, paper acadêmico ou livro que seja relevante para a decisão, o sistema lê por inteiro e extrai apenas o que importa para a situação do Eduardo. O que seria 4 horas de leitura vira 10 minutos.

**O que entrega:**

Documento de até 2 páginas com análise da decisão, os erros a evitar, o que a evidência recomenda e as fontes consultadas. Exemplo real desta semana: como precificar o primeiro serviço de auditoria de licitações — com tabela de preços praticados no mercado, âncora de negociação baseada no custo da inabilitação e script de como apresentar o preço para o cliente.

---

### Tarefa 3 — Guardião de Dependências

**Quando roda:** Toda segunda-feira às 8h

**O que faz:**

A Vanguard depende de uma série de serviços para funcionar: a empresa que fornece o sistema de inteligência artificial, o Google para armazenamento e colaboração, sistemas de automação, hospedagem de software, banco de dados. Se qualquer um desses fornecedores mudar o preço, descontinuar um produto ou sofrer um problema, a Vanguard pode ser impactada.

O sistema monitora tudo isso toda semana.

Ele também acompanha a legislação de inteligência artificial no Brasil — o PL 2338, o Marco Legal da IA que está em tramitação. Qualquer mudança nessa lei pode exigir adaptação na forma como a Vanguard opera. E mais importante: pode criar um produto novo para os clientes da Vanguard, que também vão precisar se adaptar.

Uma vez por mês (no dia 1), o sistema faz um mapeamento mais profundo: identifica onde a Vanguard tem um ponto único de falha — ou seja, algo que se quebrar, para tudo, sem plano B. Para cada ponto desse, estima o custo de criar uma redundância versus o custo de não ter.

**O que entrega:**

Relatório com:
- Status de cada fornecedor crítico (OK / Alerta / Crítico) com o que mudou
- O que mudou no Marco Legal da IA naquela semana e o que isso muda para a Vanguard e para seus clientes
- Plano B mapeado para cada fornecedor com problemas
- No dia 1 do mês: lista de pontos únicos de falha com recomendação de ação

---

### Tarefa 4 — Espelho Estratégico

**Quando roda:** Dias 1 e 15 de cada mês, às 8h

**O que faz:**

A cada 15 dias, o sistema faz uma auditoria honesta da Vanguard. Sem suavização. Sem dizer o que o Eduardo quer ouvir.

Ele analisa quatro coisas:

**1. Coerência:** O que foi decidido nas últimas semanas foi de fato executado? Existe algum projeto aprovado que ficou parado sem que ninguém tenha deliberado explicitamente por isso?

**2. Deriva:** A empresa está ficando cada vez mais sofisticada internamente enquanto a receita não cresce? Está investindo tempo em coisas que não geram cliente? Essa é a principal armadilha que o sistema foi programado para detectar — a empresa que evolui internamente mas não avança comercialmente.

**3. Temperatura do Diretor:** O Eduardo está com energia para executar ou está em modo de análise prolongada? Sessões longas com muita deliberação e pouco resultado prático são um sinal de alerta. O sistema detecta esse padrão antes que ele vire esgotamento.

**4. Custo de oportunidade:** Quanto tempo passou desde o último cliente novo? O que o sistema poderia ter feito no último período que não fez? Qual mercado deveria ter sido abordado e não foi?

**O que entrega:**

Diagnóstico em texto direto com:
- Lista do que foi prometido e não foi feito
- Identificação de deriva (sim ou não, com evidência)
- Leitura da temperatura do Diretor
- Recomendação direta de ajuste
- Uma pergunta que o Eduardo precisa responder naquela semana — não um relatório para ler, mas uma pergunta para agir

---

### Tarefa 5 — Caçador de Capital

**Quando roda:** Dias 1 e 15 de cada mês, às 16h

**O que faz:**

A cada 15 dias, o sistema varre todos os programas públicos de financiamento que podem dar dinheiro para a Vanguard — sem precisar pagar de volta (subvenção econômica) e sem ceder parte da empresa (sem diluição de equity).

Ele monitora continuamente:

- **FINEP** — linhas de subvenção para empresas de inteligência artificial e transformação digital. Edital atual: R$ 300 milhões disponíveis, prazo até setembro de 2026.
- **FAP-DF** — Fundação de Apoio à Pesquisa do Distrito Federal. A Vanguard está em Brasília — isso é prioridade.
- **SEBRAE** — programas de aceleração com recurso não-reembolsável para pequenas empresas inovadoras
- **BNDES** — linhas para micro e pequena empresa inovadora
- **CNPq, EMBRAPII, InovAtiva, Startup Brasil** — demais programas públicos e privados relevantes

Para cada edital encontrado, o sistema avalia o encaixe com a Vanguard em uma escala de 1 a 5, estima quanto esforço seria necessário para se candidatar e prepara um rascunho inicial de candidatura — para que o Eduardo não precise escrever do zero se decidir entrar.

Também monitora a Lei do Bem (Lei 11.196/2005), que permite às empresas no Lucro Real deduzir o investimento em pesquisa e desenvolvimento do imposto de renda. O Pentalateral IAH pode se qualificar como P&D — isso pode representar um benefício fiscal significativo.

**Regra absoluta:** o sistema nunca submete nada. Só prepara. Submissão é sempre decisão do Eduardo.

**O que entrega:**

Dossiê com:
- Lista das oportunidades abertas (nome, órgão, valor, prazo, URL)
- Análise de encaixe da Vanguard com cada edital
- Rascunho de candidatura pronto para os editais com melhor encaixe
- Atualização sobre a Lei do Bem e elegibilidade

---

### Tarefa 6 — Câmara de Guerra

**Quando roda:** Dia 1 de cada mês, às 16h

**O que faz:**

Todo mês, o sistema quebra a Vanguard antes que o mercado quebre. Ele assume o papel do inimigo — para que o Eduardo saiba o que está vindo antes que chegue.

Três componentes sempre executados:

**1. Simulação de concorrente**
O sistema instancia como o concorrente mais perigoso possível — uma Big4 (Deloitte, PwC) lançando serviço similar, uma startup de tecnologia captando R$ 20 milhões para atacar o mesmo mercado, um ex-executivo do setor abrindo uma boutique especializada. Para cada cenário: como esse player tomaria os clientes da Vanguard em 90 dias? Quais seriam seus 3 primeiros movimentos? Onde a Vanguard está vulnerável? Entrega: plano de defesa antecipado, para o Eduardo agir antes que o concorrente exista.

**2. Cenários de stress**
O sistema analisa 4 cenários de crise:
- E se o principal cliente cancelar o contrato?
- E se a Anthropic (fornecedora do sistema) triplicar o preço?
- E se uma lei nova proibir ou restringir o uso de IA no nicho de licitações?
- E se o Google descontinuar o Gemini, um dos componentes do sistema?

Para cada cenário: qual a probabilidade de acontecer, qual o impacto para a Vanguard, qual seria o primeiro sinal de alerta a monitorar, e qual é o plano de resposta pré-escrito — para que o Eduardo não precise pensar em crise no dia que a crise acontecer.

**3. Pré-mortem de proposta**
Quando o Eduardo está prestes a enviar uma proposta grande (acima de R$ 5 mil), o sistema assume o papel do cliente que vai RECUSAR. Escreve as 5 razões mais prováveis de rejeição — preço, timing, falta de confiança, concorrente com relacionamento existente, inércia — e para cada razão, o contra-argumento que deve estar na proposta antes de ela ser enviada. A proposta sai blindada.

**O que entrega:**

Documento com:
- Análise de cada cenário de concorrente e plano de defesa
- Tabela de cenários de stress com probabilidade, impacto, sinal de alerta e resposta
- Pré-mortem da proposta em elaboração (ou template por nicho se não houver proposta específica)

---

### Tarefa 7 — Demo Visionário

**Quando roda:** Dia 1 de cada mês, às 16h

**O que faz:**

Todo mês, o sistema atualiza o material de demonstração do serviço da Vanguard. O objetivo é simples: quando o Eduardo sentar com um cliente em potencial, o produto já deve estar na tela — construído semanas antes, em background.

O sistema produz dois artefatos:

**1. Protótipo navegável em HTML**
Um arquivo que abre em qualquer navegador e simula o serviço funcionando. Mostra o fluxo completo: o cliente envia um documento → o sistema analisa → detecta inconsistências → gera um relatório com semáforo verde/amarelo/vermelho → sugere as correções.

Tudo com dados fictícios mas realistas — empresas, valores, editais, prazos, tudo parecido com o que o cliente conhece do próprio setor. Sem nenhuma menção a tecnologia ou inteligência artificial. O que aparece é resultado — o que a equipe da Vanguard encontrou e o que isso significa para a empresa.

**2. Roteiro de demonstração (10 minutos)**
Um script minuto a minuto para o Eduardo apresentar o protótipo:
- Minutos 0–2: abrir com a pergunta da dor ("Quanto custou o último edital que vocês perderam?")
- Minutos 2–5: mostrar a detecção ao vivo de inconsistências
- Minutos 5–8: apresentar o relatório completo com o semáforo
- Minutos 8–10: fechar com o ROI calculável ("Se tivéssemos feito isso antes, vocês teriam economizado X")

Com esse roteiro, o Eduardo ensaia uma vez e apresenta com a segurança de quem fez cem vezes.

**O que entrega:**

- Arquivo HTML que abre no navegador com o protótipo navegável
- Arquivo markdown com o roteiro de 10 minutos, checklist pré-reunião e respostas para perguntas frequentes

---

### Tarefa 8 — O Cronista

**Quando roda:** Dia 1 de cada mês, às 16h

**O que faz:**

Todo mês, o sistema escreve um capítulo do Livro da Vanguard.

Não é um relatório técnico. É a história de verdade.

Daqui a 2 anos, quando a Vanguard for um caso de sucesso, a história já vai estar escrita — com os detalhes que a memória humana teria perdido: as decisões difíceis e o contexto que as cercou, o que estava em jogo em cada momento crítico, os números de cada fase, as frases que definiram o período, as viradas de estratégia, os primeiros clientes, os primeiros contratos.

O sistema escreve o capítulo do mês anterior em formato narrativo — como um capítulo de livro, não como uma planilha. Registra também um banco de momentos: citações do Eduardo com contexto, marcos do sistema (primeiro cliente, primeiro demo ao vivo, primeiro capital captado), e qualquer evento que vai aparecer no pitch futuro, em palestras, na imprensa ou num livro eventual.

Uma vez por trimestre, atualiza a linha do tempo completa da Vanguard — do início até o presente — em formato apresentável.

Tudo isso fica salvo no cofre. O que sai para uso público é sempre uma decisão do Eduardo.

**O que entrega:**

- Capítulo narrativo do mês anterior (500–800 palavras em prosa)
- Registro de marcos e citações do período
- Estado do sistema: frentes ativas, temperatura da operação, o que mudou em relação ao mês anterior
- Linha do tempo atualizada da Vanguard (trimestral)

---

## Resumo de todos os horários

| Tarefa | Quando | Horário |
|--------|--------|---------|
| Radar de Dor do Mercado | Todo dia | 7h |
| Tutor do Fundador | Toda segunda | 8h |
| Guardião de Dependências | Toda segunda | 8h |
| Espelho Estratégico | Dias 1 e 15 | 8h |
| Caçador de Capital | Dias 1 e 15 | 16h |
| Câmara de Guerra | Dia 1 do mês | 16h |
| Demo Visionário | Dia 1 do mês | 16h |
| O Cronista | Dia 1 do mês | 16h |

Todas as tarefas rodam fora do horário de pico (9h–15h) para consumir menos recursos.

---

## Uma coisa importante sobre o que esse sistema é — e o que não é

O sistema não toma decisões. Não envia e-mails. Não assina contratos. Não submete candidaturas. Não fala com clientes.

O que ele faz é trabalhar enquanto o Eduardo não está trabalhando, para que quando ele voltar, a inteligência necessária para tomar a próxima decisão já esteja pronta. O Eduardo colhe. O sistema acumula.

É como ter uma equipe de analistas que trabalha de madrugada, pesquisa o mercado, prepara os materiais, organiza os dados — e deixa tudo em cima da mesa para quando o chefe chegar.

---

*Embaixador Agentado · Vanguard Tech · Loop 33 · 2026-06-12*