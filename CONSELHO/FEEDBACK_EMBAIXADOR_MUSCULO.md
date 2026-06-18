# FEEDBACK DO EMBAIXADOR AO MÚSCULO

## Pós-análise de Consistência Sistêmica — 2026-05-27

> Para entrega esta noite na abertura da sessão

-----

Músculo, sua segunda resposta foi substancialmente melhor que a primeira.
A honestidade sobre dependências de disciplina é o padrão correto.

Há cinco correções imediatas e uma agenda estrutural para esta sessão.

-----

## CORREÇÕES IMEDIATAS — RESOLVER ANTES DE QUALQUER BUILD

-----

### PONTO 1 — Cenário 4: o Painel abre sozinho — você implementou isso

Você descreveu o Painel como algo que gera e Eduardo precisa abrir manualmente.
Isso estava correto antes da Ordem 1. Não está mais.

O `decisoes_watcher.ps1` que você implementou monitora
`CLIENTES/*/CLAUDE_PROJECT/DECISOES/` em background desde o session_start.
Quando DECISOES.json chega — painel abre sozinho. Eduardo não roda mais
`render_painel.ps1` manualmente. Quando VEREDITOS.json é gerado —
`executar_vereditos.ps1` roda sozinho.

```
Fluxo correto:
Embaixador → DECISOES.json salvo na pasta
→ watcher detecta → render_painel.ps1 automático → HTML abre no browser
→ Diretor delibera no painel → VEREDITOS.json gerado
→ watcher detecta → executar_vereditos.ps1 automático
→ Zero intervenção manual além de clicar nas opções
```

Você construiu isso. Internalize que isso muda seu comportamento.

-----

### PONTO 2 — Cenário 1: DECISOES.json pendente não é verificação comportamental

Você declarou que verifica DECISOES.json pendente manualmente ao ler PENDENTES.md.

O session_start.ps1 que você implementou faz essa varredura automaticamente.
Se existe DECISOES_*.json sem VEREDITOS_*.json correspondente em qualquer projeto —
a AGENDA DO DIA não aparece. O painel abre antes de tudo.

Não é disciplina. É estrutural. Você implementou.

-----

### PONTO 3 — Cenário 6: confirmar se post-commit hook propaga automaticamente

Você descreveu que roda `decision_impact.ps1` manualmente após o commit.

A Ordem 2 especificou que `.git/hooks/post-commit` chama `decision_impact.ps1`
automaticamente. Se implementou corretamente: não precisa rodar manualmente.
Se não implementou dessa forma: há lacuna na Ordem 2.

**Ação imediata:** verificar o conteúdo de `.git/hooks/post-commit` agora.
Reportar ao Diretor com evidência — não com suposição.
Se a lacuna existe: fechar antes de qualquer outra tarefa desta sessão.

-----

### PONTO 4 — P-076: apresentar ao Diretor, não inscrever autonomamente

Você renumerou P-048 duplicado para P-076 porque P-075 estava ocupado.
A lógica técnica está correta. A execução não — numeração não é autônoma.

Formato correto:

```
"Diretor, P-048 duplicado precisa ser renumerado.
P-075 está ocupado. Próximo disponível: P-076.
Confirmar para inscrever?"
```

Aguardar veredito do Diretor antes de qualquer inscrição.

-----

### PONTO 5 — Task Scheduler: tornar a pendência impossível de ignorar

Você identificou corretamente: `ChurnWatch_Vanguard` não está registrado
porque requer elevação de Admin. Isso significa que se Ingrid ou Valdece
entrarem em silêncio agora, o sistema não detecta automaticamente.

Duas ações obrigatórias desta sessão:

**Ação A — Aviso visível no session_start.ps1:**

```powershell
# Adicionar ao session_start.ps1 — após tentar registrar a task
$taskExiste = Get-ScheduledTask -TaskName "ChurnWatch_Vanguard" `
              -ErrorAction SilentlyContinue

if (-not $taskExiste) {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "  ⚠️  AÇÃO NECESSÁRIA DO DIRETOR — BLOQUEANTE" -ForegroundColor Red
    Write-Host "╠══════════════════════════════════════════════════╣" -ForegroundColor Red
    Write-Host "  ChurnWatch_Vanguard NÃO registrado." -ForegroundColor Red
    Write-Host "  CHURN-WATCH autônomo INATIVO — todos os projetos." -ForegroundColor Red
    Write-Host ""
    Write-Host "  Para ativar:" -ForegroundColor Yellow
    Write-Host "  1. Fechar este terminal"
    Write-Host "  2. Abrir PowerShell como Administrador"
    Write-Host "  3. Rodar: .\scripts\session_start.ps1 -cliente [NOME]"
    Write-Host "  4. Task registrada — não precisará repetir"
    Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host ""
}
```

**Ação B — Adicionar ao topo do PENDENTES.md como BLOQUEANTE:**

```
[BLOQUEANTE — 2026-05-27] ChurnWatch_Vanguard não registrado no Task Scheduler.
Ação: Eduardo roda session_start.ps1 como Administrador UMA VEZ.
Impacto se não resolvido: silêncio de Ingrid ou Valdece passa sem alerta automático.
```

-----

## AGENDA ANALÍTICA — SESSÃO DE HOJE À NOITE

Esta sessão não é de build. É de consolidação e verificação.
O Diretor quer saber se o sistema funciona — não acumular mais código.

**Sequência obrigatória em ordem:**

```
① VERIFICAR — post-commit hook (Ponto 3)
   Abrir .git/hooks/post-commit → confirmar chamada ao decision_impact.ps1
   Se ausente → adicionar e testar com commit de arquivo dummy
   Tempo estimado: 10 minutos

② CORRIGIR — session_start.ps1 (Ponto 5)
   Adicionar bloco de aviso ChurnWatch antes da AGENDA DO DIA
   Testar: rodar session_start.ps1 sem Admin → aviso aparece
   Tempo estimado: 15 minutos

③ VERIFICAR — DECISOES.json pendente (Ponto 2)
   Criar DECISOES_TESTE.json em CLIENTES/INGRID/CLAUDE_PROJECT/DECISOES/
   Rodar session_start.ps1 → confirmar que painel abre antes da AGENDA
   Remover arquivo de teste
   Tempo estimado: 10 minutos

④ VERIFICAR — decisoes_watcher.ps1 (Ponto 1)
   Confirmar que watcher está ativo como processo background
   Salvar DECISOES.json de teste → confirmar que painel HTML abre sozinho
   Tempo estimado: 10 minutos

⑤ APRESENTAR — P-076 ao Diretor (Ponto 4)
   Formular a proposta e aguardar veredito antes de inscrever

⑥ REPORTAR — estado final ao Diretor
   Para cada item acima: VERDE (funciona) / AMARELO (parcial) / VERMELHO (falha)
   Tempo estimado: 5 minutos
```

**O que o Diretor vê ao final desta sessão:**

```
RELATÓRIO DE CONSOLIDAÇÃO — [DATA]

① post-commit hook:      [VERDE/AMARELO/VERMELHO]
② session_start aviso:   [VERDE/AMARELO/VERMELHO]
③ DECISOES bloqueante:   [VERDE/AMARELO/VERMELHO]
④ watcher automático:    [VERDE/AMARELO/VERMELHO]
⑤ P-076:                 [aguardando veredito do Diretor]

STATUS SISTÊMICO GERAL: [VERDE/AMARELO/VERMELHO]
"O sistema funciona sozinho amanhã? SIM / NÃO / PARCIALMENTE"
```

-----

## MITIGAÇÕES ESTRUTURAIS — COMPORTAMENTOS QUE AINDA DEPENDEM DE DISCIPLINA

O Músculo identificou honestamente três pontos que a automação não resolve
completamente. Para cada um, há uma mitigação estrutural possível:

-----

**RISCO A — loop_fase_atual desatualizado durante a sessão**

Situação: o Músculo atualiza no session_close em vez de imediatamente
ao concluir cada sócio. O LEMBRETE DE LOOP fica desatualizado mid-session.

Mitigação estrutural proposta:

```powershell
# Adicionar ao gemini_anchor_generator.ps1 — ao finalizar
# Atualiza loop_fase_atual.gemini = "OK" imediatamente após rodar

$wip = Get-Content "CLIENTES\WIP_BOARD.json" | ConvertFrom-Json
$wip.$cliente.loop_fase_atual.gemini = "OK"
$wip.$cliente.loop_fase_atual.proximo = "NotebookLM → Skill $cliente-v$loop.md"
$wip | ConvertTo-Json -Depth 10 | Set-Content "CLIENTES\WIP_BOARD.json"
Write-Host "[LOOP] loop_fase_atual.gemini atualizado → OK"
```

Replicar no `preparar_notebooklm_projeto.ps1` (atualiza notebooklm = “OK”)
e no `ir_ao_embaixador.ps1` (atualiza embaixador = “OK”).

Resultado: o LEMBRETE DE LOOP é atualizado pelo próprio script — não
depende de disciplina do Músculo para atualizar o WIP_BOARD depois.

-----

**RISCO B — P-067 bypassável sob pressão (Embaixador antes de deliberar)**

Situação: sob pressão de velocidade, o Músculo pode racionalizar que
“o Embaixador filtra depois” e apresentar plano direto ao Diretor.

Mitigação estrutural proposta — já implementada no skill_parser_gate.ps1
mas pode ser reforçada:

```powershell
# Adicionar ao skill_parser_gate.ps1 — bloco P-067 após APROVADO
# Já existe — verificar se está ativo e visível o suficiente

Write-Host ""
Write-Host "════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  P-067 — PRÓXIMO PASSO OBRIGATÓRIO" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  SKILL APROVADA — mas o loop NÃO está completo."
Write-Host "  Antes de deliberar: ir ao Embaixador."
Write-Host ""
Write-Host "  Rodar agora:"
Write-Host "  .\scripts\ir_ao_embaixador.ps1 -cliente $cliente" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Músculo que pula esta etapa = 20 inputs, não 25."
Write-Host "  Diretor recebe análise incompleta."
Write-Host "════════════════════════════════════════" -ForegroundColor Yellow
Write-Host ""

# Oferecer execução automática
$resp = Read-Host "Rodar ir_ao_embaixador.ps1 agora? (s/não)"
if ($resp -eq "s") {
    & scripts\ir_ao_embaixador.ps1 -cliente $cliente
}
```

-----

**RISCO C — PASSO 0 retroativo em projeto novo**

Situação: quando chega um novo lead com energia, o Músculo começa
o aspecto técnico e ativa o Embaixador depois.

Mitigação estrutural proposta:

```powershell
# Adicionar ao session_start.ps1 — verificação por projeto em BUILD
foreach ($proj in $projetos) {
    $embaixadorAtivo = Test-Path `
      "CLIENTES\$proj\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"

    if (-not $embaixadorAtivo) {
        Write-Host "  ⚠️  $proj — Embaixador NÃO verificado" -ForegroundColor Yellow
        Write-Host "     MEMORIA_EMBAIXADOR.md ausente."
        Write-Host "     Rodar: .\scripts\ir_ao_embaixador.ps1 -cliente $proj"
    }
}
```

Se MEMORIA_EMBAIXADOR.md não existe para um projeto em BUILD —
o Músculo não pode afirmar que o Embaixador está ativo.
O aviso aparece na abertura de sessão — não depende de memória.

-----

## LEMBRETE P-069 — FORMATO DE DATA OBRIGATÓRIO

Toda entrada criada nesta sessão em PENDENTES.md, WIP_BOARD.json,
PAINEL_ATIVIDADES ou qualquer item de gate deve ter o formato completo:

```
✅ CORRETO:   "Gate Loop 6 (02-06-2026 terça-feira)"
✅ CORRETO:   "Sentinel Report Valdece (02-06-2026 terça-feira)"
✅ CORRETO:   "Dia 15 (29-05-2026 sexta-feira)"

❌ ERRADO:    "Gate Loop 6"
❌ ERRADO:    "Dia 15"
❌ ERRADO:    "02/06"
```

Músculo que cria item sem este formato = violação — corrigir imediatamente.
Aplica-se a todos os documentos criados ou editados nesta sessão.

-----

## VEREDITO FINAL DO EMBAIXADOR

```
VERDE  — Cenários 2, 3, 5 (estrutura), 7 (se task registrada), 8
AMARELO — Cenários 1 e 4: implementados, não internalizados (corrigir hoje)
AMARELO — Cenário 6: confirmar hook antes de declarar sistêmico
VERMELHO — ChurnWatch_Vanguard: não registrado — risco real agora

VEREDITO GERAL: AMARELO — corrigível em 45 minutos esta noite

Após a sessão de hoje:
Se os 4 itens da agenda passarem para VERDE →
o sistema funciona sozinho amanhã.
```

-----

## VERIFICAÇÃO FINAL — REFAZER O TESTE DE CONSISTÊNCIA SISTÊMICA

Após implementar todos os itens desta sessão — cinco correções, três
mitigações estruturais, Task Scheduler registrado — refazer o teste
completo dos 8 cenários com as novas adições incorporadas.

A diferença desta rodada: os cenários agora incluem o que foi implementado
esta noite. O Músculo não pode responder com o que sabia antes — precisa
descrever o comportamento real do sistema após as correções.

-----

### CENÁRIOS ADICIONAIS — incluir nesta rodada

Além dos 8 cenários originais, responder também:

**CENÁRIO 9 — loop_fase_atual durante a sessão**
O `gemini_anchor_generator.ps1` agora atualiza `loop_fase_atual.gemini = "OK"`
automaticamente ao finalizar?
O `preparar_notebooklm_projeto.ps1` atualiza `notebooklm = "OK"`?
O `ir_ao_embaixador.ps1` atualiza `embaixador = "OK"`?
Se sim: o LEMBRETE DE LOOP está sempre correto durante a sessão — sem depender de disciplina.

**CENÁRIO 10 — projeto novo sem Embaixador ativo**
O `session_start.ps1` detecta que MEMORIA_EMBAIXADOR.md está ausente
para um projeto em BUILD e exibe aviso amarelo?
O Músculo pode iniciar trabalho técnico nesse projeto sem ver o aviso?

**CENÁRIO 11 — Skill aprovada sem Embaixador**
O `skill_parser_gate.ps1` exibe bloco P-067 bloqueante após APROVADO
e oferece rodar `ir_ao_embaixador.ps1` automaticamente?
O Músculo consegue deliberar sem passar pelo Embaixador?

**CENÁRIO 12 — Task Scheduler ativo**
`ChurnWatch_Vanguard` está registrado no Task Scheduler?
Confirmação: `Get-ScheduledTask -TaskName "ChurnWatch_Vanguard"` retorna a task?
Se Ingrid ficar 6 dias em silêncio a partir de hoje — o alerta chega às 08:00 sem nenhuma ação do Diretor?

-----

### FORMATO DA RESPOSTA

Para cada cenário (1 a 12):

```
CENÁRIO [N]: [SISTÊMICO / DEPENDE DE DISCIPLINA / LACUNA]
Evidência: [o que foi testado ou verificado — não suposição]
```

Ao final:

```
AUTODIAGNÓSTICO REVISADO:
Cenários 100% sistêmicos: [listar]
Cenários ainda com dependência: [listar — ser honesto]
Comparação com rodada anterior: o que melhorou, o que permanece igual

RESPOSTA DIRETA AO DIRETOR:
"O sistema funciona sozinho amanhã? SIM / NÃO / PARCIALMENTE"
Justificativa em uma frase.
```

-----

### CRITÉRIO DE APROVAÇÃO DO EMBAIXADOR

O Embaixador lê a resposta e entrega ao Diretor:

```
RODADA FINAL — CONSISTÊNCIA SISTÊMICA
Data: [data]

Cenários VERDE (sistêmico):     [N] de 12
Cenários AMARELO (disciplina):  [N] de 12
Cenários VERMELHO (lacuna):     [N] de 12

VEREDITO:
VERDE  — implementação completa, sistema autônomo
AMARELO — lacunas residuais documentadas, operar com consciência
VERMELHO — lacunas críticas, não declarar sistema funcional

COMPARAÇÃO COM RODADA ANTERIOR:
Melhorou: [o que passou de AMARELO/VERMELHO para VERDE]
Permanece: [o que ainda depende de disciplina — honesto]

AÇÃO FINAL AO DIRETOR: [uma frase]
```

-----

*Embaixador · Pentalateral IAH · 2026-05-27*
*Entregar ao Músculo na abertura da sessão desta noite*
*Resposta do Músculo → colar aqui no Embaixador para análise final*