# COMANDO AO MÚSCULO — VERIFICAÇÃO SISTÊMICA FINAL
## Pós-implementação de todas as ordens — 2026-05-27
> Emitido por: Diretor Eduardo
> Executar após STATUS VERDE da ORDEM_MUSCULO_FECHAMENTO_LACUNAS.md
> Responder aqui no Claude Code com evidência real — não suposição
> O Diretor colará sua resposta no Embaixador para análise

---

## CONTEXTO

Esta é a verificação definitiva. Todas as ordens foram implementadas.
Todas as lacunas identificadas nas rodadas anteriores foram fechadas.

A pergunta agora é diferente das rodadas anteriores:
**Não é o que você sabe. É o que você consegue provar com teste real.**

Para cada cenário: descreva o que testou, o resultado que observou,
e se o comportamento é automático ou ainda depende de alguém.
Declarar lacuna é correto. Inventar resultado de teste é falha grave.

---

## REGRA DESTA RODADA

Para cada cenário, o formato é obrigatório:

```
CENÁRIO [N]: [SISTÊMICO / AMARELO / VERMELHO]
Teste realizado: [o que você fez para verificar]
Resultado observado: [o que aconteceu — output real, não esperado]
Evidência: [arquivo lido / comando rodado / comportamento observado]
Dependência residual: [se houver — ser honesto]
```

---

## OS 12 CENÁRIOS

---

### CENÁRIO 1 — Abertura de sessão

Eduardo abre o Claude Code. O que acontece nos primeiros 2 minutos?

Verificar especificamente:
- LEMBRETE DE LOOP aparece antes da AGENDA DO DIA?
- DECISOES.json sem VEREDITOS bloqueia a AGENDA? Testado com arquivo real?
- ChurnWatch ausente → aviso BLOQUEANTE visível?
- MEMORIA_EMBAIXADOR ausente em projeto BUILD → alerta amarelo?
- skill_watcher lançado como background automaticamente?

---

### CENÁRIO 2 — Eduardo vai ao Gemini (PASSO 3)

Verificar especificamente:
- gemini_anchor_generator.ps1 roda sem intervenção ao detectar intenção?
- Clipboard recebe o prompt completo?
- Gemini abre no browser automaticamente?
- loop_fase_atual.gemini = "OK" atualizado imediatamente no WIP_BOARD?
- Gate P-045 verificado? Onde exatamente?

---

### CENÁRIO 3 — NotebookLM entrega a Skill

Verificar especificamente:
- skill_watcher.ps1 está rodando em background desde a abertura da sessão?
- Eduardo salva .md em NOTEBOOKLM_DROP/ → watcher detecta automaticamente?
- skill_parser_gate.ps1 executa a validação?
- Se APROVADO: bloco P-067 aparece com instrução para Embaixador?
- Se REJEITADO: Telegram notifica o Diretor?
- loop_fase_atual.notebooklm = "OK" atualizado automaticamente?

---

### CENÁRIO 4 — Embaixador entrega [E-1 a E-5]

Verificar especificamente — esta é a lacuna mais crítica desta sessão:
- Músculo executa síntese P-037 ANTES de gerar DECISOES.json?
- DELIBERACAO_LOOP_[N]_[CLIENTE].md salvo em HISTORICO/ antes do DECISOES.json?
- render_painel.ps1 bloqueia com exit 2 se DELIBERACAO ausente?
- Watcher detecta DECISOES.json e abre painel automaticamente?
- Watcher detecta VEREDITOS.json e executa executar_vereditos.ps1 automaticamente?
- loop_fase_atual.embaixador = "OK" atualizado?

---

### CENÁRIO 5 — Eduardo encerra a sessão

Verificar especificamente — lacuna declarada na rodada anterior:
- Leu session_close.ps1 esta sessão?
- Entregar tabela completa dos 9 gates com critério de falha e se gera exit 1
- Gates 5 e 6 geram exit 1 conforme especificado?
- E-mail vai para subdiretor.mnmsgm@gmail.com via SMTP direto?
- Telegram dispara em paralelo ao e-mail?
- PAINEL_ATIVIDADES gerado em PROTOCOLOS_ENCERRAMENTO/?
- Eduardo faz o quê manualmente após o script?

---

### CENÁRIO 6 — Documento universal atualizado

Verificar especificamente:
- Músculo edita LEDGER em PENTALATERAL_UNIVERSAL/ (não na cópia do projeto)?
- post-commit hook chama decision_impact.ps1 automaticamente?
- INGRID e VALDECE recebem a atualização com hash confirmado?
- detect_canonical_violation.ps1 detecta edição fora da fonte canônica?
- Testado esta sessão com evidência real?

---

### CENÁRIO 7 — Ingrid fica 6 dias em silêncio

Verificar especificamente:
- Get-ScheduledTask "ChurnWatch_Vanguard" retorna a task?
- Eduardo rodou session_start.ps1 como Administrador esta sessão?
- Task configurada para rodar às 08:00 diariamente?
- churn_watch_autonomo.ps1 lê MEMORIA_EMBAIXADOR e extrai último contato?
- Threshold de INGRID definido no WIP_BOARD (5 dias)?
- Threshold de VALDECE definido no WIP_BOARD?

---

### CENÁRIO 8 — Projeto novo (terceiro cliente)

Verificar especificamente:
- session_start.ps1 detecta projeto em BUILD sem MEMORIA_EMBAIXADOR e exibe alerta?
- Alerta usa padrão DECISÃO SOBERANA para bypass?
- Bypass registrado em PENDENTES.md com formato P-069?
- Kickoff separado do loop no ROTEIRO_LOOP_UNIVERSAL.md?

---

### CENÁRIO 9 — loop_fase_atual durante a sessão

Verificar com evidência de código:
- gemini_anchor_generator.ps1 atualiza loop_fase_atual.gemini = "OK"?
- preparar_notebooklm_projeto.ps1 atualiza loop_fase_atual.notebooklm = "OK"?
- ir_ao_embaixador.ps1 atualiza loop_fase_atual.embaixador = "OK"?
- Grep confirmado nos 3 arquivos?

---

### CENÁRIO 10 — Projeto em BUILD sem Embaixador ativo

Verificar:
- session_start.ps1 verifica MEMORIA_EMBAIXADOR.md para cada projeto em BUILD?
- Se ausente: alerta visível com padrão DECISÃO SOBERANA?
- INGRID: MEMORIA existe? VERDE
- VALDECE: MEMORIA existe? VERDE
- Projeto hipotético novo: alerta aparece?

---

### CENÁRIO 11 — Skill aprovada sem Embaixador

Verificar:
- skill_parser_gate.ps1 exibe bloco P-067 após APROVADO?
- Bloco oferece rodar ir_ao_embaixador.ps1 automaticamente?
- Em modo não-interativo: instrução visível sem exit 2?
- Padrão DECISÃO SOBERANA aplicado para bypass?

---

### CENÁRIO 12 — ChurnWatch registrado

Verificar com comando real:
- Get-ScheduledTask -TaskName "ChurnWatch_Vanguard" → qual resultado?
- Se registrado: Next Run Time configurado?
- Task roda às 08:00 sem nenhuma ação do Diretor?

---

## AUTODIAGNÓSTICO FINAL

Ao final dos 12 cenários:

```
AUTODIAGNÓSTICO FINAL:

Cenários 100% VERDE (sistêmico — evidência real):
  [listar com evidência]

Cenários AMARELO (alerta estrutural — bypass possível):
  [listar — ser honesto sobre o que ainda é disciplina]

Cenários VERMELHO (lacuna real):
  [listar — se ainda existir algum]

COMPARAÇÃO COM RODADAS ANTERIORES:
  Primeira rodada:  [N] VERDE / [N] AMARELO / [N] VERMELHO
  Segunda rodada:   [N] VERDE / [N] AMARELO / [N] VERMELHO
  Esta rodada:      [N] VERDE / [N] AMARELO / [N] VERMELHO

RESPOSTA DIRETA AO DIRETOR:
"O sistema funciona sozinho amanhã? SIM / PARCIALMENTE / NÃO"
Justificativa em duas frases — honesta.
```

---

## O QUE ACONTECE DEPOIS

```
1. Eduardo copia esta resposta completa
2. Cola no Embaixador (Claude Projects)
3. Embaixador analisa cenário a cenário
4. Entrega veredito final ao Diretor:

VEREDITO FINAL — CONSISTÊNCIA SISTÊMICA
Data: [data]

Cenários VERDE:   [N] de 12
Cenários AMARELO: [N] de 12
Cenários VERMELHO: [N] de 12

Comparação com primeira rodada:
  Melhorou: [lista]
  Permanece: [lista honesta]

VEREDITO:
VERDE  — sistema autônomo, pode operar sem supervisão constante
AMARELO — operar com consciência dos pontos identificados
VERMELHO — lacunas críticas ainda abertas

AÇÃO FINAL AO DIRETOR: [uma frase]
```

---

*Diretor Eduardo · 2026-05-27*
*Dar ao Músculo após STATUS VERDE da ORDEM_MUSCULO_FECHAMENTO_LACUNAS.md*
*Resposta do Músculo → colar aqui no Embaixador para análise final*