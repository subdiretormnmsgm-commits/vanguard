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

### RESTRIÇÃO CRÍTICA DO SANDBOX DE CODE NODE (descoberta 2026-06-14):

**`$helpers` e `fetch()` NÃO existem no sandbox do Code node nesta instância EasyPanel.**

Qualquer chamada HTTP dentro de um Code node falha com:
- `$helpers is not defined` → ao usar `$helpers.httpRequest()`
- `fetch is not defined` → ao usar `fetch()` nativo

**REGRA ARQUITETURAL DEFINITIVA:**
- `Code node` = lógica pura (transformação, cálculo, formatação) — ZERO chamadas HTTP
- `n8n-nodes-base.httpRequest` (typeVersion 4.2) = toda e qualquer chamada HTTP/REST

**Para ler output de node anterior em um Code node (typeVersion 2):**
```javascript
// Acessa dados de qualquer node por nome (não precisa ser conexão direta)
const dados = $('Nome do Node').all()[0].json;
// Acessa dados do node imediatamente anterior (input)
const dadosInput = $input.all()[0].json;
```

**Erro frequente:** `Cannot publish workflow: Missing chatId`
→ Causa: Telegram node usa `$env.TELEGRAM_CHAT_ID_DIRETOR` que não existe no n8n
→ Solução: hardcodar o chat ID `8895733647` no parâmetro `chatId` do nó

### Credencial Telegram no n8n:
- ID: `pNmpmjEcJ1RUvpz3`
- Nome: `Vanguard IAH Bot`
- Usar em nós Telegram: `"credentials": { "telegramApi": { "id": "pNmpmjEcJ1RUvpz3", "name": "Vanguard IAH Bot" } }`

---

## HERMES AGENT NO EASYPANEL (validado 2026-06-07)

**Imagem:** `nousresearch/hermes-agent:latest` (MIT, Nous Research, 2.3M pulls)
**Projeto EasyPanel:** `hermes` · **Serviço:** `hermes-agent` · **Tipo:** Compose BETA
**Volume persistido:** `hermes_data:/opt/data` — config, kanban, memories, skills, logs

### Problema crítico: env vars do EasyPanel Ambiente NÃO chegam ao container

O EasyPanel Compose BETA NÃO injeta as variáveis da aba "Ambiente" no processo do container.
`echo $TELEGRAM_BOT_TOKEN` retorna vazio mesmo com var configurada no painel.

**Solução validada:** configurar via `hermes config set` dentro do container:
```bash
hermes config set telegram.token SEU_TOKEN
hermes config set telegram.allowed_chats SEU_CHAT_ID
```
Esses valores ficam em `/opt/data/config.yaml` (volume persistido → sobrevive restart).

Para a chave OpenRouter (não tem `hermes config set` para isso):
```bash
# No terminal do container — cria .env que o Hermes lê:
echo 'OPENROUTER_API_KEY=sk-or-v1-...' > /opt/hermes/.env
# ATENÇÃO: /opt/hermes/ NÃO é volume — perde no restart do container
# Workaround permanente: copiar para /opt/data/ e verificar se Hermes aceita symlink
```

### YAML para o Compose BETA (formato validado — sem ${VAR})

- Remover `version:` (obsoleto no Docker Compose v2 — causa parsing error)
- Remover `container_name:` (EasyPanel gerencia)
- Remover `ports:` (EasyPanel gerencia via Domínios — causamconflito)
- Listar env vars SEM valor (`- OPENROUTER_API_KEY`) — mas não chegam (ver acima)

### Comandos úteis no terminal do container

```bash
hermes status                  # ver estado completo (API keys, Telegram, Gateway)
hermes config set KEY VALUE    # salvar config em /opt/data/config.yaml
hermes gateway restart         # reiniciar gateway (pega novos configs)
cat /opt/data/logs/gateways/default/current | tail -30  # ver logs
```

---

## OPERAÇÕES REMOTAS VIA PLAYWRIGHT — CODEMIRROR 6 E XTERM.JS

**Operação EasyPanel (2026-06-14):** Adição de variável de ambiente ao n8n via Playwright MCP.

### Editar variáveis de ambiente (CodeMirror 6) — MÉTODO CORRETO

```js
// Acessar EditorView do CodeMirror 6
const cm = document.querySelector('.cm-content');
const view = cm.cmTile.view;

// Inserir nova variável no final sem destruir o conteúdo
const docText = view.state.doc.toString();
const docLength = view.state.doc.length;
const lastNL = docText.lastIndexOf('\n');
view.dispatch({
  changes: { from: lastNL + 1, to: docLength, insert: 'NOME_VAR=VALOR' }
});

// Verificar antes de salvar
view.state.doc.toString().slice(-60);
```

**PROIBIDO:** `browser_type` com `.cm-content` → usa `fill()` que SUBSTITUI TODO O CONTEÚDO.
**PROIBIDO:** `execCommand('insertText')` e `InputEvent('beforeinput')` → ignorados pelo CodeMirror 6.
**RECUPERAÇÃO:** `browser_press_key(key="Control+z")` → restaura estado anterior após `fill()` acidental.

Após editar → clicar **Salvar** → clicar **Implantar** (Salvar NÃO dispara redeploy automático).

### Terminal do container (xterm.js) — MÉTODO CORRETO

```
browser_type(
  target: ".terminal.xterm.focus textarea[aria-label='Terminal input']",
  text: "comando"
)
```

**PROIBIDO:** execCommand, InputEvent, WebSocket monkey-patch, keyboard.press sem foco.
Aguardar 2s após abrir Console antes de digitar.

### Skills operacionais associadas
- `.claude/skills/easypanel-remote-v1.md` — protocolo completo de operação remota no EasyPanel
- `.claude/skills/n8n-remote-v1.md` — protocolo completo de operação remota no n8n

---

## ERROS CONHECIDOS

| Erro | Causa | Solução |
|------|-------|---------|
| Login tRPC retorna 400 | Credencial do n8n ≠ credencial do EasyPanel admin | Deploy manual pelo browser |
| `request/body is read-only` | Campo proibido no POST/PUT da API n8n | Remover versionId, meta, id, active |
| Workflow ativo mas webhook retorna "No Respond to Webhook node" | responseMode=responseNode sem nó de resposta | Normal para workflows de ingestão — exit code 0 = sucesso |
| Imagem Docker não encontrada no deploy | Tag errada ou imagem privada | Confirmar existência em hub.docker.com antes |
| `yaml: line N: did not find expected key` | `version:` ou `container_name:` no compose | Remover essas diretivas — incompatíveis com Compose BETA |
| `ports is used in X. It might cause conflicts` | `ports:` no compose conflita com roteamento do EasyPanel | Remover `ports:` — configurar exposição via aba Domínios |
| Env vars do Ambiente não chegam ao container | Bug do Compose BETA — vars não injetadas no processo | Usar `hermes config set` para persistir no volume |
| `fill()` no CodeMirror substitui tudo | `browser_type` usa fill() internamente | Usar `dispatch({ changes })` via `cm-content.cmTile.view` |
| `request/body must NOT have additional properties` (n8n PUT) | Campos read-only incluídos no body | Remover id, versionId, active, meta, homeProject, sharedWithProjects, tags, hash |
| `$helpers is not defined` em Code node | $helpers indisponível nesta instância EasyPanel | Usar n8n-nodes-base.httpRequest node para chamadas HTTP |
| `fetch is not defined` em Code node | fetch() indisponível nesta instância EasyPanel | Usar n8n-nodes-base.httpRequest node para chamadas HTTP |
| PUT retorna HTTP 500 após ConvertTo-Json | body inclui campos extras do n8n (id, versionId etc) | ConvertFrom-Json → remover extras → ConvertTo-Json -Depth 20 |
| connections array inválido no PUT via PowerShell | `@(@{})` gera `[{}]` mas n8n precisa de `[[{}]]` | Usar comma operator: `,@(@{})` → `[[{}]]` correto |
