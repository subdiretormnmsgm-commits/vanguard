# skill_parser_gate.ps1
# Valida Skill gerada pelo Auditor (NotebookLM) contra os 4 blocos obrigatorios
# Previne Deficiencia 2 do Auditor: Alucinacao Estrutural e Yes-Man (P-007)
# Uso: .\scripts\skill_parser_gate.ps1 -skill "caminho\para\SKILL.md"
# Retorna exit 0 (aprovado) ou exit 2 (rejeitado)

param(
    [Parameter(Mandatory=$false)]
    [string]$skill = ""
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "================================================"
Write-Host "  skill_parser_gate -- Auditor Quality Gate"
Write-Host "================================================"

# Se nenhum arquivo passado, listar Skills disponíveis
if ([string]::IsNullOrWhiteSpace($skill)) {
    $skills = Get-ChildItem "$BASE\.claude\skills" -Filter "SKILL*.md" -ErrorAction SilentlyContinue
    if ($skills.Count -eq 0) {
        Write-Host "Nenhuma Skill encontrada em .claude\skills\"
        Write-Host "Uso: .\scripts\skill_parser_gate.ps1 -skill 'caminho\SKILL.md'"
        exit 1
    }
    Write-Host "Skills disponiveis:"
    $skills | ForEach-Object { Write-Host "  $_" }
    Write-Host ""
    Write-Host "Uso: .\scripts\skill_parser_gate.ps1 -skill 'caminho\SKILL.md'"
    exit 0
}

if (-not (Test-Path $skill)) {
    Write-Host "ERRO: arquivo nao encontrado: $skill"
    exit 1
}

$conteudo = Get-Content $skill -Encoding UTF8 -Raw -ErrorAction SilentlyContinue
if ([string]::IsNullOrWhiteSpace($conteudo)) {
    Write-Host "ERRO: arquivo vazio ou ilegivel"
    exit 1
}

Write-Host "Arquivo : $skill"
Write-Host "Tamanho : $($conteudo.Length) chars"
Write-Host ""

$erros   = [System.Collections.Generic.List[string]]::new()
$avisos  = [System.Collections.Generic.List[string]]::new()
$aprovado = $true

# VALIDACAO 1: Os 4 blocos obrigatorios
$blocos = @(
    @{ padrao = "AUDITORIA.*COER|COERENCIA"; nome = "[AUDITORIA DE COERENCIA]" },
    @{ padrao = "CONEXAO.*HIST|HISTORICA";   nome = "[CONEXAO HISTORICA]" },
    @{ padrao = "PADRAO.*SUCESSO|PADRAO.*FALHA|SUCESSO.*VALIDADO"; nome = "[PADRAO DE SUCESSO/FALHA]" },
    @{ padrao = "PERSPECTIVA.*SOCIO|SOCIO.*CONSULTOR|VISAO.*SOCIO"; nome = "[PERSPECTIVA DO SOCIO]" }
)

foreach ($bloco in $blocos) {
    if ($conteudo -notmatch $bloco.padrao) {
        $erros.Add("Bloco ausente: $($bloco.nome)")
        $aprovado = $false
    }
}

# VALIDACAO 2: Referencias a dados reais de projeto
$referenciais = @("Valdece","V\d{1,2}","R\$\s*[\d\.]+","STF","STJ","Supabase","pgvector","corpus","LEDGER","P-\d{3}")
$refEncontradas = ($referenciais | Where-Object { $conteudo -match $_ }).Count

if ($refEncontradas -lt 2) {
    $erros.Add("Dados reais insuficientes: apenas $refEncontradas referencia(s) a projetos/valores concretos (minimo 2)")
    $aprovado = $false
}

# VALIDACAO 3: Placeholders de template nao preenchidos
if ($conteudo -match "\[A PREENCHER\]|\[INSERIR\]|\[XXX\]|\[EXEMPLO\]|\[COLOCAR AQUI\]") {
    $erros.Add("Template nao preenchido: encontrado placeholder generico")
    $aprovado = $false
}

# VALIDACAO 4: Tamanho minimo
if ($conteudo.Length -lt 800) {
    $avisos.Add("Skill muito curta ($($conteudo.Length) chars) -- risco de alucinacao estrutural")
}

# VALIDACAO 5: Ideias proprias do Auditor (nao apenas eco do Gemini)
if ($conteudo -notmatch "IDEIA|DISRUPTIV|PERSPECTIVA PROPRIA|AUDITOR SUGERE|RECOMENDO|PROPONHO") {
    $avisos.Add("Skill sem contribuicao propria do Auditor -- possivel comportamento Yes-Man")
}

# OUTPUT FINAL
Write-Host ""
if ($aprovado) {
    Write-Host "RESULTADO: APROVADO"
    Write-Host "  A Skill passou em todos os criterios obrigatorios."
    Write-Host "  Pode iniciar o build com base nesta Skill."
} else {
    Write-Host "RESULTADO: REJEITADO -- O AUDITOR ALUCINOU"
    Write-Host ""
    Write-Host "  Retorne ao NotebookLM e aplique o Gatilho de Calibracao:"
    Write-Host "  'Auditor, sua Skill foi rejeitada pelo Musculo."
    Write-Host "   Reprocesse exigindo: dados reais de projeto, os 4 blocos"
    Write-Host "   obrigatorios preenchidos, e sua perspectiva critica propria.'"
}

if ($erros.Count -gt 0) {
    Write-Host ""
    Write-Host "ERROS ($($erros.Count) -- bloqueiam o build):"
    $erros | ForEach-Object { Write-Host "  [X] $_" }
}

if ($avisos.Count -gt 0) {
    Write-Host ""
    Write-Host "AVISOS ($($avisos.Count) -- revisar antes de usar):"
    $avisos | ForEach-Object { Write-Host "  [!] $_" }
}

Write-Host ""
Write-Host "================================================"

exit $(if ($aprovado) { 0 } else { 2 })
