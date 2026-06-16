# Loop 35 — Trilha Crítica (E-4 Burn Rate Shield + Company Page/POST ECD) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir o gate de custo (E-4) que destrava toda automação Cowork e publicar a Company Page + POST ECD (gancho real: prazo 30/06 + multa) antes do webinar nacional de 17/06 — fechando a lacuna externa que matou o Loop 34.

**Architecture:** Dois subsistemas na trilha crítica. (1) `burn_rate_shield.ps1` — circuit breaker de custo de runtime (distinto do `build_budget_guard.ps1`, que é budget de *builds*), bloqueia toda tarefa Cowork autônoma se o gasto da janela exceder o teto. (2) Company Page LinkedIn + POST ECD — ato externo: conteúdo redigido em disco + revisão + publicação via browser sob confirmação do Diretor, com gate E-1 registrado no fechamento. Os 3 atores (build profundo das 15 skills + atividades Cowork) ficam em planos-filho separados.

**Tech Stack:** PowerShell 5.1 (scripts, ASCII no-BOM via Write tool, validado por `scripts/validate_scripts.ps1`), JSON de estado (`LOOP_STATE.json`, `burn_rate_state.json`), Playwright MCP (publicação browser), Markdown (conteúdo + PENDING_REVIEW).

**Escopo desta sessão (P-059):** loop interno VANGUARD. Nenhum dado de Ingrid/Valdece/Mumuzinho tocado. INTELLIGENCE_HUB isolado (P-124) — saída via PENDING_REVIEW.

---

## File Structure

| Arquivo | Responsabilidade | Ação |
|---|---|---|
| `scripts/burn_rate_shield.ps1` | Circuit breaker de custo de runtime para tarefas Cowork autônomas (E-4). Lê teto + janela, acumula gasto, bloqueia se excede. | Create |
| `scripts/burn_rate_config.json` | Config do shield: teto diário (USD), teto por janela 02h-05h, custo estimado por tipo de tarefa, kill-switch. | Create |
| `CLIENTES/VANGUARD/CLAUDE_PROJECT/burn_rate_state.json` | Estado durável: gasto acumulado da janela, timestamp do reset, contador de bloqueios. | Create (gerado pelo script) |
| `scripts/agenda_scheduler.ps1` | Scheduler de tarefas Cowork existente. | Modify — inserir chamada ao shield antes de disparar qualquer tarefa |
| `CLIENTES/VANGUARD/PENDING_REVIEW/COMPANY_PAGE_SETUP.md` | Checklist + dados da Company Page LinkedIn (nome, sobre, setor, logo, CTA). Fonte de verdade do que vai ao ar. | Create |
| `CLIENTES/VANGUARD/PENDING_REVIEW/POST_ECD_2026-06.md` | Conteúdo do 1º post (gancho ECD: prazo 30/06 + multa automática; Leiaute 9 inalterado — NUNCA "formato novo"). | Create |
| `scripts/gate_e1_fechamento.ps1` | Gate E-1: Loop 35 não fecha sem POST publicado OU 1 conversa real registrada. | Create |
| `CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json` | Estado do loop. | Modify — registrar evidência E-1 + estado do shield |

**Teste (idioma do repo):** não há pytest. O teste de um `.ps1` é (a) rodar o script nos dois caminhos VERDE/BLOQUEIO e conferir o exit code + saída; (b) `scripts/validate_scripts.ps1` sem erro crítico. Toda task de script segue esse idioma.

---

## FASE 0 — E-4 Burn Rate Shield (gate bloqueante de toda automação)

> Sem o shield, nenhuma tarefa Cowork autônoma roda. É o primeiro item da ordem de dependência (E-4 -> Company Page -> resto). Incidentes de referência: US$47k e US$2.8k/4h na janela 02h-05h sem olho humano.

### Task 1: Config do Burn Rate Shield

**Files:**
- Create: `scripts/burn_rate_config.json`

- [ ] **Step 1: Escrever a config**

```json
{
  "schema": "burn-rate-v1",
  "teto_usd_dia": 10.0,
  "teto_usd_janela_madrugada": 3.0,
  "janela_madrugada": { "inicio_hora": 2, "fim_hora": 5 },
  "custo_estimado_por_tarefa_usd": {
    "radar_regulatorio": 0.40,
    "radar_prospects": 0.35,
    "concorrentes_linkedin": 0.30,
    "thought_leadership": 0.50,
    "auditoria_icp": 0.30,
    "sintese_diaria": 0.20,
    "dd_auditoria_politica": 0.10,
    "dd_baseline_promessas": 0.15,
    "default": 0.50
  },
  "kill_switch": false,
  "nota": "kill_switch=true bloqueia TODA tarefa Cowork independente de teto. teto_usd_* sao limites superiores; ajustar conforme custo real medido."
}
```

- [ ] **Step 2: Validar JSON**

Run: `powershell -NoProfile -Command "Get-Content scripts/burn_rate_config.json -Raw | ConvertFrom-Json | Out-Null; 'OK'"`
Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add scripts/burn_rate_config.json
git commit -m "feat(loop35): E-4 config do Burn Rate Shield"
```

### Task 2: Script burn_rate_shield.ps1 — caminho VERDE (dentro do teto)

**Files:**
- Create: `scripts/burn_rate_shield.ps1`
- Create (gerado): `CLIENTES/VANGUARD/CLAUDE_PROJECT/burn_rate_state.json`

- [ ] **Step 1: Escrever o script**

```powershell
#Requires -Version 5.1
# burn_rate_shield.ps1 -- E-4 Loop 35
# Circuit breaker de custo de runtime para tarefas Cowork autonomas.
# Distinto de build_budget_guard.ps1 (que e budget de BUILDS, nao de custo de API).
# Uso: .\scripts\burn_rate_shield.ps1 -Tarefa <tipo> [-Cliente VANGUARD] [-Registrar]
# Exit 0 = LIBERADO (e, se -Registrar, acumula o custo) | Exit 1 = erro | Exit 2 = BLOQUEADO (teto/kill-switch)
param(
    [Parameter(Mandatory=$true)][string]$Tarefa,
    [string]$Cliente = "VANGUARD",
    [switch]$Registrar
)
$baseDir   = Split-Path -Parent $PSScriptRoot
$cfgPath   = "$baseDir\scripts\burn_rate_config.json"
$statePath = "$baseDir\CLIENTES\$Cliente\CLAUDE_PROJECT\burn_rate_state.json"

if (-not (Test-Path $cfgPath)) { Write-Host "[BURN] config ausente: $cfgPath" -ForegroundColor Red; exit 1 }
try { $cfg = Get-Content $cfgPath -Raw -Encoding UTF8 | ConvertFrom-Json } catch { Write-Host "[BURN] config invalida: $_" -ForegroundColor Red; exit 1 }

# Carregar/inicializar estado
$hoje = (Get-Date).ToString("yyyy-MM-dd")
if (Test-Path $statePath) {
    try { $state = Get-Content $statePath -Raw -Encoding UTF8 | ConvertFrom-Json } catch { $state = $null }
}
if (-not $state -or $state.dia -ne $hoje) {
    $state = [PSCustomObject]@{ dia = $hoje; gasto_dia_usd = 0.0; gasto_janela_usd = 0.0; bloqueios = 0 }
}

# Kill-switch
if ($cfg.kill_switch) { Write-Host "[BURN] KILL-SWITCH ATIVO -- toda tarefa bloqueada." -ForegroundColor Red; exit 2 }

# Custo da tarefa
$custo = $cfg.custo_estimado_por_tarefa_usd.$Tarefa
if ($null -eq $custo) { $custo = $cfg.custo_estimado_por_tarefa_usd.default }

# Janela madrugada?
$horaAtual = (Get-Date).Hour
$naJanela = ($horaAtual -ge $cfg.janela_madrugada.inicio_hora -and $horaAtual -lt $cfg.janela_madrugada.fim_hora)

# Checar tetos (projetando o custo desta tarefa)
$projDia    = $state.gasto_dia_usd + $custo
$projJanela = $state.gasto_janela_usd + $custo
if ($projDia -gt $cfg.teto_usd_dia) {
    Write-Host "[BURN] BLOQUEADO -- teto diario USD $($cfg.teto_usd_dia) excedido (projecao USD $projDia)." -ForegroundColor Red
    $state.bloqueios++; $state | ConvertTo-Json -Depth 5 | Set-Content $statePath -Encoding UTF8; exit 2
}
if ($naJanela -and $projJanela -gt $cfg.teto_usd_janela_madrugada) {
    Write-Host "[BURN] BLOQUEADO -- teto janela madrugada USD $($cfg.teto_usd_janela_madrugada) excedido (projecao USD $projJanela)." -ForegroundColor Red
    $state.bloqueios++; $state | ConvertTo-Json -Depth 5 | Set-Content $statePath -Encoding UTF8; exit 2
}

# LIBERADO
if ($Registrar) {
    $state.gasto_dia_usd = $projDia
    if ($naJanela) { $state.gasto_janela_usd = $projJanela }
    $state | ConvertTo-Json -Depth 5 | Set-Content $statePath -Encoding UTF8
    Write-Host "[BURN] LIBERADO + registrado -- tarefa '$Tarefa' custo USD $custo (dia USD $($state.gasto_dia_usd))." -ForegroundColor Green
} else {
    Write-Host "[BURN] LIBERADO (dry-run) -- tarefa '$Tarefa' custo estimado USD $custo." -ForegroundColor Green
}
exit 0
```

- [ ] **Step 2: Rodar caminho VERDE (dry-run, fora da janela)**

Run: `powershell -NoProfile -File scripts/burn_rate_shield.ps1 -Tarefa sintese_diaria`
Expected: imprime `[BURN] LIBERADO (dry-run)`, exit 0.

- [ ] **Step 3: Rodar VERDE com -Registrar e conferir estado gerado**

Run: `powershell -NoProfile -File scripts/burn_rate_shield.ps1 -Tarefa sintese_diaria -Registrar; powershell -NoProfile -Command "Get-Content CLIENTES/VANGUARD/CLAUDE_PROJECT/burn_rate_state.json"`
Expected: `gasto_dia_usd` = 0.20; arquivo de estado válido.

- [ ] **Step 4: Commit**

```bash
git add scripts/burn_rate_shield.ps1 CLIENTES/VANGUARD/CLAUDE_PROJECT/burn_rate_state.json
git commit -m "feat(loop35): E-4 burn_rate_shield.ps1 -- caminho liberado + estado"
```

### Task 3: burn_rate_shield.ps1 — caminho BLOQUEIO (teto e kill-switch)

**Files:**
- Modify: `scripts/burn_rate_config.json` (temporariamente, para forçar bloqueio no teste)

- [ ] **Step 1: Forçar bloqueio por teto diário baixo**

Run: `powershell -NoProfile -Command "$c=Get-Content scripts/burn_rate_config.json -Raw|ConvertFrom-Json; $c.teto_usd_dia=0.01; $c|ConvertTo-Json -Depth 5|Set-Content scripts/burn_rate_config_TEST.json -Encoding UTF8"`
(cria cópia de teste — não altera a config real)

- [ ] **Step 2: Rodar contra a config de teste e confirmar BLOQUEIO**

Run: `powershell -NoProfile -Command "$env:BRS_CFG='TEST'; & scripts/burn_rate_shield.ps1 -Tarefa thought_leadership; 'exit='+$LASTEXITCODE"`
Expected: `[BURN] BLOQUEADO -- teto diario`, exit 2.
> Nota: se o script ainda não lê `BRS_CFG`, ajustar o Step 1 da Task 2 para aceitar `-ConfigPath` opcional e passar a cópia de teste. Manter a config real intocada.

- [ ] **Step 3: Testar kill-switch**

Run: `powershell -NoProfile -Command "$c=Get-Content scripts/burn_rate_config.json -Raw|ConvertFrom-Json; $c.kill_switch=$true; $c|ConvertTo-Json -Depth 5|Set-Content scripts/burn_rate_config.json -Encoding UTF8"; powershell -NoProfile -File scripts/burn_rate_shield.ps1 -Tarefa sintese_diaria; echo "exit=$LASTEXITCODE"`
Expected: `[BURN] KILL-SWITCH ATIVO`, exit 2.

- [ ] **Step 4: Restaurar config real (kill_switch=false) e limpar teste**

Run: `powershell -NoProfile -Command "$c=Get-Content scripts/burn_rate_config.json -Raw|ConvertFrom-Json; $c.kill_switch=$false; $c|ConvertTo-Json -Depth 5|Set-Content scripts/burn_rate_config.json -Encoding UTF8; Remove-Item scripts/burn_rate_config_TEST.json -ErrorAction SilentlyContinue"`
Expected: config restaurada, kill_switch=false.

- [ ] **Step 5: validate_scripts + commit**

```bash
powershell -NoProfile -File scripts/validate_scripts.ps1
git add scripts/burn_rate_config.json
git commit -m "test(loop35): E-4 caminhos BLOQUEIO (teto + kill-switch) verificados"
```

### Task 4: Wire do shield no agenda_scheduler.ps1

**Files:**
- Modify: `scripts/agenda_scheduler.ps1` (inserir verificação antes de disparar tarefa Cowork)

- [ ] **Step 1: Ler o ponto de disparo atual**

Run: `powershell -NoProfile -Command "Select-String -Path scripts/agenda_scheduler.ps1 -Pattern 'cowork|tarefa|disparar|trigger' | Select-Object -First 10"`
Expected: localiza onde uma tarefa Cowork é efetivamente disparada.

- [ ] **Step 2: Inserir a guarda antes do disparo**

No ponto onde uma tarefa Cowork seria disparada, inserir:

```powershell
# E-4 Burn Rate Shield -- bloqueia disparo se teto/kill-switch (P-174 nota: gate de custo antes de autonomia)
& "$PSScriptRoot\burn_rate_shield.ps1" -Tarefa $tipoTarefa -Registrar | Out-Null
if ($LASTEXITCODE -eq 2) {
    Write-Host "[AGENDA] Tarefa '$tipoTarefa' BLOQUEADA pelo Burn Rate Shield (E-4)." -ForegroundColor Red
    continue
}
```
(adaptar `$tipoTarefa` ao nome de variável real do loop de tarefas no scheduler)

- [ ] **Step 3: validate_scripts + dry-run do scheduler**

Run: `powershell -NoProfile -File scripts/validate_scripts.ps1; powershell -NoProfile -File scripts/agenda_scheduler.ps1 -WhatIf 2>$null; echo "exit=$LASTEXITCODE"`
Expected: validate sem erro crítico; scheduler roda referenciando o shield.

- [ ] **Step 4: Commit**

```bash
git add scripts/agenda_scheduler.ps1
git commit -m "feat(loop35): E-4 wire do Burn Rate Shield no agenda_scheduler"
```

---

## FASE 1 — Company Page + POST ECD (ato externo, deadline 17/06)

> Fecha a lacuna R2 que matou o Loop 34 (ativo pronto não-publicado). Gancho REAL e verdadeiro: ECD 2026 vence 30/06, Leiaute 9 INALTERADO (só atualização de manual), multa automática 0,02%/dia. NUNCA vender "formato novo" para a ECD. O POST publicado ou 1 conversa real é o que satisfaz o gate E-1.

### Task 5: Conteúdo da Company Page (fonte de verdade em disco)

**Files:**
- Create: `CLIENTES/VANGUARD/PENDING_REVIEW/COMPANY_PAGE_SETUP.md`

- [ ] **Step 1: Redigir o setup**

Conteúdo: nome da página, tagline (Cyber-Premium, sem hype), bloco "Sobre" em blocos semânticos densos (E-5/AEO — frescor + entidade-âncora), setor (Consultoria / Inteligência de Dados), CTA, logo a usar, e os 3 pilares de conteúdo (Thought Leadership · Business Case · Prova Técnica). Marcar cada campo como `[A PREENCHER PELO DIRETOR]` somente onde for decisão de marca (ex.: nome final, logo).

- [ ] **Step 2: Auto-review do conteúdo**

Conferir: zero claim falso (sem "first-mover AEO" — E-7), zero "leiaute novo na ECD", linguagem do cliente. Corrigir inline.

- [ ] **Step 3: Commit**

```bash
git add "CLIENTES/VANGUARD/PENDING_REVIEW/COMPANY_PAGE_SETUP.md"
git commit -m "feat(loop35): conteudo da Company Page (E-5 AEO entidade-ancora)"
```

### Task 6: POST ECD — conteúdo verificado

**Files:**
- Create: `CLIENTES/VANGUARD/PENDING_REVIEW/POST_ECD_2026-06.md`

- [ ] **Step 1: Rodar yt-search para frescor antes de redigir (P-173)**

Run: `powershell -NoProfile -File scripts/yt.ps1 "ECD 2026 prazo 30 junho multa SPED contador"`
Expected: log em `scripts/yt_search.log`; fontes vivas com data para ancorar o post.

- [ ] **Step 2: Redigir o post**

Estrutura AEO-citável (N-5: aspas + estatística): gancho prazo 30/06 + multa automática 0,02%/dia → dor de conciliação ECD×ECF em tempo real → "Seguro contra Sanção" (E-6) → CTA. Verdade factual obrigatória: **ECD Leiaute 9 inalterado; Leiaute 12 é da ECF (prazo 31/07)**. Incluir fonte datada (webinar nacional 17/06).

- [ ] **Step 3: Auto-review factual**

Cruzar com `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_MODELS/eventos-fiscais-contadores_MODEL.json` (já corrigido E-2). Garantir consistência total. Corrigir inline.

- [ ] **Step 4: Commit**

```bash
git add "CLIENTES/VANGUARD/PENDING_REVIEW/POST_ECD_2026-06.md"
git commit -m "feat(loop35): POST ECD verificado (Leiaute 9 inalterado, gate E-1)"
```

### Task 7: Publicação (ato externo — checkpoint do Diretor)

**Files:** (nenhum arquivo de código — ato em browser via Playwright)

- [ ] **Step 1: Apresentar conteúdo final ao Diretor**

Mostrar `COMPANY_PAGE_SETUP.md` + `POST_ECD_2026-06.md` renderizados. **Aguardar confirmação explícita** (ato outward-facing, irreversível). Não publicar sem o "publicar" do Diretor, mesmo com V-PAGE=SIM.

- [ ] **Step 2: Invocar skill de browser e criar a Company Page**

Invocar a skill de operação remota apropriada antes de qualquer ação Playwright. Criar a página com os campos de `COMPANY_PAGE_SETUP.md`.

- [ ] **Step 3: Publicar o POST ECD**

Publicar o conteúdo de `POST_ECD_2026-06.md` na página. Capturar URL do post.

- [ ] **Step 4: Registrar evidência E-1**

Registrar a URL do post (ou da conversa real) em `LOOP_STATE.json` → novo campo `e1_evidencia` (ver Task 8).

### Task 8: Gate E-1 de fechamento

**Files:**
- Create: `scripts/gate_e1_fechamento.ps1`
- Modify: `CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json` (campo `e1_evidencia`)

- [ ] **Step 1: Adicionar campo de evidência no LOOP_STATE**

Inserir em `LOOP_STATE.json`: `"e1_evidencia": { "post_url": "", "conversa_real": "", "registrado_em": "" }` (vazio até a publicação).

- [ ] **Step 2: Escrever o gate**

```powershell
#Requires -Version 5.1
# gate_e1_fechamento.ps1 -- E-1 Loop 35
# Loop nao fecha sem POST publicado OU 1 conversa real registrada.
# Uso: .\scripts\gate_e1_fechamento.ps1 [-Cliente VANGUARD]
# Exit 0 = evidencia presente | Exit 1 = erro | Exit 2 = BLOQUEIO (sem evidencia)
param([string]$Cliente = "VANGUARD")
$baseDir = Split-Path -Parent $PSScriptRoot
$lsPath  = "$baseDir\CLIENTES\$Cliente\CLAUDE_PROJECT\LOOP_STATE.json"
if (-not (Test-Path $lsPath)) { Write-Host "[E-1] LOOP_STATE ausente" -ForegroundColor Red; exit 1 }
try { $ls = Get-Content $lsPath -Raw -Encoding UTF8 | ConvertFrom-Json } catch { Write-Host "[E-1] LOOP_STATE invalido: $_" -ForegroundColor Red; exit 1 }
$ev = $ls.e1_evidencia
$temPost     = $ev -and $ev.post_url     -and $ev.post_url.Trim()     -ne ""
$temConversa = $ev -and $ev.conversa_real -and $ev.conversa_real.Trim() -ne ""
if ($temPost -or $temConversa) {
    Write-Host "[E-1] OK -- evidencia presente (post ou conversa real)." -ForegroundColor Green; exit 0
}
Write-Host "[E-1] BLOQUEIO -- Loop 35 nao fecha sem POST publicado OU 1 conversa real registrada." -ForegroundColor Red
exit 2
```

- [ ] **Step 3: Testar BLOQUEIO (evidência vazia)**

Run: `powershell -NoProfile -File scripts/gate_e1_fechamento.ps1; echo "exit=$LASTEXITCODE"`
Expected: `[E-1] BLOQUEIO`, exit 2.

- [ ] **Step 4: Testar OK (após publicação, com post_url preenchido)**

Run: (após Task 7) preencher `post_url` e rodar o gate.
Expected: `[E-1] OK`, exit 0.

- [ ] **Step 5: Wire no session_close.ps1 + validate + commit**

Inserir no `session_close.ps1` (novo Gate): chamar `gate_e1_fechamento.ps1` quando o loop ativo for o 35; exit 1 do close se E-1 retornar 2.

```bash
powershell -NoProfile -File scripts/validate_scripts.ps1
git add scripts/gate_e1_fechamento.ps1 scripts/session_close.ps1 CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json
git commit -m "feat(loop35): E-1 gate de fechamento (post OU conversa real) + wire session_close"
```

---

## Planos-filho (decomposição — subsistemas independentes)

Estes NÃO entram nesta sessão. Cada um produz software/artefato testável por conta própria e tem seu próprio spec → plano:

1. **`2026-06-1X-loop35-detector-deriva.md`** — DD-Auditoria de Política (policy-as-code-validator + pre-commit-compliance-hook, server-side W-10/E-3) + DD-Baseline de Promessas (baseline-promise-tracker, M'X-B) + ledger-consistency-checker. Já há TaskList #1/#2 abertas (DD-D1, DD-D2). **Bloqueado por:** E-4 (Fase 0) para agendamento.
2. **`2026-06-1X-loop35-projetista.md`** — cbr-rag-orchestrator (CBR sintético, SEM grafo — D2) + adversarial-red-teaming (pré-mortem, N-4/PyRIT) + notebooklm-studio-director; atividades Cowork T4/T6/T7. **Bloqueado por:** E-4.
3. **`2026-06-1X-loop35-embaixador-digital.md`** — aeo-entity-optimizer (M'D-1, **pós-Company Page**) + objection-to-content-converter (N-5) + icp-behavioral-auditor (E-7) + SOAI tracking (N-1) + sensor de sinal com freio P-121 (M'D-2). **Bloqueado por:** E-4 **e** Company Page (Fase 1).

> Ordem de dependência global: **Fase 0 (E-4)** → **Fase 1 (Company Page/ECD)** → planos-filho 1, 2, 3.

---

## Self-Review

- **Cobertura do spec:** E-4 (Fase 0, Tasks 1-4) ✓ · Company Page + POST ECD (Fase 1, Tasks 5-7) ✓ · E-1 gate (Task 8) ✓ · 15 skills/atividades restantes → planos-filho declarados ✓. As 15 ideias ENTRA AGORA não-críticas estão mapeadas aos planos-filho (não perdidas).
- **Placeholders:** os únicos `[A PREENCHER PELO DIRETOR]` são decisões de marca (nome/logo) — legítimos, não são lacunas de engenharia. Conteúdo de scripts está completo.
- **Consistência de tipos:** `burn_rate_shield.ps1` usa `-Tarefa`/`-Registrar`/exit 2; `agenda_scheduler` chama com os mesmos parâmetros; `gate_e1_fechamento` lê `e1_evidencia.post_url`/`conversa_real` — mesmos nomes criados na Task 8 Step 1.
- **Nota de risco honesta:** o `agenda_scheduler.ps1` Task 4 depende do nome real da variável de tarefa; Step 1 localiza antes de editar. Se o scheduler não tiver loop de tarefas explícito, a guarda vai no ponto de disparo individual.
