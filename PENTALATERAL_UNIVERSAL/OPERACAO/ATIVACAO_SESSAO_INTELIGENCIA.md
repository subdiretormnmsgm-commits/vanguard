# ATIVACAO_SESSAO_INTELIGENCIA.md
# Sessao de Inteligencia Vanguard -- protocolo de ativacao do Embaixador
# P-101 + Mandato 20 (Embaixador V4.0)
# Criado: 2026-06-04 | Musculo -- Pentalateral IAH

---

## O QUE E A SESSAO DE INTELIGENCIA VANGUARD

Uma consulta estruturada ao Embaixador para extrair inteligencia de nicho, comportamento de cliente
ou posicionamento da Vanguard -- FORA do ciclo de loop normal.

Diferenca do loop padrao:
- Loop padrao: Embaixador reage a ideias do Gemini + NotebookLM + Musculo (Secao D)
- Sessao de Inteligencia: Embaixador opera livremente sobre um tema declarado pelo Musculo

Resultado esperado: 3 a 5 insights nao-obvios que nao emergiriam no ciclo normal.

---

## 3 MODOS DE ATIVACAO

### MODO 1 -- MANUAL (Diretor vai ao Claude Projects)

1. Diretor abre o Claude Projects do cliente ativo
2. Diretora cole o bloco ATIVACAO abaixo no chat
3. Embaixador responde
4. Diretor cola a resposta no Claude Code: "Musculo, receba a Sessao de Inteligencia"
5. Musculo processa, valida e inscreve os principios aprovados

Quando usar: analise profunda que precisa de contexto acumulado de cliente especifico.

### MODO 2 -- n8n AUTOMATICO (pos-FASE 1)

O n8n envia o payload abaixo ao Claude Projects via API.
O payload DEVE incluir o bloco de ativacao -- sem ele, o Embaixador responde como chat geral.

Payload obrigatorio:
```json
{
  "role": "user",
  "content": "[SESSAO_INTELIGENCIA_VANGUARD]\nTema: {TEMA}\nCliente_referencia: {CLIENTE}\nPergunta_central: {PERGUNTA}\nEntregavel: 3 insights nao-obvios em formato [I-1] [I-2] [I-3]"
}
```

Quando usar: sessoes semanais de monitoramento -- n8n dispara automaticamente.
Gate: so ativar apos n8n estavel por 30 dias (pos-FASE 1).

### MODO 3 -- EMERGENCIA (Diretor detecta risco)

Diretor detecta sinal de churn ou oportunidade urgente e ativa manualmente.
Diferenca do Modo 1: Diretor descreve o evento especifico no bloco ATIVACAO.
Musculo processa na mesma sessao -- zero delay.

---

## BLOCO DE ATIVACAO (colar no Embaixador)

```
[SESSAO_INTELIGENCIA_VANGUARD]
Data: {DATA_HOJE}
Cliente_referencia: {NOME_CLIENTE}
Tema: {TEMA_DA_SESSAO}
Pergunta_central: {PERGUNTA_ESPECIFICA}

Contexto desta sessao:
{CONTEXTO_DE_2_A_3_LINHAS}

Entregavel:
- [I-1] a [I-3]: insights nao-obvios que nao emergiriam em uma Secao D padrao
- Cada insight: 2-3 linhas com evidencia ou inferencia declarada
- Se nao tiver evidencia: dizer "inferencia baseada em [fonte]"
```

---

## PROTOCOLO DE APROVACAO DE PRINCIPIOS (M-21)

Quando o Embaixador propoe um principio novo em qualquer Sessao de Inteligencia:

**PASSO 1 -- Embaixador propoe**
Formato esperado na resposta: "PRINCIPIO CANDIDATO: [texto] | EVIDENCIA: [fonte]"

**PASSO 2 -- Musculo valida (analise cirurgica)**
O Musculo verifica:
- O principio e tecnicamente correto?
- Ja existe no LEDGER (busca por keywords)?
- E generalizavel para outros projetos ou e especifico de um cliente?
- Ha contra-exemplos que refutam?

Saida: CONFIRMADO | AJUSTE NECESSARIO | REFUTADO (com razao tecnica)

**PASSO 3 -- Diretor aprova**
Musculo apresenta: principio + analise cirurgica + recomendacao (INSCRITO / DESCARTADO / V2)
Diretor responde com veredito binario.

**PASSO 4 -- Musculo inscreve**
Apos veredito INSCRITO: Musculo adiciona ao LEDGER com tag [VALIDA: EMBAIXADOR | MUSCULO | DATA].
Numero sequencial: proximo P-NNN disponivel.

---

## TEMAS RECORRENTES PARA SESSAO SEMANAL (n8n FASE 1)

| Semana | Tema | Pergunta central |
|--------|------|-----------------|
| 1 | Churn early warning | Quais sinais de Ingrid ou Valdece, vistos agora, indicariam risco de abandono silencioso? |
| 2 | Expansao de nicho | Qual perfil de cliente e o mais proximo de Ingrid em comportamento -- e o mais diferente? |
| 3 | Diferencial comercial | O que a Vanguard faz hoje que uma agencia tradicional nao consegue replicar em 6 meses? |
| 4 | Risco sistemico | Se o EasyPanel cair por 48h, qual cliente perde mais confianca -- e por que? |

---

## REGISTRO DE SESSOES REALIZADAS

| Data | Modo | Cliente ref | Tema | Insights | Status |
|------|------|-------------|------|----------|--------|
| (primeira sessao pendente) | | | | | |

---

*Musculo -- Pentalateral IAH -- 2026-06-04*
*Localizado em: PENTALATERAL_UNIVERSAL/OPERACAO/ATIVACAO_SESSAO_INTELIGENCIA.md*
*Tipo: TIPO 1 UNIVERSAL_PURO*
