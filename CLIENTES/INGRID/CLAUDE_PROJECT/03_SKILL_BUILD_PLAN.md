# SKILL: skill_ingrid_v2.2.md
**Camada:** 2 (Produto - Dias 6 a 8) | **Loop:** #3 | **Stack:** PWA Vanilla JS + Supabase + Claude API (Haiku)
**Consolidada em:** 2026-05-18 | **Base:** v2.2 + lógica Tutor v2.1 + deliberação Passo 6

---

## 📋 CONTEXTO DO PROJETO

PROJ-002 (Ingrid). Banco Supabase: 460 questões validadas, Cargo 202 (Técnico Administrativo — Sedes-DF/Quadrix). Disciplinas Peso 2: Dir. Administrativo, Constitucional, Arquivologia, Rec. Materiais. Feed 70/30 (Específicas/Gerais) validado no Gate Dia 5. A usuária é não-técnica, ansiosa, com ~111 dias até a prova. Temperatura da cliente: AMARELA. Prazo do projeto: 2026-05-30.

**Decisões fixadas (nunca reverter):**
- Arquitetura: 1 Claude call por invocação de Edge Function — nunca monólito (M-11)
- Auth: hardcoded via `user_id` — sem login (M-14)
- SM-2: fórmula original preservada — apenas coletar dados de latência (M-13)
- Stack: PWA Vanilla JS — sem React, Vue ou frameworks pesados
- Fluxo: Mock → Supabase → Tutor (M-15)

---

## 🛡️ ALERTAS ATIVOS (INTELLIGENCE LEDGER)

| Princípio | Regra |
|---|---|
| **[P-003] Zero Scraping** | Dados exclusivamente do Supabase populado via API Claude. Proibido buscar dados externos no frontend. |
| **[P-006] Burn Rate Shield** | Limite $5,00/dia. Kill-switch obrigatório aos 70% da cota. |
| **[P-010] Gate Verificável** | Nenhum dia avança sem output real aprovado pelo Diretor. |
| **[P-023] BLOQUEIO COMERCIAL** | PWA NÃO é entregue à Ingrid até aceite do Termo de Uso. Clickwrap resolve em código no Dia 6. |
| **[P-024] Cargo 202** | Todo conteúdo retornado pela UI reflete estritamente Cargo 202. Não TDAS área social. |
| **[P-025] 7 Panes Supabase** | Ver troubleshooting documentado antes de escalar qualquer erro de Edge Function. |
| **[P-031] Filtro de Realidade** | Ingrid repele jargão técnico e UI complexa. 1 clique para estudar. Frases E-2/E-5 são retenção, não UX secundária. |

---

## ⚙️ SEQUÊNCIA DE BUILD (DIAS 6–8)

### DIA 6 — UI Mockada + Clickwrap + Âncoras Emocionais
**PRIMEIRA TAREFA:** Clickwrap de Termo de Uso (resolve P-023)
- Primeira tela do PWA: "Ao clicar em Iniciar, declaro que li e concordo com os Termos de Uso"
- Clique grava `user_id + timestamp + versao_termo + hash_sha256` na tabela `termos_aceitos`
- Skip automático se já aceitou (verifica tabela ao iniciar)
- Desbloqueia Gate Dia 8 sem depender de assinatura de PDF

**Restante do Dia 6:**
- Esqueleto HTML/CSS/JS Vanilla, mobile-first
- Barra de progresso por disciplina Peso 2 (simples, não dashboard)
- Frase de Abertura dinâmica (E-2): adapta com base no desempenho recente — se errou Constitucional ontem, abre com *"Hoje atacamos o que travou você ontem."*
- Placeholder para Frase de Encerramento (E-5): *"Você já respondeu X questões"* — RPC na tabela, não contagem no frontend
- Auth hardcoded via `user_id`
- Debug Mode `?debug=true` (M-12): painel colapsável com questão ID, disciplina, peso SM-2, cache hit/miss, custo estimado

**GATE Dia 6:** Diretor testa layout estático no celular. Aprovação visual obrigatória antes do Dia 7.

---

### DIA 7 — Supabase + Tutor Socrático + Telemetria
**Conexão Supabase:**
- Conectar à view `questoes_nao_respondidas` (feed 70/30 já validado)
- Capturar `started_at = Date.now()` ao renderizar cada questão
- POST de resposta inclui `tempo_resposta_ms` (TTI — Telemetria de Hesitação G-2)
  - TTI < 30s + erro = desatenção → Tutor usa tom direto
  - TTI > 2min + erro = lacuna de teoria → Tutor aprofunda conceito

**Tutor Socrático em 3 Níveis (cache-first):**
1. Tutor checa `explicacao_tutor` no Supabase — se hit, retorna sem chamar API
2. Se miss → chama Claude Haiku com contexto do erro
   - **1º erro na questão:** explica o conceito da alternativa correta
   - **2º erro na mesma questão:** ataca o distrator específico que a Ingrid escolheu
   - **3º erro:** usa analogia — conecta o conceito a algo da vida cotidiana
3. Grava resultado no cache `explicacao_tutor` para reutilização (P-006)
4. Tom: `tone: "austere"` — professor exigente que acredita no aluno, não condescendente (G-5)

**Proteções de API:**
- Debounce no botão "Responder": `disabled = true` no primeiro toque, reativa após resposta da API (N-3)
- Override Admin: URL `?admin=<token_secreto>` aceita JSON de peso por disciplina, força cache reset (G-1)

**RPC get_total_respostas_ingrid:** Stored Procedure no Supabase que retorna apenas o inteiro total — alimenta a Frase de Encerramento E-5 sem baixar histórico completo (N-2)

**GATE Dia 7:** Log do Supabase confirma cache hit no Tutor (zero chamada duplicada para a API). Diretor valida via `?debug=true`.

---

### DIA 8 — Fallback + Proteções Finais + Gate Comercial
**Fallback de Fadiga (P-006):**
- Monitor de cota: ao bater 70% de $5,00/dia → kill-switch da API
- Modo passivo: exibe "Pílulas do Dia" — campo `explicacao_base` já nas questões do banco
- Graceful Degradation: se Edge Function falhar → exibe cache → se sem cache → exibe `explicacao_base`. Zero tela branca.

**Sanitização de Sessão Stale (N-4):**
- `document.hidden` listener: se aba ficar inativa > 4h → `window.location.reload()` silencioso ao retornar
- Previne fila SM-2 defasada sem que a usuária perceba

**Log de Abandono (N-5):**
- Se Ingrid abrir o app, visualizar questão e fechar sem responder em 2 minutos → `navigator.sendBeacon` grava em tabela `abandonment_log` no Supabase
- Dado crítico para o Embaixador: distingue "não acessou" de "acessou e fugiu da interface"

**GATE Dia 8 — Comercial (P-023):**
- Ingrid responde 10 questões reais, progresso salvo, fallback testado
- Gate só é válido se tabela `termos_aceitos` tiver registro da Ingrid (Clickwrap do Dia 6)
- Embaixador reporta temperatura da cliente após o Gate

---

## 🚫 O QUE NÃO CONSTRUIR NESTE LOOP

| Item | Razão |
|---|---|
| IndexedDB / sincronização offline | Dívida técnica desnecessária no prazo de 15 dias (vetado v2.1) |
| Web Speech API / áudio | Veto P-016 + P-031 — fricção de suporte para usuária não-técnica |
| Modo Revisão Express (5 min) | Vetado pelo Estrategista (BLOCO 4) — bifurcar modos antes de validar feed principal |
| Distrator Vingativo em Loop (G-3) | 4h+ de implementação — inviável no Gate Dia 8. Registrado como P-034 para V2 |
| Dashboards analíticos / gráficos pesados | Dispersa foco da usuária. 1 clique para estudar (P-031) |
| Modais de antievasão / Dark Patterns | Vetado — incompatível com perfil da Ingrid |
| Edge Function monolítica | Vetado M-11 — 1 call por invocação |
| Alterar fórmula SM-2 | Vetado M-13 — apenas coletar dados de latência neste ciclo |
| Modo multi-tenant / perfil de usuário | Fora do escopo da Camada 2 |

---

## 🔗 CONEXÃO HISTÓRICA

**Loop 1 provou:** banco de questões via API Claude é viável e de qualidade (Gate Dia 2 aprovado).
**Loop 2 provou:** Edge Functions gerar-questoes + feed-diario deployadas e validadas. Feed 70/30, 7 dias, 0 erros (Gate Dia 5 aprovado). SM-2 operacional.
**Loop 3 constrói sobre:** interface que conecta o que os Loops 1 e 2 construíram à mão da usuária final.

---

## 💡 PERSPECTIVA DO SÓCIO (AUDITOR — PARTE 2)

A Janela de Adesão Emocional é o risco real do Dia 8: se a interface for árida, Ingrid abandona antes de perceber o valor. As frases E-2 e E-5 não são decoração — são o mecanismo de retenção para este perfil específico. O Pixel de Latência (TTI) cria o ativo de dados que prova o ROI do Sovereign Study Engine para os próximos 50.000 candidatos Quadrix.

---

## 🔬 ANÁLISE CIRÚRGICA DO MÚSCULO — [G+N] QUALIFICADOS (P-034)

### Estrategista [G-1 a G-5] — Veredito técnico por ideia

| Ideia | Veredito | Onde entra |
|---|---|---|
| G-1 Inject Focus Override | **ENTRA modificado** — URL `?admin=<token>` em vez de gesto touch | Dia 7 |
| G-2 Telemetria de Hesitação (TTI) | **ENTRA** — `tempo_resposta_ms` no POST, 0.5h, zero degradação | Dia 7 |
| G-3 Distrator Vingativo em Loop | **V2** — 4h+, inviável no Gate Dia 8. Registrar P-034 para próximo loop | — |
| G-4 Clickwrap Termo de Uso | **ENTRA — PRIORIDADE MÁXIMA** — primeira tarefa Dia 6. Tabela `termos_aceitos` | Dia 6 |
| G-5 Cínico Socrático | **ENTRA** — `tone: "austere"` no system prompt. Teste com Diretor antes de entregar à Ingrid | Dia 7 |

### Auditor [N-1 a N-5] — Veredito técnico por ideia

| Ideia | Veredito | Onde entra |
|---|---|---|
| N-1 Clickwrap Front-end | **ENTRA** — convergência com G-4 confirma prioridade. Mesma implementação | Dia 6 |
| N-2 RPC get_total_respostas | **ENTRA** — stored procedure simples, alimenta E-5 sem payload móbile | Dia 7/8 |
| N-3 Debounce Anti-Duplicação | **ENTRA OBRIGATÓRIO** — usuária não-técnica em 4G vai tocar 3x. Sem debounce, 1 erro = orçamento do dia | Dia 7 |
| N-4 Sanitização Sessão Stale | **ENTRA** — `document.hidden` + reload silencioso após 4h | Dia 8 |
| N-5 Beacon Abandono | **ENTRA** — `navigator.sendBeacon` → `abandonment_log`. Dado crítico para Embaixador | Dia 8 |

---

## 💥 [M'-1 a M'-5] — NOVAS IDEIAS DO MÚSCULO (nascidas da análise cruzada G+N)

1. **M'-1 — Frase de Abertura Contextual:** abertura muda com desempenho recente. Se errou Constitucional ontem → *"Hoje atacamos o que travou você ontem."* Custo: 1h. Impacto: app parece que "conhece" a Ingrid.

2. **M'-2 — Score de Sobrevivência:** único número visível na tela principal — *"Você está a X questões do corte estimado."* Sem gráfico, sem dashboard. Urgência cirúrgica sem complexidade visual.

3. **M'-3 — Debug Mode Cirúrgico (`?debug=true`):** painel colapsável com questão ID, disciplina, peso SM-2, cache hit/miss, custo estimado Haiku. Diretor diagnostica no celular da Ingrid sem abrir Supabase.

4. **M'-4 — Graceful Degradation do Tutor:** se Edge Function falhar → exibe cache. Sem cache → exibe `explicacao_base` do banco. Zero tela branca. Ingrid nunca percebe que algo quebrou.

5. **M'-5 — Hash SHA-256 do Consentimento:** ao aceitar o Termo (Clickwrap), gera hash `SHA-256(user_id + timestamp + versao_termo)`. Log auditável além do timestamp — argumento jurídico reforçado para P-023.
