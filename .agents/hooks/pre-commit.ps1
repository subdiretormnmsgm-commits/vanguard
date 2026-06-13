#Requires -Version 5.1
# pre-commit.ps1 -- Pentalateral IAH Pre-Commit Firewall
# R-01 CIRURGICO: match por nome de arquivo exato (nao por diretorio)
# R-03: fronteiras de clientes P-059
# R-04: arquivos auto-gerados requerem flag
# Instalado como hook em: .git/hooks/pre-commit (via pre-commit.bat)
# Origem: Antigravity Build C Loop 33 -- reescrito Loop 34 (dívida R-01/R-02)

$ErrorActionPreference = "Stop"
$raiz = git rev-parse --show-toplevel 2>$null
if (-not $raiz) { Write-Host "[FIREWALL] Nao e repositorio git." -ForegroundColor Red; exit 1 }

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

Write-Host "[PRE-COMMIT FIREWALL] OK -- R-01/R-03/R-04 limpos." -ForegroundColor Green
exit 0
