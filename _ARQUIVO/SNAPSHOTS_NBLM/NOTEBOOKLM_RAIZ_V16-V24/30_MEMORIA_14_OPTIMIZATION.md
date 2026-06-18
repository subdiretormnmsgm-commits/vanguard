# MEMÓRIA 14 — SOVEREIGN OPTIMIZATION & FEEDBACK LOOP
> **Versão:** V14  
> **Data:** 2026-05-10  
> **Foco:** PDCA + Hermes Hive Mind + Trojan Generator + Dynamic HUD + Correcções de Escalabilidade  
> **Commit:** (ver git log)

---

## O QUE FOI CONSTRUÍDO

### Feature 01 — Performance Ledger (`VANGUARD_PERFORMANCE_LEDGER.md`)
Documento PDCA que regista para cada versão V11–V14:
- **PLAN:** Hipótese estratégica
- **DO:** Features implementadas com links de ficheiros
- **CHECK:** Métricas estimadas vs reais
- **ACT:** Dívidas técnicas geradas, classificadas por prioridade

Mapa global de dívidas: 38 total, 19 pagas, **8 pagas na V14** — maior retorno de qualidade do projecto.

---

### Feature 02 — Hive Mind SQL (`infra/schema_v14_hive_mind.sql`)

**Tabelas criadas:**
```sql
hermes_templates          -- Templates com métricas de performance
  ├── response_rate       -- GENERATED ALWAYS AS (response_count/send_count*100)
  └── is_vanguard_recommended  -- TRUE quando supera média+10% com 50+ envios

hermes_outbound_log       -- Registo de cada envio (template_id, nicho, outcome)
agency_partners           -- Migração dos parceiros do localStorage para Supabase
```

**Função chave:**
```sql
fn_hive_mind_promote(p_nicho TEXT)
  → Para cada nicho: calcula avg_rate → reset recomendações → promove melhor (se rate > avg*1.10)
  → Retorna TABLE(nicho, promoted_id, response_rate, action)
  → Agendada via pg_cron: SELECT cron.schedule('hive-mind-weekly', '0 2 * * 0', 'SELECT fn_hive_mind_promote()')
```

**View:**
```sql
v_hive_mind_performance   -- Rankings por nicho com RANK() OVER (PARTITION BY nicho)
```

---

### Feature 03 — Hive Mind UI (`js/hive-mind.js`)

**Padrão:** `window.HiveMind = { init(supabaseClient) {...} }`

**Lógica de promoção client-side (espelho da função SQL):**
```javascript
// Threshold demo: 10+ envios (vs 50 em produção)
const nichTemplates = templates.filter(t => t.nicho === tmpl.nicho && t.send_count >= 10);
const avgRate = nichTemplates.reduce((s, t) => s + t.response_rate, 0) / nichTemplates.length;
const best = nichTemplates.sort((a, b) => b.response_rate - a.response_rate)[0];
if (best.response_rate >= avgRate * 1.10) best.is_vanguard_recommended = true;
```

**Componentes:**
- KPI grid: Total Envios · Respostas · Taxa Média · Templates Recomendados
- Tabela com rate bars animadas (largura = response_rate %)
- Botões +Envio / +Resposta → actualizam métricas em tempo real
- Badge "⭐ RECOMENDADO" nos templates promovidos
- Fallback para demo stats quando Supabase não tem dados

---

### Feature 04 — Trojan Generator V1 (`js/trojan-generator.js`)

**Padrão:** `window.TrojanGenerator = { init(), generatePNG(domain, score) }`

**Motor de geração:**
```javascript
buildCard(domain, score, bottlenecks)
  → Cria elemento DOM 700px de largura (posição fixed off-screen)
  → Layout: shimmer border + corner brackets + score 80px + tier badge + progress bar + 2 gargalos + CTA

generatePNG(domain, score)
  → html2canvas(card, { scale: 2.5, backgroundColor: '#080C14' })
  → Retorna dataUrl PNG
  → Remove o elemento DOM após captura
```

**Bottlenecks determinísticos:**
- Usa djb2 hash do domínio para selecção consistente (mesmo domínio = mesmos gargalos sempre)
- 6 bottlenecks disponíveis: https, speed, mobile, cta, automation, seo

**Funcionalidades do dashboard:**
- Input domínio + score → Gerar PNG
- Preview da imagem gerada
- Botão download PNG
- Botão WhatsApp com mensagem pré-preenchida
- Instruções: download → anexar no WhatsApp → enviar

**Limitação V1 (documentada):** Requer envio manual da imagem no WhatsApp. V2 (V15) deve integrar WhatsApp Business API para envio automático.

---

### Feature 05 — Dynamic HUD Alerts (`dashboard/dashboard.js`)

**Função:** `renderDynamicAlerts(leads)`

**Lógica de alertas contextuais:**
| Condição | Alerta | Cor |
|---------|--------|-----|
| `vips.length > 0` | "🔴 N leads VIP aguardam contacto imediato" | #FF8080 |
| `todayN > 5` | "⚡ Dia de alta actividade — N leads hoje" | #00FF88 |
| `avgScore < 50 && leads.length > 5` | "📊 Score médio baixo — oportunidade upsell" | #FFB800 |

Alertas injectados via `kpiSection.after(bar)` — sem modificar a estrutura HTML existente. Removidos e re-criados a cada `loadLeads()` para ficarem actualizados.

---

### Feature 06 — Correcções de Escalabilidade

| Fix | Código | Impacto |
|-----|--------|---------|
| `LIMIT 200` em `loadLeads()` | `dashboard.js:101` | Previne crash com 10k+ leads |
| `const LEADS_PAGE_SIZE = 200` | `dashboard.js:100` | Configurável numa linha |
| `try/catch` em todos os engine inits | `dashboard.js` | Falha de um módulo não derruba o dashboard |
| Schema SQL `agency_partners` | `schema_v14.sql` | Migração localStorage → Supabase |

---

## FICHEIROS CRIADOS / MODIFICADOS

| Ficheiro | Acção | Notas |
|---|---|---|
| `VANGUARD_PERFORMANCE_LEDGER.md` | CRIADO | PDCA V11-V14, mapa de dívidas global |
| `infra/schema_v14_hive_mind.sql` | CRIADO | 3 tabelas + fn_hive_mind_promote + view + seed |
| `js/hive-mind.js` | CRIADO | Hive Mind UI + log de performance |
| `js/trojan-generator.js` | CRIADO | PNG generator V1 via html2canvas |
| `dashboard/index.html` | MODIFICADO | +2 secções: Hive Mind + Trojan Generator |
| `dashboard/dashboard.js` | MODIFICADO | LIMIT 200 + try/catch + renderDynamicAlerts |
| `VANGUARD_KNOWLEDGE_GRAPH.md` | MODIFICADO | V14 + Fluxo Retroalimentação + Dynamic HUD Logic |

---

## ARQUITECTURA DO FEEDBACK LOOP

```
Acção → Log → Análise → Promoção → Uso → Mais dados

1. ACÇÃO: Utilizador envia mensagem Hermes via dashboard Outbound
2. LOG: Clica "+Envio" → send_count++ em hermes_templates
3. RESPOSTA: Lead responde → "+Resposta" → response_count++
4. ANÁLISE: response_rate (GENERATED) actualiza automaticamente
5. PROMOÇÃO: fn_hive_mind_promote() (pg_cron domingo 02:00)
          → Template com rate > avg+10% → is_vanguard_recommended = TRUE
6. USO: HiveMind UI mostra badge "⭐ RECOMENDADO" → utilizador adopta
7. ESCALA: Todos os tenants do mesmo nicho beneficiam da aprendizagem
```

---

## LIÇÕES APRENDIDAS

1. **PDCA como bússola:** O Performance Ledger revelou que a Vanguard acumulou 38 dívidas técnicas em 14 versões, com apenas 50% pagas. Sem este registo, o ritmo de acumulação seria invisível até à primeira crise de produção.

2. **html2canvas off-screen:** O elemento pode ser criado com `position: fixed; left: -9999px` e não perturba o layout. A captura é síncrona após `await html2canvas()` — o elemento deve ser removido no `finally` para evitar leaks.

3. **Hive Mind client-side vs SQL:** A lógica de promoção existe em dois lugares (JS para demo imediata, SQL para produção). O threshold é diferente (10 vs 50 envios) — documentado explicitamente para não criar confusão.

4. **Error boundaries em módulos window.*:** O padrão `try { window.Module?.init(); } catch(e) { console.warn(); }` é crítico em dashboards com múltiplos módulos — uma excepção não tratada num módulo derrubava toda a IIFE do dashboard.js.

5. **Dynamic Alerts sem modificar HTML:** `kpiSection.after(bar)` injected após cada loadLeads() é mais limpo do que ter o elemento pré-existente com `hidden`. Evita estado inconsistente.

---

## PRÓXIMOS PASSOS SUGERIDOS (V15)
Ver `relatorio_evolutivo_v14.md` — secção "Visão LMM do Claude" com 4 ideias disruptivas:
1. WhatsApp Business API real para Trojan automático (sem envio manual)
2. Scanner HTTP real (substituir scanner determinístico por auditoria real)
3. Supabase Realtime para dashboard auto-actualizado (sem reload)
4. Vanguard AI Agent completo (n8n + Claude Opus orchestrator)
