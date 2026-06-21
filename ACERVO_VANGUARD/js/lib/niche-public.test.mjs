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
