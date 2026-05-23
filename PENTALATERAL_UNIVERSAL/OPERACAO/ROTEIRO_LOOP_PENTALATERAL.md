# ROTEIRO COMPLETO DO LOOP PENTALATERAL IAH
> Documento fixo · Nunca depender de memória ou de outro arquivo para reconstruir esta sequência.
> Atualizar aqui quando o processo mudar. Versão: 1.0 · 2026-05-23

---

## SUBSTITUA ANTES DE USAR

| Placeholder | O que é |
|---|---|
| `[NOME]` | Nome do cliente em maiúsculas (ex: INGRID, VALDECE) |
| `[N]` | Número do loop atual (ex: 5) |
| `[N-1]` | Número do loop anterior (ex: 4) |
| `[SKILL]` | Nome exato da skill (ex: ingrid-v5) |

---

## ETAPA 1 — GEMINI (ESTRATEGISTA)
> Objetivo: receber a DIRETRIZ com nome de skill + [G-1 a G-5]

**O que você faz:**

| Ordem | Ação | Arquivo | Caminho |
|---|---|---|---|
| 1 | Cole como texto | `COMANDO_ESTRATEGISTA_MASTER_v1.md` | `PENTALATERAL_UNIVERSAL\OPERACAO\` |
| 2 | Cole como texto | `PASSO3_GEMINI.md` | `CLIENTES\[NOME]\` |
| 3 | Anexe como arquivo | `MEMORIA_V[N-1]_[NOME].md` | `CLIENTES\[NOME]\HISTORICO\` |
| 4 | Anexe como arquivo | `relatorio_evolutivo_V[N-1]_[NOME].md` | `CLIENTES\[NOME]\HISTORICO\` |
| 5 | Anexe como arquivo | `INTELLIGENCE_LEDGER.md` | raiz do projeto |
| 6 | Anexe como arquivo | `WIP_BOARD.json` | `CLIENTES\` |

**O que o Gemini entrega:**
- DIRETRIZ com blocos: REFORMULAÇÃO_DO_PROBLEMA · POSIÇÃO_ADVERSARIAL · PARA O NOTEBOOKLM · PARA O MÚSCULO · PARA O EMBAIXADOR · TRADUÇÃO_PARA_AÇÃO · [G-1 a G-5]
- Nome exato da skill (ex: `[SKILL].md`)

**Você faz imediatamente ao receber:**
- Salvar a DIRETRIZ como: `CLIENTES\[NOME]\NOTEBOOKLM_FONTES\12_DIRETRIZ_GEMINI_V[N].txt`

---

## ETAPA 2 — NOTEBOOKLM (AUDITOR)
> Objetivo: receber a Skill `[SKILL].md` com 4 partes + [N-1 a N-5]

**Antes de ir, verificar:**
```
[ ] DIRETRIZ salva como 12_DIRETRIZ_GEMINI_V[N].txt em NOTEBOOKLM_FONTES\?
[ ] MANIFESTO_DE_FONTES.md existe em CLIENTES\[NOME]\NOTEBOOKLM_FONTES\?
    → Se não: pedir ao Músculo para criar antes de ir
```

**O que você faz:**

| Ordem | Ação | Comando / Detalhe |
|---|---|---|
| 1 | Rodar o script | `.\scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME]` |
| 2 | Arrastar para NotebookLM | Ctrl+A na pasta que abriu → arrastar TUDO → **Wipe & Sync** |
| 3 | Colar no chat | Texto abaixo (COMANDO CURTO) |

**COMANDO CURTO — colar no chat do NotebookLM:**
```
Auditor, você opera no Pentalateral IAH — 5 membros ativos: Diretor, Músculo, Estrategista, Auditor e Embaixador. O Embaixador (Claude Projects) acompanha o(a) cliente [NOME] em tempo real — suas hipóteses estão em 14_MEMORIA_EMBAIXADOR.md, use como filtro de realidade antes de validar qualquer sugestão. Leia o arquivo 13_PASSO5_NOTEBOOKLM.md das fontes carregadas detalhadamente e execute todas as instruções contidas nele. Missão principal: gerar a Skill [SKILL].md — o Músculo não inicia o Loop [N] sem ela.
```

**O que o NotebookLM entrega:**
- Skill `[SKILL].md` em 4 partes (Auditoria · Sócio Consultor · Skill copiável · [N-1 a N-5])

**Você faz imediatamente ao receber:**
- Copiar o bloco da PARTE 3 (Skill copiável) → guardar para enviar ao Músculo
- Anotar as [N-1 a N-5] para levar ao Embaixador

---

## ETAPA 3 — EMBAIXADOR (CLAUDE PROJECTS)
> Objetivo: filtrar as ideias de Gemini e Auditor com comportamento real do cliente → receber [E-1 a E-5]

**O que você faz:**

| Ordem | Ação | Arquivo | Caminho |
|---|---|---|---|
| 1 | Cole como texto | `PASSO7_EMBAIXADOR.md` | `CLIENTES\[NOME]\` |
| 2 | Inclua no texto | [G-1 a G-5] da DIRETRIZ (copie da DIRETRIZ) | — |
| 3 | Inclua no texto | [N-1 a N-5] da Skill (copie da PARTE 4) | — |

> O Embaixador tem memória persistente — não precisa de anexos. Só texto colado.

**O que o Embaixador entrega (7 blocos):**
- BLOCO 1: TEMPERATURA_PONDERADA (score 0-10 — score < 6 = CHURN-WATCH)
- BLOCO 2: Hipóteses ativas (CONFIRMADA / REFUTADA / PENDENTE)
- BLOCO 3: Comportamento do cliente — esperado / surpresa / ausente
- BLOCO 4: WATCHDOG — SCOPE-WATCH + CHURN-WATCH
- BLOCO 5: [E-1 a E-5] — 5 ideias exclusivas (não síntese dos outros membros)
- BLOCO 6: Inteligência de mercado — o que o cliente revela sobre o nicho
- BLOCO 7: Próxima ação recomendada

---

## ETAPA 4 — MÚSCULO (CLAUDE CODE)
> Objetivo: deliberar + plano de build aprovado pelo Diretor

**O que você traz para o Músculo:**

| # | O que trazer | De onde vem |
|---|---|---|
| 1 | Skill `[SKILL].md` completa (PARTES 1-4) | NotebookLM — Etapa 2 |
| 2 | DIRETRIZ completa | Gemini — Etapa 1 |
| 3 | [E-1 a E-5] + flags negativos | Embaixador — Etapa 3 |

**O que você diz ao Músculo:**
```
/[SKILL]
```
O Músculo executa a skill, delibera com os 7 pontos, apresenta plano de build.

**O que o Músculo entrega:**
- Deliberação sobre cada ideia [G] + [N] + [E]
- Plano de build Dias [X-Y] com gates verificáveis
- Circuit Breaker se o prazo estiver em risco

---

## ETAPA 5 — FECHAMENTO DO LOOP (após build completo)
> Obrigatório antes de iniciar o próximo loop (P-045)

| # | Ação | Arquivo gerado |
|---|---|---|
| 1 | Músculo gera | `MEMORIA_V[N]_[NOME].md` em `CLIENTES\[NOME]\HISTORICO\` |
| 2 | Músculo gera | `relatorio_evolutivo_V[N]_[NOME].md` em `CLIENTES\[NOME]\HISTORICO\` |
| 3 | Músculo gera | [M-1 a M-5] — 5 ideias do Músculo para o próximo Gemini |
| 4 | Rodar | `.\scripts\session_close.ps1` |
| 5 | Lembrete | Wipe & Sync do NotebookLM antes do próximo loop |

> Loop sem MEMORIA + relatorio = próximo loop bloqueado (P-045).

---

## RESUMO VISUAL — 1 LINHA POR ETAPA

```
① GEMINI    → Cole MASTER + PASSO3 · Anexe MEMORIA + relatorio + LEDGER + WIP → recebe DIRETRIZ + [G-1 a G-5]
② NOTEBOOKLM → Script + Wipe&Sync + Cole COMANDO CURTO → recebe Skill [SKILL].md + [N-1 a N-5]
③ EMBAIXADOR → Cole PASSO7 + [G-1 a G-5] + [N-1 a N-5] → recebe [E-1 a E-5] + TEMPERATURA + flags
④ MÚSCULO   → Cole Skill + DIRETRIZ + [E-1 a E-5] → recebe deliberação + plano de build
⑤ FECHAR    → MEMORIA + relatorio + session_close.ps1 → loop seguinte desbloqueado
```
