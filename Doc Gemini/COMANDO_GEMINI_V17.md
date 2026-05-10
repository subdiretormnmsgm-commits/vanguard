# TEMPLATE — Comando Gemini (Reutilizável para Qualquer Versão)
> Use este template para criar o COMANDO_GEMINI_VXX.md de cada nova versão.  
> Substitua os marcadores `V17`, `17`, `[NOME]` pelos valores corretos.

---

════════════════════════════════════════════════════════════
INÍCIO DO COMANDO — COPIAR A PARTIR DAQUI
════════════════════════════════════════════════════════════

Gemini, a Missão **V17 — [NOME DA VERSÃO]** foi concluída com sucesso. Abaixo está o conteúdo completo da MEMORIA_V17 e do relatorio_evolutivo_V17, incluindo a **Visão LMM do Claude** com as **[N] Ideias Disruptivas** que ele propôs.

Analise o que foi construído e as ideias que o Claude sugeriu. Com base neste relatório e nas nossas metas de construir o nosso modelo único de negócio, crie a **DIRETRIZ ESTRATÉGICA — VERSÃO 18** para eu alimentar o NotebookLM.

---

## CONTEXTO DO PROJETO — QUEM SOMOS

Somos uma **IAH — Inteligência Artificial Humana**: uma fábrica de produtos digitais proprietários. O Diretor orquestra três IAs como conselho:

- **Diretor (Eduardo):** O veredito.
- **Gemini (você):** O Estrategista — cria a DIRETRIZ.
- **NotebookLM:** O Auditor — guarda o histórico, gera a Skill.
- **Claude Code:** O Músculo — escreve o código, entrega o software.

**Modelo de negócio:** Fabricamos qualquer produto digital (e-commerce, app, SaaS, site) para qualquer cliente, usando o ecossistema que construímos como motor. Não somos uma SaaS — somos uma metodologia de fábrica digital, como uma McKinsey com IA.

**Estado actual ([2026-05-10]):** [X] versões construídas. [N] clientes pagantes. MRR actual: R$[VALOR].

---

## MEMORIA_V17 — O QUE FOI CONSTRUÍDO

# MEMORIA_V17 — Sovereign Intent Engine
> **Versão:** V17
> **2026-05-10:** 2026-05-10
> **Autor técnico:** Claude Code (Arquitecto-Mestre)
> **Protocolo:** Conselho Quadrilateral — Fase 4 — Encerramento de Ciclo

---

## 1. ARQUIVOS CRIADOS

| Arquivo | Função | Impacto |
|---|---|---|
| `js/pixel.js` | Sovereign Pixel <3KB: rastreio de intenção edge | Classifica COLD/WARM/HOT/FIRE em tempo real |
| `cloudflare/pixel-worker.js` | Cloudflare Worker: serve pixel.js + recebe eventos | Latência <500ms · deploy via wrangler |
| `js/neural-audit-trail.js` | Motor de Tradução Financeira + PDF 12 páginas | Gargalos → Receita Perdida R$/mês |
| `RITUAL_POS_VERSAO.md` | Padrão cronológico pós-versão (8 passos) | Ponte obrigatória código→venda |
| `scripts/prospectar.ps1` | Motor de prospecção: pipeline CSV + mensagens WhatsApp | Funil completo: captura→follow-up→fechamento |
| `MEMORIA_V17.md` | Este arquivo — memória técnica permanente | Auditoria futura |
| `relatorio_evolutivo_v17.md` | Relatório com 5 ideias V18 | Handoff Gemini |

---

## 2. ARQUIVOS MODIFICADOS

| Arquivo | Mudança | Detalhe |
|---|---|---|
| `index.html` | +scripts V17 | `real-scanner.js` + `neural-audit-trail.js` + auto-entrega Stripe |
| `VANGUARD_INNOVATION_AUDIT.md` | +[ID-004] | Sovereign Intent Engine — AUTO-LOG processado |
| `PROTOCOLO_INTERATIVO.md` | +PDCA + Directiva Arquitecto-Mestre | Ciclo obrigatório + Claude avalia Gemini |
| `scripts/fechar_versao.ps1` | +Bloco B comercial | Instrução de prospecção no fechamento |
| `DIRETRIZ_GEMINI.txt` | Actualizado V16→V17 | Estado actual + transição IAH |

---

## 3. ARQUITECTURA V17 — SOVEREIGN PIXEL

### pixel.js (<3KB)
- **Signals colectados:** dwell time (ms), scroll % máximo, CTA hover (ms), exit intent (mouseY<5px), clicks
- **Motor de classificação:** score ponderado → COLD (0–1) / WARM (2–3) / HOT (4–6) / FIRE (7+)
- **Consent:** banner LGPD/GDPR automático com localStorage `vp_consent`
- **Dispatch:** Beacon API (non-blocking) → POST `/v1/pixel` → Supabase `pixel_events_staging` UNLOGGED
- **API pública:** `window.VanguardPixel.getIntent()` para debug

### pixel-worker.js (Cloudflare Workers)
- **Route GET `/pixel.js?tid=X&sid=Y`:** serve o script com `window.__VP_CFG` injectado + Cache 1h
- **Route POST `/v1/pixel`:** valida campos obrigatórios + enriquece com `request.cf` (país, cidade, ASN) + persiste no Supabase
- **Segurança:** validação de `tenant_id` obrigatório + CORS headers + falha silenciosa (não afecta site do cliente)

---

## 4. ARQUITECTURA V17 — NEURAL AUDIT TRAIL

### Motor de Tradução Financeira
```
RealScanner V15 (dados PageSpeed reais)
        ↓
translateToFinancial()
        ↓
trafficEst = 500 + (score/10) × 9500 visitas/mês
convActual = (score/10) × 0.023 (benchmark B2B Brasil)
lostLeads  = traffic × (benchmarkConv − convActual)
lostRevenue = lostLeads × R$800 (ticket médio)
        ↓
bottlenecks[i].revenue_lost = lostRevenue × weight[i]
```

### Estrutura do PDF (12 páginas, Ion Gold + Deep Obsidian)
| Página | Conteúdo |
|---|---|
| 1 | Capa: domínio + Receita Perdida R$/mês (gatilho psicológico central) |
| 2 | Sumário Executivo: 3 KPIs + barra de conversão vs benchmark |
| 3 | Gargalos Críticos com Tradução Financeira (preview free termina aqui) |
| 4 | Análise Competitiva: tabela vs 3 concorrentes |
| 5 | Projeção ROI 90 dias + cronograma mês a mês |
| 6 | Plano de Acção 12 semanas |
| 7 | Benchmarks do Nicho |
| 8 | Análise Técnica Detalhada (PageSpeed real) |
| 9 | Roadmap Técnico V17 |
| 10 | Tabela de Investimentos |
| 11 | Depoimentos e Casos |
| 12 | Próximos Passos + Contacto + Garantia |

### Monetização Stripe Connect
- **Free:** 3 páginas (preview) — descarrega directamente
- **Paid R$50:** POST `/api/stripe/neural-audit-checkout` → Stripe Checkout → retorno `?audit_paid=1` → entrega automática
- **Fundação:** Stripe Connect V16 já existente

---

## 5. MOTOR COMERCIAL — prospectar.ps1

### Pipeline CSV (`2026-05-10/pipeline.csv`)
```
id | 2026-05-10_add | dominio | nome_contato | whatsapp | nicho | score |
receita_perdida | status | 2026-05-10_contato | 2026-05-10_resposta | notas
```

### Status do funil
`NAO_CONTACTADO → CONTACTADO → RESPONDEU → REUNIAO → PROPOSTA → FECHADO / PERDIDO`

### Funcionalidades
- **-add:** captura prospecto + gera mensagem WhatsApp personalizada + copia para clipboard + abre WhatsApp Web
- **-pipeline:** funil visual com barras + métricas (taxa resposta, conversão, MRR)
- **-followup:** detecta CONTACTADO há 2+ dias sem resposta → gera follow-up + abre WhatsApp
- **-scan domain:** abre scanner na landing + captura score/receita + adiciona ao pipeline
- **-stats:** taxa de resposta vs meta 15% + MRR vs meta R$1.350

---

## 6. PROTOCOLO INTERATIVO 2.0 — ACTUALIZAÇÕES

### Ciclo PDCA obrigatório
- **Plan:** Gemini propõe DIRETRIZ com 5 ideias para próxima versão
- **Do:** Claude constrói com Skill + contexto NotebookLM
- **Check:** Gemini avalia entregue vs planeado (Bloco 1 do próximo ciclo)
- **Act:** Diretor ajusta antes da próxima versão

### Directiva do Arquitecto-Mestre
- Claude avalia ordens do Gemini com perspectiva técnica
- Propõe alternativas quando há abordagem melhor
- Protege a arquitectura de atalhos que fecham portas futuras

---

## 7. RITUAL PÓS-VERSÃO — NOVA ADIÇÃO

**8 passos cronológicos com dependências explícitas:**
1. `fechar_versao.ps1` → gera MEMORIA + relatorio + COMANDO_GEMINI
2. NotebookLM upload → 07_MEMORIA + 08_relatorio
3. Gemini recebe COMANDO → gera 4 blocos
4. Bloco 2 → salvar como DIRETRIZ GEMINI V(XX+1).txt
5. Bloco 3 → NotebookLM → gera Skill
6. Skill salva em `.claude/skills/`
7. Bloco 4 → Claude inicia V(XX+1)
8. prospectar.ps1 → 20 contatos (em paralelo com 3–7)

---

## 8. ESTADO COMERCIAL

| Item | Estado |
|---|---|
| Clientes pagantes | 0 |
| Pipeline activo | 0 prospectos |
| MRR | R[COLAR AQUI O CONTEÚDO COMPLETO DE MEMORIA_VXX.md] |
| Ferramentas de venda prontas | Neural Audit Trail + prospectar.ps1 + Hermes |
| Próxima meta | 1 cliente em 30 dias via diagnóstico gratuito |

---

## 9. COMMITS DA V17

| Hash | Descrição |
|---|---|
| `1be6bba` | feat(v17): Sovereign Intent Engine — Pixel + Neural Audit Trail + PDCA |
| `e34e5b2` | feat(ritual): Motor de prospecção + Ritual Pós-Versão padrão |
| `97548f3` | docs(ritual): Instrução ao Conselho obrigatória pós-versão |
| `a6a3c2a` | docs(ritual): Sequência cronológica com mapa de dependências |


---

## RELATORIO_EVOLUTIVO_V17 — VISÃO LMM DO CLAUDE

# Relatório Evolutivo V17 — Sovereign Intent Engine
> **2026-05-10:** 2026-05-10
> **Versão:** V17
> **Status:** Concluída

---

## O QUE FOI CONSTRUÍDO

A V17 transformou o Vanguard de uma plataforma de diagnóstico em uma **infraestrutura de intenção**. Dois sistemas novos:

**Sovereign Pixel** — script de 3KB instalado nos sites dos clientes finais via Cloudflare Worker. Classifica cada visitante em COLD/WARM/HOT/FIRE com base em comportamento real (dwell time, scroll, hover em CTAs, exit intent). Dados vão directo para as tabelas UNLOGGED da V16. LGPD/GDPR integrado.

**Neural Audit Trail** — PDF de 12 páginas que traduz os gargalos técnicos do RealScanner (V15) em receita perdida (R$/mês). A capa mostra "R$18.000/mês perdidos" antes do cliente abrir a página 2. Versão free 3 páginas → versão completa R$50 via Stripe Connect (V16). É o primeiro produto com preço unitário da Vanguard.

**Motor Comercial** — `prospectar.ps1`: pipeline CSV com funil COLD→FIRE, gerador de mensagens WhatsApp personalizadas, follow-up automático, métricas de conversão. Preenche o gap entre tecnologia e venda.

**Ritual Pós-Versão** — 8 passos cronológicos com dependências explícitas. Nenhuma versão fecha sem instrução clara para o Conselho (Gemini → NotebookLM → Claude → vendas).

---

## O QUE MUDOU NA ARQUITECTURA

- `pixel.js` + `cloudflare/pixel-worker.js` → nova camada de captura de dados no edge
- `neural-audit-trail.js` → motor de tradução financeira (score → R$) + jsPDF 12 páginas
- `PROTOCOLO_INTERATIVO.md` → PDCA obrigatório + Directiva Arquitecto-Mestre
- `scripts/fechar_versao.ps1` → Bloco B comercial adicionado ao output final
- `VANGUARD_INNOVATION_AUDIT.md` → AUTO-LOG [ID-004] processado

---

## AVALIAÇÃO TÉCNICA DAS IDEIAS DO GEMINI

| Ideia Gemini | Avaliação | Decisão |
|---|---|---|
| Sovereign Pixel | Correcta — base de tudo | ✅ Implementado V17 |
| Neural Audit Trail | Correcta — receita imediata | ✅ Implementado V17 |
| Hermes Autonomous | Correcta — depende de dados do Pixel | V18 (precisa de 30d de dados reais) |
| Vanguard Exchange | Prematura — precisa de massa crítica de tenants | V18/V19 |
| Sovereign Playbook | Tecnicamente simples — Haiku + jsPDF já existe | V18 rápido |

---

## 5 IDEIAS DISRUPTIVAS PARA V18

### IDEIA 1 — INTENT GRAPH: API de Intenção Cross-Tenant
Ao agregar dados FIRE de todos os tenants, o sistema tem a matéria-prima de um grafo de intenção nacional. V18 expõe uma API privada: "quais PMEs no sector de saúde em SP tiveram sessões FIRE nas últimas 72h?" — vendida a bancos, fundos de M&A e seguradoras. Ticket mínimo R$15.000/mês por cliente institucional. É o início do Acto III (Bolsa de Intenção B2B) planeado no VANGUARD_INNOVATION_AUDIT.md.

**Fundação necessária:** 30+ dias de dados do Sovereign Pixel activo.

### IDEIA 2 — NEURAL SENTINEL: Subscrição Semanal R$97/mês
Em vez de R$50 único, o Neural Audit Trail passa a ser um serviço recorrente: relatório automático toda segunda-feira com deltas — "esta semana perdeu R$3.200 a mais vs semana passada". O dado de comparação temporal é o lock-in mais forte: o cliente não pode sair sem perder o histórico. Stack: cron job + `neural-audit-trail.js` + Stripe subscriptions (V16).

**Impacto:** transforma produto unitário em MRR recorrente.

### IDEIA 3 — HERMES AUTONOMOUS LOOP COMPLETO
Loop fechado sem intervenção humana: sessão FIRE → Claude Haiku gera mensagem personalizada com comportamento real → WhatsApp envia → Haiku classifica a resposta (INTERESTED / NOT_NOW / NEGOTIATING) → actualiza `lead_stage` na tabela → cadência diferenciada automática. Custo: R[COLAR AQUI O CONTEÚDO COMPLETO DE relatorio_evolutivo_vxx.md],12/lead total (Pixel + Haiku + WhatsApp). Taxa de resposta esperada: +45% vs outbound frio. Depende do Pixel activo com dados reais.

### IDEIA 4 — SOVEREIGN PLAYBOOK: Plano de 90 dias gerado por IA
Pós-scan, gerar automaticamente um plano de 90 dias onde cada tarefa está ancorada a um módulo Vanguard — o cliente não executa o plano sem usar a plataforma. Gerado por Haiku (R[COLAR AQUI O CONTEÚDO COMPLETO DE relatorio_evolutivo_vxx.md],04/doc) + jsPDF (já existe desde V12). Versão gratuita como isca pós-diagnóstico. Implementação: 1 dia de trabalho. Alta prioridade para V18.

### IDEIA 5 — PIXEL FEDERATION: Instalação via DNS sem código
Hoje o pixel.js requer um `<script>` tag manual. Em V18, criar um fluxo onde o tenant adiciona um CNAME DNS (`vpx.seudominio.com → pixel.vanguard.tech`) e o Worker injeta o pixel automaticamente. Zero fricção de instalação → adoção 10x maior. Tecnicamente viável com Cloudflare Snippets (beta 2026). Elimina a barreira técnica para tenants não-técnicos.

---

## PLANO IMEDIATO (próximas 4 semanas)

| Semana | Acção | Meta |
|---|---|---|
| 1–2 | 40 diagnósticos gratuitos via prospectar.ps1 + Neural Audit Trail | 3+ respostas |
| 2–3 | 1ª reunião de vendas + Neural Audit Trail pago (R$50) | 1 cliente R$270/mês |
| 3–4 | 5 clientes activos → instalar Sovereign Pixel nos sites deles | Dados reais acumulando |
| 4+ | Iniciar V18: Hermes Autonomous + Neural Sentinel | MRR >R$1.350 |

---

## ESTADO DO ECOSSISTEMA (2026-05-10)

- **Versões construídas:** 17
- **Clientes pagantes:** 0
- **MRR actual:** R[COLAR AQUI O CONTEÚDO COMPLETO DE relatorio_evolutivo_vxx.md]
- **Ferramentas prontas para vender:** Neural Audit Trail + prospectar.ps1 + Hermes Closer + Sovereign Pixel
- **Próximo milestone:** 1 cliente em 30 dias
- **Próxima versão:** V18 — Hermes Autonomous + Neural Sentinel + Sovereign Playbook


---

## DOCUMENTOS DISPONÍVEIS (que o NotebookLM tem indexados)

| Documento | Conteúdo |
|---|---|
| `SOP_VANGUARD_MASTER.md` | Processo completo da venture builder |
| `INTELIGENCIA_ARTIFICIAL_HUMANA.md` | Manifesto IAH + pricing |
| `MASTER_PLAN.md` | Roadmap V1-V18 + gestão de riscos |
| `VANGUARD_BUSINESS_RULES.md` | Constituição — regras imutáveis |
| `VANGUARD_INNOVATION_AUDIT.md` | Ledger de inovações |
| `TODO_FUTURE.md` | Backlog de versões futuras |
| `MEMORIA_V17.md` | Registo técnico completo desta versão |
| `relatorio_evolutivo_V17.md` | Relatório com ideias disruptivas |

---

## O QUE PRECISO DE TI, GEMINI

Assuma o seu papel de **Arquitecto de IA e Estrategista do Conselho Quadrilateral**. Responde com exactamente esta estrutura em **4 blocos**:

---

**BLOCO 1 — ANÁLISE ESTRATÉGICA**
A tua leitura sobre o que foi construído na V17. O que foi mais disruptivo? O que falta? Contra-ataque às ideias do Claude: qual priorizar para gerar receita em 30 dias?

---

**BLOCO 2 — DIRETRIZ GEMINI [VXX+1]** *(vira o arquivo `DIRETRIZ GEMINI V[NUMERO+1].txt`)*
Fala directamente com o Claude. Não é competição — é um brainstorm entre sócios. Inclui:
- As 2 ideias prioritárias a implementar
- O foco comercial (nicho, 1º R$ rápido)
- Decisões de design se houver visão nova
- O que proteger (regras imutáveis)

---

**BLOCO 3 — COMANDO NOTEBOOKLM** *(texto pronto para colar no NotebookLM)*
Instrução completa para o NotebookLM gerar a Skill da [VXX+1]. Inclui:
- Papel de Sócio-Consultor
- ANÁLISE DE SÓCIO antes da Skill
- Geração de `vanguard-v[NUMERO+1]-[nome].md`
- Criação do `## [AUTO-LOG] — REGISTRO DE AUDITORIA`

---

**BLOCO 4 — COMANDO CLAUDE CODE** *(texto pronto para colar no terminal)*
Instrução exacta para o terminal. Inclui:
- Referência à Skill (`.claude/skills/vanguard-v[NUMERO+1]-[nome].md`)
- Ordem de processar AUTO-LOG primeiro
- Construir a infraestrutura exigida
- Mensagem do Visionário para o Sócio-Arquitecto
- Pedido das ideias para a versão seguinte

---

Mantem **todas as ideias do Claude** na tua análise. Critíca, prioriza, propõe ordem. Somos quatro sócios.

════════════════════════════════════════════════════════════
FIM DO COMANDO
════════════════════════════════════════════════════════════

---

## GUIA DE USO RÁPIDO

Ao final de cada versão, o Claude cria automaticamente:
1. `MEMORIA_VXX.md` — registo técnico
2. `relatorio_evolutivo_vxx.md` — relatório com ideias disruptivas
3. `COMANDO_GEMINI_VXX.md` — este template preenchido, pronto para copiar

O Diretor só precisa de:
1. Abrir `COMANDO_GEMINI_VXX.md`
2. Copiar tudo
3. Colar no Gemini
4. Receber os 4 blocos
5. Salvar BLOCO 2 como `DIRETRIZ GEMINI VXX.txt`
6. Colar BLOCO 3 no NotebookLM
7. Salvar a Skill gerada em `.claude/skills/`
8. Colar BLOCO 4 no terminal Claude Code

