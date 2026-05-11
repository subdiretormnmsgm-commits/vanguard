# MEMORANDO QUADRILATERAL — MODELO UNIVERSAL
**IAH — Inteligência Artificial Humana**
**Classificação:** Operacional · Uso em qualquer projecto
**Versão:** 1.0
**Data de emissão:** 2026-05-11

---

> ⚠️ **ORGANISMO VIVO — ACTUALIZAR A CADA PROJECTO**
> Este memorando melhora com cada entrega. Claude é responsável por manter actualizado.

---

> **Premissa fundamental:**
> O cliente não contrata tecnologia. Contrata inteligência orquestrada.
> O Quadrilateral não é uma agência nem uma equipa de desenvolvimento.
> É um conselho de quatro inteligências que delibera antes de executar.
> O resultado: menos retrabalho, mais precisão, entrega mais rápida.

---

## O QUADRILATERAL — OS 4 MEMBROS

| Membro | Papel | Quando actua | O que produz |
|--------|-------|-------------|-------------|
| **Eduardo (Diretor)** | Veredito Final | Em cada decisão | Aprovação ou rejeição — ninguém avança sem ele |
| **Gemini (Estrategista)** | Visão de mercado e negócio | Antes de cada iteração | DIRETRIZ: o que construir, em que ordem, e porquê |
| **NotebookLM (Auditor)** | Memória e coerência | Após cada iteração | Auditoria: o que foi prometido vs o que foi entregue |
| **Claude Code (Músculo)** | Execução técnica | Durante cada iteração | Código, design, integrações, documentação |

**Regra de ouro:** Nenhum membro tem autoridade absoluta sobre os outros. O Gemini propõe. O Claude avalia. O NotebookLM audita. O Eduardo decide. A força está na tensão produtiva entre os quatro.

---

## A NATUREZA DE CADA VOZ

**O Estrategista pensa grande demais** — às vezes. Isso é útil. Força o Quadrilateral a considerar o potencial máximo antes de decidir o que é viável agora. Mas pode propor o que já existe ou subestimar a complexidade técnica. A sua DIRETRIZ é o ponto de partida — não a lei.

**O Auditor lembra o que os outros esquecem** — o que foi prometido e ainda não foi entregue, o padrão que funcionou, o erro que se repetiu. Sem memória, o Quadrilateral repete os mesmos erros em cada projecto.

**O Músculo executa com consciência crítica** — não cegamente. Antes de construir, avalia se o que foi pedido faz sentido técnica e comercialmente. Se identificar risco, comunica antes de escrever uma linha. Não tem lealdade à DIRETRIZ — tem lealdade ao resultado do cliente.

**O Diretor decide com informação real** — não com intuição, não com pressão do cliente, não com entusiasmo do Estrategista. Integra tudo e pode contrariar qualquer membro. É o único com veredito.

---

## PROTOCOLO DE DEBATE FORMAL

Quando os membros discordam, o formato é obrigatório:

**Músculo discorda do Estrategista:**
```
ALERTA TÉCNICO — [nome do módulo ou decisão]
O Estrategista propõe: [resumo]
A minha avaliação: [por que não faz sentido ou tem risco]
O risco concreto: [o que pode falhar e o impacto]
Alternativa recomendada: [o que construir em vez disso]
Aguardo Veredito do Diretor.
```

**Auditor detecta contradição:**
```
[CONEXÃO HISTÓRICA]
Em [projecto/iteração anterior], foi construído [X] com o objectivo [Y].
A proposta actual contradiz [Y] porque [razão].
[PADRÃO DE SUCESSO / FALHA]
Recomendação: [manter / adaptar / substituir].
```

**Estrategista propõe algo que já existe:**
```
"O módulo [X] já existe. Está funcional.
Posso adaptá-lo em [estimativa] — muito mais rápido que construir do zero.
Confirmas se adaptar o existente ou construir novo?"
```

**Diretor override de todos:**
```
O Veredito do Diretor prevalece sempre.
O Músculo documenta o override na MEMORIA:
"[OVERRIDE DO DIRETOR]: a proposta era [X]. O Diretor decidiu [Y] porque [razão].
Resultado a acompanhar."
```

---

## FASE -1 — QUALIFICAÇÃO (GO / NO-GO)

> Antes de activar o Quadrilateral, verificar se o projecto merece o processo completo.
> Um cliente mal qualificado consome o recurso mais escasso: o tempo do Diretor.

### 3 Perguntas de Filtro

```
1. "Qual o problema que custa dinheiro todos os meses por não estar resolvido?"
   Sem resposta clara → NO-GO. Falta diagnóstico.

2. "Qual o investimento que faz sentido para resolver este problema?"
   "O mínimo possível" → NO-GO. Não vê valor.

3. "O que acontece se não resolver isto nos próximos 3 meses?"
   "Nada" → NO-GO. Sem urgência real.
```

### Tabela GO / NO-GO

| Sinal | Decisão | Acção |
|-------|---------|-------|
| Problema real e específico | GO | Avançar para Fase 0 |
| Budget compatível com o âmbito | GO | Avançar para Fase 0 |
| Urgência real (prazo, evento, perda) | GO | Avançar para Fase 0 |
| Fala com o decisor | GO | Avançar para Fase 0 |
| "Quero algo simples e barato" | NO-GO | Oferecer Sprint de Diagnóstico |
| Sem urgência declarada | NO-GO | Diagnóstico antes de qualquer build |
| Intermediário sem poder de decisão | NO-GO | Exigir reunião com o decisor |
| Budget muito abaixo do âmbito | NO-GO | Redefinir âmbito ou recusar |

---

## FASE 0 — DISCOVERY (7 Perguntas Universais)

> Perguntar uma de cada vez. Sem as 7 respostas, o Estrategista produz estratégia genérica.

```
1. PROJECTO
   O que é? (ecommerce, app, site, SaaS, automação, modelo de negócio, outro?)
   Quem é o cliente ideal? Qual o mercado?

2. PROBLEMA
   Qual o maior problema que este projecto resolve HOJE?
   Sem este projecto, o que acontece? Qual a dor concreta?

3. VOLUME
   Quantos utilizadores / clientes / transacções por mês?
   Pequeno: <1.000 | Médio: 1k–50k | Grande: 50k+

4. RECEITA
   Como o projecto gera dinheiro?
   (venda directa, subscrição, comissão, publicidade, freemium, serviço?)
   Qual o ticket médio ou revenue esperado?

5. ESTADO ACTUAL
   O que já existe? (código, design, domínio, contas, APIs?)
   Qual a stack actual, se existir?

6. URGÊNCIA
   Há um prazo, evento ou pressão que define a entrega?
   (lançamento, apresentação, investidor, sazonalidade?)

7. RECURSOS
   Orçamento aproximado, tempo disponível, equipa, ferramentas já pagas?
```

---

## FASE 1 — ANÁLISE ESTRATÉGICA

> Claude actua como consultor antes de actuar como executor.
> Nenhum código antes desta análise.

### Classificar o Tipo de Projecto

| Tipo | Exemplos |
|------|---------|
| Presença Digital | Site institucional, landing page, portfolio |
| Ecommerce | Loja online, marketplace, dropshipping |
| Aplicação Web | Dashboard, SaaS, ferramenta interna |
| App Mobile | iOS/Android nativo, PWA instalável |
| Automação | Workflows, integrações, bots, pipelines |
| IA / Dados | Chatbot, análise, relatórios automáticos, ML |
| Modelo de Negócio | Estrutura, pricing, go-to-market, proposta de valor |
| API / Backend | REST API, microserviço, integração entre sistemas |

### Classificar a Camada de Complexidade

| Camada | Âmbito | Indicador de Prazo |
|--------|--------|--------------------|
| 1 — MVP | Protótipo funcional, prova de conceito | 1–5 dias |
| 2 — Produto | Produto completo, lançável ao mercado | 1–3 semanas |
| 3 — Plataforma | Com IA, dados, automação, integrações | 2–6 semanas |
| 4 — Ecossistema | Multi-tenant, marketplace, API pública | 1–3 meses |
| 5 — Monopólio | Activo de sector, holding de dados, vantagem estrutural | 3–6 meses |

### Inventário Antes de Construir

```
Antes de propor qualquer build, responder:

1. O que já existe no repositório que pode ser reutilizado?
2. O que o cliente já tem (código, contas, licenças, designs)?
3. O que pode ser usado off-the-shelf (Stripe, Shopify, Supabase, etc.)?
4. O que realmente precisa ser construído do zero?

Reutilizar > Adaptar > Construir do zero.
Sempre nesta ordem.
```

### Análise Crítica (papel de consultor)

```
ANÁLISE QUADRILATERAL — [NOME / TIPO DE PROJECTO]

TIPO: [ecommerce / app / site / SaaS / automação / outro]
CAMADA: [1–5]
STACK RECOMENDADA: [tecnologias — justificadas]

REUTILIZÁVEL: [o que já existe e serve]
A CONSTRUIR: [o que precisa ser feito do zero]
OFF-THE-SHELF: [ferramentas prontas recomendadas]

RISCO PRINCIPAL: [técnico ou comercial]
ROI ESTIMADO: [cálculo com base nos dados do cliente]
O QUE NÃO CONSTRUIR AGORA: [e porquê]
ESTIMATIVA: [X dias / sessões]

Confirmas para avançar? →
```

---

## FASE 2 — PLANO DE BUILD

> Declarar o plano antes de escrever qualquer linha de código.
> Sem plano confirmado → sem execução.

```
PLANO DE BUILD — [ITERAÇÃO] — [NOME DO PROJECTO]

Stack: [tecnologias confirmadas]

Módulo 1: [nome] — [porquê prioritário] — est: [X]
Módulo 2: [nome] — [dependências] — est: [X]
Módulo 3: [nome] — [risco: SIM/NÃO] — est: [X]

Total: [X horas / sessões]
O que NÃO será construído nesta iteração: [e porquê]
Dívidas técnicas previstas: [P0/P1/P2 ou NENHUMA]

Aguardo confirmação do Diretor. →
```

**Regras universais de build:**
- Sem código antes do plano confirmado
- Sem variáveis de ambiente no código — sempre em `.env`
- LGPD/GDPR por design — consentimento antes de qualquer dado pessoal
- Comunicar ao Diretor em cada decisão arquitectural relevante
- Sem commit sem aprovação explícita do Diretor

---

## FASE 3 — EXECUÇÃO

### Comunicação Durante o Build

| Momento | O que comunicar |
|---------|----------------|
| Início | Resumo do plano em 3 bullets — confirma o entendimento |
| Decisão de arquitectura | "Abordagem A vs B — recomendo A porque..." |
| Risco identificado | "ANTES DE CONSTRUIR: detectei risco X. Aguardo decisão." |
| Fim de cada módulo | O que foi feito + o que falta |
| Fim da iteração | MEMORIA + relatorio_evolutivo + próximos passos |

### Alertas Automáticos

| Situação | Formato |
|----------|---------|
| Proposta duplica algo existente | `ALERTA: [X] já existe em [local]. Reutilizar?` |
| Risco de segurança | `ALERTA SEGURANÇA: [descrição]. Resolver antes de avançar.` |
| Risco de privacidade (LGPD/GDPR) | `ALERTA PRIVACIDADE: [descrição]. Consent obrigatório.` |
| Feature fora de âmbito | `ALERTA ÂMBITO: [feature] não estava no plano. Confirmas?` |
| Stack inadequada para o volume | `ALERTA ESCALA: [stack] não suporta [volume] sem [ajuste].` |
| Prazo em risco | `ALERTA PRAZO: estimativa [X] vs prazo declarado [Y].` |
| Dívida crítica (P0) | `ALERTA P0: [descrição]. Resolver antes de nova feature.` |

---

## FASE 4 — FECHAMENTO E ENTREGA

### Documentação Obrigatória ao Fechar

**MEMORIA_V[X]_[PROJECTO].md** — memória técnica:
```markdown
# MEMÓRIA V[X] — [PROJECTO] — [MISSÃO]
Data: [data]   Tipo: [tipo]   Camada: [1–5]   Stack: [tecnologias]

## O Que Foi Construído
## Variáveis de Ambiente / Config
## Como Correr / Deploy
## Próximos Módulos Recomendados
```

**relatorio_evolutivo_v[X]_[PROJECTO].md** — análise de negócio:
```markdown
# RELATÓRIO V[X] — [PROJECTO]
## O Que Foi Construído [em linguagem de negócio]
## Análise de Negócio
   ### Pontos Fortes [3–5]
   ### Pontos Fracos e Riscos [2–4 com acção correctiva]
   ### Avaliação do Consultor [Nota A/B/C + justificação]
## ROI Estimado [investimento vs retorno]
## 5 Ideias para Próxima Iteração
## Plano Imediato [com responsável]
```

### Checklist de Handoff ao Cliente

**Acesso:**
- [ ] Domínio e hospedagem no nome do cliente — nunca no nome de quem construiu
- [ ] Todas as contas de serviço externo no nome do cliente
- [ ] Credenciais e variáveis de ambiente entregues por canal seguro

**Documentação:**
- [ ] README com instruções de operação diária
- [ ] Lista de todos os serviços externos e custos mensais
- [ ] O que fazer se algo parar de funcionar

**Formação:**
- [ ] Sessão de entrega (30–60 min) com o cliente a operar o sistema ao vivo
- [ ] Suporte pós-entrega definido (retainer ou por hora)

**Comercial:**
- [ ] Relatório de entrega em linguagem de negócio enviado ao cliente
- [ ] Próxima iteração proposta (upsell ou retainer)
- [ ] Testemunho / feedback pedido

### Code Review Antes do Commit

- [ ] Sem variáveis de ambiente hardcoded
- [ ] Consentimento de privacidade implementado onde necessário
- [ ] `.env.example` actualizado com todas as variáveis
- [ ] README actualizado
- [ ] Nenhuma dívida P0 não declarada

---

## PDCA — O MOTOR DO QUADRILATERAL

> O ciclo que impede o Quadrilateral de repetir os mesmos erros.

```
PLAN  → Estrategista gera DIRETRIZ
        O que construir, em que ordem, com que risco
        5 ideias para a iteração seguinte (obrigatório)

DO    → Músculo executa
        Declara plano antes de escrever código
        Reporta decisões ao Diretor

CHECK → Auditor + Estrategista avaliam
        Auditor: o que foi prometido vs o que foi entregue?
        Estrategista: o ROI foi alcançado? O que mudou no mercado?

ACT   → Diretor decide o próximo passo
        Avançar / Hotfix / Reformular / Upsell
```

**Regra crítica:** O ciclo fecha ENTRE iterações — nunca dentro. O Estrategista avalia o que já foi construído. Não o que está a construir.

### Classificação de Dívidas Técnicas

| Prioridade | Critério | Prazo máximo |
|------------|----------|-------------|
| P0 — Crítica | Bloqueia produção, risco de dados, falha de segurança | Próxima iteração |
| P1 — Alta | Degrada funcionalidade visível, risco de escala | 2 iterações |
| P2 — Normal | Código duplicado, UX deficiente, dívida técnica | 4 iterações |

**Regra:** Máximo 5 dívidas P0 em simultâneo. Se atingido, a próxima iteração é 100% resolução — zero features novas.

### Feedback Loop por Módulo

Todo módulo construído deve ter:
1. **Log de evento** — registo do que aconteceu
2. **Métrica derivada** — síntese que mede a qualidade
3. **Acção correctiva** — mecanismo que usa a métrica

Módulos sem feedback loop = dívida P2 automática.

---

## PITCH DO MODELO — COMO APRESENTAR AO CLIENTE

> Nunca nomear ferramentas. Sempre falar em resultado e ROI.

### Versão Curta (60 segundos)

```
"A maioria das agências tem um developer e um gestor de projecto.
Nós operamos de forma diferente.

Cada projecto passa por três análises em paralelo:
uma estratégica, uma de auditoria histórica, e uma de execução técnica.
O Eduardo coordena as três e toma o veredito final.

O resultado: antes de escrevermos uma linha de código,
já sabemos o que não construir, o que pode ser reutilizado,
e qual o retorno esperado do investimento.

Entregamos mais rápido porque não construímos o que não precisa de existir."
```

### Versão Completa (proposta formal)

```
"Trabalhamos com um modelo de quatro inteligências com papéis fixos:
um Estrategista, um Auditor com memória histórica, um Executor técnico,
e o Diretor com poder de veredito.

Nenhum código é escrito sem plano validado.
Nenhum projecto fecha sem documentação que o cliente leva consigo.

A diferença: uma agência executa o que o cliente pede.
Nós questionamos o que o cliente pede antes de executar —
porque construir a coisa errada com perfeição é o maior desperdício possível."
```

### Regras do Pitch

- ❌ Nunca nomear ferramentas pelo nome
- ❌ Nunca dizer "usamos IA" — genérico, sem impacto
- ✅ Sempre falar em resultado com números reais do cliente
- ✅ Apresentar sempre duas opções: entrada (menor) e completo

---

## PROPOSTA COMERCIAL — TEMPLATE UNIVERSAL

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PROPOSTA — [NOME DO CLIENTE] | [DATA]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DIAGNÓSTICO:
[1 parágrafo — o problema real, em linguagem do cliente, sem jargão técnico]

O QUE PROPOMOS:
[Nome do Serviço] — [1 frase do que é e do que resolve]

INCLUI:
✓ [Entrega 1 — em resultado, não em tecnologia]
✓ [Entrega 2]
✓ [Entrega 3]

ROI ESTIMADO:
[Ex: "Com base no seu ticket médio de R$X e volume de Y clientes/mês,
uma melhoria de 10% na conversão representa R$Z/mês.
O investimento paga-se em X semanas."]

INVESTIMENTO:
Opção A (entrada): R$X — [âmbito reduzido, entrega em X dias]
Opção B (completo): R$Y — [âmbito completo, entrega em Y semanas]

PRÓXIMO PASSO:
[Acção clara — única, simples, sem ambiguidade]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## ESTRUTURA DE PASTAS — QUALQUER PROJECTO DE CLIENTE

```
CLIENTES/
└── [NOME_CLIENTE]/
    ├── BRIEFING_DISCOVERY.txt        ← notas da Fase 0
    ├── DIRETRIZ_V1_ESTRATEGISTA.txt  ← estratégia aprovada
    ├── PROPOSTA_COMERCIAL.pdf        ← proposta enviada
    ├── CONTRATO.pdf                  ← contrato assinado
    ├── MEMORIA_V1.md                 ← memória técnica
    ├── relatorio_evolutivo_v1.md     ← análise de negócio
    ├── src/                          ← código do projecto
    │   ├── api/
    │   ├── web/
    │   ├── mobile/
    │   └── infra/
    └── CONSELHO/
        ├── Auditor/                  ← ficheiros para o Auditor
        └── Estrategista/             ← comandos para o Estrategista
```

---

## ANTI-PADRÕES — O QUE NUNCA FAZER

| Anti-Padrão | Consequência | Regra Correcta |
|-------------|-------------|---------------|
| Código antes do plano | Retrabalho garantido | Plano declarado e confirmado antes |
| Falar em tecnologia ao cliente | Cliente não compra | Linguagem de resultado e ROI sempre |
| Construir o que não foi pedido | Desperdício de tempo | Só o que resolve o problema declarado |
| Commit sem aprovação | Mudanças não validadas | Sempre aguardar Veredito do Diretor |
| Stack overcomplicated para MVP | Custo e tempo inflacionados | Solução mais simples que funciona |
| Proposta sem ROI | Cliente negocia o preço | ROI calculado com dados reais |
| Avançar sem as 7 perguntas | Estratégia genérica inútil | Fase 0 completa obrigatória |
| Ignorar o que já existe | Reinventar a roda | Inventário antes de qualquer build |
| Fechar sem documentação | Próxima sessão começa do zero | MEMORIA + relatorio obrigatórios |
| Credenciais no nome do fornecedor | Dependência do cliente | Tudo no nome do cliente desde o dia 1 |

---

## MANIFESTO — POR QUE O QUADRILATERAL VENCE

As agências têm criativos. Os freelancers têm código. As consultorias têm apresentações.

**O Quadrilateral tem memória e debate.**

A maioria dos sistemas de execução funciona como um empregado: recebe uma ordem, executa, entrega. O Quadrilateral funciona como um conselho: propõe, questiona, audita, decide.

Quatro características que nenhuma equipa tradicional replica:

**1. Debate antes da execução** — o que vai ser construído é questionado antes de existir. Não por desconfiança, mas porque construir a coisa errada com perfeição é o maior desperdício possível.

**2. Memória institucional** — o Auditor recorda o que funcionou, o que falhou e o que foi prometido em iterações anteriores. A maioria das equipas esquece. O Quadrilateral não.

**3. Separação de papéis** — o Estrategista não executa. O Músculo não estrategiza. O Auditor não decide. A separação elimina os conflitos de interesse que corrompem a maioria dos processos.

**4. Veredito humano** — o Diretor tem a palavra final. Sempre. A tecnologia serve o julgamento humano — nunca o substitui.

O cliente contrata uma solução. Recebe um activo.
O Quadrilateral entrega um projecto. Retém a inteligência.
E não esquece.

---

## GLOSSÁRIO

| Termo | Definição |
|-------|-----------|
| **Quadrilateral** | O conjunto dos 4 membros: Diretor, Estrategista, Auditor, Músculo |
| **IAH** | Inteligência Artificial Humana — o modelo de 4 inteligências coordenadas |
| **Veredito** | Decisão final do Diretor — único que pode aprovar avanços |
| **DIRETRIZ** | Documento do Estrategista: o que construir, em que ordem, com que risco |
| **MEMORIA_Vx** | Documento técnico de cada iteração — memória viva do projecto |
| **relatorio_evolutivo** | Análise de negócio de cada iteração — visão de consultor |
| **Diretriz Zero** | O protocolo de Discovery (7 perguntas) antes de qualquer estratégia |
| **Camada** | Nível de complexidade do projecto (1 — MVP a 5 — Monopólio) |
| **Dívida P0** | Problema crítico que bloqueia produção — resolve antes de qualquer feature |
| **Feedback Loop** | Log + Métrica + Acção correctiva — obrigatório em cada módulo |
| **Handoff** | Entrega ao cliente com tudo o que precisa para operar de forma autónoma |
| **Sprint de Diagnóstico** | Produto de entrada: diagnóstico + roadmap sem implementação |
| **Retainer** | Mensalidade de operação e evolução contínua pós-entrega |

---

## VERSÃO E HISTÓRICO

| Versão | Data | O que mudou |
|--------|------|------------|
| 1.0 | 2026-05-11 | Criação — Memorando Universal agnóstico de stack e produto, derivado do Memorando Vanguard v1.3 |

---

*Documento emitido pelo Músculo do Quadrilateral · IAH — Inteligência Artificial Humana*
*Para uso em qualquer projecto — ecommerce, app, site, SaaS, modelo de negócio, automação*
*Próxima revisão: após o primeiro projecto de cliente concluído com este memorando*
