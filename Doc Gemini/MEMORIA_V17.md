# MEMORIA_V17 — Sovereign Intent Engine
> **Versão:** V17
> **Data:** 2026-05-10
> **Autor técnico:** Claude Code (Arquitecto-Mestre)
> **Protocolo:** Conselho Pentalateral — Fase 4 — Encerramento de Ciclo

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

### Pipeline CSV (`data/pipeline.csv`)
```
id | data_add | dominio | nome_contato | whatsapp | nicho | score |
receita_perdida | status | data_contato | data_resposta | notas
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
| MRR | R$0 |
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
