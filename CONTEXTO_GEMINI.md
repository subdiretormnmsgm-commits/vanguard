ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-05-18 00:26
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
46329ab feat(embaixador): P-028 — 8 mandatos expandidos + template universal V26
51deee5 feat(embaixador): P-027 Interacao Livre obrigatorio -- Embaixador e membro ativo do Conselho
2cf2387 feat(contratos): CONTRATO_STATUS.txt para Valdece e Ingrid

================================================================================

## INTELLIGENCE LEDGER -- PRINCIPIOS ATIVOS
# INTELLIGENCE LEDGER — Quadrilateral IAH
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
**Aplica-se a:** toda sessão do Quadrilateral.

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
**Aplica-se a:** todo projeto gerido pelo Quadrilateral. Definir o número de loops no Passo 7 (aprovação do plano).

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
**Aplica-se a:** todo projeto do Quadrilateral, toda etapa de build, toda entrega a cliente.

---
... [truncado -- ver arquivo completo]

================================================================================

## WIP BOARD -- ESTADO DOS PROJETOS
{
    "atualizado_em":  "2026-05-16",
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
                                                           "dia3_5_feed_sm2_pwa"
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
                                                              },
... [truncado -- ver arquivo completo]

================================================================================

## MEMORIA MAIS RECENTE
# MEMORIA V2 — PROJ-002 Ingrid
**Loop:** #2 — Build Dias 3–5 (Feed Diário + Gate)  
**Data:** 2026-05-17  
**Próximo loop:** Loop #3 — Dias 6–8 (Interface + Tutor Socrático + Fallback Fadiga)

> Este arquivo é lido pelo Músculo no início do Loop 3.  
> Contém o estado técnico real — o que foi construído, o que falhou, o que está pendente.

---

## ESTADO DO BUILD

| Item | Status |
|---|---|
| Loop atual | #2 concluído — Gate Dia 5 APROVADO 2026-05-17 |
| Dias completos | 5 de 15 |
| Deadline app | 2026-05-30 (10 dias restantes) |
| Prova cliente | 2026-09-06 (~112 dias) |
| Questões no banco | 460 — 13 disciplinas Cargo 202 |

---

## RECALIBRAÇÃO CRÍTICA — EXECUTADA 2026-05-16 (P-024)

O cargo identificado no Loop 1 estava errado.

| Campo | Loop 1 (errado) | Loop 2 (correto) |
|---|---|---|
| Cargo | TDAS — área social | Cargo 202 — Técnico Administrativo |
| Disciplinas centrais | SUAS, LOAS, PNAS, CRAS/CREAS | Dir. Administrativo, Dir. Constitucional, Arquivologia, Recursos Materiais |
| edital_sedes.json | v2.0 (área social) | v3.0 (reconstruído do zero) |
| Edge Function index.ts | prompt com SUAS/LOAS | rebuildt — disciplinas Cargo 202 |

**P-024:** Validar o número do cargo e a especialidade no edital antes de gerar qualquer questão. Cargo errado = banco inútil.

---

## DISCIPLINAS DO CARGO 202 — edital_sedes.json v3.0

| Disciplina | Questões estimadas | Score | Peso |
|---|---|---|---|
| suas_fundamentos | 12q | 190 | 2 |
| programas_beneficios_df | 8q | 180 | 2 |
| direito_administrativo | 8q | 184 | 2 |
| direito_constitucional | 3q | 156 | 2 |
| arquivologia_rotinas_atendimento | 6q | 170 | 2 |
| recursos_materiais_patrimonio | 3q | 144 | 2 |
| portugues | 5q | ~75 | 1 |
| realidade_df_ride | 3q | ~65 | 1 |
| lei_organica_df | 2q | ~60 | 1 |
| lc840 | 2q | ~60 | 1 |
| maria_da_penha | 1q | ~50 | 1 |
| politica_mulheres | 1q | ~50 | 1 |
| primeiros_socorros | 1q | ~50 | 1 |

---

## O QUE FOI CONSTRUÍDO NO LOOP 2

### Dias 3–5

| Componente | Status | Arquivo |
|---|---|---|
| Edge Function `feed-diario` | Deployada e funcional | `supabase/functions/feed-diario/index.ts` |
| Edge Function `gerar-questoes` | Refatorada — 1 chamada Claude/invocação | `supabase/functions/gerar-questoes/index.ts` |
| Seed de questões | 460 questões no Supabase | `CLIENTES/INGRID/seed_questoes.ps1` |
| Gate Dia 5 (CLI) | APROVADO — 7 dias × 20q, 70.0% Peso 2, 0 erros | `CLIENTES/INGRID/gate_cli_dia5.js` |
| Ponto de entrada único | `iniciar.ps1` — menu, env, banco | `CLIENTES/INGRID/iniciar.ps1` |
| Troubleshooting | 7 panes documentadas | `QUADRILATERAL_UNIVERSAL/REFERENCIAS/TROUBLESHOOTING_SUPABASE_CLAUDE_API.md` |
| session_close.ps1 | Auditoria automática de documentos adicionada | `scripts/session_close.ps1` |

---

## ARQUITETURA REAL — APÓS LOOP 2

### Edge Function gerar-questoes (regra permanente)

```
REGRA DE OURO: 1 chamada Claude por invocação da Edge Function.
O loop é externo (no seed script), não dentro da Function.

Por quê: Supabase Edge Function timeout = ~150s wall clock.
Sonnet para 5 questões técnicas complexas = ~87s por chamada.
2 chamadas sequenciais = 174s → timeout garantido.

Parâmetros corretos:
  - Peso 2 (Sonnet): max 5 questões por invocação, max_tokens = 8192, TimeoutSec = 200
  - Peso 1 (Haiku): max 8 questões por invocação, max_tokens = 4096, TimeoutSec = 120
```

### Seed script — controle externo do loop

```powershell
# Peso 2: batch de 5, timeout 200s por chamada
# Peso 1: batch de 8, timeout 120s por chamada
# Seed chama a Edge Function N vezes até atingir quota
# Edge Function faz 1 Claude call e retorna
```

### Strip de markdown (regra permanente)

```typescript
// Claude pode retornar JSON envolvido em ```json ... ```
// Sempre fazer strip antes de JSON.parse
let jsonText = conteudo.trim();
if (jsonText.startsWith("```")) {
  jsonText = jsonText.replace(/^```(?:json)?\s*\n?/, "").replace(/\n?```\s*$/, "").trim();
}
```

### Gate Dia 5 — Node.js v24

```javascript
// Node.js v24 tem fetch nativo — NÃO importar node-fetch
// Remover: import fetch from 'node-fetch'
```

---

## 7 PANES DOCUMENTADAS (P-025)

| # | Sintoma | Causa | Solução |
|---|---|---|---|
| 1 | HTTP 500 instantâneo | API key Anthropic arquivada | Gerar nova key + atualizar Secret Supabase (sem redeploy) |
| 2 | HTTP 500 após ~28s | Claude retorna JSON em markdown | Strip antes de JSON.parse — permanente na Edge Function |
| 3 | HTTP 500 — max_tokens | 4096 insuficiente para 5+ questões Sonnet | max_tokens = 8192 para Sonnet; regra: N × 700 × 1.3 |
| 4 | Timeout da Edge Function | Loop de múltiplas chamadas Claude dentro da Function | 1 Claude call por invocação; loop externo no script |
| 5 | Timeout PowerShell | Sonnet demora ~87s para 5q, TimeoutSec default 120s insuficiente para batch maior | TimeoutSec = 200 para Peso 2 |
| 6 | HTTP 400 no deploy | Deploy rodado fora do diretório raiz do projeto | `cd vanguard/` antes de qualquer `npx supabase functions deploy` |
| 7 | ERR_MODULE_NOT_FOUND: node-fetch | Node.js v24 tem fetch nativo, package desnecessário | Remover import, usar fetch global |

---

## RESULTADO DO GATE DIA 5

```
Resultado: 7 dias simulados
  Dia 1: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 2: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 3: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 4: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 5: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 6: 14 Peso2 + 6 Peso1 = 20 questões ✅
  Dia 7: 14 Peso2 + 6 Peso1 = 20 questões ✅

Proporção Peso 2: 70.0% (exata)
Erros de API: 0
Status: 🟢 APROVADO
```

---

## FALHA DE PROCESSO REGISTRADA — 2026-05-17

O Músculo não auditou documentos ao fechar o Loop 2. Eduardo teve que lembrar.

**Medida permanente:** `session_close.ps1` agora inclui AUDITORIA DE DOCUMENTOS automática.  
**Regra ativa:** CLAUDE.md Regra 11 — AO FECHAR CADA SESSÃO.  
**Registrado em:** INTELLIGENCE_LEDGER.md como FALHA-PROCESSO-2026-05-17.

---

## DÍVIDAS TÉCNICAS PARA O LOOP 3

| Prioridade | Item | Impacto |
|---|---|---|
| P0 | Interface PWA mobile para Ingrid responder questões | Gate Dia 8 bloqueante — Ingrid precisa interagir |
| P0 | Tutor Socrático Haiku — feedback ao errar | Engajamento e aprendizado real |
| P1 | Cache de explicações (`explicacao_tutor` no banco) | Zero custo de API em repetições |
| P1 | Fallback de fadiga — conteúdo passivo quando burn 70% | Estudo sem custo extra |
| P2 | Progresso visual por disciplina no header | UX — Ingrid vê onde atacar |
| P2 | Modo Revisão Express 5 min | Consistência diária |

---

## DECISÕES FIXADAS — NÃO REVERTER (acumulado Loop 1 + Loop 2)

| Decisão | Razão |
|---|---|
| Fonte de questões = Claude API | P-003 — sem scraping |
| Auth = single-user | MVP — Ingrid é a única usuária |
| Proporção feed = 70% Peso 2 / 30% Peso 1 | Fixado no Gate Dia 5 |
| SM-2 intervalo variável | <30% → 2 dias / 30-50% → 4 dias / >50% → 7 dias |
| Haiku para gerais + dicas socrátcas | Custo baixo |
| Sonnet para específicos Peso 2 | Qualidade máxima |
| BURN_RATE_DAILY_LIMIT_USD = 5.00 | P-006 |
| Fallback trigger = 70% da cota | Margem de segurança |
| Stack = PWA + Supabase + Claude API | Sem framework pesado |
| 1 Claude call por Edge Function invocação | Arquitetura de timeout — nunca reverter |
| max_tokens = 8192 para Sonnet | Custo vs segurança validado |
| Batch Sonnet = 5 questões | TimeoutSec 200s comporta ~87s por call |
| Batch Haiku = 8 questões | TimeoutSec 120s comporta confortavelmente |

---

## ARQUIVOS CRIADOS/MODIFICADOS NO LOOP 2

```
CLIENTES/INGRID/
  iniciar.ps1                           ← ponto de entrada único da sessão
  seed_questoes.ps1                     ← refatorado com batch externo
  gate_cli_dia5.js                      ← import node-fetch removido
  HISTORICO/MEMORIA_V2_INGRID.md        ← este arquivo
  HISTORICO/relatorio_evolutivo_V2_INGRID.md

supabase/functions/
  gerar-questoes/index.ts               ← 1 Claude call + strip markdown
  feed-diario/index.ts                  ← deployada pela 1ª vez

scripts/
  session_close.ps1                     ← seção AUDITORIA DE DOCUMENTOS adicionada

infra/
  schema_v19.sql                        ← schema atualizado

QUADRILATERAL_UNIVERSAL/REFERENCIAS/
  TROUBLESHOOTING_SUPABASE_CLAUDE_API.md ← 7 panes documentadas

INTELLIGENCE_LEDGER.md                  ← P-025 + FALHA-PROCESSO-2026-05-17
CLIENTES/WIP_BOARD.json                 ← Loop 2 concluído, Loop 3 declarado
CLIENTES/INGRID/PASSO3_GEMINI.md        ← atualizado para Loop 3
```

---

## PRINCÍPIOS ATIVOS PARA O LOOP 3

- **P-003:** Sem scraping — questões são IP da Vanguard via Claude API
- **P-006:** Burn Rate Shield — $5,00/dia hard-limit
- **P-007:** Mágico de Oz Gate — CLI valida antes de UI avançar
- **P-010:** Gate por dia — output verificado antes de avançar
- **P-024:** Validar cargo e especialidade no edital antes de gerar qualquer questão
- **P-025:** Arquitetura Supabase+Claude — 1 call por invocação, batch externo, strip markdown sempre

---

*MEMORIA gerada pelo Músculo ao fechar Loop 2 · PROJ-002 Ingrid · 2026-05-17*


================================================================================

## PROTOCOLO VANGUARD (resumo)
---
name: protocolo-vanguard
description: ativa o Modelo Quadrilateral IAH para QUALQUER projeto — ecommerce, app, site, SaaS, modelo de negócio, automação, IA, API. O Músculo opera como Arquitecto-Mestre e membro ativo do Conselho colaborativo. Executar sempre que o Diretor disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo Quadrilateral IAH
**Versão da Skill:** 5.1 — Universal · Colaborativo · Qualquer projeto · Qualquer operador · 7 Leis Soberanas + 8 Frameworks de Gestão ativos · Intelligence Compounding · Protocolo de Imunidade do Conselho (2026-05-14)

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
> O Quadrilateral — Diretor + Estrategista + Auditor + Músculo — é o conselho.
> O cliente traz o problema. O conselho delibera. O Músculo entrega.

---

## CONFIGURAÇÃO DO OPERADOR

> Preencher uma vez por operador. Ao copiar para outro projeto ou outro operador, atualizar esta seção.
> Os valores abaixo são a configuração ativa deste Quadrilateral.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUADRILATERAL — CONFIGURAÇÃO ativa
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

TRIGGER:          PROTOCOLO VANGUARD
MEMORANDO:        MEMORANDO_QUADRILATERAL_UNIVERSAL.md
MOEDA:            BRL
PRODUTO_ENTRADA:  Sprint Discovery — [preço definido por Eduardo por projeto]
... [truncado -- ver arquivo completo]
