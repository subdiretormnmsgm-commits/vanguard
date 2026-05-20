# PASSO 6 — TEMPLATE UNIVERSAL: PARA O MÚSCULO (Claude Code)
# Versão: Universal v4.0 · 2026-05-20 · QUADRILATERAL_UNIVERSAL/OPERACAO/
# Uso: Músculo preenche [PLACEHOLDERS] com dados reais ao criar instância por projeto.

---

## 🔁 SEQUÊNCIA COMPLETA DO LOOP — EXECUTAR NESTA ORDEM EXATA

```
1. PASSO 3 → Gemini
  Músculo roda automaticamente: .\scripts\gemini_anchor_generator.ps1 → CONTEXTO_GEMINI.md
  Leva  : CONTEXTO_GEMINI.md (PASSO3 incluído — 1 arquivo, 1 Ctrl+V)
  Recebe: Diretriz Técnica V[N] — Projeto [NOME] — Loop [N]
  Salva : CLIENTES/[NOME]/NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V[N].txt

2. PASSO 5 → NotebookLM
  Roda  : .\scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME]
  Leva  : NOTEBOOKLM_FONTES/ completo (Wipe & Sync) + COMANDO CURTO do PASSO5
  Recebe: Skill [cliente]-v[N].md (4 partes obrigatórias + [N-1 a N-5])
  Salva : .claude/skills/[cliente]-v[N].md
  Valida: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\[cliente]-v[N].md"

3. PASSO 6 → Embaixador (Claude Projects)
  Músculo roda automaticamente: .\scripts\ir_ao_embaixador.ps1 -cliente [NOME]
  Leva  : contexto do loop + comportamento do cliente + perguntas específicas
  Recebe: [E-1 a E-5] + CONFIRMA/EXPANDE/ALERTA das ideias dos sócios

4. PASSO 7 → Músculo (este arquivo)
  Você terá em mãos ao iniciar:
    · [cliente]-v[N].md (Skill)  <- PARTE 3 copiável do Auditor
    · Auditor PARTE 1+2+4        <- [N-1 a N-5] NAO estao na Skill — colar SEPARADO
    · Diretriz Técnica V[N]      <- [G-1 a G-5] do Gemini   (PASSO 3)
    · Output do Embaixador       <- [E-1 a E-5] + CONFIRMA/EXPANDE/ALERTA (PASSO 6)
    · PASSO6_MUSCULO.md          <- este arquivo
  Colar nesta ordem (fatos antes de ideias):
    1. Skill [cliente]-v[N].md
    2. Auditor PARTES 1 + 2 + 4 (com [N-1 a N-5])
    3. DIRETRIZ_GEMINI_V[N].txt
    4. Output do Embaixador
    5. PASSO6_MUSCULO.md
  PRIMEIRA ACAO: executar /[cliente]-v[N] antes de qualquer palavra.
  Depois: seguir SEQUENCIA DE DELIBERACAO abaixo (PASSOS 0 a H).
  Dizer: "PROTOCOLO VANGUARD — [NOME]. Loop [N]. Execute /[cliente]-v[N] antes de deliberar.
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
   │  1. Skill [cliente]-v[N].md (PARTE 3 do Auditor)            │
   │  2. Auditor PARTES 1 + 2 + 4 (com [N-1 a N-5])             │
   │  3. DIRETRIZ_GEMINI_V[N].txt (do Gemini)                    │
   │  4. Output do Embaixador (com [E-1 a E-5])                  │
   │  5. Conteúdo deste arquivo (PASSO6_MUSCULO.md)              │
   └──────────────────────────────────────────────────────────────┘

3. DIZER:
   "PROTOCOLO VANGUARD — [NOME]. Loop [N]. Diretriz V[N].
    Execute /[cliente]-v[N] antes de deliberar.
    Trago a Skill do Auditor, a DIRETRIZ do Gemini e as ideias do Embaixador.
    Leia tudo e delibere nos 7 pontos antes de qualquer build."
```

> O Músculo não delibera sem a Skill + a DIRETRIZ.
> Sem esses dois documentos, a resposta será genérica — não consultoria do Pentalateral IAH.

---

## 🛡️ AUTO-CHECKLIST DE IMUNIDADE (executar internamente antes de deliberar)

| Deficiência | Verificação |
|---|---|
| Amnésia de Sessão | Li LEDGER (P-001 a P-0XX+) e MEMORIA_V[N-1]_[CLIENTE] desta sessão? |
| Momentum de Execução | Cada etapa tem gate verificável com output real declarado? |
| Otimismo de Estimativa | Decompus sub-tarefas em horas reais incluindo testes? |
| Escopo Silencioso | O que entrego é exatamente o aprovado — nada a mais? |
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
6. IMPACTO COMERCIAL    — o que muda para o cliente em linguagem dele
7. PRÓXIMA AÇÃO         — o que Eduardo faz agora para desbloquear
```

---

## 📋 SEQUÊNCIA DE DELIBERAÇÃO — NESTA ORDEM EXATA

**PASSO 0 — Executar `/[cliente]-v[N]` ANTES DE QUALQUER PALAVRA**
Esta é a primeira ação do Músculo ao receber os documentos. Sem a Skill rodada, toda deliberação
é inválida. Se a Skill não existir em `.claude/skills/[cliente]-v[N].md` → parar e alertar o Diretor.

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

**PASSO D — Reagir às 5 ideias do Estrategista [G-1 a G-5] (BLOCO 6 da DIRETRIZ) — obrigatório**
Para cada uma das 5 ideias do Gemini, responder nos 7 pontos.
Nenhuma ideia pode ser ignorada. Silêncio = deliberação inválida.

**PASSO E — Reagir às 5 ideias do Auditor [N-1 a N-5] (PARTE 4 do Auditor) — obrigatório**
Para cada uma das 5 ideias do NotebookLM: viável / modificada / descartada + razão técnica.
O que o Auditor viu que Gemini e Músculo não viram? Declarar antes de avançar.
⚠️ [N-1 a N-5] estão na PARTE 4 do Auditor — NÃO na Skill. Colar separado (item 2 da ordem).

**PASSO E.b — Reagir às 5 ideias do Embaixador [E-1 a E-5] — obrigatório**
O Embaixador já rodou (PASSO 6). Suas ideias chegam com evidência de comportamento real do cliente.
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
- O que vai ser construído exatamente (sequência segura, fatos antes de ideias)
- O que NÃO construir nesta entrega e por quê
- Gate de verificação de cada dia (output real, não "parece funcionar")
- Estimativa de risco: o que pode falhar e plano de contingência

**PASSO H — Aguardar Veredito do Diretor**
Nada é construído antes da aprovação explícita.

---

## 🔁 RITUAL DE FECHAMENTO (ao fechar o loop)

Ao encerrar qualquer iteração de build, gerar obrigatoriamente:

- [ ] `HISTORICO/MEMORIA_V[N]_[CLIENTE].md` — estado técnico completo — P-045 gate obrigatório
- [ ] `HISTORICO/relatorio_evolutivo_V[N]_[CLIENTE].md` — SWOT + PDCA + 5 ideias disruptivas
- [ ] Atualizar `WIP_BOARD.json` — mover de build → check → entregue
- [ ] Atualizar `CLIENTES/[NOME]/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md` (P-032)
- [ ] Registrar fricções no `INTELLIGENCE_LEDGER.md` via `session_close.ps1`
- [ ] PASSO3_GEMINI atualizado para Loop [N+1]

**Auto-auditoria ao fim de cada resposta:**
*"Respondi com base no histórico real do Pentalateral IAH e nos princípios ativos do LEDGER, ou fui genérico?"*
Se genérico → reescrever.

---

## 📌 PRINCÍPIOS DO LEDGER ATIVOS PARA ESTE PROJETO

> Preencher com os princípios específicos do projeto ao criar instância.

| Princípio | Aplicação neste projeto |
|---|---|
| P-007 | Validar motor via CLI antes de construir UI (Mágico de Oz Gate) |
| P-010 | Gate verificável em cada dia de build — nenhuma etapa avança por momentum |
| P-013 | Soberania: cliente tem acesso admin ao próprio Supabase desde o Dia 1 |
| P-031 | Embaixador filtra toda ideia — CONFIRMA/EXPANDE/ALERTA com comportamento real do cliente |
| P-037 | Músculo consolida 25 inputs em 1 plano antes do veredito do Diretor |
| [P-0XX] | [Princípio específico deste projeto — adicionar ao criar instância] |

---
*Template Universal · Pentalateral IAH · OPERACAO/ · Atualizar ao descobrir novo padrão*
