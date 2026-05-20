# MEMORIA_V18 — Recurrence Singularity Engine
> **Versão:** V18
> **Data:** 2026-05-10
> **Autor técnico:** Claude Code (Arquitecto-Mestre)
> **Protocolo:** Conselho Quadrilateral — Fase 4 — Encerramento de Ciclo

---

## 1. ARQUIVOS CRIADOS

| Arquivo | Função | Impacto |
|---|---|---|
| `js/sovereign-playbook.js` | Gerador de Plano 90 dias (12 semanas) ancorado a Power-Ups Vanguard | Lock-in: cliente não executa sem a plataforma |
| `js/neural-sentinel.js` | Delta semanal FIRE/HOT/WARM vs semana anterior + paywall R$97/mês | Histórico de 4 semanas = MRR defensável |
| `js/quiz.js` | Diagnóstico Quadrilateral™ — 7 perguntas + scoring matrix P/A/C/R | Base de dados qualificada com quadrante fraco identificado |
| `js/neural-hero.js` | Canvas de partículas neurais no hero (Design Direction 1) | Identidade visual futurista + performance IntersectionObserver |
| `MEMORIA_V18.md` | Este arquivo — memória técnica permanente | Auditoria futura |
| `relatorio_evolutivo_v18.md` | Relatório com 5 ideias V19 | Handoff Gemini |

---

## 2. ARQUIVOS MODIFICADOS

| Arquivo | Mudança | Detalhe |
|---|---|---|
| `index.html` | Quiz substituído por 9 steps + canvas hero + copy humanizada | Sem referências a IA/Claude/n8n/Scraper |
| `assets/css/v16-elite.css` | +Quiz cards, quad-bars, preview-risk, rec styles | Paleta Ion Gold/Obsidian consistente |
| `js/supabase.js` | `saveLeadDiagnostico` aceita `metadata` com scores quadrilateral | Dados ricos por lead |
| `VANGUARD_INNOVATION_AUDIT.md` | +[ID-005] Recurrence Singularity Engine | AUTO-LOG processado |
| `DIRETRIZ_GEMINI.txt` | Actualizado V17→V18 | Estado actual + 5 ideias V19 |

---

## 3. ARQUITECTURA V18 — RECURRENCE SINGULARITY ENGINE

### Sovereign Playbook Engine (`sovereign-playbook.js`)
- **Tipo de plano detectado:** Velocidade / SEO / Conversão / Default (mapeado do bottleneck principal do RealScanner)
- **Estrutura:** 12 semanas, cada tarefa ancorada a um Power-Up Vanguard (scanner, pixel, hermes, sentinel, badge, hive)
- **Paywall:** Semanas 1–2 grátis (isca) → semanas 3–12 desbloqueiam com subscrição R$97/mês Neural Sentinel
- **PDF:** jsPDF A4, capa Ion Gold, estética Deep Obsidian — motor herdado de `closer-machine.js` (V12)
- **Lock-in gerado:** Plano do cliente preso na plataforma — sem Vanguard não executa o plano

### Neural Sentinel Engine (`neural-sentinel.js`)
- **Fonte de dados:** `pixel_events_staging` UNLOGGED (V16/V17) — delta semana actual vs anterior
- **Alerta:** FIRE cai >15% OU receita estimada em risco >R$1.500 → banner vermelho
- **Ticket médio:** R$800 (B2B Brasil) para cálculo de receita em risco
- **Paywall:** Histórico de 4 semanas bloqueado → R$97/mês via Stripe subscriptions
- **Demo automático:** quando Pixel não instalado, usa dados seed (18 FIRE / 31 FIRE semanas)
- **LocalStorage:** `vg_sentinel_sub` com data de expiração (30 dias)

### Diagnóstico Quadrilateral™ (`quiz.js`)
- **7 perguntas:** Q1 sector / Q2 faturamento / Q3 canal aquisição / Q4 presença / Q5 conversão / Q6 obstáculo / Q7 histórico
- **Scoring matrix:** cada resposta contribui com scores {P, A, C, R} (0–10) — 4 quadrantes
- **Preview:** P+A revelados, C+R bloqueados → gatilho de conversão (revelar requer contacto)
- **Recomendação:** quadrante mais fraco → produto Vanguard específico (4 mapeamentos)
- **Receita em risco:** estimativa baseada em faturamento × avg score deficitário
- **Supabase:** `saveLeadDiagnostico` com payload completo incluindo `metadata.scores`

### Neural Particle Hero (`neural-hero.js`)
- **Canvas:** 80 partículas douradas (42 mobile) com conexões neurais dinâmicas
- **Pulse:** a cada 2.8s uma partícula pulsa com anel de expansão dourado
- **Performance:** pausa automática via IntersectionObserver quando hero sai do viewport
- **Paleta:** `rgba(197,160,40,X)` — Ion Gold

---

## 4. FUNDAÇÃO REUTILIZADA

| Módulo | Versão | Como foi reaproveitado |
|---|---|---|
| `closer-machine.js` | V12 | Motor jsPDF + paleta Ion Gold reutilizados no Playbook |
| `pixel_events_staging` UNLOGGED | V16/V17 | Tabela consumida pelo Sentinel para delta semanal |
| `prospectar.ps1` | V17 | Espinha dorsal do loop comercial — segue operacional |
| Stripe Connect | V16 | Checkout de subscrição recorrente (price_id sentinel_97_monthly) |
| `real-scanner.js` | V15 | Bottleneck detectado → tipo de Playbook mapeado |

---

## 5. DÍVIDAS TÉCNICAS GERADAS

| Dívida | Impacto | Versão para resolver |
|---|---|---|
| Stripe endpoint `/api/stripe/sentinel-checkout` não existe | Subscrição Neural Sentinel não funciona em produção | V19 |
| `leads_diagnostico` sem coluna `metadata` JSONB | Dados quadrilateral não são guardados no Supabase | V19 (migration) |
| Neural Sentinel: histórico real de 4 semanas só existe após 30+ dias de Pixel activo | Demo seed para early adopters | V19 |
| `DIRETRIZ GEMINI V18.txt` referencia V19 ideias — aguarda resposta Gemini | DIRETRIZ V19 ainda não existe | Ritual pós-V18 |

---

## 6. ESTADO COMERCIAL

| Métrica | Valor |
|---|---|
| Clientes pagantes | 0 |
| MRR actual | R$0 |
| Meta V18 | 1 cliente Neural Sentinel (R$97/mês) + 1 Standard (R$270/mês) |
| Ferramentas prontas para vender | Diagnóstico Quadrilateral™ + Neural Audit Trail + Sovereign Playbook + prospectar.ps1 |
| Próximo milestone | 1 conversa de venda iniciada (pré-requisito para fechar V18) |
