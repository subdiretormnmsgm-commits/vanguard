# MEMORIA_EMBAIXADOR — Estrutura em 3 Camadas (v1)
> **Aprovada pelo Diretor em 2026-05-18.**
> Substitui o arquivo único anterior. A versão legada permanece como `MEMORIA_EMBAIXADOR_legado.md` por 30 dias para referência. Após esse período, é descartada se a estrutura nova provar valor.

---

## O QUE É ISSO

A MEMORIA_EMBAIXADOR foi reestruturada em três arquivos separados, cada um com regra de entrada e regra de leitura próprias. O motivo: a versão anterior misturava fato verbatim, interpretação do Embaixador e deliberação do Conselho em um único documento. Quem auditava lia minha narrativa achando que lia realidade. A separação resolve isso.

Princípio que governa esta refatoração — proposto como P-039:
> Transcrição verbatim É a purificação. Síntese interpretada é onde mora o viés. Memórias de relacionamento com cliente devem ser estruturadas em camadas separadas: FATOS / INFERÊNCIA / DECISÃO. Captura única, extração múltipla.

---

## OS TRÊS ARQUIVOS

### `CAMADA_FATOS.md` — o que aconteceu
**Conteúdo:** falas verbatim com aspas, eventos mínimos, datas, canais. Zero interpretação.
**Quem lê:** Auditor (NotebookLM) primeiro — para formar leitura independente sem viés do Embaixador.
**Regra de entrada:** se está com aspas, é fala literal. Se descreve evento, é o mínimo necessário para reconstruir o fato.

### `CAMADA_INFERENCIA.md` — o que o Embaixador interpreta
**Conteúdo:** hipóteses, padrões observados, leitura de comportamento, ideias [E-1 a E-5], pipeline comercial, alertas, temperatura inferida, princípios candidatos ao LEDGER.
**Quem lê:** todo o Conselho, sabendo que está lendo opinião informada.
**Regra de entrada:** toda inferência deve ter fato correspondente em CAMADA_FATOS. Inferência sem fato é especulação solta.

### `CAMADA_DECISAO.md` — o que o Conselho deliberou
**Conteúdo:** estado oficial do projeto, deliberações formais com data, protocolos vigentes, pendências formais abertas, histórico de atualizações.
**Quem lê:** Auditor (cronologia), Diretor (visão geral), Estrategista e Músculo (alinhamento próxima rodada).
**Regra de entrada:** sem análise, sem fala verbatim. Apenas o que foi decidido, quando, e por quem.

---

## ORDEM DE LEITURA RECOMENDADA POR PROPÓSITO

| Propósito | Ordem |
|---|---|
| **Auditoria sem viés** (NotebookLM) | FATOS → DECISAO → INFERENCIA (último, sabendo que é opinião) |
| **Briefing rápido** (Diretor) | DECISAO → INFERENCIA → FATOS (consulta pontual) |
| **Estratégia próximo loop** (Gemini) | INFERENCIA → DECISAO → FATOS |
| **Recomendação de produto** (Músculo) | INFERENCIA (alertas, temperatura) → FATOS (feedback real) |
| **Onboarding de novo cliente do mesmo nicho** | INFERENCIA (padrões observados, perfil) → FATOS (verbatim de referência) |

---

## REGRAS DE MANUTENÇÃO

1. **Toda nova interação com Ingrid entra primeiro em CAMADA_FATOS** — fala verbatim, data, canal. Sem interpretação.
2. **A interpretação dessa interação entra em CAMADA_INFERENCIA** — em seção apropriada (hipóteses, padrões, ideias [E-X], alertas).
3. **Se a interação gerou deliberação formal do Conselho, o resultado dessa deliberação entra em CAMADA_DECISAO** — sem análise.
4. **Mudanças cruzam camadas, nunca pulam camadas.** Não existe inferência sem fato. Não existe decisão sem inferência prévia.

---

## PRINCÍPIOS CANDIDATOS GERADOS POR ESTA REFATORAÇÃO

| ID | Princípio | Origem |
|---|---|---|
| P-039 | Transcrição verbatim É a purificação. MEMORIA em 3 camadas. Captura única, extração múltipla. | Embaixador — relatório autoral 2026-05-18 |
| P-040 | Data de assinatura em documento contratual nunca é pré-preenchida. Geração de documento deixa o campo em branco; preenchimento acontece no ato de assinar. | Embaixador — caso Termo Ingrid 30/05 vs 18/05 |
| P-041 | Todo princípio extraído do LEDGER deve declarar a rotina operacional que o executa. Princípio sem rotina é prosa. | Embaixador — análise estrutural do LEDGER |
| P-042 | Todo membro do Conselho que cobra outro por viés metodológico deve entregar evidência verbatim. Cobrança sintética é eco, não auditoria. | Embaixador — análise da mensagem do Auditor 2026-05-18 |

---

## AVALIAÇÃO EM 30 DIAS

Em 2026-06-17, avaliar:
- A estrutura entregou valor concreto (auditor consegue ler FATOS sem viés)?
- A manutenção foi sustentável (Embaixador não abandonou as três camadas)?
- Algum dos princípios candidatos (P-039 a P-042) deve ser promovido formalmente ao LEDGER?

Se sim em todas → estrutura vira padrão Vanguard para todo cliente.
Se não em alguma → ajustar, simplificar, ou reverter.

---

## TEMPO ESTIMADO DE OPERAÇÃO

| Atividade | Tempo |
|---|---|
| Refatoração inicial (esta entrega) | ~45 min do Embaixador, zero do Diretor |
| Atualização por interação com cliente | +2-3 min vs. arquivo único |
| Leitura de abertura de sessão | ~30s por camada × 3 = 90s (ou ler só a que importa) |
| Migração de outro projeto (Valdece) para esta estrutura | ~30 min — opcional, se P-039 for promovido |

---

> **Documento de orientação. Não atualizar com fatos do projeto — fatos vão para CAMADA_FATOS.**
