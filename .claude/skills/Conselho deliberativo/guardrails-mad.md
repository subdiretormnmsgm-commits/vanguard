# Guardrails MAD — Proteção Contra Falhas em Deliberação Multi-Agente

## Base Científica

Este arquivo documenta os modos de falha identificados em pesquisa sobre Multi-Agent Debate
(MAD) e os protocolos para mitigá-los. Fontes: estudos de Wynn et al. (2025), pesquisa de
anonimização de identidade em MAD (2025–2026), e análise de sycophancy inter-agentes.

---

## Falha 1 — Sycophancy Coletiva

**Sintoma:** Revisores convergem para a mesma resposta sem justificativa técnica diferenciada.
Todos escolhem a Resposta A como "mais forte" com argumentos superficiais.

**Causa:** Modelos são sensíveis a padrões de concordância entre pares. A tendência de favorecer
consenso sobre raciocínio correto é um viés documentado em sistemas MAD.

**Protocolo anti-sycophancy:**
1. Identificar qual resposta está recebendo votos sem justificativa técnica.
2. Instruir cada revisor que ainda não votou a **argumentar explicitamente contra** a resposta
   mais votada antes de confirmar ou alterar seu voto.
3. Se o voto se mantiver após o contra-argumento, é válido. Se mudar sem razão técnica nova,
   descarte e mantenha o voto original.
4. O Presidente deve notar no veredicto se houve pressão de conformidade detectada.

---

## Falha 2 — Viés de Identidade Posicional

**Sintoma:** Revisores avaliam respostas diferentemente dependendo da posição (A, B, C...)
— não pelo conteúdo. Respostas na posição A ou E tendem a ser avaliadas com viés.

**Causa:** Modelos de linguagem exibem preferência posicional (primacy/recency bias) ao
avaliar listas de conteúdo.

**Protocolo:**
1. A atribuição das letras A–E aos conselheiros deve ser **aleatória a cada sessão**.
2. Nunca use a mesma ordem: não mapeie sempre Contrário→A, Primeiros Princípios→B, etc.
3. Se suspeitar de viés posicional (ex: todos os revisores preferem "Resposta A" em sessões
   diferentes mas sempre é o primeiro da lista), reordenar aleatoriamente e re-executar
   a Etapa 3.

---

## Falha 3 — Colapso Prematuro de Consenso

**Sintoma:** Conselheiros convergem para a mesma resposta já na Etapa 2, sem tensão real
entre perspectivas. O Contrário e o Expansionista produzem análises semelhantes.

**Causa:** Personas não suficientemente diferenciadas no prompt, ou pergunta formulada com
viés direcional que induz todos a uma mesma conclusão.

**Protocolo:**
1. Verificar se a pergunta formulada (Etapa 1) contém linguagem que sinaliza a resposta
   esperada. Se sim, reformular de forma neutra.
2. Recarregar `references/conselheiros.md` e garantir que cada conselheiro receba instrução
   explícita de **não moderar** sua perspectiva.
3. Adicionar ao prompt de cada conselheiro: "Se sua análise inicial parecer concordar com
   outras perspectivas óbvias, aprofunde até encontrar onde seu ângulo de pensamento
   genuinamente diverge."

---

## Falha 4 — Presidente Indeciso

**Sintoma:** Veredicto final termina com "depende do contexto", "há mérito em ambos os lados"
ou lista múltiplos próximos passos sem priorização.

**Causa:** Presidente interpretou divergência entre conselheiros como sinal para evitar
posicionamento — o oposto do objetivo do conselho.

**Protocolo:**
1. Se o Presidente produzir veredicto sem recomendação concreta, instruí-lo explicitamente:
   "Você deve escolher uma posição. Divergência entre conselheiros não é razão para omitir
   recomendação — é razão para justificar melhor a escolha. Refaça a seção 'A Recomendação'."
2. A Primeira Ação deve ser exatamente **uma** ação — não uma lista numerada, não "considere X
   ou Y". Se o Presidente listar múltiplas, pedir para escolher a mais prioritária.

---

## Falha 5 — Respostas Genéricas dos Conselheiros

**Sintoma:** Respostas com afirmações como "considere os riscos", "avalie seu contexto",
"depende das suas prioridades" — sem especificidade ao caso do usuário.

**Causa:** Pergunta formulada sem contexto suficiente (Etapa 1 incompleta), forçando os
conselheiros a trabalhar com informação vaga.

**Protocolo:**
1. Retornar à Etapa 1 e verificar se a pergunta formulada inclui: opções concretas, o que
   está em risco, restrições do usuário e números/dados relevantes quando disponíveis.
2. Não prosseguir para a Etapa 2 sem esses elementos.
3. Se o usuário não forneceu contexto suficiente, fazer a pergunta de esclarecimento (uma
   única) antes de formular.

---

## Checklist de Qualidade — Pré-Entrega do Veredicto

Antes de apresentar o veredicto ao usuário, verificar:

- [ ] As 5 respostas dos conselheiros têm entre 150–300 palavras
- [ ] Nenhuma resposta é genérica — todas fazem referência ao caso específico
- [ ] A anonimização das letras A–E foi feita de forma aleatória
- [ ] Nenhum revisor elegeu a mesma resposta sem justificativa técnica distinta
- [ ] O veredicto tem as 5 seções obrigatórias
- [ ] "A Recomendação" é concreta — sem "depende"
- [ ] "A Primeira Ação" é exatamente uma ação
- [ ] Divergências reais estão documentadas (não suprimidas)
- [ ] Pontos cegos da revisão por pares aparecem no veredicto
