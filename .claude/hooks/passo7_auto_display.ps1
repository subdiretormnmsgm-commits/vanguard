#Requires -Version 5.1
# Hook: PostToolUse (Write|Edit)
# Detecta escrita em PASSO7_EMBAIXADOR.md e exibe automaticamente no chat:
#   (1) Texto completo da SECAO D para colar no Embaixador
#   (2) Lista de fontes atualizadas a arrastar no Claude Projects
# Zero intervencao do Diretor -- automatico em qualquer sessao.

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$inputJson = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputJson)) { exit 0 }

$data = $inputJson | ConvertFrom-Json -ErrorAction SilentlyContinue
if ($null -eq $data) { exit 0 }

$filePath = $data.tool_input.file_path
if ([string]::IsNullOrWhiteSpace($filePath)) { exit 0 }

$filePath = $filePath.Replace("/", "\")

# So ativa para PASSO7_EMBAIXADOR.md
if ($filePath -notmatch "PASSO7_EMBAIXADOR\.md$") { exit 0 }

$ROOT = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

# ------------------------------------------------------------------
# Detectar cliente a partir do caminho
# ------------------------------------------------------------------
$cliente = "VANGUARD"
if ($filePath -match "CLIENTES\\([^\\]+)\\PASSO7") {
    $cliente = $Matches[1]
}

# ------------------------------------------------------------------
# Sincronizar CLAUDE_PROJECT automaticamente
# ------------------------------------------------------------------
$syncScript = Join-Path $ROOT "scripts\ir_ao_embaixador.ps1"
if (Test-Path $syncScript) {
    try {
        & powershell -NoProfile -NonInteractive -File $syncScript -cliente $cliente -AutoSync 2>&1 | Out-Null
    } catch {}
}

# ------------------------------------------------------------------
# Ler PASSO7_EMBAIXADOR.md e extrair SECAO D
# ------------------------------------------------------------------
$secaoD = "(nao foi possivel ler o arquivo)"
try {
    $linhas = Get-Content $filePath -Encoding UTF8 -ErrorAction Stop
    $dentro = $false
    $blocoLinhas = [System.Collections.Generic.List[string]]::new()

    foreach ($linha in $linhas) {
        # Inicio da secao D: linha com ## SECAO D ou ## SEÇÃO D
        if ($linha -match "^##\s+SE.*O D") {
            $dentro = $true
            continue
        }
        # Fim: proxima secao de nivel 2
        if ($dentro -and $linha -match "^##\s+" -and $linha -notmatch "SE.*O D") {
            break
        }
        if ($dentro) {
            # Pular a linha de abertura/fechamento de bloco de codigo (tres backticks)
            if ($linha -match "^```$") { continue }
            $blocoLinhas.Add($linha)
        }
    }

    if ($blocoLinhas.Count -gt 0) {
        $secaoD = ($blocoLinhas | Where-Object { $_ -ne $null }) -join "`n"
        $secaoD = $secaoD.Trim()
    }
} catch {
    $secaoD = "ERRO ao ler PASSO7: $($_.Exception.Message)"
}

# ------------------------------------------------------------------
# Listar documentos do CLAUDE_PROJECT e HISTORICO
# ------------------------------------------------------------------
$cpDir        = Join-Path $ROOT "CLIENTES\$cliente\CLAUDE_PROJECT"
$historicoDir = Join-Path $ROOT "CLIENTES\$cliente\HISTORICO"

$fontesList = [System.Collections.Generic.List[string]]::new()

# Docs padrao do CLAUDE_PROJECT
$docsCP = @(
    "06_INTELLIGENCE_LEDGER.md",
    "07_WIP_BOARD.json",
    "16_VANGUARD_TIMELINE.md",
    ("MEMORIA_EMBAIXADOR_" + $cliente + ".md")
)
foreach ($doc in $docsCP) {
    $p = Join-Path $cpDir $doc
    if (Test-Path $p) {
        $info = Get-Item $p
        $dt   = $info.LastWriteTime.ToString("dd/MM HH:mm")
        $fontesList.Add("  [OK] $doc  ($dt)  ->  CLIENTES\$cliente\CLAUDE_PROJECT\$doc")
    }
}

# AUDITOR_LOOP mais recente
if (Test-Path $historicoDir) {
    $auditor = Get-ChildItem $historicoDir -Filter ("AUDITOR_LOOP_V*_" + $cliente + ".md") `
               -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($auditor) {
        $dt = $auditor.LastWriteTime.ToString("dd/MM HH:mm")
        $fontesList.Add("  [OK] $($auditor.Name)  ($dt)  ->  CLIENTES\$cliente\HISTORICO\$($auditor.Name)")
    }

    # MEMORIA mais recente
    $memoria = Get-ChildItem $historicoDir -Filter ("MEMORIA_V*_" + $cliente + ".md") `
               -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($memoria) {
        $dt = $memoria.LastWriteTime.ToString("dd/MM HH:mm")
        $fontesList.Add("  [OK] $($memoria.Name)  ($dt)  ->  CLIENTES\$cliente\HISTORICO\$($memoria.Name)")
    }

    # RELATORIO mais recente
    $relatorio = Get-ChildItem $historicoDir -Filter ("relatorio_evolutivo_V*_" + $cliente.ToLower() + ".md") `
                 -ErrorAction SilentlyContinue |
                 Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($relatorio) {
        $dt = $relatorio.LastWriteTime.ToString("dd/MM HH:mm")
        $fontesList.Add("  [OK] $($relatorio.Name)  ($dt)  ->  CLIENTES\$cliente\HISTORICO\$($relatorio.Name)")
    }
}

$fontesTexto = if ($fontesList.Count -gt 0) {
    $fontesList -join "`n"
} else {
    "  (nenhum documento encontrado em CLAUDE_PROJECT)"
}

$totalFontes = $fontesList.Count

# ------------------------------------------------------------------
# Montar JSON de output para o Claude Code
# ------------------------------------------------------------------
$ctx = @"
=============================================================
  PASSO7 PRONTO -- EMBAIXADOR $cliente -- EXIBIR NO CHAT
=============================================================
INSTRUCAO MANDATORIA: Exibir IMEDIATAMENTE no chat o texto
e fontes abaixo, sem esperar o Diretor pedir.

---------- TEXTO PARA COLAR NO EMBAIXADOR ----------
$secaoD
---------- FIM DO TEXTO ----------

FONTES PARA ARRASTAR ($totalFontes documentos):
$fontesTexto

NAO ARRASTAR: 02_DIRETRIZ_GEMINI_LATEST.txt (contem [PARA O MUSCULO])
=============================================================
"@

$result = [PSCustomObject]@{
    hookSpecificOutput = [PSCustomObject]@{
        hookEventName     = "PostToolUse"
        additionalContext = $ctx
    }
} | ConvertTo-Json -Compress -Depth 5

Write-Output $result
exit 0
