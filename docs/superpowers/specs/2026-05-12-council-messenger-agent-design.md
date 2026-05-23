# Council Messenger Agent — Design Spec
**Data:** 2026-05-12  
**Versão:** 1.0  
**Status:** Aprovado pelo Diretor

---

## Visão Geral

O **Council Messenger Agent** é o canal de comunicação proativa do Conselho com o Diretor Eduardo. Não é um sistema de alertas técnicos — é o Conselho falando com o Diretor via email, em primeira pessoa, com diagnóstico e ação necessária.

Cada email tem um remetente lógico (Músculo, Auditor ou Conselho coletivo), tom próprio e ação clara exigida do Diretor.

---

## Arquitetura

### Dois scripts, duas responsabilidades

**`scripts/alert_wip_monitor.ps1`** (expandir o existente)
- Roda via Task Scheduler a cada 5 minutos, 24h/dia
- Cobre eventos urgentes: novo cliente, slot BUILD liberado, Circuit Breaker, Sentinel FIRE
- Só envia email quando um evento novo é detectado (anti-spam via estado persistido)

**`scripts/alert_daily_briefing.ps1`** (novo)
- Roda via Task Scheduler todo dia às 07:00
- Envia despacho matinal com estado completo do board + ações pendentes
- Envia sempre, mesmo que nada tenha mudado

### Arquivos de estado (em `CLIENTES/`, ignorados pelo git)

| Arquivo | Propósito |
|---|---|
| `.wip_last_state.json` | Já existe — rastreia clientes vistos na última execução |
| `.build_timestamps.json` | Novo — registra quando cada cliente entrou em BUILD |
| `.sentinel_fire_notified.json` | Novo — registra quais FIRE Events já foram notificados (evita re-envio) |

---

## Triggers e Lógica de Detecção

### Monitor (a cada 5 min) — `alert_wip_monitor.ps1`

| Trigger | Condição de disparo | Frequência |
|---|---|---|
| Novo cliente | Nome aparece em `discovery` ou `build` que não estava no último estado | 1× por entrada |
| Slot BUILD liberado | `build.Count` diminuiu em relação ao último estado | 1× por liberação |
| Circuit Breaker | Projeto em `build` há ≥ 4 dias sem `sentinel_config.json` válido | 1× por dia enquanto persistir |
| Sentinel FIRE | Flag `"fire_event": true` em `CLIENTES/{cliente}/sentinel_config.json` | 1× por evento (até ser resolvido) |

### Briefing Diário (07:00) — `alert_daily_briefing.ps1`

Sempre envia, com:
- Estado de todos os slots do board
- Dias em andamento por cliente em BUILD
- Lista dinâmica de ações pendentes (Sentinel não configurado, Playbook não gerado, etc.)
- Capacidade disponível (slots livres vs. limite)

---

## Templates de Email (Voz do Conselho)

### Trigger 1 — Novo cliente (Músculo)
```
Assunto: [PENTALATERAL IAH] Músculo → Novo objeto em {ETAPA}: {cliente}

Diretor Eduardo,

Novo objeto entrou no sistema. Ação sua necessária.

Cliente : {cliente}
Etapa   : {DISCOVERY | BUILD}
Entrou  : {data e hora}

O QUE PRECISA DE VOCÊ:
[DISCOVERY]
  1. Conduzir o Briefing Rápido (WhatsApp ou presencial)
  2. Calcular a Hemorragia: clientes × ticket × 4
  3. Identificar o FIRE Event
  4. Dar veredito: BUILD ou recusar?

[BUILD]
  1. Acionar PROTOCOLO VANGUARD no Claude Code
  2. Confirmar appetite (quantos dias?)
  3. Iniciar Módulo 0 (Sovereign Pixel + Sentinel)

Aguardamos seu veredito para avançar.

— Músculo (Claude Code) · Pentalateral IAH
```

### Trigger 2 — Slot BUILD liberado (Músculo)
```
Assunto: [PENTALATERAL IAH] Músculo → Slot BUILD liberado — pipeline pode avançar

Diretor Eduardo,

{cliente} saiu de BUILD. Capacidade disponível: {n}/{limite}.

Board atual:
  Discovery : {lista}
  Build     : {lista}

Se há alguém em DISCOVERY aprovado, dê o sinal para entrar em BUILD.

— Músculo (Claude Code) · Pentalateral IAH
```

### Trigger 3 — Circuit Breaker (Auditor)
```
Assunto: [PENTALATERAL IAH] ⚠ AUDITOR → Circuit Breaker: {cliente} — Dia {n} sem MVP

Diretor,

{cliente} está em BUILD há {n} dias sem MVP entregue.

Score GUT: Gravidade 5 · Urgência 5 · Tendência 5 = PRIORIDADE MÁXIMA

DIAGNÓSTICO: Risco de entrega comprometida. Intervenção necessária.

AÇÃO NECESSÁRIA HOJE:
  → Revisar o appetite com o Músculo
  → Cortar escopo ou redefinir MVP
  → Confirmar nova data de entrega

Sem sua decisão nas próximas 24h, o projeto entra em modo de congelamento.

— Auditor · Pentalateral IAH
```

### Trigger 4 — Sentinel FIRE (Auditor)
```
Assunto: [PENTALATERAL IAH] ⚠ AUDITOR → FIRE Event detectado: {cliente}

Diretor,

O Sentinel de {cliente} sinalizou um FIRE Event.

Cliente : {cliente}
Etapa   : {etapa}
Flag    : fire_event = true em sentinel_config.json

AÇÃO NECESSÁRIA:
  → Acessar CLIENTES/{cliente}/sentinel_config.json
  → Avaliar o incidente com o Músculo
  → Definir resposta e resetar a flag após resolução

— Auditor · Pentalateral IAH
```

### Trigger 5 — Despacho Matinal (Conselho)
```
Assunto: [PENTALATERAL IAH] Despacho Matinal — {data}

Diretor Eduardo, bom dia.

════════════════════════════════
ESTADO DO BOARD — {data}
════════════════════════════════

  Discovery : {lista ou "— vazio"}
  Build     : {lista com "· {cliente} — Dia {n}"}
  Check     : {lista ou "— vazio"}
  Entregue  : {lista ou "— vazio"}
  Retainer  : {lista ou "— vazio"}

CAPACIDADE:
  Slots BUILD: {em uso}/{limite} — {LIVRE | CHEIO}

════════════════════════════════
AÇÕES PENDENTES
════════════════════════════════
{Se nada pendente: "Nenhuma ação pendente. Board em ordem."}
{Senão, lista dinâmica:}
  · {cliente} em BUILD há {n} dias — revisar prazo
  · Sentinel de {cliente} não configurado — configurar antes do handoff
  · Playbook de {cliente} pendente — gerar antes de ENTREGUE
  · FIRE Event ativo em {cliente} — resolver

O Conselho está de plantão.

— Conselho · Pentalateral IAH
```

---

## Regras de Anti-Spam

1. **Novo cliente / Slot liberado:** Disparado 1× por evento. Estado salvo em `.wip_last_state.json`.
2. **Circuit Breaker:** Disparado 1× por dia por projeto em violação. Controle via `.build_timestamps.json` com campo `last_circuit_breaker_alert`.
3. **Sentinel FIRE:** Disparado 1× até a flag `fire_event` ser removida. Estado salvo em `.sentinel_fire_notified.json`.
4. **Briefing diário:** Sem controle de anti-spam — envia sempre às 07:00.

---

## Configuração do Task Scheduler

### Task existente (atualizar descrição)
```
Nome    : Pentalateral — WIP Monitor
Script  : scripts\alert_wip_monitor.ps1
Trigger : A cada 5 minutos, 24h/dia
```

### Task nova (criar)
```
Nome    : Pentalateral — Despacho Matinal
Script  : scripts\alert_daily_briefing.ps1
Trigger : Diariamente às 07:00
```

---

## Credenciais

Reutiliza `scripts/alert_config.ps1` existente:
- `$ALERT_FROM` — `subdiretor.mnmsgm@gmail.com`
- `$ALERT_TO` — `subdiretor.mnmsgm@gmail.com`
- `$ALERT_SENHA` — senha de app Google (16 chars)

---

## Fora do Escopo (Esta Versão)

- Integração com Supabase / Pixel Sovereign para FIRE Events de leads
- Múltiplos destinatários
- Email HTML / rich formatting
- Integração com WhatsApp ou Slack
