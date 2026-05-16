# HOOK: Stop
# Protege contra: sessao que termina sem ritual de fechamento
# Exibe checklist obrigatorio sempre que a sessao encerrar (com ou sem commit)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$checklist = @"
+----------------------------------------------------------+
|       RITUAL DE FECHAMENTO -- QUADRILATERAL IAH          |
|       (sessao encerrando -- verifique antes de sair)     |
+----------------------------------------------------------+
|  [ ] E-MAIL gerado pelo Musculo e enviado pelo Diretor  |
|      (subdiretor.mnmsgm@gmail.com) -- OBRIGATORIO        |
|      Conteudo: entregas do dia + alertas + proximo gate  |
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
        hookEventName = "Stop"
        systemMessage = $checklist
    }
} | ConvertTo-Json -Depth 3 -Compress

Write-Output $output
exit 0
