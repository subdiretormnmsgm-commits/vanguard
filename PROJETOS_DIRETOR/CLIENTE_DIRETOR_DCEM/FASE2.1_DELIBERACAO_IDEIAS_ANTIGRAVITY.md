# FASE 2.1 — Deliberação das 5 ideias do Antigravity (EXECUTOR) · Base Asse Ct Orç (DCEM)

> Projeto pessoal do Diretor · isolado (P-059) · documento de DELIBERAÇÃO (P-124 — nada construído sem "vai").
> Origem: o EXECUTOR-Antigravity propôs 5 ideias de amplitude junto à entrega do MVP da Fase 2.
> Autor da deliberação: Músculo · 2026-07-11. Veredito da sequência aceito pelo Diretor ("Faço conforme a sua sugestão").
> Estado: MVP da Fase 2 entregue e em implantação/teste. Estas 5 ideias NÃO entraram no MVP (SPEC puro) — são o backlog deliberado da 2.1+.

---

## Vereditos (modelo 7 pontos condensado)

| # | Ideia | Decisão | Por quê (síntese) | Custo / pré-requisito |
|---|---|---|---|---|
| 1 | **Deep-Link de Seção** (`?secao=QEMA` pré-seleciona) | **ENTRA v2.1** | Tira 1 toque + senso de pertencimento; casa com <60s. Campo fica **editável**, só pré-selecionado (link pode circular errado / consulta por outra seção). | ~10 linhas: `e.parameter` no `doGet` + `selected` no HTML. Sem coluna nova. |
| 2 | **Terminal de Resolução do Curador** (tela autenticada p/ responder + gravar parecer/macete) | **V2.1 PRIORITÁRIA** | É a peça que faz a base **encher**. Sem ela, entra dúvida e não sai conhecimento → ataca o risco "MORRE VAZIO em 90 dias" (Embaixador). Missão central: reter o tácito. | Mais cara das 5: autenticação real (só curadores) + OPSEC (`MACETE_TACITO` não vaza). Constrói ANTES de 1 e 3. |
| 3 | **Gatilho de Doutrina** (Caso-Tipo+Norma repetido N×/janela → 🚨 candidato a nota técnica) | **ENTRA v2.1** | Transforma repetição em ativo — "gestão de conhecimento a partir das dúvidas reais". | 1 coluna/sinal no PAINEL_AUDITORIA. Barato. Depois do terminal. |
| 4 | **Prioridade por Evidência** ("precisa até quando" + função) | **DESCARTADO** | Já descartado pelo Diretor em 2026-07-11 (exigiria coluna nova em REGISTROS). O EXECUTOR re-propôs sem saber do descarte. Mantido descartado salvo reabertura explícita do Diretor. | — |
| 5 | **Índice de Qualidade da Demanda** (pontua completude de cada consulta) | **V3 / CAUTELA** | Risco comportamental > ganho: vira **arma de auditoria** → demandante se sente avaliado → para de usar → base morre por inanição. Contradiz a fricção zero. | Só se o comportamento real provar que dá pra medir sem afugentar. |

---

## Sequência de build aprovada

1. **Agora:** MVP da Fase 2 no ar + teste do Diretor (em curso). Fixes A (validação de Assunto) + C (linha determinística) já aplicados em `captura_webapp.gs`.
2. **Fase 2.1:** ideia **2** (terminal do curador) primeiro → depois **1** (deep-link editável) + **3** (gatilho de doutrina).
3. **Ideia 4** descartada · **Ideia 5** só na V3.

## Fora desta deliberação (já roteirizado)
- Fase 3: motor de notificação (MailApp + `UrlFetchApp` Telegram, nativo, NÃO n8n).
- Fase 6: camada de consulta com IA (Caminho A — API externa zero-retention).

_Nada aqui é construído sem "vai" explícito por item. O MVP em teste é o único artefato vivo._
