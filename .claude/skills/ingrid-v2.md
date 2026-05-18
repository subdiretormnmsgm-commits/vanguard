# Skill ingrid-v2.md — PROJ-002 Ingrid · Loop 3
> Gerada pelo Auditor (NotebookLM) · 2026-05-17
> Executar com /ingrid-v2 antes de qualquer deliberação do Loop 3

---

## PARTE 1 — AUDITORIA DE COERÊNCIA
> Fonte: DIRETRIZ_GEMINI_V2.txt · MEMORIA_V2_INGRID.md · WIP_BOARD.json · INTELLIGENCE_LEDGER P-001 a P-025

### Verificações obrigatórias (4 eixos do PASSO5)

**Eixo 1 — Arquitetura de batch (1 Claude call/invocação — nunca reverter)**
DIRETRIZ V2 está alinhada. Tutor Socrático = 1 Edge Function → 1 chamada Haiku → resposta em modal. Sem cadeia de chamadas, sem histórico de chat. Nenhum bloco da DIRETRIZ propõe multi-turn. ✅ SEM CONFLITO.

**Eixo 2 — Cargo 202 vs TDAS (P-024 — recalibração obrigatória)**
DIRETRIZ V2 usa "Cargo 202" corretamente em todo o texto. MEMORIA_V2 confirma recalibração executada em 2026-05-17. ✅ SEM CONFLITO.

**Eixo 3 — Deadline 2026-05-30 (10 dias restantes para 2 loops)**
Loop 3: Dias 6-8 (3 dias). Loop 4: Dias 9-11 (3 dias). Loop 5: Dias 12-15 (4 dias).
DIRETRIZ estima: PWA ~7h + Tutor+Cache ~5h + Fallback ~4h = 16h em 3 dias (~5,3h/dia). Viável se não houver escopo silencioso. ⚠️ ALERTA: qualquer feature não aprovada explicitamente quebra o prazo.

**Eixo 4 — Budget $5,00/dia (P-006 — Burn Rate Shield)**
max_tokens=200 aprovado (A-2). Cache de explicações aprovado (A-1, cache bidimensional por questao_id + alternativa_escolhida). Pílulas como subproduto do batch original aprovado (não nova chamada). ✅ ALINHADO.

### Conflitos detectados com decisões anteriores

**CONFLITO 1 — E-5: TTS / Web Speech API (VETO)**
A DIRETRIZ V2 propõe Web Speech API como "sem custo extra". Tecnicamente correto — é API nativa do navegador. Mas:
- P-016 (Soberania da Solução): MVP não adiciona dependências de comportamento de SO que variam por dispositivo.
- Suporte PT-BR no iOS Safari é inconsistente (confirmado por testes de mercado — comportamento diverge do Android Chrome).
- Adicionar TTS no Dia 7 ou 8 cria dívida técnica de debugging cross-device que consome as horas do prazo.
- **VETO do Auditor confirmado. E-5 vai para V2 com nota: testar em dispositivo real da Ingrid antes de qualquer implementação.**

**CONFLITO 2 — E-1: IndexedDB / Offline Sync (V2 confirmado)**
Complexity do Service Worker + Background Sync Manager excede orçamento de horas do Dia 6-7.
MEMORIA_V2 não registra nenhuma decisão sobre IndexedDB. A-3 (localStorage) é a alternativa validada pelo Auditor para este loop. **E-1 confirmado como V2.**

**CONFLITO 3 — E-4: visibilitychange / Dark Pattern (VETO ABSOLUTO)**
Já documentado em PARTE 2. Safari iOS não dispara `visibilitychange` de forma confiável. Bug silencioso P1 garantido. **VETO ABSOLUTO mantido.**

**CONFLITO 4 — E-2: Feynman Reversa (V2)**
Exige avaliação de resposta aberta pelo Claude Haiku — chamada não cacheável por definição. Custo variável e não controlável. Viola P-006 estruturalmente. **E-2 vai para V2 após Gate Dia 8 (se burn rate estiver sob controle).**

### O que a DIRETRIZ V2 acerta (não é complacência — é registro de alinhamento)
- Vanilla JS/CSS sem framework pesado: correto para prazo de 15 dias
- Modal de explicação pontual (não chatbot infinito): correto para P-006
- Pílulas como subproduto do batch Supabase (não nova chamada de LLM): correto
- Sequência PWA → Tutor → Fallback: correta por dependência técnica (UI precisa existir antes do Tutor)
- Single-user hardcoded: correto para MVP; P-013 (Soberania do Cliente) abordado em Dias 14-15

---

## PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR
> Mandato ativo: [P-022] Auditor Advogado · [P-021] Diretor Originador · [P-023] Contrato Pré-requisito

**Ponto cego 1 — Contratos são P0 ativo:**
O histórico V1-V5/V7 prova que entregar funcionalidades sem amarras comerciais gera refatoração pesada e conflitos. Ingrid e Valdece têm minutas geradas pelo Formalizador (2026-05-16) mas não assinadas. Sem contrato assinado, a promessa de "Soberania do Cliente" é área cinzenta: se Ingrid aprovar a PWA mas não houver termos definindo quem paga a API após o piloto, o projeto falha em escalar para SaaS.

**Ponto cego 2 — Auditor chega tarde sem Diff Diário:**
Na FALHA-PROCESSO-2026-05-17, o Músculo não auditou documentos e o NotebookLM foi incapaz de alertar a tempo. Para atuar ativamente, o session_close.ps1 deve injetar nas fontes um LOG_EXECUCAO_DIARIA.md (diff granular do que o Músculo alterou no dia). Sem visão do estado diário, auditorias sempre chegam atrasadas e o Diretor continua sendo fiscal.

**Veto formal — Ideia 4 do Estrategista (visibilitychange / Dark Pattern):**
Eventos de ciclo de vida do DOM no Safari (iOS) são instáveis e inconsistentes com Chrome (Android). Gerará bugs silenciosos convertidos em dívida técnica P1. VETO ABSOLUTO para os Dias 6-8. Interface deve ser simples e responsiva, sem interceptadores de SO no MVP.

---

## PARTE 3 — A SKILL COPIÁVEL

```skill
# SKILL — PROJ-002 Ingrid · Loop 3 · Dias 6-8
# Versão: ingrid-v2.md · Gerada: 2026-05-17

## CONTEXTO DO PROJETO

- Cliente: Ingrid (concurseira Sedes-DF 2026-09-06)
- Cargo: TDAS — Técnico Administrativo — Cargo 202 (P-024: recalibrado, nunca reverter)
- Banca: Instituto Quadrix
- Stack: PWA + Vanilla JS/CSS + Supabase (RLS single-user) + Claude API (Haiku + Sonnet)
- Banco: 460 questões geradas · 13 disciplinas · 70% Peso 2 / 30% Peso 1
- Burn Rate: $5,00/dia hard limit (P-006)
- Deadline: 2026-05-30 (10 dias restantes para 3 loops)
- Auth: single-user hardcoded · sem login complexo · user_id fixo no código
- Loop atual: #3 — Dias 6-8 (Interface + Tutor Socrático + Fallback Fadiga)

## DECISÕES FIXADAS (nunca reverter sem veredito do Diretor)

1. 1 Claude call por Edge Function — nunca multi-turn, nunca chain de chamadas
2. Cache de explicações: tabela `explicacao_tutor` com chave composta (questao_id, alternativa_escolhida)
3. max_tokens: 280 (Haiku) — obriga resposta direta, blinda contra tokens longos
4. Pílulas de revisão = subproduto do batch Supabase, não nova chamada de LLM
5. Progresso: "X/20 questões resolvidas" no header — sem 6 barras de disciplina no MVP
6. Lazy Loading: 3 questões no load inicial → resto em background enquanto Ingrid lê
7. localStorage para estado de sessão (IDs do dia + gabarito cacheado) — sem IndexedDB
8. Sleep-mode: inatividade >10 min congela chamadas assíncronas + botão "Retomar Estudo"

## CONEXÃO HISTÓRICA — O QUE OS LOOPS 1 E 2 PROVARAM

Loop 1 (Dias 1-2): Schema multi-tenant + Edge Function `gerar-questoes` + Gate CLI de qualidade
- Provou: Claude API gera questões válidas para o Cargo 202 sem scraping
- Provou: Gate de rubrica ≥4/5 é a única métrica confiável de qualidade

Loop 2 (Dias 3-5): Feed SM-2 + Edge Function `feed-diario` + Gate CLI Dia 5
- Provou: 70%/30% Peso 2/Peso 1 funciona — Gate Dia 5 APROVADO com 0 erros, 7 dias × 20 questões
- Provou: Recalibração P-024 foi obrigatória — Cargo 202 ≠ TDAS área social (8 disciplinas removidas)
- Provou: 1 Claude call/invocação é a arquitetura correta — nunca reverter
- Provou: MEMORIA + relatorio são obrigatórios ao fechar cada loop — ausência gera perda de contexto do Auditor

## PADRÃO DE SUCESSO VALIDADO

- Mágico de Oz antes do código: Gate CLI valida lógica antes de UI
- Edge Function simples: 1 entrada → 1 saída → 1 Claude call
- Batch + cache: gerar 50 quando <30 disponíveis — nunca gerar on-demand
- Sequência: esqueleto estático → injeção Supabase JS → lógica do Tutor (nessa ordem)

## PADRÃO DE FALHA DOCUMENTADO (7 panes do Loop 2)

1. [PANE-001] Edge Function `gerar-questoes` gerava questões para TDAS área social → corrigido por P-024
2. [PANE-002] Feed sem filtro de cargo retornava questões de outros cargos → corrigido por RLS no Supabase
3. [PANE-003] SM-2 calculava intervalo sem considerar peso da questão → corrigido por campo `peso` na query
4. [PANE-004] Proporção 70/30 falhava com menos de 10 questões disponíveis → corrigido por fallback para 50/50
5. [PANE-005] Gate CLI reportava sucesso antes de validar 7 dias completos → corrigido por loop de verificação
6. [PANE-006] MEMORIA_V2 não foi gerada ao fechar Loop 2 → Auditor chegou ao Loop 3 sem contexto real
7. [PANE-007] WIP_BOARD.json enviado ao NotebookLM como .json → corrigido para .txt

## PERSPECTIVA DO SÓCIO CONSULTOR

Ponto cego 1 (Contratos P0): Ingrid e Valdece têm minutas não assinadas (Formalizador 2026-05-16).
Sem assinatura, "Soberania do Cliente" é promessa sem amparo. P-023 ativo.

Ponto cego 2 (Auditor sem Diff Diário): session_close.ps1 não gera LOG_EXECUCAO_DIARIA.md.
Auditor audita com base em MEMORIA — mas MEMORIA captura o estado ao fechar, não o processo do dia.
Solução estrutural: session_close.ps1 deve gravar diff dos arquivos alterados na sessão.

Veto ativo (E-4 Dark Pattern / visibilitychange): Safari iOS instável → dívida P1 garantida. VETO ABSOLUTO.

## SEQUÊNCIA DE BUILD DIAS 6-8 (gates verificáveis)

### DIA 6 — PWA Estático com Mock de Dados
Sequência obrigatória:
1. Criar `index.html` com estrutura mobile-first (header contador, card questão, 4 botões alternativa)
2. CSS: Obsidian Black (#0A0A0A) + Cyber Cyan (#00F0FF) · touch-targets ≥ 48px · sem animações
3. Mock de 3 questões hardcoded no JS para validar layout
4. Lazy Loading: carregar mock[0:3] → simular fetch do resto em 2s
5. localStorage: salvar e recuperar IDs do dia + alternativa escolhida
6. Sleep-mode: setTimeout(10min) → overlay "Retomar Estudo"
7. Debug mode: `?debug=true` na URL exibe estado interno (feed, quota, cache)

**Gate Dia 6:** Eduardo abre o HTML no celular. Botões são fáceis de tocar. Layout não quebra em 375px.
Evidência: screenshot no celular ou confirmação verbal do Diretor.

### DIA 7 — Conexão Supabase + Tutor Socrático
Sequência obrigatória:
1. Substituir mock pelo Supabase JS client (CDN) — query `questoes_nao_respondidas` (view RLS)
2. Lazy Loading real: 3 questões no load → fetch restante em background (Promise.all)
3. Edge Function `tutor-socratico`: recebe (questao_id, alternativa_escolhida) → Haiku max_tokens=280
4. Tabela `explicacao_tutor`: INSERT ON CONFLICT DO NOTHING para cache bidimensional
5. Modal de explicação: ao errar → busca cache primeiro → se miss → chama Edge Function
6. Progresso no header: query simples `count(*)` de respostas do dia
7. Sanitização do localStorage no token expire (clearSensitiveStorage)

**Gate Dia 7:** Feed exibe questões reais do Cargo 202 · Cache funciona (2ª chamada = 0ms) · Progresso atualiza.
Evidência: console.log de cada etapa verificável + screenshot do feed real.

### DIA 8 — Fallback de Fadiga + Teste Completo
Sequência obrigatória:
1. View `daily_cost` → se ≥70% do limite → ativar "Modo Revisão"
2. Modo Revisão: bloqueia novas queries ao Tutor · exibe pílulas de revisão do localStorage
3. Modo Express (5 min): subset de 5 questões Peso 2 de maior urgência SM-2
4. Ingrid responde 10 questões reais: verificar SM-2 salvo + progresso correto
5. Teste de limite: simular daily_cost ≥ $3,50 → confirmar fallback ativa

**Gate Dia 8:** Ingrid responde 10 questões · progresso salvo · fallback testado com custo simulado.
Evidência: screenshot da sessão real + log do Supabase mostrando respostas inseridas.

## O QUE NÃO CONSTRUIR NESTE LOOP (com razão objetiva)

| Feature proibida | Razão |
|---|---|
| React / Vue / Next.js | Viola prazo de 15 dias — setup + bundle >4h |
| IndexedDB / Service Worker offline | Complexity excede orçamento Dias 6-7 · V2 |
| TTS / Web Speech API | PT-BR instável no iOS · P-016 · V2 |
| Feynman Reversa (avaliação aberta) | Claude call não cacheável · viola P-006 |
| visibilitychange Dark Pattern | Safari iOS instável · bug P1 garantido |
| Animações de página / transições | Drift de pixel em vez de conexão de dados |
| Configurações de perfil / tema dark/light | Escopo silencioso · fora do MVP |
| Gráficos Recharts / D3 | Peso de bundle · V2 (aba Raio-X) |
| Histórico de chat do Tutor | Viola arquitetura 1 call/invocação |
| Auth real (OAuth, magic link) | Single-user MVP · P-013 = Dias 14-15 |

## ALERTAS ATIVOS

[P-006] Burn Rate Shield: max_tokens=280 hard · cache obrigatório · fallback em 70% da cota
[P-010] Momentum de Execução: gate sem evidência = gate inválido · nunca declarar concluído sem output verificado
[P-023] Contrato P0: Ingrid e Valdece sem contrato assinado · alertar Diretor antes de cada handoff
[P-024] Recalibração Cargo: sempre Cargo 202 · nunca TDAS área social · verificar em toda nova Edge Function
[P-025] (se ativo): verificar no INTELLIGENCE_LEDGER antes de build
```

---

## PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR

**A-1 — Cache por Distrator Escolhido:**
Tabela de chave composta (questao_id, alternativa_escolhida) para cache do Tutor Haiku. Se Ingrid erra na "B" hoje e erra na "B" amanhã — cache retorna instantaneamente, zero custo de API.

**A-2 — Token-Capped Prompts (max_tokens = 200):**
Forçar max_tokens limitadíssimo na chamada do Haiku do Tutor Socrático. Obriga a IA a ser direta (estilo socrático) e blinda financeiramente contra respostas longas de forma estrutural.

**A-3 — Fallback via localStorage (Simplicidade Extrema):**
Salvar estado da sessão (IDs das 20 questões do dia + gabarito cacheado) como string única em localStorage. Evita recarga de dados se Ingrid minimizar o navegador — sem a complexidade do IndexedDB.

**A-4 — Lazy Loading 3+resto:**
Frontend baixa as 3 primeiras questões. Enquanto Ingrid lê a primeira, o PWA busca o resto em background. Percepção de latência = zero sem estressar a query inicial do Supabase.

**A-5 — Sleep-Mode de Sessão (Kill-Switch Front-end):**
Inatividade de toque por >10 minutos congela chamadas assíncronas para a Edge Function e exige botão "Retomar Estudo". Evita que o Tutor seja ativado acidentalmente no bolso esgotando o Burn Rate Shield.

**A-6 — RPC de Progresso por Disciplina (Otimização de Query):**
Em vez do frontend calcular percentuais de acerto percorrendo todo o histórico, criar uma função RPC no Supabase (`get_progresso_disciplinas`) que retorna apenas os inteiros prontos. Corta transferência de dados em 90% e resolve a latência mobile sem IndexedDB. O Músculo e o Estrategista não propuseram isso porque estavam focados no Tutor — mas é a fundação para o Heatmap do Loop 4 (Dia 9-11) sem refatoração.

**A-7 — Sanitização Automática do LocalStorage (Segurança de Dados):**
PWA single-user guarda token e IDs do dia no localStorage. Se o dispositivo de Ingrid for acessado por terceiros (familiar, colega), esses dados ficam expostos. Implementar `clearSensitiveStorage()` chamado na expiração do token e no session_close — 3-4 linhas de JS. Atende P-023 parcialmente: mesmo sem contrato assinado, o sistema protege os dados da usuária.

**A-8 — Injeção de Status de Quota no Response Header (Anti-Polling):**
Em vez do frontend fazer query periódica à view `daily_cost` para saber se ativou o fallback de fadiga, a Edge Function do Tutor injeta `X-Fallback-Active: true/false` no response header de toda chamada. Frontend lê o header e atualiza o estado de quota instantaneamente — zero roundtrip extra, zero polling. O Músculo propôs fallback por query à view; o Auditor propõe tornar o próprio fluxo do Tutor o veículo de atualização do status.
