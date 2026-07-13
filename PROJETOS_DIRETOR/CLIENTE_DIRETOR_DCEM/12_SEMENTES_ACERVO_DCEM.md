# 12 — Sementes da Base ancoradas no ACERVO REAL · Asse Ct Orç (DCEM)

> Projeto pessoal do Diretor · isolado (P-059) · documento de DELIBERAÇÃO (P-124 — nada construído sem "vai").
> Fonte de fato (GATE DE FATO): `índice.docx` da conta soberana `orcamentariodcem@gmail.com` →
> pasta "Gestão do conhecimento" → 08 - Pareceres. Catálogo de **133 pareceres/DIEx**, assinado
> **Cel Santos, Ch Asse Ct Orç / DCEM, 02/07/2026**. Lido integralmente por Playwright/Drive em 2026-07-11.

---

## O QUE O ÍNDICE REVELA (e por que muda o desenho)

1. **Domínio único:** todo o acervo é **INDENIZAÇÃO DE MOVIMENTAÇÃO DE MILITARES**. Isso fixa o
   vocabulário controlado — não é "qualquer consulta orçamentária", é este núcleo temático.
2. **Chave natural = `Nr Ordem` (01–133).** É a numeração que o próprio Chefe já usa. Vira o
   `Anexo_Referencia` da base — zero chave inventada.
3. **O número do documento NÃO serve de chave:** DIEx nº 40 aparece em 124 e 131 (assuntos
   distintos); DIEx nº 3282 em 112 e 113. PK da NORMA VIVA continua sendo composta
   (Nr Ordem + órgão + data), nunca o nº do DIEx isolado.
4. **O índice tem o FATO, não o TÁCITO.** Ele diz o *assunto*; não diz *como se resolve rápido*
   nem *onde está a armadilha*. Essa é a camada que a base adiciona (o ativo — E-3 do Embaixador).

---

## NORMAS-SEMENTE (legislação subjacente — cada uma é uma "Norma Viva", PK)
> Existência CONFIRMADA pelo acervo. **Valores/parâmetros** entram como `[CONFIRMAR CONTRA NORMA VIGENTE]`
> (trava E-α). "Citada em" usa o Nr Ordem do acervo → `Anexo_Referencia`.

| # | Norma (âncora) | O que rege | Citada em (Nr Ordem) |
|---|---|---|---|
| N1 | **Decreto 4.307/2002** | Núcleo das indenizações de movimentação (ajuda de custo, transporte); tabela de valores | 32, 108 |
| N2 | **Portaria 290/DGP (2013)** | Regulamenta indenização de bagagem/pessoal no EB (Art. 45 = bagagem mesma sede) | 32, 102 |
| N3 | **Portaria 1.169-Cmt Ex (26/09/2014)** | Concessão de Diárias e Passagens | 27 |
| N4 | **Norma Técnica DCEM 1, 2 e 3** | IP · Movimentação motivo saúde · Recurso a ato de movimentação | 35 |
| N5 | **Portaria 881** | Guarnições categoria "A" | 36 |
| N6 | **Portaria 1.225-Cmt Ex (2010)** | Reconhecimento de Guarnições Cat "A" | 52 |
| N7 | **Portaria Normativa 86/MD (22/09/2020)** | Cursos que dão direito a adicional de habilitação | 75 |
| N8 | **Decreto 11.020/2022** | Gratificação de Localidade Especial | 94 |
| N9 | **Lei 8.112/1990** | Ajuda de custo / impossibilidade de renúncia | 115 |
| N10 | **LC 173/2020 (Art. 8º, IX)** | Reflexo sobre adicional de permanência | 73 |
| N11 | **Lei 9.784/1999 (Art. 54)** | Decadência quinquenal do ato administrativo (não corre com má-fé) | 118, 127 |
| N12 | **Decreto 20.910/1932** | Prescrição quinquenal contra a Fazenda (actio nata) | 123 |
| N13 | **Lei 6.880/1980 (Estatuto dos Militares)** | Conceito de "remuneração" | 38 |
| N14 | **Lei 6.923/1981** | Reserva remunerada | 133 |

---

## CASOS-SEMENTE (Caso-Tipo = porta de busca / índice relacional — a UX do curador)
> Consolidação dos 133 assuntos em macro-temas. Cada Caso-Tipo aponta para vários documentos do acervo.

| # | Caso-Tipo | Documentos-âncora (Nr Ordem) |
|---|---|---|
| C1 | Ajuda de custo — desligamento / prolongamento / cancelamento de curso | 01–06, 19, 24, 28, 74 |
| C2 | Ajuda de custo — militares cônjuges (mesma sede / sedes distintas / conclusão de curso) | 11, 39, 47, 71, 77, 79, 83, 119 |
| C3 | Ajuda de custo majorada — dependentes / ajuste de contas | 08, 50, 54, 55, 66, 68, 92, 101 |
| C4 | Indenização sem mudança de sede / militar já reside no local | 46, 48, 99, 100 |
| C5 | Transporte de bagagem — modalidade e alteração após ajuste de contas / mesma sede | 18, 26, 67, 86, 102, 107, 108, 110, 116, 126 |
| C6 | Transporte de pessoal / passagens (automóvel, recém-nascido, milhas) | 17, 31, 53, 72, 88, 96, 104 |
| C7 | Diárias e passagens | 15, 25, 27, 81, 95 |
| C8 | Restituição / ressarcimento ao erário — descumprimento de termo / revogação de movimentação | 30, 64, 65, 76, 84, 85, 105, 109, 111, 112, 113, 124, 130, 131 |
| C9 | Correção monetária e juros — restituição e pagamento em atraso | 37, 40, 70, 120, 125 |
| C10 | Prescrição e decadência (quinquenal; Art. 54 Lei 9.784; má-fé) | 106, 118, 123, 127 |
| C11 | Adicional de habilitação | 23, 57, 58, 59, 60, 75, 78 |
| C12 | Gratificação de representação / de localidade especial | 14, 34, 49, 56, 61, 62, 94, 132 |
| C13 | Processo de exercícios anteriores | 41, 42, 43, 44 |
| C14 | Uniformização de teses (CONJUR-MD / CONJUR-EB) — meta-tema | 110, 118, 121, 122 |

---

## FLAGS DE HIGIENE DE DADO (achados que o Auditor exige tratar antes de "base suja")

1. **112 ↔ 113 (par, não duplicata):** mesmo DIEx nº 3282, mesma data (10/JUN/25), mesma matéria
   (termo inicial/final da restituição por descumprimento de termo de compromisso), **órgãos distintos**
   (112 = Asse Ap As Jurd/DIR/DCEM · 113 = AApAJur/VCh DGP/ChCGP). Registrar como **caso relacionado**
   (par DCEM↔DGP sobre a mesma tese), não como duplicata a apagar.
2. **124 ↔ 131 (colisão de nº):** ambos "DIEx nº 40, de 6/JAN/26", **assuntos diferentes**
   (124 = restituição/reserva não remunerada; 131 = demissão a pedido / Art. 82-A). Prova viva de que
   a PK **não** pode ser o nº do documento → usar Nr Ordem + órgão + data.
3. **Mojibake nos NOMES DE ARQUIVO do Drive** (encoding UTF-8 quebrado) — o texto do índice veio limpo,
   mas os títulos dos PDFs na pasta têm caracteres corrompidos. Normalizar ao referenciar (`Anexo_Referencia`
   aponta por Nr Ordem, não pelo nome do arquivo — imune ao mojibake).

---

## COMO ISSO ENTRA NA BASE (proposta de amarração)

- A aba **NORMAS** do Gerador é semeada com N1–N14 (existência confirmada; valores travados em `[CONFIRMAR]`).
- A aba **CASOS** é semeada com C1–C14 (vocabulário controlado do dropdown de captura).
- Cada registro/Norma ganha coluna **`Anexo_Referencia`** = Nr Ordem do acervo (01–133) → link para o PDF
  na pasta soberana. A base referencia o acervo; **não** copia o PDF (biblioteca × ficha de catálogo).
- O `índice.docx` entra como **fonte-espelho** (a base é a camada de ficha+macete sobre ele).
- **Hierarquia das normas (Diretor 2026-07-11):** cada NORMA ganha `Tipo_Norma` + `Hierarquia_Nivel`
  (2=Lei Complementar · 3=Lei · 4=Decreto · 5=Portaria · 6=Norma Técnica). A resposta a uma consulta
  ordena as normas por este nível — **a inferior nunca contraria a superior**. Ex.: numa consulta que
  toca LC 173/2020 (nível 2), Lei 9.784 (3) e uma Portaria (5), a Portaria só vale no que a Lei/LC permitir.

---

## VEREDITO PENDENTE DO DIRETOR (P-124)
1. Aprova **N1–N14** como NORMAS-semente? (troca as 8 de suposição do Gerador pelas 14 do acervo)
2. Aprova **C1–C14** como CASOS-semente? (ou consolidar/enxugar algum macro-tema)
3. Confirma **`Nr Ordem` (01–133) como chave do `Anexo_Referencia`**?
4. Só após seu "vai" nesses 3 pontos + veredito dos 5 endurecimentos (E-α…E-ε) → reescrevo o
   `FASE1_GERADOR_BASE.gs` e você roda uma vez.

_Criado por: Músculo · 2026-07-11 · GATE DE FATO cumprido (índice lido do disco soberano)._
