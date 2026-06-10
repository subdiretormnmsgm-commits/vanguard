# check_skills_embaixador.ps1
# Exibe as 3 skills obrigatórias antes de qualquer analise de output do Embaixador.
# Rodar quando: Diretor colar SECAO D / E-1..E-5 no chat.
# P-146: ferramenta que previne repeticao do erro de skills erradas (2026-06-10).

Write-Host ""
Write-Host "================================================================" -ForegroundColor Red
Write-Host "  MUSCULO: ANTES DE ANALISAR O EMBAIXADOR -- 3 SKILLS OBRIG.   " -ForegroundColor Red
Write-Host "================================================================" -ForegroundColor Red
Write-Host ""
Write-Host "  1. ultrathink-trigger" -ForegroundColor Yellow
Write-Host "     Read('.claude/skills/ultrathink-trigger.md')" -ForegroundColor Gray
Write-Host "     Calcular peso de complexidade. Se >= 5: prefixar 'ultrathink:'" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. brainstorming" -ForegroundColor Yellow
Write-Host "     Skill('brainstorming')" -ForegroundColor Gray
Write-Host "     7 pontos por ideia: certo->diverge->decisao->enhancement->custo->impacto->acao" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. writing-plans" -ForegroundColor Yellow
Write-Host "     Skill('writing-plans') -- SOMENTE APOS veredito do Diretor" -ForegroundColor Gray
Write-Host "     Gera plano de implementacao das ideias aprovadas" -ForegroundColor Gray
Write-Host ""
Write-Host "  SEQUENCIA: ultrathink -> brainstorm -> sintese P-037 -> DECISOES.json" -ForegroundColor Cyan
Write-Host "             -> veredito Diretor -> PASSO7.5 -> writing-plans" -ForegroundColor Cyan
Write-Host ""
Write-Host "  SKILLS ERRADAS (NAO USAR): mcp-builder, notebooklm" -ForegroundColor DarkRed
Write-Host "  Erro registrado em 2026-06-10 -- Diretor sentiu-se enganado." -ForegroundColor DarkRed
Write-Host ""
Write-Host "================================================================" -ForegroundColor Red
Write-Host ""
