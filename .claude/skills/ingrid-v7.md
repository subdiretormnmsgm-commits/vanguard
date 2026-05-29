# SKILL: ingrid-v7 · SaaS Readiness & Commercial Pipeline
# Status: Ativa · Guardião: Músculo · Protocolo: Pentalateral IAH
# Gerada: NotebookLM 2026-05-29 · Loop 6 (Gemini V7)

## 1. CONTEXTO OPERACIONAL
- **Cliente:** Ingrid | Projeto Piloto — Concurso Sedes-DF (Cargo 202 · Quadrix)
- **Escopo Ativo:** Loop 6 — SaaS Readiness + Ativação do Pipeline Comercial
- **Estado do app:** v20 live — GitHub Pages ativo · 7 features Loop V6 entregues (F-1 a F-8)
- **Stack Tecnológica:** PWA Vanilla JS + Supabase próprio (yjqvjhezwhepwomukudt) + Claude API (Haiku)
- **Temperatura:** VERDE SUSTENTADO 7.5/10 · "Gostei bastante. Amanhã volto para atacar mais"
- **DADOS-WATCH:** VERDE — 102 registros · 1 user_id · SM-2/Heatmap/Termômetro íntegros
- **Prova final:** 2026-09-06

## 2. GATES DE VALIDAÇÃO SEQUENCIAL
- **[GATE 01 — INFRA BLOQUEANTE]:** Execução de `! supabase login` + `supabase functions deploy --project-ref yjqvjhezwhepwomukudt`. F-4 (cron 19h45) e F-6 (relatório semanal WhatsApp) devem rodar em nuvem — eliminar Mágico de Oz manual de Eduardo.
- **[GATE 02 — CI/CD]:** Desbloqueio do push no GitHub Security (secret revogado, unblock pendente) para normalizar fluxo deploy gh-pages.
- **[GATE 03 — COMERCIAL]:** Injeção do Script E-4 pelo Diretor no WhatsApp da Ingrid: "Quando você passar, vou ter o sistema pronto para quem você indicar." Plantar agora — colher quando ela passar.

## 3. ALERTAS ATIVOS E CIRCUIT BREAKERS
- **[ALERTA-CRON-MANUAL]:** F-4 e F-6 operam via Push Mágico de Oz manual enquanto GATE 01 não for executado. Eduardo envia relatório e push manualmente toda semana — risco de falha silenciosa.
- **[ALERTA-DRIFT-PAGES]:** Cada deploy requer workaround enquanto GATE 02 pendente. Feature construída pode não estar em produção sem evidência.
- **[CIRCUIT-BREAKER-SM2]:** Proibido alterar manualmente tabelas do Supabase fora dos scripts de migração homologados — quebrará o motor SM-2 dos 102 registros íntegros.

## 4. RESTRIÇÕES RÍGIDAS (O QUE NÃO CONSTRUIR)
- NUNCA alterar threshold matemático do SM-2 ou do Heatmap sem nova validação de dados brutos (HV-1).
- NUNCA construir nova interface visual para Ingrid antes de auditar RLS multi-tenant no Supabase (HV-2 · P-059).
- NUNCA construir telas de configuração, fluxos de recuperação de senha ou cadastros externos — onboarding permanece invisível (P-070).
- NUNCA implementar gateway de pagamento real (Stripe/Asaas) neste repositório.
- NUNCA reconstituir lógicas já entregues (F-1 a F-8) — DADOS-WATCH VERDE é prova de integridade.
