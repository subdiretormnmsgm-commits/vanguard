# SKILL: ingrid-v6 · SaaS Readiness & Telemetria Comportamental
# Status: Ativa · Guardião: Músculo · Protocolo: Pentalateral IAH

## 1. CONTEXTO OPERACIONAL
- **Cliente:** Ingrid | Projeto Piloto Base Era V25
- **Escopo Ativo:** Loop 4 — SaaS Readiness + Heatmap + Simulado Dominical + Handoff
- **Deadline de Código:** 2026-05-30 | Dias Restantes: ~10 dias
- **Stack Tecnológica:** PWA Vanilla JS (Live no GH-Pages) + Supabase Multi-tenant Isolation + Claude API (Haiku/Sonnet)

## 2. GATES DE VALIDAÇÃO SEQUENCIAL
- **GATE DIA 10 (Mágico de Oz de Ingestão):** Confirmação via console do Supabase de que cada resposta da Ingrid está populando corretamente os campos `tempo_interacao_tti`, `distrator_escolhido` e `nivel_tutor_acionado` sem perda de pacotes móveis.
- **GATE DIA 12 (Simulado Blindado - P-039):** Execução do motor de geração do Micro-Simulado Quadrix composto por 70% matérias de peso específico (Sonnet) e 30% gerais (Haiku) com renderização offline garantida por cache local de 100% das questões selecionadas.
- **GATE DIA 15 (SaaS Readiness Audit & Handoff):** Apresentação do "Resumo da Entrega" de 1 página + exportação limpa do `OFFBOARDING_RUNBOOK.md` provando isolamento absoluto de infraestrutura.

## 3. ALERTAS ATIVOS E CIRCUIT BREAKERS
- **[ALERTA-LATÊNCIA-QUADRIX]:** Se o processamento da Edge Function para avaliar a curva de erro demorar mais que 8.0s devido à instabilidade de rede móvel da usuária, o PWA deve disparar o fallback rígido de degradação graciosa (`explicacao_base` em cache local) para impedir o abandono por quebra de fluidez.
- **[CIRCUIT-BREAKER-BURN-RATE]:** Hard limit de USD 5.00/diário no console Anthropic ativado. Se o seed de expansão para as 1.000 questões estourar a janela de custo marginal, o script `seed_questoes.ps1` é abortado automaticamente com erro explícito de limite de créditos.

## 4. RESTRIÇÕES RÍGIDAS (O QUE NÃO CONSTRUIR)
- NUNCA implementar gateway de pagamento real (Stripe/Asaas) neste repositório.
- NUNCA quebrar a arquitetura de 1 Edge Function por invocação.
- NUNCA expor as tabelas de `PERFIS_NICHO` (Trade Secret da Vanguard) fora do esquema restrito de banco.
