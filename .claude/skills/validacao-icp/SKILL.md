---
name: validacao-icp
description: Gera o relatório de validação de ICP (Ideal Customer Profile) da campanha LinkedIn da Vanguard, analisando qualidade dos seguidores, CTR real vs vaidade, auditoria comportamental e retroalimentação ao Projetista. Use esta skill SEMPRE que o usuário disser "relatório de validação", "validação da campanha", "como está performando", "quem está engajando", "ICP dos seguidores", "CTR dos posts", "auditoria de seguidores", "retroalimentação ao Projetista", ou quando se aproximar de 30–45 dias desde o início de uma campanha. Nunca medir curtidas como sucesso. Sempre medir porte e poder de compra do engajador.
---

# Validação de ICP — Campanha LinkedIn Vanguard

Você gera o relatório de validação a cada 30–45 dias de campanha ativa.

**A pergunta central de toda validação é uma só:**
> Os seguidores e engajamentos são os decisores certos — ou é métrica de vaidade?

Curtida de micro-empresa não vale. Silêncio de um CFO de grande porte vale muito.

---

## PRÉ-CONDIÇÃO

Antes de iniciar, identificar:
- Qual nicho está sendo validado?
- Qual o período da campanha? (data início → data atual)
- Quais dados o Diretor consegue extrair do LinkedIn Analytics?

Se o Diretor não tiver os dados em mãos → entregar **roteiro de extração** (o que acessar e onde no LinkedIn Analytics) antes de gerar o relatório.

---

## ROTEIRO DE EXTRAÇÃO (entregar se dados ausentes)

```
LinkedIn Analytics — o que coletar:

COMPANY PAGE:
1. Followers > Follower demographics > Company size
   → exportar distribuição: 1–10 / 11–50 / 51–200 / 201–500 / 501–1000 / 1001–5000 / 5000+
2. Visitors > Job function
   → quais funções estão visitando a page?
3. Posts > cada post → Impressions + Clicks + CTR + Reactions + Comments

PERFIL EDUARDO:
1. Analytics > Post impressions (últimos 30 dias)
2. Seguidores novos no período
3. Para cada post: Impressões / Cliques no link / Reações / Comentários
4. Quem salvou o post (se visível)

PROSPECÇÃO:
1. Taxa de aceite das conexões enviadas
2. Taxa de resposta nas mensagens 1, 2 e 3
3. Quantos chegaram à Mensagem 3 (qualificação)
```

---

## ANÁLISE 1 — ICP DOS SEGUIDORES (porte de empresa)

**A curva saudável para a Vanguard** (vende B2B institucional):

| Porte | Sinal saudável | Sinal de alerta |
|-------|---------------|-----------------|
| 1–10 (micro) | ≤ 15% | > 40% → posicionamento varejista |
| 11–50 (pequena) | ≤ 20% | > 35% → linguagem acessível demais |
| 51–200 (média) | ≥ 25% | < 10% → conteúdo técnico demais |
| 201–1000 (grande) | ≥ 20% | < 5% → ainda construindo autoridade |
| 1001+ (enterprise) | ≥ 10% | < 2% → normal no início |

**Leitura:**
- Predominância em Micro + Pequena → reescrever Tagline e Sobre em linguagem mais C-level
- Crescimento em Média + Grande → campanha no caminho certo
- Qualquer seguidor Enterprise → investigar manualmente (candidato a abordagem artesanal)

---

## ANÁLISE 2 — CTR REAL vs VAIDADE

**Regra de ponderação:**

> Post com 200 curtidas e 0 cliques = vaidade.
> Post com 12 curtidas e 8 cliques de diretores = pipeline.

Para cada post do período, calcular e classificar:

```
| Post | Impressões | Reações | Cliques | CTR% | Classificação |
|------|-----------|---------|---------|------|---------------|
| [título] | X | Y | Z | Z/X% | Alta conversão / Vaidade / Engajamento qualificado |
```

**Classificação:**
- **Alta conversão:** CTR > 2% — post atingiu quem tem intenção
- **Engajamento qualificado:** reações baixas, mas comentários de ICP — vale ouro
- **Vaidade:** muitas reações, zero cliques, comentadores fora do ICP
- **Invisível:** impressões baixas — problema de SEO ou horário de publicação

**Padrão esperado por pilar:**

| Pilar | Expectativa de CTR | Expectativa de reação |
|-------|-------------------|-----------------------|
| Thought Leadership | Alto CTR, poucas curtidas | Comentários técnicos |
| Business Case | CTR médio, salvamentos | Baixa reação pública |
| Prova de competência | CTR baixo, alta reação | Compartilhamentos |

---

## ANÁLISE 3 — AUDITORIA COMPORTAMENTAL

Para cada novo seguidor que bate com o ICP (decisor + porte correto):

```
CANDIDATO À ABORDAGEM ARTESANAL:
Nome: [se visível]
Cargo: [cargo]
Empresa: [porte + setor]
Como chegou: [post X / busca / indicação]
Engajamento: [curtiu / comentou / salvou / visitou page]
Temperatura: [Frio / Morno / Quente]
Ação recomendada: [Mensagem 1 / Conectar / Aguardar]
```

**Temperatura:**
- **Frio** — seguiu mas não engajou → aguardar 2 posts antes de contatar
- **Morno** — curtiu ou comentou 1x → enviar Mensagem 1 de conexão
- **Quente** — comentou com dúvida técnica ou salvou post → contato imediato

**Regra:** nunca mais de 10 abordagens artesanais por semana. Qualidade > volume.

---

## ANÁLISE 4 — PROSPECÇÃO (taxa de conversão do funil)

```
Funil de prospecção — [período]:

Conexões enviadas:     [N]
Aceites recebidos:     [N] → Taxa de aceite: [%]
Mensagem 1 enviadas:   [N]
Respostas M1:          [N] → Taxa resposta M1: [%]
Mensagem 2 enviadas:   [N]
Respostas M2:          [N] → Taxa resposta M2: [%]
Mensagem 3 enviadas:   [N]
Reuniões agendadas:    [N] → Taxa de qualificação: [%]
```

**Benchmarks B2B LinkedIn (referência de mercado):**
- Taxa de aceite de conexão: 20–40% é saudável
- Taxa de resposta M1: 10–25%
- Taxa de qualificação (M3 → reunião): 5–15%

Abaixo dos benchmarks → identificar onde o funil vaza e recomendar ajuste na abordagem.

---

## RETROALIMENTAÇÃO AO PROJETISTA

Esta seção é obrigatória — fecha o laço do ciclo:

```
# RETROALIMENTAÇÃO — [nicho] — [período]

## O QUE CONVERTEU
[argumento / post / abordagem que gerou mais resposta do ICP]

## O QUE RESPONDEU (engajamento qualificado sem conversão ainda)
[conteúdo que atraiu o decisor certo mas ainda não gerou reunião]

## O QUE MORREU
[formato / pilar / argumento que não gerou nenhum sinal de ICP]

## AJUSTE RECOMENDADO PARA O PROJETISTA
[o que reprojetar na próxima rodada — abordagem blindada, produto, ROI]

## DADOS DE CAMPO NOVOS
[objeções reais ouvidas nas mensagens / comentários — insumo para o Projetista]
```

---

## FORMATO DE ENTREGA FINAL

```
# VALIDAÇÃO ICP — [nicho] — [período]

## ANÁLISE 1 — SEGUIDORES POR PORTE
[tabela + leitura + recomendação]

## ANÁLISE 2 — CTR vs VAIDADE
[tabela de posts + classificação + padrão por pilar]

## ANÁLISE 3 — AUDITORIA COMPORTAMENTAL
[lista de candidatos à abordagem artesanal com temperatura]

## ANÁLISE 4 — FUNIL DE PROSPECÇÃO
[tabela de conversão + benchmark + onde vaza]

## RETROALIMENTAÇÃO AO PROJETISTA
[o que converteu / respondeu / morreu + ajuste recomendado]

## RECOMENDAÇÃO FINAL
[ ] Manter posicionamento e cadência
[ ] Ajustar Tagline / Sobre (posicionamento muito varejista)
[ ] Mudar mix de pilares (mais Business Case / menos Thought Leadership)
[ ] Revisar abordagem de prospecção
[ ] Escalar para Fase 5 (mídia paga) — só se Diretor solicitar

## PRÓXIMO CICLO
Data da próxima validação: [data início + 30–45 dias]
Nicho a validar: [mesmo ou novo conforme Portão 1]
```

---

## REGRAS FINAIS

- **Nunca medir curtida como KPI principal** — o decisor B2B não curte publicamente.
- **Seguidor de micro-empresa não entra na auditoria comportamental** — fora do ICP.
- **Retroalimentação ao Projetista é obrigatória** — sem ela o ciclo não fecha.
- **Fase 5 (mídia paga) só sob ordem do Diretor** — nunca propor espontaneamente.
- **Dados ausentes** → entregar roteiro de extração antes do relatório, não omitir análise.
- **R-3 em vigor** — nenhum nome de cliente nos dados reportados ao Projetista.

