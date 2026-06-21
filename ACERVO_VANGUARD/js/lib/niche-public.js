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

export function buildNicheQuiz(model) {
  const dores = Array.isArray(model.dores) ? model.dores : [];
  const opcoes = dores.map((d, i) => ({ value: 'd' + i, label: assertEditorialSafe(d) }));
  opcoes.push({ value: 'outra', label: 'Outra situação — quero descrever' });
  return {
    intro: 'Reconhecemos o seu setor. Qual destes cenários mais pesa hoje?',
    perguntas: [{ id: 'dor', texto: 'Qual desses você reconhece no seu dia a dia?', opcoes }],
  };
}

export function buildPublicArtifact(models, month) {
  const selected = selectPublicNiches(models);
  const niches = selected.map((m, i) => {
    const card = toPublicCard(m, i + 1);
    card.quiz = buildNicheQuiz(m);
    return card;
  });
  return { schema: 'vitrine_v1', generated_for_month: month, niches };
}

// Datas DD/MM/YYYY (calendário) -> DD-MM-YYYY (chave interna).
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

// Stubs temporários — serão implementados nas funções seguintes
export function resolveEntrada(search) { return { porta: 'organica', nicho: null, origem: 'organico' }; }
export function buildLeadRow(opts) { return {}; }
