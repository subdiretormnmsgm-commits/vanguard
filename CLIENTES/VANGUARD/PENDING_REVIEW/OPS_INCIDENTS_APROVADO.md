# OPS_INCIDENTS — ARTEFATO APROVADO (revisao do Musculo) — 2026-06-16

> Origem: `OPS_INCIDENTS_PROPOSAL.md` (Antigravity EXECUTOR, P-124).
> Status: **APROVADO COM 3 CORRECOES** pelo Veredito do Diretor ("execute tudo", 2026-06-16).
> Este arquivo e o entregavel pronto-para-aplicar. NAO foi aplicado ao n8n vivo ainda.
> GATE DE APLICACAO: ver secao 4 (sequenciamento). Aplicar SO apos rotacao de chaves (P185-ROTACAO).

---

## CORRECOES APLICADAS vs. proposta original

| # | Correcao | Razao |
|---|---|---|
| C1 | Modelo `anthropic/claude-3.5-sonnet` -> `anthropic/claude-sonnet-4-6` | 3.5 desatualizado; padrao Vanguard = modelo atual. **Confirmar slug exato no catalogo OpenRouter antes de aplicar.** |
| C2 | Ramo de fallback Telegram apos o PUT do GitHub (W-10 e irmao) | `continueOnFail:true` cego reintroduz a falha silenciosa que o W-10 tinha. Se o PUT falhar, alerta "incidente NAO registrado". |
| C3 | Checklist de dependencias verificado ANTES de aplicar | Evita 401/undefined em producao. |

---

## 1. CORRECAO DO W-10 (3 nos + fallback)

Substituir o no `"github-push-pending"` por: `GitHub GET` -> `Code (Base64)` -> `GitHub PUT` (`continueOnFail:true`)
-> **`IF (PUT ok?)`** -> [ok] `W-8 Sinal` / [falha] **`Telegram ALERTA "incidente NAO registrado"`**.

Os 3 nos GET/Code/PUT sao identicos a proposta original (secao 1 de OPS_INCIDENTS_PROPOSAL.md), com `$env.GITHUB_PAT_WRITE`
e repo `subdiretormnmsgm-commits/vanguard` (path CONFIRMADO contra o `origin`). Nota: PUT sem `sha` faz CREATE,
entao `OPS_INCIDENTS.md` NAO precisa pre-existir — o 1o incidente cria o arquivo.

### Novo no de guarda (C2) — apos `GitHub -- PUT OPS_INCIDENTS`:
```json
{
  "id": "if-put-ok",
  "name": "IF -- PUT registrou?",
  "type": "n8n-nodes-base.if",
  "typeVersion": 2,
  "position": [2340, 180],
  "parameters": {
    "conditions": {
      "options": { "caseSensitive": true, "version": 2 },
      "combinator": "and",
      "conditions": [
        { "leftValue": "={{ $json.error }}", "rightValue": "", "operator": { "type": "string", "operation": "notExists" } }
      ]
    }
  }
}
```
- Saida TRUE  -> `W-8 -- Sinal W-10` (fluxo original).
- Saida FALSE -> novo `Telegram -- PUT FALHOU` (POST sendMessage: "[W-10] Incidente detectado mas NAO registrado no GitHub. Verificar GITHUB_PAT_WRITE / rate-limit.").

## 2. WORKFLOW IRMAO (blueprint, com C1+C2)
Estrutura identica a secao 2 de OPS_INCIDENTS_PROPOSAL.md, com:
- Modelo no HTTP OpenRouter: `anthropic/claude-sonnet-4-6` (C1).
- Mesmo guarda IF-apos-PUT + Telegram fallback (C2).
- Status do incidente sempre `AGUARDANDO` (propoe, nao auto-corrige). MANTIDO.
- Auto-exclusao do Error Trigger global (anti-loop). MANTIDO.
- Convencao IF/Switch pos-AI-Agent -> Execute Workflow (mitiga AI Agent silencioso). MANTIDO.
- Batching de rate-limit -> V2. MANTIDO.

## 3. RISCOS HERDADOS (sem mudanca)
Race de `sha` em incidentes simultaneos (409 descartado) -> baixo volume aguenta, divida conhecida -> V2 batching.

## 4. SEQUENCIAMENTO DE APLICACAO (GATE)
1. [DIRETOR] Rotacionar chaves (P185-ROTACAO): OpenRouter, Anthropic, Telegram, n8n API key, EasyPanel, Supabase, **GitHub PAT (origin)**, n8n API key (re-exposta).
2. [DIRETOR/MUSCULO] Atualizar env vars no EasyPanel: `GITHUB_PAT_WRITE`, `N8N_API_KEY`, `N8N_BASE_URL` com as chaves novas.
3. [MUSCULO] Verificar dependencias (C3): env `GITHUB_PAT_WRITE` existe? no `Analyze Health` existe com esse nome no W-10?
4. [MUSCULO] Invocar `n8n-remote-v1` -> aplicar correcao W-10 -> testar com 1 incidente sintetico.
5. [MUSCULO] Montar workflow irmao INATIVO em staging -> 7 dias -> Veredito do Diretor -> ativar.
