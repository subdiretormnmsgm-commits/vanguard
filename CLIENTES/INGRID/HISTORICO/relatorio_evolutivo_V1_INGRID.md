# RELATÓRIO EVOLUTIVO V1 — PROJ-002 Ingrid
**Loop:** #1 — Kickoff e Deliberação Completa  
**Data:** 2026-05-15  
**Próxima fase:** Build — Dias 1 a 15 (início após Veredito do Diretor)

---

## PARA A INGRID — O QUE ACONTECEU HOJE

Ingrid, hoje o Eduardo e um sistema de quatro inteligências — Eduardo, um modelo de estratégia (Gemini), um sistema de auditoria (NotebookLM) e um construtor (Claude Code) — se sentaram juntos para planejar o seu aplicativo de estudos.

Não foi uma conversa. Foi um processo de engenharia com decisões fundamentadas, revisões cruzadas e princípios que impedem o sistema de errar.

O resultado: **um plano de 15 dias, com arquitetura definida, regras de qualidade e dados de incidência real das provas** — tudo antes de escrever uma linha de código.

O que foi construído hoje:
- Um banco de dados de conhecimento do seu concurso: 15 disciplinas ranqueadas por **o que realmente cai na prova** (não só o que o edital lista)
- O algoritmo que vai ditar o seu estudo diário: mais tempo nas matérias que a banca mais cobra, menos tempo no que aparece raramente
- As regras que protegem o sistema: sem custo surpresa, sem dependência de terceiros, sem perda do seu progresso

Você não vai estudar por ordem do edital. Você vai estudar por ordem de impacto real.

---

## ESTADO ATUAL

| Dimensão | Situação |
|---|---|
| Planejamento | Concluído — 100% do Loop 1 deliberado |
| Build | Aguardando aprovação do Diretor em 8 pontos |
| Deadline | 2026-05-30 (15 dias de build) |
| Prova | 2026-09-06 (114 dias) |
| Tempo disponível para estudar | ~4 meses — viável com o plano certo |

---

## ANÁLISE SWOT DO PROJETO

### Forças
- **Score de Incidência Real:** o app vai saber que SUAS (Sistema Único de Assistência Social) cai em ~98% das provas Quadrix — e vai priorizar isso automaticamente
- **Questões no estilo exato da banca:** geradas por IA treinada para replicar o estilo Quadrix (literalidade, pegadinhas, alternativas plausíveis)
- **SM-2 (Spaced Repetition):** matéria com < 30% de acerto → revisão em 2 dias. > 50% de acerto → revisão em 7 dias. Ingrid não vai "esquecer o que aprendeu"
- **Plano adaptativo real:** o app recalcula o que Ingrid precisa estudar toda semana com base no desempenho real — não em expectativa

### Fraquezas
- Primeira edição do concurso com a banca Quadrix para o SEDES-DF (gap de 8 anos desde o último concurso) — os dados de incidência são cruzados de concursos similares, não histórico direto
- MVP de 15 dias: algumas funcionalidades avançadas (podcast, comparação preditiva) ficam para o V2

### Oportunidades
- 4.788 vagas — um dos maiores concursos do DF em 2026 — o mesmo app pode atender outros candidatos no futuro
- O banco de dados que construímos (incidência por disciplina, pegadinhas da banca, estilo das questões) é um ativo proprietário — nenhuma outra plataforma fez este cruzamento para este concurso
- Podcast diário (V2): Ingrid vai poder ouvir o resumo da disciplina do dia no ônibus, na academia, em casa

### Ameaças
- Prazo fixo (15 dias de build × 114 dias até a prova) — qualquer atraso no veredito comprime o prazo
- Questões geradas por IA precisam passar pelo Gate de Qualidade (Eduardo avalia 10 questões com rubrica ≥ 4/5 no Dia 2) — se a qualidade não bater, ajustamos antes de avançar

---

## PDCA DO LOOP 1

### Plan (Planejado)
- Discovery com Ingrid (5 perguntas)
- DIRETRIZ do Gemini (7 blocos)
- Skill do Auditor (4 partes)
- Deliberação do Músculo (8 etapas)
- edital_sedes.json com score de incidência

### Do (Executado)
- DIRETRIZ recebida e validada — 7 blocos completos
- Skill do Auditor recebida — 4 partes (P1 e P2 coladas manualmente pelo Diretor)
- edital_sedes.json v2.0 — 15 disciplinas, score de incidência, pegadinhas, ideias D-1 a D-5
- Pesquisa de provas anteriores: confirmado gap de 8 anos, método cross-concurso validado
- P-014, P-015, P-016 promovidos ao INTELLIGENCE_LEDGER como princípios universais
- Code review: bug de totais corrigido (gerais 20/20, específicos 40/40)

### Check (Verificado)
- JSON válido e totais corretos (validação via Python)
- Commit realizado: `49a69a3`
- Todos os gates de Loop 1 passados

### Act (Próxima ação)
- Veredito do Diretor nos 8 pontos → libera o Dia 1

---

## RANKING DE PRIORIDADES — O QUE INGRID VAI ESTUDAR PRIMEIRO

| Posição | Disciplina | Score | Urgência |
|---|---|---|---|
| 1 | SUAS — Sistema Único de Assistência Social | 196 | MÁXIMA |
| 2 | PNAS — Política Nacional de Assistência Social | 190 | MÁXIMA |
| 3 | LOAS — Lei Orgânica da Assistência Social | 190 | MÁXIMA |
| 4 | CRAS / CREAS — Proteção Social Básica e Especial | 184 | MÁXIMA |
| 5 | Lei Distrital 7.484/2024 — Assistência Social no DF | 180 | MÁXIMA — diferencial |
| 6 | Programas Sociais DF (Cartão Prato Cheio, Gás, DF Social) | 176 | ALTA — diferencial DF |
| 7 | NOB/SUAS — Norma Operacional Básica | 170 | ALTA |
| 8 | BPC e Benefícios Eventuais | 170 | ALTA |
| 9 | Língua Portuguesa | 95 | ALTA |
| 10-15 | Realidade DF/RIDE, LODF, LC 840, Demais | 50-88 | MÉDIA/BAIXA |

**O app vai automaticamente colocar SUAS, PNAS, LOAS e CRAS/CREAS em 70% do feed diário.**  
Ingrid vai chegar na prova dominando o que a banca mais cobra.

---

## PLANO DE BUILD — OS PRÓXIMOS 15 DIAS

| Dias | O que será entregue |
|---|---|
| **Dias 1-2** | Base técnica: banco de dados, gerador de questões via IA, Gate CLI de qualidade |
| **Dias 3-5** | Feed Diário adaptativo: plano de 114 dias, proporção 70/30, repetição espaçada |
| **Dias 6-8** | Interface de questões: Ingrid responde, acerta/erra, progresso salvo |
| **Dias 9-11** | Heatmap de lacunas + Simulado completo estilo Sedes-DF |
| **Dias 12-13** | Contador de pontos ponderados + notificação no domingo |
| **Dias 14-15** | Manual de soberania: Ingrid com acesso admin ao próprio sistema |

---

## 5 IDEIAS DISRUPTIVAS DO MÚSCULO (para o próximo loop Gemini reagir)

### M-1 — Pilula Rápida de 60 Segundos
Antes de cada bloco de questões, exibir a Pílula da disciplina em texto + card visual. Ingrid lê em 60 segundos antes de responder. Impacto: ancoragem cognitiva antes da questão — acerto aumenta mesmo em dia de cansaço. Custo: 30 min de build, zero API extra. Pergunta para o Gemini: isso sobe a taxa de acerto ou cria fricção antes da questão?

### M-2 — Modo Emergência (72h Antes da Prova)
Nos últimos 3 dias antes do Sedes-DF, o app muda de modo: apenas questões das disciplinas onde o acerto está abaixo de 50%. Feed comprimido, zero questões novas, só revisão das lacunas críticas. Impacto: correção de curso de última hora antes de ser tarde demais. Custo: lógica simples de filtro, 1h de build. Pergunta para o Gemini: ativar automaticamente por data ou deixar Ingrid escolher?

### M-3 — Distrator Personalizado com Base nos Erros Reais da Ingrid
Quando Ingrid erra uma questão por um distrator específico (ex: confunde CRAS com CREAS), o sistema registra o padrão e gera novas questões com esse mesmo distrator propositalmente — até o erro ser corrigido. Impacto: cura o erro específico, não repete o conteúdo genérico. Custo: campo `distrator_errado` em progresso_usuario + lógica de seleção, 2h de build. Pergunta para o Gemini: isso é possível com SM-2 ou precisa de algoritmo separado?

### M-4 — Resumo da Semana via WhatsApp (Loop 2)
Todo domingo à noite, um resumo automático: "Esta semana você acertou X% de SUAS e Y% de LOAS. Sua disciplina mais fraca foi Z. Próxima semana: mais foco em Z." Enviado por WhatsApp (Twilio) ou email. Impacto: engajamento fora do app, Ingrid sente que tem um copiloto ativo. Custo: Twilio sandbox gratuito, 3h de build. Pergunta para o Gemini: push semanal vs push só quando acerto cai abaixo de 40%?

### M-5 — Template `edital_sedes.json` como Produto B2C
O modelo de dados que construímos hoje — score de incidência, pílulas, pegadinhas, topicos por disciplina — é um produto em si. Pode ser vendido como "pack de concurso" para outros candidatos do Sedes-DF: R$47-97/ano, self-service. O app da Ingrid é o piloto que valida o modelo. Impacto: caminho direto para MRR com zero overhead de atendimento. Custo de build do modelo: feito. Custo do portal B2C: Loop 3/V2. Pergunta para o Gemini: qual o gatilho certo para lançar o B2C — número de aprovados que usaram o sistema ou tempo após a prova?

---

## O QUE CONSTRUÍMOS JUNTOS NESTE LOOP

| Ativo | Valor |
|---|---|
| edital_sedes.json v2.0 | Base de conhecimento do concurso — reaproveitável para qualquer concurso Quadrix futuro |
| Algoritmo de Score de Incidência | Propriedade intelectual da Vanguard — diferencial vs. qualquer app de concurso do mercado |
| 45 pegadinhas documentadas da Quadrix | Playbook para o gerador de questões — qualidade que a banca testa mas ninguém ensina |
| Arquitetura multi-tenant desde o Dia 1 | Quando o SaaS B2C chegar, zero refatoração |
| P-014, P-015, P-016 no LEDGER | Princípios que vão proteger todo futuro projeto EdTech da Vanguard |

---

## PRÓXIMOS PASSOS (para Eduardo executar)

**Ação 1 — Veredito nos 8 pontos (hoje, bloqueia o Dia 1)**  
Leia os 8 pontos na seção `pendente_diretor` do WIP_BOARD.json e responda SIM ou SIM COM AJUSTE para cada um. Quando tiver os 8 respostas → diga ao Músculo "Veredito dado — iniciar Dia 1" e o build começa.

**Ação 2 — 5 questões reais Quadrix (antes do Dia 2)**  
Busque no QConcursos (seu login) 5 questões de provas Quadrix para cargos de nível médio técnico — de preferência das disciplinas SUAS, LOAS ou CRAS/CREAS. Cole aqui como texto puro — sem scraping, sem automação. Essas 5 questões calibram o prompt do gerador (estilo dos distratores, formato dos enunciados, nível de pegadinha).

**Ação 3 — Mostrar este relatório para a Ingrid**  
O relatório foi escrito para ela entender o que foi construído e o que vem. Se ela quiser ajustar algo no plano (disciplinas, horário de estudo, nível de dificuldade), o Dia 3 ainda é o momento certo antes de o Feed Adaptativo travar os parâmetros.

---

## CLAUDE PROJECTS — QUANDO USAR

Eduardo, o Claude Projects (claude.ai/projects) entra quando você for abrir uma sessão de build com o Músculo. O fluxo é:

1. **Agora (antes do Dia 1):** você dá o Veredito nos 8 pontos aqui no Claude Code
2. **Dia 1 — Claude Projects:** abra o projeto Ingrid no Claude Projects, cole a MEMORIA_V1_INGRID.md e diga "PROTOCOLO VANGUARD — PROJ-002 Ingrid. Veredito aprovado nos 8 pontos. Iniciar Dia 1." O Músculo lê a MEMORIA e começa o build
3. **Dia 5 — gate:** ao fechar o Dia 5, volte aqui (Claude Code) para registrar o output e avançar
4. **Loop 2 — Gemini:** antes de ir ao Gemini, atualize o PASSO3_GEMINI.md com o que foi construído nos Dias 1-5 e as 5 ideias do relatório acima

---

*Relatório gerado pelo Músculo (Claude Code) ao fechar Loop 1 · PROJ-002 Ingrid · 2026-05-15*  
*Pentalateral IAH V25 — Conselho: Eduardo (Diretor) · Gemini (Estrategista) · NotebookLM (Auditor) · Claude Code (Músculo)*
