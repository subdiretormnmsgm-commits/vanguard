# atualizar_notebooklm_base.ps1
# Quadrilateral IAH — V25
#
# QUANDO RODAR: sempre que qualquer documento universal evoluir.
# - Após atualizar SKILL_PROTOCOLO_VANGUARD.md
# - Após sessão que gera novos princípios no INTELLIGENCE_LEDGER
# - Após Eduardo atualizar ANALISE_SOCIO_ATUAL.txt (pós-NotebookLM)
# - Após atualizar WIP_BOARD.json (novo projeto ou mudança de status)
#
# O QUE FAZ: sincroniza QUADRILATERAL_UNIVERSAL/NOTEBOOKLM_BASE/
# com os documentos fonte originais. A BASE é sempre espelho atualizado.
#
# USO:
#   .\scripts\atualizar_notebooklm_base.ps1

$ErrorActionPreference = "Stop"

$raiz  = $PSScriptRoot | Split-Path -Parent
$dest  = "$raiz\QUADRILATERAL_UNIVERSAL\NOTEBOOKLM_BASE"

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " QUADRILATERAL IAH — Atualizar NotebookLM BASE   " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$documentos = @(
    @{ Num = "01"; Nome = "SKILL_PROTOCOLO_VANGUARD.md";      Origem = "$raiz\QUADRILATERAL_UNIVERSAL\OPERACAO\SKILL_PROTOCOLO_VANGUARD.md" },
    @{ Num = "02"; Nome = "MEMORANDO_QUADRILATERAL.md";       Origem = "$raiz\QUADRILATERAL_UNIVERSAL\CONSTITUICAO\MEMORANDO_QUADRILATERAL_UNIVERSAL.md" },
    @{ Num = "03"; Nome = "MANUAL_DIRETOR.md";                Origem = "$raiz\QUADRILATERAL_UNIVERSAL\OPERACAO\MANUAL_DIRETOR.md" },
    @{ Num = "04"; Nome = "INTELLIGENCE_LEDGER.md";           Origem = "$raiz\INTELLIGENCE_LEDGER.md" },
    @{ Num = "05"; Nome = "PROCESSO_EVOLUTIVO.md";            Origem = "$raiz\QUADRILATERAL_UNIVERSAL\OPERACAO\PROCESSO_EVOLUTIVO_QUADRILATERAL.md" },
    @{ Num = "06"; Nome = "TEMPLATES_COMUNICACAO.md";         Origem = "$raiz\QUADRILATERAL_UNIVERSAL\TEMPLATES\TEMPLATES_COMUNICACAO_QUADRILATERAL.md" },
    @{ Num = "07"; Nome = "WIP_BOARD.json";                   Origem = "$raiz\CLIENTES\WIP_BOARD.json" },
    @{ Num = "08"; Nome = "ANALISE_SOCIO_ATUAL.txt";          Origem = "$raiz\CONSELHO\NotebookLM\ANALISE_SOCIO_ATUAL.txt" }
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

Write-Host ""
if ($erros -eq 0) {
    Write-Host "BASE atualizada: $atualizados/8 documentos sincronizados." -ForegroundColor Green
    Write-Host ""
    Write-Host "Proximo passo:" -ForegroundColor Yellow
    Write-Host "  Se for iniciar sessao de projeto, rode:" -ForegroundColor Yellow
    Write-Host "  .\scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME]" -ForegroundColor White
} else {
    Write-Host "BASE com erros: $erros documentos nao encontrados." -ForegroundColor Red
    Write-Host "Verifique os caminhos acima e rode novamente." -ForegroundColor Red
}
Write-Host ""
