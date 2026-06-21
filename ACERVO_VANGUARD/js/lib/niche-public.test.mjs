import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  selectPublicNiches, assertEditorialSafe, EDITORIAL_BANNED,
  toPublicCard, buildNicheQuiz, buildPublicArtifact,
  parseRegenDates, shouldRegenerate, resolveEntrada, buildLeadRow,
} from './niche-public.js';

// --- Função 1: selectPublicNiches
test('selectPublicNiches mantém só MOVER_AGORA e ordena por fit_score desc', () => {
  const models = [
    { id: 'a', status: 'MONITORAR', fit_score: 5 },
    { id: 'b', status: 'MOVER_AGORA', fit_score: 4.2 },
    { id: 'c', status: 'MOVER_AGORA', fit_score: 5 },
    { id: 'd', status: 'ARQUIVAR', fit_score: 5 },
  ];
  assert.deepEqual(selectPublicNiches(models).map(m => m.id), ['c', 'b']);
});
test('selectPublicNiches retorna [] para entrada vazia ou nula', () => {
  assert.deepEqual(selectPublicNiches([]), []);
  assert.deepEqual(selectPublicNiches(null), []);
});

// --- Função 2: editorial guard
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
// IMPORTANTE: "guia" não pode casar "ia" — fronteira de palavra obrigatória
test('assertEditorialSafe não dá falso-positivo em substring (guia, viagem)', () => {
  assert.equal(assertEditorialSafe('Guia de viagem corporativa'), 'Guia de viagem corporativa');
});

// --- Função 3: toPublicCard
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

// --- Função 4: buildNicheQuiz
test('buildNicheQuiz gera 1 pergunta de confirmação com 1 opção por dor + opção "outra"', () => {
  const q = buildNicheQuiz(MODEL_FIX);
  assert.equal(typeof q.intro, 'string');
  assert.equal(q.perguntas.length, 1);
  const p = q.perguntas[0];
  assert.equal(p.id, 'dor');
  assert.equal(p.opcoes.length, 4);
  assert.deepEqual(p.opcoes.map(o => o.value), ['d0', 'd1', 'd2', 'outra']);
  assert.equal(p.opcoes[0].label, MODEL_FIX.dores[0]);
  assert.equal(p.opcoes[3].label, 'Outra situação — quero descrever');
});
test('buildNicheQuiz aplica editorial guard a cada opção', () => {
  const dirty = { ...MODEL_FIX, dores: ['dor limpa', 'dor com robô embutido'] };
  assert.throws(() => buildNicheQuiz(dirty), /editorial/i);
});

// --- Função 5: buildPublicArtifact
test('buildPublicArtifact monta artefato com mês, ranking e quiz por nicho', () => {
  const models = [
    MODEL_FIX,
    { id: 'setor-eletrico', nome: 'Setor Elétrico', setor: 'Energia', status: 'MOVER_AGORA', fit_score: 4.5, dores: ['Glosa ANEEL recorrente'] },
    { id: 'ignorado', status: 'MONITORAR', fit_score: 9, dores: ['x'] },
  ];
  const art = buildPublicArtifact(models, '2026-07');
  assert.equal(art.schema, 'vitrine_v1');
  assert.equal(art.generated_for_month, '2026-07');
  assert.equal(art.niches.length, 2);
  assert.equal(art.niches[0].id, 'compliance-aduaneiro-ncm');
  assert.equal(art.niches[0].rank, 1);
  assert.equal(art.niches[1].rank, 2);
  assert.equal(art.niches[0].quiz.perguntas.length, 1);
});

// --- Função 6: gate de data
// Datas com ano de 4 dígitos (formato P-069 DD/MM/YYYY) — calendário real sempre tem ano.
const CAL_FIX = [
  '| **02/07/2026** | Qui | REGEN_VITRINE_SITE | NORMAL | Regenerar Vitrine pós-NICHE_MODELER |',
  '| **01/07/2026** | Qua | NICHE_MODELER | CRÍTICO | enriquecimento |',
  '| **02/08/2026** | Sáb | REGEN_VITRINE_SITE | NORMAL | idem |',
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

// --- Função 7: roteamento de origem + lead row
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
