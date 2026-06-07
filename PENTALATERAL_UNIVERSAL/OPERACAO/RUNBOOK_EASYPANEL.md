# RUNBOOK — EasyPanel
**Fonte canônica · Todos os projetos · Atualizado: 2026-06-07**

---

## ACESSO AO PAINEL

- **URL do painel:** `https://0ul9nk.easypanel.host`
- **URL do n8n:** `https://vanguard-vanguard-n8n.0ul9nk.easypanel.host`
- **Credenciais admin:** não salvas — Eduardo acessa com login do browser
- **Credenciais n8n:** em `N8N Easypanel.txt` (gitignored)

---

## DEPLOY DE DOCKER COMPOSE

**Sequência validada em 2026-06-07 (deploy Hermes Agent):**

1. EasyPanel → projeto existente ou criar novo (ex: `hermes`)
2. **+ Serviço** → selecionar **Compose BETA**
3. Colar conteúdo do `docker-compose.yml` no campo exibido
4. Definir env vars na seção **Environment Variables** (interface separada)
5. **Deploy** → aguardar pull da imagem (1-3 min dependendo do tamanho)

**ATENÇÃO:** O EasyPanel NÃO tem API pública para criar serviços Docker Compose via tRPC.
A autenticação tRPC retorna 400 com credenciais do n8n — são sistemas separados.
Deploy Docker Compose = sempre manual pelo painel.

---

## DEPLOY VIA APLICATIVO (imagem única, sem compose)

1. EasyPanel → projeto → **+ Serviço** → **Aplicativo**
2. Source: **Docker Image** → informar `imagem:tag`
3. Porta: definir a porta exposta pelo container
4. Env vars: aba **Environment**
5. Volumes: aba **Mounts**

---

## N8N NO EASYPANEL

**API key do n8n:** em `N8N Easypanel.txt` → campo `n8n API Key`
**Endpoint da API:** `https://vanguard-vanguard-n8n.0ul9nk.easypanel.host/api/v1/`
**Header de autenticação:** `X-N8N-API-KEY: [key]`

### Importar workflow via API (validado 2026-06-07):

```bash
# 1. Ler o JSON do workflow
# 2. Remover campos read-only antes do POST:
#    versionId, id, active, meta, createdAt, updatedAt, hash,
#    homeProject, sharedWithProjects, tags
# 3. POST /api/v1/workflows com o JSON limpo
# 4. PUT /api/v1/workflows/{id} para atualizar credenciais
#    (payload mínimo: name, nodes, connections, settings, staticData)
# 5. POST /api/v1/workflows/{id}/activate para ativar
```

**Erro frequente:** `request/body must NOT have additional properties`
→ Causa: campos read-only no body do PUT/POST
→ Solução: remover os campos listados acima

**Erro frequente:** `Cannot publish workflow: Missing chatId`
→ Causa: Telegram node usa `$env.TELEGRAM_CHAT_ID_DIRETOR` que não existe no n8n
→ Solução: hardcodar o chat ID `8895733647` no parâmetro `chatId` do nó

### Credencial Telegram no n8n:
- ID: `pNmpmjEcJ1RUvpz3`
- Nome: `Vanguard IAH Bot`
- Usar em nós Telegram: `"credentials": { "telegramApi": { "id": "pNmpmjEcJ1RUvpz3", "name": "Vanguard IAH Bot" } }`

---

## ERROS CONHECIDOS

| Erro | Causa | Solução |
|------|-------|---------|
| Login tRPC retorna 400 | Credencial do n8n ≠ credencial do EasyPanel admin | Deploy manual pelo browser |
| `request/body is read-only` | Campo proibido no POST/PUT da API n8n | Remover versionId, meta, id, active |
| Workflow ativo mas webhook retorna "No Respond to Webhook node" | responseMode=responseNode sem nó de resposta | Normal para workflows de ingestão — exit code 0 = sucesso |
| Imagem Docker não encontrada no deploy | Tag errada ou imagem privada | Confirmar existência em hub.docker.com antes |
