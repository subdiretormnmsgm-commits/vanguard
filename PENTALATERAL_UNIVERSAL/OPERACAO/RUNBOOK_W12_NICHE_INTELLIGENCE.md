# RUNBOOK — W-12 NICHE INTELLIGENCE NOTIFIER (n8n → Telegram)

> Clone do W-11 (`vew2fonxWwiGB9uQ`) — mesma topologia, mesmos nomes de campo de retorno
> (`temAtivacao`/`textoAtivacao`/`chatId`), IF e node Telegram herdados idênticos.
> CONSTRUÍDO em 2026-06-17 (quarta-feira) — **id n8n: `dfIMwQOS6qh5EEA7`** · estado: **ATIVO**.
> Skill usada: `n8n-remote-v1` (Code = lógica pura · Telegram = httpRequest dedicado typeVersion 4.2).
> **ATIVADO em 2026-06-17 (quarta-feira) por veredito do Diretor** (após build desativado + teste de 7 datas).
> Primeiro disparo real: **2026-07-01 (quarta-feira) 07:10 BRT** → ENRIQUECIMENTO MENSAL (dias sem marco silenciam).
> Reverter (se preciso): `POST /api/v1/workflows/dfIMwQOS6qh5EEA7/deactivate`.
> ⚠️ Activate/deactivate exigem header `Content-Type: application/json` mesmo sem body (senão 415).

---

## PROPÓSITO

Notificar o Diretor no Telegram, toda manhã, **somente** quando há um **marco de inteligência de
mercado** do `CALENDARIO_NICHE_INTELLIGENCE.md` a acionar hoje. Silencia nos dias sem marco
(mesmo padrão do W-6 e do W-11). O **motor Cowork roda sozinho**; o W-12 só lembra o Diretor dos
marcos que pedem **atenção/deliberação** dele.

Diferença em relação ao W-11:
- **W-11** = atores de **ativação manual do Diretor** (Projetista Sexta+dia 1 · Embaixador Digital Segunda+dia 5).
- **W-12** = **marcos de inteligência de mercado** (Cowork / Niche Intelligence) — enriquecimento mensal, quinzenal, deadlines regulatórios.

Natureza: camada de automação (Hermes/n8n). **NÃO é loop. P-160 não se aplica.**
Cowork ≠ Loop (princípio do Diretor) — este workflow é da camada de inteligência de mercado.

---

## CADÊNCIAS (do CALENDARIO_NICHE_INTELLIGENCE.md)

| Marco | Quando notificar | Prioridade | Ação que o marco pede |
|---|---|---|---|
| **ENRIQUECIMENTO MENSAL — NICHE_MODELER** | dia 1 do mês | CRÍTICO | abrir sessão Gemini Advanced (F5+F7+F8+F9+F11) e enriquecer os 9 modelos de nicho |
| **QUINZENAL — F5+F9** | dia 15 do mês | ALTA | Espelho Estratégico (deriva) + Radar de Fomento e Capital |
| **DEADLINE FINEP R$300M (OPP-01/F9)** | D-30 / D-7 / D-1 / D-0 de 2026-09-30 | ALTA→CRÍTICO | prazo FINEP R$300M |
| **DEADLINE ANVISA 180 dias** | D-30 / D-7 / D-1 / D-0 de 2026-12-09 | ALTA→CRÍTICO | deadline ANVISA (rastreabilidade sanitária) |

> Deadlines disparam apenas nos marcos de countdown {30, 7, 1, 0} dias — não todo dia.
> Prioridade dos deadlines escala para **CRÍTICO** quando faltam ≤ 1 dia.

---

## TOPOLOGIA (5 nodes — clone do W-11)

```
Cron (10 10 * * * = 07:10 BRT)  →  Code (Calcular marcos de hoje)  →  IF (temAtivacao?)
                                                                         ├─ true  → Telegram (httpRequest 4.2)
                                                                         └─ false → NoOp (silencia)
```

- **Cron:** `10 10 * * *` (UTC) = **07:10 BRT** — 5 min depois do W-11 (07:05) para não competir.
  ⚠️ O node herdou o NOME "Cron -- 7h05 BRT" do W-11 (cosmético); o cron real é 7h10. Renomear é opcional.
- **Code:** lógica determinística pura (não lê arquivo — datas fixas no código, resiliente por design).
  Retorna `{ temAtivacao, textoAtivacao, chatId }` — **mesmos nomes do W-11** para herdar IF/Telegram sem mudança.
- **Telegram:** `httpRequest` typeVersion 4.2 → `https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage`,
  `parse_mode=Markdown`. Token/chat via env vars do container (idêntico ao W-11).
- **NoOp:** silencia nos dias sem marco.

---

## VALIDAÇÃO (2026-06-17, antes do veredito)

Lógica do Code node testada localmente (Node v24) em 7 datas simuladas — todas corretas:

| Data | Esperado | Resultado |
|---|---|---|
| 2026-06-17 (dia 17, normal) | silêncio | `temAtivacao=false` ✅ |
| 2026-07-01 (dia 1) | ENRIQUECIMENTO MENSAL [CRÍTICO] | ✅ |
| 2026-06-15 (dia 15) | QUINZENAL F5+F9 [ALTA] | ✅ |
| 2026-08-31 (D-30 FINEP) | FINEP faltam 30 dias [ALTA] | ✅ |
| 2026-09-29 (D-1 FINEP) | FINEP faltam 1 dia [CRÍTICO] | ✅ |
| 2026-12-02 (D-7 ANVISA) | ANVISA faltam 7 dias [ALTA] | ✅ |
| 2026-12-09 (D-0 ANVISA) | ANVISA faltam 0 dias [CRÍTICO] | ✅ |

Canal Telegram: node herdado idêntico do W-11 → já provado em produção.

---

## NOTAS DE CONSTRUÇÃO (n8n-remote-v1 — armadilhas PS 5.1 resolvidas)

Documentadas para reuso em futuros clones via REST API a partir de PowerShell 5.1:

1. **`ConvertTo-Json -Depth N` TRAVA** na estrutura do workflow → usar `JavaScriptSerializer`
   (`System.Web.Extensions`, `MaxJsonLength = [int]::MaxValue`).
2. **Atribuir `$node.parameters.jsCode = $string` num PSCustomObject deserializado** introduz
   ciclo `RuntimeModule` no serializador → **NÃO mutar o objeto**; serializar com o jsCode
   original e trocar por **substituição de texto no JSON** (ambos escapados pelo mesmo serializer).
3. **`@()` ACHATA arrays aninhados** → `connections` (array-of-arrays `[[{}]]`) quebra com erro
   "Expected array, received object". Usar `ArrayList.Add` + `,$al.ToArray()` (vírgula impede
   o PS de desempacotar object[] de 1 elemento). `List[object]` causa outro ciclo (`PSParameterizedProperty`) — evitar.
4. **POST cria sempre DESATIVADO**; body só pode conter `{name, nodes, connections, settings, staticData}`
   — campos read-only (`id/active/versionId/meta`) → HTTP 400.

---

## FALLBACK MANUAL (P-110, ≤ 3 passos)

Se o W-12 cair, o Músculo verifica os marcos manualmente:
1. Ler `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/CALENDARIO_NICHE_INTELLIGENCE.md`.
2. Conferir se hoje é dia 1, dia 15 ou D-{30,7,1,0} de 30/09 ou 09/12.
3. Se sim, alertar o Diretor no briefing de abertura.
