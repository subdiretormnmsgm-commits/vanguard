# Intelligence Compounding Engine — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transformar o Pentalateral IAH num organismo que acumula inteligência por sessão — cada decisão, fricção e princípio descoberto vira conhecimento permanente e reutilizável.

**Architecture:** Camada humana (`INTELLIGENCE_LEDGER.md`) + camada programática (`knowledge_graph.json`) + Constituição de Processo (Hard/Soft Vetos no `AVISO_ARQUITETO.md`) + Shadow Architect obrigatório no MEMORANDO + template `CONSELHO_SESSAO` para deliberação síncrona.

**Tech Stack:** PowerShell (scripts de sessão), JSON (knowledge graph), Markdown (LEDGER + templates), Python (integração futura com briefing matinal)

---

## Mapa de Arquivos

| Arquivo | Status | Responsabilidade |
|---|---|---|
| `INTELLIGENCE_LEDGER.md` | ✅ Criado | Organismo central — princípios, padrões, log de sessões |
| `knowledge_graph.json` | ✅ Criado | Camada programática — alimenta scripts e GUT |
| `PENTALATERAL_UNIVERSAL/TEMPLATES/CONSELHO_SESSAO_TEMPLATE.md` | ✅ Criado | Template de sessão síncrona |
| `PENTALATERAL_UNIVERSAL/OPERACAO/AVISO_ARQUITETO.md` | ✅ Atualizado | Constituição de Processo (Hard/Soft Vetos) |
| `PENTALATERAL_UNIVERSAL/CONSTITUICAO/MEMORANDO_PENTALATERAL_UNIVERSAL.md` | ✅ Atualizado | v5.1 — Shadow Architect + histórico |
| `docs/superpowers/specs/2026-05-12-intelligence-compounding-engine-design.md` | ✅ Criado | Design spec aprovado |
| `scripts/session_close.ps1` | 🔲 A criar | Prompt de fechamento de sessão — força atualização do LEDGER |
| `scripts/alert_daily_briefing.ps1` | 🔲 A modificar | Integrar contagem de princípios ativos no GUT |

---

## Task 1: Verificar artefatos criados

**Files:**
- Verify: `INTELLIGENCE_LEDGER.md`
- Verify: `knowledge_graph.json`
- Verify: `PENTALATERAL_UNIVERSAL/TEMPLATES/CONSELHO_SESSAO_TEMPLATE.md`

- [ ] **Step 1: Verificar existência dos arquivos**

```powershell
$arquivos = @(
    "INTELLIGENCE_LEDGER.md",
    "knowledge_graph.json",
    "PENTALATERAL_UNIVERSAL\TEMPLATES\CONSELHO_SESSAO_TEMPLATE.md",
    "PENTALATERAL_UNIVERSAL\OPERACAO\AVISO_ARQUITETO.md"
)
foreach ($f in $arquivos) {
    $existe = Test-Path $f
    Write-Host "$f → $existe"
}
```

Expected: todos retornam `True`

- [ ] **Step 2: Validar JSON do knowledge_graph**

```powershell
$kg = Get-Content "knowledge_graph.json" -Raw | ConvertFrom-Json
Write-Host "Princípios: $($kg.principles.Count)"
Write-Host "Sessões: $($kg.sessions.Count)"
Write-Host "Hard Vetos: $($kg.constitution.hard_vetos.Count)"
```

Expected:
```
Princípios: 5
Sessões: 1
Hard Vetos: 5
```

- [ ] **Step 3: Verificar seções do INTELLIGENCE_LEDGER**

```powershell
$ledger = Get-Content "INTELLIGENCE_LEDGER.md" -Raw
$secoes = @("PRINCÍPIOS ATIVOS", "PADRÕES CONFIRMADOS", "PADRÕES REFUTADOS", "CONSTITUIÇÃO DE PROCESSO", "SHADOW ARCHITECT", "LOG DE SESSÕES")
foreach ($s in $secoes) {
    Write-Host "$s → $($ledger.Contains($s))"
}
```

Expected: todos retornam `True`

- [ ] **Step 4: Commit dos artefatos criados**

```powershell
git add INTELLIGENCE_LEDGER.md knowledge_graph.json
git add "PENTALATERAL_UNIVERSAL\TEMPLATES\CONSELHO_SESSAO_TEMPLATE.md"
git add "PENTALATERAL_UNIVERSAL\OPERACAO\AVISO_ARQUITETO.md"
git add "PENTALATERAL_UNIVERSAL\CONSTITUICAO\MEMORANDO_PENTALATERAL_UNIVERSAL.md"
git add "docs\superpowers\specs\2026-05-12-intelligence-compounding-engine-design.md"
git add "docs\superpowers\plans\2026-05-12-intelligence-compounding-engine.md"
git add "scripts\alert_daily_briefing.ps1"
git commit -m "feat(v24): Intelligence Compounding Engine -- LEDGER + knowledge_graph + Constituicao de Processo + Shadow Architect + CONSELHO_SESSAO template"
```

---

## Task 2: Criar script de fechamento de sessão

**Files:**
- Create: `scripts/session_close.ps1`

- [ ] **Step 1: Criar o script**

```powershell
# scripts/session_close.ps1
# Executar ao fechar qualquer sessão do Pentalateral
# Prompts obrigatórios para atualizar o INTELLIGENCE_LEDGER

$BASE = Split-Path -Parent $PSScriptRoot
$LEDGER = "$BASE\INTELLIGENCE_LEDGER.md"
$KG     = "$BASE\knowledge_graph.json"
$DATA   = Get-Date -Format "yyyy-MM-dd"

Write-Host ""
Write-Host "=============================================="
Write-Host "  FECHAMENTO DE SESSÃO — Pentalateral IAH"
Write-Host "=============================================="
Write-Host ""

# --- Verificar se LEDGER existe ---
if (-not (Test-Path $LEDGER)) {
    Write-Host "ERRO: INTELLIGENCE_LEDGER.md nao encontrado."
    exit 1
}

# --- Perguntas de captura de sessão ---
Write-Host "SESSÃO: $DATA"
Write-Host ""
Write-Host "[1/4] Houve FRICÇÃO nesta sessão? (ALERTA emitido, P0 criado, escopo mudou)"
Write-Host "      Se sim, descreva em 1 linha (Enter para pular):"
$friccao = Read-Host "    > "

Write-Host ""
Write-Host "[2/4] Algum PRINCÍPIO novo foi descoberto? (o 'porquê' por trás de uma decisão)"
Write-Host "      Se sim, descreva em 1 linha (Enter para pular):"
$principio = Read-Host "    > "

Write-Host ""
Write-Host "[3/4] O Diretor fez OVERRIDE de algum veto? (Hard ou Soft)"
Write-Host "      Se sim, descreva qual e o motivo (Enter para pular):"
$override = Read-Host "    > "

Write-Host ""
Write-Host "[4/4] Houve DERIVA? (sessão divergiu de um princípio ativo?)"
Write-Host "      Se sim, qual princípio e como foi corrigido (Enter para pular):"
$deriva = Read-Host "    > "

# --- Montar entrada no LEDGER ---
$entrada = @"


### [SESSÃO $DATA]

"@

if ($friccao)  { $entrada += "`n``[FRICÇÃO]`` $friccao" }
if ($principio){ $entrada += "`n``[PRINCÍPIO]`` $principio" }
if ($override) { $entrada += "`n``[OVERRIDE]`` $override" }
if ($deriva)   { $entrada += "`n``[DERIVA]`` $deriva" }

if ($friccao -or $principio -or $override -or $deriva) {
    # Inserir antes de ## GLOSSÁRIO
    $conteudo = Get-Content $LEDGER -Raw
    $conteudo = $conteudo -replace "(## GLOSSÁRIO)", "$entrada`n`n## GLOSSÁRIO"
    Set-Content $LEDGER -Value $conteudo -Encoding utf8
    Write-Host ""
    Write-Host "✓ INTELLIGENCE_LEDGER.md atualizado."
} else {
    Write-Host ""
    Write-Host "Nenhum evento registrado nesta sessão."
}

# --- Atualizar sessão no knowledge_graph.json ---
$kg = Get-Content $KG -Raw | ConvertFrom-Json
$sessoes = [System.Collections.ArrayList]@($kg.sessions)
$sessoes.Insert(0, @{
    date = $DATA
    label = "Sessão $DATA"
    friction_events = if ($friccao) { 1 } else { 0 }
    principles_generated = if ($principio) { @("novo") } else { @() }
    overrides = if ($override) { @(@{ description = $override }) } else { @() }
    drift_detected = if ($deriva) { $true } else { $false }
})

# Manter apenas últimas 20 sessões
if ($sessoes.Count -gt 20) { $sessoes = $sessoes[0..19] }
$kg.sessions = $sessoes
$kg.meta.last_updated = $DATA
$kg.meta.total_sessions = $sessoes.Count

$kg | ConvertTo-Json -Depth 10 | Set-Content $KG -Encoding utf8
Write-Host "✓ knowledge_graph.json atualizado."

Write-Host ""
Write-Host "=============================================="
Write-Host "  Próximo passo: git commit + fechar sessão"
Write-Host "=============================================="
```

- [ ] **Step 2: Testar o script em modo dry-run**

```powershell
# Verificar se o script está sintaticamente correto
powershell -NonInteractive -Command "& { . '.\scripts\session_close.ps1' }" 2>&1 | Select-Object -First 5
```

Expected: script carrega sem erros de parse (vai pedir inputs que não chegarão — OK para teste de sintaxe)

- [ ] **Step 3: Commit do script**

```powershell
git add "scripts\session_close.ps1"
git commit -m "feat(v24): session_close.ps1 -- prompt obrigatorio de fechamento atualiza LEDGER e knowledge_graph"
```

---

## Task 3: Integrar contagem de princípios no GUT do briefing matinal

**Files:**
- Modify: `scripts/alert_daily_briefing.ps1` (seção de cálculo GUT)

- [ ] **Step 1: Adicionar leitura do knowledge_graph no briefing**

Adicionar após a linha `$wip = Get-Content $WIP_PATH -Raw | ConvertFrom-Json`:

```powershell
# --- Carregar Intelligence Knowledge Graph ---
$KG_PATH = "$BASE\knowledge_graph.json"
$kg_data = $null
$principios_ativos = 0
if (Test-Path $KG_PATH) {
    $kg_data = Get-Content $KG_PATH -Raw | ConvertFrom-Json
    $principios_ativos = $kg_data.principles.Count
}
```

- [ ] **Step 2: Adicionar métrica de inteligência no email HTML**

Na seção da tabela do board (após linha de RETAINER), adicionar:

```powershell
# linha adicional na tabela HTML do briefing
$inteligencia_row = @"
    <tr style="background:#111;">
      <td style="padding:10px;border:1px solid #222;color:#888;font-size:11px;">INTELIGÊNCIA</td>
      <td style="padding:10px;border:1px solid #222;font-size:12px;">
        <span style="color:#00F0FF;">$principios_ativos princípio(s) ativo(s)</span> no LEDGER
        · Sessões: $($kg_data.meta.total_sessions)
      </td>
    </tr>
"@
```

- [ ] **Step 3: Tendência GUT sobe se LEDGER não foi atualizado há >3 dias**

Adicionar à seção de cálculo de Tendência GUT:

```powershell
# Tendencia sobe se LEDGER desatualizado
if ($kg_data) {
    $ultima_sessao = [datetime]::ParseExact($kg_data.meta.last_updated, "yyyy-MM-dd", $null)
    $dias_sem_ledger = ([datetime]::Today - $ultima_sessao).Days
    if ($dias_sem_ledger -ge 3) {
        $gut_tendencia = [Math]::Min(5, $gut_tendencia + 1)
        $gut_razoes += "  . INTELLIGENCE_LEDGER nao atualizado ha $dias_sem_ledger dias"
    }
}
```

- [ ] **Step 4: Testar o briefing com as alterações**

```powershell
# Dry-run do briefing (sem enviar email — comentar a linha smtp.Send)
powershell -File ".\scripts\alert_daily_briefing.ps1" 2>&1 | Select-Object -Last 5
```

Expected: sem erros de parse, log registra tentativa de envio

- [ ] **Step 5: Commit**

```powershell
git add "scripts\alert_daily_briefing.ps1"
git commit -m "feat(v24): briefing matinal integra INTELLIGENCE_LEDGER -- principios ativos + GUT penaliza LEDGER desatualizado"
```

---

## Task 4: Commit de fechamento V24

- [ ] **Step 1: Verificar status completo**

```powershell
git status
git log --oneline -5
```

- [ ] **Step 2: Commit final de fechamento**

```powershell
git add .
git commit -m "feat(v24): Intelligence Compounding Engine -- organismo de aprendizado por sessao

- INTELLIGENCE_LEDGER.md: 5 principios ativos, padroes confirmados/refutados, Constituicao de Processo
- knowledge_graph.json: camada programatica para scripts e GUT
- CONSELHO_SESSAO_TEMPLATE.md: deliberacao sincrona dos 4 membros
- AVISO_ARQUITETO.md v2.0: 5 Hard Vetos + 5 Soft Vetos + Skill-Drift Check
- MEMORANDO v5.1: Shadow Architect obrigatorio em todo Build
- session_close.ps1: prompt de fechamento forca captura de inteligencia
- briefing matinal: integra principios ativos + penaliza LEDGER desatualizado no GUT

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Self-Review

**Spec coverage:**
- ✅ INTELLIGENCE_LEDGER.md criado com estrutura completa
- ✅ knowledge_graph.json criado com schema correto
- ✅ 5 sementes implementadas (Friction Log, Skill-Drift, Shadow Architect, Synchronous Council, Multimodal Intent)
- ✅ Constituição de Processo (Hard/Soft Vetos) no AVISO_ARQUITETO
- ✅ Shadow Architect no MEMORANDO
- ✅ CONSELHO_SESSAO template criado
- 🔲 session_close.ps1 — a criar (Task 2)
- 🔲 Integração GUT no briefing — a implementar (Task 3)

**Placeholder scan:** nenhum TBD ou TODO encontrado.

**Type consistency:** script PS1 usa mesmos caminhos (`$BASE`, `$KG_PATH`) que o briefing existente. Consistente.
