# MEMÓRIA 15 — SOVEREIGN INVASION
> **Versão:** V15  
> **Data:** 2026-05-10  
> **Foco:** Real Scanner · War Room Realtime · Burn Rate Shield · Escudo WABA · Trojan Pipeline  
> **Commit:** (ver git log)

---

## O QUE FOI CONSTRUÍDO

### Feature 01 — Real Scanner (`js/real-scanner.js`)

**Motor de auditoria HTTP real** que substitui o scorer determinístico (djb2) por dados factuais.

**Stack técnica:**
- **Google PageSpeed Insights API v5** (quando API Key configurada): retorna Performance, SEO, Accessibility, Best Practices, HTTPS, Mobile, FCP, LCP, TTI
- **DNS-over-HTTPS Cloudflare** (`cloudflare-dns.com/dns-query`): verifica existência do domínio sem CORS
- **Fallback determinístico aprimorado**: seeded com 6 dimensões ponderadas quando API indisponível

**Dynamic Rate Limiting:**
```javascript
const CFG = {
  maxConcurrent: 2,       // máx simultâneas
  requestDelay: 2500,     // ms entre pedidos (protege Hostinger)
  rateLimitPerHour: 80,   // max 80 scans/hora
  cacheMinutes: 60,       // resultado cacheado 60min
};
```

**Score composto (alinhado §17.1 Business Rules):**
```
perf × 0.25 + seo × 0.20 + https × 0.15 + mobile × 0.15 + access × 0.10 + best × 0.10 + speed × 0.05
```

**Resultado normalizado:** `{ score: 0.0–10.0, bottlenecks: [], metrics: {fcp, lcp, tti}, isReal: bool, source: str }`

---

### Feature 02 — War Room Realtime (`dashboard/dashboard.js`)

**Supabase Realtime** activado via `supabase.channel().on('postgres_changes', ...)`.

```javascript
_realtimeChannel = client
  .channel('war-room-leads')
  .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'leads_diagnostico' }, (payload) => {
    const lead = { ...payload.new, scoring: score(...) };
    allLeads = [lead, ...allLeads].slice(0, LEADS_PAGE_SIZE);
    renderKpis(allLeads); renderHeatmap(allLeads); renderTable(allLeads);
    flashWarRoomAlert(lead);  // Flash toast de canto
  })
  .subscribe((status) => updateWarRoomStatus(status));
```

**Flash Toast:** `position:fixed; bottom:2rem; right:2rem` — animação 4s, cor por tier (VIP=vermelho, Quente=âmbar, Frio=cyan).

**Indicador de status:** dot pulsante + texto no header do cockpit (WAR ROOM · ONLINE / ERRO / OFFLINE).

**Pré-requisito Supabase:** Activar Realtime na tabela `leads_diagnostico` em Table Editor → Replication.

---

### Feature 03 — Burn Rate Shield (`infra/burn_rate_shield.py`)

**Guardião de orçamento de IA** como middleware FastAPI com 3 níveis de degradação.

```python
# Configuração via env vars:
DAILY_AI_BUDGET_EUR    = 8.00   # tecto diário total
MAX_CPL_EUR            = 0.30   # custo máx por lead
ALERT_THRESHOLD_PCT    = 0.75   # alerta a 75%

# Degradação automática por nível de orçamento:
# < 65%  → modelo preferido (Opus/Sonnet)
# 65-85% → downgrade Opus → Sonnet
# 85-99% → downgrade tudo → Haiku
# 100%   → Claude OFF → templates estáticos
```

**Endpoint:** `GET /admin/burn-rate` → JSON com total_eur, pct_used, avg_cpl, status.

**Templates estáticos de fallback:** 2 templates hard-coded por nicho para quando Claude é desactivado.

---

### Feature 04 — n8n Trojan Pipeline (`infra/n8n_workflow_v15_trojan_pipeline.json`)

**Workflow importável** para n8n com 11 nós:

```
Webhook (Supabase INSERT)
  → Extrair dados do lead
  → IF score ≤ 7 (score alto = já maduro, não precisa Trojan)
    → Real Scanner (PageSpeed API)
    → Calcular score real
    → Screenshot HUD Preview
    → Burn Rate Shield Check
      → IF orçamento OK → Spintax Message (Estado 1 = só texto)
                          → WhatsApp sendText (Evolution API)
                          → Registar em hermes_outbound_log
      → ELSE → Fallback template estático
  → Responder Webhook 200
```

**Escudo WABA integrado:** O nó "Gerar Mensagem Spintax" produz **só texto** no Estado 1. Trojan PNG/GIF só enviado no Estado 2 (via outro workflow activado por reply do lead).

---

### Feature 05 — §21 Business Rules (Protocolo de Invasão Soberana)

**3 leis constitucionais adicionadas:**

| Lei | Regra |
|-----|-------|
| **Escudo WABA** | Cold contact = texto + Spintax ONLY; Trojan desbloqueado após 1º reply |
| **Doutrina da Exposição** | Name & Shame agregado e anonimizado em LinkedIn/X (sem identificar empresas) |
| **Tecto de Combustão** | €0.30/lead, €8/dia; 3 níveis de degradação automática |

---

## FICHEIROS CRIADOS / MODIFICADOS

| Ficheiro | Acção | Notas |
|----------|-------|-------|
| `js/real-scanner.js` | CRIADO | PageSpeed API v5 + DNS-over-HTTPS + fallback determinístico + rate limiting |
| `infra/burn_rate_shield.py` | CRIADO | FastAPI middleware + tracker diário + 3 níveis degradação |
| `infra/n8n_workflow_v15_trojan_pipeline.json` | CRIADO | 11 nós importáveis, Spintax Estado 1, Burn Rate integrado |
| `dashboard/dashboard.js` | MODIFICADO | startWarRoom() + flashWarRoomAlert() + updateWarRoomStatus() |
| `dashboard/index.html` | MODIFICADO | Indicador War Room no header + script real-scanner.js |
| `VANGUARD_BUSINESS_RULES.md` | MODIFICADO | §21 Protocolo Invasão Soberana (3 leis) |

---

## LIÇÕES APRENDIDAS

1. **CORS é o limite do scanner frontend:** A PageSpeed Insights API é a única API pública de auditoria real sem CORS. DNS-over-HTTPS (Cloudflare) é o segundo pilar. Para auditorias mais profundas (HTML completo, formulários, redes sociais), é necessário um proxy server-side.

2. **Supabase Realtime não se liga imediatamente:** O canal `subscribe()` tem latência de 1-3 segundos após `showCockpit()`. Isto é normal — o `loadLeads()` inicial cobre o gap.

3. **Spintax no Estado 1 não é cosmético:** É protecção de activo. Uma conta WABA banida custa dias de operação parada. O Escudo WABA é a regra de maior ROI da V15.

4. **Burn Rate Shield em middleware é elegante:** O modelo de degradação automática (Opus→Sonnet→Haiku→estático) é transparente para o código de negócio — não requer `if/else` espalhados. Só o middleware toma a decisão.

5. **n8n como orquestrador visual:** O workflow JSON permite ao Director ver e modificar o pipeline sem código. Isto é essencial para a fase de escala quando o Director precisar de ajustar thresholds sem engenheiro.

---

## CHECKLIST DE ACTIVAÇÃO

- [ ] Executar `infra/schema_v15_agent_jobs.sql` no Supabase SQL Editor
- [ ] Activar extensão `pg_cron` no Supabase (Settings → Extensions)
- [ ] Activar Realtime na tabela `leads_diagnostico` (Table Editor → Replication)
- [ ] Configurar Supabase Webhook: INSERT em `leads_diagnostico` → POST `/n8n/webhook/vanguard-new-lead`
- [ ] Importar `infra/n8n_workflow_v15_trojan_pipeline.json` no n8n
- [ ] Definir variáveis de ambiente: `PAGESPEED_API_KEY`, `DAILY_AI_BUDGET_EUR=8`, `MAX_COST_PER_LEAD_EUR=0.30`
- [ ] Instalar Evolution API na VPS Hostinger
- [ ] No dashboard → Real Scanner → inserir Google PageSpeed API Key (gratuita: 25k queries/dia)

---

## PRÓXIMOS PASSOS SUGERIDOS (V16)

Ver `relatorio_evolutivo_v15.md` — secção "Visão LMM do Claude" com 4 ideias disruptivas para V16.
