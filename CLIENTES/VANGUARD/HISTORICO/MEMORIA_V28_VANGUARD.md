# MEMORIA V28 — VANGUARD PENTALATERAL IAH
**Loop 28 · The Sovereign Autonomous Layer · 2026-06-07**

---

## TEMA DO LOOP

Transformar o Pentalateral de sistema assistido em sistema autônomo.
Eduardo delibera. Hermes executa. O loop não para entre sessões.

---

## O QUE FOI CONSTRUÍDO

| Entregável | Descrição | Status |
|-----------|-----------|--------|
| W-8 Signal Classifier | n8n workflow — classifica sinais em AUTO-RESOLVE/INFORMAR/DELIBERAR-A/B/C. Shadow mode 7 dias. | ✅ ATIVO |
| Hermes Agent | Motor autônomo — EasyPanel, responde no Telegram, usa OpenRouter/Claude. PID 251. | ✅ ONLINE |
| silenced_signals_log | Tabela Supabase com RLS — log de sombra do W-8 | ✅ CRIADA |
| gate_coerencia.ps1 | Validação semântica via Haiku API antes de propagar decisões | ✅ INTEGRADO |
| State Guard | state_guard.ps1 — detecta anomalias no WIP_BOARD na abertura de sessão | ✅ INTEGRADO |
| ping_hermes.ps1 | Health check do Hermes Agent — exit 0/1/2 + flag -Telegram | ✅ CRIADO |
| sync_guard -WhatIf | Modo passivo real — exibe o que faria sem escrever em disco | ✅ IMPLEMENTADO |
| N-4 executar_vereditos | Sync forçado pós-veredito (P-033 automático após deliberação) | ✅ INTEGRADO |
| MEMORIA_EMBAIXADOR_VANGUARD.md | Perfil comportamental do Fundador — temperatura 9.2/10 | ✅ CRIADO |
| NARRATIVA_FUNDADOR.md | Argumento central: Vanguard como primeiro caso do próprio produto | ✅ CRIADO |
| RUNBOOK_EASYPANEL.md | Fonte canônica: deploy Compose BETA, n8n API, erros conhecidos | ✅ CRIADO |
| RUNBOOK_SUPABASE_DDL.md | Fonte canônica: DDL, RLS, anon vs service role, tabelas | ✅ CRIADO |
| P-115 no LEDGER | Músculo assessora ativamente pendentes + DEPENDENCY_MAP em toda sessão | ✅ INSCRITO |
| P-116 no LEDGER | O que dói é erro, não esforço — verificação antes de automação | ✅ INSCRITO |

---

## PRINCÍPIOS EXTRAÍDOS

- **P-115:** Músculo propõe execução de [musculo] pendentes em toda sessão. DEPENDENCY_MAP só concluído com 3 passos.
- **P-116:** Confiança no sistema se verifica, não se declara. Escada: shadow → Grau A → Grau B → Grau C.
- **Lição técnica EasyPanel:** Compose BETA não injeta vars do painel "Ambiente" no container. Usar `hermes config set` para persistir no volume `/opt/data/`.

---

## VEREDITOS DO LOOP

- **D1:** C — Híbrido Hermes + n8n + Claude API (não puramente um, não puramente outro)
- **D2:** A — Signal Classifier shadow mode primeiro (7 dias observação antes de agir)
- **D3:** A — V28 = E-1 + Classifier shadow + Hermes Agent + State Guard (~8h total)

---

## ESTADO TÉCNICO AO FECHAR

- Hermes: `OpenRouter ✓ · Telegram ✓ (home: 8895733647) · Gateway PID 251`
- W-8: ativo em shadow mode — 7 dias de observação iniciados em 2026-06-07
- Supabase: `silenced_signals_log` com RLS — anon pode SELECT e INSERT
- Persistência Hermes: token + allowed_chats + api_key em `/opt/data/config.yaml`

---

## O QUE FICA ABERTO → V29

- Hermes subir para Grau B (age + confirma, não apenas responde)
- W-8 sair do shadow mode após 7 dias de validação (2026-06-14)
- Integração W-8 → Hermes: sinal DELIBERAR-A dispara análise no Hermes
- Skill `pentalateral-graus-abc.md` upload no dashboard do Hermes
- Fix persistência OpenRouter via `.env` no volume (workaround atual: config.yaml)
- RLS do `silenced_signals_log` — restringir INSERT ao service_role (segurança)

---

## 5 IDEIAS DISRUPTIVAS PARA O GEMINI (Loop 29)

**M-1 — Hermes como árbitro de prioridade**
Quando W-8 classifica múltiplos sinais simultâneos, Hermes prioriza por impacto comercial (cliente ativo > interno > administrativo) e apresenta ao Diretor em ordem de urgência — não cronológica.

**M-2 — Grau B com janela de veto**
Grau B não precisa esperar confirmação ativa. Hermes age e dá 15 minutos para veto. Se Eduardo não rejeitar, a ação é confirmada automaticamente. Reduz carga sem perder controle.

**M-3 — Kanban do Hermes como WIP_BOARD espelho**
O `kanban.db` do Hermes pode ser populado automaticamente pelo Músculo ao session_close — transformando o Hermes num segundo ponto de verdade do estado dos projetos, acessível 24h via Telegram.

**M-4 — Hermes como co-piloto de reunião**
Antes de qualquer reunião com cliente, Eduardo envia: `/briefing Ingrid reunião`. Hermes responde com: temperatura do cliente, últimas interações, gate atual, o que não pode esquecer de dizer.

**M-5 — Hermes aprende com o Diretor**
Cada vez que Eduardo aprova ou rejeita uma sugestão do Hermes, o feedback vai para as `memories/`. Em 30 dias, o Hermes tem um perfil real do estilo de decisão do Diretor — sem Eduardo precisar explicar nada duas vezes.
