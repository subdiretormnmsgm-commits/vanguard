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

# --- GATE 0: WIP_BOARD vs artefatos reais (P-091) ---
# WIP_BOARD reflete realidade -- nao intencao.
# socio=OK sem artefato em disco = dado falso. Bloqueante.
$gate0Inconsist = [System.Collections.ArrayList]@()
$wipPath0 = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
if (Test-Path $wipPath0) {
    try {
        $board0    = Get-Content $wipPath0 -Raw -Encoding UTF8 | ConvertFrom-Json
        $projetos0 = @($board0.board.build)
        foreach ($proj0 in $projetos0) {
            $cli0        = $proj0.cliente.ToUpper()
            $clienteLow0 = $proj0.cliente.ToLower()
            $fase0       = $proj0.loop_fase_atual
            if (-not $fase0) { continue }
            $loopAtual0  = $fase0.loop

            if ($fase0.gemini -eq "OK") {
                $art0 = Join-Path $BASE "CLIENTES\$cli0\NOTEBOOKLM_FONTES\12_DIRETRIZ_GEMINI_V${loopAtual0}.txt"
                if (-not (Test-Path $art0)) {
                    [void]$gate0Inconsist.Add([PSCustomObject]@{
                        Proj = $cli0; Loop = $loopAtual0; Socio = "gemini"
                        Path = "CLIENTES\$cli0\NOTEBOOKLM_FONTES\12_DIRETRIZ_GEMINI_V${loopAtual0}.txt"
                    })
                }
            }
            if ($fase0.notebooklm -eq "OK") {
                $art0 = Join-Path $BASE ".claude\skills\${clienteLow0}-v${loopAtual0}.md"
                if (-not (Test-Path $art0)) {
                    [void]$gate0Inconsist.Add([PSCustomObject]@{
                        Proj = $cli0; Loop = $loopAtual0; Socio = "notebooklm"
                        Path = ".claude\skills\${clienteLow0}-v${loopAtual0}.md"
                    })
                }
            }
            if ($fase0.musculo -eq "OK") {
                $art0 = Join-Path $BASE "CLIENTES\$cli0\HISTORICO\DELIBERACAO_LOOP_V${loopAtual0}_${clienteLow0}.md"
                if (-not (Test-Path $art0)) {
                    [void]$gate0Inconsist.Add([PSCustomObject]@{
                        Proj = $cli0; Loop = $loopAtual0; Socio = "musculo"
                        Path = "CLIENTES\$cli0\HISTORICO\DELIBERACAO_LOOP_V${loopAtual0}_${clienteLow0}.md"
                    })
                }
            }
        }
    } catch {}
}

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
    Write-Host "  AUDITORIA DE CONSISTENCIA -- P-054 + P-091" -ForegroundColor Cyan
    Write-Host "  $DATA | Arquivos: $($arquivos.Count)"        -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host ""

    # Gate 0 output -- WIP_BOARD vs disco
    Write-Host "  [GATE 0] WIP_BOARD vs artefatos em disco (P-091):" -ForegroundColor Cyan
    if ($gate0Inconsist.Count -gt 0) {
        Write-Host "  [VERMELHO] $($gate0Inconsist.Count) inconsistencia(s) -- WIP_BOARD declara OK sem artefato:" -ForegroundColor Red
        foreach ($gi in $gate0Inconsist) {
            Write-Host "    Projeto : $($gi.Proj) Loop $($gi.Loop)" -ForegroundColor Red
            Write-Host "    Socio   : $($gi.Socio) = OK (WIP_BOARD)" -ForegroundColor DarkRed
            Write-Host "    Artefato: $($gi.Path) AUSENTE" -ForegroundColor DarkRed
            Write-Host "    Acao    : .\scripts\corrigir_wip.ps1 -cliente $($gi.Proj) -socio $($gi.Socio) -loop $($gi.Loop)"
            Write-Host ""
        }
    } else {
        Write-Host "  [OK] WIP_BOARD consistente com disco." -ForegroundColor Green
        Write-Host ""
    }

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
    if ($gate0Inconsist.Count -gt 0 -or $vermelhos.Count -gt 0) {
        Write-Host "  INTEGRIDADE: VERMELHO -- corrigir antes de fechar sessao" -ForegroundColor Red
    } elseif ($amarelos.Count -gt 0) {
        Write-Host "  INTEGRIDADE: AMARELO -- revisar e decidir"                -ForegroundColor Yellow
    } else {
        Write-Host "  INTEGRIDADE: VERDE"                                        -ForegroundColor Green
    }
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host ""
}

if ($gate0Inconsist.Count -gt 0 -or $vermelhos.Count -gt 0) { exit 2 }
if ($amarelos.Count -gt 0)                                   { exit 1 }
exit 0
