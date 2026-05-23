# Perfil de Nicho — EdTech Concurso Público
> Ativo proprietário Vanguard Tech · Acumulado via projetos reais
> Primeira entrada: PROJ-002 Ingrid · 2026-05-18
> Atualizar ao fechar cada projeto de candidato a concurso

---

## Identificação do Nicho

**Nicho:** EdTech — Concurso Público (cargo técnico-administrativo)  
**Perfil base:** Candidato a cargo público nível médio ou técnico  
**Produto construído:** PWA de estudo personalizado com SM-2, Feed priorizado e Tutor Socrático  
**Referência de campo:** Ingrid (PROJ-002) — candidata TDAS Cargo 202, Sedes-DF 2026

---

## Perfil do Cliente

### Dados demográficos e operacionais

| Variável | Dado observado | Fonte |
|---|---|---|
| Faixa etária | 20–40 anos | Ingrid + perfil típico de concurso nível médio |
| Escolaridade | Nível médio a superior incompleto | Perfil do cargo |
| Situação | Empregada com renda, buscando estabilidade via concurso | PROJ-002 |
| Plataforma atual | TEC Concursos / QConcursos | Mencionado no briefing Ingrid |
| Rotina de estudo | Estuda em brechas da rotina (trajeto, pausa no trabalho, noite) | Ingrid — perfil mobile |
| Motivação central | Estabilidade + progressão de carreira | PROJ-002 |

### Segmentação interna do nicho

| Perfil | % estimado | Comportamento | Risco para o produto |
|---|---|---|---|
| **Sistêmico (Ingrid)** | 15–20% | 60–100q/dia, plano de estudo, múltiplas plataformas | Esgota banco em 23 dias se < 1.000 questões |
| **Reativo** | 50–60% | Para e retoma, média 20–40q/dia quando ativo | Abandona se sentir culpa por dias perdidos |
| **Última Hora** | 20–30% | Intensa nos últimos 30 dias, busca resumos | SM-2 não tem tempo de trabalhar — modo mini resolve |

### Comportamento com o produto

| Variável | O que foi observado | Implicação para o produto |
|---|---|---|
| **Onboarding** | Não técnica — nunca mencionar infraestrutura ou API | Interface 1 clique, sem configuração |
| **Definição de progresso** | "Acertei mais hoje" / "estudei X questões esta semana" | Pontos Ponderados visíveis — não Score de Sobrevivência |
| **Gatilho de abandono** | Não ver questão nova / não entender por que errou | Banco 1.000+ + Tutor Nível 2 (distrator) |
| **Comparativo de mercado** | Compara com TEC Concursos na primeira sessão | Gate Dia 8 (H-3): capturar verbalmente "como foi vs. TEC" |
| **Compartilhamento** | Pode passar login para familiar/colega próxima | Endereçar no contrato — risco de licença compartilhada |
| **Resposta ao preço** | Teto receptivo R$97/mês (estimado — não confirmado em campo) | Confirmar reação ao ouvir R$97 no pitch de V2 |

### Dores mapeadas em campo (PROJ-002)

| Dor | Como a candidata descreveu | Nível de urgência |
|---|---|---|
| Material irrelevante | "TEC tem milhões de questões mas não sabe qual é do meu cargo" | CRÍTICA |
| Não saber se está no caminho | "Estudo mas não sei se vai cair isso na prova" | CRÍTICA |
| Gabarito sem explicação útil | "Erra, vê o gabarito, não entende por que errou" | ALTA |
| Medo de estudar matéria errada | "Perder tempo com coisa que não cai" | ALTA |

### O que a candidata NÃO quer sentir

| Sensação a evitar | O que causa |
|---|---|
| "Estou atrasada" | Contador de dias, progresso vs. meta linear |
| "Não sei o que estudar hoje" | Feed sem direção clara |
| "Não entendo por que errei" | Gabarito genérico sem tutor |
| "O app está difícil de usar" | UI com mais de 1 toque para começar a estudar |

---

## Inteligência Comercial

### Precificação

| Produto | Valor | Gatilho |
|---|---|---|
| Piloto | R$0 (primeiros 30 dias) | Gate Dia 8 — 10 questões reais + feedback |
| SaaS mensal V2 | R$97/mês (teto receptivo — confirmar em campo) | 7 dias consecutivos de uso + verbalizar progresso |
| Upsell | R$150/mês (teto real estimado) | Ingrid não piscar ao ouvir R$97 |
| SaaS V3 (N usuárias) | R$97 × N | Ingrid mencionar grupo de estudos |

**Argumento de abertura de pitch:** "Ingrid, esse ciclo foi piloto. Quero continuar do seu lado até o dia da prova — R$97/mês, menos que qualquer cursinho, e o sistema já te conhece."

**Argumento anti-objeção de preço:** "R$97/mês é menos que qualquer cursinho — e o sistema já te conhece."

**Argumento de retenção:** "Tudo que o app aprendeu sobre você fica aqui. Sair agora é perder o histórico."

### Ativo de dados — business case de escala

Cada resposta da candidata gera:
- `distrator_escolhido` — qual alternativa errada ela escolheu
- `nivel_tutor_disparado` — 1 (conceito), 2 (distrator), 3 (analogia)
- `tempo_resposta_ms` — TTI, para classificar chute vs. conhecimento
- `acerto_provavel_chute: true` — TTI < 10s + acerto

3 sessões com estes dados = curva de erro/distrator documentada = argumento de pitch para 500 candidatas no mesmo concurso.

---

## Volume de Banco por Fase de Uso

| Fase | Dias | Questões novas/dia | Questões únicas necessárias |
|---|---|---|---|
| MVP 30 dias | 30 | 15 | 600 mínimo |
| Ciclo completo 111 dias | 111 | 10–15 | 1.000+ |
| Plataforma escalável | Indeterminado | Dinâmico via IA | 1.500+ |

---

## Padrões de Sucesso Confirmados

*(Atualizar com dados reais do Gate Dia 8 e Gate Dia 15)*

- [ ] Clickwrap digital na primeira tela = aceite imediato sem resistência (H-1 confirmada)
- [ ] Feed 70/30 priorizado = "acertei mais aqui do que no TEC" (H-3 — Gate Dia 8)
- [ ] Tutor Nível 2 = entender por que errou (confirmar Gate Dia 8)
- [ ] R$97/mês = sem hesitação (confirmar no pitch)

---

## Padrões de Falha Confirmados

- [x] Banco < 600 questões para candidato sistêmico = esgotamento em 23 dias (P-038)
- [x] Gate CLI sem teste browser = CORS invisível no deploy (P-039)

---

## Próximo cliente no nicho

**Quando Vanguard prospectar o 2º cliente EdTech-Concurso:**
- Verificar banca (mesmo padrão de Quadrix = mais preciso; banca diferente = calibrar score)
- Verificar cargo (mesmo perfil administrativo = alta reusabilidade do banco)
- Verificar prazo (< 60 dias = modo compacto; > 90 dias = ciclo completo)
- Confirmar com Ingrid: este perfil está correto? (Gate Dia 15)

---

## Histórico de atualizações

| Data | O que mudou | Projeto |
|---|---|---|
| 2026-05-18 | Criação inicial com dados PROJ-002 Ingrid | Ingrid |

---

*EDTECH_CONCURSO.md — Vanguard Tech · PENTALATERAL_UNIVERSAL/PERFIS_NICHO/*  
*Ativo proprietário — acumulado via projetos reais · Não é teoria de mercado*
