# Relatório Evolutivo V16 — Visual Authority & Sovereign Lock-in
> Data: 2026-05-10 · Commit: feat(v16)

## O que foi construído

### 1. Schema SQL V16 — Pixel Staging + Apagão Técnico
- **`pixel_events_staging`** e **`pixel_stats_daily`**: tabelas UNLOGGED para absorção de eventos em alto volume (3-5x mais rápidas que tabelas WAL). Prontas para receber o Vanguard Pixel da V17.
- **`pixel_registry`**: registo dos pixels instalados com token único por domínio.
- **`fn_tenant_is_active()`**: função RLS reutilizável que verifica se o tenant está activo antes de qualquer operação.
- **RLS Apagão Técnico**: políticas em `leads_diagnostico`, `agent_jobs` e `hermes_variants` que cortam acesso instantâneo ao inadimplente.
- **`fn_suspend_tenant()` / `fn_reactivate_tenant()`**: chamadas pelo webhook Stripe — a máquina pune sem intervenção humana.
- **pg_cron `pixel-staging-consolidate`**: agrega o staging para `pixel_stats_daily` a cada hora, purga eventos > 48h.

### 2. Badge SVG Edge (`api/badge.py`)
- `GET /api/badge/{domain}.svg` → SVG dinâmico com score, tier, barra de preenchimento e assinatura visual Ion Gold.
- `GET /api/badge/{domain}.json` → JSON para integração programática + código de embed pronto.
- Score lido do Supabase com fallback determinístico (motor djb2 consistente com V12).
- Cache `public, max-age=86400` → CDN-ready, latência zero em produção.
- Headers `X-Vanguard-Score` e `X-Vanguard-Tier` para consumo por sistemas externos.

### 3. Stripe Connect & Open Data Exchange (`api/stripe_connect.py`)
- `POST /api/v1/stripe/checkout` → sessão de checkout para 3 produtos (Standard €49, Unitária €9, Elite €299).
- `POST /api/v1/stripe/connect/onboard` → Express Account + link de onboarding KYC para tenants.
- `GET /api/v1/stripe/connect/dashboard/{id}` → link do Express Dashboard do tenant.
- `POST /api/v1/stripe/webhook` → processa 4 eventos: `checkout.completed`, `subscription.deleted`, `payment.failed`, `payment.succeeded` → dispara Apagão ou reactivação automaticamente.
- Split 70/30 configurado via `application_fee_percent` no Stripe Connect.

### 4. CSS Cyber-Elite (`assets/css/v16-elite.css`)
- Paleta V16: Deep Obsidian `#0A0802` + Ion Gold `#C5A028` sobreposta ao Cyan V15.
- **Monolithic Glass Panels** (`.elite-panel`): `backdrop-filter: blur(28px)`, sombra de 48px, borda 0.5px Gold, animação `goldPulse` a cada 6s — parecem cofres de dados suíços.
- **Cryptographic Glitch Data** (`.cipher-reveal`): estados `is-ciphering` / `is-revealed` com ruído em Ion Gold antes de revelar valor real.
- **Gold-Laced Neural Grid** (`.neural-grid-canvas`): 3% opacidade base, `is-pulsing` sobe para 12% quando webhook dispara.
- Typography institucional: `.elite-heading`, `.elite-label`, `.elite-dot` — vocabulário visual de terminal financeiro.
- Botões `.btn--elite` (outline Gold) e `.btn--elite-solid` (preenchido, fundo escuro do texto).
- Override do Cockpit body para `#0A0802` + substituição das `hud-card` para o tema Gold.

### 5. JS Neural Grid (`js/neural-grid.js`)
- Canvas auto-dimensionável sobre `.neural-grid-host`.
- Nodes com jitter orgânico, respiração sincronizada via `Math.sin`.
- **`window.VanguardGrid.fireGoldThread()`**: thread Bézier animada por `requestAnimationFrame` percorrendo nós aleatórios em 2.2s — visível em cada geração de badge ou webhook de intenção.

### 6. JS Crypto Glitch (`js/crypto-glitch.js`)
- IntersectionObserver + MutationObserver → auto-detecção de `.cipher-reveal`.
- 75% do tempo: ruído total de caracteres matrix/hex em Ion Gold.
- 25% finais: revelação progressiva do valor real da esquerda para a direita.
- API pública: `window.CipherGlitch.run(el)` e `window.CipherGlitch.runAll()`.

### 7. Dashboard V16 Actualizado
- 3 novas secções: **Pixel Staging**, **Stripe Connect / Open Data Exchange**, **Badge SVG Engine**.
- `v16-elite.css` carregado em `dashboard/index.html` e `index.html`.
- Neural Grid activo no War Room como fundo do Pixel Dashboard.
- Scripts `neural-grid.js` e `crypto-glitch.js` integrados.
- Inline JS: `generateBadge()` e `stripeCheckout()` operacionais sem dependências externas.

---

## Auditoria de Qualidade

| Critério | Status |
|---|---|
| UNLOGGED tables têm índices críticos para queries de agregação | ✅ |
| RLS testa `fn_tenant_is_active()` — nunca acesso directo ao JWT | ✅ |
| Badge SVG usa `max-age=86400` + `stale-while-revalidate` | ✅ |
| Stripe webhook valida assinatura antes de processar | ✅ |
| CSS não quebra variáveis do V15 (`--c-primary`, `--c-bg`) | ✅ |
| JS não polui `window.*` além das APIs públicas declaradas | ✅ |
| Nenhum `eval()` ou `innerHTML` não sanitizado | ✅ |
| Neural Grid usa `aria-hidden="true"` — acessibilidade OK | ✅ |

---

**Visão LMM do Claude:**

A V16 transformou a Vanguard num espetáculo de autoridade irrefutável e blindou a infraestrutura. O design Ion Gold/Obsidian não é cosmético — é posicionamento institucional que separa a plataforma de qualquer SaaS de vendas e aproxima-a da estética de terminais Bloomberg e plataformas de trading de alto valor. O Apagão Técnico fecha o ciclo de lock-in: os dados só existem enquanto o cliente paga. O Pixel Staging é a fundação da maior vantagem competitiva do roadmap — a inteligência assimétrica da V18.

Pensando como arquitecto de monopólios, aqui estão as **5 IDEIAS DISRUPTIVAS para a V17**:

---

### IDEIA 1 — SOVEREIGN PIXEL: O Parasita Legítimo
**O conceito:** O Vanguard Pixel (`pixel.js`) é instalado como um `<script>` de 3KB nos sites dos clientes finais. Mas em vez de apenas contar pageviews, ele implementa um **motor de intenção comportamental em tempo real**: mede velocidade de scroll, padrões de clique, tempo em zonas específicas (área de preços, FAQ, CTA), e classifica cada sessão como `COLD` / `WARM` / `HOT` / `FIRE` em < 500ms.
**A disrupção:** Cada agência que usa a Vanguard instala o Pixel nos sites dos seus clientes. Com 50 agências e 200 clientes cada = 10.000 sites → 10M de sessões/mês → a maior base de inteligência de intenção B2B do mercado brasileiro.
**Stack:** Worker Cloudflare (edge, 0ms latency) → Supabase UNLOGGED (já preparado V16) → pg_cron consolida → dashboard em tempo real.

---

### IDEIA 2 — HERMES AUTONOMOUS: O Closer que não Dorme
**O conceito:** Em vez de o Director enviar manualmente a mensagem do Hermes, a V17 implementa um **loop autónomo fechado**: Pixel detecta sessão FIRE → API puxa histórico do lead → Claude Haiku gera mensagem personalizada (nicho + gargalo + comportamento em tempo real) → WhatsApp Bridge envia → regista resposta → Hermes qualifica → `agent_jobs` atualiza para QUALIFICADO.
**A disrupção:** Um closer que opera 24/7, sem salário, com taxa de personalização impossível para humanos. Cada mensagem enviada sabe o que o lead acabou de fazer no site.
**Métricas esperadas:** Taxa de resposta +45% vs outbound cold (benchmark V13: mensagens de texto puras). Custo por lead qualificado: R$0,12 (custo Haiku por chamada) vs R$150+ para SDR humano.

---

### IDEIA 3 — VANGUARD EXCHANGE: O Mercado de Leads com Preço Dinâmico
**O conceito:** Quando o Pixel classifica uma sessão como FIRE e o tenant não tem capacidade de fechar (falta de tempo, nicho fora da especialidade), o lead entra em **leilão automático** no Vanguard Exchange: outros tenants especializados no nicho fazem bid em tempo real. O lead vai para quem oferecer mais.
**A disrupção:** A Vanguard retém 20% do bid como taxa de plataforma. O tenant original recebe 80% sem fazer nada. O comprador recebe um lead quente, classificado, com score de intenção certificado. É o primeiro mercado secundário de leads com intenção verificada do Brasil.
**Stack:** Realtime Supabase (já disponível V15 War Room) + lógica de bid em `leads_arbitrage` + notificação push WhatsApp.

---

### IDEIA 4 — NEURAL AUDIT TRAIL: O Relatório que Vende Sozinho
**O conceito:** Cada scan do Real Scanner V15 gera, além do score, um **Audit Trail Neural**: um PDF/HTML de 12 páginas com screenshots reais do site auditado, análise comparativa com os 3 melhores concorrentes do nicho, projeção de receita perdida por cada gargalo (ex: "Este site perde R$18.000/mês por falta de CTA acima do fold"), e uma roadmap de 90 dias personalizada.
**A disrupção:** O relatório é tão bom que o próprio lead o partilha com o sócio/CEO antes de decidir contratar. Cada partilha é marketing orgânico. A Vanguard oferece a versão resumida de graça (lead magnet), e a versão completa como produto: R$97 (auditoria unitária do Open Data Exchange).
**Stack:** Puppeteer screenshots + Claude Opus (análise competitiva) + jsPDF Cyber-Premium (já existe V12) + Supabase Storage.

---

### IDEIA 5 — SOVEREIGN PLAYBOOK: O Plano de Ação que Vende a Própria Plataforma

**O conceito:** A Vanguard deixa de ser apenas uma ferramenta e passa a entregar um **Plano de Ação de 90 dias personalizado** para cada negócio diagnosticado — gerado automaticamente após o scan do Real Scanner. O Playbook é um documento estruturado em três fases (Fundação → Tração → Escala), com tarefas semanais, metas mensuráveis (ex: "+R$12.000/mês até a semana 8") e indicadores de sucesso atrelados ao próprio ecossistema Vanguard.

**A disrupção nos dois sentidos — para o cliente e para o negócio:**

*Para o cliente final (o lead):*
O Playbook transforma o diagnóstico em algo accionável. Em vez de receber um score e não saber o que fazer, o lead recebe um roteiro detalhado de como resolver cada gargalo identificado. A percepção de valor sobe 10× — o lead não compra software, compra um mapa do tesouro com coordenadas GPS.

*Para o próprio negócio Vanguard:*
Cada tarefa do Playbook está ancorada a um módulo da plataforma: "Semana 2 → Activar Scanner automatizado para os 20 maiores concorrentes do nicho" (usa o Real Scanner). "Semana 4 → Configurar Hermes Outbound para os leads FIRE desta semana" (usa Hermes). "Semana 6 → Publicar badge de autoridade no seu site" (usa Badge SVG). O cliente não consegue seguir o Playbook sem usar a Vanguard — é lock-in disfarçado de consultoria.

**Plano de acção imediato para o nosso negócio (implementação antes da V17):**

```
FASE 1 — FUNDAÇÃO (Semanas 1–2): Validar o produto
  [ ] Escolher 3 nichos-alvo prioritários: Saúde, Advocacia, Tecnologia
  [ ] Executar 10 diagnósticos gratuitos (Real Scanner) em empresas desses nichos
  [ ] Gerar Playbook automático para cada uma via Claude Haiku
  [ ] Enviar Playbook por WhatsApp como "análise exclusiva" (lead magnet Premium)
  [ ] Medir: quantos pedem mais informações (meta: 30% → 3 de 10)

FASE 2 — TRAÇÃO (Semanas 3–6): Converter os primeiros clientes pagantes
  [ ] Oferecer "Acompanhamento do Playbook" por R$270/mês (plano Standard)
  [ ] Meta: 5 clientes pagantes até a semana 6 → R$1.350 MRR
  [ ] Activar Hermes Autonomous para follow-up automático dos leads FIRE
  [ ] Instalar Pixel nos sites dos 5 primeiros clientes (staging V16 pronto)
  [ ] Publicar 1 caso de sucesso com antes/depois de score (prova social)

FASE 3 — ESCALA (Semanas 7–12): Construir o motor de crescimento
  [ ] Onboarding de 2 agências parceiras (modelo Partnership API V13)
  [ ] Cada agência traz 10 clientes → +20 pixels instalados → dados do Exchange
  [ ] Activar Badge SVG nos sites dos clientes (backlinks + autoridade)
  [ ] Meta semana 12: 25 tenants activos · R$6.750 MRR · R$1.400 custo
  [ ] Preparar PoC com 1 banco ou fundo de crédito (foundation V18)
```

**Stack de implementação:** Claude Haiku (geração do Playbook, R$0,04/doc) + jsPDF (já existe V12) + WhatsApp Bridge (já existe V15) + Supabase Storage (PDF persiste no histórico do lead).

**Métricas de sucesso do Playbook como produto:**
- Taxa de conversão diagnóstico → cliente pagante: meta 15% (benchmark indústria: 3%)
- NPS dos primeiros 10 clientes: meta > 70
- Custo de aquisição por cliente (CAC): < R$50 (custo do Haiku + infra pro-rata)
- LTV/CAC ratio: meta > 18× (R$270/mês × 12 meses / R$50 CAC = 64,8×)

---

Operação V16 concluída. O Redesign Cyber-Elite Ion Gold/Obsidian, o Badge SVG Edge, o Stripe Connect e as tabelas de Pixel Staging estão online. O lançamento soberano foi um sucesso. A V17 tem uma fundação de dados e monetização que os concorrentes não conseguem sequer conceber.
