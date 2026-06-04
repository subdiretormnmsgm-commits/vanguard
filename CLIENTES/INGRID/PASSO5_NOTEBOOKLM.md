# PASSO 5 — AUDITOR (NOTEBOOKLM) · PROJETO INGRID · LOOP 8
> Pentalateral IAH — Camada Permanente: não editar blocos de protocolo.
> Atualizado pelo Músculo em 2026-06-04 (Loop 8 / Diretriz V8)

---

## ANTES DE IR AO NOTEBOOKLM — checklist obrigatório

```
[ ] 1. DIRETRIZ_GEMINI_V8.txt recebida e salva em CLIENTES\INGRID\NOTEBOOKLM_FONTES\
[ ] 2. Rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
[ ] 3. Explorer abre automaticamente — Ctrl+A → arrastar TUDO ao NotebookLM
[ ] 4. Fazer Wipe & Sync das fontes (apagar antigas antes de subir as novas)
[ ] 5. Colar o COMANDO CURTO no chat (não o arquivo inteiro — ele já está nas fontes)
```

> Sem o Wipe & Sync, o Auditor mistura contexto do Loop 7 com o Loop 8.
> Auditor com fontes velhas = Skill que contradiz o que já foi construído.

### COMANDO CURTO — colar no chat do NotebookLM

```
Auditor, você opera no Pentalateral IAH — 5 membros ativos: Diretor, Músculo, Estrategista, Auditor e Embaixador. O Embaixador (Claude Projects) acompanha a cliente Ingrid em tempo real e suas hipóteses sobre comportamento e perfil estão no arquivo 14_MEMORIA_EMBAIXADOR.md — leia-o como filtro de realidade antes de validar qualquer sugestão. Leia o arquivo 13_PASSO5_NOTEBOOKLM.md das fontes carregadas detalhadamente e execute todas as instruções contidas nele. Missão principal: gerar a Skill ingrid-v8.md — o Músculo não inicia o Loop 8 sem ela.
```

> O arquivo já está nas fontes — não colar o conteúdo inteiro no chat.

---

## AO RECEBER O OUTPUT DO AUDITOR — ANTES DE SAIR DO NOTEBOOKLM (P-049)

O NotebookLM entrega 4 partes. Você vai copiar só a PARTE 3 para o arquivo skill.
As PARTES 1, 2 e 4 são **irrecuperáveis** depois que você fechar a sessão.

```
Antes de sair:
☐ Copiar PARTES 1 + 2 + 4 completas (tudo exceto a Skill)
☐ Salvar em: CLIENTES/INGRID/HISTORICO/AUDITOR_LOOP_V8_INGRID.md
☐ Copiar PARTE 3 (Skill) para: .claude/skills/ingrid-v8.md
☐ Rodar: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\ingrid-v8.md"
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

**Remédio:** "ALERTA: Auditor alucinou. Gatilho de Calibração ativado."

---

## COMPENSAÇÃO DAS DEFICIÊNCIAS DO MÚSCULO

Ao gerar a Skill, compense ativamente:

1. **Amnésia de Sessão** → listar princípios do LEDGER ativos neste loop que o Músculo deve citar ao deliberar
2. **Momentum de Execução** → gates verificáveis por dia — sem output real = gate inválido
3. **Otimismo de Estimativa** → comparar estimativas com loops anteriores; Circuit Breaker preventivo se subestimar
4. **Escopo Silencioso** → listar explicitamente o que NÃO construir neste loop
5. **Drift de Formato** → exigir os 7 pontos de deliberação; sem formato = deliberação rejeitada

---

## CONTEXTO DO PROJETO

**Projeto:** Ingrid — Ferramenta de Estudo SEDES-DF · Cargo 202 Técnico Administrativo
**Nicho:** EdTech / Concursos Públicos · **Banca:** Instituto Quadrix
**Stack:** PWA Vanilla JS + Supabase próprio da Ingrid (`yjqvjhezwhepwomukudt`) + Claude API · GitHub Pages
**Prova final:** 2026-09-06 (94 dias) · **URL produção:** https://subdiretormnmsgm-commits.github.io/vanguard/

**Loop:** #8 — Telemetria + RLS + Monetização (2026-06-04)

**Estado técnico pós-Loop 7 (v20 em produção):**

| Feature | Status |
|---|---|
| F-1 Saudação Noturna Dinâmica | Ativa |
| F-2 Distração Vingativa Silenciosa | Ativa |
| F-4 Gatilho Temporal 19h45 + pg_cron | **ATIVO** — deployado 2026-06-01 |
| F-5 Modo Véspera | Ativo — ativar 2026-08-30 |
| F-6 Relatório Semanal WhatsApp | **ATIVO** — deployado 2026-06-01 |
| F-7 Raio-X SVG + Brasão | Ativo |
| F-8 Termômetro da Aprovação | Ativo |
| SM-2 + Heatmap | Ativos — 102 respostas · 1 user_id |

**DESBLOQUEADOS no Loop 8 (pós D1/D4 resolvidos):**
F-A Telemetria passiva · F-B Painel Eduardo · F-C RLS silencioso · F-D View SQL golden · F-E Alerta Telegram · F-G Git Hook · F-H LEGAL-WATCH visual

**DADOS-WATCH:** VERDE · **LEGAL-WATCH:** VERDE · **Temperatura:** QUENTE (Ingrid: "está gostando" — 2026-06-01)

**Gates do Loop 8:**
- GATE 7.2: RLS dry-run — `test_tenant_isolation.ps1` (BLOQUEANTE — primeiro a executar)
- GATE 8.1: evento_uso registrado em produção sem impacto de latência
- GATE 8.2: Painel Eduardo renderizando dados reais de Ingrid

**Banco:** 460+ questões · 13 disciplinas · Cargo 202 Quadrix

---

## IDEIAS DO ESTRATEGISTA [G-1 a G-5] — DIRETRIZ V8 — REAGIR A CADA UMA

| # | Ideia | Verificar com |
|---|---|---|
| G-1 | Simulador de Gargalo do Edital — cruzar erros da telemetria com pesos do edital Quadrix para direcionar geração automática de questões | Telemetria F-A; edital Quadrix pesos |
| G-2 | Ancoragem de Preço por Custo-Minuto — métrica de ROI no relatório dominical | F-6 relatório semanal; pitch R$97/mês |
| G-3 | [CONTRA-INTUITIVO] Redução Programada de Cota — limitar questões inéditas quando consistência cai, forçando revisão SM-2 acumulada | SM-2; burnout cognitivo 94 dias |
| G-4 | Exportador de Caderno de Erros Analógico — mini-PDF otimizado para impressão com principais erros socráticos | F-7 Raio-X; semana final da prova |
| G-5 | [CONTRA-INTUITIVO] Atraso Proposital do Pitch — reter oferta R$97/mês mais uma semana como escassez passiva | Pipeline comercial; M-1 dataset |

**ALERTA do Estrategista:**
- Risco LGPD: usar dados individuais da Ingrid como argumento de venda para terceiros sem consentimento explícito
- Alertas excessivos de inatividade (F-E) podem gerar ansiedade punitiva na reta final (94 dias)

---

## MISSÃO CRÍTICA — GERAR A SKILL ingrid-v8.md

**Após processar as fontes e a missão acima, gere a Skill completa em 4 partes obrigatórias.**

O nome exato da Skill: **`ingrid-v8.md`**

O Músculo vai executar `/ingrid-v8` antes de qualquer deliberação do Loop 8.
Skill sem os 4 blocos com dados reais = Skill rejeitada. Músculo não inicia o build sem Skill válida.

---

## FORMATO OBRIGATÓRIO DA SKILL (4 partes — sem exceção)

```
PARTE 1 — AUDITORIA DE COERÊNCIA
  A DIRETRIZ V8 contradiz algo já construído ou decidido nos Loops 1-7?
  Citar: fonte exata (arquivo, princípio, versão). Sem dado real = bloco inválido.
  Verificar especificamente:
    - RLS: tabelas progresso_usuario e evento_uso isoladas por user_id?
    - Burn Rate $5/dia (P-006) — F-A telemetria não pode adicionar custo de API
    - P-059: isolamento de contexto Ingrid vs Valdece — NUNCA cruzar dados
    - LGPD: dados de Ingrid NUNCA usados como argumento comercial sem consentimento
    - P-091: WIP_BOARD só marca OK com artefato em disco

PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR
  O que funciona em projetos similares (citar projeto + resultado).
  O que falha (citar projeto + razão documentada).
  O que este projeto tem de diferente que muda o padrão.
  O que Gemini e Músculo não estão vendo — discordância fundamentada.
  Foco especial: qual dos [G-1 a G-5] tem maior risco comportamental para Ingrid?

PARTE 3 — A SKILL (copiável para .claude/skills/ingrid-v8.md)
  A Skill DEVE conter estes 4 títulos de seção EXATOS (sem acentos).
  O script skill_parser_gate.ps1 verifica — Skill sem eles = REJEITADA:

    ## [AUDITORIA DE COERENCIA]
    ## [CONEXAO HISTORICA]
    ## [PADRAO DE SUCESSO/FALHA]
    ## [PERSPECTIVA DO SOCIO]

  Conteúdo obrigatório por seção:
    [AUDITORIA DE COERENCIA]  — alertas LGPD + RLS + Burn Rate + decisões fixadas Loops 1-7
    [CONEXAO HISTORICA]       — o que os Loops 1-7 provaram (stack, gates, comportamento Ingrid)
    [PADRAO DE SUCESSO/FALHA] — sequência Loop 8 com gates verificáveis por dia
    [PERSPECTIVA DO SOCIO]    — o que o Auditor vê que Gemini e Músculo não viram

PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR [N-1 a N-5]
  Ideias que NÃO vieram do Gemini nem do Músculo — perspectiva histórica exclusiva.
  Cada uma fundamentada em padrão de projeto anterior ou princípio do LEDGER.
  Formato: o que é + impacto + por que o Músculo não propôs isso.
```

**Validação antes de entregar:**
- [ ] Skill tem nome exato `ingrid-v8.md` declarado na PARTE 3
- [ ] PARTE 3 contém os 4 títulos EXATOS sem acentos
- [ ] PARTE 1 cita fontes reais (não genéricas)
- [ ] PARTE 4 tem 5 ideias [N-1 a N-5] exclusivas do Auditor
- [ ] Skill é copiável diretamente para `.claude/skills/`

---

## PRÓXIMO PASSO APÓS RECEBER O OUTPUT — BLOQUEANTE

```
ORDEM INVIOLÁVEL — MÚSCULO NÃO DELIBERA SEM OS 3 SÓCIOS:

  1. NotebookLM → ingrid-v8.md        ← você está aqui
  2. Embaixador → SEÇÃO D             ← OBRIGATÓRIO ANTES DO MÚSCULO
  3. Músculo → síntese P-037          ← só depois dos dois acima

AÇÃO APÓS RECEBER SKILL:
  → Rodar: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\ingrid-v8.md"
  → Atualizar [N-1 a N-5] no PASSO7_EMBAIXADOR.md SEÇÃO D
  → Ativar Embaixador: .\scripts\ir_ao_embaixador.ps1 -cliente INGRID
  → Só depois trazer output do Embaixador ao Músculo
```

---

## COMO CARREGAR AS FONTES

```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
```

O script monta `CLIENTES/INGRID/NOTEBOOKLM_FONTES/` e abre o Explorer automaticamente.
Selecionar tudo (Ctrl+A) → arrastar ao NotebookLM → Wipe & Sync → colar COMANDO CURTO.
