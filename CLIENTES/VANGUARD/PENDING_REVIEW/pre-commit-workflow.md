---
name: pre-commit-firewall
description: Verifica conformidade com AGENTS.md antes de qualquer commit proposto pelo Antigravity. Bloqueia se arquivo da lista R-01 está no diff.
---

# WORKFLOW: Pre-Commit Firewall

Este workflow funciona como a última trincheira do Pentalateral IAH. Ele deve ser engatado via hook (`.git/hooks/pre-commit`) ou evocado obrigatoriamente pelo Músculo antes de acionar `git commit`. A sua função é garantir que as regras inquebráveis do `pentalateral-firewall.md` não sejam transpostas em nenhuma circunstância de salvamento de estado de código.

## Execução: Validação R-01 a R-04

O bloco PowerShell abaixo deve atuar como o juiz do `git diff --cached` (arquivos em staging prontos para commit).

```powershell
# [BLOCO POWERSHELL PARA EMBEBER NO PRE-COMMIT HOOK OU SCRIPT DO MÚSCULO]

$ErrorActionPreference = "Stop"
Write-Host "[PRE-COMMIT FIREWALL] Iniciando varredura de compliance Pentalateral..." -ForegroundColor Cyan

# Pega todos os arquivos em staging para commit
$stagedFiles = git diff --cached --name-only

if (-not $stagedFiles) {
    Write-Host "Nenhum arquivo em staging."
    exit 0
}

# Define a lista R-01 (Arquivos Canônicos Protegidos)
$r01_protected = @(
    "INTELLIGENCE_LEDGER.md",
    "PENDENTES.md",
    "WIP_BOARD.json",
    "DEPENDENCY_MAP.json",
    "CLAUDE.md",
    "GEMINI.md",
    "AGENTS.md"
)

$abortCommit = $false

foreach ($file in $stagedFiles) {
    $fileName = Split-Path $file -Leaf
    $dirName  = Split-Path $file -Parent

    # =========================================================
    # [R-01] Verificação de Arquivos Canônicos e Read-Only
    # =========================================================
    if ($r01_protected -contains $fileName -or $dirName -match "^PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE" -or $dirName -match "^scripts" -or $file -match "LOOP_STATE.json$") {
        # Para R-01, necessita da string 'AUTORIZO SOBRESCREVER' na flag temporária ou commit msg
        # Como é pre-commit, verificamos variável de ambiente ou confirmação do diretor
        if (-not $env:PENTALATERAL_AUTORIZO) {
            Write-Host "[VIOLAÇÃO R-01] O arquivo protegido '$file' foi alterado sem autorização explícita do Diretor." -ForegroundColor Red
            $abortCommit = $true
        }
    }

    # =========================================================
    # [R-02] Verificação de Staging Obrigatório
    # =========================================================
    # Se Antigravity gerou algo, tem que estar no PENDING_REVIEW. 
    # Músculo não deve commitar edições do Antigravity direto nesses arquivos alvo.
    # Se o commit inclui WIP_BOARD, DECISOES ou INTELLIGENCE_LEDGER, e a flag de review é falsa:
    if ($fileName -match "^WIP_BOARD\.json$" -or $fileName -match "^DECISOES.*\.json$" -or $fileName -match "^INTELLIGENCE_LEDGER\.md$") {
        # O Músculo precisa ter marcado uma flag de aprovação
        if (-not $env:PENTALATERAL_VEREDITO_DIRETOR) {
            Write-Host "[VIOLAÇÃO R-02] Tentativa de commit direto em '$fileName' sem passar pelo ciclo de PENDING_REVIEW e Veredito." -ForegroundColor Red
            $abortCommit = $true
        }
    }

    # =========================================================
    # [R-03] Fronteiras de Clientes (P-059)
    # =========================================================
    # Verifica se há vazamento de caminhos. Ex: Commit no diretório VANGUARD contendo strings de INGRID.
    if ($dirName -match "CLIENTES/VANGUARD") {
        $content = git show :$file
        if ($content -match "INGRID" -or $content -match "VALDECE" -or $content -match "MUMUZINHO") {
            # O cross-talk é aceitável em relatórios restritos, mas não em infraestrutura. Para o pre-commit, a detecção obriga a checagem.
            Write-Host "[ALERTA R-03] Possível cross-talk de cliente detectado em '$file'. Verifique o Isolamento (P-059)." -ForegroundColor Yellow
            # Não aborta automaticamente por ser falso positivo em relatórios, mas exige review.
        }
    }

    # =========================================================
    # [R-04] Edição Manual de Autogerados
    # =========================================================
    if ($file -match "MEMORIA_EMBAIXADOR" -or $file -match "RUNNING_INTELLIGENCE") {
        if (-not $env:PENTALATERAL_AUTORIZO_MANUAL) {
            Write-Host "[VIOLAÇÃO R-04] O arquivo auto-gerado '$file' foi modificado sem a flag de edição manual." -ForegroundColor Red
            $abortCommit = $true
        }
    }
}

if ($abortCommit) {
    Write-Host "[PRE-COMMIT FIREWALL] O COMMIT FOI ABORTADO DEVIDO A VIOLAÇÕES DAS REGRAS R-01 A R-04." -ForegroundColor Red
    Write-Host "Reverta os arquivos em staging ou utilize a autorização apropriada do Diretor." -ForegroundColor Yellow
    exit 1
}

Write-Host "[PRE-COMMIT FIREWALL] Verificação concluída. Firewall intacto. Commit liberado." -ForegroundColor Green
exit 0
```

## Como o Músculo utiliza este workflow
O Músculo deve garantir que este script esteja copiado para `.git/hooks/pre-commit` com permissão de execução, ou chamado explicitamente dentro das suas *skills* de manipulação de repositório sempre que ele planejar agrupar os artefatos para commit. Nenhuma "forçada de barra" (`--no-verify`) é tolerada, a menos que venha de um Veredito explícito do Diretor.
