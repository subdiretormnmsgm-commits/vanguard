# fechar_versao.ps1 -- Automacao de fechamento de versao Vanguard
# Uso: .\scripts\fechar_versao.ps1 -versao 17
# O script faz tudo: atualiza pastas, gera COMANDO_GEMINI, commita

param(
    [Parameter(Mandatory=$true)]
    [int]$versao
)

$base    = Split-Path $PSScriptRoot -Parent
$v       = $versao
$vPrev   = $versao - 1
$vStr    = "V$v"
$vPrevStr = "V$vPrev"

Write-Host ""
Write-Host "======================================================"
Write-Host "  VANGUARD TECH -- Fechamento da $vStr"
Write-Host "======================================================"
Write-Host ""

# --- 1. Verificar arquivos obrigatorios ---
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
    Write-Host "  ARQUIVOS FALTANDO -- crie antes de fechar:"
    $faltando | ForEach-Object { Write-Host "     -> $_" }
    Write-Host ""
    Write-Host "  Dica: peca ao Claude: 'Gere a MEMORIA_$vStr.md e relatorio_evolutivo_v$v.md'"
    exit 1
}

Write-Host "  OK -- Todos os arquivos presentes"

# --- 2. Gerar COMANDO_GEMINI automaticamente ---
Write-Host ""
Write-Host "[2/5] Gerando COMANDO_GEMINI_$vStr.md..."

$memoria   = Get-Content "$base\MEMORIA_$vStr.md" -Raw -Encoding UTF8
$relatorio = Get-Content "$base\relatorio_evolutivo_v$v.md" -Raw -Encoding UTF8
$template  = Get-Content "$base\TEMPLATE_COMANDO_GEMINI.md" -Raw -Encoding UTF8

$comando = $template `
    -replace '\[VXX\]',      $vStr `
    -replace '\[NUMERO\]',   $v `
    -replace '\[NUMERO \+ 1\]', ($v + 1) `
    -replace '\[COLAR AQUI O CONTE.DO COMPLETO DE MEMORIA_VXX\.md\]', $memoria `
    -replace '\[COLAR AQUI O CONTE.DO COMPLETO DE relatorio_evolutivo_vxx\.md\]', $relatorio `
    -replace 'DATA',         (Get-Date -Format "yyyy-MM-dd")

$comandoPath = "$base\COMANDO_GEMINI_$vStr.md"
$comando | Out-File -FilePath $comandoPath -Encoding utf8
Write-Host "  OK -- COMANDO_GEMINI_$vStr.md gerado"

# --- 3. Atualizar pasta NotebookLM ---
Write-Host ""
Write-Host "[3/5] Atualizando pasta NotebookLM/..."

$nlmDest = "$base\NotebookLM"
New-Item -ItemType Directory -Path $nlmDest -Force | Out-Null

$novosArquivos = @(
    @{src="MEMORIA_$vStr.md";                  prefix="07"},
    @{src="relatorio_evolutivo_v$v.md";        prefix="08"},
    @{src="COMANDO_GEMINI_$vStr.md";           prefix="09"},
    @{src="INTELIGENCIA_ARTIFICIAL_HUMANA.md"; prefix="01"},
    @{src="VANGUARD_BUSINESS_RULES.md";        prefix="03"},
    @{src="TODO_FUTURE.md";                    prefix="10"},
    @{src="VANGUARD_INNOVATION_AUDIT.md";      prefix="11"},
    @{src="RITUAL_POS_VERSAO.md";              prefix="12"},
    @{src="PLANO_DE_ACAO_SEMANA1.md";          prefix="14"}
)

foreach ($item in $novosArquivos) {
    $src = "$base\$($item.src)"
    if (Test-Path $src) {
        $fileName = Split-Path $item.src -Leaf
        Copy-Item $src -Destination "$nlmDest\$($item.prefix)_$fileName" -Force
        Write-Host "  OK -- NotebookLM/$($item.prefix)_$fileName"
    }
}

$diretrizAtual = "$base\DIRETRIZ GEMINI $vStr.txt"
if (Test-Path $diretrizAtual) {
    Copy-Item $diretrizAtual -Destination "$nlmDest\18_DIRETRIZ GEMINI $vStr.txt" -Force
    Write-Host "  OK -- NotebookLM/18_DIRETRIZ GEMINI $vStr.txt"
}

# --- 4. Atualizar pasta Doc Gemini ---
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
    "RITUAL_POS_VERSAO.md",
    "HANDOFF_${vStr}_PARA_GEMINI.md",
    "TODO_FUTURE.md",
    "VANGUARD_INNOVATION_AUDIT.md",
    "MASTER_PLAN.md"
)

foreach ($doc in $docsCopiar) {
    $src = "$base\$doc"
    if (Test-Path $src) {
        Copy-Item $src -Destination $docGemini -Force
        Write-Host "  OK -- Doc Gemini/$doc"
    }
}

# --- 5. Sincronizar .claude/skills com modelos universais ---
Write-Host ""
Write-Host "[5/6] Sincronizando .claude/skills com modelos universais..."

$skillsDir = "$base\.claude\skills"
New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null

$sincronizar = @(
    @{src="QUADRILATERAL_UNIVERSAL\OPERACAO\SKILL_PROTOCOLO_VANGUARD.md"; dest="vanguard-protocolo.md"},
    @{src="QUADRILATERAL_UNIVERSAL\CONSTITUICAO\MEMORANDO_QUADRILATERAL_UNIVERSAL.md"; dest="vanguard-memorando.md"}
)

foreach ($item in $sincronizar) {
    $src = "$base\$($item.src)"
    if (Test-Path $src) {
        Copy-Item $src -Destination "$skillsDir\$($item.dest)" -Force
        Write-Host "  OK -- .claude/skills/$($item.dest) sincronizado"
    }
}

# --- 6. Commit automatico ---
Write-Host ""
Write-Host "[6/6] Fazendo commit automatico..."

Set-Location $base

git add "MEMORIA_$vStr.md" "relatorio_evolutivo_v$v.md" "COMANDO_GEMINI_$vStr.md" "NotebookLM/" "Doc Gemini/" ".claude/skills/" 2>&1 | Out-Null

$mensagem = @"
docs($vStr): Fechamento completo -- MEMORIA + relatorio + COMANDO_GEMINI + pastas

- MEMORIA_$vStr.md: registro tecnico completo da versao
- relatorio_evolutivo_v${v}.md: 5 ideias disruptivas para V$($v+1)
- COMANDO_GEMINI_$vStr.md: regenerado com conteudo real da $vStr
- NotebookLM/ e Doc Gemini/ atualizados

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
"@

git commit -m $mensagem 2>&1 | Out-Null

$commitHash = git rev-parse --short HEAD
Write-Host "  OK -- Commit $commitHash"

# --- Resumo final ---
Write-Host ""
Write-Host "======================================================"
Write-Host "  $vStr FECHADA -- commit $commitHash"
Write-Host "======================================================"
Write-Host ""
Write-Host "  SEQUENCIA CRONOLOGICA OBRIGATORIA:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  PASSO 2 -- NOTEBOOKLM (fazer primeiro, antes do Gemini)" -ForegroundColor Cyan
Write-Host "    Upload na pasta NotebookLM/ os ficheiros novos:"
Write-Host "      07_MEMORIA_$vStr.md"
Write-Host "      08_relatorio_evolutivo_v$v.md"
Write-Host "    (O NotebookLM precisa do contexto antes de receber o Bloco 3)"
Write-Host ""
Write-Host "  PASSO 3 -- GEMINI (cole o COMANDO e aguarde os 4 blocos)" -ForegroundColor Cyan
Write-Host "    Ficheiro a colar: Doc Gemini\COMANDO_GEMINI_$vStr.md"
Write-Host "    O Gemini vai propor 5 ideias para V$($v+1) no Bloco 1"
Write-Host ""
Write-Host "  PASSO 4 -- salvar Bloco 2 como: DIRETRIZ GEMINI V$($v+1).txt"
Write-Host "  PASSO 5 -- colar Bloco 3 no NotebookLM -> receber Skill V$($v+1)"
Write-Host "  PASSO 6 -- salvar Skill em .claude\skills\vanguard-v$($v+1)-[nome].md"
Write-Host "  PASSO 7 -- colar Bloco 4 no terminal -> Claude inicia V$($v+1)"
Write-Host ""
Write-Host "  PASSO 8 -- COMERCIAL (em paralelo com passos 3 a 7)" -ForegroundColor Green
Write-Host "    .\scripts\prospectar.ps1 -add"
Write-Host "    Meta: 20 contactos hoje"
Write-Host ""
Write-Host "  Consulte RITUAL_POS_VERSAO.md para o checklist completo."
Write-Host ""
Write-Host "  REGRA: cada versao que fecha sem 1 conversa de venda e incompleta." -ForegroundColor Red
Write-Host ""
