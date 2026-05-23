ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-05-20 13:33
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
fc15595 @ docs(valdece): MEMORIA_V6 + relatorio_evolutivo_V6 — P-045 desbloqueado
e22efb5 @ docs(p033): sync_vanguard_docs mandatorio em CLAUDE.md + 3 duplicados removidos
c05fbf2 sync(p033): atualizar_notebooklm_base — 184 arquivos propagados para projetos ativos

================================================================================

## INTELLIGENCE LEDGER -- PRINCIPIOS ATIVOS
# INTELLIGENCE LEDGER — Pentalateral IAH
**Organismo Vivo — atualizado a cada sessão pelo Músculo**
**Criado:** 2026-05-12 | **Compactação:** mensal (arquivar entradas > 90 dias)

> Este arquivo é lido pelo Músculo no INÍCIO de cada sessão.
> Cada princípio aqui vale mais do que qualquer código — é o que torna o sistema impossível de copiar.

---

## PROTOCOLO DE LEITURA — INÍCIO DE SESSÃO

Antes de qualquer deliberação, o Músculo executa:

```
1. Ler PRINCÍPIOS ATIVOS — há algum que se aplica à sessão atual?
2. Ler últimas 3 entradas do LOG DE SESSÕES — há fricção recente relevante?
3. Skill-Drift check — a direção desta sessão alinha com os princípios?
4. Se CONSELHO_SESSAO_[date].md existir na raiz → ler antes de deliberar
```

---

## PRINCÍPIOS ATIVOS

Princípios extraídos de fricções reais. Cada um tem evidência — não é teoria.

---

### [P-001] Claude Code ≠ Daemon Autônomo
**Descoberto:** 2026-05-12 | **Sessão:** V24 Setup
**Evidência:** Estrategista propôs que Claude Code "monitore pastas e inicie codificação automaticamente". Físicamente impossível — Claude Code exige sessão humana. Arquitetura correta usa Claude API via n8n.
**Princípio:** Toda proposta de "execução autônoma" deve especificar Claude API + n8n, nunca Claude Code como daemon.
**Aplica-se a:** qualquer DIRETRIZ que mencione automação, monitoramento contínuo, ou "Claude que age sozinho".

---

### [P-002] VEREDITO BINÁRIO não é burocracia universal
**Descoberto:** 2026-05-12 | **Sessão:** V24 Setup
**Evidência:** Protocolo criado para decisões com divergência real. Risco de virar overhead em decisões óbvias.
**Princípio:** Emitir VEREDITO BINÁRIO apenas quando há divergência técnica real entre duas abordagens. Decisões com clareza >90% → Plano de Build direto.
**Aplica-se a:** toda sessão de deliberação técnica.

---

### [P-003] Scraping de terceiros é dependência, não ativo
**Descoberto:** 2026-05-12 | **Sessão:** Análise SEDES-DF (descartada)
**Evidência:** Proposta de scraping QConcursos viola ToS e cria dependência de terceiro. IP some se API muda.
**Princípio:** Nunca construir sobre dados de terceiros sem acordo formal. Ativo de IP = dados gerados pelo nosso sistema.
**Aplica-se a:** qualquer proposta envolvendo scraping, integração não-oficial, ou dados de plataformas externas.

---

### [P-004] O primeiro cliente não vem do site — vem de uma ligação
**Descoberto:** 2026-05-12 | **Sessão:** Discussão site V24
**Evidência:** GUT do site reformulado = 12. GUT de prospectar.ps1 esta semana = 125. O site é importante, mas não é o caminho para o primeiro real.
**Princípio:** Melhorias de posicionamento (site, design) têm GUT baixo enquanto há 0 clientes. Só sobem na prioridade após o primeiro MRR confirmado.
**Aplica-se a:** qualquer proposta de redesign, branding, ou melhorias de funil antes do primeiro cliente.

---

### [P-006] Precificação de serviço deve ser calculada por ROI do cliente, não por feeling
**Descoberto:** 2026-05-12 | **Sessão:** PROJETO_001 — Valdece
**Evidência:** Primeiro cliente real (Valdece, advogado penal) propôs R$5.000 pela ferramenta. Cálculo GUT de aceitar vs. renegociar = 75 (G:5 · U:5 · T:3). ROI calculado para o cliente: ferramenta economiza ~20h/mês × R$200/h = R$4.000/mês de dívida de tempo. Payback em 1,25 meses. Valor justo de mercado: R$12.000–18.000.
**Princípio:** Antes de aceitar qualquer preço de cliente, rodar o algoritmo: (horas_perdidas × valor_hora_cliente) × 12 = valor_anual_gerado. Preço justo = 10–25% do valor anual gerado. Se o cliente propôs abaixo disso, aceitar apenas com contrapartida (% de MRR, cláusula de referência, ou direito de case público).
**Aplica-se a:** toda proposta de precificação de projeto cliente.

---

### [P-005] Inteligência acumulada por sessão, não por versão
**Descoberto:** 2026-05-12 | **Sessão:** V24 Intelligence Engine
**Evidência:** 23 versões aprenderam, mas o aprendizado ficou preso em MEMORIAs que descrevem "o que foi feito", não "o princípio descoberto". Lag de semanas entre fricção e princípio.
**Princípio:** Todo ALERTA emitido, toda fricção, todo override do Diretor → capturado imediatamente neste LEDGER. O princípio é extraído na mesma sessão, não na próxima versão.
**Aplica-se a:** toda sessão do Pentalateral.

---

### [P-009] Número de loops evolutivos é proporcional à amplitude do projeto
**Descoberto:** 2026-05-13 | **Sessão:** PROJ-001 — Valdece / Calibração do processo
**Evidência:** Diretor identificou que loops em excesso num projeto pequeno geram ruído, não inteligência. Loops insuficientes num projeto grande geram deriva sem correção de rota.
**Princípio:** A cadência do loop Músculo→Gemini→NotebookLM→Músculo é calibrada pela Camada do projeto, não pelo calendário. Cada loop consome tempo do Diretor e dos membros — deve acontecer quando há output real suficiente para deliberar.

| Camada | Escopo | Prazo | Loops totais | Cadência |
|---|---|---|---|---|
| 1 — MVP | Protótipo funcional | 1–5 dias | 2–3 loops | Início + meio do build + fechamento |
| 2 — Produto | Produto completo | 1–3 semanas | 4–6 loops | 1 loop por semana de build |
| 3 — Plataforma | IA, dados, automação | 2–6 semanas | 6–10 loops | 1 loop por sprint (3–5 dias) |
| 4 — Ecossistema | Multi-tenant, marketplace | 1–3 meses | 10–16 loops | 2 loops por semana |
| 5 — Monopólio | Ativo de setor | 3–6 meses | 20–30 loops | Loop semanal fixo |

**Regra de ouro:** Loop acontece quando há output real para deliberar — gate passado, módulo entregue, decisão de arquitetura tomada, cliente reagindo. Nunca por calendário fixo sem evidência nova.
**Aplica-se a:** todo projeto gerido pelo Pentalateral. Definir o número de loops no Passo 7 (aprovação do plano).

---

### [P-008] Primeiro cliente com produto soberano vale mais que MRR
**Descoberto:** 2026-05-13 | **Sessão:** PROJ-001 — Valdece / Decisão Opção A
**Evidência:** Valdece pediu sistema sem mensalidade que se atualize sozinho. Diretor escolheu Opção A: produto na infra do cliente, corpus auto-atualiza por R$0,22/mês, zero vínculo. Raciocínio: "Com o melhor sistema possível, ele será nossa propaganda."
**Princípio:** O primeiro cliente de um nicho não é fonte de MRR — é canal de distribuição. Um advogado satisfeito em uma sala da OAB fala com 50 colegas. Entregar soberania total elimina objeção de churn e transforma o cliente em vendedor ativo. Cada indicação = R$3.000–5.000 de novo projeto com o mesmo codebase. MRR vem na V2, quando o cliente já está dependente e pede mais.
**Aplica-se a:** qualquer primeiro cliente de nicho com comunidade profissional densa (advogados, médicos, contadores, engenheiros).

---

### [P-010] Verificar em cada etapa antes de avançar
**Descoberto:** 2026-05-13 | **Sessão:** PROJ-001 — Valdece / Padrão de execução
**Evidência:** Diretor identificou que o Gate Semântico do Dia 3 não é apenas uma validação técnica — é a expressão de um padrão universal: nenhuma etapa avança por momentum, só por verificação explícita. "A cada etapa, temos que sempre verificar."
**Princípio:** Cada etapa do build tem um checkpoint obrigatório antes da próxima começar. Verificar não é "parece que funciona" — é executar e ver o output real.

| Camada | Checkpoint obrigatório |
|---|---|
| Dia → próximo dia | Gate: output funcionando ou explicação de por que não |
| Módulo → integração | Teste isolado antes de conectar ao sistema |
| Build → commit | Code review próprio do Músculo |
| Entrega → cliente | Teste com dado real do cliente, não dado de mock |
| Iteração → loop | MEMORIA + relatorio_evolutivo gerados e revisados |
| Proposta → execução | Veredito explícito do Diretor — nunca iniciar sem aprovação |

**Por que importa:** Avançar por assumição é o padrão de falha mais comum em build rápido. Uma UI bonita sobre corpus ruim é fachada. Um commit sem review é débito técnico disfarçado de velocidade. O Gate valida — o produto entrega.
**Aplica-se a:** todo projeto do Pentalateral, toda etapa de build, toda entrega a cliente.

---
... [truncado -- ver arquivo completo]

================================================================================

## WIP BOARD -- ESTADO DOS PROJETOS
{
    "atualizado_em":  "2026-05-19",
    "wip_limits":  {
                       "build":  2,
                       "check":  1
                   },
    "board":  {
                  "discovery":  [

                                ],
                  "build":  [
                                {
                                    "id":  "PROJ-002",
                                    "cliente":  "Ingrid",
                                    "projeto":  "Ferramenta de Estudo — Concurso Sedes-DF",
                                    "area":  "EdTech · Concursos Públicos",
                                    "camada":  "2 (Produto — 15 dias)",
                                    "valor_fechado":  0,
                                    "tipo":  "Projeto Piloto Interno — Validação V25",
                                    "deadline":  "2026-05-30",
                                    "prova_cliente":  "2026-09-06",
                                    "status":  "VEREDITO APROVADO — build liberado. Iniciando Dia 1.",
                                    "cargo":  "TDAS – Técnico em Desenvolvimento e Assistência Social – Especialidade: Técnico Administrativo (Cargo 202)",
                                    "banca":  "Instituto Quadrix",
                                    "stack":  "PWA + Supabase + Claude API",
                                    "loop_atual":  "Loop #2 — Build (Dias 3-5)",
                                    "diretriz_gemini_v1":  true,
                                    "skill_notebooklm_v1":  true,
                                    "deliberacao_musculo":  true,
                                    "veredito_diretor":  true,
                                    "veredito_data":  "2026-05-15",
                                    "edital_sedes_json":  true,
                                    "build_iniciado_em":  "2026-05-15",
                                    "dias_completos":  [
                                                           "dia1_schema_edge",
                                                           "dia2_gate_questoes",
                                                           "dia3_5_feed_sm2_pwa",
                                                           "dia6_8_tutor_fallback"
                                                       ],
                                    "plano_build":  {
                                                        "dia1_2":  "Schema multi-tenant + Edge Function + Magico de Oz Gate CLI + playbook distratores",
                                                        "dia3_5":  "Feed Diario (70/30 Peso 2) + Spaced Repetition SM-2 + Pilula JSON + Explicacao direta ao errar + Contador header",
                                                        "dia6_8":  "Interface questoes + Tutor Socratico Haiku (Peso 2) + Caching + Fallback Fadiga 70%",
                                                        "dia9_11":  "Heatmap urgencia temporal + Micro-Simulado diario + Modo Sedes-DF domingos",
                                                        "dia12_13":  "Contador Pontos Ponderados + Notificacao push domingo",
                                                        "dia14_15":  "OFFBOARDING_RUNBOOK + SaaS Readiness Audit + P-013 soberania"
                                                    },
                                    "decisoes_fixadas":  {
                                                             "fonte_questoes":  "Claude API — sem scraping (P-003)",
                                                             "auth":  "single-user — sem login complexo",
                                                             "cache":  "gerar lote 50 quando \u003c 30 questoes disponiveis",
                                                             "proporcao_feed":  "70% Peso 2 / 30% Peso 1",
                                                             "modelos_api":  "Haiku (gerais + dicas socraticas) / Sonnet (especificos)",
                                                             "burn_rate":  "BURN_RATE_DAILY_LIMIT_USD=5.00",
                                                             "fallback":  "trigger 70% da cota diaria",
                                                             "spaced_repetition":  "SM-2 intervalo variavel",
                                                             "push_vs_email":  "push no MVP / email com tracking no Loop 2",
                                                             "comentario_erro":  "Opcao A (Dias 3-5): explicacao direta do banco + Opcao B (Dias 6-8): Tutor Socratico Haiku"
                                                         },
                                    "gates_bloqueantes":  {
                                                              "dia2":  "10 questoes avaliadas por Eduardo — rubrica media \u003e= 4/5",
                                                              "dia5":  "Feed exibe plano correto 7 dias com proporcao correta",
                                                              "dia8":  "Ingrid responde 10 questoes — progresso salvo — fallback testado",
                                                              "dia11":  "Heatmap correto + simulado domingo completo",
                                                              "dia15":  "Ingrid com acesso admin proprio Supabase"
                                                          },
                                    "precificacao":  {
                                                         "valor_gerado_candidato":  "R$ 9.750 (tempo + probabilidade aprovacao)",
                                                         "servico_personalizado":  "R$ 2.500 por candidato externo",
                                                         "licenca_acesso_saas":  "R$ 197 por ciclo do concurso",
                                                         "saas_b2c_mrr":  "R$ 97/mes x 4 meses = R$ 388 por usuario",
                                                         "meta_saas":  "500 usuarios = R$ 194.000 no ciclo Sedes-DF 2026"
                                                     },
                                    "loops_programados":  [
                                                              {
                                                                  "loop":  1,
                                                                  "nome":  "Kickoff",
                                                                  "gate":  "dia2_questoes",
                                                                  "notebooklm_wipe":  true,
                                                                  "status":  "concluido"
... [truncado -- ver arquivo completo]

================================================================================

## MEMORIA MAIS RECENTE
# MEMORIA_V6_VALDECE — Estado Técnico Completo · Loop 6
> Gerado pelo Músculo ao fechar Loop 6 · 2026-05-20
> Fonte: commits 2b72b9b → 250ff9c + MEMORIA_EMBAIXADOR Loop 6 + WIP_BOARD.json
> Leitura obrigatória antes de iniciar Loop 7

---

## 1. O QUE FOI LOOP 6

**Contexto de entrada:** Loop 5 encerrou com 61 acórdãos no corpus, Gate P-038 aprovado (12/12 queries), deploy netlify ativo, contrato pendente de assinatura, 5 áudios de feedback enviados pelo Valdece.

**Objetivo do Loop 6:** Processar os feedbacks dos áudios + fechar o contrato presencialmente + desbloquear V3.

---

## 2. O QUE FOI ENTREGUE

| Feature | Commit | Status |
|---|---|---|
| URL @NUM STJ corrigida + ementa completa no Copiar ABNT | 2b72b9b | ✅ |
| 9 áudios Valdece convertidos OGG→FLAC para NotebookLM | 4342064 | ✅ |
| HC 512.290/RJ corrigido no Supabase (ementa errada → certa + re-embedding) | 1369689 | ✅ |
| Ementa completa (600 chars vs 280 anterior) | 9709649 | ✅ |
| Badge UF via regex (numero_acordao → "RJ", "SP", etc.) | 9709649 | ✅ |
| Boost monocrático: +0.15 similarity para HC/liminar | 9709649 | ✅ |
| Chave Gemini substituída (quota esgotada — 1ª ocorrência) | 9ab28a6 | ✅ |
| Contrato assinado presencialmente R$5k · Gate V3 DESBLOQUEADO | 250ff9c | ✅ |

**Resultado comercial do Loop 6:** Contrato assinado. R$5.000 fixo. Sem mensalidade. Billing do cliente direto na API dele (~R$1,20/mês). Hypercare 30 dias inclusos.

---

## 3. ESTADO TÉCNICO FINAL — LOOP 6

### Supabase
| Campo | Valor |
|---|---|
| Projeto | hqqxzecftkvtrlpkhvnc (Vanguard — migração pendente para conta Valdece) |
| Schema | `vector(768)` + índice HNSW + `SECURITY DEFINER` |
| Corpus | **61 acórdãos reais STF/STJ · 22 temas** |
| Temas cobertos | HC · preventiva · tráfico · dosimetria · nulidade · homicídio · estupro · violência-doméstica · execução-penal · prescrição · legítima-defesa · org-criminosa · porte-arma · corrupção · concurso-crimes · sursis · estelionato · extorsão · ECA · lesão-corporal · tentativa · tráfico-internacional |
| Função RPC | `search_documents(query_embedding, match_count, similarity_threshold)` |

### Modelo de Embedding
| Campo | Valor |
|---|---|
| Modelo | `gemini-embedding-001` |
| Dimensionalidade | 768 |
| Task type | `RETRIEVAL_QUERY` (busca) / `RETRIEVAL_DOCUMENT` (ingestão) |
| API endpoint | `generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent` |
| Chave | Exposta no frontend (HV-1 — fix definitivo = Edge Function no V3) |

### Frontend
| Campo | Valor |
|---|---|
| Deploy | https://toga-digital-valdece.netlify.app |
| Threshold Precisa | 0.67 (Busca Precisa) |
| Threshold Ampla | 0.45 (Busca Ampla) |
| Top resultados | 3 |
| Ementa | Completa (600 chars) |
| Badge UF | Regex via numero_acordao |
| Boost monocrático | +0.15 similarity para HC/liminar |
| Modo Tático | Ativo (toggle UI) |

### Performance Gate P-038
| Métrica | Valor |
|---|---|
| Queries aprovadas | 12/12 (100%) |
| Similaridade range | 0.67 – 0.818 |
| Latência média | 2.1 – 3.4s |
| Similaridade mínima | 0.67 (todas acima do threshold Precisa) |

---

## 4. O QUE NÃO ESTÁ PRONTO (V3 — BLOQUEADO ATÉ CONTRATO)

Estes itens foram identificados pelos áudios do Valdece e bloqueados por P-023 (scope creep) até contrato assinado. **Agora desbloqueados:**

| Campo V3 | Tipo | Status |
|---|---|---|
| `data_dje` | DATE | Pendente — ALTER TABLE |
| `repercussao_geral` | BOOLEAN | Pendente — ALTER TABLE |
| `recurso_repetitivo` | BOOLEAN | Pendente — ALTER TABLE |
| `turma` | TEXT | Pendente — ALTER TABLE |

**Blueprint pronto:** ALTER TABLE → ingest dry-run (61 acórdãos re-processados) → badges vinculantes no frontend → ABNT atualizado com data DJE.

**Gate V3:** Valdece identifica badge "VINCULANTE" sem explicação de Eduardo — sozinho, intuitivamente.

---

## 5. MIGRAÇÃO DE INFRAESTRUTURA (PENDENTE)

| Item | Status |
|---|---|
| Supabase | Vanguard → conta Valdece (sa-east-1) — P-038: gate de teste obrigatório antes da migração |
| Gemini API Key | Eduardo → conta Google do Valdece (billing ativo no Cloud Console) |
| Netlify | Redeploy com nova chave Valdece após migração |

**Nota crítica:** O embedding falhou novamente em 2026-05-20 (quota free esgotada — 2ª ocorrência). Fix definitivo = billing ativo na conta Valdece + Edge Function no V3 (chave sai do frontend).

---

## 6. PRINCÍPIOS EXTRAÍDOS NO LOOP 6

| Princípio | Descrição |
|---|---|
| P-046 | Contrato formaliza ciclo de evolução, não produto finalizado — V3, V4 são entregas futuras contratualmente previstas |
| P-023 ativo | 5 áudios = scope creep via WhatsApp em tempo real — filtro funcionou: data_dje e badges vinculantes foram bloqueados até assinatura |
| HV-1 recorrente | Chave Gemini no frontend = quota free esgota com uso real — 2ª ocorrência em Loop 6 — V3 Edge Function é obrigatória |

---

## 7. [M-1 a M-5] — 5 IDEIAS DISRUPTIVAS DO MÚSCULO PARA LOOP 7

> Estas ideias NÃO vieram do Gemini nem do NotebookLM. São perspectiva técnica exclusiva do Músculo.
> Alimentam o próximo ciclo do Gemini.

**[M-1] Modo Audiência**
Interface simplificada para uso em tempo real: texto grande, 1 resultado por vez, botão "Copiar para petição" com 1 toque, sem distrações. Valdece usa o sistema em audiências — a UI atual foi projetada para desktop tranquilo, não para stress de audiência.
Custo: 4h de frontend. Impacto: diferencial que nenhum concorrente tem para criminalistas.

**[M-2] Detector de Mudança Jurisprudencial**
Quando uma query já realizada anteriormente retornar resultado diferente (novo acórdão mais relevante), alertar: "ATENÇÃO: o precedente sobre [tema] mudou desde sua última busca." Exige histórico de queries por usuário no Supabase.
Custo: 6h (tabela query_history + lógica de comparação). Impacto: sistema que pensa junto com o advogado.

**[M-3] Export para Petição em Bloco**
Selecionar N acórdãos → gerar bloco ABNT numerado pronto para colar em petição DOCX. Hoje o Valdece copia 1 de cada vez. Com 5 acórdãos relevantes, são 5 copias manuais.
Custo: 3h (seleção multi-card + geração de texto formatado). Impacto: economiza 10 minutos por petição com múltiplas citações.

**[M-4] Watchdog de Corpus por Tema**
Monitorar frequência de busca por tema → detectar quando um tema recorrente tem < 3 acórdãos relevantes no corpus → alertar Valdece: "Você busca muito sobre [tema X] mas temos poucos acórdãos sobre isso. Quer que eu amplie?". 
Custo: 2h (analytics simples + alerta UI). Impacto: corpus evolui dirigido pelo uso real, não por intuição.

**[M-5] Sovereign Upload Simplificado (antecipação V2)**
Permitir que Valdece cole o texto de uma decisão diretamente no sistema → embedding gerado → entra no corpus dele instantaneamente. Sem interface de upload, sem PDF parsing — só texto colado. Gate: billing ativo na conta dele.
Custo: 4h (Edge Function de ingestão via UI). Impacto: corpus cresce a cada caso que ele atende — vira vantagem competitiva acumulada.

---

## 8. PRÓXIMA AÇÃO — LOOP 7

```
GATE DE ENTRADA LOOP 7:
1. Billing ativo na conta Google do Valdece → chave Gemini gerada
2. Gemini anchor: .\scripts\gemini_anchor_generator.ps1
3. Levar CONTEXTO_GEMINI.md + PASSO3_GEMINI.md ao Gemini → DIRETRIZ V7
4. preparar_notebooklm_projeto.ps1 -cliente VALDECE → Wipe & Sync
5. NotebookLM → skill valdece-v7.md (4 partes obrigatórias)
6. Músculo executa /valdece-v7 → delibera → plano V3 migration

FOCO LOOP 7:
- ALTER TABLE ADD COLUMN (data_dje, repercussao_geral, recurso_repetitivo, turma)
- Re-ingestão dry-run → verificar 61 acórdãos com campos preenchidos
- Badges vinculantes no frontend (badge VINCULANTE se repercussao_geral=true ou recurso_repetitivo=true)
- Edge Function Supabase para embedding (HV-1 fix definitivo)
- Migração Supabase conta Valdece (sa-east-1) após testes
```


================================================================================

## PROTOCOLO VANGUARD (resumo)
---
name: protocolo-vanguard
description: ativa o Modelo Pentalateral IAH para QUALQUER projeto — ecommerce, app, site, SaaS, modelo de negócio, automação, IA, API. O Músculo opera como Arquitecto-Mestre e membro ativo do Conselho colaborativo. Executar sempre que o Diretor disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo Pentalateral IAH
**Versão da Skill:** 6.0 — Universal · Colaborativo · Qualquer projeto · Qualquer operador · 7 Leis Soberanas + 8 Frameworks de Gestão ativos · Intelligence Compounding · Protocolo de Imunidade do Conselho (2026-05-14) · **4º Membro: Embaixador + P-031 Filtro de Realidade (2026-05-18)**

---

> ⚠️ **ORGANISMO VIVO — atualizar SEMPRE AO FECHAR**
> Esta skill melhora com cada projeto entregue.
> Ao fechar qualquer iteração:
> · Novo módulo construído → registar no inventário do operador
> · Debate relevante → documentar com resultado
> · Estimativa muito diferente do real → corrigir
> · Novo padrão de sucesso ou falha → registar
> Nunca fechar sem verificar. O valor da skill está no que acumula.

---

> **Este protocolo constrói qualquer coisa.**
> Um ecommerce, uma app mobile, um site, um SaaS, um modelo de negócio, uma API, uma automação.
> O que muda é o projeto. O que não muda é o processo.
>
> O Pentalateral — Diretor + Estrategista + Auditor + Músculo — é o conselho.
> O cliente traz o problema. O conselho delibera. O Músculo entrega.

---

## CONFIGURAÇÃO DO OPERADOR

> Preencher uma vez por operador. Ao copiar para outro projeto ou outro operador, atualizar esta seção.
> Os valores abaixo são a configuração ativa deste Pentalateral.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PENTALATERAL — CONFIGURAÇÃO ativa
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

diretoR:         Eduardo
  └── Papel: Veredito Final. Decide tudo. Sem a sua aprovação, nada avança.
  └── Canal: presencial / WhatsApp / terminal

ESTRATEGISTA:     Gemini (Advanced)
  └── Papel: Visão de mercado, DIRETRIZ estratégica, 5 ideias por ciclo.
  └── Como ativar: colar COMANDO_ESTRATEGISTA no chat do Gemini.

AUDITOR:          NotebookLM
  └── Papel: Sócio Consultor com memória histórica. Gera Skill. Audita coerência.
  └── Como ativar: carregar fontes no NotebookLM + colar comando padrão.

MÚSCULO:          Claude Code (este protocolo)
  └── Papel: Arquitecto-Mestre. Delibera, executa, propõe, protege.
  └── Como ativar: PROTOCOLO VANGUARD + descrição do projeto.

EMBAIXADOR:       Claude Projects (um Project por cliente)
  └── Papel: Inteligência persistente do cliente. Memória entre sessões. 11 mandatos.
  └── Único membro com acesso ao relacionamento real acumulado — o Músculo não tem isso.
  └── Como ativar: ir_ao_embaixador.ps1 -cliente [NOME] → clipboard + browser automáticos.
... [truncado -- ver arquivo completo]
