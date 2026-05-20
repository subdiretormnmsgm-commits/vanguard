# DELIBERAÇÃO LOOP 4 — PROJETO INGRID
> Gerada em 2026-05-20 · PASSO G.5 (P-048) · Aguardando veredito do Diretor

---

## CHECKLIST DE IMUNIDADE
- [x] Skill ingrid-v4.md lida e internalizada
- [x] DIRETRIZ V5 lida completa
- [x] MEMORIA_EMBAIXADOR lida ([E-1 a E-5] Loop 4 Deliberação)
- [x] LEDGER (P-001 a P-048) ativo
- [⚠️] [N-1 a N-5]: conteúdo completo perdido na compressão — deliberados pelos títulos

---

## PASSO C — PRIORIDADES DO [PARA O MÚSCULO]

### Prioridade 1: Auth / Termo (P-045, P-023)
- **Certo:** Auth real = pré-requisito para scale de 1 → 500. Erro de data no Termo é risco jurídico ativo.
- **Diverge:** DIRETRIZ propõe email/senha exposto — contradiz P-045. Auth invisível para Ingrid, RLS no backend.
- **Decisão:** Auth backend invisível + auto-login token fixo = ENTRA AGORA. Tela de login Ingrid = DESCARTADO. Clickwrap V2 ("termo_v2_18_05") = ENTRA AGORA.
- **Enhancement:** Schema Auth já multi-usuário — V2 é 1 linha de config, não rewrite.
- **Custo:** RLS + auto-login: 2h. Clickwrap V2: 1h. Total: 3h Dia 9.
- **Impacto:** Ingrid sem fricção. Backend pronto para 500 usuárias.
- **Ação:** Eduardo confirma auth invisível + Clickwrap V2?

### Prioridade 2: Heatmap / Curva de Erros (P-044)
- **Certo:** Ativo proprietário real. Argumento central do pitch.
- **Diverge:** DIRETRIZ estima 4h — realista 5-6h. "Heatmap de Urgência" ativa ansiedade — virar "Mapa de Soberania".
- **Decisão:** Heatmap linguagem conquista = ENTRA AGORA (Dias 10-11). Nome "Urgência" = DESCARTADO.
- **Enhancement:** Duas camadas: Zona Soberana (verde exuberante) + Radar de Foco (top 3 gap). G-4 absorvido sem custo adicional.
- **Custo:** Query Dia 10: 2h. UI Dia 11: 3h. Total: 5h.
- **Impacto:** Print "território conquistado" = Ad orgânico perfeito.
- **Ação:** Eduardo aprova nome "Mapa de Soberania"?

### Prioridade 3: Micro-Simulado Dominical
- **Certo:** Formato Quadrix com penalidade é necessário para setembro.
- **Diverge:** E-1 Embaixador: horário de estudo de Ingrid desconhecido. Simulado Dominical = feature desperdiçada se não estuda domingo.
- **Decisão:** V2 CONDICIONAL — só constrói após check-in 21/05 confirmar domingo. Bloqueio forçado do feed = MODIFICADO para opcional.
- **Custo:** 3h (Dias 13-14) — condicional.
- **Ação:** Eduardo confirma check-in 21/05 como gate?

---

## PASSO D — [G-1 a G-5] DO GEMINI

### [G-1] Pause Dominical Analógico (PDF impressão)
- Certo: imitar ambiente físico da prova é sólido.
- Diverge: PDF Blob = 8-10h para piloto único. Custo-benefício negativo.
- **Decisão: V3.** Enhancement: "Modo Prova" no app (tela limpa, timer, sem feedback) = V2, 2h.

### [G-2] Distrator Assombração (mesmo distrator 3 dias)
- Certo: Reforço de padrão de erro é pedagogia sólida.
- Diverge: **VETO CRÍTICO DO EMBAIXADOR** — Ingrid não reclama, abandona silenciosamente.
- **Decisão: DESCARTADO (visível). MODIFICADO: reforço oculto no SM-2**, sem confronto. 2h.

### [G-3] TTI como Persona Sargento
- Certo: TTI baixo = chute real.
- Diverge: **VETO ABSOLUTO DO EMBAIXADOR** — confronto verbal = abandono silencioso.
- **Decisão: Persona Sargento = DESCARTADO. TTI gravado silenciosamente** (campo `ttl_resposta_ms`) para análise interna. 1h.

### [G-4] Capital Acumulado / Zona Soberana
- Convergência total: G + E-3 + Skill.
- **Decisão: ENTRA AGORA** — absorvido no Mapa de Soberania. Frase: "Você já garantiu [X]% em [disciplina]. Esse é seu terreno." Custo: 30min adicional.

### [G-5] Handoff Raio-X Pessoal
- Certo: Ativo permanente. Ingrid usa até setembro. Maior gerador de indicação.
- Gate: só com 15 dias de dados. Burn Rate checado.
- **Decisão: ENTRA (Dia 15).** 3 seções: Território + Armadilhas por Padrão + Plano 7 dias. Eduardo entrega via WhatsApp pessoalmente. Custo: 3h + ~$0,50 API.

---

## PASSO E — [N-1 a N-5] DO AUDITOR
*(Conteúdo completo perdido na compressão — deliberados pelos títulos)*

| # | Nome | Decisão | Razão |
|---|---|---|---|
| N-1 | Injeção Regulatória no Prompt | V2 | Corpus legislativo precisa curação 3-4h. 460 questões prontas tornam desnecessário agora. |
| N-2 | RLS Híbrido Silencioso | ENTRA (já contemplado) | É exatamente o Auth invisível da Prioridade 1. Convergência Auditor + Músculo. |
| N-3 | Simulado Reciclado | ENTRA (já contemplado) | P-038 obrigatório. Micro-Simulado só usa pool de 460. |
| N-4 | Termo Versionado no Database | ENTRA | "termo_v2_18_05" no banco = P-023. Já no Clickwrap V2. 30min adicionais. |
| N-5 | Heatmap Inverso | ENTRA (já contemplado) | É a Zona Soberana do G-4. Auditor, Gemini e Músculo convergiram independentemente. |

---

## PASSO E.b — [E-1 a E-5] DO EMBAIXADOR

| # | Insight | Decisão |
|---|---|---|
| E-1 | Horário de pico desconhecido | CONFIRMO — Simulado bloqueado até check-in 21/05 |
| E-2 | Estado de fluxo — fallback invisível | CONFIRMO + EXPANDO — fallback graceful Dia 9: Claude API lento → questão cached, zero erro visível |
| E-3 | Feedback positivo pós-streak | CONFIRMO — condicional streak ≥ 3: "Você acertou as últimas [N] — esse é seu ritmo." 30min. |
| E-4 | Campo horario_inicio_sessao inexistente | EXPANDO — adicionar `horario_inicio_sessao` + `ttl_sessao_minutos` Dia 9. 30min. Argumento de pitch: "feito para quem estuda depois das 20h." |
| E-5 | Mensagem semanal WhatsApp | CONFIRMO — Músculo prepara template com dados reais via [M-2]. Requer autorização do Diretor. |

---

## PASSO F — [M-1 a M-5] DO MÚSCULO

| # | Ideia | Custo | Loop |
|---|---|---|---|
| M-1 | Schema `tipo_pegadinha` (enum: prescinde / salvo / nunca / sempre / dupla_negativa) | Migration 30min · curação 460q: 3h | Migration agora, curação Loop 5 |
| M-2 | RPC progresso semanal para mensagem WhatsApp de Eduardo | 1h | Dia 9 |
| M-3 | Burn Rate por sessão (> 20 chamadas API → rate limiting silencioso) | 2h | Dia 9 ou V2 |
| M-4 | Snapshot diário de métricas (cron job `metricas_diarias`) | 1.5h | Dia 9 |
| M-5 | Modo Socrático por Disciplina (meta-pergunta ao fechar bloco de 10q) | 2h | Loop 5 |

---

## PASSO G — PLANO DE BUILD

| Dia | Build | Gate CLI obrigatório |
|---|---|---|
| **9** | RLS + auto-login invisível · Clickwrap V2 · `horario_inicio_sessao` + `ttl_resposta_ms` · [M-2] RPC progresso · [M-4] snapshot diário · fallback graceful Claude API | RPCs corretas · Clickwrap V2 gravado · auto-login sem tela exposta |
| **10** | RPCs Heatmap (taxa de acerto por disciplina) · [M-3] Burn Rate por sessão | Query retorna taxa de acerto com dados reais via CLI |
| **11** | UI Mapa de Soberania + Radar de Foco · Frase "Esse é seu terreno" · E-3 streak feedback | Heatmap correto · linguagem conquista verificada |
| **12-13** | *(Condicional check-in 21/05)* Micro-Simulado Certo/Errado penalidade Quadrix · distrator oculto no SM-2 · TTI silencioso | Simulado 15q sem bug · TTI registrado |
| **14-15** | G-5 Edge Function agregação · Raio-X Pessoal · M-1 migration tipo_pegadinha (schema) | Raio-X gerado via CLI com 15 dias de dados |

**Fora deste loop:** tela login Ingrid · Persona Sargento · Distrator visível · PDF analógico · Leaderboard · M-5 Socrático · curação tipo_pegadinha

---

## PASSO H — VEREDITO PENDENTE

Eduardo, preciso do seu OK em 4 pontos antes de qualquer código:

1. **Auth invisível** (sem tela login Ingrid) + Clickwrap V2 — confirma?
2. **Check-in 21/05** como gate do Simulado Dominical — confirma que faz a pergunta de horário?
3. **Migration `tipo_pegadinha` agora** (30min), curação no Loop 5 — confirma?
4. **Mensagem semanal WhatsApp** com dados reais — autoriza o protocolo?
