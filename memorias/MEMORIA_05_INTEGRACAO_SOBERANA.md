# 🧠 MEMORIA_05 — Integração Soberana: Fábrica Autônoma Vanguard V5
> Gerado em: 2026-05-09 · Claude Sonnet 4.6 · Operação Singularidade Micro

---

## 1. Visão Geral da Arquitectura V5

A V5 (Soberano Digital) transforma a Vanguard numa **Fábrica Autônoma de Leads qualificados com IA**. O pipeline completo:

```
OpenStreetMap/Google Places
        ↓
  scraper_vanguard.py (V5)
        ↓
  Claude Haiku (AuditorIA)
  → analisa HTML do site
  → gera ai_hook personalizado
        ↓
  Supabase leads_diagnostico
  (campo ai_hook novo)
        ↓
  n8n Hermes (webhook trigger)
  → detecta lead novo com ai_hook
  → dispara WhatsApp Business API
        ↓
  Cliente recebe mensagem
  100% personalizada pela IA
```

---

## 2. Feature 01: Auditor IA (Claude Haiku)

### Implementação
- **Ficheiro:** `scraper_vanguard.py`
- **Classe:** `AuditorIA`
- **Modelo:** `claude-haiku-4-5-20251001`
- **Biblioteca:** `anthropic>=0.34.0`

### Como funciona
1. `DigitalAudit.auditar()` foi modificado para retornar `(score, descricao, html_raw)` — o HTML completo do site prospectado.
2. `AuditorIA.auditar()` recebe `(nome, nicho, html, score)` e envia para o Claude Haiku.
3. O prompt instrui o modelo a devolver **apenas JSON** com:
   - `gargalos_ia`: lista de problemas específicos identificados no site
   - `hook_personalizado`: mensagem WhatsApp 2-3 frases personalizada para aquele negócio
4. O `ai_hook` substitui o template genérico do `CopyGenerator` se disponível.

### Graceful degradation
- Se `ANTHROPIC_API_KEY` não estiver definida, o scraper funciona normalmente com templates
- Se `anthropic` não estiver instalado, avisa o utilizador e usa fallback
- Erros de JSON/rede são capturados silenciosamente (fallback para template)

### SQL necessário
```sql
-- infra/schema_v5.sql
ALTER TABLE leads_diagnostico ADD COLUMN IF NOT EXISTS ai_hook TEXT DEFAULT '';
```

### Uso
```powershell
# Com Auditor IA activado (requer ANTHROPIC_API_KEY em .env)
python scraper_vanguard.py --nicho advocacia --cidade "São Paulo" --limite 10 --modo osm

# Sem Auditor IA (mais rápido, usa templates)
python scraper_vanguard.py --nicho advocacia --modo osm --sem-ia
```

---

## 3. Feature 02: Docker Compose Mestre

### Serviços orquestrados
| Serviço    | Imagem                | Porta | Restart | Perfil   |
|------------|----------------------|-------|---------|----------|
| frontend   | vanguard-frontend:v5 | 80    | always  | default  |
| scraper    | vanguard-scraper:v5  | —     | no      | scraper  |
| n8n        | n8nio/n8n:latest     | 5678  | always  | default  |
| postgres   | postgres:15-alpine   | 5432  | always  | default  |
| hermes     | vanguard-hermes:v5   | 8000  | always  | default  |

### Uso
```bash
# Levantar toda a stack (excl. scraper)
docker compose up -d

# Executar scraper on-demand
docker compose run --rm scraper --nicho advocacia --cidade "São Paulo" --modo osm

# Logs em tempo real
docker compose logs -f n8n hermes

# White-Label para agência cliente
BRAND_NAME="AgênciaPRO" BRAND_PRIMARY="#FF6B00" docker compose up -d frontend
```

### Dockerfile.scraper
- `python:3.11-slim` base
- Instala dependências via `requirements.txt`
- `ENTRYPOINT ["python", "scraper_vanguard.py"]`
- Volume `./outbound:/app/outbound` para relatórios Markdown

---

## 4. Feature 03: White-Label

### Mecanismo
O sistema White-Label funciona em **3 camadas**:

1. **CSS Variables** (`assets/css/style.css`)
   ```css
   :root {
     --c-primary:   #00F0FF;  /* Override via brand-config.js */
     --c-secondary: #1A0B2E;
     --c-accent:    #7B2FFF;
     --c-bg:        #0A0A0A;
   }
   ```

2. **Docker Entrypoint** (`infra/entrypoint.sh`)
   - Gera `/usr/share/nginx/html/brand-config.js` com as variáveis do ambiente Docker
   - O JS sobrescreve as CSS variables no `:root` no carregamento da página

3. **JavaScript dinâmico** (`index.html`)
   - Lê as variáveis CSS via `getComputedStyle`
   - Actualiza todos os elementos `.brand-name` e `.brand-tagline`

### Variáveis de ambiente disponíveis
```env
BRAND_NAME=VANGUARD
BRAND_TAGLINE=Forja de Ecossistemas Digitais
BRAND_PRIMARY=#00F0FF
BRAND_SECONDARY=#1A0B2E
BRAND_ACCENT=#7B2FFF
BRAND_BG=#0A0A0A
```

---

## 5. UI/UX Awwwards — Design Decisions

### Tipografia
- **Display:** Syne 800 — geométrica, comandante, memorável
- **Body:** Inter (obrigatório por CLAUDE.md)
- **Code/Mono:** JetBrains Mono — para o terminal e valores numéricos

### Efeitos implementados
- **Grain texture** via SVG filter no `body::before` — textura analógica no digital
- **Scan line** animada no hero — cyberpunk aesthetic
- **3D card tilt** via `mousemove` + CSS `perspective()` + `rotate3d`
- **Counter roll-up** via `IntersectionObserver` + `requestAnimationFrame`
- **Scroll-reveal fade-up** via `IntersectionObserver` com staggered delays
- **Shimmer button** via `linear-gradient` animado no `:hover::after`
- **Terminal typing** via `animation: typeReveal` com `steps()`
- **Glassmorphism** multi-nível: `glass-1` (0.025) → `glass-3` (0.09) + `backdrop-filter`

### Layout Hero (split)
```
┌────────────────┬──────────────────────┐
│  Content       │  Terminal Preview    │
│  ─────────     │  ┌────────────────┐  │
│  Badge         │  │ $ python ...   │  │
│  Headline      │  │ LEADS: 127     │  │
│  Subtitle      │  │ SCORE: 7.8/10  │  │
│  CTA buttons   │  │ HOOKS: 127     │  │
│  Social proof  │  │ ● Claude · On  │  │
│                │  └────────────────┘  │
└────────────────┴──────────────────────┘
```

---

## 6. Integração n8n ↔ Supabase ↔ ai_hook

O fluxo actualizado do n8n (Hermes):
1. **Trigger:** Supabase Webhook ou Poll — detecta novo registo em `leads_diagnostico`
2. **Filtro:** `WHERE ai_hook IS NOT NULL AND ai_hook <> ''`
3. **Branch:**
   - Se `ai_hook` disponível → usar `ai_hook` como corpo da mensagem
   - Senão → usar template genérico `wa_copy`
4. **Acção:** WhatsApp Business API — enviar mensagem para `whatsapp`

---

## 7. Ficheiros Criados/Modificados

| Ficheiro                              | Acção    | Descrição                              |
|---------------------------------------|----------|----------------------------------------|
| `scraper_vanguard.py`                 | Editado  | + AuditorIA classe + Claude Haiku      |
| `requirements.txt`                    | Editado  | + anthropic>=0.34.0                    |
| `docker-compose.yml`                  | Reescrito| Master V5 com 5 serviços               |
| `Dockerfile.scraper`                  | Criado   | Container Python para scraper          |
| `Dockerfile`                          | Editado  | + entrypoint.sh para White-Label       |
| `infra/entrypoint.sh`                 | Criado   | Injecta brand vars no brand-config.js  |
| `infra/schema_v5.sql`                 | Criado   | ADD COLUMN ai_hook + índice + view     |
| `assets/css/style.css`                | Reescrito| Awwwards UI + brand tokens             |
| `index.html`                          | Reescrito| Split hero + terminal + features       |
| `.env.example`                        | Editado  | + todas as novas vars V5               |
| `CLAUDE.md`                           | Editado  | CURRENT_VERSION: 5                     |
| `memorias/MEMORIA_05_*.md`            | Criado   | Este ficheiro                          |
| `relatorio_evolutivo_v5.md`           | Criado   | Relatório evolutivo + Visão LMM        |

---

*MEMORIA_05 — Vanguard Tech V5 · Operação Singularidade Micro · 2026-05-09*
