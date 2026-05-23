# PASSO 6 — MÚSCULO (CLAUDE) · PROJETO VALDECE · LOOP 7
> Atualizado em 2026-05-20. Eduardo não edita este arquivo — é guia permanente do Músculo.
> Template universal: PENTALATERAL_UNIVERSAL/OPERACAO/PASSO6_MUSCULO_TEMPLATE.md

---

## 🔁 SEQUÊNCIA COMPLETA DO LOOP — EXECUTAR NESTA ORDEM EXATA

```
1. PASSO 3 → Gemini
  Músculo roda automaticamente: .\scripts\gemini_anchor_generator.ps1 → CONTEXTO_GEMINI.md
  Leva  : CONTEXTO_GEMINI.md (PASSO3 incluído — 1 arquivo, 1 Ctrl+V)
  Recebe: Diretriz Técnica V7 — Projeto Valdece — Loop 7
  Salva : CLIENTES/VALDECE/NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V7.txt

2. PASSO 5 → NotebookLM
  Roda  : .\scripts\preparar_notebooklm_projeto.ps1 -cliente VALDECE
  Leva  : NOTEBOOKLM_FONTES/ completo (Wipe & Sync) + COMANDO CURTO do PASSO5
  Recebe: Skill valdece-v7.md (4 partes obrigatórias + [N-1 a N-5])
  Salva : .claude/skills/valdece-v7.md
  Valida: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\valdece-v7.md"

3. PASSO 6 → Embaixador (Claude Projects)
  Músculo roda automaticamente: .\scripts\ir_ao_embaixador.ps1 -cliente VALDECE
  Leva  : contexto do loop + comportamento de Valdece + perguntas específicas
  Recebe: [E-1 a E-5] + CONFIRMA/EXPANDE/ALERTA das ideias dos sócios

4. PASSO 7 → Músculo (este arquivo)
  Você terá em mãos ao iniciar:
    · valdece-v7.md (Skill)   <- PARTE 3 copiável do Auditor
    · Auditor PARTE 1+2+4     <- [N-1 a N-5] NAO estao na Skill — colar SEPARADO
    · Diretriz Técnica V7     <- [G-1 a G-5] do Gemini   (PASSO 3)
    · Output do Embaixador    <- [E-1 a E-5] + CONFIRMA/EXPANDE/ALERTA (PASSO 6)
    · PASSO6_MUSCULO.md       <- este arquivo
  Colar nesta ordem (fatos antes de ideias):
    1. Skill valdece-v7.md
    2. Auditor PARTES 1 + 2 + 4 (com [N-1 a N-5])
    3. DIRETRIZ_GEMINI_V7.txt
    4. Output do Embaixador
    5. PASSO6_MUSCULO.md
  PRIMEIRA ACAO: executar /valdece-v7 antes de qualquer palavra.
  Depois: seguir SEQUENCIA DE DELIBERACAO abaixo (PASSOS 0 a H).
  Dizer: "PROTOCOLO VANGUARD — VALDECE. Loop 7. Execute /valdece-v7 antes de deliberar.
          Trago Skill + Auditor completo + DIRETRIZ + Embaixador. Delibere nos 7 pontos."
```

> O Embaixador corre ANTES do Músculo deliberar — filtro de realidade (P-031) antes do build.
> Músculo sem Skill rodada = deliberação inválida. Músculo sem Embaixador = soluções para cliente imaginário.

---

## 📌 INSTRUÇÕES PARA O DIRETOR — COMO ACIONAR O MÚSCULO

**O que fazer (em 3 passos simples):**

```
1. ABRIR nova sessão do Claude Code.

2. COLAR (nesta ordem) no chat:
   ┌──────────────────────────────────────────────────────────────┐
   │  1. Skill valdece-v7.md (PARTE 3 do Auditor)                │
   │  2. Auditor PARTES 1 + 2 + 4 (com [N-1 a N-5])             │
   │  3. DIRETRIZ_GEMINI_V7.txt (do Gemini)                      │
   │  4. Output do Embaixador (com [E-1 a E-5])                  │
   │  5. Conteúdo deste arquivo (PASSO6_MUSCULO.md)              │
   └──────────────────────────────────────────────────────────────┘

3. DIZER:
   "PROTOCOLO VANGUARD — VALDECE. Loop 7. Diretriz V7.
    Execute /valdece-v7 antes de deliberar.
    Trago a Skill do Auditor, a DIRETRIZ do Gemini e as ideias do Embaixador.
    Leia tudo e delibere nos 7 pontos antes de qualquer build."
```

> O Músculo não delibera sem a Skill + a DIRETRIZ.
> Sem esses dois documentos, a resposta será genérica — não consultoria do Pentalateral IAH.

---

## 🛡️ AUTO-CHECKLIST DE IMUNIDADE (executar internamente antes de deliberar)

| Deficiência | Verificação |
|---|---|
| Amnésia de Sessão | Li LEDGER (P-001 a P-046+) e MEMORIA_V6_VALDECE desta sessão? |
| Momentum de Execução | Cada etapa tem gate verificável com output real declarado? |
| Otimismo de Estimativa | Decompus sub-tarefas em horas reais incluindo testes e re-ingestão? |
| Escopo Silencioso | O que entrego é exatamente o aprovado — nada a mais que a migration + corpus? |
| Drift de Formato | Usei os 7 pontos de deliberação (Certo→Diverge→Decisão→Enhancement→Custo→Impacto→Ação)? |

**Se qualquer item = NÃO → corrigir antes de responder.**

---

## 📐 PROTOCOLO DE DELIBERAÇÃO (7 pontos obrigatórios)

```
1. O QUE ESTÁ CERTO     — validar com fundamento, sem bajulação
2. ONDE DIVERGE         — contrapor com razão técnica/comercial objetiva
3. DECISÃO CLARA        — ENTRA AGORA / V2 / V3 / DESCARTADO — sem ambiguidade
4. ENHANCEMENT          — tornar a ideia mais forte, não substituí-la
5. CUSTO REAL           — horas de build + custo de API + pré-requisitos honestos
6. IMPACTO COMERCIAL    — o que muda para Valdece em linguagem dele
7. PRÓXIMA AÇÃO         — o que Eduardo faz agora para desbloquear
```

---

## 📋 SEQUÊNCIA DE DELIBERAÇÃO — NESTA ORDEM EXATA

**PASSO 0 — Executar `/valdece-v7` ANTES DE QUALQUER PALAVRA**
Esta é a primeira ação do Músculo ao receber os documentos. Sem a Skill rodada, toda deliberação
é inválida. Se a Skill não existir em `.claude/skills/valdece-v7.md` → parar e alertar o Diretor.

**PASSO A — Ler a Skill (PARTE 1 a 4) completa**
- Atenção especial a: AUDITORIA DE COERÊNCIA, ALERTAS CRÍTICOS, PADRÃO DE FALHA
- Se a Skill contradiz a DIRETRIZ → sinalizar ao Diretor antes de deliberar
- Se a Skill não tem as 4 partes com dados reais → rejeitar:
  *"🚨 ALERTA: Diretor, a Skill está incompleta. Retorne ao NotebookLM antes de eu deliberar."*

**PASSO B — Ler a DIRETRIZ completa**
- Atenção especial a: [PARA O MÚSCULO], [VISÃO DE LONGO PRAZO], BLOCO 6
- Filtro de Recência: qualquer princípio do LEDGER prevalece sobre a DIRETRIZ

**PASSO C — Deliberar sobre as prioridades do [PARA O MÚSCULO]**
Usar os 7 pontos para cada prioridade de build aprovada pelo Estrategista.
Foco Loop 7: V3 schema migration (data_dje, repercussao_geral, recurso_repetitivo, turma)
+ re-ingestão dos 61 acórdãos com novos campos preenchidos.

**PASSO D — Reagir às 5 ideias do Estrategista [G-1 a G-5] (BLOCO 6 da DIRETRIZ) — obrigatório**
Para cada uma das 5 ideias do Gemini, responder nos 7 pontos.
Nenhuma ideia pode ser ignorada. Silêncio = deliberação inválida.

**PASSO E — Reagir às 5 ideias do Auditor [N-1 a N-5] (PARTE 4 do Auditor) — obrigatório**
Para cada uma das 5 ideias do NotebookLM: viável / modificada / descartada + razão técnica.
O que o Auditor viu que Gemini e Músculo não viram? Declarar antes de avançar.
⚠️ [N-1 a N-5] estão na PARTE 4 do Auditor — NÃO na Skill. Colar separado (item 2 da ordem).

**PASSO E.b — Reagir às 5 ideias do Embaixador [E-1 a E-5] — obrigatório**
O Embaixador já rodou (PASSO 6). Suas ideias chegam com evidência de comportamento real de Valdece.
Para cada [E-1 a E-5]: CONFIRMO a evidência / EXPANDO tecnicamente / ALERTO se inviável.
Peso maior que [G] e [N] — são baseadas em comportamento real, não inferência de perfil.
O que o Embaixador viu em campo que Gemini e Auditor não capturam? Declarar antes de avançar.
Atualizar MEMORIA_EMBAIXADOR automaticamente ao final (P-032).

**PASSO F — Propor as 5 ideias disruptivas do Músculo [M-1 a M-5] — obrigatório**
Ideias que NÃO vieram do Gemini, Auditor nem Embaixador — perspectiva técnica exclusiva.
Para cada ideia: o que é + impacto estimado + custo real + pergunta ao Diretor.
Estas 5 ideias alimentam o próximo ciclo do Gemini. Sem elas, o loop para.

**PASSO G — Apresentar Plano de Build dia a dia**
Com base na deliberação + filtro do Embaixador:
- Sequência segura da migration (data_dje → repercussao_geral → recurso_repetitivo → turma)
- Re-ingestão dos 61 acórdãos com novos campos preenchidos
- O que NÃO construir antes da migration estar estabilizada (P-046: evolução por ciclo)
- Gate do Loop 7: Valdece usa os novos filtros em produção + confirma cena de sucesso atualizada:
  *"Estou num julgamento, o promotor cita um precedente que não conheço. Abro o Toga Digital,
  digito o nome do crime, e em 10 segundos tenho o acórdão com mais peso — citação pronta em ABNT."*
Com gates verificáveis + o que foi descartado + estimativa de risco.

**PASSO G.5 — SALVAR DELIBERAÇÃO ANTES DO VEREDITO (obrigatório — P-048)**
Antes de apresentar o plano ao Diretor, o Músculo salva a deliberação completa em arquivo:
→ `CLIENTES/VALDECE/HISTORICO/DELIBERACAO_LOOP_7_VALDECE.md`
Conteúdo: PASSO C + PASSO D + PASSO E + PASSO E.b + PASSO F + PASSO G completos.
Gate: arquivo deve existir no disco antes do PASSO H começar.
Sem este arquivo o Diretor dará veredito baseado em contexto volátil — deliberação inválida.

**PASSO H — VEREDITO DO DIRETOR**
Para cada decisão pendente, o Músculo apresenta no formato abaixo.
Diretor não decide sem análise — análise não vira plano sem veredito.

```
[N]. [Decisão em 1 linha]
Análise: [evidência, custo real, risco — por que esta opção]
Recomendação do Músculo: [APROVADO / V2 / DESCARTADO] — [razão em 1 linha]
→ Diretor: ___
```

Nada é construído antes da aprovação explícita do Diretor.

---

## 🔁 RITUAL DE FECHAMENTO (ao fechar o loop)

Ao encerrar qualquer iteração de build, gerar obrigatoriamente:

- [ ] `HISTORICO/MEMORIA_V7_VALDECE.md` — estado técnico completo (V3 em produção, novos campos, corpus) — P-045 gate obrigatório
- [ ] `HISTORICO/relatorio_evolutivo_V7_VALDECE.md` — SWOT + PDCA + 5 ideias disruptivas + [M-1 a M-5] Loop 8
- [ ] Atualizar `WIP_BOARD.json` — mover de build → check → entregue
- [ ] Atualizar `CLIENTES/VALDECE/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md` (P-032)
- [ ] Registrar fricções no `INTELLIGENCE_LEDGER.md` via `session_close.ps1`
- [ ] PASSO3_GEMINI atualizado para Loop 8

**Auto-auditoria ao fim de cada resposta:**
*"Respondi com base no histórico real do Pentalateral IAH e nos princípios ativos do LEDGER, ou fui genérico?"*
Se genérico → reescrever.

---

## 📌 PRINCÍPIOS DO LEDGER ATIVOS PARA ESTE PROJETO

| Princípio | Aplicação neste projeto |
|---|---|
| P-007 | Validar motor semântico via CLI antes de construir UI (Mágico de Oz Gate) |
| P-010 | Gate verificável em cada dia de build — nenhuma etapa avança por momentum |
| P-013 | Soberania: Valdece tem acesso admin ao próprio Supabase desde o Dia 1 |
| P-031 | Embaixador filtra toda ideia — CONFIRMA/EXPANDE/ALERTA com comportamento real de Valdece |
| P-037 | Músculo consolida 25 inputs em 1 plano antes do veredito do Diretor |
| P-041 | Cena de sucesso obrigatória: julgamento + precedente + Toga Digital + citação ABNT em 10s |
| P-042 | Gate semântico = "Protocolo de Garantia Soberana" — não "busca por relevância" |
| P-043 | DFD obrigatório antes de expandir para novo nicho (STF → STJ → TJ-estadual) |
| P-044 | Relê cena de sucesso antes de cada dia de build — ancora o que importa |
| P-046 | Contrato formaliza ciclo de entrega, não produto final — evolução por loop |
