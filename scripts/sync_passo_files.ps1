# sync_passo_files.ps1
# Sincroniza automaticamente todos os arquivos PASSO de projetos ativos.
# Executar antes de qualquer sessao com Gemini ou NotebookLM.

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot
$DATA = Get-Date -Format "yyyy-MM-dd"
$HOJE = [datetime]::Today

Write-Host ""
Write-Host "=============================================="
Write-Host "  SYNC PASSO FILES -- Pentalateral IAH"
Write-Host "  Data: $DATA"
Write-Host "=============================================="
Write-Host ""

# 1. Descobrir maior principio ativo no LEDGER
$ledgerPath    = Join-Path $BASE "INTELLIGENCE_LEDGER.md"
$ledgerContent = Get-Content $ledgerPath -Raw -Encoding UTF8
$pMatches      = [regex]::Matches($ledgerContent, '\[P-(\d+)\]')
$maxP          = 0
foreach ($m in $pMatches) {
    $n = [int]$m.Groups[1].Value
    if ($n -gt $maxP) { $maxP = $n }
}
$pRange = "P-001 a P-$('{0:D3}' -f $maxP)"
Write-Host "  Principio mais alto no LEDGER: P-$maxP"

# 2. Varrer projetos em BUILD e CHECK
$wipPath  = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
$board    = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$projetos = @($board.board.build) + @($board.board.check)

foreach ($proj in $projetos) {
    $cliente    = $proj.cliente.ToUpper()
    $clienteDir = Join-Path $BASE "CLIENTES\$cliente"
    $deadline   = $proj.deadline

    Write-Host ""
    Write-Host "  Projeto: $($proj.id) -- $($proj.cliente)" -ForegroundColor Cyan

    # Calcular dias restantes
    $diasRestantes = ""
    if ($deadline) {
        $dl            = [datetime]::Parse($deadline)
        $diff          = ($dl - $HOJE).Days
        $diasRestantes = "$diff dias restantes"
    }

    # Descobrir proxima versao de DIRETRIZ
    $diretrizes = Get-ChildItem "$clienteDir\DIRETRIZ_GEMINI_V*.txt" -ErrorAction SilentlyContinue |
                  Sort-Object Name
    $proximaV   = 1
    if ($diretrizes) {
        $ultNome  = ($diretrizes | Select-Object -Last 1).Name
        $ultV     = [regex]::Match($ultNome, 'V(\d+)').Groups[1].Value
        $proximaV = [int]$ultV + 1
    }
    $proximaDiretriz = "DIRETRIZ_GEMINI_V${proximaV}.txt"
    $dirExiste       = Test-Path "$clienteDir\DIRETRIZ_GEMINI_V${proximaV}.txt"

    # Arquivos PASSO a sincronizar
    $passoFiles = @(
        "$clienteDir\PASSO3_GEMINI.md",
        "$clienteDir\PASSO5_NOTEBOOKLM.md",
        "$clienteDir\NOTEBOOKLM_FONTES\13_PASSO5_NOTEBOOKLM.md"
    )

    foreach ($passo in $passoFiles) {
        if (-not (Test-Path $passo)) { continue }

        $nome     = Split-Path $passo -Leaf
        $original = Get-Content $passo -Raw -Encoding UTF8
        $c        = $original
        $mudancas = @()

        # Atualizar data
        $novo = $c -replace 'Atualizado pelo M[uú]sculo em \d{4}-\d{2}-\d{2}', "Atualizado pelo Musculo em $DATA"
        if ($novo -ne $c) { $mudancas += "data -> $DATA"; $c = $novo }

        # Atualizar range de principios (P-001 a P-XXX)
        $novo = $c -replace 'P-001 a P-\d{3}', $pRange
        if ($novo -ne $c) { $mudancas += "principios -> $pRange"; $c = $novo }

        # Nomenclatura Quadrilateral -> Pentalateral IAH
        $novo = $c -replace 'Quadrilateral IAH V\d+', 'Pentalateral IAH'
        $novo = $novo -replace 'Quadrilateral IAH', 'Pentalateral IAH'
        if ($novo -ne $c) { $mudancas += "nomenclatura -> Pentalateral IAH"; $c = $novo }

        # V25 residual em contexto "V25 --" ou "(V25)"
        $novo = $c -replace '\(V25\)', '(Pentalateral IAH)'
        $novo = $novo -replace 'V25 --', 'Pentalateral IAH --'
        if ($novo -ne $c) { $mudancas += "V25 -> Pentalateral IAH"; $c = $novo }

        # Dias restantes
        if ($diasRestantes) {
            $novo = $c -replace '\(\d+ dias restantes[^)]*\)', "($diasRestantes)"
            if ($novo -ne $c) { $mudancas += "prazo -> $diasRestantes"; $c = $novo }
        }

        # Versao da DIRETRIZ
        $mDir = [regex]::Match($c, 'DIRETRIZ_GEMINI_V(\d+)\.txt')
        if ($mDir.Success) {
            $vAtual = [int]$mDir.Groups[1].Value
            if ($vAtual -lt $proximaV) {
                $c = $c -replace "DIRETRIZ_GEMINI_V${vAtual}\.txt", $proximaDiretriz
                $mudancas += "DIRETRIZ V${vAtual} -> V${proximaV}"
            }
        }

        # Checkbox da DIRETRIZ
        if ($dirExiste) {
            $novo = $c -replace "\[ \] 1\. $([regex]::Escape($proximaDiretriz))", "[x] 1. $proximaDiretriz"
            if ($novo -ne $c) { $mudancas += "DIRETRIZ V${proximaV} marcada [x]"; $c = $novo }
        } else {
            $novo = $c -replace "\[x\] 1\. $([regex]::Escape($proximaDiretriz))", "[ ] 1. $proximaDiretriz"
            if ($novo -ne $c) { $mudancas += "DIRETRIZ V${proximaV} desmarcada [ ]"; $c = $novo }
        }

        # Salvar se mudou
        if ($c -ne $original) {
            Set-Content $passo -Value $c -Encoding UTF8
            Write-Host "  [SYNC] $nome" -ForegroundColor Green
            foreach ($m in $mudancas) { Write-Host "         + $m" -ForegroundColor Gray }
        } else {
            Write-Host "  [OK]   $nome -- sem alteracoes" -ForegroundColor DarkGray
        }
    }
}

Write-Host ""
Write-Host "  Sync concluido. PASSOs atualizados." -ForegroundColor Green

# ============================================================
# 3. SYNC UNIVERSAL -> PROJETOS (P-033)
#    QUADRILATERAL_UNIVERSAL/NOTEBOOKLM_BASE/ -> CLIENTES/[NOME]/NOTEBOOKLM_FONTES/
# ============================================================
Write-Host ""
Write-Host "  Sincronizando documentos universais -> projetos (P-033)..."

$baseDir     = Join-Path $BASE "QUADRILATERAL_UNIVERSAL\NOTEBOOKLM_BASE"
$timelineSrc = Join-Path $BASE "QUADRILATERAL_UNIVERSAL\HISTORICO\VANGUARD_TIMELINE.md"
$wipSrc      = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
$socioSrc    = Join-Path $BASE "CONSELHO\NotebookLM\ANALISE_SOCIO_ATUAL.txt"

$baseNomes = @(
    "01_SKILL_PROTOCOLO_VANGUARD",
    "02_MEMORANDO_QUADRILATERAL",
    "03_MANUAL_DIRETOR",
    "04_INTELLIGENCE_LEDGER",
    "05_PROCESSO_EVOLUTIVO",
    "06_TEMPLATES_COMUNICACAO"
)

foreach ($proj in $projetos) {
    $cliente   = $proj.cliente.ToUpper()
    $fontesDir = Join-Path $BASE "CLIENTES\$cliente\NOTEBOOKLM_FONTES"
    if (-not (Test-Path $fontesDir)) { continue }

    # Detectar extensao do projeto
    $usaMd = Test-Path "$fontesDir\01_SKILL_PROTOCOLO_VANGUARD.md"
    $ext   = if ($usaMd) { ".md" } else { ".txt" }

    Write-Host ""
    Write-Host "  Projeto: $cliente  [ext=$ext]" -ForegroundColor Cyan

    # Docs 01-06 da base universal
    foreach ($nome in $baseNomes) {
        $srcArq = "$baseDir\${nome}.md"
        $dstArq = "$fontesDir\${nome}${ext}"
        if (-not (Test-Path $srcArq)) { continue }

        $conteudo = [System.IO.File]::ReadAllText($srcArq, [System.Text.Encoding]::UTF8)
        $conteudo = $conteudo.Replace('Quadrilateral IAH', 'Pentalateral IAH')
        $conteudo = $conteudo.Replace('agora com 4 membros', 'agora com 5 membros')

        $escrever = $true
        if (Test-Path $dstArq) {
            $atual = [System.IO.File]::ReadAllText($dstArq, [System.Text.Encoding]::UTF8)
            if ($atual -eq $conteudo) { $escrever = $false }
        }
        if ($escrever) {
            [System.IO.File]::WriteAllText($dstArq, $conteudo, [System.Text.Encoding]::UTF8)
            Write-Host "    [SYNC] $nome$ext" -ForegroundColor Green
        } else {
            Write-Host "    [OK]   $nome$ext" -ForegroundColor DarkGray
        }
    }

    # 07_WIP_BOARD.txt
    if (Test-Path $wipSrc) {
        $wipConteudo = [System.IO.File]::ReadAllText($wipSrc, [System.Text.Encoding]::UTF8)
        $wipDst = "$fontesDir\07_WIP_BOARD.txt"
        $escrever = $true
        if (Test-Path $wipDst) {
            $atual = [System.IO.File]::ReadAllText($wipDst, [System.Text.Encoding]::UTF8)
            if ($atual -eq $wipConteudo) { $escrever = $false }
        }
        if ($escrever) {
            [System.IO.File]::WriteAllText($wipDst, $wipConteudo, [System.Text.Encoding]::UTF8)
            Write-Host "    [SYNC] 07_WIP_BOARD.txt" -ForegroundColor Green
        } else {
            Write-Host "    [OK]   07_WIP_BOARD.txt" -ForegroundColor DarkGray
        }
    }

    # 08_ANALISE_SOCIO_ATUAL.txt
    if (Test-Path $socioSrc) {
        $socioConteudo = [System.IO.File]::ReadAllText($socioSrc, [System.Text.Encoding]::UTF8)
        $socioConteudo = $socioConteudo.Replace('Quadrilateral IAH', 'Pentalateral IAH')
        $socioDst = "$fontesDir\08_ANALISE_SOCIO_ATUAL.txt"
        $escrever = $true
        if (Test-Path $socioDst) {
            $atual = [System.IO.File]::ReadAllText($socioDst, [System.Text.Encoding]::UTF8)
            if ($atual -eq $socioConteudo) { $escrever = $false }
        }
        if ($escrever) {
            [System.IO.File]::WriteAllText($socioDst, $socioConteudo, [System.Text.Encoding]::UTF8)
            Write-Host "    [SYNC] 08_ANALISE_SOCIO_ATUAL.txt" -ForegroundColor Green
        } else {
            Write-Host "    [OK]   08_ANALISE_SOCIO_ATUAL.txt" -ForegroundColor DarkGray
        }
    }

    # VANGUARD_TIMELINE (arquivo variavel por projeto)
    if (Test-Path $timelineSrc) {
        $tlConteudo = [System.IO.File]::ReadAllText($timelineSrc, [System.Text.Encoding]::UTF8)
        $tlConteudo = $tlConteudo.Replace('Quadrilateral IAH', 'Pentalateral IAH')
        $tlArqs = Get-ChildItem $fontesDir -Filter "*VANGUARD_TIMELINE*" -ErrorAction SilentlyContinue
        if ($tlArqs) {
            $tlDst = $tlArqs[0].FullName
            $atual = [System.IO.File]::ReadAllText($tlDst, [System.Text.Encoding]::UTF8)
            if ($atual -ne $tlConteudo) {
                [System.IO.File]::WriteAllText($tlDst, $tlConteudo, [System.Text.Encoding]::UTF8)
                Write-Host "    [SYNC] VANGUARD_TIMELINE" -ForegroundColor Green
            } else {
                Write-Host "    [OK]   VANGUARD_TIMELINE" -ForegroundColor DarkGray
            }
        }
    }
}

Write-Host ""
Write-Host "  Sync universal concluido." -ForegroundColor Green
Write-Host ""
