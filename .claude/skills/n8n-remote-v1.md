SKILL: n8n-remote-v1.md
Camada: Infraestrutura Pentalateral (Universal) | Loop: Operacao EasyPanel 2026-06-14 | Stack: n8n REST API + Playwright MCP + Hermes MCP Bridge

[AUDITORIA DE COERENCIA]
O n8n expoe uma API REST em /api/v1/ autenticada via X-N8N-API-KEY. O Musculo pode criar, atualizar e ativar workflows via API sem abrir o browser, desde que: (1) o body do PUT contenha APENAS { name, nodes, connections, settings, staticData } -- campos extras causam erro 400; (2) workflows com Telegram trigger + Hermes polling sejam implementados com HTTP webhook separado (evita conflito de polling); (3) toda chave de API lida de CHAVES_SISTEMA_VANGUARD.txt -- nunca hardcoded no codigo (P-HV1). O protocolo esta em conformidade com P-075 (Diretor nao transporta -- Musculo orquestra) e P-060 (zero intervencao manual do Diretor em propagacao de infraestrutura).

[CONEXAO HISTORICA]
Sessao 2026-06-14 (W-7 Bridge): Musculo adicionou HTTP webhook trigger ao workflow W-7 (ID: KisAa6ynD4btgrkL) para receber comandos /status /score /custo /aprovar /rejeitar /veredito sem conflito com Hermes long-polling. Primeiro erro encontrado: PUT com body completo retornou 400 "must NOT have additional properties" -- causa: campos read-only (id, versionId, active, meta) incluidos. Solucao: extrair apenas { name, nodes, connections, settings, staticData } do GET e usar exclusivamente estes no PUT. Sessao 2026-06-07 (importacao workflows W-1 a W-7): estabeleceu padrao de importacao via POST /api/v1/workflows e ativacao via POST /activate. Ambas as sessoes confirmaram que a chave X-N8N-API-KEY e suficiente para todas as operacoes de CRUD.

[PADRAO DE SUCESSO/FALHA]
SUCESSO -- PUT com body filtrado: extrair { name, nodes, connections, settings, staticData } do GET antes de qualquer PUT. Validado ao adicionar nodes HTTP webhook e Normalizar HTTP ao W-7 (2026-06-14) -- HTTP 200 confirmado.
SUCESSO -- HTTP webhook trigger: POST /webhook/w7-cmds retornou 200 {"message":"Workflow was started"}. Bridge Hermes->n8n operacional. Hermes registrou MCP n8n-bridge com ferramenta executar_comando.
SUCESSO -- Ativacao via API: POST /api/v1/workflows/{id}/activate funciona independente do estado atual. Idempotente.
FALHA -- PUT com campos read-only: body com id/versionId/active/meta/homeProject/sharedWithProjects/tags/hash retorna 400 "request/body must NOT have additional properties". Sem mensagem de qual campo e o problema -- testar removendo todos os extras de uma vez.
FALHA -- Telegram webhook + Hermes polling simultaneos: conflito irrecuperavel. Hermes usa long-polling no bot; n8n nao pode ter webhook no mesmo bot ao mesmo tempo. Solucao definitiva: HTTP webhook separado no n8n, Hermes chama via MCP bridge.
GATE APRENDIDO: workflow desativado nao processa webhooks. Sempre verificar status e ativar antes de testar endpoints.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, emito alerta sobre a arquitetura de comandos via Telegram: o sistema atual (Hermes polls Telegram + chama n8n via HTTP) funciona mas cria uma cadeia de dependencias: Hermes online -> MCP bridge em /opt/data/ -> n8n online -> workflow W-7 ativo -> Telegram responde. Qualquer no desta cadeia quebrando silencia os comandos do Diretor. Recomendacoes: (1) W-7 deve ter Circuit Breaker -- se n8n cair, Hermes deve alertar Telegram diretamente sem depender do W-7; (2) ping_hermes.ps1 deve verificar tambem se W-7 esta ativo (GET /api/v1/workflows/KisAa6ynD4btgrkL e checar campo active=true); (3) toda nova variavel de ambiente adicionada ao n8n deve ser documentada em RUNBOOK_EASYPANEL.md antes de fechar a sessao -- env vars nao documentadas tornam debugging impossivel apos restarts do container.

ENDPOINTS PRINCIPAIS:
  GET  /api/v1/workflows                   → listar todos
  GET  /api/v1/workflows/{id}              → detalhe completo
  PUT  /api/v1/workflows/{id}              → atualizar (body: name+nodes+connections+settings+staticData APENAS)
  POST /api/v1/workflows                   → criar novo
  POST /api/v1/workflows/{id}/activate     → ativar
  POST /api/v1/workflows/{id}/deactivate   → desativar

WORKFLOWS ATIVOS (2026-06-14):
  W-7  | KisAa6ynD4btgrkL | Telegram + HTTP /webhook/w7-cmds | /status /score /custo /aprovar /rejeitar /veredito
  W-10 | 8yvX4MBzdaK5l6IQ | Cron 6h30 BRT diario | Health Check auto -- erros 24h + inativos + Telegram + PENDING_REVIEW

BRIDGE HERMES->N8N:
  Script: /opt/data/mcp_n8n_bridge.py (Python stdio JSON-RPC 2.0)
  Ferramenta: executar_comando(command, chat_id)
  Endpoint: POST https://vanguard-vanguard-n8n.0ul9nk.easypanel.host/webhook/w7-cmds

CREDENCIAL TELEGRAM:
  ID: pNmpmjEcJ1RUvpz3 | Nome: Vanguard IAH Bot

RUNBOOK: PENTALATERAL_UNIVERSAL/OPERACAO/RUNBOOK_EASYPANEL.md (secao N8N NO EASYPANEL)