# PASSO 5 — AUDITOR (NOTEBOOKLM) · PROJETO INGRID · LOOP 6
> Pentalateral IAH — Camada Permanente: não editar blocos de protocolo.
> Atualizado pelo Musculo em 2026-05-29 (Loop 6 / Diretriz V7)

---

## ANTES DE IR AO NOTEBOOKLM — checklist obrigatório

```
[ ] 1. DIRETRIZ_GEMINI_V7.txt recebida e salva em CLIENTES\INGRID\
[x] 2. Rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
[x] 3. Explorer abre automaticamente — Ctrl+A → arrastar TUDO ao NotebookLM
[ ] 4. Fazer Wipe & Sync das fontes (apagar antigas antes de subir as novas)
[ ] 5. Colar o COMANDO CURTO no chat (não o arquivo inteiro — ele já está nas fontes)
```

> Sem o Wipe & Sync, o Auditor mistura contexto do Loop 5 com o Loop 6.
> Auditor com fontes velhas = Skill que contradiz o que já foi construído.

### COMANDO CURTO — colar no chat do NotebookLM

```
Auditor, você opera no Pentalateral IAH — 5 membros ativos desde 2026-05-18: Diretor, Músculo, Estrategista, Auditor e Embaixador. O Embaixador (Claude Projects) acompanha a cliente Ingrid em tempo real e suas hipóteses sobre comportamento e perfil estão no arquivo 14_MEMORIA_EMBAIXADOR.md — leia-o como filtro de realidade antes de validar qualquer sugestão. Leia o arquivo 13_PASSO5_NOTEBOOKLM.md das fontes carregadas detalhadamente e execute todas as instruções contidas nele. Missão principal: gerar a Skill ingrid-v7.md — o Músculo não inicia o Loop 6 sem ela.
```

> O arquivo já está nas fontes — não colar o conteúdo inteiro no chat.

---

## AO RECEBER O OUTPUT DO AUDITOR — ANTES DE SAIR DO NOTEBOOKLM (P-049)

O NotebookLM entrega 4 partes. Você vai copiar só a PARTE 3 para o arquivo skill.
As PARTES 1, 2 e 4 são **irrecuperáveis** depois que você fechar a sessão.

```
Antes de sair:
☐ Copiar PARTES 1 + 2 + 4 completas (tudo exceto a Skill)
☐ Salvar em: CLIENTES/INGRID/HISTORICO/AUDITOR_LOOP_6_INGRID.md
☐ Copiar PARTE 3 (Skill) para: .claude/skills/ingrid-v7.md
☐ Rodar: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\ingrid-v7.md"
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

1. **Amnésia de Sessão** → listar princípios do LEDGER (P-001 a P-079) que o Músculo deve citar ao deliberar
2. **Momentum de Execução** → gates verificáveis por dia — sem output real = gate inválido
3. **Otimismo de Estimativa** → comparar estimativas com loops anteriores; Circuit Breaker preventivo se subestimar
4. **Escopo Silencioso** → listar explicitamente o que NÃO construir neste loop
5. **Drift de Formato** → exigir os 7 pontos de deliberação; sem formato = deliberação rejeitada

---

## CONTEXTO DO PROJETO

**Projeto:** Ingrid — Ferramenta de Estudo Sedes-DF
**Nicho:** EdTech / Concursos Públicos
**Stack:** PWA Vanilla JS + Supabase + Claude API (Haiku + Sonnet) · GitHub Pages
**Prova final:** 2026-09-06 · **Deadline do projeto:** 2026-05-30 (1 dias restantes)

**Loop:** #6 — SaaS Readiness + Pipeline Comercial — EM ANDAMENTO (2026-05-29)
**O que foi entregue no Loop 5 (V6):**
- F-1 Saudação Noturna Dinâmica (v19)
- F-2 Distração Vingativa Silenciosa — pegadinhas sem label
- F-4 Gatilho Temporal 19h45 + pg_cron (deploy CLI pendente)
- F-5 Modo Véspera — ativar 2026-08-30
- F-6 Relatório Semanal WhatsApp Haiku (deploy CLI pendente)
- F-7 Raio-X SVG + Brasão Semanal
- F-8 Termômetro da Aprovação

**DADOS-WATCH:** VERDE — 102 registros · 1 user_id · SM-2/Heatmap/Termômetro íntegros
**LEGAL-WATCH:** VERDE — Termo de Uso reassinado 2026-05-27

**Gates aprovados (todos os 15 dias):** Loop 1 a Loop 5 APROVADOS (último: 2026-05-26)

**Próximos gates (Loop 6):**
- GATE 01: supabase login + deploy F-4/F-6 (BLOQUEANTE)
- GATE 02: GitHub Pages push unblock
- GATE 03: Script E-4 WhatsApp Ingrid

**Banco:** 460 questões · 13 disciplinas · Cargo 202 (Instituto Quadrix)
**Prova final:** 2026-09-06 · **Temperatura da cliente:** VERDE SUSTENTADO 7.5/10

**Restrições ativas (VETO absoluto):**
- NUNCA alterar SM-2 ou Heatmap sem nova validação (HV-1)
- NUNCA nova UI antes de auditar RLS multi-tenant (HV-2 · P-059)
- NUNCA telas de configuração, recuperação de senha ou cadastros externos (P-070)
- NUNCA gateway de pagamento real (Stripe/Asaas) neste repositório
- NUNCA reconstituir F-1 a F-8 — DADOS-WATCH VERDE é prova de integridade

**Missão do Auditor neste loop:**
> "Auditor, você recebeu a DIRETRIZ_GEMINI_V7 para o Loop 6 do Projeto Ingrid.
> O Músculo deve executar os 3 GATES antes de qualquer feature nova.
> Sua missão: auditar as 5 ideias aprovadas (M-1 a M-5) cruzando com o histórico.
> Identifique: (1) o que contradiz princípios do LEDGER ou decisões fixadas,
> (2) qual das 5 ideias tem maior impacto comercial para o segundo cliente,
> (3) o que o Estrategista pode ter ignorado sobre o comportamento real da Ingrid.
> Ponto crítico: F-4 e F-6 operando manualmente — GATE 01 antes de qualquer feature.
> Não valide por momentum. Discorde quando tiver evidência histórica."

---

## MISSÃO CRÍTICA — GERAR A SKILL ingrid-v7.md

**Após processar as fontes e a missão acima, gere a Skill completa em 4 partes obrigatórias.**

O nome exato da Skill: **`ingrid-v7.md`**

O Músculo vai executar `/ingrid-v7` antes de qualquer deliberação do Loop 6.
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
    - Deadline 2026-05-30 (1 dias restantes)
    - LEGAL-WATCH: Termo datado 30/05 / assinado 18/05 — risco antes do Dia 14
    - Push iOS: isIosSafari() excluída — confirmado ou fallback modal ativo?

PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR
  O que funciona em projetos similares (citar projeto + resultado).
  O que falha (citar projeto + razão documentada).
  O que este projeto tem de diferente que muda o padrão.
  O que Gemini e Músculo não estão vendo — discordância fundamentada.

PARTE 3 — A SKILL (copiável para .claude/skills/ingrid-v7.md)
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
- [ ] Skill tem nome exato `ingrid-v7.md` declarado na PARTE 3
- [ ] PARTE 3 contém os 4 títulos EXATOS: `[AUDITORIA DE COERENCIA]`, `[CONEXAO HISTORICA]`, `[PADRAO DE SUCESSO/FALHA]`, `[PERSPECTIVA DO SOCIO]`
- [ ] PARTE 1 cita fontes reais (não genéricas)
- [ ] PARTE 4 tem 5 ideias exclusivas do Auditor
- [ ] Skill é copiável diretamente para `.claude/skills/`

---

## ⛔ PRÓXIMO PASSO APÓS RECEBER O OUTPUT — BLOQUEANTE

```
ORDEM INVIOLÁVEL — MÚSCULO NÃO DELIBERA SEM OS 3 SÓCIOS:

  1. NotebookLM → ingrid-v7.md        ← você está aqui
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
10_MEMORIA_RECENTE.md              ← MEMORIA_V4_INGRID.md (Loop 5)
11_RELATORIO_EVOLUTIVO.md          ← relatorio_evolutivo_V4_INGRID.md (Loop 5)
12_DIRETRIZ_GEMINI.txt             ← DIRETRIZ_GEMINI_V6 ← OBRIGATÓRIO
13_PASSO5_NOTEBOOKLM.md            ← este arquivo (missão do Auditor)
14_MEMORIA_EMBAIXADOR.md           ← inteligência Embaixador sobre Ingrid ← FILTRO DE REALIDADE
15_SKILL_ANTERIOR.md               ← não existe ainda (Loop 5 = primeiro uso)
16_ALERTA_CONFLITO.md
17_VANGUARD_TIMELINE.md
18_ATUALIZACAO_PENTALATERAL_2026-05-24.md
```




