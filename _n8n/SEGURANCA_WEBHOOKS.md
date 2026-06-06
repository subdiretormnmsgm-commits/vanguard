# SEGURANÇA — WEBHOOKS N8N
> Criado: 2026-06-06 · Gate: 2026-06-18 (antes de produção com dados sensíveis)
> Status: Script local OK · n8n requer UI do Diretor (API PUT indisponível)

---

## O QUE JÁ ESTÁ FEITO (Músculo)

- `n8n_session_webhook.ps1` agora envia header `X-Webhook-Secret` em todo POST para W-4
- Secret lido de `CHAVES_SISTEMA_VANGUARD.txt` → campo `N8N_WEBHOOK_SECRET`
- Valor: `9rY8Yjq6cPd6y0ozEsfUXggy3IhUDYyiQm2LQTTJoc`

---

## O QUE O DIRETOR PRECISA FAZER

### W-4 (Session Close) — Adicionar validação de secret

**No n8n UI:**
1. Abrir workflow `04 -- Session Close MEMORIA Update`
2. Entre o node "Webhook Session Close" e o node "Processar Payload", adicionar um **Code node**
3. Nome sugerido: `Validar Secret`
4. Código do node:

```javascript
const secret = $env.N8N_WEBHOOK_SECRET || '';
const recebido = ($input.item.json.headers || {})['x-webhook-secret'] || '';
if (!secret || recebido !== secret) {
  return [{ json: { erro: 'Acesso nao autorizado', valido: false } }];
}
return [$input.item];
```

5. Adicionar um **If node** após o Code node:
   - Condição: `{{ $json.valido !== false }}`
   - Ramo TRUE → conectar ao "Processar Payload"
   - Ramo FALSE → terminar (sem nó conectado)

---

### W-3 (GitHub Push) — HMAC nativo do GitHub

**No GitHub:**
1. Acessar: `github.com/subdiretormnmsgm-commits/vanguard` → Settings → Webhooks
2. Editar o webhook existente → campo "Secret": `9rY8Yjq6cPd6y0ozEsfUXggy3IhUDYyiQm2LQTTJoc`
3. Salvar

**No n8n UI (workflow `03 -- GitHub Webhook Push`):**
1. Entre "Webhook GitHub Push" e "Extrair Dados do Push", adicionar **Code node** (`Validar HMAC`):

```javascript
const crypto = require('crypto');
const secret = $env.N8N_WEBHOOK_SECRET || '';
const sig = (($input.item.json.headers || {})['x-hub-signature-256'] || '').replace('sha256=', '');
const body = JSON.stringify($input.item.json.body || $input.item.json);
const expected = crypto.createHmac('sha256', secret).update(body).digest('hex');
if (!secret || sig !== expected) {
  return [{ json: { erro: 'HMAC invalido', valido: false } }];
}
return [$input.item];
```

2. Adicionar If node com mesma lógica do W-4.

---

## IMPACTO ATUAL

- **Baixo** — URL dos webhooks não é pública (EasyPanel não expõe endpoint por padrão)
- **Quando elevar:** antes de usar W-4 com dados sensíveis de cliente fora do ambiente local

---

## VARIÁVEL DE AMBIENTE N8N_WEBHOOK_SECRET

Já está definida no EasyPanel (configurada com o valor acima).
Se não estiver: EasyPanel → vanguard-n8n → Ambiente → adicionar:
```
N8N_WEBHOOK_SECRET = 9rY8Yjq6cPd6y0ozEsfUXggy3IhUDYyiQm2LQTTJoc
```
