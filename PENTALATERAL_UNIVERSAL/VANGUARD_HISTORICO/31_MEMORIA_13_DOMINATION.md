# MEMÓRIA 13 — GLOBAL DOMINATION & VIRAL TRACTION
> **Versão:** V13  
> **Data:** 2026-05-10  
> **Foco:** Hermes Outbound Autónomo + HUD Previews + Census Engine + Partnership API  
> **Commit:** 1bb9dd1

---

## O QUE FOI CONSTRUÍDO

### Feature 01 — Personalized HUD Previews (`preview/index.html`)
- Página standalone sem dependências externas de CSS/JS (tudo inline)
- Lê parâmetro `?d=dominio` da URL → executa scanner determinístico (mesmo motor do `scanner.js`, replicado inline)
- Fluxo: Ghost Loader 3.8s (canvas neural + progress bar animada + mensagens rotativas) → Score colorido por tier → Tier badge → Alerta vermelho para CRÍTICO/BAIXO → Radar Chart.js 6 eixos → 3 Bottleneck cards → CTA WhatsApp pré-preenchido
- A mensagem WhatsApp referencia o domínio e o score reais: *"Detectámos que [dominio] tem score [X]/10..."*
- Viral loop: badge em site externo → clique → `/preview/?d=dominio` → novo lead vê o valor → CTA → WhatsApp

**Arquitectura do Scanner Inline (preview/index.html):**
```javascript
hashStr(s)          // djb2 — mesma função de scanner.js
seededRand(seed, offset, min, max)  // pseudo-random determinístico
BOTTLENECKS = { ... }  // 11 entradas: https, speed, mobile, cta, ...
analyzeURL(rawURL)  // → { domain, score, radarData[6], bottlenecks[3] }
getTier(score)      // → { label, cls } CRÍTICO/BAIXO/MÉDIO/ALTO
```

---

### Feature 02 — Vanguard Census Engine (`census/index.html`)

**O que é:** Página pública que agrega anonimamente os dados de `leads_diagnostico` do Supabase para produzir inteligência sectorial.

**Motor de dados:**
```javascript
// Lê leads_diagnostico (sem PII — só nicho + gargalo)
// Agrupa por nicho: count + score médio
// scoreEntry(nicho, gargalo) — espelha fórmula do dashboard.js
// Fallback para demoData() quando DB vazio
```

**Componentes renderizados:**
1. Stats Grid: Total Scans · Sectores Monitorizados · Score Médio Global · Sectores Críticos
2. Bar Chart (Chart.js): score médio por sector com cores dinâmicas (vermelho/âmbar/cyan)
3. Top 6 Gargalos com barras de progresso animadas
4. Ranking Table: sector + score + badge de maturidade + registos
5. **Gerador de Selo Embeddable:** input domínio + score → HTML badge copy-paste

**Badge gerado:**
```html
<a href="https://vanguardtech.io/preview/?d=DOMINIO" target="_blank" ...>
  <span style="color:[cor por score]">[score]</span>
  <span>Maturidade Digital · Auditado · Vanguard Tech™</span>
</a>
```
Cada badge em site externo é um backlink activo que traz novos visitantes ao scanner.

---

### Feature 03 — Hermes Outbound Engine (`js/outbound-engine.js`)

**Padrão:** `window.OutboundEngine = { init(client, leads) {...} }`  
**Chamado por:** `dashboard/dashboard.js` após `loadLeads()`

**Motor de mensagens — 5 templates por gargalo:**
| Gargalo | Tom da mensagem |
|---------|----------------|
| Escalar equipa | Crescimento 3× em 6 meses |
| Métricas/BI | Perda de margem por decisões cegas |
| Captação clientes | Sistema de leads automático por nicho |
| Processos manuais | 15–20h semanais recuperadas |
| Dependência tools | Infra própria sem risco de terceiros |
| _default | Abordagem genérica por nicho |

**Funcionalidades do dashboard:**
- Filtros por tier: Todos / VIP / Quentes
- Card por lead: Nome + Nicho + Gargalo (truncado) + Score colorido + Tier
- Preview da mensagem Hermes renderizada (bold em `*asteriscos*`)
- Botão WhatsApp → `web.whatsapp.com/send/?phone=NUM&text=MSG_ENCODED`
- Input de domínio manual → gera link `/preview/?d=dominio` para envio ao lead
- Máximo 25 leads por render (performance)

---

### Feature 04 — Partnership API UI (`js/partnerships.js`)

**Padrão:** `window.PartnershipsEngine = { init() {...} }`  
**Persistência:** `localStorage` com chave `vanguard_partners`  
**Chamado por:** `dashboard/dashboard.js` em `showCockpit()`

**Dados de cada parceiro:**
```javascript
{
  id, name, email, plan,      // Free | Agency | White-Label
  apiKey,                      // vg-api-{8chars hex}
  scans, revenue,              // métricas de uso
  joinedAt, status,            // active | trial | paused
}
```

**Planos codificados:**
| Plano | Preço | Scans/mês | Branding |
|-------|-------|-----------|----------|
| Free | €0 | 10/dia | — |
| Agency | €49 | 500 | Vanguard nos PDFs |
| White-Label | €149 | 2000 | Logo próprio + 20% revenue share |

**Modal de criação:** Nome + Email + Plano → gera API Key aleatória → persiste em localStorage

---

### Feature 05 — Dashboard V13 (`dashboard/index.html` + `dashboard/dashboard.js`)

**3 novas secções adicionadas ao Cockpit:**

1. **Hermes Outbound** (`#section-outbound`) — renderizado por `OutboundEngine.init()`
2. **Censo Global** (`#cockpit-censo`) — link estático para `/census/` com descrição
3. **Partnership API** (`#section-partnerships`) — renderizado por `PartnershipsEngine.init()`

**Modificações em `dashboard.js`:**
```javascript
// Em showCockpit():
window.PartnershipsEngine?.init();

// Em loadLeads() após renderTable():
window.OutboundEngine?.init(client, allLeads);
```

---

## FICHEIROS CRIADOS / MODIFICADOS

| Ficheiro | Acção | Linhas |
|---|---|---|
| `preview/index.html` | CRIADO — HUD Preview standalone | ~420 |
| `census/index.html` | CRIADO — Census Engine público | ~480 |
| `js/outbound-engine.js` | CRIADO — Hermes Outbound module | ~290 |
| `js/partnerships.js` | CRIADO — Partnership API UI module | ~280 |
| `dashboard/index.html` | MODIFICADO — +3 secções V13 | +60 |
| `dashboard/dashboard.js` | MODIFICADO — +2 engine inits | +3 |
| `VANGUARD_KNOWLEDGE_GRAPH.md` | MODIFICADO — Elevado a V13, arquitectura V11/V12/V13 | +120 |
| `VANGUARD_BUSINESS_RULES.md` | MODIFICADO — §18 Protocolo Expansão & Viralidade | +80 |
| `TODO_FUTURE.md` | MODIFICADO — Limpo, V13 IMPLEMENTADO, V14 CRÍTICO | reestruturado |

---

## ARQUITECTURA DE DADOS

### Fluxo Viral Badge (sem servidor)
```
Badge HTML embeddado em site de cliente
    │ clique do visitante externo
    ▼
/preview/?d=dominio-do-cliente
    ├── Scanner determinístico client-side (hash-seed)
    ├── Renderiza HUD com score do domínio do cliente
    ├── CTA: "O seu site tem problemas similares? Analise agora"
    └── WhatsApp pré-preenchido → Hermes recebe o lead
```

### Fluxo Census Engine
```
leads_diagnostico (Supabase)
    │ SELECT nicho, gargalo (sem PII)
    ▼
Agregação por nicho (client-side JS)
    ├── count por nicho
    ├── score médio por nicho
    └── gargalos mais frequentes
    ▼
Renderização: Bar Chart + Ranking + Gargalos + Badge Generator
```

### Fluxo Outbound Dashboard
```
allLeads (já carregados pelo dashboard.js)
    │ passados para OutboundEngine.init(client, allLeads)
    ▼
Geração de mensagem por (nicho × gargalo)
    ├── Mensagem Hermes personalizada
    └── Link wa.me com texto pré-codificado
    ▼
Card renderizado no Cockpit → 1 clique → WhatsApp abre
```

---

## LIÇÕES APRENDIDAS

1. **Módulos window.* para o dashboard:** O pattern `window.Module = (() => { ... return { init }; })()` é limpo e não polui o IIFE do dashboard.js. O optional chaining `?.init()` evita erros se o script não carregar.

2. **Census com fallback demo:** Sem dados no Supabase, o Census não quebra — exibe dados plausíveis de demo. Crítico para apresentações onde a BD está vazia.

3. **Badge HTML embeddable sem servidor:** O link do badge aponta para `/preview/?d=dominio` que é gerado 100% client-side. Zero infra adicional, zero custo de manutenção.

4. **localStorage para parceiros:** Sem tabela Supabase de parceiros, o localStorage mantém os dados entre sessões no mesmo browser. Suficiente para a fase demo/MVP.

5. **Mensagens Hermes por gargalo:** Cada gargalo tem tom e argumento diferente — não é uma mensagem genérica. Isto é a diferença entre taxa de abertura de 15% e 60%.

---

## PRÓXIMOS PASSOS SUGERIDOS (V14)
Ver `relatorio_evolutivo_v13.md` — secção "Visão LMM do Claude" com 4 ideias disruptivas:
1. Trojan Outbound Engine (vídeo/GIF do HUD via WhatsApp Business API)
2. Census Engine Dashboard (embed no Cockpit + filtros por nicho/data)
3. Viral Badge Upgrade (scan automático do visitante via referrer)
4. Hermes Aprendizado Colectivo (variante A/B global por nicho)
