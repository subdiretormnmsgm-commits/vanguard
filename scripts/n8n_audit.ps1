#Requires -Version 5.1
# n8n_audit.ps1 -- audita workflows n8n em busca de logica de julgamento hardcoded
#                  + modulo B-3: credenciais expostas em parametros de nodes
# Gate 7B do session_close. Falha (exit 1) se encontrar violacoes.
# Excecao logica: linha com comentario "// LEDGER: [razao]" passa e documenta no AUDIT_REPORT.
# Excecao seguranca: nenhuma -- credencial em valor de parametro = mover para $env, sem override.
# Uso: .\scripts\n8n_audit.ps1 [-WorkflowDir "caminho"] [-DryRun]
param(
    [string]$WorkflowDir = "",
    [switch]$DryRun
)

$scriptDir = Split-Path -Parent $PSScriptRoot
if (-not $WorkflowDir) { $WorkflowDir = Join-Path $scriptDir "_n8n\workflows" }

if (-not (Test-Path $WorkflowDir)) {
    Write-Host "[n8n_audit] Pasta $WorkflowDir nao encontrada -- gate ignorado (nenhum workflow versionado)." -ForegroundColor DarkGray
    exit 0
}

$jsonFiles = @(Get-ChildItem -Path $WorkflowDir -Filter "*.json" -ErrorAction SilentlyContinue)
if ($jsonFiles.Count -eq 0) {
    Write-Host "[n8n_audit] Nenhum workflow .json em $WorkflowDir -- gate ignorado." -ForegroundColor DarkGray
    exit 0
}

Write-Host "[n8n_audit] Auditando $($jsonFiles.Count) workflow(s)..." -ForegroundColor Cyan

# ============================================================
# MODULO 1 -- LOGICA DE JULGAMENTO HARDCODED (Gate original)
# ============================================================
$violations = [System.Collections.ArrayList]@()
$approved   = [System.Collections.ArrayList]@()

$keywords   = @("churn","score","price","preco","pitch","prompt")
# numPattern sozinho nao dispara -- so viola quando na mesma linha que keyword
# Motivo: "> 0", "< 12" sao operacionais; "> 7" em linha com "churn" e julgamento de negocio
$numPattern = '[><=!]+\s*\d+\.?\d*'
$strPattern = '"[^"$][^"]{50,}"'

foreach ($file in $jsonFiles) {
    try {
        $raw = [System.IO.File]::ReadAllText($file.FullName)
        $wf  = $raw | ConvertFrom-Json
    } catch {
        Write-Host "  [AVISO] Falha ao parsear $($file.Name): $($_.Exception.Message)" -ForegroundColor Yellow
        continue
    }

    if (-not $wf.nodes) { continue }

    foreach ($node in $wf.nodes) {
        $codeBlocks = @()
        if ($node.parameters.jsCode)       { $codeBlocks += $node.parameters.jsCode }
        if ($node.parameters.functionCode) { $codeBlocks += $node.parameters.functionCode }
        if ($node.parameters.code)         { $codeBlocks += $node.parameters.code }
        if ($codeBlocks.Count -eq 0)       { continue }

        $code    = $codeBlocks -join "`n"
        $lines   = $code -split "`n"
        $lineNum = 0

        foreach ($line in $lines) {
            $lineNum++
            $isApproved     = $line -match '//\s*LEDGER:'
            $hasNumHardcode = $line -match $numPattern
            $hasStrHardcode = $line -match $strPattern
            $hasKeyword     = ($keywords | Where-Object { $line -match $_ }).Count -gt 0

            # Numeric sozinho nao viola -- requer keyword na mesma linha
            $isBusinessNum = $hasNumHardcode -and $hasKeyword
            if ($isApproved) {
                $null = $approved.Add("[OK-LEDGER] $($file.Name) · $($node.name) · L$lineNum`n  > $($line.Trim())")
            } elseif ($isBusinessNum -or $hasStrHardcode -or $hasKeyword) {
                $null = $violations.Add("[VIOLATION] $($file.Name) · $($node.name) · L$lineNum`n  > $($line.Trim())")
            }
        }
    }
}

# ============================================================
# MODULO 2 -- CREDENCIAIS EXPOSTAS EM PARAMETROS (B-3)
# ============================================================
# Detecta tokens/chaves hardcoded em valores de parametros de qualquer node.
# Seguro: valor comeca com ={{ (expressao usando $env ou variavel n8n) -> skip.
# Sem bypass: credencial em valor literal = mover para $env obrigatoriamente.

$secViolations = [System.Collections.ArrayList]@()

# Padroes de credencial conhecidos
$credPatterns = @(
    @{ name='JWT';            regex='eyJ[A-Za-z0-9+/\-_]{30,}' },
    @{ name='GitHub-PAT';     regex='gh[ps]_[A-Za-z0-9]{20,}' },
    @{ name='GitHub-PAT-FG';  regex='github_pat_[A-Za-z0-9_]{40,}' },
    @{ name='Supabase-Token'; regex='sbp_[A-Za-z0-9]{20,}' },
    @{ name='Notion-Token';   regex='ntn_[A-Za-z0-9]{30,}' },
    @{ name='Anthropic-Key';  regex='sk-ant-[A-Za-z0-9\-_]{20,}' },
    @{ name='OpenAI-Key';     regex='sk-[A-Za-z0-9]{40,}' },
    @{ name='Telegram-Bot';   regex='[0-9]{8,10}:[A-Za-z0-9_\-]{30,}' },
    @{ name='Slack-Token';    regex='xox[bpoa]-[A-Za-z0-9\-]{20,}' },
    @{ name='Bearer-Literal'; regex='Bearer\s+[A-Za-z0-9+/=\-_\.]{30,}' }
)

function Search-CredInValue {
    param([string]$val, [string]$nodeName, [string]$paramPath, [string]$fileName)
    # Seguro: expressao n8n (usa $env, $json, $node, etc.)
    if ($val -match '^\s*=\{') { return }
    # Muito curto para ser credencial real
    if ($val.Length -lt 20)    { return }

    foreach ($cp in $credPatterns) {
        if ($val -match $cp.regex) {
            $preview = $val.Substring(0, [Math]::Min(50, $val.Length))
            $null = $script:secViolations.Add(
                "[SEC-CRED:$($cp.name)] $fileName · $nodeName · param:$paramPath`n  > $preview..."
            )
            return  # uma violacao por valor -- nao duplicar
        }
    }
}

function Walk-Params {
    param($obj, [string]$nodeName, [string]$path, [string]$fileName)
    if ($null -eq $obj) { return }

    if ($obj -is [string]) {
        Search-CredInValue -val $obj -nodeName $nodeName -paramPath $path -fileName $fileName
        return
    }

    # Array
    if ($obj -is [System.Array] -or $obj -is [System.Collections.IList]) {
        $i = 0
        foreach ($item in $obj) {
            Walk-Params -obj $item -nodeName $nodeName -path "$path[$i]" -fileName $fileName
            $i++
        }
        return
    }

    # Objeto PSCustomObject
    $members = $obj | Get-Member -MemberType NoteProperty -ErrorAction SilentlyContinue
    if ($members) {
        foreach ($m in $members) {
            Walk-Params -obj $obj.($m.Name) -nodeName $nodeName -path "$path.$($m.Name)" -fileName $fileName
        }
    }
}

foreach ($file in $jsonFiles) {
    try {
        $raw = [System.IO.File]::ReadAllText($file.FullName)
        $wf  = $raw | ConvertFrom-Json
    } catch { continue }

    if (-not $wf.nodes) { continue }

    foreach ($node in $wf.nodes) {
        if ($node.parameters) {
            Walk-Params -obj $node.parameters -nodeName $node.name -path "parameters" -fileName $file.Name
        }
    }
}

# ============================================================
# RELATORIO CONSOLIDADO
# ============================================================
$timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm"
$reportLines = [System.Collections.ArrayList]@()
$null = $reportLines.Add("# N8N_AUDIT_REPORT -- $timestamp")
$null = $reportLines.Add("")

$totalViolations = $violations.Count + $secViolations.Count

if ($totalViolations -eq 0) {
    $null = $reportLines.Add("STATUS: CLEAN -- nenhuma violacao encontrada.")
    $null = $reportLines.Add("Workflows auditados: $($jsonFiles.Count)")
} else {
    $null = $reportLines.Add("STATUS: VIOLATIONS ($totalViolations encontrada(s))")
    $null = $reportLines.Add("Workflows auditados: $($jsonFiles.Count)")
}

if ($violations.Count -gt 0) {
    $null = $reportLines.Add("")
    $null = $reportLines.Add("## [MODULO 1] Logica de julgamento hardcoded -- corrigir antes de fechar sessao")
    foreach ($v in $violations) { $null = $reportLines.Add("- $v") }
}

if ($secViolations.Count -gt 0) {
    $null = $reportLines.Add("")
    $null = $reportLines.Add("## [MODULO 2-B3] Credenciais expostas em parametros -- BLOQUEIO IMEDIATO")
    $null = $reportLines.Add("## Acao obrigatoria: mover para variavel de ambiente no EasyPanel. Sem excecao.")
    foreach ($sv in $secViolations) { $null = $reportLines.Add("- $sv") }
}

if ($approved.Count -gt 0) {
    $null = $reportLines.Add("")
    $null = $reportLines.Add("## Aprovadas via LEDGER (requer revisao do Auditor)")
    foreach ($a in $approved) { $null = $reportLines.Add("- $a") }
}

$reportPath    = Join-Path $scriptDir "_n8n\N8N_AUDIT_REPORT.md"
$reportContent = $reportLines -join "`n"

if (-not $DryRun) {
    [System.IO.File]::WriteAllText($reportPath, $reportContent, [System.Text.Encoding]::UTF8)
}

Write-Host $reportContent

if ($totalViolations -gt 0) {
    Write-Host ""
    if ($violations.Count -gt 0) {
        Write-Host "[n8n_audit] GATE 7B FALHOU -- $($violations.Count) violacao(oes) de logica." -ForegroundColor Red
        Write-Host "            Remover logica hardcoded ou adicionar comentario '// LEDGER: [razao]'." -ForegroundColor Red
    }
    if ($secViolations.Count -gt 0) {
        Write-Host "[n8n_audit] B-3 FALHOU -- $($secViolations.Count) credencial(is) exposta(s)." -ForegroundColor Red
        Write-Host "            Mover para variavel de ambiente no EasyPanel. Sem override possivel." -ForegroundColor Red
    }
    if ($DryRun) { Write-Host "  [DRYRUN] Bloquearia session_close com exit 1" -ForegroundColor DarkCyan }
    else { exit 1 }
}

Write-Host "[n8n_audit] CLEAN -- $($jsonFiles.Count) workflow(s) · logica OK · credenciais OK." -ForegroundColor Green
exit 0
