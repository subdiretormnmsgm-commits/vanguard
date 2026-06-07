# DELIBERAÇÃO — Loop V28 · VanguardV28 Pentalateral Autônomo
**Data:** 2026-06-06
**Síntese P-037 — Músculo consolida 25 inputs → 1 plano**

---

## 1. O QUE ESTÁ CERTO (validado pelo ciclo completo)

**Diagnóstico central (Gemini):** o gargalo não é tempo de build — é custo cognitivo do Diretor em rastrear estado para saber *quando* iniciar um loop. Correto. Validado pelo comportamento desta sessão inteira.

**Opção B arquitetural (Gemini):** n8n + Claude API é a única opção que respeita P-001 (Claude Code ≠ Daemon) e P-112 (n8n = Grau 1, pré-processador). Correto.

**Signal Classifier como pré-requisito (M-1 + AUDITOR):** sem taxonomia de sinal, qualquer daemon vira ruído. O Auditor emitiu VETO ativo (P-110): sem fallback documentado em MAINTENANCE_COST.md, V28 não pode ser ativado. Correto e bloqueante.

**Embaixador confirma:** TEMPERATURA 6.5/10 — acima do limiar de 6. V28 é viável. A adoção depende de respeitar o controle de timing de Eduardo, não de contorná-lo.

**Dor real redefinida pelo Embaixador (E-3):** Eduardo pediu menos esforço no loop. Mas o que dói é o **erro**, não o esforço. Um loop que exige esforço mas nunca erra é melhor que um automático que erra em silêncio. Isso redefine a prioridade do V28: verificação antes de automação.

---

## 2. ONDE DIVERGE (análise cirúrgica do Músculo)

**M-4 (NotebookLM 1-Tap via Telegram) — DESCARTADO:**
Embaixador ALERTA: Eduardo declarou explicitamente nesta sessão que não quer handoffs via Telegram. A função é válida (reduzir custo cognitivo do Wipe & Sync), mas o canal está errado. Reposicionar para aviso na abertura da sessão Claude Code — não celular.

**G-2 (Timeout Controlado — assume NÃO em 24h) — ALERTA CRÍTICO:**
Embaixador classifica como CRÍTICO. Eduardo controla timing ativamente — parou fases no meio desta sessão, reverteu quando Músculo agiu antes do veredito. Deliberação por timeout ataca diretamente o padrão de controle do fundador. Se entrar: apenas sinais triviais e reversíveis. Por ora: fora do escopo V28.

**N-2 (Briefing Reverso — perguntas aleatórias do LEDGER) — DESCARTADO:**
Eduardo não demonstrou amnésia — lembrou do Hermes, do token, de sessões anteriores hoje. Resolve problema que ele não tem. Adiciona ruído ao briefing que precisa ser limpo.

**G-5 + N-3 (Shadow Mode + Shadow Log) — CONSOLIDAR:**
São a mesma ideia vinda de dois sócios. Uma implementação só — creditar ambos.

**G-1 (Falsa Falha Programada) — ADIADO:**
Conceito válido para validar a malha de detecção. Mas injetar erro deliberado no WIP de um fundador que hoje listou 7 erros e cogitou encerrar a empresa é delicado. Apenas em ambiente isolado, nunca WIP de cliente, documentado antes. V29.

---

## 3. DECISÃO CLARA

**D1 — Arquitetura do agente:** Opção C (Híbrido) — processo persistente remove a ignição, n8n orquestra, Claude API verifica coerência semântica. Graus A/B/C do Embaixador (E-2) como modelo de delegação.

**D2 — Signal Classifier:** Opção A — Classifier primeiro em Shadow Mode (G-5+N-3 consolidados). Eduardo vê o que o sistema faria antes de o sistema fazer. Rampa de confiança obrigatória.

**D3 — Escopo V28:** Opção A — Gate de coerência semântica (E-1) + Classifier Shadow + 1 workflow incremental. Atacar a dor real (erro de looping) antes de automatizar o loop.

---

## 4. ENHANCEMENT (o que torna o plano mais forte)

**E-1 do Embaixador — Gate de Coerência Semântica:** é a peça que nenhuma das 15 ideias originais cobria. Cinco dos sete erros desta sessão não foram documento desatualizado — foram output incompleto aceito pelo passo seguinte sem verificar. Um gate via Claude API em cada handoff: "isto está completo e correto para o próximo passo?" é a única coisa que detecta essa classe de erro. **Entra no V28 como prioridade 1.**

**E-5 do Embaixador — Registro de Iniciativa:** narrativa de 2 linhas na abertura de sessão: "verifiquei N projetos, detectei 1 sinal em X, aguardo deliberação." Resolve a tensão central observada nesta sessão: Eduardo precisa ver tudo para confiar, mas não quer operar tudo. O Registro de Iniciativa dá a sensação de ver sem precisar fazer. **Entra no V28 como item de UI do briefing.**

**Hermes Agent (E-2) como motor de partida:** o gap real é que alguém precisa ser a ignição — mesmo com n8n e Claude API, o loop começa quando Eduardo abre. O Hermes Agent (open source, 2026) fecha esse gap. **V29 — após V28 provar a camada de verificação.**

---

## 5. CUSTO REAL

| Componente | Estimativa | Pré-requisito |
|---|---|---|
| Gate de coerência semântica (E-1) | 2h (Claude API + integração handoff) | Claude API key ativa no EasyPanel ✅ |
| Signal Classifier em Shadow Mode (G-5+N-3) | 3h (regras n8n + log Supabase) | silenced_signals_log table no Supabase |
| State Guard acoplado ao session_start | 2h | WIP_BOARD com campos de data corretos |
| MAINTENANCE_COST.md atualizado (P-110 VETO) | 1h | Bloqueante — sem isso, nada ativa |
| W-8 Chief of Staff Daemon (Briefing Engine) | 4h | Signal Classifier aprovado em shadow mode |
| MEMORIA_EMBAIXADOR_VANGUARD.md (primeira) | 1h | Após esta síntese |

**Total V28 core (verificação):** ~8h em 2-3 sessões
**Total V28 completo (daemon + agente):** ~13h em 4-5 sessões

---

## 6. IMPACTO COMERCIAL

Sem o V28: teto de 3-5 projetos simultâneos antes de saturar atenção do Diretor.
Com o V28 (verificação + daemon): estimativa do Embaixador de 6-10 projetos antes de a fila de deliberação virar o novo limite.

Diferencial vendável (Embaixador E-4): a Vanguard se torna o primeiro caso do próprio produto — fundador que automatizou a operação e tem os dados para provar. O pitch não é "automatizamos tudo" (assusta). É "automatizamos verificação e operação para que a inteligência humana fique inteira para o cliente."

Linha inviolável (Embaixador): automatizar transporte, verificação e vigilância. **Nunca relação e deliberação.**

---

## 7. PRÓXIMA AÇÃO

**Diretor agora:**
1. Dar veredito nas 3 decisões: D1 (A/B/C) · D2 (A/B) · D3 (A/B)
2. Confirmar se MAINTENANCE_COST.md deve ser atualizado antes ou após o veredito (é VETO ativo do Auditor)

**Músculo após veredito:**
1. Atualizar MAINTENANCE_COST.md com fallbacks ≤3 passos para Signal Classifier e W-8
2. Criar silenced_signals_log no Supabase
3. Build Gate de Coerência Semântica (E-1) — prioridade 1
4. Build Signal Classifier em Shadow Mode (G-5+N-3)
5. Criar MEMORIA_EMBAIXADOR_VANGUARD.md (primeira — perfil de Eduardo como fundador)
6. Atualizar WIP_BOARD com VANGUARD como projeto interno rastreado

**Obs. de processo:** VanguardV28 não está rastreado no WIP_BOARD — é um gap de design. Após veredito, adicionar "VANGUARD" como projeto interno com os mesmos campos de cliente.

---

*Síntese P-037 · Músculo · Pentalateral IAH · 2026-06-06*
*Ciclo: Gemini DIRETRIZ V28 → NotebookLM vanguard-v28.md → Embaixador SEÇÃO D → Músculo P-037*
