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
