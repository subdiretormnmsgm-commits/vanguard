# Vanguard Tech — PWA V1: Design Spec

**Data:** 2026-05-09
**Versão:** 1.0
**Stack:** HTML/CSS/JS Vanilla · Supabase · PWA · Docker/Nginx · Python (validação)

---

## 1. Objectivo

Construir a vitrine instalável da Vanguard Tech (PWA) com um funil de captação B2B baseado num Quiz de Diagnóstico de 3 passos. Os dados captados (nicho, gargalo, nome, WhatsApp) são persistidos no Supabase e alimentarão o motor de invenção de Micro-SaaS na V2.

---

## 2. Arquitectura — Abordagem Modular por Responsabilidade

```
vanguard/
├── index.html
├── manifest.json
├── sw.js
├── assets/
│   ├── css/style.css
│   └── icons/              # icon-192.png, icon-512.png
├── js/
│   ├── main.js             # Bootstrap da app
│   ├── quiz.js             # Motor do quiz (estado + UI)
│   └── supabase.js         # Cliente Supabase isolado
├── infra/
│   ├── schema.sql
│   ├── validate_schema.py
│   └── Dockerfile
└── docs/
    └── superpowers/specs/
```

**Princípio:** cada ficheiro tem uma única responsabilidade. `quiz.js` nunca conhece o Supabase directamente — chama apenas a interface pública de `supabase.js`. Isso permite trocar o provider sem tocar na lógica do quiz.

---

## 3. Landing Page — Estrutura Visual

**Layout:** scroll único, mobile-first, sem frameworks CSS.

| # | Secção | Descrição |
|---|--------|-----------|
| 1 | Navbar | Logo "VANGUARD" em Cyber Cyan, glassmorphism, sticky |
| 2 | Hero | Headline principal, sub-headline, botão CTA que ancora no quiz |
| 3 | Prova Social | 3 cards glassmorphism com ícone + número + label |
| 4 | Quiz | Stepper 3 passos, barra de progresso, fade entre passos |
| 5 | Footer | Tagline, links legais placeholder, copyright |

**Headline:** `"O fim do aluguer de software. Transformamos o seu método único em Tecnologia Proprietária."`

**Cards de Prova Social:**
- 50+ · Ecossistemas Diagnosticados
- 3 · Micro-SaaS em Produção
- 100% · Tecnologia Proprietária

**Paleta:**
- Background: `#0A0A0A` (Obsidian Black)
- Acento primário: `#00F0FF` (Cyber Cyan)
- Profundidade: `#1A0B2E` (Deep Purple)

**Glassmorphism:** `background: rgba(255,255,255,0.05)` + `backdrop-filter: blur(10px)` + `border: 1px solid rgba(0,240,255,0.15)`

**Tipografia:** Inter (Google Fonts), pesos 400/600/700.

---

## 4. Quiz — Fluxo e Estado

**Estado interno (`quiz.js`):**
```js
{ step: 1|2|3, nicho: "", gargalo: "", nome: "", whatsapp: "" }
```

**Passo 1 — Nicho** (select):
`Saúde | Educação | Finanças | Consultoria | E-commerce | Imobiliário | Tecnologia | Outro`

**Passo 2 — Gargalo** (radio cards):
- Processos manuais que consomem tempo
- Falta de visibilidade sobre métricas do negócio
- Dificuldade em escalar a equipa
- Captação e retenção de clientes
- Dependência de ferramentas de terceiros

**Passo 3 — Contacto:**
- `input[text]` Nome
- `input[tel]` WhatsApp (máscara básica)
- Botão "Enviar Diagnóstico" (desactivado até ambos preenchidos)

**Após submit bem-sucedido:** ecrã de confirmação + link WhatsApp pré-preenchido para contacto imediato.

**Validação:** cada "Next" valida o campo actual antes de avançar. Sem submits parciais.

**Interface pública de `supabase.js`:**
```js
supabaseClient.saveLeadDiagnostico({ nicho, gargalo, nome, whatsapp, created_at })
// Retorna: Promise<{ success: boolean, error?: string }>
```

---

## 5. Schema SQL (`infra/schema.sql`)

Tabela: `leads_diagnostico`

| Coluna | Tipo | Restrições |
|--------|------|-----------|
| `id` | `uuid` | PK, `gen_random_uuid()` |
| `nome` | `text` | NOT NULL |
| `whatsapp` | `text` | NOT NULL |
| `nicho` | `text` | NOT NULL |
| `gargalo` | `text` | NOT NULL |
| `created_at` | `timestamptz` | DEFAULT `now()` |
| `origem` | `text` | DEFAULT `'landing_v1'` |

- RLS activado: `anon` pode `INSERT`, sem `SELECT` público
- Índice em `created_at` para queries analíticas futuras
- Coluna `origem` prepara clonagem white-label V4

---

## 6. Validação Python (`infra/validate_schema.py`)

Script standalone (sem conexão ao Supabase) que:
1. Lê e parseia `schema.sql`
2. Verifica presença de todas as colunas obrigatórias
3. Constrói objecto de teste e valida tipos
4. Imprime `✅ Schema válido` ou lista erros

---

## 7. PWA

**`manifest.json`:**
- `name`: "Vanguard Tech", `short_name`: "Vanguard"
- `theme_color`: `#00F0FF`, `background_color`: `#0A0A0A`
- `display`: `standalone`, `start_url`: `/`
- Ícones: 192×192 e 512×512

**`sw.js` — estratégia Cache First:**
- Cache na instalação: `index.html`, CSS, JS, ícones
- Fallback offline: página simples com identidade visual
- Constante `CACHE_VERSION = 'v1'` para invalidação controlada

---

## 8. Infra Docker (`infra/Dockerfile`)

```dockerfile
FROM nginx:alpine
COPY . /usr/share/nginx/html
EXPOSE 80
```

- Base `nginx:alpine` (~23MB), zero dependências npm
- `nginx.conf` com headers de segurança e compressão gzip
- Pronto para EasyPanel: apontar repositório → deploy

---

## 9. Critérios de Sucesso da V1

- [ ] Lighthouse PWA score ≥ 90
- [ ] Quiz completa o fluxo e grava no Supabase sem erros
- [ ] Instalável em Android/iOS via "Adicionar ao ecrã inicial"
- [ ] `validate_schema.py` retorna `✅ Schema válido`
- [ ] Deploy Docker funcional em ambiente local
