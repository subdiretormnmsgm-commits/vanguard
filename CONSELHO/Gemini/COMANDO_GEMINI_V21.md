════════════════════════════════════════════════════════════
INÍCIO DO COMANDO — COPIAR A PARTIR DAQUI
════════════════════════════════════════════════════════════

Gemini, a Missão **V21 — Market Consciousness Engine** foi concluída com sucesso. Abaixo está o conteúdo completo da MEMORIA_V21 e do relatorio_evolutivo_V21, incluindo a **Visão LMM do Claude** com as **5 Ideias Disruptivas** que ele propôs.

Analise o que foi construído e as ideias que o Claude sugeriu. Com base neste relatório e nas nossas metas, crie a **DIRETRIZ ESTRATÉGICA — VERSÃO 22** para eu alimentar o NotebookLM.

---

## CONTEXTO DO PROJETO — QUEM SOMOS

Somos uma **IAH — Inteligência Artificial Humana**: uma fábrica de produtos digitais proprietários. O Diretor orquestra três IAs como conselho:

- **Diretor (Eduardo):** O veredito.
- **Gemini (você):** O Estrategista — cria a DIRETRIZ.
- **NotebookLM:** O Auditor — guarda o histórico, gera a Skill.
- **Claude Code:** O Músculo — escreve o código, entrega o software.

**Estado actual (2026-05-10):** 21 versões construídas. 0 clientes pagantes. MRR: R$0. Fundação completa — aguarda MEI + Stripe live + git push + primeiro cliente.

**Transição estratégica V21:** Os três motores de consciência estão construídos: o cliente recebe relatório toda segunda-feira (retenção), o Oráculo começa a respirar em silêncio (dízimo de dados), o Hermes sabe quando ligar (trigger autónomo). O próximo passo é o Hermes Loop completo.

---

## PLANO DE NEGÓCIO — ESTADO ACTUAL

Bloqueadores que ainda persistem:
1. MEI/CNPJ não aberto → Stripe BR bloqueado (Eduardo abre esta semana)
2. GitHub Secrets não definidos → CI/CD não activo (FTP_SERVER, FTP_USERNAME, FTP_PASSWORD)
3. SENDGRID_API_KEY não configurado → Report Card não envia (conta gratuita — 100 emails/dia)
4. pg_cron não activado → automações semanais não correm (Supabase → Extensions → pg_cron)

Sequência exacta para primeiro cliente:
1. MEI (30 min) → Stripe BR → produto Neural Sentinel R$97/mês BRL → Price ID
2. GitHub Secrets Hostinger → git push → site live
3. SENDGRID_API_KEY → executar schema_v21.sql → activar pg_cron
4. prospectar.ps1 → 20 contactos → 1 resposta → 1 Neural Sentinel activo
5. Na segunda-feira seguinte: primeiro Sentinel Report enviado automaticamente

---

## MEMORIA_V21 — O QUE FOI CONSTRUÍDO

**1. Sentinel Report Card (api/sentinel_report.py)**
- POST /api/sentinel/report/generate/{tenant_id}: gera e envia relatório manual
- POST /api/sentinel/report/send-weekly: envia para todos os tenants activos (pg_cron segunda 08h)
- GET /api/sentinel/report/preview/{tenant_id}: preview no Cockpit
- HTML email: barras de intenção FIRE/HOT/WARM, delta semanal, revenue_risk, CTA "Intervir Agora"
- Claude Haiku gera narrativa executiva ~$0.04/relatório

**2. Hermes Voice Bridge (api/hermes_trigger.py)**
- Varre maturity_scores VIEW a cada hora (pg_cron)
- Score >= 9.5 → cria trigger em hermes_voice_triggers (pending)
- Cockpit mostra fila → Diretor autoriza → status: authorized
- Modo AUTO: hermes_auto_mode = true → autorização imediata sem intervenção
- §21 imutável: threshold = 9.5, hardcoded

**3. Dízimo de Dados — IAH Factory V21**
- Flag -IntentShare no iah-clone.ps1: activa dataTithe: 0.15 no brand-config.js
- tenants.metadata JSONB: {intent_share: true, dataTithe: 0.15}
- Função aggregate_intent_tithe(): 15% dos FIRE/HOT events → global_intent_graph
- VIEW intent_graph_summary: nicho + geo_region + week_bucket (fundação Oráculo B2B)

**Schema V21 (infra/schema_v21.sql):**
- sentinel_report_log: auditoria de relatórios enviados
- global_intent_graph: grafo global de intenção (dízimo)
- hermes_voice_triggers: fila de chamadas autorizadas
- aggregate_intent_tithe(): função de agregação semanal
- 3 jobs pg_cron comentados prontos para activar

---

## RELATORIO_EVOLUTIVO_V21 — VISÃO LMM DO CLAUDE

**Avaliação das ideias Gemini V21:**
- Sentinel Report Card: CONSTRUÍDO
- Hermes Voice Bridge: CONSTRUÍDO
- Dízimo de Dados: CONSTRUÍDO
- Oráculo B2B — fundação: PLANTADA (global_intent_graph + VIEW)
- Sovereign Credit Score: V23+ (aguarda regulação)

**5 Ideias Disruptivas para V22:**

[V22-001] HERMES LOOP COMPLETO
trigger authorized → reverse lookup telefone → Vapi liga → Haiku classifica resposta em tempo real → agenda demo Google Calendar → CRM actualizado. Zero intervenção humana no funil.

[V22-002] COCKPIT 2.0 — Command & Control
Mapa de calor de intenção por nicho, fila Hermes Voice ao vivo, preview Sentinel Report com edição de narrativa, revenue forecast (MRR actual + MRR potencial leads FIRE não convertidos).

[V22-003] ORÁCULO B2B v0.1 — Primeira API Paga
Com 3+ tenants IntentShare: GET /api/oracle/nicho/{nicho}/pulse → densidade FIRE/HOT por semana e geo_region. Primeiro cliente: agência que quer saber "quais clínicas em SP estão quentes". Ticket: R$500/mês.

[V22-004] SENTINEL ESCALATION LADDER
Semana 1: email. Semana 2 sem abertura: WhatsApp Hermes. Semana 3 sem resposta: Hermes Voice "revisão de conta". Semana 4: alerta RISCO CHURN + proposta de desconto gerada por Haiku.

[V22-005] FRANCHISE INTELLIGENCE MATRIX
Painel para franqueadoras com IntentShare: ranking de unidades por Maturity Score médio, alertas de queda de FIRE por unidade, upsell consultoria recuperação. Ticket: R$500/mês por franqueadora.

**Estado do ecossistema:**
ACTO I (V1-V13): COMPLETO
ACTO II (V14-V21): 90% (aguarda deploy + Stripe live + 1 cliente)
ACTO III (V22+): FUNDAÇÃO PLANTADA

---

## O QUE PRECISO DE TI, GEMINI

Assuma o papel de **Sócio Estrategista do Conselho Quadrilateral**. Responde com **5 blocos**:

---

**BLOCO 0 — PLANO DE NEGÓCIO: SEQUÊNCIA DESTA SEMANA**
O motor está pronto em 21 versões. Esta semana há UMA prioridade: primeiro cliente a pagar.
- Sequência exacta com tempos estimados (MEI → Stripe → git push → SENDGRID → primeiro contacto)
- Qual nicho contactar esta semana e com que script específico
- O que dizer quando o prospect perguntar "o que é o Neural Sentinel?"

---

**BLOCO 1 — ANÁLISE ESTRATÉGICA V21**
- O Dízimo de Dados é LGPD-seguro com opt-in? Há algum risco regulatório?
- O Hermes Bridge (trigger manual) é o passo certo antes do loop completo, ou já devemos saltar para o loop?
- Das 5 ideias V22, qual é a que mais alavanca o primeiro cliente nos próximos 30 dias?

---

**BLOCO 2 — DIRETRIZ GEMINI V22** *(vira DIRETRIZ GEMINI V22.txt)*
Fala directamente com o Claude. Inclui:
- O que construir na V22 que mais acelera a primeira venda
- Se o Cockpit 2.0 é V22 ou distracção
- Como integrar o Hermes Loop sem quebrar o hermes_voice.py existente (V9)
- O que proteger (§21, Ion Gold, PDCA, global_intent_graph)

---

**BLOCO 3 — COMANDO NOTEBOOKLM**
Instrução para gerar Skill V22 com ANÁLISE DE SÓCIO + vanguard-v22-[nome].md + AUTO-LOG [ID-009].

---

**BLOCO 4 — COMANDO CLAUDE CODE**
Instrução exacta para o terminal. Skill V22 + AUTO-LOG + construir + 5 ideias V23.

---

A única métrica que importa agora: **primeiro cliente a pagar esta semana.**

════════════════════════════════════════════════════════════
FIM DO COMANDO
════════════════════════════════════════════════════════════
