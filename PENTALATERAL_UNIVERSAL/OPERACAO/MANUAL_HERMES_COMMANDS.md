# MANUAL DO HERMES — COMANDOS E CAPACIDADES
**Versão 1.1 — 2026-06-07**
**Canal:** Telegram `@Eduardo431Vanguardbot`

---

## O QUE É O HERMES

Hermes é o motor autônomo 24/7 do Pentalateral IAH. Roda na nuvem (EasyPanel), nunca depende do seu PC.
É uma IA (claude-sonnet-4-6 via OpenRouter) que lê os documentos do sistema e age conforme os Graus A/B/C.

**Grau atual: A** — toda ação requer sua aprovação antes de executar.

---

## COMANDOS DISPONÍVEIS HOJE

### VIA TELEGRAM (você digita no bot)

| Comando | O que faz | Quem processa |
|---------|-----------|--------------|
| `/status` | Status de todos os projetos ativos (WIP_BOARD) | W-7 Cérebro de Bolso |
| `/score` | Score de cada cliente (churn, engajamento) | W-7 Cérebro de Bolso |
| `/custo` | Custos de API / infra do mês | W-7 Cérebro de Bolso |
| `/veredito` | Próximos vereditos pendentes de decisão | W-7 Cérebro de Bolso |
| `/ok NOME` | Registra contato com o cliente (para ChurnWatch) | W-7 — NOVO ✅ |
| `/aprovar N` | Aprova ação pendente número N do Hermes Agent | Hermes Agent (Grau A) |

---

### `/ok NOME` — COMO USAR

Quando o ChurnWatch alertar que um cliente está próximo do threshold:

1. Envie a mensagem WhatsApp para o cliente
2. Após enviar, digite no bot: `/ok Ingrid` ou `/ok Valdece`
3. O bot atualiza `ultimo_contato_cliente` no WIP_BOARD automaticamente
4. Confirmação: _"Contato com Ingrid registrado (2026-06-07). Próximo alerta em 3 dias."_
5. O ChurnWatch para de alertar até o próximo threshold

**Nome:** pode ser parcial (case insensitive). `/ok ingrid` e `/ok INGRID` funcionam igual.

---

## AUTOMAÇÕES ATIVAS (n8n — 24/7)

### W-1 — Check-in Diário
- **Quando:** 09:00 BRT (12:00 UTC), 1x por dia
- **O que faz:** Puxa status dos projetos do WIP_BOARD e envia resumo no Telegram
- **Formato:** Semáforo visual por projeto (VERDE/AMARELO/VERMELHO)

### W-2 — Monitor Supabase
- **Quando:** A cada hora
- **O que faz:** Verifica se o Supabase está online
- **Alerta:** Envia no Telegram se offline

### W-3 — GitHub Push
- **Quando:** A cada commit no repositório
- **O que faz:** Notifica commits no Telegram + atualiza Notion WIP Board

### W-4 — Session Close
- **Quando:** Você roda `session_close.ps1`
- **O que faz:** Envia resumo da sessão para Telegram + Notion + Pendentes

### W-5 — ChurnWatch
- **Quando:** 09:00 BRT (12:00 UTC), 1x por dia
- **O que faz:** Calcula dias sem contato por cliente vs. threshold
- **Alerta:** Se ultrapassou → mensagem WhatsApp pronta para copiar
- **Dismiss:** Após enviar para o cliente → `/ok NOME` no Telegram
- **Campos obrigatórios no WIP_BOARD:** `ultimo_contato_cliente` e `churn_watch_threshold`

### W-7 — Cérebro de Bolso
- **Quando:** Você digita um comando no Telegram
- **O que faz:** Processa `/status`, `/score`, `/custo`, `/veredito`, `/ok NOME`
- **Novo:** `/ok NOME` registra contato e atualiza GitHub automaticamente

### W-8 — Signal Classifier (Shadow Mode)
- **Status:** Observação até 2026-06-14 (7 dias a contar de 2026-06-07)
- **O que faz em shadow:** Classifica sinais (AUTO-RESOLVE / INFORMAR / DELIBERAR-A/B/C) mas não age
- **Log:** `silenced_signals_log` no n8n
- **Após 2026-06-14:** Diretor decide se ativa ação real

---

## HERMES AGENT (via EasyPanel)

O Hermes Agent é diferente dos workflows n8n. É uma IA que pensa e age.

### Como ele funciona
1. Você envia mensagem no Telegram
2. Hermes lê seus documentos de skill (`/opt/data/skills/`)
3. Hermes analisa e propõe uma ação
4. **Grau A:** aguarda `/aprovar N` antes de executar

### Skills carregadas no Hermes
- `pentalateral-graus-abc.md` — regras de delegação A/B/C ✅ (carregado 2026-06-07)

### Graus de Delegação

| Grau | Comportamento | Quando usar |
|------|--------------|------------|
| **A (atual)** | Propõe → aguarda `/aprovar N` | Fase inicial — cada ação é revisada |
| **B** | Age → confirma em 15 min | Tarefas rotineiras aprovadas |
| **C** | Autônomo → loga ações | Automações de baixo risco |

### Como aprovar uma ação
```
Hermes: "Proposta #3: Enviar alerta ChurnWatch para Valdece. Aprovar?"
Você:   /aprovar 3
Hermes: "Executado. Mensagem enviada."
```

---

## CAPACIDADES FUTURAS (ainda não ativas)

| Capacidade | Status | O que desbloqueará |
|-----------|--------|-------------------|
| Hermes executa vereditos via Telegram | Planejado | Grau B — aprovação cirúrgica |
| Hermes atualiza PENDENTES.md via GitHub | Planejado | Gestão de tarefas pelo celular |
| Hermes envia PASSO3 ao Gemini | Planejado | Loop Pentalateral pelo celular |
| W-8 Signal Classifier ativo | 2026-06-14 (avaliação) | Triagem automática de sinais |
| Hermes Grau B | Decisão do Diretor | Ações sem aprovação por 15min |

---

## ENDEREÇOS E ACESSOS

| Sistema | URL |
|---------|-----|
| n8n (workflows) | `https://vanguard-vanguard-n8n.0ul9nk.easypanel.host` |
| EasyPanel (infra) | `https://0ul9nk.easypanel.host` |
| Telegram Bot | `@Eduardo431Vanguardbot` |
| Hermes no EasyPanel | projeto `hermes` / serviço `hermes-agent` |

---

## FLUXO RÁPIDO — SITUAÇÕES COMUNS

### "Quero saber o status dos projetos agora"
→ Telegram: `/status`

### "Ingrid está no threshold do ChurnWatch"
1. Copie a mensagem WhatsApp que o W-5 enviou
2. Mande para Ingrid no WhatsApp
3. Telegram: `/ok Ingrid`
4. Pronto — próximo alerta em `churn_watch_threshold` dias

### "Quero aprovar algo que o Hermes propôs"
→ Telegram: `/aprovar N` (onde N é o número da proposta)

### "Quero ver o que está pendente de decisão"
→ Telegram: `/veredito`
