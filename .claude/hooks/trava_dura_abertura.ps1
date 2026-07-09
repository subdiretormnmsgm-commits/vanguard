# HOOK: PreToolUse (Read)
# TRAVA DURA DE ABERTURA -- padrao P-180 (o unico gate que de fato IMPEDE: nega a acao).
# Origem: Diretor 2026-06-24 -- "existem varios gates para voce esquecer, e voce esquece.
#         Existe alguma forma de voce nao esquecer?" -> trava mecanica, nao depende de memoria.
#
# REGRA: NEGA Read(PENDENTES.md) enquanto as flags de HOJE 0A (Notion) e 0B (Cowork) nao existirem.
# Fonte de verdade = as MESMAS flags que gate_passo0_abertura.ps1 grava (so com evidencia):
#   scripts\.passo0_notion_<AAAA-MM-DD>.flag  +  scripts\.passo0_cowork_<AAAA-MM-DD>.flag
# Assim a sequencia P-158/P-114 (Notion 0A -> Cowork 0B -> PENDENTES) fica fisicamente inviolavel.

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$inputJson = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputJson)) { exit 0 }

$data = $inputJson | ConvertFrom-Json -ErrorAction SilentlyContinue
if ($null -eq $data) { exit 0 }

# So agimos sobre o PENDENTES.md da RAIZ -- ancora no separador de caminho (ou inicio da string)
# para NAO pegar DECISOES_PENDENTES.md (Ingrid/Valdece) nem qualquer *PENDENTES.md.
$fp = "$($data.tool_input.file_path)"
if ([string]::IsNullOrWhiteSpace($fp)) { exit 0 }
if ($fp -notmatch '(^|[\\/])PENDENTES\.md$') { exit 0 }

# Localizar scripts\ a partir da raiz (hook esta em .claude\hooks\)
$raiz       = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$scriptsDir = Join-Path $raiz "scripts"

# PAUSA DO SISTEMA (Diretor 2026-07-08): flag presente -> nao bloqueia a abertura.
# Aditivo e reversivel: deletar scripts\.SISTEMA_PAUSADO.flag restaura o comportamento normal.
if (Test-Path (Join-Path $scriptsDir ".SISTEMA_PAUSADO.flag")) { exit 0 }

$hoje       = Get-Date -Format "yyyy-MM-dd"
$flagNotion = Join-Path $scriptsDir ".passo0_notion_$hoje.flag"
$flagCowork = Join-Path $scriptsDir ".passo0_cowork_$hoje.flag"

$notionOK = Test-Path $flagNotion
$coworkOK = Test-Path $flagCowork

if ($notionOK -and $coworkOK) { exit 0 }

$falta = @()
if (-not $notionOK) { $falta += "0A Notion" }
if (-not $coworkOK) { $falta += "0B Cowork INBOX" }

$reason = "[TRAVA DURA DE ABERTURA -- P-158/P-114] Read(PENDENTES.md) BLOQUEADO. " +
          "Falta concluir hoje: $($falta -join ' + '). " +
          "Sequencia obrigatoria: BLOCO 0 -> Notion (0A) -> Cowork INBOX (0B) -> PENDENTES. " +
          "Processe Notion (MCP Notion) e Cowork (INBOX_COWORK no Drive) ANTES; depois marque com evidencia: " +
          "scripts\gate_passo0_abertura.ps1 -MarcarNotion -MarcarCowork. So entao PENDENTES libera."

$output = [ordered]@{
    hookSpecificOutput = [ordered]@{
        hookEventName            = "PreToolUse"
        permissionDecision       = "deny"
        permissionDecisionReason = $reason
    }
} | ConvertTo-Json -Depth 3 -Compress

Write-Output $output
Write-Error $reason
exit 2
