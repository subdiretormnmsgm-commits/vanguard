# DESIGN — CONTEXT ROUTING (A-3 Loop 33)
> Versão: 1.0 · Data: 2026-06-13 · Músculo · Aprovado como conceito em Loop 33 (veredito D10/A-3)
> Problema: Músculo inicia sessão com até 20 projetos simultâneos (P-059) e lê estado manualmente.
> Solução: n8n injeta LOOP_STATE de cada cliente ativo no contexto do Músculo automaticamente.

---

## PROBLEMA QUE RESOLVE

Hoje, ao iniciar uma sessão, o Músculo:
1. Lê WIP_BOARD.json para descobrir quais projetos estão ativos
2. Lê manualmente cada LOOP_STATE.json para entender o estado de cada cliente
3. Cruza com PENDENTES.md para identificar o que está bloqueado

Com 3 clientes = ~5min de overhead. Com 20 clientes = inviável. O Context Routing elimina esse loop manual.

---

## ARQUITETURA

```
[GitHub — CLIENTES/*/CLAUDE_PROJECT/LOOP_STATE.json]
         ↓ (n8n lê via API GitHub — token em ENV)
[W-?? Context Router]
         ↓ filtrar: apenas clientes em BUILD / RETAINER / HYPERCARE
         ↓ compactar para CONTEXT BLOCK por cliente
[session_start.ps1 ou Hermes system prompt]
         ↓ injetar como bloco ## [CLIENTE] STATUS no início da sessão
[Músculo recebe estado pré-carregado — zero leitura manual]
```

---

## FORMATO DO CONTEXT BLOCK (por cliente)

```
## [CONTEXT_ROUTING] INGRID — Loop 8 — RETAINER
Fase     : LOOP_ENCERRADO
Missão   : App em produção. Aguardando captação 2ª candidata antes de 04-07-2026.
Próx_Ação: Loop 9 — gemini_anchor_generator.ps1 com MEMORIA_V8 + relatorio_V8
Sócios   : Gemini ✅ | NotebookLM ✅ | Embaixador ✅ | Músculo ✅
Gates    : p133_gate_zero_captacao ❌ (bloqueante)
Temp     : ENGAJADA · último contato: 2026-06-04
ChurnWatch: 9d (threshold: 14d) — OK
```

**Regras de compactação:**
- Apenas campos: fase_atual, missao (até 120 chars), proxima_acao_musculo, socios.status, gates (só os FALSE), contexto_snapshot.cliente_temperatura + ultimo_contato
- Gates TRUE omitidos — só os FALSE são relevantes para a abertura
- Formato de 1 linha por campo — legível em scroll rápido
- Prefixo `[CONTEXT_ROUTING]` obrigatório — distingue de outros blocos da sessão (P-059)

---

## FILTRO DE PROJETOS

Somente clientes com status em WIP_BOARD.json:
- `BUILD` → incluir sempre
- `RETAINER` → incluir (churn watch ativo)
- `HYPERCARE` → incluir (deadline crítico)
- `STANDBY` → excluir (não há ação do Músculo)
- `DISCOVERY` → excluir (aguarda gatilho do Diretor)
- `ENCERRADO` → excluir

---

## IMPLEMENTAÇÃO — DUAS OPÇÕES

### Opção A — Local via session_start.ps1 (sem dependência de n8n)

```powershell
# Adicionar ao session_start.ps1 após WIP_BOARD read
function Get-ContextRouting {
    param($baseDir, $wip)
    $blocos = @()
    foreach ($proj in $wip.projetos) {
        if ($proj.status -notin @("BUILD","RETAINER","HYPERCARE")) { continue }
        $loopStatePath = "$baseDir\CLIENTES\$($proj.cliente)\CLAUDE_PROJECT\LOOP_STATE.json"
        if (-not (Test-Path $loopStatePath)) { continue }
        $ls = Get-Content $loopStatePath -Raw | ConvertFrom-Json
        $gatesFalhos = ($ls.gates.PSObject.Properties | Where-Object { $_.Value -eq $false } | ForEach-Object { $_.Name }) -join ", "
        $bloco = @(
            "## [CONTEXT_ROUTING] $($ls.cliente) — Loop $($ls.loop_atual) — $($proj.status)",
            "Fase     : $($ls.fase_atual)",
            "Missao   : $($ls.missao.Substring(0, [Math]::Min(120, $ls.missao.Length)))",
            "Prox_Acao: $($ls.proxima_acao_musculo)",
            "Socios   : Gemini $([char]0x2705) | NotebookLM $([char]0x2705) | Embaixador $([char]0x2705) | Musculo $([char]0x2705)",
            "Gates    : $(if ($gatesFalhos) { $gatesFalhos + ' (bloqueante)' } else { 'Todos OK' })",
            "Temp     : $($ls.contexto_snapshot.cliente_temperatura) · ultimo contato: $($ls.contexto_snapshot.ultimo_contato_cliente)"
        ) -join "`n"
        $blocos += $bloco
    }
    return $blocos -join "`n`n"
}
```

**Prós:** sem dependência de n8n, funciona offline, latência zero.
**Contras:** só funciona em sessões locais (não no Hermes cloud).

### Opção B — n8n Workflow W-?? Context Router (cloud)

```json
Trigger  : Webhook POST (chamado pelo session_start.ps1 ou Hermes)
Node 1   : HTTP Request → GitHub API → GET CLIENTES/WIP_BOARD.json
Node 2   : Code → filtrar projetos BUILD/RETAINER/HYPERCARE
Node 3   : Loop → para cada cliente: GET LOOP_STATE.json via GitHub API
Node 4   : Code → formatar CONTEXT BLOCK (compacto)
Node 5   : Respond to Webhook → JSON {blocos: [...]}
```

**Prós:** funciona no Hermes, reutilizável por qualquer agente.
**Contras:** depende de n8n online, latência ~2s por cliente.

---

## DECISÃO RECOMENDADA

**Implementar Opção A primeiro** (local, sem dependência):
- Adicionar `Get-ContextRouting` ao session_start.ps1 como PASSO 8g
- Output injetado antes do LEMBRETE DE LOOP e do WIP_BOARD resumo
- Custo: ~1h de build

**Depois:** quando Hermes Grau C ativo e W-9+ forem estáveis → migrar para Opção B.

---

## RESTRIÇÕES OBRIGATÓRIAS (P-059)

1. **Prefixo `[CONTEXT_ROUTING]` obrigatório** — Músculo nunca confunde contexto de clientes
2. **Nunca misturar clientes no mesmo bloco** — um bloco por cliente, sempre
3. **Dado de LOOP_STATE.json em disco** — nunca de memória do chat (P-091)
4. **Se LOOP_STATE ausente → omitir o cliente do routing** — nunca fabricar estado
5. **CONTEXT_ROUTING é leitura, não escrita** — Músculo não atualiza LOOP_STATE via routing

---

## GATE DE IMPLEMENTAÇÃO

Este design não avança para build sem:
- [ ] Diretor aprova Opção A ou B
- [ ] LOOP_STATE.json v1.1 verificado em disco para todos os clientes ativos
- [ ] session_start.ps1 tem slot PASSO 8g disponível (não conflita com outros passos)

**Status atual:** DESIGN APROVADO · BUILD PENDENTE veredito do Diretor (Opção A vs B)

---

*DESIGN_CONTEXT_ROUTING.md · Músculo · 2026-06-13 · A-3 Loop 33*
