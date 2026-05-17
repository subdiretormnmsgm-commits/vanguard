DIRETRIZ
BLOCO 0 — DIAGNÓSTICO

O risco real que não estamos endereçando é o esgotamento cognitivo. Estudar por 114 dias (até 06/09/2026) com um prazo apertado pode transformar a disciplina em tortura. Se o aplicativo for apenas um "gerenciador de tarefas" ou um banco de questões frio, Ingrid vai abandoná-lo na terceira semana por fadiga.

O problema central não é apenas a falta de um plano, mas a ansiedade de não saber se o plano está funcionando. A banca Quadrix para nível médio (TDAS) mudou para múltipla escolha (60 questões: 20 de conhecimentos gerais com peso 1 e 40 específicos com peso 2). Ingrid precisa abrir o PWA e sentir alívio e clareza imediata: o sistema diz o que ela vai estudar hoje, gera as questões na hora (focando nos pesos certos) e mostra que ela está progredindo. O aplicativo deve ser uma fonte de dopamina e controle, não mais uma cobrança na vida dela.
BLOCO 1 — PRIORIDADES DE BUILD (máximo 3)

Pesquisa Estratégica (Quadrix TDAS - Sedes-DF 2026): A prova terá 60 questões de múltipla escolha. Conhecimentos Gerais (Peso 1): Português, RIDE-DF, Política para Mulheres, Lei Orgânica do DF, LC 840/2011, Maria da Penha, Primeiros Socorros. Conhecimentos Específicos (Peso 2). A lógica de peso 2 deve nortear o algoritmo.

    Feed Diário Dinâmico (Motor de Plano Adaptativo)

        O que construir: A tela principal (Home) com o escopo do dia fechado. "Hoje você tem 2 tópicos: LOMDF e Primeiros Socorros. 20 questões." O sistema divide o edital nos dias úteis restantes e foca no que tem Peso 2.

        Por que agora: Resolve a dor principal (falta de programa). Remove a fricção de "o que estudo hoje?".

        Horas reais: ~10h (Lógica de divisão de datas + UI do feed).

        O que fica de fora: Calendários complexos de arrastar e soltar (drag & drop). A IA dita o ritmo, a usuária apenas executa.

    Gerador de Questões Quadrix Sob Demanda (Sovereign Engine)

        O que construir: Integração com Claude API usando um prompt sistêmico fortemente engenhado para replicar o estilo múltipla escolha da Quadrix.

        Por que agora: Nos liberta do TEC Concursos, criando um ativo de IP soberano e seguindo estritamente o princípio [P-003] (nunca construir dependência de scraping de terceiros).

        Horas reais: ~15h (Prompt engineering + Integração Supabase Edge Function + Mágico de Oz Gate para validar o output).

        O que fica de fora: Armazenamento massivo pré-gerado. As questões são geradas "on-the-fly" por tópico, salvando custos de banco de dados e garantindo variação infinita.

    Painel de Lacunas por Peso (Heatmap de Sobrevivência)

        O que construir: Um dashboard simples verde/amarelo/vermelho focado nas disciplinas. Se ela está com 40% de acerto em Específicos (Peso 2), o painel alerta com urgência máxima.

        Por que agora: Fornece a motivação visual diária e direciona a revisão para onde os pontos realmente importam para a aprovação.

        Horas reais: ~8h (Queries de agregação no Supabase + UI Recharts simples).

        O que fica de fora: Análises preditivas complexas ou comparações com outros candidatos fictícios.

BLOCO 2 — PROPOSTA COMERCIAL E HANDOFF

Embora seja um projeto piloto interno e sem custo para a cliente (Ingrid), o posicionamento do PROJ-002 é o de um Case de Validação do Modelo IAH V25 para o mercado B2C.

    Potencial de Replicação: Existem mais de 50.000 candidatos para o Sedes-DF. Validando o UX com uma usuária não-técnica, transformamos esse repositório em um "Copiloto Quadrix", monetizável via modelo SaaS (R$ 97/mês) logo após setembro para outros concursos da banca.

    Handoff Soberano: Mesmo sendo esposa do Diretor, a infraestrutura deve seguir o [P-013]. O projeto Supabase e o banco de questões gerado são propriedades dela (ou do modelo de negócio futuro), isolados desde o Dia 1.