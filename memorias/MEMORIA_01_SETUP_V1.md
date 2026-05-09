# MEMORIA_01_SETUP_V1 — Construção da Vanguard Tech PWA V1

**Data:** 2026-05-09
**Versão do Projecto:** 1
**Repositório:** https://github.com/subdiretormnmsgm-commits/vanguard.git

---

## 1. O que foi construído

A V1 da Vanguard Tech é uma **Landing Page PWA Cyber-Premium** com um funil de captação B2B baseado num Quiz de Diagnóstico de 3 passos. Toda a stack é JS Vanilla puro — sem frameworks, sem npm, zero dependências de runtime.

---

## 2. Arquitectura de Ficheiros

```
vanguard/
├── index.html                  # Shell da SPA — toda a estrutura HTML
├── manifest.json               # PWA: nome, cores, ícones, display standalone
├── sw.js                       # Service Worker Cache-First com offline fallback
├── Dockerfile                  # nginx:alpine para EasyPanel (raiz do repo)
├── assets/
│   ├── css/style.css           # Design system completo (tokens + componentes)
│   └── icons/
│       ├── icon-192.png        # Ícone PWA "any" 192×192 (RGBA)
│       ├── icon-512.png        # Ícone PWA "any" 512×512 (RGBA)
│       ├── icon-192-maskable.png  # Ícone maskable 192×192 (RGB, safe-zone 10%)
│       └── icon-512-maskable.png  # Ícone maskable 512×512 (RGB, safe-zone 10%)
├── js/
│   ├── supabase-lib.js         # Supabase JS v2 self-hosted (197KB, cacheável)
│   ├── supabase.js             # Cliente Supabase isolado — só expõe saveLeadDiagnostico()
│   ├── quiz.js                 # Motor do quiz: estado, UI, validação, submit
│   └── main.js                 # Bootstrap: regista SW + chama Quiz.init()
├── infra/
│   ├── schema.sql              # DDL Supabase com RLS
│   ├── validate_schema.py      # Validador Python offline do schema
│   ├── generate_icons.py       # Gerador de ícones PNG via Pillow
│   ├── nginx.conf              # nginx com headers de segurança + gzip
│   └── Dockerfile              # Dockerfile alternativo (referência)
└── memorias/
    └── MEMORIA_01_SETUP_V1.md  # Este ficheiro
```

---

## 3. Como foi construído o PWA

### 3.1 Design System (assets/css/style.css)
- Paleta Cyber-Premium definida como CSS custom properties em `:root`
- `--color-bg: #0A0A0A` (Obsidian Black)
- `--color-cyan: #00F0FF` (Cyber Cyan)
- `--color-purple: #1A0B2E` (Deep Purple)
- Glassmorphism: `rgba(255,255,255,0.05)` + `backdrop-filter: blur(10px)` + border cyan 15%
- Animação de grelha no Hero via `@keyframes gridMove` + CSS grid lines em `::before`
- Headline com gradiente via `-webkit-background-clip: text`
- Mobile-first com breakpoint único em `640px`

### 3.2 Quiz de Diagnóstico (js/quiz.js)
- Padrão IIFE — expõe apenas `Quiz.init()` ao escopo global
- Estado interno: `{ step, nicho, gargalo, nome, whatsapp }`
- Validação por passo antes de avançar (não há submit parcial)
- Validação de WhatsApp com regex: `/^\+?[1-9]\d{7,14}$/`
- Após submit bem-sucedido: gera link `wa.me/NUMERO?text=...` com dados do lead
- Erro inline via `#quiz-error` (sem `alert()`)

### 3.3 Service Worker (sw.js)
- Estratégia **Cache First**: serve cache → rede → fallback `/index.html` (só para navegação)
- `skipWaiting()` e `clients.claim()` encadeados dentro de `waitUntil` (padrão correcto)
- Supabase JS self-hosted incluído no ASSETS — garante funcionamento offline
- `CACHE_VERSION = 'v1'` — bump manual para invalidar cache em updates

### 3.4 PWA Manifest (manifest.json)
- 4 entradas de ícones: `any` e `maskable` separados para 192 e 512px
- Ícones maskable em RGB (sem alpha) com 10% de safe-zone — correcto para Android adaptive icons
- `scope: "/"`, `lang: "pt"`, `display: "standalone"`

---

## 4. Como foi estruturado o Supabase

### 4.1 Tabela: leads_diagnostico
```sql
id          uuid        PRIMARY KEY DEFAULT gen_random_uuid()
nome        text        NOT NULL
whatsapp    text        NOT NULL
nicho       text        NOT NULL
gargalo     text        NOT NULL
created_at  timestamptz NOT NULL DEFAULT now()
origem      text        NOT NULL DEFAULT 'landing_v1'
```

### 4.2 Segurança (RLS)
- Row Level Security activado
- Política `anon_insert_only`: role `anon` só pode fazer `INSERT`
- Nenhum `SELECT`, `UPDATE` ou `DELETE` público
- A coluna `origem` permite identificar a fonte do lead (preparada para white-label V4)

### 4.3 Isolamento do cliente (js/supabase.js)
- IIFE que expõe apenas `supabaseClient.saveLeadDiagnostico({ nicho, gargalo, nome, whatsapp })`
- O `quiz.js` nunca importa a biblioteca Supabase directamente
- Trocar de provider (Firebase, API própria) = editar apenas este ficheiro

---

## 5. Infra Docker/Nginx

### 5.1 Dockerfile (raiz)
```dockerfile
FROM nginx:alpine          # ~23MB base
COPY . /usr/share/nginx/html
COPY infra/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

### 5.2 nginx.conf — decisões importantes
- `sw.js` tem bloco `location = /sw.js` com `no-cache` — critical para PWA updates
- Assets estáticos: `Cache-Control: public, immutable` + 30 dias
- CSP sem cdn.jsdelivr.net (Supabase JS é self-hosted)
- `Permissions-Policy: camera=(), microphone=(), geolocation=()`
- `.dockerignore` exclui `.git/`, `infra/`, `*.md` — imagem não expõe ficheiros sensíveis

---

## 6. Lições Aprendidas sobre a Arquitectura

1. **IIFE duplo é o padrão correcto para JS Vanilla modular** — sem bundler, sem módulos ES, mas com isolamento real de escopo.

2. **Self-host sempre dependências críticas** — o Supabase JS CDN não pode ser cacheado pelo SW. Self-hosting resolve o offline e elimina dependência de terceiros.

3. **Ícones maskable exigem RGB + safe-zone** — ícones RGBA sem padding são cortados pelo Android. Este erro é comum e foi corrigido na revisão de código.

4. **EasyPanel e Dockerfile em subdirectório** — o EasyPanel não aceita caminhos relativos como `infra/Dockerfile` nem `.` no campo Caminho de Build. A solução foi colocar o Dockerfile na raiz do repositório.

5. **RLS é suficiente para a anon key ser pública** — a chave `anon` do Supabase é intencionalmente pública em aplicações frontend. A segurança real está nas políticas RLS que limitam o que essa chave pode fazer.

6. **O campo `origem` no schema é estratégico** — com valor default `'landing_v1'`, prepara a base de dados para receber leads de múltiplas origens (clones white-label V4) sem alterar o schema.

---

## 7. Credenciais Pendentes (configurar antes do deploy final)

| Ficheiro | Placeholder | Acção |
|---|---|---|
| `js/supabase.js` | `YOUR_SUPABASE_URL` | URL do projecto Supabase |
| `js/supabase.js` | `YOUR_SUPABASE_ANON_KEY` | Chave anon pública |
| `js/quiz.js` | `YOUR_WHATSAPP_NUMBER` | Número sem + (ex: 351912345678) |

---

## 8. Próximos Passos (V2)

Ver `relatorio_evolutivo_v1.md` — Visão LMM com Feature Preditiva e Motor de Pontuação de Nicho em Tempo Real via Edge Functions + Anthropic API.

**Levar o `relatorio_evolutivo_v1.md` ao Gemini para gerar a DIRETRIZ da V2.**
