# ROTEIRO N8N -- IMPORTAR WORKFLOWS
# Diretor Eduardo -- nivel: sem experiencia tecnica necessaria
# Musculo -- Pentalateral IAH -- 2026-06-04
# Executar: apos configurar credenciais (ROTEIRO_N8N_CREDENCIAIS.md)

---

## OS WORKFLOWS PREPARADOS PELO MUSCULO

Localizados em: `n8n_workflows/` na raiz do repositorio Vanguard.

| Arquivo | Funcao |
|---------|--------|
| `workflow_1_checkin_temporal.json` | Mensagens 7h, 13h, 20h no Telegram |
| `workflow_2_monitor_supabase.json` | Ping Supabase a cada hora -- alerta se cair |
| `workflow_3_github_webhook.json` | Notifica cada commit do Musculo |
| `workflow_4_session_close.json` | Recebe dados ao fechar sessao + grava no Notion |

---

## COMO IMPORTAR (4 passos por workflow)

Repetir para cada um dos 4 arquivos:

**PASSO 1:** Abrir o arquivo JSON no Windows Explorer
  - Navegar ate: `vanguard/n8n_workflows/`
  - Clicar com botao direito no arquivo
  - Abrir com: Bloco de Notas (ou qualquer editor)
  - Selecionar tudo (Ctrl+A) e copiar (Ctrl+C)

**PASSO 2:** Importar no n8n
  - No n8n, clicar nos tres pontinhos (...) no canto superior direito
  - Selecionar "Import from JSON"
  - Colar (Ctrl+V) o conteudo copiado
  - Clicar "Import"

**PASSO 3:** Configurar os campos marcados com "CONFIGURE"
  - Cada node com "CONFIGURE" precisa ser editado
  - Clicar duas vezes no node para abrir
  - Substituir o texto "CONFIGURE: ..." com o valor real
  - Exemplos:
    - "CONFIGURE: ID do chat Telegram" -> ID numerico do seu chat (ex: 123456789)
    - "CONFIGURE: ID da credencial Telegram" -> selecionar "Telegram Vanguard" no dropdown

**PASSO 4:** Salvar
  - Clicar "Save" no canto superior direito
  - NAO ativar ainda (o toggle deve ficar cinza/desativado)

---

## COMO ENCONTRAR O ID DO CHAT TELEGRAM

1. Abrir o Telegram no celular
2. Enviar qualquer mensagem para o bot Vanguard
3. Acessar: `https://api.telegram.org/bot[TOKEN-DO-BOT]/getUpdates`
   (substituir [TOKEN-DO-BOT] pelo token real)
4. Procurar no resultado: `"chat": {"id": NUMERO}`
5. O NUMERO e o chatId

---

## TESTAR CADA WORKFLOW ANTES DE ATIVAR

**Workflow 1 (Check-in):**
- Abrir o workflow
- Clicar no node "Detectar Periodo"
- Clicar "Test step"
- Verificar se aparece o periodo correto
- Clicar no node Telegram > "Test step"
- Verificar se chegou mensagem no Telegram

**Workflow 2 (Monitor Supabase):**
- Abrir o workflow
- Clicar no node "Ping Supabase Ingrid" > "Test step"
- Verificar se o status retornado e 200
- Fazer o mesmo para Valdece
- Se 200: Supabase esta online

**Workflow 3 (GitHub Webhook):**
- Ativar o workflow (toggle VERDE) -- necessario para gerar a URL
- Copiar a URL gerada (aparece ao clicar no node "Webhook GitHub Push")
- No GitHub: Settings > Webhooks > Add webhook
  - Payload URL: colar a URL
  - Content type: application/json
  - Secret: deixar em branco por enquanto
  - Events: selecionar "Pushes"
  - Clicar "Add webhook"
- Fazer um commit de teste e verificar se chegou notificacao

**Workflow 4 (Session Close):**
- Ativar o workflow (toggle VERDE)
- Copiar a URL do webhook
- Informar a URL ao Musculo para inserir no session_close.ps1
- O Musculo cuida do resto

---

## ATIVAR OS WORKFLOWS (ORDEM CORRETA)

Ativar nesta ordem e um de cada vez:

1. Workflow 2 (Monitor Supabase) -- sem risco, so leitura
2. Workflow 1 (Check-in) -- aguardar 7h/13h/20h para confirmar
3. Workflow 4 (Session Close) -- ativar + informar URL ao Musculo
4. Workflow 3 (GitHub) -- depende de configurar o webhook no GitHub

---

## SE DER ERRO AO IMPORTAR

**Erro "invalid JSON":** o arquivo foi copiado com caracteres a mais. Tentar:
- Abrir o arquivo com o editor de codigo VS Code (se instalado)
- Copiar de la

**Node com icone vermelho:** falta configurar uma credencial. Clicar no node para ver qual.

**Workflow nao executa:** verificar "Executions" no menu lateral do n8n -- mostra o log completo do erro.

---

*Musculo -- Pentalateral IAH -- 2026-06-04*
*Tempo estimado: 45-60 minutos para todos os 4 workflows*
