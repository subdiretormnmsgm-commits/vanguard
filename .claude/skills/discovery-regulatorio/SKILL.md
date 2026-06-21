---
name: discovery-regulatorio
description: Use ao abrir qualquer nicho regulatório, de compliance ou com gatilho normativo. Extrai o gatilho regulatório e o prazo/norma DA FONTE (nunca de memória), executa o discovery semântico do vocabulário do alvo (anti-homogeneidade P-043) e monta a "dor já acontecida" com número verificado. Dispare em todo nicho com componente legal, normativo ou de prazo — mesmo que o Diretor não mencione "discovery" ou "regulatório" explicitamente. Acione também quando o Embaixador reportar nova dor de mercado.
---

# Discovery Regulatório + Gate de Fato

## Contexto
Dois erros matam projetos regulatórios antes de começar: (1) usar prazo ou norma de memória — que pode estar desatualizada — e (2) migrar linguagem entre nichos sem discovery semântico, produzindo argumentos que soam estranhos ao alvo (P-043). Esta skill bloqueia os dois.

## Procedimento

### Passo 1 — Identificar o gatilho regulatório
Mapear o componente normativo do nicho:
- Qual norma/lei/instrução normativa está em jogo?
- Qual é o prazo ou evento que cria urgência?
- Quem é o órgão regulador (Receita, CVM, ANATEL, CFM, TCU, ANEEL etc.)?
- Qual é a consequência concreta do não-cumprimento (multa, embargo, CND, autuação)?

### Passo 2 — GATE DE FATO (inviolável)
Todo prazo, número, norma e consequência vem de **fonte ou disco** — nunca de memória.

Protocolo:
1. Buscar a fonte primária (site do órgão, DOU, IN publicada, deliberação TCU etc.)
2. Confirmar: número da norma + data de publicação + prazo vigente
3. Sem confirmação → marcar **[NÃO CONFIRMADO]** e bloquear qualquer output que dependa desse dado

```
GATE DE FATO — checklist obrigatório:
[ ] Norma identificada com número e data
[ ] Prazo confirmado em fonte primária (não de memória)
[ ] Consequência do não-cumprimento verificada
[ ] Fonte citada: [URL ou publicação + data de acesso]
```

Dado crítico sem fonte = **[NÃO CONFIRMADO]**. Output dependente bloqueado até verificação.

### Passo 3 — Discovery semântico (anti-P-043)
Mapear o vocabulário NATIVO do alvo naquele nicho específico. Sem este passo, o argumento soa genérico ou transplantado de outro nicho.

Perguntas obrigatórias:
- Como o alvo **chama** o problema que tem? (não como a Vanguard chama)
- Que termos técnicos usa no dia a dia? (ECD, SPED, NCM, leiaute, DRE, DCP...)
- Qual é a **cena de sucesso** do cliente — o momento concreto em que ele sabe que o problema foi resolvido?
- Que linguagem o concorrente genérico usa que o alvo já rejeita?

Corpus mínimo a consultar:
- Fóruns/grupos do setor (OAB, CFC, ANEFAC, IBEF, sindicatos setoriais)
- Linguagem das próprias normas (como o órgão regulador nomeia o problema)
- Outputs F1/F3/F18 do Embaixador para aquele nicho (se existirem)

### Passo 4 — Montar a "dor já acontecida"
Com o gatilho verificado + vocabulário nativo, construir o argumento de abertura no formato:

> *"[Número concreto] de [perfil do alvo] já [consequência real] por conta de [norma verificada] — e o prazo para [ação] é [data confirmada]."*

Este é o insumo direto da §1 do Plano e da §8 (Abordagem Blindada).

**A dor precisa ser:**
- Já acontecida (não hipotética)
- Com número verificado (Gate de Fato)
- No vocabulário do alvo (anti-P-043)
- Datada e rastreável à fonte

## Output esperado
```
DISCOVERY REGULATÓRIO — [Nicho]

GATILHO:
- Norma: [número + data]
- Prazo: [data confirmada] — Fonte: [URL/publicação]
- Órgão: [regulador]
- Consequência: [multa/embargo/autuação — valor se disponível]
- Status Gate de Fato: ✅ confirmado / ⚠️ [campo] NÃO CONFIRMADO

VOCABULÁRIO DO ALVO:
- Como chama o problema: [termo nativo]
- Termos técnicos recorrentes: [lista]
- Cena de sucesso: [momento concreto]
- O que rejeita: [linguagem genérica a evitar]

DOR JÁ ACONTECIDA:
"[argumento com número + norma + prazo — no vocabulário do alvo]"
```

## Gate
- Número/prazo/lei sem fonte = **[NÃO CONFIRMADO]** → output dependente bloqueado
- Sem discovery semântico → sem migração de argumento entre nichos (P-043)
- Dor hipotética (futura) não serve — precisa ser já acontecida

## Âncoras
Gate de Fato · P-043 · §1 (Inteligência de mercado) · §2 (Discovery)
Alimenta: `viabilidade-roi` (§3), `abordagem-blindada` (§8)