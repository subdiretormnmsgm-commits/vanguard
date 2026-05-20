# AUDITORIA_MEDICINA_V2.md
> Pentalateral IAH — Auditoria de Nicho · Medicina · 2026-05-19
> Emitido por: Auditor (NotebookLM) · Recebido e processado pelo Músculo · 2026-05-19
> Fontes auditadas: INTELLIGENCE_LEDGER + METODOLOGIA_PERFIS_VANGUARD + MEMORIA_V3_INGRID + PESQUISA_BRUTA_MEDICINA + PASSO5_V2

---

## PARTE 1 — AUDITORIA DAS DIVERGÊNCIAS IDENTIFICADAS PELO AUDITOR

> **NOTA DO MÚSCULO (processamento pós-recebimento):**
> O Auditor identificou divergências de risco TÉCNICO DE PRODUTO, não as divergências de PROCESSO solicitadas
> em [DIV-1] a [DIV-3] do PASSO5. Ambas as perspectivas são válidas e complementares. O Músculo processa
> ambas e sinaliza a divergência de interpretação no bloco de deliberação separado.

### [DIV-A] Reutilização do Prompt do Tutor Socrático entre Ingrid e Medicina-R3
**VEREDICTO: RISCO REAL**

**O que o Auditor identificou:**
O PERFIL_MEDICINA_R3 descreve um tom "austere, técnico-clínico, sem encorajamento". O Tutor Socrático
da Skill Ingrid (EdTech-Concurso) opera com tom "caloroso, motivacional, comemorativo". São tons opostos.
Se o mesmo system prompt base for reutilizado para o primeiro cliente Medicina-R3, o produto entregará
tom incompatível com o perfil do médico residente — gerando rejeição imediata.

**Evidência histórica (MEMORIA_V3_INGRID):**
A Skill Ingrid foi construída especificamente para perfil concurseiro que precisa de motivação. O mesmo
motor (SM-2 + Tutor Socrático + banco de questões) está em 25-30% de maturidade para Medicina-R3.
Reutilizar os parâmetros de tom = tratar o médico R3 como concurseiro. Risco de churn no Dia 1.

**Recomendação do Auditor:**
sentinel_config.json, system prompt do Tutor Socrático e 00_INSTRUCAO_SISTEMA.md do Embaixador
devem ser instâncias isoladas por nicho. Não copiar — bifurcar com configurações distintas.

---

### [DIV-B] Geração de Casos Clínicos sem Curadoria Humana Prévia
**VEREDICTO: RISCO GERENCIADO**

**O que o Auditor identificou:**
A geração automática de questões com casos clínicos por LLM pode produzir:
(a) diagnósticos inconsistentes com as referências oficiais (Harrison, Sabiston, Williams),
(b) dados epidemiológicos desatualizados ou geograficamente inadequados (Brasil ≠ EUA),
(c) condutas que violam os protocolos do CFM — risco regulatório real.

**Como gerenciar:**
Incluir no system prompt de geração de questões médicas: citação obrigatória de referência + disclaimer
de validação + casos fictícios sem identificação. Um Shadow Medical Board (revisor humano de 50 questões
por especialidade antes de ativar o banco) reduz o risco para aceitável antes do primeiro cliente.

**Recomendação:** RISCO GERENCIADO com ferramentas de processo — não bloqueia captação, bloqueia build.

---

### [DIV-C] Micro-Sessões para Médicos Residentes
**VEREDICTO: FALSO ALARME**

**O que o Auditor identificou:**
Preocupação inicial de que médicos R3 não teriam tempo para sessões de estudo estruturadas
(formato típico de 30-60 min de plataformas EdTech convencionais).

**Evidência que refuta:**
O plantonista em escala 12×36 tem janelas de espera (madrugadas de plantão) onde consomem
conteúdo em blocos de 5-15 min. O formato micro-sessão não é limitação — é DIFERENCIAL do produto
Vanguard contra os cursinhos que exigem presença física. PERFIL_MEDICINA_R3 H-MED-3 já mapeou isso.

---

## PARTE 2 — VALIDAÇÃO DOS PRINCÍPIOS P-051 E P-052

### P-051 — Status: APROVADO (com observação de renomeação pelo Auditor)

**Veredicto do Auditor:** APROVADO
**Renomeação proposta pelo Auditor:** "Isolamento de Persona e Tom por Nicho"

> **Processamento do Músculo:**
> O Auditor APROVOU P-051 mas propôs renomeá-lo para um conceito DIFERENTE (isolamento de tom)
> do que P-051 captura (pausa obrigatória na fragmentação). São dois princípios distintos.
> P-051 permanece como escrito. O insight de isolamento de persona vira P-053 (novo).

**P-051 conforme LEDGER (mantido):**
"Fragmentação de nicho detectada → pausa obrigatória antes de construir Perfil"

**Coerência com LEDGER existente:** Compatível com P-048 (maturidade com cliente real) e P-041 (rotina operacional obrigatória).
**Rotina operacional:** Clara — PESQUISA_BRUTA com alerta → lista de sub-nichos → Diretor escolhe → Perfil focado.

---

### P-052 — Status: AJUSTE REQUERIDO

**Veredicto do Auditor:** APROVADO COM AJUSTE
**Texto sugerido pelo Auditor:**
> "O Comando de Propagação não apenas copia o código-base; ele exige a bifurcação isolada do contexto.
> Todo Comando de Propagação DEVE instanciar um novo PERFIL_CANDIDATO_[NICHO].md, um novo
> sentinel_config.json e uma nova 00_INSTRUCAO_SISTEMA.md para o Embaixador."

> **Processamento do Músculo:**
> O texto sugerido pelo Auditor descreve um princípio OPERACIONAL de propagação de produto —
> válido, mas diferente do P-052 atual (posicionamento estratégico de mercado — precisão vs. tráfego).
> P-052 permanece como escrito. O insight de bifurcação vira P-054 (novo princípio operacional).

**P-052 conforme LEDGER (mantido):**
"Vanguard compete por precisão cirúrgica — não por aquisição de tráfego massivo"

**Coerência com LEDGER:** Evidência factual — R1 Medicina excluído formalmente do portfólio.
**Rotina operacional:** Clara — checklist GO/NO-GO com 3 critérios (competição por tráfego, problema mal resolvido, diferencial Vanguard).

---

## PARTE 3 — PERSPECTIVA DO SÓCIO CONSULTOR

### 3.1 Risco de Contaminação de Tom (Hard Risk)

O mesmo Músculo vai construir dois produtos com tons opostos. O mesmo Embaixador vai atender dois
clientes com perfis emocionais opostos. Sem separação rígida de configuração, o risco de contaminação
de tom é sistêmico — não acidental.

**Recomendação:** Silo de Contexto por nicho. Embaixador Ingrid ≠ Embaixador Medicina-R3. Dois Claude
Projects separados, nunca compartilhados. Músculo nunca abre os dois no mesmo loop de deliberação.

### 3.2 Hard Fork Jurídico (Critical Risk — ação imediata)

O Termo de Uso atual foi construído para EdTech-Concurso (Ingrid). Se propagado para Medicina-R3 sem
adaptação, o produto operará:
- Sem declaração de que NÃO é conselho médico
- Sem cláusula de limitação de responsabilidade por conteúdo clínico
- Sem alinhamento com Resolução CFM sobre uso de IA em saúde

**Status:** Bloqueia build de Medicina-R3. Não bloqueia captação (captação é humana, sem produto ainda).
**Ação:** Gerar TERMO_DE_USO_MEDICINA_R3.md como fork do Termo Ingrid antes de qualquer build.

### 3.3 Comando de Propagação como Padrão Operacional

O Auditor confirma que o COMANDO_PROPAGACAO_CONSELHO (novo formato proposto pelo Embaixador)
deve ser padrão. Marcos que justificam emissão:
- Primeiro cliente de um novo nicho
- Gate aprovado que muda portfólio (ex: GO/NO-GO de nicho)
- Princípio novo extraído de iteração real com cliente

---

## PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR [N-1 a N-5]

### [N-1] Shadow Medical Board
**Descrição:** Antes de ativar o banco de questões para qualquer especialidade de R3, 50 questões passam
por revisão de um médico especialista (shadow board) para validar acurácia clínica e conformidade CFM.
**Por que ninguém propôs:** os outros membros focaram na geração automatizada como diferencial de
velocidade — ninguém pensou no custo regulatório de escalar sem revisão humana.
**Implementação:** 1 médico revisor por especialidade × 2h de revisão = custo fixo por lançamento de nicho.
Pode ser o próprio primeiro cliente R3 em exchange por desconto.

### [N-2] Pixel de Latência Recalibrado para Medicina
**Descrição:** O hard limit de 60 segundos por sessão (Ingrid) está errado para casos clínicos médicos,
que exigem 2-3 minutos de leitura + raciocínio. Limite inadequado gera timeout antes do cliente responder.
**Por que ninguém propôs:** padrão foi importado diretamente de EdTech-Concurso sem revisão de perfil.
**Ação:** sentinel_config.json de Medicina-R3 deve ter `session_timeout_seconds: 180` (não 60).

### [N-3] Disclaimer On-the-Fly por Categoria de Questão
**Descrição:** Para questões de dosagem, diagnóstico diferencial ou conduta terapêutica, injetar
automaticamente um disclaimer: "Este conteúdo é educacional. Não substitui julgamento clínico nem
protocolos institucionais." Gerado dinamicamente pelo sistema, não genérico no rodapé.
**Por que ninguém propôs:** outros membros trataram conformidade CFM como item de Termo de Uso — não
como feature ativa do produto.

### [N-4] Silo de Contexto do Embaixador por Nicho
**Descrição:** Embaixador Ingrid e Embaixador Medicina-R3 são dois Claude Projects separados, com
INSTRUCAO_SISTEMA distintas e sem acesso cruzado ao histórico do outro cliente.
**Por que ninguém propôs:** o Embaixador foi construído como "inteligência por cliente". A Medicina-R3
criou o primeiro caso onde dois nichos com tons opostos poderiam contaminar o mesmo Embaixador.
**Decisão necessária:** o Diretor confirma que Embaixador Medicina-R3 é um Project separado do Ingrid.

### [N-5] Auditoria de Opt-Out para APIs de Terceiros
**Descrição:** Antes de qualquer integração de API externa (Supabase, Vapi, future LLMs), verificar se
o provider tem opção Zero Data Retention para dados de saúde. CFM exige sigilo sobre conteúdo
de estudo médico se o conteúdo identificar o profissional por CRM ou especialidade.
**Por que ninguém propôs:** Músculo e Estrategista otimizaram por performance — não por conformidade.
**Ação:** Supabase tem ZDR? Verificar antes do build. Usar como argumento de venda para R3 conservador.

---

## VALIDAÇÃO DE ENTREGA

- [x] PARTE 1 auditou divergências com veredicto declarado
- [x] PARTE 2 aprovou/ajustou P-051 e P-052 com texto sugerido
- [x] PARTE 3 tem ponto que contradiz o que outros membros viram (Hard Fork Jurídico bloqueante)
- [x] PARTE 4 tem 5 ideias originais sobre melhoria de processo de nicho

---

*Auditoria recebida pelo Músculo · Processada e salva em 2026-05-19*
*P-053 e P-054 extraídos para o LEDGER baseados nos insights do Auditor*
