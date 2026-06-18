QUADRO COMPLETO N8N 

  FASE 2 — QUADRO COMPLETO

  A — NOTION COMO COCKPIT DO DIRETOR

  ┌─────────────────────────────────────────┬──────────────────────────────────────────────────┐
  │              Hoje (manual)              │               FASE 2 (automático)                │
  ├─────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ WIP_BOARD.json editado pelo Músculo     │ Notion database escrito pelo n8n                 │
  ├─────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ PENDENTES.md em Markdown                │ Tasks no Notion atualizadas por webhook          │
  ├─────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ Check-in Telegram manual                │ n8n dispara 7h/13h/20h sem ação do Diretor       │
  ├─────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ MEMORIA_EMBAIXADOR atualizada na sessão │ Formulário → n8n → Notion/Supabase               │
  ├─────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ Diretor abre terminal para ver estado   │ Diretor abre URL do Notion                       │
  ├─────────────────────────────────────────┼──────────────────────────────────────────────────┤
  │ Eduardo fala com Claude pelo terminal   │ Eduardo fala com Claude pelo WhatsApp (OpenClaw) │
  └─────────────────────────────────────────┴──────────────────────────────────────────────────┘

  ---
  B — WORKFLOWS n8n A CONSTRUIR

  ┌──────────────┬──────────────────────────────────────────────────────────────────┬────────┐
  │   Workflow   │                            O que faz                             │ Status │
  ├──────────────┼──────────────────────────────────────────────────────────────────┼────────┤
  │ W-1 ampliado │ Check-in 7h/13h/20h → Notion + Telegram (FASE 1 faz só Telegram) │ FASE 2 │
  ├──────────────┼──────────────────────────────────────────────────────────────────┼────────┤
  │ W-3 ampliado │ GitHub push → atualiza Notion (além do Telegram)                 │ FASE 2 │
  ├──────────────┼──────────────────────────────────────────────────────────────────┼────────┤
  │ W-4 ampliado │ Session close → grava princípios LEDGER no Notion                │ FASE 2 │
  ├──────────────┼──────────────────────────────────────────────────────────────────┼────────┤
  │ W-5 novo     │ Auto-preparo PASSO3 quando VEREDITOS.json é criado               │ FASE 2 │
  ├──────────────┼──────────────────────────────────────────────────────────────────┼────────┤
  │ W-6 novo     │ Embaixador via API — Sessão de Inteligência automática semanal   │ FASE 2 │
  ├──────────────┼──────────────────────────────────────────────────────────────────┼────────┤
  │ W-7 novo     │ Relatório semanal de todos os projetos ativos                    │ FASE 2 │
  ├──────────────┼──────────────────────────────────────────────────────────────────┼────────┤
  │ W-8 novo     │ ChurnWatch integrado ao n8n (fora do Task Scheduler local)       │ FASE 2 │
  └──────────────┴──────────────────────────────────────────────────────────────────┴────────┘

  ---
  C — DOCUMENTOS QUE PRECISAM SER REESCRITOS

  ┌────────────────────────────┬───────────────────────────────────────────────────────────────┐
  │         Documento          │                          O que muda                           │
  ├────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ session_close.ps1          │ Parte do ritual vira automação n8n                            │
  ├────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ session_start.ps1          │ Check-in de estado vem do Notion, não de leitura de arquivos  │
  ├────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ CLAUDE.md                  │ "ler PENDENTES.md" → "consultar estado no Notion"             │
  ├────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ PENDENTES.md               │ Pode deixar de existir como arquivo — tarefas ficam no Notion │
  ├────────────────────────────┼───────────────────────────────────────────────────────────────┤
  │ Scripts de alerta Telegram │ Substituídos por workflows n8n                                │
  └────────────────────────────┴───────────────────────────────────────────────────────────────┘

  ---
  D — SESSÃO DE INTELIGÊNCIA AUTOMÁTICA (Embaixador via n8n)

  Protocolo já criado: ATIVACAO_SESSAO_INTELIGENCIA.md

  O n8n dispara automaticamente ao Embaixador via Claude API — sem o Diretor abrir o Claude Projects. 4 temas semanais
  mapeados:

  ┌────────┬──────────────────────────────────────────────────────────────────────┐
  │ Semana │                                 Tema                                 │
  ├────────┼──────────────────────────────────────────────────────────────────────┤
  │ 1      │ Churn early warning — sinais de abandono silencioso                  │
  ├────────┼──────────────────────────────────────────────────────────────────────┤
  │ 2      │ Expansão de nicho — perfil mais próximo do cliente atual             │
  ├────────┼──────────────────────────────────────────────────────────────────────┤
  │ 3      │ Diferencial comercial — o que a Vanguard faz que agência não replica │
  ├────────┼──────────────────────────────────────────────────────────────────────┤
  │ 4      │ Risco sistêmico — qual cliente perde confiança se EasyPanel cair     │
  └────────┴──────────────────────────────────────────────────────────────────────┘

  Gate: só ativar após n8n estável por 30 dias (= após 04-07-2026)

  ---
  E — SEGURANÇA

  ┌──────────────────────────────────────┬────────────┐
  │                Tarefa                │   Prazo    │
  ├──────────────────────────────────────┼────────────┤
  │ Shared secret nos webhooks W-3 e W-4 │ 18-06-2026 │
  └──────────────────────────────────────┴────────────┘

  ---
  F — OPENCLAW

  Eduardo fala com Claude pelo WhatsApp em vez do terminal. Mencionado em P-101 como fase futura. Herda a regra: toda
  mensagem externa passa pelo n8n antes de chegar ao Claude — sem exceção.

  ---
  O QUE FALTA ANTES DE CONSTRUIR

  O alerta do Músculo no N8N 2.txt é preciso:

  ▎ "O risco de 'nova era' sem planejamento: construir o stack e os documentos não acompanharem. O sistema fica híbrido
  ▎ — metade em Markdown, metade em Notion, ninguém sabe onde está a verdade."

