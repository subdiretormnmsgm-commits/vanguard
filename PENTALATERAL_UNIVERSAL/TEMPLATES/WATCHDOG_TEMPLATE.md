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
- Último contato [CLIENTE]: [há X dias / hoje — o que aconteceu em 1 linha]
- TEMPERATURA_PONDERADA: [score 0-10 — ex: "7/10 → estável"]

DESDE A ÚLTIMA SESSÃO:
[O que aconteceu com o cliente, com o build, ou com o projeto desde que fechou o Project.
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

Seis linhas. Sempre. Antes de qualquer resposta à pergunta da sessão:

```
WATCHDOG PROCESSADO — [data]

TEMPERATURA_PONDERADA: [score 0-10] | Tendência: [↑ subindo / → estável / ↓ caindo]
  Razão: [evidência concreta de comportamento real — não impressão]
  [CHURN-WATCH ativado automaticamente se score < 6]
ALERTA ATIVO: [o que precisa de atenção imediata — ou "nenhum"]
RISCO MAIOR: [o que pode quebrar o projeto se não for resolvido hoje]
HIPÓTESE A CONFIRMAR: [o que Eduardo verifica no próximo contato com o cliente]
AÇÃO ÚNICA: [o que Eduardo faz agora — uma frase]
```

Depois: responde à pergunta da sessão normalmente e gera o **Painel de Deliberação** ao fechar.

---

## REGRAS DO WATCHDOG

```
SEMPRE processar antes de qualquer resposta — sem exceção
NUNCA pular o Watchdog porque "é urgente" — urgência é exatamente quando mais importa
SEMPRE atualizar MEMORIA_EMBAIXADOR.md ao fechar a sessão
SEMPRE subir LOG_CLIENTE no NotebookLM a cada gate fechado
```

---

## REGRA DE TEMPERATURA (TEMPERATURA_PONDERADA)

```
Score 8-10 — VERDE FORTE: relacionamento saudável, cliente engajado, sem watchdogs ativos
Score 6-7  — VERDE FRÁGIL / AMARELO: atenção crescente; monitorar silêncios e sinais mistos
Score < 6  — CHURN-WATCH automático: alerta imediato + reengajamento obrigatório

Tendência ↑: score melhorou desde último contato (bom sinal mesmo em AMARELO)
Tendência →: score estável (confirmar se é conforto ou estagnação)
Tendência ↓: score caindo — escalar ação antes de atingir < 6
```

## GATILHOS QUE MUDAM A TEMPERATURA_PONDERADA

| Evento | Impacto |
|---|---|
| Termo assinado + Gate no prazo + contato recente | +2 pontos |
| Uso proativo do produto sem solicitar | +2 pontos |
| Cliente verbalizou progresso concreto | +1 ponto |
| Termo pendente OU sem contato há 2+ dias | -1 ponto |
| Termo pendente + sem contato há 3+ dias | -2 pontos |
| Cliente mencionou compartilhar login | -3 pontos + ALERTA imediato |
| Cliente não usou o app por 3+ dias após entrega | -2 pontos |
| Cliente respondeu em monossílabos por 2 interações | -1 ponto → monitorar |
| Score cai para < 6 | CHURN-WATCH automático |

---

## PAINEL DE DELIBERAÇÃO — GERADO AO FECHAR SESSÃO

Ao fechar toda ativação significativa, o Embaixador gera o Painel de Deliberação automaticamente.
O Diretor não descreve nada — apenas delibera (escolhe veredito para cada item).

```
PAINEL DE DELIBERAÇÃO — [data]

[tipo]  [descrição da decisão pendente]
        Evidência: [o que gerou esta decisão]
        Texto pré-redigido: [rascunho editável — quando aplicável]
        Veredito: [ ] APROVAR  [ ] AJUSTAR  [ ] DESCARTAR  [ ] ADIAR

Tipos: WATCHDOG | LEGAL_WATCH | GATE_WATCH | PRINCIPIO | D3_VANGUARD | SCOPE_WATCH
```

## PROTOCOLO DE FECHAMENTO DE SESSÃO

Antes de fechar o Project, Eduardo executa em 2 minutos:

```
[ ] Copiar LOG_CLIENTE gerado nesta sessão
[ ] Subir como fonte nova no NotebookLM
[ ] Atualizar MEMORIA_EMBAIXADOR.md (campos que mudaram)
[ ] Aprovar/descartar itens do Painel de Deliberação
[ ] Fechar o Project
```

Quatro itens. Se algum não for feito — registrar qual e por quê.
O Embaixador não julga. Mas precisa saber o que foi omitido para compensar na próxima sessão.

---

*Criado por: Embaixador · 2026-05-18*
*Atualizado: 2026-05-23 — V2.0: TEMPERATURA_PONDERADA + Painel de Deliberação + 17 mandatos*
*Atualizar quando: o processo de abertura de sessão mudar ou um novo membro entrar no Conselho*
