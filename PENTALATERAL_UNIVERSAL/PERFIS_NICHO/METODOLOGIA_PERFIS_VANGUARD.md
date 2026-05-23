# METODOLOGIA DE PERFIS VANGUARD
## Framework operacional + 5 nichos adjacentes + protocolo Pentalateral
> **Status:** v1 — primeira versão do método autoral.
> **Mandato:** delegado pelo Diretor em 2026-05-18.
> **Guardião:** Embaixador. **Co-construtores:** Estrategista, Auditor, Músculo, Diretor.
> **Princípio raiz:** P-039 (verbatim é purificação) + tese central do Embaixador (Perfis são trade secret, não produto).

---

## SUMÁRIO EXECUTIVO

Este documento estabelece **como** a Vanguard constrói Perfis de Nicho como ativo proprietário interno — não como produto comercializável, não como pesquisa de mercado descartável, e não como exercício teórico de classificação de clientes.

A tese disruptiva: **o ativo competitivo da Vanguard não é o código, nem o método, nem o LEDGER isoladamente — é a inteligência composta sobre como cada nicho compra, usa e abandona software feito sob medida.**

Concorrente pode copiar um app em uma semana. Não pode copiar 50 Perfis acumulados, cada um validado por cliente real, cada um diminuindo o tempo de onboarding do próximo cliente do mesmo nicho em 50-70%. Isso é defensável por anos.

Este documento entrega:
1. **A metodologia** de construção de Perfil — formato, fontes, validação.
2. **A coordenação Pentalateral** — qual membro do Conselho faz o quê em cada etapa.
3. **Os 5 nichos adjacentes propostos** — ranqueados por viabilidade nos próximos 12 meses.
4. **O roadmap** de execução — quem faz o quê, quando, com que dependência.

---

## 1. O QUE É UM PERFIL DE NICHO (VANGUARD)

### Definição operacional

Um Perfil de Nicho é um documento estruturado em **três vetores obrigatórios** que descreve o arquétipo de cliente de um segmento específico, com profundidade suficiente para acelerar onboarding e diferenciar do mercado.

**Os três vetores:**

1. **Vetor Comportamental** — como o cliente do nicho usa software cotidianamente. Padrão de uso, gatilhos de engajamento, gatilhos de abandono, padrão emocional.
2. **Vetor Comercial** — como o cliente compra. Sensibilidade a preço, janela ideal de pitch, sinais de disposição, modelo aceito (projeto único / mensalidade / híbrido).
3. **Vetor Técnico** — quais restrições técnicas o cliente exige. Plataforma, stack, métricas-alvo, features que entram no MVP, features que ficam para V2, features que **nunca** entram.

### O que um Perfil NÃO É

- **Não é persona de marketing.** Persona ilustra; Perfil opera.
- **Não é segmentação demográfica.** Idade e renda são consequência, não causa.
- **Não é benchmark de concorrência.** Benchmark olha o concorrente; Perfil olha o cliente.
- **Não é produto comercializável.** Perfil é arma interna. Vendê-lo é entregar a chave do moat.

### Maturidade de um Perfil

Cada Perfil tem percentual de maturidade declarado:
- **0-30%** — hipótese de mercado, sem cliente real. Não inicia build.
- **30-60%** — primeiro cliente em discovery ou build. Perfil pode iniciar mas requer validação.
- **60-80%** — primeiro cliente entregue, dados reais de uso. Perfil consolidado parcial.
- **80-100%** — três ou mais clientes do nicho com 60+ dias de uso. Perfil totalmente consolidado.

**Estado atual da Vanguard:** dois Perfis em 50-60% (EdTech-Concurso, Legal-Tech-Criminal). Nenhum acima de 80%.

---

## 2. METODOLOGIA DE CONSTRUÇÃO DE PERFIL

### Etapa 1 — Discovery do nicho (sem cliente, exploratório)

**Quem executa:** Estrategista (Gemini) — pesquisa de mercado externa.
**O que entrega:** documento bruto com:
- 3-5 falhas conhecidas das plataformas líderes do nicho (UX, preço, cobertura).
- 2-3 dores recorrentes documentadas em fóruns/comunidades do nicho.
- Estimativa de tamanho do nicho (número de profissionais ativos no Brasil).
- Plataformas concorrentes com preço médio.
- 3-5 hipóteses iniciais de comportamento a testar.

**Saída:** `PESQUISA_BRUTA_<NICHO>.md` — material para o Embaixador refinar.

### Etapa 2 — Construção do Perfil hipotético

**Quem executa:** Embaixador.
**O que faz:** transforma a pesquisa bruta nos três vetores. Marca explicitamente o que é **hipótese pendente de validação** vs. o que é **fato sustentado por evidência externa**.
**Saída:** `PERFIL_<NICHO>.md` em maturidade 0-30%.

### Etapa 3 — Validação histórica e cruzamento

**Quem executa:** Auditor (NotebookLM).
**O que faz:** cruza o Perfil hipotético com:
- Princípios consolidados do LEDGER que podem se aplicar (P-008 sobre distribuição, P-013 sobre soberania, etc.).
- Outros Perfis já construídos — destaca diferenças estruturais e similaridades enganosas.
- Padrões de fricção conhecidos em projetos anteriores.

**Saída:** comentários e validações que o Embaixador incorpora antes de avançar.

### Etapa 4 — Primeiro cliente real

**Quem executa:** Diretor + Embaixador (qualificação) + Músculo (build).
**O que faz:** captura tudo verbatim em CAMADA_FATOS. Cada interação com o primeiro cliente atualiza o Perfil — confirmando, refutando ou ajustando vetores.
**Saída:** Perfil sobe para 30-60% de maturidade.

### Etapa 5 — Cliente 2 e 3 do nicho

**Quem executa:** ciclo completo, com Perfil já parcialmente consolidado.
**Ganho esperado:** onboarding 50-70% mais rápido que o primeiro cliente. Tempo recuperado é receita líquida ou capacidade para captação de mais leads.
**Saída:** Perfil sobe para 60-80%.

### Etapa 6 — Consolidação como ativo Vanguard

**Quem executa:** Conselho inteiro.
**O que faz:** o Perfil entra na pasta protegida `PERFIS_NICHO/`. Auditor declara consolidação formal. Embaixador atualiza o repositório central.
**Saída:** Perfil 80-100% — pronto para escalar dentro do nicho.

---

## 3. PROTOCOLO PENTALATERAL DE COORDENAÇÃO

### Responsabilidades por membro

| Membro | Papel no Perfil | Output esperado |
|---|---|---|
| **Diretor** | Sensor de fricção biológica. Aprovação de início de nicho. "Feeling do dinheiro" em qualificação. | Decisão GO/NO-GO para cada nicho proposto. Captura verbatim em interações comerciais reais. |
| **Embaixador** | Guardião do Perfil. Coordenador do processo. Interpretação autoral dos três vetores. | Documento `PERFIL_<NICHO>.md` mantido em CAMADA_INFERENCIA do projeto correspondente. |
| **Estrategista** | Sensor macro e regulatório. Pesquisa externa de mercado, concorrência, contexto legal. | Documento `PESQUISA_BRUTA_<NICHO>.md` na Etapa 1. Atualizações regulatórias contínuas. |
| **Auditor** | Validador histórico. Cruzamento com princípios do LEDGER. Detecção de viés. | Validação formal em Etapas 3 e 6. Veto se Perfil contradisser princípios consolidados. |
| **Músculo** | Sensor de viabilidade técnica. Custos de stack, tempo de build, restrições reais. | Estimativa técnica de cada Perfil (viabilidade + custo de API + tempo de MVP). |

### Fluxo de ativação de um nicho novo

```
DIRETOR: "Embaixador, quero explorar nicho X"
   ↓
EMBAIXADOR: avalia se nicho cabe no portfólio atual (capacidade, fit estratégico)
   ↓ (se sim)
EMBAIXADOR → ESTRATEGISTA: solicita PESQUISA_BRUTA_X.md (Etapa 1)
   ↓
ESTRATEGISTA entrega pesquisa em 1-2 dias
   ↓
EMBAIXADOR: constrói PERFIL_X.md hipotético (Etapa 2)
   ↓
EMBAIXADOR → AUDITOR: solicita validação histórica (Etapa 3)
   ↓
AUDITOR retorna comentários e validações
   ↓
EMBAIXADOR: incorpora ajustes, marca Perfil como 0-30% e pronto para captação
   ↓
DIRETOR + MÚSCULO: avaliam viabilidade técnica e capacidade de execução
   ↓
DIRETOR: decisão final GO/NO-GO de captação ativa no nicho
```

**Tempo total estimado da Etapa 1 até GO/NO-GO:** 5-7 dias úteis.

### Princípio operacional

Nenhum membro executa Etapa fora da sua. Estrategista não escreve Perfil. Embaixador não faz pesquisa de mercado externa. Auditor não decide GO/NO-GO. Diretor não escreve documentos.

**A divisão protege a qualidade do output e impede sobreposição.**

---

## 4. CINCO NICHOS ADJACENTES PROPOSTOS

A escolha não é por amplitude — é por **probabilidade de o método Vanguard ganhar mercado nos próximos 12 meses**. Cada nicho proposto satisfaz três critérios:

1. **Tem dor real e documentada.**
2. **Tem cliente disposto a pagar fora da casquinha dos R$97/mês.**
3. **Tem moat construível pelo método Vanguard** (não é mercado dominado por gigante de tech).

### Ranking proposto pelo Embaixador

| # | Nicho | Por que esse | Risco principal | Score viabilidade |
|---|---|---|---|---|
| 1 | **Médico em residência ou pós-residência (R1-R3) preparando prova de especialidade** | Janela temporal igual ao EdTech-Concurso. Cliente paga alto (R$ 200-500/mês em cursinhos). Banco de questões reaproveita SM-2. **Skill da Ingrid migra com baixa adaptação.** | Concorrência forte (Medway, Sanar). Diferenciação tem que ser cirúrgica. | **9/10** |
| 2 | **Pequeno escritório de contabilidade (até 5 contadores) gerando obrigações acessórias para PMEs** | Dor documentada (SPED, eSocial, EFD-Reinf). Cliente legal-tech-derivado. Aceita projeto único + manutenção mínima. **Modelo Valdece migra com adaptação média.** | Mercado regulado e mutável — Estrategista precisa monitorar Receita Federal continuamente. | **8/10** |
| 3 | **Psicólogo clínico autônomo gerenciando agenda, prontuário e prescrição emocional** | Profissional individual, dor de organização, alta disposição a pagar pela tranquilidade. CFP regulamenta prontuário digital. | LGPD pesa muito — Auditor precisa entrar cedo. Risco de over-engineering por exigência regulatória. | **7/10** |
| 4 | **Engenheiro de obras pequenas gerenciando orçamento, cronograma e diário de obra** | Mercado fragmentado, sem player dominante. Cliente desktop-first (canteiro). Dor de papel/Excel é real. | Cliente fragmentado regionalmente — captação custosa. Ticket médio incerto. | **6/10** |
| 5 | **Professor universitário ou de pós-graduação preparando aulas, materiais e revisão por pares** | Cliente intelectualmente sofisticado, valoriza ferramenta soberana, tem orçamento individual. Adjacente a EdTech sem ser EdTech-Concurso. | Adoção institucional é lenta. Indicação entre acadêmicos é rápida quando acontece. | **6/10** |

### Detalhamento dos top 3

#### Nicho #1 — Médico em preparação para prova de especialidade

**Por que migra do EdTech-Concurso:** SM-2 funciona, banco de questões funciona, Tutor Socrático funciona. **O que muda:** linguagem técnica (CID, fluxogramas clínicos), tipo de questão (casos clínicos longos), tom (médicos esperam austeridade técnica, não "carinho").

**Janela ideal de captação:** 60-120 dias antes da prova (Revalida, residência, especialidade).

**Ticket viável:** R$ 150-300/mês durante o ciclo, sem regateio se entrega for específica para a especialidade alvo.

**Próximo passo se aprovado:** Estrategista entrega PESQUISA_BRUTA_MEDICINA.md em 3 dias. Embaixador propõe Perfil em mais 2 dias.

#### Nicho #2 — Pequeno escritório de contabilidade

**Por que adjacente ao Legal-Tech:** mesmo arquétipo de "profissional autônomo sob pressão técnica e regulatória, com dor de software grande caro". Mesma sensibilidade a soberania.

**Diferença crítica:** atualização legal/normativa é muito mais frequente que jurisprudência. Produto vive ou morre por velocidade de atualização. Exige Radar de Divergência ativo desde o Dia 1.

**Ticket viável:** R$ 8.000-15.000 projeto único + R$ 500-800/mês manutenção (justificado por monitoramento contínuo de mudanças normativas).

#### Nicho #3 — Psicólogo clínico autônomo

**Por que é o mais arriscado dos três top:** LGPD + CFP regulamentam dado de paciente com rigor. Erro técnico de armazenamento = problema ético + legal. Auditor precisa entrar cedo e ficar.

**Por que pode valer:** mercado de ~250.000 psicólogos ativos no Brasil. Player dominante (iClinic) tem fricções conhecidas e mensalidade pesada para autônomo (R$200-400/mês).

**Ticket viável:** R$ 80-150/mês — modelo SaaS mais próximo do EdTech que do Legal-Tech.

---

## 5. O QUE TORNA ESSA METODOLOGIA DISRUPTIVA

Eduardo, você pediu solução disruptiva. Vou ser direto sobre o que é e o que não é disruptivo aqui — sem inflar o discurso.

### O que NÃO é disruptivo (e seria erro afirmar que é)

- Ter Perfis de Cliente. Toda agência de produto tem isso, com nomes diferentes (personas, JTBD, ICPs).
- Mapear dor por nicho. Pesquisa qualitativa básica faz isso desde os anos 1980.
- Usar IA para gerar Perfil. Toda startup com OpenAI faz isso hoje.

### O que É disruptivo

**Disrupção #1 — Perfis como propriedade composta, não inteligência descartável**
A maioria das agências constrói "persona" no início do projeto e abandona. Vanguard constrói Perfil que **acumula evidência verbatim a cada cliente novo, atualiza a cada 30 dias, e diminui o custo unitário do próximo cliente em 50-70%**. Em 24 meses com 50 clientes, isso é moat impossível de copiar — concorrente teria que ter passado pelos mesmos 50 clientes.

**Disrupção #2 — Coordenação Pentalateral declarada**
Não é "consultoria com IA". É um Conselho com 4 IAs especializadas + 1 humano, cada um com mandato declarado, cada output rastreável por membro. Concorrente que tenta replicar precisa replicar o protocolo, não a tecnologia.

**Disrupção #3 — Princípio de captura única, extração múltipla**
A CAMADA_FATOS de cada cliente alimenta múltiplos Perfis. O verbatim da Ingrid valida o Perfil EdTech-Concurso E informa indiretamente o Perfil Médico-Prova (porque o vetor comportamental "estudante em pré-prova" tem componentes universais). Inteligência de um cliente pode iluminar 3 Perfis simultaneamente — sem o cliente saber, sem o concorrente conseguir cruzar.

**Disrupção #4 — Custo marginal decrescente da inteligência**
Primeiro Perfil custou 15 dias (Ingrid). Próximo Perfil do mesmo nicho deve custar 5 dias. Décimo Perfil de qualquer nicho deve custar 2 dias. **Os concorrentes têm custo marginal constante ou crescente** — cada novo cliente é tratado como o primeiro. Vanguard tem custo marginal decrescente.

**Onde a disrupção pode falhar:**
Se o Conselho parar de extrair princípios na hora da fricção (P-005). Se os Perfis virarem documento morto não atualizado. Se algum membro do Conselho começar a operar em silo. Disrupção sustentada exige disciplina sustentada — P-029 aplicado.

---

## 6. ROADMAP DE EXECUÇÃO — PRÓXIMAS 4 SEMANAS

### Semana 1 (2026-05-19 a 2026-05-25)

| Dia | Ação | Responsável | Output |
|---|---|---|---|
| 19/05 | Diretor entrega Valdece presencialmente. Embaixador capta fricções verbatim para atualizar Perfil Legal-Tech. | Diretor + Embaixador | CAMADA_FATOS PROJ-001 atualizada |
| 20/05 | Diretor aprova (ou rejeita) os 3 nichos top deste documento | Diretor | Decisão GO/NO-GO por nicho |
| 21-22/05 | Se aprovado nicho #1 (Médico): Estrategista executa PESQUISA_BRUTA_MEDICINA.md | Estrategista | Documento bruto |
| 23-24/05 | Embaixador constrói PERFIL_MEDICINA.md hipotético | Embaixador | Perfil v1 em 0-30% |
| 25/05 | Gate Dia 15 da Ingrid. Atualização final do PERFIL_EDTECH_CONCURSO | Embaixador | Perfil v2 em 60-80% |

### Semana 2

| Dia | Ação | Responsável |
|---|---|---|
| 26-27/05 | Auditor valida PERFIL_MEDICINA contra LEDGER | Auditor |
| 28-29/05 | Pesquisa de mercado nicho #2 (Contabilidade) — se aprovado | Estrategista |
| 30/05 | Entrega final PROJ-002 Ingrid. Perfil EdTech-Concurso vira referência interna oficial | Diretor + Embaixador |

### Semana 3

| Dia | Ação | Responsável |
|---|---|---|
| 02-04/06 | Embaixador constrói PERFIL_CONTABILIDADE.md | Embaixador |
| 05-06/06 | Estrategista mapeia primeiros 5-10 leads em cada nicho aprovado | Estrategista |

### Semana 4

| Dia | Ação | Responsável |
|---|---|---|
| 09-13/06 | Primeira tentativa de captação ativa em nicho novo | Diretor + Embaixador |

**Marco crítico:** ao final de 4 semanas, Vanguard deve ter:
- 2 Perfis em 60-80% (EdTech-Concurso, Legal-Tech-Criminal).
- 1-2 Perfis novos em 30-60% (com primeiro lead em discovery).
- Repositório `PERFIS_NICHO/` formalizado com 4 documentos.
- Protocolo Pentalateral testado em pelo menos 1 ciclo completo.

---

## 7. RISCOS DECLARADOS

Se este documento não tivesse riscos declarados, seria propaganda interna. Riscos reais:

**Risco 1 — Construir Perfil sem cliente vira teoria desconectada.**
Mitigação: nenhum Perfil sobe acima de 30% sem cliente real em discovery. Documentos hipotéticos são rotulados como tal.

**Risco 2 — Capacidade humana do Diretor é o gargalo.**
Cada Perfil novo demanda pelo menos um cliente em discovery, e Diretor é o único humano. Não escala linearmente. Mitigação: priorizar 3 nichos em 12 meses, não 10.

**Risco 3 — Estrategista pode entregar pesquisa de superfície (Reddit, App Store).**
Mitigação: Embaixador define perguntas específicas antes de solicitar pesquisa, e Auditor valida fontes citadas.

**Risco 4 — Algum Perfil pode estar errado e contaminar próximos clientes.**
Mitigação: Auditor com poder de veto formal. Perfil em estado 0-30% nunca dirige decisão de build, só captação.

**Risco 5 — Vazamento de Perfis ao mercado.**
Perfis nunca em proposta comercial, contrato ou material externo. Repositório `PERFIS_NICHO/` em pasta protegida fora do controle público.

---

## 8. PRINCÍPIOS CANDIDATOS GERADOS POR ESTE DOCUMENTO

| ID | Princípio | Aplicação |
|---|---|---|
| **P-043 (proposto)** | Perfil de Nicho é trade secret. Nunca em proposta, contrato ou pitch externo. | Todo material externo da Vanguard |
| **P-044 (proposto)** | Perfil avança de maturidade só com evidência de cliente real, nunca por extrapolação isolada de pesquisa de mercado. | Toda construção de Perfil |
| **P-045 (proposto)** | Cada Perfil novo declara explicitamente como difere dos Perfis vizinhos. Não declarar diferença = aceitar contaminação. | Toda construção e revisão de Perfil |
| **P-046 (proposto)** | Pesquisa de mercado externa é insumo do Estrategista, nunca substituto da captura verbatim do cliente. Os dois alimentam o Perfil de forma complementar, não substituta. | Coordenação Pentalateral |

---

## 9. CONVITE EXPLÍCITO AOS OUTROS MEMBROS DO CONSELHO

Este documento é minha proposta. Não decreto.

**Para o Estrategista (Gemini):** este framework te dá mandato de pesquisa externa estruturado. Topa? Tem ajuste a propor antes da Etapa 1 do primeiro nicho?

**Para o Auditor (NotebookLM):** este framework te dá poder de veto formal sobre Perfis em consolidação. Justo? Os critérios de validação (cruzamento com LEDGER, detecção de viés) estão suficientes?

**Para o Músculo (Claude Code):** este framework te coloca como sensor de viabilidade técnica antes de Perfil virar comercialização. Aceita estimar custo de stack e tempo de MVP por nicho proposto?

**Para o Diretor (Eduardo):** este framework te dá decisão GO/NO-GO em momento declarado. Aprova o fluxo? Tem nicho top-3 que rejeita? Tem nicho fora desta lista que quer ver entrar?

---

## 10. FECHAMENTO

Eduardo, você pediu solução disruptiva. Não é disruptivo afirmar disrupção — é disruptivo construir algo que o concorrente não consegue copiar mesmo vendo. Este framework, **se executado com a disciplina de captura verbatim e a coordenação Pentalateral**, é o que torna Vanguard impossível de igualar em 24 meses.

A condição é dura: requer que os 5 membros do Conselho operem em mandato declarado, sem sobreposição, sem silos, com captura única e extração múltipla.

Se quiser ajustes neste framework, vamos ajustar. Se quiser começar pelo nicho #2 ou #3 em vez do #1, vamos. Se quiser veto a algum nicho dos 5 propostos, vetamos.

A próxima palavra é sua.

---

> *Documento autoral do Embaixador, construído sobre CAMADA_FATOS dos PROJ-001 e PROJ-002, validado contra princípios do LEDGER, e proposto formalmente ao Conselho Pentalateral em 2026-05-18.*
