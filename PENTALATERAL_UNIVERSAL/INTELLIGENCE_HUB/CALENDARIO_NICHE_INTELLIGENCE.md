# CALENDÁRIO — NICHE INTELLIGENCE REPOSITORY
> Versão 1.0 · Criado 2026-06-13 · Músculo
> Referência: SKILL.md v2.0 · cowork-engine-v1.md
> Horizonte: Junho–Setembro 2026 (atualizar trimestralmente)

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

## CALENDÁRIO ESPECÍFICO — JUNHO 2026 (restante)

| Data | Dia | Frente(s) | Prioridade | Ação no Niche Model |
|---|---|---|---|---|
| **13/06** | Sáb | — | — | ✅ NICHE_MODELS criados (esta sessão) |
| **15/06** | Seg | F1+F2+F4a+F12 | ALTA | Briefing Fundador → atualizar narrativas Licitações |
| **16/06** | Ter | F1+F3 | ALTA | Filtro de Encaixe → validar fit_score ANVISA (prazo 180d) |
| **17/06** | Qua | F1+F6 | NORMAL | Radar profundo |
| **18/06** | Qui | F1+F4b | **⚠️ DEADLINE** | Antigravity CLI deadline — BUILD 2 Loop 34 |
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
| **18/06/2026** | Licitações | Antigravity CLI deadline (BUILD 2) | 5 dias |
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
