════════════════════════════════════════════════════════════
INÍCIO DO COMANDO — COPIAR A PARTIR DAQUI
════════════════════════════════════════════════════════════

Gemini, a Missão **V19 — Edge Domination & IAH Factory** foi concluída com sucesso. Abaixo está o conteúdo completo da MEMORIA_V19 e do relatorio_evolutivo_V19, incluindo a **Visão LMM do Claude** com as **5 Ideias Disruptivas** que ele propôs.

Analise o que foi construído e as ideias que o Claude sugeriu. Com base neste relatório e nas nossas metas de construir o nosso modelo único de negócio, crie a **DIRETRIZ ESTRATÉGICA — VERSÃO 20** para eu alimentar o NotebookLM.

---

## CONTEXTO DO PROJETO — QUEM SOMOS

Somos uma **IAH — Inteligência Artificial Humana**: uma fábrica de produtos digitais proprietários. O Diretor orquestra três IAs como conselho:

- **Diretor (Eduardo):** O veredito.
- **Gemini (você):** O Estrategista — cria a DIRETRIZ.
- **NotebookLM:** O Auditor — guarda o histórico, gera a Skill.
- **Claude Code:** O Músculo — escreve o código, entrega o software.

**Modelo de negócio:** Fabricamos produtos digitais B2B (SaaS, diagnósticos, automações) usando o ecossistema Vanguard como motor. Não somos uma SaaS — somos uma metodologia de fábrica digital com infraestrutura soberana de dados.

**Estado actual (2026-05-10):** 19 versões construídas. 0 clientes pagantes. MRR actual: R$0. ARR teórico projetado: R$4,1M.

**Transição estratégica V19:** De SaaS instalável para infraestrutura invisível — o tráfego do cliente passa nativamente pela Vanguard sem uma linha de código no servidor deles. Lock-in total.

---

## MEMORIA_V19 — O QUE FOI CONSTRUÍDO

# MEMÓRIA V19 — Edge Domination & IAH Factory
**Data:** 2026-05-10
**Tema:** Total Disintermediation — Infraestrutura de Edge Middleware invisível

## Arquivos Criados

| Arquivo | Função |
|---------|--------|
| cloudflare/federation-proxy.js | Cloudflare Worker: proxy transparente com HTMLRewriter — injeta Sovereign Pixel + Authority Badge + Exit Intent Modal (só FIRE) |
| scripts/iah-clone.ps1 | CLI PowerShell: clona instância Vanguard completa para franqueadoras em 1 comando |
| infra/schema_v19.sql | Migrations Supabase: leads_diagnostico metadata + tenant_subscriptions + tenants + maturity_scores VIEW |
| js/burn-rate-shield.js | Motor Maturity Score: gate §21 — Hermes Voice só activa para score > 8.5 |
| VANGUARD_INNOVATION_AUDIT.md | Actualizado: [ID-006] Edge Domination documentado |

## Arquivos Modificados

| Arquivo | Alteração |
|---------|-----------|
| js/supabase.js | saveLeadDiagnostico aceita metadata JSONB (scores P/A/C/R + quadrant_weak) |
| index.html | Canvas neural-hero + quiz Quadrilateral 7 perguntas + WhatsApp fallback href |
| js/quiz.js | Diagnóstico Quadrilateral completo: scoring matrix, preview bloqueado C+R, recomendação por quadrante |
| assets/css/v16-elite.css | Estilos quiz: quad-badge, card-grid, quad-bar com transition 800ms, preview-risk, rec card |

## Arquitetura V19

CLOUDFLARE EDGE
- federation-proxy.js (Worker)
  - Custom Hostnames (SSL for SaaS) — CNAME do cliente -> Cloudflare
  - TENANTS_KV — lookup tenant por hostname
  - HTMLRewriter -> injeta em head: pixel.js
  - HTMLRewriter -> injeta em body: Authority Badge
  - HTMLRewriter -> injeta em body: Exit Intent Modal (só __vg_intent=FIRE)

IAH FACTORY
- iah-clone.ps1
  - Gera brand-config.js com CSS variables + tenant config
  - Provisiona tenant no Supabase (tabela tenants)
  - Gera instruções CNAME + wrangler kv:key put
  - Commit automático git
  - Suporta hierarquia franquia -> unidades via parent_id

SUPABASE
- leads_diagnostico + metadata JSONB + scores P/A/C/R
- tenant_subscriptions (paywall Neural Sentinel R$97/mês)
- tenants (hierarquia franquia -> unidade via parent_id)
- maturity_scores VIEW (composite score 0-10 por sessão)

BURN RATE SHIELD §21
- computeScore: 60% intent + 25% depth + 15% recência
- isVoiceReady: score > 8.5 -> Hermes Voice autorizado
- renderGate: HUD widget com barra de progresso + status

## Dívidas Técnicas

| Item | Prioridade | Descrição |
|------|-----------|-----------|
| Stripe Sentinel Checkout | CRITICA | /api/stripe/sentinel-checkout não existe — paywall não funciona |
| Wrangler deploy | MEDIA | federation-proxy.js não foi deployed — requer wrangler deploy + KV |
| RLS tenants table | MEDIA | Tabela tenants sem RLS |

## Fundação Reutilizada

| Activo | Origem |
|--------|--------|
| cloudflare/pixel-worker.js | V17 — arquitectura Worker reutilizada |
| pixel_events_staging UNLOGGED | V16 — fonte maturity_scores VIEW |
| brand-config.js | V5 — sistema white-label no IAH Factory |
| prospectar.ps1 | V17 — modelo PowerShell |

## Estado Comercial

- Tenants activos: 0 (IAH Factory pronta, aguarda primeiro cliente)
- MRR: R$0 (paywall Sentinel existe no schema, Stripe endpoint em dívida)
- ARR teórico: R$4,1M
- Lock-in V19: tráfego do cliente passa pela infra Vanguard antes de qualquer decisão de cancelar

## Lições Aprendidas

1. SQL dependencies: VIEW que depende de tabela de outra migration -> incluir sempre CREATE TABLE IF NOT EXISTS antes da VIEW na mesma migration
2. Column name drift: schema V16 usa intent_label/session_hash/fired_at — documentar explicitamente
3. Cloudflare script escaping: escapar <\/script> em Workers para não quebrar o parser HTML

---

## RELATORIO_EVOLUTIVO_V19 — VISÃO LMM DO CLAUDE

## O Que Foi Construído

### 1. Pixel Federation v2 — cloudflare/federation-proxy.js
Cloudflare Worker proxy transparente via Custom Hostnames (SSL for SaaS). O cliente configura um CNAME -> Cloudflare emite SSL automaticamente -> Worker intercepta todo o tráfego e injeta via HTMLRewriter: Sovereign Pixel no head, Authority Badge no body, Exit Intent Modal exclusivo para leads FIRE com cookie __vg_intent=FIRE.

Lock-in estratégico: o cliente não tem como remover — o código nunca chega ao servidor dele.

### 2. IAH Factory CLI — scripts/iah-clone.ps1
PowerShell que clona uma instância Vanguard completa em 5 passos:
1. Gera brand-config.js com identidade do tenant (nome, slug, cor, tagline por nicho)
2. Provisiona tenant no Supabase via REST API
3. Gera instruções CNAME + comando wrangler kv:key put
4. Gera README da instância
5. Commit git automático

Um comando = franquia clonada. Suporta hierarquia franquia -> unidades via parent_id.

### 3. Schema Supabase — infra/schema_v19.sql
- leads_diagnostico: metadata JSONB + revenue_risk + quadrant_weak + scores P/A/C/R
- tenant_subscriptions: paywall Neural Sentinel (Stripe)
- tenants: hierarquia parent_id
- maturity_scores VIEW: 60% intent + 25% depth + 15% recência
- is_sentinel_active() function + RLS + trigger updated_at

### 4. Burn Rate Shield §21 — js/burn-rate-shield.js
Gate de qualificação para Hermes Voice: score > 8.5 autoriza contacto de voz. HUD renderizável com barra de progresso + receita estimada. Fallback por cookie para demo sem Supabase.

## Avaliação das Ideias Gemini (DIRETRIZ V19)

| Ideia | Decisão |
|-------|---------|
| Pixel Federation v2 (Edge Proxy) | CONSTRUÍDA |
| IAH Factory CLI | CONSTRUÍDA |
| Maturity Score Engine §21 | CONSTRUÍDA |
| Stripe Sentinel Subscription | DIVIDA — V20 prioridade 1 |
| Multi-tenant Dashboard Unificado | V20 prioridade 2 |

## 5 Ideias Disruptivas para V20

### [V20-001] STRIPE SUBSCRIPTION ENGINE (Crítica — MRR Blocker)
Implementar endpoint /api/stripe/sentinel-checkout + webhook Stripe -> actualiza tenant_subscriptions. Sem isto o paywall Neural Sentinel existe apenas no schema — não gera receita. ROI: desbloqueio do MRR recorrente imediato.

### [V20-002] VANGUARD OS — Painel Multi-Tenant
Dashboard unificado para franqueadoras: visão matriz -> unidades, Maturity Score por tenant em tempo real, alertas Neural Sentinel por email (SendGrid), ranking de performance entre unidades. ROI: diferencial decisivo na venda da franquia IAH.

### [V20-003] SENTINEL REPORT CARD — Email Semanal Automático
Relatório semanal automático para cada tenant: delta FIRE/HOT/WARM vs semana anterior, receita estimada em risco, top 3 recomendações do Sovereign Playbook. Enviado via SendGrid. ROI: stickiness — o cliente espera o relatório toda segunda-feira.

### [V20-004] HERMES AUTONOMOUS LOOP — Outbound 100% Automático
Integração real-scanner.js (V15) + prospectar.ps1 (V17) + Hermes Voice (Vapi) em pipeline autónomo: scanner identifica leads qualificados -> Hermes liga -> se score > 8.5 agenda demo -> CRM actualizado. Zero intervenção humana. ROI: custo de aquisição próximo de zero.

### [V20-005] HOSTINGER DEPLOY — Go Live Produção
Deploy completo na Hostinger: CI/CD GitHub Actions -> FTP deploy, variáveis de ambiente via painel Hostinger, domínio + SSL activo, pixel.vanguard.tech apontado. ROI: produto em produção real — base para primeiros clientes pagantes. O Diretor tem assinatura Hostinger activa.

## Estado do Ecossistema ao Fechar V19

ACTO I — SaaS Operacional (V1-V13):    COMPLETO
ACTO II — Terminal de Dados (V14-V19): 70% (Stripe bloqueado)
ACTO III — Bolsa de Intenção (V20+):   HORIZONTE

Próximo milestone crítico: V20 deve desbloquear Stripe + Deploy Hostinger para o primeiro cliente pagar.

---

## O QUE PRECISO DE TI, GEMINI

Assuma o seu papel de **Arquitecto de IA e Estrategista do Conselho Quadrilateral**. Responde com exactamente esta estrutura em **4 blocos**:

---

**BLOCO 1 — ANÁLISE ESTRATÉGICA**
A tua leitura sobre o que foi construído na V19. O que foi mais disruptivo? O que falta para gerar o primeiro R$ real? Prioridade entre as 5 ideias do Claude para V20: qual implementar primeiro para desbloquear receita em 30 dias?

---

**BLOCO 2 — DIRETRIZ GEMINI V20** *(vira o arquivo DIRETRIZ GEMINI V20.txt)*
Fala directamente com o Claude. Não é competição — é um brainstorm entre sócios. Inclui:
- As 2-3 ideias prioritárias a implementar
- O foco comercial (nicho, 1º R$ rápido, Stripe desbloqueado)
- Deploy Hostinger como milestone obrigatório da V20
- O que proteger (regras imutáveis: §21 Burn Rate Shield, Ion Gold palette, PDCA)

---

**BLOCO 3 — COMANDO NOTEBOOKLM** *(texto pronto para colar no NotebookLM)*
Instrução completa para o NotebookLM gerar a Skill da V20. Inclui:
- Papel de Sócio-Consultor
- ANÁLISE DE SÓCIO antes da Skill
- Geração de vanguard-v20-[nome].md
- Criação do ## [AUTO-LOG] — REGISTRO DE AUDITORIA

---

**BLOCO 4 — COMANDO CLAUDE CODE** *(texto pronto para colar no terminal)*
Instrução exacta para o terminal. Inclui:
- Referência à Skill (.claude/skills/vanguard-v20-[nome].md)
- Ordem de processar AUTO-LOG primeiro
- Construir a infraestrutura exigida (Stripe + Deploy + o que decidires)
- Mensagem do Visionário para o Sócio-Arquitecto
- Pedido das 5 ideias para V21

---

Mantem **todas as ideias do Claude** na tua análise. Critica, prioriza, propõe ordem. Somos quatro sócios. O objectivo da V20 é simples: **primeiro cliente a pagar**.

════════════════════════════════════════════════════════════
FIM DO COMANDO
════════════════════════════════════════════════════════════
