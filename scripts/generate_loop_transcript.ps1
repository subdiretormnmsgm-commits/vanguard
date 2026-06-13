#Requires -Version 5.1
# generate_loop_transcript.ps1
# M-2 Loop 33 -- Gera LOOP_TRANSCRIPT_V[N].md ao fechar sessao (anti-amnesia)
# Captura: ideias M/G/N/E com disposicao final + arquivos criados + skills usadas
# Destino: CLIENTES/[CLIENTE]/HISTORICO/LOOP_TRANSCRIPT_V[N].md
# Integrado ao session_close.ps1 (P-141 LOOP TRANSCRIPT)

param(
    [Parameter(Mandatory=$true)]
    [string]$Cliente,

    [int]$Loop = 0,

    [switch]$DryRun
)

$raiz = Split-Path $PSScriptRoot -Parent
$clienteUpper = $Cliente.ToUpper()
$data = Get-Date -Format "yyyy-MM-dd"
$hora = Get-Date -Format "HH:mm"

# --- LOCALIZAR LOOP_STATE ---
$loopStatePath = "$raiz\CLIENTES\$clienteUpper\CLAUDE_PROJECT\LOOP_STATE.json"
if (-not (Test-Path $loopStatePath)) {
    Write-Host "[ERRO] LOOP_STATE nao encontrado para $clienteUpper" -ForegroundColor Red
    exit 2
}
$ls = Get-Content $loopStatePath -Raw -Encoding UTF8 | ConvertFrom-Json
if ($Loop -eq 0) { $Loop = $ls.loop_atual }

$historico = "$raiz\CLIENTES\$clienteUpper\HISTORICO"
$outputPath = "$historico\LOOP_TRANSCRIPT_V$($Loop)_$($clienteUpper.ToLower()).md"

Write-Host "[M-2] Gerando LOOP_TRANSCRIPT_V$Loop -- $clienteUpper" -ForegroundColor Cyan

# --- SECAO 1: MISSAO ---
$missao = if ($ls.missao) { $ls.missao } else { "(missao nao registrada)" }

# --- SECAO 2: IDEIAS POR SOCIO ---
# Tentar ler DELIBERACAO_LOOP primeiro (fonte mais completa)
$deliberacaoFile = Get-ChildItem $historico -Filter "DELIBERACAO_LOOP_V$Loop*" -ErrorAction SilentlyContinue |
                   Sort-Object LastWriteTime -Descending | Select-Object -First 1

$ideiasSocios = @{}
$sintese = ""

if ($deliberacaoFile) {
    $deliberacaoConteudo = Get-Content $deliberacaoFile.FullName -Raw -Encoding UTF8
    # Extrair sintese
    if ($deliberacaoConteudo -match "(?s)## SINTESE P-037(.+?)(?=\n## |\z)") {
        $sintese = $matches[1].Trim()
        if ($sintese.Length -gt 500) { $sintese = $sintese.Substring(0, 497) + "..." }
    }
}

# Extrair M-1..M-5 do PASSO3_GEMINI.md
$passo3Path = "$raiz\CLIENTES\$clienteUpper\PASSO3_GEMINI.md"
if (Test-Path $passo3Path) {
    $passo3 = Get-Content $passo3Path -Raw -Encoding UTF8
    $ideiasM = [System.Collections.Generic.List[string]]::new()
    $matches2 = [regex]::Matches($passo3, "(?m)^\*{0,2}\[M-(\d+)\]\*{0,2}[:\s]*(.+?)(?=\n\*{0,2}\[M-|\n\n|\z)")
    foreach ($m in $matches2) {
        $num = $m.Groups[1].Value
        $texto = $m.Groups[2].Value.Trim() -replace "\*", ""
        if ($texto.Length -gt 120) { $texto = $texto.Substring(0, 117) + "..." }
        $ideiasM.Add("M-$num | $texto")
    }
    # Fallback: linhas com M-N
    if ($ideiasM.Count -eq 0) {
        $linhasM = ($passo3 -split "`n") | Where-Object { $_ -match "^\s*M-\d+" } | Select-Object -First 5
        foreach ($l in $linhasM) { $ideiasM.Add($l.Trim()) }
    }
    if ($ideiasM.Count -gt 0) { $ideiasSocios["MUSCULO"] = $ideiasM }
}

# Extrair G-1..G-5 da DIRETRIZ
$diretrizes = Get-ChildItem "$raiz\CLIENTES\$clienteUpper\NOTEBOOKLM_FONTES" `
              -Filter "*DIRETRIZ_GEMINI_V$Loop*" -ErrorAction SilentlyContinue
if (-not $diretrizes) {
    $diretrizes = Get-ChildItem "$raiz\CLIENTES\$clienteUpper\NOTEBOOKLM_FONTES" `
                  -Filter "*DIRETRIZ*V$Loop*" -ErrorAction SilentlyContinue
}
if ($diretrizes) {
    $diretrizes = $diretrizes | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $diretrizConteudo = Get-Content $diretrizes.FullName -Raw -Encoding UTF8
    $ideiasG = [System.Collections.Generic.List[string]]::new()
    $matchesG = [regex]::Matches($diretrizConteudo, "(?m)^\*{0,2}\[G-(\d+)\]\*{0,2}[:\s]*(.+?)(?=\n\*{0,2}\[G-|\n\n|\z)")
    foreach ($m in $matchesG) {
        $num = $m.Groups[1].Value
        $texto = $m.Groups[2].Value.Trim() -replace "\*", ""
        if ($texto.Length -gt 120) { $texto = $texto.Substring(0, 117) + "..." }
        $ideiasG.Add("G-$num | $texto")
    }
    if ($ideiasG.Count -gt 0) { $ideiasSocios["GEMINI"] = $ideiasG }
}

# Extrair N-1..N-5 do AUDITOR_LOOP
$auditorFile = Get-ChildItem $historico -Filter "AUDITOR_LOOP_V$Loop*" -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($auditorFile) {
    $auditorConteudo = Get-Content $auditorFile.FullName -Raw -Encoding UTF8
    $ideiasN = [System.Collections.Generic.List[string]]::new()
    $matchesN = [regex]::Matches($auditorConteudo, "(?m)^\*{0,2}\[?N-(\d+)\]?\*{0,2}[:\s]*(.+?)(?=\n\*{0,2}\[?N-|\n\n|\z)")
    foreach ($m in $matchesN) {
        $num = $m.Groups[1].Value
        $texto = $m.Groups[2].Value.Trim() -replace "\*", ""
        if ($texto.Length -gt 120) { $texto = $texto.Substring(0, 117) + "..." }
        $ideiasN.Add("N-$num | $texto")
    }
    if ($ideiasN.Count -gt 0) { $ideiasSocios["NOTEBOOKLM"] = $ideiasN }
}

# Extrair E-1..E-5 da MEMORIA_EMBAIXADOR (secao mais recente)
$memoriaEmb = "$raiz\CLIENTES\$clienteUpper\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
if (-not (Test-Path $memoriaEmb)) {
    $memoriaEmb = "$raiz\CLIENTES\$clienteUpper\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_$clienteUpper.md"
}
if (Test-Path $memoriaEmb) {
    $memoriaConteudo = Get-Content $memoriaEmb -Raw -Encoding UTF8
    $ideiasE = [System.Collections.Generic.List[string]]::new()
    $matchesE = [regex]::Matches($memoriaConteudo, "(?m)^\|\s*E-(\d+)\s*\|([^\|]+)\|([^\|]+)\|")
    foreach ($m in $matchesE) {
        $num = $m.Groups[1].Value
        $insight = $m.Groups[2].Value.Trim()
        if ($insight.Length -gt 100) { $insight = $insight.Substring(0, 97) + "..." }
        $ideiasE.Add("E-$num | $insight")
    }
    if ($ideiasE.Count -gt 0) { $ideiasSocios["EMBAIXADOR"] = $ideiasE }
}

# --- SECAO 3: ARQUIVOS CRIADOS NO LOOP ---
# Data de inicio do loop = data_conclusao do loop anterior (ou primeira atividade conhecida)
$loopInicioDate = $null
if ($ls.loop_anterior -and $ls.loop_anterior.data_fechamento) {
    try { $loopInicioDate = [datetime]::Parse($ls.loop_anterior.data_fechamento) } catch {}
}
if (-not $loopInicioDate) {
    # Fallback: 30 dias atras
    $loopInicioDate = (Get-Date).AddDays(-30)
}

$arquivosCriados = @()
try {
    $since = $loopInicioDate.ToString("yyyy-MM-dd")
    $gitLog = & git -C $raiz log --since="$($since)T00:00:00" --name-only --format="[%h %as] %s" 2>$null
    if ($gitLog) {
        # Extrair linhas que sao arquivos (nao headers de commit)
        $arquivosCriados = $gitLog | Where-Object { $_ -match "^(CLIENTES|scripts|PENTALATERAL|\.claude)" } |
                           Sort-Object -Unique | Select-Object -First 30
    }
} catch {}

# --- SECAO 4: SKILLS USADAS ---
# Verificar arquivos .md em .claude/skills acessados recentemente
$skillsUsadas = @()
$skillsDir = "$raiz\.claude\skills"
if (Test-Path $skillsDir) {
    $skillsUsadas = Get-ChildItem $skillsDir -Filter "*.md" |
                    Where-Object { $_.LastWriteTime.Date -ge $loopInicioDate.Date } |
                    ForEach-Object { $_.Name } |
                    Select-Object -First 10
}

# --- MONTAR O TRANSCRIPT ---
$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("# LOOP TRANSCRIPT V$Loop -- $clienteUpper")
[void]$sb.AppendLine("> Gerado automaticamente por generate_loop_transcript.ps1 (M-2 P-141)")
[void]$sb.AppendLine("> Data: $data $hora | Loop: $Loop | Status: $($ls.loop_status)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## MISSAO DO LOOP")
[void]$sb.AppendLine("")
[void]$sb.AppendLine($missao)
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## IDEIAS POR SOCIO E DISPOSICAO FINAL")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("> Disposicao: ENTRA (build aprovado) | V2 (proximo ciclo) | DESCARTADO | PENDENTE")
[void]$sb.AppendLine("")

$socioLabels = @{
    "MUSCULO"    = "MUSCULO (M-1..M-5)"
    "GEMINI"     = "ESTRATEGISTA / Gemini (G-1..G-5)"
    "NOTEBOOKLM" = "AUDITOR / NotebookLM (N-1..N-5)"
    "EMBAIXADOR" = "EMBAIXADOR (E-1..E-5)"
}

foreach ($socio in @("MUSCULO","GEMINI","NOTEBOOKLM","EMBAIXADOR")) {
    [void]$sb.AppendLine("### $($socioLabels[$socio])")
    [void]$sb.AppendLine("")
    if ($ideiasSocios.ContainsKey($socio) -and $ideiasSocios[$socio].Count -gt 0) {
        [void]$sb.AppendLine("| Ideia | Texto | Disposicao |")
        [void]$sb.AppendLine("|---|---|---|")
        foreach ($ideia in $ideiasSocios[$socio]) {
            $partes = $ideia -split " \| ", 2
            $codigo = $partes[0]
            $texto  = if ($partes.Count -gt 1) { $partes[1] } else { $ideia }
            [void]$sb.AppendLine("| $codigo | $texto | — |")
        }
    } else {
        [void]$sb.AppendLine("_(ideias nao capturadas automaticamente -- preencher manualmente se necessario)_")
    }
    [void]$sb.AppendLine("")
}

[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## SINTESE P-037")
[void]$sb.AppendLine("")
if ($sintese) {
    [void]$sb.AppendLine($sintese)
} else {
    [void]$sb.AppendLine("_(sintese P-037 nao encontrada em DELIBERACAO_LOOP_V$Loop -- verificar arquivo)_")
}
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## ARQUIVOS CRIADOS / MODIFICADOS NESTE LOOP")
[void]$sb.AppendLine("> Desde: $($loopInicioDate.ToString('yyyy-MM-dd'))")
[void]$sb.AppendLine("")
if ($arquivosCriados.Count -gt 0) {
    foreach ($arq in $arquivosCriados) {
        [void]$sb.AppendLine("- ``$arq``")
    }
} else {
    [void]$sb.AppendLine("_(nenhum commit encontrado desde $($loopInicioDate.ToString('yyyy-MM-dd')))_")
}
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## SKILLS USADAS NESTE LOOP")
[void]$sb.AppendLine("")
if ($skillsUsadas.Count -gt 0) {
    foreach ($sk in $skillsUsadas) {
        [void]$sb.AppendLine("- ``$sk``")
    }
} else {
    [void]$sb.AppendLine("_(nenhuma skill com LastWriteTime no periodo do loop)_")
}
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## STATUS DOS SOCIOS AO FECHAR LOOP")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("| Socio | Status | Artefato | Data |")
[void]$sb.AppendLine("|---|---|---|---|")
foreach ($sk in @("gemini","notebooklm","embaixador","musculo")) {
    $socioObj = $ls.socios.$sk
    $statusSocio = if ($socioObj.status) { $socioObj.status } else { "—" }
    $artefatoSocio = if ($socioObj.artefato) { $socioObj.artefato } else { "—" }
    $dataSocio = if ($socioObj.data_conclusao) { $socioObj.data_conclusao } else { "—" }
    [void]$sb.AppendLine("| $($sk.ToUpper()) | $statusSocio | $artefatoSocio | $dataSocio |")
}
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("*LOOP_TRANSCRIPT_V$Loop -- $clienteUpper -- Gerado em $data $hora*")
[void]$sb.AppendLine("*Este arquivo e fonte permanente do caderno NotebookLM (P-141)*")

$conteudo = $sb.ToString()

# --- SALVAR ---
if ($DryRun) {
    Write-Host "[DRYRUN] Conteudo que seria gerado ($($conteudo.Length) chars):" -ForegroundColor DarkCyan
    Write-Host ($conteudo.Substring(0, [Math]::Min(500, $conteudo.Length))) -ForegroundColor DarkCyan
    exit 0
}

if (-not (Test-Path $historico)) { New-Item -ItemType Directory -Path $historico -Force | Out-Null }
[System.IO.File]::WriteAllText($outputPath, $conteudo, [System.Text.UTF8Encoding]::new($false))

Write-Host ""
Write-Host "=== LOOP_TRANSCRIPT GERADO ===" -ForegroundColor Green
Write-Host "Arquivo : $outputPath" -ForegroundColor White
Write-Host "Loop    : $Loop" -ForegroundColor White
Write-Host "Socios  : $($ideiasSocios.Keys -join ', ')" -ForegroundColor White
Write-Host "Arquivos: $($arquivosCriados.Count) commits capturados" -ForegroundColor White
Write-Host ""
Write-Host "ACAO: arrastar para o caderno NotebookLM $clienteUpper (fonte permanente)" -ForegroundColor Yellow
exit 0
