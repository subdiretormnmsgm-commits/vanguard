# ROADMAP DO SECRETÁRIO VIRTUAL
**Quadrilateral IAH · Evolução por fases**
**Versão:** 1.0 · 2026-05-11

---

> ⚠️ **ORGANISMO VIVO** — actualizar após cada fase implementada.

---

## FASE 1 — ACTIVA ✅
**O que faz:** Tally form → Claude Haiku avalia → email para Eduardo
**Custo:** ~$5–10/mês · **Setup:** ~2 horas

```
Cliente → Formulário Tally → Webhook → Claude avalia → Email a Eduardo
                                                      → Email ao cliente
```

**Quando escalar:** Quando a gestão manual dos leads se tornar um gargalo (15+ leads/mês qualificados).

---

## FASE 2 — PRÓXIMA
**O que adiciona:** Bot WhatsApp que qualifica antes do formulário
**Custo adicional:** ~R$80–120/mês (Z-API) · **Setup:** ~1 semana

```
Cliente → WhatsApp → Bot faz 3 perguntas GO/NO-GO
  SE GO  → envia link do formulário Tally (Fase 1)
  SE NO-GO → resposta automática com Produto de Entrada
Eduardo → notificação só de leads já qualificados
```

**Trigger para implementar:** Volume justifica o custo do WhatsApp API.

---

## FASE 3 — FUTURO
**O que adiciona:** Automações operacionais completas
**Custo adicional:** mínimo · **Setup:** 2–3 semanas

- ROI Tracker automático (30 dias após lançamento → email ao cliente sem intervenção)
- Status automático quando cliente pergunta "como está?"
- Agendamento de reunião com Cal.com + briefing automático a Eduardo
- Rascunho de proposta comercial gerado pelo Claude com os dados do lead

---

## FASE 4 — VISÃO
**O que adiciona:** Secretária com memória de todos os clientes
**Custo adicional:** Supabase (gratuito) · **Setup:** 1 mês

- Histórico de todos os leads e clientes numa base de dados
- Secretária sabe o estado de cada projecto e responde contextualizadamente
- Dashboard com pipeline de clientes
- Integração directa com o Quadrilateral (alimenta NotebookLM automaticamente)

---

*Roadmap · Secretário Virtual · Quadrilateral IAH*
