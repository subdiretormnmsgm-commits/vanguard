'use strict';

// ── CONFIG ───────────────────────────────────────────────────────────────
const SUPABASE_URL = window.SUPABASE_URL || 'https://xxxxxxxxxxx.supabase.co';
const SUPABASE_ANON = window.SUPABASE_ANON_KEY || '';
const CERTIFICA_BASE = window.location.origin;

// ── DEMO DATA (fallback when Supabase is not configured) ─────────────────
const DEMO_DB = {
  restauracao: [
    { nome: 'Tasca da Ribeira', cidade: 'Porto', score: 9.4, gargalo: 'Velocidade mobile' },
    { nome: 'A Cozinha do Chef', cidade: 'Lisboa', score: 9.1, gargalo: 'Fotos desactualizadas' },
    { nome: 'Marisqueira Central', cidade: 'Faro', score: 8.7, gargalo: 'Falta de reservas online' },
    { nome: 'Restaurante Saloia',  cidade: 'Sintra', score: 8.3, gargalo: 'SEO local fraco' },
    { nome: 'Taberna do Bairro',   cidade: 'Braga', score: 7.8, gargalo: 'Sem Google Business' },
  ],
  clinica: [
    { nome: 'Clínica Saúde Total', cidade: 'Lisboa', score: 9.6, gargalo: 'Agendamento antigo' },
    { nome: 'Centro Médico Norte',  cidade: 'Porto', score: 9.2, gargalo: 'Sem chat online' },
    { nome: 'Policlínica Alverca',  cidade: 'Alverca', score: 8.5, gargalo: 'Fotos de má qualidade' },
    { nome: 'Dr. Ferreira & Assoc', cidade: 'Coimbra', score: 8.1, gargalo: 'Site não responsivo' },
    { nome: 'Clínica Vida Plena',   cidade: 'Setúbal', score: 7.6, gargalo: 'Ausência de avaliações' },
  ],
  fitness: [
    { nome: 'BodyLab Performance',  cidade: 'Porto', score: 9.5, gargalo: 'App desactualizada' },
    { nome: 'Iron Temple Gym',      cidade: 'Lisboa', score: 9.0, gargalo: 'SEO fora de zona' },
    { nome: 'Studio Move',          cidade: 'Braga', score: 8.8, gargalo: 'Poucas recensões' },
    { nome: 'CrossFit Estoril',     cidade: 'Cascais', score: 8.2, gargalo: 'Preços não visíveis' },
    { nome: 'Gym House',            cidade: 'Évora', score: 7.4, gargalo: 'Site sem HTTPS' },
  ],
  imobiliaria: [
    { nome: 'Imóveis Premium',   cidade: 'Lisboa', score: 9.3, gargalo: 'Tour 3D em falta' },
    { nome: 'Casa Norte',        cidade: 'Porto', score: 9.0, gargalo: 'Leads sem CRM' },
    { nome: 'Real Algarve',      cidade: 'Faro', score: 8.6, gargalo: 'Fotos de baixa res' },
    { nome: 'Habitar Minho',     cidade: 'Braga', score: 8.0, gargalo: 'Sem estimativa online' },
    { nome: 'Propriedades Beira', cidade: 'Coimbra', score: 7.2, gargalo: 'Site desactualizado' },
  ],
  advocacia: [
    { nome: 'Silva & Associados', cidade: 'Lisboa', score: 9.1, gargalo: 'Formulário confuso' },
    { nome: 'Advocacia do Norte',  cidade: 'Porto', score: 8.8, gargalo: 'Sem chat ao vivo' },
    { nome: 'Consultório Jurídico Alves', cidade: 'Coimbra', score: 8.3, gargalo: 'Recensões mistas' },
    { nome: 'Direito & Soluções', cidade: 'Braga', score: 7.9, gargalo: 'Sem testemunhos' },
    { nome: 'Advogada Morais',    cidade: 'Faro', score: 7.1, gargalo: 'Apenas 1 review' },
  ],
};

const NICHO_LABELS = {
  restauracao: 'Restauração',
  clinica:     'Clínica / Saúde',
  fitness:     'Fitness & Bem-Estar',
  imobiliaria: 'Imobiliária',
  advocacia:   'Advocacia',
};

const NIVEL_CONFIG = {
  elite:    { label: 'Elite',    cor: '#F59E0B', min: 9.5 },
  ready:    { label: 'Ready',    cor: '#10B981', min: 9.0 },
  advanced: { label: 'Advanced', cor: '#3B82F6', min: 8.5 },
  emerging: { label: 'Emerging', cor: '#9CA3AF', min: 8.0 },
};

// ── TICKER (duplicate track for seamless loop) ────────────────────────────
function initTicker() {
  const track = document.getElementById('tickerTrack');
  if (!track) return;
  const clone = track.cloneNode(true);
  track.parentElement.appendChild(clone);
}

// ── GRID CANVAS BACKGROUND ────────────────────────────────────────────────
function initGridCanvas() {
  const canvas = document.getElementById('gridCanvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  let w, h;

  function resize() {
    w = canvas.width  = canvas.offsetWidth;
    h = canvas.height = canvas.offsetHeight;
    draw();
  }

  function draw() {
    ctx.clearRect(0, 0, w, h);
    const sz = 56;
    ctx.strokeStyle = 'rgba(197,160,40,0.07)';
    ctx.lineWidth = 1;
    for (let x = 0; x <= w; x += sz) {
      ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, h); ctx.stroke();
    }
    for (let y = 0; y <= h; y += sz) {
      ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(w, y); ctx.stroke();
    }
    // Diagonal accent lines
    ctx.strokeStyle = 'rgba(197,160,40,0.03)';
    ctx.lineWidth = 1;
    for (let i = -h; i <= w + h; i += sz * 3) {
      ctx.beginPath(); ctx.moveTo(i, 0); ctx.lineTo(i + h, h); ctx.stroke();
    }
  }

  window.addEventListener('resize', resize);
  resize();
}

// ── COUNTER ANIMATION ─────────────────────────────────────────────────────
function initCounters() {
  const els = document.querySelectorAll('[data-target]');
  const obs = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (!e.isIntersecting) return;
      const el = e.target;
      const target = parseInt(el.dataset.target, 10);
      const suffix = el.dataset.suffix || '';
      const duration = 1800;
      const start = performance.now();
      function tick(now) {
        const p = Math.min((now - start) / duration, 1);
        const ease = 1 - Math.pow(1 - p, 3);
        el.textContent = Math.round(ease * target).toLocaleString('pt-PT') + suffix;
        if (p < 1) requestAnimationFrame(tick);
      }
      requestAnimationFrame(tick);
      obs.unobserve(el);
    });
  }, { threshold: 0.4 });
  els.forEach(el => obs.observe(el));
}

// ── LEADERBOARD ───────────────────────────────────────────────────────────
let nichoActivo = 'restauracao';

function filtrarNicho(btn, nicho) {
  document.querySelectorAll('.nicho-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  nichoActivo = nicho;
  renderLeaderboard(nicho);
}

function renderLeaderboard(nicho) {
  const lb = document.getElementById('leaderboard');
  const data = DEMO_DB[nicho] || [];
  lb.innerHTML = data.map((e, i) => {
    const scoreClass = e.score >= 9 ? 'lb-score--high' : e.score >= 8 ? 'lb-score--mid' : 'lb-score--low';
    const goldClass = i === 0 ? 'lb-row--gold' : '';
    return `<div class="lb-row ${goldClass}">
      <span class="lb-rank">${i === 0 ? '◆' : '#' + (i + 1)}</span>
      <span class="lb-name">${e.nome}</span>
      <span class="lb-cidade">${e.cidade}</span>
      <span class="lb-score ${scoreClass}">${e.score.toFixed(1)}</span>
    </div>`;
  }).join('');
}

// ── SEARCH ────────────────────────────────────────────────────────────────
document.addEventListener('keydown', e => {
  if (e.key === 'Enter' && document.activeElement.id === 'searchInput') {
    pesquisarEmpresa();
  }
});

async function pesquisarEmpresa() {
  const q = document.getElementById('searchInput').value.trim();
  if (!q) return;

  // Try Supabase first
  if (SUPABASE_ANON && SUPABASE_URL.includes('.supabase.co')) {
    try {
      const r = await fetch(
        `${SUPABASE_URL}/rest/v1/leads_diagnostico?select=empresa_nome,empresa_cidade,nicho,score_digital,gargalo_principal&empresa_nome=ilike.*${encodeURIComponent(q)}*&limit=1`,
        { headers: { apikey: SUPABASE_ANON, Authorization: `Bearer ${SUPABASE_ANON}` } }
      );
      const data = await r.json();
      if (data && data.length > 0) {
        exibirResultado(data[0]);
        return;
      }
    } catch (_) { /* fall through to demo */ }
  }

  // Demo mode: search across all nicho data
  const qL = q.toLowerCase();
  let found = null;
  for (const [nicho, entries] of Object.entries(DEMO_DB)) {
    const match = entries.find(e =>
      e.nome.toLowerCase().includes(qL) ||
      e.cidade.toLowerCase().includes(qL) ||
      nicho.includes(qL) || NICHO_LABELS[nicho]?.toLowerCase().includes(qL)
    );
    if (match) { found = { ...match, nicho }; break; }
  }

  if (!found) {
    // Generate plausible demo result
    const nomes = q.split(' ');
    found = {
      nome: q,
      cidade: 'Lisboa',
      nicho: 'restauracao',
      score: +(6.5 + Math.random() * 3).toFixed(1),
      gargalo: 'Presença digital incompleta',
    };
  }

  exibirResultado(found);
}

function determinarNivel(score) {
  if (score >= 9.5) return 'elite';
  if (score >= 9.0) return 'ready';
  if (score >= 8.5) return 'advanced';
  if (score >= 8.0) return 'emerging';
  return null;
}

function exibirResultado(empresa) {
  const score   = parseFloat(empresa.score_digital ?? empresa.score ?? 0);
  const nicho   = empresa.nicho || 'geral';
  const cidade  = empresa.empresa_cidade ?? empresa.cidade ?? '—';
  const gargalo = empresa.gargalo_principal ?? empresa.gargalo ?? 'Análise em curso';
  const nivel   = determinarNivel(score);

  // Show section
  const sec = document.getElementById('resultSection');
  sec.style.display = 'block';
  sec.scrollIntoView({ behavior: 'smooth', block: 'start' });

  // Header
  document.getElementById('resultNicho').textContent  = NICHO_LABELS[nicho] ?? nicho;
  document.getElementById('resultCidade').textContent = cidade;

  // Status badge
  const statusEl = document.getElementById('resultStatus');
  if (nivel) {
    const cfg = NIVEL_CONFIG[nivel];
    statusEl.innerHTML = `<span class="status-badge status-badge--${nivel}">${cfg.label}</span>`;
  } else {
    statusEl.innerHTML = `<span class="status-badge" style="background:rgba(255,78,78,0.1);color:#FF4E4E;border:1px solid rgba(255,78,78,0.3)">Em Desenvolvimento</span>`;
  }

  // Gauge
  animateGauge(score);

  // Level label
  const levelEl = document.getElementById('gaugeLevel');
  levelEl.textContent = nivel ? NIVEL_CONFIG[nivel].label : '—';
  levelEl.style.color = nivel ? NIVEL_CONFIG[nivel].cor : '#9CA3AF';

  // Breakdown bars (randomised around score)
  animateBreakdownBars(score);

  // Percentil
  const percentil = Math.min(Math.round(score * 10), 100);
  animatePercentil(percentil);

  const ptxt = document.getElementById('percentilText');
  if (percentil >= 95) ptxt.textContent = `Top 5% do mercado — desempenho excepcional.`;
  else if (percentil >= 80) ptxt.textContent = `Top ${100 - percentil}% do sector — acima da média.`;
  else if (percentil >= 60) ptxt.textContent = `Posição mediana — oportunidade de crescimento significativa.`;
  else ptxt.textContent = `Abaixo da média do sector — diagnóstico completo recomendado.`;

  // Gargalo
  document.getElementById('gargaloText').textContent = gargalo;

  // Certificação CTA
  const certPrompt = document.getElementById('certPrompt');
  if (nivel) {
    certPrompt.style.display = 'block';
  } else {
    certPrompt.style.display = 'none';
  }

  // Embed (only if eligible)
  const embedSec = document.getElementById('embedSection');
  if (nivel) {
    embedSec.style.display = 'block';
    const token = 'demo_' + Math.random().toString(36).slice(2, 10);
    const badgeUrl = `${CERTIFICA_BASE}/certifica/badge/${token}.svg`;
    const verifyUrl = `${CERTIFICA_BASE}/certifica/verificar/${token}`;
    document.getElementById('embedPreview').innerHTML =
      `<a href="${verifyUrl}" target="_blank"><img src="${badgeUrl}" alt="Vanguard Score™ Badge" style="height:80px;border-radius:8px;opacity:0.5;filter:grayscale(0.5)"></a>`;
    document.getElementById('embedCode').textContent =
      `<a href="${verifyUrl}" target="_blank"><img src="${badgeUrl}" alt="Vanguard Score™ ${score}" height="80"></a>`;
  } else {
    embedSec.style.display = 'none';
  }
}

function animateGauge(score) {
  const maxDash = 283; // semicircle perimeter ≈ π × r = π × 90
  const fill = document.getElementById('gaugeFill');
  const scoreEl = document.getElementById('gaugeScore');

  // Animate number
  const duration = 1400;
  const start = performance.now();
  function tick(now) {
    const p = Math.min((now - start) / duration, 1);
    const ease = 1 - Math.pow(1 - p, 3);
    const cur = ease * score;
    scoreEl.textContent = cur.toFixed(1);
    fill.style.strokeDashoffset = maxDash - (maxDash * (cur / 10));
    if (p < 1) requestAnimationFrame(tick);
  }
  requestAnimationFrame(tick);
}

function animateBreakdownBars(score) {
  const bars = document.querySelectorAll('.bar-row');
  const labels = ['Presença Digital', 'Reputação Online', 'Velocidade Web', 'SEO Local', 'Conversão'];
  const base = score * 10; // convert to %
  bars.forEach((row, i) => {
    const variance = (Math.random() - 0.5) * 20;
    const pct = Math.min(Math.max(Math.round(base + variance), 20), 100);
    const fill = row.querySelector('.bar-row__fill');
    const val  = row.querySelector('.bar-row__val');
    row.querySelector('.bar-row__label').textContent = labels[i];
    setTimeout(() => {
      fill.style.width = pct + '%';
      val.textContent  = pct + '%';
    }, i * 100);
  });
}

function animatePercentil(pct) {
  setTimeout(() => {
    document.getElementById('percentilFill').style.width  = pct + '%';
    document.getElementById('percentilMarker').style.left = pct + '%';
  }, 200);
}

// ── EMBED COPY ────────────────────────────────────────────────────────────
function copiarEmbed() {
  const code = document.getElementById('embedCode').textContent;
  navigator.clipboard.writeText(code).then(() => {
    const btn = document.querySelector('.embed-copy-btn');
    btn.textContent = 'Copiado ✓';
    setTimeout(() => { btn.textContent = 'Copiar'; }, 2000);
  });
}

// ── INIT ─────────────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  initTicker();
  initGridCanvas();
  initCounters();
  renderLeaderboard('restauracao');
});
