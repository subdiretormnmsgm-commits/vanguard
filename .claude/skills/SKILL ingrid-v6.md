# SKILL: ingrid-v6.md
**Camada:** 2 (Produto - Dias 12 a 13) | **Loop:** #5 | **Stack:** PWA Vanilla JS + Supabase RPC + WhatsApp API

## 📋 CONTEXTO DO PROJETO
PROJ-002 (Ingrid). Status: LIVE. Temperatura: VERDE FRÁGIL. Foco absoluto: Implementar o Contador de Pontos Ponderados (Fórmula Quadrix: Acertos Específicos × 2 + Básicos × 1 - Erros Totais) e garantir o Micro-Simulado Dominical sem atritos no iOS Safari. Deadline de entrega final: 30/05/2026.

## 🛡️ PADRÕES E ALERTAS DE VETO (INTELLIGENCE LEDGER)
*   **[P-045] Veto de Barreira:** Zero interfaces de login/senha complexas para a usuária piloto. Acesso via `user_id` embutido.
*   **[P-038] Reciclagem Obrigatória:** O Micro-Simulado Dominical NÃO PODE drenar questões inéditas do banco. O motor DEVE puxar exclusivamente questões já indexadas pelo SM-2, priorizando as de maior índice de falha (Easiness Factor < 2.0).
*   **[P-044] Escudo Psicológico de UI:** A pontuação punitiva (erros anulam acertos) NÃO deve ser renderizada em cor de alerta (vermelho vivo) se o score for negativo. Exiba a métrica como "Território a Conquistar".
*   **[P-023] Trava Contratual (SHIELD):** Utilize o "Widget Unclog" (G-4). O Contador de Pontos Ponderados fica visualmente desfocado (blur) até que a usuária clique no banner de confirmação da nova data do Termo de Uso (18/05), persistindo a ação via RPC no Supabase.

## ⚙️ SEQUÊNCIA DE BUILD (DIAS 12-13)
1.  **Dia 12 (Backend RPC & Fallback WhatsApp):** Construir a *Stored Procedure* (RPC) no Supabase que emite o Score Quadrix em tempo real. Codificar a string parametrizada (wa.me/...) no Dashboard do Diretor para o "WhatsApp Shield".
2.  **Dia 13 (UI Diário Oficial & Spike de Push):** Renderizar o widget do Contador Ponderado no PWA, emulando a diagramação em colunas de um Diário Oficial do DF [G-2]. Rodar um *Spike* técnico de Web Push no Service Worker; **SE** a permissão for negada pelo Safari iOS no primeiro teste, aborte a feature e utilize 100% o Fallback de WhatsApp.

## 🚫 O QUE NÃO CONSTRUIR
*   **NÃO** ultrapasse 2 horas debugando permissões de Web Push em Safari mobile. O "Mágico de Oz" via WhatsApp atende à necessidade funcional com risco zero.
*   **NÃO** altere a matriz matemática do algoritmo SM-2 [Veto à ideia G-3].
*   **NÃO** construa botões paralelos de reset de progresso do simulado (preservar telemetria histórica).
PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR
Como guardião do histórico e defensor do moat da Vanguard, trago inovações puras baseadas nos precedentes: