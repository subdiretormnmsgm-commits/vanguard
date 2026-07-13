# 16 — AUDITORIA DA CAMADA DE LEGISLAÇÃO (ANTIGRAVITY EXECUTOR) — independente

> **Realojado em 2026-07-12 (P-059).** Origem: Antigravity gravou este bloco no HUB universal
> `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PENDING_REVIEW.md` (regra R-05/R-02 do firewall dele, que o impede
> de escrever no diretório do projeto). Dado de projeto pessoal NÃO permanece no HUB universal — o Músculo
> moveu para cá e removeu do HUB. Texto limpo do mojibake de encoding; conteúdo preservado fielmente.
> **Cega em relação à auditoria do Músculo** (`15_...`) — feita para cruzamento consenso × divergência.
> **Fontes declaradas pelo Antigravity:** FASE1 + FASE2 cruzados com `08_INDICE_133_DIEX.md` e `04_INVENTARIO_DRIVE_LEGISLACAO.md`.

---

## 1. MOTOR DE EMBASAMENTO (FASE2_PAINEL_CURADOR.gs)

- **Veredito: OK.**
- A função `montarEmbasamento(temaCaso)` (linha 149) executa `listaNormas.sort((a,b) => a.nivel - b.nivel)`.
  Isso garante matematicamente que o embasamento é montado do Nível 1 (Constituição) ao 6 (Norma Técnica).
  **O motor está blindado para respeitar a hierarquia.** A falha reside exclusivamente nos dados injetados pela FASE1.

---

## 2. AUDITORIA DA CADEIA NORMATIVA POR CASO-TIPO (FASE1_GERADOR_BASE.gs)

| Caso | Cadeia atual (FASE1) | Veredito | Norma(s) faltante(s) + base recomendada |
|---|---|---|---|
| **C1 a C4, C6** (Aj. custo e passagens) | `DEC-4307-2002` (n4) | 🔴 QUEBRADA | Falta instituição do direito: `MP-2215-10-2001` e `LEI-13954-2019` (n3) → `DEC-4307-2002` (n4) |
| **C5** (Bagagem) | `DEC-4307-2002; PORT-DGP-290-2013` | 🔴 QUEBRADA | Inferiores sem o superior. Falta `MP-2215-10-2001` (n3) |
| **C7** (Diárias e passagens) | `PORT-CEX-1169-2014` (n5) | 🔴 GRAVE | Só Portaria. Exige decreto e lei (ex.: Lei 8.237/91 revogada pela MP 2.215, sobre remuneração e diárias) |
| **C8 e C9** (Restituição, correção, juros) | `DEC-4307-2002` (n4) | 🔴 QUEBRADA | Assunto civil-administrativo pendurado em Decreto de movimentação. Falta `Constituição` (n1, imprescritibilidade), `Lei 10.406/2002` (CC, enriquecimento ilícito e juros), `Lei 9.784/1999` (autotutela) |
| **C10** (Prescrição/decadência) | `LEI-9784-1999; DEC-20910-1932` | 🟡 INCOMPLETA | Nível correto (3). Falta só ancorar na `Constituição` (n1, art. 37 §5) |
| **C11** (Adicional habilitação) | `PN-MD-86-2020` (n5) | 🔴 GRAVE | O direito ao adicional nasce na `MP-2215-10-2001` (n3). A portaria é só a lista de cursos |
| **C12a** (Gratif. representação) | `MP-2215-10-2001; DEC-4307-2002` | ✅ OK | Hierarquia perfeita (n3 → n4) |
| **C12b** (Gratif. loc. especial) | `DEC-11020-2022; PORT-881` | 🔴 QUEBRADA | Falta a `MP-2215-10-2001` (n3) que institui a localidade especial |
| **C13** (Exercícios anteriores) | (vazio) | 🔴 VAZIO | Adicionar `Lei 4.320/1964` (n3) |
| **C14** (Uniformização de teses) | (vazio) | 🔴 VAZIO | Adicionar `LC 73/1993` (n2, orgânica da AGU) |
| **C15** (Movimentação por saúde) | `PORT-066-DGP-2011; NT-DCEM-1-2-3` | 🔴 QUEBRADA | Exige lei/estatuto como âncora (n3) |
| **C16** (Adic. permanência) | `LC-173-2020; MP-2215-10-2001` | ✅ OK | Cadeia 2 → 3. Citação perfeita |
| **C17** (Reserva capelão) | `LEI-6923-1981` | ✅ OK | Ancorado no nível 3 |

---

## 3. AUDITORIA DO INVENTÁRIO DO DRIVE vs FASE1

**Normas órfãs** (semeadas em NORMAS, mas nenhum CASO aponta para elas em `Normas_Relacionadas`):
- `LEI-8112` — cadastrada na FASE1, mas C1-C17 ignoram.
- `LEI-6880-1980` (Estatuto dos Militares) — totalmente ignorada nos casos.
- `LEI-13954-2019` — a FASE1 afirma em comentário que amarra às Nrs 73/74/78, mas a string `Normas_Relacionadas` das linhas 201-220 não a contém. Órfã no código operacional.

**Legislação-mãe ausente do vocabulário (Drive vs FASE1):**
- **Constituição Federal** — citada no Drive, vital para C8/C10, ausente de NORMAS.
- **Lei 10.406/2002 (Código Civil)** — no Drive, essencial para juros/restituição (C8/C9), ausente de NORMAS.
- **Lei 4.320/1964** — no Drive, vital para C13, ausente.
- **LC 73/1993** — no Drive, vital para C14, ausente.

**Anomalias de número e vigência:**
- FASE1 ainda carrega flags "ano a confirmar" e "nº a confirmar" para `LEI-8112` e `LEI-6880` (linhas 152/156) — saneamento das chaves primárias pendente. Vigência `[CONFIRMAR]` aplicada mecanicamente bloqueia o uso, mas o saneamento textual da ementa está incompleto.

---

## 4. CONCLUSÃO DA AUDITORIA (Antigravity)

A taxonomia de Casos da FASE1 **quebra sistematicamente a hierarquia legal** ao ignorar a Constituição e as leis
instituidoras da remuneração militar em ~80% dos casos, pendurando a responsabilização financeira e as concessões
diretamente em Decretos (n4) ou Portarias (n5). O motor FASE2 está higienizado e ordena a hierarquia perfeitamente.
A correção é **puramente de dados/taxonomia na FASE1** — amarrar nível 3 e nível 1 nos arrays de `Normas_Relacionadas`.
