# PLANO DE BUILD — V[X] — [NOME DO projeto]
**Data:** [data] | **Músculo:** Claude Code | **Aguarda Veredito do Diretor**

---

## CHECK P-044 — RELEITURA DA CENA DE SUCESSO ANTES DE CODIFICAR

> *"P-044: Momentum Tecnológico do Músculo — o motor ≠ a viagem do cliente."*
> Antes de cada dia de build, o Músculo relê a cena abaixo.
> Toda decisão técnica do dia é avaliada: "Esta decisão aproxima ou afasta da cena do cliente?"

**Cena de sucesso declarada pelo cliente:**
> "[Copiar literalmente da P2 do BRIEFING_DISCOVERY — campo cena_sucesso_descrita]"

**Como a demo reproduz esta cena:**
> "[Descrever: qual busca abre, o que o cliente vê, o que sente — deve mapear a cena acima]"

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
| 0.2 Burn Rate Shield | Variáveis no .env + middleware ativo + alerta 75% testado | [X]h | [ ] |
| 0.3 Kill-Switch | tenant_subscriptions + grace period 72h + webhook Stripe | [X]h | [ ] |
| 0.4 LGPD/GDPR | Banner cookies + tabela user_consents + vp_consent flag | [X]h | [ ] |
| 0.5 Ticket Médio Wizard | 3 perguntas onboarding no tenant_config | [X]h | [ ] |
| 0.6 Região Supabase | sa-east-1 (São Paulo) — OBRIGATÓRIO para clientes BR | 0h | [ ] |

**Est. Módulo 0:** [X]h | Módulo 0 aprovado? → [ ] SIM → [ ] NÃO (não avançar)

---

## MÓDULOS DO CLIENTE

### Módulo 1 — [NOME]
**Porquê prioritário:** [impacto comercial direto]
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

## REGRAS ativas NESTE BUILD

- [ ] LGPD/GDPR: consentimento antes de qualquer dado pessoal
- [ ] Sem variáveis de ambiente no código — sempre em `.env`
- [ ] Sem commit sem aprovação do Diretor
- [ ] BURN_RATE_LIMITE ativo (ver `.env`)
- [ ] Inventário verificado — não construir o que já existe
- [ ] Stack fundação respeitada — sem novos frameworks sem VEREDITO DO DIRETOR
- [ ] FIRE Event `[success_event]` pré-configurado no Módulo 0

---

**Aguardo confirmação do Diretor para avançar. →**
