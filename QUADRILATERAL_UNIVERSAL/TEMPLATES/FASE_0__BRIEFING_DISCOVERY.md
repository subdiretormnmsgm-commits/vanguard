# BRIEFING DE IGNIÇÃO — [NOME DO PROJECTO]
**IAH Factory — Quadrilateral** | Discovery Fase 0
**Cliente:** [nome] | **Data:** [data] | **Modo:** [Amigo / Cliente Formal]

---

> Preencher após a sessão de discovery (WhatsApp ou reunião).
> Este documento vai directamente para o Gemini (Comando 1) e para o NotebookLM.
> Guardar em: `CLIENTES/[NOME_CLIENTE]/BRIEFING_DISCOVERY.md`

---

## BLOCO 1 — DEFINIÇÃO DO PROJECTO

**Nome do Projecto:**
_______________________________________________

**Objectivo Único** *(em uma frase: o que o sistema faz)*
> Ex: "Um app que gere agendamentos de petshop e avisa o dono no WhatsApp."

_______________________________________________

**Nicho / Sector:**
_______________________________________________

**Tipo de Projecto:**
[ ] Presença Digital   [ ] Ecommerce   [ ] App Web / SaaS   [ ] App Mobile
[ ] Automação          [ ] IA / Dados  [ ] Sistema Interno   [ ] Outro: _____

**Camada estimada:**
[ ] 1 — MVP (1–5 dias)   [ ] 2 — Produto (1–3 sem)   [ ] 3 — Plataforma (2–6 sem)   [ ] 4 — Ecossistema (1–3 meses)

---

## BLOCO 2 — A DOR REAL

**O que está a custar dinheiro ou tempo hoje:**
_______________________________________________
_______________________________________________

**Em números** *(horas/semana, clientes perdidos, faturamento em risco)*:
_______________________________________________

**O que acontece se não resolver em 3 meses:**
_______________________________________________

---

## BLOCO 3 — O MOMENTO MÁGICO (FIRE Event)

> A acção mais importante que acontece no sistema — indica que o negócio funcionou.

**FIRE Event:**
[ ] Compra realizada         [ ] Agendamento confirmado   [ ] Orçamento pedido
[ ] Contacto WhatsApp        [ ] Registo / conta criada   [ ] Subscrição assinada
[ ] Outro: _______________________________________________

**`success_event` para sentinel_config.json:** `_____________________`

**Frequência actual:** _________ vezes/mês

---

## BLOCO 4 — A VARINHA MÁGICA

> Se pudéssemos colocar uma função impossível ou uma IA super-inteligente
> dentro deste sistema — o que ela faria para deixar o cliente à frente de toda a gente?
> *(Anotar sem filtrar. Tudo é válido. É aqui que nascem as ideias disruptivas.)*

_______________________________________________
_______________________________________________
_______________________________________________

**Nota do Músculo** *(o que disto é viável nesta iteração vs. roadmap futuro)*:
_______________________________________________

---

## BLOCO 5 — DADOS DE ENTRADA E SAÍDA

**O que o sistema recebe** *(inputs do utilizador ou de outras fontes)*:
_______________________________________________

**O que o sistema entrega** *(outputs, notificações, relatórios)*:
_______________________________________________

---

## BLOCO 6 — ESTADO ACTUAL E RECURSOS

**O que já existe** *(código, design, domínio, contas, APIs, base de dados)*:
_______________________________________________

**Stack técnica actual** *(se souber)*:
_______________________________________________

---

## BLOCO 7 — RECEITA E MERCADO

**Ticket médio por venda/serviço:** R$ __________ por __________

**Volume mensal actual ou esperado:** __________ clientes/transacções por mês

**Receita mensal estimada:** R$ __________ /mês

→ *Correr `scripts/calculadora_precificacao.py` com estes dados antes de gerar proposta*

---

## BLOCO 8 — URGÊNCIA E INVESTIMENTO

**Prazo desejado / data fixa:**
[ ] Sem prazo   [ ] _____ meses   [ ] Data: _______________   [ ] Motivo: _______________

**Urgência:**
[ ] Exploratório   [ ] Normal   [ ] Urgente   [ ] Crítico

**Orçamento disponível:**
[ ] Até R$2.000   [ ] R$2k–R$8k   [ ] R$8k–R$25k   [ ] R$25k–R$80k   [ ] Acima R$80k   [ ] Aguarda proposta

**Decisor:** [ ] Próprio   [ ] Com sócio   [ ] Precisa aprovação de: _______________

---

## BLOCO 9 — PERFIL DO CLIENTE *(preencher após a reunião — para PERFIL_CLIENTE_TEMPLATE.md)*

O que ele DISSE que quer:
_______________________________________________

O que eu acho que ele REALMENTE quer:
_______________________________________________

O medo que não verbalizou:
_______________________________________________

O que fará ele dizer SIM:
_______________________________________________

---

## PRÓXIMOS PASSOS IMEDIATOS

```
[ ] 1. Guardar como CLIENTES/[NOME]/BRIEFING_DISCOVERY.md
[ ] 2. Correr calculadora_precificacao.py com dados do Bloco 7
[ ] 3. Abrir Gemini → colar FASE_1__COMANDO_ESTRATEGISTA_TEMPLATE.md com este briefing
[ ] 4. Guardar DIRETRIZ do Gemini → CLIENTES/[NOME]/DIRETRIZ_V1_ESTRATEGISTA.txt
[ ] 5. Validar DIRETRIZ (Score ≥7?) → activar NotebookLM ou ir directo ao Claude
[ ] 6. Activar: "Protocolo Vanguard [nome do projecto]"
```

---

*FASE_0__BRIEFING_DISCOVERY.md · IAH Factory · Quadrilateral*
*Organismo Vivo — actualizar se o cliente mudar de foco a meio do projecto*
