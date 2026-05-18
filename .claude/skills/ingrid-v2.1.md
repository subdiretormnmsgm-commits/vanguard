# Skill ingrid-v2.1.md — PROJ-002 Ingrid · Loop 3
> Consolidada pelo Músculo · 2026-05-17
> Fontes: ingrid-v2.md (Músculo) + Skill Auditor (NotebookLM) + DIRETRIZ V3 (Gemini)
> Executar com /ingrid-v2.1 antes de qualquer build do Loop 3

---

## PARTE 1 — AUDITORIA DE COERÊNCIA
> Cruzamento: DIRETRIZ V3 · MEMORIA_V2_INGRID · INTELLIGENCE_LEDGER · Skill Auditor

**Eixo 1 — Arquitetura modular (M-11 MODIFICADO pelo Gemini)**
Edge Functions são módulos separados — nunca monolito. Se `tutor-socratico` falha, `feed-diario` e SM-2 continuam operando.
Regra: 1 Edge Function por responsabilidade. Deploy independente. ✅ FIXADO.

**Eixo 2 — Cargo 202 (P-024 — nunca reverter)**
Todo conteúdo retornado reflete estritamente as disciplinas do Cargo 202 (Téc. Administrativo): Dir. Administrativo, Constitucional, etc. Verificar em toda nova Edge Function. ✅ SEM CONFLITO.

**Eixo 3 — SM-2 com Time Margin (M-13 MODIFICADO pelo Gemini)**
O algoritmo SM-2 central não é alterado. O tempo de resposta age como modificador de margem: se >60s → intervalo do próximo ciclo recebe ±1 dia de ajuste. Frontend exibe flag visual (ícone tartaruga) — sinal pedagógico para Ingrid, não mudança matemática. ✅ IMPLEMENTÁVEL no Dia 8.

**Eixo 4 — Budget $5,00/dia (P-006)**
max_tokens=280 hard. Cache bidimensional obrigatório. Fallback ativa em 70% da cota.
Edge Function retorna `{ explicacao, custo_atual_dia, fallback_ativo }` no corpo — frontend lê sem polling. ✅ ALINHADO.

**Conflitos vetados — mantidos da v2:**
- E-5 TTS/Web Speech: PT-BR instável iOS · VETO
- E-4 visibilitychange: Safari iOS instável · VETO ABSOLUTO
- E-1 IndexedDB: complexidade excede prazo · V2
- E-2 Feynman Reversa: chamada não cacheável · viola P-006 · V2

---

## PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR

**Ponto cego 1 — Contratos P0 (P-023 ativo)**
Ingrid tem Termo assinado ✅. Valdece tem contrato corrigido (v2 gerada hoje — verificar assinatura amanhã no onboarding). Sem assinatura, o build do Dia 6 começa com risco comercial aberto.

**Ponto cego 2 — Embaixador sem co-autoria**
No Loop 3 o Embaixador executou — gerou documentos, mensagens, contratos. Não trouxe ideias ao Conselho. No Loop 4 precisa aparecer com pelo menos 3 contribuições autônomas. Se não aparecer, a instrução de sistema ainda o trata como executor, não como membro.

**Ponto cego 3 — Proliferação de ideias**
18 ideias aprovadas para 3 dias de build. Critério de corte obrigatório antes do Dia 6: qualquer feature >4h vai para V2, independente de quanto foi aprovado nesta deliberação.

**Veto mantido — E-4 Dark Pattern / visibilitychange:**
Safari iOS instável. Bug P1 garantido. VETO ABSOLUTO para os Dias 6-8.

---

## PARTE 3 — A SKILL COPIÁVEL

```skill
# SKILL — PROJ-002 Ingrid · Loop 3 · Dias 6-8
# Versão: ingrid-v2.1.md · Consolidada: 2026-05-17
# Fontes: Músculo + Auditor (NotebookLM) + Estrategista (Gemini DIRETRIZ V3)

## CONTEXTO DO PROJETO

- Cliente: Ingrid (concurseira Sedes-DF 2026-09-06)
- Cargo: TDAS — Técnico Administrativo — Cargo 202 (P-024: recalibrado, nunca reverter)
- Banca: Instituto Quadrix
- Stack: PWA + Vanilla JS/CSS + Supabase (RLS single-user) + Claude API (Haiku + Sonnet)
- Banco: 460 questões · 13 disciplinas · 70% Peso 2 / 30% Peso 1
- Burn Rate: $5,00/dia hard limit (P-006)
- Deadline: 2026-05-30 (10 dias restantes para 3 loops)
- Auth: single-user hardcoded · user_id fixo no código (M-14 aprovado)
- Loop atual: #3 — Dias 6-8 (Interface + Tutor Socrático + Fallback Fadiga)

## DECISÕES FIXADAS (nunca reverter sem veredito do Diretor)

1. MODULARIDADE: 1 Edge Function por responsabilidade — nunca monolito (M-11 mod. Gemini)
2. 1 Claude call por Edge Function invocação — nunca multi-turn
3. Cache bidimensional: tabela `explicacao_tutor` (questao_id, alternativa_escolhida)
4. max_tokens: 280 (Haiku) — resposta direta + burn rate shield
5. SM-2 Time Margin: tempo >60s → modificador ±1 dia no intervalo + flag tartaruga no frontend (M-13 mod. Gemini)
6. Lazy Loading: 3 questões no load → resto em background (Promise.all)
7. Sessão dupla: sessionStorage (token + bateria ativa) + localStorage (progresso consolidado do dia)
8. Sleep-mode: inatividade >10 min → overlay "Retomar Estudo" + congela chamadas assíncronas
9. Progresso: contador simples no header — sem 6 barras de disciplina no MVP
10. Debug mode: ?debug=true → exibe { feed, custo_atual_dia/$5.00, fallback_ativo, cache_hits }

## SEQUÊNCIA DE BUILD DIAS 6-8

### DIA 6 — PWA Estático + Skeleton + Sessão

Sequência obrigatória (Mock → validar → avançar):
1. `index.html` mobile-first: header contador, card questão, 4 botões alternativa (touch ≥ 48px)
2. CSS: Obsidian Black (#0A0A0A) + Cyber Cyan (#00F0FF) · sem animações no MVP
3. SKELETON SCREENS: substituir spinners por skeleton CSS nas transições — reduz percepção de latência 4G (Auditor-1)
4. Mock de 3 questões hardcoded no JS → validar layout no celular
5. Lazy Loading: mock[0:3] no load → simular fetch do resto em 2s
6. SESSÃO DUPLA: sessionStorage para token/bateria ativa · localStorage para progresso do dia (Auditor-3 mod.)
7. clearSensitiveStorage() no token expire (A-7)
8. Sleep-mode: setTimeout(10min) → overlay "Retomar Estudo"
9. Debug mode: ?debug=true exibe estado interno
10. hardcode user_id no código (M-14)

Gate Dia 6: Eduardo abre no celular. Botões fáceis de tocar. Layout ok em 375px. Skeleton visível na transição.
Evidência: screenshot no celular + confirmação verbal.

### DIA 7 — Supabase Real + Tutor + Cache + Pre-fetch

Sequência obrigatória:
1. Substituir mock → Supabase JS client (CDN) · query `questoes_nao_respondidas` (view RLS Cargo 202)
2. Lazy Loading real: 3 no load → Promise.all para o resto
3. PRE-FETCH SILENCIOSO: ao exibir questão → SELECT `explicacao_tutor WHERE questao_id = X` no Supabase. Se cache existe → carrega no frontend. Se errar e cache disponível → 0ms feedback (Auditor-2 mod.)
4. Edge Function `tutor-socratico` (módulo separado): recebe (questao_id, alternativa_escolhida) → Haiku max_tokens=280
5. Response JSON: `{ explicacao, custo_atual_dia, fallback_ativo }` — sem polling separado (A-8 + Auditor-5 fundidos)
6. INSERT `explicacao_tutor` ON CONFLICT DO NOTHING (cache bidimensional)
7. Modal de explicação: cache first → se miss → Edge Function
8. Progresso no header: query count(*) de respostas do dia
9. Debug mode: renderiza custo_atual_dia/$5.00 + fallback_ativo no rodapé

Gate Dia 7: questões reais do Cargo 202 · cache funciona (2ª chamada = 0ms) · progresso atualiza · debug mostra custo.
Evidência: console.log de cada etapa + screenshot do feed real.

### DIA 8 — SM-2 Time Margin + Fallback + Teste Completo

Sequência obrigatória:
1. Capturar timestamp de início da questão → calcular delta ao responder
2. Se delta >60s → modificador ±1 dia no próximo intervalo SM-2 + ÍCONE TARTARUGA visível (Auditor-4)
3. View `daily_cost` → se ≥70% → ativar Modo Revisão
4. Modo Revisão: bloqueia novas queries ao Tutor · exibe pílulas do localStorage
5. Modo Express (5 min): subset das 5 questões Peso 2 SM-2 mais urgentes
6. Ingrid responde 10 questões reais: verificar SM-2 salvo + progresso correto
7. Simular daily_cost ≥$3,50 → confirmar fallback ativa

Gate Dia 8: Ingrid responde 10 questões · tartaruga aparece nos acertos lentos · fallback testado com custo simulado.
Evidência: screenshot sessão real + log Supabase mostrando respostas inseridas.

## O QUE NÃO CONSTRUIR NESTE LOOP

| Feature proibida | Razão |
|---|---|
| Edge Function monolítica | Viola resiliência — M-11 mod. Gemini |
| Alterar matriz SM-2 central | Prazo · instabilidade · V2 (M-13 mod.) |
| React / Vue / Next.js | Setup >4h — viola prazo |
| IndexedDB / Service Worker offline | Complexidade excede Dias 6-7 · V2 |
| TTS / Web Speech API | PT-BR instável iOS · P-016 · V2 |
| Feynman Reversa (resposta aberta) | Chamada não cacheável · viola P-006 |
| visibilitychange Dark Pattern | Safari iOS instável · bug P1 garantido |
| Animações de página | Pixel drift em vez de dados |
| Configurações de perfil / temas | Escopo silencioso |
| Gráficos Recharts / D3 | Bundle pesado · V2 (Heatmap Dia 9-11) |
| Histórico de chat do Tutor | Viola arquitetura 1 call/invocação |
| Auth real (OAuth, magic link) | Single-user MVP · P-013 = Dias 14-15 |

## ALERTAS ATIVOS

[P-003] Zero Scraping: consumir exclusivamente do Supabase Vanguard
[P-006] Burn Rate Shield: max_tokens=280 · cache obrigatório · fallback em 70%
[P-010] Momentum de Execução: gate sem evidência = gate inválido
[P-023] Contrato P0: verificar assinatura Valdece no onboarding de amanhã
[P-024] Recalibração Cargo: sempre Cargo 202 · verificar em toda nova Edge Function
```

---

## PARTE 4 — IDEIAS CONSOLIDADAS (Músculo + Auditor + Estrategista)

### Do Auditor — aprovadas e integradas na Skill:
**Auditor-1** (Skeleton Screens) → Dia 6 ✅
**Auditor-2** (Pre-fetch Silencioso mod.) → Dia 7 ✅
**Auditor-3** (sessionStorage + localStorage complementares) → Dia 6 ✅
**Auditor-4** (Flag tartaruga SM-2) → Dia 8 ✅
**Auditor-5** (Cota no debug) → fundido com A-8, Dia 7 ✅

### Do Estrategista — para o Embaixador (não para o build):
**G-1** Change-Order Automático → Embaixador · rascunho com campos em branco
**G-2** Temperatura de Churn → Embaixador · alerta AMARELO em 48h sem resposta
**G-3** Handoff Blueprint Generator → Embaixador · Dia 15
**G-4** CONTRATO_STATUS.txt + preflight.ps1 → script local · 1h de build
**G-5** Dízimo LEDGER → Embaixador · princípio candidato ao fechar projeto

### Do Músculo — mantidas da v2:
**A-1** Cache bidimensional (questao_id, alternativa_escolhida) ✅
**A-2** max_tokens=280 ✅
**A-3** localStorage para progresso (complementar ao sessionStorage do Auditor-3) ✅
**A-4** Lazy Loading 3+resto ✅
**A-5** Sleep-mode 10min ✅
**A-6** RPC progresso por disciplina → Dia 9-11 (fundação do Heatmap) · V2 do Loop 3
**A-7** clearSensitiveStorage() no token expire ✅
**A-8** JSON unificado { explicacao, custo_atual_dia, fallback_ativo } → fundido com Auditor-5 ✅
