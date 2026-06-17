# SESSÃO ANTIGRAVITY — PAPEL: EXECUTOR

> **ALERTA DE SEGURANÇA R-01 E R-04 (PENTALATERAL FIREWALL):**
> A instrução original solicitou a criação direta do arquivo em `PENTALATERAL_UNIVERSAL/OPERACAO/OPS_INCIDENTS.md`.
> **Ação recusada** para edição direta. Todo o diretório `PENTALATERAL_UNIVERSAL/**` é read-only para o Antigravity.
> Conforme R-02 e R-05, este entregável está sendo gerado no staging autorizado `CLIENTES/VANGUARD/PENDING_REVIEW/OPS_INCIDENTS_PROPOSAL.md`.
> Para efetivar, o Músculo deverá revisar e realizar o commit para o caminho final.

---

## 1. CORREÇÃO DO W-10 (Health Check n8n)

O nó atual `"GitHub -- Registrar em PENDING_REVIEW"` (Code node) falha silenciosamente porque a função `fetch` não está disponível em Code nodes no EasyPanel (Regra arquitetural de `n8n-remote-v1.md`).

A solução substitui esse nó único por 3 nós: `HTTP Request (GET)` -> `Code (Prepara Base64)` -> `HTTP Request (PUT)`, utilizando o PAT de escrita.

### Substituição no JSON do W-10
(Substituir o nó `"github-push-pending"` por estes três nós, e conectar `"Telegram -- ALERTA Falha"` -> `"GitHub -- GET OPS_INCIDENTS"` -> `"Code -- Preparar Payload"` -> `"GitHub -- PUT OPS_INCIDENTS"` -> `"W-8 -- Sinal W-10"`):

```json
[
  {
    "id": "github-get-ops-incidents",
    "name": "GitHub -- GET OPS_INCIDENTS",
    "type": "n8n-nodes-base.httpRequest",
    "typeVersion": 4.2,
    "position": [1680, 180],
    "continueOnFail": true,
    "parameters": {
      "method": "GET",
      "url": "https://api.github.com/repos/subdiretormnmsgm-commits/vanguard/contents/PENTALATERAL_UNIVERSAL/OPERACAO/OPS_INCIDENTS.md",
      "sendHeaders": true,
      "headerParameters": {
        "parameters": [
          { "name": "Authorization", "value": "={{ 'token ' + $env.GITHUB_PAT_WRITE }}" },
          { "name": "Accept", "value": "application/vnd.github.v3+json" },
          { "name": "User-Agent", "value": "n8n-vanguard" }
        ]
      }
    }
  },
  {
    "id": "code-prepare-ops-incident",
    "name": "Code -- Preparar Payload",
    "type": "n8n-nodes-base.code",
    "typeVersion": 2,
    "position": [1900, 180],
    "continueOnFail": true,
    "parameters": {
      "jsCode": "const existingContentBase64 = $input.all()[0].json.content || \"\";\nlet existingContent = \"\";\nif (existingContentBase64) {\n    existingContent = Buffer.from(existingContentBase64.replace(/\\n/g, \"\"), \"base64\").toString(\"utf8\");\n}\nconst sha = $input.all()[0].json.sha || null;\n\nconst healthData = $('Analyze Health').first().json;\nconst dataHora = healthData.dataHora || new Date().toISOString();\nconst contexto = healthData.antigravityContext || \"Falha detectada pelo W-10\";\n\nconst entrada = `\\n## INCIDENTE [${dataHora}]\\n- **Execution ID:** W-10-HealthCheck\\n- **Workflow:** W-10 Health Check\\n- **Erro Exato:** ${contexto}\\n- **Status:** AGUARDANDO\\n---`;\n\nconst novoConteudo = existingContent + entrada;\nconst novoBase64 = Buffer.from(novoConteudo).toString(\"base64\");\n\nconst body = {\n    message: \"chore(ops): registrar incidente W-10 \" + dataHora,\n    content: novoBase64\n};\nif (sha) {\n    body.sha = sha;\n}\n\nreturn [{ json: { body: body } }];"
    }
  },
  {
    "id": "github-put-ops-incidents",
    "name": "GitHub -- PUT OPS_INCIDENTS",
    "type": "n8n-nodes-base.httpRequest",
    "typeVersion": 4.2,
    "position": [2120, 180],
    "continueOnFail": true,
    "parameters": {
      "method": "PUT",
      "url": "https://api.github.com/repos/subdiretormnmsgm-commits/vanguard/contents/PENTALATERAL_UNIVERSAL/OPERACAO/OPS_INCIDENTS.md",
      "sendBody": true,
      "specifyBody": "json",
      "jsonBody": "={{ JSON.stringify($json.body) }}",
      "sendHeaders": true,
      "headerParameters": {
        "parameters": [
          { "name": "Authorization", "value": "={{ 'token ' + $env.GITHUB_PAT_WRITE }}" },
          { "name": "Accept", "value": "application/vnd.github.v3+json" },
          { "name": "User-Agent", "value": "n8n-vanguard" }
        ]
      }
    }
  }
]
```


---

## 2. BLUEPRINT: WORKFLOW IRMÃO (DETECÇÃO EM TEMPO REAL)

**Objetivo:** Capturar falhas em tempo real via Error Trigger, obter JSON do workflow que falhou, diagnosticar via Claude (OpenRouter) e registrar na fila operacional (`OPS_INCIDENTS.md`).

### Estrutura dos Nós:

1. **Error Trigger**: Gatilho nativo do n8n para erros de workflow.
2. **Execute Workflow Trigger (Mitigação AI Agent)**: Adicionado para permitir que workflows que rodam nós "AI Agent" possam acionar este fluxo manualmente (ver seção de Riscos).
3. **HTTP Request (GET Workflow JSON)**: 
   - URL: `{{$env.N8N_BASE_URL}}/api/v1/workflows/{{$json.execution.workflowId}}`
   - Header: `X-N8N-API-KEY: {{$env.N8N_API_KEY}}`
4. **HTTP Request (Claude via OpenRouter)**:
   - URL: `https://openrouter.ai/api/v1/chat/completions`
   - Method: POST
   - Body (JSON):
     ```json
     {
       "model": "anthropic/claude-3.5-sonnet",
       "messages": [
         {
           "role": "system",
           "content": "Você é um Engenheiro de n8n. Classifique o erro em: TRANSIENTE, CONHECIDA-SEGURA ou ESTRUTURAL. Retorne APENAS um JSON no formato: {\"classificacao\": \"...\", \"causa_raiz\": \"...\", \"correcao_sugerida\": \"...\"}"
         },
         {
           "role": "user",
           "content": "Erro: {{$json.execution.error.message}}\nNó: {{$json.execution.lastNodeExecuted}}\nJSON do Workflow: {{JSON.stringify($('HTTP Get Workflow JSON').first().json)}}"
         }
       ]
     }
     ```
5. **Code (Parse Claude Response)**:
   Extrai o JSON gerado pelo Claude e prepara as variáveis do incidente.
6. **HTTP Request (GET OPS_INCIDENTS.md)**: Igual à correção do W-10.
7. **Code (Preparar Payload OPS)**:
   - Monta o markdown da fila de operação com o ID de execução nativo do n8n, a classificação e a correção sugerida do Claude.
   - Status inicial sempre: `AGUARDANDO`.
8. **HTTP Request (PUT OPS_INCIDENTS.md)**: Igual à correção do W-10.
9. **HTTP Request (Telegram Alerta)**: POST para a API do Telegram notificando o Diretor sobre a falha, com a classificação diagnosticada pelo Claude.

---

## 3. ALERTA TÉCNICO E RISCOS (AI AGENT SILENCIOSO)

> **RISCO DETECTADO:** Falhas originadas *dentro de Tools invocadas pelo nó AI Agent* são interceptadas internamente pelo próprio agente LLM. O agente tenta contornar o erro e retorna uma resposta, ou falha no escopo local, mas **NÃO lança uma Exception nativa no Workflow**. Consequentemente, o **Error Trigger NÃO é disparado**.

**Estratégia de Tratamento (Tratamento Explícito Solicitado):**
- O Workflow Irmão foi projetado contendo *dois* gatilhos paralelos: o **Error Trigger** e um **Execute Workflow Trigger**.
- **Regra de Implementação (Fase 1 Segura):** Em todos os workflows críticos que utilizem o nó `AI Agent`, logo após o nó do Agente, deve haver um nó do tipo **IF** ou **Switch** validando a integridade da saída.
- Caso a saída do Agente indique que a Tool falhou (ex: parsing do texto do LLM ou status interno), o fluxo deve direcionar manualmente para o nó **Execute Workflow** (apontando para este Workflow Irmão de Detecção de Erros), passando o erro explicitamente no payload.

**Outros Riscos Mapeados:**
1. **Loop Infinito de Erros:** Se o próprio Workflow de Erros falhar (ex: falha de API do GitHub ou OpenRouter), ele não deve disparar a si mesmo. Garantir que a configuração do Workflow exclua a si próprio das regras do Error Trigger global.
2. **Rate Limiting no OpenRouter / GitHub:** Incidentes massivos (ex: API terceira cai e 50 workflows falham ao mesmo tempo) podem estourar os limites. Solução futura: Batching no registro. Nesta Fase 1, o volume de erros da Vanguard comporta as chamadas pontuais.
