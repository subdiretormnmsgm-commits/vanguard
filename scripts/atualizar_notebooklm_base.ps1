# atualizar_notebooklm_base.ps1
# PENTALATERAL IAH - V26
#
# QUANDO RODAR: sempre que qualquer documento universal evoluir.
# - Apos atualizar SKILL_PROTOCOLO_VANGUARD.md
# - Apos sessao que gera novos principios no INTELLIGENCE_LEDGER
# - Apos Eduardo atualizar ANALISE_SOCIO_ATUAL.txt (pos-NotebooklM)
# - Apos atualizar WIP_BOARD.json (novo projeto ou mudanca de status)
#
# O QUE FAZ: sincroniza PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/
# com os documentos fonte originais. A BASE e sempre espelho atualizado.
# NOTA: WIP_BOARD.json e convertido para texto legivel (07_WIP_BOARD.txt)
#       NotebookLM nao processa JSON bruto — extensao .txt nao basta.
#
# USO:
#   .\scripts\atualizar_notebooklm_base.ps1

$ErrorActionPreference = "Stop"

$raiz  = $PSScriptRoot | Split-Path -Parent
$dest  = "$raiz\PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE"

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " PENTALATERAL IAH - Atualizar NotebookLM BASE   " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# ──────────────────────────────────────────────────────────────
# FUNCAO: Converte WIP_BOARD.json para texto legivel pelo Auditor
# ──────────────────────────────────────────────────────────────
function ConvertTo-WipBoardTxt {
    param([string]$jsonPath)

    $wip = Get-Content $jsonPath -Raw -Encoding utf8 | ConvertFrom-Json

    $linhas = @()
    $linhas += "WIP BOARD — PENTALATERAL IAH"
    $linhas += "Atualizado em: $($wip.atualizado_em)"
    $linhas += "WIP Limits: BUILD=$($wip.wip_limits.build)  CHECK=$($wip.wip_limits.check)"
    $linhas += ""

    # Itera colunas do board
    foreach ($coluna in @("build","check","entregue","retainer","discovery")) {
        $projetos = $wip.board.$coluna
        if (-not $projetos -or $projetos.Count -eq 0) { continue }

        $linhas += "=============================="
        $linhas += "COLUNA: $($coluna.ToUpper())"
        $linhas += "=============================="
        $linhas += ""

        foreach ($p in $projetos) {
            $linhas += "-------------------------------"
            $linhas += "PROJETO: $($p.id) — $($p.cliente)"
            $linhas += "  Descricao : $($p.projeto)"
            $linhas += "  Area      : $($p.area)"
            $linhas += "  Camada    : $($p.camada)"
            $linhas += "  Stack     : $($p.stack)"
            $linhas += "  Deadline  : $($p.deadline)"
            $linhas += "  Status    : $($p.status)"
            $linhas += "  Loop atual: $($p.loop_atual)"

            if ($p.dias_completos) {
                $linhas += "  Dias completos: $($p.dias_completos -join ', ')"
            }

            if ($p.gates_bloqueantes) {
                $linhas += "  Gates bloqueantes:"
                $p.gates_bloqueantes.PSObject.Properties | ForEach-Object {
                    $linhas += "    $($_.Name): $($_.Value)"
                }
            }

            if ($p.decisoes_fixadas) {
                $linhas += "  Decisoes fixadas:"
                $p.decisoes_fixadas.PSObject.Properties | ForEach-Object {
                    $linhas += "    $($_.Name): $($_.Value)"
                }
            }

            if ($p.proximo_passo) {
                $linhas += "  Proximo passo: $($p.proximo_passo)"
            }

            if ($p.loops_programados) {
                $linhas += "  Loops programados:"
                foreach ($lp in $p.loops_programados) {
                    $linhas += "    Loop $($lp.loop) ($($lp.nome)): $($lp.status)"
                }
            }

            $linhas += ""
        }
    }

    # Perfis de nicho
    if ($wip.perfis_nicho) {
        $linhas += "=============================="
        $linhas += "PERFIS DE NICHO"
        $linhas += "=============================="
        foreach ($pf in $wip.perfis_nicho.perfis_ativos) {
            $linhas += "  $($pf.nicho): maturidade=$($pf.maturidade) status=$($pf.status)"
        }
        foreach ($pf in $wip.perfis_nicho.perfis_em_discovery) {
            $linhas += "  $($pf.nicho) [DISCOVERY]: $($pf.status)"
        }
        $linhas += ""
    }

    return $linhas -join "`n"
}

# ──────────────────────────────────────────────────────────────
# Documentos normais (copia direta)
# ──────────────────────────────────────────────────────────────
$documentos = @(
    @{ Num = "01"; Nome = "SKILL_PROTOCOLO_VANGUARD.md";           Origem = "$raiz\PENTALATERAL_UNIVERSAL\OPERACAO\SKILL_PROTOCOLO_VANGUARD.md" },
    @{ Num = "02"; Nome = "MEMORANDO_PENTALATERAL_UNIVERSAL.md";  Origem = "$raiz\PENTALATERAL_UNIVERSAL\CONSTITUICAO\MEMORANDO_PENTALATERAL_UNIVERSAL.md" },
    @{ Num = "03"; Nome = "MANUAL_DIRETOR.md";                     Origem = "$raiz\PENTALATERAL_UNIVERSAL\OPERACAO\MANUAL_DIRETOR.md" },
    @{ Num = "04"; Nome = "INTELLIGENCE_LEDGER.md";                Origem = "$raiz\INTELLIGENCE_LEDGER.md" },
    @{ Num = "05"; Nome = "PROCESSO_EVOLUTIVO_PENTALATERAL.md";   Origem = "$raiz\PENTALATERAL_UNIVERSAL\OPERACAO\PROCESSO_EVOLUTIVO_PENTALATERAL.md" },
    @{ Num = "06"; Nome = "TEMPLATES_COMUNICACAO_PENTALATERAL.md";Origem = "$raiz\PENTALATERAL_UNIVERSAL\TEMPLATES\TEMPLATES_COMUNICACAO_PENTALATERAL.md" },
    @{ Num = "08"; Nome = "ANALISE_SOCIO_ATUAL.txt";               Origem = "$raiz\CONSELHO\NotebookLM\ANALISE_SOCIO_ATUAL.txt" }
)

$atualizados = 0
$erros       = 0

foreach ($doc in $documentos) {
    $destino = "$dest\$($doc.Num)_$($doc.Nome)"
    if (Test-Path $doc.Origem) {
        Copy-Item $doc.Origem $destino -Force
        Write-Host "  [OK] $($doc.Num)_$($doc.Nome)" -ForegroundColor Green
        $atualizados++
    } else {
        Write-Host "  [FALTANDO] $($doc.Origem)" -ForegroundColor Red
        $erros++
    }
}

# ──────────────────────────────────────────────────────────────
# WIP_BOARD: conversao JSON → texto legivel (07)
# ──────────────────────────────────────────────────────────────
$wipJson = "$raiz\CLIENTES\WIP_BOARD.json"
$wipDest = "$dest\07_WIP_BOARD.txt"
if (Test-Path $wipJson) {
    $txt = ConvertTo-WipBoardTxt -jsonPath $wipJson
    [System.IO.File]::WriteAllText($wipDest, $txt, [System.Text.Encoding]::UTF8)
    Write-Host "  [OK] 07_WIP_BOARD.txt (convertido de JSON)" -ForegroundColor Green
    $atualizados++
} else {
    Write-Host "  [FALTANDO] $wipJson" -ForegroundColor Red
    $erros++
}

Write-Host ""
if ($erros -eq 0) {
    Write-Host "BASE atualizada: $atualizados/8 documentos sincronizados." -ForegroundColor Green
    Write-Host ""
    Write-Host "Proximo passo:" -ForegroundColor Yellow
    Write-Host "  Se for iniciar sessao de projeto, rode:" -ForegroundColor Yellow
    Write-Host '  .\scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME]' -ForegroundColor White
} else {
    Write-Host "BASE com erros: $erros documentos nao encontrados." -ForegroundColor Red
    Write-Host "Verifique os caminhos acima e rode novamente." -ForegroundColor Red
}
Write-Host ""