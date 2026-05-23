---
name: skill-[nome-cliente]-v[X]
description: Skill do projeto [NOME DO CLIENTE] — gerada pelo Auditor (NotebookLM) para o Músculo (Claude Code). ativar ao iniciar qualquer sessão deste projeto.
---

# SKILL — [NOME DO CLIENTE / projeto]
**Gerada por:** NotebookLM (Auditor / Sócio Consultor)
**Iteração:** V[X] | **Data:** [data] | **Camada:** [1–5]

---

## CONTEXTO DO projeto

**Cliente:** [nome/nicho] | **Stack:** [tecnologias] | **Camada:** [X]
**Problema principal:** [1 frase — o que o cliente precisa de resolver]
**objetivo desta iteração:** [1 frase — o que o Músculo entrega]
**FIRE Event:** `[success_event]` — [descrição em linguagem de negócio]

---

## [CONEXÃO HISTÓRICA — Para o Músculo]

Na iteração V[X], foi construído **[módulo]** com objetivo **[Y]**.
Reutilizar a estrutura de `[arquivo:linha]` — economiza [estimativa].
Não reconstruir do zero.

Na iteração V[X], foi construído **[módulo 2]** com objetivo **[Y2]**.
Adaptar `[arquivo]` para o novo contexto — [o que muda].

O que foi construído e está descartado / não usar: [módulo] — razão: [porquê obsoleto].

---

## [PADRÃO DE SUCESSO]

O que funcionou em projetos similares:
- **[padrão 1]** → resultado: [impacto concreto]. Expandir este padrão neste projeto.
- **[padrão 2]** → resultado: [impacto]. Aplicar diretamente.

---

## [PADRÃO DE FALHA]

O que falhou antes:
- **[falha 1]** porque [razão técnica/comercial]. Evitar esta abordagem.
- **[falha 2]** porque [razão]. Alternativa validada: [o que usar em vez].

---

## [PERSPECTIVA DO SÓCIO CONSULTOR]

Baseado em [N] projetos similares ([lista de tipos]), o padrão que emerge é:

**O que sistematicamente funciona:** [insight específico com dados]
**O que sistematicamente falha:** [insight específico]
**O que este projeto tem de diferente:** [o que pode mudar o padrão]
**A abordagem com maior probabilidade de sucesso:** [recomendação concreta]
**O que o Gemini e o Claude não estão a ver:** [blind spot histórico]

Recomendação do Sócio: [abordagem específica com fundamentação]
Nível de confiança: [Alto / Médio / Baixo] — porque: [razão]

---

## CENA DE SUCESSO DO CLIENTE (P-041 — obrigatório)

> Copiar da P2 do discovery. O Músculo relê esta cena antes de cada dia de build.
> Toda decisão técnica é avaliada: "Esta decisão aproxima ou afasta da cena do cliente?" (P-044)

**Cena descrita pelo cliente:**
_______________________________________________

**Como a demo abre reproduzindo esta cena:**
_______________________________________________

---

## GATE DE VALIDAÇÃO — PROTOCOLO DE GARANTIA SOBERANA (P-042)

> Executar ANTES da demo. Documentar como artefato formal de entrega.

| Área | Query testada | Melhor sim | Latência | Status |
|---|---|---|---|---|
| [área 1] | [query] | 0.__ | __s | 🟢/🟡/🔴 |
| [área 2] | [query] | 0.__ | __s | 🟢/🟡/🔴 |
| Coringa | [query] | 0.__ | __s | 🟢/🟡/🔴 |

**Threshold aprovação:** sim ≥ 0.67 | **Latência alvo:** < 3s | **Top:** 3  
**Artefato:** `GATE_[NICHO]_[DATA].md` — entregue ao cliente no handoff como "Protocolo de Garantia Soberana"

---

## SEQUÊNCIA DE BUILD RECOMENDADA

```
MÓDULO 0 — INJECÇÕES SOBERANAS (sempre primeiro)
  0.1 Sovereign Pixel + FIRE Event: [success_event]
  0.2 Burn Rate Shield (hard-limit diário de API)
  0.3 Kill-Switch Soberano
  0.4 LGPD/GDPR
  0.5 Região Supabase: sa-east-1 (São Paulo) — obrigatório para clientes BR

Módulo 1: [nome] — [porquê prioritário]
Módulo 2: [nome] — [dependência do Módulo 1]
Módulo 3: [nome] — [risco: SIM/NÃO — se SIM: qual]
```

---

## ALERTAS CRÍTICOS

- **[alerta 1]:** [descrição + consequência se ignorado]
- **[alerta 2]:** [descrição + consequência]
- **[alerta de segurança se aplicável]:** [descrição]

---

## O QUE NÃO CONSTRUIR NESTA ITERAÇÃO

| Item | Razão para adiar |
|------|-----------------|
| [feature X] | [porquê — dependência, custo, prioridade] |
| [feature Y] | [porquê — fora de âmbito desta camada] |

---

---

## ROTEIRO DA DEMO (P-041 — estruturada na cena, não nas features)

```
Abertura: "[Cena descrita pelo cliente na P2]." — reproduzir verbalmente
Busca 1 e 2: Eduardo conduz — silêncio total durante o resultado
Busca 3: mostrar funcionalidade diferencial do nicho
Busca 4 (H-2): cliente digita sozinho — Eduardo não toca no teclado
Sovereign Playbook: "Se eu sumir, você opera em 3 passos."
Corpus_gap: "Estes [N] temas ainda não estão cobertos — V2 resolve."
Contrato: "O sistema é seu. Isso aqui só formaliza."
```

---

## CORPUS_GAP COMO SLA DO SENTINEL REPORT

> Documentar antes da demo. Entregue ao cliente como argumento de V2.

**Temas cobertos:** [N]  
**Temas pendentes (corpus_gap):** [M]  
**Gatilho de V2:** corpus ≥ 500 docs ou 30 dias de uso ativo

---

*Skill gerada pelo NotebookLM (Auditor) · PENTALATERAL IAH · V[X]*
*Atualizado 2026-05-19: P-041 (cena de sucesso) + P-042 (gate como artefato) + P-044 (demo na cena)*
*atualizar ao fechar a iteração com novos padrões identificados*
