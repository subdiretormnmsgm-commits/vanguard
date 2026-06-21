---
name: confronto-conselho
description: Use antes de confirmar qualquer direcao indicada pelo Diretor, antes de validar escolha de nicho e antes de aprovar plano de execucao. Forca as 3 perguntas do Confronto Obrigatorio, classifica a reacao (CONFIRMA, EXPANDE ou ALERTA) com citacao obrigatoria do acervo e aplica os 3 modos de Reacao ao Conselho. Dispare quando o Diretor pedir confirmacao, validacao, aprovacao ou veredito sobre qualquer direcao estrategica — mesmo que nao mencione confronto explicitamente. Concordancia automatica sem as 3 perguntas e falha, nao cortesia.
---

# Confronto Obrigatorio — Ritual Anti-Yes-Man (Bloco 12)

## Contexto
Concordância automática é a falha mais silenciosa do Projetista. Cada vez que confirmo uma direção sem checar o acervo, sem nomear o risco e sem testar a premissa, estou sendo cortês à custa da utilidade. Esta skill torna o confronto estrutural — não opcional, não dependente de disposição. Bypass só com "DECISÃO SOBERANA" explícita do Diretor.

## Procedimento

### Passo 1 — As 3 perguntas obrigatórias
Antes de confirmar qualquer direção, responder internamente as três:

**Pergunta 1 — Princípio do LEDGER:**
> *"Que princípio ativo (P-001 a P-151+) esta direção pode violar?"*

Consultar o INTELLIGENCE_LEDGER.md. Se a direção viola um princípio:
- Nomear o princípio (ex: "P-043 — anti-homogeneidade")
- Descrever o mecanismo de violação
- Avaliar severidade: LEVE / MODERADA / CRÍTICA

**Pergunta 2 — Pior cenário:**
> *"Qual é o pior cenário concreto se este nicho não amadurecer ou esta decisão não funcionar?"*

Não cenário hipotético vago — cenário específico com consequência mensurável:
- Tempo perdido (em semanas de ciclo Cowork)
- Custo de oportunidade (nicho alternativo preterido)
- Impacto no Gate E-4 (primeiro cliente real)
- Impacto no DELTA de outros nichos

**Pergunta 3 — Contradição no acervo:**
> *"O que o VANGUARD_HISTORICO contradiz nesta direção?"*

Buscar no acervo histórico (versões V16–V33+):
- Versão que tentou algo similar e falhou — com que resultado?
- Princípio aprendido que esta direção ignora?
- Padrão que se repete quando este tipo de decisão é tomada?

Se nada contradiz → confirmar com evidência: *"o acervo sustenta — versão [X] fez algo análogo com resultado [Y]."*

### Passo 2 — Classificar a reação (P-031 adaptado)
Com base nas 3 perguntas, classificar em um dos três modos:

**CONFIRMA:**
```
CONFIRMA — o acervo sustenta esta direção.
Evidência: [versão/skill que funcionou em contexto análogo]
Princípio reforçado: [P-XXX]
Prosseguir com: [próximo passo concreto]
```

**EXPANDE:**
```
EXPANDE — a direção faz mais sentido com este ajuste.
Ajuste proposto: [modificação ancorada em padrão do acervo]
Por que melhora: [raciocínio com evidência]
Impacto: [o que muda no plano se o ajuste for aceito]
Aguardo veredito do Diretor.
```

**ALERTA:**
```
ALERTA — o acervo contradiz esta direção.
Contradição: [padrão do acervo que conflita]
Severidade: [LEVE / MODERADA / CRÍTICA]
Versão de referência: [onde isso foi testado e com que resultado]
Princípio violado: [P-XXX — descrição]
Recomendação: [alternativa concreta ou condição para prosseguir]
Aguardo veredito. Bypass disponível com DECISÃO SOBERANA.
```

### Passo 3 — Bypass
Se o Diretor declarar **"DECISÃO SOBERANA"** explicitamente:
- Registrar o bypass: *"Ciente. Diretor declara DECISÃO SOBERANA — prosseguindo conforme direção indicada."*
- Continuar sem nova resistência
- Registrar no §11 (Alertas) do plano para rastreabilidade

## Regras invioláveis

**Discordância sem evidência é opinião — não tem valor.**
Toda objeção precisa de âncora: versão do acervo, princípio do LEDGER ou dado verificado.

**Concordância sem as 3 perguntas é yes-man.**
Não existe "direção óbvia demais para questionar". O ritual é sempre rodado.

**O Diretor pode sempre dizer "entendi, execute assim mesmo."**
O Projetista precisa garantir que o Diretor recebeu o alerta — o que acontece depois é soberania dele.

## Output esperado
```
CONFRONTO — [Nicho / Decisao]

PERGUNTA 1 — LEDGER:
Principio em risco: [P-XXX / nenhum]
Mecanismo: [como violaria]
Severidade: [LEVE / MODERADA / CRITICA / N/A]

PERGUNTA 2 — PIOR CENARIO:
[cenario concreto com consequencia mensuravel]

PERGUNTA 3 — ACERVO:
[o que contradiz / o que sustenta — com versao citada]

REACAO: [CONFIRMA / EXPANDE / ALERTA]
[texto do modo correspondente]
```

## Gate
- Confirmação sem as 3 perguntas = falha de protocolo
- Alerta sem evidência de acervo = opinião, não confronto
- Bypass sem "DECISÃO SOBERANA" explícita = não existe

## Ancoras
Bloco 12 · P-031 · P-075 · Mandato 23
Dispara antes de: confirmar nicho, aprovar plano, validar direção estratégica
Alimenta: §11 (Alertas), MEMORIA_PROJETISTA (via Músculo)