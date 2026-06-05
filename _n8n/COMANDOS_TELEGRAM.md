# COMANDOS TELEGRAM — Bot Vanguard (@Eduardo431Vanguardbot)
> Acesso exclusivo ao Diretor (chat_id 8895733647). Qualquer outro ID recebe "Acesso não autorizado."
> Workflow: W-7 — atualizado em 2026-06-05

---

## CONSULTAS (leitura)

### `/status`
Mostra o estado atual de todos os projetos no WIP Board.
Lê diretamente o `WIP_BOARD.json` do GitHub (fonte canônica).

**Exemplo de resposta:**
```
STATUS 2026-06-05

CHECK|Valdece L7|Musculo -- P-037 sintese Loop 7
RETAINER|Ingrid L8|Loop 9 -- Gate 7.2 RLS
```

---

### `/score`
Mostra a taxa de acerto da Ingrid nos quizzes do sistema.
Lê a tabela `respostas` no Supabase Ingrid.

**Exemplo de resposta:**
```
SCORE INGRID
87/120 (72%)
7d: 23/30 (76%)
2026-06-05
```
> `sem dados em respostas` = Ingrid ainda não usou o sistema. Normal até ela responder o primeiro quiz.

---

### `/custo`
Mostra o custo acumulado de API do projeto (últimas 10 sessões).
Lê a tabela `custo_sessoes` no Supabase Ingrid.

**Exemplo de resposta:**
```
CUSTO 2026-06
USD: 0.0847
Tokens: 142.300
```
> `sem dados` = tabela `custo_sessoes` ainda não tem registros. Precisa ser populada manualmente ou via script de sessão.

---

## VEREDITOS (escrita)

Gravam no GitHub (`VEREDITOS/VEREDITOS_YYYYMMDDHHNN.json`), atualizam o Notion WIP Board e confirmam via Telegram.

---

### `/aprovar <ID>`
Aprova uma decisão pendente. Equivale a veredito **A**.

```
/aprovar D1
```

---

### `/rejeitar <ID>`
Rejeita uma decisão pendente. Equivale a veredito **B**.

```
/rejeitar D2
```

---

### `/veredito <D1:A> <D2:B> ...`
Envia múltiplos vereditos de uma vez.

Opções de veredito:
- `A` = Aprovar
- `B` = Rejeitar
- `C` = Adiar

```
/veredito D1:A D2:B D3:C
```

**Exemplo de resposta:**
```
Veredito registrado!
Arquivo: VEREDITOS/VEREDITOS_202606051925.json
2026-06-05 19:25 UTC
```

---

## REGRAS DE USO

| Regra | Detalhe |
|---|---|
| IDs de decisão | Definidos no `DECISOES.json` do projeto ativo (D1, D2, D3...) |
| Arquivo gerado | `VEREDITOS/VEREDITOS_{timestamp}.json` no repositório GitHub |
| Notion | Atualizado automaticamente após cada veredito |
| Proteção split-brain | Timestamp único por arquivo — dois vereditos simultâneos não colidem |
| Chaves necessárias | `GITHUB_PAT_WRITE` + `TELEGRAM_BOT_TOKEN` + `NOTION_API_TOKEN` (EasyPanel) |
| Dados Supabase | `SUPABASE_URL` + `SUPABASE_ANON_KEY` (EasyPanel) |

---

## FLUXO COMPLETO DE VEREDITO

```
Telegram /veredito D1:A
    ↓
W-7 valida isDiretor
    ↓
Grava VEREDITOS_{ts}.json no GitHub
    ↓
Atualiza Notion WIP Board
    ↓
Telegram confirma: "Veredito registrado!"
    ↓
[próxima sessão] session_start detecta arquivo → executar_vereditos.ps1 processa
```

---

## CHURN WATCH (automático — sem comando)

O W-5 roda todo dia às **8h BRT** automaticamente.
Lê o WIP_BOARD, calcula dias sem contato por cliente e envia:

- **Resumo diário** sempre (todos os projetos com status OK/ALERTA)
- **Alerta de churn** apenas se algum cliente ultrapassou o threshold de dias

Thresholds configurados no `WIP_BOARD.json` → campo `churn_watch_threshold` por projeto.

**Mensagens sugeridas incluídas no alerta de churn:**

| Cliente | Dias sem contato | Mensagem sugerida |
|---|---|---|
| Ingrid | 3–4 dias | "Ingrid, tudo bem? Estou por aqui se precisar de algo. 🙂" |
| Ingrid | 5+ dias | "Ingrid, estou por aqui. Como está o estudo?" |
| Valdece | 7+ dias | "Dr. Valdece, tudo bem? Passando para saber como está sendo a experiência com o sistema." |

**Lembrete de domingo (Ingrid):**
Todo domingo o resumo diário inclui a mensagem de relatório semanal:
`"Ingrid, semana encerrada! Me conta: quantas questões você respondeu essa semana? Quero atualizar o seu relatório de progresso. 📊"`
