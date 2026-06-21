---
name: campanha-linkedin-5fases
description: Monta a campanha completa do LinkedIn para um nicho escolhido pelo Diretor, seguindo as 5 fases da metodologia B2B da Vanguard: diagnóstico, planejamento, execução, validação e otimização. Use esta skill SEMPRE que o usuário disser "trabalhar [nicho]", "montar campanha", "campanha LinkedIn", "preparar os posts", "quero trabalhar o nicho X", "gerar conteúdo para [nicho]", "me dê a campanha", ou após o Diretor escolher um nicho no radar. Nunca montar campanha sem nicho definido. Nunca publicar — entregar tudo pronto para os 2 cliques do Diretor.
---

# Campanha LinkedIn 5 Fases — Vanguard IAH

Você monta a campanha completa de LinkedIn para o nicho escolhido pelo Diretor.
Entrega tudo pronto para aprovação — o gatilho de publicar é sempre humano (Portão 2).

**Fonte primária:** material do Projetista (plano de execução, cards, roteiros).
**Fonte complementar:** `_MODEL.json` do nicho (campos: `busca_linkedin`, `dores`, `roi_vanguard`, `narrativas.linkedin_post`, `gatilho_regulatorio`, `prospect_ideal`).

Se o Projetista ainda não entregou → operar com `_MODEL.json` + sinalizar `[AGUARDA Projetista]` nos campos dependentes.

---

## PRÉ-CONDIÇÃO OBRIGATÓRIA

Antes de iniciar qualquer fase:

```
[ ] Portão 1 confirmado — Diretor escolheu o nicho
[ ] _MODEL.json do nicho disponível (Drive ou paste)
[ ] Portão 2 (LinkedIn setup) — sinalizar se pendente
```

Se Portão 2 pendente → alertar no topo e continuar produzindo o material.
A campanha pode ser montada antes do setup estar concluído — não pode ser publicada.

---

## FASE 1 — DIAGNÓSTICO

### 1A. Audiência-alvo (3 decisores do comitê de compra B2B)

Para cada nicho, mapear:

| Decisor | Cargo típico | Preocupação principal | Como entra no conteúdo |
|---------|-------------|----------------------|------------------------|
| Técnico | CTO / Dir. Compliance / Dir. TI | Risco e conformidade | Thought Leadership + Prova técnica |
| Financeiro | CFO / Dir. Financeiro | ROI e multa evitada | Business Case quantificado |
| Operacional | Coord. Fiscal / Gerente de TI | Dor crônica do dia a dia | Pilar de prova de competência |

Fonte: campo `prospect_ideal.perfil` do `_MODEL.json`.

### 1B. Estado dos ativos digitais

```
Perfil Eduardo:
[ ] Headline otimizada com palavras-chave do nicho
[ ] Seção Sobre com pirâmide invertida
[ ] All-Star do LinkedIn confirmado

Company Page Vanguard IAH:
[ ] Existe e está configurada
[ ] URL customizada (não aleatória)
[ ] Especialidades preenchidas (até 20)
[ ] Taxonomia correta
```

Campos não confirmados → `[VERIFICAR COM DIRETOR]`.

### 1C. Lacuna competitiva

Com base no `DIGITAL/INBOX` (frente ED1 — concorrentes LinkedIn):
- O que os concorrentes publicam neste nicho?
- Qual a frequência deles?
- Qual a lacuna que a Vanguard ocupa?

Se INBOX vazio → `[AGUARDA ED1]` + operar com análise baseada no nicho.

---

## FASE 2 — PLANEJAMENTO

### Calendário editorial — 30 dias

Cadência: **5 posts/semana no perfil do Eduardo** + **1 post/semana na Company Page**.

Distribuição por pilar (semana-tipo):

| Dia | Pilar | Formato | Gatilho de timing |
|-----|-------|---------|-------------------|
| Seg | Thought Leadership | Análise regulatória (texto longo) | Abertura da semana do decisor |
| Ter | Business Case | Case anonimizado com número | Terça = alto engajamento B2B |
| Qua | Prova de competência | Método em ação / bastidor técnico | Mid-week |
| Qui | Thought Leadership | Enquete ou provocação técnica | Engajamento qualificado |
| Sex | Business Case | ROI / dado de mercado | Fechamento semanal |
| Page | Validação institucional | Case denso ou posicionamento | Semanal, dia flexível |

**Prioridade do calendário:** gatilho regulatório (`gatilho_regulatorio` do `_MODEL.json`) sobrepõe a cadência fixa — deadline próximo vira janela de autoridade just-in-time (L34-⭐ A2).

---

## FASE 3 — EXECUÇÃO (conteúdo pronto)

### Posts do perfil do Eduardo (5 posts da semana)

Para cada post entregar:

```
POST [N] — [Dia] — Pilar: [Thought Leadership / Business Case / Prova]

HEADLINE (primeira linha — gancho):
[texto — max 2 linhas visíveis antes do "ver mais"]

CORPO:
[texto completo — linguagem do Eduardo — primeira pessoa]
[sem bullet points excessivos — parágrafos curtos — voz humana]
[palavra-chave de cauda longa no 1º parágrafo]

CTA (última linha):
[uma ação — comentar, salvar, conectar — nunca "compre agora"]

HASHTAGS (3–5 — técnicas, não genéricas):
#[hashtag1] #[hashtag2] #[hashtag3]

NOTA INTERNA (não publica):
[instrução ao Diretor — ex: "publicar na terça 08h", "anonimizar dado X antes"]
```

### Post da Company Page (1 post semanal)

Business case anonimizado ou posicionamento institucional.
Formato mais denso, mais formal — voz institucional, não pessoal.
Eduardo compartilha do perfil pessoal para romper inércia algorítmica.

---

## FASE 4 — PROSPECÇÃO

### Busca no LinkedIn Sales Navigator / busca nativa

```
Busca recomendada:
[extrair campo busca_linkedin do _MODEL.json]

Filtros adicionais:
- Porte: [conforme prospect_ideal do nicho]
- Setor: [conforme nicho]
- Cargo: [3 decisores mapeados na Fase 1]
- Localização: Brasil (refinar por estado se nicho regional)
```

### Roteiro de abordagem artesanal (para o Diretor enviar manualmente)

**Mensagem 1 — conexão (sem pitch):**
```
[Nome], vi seu trabalho em [empresa/cargo]. Tenho acompanhado os impactos
de [gatilho_regulatorio] no setor e estou publicando análises sobre isso.
Posso te adicionar?
```

**Mensagem 2 — depois de aceito (valor primeiro):**
```
Obrigado pela conexão, [Nome]. Recentemente publicamos [tema do post]
que pode ser relevante para [cargo/setor]. Sem compromisso — só quero
saber se fez sentido para a sua realidade.
```

**Mensagem 3 — qualificação (só se respondeu):**
```
Que bom que fez sentido. Temos trabalhado com [descrição genérica do perfil]
em situações parecidas com a sua. Valeria uma conversa rápida de 20 minutos
para ver se podemos ajudar?
```

**Regra:** nunca automatizar. Artesanal, cadenciado, sem ansiedade de venda.
O Diretor envia cada mensagem manualmente e no tempo certo.

---

## FASE 5 — SEO APLICADO

Listar as **5 palavras-chave de cauda longa** usadas nesta campanha:

```
1. [termo] — aparece em: [post N, headline, CTA]
2. ...
5. [termo] — aparece em: [...]
```

Confirmar que as palavras-chave do nicho ativo estão nas Especialidades da Company Page.

---

## FORMATO DE ENTREGA FINAL

```
# CAMPANHA LINKEDIN — [NICHO] — [data]

## PRÉ-CONDIÇÕES
[checklist preenchido]

## FASE 1 — DIAGNÓSTICO
[3 decisores + estado dos ativos + lacuna competitiva]

## FASE 2 — CALENDÁRIO EDITORIAL (30 dias)
[tabela semana-tipo + ajuste por gatilho regulatório]

## FASE 3 — CONTEÚDO PRONTO
### Posts — Perfil Eduardo (semana 1)
[5 posts completos]
### Post — Company Page (semana 1)
[1 post completo]

## FASE 4 — PROSPECÇÃO
[busca + 3 mensagens prontas para o Diretor]

## FASE 5 — SEO APLICADO
[5 palavras-chave + onde aparecem]

## ALERTAS AO DIRETOR
[o que precisa de aprovação / verificação antes de publicar]
[sinalizar [AGUARDA Projetista] se material não chegou]

## PRÓXIMO PASSO
Aguardando sua aprovação nos 2 cliques para publicar.
Semana 2 monto após seu sinal.
```

---

## REGRAS FINAIS

- **Portão 2 é inviolável** — entrego tudo, o Diretor publica.
- **Post ensina, não vende** — zero pitch direto em nenhum dos 5 posts.
- **R-3 em vigor** — nenhum termo de IA, ferramenta ou cliente nomeado.
- **Business case sempre anonimizado** — "um hospital de 200 leitos", nunca o nome.
- **Prospecção artesanal** — nunca sugerir automação de mensagens.
- **Mídia paga = fase 5 avançada** — só sob ordem do Diretor com ROI validado.
- Campo vazio no `_MODEL.json` → `[AGUARDA]`, nunca inventar dado.

