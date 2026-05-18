# SKILL: skill_ingrid_v2.md
**Camada:** 2 (Produto - Dias 6 a 8) | **Loop:** #3 | **Stack:** PWA Vanilla JS + Supabase + Claude API

## 📋 CONTEXTO DO PROJETO
Projeto Ingrid (PROJ-002). O banco Supabase já possui 460 questões validadas para o Cargo 202 (Técnico Administrativo), priorizadas por escore de incidência histórica. O objetivo dos Dias 6-8 é construir a Interface Mobile, o Tutor Socrático (Haiku) e o Fallback de Fadiga, garantindo um "Caminho Feliz" que seja mobile-first e sem atritos.

## 🛡️ PADRÕES E ALERTAS DE VETO (INTELLIGENCE LEDGER)
*   **[P-003] Zero Scraping:** O app consome exclusivamente do nosso Supabase. Nenhuma conexão com plataformas externas.
*   **[P-006] Burn Rate Shield:** O limite é de $5,00/dia. O "Fallback de Fadiga" deve ser ativado graciosamente se o consumo chegar a 70%.
*   **[P-010] Sequência Obrigatória:** M-15 aprovado. O fluxo deve ser Mock -> Supabase -> Tutor. Não pule para a integração de dados reais sem validar a renderização dos mocks na UI.
*   **[P-024] Validação de Cargo:** Garantir que todo conteúdo retornado pela UI reflete estritamente as disciplinas do Cargo 202 (Dir. Administrativo, Constitucional, etc.).

## ⚙️ SEQUÊNCIA DE BUILD (DIAS 6-8)
1.  **Dia 6 (UI Mockada + Debug):** Desenvolver o layout HTML/CSS/JS (Vanilla). Foco mobile. Implementar o *Debug Mode* (`?debug=true` na URL) aprovado em M-12 para facilitar a inspeção do Diretor no celular. Auth fixado via hardcode do `user_id` (M-14).
2.  **Dia 7 (Supabase + Feedback Socrático):** Conectar com a view `questoes_nao_respondidas`. Integrar o Tutor Socrático com memória de erro: 1º erro (conceito), 2º erro (ataca distrator), 3º erro (analogia). Implementar o Cache Inteligente de Explicações (explicacao_tutor).
3.  **Dia 8 (Revisão Express + Fallback):** Implementar o Modo Revisão Express (5 minutos) puxando as 5 questões SM-2 mais prioritárias e vencidas. Configurar o fallback passivo para gatilho de 70% da cota.

## 🚫 O QUE NÃO CONSTRUIR
*   **NÃO** construa uma Edge Function única/monolítica (Modificação de M-11 acatada).
*   **NÃO** altere a matriz matemática central do SM-2 com o tempo de latência neste MVP (M-13 adiado para V2).
*   **NÃO** implemente sincronização offline via IndexedDB ou Áudio via Web Speech API.
*   **NÃO** construa sistemas de login/auth.