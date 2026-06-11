---
name: json-bom-guard
description: Skill de proteção contra BOM UTF-8 em arquivos JSON. FALHA-H recorrente (3ª ocorrência em Loop 32). Usar sempre que criar, editar ou receber arquivo .json.
version: "1.0"
created: "2026-06-11"
---

# JSON BOM GUARD — PENTALATERAL IAH

> FALHA-H: BOM UTF-8 (0xEF 0xBB 0xBF) silenciosamente quebrou ChurnWatch, Notion sync
> e session_start por múltiplas sessões. 3ª ocorrência em Loop 32. Esta skill previne a 4ª.

---

## O QUE É O BOM

BOM (Byte Order Mark) UTF-8 são 3 bytes (EF BB BF) inseridos automaticamente por:
- PowerShell 5.1 `Out-File` (default é UTF-16LE com BOM)
- Notepad do Windows ao salvar UTF-8
- VS Code em certos modos

O BOM é invisível no editor mas quebra `ConvertFrom-Json` e qualquer parser JSON
que não antecipe BOM (Python `json.load`, Node.js `JSON.parse`, n8n, etc.).

---

## REGRAS OBRIGATÓRIAS

### Ao CRIAR arquivo .json via PowerShell:

```powershell
# CORRETO — sem BOM
$utf8nb = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText("arquivo.json", $json, $utf8nb)

# ERRADO — PowerShell 5.1 adiciona BOM
$json | Out-File "arquivo.json" -Encoding UTF8
Set-Content "arquivo.json" -Value $json -Encoding UTF8
```

### Ao EDITAR arquivo .json existente:

```powershell
# 1. Ler como bytes
$bytes = [System.IO.File]::ReadAllBytes("arquivo.json")

# 2. Verificar BOM
if ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    Write-Warning "[BOM DETECTADO] arquivo.json tem BOM — removendo antes de editar"
    $bytes = $bytes[3..($bytes.Length-1)]
    [System.IO.File]::WriteAllBytes("arquivo.json", $bytes)
}

# 3. Editar e gravar sem BOM
$conteudo = [System.Text.Encoding]::UTF8.GetString($bytes) | ConvertFrom-Json
# ... editar ...
$novoJson = $conteudo | ConvertTo-Json -Depth 20
$utf8nb = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText("arquivo.json", $novoJson, $utf8nb)
```

### Ao RECEBER arquivo .json externo (upload, paste, n8n):

```powershell
# Sempre verificar antes de usar
$b = [System.IO.File]::ReadAllBytes("arquivo.json")
if ($b[0] -eq 0xEF) {
    Write-Warning "[ALERTA] BOM detectado em arquivo.json recebido externamente"
    # Executar fix_bom_json.ps1
    & ".\scripts\fix_bom_json.ps1" -Path (Split-Path "arquivo.json" -Parent)
}
```

---

## FERRAMENTA AUTOMÁTICA

`scripts/fix_bom_json.ps1` — remove BOM de todos os .json do repo:
```powershell
.\scripts\fix_bom_json.ps1          # corrigir todos
.\scripts\fix_bom_json.ps1 -DryRun  # simular sem escrever
```

Integrado ao Gate 1 do session_close.ps1 — roda automaticamente ao fechar sessão.

---

## ARQUIVOS COM HISTÓRICO DE BOM (monitorar sempre)

```
CLIENTES/WIP_BOARD.json           ← 3 incidentes documentados
CLIENTES/*/CLAUDE_PROJECT/LOOP_STATE.json
PENTALATERAL_UNIVERSAL/OPERACAO/DEPENDENCY_MAP.json
knowledge_graph.json
```

---

## DETECÇÃO RÁPIDA

```powershell
# Verificar se arquivo tem BOM (retorna True/False)
$b = [System.IO.File]::ReadAllBytes("arquivo.json")
$temBom = $b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF
Write-Host "BOM: $temBom"
```

---

## HISTÓRICO DE INCIDENTES

| Incidente | Loop | Arquivo | Impacto |
|-----------|------|---------|---------|
| FALHA-H-1 | ~29  | WIP_BOARD.json | ChurnWatch parou silenciosamente |
| FALHA-H-2 | ~30  | WIP_BOARD.json | Notion sync quebrado |
| FALHA-H-3 | 32   | WIP_BOARD.json | session_start falhou ao ler JSON |

v1.0 (2026-06-11): ATO 3 Loop 33 — prevenção FALHA-H (3ª ocorrência).