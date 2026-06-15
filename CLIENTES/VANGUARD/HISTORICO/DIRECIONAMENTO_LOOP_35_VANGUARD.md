# DIRECIONAMENTO — LOOP 35 — VANGUARD

> Proposta do Músculo para o Diretor DECLARAR o objetivo na abertura (P-160). Nada aqui é decisão — é direcionamento para deliberação.
> Origem: tudo que aconteceu no Loop 34 (2026-06-14/15). O Diretor confirma, ajusta ou substitui o objetivo.

---

## 1. O QUE ACONTECEU NO LOOP 34 (1 quadro)

| Resultado esperado (intenção do Diretor) | Entregue | Lacuna |
|---|---|---|
| R1 — Company Page criada (pré-requisito do post) | ❌ não criada | aberta |
| R2 — 1º post ECD publicado | ❌ rascunho, sem página | aberta |
| R3 — 3 atores FORMALIZADOS e funcionais (Projetista, Embaixador Digital [Freeze], Detector de Deriva) | ❌ só rascunhos (system prompts que o Diretor construiu) | **aberta — núcleo** |
| R4 — Atividade AGENDADA para cada ator novo | ❌ zero | **aberta — núcleo** |
| R5 — CLAUDE.md + estrutura do Conselho atualizados | ❌ deferido (autorizado, não executado) | aberta |

**O que o Loop 34 ENTREGOU de fato:** a régua ganhou travas contra este erro (P-171 canonicidade LEDGER · P-172 síntese medida contra o objetivo · P-174–P-177 loop entrega o delta, não o BAU; ator só "pronto" com atividade agendada). É meta-estrutura. **Não é a estrutura que o Diretor pediu.**

---

## 2. O QUE A VANGUARD PRECISA AGORA (diagnóstico)

A dor declarada pelo Diretor, em 1 frase: **"Com 20 projetos não se consegue. Muitas falhas e códigos errados."**
Logo, o que a Vanguard precisa não é mais pesquisa de mercado (isso já roda via Cowork/Intel Hub — é BAU). A Vanguard precisa da **camada que permite escalar sem o caos de hoje**. Os 3 atores novos + os gates SÃO essa camada:

- **Detector de Deriva** → impede documentos do Pentalateral divergirem em silêncio (o caos que apareceu neste loop: LEDGER órfão, paths errados, "78 princípios" desatualizado).
- **Projetista** → padroniza o desenho antes do build, reduzindo "código errado".
- **Gates P-174–P-177** → garantem que cada loop entregue o delta e não recicle BAU.

Ou seja: **o delta não entregue do Loop 34 É exatamente o que a Vanguard precisa.** Não é refazer por refazer — é construir a capacidade de escala.

---

## 3. OBJETIVO PROPOSTO DO LOOP 35 (P-160 — formato "Ao final teremos X para Y")

**RECOMENDADO:**
> "Ao final do Loop 35, teremos os 3 atores formalizados e FUNCIONAIS — cada um com atividade agendada e canal de devolução de sinal — incorporados à estrutura do Conselho (8 membros + instrumentos)."

**Alternativa A (mais enxuta):** só o Detector de Deriva 100% funcional (system prompt + skill + cron + canal), deixando Projetista/Embaixador Digital para Loop 36 — entrega 1 ator de ponta a ponta em vez de 3 pela metade.

**Alternativa B (mais ampla):** os 3 atores + os 4 gates (P-174–177) construídos como scripts — fecha de vez a falha de processo. Maior, ~2 sessões.

> Recomendo a opção principal OU a Alternativa A. A B é correta mas grande para o cansaço atual.

---

## 4. RESULTADOS ESPERADOS TIPADOS (P-174 — cada um com evidência em disco)

- **R1 — Atores no canônico:** 3 system prompts em `PENTALATERAL_UNIVERSAL/CONSELHO/` (verificável: arquivos existem).
- **R2 — System prompt reconciliado:** D1–D5 corrigidos no DETECTOR_DERIVA (verificável: grep não acha path errado nem "78 princípios").
- **R3 — Skill operacional:** `doc-drift-audit.md` unificada 2 modos (verificável: skill lida).
- **R4 — Atividade agendada por ator** (P-176 — o ponto que faltou):
  - Detector de Deriva → cron/n8n: varredura de deriva documental semanal → `INTELLIGENCE_HUB/PENDING_REVIEW.md`.
  - Projetista → gatilho a confirmar após ler o system prompt em CONSELHO/ (papel exato não conhecido — pasta exclusiva).
  - Embaixador Digital → em Freeze (D1:A): formalizado como congelado, sem atividade ativa (documentar o congelamento, não criar cron).
- **R5 — Estrutura formal:** CLAUDE.md = Conselho 6→8 membros + Detector instrumento coadjuvante; DEPENDENCY_MAP + sync (verificável: hash sincronizado).
- **R6 — Canal de devolução:** todo output dos atores → PENDING_REVIEW (P-124) — declarado no system prompt de cada um.

---

## 5. FORA DE ESCOPO / BAU (P-177 — não reciclar)

- Pesquisa de mercado / nicho / ECD / dossiê de leads → já roda (Cowork/Intel Hub). Só entra se a intenção pedir explicitamente.
- Post no LinkedIn / Company Page → depende de decisão comercial do Diretor; fica como frente separada, não bloqueia a camada de escala. (Se o Diretor quiser, vira objetivo de outro loop.)
- Re-sync de docs Pentalateral desatualizados → o Detector funcional já vai detectá-los; não tratar manualmente.

---

## 6. INSUMOS ACUMULADOS QUE ALIMENTAM (do ciclo anterior)

- **M-4** (3 atores em circuito) · **N-5/D1:A** (Embaixador Digital Freeze) · system prompts já escritos pelo Diretor.
- **Intenção Obsidian** = system prompt do Detector de Deriva (já capturado) — o Detector roda como Claude Code lendo o vault, Stage 1 SEM MCP.
- **5 descompassos D1–D5** já mapeados (no `EXECUCAO_AUTORIZADA_LOOP34.md`) — entram como tarefa, não como descoberta.

---

## 7. REGRAS QUE ESTE LOOP ESTREIA (as travas do Loop 34)

- **Budget ≤90min** (P-173 proposto) — estourou, fatiar.
- **P-172** — síntese medida contra ESTE objetivo, nunca reorganizada por 1 sócio.
- **P-176** — cada sócio, ao tratar ator novo, propõe ≥1 atividade agendável. Sem isso, ideia incompleta.
- **Flag P-098 pré-criada** antes de editar CLAUDE.md (evita ciclo bloqueio/retry).
- **gate_fechamento_resultado** (a construir / manual): o Loop não fecha com R aberto sem evidência.

---

## ABERTURA DA PRÓXIMA SESSÃO — sequência de 3 passos

1. Diretor lê este direcionamento → **declara o objetivo** (escolhe seção 3: principal, A ou B).
2. Músculo grava o objetivo + R1..Rn em `LOOP_STATE.json` (gate_loop_objetivo).
3. Executa primeiro a formalização já autorizada (`EXECUCAO_AUTORIZADA_LOOP34.md`) — porque é o caminho mais curto para R1/R2/R5 — e depois constrói as atividades agendadas (R4), que é o que faltou.

---

*Direcionamento Loop 35 · montado 2026-06-15 · proposta para deliberação do Diretor.*
