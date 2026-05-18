 SKILL: skill_ingrid_v2.md
**Camada:** 2 (Produto - Dias 6 a 8) | **Loop:** #3 | **Stack:** PWA Vanilla JS + Supabase + Claude API

## 📋 CONTEXTO DO PROJETO
O projeto "Ingrid" entra na fase de Frontend. O banco Supabase já contém 460 questões validadas do Cargo 202 - Técnico Administrativo (Peso 2: Dir. Administrativo, Constitucional, Arquivologia, Rec. Materiais). O foco absoluto dos Dias 6-8 é eliminar a fricção de latência. Ingrid deve abrir a PWA e, em < 2 segundos, estar respondendo a meta diária (70% Específicos / 30% Gerais). 

## 🛡️ PADRÕES E ALERTAS DE VETO (INTELLIGENCE LEDGER)
*   **[P-003] (Zero Scraping):** Os dados vêm exclusivamente do banco populado pela API Claude. Proibido tentar buscar dados externos no frontend.
*   **[P-006] (Burn Rate Shield):** O Tutor Socrático DEVE obrigatoriamente possuir um cache local ou no Supabase (`explicacao_tutor`). Não chame o Claude Haiku duas vezes para o mesmo erro.
*   **[P-010] (Gate por Dia):** O Músculo não avança para o Dia 7 sem renderizar o HTML estático no Dia 6 e ter a aprovação visual do Diretor Eduardo (botões e tipografia mobile-first).
*   **[HV-1 a HV-6] (deploy_guard):** Nenhuma credencial de API (.env) deve subir em commit do PWA. A Soberania do Cliente [P-013] e a ausência de infra prisioneira são inegociáveis.

## ⚙️ SEQUÊNCIA DE BUILD (DIAS 6-8)
1.  **Dia 6 (Esqueleto PWA UI):** Construir o esqueleto em HTML/CSS/JS (Vanilla). Foco mobile-first. **GATE:** Eduardo testa o layout estático no próprio celular para aprovação de UX.
2.  **Dia 7 (Conexão Supabase & Roteamento):** Conectar a View de `questoes_nao_respondidas` via Supabase JS. Implementar a lógica de meta diária (apenas 1 barra de progresso simples, ex: "Questão 4 de 20").
3.  **Dia 8 (Tutor Socrático + Fallback):** Conectar as respostas incorretas à Edge Function do Tutor (Haiku). Implementar salvamento e leitura do cache de explicações. Implementar o Modo Express (5 questões) ativado quando o consumo atingir 70% do orçamento.

## 🚫 O QUE NÃO CONSTRUIR
*   **NÃO** utilize React, Vue, Redux ou frameworks pesados.
*   **NÃO** construa IndexedDB complexo para cache offline (gera dívida técnica desnecessária no prazo de 15 dias).
*   **NÃO** incorpore TTS (Web Speech API) ou áudio agora (Veto por [P-016]).
*   **NÃO** construa Gráficos analíticos pesados (Recharts) ou 6 barras de progresso na tela inicial. A tela deve ser 1 clique para estudar.
*   **NÃO** implemente `visibilitychange` listeners (Dark Patterns).
PARTE 4 — 5 Ideias Disruptivas do Auditor