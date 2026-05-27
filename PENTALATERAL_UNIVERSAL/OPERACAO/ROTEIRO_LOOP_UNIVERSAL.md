# ROTEIRO COMPLETO DO LOOP PENTALATERAL IAH — UNIVERSAL
> Versão 2.0 · 2026-05-27 · Incorpora P-037, P-045, P-067, P-075, P-077 e automações OSV-006
> Este documento substitui ROTEIRO_LOOP_PENTALATERAL.md (v1.0) como fonte canônica.
> Documento fixo — nunca depender de memória para reconstruir esta sequência.

---

## SUBSTITUIR ANTES DE USAR

| Placeholder | O que é |
|---|---|
| `[NOME]` | Nome do cliente em maiúsculas (ex: INGRID, VALDECE) |
| `[N]` | Número do loop atual (ex: 6) |
| `[N-1]` | Número do loop anterior (ex: 5) |
| `[SKILL]` | Nome exato da skill (ex: ingrid-v6) |

---

## PRÉ-REQUISITO DO LOOP — GATE P-045

> **BLOQUEANTE antes da Etapa 1.** Verificar automaticamente via `gemini_anchor_generator.ps1`.

```
[ ] MEMORIA_V[N-1]_[NOME].md existe em CLIENTES\[NOME]\HISTORICO\ ?
[ ] relatorio_evolutivo_V[N-1]_[NOME].md existe em CLIENTES\[NOME]\HISTORICO\ ?
```

Se ausentes → **Músculo gera os dois arquivos agora.** Loop [N-1] sem fechamento = Loop [N] sem contexto.

Automação: `gemini_anchor_generator.ps1` executa este gate e faz `exit 1` se arquivos ausentes (Loop > 1).

---

## ETAPA 1 — GEMINI (ESTRATEGISTA)

> Objetivo: receber a DIRETRIZ com nome de skill + [G-1 a G-5]

**Antes de abrir o Gemini:**
```powershell
.\scripts\gemini_anchor_generator.ps1 -cliente [NOME]
```
O script executa o Gate P-045, compila LEDGER + WIP + MEMORIA e copia tudo para o clipboard.

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
- Músculo atualiza WIP_BOARD: `loop_fase_atual.gemini = "OK"` + `proximo = "NotebookLM → Skill [SKILL].md"` (P-077)

---

## ETAPA 2 — NOTEBOOKLM (AUDITOR)

> Objetivo: receber a Skill `[SKILL].md` com 4 partes + [N-1 a N-5]

**Antes de ir, verificar:**
```
[ ] DIRETRIZ salva como 12_DIRETRIZ_GEMINI_V[N].txt em NOTEBOOKLM_FONTES\ ?
[ ] MANIFESTO_DE_FONTES.md existe em CLIENTES\[NOME]\NOTEBOOKLM_FONTES\ ?
    → Se não: Músculo cria antes de ir
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

**Automação ativa (P-075):**
- Salvar `[SKILL].md` na pasta `CLIENTES\[NOME]\NOTEBOOKLM_DROP\`
- `skill_watcher.ps1` valida automaticamente (`skill_parser_gate.ps1`) e instala em `.claude\skills\`
- Telegram recebe confirmação de instalação
- WIP_BOARD atualizado automaticamente: `loop_fase_atual.notebooklm = "OK"` (P-077)

**Gate P-067 (automático):**
- Skill aprovada NÃO libera o Músculo diretamente
- `skill_parser_gate.ps1` exibe: "MÚSCULO BLOQUEADO até o Embaixador reagir"
- DECISÃO SOBERANA: criar `CLIENTES\[NOME]\CLAUDE_PROJECT\SOBERANA_P067.flag` (suprime por 48h)

---

## ETAPA 3 — EMBAIXADOR (CLAUDE PROJECTS)

> Objetivo: filtrar as ideias de Gemini e Auditor com comportamento real do cliente → receber [E-1 a E-5]

**Gate P-067:** Embaixador é BLOQUEANTE. Músculo não delibera sem a reação do Embaixador.

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

**Músculo faz imediatamente ao receber output do Embaixador:**
- Atualiza WIP_BOARD: `loop_fase_atual.embaixador = "OK"` + `proximo = "Músculo → deliberação P-037"` (P-077)

---

## ETAPA 4 — MÚSCULO (CLAUDE CODE)

> Objetivo: síntese P-037 → deliberação + plano de build aprovado pelo Diretor

**Gate P-037 (BLOQUEANTE):**
Músculo executa síntese ANTES de gerar DECISOES.json.
Sequência inviolável: Embaixador→Seção D → Músculo→síntese P-037 → DECISOES.json

**O que você diz ao Músculo:**
```
/[SKILL]
```

**Músculo executa:**
1. Síntese dos 25 inputs [G+N+E+M] — deliberação 7 pontos
2. Gera `CLIENTES\[NOME]\HISTORICO\DELIBERACAO_LOOP_V[N]_[NOME].md`
3. Gera `CLIENTES\[NOME]\CLAUDE_PROJECT\DECISOES\DECISOES_[NOME]_[DATA].json`
4. Atualiza WIP_BOARD: `loop_fase_atual.musculo = "OK"` (P-077)

**Fluxo DECISOES → Veredito:**
1. `decisoes_watcher.ps1` detecta novo DECISOES_*.json → abre `render_painel.ps1` automaticamente
2. Gate P-037 em render_painel: verifica DELIBERACAO_LOOP_*.md (últimas 4h) — exit 2 se ausente
3. Diretor marca vereditos no Painel HTML → baixa VEREDITOS_*.json
4. `decisoes_watcher.ps1` detecta VEREDITOS_*.json → executa `executar_vereditos.ps1` automaticamente

---

## ETAPA 5 — FECHAMENTO DO LOOP (após build completo)

> Obrigatório antes de iniciar o próximo loop (P-045)

| # | Ação | Arquivo gerado |
|---|---|---|
| 1 | Músculo gera | `MEMORIA_V[N]_[NOME].md` em `CLIENTES\[NOME]\HISTORICO\` |
| 2 | Músculo gera | `relatorio_evolutivo_V[N]_[NOME].md` em `CLIENTES\[NOME]\HISTORICO\` |
| 3 | Músculo gera | [M-1 a M-5] — 5 ideias do Músculo para o próximo Gemini |
| 4 | Rodar | `.\scripts\session_close.ps1` |
| 5 | Wipe & Sync | NotebookLM — arrastar NOTEBOOKLM_FONTES atualizado |
| 6 | Músculo atualiza WIP_BOARD | `loops_programados[N].status = "concluido"` + `evidencia` |

> Loop sem MEMORIA + relatorio = próximo loop bloqueado (P-045, gate automático em gemini_anchor_generator).

---

## RESUMO VISUAL — 1 LINHA POR ETAPA

```
① GEMINI       → gemini_anchor_generator.ps1 [Gate P-045] · Cole MASTER + PASSO3 · Anexe MEMORIA[N-1] + relatorio[N-1] + LEDGER + WIP → DIRETRIZ + [G-1 a G-5]
② NOTEBOOKLM   → Script + Wipe&Sync + Cole COMANDO CURTO → recebe Skill · Salvar em NOTEBOOKLM_DROP/ → skill_watcher instala + atualiza WIP [P-075/P-077]
③ EMBAIXADOR   → Cole PASSO7 + [G-1 a G-5] + [N-1 a N-5] [Gate P-067] → [E-1 a E-5] + TEMPERATURA + flags
④ MÚSCULO P-037 → Síntese 25 inputs · DELIBERACAO_LOOP_V[N].md · DECISOES.json · render_painel [Gate P-037] · VEREDITOS → executar_vereditos [automático]
⑤ FECHAR       → MEMORIA_V[N] + relatorio_V[N] + session_close.ps1 → Wipe & Sync → loop seguinte desbloqueado [P-045]
```

---

## DECISÕES SOBERANAS — BYPASS DE GATES

| Gate | Flag file | Validade | Quando usar |
|---|---|---|---|
| P-067 (Embaixador bloqueante) | `CLIENTES\[NOME]\CLAUDE_PROJECT\SOBERANA_P067.flag` | 48h | Embaixador reagiu offline na sessão atual |
| P-037 (Síntese obrigatória) | `CLIENTES\[NOME]\CLAUDE_PROJECT\SOBERANA_P037.flag` | 4h | Síntese feita na sessão mas sem arquivo |
| RISCO C (MEMORIA_EMBAIXADOR) | `CLIENTES\[NOME]\CLAUDE_PROJECT\SOBERANA_EMBAIXADOR.flag` | 7 dias | Projeto novo, Embaixador ainda não ativado |

---

> Fonte canônica: `PENTALATERAL_UNIVERSAL\OPERACAO\ROTEIRO_LOOP_UNIVERSAL.md` · v2.0 · 2026-05-27
> Sincronizado via: `sync_vanguard_docs.ps1` (P-033)
