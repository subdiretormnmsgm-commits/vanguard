---
name: viabilidade-roi
description: Use no filtro estrutural de todo nicho, após o pré-mortem e o discovery. Roda SWOT + 3 critérios + Pergunta de Ouro e separa obrigatoriamente as DUAS camadas de ROI (A1 prospect × A2 sizing interno). RECUSA fabricar número de mercado — consome o parecer M-STATS ou declara a lacuna e aciona a Ação 3. Dispare sempre que o Diretor pedir análise de viabilidade, avaliação de nicho, ticket, ROI ou dimensionamento de mercado — mesmo sem mencionar "SWOT" ou "M-STATS" explicitamente. Número sem intervalo de confiança é inválido.
---

# Viabilidade + ROI Duas Camadas

## Contexto
Dois erros recorrentes nesta fase: (1) misturar o ROI do prospect com o sizing de mercado da Vanguard — são públicos diferentes, lógicas diferentes, jamais se contaminam; (2) inventar TAM/SAM/SOM sem parecer M-STATS, produzindo número que não resiste a uma pergunta do cliente. Esta skill bloqueia os dois.

## Procedimento

### Passo 1 — SWOT Vanguard × nicho
Analisar forças e fraquezas **da Vanguard naquele nicho específico** — não SWOT genérica.

```
FORÇAS (o que a Vanguard já tem que serve aqui):
- Skills/versões do VANGUARD_HISTORICO aplicáveis
- Casos anonimizados que provam entrega neste contexto
- Relacionamentos ou entradas já existentes no setor

FRAQUEZAS (o que falta ou é risco interno):
- Gaps de acervo (o que precisaria ser construído do zero)
- Ausência de casos no nicho
- Dependências de terceiros (frentes Cowork pendentes)

OPORTUNIDADES (o que o mercado está oferecendo agora):
- Gatilho regulatório ativo (do discovery-regulatorio)
- Janela temporal (prazo, deadline, mudança recente)
- Concorrentes sem solução especializada

AMEAÇAS (o que pode matar o projeto — conectar ao pré-mortem):
- Fator-morte identificado no pre-mortem-risco
- Risco regulatório (norma pode mudar)
- Risco de pipeline (Gate E-4: sem cliente para validar)
```

### Passo 2 — Filtro estrutural: 3 critérios + Pergunta de Ouro
Avaliar cada critério com SIM / NÃO / PARCIAL:

```
FILTRO ESTRUTURAL:
[ ] Critério 1 — DOR VERIFICÁVEL: existe dor já acontecida com número confirmado?
[ ] Critério 2 — ACERVO APLICÁVEL: há skill/versão no VANGUARD_HISTORICO reutilizável?
[ ] Critério 3 — ENTRADA VIÁVEL: existe um caminho real de primeiro contato?

PERGUNTA DE OURO: "Se tudo correr bem, o cliente vai perceber o valor em até 90 dias?"
Resposta: SIM / NÃO / DEPENDE DE [condição]
```

**Regra:** qualquer critério com NÃO → não avança a plano completo (PADRÃO/PESADA). Pode avançar a sessão LEVE para preparação, mas não a execução.

### Passo 3 — ROI Camada A1 (prospect — cost-avoidance)
Esta é a camada que o cliente vê. Nunca misturar com A2.

Calcular o ROI do **prospect** com base na dor verificada:
- Custo da não-conformidade (multa, autuação, retrabalho, perda de CND)
- Custo atual de resolver o problema sem a Vanguard (horas internas, consultor genérico)
- Economia/ganho com a solução da Vanguard
- Payback estimado (em dias/meses)

```
ROI A1 — PROSPECT:
Custo atual do problema: R$ [valor ou faixa — da dor verificada]
Custo da solução Vanguard: R$ [ticket]
Economia/ganho: R$ [diferença]
Payback: [N] dias/meses
Argumento: "Para cada R$ 1 investido, o cliente evita R$ [X] em [consequência]"
```

### Passo 4 — ROI Camada A2 (interno — market sizing)
Esta é a camada interna da Vanguard. **NUNCA sai em material externo.**

**REGRA INVIOLÁVEL — ANTI-FABRICAÇÃO:**
- Se o parecer M-STATS **existe** em PENDING_REVIEW.md → citar com IC + fonte. Nunca arredondar.
- Se o parecer M-STATS **não existe** → declarar lacuna e acionar Ação 3:

```
⚠️ SEM DIMENSIONAMENTO M-STATS
Ação 3 acionada: solicitar parecer M-STATS ao Músculo/Executor com foco em:
- TAM: [especificação do universo a dimensionar]
- SAM: [recorte aplicável à Vanguard]
- SOM: [meta realista no horizonte do plano]
Projeção de A2 bloqueada até recebimento do parecer.
"INCONCLUSIVO — sem dimensionamento" vence número inventado.
```

Se M-STATS disponível:
```
ROI A2 — SIZING INTERNO (camada fria — M-STATS):
TAM: R$ [valor] ± [IC]% — Fonte: [origem] · Data: [data] · N: [amostra]
SAM: R$ [valor] ± [IC]%
SOM (horizonte [N] meses): R$ [valor] ± [IC]%
Convergência top-down × bottom-up: [±X% — dentro/fora do ±15%]
```

## Output esperado
```
VIABILIDADE + ROI — [Nicho]

SWOT: [tabela forças/fraquezas/oportunidades/ameaças]

FILTRO ESTRUTURAL:
✅/❌ Critério 1 — Dor verificável
✅/❌ Critério 2 — Acervo aplicável
✅/❌ Critério 3 — Entrada viável
Pergunta de Ouro: [SIM/NÃO/DEPENDE]
Veredito: [AVANÇA / NÃO AVANÇA / AVANÇA LEVE]

ROI A1 (prospect): [argumento de cost-avoidance]
ROI A2 (interno): [M-STATS com IC] ou [INCONCLUSIVO — Ação 3 acionada]
```

## Gates
- Critério com NÃO → não avança a plano completo
- TAM/SAM/SOM sem parecer M-STATS → **bloqueado**
- Número sem IC → **inválido**
- A1 e A2 misturados → **falha crítica**

## Âncoras
Mandato 23 · Gate de Fato · M-STATS · §3 · §3b · §6
Depende de: `pre-mortem-risco`, `discovery-regulatorio`
Alimenta: `eap-raci` (§5), `abordagem-blindada` (§8)