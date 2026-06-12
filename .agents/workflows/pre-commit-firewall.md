---
name: pre-commit-firewall
description: Verifica conformidade com AGENTS.md antes de qualquer commit. Bloqueia se arquivo da lista R-01 está no diff sem autorização explícita do Diretor.
status: DOCUMENTACAO_APENAS
dívida: "R-01 e R-02 precisam ser reescritos com lógica cirúrgica antes de instalar como git hook — Loop 34"
---

# WORKFLOW: Pre-Commit Firewall (Documentação)

> **STATUS:** DOCUMENTAÇÃO APENAS — NÃO instalar como `.git/hooks/pre-commit` até que R-01 e R-02 sejam reescritos.
> **Problemas bloqueantes antes de ativar como hook:**
> 1. R-01: `$dirName -match "^scripts"` é amplo demais — bloquearia commits normais dos scripts de orquestração.
> 2. R-02: exige `$env:PENTALATERAL_VEREDITO_DIRETOR` para commitar `WIP_BOARD.json`, arquivo modificado em praticamente todo commit.
> 3. Git hooks no Windows não executam PowerShell nativo sem wrapper `.bat` ou configuração adicional.
>
> **Dívida técnica Loop 34:** reescrever R-01 para match por arquivo específico (não diretório), R-02 para usar flag de commit msg ao invés de ENV_VAR.

Este workflow funciona como a última trincheira do Pentalateral IAH. Aborta commits do LLM se o diff tocar em arquivos do R-01 a R-04 sem flag de autorização.

## Execução: Validação R-01 a R-04

```powershell
# [BLOCO POWERSHELL PARA EMBEBER NO PRE-COMMIT HOOK OU SCRIPT DO MÚSCULO]
# ORIGEM: Antigravity Executor MODO 2, Build C, Loop 33 ATO 3
# ATENÇÃO: NÃO instalar diretamente — ver problemas R-01/R-02 no cabeçalho acima.

$ErrorActionPreference = "Stop"
Write-Host "[PRE-COMMIT FIREWALL] Iniciando varredura de compliance Pentalateral..." -ForegroundColor Cyan

# Pega todos os arquivos em staging para commit
$stagedFiles = git diff --cached --name-only

if (-not $stagedFiles) {
    Write-Host "Nenhum arquivo em staging."
    exit 0
}

# Define a lista R-01 (Arquivos Canônicos Protegidos)
# TODO Loop 34: substituir por match por nome de arquivo, não por diretório
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

    # [R-01] Verificação de Arquivos Canônicos e Read-Only
    # TODO Loop 34: remover "$dirName -match '^scripts'" — bloqueia scripts de orquestração
    if ($r01_protected -contains $fileName -or $dirName -match "^PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE" -or $dirName -match "^scripts" -or $file -match "LOOP_STATE.json$") {
        if (-not $env:PENTALATERAL_AUTORIZO) {
            Write-Host "[VIOLAÇÃO R-01] O arquivo protegido '$file' foi alterado sem autorização explícita do Diretor." -ForegroundColor Red
            $abortCommit = $true
        }
    }

    # [R-02] Verificação de Staging Obrigatório
    # TODO Loop 34: substituir $env:PENTALATERAL_VEREDITO_DIRETOR por flag em mensagem de commit
    if ($fileName -match "^WIP_BOARD\.json$" -or $fileName -match "^DECISOES.*\.json$" -or $fileName -match "^INTELLIGENCE_LEDGER\.md$") {
        if (-not $env:PENTALATERAL_VEREDITO_DIRETOR) {
            Write-Host "[VIOLAÇÃO R-02] Tentativa de commit direto em '$fileName' sem passar pelo ciclo de PENDING_REVIEW e Veredito." -ForegroundColor Red
            $abortCommit = $true
        }
    }

    # [R-03] Fronteiras de Clientes (P-059)
    if ($dirName -match "CLIENTES/VANGUARD") {
        $content = git show :$file
        if ($content -match "INGRID" -or $content -match "VALDECE" -or $content -match "MUMUZINHO") {
            Write-Host "[ALERTA R-03] Possível cross-talk de cliente detectado em '$file'. Verifique o Isolamento (P-059)." -ForegroundColor Yellow
        }
    }

    # [R-04] Edição Manual de Autogerados
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

## Dívida Técnica — Loop 34

- **R-01 cirúrgico:** match por nome de arquivo exato ou padrão glob, não por diretório — ex: `$fileName -match "^(INTELLIGENCE_LEDGER|DEPENDENCY_MAP|CLAUDE)\..*$"` + wildcard para `PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/**.md`
- **R-02 por commit msg:** verificar se commit message contém tag `[VEREDITO-DIRETOR]` ao invés de ENV_VAR — integra com o mecanismo [RESOLVE:] já ativo
- **Wrapper Windows:** criar `pre-commit.bat` que chama `powershell.exe -File .git/hooks/pre-commit.ps1` para compatibilidade

## Origem

Antigravity Executor MODO 2, Build C, Loop 33 ATO 3 (2026-06-12).
Análise e decisão de não instalar: Músculo, Loop 33 ATO 4 (2026-06-12).
