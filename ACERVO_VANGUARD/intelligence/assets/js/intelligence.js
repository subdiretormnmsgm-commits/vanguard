/* ═══════════════════════════════════════════════════════════════════════════
   VANGUARD INTELLIGENCE — Sovereign Glass JS
   Playground + Noise canvas + Stat counters + cURL builder
   ═══════════════════════════════════════════════════════════════════════════ */

const API_BASE = window.location.origin;

// ─── Noise canvas ─────────────────────────────────────────────────────────────
(function initNoise() {
  const canvas = document.getElementById('noise-canvas');
  if (!canvas) return;
  canvas.width  = window.innerWidth;
  canvas.height = window.innerHeight;
  const ctx = canvas.getContext('2d');

  function generateNoise() {
    const imageData = ctx.createImageData(canvas.width, canvas.height);
    const data      = imageData.data;
    for (let i = 0; i < data.length; i += 4) {
      const v    = Math.random() * 255 | 0;
      data[i]    = v;
      data[i+1]  = v;
      data[i+2]  = v;
      data[i+3]  = 12; // very low alpha
    }
    ctx.putImageData(imageData, 0, 0);
    requestAnimationFrame(generateNoise);
  }
  generateNoise();

  window.addEventListener('resize', () => {
    canvas.width  = window.innerWidth;
    canvas.height = window.innerHeight;
  });
})();


// ─── Stat counter animation ───────────────────────────────────────────────────
(function initCounters() {
  const counters = [
    { el: document.getElementById('stat-empresas'), target: 50000, suffix: 'k+',    divisor: 1000, decimals: 0 },
    { el: document.getElementById('stat-nichos'),   target: 12,    suffix: '',        divisor: 1,    decimals: 0 },
    { el: document.getElementById('stat-uptime'),   target: 99.9,  suffix: '%',       divisor: 1,    decimals: 1 },
  ];

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      counters.forEach(({ el, target, suffix, divisor, decimals }) => {
        if (!el) return;
        let start     = 0;
        const step    = target / 60;
        const display = () => {
          start = Math.min(start + step, target);
          const val = divisor > 1
            ? (start / divisor).toFixed(decimals)
            : start.toFixed(decimals);
          el.textContent = val + suffix;
          if (start < target) requestAnimationFrame(display);
        };
        display();
      });
      observer.disconnect();
    });
  }, { threshold: 0.3 });

  const hero = document.querySelector('.hero__stats');
  if (hero) observer.observe(hero);
})();


// ─── Hero terminal cycling ────────────────────────────────────────────────────
(function initTerminalCycle() {
  const totalEl = document.getElementById('t-total');
  if (!totalEl) return;
  const values = [8431, 8444, 8456, 8463, 8471];
  let i = 0;
  setInterval(() => {
    i = (i + 1) % values.length;
    totalEl.textContent = values[i].toLocaleString('pt-BR');
  }, 3000);
})();


// ─── Playground ───────────────────────────────────────────────────────────────
const DEMO_RESPONSES = {
  nichos: {
    nichos: [
      { nicho: 'advocacia',     total_leads: 8431, score_medio: 3.8, leads_alta_qualidade: 1204, pct_com_ia: 71.4 },
      { nicho: 'estetica',      total_leads: 6782, score_medio: 4.2, leads_alta_qualidade: 1103, pct_com_ia: 68.9 },
      { nicho: 'dentista',      total_leads: 5210, score_medio: 5.1, leads_alta_qualidade: 1890, pct_com_ia: 74.2 },
      { nicho: 'contabilidade', total_leads: 4930, score_medio: 3.4, leads_alta_qualidade: 876,  pct_com_ia: 65.1 },
    ],
    total: 4,
    actualizado_em: new Date().toISOString(),
  },
  nicho: (nicho) => ({
    nicho,
    total_empresas: Math.floor(Math.random() * 5000 + 3000),
    score_medio: +(Math.random() * 4 + 2).toFixed(1),
    score_mediana: +(Math.random() * 3 + 2).toFixed(1),
    empresas_qualidade: Math.floor(Math.random() * 1500 + 500),
    pct_com_ia_hook: +(Math.random() * 20 + 60).toFixed(1),
    ultimo_dado_em: new Date(Date.now() - Math.random() * 86400000 * 7).toISOString(),
    referencia_mes: new Date().toISOString().slice(0, 7) + '-01T00:00:00Z',
    insight: `Nicho com maturidade digital moderada — segmento competitivo mas com espaço para diferenciação por especialização.`,
  }),
  tendencias: {
    tendencias: [
      { nicho: 'estetica',  cidade: 'São Paulo',    leads_30d: 340, score_medio: 4.3 },
      { nicho: 'dentista',  cidade: 'Curitiba',     leads_30d: 280, score_medio: 5.2 },
      { nicho: 'advocacia', cidade: 'Rio de Janeiro',leads_30d: 240, score_medio: 3.9 },
      { nicho: 'clinica',   cidade: 'Belo Horizonte',leads_30d: 195, score_medio: 4.7 },
    ],
    total: 4,
    periodo: 'ultimos_30_dias',
    referencia_dia: new Date().toISOString().slice(0, 10),
  },
  cidades: (nicho) => ({
    nicho,
    cidades: [
      { cidade: 'São Paulo',     leads_30d: 340, score_medio: 4.2 },
      { cidade: 'Rio de Janeiro',leads_30d: 210, score_medio: 3.8 },
      { cidade: 'Curitiba',      leads_30d: 156, score_medio: 4.8 },
      { cidade: 'Belo Horizonte',leads_30d: 134, score_medio: 4.1 },
      { cidade: 'Porto Alegre',  leads_30d: 98,  score_medio: 4.5 },
    ],
    total: 5,
    periodo: 'ultimos_30_dias',
  }),
  status: {
    key_prefix:   'vng_live_demo',
    plano:        'free',
    requests_mes: 127,
    limite_mes:   1000,
    restantes:    873,
    pct_usado:    12.7,
    ultimo_uso_em: new Date().toISOString(),
    ativo:        true,
  },
};

function buildCurlExample(endpoint, nicho, top, key) {
  const paths = {
    nichos:     `/v1/intelligence/nichos`,
    nicho:      `/v1/intelligence/nicho/${nicho}`,
    tendencias: `/v1/intelligence/tendencias?nicho=${nicho}`,
    cidades:    `/v1/intelligence/cidades?nicho=${nicho}&top=${top}`,
    status:     `/v1/intelligence/status`,
  };
  const path = paths[endpoint] || '/v1/intelligence/nichos';
  return `curl -X GET "${API_BASE}${path}" \\\n  -H "X-Vanguard-Key: ${key}"`;
}

function syntaxHighlight(json) {
  const str = typeof json === 'string' ? json : JSON.stringify(json, null, 2);
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, (match) => {
      let cls = 'j-number';
      if (/^"/.test(match)) {
        cls = /:$/.test(match) ? 'j-key' : 'j-string';
      } else if (/true|false/.test(match)) {
        cls = 'j-boolean';
      } else if (/null/.test(match)) {
        cls = 'j-null';
      }
      return `<span class="${cls}">${match}</span>`;
    });
}

function updateCurlPreview() {
  const endpoint = document.getElementById('pg-endpoint').value;
  const nicho    = document.getElementById('pg-nicho').value;
  const top      = document.getElementById('pg-top').value;
  const key      = document.getElementById('pg-key').value;
  const curlEl   = document.getElementById('curl-example');
  if (curlEl) curlEl.textContent = buildCurlExample(endpoint, nicho, top, key);

  // Mostrar/ocultar grupos
  const nichoGroup = document.getElementById('pg-nicho-group');
  const topGroup   = document.getElementById('pg-top-group');
  const showNicho  = ['nicho', 'tendencias', 'cidades'].includes(endpoint);
  const showTop    = endpoint === 'cidades';
  if (nichoGroup) nichoGroup.style.display = showNicho ? 'flex' : 'none';
  if (topGroup)   topGroup.style.display   = showTop   ? 'flex' : 'none';
}

function showLoadingState() {
  const output = document.getElementById('pg-output');
  const status = document.getElementById('pg-status');
  const latency = document.getElementById('pg-latency');

  status.textContent  = 'Loading...';
  status.className    = 'output-panel__status status-pending';
  latency.textContent = '';
  output.classList.add('loading');
  output.innerHTML    = '';

  for (let i = 0; i < 8; i++) {
    const line = document.createElement('div');
    line.className = 'skeleton-line';
    line.style.width = (40 + Math.random() * 55) + '%';
    output.appendChild(line);
  }
}

async function executarPlayground() {
  const endpoint = document.getElementById('pg-endpoint').value;
  const nicho    = document.getElementById('pg-nicho').value;
  const key      = document.getElementById('pg-key').value;
  const output   = document.getElementById('pg-output');
  const statusEl = document.getElementById('pg-status');
  const latencyEl= document.getElementById('pg-latency');

  showLoadingState();
  const t0 = Date.now();

  await new Promise(r => setTimeout(r, 600 + Math.random() * 400));

  let data;
  switch (endpoint) {
    case 'nichos':     data = DEMO_RESPONSES.nichos;    break;
    case 'nicho':      data = DEMO_RESPONSES.nicho(nicho); break;
    case 'tendencias': data = DEMO_RESPONSES.tendencias; break;
    case 'cidades':    data = DEMO_RESPONSES.cidades(nicho); break;
    case 'status':     data = DEMO_RESPONSES.status;    break;
    default:           data = { error: 'Endpoint desconhecido' };
  }

  const ms = Date.now() - t0;
  output.classList.remove('loading');
  output.innerHTML    = syntaxHighlight(data);
  statusEl.textContent= '200 OK';
  statusEl.className  = 'output-panel__status status-ok';
  latencyEl.textContent= `${ms}ms`;
}

// ─── Init ─────────────────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  const endpointSel = document.getElementById('pg-endpoint');
  const nichoSel    = document.getElementById('pg-nicho');
  const topInput    = document.getElementById('pg-top');
  const keyInput    = document.getElementById('pg-key');

  if (endpointSel) endpointSel.addEventListener('change', updateCurlPreview);
  if (nichoSel)    nichoSel.addEventListener('change', updateCurlPreview);
  if (topInput)    topInput.addEventListener('input', updateCurlPreview);
  if (keyInput)    keyInput.addEventListener('input', updateCurlPreview);

  updateCurlPreview();

  // Intersection observer para fade-up elements
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.animationPlayState = 'running';
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15 });

  document.querySelectorAll('.endpoint-card, .plan-card, .fingerprint-cell').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(20px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
  });

  // Trigger cards animation on intersect
  const cardObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry, idx) => {
      if (entry.isIntersecting) {
        setTimeout(() => {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
        }, idx * 80);
        cardObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  document.querySelectorAll('.endpoint-card, .plan-card, .fingerprint-cell').forEach(el => {
    cardObserver.observe(el);
  });
});
