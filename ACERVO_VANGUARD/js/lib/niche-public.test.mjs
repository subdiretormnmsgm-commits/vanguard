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
