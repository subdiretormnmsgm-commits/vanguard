# TEMPLATES DE COMUNICAÇÃO — QUADRILATERAL IAH
**Protocolo padronizado de input e output entre todos os membros**
**Organismo vivo — atualizar quando o processo evoluir**
**Versão:** 1.0 | Data: 2026-05-13

> Nenhum membro improvisa o formato. Cada documento tem estrutura fixa.
> Quando o formato muda, o loop quebra. Quando o formato é respeitado, o sistema aprende.

---

## VISÃO GERAL DO FLUXO DE DOCUMENTOS

```
DIRETOR
  │
  ├──[COMANDO 1]──► GEMINI ──[DIRETRIZ]──► DIRETOR
  │                                              │
  ├──[COMANDO 2 + fontes]──► NOTEBOOKLM ──[SKILL]──► DIRETOR
  │                                                        │
  └──[PROTOCOLO VANGUARD + Skill + Diretriz]──► MÚSCULO
                                                     │
                                    ┌────────────────┤
                                    │                │
                               [MEMORIA]      [RELATORIO]
                               [COMANDO_ESTRATEGISTA]
                                    │
                                    └──► DIRETOR ──► (volta ao GEMINI)
```

---

# TEMPLATE 1 — COMANDO 1
## Eduardo → Gemini | Como pedir a DIRETRIZ

**Quando usar:** Ao iniciar projeto novo ou nova iteração após receber MEMORIA + relatorio do Músculo.

**O que colar antes do comando:** MEMORIA_V[X] + relatorio_evolutivo_V[X] (nessa ordem, no mesmo chat).

```
════════════════════════════════════════════════════════════
QUADRILATERAL IAH — EDUARDO → GEMINI
projeto: [NOME DO PROJETO] | ITERAÇÃO: V[X] | DATA: [DD-MM-AAAA]
════════════════════════════════════════════════════════════

Gemini, somos o Quadrilateral IAH.
Tu és o Estrategista. Eu sou o Diretor.
O NotebookLM é o Auditor. O Claude Code é o Músculo.

[SE PROJETO NOVO — preencher com dados do Discovery:]
NICHO/SETOR: [resposta]
PROBLEMA PRINCIPAL: [resposta]
VOLUME/ESCALA: [resposta]
RECEITA / TICKET MÉDIO: [resposta]
ESTADO ATUAL: [resposta]
URGÊNCIA: [resposta]
ORÇAMENTO / RECURSOS: [resposta]
CAMADA ESTIMADA: [1–5]

[SE ITERAÇÃO SEGUINTE — preencher com reação às ideias do Músculo:]
O Músculo propôs para esta iteração:
1. [ideia 1 do Músculo]
2. [ideia 2 do Músculo]
3. [ideia 3 do Músculo]
4. [ideia 4 do Músculo]
5. [ideia 5 do Músculo]
Analisa cada uma. Aprova, transforma ou descarta — com razão.

ESTADO ATUAL DO PROJETO:
Camada: [X] | Valor/MRR: [R$X] | Próximo objetivo: [1 frase]

RESPONDE OBRIGATORIAMENTE COM OS 5 BLOCOS:
BLOCO 0 — DIAGNÓSTICO
BLOCO 1 — PRIORIDADES
BLOCO 2 — PROPOSTA COMERCIAL
BLOCO 3 — DIRETRIZ TÉCNICA (com [PARA O NOTEBOOKLM] e [PARA O MÚSCULO])
BLOCO 4 — PRÓXIMOS PASSOS DO DIRETOR

+ 5 IDEIAS DISRUPTIVAS para o Músculo reagir.
+ [RESPOSTA ÀS IDEIAS DO MÚSCULO] no Bloco 3 se for iteração seguinte.
════════════════════════════════════════════════════════════
```

---

# TEMPLATE 2 — DIRETRIZ
## Gemini → Eduardo | Como o Gemini deve responder SEMPRE

**Regra:** Este é o único formato aceito. Se o Gemini responder fora deste formato, o Diretor pede para refazer.

```
════════════════════════════════════════════════════════════
DIRETRIZ ESTRATÉGICA — [NOME DO PROJETO] — V[X]
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

[RESPOSTA ÀS IDEIAS DO MÚSCULO] — obrigatório em iteração seguinte
Ideia 1 — [título]: [APROVADA / MODIFICADA: nova versão / DESCARTADA: razão]
Ideia 2 — [título]: [APROVADA / MODIFICADA: nova versão / DESCARTADA: razão]
Ideia 3 — [título]: [APROVADA / MODIFICADA: nova versão / DESCARTADA: razão]
Ideia 4 — [título]: [APROVADA / MODIFICADA: nova versão / DESCARTADA: razão]
Ideia 5 — [título]: [APROVADA / MODIFICADA: nova versão / DESCARTADA: razão]

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
  ✓ 02_MEMORANDO_QUADRILATERAL_UNIVERSAL.txt
  ✓ 04_INTELLIGENCE_LEDGER.txt
  ✓ 11_BRIEFING_DISCOVERY_[CLIENTE].txt
  ✓ 12_DIRETRIZ_GEMINI_V[X].txt  ← recém gerada

Complementares (adicionar quando disponíveis):
  + MEMORIA das últimas 2–3 iterações
  + relatorios_evolutivos das últimas 2–3 iterações
  + Skill anterior do cliente (se existir)
  + 13_PROCESSO_EVOLUTIVO_QUADRILATERAL.txt
```

**Mensagem a colar após carregar as fontes:**
```
════════════════════════════════════════════════════════════
QUADRILATERAL IAH — EDUARDO → NOTEBOOKLM
projeto: [NOME] | ITERAÇÃO: V[X] | DATA: [DD-MM-AAAA]
════════════════════════════════════════════════════════════

NotebookLM, você atua como Sócio Consultor do Quadrilateral IAH.
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

## REGRAS GERAIS DE COMUNICAÇÃO

```
1. Nenhum membro improvisa formato — usar sempre o template do seu papel
2. Nenhum membro ignora o output do anterior — reagir explicitamente
3. O Diretor não interpreta — os documentos dizem exatamente o que fazer
4. Quando um membro sair do formato: citar o template e pedir para refazer
5. Cada documento tem "Para [MEMBRO]" no corpo — o destinatário lê e age
6. Dúvida sobre o formato? Consultar este documento antes de improvisar
```

---

## ATUALIZAÇÃO DESTE TEMPLATE

Quando o processo evoluir e revelar um formato melhor:
1. Atualizar o template correspondente aqui
2. Commitar: `docs(templates): [qual template] — [o que mudou e por quê]`
3. Sincronizar para NOTEBOOKLM_FONTES do projeto ativo
4. O Músculo notifica o Diretor: "Template [X] atualizado — novo padrão: [descrição]"
