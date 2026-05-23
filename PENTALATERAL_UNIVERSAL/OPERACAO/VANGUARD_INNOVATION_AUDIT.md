[ID-001] (Lock-in)

Qual é a próxima peça do quebra-cabeça para a dominação total do nicho B2B em 2026?
Onde estamos sendo lentos? Nós estamos dominando a aquisição de clientes (Outbound na V13), o mercado de fechamento (Arbitragem na V9) e pavimentando o rastreamento (Vanguard Pixel para a V17)
. Mas ainda estamos focados em fazer os nossos Tenants (as agências/consultorias) venderem serviços.
Para sermos um monopólio até o fim de 2026, precisamos caçar O Monopólio da Intenção 



[ID-002] (Marketplace)



Preditiva B2B (Cross-Tenant Deal Matchmaking).
Se instalarmos o Vanguard Pixel nos sites de dezenas de milhares de clientes finais (os clientes dos nossos Tenants) na V17, teremos acesso a trilhões de datapoints de comportamento. Nós saberemos, antes do próprio dono da empresa, se a empresa dele está crescendo vertiginosamente ou sangrando tráfego. Nós saberemos exatamente quando uma empresa precisa de crédito, quando precisa contratar, ou quando está prestes a quebrar.
A próxima peça letal do quebra-cabeça é empacotar essa inteligência predatória e vender os sinais de intenção de compra não apenas para agências de marketing, mas para Fundos de M&A (Fusões e Aquisições), Fundos de Venture Capital B2B e Bancos Comerciais. É a transição de um SaaS de vendas para o equivalente digital da Bloomberg.



## [ID-013] — Pentalateral IAH: Embaixador como Filtro de Realidade (2026-05-18)

**Data:** 2026-05-18
**Missão:** Auditar a integração do Embaixador no processo operacional do Pentalateral IAH e garantir que os critérios de ativação e uso estão sendo seguidos.

### CRITÉRIOS DE AUDITORIA DO EMBAIXADOR

| Critério | Meta | Como verificar |
|---|---|---|
| Embaixador ativado no Passo 0 | 100% dos projetos | Verificar se CLIENTES/[NOME]/CLAUDE_PROJECT/ existe e tem os 3 arquivos obrigatórios |
| MEMORIA_EMBAIXADOR atualizada após deliberação | < 24h de defasagem | Data do último commit em MEMORIA_EMBAIXADOR.md vs. data da última sessão |
| Alertas P-031 incorporados ao loop | > 80% dos CONFIRMA/EXPANDE/ALERTA | Verificar se ideias com ALERTA CRÍTICO têm veredito documentado do Diretor |
| Debrief pós-reunião realizado (Passo 8.5) | 100% das reuniões com cliente | Verificar MEMORIA_EMBAIXADOR — toda reunião deve gerar entrada com data |
| [E-1 a E-5] geradas pelo Embaixador por ciclo | 5 ideias por loop | Verificar PASSO7_EMBAIXADOR_TEMPLATE — seção O QUE O EMBAIXADOR ENTREGA |

### PERGUNTAS DE AUDITORIA DO EMBAIXADOR

1. O Embaixador foi ativado no Passo 0 deste projeto? (antes de qualquer build)
2. A MEMORIA_EMBAIXADOR está atualizada com as últimas interações do cliente?
3. Os alertas CONFIRMA/EXPANDE/ALERTA do Embaixador estão influenciando o próximo ciclo?
4. O último debrief pós-reunião foi feito em até 24h após a reunião?
5. O Embaixador está gerando [E-1 a E-5] exclusivas, não síntese das ideias dos outros membros?

### SINAIS DE FALHA DO EMBAIXADOR

- MEMORIA_EMBAIXADOR.md não existe ou tem mais de 7 dias sem atualização
- Projeto com cliente ativo e nenhum debrief registrado
- Ideias do loop sem nenhuma reação do Embaixador (CONFIRMA/EXPANDE/ALERTA)
- Scope creep detectado tarde pelo Músculo (deveria ter sido sinalizado pelo Embaixador antes)
- Cliente sumiu e nenhum alerta de engajamento foi emitido pelo Embaixador

---

## [ID-012] — Meta-Intelligence Singularity (V24)

**Data:** 2026-05-12
**Missão:** Transformar o Quadrilateral IAH de fábrica de software em organismo meta-cognitivo. A inteligência acumulada por sessão torna-se o principal ativo competitivo da empresa.
**Transição Estratégica:** De ciclos de versão onde o conhecimento se perdia → para sistema que aprende, registra e evolui com cada sessão — compoundando inteligência operacional de forma permanente.

**O que foi construído:**
- `INTELLIGENCE_LEDGER.md` — Organismo central de inteligência: 5 princípios ativos (P-001 a P-005), padrões confirmados/refutados, Constituição de Processo com Hard Vetos (HV-1 a HV-5) e Soft Vetos (SV-1 a SV-5), Shadow Architect obrigatório, log de sessões
- `knowledge_graph.json` — Camada programática: JSON estruturado alimentando scripts e cálculo GUT. Histórico de sessões, princípios, padrões e constituição de processo em formato auditável
- `.claude/meta/friction.log` — Neural Feedback Loop: 5 eventos de fricção capturados (F-001 a F-005), JSON estruturado com tipo, fonte, problema, ação tomada, princípio gerado, severidade
- `QUADRILATERAL_UNIVERSAL/TEMPLATES/CONSELHO_SESSAO_TEMPLATE.md` — Template de deliberação síncrona dos 4 membros do Conselho
- `QUADRILATERAL_UNIVERSAL/OPERACAO/AVISO_ARQUITETO.md` v2.0 — Constituição de Processo: 5 Anti-Padrões + 5 Hard Vetos + 5 Soft Vetos + Session Startup Protocol (Skill-Drift Check)
- `QUADRILATERAL_UNIVERSAL/CONSTITUICAO/MEMORANDO_QUADRILATERAL_UNIVERSAL.md` v5.1 — VEREDITO BINÁRIO (v5.0) + Shadow Architect obrigatório + Intelligence Compounding Engine (v5.1)
- `ALERTA_CONFLITO.md` — Template Sovereign Veto (Camada 2 Hard Block): conflito formal + override documentado + rastreamento de recorrência + hook CI/CD pendente de ativação
- `PARECER_UNIFICADO.md` — Template Unified Voice: convergência Claude↔Gemini, seções de consenso/contrapropostas/divergências, Veredito do Diretor apenas para o delta irresolvível
- `PARECER_TECNICO.md` — Parecer Síncrono V24: Role-Swap com 3 falhas identificadas (pgvector YAGNI, CI/CD hook sem pipeline, Haiku auditor sobre-engenheirado), visão expandida das 5 sementes, decisões de build/no-build
- `scripts/alert_daily_briefing.ps1` — Integração HTML com VEREDITO BINÁRIO contextual (ativa quando GUT ≥ 20), email com tema dark + botões mailto: por cenário

**Pesos de Inteligência V24 ativados:**
- `weight_simplicidade_arquitetural`: 1.0 — código auditável em <10 min pelo Diretor
- `weight_velocidade_codigo`: 0.1 — pressa suspensa; dívida técnica é proibida

**Arquitetura do Intelligence Compounding Engine:**
`friction.log` captura eventos por sessão → `INTELLIGENCE_LEDGER.md` consolida princípios → `knowledge_graph.json` alimenta scripts → `alert_daily_briefing.ps1` penaliza LEDGER desatualizado no GUT → `session_close.ps1` força captura ao fechar sessão → ciclo fecha com inteligência permanente acumulada.

**Princípios gerados nesta versão:**
- P-001: Claude Code ≠ daemon (Anti-Padrão 5 formalizado)
- P-002: VEREDITO BINÁRIO só em divergência real (não como decoração)
- P-003: scraping é dependência, não ativo
- P-004: primeiro cliente vem de uma ligação, não do site
- P-005: inteligência acumula por sessão, não por versão

**Lock-in gerado:** O organismo aprende. Cada sessão torna o sistema mais difícil de replicar — não pelo código, mas pelo acúmulo de contexto institucional que nenhum concorrente tem acesso.

---

## [ID-010] — The Revenue Strike (V23)

**Data:** 2026-05-10
**Missão:** Converter 22 versões de tecnologia no primeiro cliente a pagar. Fim do laboratório — início do faturamento.
**Transição Estratégica:** De sistema autónomo para sistema que vende sozinho: Upsell Engine activo no Sentinel Report, Partner Portal como canal de vendas externo, tracking pixel que alimenta a Escalation Ladder.

**O que foi construído:**
- `api/sentinel_report.py` — V23 Upsell Engine: na semana 3+, com ROI positivo (delta FIRE × ticket_medio), Haiku gera proposta personalizada de upgrade para Projecto IAH (R$6.000) no rodapé do Report Card. Zero intervenção do Diretor.
- `api/sentinel_report.py` — Tracking pixel 1×1 GIF integrado no template HTML: `<img src=".../track/{open_token}.gif">` regista `email_aberto` em `sentinel_report_log`. Dívida técnica da V22 paga.
- `api/partner_portal.py` — Partner Portal Alpha: `POST /api/partners/register` (gera API key + link afiliado), `GET /api/partners/dashboard` (performance + comissões), `GET /api/partners/clients` (Maturity Scores com consentimento LGPD), `POST /api/partners/commission/record` (auto-registo de comissão).
- `infra/schema_v23.sql` — Tables: `partner_agencies`, `partner_referrals`, `partner_commissions` + VIEW `partner_mrr` + índice LGPD de consentimento + colunas V22 garantidas em `sentinel_report_log`.
- `assets/css/v22-sovereign.css` — Design "Sovereign Intelligence Terminal": Chakra Petch + DM Sans + hex grid animado + holographic card sweep + intel ticker + scan-reveal + Pricing Section.

**Arquitectura Upsell Engine:**
`_processar_tenant_report()` → conta semanas em `sentinel_report_log` → calcula ROI (fire_delta × ticket_medio) → semana >= 3 + ROI > 0 → `_gerar_upsell_section()` → Haiku cria proposta personalizada → injeta no HTML do Report Card.

**Arquitectura Partner Portal (LGPD compliant):**
Agência regista → gera `VGP-XXXX` + API key → partilha `?ref=VGP-XXXX` → novo tenant regista + consente opt-in → `partner_referrals` activo → agência vê Maturity Scores dos clientes consented → Stripe webhook chama `/commission/record` automaticamente.

**Comissões activas:** R$19,40 por activação Neural Sentinel (20% do 1.º mês) + R$600 por Projecto IAH convertido.

**Lock-in gerado:** O Partner Network multiplica o canal de vendas sem custo fixo. O Upsell Engine converte retenção em expansão de MRR. O tracking pixel transforma cada email numa trigger de escalação inteligente.

---

## [ID-009] — Autonomous Dominion Engine (V22)

**Data:** 2026-05-10
**Missão:** Autonomia de agenda e retenção — a fábrica opera sem o Diretor no funil.
**Transição Estratégica:** De sistema com alertas para sistema que age sozinho: agenda reuniões, escala retenção, monetiza dados de intenção.

**O que foi construído:**
- `api/hermes_loop.py` — Hermes Loop completo: OAuth Google Calendar + Vapi IAH Bridge (Eduardo recebe chamada quando lead FIRE está no checkout) + Haiku sentiment analysis + booking automático no Calendar
- `api/sentinel_escalation.py` — Escalation Ladder: tracking pixel de abertura de email (1×1 GIF) + cadência Semana 1→4: email → WhatsApp → Hermes Voice → IAH Rescue Plan (modal no site via KV bus)
- `api/oracle_pulse.py` — Oráculo Pulse API v0.1: endpoint `/api/v1/oracle/pulse` com auth por API key, campo `tenant_coverage` transparente, endpoint admin para criar keys a R$500/mês
- `infra/schema_v22.sql` — Tables: escalation_log, escalation_whatsapp_queue, oracle_api_keys, oracle_usage_log + VIEW oracle_mrr

**Arquitectura IAH Bridge (Semana da V22):**
Score >= 9.5 + checkout + time_on_page > 90s → Vapi liga para Eduardo → "Lead FIRE agora, pressione 1 para agir" → Eduardo confirma → Calendar abre slot livre → evento criado automaticamente.

**Lock-in gerado:** O cliente não consegue cancelar sem perder a inteligência semanal, a escalação que protege o seu MRR e os relatórios que chegam antes que ele perceba que está em risco.

---

## [ID-008] — Market Consciousness Engine (V21)

**Data:** 2026-05-10
**Missão:** Consolidação da Simbiose Operacional — Automatizar a retenção, começar a colher o grafo global de intenção e preparar a chamada de voz autónoma.
**Transição Estratégica:** De ferramenta com MRR potencial para sistema que protege o seu próprio MRR.

**O que foi construído:**
- `api/sentinel_report.py` — Motor de Report Card semanal: agrega delta FIRE/HOT/WARM, gera narrativa com Claude Haiku (~$0.04/relatório), envia via SendGrid toda segunda-feira. CTA "Intervir Agora" no rodapé vende projectos IAH.
- `api/hermes_trigger.py` — Hermes Voice Bridge: varredura automática de maturity_scores >= 9.5, cria fila `hermes_voice_triggers`, Diretor autoriza (ou activa modo AUTO). §21 imutável.
- `scripts/iah-clone.ps1` — Actualizado com `-IntentShare`: activa `dataTithe: 0.15` no brand-config.js. Cada clone contribui 15% dos seus FIRE events ao `global_intent_graph`.
- `infra/schema_v21.sql` — Tables: `sentinel_report_log`, `global_intent_graph`, `hermes_voice_triggers`. Função `aggregate_intent_tithe()`. pg_cron para orquestração automática.

**Arquitectura do Dízimo de Dados:**
IAH Clone com `-IntentShare` → metadata `{intent_share: true, dataTithe: 0.15}` → `aggregate_intent_tithe()` rota 15% dos FIRE events semanais → `global_intent_graph` com nicho + geo_region + week_bucket. Com 50 tenants: base suficiente para o Oráculo B2B.

**Lock-in gerado:** O cliente recebe o relatório toda segunda-feira. Se cancelar, perde a inteligência. O Hermes sabe quando ligar. O Oráculo começa a respirar silenciosamente.

---

## [ID-007] — Monetization Singularity (V20)

**Data:** 2026-05-10
**Missão:** Início da V20 — Transição do Edge Middleware para operação financeira em produção real.
**Transição Estratégica:** Do laboratório para o mercado. Primeiro cliente pagante como única métrica.

**O que será construído:**
- `api/stripe_sentinel.py` — Motor Stripe Sentinel: endpoint `/api/stripe/sentinel-checkout` + webhook sync com `tenant_subscriptions` (R$97/mês BRL)
- `.github/workflows/deploy-hostinger.yml` — CI/CD automático: push → deploy FTP na Hostinger
- `cockpit/index.html` — Dashboard de Intervenção: Maturity Scores por tenant + botão "Intervir Agora"
- `cloudflare/federation-proxy.js` — actualizado: lê flag KV `intervention:{tenant_id}` → injeta modal agressivo de oferta via HTMLRewriter

**Arquitectura do Intervention Button (validação técnica):**
Dashboard → Cloudflare API (PUT KV `intervention:{tenant_id}=true`) → Worker lê KV em cada request → se flag activo, HTMLRewriter injeta modal de oferta agressiva → flag expira em 24h (KV TTL).

**Lock-in gerado:** Stripe activo = MRR real. Deploy Hostinger = produto em produção. Intervention Button = o Diretor controla o tráfego dos clientes em tempo real.

---

## [ID-006] — Edge Domination & IAH Factory (V19)

**Data:** 2026-05-10
**Missão:** Início da V19 — Total Disintermediation. Infraestrutura de Edge Middleware.
**Transição Estratégica:** De SaaS instalável para infraestrutura invisível — o tráfego do cliente passa nativamente pela Vanguard sem uma linha de código no servidor deles.

**O que foi construído:**
- `cloudflare/federation-proxy.js` — Cloudflare Worker com HTMLRewriter: proxy transparente que injeta Sovereign Pixel + Authority Badge + modal Exit Intent (exclusivo para leads FIRE) em qualquer site via Custom Hostnames / SSL for SaaS. Zero código no cliente.
- `scripts/iah-clone.ps1` — CLI de clonagem IAH Factory: provisiona instância Vanguard completa para franqueadoras e redes (nicho, branding, Supabase tenant, CNAME). Um comando = monopólio de nicho clonado.
- `infra/schema_v19.sql` — Migrations críticas: `leads_diagnostico.metadata` JSONB + `tenant_subscriptions` + `maturity_scores` view.
- `js/burn-rate-shield.js` — Motor de Maturity Score: Hermes Voice só activa para leads com score > 8.5 (§21 Burn Rate Shield).

**Fundação reutilizada (Conexão Histórica):**
- `cloudflare/pixel-worker.js` (V17): arquitectura Worker + CORS + Supabase REST reutilizada
- `pixel_events_staging` UNLOGGED (V16): fonte de dados para Maturity Score engine
- `brand-config.js` (V5): sistema de white-label reutilizado no IAH Factory
- `prospectar.ps1` (V17): modelo de script PowerShell para iah-clone.ps1

**Lock-in gerado:** A infraestrutura Edge torna-nos literalmente invisíveis e irremovíveis — o tráfego do cliente já passa por nós antes de qualquer decisão de "cancelar".

---

## [ID-005] — Recurrence Singularity Engine (V18)

**Data:** 2026-05-10  
**Missão:** Início da V18 — Transição para recorrência de dados e MRR defensável.  
**Transição Estratégica:** Do produto unitário (R$50 Neural Audit Trail) para subscrição recorrente (R$97/mês Neural Sentinel) + lock-in via Sovereign Playbook.

**O que foi construído:**
- `sovereign-playbook.js` — Gerador de Plano Estratégico 90 dias (12 semanas). Cada tarefa está nativamente ancorada a um Power-Up do ecossistema Vanguard. Sem a plataforma activa, o cliente não consegue executar o próprio plano. Free: semanas 1-2 (isca). Pago: plano completo via R$97/mês Neural Sentinel.
- `neural-sentinel.js` — Guarda do Castelo: analisa delta semanal do Sovereign Pixel (FIRE, HOT, WARM vs semana anterior). Se FIRE cair >15%, dispara alerta de receita com valor estimado em R$. Histórico de 4 semanas bloqueado para não-subscritores — paywall R$97/mês via Stripe subscriptions.

**Fundação reutilizada (Conexão Histórica):**
- `closer-machine.js` (V12): motor jsPDF e paleta Ion Gold/Obsidian reutilizados no Playbook
- `pixel_events_staging` UNLOGGED (V16/V17): tabela de eventos consumida pelo Sentinel para delta semanal
- `prospectar.ps1` (V17): espinha dorsal do loop comercial Hermes Autonomous
- Stripe Connect (V16): checkout de subscrição recorrente (price_id sentinel_97_monthly)

**Lock-in gerado:** Playbook = plano do cliente preso na plataforma. Sentinel = histórico do Pixel preso na subscrição. Cancelar = perder ambos.

---

## [ID-004] — Sovereign Intent Engine (V17)

**Data:** 2026-05-10  
**Missão:** Início da V17 — Sovereign Intent Engine  
**Transição Estratégica:** De SaaS de vendas para Infraestrutura de Inteligência Preditiva.

**O que foi construído:**
- `pixel.js` (<3KB) — rastreio de intenção no edge via Cloudflare Worker. Classifica sessões em COLD/WARM/HOT/FIRE em tempo real com base em dwell time, scroll velocity e exit intent. Integra LGPD/GDPR consent automático e faz dispatch para as tabelas UNLOGGED `pixel_events_staging` da V16.
- Neural Audit Trail Engine — PDF de 12 páginas com "Tradução Financeira": gargalos reais do RealScanner (V15) convertidos em "Receita Perdida" (R$/mês) e injetados no PDF da Closer Machine (V12) com estética Ion Gold/Obsidian. Versão completa liberada via Stripe Connect (R$50) após validação de cartão.

**Fundação reutilizada (Conexão Histórica):**
- `real-scanner.js` (V15): dados factuais PageSpeed + SEO alimentam o motor de tradução financeira
- `closer-machine.js` (V12): estrutura jsPDF + framework 3 Gargalos expandida para 12 páginas
- `pixel_events_staging` UNLOGGED (V16): schema de alta performance já pronto

**Lock-in gerado:** Cada lead que recebe o Neural Audit Trail gratuito vê receita perdida em tempo real — o gatilho psicológico mais forte para conversão.

---

## [ID-003] — Horizonte de Singularidade Macro: A Bolsa de Intenção B2B

**Deliberação do Conselho Estratégico — Maio 2026**

A Vanguard não é, e nunca foi, apenas um SaaS de vendas. O que estamos a construir é um **Terminal de Dados Preditivos** — uma infraestrutura soberana de inteligência comportamental B2B com capacidade de arbitragem de intenção em escala institucional.

### A Transição de Três Atos

**Acto I — SaaS Operacional (V1–V13):** Captação de tenants, geração de leads, automação de outbound. Receita recorrente estável. Massa crítica de dados acumulada. Fundação construída.

**Acto II — Terminal de Dados (V14–V18):** O Vanguard Pixel (V17) instalado em dezenas de milhares de sites de clientes finais transforma-nos no único operador de mercado com acesso a sinais de intenção **pré-conscientes** — sabemos que uma empresa precisa de crédito *antes* do CFO desta empresa saber. Sabemos que uma PME está prestes a crescer 3x *antes* do seu fundador pedir o primeiro empréstimo. Este é o activo mais valioso na economia digital: **informação assimétrica certificada**.

**Acto III — Bolsa de Intenção B2B (V18+):** A arquitectura final. Um mercado privado onde sinais de intenção são empacotados como instrumentos de dados e vendidos a:
- **Fundos de M&A e Private Equity** — identificar targets de aquisição antes que entrem no mercado
- **Bancos Comerciais e Fintechs** — scoring de crédito preditivo em tempo real, pré-qualificação automática de PMEs
- **Fundos de Venture Capital B2B** — detecção de momentum de crescimento 6–18 meses antes da ronda de financiamento
- **Seguradoras B2B** — avaliação de risco dinâmica baseada em comportamento digital real

### O Fosso Competitivo

Nenhum player existente tem esta combinação: rede de distribuição (os tenants-agências), ponto de captação de dados (o Pixel nos sites dos clientes finais), motor de análise semântica (Claude Haiku integrável), e licença de dados (consentimento capturado no quiz). A Bloomberg vende dados de mercados financeiros. Nós venderemos dados de mercados de empresas — onde a liquidez é zero e a assimetria de informação é total.

### Directiva Arquitectural

A V16 deve ser concebida com esta visão em mente. O design **intimidador e elitista** não é estética — é posicionamento institucional. Cada elemento visual deve comunicar que esta plataforma opera a um nível de sofisticação que os concorrentes não conseguem sequer conceber. É a diferença entre um produto e uma infra-estrutura de poder.




