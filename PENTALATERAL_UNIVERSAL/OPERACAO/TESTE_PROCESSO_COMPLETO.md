# TESTE_PROCESSO_COMPLETO — Checklist de Verificação do Sistema
> Pentalateral IAH · Executado pelo Músculo · Nunca pelo Diretor
> Frequência: conforme gatilho — não a cada sessão (P-032/2026-05-29)

---

## QUANDO USAR CADA BLOCO

| Gatilho | Bloco | Tempo |
|---|---|---|
| Build significativo na sessão (novo feature ou deploy) | **Bloco A** | 5 min |
| session_close exibiu "CHECK-UP SISTÊMICO RECOMENDADO" (a cada 3 loops) | Redirect → `COMANDO_VERIFICACAO_SISTEMICA_FINAL.md` | 20 min |
| Projeto novo detectado em PRE-QUALIFICACAO | **Completo (A+B+C)** | 40 min |

---

## BLOCO A — PÓS-BUILD SIGNIFICATIVO (5 min)

Executar após qualquer sessão com commit de feature ou deploy confirmado.
Gates: PASSO3 placeholder · versão de artefatos · timing P-089

### Gate A1 — PASSO3 sem placeholder

Verificar que nenhum PASSO3_GEMINI.md ativo contém marcador de rascunho:

```powershell
Select-String -Path "CLIENTES\*\PASSO3_GEMINI.md" -Pattern "\[MUSCULO:" -SimpleMatch
```

**VERDE:** nenhum resultado  
**VERMELHO:** arquivo com placeholder → Músculo preenche antes de qualquer loop

---

### Gate A2 — Artefatos de fechamento do loop atual existem em disco

Para cada projeto com `musculo = "OK"` no WIP_BOARD, verificar:

```powershell
# Substituir [CLIENTE] e [N] pelos valores do WIP_BOARD
Test-Path "CLIENTES\[CLIENTE]\HISTORICO\MEMORIA_V[N]_[CLIENTE].md"
Test-Path "CLIENTES\[CLIENTE]\HISTORICO\relatorio_evolutivo_V[N]_[CLIENTE].md"
Test-Path "CLIENTES\[CLIENTE]\HISTORICO\DELIBERACAO_LOOP_V[N]_[CLIENTE].md"
```

**VERDE:** todos os 3 existem  
**VERMELHO:** artefato ausente → P-045 violado → criar antes de avançar

---

### Gate A3 — Timing P-089 (PASSO3 coerente com loop atual)

Verificar que o cabeçalho do PASSO3_GEMINI.md ativo referencia o loop atual do WIP_BOARD, não o anterior:

```powershell
# Ler primeira linha do PASSO3 e comparar com loop atual do WIP_BOARD
$loop = (Get-Content "CLIENTES\WIP_BOARD.json" | ConvertFrom-Json).projetos.[CLIENTE].loop_atual
$passo3Header = (Get-Content "CLIENTES\[CLIENTE]\PASSO3_GEMINI.md" -TotalCount 5) -join " "
if ($passo3Header -match "Loop $loop") { "VERDE" } else { "VERMELHO — PASSO3 defasado" }
```

**VERDE:** loop no cabeçalho bate com loop_atual do WIP_BOARD  
**VERMELHO:** PASSO3 do loop anterior → rodar `gemini_anchor_generator.ps1 -cliente [CLIENTE]`

---

### Gate A4 — MEMORY_EMBAIXADOR atualizada no mesmo dia dos vereditos executados

```powershell
# Para cada projeto com vereditos executados hoje
$hoje = Get-Date -Format "yyyy-MM-dd"
$memoria = Get-Item "CLIENTES\[CLIENTE]\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
if ($memoria.LastWriteTime.ToString("yyyy-MM-dd") -eq $hoje) { "VERDE" } else { "VERMELHO — P-032 violado" }
```

**VERDE:** LastWriteTime = hoje  
**VERMELHO:** `MEMORIA_EMBAIXADOR` desatualizada → Músculo atualiza antes de fechar sessão (P-036 bloqueante)

---

### Resultado do Bloco A

```
Gate A1 — PASSO3 sem placeholder:     [ ] VERDE  [ ] VERMELHO
Gate A2 — Artefatos em disco:         [ ] VERDE  [ ] VERMELHO
Gate A3 — Timing P-089:               [ ] VERDE  [ ] VERMELHO
Gate A4 — MEMORIA_EMBAIXADOR (P-032): [ ] VERDE  [ ] VERMELHO
```

**Todos VERDES:** Bloco A concluído. Sessão pode fechar.  
**Qualquer VERMELHO:** resolver antes de rodar `session_close.ps1`.

---

## BLOCO B — ONBOARDING DE PROJETO NOVO (adicional ao Bloco A)

Executar apenas quando session_start detectar projeto novo em PRE-QUALIFICACAO.

### Gate B1 — Estrutura de pastas do projeto existe

```powershell
$cliente = "[NOME]"
@(
  "CLIENTES\$cliente\CLAUDE_PROJECT",
  "CLIENTES\$cliente\HISTORICO",
  "CLIENTES\$cliente\NOTEBOOKLM_FONTES",
  "CLIENTES\$cliente\CLAUDE_PROJECT\DECISOES"
) | ForEach-Object { if (Test-Path $_) { "OK: $_" } else { "AUSENTE: $_" } }
```

---

### Gate B2 — Hooks ativos

```powershell
@(
  ".claude\hooks\session_start.ps1",
  ".claude\hooks\hv1_credential_guard.ps1",
  ".claude\hooks\fechamento_checklist.ps1",
  ".claude\hooks\stop_checklist.ps1"
) | ForEach-Object { if (Test-Path $_) { "OK: $_" } else { "AUSENTE: $_" } }
```

---

### Gate B3 — detect_canonical_violation VERDE

```powershell
.\scripts\detect_canonical_violation.ps1
# Resultado esperado: exit 0 — VERDE
```

---

### Gate B4 — WIP_BOARD tem entry do novo projeto

```powershell
$wb = Get-Content "CLIENTES\WIP_BOARD.json" | ConvertFrom-Json
$wb.projetos.[CLIENTE] | ConvertTo-Json
# Verificar: status, loop_atual, loop_fase_atual, gates_programados
```

---

### Gate B5 — Embaixador ativado (INSTRUCAO_SISTEMA existe)

```powershell
Test-Path "CLIENTES\[CLIENTE]\CLAUDE_PROJECT\INSTRUCAO_SISTEMA.md"
# VERDE = Passo 0 foi executado
```

---

### Gate B6 — Scripts de sócio funcionam sem erro

```powershell
.\scripts\gemini_anchor_generator.ps1 -cliente [CLIENTE] -DryRun
.\scripts\preparar_notebooklm_projeto.ps1 -cliente [CLIENTE] -DryRun
.\scripts\ir_ao_embaixador.ps1 -cliente [CLIENTE] -DryRun
# Todos devem retornar exit 0
```

---

### Resultado do Bloco B

```
Gate B1 — Estrutura de pastas:        [ ] VERDE  [ ] VERMELHO
Gate B2 — Hooks ativos:               [ ] VERDE  [ ] VERMELHO
Gate B3 — Canonical violation:        [ ] VERDE  [ ] VERMELHO
Gate B4 — WIP_BOARD entry:            [ ] VERDE  [ ] VERMELHO
Gate B5 — Embaixador ativado:         [ ] VERDE  [ ] VERMELHO
Gate B6 — Scripts DryRun:             [ ] VERDE  [ ] VERMELHO
```

**Todos VERDES:** sistema pronto para o Loop 1 do projeto.  
**Qualquer VERMELHO:** resolver antes de ir ao Gemini (Passo 3).

---

## REGISTRO DE EXECUÇÃO

Ao executar qualquer Bloco, registrar no PENDENTES.md como resolvido:

```
- [x] `[DATA]` ~~[BUILD/PRE-QUALIFICACAO] TESTE_PROCESSO_COMPLETO.md Bloco [A/Completo] — todos VERDES~~
```

---

> Criado pelo Músculo em 2026-06-04 · origem: fantasma detectado em PENDENTES.md × 3 sessões
> Mantido em: PENTALATERAL_UNIVERSAL/OPERACAO/ (TIPO 1 UNIVERSAL_PURO)
