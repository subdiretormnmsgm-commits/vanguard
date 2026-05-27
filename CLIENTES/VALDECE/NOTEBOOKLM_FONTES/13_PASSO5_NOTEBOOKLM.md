# PASSO 5 — PARA O NOTEBOOKLM · Instancia: Projeto Valdece
# Template universal: PENTALATERAL_UNIVERSAL/OPERACAO/PASSO5_NOTEBOOKLM_TEMPLATE.md
# ORGANISMO VIVO: atualizar contexto e lista de fontes antes de CADA loop.
# Ultima atualizacao: 2026-05-20 · Loop 7 — V3 desbloqueado (contrato assinado) · skill esperada: valdece-v7.md

## ANTES DE ABRIR O NOTEBOOKLM — EXECUTAR OBRIGATORIAMENTE

1. Rodar no terminal:
   .\scripts\preparar_notebooklm_projeto.ps1 -cliente VALDECE
2. Confirmar que NOTEBOOKLM_FONTES\ foi atualizada (script lista os arquivos)
3. Abrir o NotebookLM — Wipe & Sync das fontes (apagar antigas antes de subir as novas)
4. Arrastar TUDO de NOTEBOOKLM_FONTES\ em ordem crescente de prefixo numérico
5. Colar o COMANDO CURTO abaixo no chat (não o arquivo inteiro — ele já está nas fontes)

> Sem o Wipe & Sync, o Auditor mistura contexto do Loop anterior com o atual.

### 💬 COMANDO CURTO — colar no chat do NotebookLM (Ctrl+V)

```
Auditor, você opera no Pentalateral IAH — 5 membros ativos: Diretor, Músculo, Estrategista, Auditor e Embaixador. O Embaixador (Claude Projects) acompanha o cliente Valdece em tempo real e suas hipóteses sobre comportamento e perfil estão no arquivo 14_MEMORIA_EMBAIXADOR.md — leia-o como filtro de realidade antes de validar qualquer sugestão. Leia o arquivo 13_PASSO5_NOTEBOOKLM.md das fontes carregadas detalhadamente e execute todas as instruções contidas nele. Leia também a DIRETRIZ do Estrategista no arquivo 12_DIRETRIZ_GEMINI_V8.txt e incorpore as solicitações do bloco [PARA O NOTEBOOKLM] ao gerar a Skill. Missão principal: gerar a Skill valdece-v7.md — o Músculo não inicia o Loop 7 sem ela.
```

> O arquivo já está nas fontes — não colar o conteúdo inteiro no chat.

---

## 📥 AO RECEBER O OUTPUT DO AUDITOR — ANTES DE SAIR DO NOTEBOOKLM (P-049)

O NotebookLM entrega 4 partes. Você vai copiar só a PARTE 3 para o arquivo skill.
As PARTES 1, 2 e 4 são **irrecuperáveis** depois que você fechar a sessão.

```
Antes de sair:
☐ Copiar PARTES 1 + 2 + 4 completas (tudo exceto a Skill)
☐ Salvar em: CLIENTES/VALDECE/HISTORICO/AUDITOR_LOOP_7_VALDECE.md
☐ Copiar PARTE 3 (Skill) para: .claude/skills/valdece-v7.md
☐ Rodar: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\valdece-v7.md"
```

> PARTES 1+2+4 não salvas = Músculo delibera sem [N-1 a N-5] + Auditoria = 20 inputs, não 25.

## FONTES A CARREGAR NO NOTEBOOKLM (nesta ordem — respeitar os prefixos numericos)

> Geradas pelo script preparar_notebooklm_projeto.ps1 -cliente VALDECE
> Arrastar em ordem crescente. Fatos do passado (01-11) ANTES das ideias novas (12-17).

  --- BASE Pentalateral (01-08) ---
  01_SKILL_PROTOCOLO_VANGUARD.md          -- ancora o Auditor nos padroes do Pentalateral
  02_MEMORANDO_PENTALATERAL_UNIVERSAL.md -- constituicao e valores
  03_MANUAL_DIRETOR.md                    -- como o Diretor opera
  04_INTELLIGENCE_LEDGER.md               -- principios ativos (P-001 a P-076+)
  05_PROCESSO_EVOLUTIVO_PENTALATERAL.md  -- como o loop funciona
  06_TEMPLATES_COMUNICACAO_PENTALATERAL.md -- formatos obrigatorios dos membros
  07_WIP_BOARD.txt                        -- estado atual de todos os projetos
  08_ANALISE_SOCIO_ATUAL.txt              -- visao de negocio mais recente

  --- PROJETO VALDECE (09-17) ---
  09_BRIEFING_DISCOVERY.txt               -- dor real do cliente + escopo original
  10_MEMORIA_RECENTE.md                   -- MEMORIA mais recente do projeto (estado tecnico)
  11_RELATORIO_EVOLUTIVO.md               -- relatorio evolutivo mais recente (SWOT + 5 ideias)
  12_DIRETRIZ_GEMINI_V8.txt               -- DIRETRIZ V7 do Estrategista ← substituir pelo arquivo real após receber do Gemini
  13_PASSO5_NOTEBOOKLM.md                 -- este arquivo (missao do Auditor) ← ja nas fontes
  14_MEMORIA_EMBAIXADOR.md                -- inteligencia acumulada do Embaixador sobre o Valdece
  16_ALERTA_CONFLITO.md                   -- gatilho de calibracao (se Auditor alucinar)
  17_VANGUARD_TIMELINE.md                 -- historico completo da Vanguard

  EXTRA (se existir): DIVIDAS_TECNICAS_AUDITOR.md -- carregar como fonte adicional
  quando houver entradas novas (gerado pelo session_close.ps1)

## AO RECEBER A SKILL DO AUDITOR

1. Salvar o conteudo em: .claude\skills\valdece-v7.md
2. Validar no terminal:
   .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\valdece-v7.md"
3. Se REJEITADO: retornar ao NotebookLM com o Gatilho de Calibracao:
   "Auditor, sua Skill foi rejeitada pelo gate de qualidade. Faltam: [listar blocos].
    Reprocesse com dados reais do projeto Valdece. Nao seja generico."
4. Se APROVADO: trazer a Skill ao Musculo junto com a DIRETRIZ do Gemini

---

## 🛡️ PROTOCOLO ANTI-ALUCINAÇÃO — ATIVE ANTES DE GERAR A SKILL

NotebookLM, o Conselho mapeou 4 deficiências nativas do seu modelo. Para que a Skill que você vai gerar seja de elite e não genérica, auto-aplique os seguintes contra-ataques ANTES de escrever qualquer bloco:

**Contra-ataque 1 — Regra do Nutricionista (vs. Amnésia de Contexto)**
Você não tem memória entre sessões. Tudo o que você sabe vem dos documentos carregados agora. Por isso: dê peso máximo à MEMORIA_V[X] e ao relatorio_evolutivo — eles representam o estado REAL do projeto. Se qualquer sugestão que você for fazer contradiz uma decisão documentada nesses arquivos, a decisão documentada prevalece. Declare explicitamente quando isso acontecer.

**Contra-ataque 2 — Rejeição de Análise Genérica (vs. Alucinação Estrutural P-007)**
Você está proibido de preencher os 4 blocos obrigatórios da Skill com afirmações genéricas. Cada bloco deve citar dados reais: nome do projeto, versão, decisão específica, princípio ativo do Ledger, ou padrão observado neste corpus de documentos. Se você não tiver dado real para preencher um bloco — declare "dados insuficientes para este bloco" em vez de inventar. Skill genérica é pior que Skill incompleta.

**Contra-ataque 3 — Tensão Ativa (vs. Síndrome do Yes-Man)**
Sua função não é validar a DIRETRIZ do Gemini — é auditá-la. Para cada sugestão da DIRETRIZ, pergunte: "Isso realmente resolve a dor de 2 horas de busca do Valdece ou é perfumaria tecnológica?" Se você identificar que o Gemini está propondo algo que viola o prazo de 5 dias, o orçamento do cliente, ou qualquer princípio do Ledger — diga. Com evidência. Seja o "chato" da sala.

**Contra-ataque 4 — Filtro de Recência (vs. Efeito Lost-in-the-Middle)**
Ao cruzar os documentos, você pode dar peso igual a uma regra antiga da V1 e a uma decisão nova do Loop 2. Não faça isso. Aplique o Filtro de Recência: documentos mais recentes têm peso maior. A DIRETRIZ V3 prevalece sobre a V1. O Princípio P-013 prevalece sobre qualquer padrão anterior que ele contradiga. Quando houver conflito entre documentos, sinalize qual prevalece e por quê.

**Contra-ataque 5 — Advogado do Diabo (vs. Complacência — P-022)**
Instituted by Eduardo directly. Identifique o cenário mais provável em que a decisão do Diretor falha nos próximos 90 dias, baseado no histórico real dos projetos carregados. Não valide — objete com base em precedentes. Pergunte: "Onde está o ponto cego do Diretor nesta decisão?"
Para Valdece especificamente: o contrato está ausente. O onboarding presencial é segunda-feira. Quais os riscos reais de uma entrega sem formalização de escopo?

**Intervenções do Diretor neste ciclo (P-021 — registrar como eventos canônicos):**
[INTERVENÇÃO-Eduardo-2026-05-16] Necessidade do contrato formal antes de entrega Camada 1 (P-023)
[INTERVENÇÃO-Eduardo-2026-05-16] NotebookLM como advogado do processo (P-022)
[INTERVENÇÃO-Eduardo-2026-05-16] Manutenção Soberana como pré-requisito, não upsell
[INTERVENÇÃO-Eduardo-2026-05-19] P-041 — Discovery V3 com 9 perguntas; Cena de Sucesso é obrigatória
[INTERVENÇÃO-Eduardo-2026-05-19] P-042 — Gate semântico = "Protocolo de Garantia Soberana"; apresentar antes do contrato
[INTERVENÇÃO-Eduardo-2026-05-19] P-043 — DFD obrigatório antes de replicar busca semântica em novo nicho
[INTERVENÇÃO-Eduardo-2026-05-19] P-044 — Releitura da cena de sucesso antes de cada dia de build
[INTERVENÇÃO-Eduardo-2026-05-19] Próximo nicho: Contabilidade (pós-Ingrid; DFD antes da proposta)
[INTERVENÇÃO-Eduardo-2026-05-19] RLS exposta = P1 pós-contrato; NÃO mencionar ao cliente antes da assinatura
[INTERVENÇÃO-Eduardo-2026-05-19] Garantia Zero Churn: teste 30 dias interno; NÃO incluir no contrato V1
[INTERVENÇÃO-Eduardo-2026-05-19] P-046 — Contrato formaliza ciclo de evolução, não produto finalizado. Feedback durante teste = sinal de comprometimento. Não tratar como bloqueante.

**Ordem de leitura obrigatória (não inverter):**
MEMORIA_V[X] → relatorio_evolutivo_V[X] → DIRETRIZ do Gemini → este PASSO5
Fatos do passado carregam antes da nova ideia. Sempre.

**Integração obrigatória com o Estrategista:**
A DIRETRIZ do Gemini (arquivo `12_DIRETRIZ_GEMINI_V8.txt`) contém um bloco `[PARA O NOTEBOOKLM]`
com solicitações específicas do Estrategista sobre o que a Skill deve cobrir.
Auditor: leia esse bloco e incorpore as solicitações — elas são complementares a este PASSO5, não redundantes.
Conflito entre DIRETRIZ e PASSO5 → PASSO5 prevalece (é mais recente e específico).

---

NotebookLM, você atua como Sócio Consultor do Pentalateral IAH — não como arquivo passivo.

Você tem memória de todos os projetos anteriores da Vanguard. Você vê o que o Gemini e o Músculo não veem porque você conhece o histórico completo. Sua função agora é gerar a Skill `valdece-v7.md` que o Músculo vai executar antes de deliberar sobre o Loop 7 do projeto Valdece.

CONTEXTO ATUAL (Loop 7 — V3 desbloqueado · 2026-05-20):
Ferramenta de busca semântica de jurisprudências STF/STJ para advogado criminalista (Valdece).
Stack: Vanilla JS + Supabase pgvector + gemini-embedding-001 (768 dims). Loop 6 encerrado.
Corpus: 61 acórdãos reais · 22 temas · threshold 0.67 (Precisa) / 0.45 (Ampla) · top 3.
GATE LOOP 6 VERDE — Contrato R$5.000 ASSINADO · Deploy live: https://toga-digital-valdece.netlify.app
V3 desbloqueada: schema migration (data_dje, repercussao_geral, recurso_repetitivo, turma) + re-ingestão.

ENTREGAS DO LOOP 6 (concluídas e em produção):
- Ementa completa no card (threshold 600 chars, sem truncamento forçado)
- Badge UF extraído do numero_acordao (ex: HC 512.290/RJ → badge "RJ")
- Boost monocrático: +0.15 similarity para HC/liminar/monocrática
- HC 512.290/RJ corrigido no Supabase (dados e embedding)
- Contrato formal assinado — ciclo de evolução V3 formalizado

MISSÃO DO LOOP 7 — V3 (schema migration + corpus expandido):
`data_dje` (date), `repercussao_geral` (boolean), `recurso_repetitivo` (boolean), `turma` (text)
Esses campos foram pedidos por Valdece nos áudios. V3 exige migration segura + re-ingestão de todos os 61 acórdãos.
P-046 ativo: feedback pós-contrato = sinal de comprometimento, não bloqueante.

PRINCÍPIOS ATIVOS (P-041 a P-046):
- P-041: Cena de Sucesso documentada é obrigatória. Demo aprovada = reproduz a cena.
- P-042: Gate semântico documentado = "Protocolo de Garantia Soberana".
- P-043: DFD obrigatório antes de novo nicho semântico.
- P-044: Músculo relê a cena antes de cada dia de build.
- P-046: Contrato formaliza o ciclo de evolução — não o produto finalizado.

Cena de sucesso (P-041 — ÂNCORA):
"Estou num julgamento, o promotor cita um precedente que não conheço. Abro o Toga Digital,
 digito o nome do crime, e em 10 segundos tenho o acórdão com mais peso — citação pronta em ABNT."

Skill esperada: `valdece-v7.md`

COMO DESCREVER A DIRETRIZ DO GEMINI PARA O AUDITOR REAGIR CRITICAMENTE:
"Auditor, o Estrategista gerou a DIRETRIZ V7 para o projeto Valdece (Loop 7 — V3).
Sua missão: auditar esta DIRETRIZ cruzando com o histórico real das fontes.
Identifique: (1) o que contradiz princípios ativos do LEDGER,
(2) o que já falhou em projetos anteriores similares,
(3) o que o Estrategista está ignorando por otimismo ou falta de contexto técnico.
Não valide por momentum. Discorde quando tiver evidência histórica."

## ⚠️ DEFICIÊNCIAS DO MÚSCULO — ESTRUTURE A SKILL PARA COMPENSÁ-LAS

Auditor, ao gerar a Skill, leve em conta que o Músculo tem 5 deficiências nativas. A Skill deve ser escrita de forma a combater ativamente essas falhas — não apenas auditar o projeto:

**Deficiência 1 — Amnésia de Sessão:** No bloco de Contexto do Projeto, liste os princípios ativos do LEDGER que são obrigatórios nesta sessão. O Músculo deve encontrar esses princípios na Skill — não precisa lembrar de buscá-los.

**Deficiência 2 — Momentum de Execução:** No bloco de Sequência de Build, inclua os gates de verificação obrigatórios entre cada dia. O Músculo não deve avançar do Dia 4 para o Dia 5 sem ter confirmado o output real do Dia 4. Defina esse output explicitamente.

**Deficiência 3 — Otimismo de Estimativa:** No bloco de Alertas Críticos, inclua estimativas realistas de tempo para os módulos mais complexos desta entrega (baseado no histórico de builds similares que você conhece). Se o histórico mostra que um módulo similar levou 6 horas, diga isso.

**Deficiência 4 — Escopo Silencioso:** No bloco "O que não construir nesta entrega", seja tão específico quanto no bloco de prioridades. Liste por nome as features que o Músculo pode ser tentado a adicionar e que estão fora do escopo aprovado.

**Deficiência 5 — Drift de Formato:** Na seção de Perspectiva do Sócio, inclua uma instrução explícita ao Músculo: "Ao deliberar sobre cada prioridade, use os 7 pontos: Certo → Diverge → Decisão → Enhancement → Custo → Impacto → Ação. Não resumir."

---

Gere a Skill para o Músculo em quatro partes obrigatórias, nesta ordem:

**PARTE 1 — AUDITORIA DE COERÊNCIA**
A DIRETRIZ do Gemini contradiz algo que foi construído antes neste projeto ou em projetos anteriores? Há módulos que o Gemini propõe mas que já existem? Há riscos que a DIRETRIZ ignora e que o histórico mostra como recorrentes em projetos similares?

**PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR**
Com base em tudo que você conhece de projetos anteriores da Vanguard — o que sistematicamente funciona em Legal Tech ou busca semântica? O que sistematicamente falha? O que este projeto tem de diferente? O que o Gemini e o Músculo não estão vendo? Cite projetos ou padrões do histórico.

**PARTE 3 — A SKILL (copiável para `.claude/skills/valdece-v7.md`)**
⚠️ GATE OBRIGATÓRIO: a Skill DEVE conter estes 4 títulos de seção EXATOS (sem acentos).
O script skill_parser_gate.ps1 verifica esses textos — Skill sem eles = REJEITADA automaticamente:

```
## [AUDITORIA DE COERENCIA]
## [CONEXAO HISTORICA]
## [PADRAO DE SUCESSO/FALHA]
## [PERSPECTIVA DO SOCIO]
```

Conteúdo obrigatório por seção:
- `[AUDITORIA DE COERENCIA]`  — alertas VETO do LEDGER, princípios P-041 a P-046 ativos
- `[CONEXAO HISTORICA]`       — o que os Loops 1-6 provaram (decisões fixadas, stack, gates aprovados)
- `[PADRAO DE SUCESSO/FALHA]` — o que funcionou + o que falhou + sequência de build V3 com gates verificáveis
- `[PERSPECTIVA DO SOCIO]`    — o que o Auditor vê que os outros não veem + discordância fundamentada

**PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR [N-1 a N-5]**
Suas 5 ideias — não as do Gemini nem as do Músculo. Fundamentadas no histórico completo. O que nenhum dos outros membros está vendo.

Não resuma. Não seja genérico. Se citar padrão histórico, cite de qual projeto ele vem. O Músculo vai ler isso antes de construir — cada linha impacta o que será entregue ao Valdece.

