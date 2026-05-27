# RELATÓRIO EVOLUTIVO V7 — PROJETO VALDECE
> Loop 7 · V3 ENRICHMENT + Deploy Netlify + Hypercare · Fechamento 2026-05-26
> Análise de negócio + 5 ideias disruptivas para Loop 8

---

## RESUMO EXECUTIVO

Loop 7 entregou a **soberania jurídica do corpus** (V3 ENRICHMENT) — os 61 acórdãos agora têm classificação vinculante/pleno/turma, o que permite a Valdece filtrar por autoridade do precedente além do tema. Adicionalmente, a chave Gemini saiu do frontend (HV-1 resolvido), o deploy V3 está em produção e o Embaixador processou os vereditos D1–D6. O projeto está em Hypercare com sistema operando em produção.

---

## SWOT — ESTADO ATUAL (pós-Loop 7)

### Forças
- **Corpus classificado:** 3 acórdãos vinculantes identificados — argumento jurídico mais forte é agora filtrado automaticamente.
- **Segurança de produção:** GEMINI_API_KEY no proxy server-side. Chave do cliente protegida.
- **Sistema maduro:** 61 acórdãos · 22 temas · embedding 3072 dim · threshold duplo (Precisa/Ampla) · Deploy Netlify em produção.
- **Scope-watch ativo:** qualquer pedido novo = Change-Order formal. Proteção de receita documentada.

### Fraquezas
- **Uso real não confirmado:** 5+ dias desde assinatura sem check-in de Valdece. Sabemos que o sistema funciona, não que ele usa.
- **Migração Supabase pendente:** ainda no projeto Vanguard — dependência de infra compartilhada que não deveria existir em Hypercare.
- **Corpus sem curadoria ativa:** sem mecanismo para Valdece sinalizar buscas sem resultado.

### Oportunidades
- **Badge VINCULANTE como argumento de venda:** "Você vai encontrar os 3 acórdãos que o STF considera obrigatórios para o caso." Nenhum concorrente na faixa de preço oferece isso.
- **Pipeline OAB (D6 ativo):** ao ouvir menção a colega criminalista → pitch de indicação imediato. Comunidade densa = multiplicação de receita sem custo de aquisição.
- **V2 (Sovereign Upload):** gatilho em 30 dias de uso ativo. Loop 8 deve confirmar sinais antes do pitch.

### Ameaças
- **Churn silencioso:** Valdece pode não usar sem saber que poderia. 30 dias de Hypercare sem dado de uso = Loop 8 com nenhuma inteligência real.
- **Scope creep via WhatsApp:** personalização de logo OAB já foi sinalizada. Sem Change-Order formalizado, erosão de margem silenciosa.
- **Embedding Gemini:** modelo pode mudar dimensionalidade novamente (já aconteceu: 768→3072). Re-embedding de 61 acórdãos = custo não nulo.

---

## PDCA — AVALIAÇÃO DO LOOP 7

### PLAN (o que foi planejado)
- V3 ENRICHMENT: ALTER TABLE + classify_v3_fields + reingest 61 acórdãos
- Fix HV-1: GEMINI_API_KEY para proxy Netlify
- Deploy Netlify V3 em produção
- Embaixador Loop 7: DECISOES D1–D6

### DO (o que foi executado)
- ✅ Todos os itens planejados entregues
- ✅ reingest 61/61 · 0 erros · gate_v3 APROVADO (vinculantes=3 · pleno=5 · turma=56)
- ✅ HV-1 resolvido: proxy embed.js + netlify.toml + env vars configuradas
- ✅ Deploy 11s: proxy 200 OK · vetor 3072 dim
- ✅ Embaixador: DECISOES D1–D6 executados · MEMORIA_EMBAIXADOR atualizada
- ⚠️ Descoberta: classify_v3_fields inicial classificava RE/ARE STF incorretamente → fix aplicado (EC 45/2004)

### CHECK (o que funcionou e o que não funcionou)
- **Funcionou:** pipeline reingest automatizado (61/61 sem erro)
- **Funcionou:** proxy Netlify resolveu HV-1 sem afetar UX do Valdece
- **Funcionou:** view_diretor_roi como gate de validação do enrichment
- **Não funcionou:** classify_v3_fields não contemplava a regra EC 45/2004 para RE/ARE → corrigido na mesma sessão
- **A investigar:** Valdece ainda não confirmou uso real após receber o sistema V3

### ACT (o que muda no próximo loop)
- Confirmar uso real como gate mandatório para Loop 8 (sem dado = Loop 8 sem contexto real)
- Incluir teste de threshold no Sentinel Report (query Valdece mais recente → similaridade medida)
- Documentar regra EC 45/2004 no runbook de ingestão para novos acórdãos RE/ARE

---

## 5W2H — PRÓXIMO LOOP (Loop 8)

| Dimensão | Resposta |
|---|---|
| **What** | Sentinel Report + confirmação de uso real + pitch V2 se sinais certos + migração Supabase |
| **Why** | Hypercare termina em 30 dias — sem dado de uso, não há argumento para V2 nem para indicação OAB |
| **Who** | Eduardo + Músculo · Valdece (passivo — recebe Sentinel Report) |
| **When** | Sentinel em 02-06-2026 (terça-feira) · Loop 8 build a partir de 03-06-2026 |
| **Where** | toga-digital-valdece.netlify.app · Supabase Vanguard (pré-migração) |
| **How** | Sentinel via WhatsApp curto → aguardar resposta → análise de temperatura → deliberação |
| **How much** | ~1h Sentinel · ~4h migração Supabase · $0 custo adicional de infra |

---

## 5 IDEIAS DISRUPTIVAS [M-1 a M-5] — Para o Gemini processar

**[M-1] Modo Audiência com Destaque de Vinculantes**
Interface simplificada para uso em tempo real: texto grande + badge VINCULANTE em vermelho destacado + botão "Copiar para petição" com 1 toque. Agora que V3 está ativo, esse modo fica exponencialmente mais poderoso. Valdece usa o sistema em audiências — o badge VINCULANTE resolve objeções do juiz antes de serem feitas.

**[M-2] Relatório Mensal Automático**
No dia 1 de cada mês: "Você fez N buscas. Seus temas favoritos foram X, Y, Z. Seu acórdão mais buscado foi [título]." Gerado por Edge Function + enviado por email. Eduardo não digita nada. Impacto: retenção emocional + argumento quantitativo para V2.

**[M-3] Detector de Lacuna no Corpus**
Se similaridade máxima < 0.40 em qualquer busca → alerta automático ao Valdece: "Esse tema não está bem coberto. Quer que eu adicione acórdãos?" Eduardo recebe o alerta no Telegram antes de Valdece. Impacto: corpus evolui por uso real, não por intuição.

**[M-4] Export DOCX em Bloco com Classificação V3**
Selecionar N resultados → gerar DOCX com blocos ABNT numerados + tag [VINCULANTE] onde aplicável. Hoje Valdece copia 1 de cada vez. Com 3 acórdãos vinculantes numa petição, são 3 copias manuais. Economiza 10+ minutos por petição complexa.

**[M-5] Portfólio de Uso pós-Hypercare**
Após 30 dias: gerar PDF — "Valdece realizou N buscas · M temas cobertos · 3 acórdãos vinculantes utilizados." Serve como prova social para o próximo cliente LegalTech-Penal e como argumento emocional de renovação/V2: "Olha o que você construiu."

---

## ANÁLISE COMERCIAL

**O que este loop significou para o negócio:**
Loop 7 elevou o produto de "buscador de jurisprudência" para "filtro de precedentes com classificação de autoridade." A distinção vinculante/pleno/turma não é cosmética — é a diferença entre um precedente que o juiz pode ignorar e um que ele é obrigado a seguir. Para criminalistas, isso é argumento de defesa, não feature de software.

**Risco principal:** 5+ dias sem check-in pós-assinatura. O produto está em produção mas sem evidência de uso. Sentinel Report 02-06 é o único ponto de contato controlado antes do fim do Hypercare. Se Valdece não tiver usado, o pitch V2 não tem fundamento.

**Oportunidade imediata:** Pipeline OAB (D6) está ativo. A próxima vez que Valdece mencionar um colega criminalista → pergunta pronta, sem fricção, sem improv. A indicação certa vem de uso genuíno — confirmar isso no Sentinel é pré-requisito.

---

*Músculo — Pentalateral IAH — 2026-05-26*
