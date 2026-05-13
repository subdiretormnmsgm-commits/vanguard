# RELATÓRIO EVOLUTIVO V2 — PROJ-001 VALDECE
# A ser gerado no Dia 5 após entrega completa
# Frameworks aplicados: SWOT + PDCA + 5W2H integrados

---

## 0. CONTEXTO DA ENTREGA

- **Projeto:** Buscador Semântico de Jurisprudência STF/STJ
- **Cliente:** Valdece (advogado criminalista)
- **Stack:** Vanilla JS + Supabase pgvector + Gemini embedding-004
- **Ciclo:** Loop 1 (Dias 1-2) + Loop 2 (Gate Dia 3) + Loop 3 (Entrega Dia 5)
- **Modelo:** Opção A — soberano, sem MRR, R$1,20/mês no API de Valdece

---

## 1. PDCA — O QUE O LOOP ENTREGOU

### PLAN — O que foi planejado
*(Gemini DIRETRIZ V2 + NotebookLM SKILL V2 — preencher no Dia 5)*
- Prioridades da DIRETRIZ que entraram
- Prioridades que foram descartadas ou movidas para V2
- O que o Auditor alertou que foi validado em campo

### DO — O que foi construído
*(preencher no Dia 5 com o que foi efetivamente entregue)*
- Dia 1: Schema pgvector + Burn Rate Shield + Kill Switch
- Dia 2: ingest.py + search_cli.py
- Dia 3: Gate OK + tema column + corpus_gap + UI core
- Dia 4: Drafting Reverso + Badge RECENTE + Painel 3 números + Feedback + Circuit Breaker
- Dia 5: Auth + Edge Function cron + Sovereign Playbook + migração para ambiente Valdece

### CHECK — O que foi validado
*(preencher com resultado dos testes do Dia 5)*
- Gate Semântico: X/5 queries com similarity ≥ 0.65
- Burn Rate Shield: testado / não testado
- Kill Switch: testado / não testado
- Modo Tático: testado / não testado
- Auth: testado / não testado
- Edge Function: testado / não testado
- Mobile: testado / não testado

### ACT — O que alimenta o próximo ciclo
*(5 ideias disruptivas do Músculo — preencher no Dia 5)*
1. [Ideia 1]
2. [Ideia 2]
3. [Ideia 3]
4. [Ideia 4]
5. [Ideia 5]

---

## 2. SWOT — ESTADO DO PROJETO NA ENTREGA

### Forças
- Motor semântico em linguagem jurídica — não é busca por palavras-chave
- Modo Tático (Drafting Reverso) — diferencial sem equivalente no Brasil
- Soberania total: dados de Valdece ficam com Valdece
- Auto-atualização semanal sem intervenção humana
- Custo operacional de R$1,20/mês — zero fricção de renovação

### Fraquezas
*(preencher no Dia 5 com o que ficou para trás)*
- Corpus inicial limitado (100 docs STF — STJ ainda fora)
- tema classificado apenas por ementa, não por voto completo
- Sem analytics de jurista (quais temas Valdece mais busca)
- Sovereign Upload (PDF de petições) não entrou nesta versão

### Oportunidades
- Valdece é o ponto zero de uma rede OAB — cada colega que ele mostrar é um lead qualificado
- Radar de Divergência (V2) priceable a R$397/mês — corpus de 500+ docs ativa o produto
- Sovereign Upload cria lock-in emocional: o sistema aprende com as petições de Valdece
- Legal Tech no Brasil está 5 anos atrás do mercado norte-americano — janela aberta

### Ameaças
- STF pode mudar a estrutura da API Open Data (risco: médio, mitigação: CSV fallback)
- Corpus pequeno no início pode frustrar na primeira busca exótica
- Gemini pode alterar preços de embedding (risco: baixo, mas monitorar)
- Concorrente com corpus maior pode aparecer (janela de 6-12 meses)

---

## 3. 5W2H — PLANO DA V2 (RADAR DE DIVERGÊNCIA)

### WHAT — O que será feito
Radar de Divergência: sistema que detecta quando o STF mudou de entendimento
num tema específico e alerta Valdece antes que ele cite jurisprudência desatualizada.

### WHY — Por que isso gera valor
Uma jurisprudência ultrapassada numa peça pode custar o caso.
Valdece não tem tempo de monitorar mudanças de entendimento manualmente.
O sistema faz isso por ele — e isso vale R$397/mês.

### WHO — Quem executa
- Músculo: build do comparador temporal + UI de alertas
- Diretor: vender a assinatura V2 a Valdece após 30 dias de uso da V1
- Valdece: corpus precisa crescer para 500+ docs para ativar a feature

### WHERE — Em qual módulo
- Layer B: job de comparação temporal (backend, Supabase Edge Function)
- Layer C: painel de alertas na UI (nova aba "Radar" no index.html)
- tema column já está no banco — é a fundação

### WHEN — Em qual prazo
- Gatilho: corpus atingir 500 documentos (monitorar via Painel do Diretor)
- Estimativa: 30-45 dias após entrega da V1
- Proposta comercial: apresentar no primeiro retorno com Valdece (2 semanas)

### HOW — Como será construído
- Layer B: query SQL que agrupa docs por tema + calcula centroide de embedding por período semestral
- Drift = distância cossenoidal entre centroide atual e centroide 12 meses atrás
- Threshold de alerta: drift > 0.15 (calibrar com corpus real)
- Layer C: card "⚠️ Entendimento pode ter mudado — ver decisões recentes" na UI

### HOW MUCH — Custo estimado
- Build: ~16h (Layer B: 8h, Layer C: 8h)
- API: ~$0.05 extra/mês (job semanal sobre corpus de 500 docs)
- Receita potencial: R$397/mês por cliente Premium
- Break-even: 1 cliente V2 paga 331 meses de custo operacional

---

## 4. INSIGHTS PARA O SKILL_PROTOCOLO_VANGUARD

*(preencher no Dia 5 — o que deste projeto vira padrão universal)*

- [ ] Token Rate Shield como pré-requisito de qualquer projeto IA (já em P-006)
- [ ] Mágico de Oz Gate como protocolo de validação de corpus antes de UI
- [ ] Roteiro de Campo para onboarding de cliente não-técnico
- [ ] Opção A (soberano, sem MRR) como modelo de relacionamento fundacional (P-008)
- [ ] SWOT + PDCA + 5W2H integrados como formato do relatorio_evolutivo de cliente

---

## 5. PRÓXIMOS PASSOS DO DIRETOR

*(preencher no Dia 5)*
1. Validar relatório e extrair insights para o Gemini
2. Executar Loop 3: levar MEMORIA_V2 + relatorio_evolutivo_V2 + 5 ideias ao Gemini
3. Agendar retorno com Valdece em 2 semanas para apresentar proposta V2
4. Atualizar WIP_BOARD.json: PROJ-001 → "Entregue | V2 em pipeline"
