# ROTEIRO N8N -- CONFIGURAR CREDENCIAIS
# Diretor Eduardo -- nivel: sem experiencia tecnica necessaria
# Musculo -- Pentalateral IAH -- 2026-06-04
# Executar: apos instalar n8n (ROTEIRO_N8N_EASYPANEL_INSTALACAO.md)

---

## ONDE CONFIGURAR

No n8n, clicar em "Settings" (engrenagem no menu lateral esquerdo) > "Credentials"
Ou clicar direto: no menu lateral > "Credentials"

---

## CREDENCIAL 1 -- TELEGRAM

**Por que precisa:** para o n8n enviar mensagens no seu Telegram.

1. Clicar "+ Add Credential"
2. Buscar: "Telegram"
3. Selecionar "Telegram API"
4. Preencher:
   - **Access Token:** [Token do seu bot Telegram]
   - Onde achar: no Telegram, abrir @BotFather > /mybots > seu bot > API Token
5. Clicar "Save"
6. Clicar "Test" -- deve aparecer mensagem de sucesso
7. Anotar o NOME que voce deu a esta credencial (ex: "Telegram Vanguard")

---

## CREDENCIAL 2 -- SUPABASE INGRID

**Por que precisa:** para o n8n verificar se o Supabase de Ingrid esta online.

1. Clicar "+ Add Credential"
2. Buscar: "HTTP Request" -- selecionar "HTTP Request"  
   (Supabase nao tem credencial propria no n8n -- usamos HTTP Request com header)
3. Preencher:
   - **Name:** `Supabase Ingrid`
   - **Authentication:** None (vamos configurar no workflow)
4. Clicar "Save"

**ANOTE separado (para usar nos workflows):**
- URL Supabase Ingrid: `https://[ID-DO-PROJETO].supabase.co`
- Service Key Ingrid: `eyJ...` (do arquivo Projeto Supabase Ingrid)

---

## CREDENCIAL 3 -- SUPABASE VALDECE

Mesmo processo da Credencial 2, com as informacoes de Valdece.

**ANOTE separado:**
- URL Supabase Valdece: `https://[ID-DO-PROJETO].supabase.co`
- Service Key Valdece: `eyJ...` (do arquivo Projeto Supabase Valdece)

---

## CREDENCIAL 4 -- GITHUB (para webhook)

**Por que precisa:** para o n8n processar os commits que o Musculo faz.

1. Clicar "+ Add Credential"
2. Buscar: "GitHub"
3. Selecionar "GitHub API"
4. Preencher:
   - **Access Token:** [GitHub Personal Access Token]
   - Onde criar: github.com > Settings > Developer settings > Personal access tokens > Generate new token (classic)
   - Permissoes necessarias: `repo` (marcar o checkbox)
5. Clicar "Save"
6. Anotar o nome dado

---

## CREDENCIAL 5 -- NOTION (para o cockpit)

**Por que precisa:** para o n8n escrever no Notion automaticamente.

1. No Notion, criar uma integracao:
   - Acessar: notion.so/my-integrations
   - Clicar "+ New integration"
   - Nome: "n8n Vanguard"
   - Tipo: Internal
   - Copiar o "Internal Integration Token" (comeca com `secret_`)

2. No n8n, clicar "+ Add Credential"
3. Buscar: "Notion"
4. Selecionar "Notion API"
5. Preencher:
   - **API Key:** [token que voce copiou do Notion]
6. Clicar "Save"

**IMPORTANTE:** apos criar a integracao no Notion, voce precisara dar acesso a ela em cada pagina ou database que o n8n vai usar. No Notion: abrir a pagina > "..." > "Connections" > adicionar "n8n Vanguard".

---

## CHECKLIST FINAL

Antes de importar os workflows, confirmar:

- [ ] Telegram: credencial salva e testada (verde)
- [ ] Supabase Ingrid: URL e Service Key anotados
- [ ] Supabase Valdece: URL e Service Key anotados
- [ ] GitHub: credencial salva
- [ ] Notion: token criado e salvo

---

## PROXIMO: IMPORTAR OS WORKFLOWS

Apos todas as credenciais configuradas, ir para:
**ROTEIRO_N8N_IMPORTAR_WORKFLOWS.md**

---

*Musculo -- Pentalateral IAH -- 2026-06-04*
*Tempo estimado: 30-40 minutos*
