---
cliente: "[nome do cliente ou projeto]"
versao: "V1"
data: "YYYY-MM-DD"
principios_ativos: 0
sessoes: 0
---

# INTELLIGENCE LEDGER — [NOME DO PROJETO]
**Organismo:** Memória Viva do Pentalateral IAH para este projeto
**Ciclo:** por sessão — atualizar via `scripts/session_close.ps1` ao fechar cada sessão

> Este documento acumula a inteligência operacional do projeto. Cada princípio aqui
> representa uma decisão que custou tempo ou dinheiro para aprender. Não repita o erro.

---

## PRINCÍPIOS ATIVOS

> Registre aqui toda regra que emergiu de uma fricção real — não de teoria.
> Formato: **P-00X — [nome curto]:** [regra em 1 frase] | Origem: [sessão/evento]

*(nenhum ainda — o organismo começa vazio e cresce com cada sessão)*

---

## PADRÕES CONFIRMADOS

> O que funcionou e deve ser repetido neste projeto.

*(nenhum ainda)*

---

## PADRÕES REFUTADOS

> O que foi tentado e falhou — com o motivo documentado.

*(nenhum ainda)*

---

## CONSTITUIÇÃO DE PROCESSO

> Regras inegociáveis deste projeto específico.
> Hard Vetos (HV) = processo para imediatamente.
> Soft Vetos (SV) = sinal de alerta, 1 sessão de cooling antes de avançar.

### Hard Vetos — [PROJETO]

| ID | Regra | Origem |
|---|---|---|
| HV-P1 | [definir na Fase 0 com o cliente] | [sessão] |

### Soft Vetos — [PROJETO]

| ID | Sinal | Ação |
|---|---|---|
| SV-P1 | [definir conforme o projeto evolui] | [cooling de 1 sessão] |

---

## SHADOW ARCHITECT — Checklist obrigatório antes de cada build

Antes de escrever qualquer linha de código, responder:

```
[ ] Eduardo entenderia este bloco em menos de 10 minutos?
[ ] Esta feature resolve um problema real do cliente AGORA (não hipotético)?
[ ] Existe algo mais simples que resolve o mesmo problema?
[ ] Este build gera dívida técnica que vai custar >2x o tempo amanhã?
[ ] GUT desta feature vs GUT da próxima alternativa — qual vence?
```

Se qualquer resposta for "não" ou "talvez" → emitir Soft Veto antes de prosseguir.

---

## LOG DE SESSÕES

> Preenchido automaticamente pelo `session_close.ps1` ao fechar cada sessão.
> Formato: `[FRICÇÃO]`, `[PRINCÍPIO]`, `[OVERRIDE]`, `[DERIVA]`

### [SESSÃO YYYY-MM-DD — Kickoff]

`[PRINCÍPIO]` Primeira sessão do projeto — LEDGER inicializado.

---

## GLOSSÁRIO DO PROJETO

> Termos técnicos ou de negócio específicos deste cliente que o Quadrilateral deve conhecer.

| Termo | Significado no contexto deste cliente |
|---|---|
| [termo] | [definição] |
