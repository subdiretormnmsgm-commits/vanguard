# CALIBRAÇÃO — Cowork Artifact Engine
> Registro contínuo de execuções. Fonte de aprendizado para calibração de scoring.

---

## 2026-06-13 | Frentes: F20, F22, F3, F1, F9, F5, F12, F7, F15 (20 arquivos)

| Campo | Valor |
|-------|-------|
| Arquivos lidos | 2 (BRIEFINGs) + F5 v7 (preview) |
| Nichos avaliados | 3 novos (N16, N17, N18) |
| Nichos MOVER AGORA | 3 |
| Nichos MONITORAR | 0 |
| Nichos ARQUIVADOS | 0 |
| Sinais adicionais | N01, N02, N03 (já em Biblioteca v4 pelo Embaixador) |

**Nichos aprovados para geração:** N16 · N17 · N18
**Ativos gerados:** 3 CARTÕEs + 1 Pipeline + 3 LinkedIn + 1 Instagram = 8 arquivos

**Nichos MOVER AGORA:**
- N16 — Farmacêuticos RT (score 4.4): CFF vs ANVISA — conflito estrutural permanente
- N17 — Engenheiros Acervo (score 4.6): Nova Resolução Confea + TCU + CAT
- N18 — Saúde Digital (score 4.8): 4 reguladores + responsabilidade pessoal diretor clínico

**Insight para próxima execução:**
- Scheduler do Embaixador estava disparando múltiplas versões do mesmo arquivo no dia 12/06 (F5 v7 = 7ª ativação) — verificar se foi corrigido no Loop 34
- 20 arquivos sem [LIDO] indicam acúmulo de 2 semanas — executar Engine semanalmente para evitar backlog
- Tripla convergência em N18 (F16+F20+F22) é o sinal mais forte do catálogo — prioridade 1 para prospecção

---

## 2026-06-22 | Frentes: F19, F21 (+ N01 sinal adicional) | Aprovados: 2 / Total: 2

**Nichos aprovados:**
- N19 — Holdings com Offshore (Lei 14.754/2023) · nicho NOVO · score 4,9 · MOVER AGORA · 4 ativos gerados (Cartão + Pipeline + LinkedIn + Instagram)
- N01 — Compliance de IA (AI Act + PL 2338) · SINAL ADICIONAL a nicho já catalogado · cartão NÃO duplicado · 3 ativos de ativação gerados (Pipeline + LinkedIn + Instagram)

**Descartados:** 0

**Insight para próxima execução:**
- GATE DE FATO evitou duplicação: Compliance de IA já era N01 da Biblioteca — sempre cruzar candidato com catálogo antes de gerar Cartão.
- Biblioteca_Nichos_Vanguard_v4.md estava CORROMPIDA (pipe-por-caractere, 50.876 pipes + escape markdown + emojis mojibake). Reparada para v4.1 sem alterar texto. Causa-raiz do encoding não identificada — monitorar se o gerador (Embaixador Agentado/Drive) reintroduz.
- PENDÊNCIA SINALIZADA AO DIRETOR: este CALIBRACAO.md tem mojibake double-encode (UTF-8 lido como Latin-1) nas entradas anteriores — requer reparo próprio, fora do escopo deste ciclo.