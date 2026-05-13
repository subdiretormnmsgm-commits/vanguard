════════════════════════════════════════════════════════════
INÍCIO DO COMANDO — COPIAR A PARTIR DAQUI
════════════════════════════════════════════════════════════

Gemini, a Missão **V20 — Monetization Singularity** foi concluída com sucesso. Abaixo está o conteúdo completo da MEMORIA_V20 e do relatorio_evolutivo_V20, incluindo a **Visão LMM do Claude** com as **5 Ideias Disruptivas** que ele propôs.

Analise o que foi construído e as ideias que o Claude sugeriu. Com base neste relatório e nas nossas metas, crie a **DIRETRIZ ESTRATÉGICA — VERSÃO 21** para eu alimentar o NotebookLM.

---

## CONTEXTO DO PROJETO — QUEM SOMOS

Somos uma **IAH — Inteligência Artificial Humana**: uma fábrica de produtos digitais proprietários. O Diretor orquestra três IAs como conselho:

- **Diretor (Eduardo):** O veredito.
- **Gemini (você):** O Estrategista — cria a DIRETRIZ.
- **NotebookLM:** O Auditor — guarda o histórico, gera a Skill.
- **Claude Code:** O Músculo — escreve o código, entrega o software.

**Estado actual (2026-05-10):** 20 versões construídas. 0 clientes pagantes. MRR: R$0. Motor de pagamentos pronto — aguarda MEI + Stripe live + deploy Hostinger.

**Transição estratégica V20:** O motor de receita está forjado. A única barreira que resta é operacional: MEI aberto, Stripe activo, git push.

---

## PLANO DE NEGÓCIO — ESTADO ACTUAL

Documento completo em PLANO_IMPLEMENTACAO_NEGOCIO.md. Resumo crítico:

**Bloqueadores identificados:**
1. Sem MEI/CNPJ -> Stripe BR não activa (Eduardo abre esta semana — gov.br, 30 min)
2. Stripe não configurado -> zero receita (Price ID + STRIPE_SENTINEL_PRICE_ID env var)
3. GitHub Secrets não definidos -> CI/CD não funciona (FTP_SERVER, FTP_USERNAME, FTP_PASSWORD)
4. Site não em produção -> cliente não acede (git push activa deploy automático)

**Primeira venda:** Neural Sentinel R$97/mês. Nicho alvo: clínicas médicas ou e-commerce de nicho.

---

## MEMORIA_V20 — O QUE FOI CONSTRUÍDO

**1. Stripe Sentinel Engine (api/stripe_sentinel.py)**
- POST /api/stripe/sentinel-checkout: cria Customer + Checkout Session R$97/mês BRL
- POST /api/stripe/sentinel-webhook: 4 eventos Stripe -> sincroniza tenant_subscriptions
- Router independente do stripe_connect.py V16 — zero regressão

**2. CI/CD Hostinger (.github/workflows/deploy-hostinger.yml)**
- Push master -> FTP deploy automático na Hostinger
- Exclui ficheiros sensíveis (api/, .claude/, NotebookLM/, etc.)
- Activar: 3 GitHub Secrets (FTP_SERVER, FTP_USERNAME, FTP_PASSWORD)

**3. Cockpit de Intervenção (cockpit/index.html)**
- Stats: tenants activos, sentinel, MRR, leads FIRE 24h
- Grid: Maturity Score por tenant + status Sentinel
- Botão "Intervir Agora": tipo + mensagem + TTL -> modal agressivo no site do cliente

**4. Intervention Button via KV Bus**
- Arquitectura: Cockpit -> intervention-worker.js -> KV.put(intervention:{tenantId}, TTL)
- federation-proxy.js lê KV em cada request -> HTMLRewriter injeta modal
- Zero latência, zero código no servidor do cliente, TTL configurável

**Dívidas técnicas:**
- STRIPE_SENTINEL_PRICE_ID: criar produto no Stripe Dashboard (R$97/mês BRL)
- GitHub Secrets: FTP_SERVER, FTP_USERNAME, FTP_PASSWORD
- COCKPIT_SECRET: wrangler secret put COCKPIT_SECRET

---

## RELATORIO_EVOLUTIVO_V20 — VISÃO LMM DO CLAUDE

**Avaliação das ideias Gemini V20:**
- Stripe Sentinel Engine: CONSTRUÍDO
- Cockpit de Intervenção: CONSTRUÍDO
- CI/CD Hostinger Deploy: CONSTRUÍDO
- Sentinel Report Card email: V21
- Hermes Autonomous Loop: V21

**5 Ideias Disruptivas para V21:**

[V21-001] ORÁCULO B2B — Intent Graph como Produto Institucional
Agregar dados FIRE cross-tenant -> API privada para bancos, fundos M&A, seguradoras. "Quais PMEs em SP tiveram sessões FIRE nas últimas 72h?" Ticket R$15.000/mês. Início do Acto III.

[V21-002] HERMES AUTONOMOUS LOOP COMPLETO
real-scanner -> lead qualificado -> Haiku gera mensagem -> WhatsApp -> Haiku classifica resposta -> score > 8.5 -> Vapi liga -> agenda demo -> CRM actualizado. Zero intervenção humana.

[V21-003] SENTINEL REPORT CARD — Vendedor de Retainers
Email semanal: delta FIRE/HOT/WARM + receita em risco + proposta IAH no rodapé. SendGrid + cron. O cliente espera o relatório toda segunda-feira.

[V21-004] IAH PROJECT CLONER com Dízimo de Dados
Cada instância clonada com dataTithe: 0.15 — 15% dos dados alimentam o Intent Graph global. Franqueado cresce, Oráculo fica mais inteligente.

[V21-005] SOVEREIGN CREDIT SCORE — PME como Activo Financeiro
Densidade FIRE + estabilidade de intenção -> score de solvência vendido a bancos. Alternativa ao balanço tradicional. Primeiro produto do Acto III.

**Estado do ecossistema:**
ACTO I (V1-V13): COMPLETO
ACTO II (V14-V20): 85% (aguarda deploy + Stripe live)
ACTO III (V21+): HORIZONTE

---

## O QUE PRECISO DE TI, GEMINI

Assuma o papel de **Sócio Estrategista do Conselho Quadrilateral**. Responde com **5 blocos**:

---

**BLOCO 0 — PLANO DE NEGÓCIO: SEQUÊNCIA DESTA SEMANA**
O motor está pronto. O que falta é operacional. Dá a sequência exacta de acções para o Eduardo executar esta semana para ter o primeiro cliente pagante. Inclui:
- Passo a passo MEI (gov.br)
- Passo a passo Stripe (produto + Price ID + webhook)
- Como configurar os GitHub Secrets da Hostinger
- Script de primeira abordagem WhatsApp (pronto para copiar)
- Qual nicho contactar primeiro e porquê

---

**BLOCO 1 — ANÁLISE ESTRATÉGICA V20**
O que foi mais disruptivo? O Intervention Button é realmente diferenciador ou é complexidade desnecessária? Qual a prioridade entre as 5 ideias do Claude para V21?

---

**BLOCO 2 — DIRETRIZ GEMINI V21** *(vira DIRETRIZ GEMINI V21.txt)*
Fala directamente com o Claude. Inclui:
- As 2-3 ideias técnicas prioritárias para V21
- Se o Oráculo B2B é prematuro ou o momento certo
- O que construir enquanto Eduardo angaria os primeiros clientes
- O que proteger (§21, Ion Gold, PDCA, KV bus)

---

**BLOCO 3 — COMANDO NOTEBOOKLM**
Instrução para gerar Skill V21 com ANÁLISE DE SÓCIO + vanguard-v21-[nome].md + AUTO-LOG [ID-008].

---

**BLOCO 4 — COMANDO CLAUDE CODE**
Instrução exacta para o terminal. Skill V21 + AUTO-LOG + construir + 5 ideias V22.

---

A única métrica que importa agora: **primeiro cliente a pagar esta semana.**

════════════════════════════════════════════════════════════
FIM DO COMANDO
════════════════════════════════════════════════════════════
