# COMANDOS TELEGRAM — Bot Vanguard (@Eduardo431Vanguardbot)
> Acesso exclusivo ao Diretor (chat_id 8895733647). Qualquer outro ID recebe "Acesso não autorizado."
> Workflow: W-7 — atualizado em 2026-06-06

---

## GUIA DO DIRETOR — O QUE FAZER COM CADA MENSAGEM

### 1. Check-in diário (W-1) — chega 1x por dia: 7h BRT

```
Bom dia, Diretor.
Check-in Vanguard IAH -- 06/06/2026

Status dos projetos:
- Valdece: HYPERCARE
- Ingrid: RETAINER
```

**O que fazer:** Ler e ignorar. É só uma atualização automática.
Nenhuma ação necessária, nenhum comando para enviar.

---

### 2. ChurnWatch (W-5) — chega 1x por dia: 8h BRT

**Cenário A — tudo OK:**
```
ChurnWatch 2026-06-06 11:00 UTC
Valdece: 2d (threshold 3d) -- OK
Ingrid: 2d (threshold 3d) -- OK
```
**O que fazer:** Ler e ignorar. Nenhuma ação necessária.

---

**Cenário B — alerta com mensagem sugerida:**
```
[ALERTA] CHURN-WATCH -- INGRID
5 dias sem contato (threshold: 3 dias)
Último contato: 01/06/2026

Mensagem sugerida:
"Ingrid, estou por aqui. Como está o estudo?"
```
**O que fazer:** Copiar a mensagem sugerida e enviar à Ingrid pelo WhatsApp/canal que usa.
Nenhum comando Telegram necessário.
Depois, na próxima sessão Claude Code, informar ao Músculo que o contato foi feito — ele atualiza o WIP_BOARD.

---

**Cenário C — alerta VERMELHO:**
```
[VERMELHO] CHURN-WATCH -- VALDECE
17 dias sem contato (threshold: 5 dias)
```
**O que fazer:** Verificar se o alerta é real — pode ser falso positivo (bug no W-5).
Não enviar mensagem ao cliente antes de confirmar com o Músculo.
Abrir o Claude Code e informar o alerta recebido.

---

### 3. Notificação de commit (W-3) — chega a cada push no GitHub

```
Novo commit no vanguard
feat(n8n): W-5 ChurnWatch -- mensagens sugeridas
Eduardo · 2026-06-05 17:43
```
**O que fazer:** Ler e ignorar. É informativo — confirma que o Músculo commitou algo.

---

### 4. Notificação de sessão encerrada (W-4) — chega ao fechar sessão

```
Sessão encerrada -- 2026-06-05
Entregas: W-5 ChurnWatch · B-3 security · P-072 resolvido
Pendentes: 3 abertos · 0 urgentes
Próximo: verificar W-5 às 8h BRT
```
**O que fazer:** Ler. É o lembrete para subir o PAINEL_ATIVIDADES ao Embaixador.
Nenhum comando Telegram necessário.

---

### 5. Menu de ajuda — aparece quando o bot não entendeu o que você digitou

```
Cmds: /status /score /custo /aprovar X /rejeitar X /veredito D1:A
```
**O que fazer:** Ignorar. Isso significa que você digitou algo que o bot não reconheceu.
O bot não entende frases como "acionar Embaixador" — só entende os comandos listados abaixo.
Nenhuma ação necessária.

---

### 6. Confirmação de veredito — aparece após você enviar /aprovar, /rejeitar ou /veredito

```
Veredito registrado!
Arquivo: VEREDITOS/VEREDITOS_202606051925.json
2026-06-05 19:25 UTC
```
**O que fazer:** Ler e confirmar que chegou "Veredito registrado!". Pronto.
Na próxima sessão o Músculo processa automaticamente.

---

## QUANDO USAR OS COMANDOS

Os comandos abaixo você só usa quando quiser consultar algo ou quando o Músculo pedir.
Na maioria dos dias você não precisa digitar nada no Telegram.

---

## CONSULTAS (você digita, o bot responde)

### `/status`
**Quando usar:** quando quiser ver o estado atual dos projetos sem abrir o Claude Code.

**O que chega:**
```
STATUS 2026-06-05
CHECK|Valdece L7|Loop 8 -- Sentinel aguardando
RETAINER|Ingrid L8|Loop 9 -- captacao 2a candidata
```

---

### `/score`
**Quando usar:** quando quiser ver o desempenho de Ingrid nos quizzes.

**O que chega:**
```
SCORE INGRID
87/120 (72%)
7d: 23/30 (76%)
2026-06-05
```
> `sem dados` = Ingrid ainda não usou o quiz. Normal.

---

### `/custo`
**Quando usar:** quando quiser ver quanto a API da Anthropic consumiu.

**O que chega:**
```
CUSTO 2026-06
USD: 0.0847
Tokens: 142.300
```
> `sem dados` = tabela de custo ainda vazia. Normal por enquanto.

---

## VEREDITOS (você digita quando o Músculo pedir)

O Músculo só pede veredito via Telegram quando gera um `DECISOES.json` com opções para deliberar.
Ele vai te avisar explicitamente qual ID usar e qual opção escolher.

### `/aprovar D1`
Aprova a decisão D1. Equivale a veredito A.

### `/rejeitar D2`
Rejeita a decisão D2. Equivale a veredito B.

### `/veredito D1:A D2:B D3:C`
Envia vários vereditos de uma vez.
- `A` = Aprovar
- `B` = Rejeitar
- `C` = Adiar

**Fluxo completo:**
```
Músculo avisa: "Diretor, decisão D1 aguarda veredito — /aprovar D1 ou /rejeitar D1"
Você digita:   /aprovar D1
Bot confirma:  "Veredito registrado!"
Próxima sessão: Músculo aplica automaticamente.
```

---

## CHURN WATCH — THRESHOLDS ATIVOS

| Cliente | Threshold | Mensagem 3-4 dias | Mensagem 5+ dias |
|---|---|---|---|
| Ingrid | 3 dias | "Ingrid, tudo bem? Estou por aqui se precisar de algo. 🙂" | "Ingrid, estou por aqui. Como está o estudo?" |
| Valdece | 3 dias | — | "Dr. Valdece, tudo bem? Passando para saber como está sendo a experiência com o sistema." |

**Lembrete de domingo (Ingrid):**
Todo domingo o resumo inclui:
`"Ingrid, semana encerrada! Me conta: quantas questões você respondeu essa semana? Quero atualizar o seu relatório de progresso. 📊"`
