# preparar_notebooklm_projeto.ps1
# Pentalateral IAH - V26
#
# O QUE FAZ:
#   Monta a pasta CLIENTES/[CLIENTE]/NOTEBOOKLM_FONTES/ com:
#   - Documentos universais (01-08) copiados da NOTEBOOKLM_BASE
#   - Documentos do projeto (09-17) copiados de CLIENTES/[CLIENTE]/
#   Resultado: UMA pasta com TUDO. Seleciona todos e arrasta ao NotebookLM.
#
# QUANDO RODAR: antes de qualquer sessao Passo 5 (NotebookLM).
#
# USO:
#   .\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
#   .\scripts\preparar_notebooklm_projeto.ps1 -cliente VALDECE

param(
    [Parameter(Mandatory=$true)]
    [string]$cliente
)

$ErrorActionPreference = "Stop"
$cliente = $cliente.ToUpper()

$raiz       = $PSScriptRoot | Split-Path -Parent
$base_dir   = "$raiz\PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE"
$proj_dir   = "$raiz\CLIENTES\$cliente"
$fontes_dir = "$proj_dir\NOTEBOOKLM_FONTES"

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " PENTALATERAL IAH - Preparar NotebookLM Projeto" -ForegroundColor Cyan
Write-Host " Cliente: $cliente" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $proj_dir)) {
    Write-Host "[ERRO] Projeto nao encontrado: $proj_dir" -ForegroundColor Red
    Write-Host "       Crie o projeto com: python .\scripts\clone_project.py --nome $cliente" -ForegroundColor Yellow
    exit 1
}

# Limpar ou criar pasta NOTEBOOKLM_FONTES
if (Test-Path $fontes_dir) {
    Remove-Item "$fontes_dir\*" -Force -Recurse
    Write-Host "[OK] NOTEBOOKLM_FONTES limpa." -ForegroundColor DarkGray
} else {
    New-Item -ItemType Directory -Force -Path $fontes_dir | Out-Null
    Write-Host "[OK] NOTEBOOKLM_FONTES criada." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "--- PARTE 1: Atualizando documentos universais (01-08) ---" -ForegroundColor Yellow
Write-Host "  Sincronizando BASE com fontes originais..." -ForegroundColor DarkGray

# Sempre atualiza a BASE antes de copiar — garante que Eduardo arrasta documentos em dia
& "$PSScriptRoot\atualizar_notebooklm_base.ps1" | Out-Null

Write-Host ""
Get-ChildItem $base_dir | ForEach-Object {
    Copy-Item $_.FullName "$fontes_dir\$($_.Name)" -Force
    Write-Host "  [OK] $($_.Name)" -ForegroundColor Green
}

Write-Host ""
Write-Host "--- PARTE 2: Documentos do projeto $cliente (09+) ---" -ForegroundColor Yellow

# 09 - BRIEFING_DISCOVERY
$f = "$proj_dir\BRIEFING_DISCOVERY.txt"
if (Test-Path $f) {
    Copy-Item $f "$fontes_dir\09_BRIEFING_DISCOVERY.txt" -Force
    Write-Host "  [OK] 09_BRIEFING_DISCOVERY.txt" -ForegroundColor Green
} else {
    Write-Host "  [--] 09_BRIEFING_DISCOVERY.txt (nao encontrado)" -ForegroundColor DarkGray
}

# 10 - MEMORIA mais recente
$mem = Get-ChildItem "$proj_dir\HISTORICO" -Filter "MEMORIA_V*.md" -ErrorAction SilentlyContinue |
       Sort-Object Name -Descending | Select-Object -First 1
if ($mem) {
    Copy-Item $mem.FullName "$fontes_dir\10_MEMORIA_RECENTE.md" -Force
    Write-Host "  [OK] 10_MEMORIA_RECENTE.md ($($mem.Name))" -ForegroundColor Green
} else {
    Write-Host "  [--] 10_MEMORIA_RECENTE.md (ainda nao existe - normal no Loop 1)" -ForegroundColor DarkGray
}

# 11 - RELATORIO mais recente
$rel = Get-ChildItem "$proj_dir\HISTORICO" -Filter "relatorio_evolutivo_V*.md" -ErrorAction SilentlyContinue |
       Sort-Object Name -Descending | Select-Object -First 1
if ($rel) {
    Copy-Item $rel.FullName "$fontes_dir\11_RELATORIO_EVOLUTIVO.md" -Force
    Write-Host "  [OK] 11_RELATORIO_EVOLUTIVO.md ($($rel.Name))" -ForegroundColor Green
} else {
    Write-Host "  [--] 11_RELATORIO_EVOLUTIVO.md (ainda nao existe - normal no Loop 1)" -ForegroundColor DarkGray
}

# 12 - DIRETRIZ do Gemini mais recente
$dir = Get-ChildItem "$proj_dir" -Filter "DIRETRIZ_GEMINI_V*.txt" -ErrorAction SilentlyContinue |
       Sort-Object Name -Descending | Select-Object -First 1
if ($dir) {
    Copy-Item $dir.FullName "$fontes_dir\12_DIRETRIZ_GEMINI.txt" -Force
    Write-Host "  [OK] 12_DIRETRIZ_GEMINI.txt ($($dir.Name))" -ForegroundColor Green
} else {
    Set-Content "$fontes_dir\12_DIRETRIZ_GEMINI_PLACEHOLDER.txt" "PLACEHOLDER - Cole aqui a DIRETRIZ completa recebida do Gemini antes de ir ao NotebookLM." -Encoding utf8
    Write-Host "  [PH] 12_DIRETRIZ_GEMINI_PLACEHOLDER.txt (aguardando Gemini)" -ForegroundColor Yellow
}

# 13 - PASSO5_NOTEBOOKLM (instrucao para o Auditor - carrega como fonte)
$f = "$proj_dir\PASSO5_NOTEBOOKLM.md"
if (Test-Path $f) {
    Copy-Item $f "$fontes_dir\13_PASSO5_NOTEBOOKLM.md" -Force
    Write-Host "  [OK] 13_PASSO5_NOTEBOOKLM.md" -ForegroundColor Green
} else {
    Write-Host "  [--] 13_PASSO5_NOTEBOOKLM.md (nao encontrado)" -ForegroundColor DarkGray
}

# 14 - MEMORIA_EMBAIXADOR (inteligencia do cliente - filtro de realidade do Auditor)
$f = "$proj_dir\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
if (Test-Path $f) {
    Copy-Item $f "$fontes_dir\14_MEMORIA_EMBAIXADOR.md" -Force
    Write-Host "  [OK] 14_MEMORIA_EMBAIXADOR.md" -ForegroundColor Green
} else {
    Write-Host "  [--] 14_MEMORIA_EMBAIXADOR.md (nao encontrado - criar via ir_ao_embaixador.ps1)" -ForegroundColor Yellow
}

# 15 - SKILL do ciclo anterior (se existir)
$skill = Get-ChildItem "$proj_dir\CONSELHO" -Filter "SKILL_*.md" -Recurse -ErrorAction SilentlyContinue |
         Sort-Object Name -Descending | Select-Object -First 1
if ($skill) {
    Copy-Item $skill.FullName "$fontes_dir\15_SKILL_ANTERIOR.md" -Force
    Write-Host "  [OK] 15_SKILL_ANTERIOR.md ($($skill.Name))" -ForegroundColor Green
} else {
    Write-Host "  [--] 15_SKILL_ANTERIOR.md (ainda nao existe - normal no Loop 1)" -ForegroundColor DarkGray
}

# 16 - ALERTA_CONFLITO (universal - alerta de calibracao)
$f = "$raiz\PENTALATERAL_UNIVERSAL\OPERACAO\ALERTA_CONFLITO.md"
if (Test-Path $f) {
    Copy-Item $f "$fontes_dir\16_ALERTA_CONFLITO.md" -Force
    Write-Host "  [OK] 16_ALERTA_CONFLITO.md" -ForegroundColor Green
} else {
    Write-Host "  [--] 16_ALERTA_CONFLITO.md (nao encontrado)" -ForegroundColor DarkGray
}

# 17 - VANGUARD_TIMELINE (historia completa da Vanguard - fonte historica do Auditor)
$f = "$raiz\PENTALATERAL_UNIVERSAL\HISTORICO\VANGUARD_TIMELINE.md"
if (Test-Path $f) {
    Copy-Item $f "$fontes_dir\17_VANGUARD_TIMELINE.md" -Force
    Write-Host "  [OK] 17_VANGUARD_TIMELINE.md" -ForegroundColor Green
} else {
    Write-Host "  [--] 17_VANGUARD_TIMELINE.md (nao encontrado)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan

$total = (Get-ChildItem $fontes_dir).Count
Write-Host " $total documentos prontos em:" -ForegroundColor Green
Write-Host " CLIENTES\$cliente\NOTEBOOKLM_FONTES\" -ForegroundColor White

# Extrair e copiar COMANDO CURTO automaticamente para o clipboard
$passo5 = "$fontes_dir\13_PASSO5_NOTEBOOKLM.md"
if (Test-Path $passo5) {
    $conteudo = [System.IO.File]::ReadAllText($passo5, [System.Text.Encoding]::UTF8)
    $match = [regex]::Match($conteudo, '(?s)### [^\n]*COMANDO CURTO[^\n]*\n+```\n(.*?)\n```')
    if ($match.Success) {
        $cmd = $match.Groups[1].Value.Trim()
        $cmd | clip
        Write-Host ""
        Write-Host " [CLIPBOARD] COMANDO CURTO copiado (Ctrl+V pronto):" -ForegroundColor Green
        Write-Host "  $($cmd.Substring(0, [Math]::Min(80, $cmd.Length)))..." -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host " INSTRUCAO (3 passos):" -ForegroundColor Yellow
Write-Host "  1. Explorer abre automaticamente - Ctrl+A + arrastar TUDO ao NotebookLM" -ForegroundColor White
Write-Host "  2. Fazer Wipe & Sync das fontes (apagar antigas, subir as novas)" -ForegroundColor White
Write-Host "  3. Colar o COMANDO CURTO no chat (Ctrl+V - ja esta no clipboard)" -ForegroundColor Cyan
Write-Host ""
Write-Host " NOTA: o arquivo 12 com PLACEHOLDER deve ser substituido pela" -ForegroundColor Yellow
Write-Host "       DIRETRIZ real do Gemini antes de ir ao NotebookLM." -ForegroundColor Yellow
Write-Host ""

Start-Process explorer.exe $fontes_dir
