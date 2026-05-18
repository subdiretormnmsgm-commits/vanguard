# DISCOVERY PRODUCT — DELIBERAÇÃO DO CONSELHO EM 48H
**Template Universal · Vanguard Tech**
**Valor:** R$ 3.000 – R$ 5.000 · Sem código · Entrega: artefato executivo em PDF/MD

---

> Este produto vende a inteligência composta do Conselho IAH (Músculo + Estrategista + Auditor)
> aplicada ao problema real do cliente em 48 horas.
> Não há código. Não há MVP. Há diagnóstico, arquitetura de decisão e plano de ação.
> O cliente sai com clareza que levaria meses de tentativa e erro para obter sozinho.

---

## O QUE É ENTREGUE

```
ARTEFATO FINAL: DELIBERAÇÃO_CONSELHO_[CLIENTE]_[DATA].md

Composto por:
  1. DIAGNÓSTICO DO CONSELHO       — o problema real (não o que o cliente acha que é)
  2. MAPA DE DECISÕES              — as 5 decisões que desbloqueiam o negócio
  3. ARQUITETURA DE SOLUÇÃO        — o que construir, nesta ordem, por quê
  4. RISCOS OCULTOS                — o que vai falhar se não for endereçado agora
  5. PLANO DE AÇÃO 30 DIAS         — o que fazer, quem faz, quando
  6. PARECER DO AUDITOR            — o que o histórico de projetos similares ensina
  7. VEREDITO DO DIRETOR           — a decisão soberana sobre qual caminho tomar
```

---

## PROCESSO — 48 HORAS

### HORA 0–2 | INTAKE (Eduardo + Cliente)

**Discovery de 7 Perguntas** (baseado em `FASE_0__BRIEFING_DISCOVERY.md`):

```
1. Qual é o problema que o seu negócio ainda não conseguiu resolver?
2. O que você já tentou? Por que falhou?
3. Quem é o cliente do seu cliente — quem sente a dor na ponta?
4. Se este problema fosse resolvido amanhã, o que mudaria em números?
5. Qual é o maior risco de não resolver isso nos próximos 90 dias?
6. Quem na sua empresa resistiria a uma mudança? Por quê?
7. O que seria uma vitória incontestável para você em 6 meses?
```

**Output:** `BRIEFING_DISCOVERY_[CLIENTE].md` preenchido

---

### HORA 2–8 | CONSELHO PROCESSA (Eduardo + 3 LLMs)

**Passo 1 — Estrategista (Gemini):**
- Recebe BRIEFING_DISCOVERY
- Gera DIRETRIZ com: diagnóstico, prioridades, riscos, arquitetura de solução
- Tempo estimado: 1h de sessão

**Passo 2 — Auditor (NotebookLM):**
- Recebe DIRETRIZ + histórico de projetos similares
- Gera SKILL com: auditoria de coerência, padrões de falha, perspectiva de sócio
- Tempo estimado: 1h de sessão

**Passo 3 — Músculo (Claude Code):**
- Delibera sobre DIRETRIZ + SKILL
- Gera DELIBERAÇÃO_CONSELHO com os 7 blocos obrigatórios
- Tempo estimado: 1–2h de sessão

---

### HORA 8–24 | REFINAMENTO (Eduardo valida)

Eduardo lê o artefato e emite o Veredito Soberano:
- O que está certo → mantém
- O que está impreciso → devolve ao Músculo para refinamento
- O que falta → aciona nova rodada pontual com o membro relevante

---

### HORA 24–48 | ENTREGA (Eduardo + Cliente)

Reunião de entrega:
- Eduardo apresenta o artefato (30–45 min)
- Cliente faz perguntas → Eduardo consulta o Músculo ao vivo se necessário
- Artefato final entregue em PDF + MD

---

## PRECIFICAÇÃO

| Tier | Escopo | Valor |
|---|---|---|
| **Diagnóstico Rápido** | 1 problema · 1 decisão · 24h | R$ 1.500 |
| **Deliberação Completa** | Discovery 7 perguntas · 7 blocos · 48h | R$ 3.000 |
| **Deliberação Executiva** | Discovery + Arquitetura Técnica + Plano 90 dias | R$ 5.000 |

**Critério de upgrade:** se o cliente pede código após a deliberação → PROJ-00X inicia com desconto de R$ 1.000 (o Discovery já foi pago).

---

## POSICIONAMENTO COMERCIAL

**Para o cliente:**
> "Em 48 horas, um conselho de três inteligências — treinadas em dezenas de projetos reais — analisa o seu problema e entrega um plano de ação que um consultor tradicional levaria semanas para produzir."

**Argumento de valor:**
- Consultor sênior: R$ 500–800/h · 20h de análise = R$ 10.000–16.000
- Discovery do Conselho: R$ 3.000–5.000 · 48h · sem overhead de agenda

**Quando vender:**
- Lead que não tem orçamento para projeto completo mas tem problema urgente
- Lead que precisa de clareza antes de contratar qualquer solução
- Cliente atual que quer auditar uma decisão estratégica sem novo projeto

---

## PROTEÇÃO JURÍDICA — CLÁUSULA OBRIGATÓRIA

> ⚠️ Esta cláusula deve constar em todo contrato de Discovery Product.
> Ver `QUADRILATERAL_UNIVERSAL/JURIDICO/CLAUSULA_ISENÇÃO_IA.md` (a criar)

**Rascunho base:**
> "As deliberações, diagnósticos e planos de ação entregues pela Vanguard Tech no âmbito deste serviço constituem análise consultiva baseada em inteligência artificial e na experiência do Diretor Responsável. Não configuram consultoria jurídica, financeira, contábil ou médica regulamentada. O cliente é o único responsável pelas decisões tomadas com base neste material. A Vanguard Tech não se responsabiliza por resultados comerciais, perdas financeiras ou danos decorrentes da implementação ou não-implementação das recomendações contidas no artefato entregue."

---

## ARTEFATO FINAL — ESTRUTURA OBRIGATÓRIA

```markdown
# DELIBERAÇÃO DO CONSELHO IAH
**Cliente:** [Nome]
**Data:** [YYYY-MM-DD]
**Conselho:** Músculo (Claude) · Estrategista (Gemini) · Auditor (NotebookLM)
**Diretor Responsável:** Eduardo

---

## 1. DIAGNÓSTICO DO CONSELHO
[O problema real — não o sintoma que o cliente descreveu]

## 2. MAPA DE DECISÕES
[As 5 decisões que desbloqueiam o negócio — cada uma com ENTRA/V2/DESCARTADO]

## 3. ARQUITETURA DE SOLUÇÃO
[O que construir, nesta ordem, com prazo e custo real]

## 4. RISCOS OCULTOS
[O que vai falhar se não for endereçado — com evidência histórica do Auditor]

## 5. PLANO DE AÇÃO 30 DIAS
[O que fazer, quem faz, quando — formato 5W2H]

## 6. PARECER DO AUDITOR
[O que projetos similares ensinaram — padrões de sucesso e falha]

## 7. VEREDITO DO DIRETOR
[A decisão soberana — aprovado/ajustado/vetado — com justificativa]

---
*Gerado pelo Conselho IAH · Vanguard Tech · [DATA]*
*Este artefato é confidencial e de uso exclusivo do cliente acima identificado.*
```

---

## COMO INICIAR UM DISCOVERY PRODUCT

```powershell
# 1. Criar pasta do cliente
New-Item -ItemType Directory -Path "CLIENTES\[NOME]\DISCOVERY_PRODUCT"

# 2. Copiar template de briefing
Copy-Item "QUADRILATERAL_UNIVERSAL\TEMPLATES\FASE_0__BRIEFING_DISCOVERY.md" `
          "CLIENTES\[NOME]\BRIEFING_DISCOVERY.md"

# 3. Registrar no WIP_BOARD como tipo "discovery_product"
# (atualizar CLIENTES\WIP_BOARD.json manualmente)

# 4. Após Discovery: rodar gemini_anchor_generator.ps1 e iniciar Passo 1
.\scripts\gemini_anchor_generator.ps1
```
