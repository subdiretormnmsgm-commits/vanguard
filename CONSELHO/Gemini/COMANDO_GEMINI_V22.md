════════════════════════════════════════════════════════════
INÍCIO DO COMANDO — COPIAR A PARTIR DAQUI
════════════════════════════════════════════════════════════

Gemini, a Missão **V22 — Autonomous Dominion Engine** foi concluída. Abaixo está o conteúdo completo da MEMORIA_V22 e do relatorio_evolutivo_V22, incluindo a **Análise de Negócio** com pontos fortes e fracos e as **5 Ideias Disruptivas** para V23.

Analise o que foi construído, a análise de negócio honesta do Claude e as ideias para V23. Crie a **DIRETRIZ ESTRATÉGICA — VERSÃO 23** focada em transformar 22 versões de tecnologia no primeiro contrato real.

---

## CONTEXTO — QUEM SOMOS

IAH — Inteligência Artificial Humana. O Diretor Eduardo orquestra 3 IAs:
- **Gemini (você):** O Estrategista
- **NotebookLM:** O Auditor
- **Claude Code:** O Músculo

**Estado actual (2026-05-10):** 22 versões. 0 clientes. MRR R$0. Toda a infra construída. Bloqueador: operacional (MEI + Stripe + git push).

---

## MEMORIA_V22 — O QUE FOI CONSTRUÍDO

**1. Hermes Loop (api/hermes_loop.py)**
- Google Calendar OAuth 2.0 completo (setup único via /oauth/start)
- IAH Bridge: Vapi liga para Eduardo quando lead FIRE >= 9.5 está no checkout
- Haiku sentiment analysis na transcrição → se interesse=alto: booking automático no Calendar
- GET /api/hermes-loop/calendar/slots → lista slots livres da semana
- §21 imutável: score < 9.5 = HTTPException 403

**2. Sentinel Escalation Ladder (api/sentinel_escalation.py)**
- Tracking pixel 1×1 GIF por relatório → regista email_aberto em sentinel_report_log
- Cadência automática: Semana 1 (email) → 2 (WhatsApp queue) → 3 (Vapi alerta Eduardo) → 4 (IAH Rescue Plan modal KV bus 48h)
- IAH Rescue Plan: oferta de valor, não desconto — "5 prospecções gratuitas"

**3. Oráculo Pulse API v0.1 (api/oracle_pulse.py)**
- GET /api/v1/oracle/pulse?nicho=clinicas&region=SP — Bússola de Nicho
- Auth por API key SHA-256 + oracle_usage_log para billing
- Preço Early Access: R$500/mês por agência
- tenant_coverage transparente — cobertura cresce com cada tenant IntentShare

---

## ANÁLISE DE NEGÓCIO — PONTOS FRACOS E FORTES

**PONTOS FORTES:**
1. Funil autónomo: lead → reunião → Eduardo fecha (o Hermes intermedia tudo)
2. Retenção em camadas sem custo: WhatsApp (grátis) → Vapi (< R$0,25) → KV modal (grátis)
3. Segundo fluxo de receita (Oráculo): R$500/mês por agência sem custo marginal
4. Transparência como diferencial: tenant_coverage visível — vantagem sobre competidores
5. Lock-in triplo: dados + inteligência + rede do Oráculo

**PONTOS FRACOS:**
1. **CRÍTICO: 0 clientes com 22 versões** — risco de museu tecnológico sem mercado
2. Google Calendar OAuth requer setup técnico (30-45 min de overhead para Eduardo)
3. Oráculo sem dados = promessa vazia (não prospectar até >= 3 tenants IntentShare)
4. Tracking pixel ainda não integrado no template do email (dívida técnica activa)
5. Dependência Vapi para 3 funcionalidades críticas

---

## RELATORIO_EVOLUTIVO_V22 — VISÃO LMM DO CLAUDE

**Avaliação das ideias Gemini + Eduardo:**
- Hermes Loop + Calendar: CONSTRUÍDO
- IAH Bridge (Eduardo recebe chamada): CONSTRUÍDO
- Sentinel Escalation: CONSTRUÍDO
- IAH Rescue Plan (modal vs desconto): CONSTRUÍDO
- Oráculo Pulse API: CONSTRUÍDO
- Franchise Intelligence: V23

**5 Ideias para V23:**

[V23-001] FRANCHISE INTELLIGENCE MATRIX
Painel para franqueadoras: ranking de unidades por Maturity Score, alertas de queda FIRE por unidade, upsell R$3.000. Ticket: R$500/mês por franqueadora.

[V23-002] ORÁCULO B2B v1.0 — Intent Radar por Código Postal
GeoIP em site_domain → intent por CEP. "Quais bairros de SP têm leads FIRE em clínicas?" Ticket agências: R$2.000/mês.

[V23-003] SENTINEL UPSELL ENGINE
Semana 3+ com ROI positivo: Haiku gera proposta automática de upgrade IAH no rodapé do email. A IA propõe, o cliente clica, Eduardo fecha.

[V23-004] SOVEREIGN PLAYBOOK DIGITAL
Plano 90 dias por Claude Sonnet: cada tarefa exige a plataforma Vanguard (lock-in de consultoria). R$500/mês adicional ao projecto IAH.

[V23-005] VANGUARD PARTNER NETWORK
Programa de parceiros: agências indicam clientes, recebem 20% do 1.º mês Sentinel + R$600 por Projecto IAH. Canal de vendas sem custo fixo.

**Classificação Claude: B+ — código sólido, foco comercial urgente.**

---

## O QUE PRECISO DE TI, GEMINI

Responde com **5 blocos**:

---

**BLOCO 0 — PLANO DE NEGÓCIO DESTA SEMANA**
A tecnologia está pronta. O que falta é comercial. Dá o plano hora a hora para Eduardo esta semana:
- Segunda: MEI + Stripe setup
- Terça: GitHub Secrets + git push + site live
- Quarta: 10 primeiros contactos via prospectar.ps1
- Quinta-sexta: Follow-ups + primeira reunião
- Sábado: revisão e preparação para semana 2

Qual o script exacto para a primeira abordagem no nicho que tens mais confiança?

---

**BLOCO 1 — ANÁLISE ESTRATÉGICA V22**
- Concordas com a avaliação B+ do Claude? O que ele errou ou acertou?
- O IAH Bridge (Eduardo recebe chamada) é a decisão certa para esta fase ou já deveríamos ter a IA a ligar directamente para o lead?
- Das 5 ideias V23, qual é a que fecha negócio mais rápido?

---

**BLOCO 2 — DIRETRIZ GEMINI V23** *(vira DIRETRIZ GEMINI V23.txt)*
Fala directamente com o Claude. Inclui:
- O que construir na V23 que mais impacta o primeiro cliente nos próximos 30 dias
- Se o Franchise Intelligence é para agora ou é distracção
- Como evitar que a V23 seja outra versão sem cliente
- O que proteger sem alteração (§21, KV bus, Oráculo v0.1, tracking pixel)

---

**BLOCO 3 — COMANDO NOTEBOOKLM**
Instrução para gerar Skill V23 com ANÁLISE DE SÓCIO + vanguard-v23-[nome].md + AUTO-LOG [ID-010].

---

**BLOCO 4 — COMANDO CLAUDE CODE**
Instrução exacta para o terminal. Skill V23 + AUTO-LOG + construir + 5 ideias V24.

---

A única métrica que importa agora: **primeiro cliente a pagar antes da V23.**

════════════════════════════════════════════════════════════
FIM DO COMANDO
════════════════════════════════════════════════════════════
