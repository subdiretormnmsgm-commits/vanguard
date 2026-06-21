// Módulo puro de transformação Niche Model -> artefato público da Vitrine.
// Consumido por: gerador Node, frontend (browser type=module) e testes (node --test).
// Sem I/O, sem DOM — só dados.

export function selectPublicNiches(models) {
  if (!Array.isArray(models)) return [];
  return models
    .filter(m => m && m.status === 'MOVER_AGORA')
    .sort((a, b) => (b.fit_score || 0) - (a.fit_score || 0));
}

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
    const b = normalize(banned).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const re = new RegExp('(^|[^a-z0-9])' + b + '($|[^a-z0-9])');
    if (re.test(norm)) {
      throw new Error(`Violação editorial: termo proibido "${banned}" em "${text}"`);
    }
  }
  return text;
}

// Stubs temporários — serão implementados nas funções seguintes
export function toPublicCard(model, rank) { return {}; }
export function buildNicheQuiz(model) { return {}; }
export function buildPublicArtifact(models, month) { return {}; }
export function parseRegenDates(calendarMarkdown) { return []; }
export function shouldRegenerate(opts) { return { regen: false }; }
export function resolveEntrada(search) { return { porta: 'organica', nicho: null, origem: 'organico' }; }
export function buildLeadRow(opts) { return {}; }
