# 13 — MATRIZ DE CRUZAMENTO · ANDAIME (1ª passada — Claude Code)

> **STATUS: RASCUNHO A VERIFICAR.** Não é matriz autoritativa. Não povoar a base a partir deste arquivo.
> Produzido pela 1ª passada (Claude Code, 3 subagentes: Cartógrafo de Normas + Cruzador de Casos + Auditor de Hierarquia adversarial), sobre as **fontes derivadas de disco** (`04_INVENTARIO`, `12_SEMENTES`, `FASE1_GERADOR_BASE.gs`). O `índice.docx` (133 DIEx originais) **não foi lido nesta passada**.
> A 2ª passada (Antigravity) verifica cada linha contra o `índice.docx` e gera `13_MATRIZ_CRUZAMENTO_V1.md`.
> Toda linha marcada `[confirmar no índice]` é hipótese a aferir na fonte primária. Nada afirma vigência (100% `[a confirmar]` — os PDFs não foram abertos).
> Material de DELIBERAÇÃO (P-124): o Diretor/Cel valida antes de qualquer povoamento.
>
> **Registro da 2ª passada (Antigravity · 2026-07-12):** travou por falta de acesso ao `índice.docx` (o Antigravity só lê o workspace local, não o Drive autenticado) → resultado 0/16 (tudo ❓, recusou-se a validar sem a fonte). **Ganho:** corroborou o achado estrutural (base `.gs` trava no nível 4) sem precisar do índice.
> **Verificação concluída por outro caminho (Claude Code · MCP Google Drive · 2026-07-12):** o Diretor autorizou ("Eu tento ler via MCP Drive") e o `índice.docx` foi lido direto do Drive (ID `1edW6vLbhZuRbXH0iLxg9D2jXPjPpAiNq`). Resultado em **`13_MATRIZ_CRUZAMENTO_V1.md`**: 16 casos conferidos, 1 correção (Nr 95), ~24 adições, Dec 11.020/2022 resolvido, Port 071-SEF removida (ruído), colisões de nº confirmadas. Este andaime está superado pelo V1.

---

## ⚠️ ACHADO CENTRAL DA AUDITORIA — A CADEIA NORMATIVA ESTÁ QUEBRADA POR BAIXO

A auditoria adversarial encontrou um problema **estrutural**, não cosmético:

1. **Leis de nível 3 amputadas das âncoras.** Os casos de ajuda de custo/transporte (C1–C6, C8, C9) ancoram **só no Decreto 4.307/2002 (nível 4)**. Mas o Decreto é *regulamento* — quem **institui** a ajuda de custo e a indenização de transporte é a **MP 2.215-10/2001 + Lei 13.954/2019 (nível 3)**. O próprio `Prompt NotebookLM` já cravava a cadeia "MP 2.215 → Lei 13.954 → Dec 4.307 → Port 290". A semente cortou os dois degraus de lei. Isso é literalmente "inferior sem o superior".

2. **A base trava a correção na captura.** No `FASE1_GERADOR_BASE.gs`, o dropdown `Norma_Chave_Primaria` lê `NORMAS!B2:B15` — só as 14 normas semeadas. **MP 2.215-10, Lei 13.954, CF/88, Código Civil, Lei 4.320 não estão na aba NORMAS → o curador é fisicamente impedido de escolhê-las como chave.** A base *força* o inferior-contra-superior.

3. **Falta o nível 1 (Constituição).** O vocabulário `Tipo_Norma` do `.gs` vai de "Lei Complementar" (2) a "Norma Técnica" (6). **Não há Constituição.** Um caso que toque o **art. 37 §5 CF** (imprescritibilidade do ressarcimento — direto em C8) não tem como ser codificado no topo.

**Consequência:** o painel "Análise e confecção das respostas" (Entrega B) precisa que a aba NORMAS seja completada com as leis de nível 1 e 3 **antes** de virar fonte de resposta — senão o curador embasa parecer com o regulamento, sem citar a lei que cria o direito. Esta é uma correção de **base**, sujeita ao seu veredito (P-124) — não toquei o `.gs`.

---

## ESCALA DE HIERARQUIA (eixo)
`1` Constituição · `2` Lei Complementar · `3` Lei / MP com força de lei / Decreto-Lei / Decreto com força de lei · `4` Decreto · `5` Portaria · `6` Norma Técnica·Caderno·Manual·Doutrina·Jurisprudência (apoio — **nunca chave primária**).
Conflito: **hierarquia > recência** · **especialidade** (mesmo nível, especial vence geral) · dispositivo revogado desconsiderado · DIEx/parecer = **precedente**, não entra na hierarquia.
Exceção sinalizada: **Súmula Vinculante** (art. 103-A CF) vincula a Administração — cita-se logo após a CF, não é apoio comum.

---

## TABELA MESTRE DE NORMAS (por nível · vigência 100% `[a confirmar]`)

| Nível | Norma | Papel no acervo | Âncora (Nr Ordem) | Origem |
|---|---|---|---|---|
| **1** | Constituição Federal 1988 (art. 37 §5 · art. 142) | topo — **ausente da base** | — | inventário; **semear** |
| **2** | LC 173/2020 (Art. 8º IX — reflexo adicional permanência) | especial | 73 | semente N10 `[confirmar]` |
| **2** | LC 73/1993 (Lei Orgânica AGU/CONJUR) | procedimental (C14) | — | inventário |
| **3** | **MP 2.215-10/2001** (institui remuneração/ajuda de custo militar) | **fundamento — hoje amputado** | — | inventário (prioritária); **semear** |
| **3** | **Lei 13.954/2019** (reestruturação) | fundamento | — | inventário (prioritária); **semear** |
| **3** | Lei 6.880/1980 (Estatuto — conceito de remuneração) | fundamento transversal | 38 | semente N13 |
| **3** | Lei 9.784/1999 (art. 53 autotutela · art. 54 decadência) | fundamento C8/C10 | 118; 127 | semente N11 ✅ |
| **3** | Dec 20.910/1932 (prescrição quinquenal Fazenda — força de lei) | fundamento C8/C10 | 123 | semente N12 ✅ |
| **3** | Lei 10.406/2002 — Código Civil (enriq. sem causa/pgto indevido) | fundamento C8/C9 | — | inventário; **semear p/ C8** |
| **3** | Lei 4.320/1964 (art. 37 — exercícios anteriores) | **âncora recomendada p/ C13** | — | inventário; **semear** |
| **3** | Lei 8.112/1990 (ajuda de custo / impossib. renúncia) | subsidiária C1 | 115 | semente N9 `[confirmar]` |
| **3** | Lei 6.923/1981 (reserva remunerada) | C8 | 133 | semente N14 `[confirmar]` |
| **3** | DL 4.657/1942 — LINDB (+ Dec 9.830/19 regulamenta) | interpretação | — | inventário |
| **4** | **Dec 4.307/2002** (núcleo das indenizações de movimentação) | regulamento — chave de C1–C6, C8, C9 | 32; 108 | semente N1 ✅ |
| **4** | Dec 2.040/1996 (movimentação — **anterior ao 4.307**) | verificar revogação | — | inventário `[confirmar vigência]` |
| **4** | Dec 11.020/2022 **ou** 11.002/2022 (Gratif. Localidade Especial) | chave C12 — **identidade em disputa** | 94 | semente N8 `[confirmar]` |
| **5** | Port DGP 290/2013 (bagagem/pessoal — Art. 45 bagagem mesma sede) | regulamento C5 | 32; 102 | semente N2 ✅ |
| **5** | Port Normativa 86/MD 2020 (cursos com direito a adicional) | **último degrau** de C11 (não é âncora) | 75 | semente N7 ✅ |
| **5** | Port Cmt Ex 1.169/2014 (diárias e passagens) | regulamento C7 | 27 | semente N3 `[confirmar]` |
| **5** | Port 881 (guarnições Cat A) | substrato C12 | 36 | semente N5 `[órgão/ano faltam]` |
| **5** | Port Cmt Ex 1.225/2010 (guarnições Cat A) | substrato C12 | 52 | semente N6 `[confirmar]` |
| **5** | +~35 portarias do catálogo §2 sem Nr Ordem | acervo de referência | — | inventário |
| **6** | NT-DCEM 1/2/3 (IP · movimentação saúde · recurso a ato) | apoio — **candidata a C15** | 35 | semente N4 `[confirmar]` |
| **6** | Cadernos · Tabelas · MTO · MCASP · Glossário · Doutrina | apoio | — | inventário |
| **6** | Jurisprudência (Súmulas STF/STJ · Teses TNU · REsp/RE) | persuasiva (Súm. Vinculante = obrigatória) | — | inventário |

---

## CRUZAMENTO POR CASO-TIPO (norma ordenada topo→base)

> `✅` = âncora confirmada na semente · `⚠️` = camada recomendada pelo auditor, **ausente da semente**, `[confirmar no índice]` · `[a semear]` = precisa entrar na aba NORMAS.

### C1 — Ajuda de custo (desligamento / prolongamento / cancelamento de curso)
- **DIEx âncora:** 01, 02, 03, 04, 05, 06, 19, 24, 28, 74 (+ órfão **115** → anexar) (+ paradigma **32**).
- **Cadeia:** ⚠️[3] MP 2.215-10/2001 · Lei 13.954/2019 · Lei 6.880/80 · Lei 8.112/90 (subsidiária) `[a semear]` → ✅[4] Dec 4.307/2002 → [5] portarias do curso → [6] NT-DCEM, Tabela de Valores.

### C2 — Ajuda de custo: militares cônjuges
- **DIEx âncora:** 11, 39, 47, 71, 77, 79, 83, 119.
- **Cadeia:** ⚠️[3] MP 2.215-10 · Lei 13.954 → ✅[4] Dec 4.307/2002 → [6] apoio.

### C3 — Ajuda de custo majorada (dependentes / ajuste de contas)
- **DIEx âncora:** 08, 50, 54, 55, 66, 68, 92, 101.
- **Cadeia:** ⚠️[3] MP 2.215-10 · Lei 13.954 → ✅[4] Dec 4.307/2002 → [6] Tabela de Valores.

### C4 — Indenização sem mudança de sede
- **DIEx âncora:** 46, 48, 99, 100.
- **Cadeia:** ⚠️[3] MP 2.215-10 · Lei 13.954 → ✅[4] Dec 4.307/2002.

### C5 — Transporte de bagagem
- **DIEx âncora:** 18, 26, 67, 86, 102, 107, 108, 110, 116, 126. (**110 compartilhado com C14** por desenho.) (+ paradigma **32**.)
- **Cadeia:** ⚠️[3] MP 2.215-10 · Lei 13.954 → ✅[4] Dec 4.307/2002 → ✅[5] Port DGP 290/2013 (Art. 45) → [6] Caderno Req. Transporte de Bagagem, Tabela de Transporte.

### C6 — Transporte de pessoal / passagens
- **DIEx âncora:** 17, 31, 53, 72, 88, 96, 104.
- **Cadeia:** ⚠️[3] MP 2.215-10 · Lei 13.954 → ✅[4] Dec 4.307/2002 → [6] Tabela de distância DSG.

### C7 — Diárias e passagens
- **DIEx âncora:** 15, 25, 27, 81, 95.
- **Cadeia:** ⚠️[3] MP 2.215-10 / Lei 13.954 (base remuneratória) `[a semear]` → [4] decreto de diárias `[confirmar no índice]` → ✅[5] Port Cmt Ex 1.169/2014. **Único caso sem Decreto no meio — âncora frágil.**

### C8 — Restituição / ressarcimento ao erário (o MAIOR)
- **DIEx âncora:** 30, 64, 65, 76, 84, 85, 105, 109, 111, **112**, **113**, **124**, 130, **131** (+ órfão **133** → avaliar).
- **Cadeia:** ⚠️[1] CF art. 37 §5 (imprescritibilidade) `[a semear]` → ⚠️[3] Código Civil (enriq. sem causa) · ✅ Lei 9.784/99 (art. 53/54) · ✅ Dec 20.910/32 → ✅[4] Dec 4.307/2002 (descumprimento de termo) → [5] Port 1.845/2022 (dano ao erário) → [6] Súmulas STJ (boa-fé/devolução), Jur. em Teses 88.
- **Armadilhas:** **112↔113** = par relacionado (DIEx 3282, mesma matéria, órgãos DCEM≠DGP — *não* duplicata). **124↔131** = colisão de nº (DIEx 40, assuntos diferentes: 124 restituição/reserva · 131 demissão a pedido Art. 82-A). **Conflito vivo:** CF art. 37 §5 (imprescritível) × Dec 20.910 (quinquenal) → recorte jurisprudencial (STF Temas 666/899).

### C9 — Correção monetária e juros
- **DIEx âncora:** 37, 40, 70, 120, 125. (**Nr Ordem 40 ≠ DIEx nº 40** de C8.)
- **Cadeia:** ⚠️[3] Código Civil (juros/correção) `[a semear]` → ✅[4] Dec 4.307/2002 → [6] Manual de Cálculos, jurisprudência de índices. *Decreto não rege juros contra a Fazenda — base é civil + jurisprudência.*

### C10 — Prescrição e decadência
- **DIEx âncora:** 106, 118, 123, 127. (**118 compartilhado com C14**.)
- **Cadeia:** ⚠️[1] CF art. 37 §5 → ✅[3] Lei 9.784/99 art. 54 · ✅ Dec 20.910/32 · Código Civil (subsidiário) → [6] Teses TNU/Súmulas (actio nata, má-fé). **Único caso já ancorado no nível correto (bom contraexemplo).** Nenhum Decreto/Portaria pode encurtar esses prazos.

### C11 — Adicional de habilitação
- **DIEx âncora:** 23, 57, 58, 59, 60, 75, 78.
- **Cadeia:** ⚠️[1] CF art. 142 §3 → ⚠️[3] **MP 2.215-10/2001 (institui o adicional — âncora HOJE ausente)** · Lei 13.954 · Lei 6.880/80 `[a semear]` → [4] decreto remuneratório `[confirmar no índice]` → ✅[5] PN-86/MD/2020 (**lista de cursos — último degrau, não a âncora**) → [6] pareceres CONJUR. **Âncora mais invertida de todas.**

### C12 — Gratificação de representação / de localidade especial
- **DIEx âncora:** 14, 34, 49, 56, 61, 62, 94, 132 (+ órfãos **36**, **52** → anexar).
- **Cadeia:** ⚠️[3] MP 2.215-10 / Lei 13.954 (instituem a gratificação) `[a semear]` → [4] **Dec 11.020 OU 11.002/2022** — `[confirmar identidade no índice]` → [5] Port 881 · Port 1.225 (guarnições Cat A). **Âncora depende de resolver o número do decreto.**

### C13 — Processo de exercícios anteriores
- **DIEx âncora:** 41, 42, 43, 44.
- **Cadeia:** ⚠️[3] **Lei 4.320/1964 art. 37 (âncora recomendada — hoje vazia)** `[a semear]` → [4] Dec 93.872/1986 `[confirmar no índice]`. **Lacuna de norma preenchida por recomendação.**

### C14 — Uniformização de teses (CONJUR-MD / CONJUR-EB) — META, transversal
- **DIEx âncora:** 110, 118, 121, 122. (**110→C5, 118→C10** por desenho.)
- **Cadeia:** procedimental — [2] LC 73/1993 (AGU/CONJUR) · Lei 9.784/99. **Não forçar âncora substantiva** — marcar `META — transversal`.

### C15 — [PROPOSTO] Movimentação por motivo de saúde / recurso a ato de movimentação
- **DIEx âncora:** **35** (órfão que ancora NT-DCEM 1/2/3). Assunto **não coberto** por C1–C14.
- **Recomendação:** criar Caso-Tipo novo. Norma: NT-DCEM (nível 6, apoio) + base legal a confirmar no índice.

### C16 — [PROPOSTO] Adicional de permanência / reflexos
- **DIEx âncora:** **73** (órfão que ancora LC 173/2020). **Permanência ≠ habilitação (C11).**
- **Recomendação:** criar Caso-Tipo novo **ou** ampliar C11 para "Adicionais". Norma: LC 173/2020 (nível 2).

---

## LACUNAS & CONFLITOS (para o Diretor decidir)

1. **Cadeia quebrada (nível 3 amputado)** — semear MP 2.215-10, Lei 13.954, Código Civil, Lei 4.320 na aba NORMAS e ligar às âncoras. **Correção de base, seu veredito.**
2. **Falta o nível 1 (CF)** no vocabulário do `.gs` — adicionar `Constituição` = nível 1.
3. **Dropdown de captura trava a chave** (`NORMAS!B2:B15`) — expandir para as normas superiores, senão o painel não deixa citar a lei correta.
4. **Identidade Dec 11.020 vs 11.002/2022** (âncora de C12) — não resolvível sem o índice.
5. **C13/C14 sem norma** — C13 → Lei 4.320/64 (recomendado); C14 → manter META transversal.
6. **Dois Casos-Tipo novos (C15 saúde, C16 permanência)** — 35 e 73 não cabem nos existentes sem distorção.
7. **28 órfãos de assunto desconhecido** — exigem o índice para classificar.
8. **Vigência 100% não aferida** — Dec 2.040/1996 (anterior ao 4.307): confirmar se revogado antes de citar.

## PENDÊNCIAS `[CONFIRMAR]` — TOP 5 que o Antigravity confirma no índice.docx
1. **Dec 11.020 vs 11.002/2022** — qual número o Nr Ordem 94 cita? (integridade da âncora de C12).
2. **MP 2.215-10 e Lei 13.954 aparecem citadas** nos pareceres de ajuda de custo/adicional? (fia as leis acima do Dec 4.307 e da PN-86).
3. **Coluna DIEx nº dos 133** — caçar colisões além de 3282 e nº40; confirmar Nr Ordem único 01–133.
4. **Assunto dos 8 órfãos-âncora** (32, 35, 36, 38, 52, 73, 115, 133) — em especial 35 e 73 (Casos novos).
5. **Vigência/identidade** de Port 071-SEF/2020 (índices 55 e 59), Port 881 (órgão/ano), Dec 2.040/1996 (revogado?).
