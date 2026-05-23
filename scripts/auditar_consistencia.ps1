# ============================================================
# AUDITAR_CONSISTENCIA.PS1 -- Gate de integridade textual
# P-054: toda operacao de substituicao em massa exige verificacao
# Uso: .\scripts\auditar_consistencia.ps1
# Retorna exit code 0 = VERDE, 1 = AMARELO, 2 = VERMELHO
# ============================================================

param(
    [switch]$Silencioso
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$DATA = Get-Date -Format "yyyy-MM-dd HH:mm"

# --- PADROES PROIBIDOS ---
$padroesProibidos = @(
    [PSCustomObject]@{ Padrao = 'QUADRILATERAL';                    Severidade = 'VERMELHO'; Msg = 'Nomenclatura obsoleta -- deve ser PENTALATERAL' },
    [PSCustomObject]@{ Padrao = '20 ideias/ciclo';                  Severidade = 'VERMELHO'; Msg = 'Ciclo desatualizado -- deve ser 25 ideias/ciclo [Mx2+G+N+E x 5]' },
    [PSCustomObject]@{ Padrao = '20 ideias por ciclo';              Severidade = 'VERMELHO'; Msg = 'Ciclo desatualizado -- deve ser 25 ideias por ciclo' },
    [PSCustomObject]@{ Padrao = 'MEMORANDO_QUADRILATERAL';          Severidade = 'VERMELHO'; Msg = 'Nome obsoleto -- deve ser MEMORANDO_PENTALATERAL_UNIVERSAL' },
    [PSCustomObject]@{ Padrao = 'PROCESSO_EVOLUTIVO_QUADRILATERAL'; Severidade = 'VERMELHO'; Msg = 'Nome obsoleto -- deve ser PROCESSO_EVOLUTIVO_PENTALATERAL' },
    [PSCustomObject]@{ Padrao = 'TEMPLATES_COMUNICACAO_QUADRILATERAL'; Severidade = 'VERMELHO'; Msg = 'Nome obsoleto -- deve ser TEMPLATES_COMUNICACAO_PENTALATERAL' },
    [PSCustomObject]@{ Padrao = 'vanguard-protocolo\.md.*v5\.|SKILL_PROTOCOLO.*v5\.'; Severidade = 'AMARELO'; Msg = 'Versao antiga da SKILL -- atual: v6.1' }
)

# --- PASTAS EXCLUIDAS (historico imutavel) ---
$excluirPastas = @(
    'VANGUARD_HISTORICO',
    'NOTEBOOKLM_LOOP1_VALDECE',
    'NOTEBOOKLM_RAIZ_V16-V24',
    'SESOES',
    'quadrilateral-v25',       # skill arquivada da era v25
    'CLIENTES\\INGRID\\HISTORICO',
    'CLIENTES\\VALDECE\\HISTORICO',
    'CLIENTES\\INGRID\\CLAUDE_PROJECT',   # docs do Claude Projects (acervo do Embaixador)
    'CLIENTES\\VALDECE\\CLAUDE_PROJECT',
    'vanguard-v15-',                      # skills arquivadas de versoes anteriores
    'vanguard-v24-',
    'auditar_consistencia'                # o proprio script nao se auto-audita
)

# --- ESCOPO DE BUSCA ---
$escopos = @(
    "$BASE\PENTALATERAL_UNIVERSAL",
    "$BASE\CLIENTES",
    "$BASE\.claude\skills",
    "$BASE\scripts"
)
$arquivosExtra = @(
    "$BASE\CLAUDE.md",
    "$BASE\INTELLIGENCE_LEDGER.md"
)

$arquivos = @()
foreach ($pasta in $escopos) {
    if (Test-Path $pasta) {
        $candidatos = Get-ChildItem $pasta -Recurse -File -Include "*.md","*.txt","*.ps1","*.json" -ErrorAction SilentlyContinue
        foreach ($f in $candidatos) {
            $rel = $f.FullName.Replace($BASE + "\", "")
            $excluir = $false
            foreach ($ex in $excluirPastas) {
                if ($rel -match $ex) { $excluir = $true; break }
            }
            if (-not $excluir) { $arquivos += $f }
        }
    }
}
foreach ($extra in $arquivosExtra) {
    if (Test-Path $extra) { $arquivos += Get-Item $extra }
}

# --- VARREDURA ---
$ocorrencias = [System.Collections.ArrayList]@()

foreach ($arquivo in $arquivos) {
    $conteudo = Get-Content $arquivo.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $conteudo) { continue }

    foreach ($p in $padroesProibidos) {
        if ($conteudo -match $p.Padrao) {
            $trecho = ($conteudo -split "`n" | Select-String -Pattern $p.Padrao | Select-Object -First 2 |
                       ForEach-Object { $_.ToString().Trim() }) -join " | "
            [void]$ocorrencias.Add([PSCustomObject]@{
                Arquivo    = $arquivo.FullName.Replace($BASE + "\", "")
                Severidade = $p.Severidade
                Msg        = $p.Msg
                Trecho     = if ($trecho.Length -gt 100) { $trecho.Substring(0,100) + "..." } else { $trecho }
            })
        }
    }
}

$vermelhos = @($ocorrencias | Where-Object { $_.Severidade -eq 'VERMELHO' })
$amarelos  = @($ocorrencias | Where-Object { $_.Severidade -eq 'AMARELO' })

# --- OUTPUT ---
if (-not $Silencioso) {
    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host "  AUDITORIA DE CONSISTENCIA TEXTUAL -- P-054" -ForegroundColor Cyan
    Write-Host "  $DATA | Arquivos: $($arquivos.Count)"        -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host ""

    if ($vermelhos.Count -gt 0) {
        Write-Host "  [VERMELHO] $($vermelhos.Count) ocorrencia(s) bloqueante(s):" -ForegroundColor Red
        foreach ($v in $vermelhos) {
            Write-Host "    Arquivo : $($v.Arquivo)"  -ForegroundColor Red
            Write-Host "    Motivo  : $($v.Msg)"      -ForegroundColor DarkRed
            if ($v.Trecho) {
                Write-Host "    Trecho  : $($v.Trecho)" -ForegroundColor DarkGray
            }
            Write-Host ""
        }
    }

    if ($amarelos.Count -gt 0) {
        Write-Host "  [AMARELO] $($amarelos.Count) ocorrencia(s) para revisar:" -ForegroundColor Yellow
        foreach ($a in $amarelos) {
            Write-Host "    Arquivo : $($a.Arquivo)" -ForegroundColor Yellow
            Write-Host "    Motivo  : $($a.Msg)"     -ForegroundColor DarkYellow
            Write-Host ""
        }
    }

    if ($ocorrencias.Count -eq 0) {
        Write-Host "  [VERDE] Zero ocorrencias de padroes proibidos." -ForegroundColor Green
        Write-Host "  Consistencia textual confirmada."                -ForegroundColor Green
        Write-Host ""
    }

    Write-Host "==============================================" -ForegroundColor Cyan
    if ($vermelhos.Count -gt 0) {
        Write-Host "  INTEGRIDADE: VERMELHO -- corrigir antes de fechar sessao" -ForegroundColor Red
    } elseif ($amarelos.Count -gt 0) {
        Write-Host "  INTEGRIDADE: AMARELO -- revisar e decidir"                -ForegroundColor Yellow
    } else {
        Write-Host "  INTEGRIDADE: VERDE"                                        -ForegroundColor Green
    }
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host ""
}

if ($vermelhos.Count -gt 0) { exit 2 }
if ($amarelos.Count -gt 0)  { exit 1 }
exit 0
