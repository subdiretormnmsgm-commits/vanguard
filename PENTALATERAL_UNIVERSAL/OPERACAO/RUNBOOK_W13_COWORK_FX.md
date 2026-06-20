# RUNBOOK — W-13 Cowork F(x) Notifier (S-2)

> Origem: sugestão S-2 do Diretor (Notion, 2026-06-18) — "Quero notificações no Telegram toda vez
> que for necessário abrir sessão no Músculo para fazer a atividade junto com o Executor Cowork."
> Construído 2026-06-19 (sexta) como clone do W-11 via `scripts/build_w13.ps1`.

## O QUE FAZ
Cron diário 07:15 BRT. Lê o calendário Cowork (espelho de `scripts/cowork_calendar.ps1`) e, **quando
há tarefa F(x) que exige o Músculo abrir sessão**, dispara Telegram instruindo o Diretor a abrir o
Claude Code para extrair e rodar as frentes com o Executor Cowork. Dias só com F1 (Radar de Dor
diário, automático) → silencia (mesmo padrão de W-6/W-11/W-12).

## CADÊNCIA (fire-table validada — teste local de 10 datas)
| Dia | Dispara | Conteúdo |
|---|---|---|
| Segunda | SIM | M1 + F12/F15/ROD (+M6 se dia 8/22; +bloco mensal/quinzenal se dia 1/15) |
| Terça | SIM | M2 |
| Quarta | SIM | M3 |
| Quinta | silencia | só F1 diário |
| Sexta | SIM | F3 consolidação semanal |
| Sáb/Dom | silencia | — |
| dia 1 | +bloco | M4+M5 + F5/F9 + F7/F8/F11/NICHE_MODELER/M-STATS |
| dia 15 | +bloco | M4+M7 + F5/F9 |

## TOPOLOGIA (5 nós — clone do W-11)
Schedule Trigger (cron `15 10 * * *`) → Code "Calcular F(x) Hoje" (JS puro) → IF "Tem F(x)?" →
Telegram httpRequest (`$env.TELEGRAM_BOT_TOKEN`) / NoOp silencia.
Campos do Code node: `temAtivacao` / `textoAtivacao` / `chatId` (idênticos ao W-11 → IF e Telegram inalterados).

## IDENTIFICADORES
- id n8n: `g06fYsG6kxduv7ZA`
- Estado inicial: **DESATIVADO** (POST cria desativado; ativação por veredito).
- Ativar: `.\scripts\ativar_w13.ps1` (POST /activate) — **só o Diretor**, após veredito.
- Reconstruir: `.\scripts\build_w13.ps1` (idempotente — cria nova cópia; apagar a antiga se reexecutar).

## FALLBACK MANUAL (P-110)
Se o W-13 cair, a fonte de verdade da cadência permanece `scripts/cowork_calendar.ps1` (rodado no
session_start, gate 0C). O Telegram é conveniência de push, não a única via.

## RELAÇÃO COM OUTROS WORKFLOWS
- W-11 (07:05) = ativação MANUAL Projetista/Embaixador Digital (comandos para colar no Claude Project).
- W-12 (07:10) = marcos de inteligência de mercado (enriquecimento/quinzenal/deadlines).
- W-13 (07:15) = F(x) Cowork que exigem o Músculo. Os três são cron-notifiers irmãos, horários escalonados.
