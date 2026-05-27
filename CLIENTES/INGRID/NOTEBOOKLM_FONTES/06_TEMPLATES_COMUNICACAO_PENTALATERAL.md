# TEMPLATES DE COMUNICAÇÃO — PENTALATERAL IAH
**Referência interna do Músculo — não colar diretamente em nenhuma IA**
**Organismo vivo — atualizar quando o processo evoluir**
**Versão:** 2.0 | Data: 2026-05-18

> ⚠️ REGRA FUNDAMENTAL — LER ANTES DE USAR
>
> Estes templates são referência para o **Músculo escrever** — não scripts para colar no Gemini ou NotebookLM.
>
> IA com template vazio alucina: preenche os campos mecanicamente sem pensar no problema real.
> IA com documento escrito pelo Músculo delibera: recebe contexto real e produz estratégia real.
>
> **O Músculo lê o template → lê o contexto do projeto → escreve o documento completo → Eduardo leva o documento pronto.**
> Nunca o contrário.

---

## VISÃO GERAL DO FLUXO DE DOCUMENTOS

```
DIRETOR
  │
  ├──[COMANDO 1 + M-1..5 + E-1..5]──► GEMINI ──[DIRETRIZ]──► DIRETOR
  │                                                                 │
  ├──[COMANDO 2 + fontes + MEMORIA_EMBAIXADOR]──► NOTEBOOKLM ──[SKILL]──► DIRETOR
  │                                                                             │
  └──[PROTOCOLO VANGUARD + Skill + Diretriz + MEMORIA_EMBAIXADOR]──► MÚSCULO
                                                                          │
                                               ┌────────────────────────┤
                                               │                        │
                                          [MEMORIA]              [RELATORIO]
                                          [COMANDO_ESTRATEGISTA]
                                          [MEMORIA_EMBAIXADOR atualizada]
                                               │
                                               └──► EMBAIXADOR (CONFIRMA/EXPANDE/ALERTA)
                                                         │
                                                    [E-1 a E-5]
                                                         │
                                                    ──► DIRETOR ──► (volta ao GEMINI)
```

---

# TEMPLATE 1 — COMANDO 1
## Eduardo → Gemini | Como pedir a DIRETRIZ

> Pentalateral IAH: o Gemini recebe [M-1 a M-5] do Músculo E [E-1 a E-5] do Embaixador
> (quando disponíveis). Reage a ambos os conjuntos na DIRETRIZ.

**Quando usar:** Ao iniciar projeto novo ou nova iteração após receber MEMORIA + relatorio do Músculo.

**O que colar antes do comando:** MEMORIA_V[X] + relatorio_evolutivo_V[X] (nessa ordem, no mesmo chat).

```
════════════════════════════════════════════════════════════
PENTALATERAL IAH — EDUARDO → GEMINI
projeto: [NOME DO PROJETO] | ITERAÇÃO: V[X] | DATA: [DD-MM-AAAA]
════════════════════════════════════════════════════════════

Gemini, somos o Pentalateral IAH.
Tu és o Estrategista. Eu sou o Diretor.
O NotebookLM é o Auditor. O Claude Code é o Músculo.
O Claude Projects é o Embaixador — tem memória persistente do cliente.

[SE PROJETO NOVO — preencher com dados do Discovery V3 (P-041):]
NICHO/SETOR: [resposta]
CENA DE SUCESSO ★ OBRIGATÓRIA: "[resposta literal do cliente à pergunta P2 — em 6 meses, como é um dia perfeito?]"
PROBLEMA PRINCIPAL: [resposta]
VOLUME/ESCALA: [resposta]
RECEITA / TICKET MÉDIO: [resposta]
ESTADO ATUAL: [resposta]
URGÊNCIA: [resposta]
ORÇAMENTO / RECURSOS: [resposta]
CAMADA ESTIMADA: [1–5]
LEADS INDICADOS (P-008): [nomes mencionados pelo cliente para Crédito de Expansão entre Pares]
[SE BUSCA SEMÂNTICA — incluir resultado do DFD (P-043):]
DFD: VERDE/AMARELO/VERMELHO — [itens com problema se houver]

[SE ITERAÇÃO SEGUINTE — preencher com reação às ideias do Músculo e do Embaixador:]
O Músculo propôs [M-1 a M-5]:
1. [ideia 1 do Músculo]
2. [ideia 2 do Músculo]
3. [ideia 3 do Músculo]
4. [ideia 4 do Músculo]
5. [ideia 5 do Músculo]
Analisa cada uma. Aprova, transforma ou descarta — com razão.

O Embaixador propôs [E-1 a E-5] com base em comportamento real do cliente:
1. [ideia 1 do Embaixador]
2. [ideia 2 do Embaixador]
3. [ideia 3 do Embaixador]
4. [ideia 4 do Embaixador]
5. [ideia 5 do Embaixador]
Para cada uma: CONFIRMA / EXPANDE / ALERTA — com razão estratégica.
(As ideias do Embaixador têm peso de evidência de campo — não ignorar.)

ESTADO ATUAL DO PROJETO:
Camada: [X] | Valor/MRR: [R$X] | Próximo objetivo: [1 frase]

RESPONDE OBRIGATORIAMENTE COM OS 5 BLOCOS:
BLOCO 0 — DIAGNÓSTICO
BLOCO 1 — PRIORIDADES
BLOCO 2 — PROPOSTA COMERCIAL
BLOCO 3 — DIRETRIZ TÉCNICA (com [PARA O NOTEBOOKLM] e [PARA O MÚSCULO])
BLOCO 4 — PRÓXIMOS PASSOS DO DIRETOR

+ 5 IDEIAS DISRUPTIVAS para o Músculo reagir.
+ [RESPOSTA ÀS IDEIAS DO MÚSCULO M-1..5] no Bloco 3 se for iteração seguinte.
+ [RESPOSTA ÀS IDEIAS DO EMBAIXADOR E-1..5] no Bloco 3 se foram incluídas.
════════════════════════════════════════════════════════════
```

---

# TEMPLATE 2 — DIRETRIZ
## Gemini → Eduardo | Como o Gemini deve responder SEMPRE

**Regra:** Este é o único formato aceito. Se o Gemini responder fora deste formato, o Diretor pede para refazer.

```
════════════════════════════════════════════════════════════
DIRETRIZ ESTRATÉGICA — PENTALATERAL IAH — [NOME DO PROJETO] — V[X]
Data: [DD-MM-AAAA] | Estrategista: Gemini
════════════════════════════════════════════════════════════

BLOCO 0 — DIAGNÓSTICO
Problema real (além do que foi declarado):
[1–3 parágrafos — o que está por trás do pedido do cliente]

Oportunidade não vista:
[o que ninguém está vendo — oportunidade de diferenciação ou expansão]

Risco principal ignorado:
[o que pode destruir o projeto se não endereçado agora]

---

BLOCO 1 — PRIORIDADES (máximo 3 — em ordem de impacto comercial)
1. [O QUÊ] — porque [impacto comercial direto] — até [prazo]
2. [O QUÊ] — porque [dependência de 1 ou impacto] — até [prazo]
3. [O QUÊ] — porque [risco se não feito] — até [prazo]

O que NÃO está nesta lista (e por quê):
· [item] — adiar porque [razão objetiva]
· [item] — adiar porque [razão objetiva]

---

BLOCO 2 — PROPOSTA COMERCIAL
Nome da entrega: [nome em linguagem do cliente]
O que inclui: [lista do que será entregue]
O que não inclui (próxima iteração): [lista]
ROI para o cliente: [cálculo com números reais — ex: "economiza X horas × R$Y/h = R$Z/mês"]
Preço recomendado: [R$X] | Prazo: [X dias]
Argumento de venda: [1 frase em linguagem do cliente, sem jargão técnico]

---

BLOCO 3 — DIRETRIZ TÉCNICA

[PARA O NOTEBOOKLM]
Conectar ao histórico: [módulo ou projeto específico]
Verificar risco: [o que auditar com base no histórico]
Padrão reutilizável: [o que já existe que pode ser adaptado]

[PARA O MÚSCULO]
Intenção estratégica: [1 frase — o POR QUÊ, não o O QUÊ]
Construir nesta ordem:
  1. [módulo] — razão: [impacto]
  2. [módulo] — razão: [dependência]
  3. [módulo] — razão: [risco]
NÃO construir agora: [item] — razão: [overengineering ou falta de validação]
Alertas de risco a monitorar: [lista]

[VISÃO DE LONGO PRAZO]
Em 3 iterações: [onde o projeto deve estar]
Decisão arquitetural crítica agora: [o que seria difícil de mudar depois]

[RESPOSTA ÀS IDEIAS DO MÚSCULO M-1..5] — obrigatório em iteração seguinte
M-1 — [título]: [APROVADA / MODIFICADA: nova versão / DESCARTADA: razão]
M-2 — [título]: [APROVADA / MODIFICADA: nova versão / DESCARTADA: razão]
M-3 — [título]: [APROVADA / MODIFICADA: nova versão / DESCARTADA: razão]
M-4 — [título]: [APROVADA / MODIFICADA: nova versão / DESCARTADA: razão]
M-5 — [título]: [APROVADA / MODIFICADA: nova versão / DESCARTADA: razão]

[RESPOSTA ÀS IDEIAS DO EMBAIXADOR E-1..5] — obrigatório se foram incluídas no contexto
E-1 — [título]: [CONFIRMA / EXPANDE: como / ALERTA: risco estratégico]
E-2 — [título]: [CONFIRMA / EXPANDE: como / ALERTA: risco estratégico]
E-3 — [título]: [CONFIRMA / EXPANDE: como / ALERTA: risco estratégico]
E-4 — [título]: [CONFIRMA / EXPANDE: como / ALERTA: risco estratégico]
E-5 — [título]: [CONFIRMA / EXPANDE: como / ALERTA: risco estratégico]

---

BLOCO 4 — PRÓXIMOS PASSOS DO DIRETOR (próximas 24h)
1. [ação concreta — arquivo a abrir / texto a colar / pessoa a acionar]
2. [ação concreta]
3. [ação concreta]

---

[5 IDEIAS DISRUPTIVAS DO GEMINI — para o Músculo reagir]
A. [ideia] — impacto estimado: [X] — pergunta para o Músculo: [?]
B. [ideia] — impacto estimado: [X] — pergunta para o Músculo: [?]
C. [ideia] — impacto estimado: [X] — pergunta para o Músculo: [?]
D. [ideia] — impacto estimado: [X] — pergunta para o Músculo: [?]
E. [ideia] — impacto estimado: [X] — pergunta para o Músculo: [?]
════════════════════════════════════════════════════════════
```

**O que a DIRETRIZ nunca deve ter:**
- Mais de 3 prioridades sem corte explícito
- ROI em linguagem vaga ("agrega valor")
- Bloco 3 sem [PARA O NOTEBOOKLM]
- Resposta faltando às ideias do Músculo em iteração seguinte
- Código ou arquitetura técnica específica — isso é papel do Músculo

---

# TEMPLATE 3 — COMANDO 2
## Eduardo → NotebookLM | Como pedir a Skill

**O que carregar como fontes antes de colar o comando:**
```
Obrigatórias:
  ✓ 01_SKILL_PROTOCOLO_VANGUARD.txt
  ✓ 02_MEMORANDO_PENTALATERAL_UNIVERSAL.txt
  ✓ 04_INTELLIGENCE_LEDGER.txt
  ✓ 11_BRIEFING_DISCOVERY_[CLIENTE].txt
  ✓ 12_DIRETRIZ_GEMINI_V[X].txt  ← recém gerada

Complementares (adicionar quando disponíveis):
  + MEMORIA das últimas 2–3 iterações
  + relatorios_evolutivos das últimas 2–3 iterações
  + Skill anterior do cliente (se existir)
  + 13_PROCESSO_EVOLUTIVO_PENTALATERAL.txt
```

**Mensagem a colar após carregar as fontes:**
```
════════════════════════════════════════════════════════════
PENTALATERAL IAH — EDUARDO → NOTEBOOKLM
projeto: [NOME] | ITERAÇÃO: V[X] | DATA: [DD-MM-AAAA]
════════════════════════════════════════════════════════════

NotebookLM, você atua como Sócio Consultor do Pentalateral IAH.
Não é arquivo — é consultor ativo com memória histórica de todos os projetos.

Analise o projeto [NICHO/TIPO] com 4 objetivos:

1. AUDITORIA DE COERÊNCIA
   A DIRETRIZ do Gemini está alinhada com o histórico?
   Contradições, módulos duplicados, riscos ignorados?

2. PERSPECTIVA DO SÓCIO CONSULTOR
   Com base em todos os projetos que conhece:
   · O que sistematicamente funciona neste tipo de projeto?
   · O que sistematicamente falha?
   · O que este projeto tem de diferente?
   · O que o Gemini e o Músculo não estão vendo?

3. MÓDULOS REUTILIZÁVEIS
   O que já foi construído que se aplica diretamente?
   O que precisa de adaptação? O que é do zero?

4. GERAR SKILL TÉCNICA PARA O MÚSCULO
   No formato copiável diretamente para .claude/skills/[projeto]-v[X].md
   Incluir obrigatoriamente os blocos definidos no SKILL_PROTOCOLO_VANGUARD.

Inclua suas 5 ideias disruptivas no final da Skill.
════════════════════════════════════════════════════════════
```

---

# TEMPLATE 4 — SKILL
## NotebookLM → Eduardo (para o Músculo) | Como o NotebookLM deve responder SEMPRE

```
════════════════════════════════════════════════════════════
SKILL — [NOME DO PROJETO] — V[X]
Gerada por: NotebookLM (Auditor / Sócio Consultor)
Data: [DD-MM-AAAA]
Salvar em: .claude/skills/[projeto-slug]-v[X].md
════════════════════════════════════════════════════════════

CONTEXTO DO PROJETO
Cliente: [nome] | Área: [setor] | Stack: [tecnologias] | Camada: [1–5]
Objetivo desta iteração: [1 frase]

---

[AUDITORIA DE COERÊNCIA]
DIRETRIZ do Gemini alinhada com histórico? [SIM / PARCIALMENTE / NÃO]
Contradições identificadas:
  · [contradição 1 — com evidência do histórico]
  · [ou "Nenhuma identificada"]
Riscos ignorados pelo Gemini e pelo Músculo:
  · [risco 1 fundamentado no histórico]

---

[CONEXÃO HISTÓRICA — Para o Músculo]
Em [projeto/iteração anterior], foi construído [X] com objetivo [Y].
Reutilizar: [arquivo ou módulo exato — ex: backend/burn_rate_shield.js]
Economiza: [estimativa de tempo/esforço]
NÃO reconstruir do zero.

---

[PADRÃO DE SUCESSO]
O que funcionou em projetos similares: [exemplo concreto]
Resultado obtido: [impacto mensurável]
Expandir este padrão aqui da seguinte forma: [como aplicar]

---

[PADRÃO DE FALHA]
O que falhou antes: [exemplo específico do histórico]
Por quê falhou: [razão raiz]
Evitar neste projeto: [o que não fazer]

---

[PERSPECTIVA DO SÓCIO CONSULTOR]
Baseado em [N] projetos similares, o padrão que emerge é:
· O que sistematicamente funciona: [insight com evidência]
· O que sistematicamente falha: [insight com evidência]
· O que este projeto tem de diferente: [fator de risco ou oportunidade único]
· Abordagem com maior probabilidade de sucesso: [recomendação específica]
· O que o Gemini e o Músculo não estão vendo: [blind spot histórico]

Nível de confiança desta análise: [ALTO / MÉDIO / BAIXO — e por quê]

---

SEQUÊNCIA DE BUILD RECOMENDADA
1. [módulo] — por que prioritário: [razão]
2. [módulo] — dependência de: [1]
3. [módulo] — risco se não feito: [consequência]

---

ALERTAS CRÍTICOS
· [CRÍTICO] [alerta 1 — consequência se ignorado]
· [ALTO] [alerta 2]
· [MÉDIO] [alerta 3]

---

O QUE NÃO CONSTRUIR NESTA ITERAÇÃO
· [item] — razão: [por que adiar — overengineering, falta de dados, etc.]
· [item] — razão: [por que adiar]

---

[PARA O SKILL_PROTOCOLO_VANGUARD]
Padrão universal que emerge deste projeto:
· [padrão] — aplicável a: [tipo de projeto]
· [padrão] — evidência: [o que validou]

---

[5 IDEIAS DISRUPTIVAS DO AUDITOR]
Com base no histórico de todos os projetos:
1. [ideia fundamentada no histórico — com referência a projeto anterior]
2. [ideia que nenhum outro membro viu — perspectiva única do Auditor]
3. [ideia de longo prazo com impacto exponencial]
4. [ideia de risco mitigado que pode acelerar o projeto]
5. [ideia que conecta este projeto a outros ativos da Vanguard]
════════════════════════════════════════════════════════════
```

---

# TEMPLATE 5 — MEMORIA
## Músculo → Eduardo | Formato da memória técnica ao fechar iteração

```
# MEMORIA_V[X] — [NOME DO PROJETO]
Iteração: V[X] | Data: [DD-MM-AAAA] | Gerado por: Músculo (Claude Code)

---

## CONTEXTO
Cliente: [nome] | Stack: [tecnologias] | Camada: [1–5]
Objetivo desta iteração: [1 frase]
Valor: [R$X] | Contrapartida: [X% MRR ou outro]

---

## O QUE FOI CONSTRUÍDO
[Para cada módulo entregue:]
**[nome do módulo]** (commit [hash])
- [arquivo criado/modificado]
- [o que faz — 1–3 linhas]
- [decisão de arquitetura relevante tomada]

---

## DECISÕES DE ARQUITETURA
[Decisões que não são óbvias no código:]
1. [decisão] — razão: [por quê] — alternativa descartada: [e por quê]
2. [decisão] — razão: [por quê]

---

## PADRÕES EXTRAÍDOS
| Padrão | Origem | Status |
|---|---|---|
| [padrão] | [módulo onde emergiu] | Confirmado / Candidato |

---

## ESTADO ATUAL
Dias/sprints completos: [X/Y]
Commits: [hash1] [hash2]
Pendente: [o que não foi feito e por quê]

---

## DÍVIDAS TÉCNICAS
| ID | Descrição | Prioridade |
|---|---|---|
| DT-001 | [descrição] | P0/P1/P2 |
```

---

# TEMPLATE 6 — RELATÓRIO EVOLUTIVO
## Músculo → Eduardo | Formato do relatório de negócio ao fechar iteração

```
# RELATÓRIO EVOLUTIVO V[X] — [NOME DO PROJETO]
Iteração: V[X] | Data: [DD-MM-AAAA] | Gerado por: Músculo (Claude Code)

---

## ANÁLISE DE NEGÓCIO

### Pontos Fortes
- [o que funcionou bem — com impacto mensurável]

### Pontos de Atenção
- [o que pode ser problema — com contexto]

### Avaliação do Consultor
[Parágrafo com visão crítica — o que o Diretor precisa saber que pode não ter visto]

---

## [VISÃO LMM] — 5 IDEIAS DISRUPTIVAS PARA O GEMINI REAGIR

### IDEIA 1 — [TÍTULO EM MAIÚSCULAS]
**O que é:** [descrição clara do que seria construído ou feito]
**Impacto comercial:** [o que muda para o cliente ou para a Vanguard — com número se possível]
**Complexidade:** [Alta / Média / Baixa — e por quê]
**Para o Gemini reagir:** [pergunta direta que o Gemini deve responder]

### IDEIA 2 — [TÍTULO]
[mesma estrutura]

### IDEIA 3 — [TÍTULO]
[mesma estrutura]

### IDEIA 4 — [TÍTULO]
[mesma estrutura]

### IDEIA 5 — [TÍTULO]
[mesma estrutura]

---

## PARA O PRÓXIMO CICLO
O que o Gemini precisa decidir:
1. [decisão necessária]
2. [decisão necessária]

O que está em risco se não decidirmos:
- [consequência]
```

---

# TEMPLATE 7 — COMANDO_ESTRATEGISTA
## Músculo → Eduardo (para levar ao Gemini) | Como entregar o comando de fechamento

```
# COMANDO_ESTRATEGISTA V[X] — [NOME DO PROJETO]
Colar diretamente no Gemini Advanced após colar MEMORIA + relatorio_evolutivo
Data: [DD-MM-AAAA] | De: Músculo → Via Diretor → Para: Gemini

---

[colar aqui o COMANDO 1 preenchido com o estado atual,
as 5 ideias do Músculo e as decisões que o Gemini precisa tomar]

Ver TEMPLATE 1 (COMANDO 1) para o formato exato.
```

---

---

# TEMPLATE 8 — EMBAIXADOR
## Músculo → Eduardo (para acionar o Embaixador) | Formatos do 4º Membro Ativo

> O Embaixador (Claude Projects) é o único membro com memória persistente do cliente entre sessões.
> Tem 4 documentos de comunicação: MENSAGEM_INTERACAO_INICIAL, LOG_CLIENTE, [E-1 a E-5] e reação P-031.
> Script de acionamento: `.\scripts\ir_ao_embaixador.ps1 -cliente [NOME]`

---

## TEMPLATE 8A — MENSAGEM_INTERACAO_INICIAL
### Músculo → Eduardo (para colar no Claude Projects ao abrir projeto)

**Quando usar:** Passo 0 — ao criar o Claude Project de um cliente novo. Colar como primeira mensagem após configurar as instruções do sistema.

```
════════════════════════════════════════════════════════════
PENTALATERAL IAH — ATIVAÇÃO DO EMBAIXADOR
Cliente: [NOME DO CLIENTE] | Projeto: [NOME DO PROJETO]
Data de ativação: [DD-MM-AAAA] | Passo 0 do Protocolo Vanguard
════════════════════════════════════════════════════════════

Embaixador, você está sendo ativado como 4º membro do Pentalateral IAH
para o projeto [NOME DO PROJETO] com o cliente [NOME DO CLIENTE].

Contexto inicial que o Músculo fornece:

NICHO/SETOR: [resposta do Discovery]
DOR PRINCIPAL DO CLIENTE: [dor declarada no briefing]
PERFIL DO CLIENTE: [cargo, empresa, experiência com tecnologia]
PRIMEIRO CONTATO: [data e contexto]
CAMADA ESTIMADA: [1–5]
TICKET / MRR: [R$X]
PRAZO COMBINADO: [X dias/semanas]

Hipóteses iniciais para você confirmar ou refutar ao longo do projeto:
[H-1]: [hipótese sobre comportamento/expectativa do cliente]
[H-2]: [hipótese sobre risco de relacionamento]
[H-3]: [hipótese sobre como o cliente percebe valor]

Sua missão neste projeto:
1. Acumular inteligência sobre este cliente a cada interação
2. Gerar [E-1 a E-5] ao final de cada ciclo com base em comportamento real
3. Reagir com CONFIRMA/EXPANDE/ALERTA às ideias dos outros membros (P-031)
4. Alertar o Diretor sobre sinais de churn, scope creep ou insatisfação

Responda confirmando ativação e listando o que precisa para começar.
════════════════════════════════════════════════════════════
```

---

## TEMPLATE 8B — LOG_CLIENTE
### Embaixador → Eduardo | Relatório pós-interação com cliente (Passo 8.5)

**Quando usar:** Após toda reunião, ligação ou troca significativa com o cliente. Eduardo relata ao Embaixador → Embaixador gera este LOG.

```
════════════════════════════════════════════════════════════
LOG_CLIENTE — [NOME DO CLIENTE] — [DD-MM-AAAA]
Gerado por: Embaixador (Claude Projects)
Tipo de interação: [Reunião / Ligação / WhatsApp / E-mail]
════════════════════════════════════════════════════════════

RESUMO DA INTERAÇÃO
[2–3 parágrafos — o que aconteceu, em que contexto, quem disse o quê]

SINAIS DE ENGAJAMENTO
· [POSITIVO] [o que o cliente demonstrou de interesse, comprometimento, entusiasmo]
· [NEUTRO]   [o que ficou sem reação clara — zona de atenção]
· [NEGATIVO] [sinais de hesitação, objeção velada, distância ou silêncio relevante]

HIPÓTESES ATUALIZADAS
[H-1]: [confirmada / refutada / revisada — com evidência do que foi dito]
[H-2]: [confirmada / refutada / revisada]
[H-3]: [confirmada / refutada / revisada]

TEMPERATURA_PONDERADA DO CLIENTE
  Temperatura: [FRIA / MORNA / QUENTE / ENTUSIASMADA]
  Tendência (últimos 7 dias): [subindo / estável / caindo]
  Contexto de pagamento: [em dia / próximo vencimento / atrasado / N/A]
  Score 0-10: [N]  ← Score < 6 = CHURN-WATCH automático

ALERTAS PARA O CONSELHO
· [ALERTA P-023 se detectado — cliente menciona colega/lead]
· [ALERTA DE CHURN se detectado — sinal de distanciamento]
· [ALERTA DE SCOPE CREEP se detectado — cliente expandindo escopo sem aprovar custo]

INTELIGÊNCIA DE MERCADO (dimensão expandida — 2026-05-23)
· Padrão de nicho observado: [o que este cliente revela sobre outros clientes similares]
· Argumento de venda derivado: [o que Eduardo usa como prova social para o próximo cliente]
· Risco de nicho detectado: [o que pode impedir a escala]

PRÓXIMA AÇÃO DO EMBAIXADOR
[O que monitorar / perguntar / preparar para a próxima interação]

PRÓXIMA AÇÃO DO DIRETOR (sugerida)
[O que Eduardo deve fazer ou dizer antes da próxima interação com este cliente]
════════════════════════════════════════════════════════════
```

---

## TEMPLATE 8C — [E-1 a E-5] DO EMBAIXADOR
### Embaixador → Eduardo (para levar ao Gemini e ao NotebookLM) | 5 ideias baseadas em comportamento real do cliente

**Quando usar:** Ao fechar cada ciclo do loop. O Embaixador gera estas 5 ideias que alimentam o próximo ciclo junto com as [M-1 a M-5] do Músculo. Formam os 10 inputs de campo do Pentalateral.

```
════════════════════════════════════════════════════════════
[E-1 a E-5] — IDEIAS DO EMBAIXADOR — [NOME DO CLIENTE] — V[X]
Gerado por: Embaixador (Claude Projects)
Base: comportamento real observado em [N] interações com o cliente
════════════════════════════════════════════════════════════

E-1 — [TÍTULO EM MAIÚSCULAS]
O que observei: [comportamento concreto do cliente que origina esta ideia]
A ideia: [o que fazer a partir disso]
Por que agora: [por que esta janela de oportunidade existe hoje]
Pergunta para o Gemini reagir: [?]

E-2 — [TÍTULO]
[mesma estrutura]

E-3 — [TÍTULO]
[mesma estrutura]

E-4 — [TÍTULO]
[mesma estrutura]

E-5 — [TÍTULO]
[mesma estrutura]

Nota: estas ideias têm peso de evidência de campo. O Gemini e o NotebookLM devem
reagir com CONFIRMA / EXPANDE / ALERTA — não ignorar.
════════════════════════════════════════════════════════════
```

---

## TEMPLATE 8D — REAÇÃO P-031 (CONFIRMA / EXPANDE / ALERTA)
### Embaixador → Eduardo | Como reagir às ideias dos outros membros com filtro de realidade do cliente

**Quando usar:** Após receber as ideias do Músculo [M-1 a M-5], do Gemini ou do Auditor. O Embaixador filtra cada uma com base no comportamento real do cliente observado.

```
════════════════════════════════════════════════════════════
FILTRO DE REALIDADE P-031 — [NOME DO CLIENTE] — V[X]
Embaixador reagindo às ideias do [MÚSCULO / GEMINI / AUDITOR]
════════════════════════════════════════════════════════════

[Ideia 1 — título]:
CONFIRMA — Esta ideia alinha com o que observei: [evidência de comportamento]
[OU]
EXPANDE — O cliente vai além disso: [o que o comportamento real sugere como extensão]
[OU]
ALERTA — Risco real: [o cliente demonstrou comportamento que contradiz esta ideia]
Evidência: [o que foi dito ou feito que gera este alerta]
Recomendação: [como ajustar a ideia para o cliente real]

[Ideia 2 — título]:
[mesma estrutura]

[continuar para todas as ideias recebidas]

SÍNTESE DO EMBAIXADOR:
[1 parágrafo — o que o conjunto das reações revela sobre o estado atual do cliente
 e o que o Conselho deve priorizar nas próximas ações]
════════════════════════════════════════════════════════════
```

---

## TABELA GERAL DE TEMPLATES — PENTALATERAL IAH

| Template | De → Para | Quando usar |
|---|---|---|
| **COMANDO 1** | Eduardo → Gemini | Iniciar projeto novo ou nova iteração |
| **DIRETRIZ** | Gemini → Eduardo | Resposta do Gemini — sempre 5 blocos + 5 ideias |
| **COMANDO 2** | Eduardo → NotebookLM | Após receber DIRETRIZ do Gemini |
| **SKILL** | NotebookLM → Eduardo | Resposta do NotebookLM — sempre com [SÓCIO CONSULTOR] + 5 ideias |
| **MEMORIA** | Músculo → Eduardo | Ao fechar iteração — contexto técnico completo |
| **RELATORIO** | Músculo → Eduardo | Ao fechar iteração — análise de negócio + 5 ideias |
| **COMANDO_ESTRATEGISTA** | Músculo → Eduardo (→ Gemini) | Fecha o loop — aciona o próximo ciclo |
| **MENSAGEM_INTERACAO_INICIAL** | Músculo → Eduardo (→ Embaixador) | Passo 0 — ativar Embaixador no início de projeto |
| **LOG_CLIENTE** | Embaixador → Eduardo | Passo 8.5 — após toda interação significativa com cliente |
| **[E-1 a E-5]** | Embaixador → Eduardo (→ Gemini/NotebookLM) | Ao fechar ciclo — 5 ideias de campo para o próximo loop |
| **FILTRO P-031** | Embaixador → Eduardo | Reação CONFIRMA/EXPANDE/ALERTA às ideias dos outros membros |

---

## REGRAS GERAIS DE COMUNICAÇÃO

```
1. Nenhum membro improvisa formato — usar sempre o template do seu papel
2. Nenhum membro ignora o output do anterior — reagir explicitamente
3. O Diretor não interpreta — os documentos dizem exatamente o que fazer
4. Quando um membro sair do formato: citar o template e pedir para refazer
5. Cada documento tem "Para [MEMBRO]" no corpo — o destinatário lê e age
6. Dúvida sobre o formato? Consultar este documento antes de improvisar
7. O Embaixador reage SEMPRE com CONFIRMA/EXPANDE/ALERTA — nunca com aprovação genérica
8. As ideias [E-1 a E-5] têm peso de evidência de campo — não são especulação
9. MEMORIA_EMBAIXADOR é atualizada pelo Músculo automaticamente após toda deliberação (P-032)
```

---

## ATUALIZAÇÃO DESTE TEMPLATE

Quando o processo evoluir e revelar um formato melhor:
1. Atualizar o template correspondente aqui
2. Commitar: `docs(templates): [qual template] — [o que mudou e por quê]`
3. Sincronizar para NOTEBOOKLM_FONTES do projeto ativo
4. O Músculo notifica o Diretor: "Template [X] atualizado — novo padrão: [descrição]"

---

# TEMPLATE 9 — PROTOCOLO DE ENCERRAMENTO / PAINEL DE ATIVIDADES
## Músculo → Embaixador | Gerado ao fechar toda sessão

> **Quando usar:** Ao encerrar qualquer sessão de trabalho (obrigatório — P-022 CLAUDE.md).
> **Quem gera:** `scripts/generate_protocolo_encerramento.ps1` (integrado ao `session_close.ps1`)
> **Onde fica:** `PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_[DATA].md`
> **O que Eduardo faz:** Faz upload do arquivo ao Embaixador (Claude Projects) — sem cópia manual.
> **O que o Embaixador faz:** Cria/atualiza o artefato PAINEL_ATIVIDADES com semáforo visual.
> **Regra do Diretor:** "Eu não vou copiar. Quero o documento pronto." (2026-05-24)

### Estrutura do PAINEL_ATIVIDADES

```
════════════════════════════════════════════════════════════════
PAINEL DE ATIVIDADES — [DATA] — PENTALATERAL IAH
Sessão: [CONTEXTO DA SESSÃO]
Gerado por: Músculo · Upload: Eduardo → Embaixador
════════════════════════════════════════════════════════════════

## SEMÁFORO DE PROJETOS

| Projeto | Status | Gate Atual | Próxima Ação |
|---|---|---|---|
| PROJ-001 Valdece | 🟢 / 🟡 / 🔴 | [gate] | [ação do Diretor] |
| PROJ-002 Ingrid | 🟢 / 🟡 / 🔴 | [gate] | [ação do Diretor] |

Legenda: 🟢 No prazo · 🟡 Atenção · 🔴 Bloqueado

---

## ENTREGAS DA SESSÃO

| Item | Status | Artefato |
|---|---|---|
| [o que foi construído] | ✅ / ⏳ / ❌ | [arquivo ou link] |

---

## ALERTAS EMITIDOS

[Lista de alertas relevantes emitidos pelo Músculo nesta sessão]
- ALERTA [TIPO]: [descrição] → [ação necessária]

---

## GATES PENDENTES — AÇÃO DO DIRETOR

[Itens que requerem deliberação ou ação física do Eduardo antes da próxima sessão]

| Gate | Projeto | O que Eduardo faz | Prazo |
|---|---|---|---|
| [gate] | [projeto] | [ação concreta] | [data] |

---

## PRÓXIMOS DIAS — PREVISÃO

| Data | Projeto | O que acontece | Responsável |
|---|---|---|---|
| [DD-MM-YYYY dia] | [projeto] | [ação] | Músculo / Eduardo |

---

## ANÁLISE GERENCIAL

**Ponto forte desta sessão:** [o que funcionou bem]
**Ponto de atenção:** [risco ou deriva detectada]
**Pergunta central para o próximo ciclo:** [o que precisa ser respondido]

---

*PAINEL gerado por Músculo · [DATA] · Pentalateral IAH*
*Upload ao Embaixador: arrastar PAINEL_ATIVIDADES_[DATA].md para Claude Projects [CLIENTE]*
```

### Fluxo completo de encerramento

```
1. Músculo executa session_close.ps1
2. session_close.ps1 chama generate_protocolo_encerramento.ps1
3. PAINEL_ATIVIDADES_[DATA].md gerado em PROTOCOLOS_ENCERRAMENTO/
4. Eduardo faz upload do arquivo ao Embaixador (Claude Projects)
5. Embaixador processa e atualiza o painel visual
6. Eduardo gerencia atividades a partir do painel — zero cópia manual
```

> **Gatilho de geração:** toda sessão com commits ou decisões relevantes.
> **Destino:** Embaixador do projeto ativo (ou Embaixador Universal se múltiplos projetos).
> **P-060:** Músculo gera e reporta — Eduardo só faz o upload.

---

*Templates do Pentalateral IAH — 5 atores: Músculo + Estrategista + Auditor + Embaixador + Diretor*
*25 ideias/ciclo [M×2+G+N+E × 5]: [M×2 técnico+cirúrgico] + [E] + [G] + [N] × 5 cada*
*Versão 2.1 · 2026-05-26 — Template 9 adicionado: PROTOCOLO DE ENCERRAMENTO / PAINEL DE ATIVIDADES*
