---
name: pre-mortem-risco
description: Use SEMPRE no início de toda projeção de nicho, ANTES da SWOT e antes de qualquer planejamento. Escreve a certidão de óbito do projeto, isola o único fator-morte mais provável e o converte em restrição de arquitetura obrigatória para a EAP. Risco vira tijolo, não relatório. Dispare automaticamente quando o Diretor pedir projeção, plano de execução, análise de nicho ou viabilidade — mesmo que não mencione "risco" ou "pré-mortem" explicitamente.
---

# Pré-Mortem como Input (L34-A1)

## Contexto
A análise de risco tradicional produz listas que ninguém lê. O pré-mortem inverte: parte do fracasso já ocorrido e trabalha para trás. O resultado não é um checklist — é uma **restrição de arquitetura** que entra na EAP como pacote obrigatório. Antecipa para o nascimento do projeto o que o Cowork (F7) só detectaria tarde.

## Procedimento

### Passo 1 — Escrever a certidão de óbito
Completar a frase no contexto do nicho em análise:

> *"Este projeto morre se ______."*

Gerar 3 candidatos plausíveis, ancorados em:
- Histórico do VANGUARD_HISTORICO (o que matou projetos similares em versões anteriores?)
- Gatilho regulatório do nicho (o que pode mudar e invalidar a dor?)
- Gate E-4 / pipeline real (o que acontece se não houver cliente para validar?)

### Passo 2 — Isolar o fator-morte único
Dos 3 candidatos, selecionar **o único X mais provável** — o que mata mais rápido e é menos controlável pela Vanguard. Não é a lista — é o fator singular.

Critério de seleção:
- **Probabilidade** — qual é mais provável dado o DELTA atual?
- **Velocidade** — qual mata mais rápido (antes de qualquer receita)?
- **Controlabilidade** — qual está menos na mão da Vanguard neutralizar?

O X de maior produto (probabilidade × velocidade × baixa controlabilidade) é o fator-morte.

### Passo 3 — Converter em restrição de arquitetura
Transformar X em uma condição que o design do projeto PRECISA satisfazer:

> *"RESTRIÇÃO DE ARQUITETURA: o plano só é viável se [condição que neutraliza X]."*

Exemplos:
- X = "cliente não percebe urgência" → Restrição: "o produto precisa ter ROI calculável em ≤30 dias"
- X = "prazo regulatório muda antes da entrega" → Restrição: "entrega mínima viável em ≤2 semanas"
- X = "nicho sem entrada pela rede atual" → Restrição: "primeiro contato via referência, não cold"

### Passo 4 — Emitir requisito para a EAP
Declarar formalmente o pacote obrigatório que a FASE 2 deve incluir:

> *"REQUISITO EAP: um pacote de trabalho na §5 existe especificamente para neutralizar [X]. Sem ele, o plano não é aprovado."*

## Output esperado
```
PRÉ-MORTEM — [Nicho]

Candidatos de morte:
1. [candidato A]
2. [candidato B]
3. [candidato C]

FATOR-MORTE ÚNICO: [X]
Justificativa: [probabilidade × velocidade × baixa controlabilidade]

RESTRIÇÃO DE ARQUITETURA: [condição que o design precisa satisfazer]

REQUISITO EAP: pacote anti-[X] obrigatório na §5
```

## Gate
**A projeção não avança para a SWOT sem o output acima declarado.**
Risco vira tijolo (pacote na EAP) — nunca relatório (seção de alertas ignorada).

## Cláusula de auto-obsolescência (L34-A4)
Ao final do pré-mortem, registrar também:

> *"Este design expira se [condição de mercado/regulatória que invalida a restrição de arquitetura]."*

Esta condição é repassada ao Detector de Deriva para monitoramento contínuo.

## Âncoras
L34-A1 · L34-A4 · Bloco 4 (Iniciação) · Bloco 9 §3 · §11 (Alertas)
Precede: SWOT, viabilidade, EAP
Alimenta: `viabilidade-roi` (§3), `eap-raci` (§5), `confronto-conselho` (§11)