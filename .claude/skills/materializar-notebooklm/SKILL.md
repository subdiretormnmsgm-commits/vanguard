---
name: materializar-notebooklm
description: Use quando um plano é aprovado ou o Diretor pede material apresentável. Emite o prompt personalizado ao NotebookLM (caderno PROJETISTA-ACERVO), seleciona o formato calibrado ao decisor-alvo, trata JSON para TXT, aciona fallback se Chrome falhar e roda verificacao-r3-blindagem no resultado antes de entregar. Dispare em toda sessão de materialização — deck ao cliente, audio de briefing, infografico EAP ou ROI, cards de campanha para o Digital.
---

# Materializar via NotebookLM (Acao 2 + Acao 4 · Bloco 7)

## Contexto
O Projetista não produz material apresentável à mão — comanda o NotebookLM com prompts personalizados e entrega o artefato blindado ao Diretor. A materialização tem duas faces: (1) material para o cliente (deck, áudio, infográfico) e (2) material para o Embaixador Digital (cards, posts, roteiros). Ambas passam pelo mesmo gate R-3 antes de sair.

## Pré-condição obrigatória

### Verificar caderno PROJETISTA-ACERVO
Antes de qualquer materialização:
```
PROJETISTA-ACERVO existe? [SIM / NÃO]
→ NÃO: sinalizar "PROJETISTA-ACERVO ausente — acionar /notebooklm" e PARAR.
→ SIM: confirmar que as fontes do VANGUARD_HISTORICO estão carregadas.
```
Namespace exclusivo: P-123 — nunca usar o caderno do Auditor.

### Preparar fontes
```
Arquivos JSON (NICHE_INDEX, MODEL.json) → converter para TXT antes (P-161)
Comando: copiar conteúdo relevante em arquivo .txt antes de carregar no NotebookLM
```

## Procedimento

### Passo 1 — Identificar o artefato solicitado
Selecionar o tipo de materialização:

| Tipo | Destinatário | Formato | Template |
|---|---|---|---|
| Apresentação ao cliente | Prospect (via Diretor) | 8 slides | PROMPT-DECK |
| Áudio de briefing | Diretor (pré-reunião) | Até 10 min | PROMPT-AUDIO |
| Infográfico ROI/EAP | Diretor / prospect | Visual | PROMPT-INFOGRAFICO |
| Cards de campanha | Embaixador Digital (via Diretor) | 3 cards + 1 reel | PROMPT-CAMPANHA |
| One-pager de arquitetura | Comprador técnico | 1 página | PROMPT-ONEPAGER |

### Passo 2 — Calibrar ao decisor (L34-A2)
Antes de emitir o prompt, confirmar o decisor-alvo da `abordagem-blindada`:
- CFO/Financeiro → priorizar PROMPT-INFOGRAFICO (risco financeiro + ROI em R$)
- Fundador/CEO → priorizar PROMPT-AUDIO (visão) + PROMPT-DECK
- Comprador técnico → priorizar PROMPT-ONEPAGER (arquitetura + checklist)
- Embaixador Digital → sempre PROMPT-CAMPANHA

### Passo 3 — Emitir o prompt personalizado

**PROMPT-DECK (apresentação ao cliente):**
```
[PROMPT — APRESENTAÇÃO] Gere apresentação de 8 slides para o Diretor apresentar
ao cliente do nicho [X]. Fontes: cartão [id]_MODEL.txt, skill validada na
[versão do VANGUARD_HISTORICO], argumento de abertura da abordagem blindada.
Estrutura obrigatória:
  Slide 1 — Dor já acontecida (número verificado + fonte)
  Slide 2 — Por que soluções genéricas falham neste nicho
  Slide 3 — Método da Vanguard ("nossa equipe de especialistas")
  Slide 4 — O produto: o que é entregue e em quanto tempo
  Slide 5 — Prova: caso anonimizado com resultado mensurável
  Slide 6 — ROI: quanto o cliente economiza/evita em R$
  Slide 7 — Como começa: próximos passos concretos
  Slide 8 — Fechamento: o que muda para o cliente
Linguagem: PT-BR, foco em resultado, tom executivo.
RESTRICAO ABSOLUTA: nunca IA, automação, ferramentas, Claude, NotebookLM.
Sempre "especialistas da Vanguard", "nossa equipe", "nosso método".
```

**PROMPT-AUDIO (briefing pré-reunião):**
```
[PROMPT — AUDIO] Audio Overview em PT-BR, até 10 minutos, resumindo o plano
do nicho [X] para o Diretor ouvir antes da reunião com o prospect.
Cobrir: dor do nicho (número), produto da Vanguard, argumento de abertura,
as 3 objeções mais prováveis com respostas prontas, próximo passo concreto.
Tom: briefing executivo direto — sem rodeios, sem repetição.
RESTRICAO: sem citar ferramentas internas. "Nossa equipe" em todo lugar.
```

**PROMPT-INFOGRAFICO (ROI ou EAP):**
```
[PROMPT — INFOGRAFICO] Gere infográfico visual sobre [ROI do nicho X / EAP do projeto Y].
Para ROI: mostrar custo do problema, custo da solução, economia, payback em dias.
Para EAP: decomposição hierárquica top-down dos [N] pacotes, com responsável por pacote.
Visual limpo, dados verificados, sem menção a ferramentas internas.
Fonte dos números: [citar origem — Gate de Fato].
```

**PROMPT-CAMPANHA (cards para o Digital):**
```
[PROMPT — CAMPANHA] Gere 3 cards LinkedIn + 1 roteiro de reel sobre o nicho [X],
a partir do argumento de abertura e das dores verificadas.
Cada card: um número de dor verificado + uma linha de autoridade da Vanguard.
Reel (60s): gancho (dor) + agravante (consequência) + solução (nossa equipe) + CTA.
Linguagem: "especialistas da Vanguard" / "nosso método". Pronto para o Diretor
aprovar e despachar ao Embaixador Digital.
RESTRICAO: nunca IA, automação, Claude, ferramentas. Sempre "nossa equipe".
```

**PROMPT-ONEPAGER (comprador técnico):**
```
[PROMPT — ONEPAGER] Gere one-pager de arquitetura para comprador técnico do nicho [X].
Estrutura: problema técnico específico + consequência mensurável + como a Vanguard
resolve (passos concretos) + checklist de conformidade pós-entrega.
Tom: técnico, objetivo, sem adjetivo. Sem menção a ferramentas ou IA.
```

### Passo 4 — Executar via Claude in Chrome (P-126)
```
EXECUCAO:
1. Abrir NotebookLM no caderno PROJETISTA-ACERVO via Claude in Chrome
2. Colar o prompt personalizado no Studio do caderno
3. Aguardar geração
4. Copiar o artefato gerado para revisão

FALHOU (timeout, extensão inativa, erro de navegação)?
→ Fallback P-110: entregar o prompt formatado ao Diretor para execução manual.
   "Diretor, o Chrome falhou. Cole este prompt no PROJETISTA-ACERVO:"
   [prompt pronto para colar]
```

### Passo 5 — Gate R-3 no artefato gerado
Rodar `verificacao-r3-blindagem` no artefato antes de qualquer entrega:
```bash
python scripts/scan_r3.py <artefato_gerado.txt>
```
- FAIL → corrigir prompt (adicionar restrição mais específica) e regenerar
- OK → liberar com selo "R-3 OK"

### Passo 6 — Entrega ao Diretor + recomendação de despacho
```
ENTREGA:
Artefato: [tipo] — [nicho] — R-3 OK
Recomendação de despacho (Acao 4):
"Diretor, este [deck/áudio/cards] está pronto para [reunião com prospect / despacho
ao Embaixador Digital]. Sugiro [acao concreta]. Aguardo veredito."
```
Nunca despachar diretamente ao Digital — sempre via Diretor (P-075).

## Output esperado
```
MATERIALIZACAO — [Nicho] — [tipo de artefato]

PRE-CONDICAO: PROJETISTA-ACERVO [confirmado / ausente]
DECISOR-ALVO: [cargo] — FORMATO: [tipo]
PROMPT EMITIDO: [DECK / AUDIO / INFOGRAFICO / CAMPANHA / ONEPAGER]
EXECUCAO: [Chrome OK / Fallback P-110 acionado]
STATUS R-3: [OK / FAIL — corrigindo]
RECOMENDACAO DE DESPACHO: [texto pronto para o Diretor]
```

## Gates
- Caderno ausente → PARAR, sinalizar, não improvisar
- JSON sem conversão TXT → bloquear carga no NotebookLM (P-161)
- Artefato sem R-3 OK → não entrega
- Despacho direto ao Digital sem veredito do Diretor → violação P-075

## Ancoras
Acao 2 · Acao 4 · Bloco 7 · P-123 · P-126 · P-110 · P-161 · L34-A2
Depende de: `abordagem-blindada`
Chama: `verificacao-r3-blindagem`
Entrega a: Diretor (que despacha ao Digital)