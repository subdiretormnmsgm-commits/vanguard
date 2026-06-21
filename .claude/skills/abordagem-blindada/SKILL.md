---
name: abordagem-blindada
description: Use ao fechar todo plano de execução, para gerar o insumo de campanha do Embaixador Digital. Produz argumento de abertura, objeções com contra-argumentos, perfil do prospect e canal recomendado — calibrados ao decisor-alvo (CFO, fundador ou comprador técnico). Chama verificacao-r3-blindagem antes de liberar qualquer linha. Dispare quando o Diretor pedir abordagem, roteiro de prospecção, como chegar no cliente, material para o Digital ou campanha de nicho.
---

# Abordagem Blindada — Insumo de Campanha (FASE 4 · §8 + Ação 4)

## Contexto
A abordagem é a ponte entre o plano interno e o mercado externo. Dois erros a destroem: (1) linguagem interna vazando para o prospect (ferramenta, IA, automação) — invalida o posicionamento; (2) argumento genérico não calibrado ao decisor real — cai no lixo antes da segunda frase. Esta skill blinda os dois e entrega insumo pronto para o Embaixador Digital.

## Procedimento

### Passo 1 — Identificar o decisor-alvo
A partir do RACI da `eap-raci` e do perfil do nicho, identificar quem de fato assina a compra:

```
PERFIL DO DECISOR:
Cargo/função: [título real — não genérico]
Empresa-tipo: [porte, setor, faturamento mínimo se aplicável]
Dor primária: [o que tira o sono — em linguagem nativa do alvo]
Métrica que usa: [como mede sucesso no dia a dia]
Objeção provável #1: [o que vai dizer primeiro]
Canal de entrada: [LinkedIn / WhatsApp / referência / evento / cold e-mail]
```

### Passo 2 — Calibrar formato ao decisor (L34-A2)
O formato do material é determinado pelo perfil do decisor — nunca pela preferência estética:

| Decisor | Formato prioritário | Tom |
|---|---|---|
| CFO / Diretor Financeiro | Infográfico de risco financeiro + ROI em R$ | Frio, quantitativo, sem adjetivo |
| Fundador / CEO | Áudio de visão + one-pager de posicionamento | Estratégico, orientado a futuro |
| Comprador técnico (Controller, Coordenador Fiscal) | One-pager de arquitetura + checklist de conformidade | Técnico, detalhado, concreto |
| Sócio de escritório (contabilidade, advocacia) | Post LinkedIn + roteiro de conversa | Peer-to-peer, sem jargão de venda |

### Passo 3 — Construir o argumento de abertura
Ancorado na "dor já acontecida" do `discovery-regulatorio`. Formato obrigatório:

> *"[Número verificado] de [perfil exato do alvo] já [consequência real] por conta de [norma verificada]. O prazo para [ação] é [data confirmada]. Nossa equipe resolve isso em [tempo] — sem [principal dor do processo atual]."*

**Regras:**
- Número vem do Gate de Fato (discovery-regulatorio) — nunca inventado
- "Nossa equipe" / "nossos especialistas" — nunca ferramenta ou IA
- Consequência concreta (valor da multa, perda de CND, embargo) — nunca vaga
- Prazo real confirmado em fonte — nunca estimado

### Passo 4 — Mapear objeções e contra-argumentos
As 3 objeções mais prováveis para o nicho, com resposta pronta:

```
OBJEÇÃO 1: "[o que o prospect vai dizer]"
CONTRA: "[resposta ancorada em caso anonimizado ou dado verificado]"

OBJEÇÃO 2: "[segunda objeção mais provável]"
CONTRA: "[resposta]"

OBJEÇÃO 3: "Já temos alguém cuidando disso internamente"
CONTRA: "Nossos especialistas complementam o time interno — o foco deles é operação, o nosso é [especificidade do nicho]. Em [caso anonimizado], o cliente já tinha equipe e ainda assim [consequência antes da Vanguard]."
```

### Passo 5 — Definir sequência de canal
Sequência recomendada de contato (não dispersar em todos os canais ao mesmo tempo):

```
SEQUÊNCIA DE CANAL:
1º contato: [canal + formato — ex: LinkedIn connection request com nota curta]
2º contato (D+3): [follow-up — ex: mensagem WhatsApp com argumento de abertura]
3º contato (D+7): [ex: compartilhar post LinkedIn relevante ao nicho]
Gatilho de reunião: [o que converte — ex: "quer ver como calculamos o risco no seu caso?"]
```

### Passo 6 — Gate R-3 obrigatório
**Antes de liberar qualquer linha desta seção**, rodar `verificacao-r3-blindagem` no texto completo.

```
CHECKLIST R-3 (varredura manual se o script não estiver disponível):
[ ] Sem menção a IA, automação, Claude, Opus, NotebookLM
[ ] Sem menção a Gemini, Cowork, Antigravity, Músculo
[ ] Sem menção a ferramentas, algoritmos, bots, prompts
[ ] "Especialistas da Vanguard" ou "nossa equipe" em todo lugar que precisaria de substituição
[ ] Casos sempre anonimizados (P-059)
[ ] Números vêm do Gate de Fato — nenhum inventado
```

FAIL em qualquer item → corrigir antes de liberar. Nunca entregar com R-3 pendente.

## Output esperado
```
ABORDAGEM BLINDADA — [Nicho] — v[N]

DECISOR-ALVO: [cargo + empresa-tipo + canal]
FORMATO CALIBRADO: [tipo de material — L34-A2]

ARGUMENTO DE ABERTURA:
"[texto pronto — blindado, com número verificado]"

OBJEÇÕES + CONTRA-ARGUMENTOS:
1. [objeção] → [contra]
2. [objeção] → [contra]
3. [objeção] → [contra]

SEQUÊNCIA DE CANAL:
1º [D+0] → 2º [D+3] → 3º [D+7] → gatilho de reunião

STATUS R-3: ✅ OK — liberado para despacho ao Diretor
```

## Gate final
**Entrega ao Diretor — nunca diretamente ao Digital (P-075).**
Diretor decide se despacha e quando. O Projetista propõe: *"Sugiro despachar esta seção + cards ao Embaixador Digital — aguardo veredito."*

## Âncoras
R-3 · P-059 · P-075 · L34-A2 · §8 · Ação 4
Depende de: `discovery-regulatorio`, `eap-raci`
Chama: `verificacao-r3-blindagem`
Alimenta: Embaixador Digital (via Diretor), `materializar-notebooklm`