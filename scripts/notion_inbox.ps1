# notion_inbox.ps1 -- Inbound: le Falhas + Sugestoes do Diretor no Notion
# Rodado no session_start (LEITURA OBRIGATORIA toda sessao -- declaracao do Diretor 2026-06-08).
# Diretor SO escreve nessas duas paginas. O Musculo le, classifica e marca [PROCESSADO].
# Saida em texto plano -- o session_start injeta no contexto da sessao.

$ErrorActionPreference = "Stop"
$RAIZ   = Split-Path $PSScriptRoot -Parent
$CHAVES = Join-Path $RAIZ "CHAVES_SISTEMA_VANGUARD.txt"
if (-not (Test-Path $CHAVES)) { exit 0 }

$chaves = Get-Content -Raw $CHAVES
$tok = ([regex]'NOTION_API_TOKEN\s*=\s*(\S+)').Match($chaves).Groups[1].Value
$idF = ([regex]'NOTION_FALHAS_PAGE_ID\s*=\s*(\S+)').Match($chaves).Groups[1].Value
$idS = ([regex]'NOTION_SUGESTOES_PAGE_ID\s*=\s*(\S+)').Match($chaves).Groups[1].Value
if (-not $tok -or -not $idF -or -not $idS) { exit 0 }

$h = @{ "Authorization" = "Bearer $tok"; "Notion-Version" = "2022-06-28" }

function Get-Texto($pageId) {
    $out = New-Object System.Collections.ArrayList
    try {
        $r = Invoke-RestMethod -Uri "https://api.notion.com/v1/blocks/$pageId/children?page_size=100" -Headers $h -Method Get -TimeoutSec 8
    } catch {
        [void]$out.Add("[ERRO ao ler pagina Notion: $($_.Exception.Message)]"); return $out
    }
    foreach ($b in $r.results) {
        $tipo = $b.type
        $rt = $b.$tipo.rich_text
        if ($rt) {
            $txt = ($rt | ForEach-Object { $_.plain_text }) -join ''
            if ($txt.Trim()) {
                $mark = ''
                if ($tipo -eq 'to_do') { $mark = if ($b.to_do.checked) { '[PROCESSADO] ' } else { '[ ] ' } }
                [void]$out.Add($mark + $txt)
            }
        }
    }
    return $out
}

# Remove cabecalho/instrucoes das paginas (mantem so os itens reais do Diretor)
function Limpa($arr) { @($arr | Where-Object { $_ -notmatch '^(FALHAS:|SUGESTOES:|\(Anote)' }) }

$falhas = Limpa (Get-Texto $idF)
$sug    = Limpa (Get-Texto $idS)

# So lista itens NAO processados (sem marca [PROCESSADO])
$falhasAbertas = @($falhas | Where-Object { $_ -notmatch '^\[PROCESSADO\]' })
$sugAbertas    = @($sug    | Where-Object { $_ -notmatch '^\[PROCESSADO\]' })

Write-Output "=== NOTION INBOX DO DIRETOR (leitura obrigatoria -- session_start) ==="
Write-Output "--- FALHAS DO DIA -- abertas: $($falhasAbertas.Count) ---"
if ($falhasAbertas.Count) { $falhasAbertas | ForEach-Object { Write-Output "  - $_" } } else { Write-Output "  (nenhuma falha aberta)" }
Write-Output "--- SUGESTOES DO DIA -- abertas: $($sugAbertas.Count) ---"
if ($sugAbertas.Count) { $sugAbertas | ForEach-Object { Write-Output "  - $_" } } else { Write-Output "  (nenhuma sugestao aberta)" }
if ($falhasAbertas.Count -or $sugAbertas.Count) {
    Write-Output "ACAO DO MUSCULO: classificar cada item (Falha -> LEDGER + ferramenta anti-recorrencia; Sugestao -> PENDENTES/loop P-092) e marcar [PROCESSADO] na pagina Notion."
}
