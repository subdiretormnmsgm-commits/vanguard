# COMANDO AO MÚSCULO — VERIFICAÇÃO DE CONSISTÊNCIA SISTÊMICA
> Emitido por: Diretor Eduardo
> Data: 2026-05-27
> Responder neste chat. O Embaixador analisará a resposta.

---

## CONTEXTO

Nesta sessão foram implementadas mudanças significativas no processo.
A pergunta não é se você sabe o que foi feito hoje.
A pergunta é: **amanhã, na próxima sessão, com um projeto novo — o sistema funciona sozinho?**

Para cada cenário abaixo, descreva exatamente o que acontece —
o que é automático, o que depende de você lembrar, e o que depende do Diretor.

---

## CENÁRIO 1 — Eduardo abre o Claude Code amanhã de manhã

Descreva o que acontece do momento em que Eduardo digita o primeiro comando
até o momento em que ele vê a AGENDA DO DIA.

Perguntas guia:
- O LEMBRETE DE LOOP aparece? Como?
- O sistema detecta se há DECISOES.json pendente? Como?
- O Músculo sabe em que etapa cada projeto está? De onde vem essa informação?
- O que bloqueia se algo estiver errado?

---

## CENÁRIO 2 — Eduardo vai ao Gemini com o PASSO 3

Descreva o que Eduardo faz do zero até colar no Gemini.

Perguntas guia:
- Qual script roda? O que ele produz?
- O que vai para o clipboard automaticamente?
- O que Eduardo ainda faz com a mão? É evitável?
- O gate P-045 é verificado? Quando? O que acontece se falhar?

---

## CENÁRIO 3 — NotebookLM entrega a Skill

Descreva o caminho da Skill desde o NotebookLM até estar instalada e pronta.

Perguntas guia:
- O que Eduardo faz manualmente?
- O que o watcher faz automaticamente?
- O que o skill_parser_gate.ps1 verifica?
- O que acontece se a Skill for rejeitada?
- O Diretor recebe confirmação? Como?

---

## CENÁRIO 4 — O Embaixador entrega os [E-1 a E-5]

Descreva o que acontece entre o Embaixador entregar e o Diretor ver o Painel.

Perguntas guia:
- O Músculo faz alguma coisa antes do Painel abrir? O quê? (P-037/P-068)
- O Painel abre sozinho? Como?
- O que acontece se o Músculo pular a etapa ⑤?
- Onde o output da síntese é salvo? Por quê?

---

## CENÁRIO 5 — Eduardo encerra a sessão

Descreva os últimos 10 minutos de qualquer sessão.

Perguntas guia:
- O que o session_close.ps1 faz nos 9 gates — em ordem?
- Quais gates bloqueiam com exit 1 se falharem?
- O e-mail vai para qual endereço? O Telegram dispara em paralelo?
- O que Eduardo precisa fazer manualmente após o script terminar?
- O loop_fase_atual é atualizado? Quando — no close ou durante a sessão?

---

## CENÁRIO 6 — Um documento universal é atualizado

O Músculo atualiza o INTELLIGENCE_LEDGER.md com um princípio novo e faz commit.

Perguntas guia:
- O que o post-commit hook faz automaticamente?
- O decision_impact.ps1 é chamado? O que ele calcula?
- INGRID e VALDECE recebem a atualização? Como é confirmado?
- O que acontece se o Músculo editou a cópia do projeto em vez da fonte canônica?

---

## CENÁRIO 7 — Ingrid fica 6 dias sem usar o app

Descreva o que acontece sem o Diretor precisar fazer nada.

Perguntas guia:
- Quem detecta o silêncio? Quando?
- O alerta chega como? Para onde?
- O Embaixador precisa ser ativado para isso acontecer?
- Qual é o threshold configurado? Onde está definido?

---

## CENÁRIO 8 — Começa um projeto novo (terceiro cliente)

Do zero até o primeiro loop rodando.

Perguntas guia:
- Quais são os passos de kickoff? São do loop ou separados?
- O Embaixador é ativado quando?
- Quando o projeto entra no loop iterativo?
- O ROTEIRO_LOOP_UNIVERSAL.md se aplica desde o primeiro loop?

---

## FORMATO DA RESPOSTA

Para cada cenário: resposta em prosa direta.
Se algo depende de disciplina humana (sua ou do Diretor): declarar explicitamente.
Se não souber: declarar. Não inventar.

Ao final:

```
AUTODIAGNÓSTICO:
Cenários onde o sistema funciona sozinho: [listar]
Cenários onde ainda depende de minha disciplina: [listar]
Cenários onde ainda depende do Diretor lembrar: [listar]
Maior risco sistêmico que identifico: [uma frase]
```

---

## O QUE ACONTECE DEPOIS

Cole a resposta do Músculo no chat do Embaixador (Claude Projects).
O Embaixador analisa cenário a cenário e entrega ao Diretor:

```
ANÁLISE DE CONSISTÊNCIA SISTÊMICA — MÚSCULO
Data: [data]

Para cada cenário:
  STATUS: SISTÊMICO / DEPENDE DE DISCIPLINA / LACUNA
  Observação: [o que está correto, o que está faltando, o risco real]

VEREDITO:
VERDE  — sistema funciona sozinho na próxima sessão
AMARELO — funciona com supervisão nos pontos identificados
VERMELHO — há lacunas que farão o processo falhar amanhã

RISCO PRINCIPAL IDENTIFICADO: [uma frase]
AÇÃO RECOMENDADA AO DIRETOR: [uma frase]
```

---

*Diretor Eduardo · 2026-05-27*
*Colar no Claude Code — aguardar resposta — colar resposta no Embaixador*