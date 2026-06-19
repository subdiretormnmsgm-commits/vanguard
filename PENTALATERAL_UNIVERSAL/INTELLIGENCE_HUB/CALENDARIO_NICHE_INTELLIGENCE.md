# CALENDÁRIO — NICHE INTELLIGENCE REPOSITORY
> Versão 1.5 · Criado 2026-06-13 · Atualizado 2026-06-18 (v1.3: entrelaçado à AGENDA VANGUARD oficial: F2/F4a/F4b/F6 descontinuadas · F3→Sexta · F15→Segunda · +ROD +BIB. v1.4: classificação A/B das ativações Projetista/Embaixador Digital derivada dos system prompts — Categoria A=frente Cowork automática, Categoria B=comando manual; só B notifica; textos em scripts/comandos_ativacao_atores.json. **v1.5: GATE DE DEPENDÊNCIA Projetista→Embaixador Digital — esteira, não atores diários independentes; `trabalhar [nicho]` travado até Projetista entregar plano**) · Músculo
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

## RITMO SEMANAL FIXO — EMBAIXADOR AGENTADO (automático Cowork · o Músculo COLHE)

> Alinhado à AGENDA VANGUARD oficial (Embaixador Agentado, 2026-06-17). **F2, F4a, F4b e F6 foram
> descontinuadas** (não constam mais da agenda). **F3** migrou de Terça → **Sexta** (consolidação).
> **F15** migrou de Sexta → **Segunda**. **ROD** (rodízio caça F16–F22) adicionado à Segunda.

| Dia | Frente(s) | O que acontece | Niche Model: campos atualizados |
|---|---|---|---|
| **Segunda** | F1 + F12 + F15 + ROD | F1: Radar de Dor (07h05) · F12: Tutor do Fundador (08h03) · F15: Guardião de Dependências (08h05) · ROD: Rodízio Caça F16–F22 (16h03) | `dores[]`, `evidencias_mercado`, `narrativas`, `cadencia_cowork.[F]_ultima` |
| **Terça** | F1 | F1: Radar de Dor (07h05) | `dores[]`, `evidencias_mercado` |
| **Quarta** | F1 | F1: Radar de Dor (07h05) | `dores[]`, `evidencias_mercado` |
| **Quinta** | F1 | F1: Radar de Dor (07h05) | `dores[]`, `evidencias_mercado` |
| **Sexta** | F1 + F3 | F1: Radar de Dor (07h05) · F3: Caçador de Encaixe — consolidação semanal (16h00) | `fit_score`, `status` (promoção MONITORAR→MOVER_AGORA) |

**Regra do F1 (diário):** Todo sinal novo de F1 que impactar um nicho existente → Músculo atualiza `dores[]` ou `evidencias_mercado` do modelo correspondente no mesmo dia. F1 roda **todos os dias** (inclusive sábado e domingo).

---

## ⚡ ATIVAÇÕES MANUAIS DO DIRETOR — PROJETISTA + EMBAIXADOR DIGITAL (Claude Projects)

> Adicionado 2026-06-17 (Diretor). Diferente do Embaixador Agentado (Cowork automático que o Músculo
> colhe), o **Projetista** e o **Embaixador Digital** são atores no **Claude Projects**.
> **Classificação A/B (derivada dos system prompts — Embaixador Digital v2.1 + Projetista v5.1, 2026-06-17):**
> os system prompts têm comandos por **tipo de sessão**, não por código ED#/P-T#. E vários ED#/P-T# são,
> na verdade, **frentes Cowork automáticas** (o prompt do Embaixador Digital declara: a pasta DIGITAL/INBOX é
> a SAÍDA das suas 6 frentes agendadas no Cowork). Logo:
>
> - **Categoria A — frente Cowork AUTOMÁTICA** (roda na madrugada, deposita em DIGITAL/INBOX ou PROJETISTA/INBOX,
>   o Diretor **NÃO ativa**): ED1, ED2, ED3, ED4, ED6 · P-T3, P-T4, P-T6.
> - **Categoria B — COMANDO DE ATIVAÇÃO MANUAL** (o Diretor **cola o comando** no Claude Project): os comandos
>   canônicos abaixo. **Só a Categoria B vira notificação** (W-11 Telegram de manhã + abertura da sessão via
>   `cowork_calendar.ps1` gate 0C). Os horários da AGENDA são teóricos — vale **quando o Diretor efetivamente ativa**.
>
> Fonte dos textos: `scripts/comandos_ativacao_atores.json` (lido pelo `cowork_calendar.ps1` e pelo W-11).

> ⛔ **GATE DE DEPENDÊNCIA — PROJETISTA ANTES DO EMBAIXADOR DIGITAL (2026-06-18, Diretor). Bloqueante.**
> Projetista e Embaixador Digital **NÃO são atores diários independentes — são uma esteira**:
> o **Projetista PROJETA** o nicho → o **Embaixador Digital OPERA** o que ele projetou → o **Diretor publica**.
> - O comando **`EMBAIXADOR DIGITAL, trabalhar [nicho]`** (e `setup inicial`) só é válido **DEPOIS** que o
>   Projetista entregou ≥1 plano em `INTELLIGENCE_HUB/PROJETISTA/PLANOS/` para aquele nicho.
> - Enquanto essa pasta estiver vazia, o Embaixador Digital só roda **`mostrar radar`** (monitoramento
>   passivo — reporta `[AGUARDA Projetista]`). Rodar o fim da esteira antes do começo = operar pipeline vazio.
> - **Causa-raiz (corrigida 2026-06-18):** o Projetista nunca havia rodado; toda a esteira estava parada na
>   origem, mas o calendário mandava ativar o Embaixador Digital todo dia. Por isso a ativação dava "nada montado".
> - **Ordem de ativação correta a cada nicho novo:** `PROJETISTA, materialização do nicho [X]` → (entrega o
>   plano) → `EMBAIXADOR DIGITAL, trabalhar [X]` → Diretor aprova (2 cliques) → publica.

**Comandos manuais (Categoria B) que o Diretor cola — por dia:**

| Dia | 🟨 Projetista — comando manual | 🟩 Embaixador Digital — comando manual |
|---|---|---|
| **Segunda** | `PROJETISTA, triagem.` (consome P-T1) | `EMBAIXADOR DIGITAL, mostrar radar.` |
| **Terça** | `PROJETISTA, nova oportunidade.` (consome P-T2) | `EMBAIXADOR DIGITAL, mostrar radar.` |
| **Quarta** | — (frentes Cowork rodam sozinhas) | `EMBAIXADOR DIGITAL, mostrar radar.` |
| **Quinta** | — | `EMBAIXADOR DIGITAL, mostrar radar.` |
| **Sexta** | `PROJETISTA, retroalimentação.` (consome P-T5) | `EMBAIXADOR DIGITAL, mostrar radar.` + `relatório de validação.` (consome ED5) |
| **Sábado / Domingo** | — | `EMBAIXADOR DIGITAL, mostrar radar.` |
| **Sob gatilho** | `materialização` (plano aprovado) · `sessão de agendamento` (lacuna / novo nicho — P-T7) | `trabalhar [nicho]` (ao escolher nicho no radar) · `setup inicial` (1ª vez) |

**Frentes Cowork automáticas (Categoria A — o Diretor NÃO ativa, documentadas para rastreio):**
ED1 (síntese diária → alimenta `radar`) · ED2 (regulatório, seg) · ED3 (concorrentes, qua) · ED4 (prospects, ter/qui) ·
ED6 (temas, dias 1 e 15) · P-T3 (diário do Projetista) · P-T4 (acervo, seg semana par) · P-T6 (pré-mortem, gatilho > R$5k).

**Persistentes (append diário):** `DIARIO_PROJETISTA.md` (P-T3, 23h02) · `DIARIO_DIGITAL.md` (ED1, 23h00) — destino INBOX_COWORK.
**Regra de notificação:** todo dia, o Músculo (via `cowork_calendar.ps1` na abertura + W-11 no Telegram) apresenta ao Diretor **o texto completo** dos comandos manuais (Categoria B) previstos para o dia, prontos para colar. **M-STATS NÃO entra** (execução interna do motor, não ativação manual).

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
| **M-STATS** | Análise Estatística de Nicho — skill `market-stats-analysis`: market sizing TAM/SAM/SOM (dupla-via, ±15%) + tendência com IC sobre o produto Vanguard mais recente | `market_sizing`, `tendencia_ic`, `pricing.referencia_mercado` | NÃO — camada analítica fria; handoff ao Projetista (R-3) |

**Regra mensal:** No dia 1, após F7+F8+F11 rodarem, o Músculo prepara PASSO_NICHE_MODELER.md atualizado e o Diretor abre sessão Gemini. Output vai para PENDING_REVIEW com flag `[ALERTA]` se urgência detectada.

**BIB — Biblioteca de Nichos (dia 12, 10h00):** atualização mensal do catálogo de nichos pelo Embaixador Agentado → `BIBLIOTECA_NICHOS_v[X]_[data].md` no INBOX_COWORK. Roda em **dia 12** (não dia 1) — o Músculo colhe na abertura do dia 12.

**M-STATS (engrenagem analítica transversal, dia 1 + sob demanda) — DOIS PASSOS distintos.** Protocolo completo em `MOTOR_INTELIGENCIA_NICHO.md` → "PROTOCOLO DE EXECUÇÃO M-STATS — DOIS PASSOS":
- **Passo 1 — Músculo (análise BASE):** ao processar o `INBOX_COWORK`, roda a skill `market-stats-analysis` em regime base (market sizing inicial + gate N pequeno) → parecer BASE anexado ao Cartão → `PENDING_REVIEW` (P-124).
- **Passo 2 — Executor Cowork (ROBUSTECE):** disparo mensal (dia 1) **ou** sob demanda do Projetista — pega o parecer BASE e robustece (convergência ±15%, métodos completos, IC pelo horizonte) → `PENDING_REVIEW` atualizado → handoff ao Projetista (R-3).

⚠️ **Diferente das atividades Cowork usuais:** o Passo 2 **não é pesquisa nova, não cai no `INBOX_COWORK` e não é colhido** como M1–M7/F-series. É downstream (opera sobre a BASE já depositada), analítico e transversal. O calendário só agenda o **disparo mensal**; o resto é sob demanda. **Execução interna do motor — NÃO é ativação manual do Diretor**, portanto **não entra no W-11** (refinamento do Diretor em 2026-06-16; reconfirmado 2026-06-17).

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
| **15/06** | Seg | F1+F12+F15+ROD · **Fono: M1+M4+M7** | ALTA | Briefing Fundador → narrativas Licitações · colher M1/M4/M7 (fonográfico → PENDING_REVIEW [NICHO-FONOGRAFICO]) ✅ colhido |
| **16/06** | Ter | F1 | ALTA | Filtro de Encaixe → validar fit_score ANVISA (prazo 180d) |
| **17/06** | Qua | F1 | NORMAL | Radar profundo |
| **18/06** | Qui | F1 | **⚠️ DEADLINE** | Migração plataforma Antigravity (Google) substitui Gemini Code Assist IDE — verificar IDE + nomenclatura |
| **19/06** | Sex | F1+F3 | ALTA | Guardião: confirmar atualizações da semana nos modelos |
| **22/06** | Seg | F1+F12+F15+ROD | NORMAL | — |
| **23/06** | Ter | F1 | NORMAL | — |
| **24/06** | Qua | F1 | NORMAL | — |
| **25/06** | Qui | F1 | NORMAL | — |
| **26/06** | Sex | F1+F3 | ALTA | Semáforo quinzenal (pré-dia 30) |
| **29/06** | Seg | F1+F12+F15+ROD | NORMAL | — |
| **30/06** | Ter | F1 | **ALTA** | Pré-revisão: preparar lista de atualizações para dia 1/jul |

---

## CALENDÁRIO ESPECÍFICO — JULHO 2026

| Data | Dia | Frente(s) | Prioridade | Ação no Niche Model |
|---|---|---|---|---|
| **01/07** | Qua | **F5+F7+F8+F9+F11+NICHE_MODELER** | **🔴 CRÍTICO** | **DIA DE ENRIQUECIMENTO MENSAL** — Sessão Gemini Advanced |
| **06/07** | Seg | F1+F12+F15+ROD | NORMAL | — |
| **07/07** | Ter | F1 | NORMAL | — |
| **08/07** | Qua | F1 | NORMAL | — |
| **09/07** | Qui | F1 | NORMAL | — |
| **10/07** | Sex | F1+F3 | NORMAL | — |
| **13/07** | Seg | F1+F12+F15+ROD | NORMAL | — |
| **14/07** | Ter | F1 | NORMAL | — |
| **15/07** | Qua | **F5+F9** | ALTA | **QUINZENAL** — Espelho Estratégico + Fomento |
| **16/07** | Qui | F1 | NORMAL | — |
| **17/07** | Sex | F1+F3 | ALTA | Semáforo + confirmar quinzenal |
| **20/07** | Seg | F1+F12+F15+ROD | NORMAL | — |
| **21/07** | Ter | F1 | NORMAL | — |
| **22/07** | Qua | F1 | NORMAL | — |
| **23/07** | Qui | F1 | NORMAL | — |
| **24/07** | Sex | F1+F3 | NORMAL | — |
| **27/07** | Seg | F1+F12+F15+ROD | NORMAL | — |
| **28/07** | Ter | F1 | NORMAL | — |
| **29/07** | Qua | F1 | NORMAL | Pré-revisão mensal agosto |
| **30/07** | Qui | F1 | NORMAL | — |
| **31/07** | Sex | F1+F3 | ALTA | Semáforo: preparar lista agosto |

---

## CALENDÁRIO ESPECÍFICO — AGOSTO 2026

| Data | Dia | Frente(s) | Prioridade | Ação no Niche Model |
|---|---|---|---|---|
| **01/08** | Sáb | **F5+F7+F8+F9+F11+NICHE_MODELER** | **🔴 CRÍTICO** | **DIA DE ENRIQUECIMENTO MENSAL** — Sessão Gemini Advanced |
| **03/08** | Seg | F1+F12+F15+ROD | NORMAL | — |
| **04/08** | Ter | F1 | NORMAL | — |
| **05/08** | Qua | F1 | NORMAL | — |
| **06/08** | Qui | F1 | NORMAL | — |
| **07/08** | Sex | F1+F3 | NORMAL | — |
| **10/08** | Seg | F1+F12+F15+ROD | NORMAL | — |
| **11/08** | Ter | F1 | NORMAL | — |
| **12/08** | Qua | F1 | NORMAL | — |
| **13/08** | Qui | F1 | NORMAL | — |
| **14/08** | Sex | F1+F3 | NORMAL | — |
| **15/08** | Sáb | **F5+F9** | ALTA | **QUINZENAL** — Espelho + Fomento |
| **17/08** | Seg | F1+F12+F15+ROD | NORMAL | — |
| **18/08** | Ter | F1 | ALTA | **ALERTA:** prazo ANVISA 09/12 se aproxima (120 dias) |
| **19/08** | Qua | F1 | NORMAL | — |
| **20/08** | Qui | F1 | NORMAL | — |
| **21/08** | Sex | F1+F3 | ALTA | Semáforo: verificar ANVISA + LC 227/2026 |

---

## CALENDÁRIO ESPECÍFICO — SETEMBRO 2026

| Data | Dia | Frente(s) | Prioridade | Ação no Niche Model |
|---|---|---|---|---|
| **01/09** | Ter | **F5+F7+F8+F9+F11+NICHE_MODELER** | **🔴 CRÍTICO** | **DIA DE ENRIQUECIMENTO MENSAL** — Sessão Gemini Advanced |
| **06/09** | Dom | — | **⚠️ ALERTA** | Prova SEDES-DF (contexto Ingrid — F13) |
| **09/09** | Qua | F1 | **🔴 ALERTA** | **90 dias para deadline ANVISA (09/12/2026)** — urgência máxima Rastreabilidade |
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
