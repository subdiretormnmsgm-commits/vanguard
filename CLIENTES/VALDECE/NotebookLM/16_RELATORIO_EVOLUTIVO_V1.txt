# RELATÓRIO EVOLUTIVO V1 — PROJETO VALDECE
**Iteração:** V1 (Dias 1–2 de 5)
**Data:** 2026-05-13
**Gerado por:** Músculo (Claude Code)

---

## ANÁLISE DE NEGÓCIO

### Pontos Fortes desta Iteração
- **Infraestrutura soberana desde o Dia 1:** Kill-Switch, Burn Rate Shield e Sovereign Pixel construídos antes de qualquer feature — padrão que protege o projeto de custos descontrolados e outages
- **Corpus de dados públicos:** STF Open Data elimina dependência de terceiros (reforça P-003) — o ativo é nosso
- **Mágico de Oz Gate:** decisão arquitetural que economiza potencialmente 2 dias de build se o corpus for ruim — o gate não deixa construir UI em cima de motor semântico inválido

### Pontos de Atenção
- **Corpus real ainda não testado:** até o gate rodar com credenciais reais, o GO/NO-GO do Dia 2 está pendente — maior risco do projeto
- **API STF Open Data não documentada formalmente:** sem garantia de SLA — fallback CSV deve ser comunicado ao Valdece no handoff
- **Single-user por ora:** Auth está no schema mas não implementado no frontend — Dia 4 pode ser apertado se Auth for complexo

### Avaliação do Consultor
A stack Vanilla JS + Supabase foi a decisão certa para o deadline de 5 dias. A alternativa Next.js adicionaria 1–2 dias de setup sem benefício real para o MVP. O risco principal agora é o corpus: se o STF Open Data retornar poucos acórdãos penais relevantes, o Dia 2 precisa de um CSV de backup com acórdãos manuais — o Diretor deve validar isso com o Valdece antes do Dia 3.

---

## [VISÃO LMM] — 5 IDEIAS DISRUPTIVAS PARA O GEMINI REAGIR

### IDEIA 1 — Corpus Ativo: o sistema aprende com cada busca do Valdece
**O que é:** Cada query do Valdece que retorna resultado relevante (marked_relevant=true no search_logs) alimenta automaticamente um ranking de "acórdãos mais úteis". Com 30 dias de uso, o sistema sabe quais jurisprudências o Valdece usa mais para cada tipo de caso.

**Impacto comercial:** Transforma a ferramenta de buscador passivo em consultor ativo. "Para casos de tráfico com réu primário, o STF mais citado pelo Valdece é o HC 123.456." Diferencial brutal em Legal Tech.

**Complexidade:** Baixa — search_logs já existe. É uma view + um endpoint.

**Para o Gemini reagir:** Isso muda o pitch para o Valdece? Vale mostrar no handoff como "feature que ativa no mês 2"?

---

### IDEIA 2 — Sentinel Automático: alerta quando STF publica nova jurisprudência relevante
**O que é:** n8n monitora o feed público do STF diariamente. Quando detecta acórdão de Direito Penal novo, insere no corpus, gera embedding e envia WhatsApp/email para o Valdece: "Novo acórdão do STF sobre prisão preventiva publicado hoje."

**Impacto comercial:** Transforma assinatura de R$X/mês em sistema de inteligência proativa. O Valdece não busca — recebe. MRR justificado automaticamente.

**Complexidade:** Média — n8n + cron + ingest.py já existe. Feature Flag sentinel_enabled=false já está no schema.

**Para o Gemini reagir:** Este é o argumento para o MRR do retainer? Quando ativar — Mês 1 ou Mês 2?

---

### IDEIA 3 — Síntese Automática: resumo do acórdão em linguagem do advogado
**O que é:** Quando o Valdece clica num resultado, o sistema chama Gemini Pro para gerar um resumo em 3 parágrafos: (1) Contexto do caso, (2) Tese do STF, (3) Como aplicar na defesa. Feature Flag sintese_enabled=false já está no schema esperando.

**Impacto comercial:** O que levaria 20 minutos de leitura vira 30 segundos. Cada síntese gerada é um token de custo — justifica Camada 2 de preço no futuro.

**Complexidade:** Baixa — Gemini Pro API + prompt já desenhado. Unlock quando Valdece confirmar interesse.

**Para o Gemini reagir:** Isso entra no pitch do handoff como "próxima versão" ou é surpresa para o Dia 30?

---

### IDEIA 4 — White-Label: o sistema do Valdece vira produto para outros advogados
**O que é:** O Valdece usa a ferramenta e gosta. No mês 3, ele nos apresenta 2 colegas da OAB. Em vez de construir do zero, fazemos white-label: cada advogado tem seu corpus separado (RLS por user_id já no schema), seu próprio branding, e paga MRR separado. Nós ficamos com 20% de cada um.

**Impacto comercial:** Primeiro cliente vira canal de distribuição. Se o Valdece nos indica 5 colegas, o projeto que começou como R$5.000 gera R$X × 5 em MRR recorrente.

**Complexidade:** Baixa — a arquitetura já suporta. É onboarding + billing por tenant.

**Para o Gemini reagir:** Como estruturar a proposta de parceria com o Valdece para isso? Contrapartida diferente?

---

### IDEIA 5 — Painel do Diretor: dashboard de uso para o Valdece ver o valor em tempo real
**O que é:** Aba simples no app que mostra: queries realizadas este mês, acórdãos mais consultados, tempo economizado estimado (queries × 20min/busca manual), custo do sistema este mês. O Valdece vê o ROI do investimento todo dia.

**Impacto comercial:** Elimina o maior risco de churn — o cliente esquecer que usa a ferramenta. Um painel que mostra "você economizou 14 horas este mês" é argumento de renovação automático.

**Complexidade:** Baixa — é uma view no Supabase + 1 página no frontend. search_logs e token_usage já têm os dados.

**Para o Gemini reagir:** Este painel entra no MVP do Dia 3 ou é feature do mês 1 pós-entrega?

---

## PARA O PRÓXIMO CICLO

**O que o Gemini precisa decidir:**
1. Das 5 ideias acima — quais entram no handoff do Dia 5 como "roadmap"?
2. O painel de uso (Ideia 5) entra no MVP ou é pós-entrega?
3. O argumento de MRR (Sentinel + Síntese) — como apresentar ao Valdece no handoff?
4. A estratégia de white-label — comunicar agora ou aguardar 30 dias de uso?

**O que está em risco se não decidirmos:**
- Dia 3 começa sem saber se Painel (Ideia 5) entra no frontend — pode adicionar 1 dia
- Sem roadmap no handoff, o Valdece não vê o caminho para o MRR — churn em 3 meses
