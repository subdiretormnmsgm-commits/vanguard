# MEMORIA V1 — PROJ-002 Ingrid
**Loop:** #1 — Kickoff e Deliberação  
**Data:** 2026-05-15  
**Próximo loop:** ao final do Dia 5 de build (gate Feed Adaptativo)

> Este arquivo é lido pelo Músculo no início do Loop 2.
> Contém o estado técnico real — decisões tomadas, dívidas, riscos, gates pendentes.

---

## ESTADO DO BUILD

| Item | Status |
|---|---|
| Loop atual | #1 concluído — aguardando Veredito do Diretor para Dia 1 |
| Dias completos | 0 — build ainda não iniciado |
| Deadline app | 2026-05-30 (15 dias de build) |
| Prova cliente | 2026-09-06 (114 dias) |
| Stack aprovada | PWA + Supabase + Claude API |

---

## DECISÕES FIXADAS — NÃO REVERTER

| Decisão | Razão |
|---|---|
| Fonte de questões = Claude API (estilo Quadrix) | P-003 — sem scraping TEC/QConcursos |
| Auth = single-user (sem login complexo) | MVP — Ingrid é a única usuária |
| Cache = lote 50 quando < 30 disponíveis | P-006 Lei 5 — evitar geração on-the-fly repetida |
| Proporção feed = 70% Peso 2 / 30% Peso 1 | Específicos valem 80/100 pontos — foco obrigatório |
| Haiku = gerais + dicas socráticas | Custo baixo para conteúdo simples |
| Sonnet = específicos (SUAS, LOAS, PNAS) | Qualidade máxima para conteúdo crítico |
| BURN_RATE_DAILY_LIMIT_USD = 5.00 | P-006 — limite antes de qualquer chamada API |
| Fallback = trigger em 70% da cota diária | Margem de segurança antes do hard-limit |
| SM-2 = intervalo variável | <30% acerto → 2 dias / 30-50% → 4 dias / >50% → 7 dias |
| Push MVP / email Loop 2 | Sem serviço de email complexo no MVP |

---

## ARQUITETURA APROVADA (Dias 1-2)

### Schema Supabase

```sql
-- Tabela de questões (global, multi-tenant desde o Dia 1)
questoes_quadrix (
  id uuid PRIMARY KEY,
  concurso_id text NOT NULL,       -- 'sedes_df_2026'
  disciplina_id text NOT NULL,     -- 'suas', 'loas', 'pnas', etc.
  peso_edital integer NOT NULL,    -- 1 ou 2
  score_prioridade integer,        -- peso × incidencia_historica_pct
  enunciado text NOT NULL,
  alternativas jsonb,              -- [{ letra, texto, correta }]
  gabarito text,
  explicacao text,
  nivel_dificuldade integer,       -- 1 (fácil) a 5 (difícil)
  estilo_quadrix text[],           -- ['literalidade', 'pegadinha_troca', ...]
  criada_em timestamptz DEFAULT now()
)

-- Progresso por usuário (per user_id — pronto para multi-tenant)
progresso_usuario (
  id uuid PRIMARY KEY,
  user_id uuid NOT NULL,           -- FK futura para auth.users
  questao_id uuid REFERENCES questoes_quadrix(id),
  respondida_em timestamptz DEFAULT now(),
  resposta_usuario text,
  correta boolean,
  tempo_resposta_seg integer,
  proxima_revisao_em date          -- SM-2
)
```

### Algoritmo de Feed Diário

```
score_prioridade = peso_edital × incidencia_historica_pct

Ranking (top-3 por score):
  1. SUAS       — score 196 — 10 questões estimadas na prova
  2. PNAS/LOAS  — score 190 — 7/6 questões estimadas
  3. CRAS/CREAS — score 184 — 4 questões estimadas

Feed diário de 20 questões:
  → 14 questões Peso 2 (70%) — priorizadas por score_prioridade DESC
  → 6 questões Peso 1 (30%) — priorizadas por score_prioridade DESC
  → SM-2 insere questões de revisão antes das novas
```

### Edge Function (Dias 1-2)

```
POST /gerar-questoes
  body: { disciplina, peso, quantidade, estilo_quadrix }
  → chama Claude API (Haiku ou Sonnet por peso)
  → valida JSON da resposta
  → insere em questoes_quadrix
  → retorna questões para o front
  
Trigger de cache:
  QUANDO questoes disponíveis (concurso_id, disciplina_id) < 30
  → gerar lote de 50 em background
  → BURN_RATE_DAILY_LIMIT_USD = $5.00 verificado antes
```

### Mágico de Oz Gate (Dia 2 — bloqueante)

```bash
# Eduardo avalia 10 questões geradas via CLI
node test_geracao.js --disciplina suas --quantidade 10
# Rubrica: estilo Quadrix (literalidade, alternativas plausíveis, pegadinhas)
# Gate passa se média >= 4/5 na rubrica
```

---

## GATES BLOQUEANTES POR DIA

| Dia | Gate | Critério | Output verificado |
|---|---|---|---|
| Dia 2 | Qualidade da questão | Eduardo avalia 10 questões — rubrica média >= 4/5 | JSON com 10 questões geradas no terminal |
| Dia 5 | Feed correto | Feed exibe plano 7 dias com proporção 70/30 correta | Tela do app mostrando disciplinas e contagens |
| Dia 8 | Experiência real | Ingrid responde 10 questões, progresso salvo, fallback testado | Registros no Supabase + log de custo |
| Dia 11 | Heatmap funcional | Heatmap verde/amarelo/vermelho correto + simulado domingo | Screenshot da tela + resultado do simulado |
| Dia 15 | Soberania (P-013) | Ingrid com acesso admin ao próprio Supabase | Login da Ingrid no Supabase confirmado ao vivo |

---

## VEREDITO DO DIRETOR — PENDENTE (BLOQUEANTE DIA 1)

O build não pode iniciar sem aprovação nos 8 pontos abaixo:

1. Schema multi-tenant desde o Dia 1 (questoes_quadrix + progresso_usuario)?
2. Haiku para gerais + dicas / Sonnet para específicos?
3. BURN_RATE_DAILY_LIMIT_USD = $5,00?
4. Cache: gerar lote 50 quando < 30 disponíveis?
5. Proporção feed: 70% Peso 2 / 30% Peso 1?
6. Fallback trigger em 70% (não 90%) da cota?
7. SM-2 intervalo variável (não 3 dias fixos)?
8. Push no MVP / email com tracking no Loop 2?

**Quando o Diretor responder SIM a todos → Músculo inicia Dia 1.**

---

## IDEIAS DO DIRETOR (REGISTRADAS — alimentar Gemini no Loop 2)

| ID | Ideia | Status |
|---|---|---|
| D-1 | Score de Incidência Histórica (peso × incidencia) | Implementado no edital_sedes.json |
| D-2 | Blocos de Incidência como critério de feed | Implementado no algoritmo_feed |
| D-3 | Análise Provas vs Editais (base proprietária) | Pesquisa feita, V2 pipeline |
| D-4 | Estrutura JSON rica por concurso (modelo reutilizável) | Implementado — edital_sedes.json v2.0 |
| D-5 | Podcast passivo (roteiro → TTS → áudio do dia) | Registrado, entra no Loop 2/V2 |

---

## DÍVIDAS TÉCNICAS

| Prioridade | Item | Impacto |
|---|---|---|
| P0 | 5 questões reais Quadrix para playbook de distratores | Sem isso o prompt de geração tem distratores fracos |
| P0 | Veredito do Diretor nos 8 pontos | Build bloqueado |
| P1 | Conteúdo topicos detalhados do PDF do Edital | edital_sedes.json tem estrutura mas pode complementar |
| P2 | Pesquisa provas reais anteriores para calibrar incidência_pct | Dados atuais são cross-concurso (Quadrix similares) |

---

## ARQUIVOS CRIADOS NO LOOP 1

```
CLIENTES/INGRID/
  BRIEFING_DISCOVERY.txt          ← respostas do discovery com Ingrid
  PASSO3_GEMINI.md                ← instrução ao Gemini (atualizada)
  PASSO5_NOTEBOOKLM.md            ← instrução ao Auditor
  PASSO6_MUSCULO.md               ← guia do Músculo (atualizado)
  DIRETRIZ_GEMINI_V1.txt          ← DIRETRIZ completa 7 blocos
  edital_sedes.json               ← v2.0 completo com score incidência
  HISTORICO/MEMORIA_V1_INGRID.md  ← este arquivo
  HISTORICO/relatorio_evolutivo_V1_INGRID.md
  sql/                            ← schema SQL (a criar no Dia 1)
  backend/                        ← Edge Functions (a criar no Dia 1)
  frontend/                       ← PWA (a criar no Dia 3)

.claude/skills/
  skill_proj002_ingrid_loop1.md   ← Skill do Auditor

INTELLIGENCE_LEDGER.md            ← P-014, P-015, P-016 adicionados
CLIENTES/WIP_BOARD.json           ← PROJ-002 em BUILD
```

---

## PRINCÍPIOS ATIVOS PARA O LOOP 2

- **P-003:** Sem scraping — questões são IP da Vanguard gerado via Claude API
- **P-006:** Burn Rate Shield — $5,00/dia hard-limit antes de qualquer chamada
- **P-007:** Mágico de Oz Gate — CLI valida geração antes de UI avançar
- **P-010:** Gate por dia — nenhuma etapa avança sem output verificado
- **P-013:** Supabase na conta da Ingrid desde o Dia 1
- **P-014:** Score de incidência histórica guia o feed — não o edital linear
- **P-016:** Podcast como V2 — não entra no MVP

---

*MEMORIA gerada pelo Músculo ao fechar Loop 1 · PROJ-002 Ingrid · 2026-05-15*
