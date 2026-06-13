# RUNBOOK — COWORK ENGINE
> Vanguard IAH · Pentalateral
> Criado: 2026-06-13 · Músculo
> Fonte canônica: `PENTALATERAL_UNIVERSAL/OPERACAO/RUNBOOK_COWORK_ENGINE.md`

---

## O QUE É O COWORK ENGINE

**Cowork Engine = motor de inteligência de mercado dinâmica da Vanguard.**

Produção contínua de inteligência sobre nichos, concorrentes e tendências — permite à Vanguard prospectar com precisão regulatória e velocidade comercial.

> ⚠️ **COWORK ≠ LOOP DO PENTALATERAL — são coisas distintas.**
> Loop = ciclo Gemini→NotebookLM→Embaixador→Músculo de projeto cliente (Ingrid, Valdece, etc.)
> Cowork = inteligência de mercado dinâmica da Vanguard como empresa

---

## MEMBROS ATIVOS NO COWORK

| Membro | Papel no Cowork |
|---|---|
| **Embaixador** | Coleta frentes de inteligência (F1–F15) via interações com mercado |
| **Antigravity IDE** | Executa sessão NICHE_MODELER — valida modelos, identifica nichos, gera narrativas |
| **Músculo** | Valida toda saída (P-124), delibera, executa aprovações, gera Resumo |
| **Diretor** | Emite veredito por item — decide o que avança |

---

## SEQUÊNCIA PADRÃO — 7 FASES

### Fase 1 — COLETA (Embaixador)

**Quem:** Embaixador agentado  
**O que:** Coleta frentes de inteligência de mercado durante interações (F1 Radar de Dor, F5 Espelho Estratégico, F7 Simulador de Objeções, F8 Demo, F9 Capital, F11 Radar de Preço, F12 Briefing, F15 Guardião de Promessas)  
**Onde salva:** Google Drive → pasta INBOX_COWORK (`1EjaH6TmsxbYpgKWb7ASm7CohFJfwSLKi`)  
**Output:** arquivos `YYYY-MM-DD_FX_nome.md` no Drive

---

### Fase 2 — VEREDITO INBOX (Músculo)

**Quem:** Músculo (via MCP Google Drive)  
**O que:** Lê cada arquivo do INBOX_COWORK, emite veredito por arquivo  
**Vereditos possíveis:**
- `APROVADO` — arquivo entra no corpus da próxima sessão NICHE_MODELER
- `STANDBY` — aguarda contexto adicional ou ordem do Diretor
- `REJEITAR` — arquivo fora do escopo ou dado inválido

**Onde registra:** `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PENDING_REVIEW.md` → seção INBOX_COWORK  
**⛔ GATE BLOQUEANTE:** sem veredito completo da INBOX, Fase 3 não começa

---

### Fase 3 — NICHE_MODELER (Antigravity COWORK CONDUCTOR)

**Quem:** Diretor ativa Antigravity IDE  
**O que:** Sessão única com Gemini 3.1 Pro High — executa as 5 tarefas do PASSO  
**Corpus:** arquivos APROVADOS (Fase 2) + BIBLIOTECA + COMPETITORS + NICHE_INDEX atual  
**PASSO:** `CLIENTES/VANGUARD/PASSO_NICHE_MODELER.md`  
**Output:** análise completa colada pelo Diretor no chat do Músculo  
**Onde registra:** Músculo salva em PENDING_REVIEW → seção ANTIGRAVITY COWORK CONDUCTOR

---

### Fase 4 — VALIDAÇÃO P-124 (Músculo + Diretor)

**Quem:** Músculo delibera → Diretor vota  
**O que:** Músculo analisa output do Antigravity com 7 pontos de deliberação por item relevante  
**Formato:** lista numerada `1-SIM/NÃO` para o Diretor  
**Regra P-124:** todo output do Antigravity passa pelo Músculo ANTES de qualquer ação  
**Itens típicos:** validação de fit_score · status MOVER_AGORA vs MONITORAR · narrativas aprovadas · novos nichos aceitos

---

### Fase 5 — EXECUÇÃO (Músculo)

**Quem:** Músculo  
**O que:** após veredito do Diretor, executa os itens aprovados:
- Criar/atualizar `NICHE_MODELS/*_MODEL.json`
- Atualizar `NICHE_INDEX.json` (versão + campos)
- Atualizar `CLIENTES/VANGUARD/INTENCAO_LINKEDIN.md` (posts novos)
- Registrar alertas críticos em `PENDENTES.md`
- Atualizar `NICHE_MODELER_SESSIONS.json`

**Commit obrigatório:** `feat(cowork): NICHE_INDEX vX.Y + N modelos + [descrição]`

---

### Fase 6 — FECHAMENTO (Músculo)

**Quem:** Músculo  
**O que:**
- PENDING_REVIEW: todos os itens da sessão com veredito final (APROVADO/REJEITADO/STANDBY)
- `NICHE_MODELER_SESSIONS.json`: marcar `pending_review_processado: true`
- Verificar se há itens AGUARDANDO sem veredito → registrar em PENDENTES para próxima sessão
- Commit de fechamento

---

### Fase 7 — RESUMO DE ENCERRAMENTO (Músculo → Diretor)

**Quando:** após Fase 5 executada + veredito final do Diretor  
**Quem:** Músculo gera, Diretor lê e confirma encerramento  
**Formato obrigatório:**

```
RESUMO COWORK ENGINE — [DATA]

ATIVIDADES ENCERRADAS:
✅ [item] — [resultado em 1 linha]
✅ [item] — [resultado em 1 linha]

NICHE_INDEX: v[anterior] → v[novo] | [N] MOVER_AGORA / [M] MONITORAR

ALERTAS ATIVOS:
⚠️ [nicho] — prazo [data] — ação: [o que o Diretor faz]

PENDÊNCIAS CARRYOVER (próxima sessão Cowork):
→ [item] — razão do adiamento

PRÓXIMA SESSÃO COWORK:
→ Fase 2: veredito [N] arquivos INBOX pendentes
→ Fase 3: NICHE_MODELER com corpus [data]
→ Data sugerida: [quando — baseado em deadlines ativos]
```

---

## ARQUIVOS DO SISTEMA COWORK

| Arquivo | Função |
|---|---|
| `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_INDEX.json` | Estado atual de todos os nichos (fonte canônica) |
| `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_MODELS/*_MODEL.json` | Modelos individuais por nicho |
| `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_MODELS/SCHEMA.md` | Schema obrigatório dos MODEL files |
| `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PENDING_REVIEW.md` | Canal Antigravity→Músculo (P-124) |
| `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_MODELER_SESSIONS.json` | Log de sessões Cowork executadas |
| `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/BIBLIOTECA_NICHOS/` | Biblioteca de nichos e cartões candidatos |
| `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/COMPETITORS/` | Relatórios de concorrência |
| `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/TRENDS/` | Relatórios de tendências semanais |
| `CLIENTES/VANGUARD/PASSO_NICHE_MODELER.md` | Missão da sessão Antigravity (atualizado por sessão) |
| `CLIENTES/VANGUARD/INTENCAO_LINKEDIN.md` | Posts aprovados para publicação |
| `scripts/match_niche.ps1` | Cruzamento de prospect vs NICHE_INDEX |
| `GEMINI.md` | Identidade e 3 funções do Antigravity IDE |

---

## CADÊNCIA SUGERIDA

| Atividade | Frequência |
|---|---|
| Fase 1 — Coleta (Embaixador) | Contínua — a cada interação de mercado |
| Fase 2 — Veredito INBOX | A cada acúmulo de 5+ frentes novas |
| Fase 3 a 7 — Sessão NICHE_MODELER completa | Mensal (dia 1 do mês) ou quando alerta CRÍTICO |
| COMPETITORS (Intel Loop Motor) | 1º domingo do mês |
| TRENDS (Intel Loop Motor) | Toda segunda-feira |

---

## REGRAS OBRIGATÓRIAS

1. **P-124:** todo output do Antigravity vai para PENDING_REVIEW antes de qualquer ação
2. **Fase 2 é gate bloqueante:** INBOX sem veredito = Fase 3 bloqueada
3. **COWORK ≠ LOOP:** nunca usar "Loop X" para designar sessão Cowork
4. **P-059:** contexto Vanguard isolado de Ingrid/Valdece — NUNCA misturar
5. **Resumo (Fase 7) é obrigatório:** sessão Cowork sem Resumo = fechamento incompleto
6. **Commit por fase:** Fase 5 tem commit próprio; Fase 6 tem commit de fechamento

---

*RUNBOOK_COWORK_ENGINE.md · Pentalateral IAH · Atualizar ao detectar novo padrão ou nova fase*
