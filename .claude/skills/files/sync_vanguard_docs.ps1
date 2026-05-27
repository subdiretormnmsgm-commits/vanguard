### sync_vanguard_docs.ps1
### Vanguard Doc Sync -- Script do Musculo
### Versao: 2.3 | Exclusao de PERFIS_NICHO e VANGUARD_HISTORICO por padrao
### Baseado em: P-033 -- Sync universal -> projetos e obrigatorio e imediato
### Fix P-073: PROJECT_ONLY nao sao orfaos -- lidos do DEPENDENCY_MAP v2.0

param(
    [string]$cliente = "",
    [ValidateSet("completo", "verificar")]
    [string]$modo = "completo",
    [switch]$verbose,
    [string]$promover = "",
    [string]$destino = "",
    [string]$deletar = "",
    [string]$incluirNichos = ""
)

### Pastas excluidas do sync universal por padrao
### Para incluir nicho especifico: -incluirNichos MEDICINA | LEGALTECH_PENAL | EDTECH_CONCURSO | CONTABILIDADE | PSICOLOGIA
$PASTAS_EXCLUIDAS = @("PERFIS_NICHO", "VANGUARD_HISTORICO")

### Configuracao
$RAIZ           = (Get-Item -Path ".").FullName
$UNIVERSAL_BASE = Join-Path $RAIZ "PENTALATERAL_UNIVERSAL"
$CLIENTES_DIR   = Join-Path $RAIZ "CLIENTES"
$DATA_HOJE      = Get-Date -Format "yyyyMMdd"
$RELATORIO_PATH = Join-Path $RAIZ "SYNC_REPORT_$DATA_HOJE.md"
$DEPENDENCY_MAP = Join-Path $RAIZ "PENTALATERAL_UNIVERSAL\OPERACAO\DEPENDENCY_MAP.json"

### Carregar padroes PROJECT_ONLY do DEPENDENCY_MAP v2.0
$PADROES_PROJECT_ONLY = @()
if (Test-Path $DEPENDENCY_MAP) {
    try {
        $mapObj = Get-Content $DEPENDENCY_MAP -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($mapObj.documentos -and $mapObj.documentos.PROJECT_ONLY -and $mapObj.documentos.PROJECT_ONLY.padroes) {
            $PADROES_PROJECT_ONLY = @($mapObj.documentos.PROJECT_ONLY.padroes)
        }
    } catch { }
}
if ($PADROES_PROJECT_ONLY.Count -eq 0) {
    ### Fallback hardcoded se DEPENDENCY_MAP v2.0 nao disponivel
    $PADROES_PROJECT_ONLY = @(
        "07_WIP_BOARD.txt","08_ANALISE_SOCIO_ATUAL.txt",
        "09_BRIEFING_DISCOVERY.txt","09_BRIEFING_DISCOVERY.md",
        "10_MEMORIA_RECENTE.md","11_RELATORIO_EVOLUTIVO.md",
        "12_DIRETRIZ_GEMINI.txt","12_DIRETRIZ_GEMINI.md",
        "13_PASSO5_NOTEBOOKLM.md","14_MEMORIA_EMBAIXADOR.md",
        "14_PASSO3_GEMINI_TEMPLATE.md","15_PASSO5_NOTEBOOKLM_TEMPLATE.md",
        "16_ALERTA_CONFLITO.md"
    )
}

function Test-ProjectOnly {
    param([string]$nomeArquivo)
    foreach ($padrao in $PADROES_PROJECT_ONLY) {
        if ($nomeArquivo -like $padrao) { return $true }
    }
    return $false
}

### Arquivos Criticos Dinamicos na Raiz
$ARQUIVOS_CRITICOS_RAIZ = @(
    "WIP_BOARD.json",
    "INTELLIGENCE_LEDGER.md",
    "VANGUARD_TIMELINE.md",
    "CONSELHO\NotebookLM\ANALISE_SOCIO_ATUAL.txt"
)

### Funcoes Auxiliares
function Get-FileHash256 {
    param([string]$path)
    if (Test-Path $path) { return (Get-FileHash -Path $path -Algorithm SHA256).Hash }
    return $null
}
function Write-Log {
    param([string]$msg, [string]$cor = "White")
    Write-Host $msg -ForegroundColor $cor
}
function Write-Relatorio {
    param([string]$linha)
    Add-Content -Path $RELATORIO_PATH -Value $linha -Encoding UTF8
}
function Test-PastaExcluida {
    param([string]$caminho)
    foreach ($pasta in $PASTAS_EXCLUIDAS) {
        if ($caminho -like "*\$pasta\*" -or $caminho -like "*\$pasta") { return $true }
    }
    return $false
}
function Get-NumeradoDestino {
    # Retorna o caminho do arquivo ##_<nome> se existir; caso contrario, retorna caminho bare.
    # Evita criar copias bare quando ja existe versao numerada para o NotebookLM.
    param([string]$fontes_dir, [string]$nome)
    $pattern = '^[0-9]{2}_' + [regex]::Escape($nome) + '$'
    $numerado = Get-ChildItem $fontes_dir -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -match $pattern } |
                Select-Object -First 1
    if ($numerado) { return $numerado.FullName }
    return (Join-Path $fontes_dir $nome)
}

### Acoes Especiais
if ($promover -ne "") {
    if ($destino -eq "") { Write-Log "ERRO: -destino obrigatorio ao usar -promover." "Red"; exit 1 }
    $destino_completo = Join-Path $RAIZ $destino
    if (-not (Test-Path $destino_completo)) { New-Item -ItemType Directory -Path $destino_completo -Force | Out-Null }
    Copy-Item -Path $promover -Destination $destino_completo -Force
    Write-Log "PROMOVIDO: $promover -> $destino_completo" "Green"
    exit 0
}
if ($deletar -ne "") {
    $alvo = Join-Path $RAIZ $deletar
    if (Test-Path $alvo) { Remove-Item -Path $alvo -Force; Write-Log "DELETADO: $alvo" "Yellow" }
    else { Write-Log "Arquivo nao encontrado: $alvo" "Yellow" }
    exit 0
}

### Validacao
if (-not (Test-Path $UNIVERSAL_BASE)) { Write-Log "BLOQUEIO: PENTALATERAL_UNIVERSAL nao encontrada." "Red"; exit 1 }
if (-not (Test-Path $CLIENTES_DIR))   { Write-Log "BLOQUEIO: CLIENTES nao encontrada." "Red"; exit 1 }

if (Test-Path $RELATORIO_PATH) { Remove-Item $RELATORIO_PATH }
Write-Relatorio "# VANGUARD DOC SYNC -- RELATORIO $DATA_HOJE"
Write-Relatorio "> P-033 -- Sync universal -> projetos e obrigatorio e imediato"
Write-Relatorio "> Pastas excluidas: $($PASTAS_EXCLUIDAS -join ', ')"
if ($incluirNichos -ne "") { Write-Relatorio "> Nicho incluido: $incluirNichos" }
Write-Relatorio ""

$projetos = @()
if ($cliente -ne "") {
    $proj_path = Join-Path $CLIENTES_DIR $cliente
    if (Test-Path $proj_path) { $projetos = @($proj_path) }
    else { Write-Log "Projeto '$cliente' nao encontrado." "Red"; exit 1 }
} else {
    $projetos = Get-ChildItem -Path $CLIENTES_DIR -Directory | ForEach-Object { $_.FullName }
}

Write-Log "==================================================" "Cyan"
Write-Log "  VANGUARD DOC SYNC -- $DATA_HOJE (Modo: $modo)" "Cyan"
if ($incluirNichos -ne "") { Write-Log "  Nicho: $incluirNichos" "Cyan" }
Write-Log "==================================================" "Cyan"

### Rodada 1 -- Inventario
Write-Log "RODADA 1 -- INVENTARIO" "Yellow"

### Coleta de arquivos: exclui PERFIS_NICHO e VANGUARD_HISTORICO por padrao
$arquivos_universais = Get-ChildItem -Path $UNIVERSAL_BASE -Recurse -File | Where-Object {
    $_.Extension -match "\.(md|txt)$" -and -not (Test-PastaExcluida $_.FullName)
}

$lista_fontes_origem = @()
foreach ($arq in $arquivos_universais) {
    $lista_fontes_origem += [PSCustomObject]@{ Nome = $arq.Name; Caminho = $arq.FullName }
}

### Inclui nicho especifico se solicitado
if ($incluirNichos -ne "") {
    $nicho_path = Join-Path $UNIVERSAL_BASE "PERFIS_NICHO\$incluirNichos"
    if (Test-Path $nicho_path) {
        $arqs_nicho = Get-ChildItem -Path $nicho_path -Recurse -File | Where-Object { $_.Extension -match "\.(md|txt)$" }
        foreach ($arq in $arqs_nicho) {
            $lista_fontes_origem += [PSCustomObject]@{ Nome = $arq.Name; Caminho = $arq.FullName }
        }
        Write-Log "  Nicho incluido: $incluirNichos ($($arqs_nicho.Count) arquivos extras)" "Cyan"
    } else {
        Write-Log "  AVISO: Nicho '$incluirNichos' nao encontrado em PERFIS_NICHO/" "Yellow"
    }
}

### Criticos da raiz
foreach ($arq_critico in $ARQUIVOS_CRITICOS_RAIZ) {
    $caminho_critico = Join-Path $RAIZ $arq_critico
    if (Test-Path $caminho_critico) {
        $lista_fontes_origem += [PSCustomObject]@{ Nome = (Split-Path $arq_critico -Leaf); Caminho = $caminho_critico }
    }
}

$total_universal = $lista_fontes_origem.Count
Write-Log "  Arquivos fontes a espelhar: $total_universal (excluindo: $($PASTAS_EXCLUIDAS -join ', '))" "White"

$inventario = @{}
$contadores  = @{ SYNC=0; DESATUAL=0; AUSENTE=0; ORFAO=0; PROJECT_ONLY=0 }

foreach ($proj_path in $projetos) {
    $proj_nome = Split-Path $proj_path -Leaf
    $fontes_dir = Join-Path $proj_path "NOTEBOOKLM_FONTES"
    if (-not (Test-Path $fontes_dir)) { New-Item -ItemType Directory -Path $fontes_dir -Force | Out-Null }

    foreach ($fonte in $lista_fontes_origem) {
        $arq_destino = Get-NumeradoDestino $fontes_dir $fonte.Nome
        $chave = "$proj_nome|$($fonte.Nome)"

        if (-not (Test-Path $arq_destino)) {
            $inventario[$chave] = "AUSENTE"; $contadores.AUSENTE++
        } else {
            if ((Get-FileHash256 $fonte.Caminho) -eq (Get-FileHash256 $arq_destino)) {
                $inventario[$chave] = "SYNC"; $contadores.SYNC++
            } else {
                $inventario[$chave] = "DESATUAL"; $contadores.DESATUAL++
            }
        }
    }

    $arquivos_projeto = Get-ChildItem -Path $fontes_dir -File
    foreach ($arq_proj in $arquivos_projeto) {
        # Strip prefixo ##_ para comparar com nome da fonte original
        $nomeBase = $arq_proj.Name -replace '^[0-9]{2}_', ''
        $existe_na_origem = $lista_fontes_origem | Where-Object { $_.Nome -eq $arq_proj.Name -or $_.Nome -eq $nomeBase }
        if (-not $existe_na_origem) {
            $chave = "$proj_nome|$($arq_proj.Name)"
            # PROJECT_ONLY nao sao orfaos -- gerados por processo, nao tem origem em UNIVERSAL
            if ((Test-ProjectOnly $arq_proj.Name) -or (Test-ProjectOnly $nomeBase)) {
                $inventario[$chave] = "PROJECT_ONLY"; $contadores.PROJECT_ONLY++
            } else {
                $inventario[$chave] = "ORFAO"; $contadores.ORFAO++
            }
        }
    }
}

Write-Log ""
Write-Log "  RESUMO RODADA 1:" "White"
Write-Log "  SYNC:          $($contadores.SYNC)" "Green"
Write-Log "  DESATUALIZADO: $($contadores.DESATUAL)" "Yellow"
Write-Log "  AUSENTE:       $($contadores.AUSENTE)" "Red"
Write-Log "  ORFAO:         $($contadores.ORFAO)" "Magenta"
Write-Log "  PROJECT_ONLY:  $($contadores.PROJECT_ONLY) (gerados por processo -- nao sao orfaos)" "DarkGray"

if ($modo -eq "verificar") {
    Write-Log ""
    Write-Log "  Modo 'verificar' - Rodadas 2 e 3 nao executadas." "Gray"
    Write-Relatorio "## VERIFICACAO"
    Write-Relatorio "- SYNC: $($contadores.SYNC)"
    Write-Relatorio "- DESATUALIZADO: $($contadores.DESATUAL)"
    Write-Relatorio "- AUSENTE: $($contadores.AUSENTE)"
    Write-Relatorio "- ORFAO: $($contadores.ORFAO)"
    Write-Log "  Relatorio salvo em: $RELATORIO_PATH" "Cyan"
    exit 0
}

### Rodada 2 -- Sincronizacao
Write-Log ""
Write-Log "RODADA 2 -- SINCRONIZACAO" "Yellow"

$sincronizados = 0
$falhas = 0

foreach ($proj_path in $projetos) {
    $proj_nome  = Split-Path $proj_path -Leaf
    $fontes_dir = Join-Path $proj_path "NOTEBOOKLM_FONTES"

    foreach ($fonte in $lista_fontes_origem) {
        $chave       = "$proj_nome|$($fonte.Nome)"
        $arq_destino = Get-NumeradoDestino $fontes_dir $fonte.Nome

        if ($inventario[$chave] -in @("DESATUAL")) {
            # AUSENTE e ignorado: NOTEBOOKLM_FONTES so recebe novos arquivos via preparar_notebooklm_projeto.ps1
            Copy-Item -Path $fonte.Caminho -Destination $arq_destino -Force
            $sincronizados++
            if ($verbose) { Write-Log "  SYNC: $proj_nome\$($fonte.Nome)" "Green" }
            if ((Get-FileHash256 $fonte.Caminho) -ne (Get-FileHash256 $arq_destino)) {
                $falhas++
                Write-Log "  FALHA hash pos-copia: $arq_destino" "Red"
            }
        }
    }
}

Write-Log "  Sincronizados nesta rodada: $sincronizados" "Green"
Write-Log ""
Write-Log "RODADA 3 -- VERIFICACAO DE INTEGRIDADE" "Yellow"
Write-Log "  Verificados: $($contadores.SYNC + $sincronizados) | Falhas: $falhas" "White"

$integridade = if ($falhas -gt 0) { "VERMELHO" } elseif ($contadores.ORFAO -gt 0) { "AMARELO" } else { "VERDE" }

Write-Log ""
Write-Log "==================================================" "Cyan"
Write-Log "  SYNC CONCLUIDO -- $DATA_HOJE" "Cyan"
Write-Log "==================================================" "Cyan"
Write-Log "  INTEGRIDADE: $integridade" $(if($integridade -eq 'VERDE'){"Green"}elseif($integridade -eq 'AMARELO'){"Yellow"}else{"Red"})
Write-Log ""
Write-Log "  Sync:      $sincronizados arquivos" "White"
Write-Log "  Orfaos:    $($contadores.ORFAO) arquivo(s)" $(if($contadores.ORFAO -gt 0){"Yellow"}else{"Green"})
Write-Log ""
Write-Log "  Relatorio: $RELATORIO_PATH" "Cyan"
Write-Log "==================================================" "Cyan"

Write-Relatorio "## STATUS FINAL"
Write-Relatorio "- Sincronizados: $sincronizados"
Write-Relatorio "- Falhas de Integridade: $falhas"
Write-Relatorio "- Orfaos: $($contadores.ORFAO)"
Write-Relatorio "- Project_Only (nao sao orfaos): $($contadores.PROJECT_ONLY)"

if ($contadores.ORFAO -gt 0) {
    Write-Relatorio "## DECISOES PENDENTES (ORFAOS REAIS)"
    foreach ($key in $inventario.Keys | Where-Object { $inventario[$_] -eq "ORFAO" }) {
        Write-Relatorio "- $key"
    }
}

if ($contadores.PROJECT_ONLY -gt 0 -and $verbose) {
    Write-Relatorio "## PROJECT_ONLY (gerados por processo -- sem acao necessaria)"
    foreach ($key in $inventario.Keys | Where-Object { $inventario[$_] -eq "PROJECT_ONLY" }) {
        Write-Relatorio "- $key"
    }
}
