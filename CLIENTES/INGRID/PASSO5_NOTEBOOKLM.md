# PASSO 5 — AUDITOR (NOTEBOOKLM) · PROJETO INGRID · LOOP 4
> Pentalateral IAH — Camada Permanente: não editar blocos de protocolo.
> Atualizado pelo Músculo em 2026-05-19 (Loop 4 / Diretriz V5)

---

## 📌 ANTES DE IR AO NOTEBOOKLM — checklist obrigatório

```
[x] 1. DIRETRIZ_GEMINI_V5.txt recebida e salva em CLIENTES\INGRID\
[x] 2. Rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
[x] 3. Explorer abre automaticamente — Ctrl+A → arrastar TUDO ao NotebookLM
[x] 4. Fazer Wipe & Sync das fontes (apagar antigas antes de subir as novas)
[x] 5. Colar o COMANDO CURTO no chat (não o arquivo inteiro — ele já está nas fontes)
```

> Sem o Wipe & Sync, o Auditor mistura contexto do Loop anterior com o atual.
> Auditor com fontes velhas = Skill que contradiz o que já foi construído.

### 💬 COMANDO CURTO — colar no chat do NotebookLM (Ctrl+V)

```
Auditor, você opera no Pentalateral IAH — 5 membros ativos desde 2026-05-18: Diretor, Músculo, Estrategista, Auditor e Embaixador. O Embaixador (Claude Projects) acompanha a cliente Ingrid em tempo real e suas hipóteses sobre comportamento e perfil estão no arquivo 14_MEMORIA_EMBAIXADOR.md — leia-o como filtro de realidade antes de validar qualquer sugestão. Leia o arquivo 13_PASSO5_NOTEBOOKLM.md das fontes carregadas detalhadamente e execute todas as instruções contidas nele. Missão principal: gerar a Skill ingrid-v4.md — o Músculo não inicia o Loop 4 sem ela.
```

> O arquivo já está nas fontes — não colar o conteúdo inteiro no chat.

---

## 📥 AO RECEBER O OUTPUT DO AUDITOR — ANTES DE SAIR DO NOTEBOOKLM (P-049)

O NotebookLM entrega 4 partes. Você vai copiar só a PARTE 3 para o arquivo skill.
As PARTES 1, 2 e 4 são **irrecuperáveis** depois que você fechar a sessão.

```
Antes de sair:
☐ Copiar PARTES 1 + 2 + 4 completas (tudo exceto a Skill)
☐ Salvar em: CLIENTES/INGRID/HISTORICO/AUDITOR_LOOP_4_INGRID.md
☐ Copiar PARTE 3 (Skill) para: .claude/skills/ingrid-v4.md
☐ Rodar: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\ingrid-v4.md"
```

> PARTES 1+2+4 não salvas = Músculo delibera sem [N-1 a N-5] + Auditoria = 20 inputs, não 25.

---

## 🔍 PROTOCOLO ANTI-ALUCINAÇÃO (ler antes de processar)

Auditor, você opera com 4 deficiências nativas:

| Deficiência | Gatilho de Alerta |
|---|---|
| Amnésia de Contexto | Tratar o projeto como Dia 1 sem MEMORIA |
| Alucinação Estrutural (P-007) | Skill com blocos genéricos sem dados reais do projeto |
| Síndrome do Yes-Man | Validar a DIRETRIZ do Gemini sem questionar |
| Lost-in-the-Middle | Ignorar OVERRIDE recente e aplicar regra V1 |

**Remédio:** "🚨 ALERTA: Auditor alucinou. Gatilho de Calibração ativado."

---

## ⚙️ COMPENSAÇÃO DAS DEFICIÊNCIAS DO MÚSCULO

Ao gerar a Skill, compense ativamente:

1. **Amnésia de Sessão** → listar princípios do LEDGER (P-001 a P-032) que o Músculo deve citar ao deliberar
2. **Momentum de Execução** → gates verificáveis por dia — sem output real = gate inválido
3. **Otimismo de Estimativa** → comparar estimativas com projetos similares; SV preventivo se subestimar
4. **Escopo Silencioso** → listar explicitamente o que NÃO construir neste loop
5. **Drift de Formato** → exigir os 7 pontos de deliberação; sem formato = deliberação rejeitada

---

## 📋 CONTEXTO DO PROJETO

**Projeto:** Ingrid — Ferramenta de Estudo Sedes-DF
**Nicho:** EdTech / Concursos Públicos
**Camada:** 2 — Produto (15 dias)
**Loop:** #4 — Dias 9–11 (Heatmap + Micro-Simulado + SaaS Readiness)
**Gates aprovados:** Dia 2 (qualidade das questões) + Dia 5 (feed 70/30, 7 dias, 0 erros) + Dia 8 (PWA completo: Clickwrap + Tutor 3 níveis + Fallback + TTI — APROVADO 2026-05-19)
**Banco de questões:** 460 questões no Supabase — 13 disciplinas Cargo 202
**Próximo gate:** Dia 11 — Heatmap correto por disciplina + micro-simulado completo funcional

**Estado técnico atual (MEMORIA_V2_INGRID.md):**
- Edge Functions gerar-questoes + feed-diario deployadas e validadas
- Arquitetura: 1 Claude call por Edge Function invocação (nunca reverter)
- Recalibração de cargo executada (P-024): Cargo 202, não TDAS área social

**Missão do Auditor neste loop:**
> "Auditor, você recebeu a DIRETRIZ_GEMINI_V5 para o Loop 4 do Projeto Ingrid.
> O Músculo vai deliberar e construir o Heatmap de disciplinas, o Micro-Simulado e o SaaS Readiness Audit.
> Sua missão: auditar a DIRETRIZ cruzando com o histórico real das fontes.
> Identifique: (1) o que contradiz princípios ativos do LEDGER ou decisões já tomadas,
> (2) o que já falhou em projetos anteriores,
> (3) o que o Estrategista está ignorando por otimismo de prazo.
> Não valide por momentum. Discorde quando tiver evidência histórica."

---

## 🎯 MISSÃO CRÍTICA — GERAR A SKILL ingrid-v4.md

**Após processar as fontes e a missão acima, gere a Skill completa em 4 partes obrigatórias.**

O nome exato da Skill: **`ingrid-v4.md`**

O Músculo vai executar `/ingrid-v4` antes de qualquer deliberação do Loop 4.
Skill sem os 4 blocos com dados reais = Skill rejeitada. Músculo não inicia o build sem Skill válida.

---

## 📤 FORMATO OBRIGATÓRIO DA SKILL (4 partes — sem exceção)

```
PARTE 1 — AUDITORIA DE COERÊNCIA
  A DIRETRIZ V5 contradiz algo já construído ou decidido nos Loops 1, 2, 3 ou 4?
  Citar: fonte exata (arquivo, princípio, versão). Sem dado real = bloco inválido.
  Verificar especificamente:
    - Arquitetura de batch (1 Claude call/invocação — nunca reverter)
    - Cargo 202 vs TDAS (P-024 — recalibração obrigatória)
    - Deadline 2026-05-30 (12 dias restantes)
    - Budget $5,00/dia (P-006 — Burn Rate Shield)

PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR
  O que funciona em projetos similares (citar projeto + resultado).
  O que falha (citar projeto + razão documentada).
  O que este projeto tem de diferente que muda o padrão.
  O que Gemini e Músculo não estão vendo — discordância fundamentada.

PARTE 3 — A SKILL (copiável para .claude/skills/ingrid-v4.md)
  ⚠️ GATE OBRIGATÓRIO: a Skill DEVE conter estes 4 títulos de seção EXATOS (sem acentos).
  O script skill_parser_gate.ps1 verifica esses textos — Skill sem eles = REJEITADA:

    ## [AUDITORIA DE COERENCIA]
    ## [CONEXAO HISTORICA]
    ## [PADRAO DE SUCESSO/FALHA]
    ## [PERSPECTIVA DO SOCIO]

  Conteúdo obrigatório por seção:
    [AUDITORIA DE COERENCIA]  — alertas VETO do LEDGER (P-003, P-006, P-010, P-024, P-025 ativos)
    [CONEXAO HISTORICA]       — o que os Loops 1-3 provaram (decisões fixadas, stack, gates aprovados)
    [PADRAO DE SUCESSO/FALHA] — o que funcionou + o que falhou + sequência de build com gates verificáveis
    [PERSPECTIVA DO SOCIO]    — o que o Auditor vê que os outros não veem + discordância fundamentada

PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR
  Ideias que NÃO vieram do Gemini nem do Músculo — perspectiva histórica exclusiva.
  Cada uma fundamentada em padrão de projeto anterior ou princípio do LEDGER.
  Formato: o que é + impacto + por que o Músculo não propôs isso.
```

**Validação antes de entregar:**
- [ ] Skill tem nome exato `ingrid-v4.md` declarado na PARTE 3
- [ ] PARTE 3 contém os 4 títulos EXATOS: `[AUDITORIA DE COERENCIA]`, `[CONEXAO HISTORICA]`, `[PADRAO DE SUCESSO/FALHA]`, `[PERSPECTIVA DO SOCIO]`
- [ ] PARTE 1 cita fontes reais (não genéricas)
- [ ] PARTE 4 tem 5 ideias exclusivas do Auditor
- [ ] Skill é copiável diretamente para `.claude/skills/`

---

## 📚 COMO CARREGAR AS FONTES (V25 — pasta única)

```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
```

O script monta `CLIENTES/INGRID/NOTEBOOKLM_FONTES/` e abre o Explorer automaticamente.
Selecionar tudo (Ctrl+A) → arrastar ao NotebookLM → colar o texto deste PASSO5 no chat.

Ordem dos documentos (fatos do passado primeiro — nunca inverter):

```
--- UNIVERSAIS ---
01_SKILL_PROTOCOLO_VANGUARD.md     ← ancora nos padrões do Quadrilateral
02_MEMORANDO_PENTALATERAL_UNIVERSAL.md  ← constituição e valores
03_MANUAL_DIRETOR.md                     ← como Eduardo opera
04_INTELLIGENCE_LEDGER.md               ← princípios ativos P-001 a P-032
05_PROCESSO_EVOLUTIVO_QUADRILATERAL.md  ← como o loop funciona
06_TEMPLATES_COMUNICACAO_QUADRILATERAL.md ← formatos obrigatórios
07_WIP_BOARD.txt                   ← estado atual dos projetos (TXT — NotebookLM lê)
08_ANALISE_SOCIO_ATUAL.txt         ← visão de negócio atualizada

--- PROJETO INGRID ---
09_BRIEFING_DISCOVERY.txt          ← dor real da cliente
10_MEMORIA_RECENTE.md              ← MEMORIA_V3_INGRID.md (Loop 3)
11_RELATORIO_EVOLUTIVO.md          ← relatorio_evolutivo_V3_INGRID.md (Loop 3)
12_DIRETRIZ_GEMINI.txt             ← DIRETRIZ_GEMINI_V5 do Gemini ← OBRIGATÓRIO
13_PASSO5_NOTEBOOKLM.md            ← este arquivo (missão do Auditor)
14_MEMORIA_EMBAIXADOR.md           ← inteligência Embaixador sobre Ingrid ← FILTRO DE REALIDADE
15_SKILL_ANTERIOR.md               ← Skill ingrid-v5.md do Loop anterior
16_ALERTA_CONFLITO.md              ← gatilho de calibração
17_VANGUARD_TIMELINE.md            ← histórico completo da Vanguard
```

> **07_WIP_BOARD.txt** — extensão `.txt` obrigatória. NotebookLM não lê `.json`.
> O script converte automaticamente. Se aparecer `.json`, rodar `atualizar_notebooklm_base.ps1` antes.

