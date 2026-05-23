# ROI TRACKER — VERIFICAÇÃO 30 DIAS PÓS-LANÇAMENTO
**PENTALATERAL IAH · Template Universal**
**Versão:** 1.0 · 2026-05-11

---

> ⚠️ **ORGANISMO VIVO — atualizar APÓS CADA VERIFICAÇÃO**
> · Resultado melhor do que estimado → corrigir estimativas futuras para cima
> · Resultado abaixo do estimado → documentar porquê e ajustar Biblioteca de Padrões
> · Cliente respondeu com dados reais → guardar como caso de estudo (sem nome)
> · Nova métrica útil descoberta → adicionar às perguntas de check

---

> **Para que serve:**
> O sistema promete ROI ao vender. O ROI Tracker verifica se aconteceu.
> Cria prova social com números reais. Calibra estimativas futuras.
> Abre portas para a próxima iteração sem precisar de "vender" — os dados vendem sozinhos.

---

## QUANDO USAR

```
Dia do lançamento → marcar lembrete para 30 dias depois
Dia 30 → enviar Mensagem 1 ao cliente
Dia 33–35 → se sem resposta, enviar Mensagem 2
Dia 37 → se ainda sem resposta → verificar pelo celular
Dia 40 → fechar o tracker com os dados disponíveis
```

---

## MENSAGEM 1 — ENVIAR AO CLIENTE (WhatsApp / Email)

Adaptar ao canal e ao tom da relação. Copiar e preencher os `[campos]`:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[CANAL: WhatsApp — versão curta]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Nome], já faz 30 dias desde que o [nome do projeto] entrou no ar.

Queria fazer 3 perguntas rápidas — levam menos de 5 minutos:

1. O [resultado que prometemos — ex: agendamentos online] está a funcionar?
   Tens algum número de referência? (não precisa de ser exato)

2. O que correu melhor do que esperavas?

3. O que ainda está a falhar ou podia melhorar?

Pergunto porque quero perceber o impacto real — e porque os dados que me deres
ajudam-me a afinar o que construo para os próximos clientes.

Obrigado!
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[CANAL: Email — versão formal]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Assunto: [Nome do projeto] — verificação de 30 dias

Olá [Nome],

Passado um mês desde o lançamento do [projeto], gostava de fazer
uma breve verificação do impacto.

Três perguntas — resposta curta basta:

1. RESULTADO: [a métrica que prometemos melhorar] — o que observaste nos últimos 30 dias?
   (ex: número de agendamentos, vendas online, tempo poupado, etc.)

2. POSITIVO: O que funcionou melhor do que esperavas?

3. A MELHORAR: O que ainda não está como gostavas?

Os teus dados são úteis para mim também — ajudam a afinar as estimativas
para projetos futuros. Podes ser direto.

[Assinatura]
```

---

## FORMULÁRIO INTERNO — PREENCHER COM AS RESPOSTAS DO CLIENTE

Guardar em `CLIENTES/[NOME_CLIENTE]/ROI_CHECK_V[X]_30DIAS.md`:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ROI CHECK — [projeto] — 30 DIAS PÓS-LANÇAMENTO
Data de lançamento: [data]
Data desta verificação: [data]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ROI PROMETIDO (da proposta):
  Métrica: [o que prometemos melhorar]
  Valor estimado: [o que dissemos que ia acontecer]

ROI REAL (resposta do cliente):
  Métrica: [o que o cliente reportou]
  Valor real: [o número ou percepção do cliente]
  Desvio: [real vs prometido — positivo/negativo/neutro]

O QUE CORREU BEM: [resposta do cliente]

O QUE AINDA FALHA: [resposta do cliente]

CLASSIFICAÇÃO:
  [ ] Superou expectativas — usar como caso de estudo
  [ ] Entregou o prometido — resultado sólido
  [ ] Entregou parcialmente — o que faltou: [razão]
  [ ] Não entregou o prometido — o que falhou: [razão]

ação IMEDIATA:
  [ ] Propor próxima iteração (se resultado sólido)
  [ ] Oferecer correcção (se algo falhou)
  [ ] Pedir testemunho (se superou expectativas)

APRENDIZAGEM PARA PADRÕES FUTUROS:
  [o que isto ensina sobre estimativas deste tipo de projeto]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## COMO USAR O TESTEMUNHO

Se o resultado foi positivo, pedir ao cliente um testemunho escrito ou em vídeo.
Estrutura sugerida para o testemunho (pode enviar como guia):

```
"Antes do projeto, [problema que tinha].
Depois do lançamento, [resultado específico com número se possível].
O que mais surpreendeu foi [algo inesperadamente bom].
Recomendo porque [razão específica]."
```

**Onde usar o testemunho:**
- Na próxima proposta para clientes do mesmo SETOR
- No pitch do modelo IAH (versão curta e versão completa)
- No Gemini: alimentar a DIRETRIZ V2 com dados reais de impacto

---

## COMO ALIMENTAR O SISTEMA COM OS DADOS

**Ao receber as respostas do cliente:**

1. atualizar a Biblioteca de Padrões na Skill (`SKILL_PROTOCOLO_VANGUARD.md`):
   - Se a estimativa de ROI estava certa → reforçar o padrão
   - Se estava errada → corrigir a estimativa para o tipo de projeto

2. Adicionar ao NotebookLM como fonte para projetos futuros do mesmo SETOR:
   - O arquivo `ROI_CHECK_V[X]_30DIAS.md` torna-se fonte de dados reais
   - O NotebookLM passa a dizer "neste tipo de projeto, o ROI real foi X em 30 dias"

3. Se abriu porta para próxima iteração:
   - Iniciar novo ciclo com COMANDO 1 para o Gemini
   - Incluir no briefing: "resultado dos 30 dias: [dados reais]"

---

## ACUMULADOR DE RESULTADOS (atualizar após cada check)

> Manter este registo atualizado — é a prova social real do Pentalateral.

| projeto | Tipo | Camada | ROI Prometido | ROI Real 30d | Desvio | Testemunho |
|----------|------|--------|--------------|-------------|--------|-----------|
| [nome] | [tipo] | [C] | [estimado] | [real] | [+/-] | SIM/NÃO |

---

*ROI Tracker · PENTALATERAL IAH · V1.0*
*Usar em todos os projetos, sem exceção · Os dados acumulados aqui são o ativo mais valioso do sistema*
