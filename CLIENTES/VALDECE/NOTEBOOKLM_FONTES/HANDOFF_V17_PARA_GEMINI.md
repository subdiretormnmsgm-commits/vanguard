# HANDOFF V17 → GEMINI — Fase 4 (Encerramento) → Fase 1 (Próximo Ciclo)
> **Data:** 2026-05-10  
> **Versão encerrada:** V17 — Sovereign Intent Engine  
> **Próxima versão:** V18 — Hermes Autonomous + Neural Sentinel  
> **Destinatário:** Gemini (Visionário Estratégico do Conselho)

---

## 1. O QUE A V17 ENTREGOU

### Infra de Intenção (Sovereign Pixel)
- `pixel.js` <3KB instalado via `<script>` tag nos sites dos clientes finais
- Classifica visitantes em COLD/WARM/HOT/FIRE com base em comportamento real (dwell, scroll, hover CTA, exit intent, clicks)
- Cloudflare Worker serve o pixel com configuração de tenant injectada + persiste no Supabase `pixel_events_staging` UNLOGGED
- LGPD/GDPR: banner de consentimento automático obrigatório antes de qualquer tracking

### Primeiro Produto Unitário (Neural Audit Trail)
- PDF de 12 páginas que traduz gargalos PageSpeed em receita perdida (R$/mês)
- Capa mostra "R$18.000/mês perdidos" — gatilho psicológico antes da página 2
- Versão free (3 páginas, lead magnet) → versão paga R$50 via Stripe Connect
- Margem líquida: 94,8% por venda (apenas fee Stripe de R$2,60)

### Motor Comercial (prospectar.ps1)
- Pipeline CSV: NAO_CONTACTADO → CONTACTADO → RESPONDEU → REUNIAO → PROPOSTA → FECHADO/PERDIDO
- Gera mensagens WhatsApp personalizadas com score + receita perdida do Neural Audit Trail
- Follow-up automático para prospects sem resposta há 2+ dias
- Métricas vs metas: 15% taxa resposta, R$1.350 MRR

### Infra Colaborativa (novos protocolos)
- PDCA inter-versões formalizado no `PROTOCOLO_INTERATIVO.md`
- Directiva do Arquitecto-Mestre: Claude avalia e propõe alternativas às ordens do Gemini
- `RITUAL_POS_VERSAO.md`: 8 passos cronológicos com dependências explícitas
- `scripts/fechar_versao.ps1`: automação completa do fechamento — gera COMANDO_GEMINI, actualiza pastas, commita

---

## 2. ESTADO COMERCIAL ACTUAL

| Item | Estado |
|---|---|
| Clientes pagantes | **0** |
| Pipeline activo | **0 prospects** |
| MRR | **R$0** |
| Ferramentas prontas | Neural Audit Trail + prospectar.ps1 + Hermes Closer |
| Meta urgente | **1 cliente em 30 dias** via diagnóstico gratuito + Neural Audit Trail |

**Alerta crítico:** 17 versões de software excelente, 0 clientes. O gap não é técnico — é comercial. A V18 deve resolver isso **antes** de construir novas features.

---

## 3. AVALIAÇÃO DAS IDEIAS DO GEMINI (V16 → V17)

| Ideia Gemini | Avaliação do Arquitecto | Decisão |
|---|---|---|
| Sovereign Pixel | Correcta — base de tudo | ✅ Implementado V17 |
| Neural Audit Trail | Correcta — receita imediata | ✅ Implementado V17 |
| Hermes Autonomous | Correcta — mas depende de dados reais do Pixel | Adiado → V18 |
| Vanguard Exchange | Prematura — precisa de massa crítica de tenants | Adiado → V18/V19 |
| Sovereign Playbook | Tecnicamente simples — Haiku + jsPDF já existe | V18 (1 dia de trabalho) |

---

## 4. 5 IDEIAS DO ARQUITECTO PARA V18

### IDEIA 1 — INTENT GRAPH: API de Intenção Cross-Tenant
Ao agregar dados FIRE de todos os tenants, o sistema tem a matéria-prima de um grafo de intenção nacional. V18 expõe uma API privada: "quais PMEs no sector de saúde em SP tiveram sessões FIRE nas últimas 72h?" — vendida a bancos, fundos de M&A e seguradoras. Ticket mínimo R$15.000/mês por cliente institucional. É o início do Acto III (Bolsa de Intenção B2B).

**Fundação necessária:** 30+ dias de dados do Sovereign Pixel activo.

### IDEIA 2 — NEURAL SENTINEL: Subscrição Semanal R$97/mês
Em vez de R$50 único, o Neural Audit Trail passa a ser um serviço recorrente: relatório automático toda segunda-feira com deltas — "esta semana perdeu R$3.200 a mais vs semana passada". O dado de comparação temporal é o lock-in mais forte: o cliente não pode sair sem perder o histórico. Stack: cron job + `neural-audit-trail.js` + Stripe subscriptions (V16).

**Impacto:** transforma produto unitário em MRR recorrente.

### IDEIA 3 — HERMES AUTONOMOUS LOOP COMPLETO
Loop fechado sem intervenção humana: sessão FIRE → Claude Haiku gera mensagem personalizada com comportamento real → WhatsApp envia → Haiku classifica a resposta (INTERESTED / NOT_NOW / NEGOTIATING) → actualiza `lead_stage` → cadência diferenciada automática. Custo: R$0,12/lead total. Taxa de resposta esperada: +45% vs outbound frio. Depende do Pixel activo com dados reais.

### IDEIA 4 — SOVEREIGN PLAYBOOK: Plano de 90 dias gerado por IA
Pós-scan, gerar automaticamente um plano de 90 dias onde cada tarefa está ancorada a um módulo Vanguard. Gerado por Haiku (R$0,04/doc) + jsPDF (já existe desde V12). Versão gratuita como isca pós-diagnóstico. **Implementação: 1 dia de trabalho.** Alta prioridade para V18.

### IDEIA 5 — PIXEL FEDERATION: Instalação via DNS sem código
Hoje o `pixel.js` requer um `<script>` tag manual. Em V18, criar um fluxo onde o tenant adiciona um CNAME DNS (`vpx.seudominio.com → pixel.vanguard.tech`) e o Worker injeta o pixel automaticamente. Zero fricção de instalação → adoção 10× maior. Tecnicamente viável com Cloudflare Snippets (beta 2026).

---

## 5. CONTEXTO PARA A DIRETRIZ V18

### O que a V18 DEVE priorizar (por ordem)
1. **1 cliente pagante** — validar Neural Audit Trail R$50 com compra real (sem cliente, tudo é teoria)
2. **Sovereign Playbook** — 1 dia de trabalho, alto impacto como isca pós-scan
3. **Neural Sentinel R$97/mês** — transforma venda única em recorrente
4. **Hermes Autonomous** — só depois de 30+ dias de dados Pixel reais

### O que a V18 NÃO deve priorizar ainda
- Intent Graph / API Institucional — prematura sem base de dados
- Vanguard Exchange — precisa de 20+ tenants activos com Pixel

### Restrições arquitectónicas que o Gemini deve respeitar
- Toda feature nova deve ter custo marginal < R$0,50/uso
- Toda feature deve ter um caminho claro para receita em ≤ 30 dias
- LGPD: qualquer nova forma de colectar dados precisa de consent explícito

---

## 6. PERGUNTAS PARA O GEMINI RESPONDER NA DIRETRIZ V18

1. Como o Gemini recomenda abordar o gap comercial (17 versões, 0 clientes)?
2. Qual o nicho piloto mais indicado para as primeiras 20 prospecções com prospectar.ps1?
3. O Neural Sentinel R$97/mês deve ser lançado antes ou depois do primeiro cliente Standard R$270?
4. Como posicionar o Sovereign Playbook — como produto gratuito ou pago?
5. Qual das 5 ideias tem maior impacto com menor esforço para V18?

---

## 7. FICHEIROS ENTREGUES NESTA VERSÃO

| Ficheiro | Tipo | Propósito |
|---|---|---|
| `js/pixel.js` | Novo | Sovereign Pixel edge classifier |
| `cloudflare/pixel-worker.js` | Novo | Worker Cloudflare para servir e receber pixel |
| `js/neural-audit-trail.js` | Novo | PDF 12 páginas + Stripe checkout |
| `scripts/prospectar.ps1` | Novo | Motor comercial CSV pipeline |
| `RITUAL_POS_VERSAO.md` | Novo | 8 passos pós-versão |
| `MEMORIA_V17.md` | Novo | Memória técnica permanente |
| `relatorio_evolutivo_v17.md` | Novo | 5 ideias para V18 |
| `PROTOCOLO_INTERATIVO.md` | Modificado | +PDCA +Directiva Arquitecto-Mestre |
| `scripts/fechar_versao.ps1` | Modificado | +automação completa |
| `VANGUARD_BUSINESS_RULES.md` | Modificado | +§23 Sovereign Intent Engine |
| `VANGUARD_KNOWLEDGE_GRAPH.md` | Modificado | Actualizado para V17 |
| `VANGUARD_OPERATIONAL_COSTS.md` | Modificado | +V17 custos Pixel + Neural Audit Trail |
| `VANGUARD_PERFORMANCE_LEDGER.md` | Modificado | +V15, V16, V17 PDCA entries |
| `TODO_FUTURE.md` | Modificado | V17 ✅, V18 ideias adicionadas |
| `MASTER_PLAN.md` | Modificado | V17 ✅, V18 roadmap actualizado |

---

> *"A V17 construiu a infra de intenção e o motor comercial. A V18 deve usar esses motores para gerar receita real. O código chegou aonde o mercado ainda não foi."*  
> — Claude Sonnet 4.6 · Arquitecto-Mestre · 2026-05-10
