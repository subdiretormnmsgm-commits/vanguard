# PASSO 5 — AUDITOR (NOTEBOOKLM) · PROJETO INGRID · LOOP 7
> Pentalateral IAH — Camada Permanente: não editar blocos de protocolo.
> Atualizado pelo Músculo em 2026-05-30 (Loop 7 / Diretriz V7)

---

## ANTES DE IR AO NOTEBOOKLM — checklist obrigatório

```
[x] 1. DIRETRIZ_GEMINI_V7.txt recebida e salva em CLIENTES\INGRID\NOTEBOOKLM_FONTES\
[ ] 2. Rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
[ ] 3. Explorer abre automaticamente — Ctrl+A → arrastar TUDO ao NotebookLM
[ ] 4. Fazer Wipe & Sync das fontes (apagar antigas antes de subir as novas)
[ ] 5. Colar o COMANDO CURTO no chat (não o arquivo inteiro — ele já está nas fontes)
```

> Sem o Wipe & Sync, o Auditor mistura contexto do Loop 6 com o Loop 7.
> Auditor com fontes velhas = Skill que contradiz o que já foi construído.

### COMANDO CURTO — colar no chat do NotebookLM

```
Auditor, você opera no Pentalateral IAH — 5 membros ativos: Diretor, Músculo, Estrategista, Auditor e Embaixador. O Embaixador (Claude Projects) acompanha a cliente Ingrid em tempo real e suas hipóteses sobre comportamento e perfil estão no arquivo 14_MEMORIA_EMBAIXADOR.md — leia-o como filtro de realidade antes de validar qualquer sugestão. Leia o arquivo 13_PASSO5_NOTEBOOKLM.md das fontes carregadas detalhadamente e execute todas as instruções contidas nele. Missão principal: gerar a Skill ingrid-v7.md — o Músculo não inicia o Loop 7 sem ela.
```

> O arquivo já está nas fontes — não colar o conteúdo inteiro no chat.

---

## AO RECEBER O OUTPUT DO AUDITOR — ANTES DE SAIR DO NOTEBOOKLM (P-049)

O NotebookLM entrega 4 partes. Você vai copiar só a PARTE 3 para o arquivo skill.
As PARTES 1, 2 e 4 são **irrecuperáveis** depois que você fechar a sessão.

```
Antes de sair:
☐ Copiar PARTES 1 + 2 + 4 completas (tudo exceto a Skill)
☐ Salvar em: CLIENTES/INGRID/HISTORICO/AUDITOR_LOOP_7_INGRID.md
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

1. **Amnésia de Sessão** → listar princípios do LEDGER (P-001 a P-091) que o Músculo deve citar ao deliberar
2. **Momentum de Execução** → gates verificáveis por dia — sem output real = gate inválido
3. **Otimismo de Estimativa** → comparar estimativas com loops anteriores; Circuit Breaker preventivo se subestimar
4. **Escopo Silencioso** → listar explicitamente o que NÃO construir neste loop
5. **Drift de Formato** → exigir os 7 pontos de deliberação; sem formato = deliberação rejeitada

---

## CONTEXTO DO PROJETO

**Projeto:** Ingrid — Ferramenta de Estudo SEDES-DF · Cargo 202 Técnico Administrativo
**Nicho:** EdTech / Concursos Públicos · **Banca:** Instituto Quadrix
**Stack:** PWA Vanilla JS + Supabase próprio da Ingrid (`yjqvjhezwhepwomukudt`) + Claude API · GitHub Pages
**Prova final:** 2026-09-06 (~99 dias) · **URL produção:** https://subdiretormnmsgm-commits.github.io/vanguard/

**Loop:** #7 — SaaS Readiness + Pipeline Comercial + Deploy CLI — EM ANDAMENTO (2026-05-30)

**Estado técnico pós-Loop 6 (v20 em produção):**

| Feature | Status |
|---|---|
| F-1 Saudação Noturna Dinâmica | Ativa — "Boa noite, N questões te esperam" |
| F-2 Distração Vingativa Silenciosa | Ativa — pegadinhas sem label visível |
| F-4 Gatilho Temporal 19h45 + pg_cron | Código entregue — **deploy CLI PENDENTE** |
| F-5 Modo Véspera | Ativo — ativar em 2026-08-30 |
| F-6 Relatório Semanal WhatsApp | Código entregue — **deploy CLI PENDENTE** |
| F-7 Raio-X SVG + Brasão | Ativo — html2canvas export PNG |
| F-8 Termômetro da Aprovação | Ativo — Nota Projetada vs Linha de Corte |
| SM-2 + Heatmap | Ativos — 102 respostas · 1 user_id · VERDE |

**DADOS-WATCH:** VERDE · 102 registros · 1 user_id · SM-2/Heatmap/Termômetro íntegros
**LEGAL-WATCH:** VERDE · Termo de Uso reassinado 2026-05-27 · P-013 VERDE (Ingrid admin do próprio Supabase)
**Temperatura da cliente:** 7.5/10 VERDE SUSTENTADO · "Gostei bastante. Amanhã volto para atacar mais" (2026-05-24)

**Gates aprovados (todos os dias 1–15):** Loops 1–4 APROVADOS (último: dia15 2026-05-30)

**Gates do Loop 7:**
- GATE 7.1: supabase login + deploy F-4/F-6 no projeto Ingrid (BLOQUEANTE)
- GATE 7.2: Auditoria RLS — query confirma isolamento total de tenants
- GATE 7.3: Painel de uso real renderizando eventos de telemetria de Ingrid

**Banco:** 460+ questões · 13 disciplinas · Cargo 202 Quadrix

---

## IDEIAS DO ESTRATEGISTA [G-1 a G-5] — DIRETRIZ V7 — REAGIR A CADA UMA

| # | Ideia | Verificar com |
|---|---|---|
| G-1 | Safe-Horizon SM-2 Adaptativo (modo manutenção se prova atrasar para 2027) | P-009 cadência de loops; comportamento sob carga reduzida |
| G-2 | Dry-Run Isolamento de Tenant — `test_tenant_isolation.ps1` | P-059 isolamento de contexto por cliente |
| G-3 | Mapeador de Replicabilidade Quadrix (próximo nicho com 80%+ similaridade) | P-015 cross-concurso; pipeline comercial |
| G-4 | Telemetria Passiva por Evento de Componente (F-7, F-8 — heartbeat silencioso) | P-013 soberania; LGPD |
| G-5 | Git Hook pre-push Antiamnésia (P-045) — bloqueia push sem MEMORIA + relatorio | P-045; P-091 |

**ALERTA GEMINI recebido:** Deploy CLI é urgência #1 — F-4/F-6 manuais falham no primeiro domingo e destroem a primeira impressão do sistema autônomo.

---

## MISSÃO CRÍTICA — GERAR A SKILL ingrid-v7.md

**Após processar as fontes e a missão acima, gere a Skill completa em 4 partes obrigatórias.**

O nome exato da Skill: **`ingrid-v7.md`**

O Músculo vai executar `/ingrid-v7` antes de qualquer deliberação do Loop 7.
Skill sem os 4 blocos com dados reais = Skill rejeitada. Músculo não inicia o build sem Skill válida.

---

## FORMATO OBRIGATÓRIO DA SKILL (4 partes — sem exceção)

```
PARTE 1 — AUDITORIA DE COERÊNCIA
  A DIRETRIZ V7 contradiz algo já construído ou decidido nos Loops 1-6?
  Citar: fonte exata (arquivo, princípio, versão). Sem dado real = bloco inválido.
  Verificar especificamente:
    - G-3 Bloqueio TTL e G-1 Simulador Invalidação: VETADOS PERMANENTES — não reabrir
    - Deploy CLI antes de qualquer feature (F-4 + F-6 manuais = risco de falha no domingo)
    - RLS: tabelas progresso_usuario e evento_uso isoladas por user_id?
    - P-091: WIP_BOARD só marca OK com artefato em disco
    - Burn Rate $5/dia (P-006) — G-4 telemetria não adiciona custo de API
    - P-059: isolamento de contexto Ingrid vs Valdece — NUNCA cruzar dados

PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR
  O que funciona em projetos similares (citar projeto + resultado).
  O que falha (citar projeto + razão documentada).
  O que este projeto tem de diferente que muda o padrão.
  O que Gemini e Músculo não estão vendo — discordância fundamentada.
  Foco especial: qual das 5 ideias (G-1 a G-5) tem maior risco para Ingrid vs maior oportunidade para escala?

PARTE 3 — A SKILL (copiável para .claude/skills/ingrid-v7.md)
  ⚠️ GATE OBRIGATÓRIO: a Skill DEVE conter estes 4 títulos de seção EXATOS (sem acentos).
  O script skill_parser_gate.ps1 verifica esses textos — Skill sem eles = REJEITADA:

    ## [AUDITORIA DE COERENCIA]
    ## [CONEXAO HISTORICA]
    ## [PADRAO DE SUCESSO/FALHA]
    ## [PERSPECTIVA DO SOCIO]

  Conteúdo obrigatório por seção:
    [AUDITORIA DE COERENCIA]  — alertas VETO do LEDGER + decisões fixadas Loop 1-6 + G-3/G-1 VETADOS
    [CONEXAO HISTORICA]       — o que os Loops 1-6 provaram (stack, gates, comportamento Ingrid)
    [PADRAO DE SUCESSO/FALHA] — o que funcionou + o que falhou + sequência Loop 7 com gates verificáveis
    [PERSPECTIVA DO SOCIO]    — o que o Auditor vê que os outros não veem + discordância fundamentada

PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR [N-1 a N-5]
  Ideias que NÃO vieram do Gemini nem do Músculo — perspectiva histórica exclusiva.
  Cada uma fundamentada em padrão de projeto anterior ou princípio do LEDGER.
  Formato: o que é + impacto + por que o Músculo não propôs isso.
```

**Validação antes de entregar:**
- [ ] Skill tem nome exato `ingrid-v7.md` declarado na PARTE 3
- [ ] PARTE 3 contém os 4 títulos EXATOS sem acentos
- [ ] PARTE 1 cita fontes reais (não genéricas)
- [ ] PARTE 4 tem 5 ideias [N-1 a N-5] exclusivas do Auditor
- [ ] Skill é copiável diretamente para `.claude/skills/`

---

## ⛔ PRÓXIMO PASSO APÓS RECEBER O OUTPUT — BLOQUEANTE

```
ORDEM INVIOLÁVEL — MÚSCULO NÃO DELIBERA SEM OS 3 SÓCIOS:

  1. NotebookLM → ingrid-v7.md        ← você está aqui
  2. Embaixador → SEÇÃO D             ← OBRIGATÓRIO ANTES DO MÚSCULO
  3. Músculo → síntese P-037          ← só depois dos dois acima

AÇÃO APÓS RECEBER SKILL:
  → Rodar: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\ingrid-v7.md"
  → Atualizar [N-1 a N-5] no PASSO7_EMBAIXADOR.md SEÇÃO D com as ideias do Auditor
  → Ativar Embaixador: .\scripts\ir_ao_embaixador.ps1 -cliente INGRID
  → Colar SEÇÃO D (com [M]+[G]+[N] completos) no Claude Projects
  → Só depois trazer output do Embaixador ao Músculo
```

---

## COMO CARREGAR AS FONTES

```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
```

O script monta `CLIENTES/INGRID/NOTEBOOKLM_FONTES/` e abre o Explorer automaticamente.
Selecionar tudo (Ctrl+A) → arrastar ao NotebookLM → Wipe & Sync → colar COMANDO CURTO.

Fontes principais para este Loop 7:

```
--- UNIVERSAIS ---
00_INSTRUCAO_AUDITOR.md
01_SKILL_PROTOCOLO_VANGUARD.md
02_MEMORANDO_PENTALATERAL_UNIVERSAL.md
03_MANUAL_DIRETOR.md
04_INTELLIGENCE_LEDGER.md          ← contém P-091 (novo — WIP_BOARD vs disco)
05_PROCESSO_EVOLUTIVO_PENTALATERAL.md
06_TEMPLATES_COMUNICACAO_PENTALATERAL.md
07_WIP_BOARD.md                    ← estado atual de INGRID + VALDECE
08_ANALISE_SOCIO_ATUAL.txt

--- PROJETO INGRID ---
10_MEMORIA_RECENTE.md              ← MEMORIA_V6_INGRID.md (Loop 6)
11_RELATORIO_EVOLUTIVO.md          ← relatorio_evolutivo_V6_INGRID.md (SWOT + PDCA + [M-1 a M-5])
12_DIRETRIZ_GEMINI_V7.txt          ← DIRETRIZ V7 recebida hoje ← OBRIGATÓRIO
13_PASSO5_NOTEBOOKLM.md            ← este arquivo (missão do Auditor)
14_MEMORIA_EMBAIXADOR.md           ← inteligência Embaixador sobre Ingrid ← FILTRO DE REALIDADE
16_ALERTA_CONFLITO.md
17_VANGUARD_TIMELINE.md
18_ATUALIZACAO_PENTALATERAL_2026-05-24.md
```
