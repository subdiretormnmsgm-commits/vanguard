# PASSO 5 — AUDITOR (NOTEBOOKLM) · PROJETO INGRID · LOOP 5
> Pentalateral IAH — Camada Permanente: não editar blocos de protocolo.
> Atualizado pelo Músculo em 2026-05-26 (Loop 5 / Diretriz V6)

---

## ANTES DE IR AO NOTEBOOKLM — checklist obrigatório

```
[x] 1. DIRETRIZ_GEMINI_V6.txt recebida e salva em CLIENTES\INGRID\
[x] 2. Rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
[x] 3. Explorer abre automaticamente — Ctrl+A → arrastar TUDO ao NotebookLM
[ ] 4. Fazer Wipe & Sync das fontes (apagar antigas antes de subir as novas)
[ ] 5. Colar o COMANDO CURTO no chat (não o arquivo inteiro — ele já está nas fontes)
```

> Sem o Wipe & Sync, o Auditor mistura contexto do Loop 4 com o Loop 5.
> Auditor com fontes velhas = Skill que contradiz o que já foi construído.

### COMANDO CURTO — colar no chat do NotebookLM

```
Auditor, você opera no Pentalateral IAH — 5 membros ativos desde 2026-05-18: Diretor, Músculo, Estrategista, Auditor e Embaixador. O Embaixador (Claude Projects) acompanha a cliente Ingrid em tempo real e suas hipóteses sobre comportamento e perfil estão no arquivo 14_MEMORIA_EMBAIXADOR.md — leia-o como filtro de realidade antes de validar qualquer sugestão. Leia o arquivo 13_PASSO5_NOTEBOOKLM.md das fontes carregadas detalhadamente e execute todas as instruções contidas nele. Missão principal: gerar a Skill ingrid-v5.md — o Músculo não inicia o Loop 5 sem ela.
```

> O arquivo já está nas fontes — não colar o conteúdo inteiro no chat.

---

## AO RECEBER O OUTPUT DO AUDITOR — ANTES DE SAIR DO NOTEBOOKLM (P-049)

O NotebookLM entrega 4 partes. Você vai copiar só a PARTE 3 para o arquivo skill.
As PARTES 1, 2 e 4 são **irrecuperáveis** depois que você fechar a sessão.

```
Antes de sair:
☐ Copiar PARTES 1 + 2 + 4 completas (tudo exceto a Skill)
☐ Salvar em: CLIENTES/INGRID/HISTORICO/AUDITOR_LOOP_5_INGRID.md
☐ Copiar PARTE 3 (Skill) para: .claude/skills/ingrid-v5.md
☐ Rodar: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\ingrid-v5.md"
```

> PARTES 1+2+4 não salvas = Músculo delibera sem [N-1 a N-5] + Auditoria = 20 inputs, não 25.

---

## PROTOCOLO ANTI-ALUCINAÇÃO (ler antes de processar)

Auditor, você opera com 4 deficiências nativas:

| Deficiência | Gatilho de Alerta |
|---|---|
| Amnésia de Contexto | Tratar o projeto como Dia 1 sem MEMORIA |
| Alucinação Estrutural (P-007) | Skill com blocos genéricos sem dados reais do projeto |
| Síndrome do Yes-Man | Validar a DIRETRIZ do Gemini sem questionar |
| Lost-in-the-Middle | Ignorar OVERRIDE recente e aplicar regra V1 |

**Remédio:** "🚨 ALERTA: Auditor alucinou. Gatilho de Calibração ativado."

---

## COMPENSAÇÃO DAS DEFICIÊNCIAS DO MÚSCULO

Ao gerar a Skill, compense ativamente:

1. **Amnésia de Sessão** → listar princípios do LEDGER (P-001 a P-066) que o Músculo deve citar ao deliberar
2. **Momentum de Execução** → gates verificáveis por dia — sem output real = gate inválido
3. **Otimismo de Estimativa** → comparar estimativas com loops anteriores; Circuit Breaker preventivo se subestimar
4. **Escopo Silencioso** → listar explicitamente o que NÃO construir neste loop
5. **Drift de Formato** → exigir os 7 pontos de deliberação; sem formato = deliberação rejeitada

---

## CONTEXTO DO PROJETO

**Projeto:** Ingrid — Ferramenta de Estudo Sedes-DF
**Nicho:** EdTech / Concursos Públicos
**Stack:** PWA Vanilla JS + Supabase + Claude API (Haiku + Sonnet) · GitHub Pages
**Prova final:** 2026-09-06 · **Deadline do projeto:** 2026-05-30 (4 dias restantes)

**Loop:** #5 — Dias 12-13 — CONCLUÍDO (build feito em 2026-05-23)
**O que foi entregue:**
- Widget Contador: pontosBase (Supabase) + pontosAcumulados (sessão) no header
- Push dominical: banner slideDown + Notification API (iOS excluído via isIosSafari())
- Deploy v14 GitHub Pages — smoke test 5/5 PASSOU
- Gate Dia 13: aguardando aprovação de Ingrid

**Gates aprovados:**
- Dia 2: qualidade das questões
- Dia 5: feed 70/30 funcional (7 dias, 0 erros)
- Dia 8: PWA completo — Clickwrap + Tutor 3 níveis + Fallback + TTI (APROVADO 2026-05-19)
- Dia 11: Heatmap + Micro-Simulado funcional (APROVADO 2026-05-20)
- Dia 13: Widget Contador + Push dominical — DEPLOY OK · aprovação cliente pendente

**Próximo gate:** Dia 15 — Ingrid com acesso admin ao próprio Supabase (2026-05-30)

**Banco:** 460 questões · 13 disciplinas · Cargo 202 (Instituto Quadrix)
**Temperatura da cliente:** VERDE CONSOLIDANDO

**Restrições ativas (VETO absoluto):**
- P-045: zero tela de login para Ingrid
- P-038: Micro-Simulado só recicla questões SM-2 (já vistas)
- P-003: sem scraping — questões via Claude API apenas
- Burn Rate: `BURN_RATE_DAILY_LIMIT_USD=5.00`
- P-007: validar toda RPC/Edge via CLI antes da UI
- LEGAL-WATCH: PDF do Termo datado 30/05 mas assinado em 18/05 — resolver antes do Dia 14

**Missão do Auditor neste loop:**
> "Auditor, você recebeu a DIRETRIZ_GEMINI_V6 para o Loop 5 do Projeto Ingrid.
> O Músculo construiu o Widget de Pontos Ponderados e as Notificações Push (Dias 12-13).
> Sua missão: auditar a DIRETRIZ cruzando com o histórico real das fontes.
> Identifique: (1) o que contradiz princípios ativos do LEDGER ou decisões já tomadas,
> (2) o que já falhou em projetos anteriores,
> (3) o que o Estrategista está ignorando — especialmente o risco legal do Termo mal datado.
> Ponto crítico: Push via Service Worker em iOS Safari — limitação estrutural ou foi contornada?
> Não valide por momentum. Discorde quando tiver evidência histórica."

---

## MISSÃO CRÍTICA — GERAR A SKILL ingrid-v5.md

**Após processar as fontes e a missão acima, gere a Skill completa em 4 partes obrigatórias.**

O nome exato da Skill: **`ingrid-v5.md`**

O Músculo vai executar `/ingrid-v5` antes de qualquer deliberação do Loop 5.
Skill sem os 4 blocos com dados reais = Skill rejeitada. Músculo não inicia o build sem Skill válida.

---

## FORMATO OBRIGATÓRIO DA SKILL (4 partes — sem exceção)

```
PARTE 1 — AUDITORIA DE COERÊNCIA
  A DIRETRIZ V6 contradiz algo já construído ou decidido nos Loops 1-5?
  Citar: fonte exata (arquivo, princípio, versão). Sem dado real = bloco inválido.
  Verificar especificamente:
    - P-045: zero login para Ingrid (NUNCA reverter)
    - P-038: Micro-Simulado só recicla SM-2 (já vistas)
    - Burn Rate $5/dia (P-006)
    - Deadline 2026-05-30 (4 dias restantes)
    - LEGAL-WATCH: Termo datado 30/05 / assinado 18/05 — risco antes do Dia 14
    - Push iOS: isIosSafari() excluída — confirmado ou fallback modal ativo?

PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR
  O que funciona em projetos similares (citar projeto + resultado).
  O que falha (citar projeto + razão documentada).
  O que este projeto tem de diferente que muda o padrão.
  O que Gemini e Músculo não estão vendo — discordância fundamentada.

PARTE 3 — A SKILL (copiável para .claude/skills/ingrid-v5.md)
  ⚠️ GATE OBRIGATÓRIO: a Skill DEVE conter estes 4 títulos de seção EXATOS (sem acentos).
  O script skill_parser_gate.ps1 verifica esses textos — Skill sem eles = REJEITADA:

    ## [AUDITORIA DE COERENCIA]
    ## [CONEXAO HISTORICA]
    ## [PADRAO DE SUCESSO/FALHA]
    ## [PERSPECTIVA DO SOCIO]

  Conteúdo obrigatório por seção:
    [AUDITORIA DE COERENCIA]  — alertas VETO do LEDGER (P-003, P-006, P-007, P-038, P-045, P-055) + LEGAL-WATCH
    [CONEXAO HISTORICA]       — o que os Loops 1-4 provaram (decisões fixadas, stack, gates aprovados)
    [PADRAO DE SUCESSO/FALHA] — o que funcionou + o que falhou + sequência de build com gates verificáveis
    [PERSPECTIVA DO SOCIO]    — o que o Auditor vê que os outros não veem + discordância fundamentada

PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR
  Ideias que NÃO vieram do Gemini nem do Músculo — perspectiva histórica exclusiva.
  Cada uma fundamentada em padrão de projeto anterior ou princípio do LEDGER.
  Formato: o que é + impacto + por que o Músculo não propôs isso.
```

**Validação antes de entregar:**
- [ ] Skill tem nome exato `ingrid-v5.md` declarado na PARTE 3
- [ ] PARTE 3 contém os 4 títulos EXATOS: `[AUDITORIA DE COERENCIA]`, `[CONEXAO HISTORICA]`, `[PADRAO DE SUCESSO/FALHA]`, `[PERSPECTIVA DO SOCIO]`
- [ ] PARTE 1 cita fontes reais (não genéricas)
- [ ] PARTE 4 tem 5 ideias exclusivas do Auditor
- [ ] Skill é copiável diretamente para `.claude/skills/`

---

## ⛔ PRÓXIMO PASSO APÓS RECEBER O OUTPUT — BLOQUEANTE

```
ORDEM INVIOLÁVEL — MÚSCULO NÃO DELIBERA SEM OS 3 SÓCIOS:

  1. NotebookLM → ingrid-v5.md        ← você está aqui
  2. Embaixador → SEÇÃO D             ← OBRIGATÓRIO ANTES DO MÚSCULO
  3. Músculo → síntese P-037          ← só depois dos dois acima

AÇÃO APÓS RECEBER SKILL:
  → Atualizar [N-1 a N-5] no PASSO7_EMBAIXADOR.md SEÇÃO D com as ideias do Auditor
  → Ativar Embaixador: .\scripts\ir_ao_embaixador.ps1 -cliente INGRID
  → Colar SEÇÃO D (com [M]+[G]+[N] completos) no Claude Projects
  → Só depois trazer output do Embaixador ao Músculo
```

---

## COMO CARREGAR AS FONTES (V25 — pasta única)

```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
```

O script monta `CLIENTES/INGRID/NOTEBOOKLM_FONTES/` e abre o Explorer automaticamente.
Selecionar tudo (Ctrl+A) → arrastar ao NotebookLM → Wipe & Sync → colar COMANDO CURTO.

Ordem dos documentos:

```
--- UNIVERSAIS ---
00_INSTRUCAO_AUDITOR.md
01_SKILL_PROTOCOLO_VANGUARD.md
02_MEMORANDO_PENTALATERAL_UNIVERSAL.md
03_MANUAL_DIRETOR.md
04_INTELLIGENCE_LEDGER.md
05_PROCESSO_EVOLUTIVO_PENTALATERAL.md
06_TEMPLATES_COMUNICACAO_PENTALATERAL.md
07_WIP_BOARD.txt
08_ANALISE_SOCIO_ATUAL.txt

--- PROJETO INGRID ---
09_BRIEFING_DISCOVERY.txt          ← dor real da cliente
10_MEMORIA_RECENTE.md              ← MEMORIA_V4_INGRID.md (Loop 4)
11_RELATORIO_EVOLUTIVO.md          ← relatorio_evolutivo_V4_INGRID.md (Loop 4)
12_DIRETRIZ_GEMINI.txt             ← DIRETRIZ_GEMINI_V6 ← OBRIGATÓRIO
13_PASSO5_NOTEBOOKLM.md            ← este arquivo (missão do Auditor)
14_MEMORIA_EMBAIXADOR.md           ← inteligência Embaixador sobre Ingrid ← FILTRO DE REALIDADE
15_SKILL_ANTERIOR.md               ← não existe ainda (Loop 5 = primeiro uso)
16_ALERTA_CONFLITO.md
17_VANGUARD_TIMELINE.md
18_ATUALIZACAO_PENTALATERAL_2026-05-24.md
```
