# PLANO DE BUILD — V[X] — [NOME DO PROJECTO]
**Data:** [data] | **Músculo:** Claude Code | **Aguarda Veredito do Diretor**

---

## STACK CONFIRMADA

```
Frontend:  [Next.js / React / HTML+CSS / Shopify / outro]
Backend:   [FastAPI / Node.js / Supabase Functions / outro]
Base dados: [Supabase (PostgreSQL) / outro]
Deploy:    [Vercel / Railway / EasyPanel / Hostinger / outro]
Extras:    [Cloudflare Workers / Stripe / n8n / Vapi / outro]
```

---

## MÓDULO 0 — INJECÇÕES SOBERANAS
*(obrigatório · executar ANTES de qualquer feature do cliente)*

| Sub-módulo | Descrição | Est. | Status |
|-----------|-----------|------|--------|
| 0.1 Sovereign Pixel | Telemetria pré-configurada para FIRE Event: `[success_event]` | [X]h | [ ] |
| 0.2 Burn Rate Shield | Variáveis no .env + middleware activo + alerta 75% testado | [X]h | [ ] |
| 0.3 Kill-Switch | tenant_subscriptions + grace period 72h + webhook Stripe | [X]h | [ ] |
| 0.4 LGPD/GDPR | Banner cookies + tabela user_consents + vp_consent flag | [X]h | [ ] |
| 0.5 Ticket Médio Wizard | 3 perguntas onboarding no tenant_config | [X]h | [ ] |

**Est. Módulo 0:** [X]h | Módulo 0 aprovado? → [ ] SIM → [ ] NÃO (não avançar)

---

## MÓDULOS DO CLIENTE

### Módulo 1 — [NOME]
**Porquê prioritário:** [impacto comercial directo]
**Estimativa:** [X]h | **Risco:** [SIM — qual / NÃO]
**Dependências:** [Módulo 0 / nenhuma / outro]

Subtarefas:
- [ ] [subtarefa 1]
- [ ] [subtarefa 2]
- [ ] [subtarefa 3]

---

### Módulo 2 — [NOME]
**Depende de:** Módulo 1
**Estimativa:** [X]h | **Risco:** [SIM — qual / NÃO]

Subtarefas:
- [ ] [subtarefa 1]
- [ ] [subtarefa 2]

---

### Módulo 3 — [NOME]
**Estimativa:** [X]h | **Risco:** [SIM — qual / NÃO]

Subtarefas:
- [ ] [subtarefa 1]
- [ ] [subtarefa 2]

---

## RESUMO

| | |
|--|--|
| **Total estimado** | [X]h / [Y] sessões |
| **O que NÃO será construído** | [lista — com razão] |
| **Dívidas técnicas previstas** | [P0/P1/P2 ou NENHUMA — descrever] |
| **Módulos reutilizados** | [lista de módulos existentes reutilizados] |
| **Módulos do zero** | [lista dos que precisam de ser construídos do zero] |

---

## REGRAS ACTIVAS NESTE BUILD

- [ ] LGPD/GDPR: consentimento antes de qualquer dado pessoal
- [ ] Sem variáveis de ambiente no código — sempre em `.env`
- [ ] Sem commit sem aprovação do Diretor
- [ ] BURN_RATE_LIMITE activo (ver `.env`)
- [ ] Inventário verificado — não construir o que já existe
- [ ] Stack fundação respeitada — sem novos frameworks sem VEREDITO DO DIRETOR
- [ ] FIRE Event `[success_event]` pré-configurado no Módulo 0

---

**Aguardo confirmação do Diretor para avançar. →**
