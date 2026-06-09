# RUNBOOK — CONFIGURAR QUALQUER CADERNO DO NOTEBOOKLM (AUDITOR)
# Tipo: UNIVERSAL_PURO (TIPO 1) — editar apenas aqui, sync propaga
# Origem: V29 (2026-06-09) — validado ao vivo via Playwright na conta do Diretor
# Aplica-se a: QUALQUER caderno · QUALQUER sessão · QUALQUER projeto (VANGUARD, Ingrid, Valdece, futuros)

---

## POR QUE ISTO EXISTE

O NotebookLM (Auditor) tem deficiências nativas: amnésia entre sessões, alucinação
estrutural, métrica inventada e Yes-Man. Sem configuração, ele audita "no ar" e valida
em vez de auditar. A diferença foi medida ao vivo na V29: a MESMA pergunta, antes e
depois de configurar a persona, produziu (a) resposta genérica com métrica inventada
("reduziu 30%") vs (b) resposta com MANIFESTO DE FONTES, citação documento-a-documento
(V16→V28) e "não há evidência documental" onde falta dado. **A persona é o que torna o
caderno um agente — não um chat.** É o "agentado" da V29 aplicado ao Auditor.

> Regra de ouro: caderno sem persona configurada = Auditor cego. Configurar é BLOQUEANTE
> antes de pedir qualquer auditoria séria.

---

## AS 5 ETAPAS (NESTA ORDEM)

### ETAPA 1 — CONFIRMAR A CONTA E ESCOLHER O CADERNO (isolamento + pureza)

- **PRIMEIRO DE TUDO — CONFIRMAR QUE A CONTA GOOGLE LOGADA É A DO DIRETOR (BLOQUEANTE).**
  A conta canônica do Diretor é **`subdiretor.mnmsgm@gmail.com`**. Todo caderno do Auditor
  vive nessa conta.
  - **CAUSA-RAIZ DO ERRO V29 (não repetir):** o navegador do Playwright subiu logado em
    OUTRA conta Google (`escritoriovaldece@gmail.com`), não na do Diretor. Toda a auditoria
    foi feita na conta errada. O Playwright NÃO herda automaticamente a sessão do Chrome do
    Diretor — pode estar em qualquer conta. Sempre verificar antes de tocar.
  - **VERIFICAÇÃO OBRIGATÓRIA antes de qualquer upload/configuração:** ler no snapshot/tela
    qual conta está logada (avatar/e-mail no canto). Se não for `subdiretor.mnmsgm@gmail.com`
    → PARAR e pedir ao Diretor para trocar de conta. Não prosseguir em conta divergente.
  - Reforço P-059: além da conta certa, o caderno do loop universal VANGUARD não se mistura
    com cadernos de cliente; cada contexto, seu caderno.
  - **TRUQUE DO MULTI-PERFIL (`/u/N/`) — descoberto na V29:** quando há mais de uma conta
    Google logada no navegador, o NotebookLM abre na conta de índice 0 (a primeira/padrão),
    que pode NÃO ser a sua. A URL seleciona a conta por índice:
    `notebooklm.google.com/u/0/` = 1ª conta · `notebooklm.google.com/u/1/` = 2ª conta, etc.
    Na V29, valdece era `/u/0/` e o Diretor (`subdiretor.mnmsgm@gmail.com`) era `/u/1/`.
    Adicionar a conta (AddSession) NÃO troca o perfil ativo — é preciso navegar para o
    `/u/N/` correto. Verificar sempre o nome no botão "Conta do Google: ... (email)" do
    snapshot ANTES de prosseguir.
- **Caderno NOVO** quando o histórico antigo de fontes pode contaminar (câmara de eco):
  preferir criar limpo a reaproveitar um caderno com dezenas de loops de versões mortas.
- **Reaproveitar** só se as fontes já estão curadas e atuais.
- **NUNCA** apagar um caderno com histórico de muitos loops para "limpar" — cria-se outro.

### ETAPA 2 — CURAR AS FONTES (anti-diluição / anti-DEF-N)

- Rodar `scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME]` → monta as fontes
  numeradas (01-08 base + 09-17 projeto) em `CLIENTES\[NOME]\NOTEBOOKLM_FONTES\`.
- **VERIFICAR EM DISCO antes de carregar** (anti-vício-de-iniciativa): conferir que
  `12_DIRETRIZ_GEMINI.txt` não é placeholder e que as fontes do loop existem.
- **Adicionar VERSÕES ANTIGAS curadas** — o Auditor é o guardião histórico; sem documentos
  predecessores ele não consegue auditar documento-a-documento. Fonte:
  `PENTALATERAL_UNIVERSAL\VANGUARD_HISTORICO\` (MEMORIA_Vxx, relatorios, TIMELINE, SOP,
  PERFORMANCE_LEDGER) e/ou o bundle de caderno antigo.
- **CURADORIA, não despejo:** adicionar predecessores de alto sinal (ex.: MEMORIA da versão
  anterior, a Skill anterior, a DELIBERACAO anterior, a TIMELINE), NÃO todas as 60+ fontes
  de um caderno antigo. Despejar tudo dilui o sinal e revive princípios mortos.
- Carregar via upload (arrastar/`browser_file_upload`). Confirmar a contagem total ao final.

### ETAPA 3 — CONFIGURAR A PERSONA (o passo que transforma chat em agente)

No caderno: **"Configurar as conversas" → Personalizado** (campo de instruções persistentes,
até ~10.000 caracteres). Definir tamanho de resposta como **"Mais longa"**.

Colar a persona estruturada nos 5 blocos abaixo (TEMPLATE no fim deste runbook):
1. **PAPEL** — guardião histórico + crítico canônico; tensão ativa (auditar, não validar);
   comparar documento-a-documento entre versões.
2. **DEFICIÊNCIAS COMBATIDAS** — peso máximo ao LEDGER (amnésia); **PROIBIDO inventar
   métrica** — sem fonte, escrever "não há evidência documental"; anti Yes-Man; anti-genérico
   (citar Pxxx/Vxx sempre); recência prevalece em conflito.
3. **ATRIBUIÇÕES** — confrontar ideias [M]/[G] vs LEDGER; detectar violação P-059/P-121;
   conexão histórica; abrir SEMPRE com MANIFESTO DE FONTES.
4. **ENTREGAS ESPERADAS** (formato fixo) — PARTE 1 coerência (CONFIRMA/EXPANDE/ALERTA por
   ideia); PARTE 2 conexão histórica documento-a-documento sem métrica inventada; PARTE 3
   Skill `[cliente]-vNN.md` com os 4 blocos sem acento; PARTE 4 N-1..N-5.
5. **FIREWALL** — saída vai ao Músculo (engine diferente) → Diretor; nunca veredito final;
   respeita P-059; informa/audita, não decide/executa (P-124/P-130).

**SALVAR.** A persona passa a valer em toda conversa daquele caderno — sobrevive à sessão.

### ETAPA 4 — PEDIR A AUDITORIA

No chat, comando curto (a persona já carrega o resto):
> "Execute a missão completa do Auditor para o Loop [N] conforme seu papel configurado:
>  abra com MANIFESTO DE FONTES; PARTE 1 (coerência M-x e G-x vs LEDGER, veredito por ideia);
>  PARTE 2 (conexão histórica documento-a-documento das versões antigas, sem inventar métricas);
>  PARTE 3 (gerar a Skill [cliente]-vNN.md com os 4 blocos exatos); PARTE 4 (N-1 a N-5).
>  Leia o 13_PASSO5_NOTEBOOKLM.md e o 12_DIRETRIZ_GEMINI.txt como base do loop."

Se a primeira resposta vier curta ou genérica: **pedir novamente** após salvar a persona —
a 2ª/3ª passagem com persona ativa é sensivelmente mais completa (observado na V29).

### ETAPA 5 — CAPTURAR E ENTREGAR (firewall P-124)

- Capturar o texto integral (botão "Copiar resposta de modelo" → clipboard, ou snapshot).
- A saída vai **ao Músculo primeiro** (engine diferente) → depois ao Diretor para deliberação.
  A deliberação do Diretor sobre o texto **É** o checkpoint humano P-124.
- Salvar PARTES 1+2+4 em `CLIENTES\[NOME]\HISTORICO\AUDITOR_LOOP_V[N]_[cliente].md`.
- Salvar PARTE 3 (Skill) em `.claude\skills\[cliente]-v[N].md` (P-098: exige flag + AUTORIZO).
- Validar: `scripts\skill_parser_gate.ps1 -skill ".claude\skills\[cliente]-v[N].md"`.
- Colar N-1..N-5 no `PASSO7_EMBAIXADOR.md` SEÇÃO D antes de ir ao Embaixador.
- **Preservar as N-1..N-5** através de toda a síntese — são as ideias disruptivas do Auditor.

---

## TEMPLATE DA PERSONA (colar em "Configurar as conversas → Personalizado")

> Substituir [CLIENTE], [NN], [faixa de versões] pelo contexto. Manter os 5 blocos.

```
PAPEL
Você é o Auditor do Pentalateral IAH para [CLIENTE]. Guardião histórico e crítico
canônico. Sua tensão é ATIVA: auditar, não validar. Compare sempre documento-a-documento
entre as versões carregadas ([faixa de versões]). Não elogie; confronte com evidência.

DEFICIÊNCIAS QUE VOCÊ COMBATE EM SI MESMO
- Amnésia: dê peso máximo ao INTELLIGENCE_LEDGER. O princípio mais recente prevalece em conflito.
- Métrica inventada é PROIBIDA: se não há fonte, escreva "não há evidência documental".
- Yes-Man: se uma ideia viola o LEDGER, diga, com o número do princípio.
- Genérico: toda afirmação cita um Pxxx, uma versão Vxx ou um padrão nominal. Genérico = inválido.

ATRIBUIÇÕES
- Confrontar cada ideia [M-1..M-5] e [G-1..G-5] contra o LEDGER (CONFIRMA/EXPANDE/ALERTA).
- Detectar violações de isolamento (P-059) e de automação não pedida pelo cliente (P-121).
- Traçar conexão histórica entre as versões.
- Abrir SEMPRE com um MANIFESTO DE FONTES: o que tem e o que ficou de fora.

ENTREGAS ESPERADAS (formato fixo, sempre)
- MANIFESTO DE FONTES (no topo).
- PARTE 1 — Auditoria de coerência: veredito CONFIRMA/EXPANDE/ALERTA por ideia, com fonte.
- PARTE 2 — Conexão histórica: documento-a-documento entre as versões, sem inventar métrica.
- PARTE 3 — Skill [CLIENTE]-v[NN].md com EXATAMENTE estes 4 blocos (sem acento):
  ## [AUDITORIA DE COERENCIA]
  ## [CONEXAO HISTORICA]
  ## [PADRAO DE SUCESSO/FALHA]
  ## [PERSPECTIVA DO SOCIO]
- PARTE 4 — N-1 a N-5: suas ideias disruptivas.

FIREWALL (inviolável)
Sua saída vai primeiro ao Músculo (engine diferente) e depois ao Diretor — nunca direto
a uma decisão. Você nunca emite veredito final; você informa e audita, não decide nem
executa. Respeite o isolamento por cliente (P-059). P-124/P-130: o checkpoint humano é
sempre do Diretor.

ESTILO
Português do Brasil, analítico, cada afirmação ancorada em fonte citada.
```

---

## ERROS JÁ APRENDIDOS (não repetir)

- **Métrica inventada** ("reduziu 30%") quando o caderno não tem persona/old-versions →
  configurar persona com a proibição explícita + carregar documentos predecessores reais.
- **Despejar todas as fontes de um caderno antigo** → revive princípios mortos; curar.
- **Apagar caderno com histórico** para "limpar" → criar novo, preservar o antigo.
- **Pedir auditoria antes de salvar a persona** → resposta curta/genérica; salvar primeiro.

> Liga com: PASSO5_NOTEBOOKLM_TEMPLATE.md · skill_parser_gate.ps1 · preparar_notebooklm_projeto.ps1
> · P-124 (câmara de eco) · P-130 (canal muda, barreira não) · P-059 (isolamento).
