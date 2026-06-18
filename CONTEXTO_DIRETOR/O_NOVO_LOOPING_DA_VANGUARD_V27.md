 O NOVO LOOPING DA VANGUARD — V27

  ╔══════════════════════════════════════════════════════════════════╗
  ║         PENTALATERAL IAH — LOOP V27 (com Sistema Nervoso)       ║
  ╚══════════════════════════════════════════════════════════════════╝

                      DIRETOR (Eduardo)
                      Delibera · Aprova · Veredita
                             │
                ┌────────────┴────────────┐
                │                         │
           MANUAL                    AUTOMÁTICO
           (loop intelectual)        (n8n 24/7)
                │                         │
      ┌─────────▼──────────┐    ┌─────────▼──────────┐
      │ ① GEMINI           │    │        W-1 Briefing 7h/13h │
      │ PASSO3_GEMINI.md   │    │        W-2 Monitor Supabase│
      │ ← DIRETRIZ + [G-5] │    │        W-3 Push → Telegram │
      └─────────┬──────────┘    │ W-4 Session Close   │
                │                │       W-7 Veredito /aprov│
      ┌─────────▼──────────┐    └────────────────────┘
      │ ② NOTEBOOKLM       │
      │ PASSO5 + Wipe&Sync │
      │ ← Skill + [N-5]    │
      └─────────┬──────────┘
                │
      ┌─────────▼──────────┐
      │ ③ EMBAIXADOR       │
      │ PASSO7 (ir_ao_emb) │
      │ ← [E-5] + TEMP +   │
      │   DECISOES.json    │
      └─────────┬──────────┘
                │
      ┌─────────▼──────────┐
      │ ④ MÚSCULO          │
      │ /[cliente]-v[N]    │
      │ Deliberação 7pts   │
      │ ← Plano de build   │
      └─────────┬──────────┘
                │
      ┌─────────▼──────────┐
      │ ⑤ BUILD            │
      │ Commits [RESOLVE:] │
      │ W-3 → Telegram     │◄── a cada push
      └─────────┬──────────┘
                │
      ┌─────────▼──────────┐
      │ ⑥ FECHAR LOOP      │
      │ DELIBERACAO (P-037)│
      │ MEMORIA + relatorio│
      │ session_close.ps1  │
      │ W-4 → Telegram     │◄── automático
      │ Wipe & Sync NLM    │
      └─────────┬──────────┘
                │
      ┌─────────▼──────────┐
      │ VEREDITO (Telegram)│
      │ /veredito D1:A D2:B│
      │ W-7 → Notion + git │
      │ executar_vereditos │
      └─────────┬──────────┘
                │
           LOOP RECOMEÇA

  ---
  O QUE MUDOU DO V25 PARA O V27

  Antes — o Diretor transportava:
  Eduardo copia MEMORIA → abre Gemini → cola → copia DIRETRIZ  → abre NotebookLM → cola → copia Skill → abre Claude Code...

  Agora — o Diretor delibera:
  n8n envia briefing às 7h → Eduardo avalia
  → gemini_anchor_generator.ps1 já compilou o contexto
  → Eduardo só cola + recebe → /veredito D1:A no Telegram
  → n8n executa → Músculo constrói

  Os 25 inputs do loop continuam os mesmos:
  - [M-1 a M-5] — Músculo técnico
  - [M'-1 a M'-5] — Músculo cirúrgico (filtrando G+N)
  - [G-1 a G-5] — Gemini Estrategista
  - [N-1 a N-5] — NotebookLM Auditor
  - [E-1 a E-5] — Embaixador (comportamento real do cliente)

  O que o n8n não faz: pensar, deliberar, gerar ideias. Isso é exclusivo dos 5 membros.
  O que o n8n faz: notificar, registrar vereditos, atualizar dashboards, alertar churn.

  O Pentalateral ficou mais rápido. O Diretor ficou mais livre. O loop ficou mais rico.

 ---
  Como n8n e Notion funcionam HOJE

  A arquitetura em 1 frase

  O n8n roda 24/7 na nuvem (EasyPanel) e age como o braço automático do sistema — dispara, coleta, envia. O Notion é a
  lousa de saída — recebe registros do n8n para o Diretor visualizar. Nenhum dos dois raciocina: quem raciocina é o
  Haiku (API) e o Conselho.

  ---
  O que existe hoje — 5 workflows ativos

  W-1  Check-in       Cron 7h/13h/20h ──────► Notion WIP Board  ✅
       (status projetos)                  └──► Telegram          ❌ sem token

  W-2  Monitor Supabase  Cron horário ─────► Telegram se offline ❌ sem token

  W-3  GitHub Push    Webhook GitHub ────────► Notion WIP Board  ✅
       (registra commit)              └──────► Telegram          ❌ sem token

  W-4  Session Close  POST do seu PC ────────► Notion WIP Board  ✅
       (fecha sessão)                 ├──────► Notion Pendentes  ✅
                                      └──────► Telegram resumo   ❌ sem token

  W-7  Veredito       Telegram /aprovar ─────► Notion Pendentes  ✅
       (recebe veredito)              └──────► Telegram resposta ❌ sem token

  Em verde = funciona hoje. Em vermelho = Telegram mudo porque o token não está no n8n EasyPanel.

  ---
  

O que o Notion recebe hoje

  Você tem 3 páginas configuradas no Notion:

  ┌───────────────┬─────────────────────────────────────────────────────────────┬────────────┐
  │ Página Notion │                        Quem escreve                         │ Frequência │
  ├───────────────┼─────────────────────────────────────────────────────────────┼────────────┤
  │ WIP Board     │ W-1 (3x/dia) + W-3 (a cada commit) + W-4 (ao fechar sessão) │ Diário     │
  ├───────────────┼─────────────────────────────────────────────────────────────┼────────────┤
  │ Pendentes     │ W-4 (ao fechar sessão) + W-7 (veredito)                     │ Por sessão │
  ├───────────────┼─────────────────────────────────────────────────────────────┼────────────┤
  │ Ledger        │ Ninguém ainda — NOTION_LEDGER_PAGE_ID não configurado       │ —          │
  └───────────────┴─────────────────────────────────────────────────────────────┴────────────┘

  ---
  As 7 ENV_VARS que faltam e o que cada uma desbloqueia

  ┌───────────────────────────┬────────────────────────────────┬─────────────────────────────────────────────┐
  │          ENV_VAR          │             Valor              │                 Desbloqueia                 │
  ├───────────────────────────┼────────────────────────────────┼─────────────────────────────────────────────┤
  │ TELEGRAM_BOT_TOKEN        │ Já está no alert_config.ps1    │ Todos os alertas Telegram — W-1/W-3/W-4/W-7 │
  ├───────────────────────────┼────────────────────────────────┼─────────────────────────────────────────────┤
  │ TELEGRAM_CHAT_ID_DIRETOR  │ Já está no alert_config.ps1    │ Destino do Telegram                         │
  ├───────────────────────────┼────────────────────────────────┼─────────────────────────────────────────────┤
  │ ANTHROPIC_API_KEY         │ Sua conta Anthropic            │ Haiku gera artefatos de fechamento          │
  ├───────────────────────────┼────────────────────────────────┼─────────────────────────────────────────────┤
  │ NOTION_LEDGER_PAGE_ID     │ ID da página Notion            │ W-1 escreve princípios novos no Notion      │
  ├───────────────────────────┼────────────────────────────────┼─────────────────────────────────────────────┤
  │ GITHUB_PAT_READONLY       │ GitHub → Settings → Tokens     │ W-3 acessa repo privado com leitura         │
  ├───────────────────────────┼────────────────────────────────┼─────────────────────────────────────────────┤
  │ BURN_RATE_DAILY_LIMIT_USD │ Valor em dólares (ex: 5)       │ W-1 calcula burn rate diário                │
  ├───────────────────────────┼────────────────────────────────┼─────────────────────────────────────────────┤
  │ N8N_WEBHOOK_SECRET        │ Você escolhe (string qualquer) │ Autenticação nos webhooks W-3/W-4           │
  └───────────────────────────┴────────────────────────────────┴─────────────────────────────────────────────┘

  As 2 mais urgentes (desbloqueiam Telegram de imediato): TELEGRAM_BOT_TOKEN + TELEGRAM_CHAT_ID_DIRETOR.
