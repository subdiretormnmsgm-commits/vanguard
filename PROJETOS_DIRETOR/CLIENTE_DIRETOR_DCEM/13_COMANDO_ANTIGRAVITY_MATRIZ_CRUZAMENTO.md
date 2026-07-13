# 13 — COMANDO AO ANTIGRAVITY · Verificação da MATRIZ DE CRUZAMENTO (2ª passada)

> Projeto pessoal do Diretor · isolado (P-059) — **não** é loop Pentalateral nem inteligência de mercado.
> Fluxo fixo: este comando vai ao **chat**; o Diretor opera o Antigravity e cola a resposta de volta.
> Entrega A do projeto "Análise e confecção das respostas". Precede a construção do painel (Entrega B).
> Estratégia de qualidade: **duas análises independentes convergem.**
> 1ª passada (Claude Code, fontes de disco) → produz o **andaime** `13_MATRIZ_CRUZAMENTO_ANDAIME.md`.
> 2ª passada (Antigravity, fonte primária) → **verifica e enriquece** o andaime contra os 133 DIEx originais.
> Saída é material de DELIBERAÇÃO (P-124): o Diretor/Cel valida antes de qualquer povoamento da base.

---

## COMANDO (colar no Antigravity)

**PAPEL:** EXECUTOR — verificação documental do acervo jurídico da Asse Ct Orç / DCEM.
Abra com **@concise-planning**. Trabalho analítico, documento a documento — **não escreva código nesta etapa.**
Domínio único do acervo: **indenização de movimentação de militares.**

**SUA TAREFA NÃO É REFAZER DO ZERO.** Já existe um andaime da matriz (`13_MATRIZ_CRUZAMENTO_ANDAIME.md`) montado a partir das fontes derivadas. Seu papel é a **2ª passada independente**: conferir cada linha desse andaime contra a **fonte primária** (o `índice.docx` com os 133 DIEx) e **corrigir, completar e enriquecer** — nunca copiar cegamente.

### SUBAGENTES (use o Agent Manager — 3 papéis paralelos)
1. **Cartógrafo verificador** — confere a tabela de normas do andaime contra as normas reais citadas nos 133 DIEx; corrige nível de hierarquia, vigência e códigos.
2. **Cruzador verificador** — confere, caso a caso, se os DIEx (Nr Ordem) ligados a cada Caso-Tipo batem com o índice.docx; adiciona DIEx que o andaime não pegou.
3. **Auditor de hierarquia** (adversarial) — revê o resultado dos dois caçando: inferior contrariando superior, colisões de nº de DIEx (124↔131), pares relacionados (112↔113), termo inicial, prescrição quinquenal, e lacunas.

### FONTES (ler direto do workspace — tudo local, nada de Drive nesta passada)
- **FONTE PRIMÁRIA (agora no workspace):** **`08_INDICE_133_DIEX.md`** — transcrição fiel do `índice.docx` do Cel Santos, os 133 DIEx (Órgão · Documento · Nº · Assunto · Nr Ordem). É contra ESTE arquivo que cada linha do andaime é verificada. *(Foi materializado no workspace justamente porque a sessão do Antigravity não alcança o Drive autenticado — não perca tempo tentando o Drive.)*
- **Andaime a verificar:** `13_MATRIZ_CRUZAMENTO_ANDAIME.md`.
- **Apoio (fontes derivadas):** `04_INVENTARIO_DRIVE_LEGISLACAO.md`, `12_SEMENTES_ACERVO_DCEM.md`, `FASE1_GERADOR_BASE.gs`.
- **Fronteira epistêmica:** o índice é catálogo de *assuntos*, não o corpo dos pareceres. O que só o PDF do parecer responde (ex.: se MP 2.215-10 / Lei 13.954 são citadas dentro da peça; vigência de normas) → marque `[EXIGE PDF]`, não invente. Nunca valide uma linha sem tê-la conferido no `08_INDICE_133_DIEX.md`.

### REGRA DE HIERARQUIA (eixo obrigatório)
Ordene sempre as normas pela ascendência — **a inferior nunca contraria a superior.**
`1` Constituição · `2` Lei Complementar · `3` Lei / MP com força de lei (Lei 6.880/80, 9.784/99, MP 2.215-10) · `4` Decreto · `5` Portaria (290-DGP, Normativa 86/MD) · `6` Norma Técnica / Caderno — **nunca chave primária.**
Conflito: **hierarquia > recência** · **especialidade** (mesmo nível, especial vence geral) · desconsiderar dispositivo revogado · **DIEx/parecer = precedente**, não entra na hierarquia.

### PARA CADA LINHA DO ANDAIME — status de verificação
Marque uma das quatro: `✅ CONFIRMADO` (bate com a fonte) · `✏️ CORRIGIDO` (diga o quê) · `➕ ADICIONADO` (não estava no andaime) · `❓ NÃO ENCONTRADO NA FONTE` (andaime tinha, fonte não confirma). Toda correção cita o Nr Ordem / norma que a fundamenta.

### TRAVAS (não violar)
- Não inventar valores/prazos → `[CONFIRMAR CONTRA NORMA VIGENTE]`; vigência incerta → `[a confirmar]`.
- Chave do acervo = **Nr Ordem (01–133)**, nunca o nº do DIEx isolado. PK da norma = código+ano.
- Deduplicar por norma (código+ano), não por arquivo (10 grupos de duplicatas no inventário).
- Divergência andaime × fonte primária → a **fonte primária vence**, mas registre a divergência.

### SAÍDA
- Gravar em `CLIENTE_DIRETOR_DCEM/13_MATRIZ_CRUZAMENTO_V1.md`. **Não tocar** a planilha/base.
- Uma seção por Caso-Tipo: normas ordenadas por nível (com status ✅/✏️/➕/❓) + DIEx + armadilhas + lacunas.
- Dois blocos finais: **LACUNAS & CONFLITOS** e **PENDÊNCIAS [CONFIRMAR]**.
- Ao terminar, colar no chat um resumo: nº de linhas confirmadas / corrigidas / adicionadas / não encontradas + nº de lacunas.

---

## O QUE O DIRETOR FAZ
1. **Só depois** que o andaime `13_MATRIZ_CRUZAMENTO_ANDAIME.md` estiver pronto (o Músculo avisa).
2. Abrir o Antigravity (workspace do projeto DCEM) → colar o bloco **COMANDO** acima.
3. Deixar rodar; conferir o `13_MATRIZ_CRUZAMENTO_V1.md` gerado.
4. Colar o **resumo final** de volta aqui → o Músculo sintetiza e, com seu "vai" (P-124), povoa a base e parte pro painel (Entrega B).
