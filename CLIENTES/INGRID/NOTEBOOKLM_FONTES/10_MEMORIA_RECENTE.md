# MEMÓRIA V8 — PROJETO INGRID
> Diretriz V8 · Loop 8 · Telemetria + RLS + Monetização
> Gerada em 2026-06-04 — encerramento do ciclo Loop 8

---

## ESTADO TÉCNICO AO ENCERRAR LOOP 8

**Stack ativa:** PWA Vanilla JS + Supabase próprio da Ingrid (yjqvjhezwhepwomukudt) + Claude API · GitHub Pages
**Versão em produção:** v20 · URL: https://subdiretormnmsgm-commits.github.io/vanguard/
**Nota:** app.js atualizado com F-A + N-3 — deploy GitHub Pages pendente para esta versão

### Features ativas em produção (pós-Loop 8):

| Feature | Status |
|---|---|
| F-1 Saudação Noturna Dinâmica | Ativo |
| F-2 Distração Vingativa Silenciosa | Ativo |
| F-4 Gatilho Temporal 19h45 + pg_cron | ✅ AUTÔNOMO — Gate 7.1 APROVADO 2026-06-01 |
| F-5 Modo Véspera | Ativo — acionar em 2026-08-30 |
| F-6 Relatório Semanal WhatsApp | ✅ AUTÔNOMO — domingo 10h BRT · framing relativo ao edital (D2 Loop 8) |
| F-7 Raio-X SVG + Brasão Semanal | Ativo |
| F-8 Termômetro da Aprovação | Ativo |
| SM-2 + Heatmap | Ativos — 102+ respostas |
| **F-A Telemetria evento_uso** | ✅ NOVO Loop 8 — batch assíncrono · IndexedDB fallback |
| **F-B Painel Eduardo** | ✅ NOVO Loop 8 — painel_eduardo.html · threshold visual 3d/5d |
| **F-E Alerta Telegram 3 dias** | ✅ NOVO Loop 8 — alerta-inatividade Edge Function |
| **F-G Git Hook pre-push** | ✅ NOVO Loop 8 — bloqueou token sbp_ em 13:12 na própria sessão |
| **N-3 Heartbeat + fallback batch** | ✅ NOVO Loop 8 — integrado ao app.js |
| **N-4 TTL expurgo LGPD** | ✅ NOVO Loop 8 — dados sintéticos purgados a cada 24h |

### Loop 8 — o que NÃO foi construído (bloqueado ou adiado):

| Feature | Por que não construída |
|---|---|
| Gate 7.2 RLS dry-run | Ação do Diretor — requer `SUPABASE_SERVICE_ROLE_KEY` |
| M-4 Link demo anônimo | Bloqueado até 2ª usuária ativa |
| N-1 Clickwrap Opt-In Dataset | Loop 9 — necessário antes de pitch B2C |
| N-5 Pulse Check dominical | Loop 9 |
| Fluxo aceite do pitch | Loop 9 — contrato V2 + onboarding 2ª candidata |

---

## DECISÃO ESTRATÉGICA CENTRAL — NÃO REVERTER SEM DELIBERAÇÃO

> **Ingrid não é cliente pagante. É fundadora simbólica.**
> Ferramenta gratuita para ela.
> Dados anonimizados do uso dela = argumento comercial para 2ª candidata.
> Eixo comercial: vender para próximas candidatas usando jornada da Ingrid como prova.

---

## DECISÕES FIXADAS LOOP 8 (não reverter sem novo veredito)

| Veredito | Decisão |
|---|---|
| D1 DESCARTADO | Ferramenta gratuita para Ingrid — sem cobrança R$/mês |
| D2 A | Framing relativo ao edital ativo no F-6 |
| D3 DESCARTADO | Sem transação comercial com Ingrid — opt-in dataset com 2ª candidata |
| D4 A | Eduardo envia mensagem de presença humana esta semana (texto pronto na DELIBERAÇÃO) |
| D5 A | Sequência RLS → TTL → Heartbeat → Telemetria |

---

## BLOQUEIOS ATIVOS

| Bloqueio | Causa | Desbloqueio |
|---|---|---|
| Deploy GitHub Pages | app.js Loop 8 não pushado para gh-pages | `.\scripts\deploy_ingrid_ghpages.ps1` |
| Gate 7.2 RLS dry-run | Requer chave service role do Diretor | `$env:SUPABASE_SERVICE_ROLE_KEY = 'sua-key'` + `test_tenant_isolation.ps1` |
| 2ª candidata | Loop 8 validou fundações — pré-requisito: Gate 7.2 VERDE | Eduardo + Embaixador identificam próxima candidata |
| Pitch | D4 mensagem de presença humana precisa ir ANTES | Texto pronto — Diretor envia esta semana |

---

## ESTADO DOS GATES E WATCHES

| Gate/Watch | Status | Data |
|---|---|---|
| Gate Dia 15 | ✅ APROVADO | 2026-05-30 |
| Gate 7.1 Deploy CLI | ✅ APROVADO — F-4 + F-6 autônomos | 2026-06-01 |
| Gate 7.2 RLS dry-run | ⏳ PENDENTE — ação do Diretor | Loop 9 |
| LEGAL-WATCH | ✅ VERDE — Termo assinado 18/05 | 2026-05-27 |
| DADOS-WATCH | ✅ VERDE — 102 respostas · 1 user_id | 2026-05-30 |
| GITHUB-WATCH | ✅ VERDE — token sbp_ revogado · F-G ativo | 2026-06-04 |
| DEPLOY-WATCH | ✅ VERDE — 3 Edge Functions + pg_cron ativos | 2026-06-01 |
| CHURN-WATCH | ✅ DESATIVADO — Ingrid ativa e engajada | 2026-06-01 |
| PITCH-WATCH | 🔥 AQUECIDO — D4 urgente · janela fecha ~04-07/julho | 2026-06-04 |
| LGPD-WATCH | ⚠️ ATENÇÃO — N-1 Clickwrap pendente para Loop 9 | Loop 9 |
| P-013 Soberania | ✅ VERDE — Ingrid admin Supabase próprio | 2026-05-30 |

---

## ESTADO DO SUPABASE (yjqvjhezwhepwomukudt)

| Componente | Estado |
|---|---|
| pg_cron `gatilho_temporal_ingrid` | ✅ ATIVO — 22:45 UTC (19h45 BRT) diário |
| pg_cron `relatorio_semanal_ingrid` | ✅ ATIVO — 13h UTC (10h BRT) domingos |
| Edge Function `notificar-progresso` | ✅ ATIVO |
| Edge Function `alerta-inatividade` | ✅ ATIVO Loop 8 — 3 dias sem uso → Telegram |
| Edge Function `relatorio-semanal` | ✅ ATIVO — framing relativo ao edital |
| Migration `evento_uso` | ✅ APLICADA 2026-06-04 |
| Migration `ttl_expurgo` | ✅ APLICADA 2026-06-04 |
| View `snapshot_ingrid_loop6_golden` | ✅ CRIADA E CORRIGIDA 2026-06-04 |
| RLS isolamento tenant | ⏳ PENDENTE Gate 7.2 |

---

## INTELIGÊNCIA ACUMULADA — NÃO REPETIR

- **G-3 VETO PERMANENTE** — redução punitiva de cota SM-2 causa churn silencioso com perfil ansioso
- **Pitch com Ingrid ENCERRADO** — ela é fundadora, não cliente. Monetizar com próximas candidatas
- **H-6 (teto de preço)** — nunca testar com Ingrid. Testar com 2º/3º cliente
- **SaaS Readiness Audit** — segredo interno de franquia. Nunca expor engrenagens para cliente
- **Tom que funciona:** caloroso, direto, sem jargão técnico
- **Padrão de uso:** estuda à noite (~20h). F-4 cron 19h45 calibrado para este padrão

---

## PRÓXIMA AÇÃO DO DIRETOR

1. **ESTA SEMANA:** Enviar D4 — mensagem de presença humana (texto na DELIBERAÇÃO_V8)
2. **Antes de 2ª candidata:** Gate 7.2 RLS dry-run (`test_tenant_isolation.ps1`)
3. **Próxima sessão:** Deploy GitHub Pages com app.js Loop 8

---

## REGISTRO

- **MEMÓRIA criada:** 2026-06-04
- **Músculo responsável:** Claude Sonnet 4.6
- **Loops anteriores:** V1 → V7 em `CLIENTES/INGRID/HISTORICO/`
