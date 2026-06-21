---
name: eap-raci
description: Use no planejamento de todo plano de execução, após viabilidade-roi aprovada. Decompõe a entrega em 4 a 6 pacotes de trabalho, marca a origem de cada pacote no acervo histórico (Reutilizar, Adaptar, Combinar ou Construir), atribui RACI por pacote (Diretor/Antigravity/Embaixador Digital/Músculo) e verifica obrigatoriamente que um pacote neutraliza o fator-morte do pré-mortem. Dispare quando o Diretor pedir plano, EAP, estrutura de entrega, cronograma ou qualquer decomposição de entrega para um nicho aprovado.
---

# EAP + RACI — Estrutura Analítica do Projeto

## Contexto
A EAP transforma o "o que entregar" em pacotes gerenciáveis com responsável claro. O eixo de aproveitamento (Reutilizar > Adaptar > Combinar > Construir) garante que a Vanguard não reinventa o que já existe — e cita a versão do acervo que sustenta cada pacote. O pacote anti-fator-morte não é opcional: se não existe, o plano não é aprovado.

## Procedimento

### Passo 1 — Definir o produto entregável
Antes de decompor, declarar o produto com precisão:
- O que o cliente recebe ao final? (relatório, dashboard, framework, diagnóstico, solução implementada?)
- Qual o ticket e condições comerciais?
- Qual o critério de aceite — como o cliente sabe que recebeu valor?

### Passo 2 — Decompor em 4–6 pacotes de trabalho
Cada pacote é uma entrega intermediária verificável — não uma tarefa, não uma fase genérica.

Para cada pacote, preencher:

```
PACOTE [N] — [nome do pacote]
Entrega: [o que está pronto ao fim deste pacote]
Origem no acervo (Eixo 1):
  [ ] REUTILIZAR — skill/versão [X] do VANGUARD_HISTORICO, sem alteração
  [ ] ADAPTAR    — skill/versão [X], com ajuste em [componente específico]
  [ ] COMBINAR   — skills [X] + [Y], integradas por [lógica]
  [ ] CONSTRUIR  — não existe no acervo; build novo necessário
Responsável (RACI):
  R (Responsável pela execução): [Músculo / Antigravity / Embaixador Digital]
  A (Accountable — aprova): [Diretor]
  C (Consultado): [quem contribui]
  I (Informado): [quem é notificado]
Prazo estimado: [N dias/semanas]
Critério de conclusão: [verificável]
```

### Passo 3 — Verificação anti-fator-morte (obrigatória)
Cruzar com o output do `pre-mortem-risco`:

```
VERIFICAÇÃO ANTI-FATOR-MORTE:
Fator-morte identificado: [X do pré-mortem]
Restrição de arquitetura: [condição que o design precisa satisfazer]

Existe pacote dedicado a neutralizar X? [SIM / NÃO]
→ SIM: Pacote [N] — [nome] — como neutraliza: [mecanismo]
→ NÃO: BLOQUEADO. Adicionar pacote obrigatório antes de prosseguir.
```

**Gate:** plano sem pacote anti-fator-morte = plano não aprovado.

### Passo 4 — Cronograma lógico
Ordenar os pacotes por dependência (não por data):

```
Sequência lógica:
[P1] → [P2] → [P3]
         ↘ [P4] (paralelo com P3)
[P5] (depende de P3 + P4) → [P6 — entrega final]
```

### Passo 5 — Verificação de aproveitamento
Auditar o conjunto de pacotes:

```
AUDITORIA DE APROVEITAMENTO:
REUTILIZAR: [N] pacotes — [%] do esforço total
ADAPTAR:    [N] pacotes
COMBINAR:   [N] pacotes
CONSTRUIR:  [N] pacotes — [%] do esforço total (quanto mais baixo, melhor)

Alerta se CONSTRUIR > 40% do esforço: consultar VANGUARD_HISTORICO antes de confirmar.
```

## Output esperado
```
EAP + RACI — [Nicho] — v[N]

PRODUTO DEFINIDO:
Entregável: [descrição]
Ticket: R$ [valor]
Critério de aceite: [verificável]

PACOTES DE TRABALHO:
[tabela com P1–P6, origem, RACI, prazo, critério]

VERIFICAÇÃO ANTI-FATOR-MORTE: ✅ Pacote [N] neutraliza [X]

CRONOGRAMA LÓGICO: [sequência de dependências]

AUDITORIA DE APROVEITAMENTO:
Reutilizar [N] · Adaptar [N] · Combinar [N] · Construir [N]
```

## Gates
- Menos de 4 ou mais de 6 pacotes → revisar granularidade
- Pacote sem origem declarada no acervo → bloqueado
- Pacote CONSTRUIR sem consulta ao VANGUARD_HISTORICO → bloqueado
- Sem pacote anti-fator-morte → plano não aprovado
- RACI sem Accountable (Diretor) em cada pacote → corrigir

## Âncoras
Eixo 1 (Reutilizar > Adaptar > Combinar > Construir) · L34-A1 · §5 · §6
Depende de: `pre-mortem-risco`, `viabilidade-roi`
Alimenta: `abordagem-blindada` (§8), marcos de controle (§7)