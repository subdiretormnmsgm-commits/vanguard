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
  return `<a class="vitrine__card${hero}" href="?nicho=${encodeURIComponent(n.id)}#quiz" data-nicho="${n.id}" role="listitem">
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
