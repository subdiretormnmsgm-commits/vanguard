#Requires -Version 5.1
# pre-commit.ps1 -- Pentalateral IAH Pre-Commit Firewall
# R-01 CIRURGICO: match por nome de arquivo exato (nao por diretorio)
# R-03: fronteiras de clientes P-059
# R-04: arquivos auto-gerados requerem flag
# Instalado como hook em: .git/hooks/pre-commit (via pre-commit.bat)
# Origem: Antigravity Build C Loop 33 -- reescrito Loop 34 (dívida R-01/R-02)

$ErrorActionPreference = "Stop"
# raiz derivada de $PSScriptRoot (argv chega em UTF-16 correto via -File).
# NAO usar 'git rev-parse --show-toplevel' para o path: no powershell.exe spawned
# pelo git-sh o console e CP850 e a saida UTF-8 do git corrompe o acento de
# 'Area de Trabalho' -- quebrava Test-Path do flag P-098 (.musculo_autorizacao.flag)
# e do gate R-05. Confirmado 2026-06-16 (CP850, Test-Path via raiz=False). #17 PENDENTES.
if ($PSScriptRoot) {
    # $PSScriptRoot = <raiz>/.git/hooks  -> dois niveis acima = <raiz>
    $raiz = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
} else {
    $raiz = git rev-parse --show-toplevel 2>$null
}
$ehRepo = git rev-parse --is-inside-work-tree 2>$null
if ($ehRepo -ne 'true' -or -not $raiz) { Write-Host "[FIREWALL] Nao e repositorio git." -ForegroundColor Red; exit 1 }

Write-Host "[PRE-COMMIT FIREWALL] Varredura R-01/R-03/R-04..." -ForegroundColor Cyan

$stagedFiles = git diff --cached --name-only 2>$null
if (-not $stagedFiles) { exit 0 }

# --- R-01: ARQUIVOS CANONICOS PROTEGIDOS (match por nome exato ou padrao) ---
# Mudanca Loop 34: match cirurgico por arquivo, nao por diretorio
$r01_nomes_exatos = @(
    "INTELLIGENCE_LEDGER.md",
    "WIP_BOARD.json",
    "DEPENDENCY_MAP.json",
    "CLAUDE.md",
    "GEMINI.md",
    "AGENTS.md",
    "LOOP_STATE.json"
)
# PENDENTES.md excluido de R-01 -- arquivo de tracking, modificado toda sessao com [RESOLVE:]
# Protecao suficiente via git diff + R-02 no commit-msg (se junto com WIP_BOARD)
$r01_padroes = @(
    "NOTEBOOKLM_BASE/",
    "PENTALATERAL_UNIVERSAL/OPERACAO/SKILL_PROTOCOLO_VANGUARD.md"
)

# Flag de autorizacao P-098 (bypass R-01 por arquivo especifico)
$autorizacaoFlag = Join-Path $raiz ".musculo_autorizacao.flag"
$arquivoAutorizado = ""
if (Test-Path $autorizacaoFlag) {
    $arquivoAutorizado = (Get-Content $autorizacaoFlag -Raw -Encoding UTF8).Trim()
}

$abortCommit = $false

foreach ($file in $stagedFiles) {
    $fileName = Split-Path $file -Leaf
    $filePath = $file -replace "\\","/"

    # --- R-01 ---
    $isR01 = $false
    if ($r01_nomes_exatos -contains $fileName) { $isR01 = $true }
    foreach ($pad in $r01_padroes) {
        if ($filePath -match [regex]::Escape($pad)) { $isR01 = $true; break }
    }

    if ($isR01) {
        # Verificar autorizacao: flag P-098 OU env PENTALATERAL_AUTORIZO (bypass de emergencia)
        $autorizado = $false
        if ($arquivoAutorizado -and ($fileName -eq $arquivoAutorizado -or $filePath -match [regex]::Escape($arquivoAutorizado))) {
            $autorizado = $true
            Write-Host "  [R-01] $file -- autorizado via .musculo_autorizacao.flag" -ForegroundColor Yellow
        } elseif ($env:PENTALATERAL_AUTORIZO) {
            $autorizado = $true
        }
        if (-not $autorizado) {
            Write-Host "  [VIOLACAO R-01] Arquivo canonico '$file' requer autorizacao." -ForegroundColor Red
            Write-Host "  Opcoes: (a) criar .musculo_autorizacao.flag com nome '$fileName'" -ForegroundColor Yellow
            Write-Host "          (b) incluir [VEREDITO-DIRETOR] na mensagem de commit (verificado em commit-msg)" -ForegroundColor Yellow
            $abortCommit = $true
        }
    }

    # --- R-03: FRONTEIRAS DE CLIENTE (P-059) ---
    # VANGUARD e meta-projeto -- LEDGER/FONTES referenciam todos os clientes por design
    $r03Excluir = $filePath -match "INTELLIGENCE_LEDGER|NOTEBOOKLM_FONTES/04_|CONTEXTO_GEMINI"
    if ($filePath -match "CLIENTES/VANGUARD" -and -not $r03Excluir) {
        try {
            $content = git show ":$file" 2>$null
            if ($content) {
                $crossTalk = @("INGRID","VALDECE","MUMUZINHO") | Where-Object { $content -match $_ }
                if ($crossTalk) {
                    Write-Host "  [ALERTA R-03] Cross-talk detectado em '$file': $($crossTalk -join ', ') -- P-059" -ForegroundColor Yellow
                }
            }
        } catch {}
    }

    # --- R-04: ARQUIVOS AUTO-GERADOS (apenas .md em CLAUDE_PROJECT, nao scripts) ---
    if (($filePath -match "CLAUDE_PROJECT[/\\]MEMORIA_EMBAIXADOR.*\.md$") -or
        ($filePath -match "CLAUDE_PROJECT[/\\]RUNNING_INTELLIGENCE.*\.md$")) {
        if (-not $env:PENTALATERAL_AUTORIZO_MANUAL -and $arquivoAutorizado -ne $fileName) {
            Write-Host "  [VIOLACAO R-04] Arquivo auto-gerado '$file' modificado sem flag." -ForegroundColor Red
            Write-Host "  Flag: .musculo_autorizacao.flag com conteudo '$fileName'" -ForegroundColor Yellow
            $abortCommit = $true
        }
    }
}

# Consumir flag P-098 (one-shot -- apagar apos uso)
if ((Test-Path $autorizacaoFlag) -and $arquivoAutorizado -ne "") {
    Remove-Item $autorizacaoFlag -Force -ErrorAction SilentlyContinue
    Write-Host "  [R-01] Flag .musculo_autorizacao.flag consumida (one-shot P-098)" -ForegroundColor DarkGray
}

if ($abortCommit) {
    Write-Host ""
    Write-Host "[PRE-COMMIT FIREWALL] COMMIT ABORTADO -- R-01 ou R-04 violado." -ForegroundColor Red
    exit 1
}

# --- R-05: CODE-REVIEW (P-178) -- codigo staged exige review antes do commit ---
# Gatilho mecanico nao-bypassavel: combate "muitos erros de codigo ao longo dos loops".
# A engine detecta+bloqueia; o Musculo roda a skill requesting-code-review + -MarkReviewed.
$crScript = Join-Path $raiz "scripts\gate_code_review.ps1"
if (Test-Path $crScript) {
    & $crScript -Verify
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "[PRE-COMMIT FIREWALL] COMMIT ABORTADO -- R-05 (code-review P-178)." -ForegroundColor Red
        exit 1
    }
}

# --- R-06: DRIFT DE ATIVACAO (P-146) -- JSON fonte vs Code node embutido do W-11 ---
# So roda se um dos 2 arquivos de ativacao estiver staged (barato; evita ruido).
# Comandos vivem duplicados (n8n nao le repo) -> impede divergencia silenciosa.
$ativStaged = $stagedFiles | Where-Object { $_ -match "comandos_ativacao_atores\.json$" -or $_ -match "w11_calcular_ativacoes\.js$" }
if ($ativStaged) {
    $driftScript = Join-Path $raiz "scripts\gate_drift_ativacao.ps1"
    if (Test-Path $driftScript) {
        & $driftScript -Quiet
        # exit 1 = drift (BLOQUEIA) | exit 2 = fonte ausente (ex.: delecao do .js -- NAO bloqueia) | 0 = ok
        if ($LASTEXITCODE -eq 1) {
            Write-Host ""
            Write-Host "[PRE-COMMIT FIREWALL] COMMIT ABORTADO -- R-06 (drift ativacao A/B P-146)." -ForegroundColor Red
            & $driftScript   # reexibe os detalhes da divergencia
            exit 1
        }
    }
}

Write-Host "[PRE-COMMIT FIREWALL] OK -- R-01/R-03/R-04/R-05/R-06 limpos." -ForegroundColor Green
exit 0
