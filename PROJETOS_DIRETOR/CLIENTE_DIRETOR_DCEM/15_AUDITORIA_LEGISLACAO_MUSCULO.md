# 15 — AUDITORIA DA CAMADA DE LEGISLAÇÃO (MÚSCULO) — independente

> **Cega em relação à auditoria do Antigravity** (`14_...`). Feita a pedido do Diretor (2026-07-12) para cruzamento consenso × divergência.
> **Fontes de disco:** `FASE1_GERADOR_BASE.gs` (abas NORMAS 143-165 + CASOS 201-220), `04_INVENTARIO_DRIVE_LEGISLACAO.md`, `08_INDICE_133_DIEX.md`.
> **GATE DE FATO:** todo número citado veio de uma dessas fontes. Onde a *amarração* proposta depende de leitura jurídica (art. específico), está marcado `[CONFIRMAR-CEL]` — a fonte existe no Drive; o encaixe legal é do curador/Cel.
> **P-124:** nada entra na planilha sem veredito.

---

## 1. QUADRO POR CASO (18 casos-semente)

| Caso | Tema | Cadeia atual | Veredito | Falta (norma superior) |
|---|---|---|---|---|
| C01 | Ajuda de custo — curso | DEC-4307 (n4) | ⚠️ incompleta | MP-2215-10 (n3) acima — a própria doutrina da base (linha 158-160) diz que sobe à MP |
| C02 | Aj. custo — cônjuges | DEC-4307 | ⚠️ incompleta | MP-2215-10 acima |
| C03 | Aj. custo majorada | DEC-4307 | ⚠️ incompleta | MP-2215-10 acima |
| C04 | Indeniz. sem mudança de sede | DEC-4307 | ⚠️ incompleta | MP-2215-10 acima (leve) |
| C05 | Transporte de bagagem | DEC-4307 + PORT-290 | ✅ **modelo correto** | (Decreto na cabeça + Portaria detalhando) |
| C06 | Transporte pessoal / passagens | DEC-4307 | 🟡 ok | refino MP-2215-10 |
| **C07** | **Diárias e passagens** | **PORT-CEX-1169 (n5) SOZINHA** | 🔴 **INVERSÃO** | Decreto/MP mãe — Portaria regulando sozinha |
| C08 | Restituição ao erário | DEC-4307 | ⚠️ incompleta | fundamento civil (Lei 10.406/CC) `[CONFIRMAR-CEL]` |
| C09 | Correção monetária / juros | DEC-4307 | ⚠️ cabeça discutível | correção nasce de CC + jurisprudência, não do Dec 4.307 `[CONFIRMAR-CEL]` |
| C10 | Prescrição e decadência | LEI-9784 + DEC-20910 | ✅ ok | (dois n3, hierarquia sã) |
| **C11** | **Adicional de habilitação** | **PN-MD-86 (n5) SOZINHA** | 🔴 **INVERSÃO** | MP-2215-10 (institui o adicional); a PN-MD só lista os cursos |
| C12a | Gratif. de representação | MP-2215-10 + DEC-4307 | 🟡 ok | MP na cabeça ✓; Dec 4.307 talvez impróprio aqui |
| C12b | Gratif. localidade especial | DEC-11020 + PORT-881 | ✅ ok | refino MP-2215-10; **falta amarrar PORT-CEX-1225 (doc 52, órfã)** |
| **C13** | **Processo de exercícios anteriores** | **VAZIO** | 🔴 **CRÍTICO** | Lei 4.320/1964 art.37 → Dec 93.872/1986 → Port DGP 410/2022 + Port C Ex 1.746/2022 `[CONFIRMAR-CEL]` |
| C14 | Uniformização de teses (meta) | VAZIO | 🟡 vazio (meta-tema) | procedimental; pode ser aceitável — sinalizar |
| **C15** | **Movimentação por saúde** | **PORT-066 + NT (n5/n6) SOZINHAS** | 🔴 **INVERSÃO** | Dec 2.040/1996 (mãe da movimentação) + Estatuto Lei 6.880 |
| C16 | Adicional de permanência | LC-173 + MP-2215-10 | ✅ ok | (n2 + n3) |
| C17 | Reserva capelão | LEI-6923 | ✅ ok | (lei específica) |

---

## 2. A PATOLOGIA DO DIRETOR — "Portaria regulando um Decreto/Lei" (inversões)

Casos onde uma **norma inferior aparece sozinha (ou como cabeça)** numa matéria cuja mãe é superior:

1. **C07 — Diárias e passagens:** só `PORT-CEX-1169-2014` (Portaria n5). Falta o Decreto/MP que institui a diária.
2. **C11 — Adicional de habilitação:** só `PN-MD-86-2020` (Portaria n5). O adicional é **instituído pela MP 2.215-10** (n3); a Portaria só define quais cursos dão direito. Clássico da inversão: a Portaria "regula" o que a MP institui.
3. **C15 — Movimentação por saúde:** só `PORT-066-DGP-2011` + `NT-DCEM` (n5/n6). A movimentação de militar nasce no **Decreto 2.040/1996** e no **Estatuto (Lei 6.880/1980)** — ambos ausentes.

## 3. CASOS VAZIOS

- **C13 — Processo de exercícios anteriores → `''`.** Confirmado o achado do Diretor. Port DGP 410/2022 **está no Drive** (`04` §2 item 23 + duplicata "portaria410 DEA") e o **Auditor já a nomeou** (`AUDITOR_BASE_DCEM_V1` N-3), mas nada entrou na semente. Ressalva de fato: os DIEx de C13 (41-44) falam de *"Processo"* de exercícios anteriores (sindicância/valores); a Port 410 está rotulada *"Despesas"* de exercícios anteriores (DEA) — pode ser a mesma matéria ou adjacente. `[CONFIRMAR-CEL]`
- **C14 — Uniformização de teses → `''`.** Meta-tema procedimental; talvez sem norma substantiva própria. Sinalizar, não necessariamente erro.

## 4. NORMAS ÓRFÃS — semeadas em NORMAS, citadas por NENHUM caso

O motor `montarEmbasamento` **nunca** vai exibir estas 5 (existem na aba NORMAS mas nenhum CASO aponta para elas):

1. **PORT-CEX-1225-2010** (reconhecimento guarnições cat "A", doc 52) → pertence a **C12b**.
2. **LEI-8112** (impossibilidade de renúncia à ajuda de custo, doc 115) → pertence à família **C01/C02/C03**.
3. **LEI-6880-1980** (Estatuto — conceito de "remuneração", doc 38) → transversal; pelo menos **C15** e família remuneratória.
4. **LEI-13954-2019** (ressarcimento de cursos, art. 97 §2º) — é *prioritária* no Drive e ficou órfã → **C01** (desligamento de curso) e um eventual caso de ressarcimento de curso.
5. **PORT-GM-MD-4044-2021** (ressarcimento de despesas com formação, base do doc 117 CHQAO) → órfã.

## 5. NORMAS NO DRIVE, VIGENTES, NÃO SEMEADAS — "a fonte existe, faltou amarrar"

O Diretor tem razão: *"botei tudo lá"*. Estas estão no `04` e não estão na aba NORMAS:

- **Decreto 2.040/1996** (`04` §1 item 9 — "movimentação") — mãe da movimentação; falta em C15. **Alta prioridade.**
- **Lei 4.320/1964** (`04` §1 item 7 — orçamento) — mãe de exercícios anteriores; falta em C13. **Alta prioridade.**
- **Port DGP 410/2022 + Port C Ex 1.746/2022** (`04` §2 itens 23 e 22 — DEA) — detalham C13.
- **Lei 10.406/2002 — Código Civil** (`04` §1 item 2) — fundamento de restituição/correção (C08/C09).

## 6. MOTOR (`montarEmbasamento`)

O motor resolve Caso → Normas_Relacionadas → acervo. Ele **só mostra o que está na coluna Normas_Relacionadas** do caso. Portanto todo buraco acima (inversão, vazio, órfã) é buraco de **dado na aba CASOS**, não de código. A Guard A-2 protege a aba NORMAS de re-seed (trabalho do curador); a aba CASOS não tem dado de curador → re-semear CASOS é seguro. Confirmação exige o veredito.

---

## 7. SÍNTESE (o tamanho real do problema)

- **3 inversões** (C07, C11, C15) + **1 vazio crítico** (C13) = **4 casos** com falha hierárquica dura.
- **5 normas órfãs** (semeadas e nunca exibidas).
- **4 normas-mãe no Drive não semeadas** (Dec 2.040, Lei 4.320, Port 410/1.746, CC 10.406).
- **Refino** (MP-2215-10 acima do Dec 4.307) em C01-C04 — a própria base já declara essa doutrina no comentário, mas não a aplicou aos casos.

**Não é "a base inteira errada".** É finito e mapeável: a varredura amarrou *parecer↔caso* (por título de DIEx) mas nunca amarrou *norma-mãe↔caso* (que mora no inventário de legislação, não no índice de DIEx). Essa é a raiz única.

**P-124 — nada disso entra na planilha sem veredito do Diretor + Cel.**
