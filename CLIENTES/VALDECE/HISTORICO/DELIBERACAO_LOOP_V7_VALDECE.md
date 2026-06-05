# DELIBERACAO_LOOP_V7_VALDECE — Sintese P-037
> Gerado pelo Musculo · Loop 7 · Retroativo 2026-06-05
> Sintese das 25 ideias [M]+[G]+[N]+[E] em 1 plano consolidado
> Base documental: MEMORIA_V7 + relatorio_V7 + AUDITOR_LOOP_7_VALDECE + DIRETRIZ_V7 + MEMORIA_EMBAIXADOR

---

## 1. CONTEXTO DO LOOP 7

**Projeto:** PROJ-001 Valdece — Toga Digital — LegalTech Penal
**Loop:** 7 — V3 ENRICHMENT + HV-1 Fix + Deploy Netlify
**Entrada do loop:** Contrato assinado R$5k · 2026-05-19 · V3 desbloqueado
**Objetivo central:** Entregar badges vinculante/pleno/turma nos 61 acordaos + corrigir chave Gemini exposta no frontend (HV-1) + deploy em producao

---

## 2. CATALOGO DOS 25 INPUTS

### [M-1 a M-5] — Musculo (Loop 6 → Loop 7)
| Ideia | Proposta | Resposta Gemini |
|---|---|---|
| M-1 | Modo Audiencia com destaque vinculante | MODIFICADA — congelar para Hypercare |
| M-2 | Detector de Mudanca Jurisprudencial | DESCARTADA — 6h build, fora do escopo V3 |
| M-3 | Export Peticao em Bloco | MODIFICADA — guardar para pitch V2 |
| M-4 | Watchdog de Corpus por Tema | MODIFICADA — so tabela logs silenciosa no Supabase |
| M-5 | Sovereign Upload Simplificado (antecipacao V2) | DESCARTADA — violacao P-046 |

### [G-1 a G-5] — Gemini DIRETRIZ V7
| Ideia | Proposta | Decisao Musculo |
|---|---|---|
| G-1 | Cache estrategico de embeddings (20 queries frequentes) | V2 — complexidade vs. prazo Loop 7 fixo |
| G-2 | Demonstracao oculta de resiliencia (fail-open guard) | V2 — aguarda confirmacao de uso ativo |
| G-3 | Citacao ABNT com link de validacao soberana | V2 — rota dinamica frontend requires Loop 8+ |
| G-4 | Indexador automatico de peso por turma julgadora | ENTRA com ajuste — campo turma ja criado, multiplicador aprovado como enhancement futuro |
| G-5 | view_diretor_roi (telemetria de ROI) | ENTRA AGORA — custo zero, impacto imediato (commit 2026-05-25) |

### [N-1 a N-5] — NotebookLM AUDITOR_LOOP_7_VALDECE
| Ideia | Proposta | Decisao Musculo |
|---|---|---|
| N-1 | Mapeamento vocabulario nativo via audios de feedback | V2 — aguarda mais transcricoes de Valdece |
| N-2 | Sincronizacao automatica WIP_BOARD pos-commit (P-055) | ENTRA — implementado como regra de processo |
| N-3 | Diagnostico de dimensao vetorial no pipeline de deploy | ENTRA — teste de dimensionality adicionado ao reingest |
| N-4 | Trava de escopo comercial (CHANGE_ORDERS_PENDENTES git) | V3 — exige UI e disciplina de equipe |
| N-5 | Monitor de latencia geografica pos-migracao sa-east-1 | ENTRA — benchmark executado durante gate P-038 |

### [E-1 a E-5] — Embaixador SECAO D Loop 7 (2026-05-24)
| Ideia | Proposta | Decisao Musculo |
|---|---|---|
| E-1 | Silencio como protocolo tecnico durante demo (ja executado) | CONSOLIDADO — principio operacional ativo |
| E-2 | Pergunta que revela encantamento ("salva para depois?") | MONITORAR — sinal de fechamento de contrato V2 |
| E-3 | Toga Digital como linha de nicho, nao produto unico | ESTRUTURAL — documentado para replicacao em LegalTech-2 |
| E-4 | Argumento do promotor para fechamento | CONSOLIDADO — ativo no pitch de indicacao |
| E-5 | Hypercare como janela de escuta de falhas (evidencia V2) | MONITORAR — Sentinel Report 2026-06-02 captura |

---

## 3. DELIBERACAO 7 PONTOS — PROPOSTAS RELEVANTES

### Proposta Central: V3 ENRICHMENT (G + BLOCO 1 DIRETRIZ)

1. **O QUE ESTA CERTO**
   Gemini acertou ao priorizar HV-1 como prioridade 1 antes dos badges visuais. Chave Gemini exposta = risco de outage em producao que anularia a satisfacao do Hypercare no dia 1.

2. **ONDE DIVERGE**
   Gemini propoe migracao sa-east-1 como prioridade 3 no Loop 7. O Musculo identifica risco: migrar 61 acordaos com campos V3 recen-criados, antes de validar o reingest completo, adiciona uma variavel de falha desnecessaria ao loop. Recomendacao: badges e HV-1 primeiro, migracao como objetivo do Loop 8 pos-confirmacao de uso real.

3. **DECISAO CLARA**
   - HV-1 fix: ENTRA AGORA (Edge Function Netlify, nao Supabase)
   - V3 ENRICHMENT badges: ENTRA AGORA
   - Migracao sa-east-1: V2/Loop 8 — gatilho: Sentinel Report confirmar uso ativo

4. **ENHANCEMENT**
   O HV-1 fix via Netlify Functions (nao Supabase Edge Function como Gemini propos) e mais rapido de implementar (nao exige token Supabase novo) e zero risco de cold-start no free tier do Supabase.

5. **CUSTO REAL**
   - Edge Function Netlify + HV-1: 3h
   - V3 ENRICHMENT (ALTER TABLE + classify_v3_fields + reingest 61): 4h (+ 1h extra pelo bug EC 45/2004)
   - view_diretor_roi: 0.5h
   - Total: ~8.5h build

6. **IMPACTO COMERCIAL**
   Valdece passa de "sistema que busca" para "sistema que classifica a autoridade do precedente." O badge VINCULANTE e argumento de defesa antes que o juiz peca — nenhum concorrente na faixa de preco oferece isso.

7. **PROXIMA ACAO**
   Musculo executa reingest + HV-1 + badges + view_diretor_roi. Ao fechar: MEMORIA_V7 + relatorio_V7 + DELIBERACAO. Diretor envia Sentinel Report em 2026-06-02.

---

### Proposta Secundaria: G-5 view_diretor_roi

1. **O QUE ESTA CERTO** — Dado quantitativo de ROI e o unico argumento irrefutavel para o pitch V2.
2. **ONDE DIVERGE** — Nenhuma divergencia. Custo 0, impacto alto.
3. **DECISAO CLARA** — ENTRA AGORA. SQL view protegida.
4. **ENHANCEMENT** — Incluir campo `ultimo_tema_buscado` na view para facilitar personalizacao do pitch.
5. **CUSTO REAL** — 30 min (SQL).
6. **IMPACTO COMERCIAL** — "Valdece fez N buscas. Economizou X horas. V2 custa R$8.500 e paga em 3 casos."
7. **PROXIMA ACAO** — Implementado. Validado: total_acordaos=61 · vinculantes=3.

---

### Proposta de Processo: N-3 Diagnostico de Dimensao Vetorial

1. **O QUE ESTA CERTO** — O bug outputDimensionality 768→3072 JA ACONTECEU neste loop. N-3 e correto.
2. **ONDE DIVERGE** — Nenhuma. Risco comprovado em producao.
3. **DECISAO CLARA** — ENTRA AGORA como regra de processo: verificar `outputDimensionality` antes de qualquer reingest.
4. **ENHANCEMENT** — Adicionar assertion no script `classify_v3_fields.py`: `assert len(embedding) == 3072, f"Dimensao incorreta: {len(embedding)}"`.
5. **CUSTO REAL** — 0.5h (assertion no script existente).
6. **IMPACTO COMERCIAL** — Zero downtime em producao. Corpus integro.
7. **PROXIMA ACAO** — Assertion implementada. Documentada no KNOWLEDGE_BASE.

---

## 4. SINTESE P-037 — PLANO CONSOLIDADO DO LOOP 7

### O que entrou
| Feature | Origem | Custo | Status Final |
|---|---|---|---|
| HV-1 fix: Edge Function Netlify | BLOCO 1 DIRETRIZ | 3h | ENTREGUE |
| V3 ENRICHMENT: badges vinculante/turma/data_dje | BLOCO 1 DIRETRIZ | 4h | ENTREGUE |
| classify_v3_fields + reingest 61 acordaos | BLOCO 1 DIRETRIZ | 2h | ENTREGUE |
| view_diretor_roi | G-5 | 0.5h | ENTREGUE |
| Assertion dimensionality no reingest | N-3 | 0.5h | ENTREGUE |
| Embaixador SECAO D D1-D6 | E loop | — | EXECUTADOS |

### O que ficou para loops seguintes
| Feature | Destino | Gatilho |
|---|---|---|
| Migracao sa-east-1 | Loop 8 | Sentinel Report confirmar uso ativo |
| Modo Audiencia (M-1/G revisado) | Loop 8 | Uso ativo confirmado |
| Cache estrategico embeddings (G-1) | V2 | Dados de query_logs acumulados |
| Export DOCX em Bloco (M-3) | V2 pitch | Pitch com argumento "R$8.500" |
| Monitor latencia sa-east-1 (N-5) | Loop 8 | Pos-migracao |

### Circuit Breaker aplicado
- **Scope creep (H-4 Embaixador):** personalização logo OAB solicitada por Valdece → BLOQUEADO por Scope-watch (D3). Registrado como Change-Order potencial.
- **Sovereign Upload antecipado (M-5):** DESCARTADO por P-046. Base estatica deve ser estabilizada antes de upload dinamico.

---

## 5. O QUE FOI CONSTRUIDO — RETROSPECTIVA

Commits principais: 2026-05-21 a 2026-05-25
- `classify_v3_fields.py` rodado em 61 acordaos · 0 erros pos-fix EC 45/2004
- `netlify/functions/embed.js` + `netlify.toml` (HV-1)
- `view_diretor_roi` criada no Supabase
- Deploy Netlify V3: toga-digital-valdece.netlify.app (11s)
- MEMORIA_EMBAIXADOR atualizada com D1-D6

**Gate de qualidade:** gate_v3 --check APROVADO: vinculantes=3 · pleno=5 · turma=56 · proxy 200 OK · vetor 3072 dim.

---

## 6. PRINCIPIOS EXTRAIDOS NO LOOP 7

| Principio | Descricao |
|---|---|
| P-061 | Nenhuma API key de terceiro pertence ao frontend — proxy obrigatorio |
| P-065 | Advogado que testa antes de assinar ja se vendeu — Hypercare comeca no dia 1 |
| P-066 | PAINEL_ATIVIDADES tem destino fixo — Embaixador cria artefato, Diretor nao copia |
| P-067 | Musculo bloqueado ate Embaixador reagir — gate automatico pos-Skill aprovada |

---

## 7. NOTAS DE PROCESSO

**Nota retroativa:** Este arquivo foi criado em 2026-06-05 para registrar a sintese P-037 do Loop 7, que foi executada mas nao formalmente documentada antes do fechamento do loop. O conteudo reflete fielmente as decisoes tomadas com base nos artefatos disponiveis (MEMORIA_V7, relatorio_V7, AUDITOR_LOOP_7, DIRETRIZ_V7, MEMORIA_EMBAIXADOR). Nenhuma decisao retroativa foi inserida — apenas documentacao do que ocorreu.

---

*Musculo — Pentalateral IAH — PROJ-001 Valdece — Loop 7 — 2026-06-05 (retroativo)*
