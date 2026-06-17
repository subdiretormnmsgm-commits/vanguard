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
SUCESSO -- W-10 arquitetura HTTP Request nodes (2026-06-14): rearquitetar W-10 de 1 Code node com $helpers/fetch para 2 HTTP Request nodes + 1 Code node logica pura resolveu "not defined". Execucao 499 confirmou 9 nos verdes.
SUCESSO -- node selector em Code node typeVersion 2: $('Nome do Node').all()[0].json disponivel para acessar dados de nos nao diretamente conectados. Usar $input.all()[0].json para o no imediatamente anterior.
SUCESSO -- connections array-of-arrays via PowerShell: usar comma operator ,@(@{node="...";type="main";index=0}) para gerar [[{...}]] correto. Sem comma operator = [{...}] (falta um nivel de aninhamento) = erro n8n.
SUCESSO -- WebClient.UploadData para PUT em PS 5.1: [Net.WebClient]::new().UploadData(url,'PUT',[Text.Encoding]::UTF8.GetBytes($body)) mais confiavel que Invoke-RestMethod -Body para UTF-8.
FALHA CRITICA -- $helpers.httpRequest em Code node: $helpers NAO DEFINIDO nesta instancia n8n EasyPanel. Gera "$helpers is not defined". SOLUCAO: usar n8n-nodes-base.httpRequest node dedicado.
FALHA CRITICA -- fetch() em Code node: fetch() TAMBEM NAO DISPONIVEL nesta instancia n8n EasyPanel. Gera "fetch is not defined". CONFIRMA: nenhuma chamada HTTP possivel de dentro de Code node aqui.
REGRA ARQUITETURAL DEFINITIVA (2026-06-14): Code node = logica pura APENAS. HTTP calls = n8n-nodes-base.httpRequest (typeVersion 4.2) nodes dedicados. Sem excecoes nesta instancia EasyPanel.
FALHA -- PUT com campos read-only: body com id/versionId/active/meta/homeProject/sharedWithProjects/tags/hash retorna 400 "request/body must NOT have additional properties". Remover todos os extras de uma vez via ConvertFrom-Json.
FALHA -- Telegram webhook + Hermes polling simultaneos: conflito irrecuperavel. Hermes usa long-polling no bot; n8n nao pode ter webhook no mesmo bot ao mesmo tempo. Solucao definitiva: HTTP webhook separado no n8n, Hermes chama via MCP bridge.
FALHA -- PS here-string @"..."@ interpola $env como PSDrive: $env.VAR em double-quoted here-string gera vazio (PS avalia $env como drive). Usar Write tool para gravar JS em arquivo (zero interpolacao) e ler de volta como bytes.
FALHA -- PUT HTTP 500 com JSON completo: body incluindo campos extras do n8n causa 500. Fluxo correto: GET → ConvertFrom-Json → remover campos proibidos → ConvertTo-Json -Depth 20 → ~9000 chars (correto vs ~18000 chars brutos).
GATE APRENDIDO: workflow desativado nao processa webhooks. Sempre verificar status e ativar antes de testar endpoints.
GATE APRENDIDO: GitHub Code node com fetch() tem continueOnFail:true como mitigacao -- workflow nao falha mas nao registra em PENDING_REVIEW. Converter para HTTP Request node esta no backlog W-10.

[CLONE DE WORKFLOW VIA POWERSHELL 5.1 -- 2026-06-17 (build do W-12)]
Clonar um workflow inteiro (GET workflow A -> patch -> POST como workflow B) expoe 4 armadilhas de serializacao do PS 5.1 que NAO aparecem ao editar um unico campo via PUT. Documentadas por P-146 (documentar sem automatizar = repetir o erro):
1. FALHA CRITICA -- ConvertTo-Json -Depth N TRAVA na estrutura completa de um workflow (PSInvalidCastException "Nao e possivel converter o valor para o tipo System.String"). Vale para o clone inteiro mesmo que -Depth 20 funcione para um PUT pequeno (linha 24). SOLUCAO: System.Web.Script.Serialization.JavaScriptSerializer -- Add-Type -AssemblyName System.Web.Extensions; $ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer; $ser.MaxJsonLength = [int]::MaxValue; $json = $ser.Serialize($body).
2. FALHA CRITICA -- atribuir $node.parameters.jsCode = $novoCodigo num PSCustomObject vindo de ConvertFrom-Json introduz ciclo RuntimeModule que quebra QUALQUER serializador. SOLUCAO: NAO mutar o objeto. Serializar com o jsCode ORIGINAL e trocar por substituicao de TEXTO no JSON ja serializado: $oldEsc = $ser.Serialize($oldJs); $newEsc = $ser.Serialize($novoJs); $json = $json.Replace($oldEsc, $newEsc). Patch de campos simples (ex: cron) DIRETO no objeto e seguro -- so jsCode/strings grandes geram o ciclo.
3. FALHA CRITICA -- @(...) ACHATA arrays aninhados: connections [[{...}]] vira [{...}] = erro 400 "Expected array, received object". SOLUCAO: funcao recursiva de limpeza com System.Collections.ArrayList e retorno com comma operator: $al = New-Object System.Collections.ArrayList; foreach ($i in $o) { [void]$al.Add((Clean $i)) }; return ,($al.ToArray()). A virgula impede o PS de desempacotar object[] de 1 elemento. NAO usar List[object] -- gera outro ciclo (PSParameterizedProperty).
4. FALHA -- POST /workflows/{id}/activate e /deactivate retornam 415 "unsupported media type application/x-www-form-urlencoded" se chamados sem Content-Type. SOLUCAO: Invoke-RestMethod ... -ContentType 'application/json' MESMO sem body.
SUCESSO -- W-12 (dfIMwQOS6qh5EEA7) criado como clone do W-11 (vew2fonxWwiGB9uQ) aplicando as 4 solucoes acima. POST cria sempre DESATIVADO; ativado por veredito apos teste local de 7 datas. Runbook: RUNBOOK_W12_NICHE_INTELLIGENCE.md.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, emito alerta sobre a arquitetura de comandos via Telegram: o sistema atual (Hermes polls Telegram + chama n8n via HTTP) funciona mas cria uma cadeia de dependencias: Hermes online -> MCP bridge em /opt/data/ -> n8n online -> workflow W-7 ativo -> Telegram responde. Qualquer no desta cadeia quebrando silencia os comandos do Diretor. Recomendacoes: (1) W-7 deve ter Circuit Breaker -- se n8n cair, Hermes deve alertar Telegram diretamente sem depender do W-7; (2) ping_hermes.ps1 deve verificar tambem se W-7 esta ativo (GET /api/v1/workflows/KisAa6ynD4btgrkL e checar campo active=true); (3) toda nova variavel de ambiente adicionada ao n8n deve ser documentada em RUNBOOK_EASYPANEL.md antes de fechar a sessao -- env vars nao documentadas tornam debugging impossivel apos restarts do container.

ENDPOINTS PRINCIPAIS:
  GET  /api/v1/workflows                   → listar todos
  GET  /api/v1/workflows/{id}              → detalhe completo
  PUT  /api/v1/workflows/{id}              → atualizar (body: name+nodes+connections+settings+staticData APENAS)
  POST /api/v1/workflows                   → criar novo
  POST /api/v1/workflows/{id}/activate     → ativar
  POST /api/v1/workflows/{id}/deactivate   → desativar

WORKFLOWS ATIVOS (2026-06-17):
  W-7  | KisAa6ynD4btgrkL | Telegram + HTTP /webhook/w7-cmds | /status /score /custo /aprovar /rejeitar /veredito
  W-10 | 8yvX4MBzdaK5l6IQ | Cron 6h30 BRT diario | Health Check auto -- erros 24h + inativos + Telegram + PENDING_REVIEW
  W-11 | vew2fonxWwiGB9uQ | Cron 7h05 BRT diario | Ativacao Manual Notifier -- Projetista (Sexta+dia1) + Embaixador Digital (Segunda+dia5); silencia nos demais dias
  W-12 | dfIMwQOS6qh5EEA7 | Cron 7h10 BRT diario | Niche Intelligence Notifier (clone do W-11) -- ENRIQUECIMENTO MENSAL (dia1) + QUINZENAL F5+F9 (dia15) + deadlines FINEP 30/09 e ANVISA 09/12 (D-30/7/1/0); silencia nos demais dias

BRIDGE HERMES->N8N:
  Script: /opt/data/mcp_n8n_bridge.py (Python stdio JSON-RPC 2.0)
  Ferramenta: executar_comando(command, chat_id)
  Endpoint: POST https://vanguard-vanguard-n8n.0ul9nk.easypanel.host/webhook/w7-cmds

CREDENCIAL TELEGRAM:
  ID: pNmpmjEcJ1RUvpz3 | Nome: Vanguard IAH Bot

RUNBOOK: PENTALATERAL_UNIVERSAL/OPERACAO/RUNBOOK_EASYPANEL.md (secao N8N NO EASYPANEL)