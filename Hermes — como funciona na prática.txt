  Hermes — como funciona na prática:

  Existem duas coisas separadas no sistema, que se complementam:

  1. N8n (workflows automáticos)
  São robôs que rodam por conta própria na nuvem. Não precisam de interação:
  - W-1 roda às 7h todo dia → te manda briefing no Telegram
  - W-5 verifica ChurnWatch → te manda alerta quando cliente some
  - W-3 detecta commit no GitHub → te notifica
  - Você não precisa fazer nada — eles disparam sozinhos

  2. Hermes Agent (a IA no Telegram)
  É o @Eduardo431Vanguardbot. Você conversa com ele. Ele é uma IA (claude-sonnet-4-6) que lê os documentos do sistema e
  age com base nos Graus A/B/C:

  - Grau A (atual): Hermes te manda análise + opções → você responde /aprovar 1 → ele age
  - Grau B (futuro): Hermes age primeiro, te informa depois com opção de reverter
  - Grau C (futuro): Hermes age e só registra no log diário das 7h

  Hoje na prática: você abre o Telegram, manda uma mensagem ao bot (/status, /score Ingrid, ou texto livre) e ele
  responde. Para tudo que envolve cliente, sempre pede sua aprovação antes de agir.

  A skill que acabamos de instalar (pentalateral-graus-abc.md) é o que define essa lógica para o Hermes — agora ele sabe
  exatamente quando agir sozinho e quando parar para pedir aprovação.

Como o Hermes funciona (concreto):

  Quando você manda /ok Valdece no @Eduardo431Vanguardbot:
  1. Telegram entrega ao container Hermes no EasyPanel
  2. Hermes (claude-sonnet-4-6 via OpenRouter) lê /opt/data/skills/pentalateral-graus-abc.md — o arquivo que acabamos de
  instalar — como contexto
  3. A skill diz: "/ok → contato confirmado" → Hermes responde e age

  Para ChurnWatch, quem cuida é o n8n W-5 (cron, não conversa). Vou adicionar o /ok NOME no W-7 (o bot de comando) para
  que, quando você enviar /ok Valdece, ele atualize o WIP_BOARD.json no GitHub e pare o alerta.

Ah, nessa mensagem o horáriomestá configurado erradamente [Pasted text #1 +3 lines] Essa qui, recebo de hora em hora
  [Pasted text #1 +14 lines]

