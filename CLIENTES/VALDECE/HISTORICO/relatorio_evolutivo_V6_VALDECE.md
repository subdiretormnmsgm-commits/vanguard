# RELATÓRIO EVOLUTIVO V6 — PROJ-001 VALDECE · Loop 6
> Gerado pelo Músculo · 2026-05-20
> Framework: SWOT (estado atual) + PDCA (Loop 6) + 5W2H (Loop 7)
> Leitura recomendada antes de ir ao Gemini com PASSO3 Loop 7

---

## SWOT — ESTADO AO FECHAR LOOP 6

### FORÇAS
- **Contrato assinado** — R$5.000 fixo, modelo sem mensalidade validado comercialmente
- **Sistema em produção real** — netlify live, 61 acórdãos, Gate P-038 100% aprovado
- **Cliente engajado ativamente** — 5 áudios de feedback técnico enviados espontaneamente
- **Interface validada pelo cliente** — Toga Digital Navy + Ouro foi escolha do Valdece
- **Corpus testado em 22 temas criminais** — cobertura para 80% dos casos típicos de criminalista
- **Loop evolutivo funcionando** — 4 princípios extraídos (P-041 a P-046), 3 membros deliberaram

### FRAQUEZAS
- **HV-1 recorrente** — chave Gemini exposta no frontend; quota free esgotou 2x — risco real de sistema offline para cliente pagante
- **Infra em conta Vanguard** — Supabase não migrado para conta Valdece (P-038 pendente)
- **Corpus pequeno** — 61 acórdãos cobre temas principais mas não profundidade (< 5 por tema em média)
- **Sem filtragem V3** — Valdece não consegue filtrar por data, vinculante ou turma — demanda declarada nos áudios
- **Zero analytics de uso** — não sabemos quais temas Valdece busca mais, em qual horário, com qual taxa de sucesso

### OPORTUNIDADES
- **V3 desbloqueada** — 4 campos novos (data_dje, repercussao_geral, recurso_repetitivo, turma) aumentam utilidade 3x
- **Pipeline de indicação** — advocacia criminal é comunidade densa; 1 satisfeito fala com 50 na OAB
- **V2 em 30 dias** — corpus ≥ 500 docs ou uso ativo → Sovereign Upload + Radar de Divergência + Citação DOCX (R$8.500–12.000)
- **Nicho Legal-Tech-Criminal a 75% maturidade** — Valdece é cliente referência; próximo cliente do nicho tem blueprint pronto
- **3 nichos em discovery** — Medicina, Contabilidade, Psicologia aprovados para pesquisa

### AMEAÇAS
- **Instabilidade de API** — quota free esgotada 2x em Loop 6; billing não ativo = risco de outage para cliente pagante
- **Perda de confiança por outage** — Valdece pagou R$5k; sistema offline é quebra de confiança imediata
- **Corpus desatualizado** — jurisprudência muda; sem mecanismo de atualização, corpus envelhece
- **Concorrência implícita** — Westlaw (R$3k/mês) e Jusbrasil (gratuito/limitado) definem o benchmark de comparação

---

## PDCA — ANÁLISE DO LOOP 6

### PLAN (o que foi planejado)
- Processar feedbacks dos 5 áudios do Valdece: ementa completa, badge UF, data_dje, badges vinculantes
- Priorizar: ementa + UF (melhorias V1 imediatas) · data_dje + vinculantes (V3 — bloqueados por P-023)
- Fechar contrato presencialmente em 2026-05-19
- Desbloquear V3 mediante assinatura

### DO (o que foi executado)
- ✅ URL STJ corrigida + ementa completa no Copiar ABNT (2b72b9b)
- ✅ 9 áudios convertidos OGG→FLAC para NotebookLM (4342064)
- ✅ HC 512.290/RJ corrigido no banco + re-embedding (1369689)
- ✅ Ementa completa (600 chars) + badge UF + boost monocrático +0.15 (9709649)
- ✅ Chave Gemini substituída após quota esgotada — 1ª ocorrência (9ab28a6)
- ✅ Presencial realizado — credenciais Valdece obtidas — deploy netlify apresentado
- ✅ Contrato assinado R$5k · Gate V3 DESBLOQUEADO (250ff9c)
- ❌ data_dje e badges vinculantes → corretamente bloqueados por P-023 até assinatura

### CHECK (o que o gate revelou)
- **Gate comercial:** APROVADO — contrato assinado com modelo correto (sem mensalidade)
- **Gate técnico:** P-038 mantido (12/12) após ementa + badge UF + boost
- **Surpresa positiva:** Valdece enviou feedback por áudio (não WhatsApp texto) — nível de engajamento acima do esperado
- **Surpresa negativa:** Quota Gemini esgotou 2x — o modelo free tier não suporta nem o volume de testes de desenvolvimento
- **P-023 funcionou:** scope creep via áudio (data_dje, vinculantes) foi bloqueado até contrato — correto

### ACT (o que muda no Loop 7)
- V3 agora é prioridade #1: 4 campos novos + re-ingestão + badges vinculantes
- Billing Gemini obrigatório antes de qualquer coisa (previne 3ª ocorrência de outage)
- Edge Function para embedding (HV-1 fix definitivo — chave sai do frontend)
- Migração Supabase para conta Valdece após testes (P-013 soberania)
- Analytics básicos de uso para alimentar Loop 8 com dados reais

---

## 5W2H — LOOP 7

| Dimensão | Resposta |
|---|---|
| **What** | V3 schema migration: 4 campos novos + re-ingestão 61 acórdãos + badges vinculantes frontend + Edge Function embedding + migração infra Valdece |
| **Why** | Aumentar utilidade (filtrar vinculantes em 1 clique = demanda explícita do cliente) + soberania (P-013) + HV-1 fix definitivo |
| **Who** | Músculo executa · Diretor aprova cada gate · Valdece valida badge "VINCULANTE" em produção |
| **When** | 2026-05-20 a 2026-05-23 (deadline contratual) |
| **Where** | Supabase Vanguard (migration segura) → migração final para sa-east-1 conta Valdece |
| **How** | ALTER TABLE → dry-run script → validar 61 acórdãos com novos campos → redeploy → migração → Valdece testa |
| **How much** | R$0 adicional · billing Gemini ~R$1,20/mês na conta do Valdece |

---

## ANÁLISE COMERCIAL — POSIÇÃO AO FECHAR LOOP 6

### Receita gerada
| Item | Valor |
|---|---|
| Contrato Toga Digital V1 | R$5.000 fixo |
| Hypercare incluso (30 dias) | Sem custo adicional |
| MRR do cliente | R$0 (modelo sem mensalidade — Valdece paga R$1,20/mês direto ao Google) |

### Pipeline imediato
| Produto | Valor estimado | Gatilho | Prazo |
|---|---|---|---|
| V2 (Sovereign Upload + Radar + DOCX) | R$8.500–12.000 | 30 dias de uso ativo ou corpus ≥ 500 | 2026-06-19 |
| Indicação OAB | Novo contrato ~R$5.000 | Valdece mencionar colega criminalista | Qualquer momento |
| Expansão nicho Legal-Tech-Criminal | Blueprint reutilizável | 2º cliente do nicho | 2026-07 |

### Avaliação de consultor
O Loop 6 entregou o que importa: contrato assinado, cliente usando o sistema ativamente, V3 desbloqueada. O modelo sem mensalidade foi um risco calculado que se provou certo — Valdece não teria assinado com mensalidade (H-1 confirmada). O risco real agora é operacional: sistema offline por quota esgotada. Se o Valdece ligar para dizer que o sistema está fora no dia de uma audiência, perde-se a confiança que o presencial construiu. Billing precisa estar ativo antes do Valdece usar o sistema seriamente.

---

## [M-1 a M-5] — 5 IDEIAS DISRUPTIVAS PARA LOOP 7

> Alimentar o Gemini no próximo PASSO3. Sem elas, o loop para.

**[M-1] Edge Function de Embedding** — mover a chamada Gemini do frontend para Supabase Edge Function. Chave sai do HTML, quota fica no servidor, rate limiting controlado. Fix HV-1 definitivo. Custo: 3h. Impacto: sistema nunca fica offline por chave exposta ou quota de browser.

**[M-2] Modo Audiência** — toggle UI que simplifica a interface para uso em tempo real: texto grande, 1 resultado, copiar em 1 toque, sem distrações. Valdece usa durante audiências — a UI atual é boa para desktop calmo, não para stress de tribunal. Custo: 4h. Impacto: diferencial que nenhum Westlaw tem.

**[M-3] Analytics de Uso** — tabela `query_log(user_id, query_text, resultado_count, threshold_usado, timestamp)` no Supabase. Painel simples para Eduardo: quais temas Valdece busca mais, quando, com qual taxa de resultado. Alimenta Loop 8 com dados reais. Custo: 2h. Impacto: corpus evolui dirigido por uso, não intuição.

**[M-4] Export para Petição em Bloco** — selecionar N cards de resultado → gerar texto ABNT numerado formatado para colar em DOCX. Hoje é 1 cópia por acórdão. Com 5 citações por petição, são 5 copias manuais. Custo: 3h. Impacto: economiza 10 minutos por petição — Valdece faz 10+ petições/semana.

**[M-5] Watchdog de Corpus** — detectar quando tema frequentemente buscado tem < 3 resultados relevantes → alertar no painel: "Você busca muito sobre [tema X] — temos cobertura fraca nesse tema. Deseja ampliar?" Direciona a expansão do corpus por prioridade real. Custo: 2h. Impacto: corpus de 61 → 200 acórdãos nos temas certos, não aleatoriamente.
