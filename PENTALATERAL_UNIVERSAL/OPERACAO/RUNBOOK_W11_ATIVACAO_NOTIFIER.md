# RUNBOOK — W-11 ATIVAÇÃO MANUAL NOTIFIER (n8n → Telegram)

> Desenho aprovado pelo Diretor em 2026-06-16. Cadências ratificadas na mesma data.
> CONSTRUÍDO em 2026-06-16 — **id n8n: `vew2fonxWwiGB9uQ`** · estado: **ATIVO**.
> Nome corrigido de W-10 → **W-11**: "W-10" já existe (`8yvX4MBzdaK5l6IQ` — n8n Health Check).
> Skill usada: `n8n-remote-v1` (Code = lógica pura · Telegram = httpRequest dedicado typeVersion 4.2).
> **ATIVADO em 2026-06-16 por ordem do Diretor** ("Tudo ativado automaticamente" → "Ativar W-11 agora"),
> sobrepondo a regra dos 7 dias de staging. Primeiro disparo: 2026-06-17 07:05 BRT (se houver ator do dia).
> Reverter (se preciso): `POST /api/v1/workflows/vew2fonxWwiGB9uQ/deactivate`.

---

## PROPÓSITO

Notificar o Diretor no Telegram, toda manhã, **somente** quando há ator a ativar
manualmente hoje (M-STATS / Projetista / Embaixador Digital). Silencia nos dias sem
ativação (mesmo padrão do W-6 Session Watch). O motor prepara o insumo; o W-11 só
lembra o Diretor de **quando** acionar cada ator manual.

Natureza: camada de automação (Hermes/n8n). NÃO é loop. P-160 não se aplica.

---

## CADÊNCIAS (ratificadas pelo Diretor 2026-06-16)

| Ator | Quando ativar | Ação que o Diretor dispara |
|---|---|---|
| **M-STATS** (skill `market-stats-analysis`) | dia 1 do mês | rodar a skill sobre o Cartão de Nicho do mês |
| **PROJETISTA** | toda Sexta + dia 1 | gerar PLANOS + CAMPANHA do produto Vanguard |
| **EMBAIXADOR DIGITAL** | toda Segunda + dia 5 | prospectar (LinkedIn) a partir do produto + camada M-STATS |

---

## TOPOLOGIA DOS NODES

```
[1] Schedule Trigger          (cron "5 10 * * *"  =  07:05 BRT / 10:05 UTC)
          |                                          roda DEPOIS do W-1 (07h)
          v
[2] Code node "calcula_ativacoes_hoje"   (JS puro — datas determinísticas,
          |                                zero dependência de arquivo externo)
          v
[3] IF  "tem ativação hoje?"   (ativacoes.length > 0)
        |true                       |false
        v                           v
[4] Telegram "sendMessage"     [5] NoOp (silencia — não notifica)
        |
   (continueOnFail: true  — P-110)
```

---

## [1] SCHEDULE TRIGGER
- Cron: `5 10 * * *` (07:05 BRT = 10:05 UTC). Após o W-1 Check-in (07h) para não competir.

## [2] CODE NODE — regra de cadência (JS, espelha `scripts/cowork_calendar.ps1`)

```javascript
// Datas são determinísticas -> não precisa ler arquivo. Resiliente por design.
const agora = new Date(new Date().toLocaleString('en-US', { timeZone: 'America/Sao_Paulo' }));
const dow = agora.getDay();   // 0=Dom .. 1=Seg .. 5=Sex
const dia = agora.getDate();  // 1..31

// Cadências ratificadas pelo Diretor 2026-06-16.
const regras = [
  { ator: 'M-STATS (Análise Estatística de Nicho)', quando: (dia === 1),
    acao: 'rodar skill market-stats-analysis sobre o Cartão de Nicho do mês' },
  { ator: 'PROJETISTA', quando: (dow === 5 || dia === 1),
    acao: 'gerar PLANOS + CAMPANHA do produto Vanguard' },
  { ator: 'EMBAIXADOR DIGITAL', quando: (dow === 1 || dia === 5),
    acao: 'prospectar (LinkedIn) a partir do produto + camada M-STATS' },
];

// AS-BUILT: o texto é montado AQUI (Code = lógica pura) e o node Telegram só o envia.
const ativacoes = regras.filter(r => r.quando);
const dataBR = agora.toLocaleDateString('pt-BR');
let texto = '';
if (ativacoes.length > 0) {
  const linhas = ativacoes.map(a => '• *' + a.ator + '*\n  → ' + a.acao);
  texto = '🟢 *VANGUARD — Ativações de hoje (' + dataBR + ')*\n\n'
        + linhas.join('\n\n')
        + '\n\n_Ativação manual sua. Motor já preparou o insumo no INBOX_COWORK / PENDING_REVIEW._';
}
return [{ json: { temAtivacao: ativacoes.length > 0, textoAtivacao: texto, chatId: $env.TELEGRAM_CHAT_ID || '8895733647' } }];
```

## [3] IF — "Tem Ativacao Hoje?"
- Condição (boolean): `{{ $json.temAtivacao }}` == `true`. Falso → NoOp "Silencia (sem ativacao)".

## [4] TELEGRAM — httpRequest (typeVersion 4.2)
- **Não usa o node de credencial Telegram** — segue o padrão das engrenagens existentes (W-5/W-1):
  `httpRequest` POST direto à Bot API. Evita dependência de credencial e conflito com o polling do Hermes.
- URL: `={{ 'https://api.telegram.org/bot' + $env.TELEGRAM_BOT_TOKEN + '/sendMessage' }}`
- Body keypair: `chat_id={{ $json.chatId }}` · `text={{ $json.textoAtivacao }}` · `parse_mode=Markdown`
- `$env.TELEGRAM_BOT_TOKEN` e `$env.TELEGRAM_CHAT_ID` já existem no container (usados por W-1/W-5).
- `continueOnFail: true` (P-110) — se o Telegram cair, o workflow não quebra; erro vai ao log.

---

## FALLBACK MANUAL (≤3 passos — P-110)
1. `.\scripts\cowork_calendar.ps1` (local) → mostra frentes/M-STATS previstas hoje.
2. Abrir Telegram e conferir o bot `@Eduardo431Vanguardbot` manualmente.
3. (Músculo) reporta na abertura da sessão via `session_start`, que já lê o calendário.

---

## CHECKLIST DE BUILD — status 2026-06-16
- [x] Invocar skill `n8n-remote-v1` antes de tocar no n8n.
- [x] Criar W-11 no n8n cloud — id `vew2fonxWwiGB9uQ`, INATIVO.
- [x] `continueOnFail: true` no node Telegram.
- [x] Validar lógica de cadência (hoje silencia; dia 1 dispara os 3; cadências batem).
- [x] Testar 1 disparo Telegram — recebido pelo Diretor (message_id 432), Markdown OK.
- [x] **ATIVADO em 2026-06-16** por ordem do Diretor (staging sobreposto) — `active: True` confirmado via API.
- [ ] Registrar W-11 na tabela de workflows do `CLAUDE.md` + `RUNBOOK_EASYPANEL.md` (P-098 → `.musculo_autorizacao.flag`).

> Infra n8n: EasyPanel cloud 24/7. Credenciais em `N8N Easypanel.txt` (gitignored).
> Ativação (após 2026-06-23): `curl -X POST -H "X-N8N-API-KEY: $KEY" "$HOST/api/v1/workflows/vew2fonxWwiGB9uQ/activate"`
