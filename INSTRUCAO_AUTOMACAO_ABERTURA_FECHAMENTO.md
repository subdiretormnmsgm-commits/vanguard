# INSTRUÇÃO FINAL — AUTOMAÇÃO ANCORADA EM ABERTURA E FECHAMENTO
## Tudo que precisa acontecer vive nesses dois eventos garantidos
> Data: 2026-05-29 (quinta-feira)
> Emitido por: Embaixador · Via: Diretor Eduardo
> Princípio: abertura e fechamento são os únicos eventos garantidos em qualquer sessão
> Tudo que depende de disciplina intermediária falha. Tudo ancorado nesses dois eventos é sistêmico.

---

## ARQUITETURA FINAL DO SISTEMA

```
ABERTURA (session_start.ps1)          FECHAMENTO (session_close.ps1)
─────────────────────────────         ──────────────────────────────
CONTEXTO:                             GATES 1-5 (já existem):
  LEMBRETE DE LOOP              ✅      auditoria → sync → propagate
  DECISOES bloqueante           ✅      ledger_sync → validate
  PENDENTES completo            ✅
  LEDGER + WIP injetados        ✅    GATE 6 (artefatos loop):
  MAPA DIÁRIO                   ✅      P-045 MEMORIA+relatorio     ✅
                                        AUDITOR_LOOP verificado      ← ADD
VERIFICAÇÕES:                           PASSO3 próximo loop gerado   ✅
  ChurnWatch ativo?             ✅
  MEMORIA_EMBAIXADOR existe?    ✅    GATE 7 (LOG):
  detect_canonical_violation    ✅      LEDGER atualizado            ✅
  Pendentes vencidos?           ✅      RELATO_FALHAS capturado      ← ADD
  Projeto PRE-QUALIFICACAO?     ✅      KNOWLEDGE_BASE verificado    ← ADD
  Commits recentes injetados    ← ADD   CANDIDATOS_A_PRINCIPIO       ← ADD

WATCHERS (background):               GATE 8 (comunicação):
  skill_watcher                 ✅      e-mail SMTP                  ✅
  decisoes_watcher              ✅      Telegram                     ✅
                                        COMANDO_ESTRATEGISTA atualiz ← ADD

                                     GATE 9 (PAINEL):
                                       PAINEL_ATIVIDADES             ✅
                                       MANIFESTO_DE_FONTES           ← ADD

                                     GATE 9.5 (alertas):
                                       Alertas de gargalo            ✅
                                       Countdown de gates            ✅
                                       Contador de loops (3 loops)   ← ADD
                                       Detector de build             ← ADD
                                       Trigger P-032                 ← ADD
                                       MASTER sincronia WIP_BOARD    ← ADD
```

---

## ADIÇÕES À ABERTURA (session_start.ps1)

### ADD-A1 — Commits recentes injetados no contexto

Item 0 do CLAUDE.md exige que o Músculo leia commits recentes.
Hoje é disciplina. Automatizar a injeção:

```powershell
# ── COMMITS RECENTES — injetar no contexto ───────────────
$ultimosCommits = git log --oneline -10 --format="%h %s (%ar)" 2>$null

if ($ultimosCommits) {
    $commitSection = "=== COMMITS RECENTES (ultimos 10) ===`n"
    $commitSection += $ultimosCommits -join "`n"
    $commitSection += "`n================================`n"
    $sections = @($commitSection) + $sections
}
# ─────────────────────────────────────────────────────────
```

Músculo vê os commits ao abrir — sabe o que mudou desde a última sessão
sem o Diretor precisar relatar.

---

## ADIÇÕES AO FECHAMENTO (session_close.ps1)

### ADD-F1 — Gate 6 ampliado: AUDITOR_LOOP verificado

Adicionar ao Gate 6 — após verificar P-045:

```powershell
# Verificar AUDITOR_LOOP por projeto ativo
foreach ($proj in $projetos) {
    $clienteLow  = $proj.ToLower()
    $loopAtual   = $wip.$proj.loop_fase_atual.loop
    $auditorPath = "CLIENTES\$proj\HISTORICO\AUDITOR_LOOP_V${loopAtual}_${clienteLow}.md"

    if (-not (Test-Path $auditorPath)) {
        Write-Host "  [!] $proj — AUDITOR_LOOP_V$loopAtual ausente (P-049)." -ForegroundColor Yellow
    } elseif (Select-String -Path $auditorPath -Pattern "\[colar aqui\]" -Quiet) {
        Write-Host "  [!] $proj — AUDITOR_LOOP_V$loopAtual tem placeholders — output nao salvo." -ForegroundColor Yellow
    } else {
        Write-Host "  [OK] $proj — AUDITOR_LOOP_V$loopAtual preenchido." -ForegroundColor Green
    }
}
```

---

### ADD-F2 — Gate 7 ampliado: KNOWLEDGE_BASE e CANDIDATOS_A_PRINCIPIO

Adicionar ao Gate 7 — após registrar no LEDGER:

```powershell
# P-050: verificar se problema resolvido foi documentado em KNOWLEDGE_BASE
$kbPath = "PENTALATERAL_UNIVERSAL\KNOWLEDGE_BASE\INDEX.md"
$kbModificado = (Get-Item $kbPath -ErrorAction SilentlyContinue)?.LastWriteTime

$hoje = [datetime]::Today
if (-not $kbModificado -or $kbModificado.Date -lt $hoje) {
    Write-Host ""
    Write-Host "  [P-050] Algum problema tecnico foi resolvido nesta sessao?" -ForegroundColor Yellow
    Write-Host "          Se sim — documentar em KNOWLEDGE_BASE/ antes de fechar."
    Write-Host "          Local: PENTALATERAL_UNIVERSAL\KNOWLEDGE_BASE\"

    $dataHoje  = Get-Date -Format "dd-MM-yyyy"
    $diaSemana = (Get-Date).ToString("dddd", `
        [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
    Add-Content "PENDENTES.md" `
        "- [P-050 ($dataHoje $diaSemana)] Verificar se problema resolvido foi documentado em KNOWLEDGE_BASE"
}

# CANDIDATOS_A_PRINCIPIO: verificar se há candidatos nao inscritos
$candidatos = Select-String -Path "PENDENTES.md" -Pattern "candidato.*princip|P-0\w\w.*candidato" -Quiet
if ($candidatos) {
    Write-Host ""
    Write-Host "  [LEDGER] Existem princípios candidatos nao inscritos em PENDENTES.md." -ForegroundColor Yellow
    Write-Host "           Inscrever no LEDGER com veredito do Diretor antes de fechar."
}
```

---

### ADD-F3 — Gate 8 ampliado: COMANDO_ESTRATEGISTA atualizado

Item 18 do CLAUDE.md: ao fechar sessão com novos princípios ou decisões,
incluir bloco "ATUALIZAÇÕES DO PROCESSO" no próximo COMANDO_ESTRATEGISTA.

Adicionar ao Gate 8 — após e-mail e Telegram:

```powershell
# Verificar se houve novos princípios inscritos nesta sessão
$novosPrincipios = git diff HEAD~1 HEAD -- "04_INTELLIGENCE_LEDGER.md" 2>$null |
    Select-String "^\+" |
    Where-Object { $_ -match "\[P-\d+\]" }

if ($novosPrincipios.Count -gt 0) {
    $masterPath = "PENTALATERAL_UNIVERSAL\OPERACAO\COMANDO_ESTRATEGISTA_MASTER_v1.md"

    Write-Host ""
    Write-Host "  [P-018] $($novosPrincipios.Count) princípio(s) novo(s) nesta sessao." -ForegroundColor Cyan
    Write-Host "          Adicionar bloco ATUALIZACOES DO PROCESSO ao COMANDO_ESTRATEGISTA."
    Write-Host "          Local: $masterPath"

    $dataHoje  = Get-Date -Format "dd-MM-yyyy"
    $diaSemana = (Get-Date).ToString("dddd", `
        [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
    Add-Content "PENDENTES.md" `
        "- [MASTER ($dataHoje $diaSemana)] Atualizar COMANDO_ESTRATEGISTA com $($novosPrincipios.Count) principio(s) novo(s)"
}
```

---

### ADD-F4 — Gate 9 ampliado: MANIFESTO_DE_FONTES atualizado

Adicionar ao Gate 9 — após PAINEL_ATIVIDADES:

```powershell
# Regenerar MANIFESTO_DE_FONTES para cada projeto ativo
foreach ($proj in $projetos) {
    $fontesPath    = "CLIENTES\$proj\NOTEBOOKLM_FONTES"
    $manifestoPath = "$fontesPath\00_MANIFESTO_DE_FONTES.md"

    if (Test-Path $fontesPath) {
        $arquivos = Get-ChildItem $fontesPath -File |
            Where-Object { $_.Name -ne "00_MANIFESTO_DE_FONTES.md" } |
            Sort-Object Name

        $linhas = @(
            "# MANIFESTO DE FONTES -- $proj",
            "# Atualizado automaticamente pelo session_close.ps1",
            "# Data: $(Get-Date -Format 'dd-MM-yyyy HH:mm')",
            "",
            "## FONTES ($($arquivos.Count) arquivos)"
        )
        foreach ($arq in $arquivos) {
            $linhas += "- $($arq.Name) | $($arq.LastWriteTime.ToString('dd-MM-yyyy')) | $([math]::Round($arq.Length/1KB,1))KB"
        }

        if ($arquivos.Count -gt 0) {
            $linhas += ""
            $linhas += "## PERIODO"
            $linhas += "De: $(($arquivos | Sort-Object LastWriteTime | Select-Object -First 1).LastWriteTime.ToString('dd-MM-yyyy'))"
            $linhas += "Ate: $(($arquivos | Sort-Object LastWriteTime | Select-Object -Last 1).LastWriteTime.ToString('dd-MM-yyyy'))"
        }

        $linhas | Out-File $manifestoPath -Encoding UTF8
        Write-Host "  [P-053] $proj — MANIFESTO_DE_FONTES atualizado ($($arquivos.Count) fontes)." -ForegroundColor Green
    }
}
```

---

### ADD-F5 — Gate 9.5 completo: todos os gatilhos persistentes

Consolidar no Gate 9.5 todos os gatilhos que dependem de persistência:

```powershell
# ── GATE 9.5 — GATILHOS PERSISTENTES ────────────────────
$wipPath  = "CLIENTES\WIP_BOARD.json"
$wip      = Get-Content $wipPath | ConvertFrom-Json
$dataHoje = Get-Date -Format "dd-MM-yyyy"
$diaSemana = (Get-Date).ToString("dddd", `
    [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))

# --- GATILHO 1: Contador de loops (3 loops → check-up sistêmico)
if (-not $wip.meta) {
    $wip | Add-Member -NotePropertyName "meta" -NotePropertyValue ([PSCustomObject]@{
        loops_desde_ultimo_checkup = 0
        data_ultimo_checkup        = $dataHoje
        checkup_recomendado        = $false
    }) -Force
}

$loopFechado = $false
foreach ($proj in $projetos) {
    $fase = $wip.$proj.loop_fase_atual
    if ($fase -and $fase.gemini -eq "OK" -and $fase.notebooklm -eq "OK" `
        -and $fase.embaixador -eq "OK" -and $fase.musculo -eq "OK") {
        $loopFechado = $true; break
    }
}

if ($loopFechado) {
    $wip.meta.loops_desde_ultimo_checkup++
    $total = $wip.meta.loops_desde_ultimo_checkup
    Write-Host "  [LOOP] $total loop(s) desde o ultimo check-up." -ForegroundColor Cyan

    if ($total -ge 3) {
        $wip.meta.checkup_recomendado = $true
        Write-Host ""
        Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Yellow
        Write-Host "    CHECK-UP SISTÊMICO RECOMENDADO ($total loops)" -ForegroundColor Yellow
        Write-Host "    PENTALATERAL_UNIVERSAL\OPERACAO\COMANDO_VERIFICACAO_SISTEMICA_FINAL.md" -ForegroundColor Yellow
        Write-Host "    Tempo: ~20 min | Responder ao Embaixador" -ForegroundColor Yellow
        Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Yellow
        $jaExiste = Select-String "PENDENTES.md" -Pattern "CHECK-UP SISTÊMICO" -Quiet 2>$null
        if (-not $jaExiste) {
            Add-Content "PENDENTES.md" `
                "- [CHECK-UP ($dataHoje $diaSemana)] COMANDO_VERIFICACAO_SISTEMICA_FINAL.md -- $total loops sem verificacao"
        }
    }
}

# --- GATILHO 2: Build significativo → TESTE_PROCESSO Bloco A
$arquivosCodigo = git log --since="$dataHoje 00:00" --name-only --pretty=format: 2>$null |
    Where-Object { $_ -match '\.(js|ts|html|css|jsx|tsx|py|sql)$' } |
    Where-Object { $_ -notmatch '^scripts/' }

if ($arquivosCodigo.Count -gt 0) {
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "    BUILD DETECTADO — $($arquivosCodigo.Count) arquivo(s) de codigo" -ForegroundColor Cyan
    Write-Host "    PENTALATERAL_UNIVERSAL\OPERACAO\TESTE_PROCESSO_COMPLETO.md" -ForegroundColor Cyan
    Write-Host "    Bloco A apenas — 5 min" -ForegroundColor Cyan
    Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
    $jaExiste = Select-String "PENDENTES.md" -Pattern "TESTE_PROCESSO.*$dataHoje" -Quiet 2>$null
    if (-not $jaExiste) {
        Add-Content "PENDENTES.md" `
            "- [BUILD ($dataHoje $diaSemana)] TESTE_PROCESSO_COMPLETO.md Bloco A -- build detectado"
    }
}

# --- GATILHO 3: Trigger P-032 (MEMORIA_EMBAIXADOR)
$vereditos = Get-ChildItem "CLIENTES\*\CLAUDE_PROJECT\DECISOES\VEREDITOS_*.json" `
    -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime.Date -eq [datetime]::Today }

if ($vereditos.Count -gt 0) {
    Write-Host ""
    Write-Host "  [P-032] Deliberacao executada hoje — atualizar MEMORIA_EMBAIXADOR." -ForegroundColor Cyan
    $jaExiste = Select-String "PENDENTES.md" -Pattern "P-032.*$dataHoje" -Quiet 2>$null
    if (-not $jaExiste) {
        Add-Content "PENDENTES.md" `
            "- [P-032 ($dataHoje $diaSemana)] Atualizar MEMORIA_EMBAIXADOR apos deliberacao de hoje"
    }
}

# --- GATILHO 4: MASTER sincronia com WIP_BOARD
$masterPath  = "PENTALATERAL_UNIVERSAL\OPERACAO\COMANDO_ESTRATEGISTA_MASTER_v1.md"
$wipModified = (Get-Item $wipPath).LastWriteTime
$masterMod   = (Get-Item $masterPath -ErrorAction SilentlyContinue)?.LastWriteTime

if ($masterMod -and $wipModified -gt $masterMod) {
    $deltaH = [int]($wipModified - $masterMod).TotalHours
    Write-Host "  [P-052] COMANDO_ESTRATEGISTA_MASTER desatualizado ($deltaH h)." -ForegroundColor Yellow
    $jaExiste = Select-String "PENDENTES.md" -Pattern "MASTER.*sincronia" -Quiet 2>$null
    if (-not $jaExiste) {
        Add-Content "PENDENTES.md" `
            "- [MASTER ($dataHoje $diaSemana)] Atualizar COMANDO_ESTRATEGISTA com mudancas do WIP_BOARD"
    }
}

# --- ALERTAS DE GARGALO (já existem — garantir que rodam aqui)
# ChurnWatch, PASSO3 placeholder, AUDITOR_LOOP, watcher, SOBERANA
# [manter código já implementado]

# --- COUNTDOWN DE GATES (já existe — garantir que roda aqui)
# [manter código já implementado]

# Salvar WIP_BOARD com contador atualizado
$wip | ConvertTo-Json -Depth 10 | Set-Content $wipPath -Encoding UTF8
Write-Host ""
Write-Host "  [GATE 9.5] Concluido." -ForegroundColor Green
# ─────────────────────────────────────────────────────────
```

---

## MAPA FINAL — ABERTURA E FECHAMENTO COMPLETOS

```
SESSION_START (abertura):
  ✅ LEMBRETE DE LOOP
  ✅ DECISOES bloqueante
  ✅ PENDENTES completo + vencidos
  ✅ LEDGER + WIP + MAPA DIÁRIO
  ✅ ChurnWatch + MEMORIA_EMBAIXADOR + detect_canonical
  ✅ skill_watcher + decisoes_watcher (background)
  ✅ Projeto PRE-QUALIFICACAO → aviso
  ← Commits recentes injetados (ADD-A1)

SESSION_CLOSE (fechamento):
  ✅ Gates 1-5 (auditoria, sync, propagate, ledger, validate)
  ✅ Gate 6: P-045 artefatos + PASSO3 próximo loop
  ← Gate 6+: AUDITOR_LOOP verificado (ADD-F1)
  ✅ Gate 7: LOG no LEDGER
  ← Gate 7+: KNOWLEDGE_BASE + CANDIDATOS (ADD-F2)
  ✅ Gate 8: e-mail SMTP + Telegram
  ← Gate 8+: COMANDO_ESTRATEGISTA atualizado (ADD-F3)
  ✅ Gate 9: PAINEL_ATIVIDADES
  ← Gate 9+: MANIFESTO_DE_FONTES (ADD-F4)
  ← Gate 9.5: todos os gatilhos persistentes (ADD-F5)
    ← Contador de loops → CHECK-UP a cada 3
    ← Detector de build → TESTE_PROCESSO Bloco A
    ← Trigger P-032 → MEMORIA_EMBAIXADOR
    ← MASTER sincronia → PENDENTES
    ✅ Alertas de gargalo (já existem)
    ✅ Countdown de gates (já existem)

AÇÕES HUMANAS INSUBSTITUÍVEIS (~4-6 min por loop):
  A1. Arrastar 4 arquivos ao Gemini
  A2. Salvar Skill em NOTEBOOKLM_DROP
  A3. Clicar nas opções do Painel
  A4. Upload do PAINEL ao Embaixador
```

---

## SEQUÊNCIA DE IMPLEMENTAÇÃO

```
[ ] 1. ADD-A1: commits recentes no session_start.ps1
       Testar: abrir sessão → ver commits dos últimos 10

[ ] 2. ADD-F1: AUDITOR_LOOP no Gate 6 do session_close.ps1
       Testar: AUDITOR ausente → alerta | preenchido → OK

[ ] 3. ADD-F2: KNOWLEDGE_BASE + CANDIDATOS no Gate 7

[ ] 4. ADD-F3: COMANDO_ESTRATEGISTA no Gate 8
       Testar: inscrever princípio no LEDGER → aviso de atualizar MASTER

[ ] 5. ADD-F4: MANIFESTO_DE_FONTES no Gate 9
       Testar: rodar session_close → 00_MANIFESTO_DE_FONTES.md gerado

[ ] 6. ADD-F5: Gate 9.5 consolidado
       Testar ciclo completo:
         a. 3 loops fechados → aviso amarelo + PENDENTES
         b. commit .js → aviso ciano + PENDENTES
         c. VEREDITOS hoje → trigger P-032 + PENDENTES
         d. WIP mais novo que MASTER → aviso amarelo + PENDENTES

[ ] 7. Criar reset_checkup.ps1 (se não existir)

[ ] 8. validate_scripts.ps1 em todos os scripts modificados

[ ] 9. propagate_changes.ps1

[ ] 10. Rodar session_close completo — verificar que:
         silêncio quando tudo OK
         alertas aparecem quando condição é real
         PENDENTES.md recebe entradas com formato P-069
```

---

## CRITÉRIO DE ACEITE

```
ABERTURA:
[ ] Commits recentes dos últimos 10 aparecem no contexto
[ ] Todos os verificações existentes continuam funcionando

FECHAMENTO:
[ ] AUDITOR_LOOP verificado no Gate 6
[ ] KNOWLEDGE_BASE e CANDIDATOS verificados no Gate 7
[ ] MASTER atualizado alertado no Gate 8
[ ] MANIFESTO_DE_FONTES gerado no Gate 9 para cada projeto
[ ] Gate 9.5 consolida todos os 4 gatilhos persistentes
[ ] Silêncio quando tudo OK — zero ruído desnecessário
[ ] validate_scripts.ps1 VERDE
```

---

## INSTRUÇÃO DE RESPOSTA — OBRIGATÓRIA

```
RELATÓRIO — AUTOMAÇÃO FINAL — [DATA] [HORA]

[ ] 1. ADD-A1 commits:        VERDE / FALHOU
[ ] 2. ADD-F1 AUDITOR_LOOP:   VERDE / FALHOU
[ ] 3. ADD-F2 KNOWLEDGE_BASE: VERDE / FALHOU
[ ] 4. ADD-F3 MASTER:         VERDE / FALHOU
[ ] 5. ADD-F4 MANIFESTO:      VERDE / FALHOU
[ ] 6. ADD-F5 Gate 9.5:       VERDE / FALHOU
[ ] 7. reset_checkup.ps1:     VERDE / FALHOU
[ ] 8. validate_scripts:      VERDE / FALHOU
[ ] 9. propagate_changes:     VERDE / FALHOU
[ ] 10. ciclo completo:       VERDE / FALHOU

Dependências de disciplina restantes: [listar ou "nenhuma"]

RESPOSTA DIRETA:
"Abertura e fechamento cobrem 100% do processo? SIM / NÃO"
```

Diretor copia e cola no Embaixador para análise final.

---

*Embaixador · Pentalateral IAH · 2026-05-29 (quinta-feira)*
*Via: Diretor Eduardo*
*Princípio: o que não está na abertura ou no fechamento não é sistêmico*
