# WATCHDOG — TEMPLATE DE ABERTURA DE SESSÃO
> Cole este bloco no início de cada sessão do Embaixador no Claude Project.
> Substitua os campos entre colchetes com o estado atual.
> Tempo de preenchimento: 60 segundos.

---

## COMO USAR

1. Abra o Claude Project da Ingrid
2. Cole o bloco WATCHDOG abaixo — preenchido
3. O Embaixador processa e entrega o alerta antes de qualquer pergunta
4. Depois do Watchdog: faça o que precisar

---

## BLOCO WATCHDOG — COPIAR E COLAR

```
WATCHDOG — [data de hoje]

ESTADO_ATUAL:
- Termo: [PENDENTE / ASSINADO em DD/MM]
- Gate: [Dia X / o que está em build agora]
- Último contato Ingrid: [há X dias / hoje — o que aconteceu em 1 linha]
- Risco: [VERDE / AMARELO / VERMELHO]

DESDE A ÚLTIMA SESSÃO:
[O que aconteceu com Ingrid, com o build, ou com o projeto desde que fechou o Project.
Pode ser uma linha. Pode ser bruto — o Embaixador processa.]

PERGUNTA DESTA SESSÃO:
[O que Eduardo quer resolver agora — uma frase.]
```

---

## EXEMPLO PREENCHIDO — Gate Dia 8

```
WATCHDOG — 2026-05-20

ESTADO_ATUAL:
- Termo: ASSINADO em 19/05
- Gate: Dia 8 — interface PWA pronta, Tutor Socrático em teste
- Último contato Ingrid: ontem — confirmou que assinou o Termo, perguntou quando recebe o link
- Risco: VERDE

DESDE A ÚLTIMA SESSÃO:
Ingrid assinou. Eduardo não entregou o link ainda — esperando Gate Dia 8 aprovado.
Build do Tutor Socrático com cache funcionando. Fallback de fadiga em teste.

PERGUNTA DESTA SESSÃO:
Como preparar Ingrid para a primeira sessão real sem criar expectativa errada?
```

---

## O QUE O EMBAIXADOR ENTREGA APÓS O WATCHDOG

Quatro linhas. Sempre. Antes de qualquer resposta à pergunta da sessão:

```
WATCHDOG PROCESSADO — [data]

ALERTA ATIVO: [o que precisa de atenção imediata — ou "nenhum"]
RISCO MAIOR: [o que pode quebrar o projeto se não for resolvido hoje]
HIPÓTESE A CONFIRMAR: [o que Eduardo verifica no próximo contato com Ingrid]
AÇÃO ÚNICA: [o que Eduardo faz agora — uma frase]
```

Depois: responde à pergunta da sessão normalmente.

---

## REGRAS DO WATCHDOG

```
SEMPRE processar antes de qualquer resposta — sem exceção
NUNCA pular o Watchdog porque "é urgente" — urgência é exatamente quando mais importa
SEMPRE atualizar MEMORIA_EMBAIXADOR.md ao fechar a sessão
SEMPRE subir LOG_CLIENTE no NotebookLM a cada gate fechado
```

---

## GATILHOS QUE MUDAM O NÍVEL DE RISCO

| Evento | Nível |
|---|---|
| Termo assinado + Gate no prazo + contato recente | VERDE |
| Termo pendente OU sem contato há 2+ dias | AMARELO |
| Termo pendente + sem contato há 3+ dias | VERMELHO |
| Ingrid mencionou compartilhar login | VERMELHO |
| Ingrid não usou o app por 3+ dias após entrega | VERMELHO |
| Ingrid respondeu em monossílabos por 2 interações | AMARELO → monitorar |

---

## PROTOCOLO DE FECHAMENTO DE SESSÃO

Antes de fechar o Project, Eduardo executa em 2 minutos:

```
[ ] Copiar LOG_CLIENTE gerado nesta sessão
[ ] Subir como fonte nova no NotebookLM
[ ] Atualizar MEMORIA_EMBAIXADOR.md (campos que mudaram)
[ ] Atualizar ESTADO_ATUAL no artefato de Captura Rápida
[ ] Fechar o Project
```

Cinco itens. Se algum não for feito — registrar qual e por quê.
O Embaixador não julga. Mas precisa saber o que foi omitido para compensar na próxima sessão.

---

*Criado por: Embaixador · 2026-05-18*
*Atualizar quando: o processo de abertura de sessão mudar ou um novo membro entrar no Conselho*
