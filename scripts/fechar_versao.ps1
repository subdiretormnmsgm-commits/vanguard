# fechar_versao.ps1 — Automacao de fechamento de versao Vanguard
# Uso: .\scripts\fechar_versao.ps1 -versao 17
# O script faz tudo: atualiza pastas, gera COMANDO_GEMINI, commita

param(
    [Parameter(Mandatory=$true)]
    [int]$versao
)

$base    = "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard"
$v       = $versao
$vPrev   = $versao - 1
$vStr    = "V$v"
$vPrevStr = "V$vPrev"

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "  VANGUARD TECH — Fechamento da $vStr"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host ""

# ─── 1. Verificar arquivos obrigatorios ────────────────────────────
Write-Host "[1/5] Verificando arquivos obrigatorios da $vStr..."

$obrigatorios = @(
    "MEMORIA_$vStr.md",
    "relatorio_evolutivo_v$v.md"
)

$faltando = @()
foreach ($f in $obrigatorios) {
    if (-not (Test-Path "$base\$f")) {
        $faltando += $f
    }
}

if ($faltando.Count -gt 0) {
    Write-Host "  ⚠️  ARQUIVOS FALTANDO — crie antes de fechar:"
    $faltando | ForEach-Object { Write-Host "     → $_" }
    Write-Host ""
    Write-Host "  Dica: peça ao Claude: 'Gere a MEMORIA_$vStr.md e relatorio_evolutivo_v$v.md'"
    exit 1
}

Write-Host "  ✅ Todos os arquivos presentes"

# ─── 2. Gerar COMANDO_GEMINI automaticamente ──────────────────────
Write-Host ""
Write-Host "[2/5] Gerando COMANDO_GEMINI_$vStr.md..."

# Ler conteudo dos arquivos
$memoria   = Get-Content "$base\MEMORIA_$vStr.md" -Raw -Encoding UTF8
$relatorio = Get-Content "$base\relatorio_evolutivo_v$v.md" -Raw -Encoding UTF8

# Ler template
$template  = Get-Content "$base\TEMPLATE_COMANDO_GEMINI.md" -Raw -Encoding UTF8

# Substituir marcadores
$comando = $template `
    -replace '\[VXX\]',      $vStr `
    -replace '\[NUMERO\]',   $v `
    -replace '\[NUMERO \+ 1\]', ($v + 1) `
    -replace '\[COLAR AQUI O CONTEÚDO COMPLETO DE MEMORIA_VXX\.md\]', $memoria `
    -replace '\[COLAR AQUI O CONTEÚDO COMPLETO DE relatorio_evolutivo_vxx\.md\]', $relatorio `
    -replace 'DATA',         (Get-Date -Format "yyyy-MM-dd")

$comandoPath = "$base\COMANDO_GEMINI_$vStr.md"
$comando | Out-File -FilePath $comandoPath -Encoding utf8
Write-Host "  ✅ COMANDO_GEMINI_$vStr.md gerado"

# ─── 3. Atualizar pasta NotebookLM ────────────────────────────────
Write-Host ""
Write-Host "[3/5] Atualizando pasta NotebookLM/..."

$nlmDest = "$base\NotebookLM"
New-Item -ItemType Directory -Path $nlmDest -Force | Out-Null

$novosArquivos = @(
    @{src="MEMORIA_$vStr.md";                prefix="07"},
    @{src="relatorio_evolutivo_v$v.md";      prefix="08"},
    @{src="COMANDO_GEMINI_$vStr.md";         prefix="09"},
    @{src="INTELIGENCIA_ARTIFICIAL_HUMANA.md"; prefix="01"},
    @{src="VANGUARD_BUSINESS_RULES.md";      prefix="03"},
    @{src="TODO_FUTURE.md";                  prefix="10"},
    @{src="VANGUARD_INNOVATION_AUDIT.md";    prefix="11"},
    @{src="PLANO_DE_ACAO_SEMANA1.md";        prefix="14"}
)

foreach ($item in $novosArquivos) {
    $src = "$base\$($item.src)"
    if (Test-Path $src) {
        $fileName = Split-Path $item.src -Leaf
        Copy-Item $src -Destination "$nlmDest\$($item.prefix)_$fileName" -Force
        Write-Host "  ✅ NotebookLM/$($item.prefix)_$fileName"
    }
}

# Adicionar DIRETRIZ da versao atual se existir
$diretrizAtual = "$base\DIRETRIZ GEMINI $vStr.txt"
if (Test-Path $diretrizAtual) {
    Copy-Item $diretrizAtual -Destination "$nlmDest\18_DIRETRIZ GEMINI $vStr.txt" -Force
    Write-Host "  ✅ NotebookLM/18_DIRETRIZ GEMINI $vStr.txt"
}

# ─── 4. Atualizar pasta Doc Gemini ────────────────────────────────
Write-Host ""
Write-Host "[4/5] Atualizando pasta Doc Gemini/..."

$docGemini = "$base\Doc Gemini"
New-Item -ItemType Directory -Path $docGemini -Force | Out-Null

$docsCopiar = @(
    "COMANDO_GEMINI_$vStr.md",
    "MEMORIA_$vStr.md",
    "relatorio_evolutivo_v$v.md",
    "INTELIGENCIA_ARTIFICIAL_HUMANA.md",
    "EMPRESA_VANGUARD.md",
    "REPOSITORIO_ESTRUTURA.md",
    "PROTOCOLO_INTERATIVO.md",
    "HANDOFF_${vStr}_PARA_GEMINI.md",
    "TODO_FUTURE.md",
    "VANGUARD_INNOVATION_AUDIT.md",
    "MASTER_PLAN.md"
)

foreach ($doc in $docsCopiar) {
    $src = "$base\$doc"
    if (Test-Path $src) {
        Copy-Item $src -Destination $docGemini -Force
        Write-Host "  ✅ Doc Gemini/$doc"
    }
}

# ─── 5. Commit automatico ─────────────────────────────────────────
Write-Host ""
Write-Host "[5/5] Fazendo commit automatico..."

Set-Location $base

git add "COMANDO_GEMINI_$vStr.md" "NotebookLM/" "Doc Gemini/" "PROTOCOLO_INTERATIVO.md" 2>&1 | Out-Null

$mensagem = @"
docs($vStr): Fechamento automatico — COMANDO_GEMINI + NotebookLM + Doc Gemini atualizados

Protocolo Colaborativo Ativo:
- COMANDO_GEMINI_$vStr.md gerado automaticamente pelo script fechar_versao.ps1
- NotebookLM/ atualizado com arquivos da $vStr
- Doc Gemini/ atualizado com contexto completo

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
"@

git commit -m $mensagem 2>&1 | Out-Null

$commitHash = git rev-parse --short HEAD
Write-Host "  ✅ Commit $commitHash"

# ─── Resumo final ─────────────────────────────────────────────────
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "  $vStr FECHADA COM SUCESSO  ·  commit $commitHash"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host ""
Write-Host "  ► BLOCO A — CONSELHO QUADRILATERAL" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. NOTEBOOKLM — faça upload dos novos arquivos da pasta NotebookLM/"
Write-Host "     Ficheiros novos: 07_MEMORIA_$vStr.md + 08_relatorio_evolutivo_v$v.md"
Write-Host ""
Write-Host "  2. GEMINI — cole o conteúdo de:"
Write-Host "     Doc Gemini\COMANDO_GEMINI_$vStr.md"
Write-Host "     (O Gemini propõe 5 ideias para V$($v+1) no Bloco 1)"
Write-Host ""
Write-Host "  3. Receba os 4 blocos do Gemini:"
Write-Host "     Bloco 2 → salve como 'DIRETRIZ GEMINI V$($v+1).txt'"
Write-Host "     Bloco 3 → cole no NotebookLM → receba a Skill"
Write-Host "     Bloco 4 → cole no terminal → Claude inicia V$($v+1)"
Write-Host ""
Write-Host "  ─────────────────────────────────────────────────" -ForegroundColor DarkYellow
Write-Host ""
Write-Host "  ► BLOCO B — ACTIVAÇÃO COMERCIAL (fazer HOJE)" -ForegroundColor Green
Write-Host ""
Write-Host "  4. PIPELINE — abra o motor de prospecção:"
Write-Host "     .\scripts\prospectar.ps1"
Write-Host ""
Write-Host "  5. NOVA ARMA — o que foi construído que posso usar para vender?"
Write-Host "     → Consulte RITUAL_POS_VERSAO.md · Preencha a tabela 'nova arma'"
Write-Host ""
Write-Host "  6. PROSPECÇÃO — contactar pelo menos 20 novos alvos hoje:"
Write-Host "     .\scripts\prospectar.ps1 -add    (adicionar 1 prospecto + gerar mensagem)"
Write-Host "     .\scripts\prospectar.ps1 -followup (ver quem precisa de follow-up)"
Write-Host ""
Write-Host "  7. PDCA — actualizar RITUAL_POS_VERSAO.md com os resultados da $vStr:"
Write-Host "     | $vStr | [nova arma] | [clientes gerados] | [MRR adicionado] |"
Write-Host ""
Write-Host "  ─────────────────────────────────────────────────" -ForegroundColor DarkYellow
Write-Host ""
Write-Host "  LEMBRE-SE: cada versão que fecha sem 1 conversa de venda é incompleta." -ForegroundColor Red
Write-Host ""
