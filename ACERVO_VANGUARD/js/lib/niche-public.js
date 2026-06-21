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
  const nome = assertEditorialSafe(model.nome || model.id);
  const headline = assertEditorialSafe(dores[0] || nome);
  return {
    id: model.id,
    nome,
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

export function buildPublicArtifact(models, month, opts = {}) {
  const selected = selectPublicNiches(models);
  const niches = [];
  const excluded = [];
  for (const m of selected) {
    try {
      const card = toPublicCard(m, niches.length + 1);
      card.quiz = buildNicheQuiz(m);
      niches.push(card);
    } catch (err) {
      if (opts.resilient) excluded.push({ id: m.id, reason: err.message });
      else throw err;
    }
  }
  const result = { schema: 'vitrine_v1', generated_for_month: month, niches };
  if (opts.resilient) result.excluded = excluded;
  return result;
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
