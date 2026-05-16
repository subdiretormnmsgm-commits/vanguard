# SKILL: skill_proj002_ingrid_loop1
**Camada:** 2 (Produto) | **Prazo:** 15 dias | **Deploy:** PWA + Supabase + Claude API

## 📋 CONTEXTO DO PROJETO
Aplicativo de estudo imersivo para o Concurso Sedes-DF (Banca Quadrix, cargo TDAS), desenhado para mitigar o esgotamento cognitivo em 114 dias de preparação. O app focará na entrega de um plano adaptativo (Feed Diário) com base em pesos do edital (Específicos = Peso 2) e geração de questões proprietárias.

## 🛡️ PADRÕES E ALERTAS (INTELLIGENCE LEDGER)
*   **[P-003] (Zero Scraping):** Absolutamente proibido criar integrações com TEC Concursos ou QConcursos. As questões devem ser nativas, geradas pela API.
*   **[P-006] (Burn Rate Shield / Lei 5):** Limite diário de API obrigatório. Não gere questões "on-the-fly" repetidas. Use estratégia de *Geração + Caching* no Supabase.
*   **[P-007] (Mágico de Oz Gate):** O motor de geração (Claude API) deve ser validado puramente via CLI no Dia 2. O Diretor deve aprovar a qualidade da questão estilo Quadrix antes do build da UI PWA avançar.
*   **[P-010] (Gate por Dia):** Não avance para a próxima funcionalidade sem um output real verificado.
*   **[P-013] (Soberania):** Supabase e repositório na conta da usuária. Criar `OFFBOARDING_RUNBOOK.md` no handoff.

## ⚙️ SEQUÊNCIA TÁTICA DE BUILD (15 DIAS)
1.  **Dias 1-2 (Motor de IP):** Setup Supabase (tabelas `questoes_quadrix` e `progresso_usuario`). Integração Claude API (Edge Function). Mágico de Oz Gate via CLI para testar output de questões Múltipla Escolha.
2.  **Dias 3-8 (Feed Adaptativo):** Lógica do calendário até 06/09/2026. Algoritmo de roteamento focando em disciplinas Peso 2 (Conhecimentos Específicos). UI do Feed diário fechado (ex: "Hoje: 20 questões de LOMDF").
3.  **Dias 9-12 (PWA & Execução):** Interface de resolução de questões simples. Cálculo imediato de certo/errado e salvamento na tabela de progresso.
4.  **Dias 13-15 (Heatmap & Handoff):** UI Recharts verde/amarelo/vermelho indicando lacunas de sobrevivência. Implementação das 7 Leis (Sovereign Pixel, Consentimento, Kill-Switch, etc).

## 🚫 O QUE NÃO CONSTRUIR
*   Não construa geração 100% "on-the-fly" de descarte; guarde as questões no DB.
*   Não construa calendários "drag & drop". A IA e o tempo disponível ditam a meta, o usuário executa.
*   Não construa painéis de comparação preditiva ou gamificação complexa (perfis, emblemas, XP).
*   Não construa sistemas de Auth complexos. Autenticação single-user (ou Magic Link) no MVP.