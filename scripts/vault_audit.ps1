#Requires -Version 5.1
# vault_audit.ps1 -- FASE 1 da Operacao Vault Soberano: Inventario e Auditoria de Frescor
# LOCAL-FIRST absoluto (C1/P-169): roda SO sobre o filesystem local. NUNCA sobre mount rclone.
# READ-ONLY: nao move, nao apaga, nao edita nada. Apenas coleta e relata.
#
# v2 (2026-06-17): separa DRIFT REAL de ISOLAMENTO P-059 (dimensao "dono") e segmenta
# os nao-classificados em buckets (codigo de produto / historico / instancia / etc).
#
# Coleta por arquivo: caminho, tamanho, LastWriteTime, SHA-256, formato, TIPO, dono, bucket.
# Deteccoes: duplicados exatos (hash) | divergentes CLASSIFICADOS | nao-MD convertivel.
# Output: VAULT_MANIFEST.json (dados crus) + VAULT_AUDIT_REPORT.md (semaforo por pasta).
#
# Uso: .\scripts\vault_audit.ps1
# Gate: Diretor revisa VAULT_AUDIT_REPORT.md antes de qualquer acao destrutiva (Fase 2+).

$ErrorActionPreference = "Stop"
$raiz = Split-Path $PSScriptRoot -Parent
Set-Location $raiz

$dataAgora = Get-Date
$stamp = $dataAgora.ToString("yyyy-MM-dd HH:mm")

Write-Host "[VAULT-AUDIT] Raiz: $raiz" -ForegroundColor Cyan
Write-Host "[VAULT-AUDIT] Inicio: $stamp" -ForegroundColor Cyan

# ---------- Escopo (C5 excluido: pasta proibida do Diretor) ----------
$raizesEscopo = @("PENTALATERAL_UNIVERSAL", "CLIENTES")
$arquivosRaiz = @("PENDENTES.md", "LEDGER_INBOX.md", "INTELLIGENCE_LEDGER.md")
$excluirPadrao = @("Doc Vanguard Evolu", "\.git\", "node_modules", "_ARQUIVO\", "\.netlify\")

# Nomes de leaf estruturais/genericos: arquivos distintos por design que so compartilham
# o nome (cada pasta tem seu README; cada Edge Function tem seu index.ts). NUNCA sao drift.
$genericNames = @("README.md","index.ts","index.js","index.html","manifest.json",
                  "package.json","package-lock.json","netlify.toml","sw.js",".gitkeep",
                  "__init__.py","style.css","app.js","config.json",".gitignore")

# ---------- Carregar DEPENDENCY_MAP para classificacao TIPO ----------
$depMapPath = Join-Path $raiz "PENTALATERAL_UNIVERSAL\OPERACAO\DEPENDENCY_MAP.json"
if (-not (Test-Path -LiteralPath $depMapPath)) {
    Write-Host "[VAULT-AUDIT] FALHA: DEPENDENCY_MAP ausente: $depMapPath" -ForegroundColor Red; exit 1
}
try {
    $depMap = Get-Content -LiteralPath $depMapPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Host "[VAULT-AUDIT] FALHA: DEPENDENCY_MAP ilegivel/JSON invalido: $_" -ForegroundColor Red; exit 1
}

$tipo1Nomes = @{}
foreach ($a in $depMap.documentos.UNIVERSAL_PURO.arquivos) { if ($a.nome) { $tipo1Nomes[$a.nome] = $true } }
foreach ($s in $depMap.documentos.SCRIPTS_CANONICOS.scripts) { if ($s.nome) { $tipo1Nomes[$s.nome] = $true } }
$tipo2Templates = @()
foreach ($t in $depMap.documentos.TEMPLATE_COM_INSTANCIA.arquivos) { if ($t.template) { $tipo2Templates += ($t.template -replace "/","\") } }
$tipo3Padroes = @()
foreach ($p in $depMap.documentos.PROJECT_ONLY.padroes) { $tipo3Padroes += $p }

function Get-Tipo($relPath, $leaf) {
    foreach ($t in $tipo2Templates) { if ($relPath -like "*$t") { return "TIPO2_TEMPLATE" } }
    if ($tipo1Nomes.ContainsKey($leaf)) { return "TIPO1_UNIVERSAL" }
    if ($relPath -like "*NOTEBOOKLM_BASE*") { return "TIPO1_UNIVERSAL" }
    foreach ($pad in $tipo3Padroes) { if ($leaf -like $pad) { return "TIPO3_PROJECT" } }
    return "NAO_CLASSIFICADO"
}

# Dono/contexto do arquivo -- base para separar drift real de isolamento P-059
function Get-Dono($rel) {
    if ($rel -like "CLIENTES\*") { return "CLIENTE:" + (($rel -split '\\')[1]) }
    if ($rel -like "PENTALATERAL_UNIVERSAL\*") { return "UNIVERSAL" }
    return "RAIZ"
}

# Bucket interpretativo: explica POR QUE um arquivo e NAO_CLASSIFICADO
function Get-Bucket($rel, $tipo) {
    if ($tipo -ne "NAO_CLASSIFICADO") { return $tipo }
    if ($rel -match "\\(supabase|frontend|backend|sql|functions|\.netlify|dist|build)\\") { return "CODIGO_PRODUTO" }
    if ($rel -match "VANGUARD_HISTORICO|\\HISTORICO\\|\\SESOES\\") { return "HISTORICO" }
    if ($rel -match "\\KNOWLEDGE_BASE\\") { return "KNOWLEDGE_BASE" }
    if ($rel -match "\\NOTEBOOKLM_FONTES\\|\\CLAUDE_PROJECT\\|\\DECISOES\\|\\CONSELHO\\") { return "INSTANCIA_CLIENTE" }
    return "OUTROS_NAO_CLASS"
}

function Get-NomeNormalizado($leaf) { return ($leaf -replace '^\d{2}_', '') }

# ---------- Coleta ----------
$itens = New-Object System.Collections.Generic.List[object]

function Add-Arquivo($fileInfo) {
    $rel = $fileInfo.FullName.Substring($raiz.Length).TrimStart('\')
    foreach ($ex in $excluirPadrao) { if ($rel -like "*$ex*") { return } }
    $leaf = $fileInfo.Name
    $ext  = ($fileInfo.Extension -replace '^\.', '').ToLower()
    if ([string]::IsNullOrEmpty($ext)) { $ext = "(sem-ext)" }
    $hash = (Get-FileHash -LiteralPath $fileInfo.FullName -Algorithm SHA256).Hash
    $tipo = (Get-Tipo $rel $leaf)
    $itens.Add([pscustomobject]@{
        caminho       = $rel
        pasta_topo    = ($rel -split '\\')[0]
        leaf          = $leaf
        nome_norm     = (Get-NomeNormalizado $leaf)
        formato       = $ext
        tamanho       = $fileInfo.Length
        modificado    = $fileInfo.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        modificado_dt = $fileInfo.LastWriteTime
        sha256        = $hash
        tipo          = $tipo
        dono          = (Get-Dono $rel)
        bucket        = (Get-Bucket $rel $tipo)
    })
}

foreach ($r in $raizesEscopo) {
    $base = Join-Path $raiz $r
    if (Test-Path $base) {
        Get-ChildItem -LiteralPath $base -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object { Add-Arquivo $_ }
    }
}
foreach ($f in $arquivosRaiz) {
    $p = Join-Path $raiz $f
    if (Test-Path $p) { Add-Arquivo (Get-Item -LiteralPath $p) }
}

Write-Host "[VAULT-AUDIT] Arquivos coletados: $($itens.Count)" -ForegroundColor Green

# ---------- Deteccoes ----------
# 1) Duplicados exatos (mesmo hash, >1 caminho)
$dupExatos = $itens | Group-Object sha256 | Where-Object { $_.Count -gt 1 } |
    ForEach-Object { [pscustomobject]@{ hash = $_.Name; n = $_.Count; caminhos = @($_.Group.caminho) } }

# 2) Divergentes CLASSIFICADOS (mesmo nome_norm, >1 hash distinto)
$divergentes = $itens | Group-Object nome_norm | Where-Object {
    ($_.Group | Select-Object -ExpandProperty sha256 -Unique).Count -gt 1 -and $_.Count -gt 1
} | ForEach-Object {
    $g = $_.Group | Sort-Object modificado_dt -Descending
    $donos = @($g | Select-Object -ExpandProperty dono -Unique)
    # drift intra-dono: mesmo dono com hashes diferentes (anomalia real)
    $driftIntra = $false
    foreach ($d in $donos) {
        $hs = @($g | Where-Object { $_.dono -eq $d } | Select-Object -ExpandProperty sha256 -Unique)
        if ($hs.Count -gt 1) { $driftIntra = $true; break }
    }
    $temTipo12 = @($g | Where-Object { $_.tipo -eq "TIPO1_UNIVERSAL" -or $_.tipo -eq "TIPO2_TEMPLATE" }).Count -gt 0
    $genericLeaf = $genericNames -contains $_.Name
    # Classificacao. ALTA reservado a divergencia de arquivo CANONICO (TIPO1/TIPO2) -- esse e
    # o unico drift que exige acao imediata. Nome generico = colisao por design (BAIXA).
    # Intra-dono nao-canonico (ex.: snapshot V16-V24 vs vivo) = MEDIA, resolvido por arquival na F2.
    if ($genericLeaf) { $classe = "COLISAO_NOME_GENERICO"; $prio = "BAIXA" }
    elseif ($temTipo12) { $classe = "DRIFT_CANONICO"; $prio = "ALTA" }
    elseif ($driftIntra) { $classe = "DRIFT_INTRA"; $prio = "MEDIA" }
    elseif ($donos.Count -eq $g.Count) { $classe = "ISOLAMENTO_P059"; $prio = "BAIXA" }
    elseif ($donos.Count -gt 1) { $classe = "CRUZA_CONTEXTO"; $prio = "MEDIA" }
    else { $classe = "REVISAR"; $prio = "MEDIA" }
    [pscustomobject]@{
        nome     = $_.Name
        classe   = $classe
        prioridade = $prio
        n_copias = $_.Count
        n_hashes = ($g | Select-Object -ExpandProperty sha256 -Unique).Count
        donos    = ($donos -join ", ")
        versoes  = @($g | ForEach-Object { "$($_.modificado) | $($_.sha256.Substring(0,8)) | $($_.caminho)" })
    }
}

# 3) Nao-Markdown: separa DOC_CONVERTIVEL de PRODUTO/binario/sistema
$formatosCodigo = @("md","json","ps1","js","sql","py","ts","jsx","toml","env","example","gitkeep","css")
$formatosBinario = @("pdf","docx","zip","webp","png","jpg","jpeg","bak","rhistory","pptx")
$naoMarkdown = $itens | Where-Object {
    $_.formato -ne "md" -and ($formatosCodigo -notcontains $_.formato) -and ($formatosBinario -notcontains $_.formato)
} | Where-Object {
    $_.leaf -notmatch "CHAVES_SISTEMA|N8N Easypanel" -and $_.caminho -notmatch "\.log$"
} | ForEach-Object {
    $conv = "DOC_CONVERTIVEL"
    if ($_.formato -ne "txt") { $conv = "PRODUTO_OU_SISTEMA" }
    if ($_.bucket -eq "CODIGO_PRODUTO") { $conv = "PRODUTO_OU_SISTEMA" }
    if ($_.caminho -match "\.temp\\|\.env|\.gitignore|\.local") { $conv = "PRODUTO_OU_SISTEMA" }
    $_ | Add-Member -NotePropertyName conv -NotePropertyValue $conv -PassThru
}
$docConvertivel = @($naoMarkdown | Where-Object { $_.conv -eq "DOC_CONVERTIVEL" })

# 4) Nao classificado por bucket
$naoClass = $itens | Where-Object { $_.tipo -eq "NAO_CLASSIFICADO" }

# ---------- Semaforo por pasta de topo ----------
$porPasta = $itens | Group-Object pasta_topo | ForEach-Object {
    $g = $_.Group
    $nDup = ($g | Where-Object { $dupExatos.caminhos -contains $_.caminho }).Count
    $nDocConv = ($g | Where-Object { $docConvertivel.caminho -contains $_.caminho }).Count
    $nNaoClass = ($g | Where-Object { $_.tipo -eq "NAO_CLASSIFICADO" }).Count
    $semaforo = "VERDE"
    if ($nNaoClass -gt 0 -or $nDocConv -gt 0) { $semaforo = "AMARELO" }
    [pscustomobject]@{
        pasta = $_.Name; arquivos = $_.Count
        doc_conv = $nDocConv; nao_class = $nNaoClass; dup = $nDup; semaforo = $semaforo
    }
} | Sort-Object pasta

$driftAlta = @($divergentes | Where-Object { $_.prioridade -eq "ALTA" })

# ---------- Output JSON ----------
$manifest = [ordered]@{
    gerado_em        = $stamp
    raiz             = $raiz
    total_arquivos   = $itens.Count
    total_bytes      = ($itens | Measure-Object tamanho -Sum).Sum
    por_formato      = ($itens | Group-Object formato | ForEach-Object { [pscustomobject]@{ formato=$_.Name; n=$_.Count } })
    por_tipo         = ($itens | Group-Object tipo | ForEach-Object { [pscustomobject]@{ tipo=$_.Name; n=$_.Count } })
    por_bucket       = ($itens | Group-Object bucket | ForEach-Object { [pscustomobject]@{ bucket=$_.Name; n=$_.Count } })
    semaforo_pasta   = $porPasta
    duplicados_exatos = $dupExatos
    divergentes      = $divergentes
    drift_alta       = $driftAlta
    doc_convertivel  = @($docConvertivel | ForEach-Object { $_.caminho })
    nao_markdown_produto = @($naoMarkdown | Where-Object { $_.conv -ne "DOC_CONVERTIVEL" } | ForEach-Object { $_.caminho })
    nao_classificado = @($naoClass | ForEach-Object { [pscustomobject]@{ caminho=$_.caminho; bucket=$_.bucket } })
    arquivos         = @($itens | ForEach-Object { $_ | Select-Object caminho,formato,tamanho,modificado,sha256,tipo,dono,bucket })
}
$manifestPath = Join-Path $raiz "VAULT_MANIFEST.json"
# BOM-free UTF-8: Out-File -Encoding utf8 grava BOM no PS 5.1 e quebra parsers JSON estritos.
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($manifestPath, ($manifest | ConvertTo-Json -Depth 8), $utf8NoBom)

# ---------- Output Relatorio Markdown ----------
$sb = New-Object System.Text.StringBuilder
$null = $sb.AppendLine("# VAULT AUDIT REPORT -- Operacao Vault Soberano (Fase 1)")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("> Gerado: $stamp | LOCAL-FIRST (C1) | READ-ONLY | Gate: Diretor revisa antes da Fase 2.")
$null = $sb.AppendLine("> v2: divergentes classificados (drift real vs isolamento P-059); nao-classificados em buckets.")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("## Resumo")
$null = $sb.AppendLine("")
$totMB = [math]::Round(($itens | Measure-Object tamanho -Sum).Sum / 1MB, 1)
$null = $sb.AppendLine("- **Arquivos no escopo:** $($itens.Count) ($totMB MB)")
$null = $sb.AppendLine("- **Duplicados exatos (hash):** $($dupExatos.Count) grupo(s) -- maioria = sync canonico CORRETO")
$null = $sb.AppendLine("- **Divergentes totais:** $($divergentes.Count) grupo(s)")
$null = $sb.AppendLine("  - **DRIFT_CANONICO ALTA (TIPO1/TIPO2 divergiu -- acao imediata):** $($driftAlta.Count)")
$null = $sb.AppendLine("  - DRIFT_INTRA / CRUZA / REVISAR (MEDIA -- decidir na F2): $(@($divergentes | Where-Object { $_.prioridade -eq 'MEDIA' }).Count)")
$null = $sb.AppendLine("  - ISOLAMENTO_P059 + COLISAO_NOME_GENERICO (BAIXA -- sem acao): $(@($divergentes | Where-Object { $_.prioridade -eq 'BAIXA' }).Count)")
$null = $sb.AppendLine("- **Doc .txt convertivel (Fase 4):** $($docConvertivel.Count) (exclui produto/sistema)")
$null = $sb.AppendLine("- **TIPO nao classificado:** $($naoClass.Count) -- segmentado em buckets abaixo")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("## Buckets dos nao-classificados (porque nao casam o DEPENDENCY_MAP)")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("| Bucket | N | Leitura |")
$null = $sb.AppendLine("|---|---|---|")
$bucketLeitura = @{
    CODIGO_PRODUTO="Codigo de produto do cliente -- fora do dicionario, nao e lixo"
    HISTORICO="Snapshots/sessoes arquivadas -- candidato a _ARQUIVO"
    INSTANCIA_CLIENTE="Instancia por cliente (P-059) -- conteudo proprio"
    KNOWLEDGE_BASE="Base de conhecimento por projeto"
    OUTROS_NAO_CLASS="Revisar caso a caso na Fase 2"
}
foreach ($b in ($naoClass | Group-Object bucket | Sort-Object Count -Descending)) {
    $lt = $bucketLeitura[$b.Name]; if (-not $lt) { $lt = "" }
    $null = $sb.AppendLine("| $($b.Name) | $($b.Count) | $lt |")
}
$null = $sb.AppendLine("")
$null = $sb.AppendLine("## Semaforo por pasta de topo")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("| Pasta | Arquivos | Doc-conv | Nao-class | Dup | Semaforo |")
$null = $sb.AppendLine("|---|---|---|---|---|---|")
foreach ($p in $porPasta) {
    $null = $sb.AppendLine("| $($p.pasta) | $($p.arquivos) | $($p.doc_conv) | $($p.nao_class) | $($p.dup) | $($p.semaforo) |")
}
$null = $sb.AppendLine("")
$null = $sb.AppendLine("## >>> DRIFT_CANONICO prioridade ALTA (acao imediata) <<<")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("> So entra aqui arquivo TIPO1/TIPO2 (canonico/template) que deveria ser identico em")
$null = $sb.AppendLine("> todo lugar mas divergiu -- unico drift que exige correcao imediata (R-01/sync). Versao recente no topo.")
$null = $sb.AppendLine("> ALTA=0 e estado SAUDAVEL: nenhum canonico drifou. DRIFT_INTRA (snapshot vs vivo) cai em MEDIA.")
$null = $sb.AppendLine("")
if ($driftAlta.Count -eq 0) { $null = $sb.AppendLine("_Nenhum drift CANONICO de prioridade ALTA -- firewall R-01 + sync mantiveram os TIPO1 identicos._`n") }
foreach ($d in ($driftAlta | Sort-Object n_copias -Descending)) {
    $null = $sb.AppendLine("### [$($d.classe)] $($d.nome) -- $($d.n_copias) copias / $($d.n_hashes) versoes -- donos: $($d.donos)")
    $null = $sb.AppendLine("")
    foreach ($v in $d.versoes) { $null = $sb.AppendLine("- $v") }
    $null = $sb.AppendLine("")
}
$null = $sb.AppendLine("## DRIFT_INTRA / CRUZA_CONTEXTO / REVISAR (MEDIA -- decidir na Fase 2)")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("> DRIFT_INTRA = mesmo dono com versoes diferentes mas NAO-canonico (tipico: snapshot")
$null = $sb.AppendLine("> arquivado V16-V24 vs vivo) -- resolve-se movendo o snapshot para _ARQUIVO, nao 'consertando'.")
$null = $sb.AppendLine("")
foreach ($d in (@($divergentes | Where-Object { $_.prioridade -eq 'MEDIA' }) | Sort-Object nome)) {
    $null = $sb.AppendLine("- **[$($d.classe)] $($d.nome)** ($($d.n_copias) copias): $($d.donos)")
}
$null = $sb.AppendLine("")
$null = $sb.AppendLine("## BAIXA prioridade -- esperado, SEM acao (ISOLAMENTO_P059 + COLISAO_NOME_GENERICO)")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("> ISOLAMENTO_P059 = cada cliente tem sua versao (por design). COLISAO_NOME_GENERICO =")
$null = $sb.AppendLine("> arquivos distintos que so compartilham o nome (README/index.ts/manifest). Nenhum e drift.")
$null = $sb.AppendLine("")
foreach ($d in (@($divergentes | Where-Object { $_.prioridade -eq 'BAIXA' }) | Sort-Object classe,nome)) {
    $null = $sb.AppendLine("- **[$($d.classe)] $($d.nome)** ($($d.n_copias) copias): $($d.donos)")
}
$null = $sb.AppendLine("")
$null = $sb.AppendLine("## Doc .txt convertivel para Markdown (Fase 4 -- cirurgico)")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("> Apenas .txt de documentacao. Exclui produto, .temp, chaves, logs, html/css/csv.")
$null = $sb.AppendLine("")
foreach ($n in ($docConvertivel | Sort-Object caminho | Select-Object -First 80)) {
    $null = $sb.AppendLine("- $($n.caminho)")
}
if ($docConvertivel.Count -gt 80) { $null = $sb.AppendLine("- _(... +$($docConvertivel.Count - 80) -- ver VAULT_MANIFEST.json)_") }
$null = $sb.AppendLine("")
$null = $sb.AppendLine("## Duplicados exatos (top 25 -- maioria e sync canonico legitimo)")
$null = $sb.AppendLine("")
$topDup = $dupExatos | Sort-Object n -Descending | Select-Object -First 25
foreach ($g in $topDup) {
    $null = $sb.AppendLine("- **$($g.n)x** ($($g.hash.Substring(0,8))): $($g.caminhos[0]) ...")
}
if ($dupExatos.Count -gt 25) { $null = $sb.AppendLine("- _(... +$($dupExatos.Count - 25) grupos -- ver VAULT_MANIFEST.json)_") }
$null = $sb.AppendLine("")
$null = $sb.AppendLine("---")
$null = $sb.AppendLine("*Fonte de dados: VAULT_MANIFEST.json (mesma pasta). Re-rodar: .\\scripts\\vault_audit.ps1*")

$reportPath = Join-Path $raiz "VAULT_AUDIT_REPORT.md"
$sb.ToString() | Out-File -LiteralPath $reportPath -Encoding utf8

Write-Host "[VAULT-AUDIT] Manifesto: $manifestPath" -ForegroundColor Green
Write-Host "[VAULT-AUDIT] Relatorio: $reportPath" -ForegroundColor Green
Write-Host "[VAULT-AUDIT] dup=$($dupExatos.Count) divergentes=$($divergentes.Count) drift_ALTA=$($driftAlta.Count) doc_conv=$($docConvertivel.Count) nao_class=$($naoClass.Count)" -ForegroundColor Cyan
