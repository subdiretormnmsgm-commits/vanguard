# PASSO 5 — PARA O NOTEBOOKLM · Instancia: Projeto Valdece
# Template universal: QUADRILATERAL_UNIVERSAL/OPERACAO/PASSO5_NOTEBOOKLM_TEMPLATE.md
# ORGANISMO VIVO: atualizar contexto e lista de fontes antes de CADA loop.
# Ultima atualizacao: 2026-05-19 · Loop 5 — pré-demo ao vivo · skill esperada: valdece-v5.md

## ANTES DE ABRIR O NOTEBOOKLM — EXECUTAR OBRIGATORIAMENTE

1. Rodar no terminal:
   .\scripts\preparar_notebooklm_projeto.ps1 -cliente VALDECE
2. Confirmar que NOTEBOOKLM_FONTES\ foi atualizada (script lista os arquivos)
3. Abrir o NotebookLM e carregar TODOS os arquivos da pasta NOTEBOOKLM_FONTES\
   IMPORTANTE: arrastar em ordem crescente de prefixo numérico

## FONTES A CARREGAR NO NOTEBOOKLM (nesta ordem — respeitar os prefixos numericos)

  --- BASE QUADRILATERAL (01-08) ---
  01_SKILL_PROTOCOLO_VANGUARD.txt         -- ancora o Auditor nos padroes do Quadrilateral
  02_MEMORANDO_QUADRILATERAL_UNIVERSAL.txt -- constituicao e valores
  03_MANUAL_DIRETOR.txt                   -- como o Diretor opera
  04_INTELLIGENCE_LEDGER.txt              -- principios ativos (P-001 a P-058)
  05_MEMORIA_V24.txt                      -- contexto historico universal (ciclos anteriores)
  06_RELATORIO_V24.txt                    -- historico evolutivo universal
  07_WIP_BOARD.txt                        -- estado atual de todos os projetos
  08_ANALISE_SOCIO_ATUAL.txt              -- visao de negocio mais recente

  --- PROJETO VALDECE (11+) ---
  11_BRIEFING_DISCOVERY_VALDECE.txt       -- dor real do cliente + escopo original
  14_ALERTA_CONFLITO_PROTOCOLO.txt        -- gatilho de calibracao se necessario
  15_VANGUARD_TIMELINE.txt                -- historico completo da Vanguard
  16_MEMORIA_EMBAIXADOR.txt               -- inteligencia acumulada do Embaixador (atualizada 2026-05-19)
  17_DIRETRIZ_GEMINI_V3.txt               -- ultima DIRETRIZ do Estrategista
  19_MEMORIA_V1_VALDECE.txt               -- estado tecnico e dividas do projeto
  20_RELATORIO_V1_VALDECE.txt             -- SWOT + 5 ideias do ciclo anterior

  EXTRA (se existir): DIVIDAS_TECNICAS_AUDITOR.md -- carregar como fonte adicional
  quando houver entradas novas (gerado pelo session_close.ps1)

## AO RECEBER A SKILL DO AUDITOR

1. Salvar o conteudo em: .claude\skills\valdece-v5.md
2. Validar no terminal:
   .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\valdece-v5.md"
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

**Ordem de leitura obrigatória (não inverter):**
MEMORIA_V[X] → relatorio_evolutivo_V[X] → DIRETRIZ do Gemini → este COMANDO
Fatos do passado carregam antes da nova ideia. Sempre.

---

NotebookLM, você atua como Sócio Consultor do Pentalateral IAH — não como arquivo passivo.

Você tem memória de todos os projetos anteriores da Vanguard. Você vê o que o Gemini e o Músculo não veem porque você conhece o histórico completo. Sua função agora é gerar a Skill `valdece-v5.md` que o Músculo vai executar antes de deliberar sobre a demo ao vivo do projeto Valdece.

CONTEXTO ATUAL (Loop 5 — pós loop evolutivo 2026-05-19):
Ferramenta de busca semântica de jurisprudências STF/STJ para advogado criminalista (Valdece).
Stack: Vanilla JS + Supabase pgvector + gemini-embedding-001 (768 dims). 5 dias de build concluídos.
Corpus: 61 acórdãos reais · 22 temas · threshold 0.67 · top 3 · GATE P-038 APROVADO (12/12 verde).
Deploy live: https://toga-digital-valdece.netlify.app
Presencial 2026-05-19 realizado — Sovereign Playbook apresentado — credenciais obtidas.
Demo real: PENDENTE — Valdece ainda não testou no sistema DELE. Janela de encantamento INTACTA.
Contrato R$5.000 pendente — aguarda demo + encantamento + assinatura.

NOVOS PRINCÍPIOS DESTE LOOP (P-041 a P-044) — auditar coerência com DIRETRIZ:
- P-041: Cena de Sucesso documentada é obrigatória. Demo aprovada = reproduz a cena.
- P-042: Gate semântico documentado = "Protocolo de Garantia Soberana" (apresentar antes do contrato).
- P-043: DFD obrigatório antes de novo nicho semântico.
- P-044: Músculo relê a cena antes de cada dia de build.

Cena de sucesso (P-041 — ÂNCORA):
"Estou num julgamento, o promotor cita um precedente que não conheço. Abro o Toga Digital,
 digito o nome do crime, e em 10 segundos tenho o acórdão com mais peso — citação pronta em ABNT."
Gate da demo: Valdece diz "é isso" em <10s no sistema DELE — não no computador do Eduardo.

Skill esperada: `valdece-v5.md`

COMO DESCREVER A DIRETRIZ DO GEMINI PARA O AUDITOR REAGIR CRITICAMENTE:
"Auditor, o Estrategista gerou a DIRETRIZ V3 para o projeto Valdece (Dia 5).
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

Preciso que você gere a Skill para o Músculo em quatro partes, nesta ordem:

Primeiro: auditoria de coerência. A DIRETRIZ do Gemini contradiz alguma coisa que foi construído antes neste projeto ou em projetos anteriores? Há módulos que o Gemini propõe mas que já existem? Há riscos que a DIRETRIZ ignora e que o histórico mostra como recorrentes em projetos similares?

Segundo: perspectiva do sócio consultor. Com base em tudo que você conhece de projetos anteriores da Vanguard — o que sistematicamente funciona em projetos de Legal Tech ou busca semântica? O que sistematicamente falha? O que este projeto tem de diferente que pode mudar o padrão? O que o Gemini e o Músculo não estão vendo? Seja específico — cite projetos ou padrões do histórico quando puder.

Terceiro: a Skill propriamente dita. Escreva em formato copiável direto para .claude/skills/valdece-v5.md com os seguintes blocos obrigatórios: contexto do projeto, conexão histórica com localização exata do que reutilizar, padrão de sucesso, padrão de falha, perspectiva do sócio, sequência de build recomendada para os Dias 3-4-5, alertas críticos com severidade, o que não construir nesta entrega, e o que deve ser promovido ao SKILL_PROTOCOLO_VANGUARD como padrão universal.

Quarto: suas 5 ideias disruptivas como Auditor. Não as ideias do Gemini nem as do Músculo — as suas, fundamentadas no que você vê no histórico completo. O que nenhum dos outros membros está vendo.

Não resuma. Não seja genérico. Se citar padrão histórico, cite de qual projeto ele vem. O Músculo vai ler isso antes de construir — cada linha impacta o que será entregue ao Valdece.
