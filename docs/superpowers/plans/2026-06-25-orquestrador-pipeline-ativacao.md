# Orquestrador de Pipeline por Estágio + Calendário — Plano de Implementação

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir um orquestrador automático que, em todo dia do calendário, leia o ESTÁGIO de cada produto do funil (Cowork → Projetista → Embaixador Digital) e traga ao Diretor a ação pronta — comando já preenchido com a última saída do ator —, sem depender da memória do Músculo.

**Architecture:** Uma máquina de estados em disco (`PIPELINE_STATE.json`) é a fonte única da verdade sobre o estágio de cada produto. Um script read-only (`pipeline_orquestrador.ps1`) cruza esse estado com a grade (`comandos_ativacao_atores.json`) e a data, preenche o template do comando com o que existe em disco (marcando `[AGUARDA]` o que não existe — nunca inventa), respeita produtos RETIDOS, e detecta deriva (produto novo em disco fora do estado). Pluga no `session_start.ps1` (PASSO 0C) — gatilho que já dispara em toda abertura — e é provado por simulação de datas, igual fizemos no W-12.

**Tech Stack:** PowerShell 5.1 (padrão da casa: `param([string]$Data, [switch]$Json)`, `ConvertFrom-Json -Encoding UTF8`, `[datetime]::ParseExact`, fail-safe `exit 0`). JSON de estado. Hook `session_start.ps1`. ASCII-safe no console (sem emoji/acento nos scripts).

**Princípios travados:**
- **GATE DE PAPEL (item 42):** o orquestrador rastreia ESTÁGIO mecânico — nunca decide/classifica/prioriza nicho. Não pontua, não elege. A decisão de avançar S2→S3 (Portão 1) e S2b→S3 (base legal) é veredito do Diretor.
- **Mandato 8 / GATE DE FATO:** placeholder sem fonte em disco vira `[AGUARDA: <o que falta>]`, jamais um número/dado inventado.
- **P-124:** o orquestrador é read-only sobre o canônico. Detecta deriva e ALERTA; nunca escreve sozinho em PENDING_REVIEW/WIP/DECISOES.
- **Fail-safe:** qualquer erro → não trava o `session_start` (padrão `ativacoes_do_dia.ps1`).

---

## File Structure

- **Create:** `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PIPELINE_STATE.json` — estado (fonte da verdade do estágio de cada produto).
- **Create:** `scripts/pipeline_orquestrador.ps1` — núcleo: lê estado + grade + data → ação do dia por produto (humano + `-Json`).
- **Create:** `scripts/test_orquestrador.ps1` — runner de simulação de datas (prova sem erros).
- **Create (pasta):** `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PROJETISTA/INBOX/` — destino estruturado do acúmulo Cowork (pré-requisito planejado e ausente).
- **Modify:** `.claude/hooks/session_start.ps1:974-987` — adicionar 1 bloco que invoca o orquestrador (mesmo padrão de `ativacoes_do_dia.ps1`).

---

## Task 1: Pré-requisito — pasta PROJETISTA/INBOX/

**Files:**
- Create: `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PROJETISTA/INBOX/.gitkeep`

- [ ] **Step 1: Criar a pasta-destino do acúmulo Cowork**

A grade (`comandos_ativacao_atores.json`) referencia `PROJETISTA/INBOX` como destino das frentes P-T3/P-T4, mas a pasta não existe em disco. Criar com um `.gitkeep` (conteúdo: linha única `# destino do acumulo Cowork para o Projetista (frentes P-T3/P-T4)`).

- [ ] **Step 2: Verificar**

Run: `Test-Path "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PROJETISTA\INBOX"`
Expected: `True`

- [ ] **Step 3: Commit**

```bash
git add "PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PROJETISTA/INBOX/.gitkeep"
git commit -m "chore(pipeline): cria PROJETISTA/INBOX -- destino do acumulo Cowork [RESOLVE: projetista-inbox]"
```

---

## Task 2: PIPELINE_STATE.json — a fonte única da verdade

**Files:**
- Create: `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PIPELINE_STATE.json`

**Estágios (mecânicos):** `S0_ACUMULANDO` → `S1_PROJETADO` → `S2_CAMPANHA_PRONTA` → `S3_LIBERADO` → `S4_EM_PROSPECCAO` → `S5_CAMPO` → `S6_RETROALIMENTADO`. Ramo lateral: `S2b_RETIDO` (não avança até a pré-condição ser liberada por veredito do Diretor).

- [ ] **Step 1: Escrever o estado com os 2 produtos reais (confirmados em disco)**

```json
{
  "_doc": "Maquina de estados do pipeline Vanguard (Cowork -> Projetista -> Embaixador Digital). Fonte UNICA da verdade do ESTAGIO de cada produto. NAO decide nicho (GATE DE PAPEL item 42) -- so rastreia estagio mecanico. Avanco S2->S3 e S2b->S3 exige veredito do Diretor.",
  "_estagios": ["S0_ACUMULANDO","S1_PROJETADO","S2_CAMPANHA_PRONTA","S2b_RETIDO","S3_LIBERADO","S4_EM_PROSPECCAO","S5_CAMPO","S6_RETROALIMENTADO"],
  "_atualizado": "2026-06-25",
  "produtos": [
    {
      "id": "saude-digital-n18",
      "rotulo": "Saude Digital (N18)",
      "estagio": "S1_PROJETADO",
      "evidencia": "PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PROJETISTA/PLANOS/PLANO_EXECUCAO_N18_saude-digital_v1.md",
      "ultima_saida_ator": "projetista",
      "ultima_saida_data": "2026-06-23",
      "proxima_acao_ator": "projetista",
      "proxima_acao_comando": "materializacao",
      "retido_motivo": null
    },
    {
      "id": "compliance-aduaneiro-ncm",
      "rotulo": "Compliance Aduaneiro NCM",
      "estagio": "S2b_RETIDO",
      "evidencia": "PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PROJETISTA/CAMPANHA/compliance-aduaneiro-ncm_CAMPANHA_v1.md",
      "ultima_saida_ator": "projetista",
      "ultima_saida_data": "2026-06-19",
      "proxima_acao_ator": "embaixador_digital",
      "proxima_acao_comando": "campanha",
      "retido_motivo": "Base legal LC 227/2026 (R$20.000/erro + rejeicao automatica NF SEFAZ) a confirmar com fonte juridica citavel antes do disparo ao Embaixador Digital."
    }
  ]
}
```

- [ ] **Step 2: Validar JSON**

Run: `Get-Content "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PIPELINE_STATE.json" -Raw -Encoding UTF8 | ConvertFrom-Json | Out-Null; $?`
Expected: `True` (sem exceção de parse)

- [ ] **Step 3: Validar que cada `evidencia` existe em disco**

```powershell
$s = Get-Content "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PIPELINE_STATE.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$s.produtos | ForEach-Object { "{0}: {1}" -f $_.id, (Test-Path $_.evidencia) }
```
Expected: ambas as linhas terminam em `True`.

- [ ] **Step 4: Commit**

```bash
git add "PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PIPELINE_STATE.json"
git commit -m "feat(pipeline): PIPELINE_STATE.json -- fonte unica do estagio de cada produto [RESOLVE: pipeline-state]"
```

---

## Task 3: pipeline_orquestrador.ps1 — núcleo (comando contextualizado por produto)

**Files:**
- Create: `scripts/pipeline_orquestrador.ps1`

- [ ] **Step 1: Escrever o script completo**

```powershell
#Requires -Version 5.1
# pipeline_orquestrador.ps1 -- Orquestrador de Pipeline por Estagio + Calendario.
# Le PIPELINE_STATE.json (estagio de cada produto) + comandos_ativacao_atores.json (grade)
# e, para a DATA de hoje (ou -Data), monta a ACAO DO DIA por produto com o comando JA PREENCHIDO
# (placeholder sem fonte em disco vira [AGUARDA: ...] -- Mandato 8, nunca inventa).
# GATE DE PAPEL (item 42): rastreia ESTAGIO mecanico, NAO decide/classifica nicho.
# P-124: read-only sobre o canonico. Detecta deriva e ALERTA; nunca escreve.
# FAIL-SAFE: qualquer erro -> exit 0 sem saida (nunca trava o session_start).
#
# Uso:
#   .\scripts\pipeline_orquestrador.ps1                 # saida humana para hoje
#   .\scripts\pipeline_orquestrador.ps1 -Data 2026-06-26
#   .\scripts\pipeline_orquestrador.ps1 -Json           # saida JSON

param(
    [string]$Data = "",
    [switch]$Json
)

try {
    if ($Data -ne "") {
        try { $hoje = [datetime]::ParseExact($Data, "yyyy-MM-dd", $null) }
        catch { if ($Json) { Write-Output "{}" }; exit 0 }
    } else {
        $hoje = Get-Date
    }
    $diaSemana = $hoje.DayOfWeek.ToString()   # Monday..Sunday
    $dataFmt   = $hoje.ToString("dd-MM-yyyy")

    $raiz      = Split-Path $PSScriptRoot -Parent
    $statePath = Join-Path $raiz "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PIPELINE_STATE.json"
    $gradePath = Join-Path $PSScriptRoot "comandos_ativacao_atores.json"

    if (-not (Test-Path $statePath) -or -not (Test-Path $gradePath)) { if ($Json) { Write-Output "{}" }; exit 0 }

    $state = Get-Content -LiteralPath $statePath -Raw -Encoding UTF8 | ConvertFrom-Json
    $grade = Get-Content -LiteralPath $gradePath -Raw -Encoding UTF8 | ConvertFrom-Json
    $agendaHoje = $grade.agenda_ativacao_manual.$diaSemana

    function Expand-Comando {
        param($template, $p)
        $t = $template
        # placeholders com fonte em disco
        $t = $t -replace '\[nicho\]',      $p.rotulo
        $t = $t -replace '\[nome/codigo\]', $p.rotulo
        $t = $t -replace '\[X\]',          $p.rotulo
        $t = $t -replace '\[referencia\]', $p.evidencia
        $t = $t -replace '\[data\]',       $p.ultima_saida_data
        # placeholders SEM fonte -> AGUARDA (Mandato 8: nunca inventar)
        $t = $t -replace '\[sinal\]',               '[AGUARDA: DELTA no _MODEL.json]'
        $t = $t -replace '\[N\]',                   '[AGUARDA: ciclos]'
        $t = $t -replace '\[quando\]',              '[AGUARDA: janela]'
        $t = $t -replace '\[LEVE/PADRAO/PESADA\]',  '[AGUARDA: tipo de deliberacao]'
        $t = $t -replace '\[deck / audio / infografico EAP / cards p/ Digital\]', '[AGUARDA: Diretor escolhe o formato]'
        $t = $t -replace '\[resultado de campanha\]', '[AGUARDA: resultado de campo do Embaixador Digital]'
        $t = $t -replace '\[tema\]',                '[AGUARDA: tema da lacuna]'
        return $t
    }

    $resultados = @()
    foreach ($p in $state.produtos) {
        $ator   = $p.proxima_acao_ator
        $cmdKey = $p.proxima_acao_comando

        $janelaFixa = $false
        if ($agendaHoje -and $agendaHoje.$ator -and (@($agendaHoje.$ator) -contains $cmdKey)) { $janelaFixa = $true }
        $sobGatilho = [bool]($grade.sob_gatilho.$ator.$cmdKey)

        # produto retido -> mostra o que falta, nao o comando
        if ($p.retido_motivo) {
            $resultados += [ordered]@{
                produto = $p.rotulo; estagio = $p.estagio; status = "RETIDO"
                falta = $p.retido_motivo; comando = $null
            }
            continue
        }

        $tpl = $grade.comandos_canonicos.$ator.$cmdKey.texto
        $cmd = if ($tpl) { Expand-Comando $tpl $p } else { $null }

        $status = if     ($janelaFixa) { "JANELA HOJE (grade fixa)" }
                  elseif ($sobGatilho) { "SOB GATILHO (seu portao -- decide o Diretor)" }
                  else                 { "AGUARDA JANELA" }

        $resultados += [ordered]@{
            produto = $p.rotulo; estagio = $p.estagio; status = $status
            ator = $ator; comando = $cmd
        }
    }

    # -- deteccao de deriva (read-only): produto em disco fora do estado --
    $deriva = @()
    $dirCamp = Join-Path $raiz "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PROJETISTA\CAMPANHA"
    $dirPlan = Join-Path $raiz "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\PROJETISTA\PLANOS"
    $rastreados = @($state.produtos | ForEach-Object { Split-Path $_.evidencia -Leaf })
    foreach ($dir in @($dirCamp, $dirPlan)) {
        if (Test-Path $dir) {
            Get-ChildItem -LiteralPath $dir -Filter *.md -File -ErrorAction SilentlyContinue | ForEach-Object {
                if ($rastreados -notcontains $_.Name) { $deriva += $_.Name }
            }
        }
    }

    if ($Json) {
        $obj = [ordered]@{ data = $hoje.ToString("yyyy-MM-dd"); dia_semana = $diaSemana; produtos = @($resultados); deriva = @($deriva) }
        Write-Output ($obj | ConvertTo-Json -Depth 8 -Compress)
        exit 0
    }

    Write-Host ""
    Write-Host "  PIPELINE -- ACAO DO DIA POR PRODUTO  -- $dataFmt ($diaSemana)"
    Write-Host "  ============================================================================"
    Write-Host "  Estagio em disco (PIPELINE_STATE.json). Portoes 1 e 2 continuam do Diretor."
    Write-Host ""
    foreach ($r in $resultados) {
        Write-Host ("  >> {0}  [{1}]  -- {2}" -f $r.produto, $r.estagio, $r.status)
        if ($r.status -eq "RETIDO") {
            Write-Host ("     RETIDO. Falta: {0}" -f $r.falta)
        } elseif ($r.comando) {
            foreach ($ln in ($r.comando -split "`n")) { Write-Host "       $ln" }
        }
        Write-Host ""
    }
    if ($deriva.Count -gt 0) {
        Write-Host "  [DERIVA] Produto(s) em disco FORA do PIPELINE_STATE -- confirmar avanco de estagio com o Diretor (P-124):"
        foreach ($d in $deriva) { Write-Host "     -> $d" }
        Write-Host ""
    }
    exit 0
} catch {
    if ($Json) { Write-Output "{}" }
    exit 0
}
```

- [ ] **Step 2: Rodar para HOJE (Quinta 25) e conferir saída humana**

Run: `.\scripts\pipeline_orquestrador.ps1`
Expected: lista `Saude Digital (N18) [S1_PROJETADO] -- SOB GATILHO ...` com comando de materialização preenchido (`Nicho: Saude Digital (N18)` + `Plano-base: ...PLANO_EXECUCAO_N18...`), e `Compliance Aduaneiro NCM [S2b_RETIDO] -- RETIDO. Falta: Base legal LC 227/2026 ...`.

- [ ] **Step 3: Rodar `-Json` e validar parse**

Run: `.\scripts\pipeline_orquestrador.ps1 -Json | ConvertFrom-Json | Out-Null; $?`
Expected: `True`

- [ ] **Step 4: Commit**

```bash
git add scripts/pipeline_orquestrador.ps1
git commit -m "feat(pipeline): orquestrador -- comando contextualizado por produto/estagio/data [RESOLVE: pipeline-orquestrador]"
```

---

## Task 4: test_orquestrador.ps1 — prova por simulação de datas

**Files:**
- Create: `scripts/test_orquestrador.ps1`

Valida o comportamento em datas-chave SEM esperar o dia chegar (igual às 7 datas do W-12). Cada caso é uma asserção sobre a saída `-Json`.

- [ ] **Step 1: Escrever o runner**

```powershell
#Requires -Version 5.1
# test_orquestrador.ps1 -- prova de datas do pipeline_orquestrador.ps1 (sem esperar o dia chegar).
$ErrorActionPreference = "Stop"
$orq = Join-Path $PSScriptRoot "pipeline_orquestrador.ps1"
$falhas = 0

function Assert-Contains($json, $needle, $label) {
    if ($json -like "*$needle*") { Write-Host "  PASS  $label" -ForegroundColor Green }
    else { Write-Host "  FAIL  $label (esperava conter: $needle)" -ForegroundColor Red; $script:falhas++ }
}

# Caso A -- Sexta 26-06: N18 sob gatilho com comando preenchido; compliance retido
$jA = (& powershell.exe -NonInteractive -File $orq -Data "2026-06-26" -Json)
Assert-Contains $jA "S1_PROJETADO"            "26-06: N18 em S1_PROJETADO"
Assert-Contains $jA "PLANO_EXECUCAO_N18"      "26-06: comando do N18 cita o plano-base (ultima saida)"
Assert-Contains $jA "S2b_RETIDO"              "26-06: compliance RETIDO"
Assert-Contains $jA "LC 227"                  "26-06: motivo da retencao presente"

# Caso B -- nunca inventa dado ausente
Assert-Contains $jA "AGUARDA"                 "26-06: placeholder sem fonte vira [AGUARDA], nao inventado"

# Caso C -- JSON sempre valido em qualquer data (Domingo)
$jC = (& powershell.exe -NonInteractive -File $orq -Data "2026-06-28" -Json)
try { $jC | ConvertFrom-Json | Out-Null; Write-Host "  PASS  28-06: JSON valido no domingo" -ForegroundColor Green }
catch { Write-Host "  FAIL  28-06: JSON invalido" -ForegroundColor Red; $falhas++ }

# Caso D -- data invalida nao quebra (fail-safe)
$jD = (& powershell.exe -NonInteractive -File $orq -Data "xx" -Json)
try { $jD | ConvertFrom-Json | Out-Null; Write-Host "  PASS  data invalida -> JSON vazio, sem crash" -ForegroundColor Green }
catch { Write-Host "  FAIL  data invalida quebrou" -ForegroundColor Red; $falhas++ }

Write-Host ""
if ($falhas -eq 0) { Write-Host "[VERDE] Todos os casos passaram." -ForegroundColor Green; exit 0 }
else { Write-Host "[VERMELHO] $falhas caso(s) falharam." -ForegroundColor Red; exit 1 }
```

- [ ] **Step 2: Rodar a prova**

Run: `.\scripts\test_orquestrador.ps1`
Expected: `[VERDE] Todos os casos passaram.` (exit 0)

- [ ] **Step 3: Commit**

```bash
git add scripts/test_orquestrador.ps1
git commit -m "test(pipeline): prova por simulacao de datas (dia 26 + fail-safe) [RESOLVE: pipeline-teste]"
```

---

## Task 5: Integração no session_start.ps1 (PASSO 0C) — o gatilho permanente

**Files:**
- Modify: `.claude/hooks/session_start.ps1` (após o bloco ATIVACOES MANUAIS DO DIA, linha ~987)

- [ ] **Step 1: Inserir o bloco do orquestrador**

Logo após o bloco que termina em `$sections = @("## 🔔 ATIVACOES MANUAIS DE HOJE ...") + $sections` (linha ~986-987), inserir:

```powershell
# PIPELINE -- ACAO DO DIA POR PRODUTO (orquestrador por estagio + calendario)
# Le PIPELINE_STATE.json e, para cada produto, traz o comando JA PREENCHIDO com a ultima
# saida do ator. Memoria fora do loop (Diretor 2026-06-25): o estado mora em disco, nao na cabeca.
$pipelineOutput = ""
$pipelineScript = Join-Path $projectDir "scripts\pipeline_orquestrador.ps1"
if (Test-Path $pipelineScript) {
    try {
        $plLines = (& powershell.exe -NonInteractive -File $pipelineScript 2>$null)
        if ($plLines) { $pipelineOutput = ($plLines | Where-Object { $_ -ne $null }) -join "`n" }
    } catch {}
}
if ($pipelineOutput) {
    $sections = @("## 🚦 PIPELINE -- ACAO DO DIA POR PRODUTO (Cowork -> Projetista -> Embaixador Digital)`n$pipelineOutput") + $sections
}
```

- [ ] **Step 2: Verificar sintaxe do hook (não pode quebrar a abertura)**

Run: `powershell.exe -NonInteractive -Command "& { $null = [ScriptBlock]::Create((Get-Content '.\.claude\hooks\session_start.ps1' -Raw)); 'OK-SINTAXE' }"`
Expected: `OK-SINTAXE`

- [ ] **Step 3: Simular a injeção rodando o script-alvo isolado (mesma chamada do hook)**

Run: `& powershell.exe -NonInteractive -File ".\scripts\pipeline_orquestrador.ps1"`
Expected: o bloco `PIPELINE -- ACAO DO DIA POR PRODUTO` com N18 e compliance.

- [ ] **Step 4: Commit**

```bash
git add .claude/hooks/session_start.ps1
git commit -m "feat(pipeline): session_start injeta a acao do dia por produto (gatilho permanente) [RESOLVE: pipeline-sessionstart]"
```

---

## Task 6: Prova final ao Diretor + registro de doutrina

**Files:**
- Modify: `INTELLIGENCE_LEDGER.md` (somente com a frase de autorização — P-098) **OU** registrar via memória, conforme veredito.

- [ ] **Step 1: Rodar a prova do dia 26 na frente do Diretor (hoje, dia 25)**

Run: `.\scripts\pipeline_orquestrador.ps1 -Data 2026-06-26`
Expected: a ordem do dia 26 já montada — N18 com comando de materialização preenchido + compliance retido com o motivo. Mostrar ao Diretor: "esta é a ordem que vai aparecer sozinha amanhã na abertura."

- [ ] **Step 2: Rodar a suíte completa**

Run: `.\scripts\test_orquestrador.ps1`
Expected: `[VERDE]`.

- [ ] **Step 3: (Após veredito do Diretor) registrar o princípio**

Princípio: *"O estágio do pipeline mora em disco (PIPELINE_STATE.json), nunca na memória do Músculo. O orquestrador traz a ação do dia por produto; o Músculo não decide nicho — só rastreia estágio."* Registrar no LEDGER (exige a frase literal de autorização P-098) ou como memória `reference_orquestrador_pipeline`, conforme o Diretor decidir.

- [ ] **Step 4: Sync universal (P-033) — houve mudança em PENTALATERAL_UNIVERSAL/**

Run: `.\.claude\skills\files\sync_vanguard_docs.ps1`
Expected: INTEGRIDADE VERDE.

---

## Self-Review

- **Spec coverage:** estado em disco (T2) · gerador contextualizado por produto (T3) · serve Projetista e Embaixador Digital via grade (T3, lê `agenda_ativacao_manual` + `sob_gatilho` de ambos) · percorre todo o calendário via `-Data`/`session_start` (T3+T5) · permanente/automático sem memória (T5 hook) · provado por simulação (T4) · GATE DE PAPEL e Mandato 8 respeitados (T3 `Expand-Comando` + RETIDO). Cobertura completa.
- **Placeholder scan:** sem TBD/TODO; todo código está completo e literal.
- **Type consistency:** campos do produto (`rotulo`, `evidencia`, `ultima_saida_data`, `proxima_acao_ator`, `proxima_acao_comando`, `retido_motivo`, `estagio`) idênticos entre T2 (JSON) e T3 (consumo). `Expand-Comando` usa exatamente esses nomes.
- **Risco residual:** `Expand-Comando` cobre os placeholders presentes nos templates atuais; um template novo com placeholder novo aparece literal — aceitável (visível, não inventado). Documentado.
