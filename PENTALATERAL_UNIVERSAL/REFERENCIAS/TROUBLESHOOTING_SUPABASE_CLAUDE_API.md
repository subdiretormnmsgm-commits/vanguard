# TROUBLESHOOTING — Supabase Edge Functions + Claude API
**Criado:** 2026-05-17 | **Extraído de:** PROJ-002 Ingrid (seed_questoes / gerar-questoes)
**Aplica-se a:** todo projeto com Supabase Edge Functions + Anthropic Claude API

> Este documento registra panes reais, sintomas, diagnóstico e correção.
> Cada entrada tem evidência de projeto — não é teoria.
> Ler ANTES de começar qualquer projeto com esta stack.

---

## PANE 1 — Credencial da Anthropic API arquivada

### Sintoma
```
HTTP 500 — resposta instantânea (~300ms)
{"error":"Falha na geração via Claude API","detalhe":"Claude API error: ...invalid x-api-key..."}
```

### Por que identifica rápido
Resposta em <1 segundo → Claude nem chegou a processar. Erro na autenticação.

### Causa
A API key da Anthropic foi arquivada (desativada) no console.anthropic.com — seja manualmente ou por inatividade. A Supabase Secret ainda guarda a chave antiga.

### Correção
1. Acesse [console.anthropic.com](https://console.anthropic.com) → API Keys
2. Crie uma nova chave (não reative a arquivada — ela some da interface)
3. No Supabase Dashboard → Projeto → Settings → Edge Functions → Secrets
4. Atualize `ANTHROPIC_API_KEY` com o novo valor
5. Redeploy NÃO é necessário — secrets são lidos em runtime

### Prevenção
- Verificar se a API key está ativa ANTES de iniciar qualquer sessão de build com IA
- Adicionar ao checklist de kick-off de projeto: "API key Anthropic ativa? Sim/Não"

---

## PANE 2 — Claude retornando markdown em vez de JSON puro

### Sintoma
```
HTTP 500 — resposta após ~28s (Claude processou, mas parse falhou)
{"error":"Falha na geração via Claude API","detalhe":"SyntaxError: Unexpected token '`', \"```json\n{\"..."}
```

### Por que identifica
Tempo longo (>10s) indica que Claude executou. Backtick no erro indica markdown na resposta.

### Causa
Apesar do prompt instruir "JSON puro, sem markdown", Claude Sonnet às vezes retorna:
```
```json
{ "questoes": [...] }
```
```
O `JSON.parse()` falha no `` ` `` inicial.

### Correção
Adicionar strip de markdown antes do `JSON.parse()` na Edge Function:

```typescript
let jsonText = conteudo.trim();
if (jsonText.startsWith("```")) {
  jsonText = jsonText
    .replace(/^```(?:json)?\s*\n?/, "")
    .replace(/\n?```\s*$/, "")
    .trim();
}
const parsed = JSON.parse(jsonText);
```

### Prevenção
Incluir este strip em TODA Edge Function que recebe JSON via Claude API — mesmo que o prompt instrua JSON puro. Claude ocasionalmente ignora a instrução.

---

## PANE 3 — max_tokens insuficiente → JSON truncado

### Sintoma
```
HTTP 500 — resposta após ~45-60s (Claude executou mas cortou no meio)
{"error":"Falha na geração via Claude API","detalhe":"SyntaxError: Unexpected end of JSON input"}
```
Ou ainda: o diagnóstico com quantidade pequena funciona, mas quantidade grande falha.

### Por que identifica
- Diagnóstico com 5 questões: SUCCESS
- Seed com 30 questões: ERRO — mesmo função, mesma disciplina

### Causa
`max_tokens: 4096` é insuficiente para respostas longas:
- Claude Sonnet gera ~693 tokens por questão completa (5 alternativas + gabarito + explicação + distrator)
- 5 questões: ~3.467 tokens → cabe em 4.096 ✓
- 30 questões: ~20.790 tokens → trunca em 4.096 ✗ → JSON incompleto → SyntaxError

### Correção
Dois níveis de correção obrigatórios:

**1. Aumentar max_tokens:**
```typescript
body: JSON.stringify({
  model: modelo,
  max_tokens: 8192,  // era 4096
  messages: [{ role: "user", content: prompt }],
}),
```

**2. Limitar quantidade por invocação:**
A Edge Function deve processar no máximo 8 questões por chamada:
```typescript
const MAX_POR_INVOCACAO = 8;
const efectiveQty = Math.min(quantidade, MAX_POR_INVOCACAO);
```

O seed (ou o caller) faz o loop externo, chamando a função várias vezes.

### Referência de tokens por modelo (estimativa real — PROJ-002 Ingrid)

| Modelo | Tokens por questão | max_tokens seguro para N questões |
|---|---|---|
| claude-sonnet-4-6 | ~693 | `N × 700 + 500` (overhead) |
| claude-haiku-4-5 | ~350 | `N × 400 + 500` |

Para 8 questões Sonnet: 8 × 700 = 5.600 → `max_tokens: 8192` ✓
Para 8 questões Haiku: 8 × 400 = 3.200 → `max_tokens: 4096` ✓ (mas usar 8192 por segurança)

### Prevenção
Regra de ouro: `max_tokens = ceil(quantidade × tokens_por_questao × 1.3)`.
Nunca deixar `max_tokens: 4096` para qualquer geração de múltiplos itens estruturados.

---

## PANE 4 — Timeout da Edge Function por loop interno

### Sintoma
```powershell
ERRO - O tempo limite da operação foi atingido
```
(Todas as disciplinas falham, nenhuma retorna HTTP 500)

### Por que identifica
Timeout do PowerShell (`TimeoutSec 120`) ou da Edge Function (Supabase: ~150s wall clock).

### Causa
Implementar loop de batches **dentro** da Edge Function:
```typescript
for (let b = 0; b < totalBatches; b++) {
  await fetch("https://api.anthropic.com/v1/messages", ...);
}
```
Para 30 questões com Sonnet: 4 batches × ~45s = 180s → estoura os ~150s da Edge Function.

### Correção
**Inverter o controle:** Edge Function faz UMA chamada Claude por invocação. O script de seed faz o loop externo.

**Edge Function — uma chamada por invocação:**
```typescript
const MAX_POR_INVOCACAO = 8;
const efectiveQty = Math.min(quantidade, MAX_POR_INVOCACAO);
const prompt = buildPrompt(disciplina_id, efectiveQty);
// uma única chamada fetch ao Claude API
```

**Seed script — loop externo:**
```powershell
function Invoke-GerarQuestoes {
    param($DisciplinaId, $Quantidade)
    $BATCH   = 8
    $batches = [Math]::Ceiling($Quantidade / $BATCH)
    $totalSalvas = 0
    $custoTotal  = 0.0
    for ($b = 0; $b -lt $batches; $b++) {
        $batchQty = [Math]::Min($BATCH, $Quantidade - $totalSalvas)
        $r = Invoke-GerarLote -DisciplinaId $DisciplinaId -Quantidade $batchQty
        if (-not $r.ok) { return @{ ok = $false; erro = $r.erro } }
        $totalSalvas += $r.salvas
        $custoTotal  += $r.custo_usd
        if ($b -lt ($batches - 1)) { Start-Sleep -Seconds 1 }
    }
    return @{ ok = $true; salvas = $totalSalvas; custo_usd = $custoTotal; ... }
}
```

### Prevenção
**Regra de arquitetura para Edge Functions com LLM:**
- Uma chamada de LLM por invocação da Edge Function
- Tempo máximo aceitável por invocação: 90s (margem de 60s antes do limite Supabase)
- Loop de múltiplas invocações → sempre no caller (seed script, frontend, n8n)

---

## PANE 5 — PowerShell 5.1 quebrando em caracteres Unicode

### Sintoma
```
ParserError: Unexpected token '—' in expression or statement.
```
(Script não executa nenhuma linha)

### Causa
PowerShell 5.1 (padrão Windows) falha em parsear scripts com caracteres especiais no código-fonte:
- Em-dash: `—` (U+2014)
- Caracteres de box-drawing: `═`, `║`, `╔`, etc.
- Outros Unicode fora do ASCII em literais de string

### Correção
Reescrever o script usando apenas ASCII:
- `—` → `-`
- `╔═══╗` → usar apenas `-` ou `=` para bordas
- Testar: `powershell -NonInteractive -File script.ps1`

### Prevenção
Todo script PowerShell gerado pelo Músculo deve usar apenas ASCII no código-fonte.
Acentos em strings de output (dentro de `Write-Host "..."`) são aceitos se o arquivo for salvo em UTF-8 com BOM, mas caracteres especiais fora de strings não são.

---

## PANE 6 — `supabase` CLI não reconhecido no PATH

### Sintoma
```
supabase : O termo 'supabase' não é reconhecido como nome de um cmdlet...
```

### Causa
A CLI do Supabase foi instalada globalmente mas não está no PATH do PowerShell — comum em Windows.

### Correção
Usar `npx` ao invés da CLI global:
```powershell
# Login (apenas uma vez)
npx supabase login

# Deploy de função
npx supabase functions deploy [nome-da-funcao] --project-ref [project-ref]
```

O `project-ref` está na URL do Supabase Dashboard: `https://supabase.com/dashboard/project/[project-ref]`

### Prevenção
Sempre usar `npx supabase` em vez de `supabase` diretamente em ambientes Windows sem configuração de PATH garantida. Documentar o `project-ref` no WIP_BOARD.json de cada projeto.

---

## PANE 7 — Burn rate acumulado de tentativas frustradas

### Sintoma
Seed começa a funcionar mas para no meio. Ou: função retorna 429 com `BURN_RATE_LIMIT atingido`.

### Causa
Cada chamada ao Claude API consome tokens — mesmo quando a Edge Function retorna 500 por falha de parse (Pane 2 ou 3). O Claude gerou o conteúdo, cobrou os tokens, e a Edge Function falhou depois. Se o mesmo seed foi rodado várias vezes durante debugging, o acumulado de custo pode atingir o limite diário.

### Como verificar
No Supabase Dashboard → SQL Editor:
```sql
SELECT data_ref, custo_acumulado_usd, limite_diario_usd, bloqueado
FROM controle_burn_rate
WHERE data_ref >= CURRENT_DATE - 2
ORDER BY data_ref DESC;
```

### Solução imediata
Aguardar o próximo dia (reset automático) ou ajustar o limite temporariamente:
```sql
UPDATE controle_burn_rate SET bloqueado = false, custo_acumulado_usd = 0
WHERE data_ref = CURRENT_DATE;
```

### Prevenção
- Antes de debugar falhas de geração: verificar o saldo do dia
- Durante debugging, usar `quantidade: 1` para testar, não `quantidade: 30`
- Registrar no seed: alertar quando custo do dia > 50% do limite antes de rodar

---

## CHECKLIST DE INÍCIO DE PROJETO — Supabase + Claude API

Copiar para o kick-off de qualquer projeto com esta stack:

```
[ ] 1. API key Anthropic ativa em console.anthropic.com → API Keys
[ ] 2. ANTHROPIC_API_KEY configurada em Supabase Secrets
[ ] 3. Supabase project-ref anotado no WIP_BOARD.json
[ ] 4. Edge Function com strip de markdown antes de JSON.parse
[ ] 5. max_tokens calculado: ceil(max_questoes_por_chamada × tokens_por_item × 1.3)
[ ] 6. Edge Function: uma chamada LLM por invocação (loop no caller, não na função)
[ ] 7. Scripts PowerShell: apenas ASCII no código-fonte
[ ] 8. Deploy via: npx supabase functions deploy [fn] --project-ref [ref]
[ ] 9. Diagnóstico com quantidade=1 ANTES de rodar seed completo
[ ] 10. Burn rate verificado antes de rodar seed (SELECT controle_burn_rate)
```

---

## SEQUÊNCIA OBRIGATÓRIA DE EXECUÇÃO — Supabase + Seed

A cada sessão nova do PowerShell, sempre nesta ordem:

```powershell
# 1. Estar no diretório raiz do projeto
cd "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard"

# 2. Configurar variáveis de ambiente (perdem-se ao fechar o terminal)
$env:SUPABASE_URL = "https://[project-ref].supabase.co"
$env:SUPABASE_SERVICE_ROLE_KEY = "[service_role key — Supabase Dashboard > Settings > API]"

# 3. (Apenas se houve mudança na Edge Function) Deploy
npx supabase functions deploy [nome-da-funcao] --project-ref [project-ref]

# 4. Diagnóstico antes do seed completo (quantidade pequena = custo mínimo)
# Confirmar que a função responde antes de rodar 390 questões
Invoke-RestMethod -Uri "$env:SUPABASE_URL/functions/v1/gerar-questoes" `
  -Method POST `
  -Headers @{ "Authorization" = "Bearer $env:SUPABASE_SERVICE_ROLE_KEY"; "Content-Type" = "application/json" } `
  -Body '{"disciplina_id":"portugues","quantidade":1,"modo":"cache_lote"}' `
  -TimeoutSec 60

# 5. Seed completo
.\CLIENTES\INGRID\seed_questoes.ps1 -QuantidadePorDisciplina 25
```

**Regra dos 3 Nunca:**
- Nunca rodar o seed sem antes confirmar que a API key está ativa (PANE 1)
- Nunca fazer deploy de fora do diretório raiz do projeto (PANE 6 variante)
- Nunca usar `supabase` diretamente — sempre `npx supabase` no Windows

---

## DIAGRAMA DE DIAGNÓSTICO RÁPIDO

```
Seed retornou ERRO?
    │
    ├─ Resposta em <1s → PANE 1 (API key arquivada)
    │
    ├─ Resposta em ~28s com SyntaxError backtick → PANE 2 (markdown JSON)
    │
    ├─ Diagnóstico com 5 questões OK, seed com 30 ERRO → PANE 3 (max_tokens)
    │
    ├─ "tempo limite atingido" em Peso 2, Peso 1 OK → PANE 4 (batch muito grande para Sonnet)
    │
    ├─ ParserError no script PS1 antes de executar → PANE 5 (Unicode PS1)
    │
    ├─ 'supabase' não reconhecido → PANE 6 (CLI PATH)
    │
    ├─ HTTP 400 "Entrypoint path does not exist" no deploy → diretório errado (usar cd primeiro)
    │
    └─ HTTP 429 BURN_RATE_LIMIT → PANE 7 (custo acumulado de debug)
```
