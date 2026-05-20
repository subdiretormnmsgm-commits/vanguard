SKILL: ingrid-v2.md
**Camada:** 2 (Produto - Dias 6 a 8) | **Loop:** #3 | **Stack:** PWA Vanilla JS + Supabase + Claude API

## 📋 CONTEXTO DO PROJETO
PROJ-002 (Ingrid). O banco Supabase contém 460 questões validadas do Cargo 202 (Técnico Administrativo). A usuária é não-técnica, focada, e possui ~111 dias até a prova da Quadrix. O objetivo dos Dias 6-8 é entregar uma Interface PWA mobile-first ultra-rápida, com Tutor Socrático (Haiku) cacheado e Fallback de Fadiga, integrando âncoras emocionais de UX (Frases de abertura e encerramento).

## 🛡️ PADRÕES E ALERTAS DE VETO (INTELLIGENCE LEDGER)
*   **[P-006] Burn Rate Shield:** O limite é $5,00/dia. O Fallback de Fadiga (corte de API aos 70%) é inegociável.
*   **[P-010] Gate Verificável:** O fluxo é Mock → Supabase → Tutor. Não conecte o Supabase sem o Diretor aprovar o layout estático no celular.
*   **[P-023] BLOQUEIO COMERCIAL:** O aplicativo PWA NÃO pode ser entregue à Ingrid (Gate Dia 8) até que a variável de aceite do Termo de Uso esteja confirmada.
*   **[P-031] Filtro de Realidade:** A usuária repele jargão técnico e UI complexa. A interface deve ser focada em 1 clique para estudar.

## ⚙️ SEQUÊNCIA DE BUILD (DIAS 6-8)
1.  **Dia 6 (UI Mockada + UX Passiva):** Construir o esqueleto em HTML/CSS/JS (Vanilla). Incluir barra de progresso visual focada apenas no Peso 2 (Administrativo, Constitucional, etc.). Inserir os placeholders para a Frase de Abertura (E-2) e Encerramento (E-5). Auth hardcoded via `user_id`. **GATE:** Aprovação visual do Diretor via URL local.
2.  **Dia 7 (Supabase + Tutor Socrático):** Conectar à view `questoes_nao_respondidas`. Implementar a Edge Function do Tutor (sem ser um monólito). O Tutor checa primeiro o cache no Supabase (`explicacao_tutor`); se não houver, chama o Claude Haiku. Implementar a coleta silenciosa do Pixel de Latência (G-3) no POST de resposta.
3.  **Dia 8 (Fallback Fadiga + Trava de Contrato):** Implementar kill-switch de API ao bater 70% da cota, acionando o Fallback de texto passivo. **GATE:** Homologação do PWA, sujeito à verificação de assinatura do Termo de Uso.

## 🚫 O QUE NÃO CONSTRUIR
*   **NÃO** construa sincronização offline complexa (IndexedDB vetado).
*   **NÃO** inclua recursos de áudio ou Web Speech API (Veto por P-016 e P-031).
*   **NÃO** crie modais interruptivos de antievasão ("Dark Patterns").
*   **NÃO** crie uma Edge Function única/monolítica para tudo.
*   **NÃO** altere a fórmula original do algoritmo SM-2 neste ciclo (apenas colete os dados de latência).
PARTE 4 — 5 Ideias Disruptivas do Auditor
Estas são intervenções exclusivas voltadas à segurança corporativa, otimização técnica e 



 Sequência correta ao fechar o Loop 3:

  1. Músculo → MEMORIA + Relatório + [M-1 a M-5]
          ↓
  2. Gemini → reage às [M-1 a M-5] + gera DIRETRIZ + [G-1 a G-5]
          ↓
  3. Auditor → audita tudo + gera nova Skill + [N-1 a N-5]

  4. Músculo →  
    · O que é inviável no prazo real
    · O que contradiz decisões já tomadas
    · O que precisa de ajuste antes de chegar ao cliente
    . Sugere ideias disruptovas
          ↓
  6. Embaixador → CONFIRMA / EXPANDE / ALERTA
     cada uma das 15 ideias [M+G+N]
     + gera [E-1 a E-5] com base no comportamento real da Ingrid. Ele pode atuar em outras áreas, de modo a ampliar a sua capacidade, não tão somente no comportamento de Ingrid
          ↓
  6. Diretor → veredito final