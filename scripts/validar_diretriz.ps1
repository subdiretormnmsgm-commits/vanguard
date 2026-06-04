#Requires -Version 5.1
# validar_diretriz.ps1 -- Gate obrigatorio antes de processar resposta do Gemini
# Uso: .\scripts\validar_diretriz.ps1 -Arquivo "caminho\para\diretriz.txt"
# Resultado: APROVADO (exit 0) ou REJEITADO com motivo (exit 1)
#
# O QUE ESTE SCRIPT PREVINE:
# - Gemini gerando skill em vez de DIRETRIZ (erros recorrentes P-096)
# - Diretriz com [N-x] (Auditor) em vez de [G-x] (Estrategista)
# - Diretriz sem [NOME DA SKILL] definido
# - Diretriz com [PARA O NOTEBOOKLM] (Gemini tentando fazer trabalho do Auditor)
# - Diretriz sem [PARA O MUSCULO]
# Se REJEITADO: devolver ao Gemini com a mensagem de erro exibida.

param(
    [Parameter(Mandatory=$false)]
    [string]$Arquivo = "",
    [Parameter(Mandatory=$false)]
    [string]$Texto = ""
)

$BASE = $PSScriptRoot -replace "\\scripts$", ""
$erros   = [System.Collections.ArrayList]@()
$avisos  = [System.Collections.ArrayList]@()

Write-Host ""
Write-Host "======================================================="
Write-Host "  VALIDAR_DIRETRIZ -- Gate Pentalateral IAH"
Write-Host "======================================================="

# Obter conteudo
$conteudo = ""
if ($Arquivo -and (Test-Path $Arquivo)) {
    $conteudo = Get-Content $Arquivo -Raw -Encoding UTF8
    Write-Host "  Arquivo: $Arquivo"
} elseif ($Texto) {
    $conteudo = $Texto
    Write-Host "  Texto inline: $($conteudo.Length) chars"
} else {
    # Tentar clipboard
    try {
        $conteudo = Get-Clipboard -Raw
        if ($conteudo.Length -lt 50) {
            Write-Host "  [ERRO] Nenhum arquivo, texto ou clipboard valido fornecido." -ForegroundColor Red
            exit 1
        }
        Write-Host "  Fonte: clipboard ($($conteudo.Length) chars)"
    } catch {
        Write-Host "  [ERRO] Fornecer -Arquivo ou -Texto." -ForegroundColor Red
        Write-Host "  Uso: .\scripts\validar_diretriz.ps1 -Arquivo caminho\diretriz.txt"
        exit 1
    }
}

Write-Host ""
Write-Host "  [CHECK 1] Titulo da Diretriz..."
if ($conteudo -match "Diretriz Estrat[eé]gica V\d+ .* Loop \d+") {
    Write-Host "  [OK] Titulo encontrado: $($Matches[0])" -ForegroundColor Green
} else {
    [void]$erros.Add("Titulo ausente. Esperado: 'Diretriz Estrategica VN -- Projeto X -- Loop N'")
}

Write-Host "  [CHECK 2] [NOME DA SKILL] definido..."
if ($conteudo -match "\[NOME DA SKILL\]\s*:\s*(\S+)") {
    $skillNome = $Matches[1]
    Write-Host "  [OK] Skill: $skillNome" -ForegroundColor Green
    # Verificar formato [cliente]-v[N]
    if ($skillNome -notmatch "^[a-z]+-v\d+$") {
        [void]$avisos.Add("Nome da skill '$skillNome' pode nao seguir o formato [cliente]-v[N] (ex: ingrid-v8)")
    }
} else {
    [void]$erros.Add("[NOME DA SKILL] ausente. Gemini deve definir o nome exato da skill.")
}

Write-Host "  [CHECK 3] [PARA O MUSCULO] presente..."
if ($conteudo -match "\[PARA O M[UU]SCULO\]") {
    Write-Host "  [OK] [PARA O MUSCULO] encontrado" -ForegroundColor Green
} else {
    [void]$erros.Add("[PARA O MUSCULO] ausente. Gemini deve incluir diretrizes tecnicas de build.")
}

Write-Host "  [CHECK 4] [G-1 a G-5] presentes..."
$gCount = ([regex]::Matches($conteudo, '\[G-\d\]')).Count
if ($gCount -ge 5) {
    Write-Host "  [OK] $gCount ideias [G-x] encontradas" -ForegroundColor Green
} elseif ($gCount -gt 0) {
    [void]$avisos.Add("Apenas $gCount de 5 ideias [G-x] encontradas. Gemini deve emitir G-1 a G-5.")
} else {
    [void]$erros.Add("[G-1 a G-5] ausentes. Gemini gerou ideias sem o marcador [G-x] ou usou [N-x] (papel do Auditor).")
}

Write-Host "  [CHECK 5] Ausencia de [N-x] -- papel do Auditor, nao do Estrategista..."
$nCount = ([regex]::Matches($conteudo, '\[N-\d\]')).Count
if ($nCount -eq 0) {
    Write-Host "  [OK] Nenhum [N-x] detectado" -ForegroundColor Green
} else {
    [void]$erros.Add("$nCount marcadores [N-x] detectados. Gemini esta agindo como Auditor (NotebookLM). Devolver ao Gemini.")
}

Write-Host "  [CHECK 6] Ausencia de [PARA O NOTEBOOKLM]..."
if ($conteudo -notmatch "\[PARA O NOTEBOOKLM\]") {
    Write-Host "  [OK] Sem [PARA O NOTEBOOKLM]" -ForegroundColor Green
} else {
    [void]$erros.Add("[PARA O NOTEBOOKLM] detectado. Gemini tentou fazer o trabalho do Auditor. Devolver com: 'Estrategista, remova [PARA O NOTEBOOKLM]. O Musculo prepara o PASSO5.'")
}

Write-Host "  [CHECK 7] Ausencia de skill completa -- Gemini nao deve gerar skill..."
$skillIndicators = @("## 1\. CONTEXTO DO CLIENTE", "## 2\. SEQUENCIA DE BUILD", "CIRCUIT BREAKER", "## 3\. O QUE NAO CONSTRUIR")
$skillCount = ($skillIndicators | Where-Object { $conteudo -match $_ }).Count
if ($skillCount -ge 3) {
    [void]$erros.Add("Conteudo de SKILL detectado (secoes de skill encontradas). Gemini gerou a skill diretamente -- trabalho do Auditor. Devolver: 'Estrategista, voce nao gera a skill. Gere apenas a DIRETRIZ com [G-1 a G-5] + [PARA O MUSCULO].'")
} else {
    Write-Host "  [OK] Sem conteudo de skill detectado" -ForegroundColor Green
}

Write-Host "  [CHECK 8] [ALERTA GEMINI] presente..."
if ($conteudo -match "\[ALERTA GEMINI\]") {
    Write-Host "  [OK] [ALERTA GEMINI] encontrado" -ForegroundColor Green
} else {
    [void]$avisos.Add("[ALERTA GEMINI] ausente. Recomendado mas nao bloqueante.")
}

# RESULTADO
Write-Host ""
Write-Host "======================================================="
if ($avisos.Count -gt 0) {
    Write-Host "  AVISOS ($($avisos.Count)):" -ForegroundColor Yellow
    foreach ($a in $avisos) { Write-Host "  [!] $a" -ForegroundColor Yellow }
    Write-Host ""
}

if ($erros.Count -eq 0) {
    Write-Host "  RESULTADO: APROVADO -- DIRETRIZ valida" -ForegroundColor Green
    Write-Host "  Proximo passo: trazer para o Musculo sintetizar [G-x] + [M-x] e preparar PASSO5"
    Write-Host "======================================================="
    exit 0
} else {
    Write-Host "  RESULTADO: REJEITADO -- $($erros.Count) erro(s)" -ForegroundColor Red
    Write-Host ""
    foreach ($e in $erros) {
        Write-Host "  [ERRO] $e" -ForegroundColor Red
        Write-Host ""
    }
    Write-Host "  ACAO: devolver ao Gemini com a mensagem de erro acima." -ForegroundColor Yellow
    Write-Host "  NAO processar esta DIRETRIZ -- o loop produzira output incorreto." -ForegroundColor Yellow
    Write-Host "======================================================="
    exit 1
}
