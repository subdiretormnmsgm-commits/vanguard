# verificar_projeto.ps1 -- P-041: Checklist de Setup de Projeto
# Valida os 6 artefatos obrigatorios antes de declarar projeto pronto.
# Uso: .\scripts\verificar_projeto.ps1 -cliente INGRID

param(
    [Parameter(Mandatory=$true)]
    [string]$cliente
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE       = Split-Path -Parent $PSScriptRoot
$clienteDir = Join-Path $BASE "CLIENTES\$($cliente.ToUpper())"

if (-not (Test-Path $clienteDir)) {
    Write-Host ""
    Write-Host "  ERRO: Projeto '$cliente' nao encontrado em CLIENTES\." -ForegroundColor Red
    exit 1
}

$artefatos = @(
    @{ nome = "PASSO3_GEMINI.md";        path = Join-Path $clienteDir "PASSO3_GEMINI.md";                       descricao = "Instrucoes para o Estrategista (Gemini)" },
    @{ nome = "PASSO5_NOTEBOOKLM.md";    path = Join-Path $clienteDir "PASSO5_NOTEBOOKLM.md";                   descricao = "Instrucoes para o Auditor (NotebookLM)" },
    @{ nome = "PASSO6_MUSCULO.md";       path = Join-Path $clienteDir "PASSO6_MUSCULO.md";                      descricao = "Instrucoes para o Musculo (Claude)" },
    @{ nome = "PASSO7_EMBAIXADOR.md";    path = Join-Path $clienteDir "PASSO7_EMBAIXADOR.md";                   descricao = "Instrucoes + formato de resposta do Embaixador" },
    @{ nome = "00_INSTRUCAO_SISTEMA.md"; path = Join-Path $clienteDir "CLAUDE_PROJECT\00_INSTRUCAO_SISTEMA.md"; descricao = "Instrucao do Sistema (Claude Projects)" },
    @{ nome = "MEMORIA_EMBAIXADOR.md";   path = Join-Path $clienteDir "CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md";   descricao = "Memoria acumulada do cliente pelo Embaixador" }
)

Write-Host ""
Write-Host "  =============================================" -ForegroundColor Cyan
Write-Host "  VERIFICACAO DE SETUP -- $($cliente.ToUpper())" -ForegroundColor Cyan
Write-Host "  P-041: 6 artefatos obrigatorios"              -ForegroundColor Cyan
Write-Host "  =============================================" -ForegroundColor Cyan
Write-Host ""

$faltando  = 0
$presentes = 0

foreach ($a in $artefatos) {
    if (Test-Path $a.path) {
        $tamanho = (Get-Item $a.path).Length
        if ($tamanho -lt 200) {
            Write-Host "  [VAZIO ] $($a.nome)" -ForegroundColor Yellow
            Write-Host "           $($a.descricao)" -ForegroundColor DarkGray
            Write-Host "           ATENCAO: existe mas parece vazio ou com placeholder." -ForegroundColor Yellow
            $faltando++
        } else {
            Write-Host "  [OK    ] $($a.nome)" -ForegroundColor Green
            $presentes++
        }
    } else {
        Write-Host "  [FALTA ] $($a.nome)" -ForegroundColor Red
        Write-Host "           $($a.descricao)" -ForegroundColor DarkGray
        $faltando++
    }
}

Write-Host ""
Write-Host "  Presentes : $presentes / $($artefatos.Count)" -ForegroundColor White

if ($faltando -eq 0) {
    Write-Host "  Faltando  : 0" -ForegroundColor Green
    Write-Host ""
    Write-Host "  SETUP COMPLETO. Projeto pronto para operar." -ForegroundColor Green
} else {
    Write-Host "  Faltando  : $faltando" -ForegroundColor Red
    Write-Host ""
    Write-Host "  SETUP INCOMPLETO. Musculo deve criar os artefatos faltantes." -ForegroundColor Red
    Write-Host "  Template: PENTALATERAL_UNIVERSAL\OPERACAO\PASSO7_EMBAIXADOR_TEMPLATE.md" -ForegroundColor Yellow
}

Write-Host ""
