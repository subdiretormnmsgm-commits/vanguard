# validar_formalizador.ps1
# Compara os documentos do Formalizador (CLAUDE_PROJECT/) contra o modelo
# comercial aprovado no WIP_BOARD. Alerta se houver termo nao aprovado.
# Uso: .\scripts\validar_formalizador.ps1
# Roda automaticamente no session_start via hook.

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

param([switch]$Silencioso)

$BASE = Split-Path -Parent $PSScriptRoot
$wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"

if (-not (Test-Path $wipPath)) { exit 0 }

$board    = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$projetos = @($board.board.build)
if ($projetos.Count -eq 0) { exit 0 }

$conflitos = @()

foreach ($proj in $projetos) {
    $cliente    = $proj.cliente
    $projectDir = Join-Path $BASE "CLIENTES\$($cliente.ToUpper())\CLAUDE_PROJECT"
    $instrucao  = Join-Path $projectDir "00_INSTRUCAO_SISTEMA.md"

    if (-not (Test-Path $instrucao)) { continue }

    $conteudo = Get-Content $instrucao -Raw -Encoding UTF8

    # Determinar modelo aprovado
    $modeloStr   = if ($proj.modelo_entrega) { $proj.modelo_entrega } else { "" }
    $ehPagUnico  = $modeloStr -match "pagamento.{0,10}único|sem MRR|unico" -or $proj.valor_fechado -gt 0
    $ehMRR       = $modeloStr -match "MRR|mensal|assinatura"

    $termosProibidos = @()

    if ($ehPagUnico -and -not $ehMRR) {
        # Modelo pagamento único — qualquer recorrência é conflito
        $termos = @(
            "R\$\s*\d+[.,]\d*\s*/\s*m[eê]s",
            "mensalidade",
            "assinatura\s*mensal",
            "\bMRR\b",
            "recorr[eê]nte",
            "cobran[cç]a\s*mensal",
            "plano\s*mensal"
        )
        foreach ($t in $termos) {
            if ($conteudo -match $t) {
                # Verificar se é instrucao negativa (ex: "Nao propor mensalidade")
                $linhas = $conteudo -split "`n" | Where-Object { $_ -match $t }
                foreach ($linha in $linhas) {
                    $ehNegativo = $linha -match "não|nao|nunca|proibido|vedado|sem\s+mensalidade|remove|exclu"
                    if (-not $ehNegativo) {
                        $termosProibidos += $linha.Trim()
                    }
                }
            }
        }
    }

    if ($termosProibidos.Count -gt 0) {
        $conflitos += ""
        $conflitos += "[CONFLITO] $($proj.id) / $cliente — modelo aprovado: pagamento único (sem MRR)"
        $conflitos += "  Termos nao aprovados detectados em CLAUDE_PROJECT/00_INSTRUCAO_SISTEMA.md:"
        foreach ($t in $termosProibidos | Select-Object -Unique) {
            $conflitos += "    > $t"
        }
        $conflitos += "  Acao: corrigir o documento antes de usar o Formalizador com este cliente."
    }
}

if ($conflitos.Count -eq 0) { exit 0 }

$saida = @("VALIDADOR FORMALIZADOR — $(Get-Date -Format 'yyyy-MM-dd')") + $conflitos
$saida += ""
$saida += "[!!] Documentos do Formalizador com termos comerciais nao aprovados."
$saida += "     Corrigir antes de gerar contrato ou pitch para o cliente."

if ($Silencioso) {
    Write-Output ($saida -join "`n")
} else {
    Write-Host ""
    foreach ($linha in $saida) { Write-Host $linha }
    Write-Host ""
}

exit 0
