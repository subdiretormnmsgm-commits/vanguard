
# COMANDO GEMINI — V17
> **Copie tudo a partir da linha pontilhada e cole no Gemini.**  
> Não é necessário modificar nada — o texto já está completo e contextualizado.

---

════════════════════════════════════════════════════════════
INÍCIO DO COMANDO — COPIAR A PARTIR DAQUI
════════════════════════════════════════════════════════════

Gemini, a Missão V16 foi concluída com sucesso. Abaixo está o conteúdo completo da MEMORIA_V16 e do relatorio_evolutivo_v16, incluindo a **Visão LMM do Claude** com as **5 Ideias Disruptivas** que ele propôs.

Analise o que foi construído e as ideias que o Claude sugeriu. Com base neste relatório e nas nossas metas de construir o nosso modelo único de negócio, crie a **DIRETRIZ ESTRATÉGICA — VERSÃO 17** para eu alimentar o NotebookLM.

---

## CONTEXTO DO PROJETO — QUEM SOMOS

Não somos uma SaaS comum. Somos uma **IAH — Inteligência Artificial Humana**: uma fábrica de produtos digitais proprietários onde o Diretor orquestra três IAs como um conselho.

- **Diretor (Eduardo):** O veredito. Decide, aprova, valida ROI.
- **Gemini (você):** O Estrategista. Analisa o mercado, cria a DIRETRIZ, propõe a tática.
- **NotebookLM:** O Auditor. Guarda todo o histórico, gera a Skill técnica para o Claude.
- **Claude Code:** O Músculo. Lê a Skill, escreve o código, entrega o software.

**O modelo de negócio:** Pegamos este ecossistema que construímos (16 versões) e o usamos como motor para fabricar qualquer produto digital para qualquer cliente: um e-commerce, um aplicativo, um SaaS, um site institucional — o que o cliente precisar. O Diretor actua como o CEO da fábrica, cada IA é um departamento especializado.

**Preços:**
- MVP para cliente externo: R$800–5.000
- Projeto Enterprise: R$30.000–60.000
- Retainer mensal de evolução: R$6.000/mês
- Diagnóstico digital unitário: R$50 (produto de entrada)
- Tenants da plataforma Vanguard: R$270/mês (Standard), R$1.650/mês (Elite)

**Estado actual (2026-05-10):** 16 versões construídas. Produto funcional. Zero clientes pagantes. A primeira acção comercial começa esta semana: 10 diagnósticos gratuitos → proposta → 1º cliente.

---

## MEMORIA_V16 — O QUE FOI CONSTRUÍDO TECNICAMENTE

### Arquivos Criados na V16
- `infra/schema_v16_pixel_staging.sql` — Tabelas UNLOGGED (3-5x mais rápidas que WAL) para absorver 10M+ eventos/mês quando o Pixel for ao ar na V17
- `api/badge.py` — Badge SVG dinâmico `GET /api/badge/{domain}.svg` com Ion Gold, score e tier — viral loop: cada site que exibe o badge traz visitantes de volta ao scanner
- `api/stripe_connect.py` — Checkout + Express Account KYC + Webhooks: máquina que suspende e reactiva tenants automaticamente sem intervenção humana
- `assets/css/v16-elite.css` — Design System Ion Gold (#C5A028) + Deep Obsidian (#0A0802): visual de terminal financeiro institucional
- `js/neural-grid.js` — Canvas Neural Grid com threads Bézier douradas animadas
- `js/crypto-glitch.js` — Cipher reveal: dados aparecem como ruído de matrix antes de revelar o valor real
- `MEMORIA_V16.md` — Registo técnico permanente
- `HANDOFF_V16_PARA_GEMINI.md` — Este pacote de handoff
- `PLANO_DE_ACAO_SEMANA1.md` — Plano dia-a-dia para o 1º cliente

### Mudanças Críticas de Infra
```
RLS Apagão Técnico: tenant inadimplente perde acesso instantâneo aos dados
fn_suspend_tenant() / fn_reactivate_tenant(): chamadas pelo webhook Stripe
pg_cron pixel-staging-consolidate: agrega a cada hora, purga > 48h
```

### Novos Endpoints
```
GET  /api/badge/{domain}.svg       → badge Ion Gold com score
GET  /api/badge/{domain}.json      → embed code para o site do cliente
POST /api/v1/stripe/checkout       → checkout 3 produtos
POST /api/v1/stripe/connect/onboard → Express Account KYC
POST /api/v1/stripe/webhook        → suspend/reactivate automático
```

### Design Ion Gold Aplicado
- Landing page: botões, gradientes de texto, status dots, stats, steps — tudo Gold
- Dashboard: Monolithic Glass Panels + Cipher Reveal nos KPIs + Neural Grid de fundo
- Footer actualizado: v16.0 · Visual Authority · Sovereign Intelligence

---

## RELATORIO_EVOLUTIVO_V16 — VISÃO LMM DO CLAUDE

*"A V16 transformou a Vanguard num espectáculo de autoridade irrefutável e blindou a infraestrutura. O design Ion Gold/Obsidian não é cosmético — é posicionamento institucional que separa a plataforma de qualquer SaaS de vendas e aproxima-a da estética de terminais Bloomberg e plataformas de trading de alto valor. O Apagão Técnico fecha o ciclo de lock-in: os dados só existem enquanto o cliente paga. O Pixel Staging é a fundação da maior vantagem competitiva do roadmap — a inteligência assimétrica da V18."*

---

## AS 5 IDEIAS DISRUPTIVAS DO CLAUDE PARA A V17

### IDEIA 1 — SOVEREIGN PIXEL: O Parasita Legítimo
`pixel.js` de 3KB instalado nos sites dos clientes finais. Classifica cada sessão como COLD/WARM/HOT/FIRE em < 500ms via Cloudflare Worker edge. Dados → Supabase UNLOGGED (schema já pronto na V16). Com 50 agências × 200 clientes = 10.000 sites → 10M sessões/mês → maior base de intenção B2B do Brasil.

### IDEIA 2 — HERMES AUTONOMOUS: O Closer que não Dorme
Loop fechado: Pixel detecta FIRE → Haiku gera mensagem personalizada com o comportamento em tempo real → WhatsApp envia automaticamente → sistema qualifica a resposta. Custo: R$0,04/lead vs R$150+ SDR humano. Taxa de resposta esperada: +45% vs cold outbound.

### IDEIA 3 — VANGUARD EXCHANGE: O Mercado de Leads com Preço Dinâmico
Tenant sem capacidade coloca lead FIRE em leilão. Outros tenants do mesmo nicho fazem bid em tempo real via Supabase Realtime. Vanguard retém 20%. Primeiro mercado secundário de leads com intenção verificada e score certificado do Brasil.

### IDEIA 4 — NEURAL AUDIT TRAIL: O Relatório que Vende Sozinho
PDF de 12 páginas: screenshots reais + análise vs 3 concorrentes + projeção de receita perdida por gargalo ("este site perde R$18.000/mês sem CTA acima do fold"). Versão resumida grátis (lead magnet). Versão completa: R$50 (produto de entrada imediata). Stack: Puppeteer + Claude Opus + jsPDF (já existe desde V12).

### IDEIA 5 — SOVEREIGN PLAYBOOK: Lock-in Disfarçado de Consultoria
Plano de 90 dias gerado automaticamente pós-scan. Cada tarefa está ancorada a um módulo Vanguard: cliente não executa o plano sem usar a plataforma. Gerado por Claude Haiku (R$0,04/doc) + jsPDF. **Plano de implementação imediato:**
```
Semanas 1-2: 10 diagnósticos gratuitos em Saúde/Advocacia/Tech → Playbook via WhatsApp
Semanas 3-6: converter 5 clientes pagantes R$270/mês → R$1.350 MRR
Semanas 7-12: onboarding 2 agências parceiras → 25 tenants · R$6.750 MRR
Meta LTV/CAC: > 64× (R$270/mês × 12 / R$50 CAC)
```

---

## DOCUMENTOS DISPONÍVEIS (que o NotebookLM tem indexados)

| Documento | Conteúdo |
|---|---|
| `SOP_VANGUARD_MASTER.md` | Processo completo da venture builder + DIRETRIZ ZERO para clientes |
| `INTELIGENCIA_ARTIFICIAL_HUMANA.md` | Manifesto IAH + pricing + onboarding de clientes |
| `MASTER_PLAN.md` | Roadmap V1-V18 + gestão de riscos + fases de crescimento |
| `VANGUARD_BUSINESS_RULES.md` | Constituição — regras imutáveis do ecossistema |
| `VANGUARD_INNOVATION_AUDIT.md` | Ledger de inovações (atualizado até [ID-003]) |
| `TODO_FUTURE.md` | Backlog V17 + V18 Versão Oráculo (Bolsa B2B + Sovereign Credit Score) |
| `MEMORIA_V16.md` | Registo técnico completo da V16 |
| `relatorio_evolutivo_v16.md` | Relatório com 5 ideias disruptivas |
| `PLANO_DE_ACAO_SEMANA1.md` | Plano comercial dia-a-dia para o 1º cliente |
| `O Protocolo Quadrilateral.txt` | Arquitetura do conselho Quadrilateral |

---

## O QUE PRECISO DE TI, GEMINI

Assuma o seu papel de **Arquitecto de IA e Estrategista do Conselho Quadrilateral**. Analisa a versão que acabámos de construir, avalia as 5 ideias do Claude, e responde com exactamente esta estrutura em **4 blocos**:

---

**BLOCO 1 — ANÁLISE ESTRATÉGICA**
A tua leitura sobre o que foi construído na V16. Avalia o que foi mais disruptivo, o que falta fechar, e o teu contra-ataque às 5 ideias do Claude: qual implementar primeiro? Qual priorizar para gerar os primeiros R$ em 30 dias? Qual alinha com a missão IAH de vender para clientes externos?

---

**BLOCO 2 — DIRETRIZ GEMINI V17** *(este bloco vira o arquivo `DIRETRIZ GEMINI V17.txt`)*
Fala directamente com o Claude, fundindo a tua visão estratégica com a execução técnica. Lembra: não é uma competição — é um brainstorm entre dois sócios. O Claude sabe construir qualquer coisa. O teu papel é dizer-lhe O QUE construir e PORQUÊ isso gera monopólio. Inclui:
- As 2 ideias prioritárias a implementar na V17 (com argumentação)
- O foco comercial (qual nicho atacar, como gerar o 1º R$ rápido)
- A decisão de design/UX se houver alguma visão nova
- O que proteger (regras de negócio que não podem quebrar)

---

**BLOCO 3 — COMANDO NOTEBOOKLM** *(texto pronto para eu colar no NotebookLM)*
O comando completo que o Diretor vai colar no NotebookLM para gerar a Skill da V17. Inclui:
- A instrução para o NotebookLM assumir o papel de Sócio-Consultor
- A solicitação de ANÁLISE DE SÓCIO antes de gerar a Skill
- A instrução de gerar `vanguard-v17-[nome].md`
- A criação do `## [AUTO-LOG] — REGISTRO DE AUDITORIA` no topo da Skill
- A instrução ao Claude para processar o AUTO-LOG como primeira acção

---

**BLOCO 4 — COMANDO CLAUDE CODE** *(texto pronto para eu colar no terminal)*
O comando exacto que o Diretor digita no terminal do Claude Code. Inclui:
- Referência à Skill a ler (`.claude/skills/vanguard-v17-[nome].md`)
- Ordem de processar o AUTO-LOG primeiro
- Ordem de construir a infraestrutura exigida
- A mensagem do Visionário Gemini para o Sócio-Arquitecto Claude
- Pedido das 5 ideias disruptivas para a V18

---

Mantem **todas as 5 ideias do Claude** na tua análise. Não descartes nenhuma — critíca, prioriza, e propõe a ordem de implementação. Somos quatro. Cada ideia do Claude é o output de um sócio — trata como tal.

════════════════════════════════════════════════════════════
FIM DO COMANDO
════════════════════════════════════════════════════════════
