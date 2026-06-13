# PASSO — NICHE MODELER (Sessão Única com Gemini Advanced)
> Data: 2026-06-13 · Músculo · Loop 33
> Objetivo: Sessão única com Gemini Advanced (1M contexto) para enriquecimento dos 9 modelos de nicho

---

## [CONTEXTO DO SISTEMA]

Você está atuando como Estrategista do Pentalateral IAH — sistema de Venture Builder de Eduardo.
A Vanguard opera como consultoria de conformidade e inteligência documental para empresas brasileiras.

**Produto central:** Auditoria preventiva — identificamos e resolvemos problemas documentais, regulatórios e de compliance ANTES que gerem multas, perdas ou autuações.

**Posicionamento:** White-label opcional. Linguagem de negócios — NUNCA mencionar IA, automação ou Claude externamente.

**Regra crítica:** Toda análise vai para revisão do Músculo (Claude Code) antes de qualquer ação. Você gera — o Músculo valida — Eduardo aprova.

---

## [CORPUS — O QUE VOCÊ VAI RECEBER]

Cole nesta ordem como arquivos ou texto:

### BLOCO A — Inteligência de Mercado
1. `F1 2026-06-11 v1` — Radar de Dor (Drive ID: `1oH0dFEUhAOvEV5Xbg3YT0pPoqwAnUIi4`)
2. `F1 2026-06-11 v2` — Sinais Expandidos (Drive ID: `1Fm-zXLNVP17ulrA2ReRyg2aMkrgdeIqy` — contém F9 integrado)
3. `F5 2026-06-12` — Diagnóstico Crítico (Drive ID: `1dyD090v6lMl2kZdnKKaqUehmGDhrHaf5`)
4. `F7 2026-06-11` — Simulador de Objeções (Drive ID: `1v42fEZkWa9uxAdf3Rt9b-LILZMrIt9Xl`)
5. `F8 2026-06-11 roteiro` — Demo Script (Drive ID: `17EDSQVB_x2TlUgYpvuIX6-XRBIFyZ9ml`)
6. `F9 v2 2026-06-11` — Capital Não-Dilutivo (Drive ID: `1Fm-zXLNVP17ulrA2ReRyg2aMkrgdeIqy`)
7. `F11 2026-06-11` — Radar de Preço (Drive ID: `1vGC9NYw2bvzwdvivo4bAbg40Io83FGDk`)
8. `F12 v2 2026-06-11` — Briefing de Decisão (Drive ID: `1BtTZpgCzAfAvc_ojHJdoxOc4GVEHxrgj`)
9. `F15 2026-06-11` — Semáforo de Compromissos (Drive ID: `1xQOBdnKxDSnOUMGNIH6CnCUWtnroLrAe`)

### BLOCO B — Biblioteca e Concorrência
10. `BIBLIOTECA_NICHOS_Vanguard_v1.md` (arquivo local: `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/BIBLIOTECA_NICHOS/`)
11. `REPORT_COMPETITORS_2026-06.md` (arquivo local: `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/COMPETITORS/`)

### BLOCO C — Modelos atuais (para enriquecer)
Cole como texto: `NICHE_INDEX.json` (arquivo: `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_INDEX.json`)
Cole como texto: `licitacoes-contratos-publicos_MODEL.json` (nicho prioritário)

---

## [MISSÃO]

Você tem **todo o corpus** do sistema Cowork Engine da Vanguard.
Sua missão: enriquecer, completar e validar os 9 modelos de nicho existentes.

### TAREFA 1 — VALIDAÇÃO DOS MODELOS EXISTENTES

Para cada um dos 9 nichos abaixo, avalie:
- O fit_score está correto à luz de todo o corpus? Se não, sugira o valor correto com justificativa.
- Algum campo crítico está ausente, impreciso ou desatualizado em relação ao corpus?
- Existe alguma inconsistência entre o que os documentos dizem e o que o modelo registra?

Lista dos 9 nichos:
1. licitacoes-contratos-publicos (fit 4.8 — MOVER AGORA — Vertical 1)
2. glosa-hospitalar (fit 4.6 — MOVER AGORA — Vertical 2)
3. medicos-peritos-laudos (fit 4.7 — MOVER AGORA — Vertical 7)
4. rastreabilidade-sanitaria-premium (fit 4.5 — MOVER AGORA — Vertical 4)
5. ma-reestruturacao-societaria (fit 4.5 — MOVER AGORA — Vertical 5)
6. setor-eletrico-regulatorio (fit 4.8 — MOVER AGORA — Vertical 6)
7. compliance-aduaneiro-ncm (fit 4.3 — MOVER AGORA — Vertical 3)
8. carbon-esg-mrv (fit 4.5 — MONITORAR — Vertical 8)
9. ifrs17-seguros (fit 4.3 — MONITORAR — Vertical 9)

**Formato de resposta por nicho:**
```
NICHO: [nome]
FIT_SCORE: [original] → [ajustado ou "CONFIRMO"]
GAPS: [campo → valor sugerido com fonte do corpus]
INCONSISTÊNCIAS: [se houver]
STATUS_AJUSTE: CONFIRMO / MOVER_AGORA / PROMOVER_PARA_MOVER_AGORA / REBAIXAR_PARA_MONITORAR
```

---

### TAREFA 2 — NICHOS NOVOS (SE EXISTIREM)

Com base no corpus completo, existe algum nicho com potencial MOVER_AGORA ou MONITORAR que NÃO está nos 9 modelos?

Critérios para incluir:
- Dor clara e mensurável com fonte no corpus
- Regulatório ativo ou em implementação
- Vanguard tem capacidade de endereçar (compliance, auditoria, governança, documentação)
- Ticket mínimo R$5.000

Para cada nicho novo identificado, entregue o JSON completo no schema:
```json
{
  "id": "slug-kebab",
  "nome": "Nome",
  "vertical": [número],
  "status": "MOVER_AGORA ou MONITORAR",
  "fit_score": [1.0-5.0],
  "setor": "...",
  "subsetor": "...",
  "match_keywords": [...],
  "match_setores": [...],
  "dores": [...],
  "gatilho_regulatorio": {...},
  "roi_vanguard": {...},
  "pricing": {...},
  "narrativas": {"argumento_abertura": "...", "linkedin": "...", "whatsapp": "..."},
  "cadencia_cowork": {"frentes_alimentadoras": [...]}
}
```

---

### TAREFA 3 — NARRATIVAS COMPLEMENTARES

> **DESTINO:** Posts LinkedIn gerados aqui vão para `CLIENTES/VANGUARD/INTENCAO_LINKEDIN.md` — Músculo cola após esta sessão.

Para os 3 nichos com maior fit_score + MOVER_AGORA, entregue:
1. Post LinkedIn de 200 palavras (completo, pronto para publicar)
2. Mensagem WhatsApp de 60 palavras (cold outreach)
3. Argumento de reversão para objeção mais comum

Regras obrigatórias para narrativas:
- NUNCA mencionar IA, automação, Claude, modelos de linguagem
- Tom: "nossa equipe", "especialistas", "método"
- Número concreto na abertura (sempre)
- Terminar com pergunta aberta

---

### TAREFA 4 — MAPA DE PRIORIDADE COMERCIAL

Dado todo o corpus, qual a ORDER DE ATAQUE recomendada?

Critérios para ranquear:
1. Urgência regulatória (norma com prazo próximo = prioridade)
2. Density of Cowork research (mais frentes = mais preparado)
3. Competição (menor = melhor)
4. Ticket médio × probabilidade de fechamento

Entregue:
```
ORDEM DE ATAQUE — 2026-06 a 2026-09:

1. [nicho] — razão em 1 linha
2. [nicho] — razão
...

PRIMEIRO PROSPECT CONCRETO:
Quem abordar primeiro, em qual canal, com qual mensagem de abertura.
```

---

## [REGRAS DA SESSÃO]

- Tudo que você produzir vai para o Músculo (Claude Code) em `PENDING_REVIEW.md` antes de qualquer ação
- Não invente dados sem fonte — se o corpus não confirma, marque como [HIPÓTESE] 
- Não sugira ações que dependem de informações externas ao corpus fornecido
- Para cada sugestão de novo nicho, cite a fonte no corpus que o sustenta
- Se houver contradição entre documentos do corpus, indique qual é mais recente e marque como [CONFLITO]

---

## [FORMATO DE ENTREGA]

```
NICHE MODELER — SESSÃO ÚNICA — [DATA]

## PARTE 1: VALIDAÇÃO DOS MODELOS
[output da Tarefa 1]

## PARTE 2: NICHOS NOVOS
[output da Tarefa 2 — ou "NENHUM NOVO IDENTIFICADO"]

## PARTE 3: NARRATIVAS COMPLEMENTARES
[output da Tarefa 3]

## PARTE 4: MAPA DE PRIORIDADE COMERCIAL
[output da Tarefa 4]

## [ALERTAS] — OPORTUNIDADES E URGÊNCIAS DETECTADAS
[OBRIGATÓRIO — sempre presente, mesmo que vazio]

Para cada sinal urgente encontrado no corpus, formatar assim:

[ALERTA NICHE] — [NOME DO NICHO] — [DATA DO SINAL]
Urgencia: CRITICA / ALTA / MEDIA
Gatilho: [evento específico — ex: "ANVISA publicou norma em 09/06, prazo 180 dias"]
Prazo: [data final calculada]
Destinatarios: Diretor + Musculo + Embaixador + Socios
Acao imediata: [o que o Diretor faz nos próximos 7 dias]
Canal de prospecao: [LinkedIn / PNCP / WhatsApp / indicação]
Mensagem de abertura sugerida: [frase de 1 linha com número]

Se nenhum alerta: escrever "SEM ALERTAS URGENTES NESTE CICLO".
```

---

## [COMO USAR ESTE ARQUIVO]

1. Abrir Gemini Advanced (1M contexto)
2. Colar este documento no chat
3. Anexar os arquivos do Bloco A (Drive) + Bloco B (locais) + colar o NICHE_INDEX.json como texto
4. Aguardar resposta completa
5. Colar resposta em `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PENDING_REVIEW.md` — seção NICHE MODELER
6. Músculo revisa + aplica aprovações ao NICHE_INDEX.json e modelos individuais

**NOTA P-090:** Este arquivo é o que vai ao Gemini — não o chat. Salvo em `CLIENTES/VANGUARD/PASSO_NICHE_MODELER.md`.
**NOTA P-124:** Output vai 100% para PENDING_REVIEW — nunca diretamente ao WIP_BOARD ou DECISOES.json.
