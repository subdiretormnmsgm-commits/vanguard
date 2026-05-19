# Perfil do Candidato — Concurso Sedes-DF 2026
> Documento gerado como protocolo universal de EdTech — P-038 Vanguard Tech
> Todo projeto de educação deve ter este perfil documentado antes do build do banco de questões.

---

## Quem é o candidato típico do Sedes-DF Cargo 202

### Dados do concurso

| Variável | Dado |
|---|---|
| Vagas totais | 4.788 (1.197 imediatas) |
| Taxa de inscrição | R$ 84,00 |
| Perfil de renda estimado | Classe média baixa a média — concurso acessível |
| Escolaridade | Nível médio (não exige superior) |
| Faixa etária provável | 20–40 anos |
| Experiência com concursos | Maioria com 1–3 concursos anteriores |

### Comportamento de estudo típico

| Variável | Perfil típico | O que isso exige do produto |
|---|---|---|
| **Questões por dia** | 30–80 (plataformas abertas) | Banco mínimo de 1.000+ questões |
| **Horas de estudo/dia** | 1–3 horas | Sessões de 20–40 min funcionam melhor que 2h seguidas |
| **Padrão de uso mobile** | Esporádico (trajeto, pausa no trabalho) | App deve funcionar sem internet + sessões curtas |
| **Comparativo de mercado** | Usa TEC Concursos e/ou QConcursos como referência | Precisa sentir vantagem clara vs. essas plataformas |
| **Gatilho de abandono** | Não ver questão nova / não entender por que errou | SM-2 + tutor são resposta direta a esses gatilhos |
| **Definição de progresso** | "Acertei mais do que ontem" | Pontos Ponderados visíveis — nunca Score de Sobrevivência |
| **Medo principal** | Estudar matéria errada e perder tempo | Feed priorizado por score é o antídoto direto |

---

## Segmentação de perfis dentro do universo de candidatos

### Perfil A — Candidato Sistêmico (15–20% do total)
**Quem é:** Estuda com plano, usa caderno, faz cronograma.  
**Comportamento:** 60–100 questões/dia, estuda todo dia, usa múltiplas plataformas.  
**O que quer:** Eficiência — não quer perder tempo com conteúdo que já domina.  
**Risco:** Vai esgotar banco rápido se não houver volume suficiente. Compara taxa de acerto por disciplina.  
**Ingrid é este perfil.**

### Perfil B — Candidato Reativo (50–60% do total)
**Quem é:** Estuda quando lembra, para quando a rotina pesa, retoma quando a prova se aproxima.  
**Comportamento:** 20–40 questões/dia quando ativo, longos períodos sem estudar.  
**O que quer:** Sentir que está "em dia" rapidamente quando retoma.  
**Risco:** Abandona se sentir culpa acumulada de dias perdidos.  
**Resposta do produto:** sessão de 20 questões resolve o dia em 20 minutos — sem julgamento.

### Perfil C — Candidato de Última Hora (20–30% do total)
**Quem é:** Começa a estudar 30–45 dias antes da prova.  
**Comportamento:** Alta intensidade por curto período. Usa resumos e questões de ano anterior.  
**O que quer:** Máxima cobertura no menor tempo.  
**Risco:** Não aproveita o SM-2 (ciclo muito curto).  
**Resposta do produto:** modo "simulado mini" (15 questões, 70/30) — máxima eficiência para prazo curto.

---

## O que o candidato faz no TEC / QConcursos que o produto precisa responder

| Comportamento no TEC | Limitação que o TEC tem | Como o produto resolve |
|---|---|---|
| Filtra por matéria e responde 50 questões | Sem priorização por banca | Feed já prioriza por Score Quadrix |
| Vê gabarito comentado ao errar | Comentário genérico da matéria | Tutor ataca o distrator específico que ele escolheu |
| Faz simulado de 60 questões | Misto sem peso de cargo | Modo simulado completo com distribuição 20/40 (em V2) |
| Salva questões para revisar depois | Revisão manual, sem algoritmo | SM-2 automático — revisão no momento certo |
| Compara desempenho geral | Ranking global sem foco no cargo | Pontos Ponderados refletem peso real da prova |

---

## Volume necessário por fase de estudo

| Fase | Dias | Questões/dia | Questões novas necessárias |
|---|---|---|---|
| Fase 1 — Ritmo (semanas 1–4) | 30 dias | 20 | 600 questões novas |
| Fase 2 — Profundidade (semanas 5–8) | 30 dias | 15 novas + 5 revisão | 450 questões novas |
| Fase 3 — Consolidação (semanas 9–12) | 30 dias | 10 novas + 10 revisão | 300 questões novas |
| Fase 4 — Reta Final (semanas 13–15) | 21 dias | 5 novas + 15 revisão | 105 questões novas |
| **Total necessário** | **111 dias** | — | **~1.455 questões únicas** |

> **Conclusão:** banco mínimo viável para o ciclo completo = **1.000 questões**. Banco ideal = **1.500 questões**. Abaixo de 600, o candidato Sistêmico (Perfil A) começa a ver repetição na semana 5 — risco real de abandono.

---

## Gatilhos de abandono documentados

| Gatilho | Quando ocorre | Como o produto previne |
|---|---|---|
| "Não estou vendo questão nova" | Banco < 600 questões + uso diário | Banco 1.000+ + SM-2 intercalado |
| "Não entendo por que errei" | Gabarito genérico | Tutor Nível 2 — ataca o distrator específico |
| "Estou perdendo tempo com matéria fácil" | Feed sem priorização | Score 190 sempre entra antes de Score 50 |
| "Faz dias que não estudo — desisti" | Interrupção de sequência | Beacon + alerta WhatsApp (Gate Dia 15) |
| "O app travou / não carregou" | Falha técnica | Service worker + graceful degradation |
| "Não sei se estou indo bem" | Ausência de feedback de progresso | Pontos Ponderados visíveis + frase de encerramento (E-5) |

---

## Protocolo P-038 — Perfil de Candidato como pré-requisito de EdTech

> Registrado em 2026-05-18 · Gerado a partir de falha identificada no PROJ-002 Ingrid
> Antes de iniciar o build de banco de questões em qualquer projeto EdTech, documentar obrigatoriamente:

**5 variáveis obrigatórias do Perfil de Candidato:**

| # | Variável | Pergunta |
|---|---|---|
| 1 | **Volume** | Quantas questões/dia o candidato típico faz na plataforma de referência? |
| 2 | **Padrão de sessão** | Uma sessão longa ou várias curtas? Mobile ou desktop? |
| 3 | **Gatilho de abandono** | O que fez candidatos similares pararem de usar plataformas anteriores? |
| 4 | **Referência de mercado** | Com o que ele vai comparar o produto no primeiro uso? |
| 5 | **Definição de progresso** | O que ele precisa sentir para continuar estudando amanhã? |

**Banco mínimo por fase:**
- MVP (primeiros 30 dias): 600 questões únicas
- Produto completo (111 dias): 1.000 questões únicas
- Plataforma escalável: 1.500+ questões únicas

---

*PERFIL_CANDIDATO_SEDES_DF.md — Vanguard Tech · PROJ-002 Ingrid · 2026-05-18*  
*Template universal disponível em: QUADRILATERAL_UNIVERSAL/TEMPLATES/PERFIL_CANDIDATO_TEMPLATE.md*
