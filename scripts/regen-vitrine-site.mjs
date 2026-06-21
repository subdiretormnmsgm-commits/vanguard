// Gerador da Vitrine. Lê os *_MODEL.json e escreve ACERVO_VANGUARD/data/niches_public.json.
// FAIL-SOFT por nicho: nicho com termo editorial proibido é EXCLUÍDO + logado (site fica 100%
// editorial-safe sem travar). Os excluídos sinalizam curadoria de copy pública (não editar modelos).
// Uso:
//   node scripts/regen-vitrine-site.mjs            -> gera (força, p/ teste manual)
//   node scripts/regen-vitrine-site.mjs --gate     -> só gera se o gate de data liberar
import { readFileSync, writeFileSync, readdirSync, existsSync, mkdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import { buildPublicArtifact, parseRegenDates, shouldRegenerate } from '../ACERVO_VANGUARD/js/lib/niche-public.js';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const MODELS_DIR = join(ROOT, 'PENTALATERAL_UNIVERSAL', 'INTELLIGENCE_HUB', 'NICHE_MODELS');
const CALENDAR = join(ROOT, 'PENTALATERAL_UNIVERSAL', 'INTELLIGENCE_HUB', 'CALENDARIO_NICHE_INTELLIGENCE.md');
const DATA_DIR = join(ROOT, 'ACERVO_VANGUARD', 'data');
const OUT = join(DATA_DIR, 'niches_public.json');

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

function currentMonth(file) {
  try { return JSON.parse(readFileSync(file, 'utf8')).generated_for_month; }
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

if (!existsSync(DATA_DIR)) mkdirSync(DATA_DIR, { recursive: true });
const result = buildPublicArtifact(loadModels(), month, { resilient: true });

// O `excluded` carrega os termos editoriais proibidos nas mensagens de motivo —
// é metadado de OPERAÇÃO/curadoria, NUNCA pode ir no arquivo servido ao browser
// (vazaria "IA"/"automação" em view-source). Só `niches[]` é público.
const publicArtifact = {
  schema: result.schema,
  generated_for_month: result.generated_for_month,
  niches: result.niches,
};
writeFileSync(OUT, JSON.stringify(publicArtifact, null, 2) + '\n', 'utf8');

if (result.excluded.length) {
  console.log(`[regen-vitrine] EXCLUIDOS por editorial (${result.excluded.length}) — requerem curadoria de copy publica:`);
  for (const e of result.excluded) console.log(`  - ${e.id}: ${e.reason}`);
}
console.log(`[regen-vitrine] ${result.niches.length} nichos publicados -> ${OUT} (mes ${month})`);
