# Site Vanguard — Dupla Entrada + Vitrine Dinâmica de Nichos — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transformar a inteligência de mercado em canal de entrada do site sem descartar o DNA do quiz orgânico — uma Vitrine de nichos pontuados como fortes + um quiz por nicho derivado das dores mapeadas, tudo regenerado mensalmente sob gate de data.

**Architecture:** Um único módulo de transformação puro (`niche-public.js`) é consumido por três lados — o gerador Node (offline, sob gate), o frontend do browser (runtime) e os testes (`node --test`). O gerador lê os `*_MODEL.json` e escreve um artefato público curado e editorial-safe (`niches_public.json`); o frontend faz fetch desse artefato e renderiza a Vitrine + condiciona o quiz por `?nicho=<slug>`. A regeneração nunca é cron cego: é uma ação datada no `CALENDARIO_NICHE_INTELLIGENCE.md`, liberada por um gate de data.

**Tech Stack:** HTML/CSS/JS vanilla (zero build step, padrão existente do PWA) · ES Modules (browser `type="module"` + Node ESM) · `node --test` (runner nativo, zero dependências novas) · PowerShell (wrapper do gate, padrão de orquestração do repo) · Supabase JS (tabela `leads_diagnostico`, já em produção).

---

## Decisões diferidas do spec §9 — resolvidas

1. **Onde mora / como o regen se pluga:** site é vanilla estático servido de `ACERVO_VANGUARD/` (root → `/js/`, `/data/`). Regen é **data-driven sob gate**: script Node offline gera `ACERVO_VANGUARD/data/niches_public.json`; o browser faz fetch em runtime. **Zero build step preservado** — o cliente só baixa um JSON.
2. **Formato do quiz por nicho:** **runtime**, lido do mesmo `niches_public.json`. Cada nicho carrega um bloco `quiz` editorial-safe **derivado de `dores[]`** pelo gerador offline. O frontend renderiza dinamicamente; conforme `dores[]` enriquece no ciclo mensal, o quiz fica mais robusto.
3. **Instrumentação da métrica-mãe:** o lead grava `origem` (`'vitrine_nicho'` vs `'organico'`) + `nicho` (slug) em `leads_diagnostico`. O cruzamento lead→conversa real (E-4) acontece fora do site (Embaixador); o site garante o **dado de origem auditável**. Sem dashboard (YAGNI).

## File Structure

| Arquivo | Responsabilidade |
|---|---|
| `ACERVO_VANGUARD/js/lib/niche-public.js` (criar) | Módulo puro: seleção, editorial-guard, card, quiz, artefato, gate-de-data, roteamento. ESM. |
| `ACERVO_VANGUARD/js/lib/niche-public.test.mjs` (criar) | Testes `node --test` do módulo puro. |
| `ACERVO_VANGUARD/js/lib/package.json` (criar) | `{"type":"module"}` — escopa ESM só a `/lib/`, sem afetar os JS clássicos. |
| `scripts/regen-vitrine-site.mjs` (criar) | Gerador: lê `*_MODEL.json` do disco, escreve o artefato; flag `--gate`. |
| `scripts/gate_regen_vitrine.ps1` (criar) | Wrapper PS do gate (para o Músculo/session_start). |
| `ACERVO_VANGUARD/data/niches_public.json` (gerado) | Artefato público curado. Não editado à mão. |
| `ACERVO_VANGUARD/js/vitrine.js` (criar) | Frontend: fetch + render dos cards da Vitrine (hero = nº 1). |
| `ACERVO_VANGUARD/js/niche-quiz-bridge.js` (criar) | Frontend: lê `?nicho=`, expõe origem/slug ao quiz. |
| `ACERVO_VANGUARD/js/supabase.js` (modificar) | Aceitar `origem` no payload (hoje hardcoded `'landing_v18'`). |
| `ACERVO_VANGUARD/js/quiz.js` (modificar) | Incluir `origem` + `nicho` slug no payload de `submitLead`. |
| `ACERVO_VANGUARD/PWA/index.html` (modificar) | Seção Vitrine + tags `<script type="module">`. |
| `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/CALENDARIO_NICHE_INTELLIGENCE.md` (modificar) | Linha datada `REGEN_VITRINE_SITE` (autoridade do gate). |

**Restrições inegociáveis aplicadas em todo o plano:** editorial nunca menciona IA/automação/Claude/robô (guard testado, Task 2); chaves anon do Supabase **permanecem** hardcoded (não tocar); isolamento P-059 (nichos ≠ dados de cliente).

---

### Task 1: Módulo puro — seleção e ordenação de nichos públicos

**Files:**
- Create: `ACERVO_VANGUARD/js/lib/package.json`
- Create: `ACERVO_VANGUARD/js/lib/niche-public.js`
- Test: `ACERVO_VANGUARD/js/lib/niche-public.test.mjs`

- [ ] **Step 1: Criar o package.json de escopo ESM**

`ACERVO_VANGUARD/js/lib/package.json`:
```json
{ "type": "module" }
```

- [ ] **Step 2: Escrever o teste que falha**

`ACERVO_VANGUARD/js/lib/niche-public.test.mjs`:
```javascript
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { selectPublicNiches } from './niche-public.js';

test('selectPublicNiches mantém só MOVER_AGORA e ordena por fit_score desc', () => {
  const models = [
    { id: 'a', status: 'MONITORAR', fit_score: 5 },
    { id: 'b', status: 'MOVER_AGORA', fit_score: 4.2 },
    { id: 'c', status: 'MOVER_AGORA', fit_score: 5 },
    { id: 'd', status: 'ARQUIVAR', fit_score: 5 },
  ];
  const out = selectPublicNiches(models);
  assert.deepEqual(out.map(m => m.id), ['c', 'b']);
});

test('selectPublicNiches retorna [] para entrada vazia ou nula', () => {
  assert.deepEqual(selectPublicNiches([]), []);
  assert.deepEqual(selectPublicNiches(null), []);
});
```

- [ ] **Step 3: Rodar o teste e confirmar que falha**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: FAIL — `Cannot find module './niche-public.js'`.

- [ ] **Step 4: Implementação mínima**

`ACERVO_VANGUARD/js/lib/niche-public.js`:
```javascript
// Módulo puro de transformação Niche Model -> artefato público da Vitrine.
// Consumido por: gerador Node (scripts/regen-vitrine-site.mjs), frontend (browser
// type=module) e testes (node --test). Sem I/O, sem DOM — só dados.

export function selectPublicNiches(models) {
  if (!Array.isArray(models)) return [];
  return models
    .filter(m => m && m.status === 'MOVER_AGORA')
    .sort((a, b) => (b.fit_score || 0) - (a.fit_score || 0));
}
```

- [ ] **Step 5: Rodar o teste e confirmar que passa**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: PASS (2/2).

- [ ] **Step 6: Commit**

```bash
git add ACERVO_VANGUARD/js/lib/package.json ACERVO_VANGUARD/js/lib/niche-public.js ACERVO_VANGUARD/js/lib/niche-public.test.mjs
git commit -m "feat(vitrine): selectPublicNiches — filtra MOVER_AGORA e ordena por fit_score"
```

---

### Task 2: Editorial guard — nunca mencionar IA/automação

**Files:**
- Modify: `ACERVO_VANGUARD/js/lib/niche-public.js`
- Test: `ACERVO_VANGUARD/js/lib/niche-public.test.mjs`

- [ ] **Step 1: Escrever o teste que falha**

Adicionar a `niche-public.test.mjs`:
```javascript
import { assertEditorialSafe, EDITORIAL_BANNED } from './niche-public.js';

test('EDITORIAL_BANNED cobre os termos proibidos', () => {
  for (const t of ['ia', 'inteligência artificial', 'automação', 'claude', 'robô', 'algoritmo']) {
    assert.ok(EDITORIAL_BANNED.includes(t), `faltou: ${t}`);
  }
});

test('assertEditorialSafe lança ao encontrar termo proibido (case/acento-insensível)', () => {
  assert.throws(() => assertEditorialSafe('Nossa IA resolve isso'), /editorial/i);
  assert.throws(() => assertEditorialSafe('AutomaÇÃo total'), /editorial/i);
});

test('assertEditorialSafe passa texto limpo e o retorna', () => {
  assert.equal(assertEditorialSafe('Auditoria de classificação NCM'), 'Auditoria de classificação NCM');
});
```

- [ ] **Step 2: Rodar e confirmar falha**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: FAIL — `assertEditorialSafe is not a function`.

- [ ] **Step 3: Implementação mínima**

Adicionar a `niche-public.js`:
```javascript
export const EDITORIAL_BANNED = [
  'ia', 'inteligência artificial', 'inteligencia artificial',
  'automação', 'automacao', 'automatizado', 'automatizada',
  'claude', 'gpt', 'robô', 'robo', 'bot', 'algoritmo', 'machine learning',
];

function normalize(s) {
  return String(s).toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '');
}

export function assertEditorialSafe(text) {
  const norm = normalize(text);
  for (const banned of EDITORIAL_BANNED) {
    const b = normalize(banned);
    // fronteira de palavra para evitar falso-positivo (ex.: "guia" não casa "ia")
    const re = new RegExp('(^|[^a-z0-9])' + b.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '($|[^a-z0-9])');
    if (re.test(norm)) {
      throw new Error(`Violação editorial: termo proibido "${banned}" em "${text}"`);
    }
  }
  return text;
}
```

- [ ] **Step 4: Rodar e confirmar passa**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: PASS (todos).

- [ ] **Step 5: Commit**

```bash
git add ACERVO_VANGUARD/js/lib/niche-public.js ACERVO_VANGUARD/js/lib/niche-public.test.mjs
git commit -m "feat(vitrine): editorial guard — bloqueia IA/automação/Claude em texto público"
```

---

### Task 3: `toPublicCard` — mapear Niche Model para card público

**Files:**
- Modify: `ACERVO_VANGUARD/js/lib/niche-public.js`
- Test: `ACERVO_VANGUARD/js/lib/niche-public.test.mjs`

- [ ] **Step 1: Escrever o teste que falha**

Adicionar:
```javascript
import { toPublicCard } from './niche-public.js';

const MODEL_FIX = {
  id: 'compliance-aduaneiro-ncm',
  nome: 'Conformidade Aduaneira — Classificação NCM',
  setor: 'Comércio Exterior',
  status: 'MOVER_AGORA',
  fit_score: 5,
  dores: [
    'Erro de classificação NCM rejeita notas automaticamente na SEFAZ',
    'Multa R$20.000 por informação incorreta (LC 227/2026)',
    'Portfolio de importados sem auditoria sistemática há 12+ meses',
  ],
  // campos internos que NÃO podem vazar ao público:
  objecoes: [{ objecao: 'x', reversao: 'y' }],
  roi_vanguard: { ticket_estimado: 'R$15.000 a R$40.000', pricing: 'sigiloso' },
};

test('toPublicCard expõe só campos públicos e nunca os internos', () => {
  const c = toPublicCard(MODEL_FIX, 1);
  assert.equal(c.id, 'compliance-aduaneiro-ncm');
  assert.equal(c.rank, 1);
  assert.equal(c.fit_score, 5);
  assert.equal(typeof c.headline, 'string');
  assert.ok(c.headline.length > 0);
  assert.equal(c.objecoes, undefined);
  assert.equal(c.roi_vanguard, undefined);
});

test('toPublicCard passa o headline pelo editorial guard', () => {
  const dirty = { ...MODEL_FIX, dores: ['Nossa automação resolve a NCM'] };
  assert.throws(() => toPublicCard(dirty, 1), /editorial/i);
});
```

- [ ] **Step 2: Rodar e confirmar falha**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: FAIL — `toPublicCard is not a function`.

- [ ] **Step 3: Implementação mínima**

Adicionar:
```javascript
export function toPublicCard(model, rank) {
  const dores = Array.isArray(model.dores) ? model.dores : [];
  const headline = assertEditorialSafe(dores[0] || model.nome || model.id);
  return {
    id: model.id,
    nome: model.nome || model.id,
    setor: model.setor || '',
    rank,
    fit_score: model.fit_score || 0,
    headline,
    dor_vetores: dores.map(d => assertEditorialSafe(d)),
  };
}
```

- [ ] **Step 4: Rodar e confirmar passa**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add ACERVO_VANGUARD/js/lib/niche-public.js ACERVO_VANGUARD/js/lib/niche-public.test.mjs
git commit -m "feat(vitrine): toPublicCard — mapeia Niche Model para card público sem vazar campos internos"
```

---

### Task 4: `buildNicheQuiz` — derivar o quiz das dores do nicho

**Files:**
- Modify: `ACERVO_VANGUARD/js/lib/niche-public.js`
- Test: `ACERVO_VANGUARD/js/lib/niche-public.test.mjs`

- [ ] **Step 1: Escrever o teste que falha**

Adicionar:
```javascript
import { buildNicheQuiz } from './niche-public.js';

test('buildNicheQuiz gera uma pergunta de confirmação com 1 opção por dor + opção "outra"', () => {
  const q = buildNicheQuiz(MODEL_FIX);
  assert.equal(typeof q.intro, 'string');
  assert.equal(q.perguntas.length, 1);
  const p = q.perguntas[0];
  assert.equal(p.id, 'dor');
  // 3 dores do fixture + 1 escape "outra"
  assert.equal(p.opcoes.length, 4);
  assert.deepEqual(p.opcoes.map(o => o.value), ['d0', 'd1', 'd2', 'outra']);
  assert.equal(p.opcoes[0].label, MODEL_FIX.dores[0]);
  assert.equal(p.opcoes[3].label, 'Outra situação — quero descrever');
});

test('buildNicheQuiz aplica editorial guard a cada opção', () => {
  const dirty = { ...MODEL_FIX, dores: ['dor limpa', 'dor com robô embutido'] };
  assert.throws(() => buildNicheQuiz(dirty), /editorial/i);
});
```

- [ ] **Step 2: Rodar e confirmar falha**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: FAIL — `buildNicheQuiz is not a function`.

- [ ] **Step 3: Implementação mínima**

Adicionar:
```javascript
export function buildNicheQuiz(model) {
  const dores = Array.isArray(model.dores) ? model.dores : [];
  const opcoes = dores.map((d, i) => ({ value: 'd' + i, label: assertEditorialSafe(d) }));
  opcoes.push({ value: 'outra', label: 'Outra situação — quero descrever' });
  return {
    intro: 'Reconhecemos o seu setor. Qual destes cenários mais pesa hoje?',
    perguntas: [{ id: 'dor', texto: 'Qual desses você reconhece no seu dia a dia?', opcoes }],
  };
}
```

- [ ] **Step 4: Rodar e confirmar passa**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add ACERVO_VANGUARD/js/lib/niche-public.js ACERVO_VANGUARD/js/lib/niche-public.test.mjs
git commit -m "feat(vitrine): buildNicheQuiz — quiz de confirmação derivado das dores do nicho"
```

---

### Task 5: `buildPublicArtifact` — orquestrar o artefato completo

**Files:**
- Modify: `ACERVO_VANGUARD/js/lib/niche-public.js`
- Test: `ACERVO_VANGUARD/js/lib/niche-public.test.mjs`

- [ ] **Step 1: Escrever o teste que falha**

Adicionar:
```javascript
import { buildPublicArtifact } from './niche-public.js';

test('buildPublicArtifact monta artefato com mês, ranking e quiz por nicho', () => {
  const models = [
    MODEL_FIX,
    { id: 'setor-eletrico', nome: 'Setor Elétrico', setor: 'Energia', status: 'MOVER_AGORA', fit_score: 4.5, dores: ['Glosa ANEEL recorrente'] },
    { id: 'ignorado', status: 'MONITORAR', fit_score: 9, dores: ['x'] },
  ];
  const art = buildPublicArtifact(models, '2026-07');
  assert.equal(art.schema, 'vitrine_v1');
  assert.equal(art.generated_for_month, '2026-07');
  assert.equal(art.niches.length, 2);            // MONITORAR fica de fora
  assert.equal(art.niches[0].id, 'compliance-aduaneiro-ncm'); // fit 5 primeiro
  assert.equal(art.niches[0].rank, 1);
  assert.equal(art.niches[1].rank, 2);
  assert.ok(art.niches[0].quiz.perguntas.length === 1);
});
```

- [ ] **Step 2: Rodar e confirmar falha**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: FAIL — `buildPublicArtifact is not a function`.

- [ ] **Step 3: Implementação mínima**

Adicionar:
```javascript
export function buildPublicArtifact(models, month) {
  const selected = selectPublicNiches(models);
  const niches = selected.map((m, i) => {
    const card = toPublicCard(m, i + 1);
    card.quiz = buildNicheQuiz(m);
    return card;
  });
  return { schema: 'vitrine_v1', generated_for_month: month, niches };
}
```

- [ ] **Step 4: Rodar e confirmar passa**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add ACERVO_VANGUARD/js/lib/niche-public.js ACERVO_VANGUARD/js/lib/niche-public.test.mjs
git commit -m "feat(vitrine): buildPublicArtifact — orquestra artefato público com ranking e quiz"
```

---

### Task 6: Gate de data — parse do calendário + decisão de regeneração

**Files:**
- Modify: `ACERVO_VANGUARD/js/lib/niche-public.js`
- Test: `ACERVO_VANGUARD/js/lib/niche-public.test.mjs`

- [ ] **Step 1: Escrever o teste que falha**

Adicionar:
```javascript
import { parseRegenDates, shouldRegenerate } from './niche-public.js';

const CAL_FIX = [
  '| **02/07** | Qui | REGEN_VITRINE_SITE | NORMAL | Regenerar Vitrine pós-NICHE_MODELER |',
  '| **01/07** | Qua | NICHE_MODELER | CRÍTICO | enriquecimento |',
  '| **02/08** | Sáb | REGEN_VITRINE_SITE | NORMAL | idem |',
].join('\n');

test('parseRegenDates extrai só as datas marcadas REGEN_VITRINE_SITE', () => {
  assert.deepEqual(parseRegenDates(CAL_FIX), ['02-07-2026', '02-08-2026']);
});

test('shouldRegenerate libera quando hoje é data de regen e o mês ainda não foi gerado', () => {
  const r = shouldRegenerate({ today: '02-07-2026', regenDates: ['02-07-2026'], lastGeneratedMonth: '2026-06' });
  assert.equal(r.regen, true);
  assert.equal(r.month, '2026-07');
});

test('shouldRegenerate NÃO age fora da data', () => {
  assert.equal(shouldRegenerate({ today: '05-07-2026', regenDates: ['02-07-2026'], lastGeneratedMonth: '2026-06' }).regen, false);
});

test('shouldRegenerate NÃO age se o mês já foi gerado (idempotente)', () => {
  assert.equal(shouldRegenerate({ today: '02-07-2026', regenDates: ['02-07-2026'], lastGeneratedMonth: '2026-07' }).regen, false);
});
```

- [ ] **Step 2: Rodar e confirmar falha**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: FAIL — `parseRegenDates is not a function`.

- [ ] **Step 3: Implementação mínima**

Adicionar:
```javascript
// Datas no formato DD/MM/YYYY (calendário) -> DD-MM-YYYY (chave interna).
export function parseRegenDates(calendarMarkdown) {
  const out = [];
  const re = /(\d{2})\/(\d{2})\/(\d{4})[^\n]*REGEN_VITRINE_SITE/g;
  let m;
  while ((m = re.exec(calendarMarkdown)) !== null) {
    out.push(`${m[1]}-${m[2]}-${m[3]}`);
  }
  return out;
}

function monthKey(ddmmyyyy) {
  const [, mm, yyyy] = ddmmyyyy.split('-');
  return `${yyyy}-${mm}`;
}

export function shouldRegenerate({ today, regenDates, lastGeneratedMonth }) {
  const isRegenDay = Array.isArray(regenDates) && regenDates.includes(today);
  const month = today ? monthKey(today) : null;
  if (!isRegenDay) return { regen: false, month, reason: 'fora-da-data' };
  if (month === lastGeneratedMonth) return { regen: false, month, reason: 'mes-ja-gerado' };
  return { regen: true, month, reason: 'liberado' };
}
```

- [ ] **Step 4: Rodar e confirmar passa**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: PASS (todos).

- [ ] **Step 5: Commit**

```bash
git add ACERVO_VANGUARD/js/lib/niche-public.js ACERVO_VANGUARD/js/lib/niche-public.test.mjs
git commit -m "feat(vitrine): gate de data — parseRegenDates + shouldRegenerate (idempotente por mês)"
```

---

### Task 7: Roteamento de origem — `?nicho=` e gravação do lead

**Files:**
- Modify: `ACERVO_VANGUARD/js/lib/niche-public.js`
- Test: `ACERVO_VANGUARD/js/lib/niche-public.test.mjs`

- [ ] **Step 1: Escrever o teste que falha**

Adicionar:
```javascript
import { resolveEntrada, buildLeadRow } from './niche-public.js';

test('resolveEntrada: sem nicho -> porta orgânica', () => {
  assert.deepEqual(resolveEntrada(''), { porta: 'organica', nicho: null, origem: 'organico' });
  assert.deepEqual(resolveEntrada('?foo=bar'), { porta: 'organica', nicho: null, origem: 'organico' });
});

test('resolveEntrada: com nicho -> porta inteligência + slug saneado', () => {
  assert.deepEqual(resolveEntrada('?nicho=compliance-aduaneiro-ncm'),
    { porta: 'inteligencia', nicho: 'compliance-aduaneiro-ncm', origem: 'vitrine_nicho' });
});

test('resolveEntrada: slug inválido cai para porta orgânica (anti-injeção)', () => {
  assert.equal(resolveEntrada('?nicho=<script>').porta, 'organica');
});

test('buildLeadRow usa origem default organico e aceita override', () => {
  assert.equal(buildLeadRow({ nicho: 'x', gargalo: 'A', nome: 'n', whatsapp: 'w' }).origem, 'organico');
  const r = buildLeadRow({ nicho: 'x', gargalo: 'A', nome: 'n', whatsapp: 'w', origem: 'vitrine_nicho' });
  assert.equal(r.origem, 'vitrine_nicho');
  assert.equal(r.nicho, 'x');
});
```

- [ ] **Step 2: Rodar e confirmar falha**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: FAIL — `resolveEntrada is not a function`.

- [ ] **Step 3: Implementação mínima**

Adicionar:
```javascript
const SLUG_RE = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;

export function resolveEntrada(search) {
  let slug = null;
  try {
    slug = new URLSearchParams(search || '').get('nicho');
  } catch (_) { slug = null; }
  if (slug && SLUG_RE.test(slug)) {
    return { porta: 'inteligencia', nicho: slug, origem: 'vitrine_nicho' };
  }
  return { porta: 'organica', nicho: null, origem: 'organico' };
}

export function buildLeadRow({ nicho, gargalo, nome, whatsapp, metadata, origem }) {
  const row = { nicho, gargalo, nome, whatsapp, origem: origem || 'organico' };
  if (metadata) row.metadata = metadata;
  return row;
}
```

- [ ] **Step 4: Rodar e confirmar passa**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add ACERVO_VANGUARD/js/lib/niche-public.js ACERVO_VANGUARD/js/lib/niche-public.test.mjs
git commit -m "feat(vitrine): resolveEntrada (porta por origem) + buildLeadRow (origem auditável)"
```

---

### Task 8: Gerador Node — ler modelos do disco e escrever o artefato

**Files:**
- Create: `scripts/regen-vitrine-site.mjs`
- Create: `ACERVO_VANGUARD/data/.gitkeep` (garante a pasta)

- [ ] **Step 1: Criar a pasta de destino**

```bash
mkdir -p "ACERVO_VANGUARD/data"
touch "ACERVO_VANGUARD/data/.gitkeep"
```

- [ ] **Step 2: Escrever o gerador**

`scripts/regen-vitrine-site.mjs`:
```javascript
// Gerador da Vitrine. Lê os *_MODEL.json e escreve ACERVO_VANGUARD/data/niches_public.json.
// Uso:
//   node scripts/regen-vitrine-site.mjs            -> gera (força, p/ teste manual)
//   node scripts/regen-vitrine-site.mjs --gate     -> só gera se o gate de data liberar
import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import { buildPublicArtifact, parseRegenDates, shouldRegenerate } from '../ACERVO_VANGUARD/js/lib/niche-public.js';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const MODELS_DIR = join(ROOT, 'PENTALATERAL_UNIVERSAL', 'INTELLIGENCE_HUB', 'NICHE_MODELS');
const CALENDAR = join(ROOT, 'PENTALATERAL_UNIVERSAL', 'INTELLIGENCE_HUB', 'CALENDARIO_NICHE_INTELLIGENCE.md');
const OUT = join(ROOT, 'ACERVO_VANGUARD', 'data', 'niches_public.json');

function loadModels() {
  return readdirSync(MODELS_DIR)
    .filter(f => f.endsWith('_MODEL.json'))
    .map(f => JSON.parse(readFileSync(join(MODELS_DIR, f), 'utf8')));
}

function todayKey() {
  const d = new Date();
  const p = n => String(n).padStart(2, '0');
  return `${p(d.getDate())}-${p(d.getMonth() + 1)}-${d.getFullYear()}`;
}

function currentMonth(existing) {
  try { return JSON.parse(readFileSync(existing, 'utf8')).generated_for_month; }
  catch (_) { return null; }
}

const gateMode = process.argv.includes('--gate');
const today = todayKey();
let month = `${today.split('-')[2]}-${today.split('-')[1]}`;

if (gateMode) {
  const dates = existsSync(CALENDAR) ? parseRegenDates(readFileSync(CALENDAR, 'utf8')) : [];
  const decision = shouldRegenerate({ today, regenDates: dates, lastGeneratedMonth: currentMonth(OUT) });
  if (!decision.regen) {
    console.log(`[regen-vitrine] no-op (${decision.reason}) — hoje ${today}`);
    process.exit(0);
  }
  month = decision.month;
}

const artifact = buildPublicArtifact(loadModels(), month);
writeFileSync(OUT, JSON.stringify(artifact, null, 2) + '\n', 'utf8');
console.log(`[regen-vitrine] ${artifact.niches.length} nichos -> ${OUT} (mês ${month})`);
```

- [ ] **Step 3: Rodar o gerador contra os modelos reais (smoke)**

Run: `node scripts/regen-vitrine-site.mjs`
Expected: imprime `[regen-vitrine] N nichos -> ...` com N ≥ 1; cria `ACERVO_VANGUARD/data/niches_public.json` válido.

- [ ] **Step 4: Validar o artefato gerado**

Run: `node -e "const a=require('./ACERVO_VANGUARD/data/niches_public.json'); if(a.schema!=='vitrine_v1'||!a.niches.length) process.exit(1); console.log('OK', a.niches.length)"`
Expected: `OK N`. (Se algum modelo tiver termo editorial proibido, o gerador lança — corrigir o modelo, não o guard.)

- [ ] **Step 5: Commit**

```bash
git add scripts/regen-vitrine-site.mjs ACERVO_VANGUARD/data/.gitkeep ACERVO_VANGUARD/data/niches_public.json
git commit -m "feat(vitrine): gerador Node do artefato público + primeira geração"
```

---

### Task 9: Calendário — linha datada `REGEN_VITRINE_SITE` (autoridade do gate)

**Files:**
- Modify: `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/CALENDARIO_NICHE_INTELLIGENCE.md`

- [ ] **Step 1: Adicionar a seção da ação datada**

Inserir logo após a seção `## RITMO MENSAL (dia 1 de cada mês)` (depois da linha do `M-STATS`, antes do `---` que a fecha), este bloco:

```markdown
### REGEN_VITRINE_SITE — Vitrine do site (gated, dia 2 — pós-NICHE_MODELER)

> A Vitrine de nichos do site público (`ACERVO_VANGUARD/data/niches_public.json`) é regenerada
> **uma vez por mês, no dia seguinte ao enriquecimento** (NICHE_MODELER de dia 1 produz o `fit_score`/`status`).
> **Não é cron cego:** o gate `scripts/gate_regen_vitrine.ps1` só age na data abaixo e é idempotente por mês.
> Princípio do Diretor (2026-06-21): nenhuma ação de calendário sem sincronização com este calendário.

| Data | Ação | Gate |
|---|---|---|
| **02/07/2026** | REGEN_VITRINE_SITE | libera só em 02/07 e se mês 2026-07 ainda não gerado |
| **02/08/2026** | REGEN_VITRINE_SITE | idem 2026-08 |
| **02/09/2026** | REGEN_VITRINE_SITE | idem 2026-09 |
```

- [ ] **Step 2: Verificar que o parser enxerga as datas**

Run: `node -e "const fs=require('fs');const {parseRegenDates}=require('./ACERVO_VANGUARD/js/lib/niche-public.js')" 2>/dev/null || node --input-type=module -e "import {parseRegenDates} from './ACERVO_VANGUARD/js/lib/niche-public.js'; import {readFileSync} from 'fs'; console.log(parseRegenDates(readFileSync('PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/CALENDARIO_NICHE_INTELLIGENCE.md','utf8')))"`
Expected: `[ '02-07-2026', '02-08-2026', '02-09-2026' ]`.

- [ ] **Step 3: Commit**

```bash
git add PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/CALENDARIO_NICHE_INTELLIGENCE.md
git commit -m "docs(calendario): REGEN_VITRINE_SITE como ação datada gated (dia 2 mensal)"
```

> **Propagação (P-033/P-060):** o `CALENDARIO_NICHE_INTELLIGENCE.md` vive em `PENTALATERAL_UNIVERSAL/`.
> Após o commit, rodar `.\.claude\skills\files\sync_vanguard_docs.ps1` (sincroniza as cópias em `CLIENTES/*/NOTEBOOKLM_FONTES/`). Reportar "Propagação concluída — N arquivos".

---

### Task 10: Gate PS — wrapper de orquestração

**Files:**
- Create: `scripts/gate_regen_vitrine.ps1`

- [ ] **Step 1: Escrever o wrapper**

`scripts/gate_regen_vitrine.ps1`:
```powershell
#Requires -Version 5.1
# gate_regen_vitrine.ps1 -- aciona a regeneração da Vitrine SOMENTE sob o gate de data
# (CALENDARIO_NICHE_INTELLIGENCE.md -> REGEN_VITRINE_SITE). Toda a decisão vive no modulo
# Node (shouldRegenerate, idempotente por mes); este wrapper so orquestra e reporta.
# FAIL-OPEN: erro do gate nunca trava a sessao.
$ErrorActionPreference = 'Stop'
try {
    $root = Split-Path -Parent $PSScriptRoot
    $node = (Get-Command node -ErrorAction SilentlyContinue)
    if (-not $node) { Write-Host '[gate-regen] node ausente -- pulando (manual depois).'; exit 0 }
    Push-Location $root
    try {
        node scripts/regen-vitrine-site.mjs --gate
    } finally { Pop-Location }
    exit 0
}
catch {
    Write-Host "[gate-regen] erro nao-fatal: $($_.Exception.Message)"
    exit 0
}
```

- [ ] **Step 2: Rodar o validador de scripts do repo (P-060)**

Run: `pwsh -NoProfile -File scripts/validate_scripts.ps1 -Path scripts/gate_regen_vitrine.ps1` (ou `powershell` se `pwsh` ausente)
Expected: sem erros de sintaxe. Se `validate_scripts.ps1` não aceitar `-Path`, rodar `powershell -NoProfile -Command "& { . scripts/gate_regen_vitrine.ps1 }"` num dia fora de regen e confirmar `no-op`.

- [ ] **Step 3: Smoke — confirmar no-op fora da data**

Run: `powershell -NoProfile -File scripts/gate_regen_vitrine.ps1`
Expected: `[regen-vitrine] no-op (fora-da-data) — hoje DD-MM-YYYY` (hoje não é dia 2).

- [ ] **Step 4: Commit**

```bash
git add scripts/gate_regen_vitrine.ps1
git commit -m "feat(vitrine): gate_regen_vitrine.ps1 — wrapper PS do gate de data (FAIL-OPEN)"
```

> **Integração ao session_start (FORA DE ESCOPO deste MVP):** não tocar no hook crítico `session_start.ps1` agora. O Músculo roda `gate_regen_vitrine.ps1` quando o `cowork_calendar.ps1` (gate 0B) indicar a data. Plugar ao session_start é iniciativa-irmã, sob veredito próprio.

---

### Task 11: Frontend — Vitrine de nichos (render)

**Files:**
- Create: `ACERVO_VANGUARD/js/vitrine.js`

- [ ] **Step 1: Escrever o módulo de render**

`ACERVO_VANGUARD/js/vitrine.js`:
```javascript
// Vitrine de nichos — fetch do artefato público + render dos cards (hero = rank 1).
// ES module (carregado via <script type="module">). Editorial: o artefato já é guarded
// na geração; aqui só renderiza.
import { } from './lib/niche-public.js'; // marca a dependência de domínio (mesma pasta servida)

async function loadNiches() {
  try {
    const r = await fetch('/data/niches_public.json', { cache: 'no-store' });
    if (!r.ok) return null;
    return await r.json();
  } catch (_) { return null; }
}

function cardHTML(n) {
  const hero = n.rank === 1 ? ' vitrine__card--hero' : '';
  return `<a class="vitrine__card${hero}" href="?nicho=${encodeURIComponent(n.id)}#quiz" data-nicho="${n.id}">
    <span class="vitrine__rank">#${n.rank}</span>
    <h3 class="vitrine__nome">${n.nome}</h3>
    <p class="vitrine__headline">${n.headline}</p>
    <span class="vitrine__cta">Ver diagnóstico do setor →</span>
  </a>`;
}

async function init() {
  const mount = document.getElementById('vitrine-grid');
  if (!mount) return;
  const data = await loadNiches();
  if (!data || !data.niches || !data.niches.length) {
    const sec = document.getElementById('vitrine');
    if (sec) sec.style.display = 'none';   // sem nichos -> esconde a seção (porta orgânica intacta)
    return;
  }
  mount.innerHTML = data.niches.map(cardHTML).join('');
}

if (document.readyState !== 'loading') init();
else document.addEventListener('DOMContentLoaded', init);
```

- [ ] **Step 2: Smoke manual no servidor local**

Run: `node ACERVO_VANGUARD/PWA/server.js` (ou o comando que o `server.js` expõe) e abrir `http://localhost:<porta>/` — confirmar (após Task 13) que a seção Vitrine lista os nichos e o card #1 recebe a classe hero. Sem `niches_public.json` → seção some, quiz orgânico intacto.

- [ ] **Step 3: Commit**

```bash
git add ACERVO_VANGUARD/js/vitrine.js
git commit -m "feat(vitrine): frontend render da Vitrine de nichos (hero = rank 1)"
```

---

### Task 12: Frontend — bridge de origem (`?nicho=` → quiz)

**Files:**
- Create: `ACERVO_VANGUARD/js/niche-quiz-bridge.js`

- [ ] **Step 1: Escrever o bridge**

`ACERVO_VANGUARD/js/niche-quiz-bridge.js`:
```javascript
// Bridge: resolve a porta de entrada a partir da URL e expõe ao quiz.js o slug do nicho +
// a origem do lead. Não toca no fluxo do quiz orgânico — só publica o contexto em window.
import { resolveEntrada } from './lib/niche-public.js';

const entrada = resolveEntrada(window.location.search);
// contrato lido pelo quiz.js no submit:
window.VG_ENTRADA = { nicho: entrada.nicho, origem: entrada.origem, porta: entrada.porta };

// Se veio pela porta inteligência, marca o body para CSS/UX opcional e rola ao quiz.
if (entrada.porta === 'inteligencia') {
  document.documentElement.setAttribute('data-porta', 'inteligencia');
}
```

- [ ] **Step 2: Smoke**

Run: abrir `http://localhost:<porta>/?nicho=compliance-aduaneiro-ncm` no console: `window.VG_ENTRADA`
Expected: `{ nicho: 'compliance-aduaneiro-ncm', origem: 'vitrine_nicho', porta: 'inteligencia' }`. Sem `?nicho=` → `origem: 'organico'`.

- [ ] **Step 3: Commit**

```bash
git add ACERVO_VANGUARD/js/niche-quiz-bridge.js
git commit -m "feat(vitrine): bridge de origem ?nicho= -> window.VG_ENTRADA"
```

---

### Task 13: Instrumentar a métrica-mãe — `supabase.js` + `quiz.js`

**Files:**
- Modify: `ACERVO_VANGUARD/js/supabase.js`
- Modify: `ACERVO_VANGUARD/js/quiz.js:384-407`

- [ ] **Step 1: Permitir `origem` no `saveLeadDiagnostico`**

Em `ACERVO_VANGUARD/js/supabase.js`, trocar o corpo de `saveLeadDiagnostico` para honrar o `origem` recebido (mantendo o default histórico):
```javascript
  async function saveLeadDiagnostico({ nicho, gargalo, nome, whatsapp, metadata, origem }) {
    const row = { nicho, gargalo, nome, whatsapp, origem: origem || 'landing_v18' };
    if (metadata) row.metadata = metadata;
    const { error } = await client
      .from('leads_diagnostico')
      .insert([row]);

    if (error) return { success: false, error: error.message };
    return { success: true };
  }
```

- [ ] **Step 2: Passar origem + slug no payload do quiz**

Em `ACERVO_VANGUARD/js/quiz.js`, dentro de `submitLead()`, ajustar a montagem do `payload` (linhas 384-403). O `nicho` gravado passa a ser o slug da porta inteligência quando houver; senão mantém `state.q1` (setor orgânico). Acrescentar `origem`:
```javascript
    var entrada = window.VG_ENTRADA || { nicho: null, origem: 'organico' };
    var payload = {
      nicho:    entrada.nicho || state.q1,
      gargalo:  getWeakestQuadrant(),
      nome:     state.nome,
      whatsapp: state.whatsapp,
      origem:   entrada.origem,
      metadata: {
        email:        state.email,
        setor_quiz:   state.q1,
        faturamento:  state.q2,
        canal:        state.q3,
        presenca:     state.q4,
        conversao:    state.q5,
        obstaculo:    state.q6,
        historico:    state.q7,
        custo_ads:    state.q8_custo_ads,
        scores:       state.scores,
        revenue_risk: getRevenueRisk(),
        lucro_em_risco: calcLucroEmRisco(state.q8_custo_ads),
        outros_textos:  state.outros_textos,
      },
    };
```
(`setor_quiz` preserva `state.q1` na metadata mesmo quando `nicho` recebe o slug — nada se perde.)

- [ ] **Step 3: Smoke do fluxo de submit**

Run: servidor local; completar o quiz por `/?nicho=compliance-aduaneiro-ncm`; na aba Network confirmar o insert em `leads_diagnostico` com `origem: "vitrine_nicho"` e `nicho: "compliance-aduaneiro-ncm"`. Pela home sem parâmetro: `origem: "organico"`, `nicho: <setor>`.

- [ ] **Step 4: Commit**

```bash
git add ACERVO_VANGUARD/js/supabase.js ACERVO_VANGUARD/js/quiz.js
git commit -m "feat(vitrine): métrica-mãe — origem (vitrine_nicho/organico) + slug do nicho no lead"
```

---

### Task 14: Integração no `index.html` — seção Vitrine + scripts

**Files:**
- Modify: `ACERVO_VANGUARD/PWA/index.html:496` (antes da `<section class="quiz-section" id="quiz">`)
- Modify: `ACERVO_VANGUARD/PWA/index.html:1085-1099` (bloco de `<script>`)

- [ ] **Step 1: Inserir a seção Vitrine antes do quiz**

Imediatamente antes de `<section class="quiz-section" id="quiz" ...>` (linha 496), inserir:
```html
  <!-- VITRINE DE NICHOS — preenchida em runtime por /js/vitrine.js (porta inteligência) -->
  <section class="vitrine" id="vitrine" aria-labelledby="vitrine-title">
    <div class="vitrine__container">
      <h2 class="section__title" id="vitrine-title">Setores em foco neste mês</h2>
      <p class="vitrine__intro">Mapeamos os gargalos críticos de cada setor. Encontre o seu.</p>
      <div class="vitrine__grid" id="vitrine-grid" role="list"></div>
    </div>
  </section>
```

- [ ] **Step 2: Registrar os módulos ES**

No bloco de scripts (após a linha 1088 `/js/quiz.js`), adicionar — como módulos, para o `import` resolver:
```html
  <script type="module" src="/js/niche-quiz-bridge.js?v=27"></script>
  <script type="module" src="/js/vitrine.js?v=27"></script>
```
O `niche-quiz-bridge.js` define `window.VG_ENTRADA` antes do submit; o `quiz.js` (clássico, já carregado) o lê em runtime no clique do botão — ordem de execução garante que o bridge corre no parse do módulo, antes de qualquer submit do usuário.

- [ ] **Step 3: Smoke de regressão do quiz orgânico**

Run: servidor local; abrir `/` SEM parâmetro; completar o quiz inteiro; confirmar que funciona idêntico ao atual (nenhuma regressão) e grava `origem: organico`. Depois abrir `/?nicho=<slug>` e confirmar a porta inteligência.

- [ ] **Step 4: Acessibilidade/UX antes de qualquer deploy**

Antes de marcar pronto: revisar a seção Vitrine com a skill `web-design-guidelines` (contraste dos cards, foco de teclado nos `<a>`, `role="list"`/`listitem`, hero legível). Ajustar o CSS necessário em `assets/css/` seguindo o design system cyber-premium (#0A0A0A / #00F0FF). **Não deployar antes do teste do Diretor.**

- [ ] **Step 5: Commit**

```bash
git add ACERVO_VANGUARD/PWA/index.html
git commit -m "feat(vitrine): integra seção Vitrine + módulos de entrada no index.html"
```

---

### Task 15: Fechamento — full test + nota de deploy

**Files:** nenhum novo (verificação).

- [ ] **Step 1: Rodar a suíte completa do módulo**

Run: `node --test ACERVO_VANGUARD/js/lib/niche-public.test.mjs`
Expected: PASS em todos os testes das Tasks 1-7.

- [ ] **Step 2: Regenerar o artefato e validar**

Run: `node scripts/regen-vitrine-site.mjs` e revalidar (`schema === vitrine_v1`, `niches.length ≥ 1`, nenhum termo editorial proibido).

- [ ] **Step 3: Nota de deploy (NÃO deployar sem veredito)**

O deploy é Hostinger via `.github/workflows/deploy-hostinger.yml` (trigger manual). Confirmar que o workflow inclui `/js/lib/`, `/js/vitrine.js`, `/js/niche-quiz-bridge.js` e `/data/niches_public.json` no upload (e **exclui** `*.test.mjs` e `scripts/`). Ajustar a allow/deny-list do workflow se necessário — em tarefa própria, sob veredito. Build→commit→**teste do Diretor**→aprovação→deploy (gate de deploy, regra do repo).

- [ ] **Step 4: Commit final (se houve ajuste de workflow)**

```bash
git add .github/workflows/deploy-hostinger.yml
git commit -m "chore(vitrine): inclui assets da Vitrine no deploy Hostinger"
```

---

## Self-Review

**Spec coverage:**
- §2 dupla entrada por origem → Tasks 7, 12, 13, 14 (`resolveEntrada`, bridge, `?nicho=`). ✓
- §3 quiz robusto por nicho derivado de `dores[]` → Tasks 4, 8 (`buildNicheQuiz`, gerador). ✓
- §4 Vitrine com hero = nº1 → Tasks 5, 11, 14. ✓
- §5 cadência mensal GATED → Tasks 6, 8, 9, 10 (gate de data + calendário + wrapper). ✓
- §6 editorial/E-4/P-059 → Task 2 (guard testado) + nota em Tasks 13/15 (E-4 fora do site); P-059 respeitado (nichos ≠ cliente). ✓
- §7 métrica-mãe (conversas reais por nicho) → Task 13 (`origem`+`nicho` auditáveis); cruzamento conversa fora do site, declarado. ✓
- §9 três decisões → resolvidas no topo + implementadas. ✓

**Placeholder scan:** sem TBD/TODO; todo step de código traz o código; comandos com saída esperada. ✓

**Type consistency:** `selectPublicNiches`→`toPublicCard`→`buildNicheQuiz`→`buildPublicArtifact` encadeiam; `shouldRegenerate` retorna `{regen, month, reason}` (consumido igual no gerador); `resolveEntrada` retorna `{porta, nicho, origem}` (consumido no bridge e no quiz); `buildLeadRow` espelha o `row` real do `supabase.js`. ✓

**Riscos sinalizados (cirúrgico, P-III):** não toco em `session_start.ps1` (Task 10) nem no deploy workflow sem veredito (Task 15); chaves anon permanecem; guard editorial falha-fechado na geração (modelo sujo → corrige o modelo, não o guard).

---

## Execution Handoff

Plano completo e salvo. **HARD-GATE:** nada deste plano é implementado sem o veredito do Diretor sobre o próprio plano.
