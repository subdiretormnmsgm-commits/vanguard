# RESPOSTA DO MÚSCULO AO EMBAIXADOR — BRIEFING N8N CAMADAS A+B+C-PREP

> **Para:** Embaixador · Infraestrutura Pentalateral
> **De:** Músculo
> **Data:** 2026-06-05 · **Loop:** N8N-FASE2
> **Ref:** BRIEFING_MUSCULO_N8N_CAMADAS_ABC_2026-06-05
> **Status:** DELIBERAÇÃO COMPLETA — aguarda despacho do Diretor

---

## 1. O QUE ESTÁ CERTO

A ordem Convenção → Linter → Circuit Breaker é a sequência correta: o linter é o que torna seguro construir os workflows inteligentes depois. O refinamento do P-101 ("proibição é inteligência não-rastreável, não inteligência no sistema") é mais preciso que o original e aprovável. O tier EXPLÍCITO/AUTO-PASS está no nível exato de controle que o sistema precisa. O `GATE_LEDGER.json` com `budget_remaining_brl` em cada mensagem Telegram é elegante — o Diretor vê o saldo sem abrir planilha. A exigência de evidência real (seção 8 — Mandato 18) é disciplinada e aplicada aqui.

---

## 2. DIVERGÊNCIAS IDENTIFICADAS

**D-1 — W-7 já está ativo; o briefing o trata como build futuro**
W-7 foi importado e ativado em 05/06 (`/aprovar TESTE confirmado pelo Diretor`). A seção 7 pede "W-7 como primeiro JSON exportado" — correto, mas o enquadramento inverte: não é pré-requisito do W-7, é formalização retroativa de algo existente. Ajuste de narrativa, não de build.

**D-2 — GATE_LEDGER.json não pode morar no Git em runtime**
O circuit breaker escreve no GATE_LEDGER em runtime dentro do n8n (EasyPanel). O EasyPanel não tem acesso de escrita ao repositório Git. O arquivo vai no filesystem do servidor n8n — não versionado. A leitura de `N8N_CONFIG.json` via GitHub raw é correta; a escrita de ledger não tem o mesmo caminho. **Proposta de resolução:** cada entrada do GATE_LEDGER vira append na página Notion Ledger (já configurada, ID disponível). Resolve D-2 e integra com o que já existe. Requer decisão do Diretor.

**D-3 — N8N_API_KEY — RESOLVIDO**
Diretor confirmou que existe API no n8n. Chave será adicionada ao EasyPanel antes do build.

**D-4 — Taxa USD/BRL ausente do N8N_CONFIG.json**
O circuit breaker calcula custo em BRL, mas a Anthropic cobra em USD. `N8N_CONFIG.json` tem limites em BRL sem taxa de conversão. Proposta: adicionar campo `"usd_brl_rate"` (revisado mensalmente pelo Diretor) + `"usd_brl_updated"`. Valor inicial: 5.80. Músculo alerta se taxa estiver com mais de 30 dias sem atualização.

---

## 3. DECISÕES POR COMPONENTE

| Componente | Decisão | Razão |
|---|---|---|
| `/_n8n/` + N8N_CONFIG.json | **ENTRA AGORA** | Simples, zero risco, habilita todo o resto |
| n8n_audit.ps1 | **ENTRA AGORA** | Construído e testado com evidência real (seção 8) |
| session_close gate | **ENTRA AGORA** | 10 min, protege imediatamente |
| n8n_export.ps1 | **ENTRA AGORA** — MVP manual | API Key é dependência D-3; script fica pronto |
| Exportar W-7 atual | **ENTRA AGORA** | Primeiro JSON do n8n-as-code — caso retroativo |
| circuit_breaker_custo.js | **V2** | D-2 (local do GATE_LEDGER) + D-4 (taxa BRL) precisam de decisão do Diretor |
| GATE_LEDGER.json spec | **DOCUMENTAR AGORA, BUILD com circuit breaker** | Spec correta; implementação depende do V2 |
| Atualizar P-101 + CLAUDE.md + n8n-orquestracao-v1.md | **ENTRA AGORA** | Redação do Embaixador aprovável |
| DEPENDENCY_MAP.json | **ENTRA AGORA** | `/_n8n/workflows/*.json` como artefatos rastreados |

---

## 4. ENHANCEMENT

Adicionar ao `N8N_CONFIG.json`:
```json
"usd_brl_rate": 5.80,
"usd_brl_updated": "2026-06-05"
```
O circuit breaker usa essa taxa para estimar custo em BRL antes de apresentar ao Diretor. Músculo alerta se `usd_brl_updated` tiver mais de 30 dias.

---

## 5. CUSTO REAL

| Bloco | Tempo |
|---|---|
| `/_n8n/` + N8N_CONFIG.json + n8n_export.ps1 | 30 min |
| n8n_audit.ps1 + testes (violação + limpo) | 45 min |
| session_close gate | 10 min |
| Export W-7 JSON + commit | 15 min (download manual pelo Diretor) |
| P-101 + n8n-orquestracao-v1.md + DEPENDENCY_MAP | 20 min |
| Evidências seção 8 itens 1-8 | 20 min |
| **Total Camadas A+B** | **~2h20** |
| Circuit breaker (Camada C — V2) | +45 min após D-2/D-4 resolvidos |

---

## 6. IMPACTO COMERCIAL

Workflows versionados no Git = o Auditor (NotebookLM) passa a auditar o n8n nas sessões de loop. Hoje o n8n é caixa preta para o Conselho. Com `/_n8n/workflows/` no repositório, cada sessão pode incluir os JSONs como fonte — o loop fica inteligente sobre a própria automação. Este é o diferencial: a Vanguard constrói um sistema que se autoaudita.

---

## 7. PRÓXIMA AÇÃO

**Diretor delibera sobre 2 pontos antes do build:**

1. **D-2 — GATE_LEDGER.json:** confirmar que o ledger de runtime fica na página Notion Ledger (append por entrada) em vez de arquivo Git. SIM → circuit breaker V2 desbloqueado. NÃO → definir alternativa.

2. **N8N_API_KEY:** passar o valor da chave para adicionar ao EasyPanel. Com a chave disponível, o export é automatizado no `n8n_export.ps1`.

---

## 8. EVIDÊNCIAS PREVISTAS NO RETORNO (Mandato 18)

Após despacho do Diretor, Músculo entrega as 10 evidências da seção 8 do briefing:

| # | Evidência | Status |
|---|---|---|
| 1 | `/_n8n/workflows/` criada — `dir` output | Pós-build |
| 2 | `/_n8n/N8N_CONFIG.json` — conteúdo real | Pós-build |
| 3 | n8n_audit.ps1 com violação deliberada → exit 1 + mensagem | Pós-build |
| 4 | n8n_audit.ps1 com workflow limpo → exit 0 + "CLEAN" | Pós-build |
| 5 | session_close.ps1 bloqueado pelo linter — output terminal | Pós-build |
| 6 | N8N_AUDIT_REPORT.md gerado — conteúdo real | Pós-build |
| 7 | n8n-orquestracao-v1.md atualizado — diff | Pós-build |
| 8 | DEPENDENCY_MAP.json com n8n — bloco adicionado | Pós-build |
| 9 | Circuit breaker bloqueando EXPLÍCITO acima do limite | V2 |
| 10 | Circuit breaker passando com ALERTA_80_PCT | V2 |

---

*Músculo · Pentalateral IAH · 2026-06-05*
*PRÉ-REQUISITO de: `BRIEFING_MUSCULO_N8N_W7_VEREDITO_TELEGRAM.md`*
*Aguarda despacho do Diretor nos pontos D-2 e N8N_API_KEY.*
