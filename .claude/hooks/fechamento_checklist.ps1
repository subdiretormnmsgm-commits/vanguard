# HOOK: PostToolUse (Bash)
# Protege contra: Amnesia de Sessao no fechamento + P-010 (verificar cada etapa)
# Exibe checklist obrigatorio do ritual de fechamento apos git commit

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$inputJson = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputJson)) { exit 0 }

$data = $inputJson | ConvertFrom-Json -ErrorAction SilentlyContinue
if ($null -eq $data) { exit 0 }

$command = ""
if ($data.tool_input.command) { $command = $data.tool_input.command }

# Ativa apenas em git commits
if ($command -notmatch "git commit") { exit 0 }

$checklist = @"
+----------------------------------------------------------+
|       RITUAL DE FECHAMENTO -- PENTALATERAL IAH          |
+----------------------------------------------------------+
|  [ ] MEMORIA_VX.md gerado e commitado                   |
|  [ ] relatorio_evolutivo_VX.md (SWOT + PDCA + 5W2H)    |
|  [ ] 5 ideias disruptivas listadas no relatorio          |
|  [ ] INTELLIGENCE_LEDGER.md atualizado com friccoes      |
|  [ ] WIP_BOARD.json atualizado (status do projeto)      |
|  [ ] PASSO3_GEMINI.md pronto para proximo loop           |
|  Se fechar versao: sincronizar .claude/skills/           |
+----------------------------------------------------------+
"@

$output = [ordered]@{
    hookSpecificOutput = [ordered]@{
        hookEventName = "PostToolUse"
        systemMessage = $checklist
    }
} | ConvertTo-Json -Depth 3 -Compress

Write-Output $output
exit 0
