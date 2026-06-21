// Módulo puro de transformação Niche Model -> artefato público da Vitrine.
// Consumido por: gerador Node, frontend (browser type=module) e testes (node --test).
// Sem I/O, sem DOM — só dados.

export function selectPublicNiches(models) {
  if (!Array.isArray(models)) return [];
  return models
    .filter(m => m && m.status === 'MOVER_AGORA')
    .sort((a, b) => (b.fit_score || 0) - (a.fit_score || 0));
}

// Stubs temporários — serão implementados nas funções seguintes
export const EDITORIAL_BANNED = [];
export function assertEditorialSafe(text) { return text; }
export function toPublicCard(model, rank) { return {}; }
export function buildNicheQuiz(model) { return {}; }
export function buildPublicArtifact(models, month) { return {}; }
export function parseRegenDates(calendarMarkdown) { return []; }
export function shouldRegenerate(opts) { return { regen: false }; }
export function resolveEntrada(search) { return { porta: 'organica', nicho: null, origem: 'organico' }; }
export function buildLeadRow(opts) { return {}; }
