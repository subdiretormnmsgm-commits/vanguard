# atualizar_notebooklm.ps1
# Empacota os documentos atuais do Pentalateral para o NotebookLM (Auditor)
# Previne Deficiencia 1 do Auditor: Miopia de Contexto / Lost-in-the-Middle
# Uso: .\scripts\atualizar_notebooklm.ps1
# Output: pasta NotebookLM\ com arquivos numerados prontos para upload

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$DEST = "$BASE\NotebookLM"
$DATA = Get-Date -Format "yyyy-MM-dd HH:mm"

New-Item -ItemType Directory -Path $DEST -Force | Out-Null

Write-Host ""
Write-Host "================================================"
Write-Host "  atualizar_notebooklm -- $DATA"
Write-Host "================================================"
Write-Host ""
Write-Host "Destino: NotebookLM\"
Write-Host ""

# ORDEM OBRIGATORIA DE INJECAO NO AUDITOR:
# Fatos concretos do passado ANTES de qualquer nova ideia.
# Nunca inverter esta ordem.

$arquivos = @(
    # CAMADA 1 -- Processo e Constituicao (ancora o Auditor)
    @{ src = ".claude\skills\vanguard-protocolo.md";                                          prefix = "01"; nome = "SKILL_PROTOCOLO_VANGUARD.txt" },
    @{ src = "PENTALATERAL_UNIVERSAL\CONSTITUICAO\MEMORANDO_PENTALATERAL_UNIVERSAL.md";    prefix = "02"; nome = "MEMORANDO_PENTALATERAL_UNIVERSAL.txt" },
    @{ src = "PENTALATERAL_UNIVERSAL\OPERACAO\MANUAL_DIRETOR.md";                           prefix = "03"; nome = "MANUAL_DIRETOR.txt" },

    # CAMADA 2 -- Inteligencia acumulada (principios e historico)
    @{ src = "INTELLIGENCE_LEDGER.md";                                                        prefix = "04"; nome = "INTELLIGENCE_LEDGER.txt" },
    @{ src = "PENTALATERAL_UNIVERSAL\OPERACAO\PROCESSO_EVOLUTIVO_PENTALATERAL.md";         prefix = "05"; nome = "PROCESSO_EVOLUTIVO_PENTALATERAL.txt" },
    @{ src = "PENTALATERAL_UNIVERSAL\TEMPLATES\TEMPLATES_COMUNICACAO_PENTALATERAL.md";     prefix = "06"; nome = "TEMPLATES_COMUNICACAO_PENTALATERAL.txt" },

    # CAMADA 3 -- Estado atual dos projetos
    @{ src = "CLIENTES\WIP_BOARD.json";                                                       prefix = "07"; nome = "WIP_BOARD.txt" },
    @{ src = "CONSELHO\NotebookLM\ANALISE_SOCIO_ATUAL.txt";                                  prefix = "08"; nome = "ANALISE_SOCIO_ATUAL.txt" },

    # CAMADA 4 -- Projeto ativo: VALDECE (atualizar quando mudar de cliente)
    @{ src = "CLIENTES\VALDECE\BRIEFING_DISCOVERY.txt";                                       prefix = "09"; nome = "BRIEFING_DISCOVERY_VALDECE.txt" },
    @{ src = "CLIENTES\VALDECE\HISTORICO\MEMORIA_V1_VALDECE.md";                             prefix = "10"; nome = "MEMORIA_V1_VALDECE.txt" },
    @{ src = "CLIENTES\VALDECE\HISTORICO\relatorio_evolutivo_V1_VALDECE.md";                 prefix = "11"; nome = "RELATORIO_EVOLUTIVO_V1_VALDECE.txt" },
    @{ src = "CLIENTES\VALDECE\HISTORICO\DIRETRIZ ESTRATEGICA V3.txt";                       prefix = "12"; nome = "DIRETRIZ_GEMINI_V3_VALDECE.txt" },
    @{ src = "CLIENTES\VALDECE\PASSO5_NOTEBOOKLM.md";                                        prefix = "13"; nome = "PASSO5_NOTEBOOKLM_VALDECE.txt" },
    @{ src = "CLIENTES\VALDECE\SKILL_PROTOCOLO_VALDECE_V2.md";                               prefix = "14"; nome = "SKILL_PROTOCOLO_VALDECE_V2.txt" },

    # CAMADA 5 -- Alertas e calibracao
    @{ src = "PENTALATERAL_UNIVERSAL\OPERACAO\ALERTA_CONFLITO.md";                          prefix = "15"; nome = "ALERTA_CONFLITO_PROTOCOLO.txt" }
)

$ok  = 0
$err = 0

foreach ($item in $arquivos) {
    $srcPath = Join-Path $BASE $item.src
    $dstPath = Join-Path $DEST "$($item.prefix)_$($item.nome)"

    if (Test-Path $srcPath) {
        Copy-Item $srcPath -Destination $dstPath -Force
        Write-Host "  OK  $($item.prefix) -- $($item.nome)"
        $ok++
    } else {
        Write-Host "  --  nao encontrado: $($item.src)"
        $err++
    }
}

Write-Host ""
Write-Host "================================================"
Write-Host "  $ok copiados  |  $err nao encontrados"
Write-Host "  Total na pasta: $((Get-ChildItem $DEST).Count) arquivos"
Write-Host ""
Write-Host "PROXIMOS PASSOS:"
Write-Host "  1. Abrir NotebookLM e carregar todos os arquivos de NotebookLM\"
Write-Host "  2. Manter a ordem numerada -- ela define o peso de leitura do Auditor"
Write-Host "  3. Colar o conteudo de CLIENTES\[PROJETO]\PASSO5_NOTEBOOKLM.md como prompt"
Write-Host "  4. Ao receber a Skill: validar com skill_parser_gate.ps1 antes de usar"
Write-Host "================================================"
