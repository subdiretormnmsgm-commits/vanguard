# CALENDÁRIO — NICHE INTELLIGENCE REPOSITORY
> Versão 1.2 · Criado 2026-06-13 · Atualizado 2026-06-15 (+ M1–M7 fonográficas + GATE DE DATA) · Músculo
> Referência: SKILL.md v2.0 · cowork-engine-v1.md
> Horizonte: Junho–Setembro 2026 (atualizar trimestralmente)
>
> **NATUREZA DESTE CALENDÁRIO:** isto é **GESTÃO DE INTELIGÊNCIA DE MERCADO DA VANGUARD** —
> motor autônomo (Claude Cowork), dinâmico, multi-nicho. **NÃO é loop.** Loop = ciclo Pentalateral
> de projeto cliente. As frentes F1–F15 e as tarefas M1–M7 são inteligência de mercado e nunca
> devem ser rotuladas, contadas ou tratadas como etapas de loop (Diretor 2026-06-15).

---

## ⛔ GATE DE DATA — CONSULTA OBRIGATÓRIA ANTES DE QUALQUER ATIVIDADE COWORK

> Regra declarada pelo Diretor em 2026-06-15. **Bloqueante.**

**O Músculo NUNCA executa nem colhe uma atividade Cowork fora da data estipulada.**
Antes de qualquer ação ligada ao Cowork (colher briefing, atualizar Niche Model, preparar PASSO_NICHE_MODELER), o Músculo:

1. **Consulta a data de hoje** (DD-MM-YYYY + dia da semana).
2. **Cruza com este calendário** (mês → data → frentes/tarefas previstas).
3. **Age SOMENTE no que a data de hoje prevê.** Nada fora da grade.
4. Briefing **previsto e ausente** no `INBOX_COWORK` = alerta de falha do Cowork (reportar ao Diretor).
5. Briefing **presente mas não previsto** para hoje = registrar mas NÃO colher; checar a data correta na grade.

**Por isso o calendário é organizado por mês e data** (seções "CALENDÁRIO ESPECÍFICO — [MÊS]" abaixo):
a data é a única unidade de autorização. Sem data correspondente na grade → o Músculo não age.

**Ferramenta de apoio:** `.\scripts\cowork_calendar.ps1` cruza a data de hoje com este arquivo e
informa ao Músculo, na abertura (gate 0B), exatamente quais frentes/tarefas estão previstas e quais
briefings esperar. Integrada ao `session_start`.

---

## RITMO SEMANAL FIXO (recorrente — toda semana)

| Dia | Frente(s) | O que acontece | Niche Model: campos atualizados |
|---|---|---|---|
| **Segunda** | F1 + F2 + F4a + F12 | F1: Radar de Dor (07h) · F2: Análise de Oportunidades · F4a: 1ª rodada semanal · F12: Briefing Fundador | `dores[]`, `evidencias_mercado`, `narrativas.whatsapp`, `perfil_cliente` |
| **Terça** | F1 + F3 | F1: Radar de Dor (07h) · F3: Filtro de Encaixe Perfeito | `fit_score`, `status` (promoção MONITORAR→MOVER_AGORA) |
| **Quarta** | F1 + F6 | F1: Radar de Dor (07h) · F6: Radar Profundo (versão semanal intensiva) | `evidencias_mercado.dados_chave`, `gatilho_regulatorio` |
| **Quinta** | F1 + F4b | F1: Radar de Dor (07h) · F4b: 2ª rodada semanal | `narrativas.linkedin` |
| **Sexta** | F1 + F15 | F1: Radar de Dor (07h) · F15: Guardião de Promessas (semáforo) | `cadencia_cowork.[F]_ultima` (confirmar atualização da semana) |

**Regra do F1 (diário):** Todo sinal novo de F1 que impactar um nicho existente → Músculo atualiza `dores[]` ou `evidencias_mercado` do modelo correspondente no mesmo dia.

---

## RITMO QUINZENAL (dias 1 e 15 de cada mês)

| Data | Frente(s) | O que acontece | Niche Model: campos atualizados |
|---|---|---|---|
| **Dia 1** | F5 + F9 | F5: Espelho Estratégico (deriva) · F9: Radar de Fomento e Capital | `status` (revisar todos), `roi_vanguard`, `capital_nao_dilutivo` |
| **Dia 15** | F5 + F9 | Idem — segunda rodada quinzenal | `status` (validar promoções), `capital_nao_dilutivo` (novos editais FINEP/BNDES) |

---

## RITMO MENSAL (dia 1 de cada mês)

| Frente | O que acontece | Niche Model: campos atualizados | Ação Gemini |
|---|---|---|---|
| **F7** | Simulador de Objeções — novos cenários por nicho | `objecoes[]` | SIM — envia para enriquecimento |
| **F8** | Demo Visionário — roteiro/artefato por vertical | `demo_disponivel`, `roteiro_demo_arquivo` | SIM — envia para revisão |
| **F11** | Radar de Preço — benchmark do mercado | `pricing.referencia_mercado` | SIM — valida pricing Vanguard |
| **NICHE_MODELER** | Sessão única Gemini Advanced para enriquecer todos os modelos | Todos os campos — revisão completa | **SIM — SESSÃO PRINCIPAL** |

**Regra mensal:** No dia 1, após F7+F8+F11 rodarem, o Músculo prepara PASSO_NICHE_MODELER.md atualizado e o Diretor abre sessão Gemini. Output vai para PENDING_REVIEW com flag `[ALERTA]` se urgência detectada.

---

## NICHO FONOGRÁFICO — INTELIGÊNCIA DE DISCOVERY · MUMUZINHO / DUDU FÉLIX (M1–M7)

> Adicionado 2026-06-15 (Diretor). Tarefas Cowork dedicadas ao nicho MusicTech/Fonografia, agendadas
> para **preparar o discovery do PROJ-003 Mumuzinho** (decisor presumido Dudu Félix, ex-Universal Music).
> PROJ-003 está em **STANDBY** no WIP_BOARD — esta é inteligência de **NICHO**, não dados do cliente. Intencional (Diretor 2026-06-15).
> Motor: **Claude Cowork** (2º motor — roda sozinho nos horários). O Músculo **colhe**, não executa.
> Output: `INBOX_COWORK` (Drive folder `1EjaH6TmsxbYpgKWb7ASm7CohFJfwSLKi`, conta subdiretor.mnmsgm@gmail.com),
> em pares `M[n]_*` (bruto) + `BRIEFING_MUSCULO_M[n]_*` (para colher).
> Firewall: colher → `PENDING_REVIEW` (P-124, fonte+data sempre P-132) → tag `[NICHO-FONOGRAFICO]`.
> **P-059 N/A** — isto é inteligência de NICHO, não dado de cliente. Alimentará o discovery do Mumuzinho quando o PROJ-003 sair de STANDBY. Nunca direto ao MAPA DIÁRIO.

| Task | Tema | Cadência | Dia | Horário (BRT) | YouTube |
|---|---|---|---|---|---|
| **M1** | Radar de Artista | Semanal | Segunda | 03:00 | ✅ |
| **M2** | Regulatório (entretenimento) | Semanal | Terça | 03:15 | ✅ |
| **M3** | Prospecção de Holdings | Semanal | Quarta | 03:30 | ✅ |
| **M4** | ECAD + Streaming | Quinzenal | Dias 1 e 15 | 03:45 | ✅ |
| **M5** | Mercado Fonográfico | Mensal | Dia 1 | 04:00 | ✅ |
| **M6** | Licenciamento de Eventos | Quinzenal | Dias 8 e 22 | 04:15 | ✅ |
| **M7** | Concorrência Musical | Mensal | Dia 15 | 04:30 | ✅ |

### O que cai em cada dia (mapa de colheita)

| Quando | Tarefas que rodam | Músculo colhe na próxima abertura |
|---|---|---|
| **Toda segunda** | M1 | `BRIEFING_MUSCULO_M1` |
| **Toda terça** | M2 | `BRIEFING_MUSCULO_M2` |
| **Toda quarta** | M3 | `BRIEFING_MUSCULO_M3` |
| **Dia 1** | M4 + M5 (+ semanal do dia) | `BRIEFING_MUSCULO_M4`, `M5` |
| **Dia 8** | M6 (+ semanal do dia) | `BRIEFING_MUSCULO_M6` |
| **Dia 15** | M4 + M7 (+ semanal do dia) | `BRIEFING_MUSCULO_M4`, `M7` |
| **Dia 22** | M6 (+ semanal do dia) | `BRIEFING_MUSCULO_M6` |

**Regra de colheita (gate 0B):** ao abrir sessão, cruzar a data de hoje com este mapa → saber quais
`BRIEFING_MUSCULO_M[n]` esperar no `INBOX_COWORK`. Briefing esperado e ausente = alerta de falha do Cowork.

---

## CALENDÁRIO ESPECÍFICO — JUNHO 2026 (restante)

| Data | Dia | Frente(s) | Prioridade | Ação no Niche Model |
|---|---|---|---|---|
| **13/06** | Sáb | — | — | ✅ NICHE_MODELS criados (esta sessão) |
| **15/06** | Seg | F1+F2+F4a+F12 · **Fono: M1+M4+M7** | ALTA | Briefing Fundador → narrativas Licitações · colher M1/M4/M7 (fonográfico → PENDING_REVIEW [NICHO-FONOGRAFICO]) ✅ colhido |
| **16/06** | Ter | F1+F3 | ALTA | Filtro de Encaixe → validar fit_score ANVISA (prazo 180d) |
| **17/06** | Qua | F1+F6 | NORMAL | Radar profundo |
| **18/06** | Qui | F1+F4b | **⚠️ DEADLINE** | Migração plataforma Antigravity (Google) substitui Gemini Code Assist IDE — verificar IDE + nomenclatura |
| **19/06** | Sex | F1+F15 | ALTA | Guardião: confirmar atualizações da semana nos modelos |
| **22/06** | Seg | F1+F2+F4a+F12 | NORMAL | — |
| **23/06** | Ter | F1+F3 | NORMAL | — |
| **24/06** | Qua | F1+F6 | NORMAL | — |
| **25/06** | Qui | F1+F4b | NORMAL | — |
| **26/06** | Sex | F1+F15 | ALTA | Semáforo quinzenal (pré-dia 30) |
| **29/06** | Seg | F1+F2+F4a+F12 | NORMAL | — |
| **30/06** | Ter | F1+F3 | **ALTA** | Pré-revisão: preparar lista de atualizações para dia 1/jul |

---

## CALENDÁRIO ESPECÍFICO — JULHO 2026

| Data | Dia | Frente(s) | Prioridade | Ação no Niche Model |
|---|---|---|---|---|
| **01/07** | Qua | **F5+F7+F8+F9+F11+NICHE_MODELER** | **🔴 CRÍTICO** | **DIA DE ENRIQUECIMENTO MENSAL** — Sessão Gemini Advanced |
| **06/07** | Seg | F1+F2+F4a+F12 | NORMAL | — |
| **07/07** | Ter | F1+F3 | NORMAL | — |
| **08/07** | Qua | F1+F6 | NORMAL | — |
| **09/07** | Qui | F1+F4b | NORMAL | — |
| **10/07** | Sex | F1+F15 | NORMAL | — |
| **13/07** | Seg | F1+F2+F4a+F12 | NORMAL | — |
| **14/07** | Ter | F1+F3 | NORMAL | — |
| **15/07** | Qua | **F5+F9** | ALTA | **QUINZENAL** — Espelho Estratégico + Fomento |
| **16/07** | Qui | F1+F4b | NORMAL | — |
| **17/07** | Sex | F1+F15 | ALTA | Semáforo + confirmar quinzenal |
| **20/07** | Seg | F1+F2+F4a+F12 | NORMAL | — |
| **21/07** | Ter | F1+F3 | NORMAL | — |
| **22/07** | Qua | F1+F6 | NORMAL | — |
| **23/07** | Qui | F1+F4b | NORMAL | — |
| **24/07** | Sex | F1+F15 | NORMAL | — |
| **27/07** | Seg | F1+F2+F4a+F12 | NORMAL | — |
| **28/07** | Ter | F1+F3 | NORMAL | — |
| **29/07** | Qua | F1+F6 | NORMAL | Pré-revisão mensal agosto |
| **30/07** | Qui | F1+F4b | NORMAL | — |
| **31/07** | Sex | F1+F15 | ALTA | Semáforo: preparar lista agosto |

---

## CALENDÁRIO ESPECÍFICO — AGOSTO 2026

| Data | Dia | Frente(s) | Prioridade | Ação no Niche Model |
|---|---|---|---|---|
| **01/08** | Sáb | **F5+F7+F8+F9+F11+NICHE_MODELER** | **🔴 CRÍTICO** | **DIA DE ENRIQUECIMENTO MENSAL** — Sessão Gemini Advanced |
| **03/08** | Seg | F1+F2+F4a+F12 | NORMAL | — |
| **04/08** | Ter | F1+F3 | NORMAL | — |
| **05/08** | Qua | F1+F6 | NORMAL | — |
| **06/08** | Qui | F1+F4b | NORMAL | — |
| **07/08** | Sex | F1+F15 | NORMAL | — |
| **10/08** | Seg | F1+F2+F4a+F12 | NORMAL | — |
| **11/08** | Ter | F1+F3 | NORMAL | — |
| **12/08** | Qua | F1+F6 | NORMAL | — |
| **13/08** | Qui | F1+F4b | NORMAL | — |
| **14/08** | Sex | F1+F15 | NORMAL | — |
| **15/08** | Sáb | **F5+F9** | ALTA | **QUINZENAL** — Espelho + Fomento |
| **17/08** | Seg | F1+F2+F4a+F12 | NORMAL | — |
| **18/08** | Ter | F1+F3 | ALTA | **ALERTA:** prazo ANVISA 09/12 se aproxima (120 dias) |
| **19/08** | Qua | F1+F6 | NORMAL | — |
| **20/08** | Qui | F1+F4b | NORMAL | — |
| **21/08** | Sex | F1+F15 | ALTA | Semáforo: verificar ANVISA + LC 227/2026 |

---

## CALENDÁRIO ESPECÍFICO — SETEMBRO 2026

| Data | Dia | Frente(s) | Prioridade | Ação no Niche Model |
|---|---|---|---|---|
| **01/09** | Ter | **F5+F7+F8+F9+F11+NICHE_MODELER** | **🔴 CRÍTICO** | **DIA DE ENRIQUECIMENTO MENSAL** — Sessão Gemini Advanced |
| **06/09** | Dom | — | **⚠️ ALERTA** | Prova SEDES-DF (contexto Ingrid — F13) |
| **09/09** | Qua | F1+F6 | **🔴 ALERTA** | **90 dias para deadline ANVISA (09/12/2026)** — urgência máxima Rastreabilidade |
| **15/09** | Ter | **F5+F9** | ALTA | **QUINZENAL** — Espelho + Fomento |
| **30/09** | Qua | — | **⚠️ DEADLINE** | Prazo FINEP R$300M (OPP-01 F9) |

---

## AÇÕES DO GEMINI NO CICLO MENSAL

### O que o Gemini faz no NICHE_MODELER (dia 1 de cada mês):

```
1. VALIDAÇÃO — revisar fit_score de todos os 9 nichos com base nos sinais do mês
2. ENRIQUECIMENTO — completar campos com gaps (dores, objeções, pricing)
3. ALERTAS — identificar oportunidades de tempo crítico (prazo ≤ 90 dias)
4. NOVOS NICHOS — identificar se algum sinal do mês sugere nicho novo
5. MAPA DE PRIORIDADE — ranquear ordem de ataque atualizada
```

### Quando Gemini deve emitir ALERTA (formatar como seção separada):

```markdown
## [ALERTA NICHE] — [NICHO] — [DATA]
**Urgência:** CRÍTICA / ALTA / MÉDIA
**Gatilho:** [evento específico com data]
**Prazo:** [data final — ex: 09/12/2026]
**Destinatários:** Diretor + Músculo + Embaixador
**Ação imediata:** [o que o Diretor deve fazer nos próximos 7 dias]
```

### Rota do alerta:
```
Gemini output → PENDING_REVIEW.md (seção [ALERTA]) 
→ Músculo lê → extrai alertas → envia via Telegram (W-7 ou W-8)
→ Cria entrada em PENDENTES.md [diretor] com prazo
→ Embaixador informado no próximo PASSO7
```

---

## GATE: CONSULTA OBRIGATÓRIA DE NICHOS AO INICIAR PROJETO

**P-147 — NICHE_GATE (2026-06-13):**
Antes de iniciar qualquer projeto cliente (Passo 1 — Qualificação GO/NO-GO), o Músculo DEVE rodar:

```powershell
.\scripts\match_niche.ps1 -setor "[setor do prospect]" -tags "[tags do briefing]"
```

Resultado apresentado ao Diretor:
- Se **fit_score ≥ 4.5**: "Nicho mapeado — [nome]. Temos modelo completo: dores, pricing, objeções e narrativas prontos."
- Se **fit_score 3.0–4.4**: "Adjacente a [nicho]. Consultar modelo para adaptar abordagem."
- Se **sem match**: "Nicho novo. Criar NICHE_MODEL antes de avançar para PASSO 3."

**Nunca iniciar PASSO 3 (Gemini) sem consultar o repositório primeiro.**

---

## ÍNDICE DE ALERTAS REGULATÓRIOS — PRÓXIMOS 180 DIAS

| Prazo | Nicho | Evento | Dias Restantes (hoje 13/06/2026) |
|---|---|---|---|
| **18/06/2026** | Infra / Ferramenta | Migração plataforma Antigravity (Google) substitui Gemini Code Assist IDE | 5 dias |
| **21/06/2026** | Vanguard | W-8 shadow mode expira — avaliar ativação | 8 dias |
| **30/09/2026** | M&A / Capital | FINEP R$300M — prazo OPP-01 | 109 dias |
| **09/12/2026** | Rastreabilidade Sanitária | Deadline ANVISA 180 dias | 179 dias |
| Em regulamentação | Compliance Aduaneiro NCM | LC 227/2026 — prazo a definir | Acompanhar DOU |

---

## COMO MANTER ESTE CALENDÁRIO

1. **Atualizar trimestralmente** — ao início de cada trimestre, gerar novo calendário com datas específicas
2. **Após cada NICHE_MODELER** — adicionar novos alertas regulatórios detectados pelo Gemini
3. **Quando fit_score mudar** — F3 semanal pode promover/rebaixar nichos → atualizar coluna Prioridade
4. **Ferramenta:** `.\scripts\match_niche.ps1 -status MOVER_AGORA` mostra lista atual a qualquer momento
