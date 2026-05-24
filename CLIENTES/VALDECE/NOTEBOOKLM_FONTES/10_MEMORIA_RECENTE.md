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
