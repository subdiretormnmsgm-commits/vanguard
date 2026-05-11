════════════════════════════════════════════════════════════
INÍCIO DO COMANDO — COPIAR A PARTIR DAQUI
════════════════════════════════════════════════════════════

Gemini, a Missão **V23 — The Revenue Strike** foi concluída. Abaixo está o conteúdo completo da MEMORIA_V23 e do relatorio_evolutivo_V23, incluindo a **Análise de Negócio** e as **5 Ideias Disruptivas** para V24.

Analise o que foi construído, a análise honesta do Claude e as ideias para V24. Crie a **DIRETRIZ ESTRATÉGICA — VERSÃO 24** com foco único: **converter o primeiro cliente real e escalar para 5 clientes em 30 dias**.

---

## CONTEXTO — QUEM SOMOS

IAH — Inteligência Artificial Humana. O Diretor Eduardo orquestra 3 IAs:
- **Gemini (você):** O Estrategista
- **NotebookLM:** O Auditor
- **Claude Code:** O Músculo

**Estado actual (2026-05-10):** 23 versões. 0 clientes. MRR R$0. Toda a infra construída + Partner Portal activo + Upsell Engine activo + Design premium live.

---

## MEMORIA_V23 — O QUE FOI CONSTRUÍDO

**1. Tracking Pixel (api/sentinel_report.py)**
- Pixel 1×1 GIF nativo no template HTML do Report Card
- open_token SHA-256 único por relatório → regista email_aberto em sentinel_report_log
- Escalation Ladder agora opera com dados reais de abertura

**2. Upsell Engine (api/sentinel_report.py)**
- Semana 3+ com ROI positivo → Haiku gera proposta de upgrade para Projecto IAH (R$6.000)
- ROI calculado: fire_delta × ticket_medio (declarado pelo tenant)
- Zero intervenção do Diretor

**3. Partner Portal Alpha (api/partner_portal.py)**
- Registo de agências + link afiliado VGP-XXXX
- Dashboard: referrals, comissões ganhas/pendentes
- Clientes: Maturity Scores com consentimento LGPD
- Comissões: R$19,40 (Sentinel) + R$600 (IAH)

**4. Design Sovereign Intelligence Terminal**
- Chakra Petch + DM Sans + hex grid + intel ticker + pricing section
- Holographic card sweep + scan-reveal + todos os V18 → V22

---

## ANÁLISE DE NEGÓCIO — PONTOS FRACOS E FORTES

**PONTOS FORTES:**
1. Upsell Engine converte retenção em expansão de MRR sem esforço do Diretor
2. Partner Portal multiplica o canal de vendas sem custo fixo
3. Tracking pixel fecha o loop da Escalation Ladder (antes operava às cegas)
4. Design premium justifica o preço do produto visualmente
5. ROI Calculator usa ticket_medio real do cliente (não estimativa genérica)

**PONTOS FRACOS:**
1. **CRÍTICO: 0 clientes com 23 versões** — o sistema é perfeito, o mercado ainda não o testou
2. Partner Portal sem provas = argumento fraco para agências (falta case de sucesso)
3. ticket_medio sem campo de onboarding (usa default R$300 se não declarado)
4. Comissões do Partner Portal dependem do Stripe webhook (ainda por activar)

---

## RELATORIO_EVOLUTIVO_V23 — VISÃO LMM DO CLAUDE

**Classificação V23: A-**

O código está no lugar certo: vender. O Upsell Engine é a funcionalidade mais imediata que pode gerar MRR sem esforço do Diretor. O Partner Portal é a aposta de médio prazo correcta — quando houver provas, multiplica o canal. A nota não é A porque as peças estão prontas mas o primeiro cliente ainda não existe.

**5 Ideias para V24:**

[V24-001] TICKET_MEDIO WIZARD — pergunta no quiz que alimenta o ROI Calculator em tempo real

[V24-002] PARTNER LEADERBOARD — ranking público de agências por clientes activos (gamificação sem custo)

[V24-003] SENTINEL ROI REPORT — relatório mensal gerado por Claude Sonnet: ROI total, leads convertidos, CFO virtual

[V24-004] PARTNER CONSENT FLOW — opt-in no quiz que activa o dashboard de scores da agência automaticamente

[V24-005] IAH PLAYBOOK AUTO-GERADO — 90 dias personalizado por Sonnet ao converter Sentinel → IAH (R$500/mês adicional)

**Prioridade comercial imediata do Diretor:**
1. MEI + Stripe + git push (esta semana — não é código)
2. 10 contactos via prospectar.ps1
3. 1 Neural Sentinel activo → primeiro Sentinel Report enviado
4. Com 1 cliente: prospectar 1 agência para o Partner Portal

---

## O QUE PRECISO DE TI, GEMINI

Responde com **5 blocos**:

---

**BLOCO 0 — PLANO DE NEGÓCIO DESTA SEMANA**
Script exacto para Eduardo abordar as primeiras 10 empresas. Qual o nicho prioritário? Qual a mensagem de abertura? Como qualificar em 2 minutos?

---

**BLOCO 1 — ANÁLISE ESTRATÉGICA V23**
- Concordas com a avaliação A- do Claude?
- O Partner Portal deve ser lançado agora ou aguardar o primeiro case?
- Das 5 ideias V24, qual fecha cliente mais rápido?

---

**BLOCO 2 — DIRETRIZ GEMINI V24** *(vira DIRETRIZ GEMINI V24.txt)*
Fala directamente com o Claude. Inclui:
- O que construir na V24 que mais impacta o primeiro cliente nos próximos 14 dias
- Ticket_medio Wizard: vale a pena agora ou é distracção?
- Como usar o Partner Leaderboard como prova social antes de ter parceiros reais
- O que proteger sem alteração (§21, tracking pixel, Upsell Engine, LGPD consent flow)

---

**BLOCO 3 — COMANDO NOTEBOOKLM**
Instrução para gerar Skill V24 com ANÁLISE DE SÓCIO + vanguard-v24-[nome].md + AUTO-LOG [ID-011].

---

**BLOCO 4 — COMANDO CLAUDE CODE**
Instrução exacta para o terminal. Skill V24 + AUTO-LOG + construir + 5 ideias V25.

---

A única métrica que importa agora: **primeiro cliente a pagar antes da V24.**

════════════════════════════════════════════════════════════
FIM DO COMANDO
════════════════════════════════════════════════════════════
