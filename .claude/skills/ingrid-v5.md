# SKILL: ingrid-v5.md
**Projeto:** Ingrid — Ferramenta de Estudo Sedes-DF
**Camada:** 2 (Produto) | **Loop:** #5 | **Dias:** 12-13
**Stack:** PWA Vanilla JS + Supabase RPC + GitHub Pages
**Gerada pelo Auditor (NotebookLM) — headers corrigidos pelo Músculo — 2026-05-26**

---

## [AUDITORIA DE COERENCIA]

**3 riscos críticos identificados pelo Auditor:**

**RISCO 1 — Ilusão Arquitetural iOS Safari (CRÍTICO)**
DIRETRIZ V6 propõe 4h de build em Web Push via Service Worker. Ingrid usa iOS, tem perfil zero tolerância a fricção técnica (14_MEMORIA_EMBAIXADOR.md). Apple bloqueia Web Push em PWAs não adicionados à Home Screen. Construir "gatilho vital" que nasce morto viola P-030. **Decisão: fallback analógico WhatsApp. Eduardo envia link manualmente. 100% à prova de falha da Apple.**

**RISCO 2 — Anacronismo de Compliance Jurídico (AMARELO → VERMELHO)**
Assinatura real de Ingrid: 18/05/2026. Termo_de_Uso_Ingrid_PROJ002 crava vigência em 30/05/2026. Divergência anula proteção de liability da holding para dados já coletados. Resolver antes do Dia 14 via Clickwrap-Unclog: Contador bloqueado até Ingrid confirmar termo com data correta, gravando hash SHA-256 no Supabase.

**RISCO 3 — Desamparo Aprendido via Interface Punitiva**
Quadrix usa fator de correção negativo (1 erro anula 1 acerto). Plotar pontuações em vermelho ou como "dívida" destroi Temperatura VERDE FRÁGIL conquistada. Exibir sempre como "Metros Conquistados no Edital" — nunca como déficit.

**Alertas ativos do LEDGER:**
- **[P-038]** BLOQUEANTE: banco 460 questões — Micro-Simulado Dominical DEVE reciclar exclusivamente SM-2 (já vistas). Drenar inéditas = colapso estrutural antes de setembro.
- **[P-045]** Respeitado: zero telas de login. Auto-login via UUID hardcoded invisível.
- **[P-044]** Score punitivo nunca exibido como dívida — sempre como conquista/território.
- **[P-056]** Deploy frontal exige `deploy_ingrid_ghpages.ps1` — nunca direto no master.
- **[P-023]** Trava contratual: Contador desfocado (blur) até Ingrid confirmar termo 18/05.

**G-3 (Bloqueio por Leitura Dinâmica) — VETO:** Punições de tempo geram abandono reativo. "Persona Sargento" refutado no Loop 4. Descartado.

---

## [CONEXAO HISTORICA]

**Decisões fixadas (nunca reverter):**
- Arquitetura 1 Claude call/invocação Edge Function
- Cargo 202 (P-024) — não TDAS área social
- Proporção feed 70% Peso 2 / 30% Peso 1
- SM-2 para espaçamento — sem alterar matriz fundamental
- Single-user sem auth complexa (P-045)
- Fallback 70% cota diária (Burn Rate $5/dia)

**Gates aprovados (evidência real):**
- Dia 2: 10 questões avaliadas — rubrica ≥4/5 OK
- Dia 5: 7 dias × 20 questões — 70% Peso 2 — 0 erros — gate_cli_dia5.js APROVADO
- Dia 8: PWA completo — Clickwrap + Tutor 3 níveis + Fallback + TTI — APROVADO 2026-05-19
- Dia 11: Heatmap + Micro-Simulado — APROVADO 2026-05-20
- Dia 13: Widget Contador + Push dominical — deploy v14 gh-pages — smoke 5/5 PASSOU · aprovação Ingrid **pendente**

**O que os Loops 1-4 provaram sobre a Ingrid:**
- Usa o app diariamente — hábito em formação, não consolidado
- Não reclama quando frustrada — abandona silenciosamente → [CHURN-WATCH] ativo
- Feed diário é o core real do produto
- A cada deploy, Ingrid testa e reporta bug na mesma sessão (engajamento alto)
- Automações complexas de servidor em Camada 2 geram suporte que a Vanguard não absorve

---

## [PADRAO DE SUCESSO/FALHA]

**O que funciona:**
- Cálculo Quadrix estrito (Acertos P2×2 + Acertos P1×1 - Erros) traduz a "Cena de Sucesso" (P-041) e sana a ansiedade da Ingrid com dado real
- Edge Functions simples 1 call/invocação — sem cascatas
- Smoke test CLI antes de qualquer UI — P-007 obrigatório
- Deploy via `deploy_ingrid_ghpages.ps1` — nunca manual

**O que falha:**
- Automações nativas de SO (Web Push iOS) sem onboarding físico — repete erro de V16 com integrações mobile
- Notificação push às 09h fixo sem validar horário real de Ingrid = spam improdutivo
- Otimismo de prazo: inflar escopo com integrações nativas a 4 dias do deadline (30/05)

**Sequência de build com gates verificáveis:**

```
PASSO 1 — RPC Score Quadrix (Backend)
  Stored Procedure Supabase: (Acertos P2×2) + (Acertos P1×1) - Erros
  Gate: query retorna score correto para 5 respostas simuladas via SQL

PASSO 2 — Widget Contador no Header (Frontend)
  Renderizar em tempo real com linguagem "Metros Conquistados"
  Gate: responder 3 questões e verificar alteração precisa do contador

PASSO 3 — Linha de Corte Fantasma opcional
  Linha pontilhada estática "72 pts" — referência visual de meta (P-041)
  Gate: elemento renderizado sem quebrar layout mobile

PASSO 4 — WhatsApp Fallback dominical (Mágico de Oz)
  String parametrizada wa.me/... no Dashboard interno
  Gate: Eduardo clica e abre WhatsApp com mensagem correta pré-formatada

PASSO 5 — Spike Push (30 min máximo)
  SE iOS Safari aceitar → Service Worker
  SE recusar → abortar graciosamente, manter WhatsApp Shield
  Gate: push chega no device real OU fallback funciona sem erro

PASSO 6 — Deploy via script
  deploy_ingrid_ghpages.ps1 → confirmar URL pública ativa
  Gate: URL responde 200, widget visível no mobile
```

**O que NÃO construir:**
- Service Worker além do spike de 30 min
- Bloqueio punitivo por desatenção (G-3 vetada — risco de desamparo)
- SVG gerado em servidor — html2canvas cliente se necessário (N-5)
- Dashboard de histórico gráfico temporal — fora do escopo Loop 5
- Exportação PDF complexa

---

## [PERSPECTIVA DO SOCIO]

**O que o Gemini e o Músculo não estão vendo:**

A burocratização está se instaurando no Pentalateral. Adicionar flags, modais punitivos e badges de vacinação sobre UI de cliente VERDE FRÁGIL prova que a máquina prioriza *adicionar features* a *observar o usuário*. A restrição é o oxigênio do design — a interface deve ser limpa e implacável no foco.

**Divergência fundamentada:**
- G-3 (Bloqueio por Desatenção): veto completo. Ingrid tem perfil de desamparo silencioso — punição de tempo = churn garantido.
- Horário fixo 09h: sem base empírica. `horario_inicio_sessao` deve definir o trigger — não suposição.
- O Estrategista e o Músculo repetem o erro histórico de subestimar as "gaiolas de hardware dos fabricantes" (Apple iOS).

**Decisão exclusiva do Diretor:**
Confirmar horário real de estudo de Ingrid aos domingos + forçar assinatura de termo retificado para estancar brecha jurídica antes do Dia 14.

**[N-1 a N-5] — Ideias exclusivas do Auditor:**

N-1: Gatilho Temporal Autônomo — Push/WhatsApp 15 min antes do pico modal de `horario_inicio_sessao` (últimas 2 semanas). Não às 09h fixo. Consulta passiva, sem custo adicional.

N-2: Reconciliação Contratual Criptográfica — Clickwrap-Unclog: Contador bloqueado até Ingrid confirmar termo com data 18/05. Clique grava hash SHA-256 no Supabase. Mata passivo jurídico sem atrito visível.

N-3: Linha de Corte Fantasma — 72 pts históricos como linha pontilhada estática. Aversão à Perda (P-041) converte número frio em caça tangível à vaga.

N-4: Rótulo de Ilusão Estatística SM-2 — Tag [Simulado de Fixação] nos scores do domingo. Informa que a nota tem viés de reciclagem (P-038). Previne complacência por memória fotográfica de distratores.

N-5: Raio-X SVG via html2canvas — Card motivacional gerado no cliente JS puro. Sem token de back-end. Ingrid vê conquista; Vanguard colhe anonimizado para pitch SaaS das 500 usuárias (MRR R$97/mês).
