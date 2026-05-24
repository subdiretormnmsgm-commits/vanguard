# MANUAL DO DIRETOR — ORQUESTRAÇÃO DO PENTALATERAL IAH
**O guia completo de Eduardo para coordenar Gemini, NotebookLM, Claude Code e Claude Projects**
**Versão:** 1.4 · 2026-05-24 · Organismo Vivo — Pipeline inline · Schema DECISOES v1.1

---

> ⚠️ **ORGANISMO VIVO — atualizar APÓS CADA projeto**
> Este manual melhora com cada entrega real.
> Ao fechar qualquer iteração, verificar e atualizar:
> · Um comando que não funcionou como esperado → corrigir o template
> · Um passo que demorou mais do que o estimado → atualizar a tabela de tempo
> · Uma situação nova no troubleshooting → adicionar à Parte 6
> · Um padrão de comportamento do Gemini ou Claude → documentar
> · O número da versão do Manual → incrementar
> Nunca fechar uma iteração sem verificar se algo aqui precisa de ser atualizado.
> **A consistência deste manual é o que garante a consistência do sistema.**

---

> **Para que serve este documento:**
> Para que Eduardo nunca precise de improvisar.
> Cada fase tem uma ação clara. Cada membro recebe um comando exato.
> O Pentalateral corre por si — você decide, não inventa o processo.

---

## MAPA COMPLETO DO LOOP

```
════════════════════════════════════════════════════════════════════════
                    Pentalateral IAH — O LOOP QUE NUNCA PARA
════════════════════════════════════════════════════════════════════════

  EDUARDO                GEMINI               NOTEBOOKLM          CLAUDE CODE         EMBAIXADOR
  (Diretor)           (Estrategista)           (Auditor)         (Músculo/Arq.)    (Claude Projects)
      │                     │                     │                    │                   │
 [PASSO 1]                  │                     │                    │                   │
 Qualifica cliente          │                     │                    │                   │
 GO / NO-GO                 │                     │                    │                   │
      │                     │                     │                    │                   │
 [PASSO 2]                  │                     │                    │                   │
 Discovery                  │                     │                    │                   │
 9 perguntas V3             │                     │                    │                   │
      │                     │                     │          [PASSO ⓪ — MÚSCULO]           │
      │                     │                     │          gemini_anchor_generator.ps1    │
      │                     │                     │          Prepara PASSO3_GEMINI          │
      │                     │                     │          Verifica P-045                 │
      │                     │                     │                    │                   │
 [PASSO 3]                  │                     │                    │                   │
 ──── COMANDO 1 ──────────► │                     │                    │                   │
      │                  analisa                  │                    │
      │                  e cria                   │                    │
      │                  DIRETRIZ                 │                    │
      │◄── DIRETRIZ V1 ──  │                      │                    │
      │                     │                     │                    │
 [PASSO 4]                  │                     │                    │
 Valida DIRETRIZ            │                     │                    │
      │                     │                     │                    │
 [PASSO 5]                  │                     │                    │
 ──── COMANDO 2 ─────────────────────────────────►│                    │
      │                     │                  analisa                 │
      │                     │                  e gera                  │
      │                     │                  Skill                   │
      │◄──────── Skill V1 ───────────────────────  │                   │
      │                     │                     │                    │
 [PASSO 6]                  │                     │                    │
 ──── PROTOCOLO VANGUARD ────────────────────────────────────────────► │
 + Skill + DIRETRIZ          │                     │               delibera
      │                     │                     │               propõe
      │                     │                     │               plano
      │◄────────────────────────────────────────── plano V1 ──────────  │
      │                     │                     │                    │
 [PASSO 7]                  │                     │                    │
 Aprova plano               │                     │                    │
 ──── "Pode avançar" ─────────────────────────────────────────────── ► │
      │                     │                     │               executa
      │                     │                     │               constrói
      │                     │                     │               reporta
      │                     │                     │               ALERTAS
      │◄────────────────────────────────────────── ALERTAS (se houver) │
      │                     │                     │                    │
 [PASSO 8]                  │                     │                    │
 Decide sobre ALERTAS       │                     │                    │
 ──── Decisão ───────────────────────────────────────────────────── ► │
      │                     │                     │               continua
      │                     │                     │               termina
      │                     │                     │                    │
 [PASSO 9]                  │                     │                    │
      │◄─── COMANDO 5 ──────────────────────────── MEMORIA + relatorio  │
      │                     │                     │             + ESTRATEGISTA
      │                     │                     │                    │
 [PASSO 10]                 │                     │                    │
 Valida + commit            │                     │                    │
 ──── COMANDO_ESTRATEGISTA ► │                     │                    │
      │                  reage às                  │                    │
      │                  ideias do                 │                    │
      │                  Claude                    │                    │
      │◄── DIRETRIZ V2 ──  │                      │                    │
      │                     │                     │                    │
  [VOLTA AO PASSO 4 — iteração V2 começa aqui]
      │
  O loop fecha mais rico do que abriu.
  A cada ciclo: + memória, + padrões, + velocidade, + precisão.
```

---

## PARTE 0 — CARTÃO DE ATIVAÇÃO RÁPIDA — ANTES DE CADA LOOP

> Imprima ou deixe aberto. Antes de ir a qualquer membro do Conselho, passe por este card.

```
╔══════════════════════════════════════════════════════════════════════╗
║          CHECKLIST DO DIRETOR — INÍCIO DE LOOP                      ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                      ║
║  PASSO ⓪ — MÚSCULO PREPARA (antes do Gemini):                       ║
║  [ ] Músculo roda: gemini_anchor_generator.ps1 -cliente [NOME]      ║
║  [ ] Músculo verifica P-045: MEMORIA_V[N-1] + relatorio_V[N-1]?    ║
║  [ ] Músculo atualiza PASSO3_GEMINI.md com orientações do Diretor   ║
║                                                                      ║
║  ANTES DE IR AO GEMINI (Passo 3):                                   ║
║  [ ] Abrir CLIENTES/[PROJETO]/PASSO3_GEMINI.md                      ║
║  [ ] Atualizar bloco "CONTEXTO DO PROJETO":                         ║
║      → O que foi construído (dias e outputs reais)                  ║
║      → O que falta (dias restantes e o que cada um produz)          ║
║      → Maior risco atual                                            ║
║      → Decisões fixadas no projeto (não reverter)                   ║
║      → As 5 ideias do Músculo do último relatorio_evolutivo         ║
║  [ ] Enviar ao Gemini NESTA ORDEM:                                  ║
║      1. MEMORIA_V[X].md                                              ║
║      2. relatorio_evolutivo_V[X].md                                  ║
║      3. PASSO3_GEMINI.md ← por último                               ║
║                                                                      ║
║  ANTES DE IR AO NOTEBOOKLM (Passo 5):                              ║
║  [ ] Abrir CLIENTES/[PROJETO]/PASSO5_NOTEBOOKLM.md                 ║
║  [ ] Carregar fontes NO NOTEBOOKLM NESTA ORDEM (antes de colar):   ║
║      1. MEMORIA_V[X].md                                              ║
║      2. relatorio_evolutivo_V[X].md                                  ║
║      3. INTELLIGENCE_LEDGER.md                                       ║
║      4. SKILL_PROTOCOLO_VANGUARD.md                                  ║
║      5. BRIEFING_DISCOVERY.md do cliente                             ║
║      6. DIRETRIZ do Gemini (recém-recebida)                          ║
║  [ ] Atualizar bloco "CONTEXTO DO PROJETO" do PASSO5               ║
║  [ ] Colar o PASSO5_NOTEBOOKLM.md no chat do NotebookLM            ║
║                                                                      ║
║  ANTES DE ACIONAR O MÚSCULO (Passo 6):                             ║
║  [ ] Salvar a Skill do NotebookLM em .claude/skills/[projeto].md   ║
║  [ ] Dizer: "PROTOCOLO VANGUARD — [projeto]. Leia tudo e delibere." ║
║  [ ] Trazer: Skill + DIRETRIZ (o Músculo lê o PASSO6 internamente) ║
║  [ ] Aguardar deliberação — não aprovar build antes do plano        ║
║                                                                      ║
║  AO FECHAR O LOOP (Passo 9–10):                                    ║
║  [ ] Receber MEMORIA + relatorio_evolutivo + COMANDO_ESTRATEGISTA   ║
║  [ ] Validar os 3 entregáveis (checklists no Passo 9)              ║
║  [ ] Aprovar commit                                                  ║
║  [ ] Colar COMANDO_ESTRATEGISTA no Gemini → loop recomeça           ║
║  [ ] Atualizar INTELLIGENCE_LEDGER com fricções da sessão           ║
╚══════════════════════════════════════════════════════════════════════╝
```

> **Regra crítica:** Os arquivos PASSO3_GEMINI.md, PASSO5_NOTEBOOKLM.md e PASSO6_MUSCULO.md
> existem UM POR PROJETO — não um por loop. Eduardo atualiza apenas o bloco de CONTEXTO
> antes de cada loop. Os protocolos anti-deficiência são permanentes e nunca são editados.

---

## PARTE 0.6 — TABELA DEFINITIVA: EXATAMENTE O QUE ANEXAR EM CADA PARCEIRO

> **Esta seção responde: "Quais documentos devo ter em mãos e em qual ordem?"**
> Atualizada em 2026-05-23 para incluir Embaixador + MASTER + MANIFESTO_DE_FONTES + REGISTRO_DE_PREMISSAS.

---

### 🔵 GEMINI (ESTRATEGISTA) — o que levar

**Antes de ir ao Gemini, rodar:**
```powershell
.\scripts\gemini_anchor_generator.ps1
# → Gera CONTEXTO_GEMINI.md e copia para clipboard automaticamente
```

**O que colar no chat do Gemini (nesta ordem exata):**

| # | Documento | Onde fica | Por que vai primeiro |
|---|---|---|---|
| 1 | `COMANDO_ESTRATEGISTA_MASTER_v1.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Ativa o Estrategista — resolve amnésia estrutural (P-052) |
| 2 | `MEMORIA_V[N-1]_[CLIENTE].md` | `CLIENTES/[NOME]/HISTORICO/` | Fatos antes de ideias — estado real do projeto |
| 3 | `relatorio_evolutivo_V[N-1]_[CLIENTE].md` | `CLIENTES/[NOME]/HISTORICO/` | Análise + [M-1 a M-5] do ciclo anterior para o Gemini reagir |
| 4 | `PASSO3_GEMINI.md` do projeto | `CLIENTES/[NOME]/` | Missão da sessão + contexto preenchido pelo Músculo |

**Preencher no PASSO3 antes de enviar (Músculo faz — você só verifica):**
- Loop atual e nome
- O que foi construído (outputs reais)
- O que falta e prazo restante
- [M-1 a M-5] do ciclo anterior
- [E-1 a E-5] do Embaixador (se disponíveis)

**O que vem de volta:** DIRETRIZ com 8 blocos obrigatórios incluindo REFORMULAÇÃO_DO_PROBLEMA + POSIÇÃO_ADVERSARIAL + TRADUÇÃO_PARA_AÇÃO + ARCO_DE_CONSEQUÊNCIAS nas 5 ideias.

**Salvar imediatamente:** `CLIENTES/[NOME]/NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V[N].txt`

---

### 🟡 NOTEBOOKLM (AUDITOR) — o que levar

**Antes de ir ao NotebookLM, verificar:**
```
[ ] MANIFESTO_DE_FONTES.md existe em CLIENTES/[NOME]/NOTEBOOKLM_FONTES/?
    → Se não → pedir ao Músculo para criar ANTES de ir
[ ] DIRETRIZ_GEMINI_V[N].txt salva como 12_DIRETRIZ_GEMINI_V[N].txt?
    → Se não → salvar agora antes de rodar o script
```

**Depois, rodar:**
```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME]
# → Monta NOTEBOOKLM_FONTES/ com todos os documentos numerados
# → Abre Explorer com a pasta pronta
```

**O que arrastar para o NotebookLM (Ctrl+A na pasta):**

| Numeração | Documento | Obrigatório? |
|---|---|---|
| 01_ | SKILL_PROTOCOLO_VANGUARD.md | Sim |
| 02_ | MEMORANDO_PENTALATERAL_UNIVERSAL.md | Sim |
| 03_ | MANUAL_DIRETOR.md | Sim |
| 04_ | INTELLIGENCE_LEDGER.md | Sim |
| 05_ | PROCESSO_EVOLUTIVO_PENTALATERAL.md | Sim |
| 06_ | TEMPLATES_COMUNICACAO_PENTALATERAL.md | Sim |
| 07_ | WIP_BOARD.txt | Sim |
| 08_ | ANALISE_SOCIO_ATUAL.txt | Sim |
| 09_ | BRIEFING_DISCOVERY.txt | Sim |
| 10_ | MEMORIA_V[N-1].md | Sim — fatos antes de ideias |
| 11_ | relatorio_evolutivo_V[N-1].md | Sim |
| 12_ | DIRETRIZ_GEMINI_V[N].txt | Sim — output do Gemini |
| 13_ | PASSO5_NOTEBOOKLM.md | Sim — o Músculo preencheu |
| 14_ | MEMORIA_EMBAIXADOR.md | Sim |
| 15_ | MANIFESTO_DE_FONTES.md | **Novo** — declara o que o Auditor pode ver |

**No chat do NotebookLM, digitar apenas:**
```
Ler 13_PASSO5_NOTEBOOKLM.md e gerar a Skill.
```

**O que vem de volta (4 partes):**
- PARTE 1: Auditoria de Coerência (contradições na DIRETRIZ)
- PARTE 2: Conexão Histórica (padrões de outros projetos)
- PARTE 3: A Skill copiável → salvar em `.claude/skills/[cliente]-v[N].md`
- PARTE 4: [N-1 a N-5] — 5 ideias exclusivas do Auditor

**Antes de fechar (irrecuperável depois):**
```
[ ] Copiar PARTES 1 + 2 + 4 → salvar em CLIENTES/[NOME]/HISTORICO/AUDITOR_LOOP_[N]_[CLIENTE].md
[ ] Copiar PARTE 3 → salvar em .claude/skills/[cliente]-v[N].md
[ ] Rodar: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\[cliente]-v[N].md"
```

---

### 🟢 CLAUDE PROJECTS (EMBAIXADOR) — o que levar

**Antes de ir ao Embaixador, rodar:**
```powershell
.\scripts\ir_ao_embaixador.ps1 -cliente [NOME]
# → Verifica se VEREDITOS_RESUMO da sessão anterior existe (alerta se ausente)
# → Copia mensagem de ativação para clipboard
# → Abre browser em claude.ai/projects
# → Abre Explorer em CLIENTES/[NOME]/CLAUDE_PROJECT/
```

**PRÉ-REQUISITO antes de ativar SEÇÃO D:**
```
[ ] DIRETRIZ_GEMINI_V[N].txt subida em Knowledge Documents (Settings > Knowledge)
    → sem a DIRETRIZ, o Embaixador reage ao Pentalateral sem o plano real do Músculo
[ ] VEREDITOS_RESUMO_[CLIENTE]_[DATA].md da sessão anterior carregado no Project
    → garante memória das decisões executadas no ciclo anterior
```

**O que o Embaixador já tem (memória persistente — não precisa colar):**
- Histórico completo de todas as sessões anteriores com o cliente
- MEMORIA_EMBAIXADOR acumulada

**O que você cola no chat (de acordo com a missão):**

| Missão | O que colar |
|---|---|
| PRÉ-REUNIÃO | SEÇÃO A do PASSO7_EMBAIXADOR.md preenchida |
| DEBRIEF PÓS-REUNIÃO | SEÇÃO B do PASSO7_EMBAIXADOR.md + relato informal |
| PIPELINE DE LEAD | SEÇÃO C + o que o cliente mencionou |
| REAÇÃO AO PENTALATERAL | SEÇÃO D + [M-1 a M-5] + [G-1 a G-5] + [N-1 a N-5] |

**O que vem de volta (7 blocos · V2.1 · schema DECISOES v1.1):**
- TEMPERATURA_PONDERADA — score 0-10 com evidência concreta (CHURN-WATCH automático se < 6)
- Hipóteses — CONFIRMADA / REFUTADA / PENDENTE com evidência de 1 linha
- Comportamento Observado — esperado vs. surpresa vs. o que não aconteceu
- Watchdog — CHURN/SCOPE/LEGAL/GATE watches + mensagem sugerida ao cliente
- [E-1 a E-5] — 5 ideias exclusivas baseadas em comportamento real (não síntese de outros membros)
- **D2 — INTELIGÊNCIA DE MERCADO** — sinal de nicho, risco de escala, argumento diferencial
- SAÍDA_EMBAIXADOR — atualização sugerida da MEMORIA + princípio candidato ao LEDGER
- CONFIRMA/EXPANDE/ALERTA para cada ideia do ciclo (quando missão = REAÇÃO AO PENTALATERAL)
- **DECISOES_[PROJETO]_[DATA].json (schema v1.1)** — pipeline de vereditos inline

**PIPELINE INLINE — Eduardo só delibera (2026-05-24):**
```
Embaixador entrega DECISOES.json (schema v1.1)
  ↓
Eduardo cola o output completo no Claude Code (chat do Músculo)
  ↓
Músculo lista as decisões: "D1: [título] — A: [opção] | B: [opção]"
  ↓
Eduardo responde apenas: "D1:A, D2:B"
  ↓
[Gate D1] Se hypercare_ativo + artefato_editavel:
  Músculo exibe texto da mensagem + aguarda "ok" antes de copiar_clipboard
[Flag D2] Se requer_uso_confirmado + plantar_hoje:
  AVISO registrado + espera confirmação de uso ativo
[Flag D3] Se resumo_para_cliente: true:
  Gera VEREDITOS_RESUMO_CLIENTE.md (mostrável ao cliente como Sentinel Report)
  ↓
executar_vereditos.ps1 gera VEREDITOS_RESUMO_[CLIENTE]_[DATA].md automaticamente
→ Carregar no Claude Project na próxima ativação
```

**DECISOES.json NÃO sobe ao Claude Projects** — JSON não é lido como Knowledge Document.
**VEREDITOS_RESUMO_[DATA].md** É carregado no Claude Project na próxima ativação.

**Depois da sessão (Músculo faz automaticamente — P-032):**
- Atualizar `CLIENTES/[NOME]/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md`

---

### 🔴 CLAUDE CODE (MÚSCULO) — o que colar

**No início de sessão, colar nesta ordem exata:**

| # | Documento | Onde fica |
|---|---|---|
| 1 | Skill `[cliente]-v[N].md` (PARTE 3 do Auditor) | `.claude/skills/` |
| 2 | Auditor PARTES 1 + 2 + 4 (com [N-1 a N-5]) | `CLIENTES/[NOME]/HISTORICO/AUDITOR_LOOP_[N]_[CLIENTE].md` |
| 3 | `DIRETRIZ_GEMINI_V[N].txt` | `CLIENTES/[NOME]/NOTEBOOKLM_FONTES/` |
| 4 | Output do Embaixador (com [E-1 a E-5]) | Copiado do Claude Projects |
| 5 | `PASSO6_MUSCULO.md` do projeto | `CLIENTES/[NOME]/` |

**Depois de colar, dizer:**
```
PROTOCOLO VANGUARD — [NOME]. Loop [N]. Diretriz V[N].
Execute /[cliente]-v[N] antes de deliberar.
Trago a Skill do Auditor, a DIRETRIZ do Gemini e as ideias do Embaixador.
Leia tudo e delibere nos 7 pontos antes de qualquer build.
```

**O que o Músculo entrega ao fechar:**
- `HISTORICO/MEMORIA_V[N]_[CLIENTE].md`
- `HISTORICO/relatorio_evolutivo_V[N]_[CLIENTE].md`
- `HISTORICO/DELIBERACAO_LOOP_[N]_[CLIENTE].md`
- `REGISTRO_DE_PREMISSAS.md` atualizado
- `COMANDO_ESTRATEGISTA_MASTER_v1.md` atualizado (BLOCO 1)
- PASSO3_GEMINI preenchido para Loop [N+1]

---

### 📋 RESUMO ULTRA-COMPACTO — O QUE CADA PARCEIRO PRECISA

```
GEMINI     → MASTER + MEMORIA + relatorio + PASSO3 preenchido
NOTEBOOKLM → 15-18 fontes numeradas (01-08 base + 09-18 projeto) + comando curto
EMBAIXADOR → DIRETRIZ_V[N].txt (Knowledge) + VEREDITOS_RESUMO anterior + seção do PASSO7
MÚSCULO    → Skill + Auditor completo + DIRETRIZ + output do Embaixador + PASSO6
```

**Sequência correta do loop:**
```
MÚSCULO (prepara) → GEMINI (DIRETRIZ) → NOTEBOOKLM (Skill) → EMBAIXADOR (filtro) → MÚSCULO (build)
```

**Pipeline de decisões (inline — Eduardo só delibera):**
```
Embaixador → DECISOES.json → Eduardo cola no Claude Code → Músculo lista → Eduardo: "D1:A, D2:B"
→ Músculo executa tudo → VEREDITOS_RESUMO.md gerado → Embaixador carrega na próxima ativação
```

---

## PARTE 0.5 — SECRETÁRIO VIRTUAL (opera antes de você)

> Se o Secretário Virtual estiver ativo (`SECRETARIO_VIRTUAL/`), os Passos 1 e 2 são automáticos.
> O cliente preenche o formulário → você recebe o briefing por email → vai direto para o Passo 3.

```
SEM SECRETÁRIO VIRTUAL:
  Você → qualifica → faz Discovery → formata briefing → Gemini
  (60–90 min do seu tempo)

COM SECRETÁRIO VIRTUAL:
  Cliente → formulário → Claude Haiku → email a você com briefing pronto
  Você → cola no Gemini → ativa o Pentalateral
  (5 min do seu tempo)
```

**Para instalar:** `SECRETARIO_VIRTUAL/SETUP_GUIDE.md` — setup completo em ~2 horas.

---

## PARTE 1 — projeto NOVO (primeira iteração, V1)

---

### PASSO 1 — Você qualifica o cliente (sozinho, antes de ativar qualquer membro)

> **Se o Secretário Virtual estiver ativo, este passo foi feito automaticamente.**
> Só executar manualmente se o lead chegou por outro canal (indicação, evento, chamada direta).

**Onde:** Conversa com o cliente (WhatsApp, chamada, reunião)
**Tempo:** 10 minutos
**Output:** Decisão GO ou NO-GO

Faça estas 3 perguntas — uma de cada vez, informalmente:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3 PERGUNTAS DE QUALIFICAÇÃO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

P1: "Qual é o problema que te custa dinheiro todos os meses
    por não estar resolvido?"

  → Resposta clara e específica = POSITIVO
  → Resposta vaga ("não sei", "quero crescer") = NEGATIVO

P2: "Que investimento faz sentido para resolver isso?"

  → Valor concreto compatível com o âmbito = POSITIVO
  → "O mínimo possível" ou "quanto é que custa?" = NEGATIVO

P3: "O que acontece se não resolver isso nos próximos 3 meses?"

  → Consequência real (perda de clientes, custo, concorrente) = POSITIVO
  → "Nada muito grave" = NEGATIVO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Resultado:**
- 3 positivos → **GO** — avançar para o Passo 2
- 1 ou 2 negativos → **NO-GO** — oferecer Produto de Entrada (diagnóstico pago, sem build)
- 3 negativos → **NO-GO** — não investir tempo do Pentalateral

> **Produto de Entrada:** uma sessão de diagnóstico onde você entrega ao cliente
> um mapa do problema, um roadmap de resolução, e uma proposta comercial.
> Sem código. Preço definido por você. Serve para qualificar quem tem dinheiro mas não tem clareza.

---

### PASSO 2 — Você faz o Discovery com o cliente

**Dois modos disponíveis:**

| Modo | Quando usar | Template |
|------|-------------|----------|
| **Informal (WhatsApp)** | Amigo, conhecido, primeiro contato descontraído | `FASE_PRE__DISCOVERY_WHATSAPP_AMIGO.txt` — 8 mensagens sequenciais, tom de parceria |
| **Formal (Questionário)** | Cliente pagante, reunião, proposta comercial | `FASE_PRE__QUESTIONARIO_CLIENTE_FORMAL.md` — 8 blocos estruturados |

**Onde:** Reunião, chamada, ou WhatsApp
**Tempo:** 30–60 minutos (formal) | assíncrono (informal)
**Output:** Briefing com as 8 respostas — vai ser a base de tudo

Faça uma pergunta de cada vez. Anote tudo. Não avance sem as 8 respostas.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
8 PERGUNTAS DE DISCOVERY — ANOTAR AS RESPOSTAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. PROJETO
   "O que é exatamente o que precisas?"
   (ecommerce, app, site, SaaS, automação, modelo de negócio, outro?)
   "Quem é o teu cliente ideal? Qual o teu mercado?"
   → Resposta: _______________________________________________

2. CENA DE SUCESSO ★ OBRIGATÓRIA (P-041)
   "Daqui a 6 meses, como é um dia perfeito com este sistema funcionando?"
   "Descreve: o que você faz, o que vê, o que sente quando funciona do jeito certo."
   → Resposta: _______________________________________________
   → Esta cena é o script da demo. O sistema é aprovado se a reproduzir.
   → Guardar em BRIEFING_DISCOVERY → campo cena_sucesso_descrita

3. PROBLEMA (em números)
   "Qual o maior problema que este projeto resolve HOJE?"
   "Dá-me um número — horas/semana, clientes perdidos, quanto deixas de faturar?"
   "Se não resolvermos isso, o que acontece concretamente?"
   → Resposta: _______________________________________________

3. O MOMENTO MÁGICO — FIRE Event  ★ CRÍTICO
   "Se um utilizador entrar no teu sistema e fizer UMA coisa
   que significa que o teu negócio funcionou — qual é essa coisa?"
   (comprou / agendou / pediu orçamento / registou-se / outro)
   → Resposta: _______________________________________________
   → success_event para sentinel_config.json: ________________

4. A VARINHA MÁGICA
   "Se pudéssemos colocar uma função impossível ou uma IA
   super-inteligente lá dentro — o que ela faria para te deixar
   à frente de toda a concorrência?"
   (Anotar sem filtrar. Captura a visão e os diferenciais futuros.)
   → Resposta: _______________________________________________

5. ESTADO atual
   "O que já existe? Código, design, domínio, contas, APIs, base de dados?"
   → Resposta: _______________________________________________

6. RECEITA E VOLUME
   "Como é que este projeto gera dinheiro?"
   "Qual o ticket médio por venda/serviço? Quantos clientes por mês?"
   (→ Correr calculadora_precificacao.py com estes dados)
   → Ticket médio: R$_______ | Volume: _______ /mês

7. URGÊNCIA
   "Há algum prazo fixo? Lançamento, evento, investidor, data de pico?"
   → Resposta: _______________________________________________

8. RECURSOS E ORÇAMENTO
   "Qual é o orçamento aproximado? Tens equipe? Que ferramentas já usas?"
   → Resposta: _______________________________________________

9. EXPANSÃO FUTURA ★ OBRIGATÓRIA (P-041 / P-008)
   "Se isto funcionar, quem mais no seu setor deveria ter?"
   "Tem colegas, parceiros ou conhecidos que teriam o mesmo problema?"
   → Nomes mencionados: _______________________________________________
   → Esta informação alimenta o "Crédito de Expansão entre Pares" (P-008)
   → Guardar em BRIEFING_DISCOVERY → campo leads_indicados[]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Guardar como:** `CLIENTES/[NOME_CLIENTE]/BRIEFING_DISCOVERY.md`
**Template:** `PENTALATERAL_UNIVERSAL/TEMPLATES/FASE_0__BRIEFING_DISCOVERY.md`

> 💡 **Ferramentas de apoio:**
> · `OPERACAO/DISCOVERY_CARD.md` — cartão para reuniões (imprimir A5 ou celular)
> · `FASE_PRE__DISCOVERY_WHATSAPP_AMIGO.txt` — 8 mensagens prontas para WhatsApp informal
> · `FASE_PRE__QUESTIONARIO_CLIENTE_FORMAL.md` — questionário completo para cliente pagante
> · `scripts/calculadora_precificacao.py` — correr após respostas 6 para gerar proposta

---

### PASSO 3 — Você ativa o Gemini

**Onde:** Chat do Gemini Advanced
**Tempo:** 5 minutos seus (preencher contexto) + 5–15 minutos do Gemini
**Output:** DIRETRIZ com 7 blocos obrigatórios + 5 ideias disruptivas

**Arquivo de referência:** `CLIENTES/[PROJETO]/PASSO3_GEMINI.md`
- Projeto novo → copiar de `PENTALATERAL_UNIVERSAL/OPERACAO/PASSO3_GEMINI_TEMPLATE.md`
- Projeto existente → abrir o arquivo, atualizar só o bloco `## 📋 CONTEXTO DO PROJETO`

**O que Eduardo atualiza no bloco de contexto (5 min):**
```
Loop atual:         Loop [N]
Construído até aqui: [dias entregues e outputs reais]
O que falta:        [dias restantes e o que cada um produz]
Maior risco agora:  [risco técnico ou comercial mais urgente]
Decisões fixadas:   [ex: Opção A, PWA, STJ adicionado — não reverter]
5 ideias do Músculo: [do último relatorio_evolutivo — copiar por nome]
```

**Ordem de envio ao Gemini (obrigatória — nunca inverter):**
```
1º → MEMORIA_V[X].md
2º → relatorio_evolutivo_V[X].md
3º → PASSO3_GEMINI.md  ← por último (o contexto carrega antes da nova ideia)
```

> O PASSO3_GEMINI.md já contém o Protocolo Anti-Deriva (4 contra-ataques ao Gemini)
> e as instruções para o Gemini compensar as deficiências do Músculo na DIRETRIZ.
> Eduardo não precisa escrever nada disso — já está no arquivo.

**Para projetos novos (primeira iteração) — usar o comando direto abaixo:**

Copiar o comando, preencher os campos `[entre colchetes]` com as respostas do Discovery, e enviar:

```
════════════════════════════════════════════════════════════
Pentalateral IAH — EDUARDO → GEMINI
projeto: [nome do projeto] | ITERAÇÃO: V1 | DATA: [data de hoje]
════════════════════════════════════════════════════════════

Gemini, somos o Pentalateral IAH.
Tu és o Estrategista. Eu sou o Diretor.
O NotebookLM é o Auditor. O Claude Code é o Músculo.

BRIEFING DO CLIENTE:
NICHO/SETOR:        [resposta da pergunta 1 do Discovery]
PROBLEMA PRINCIPAL:  [resposta da pergunta 2]
VOLUME MENSAL:       [resposta da pergunta 3]
RECEITA/TICKET:      [resposta da pergunta 4]
ESTADO atual:       [resposta da pergunta 5]
URGÊNCIA:            [resposta da pergunta 6]
RECURSOS/ORÇAMENTO:  [resposta da pergunta 7]
CAMADA ESTIMADA:     [1=MVP · 2=Produto · 3=Plataforma · 4=Ecossistema · 5=Monopólio]

RESPONDE COM 5 BLOCOS OBRIGATÓRIOS:

BLOCO 0 — DIAGNÓSTICO
  Qual é o problema real por trás do gargalo declarado?
  Qual a oportunidade que o cliente ainda não viu?

BLOCO 1 — CAMADA E 3 PRIORIDADES
  Confirma ou corrige a camada.
  Define as 3 entregas prioritárias em ordem de impacto comercial imediato.
  (máximo 3 — não 5, não 7 — exatamente 3)

BLOCO 2 — PROPOSTA COMERCIAL
  Nome do serviço, o que inclui, preço recomendado, prazo,
  argumento de ROI em linguagem do cliente (sem jargão técnico).

BLOCO 3 — DIRETRIZ TÉCNICA (mais importante para o Claude)
  [PARA O NOTEBOOKLM]: o que conectar do histórico de projetos
  [PARA O CLAUDE]: o que construir, em que ordem, alertas de risco
  [VISÃO DE LONGO PRAZO]: onde este projeto pode chegar em 3 iterações

BLOCO 4 — PRÓXIMOS PASSOS DO diretoR
  O que eu (Eduardo) faço nas próximas 24h para avançar.

OBRIGATÓRIO no final: 5 ideias disruptivas para a iteração seguinte.
════════════════════════════════════════════════════════════
```

**O que o Gemini vai devolver:**
Uma DIRETRIZ com os 5 blocos preenchidos + 5 ideias disruptivas no final.
O Bloco 3 é o coração — contém o que o Claude precisa para executar.

**Guardar como:** `CLIENTES/[NOME_CLIENTE]/DIRETRIZ_V1_ESTRATEGISTA.txt`

---

### PASSO 4 — Você valida a DIRETRIZ (5 minutos)

Antes de avançar, verificar se a DIRETRIZ está pronta para uso.
Marcar o que está presente:

```
CHECKLIST DE VALIDAÇÃO DA DIRETRIZ V1:

[ ] Bloco 0 — Diagnóstico com dados reais (não só sintomas vagos)
[ ] Bloco 1 — exatamente 3 prioridades, em ordem clara
[ ] Bloco 2 — ROI calculado com os dados declarados pelo cliente
[ ] Bloco 3 — [PARA O NOTEBOOKLM] preenchido com instrução específica
[ ] Bloco 3 — [PARA O CLAUDE] preenchido com o que construir e alertas
[ ] Bloco 4 — ação concreta para o diretor nas próximas 24h
[ ] 5 ideias disruptivas presentes no final
```

**5–7 marcados → excelente, avançar.**
**3–4 marcados → pedir complemento ao Gemini:**

```
[Enviar ao Gemini]:
"O Bloco [X] precisa de mais detalhe.
Falta: [o que falta — ex: 'o ROI não está calculado com dados reais'].
Podes completar essa parte?"
```

**Menos de 3 → pedir refazer:**
```
[Enviar ao Gemini]:
"A DIRETRIZ precisa de ser mais específica.
Podes recomeçar com foco no diagnóstico real do cliente?
O problema central é [descrever em 1 frase o que você entendeu]."
```

---

### PASSO 5 — Você ativa o NotebookLM

**Quando usar:** Camada 2 ou superior, OU quando há projetos anteriores com módulos reutilizáveis.
**Quando saltar:** Primeiro projeto de sempre (sem histórico), OU Camada 1 simples.

**Onde:** Interface do NotebookLM
**Tempo:** 10 minutos seus (carregar fontes + atualizar contexto) + 10–20 minutos do NotebookLM

**Arquivo de referência:** `CLIENTES/[PROJETO]/PASSO5_NOTEBOOKLM.md`
- Projeto novo → copiar de `PENTALATERAL_UNIVERSAL/OPERACAO/PASSO5_NOTEBOOKLM_TEMPLATE.md`
- Projeto existente → abrir o arquivo, atualizar só o bloco `## 📋 CONTEXTO DO PROJETO`

> O PASSO5_NOTEBOOKLM.md já contém o Protocolo Anti-Alucinação (4 contra-ataques ao NotebookLM)
> e as instruções para o Auditor compensar as deficiências do Músculo na Skill.
> Eduardo não precisa escrever nada disso — já está no arquivo.

**ANTES de colar o PASSO5_NOTEBOOKLM.md, carregar estas fontes no NotebookLM NESTA ORDEM:**

```
FONTES A CARREGAR (na ordem):
1. DIRETRIZ_V1_ESTRATEGISTA.txt    ← output do Gemini (Passo 3)
2. BRIEFING_DISCOVERY.txt          ← as 9 respostas V3 — P-041 (Passo 2)
3. MEMORIA_V[X].md                 ← se existirem MEMORIAs anteriores
4. relatorio_evolutivo_v[X].md     ← se existirem relatórios anteriores
5. skill-v[X].md anterior          ← se existir Skill de iteração anterior
6. PERFIL_CLIENTE.md               ← se existir (usar PERFIL_CLIENTE_TEMPLATE.md)
   → Dá ao NotebookLM o perfil humano do cliente além do contexto técnico
   → A Skill gerada fica calibrada ao que o cliente realmente quer
```

**Depois de carregar as fontes, colar este comando:**

```
════════════════════════════════════════════════════════════
Pentalateral IAH — EDUARDO → NOTEBOOKLM
projeto: [nome] | ITERAÇÃO: V1
════════════════════════════════════════════════════════════

NotebookLM, actuas como Sócio Consultor do Pentalateral IAH.
Não apenas arquivo — consultor ativo com memória longa.

ANALISA O projeto [NICHO/TIPO] COM 4 objetivos:

1. AUDITORIA DE COERÊNCIA
   A DIRETRIZ do Gemini está alinhada com o histórico?
   Há contradições, módulos duplicados, riscos ignorados?
   Se sim — nomeia os específicos.

2. PERSPECTIVA DO SÓCIO CONSULTOR
   Baseado em todos os projetos que conheces:
   · O que sistematicamente funciona neste tipo de projeto?
   · O que sistematicamente falha neste tipo de projeto?
   · O que este projeto tem de diferente que pode mudar o padrão?
   · O que o Gemini e o Claude não estão a ver?
   · Qual a abordagem com maior probabilidade de sucesso?

3. MÓDULOS REUTILIZÁVEIS
   O que já foi construído que se aplica diretamente?
   O que precisa de adaptação? O que é mesmo do zero?
   Localização exata nos arquivos, se disponível.

4. GERAR SKILL TÉCNICA PARA O CLAUDE
   Formato obrigatório da Skill (bloco copiável):
   ────────────────────────────────────────────
   SKILL — [projeto] — V1
   Gerada por: NotebookLM (Auditor/Sócio Consultor)
   ────────────────────────────────────────────
   CONTEXTO DO projeto
   Cliente: [nome/nicho] | Camada: [X] | Stack esperada: [X]
   Problema principal: [1 frase]
   objetivo desta iteração: [1 frase]

   [CONEXÃO HISTÓRICA — Para o Claude]
   [módulos reutilizáveis com localização exata]

   [PADRÃO DE SUCESSO]
   [o que funcionou em projetos similares]

   [PADRÃO DE FALHA]
   [o que falhou e deve ser evitado]

   [PERSPECTIVA DO SÓCIO CONSULTOR]
   [insight histórico que o Gemini e o Claude não estão a ver]

   SEQUÊNCIA DE BUILD RECOMENDADA
   [módulos em ordem de prioridade]

   ALERTAS CRÍTICOS
   [avisos importantes]

   O QUE NÃO CONSTRUIR NESTA ITERAÇÃO
   [e porquê]
   ────────────────────────────────────────────

Fontes carregadas: [listar os arquivos que carregou]
════════════════════════════════════════════════════════════
```

**O que o NotebookLM vai devolver:**
1. Análise de coerência da DIRETRIZ (possíveis contradições)
2. Perspectiva do Sócio Consultor (padrões históricos)
3. Lista de módulos reutilizáveis com localização
4. A Skill técnica pronta para o Claude

**Guardar a Skill como:** `.claude/skills/[nome-projeto]-v1.md`

> **Nota:** Se o NotebookLM não tiver fontes suficientes para a perspectiva histórica,
> irá dizer isso — e isso é informação válida. "Sem histórico suficiente neste tipo de projeto"
> já é um sinal útil para o Claude operar com mais cautela.

---

### PASSO 6 — Você ativa o Músculo (Claude Code)

**Onde:** Terminal com Claude Code instalado
**Arquivo de referência:** `CLIENTES/[PROJETO]/PASSO6_MUSCULO.md`
- O Músculo lê este arquivo internamente antes de deliberar
- Eduardo não precisa colar o PASSO6 — ele é o guia interno do Músculo
- Projeto novo → copiar de `PENTALATERAL_UNIVERSAL/OPERACAO/PASSO6_MUSCULO_TEMPLATE.md`

**O que Eduardo diz para ativar:**
```
PROTOCOLO VANGUARD — [nome do projeto]. Leia tudo e delibere.
```

**Em seguida, trazer nesta ordem:**

**1º — A Skill do NotebookLM** (salvar em `.claude/skills/[projeto].md` antes):
```
[O Músculo lê o arquivo .claude/skills/[projeto].md automaticamente via PROTOCOLO VANGUARD]
```

**2º — A DIRETRIZ completa do Gemini:**
```
[colar a DIRETRIZ completa recebida no Passo 3]
```

**O que o Músculo faz antes de responder (PASSO6_MUSCULO.md — automático):**
- Executa o Checklist de Imunidade (5 defesas internas)
- Lê Skill + DIRETRIZ completas antes de qualquer palavra
- Delibera no formato de 7 pontos para cada prioridade
- Apresenta plano de build — aguarda Veredito do Diretor antes de construir

**O que esperar do Claude:**
O Claude vai processar tudo e apresentar, nesta sequência:
1. **Confirmação de leitura** — confirma que leu Skill, DIRETRIZ e Briefing
2. **ANÁLISE PENTALATERAL** — tipo detectado, camada, stack recomendada, ROI, o que não construir
3. **Score de Confiança da DIRETRIZ** (0–10) — avalia a solidez da estratégia do Gemini
4. **Deliberação** — se houver propostas do Gemini que mereçam debate, o Claude analisa antes de construir
5. **Pedido de confirmação** para avançar para o Plano de Build

**Se o Score for baixo (abaixo de 7):**
O Claude vai dizer o que falta na DIRETRIZ.
Você volta ao Gemini e pede o complemento (ver Passo 4 — como pedir complemento).
Depois cola a versão melhorada no Claude.

---

### PASSO 7 — Você aprova o Plano de Build

O Claude vai apresentar um plano estruturado antes de escrever qualquer código:

```
PLANO DE BUILD — V1 — [NOME DO projeto]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Stack: [tecnologias confirmadas]

Módulo 1: [nome] — [porquê é prioritário] — estimativa: [X dias]
Módulo 2: [nome] — [dependências] — estimativa: [X dias]
Módulo 3: [nome] — [risco: SIM/NÃO] — estimativa: [X dias]

Total: [X dias / sessões]
O que NÃO será construído nesta iteração: [lista — e porquê]
Dívidas técnicas previstas: [P0/P1/P2 ou NENHUMA]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Aguardo confirmação do Diretor. →
```

**O que verificar antes de aprovar:**
```
[ ] Os módulos correspondem às 3 prioridades do Bloco 1 do Gemini
[ ] A stack faz sentido para a camada e o volume declarado
[ ] O prazo total é aceitável para o cliente
[ ] O que "não será construído" faz sentido (não é falta — é priorização)
[ ] Nenhuma dívida P0 prevista (se houver, decidir antes de avançar)
```

**Para aprovar:**
```
"Confirmo o plano. Pode avançar."
```

**Para ajustar:**
```
"Módulo 2 não é prioridade agora — tira desta iteração.
Adiciona [outro módulo] no lugar."
```

**Regra inviolável:** O Claude não escreve uma linha de código sem plano aprovado por você.

---

### PASSO 8 — O Claude executa (você supervisiona)

**O que o Claude faz durante a execução:**
- Constrói módulo a módulo
- Reporta o fim de cada módulo
- Emite ALERTAS quando detecta situações que precisam de decisão sua

**Tipos de ALERTA que pode receber:**

```
ALERTA: [módulo X] já existe em [local]. Reutilizar ou construir novo?
  → Você responde: "Reutiliza" ou "Constrói novo porque [razão]"

ALERTA SEGURANÇA: [descrição do risco]. Resolver antes de avançar.
  → Você responde: "Resolve" — nunca ignorar

ALERTA ÂMBITO: [feature Y] não estava no plano aprovado. Confirmas?
  → Você responde: "Confirmo" ou "Não inclui — mantém o plano original"

ALERTA PRAZO: estimativa [X dias] vs prazo declarado [Y dias].
  → Você responde: "Reduz o âmbito" ou "Estendo o prazo" ou "Aceito o risco"

ALERTA P0: [problema crítico]. Resolve antes de nova feature.
  → Você responde: "Resolve o P0 primeiro. Pausa tudo o resto."

ALERTA TÉCNICO — [decisão]:
  O Gemini propõe [X].
  A minha avaliação: [risco técnico].
  Alternativa: [Y].
  → Você decide: "Aceito alternativa do Claude" ou "Mantém proposta do Gemini"
```

**Quando NÃO interromper:**
- Quando o Claude está a construir dentro do plano aprovado
- Quando não há ALERTA ativo
- Quando não fez nenhuma pergunta

> **O silêncio do Claude durante a execução é boa notícia — significa que está a construir.**

---

### PASSO 9 — O Claude entrega os arquivos finais (COMANDO 5)

Ao terminar a iteração, o Claude entrega automaticamente:

```
════════════════════════════════════════════════════════════
CLAUDE → EDUARDO — FECHO DA ITERAÇÃO V1 — [projeto]
════════════════════════════════════════════════════════════

ENTREGÁVEIS:

1. MEMORIA_V1_[projeto].md — memória técnica completa
   Contém: módulos construídos, variáveis de ambiente, deploy, próximos recomendados

2. relatorio_evolutivo_v1_[projeto].md — análise de negócio
   Contém: o que foi construído (linguagem cliente), análise, ROI, [VISÃO LMM]
   [VISÃO LMM] inclui: 5 ideias técnicas para a próxima iteração

3. COMANDO_ESTRATEGISTA_V1.md — pronto para colar no Gemini
   Contém: MEMORIA + relatorio + [REAGE A ESTAS IDEIAS DO MÚSCULO]
   O diretor não precisa formatar nada — copia e cola diretamente

ESTADO FINAL:
Módulos entregues: [lista]
Dívidas técnicas: [lista ou NENHUMA]
O que ficou fora: [e porquê]

ação IMEDIATA DO diretoR:
1. Validar entregáveis
2. Aprovar commit
3. Abrir COMANDO_ESTRATEGISTA_V1.md → copiar → colar no Gemini
════════════════════════════════════════════════════════════
```

**O que verificar antes de aprovar:**

Na **MEMORIA_V1:**
```
[ ] Todos os módulos entregues estão listados
[ ] Variáveis de ambiente / configurações estão listadas (sem valores)
[ ] Instruções de deploy estão presentes e claras
[ ] Próximos módulos recomendados estão presentes
```

No **relatorio_evolutivo_v1:**
```
[ ] Escrito em linguagem de negócio (sem jargão técnico)
[ ] Pontos fortes e pontos fracos presentes
[ ] ROI estimado com dados reais
[ ] [VISÃO LMM] com 5 ideias do Claude presente
```

No **COMANDO_ESTRATEGISTA_V1:**
```
[ ] Conteúdo da MEMORIA incluído
[ ] Conteúdo do relatorio incluído
[ ] [REAGE A ESTAS IDEIAS DO MÚSCULO] com as 5 ideias do Claude
[ ] Pedido dos 5 blocos de DIRETRIZ V2 presente
[ ] Copiável diretamente para o Gemini sem formatação adicional
```

**Se faltar algo:**
```
"Antes de fechar, preciso que completes:
- [o que falta no MEMORIA / relatorio / COMANDO]"
```

---

### PASSO 10 — Você fecha a iteração e inicia a próxima

**Aprovar o commit:**
```
"Aprovado. Pode fazer o commit."
```

**Entregar ao cliente:**
- Relatório em linguagem de negócio (de relatorio_evolutivo_v1)
- Acesso ao que foi construído
- Próxima iteração proposta (com base no Bloco 2 do Gemini e nas 5 ideias do Claude)

**ativar o ROI Tracker:**
1. Copiar `ROI_TRACKER_TEMPLATE.md` para `CLIENTES/[NOME_CLIENTE]/ROI_CHECK_V1_30DIAS.md`
2. Registar o ROI prometido (base de comparação)
3. Marcar lembrete no calendário: **data de hoje + 30 dias**
4. Em 30 dias: usar a Mensagem 1 do template para contactar o cliente

**Abrir o próximo ciclo:**
1. Abrir `CLIENTES/[NOME_CLIENTE]/COMANDO_ESTRATEGISTA_V1.md`
2. Copiar todo o conteúdo
3. Colar diretamente no Gemini

---

### RITUAL DE FECHAMENTO DE SESSÃO — Intelligence Compounding

> **Executar ao fechar QUALQUER sessão do Pentalateral — não só ao fechar versão.**
> Este ritual garante que a inteligência da sessão não se perde.

```powershell
# Na pasta do projeto:
.\scripts\session_close.ps1
```

O script faz 4 perguntas (30 segundos):
1. Houve FRICÇÃO? (ALERTA emitido, escopo mudou, P0 criado)
2. Algum PRINCÍPIO novo foi descoberto?
3. O Diretor fez OVERRIDE de algum veto?
4. Houve DERIVA de algum princípio ativo?

Cada resposta é registrada automaticamente no `INTELLIGENCE_LEDGER.md` e no `knowledge_graph.json`.

**Por que isso importa:** cada sessão sem este ritual é inteligência perdida. O sistema não aprende sozinho — aprende quando você fecha o loop.

**Arquivos atualizados pelo script:**
- `INTELLIGENCE_LEDGER.md` — nova entrada `[SESSÃO YYYY-MM-DD]`
- `knowledge_graph.json` — `meta.last_updated` + nova sessão no histórico

> ⚠️ Se o `INTELLIGENCE_LEDGER.md` não for atualizado por 3 dias consecutivos,
> o GUT do Despacho Matinal sobe automaticamente como penalidade.

O Gemini vai receber:
- O que foi construído (MEMORIA)
- A avaliação do Claude (relatorio + 5 ideias do Músculo)
- O pedido explícito para **reagir às ideias do Claude** e gerar a DIRETRIZ V2

**O loop fecha. A iteração V2 começa no Passo 4.**

---

## PARTE 2 — ITERAÇÕES SEGUINTES (V2, V3, V4...)

O processo é o mesmo da Parte 1 — com estas diferenças evolutivas:

### O que muda no Passo 3 (Gemini) a partir de V2

Você **não** cola um novo briefing. Cola o COMANDO_ESTRATEGISTA gerado pelo Claude.
Este documento já contém tudo que o Gemini precisa.

**O que o Gemini recebe no COMANDO_ESTRATEGISTA:**
```
• MEMORIA_V1 — o que foi construído tecnicamente
• relatorio_evolutivo_v1 — como o negócio evoluiu
• [REAGE A ESTAS IDEIAS DO MÚSCULO] — as 5 ideias do Claude
• Estado atual: camada, receita/MRR, próximo objetivo
• Pedido dos 5 blocos de DIRETRIZ V2
```

**O que o Gemini vai devolver:**
```
• DIRETRIZ V2 que:
  - Reage às 5 ideias do Claude (aprova, modifica ou descarta)
  - Propõe as suas próprias 5 ideias novas
  - Define 3 prioridades baseadas no que foi aprendido em V1
  - Inclui [PARA O NOTEBOOKLM] e [PARA O CLAUDE] atualizados
```

> **Este é o diálogo entre Gemini e Claude.** Eles nunca falam diretamente —
> você é o canal. Mas o COMANDO_ESTRATEGISTA garante que cada membro responde ao que o outro propôs.
> A inteligência emerge desta conversa indireta.

### O que muda no Passo 5 (NotebookLM) a partir de V2

Adicionar às fontes carregadas:
- MEMORIA_V1 (agora existente)
- relatorio_evolutivo_v1 (agora existente)
- skill-v1.md (a Skill anterior)

A Skill V2 gerada vai:
- Conectar a DIRETRIZ V2 ao que foi construído em V1
- Identificar módulos de V1 reutilizáveis em V2
- Detectar padrões que emergiram na primeira iteração
- atualizar [PADRÃO DE SUCESSO] e [PADRÃO DE FALHA] com dados reais

### O que muda no Passo 6 (Claude) a partir de V2

O Claude começa a ter contexto acumulado real.
Em vez de trabalhar com estimativas, trabalha com dados do projeto específico.
A deliberação sobre a DIRETRIZ fica mais afinada porque o Claude conhece a arquitectura de V1.

---

## PARTE 3 — A EVOLUÇÃO CICLO A CICLO

### Como o sistema fica mais inteligente

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ITERAÇÃO V1 — O PENTALATERAL NASCE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Gemini        → Analisa com base em conhecimento geral
NotebookLM    → Pouco histórico (ou nenhum)
Claude        → Sem contexto do projeto específico
Resultado     → Bom produto, estimativas calibradas ao mercado geral

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ITERAÇÃO V2 — O LOOP COMEÇA A GANHAR VALOR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Gemini        → Reage às 5 ideias do Claude de V1
              → DIRETRIZ mais afinada com o que foi aprendido
NotebookLM    → Tem MEMORIA_V1 — identifica módulos reutilizáveis
              → Detecta padrões de sucesso e falha de V1
Claude        → Conhece a arquitectura de V1
              → Reutiliza em vez de construir do zero
              → Estimativas mais precisas (dados reais de V1)
Resultado     → Mais rápido, mais preciso, menos retrabalho

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ITERAÇÃO V3 — A MÁQUINA COMEÇA A APRENDER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Gemini        → Recebe feedback real de 2 ciclos
              → Propõe ideias que sabe que o Claude consegue executar
NotebookLM    → Tem 2 MEMORIAs — começa a ver padrões
              → "Em V1 estimámos X, foi Y — ajusta a estimativa de V3"
Claude        → Tem arquitectura de 2 iterações para reutilizar
              → Boilerplate real do projeto específico
              → Identifica onde pode acelerar com base no que já construiu
Resultado     → Velocidade 2x de V1. Custo de erros perto de zero.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ITERAÇÃO V5+ — o Pentalateral é IMPOSSÍVEL DE COPIAR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Gemini        → Debate com o Claude como sócio experiente
              → Sabe o que é viável nesta stack específica
NotebookLM    → Banco de padrões real do projeto e do SETOR
              → Pode dizer "é exatamente como V2, mas com a variável X diferente"
Claude        → Sistema em evolução, não projeto novo
              → Estima com precisão, executa com velocidade, antecipa problemas
Resultado     → Produto no mercado. Código de qualidade. Cliente independente.
              O que levaria 6 meses levou 6 semanas.
```

---

## PARTE 4 — O DIÁLOGO ENTRE GEMINI E CLAUDE

Este é o coração do Pentalateral — o debate que ninguém vê mas que produz os melhores resultados.

### Como funciona na prática

**Ao fechar V1, o Claude propõe no relatorio:**
```
[VISÃO LMM] — 5 IDEIAS PARA A PRÓXIMA ITERAÇÃO

1. Integrar WhatsApp API para confirmações automáticas
   → Impacto estimado: reduz no-show do cliente em 40%

2. Dashboard de ocupação em tempo real
   → Impacto estimado: cliente consegue reagir a buracos na agenda

3. Sistema de lista de espera automática
   → Impacto estimado: preenche cancelamentos sem intervenção

4. Relatório mensal automático por email ao cliente do cliente
   → Impacto estimado: fidelização + argumento para upsell

5. Módulo de avaliação pós-consulta (NPS integrado)
   → Impacto estimado: dados de qualidade para o cliente melhorar
```

**No início de V2, o Gemini recebe essas 5 ideias e responde:**
```
[RESPOSTA ÀS IDEIAS DO MÚSCULO]

Ideia 1 (WhatsApp): APROVADA — prioritária para V2.
  Acrescento: testar primeiro com template de confirmação simples antes do flow completo.

Ideia 2 (Dashboard): MODIFICADA — não é V2.
  Em V2 o cliente precisa de revenue. Dashboard é V3 quando já há dados para mostrar.

Ideia 3 (Lista de espera): APROVADA para V2.
  Posso ser mais específico: lista de espera por médico, não por clínica.

Ideia 4 (Relatório mensal): APROVADA — mas como V3.
  Primeiro validar que o cliente usa o sistema todos os dias (V2), depois relatório.

Ideia 5 (NPS): DESCARTADA por agora.
  O cliente ainda não tem volume suficiente para dados de NPS serem úteis.
  Reavaliar em V4.

[MINHAS IDEIAS PARA O CLAUDE REAGIR]
A. Módulo de reagendamento pelo próprio paciente — tecnicamente viável em V2?
B. Integração com Google Calendar bidirecional — quanto esforço adicional?
C. Perfil do paciente com histórico de consultas — vale a pena nesta camada?
```

**O Claude lê esta resposta ao ativar para V2 e responde na deliberação:**
```
[REação ÀS IDEIAS NOVAS DO GEMINI]

A. Reagendamento pelo paciente: VIÁVEL em V2.
   Cuidado: requer lógica de validação de slots disponíveis.
   Estimativa: +2 dias de desenvolvimento. Impacto: alto (autonomia do paciente).
   Recomendo incluir se o prazo permitir.

B. Google Calendar bidirecional: NÃO V2.
   Syncing bidirecional tem edge cases que facilmente viram P0.
   Proposta: V2 faz Calendar → sistema (unidirecional). V3 faz bidirecional.

C. Perfil do paciente: APROVADO com ajuste.
   Perfil básico (nome, contato, histórico de consultas) cabe em V2.
   Perfil completo (fichas clínicas) é Camada 3 e tem implicações de LGPD.
   Fazer o básico agora, documentar o que fica para V3.
```

> **Resultado:** A DIRETRIZ V2 é mais inteligente do que qualquer um dos dois teria produzido sozinho.
> O Gemini conhece o mercado. O Claude conhece o sistema. A tensão entre os dois produz o produto certo.

---

## PARTE 5 — REFERÊNCIA RÁPIDA

### Onde vai cada coisa (estrutura de pastas)

```
CLIENTES/
└── [NOME_CLIENTE]/
    ├── BRIEFING_DISCOVERY.txt          ← Passo 2 — as 7 respostas
    ├── DIRETRIZ_V1_ESTRATEGISTA.txt    ← Passo 3 — output do Gemini
    ├── DIRETRIZ_V2_ESTRATEGISTA.txt    ← iteração seguinte
    ├── PROPOSTA_COMERCIAL.pdf          ← baseada no Bloco 2 do Gemini
    ├── CONTRATO.pdf
    ├── MEMORIA_V1.md                   ← Passo 9 — entregável do Claude
    ├── MEMORIA_V2.md
    ├── relatorio_evolutivo_v1.md       ← Passo 9 — entregável do Claude
    ├── relatorio_evolutivo_v2.md
    ├── COMANDO_ESTRATEGISTA_V1.md      ← Passo 9 — gerado automaticamente
    ├── COMANDO_ESTRATEGISTA_V2.md
    ├── src/
    │   ├── api/
    │   ├── web/
    │   ├── mobile/
    │   └── infra/
    └── CONSELHO/
        ├── Auditor/
        │   ├── skill-v1.md             ← Passo 5 — output do NotebookLM
        │   └── skill-v2.md
        └── Estrategista/
            └── [comandos para o Gemini]
```

### Quem ativa quem, quando

| Passo | Você faz | Para quem | Output esperado |
|-------|----------|-----------|-----------------|
| 1 | Qualifica cliente | — (você sozinho) | GO / NO-GO |
| 2 | Discovery | Cliente | Briefing com 9 respostas V3 (P-041) |
| 3 | Envia COMANDO 1 | **Gemini** | DIRETRIZ com 5 blocos |
| 4 | Valida DIRETRIZ | — (você sozinho) | Score de validação |
| 5 | Envia COMANDO 2 | **NotebookLM** | Skill técnica do Claude |
| 6 | ativa PROTOCOLO VANGUARD | **Claude** | Confirmação + Análise |
| 7 | Aprova plano | **Claude** | Build iniciado |
| 8 | Decide sobre ALERTAs | **Claude** | Execução contínua |
| 9 | Recebe COMANDO 5 | **Claude** → você | MEMORIA + relatorio + ESTRATEGISTA |
| 10 | Cola ESTRATEGISTA | **Gemini** | DIRETRIZ da próxima iteração |

### Tempo estimado por passo (o seu tempo)

| Passo | Seu tempo |
|-------|-----------|
| Qualificação | 10 min |
| Discovery | 30–60 min |
| ativar Gemini | 5 min |
| Validar DIRETRIZ | 5 min |
| ativar NotebookLM | 10 min |
| ativar Claude | 5 min |
| Aprovar plano | 10 min |
| Supervisão da execução | 5–15 min/dia |
| Verificar entregáveis | 15 min |
| Fechar + próximo ciclo | 5 min |
| **Total (excluindo execução)** | **~100–140 min** |

---

## PARTE 6 — O QUE FAZER QUANDO...

### O Gemini propõe algo que o Claude já construiu

Não precisa fazer nada — o Claude vai detectar e emitir:
```
ALERTA: O módulo [X] já existe em [localização]. Reutilizar ou construir novo?
```
Você responde: `"Reutiliza."`

### O Claude discorda do Gemini

O Claude apresenta um ALERTA TÉCNICO formal:
```
ALERTA TÉCNICO — [nome da decisão]
O Estrategista propõe: [proposta do Gemini]
A minha avaliação: [por que tem risco]
O risco concreto: [o que pode falhar e o impacto]
Alternativa recomendada: [proposta do Claude]
Aguardo Veredito do Diretor.
```

Você decide:
- `"Aceito a alternativa do Claude."` — Claude documenta e avança com a alternativa
- `"Mantém a proposta do Gemini."` — Claude documenta o override e constrói conforme o Gemini

### O prazo está em risco

```
ALERTA PRAZO: estimativa [X dias] vs prazo declarado [Y dias].
```

Opções:
- `"Reduz o âmbito. Tira o Módulo [X] desta iteração."` — mais rápido
- `"Aceito o prazo estendido. Avisa o cliente."` — mais completo
- `"Podes trabalhar os Módulos 2 e 3 em paralelo?"` — mais rápido se independentes

### O cliente muda o gargalo a meio

**Parar tudo.** Voltar ao Passo 2.
Novas 7 perguntas com o novo contexto.
Novo ciclo com nova DIRETRIZ do Gemini.

`"Claude, o cliente mudou o foco. Pausa a execução. Vamos reformular."`

### Não tem histórico no NotebookLM

Saltar o Passo 5. Ir diretamente do Gemini para o Claude.
O NotebookLM só tem valor quando tem fontes para analisar.
A partir do segundo projeto começa a ter valor real.

### Quer saber em que ponto está o projeto

Pedir ao Claude:
```
"Dá-me o estado atual do projeto em 5 bullets."
```

O Claude responde com:
```
ESTADO atual — [projeto] — [DATA]
• Módulo 1: COMPLETO
• Módulo 2: EM CURSO — [o que falta]
• Módulo 3: NÃO INICIADO
• Dívidas técnicas ativas: [lista ou NENHUMA]
• Próximo passo: [ação exata]
```

### Retoma o projeto depois de uma pausa

Iniciar uma nova sessão do Claude com:
```
Músculo — sessão nova.
projeto: [NOME], Camada [X], iteração V[Y].
Estado: [o que foi feito em 3 bullets — copiar do ESTADO atual].
Próximo passo: [o que começa agora].
Lê a Skill do cliente antes de qualquer ação.
```

---

## PARTE 7 — REGRAS DE OURO DO diretoR

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REGRA 1 — O VEREDITO É SEU
  Nenhum membro avança sem a sua aprovação.
  O Músculo não constrói sem plano aprovado.
  O commit não acontece sem o seu "Aprovado".
  O Pentalateral tem poder máximo — mas o veredito é sempre seu.

REGRA 2 — O COMANDO_ESTRATEGISTA É SAGRADO
  Ao fechar cada iteração: copiar → colar no Gemini.
  É o que fecha o loop e garante que o próximo ciclo começa mais inteligente.
  Saltar isto é quebrar o Pentalateral.

REGRA 3 — CLAUDE SEM SKILL (CAMADA 2+) É CLAUDE SEM MEMÓRIA
  O NotebookLM existe para dar contexto histórico ao Claude.
  Na Camada 2+, saltar o Passo 5 é trabalhar sem rede de segurança.

REGRA 4 — NUNCA CONSTRUIR COM DIRETRIZ INVÁLIDA
  Se o Score de Confiança do Claude for baixo, reformular antes de avançar.
  Gastar 1h a reformular é melhor do que 3 dias a refazer.

REGRA 5 — OS ALERTAS DO CLAUDE SÃO PRIORIDADE
  Um ALERTA P0 ou ALERTA TÉCNICO bloqueia tudo.
  Decidir imediatamente. Não deixar acumular.

REGRA 6 — O CLIENTE VÊ O RELATÓRIO, NÃO A ESTRATÉGIA
  A DIRETRIZ, a Skill e os ALERTAs são internos.
  O cliente recebe o relatorio_evolutivo — em linguagem de negócio.
  O motor é invisível. O resultado é o que importa.

REGRA 7 — CADA ITERAÇÃO ENTREGUE É UM ativo
  Não é só um projeto concluído.
  É uma MEMORIA, um padrão validado, um boilerplate que acelera o próximo.
  O valor do Pentalateral cresce de forma não-linear — exponencial.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## PARTE 8 — GLOSSÁRIO OPERACIONAL

| Termo | O que é | Quando usar |
|-------|---------|-------------|
| **DIRETRIZ** | Documento do Gemini com 5 blocos — é o PLAN do ciclo | Sempre, ao início de cada iteração |
| **Skill** | arquivo .md do NotebookLM com contexto e padrões para o Claude | Camada 2+, antes de ativar o Claude |
| **MEMORIA_Vx** | Registo técnico do que foi construído na iteração X | Gerado pelo Claude ao fechar |
| **relatorio_evolutivo** | Análise de negócio + [VISÃO LMM] para o cliente e para o Gemini | Gerado pelo Claude ao fechar |
| **COMANDO_ESTRATEGISTA** | Documento pré-formatado para colar no Gemini no próximo ciclo | Gerado pelo Claude ao fechar — colar imediatamente |
| **[VISÃO LMM]** | As 5 ideias do Claude para a próxima iteração | Está no relatorio_evolutivo |
| **[REAGE A ESTAS IDEIAS]** | Pedido ao Gemini para responder às ideias do Claude | Está no COMANDO_ESTRATEGISTA |
| **Score de Confiança** | Avaliação do Claude sobre a solidez da DIRETRIZ (0–10) | Antes de qualquer build |
| **ALERTA P0** | Problema crítico que bloqueia produção | Resolver antes de qualquer feature |
| **Veredito** | Sua decisão final — único que pode aprovar avanços | Em qualquer momento de decisão |
| **Camada** | Nível de complexidade: 1=MVP, 2=Produto, 3=Plataforma, 4=Ecossistema, 5=Monopólio | Para classificar o projeto |
| **Handoff** | Entrega ao cliente com tudo para operar sozinho | Fase 5 — ao fechar o projeto |

---

## AVALIAÇÃO HONESTA — O QUE ROMPEMOS COM ESTA FERRAMENTA

Eduardo, você pediu uma avaliação honesta. Aqui está, sem suavizar.

### O que criámos de genuinamente novo

O que a maioria dos operadores faz com IA:
usar uma ferramenta de cada vez, de forma isolada, sem loop entre elas.
O Gemini sugere. O Claude constrói. O NotebookLM arquiva.
Três ferramentas poderosas — mas sem conversa entre elas.
O resultado é a soma das partes.

O que o Pentalateral faz:
cria um protocolo de troca entre ferramentas que normalmente não se comunicam.
O COMANDO_ESTRATEGISTA leva as 5 ideias do Claude para o Gemini.
O Gemini reage e enriquece.
O NotebookLM captura tudo e alimenta o próximo ciclo.
O resultado é mais do que a soma das partes.

**Isso não é trivial. É a diferença entre usar ferramentas e construir um sistema.**

### O que este sistema tem de difícil de copiar

Qualquer pessoa pode abrir o Gemini, o Claude e o NotebookLM amanhã.
O que não se copia em semanas é o que o sistema acumula:
- As MEMORIAs de N iterações reais
- Os padrões de sucesso indexados com dados reais do seu mercado
- As estimativas calibradas com a sua realidade (não com benchmarks genéricos)
- O diálogo estabelecido entre Gemini e Claude ao longo de ciclos

Em V1, o Pentalateral é um bom processo.
Em V5, é uma vantagem competitiva real.
Em V10, é um ativo que vale muito mais do que a soma das ferramentas.

### O que é difícil neste sistema — e você precisa saber

**A barreira não é técnica — é de consistência.**
O loop só funciona se o COMANDO_ESTRATEGISTA for sempre enviado ao Gemini.
Se uma iteração fechar sem gerar o COMANDO_ESTRATEGISTA, o loop quebra.
O próximo ciclo começa do zero em vez de começar mais inteligente.

**A qualidade do Gemini depende da qualidade das perguntas.**
Um COMANDO 1 vago produz uma DIRETRIZ vaga.
Um COMANDO 1 com dados reais produz uma DIRETRIZ accionável.
O Pentalateral não compensa um briefing mal feito — amplifica o que recebe.

**O NotebookLM fica mais valioso com o tempo — mas precisa de fontes.**
Nos primeiros 2–3 projetos, o valor do Auditor é limitado.
A partir do 4º–5º, começa a ter padrões reais para extrair.
Não subestime — mas não sobrestime nos primeiros meses.

### A barreira que rompemos

A maioria das metodologias de IA para negócios trata cada sessão como isolada.
Você começa uma conversa com o Claude. Ela termina. A próxima começa do zero.
O conhecimento fica na cabeça de quem operou — não no sistema.

O Pentalateral trata cada sessão como um elo de uma cadeia.
O que foi aprendido em V1 alimenta V2.
O que foi debatido entre Gemini e Claude em V2 fica documentado para V3.
O sistema cresce. A velocidade aumenta. O custo de erro diminui.

Isso é o que significa ser um **organismo vivo** — não uma ferramenta, mas um sistema que aprende.

**Rompemos a barreira da continuidade.**
E com ela, a barreira da escalabilidade.
O Eduardo de daqui a 6 meses vai operar com a inteligência acumulada de N iterações reais —
não com a memória de conversas perdidas.

Isso é genuinamente valioso. E o mais importante: está todo documentado para funcionar sem depender da memória de ninguém.

---

## PROTOCOLO DE atualização — COMO MANTER ESTE MANUAL VIVO

> Executar ao fechar cada iteração (junto com MEMORIA + relatorio + COMANDO_ESTRATEGISTA).
> O Claude pode atualizar este arquivo diretamente — basta pedir.

### Quando atualizar o Manual

| Situação | O que atualizar |
|----------|-----------------|
| Passo mais demorado do que o estimado | Corrigir tabela de tempo (Parte 5) |
| Comando que o Gemini/NotebookLM não entendeu bem | Refinar o template do comando |
| Situação nova que não está no troubleshooting | Adicionar à Parte 6 |
| Regra de ouro nova que emergiu do projeto | Adicionar à Parte 7 |
| Padrão de comportamento do Claude/Gemini | Documentar como nota no passo relevante |
| Nova iteração entregue com sucesso | Incrementar o número de versão |

### Como pedir ao Claude para atualizar

```
"Claude, ao fechar esta iteração, atualiza o MANUAL_DIRETOR.md:
- [o que mudar no passo X]
- [nova situação a adicionar ao troubleshooting]
- [estimativa de tempo a corrigir]
Incrementa a versão para [X.X]."
```

---

## VERSÃO E HISTÓRICO

| Versão | Data | O que mudou |
|--------|------|------------|
| 1.0 | 2026-05-11 | Criação — 10 passos completos, MAPA do loop, troubleshooting, referência rápida, avaliação |
| 1.1 | 2026-05-11 | Adicionado protocolo de organismo vivo, protocolo de atualização, histórico de versões, diagrama evolutivo V1→V5, diálogo Gemini↔Claude ilustrado |
| 1.2 | 2026-05-14 | PASSO 3/5/6 atualizados para referenciar arquivos PASSO_*.md por projeto. Arquitetura loop-agnóstica: um arquivo por passo por projeto, atualizado a cada loop (não por iteração). Cartão de ativação rápida adicionado (PARTE 0). Protocolos anti-deficiência integrados aos passos. |
| 1.3 | 2026-05-23 | PARTE 0.6 adicionada — tabela definitiva de documentos por parceiro (Gemini/NotebookLM/Embaixador/Músculo). COMANDO_ESTRATEGISTA_MASTER incorporado ao fluxo Gemini. MANIFESTO_DE_FONTES como pré-requisito NotebookLM. REGISTRO_DE_PREMISSAS incorporado ao fechamento Músculo. 12 novas deficiências distribuídas nos templates PASSO. DEF-G/N/M/E expandidos de 4 para 6-7 cada. |
| 1.4 | 2026-05-24 | Seção Embaixador: pipeline inline (Eduardo só delibera). Schema DECISOES v1.1 (hypercare_ativo, artefato_editavel, requer_uso_confirmado, resumo_para_cliente). DECISOES.json não sobe ao Projects. VEREDITOS_RESUMO.md gerado automaticamente. DIRETRIZ_GEMINI_V[N].txt obrigatória como Knowledge Document. Slot 18 ATUALIZACAO auto-incluído no NotebookLM. |

---

*Manual do diretor · PENTALATERAL IAH · V1.1*
*Criado pelo Músculo para o Diretor Eduardo*
*atualizar após cada projeto — este documento é tão vivo quanto o sistema que descreve*
