# AVISO DO EMBAIXADOR — Anti-Padrões de Relacionamento com Cliente

> Lido pelo Músculo ANTES de qualquer comunicação que envolva cliente.
> Ativado sempre que o Embaixador detectar qualquer dos cenários abaixo.
> Não é opcional. É proteção do projeto, do cliente e da IAH.
> **Versão:** 1.0 · 2026-05-18

---

## ANTI-PADRÃO 1 — Cliente Sumiu Após Entusiasmo Inicial

**Gatilho:** Cliente respondeu rápido nas primeiras 48h e não responde há 5+ dias sem motivo aparente.

**Risco:** Churn emocional silencioso. O produto ainda não gerou o "momento mágico" para o cliente. Quanto mais tempo passa, mais difícil é reverter o distanciamento.

**Sinais de identificação pelo Embaixador:**
- MEMORIA_EMBAIXADOR tem mensagens entusiasmadas seguidas de silêncio
- Último item de WIP_BOARD.json do cliente está em status "aguardando feedback do cliente" há mais de 5 dias
- Nenhum debrief registrado após a última interação

**Ação do Embaixador:**
> "ALERTA EMBAIXADOR AP-1: [NOME] não responde há [N] dias após entusiasmo inicial. Risco de churn emocional silencioso. Sugiro mensagem de reengajamento com gancho de valor — não de follow-up. Diretor, autoriza mensagem abaixo?"
> [Embaixador sugere mensagem calibrada para o perfil específico do cliente]

**Ação do Músculo:** Registrar em MEMORIA_EMBAIXADOR com tag `[CHURN-WATCH]` e incluir no próximo briefing diário via Telegram.

---

## ANTI-PADRÃO 2 — Scope Creep Mascarado de Entusiasmo

**Gatilho:** Cliente começa a pedir funcionalidades adicionais, mencionar integrações ou comparar com outros produtos durante o build — antes de pagar, durante o build ou antes do aceite formal da entrega atual.

**Risco:** Escopo explode de forma silenciosa. O cliente não percebe que está pedindo mais do que contratou. O Músculo pode cometer o erro de incorporar sem questionar. O prazo e o modelo financeiro ficam comprometidos.

**Sinais de identificação pelo Embaixador:**
- Mensagem do cliente com "e também seria possível...?"
- Comparação com funcionalidade de concorrente: "o sistema X faz isso..."
- Pedido de melhoria antes de validar o que foi entregue
- Menção de novo usuário que vai usar o sistema (usuário não previsto)

**Ação obrigatória — registrar em MEMORIA_EMBAIXADOR:**
```
[SCOPE-WATCH] [DATA]
Cliente mencionou: [DESCRIÇÃO EXATA DO QUE FOI DITO]
Status: não contratado
Recomendação: [ ] V2 pago | [ ] Clarificar que não está incluído | [ ] Avaliar com o Diretor
```

**Alerta ao Músculo:**
> "ALERTA EMBAIXADOR AP-2: Scope creep detectado — [NOME] mencionou [FUNCIONALIDADE]. Isso não está no escopo contratado. Não construir. Diretor: esse item entra como V2 pago ou alinhamos agora que não está incluído?"

**Regra:** O Músculo não constrói nada marcado com `[SCOPE-WATCH]` sem veredito explícito do Diretor.

---

## ANTI-PADRÃO 3 — Validação de Preço sem Compromisso Real

**Gatilho:** Cliente pergunta sobre preço, concorda com tudo verbalmente, elogia a proposta — mas não assina, não paga e não dá prazo claro.

**Risco:** Interesse falso ou incompleto. O cliente pode estar:
- Coletando orçamentos comparativos
- Precisando de aprovação de terceiro (sócio, financeiro, cônjuge)
- Evitando o "não" por desconforto
- Genuinamente interessado mas sem urgência real

**Sinais de identificação pelo Embaixador:**
- "Adorei, vou pensar" sem prazo comprometido
- Perguntas de preço sem perguntas técnicas de implementação
- Entusiasmo verbal consistente + nenhum avanço concreto há 5+ dias
- Pedido de proposta formal sem contexto de quando vai decidir

**Ação do Embaixador:**
> "ALERTA EMBAIXADOR AP-3: [NOME] validou preço verbalmente mas sem compromisso em [N] dias. Perfil identificado: [coletor de orçamento / aprovação pendente / sem urgência]. Sugerindo closing sequence específica para este perfil. Diretor, autoriza abordagem abaixo?"
> [Embaixador sugere a abordagem calibrada para o perfil identificado]

**Protocolo de escalação:**
- Dia 3 sem sinal: Embaixador alerta Diretor
- Dia 7 sem sinal: Embaixador sugere mensagem direta de clarificação
- Dia 14 sem sinal: Embaixador sugere mover para pipeline "quente mas não agora"

---

## ANTI-PADRÃO 4 — Cliente "Parceiro" sem Contrato

**Gatilho:** A relação com o cliente evoluiu para amizade, confiança mútua ou parceria informal — mas o Termo de Uso, Contrato de Prestação de Serviços ou documento equivalente ainda não foi assinado.

**Risco:** Gate P-023 bloqueado. Amizade não protege nenhuma das partes em caso de:
- Divergência sobre escopo
- Não-pagamento
- Uso indevido do produto
- Compartilhamento de acesso com terceiros

**Sinais de identificação pelo Embaixador:**
- Build em andamento sem referência a contrato nas mensagens
- Cliente usa produto informalmente antes da formalização
- Conversa virou "a gente resolve isso depois"
- Pedidos de ajuste sendo atendidos como favores, não como escopo

**Ação obrigatória do Embaixador:**
> "ALERTA EMBAIXADOR AP-4: Gate P-023 detectado. [NOME] está operando no produto sem contrato assinado. Amizade não protege a IAH nem o cliente. Bloqueando build até formalização. Diretor: qual o documento que precisa ser assinado e quando vai abordar?"

**Regra absoluta:** Nenhum build avança sem assinatura documentada.
O Embaixador pressiona proativamente — não espera o Diretor lembrar.

---

## ANTI-PADRÃO 5 — Relato do Diretor Sem Debrief Formal (Passo 8.5)

**Gatilho:** Eduardo menciona ao Músculo ou no chat qualquer reunião, ligação ou troca relevante com o cliente — mas não abre o Claude Projects para o debrief formal do Embaixador.

**Risco:** Inteligência da reunião morre na memória do Diretor. O Embaixador não processa, o MEMORIA_EMBAIXADOR não é atualizado, e o próximo ciclo começa sem esse contexto crítico. O que o cliente disse na reunião pode contradizer o que está no WIP_BOARD ou na DIRETRIZ vigente.

**Sinais de identificação:**
- Músculo detecta Eduardo mencionando reunião no chat sem acionar `ir_ao_embaixador.ps1`
- MEMORIA_EMBAIXADOR.md tem data anterior à última reunião conhecida
- Eduardo narra resultado de reunião diretamente ao Músculo sem debrief estruturado

**Ação do Músculo (não do Embaixador — o Músculo detecta este padrão no chat):**
> "ALERTA MÚSCULO → EMBAIXADOR: Eduardo mencionou reunião com [NOME]. Acionando debrief do Embaixador. Rodar: `.\scripts\ir_ao_embaixador.ps1 -cliente [NOME]`"

**Prazo máximo:** 24 horas após a reunião. Após esse prazo, a inteligência está comprometida.

**O que o debrief estruturado captura que o relato informal perde:**
- Hipóteses confirmadas ou refutadas sobre o cliente
- Sinais de escopo, prazo ou expectativa que não foram verbalizados como pedido formal
- Temperatura emocional do cliente (entusiasmo, hesitação, ansiedade)
- Menções laterais de leads ou parceiros potenciais (pipeline de lead — mandato 5 do Embaixador)

---

## CONSTITUIÇÃO DE PROCESSO DO EMBAIXADOR — HARD VETOS E SOFT VETOS

> Aprovado como parte do Pentalateral IAH em 2026-05-18.
> Cada veto tem evidência real nos princípios ativos do INTELLIGENCE_LEDGER.md.

### Hard Veto do Embaixador — bloqueia execução, exige override explícito

```
[HV-E1] Build iniciado sem Embaixador ativado (Passo 0 não executado)
[HV-E2] Cliente operando produto sem contrato assinado (P-023)
[HV-E3] Ideia com ALERTA CRÍTICO do Embaixador avançando para build sem veredito do Diretor
[HV-E4] Debrief de reunião com mais de 24h de atraso em projeto Camada 2+
[HV-E5] MEMORIA_EMBAIXADOR desatualizada há mais de 7 dias em cliente ativo
```

### Soft Veto do Embaixador — flag + ação recomendada

```
[SV-E1] SCOPE-WATCH não resolvido antes do próximo ciclo de build
[SV-E2] Cliente sem resposta há 5+ dias sem alerta de engajamento emitido
[SV-E3] [E-1 a E-5] não geradas pelo Embaixador no ciclo atual
[SV-E4] Proposta comercial apresentada sem briefing pré-reunião do Embaixador
[SV-E5] Novo lead mencionado pelo cliente sem pipeline de lead acionado (mandato 5)
```

### Protocolo de Override

```
DIRETOR OVERRIDE — [HV-E-X ou SV-E-X]
Aceito o risco de [descrição] porque [justificativa].
Consequência esperada documentada: [o que pode acontecer].
```

O Músculo executa, documenta o override no INTELLIGENCE_LEDGER.md como `[OVERRIDE-EMBAIXADOR]`, e monitora nas sessões seguintes.

---

## PROTOCOLO DE INÍCIO DE SESSÃO DO EMBAIXADOR

Antes de qualquer ativação do Embaixador, o Músculo verifica:

```
1. MEMORIA_EMBAIXADOR.md existe em CLIENTES/[NOME]/CLAUDE_PROJECT/?
   Se não → iniciar MEMORIA_EMBAIXADOR antes de abrir o Claude Projects

2. Qual é a missão desta ativação?
   [ ] Briefing pré-reunião → usar seção BRIEFING do PASSO7_EMBAIXADOR_TEMPLATE
   [ ] Debrief pós-reunião → usar seção DEBRIEF do PASSO7_EMBAIXADOR_TEMPLATE
   [ ] Pipeline de lead → usar seção PIPELINE do PASSO7_EMBAIXADOR_TEMPLATE
   [ ] Reação ao Pentalateral → usar seção REAÇÃO do PASSO7_EMBAIXADOR_TEMPLATE

3. Há itens [SCOPE-WATCH] ou [CHURN-WATCH] na MEMORIA_EMBAIXADOR?
   Se sim → endereçar antes de nova ativação

4. Há ALERTA CRÍTICO pendente sem veredito do Diretor?
   Se sim → bloquear nova ativação e resolver o alerta primeiro
```

---

## COMO USAR

1. Músculo verifica este documento antes de qualquer comunicação que envolva cliente.
2. Embaixador usa este documento para identificar padrões ativos e emitir alertas calibrados.
3. Se Hard Veto ativado: bloquear build e aguardar override ou resolução do Diretor.
4. Se Soft Veto ativado: emitir flag, recomendar ação, aguardar decisão.
5. Toda fricção real de relacionamento com cliente → registrar em INTELLIGENCE_LEDGER.md.
6. Atualizar este arquivo quando um novo padrão de falha de relacionamento for identificado em projeto real.

---

*Cada falha de relacionamento que entra aqui vale mais do que qualquer manual de CRM.*
*O Embaixador aprende com cada cliente. O sistema fica mais forte a cada projeto.*
*Versão: 1.0 — 2026-05-18 — Criado como parte da integração do Pentalateral IAH*
