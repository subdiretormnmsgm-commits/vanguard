#Requires -Version 5.1
# check_skills_embaixador.ps1 -- Gate P-037 BLOQUEANTE
# Invocado antes de qualquer analise de output do Embaixador (SECAO D / E-1..E-5)
# P-146: ferramenta que previne repeticao do erro de skills erradas (2026-06-10)
# P-153: Musculo identifica falhas no raciocinio ANTES de concordar

param(
    [string]$Cliente = "VANGUARD",
    [switch]$Verificar  # -Verificar: checa se DELIBERACAO_LOOP existe com evidencia de skills
)

$base = Split-Path -Parent $PSScriptRoot

if ($Verificar) {
    # Verificar se o DELIBERACAO_LOOP do loop atual existe e tem evidencia das skills
    $loopStatePath = "$base\CLIENTES\$Cliente\CLAUDE_PROJECT\LOOP_STATE.json"
    if (-not (Test-Path $loopStatePath)) {
        Write-Host "[GATE P-037] LOOP_STATE.json nao encontrado: $loopStatePath" -ForegroundColor Red
        exit 1
    }
    $loopState = Get-Content $loopStatePath -Raw -Encoding UTF8 | ConvertFrom-Json
    $loopAtual = $loopState.loop_atual

    $deliberacaoPath = "$base\CLIENTES\$Cliente\HISTORICO\DELIBERACAO_LOOP_V${loopAtual}_${Cliente}.md"
    if (-not (Test-Path $deliberacaoPath)) {
        Write-Host "" -ForegroundColor Red
        Write-Host "================================================================" -ForegroundColor Red
        Write-Host "  GATE P-037 BLOQUEADO -- DELIBERACAO_LOOP nao existe           " -ForegroundColor Red
        Write-Host "================================================================" -ForegroundColor Red
        Write-Host "  Arquivo esperado:" -ForegroundColor Yellow
        Write-Host "  $deliberacaoPath" -ForegroundColor Yellow
        Write-Host "" -ForegroundColor Red
        Write-Host "  MUSCULO: antes de gerar DECISOES.json, voce DEVE:" -ForegroundColor Red
        Write-Host "  1. ultrathink-trigger: calcular score (>= 5 -> prefixar ultrathink:)" -ForegroundColor Yellow
        Write-Host "  2. Skill('brainstorming'): deliberar cada ideia com 7 pontos" -ForegroundColor Yellow
        Write-Host "  3. Gravar DELIBERACAO_LOOP_V${loopAtual}_${Cliente}.md" -ForegroundColor Yellow
        Write-Host "  [Somente entao] writing-plans apos veredito do Diretor" -ForegroundColor Yellow
        Write-Host "" -ForegroundColor Red
        Write-Host "================================================================" -ForegroundColor Red
        exit 1
    }

    # Verificar evidencia de skills no arquivo
    $deliberacaoContent = Get-Content $deliberacaoPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    $temUltrathink = $deliberacaoContent -match "ultrathink"
    $temBrainstorm = $deliberacaoContent -match "brainstorm|7 pontos|certo.*diverge|PARTE 1.*PARTE 2"

    if (-not $temUltrathink -or -not $temBrainstorm) {
        Write-Host "" -ForegroundColor Yellow
        Write-Host "  [GATE P-037 AMARELO] DELIBERACAO_LOOP existe mas pode estar incompleto" -ForegroundColor Yellow
        if (-not $temUltrathink) { Write-Host "  FALTANDO: prefixo 'ultrathink:' na analise" -ForegroundColor Yellow }
        if (-not $temBrainstorm) { Write-Host "  FALTANDO: evidencia do framework brainstorming (7 pontos)" -ForegroundColor Yellow }
        Write-Host "" -ForegroundColor Yellow
        exit 2
    }

    Write-Host "[GATE P-037 VERDE] DELIBERACAO_LOOP_V${loopAtual} com evidencia de skills -- OK" -ForegroundColor Green
    exit 0
}

# Modo padrao: exibir lembrete BLOQUEANTE antes de analisar output do Embaixador
Write-Host ""
Write-Host "================================================================" -ForegroundColor Red
Write-Host "  GATE P-037 -- 3 SKILLS OBRIGATORIAS ANTES DE QUALQUER ANALISE" -ForegroundColor Red
Write-Host "================================================================" -ForegroundColor Red
Write-Host ""
Write-Host "  SEQUENCIA INVIOLAVEL:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. ultrathink-trigger                                [NAO e Skill()]" -ForegroundColor Yellow
Write-Host "     -> Read('.claude/skills/ultrathink-trigger.md')" -ForegroundColor Gray
Write-Host "     -> Calcular score de complexidade (P-037 = SEMPRE >= 5)" -ForegroundColor Gray
Write-Host "     -> Prefixar toda analise com 'ultrathink:'" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Skill('brainstorming')                             [INVOCAR VIA Skill tool]" -ForegroundColor Yellow
Write-Host "     -> Deliberar CADA ideia com 7 pontos completos:" -ForegroundColor Gray
Write-Host "        certo->diverge->decisao->enhancement->custo->impacto->acao" -ForegroundColor Gray
Write-Host "     -> Gravar DELIBERACAO_LOOP_V[N]_[CLIENTE].md ANTES de DECISOES.json" -ForegroundColor Gray
Write-Host "     -> HARD-GATE: zero DECISOES.json antes do veredito do Diretor" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. Skill('writing-plans')            [SOMENTE APOS veredito do Diretor]" -ForegroundColor Yellow
Write-Host "     -> Plano bite-sized: arquivos exatos + commits + [RESOLVE:] tags" -ForegroundColor Gray
Write-Host "     -> Popula PENDENTES.md com tasks prontas para execucao" -ForegroundColor Gray
Write-Host ""
Write-Host "  VERIFICAR SE DELIBERACAO EXISTE:" -ForegroundColor Cyan
Write-Host "  .\\scripts\\check_skills_embaixador.ps1 -Cliente VANGUARD -Verificar" -ForegroundColor Gray
Write-Host ""
Write-Host "  SKILLS ERRADAS (NAO USAR AQUI): mcp-builder, notebooklm" -ForegroundColor DarkRed
Write-Host "  Erro documentado: 2026-06-10 -- Diretor sentiu-se enganado." -ForegroundColor DarkRed
Write-Host ""
Write-Host "================================================================" -ForegroundColor Red
Write-Host ""