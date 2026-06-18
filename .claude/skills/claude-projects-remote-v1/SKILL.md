---
name: claude-projects-remote-v1
description: "Camada técnica pura para operar o Claude.ai via Playwright MCP — navegar, excluir arquivos, fazer upload, enviar mensagens. Invocar antes de qualquer operação remota no Claude Projects."
---

SKILL: claude-projects-remote-v1.md
Camada: Infraestrutura Pentalateral (Universal) | Stack: Claude.ai Projects + Playwright MCP + browser_file_upload

[AUDITORIA DE COERENCIA]
Claude.ai nao tem API publica de administracao. Toda operacao remota — excluir arquivo, fazer upload, enviar mensagem — exige Playwright MCP. O Playwright usa um contexto de browser separado do browser pessoal do Diretor: o login pode exigir "Continue with Google" com a conta subdiretor.mnmsgm@gmail.com. Coerencia com P-110: arquivos locais sao a fonte canonica — Claude Projects recebe copias para contexto do Embaixador, nunca edita originais. Coerencia com P-060: o Musculo executa toda operacao sem intervencao do Diretor. Esta skill e a base tecnica invocada por embaixador-encerramento-v1 e embaixador-passo7-[cliente]-v1 — nao contem lista de arquivos nem contexto de projeto.

[CONEXAO HISTORICA]
Operacao inaugural 2026-06-14 (Loop 33 V2, LEDGER P-114/P-032): Musculo excluiu 7 arquivos antigos e fez upload de 7 atualizados no projeto "Embaixador - Diretor". Erros descobertos nesta operacao: (1) browser_click exige parametro target como string — "expected string, received undefined" ao usar ref como named param; (2) refs dos botoes Excluir mudam apos cada exclusao — snapshot obrigatorio entre cada delete; (3) file chooser fecha em poucos segundos — browser_file_upload deve ser chamado imediatamente apos "Carregar do aparelho"; (4) ENOENT silencioso se path do arquivo estiver errado — Glob obrigatorio antes de qualquer upload. Todas as correcoes validadas na mesma sessao. Refs: INTELLIGENCE_LEDGER.md P-114, WIP_BOARD.json Loop 33 V2.

[PADRAO DE SUCESSO/FALHA]
SUCESSO VALIDADO — Exclusao sequencial: browser_snapshot -> identificar ref do botao Excluir -> browser_click target=<ref> -> browser_snapshot (nova ref) -> repetir. Nunca tentar excluir multiplos arquivos sem snapshot entre cada um.
SUCESSO VALIDADO — Upload via file chooser: browser_click "Adicionar arquivos" -> browser_click "Carregar do aparelho" -> browser_file_upload paths=[lista absoluta] imediatamente. Todos os arquivos em uma unica chamada.
SUCESSO VALIDADO — Verificacao pos-upload: browser_snapshot na area de arquivos — confirmar nome e tamanho de cada item listado antes de prosseguir.
FALHA (BLOQUEANTE) — browser_file_upload sem chooser ativo: erro "no active file chooser". Causa: clicou "Adicionar arquivos" mas nao clicou "Carregar do aparelho", ou aguardou tempo demais. Solucao: repetir o fluxo sem pausas.
FALHA (BLOQUEANTE) — fill() ou browser_type em campos nao-padrao: Claude.ai usa React controlado — eventos sinteticos podem ser ignorados. Usar browser_type apenas em campos de chat nativos.
GATE APRENDIDO — Glob obrigatorio antes de montar a lista de paths: um path errado causa ENOENT silencioso e o arquivo nao e enviado sem aviso de erro visivel.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, opero sobre uma UI web sem contrato de estabilidade — seletores e fluxos podem mudar a qualquer update do Claude.ai. Recomendacoes obrigatorias: (1) sempre tirar browser_snapshot antes de qualquer acao para obter refs atuais; (2) verificar login antes de operar — se URL redirecionar para /logout, clicar "Continue with Google" com subdiretor.mnmsgm@gmail.com; (3) confirmar resultado de cada operacao via snapshot antes de avancar; (4) nunca assumir que o upload foi concluido sem verificar a lista de arquivos na UI. IDEIA DISRUPTIVA: criar script PowerShell claude_projects_sync.ps1 que gera os comandos Playwright automaticamente a partir da lista de arquivos — eliminando risco de path errado ou ordem incorreta. PROPONHO adicionar ao PENDENTES como evolucao desta camada tecnica.

---

## FLUXO TECNICO

### Navegacao e login
1. browser_navigate "https://claude.ai/project/<ID>"
2. Se redirecionar para /logout -> browser_click "Continue with Google" -> selecionar subdiretor.mnmsgm@gmail.com

### Exclusao de arquivo (repetir para cada arquivo)
1. browser_snapshot -> localizar botao Excluir do arquivo alvo -> anotar ref
2. browser_click target="<ref>"
3. browser_snapshot -> confirmar remocao + obter nova ref do proximo arquivo

### Upload de arquivos
1. browser_click "Adicionar arquivos"
2. browser_click "Carregar do aparelho" (file chooser ativa)
3. browser_file_upload paths=["<path1>","<path2>",...] (imediatamente)
4. browser_snapshot -> confirmar lista de arquivos na UI

### Envio de mensagem
1. browser_click no campo de chat
2. browser_type texto da mensagem
3. browser_press_key "Enter" ou clicar botao de enviar