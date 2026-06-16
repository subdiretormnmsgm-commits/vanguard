# TASKS COWORK — PROJETISTA
## Vanguard Tech · Pentalateral IAH · Loop 34+
## Textos prontos para colar via /schedule no Cowork (Claude Desktop)
## Como usar: abra o Cowork → nova tarefa → cole o texto → defina a cadência → Schedule

---

## COMO FUNCIONA A RELAÇÃO COWORK → PROJETISTA

O Cowork (Embaixador) produz inteligência de mercado via F1-F22.
O Projetista cruza essa inteligência com o VANGUARD_HISTORICO e projeta.

As tasks abaixo fazem o Cowork **preparar o terreno** para o Projetista —
depositando arquivos específicos em PROJETISTA/INBOX que o Projetista lê
na abertura de cada sessão. Você abre o Claude Project do Projetista
quando quiser colher. A automação prepara; você aciona.

**Regra de output de todas as tasks:**
→ Arquivo depositado em: INTELLIGENCE_HUB/PROJETISTA/INBOX/[AAAA-MM-DD]_[task].md
→ Formato markdown com cabeçalho padrão
→ Nunca mencionar IA, automação ou ferramentas em conteúdo externo

---

## TASK 1 — RADAR DE FRONTEIRA DELTA
**Cadência:** Semanal (segunda-feira, antes de você abrir o Projetista)
**O que faz:** varre o NICHE_INDEX e sinaliza os nichos prestes a amadurecer
**Aciona no Projetista:** Ação 5 (Vigiar a Fronteira) + inicia Ação 1 (Projetar)

**Texto para colar no /schedule:**
```
Toda segunda-feira de manhã, você é o Embaixador Agentado da Vanguard Tech
preparando material para o Projetista.

Leia o arquivo NICHE_INDEX.json (ou .txt) na pasta
INTELLIGENCE_HUB/NICHE_MODELS do Google Drive.

Identifique os nichos com sinal DELTA 🔄 REPETIDO que estão prestes a virar
🎯 TENDÊNCIA — ou seja, aqueles com 2 ciclos de confirmação acumulados.

Para cada nicho identificado, liste:
- Nome do nicho
- Quantos ciclos confirmados acumulou
- Qual frente (F1-F22) o confirmou por último e quando
- O sinal concreto que justifica a promoção (queixa, regulação, dado)
- O que falta para confirmar definitivamente (o que a próxima frente deve buscar)

Inclua também os nichos já em 🎯 TENDÊNCIA ou CONVERGÊNCIA que ainda não
receberam um plano de execução do Projetista.

NÃO projete nada. NÃO recomende produto. Apenas sinalize a fronteira.

Salve em:
INTELLIGENCE_HUB/PROJETISTA/INBOX/[data]_RADAR_FRONTEIRA_PROJETISTA.md

Cabeçalho obrigatório:
# RADAR DE FRONTEIRA — PROJETISTA · [DATA]
# Produzido por: Embaixador Agentado · Cowork
# Destino: PROJETISTA/INBOX → leitura de abertura do Projetista
```

---

## TASK 2 — PRÉ-DIGESTÃO DE MERCADO POR NICHO
**Cadência:** Semanal (terça-feira)
**O que faz:** cruza os outputs recentes do F1-F22 e monta um briefing de mercado
por nicho MOVER_AGORA — exatamente o que o Projetista precisa na Fase 1 (Iniciação)
**Aciona no Projetista:** Bloco 3 Passo 2 (leitura de mercado) + Fase 1 do ciclo de vida

**Texto para colar no /schedule:**
```
Toda terça-feira, você é o Embaixador Agentado da Vanguard Tech preparando
o briefing de mercado para o Projetista.

Leia os arquivos mais recentes depositados nas pastas temáticas
INTELLIGENCE_HUB/PIPELINE/, /CONTEUDO/, /COMPETITORS/, /TRENDS/
nos últimos 7 dias. Filtre os que são outputs de frentes de inteligência
de mercado (F1, F3, F16, F17, F18, F19, F20, F21, F22).

Para cada nicho com status MOVER_AGORA no NICHE_INDEX, consolide:

1. SINAIS DE MERCADO (do F1 e frentes de caça):
   - As 2-3 dores mais documentadas desta semana
   - Gatilho regulatório ativo (se houver): órgão + norma + prazo
   - Urgência: ALTA / MÉDIA / BAIXA + justificativa com fonte (URL)

2. ESTADO DA CONCORRÊNCIA (do F17/F19 se disponível):
   - Quem já atende este nicho e como
   - A lacuna que a Vanguard preenche que eles não preenchem

3. PONTO DE ENTRADA SUGERIDO:
   - Qual o perfil do primeiro prospect ideal neste nicho
   - Qual a dor de abertura mais forte (a que ele já sentiu no bolso)
   - Qual o canal mais provável de encontrá-lo

Formato por nicho:
## [NOME DO NICHO]
### Sinais de mercado | Concorrência | Ponto de entrada

Salve em:
INTELLIGENCE_HUB/PROJETISTA/INBOX/[data]_PREDIGESTAO_MERCADO_PROJETISTA.md

Cabeçalho obrigatório:
# PRÉ-DIGESTÃO DE MERCADO — PROJETISTA · [DATA]
# Produzido por: Embaixador Agentado · Cowork
# Destino: PROJETISTA/INBOX → alimenta Fase 1 (Iniciação) do Projetista
```

---

## TASK 3 — SÍNTESE PÓS-DELIBERAÇÃO DIÁRIA
**Cadência:** Diária (ao fim do dia, após a deliberação do Músculo)
**O que faz:** captura o que a deliberação do Músculo depositou de novo,
para o Projetista não precisar reler tudo
**Aciona no Projetista:** Bloco 3 Passo 1 (estado do sistema)

**Texto para colar no /schedule:**
```
Todo fim de dia, você é o Embaixador Agentado da Vanguard Tech fazendo
a síntese diária para o Projetista.

Verifique se houve arquivos novos ou modificados em:
- INTELLIGENCE_HUB/PIPELINE/, /CONTEUDO/, /COMPETITORS/, /TRENDS/ (outputs das frentes do dia)
- INTELLIGENCE_HUB/PENDING_REVIEW.md (novos alertas)
- WIP_BOARD.json (mudança de status de projetos)

Se houve novidades, escreva uma síntese objetiva de 5-10 linhas:
- O que foi produzido hoje e por qual frente
- Quais nichos foram afetados ou sinalizados
- Algum alerta novo no PENDING_REVIEW relevante para o Projetista
- Mudança de estado no WIP_BOARD (se houver)

Se não houve nada novo: escreva apenas "Sem novos depósitos hoje — [data]".

Acrescente ao final do arquivo (não sobrescreva — append):
INTELLIGENCE_HUB/PROJETISTA/INBOX/DIARIO_PROJETISTA.md

Formato de cada entrada:
---
[DATA] | [HORA]
[Síntese de 5-10 linhas]
---
```

---

## TASK 4 — VARREDURA DE ACERVO REAPROVEITÁVEL
**Cadência:** Quinzenal (primeira e terceira segunda-feira do mês)
**O que faz:** mapeia o que a Vanguard já construiu que pode ser reaproveitado
em novas projeções — alimenta diretamente a Fase 2 (Planejamento) do Projetista
**Aciona no Projetista:** Eixo 1 (hierarquia de aproveitamento) + Fase 2 (EAP)

**Texto para colar no /schedule:**
```
A cada duas semanas, você é o Embaixador Agentado da Vanguard Tech
mapeando o acervo reaproveitável para o Projetista.

Varra as seguintes pastas no Google Drive:
- INTELLIGENCE_HUB/PIPELINE/ (mensagens e abordagens já geradas)
- INTELLIGENCE_HUB/CONTEUDO/ (posts e cards prontos)
- INTELLIGENCE_HUB/NICHE_MODELS/ (modelos de nicho existentes)

Para cada ativo encontrado, catalogue:
- Nome do ativo
- A qual nicho pertence
- O que ele contém (argumento, narrativa, produto, abordagem)
- Grau de reuso: REUTILIZAR (serve direto) / ADAPTAR (precisa calibrar)
  / COMBINAR (junta com outro ativo)
- Com qual outro nicho ou situação poderia ser combinado

Agrupe por padrão de reaproveitamento:
- Auditoria preventiva documental (quais nichos compartilham esse padrão?)
- Conformidade de responsabilidade técnica pessoal (idem)
- Detecção de inconsistência regulatória (idem)
- [outros padrões que emergir]

NÃO invente ativos. Catalogue apenas o que existe nos arquivos.

Salve em:
INTELLIGENCE_HUB/PROJETISTA/INBOX/[data]_ACERVO_REAPROVEITAVEL_PROJETISTA.md

Cabeçalho obrigatório:
# ACERVO REAPROVEITÁVEL — PROJETISTA · [DATA]
# Produzido por: Embaixador Agentado · Cowork
# Destino: PROJETISTA/INBOX → alimenta Fase 2 (Planejamento/EAP) do Projetista
```

---

## TASK 5 — RETROALIMENTAÇÃO DO EMBAIXADOR DIGITAL
**Cadência:** Semanal (sexta-feira)
**O que faz:** coleta resultado de campo das campanhas do Embaixador Digital
e prepara o insumo de aprendizado para o Projetista incorporar nas próximas
projeções (Fase 4 — Encerramento: lições aprendidas)
**Ativar:** somente quando o Embaixador Digital estiver operando

**Texto para colar no /schedule:**
```
Toda sexta-feira, você é o Embaixador Agentado da Vanguard Tech
consolidando os resultados de campo para o Projetista.

Leia o PENDING_REVIEW.md e qualquer arquivo de resultado de campanha
em INTELLIGENCE_HUB/CONTEUDO/ ou INTELLIGENCE_HUB/PIPELINE/
modificados nos últimos 7 dias.

Identifique e documente:

1. ARGUMENTOS QUE CONVERTERAM:
   - Qual argumento ou abordagem gerou resposta positiva do prospect
   - Em qual nicho aconteceu
   - Qual canal foi usado (LinkedIn, WhatsApp, etc.)

2. NICHOS QUE RESPONDERAM vs NÃO RESPONDERAM:
   - O que o campo confirmou ou refutou sobre cada nicho
   - Diferença entre o que o Projetista projetou e o que o mercado respondeu

3. LIÇÕES APRENDIDAS (formato Fase 4 — Encerramento):
   - O que deve entrar no próximo plano de execução como padrão reutilizável
   - O que deve ser descartado ou adaptado
   - Qual nicho subiu ou desceu no DELTA com base no campo real

NÃO projete. Apenas registre o que o campo mostrou com evidências.

Salve em:
INTELLIGENCE_HUB/PROJETISTA/INBOX/[data]_RETROALIMENTACAO_DIGITAL_PROJETISTA.md

Cabeçalho obrigatório:
# RETROALIMENTAÇÃO DIGITAL — PROJETISTA · [DATA]
# Produzido por: Embaixador Agentado · Cowork
# Destino: PROJETISTA/INBOX → alimenta Fase 4 (Encerramento/Lições) do Projetista
```

---

## TASK 6 — PRÉ-MORTEM DE PROPOSTA (gatilho)
**Cadência:** Sob gatilho — acionar quando o Diretor indicar proposta >R$5k
**O que faz:** simula o decisor que vai recusar e blinda a proposta
antes do envio — alimenta a seção "Abordagem Blindada" do Projetista
**Aciona no Projetista:** Seção 8 (Abordagem Blindada) + Ação 4 (ligação ao Digital)

**Texto para colar no /schedule (ou acionar manualmente):**
```
GATILHO MANUAL — acionar quando o Diretor indicar proposta >R$5k.

Você é o Embaixador Agentado da Vanguard Tech simulando o pré-mortem
desta proposta.

Nicho: [PREENCHER AO ACIONAR]
Produto proposto: [PREENCHER AO ACIONAR]
Ticket estimado: [PREENCHER AO ACIONAR]
Perfil do prospect: [PREENCHER AO ACIONAR]

Execute F7 (Câmara de Guerra — Pré-Mortem):

1. Assuma o papel do decisor que vai RECUSAR esta proposta.
   Escreva as 5 razões pelas quais ele diz não:
   - Preço (como ele compara com alternativas?)
   - Timing (por que agora não é o momento?)
   - Confiança (o que ele ainda não acredita sobre a Vanguard?)
   - Concorrente (quem ele já conhece que faz algo parecido?)
   - Inércia (o que ele perde se não agir agora?)

2. Para cada razão: o contra-argumento que deveria estar na proposta
   e ainda não está. Formulado na linguagem do decisor, não da Vanguard.

3. Avalie a seção "Abordagem Blindada" do plano do Projetista:
   ela responde às 5 objeções? O que está faltando?

4. Entregue: a proposta blindada — os ajustes específicos antes do envio.

Salve em:
INTELLIGENCE_HUB/PROJETISTA/INBOX/[data]_F7_PREMORTEM_[nicho].md

Cabeçalho obrigatório:
# PRÉ-MORTEM DE PROPOSTA — [NICHO] · [DATA]
# Produzido por: Embaixador Agentado · Cowork (F7)
# Destino: PROJETISTA/INBOX → alimenta Abordagem Blindada do Projetista
```

---

## TASK 7 — SMOKE TEST DE DEMANDA (por vertical)
**Cadência:** Por vertical em validação — acionar quando Projetista recomendar F10
**O que faz:** testa se a demanda existe antes de recomendar build —
valida as hipóteses da Fase 1 (Iniciação) do Projetista

**Texto para colar no /schedule:**
```
GATILHO — acionar quando o Projetista recomendar teste de demanda para
um nicho específico.

Nicho: [PREENCHER AO ACIONAR]
Hipótese de dor: [PREENCHER AO ACIONAR]
Prazo de validação: [PREENCHER AO ACIONAR]

Execute F10 (Laboratório de Demanda):

1. LANDING PAGE DE HIPÓTESE (HTML):
   - Título com a dor exata do nicho (a que ele já sentiu no bolso)
   - 3 blocos de valor em linguagem do decisor (resultado, não ferramenta)
   - 1 formulário de interesse simples
   - CTA que mede intenção real: "Quero saber como evitar [dor X]"
   - Rodapé: "especialistas da Vanguard" — nunca IA, automação, ferramentas

2. TESTE A/B DE NARRATIVA — duas versões:
   - Versão Blindagem: "nunca mais perca por [erro específico do nicho]"
   - Versão Velocidade: "auditoria completa em [prazo] — sem risco de [dor]"

3. RELATÓRIO DE VALIDAÇÃO (após 2-3 semanas de dados):
   - Tráfego estimado, taxa de interesse, perguntas recebidas
   - Veredito: DEMANDA CONFIRMADA / SINAL FRACO / HIPÓTESE MORTA
   - Recomendação ao Projetista: vale construir o produto?

GUARDRAIL: a página nunca promete o que não pode ser entregue.
Publicação é decisão do Diretor.

Salve em:
INTELLIGENCE_HUB/PROJETISTA/INBOX/[data]_F10_SMOKETEST_[nicho].html
INTELLIGENCE_HUB/PROJETISTA/INBOX/[data]_F10_VALIDACAO_[nicho].md
```

---

## RESUMO DAS TASKS — CADÊNCIAS E ATIVAÇÕES

| Task | Cadência | O que entrega | Alimenta no Projetista |
|------|----------|---------------|------------------------|
| 1 — Radar de Fronteira | Semanal (seg) | RADAR_FRONTEIRA | Ação 5 (triagem) → Ação 1 |
| 2 — Pré-Digestão de Mercado | Semanal (ter) | PREDIGESTAO_MERCADO | Bloco 3 Passo 2 → Fase 1 |
| 3 — Síntese Pós-Deliberação | Diária | DIARIO_PROJETISTA | Bloco 3 Passo 1 |
| 4 — Acervo Reaproveitável | Quinzenal | ACERVO_REAPROVEITAVEL | Fase 2 (EAP/aproveitamento) |
| 5 — Retroalimentação Digital | Semanal (sex) | RETROALIMENTACAO_DIGITAL | Fase 4 (lições aprendidas) |
| 6 — Pré-Mortem de Proposta | Gatilho >R$5k | F7_PREMORTEM | Seção 8 (Abordagem Blindada) |
| 7 — Smoke Test de Demanda | Por vertical | F10_SMOKETEST + VALIDACAO | Fase 1 (viabilidade) |

**Tasks para ativar imediatamente:** 1, 2, 3, 4
**Tasks para ativar quando o Embaixador Digital estiver operando:** 5
**Tasks acionadas manualmente pelo Diretor:** 6, 7

---

## FLUXO COMPLETO — O QUE ACONTECE AUTOMATICAMENTE

```
[segunda, manhã]
  Task 1 → RADAR_FRONTEIRA_PROJETISTA.md (nichos prestes a amadurecer)

[terça, manhã]
  Task 2 → PREDIGESTAO_MERCADO_PROJETISTA.md (briefing de mercado por nicho)

[todo dia, noite]
  Task 3 → DIARIO_PROJETISTA.md (o que o dia depositou — append)

[quinzenal, segunda]
  Task 4 → ACERVO_REAPROVEITAVEL_PROJETISTA.md (o que a Vanguard já sabe)

[sexta, noite — quando Digital ativo]
  Task 5 → RETROALIMENTACAO_DIGITAL_PROJETISTA.md (o que o campo ensinou)

[quando Diretor acionar]
  Task 6 → F7_PREMORTEM_[nicho].md (proposta blindada)
  Task 7 → F10_SMOKETEST_[nicho].md (valida a hipótese)

[você abre o Claude Project do Projetista]
  Cola MEMORIA_PROJETISTA.md + bloco de ativação
  Projetista lê os 4 passos do Bloco 3 (inclui os arquivos acima)
  Projeta com método → materializa via NotebookLM → liga ao Digital
```

---
*Gerado em 2026-06-14 · Sessão Claude.ai · Loop 33*
*Sistema: Pentalateral IAH · Vanguard Tech*
*Motor: Cowork (Claude Desktop) → Projetista (Claude Project Opus 4.8)*
*Mecanismo: /schedule em linguagem natural — textos prontos para colar*
