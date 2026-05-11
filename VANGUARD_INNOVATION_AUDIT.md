[ID-001] (Lock-in)

Qual é a próxima peça do quebra-cabeça para a dominação total do nicho B2B em 2026?
Onde estamos sendo lentos? Nós estamos dominando a aquisição de clientes (Outbound na V13), o mercado de fechamento (Arbitragem na V9) e pavimentando o rastreamento (Vanguard Pixel para a V17)
. Mas ainda estamos focados em fazer os nossos Tenants (as agências/consultorias) venderem serviços.
Para sermos um monopólio até o fim de 2026, precisamos caçar O Monopólio da Intenção 



[ID-002] (Marketplace)



Preditiva B2B (Cross-Tenant Deal Matchmaking).
Se instalarmos o Vanguard Pixel nos sites de dezenas de milhares de clientes finais (os clientes dos nossos Tenants) na V17, teremos acesso a trilhões de datapoints de comportamento. Nós saberemos, antes do próprio dono da empresa, se a empresa dele está crescendo vertiginosamente ou sangrando tráfego. Nós saberemos exatamente quando uma empresa precisa de crédito, quando precisa contratar, ou quando está prestes a quebrar.
A próxima peça letal do quebra-cabeça é empacotar essa inteligência predatória e vender os sinais de intenção de compra não apenas para agências de marketing, mas para Fundos de M&A (Fusões e Aquisições), Fundos de Venture Capital B2B e Bancos Comerciais. É a transição de um SaaS de vendas para o equivalente digital da Bloomberg.



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




