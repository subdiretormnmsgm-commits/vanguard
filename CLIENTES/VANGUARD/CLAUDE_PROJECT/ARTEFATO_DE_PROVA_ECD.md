# ARTEFATO DE PROVA — POST ECD (Loop 34)
> Criado: 2026-06-15 · Músculo · Gate E-3 (verificação factual antes de publicar)
> Regra: nenhuma afirmação factual no POST 4 vai ao ar sem entrada rastreável aqui.

---

## AFIRMAÇÕES VERIFICADAS

| # | Afirmação no post | Status | Fonte |
|---|---|---|---|
| 1 | Prazo da ECD 2026 = 30/06/2026, até 23h59min59s (horário de Brasília) | ✅ VERIFICADO | IOB; ContaAzul; ACIES |
| 2 | Refere-se ao ano-calendário de 2025 | ✅ VERIFICADO | IOB; Dattos |
| 3 | Multa por atraso = 0,02% por dia sobre a receita bruta, limitada a 1% | ✅ VERIFICADO | JUDIT; Contabilidade Financeira |
| 4 | Multa por incorreção/omissão = 5% sobre o valor omitido, limitada a 1% da receita bruta | ✅ VERIFICADO | JUDIT; IOB |
| 5 | A ECD alimenta a ECF; atrasar/errar a ECD trava a ECF (ECF prazo 31/07/2026) | ✅ VERIFICADO | ACIES; ContaJa |
| 6 | Registro I157 = "Transferência de Saldos de Plano de Contas Anterior" | ✅ VERIFICADO | Fortes; Omie; IOB |
| 7 | I157 é obrigatório quando há alteração de plano de contas (sinalizada no registro 0000) — casos típicos: troca de plano entre anos, troca de software, troca de contador/escritório | ✅ VERIFICADO | Omie; Contmatic; VRI Consulting |
| 8 | Função do I157: os saldos finais do período anterior devem corresponder aos saldos iniciais do período atual | ✅ VERIFICADO | Omie; Fortes |

---

## ⚠️ CORREÇÃO FACTUAL APLICADA (E-3 — 2ª pega da sessão)

**Erro anterior no WhatsApp do POST 4:** "divergências no registro I157 no cruzamento com a ECF".
**Por que está errado:** o I157 trata da amarração de saldos entre **planos de contas (ano anterior × ano atual)** — NÃO do cruzamento ECD×ECF. O cruzamento ECD→ECF existe (afirmação #5), mas é outro mecanismo.
**Correção:** o exemplo I157 no post deve falar de **troca de plano de contas / software / contador** e da amarração saldo-final-anterior = saldo-inicial-atual.

> 1ª pega da sessão (pelo Embaixador): "leiaute 12" era da ECF, não da ECD — já corrigido.

---

## FONTES

- Fortes Tecnologia — Registro I157 (Transferência de Saldos de Plano de Contas Anterior): https://ajuda.fortestecnologia.com.br/kb/pt-br/article/120603/
- Omie — SPED ECD: Entendendo o Registro I157 e o Relacionamento entre Planos de Contas: https://ajuda.omie.com.br/pt-BR/articles/14742470
- Contmatic — Como configurar o Registro I157 da ECD: https://autoatendimento.contmatic.com.br/hc/pt-br/articles/36080910781459
- IOB — Saldos de Balanço Anterior (ECD registro I157): https://aprendo.iob.com.br/ajudaonline/artigo.aspx?artigo=14269
- VRI Consulting — Registro I157 da ECD: https://www.vriconsulting.com.br/guias/guiasIndex.php?idGuia=677
- ACIES — ECD e ECF 2026: o prazo de 30 de junho: https://www.blog.aciescontabilidade.com.br/post/ecd-ecf-2026-prazo-junho-julho-obrigatoriedade
- IOB — ECD 2026: prazo e obrigatoriedade: https://iob.com.br/escrituracao-contabil-digital/
- JUDIT — ECD e ECF 2026: data de entrega e como evitar multas: https://judit.io/blog/guias-e-materiais/ecd-e-ecf-2026-data-de-entrega-prazo-do-sped-contabil-download-e-como-evitar-multas/
- ContaJa — ECF 2026: prazos e diferença entre ECD: https://contaja.com.br/blog/ecf-e-ecd/
