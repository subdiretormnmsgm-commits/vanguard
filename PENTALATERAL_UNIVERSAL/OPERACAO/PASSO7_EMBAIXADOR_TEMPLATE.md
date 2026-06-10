# PASSO 7 — TEMPLATE UNIVERSAL: PARA O EMBAIXADOR (CLAUDE PROJECTS)
# Versão: Universal v2.1 · 2026-06-09 · PENTALATERAL_UNIVERSAL/OPERACAO/
# Mudança v2.1: BLOCO 8 (Inteligência Externa) adicionado como PARTE 5 obrigatória na SEÇÃO D
# Uso: O Músculo preenche os [PLACEHOLDERS] com dados reais antes de enviar ao Embaixador.

---

## INSTRUÇÕES PARA O DIRETOR — ANTES DE ABRIR O CLAUDE PROJECTS

**O que fazer (em 3 passos simples):**

```
1. RODAR no terminal:
   .\scripts\ir_ao_embaixador.ps1 -cliente [NOME]
   → Script verifica se VEREDITOS_RESUMO da sessão anterior existe
   → Copia MENSAGEM_INTERACAO_INICIAL para clipboard
   → Abre browser em claude.ai/projects
   → Abre Explorer na pasta CLIENTES\[NOME]\CLAUDE_PROJECT\

2. NO CLAUDE PROJECTS:
   Se primeiro acesso: colar 00_INSTRUCAO_SISTEMA.md em Settings > Instructions
   PRÉ-REQUISITO: subir DIRETRIZ_GEMINI_V[N].txt em Knowledge Documents (Settings > Knowledge)
   → sem a DIRETRIZ, o Embaixador reage ao Pentalateral sem o plano real do Músculo
   Em qualquer acesso: colar o conteúdo da seção relevante deste template no chat

3. AGUARDAR resposta do Embaixador.
   O Embaixador entrega: [E-1 a E-5] + alertas + temperatura do cliente + DECISOES.json
   APÓS RECEBER (Eduardo só delibera — Músculo faz o resto):
   → Colar o output completo do Embaixador no Claude Code (chat do Músculo)
   → Músculo extrai JSON + lista decisões: "D1: [título] — A: [opção] | B: [opção]"
   → Eduardo responde apenas: "D1:A, D2:B" — Músculo executa automaticamente
   MEMORIA_EMBAIXADOR: atualizada automaticamente pelo Músculo via P-032
```

> Por que usar o Embaixador: ele é o único membro com memória persistente do cliente.
> Sem ele, cada sessão começa do zero com o cliente. Com ele, cada sessão começa
> onde a última terminou — acumulando inteligência que nenhum outro membro tem.

---

## PROTOCOLO ANTI-DEFICIÊNCIAS DO EMBAIXADOR
> Leia antes de cada ativação. O Embaixador tem deficiências documentadas — compensá-las ativamente.

**Deficiência 1 — Viés de Afinidade**
O Embaixador pode suavizar alertas sobre clientes com quem desenvolveu relacionamento positivo.
Contra-ataque: ao emitir ALERTA, exigir que o Embaixador cite evidência concreta da MEMORIA_EMBAIXADOR, não apenas intuição.

**Deficiência 2 — Excesso de Otimismo de Engajamento**
O Embaixador pode interpretar silêncio como "processando" quando na verdade é churn emocional.
Contra-ataque: qualquer cliente sem resposta há 5+ dias = ALERTA AP-1 obrigatório, mesmo que a última mensagem fosse positiva.

**Deficiência 3 — Generalização de Perfil**
O Embaixador pode aplicar padrões de um cliente anterior a um cliente diferente do mesmo nicho.
Contra-ataque: cada cliente tem entrada separada em MEMORIA_EMBAIXADOR. Nunca comparar perfis sem evidência explícita.

**Deficiência 4 — Omissão de Flags Desconfortáveis**
O Embaixador pode omitr sinais de que o cliente está insatisfeito para manter o momentum positivo.
Contra-ataque: Músculo pergunta diretamente: "Qual é o sinal mais preocupante que você detectou sobre [NOME] neste ciclo?"

**Deficiência 5 — Scope Creep Validado por Entusiasmo**
O Embaixador pode confirmar ideias do loop simplesmente porque o cliente mostrou entusiasmo com conceito similar, sem evidência de que o cliente pagaria por isso.
Contra-ataque: CONFIRMA só vale quando o cliente demonstrou disposição de pagar ou usar ativamente, não apenas interesse verbal.

**Deficiência 6 — Silo de Cliente (DEF-E-6)**
O Embaixador vê um cliente por vez e não tem como detectar padrões que só aparecem quando se compara dois clientes do mesmo nicho.
Contra-ataque: ao emitir [E-1 a E-5], o Embaixador aplica INTELIGENCIA_CRUZADA_NICHO se houver mais de 1 cliente ativo no mesmo nicho:
```
INTELIGENCIA_CRUZADA_NICHO (quando aplicável):
  Padrão observado em [CLIENTE-A]: [comportamento]
  Padrão observado em [CLIENTE-B]: [comportamento]
  O que isso sugere para o nicho [NOME-NICHO]: [hipótese de mercado]
```
Se há apenas 1 cliente no nicho, declarar: "Cruzamento impossível — único cliente no nicho."

**Deficiência 7 — Temperatura Simples (DEF-E-7)**
A temperatura do cliente (FRIA/MORNA/QUENTE/ENTUSIASMADA) é um snapshot estático que não captura tendência nem contexto de pagamento.
Contra-ataque: ao emitir temperatura, usar TEMPERATURA_PONDERADA:
```
TEMPERATURA_PONDERADA:
  Temperatura atual: [FRIA / MORNA / QUENTE / ENTUSIASMADA]
  Tendência (vs. loop anterior): [↑ subindo / → estável / ↓ caindo]
  Contexto de pagamento: [em dia / próximo vencimento / atrasado / N/A]
  Score composto: [0-10 — baseado nos 3 fatores acima]
  Alerta se score < 6: [CHURN-WATCH ativado]
```

---

## CABEÇALHO DA ATIVAÇÃO

```
ATIVAÇÃO DO EMBAIXADOR — [NOME_DO_CLIENTE]
Data: [YYYY-MM-DD]
Loop atual: [N] | Dia do build: [X] | Fase: [PRÉ-REUNIÃO / DEBRIEF / PIPELINE / REAÇÃO]
Última ativação: [DATA]

--- ELO DO CICLO ATUAL (obrigatório no cabeçalho) ---
DIRETRIZ em processo: DIRETRIZ_GEMINI_V[N].txt
Skill gerada pelo Auditor: [cliente]-v[N].md
Skill executada pelo Músculo: /[cliente]-v[N] (antes de qualquer build)
Gate atual: [DESCREVER o gate do loop — ex: Gate P-038, demo pendente, contrato pendente]
```

> Por que o elo importa para o Embaixador: sem saber qual DIRETRIZ e qual Skill estão
> em execução, o Embaixador reage a ideias abstratas — não ao plano real do Músculo.
> Com o elo declarado, o CONFIRMA/EXPANDE/ALERTA é baseado no que o Músculo vai
> REALMENTE construir, não em hipóteses genéricas do ciclo.

---

## CONTEXTO DO PROJETO
> O Músculo preenche esta seção com dados reais antes de enviar ao Embaixador.

**Cliente:** [NOME_DO_CLIENTE]
**Projeto:** [NOME_DO_PROJETO]
**Camada:** [1-5]
**Status atual:** [DESCREVER: o que foi entregue, o que falta, gate mais recente]
**Temperatura estimada do cliente (Músculo):** [FRIA / MORNA / QUENTE / ENTUSIASMADA]
**Itens [SCOPE-WATCH] abertos:** [LISTAR OU "nenhum"]
**Itens [CHURN-WATCH] abertos:** [LISTAR OU "nenhum"]

---

## MISSÃO DESTA ATIVAÇÃO
> Marcar somente uma. Colar a seção correspondente no chat do Embaixador.

- [ ] BRIEFING PRÉ-REUNIÃO — Eduardo vai se reunir com o cliente
- [ ] DEBRIEF PÓS-REUNIÃO — Eduardo acabou de se reunir com o cliente
- [ ] PIPELINE DE LEAD — cliente mencionou alguém que pode ser um lead
- [ ] REAÇÃO AO PENTALATERAL — Embaixador reage às ideias do ciclo atual

---

## SEÇÃO A — BRIEFING PRÉ-REUNIÃO

> Usar quando: Eduardo vai ter reunião com o cliente.
> Prazo: pelo menos 2 horas antes da reunião.

```
Embaixador, briefing pré-reunião para [NOME_DO_CLIENTE].

O QUE SABEMOS SOBRE ESTE CLIENTE (desta MEMORIA_EMBAIXADOR):
[LISTAR OS 3-5 PONTOS MAIS RELEVANTES DO HISTÓRICO]

O QUE ESTA REUNIÃO PRECISA ENTREGAR:
[DESCREVER: objetivo principal, decisão esperada, o que queremos que o cliente sinta ao sair]

O QUE QUEREMOS DESCOBRIR:
[LISTAR PERGUNTAS OU HIPÓTESES QUE PRECISAM SER VALIDADAS]

ALERTAS DO WATCHDOG PARA ESTA REUNIÃO:
[LISTAR ITENS [SCOPE-WATCH] / [CHURN-WATCH] abertos que podem emergir]

PEDIDO AO EMBAIXADOR:
1. Quais pontos desta reunião o Diretor deve abordar com cuidado?
2. Qual é a pergunta-chave que vai revelar o estado real do cliente?
3. O que o Diretor NÃO deve mencionar nesta reunião (e por quê)?
4. Se tudo correr bem, qual o próximo passo natural a propor?
```

---

## SEÇÃO B — DEBRIEF PÓS-REUNIÃO (Passo 8.5)

> Usar quando: Eduardo acabou de ter reunião, ligação ou troca relevante com o cliente.
> Prazo máximo: 24 horas após a reunião.

```
Embaixador, debrief pós-reunião com [NOME_DO_CLIENTE].

O QUE ACONTECEU (Eduardo relata informalmente):
[DESCREVER: como foi a reunião, o que o cliente disse, como reagiu ao produto,
 pedidos que fez, perguntas que fez, como terminou a reunião]

PEDIDO AO EMBAIXADOR:
Com base neste relato e no histórico de [NOME_DO_CLIENTE] na MEMORIA_EMBAIXADOR:

1. Quais hipóteses sobre este cliente foram CONFIRMADAS?
2. Quais hipóteses foram REFUTADAS (o cliente agiu diferente do esperado)?
3. Há sinais de SCOPE-WATCH que devo registrar?
4. Há sinais de CHURN-WATCH que devo monitorar?
5. O cliente mencionou alguém? (acionar pipeline de lead se sim)
6. Qual é a temperatura atual do cliente em escala FRIA/MORNA/QUENTE/ENTUSIASMADA?
7. Qual é o próximo passo que maximiza o avanço do projeto e do relacionamento?

ATUALIZAR MEMORIA_EMBAIXADOR com:
- Data da reunião e resumo de 3 linhas
- Hipóteses confirmadas/refutadas
- Alertas ativos (SCOPE-WATCH, CHURN-WATCH)
- Próxima ação recomendada
```

---

## SEÇÃO C — PIPELINE DE LEAD

> Usar quando: cliente mencionou alguém — colega, parceiro, amigo, concorrente — que pode ser lead.
> O Embaixador infere perfil e sugere pergunta casual a plantar.

```
Embaixador, pipeline de lead detectado a partir de [NOME_DO_CLIENTE].

O QUE O CLIENTE DISSE:
[DESCREVER: o que exatamente foi mencionado, contexto, como surgiu na conversa]

O QUE SABEMOS SOBRE O LEAD:
[DESCREVER: nome se conhecido, nicho, empresa, contexto inferido]

PEDIDO AO EMBAIXADOR:
1. Com base no que [NOME_DO_CLIENTE] disse, qual é o perfil mais provável deste lead?
2. Qual é a dor mais provável que este lead tem (inferida pelo nicho/contexto)?
3. Qual pergunta casual Eduardo pode plantar em [NOME_DO_CLIENTE] para saber mais?
4. Em qual momento natural da próxima conversa com [NOME_DO_CLIENTE] essa pergunta cabe?
5. Se qualificado, qual seria o "Choque de Valor Imediato" mais impactante para este perfil?
```

---

## SEÇÃO D — REAÇÃO AO PENTALATERAL (P-031)

> Usar quando: Músculo, Estrategista e Auditor geraram suas ideias e o Embaixador precisa filtrar pela realidade do cliente.
> Colar as ideias dos outros membros aqui para o Embaixador reagir.

```
Embaixador, reação ao ciclo atual do Pentalateral para [NOME_DO_CLIENTE].

CONTEXTO DO CICLO (elo obrigatório — não omitir):
- DIRETRIZ em execução: DIRETRIZ_GEMINI_V[N]
- Skill que o Músculo vai executar: /[cliente]-v[N]
- O que a Skill define como prioridade de build: [RESUMO DE 2 LINHAS DA PRIORIDADE PRINCIPAL]
- O que a Skill proíbe de construir: [RESUMO DO QUE ESTÁ FORA DO ESCOPO]

[M-1 a M-5] — IDEIAS DO MÚSCULO:
[COLAR AS 5 IDEIAS DO MÚSCULO COM NOME E DESCRIÇÃO DE 2 LINHAS CADA]

[G-1 a G-5] — IDEIAS DO ESTRATEGISTA (GEMINI):
[COLAR AS 5 IDEIAS DO GEMINI COM NOME E DESCRIÇÃO DE 2 LINHAS CADA]

[N-1 a N-5] — IDEIAS DO AUDITOR (NOTEBOOKLM):
[COLAR AS 5 IDEIAS DO NOTEBOOKLM COM NOME E DESCRIÇÃO DE 2 LINHAS CADA]

INSTRUÇÃO DE AMPLITUDE — BLOCO 8 ATIVO:
O Embaixador tem acesso à internet, busca avançada e pesquisa profunda em tempo real.
Na PARTE 5 deste pedido, use essas capacidades ativamente.
Não responda com base apenas em memória — pesquise, cite fontes, confronte dados.

CRITÉRIO DE FONTE — INVIOLÁVEL:
  ACEITO:   sites oficiais de órgãos/empresas · relatórios Gartner/McKinsey/IBGE ·
            publicações técnicas (GitHub, docs oficiais, arxiv) · press releases ·
            veículos jornalísticos com CNPJ identificado.
  PROIBIDO: blogs de opinião sem autoria institucional · Medium sem peer review ·
            posts de redes sociais como fonte primária · sites sem data de publicação.
  DÚVIDA:   cite + sinalize [FONTE SECUNDÁRIA — verificar].

---

PEDIDO AO EMBAIXADOR — CINCO PARTES OBRIGATÓRIAS:

PARTE 1 — FILTRO DE REALIDADE (MANDATO TOTAL — 15 IDEIAS OBRIGATÓRIAS)
⚠️ REAGIR INDIVIDUALMENTE A CADA UMA DAS 15 IDEIAS SEM EXCEÇÃO.
   Sequência obrigatória: M-1 → M-2 → M-3 → M-4 → M-5 → G-1 → G-2 → G-3 → G-4 → G-5 → N-1 → N-2 → N-3 → N-4 → N-5
   Nenhuma ideia pode ser omitida. Silêncio sobre uma ideia = entrega incompleta = retornar ao Embaixador.
   Omitir não é resumir — é uma ideia por bloco, mesmo que a reação seja de 2 linhas.

Para cada uma das 15 ideias, responder com:
  CONFIRMA — se o cliente demonstrou comportamento, interesse ou disposição compatível
  EXPANDE  — se o cliente tem contexto que potencializa esta ideia além do que foi proposto
  ALERTA   — se o comportamento real do cliente contradiz ou torna esta ideia arriscada

Formato obrigatório por ideia (sem exceção):
  [M/G/N]-[N]: [NOME DA IDEIA]
  Reação: [CONFIRMA / EXPANDE / ALERTA]
  Evidência da MEMORIA_EMBAIXADOR: [citar o que o cliente disse/fez — ou "sem evidência direta, mas..."]
  Severidade (apenas para ALERTA): [ALTO / CRÍTICO]

Após as 15 reações individuais → PARTE 2 → PARTE 3 → PARTE 4.

PARTE 2 — ANÁLISE INOVADORA (P-035 — amplitude total)
"Não tenho evidência direta, mas vejo este risco/oportunidade" é contribuição obrigatória.
- [RISCO PRINCIPAL DO CICLO ATUAL para o cliente]
- [OPORTUNIDADE DE PIPELINE — o cliente mencionou alguém?]
- [O QUE O MÚSCULO E O GEMINI NÃO ESTÃO VENDO]

PARTE 3 — INTELIGÊNCIA DE MERCADO (dimensão expandida)
O que o comportamento real do cliente revela sobre o nicho — não apenas sobre ele individualmente:
- Padrão confirmado no nicho: [comportamento que provavelmente se repete em outros clientes similares]
- Padrão específico deste cliente: [o que é dele, não do nicho]
- Argumento de venda derivado: [o que Eduardo usa como prova social para o próximo cliente do nicho]
- Risco de nicho: [o que pode impedir a escala de 1 para N clientes]
- Modelo de precificação: [o nicho suporta MRR / licença única / project-based?]

PARTE 5 — MISSÃO DE INTELIGÊNCIA EXTERNA [BLOCO 8 ATIVO]
USE SUA CAPACIDADE DE BUSCA NA INTERNET AGORA.
Músculo preenche os placeholders abaixo com o nicho e tecnologias do projeto antes de enviar.
Para cada tarefa: pesquise, cite fonte (URL + data de acesso), entregue dados reais.

[BLOCO 8 — TAREFA 1] RADAR COMPETITIVO — [NICHO_DO_PROJETO]
→ Quem oferece produto equivalente no Brasil hoje (últimos 90 dias)?
→ Algum concorrente direto surgiu ou ganhou tração recentemente?
Entregável: 2-3 concorrentes reais — URL + o que fazem + ponto fraco.

[BLOCO 8 — TAREFA 2] SENSOR DE TENDÊNCIAS — [TECNOLOGIAS_CENTRAIS]
→ Estado real de adoção das tecnologias centrais do projeto?
→ Atualizações críticas de API ou regulação nos últimos 30 dias?
→ Formato de produto ou go-to-market viral em B2B nos últimos 60 dias?
Entregável: 2-3 tendências com impacto direto + link.

[BLOCO 8 — TAREFA 3] FACT-CHECKER DO CONSELHO
→ Afirmações técnicas ou de mercado de M/G/N que precisam de verificação externa:
  [MÚSCULO LISTA AQUI AS PREMISSAS QUE PRECISAM DE VERIFICAÇÃO]
Entregável: CONFIRMADO / PARCIALMENTE CORRETO / DERRUBADO + fonte.

[BLOCO 8 — TAREFA 4] BENCHMARK DE PRICING
→ Preço real de produtos comparáveis no segmento-alvo?
→ Teto de preço que o segmento aceita pagar?
→ Modelo de cobrança dominante (SaaS, por uso, freemium, projeto)?
Entregável: tabela produto · preço · modelo · fonte URL.

[BLOCO 8 — TAREFA 5] WATCH REGULATÓRIO
→ Mudanças recentes em regulação/legislação/edital que afetam o cliente [NOME_DO_CLIENTE]?
→ Algum edital público relevante para o nicho [NICHO_DO_PROJETO]?
Entregável: achados com link oficial + impacto imediato para o cliente.

---

PARTE 4 — DECISOES.json (DEF-E-8: obrigatório ao fechar SEÇÃO D)

CRITÉRIO DE ATIVAÇÃO (schema v1.1 — 2026-05-24):
  JSON obrigatório → decisões com consequência formal:
    inscrever_ledger | criar_nota_regerar_pdf | LEGAL-WATCH | pitch/Change-Order | SCOPE com compromisso
  JSON dispensável → decisões relacionais puras:
    tom de mensagem WhatsApp sem novo compromisso | escolha de horário de check-in
  Critério: consequência formal — NÃO B2C vs. B2B (ambos os perfis têm decisões formais)

FLUXO OBRIGATÓRIO — Eduardo só delibera (schema v1.1 — 2026-05-24):

  Embaixador fecha ativação → gera DECISOES_[CLIENTE]_[YYYY-MM-DD].json
  Eduardo cola output completo do Embaixador no Claude Code (chat do Músculo)
    ↓ Músculo extrai JSON + lista decisões numeradas:
      "D1: [título] — A: [ação A] | B: [ação B]"
  Eduardo responde apenas: "D1:A, D2:B"
    ↓ [Gate D1 — Hypercare] Se hypercare_ativo: true + artefato_editavel: true:
        Músculo exibe artefato_texto + aguarda "ok" antes de executar copiar_clipboard
    ↓ [Flag D2 — uso] Se requer_uso_confirmado: true + opção plantar_hoje selecionada:
        AVISO: Músculo registra risco e aguarda confirmação de uso ativo pelo Diretor
    ↓ [Flag D3 — cliente] Se resumo_para_cliente: true:
        executar_vereditos.ps1 gera VEREDITOS_RESUMO_[CLIENTE]_[DATA]_CLIENTE.md
    ↓ executar_vereditos.ps1 gera VEREDITOS_RESUMO_[CLIENTE]_[DATA].md automaticamente
       → salvo em CLIENTES/[NOME]/CLAUDE_PROJECT/ → carregar no Projects na próxima ativação
  Ciclo completo — Eduardo não move nenhum arquivo

SCHEMA v1.1 — campos obrigatórios:
{
  "schema_version": "1.1",
  "cliente": "[NOME_CLIENTE_UPPER]",  ← P-059: OBRIGATÓRIO — Músculo confirma identidade antes de listar decisões
  "loop": N,                          ← P-059: OBRIGATÓRIO — validação dupla cliente+loop antes de qualquer execução
  "projeto_label": "[NOME_CLIENTE]",
  "data_decisoes": "[YYYY-MM-DD]",
  "hypercare_ativo": true,           ← true nos dias 1–30 do contrato
  "vereditos": [{
    "id": "D1",
    "titulo": "[decisão]",
    "urgencia": "ALTA|MEDIA|BAIXA",
    "situacao": "[contexto]",
    "artefato_editavel": false,        ← true → gate D1 obrigatório se hypercare_ativo
    "requer_uso_confirmado": false,    ← true → bloqueia plantar_hoje até uso confirmado
    "resumo_para_cliente": false,      ← true → aparece no VEREDITOS_RESUMO_CLIENTE (Sentinel)
    "opcoes": [
      {"valor": "A", "label": "[ação A]", "acoes": ["copiar_clipboard"]},
      {"valor": "B", "label": "[ação B]", "acoes": ["log_apenas"]}
    ],
    "artefato_texto": "[texto — obrigatório se artefato_editavel: true]"
  }]
}

DECISOES.json NÃO sobe ao Claude Projects — JSON não é lido como Knowledge Document.
VEREDITOS_RESUMO_[DATA].md (.md) É carregado no Claude Project na próxima ativação.
Ações mapeadas: "log_apenas" | "copiar_clipboard" | "log_contato" |
                "inscrever_ledger" | "criar_nota_regerar_pdf"

Regra: Músculo NÃO executa sem resposta "D1:A, D2:B" do Diretor.
```

---

## FORMATO OBRIGATÓRIO — 6 BLOCOS DA RESPOSTA DO EMBAIXADOR

```
BLOCO 1 — TEMPERATURA_PONDERADA DE [NOME_DO_CLIENTE]
  Temperatura atual: [FRIA / MORNA / QUENTE / ENTUSIASMADA]
  Tendência (últimos 7 dias): [subindo / estável / caindo]
  Contexto de pagamento: [em dia / próximo vencimento / atrasado / N/A]
  Score 0-10: [N]  ← Score < 6 = CHURN-WATCH automático
  Razão: [1-2 linhas com evidência concreta]

BLOCO 2 — HIPÓTESES ATIVAS
  Para cada hipótese pendente: CONFIRMADA / REFUTADA / PENDENTE + evidência de 1 linha

BLOCO 3 — COMPORTAMENTO DO CLIENTE (3 pontos obrigatórios)
  O que [NOME] fez que era esperado:
  O que [NOME] fez que foi surpresa:
  O que [NOME] NÃO fez que deveria ter feito:

BLOCO 4 — WATCHDOG
  [SCOPE-WATCH] abertos:
  [CHURN-WATCH] ativos:
  Próximo debrief recomendado:

BLOCO 5 — [E-1 a E-5] IDEIAS EXCLUSIVAS DO EMBAIXADOR
  Perspectiva exclusiva — não síntese das ideias dos outros membros.
  Para cada ideia:
    [E-N] [NOME]
    Descrição: [o que é]
    Por que [NOME_DO_CLIENTE] valorizaria: [razão fundamentada no histórico]
    Evidência: [o que o cliente disse/fez]

BLOCO 6 — INTELIGÊNCIA DE MERCADO ([NICHO])
  O que o comportamento real do cliente revela sobre o nicho — não sobre ele individualmente:
  Padrão confirmado no nicho: [comportamento que provavelmente se repete em outros clientes similares]
  Padrão específico deste cliente: [o que é dele, não do nicho]
  Argumento de venda derivado: [o que Eduardo usa como prova social para o próximo cliente]
  Risco de nicho: [o que pode impedir a escala de 1 para N clientes]

BLOCO 7 — PRÓXIMA AÇÃO RECOMENDADA
  [AÇÃO ESPECÍFICA] — [QUEM EXECUTA] — [PRAZO]
  Razão: [por que esta ação agora e não outra]
```

---

## VALIDAÇÃO ANTES DE FECHAR A SESSÃO DO EMBAIXADOR

| Item | Critério |
|---|---|
| [E-1 a E-5] foram geradas? | Sim — exclusivas, não síntese |
| Todas as 15 ideias receberam reação individual? | Sim — M-1 a M-5 + G-1 a G-5 + N-1 a N-5 com CONFIRMA/EXPANDE/ALERTA. Zero omissões. |
| SCOPE-WATCH atualizado? | Sim — novos itens adicionados se detectados |
| Temperatura do cliente atualizada? | Sim — com razão declarada |
| MEMORIA_EMBAIXADOR marcada para atualização (P-032)? | Sim — Músculo atualiza após sessão |
| DIRETRIZ_GEMINI_V[N].txt subida ao Claude Project? | Obrigatório antes de ativar SEÇÃO D |
| DECISOES.json gerado pelo Embaixador (schema v1.1)? | Obrigatório ao fechar SEÇÃO D — ausência = DEF-E-8 |
| DECISOES.json salvo LOCAL em DECISOES/? | NÃO sobe ao Projects — JSON não é Knowledge Document |
| VEREDITOS_RESUMO.md gerado automaticamente? | via executar_vereditos.ps1 — carregar no Projects |

---

*Template Universal · Pentalateral IAH · OPERACAO/ · Atualizar ao descobrir novo padrão de relacionamento com cliente*
*Versão: 1.3 · 2026-05-24 — Pipeline inline (Eduardo só delibera) · Schema v1.1 · Gate Hypercare · DIRETRIZ upload obrigatório*
